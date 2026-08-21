"""MadStree v0.15 adapter 奇点路线的独立数值证据生成器。

正式入口是同目录 run_validation.wls；本脚本只执行 adapter actual、逐点 naive 路线和
闭式 oracle，并把 JSON 证据交回 Wolfram 入口生成 summary.wl 与 Markdown 报告。
"""

from __future__ import annotations

import hashlib
import importlib
import json
import os
import sys
import time
from pathlib import Path
from typing import Any


CASE_ROOT = Path(__file__).resolve().parent
PACKAGE_ROOT = CASE_ROOT.parents[1]
VERSION_ROOT = PACKAGE_ROOT / "versions" / "MadStree-v0.15"
BACKEND_ROOT = VERSION_ROOT / "Backend"
VENDOR_ROOT = VERSION_ROOT / "Vendor" / "FlintNDE"
RESULTS_ROOT = CASE_ROOT / "results"


def _complex(real: str, imag: str = "0") -> dict[str, str]:
    """建立 adapter 当前唯一复数 JSON 记录。"""

    return {"real": real, "imag": imag}


def _source_digest() -> str:
    """对 MadStree adapter 及其实际 Vendor Python 建立聚合 SHA-256。"""

    digest = hashlib.sha256()
    paths = [BACKEND_ROOT / "flintnde_transport.py", *sorted((VENDOR_ROOT / "flintnde").glob("*.py"))]
    for path in paths:
        digest.update(str(path.relative_to(VERSION_ROOT)).replace("\\", "/").encode("utf-8"))
        digest.update(path.read_bytes())
    return digest.hexdigest()


def _request(points: list[dict[str, str]], letters: list[dict[str, Any]], *, planning: bool) -> dict[str, Any]:
    """建立与 MadStree Wolfram 数值层相同的单段 adapter 请求。"""

    return {
        "schema": "madstree_flintnde_evaluate_v1",
        "backendPackagePath": str(VENDOR_ROOT),
        "masterDigest": "independent-v015-singular-route",
        "dimension": 1,
        "segments": [{
            "start": "0",
            "points": points,
            "letters": letters,
            "fromUserIndex": 0,
            "userIndices": list(range(1, len(points) + 1)),
        }],
        "pathPlanning": planning,
        "singularityMode": "singularity_jump" if planning else "avoid",
        "boundary": {"kind": "finite", "values": [_complex("1")]},
        "workingPrecisionDigits": 90,
        "primaryOrder": 64,
        "referenceOrder": 88,
        "targetRelativeError": "1e-25",
        "certificationMode": "certified",
        "messageLanguage": "CN",
        "columnVectorConvention": "Y'=A(s)Y",
        "dlogStatus": "certifiedByFormulaChecks",
    }


def _record_to_acb(record: dict[str, str]) -> Any:
    """把 adapter 有限值记录恢复为 Acb。"""

    from flint import acb

    return acb(record["real"], record["imag"])


