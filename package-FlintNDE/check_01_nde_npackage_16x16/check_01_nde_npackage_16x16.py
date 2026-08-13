#!/usr/bin/env python3
"""在完整 16 维端点向量层比较 FlintNDE 与 Npackage NDE 输运。

检查使用同一 OOO-232 kECep fixed-epsilon 模板、``epsilon=1/997``、Watson 边界、
路径和 22 阶截断。Npackage 通过已知 pole/residue 公式直接生成矩阵 Taylor 系数；
FlintNDE 只把矩阵当作一般解析函数，以 Cauchy-DFT 重建系数。结果在三个匹配点逐分量
比较，不执行局部 scalar contraction、epsilon 重构、Step4 或 ``Rhat`` 装配。
"""

from __future__ import annotations

import sys
import time
from pathlib import Path
from typing import Any

from flint import acb, acb_mat, arb, fmpq


CHECK_DIR = Path(__file__).resolve().parent
FLINTNDE_ROOT = CHECK_DIR.parent
PROJECT_ROOT = FLINTNDE_ROOT.parent
PACKAGE_ROOT = FLINTNDE_ROOT / "versions" / "FlintNDE-0.4.0"
if str(FLINTNDE_ROOT) not in sys.path:
    sys.path.insert(0, str(FLINTNDE_ROOT))

from check_common import (  # noqa: E402
    load_json,
    load_module,
    sha256_file,
    vector_records,
)
NPACKAGE_SCRIPT = (
    PROJECT_ROOT
    / "000_code_Npackage"
    / "v0.7"
    / "02_03_routes"
    / "eps-amflow-like"
    / "03_fixed_epsilon_de"
    / "03_run_fixed_epsilon_samples.py"
)
ROUTE_CONFIG_PATH = (
    PROJECT_ROOT
    / "000_code_Npackage"
    / "v0.7"
    / "config"
    / "eps_amflow_qnm_ooo_232_n0_odd_distinct_parents.json"
)
TEMPLATE_PATH = (
    NPACKAGE_SCRIPT.parent
    / "results"
    / "internal"
    / "full"
    / "oo2o"
    / "Npoint_qnm_ooo_232_n0_odd_distinct_parents_EC"
    / "03_fixed_epsilon_templates_oo2o.json"
)
RESULT_PATH = CHECK_DIR / "results" / "check_01_nde_npackage_16x16_summary.json"
EPSILON_EXACT = fmpq(1, 997)
RELATIVE_TOLERANCE = arb("1e-10")
CAUCHY_SAMPLE_COUNT = 64
CAUCHY_RADIUS_FRACTION = 0.50

if str(PACKAGE_ROOT) not in sys.path:
    sys.path.insert(0, str(PACKAGE_ROOT))

from flintnde import (  # noqa: E402
    AnalyticMatrixSystem,
    configure_working_precision,
    relative_difference_inf,
    transport_path as flintnde_transport_path,
)


def evaluate_pole_residue(system: Any, point: acb) -> acb_mat:
    """只按矩阵函数求值，不向 FlintNDE 暴露 pole/residue Taylor 公式。"""

    value = acb_mat(system.constant)
    for pole, residue in zip(system.poles, system.residues):
        value += residue / (point - pole)
    return value


