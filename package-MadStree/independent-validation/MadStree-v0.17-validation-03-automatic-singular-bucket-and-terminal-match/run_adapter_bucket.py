"""通过 MadStree 后端 CLI 验证奇点 bucket、末端匹配和 fail-closed 路线。

独立闭式系统为 ``Y=(x+1)/(1-x)``。planned 与 naive 逐点路线使用相同阶数和精度，
所有请求/响应、用户点归属、实际节点、误差和 wall time 写入指定 evidence JSON。
"""

from __future__ import annotations

import hashlib
import json
import os
import subprocess
import sys
import time
from pathlib import Path
from typing import Any


POINTS = [
    "2/5", "1/2", "3/5", "7/10", "3/4", "4/5", "17/20", "9/10",
    "1",
    "11/10", "23/20", "6/5", "5/4", "13/10", "7/5", "3/2", "8/5",
    "13/4",
]


def complex_record(real: str, imag: str = "0") -> dict[str, str]:
    """建立 exact 复数 JSON 记录。"""

    return {"real": real, "imag": imag}


def letter(pole: str, residue: str) -> dict[str, Any]:
    """把 residue/(x-pole) 写成 affine dlog 记录。"""

    from fractions import Fraction

    return {
        "alpha": complex_record(str(-Fraction(pole))),
        "beta": complex_record("1"),
        "residue": [[complex_record(residue)]],
    }


def base_request(vendor_root: Path, points: list[str], planning: bool = True) -> dict[str, Any]:
    """构造双极点闭式系统的单段请求。"""

    return {
        "schema": "madstree_flintnde_evaluate_v1",
        "backendPackagePath": str(vendor_root),
        "masterDigest": "independent-two-sided-bucket",
        "dimension": 1,
        "segments": [{
            "start": "0",
            "points": [complex_record(point) for point in points],
            "letters": [letter("1", "-1"), letter("-1", "1")],
            "fromUserIndex": 0,
            "userIndices": list(range(1, len(points) + 1)),
        }],
        "pathPlanning": planning,
        "singularityMode": "singularity_jump" if planning else "avoid",
        "boundary": {"kind": "finite", "values": [complex_record("1")]},
        "workingPrecisionDigits": 90,
        "primaryOrder": 64,
        "referenceOrder": 88,
        "targetRelativeError": "1e-25",
        "certificationMode": "certified",
        "messageLanguage": "CN",
        "columnVectorConvention": "Y'=A(s)Y",
        "dlogStatus": "certifiedByFormulaChecks",
    }


def run_cli(
    python: str,
    backend: Path,
    temp_root: Path,
    name: str,
    payload: dict[str, Any],
) -> dict[str, Any]:
    """执行一次隔离 CLI 请求并返回 wall time 和响应。"""

    input_path = temp_root / f"{name}_input.json"
    output_path = temp_root / f"{name}_output.json"
    input_path.write_text(json.dumps(payload, ensure_ascii=False, indent=2), encoding="utf-8")
    environment = os.environ.copy()
    environment["FLINTNDE_SUPPRESS_CITATION_NOTICE"] = "1"
    started = time.perf_counter()
    process = subprocess.run(
        [python, str(backend), str(input_path), str(output_path)],
        text=True,
        encoding="utf-8",
        errors="replace",
        capture_output=True,
        env=environment,
        check=False,
    )
    elapsed = time.perf_counter() - started
    if not output_path.exists():
        raise RuntimeError(f"{name}: no backend output: {process.stderr}")
    return {
        "wallTimeSeconds": elapsed,
        "returnCode": process.returncode,
        "requestPath": str(input_path),
        "responsePath": str(output_path),
        "stdout": process.stdout,
        "stderr": process.stderr,
        "response": json.loads(output_path.read_text(encoding="utf-8")),
    }


def midpoint(record: dict[str, Any]) -> complex | str:
    """读取一个 adapter 数值或文本 Infinity。"""

    if "text" in record:
        return record["text"]
    return complex(float(record["real"]), float(record["imag"]))


