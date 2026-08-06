#!/usr/bin/env python3
"""在一个已认证 OOO-232 EC 点上测试 FlintNDE 的 16 维实际 kECep 输入。

本脚本只读取共享的 ``kECep_symbolic_pole_residue_template.json``，不重新生成 DE。
测试覆盖一般矩阵 Cauchy--DFT 系数、路径与 refinement 输运、epsilon=0 数值
Frobenius/log gate、最小 regulator 幂级数重构和输出布局。正式输出仅写入同级
``results_test/kECep_16x16_ooo232/summary.json``。

实现思路：先用轻量 exact Gaussian-rational 解析器把模板实例化为 Acb pole-residue
矩阵，再只通过 FlintNDE 的公开接口完成各项计算；共享 exact manifest 只作为
结构 oracle，不替代程序包自己的数值判别。
"""

from __future__ import annotations

import hashlib
import json
import re
import sys
import tempfile
import time
import warnings
from dataclasses import dataclass
from pathlib import Path
from typing import Any

from flint import acb, acb_mat, arb, fmpq


SCRIPT_DIR = Path(__file__).resolve().parent
NDES_ROOT = SCRIPT_DIR.parent
PROJECT_ROOT = NDES_ROOT.parent
PACKAGE_ROOT = NDES_ROOT / "versions" / "FlintNDE-0.1.0"
RESOURCE_INSTANCE_ROOT = (
    PROJECT_ROOT
    / "000_resource"
    / "results"
    / "iterative_de"
    / "point_instances"
    / "Npoint_qnm_ooo_232_n0_odd_distinct_parents_EC"
)
TEMPLATE_PATH = RESOURCE_INSTANCE_ROOT / "kECep_symbolic_pole_residue_template.json"
EXACT_MANIFEST_PATH = RESOURCE_INSTANCE_ROOT / "kECep_epsilon0_frobenius_manifest.json"
CONFIG_PATH = (
    PROJECT_ROOT
    / "000_code_Npackage"
    / "v0.7"
    / "config"
    / "eps_amflow_qnm_ooo_232_n0_odd_distinct_parents.json"
)
RESULT_ROOT = SCRIPT_DIR / "results_test" / "kECep_16x16_ooo232"
SUMMARY_PATH = RESULT_ROOT / "summary.json"

if str(PACKAGE_ROOT) not in sys.path:
    sys.path.insert(0, str(PACKAGE_ROOT))
sys.dont_write_bytecode = True

from flintnde import (  # noqa: E402
    AnalyticMatrixSystem,
    GaussianRational,
    NumericalRegularSingularSystem,
    RationalMatrixSystem,
    analyze_singularities,
    build_frobenius_manifest,
    build_power_log_basis,
    build_straight_path,
    configure_working_precision,
    gaussian_rational,
    initialize_output_layout,
    rational_function,
    reconstruct_series_solution,
    transport_path_refined,
)


def load_json(path: Path, label: str) -> dict[str, Any]:
    """读取必需 JSON 对象，缺文件或根类型错误时立即阻断。"""

    if not path.is_file():
        raise FileNotFoundError(f"missing {label}: {path}")
    payload = json.loads(path.read_text(encoding="utf-8-sig"))
    if not isinstance(payload, dict):
        raise ValueError(f"{label} must contain one JSON object")
    return payload


def sha256_file(path: Path) -> str:
    """流式计算输入资源哈希，固定本次测试实际消费的字节。"""

    digest = hashlib.sha256()
    with path.open("rb") as stream:
        for block in iter(lambda: stream.read(1024 * 1024), b""):
            digest.update(block)
    return digest.hexdigest()


def parse_fraction(text: str) -> fmpq:
    """把带符号整数或 ``p/q`` 转成 FLINT 精确有理数。"""

    normalized = text.strip()
    if normalized in {"", "+"}:
        return fmpq(1)
    if normalized == "-":
        return fmpq(-1)
    if "/" in normalized:
        numerator, denominator = normalized.split("/", 1)
        return fmpq(int(numerator), int(denominator))
    return fmpq(int(normalized))


