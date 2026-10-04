"""FlintNDE 0.5.0 高阶 pole、指数局部解和 fail-closed 独立验证。

可执行 expected 分别来自 ``y2=2, y1=-2/x-1`` 与 ``y=3 exp(-1/x)``。
反例独立指定 nilpotent defective 高阶项、非 Q(i) indicial 根和缺 Stokes connection
的形式渐近块，要求在未知跨奇点输运开始前停止。
"""

from __future__ import annotations

import hashlib
import json
import os
import shutil
import sys
import time
import warnings
from pathlib import Path
from typing import Any


CASE_ROOT = Path(__file__).resolve().parent
PACKAGE_ROOT = CASE_ROOT.parents[1]
VERSION_ROOT = PACKAGE_ROOT / "versions" / "FlintNDE-0.5.0"
RESULTS_ROOT = CASE_ROOT / "results"
TEMP_ROOT = CASE_ROOT / "results_temp"
REPORT_PATH = CASE_ROOT / "000_FlintNDE-0.5.0-validation-04-report.md"


def fresh_output() -> None:
    """删除本 case 的旧输出。"""

    for directory in (RESULTS_ROOT, TEMP_ROOT):
        if directory.exists():
            shutil.rmtree(directory)
    if REPORT_PATH.exists():
        REPORT_PATH.unlink()
    RESULTS_ROOT.mkdir(parents=True)
    TEMP_ROOT.mkdir(parents=True)


def source_digest() -> str:
    """生成当前 FlintNDE Python 源码聚合哈希。"""

    digest = hashlib.sha256()
    for path in sorted((VERSION_ROOT / "flintnde").glob("*.py")):
        digest.update(path.name.encode("utf-8"))
        digest.update(path.read_bytes())
    return digest.hexdigest()


def text_ball(value: Any, digits: int = 50) -> str:
    """稳定保存 Acb/Arb 球。"""

    return value.str(digits)


def vector_errors(vector: Any, expected: list[Any]) -> list[Any]:
    """返回列向量对独立闭式 expected 的逐分量绝对误差球。"""

    return [abs(vector[index, 0] - expected[index]) for index in range(len(expected))]


