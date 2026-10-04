"""FlintNDE 0.5.0 savepoint、regulator 和 Wolfram bridge 独立验证。

普通点路线使用闭式 ``y=(x+2)/2``；regulator family 的 Laurent 系数由本脚本直接
定义，拟合点与验证点固定分离。Wolfram 脚本通过标准 ``Needs`` 执行复数和 Infinity
case，再与 Python bridge schema 互检。
"""

from __future__ import annotations

import hashlib
import json
import os
import shutil
import subprocess
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
REPORT_PATH = CASE_ROOT / "000_FlintNDE-0.5.0-validation-05-report.md"
WOLFRAM_RUNNER = CASE_ROOT / "run_wolfram_bridge.wls"


def zero_system_factory(_ep: Any) -> Any:
    """在 regulator worker 内构造二维零 DE；闭式终点等于输入边界。"""

    from flint import acb, acb_mat
    from flintnde import AnalyticMatrixSystem

    return AnalyticMatrixSystem(
        lambda _point: acb_mat(2, 2),
        2,
        (acb(-10), acb(10)),
        "independent-regulator-zero-system",
    )


def laurent_boundary(ep: Any) -> list[Any]:
    """返回已知到四阶的二维 Laurent family。"""

    from flint import acb

    regulator = acb(ep)
    return [
        acb(2) / regulator
        + acb(3)
        + acb(4) * regulator
        + acb(5) * regulator**2
        + acb(6) * regulator**3
        + acb(7) * regulator**4,
        -acb(1) / regulator
        + acb(2)
        - acb(3) * regulator
        + acb(4) * regulator**2,
    ]


def exhaustion_boundary(ep: Any) -> list[Any]:
    """返回无法由有限候选池达到 1e-40 的指数型边界。"""

    from flint import acb

    regulator = acb(ep)
    return [regulator.exp(), (-regulator).exp()]


def fixed_path(_ep: Any, _system: Any) -> list[Any]:
    """让每个 regulator 样本真实经过同一普通点 NDE 路线。"""

    from flint import acb

    return [acb(0), acb(1)]


def leading_power_certificate(power: int) -> dict[str, object]:
    """冻结由显式 Laurent 边界直接读出的最低幂。"""

    return {
        "status": "certified",
        "leading_power": power,
        "method": "independent-explicit-laurent-boundary",
    }


def fresh_output() -> None:
    """删除本 case 的旧正式/临时输出和报告。"""

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


def first_save_record(directory: Path) -> dict[str, Any]:
    """读取一个普通保存点；多文件或无文件均视为验证脚本错误。"""

    files = sorted(directory.glob("flintnde_save_[0-9][0-9][0-9].json"))
    if len(files) != 1:
        raise RuntimeError(f"expected one savepoint in {directory}, got {len(files)}")
    return json.loads(files[0].read_text(encoding="utf-8"))


def saved_vector(record: dict[str, Any]) -> Any:
    """从 ordinary savepoint 的中点记录恢复 Acb 列向量。"""

    from flint import acb, acb_mat

    return acb_mat(
        [[acb(component["real"], component["imag"])] for component in record["result"]]
    )


def ball_text(value: Any, digits: int = 50) -> str:
    """稳定保存 Acb/Arb 球。"""

    return value.str(digits)


def bridge_plan_request(system: dict[str, Any], points: list[str], mode: str) -> dict[str, Any]:
    """构造当前 Python bridge 的显式规划请求。"""

    from flintnde import mathematica_bridge

    return {
        "schema": mathematica_bridge.REQUEST_SCHEMA,
        "action": "plan",
        "system": system,
        "start": "0",
        "points": points,
        "workingPrecisionDigits": 90,
        "outputDigits": 50,
        "singularityMode": mode,
        "messageLanguage": "CN",
        "radiusFraction": 0.60,
        "maxStepOverRadius": 0.45,
        "singularityJumpThreshold": 0.5,
        "matchFraction": 0.6,
        "maxSingularityJumps": 16,
    }


def bridge_execute_request(
    system: dict[str, Any], plan: dict[str, Any], initial: list[Any], primary: int, reference: int
) -> dict[str, Any]:
    """构造只消费已有计划的当前 Python bridge 请求。"""

    from flintnde import mathematica_bridge

    return {
        "schema": mathematica_bridge.REQUEST_SCHEMA,
        "action": "execute",
        "system": system,
        "initialVector": initial,
        "plannedResult": plan,
        "workingPrecisionDigits": 90,
        "outputDigits": 50,
        "primaryOrder": primary,
        "referenceOrder": reference,
        "targetRelativeError": "1e-25",
        "certificationMode": "certified",
        "radiusFraction": 0.60,
        "messageLanguage": "CN",
    }


