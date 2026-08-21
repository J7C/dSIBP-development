"""FlintNDE 0.5.0 奇点双侧 bucket 与末端隐藏匹配点独立验证。

脚本从空的本 case 结果目录运行。被测值来自 FlintNDE 当前源码，expected 使用标量闭式解；
planned 与逐点 naive 路线分别执行并互检，随后自动写出机器 summary 和自包含 Markdown 报告。
"""

from __future__ import annotations

import hashlib
import json
import os
import shutil
import sys
import time
from pathlib import Path
from typing import Any


CASE_ROOT = Path(__file__).resolve().parent
PACKAGE_ROOT = CASE_ROOT.parents[1]
VERSION_ROOT = PACKAGE_ROOT / "versions" / "FlintNDE-0.5.0"
RESULTS_ROOT = CASE_ROOT / "results"
TEMP_ROOT = CASE_ROOT / "results_temp"
REPORT_PATH = CASE_ROOT / "000_FlintNDE-0.5.0-validation-02-report.md"


def _fresh_output() -> None:
    """只清理本验证 case 的可重跑结果和旧报告。"""

    for directory in (RESULTS_ROOT, TEMP_ROOT):
        if directory.exists():
            shutil.rmtree(directory)
    if REPORT_PATH.exists():
        REPORT_PATH.unlink()
    RESULTS_ROOT.mkdir(parents=True)
    TEMP_ROOT.mkdir(parents=True)


def _source_digest() -> str:
    """对当前 FlintNDE Python 源码建立相对路径敏感的聚合 SHA-256。"""

    digest = hashlib.sha256()
    for path in sorted((VERSION_ROOT / "flintnde").glob("*.py")):
        digest.update(path.name.encode("utf-8"))
        digest.update(path.read_bytes())
    return digest.hexdigest()


def _acb_text(value: Any, digits: int = 50) -> str:
    """稳定保存 Acb 数值球。"""

    return value.str(digits)


def _extract_user_values(plan: Any, result: dict[str, Any], points: list[Any]) -> tuple[dict[int, Any], list[dict[str, Any]]]:
    """按原始用户索引恢复节点、dense bucket 和精确奇点三类结果。"""

    sample_by_index = {
        int(item["user_point_index"]): item for item in result["sample_results"]
        if item["user_point_index"] is not None
    }
    singular_by_index = {
        int(item["user_point_index"]): item for item in result["singular_target_results"]
    }
    values: dict[int, Any] = {}
    assignments: list[dict[str, Any]] = []
    for index, point in enumerate(points):
        if index in singular_by_index:
            item = singular_by_index[index]
            values[index] = item["values"]
            assignments.append({
                "userIndex": index,
                "coordinate": _acb_text(point),
                "source": "singular_target",
                "segmentIndex": item["segment_index"],
                "classification": item["classification"],
            })
            continue
        if index in sample_by_index:
            item = sample_by_index[index]
            values[index] = item["value"]
            assignments.append({
                "userIndex": index,
                "coordinate": _acb_text(point),
                "source": item["source"],
                "segmentIndex": item["segment_index"],
            })
            continue
        node_index = next(
            (node_index for node_index, node in enumerate(plan.nodes)
             if abs(node - point).contains(0)),
            None,
        )
        if node_index is None:
            raise RuntimeError(f"user point {index} has no node or local-bucket result")
        values[index] = result["primary_snapshots"][node_index]
        assignments.append({
            "userIndex": index,
            "coordinate": _acb_text(point),
            "source": "ordinary_node",
            "nodeIndex": node_index,
        })
    return values, assignments


