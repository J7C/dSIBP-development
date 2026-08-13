"""逐点 FlintNDE 基线与 900 点交叉比较。

本脚本不加载 MadStree 的序列化计划或局部系数。它只消费 MadStree 已固定的
拉回 dlog 系统、边界和数值参数，对原始用户顺序中的每个新点分别执行一次
``plan_transport_path`` 和 ``transport_planned_path_refined``。
"""

from __future__ import annotations

import hashlib
import json
import statistics
import sys
import time
import uuid
from collections import Counter
from pathlib import Path
from typing import Any


def _acb_record(value: Any, digits: int) -> dict[str, str]:
    return {
        "real": value.real.mid().str(digits, radius=False, more=True),
        "imag": value.imag.mid().str(digits, radius=False, more=True),
        "realRadius": value.real.rad().str(digits),
        "imagRadius": value.imag.rad().str(digits),
    }


def _vector_record(vector: Any, digits: int) -> list[dict[str, str]]:
    return [_acb_record(vector[row, 0], digits) for row in range(vector.nrows())]


def _midpoint_complex(record: dict[str, str]) -> complex:
    return complex(float(record["real"]), float(record["imag"]))


def _relative_errors(
    first: list[dict[str, str]], second: list[dict[str, str]]
) -> tuple[list[float], list[float]]:
    absolute: list[float] = []
    relative: list[float] = []
    for left, right in zip(first, second):
        left_value = _midpoint_complex(left)
        right_value = _midpoint_complex(right)
        difference = abs(left_value - right_value)
        absolute.append(difference)
        relative.append(difference / max(abs(right_value), 1.0e-300))
    return absolute, relative


def _sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as stream:
        for block in iter(lambda: stream.read(1024 * 1024), b""):
            digest.update(block)
    return digest.hexdigest()


def _load_system(adapter: Any, request: dict[str, Any], segment: dict[str, Any], index: int):
    from flint import acb, acb_mat
    from flintnde import gaussian_rational

    return adapter._polyline_segment_system(  # pylint: disable=protected-access
        request,
        segment,
        index,
        int(request["dimension"]),
        acb,
        acb_mat,
        gaussian_rational,
    )


def _run_naive(
    request: dict[str, Any], adapter: Any, checkpoint_path: Path
) -> dict[str, Any]:
    from flint import acb, acb_mat
    from flintnde import (
        configure_working_precision,
        plan_transport_path,
        transport_planned_path_refined,
    )

    digits = int(request["workingPrecisionDigits"])
    configure_working_precision(digits)
    vector = acb_mat(
        [[acb(item["real"], item["imag"])] for item in request["boundary"]]
    )
    seen: set[int] = set()
    records: list[dict[str, Any]] = []
    planning_seconds = 0.0
    execution_seconds = 0.0
    node_counts: list[int] = []
    all_targets_met = True
    wall_start = time.perf_counter()
    with checkpoint_path.open("w", encoding="utf-8", newline="\n") as checkpoint:
      for segment_index, segment in enumerate(request["segments"]):
        system, _segment_start, points = _load_system(
            adapter, request, segment, segment_index
        )
        current = _segment_start
        for local_index, (target, user_index) in enumerate(
            zip(points, segment["userIndices"])
        ):
            user_index = int(user_index)
            if user_index in seen:
                current = target
                continue
            plan_clock = time.perf_counter()
            plan = plan_transport_path(
                system,
                current,
                [target],
                singularity_mode=request["singularityMode"],
                message_language=request["messageLanguage"],
            )
            point_plan_seconds = time.perf_counter() - plan_clock
            planning_seconds += point_plan_seconds
            execute_clock = time.perf_counter()
            result = transport_planned_path_refined(
                system,
                vector,
                plan,
                primary_order=int(request["primaryOrder"]),
                reference_order=int(request["referenceOrder"]),
                radius_fraction=0.60,
                target_relative_error=request["targetRelativeError"],
                certification_mode=request["certificationMode"],
            )
            point_execute_seconds = time.perf_counter() - execute_clock
            execution_seconds += point_execute_seconds
            vector = result["reference_snapshots"][-1]
            current = target
            met = result["target_relative_error_met"]
            all_targets_met = all_targets_met and (met is None or bool(met))
            node_counts.append(len(plan.nodes))
            records.append(
                {
                    "userIndex": user_index,
                    "segmentIndex": segment_index,
                    "localPointIndex": local_index,
                    "planSeconds": point_plan_seconds,
                    "executionSeconds": point_execute_seconds,
                    "nodeCount": len(plan.nodes),
                    "actualPath": [node.str(40) for node in plan.nodes],
                    "relativeDifferenceInf": result[
                        "relative_difference_inf"
                    ].str(digits),
                    "targetRelativeErrorMet": (
                        True if met is None else bool(met)
                    ),
                    "values": _vector_record(vector, digits),
                }
            )
            checkpoint.write(json.dumps(records[-1], ensure_ascii=False) + "\n")
            checkpoint.flush()
            seen.add(user_index)
    wall_seconds = time.perf_counter() - wall_start
    return {
        "route": "direct-FlintNDE-cold-naive",
        "pointCount": len(records),
        "planningSeconds": planning_seconds,
        "executionSeconds": execution_seconds,
        "totalWallSeconds": wall_seconds,
        "overheadSeconds": wall_seconds - planning_seconds - execution_seconds,
        "allTargetsMet": all_targets_met,
        "nodeCountMinimum": min(node_counts),
        "nodeCountMedian": statistics.median(node_counts),
        "nodeCountMean": statistics.fmean(node_counts),
        "nodeCountMaximum": max(node_counts),
        "nodeCountHistogram": dict(sorted(Counter(node_counts).items())),
        "points": records,
    }


