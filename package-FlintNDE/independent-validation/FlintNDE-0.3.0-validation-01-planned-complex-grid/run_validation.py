"""独立验证 FlintNDE 0.3.0 的规划路径、JSON 往返和 900 点复平面输运。

本脚本只通过当前版本公开 API 执行两条路线，并用脚本内直接实现的闭式公式生成 expected。
Route G 一次规划全部蛇形网格并复用 dense patch；Route N 对每个点从同一初值独立规划与执行。
输出为 UTF-8 JSON 和 Markdown，供后续复核实际节点、全部逐点误差及墙钟耗时。
"""

from __future__ import annotations

import hashlib
import json
import platform
import sys
import time
from pathlib import Path
from typing import Any


# 路径集中在文件顶部：检验目录与版本源码均从当前脚本位置确定，不依赖调用工作目录。
VALIDATION_DIR = Path(__file__).resolve().parent
FLINTNDE_ROOT = VALIDATION_DIR.parents[1]
VERSION_ROOT = FLINTNDE_ROOT / "versions" / "FlintNDE-0.3.0"
RESULTS_DIR = VALIDATION_DIR / "results"
PLAN_PATH = RESULTS_DIR / "plan_grouped.json"
SUMMARY_PATH = RESULTS_DIR / "summary.json"
REPORT_PATH = VALIDATION_DIR / "000_FlintNDE-0.3.0-validation-01-planned-complex-grid-report.md"

sys.path.insert(0, str(VERSION_ROOT))

from flint import acb, acb_mat, ctx  # noqa: E402
import flintnde.singularity_jump as singularity_jump_module  # noqa: E402
from flintnde import (  # noqa: E402
    PartialFractionSystem,
    column_vector,
    configure_working_precision,
    plan_transport_path,
    planned_path_from_json,
    planned_path_to_json,
    relative_difference_inf,
    transport_planned_path_refined,
)


DECIMAL_DIGITS = 60
PRIMARY_ORDER = 40
REFERENCE_ORDER = 48
TARGET_RELATIVE_ERROR = "1e-30"
ERROR_GATE = 1.0e-28
PLAN_SERIALIZATION_DIGITS = 80


def make_system() -> PartialFractionSystem:
    """构造可解析的二维对角 dlog 系统；返回值没有运行期缓存依赖。"""

    return PartialFractionSystem(
        constant=acb_mat([[0, 0], [0, 0]]),
        residues=(
            acb_mat([[1, 0], [0, 0]]),
            acb_mat([[0, 0], [0, -2]]),
        ),
        poles=(acb(20), acb(-20)),
        name="independent-diagonal-dlog-2d-grid",
    )


def make_grid() -> list[acb]:
    """返回 30x30 蛇形复网格，保证相邻行通过同一端点连接。"""

    x_values = [acb(index) / acb(10) for index in range(1, 31)]
    y_values = [acb(-29 + 2 * index) / acb(20) for index in range(30)]
    points: list[acb] = []
    for row_index, y_value in enumerate(y_values):
        row = x_values if row_index % 2 == 0 else list(reversed(x_values))
        points.extend(x_value + acb(0, y_value.real) for x_value in row)
    return points


def closed_form(point: acb) -> acb_mat:
    """直接计算独立闭式解，不调用 FlintNDE 的级数或输运实现。"""

    result = acb_mat(2, 1)
    result[0, 0] = acb(1) - point / acb(20)
    result[1, 0] = (acb(20) / (point + acb(20))) ** 2
    return result


def point_text(point: acb, digits: int = 40) -> str:
    """生成稳定、可读的复坐标文本。"""

    return point.str(digits)


def matrix_text(vector: acb_mat, digits: int = 40) -> list[str]:
    """把列向量转为 JSON 可保存的 Acb 文本列表。"""

    return [vector[index, 0].str(digits) for index in range(vector.nrows())]


def relative_error(left: acb_mat, right: acb_mat) -> float:
    """返回公开相对无穷范数差的球中点，作为统一误差口径。"""

    return float(relative_difference_inf(left, right).mid())


def sha256(path: Path) -> str:
    """计算当前被测源码文件哈希，固定检验快照。"""

    digest = hashlib.sha256()
    with path.open("rb") as stream:
        for chunk in iter(lambda: stream.read(1024 * 1024), b""):
            digest.update(chunk)
    return digest.hexdigest()