def parse_exact_gaussian(value: Any) -> acb:
    """解析模板中只含有理数、``I`` 和四则乘除的 exact Gaussian rational。

    exporter 已把 epsilon 单独保存为稀疏多项式幂次，因此这里不处理符号变量，
    也不调用 SymPy 或 Python binary64。
    """

    compact = str(value).replace(" ", "").replace("(", "").replace(")", "")
    terms = re.findall(r"[+-]?[^+-]+", compact)
    if not terms or "".join(terms) != compact:
        raise ValueError(f"unsupported exact Gaussian-rational syntax: {value}")
    real = fmpq(0)
    imaginary = fmpq(0)
    for term in terms:
        if "I" in term:
            coefficient = term.replace("*I", "").replace("I", "")
            imaginary += parse_fraction(coefficient)
        else:
            real += parse_fraction(term)
    return acb(real, imaginary)


def exact_record_at_epsilon_zero(record: dict[str, Any]) -> GaussianRational:
    """在 epsilon=0 精确求一个模板有理函数，不经过 Acb。"""

    numerator = GaussianRational()
    denominator = GaussianRational()
    for term in record["numerator_terms"]:
        if int(term["epsilon_power"]) == 0:
            numerator += gaussian_rational(term["coefficient_exact"])
    for term in record["denominator_terms"]:
        if int(term["epsilon_power"]) == 0:
            denominator += gaussian_rational(term["coefficient_exact"])
    return numerator / denominator


def exact_matrix_at_epsilon_zero(
    records: list[list[dict[str, Any]]],
) -> list[list[GaussianRational]]:
    """把模板二维记录恢复为 epsilon=0 的精确 Q(i) 矩阵。"""

    return [[exact_record_at_epsilon_zero(record) for record in row] for row in records]


def build_exact_rational_matrix_system(
    system_template: dict[str, Any],
) -> RationalMatrixSystem:
    """把 pole-residue payload 合成为通用 Q(i)(k) 有理函数矩阵。"""

    dimension = int(system_template["dimension"])
    poles = [gaussian_rational(value) for value in system_template["poles_exact"]]
    constant = exact_matrix_at_epsilon_zero(system_template["constant_matrix_entries"])
    residues = [
        exact_matrix_at_epsilon_zero(records)
        for records in system_template["residue_matrix_entries"]
    ]
    entries = []
    for row in range(dimension):
        output_row = []
        for column in range(dimension):
            entry = rational_function(constant[row][column])
            for pole, residue in zip(poles, residues):
                if not residue[row][column].is_zero:
                    entry += rational_function(residue[row][column], (-pole, 1))
            output_row.append(entry)
        entries.append(tuple(output_row))
    return RationalMatrixSystem(
        tuple(entries),
        variable_name="k",
        name="kECep-OOO232-epsilon0-exact-Qi",
    )


@dataclass(frozen=True)
class CompiledTerm:
    """保存 epsilon 有理函数的一项。"""

    power: int
    coefficient: acb


@dataclass(frozen=True)
class CompiledRational:
    """保存已经解析的 epsilon 分子、分母稀疏多项式。"""

    numerator: tuple[CompiledTerm, ...]
    denominator: tuple[CompiledTerm, ...]


class TemplateEvaluator:
    """缓存 exact 常数和 epsilon-rational 记录，避免四个样本重复解析。"""

    def __init__(self) -> None:
        self._scalar_cache: dict[str, acb] = {}
        self._record_cache: dict[int, CompiledRational] = {}

    def exact(self, value: Any) -> acb:
        """返回 exact Gaussian-rational Acb 值。"""

        key = str(value)
        if key not in self._scalar_cache:
            self._scalar_cache[key] = parse_exact_gaussian(key)
        return self._scalar_cache[key]

    def compile(self, record: dict[str, Any]) -> CompiledRational:
        """编译一个模板记录，并按对象身份缓存。"""

        identity = id(record)
        cached = self._record_cache.get(identity)
        if cached is not None:
            return cached

        def terms(field: str) -> tuple[CompiledTerm, ...]:
            return tuple(
                CompiledTerm(int(term["epsilon_power"]), self.exact(term["coefficient_exact"]))
                for term in record[field]
            )

        compiled = CompiledRational(terms("numerator_terms"), terms("denominator_terms"))
        self._record_cache[identity] = compiled
        return compiled

    def evaluate(self, record: dict[str, Any], epsilon: acb) -> acb:
        """在一个非奇异 epsilon 值上计算模板有理函数。"""

        compiled = self.compile(record)

        def polynomial(terms: tuple[CompiledTerm, ...]) -> acb:
            return sum(
                (term.coefficient * epsilon**term.power for term in terms),
                acb(0),
            )

        denominator = polynomial(compiled.denominator)
        if abs(denominator).contains(0):
            raise ZeroDivisionError("epsilon sample hits a template denominator zero")
        return polynomial(compiled.numerator) / denominator

    def matrix(self, records: list[list[dict[str, Any]]], epsilon: acb) -> acb_mat:
        """实例化一个稠密 epsilon-rational 矩阵。"""

        return acb_mat(
            [[self.evaluate(record, epsilon) for record in row] for row in records]
        )


