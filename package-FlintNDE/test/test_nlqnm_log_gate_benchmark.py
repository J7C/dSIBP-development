#!/usr/bin/env python3
"""比较真实 NLQNM DE 上 exact Gaussian-rational 与 numerical log gate 的效率。

输入是共享资源中一个已认证的 16 维 fixed-epsilon pole/residue payload。脚本在
epsilon=0 精确重建 k=0 residue 和 A_0,...,A_8；exact 路线用两张 ``fmpq_mat``
保存复有理矩阵的实部/虚部，numerical 路线用原维数 ``acb_mat``。计时不含 JSON
读取和矩阵构造，输出只写入本目录的 ``results_test/``。
"""

from __future__ import annotations

import argparse
import hashlib
import json
import platform
import statistics
import sys
import time
import warnings
from dataclasses import dataclass
from fractions import Fraction
from pathlib import Path
from typing import Any

import flint
from flint import fmpq, fmpq_mat, fmpq_poly


TEST_DIR = Path(__file__).resolve().parent
NDE_ROOT = TEST_DIR.parent
REPO_ROOT = NDE_ROOT.parent
PACKAGE_ROOT = NDE_ROOT / "versions" / "FlintNDE-0.1.0"
if str(PACKAGE_ROOT) not in sys.path:
    sys.path.insert(0, str(PACKAGE_ROOT))

from flintnde import (  # noqa: E402
    NumericalFrobeniusOptions,
    NumericalRegularSingularSystem,
    build_numerical_frobenius_manifest,
    configure_working_precision,
)


DEFAULT_TEMPLATE = (
    REPO_ROOT
    / "000_resource"
    / "results"
    / "iterative_de"
    / "point_instances"
    / "Npoint_qnm_ooo_232_n0_odd_distinct_parents_EC"
    / "kECep_symbolic_pole_residue_template.json"
)
RESULTS_DIR = TEST_DIR / "results_test"
SUMMARY_PATH = RESULTS_DIR / "nlqnm_log_gate_benchmark.json"
RECORD_PATH = RESULTS_DIR / "nlqnm_log_gate_benchmark.md"


Gaussian = tuple[fmpq, fmpq]


def _gaussian(real: int | str | fmpq = 0, imag: int | str | fmpq = 0) -> Gaussian:
    """构造一个高斯有理数 ``real + imag I``。"""

    return fmpq(real), fmpq(imag)


def _gadd(left: Gaussian, right: Gaussian) -> Gaussian:
    """返回两个高斯有理数之和。"""

    return left[0] + right[0], left[1] + right[1]


def _gneg(value: Gaussian) -> Gaussian:
    """返回高斯有理数的相反数。"""

    return -value[0], -value[1]


def _gmul(left: Gaussian, right: Gaussian) -> Gaussian:
    """返回两个高斯有理数之积。"""

    return (
        left[0] * right[0] - left[1] * right[1],
        left[0] * right[1] + left[1] * right[0],
    )


def _gdiv(left: Gaussian, right: Gaussian) -> Gaussian:
    """精确计算高斯有理数除法。"""

    norm = right[0] * right[0] + right[1] * right[1]
    if norm == 0:
        raise ZeroDivisionError("division by zero Gaussian rational")
    return (
        (left[0] * right[0] + left[1] * right[1]) / norm,
        (left[1] * right[0] - left[0] * right[1]) / norm,
    )


def _gpow(value: Gaussian, power: int) -> Gaussian:
    """用二进制幂计算非负整数次高斯有理幂。"""

    if power < 0:
        return _gdiv(_gaussian(1), _gpow(value, -power))
    result = _gaussian(1)
    base = value
    exponent = power
    while exponent:
        if exponent & 1:
            result = _gmul(result, base)
        base = _gmul(base, base)
        exponent //= 2
    return result


