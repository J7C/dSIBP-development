"""统一普通点/奇点调度与命名直线路径规划。

端点必须显式命名，并可用字面量 ``"inf"`` 表示无穷远。无穷远在局部变量
``sinv=1/s`` 下处理，系数矩阵为 ``-sinv**(-2) A(1/sinv)``。调度器在普通点调用
Cauchy--DFT；奇点依次尝试 exact power-log、Fuchsian reduction 和认证的指数广义幂级数。
路径计划报告两端及路径上的全部奇点；内部奇点由相邻普通匹配点和局部基跨点元数据表示。
"""

from __future__ import annotations

import warnings
from dataclasses import dataclass
from typing import Any

from flint import acb, acb_mat, arb

from .exact_gaussian import gaussian_rational
from .local_solutions import LocalReductionError, LocalSolutionBasis, build_local_solution_basis
from .singularities import (
    RationalMatrixSystem,
    SingularityInventory,
    SingularityRecord,
    analyze_singularities,
)
from .transport import build_straight_path


@dataclass(frozen=True)
class NamedPoint:
    """保存既有奇点路由使用的诊断名称及坐标。"""

    name: str
    value: Any

    def __post_init__(self) -> None:
        """拒绝空名称和含混的无穷远拼写。"""

        if not self.name.strip():
            raise ValueError("point name must not be empty")
        if isinstance(self.value, str) and self.value.lower() == "inf" and self.value != "inf":
            raise ValueError('infinity must be written exactly as "inf"')

    @property
    def is_infinity(self) -> bool:
        """返回端点是否表示无穷远。"""

        return isinstance(self.value, str) and self.value == "inf"

    def finite_acb(self) -> acb:
        """把有限端点转为 Acb，同时保留已有 Acb ball。"""

        if self.is_infinity:
            raise ValueError(f"{self.name} is infinity, not a finite point")
        if isinstance(self.value, acb):
            return acb(self.value)
        if isinstance(self.value, complex):
            return acb(str(self.value.real), str(self.value.imag))
        try:
            return gaussian_rational(self.value).to_acb()
        except (TypeError, ValueError):
            return acb(str(self.value))

    def exact_gaussian_value(self) -> str | None:
        """当端点不是浮点输入时，返回可移植的 Q(i) 精确值。"""

        if self.is_infinity or isinstance(self.value, (float, complex, acb, arb)):
            return None
        try:
            return str(gaussian_rational(self.value))
        except (TypeError, ValueError):
            return None

    def exact_rational_value(self) -> str | None:
        """保留旧名；现返回实有理数或高斯有理数的精确记录。"""

        return self.exact_gaussian_value()


@dataclass(frozen=True)
class PointClassification:
    """保存一个命名点的分类和收敛半径规则。"""

    name: str
    value: acb | None
    value_label: str
    kind: str
    singularity_identifier: str | None
    pole_order: int
    convergence_radius: arb | None

    def to_json(self) -> dict[str, Any]:
        """序列化点分类和半径，不引入 binary64 精度损失。"""

        return {
            "name": self.name,
            "value": self.value_label,
            "classification": self.kind,
            "singularity_identifier": self.singularity_identifier,
            "pole_order": self.pole_order,
            "convergence_radius": (
                None if self.convergence_radius is None else self.convergence_radius.str(40)
            ),
            "radius_rule": (
                "nearest other finite singularity"
                if self.kind != "ordinary"
                else "nearest finite singularity"
            ),
        }


def _nearest_distance(point: acb, records: list[SingularityRecord]) -> arb | None:
    """返回最近有限记录的距离；局部圆无界时返回 None。"""

    distances = [abs(point - record.location) for record in records if record.location is not None]
    if not distances:
        return None
    return min(distances, key=lambda value: float(value.mid()))


def classify_point(
    endpoint: NamedPoint,
    inventory: SingularityInventory,
) -> PointClassification:
    """使用已验证清单分类命名有限点或无穷远。"""

    if endpoint.is_infinity:
        record = inventory.infinity
        return PointClassification(
            endpoint.name,
            None,
            "inf",
            record.kind,
            record.identifier if record.kind != "ordinary" else None,
            record.pole_order,
            None,
        )
    point = endpoint.finite_acb()
    matches = [
        record
        for record in inventory.finite
        if record.location is not None and abs(point - record.location).contains(0)
    ]
    if len(matches) > 1:
        raise ValueError(f"{endpoint.name}: point overlaps more than one isolated singularity")
    if not matches:
        radius = _nearest_distance(point, list(inventory.finite))
        return PointClassification(
            endpoint.name,
            point,
            point.str(40),
            "ordinary",
            None,
            0,
            radius,
        )
    record = matches[0]
    others = [candidate for candidate in inventory.finite if candidate is not record]
    radius = _nearest_distance(point, others)
    return PointClassification(
        endpoint.name,
        point,
        record.location_exact or point.str(40),
        record.kind,
        record.identifier,
        record.pole_order,
        radius,
    )


@dataclass(frozen=True)
class LocalExpansion:
    """统一局部方法调度器的返回结果。"""

    classification: PointClassification
    working_variable: str
    method: str
    convergence_radius: arb | None
    matrix_coefficients: tuple[acb_mat, ...] | None
    power_log_basis: LocalSolutionBasis | None
    manifest: dict[str, Any]


