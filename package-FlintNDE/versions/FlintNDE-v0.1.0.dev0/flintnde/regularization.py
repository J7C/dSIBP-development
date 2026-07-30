"""正规化参数的幂级数解重构。

本模块在多个固定、非零 regulator 样本上复用 ``transport_path_refined``，随后用
FLINT Acb 方阵插值重构最终解矢量的连续 Laurent 系数。自动样本数、样本尺度和
工作精度采用 AMFlow 2.0 的经验公式；最低幂 pilot、独立验证和失败门禁由本程序包
补充。模块不对奇点局部解做多项式回归，也不引入 python-flint 之外的运行依赖。

实现思路：先用嵌套小参数样本判定最低整数幂，再生成带高阶截断缓冲的生产网格；
每个样本完整调用同一 NDE 主线，最后在未参与插值的更小尺度上验证返回级数。
"""

from __future__ import annotations

import math
import statistics
from dataclasses import dataclass, replace
from decimal import Decimal, localcontext
from fractions import Fraction
from pathlib import Path
from typing import Any, Callable

from flint import acb, acb_mat, arb, fmpq

from .boundary import FrobeniusBoundary, frobenius_boundary
from .core import column_vector, configure_working_precision, exact_rational, vector_norm_inf
from .singularities import RationalMatrixSystem
from .systems import AnalyticMatrixSystem
from .transport import transport_path_refined


AUTOMATIC = "automatic"
MatrixSystem = AnalyticMatrixSystem | RationalMatrixSystem


class LeadingPowerDetectionError(ValueError):
    """表示 pilot 样本不能稳定确定共同的最低整数幂。"""


class SeriesValidationError(ValueError):
    """表示 NDE refinement 或独立 regulator 样本未达到目标精度。"""


@dataclass(frozen=True)
class SeriesReconstructionResult:
    """保存返回系数、实际样本、有效参数和全部验证诊断。

    ``coefficients[index]`` 对应 ``powers[index]``，每个系数都是与 NDE 解同维的
    Acb 列向量。``sample_values`` 是生产样本处的完整 NDE 终点值，不包含 pilot。
    """

    series_parameter: str
    powers: tuple[int, ...]
    coefficients: tuple[acb_mat, ...]
    leading_power: int
    maximum_power: int
    internal_maximum_power: int
    sample_points: tuple[acb, ...]
    sample_values: tuple[acb_mat, ...]
    validation_points: tuple[acb, ...]
    validation_values: tuple[acb_mat, ...]
    effective_parameters: dict[str, Any]
    diagnostics: dict[str, Any]
    output_file: str | None = None

    def coefficient(self, power: int) -> acb_mat:
        """返回指定幂的系数列向量；超出用户请求范围时拒绝。"""

        if power < self.leading_power or power > self.maximum_power:
            raise KeyError(
                f"power {power} is outside [{self.leading_power}, {self.maximum_power}]"
            )
        return acb_mat(self.coefficients[power - self.leading_power])

    def evaluate(self, point: Any) -> acb_mat:
        """在非零 regulator 点计算已经截断到 ``maximum_power`` 的返回级数。"""

        regulator = point if isinstance(point, acb) else acb(point)
        if regulator.is_zero() or abs(regulator).contains(0):
            raise ValueError("series evaluation requires a definitely nonzero regulator")
        value = acb_mat(self.coefficients[-1])
        for coefficient in reversed(self.coefficients[:-1]):
            value = value * regulator + coefficient
        return value * (regulator**self.leading_power)

    def to_summary(self) -> dict[str, Any]:
        """返回可直接写入 JSON 的稳定摘要。"""

        return {
            "schema": "flintnde_series_reconstruction_v1",
            "series_parameter": self.series_parameter,
            "leading_power": self.leading_power,
            "maximum_power": self.maximum_power,
            "internal_maximum_power": self.internal_maximum_power,
            "sample_points": [point.str(50) for point in self.sample_points],
            "validation_points": [point.str(50) for point in self.validation_points],
            "coefficients": {
                str(power): _vector_to_strings(coefficient)
                for power, coefficient in zip(self.powers, self.coefficients)
            },
            "sample_values": [
                _vector_to_strings(value) for value in self.sample_values
            ],
            "validation_values": [
                _vector_to_strings(value) for value in self.validation_values
            ],
            "effective_parameters": self.effective_parameters,
            "diagnostics": self.diagnostics,
            "output_file": self.output_file,
        }


@dataclass(frozen=True)
class _ReconstructionPlan:
    """保存内部生产/验证点以及已经解析的 NDE 数值设置。"""

    sample_arguments: tuple[Any, ...]
    sample_points: tuple[acb, ...]
    validation_arguments: tuple[Any, ...]
    validation_points: tuple[acb, ...]
    sample_count: int
    base_sample: str
    alpha_epsilon: float
    base_precision_digits: int
    working_precision_digits: int
    transport_order: int
    transport_extra_order: int
    transport_sample_count: int | None
    transport_extra_sample_count: int | None
    source: str