def _parse_gaussian_exact(text: Any) -> Gaussian:
    """解析 payload 中由有理项和 ``I`` 构成的 Mathematica InputForm 数。"""

    compact = str(text).replace(" ", "").replace("(", "").replace(")", "")
    if not compact:
        return _gaussian()
    pieces: list[str] = []
    start = 0
    for index, character in enumerate(compact):
        if index > 0 and character in "+-":
            pieces.append(compact[start:index])
            start = index
    pieces.append(compact[start:])
    real = Fraction(0)
    imag = Fraction(0)
    for piece in pieces:
        if "I" in piece:
            coefficient = piece.replace("*I", "").replace("I", "")
            if coefficient in {"", "+"}:
                coefficient = "1"
            elif coefficient == "-":
                coefficient = "-1"
            elif coefficient.startswith("/"):
                coefficient = "1" + coefficient
            elif coefficient.startswith("-/"):
                coefficient = "-1" + coefficient[1:]
            imag += Fraction(coefficient)
        else:
            real += Fraction(piece)
    return _gaussian(str(real), str(imag))


@dataclass(frozen=True)
class GaussianMatrix:
    """用两张同维 ``fmpq_mat`` 表示 exact 复有理矩阵。"""

    real: fmpq_mat
    imag: fmpq_mat

    @property
    def nrows(self) -> int:
        """返回行数。"""

        return self.real.nrows()

    @property
    def ncols(self) -> int:
        """返回列数。"""

        return self.real.ncols()


def _qzero(nrows: int, ncols: int) -> GaussianMatrix:
    """构造 exact 复零矩阵。"""

    return GaussianMatrix(fmpq_mat(nrows, ncols), fmpq_mat(nrows, ncols))


def _qidentity(dimension: int) -> GaussianMatrix:
    """构造 exact 复单位矩阵。"""

    identity = fmpq_mat(
        [[1 if row == column else 0 for column in range(dimension)] for row in range(dimension)]
    )
    return GaussianMatrix(identity, fmpq_mat(dimension, dimension))


def _qadd(left: GaussianMatrix, right: GaussianMatrix) -> GaussianMatrix:
    """返回 exact 复矩阵之和。"""

    return GaussianMatrix(left.real + right.real, left.imag + right.imag)


def _qsub(left: GaussianMatrix, right: GaussianMatrix) -> GaussianMatrix:
    """返回 exact 复矩阵之差。"""

    return GaussianMatrix(left.real - right.real, left.imag - right.imag)


def _qmul(left: GaussianMatrix, right: GaussianMatrix) -> GaussianMatrix:
    """用四次 FLINT 有理矩阵乘法计算 exact 复矩阵乘积。"""

    return GaussianMatrix(
        left.real * right.real - left.imag * right.imag,
        left.real * right.imag + left.imag * right.real,
    )


def _qscale(matrix: GaussianMatrix, scalar: Gaussian) -> GaussianMatrix:
    """用一个高斯有理数缩放 exact 复矩阵。"""

    return GaussianMatrix(
        matrix.real * scalar[0] - matrix.imag * scalar[1],
        matrix.real * scalar[1] + matrix.imag * scalar[0],
    )


def _qtrace(matrix: GaussianMatrix) -> Gaussian:
    """返回 exact 复矩阵迹。"""

    return (
        sum((matrix.real[index, index] for index in range(matrix.nrows)), fmpq(0)),
        sum((matrix.imag[index, index] for index in range(matrix.nrows)), fmpq(0)),
    )


def _qis_zero(matrix: GaussianMatrix) -> bool:
    """严格判断 exact 复矩阵是否为零。"""

    return all(value == 0 for value in matrix.real.entries()) and all(
        value == 0 for value in matrix.imag.entries()
    )


def _qcolumn(matrix: GaussianMatrix, column: int) -> GaussianMatrix:
    """提取 exact 复矩阵的一列。"""

    return GaussianMatrix(
        fmpq_mat([[matrix.real[row, column]] for row in range(matrix.nrows)]),
        fmpq_mat([[matrix.imag[row, column]] for row in range(matrix.nrows)]),
    )