@dataclass(frozen=True)
class PoleResidueInstance:
    """保存固定 epsilon 的实际 16 维 pole-residue 系统。"""

    epsilon: acb
    poles: tuple[acb, ...]
    constant: acb_mat
    residues: tuple[acb_mat, ...]
    zero_pole_position: int
    name: str

    @property
    def dimension(self) -> int:
        """返回矩阵维数。"""

        return self.constant.nrows()

    def evaluate(self, point: acb) -> acb_mat:
        """计算 ``C + sum R_p/(k-p)``。"""

        value = acb_mat(self.constant)
        for pole, residue in zip(self.poles, self.residues):
            if abs(point - pole).contains(0):
                raise ZeroDivisionError(f"evaluation point hits pole {pole}")
            value += residue / (point - pole)
        return value

    def direct_taylor_coefficients(self, center: acb, order: int) -> list[acb_mat]:
        """用已知 pole-residue 恒等式生成独立 Taylor coefficient oracle。"""

        coefficients: list[acb_mat] = []
        for degree in range(order):
            coefficient = acb_mat(self.constant) if degree == 0 else acb_mat(
                self.dimension, self.dimension
            )
            for pole, residue in zip(self.poles, self.residues):
                coefficient += residue * ((-1) ** degree) / (center - pole) ** (degree + 1)
            coefficients.append(coefficient)
        return coefficients

    def laurent_at_zero(self, order: int) -> tuple[acb_mat, list[acb_mat]]:
        """返回 k=0 residue 和解析部分的前 ``order`` 项。"""

        residue_zero = acb_mat(self.residues[self.zero_pole_position])
        regular: list[acb_mat] = []
        for degree in range(order):
            coefficient = acb_mat(self.constant) if degree == 0 else acb_mat(
                self.dimension, self.dimension
            )
            for index, (pole, residue) in enumerate(zip(self.poles, self.residues)):
                if index != self.zero_pole_position:
                    coefficient -= residue / pole ** (degree + 1)
            regular.append(coefficient)
        return residue_zero, regular

    def analytic_system(self) -> AnalyticMatrixSystem:
        """适配为 FlintNDE 的一般解析矩阵公开接口。"""

        return AnalyticMatrixSystem(
            self.evaluate,
            self.dimension,
            self.poles,
            self.name,
        )


def instantiate_system(
    system_template: dict[str, Any], evaluator: TemplateEvaluator, epsilon: acb
) -> PoleResidueInstance:
    """在一个 epsilon 样本上实例化共享 16 维模板。"""

    required_gates = (
        "exact_pole_residue_identity",
        "exact_k0_minimal_polynomial_identity",
        "exact_k0_projector_identities",
        "exact_k0_eigenbasis_identity",
    )
    for field in required_gates:
        if system_template.get(field) is not True:
            raise ValueError(f"shared template lacks exact gate {field}")
    poles = tuple(evaluator.exact(value) for value in system_template["poles_exact"])
    zero_position = int(system_template["zero_pole_position_zero_based"])
    if [index for index, pole in enumerate(poles) if abs(pole).contains(0)] != [zero_position]:
        raise ValueError("saved zero pole position does not match the pole list")
    constant = evaluator.matrix(system_template["constant_matrix_entries"], epsilon)
    residues = tuple(
        evaluator.matrix(matrix, epsilon)
        for matrix in system_template["residue_matrix_entries"]
    )
    return PoleResidueInstance(
        epsilon,
        poles,
        constant,
        residues,
        zero_position,
        f"kECep-OOO232-epsilon-{epsilon.str(20, radius=False)}",
    )