def _vector_to_strings(vector: acb_mat) -> list[str]:
    """把 Acb 列向量转换为不降到 binary64 的字符串列表。"""

    return [vector[row, 0].str(50) for row in range(vector.nrows())]


def _require_integer(value: Any, name: str, *, minimum: int) -> int:
    """验证非布尔整数及其下界。"""

    if isinstance(value, bool) or not isinstance(value, int) or value < minimum:
        raise ValueError(f"{name} must be an integer >= {minimum}")
    return value


def _require_automatic_or_integer(value: Any, name: str, *, minimum: int) -> int | None:
    """把字面量 ``automatic`` 解析为 ``None``，否则验证整数。"""

    if value == AUTOMATIC:
        return None
    return _require_integer(value, name, minimum=minimum)


def _fraction_from_decimal_control(value: Any, name: str) -> Fraction:
    """把采样比例控制量转为精确十进制分数。"""

    try:
        result = Fraction(str(value))
    except (ValueError, ZeroDivisionError) as error:
        raise ValueError(f"{name} must be a finite real number") from error
    return result


def _sample_pair(value: Any, *, rationalize: bool, name: str) -> tuple[Any, acb]:
    """同时保留工厂所需 exact 参数和插值所需 Acb 点。

    自动或显式有理实数以 ``fmpq`` 传给 ``DEmatrix(ep)``；Acb 点保持数值输入。
    Python float/complex 会丢失用户声称的高精度，因此显式拒绝并要求字符串或 Acb。
    """

    if isinstance(value, bool) or isinstance(value, (float, complex)):
        raise TypeError(f"{name} must use an exact string/fmpq or an acb value, not float/complex")
    if isinstance(value, acb):
        point = acb(value)
        if point.is_zero() or abs(point).contains(0):
            raise ValueError(f"{name} must be definitely nonzero")
        return point, point
    if rationalize:
        try:
            exact = exact_rational(value)
        except ValueError as error:
            raise TypeError(f"{name} must be an exact real scalar or acb") from error
        if exact == 0:
            raise ValueError(f"{name} must be nonzero")
        return exact, acb(exact)
    try:
        point = acb(str(value))
    except (TypeError, ValueError) as error:
        raise TypeError(f"{name} cannot be converted to acb") from error
    if point.is_zero() or abs(point).contains(0):
        raise ValueError(f"{name} must be definitely nonzero")
    return point, point


def _power_of_ten_fraction(exponent: Decimal, precision: int) -> Fraction:
    """在受控十进制精度下计算 ``10**exponent`` 并转为 exact rational。"""

    with localcontext() as decimal_context:
        decimal_context.prec = max(50, precision)
        value = Decimal(10) ** exponent
    return Fraction(str(value))


def _automatic_grid(
    base: Fraction,
    count: int,
    spacing: Fraction,
    *,
    rationalize: bool,
) -> tuple[tuple[Any, ...], tuple[acb, ...]]:
    """生成 AMFlow 式网格；按选项以 fmpq 或 Acb 传入用户工厂。"""

    arguments: list[fmpq] = []
    points: list[acb] = []
    for index in range(1, count + 1):
        value = base * (Fraction(1) + index * spacing)
        if rationalize:
            argument = fmpq(value.numerator, value.denominator)
        else:
            argument = acb(value.numerator) / acb(value.denominator)
        arguments.append(argument)
        points.append(acb(argument))
    return tuple(arguments), tuple(points)


def _point_alpha(points: tuple[acb, ...]) -> float:
    """由最大生产样本模估计 ``-log10(r)``，供自定义网格精度规划。"""

    log_magnitudes = [float(abs(point).log().mid()) / math.log(10) for point in points]
    return max(0.0, -max(log_magnitudes))


def _scaled_validation_points(
    sample_arguments: tuple[Any, ...],
    count: int,
    scale: Fraction,
) -> tuple[tuple[Any, ...], tuple[acb, ...]]:
    """从生产网格前部生成未参与插值的更小尺度验证点。"""

    arguments: list[Any] = []
    points: list[acb] = []
    exact_scale = fmpq(scale.numerator, scale.denominator)
    for argument in sample_arguments[:count]:
        if isinstance(argument, fmpq):
            value = argument * exact_scale
        else:
            value = acb(argument) * acb(exact_scale)
        if any(abs(acb(value) - existing).contains(0) for existing in points):
            raise ValueError("validation grid contains duplicate points")
        arguments.append(value)
        points.append(acb(value))
    return tuple(arguments), tuple(points)