def main() -> int:
    """生成 planned/naive/闭式互检和结构化反例证据。"""

    RESULTS_ROOT.mkdir(parents=True, exist_ok=True)
    os.environ["FLINTNDE_SUPPRESS_CITATION_NOTICE"] = "1"
    sys.path.insert(0, str(BACKEND_ROOT))
    sys.path.insert(0, str(VENDOR_ROOT))
    adapter = importlib.import_module("flintnde_transport")
    from flint import acb, arb

    point_texts = [
        "2/5", "1/2", "3/5", "7/10", "3/4", "4/5", "17/20", "9/10",
        "1",
        "11/10", "23/20", "6/5", "5/4", "13/10", "7/5", "3/2", "8/5",
        "13/4",
    ]
    points = [_complex(text) for text in point_texts]
    letters = [
        {"alpha": _complex("-1"), "beta": _complex("1"), "residue": [[_complex("-1")]]},
        {"alpha": _complex("1"), "beta": _complex("1"), "residue": [[_complex("1")]]},
    ]

    planned_clock = time.perf_counter()
    planned = adapter._run(adapter._validate_request(_request(points, letters, planning=True)))
    planned_seconds = time.perf_counter() - planned_clock
    if planned.get("status") != "success":
        raise RuntimeError(f"planned adapter request failed: {planned}")

    naive_clock = time.perf_counter()
    naive_records: dict[int, dict[str, Any]] = {}
    for index, point in enumerate(points, start=1):
        one = adapter._run(adapter._validate_request(_request([point], letters, planning=True)))
        if one.get("status") != "success":
            raise RuntimeError(f"naive point {index} failed: {one}")
        naive_records[index] = one["segments"][0]["pointValues"][0]
    naive_seconds = time.perf_counter() - naive_clock

    planned_records = {
        int(item["userIndex"]): item for item in planned["segments"][0]["pointValues"]
    }
    maximum_planned_closed = arb(0)
    maximum_naive_closed = arb(0)
    maximum_mutual = arb(0)
    value_rows = []
    for user_index, text in enumerate(point_texts, start=1):
        planned_value_record = planned_records[user_index]["values"][0]
        naive_value_record = naive_records[user_index]["values"][0]
        if text == "1":
            value_rows.append({
                "userIndex": user_index,
                "point": text,
                "planned": planned_value_record,
                "naive": naive_value_record,
                "closedForm": "Infinity",
            })
            continue
        point = acb(text)
        closed = (point + acb(1)) / (acb(1) - point)
        planned_value = _record_to_acb(planned_value_record)
        naive_value = _record_to_acb(naive_value_record)
        denominator = max(arb(1), abs(closed), key=lambda item: float(item.mid()))
        planned_error = abs(planned_value - closed) / denominator
        naive_error = abs(naive_value - closed) / denominator
        mutual_error = abs(planned_value - naive_value) / max(
            arb(1), abs(naive_value), key=lambda item: float(item.mid())
        )
        maximum_planned_closed = max(maximum_planned_closed, planned_error)
        maximum_naive_closed = max(maximum_naive_closed, naive_error)
        maximum_mutual = max(maximum_mutual, mutual_error)
        value_rows.append({
            "userIndex": user_index,
            "point": text,
            "planned": planned_value_record,
            "naive": naive_value_record,
            "closedForm": closed.str(50),
            "plannedClosedRelativeError": planned_error.str(50),
            "naiveClosedRelativeError": naive_error.str(50),
            "mutualRelativeError": mutual_error.str(50),
        })

    terminal_letters = [
        {"alpha": _complex("-1"), "beta": _complex("1"), "residue": [[_complex("-1")]]},
        {"alpha": _complex("-11/10"), "beta": _complex("1"), "residue": [[_complex("1")]]},
    ]
    terminal = adapter._run(
        adapter._validate_request(_request([_complex("1")], terminal_letters, planning=True))
    )
    terminal_disabled = adapter._run(
        adapter._validate_request(_request([_complex("1")], terminal_letters, planning=False))
    )
    intermediate_disabled = adapter._run(
        adapter._validate_request(_request(points, letters, planning=False))
    )
    turn_request = _request([_complex("1")], terminal_letters, planning=True)
    turn_request["segments"].append({
        "start": "1",
        "points": [_complex("1", "1")],
        "letters": terminal_letters,
        "fromUserIndex": 1,
        "userIndices": [2],
    })
    singular_turn = adapter._run(adapter._validate_request(turn_request))

    segment = planned["segments"][0]
    sources = [item["source"] for item in segment["pointValues"]]
    singular_record = planned_records[9]
    final_value = _record_to_acb(planned_records[18]["values"][0])
    terminal_segment = terminal["segments"][0] if terminal.get("status") == "success" else {}
    terminal_match = terminal_segment.get("planReport", {}).get("terminal_singular_match", {})
    checks = {
        "automaticBackendRequestSucceeded": planned.get("status") == "success",
        "singularTargetNotOrdinaryNode": not any(
            abs(_record_to_acb(node) - acb(1)).contains(0) for node in segment["actualNodes"]
        ),
        "incomingBucketPresent": "covered_by_singularity_jump_incoming" in sources,
        "outgoingBucketPresent": "covered_by_singularity_jump" in sources,
        "singularValueIsInfinity": singular_record["values"][0] == {"text": "Infinity"},
        "classificationKeepsUserIndex": planned["singularityClassifications"][0]["userIndex"] == 9,
        "continuedToClosedForm": abs(final_value - acb("-17/9")) < arb("1e-25"),
        "plannedMatchesClosedForm": maximum_planned_closed < arb("1e-25"),
        "naiveMatchesClosedForm": maximum_naive_closed < arb("1e-25"),
        "plannedMatchesNaive": maximum_mutual < arb("1e-25"),
        "terminalMatchInserted": terminal.get("status") == "success" and terminal_match.get("matchPointInserted") is True,
        "terminalPrimaryIsResult": terminal_segment.get("pointValues", [{}])[0].get("values", [{}])[0] == {"text": "Infinity"},
        "disabledTerminalMatchRefused": terminal_disabled.get("status") == "singularTargetMatchPlanningRequired",
        "disabledIntermediateRefused": intermediate_disabled.get("status") == "intermediateSingularPointRequiresPlannedJump",
        "noncollinearSingularTurnRefused": singular_turn.get("status") == "singularTurnContinuationUnsupported",
    }
    passed = sum(bool(value) for value in checks.values())
    evidence = {
        "schema": "madstree_v0_15_validation_03_python_evidence_v1",
        "status": "passed" if passed == len(checks) else "failed",
        "pythonPassed": passed,
        "pythonTotal": len(checks),
        "sourceRoot": str(VERSION_ROOT),
        "sourceDigestSha256": _source_digest(),
        "convention": "MadStree affine segment -> FlintNDE Y'(s)=A(s)Y(s), principal Acb branch",
        "system": "A(s)=-1/(s-1)+1/(s+1), Y(0)=1, Y(s)=(s+1)/(1-s)",
        "pointSequenceExact": [["s"], *[[text] for text in point_texts]],
        "actualNodes": segment["actualNodes"],
        "nodeCount": segment["nodeCount"],
        "pointAssignments": segment["pointAssignments"],
        "pointValues": segment["pointValues"],
        "singularityClassifications": planned["singularityClassifications"],
        "orders": {"primary": 64, "reference": 88},
        "workingPrecisionDigits": 90,
        "targetRelativeError": "1e-25",
        "timingSeconds": {
            "plannedAdapter": planned_seconds,
            "naivePointwiseAdapter": naive_seconds,
            "naiveOverPlanned": naive_seconds / planned_seconds,
        },
        "maximumRelativeErrors": {
            "plannedVsClosed": maximum_planned_closed.str(50),
            "naiveVsClosed": maximum_naive_closed.str(50),
            "plannedVsNaive": maximum_mutual.str(50),
        },
        "values": value_rows,
        "terminalSingularMatch": terminal_match,
        "negativeStatuses": {
            "disabledTerminal": terminal_disabled.get("status"),
            "disabledIntermediate": intermediate_disabled.get("status"),
            "noncollinearTurn": singular_turn.get("status"),
        },
        "checks": checks,
    }
    evidence_path = RESULTS_ROOT / "evidence.json"
    evidence_path.write_text(
        json.dumps(evidence, ensure_ascii=False, indent=2), encoding="utf-8"
    )
    print(f"MadStree Validation-03 Python evidence: {evidence['status']} {passed}/{len(checks)}")
    print(f"planned={planned_seconds:.9f}s naive={naive_seconds:.9f}s ratio={naive_seconds/planned_seconds:.6f}")
    return 0 if evidence["status"] == "passed" else 1


if __name__ == "__main__":
    raise SystemExit(main())