def _working_system_and_point(
    system: RationalMatrixSystem, endpoint: NamedPoint
) -> tuple[RationalMatrixSystem, NamedPoint, bool]:
    """把无穷远端点映射为反演变量的零点。"""

    if endpoint.is_infinity:
        return system.inverted("sinv"), NamedPoint(endpoint.name, 0), True
    return system, endpoint, False


def prepare_local_expansion(
    system: RationalMatrixSystem,
    endpoint: NamedPoint,
    *,
    order: int,
    radius_fraction: float = 0.60,
    radius: acb | None = None,
    sample_count: int | None = None,
    output_layout: Any | None = None,
) -> LocalExpansion:
    """按 exact 结构选择普通点、Fuchsian 化或指数广义幂级数引擎。

    高阶 pole 会先做 exact shearing；仍保留二阶 pole 时还可接受单重不同主导根的
    start-only 形式渐近 sector。普通点若没有有限奇点限制局部圆，则必须显式提供
    ``radius``；形式渐近基的返回收敛半径为 ``None``。
    """

    if order <= 0:
        raise ValueError("local expansion order must be positive")
    if not 0 < radius_fraction < 1:
        raise ValueError("radius_fraction must lie between zero and one")
    working_system, working_endpoint, inverted = _working_system_and_point(system, endpoint)
    inventory = analyze_singularities(
        working_system,
        output_layout=output_layout,
        filename=("singularity_inventory_sinv.json" if inverted else "singularity_inventory.json"),
    )
    classification = classify_point(working_endpoint, inventory)
    if classification.kind == "ordinary":
        sampling_radius = radius
        if sampling_radius is None:
            if classification.convergence_radius is None:
                raise ValueError(
                    f"{endpoint.name}: no finite singularity bounds the Cauchy disk; provide radius"
                )
            sampling_radius = acb(classification.convergence_radius * radius_fraction)
        coefficients = working_system.to_analytic_system(inventory).taylor_matrix_coefficients(
            working_endpoint.finite_acb(),
            order,
            radius=sampling_radius,
            sample_count=sample_count,
        )
        manifest = {
            "schema": "flintnde_local_dispatch_v1",
            "point": classification.to_json(),
            "working_variable": working_system.variable_name,
            "infinity_transformation": inverted,
            "method": "ordinary_cauchy_dft",
            "order": order,
            "sample_count": sample_count or max(32, 2 * order),
            "sampling_radius": sampling_radius.str(40),
        }
        if output_layout is not None:
            output_layout.write_json(
                "transport", f"{endpoint.name}_ordinary_expansion.json", manifest
            )
        return LocalExpansion(
            classification,
            working_system.variable_name,
            "ordinary_cauchy_dft",
            classification.convergence_radius,
            tuple(coefficients),
            None,
            manifest,
        )

    exact_point = working_endpoint.exact_gaussian_value() or classification.value_label
    try:
        gaussian_rational(exact_point)
    except (TypeError, ValueError) as error:
        raise ValueError(
            f"{endpoint.name}: automatic exact Frobenius extraction currently requires a Q(i) singularity"
        ) from error
    basis = build_local_solution_basis(working_system, exact_point, order)
    manifest = {
        "schema": "flintnde_local_dispatch_v1",
        "point": classification.to_json(),
        "working_variable": working_system.variable_name,
        "infinity_transformation": inverted,
        "method": basis.method,
        "order": order,
        "frobenius": basis.manifest.get("frobenius"),
        "local_basis": basis.manifest,
    }
    if output_layout is not None:
        output_layout.write_json("frobenius", f"{endpoint.name}_frobenius.json", manifest)
    return LocalExpansion(
        classification,
        working_system.variable_name,
        basis.method,
        (
            classification.convergence_radius
            if basis.continuation_ready
            else None
        ),
        None,
        basis,
        manifest,
    )


@dataclass(frozen=True)
class PathPlan:
    """保存命名路径点、所选局部方法和跨奇点要求。"""

    name: str
    original_variable: str
    working_variable: str
    infinity_transformation: bool
    max_step_over_radius: float
    start: PointClassification
    target: PointClassification
    internal_singularities: tuple[PointClassification, ...]
    points: tuple[dict[str, Any], ...]
    segments: tuple[dict[str, Any], ...]
    continuation_ready: bool
    messages: tuple[str, ...]

    def to_json(self) -> dict[str, Any]:
        """序列化完整路径决策和生成点。"""

        return {
            "schema": "flintnde_adaptive_path_plan_v1",
            "path_name": self.name,
            "original_variable": self.original_variable,
            "working_variable": self.working_variable,
            "infinity_transformation": self.infinity_transformation,
            "max_step_over_convergence_radius": self.max_step_over_radius,
            "start": self.start.to_json(),
            "target": self.target.to_json(),
            "internal_singularities": [item.to_json() for item in self.internal_singularities],
            "points": list(self.points),
            "segments": list(self.segments),
            "continuation_ready": self.continuation_ready,
            "messages": list(self.messages),
        }