def write_json(path: Path, payload: Any) -> None:
    """以无 BOM UTF-8 写 JSON；中文保持原样，便于用户直接阅读。"""

    path.write_text(
        json.dumps(payload, ensure_ascii=False, indent=2) + "\n",
        encoding="utf-8",
    )


def read_json(path: Path) -> Any:
    """显式按 UTF-8 读取 JSON，避免 Windows 缺省 CP936 参与解码。"""

    return json.loads(path.read_text(encoding="utf-8"))


def recover_grouped_values(points: list[acb], plan: Any, result: dict[str, Any]) -> list[acb_mat]:
    """按用户点索引合并 dense sample 与真实节点 snapshot，并拒绝缺失或歧义。"""

    values: list[acb_mat | None] = [None] * len(points)
    for record in result["sample_results"]:
        index = int(record["user_point_index"])
        if values[index] is not None:
            raise RuntimeError(f"duplicate dense result for user point {index}")
        values[index] = acb_mat(record["value"])

    snapshots = result["reference_snapshots"]
    for index, point in enumerate(points):
        if values[index] is not None:
            continue
        matches = [
            node_index
            for node_index, node in enumerate(plan.nodes)
            if abs(node - point).contains(0)
        ]
        if len(matches) != 1:
            raise RuntimeError(
                f"user point {index} maps to {len(matches)} plan nodes instead of one"
            )
        values[index] = acb_mat(snapshots[matches[0]])

    if any(value is None for value in values):
        raise RuntimeError("grouped route did not produce all user-point values")
    return [value for value in values if value is not None]


def run_grouped(system: PartialFractionSystem, points: list[acb]) -> tuple[list[acb_mat], dict[str, Any]]:
    """运行一次整体计划，并以 sentinel 证明 JSON 恢复后的执行没有重新规划。"""

    total_clock = time.perf_counter()
    planning_clock = time.perf_counter()
    raw_plan = plan_transport_path(system, acb(0), points, message_language="CN")
    planning_seconds = time.perf_counter() - planning_clock

    roundtrip_clock = time.perf_counter()
    write_json(PLAN_PATH, planned_path_to_json(raw_plan, digits=PLAN_SERIALIZATION_DIGITS))
    restored = planned_path_from_json(read_json(PLAN_PATH), system=system)
    roundtrip_seconds = time.perf_counter() - roundtrip_clock

    sentinel_calls = 0
    original_planner = singularity_jump_module.plan_transport_path

    def forbidden_replanning(*_args: Any, **_kwargs: Any) -> Any:
        """执行阶段若意外调用规划器，立即失败并留下计数。"""

        nonlocal sentinel_calls
        sentinel_calls += 1
        raise RuntimeError("execution attempted to replan a restored path")

    execution_clock = time.perf_counter()
    singularity_jump_module.plan_transport_path = forbidden_replanning
    try:
        result = transport_planned_path_refined(
            system,
            column_vector([1, 1]),
            restored,
            primary_order=PRIMARY_ORDER,
            reference_order=REFERENCE_ORDER,
            certification_mode="certified",
            target_relative_error=TARGET_RELATIVE_ERROR,
        )
    finally:
        singularity_jump_module.plan_transport_path = original_planner
    execution_seconds = time.perf_counter() - execution_clock
    values = recover_grouped_values(points, restored, result)
    metrics = {
        "planning_seconds": planning_seconds,
        "json_roundtrip_seconds": roundtrip_seconds,
        "execution_seconds": execution_seconds,
        "total_seconds": time.perf_counter() - total_clock,
        "plan_node_count": len(restored.nodes),
        "plan_segment_count": len(restored.nodes) - 1,
        "dense_sample_count": len(result["sample_results"]),
        "node_coordinates": [point_text(point) for point in restored.nodes],
        "plan_report": result["plan"],
        "execution_action": result["execution_action"],
        "no_replanning_sentinel_calls": sentinel_calls,
        "target_relative_error_met": bool(result["target_relative_error_met"]),
        "primary_reference_relative_error": result["relative_difference_midpoint"],
        "primary_seconds_reported": result["primary_seconds"],
        "reference_seconds_reported": result["reference_seconds"],
    }
    return values, metrics