def main() -> None:
    """执行一个 fixed-epsilon 双后端输运并保存逐匹配点比较。"""

    configure_working_precision(70, 64)
    route_config = load_json(ROUTE_CONFIG_PATH)
    template = load_json(TEMPLATE_PATH)
    if template.get("status") != "passed" or len(template.get("systems", [])) != 1:
        raise ValueError("OOO-232 template is not a single passed 16x16 system")
    system_template = template["systems"][0]
    if int(system_template["dimension"]) != 16:
        raise ValueError("selected Npackage system is not 16 dimensional")

    npackage = load_module(NPACKAGE_SCRIPT, "npackage_fixed_epsilon_nde_check")
    evaluator = npackage.EpsilonEvaluator()
    system, _projectors, _roots, _root_indices, _initials = npackage.instantiate_system(
        system_template, evaluator, acb(EPSILON_EXACT)
    )
    outer_radius = max(abs(pole) for pole in system.poles)
    k_start = acb(outer_radius / fmpq(3, 100))
    targets = [
        acb(npackage.parse_rational(value)) for value in route_config["Path"]["MatchPoints"]
    ]
    path, path_segments, target_positions = npackage.build_positive_real_path_through_targets(
        system.poles,
        k_start,
        targets,
        step_fraction=fmpq(
            int(route_config["Path"]["StepFractionNumerator"]),
            int(route_config["Path"]["StepFractionDenominator"]),
        ),
    )
    primary = route_config["NDEOrders"]["Primary"]
    boundary, boundary_seconds = npackage.watson_fixed_epsilon_boundary(
        system_template,
        epsilon=acb(EPSILON_EXACT),
        k_start=k_start,
        order=int(primary["WatsonOrder"]),
        it0=int(template["it0"]),
        it1=int(template["it1"]),
    )

    npackage_snapshots, _npackage_reports, npackage_seconds = npackage.transport_path(
        system, boundary, path, int(primary["TransportOrder"])
    )
    analytic = AnalyticMatrixSystem(
        lambda point: evaluate_pole_residue(system, point),
        system.dimension,
        tuple(system.poles),
        f"{system.request_id}-general-matrix",
    )
    flintnde_snapshots, _flintnde_reports, flintnde_seconds = flintnde_transport_path(
        analytic,
        boundary,
        path,
        order=int(primary["TransportOrder"]),
        sample_count=CAUCHY_SAMPLE_COUNT,
        radius_fraction=CAUCHY_RADIUS_FRACTION,
    )

    comparisons = []
    maximum_error = arb(0)
    for target, position in zip(targets, target_positions):
        npackage_vector = npackage_snapshots[position]
        flintnde_vector = flintnde_snapshots[position]
        error = relative_difference_inf(flintnde_vector, npackage_vector)
        maximum_error = max(maximum_error, error, key=lambda value: float(value.mid()))
        comparisons.append(
            {
                "match_point": target.str(30, radius=False),
                "path_position": position,
                "relative_difference_inf": error.str(20),
                "npackage_endpoint_vector": vector_records(npackage_vector),
                "flintnde_endpoint_vector": vector_records(flintnde_vector),
            }
        )

    status = "passed" if maximum_error < RELATIVE_TOLERANCE else "failed"
    summary = {
        "schema": "flintnde_check_nde_npackage_16x16_v1",
        "status": status,
        "scope": "16x16 NDE endpoint vectors only; no scalar contraction, Step4, or Rhat comparison",
        "ConfigPath": route_config["ConfigPath"],
        "ConventionName": template["ConventionName"],
        "it0": template["it0"],
        "it1": template["it1"],
        "EnergyCondition": template["EnergyCondition"],
        "point_name": template["point_name"],
        "request_id": system.request_id,
        "dimension": system.dimension,
        "epsilon_exact": str(EPSILON_EXACT),
        "common_input": {
            "boundary": "fixed-epsilon Watson boundary",
            "k_start": k_start.str(30),
            "path_point_count": len(path),
            "path_segment_count": len(path_segments),
            "step_fraction": "1/15",
            "match_points": route_config["Path"]["MatchPoints"],
            "WatsonOrder": primary["WatsonOrder"],
            "TransportOrder": primary["TransportOrder"],
        },
        "solver_routes": {
            "npackage": "direct Taylor coefficients from known pole/residue matrices",
            "flintnde": "general matrix evaluation with Cauchy-DFT Taylor reconstruction",
            "flintnde_cauchy_sample_count": CAUCHY_SAMPLE_COUNT,
            "flintnde_cauchy_radius_fraction": CAUCHY_RADIUS_FRACTION,
        },
        "acceptance_relative_difference_inf": "1e-10",
        "maximum_relative_difference_inf": maximum_error.str(20),
        "comparisons": comparisons,
        "timing_seconds": {
            "common_boundary": boundary_seconds,
            "npackage_transport": npackage_seconds,
            "flintnde_transport": flintnde_seconds,
            "flintnde_over_npackage": flintnde_seconds / npackage_seconds,
        },
        "sources": {
            "route_config": str(ROUTE_CONFIG_PATH.relative_to(PROJECT_ROOT)).replace("\\", "/"),
            "route_config_sha256": sha256_file(ROUTE_CONFIG_PATH),
            "fixed_epsilon_template": str(TEMPLATE_PATH.relative_to(PROJECT_ROOT)).replace("\\", "/"),
            "fixed_epsilon_template_sha256": sha256_file(TEMPLATE_PATH),
            "npackage_nde_runtime": str(NPACKAGE_SCRIPT.relative_to(PROJECT_ROOT)).replace("\\", "/"),
            "npackage_nde_runtime_sha256": sha256_file(NPACKAGE_SCRIPT),
            "flintnde_transport": "package-FlintNDE/versions/FlintNDE-0.4.0/flintnde/transport.py",
            "flintnde_transport_sha256": sha256_file(PACKAGE_ROOT / "flintnde" / "transport.py"),
        },
    }
    RESULT_PATH.parent.mkdir(parents=True, exist_ok=True)
    RESULT_PATH.write_text(
        json.dumps(summary, ensure_ascii=False, indent=2) + "\n", encoding="utf-8"
    )
    print(
        json.dumps(
            {
                "status": status,
                "maximum_relative_difference_inf": maximum_error.str(20),
                "timing_seconds": summary["timing_seconds"],
                "result": str(RESULT_PATH),
            },
            indent=2,
        )
    )
    if status != "passed":
        raise SystemExit(1)


if __name__ == "__main__":
    main()