class AdaptivePath(list[acb]):
    """可直接输运且携带奇点跨越、半径和逐步比值的路径变量。

    列表元素只包含可实际求值的普通匹配点；内部奇点作为相邻两点之间的 transition
    元数据保存，避免把未必有限的 ``Y(singularity)`` 冒充普通 snapshot。
    """

    def __init__(
        self,
        points: list[acb],
        *,
        working_system: RationalMatrixSystem,
        transitions: list[dict[str, Any]],
        step_reports: list[dict[str, Any]],
        internal_singularities: tuple[PointClassification, ...],
        start_classification: PointClassification,
        target_classification: PointClassification,
        working_variable: str,
        infinity_transformation: bool,
        save_requests: tuple[dict[str, Any], ...] = (),
        formal_asymptotic_match_estimate: dict[str, Any] | None = None,
    ) -> None:
        """保存直接执行点和与其严格对齐的 transition/step 诊断。"""

        super().__init__(acb(point) for point in points)
        if len(transitions) != max(0, len(points) - 1):
            raise ValueError("adaptive path transition count does not match point count")
        self._working_system = working_system
        self._transitions = tuple(transitions)
        self.step_reports = tuple(step_reports)
        self.internal_singularities = internal_singularities
        self.start_classification = start_classification
        self.target_classification = target_classification
        self.working_variable = working_variable
        self.infinity_transformation = infinity_transformation
        self.save_requests = save_requests
        self.formal_asymptotic_match_estimate = formal_asymptotic_match_estimate
        finite_ratios = [
            report["step_over_convergence_radius"]
            for report in step_reports
            if report["step_over_convergence_radius"] is not None
        ]
        self.max_step_over_convergence_radius = max(finite_ratios, default=None)


def _map_path_endpoints_at_infinity(
    system: RationalMatrixSystem, start: NamedPoint, target: NamedPoint
) -> tuple[RationalMatrixSystem, NamedPoint, NamedPoint, bool]:
    """把含一个无穷远端点的路径映射到倒数变量。"""

    if start.is_infinity and target.is_infinity:
        raise ValueError("a path cannot have infinity as both endpoints")
    if not start.is_infinity and not target.is_infinity:
        return system, start, target, False
    working = system.inverted("sinv")

    def mapped(endpoint: NamedPoint) -> NamedPoint:
        if endpoint.is_infinity:
            return NamedPoint(endpoint.name, 0)
        value = endpoint.finite_acb()
        if abs(value).contains(0):
            raise ValueError("a finite zero endpoint maps to infinity in sinv; split the route explicitly")
        return NamedPoint(endpoint.name, 1 / value)

    return working, mapped(start), mapped(target), True


def _on_segment_parameter(point: acb, start: acb, target: acb, tolerance: float) -> float | None:
    """对 Acb ball 与路径直线相交的根，返回其实线段参数。"""

    start_mid = complex(float(start.real.mid()), float(start.imag.mid()))
    target_mid = complex(float(target.real.mid()), float(target.imag.mid()))
    point_mid = complex(float(point.real.mid()), float(point.imag.mid()))
    direction = target_mid - start_mid
    denominator = abs(direction) ** 2
    if denominator == 0:
        return None
    parameter = ((point_mid - start_mid) * direction.conjugate()).real / denominator
    projected = start_mid + parameter * direction
    root_radius = max(float(point.real.rad()), float(point.imag.rad()))
    if tolerance < parameter < 1 - tolerance and abs(point_mid - projected) <= tolerance + root_radius:
        return parameter
    return None


def _point_record(name: str, point: acb, classification: PointClassification) -> dict[str, Any]:
    """构造一个可移植的生成路径点记录。"""

    return {
        "name": name,
        "value": point.str(40),
        "classification": classification.kind,
        "singularity_identifier": classification.singularity_identifier,
        "convergence_radius": (
            None
            if classification.convergence_radius is None
            else classification.convergence_radius.str(40)
        ),
    }


def _map_detour_point(endpoint: NamedPoint, inverted: bool) -> NamedPoint:
    """把用户绕行点映射到当前工作变量；无穷远绕行点和反演后的零点均不允许。"""

    if endpoint.is_infinity:
        raise ValueError("detour points must be finite")
    if not inverted:
        return endpoint
    value = endpoint.finite_acb()
    if abs(value).contains(0):
        raise ValueError("a zero detour point maps to infinity in sinv")
    return NamedPoint(endpoint.name, 1 / value)


def _internal_singularities_on_leg(
    inventory: SingularityInventory,
    start: acb,
    target: acb,
    path_tolerance: float,
) -> list[PointClassification]:
    """按路径顺序返回一条有限线段内部的全部奇点。"""

    found: list[tuple[float, PointClassification]] = []
    for record in inventory.finite:
        if record.location is None:
            continue
        parameter = _on_segment_parameter(record.location, start, target, path_tolerance)
        if parameter is None:
            continue
        endpoint = NamedPoint(record.identifier, record.location)
        found.append((parameter, classify_point(endpoint, inventory)))
    found.sort(key=lambda item: item[0])
    return [classification for _, classification in found]


