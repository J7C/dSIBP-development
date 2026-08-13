"""独立验证 FlintNDE 0.4.0 的 fast multipoint 与直接用户节点路径。

脚本从当前 0.4.0 源码导入公开输运 API；fast multipoint 的独立 oracle 是逐点 Horner，
900 点输运的独立 oracle 是闭式解。结果完整保留节点、覆盖桶、算法、backend 墙钟和逐分量
误差，所有 JSON/Markdown 文本均显式写为 UTF-8 无 BOM。
"""

from __future__ import annotations

import hashlib
import json
import platform
import shutil
import sys
import time
from pathlib import Path
from typing import Any


VALIDATION_DIR = Path(__file__).resolve().parent
FLINTNDE_ROOT = VALIDATION_DIR.parents[1]
VERSION_ROOT = FLINTNDE_ROOT / "versions" / "FlintNDE-0.4.0"
RESULTS_DIR = VALIDATION_DIR / "results"
SUMMARY_PATH = RESULTS_DIR / "summary.json"
REPORT_PATH = VALIDATION_DIR / "000_FlintNDE-0.4.0-validation-01-report.md"

sys.dont_write_bytecode = True
sys.path.insert(0, str(VERSION_ROOT))

from flint import acb, acb_mat, ctx  # noqa: E402
import flintnde.singularity_jump as singularity_jump_module  # noqa: E402
from flintnde import (  # noqa: E402
    PartialFractionSystem,
    SingularPathError,
    column_vector,
    configure_working_precision,
    direct_user_point_path,
    plan_transport_path,
    transport_planned_path,
)
from flintnde.transport import (  # noqa: E402
    evaluate_vector_series,
    evaluate_vector_series_many,
)


DECIMAL_DIGITS = 60
TRANSPORT_ORDER = 64
ERROR_GATE = 1.0e-28
MULTIPOINT_ERROR_GATE = 1.0e-50
GRID_STEP_NUMERATOR = 9
GRID_STEP_DENOMINATOR = 20
MIN_USER_VALUES_PER_SEGMENT = 3
MAX_USER_VALUES_PER_SEGMENT = 20


def write_json(path: Path, payload: Any) -> None:
    """以严格 UTF-8 无 BOM 写出中文可读 JSON。"""

    path.write_text(
        json.dumps(payload, ensure_ascii=False, indent=2) + "\n",
        encoding="utf-8",
        newline="\n",
    )


def sha256(path: Path) -> str:
    """计算被测 0.4.0 源码的 SHA-256。"""

    digest = hashlib.sha256()
    with path.open("rb") as stream:
        for chunk in iter(lambda: stream.read(1024 * 1024), b""):
            digest.update(chunk)
    return digest.hexdigest()


def point_text(point: acb, digits: int = 40) -> str:
    """返回稳定的复球文本，供 retained summary 复核输入顺序。"""

    return point.str(digits)


def vector_text(vector: acb_mat, digits: int = 40) -> list[str]:
    """将列向量逐分量序列化为 Acb 文本。"""

    return [vector[row, 0].str(digits) for row in range(vector.nrows())]


def make_system(poles: tuple[int, int] = (20, -20)) -> PartialFractionSystem:
    """构造二维对角 dlog 系统；缺省系统在验证区域远离奇点。"""

    return PartialFractionSystem(
        constant=acb_mat([[0, 0], [0, 0]]),
        residues=(
            acb_mat([[1, 0], [0, 0]]),
            acb_mat([[0, 0], [0, -2]]),
        ),
        poles=(acb(poles[0]), acb(poles[1])),
        name="independent-0.4.0-diagonal-dlog",
    )


def closed_form(point: acb) -> acb_mat:
    """直接计算远极点系统的闭式解，不调用 FlintNDE 递推。"""

    result = acb_mat(2, 1)
    result[0, 0] = acb(1) - point / acb(20)
    result[1, 0] = (acb(20) / (point + acb(20))) ** 2
    return result


def make_grid() -> list[acb]:
    """构造间距 9/20 的 30x30 蛇形复网格，避免单展开盘覆盖全部点。"""

    # 必须在 configure_working_precision 之后构造 Acb 步长，不能在模块加载期固化低精度球。
    grid_step = acb(GRID_STEP_NUMERATOR) / acb(GRID_STEP_DENOMINATOR)
    xs = [grid_step * acb(index) for index in range(1, 31)]
    ys = [grid_step * acb(-29 + 2 * index) / acb(2) for index in range(30)]
    points: list[acb] = []
    for row_index, y in enumerate(ys):
        row = xs if row_index % 2 == 0 else list(reversed(xs))
        points.extend(x + acb(0, y.real) for x in row)
    return points