def _record_at_epsilon_zero(record: dict[str, Any]) -> Gaussian:
    """在 epsilon=0 处精确计算一个已认证 epsilon-rational 记录。"""

    numerator = _gaussian()
    denominator = _gaussian()
    for term in record["numerator_terms"]:
        if int(term["epsilon_power"]) == 0:
            numerator = _gadd(
                numerator,
                _parse_gaussian_exact(term["coefficient_exact"]),
            )
    for term in record["denominator_terms"]:
        if int(term["epsilon_power"]) == 0:
            denominator = _gadd(
                denominator,
                _parse_gaussian_exact(term["coefficient_exact"]),
            )
    return _gdiv(numerator, denominator)


def _matrix_at_epsilon_zero(records: list[list[dict[str, Any]]]) -> GaussianMatrix:
    """把 epsilon-rational 二维记录恢复为同维 exact 复矩阵。"""

    values = [[_record_at_epsilon_zero(record) for record in row] for row in records]
    return GaussianMatrix(
        fmpq_mat([[value[0] for value in row] for row in values]),
        fmpq_mat([[value[1] for value in row] for row in values]),
    )


def _characteristic_roots(matrix: GaussianMatrix) -> list[tuple[fmpq, int]]:
    """用 Faddeev-LeVerrier 和 FLINT 求同维复有理矩阵的有理特征根。"""

    dimension = matrix.nrows
    identity = _qidentity(dimension)
    auxiliary = identity
    coefficients: list[Gaussian] = [_gaussian(1)]
    for degree in range(1, dimension + 1):
        product = _qmul(matrix, auxiliary)
        trace = _qtrace(product)
        coefficient = _gdiv(_gneg(trace), _gaussian(degree))
        coefficients.append(coefficient)
        auxiliary = _qadd(product, _qscale(identity, coefficient))
    if not _qis_zero(auxiliary):
        raise ValueError("exact characteristic recurrence failed Cayley-Hamilton check")
    if any(imag != 0 for _, imag in coefficients):
        raise ValueError("NLQNM residue characteristic polynomial is not rational-real")
    polynomial = fmpq_poly([value[0] for value in reversed(coefficients)])
    roots = [(root, int(multiplicity)) for root, multiplicity in polynomial.roots()]
    if sum(multiplicity for _, multiplicity in roots) != dimension:
        raise ValueError("exact NLQNM residue does not have a fully rational spectrum")
    return sorted(roots)


def _spectral_projectors(
    residue: GaussianMatrix,
    roots: list[fmpq],
) -> list[GaussianMatrix]:
    """由 exact 有理根构造同维复有理谱投影。"""

    identity = _qidentity(residue.nrows)
    projectors: list[GaussianMatrix] = []
    for root in roots:
        projector = identity
        for other in roots:
            if other != root:
                factor = _qsub(residue, _qscale(identity, _gaussian(other)))
                projector = _qscale(_qmul(projector, factor), _gaussian(1 / (root - other)))
        projectors.append(projector)
    total = _qzero(residue.nrows, residue.ncols)
    for projector in projectors:
        total = _qadd(total, projector)
    if not _qis_zero(_qsub(total, identity)):
        raise ValueError("exact NLQNM spectral projectors failed completeness")
    for left, projector in enumerate(projectors):
        if not _qis_zero(_qsub(_qmul(projector, projector), projector)):
            raise ValueError("exact NLQNM spectral projector failed idempotency")
        for right, other in enumerate(projectors):
            if left != right and not _qis_zero(_qmul(projector, other)):
                raise ValueError("exact NLQNM spectral projectors failed orthogonality")
    return projectors