def _ordinary_match_point(
    point: acb,
    classification: PointClassification,
    direction: acb,
    interval_length: arb,
    max_step_over_radius: float,
    preferred_distance: arb | None = None,
) -> acb:
    """奇点端点向区间内部移动到局部收敛圆中的普通匹配点。"""

    if classification.kind == "ordinary":
        return acb(point)
    distance = interval_length / 3
    if preferred_distance is not None:
        distance = min(
            distance,
            preferred_distance,
            key=lambda value: float(value.mid()),
        )
    if classification.convergence_radius is not None:
        distance = min(
            distance,
            classification.convergence_radius * max_step_over_radius,
            key=lambda value: float(value.mid()),
        )
    return point + direction * distance


def _route_point(value: Any, role: str) -> tuple[NamedPoint, bool]:
    """把裸坐标或 ``(coordinate,"save")`` 转为内部端点；名称不属于 save 合同。"""

    tagged = isinstance(value, (list, tuple)) and len(value) == 2 and value[1] == "save"
    coordinate = value[0] if tagged else value
    if isinstance(coordinate, NamedPoint):
        return coordinate, tagged
    return NamedPoint(role, coordinate), tagged


def _preflight_local_basis(
    system: RationalMatrixSystem,
    inventory: SingularityInventory,
    classification: PointClassification,
    order: int,
) -> tuple[SingularityRecord, LocalSolutionBasis]:
    """对一个非普通点执行正式建路所需的同一局部基能力检查。

    输入必须是 inventory 中的奇点分类。当前 exact 局部 dispatcher 只接受 Q(i)
    中心；位置或局部谱超出能力时统一抛出 ``LocalReductionError``，调用方决定
    是把失败记录进计划，还是立即停止正式建路。
    """

    record = inventory.find_finite(classification.singularity_identifier)
    if record is None or record.location_exact is None:
        raise LocalReductionError(
            f"{classification.name}: {classification.kind} local basis requires "
            "an exact Q(i) singular location"
        )
    try:
        basis = build_local_solution_basis(system, record.location_exact, order)
    except (ValueError, NotImplementedError, LocalReductionError) as error:
        raise LocalReductionError(
            f"{classification.name}: unsupported {classification.kind} local basis: {error}"
        ) from error
    return record, basis