def _resolve_plan(
    *,
    leading_power: int,
    maximum_power: int,
    goal_digits: int,
    sample_points: Any,
    sample_count: Any,
    base_sample: Any,
    sample_spacing: Any,
    working_precision_digits: Any,
    extra_working_precision: float,
    transport_order: Any,
    transport_extra_order: Any,
    transport_sample_count: Any,
    transport_extra_sample_count: Any,
    validation_sample_count: int,
    validation_scale: Any,
    maximum_samples: int,
    rationalize_sample_points: bool,
) -> _ReconstructionPlan:
    """解析生产网格、AMFlow 式精度以及底层 NDE 阶数。"""

    pole_depth = max(0, -leading_power)
    reconstruction_depth = maximum_power - leading_power
    if reconstruction_depth < 0:
        raise ValueError("maximum_power must not be below the detected leading_power")
    automatic_count = max(
        math.ceil(2.5 * reconstruction_depth + pole_depth),
        reconstruction_depth + 1,
    )
    resolved_count = _require_automatic_or_integer(
        sample_count, "sample_count", minimum=reconstruction_depth + 1
    )

    if sample_points == AUTOMATIC:
        count = automatic_count if resolved_count is None else resolved_count
        if count > maximum_samples:
            raise ValueError(
                f"automatic production needs {count} samples, above maximum_samples={maximum_samples}"
            )
        alpha_decimal = Decimal(pole_depth) / Decimal(4) + Decimal(goal_digits) / Decimal(
            reconstruction_depth + 1
        )
        if base_sample == AUTOMATIC:
            base_fraction = _power_of_ten_fraction(
                -alpha_decimal, goal_digits + 30
            )
        else:
            base_fraction = _fraction_from_decimal_control(base_sample, "base_sample")
        if base_fraction <= 0:
            raise ValueError("base_sample must be positive")
        spacing = _fraction_from_decimal_control(sample_spacing, "sample_spacing")
        if spacing <= 0:
            raise ValueError("sample_spacing must be positive")
        arguments, points = _automatic_grid(
            base_fraction,
            count,
            spacing,
            rationalize=rationalize_sample_points,
        )
        alpha = float(alpha_decimal) if base_sample == AUTOMATIC else _point_alpha(points)
        source = "automatic"
        base_label = str(base_fraction)
    else:
        if base_sample != AUTOMATIC:
            raise ValueError("base_sample cannot be combined with explicit sample_points")
        if not isinstance(sample_points, (list, tuple)) or not sample_points:
            raise TypeError('sample_points must be "automatic" or a nonempty sequence')
        pairs = tuple(
            _sample_pair(
                value,
                rationalize=rationalize_sample_points,
                name=f"sample_points[{index}]",
            )
            for index, value in enumerate(sample_points)
        )
        arguments = tuple(pair[0] for pair in pairs)
        points = tuple(pair[1] for pair in pairs)
        count = len(points)
        if resolved_count is not None and resolved_count != count:
            raise ValueError("sample_count must equal the explicit sample_points length")
        if count < reconstruction_depth + 1:
            raise ValueError("explicit sample_points do not cover the requested powers")
        if count > maximum_samples:
            raise ValueError("explicit sample_points exceed maximum_samples")
        for index, point in enumerate(points):
            if any(abs(point - previous).contains(0) for previous in points[:index]):
                raise ValueError("sample_points must be distinct")
        alpha = _point_alpha(points)
        source = "user"
        base_label = "user-supplied"

    base_precision = max(math.ceil((count + pole_depth) * alpha), 30)
    resolved_precision = _require_automatic_or_integer(
        working_precision_digits, "working_precision_digits", minimum=1
    )
    precision = resolved_precision or math.ceil(
        2 * (1 + extra_working_precision) * base_precision
    )
    resolved_order = _require_automatic_or_integer(
        transport_order, "transport_order", minimum=1
    )
    primary_order = resolved_order or 4 * base_precision
    resolved_extra_order = _require_automatic_or_integer(
        transport_extra_order, "transport_extra_order", minimum=1
    )
    extra_order = resolved_extra_order or math.ceil(max(50, base_precision / 5))
    primary_samples = _require_automatic_or_integer(
        transport_sample_count, "transport_sample_count", minimum=primary_order + 1
    )
    reference_order = primary_order + extra_order
    reference_samples = _require_automatic_or_integer(
        transport_extra_sample_count,
        "transport_extra_sample_count",
        minimum=reference_order + 1,
    )
    scale = _fraction_from_decimal_control(validation_scale, "validation_scale")
    if not 0 < scale < 1:
        raise ValueError("validation_scale must lie strictly between zero and one")
    validation_arguments, validation_points = _scaled_validation_points(
        arguments, validation_sample_count, scale
    )
    production_set = points
    if any(
        abs(validation_point - production_point).contains(0)
        for validation_point in validation_points
        for production_point in production_set
    ):
        raise ValueError("validation points must be distinct from production points")

    return _ReconstructionPlan(
        arguments,
        points,
        validation_arguments,
        validation_points,
        count,
        base_label,
        alpha,
        base_precision,
        precision,
        primary_order,
        extra_order,
        primary_samples,
        reference_samples,
        source,
    )