def main() -> int:
    """执行 savepoint、正规化正反例和 Python/Wolfram bridge。"""

    fresh_output()
    os.environ["FLINTNDE_SUPPRESS_CITATION_NOTICE"] = "1"
    sys.path.insert(0, str(VERSION_ROOT))

    from flint import acb, acb_mat
    from flintnde import (
        RationalMatrixSystem,
        build_adaptive_path,
        configure_working_precision,
        rational_function,
        reconstruct_series_solution,
        transport_path,
        transport_path_refined,
    )
    from flintnde import mathematica_bridge

    configure_working_precision(90, 50)
    started = time.perf_counter()
    primary_order = 48
    reference_order = 68

    # cold 与 resume 共享同一条经 x=1 的自适应路线；save 标签只控制落盘。
    ordinary_system = RationalMatrixSystem(
        ((rational_function(1, [2, 1]),),),
        variable_name="x",
        name="independent-savepoint-y-equals-x-plus-two-over-two",
    )
    cold_path = build_adaptive_path(
        ordinary_system,
        acb(0),
        acb(2),
        detour_points=(acb(1),),
    )
    save_path = build_adaptive_path(
        ordinary_system,
        acb(0),
        acb(2),
        detour_points=((acb(1), "save"),),
    )
    resume_path = build_adaptive_path(ordinary_system, acb(1), acb(2))
    cold_clock = time.perf_counter()
    cold = transport_path_refined(
        ordinary_system,
        acb_mat([[1]]),
        cold_path,
        primary_order=primary_order,
        reference_order=reference_order,
        target_relative_error="1e-25",
        certification_mode="certified",
    )
    cold_seconds = time.perf_counter() - cold_clock

    primary_save_dir = TEMP_ROOT / "savepoint_primary"
    reference_save_dir = TEMP_ROOT / "savepoint_reference"
    resume_clock = time.perf_counter()
    transport_path(
        ordinary_system,
        acb_mat([[1]]),
        save_path,
        order=primary_order,
        save_output_directory=primary_save_dir,
    )
    transport_path(
        ordinary_system,
        acb_mat([[1]]),
        save_path,
        order=reference_order,
        save_output_directory=reference_save_dir,
    )
    primary_record = first_save_record(primary_save_dir)
    reference_record = first_save_record(reference_save_dir)
    primary_round_trip = json.loads(json.dumps(primary_record, ensure_ascii=False))
    reference_round_trip = json.loads(json.dumps(reference_record, ensure_ascii=False))
    resumed_primary = transport_path(
        ordinary_system,
        saved_vector(primary_round_trip),
        resume_path,
        order=primary_order,
    )[0][-1]
    resumed_reference = transport_path(
        ordinary_system,
        saved_vector(reference_round_trip),
        resume_path,
        order=reference_order,
    )[0][-1]
    resume_seconds = time.perf_counter() - resume_clock
    cold_primary = cold["primary_snapshots"][-1]
    cold_reference = cold["reference_snapshots"][-1]
    detour_index = next(
        index for index, point in enumerate(cold_path) if abs(point - acb(1)).contains(0)
    )
    savepoint_route_consistent = (
        len(cold_path) == len(save_path)
        and all(abs(left - right).contains(0) for left, right in zip(cold_path, save_path))
        and len(cold_path[detour_index:]) == len(resume_path)
        and all(
            abs(left - right).contains(0)
            for left, right in zip(cold_path[detour_index:], resume_path)
        )
    )
    savepoint_differences = {
        "primaryVsCold": abs(resumed_primary[0, 0] - cold_primary[0, 0]),
        "referenceVsCold": abs(resumed_reference[0, 0] - cold_reference[0, 0]),
        "primaryVsClosed": abs(resumed_primary[0, 0] - acb(2)),
        "referenceVsClosed": abs(resumed_reference[0, 0] - acb(2)),
    }

    # 显式候选池先拟合到内部二阶，独立验证失败后追加两点并提高到四阶。
    regulator_clock = time.perf_counter()
    production_candidates = (
        "0.10",
        "0.09",
        "0.08",
        "0.07",
        "0.06",
        "0.05",
        "0.045",
        "0.04",
    )
    validation_candidates = ("0.025", "0.02")
    reconstruction = reconstruct_series_solution(
        DEmatrix=zero_system_factory,
        boundary=laurent_boundary,
        path=fixed_path,
        maximum_power=1,
        leading_power=-1,
        leading_power_certificate=leading_power_certificate(-1),
        goal_digits=12,
        sample_points=production_candidates,
        validation_points=validation_candidates,
        initial_internal_maximum_power=2,
        fit_order_increment=2,
        fit_max_rounds=2,
        working_precision_digits=90,
        transport_order=8,
        transport_extra_order=4,
        validation_tolerance="1e-20",
        parallel_task_count=2,
    )
    regulator_seconds = time.perf_counter() - regulator_clock
    expected_coefficients = {
        -1: [acb(2), acb(-1)],
        0: [acb(3), acb(2)],
        1: [acb(4), acb(-3)],
    }
    coefficient_errors: dict[str, list[Any]] = {}
    for power, expected in expected_coefficients.items():
        actual = reconstruction.coefficient(power)
        coefficient_errors[str(power)] = [
            abs(actual[row, 0] - expected[row]) for row in range(2)
        ]
    production_validation_disjoint = all(
        not abs(production - validation).contains(0)
        for production in reconstruction.sample_points
        for validation in reconstruction.validation_points
    )

    # 候选池耗尽仍返回最佳结果，但必须明确标记未达到目标精度。
    with warnings.catch_warnings(record=True) as exhaustion_warnings:
        warnings.simplefilter("always")
        exhausted = reconstruct_series_solution(
            DEmatrix=zero_system_factory,
            boundary=exhaustion_boundary,
            path=fixed_path,
            maximum_power=0,
            leading_power=0,
            leading_power_certificate=leading_power_certificate(0),
            goal_digits=12,
            sample_points=("0.10", "0.09", "0.08", "0.07"),
            validation_points=("0.04", "0.03"),
            initial_internal_maximum_power=1,
            fit_order_increment=2,
            fit_max_rounds=3,
            working_precision_digits=90,
            transport_order=8,
            transport_extra_order=4,
            validation_tolerance="1e-40",
            parallel_task_count=2,
        )

    # Python bridge 生成与 Wolfram 标准入口相同的 schema/type 参照。
    ordinary_record_system = {
        "type": "rationalMatrix",
        "variable": "x",
        "name": "validation-05-ordinary",
        "matrix": [[{"numerator": ["1"], "denominator": ["2", "1"]}]],
    }
    python_ordinary_plan = mathematica_bridge.run_request(
        bridge_plan_request(ordinary_record_system, ["1", "2"], "avoid")
    )
    python_ordinary_result = mathematica_bridge.run_request(
        bridge_execute_request(
            ordinary_record_system,
            python_ordinary_plan,
            [{"re": "1", "im": "1"}],
            48,
            68,
        )
    )
    singular_record_system = {
        "type": "rationalMatrix",
        "variable": "x",
        "name": "validation-05-pole",
        "matrix": [[{"numerator": ["-1"], "denominator": ["-1", "1"]}]],
    }
    python_singular_plan = mathematica_bridge.run_request(
        bridge_plan_request(
            singular_record_system, ["1/2", "1", "3/2", "2"], "singularity_jump"
        )
    )
    python_singular_result = mathematica_bridge.run_request(
        bridge_execute_request(
            singular_record_system, python_singular_plan, ["1"], 64, 88
        )
    )

    environment = os.environ.copy()
    environment["PYTHONDONTWRITEBYTECODE"] = "1"
    environment["PYTHONPATH"] = str(VERSION_ROOT)
    environment["FLINTNDE_TEST_PYTHON"] = sys.executable
    environment["FLINTNDE_SUPPRESS_CITATION_NOTICE"] = "1"
    wolfram_clock = time.perf_counter()
    wolfram_process = subprocess.run(
        ["wolframscript", "-file", str(WOLFRAM_RUNNER)],
        cwd=CASE_ROOT,
        env=environment,
        text=True,
        encoding="utf-8",
        errors="replace",
        capture_output=True,
        check=False,
    )
    wolfram_seconds = time.perf_counter() - wolfram_clock
    (TEMP_ROOT / "wolfram-stdout.log").write_text(
        wolfram_process.stdout, encoding="utf-8", newline="\n"
    )
    (TEMP_ROOT / "wolfram-stderr.log").write_text(
        wolfram_process.stderr, encoding="utf-8", newline="\n"
    )
    wolfram_summary_path = TEMP_ROOT / "wolfram_bridge" / "wolfram_summary.json"
    wolfram_summary = (
        json.loads(wolfram_summary_path.read_text(encoding="utf-8-sig"))
        if wolfram_summary_path.exists()
        else {}
    )

    elapsed = time.perf_counter() - started
    history = reconstruction.diagnostics["fit_expansion_history"]
    checks = {
        "savepointPrimaryRoundTripExact": primary_round_trip == primary_record,
        "savepointReferenceRoundTripExact": reference_round_trip == reference_record,
        "savepointResultTypes": primary_record["resultType"] == "ordinary_vector"
        and reference_record["resultType"] == "ordinary_vector",
        "savepointPrimaryMatchesCold": float(savepoint_differences["primaryVsCold"].mid())
        < 1.0e-20,
        "savepointReferenceMatchesCold": float(
            savepoint_differences["referenceVsCold"].mid()
        )
        < 1.0e-25,
        "savepointClosedForm": max(
            float(savepoint_differences[name].mid())
            for name in ("primaryVsClosed", "referenceVsClosed")
        )
        < 1.0e-20,
        "savepointNodeSequence": savepoint_route_consistent,
        "regulatorPrecisionMet": reconstruction.effective_parameters[
            "precision_target_met"
        ],
        "regulatorCoefficients": max(
            float(error.mid()) for errors in coefficient_errors.values() for error in errors
        )
        < 1.0e-14,
        "regulatorFitValidationDisjoint": production_validation_disjoint,
        "regulatorIncrementalExpansion": len(history) == 2
        and not history[0]["passed"]
        and history[1]["passed"]
        and history[1]["reused_production_sample_count"]
        == history[0]["new_production_sample_count"]
        + history[0]["reused_production_sample_count"]
        and history[1]["reused_validation_sample_count"]
        == len(reconstruction.validation_points),
        "candidatePoolExhaustionUncertified": not exhausted.effective_parameters[
            "precision_target_met"
        ]
        and exhausted.effective_parameters["precision_failure_reason"]
        == "candidate_pool_exhausted"
        and any("candidate pool was exhausted" in str(item.message) for item in exhaustion_warnings),
        "wolframRunnerPassed": wolfram_process.returncode == 0
        and wolfram_summary.get("status") == "passed"
        and wolfram_summary.get("passedCount") == wolfram_summary.get("checkCount"),
        "pythonWolframSchemasMatch": wolfram_summary.get("ordinaryPlanSchema")
        == python_ordinary_plan.get("schema")
        and wolfram_summary.get("ordinaryResultSchema")
        == python_ordinary_result.get("schema"),
        "pythonWolframInfinityMatch": wolfram_summary.get("infinityValue") == "Infinity"
        and python_singular_result["singularTargets"][0]["values"]
        == [{"text": "Infinity"}],
        "pythonWolframMessageLanguage": wolfram_summary.get("messageLanguage") == "CN"
        and python_singular_plan.get("messageLanguage") == "CN",
        "wolframCallerLocalOutput": wolfram_summary_path.exists()
        and str(wolfram_summary_path.resolve()).startswith(str(CASE_ROOT.resolve())),
    }
    checks = {name: bool(value) for name, value in checks.items()}
    passed_count = sum(value is True for value in checks.values())
    status = "passed" if passed_count == len(checks) else "failed"
    summary = {
        "schema": "flintnde_0.5.0_validation_05_v1",
        "status": status,
        "passedCount": passed_count,
        "checkCount": len(checks),
        "sourceDigestSHA256": source_digest(),
        "settings": {
            "workingPrecisionDigits": 90,
            "primaryOrder": primary_order,
            "referenceOrder": reference_order,
            "targetRelativeError": "1e-25",
            "parallelTaskCount": 2,
        },
        "savepoint": {
            "exactModel": "y'=y/(x+2), y(0)=1, hence y=(x+2)/2 and y(2)=2",
            "requestedCheckpoints": ["0", "1", "2"],
            "coldAdaptiveNodes": [ball_text(point) for point in cold_path],
            "resumeAdaptiveNodes": [ball_text(point) for point in resume_path],
            "savedCoordinate": primary_record["coordinate"],
            "primaryRecord": primary_record,
            "referenceRecord": reference_record,
            "differences": {
                name: ball_text(value) for name, value in savepoint_differences.items()
            },
            "coldWallTimeSeconds": cold_seconds,
            "resumeWallTimeSeconds": resume_seconds,
            "coldPrimarySeconds": cold["primary_seconds"],
            "coldReferenceSeconds": cold["reference_seconds"],
        },
        "regulator": {
            "leadingPower": reconstruction.leading_power,
            "maximumPower": reconstruction.maximum_power,
            "internalMaximumPower": reconstruction.internal_maximum_power,
            "samplePoints": [point.str(40) for point in reconstruction.sample_points],
            "validationPoints": [point.str(40) for point in reconstruction.validation_points],
            "coefficientErrors": {
                power: [ball_text(error) for error in errors]
                for power, errors in coefficient_errors.items()
            },
            "history": history,
            "effectiveParameters": reconstruction.effective_parameters,
            "wallTimeSeconds": regulator_seconds,
            "candidateExhaustion": exhausted.to_summary(),
            "candidateExhaustionWarnings": [str(item.message) for item in exhaustion_warnings],
        },
        "bridge": {
            "pythonOrdinaryPlanSchema": python_ordinary_plan.get("schema"),
            "pythonOrdinaryResultSchema": python_ordinary_result.get("schema"),
            "pythonOrdinaryReference": python_ordinary_result.get("referenceFinalVector"),
            "pythonSingularTarget": python_singular_result["singularTargets"][0],
            "wolfram": wolfram_summary,
            "wolframReturnCode": wolfram_process.returncode,
            "wolframWallTimeSeconds": wolfram_seconds,
            "stdoutLog": "results_temp/wolfram-stdout.log",
            "stderrLog": "results_temp/wolfram-stderr.log",
        },
        "checks": checks,
        "wallTimeSeconds": elapsed,
    }
    (RESULTS_ROOT / "summary.json").write_text(
        json.dumps(summary, ensure_ascii=False, indent=2) + "\n", encoding="utf-8", newline="\n"
    )

    failed = [name for name, value in checks.items() if value is not True]
    largest_coefficient_error = max(
        (error for errors in coefficient_errors.values() for error in errors),
        key=lambda item: float(item.mid()),
    )
    report = "\n".join(
        [
            "# FlintNDE 0.5.0 Validation-05 独立报告",
            "",
            f"- 状态：**{status}**，{passed_count}/{len(checks)}。",
            f"- 当前 Python 源码聚合 SHA-256：`{summary['sourceDigestSHA256']}`。",
            f"- 工作精度/主阶/参考阶/并行任务：`90 / {primary_order} / {reference_order} / 2`。",
            f"- 总 wall time：`{elapsed:.6f} s`。",
            "",
            "## Savepoint",
            "",
            "- exact 路线：`y'=y/(x+2), y(0)=1`，请求检查点为 `{0,1,2}`，闭式终点为 2。",
            f"- 实际 cold adaptive 节点：`{summary['savepoint']['coldAdaptiveNodes']}`；恢复路线节点：`{summary['savepoint']['resumeAdaptiveNodes']}`。",
            f"- cold/resume wall time：`{cold_seconds:.6f} / {resume_seconds:.6f} s`。",
            f"- resume 对 cold 的主/参考差：`{ball_text(savepoint_differences['primaryVsCold'])}` / `{ball_text(savepoint_differences['referenceVsCold'])}`。",
            "- 低阶与高阶分别保存并从 JSON round-trip 恢复；保存记录均为 `ordinary_vector`。",
            "",
            "## Regulator",
            "",
            f"- 检测最低幂 `-1`，用户返回最高幂 `1`，最终内部最高幂 `{reconstruction.internal_maximum_power}`。",
            f"- 拟合轮数 `{len(history)}`；第二轮复用生产/验证点 `{history[-1]['reused_production_sample_count']}/{history[-1]['reused_validation_sample_count']}`。",
            f"- Laurent 系数最大误差：`{ball_text(largest_coefficient_error)}`；拟合点与验证点严格不相交。",
            "- 候选池耗尽反例仍返回最佳系数，但 `precision_target_met=False` 且原因是 `candidate_pool_exhausted`。",
            "",
            "## Wolfram bridge",
            "",
            f"- Wolfram 状态：`{wolfram_summary.get('passedCount')}/{wolfram_summary.get('checkCount')}`；wall time `{wolfram_seconds:.6f} s`。",
            "- Python/Wolfram plan/result schema 相同；复数 `2+2 I` 保持复数类型，奇点输出保持文本 `Infinity`。",
            "- 消息语言为 `CN`；bridge JSON 写入本 case 的 `results_temp/wolfram_bridge/`。",
            f"- 失败项：`{failed if failed else '无'}`。",
            "- 机器 summary：`results/summary.json`。",
            "",
        ]
    )
    REPORT_PATH.write_text(report, encoding="utf-8", newline="\n")
    print(f"FlintNDE Validation-05: {passed_count}/{len(checks)} checks passed")
    return 0 if status == "passed" else 1


if __name__ == "__main__":
    raise SystemExit(main())