def matrix_row_norm(matrix: acb_mat) -> arb:
    """返回 Acb 矩阵最大行和范数。"""

    return max(
        (
            sum((abs(matrix[row, column]) for column in range(matrix.ncols())), arb(0))
            for row in range(matrix.nrows())
        ),
        default=arb(0),
        key=lambda value: float(value.mid()),
    )


def relative_matrix_difference(left: acb_mat, right: acb_mat) -> arb:
    """计算两个矩阵的最大行和相对差。"""

    denominator = matrix_row_norm(right)
    if denominator.contains(0):
        raise ZeroDivisionError("matrix reference norm contains zero")
    return matrix_row_norm(left - right) / denominator


def matrix_to_records(matrix: acb_mat) -> list[list[acb]]:
    """把 Acb 矩阵转换为数值 Frobenius 接口接受的二维记录。"""

    return [
        [matrix[row, column] for column in range(matrix.ncols())]
        for row in range(matrix.nrows())
    ]


def vector_records(vector: acb_mat) -> list[dict[str, str]]:
    """保存列向量中点与 ball，避免降到 binary64。"""

    return [
        {
            "real": vector[row, 0].real.str(35, radius=False),
            "imag": vector[row, 0].imag.str(35, radius=False),
            "real_ball": vector[row, 0].real.str(20),
            "imag_ball": vector[row, 0].imag.str(20),
        }
        for row in range(vector.nrows())
    ]