def _resolve_matrix_system(DEmatrix: Any, sample: Any) -> MatrixSystem:
    """在一个 regulator 样本上解析固定系统或 ``DEmatrix(ep)`` 工厂。"""

    system = DEmatrix(sample) if callable(DEmatrix) else DEmatrix
    if not isinstance(system, (AnalyticMatrixSystem, RationalMatrixSystem)):
        raise TypeError(
            "DEmatrix must be an AnalyticMatrixSystem/RationalMatrixSystem or ep -> system"
        )
    return system


def _resolve_boundary(
    boundary: Any, sample: Any, path: list[acb]
) -> acb_mat | FrobeniusBoundary:
    """按路径起点解析普通列向量或 exact ``{a,b,C}`` 边界。"""

    value = boundary(sample) if callable(boundary) else boundary
    start_classification = getattr(path, "start_classification", None)
    if start_classification is not None and start_classification.kind != "ordinary":
        return frobenius_boundary(value)
    if isinstance(value, acb_mat):
        vector = acb_mat(value)
    elif isinstance(value, (list, tuple)):
        if value and isinstance(value[0], (dict, FrobeniusBoundary)):
            raise TypeError("{a,b,C} boundary requires a regular-singular path start")
        vector = column_vector(list(value))
    else:
        raise TypeError(
            "ordinary boundary must be an acb_mat/list; singular boundary must use {a,b,C}"
        )
    if vector.ncols() != 1:
        raise ValueError("boundary must be a column vector")
    return vector


def _resolve_path(path: Any, sample: Any, system: MatrixSystem) -> list[acb]:
    """解析固定路径或 ``path(ep, DEmatrix_at_ep)`` 工厂。"""

    value = path(sample, system) if callable(path) else path
    if not isinstance(value, list):
        raise TypeError("path must be a list[acb] or (ep, system) -> list[acb]")
    if type(value) is list:
        return [point if isinstance(point, acb) else acb(point) for point in value]
    return value


def _solve_sample(
    *,
    DEmatrix: Any,
    boundary: Any,
    path: Any,
    sample_argument: Any,
    sample_point: acb,
    transport_order: int,
    transport_extra_order: int,
    transport_sample_count: int | None,
    transport_extra_sample_count: int | None,
    radius_fraction: float,
    nde_tolerance: arb,
) -> tuple[acb_mat, dict[str, Any]]:
    """在固定 regulator 上运行基础 NDE refinement，并执行样本级精度门禁。"""

    system = _resolve_matrix_system(DEmatrix, sample_argument)
    resolved_path = _resolve_path(path, sample_argument, system)
    initial_vector = _resolve_boundary(boundary, sample_argument, resolved_path)
    if isinstance(initial_vector, acb_mat) and initial_vector.nrows() != system.dimension:
        raise ValueError("boundary dimension does not match DEmatrix")
    result = transport_path_refined(
        system,
        initial_vector,
        resolved_path,
        primary_order=transport_order,
        reference_order=transport_order + transport_extra_order,
        primary_sample_count=transport_sample_count,
        reference_sample_count=transport_extra_sample_count,
        radius_fraction=radius_fraction,
        target_relative_error=nde_tolerance,
    )
    nde_error = result["relative_difference_inf"]
    if not nde_error < nde_tolerance:
        raise SeriesValidationError(
            f"NDE refinement failed at {sample_point.str(30)}: "
            f"relative difference {nde_error.str(20)} is not below {nde_tolerance.str(20)}"
        )
    endpoint = acb_mat(result["reference_snapshots"][-1])
    boundary_initialization = next(
        (
            report
            for report in result["reference_segments"]
            if report.get("method", "").endswith("boundary_initialization")
        ),
        None,
    )
    return endpoint, {
        "sample_point": sample_point.str(50),
        "endpoint": _vector_to_strings(endpoint),
        "nde_relative_difference": nde_error.str(30),
        "primary_seconds": result["primary_seconds"],
        "reference_seconds": result["reference_seconds"],
        "boundary_initialization": boundary_initialization,
    }