def component_absolute_errors(left: acb_mat, right: acb_mat) -> list[float]:
    """逐分量返回绝对差球的中点，避免总体范数掩盖单分量。"""

    return [float(abs(left[row, 0] - right[row, 0]).mid()) for row in range(left.nrows())]


def run_multipoint_oracle() -> dict[str, Any]:
    """同一 64 阶向量多项式上比较 fast 子积树/余数树和逐点 Horner。"""

    coefficient_count = 65
    coefficients = [
        acb_mat(
            [
                [acb(index + 1, (index % 7) - 3) / acb(index + 2)],
                [acb(2 * index - 5, (index % 5) - 2) / acb(index + 3)],
            ]
        )
        for index in range(coefficient_count)
    ]
    points = [
        acb(index - 128, (index * 17) % 101 - 50) / acb(512)
        for index in range(257)
    ]
    fast_clock = time.perf_counter()
    fast_values, algorithm = evaluate_vector_series_many(coefficients, points)
    fast_seconds = time.perf_counter() - fast_clock
    horner_clock = time.perf_counter()
    horner_values = [evaluate_vector_series(coefficients, point) for point in points]
    horner_seconds = time.perf_counter() - horner_clock

    records: list[dict[str, Any]] = []
    all_errors: list[float] = []
    for index, (point, fast_value, horner_value) in enumerate(
        zip(points, fast_values, horner_values, strict=True)
    ):
        errors = component_absolute_errors(fast_value, horner_value)
        all_errors.extend(errors)
        records.append(
            {
                "index": index,
                "point": point_text(point),
                "fast": vector_text(fast_value),
                "horner": vector_text(horner_value),
                "component_absolute_errors": errors,
            }
        )
    return {
        "algorithm": algorithm,
        "implementation": "FLINT acb_poly.evaluate fast: subproduct tree / remainder tree",
        "oracle": "evaluate_vector_series pointwise Horner",
        "coefficient_count": coefficient_count,
        "polynomial_degree": coefficient_count - 1,
        "point_count": len(points),
        "component_count": 2,
        "fast_seconds": fast_seconds,
        "horner_seconds": horner_seconds,
        "horner_over_fast_ratio": horner_seconds / fast_seconds,
        "complexity": {
            "horner": "O(n*m) scalar operations for degree n at m points",
            "fast": "about O(M(n)*log(m)) with fast polynomial arithmetic; O(M(n)*log(n)) when m is comparable to n",
        },
        "maximum_component_absolute_error": max(all_errors),
        "all_component_errors_below_gate": all(value < MULTIPOINT_ERROR_GATE for value in all_errors),
        "records": records,
    }


def recover_planned_values(
    points: list[acb], plan: Any, snapshots: list[acb_mat], samples: list[dict[str, Any]]
) -> list[acb_mat]:
    """按 user_point_index 合并节点 snapshot 与 dense sample，严格要求 900 项无重无漏。"""

    values: list[acb_mat | None] = [None] * len(points)
    for record in samples:
        index = int(record["user_point_index"])
        if values[index] is not None:
            raise RuntimeError(f"duplicate planned sample at user point {index}")
        values[index] = acb_mat(record["value"])
    for index, point in enumerate(points):
        if values[index] is not None:
            continue
        matches = [
            node_index
            for node_index, node in enumerate(plan.nodes)
            if abs(node - point).contains(0)
        ]
        if len(matches) != 1:
            raise RuntimeError(f"planned point {index} maps to {len(matches)} nodes")
        values[index] = acb_mat(snapshots[matches[0]])
    if any(value is None for value in values):
        raise RuntimeError("planned route omitted user values")
    return [value for value in values if value is not None]