def main() -> None:
    """运行单点测试，并写出轻量、可复核的功能与耗时摘要。"""

    total_clock = time.perf_counter()
    configure_working_precision(70, 64)
    payload = load_json(TEMPLATE_PATH, "kECep template")
    exact_manifest = load_json(EXACT_MANIFEST_PATH, "epsilon=0 Frobenius manifest")
    config = load_json(CONFIG_PATH, "consumer config")
    if payload.get("status") != "passed" or len(payload.get("systems", [])) != 1:
        raise ValueError("shared kECep payload is not a single passed system")
    system_template = payload["systems"][0]
    if int(system_template["dimension"]) != 16:
        raise ValueError("selected kECep system is not 16 dimensional")
    if payload["point_name"] != exact_manifest["point_name"]:
        raise ValueError("template and exact Frobenius manifest point mismatch")

    evaluator = TemplateEvaluator()
    timings: dict[str, float] = {}
    checks: dict[str, Any] = {}

    # 一档已记录 probe epsilon 足以检查实际矩阵的普通点功能。
    probe_epsilon = acb(fmpq(1, 997))
    clock = time.perf_counter()
    probe = instantiate_system(system_template, evaluator, probe_epsilon)
    timings["instantiate_probe_system_seconds"] = time.perf_counter() - clock
    center = acb(fmpq(1, 5))
    target = acb(fmpq(19, 100))
    analytic = probe.analytic_system()
    nearest_radius = analytic.nearest_singularity_distance(center)
    path = build_straight_path(analytic, center, target, step_fraction=0.20)
    checks["system_identity"] = {
        "status": "passed",
        "dimension": probe.dimension,
        "pole_count": len(probe.poles),
        "zero_pole_position_zero_based": probe.zero_pole_position,
        "center": center.str(30, radius=False),
        "target": target.str(30, radius=False),
        "nearest_singularity_distance_at_center": nearest_radius.str(30),
        "generated_path_point_count": len(path),
    }

    clock = time.perf_counter()
    cauchy_coefficients = analytic.taylor_matrix_coefficients(
        center,
        6,
        radius=acb(nearest_radius * arb("0.4")),
        sample_count=48,
    )
    timings["cauchy_dft_coefficients_seconds"] = time.perf_counter() - clock
    direct_coefficients = probe.direct_taylor_coefficients(center, 6)
    coefficient_errors = [
        relative_matrix_difference(cauchy, direct)
        for cauchy, direct in zip(cauchy_coefficients, direct_coefficients)
    ]
    maximum_coefficient_error = max(
        coefficient_errors, key=lambda value: float(value.mid())
    )
    checks["general_matrix_cauchy_dft"] = {
        "status": "passed" if maximum_coefficient_error < arb("1e-18") else "failed",
        "acceptance_tolerance": "1e-18",
        "order": 6,
        "sample_count": 48,
        "radius_over_nearest_singularity": "0.4",
        "relative_errors_by_degree": [value.str(20) for value in coefficient_errors],
        "maximum_relative_error": maximum_coefficient_error.str(20),
    }

    initial = acb_mat(16, 1)
    initial[0, 0] = 1
    refined = transport_path_refined(
        analytic,
        initial,
        path,
        primary_order=8,
        reference_order=12,
        primary_sample_count=32,
        reference_sample_count=40,
        radius_fraction=0.40,
    )
    timings["transport_primary_seconds"] = refined["primary_seconds"]
    timings["transport_reference_seconds"] = refined["reference_seconds"]
    transport_error = refined["relative_difference_inf"]
    checks["ordinary_path_and_refined_transport"] = {
        "status": "passed" if transport_error < arb("1e-8") else "failed",
        "path": [point.str(30, radius=False) for point in path],
        "primary_order": 8,
        "reference_order": 12,
        "relative_difference_inf": transport_error.str(20),
        "endpoint_reference": vector_records(refined["reference_snapshots"][-1]),
    }

    # epsilon=0 是共享 exact manifest 已认证存在整数差共振和 log 的点。
    clock = time.perf_counter()
    epsilon_zero = instantiate_system(system_template, evaluator, acb(0))
    residue_zero, regular_zero = epsilon_zero.laurent_at_zero(10)
    numerical_system = NumericalRegularSingularSystem(
        matrix_to_records(residue_zero),
        tuple(matrix_to_records(matrix) for matrix in regular_zero),
        name="kECep-OOO232-epsilon0-numerical",
        input_precision_digits=70,
    )
    with warnings.catch_warnings(record=True) as captured_warnings:
        warnings.simplefilter("always")
        numerical_manifest = build_frobenius_manifest(numerical_system)
    timings["numerical_frobenius_manifest_seconds"] = time.perf_counter() - clock
    root_midpoints = [
        (
            record["real"],
            record["imag"],
        )
        for record in numerical_manifest["roots_numeric"]
    ]
    active_gates = sum(bool(value) for value in numerical_manifest["resonance_gates"].values())
    frobenius_matches_oracle = (
        numerical_manifest["root_multiplicities"] == exact_manifest["root_multiplicities"]
        and numerical_manifest["geometric_multiplicities"]
        == exact_manifest["geometric_multiplicities"]
        and int(numerical_manifest["maximum_log_degree"])
        == int(exact_manifest["maximum_log_degree"])
        and active_gates == int(exact_manifest["strict_nonzero_resonance_gate_count"])
    )
    checks["numerical_indicial_resonance_log_gate"] = {
        "status": "passed" if frobenius_matches_oracle else "failed",
        "roots_numeric": root_midpoints,
        "root_multiplicities": numerical_manifest["root_multiplicities"],
        "geometric_multiplicities": numerical_manifest["geometric_multiplicities"],
        "maximum_log_degree": numerical_manifest["maximum_log_degree"],
        "active_resonance_gate_count": active_gates,
        "exact_oracle": {
            "roots_exact": exact_manifest["roots_exact"],
            "root_multiplicities": exact_manifest["root_multiplicities"],
            "geometric_multiplicities": exact_manifest["geometric_multiplicities"],
            "maximum_log_degree": exact_manifest["maximum_log_degree"],
            "strict_nonzero_resonance_gate_count": exact_manifest[
                "strict_nonzero_resonance_gate_count"
            ],
        },
        "numeric_diagnostics": numerical_manifest["numeric_diagnostics"],
        "warnings": [str(item.message) for item in captured_warnings],
    }

    clock = time.perf_counter()
    basis = build_power_log_basis(numerical_system, numerical_manifest, series_order=10)
    basis_value = basis.evaluate(acb(fmpq(4, 25)))
    identity = acb_mat([[1 if row == column else 0 for column in range(16)] for row in range(16)])
    inverse_residual = relative_matrix_difference(basis_value * basis_value.inv(), identity)
    timings["power_log_basis_build_and_evaluate_seconds"] = time.perf_counter() - clock
    checks["power_log_basis"] = {
        "status": "passed" if inverse_residual < arb("1e-20") else "failed",
        "series_order": 10,
        "evaluation_point": "4/25",
        "maximum_log_degree": basis.maximum_log_degree,
        "inverse_identity_relative_residual": inverse_residual.str(20),
    }

    # 三个生产样本加一个独立点，只验证外层重构接口，不做正式物理 finite part。
    def system_factory(epsilon: Any) -> AnalyticMatrixSystem:
        """把 exact regulator 样本实例化为同一物理点的实际 16 维 DE。"""

        return instantiate_system(system_template, evaluator, acb(epsilon)).analytic_system()

    clock = time.perf_counter()
    reconstruction = reconstruct_series_solution(
        DEmatrix=system_factory,
        boundary=initial,
        path=[center, target],
        maximum_power=1,
        goal_digits=6,
        sample_points=("1/200000", "11/2000000", "3/500000"),
        leading_power=0,
        working_precision_digits=70,
        transport_order=8,
        transport_extra_order=4,
        transport_sample_count=32,
        transport_extra_sample_count=40,
        radius_fraction=0.40,
        validation_sample_count=1,
        validation_scale="1/2",
        validation_tolerance="1e-6",
        maximum_samples=10,
    )
    timings["series_reconstruction_total_seconds"] = time.perf_counter() - clock
    checks["series_solution_reconstruction"] = {
        "status": "passed",
        "production_sample_count": len(reconstruction.sample_points),
        "validation_sample_count": len(reconstruction.validation_points),
        "leading_power": reconstruction.leading_power,
        "maximum_power": reconstruction.maximum_power,
        "internal_maximum_power": reconstruction.internal_maximum_power,
        "validation_relative_residual": reconstruction.diagnostics["validation_solves"][0][
            "series_relative_residual"
        ],
        "least_squares_used": reconstruction.diagnostics["least_squares_used"],
    }

    # 输出布局在临时 caller 上检查，避免把单元测试产物写入正式 results/。
    with tempfile.TemporaryDirectory() as temporary_directory:
        caller = Path(temporary_directory) / "kECep_test_caller.py"
        caller.write_text("# temporary caller\n", encoding="utf-8")
        layout = initialize_output_layout(caller, run_name="kECep_16x16")
        test_output = layout.write_json("summary", "smoke.json", {"dimension": 16})
        output_layout_passed = test_output.is_file() and test_output.parent.name == "summary"
    checks["caller_local_output_layout"] = {
        "status": "passed" if output_layout_passed else "failed",
        "temporary_output_removed_after_check": True,
    }

    # 用通用 Q(i)(k) 矩阵入口重建同一个 epsilon=0 系统，不调用专用 pole-residue API。
    clock = time.perf_counter()
    exact_system = build_exact_rational_matrix_system(system_template)
    timings["exact_gaussian_rational_system_build_seconds"] = time.perf_counter() - clock
    clock = time.perf_counter()
    exact_inventory = analyze_singularities(exact_system, root_tolerance=1.0e-40)
    timings["exact_gaussian_singularity_inventory_seconds"] = time.perf_counter() - clock
    exact_matrix_error = relative_matrix_difference(
        exact_system.evaluate(center),
        epsilon_zero.evaluate(center),
    )
    clock = time.perf_counter()
    exact_local_system = exact_system.regular_singular_system_at(0, 10)
    exact_package_manifest = build_frobenius_manifest(exact_local_system)
    timings["exact_gaussian_frobenius_manifest_seconds"] = time.perf_counter() - clock
    exact_active_gates = sum(
        bool(value) for value in exact_package_manifest["resonance_gates"].values()
    )
    exact_matches_oracle = (
        exact_package_manifest["roots_exact"] == exact_manifest["roots_exact"]
        and exact_package_manifest["root_multiplicities"]
        == exact_manifest["root_multiplicities"]
        and exact_package_manifest["geometric_multiplicities"]
        == exact_manifest["geometric_multiplicities"]
        and int(exact_package_manifest["maximum_log_degree"])
        == int(exact_manifest["maximum_log_degree"])
        and exact_active_gates
        == int(exact_manifest["strict_nonzero_resonance_gate_count"])
    )
    clock = time.perf_counter()
    exact_basis = build_power_log_basis(
        exact_local_system,
        exact_package_manifest,
        series_order=10,
    )
    exact_basis_value = exact_basis.evaluate(acb(fmpq(4, 25)))
    exact_basis_residual = relative_matrix_difference(
        exact_basis_value * exact_basis_value.inv(),
        identity,
    )
    timings["exact_gaussian_power_log_basis_seconds"] = time.perf_counter() - clock
    exact_passed = (
        len(exact_inventory.finite) == len(epsilon_zero.poles)
        and exact_matrix_error < arb("1e-55")
        and exact_matches_oracle
        and exact_basis_residual < arb("1e-55")
    )
    checks["exact_gaussian_rational_routing"] = {
        "status": "passed" if exact_passed else "failed",
        "input_interface": "general RationalMatrixSystem over Q(i)(k)",
        "matrix_dimension": exact_system.dimension,
        "finite_singularity_count": len(exact_inventory.finite),
        "finite_singularities_exact": [
            record.location_exact for record in exact_inventory.finite
        ],
        "infinity_classification": exact_inventory.infinity.kind,
        "ordinary_point_matrix_relative_error": exact_matrix_error.str(20),
        "roots_exact": exact_package_manifest["roots_exact"],
        "root_multiplicities": exact_package_manifest["root_multiplicities"],
        "geometric_multiplicities": exact_package_manifest["geometric_multiplicities"],
        "maximum_log_degree": exact_package_manifest["maximum_log_degree"],
        "active_resonance_gate_count": exact_active_gates,
        "power_log_inverse_identity_relative_residual": exact_basis_residual.str(20),
    }

    required_checks = [
        "system_identity",
        "general_matrix_cauchy_dft",
        "ordinary_path_and_refined_transport",
        "numerical_indicial_resonance_log_gate",
        "power_log_basis",
        "series_solution_reconstruction",
        "caller_local_output_layout",
        "exact_gaussian_rational_routing",
    ]
    supported_passed = all(checks[name]["status"] == "passed" for name in required_checks)
    overall_status = "passed" if supported_passed else "failed"
    timings["total_seconds"] = time.perf_counter() - total_clock
    summary = {
        "schema": "flintnde_kECep_16x16_single_point_test_v1",
        "status": overall_status,
        "scope": "one physical EC point; one probe epsilon; epsilon=0 structure; 3+1 reconstruction samples",
        "physical_point": {
            "point_name": payload["point_name"],
            "channel": payload["channel"],
            "EnergyCondition": payload["EnergyCondition"],
            "request_id": system_template["request_id"],
            "dimension": system_template["dimension"],
            "numeric_point": system_template["numeric_point"],
        },
        "configuration": {
            "ConfigPath": config["ConfigPath"],
            "ConventionName": payload["ConventionName"],
            "it0": payload["it0"],
            "it1": payload["it1"],
            "probe_epsilon": "1/997",
            "working_decimal_digits": 70,
            "guard_bits": 64,
        },
        "inputs": {
            "template": str(TEMPLATE_PATH.relative_to(PROJECT_ROOT)).replace("\\", "/"),
            "template_sha256": sha256_file(TEMPLATE_PATH),
            "exact_manifest": str(EXACT_MANIFEST_PATH.relative_to(PROJECT_ROOT)).replace("\\", "/"),
            "exact_manifest_sha256": sha256_file(EXACT_MANIFEST_PATH),
        },
        "checks": checks,
        "timings": timings,
    }
    RESULT_ROOT.mkdir(parents=True, exist_ok=True)
    SUMMARY_PATH.write_text(
        json.dumps(summary, ensure_ascii=False, indent=2) + "\n",
        encoding="utf-8",
    )
    print(json.dumps({"status": overall_status, "summary": str(SUMMARY_PATH), "timings": timings}, indent=2))
    if not supported_passed:
        raise SystemExit(1)


if __name__ == "__main__":
    main()