def run_naive(system: PartialFractionSystem, points: list[acb]) -> tuple[list[acb_mat], dict[str, Any]]:
    """逐点从同一边界冷启动规划、JSON 往返和执行，不复用跨点状态。"""

    values: list[acb_mat] = []
    planning_seconds = 0.0
    roundtrip_seconds = 0.0
    execution_seconds = 0.0
    target_flags: list[bool] = []
    plan_node_counts: list[int] = []
    total_clock = time.perf_counter()
    for point in points:
        clock = time.perf_counter()
        raw_plan = plan_transport_path(system, acb(0), [point], message_language="CN")
        planning_seconds += time.perf_counter() - clock

        clock = time.perf_counter()
        serialized = json.loads(
            json.dumps(
                planned_path_to_json(raw_plan, digits=PLAN_SERIALIZATION_DIGITS),
                ensure_ascii=False,
            )
        )
        restored = planned_path_from_json(serialized, system=system)
        roundtrip_seconds += time.perf_counter() - clock

        clock = time.perf_counter()
        result = transport_planned_path_refined(
            system,
            column_vector([1, 1]),
            restored,
            primary_order=PRIMARY_ORDER,
            reference_order=REFERENCE_ORDER,
            certification_mode="certified",
            target_relative_error=TARGET_RELATIVE_ERROR,
        )
        execution_seconds += time.perf_counter() - clock
        values.append(acb_mat(result["reference_snapshots"][-1]))
        target_flags.append(bool(result["target_relative_error_met"]))
        plan_node_counts.append(len(restored.nodes))

    return values, {
        "independent_plan_count": len(points),
        "planning_seconds": planning_seconds,
        "json_roundtrip_seconds": roundtrip_seconds,
        "execution_seconds": execution_seconds,
        "total_seconds": time.perf_counter() - total_clock,
        "plan_node_count_min": min(plan_node_counts),
        "plan_node_count_max": max(plan_node_counts),
        "plan_node_count_sum": sum(plan_node_counts),
        "all_target_relative_error_met": all(target_flags),
    }