def main() -> int:
    """执行 fresh 数值路线、闭式互检、计时和报告生成。"""

    _fresh_output()
    os.environ["FLINTNDE_SUPPRESS_CITATION_NOTICE"] = "1"
    sys.path.insert(0, str(VERSION_ROOT))

    from flint import acb, acb_mat, arb
    from flintnde import (
        PartialFractionSystem,
        RationalMatrixSystem,
        configure_working_precision,
        evaluate_singular_target,
        plan_singular_target_match,
        plan_transport_path,
        planned_path_from_json,
        planned_path_to_json,
        rational_function,
        transport_planned_path_refined,
    )

    configure_working_precision(90, 48)
    primary_order = 64
    reference_order = 88
    target_error = "1e-25"
    start = acb(0)
    initial = acb_mat([[1]])
    system = PartialFractionSystem(
        constant=acb_mat([[0]]),
        residues=(acb_mat([[-1]]), acb_mat([[1]])),
        poles=(acb(1), acb(-1)),
        name="independent-two-sided-scalar",
    )
    exact_system = RationalMatrixSystem(
        ((rational_function(-1, [-1, 1]) + rational_function(1, [1, 1]),),),
        variable_name="s",
        name="independent-two-sided-scalar-exact",
    )
    point_texts = [
        "2/5", "1/2", "3/5", "7/10", "3/4", "4/5", "17/20", "9/10",
        "1",
        "11/10", "23/20", "6/5", "5/4", "13/10", "7/5", "3/2", "8/5",
        "13/4",
    ]
    points = [acb(text) for text in point_texts]

    planned_clock = time.perf_counter()
    plan = plan_transport_path(
        system, start, points, singularity_mode="singularity_jump", message_language="CN"
    )
    planned = transport_planned_path_refined(
        system,
        initial,
        plan,
        primary_order=primary_order,
        reference_order=reference_order,
        certification_mode="certified",
        target_relative_error=target_error,
    )
    planned_seconds = time.perf_counter() - planned_clock
    planned_values, assignments = _extract_user_values(plan, planned, points)

    serialized = planned_path_to_json(plan, digits=90)
    restored_plan = planned_path_from_json(serialized, system=system)
    restored = transport_planned_path_refined(
        system,
        initial,
        restored_plan,
        primary_order=primary_order,
        reference_order=reference_order,
        certification_mode="certified",
        target_relative_error=target_error,
    )

    naive_clock = time.perf_counter()
    naive_values: dict[int, Any] = {}
    for index, point in enumerate(points):
        if point_texts[index] == "1":
            naive_values[index] = evaluate_singular_target(
                exact_system,
                0,
                initial,
                1,
                order=primary_order,
                target_relative_error=target_error,
            ).values
            continue
        point_plan = plan_transport_path(
            system,
            start,
            [point],
            singularity_mode="singularity_jump",
        )
        point_result = transport_planned_path_refined(
            system,
            initial,
            point_plan,
            primary_order=primary_order,
            reference_order=reference_order,
            certification_mode="certified",
            target_relative_error=target_error,
        )
        naive_values[index] = point_result["primary_snapshots"][-1]
    naive_seconds = time.perf_counter() - naive_clock

    maximum_planned_closed = arb(0)
    maximum_naive_closed = arb(0)
    maximum_mutual = arb(0)
    value_rows = []
    for index, point in enumerate(points):
        if point_texts[index] == "1":
            planned_state = planned_values[index][0]
            naive_state = naive_values[index][0]
            value_rows.append({
                "userIndex": index,
                "point": point_texts[index],
                "planned": planned_state,
                "naive": naive_state,
                "closedForm": "Infinity",
            })
            continue
        closed = (point + acb(1)) / (acb(1) - point)
        planned_value = planned_values[index][0, 0]
        naive_value = naive_values[index][0, 0]
        planned_error = abs(planned_value - closed) / max(arb(1), abs(closed), key=lambda x: float(x.mid()))
        naive_error = abs(naive_value - closed) / max(arb(1), abs(closed), key=lambda x: float(x.mid()))
        mutual_error = abs(planned_value - naive_value) / max(arb(1), abs(naive_value), key=lambda x: float(x.mid()))
        maximum_planned_closed = max(maximum_planned_closed, planned_error)
        maximum_naive_closed = max(maximum_naive_closed, naive_error)
        maximum_mutual = max(maximum_mutual, mutual_error)
        value_rows.append({
            "userIndex": index,
            "point": point_texts[index],
            "planned": _acb_text(planned_value),
            "naive": _acb_text(naive_value),
            "closedForm": _acb_text(closed),
            "plannedClosedRelativeError": _acb_text(planned_error),
            "naiveClosedRelativeError": _acb_text(naive_error),
            "mutualRelativeError": _acb_text(mutual_error),
        })

    terminal_exact = RationalMatrixSystem(
        ((rational_function(-1, [-1, 1]) + rational_function(1, ["-11/10", 1]),),),
        variable_name="s",
        name="independent-terminal-target-exact",
    )
    terminal_system = PartialFractionSystem(
        constant=acb_mat([[0]]),
        residues=(acb_mat([[-1]]), acb_mat([[1]])),
        poles=(acb(1), acb("11/10")),
        name="independent-terminal-target",
    )
    terminal_match = plan_singular_target_match(terminal_exact, 0, 1)
    terminal_plan = plan_transport_path(
        terminal_system,
        start,
        [terminal_match.match_point],
        singularity_mode="singularity_jump",
    )
    terminal_transport = transport_planned_path_refined(
        terminal_system,
        initial,
        terminal_plan,
        primary_order=primary_order,
        reference_order=reference_order,
        certification_mode="certified",
        target_relative_error=target_error,
    )
    terminal_primary = evaluate_singular_target(
        terminal_exact,
        terminal_match.match_point,
        terminal_transport["primary_snapshots"][-1],
        1,
        order=primary_order,
        target_relative_error=target_error,
    )
    terminal_reference = evaluate_singular_target(
        terminal_exact,
        terminal_match.match_point,
        terminal_transport["reference_snapshots"][-1],
        1,
        order=reference_order,
        target_relative_error=target_error,
    )

    sources = [item["source"] for item in assignments]
    checks = {
        "singularTargetNotOrdinaryNode": not any(abs(node - acb(1)).contains(0) for node in plan.nodes),
        "incomingBucketPresent": "covered_by_singularity_jump_incoming" in sources,
        "outgoingBucketPresent": "covered_by_singularity_jump" in sources,
        "continuedPastLocalDisk": abs(planned["primary_snapshots"][-1][0, 0] - acb("-17/9")) < arb("1e-25"),
        "plannedMatchesClosedForm": maximum_planned_closed < arb("1e-25"),
        "naiveMatchesClosedForm": maximum_naive_closed < arb("1e-25"),
        "plannedMatchesNaive": maximum_mutual < arb("1e-25"),
        "singularValueIsInfinity": planned_values[8][0] == "Infinity" and naive_values[8][0] == "Infinity",
        "roundTripFinalValue": abs(restored["primary_snapshots"][-1][0, 0] - planned["primary_snapshots"][-1][0, 0]) < arb("1e-25"),
        "terminalMatchInserted": terminal_match.inserted,
        "terminalMatchInsideDisk": abs(terminal_match.match_point - acb(1)) < terminal_match.convergence_radius,
        "terminalPrimaryReferenceClassification": terminal_primary.component_classifications == terminal_reference.component_classifications == ("true_pole",),
    }
    passed = sum(bool(value) for value in checks.values())
    status = "passed" if passed == len(checks) else "failed"
    summary = {
        "schema": "flintnde_0_5_0_validation_02_v1",
        "status": status,
        "passed": passed,
        "total": len(checks),
        "sourceRoot": str(VERSION_ROOT),
        "sourceDigestSha256": _source_digest(),
        "convention": "Y'(s)=A(s)Y(s), principal Acb branch, left detour for left-to-right crossing",
        "system": "A(s)=-1/(s-1)+1/(s+1), Y(0)=1, Y(s)=(s+1)/(1-s)",
        "userPointsExact": point_texts,
        "actualNodes": [_acb_text(node) for node in plan.nodes],
        "planReport": plan.report,
        "assignments": assignments,
        "values": value_rows,
        "orders": {"primary": primary_order, "reference": reference_order},
        "workingPrecisionDigits": 90,
        "targetRelativeError": target_error,
        "timingSeconds": {
            "planned": planned_seconds,
            "naivePointwise": naive_seconds,
            "naiveOverPlanned": naive_seconds / planned_seconds,
        },
        "maximumRelativeErrors": {
            "plannedVsClosed": _acb_text(maximum_planned_closed),
            "naiveVsClosed": _acb_text(maximum_naive_closed),
            "plannedVsNaive": _acb_text(maximum_mutual),
        },
        "terminalSingularMatch": terminal_match.report,
        "terminalPrimaryClassification": terminal_primary.classification,
        "terminalReferenceClassification": terminal_reference.classification,
        "checks": checks,
        "outputs": {
            "summary": str(RESULTS_ROOT / "summary.json"),
            "report": str(REPORT_PATH),
        },
    }
    (RESULTS_ROOT / "summary.json").write_text(
        json.dumps(summary, ensure_ascii=False, indent=2), encoding="utf-8"
    )

    node_lines = "\n".join(f"- `{index}`: `{node}`" for index, node in enumerate(summary["actualNodes"]))
    assignment_lines = "\n".join(
        f"- userIndex `{item['userIndex']}`, point `{item['coordinate']}`, source `{item['source']}`"
        for item in assignments
    )
    report = f"""# FlintNDE 0.5.0 Validation-02 独立报告

- 状态：**{status}**，{passed}/{len(checks)}。
- 源码：`{VERSION_ROOT}`
- Python 源码聚合 SHA-256：`{summary['sourceDigestSha256']}`
- convention：`{summary['convention']}`

## 数值点与路径

闭式系统为 `{summary['system']}`。用户点依次为 `{point_texts}`；`s=1` 是真实 pole，`s=13/4` 位于奇点局部圆外，用于检查从出射普通点继续输运。

实际普通节点：

{node_lines}

点归属：

{assignment_lines}

## 展开、精度与计时

- 普通/奇点局部主阶：{primary_order}；参考阶：{reference_order}。
- 工作精度：90 decimal digits；目标相对误差：`{target_error}`。
- planned wall time：{planned_seconds:.9f} s。
- naive 逐点独立规划/输运 wall time：{naive_seconds:.9f} s。
- naive/planned：{naive_seconds / planned_seconds:.6f}。
- planned/闭式最大相对误差：`{summary['maximumRelativeErrors']['plannedVsClosed']}`。
- naive/闭式最大相对误差：`{summary['maximumRelativeErrors']['naiveVsClosed']}`。
- planned/naive 最大相对误差：`{summary['maximumRelativeErrors']['plannedVsNaive']}`。

## 末端奇点

前一状态 `s=0` 位于目标 `s=1` 的局部收敛圆外；FlintNDE 生成隐藏匹配点 `{terminal_match.report['matchPoint']}`，收敛半径 `{terminal_match.report['convergenceRadius']}`。主/参考链均分类为 `true_pole`，用户值为文本 `Infinity`。高阶链只参与分类与精度核验。

## 结论与边界

精确奇点没有进入普通节点链；同一局部基覆盖两侧用户点，计划 round-trip 后结果不变，并从出射普通点继续到局部圆外的最终点。非共线奇点转向、连续奇点、未认证局部基和缺 Stokes 数据的路线仍不在本报告认证范围内。

机器结果：`{RESULTS_ROOT / 'summary.json'}`。
"""
    REPORT_PATH.write_text(report, encoding="utf-8")
    print(f"FlintNDE Validation-02 {status}: {passed}/{len(checks)}")
    print(f"planned={planned_seconds:.9f}s naive={naive_seconds:.9f}s ratio={naive_seconds/planned_seconds:.6f}")
    return 0 if status == "passed" else 1


if __name__ == "__main__":
    raise SystemExit(main())