def _leading_candidates(
    values: tuple[acb_mat, ...],
    ratio: float,
    tolerance: float,
) -> tuple[int, list[dict[str, Any]]]:
    """由各分量相邻模比判定最低整数幂；不稳定或非整数行为 fail closed。"""

    if len(values) < 3:
        raise ValueError("pilot_sample_count must be at least three")
    dimension = values[0].nrows()
    if any(value.nrows() != dimension or value.ncols() != 1 for value in values):
        raise ValueError("pilot NDE values have inconsistent dimensions")
    accepted: list[int] = []
    diagnostics: list[dict[str, Any]] = []
    log_ratio = math.log(ratio)
    for component in range(dimension):
        entries = [value[component, 0] for value in values]
        if all(entry.is_zero() for entry in entries):
            diagnostics.append(
                {"component": component, "status": "identically-zero-on-pilot"}
            )
            continue
        if any(entry.is_zero() or abs(entry).contains(0) for entry in entries):
            raise LeadingPowerDetectionError(
                f"component {component} is numerically compatible with zero on the pilot grid"
            )
        estimates = [
            (
                float(abs(right).log().mid())
                - float(abs(left).log().mid())
            )
            / log_ratio
            for left, right in zip(entries[:-1], entries[1:])
        ]
        center = statistics.median(estimates)
        candidate = round(center)
        spread = max(estimates) - min(estimates)
        distance = max(abs(estimate - candidate) for estimate in estimates)
        status = "accepted" if spread <= tolerance and distance <= tolerance else "unstable"
        diagnostics.append(
            {
                "component": component,
                "status": status,
                "estimates": estimates,
                "candidate": candidate,
                "spread": spread,
                "maximum_integer_distance": distance,
            }
        )
        if status != "accepted":
            raise LeadingPowerDetectionError(
                f"component {component} has unstable/noninteger pilot exponent estimates {estimates}"
            )
        accepted.append(candidate)
    if not accepted:
        raise LeadingPowerDetectionError("all endpoint components vanish on the pilot grid")
    return min(accepted), diagnostics


def _detect_leading_power(
    *,
    DEmatrix: Any,
    boundary: Any,
    path: Any,
    maximum_power: int,
    goal_digits: int,
    working_precision_digits: Any,
    extra_working_precision: float,
    transport_order: Any,
    transport_extra_order: Any,
    transport_sample_count: Any,
    transport_extra_sample_count: Any,
    radius_fraction: float,
    pilot_sample_count: int,
    pilot_base_sample: Any,
    pilot_ratio: Any,
    pilot_max_rounds: int,
    leading_power_tolerance: Any,
    guard_bits: int,
    rationalize_sample_points: bool,
) -> tuple[int, dict[str, Any]]:
    """运行可重复的 pilot 网格，并返回全局最低幂及逐分量证据。"""

    provisional_depth = max(0, maximum_power)
    provisional_count = max(math.ceil(2.5 * provisional_depth), provisional_depth + 1)
    pilot_alpha = Decimal(goal_digits) / Decimal(provisional_depth + 1)
    if pilot_base_sample == AUTOMATIC:
        base = _power_of_ten_fraction(-pilot_alpha, goal_digits + 30)
    else:
        base = _fraction_from_decimal_control(pilot_base_sample, "pilot_base_sample")
    ratio_fraction = _fraction_from_decimal_control(pilot_ratio, "pilot_ratio")
    if not 0 < ratio_fraction < 1:
        raise ValueError("pilot_ratio must lie strictly between zero and one")
    tolerance = (
        10 ** (-min(8.0, goal_digits / 4))
        if leading_power_tolerance == AUTOMATIC
        else float(leading_power_tolerance)
    )
    if tolerance <= 0:
        raise ValueError("leading_power_tolerance must be positive")
    provisional_p0 = max(math.ceil(provisional_count * float(pilot_alpha)), 30)
    precision_override = _require_automatic_or_integer(
        working_precision_digits, "working_precision_digits", minimum=1
    )
    precision = precision_override or math.ceil(
        2 * (1 + extra_working_precision) * provisional_p0
    )
    primary_override = _require_automatic_or_integer(
        transport_order, "transport_order", minimum=1
    )
    primary_order = primary_override or 4 * provisional_p0
    extra_override = _require_automatic_or_integer(
        transport_extra_order, "transport_extra_order", minimum=1
    )
    extra_order = extra_override or math.ceil(max(50, provisional_p0 / 5))
    primary_samples = _require_automatic_or_integer(
        transport_sample_count, "transport_sample_count", minimum=primary_order + 1
    )
    reference_samples = _require_automatic_or_integer(
        transport_extra_sample_count,
        "transport_extra_sample_count",
        minimum=primary_order + extra_order + 1,
    )
    configure_working_precision(precision, guard_bits)
    nde_tolerance = arb(f"1e-{min(goal_digits, 8)}")
    rounds: list[dict[str, Any]] = []
    current_base = base
    last_error: LeadingPowerDetectionError | None = None
    for round_index in range(1, pilot_max_rounds + 1):
        raw_points = [current_base * (ratio_fraction**index) for index in range(pilot_sample_count)]
        arguments = tuple(
            (
                fmpq(value.numerator, value.denominator)
                if rationalize_sample_points
                else acb(value.numerator) / acb(value.denominator)
            )
            for value in raw_points
        )
        points = tuple(acb(value) for value in arguments)
        values: list[acb_mat] = []
        reports: list[dict[str, Any]] = []
        for argument, point in zip(arguments, points):
            value, report = _solve_sample(
                DEmatrix=DEmatrix,
                boundary=boundary,
                path=path,
                sample_argument=argument,
                sample_point=point,
                transport_order=primary_order,
                transport_extra_order=extra_order,
                transport_sample_count=primary_samples,
                transport_extra_sample_count=reference_samples,
                radius_fraction=radius_fraction,
                nde_tolerance=nde_tolerance,
            )
            values.append(value)
            reports.append(report)
        try:
            leading, component_diagnostics = _leading_candidates(
                tuple(values), float(ratio_fraction), tolerance
            )
        except LeadingPowerDetectionError as error:
            last_error = error
            rounds.append(
                {
                    "round": round_index,
                    "sample_points": [point.str(50) for point in points],
                    "status": "retry",
                    "reason": str(error),
                    "solves": reports,
                }
            )
            current_base = raw_points[-1] * ratio_fraction
            continue
        rounds.append(
            {
                "round": round_index,
                "sample_points": [point.str(50) for point in points],
                "status": "accepted",
                "leading_power": leading,
                "components": component_diagnostics,
                "solves": reports,
            }
        )
        return leading, {
            "source": "automatic-pilot",
            "pilot_sample_count": pilot_sample_count,
            "pilot_base_sample": str(base),
            "pilot_ratio": str(ratio_fraction),
            "pilot_max_rounds": pilot_max_rounds,
            "leading_power_tolerance": tolerance,
            "working_precision_digits": precision,
            "transport_order": primary_order,
            "transport_extra_order": extra_order,
            "rounds": rounds,
        }
    raise LeadingPowerDetectionError(
        f"leading power remained ambiguous after {pilot_max_rounds} pilot rounds: {last_error}"
    )