def build_adaptive_path(
    system: RationalMatrixSystem,
    start: Any,
    target: Any,
    *,
    detour_points: tuple[Any, ...] = (),
    path_name: str | None = None,
    max_step_over_radius: float = 0.45,
    path_tolerance: float = 1.0e-24,
    formal_asymptotic_order: int | None = None,
    formal_minimum_order_factor: float = 3.0,
    output_layout: Any | None = None,
) -> AdaptivePath:
    """生成可直接作为 ``transport_path`` 参数的自描述 Acb 路径。

    ``max_step_over_radius`` 只控制步长，不改变由奇点位置确定的收敛半径。内部奇点仅
    warning；用户不提供绕行点时，路径自动在奇点两侧建立普通匹配点，并把该连接标为
    统一局部基 bridge。进入奇点的步长始终除以目标奇点的收敛半径。
    """

    start, start_save = _route_point(start, "start")
    target, target_save = _route_point(target, "target")
    parsed_detours = tuple(
        _route_point(point, f"detour_{index + 1:03d}")
        for index, point in enumerate(detour_points)
    )
    detour_points = tuple(point for point, _save in parsed_detours)
    save_flags = (start_save, *(save for _point, save in parsed_detours), target_save)
    if not 0 < max_step_over_radius < 1:
        raise ValueError("max_step_over_radius must lie between zero and one")
    if path_tolerance <= 0:
        raise ValueError("path_tolerance must be positive")
    if formal_asymptotic_order is not None and formal_asymptotic_order <= 0:
        raise ValueError("formal_asymptotic_order must be positive")
    if formal_minimum_order_factor <= 1:
        raise ValueError("formal_minimum_order_factor must exceed one")
    resolved_name = path_name or f"{start.name}_to_{target.name}"
    working, working_start, working_target, inverted = _map_path_endpoints_at_infinity(
        system, start, target
    )
    mapped_detours = tuple(
        _map_detour_point(endpoint, inverted) for endpoint in detour_points
    )
    original_inventory = analyze_singularities(system, output_layout=output_layout)
    working_inventory = (
        analyze_singularities(
            working,
            output_layout=output_layout,
            filename="singularity_inventory_sinv.json",
        )
        if inverted
        else original_inventory
    )
    route = (working_start, *mapped_detours, working_target)
    route_classifications = tuple(
        classify_point(endpoint, working_inventory) for endpoint in route
    )
    bad_middle_points = [
        item.name
        for item, save_requested in zip(
            route_classifications[1:-1], save_flags[1:-1]
        )
        if item.kind != "ordinary" and not save_requested
    ]
    if bad_middle_points:
        raise ValueError(
            "singular intermediate points must carry the save tag; unsupported points: "
            + ", ".join(bad_middle_points)
        )

    internal_by_leg: list[tuple[int, list[PointClassification]]] = []
    checkpoints: list[tuple[NamedPoint, PointClassification]] = []
    for leg_index, (left, right) in enumerate(zip(route[:-1], route[1:]), start=1):
        left_value = left.finite_acb()
        right_value = right.finite_acb()
        if abs(right_value - left_value).contains(0):
            raise ValueError(f"path leg {leg_index} has identical endpoints")
        internal = _internal_singularities_on_leg(
            working_inventory,
            left_value,
            right_value,
            path_tolerance,
        )
        if internal:
            internal_by_leg.append((leg_index, internal))
        if not checkpoints:
            checkpoints.append((left, route_classifications[leg_index - 1]))
        checkpoints.extend(
            (NamedPoint(item.name, item.value), item) for item in internal
        )
        checkpoints.append((right, route_classifications[leg_index]))

    internal_classifications = tuple(
        item for _, records in internal_by_leg for item in records
    )
    bridge_classifications = tuple(
        classification
        for _point, classification in checkpoints[1:-1]
        if classification.kind != "ordinary"
    )
    formal_start_distance: arb | None = None
    formal_start_estimate: dict[str, Any] | None = None
    # 所有非普通点先走同一个局部 dispatcher；形式渐近基只允许从起点向外初始化。
    for role, classification in (
        ("start", route_classifications[0]),
        *(("internal", item) for item in bridge_classifications),
        ("target", route_classifications[-1]),
    ):
        if classification.kind == "ordinary":
            continue
        _record, local_basis = _preflight_local_basis(
            working, working_inventory, classification, 4
        )
        if not local_basis.continuation_ready and role != "start":
            raise LocalReductionError(
                f"{classification.name}: {local_basis.method} is start-only; "
                "internal/target continuation requires Stokes connection data"
            )
        if local_basis.method == "formal_exponential_asymptotic" and role == "start":
            if formal_asymptotic_order is not None:
                formal_start_distance, formal_start_estimate = (
                    local_basis.suggest_match_distance(
                        formal_asymptotic_order,
                        formal_minimum_order_factor,
                    )
                )
    if internal_by_leg:
        identifiers = [
            item.singularity_identifier or item.name
            for _, records in internal_by_leg
            for item in records
        ]
        method_label = (
            "Frobenius bridges"
            if all(item.kind == "regular_singular" for item in bridge_classifications)
            else "automatic high-pole local-basis attempts"
        )
        message = (
            "path intersects internal singularities "
            + ", ".join(identifiers)
            + f"; continuing with {method_label}. To avoid them, rerun with explicit "
            "detour_points=(NamedPoint('detour_01', complex_value), ...)"
        )
        warnings.warn(message, UserWarning, stacklevel=2)

    messages = [
        f"start '{start.name}' is {route_classifications[0].kind}",
        f"target '{target.name}' is {route_classifications[-1].kind}",
        f"step length is limited by {max_step_over_radius} times the convergence radius",
    ]
    if inverted:
        messages.append("path points use sinv=1/s")
    if route_classifications[0].kind == "non_fuchsian_input_basis":
        messages.append(
            "the high-pole start requires the five-order asymptotic convergence report"
        )
        if formal_start_estimate is not None:
            messages.append(
                "formal start match distance uses the nearest exponential-root gap and places "
                "the requested order at one third of the estimated least-term degree"
            )
    if mapped_detours:
        messages.append(
            "user-selected detours: " + ", ".join(point.name for point in detour_points)
        )
    elif internal_by_leg:
        messages.append("internal singularities use automatic local bridges")
    else:
        messages.append("the straight path contains no internal singularity")

    analytic_system = working.to_analytic_system(working_inventory)
    generated: list[acb] = []
    generated_classifications: list[PointClassification] = []
    transitions: list[dict[str, Any]] = []
    endpoint_matches: list[dict[str, Any]] = []

    def append_unique(
        point: acb,
        classification: PointClassification,
        transition: dict[str, Any] | None = None,
    ) -> None:
        """追加普通执行点，并让 transition 与新增线段一一对应。"""

        if generated and abs(generated[-1] - point).contains(0):
            return
        if generated:
            transitions.append(transition or {"method": "ordinary_taylor"})
        generated.append(acb(point))
        generated_classifications.append(classification)

    previous_right_classification: PointClassification | None = None
    for interval_index, ((left, left_classification), (right, right_classification)) in enumerate(
        zip(checkpoints[:-1], checkpoints[1:])
    ):
        left_value = left.finite_acb()
        right_value = right.finite_acb()
        delta = right_value - left_value
        interval_length = abs(delta)
        unit = delta / interval_length
        left_work = _ordinary_match_point(
            left_value,
            left_classification,
            unit,
            interval_length,
            max_step_over_radius,
            (
                formal_start_distance
                if interval_index == 0
                and left_classification is route_classifications[0]
                else None
            ),
        )
        right_work = _ordinary_match_point(
            right_value,
            right_classification,
            -unit,
            interval_length,
            max_step_over_radius,
        )
        for endpoint, classification, match in (
            (left, left_classification, left_work),
            (right, right_classification, right_work),
        ):
            if classification.kind != "ordinary":
                endpoint_matches.append(
                    {
                        "endpoint_name": endpoint.name,
                        "classification": classification.kind,
                        "singular_point": classification.value_label,
                        "ordinary_match_point": match.str(40),
                        "convergence_radius": (
                            None
                            if classification.convergence_radius is None
                            else classification.convergence_radius.str(40)
                        ),
                        "match_distance_over_convergence_radius": (
                            None
                            if classification.convergence_radius is None
                            else float((abs(match - endpoint.finite_acb()) / classification.convergence_radius).mid())
                        ),
                        "formal_asymptotic_match_estimate": (
                            formal_start_estimate
                            if interval_index == 0 and endpoint.name == route[0].name
                            else None
                        ),
                    }
                )
        if abs(right_work - left_work).contains(0):
            raise ValueError(
                f"path interval {interval_index + 1} has no ordinary region after matching"
            )
        left_work_classification = classify_point(
            NamedPoint(f"{resolved_name}_match_{interval_index + 1:03d}_left", left_work),
            working_inventory,
        )
        bridge_transition = None
        if generated and previous_right_classification is not None:
            bridge_transition = {
                "method": "regular_singular_bridge",
                "singularity": previous_right_classification,
            }
        append_unique(left_work, left_work_classification, bridge_transition)
        if working_inventory.finite:
            leg_points = build_straight_path(
                analytic_system,
                left_work,
                right_work,
                step_fraction=max_step_over_radius,
            )
        else:
            leg_points = [acb(left_work), acb(right_work)]
        for point in leg_points[1:]:
            local_classification = classify_point(
                NamedPoint(f"{resolved_name}_ordinary", point), working_inventory
            )
            append_unique(point, local_classification, {"method": "ordinary_taylor"})
        previous_right_classification = (
            right_classification if right_classification.kind != "ordinary" else None
        )

    if len(generated) < 2:
        raise ValueError("adaptive path requires at least two ordinary path points")
    path_records: list[dict[str, Any]] = []
    segment_records: list[dict[str, Any]] = []
    for index, (point, classification) in enumerate(
        zip(generated, generated_classifications), start=1
    ):
        path_records.append(
            {
                "point_index": index,
                "value": point.str(40),
                "convergence_radius": (
                    None
                    if classification.convergence_radius is None
                    else classification.convergence_radius.str(40)
                ),
            }
        )
        if index == len(generated):
            continue
        transition = transitions[index - 1]
        target_point = generated[index]
        if transition["method"] == "regular_singular_bridge":
            singularity = transition["singularity"]
            center = singularity.value
            if center is None:
                raise ValueError("finite Frobenius bridge is missing its center")
            for side, step_start, step_target in (
                ("match_to_singularity", point, center),
                ("singularity_to_match", center, target_point),
            ):
                step_length = abs(step_target - step_start)
                radius = singularity.convergence_radius
                ratio = None if radius is None else float((step_length / radius).mid())
                segment_records.append(
                    {
                        "step_index": len(segment_records) + 1,
                        "execution_segment_index": index,
                        "method": "local_singular_basis",
                        "side": side,
                        "singularity_identifier": singularity.singularity_identifier,
                        "step_length": step_length.str(40),
                        "controlling_convergence_radius": (
                            None if radius is None else radius.str(40)
                        ),
                        "radius_owner": "singularity",
                        "step_over_convergence_radius": ratio,
                    }
                )
        else:
            step_length = abs(target_point - point)
            radius = classification.convergence_radius
            ratio = None if radius is None else float((step_length / radius).mid())
            segment_records.append(
                {
                    "step_index": len(segment_records) + 1,
                    "execution_segment_index": index,
                    "method": "ordinary_taylor",
                    "side": None,
                    "singularity_identifier": None,
                    "step_length": step_length.str(40),
                    "controlling_convergence_radius": (
                        None if radius is None else radius.str(40)
                    ),
                    "radius_owner": "start_ordinary_point",
                    "step_over_convergence_radius": ratio,
                }
            )
    finite_ratios = [
        record["step_over_convergence_radius"]
        for record in segment_records
        if record["step_over_convergence_radius"] is not None
    ]
    actual_maximum_ratio = max(finite_ratios, default=None)
    if actual_maximum_ratio is not None and actual_maximum_ratio > max_step_over_radius + 1.0e-12:
        raise ArithmeticError("generated path violates max_step_over_radius")
    ratio_message = (
        "step/R ratios in path order: "
        + repr([record["step_over_convergence_radius"] for record in segment_records])
        + f"; maximum step/R: {actual_maximum_ratio}"
    )
    messages.append(ratio_message)
    save_requests: list[dict[str, Any]] = []
    original_route = (start, *detour_points, target)
    for route_index, (original_point, working_point, classification, save_requested) in enumerate(
        zip(original_route, route, route_classifications, save_flags)
    ):
        if not save_requested:
            continue
        request: dict[str, Any] = {
            "coordinate": "inf" if original_point.is_infinity else original_point.finite_acb().str(40),
            "working_coordinate": classification.value_label,
            "classification": classification.kind,
            "singularity_identifier": classification.singularity_identifier,
            "role": (
                "start" if route_index == 0 else
                "target" if route_index == len(original_route) - 1 else
                "detour"
            ),
            "execution_index": None,
        }
        if classification.kind == "ordinary":
            working_value = working_point.finite_acb()
            request["execution_index"] = next(
                (
                    index
                    for index, generated_point in enumerate(generated)
                    if abs(generated_point - working_value).contains(0)
                ),
                None,
            )
            if request["execution_index"] is None:
                raise ArithmeticError(
                    "saved ordinary route coordinate is absent from the execution path"
                )
        save_requests.append(request)
    warnings.warn("; ".join(messages), UserWarning, stacklevel=2)
    manifest = {
        "schema": "flintnde_executable_path_v1",
        "path_name": resolved_name,
        "original_variable": system.variable_name,
        "working_variable": working.variable_name,
        "infinity_transformation": inverted,
        "max_step_over_convergence_radius": max_step_over_radius,
        "start": route_classifications[0].to_json(),
        "target": route_classifications[-1].to_json(),
        "detour_points": [item.to_json() for item in route_classifications[1:-1]],
        "internal_singularities": [item.to_json() for item in internal_classifications],
        "endpoint_matches": endpoint_matches,
        "path_points": path_records,
        "steps": segment_records,
        "step_over_convergence_radius_list": [
            record["step_over_convergence_radius"] for record in segment_records
        ],
        "actual_max_step_over_convergence_radius": actual_maximum_ratio,
        "formal_asymptotic_match_estimate": formal_start_estimate,
        "save_requests": save_requests,
        "direct_transport_path_type": "list[acb]",
        "messages": messages,
    }
    if output_layout is not None:
        output_layout.write_json("transport", f"{resolved_name}_path.json", manifest)
    return AdaptivePath(
        generated,
        working_system=working,
        transitions=transitions,
        step_reports=segment_records,
        internal_singularities=bridge_classifications,
        start_classification=route_classifications[0],
        target_classification=route_classifications[-1],
        working_variable=working.variable_name,
        infinity_transformation=inverted,
        save_requests=tuple(save_requests),
        formal_asymptotic_match_estimate=formal_start_estimate,
    )