def main() -> int:
    """执行两条支持路线和三类 fail-closed 路线。"""

    fresh_output()
    os.environ["FLINTNDE_SUPPRESS_CITATION_NOTICE"] = "1"
    sys.path.insert(0, str(VERSION_ROOT))

    from flint import acb, acb_mat
    from flintnde import (
        LocalReductionError,
        NamedPoint,
        RationalMatrixSystem,
        attempt_fuchsian_reduction,
        build_adaptive_path,
        build_adaptive_path_plan,
        build_local_solution_basis,
        configure_working_precision,
        exponential_boundary,
        rational_function,
        transport_path_refined,
    )

    configure_working_precision(90, 50)
    primary_order = 40
    reference_order = 56
    target_error = "1e-22"
    started = time.perf_counter()

    # 独立正向模型 A=[[0,x^-2],[0,0]]，闭式为 y2=2, y1=-2/x-1。
    inverse_square = rational_function(1, [0, 0, 1])
    apparent_system = RationalMatrixSystem(
        ((0, inverse_square), (0, 0)),
        variable_name="x",
        name="independent-apparent-double-pole",
    )
    reduction = attempt_fuchsian_reduction(apparent_system, 0)
    restored = reduction.transformation.restore_system(reduction.transformed_system)
    exact_system_round_trip = all(
        (restored.entries[row][column] - apparent_system.entries[row][column]).is_zero
        for row in range(apparent_system.dimension)
        for column in range(apparent_system.dimension)
    )
    with warnings.catch_warnings():
        warnings.simplefilter("ignore")
        apparent_path = build_adaptive_path(
            apparent_system,
            NamedPoint("left", -1),
            NamedPoint("right", 1),
            max_step_over_radius=0.25,
            singularity_mode="singularity_jump",
        )
    apparent_result = transport_path_refined(
        apparent_system,
        acb_mat([[1], [2]]),
        apparent_path,
        primary_order=primary_order,
        reference_order=reference_order,
        primary_sample_count=128,
        reference_sample_count=160,
        target_relative_error=target_error,
        certification_mode="certified",
    )
    apparent_expected = [acb(-3), acb(2)]
    apparent_primary_errors = vector_errors(
        apparent_result["primary_snapshots"][-1], apparent_expected
    )
    apparent_reference_errors = vector_errors(
        apparent_result["reference_snapshots"][-1], apparent_expected
    )

    # 标量 y'=x^-2 y 的闭式为 y=C exp(-1/x)，phi 必须精确为 -x^-1。
    exponential_system = RationalMatrixSystem(
        ((inverse_square,),),
        variable_name="x",
        name="independent-scalar-exponential",
    )
    exponential_basis = build_local_solution_basis(exponential_system, 0, reference_order)
    exponential_input = exponential_boundary(
        [{"phi": [{"power": -1, "coefficient": -1}], "a": 0, "b": 0, "C": [3]}]
    )
    constants, boundary_report = exponential_basis.resolve_boundary(exponential_input)
    basis_at_one = exponential_basis.evaluate(acb(1)) * constants.to_acb()
    with warnings.catch_warnings():
        warnings.simplefilter("ignore")
        exponential_path = build_adaptive_path(
            exponential_system,
            NamedPoint("irregular_start", 0),
            NamedPoint("ordinary_target", 1),
            max_step_over_radius=0.25,
        )
    exponential_result = transport_path_refined(
        exponential_system,
        exponential_input,
        exponential_path,
        primary_order=64,
        reference_order=88,
        primary_sample_count=192,
        reference_sample_count=256,
        target_relative_error=target_error,
        certification_mode="certified",
    )
    exponential_expected = acb(3) * (-acb(1)).exp()
    exponential_primary_error = abs(
        exponential_result["primary_snapshots"][-1][0, 0] - exponential_expected
    )
    exponential_reference_error = abs(
        exponential_result["reference_snapshots"][-1][0, 0] - exponential_expected
    )
    exponential_basis_error = abs(basis_at_one[0, 0] - exponential_expected)
    exponential_sector_signature = boundary_report["term_resolutions"][0]["exponential"]

    # k=0 的 nilpotent 二阶项与反向 simple-pole 耦合形成 defective block。
    defective_system = RationalMatrixSystem(
        ((0, inverse_square), (rational_function(1, [0, 1]), 0)),
        variable_name="x",
        name="independent-defective-zero-k",
    )
    defective_error = ""
    try:
        build_local_solution_basis(defective_system, 0, 16)
    except LocalReductionError as error:
        defective_error = str(error)
    with warnings.catch_warnings():
        warnings.simplefilter("ignore")
        defective_plan = build_adaptive_path_plan(
            defective_system,
            NamedPoint("left", -1),
            NamedPoint("right", 1),
            max_step_over_radius=0.25,
            singularity_mode="singularity_jump",
        )

    # residue [[0,1],[2,0]]/x 的 indicial roots 为 +/-sqrt(2)，不属于 Q(i)。
    inverse_x = rational_function(1, [0, 1])
    algebraic_system = RationalMatrixSystem(
        ((0, inverse_x), (2 * inverse_x, 0)),
        variable_name="x",
        name="independent-algebraic-indicial-roots",
    )
    algebraic_error = ""
    try:
        build_local_solution_basis(algebraic_system, 0, 16)
    except (LocalReductionError, ValueError) as error:
        algebraic_error = str(error)
    with warnings.catch_warnings():
        warnings.simplefilter("ignore")
        algebraic_plan = build_adaptive_path_plan(
            algebraic_system,
            NamedPoint("left", -1),
            NamedPoint("right", 1),
            max_step_over_radius=0.25,
            singularity_mode="singularity_jump",
        )

    # 两指数 sector 的低阶耦合只有 start-only formal basis，跨点必须要求 Stokes 数据。
    formal_system = RationalMatrixSystem(
        ((inverse_square, 1), (0, -inverse_square)),
        variable_name="x",
        name="independent-formal-start-only",
    )
    formal_basis = build_local_solution_basis(formal_system, 0, 24)
    formal_boundary = exponential_boundary(
        [{"phi": [{"power": -1, "coefficient": 1}], "a": 0, "b": 0, "C": [0, 1]}]
    )
    formal_constants, formal_boundary_report = formal_basis.resolve_boundary(formal_boundary)
    formal_start_value = formal_basis.evaluate(acb("1/20")) * formal_constants.to_acb()
    internal_error = ""
    target_error_text = ""
    try:
        with warnings.catch_warnings():
            warnings.simplefilter("ignore")
            build_adaptive_path(
                formal_system,
                NamedPoint("left", -1),
                NamedPoint("right", 1),
                max_step_over_radius=0.25,
                singularity_mode="singularity_jump",
            )
    except LocalReductionError as error:
        internal_error = str(error)
    try:
        with warnings.catch_warnings():
            warnings.simplefilter("ignore")
            build_adaptive_path(
                formal_system,
                NamedPoint("ordinary", 1),
                NamedPoint("formal_target", 0),
                max_step_over_radius=0.25,
                singularity_mode="singularity_jump",
            )
    except LocalReductionError as error:
        target_error_text = str(error)

    elapsed = time.perf_counter() - started
    checks = {
        "apparentPoleOrderTwo": reduction.original_pole_order == 2,
        "leeMoserReducedToSimplePole": reduction.status == "reduced_to_fuchsian"
        and reduction.reduced_pole_order == 1,
        "leeMoserExactSystemRoundTrip": exact_system_round_trip,
        "leeMoserProjectorsExact": all(
            reduction.transformation.to_json()["projector_idempotency_exact"]
        ),
        "apparentPrimaryClosedForm": max(float(error.mid()) for error in apparent_primary_errors)
        < 1.0e-12,
        "apparentReferenceClosedForm": max(
            float(error.mid()) for error in apparent_reference_errors
        )
        < 1.0e-15,
        "exponentialMethodAndPhi": exponential_basis.method == "exponential_power_log"
        and exponential_basis.continuation_ready
        and len(exponential_sector_signature) == 1
        and exponential_sector_signature[0]["matrix_power"] == -2
        and exponential_sector_signature[0]["phi_power"] == -1
        and exponential_sector_signature[0]["phi_coefficient"] == "-1"
        and exponential_sector_signature[0]["derivative_coefficient"] == "1",
        "exponentialLocalBasisClosedForm": float(exponential_basis_error.mid()) < 1.0e-15,
        "exponentialPrimaryClosedForm": float(exponential_primary_error.mid()) < 1.0e-12,
        "exponentialReferenceClosedForm": float(exponential_reference_error.mid()) < 1.0e-15,
        "defectiveFailsClosed": "defective" in defective_error.lower()
        and not defective_plan.continuation_ready
        and any("defective" in message.lower() for message in defective_plan.messages),
        "algebraicExtensionFailsClosed": algebraic_error != ""
        and not algebraic_plan.continuation_ready
        and any(
            token in (algebraic_error + " " + " ".join(algebraic_plan.messages)).lower()
            for token in ("q(i)", "algebraic", "unsupported")
        ),
        "formalStartOnlyConstructed": formal_basis.method == "formal_exponential_asymptotic"
        and not formal_basis.continuation_ready
        and formal_start_value.nrows() == 2
        and formal_boundary_report["term_resolutions"],
        "formalInternalRequiresStokes": "stokes" in internal_error.lower(),
        "formalTargetRequiresStokes": "stokes" in target_error_text.lower(),
    }
    checks = {name: bool(value) for name, value in checks.items()}
    passed_count = sum(value is True for value in checks.values())
    status = "passed" if passed_count == len(checks) else "failed"
    summary = {
        "schema": "flintnde_0.5.0_validation_04_v1",
        "status": status,
        "passedCount": passed_count,
        "checkCount": len(checks),
        "sourceDigestSHA256": source_digest(),
        "settings": {
            "workingPrecisionDigits": 90,
            "apparentPrimaryOrder": primary_order,
            "apparentReferenceOrder": reference_order,
            "exponentialPrimaryOrder": 64,
            "exponentialReferenceOrder": 88,
            "targetRelativeError": target_error,
        },
        "apparentHighPole": {
            "exactModel": "y2=2; y1=-2/x-1; y(-1)=(1,2); y(1)=(-3,2)",
            "reduction": reduction.to_json(),
            "exactSystemRoundTrip": exact_system_round_trip,
            "path": [point.str(40) for point in apparent_path],
            "primaryErrors": [text_ball(error) for error in apparent_primary_errors],
            "referenceErrors": [text_ball(error) for error in apparent_reference_errors],
            "primarySeconds": apparent_result["primary_seconds"],
            "referenceSeconds": apparent_result["reference_seconds"],
        },
        "exponentialStart": {
            "exactModel": "y=3 exp(-1/x); y(1)=3/e",
            "method": exponential_basis.method,
            "continuationReady": exponential_basis.continuation_ready,
            "manifest": exponential_basis.manifest,
            "boundary": boundary_report,
            "path": [point.str(40) for point in exponential_path],
            "basisError": text_ball(exponential_basis_error),
            "primaryError": text_ball(exponential_primary_error),
            "referenceError": text_ball(exponential_reference_error),
            "primarySeconds": exponential_result["primary_seconds"],
            "referenceSeconds": exponential_result["reference_seconds"],
        },
        "failClosed": {
            "defective": {
                "error": defective_error,
                "continuationReady": defective_plan.continuation_ready,
                "messages": list(defective_plan.messages),
            },
            "algebraicIndicialRoots": {
                "error": algebraic_error,
                "continuationReady": algebraic_plan.continuation_ready,
                "messages": list(algebraic_plan.messages),
            },
            "formalStartOnly": {
                "method": formal_basis.method,
                "continuationReady": formal_basis.continuation_ready,
                "boundary": formal_boundary_report,
                "internalError": internal_error,
                "targetError": target_error_text,
            },
        },
        "checks": checks,
        "wallTimeSeconds": elapsed,
    }
    (RESULTS_ROOT / "summary.json").write_text(
        json.dumps(summary, ensure_ascii=False, indent=2) + "\n", encoding="utf-8", newline="\n"
    )

    failed = [name for name, value in checks.items() if value is not True]
    report = "\n".join(
        [
            "# FlintNDE 0.5.0 Validation-04 独立报告",
            "",
            f"- 状态：**{status}**，{passed_count}/{len(checks)}。",
            f"- 当前 Python 源码聚合 SHA-256：`{summary['sourceDigestSHA256']}`。",
            f"- 工作精度：`90`；表观 pole 主/参考阶 `{primary_order}/{reference_order}`；指数起点主/参考阶 `64/88`；总 wall time `{elapsed:.6f} s`。",
            "",
            "## 支持路线",
            "",
            "- 表观二阶 pole：Lee–Moser exact 降为一阶 pole，projector 幂等和原系统 round-trip 均 exact；",
            f"  普通点闭式 `(-3,2)` 最大主/参考误差为 `{text_ball(max(apparent_primary_errors, key=lambda item: float(item.mid())))}` / `{text_ball(max(apparent_reference_errors, key=lambda item: float(item.mid())))}`。",
            "- 标量指数起点：局部签名 `phi=-1/x`，边界 `C=3`；闭式终点为 `3/e`；",
            f"  主/参考误差为 `{text_ball(exponential_primary_error)}` / `{text_ball(exponential_reference_error)}`。",
            "",
            "## Fail-closed 边界",
            "",
            "- nilpotent defective block：局部基和规划均在输运前拒绝。",
            "- indicial roots `+/-sqrt(2)`：不属于 Q(i)，规划标记不可 continuation。",
            "- coupled formal exponential block：只允许 start-only 局部求值；作为中间点或终点均明确要求 Stokes connection。",
            f"- 失败项：`{failed if failed else '无'}`。",
            "- 机器 summary：`results/summary.json`，含实际路径、变换、边界和失败消息。",
            "",
        ]
    )
    REPORT_PATH.write_text(report, encoding="utf-8", newline="\n")
    print(f"FlintNDE Validation-04: {passed_count}/{len(checks)} checks passed")
    return 0 if status == "passed" else 1


if __name__ == "__main__":
    raise SystemExit(main())