def _fit_coefficient_vectors(
    points: tuple[acb, ...],
    values: tuple[acb_mat, ...],
    leading_power: int,
) -> tuple[acb_mat, ...]:
    """一次求解多右端 Vandermonde 方阵，返回全部内部系数矢量。"""

    count = len(points)
    if count != len(values):
        raise ValueError("production point/value counts do not match")
    if not values:
        raise ValueError("production samples must not be empty")
    dimension = values[0].nrows()
    if any(value.nrows() != dimension or value.ncols() != 1 for value in values):
        raise ValueError("production NDE values have inconsistent dimensions")
    powers = range(leading_power, leading_power + count)
    matrix = acb_mat([[point**power for power in powers] for point in points])
    right_hand_sides = acb_mat(
        [[value[row, 0] for row in range(dimension)] for value in values]
    )
    try:
        solved = matrix.solve(right_hand_sides)
    except RuntimeError as error:
        raise SeriesValidationError(
            "Laurent interpolation matrix is singular or unresolved at the working precision"
        ) from error
    return tuple(
        acb_mat([[solved[degree, component]] for component in range(dimension)])
        for degree in range(count)
    )


def _evaluate_coefficients(
    coefficients: tuple[acb_mat, ...], leading_power: int, point: acb
) -> acb_mat:
    """用 Horner 法计算从 ``leading_power`` 开始的连续系数矢量。"""

    value = acb_mat(coefficients[-1])
    for coefficient in reversed(coefficients[:-1]):
        value = value * point + coefficient
    return value * (point**leading_power)


def _relative_vector_residual(predicted: acb_mat, actual: acb_mat) -> arb:
    """计算验证矢量残差；全零参考值退化为绝对无穷范数。"""

    difference = vector_norm_inf(actual - predicted)
    scale = vector_norm_inf(actual)
    if scale.contains(0):
        return difference
    return difference / scale