def _exact_gaussian_log_gate(case: dict[str, Any]) -> dict[str, Any]:
    """精确判断 NLQNM residue 谱、semisimplicity 和整数差 resonance。"""

    residue: GaussianMatrix = case["residue"]
    regular: list[GaussianMatrix] = case["regular"]
    root_records = _characteristic_roots(residue)
    roots = [root for root, _ in root_records]
    projectors = _spectral_projectors(residue, roots)
    differences = [
        (lower_position, upper_position, int(upper - lower))
        for lower_position, lower in enumerate(roots)
        for upper_position, upper in enumerate(roots)
        if upper > lower and (upper - lower).q == 1
    ]
    active_defects = 0
    checked_columns = 0
    for lower_position, upper_position, gap in differences:
        lower = roots[lower_position]
        lower_projector = projectors[lower_position]
        upper_projector = projectors[upper_position]
        for column in range(residue.ncols):
            initial = _qcolumn(lower_projector, column)
            if _qis_zero(initial):
                continue
            checked_columns += 1
            series = [initial]
            for degree in range(1, gap + 1):
                rhs = _qzero(residue.nrows, 1)
                for regular_degree in range(degree):
                    rhs = _qadd(
                        rhs,
                        _qmul(regular[regular_degree], series[degree - 1 - regular_degree]),
                    )
                if degree == gap:
                    if not _qis_zero(_qmul(upper_projector, rhs)):
                        active_defects += 1
                    break
                inverse = _qzero(residue.nrows, residue.ncols)
                absolute_power = lower + degree
                for root, projector in zip(roots, projectors):
                    inverse = _qadd(
                        inverse,
                        _qscale(projector, _gaussian(1 / (absolute_power - root))),
                    )
                series.append(_qmul(inverse, rhs))
    return {
        "roots_exact": [str(root) for root in roots],
        "root_multiplicities": [multiplicity for _, multiplicity in root_records],
        "semisimple": True,
        "integer_difference_gaps": sorted({gap for _, _, gap in differences}),
        "resonance_gate_active": active_defects > 0,
        "active_defect_column_count": active_defects,
        "checked_projector_column_count": checked_columns,
        "maximum_log_degree": 1 if active_defects else 0,
    }


def _numeric_records(matrix: GaussianMatrix) -> list[list[tuple[str, str]]]:
    """把 exact 复有理矩阵转成 Acb 接口接受的原维二维记录。"""

    return [
        [
            (str(matrix.real[row, column]), str(matrix.imag[row, column]))
            for column in range(matrix.ncols)
        ]
        for row in range(matrix.nrows)
    ]


def _numerical_log_gate(case: dict[str, Any], precision_digits: int) -> dict[str, Any]:
    """调用公开 Acb threshold gate 判断同一个 NLQNM 局部系统。"""

    system = NumericalRegularSingularSystem(
        residue=_numeric_records(case["residue"]),
        regular_coefficients=tuple(_numeric_records(matrix) for matrix in case["regular"]),
        name=f"nlqnm-{case['request_id']}",
    )
    with warnings.catch_warnings():
        warnings.simplefilter("ignore", UserWarning)
        manifest = build_numerical_frobenius_manifest(
            system,
            NumericalFrobeniusOptions(precision_digits=precision_digits),
        )
    roots = [
        complex(float(record["real"]), float(record["imag"]))
        for record in manifest["roots_numeric"]
    ]
    diagnostics = manifest["numeric_diagnostics"]
    return {
        "roots_numeric": [
            {"real": format(root.real, ".17g"), "imag": format(root.imag, ".17g")}
            for root in roots
        ],
        "root_multiplicities": manifest["root_multiplicities"],
        "geometric_multiplicities": manifest["geometric_multiplicities"],
        "resonance_gate_active": any(manifest["resonance_gates"].values()),
        "active_resonance_gate_count": sum(manifest["resonance_gates"].values()),
        "gate_series_order": manifest["gate_series_order"],
        "numeric_diagnostics": diagnostics,
    }