def _spot_checks(request: dict[str, Any], route_a: dict[str, Any], adapter: Any) -> list[dict[str, Any]]:
    from flint import acb, acb_mat
    from flintnde import plan_transport_path, transport_planned_path_refined

    selected = [3, 100, 149, 300, 303, 349, 449, 600, 603, 649, 749, 900]
    route_values = {int(item["userIndex"]): item["values"] for item in route_a["pointValues"]}
    fixed_segments = {
        int(user_index): segment_index
        for segment_index, segment in enumerate(request["segments"])
        if len(segment["userIndices"]) == 300
        for user_index in segment["userIndices"]
    }
    checks: list[dict[str, Any]] = []
    for user_index in selected:
        segment_index = fixed_segments[user_index]
        segment = request["segments"][segment_index]
        local_index = segment["userIndices"].index(user_index)
        system, start, points = _load_system(adapter, request, segment, segment_index)
        anchor_user_index = int(segment["userIndices"][0])
        boundary = acb_mat([
            [acb(item["real"], item["imag"])]
            for item in route_values[anchor_user_index]
        ])
        plan = plan_transport_path(
            system,
            start,
            [points[local_index]],
            singularity_mode="avoid",
            message_language="EN",
        )
        result = transport_planned_path_refined(
            system,
            boundary,
            plan,
            primary_order=int(request["primaryOrder"]) + 24,
            reference_order=int(request["referenceOrder"]) + 32,
            radius_fraction=0.60,
            target_relative_error="1e-24",
            certification_mode=request["certificationMode"],
        )
        value = _vector_record(result["reference_snapshots"][-1], int(request["workingPrecisionDigits"]))
        absolute, relative = _relative_errors(value, route_values[user_index])
        checks.append(
            {
                "userIndex": user_index,
                "segmentIndex": segment_index,
                "primaryOrder": int(request["primaryOrder"]) + 24,
                "referenceOrder": int(request["referenceOrder"]) + 32,
                "actualPath": [node.str(40) for node in plan.nodes],
                "targetRelativeErrorMet": bool(result["target_relative_error_met"]),
                "maximumAbsoluteDifferenceVsRouteA": max(absolute),
                "maximumRelativeDifferenceVsRouteA": max(relative),
                "values": value,
            }
        )
    return checks


def main() -> int:
    if len(sys.argv) != 5:
        raise SystemExit("usage: naive_oracle.py REQUEST ROUTE_A OUTPUT VENDOR_ROOT")
    request_path, route_a_path, output_path, vendor_root = map(Path, sys.argv[1:])
    request = json.loads(request_path.read_text(encoding="utf-8"))
    route_a = json.loads(route_a_path.read_text(encoding="utf-8"))
    sys.path.insert(0, str(vendor_root.resolve()))
    sys.path.insert(0, str((vendor_root.parent.parent / "Backend").resolve()))
    import flintnde_transport as adapter  # pylint: disable=import-error,import-outside-toplevel

    checkpoint_path = Path(output_path).with_name(
        f"naive_checkpoint_{uuid.uuid4().hex}.jsonl"
    )
    naive = _run_naive(request, adapter, checkpoint_path)
    route_a_values = {
        int(item["userIndex"]): item["values"] for item in route_a["pointValues"]
    }
    comparisons: list[dict[str, Any]] = []
    for item in naive["points"]:
        absolute, relative = _relative_errors(
            item["values"], route_a_values[int(item["userIndex"])]
        )
        comparisons.append(
            {
                "userIndex": item["userIndex"],
                "componentAbsoluteDifferences": absolute,
                "componentRelativeDifferences": relative,
                "maximumAbsoluteDifference": max(absolute),
                "maximumRelativeDifference": max(relative),
            }
        )
    spots = _spot_checks(request, route_a, adapter)
    result = {
        "schema": "madstree_v0.10_complex_grid_independent_validation_v1",
        "status": "success",
        "naive": naive,
        "comparison": {
            "pointCount": len(comparisons),
            "maximumAbsoluteDifference": max(
                item["maximumAbsoluteDifference"] for item in comparisons
            ),
            "maximumRelativeDifference": max(
                item["maximumRelativeDifference"] for item in comparisons
            ),
            "points": comparisons,
        },
        "higherOrderSpotChecks": spots,
        "sourceDigests": {
            "adapterSHA256": _sha256(Path(adapter.__file__)),
            "flintndeInitSHA256": _sha256(vendor_root / "flintnde" / "__init__.py"),
        },
        "checkpointFile": str(checkpoint_path),
    }
    Path(output_path).write_text(
        json.dumps(result, ensure_ascii=False, indent=2), encoding="utf-8"
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