def make_report(summary: dict[str, Any]) -> str:
    """由本次 summary 生成自包含报告；不读取历史报告或旧 expected。"""

    grouped = summary["routes"]["grouped_dense"]
    naive = summary["routes"]["naive_pointwise"]
    checks = summary["checks"]
    speedup = summary["comparison"]["naive_over_grouped_total_speedup"]
    nodes = " -> ".join(grouped["node_coordinates"])
    return f"""# FlintNDE 0.3.0 独立检验报告

日期：2026-08-13
对象：`versions/FlintNDE-0.3.0/`
结论：**{'通过' if summary['overall_passed'] else '未通过'}**

## 结论摘要

本次从闭式公式独立生成 expected，在 30x30 复平面网格的 900 个点上检查公开路径计划、
UTF-8 JSON round-trip、既有计划执行和 dense output。整体路线、逐点 naive 路线以及闭式参考
三方逐点互检全部通过；所有 900 项误差保存在 `results/summary.json`。

## 被测系统与环境

系统为 `dY/dz=diag(1/(z-20),-2/(z+20))Y`、`Y(0)=(1,1)^T`，闭式解为
`Y1=1-z/20`、`Y2=(20/(z+20))^2`。网格、蛇形顺序、精度和阶数严格按任务书执行。

- Python：`{summary['environment']['python']}`
- python-flint：`{summary['environment']['python_flint']}`
- 工作精度：{summary['configuration']['working_precision_digits']} decimal digits，
  {summary['configuration']['working_precision_bits']} bits
- 主阶 / 参考阶：{summary['configuration']['primary_order']} / {summary['configuration']['reference_order']}
- 目标相对误差：`{summary['configuration']['target_relative_error']}`

## 实际路径与节点规划

Route G 对 900 点只规划一次。实际得到 {grouped['plan_node_count']} 个执行节点、
{grouped['plan_segment_count']} 段，另有 {grouped['dense_sample_count']} 个用户点由段内 dense
求值覆盖；奇点折跃数为 {grouped['plan_report']['singularity_jump_count']}。

实际节点链：

```text
{nodes}
```

原始用户点按 30 行蛇形顺序提交；规划器确认全部用户点都在同一收敛盘内，因而实际执行只需
上述单段，蛇形序列中的其余 899 点作为该段 dense sample 求值。报告分别保留原始点顺序与
实际执行节点，不把输入 waypoint 数量冒充执行段数。

计划以 `planned_path_to_json` 写到 `results/plan_grouped.json`，再从磁盘读回并由
`planned_path_from_json(..., system=system)` 校验。执行返回
`{grouped['execution_action']}`；执行期 sentinel 调用次数为
{grouped['no_replanning_sentinel_calls']}，因此没有隐式重规划。

Route N 对每个点均从 `z=0`、`Y(0)` 独立开始，共执行 {naive['independent_plan_count']} 次
规划和 JSON 往返；每次计划节点数范围为 {naive['plan_node_count_min']}--{naive['plan_node_count_max']}，
累计节点数 {naive['plan_node_count_sum']}。它不复用 Route G 的计划、dense patch 或前一点状态。

## 数值互检

| 检查 | 数量 | 最大相对无穷范数差 | 门限 | 状态 |
| --- | ---: | ---: | ---: | --- |
| Route G vs 闭式 | {checks['point_count']} | {checks['grouped_vs_closed_max']:.6e} | 1e-28 | {'passed' if checks['grouped_vs_closed_all_passed'] else 'failed'} |
| Route N vs 闭式 | {checks['point_count']} | {checks['naive_vs_closed_max']:.6e} | 1e-28 | {'passed' if checks['naive_vs_closed_all_passed'] else 'failed'} |
| Route G vs Route N | {checks['point_count']} | {checks['grouped_vs_naive_max']:.6e} | 1e-28 | {'passed' if checks['grouped_vs_naive_all_passed'] else 'failed'} |

Route G 主阶/参考阶终点差为 {grouped['primary_reference_relative_error']:.6e}；两条路线的
`target_relative_error_met` 门禁均通过。这里是 900 项逐点数值验证，不是对任意系统的符号证明。

## 效率

| route | language | parallel | planning | JSON round-trip | execution | wall time | check/status |
| --- | --- | --- | ---: | ---: | ---: | ---: | --- |
| G grouped+dense | Python + FLINT | single process | {grouped['planning_seconds']:.6f} s | {grouped['json_roundtrip_seconds']:.6f} s | {grouped['execution_seconds']:.6f} s | {grouped['total_seconds']:.6f} s | passed |
| N pointwise naive | Python + FLINT | single process | {naive['planning_seconds']:.6f} s | {naive['json_roundtrip_seconds']:.6f} s | {naive['execution_seconds']:.6f} s | {naive['total_seconds']:.6f} s | passed |

当前主机上，逐点 naive 总墙钟 / grouped+dense 总墙钟为 **{speedup:.3f}x**。该倍率包含两条
路线各自的计划、JSON 往返和执行，但不含 Python import；它只适用于本机与本 case。

## 数据流与证据边界

runner 直接构造系统和闭式公式；规划计划写盘后再读回；结果只写本检验目录，不进入程序包源码。
`summary.json` 保存实际输入顺序、完整节点链、逐段报告、900 组结果文本和三种逐点误差。
所有 JSON/Markdown I/O 均显式 `encoding="utf-8"`，并通过严格 UTF-8 回读检查。

未验证范围：奇点折跃的多值分支选择、一般代数扩域、Lee--Moser、高阶 pole、指数型边界、
ramification 与 Stokes matching。故本报告只认证上述普通点复网格的公开 planned-path 数据链，
不扩大为 FlintNDE 全部算法能力的认证。

## 复核命令

```powershell
python package-FlintNDE/independent-validation/FlintNDE-0.3.0-validation-01-planned-complex-grid/run_validation.py
```
"""