def _build_case(system: dict[str, Any]) -> dict[str, Any]:
    """从同一 pole/residue payload 重建 epsilon=0 的局部 NLQNM 系统。"""

    constant = _matrix_at_epsilon_zero(system["constant_matrix_entries"])
    residues = [
        _matrix_at_epsilon_zero(records) for records in system["residue_matrix_entries"]
    ]
    poles = [_parse_gaussian_exact(value) for value in system["poles_exact"]]
    zero_position = int(system["zero_pole_position_zero_based"])
    if poles[zero_position] != _gaussian():
        raise ValueError(f"{system['request_id']}: saved zero pole is not exactly zero")
    nonzero = [index for index in range(len(poles)) if index != zero_position]
    regular: list[GaussianMatrix] = []
    for degree in range(9):
        coefficient = constant if degree == 0 else _qzero(constant.nrows, constant.ncols)
        for index in nonzero:
            scalar = _gneg(_gdiv(_gaussian(1), _gpow(poles[index], degree + 1)))
            coefficient = _qadd(coefficient, _qscale(residues[index], scalar))
        regular.append(coefficient)
    return {
        "request_id": system["request_id"],
        "dimension": int(system["dimension"]),
        "residue": residues[zero_position],
        "regular": regular,
        "complex_input_diagnostics": {
            "pole_count": len(poles),
            "nonreal_pole_count": sum(imaginary != 0 for _, imaginary in poles),
            "residue_nonzero_imaginary_entry_count": sum(
                value != 0 for value in residues[zero_position].imag.entries()
            ),
            "regular_nonzero_imaginary_entry_counts_by_degree": [
                sum(value != 0 for value in matrix.imag.entries()) for matrix in regular
            ],
        },
    }


def _time_route(function: Any, repeats: int) -> tuple[dict[str, Any], list[float]]:
    """预热一次后记录多次单进程墙钟时间。"""

    reference = function()
    timings: list[float] = []
    for _ in range(repeats):
        started = time.perf_counter()
        result = function()
        timings.append(time.perf_counter() - started)
        if result != reference:
            raise ValueError("benchmark route returned non-deterministic manifest")
    return reference, timings


def _root_agreement(exact: dict[str, Any], numerical: dict[str, Any]) -> bool:
    """检查两条路线的根、多重度和 resonance 总判定是否一致。"""

    exact_roots = [float(value) for value in exact["roots_exact"]]
    numeric_roots = [float(value["real"]) for value in numerical["roots_numeric"]]
    roots_match = len(exact_roots) == len(numeric_roots) and all(
        abs(left - right) < 1.0e-30
        for left, right in zip(exact_roots, numeric_roots)
    )
    return bool(
        roots_match
        and exact["root_multiplicities"] == numerical["root_multiplicities"]
        and exact["resonance_gate_active"] == numerical["resonance_gate_active"]
    )


def _sha256(path: Path) -> str:
    """返回输入 payload 的 SHA-256。"""

    digest = hashlib.sha256()
    with path.open("rb") as stream:
        for block in iter(lambda: stream.read(1024 * 1024), b""):
            digest.update(block)
    return digest.hexdigest()


def _write_markdown(summary: dict[str, Any]) -> None:
    """按项目 benchmark 固定字段写入只供 test 使用的效率记录。"""

    lines = [
        "# NLQNM log gate benchmark",
        "",
        "本记录只用于 FlintNDE 内部技术路线选择，不进入正式 note。",
        "",
        "----------",
        "",
        "## Step 1: same-input complex classification backends",
        "",
        "| system | route | language | parallel | wall time | total size | check/status |",
        "| --- | --- | --- | --- | ---: | ---: | --- |",
    ]
    for case in summary["cases"]:
        for route_name in ("exact_gaussian_fmpq_pair", "numerical_acb_threshold"):
            route = case["routes"][route_name]
            lines.append(
                f"| {case['request_id']} ({case['dimension']}x{case['dimension']}) "
                f"| {route_name} | Python + python-flint | single process "
                f"| median {route['median_seconds']:.6f} s; min {route['min_seconds']:.6f} s "
                f"| {summary['source_size_bytes']} B input | {case['agreement']} |"
            )
    lines.extend(
        [
            "",
            "结论：见 JSON 的 `route_decision`。两条路线都保持原矩阵维数，不做实块化。",
            "",
        ]
    )
    RECORD_PATH.write_text("\n".join(lines), encoding="utf-8")