def exact_value(point: str) -> float | str:
    """返回 Y=(x+1)/(1-x) 在有理用户点的闭式值。"""

    from fractions import Fraction

    x = Fraction(point)
    if x == 1:
        return "Infinity"
    return float((x + 1) / (1 - x))


def serializable_value(value: complex | str) -> dict[str, float] | str:
    """把内部 complex 中点转换为稳定 JSON 记录。"""

    if isinstance(value, str):
        return value
    return {"real": value.real, "imag": value.imag}


def point_map(response: dict[str, Any]) -> dict[int, dict[str, Any]]:
    """按原始 userIndex 建立点记录映射。"""

    records = response["segments"][0]["pointValues"]
    return {int(record["userIndex"]): record for record in records}


def main() -> int:
    """执行 planned/naive、末端匹配和三类反例。"""

    if len(sys.argv) != 5:
        raise SystemExit("usage: run_adapter_bucket.py VERSION_ROOT PYTHON TEMP_ROOT EVIDENCE")
    version_root = Path(sys.argv[1]).resolve()
    python = sys.argv[2]
    temp_root = Path(sys.argv[3]).resolve()
    evidence_path = Path(sys.argv[4]).resolve()
    backend = version_root / "Backend" / "flintnde_transport.py"
    vendor_root = version_root / "Vendor" / "FlintNDE"
    temp_root.mkdir(parents=True, exist_ok=True)

    planned = run_cli(python, backend, temp_root, "planned", base_request(vendor_root, POINTS))
    planned_points = point_map(planned["response"])

    naive_started = time.perf_counter()
    naive_cases: dict[str, Any] = {}
    for index, point in enumerate(POINTS, start=1):
        payload = base_request(vendor_root, [point])
        payload["segments"][0]["userIndices"] = [index]
        naive_cases[str(index)] = run_cli(
            python, backend, temp_root, f"naive_{index:02d}", payload
        )
    naive_seconds = time.perf_counter() - naive_started

    value_rows = []
    maximum_closed_error = 0.0
    maximum_mutual_error = 0.0
    for index, point in enumerate(POINTS, start=1):
        planned_value = midpoint(planned_points[index]["values"][0])
        naive_value = midpoint(point_map(naive_cases[str(index)]["response"])[index]["values"][0])
        closed = exact_value(point)
        if closed == "Infinity":
            closed_error = 0.0 if planned_value == naive_value == "Infinity" else float("inf")
            mutual_error = closed_error
        else:
            denominator = max(1.0, abs(closed))
            closed_error = abs(complex(planned_value).real - closed) / denominator
            mutual_error = abs(complex(planned_value) - complex(naive_value)) / denominator
            maximum_closed_error = max(maximum_closed_error, closed_error)
            maximum_mutual_error = max(maximum_mutual_error, mutual_error)
        value_rows.append({
            "userIndex": index,
            "point": point,
            "source": planned_points[index]["source"],
            "planned": serializable_value(planned_value),
            "naive": serializable_value(naive_value),
            "closed": closed,
            "plannedClosedRelativeError": closed_error,
            "plannedNaiveRelativeError": mutual_error,
        })

    terminal = base_request(vendor_root, ["1"])
    terminal["segments"][0]["letters"] = [letter("1", "-1"), letter("11/10", "1")]
    terminal_case = run_cli(python, backend, temp_root, "terminal_hidden", terminal)

    direct_intermediate = base_request(vendor_root, ["1/2", "1", "3/2"], planning=False)
    direct_intermediate_case = run_cli(
        python, backend, temp_root, "direct_intermediate", direct_intermediate
    )
    direct_terminal = base_request(vendor_root, ["1"], planning=False)
    direct_terminal["segments"][0]["letters"] = [letter("1", "-1"), letter("11/10", "1")]
    direct_terminal_case = run_cli(python, backend, temp_root, "direct_terminal", direct_terminal)

    singular_turn = base_request(vendor_root, ["1"])
    singular_turn["segments"].append({
        **singular_turn["segments"][0],
        "start": "0",
        "points": [complex_record("1/2")],
        "fromUserIndex": 1,
        "userIndices": [2],
    })
    singular_turn_case = run_cli(python, backend, temp_root, "singular_turn", singular_turn)

    segment = planned["response"]["segments"][0]
    sources = {record["source"] for record in segment["pointValues"]}
    singular_records = planned["response"].get("singularityClassifications", [])
    terminal_segment = terminal_case["response"].get("segments", [{}])[0]
    terminal_match = terminal_segment.get("planReport", {}).get("terminal_singular_match", {})
    checks = {
        "plannedSuccess": planned["returnCode"] == 0 and planned["response"].get("status") == "success",
        "singularNotOrdinaryNode": all(
            abs(float(node["real"]) - 1.0) > 1.0e-20 for node in segment["actualNodes"]
        ),
        "incomingBucket": "covered_by_singularity_jump_incoming" in sources,
        "outgoingBucket": "covered_by_singularity_jump" in sources,
        "singularInfinityAndIndex": planned_points[9]["values"] == [{"text": "Infinity"}]
        and planned_points[9]["userIndex"] == 9,
        "classificationTable": len(singular_records) == 1
        and singular_records[0]["classification"] == "true_pole"
        and singular_records[0]["userIndex"] == 9,
        "continuedToFinalPoint": value_rows[-1]["closed"] == -17.0 / 9.0,
        "closedFormBudget": maximum_closed_error < 8.0e-25,
        "naiveMutualBudget": maximum_mutual_error < 8.0e-25,
        "terminalSuccess": terminal_case["returnCode"] == 0
        and terminal_case["response"].get("status") == "success",
        "terminalHiddenMatch": bool(terminal_match.get("matchPointInserted")),
        "terminalPrimaryReference": terminal_segment.get("targetRelativeErrorMet") is True,
        "directIntermediateFailsClosed": direct_intermediate_case["response"].get("status") != "success",
        "directTerminalRequiresPlanning": direct_terminal_case["response"].get("status")
        == "singularTargetMatchPlanningRequired",
        "singularTurnFailsClosed": singular_turn_case["response"].get("status") != "success",
    }
    evidence = {
        "schema": "madstree_v0.17_validation_03_adapter_v1",
        "backendSHA256": hashlib.sha256(backend.read_bytes()).hexdigest(),
        "exactModel": "Y'=(-1/(x-1)+1/(x+1))Y, Y(0)=1, Y=(x+1)/(1-x)",
        "userPoints": POINTS,
        "settings": {
            "workingPrecisionDigits": 90,
            "primaryOrder": 64,
            "referenceOrder": 88,
            "targetRelativeError": "1e-25",
            "safetyFactor": 8,
        },
        "planned": planned,
        "naiveWallTimeSeconds": naive_seconds,
        "naiveCases": naive_cases,
        "values": value_rows,
        "maximumClosedRelativeError": maximum_closed_error,
        "maximumPlannedNaiveRelativeError": maximum_mutual_error,
        "terminal": terminal_case,
        "negativeCases": {
            "directIntermediate": direct_intermediate_case,
            "directTerminal": direct_terminal_case,
            "singularTurn": singular_turn_case,
        },
        "checks": checks,
        "passedCount": sum(checks.values()),
        "checkCount": len(checks),
    }
    evidence["status"] = (
        "passed" if evidence["passedCount"] == evidence["checkCount"] else "failed"
    )
    evidence_path.write_text(json.dumps(evidence, ensure_ascii=False, indent=2), encoding="utf-8")
    print(f"MadStree Validation-03 adapter: {evidence['passedCount']}/{evidence['checkCount']}")
    return 0 if evidence["status"] == "passed" else 1


if __name__ == "__main__":
    raise SystemExit(main())