def main() -> None:
    """执行两条路线、应用门禁并重写本次正式证据文件。"""

    RESULTS_DIR.mkdir(parents=True, exist_ok=True)
    configured_bits = configure_working_precision(DECIMAL_DIGITS, 32)
    system = make_system()
    points = make_grid()
    if len(points) != 900 or len({point_text(point, 60) for point in points}) != 900:
        raise RuntimeError("the configured complex grid is not 900 distinct points")

    grouped_values, grouped_metrics = run_grouped(system, points)
    naive_values, naive_metrics = run_naive(system, points)
    point_records: list[dict[str, Any]] = []
    grouped_closed_errors: list[float] = []
    naive_closed_errors: list[float] = []
    grouped_naive_errors: list[float] = []
    for index, (point, grouped_value, naive_value) in enumerate(
        zip(points, grouped_values, naive_values, strict=True)
    ):
        expected = closed_form(point)
        error_gc = relative_error(grouped_value, expected)
        error_nc = relative_error(naive_value, expected)
        error_gn = relative_error(grouped_value, naive_value)
        grouped_closed_errors.append(error_gc)
        naive_closed_errors.append(error_nc)
        grouped_naive_errors.append(error_gn)
        point_records.append(
            {
                "index": index,
                "coordinate": point_text(point),
                "closed_form": matrix_text(expected),
                "grouped_value": matrix_text(grouped_value),
                "naive_value": matrix_text(naive_value),
                "grouped_vs_closed": error_gc,
                "naive_vs_closed": error_nc,
                "grouped_vs_naive": error_gn,
            }
        )

    checks = {
        "point_count": len(points),
        "grouped_result_count": len(grouped_values),
        "naive_result_count": len(naive_values),
        "grouped_vs_closed_max": max(grouped_closed_errors),
        "naive_vs_closed_max": max(naive_closed_errors),
        "grouped_vs_naive_max": max(grouped_naive_errors),
        "grouped_vs_closed_all_passed": all(value < ERROR_GATE for value in grouped_closed_errors),
        "naive_vs_closed_all_passed": all(value < ERROR_GATE for value in naive_closed_errors),
        "grouped_vs_naive_all_passed": all(value < ERROR_GATE for value in grouped_naive_errors),
    }
    overall_passed = all(
        (
            checks["point_count"] == 900,
            checks["grouped_result_count"] == 900,
            checks["naive_result_count"] == 900,
            checks["grouped_vs_closed_all_passed"],
            checks["naive_vs_closed_all_passed"],
            checks["grouped_vs_naive_all_passed"],
            grouped_metrics["execution_action"] == "execute_existing_plan_without_replanning",
            grouped_metrics["no_replanning_sentinel_calls"] == 0,
            grouped_metrics["target_relative_error_met"],
            naive_metrics["all_target_relative_error_met"],
        )
    )
    summary = {
        "schema": "flintnde_0_3_0_independent_validation_v1",
        "date": "2026-08-13",
        "target": str(VERSION_ROOT.relative_to(FLINTNDE_ROOT.parent)).replace("\\", "/"),
        "environment": {
            "python": sys.version.replace("\n", " "),
            "python_flint": getattr(sys.modules["flint"], "__version__", "unknown"),
            "platform": platform.platform(),
        },
        "configuration": {
            "grid_shape": [30, 30],
            "point_order": "row-wise snake path",
            "working_precision_digits": DECIMAL_DIGITS,
            "working_precision_bits": configured_bits,
            "flint_context_precision_bits": int(ctx.prec),
            "primary_order": PRIMARY_ORDER,
            "reference_order": REFERENCE_ORDER,
            "target_relative_error": TARGET_RELATIVE_ERROR,
            "pointwise_error_gate": ERROR_GATE,
            "plan_serialization_digits": PLAN_SERIALIZATION_DIGITS,
        },
        "source_sha256": {
            "flintnde_init_py": sha256(VERSION_ROOT / "flintnde" / "__init__.py"),
            "singularity_jump_py": sha256(VERSION_ROOT / "flintnde" / "singularity_jump.py"),
            "core_py": sha256(VERSION_ROOT / "flintnde" / "core.py"),
        },
        "routes": {
            "grouped_dense": grouped_metrics,
            "naive_pointwise": naive_metrics,
        },
        "comparison": {
            "naive_over_grouped_total_speedup": (
                naive_metrics["total_seconds"] / grouped_metrics["total_seconds"]
            ),
        },
        "checks": checks,
        "points": point_records,
        "overall_passed": overall_passed,
    }
    write_json(SUMMARY_PATH, summary)
    REPORT_PATH.write_text(make_report(summary), encoding="utf-8")

    # 写出后严格解码，并拒绝 replacement character，覆盖用户实际打开文件的边界。
    for output_path in (PLAN_PATH, SUMMARY_PATH, REPORT_PATH):
        decoded = output_path.read_bytes().decode("utf-8", errors="strict")
        if "\ufffd" in decoded:
            raise RuntimeError(f"replacement character found in {output_path}")
    if not overall_passed:
        raise RuntimeError("FlintNDE 0.3.0 independent validation failed")
    print(json.dumps({"overall_passed": True, "summary": str(SUMMARY_PATH)}, ensure_ascii=True))


if __name__ == "__main__":
    main()