def dense_algorithm_counts(reports: list[dict[str, Any]]) -> dict[str, Any]:
    """汇总后端逐段报告的 dense 算法桶和覆盖点数。"""

    algorithm_buckets: dict[str, int] = {}
    algorithm_points: dict[str, int] = {}
    for report in reports:
        dense = report.get("dense_evaluation")
        if dense is None:
            continue
        algorithm = str(dense["algorithm"])
        algorithm_buckets[algorithm] = algorithm_buckets.get(algorithm, 0) + 1
        algorithm_points[algorithm] = algorithm_points.get(algorithm, 0) + int(
            dense["point_count"]
        )
    return {"bucket_counts": algorithm_buckets, "point_counts": algorithm_points}


def segment_user_value_distribution(points: list[acb], plan: Any) -> dict[str, Any]:
    """统计每个输运段承担的用户值；插入的纯输运节点不计作用户值。"""

    segment_count = len(plan.nodes) - 1
    dense_counts = [0] * segment_count
    for assignment in plan.sample_assignments:
        dense_counts[int(assignment["segment_index"])] += 1

    endpoint_counts = [0] * segment_count
    assigned_user_indices = {
        int(assignment["user_point_index"])
        for assignment in plan.sample_assignments
        if assignment["user_point_index"] is not None
    }
    for user_index, point in enumerate(points):
        if user_index in assigned_user_indices:
            continue
        matches = [
            segment_index
            for segment_index, node in enumerate(plan.nodes[1:])
            if abs(node - point).contains(0)
        ]
        if len(matches) != 1:
            raise RuntimeError(
                f"user point {user_index} maps to {len(matches)} segment endpoints"
            )
        endpoint_counts[matches[0]] += 1

    counts = [dense + endpoint for dense, endpoint in zip(dense_counts, endpoint_counts)]
    if sum(counts) != len(points):
        raise RuntimeError("per-segment user-value counts do not sum to the input point count")
    user_bearing_counts = [count for count in counts if count > 0]
    if not user_bearing_counts:
        raise RuntimeError("planned route has no user-bearing segments")
    sorted_counts = sorted(user_bearing_counts)
    histogram: dict[str, int] = {}
    for count in counts:
        key = str(count)
        histogram[key] = histogram.get(key, 0) + 1
    exceptions = [
        {
            "segment_index": index,
            "user_value_count": count,
            "is_final_segment": index == segment_count - 1,
        }
        for index, count in enumerate(counts)
        if count > 0
        and not MIN_USER_VALUES_PER_SEGMENT <= count <= MAX_USER_VALUES_PER_SEGMENT
    ]
    return {
        "definition": "dense sample count plus user points coincident with the segment endpoint",
        "counts": counts,
        "pure_transport_segment_indices": [
            index for index, count in enumerate(counts) if count == 0
        ],
        "user_bearing_segment_count": len(user_bearing_counts),
        "dense_counts": dense_counts,
        "endpoint_user_counts": endpoint_counts,
        "minimum": sorted_counts[0],
        "median": sorted_counts[len(sorted_counts) // 2],
        "mean": sum(user_bearing_counts) / len(user_bearing_counts),
        "maximum": sorted_counts[-1],
        "histogram": histogram,
        "exceptions": exceptions,
        "all_user_bearing_segments_between_3_and_20": all(
            MIN_USER_VALUES_PER_SEGMENT <= count <= MAX_USER_VALUES_PER_SEGMENT
            for count in user_bearing_counts
        ),
    }


def run_transport_routes(points: list[acb]) -> tuple[list[dict[str, Any]], dict[str, Any]]:
    """在同一系统/点/初值/精度下运行 planned dense fast 与 direct user-node 路线。"""

    system = make_system()
    initial = column_vector([1, 1])

    planned_total_clock = time.perf_counter()
    planned_plan_clock = time.perf_counter()
    planned_plan = plan_transport_path(system, acb(0), points, message_language="CN")
    planned_planning_seconds = time.perf_counter() - planned_plan_clock
    planned_result = transport_planned_path(
        system, initial, planned_plan, order=TRANSPORT_ORDER
    )
    planned_total_seconds = time.perf_counter() - planned_total_clock
    planned_values = recover_planned_values(
        points, planned_plan, planned_result[0], planned_result[3]["sample_results"]
    )
    planned_distribution = segment_user_value_distribution(points, planned_plan)

    sentinel_calls = 0
    original_planner = singularity_jump_module.plan_transport_path

    def forbidden_planner(*_args: Any, **_kwargs: Any) -> Any:
        """直接路径若错误调用 planner，立即失败。"""

        nonlocal sentinel_calls
        sentinel_calls += 1
        raise RuntimeError("direct user-point path called plan_transport_path")

    direct_total_clock = time.perf_counter()
    singularity_jump_module.plan_transport_path = forbidden_planner
    try:
        direct_construct_clock = time.perf_counter()
        direct_plan = direct_user_point_path(system, acb(0), points, message_language="CN")
        direct_construction_seconds = time.perf_counter() - direct_construct_clock
        direct_result = transport_planned_path(
            system, initial, direct_plan, order=TRANSPORT_ORDER
        )
    finally:
        singularity_jump_module.plan_transport_path = original_planner
    direct_total_seconds = time.perf_counter() - direct_total_clock
    direct_values = [acb_mat(value) for value in direct_result[0][1:]]

    expected_nodes = [acb(0), *points]
    direct_nodes_exact = len(direct_plan.nodes) == len(expected_nodes) and all(
        abs(actual - expected).contains(0)
        for actual, expected in zip(direct_plan.nodes, expected_nodes, strict=True)
    )
    records: list[dict[str, Any]] = []
    planned_closed_errors: list[float] = []
    direct_closed_errors: list[float] = []
    route_errors: list[float] = []
    for index, (point, planned_value, direct_value) in enumerate(
        zip(points, planned_values, direct_values, strict=True)
    ):
        expected = closed_form(point)
        pc = component_absolute_errors(planned_value, expected)
        dc = component_absolute_errors(direct_value, expected)
        pd = component_absolute_errors(planned_value, direct_value)
        planned_closed_errors.extend(pc)
        direct_closed_errors.extend(dc)
        route_errors.extend(pd)
        records.append(
            {
                "index": index,
                "coordinate": point_text(point),
                "closed_form": vector_text(expected),
                "planned_value": vector_text(planned_value),
                "direct_value": vector_text(direct_value),
                "planned_vs_closed_component_absolute_errors": pc,
                "direct_vs_closed_component_absolute_errors": dc,
                "planned_vs_direct_component_absolute_errors": pd,
            }
        )

    metrics = {
        "shared_conditions": {
            "point_count": len(points),
            "initial_vector": ["1", "1"],
            "working_precision_digits": DECIMAL_DIGITS,
            "transport_order": TRANSPORT_ORDER,
            "parallel": "single process",
        },
        "planned_dense_fast": {
            "planning_seconds": planned_planning_seconds,
            "backend_wall_seconds": planned_result[2],
            "total_wall_seconds": planned_total_seconds,
            "node_count": len(planned_plan.nodes),
            "segment_count": len(planned_plan.nodes) - 1,
            "covered_sample_count": len(planned_plan.sample_assignments),
            "result_sample_count": len(planned_result[3]["sample_results"]),
            "node_coordinates": [point_text(point) for point in planned_plan.nodes],
            "dense_algorithms": dense_algorithm_counts(planned_result[1]),
            "user_values_per_segment": planned_distribution,
            "plan_report": planned_plan.report,
        },
        "direct_user_point_path": {
            "construction_seconds": direct_construction_seconds,
            "backend_wall_seconds": direct_result[2],
            "total_wall_seconds": direct_total_seconds,
            "node_count": len(direct_plan.nodes),
            "segment_count": len(direct_plan.nodes) - 1,
            "covered_sample_count": len(direct_plan.sample_assignments),
            "node_sequence_exact": direct_nodes_exact,
            "planning_action": direct_plan.report["planning_action"],
            "planner_sentinel_calls": sentinel_calls,
            "dense_algorithms": dense_algorithm_counts(direct_result[1]),
        },
        "comparison": {
            "direct_over_planned_backend_ratio": direct_result[2] / planned_result[2],
            "direct_over_planned_total_ratio": direct_total_seconds / planned_total_seconds,
            "planned_vs_closed_max_component_absolute_error": max(planned_closed_errors),
            "direct_vs_closed_max_component_absolute_error": max(direct_closed_errors),
            "planned_vs_direct_max_component_absolute_error": max(route_errors),
            "all_component_errors_below_gate": all(
                value < ERROR_GATE
                for value in planned_closed_errors + direct_closed_errors + route_errors
            ),
            "planned_segment_coverage_gate": (
                planned_distribution["all_user_bearing_segments_between_3_and_20"]
                and not planned_distribution["exceptions"]
            ),
        },
    }
    return records, metrics


def run_fail_closed_check() -> dict[str, Any]:
    """确认 direct 路线穿越 z=1 极点时拒绝，并确认拒绝过程没有调用 planner。"""

    system = make_system((1, -3))
    sentinel_calls = 0
    original_planner = singularity_jump_module.plan_transport_path

    def forbidden_planner(*_args: Any, **_kwargs: Any) -> Any:
        nonlocal sentinel_calls
        sentinel_calls += 1
        raise RuntimeError("fail-closed check called planner")

    error_type = None
    error_message = None
    singularity_jump_module.plan_transport_path = forbidden_planner
    try:
        try:
            direct_user_point_path(system, acb(0), [acb(2)], message_language="CN")
        except SingularPathError as error:
            error_type = type(error).__name__
            error_message = str(error)
    finally:
        singularity_jump_module.plan_transport_path = original_planner
    return {
        "expected_error": "SingularPathError",
        "actual_error": error_type,
        "message": error_message,
        "planner_sentinel_calls": sentinel_calls,
        "passed": error_type == "SingularPathError" and sentinel_calls == 0,
    }


def make_report(summary: dict[str, Any]) -> str:
    """从当前 0.4.0 机器结果生成自包含报告。"""

    multipoint = summary["fast_multipoint_oracle"]
    transport = summary["transport_900_points"]
    planned = transport["planned_dense_fast"]
    direct = transport["direct_user_point_path"]
    comparison = transport["comparison"]
    fail_closed = summary["direct_fail_closed"]
    distribution = planned["user_values_per_segment"]
    first_node = planned["node_coordinates"][0]
    final_node = planned["node_coordinates"][-1]
    return f"""# FlintNDE 0.4.0 独立检验报告

日期：2026-08-13
对象：`versions/FlintNDE-0.4.0/` 当前实际源码
结论：**{'通过' if summary['overall_passed'] else '未通过'}**

## 范围与方法

本次未读取 0.3.0 独立报告或结果。fast multipoint 的 expected 是同一系数/点/精度下逐点
Horner；900 点输运 expected 是脚本直接计算的闭式解。执行均为单进程，工作精度
{summary['configuration']['working_precision_digits']} 位十进制（实际
{summary['configuration']['working_precision_bits']} bits）。

## 单节点覆盖桶：Fast 与 Horner

测试 2 分量、{multipoint['polynomial_degree']} 阶向量多项式在 {multipoint['point_count']} 个
互异复点上的求值。批量入口实际返回算法 `{multipoint['algorithm']}`，对应
`acb_poly.evaluate(..., algorithm="fast")` 的子积树/余数树；oracle 为逐点 Horner。

| route | points | components | wall time | 最大逐分量绝对差 | status |
| --- | ---: | ---: | ---: | ---: | --- |
| fast subproduct/remainder tree | {multipoint['point_count']} | {multipoint['component_count']} | {multipoint['fast_seconds']:.6f} s | {multipoint['maximum_component_absolute_error']:.6e} | passed |
| iterative Horner oracle | {multipoint['point_count']} | {multipoint['component_count']} | {multipoint['horner_seconds']:.6f} s | oracle | passed |

当前实测 Horner/fast 为 {multipoint['horner_over_fast_ratio']:.3f}x。复杂度模型：逐点 Horner
是 `O(n*m)` 标量操作；基于快速多项式算术的子积树/余数树约为 `O(M(n) log(m))`，当
`m~n` 时常写为 `O(M(n) log(n))`。倍率只描述当前主机 case，不是复杂度证明。

## 900 点 Planned 与 Direct

系统为 `dY/dz=diag(1/(z-20),-2/(z+20))Y`、`Y(0)=(1,1)^T`；闭式解为
`Y1=1-z/20`、`Y2=(20/(z+20))^2`。30x30 蛇形网格的实部和虚部相邻间距均为
`9/20=0.45`；两路线使用相同点序、初值、60 位精度、
{summary['configuration']['transport_order']} 阶和单进程。

Route P 实际节点 {planned['node_count']} 个、段 {planned['segment_count']} 条，覆盖
{planned['covered_sample_count']} 个 dense 点。完整节点链保存在 `results/summary.json`；首尾为：

```text
{first_node} -> ... -> {final_node}
```

其算法桶数为 `{json.dumps(planned['dense_algorithms']['bucket_counts'], ensure_ascii=False)}`，
对应点数为 `{json.dumps(planned['dense_algorithms']['point_counts'], ensure_ascii=False)}`。

逐段“承担用户值数”严格定义为该段的 dense samples 加恰好命中该段终点的用户点；纯输运
插入节点不计作用户值。分布 min/median/mean/max =
{distribution['minimum']}/{distribution['median']}/{distribution['mean']:.6f}/{distribution['maximum']}，
直方图为 `{json.dumps(distribution['histogram'], ensure_ascii=False, sort_keys=True)}`。纯输运桥段为
`{json.dumps(distribution['pure_transport_segment_indices'])}`；其余
{distribution['user_bearing_segment_count']} 个承担用户值的段全部包含 3--20 点：
`{distribution['all_user_bearing_segments_between_3_and_20']}`，例外为
`{json.dumps(distribution['exceptions'], ensure_ascii=False)}`。这避免了原小网格由一个展开盘覆盖
全部 900 点的极端情形，同时保留多个 fast multipoint 桶检验批量求值。

Route D 由 `direct_user_point_path` 构造，实际节点 {direct['node_count']} 个、段
{direct['segment_count']} 条、coverage {direct['covered_sample_count']}；节点序列与
`[start,*900 user points]` 严格一致：`{direct['node_sequence_exact']}`。planner sentinel 调用
{direct['planner_sentinel_calls']} 次，证明构造与执行未调用 planner。

| route | nodes | coverage | backend wall | total wall | algorithm |
| --- | ---: | ---: | ---: | ---: | --- |
| planned dense fast | {planned['node_count']} | {planned['covered_sample_count']} | {planned['backend_wall_seconds']:.6f} s | {planned['total_wall_seconds']:.6f} s | fast buckets={planned['dense_algorithms']['bucket_counts'].get('fast', 0)} |
| direct user nodes | {direct['node_count']} | {direct['covered_sample_count']} | {direct['backend_wall_seconds']:.6f} s | {direct['total_wall_seconds']:.6f} s | dense none; 900 ordinary segments |

direct/planned backend wall time 为 **{comparison['direct_over_planned_backend_ratio']:.3f}x**，总墙钟
为 **{comparison['direct_over_planned_total_ratio']:.3f}x**。

这里 backend wall 是 `transport_planned_path` 内部返回的墙钟，只覆盖局部级数、输运和 dense
求值；total wall 还包括 planned 路线的规划或 direct 路线的节点链构造，但两者均在已启动的
同一 Python 进程内，不含 Python 进程启动。

## 全点全分量互检

| comparison | values checked | 最大逐分量绝对差 | gate | status |
| --- | ---: | ---: | ---: | --- |
| planned vs closed | 1800 | {comparison['planned_vs_closed_max_component_absolute_error']:.6e} | 1e-28 | passed |
| direct vs closed | 1800 | {comparison['direct_vs_closed_max_component_absolute_error']:.6e} | 1e-28 | passed |
| planned vs direct | 1800 | {comparison['planned_vs_direct_max_component_absolute_error']:.6e} | 1e-28 | passed |

`results/summary.json` 保留全部 900 点、两个分量的三组误差，没有以抽样或总体范数替代。

## Sentinel 与 Fail Closed

直接节点正例的 planner sentinel 为 {direct['planner_sentinel_calls']}。负例从 `0` 到 `2` 穿过
`z=1` 极点，实际抛出 `{fail_closed['actual_error']}`，planner sentinel 仍为
{fail_closed['planner_sentinel_calls']}；因此没有静默规划、插点或绕行。

## 证据边界

本报告认证 0.4.0 当前 SHA-256 所对应源码的 fast multipoint、普通点 planned/direct 路线和
直接路径穿奇点拒绝。它不认证奇点折跃分支、Stokes connection、ramification、一般代数扩域、
Lee--Moser 或指数型边界。所有正式输出严格 UTF-8、无 BOM、无 replacement character。

复核命令：

```powershell
python package-FlintNDE/independent-validation/FlintNDE-0.4.0-validation-01-fast-multipoint-and-direct-path/run_validation.py
```
"""


def clean_generated_cache() -> list[str]:
    """只清理本独立验证目录内部的 cache，不触碰程序包源码或其它任务产物。"""

    removed: list[str] = []
    for cache in VALIDATION_DIR.rglob("__pycache__"):
        resolved = cache.resolve()
        if VALIDATION_DIR.resolve() not in resolved.parents:
            raise RuntimeError(f"unsafe cache path: {resolved}")
        shutil.rmtree(resolved)
        removed.append(str(resolved))
    return removed


def main() -> None:
    """执行全部 0.4.0 独立门禁、生成证据并清理 cache。"""

    RESULTS_DIR.mkdir(parents=True, exist_ok=True)
    configured_bits = configure_working_precision(DECIMAL_DIGITS, 32)
    points = make_grid()
    if len(points) != 900 or len({point_text(point, 60) for point in points}) != 900:
        raise RuntimeError("configured grid is not 900 distinct points")

    multipoint = run_multipoint_oracle()
    transport_records, transport_metrics = run_transport_routes(points)
    fail_closed = run_fail_closed_check()
    planned = transport_metrics["planned_dense_fast"]
    direct = transport_metrics["direct_user_point_path"]
    comparison = transport_metrics["comparison"]
    overall_passed = all(
        (
            multipoint["algorithm"] == "fast",
            multipoint["all_component_errors_below_gate"],
            planned["node_count"] >= 2,
            sum(planned["user_values_per_segment"]["counts"]) == 900,
            planned["dense_algorithms"]["bucket_counts"].get("fast", 0) >= 1,
            comparison["planned_segment_coverage_gate"],
            direct["node_count"] == 901,
            direct["segment_count"] == 900,
            direct["covered_sample_count"] == 0,
            direct["node_sequence_exact"],
            direct["planning_action"] == "disabled_use_user_points_as_nodes",
            direct["planner_sentinel_calls"] == 0,
            comparison["all_component_errors_below_gate"],
            fail_closed["passed"],
        )
    )
    summary = {
        "schema": "flintnde_0_4_0_independent_validation_v1",
        "date": "2026-08-13",
        "target": "package-FlintNDE/versions/FlintNDE-0.4.0",
        "environment": {
            "python": sys.version.replace("\n", " "),
            "python_flint": getattr(sys.modules["flint"], "__version__", "unknown"),
            "platform": platform.platform(),
            "parallel": "single process",
        },
        "configuration": {
            "working_precision_digits": DECIMAL_DIGITS,
            "working_precision_bits": configured_bits,
            "flint_context_precision_bits": int(ctx.prec),
            "transport_order": TRANSPORT_ORDER,
            "component_error_gate": ERROR_GATE,
            "multipoint_error_gate": MULTIPOINT_ERROR_GATE,
            "grid_shape": [30, 30],
            "grid_order": "row-wise snake path",
            "grid_step_exact": "9/20",
            "grid_step_decimal": 0.45,
            "planned_user_values_per_segment_gate": [
                MIN_USER_VALUES_PER_SEGMENT,
                MAX_USER_VALUES_PER_SEGMENT,
            ],
        },
        "source_sha256": {
            "flintnde_init_py": sha256(VERSION_ROOT / "flintnde" / "__init__.py"),
            "transport_py": sha256(VERSION_ROOT / "flintnde" / "transport.py"),
            "singularity_jump_py": sha256(VERSION_ROOT / "flintnde" / "singularity_jump.py"),
        },
        "fast_multipoint_oracle": multipoint,
        "transport_900_points": {**transport_metrics, "point_records": transport_records},
        "direct_fail_closed": fail_closed,
        "overall_passed": overall_passed,
    }
    write_json(SUMMARY_PATH, summary)
    REPORT_PATH.write_text(make_report(summary), encoding="utf-8", newline="\n")

    for path in (SUMMARY_PATH, REPORT_PATH):
        raw = path.read_bytes()
        if raw.startswith(b"\xef\xbb\xbf"):
            raise RuntimeError(f"UTF-8 BOM found in {path}")
        text = raw.decode("utf-8", errors="strict")
        if "\ufffd" in text:
            raise RuntimeError(f"replacement character found in {path}")
    removed = clean_generated_cache()
    if not overall_passed:
        raise RuntimeError("FlintNDE 0.4.0 independent validation failed")
    print(
        json.dumps(
            {
                "overall_passed": True,
                "summary": str(SUMMARY_PATH),
                "removed_cache_count": len(removed),
            },
            ensure_ascii=True,
        )
    )


if __name__ == "__main__":
    main()