def build_adaptive_path_plan(
    system: RationalMatrixSystem,
    start: NamedPoint,
    target: NamedPoint,
    *,
    path_name: str | None = None,
    max_step_over_radius: float = 0.45,
    path_tolerance: float = 1.0e-24,
    local_analysis_order: int = 4,
    output_layout: Any | None = None,
) -> PathPlan:
    """生成命名直线路径，并报告全部端点奇点和内部奇点。

    奇点检查点的局部匹配距离由最近的*其他*有限奇点限制；普通点由最近有限奇点限制。
    内部正则奇点使用 power-log 局部桥接；高阶 pole 用低阶 exact 局部分析预检 shearing
    或指数 sector。只有两条路线都不能认证时 ``continuation_ready=False``。规划器从不
    在 pole 上计算 Taylor 级数，也不把未通过门禁的高阶 pole 自动认证为真正不规则奇点。
    """

    if not 0 < max_step_over_radius < 1:
        raise ValueError("max_step_over_radius must lie between zero and one")
    if path_tolerance <= 0:
        raise ValueError("path_tolerance must be positive")
    if local_analysis_order <= 0:
        raise ValueError("local_analysis_order must be positive")
    resolved_name = path_name or f"{start.name}_to_{target.name}"
    working, working_start, working_target, inverted = _map_path_endpoints_at_infinity(
        system, start, target
    )
    original_inventory = analyze_singularities(system, output_layout=output_layout)
    working_inventory = (
        analyze_singularities(
            working,
            output_layout=output_layout,
            filename="singularity_inventory_sinv.json",
        )
        if inverted
        else original_inventory
    )
    start_classification = classify_point(working_start, working_inventory)
    target_classification = classify_point(working_target, working_inventory)
    start_value = working_start.finite_acb()
    target_value = working_target.finite_acb()
    if abs(target_value - start_value).contains(0):
        raise ValueError("start and target must be distinct points")

    internal_with_parameter: list[tuple[float, PointClassification]] = []
    for record in working_inventory.finite:
        if record.location is None:
            continue
        parameter = _on_segment_parameter(
            record.location, start_value, target_value, path_tolerance
        )
        if parameter is None:
            continue
        endpoint = NamedPoint(record.identifier, record.location)
        internal_with_parameter.append((parameter, classify_point(endpoint, working_inventory)))
    internal_with_parameter.sort(key=lambda item: item[0])
    internal = tuple(item[1] for item in internal_with_parameter)

    messages = [
        f"start '{start.name}' is {start_classification.kind}",
        f"target '{target.name}' is {target_classification.kind}",
    ]
    if inverted:
        messages.append("infinity handled with sinv=1/s and d/dsinv=-sinv^(-2) d/ds")
    local_methods: dict[str, str] = {}
    unresolved_local_points: dict[str, str] = {}
    classified_roles = (
        (("start", start_classification),)
        + tuple(("internal", item) for item in internal)
        + (("target", target_classification),)
    )
    for role, classification in classified_roles:
        if classification.kind == "ordinary":
            continue
        identifier = classification.singularity_identifier or classification.name
        try:
            _record, local_basis = _preflight_local_basis(
                working, working_inventory, classification, local_analysis_order
            )
        except LocalReductionError as error:
            unresolved_local_points[identifier] = str(error)
        else:
            local_methods[identifier] = local_basis.method
            if not local_basis.continuation_ready and role != "start":
                unresolved_local_points[identifier] = (
                    f"{local_basis.method} is start-only; Stokes connection data are unavailable"
                )

    if internal:
        messages.append(
            "internal singularities on the straight path: "
            + ", ".join(item.singularity_identifier or item.name for item in internal)
        )
        if unresolved_local_points:
            messages.append(
                "unsupported local singularities: "
                + "; ".join(
                    f"{identifier}: {reason}"
                    for identifier, reason in unresolved_local_points.items()
                )
            )
        else:
            messages.append("all internal singularities have an automatic certified local basis")
    else:
        messages.append("no internal singularity lies on the straight path")
    warnings.warn("; ".join(messages), UserWarning, stacklevel=2)

    checkpoints: list[tuple[float, NamedPoint, PointClassification]] = [
        (0.0, working_start, start_classification)
    ]
    for parameter, classification in internal_with_parameter:
        checkpoints.append(
            (parameter, NamedPoint(classification.name, classification.value), classification)
        )
    checkpoints.append((1.0, working_target, target_classification))
    direction = target_value - start_value
    total_distance = abs(direction)
    unit = direction / total_distance
    analytic_system = working.to_analytic_system(working_inventory)
    generated: list[tuple[str, acb, PointClassification]] = []
    ordinary_counter = 0

    def append_point(name: str, point: acb, classification: PointClassification) -> None:
        if generated and abs(generated[-1][1] - point).contains(0):
            return
        generated.append((name, acb(point), classification))

    for interval_index, (left, right) in enumerate(zip(checkpoints[:-1], checkpoints[1:])):
        left_parameter, left_named, left_classification = left
        right_parameter, right_named, right_classification = right
        left_point = start_value + direction * left_parameter
        right_point = start_value + direction * right_parameter
        interval_length = abs(right_point - left_point)
        if interval_length.contains(0):
            continue
        append_point(left_named.name, left_point, left_classification)

        left_work = acb(left_point)
        if left_classification.kind != "ordinary":
            candidate = interval_length / 3
            if left_classification.convergence_radius is not None:
                candidate = min(
                    candidate,
                    left_classification.convergence_radius * max_step_over_radius,
                    key=lambda value: float(value.mid()),
                )
            left_work = left_point + unit * candidate

        right_work = acb(right_point)
        if right_classification.kind != "ordinary":
            candidate = interval_length / 3
            if right_classification.convergence_radius is not None:
                candidate = min(
                    candidate,
                    right_classification.convergence_radius * max_step_over_radius,
                    key=lambda value: float(value.mid()),
                )
            right_work = right_point - unit * candidate

        if not abs(left_work - left_point).contains(0):
            ordinary_counter += 1
            local = classify_point(NamedPoint(f"{resolved_name}_ordinary_{ordinary_counter:03d}", left_work), working_inventory)
            append_point(local.name, left_work, local)
        if not abs(right_work - left_work).contains(0):
            ordinary_path = build_straight_path(
                analytic_system,
                left_work,
                right_work,
                step_fraction=max_step_over_radius,
            )
            for point in ordinary_path[1:]:
                ordinary_counter += 1
                local = classify_point(
                    NamedPoint(f"{resolved_name}_ordinary_{ordinary_counter:03d}", point),
                    working_inventory,
                )
                append_point(local.name, point, local)
        if not abs(right_work - right_point).contains(0):
            append_point(right_named.name, right_point, right_classification)
        elif interval_index == len(checkpoints) - 2:
            append_point(right_named.name, right_point, right_classification)

    points = tuple(_point_record(name, point, classification) for name, point, classification in generated)
    segments: list[dict[str, Any]] = []
    for index, (left, right) in enumerate(zip(generated[:-1], generated[1:]), start=1):
        if left[2].kind != "ordinary":
            method = (
                "regular_singular_power_log_launch"
                if left[2].kind == "regular_singular"
                else "automatic_high_pole_local_basis"
            )
        elif right[2].kind != "ordinary":
            method = (
                "regular_singular_power_log_match"
                if right[2].kind == "regular_singular"
                else "automatic_high_pole_local_basis"
            )
        else:
            method = "ordinary_taylor"
        controlling_radius = (
            left[2].convergence_radius
            if left[2].kind != "ordinary"
            else right[2].convergence_radius
            if right[2].kind != "ordinary"
            else left[2].convergence_radius
        )
        step_length = abs(right[1] - left[1])
        segments.append(
            {
                "segment_index": index,
                "start_name": left[0],
                "target_name": right[0],
                "method": method,
                "step_length": step_length.str(40),
                "controlling_convergence_radius": (
                    None if controlling_radius is None else controlling_radius.str(40)
                ),
                "step_over_convergence_radius": (
                    None
                    if controlling_radius is None
                    else float((step_length / controlling_radius).mid())
                ),
            }
        )
    continuation_ready = not unresolved_local_points
    if local_methods:
        messages.append(
            "certified local methods: "
            + ", ".join(
                f"{identifier}={method}" for identifier, method in local_methods.items()
            )
        )
    plan = PathPlan(
        resolved_name,
        system.variable_name,
        working.variable_name,
        inverted,
        max_step_over_radius,
        start_classification,
        target_classification,
        internal,
        points,
        tuple(segments),
        continuation_ready,
        tuple(messages),
    )
    if output_layout is not None:
        output_layout.write_json("transport", f"{resolved_name}_path.json", plan.to_json())
    return plan