def main() -> None:
    """运行同输入复参数测试并保存可复核 summary。"""

    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--template", type=Path, default=DEFAULT_TEMPLATE)
    parser.add_argument("--precision-digits", type=int, default=80)
    parser.add_argument("--guard-bits", type=int, default=64)
    parser.add_argument("--repeats", type=int, default=1)
    parser.add_argument(
        "--systems",
        choices=("16", "24", "both"),
        default="16",
        help="选择 subsector16、top24 或两者。",
    )
    arguments = parser.parse_args()
    if arguments.repeats <= 0:
        raise ValueError("repeats must be positive")
    template_path = arguments.template.resolve()
    payload = json.loads(template_path.read_text(encoding="utf-8"))
    selected = [
        system
        for system in payload["systems"]
        if arguments.systems == "both"
        or int(system["dimension"]) == int(arguments.systems)
    ]
    if not selected:
        raise ValueError("no requested NLQNM system found in template")
    configure_working_precision(arguments.precision_digits, arguments.guard_bits)
    cases: list[dict[str, Any]] = []
    for system in selected:
        case = _build_case(system)
        exact, exact_times = _time_route(
            lambda current=case: _exact_gaussian_log_gate(current),
            arguments.repeats,
        )
        numerical, numerical_times = _time_route(
            lambda current=case: _numerical_log_gate(
                current,
                arguments.precision_digits,
            ),
            arguments.repeats,
        )
        agreement = _root_agreement(exact, numerical)
        if not agreement:
            raise ValueError(f"{case['request_id']}: exact/numerical classification mismatch")
        exact_median = statistics.median(exact_times)
        numerical_median = statistics.median(numerical_times)
        cases.append(
            {
                "request_id": case["request_id"],
                "dimension": case["dimension"],
                "agreement": "passed",
                "complex_input_diagnostics": case["complex_input_diagnostics"],
                "exact_result": exact,
                "numerical_result": numerical,
                "routes": {
                    "exact_gaussian_fmpq_pair": {
                        "times_seconds": exact_times,
                        "median_seconds": exact_median,
                        "min_seconds": min(exact_times),
                    },
                    "numerical_acb_threshold": {
                        "times_seconds": numerical_times,
                        "median_seconds": numerical_median,
                        "min_seconds": min(numerical_times),
                    },
                },
                "numerical_over_exact_median": numerical_median / exact_median,
            }
        )
    exact_is_practical = all(
        case["routes"]["exact_gaussian_fmpq_pair"]["median_seconds"] <= 5.0
        for case in cases
    )
    summary = {
        "schema": "flintnde_nlqnm_log_gate_benchmark_v1",
        "status": "passed",
        "scope": "internal test only; excluded from formal note",
        "source_path": str(template_path),
        "source_sha256": _sha256(template_path),
        "source_size_bytes": template_path.stat().st_size,
        "ConfigPath": payload.get("ConfigPath"),
        "ConventionName": payload.get("ConventionName"),
        "it0": payload.get("it0"),
        "it1": payload.get("it1"),
        "EnergyCondition": payload.get("EnergyCondition"),
        "epsilon_value": "0",
        "precision_digits": arguments.precision_digits,
        "guard_bits": arguments.guard_bits,
        "repeats_after_warmup": arguments.repeats,
        "parallel": "single process",
        "python_version": platform.python_version(),
        "python_flint_version": flint.__version__,
        "platform": platform.platform(),
        "cases": cases,
        "route_decision": (
            "prefer the exact fmpq-pair backend for certified structure because it adds no "
            "dependency beyond python-flint; retain Acb threshold as the floating-input fallback"
            if exact_is_practical
            else "exact Gaussian-rational classification is not yet practical on all tested "
            "NLQNM systems; keep numerical threshold as the operational route until the exact "
            "implementation is optimized"
        ),
        "decision_threshold_seconds": 5.0,
        "limitations": [
            "The exact Gaussian-rational pair backend is a test implementation, not yet a public package API.",
            "The comparison covers the saved NLQNM k=0 two-root semisimple residue and its order-nine resonance gate.",
            "The result does not establish performance for arbitrary spectra or irregular singularities.",
        ],
    }
    RESULTS_DIR.mkdir(parents=True, exist_ok=True)
    SUMMARY_PATH.write_text(json.dumps(summary, indent=2, ensure_ascii=False), encoding="utf-8")
    _write_markdown(summary)
    print(json.dumps(summary, indent=2, ensure_ascii=False))


if __name__ == "__main__":
    main()