def reconstruct_series_solution(
    *,
    DEmatrix: MatrixSystem | Callable[[Any], MatrixSystem],
    boundary: Any,
    path: list[acb] | Callable[[Any, MatrixSystem], list[acb]],
    maximum_power: int,
    series_parameter: str = "ep",
    goal_digits: int = 30,
    sample_points: Any = AUTOMATIC,
    leading_power: Any = AUTOMATIC,
    sample_count: Any = AUTOMATIC,
    base_sample: Any = AUTOMATIC,
    sample_spacing: Any = 0.01,
    working_precision_digits: Any = AUTOMATIC,
    extra_working_precision: float = 0.0,
    transport_order: Any = AUTOMATIC,
    transport_extra_order: Any = AUTOMATIC,
    transport_sample_count: Any = AUTOMATIC,
    transport_extra_sample_count: Any = AUTOMATIC,
    radius_fraction: float = 0.60,
    guard_bits: int = 32,
    pilot_sample_count: int = 4,
    pilot_base_sample: Any = AUTOMATIC,
    pilot_ratio: Any = 0.5,
    pilot_max_rounds: int = 3,
    leading_power_tolerance: Any = AUTOMATIC,
    validation_sample_count: int = 2,
    validation_scale: Any = 0.5,
    validation_tolerance: Any = AUTOMATIC,
    maximum_samples: int = 100,
    rationalize_sample_points: bool = True,
    output_layout: Any | None = None,
    result_name: str = "series_reconstruction",
) -> SeriesReconstructionResult:
    """用固定 regulator 的完整 NDE 解重构最终解矢量的 Laurent 系数。

    参数 ``DEmatrix``、``boundary`` 和 ``path`` 可直接给固定对象；依赖 regulator 时，
    分别给出 ``DEmatrix(ep)``、``boundary(ep)`` 和 ``path(ep, system)``。自动生成的
    exact-rational 样本以 ``fmpq`` 传给这些工厂。普通点使用列向量；正则奇点起点使用
    ``frobenius_boundary`` 生成的 exact ``{a,b,C}`` 记录，并由基础输运验证 indicial root、
    最高 log 次数和领头向量相容性。

    返回值包含用户请求到 ``maximum_power`` 的系数；生产插值内部还保留 AMFlow 式
    高阶缓冲。任一 NDE refinement、leading-power pilot 或独立样本验证失败都会抛出
    明确异常，不使用最小二乘、伪逆或静默降精度。
    """

    maximum_power = _require_integer(maximum_power, "maximum_power", minimum=-10**9)
    goal_digits = _require_integer(goal_digits, "goal_digits", minimum=1)
    pilot_sample_count = _require_integer(
        pilot_sample_count, "pilot_sample_count", minimum=3
    )
    pilot_max_rounds = _require_integer(pilot_max_rounds, "pilot_max_rounds", minimum=1)
    validation_sample_count = _require_integer(
        validation_sample_count, "validation_sample_count", minimum=1
    )
    maximum_samples = _require_integer(maximum_samples, "maximum_samples", minimum=1)
    guard_bits = _require_integer(guard_bits, "guard_bits", minimum=0)
    if not isinstance(series_parameter, str) or not series_parameter.strip():
        raise ValueError("series_parameter must be a nonempty string")
    if extra_working_precision < 0:
        raise ValueError("extra_working_precision must be nonnegative")
    if not 0 < radius_fraction < 1:
        raise ValueError("radius_fraction must lie strictly between zero and one")
    if not isinstance(rationalize_sample_points, bool):
        raise TypeError("rationalize_sample_points must be bool")

    if leading_power == AUTOMATIC:
        resolved_leading, pilot_diagnostics = _detect_leading_power(
            DEmatrix=DEmatrix,
            boundary=boundary,
            path=path,
            maximum_power=maximum_power,
            goal_digits=goal_digits,
            working_precision_digits=working_precision_digits,
            extra_working_precision=extra_working_precision,
            transport_order=transport_order,
            transport_extra_order=transport_extra_order,
            transport_sample_count=transport_sample_count,
            transport_extra_sample_count=transport_extra_sample_count,
            radius_fraction=radius_fraction,
            pilot_sample_count=pilot_sample_count,
            pilot_base_sample=pilot_base_sample,
            pilot_ratio=pilot_ratio,
            pilot_max_rounds=pilot_max_rounds,
            leading_power_tolerance=leading_power_tolerance,
            guard_bits=guard_bits,
            rationalize_sample_points=rationalize_sample_points,
        )
    else:
        resolved_leading = _require_integer(
            leading_power, "leading_power", minimum=-10**9
        )
        pilot_diagnostics = {
            "source": "user",
            "leading_power": resolved_leading,
            "pilot_skipped": True,
        }

    plan = _resolve_plan(
        leading_power=resolved_leading,
        maximum_power=maximum_power,
        goal_digits=goal_digits,
        sample_points=sample_points,
        sample_count=sample_count,
        base_sample=base_sample,
        sample_spacing=sample_spacing,
        working_precision_digits=working_precision_digits,
        extra_working_precision=extra_working_precision,
        transport_order=transport_order,
        transport_extra_order=transport_extra_order,
        transport_sample_count=transport_sample_count,
        transport_extra_sample_count=transport_extra_sample_count,
        validation_sample_count=validation_sample_count,
        validation_scale=validation_scale,
        maximum_samples=maximum_samples,
        rationalize_sample_points=rationalize_sample_points,
    )
    configure_working_precision(plan.working_precision_digits, guard_bits)
    tolerance = (
        arb(f"1e-{goal_digits}")
        if validation_tolerance == AUTOMATIC
        else arb(str(validation_tolerance))
    )
    if tolerance <= 0:
        raise ValueError("validation_tolerance must be positive")

    production_values: list[acb_mat] = []
    production_reports: list[dict[str, Any]] = []
    for argument, point in zip(plan.sample_arguments, plan.sample_points):
        value, report = _solve_sample(
            DEmatrix=DEmatrix,
            boundary=boundary,
            path=path,
            sample_argument=argument,
            sample_point=point,
            transport_order=plan.transport_order,
            transport_extra_order=plan.transport_extra_order,
            transport_sample_count=plan.transport_sample_count,
            transport_extra_sample_count=plan.transport_extra_sample_count,
            radius_fraction=radius_fraction,
            nde_tolerance=tolerance,
        )
        production_values.append(value)
        production_reports.append(report)

    internal_coefficients = _fit_coefficient_vectors(
        plan.sample_points, tuple(production_values), resolved_leading
    )
    returned_count = maximum_power - resolved_leading + 1
    returned_coefficients = internal_coefficients[:returned_count]

    validation_values: list[acb_mat] = []
    validation_reports: list[dict[str, Any]] = []
    for argument, point in zip(plan.validation_arguments, plan.validation_points):
        actual, solve_report = _solve_sample(
            DEmatrix=DEmatrix,
            boundary=boundary,
            path=path,
            sample_argument=argument,
            sample_point=point,
            transport_order=plan.transport_order,
            transport_extra_order=plan.transport_extra_order,
            transport_sample_count=plan.transport_sample_count,
            transport_extra_sample_count=plan.transport_extra_sample_count,
            radius_fraction=radius_fraction,
            nde_tolerance=tolerance,
        )
        predicted = _evaluate_coefficients(returned_coefficients, resolved_leading, point)
        residual = _relative_vector_residual(predicted, actual)
        validation_values.append(actual)
        validation_reports.append(
            {
                **solve_report,
                "predicted": _vector_to_strings(predicted),
                "series_relative_residual": residual.str(30),
                "passed": bool(residual < tolerance),
            }
        )
        if not residual < tolerance:
            raise SeriesValidationError(
                f"series validation failed at {point.str(30)}: residual "
                f"{residual.str(20)} is not below {tolerance.str(20)}"
            )

    internal_maximum = resolved_leading + plan.sample_count - 1
    effective_parameters = {
        "goal_digits": goal_digits,
        "sample_source": plan.source,
        "sample_count": plan.sample_count,
        "base_sample": plan.base_sample,
        "sample_spacing": str(sample_spacing),
        "alpha_epsilon": plan.alpha_epsilon,
        "base_precision_digits": plan.base_precision_digits,
        "working_precision_digits": plan.working_precision_digits,
        "extra_working_precision": extra_working_precision,
        "transport_order": plan.transport_order,
        "transport_extra_order": plan.transport_extra_order,
        "transport_sample_count": plan.transport_sample_count or AUTOMATIC,
        "transport_extra_sample_count": plan.transport_extra_sample_count or AUTOMATIC,
        "radius_fraction": radius_fraction,
        "guard_bits": guard_bits,
        "validation_sample_count": validation_sample_count,
        "validation_scale": str(validation_scale),
        "validation_tolerance": tolerance.str(30),
        "maximum_samples": maximum_samples,
        "rationalize_sample_points": rationalize_sample_points,
    }
    diagnostics = {
        "pilot": pilot_diagnostics,
        "production_solves": production_reports,
        "validation_solves": validation_reports,
        "internal_buffer_powers": internal_maximum - maximum_power,
        "interpolation": "square Acb Vandermonde with all production samples",
        "least_squares_used": False,
    }
    powers = tuple(range(resolved_leading, maximum_power + 1))
    result = SeriesReconstructionResult(
        series_parameter,
        powers,
        tuple(acb_mat(value) for value in returned_coefficients),
        resolved_leading,
        maximum_power,
        internal_maximum,
        plan.sample_points,
        tuple(acb_mat(value) for value in production_values),
        plan.validation_points,
        tuple(acb_mat(value) for value in validation_values),
        effective_parameters,
        diagnostics,
    )
    if output_layout is not None:
        filename = f"{result_name}_series_reconstruction.json"
        relative_output = str(Path("regularization") / filename)
        result = replace(result, output_file=relative_output)
        output_layout.write_json("regularization", filename, result.to_summary())
    return result
