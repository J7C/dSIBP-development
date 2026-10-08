#!/usr/bin/env python3
"""Self-evidence recheck of the external report's section 7 (ep_parallel gate).

The external report 000_report/2026-10-3-FlintNDE Mathematica precision-loss
report, section 7, claimed that examples/ep_parallel.py declared a 1e-40 target
but passed on a hardcoded absolute-difference < 1e-30 gate, so it printed PASSED
even though the closed-form relative error was ~1.05e-37. Its own evidence
attachments are absent from the repository.

This runner regenerates that evidence against the CURRENT repository bytes: it
executes the shipped example as a subprocess, records the exit code and stdout,
parses the per-ep relative differences, and reads the declared orders/target and
the pass condition straight from the example source. It writes ep_parallel_recheck.json.

It modifies no package source.
"""

from __future__ import annotations

import ast
import json
import re
import subprocess
import sys
from pathlib import Path

HERE = Path(__file__).resolve().parent


def find_repo_root(start: Path) -> Path:
    for parent in [start, *start.parents]:
        if (parent / "package-FlintNDE" / "examples" / "ep_parallel.py").exists():
            return parent
    raise FileNotFoundError("could not locate the repository root above " + str(start))


REPO_ROOT = find_repo_root(HERE)
EXAMPLE = REPO_ROOT / "package-FlintNDE" / "examples" / "ep_parallel.py"
OUT_JSON = HERE / "ep_parallel_recheck.json"


def read_gate_facts(source: str) -> dict[str, object]:
    """Extract the declared orders/target and the literal pass condition."""
    orders = dict(
        re.findall(r"^(PRIMARY_ORDER|REFERENCE_ORDER)\s*=\s*(\d+)", source, re.M)
    )
    target = re.search(r'^TARGET_RELATIVE_ERROR\s*=\s*"([^"]+)"', source, re.M)
    # The pass condition block: capture whether it references the declared target
    # and target_relative_error_met, and whether any hardcoded 1e-30 abs gate remains.
    passed_block = re.search(r'"passed":\s*bool\((.*?)\),', source, re.S)
    passed_src = passed_block.group(1).strip() if passed_block else ""
    return {
        "primaryOrder": int(orders.get("PRIMARY_ORDER", -1)),
        "referenceOrder": int(orders.get("REFERENCE_ORDER", -1)),
        "targetRelativeError": target.group(1) if target else None,
        "passedConditionSource": passed_src,
        "gateUsesTargetRelativeErrorMet": "target_relative_error_met" in passed_src,
        "gateComparesAgainstDeclaredTarget": "TARGET_RELATIVE_ERROR" in passed_src,
        "hardcodedAbsDiff1e30GatePresent": bool(
            re.search(r"1e-30|10\*\*-30|1e-30", source)
        ),
    }


def parse_relative_errors(stdout: str) -> list[dict[str, object]]:
    rows = []
    for line in stdout.splitlines():
        line = line.strip()
        if not (line.startswith("{") and "'ep'" in line):
            continue
        try:
            rec = ast.literal_eval(line)
        except (ValueError, SyntaxError):
            continue
        rows.append(
            {
                "ep": rec.get("ep"),
                "relativeDifference": rec.get("relative_difference"),
                "passed": rec.get("passed"),
            }
        )
    return rows


def main() -> int:
    source = EXAMPLE.read_text(encoding="utf-8")
    gate = read_gate_facts(source)

    proc = subprocess.run(
        [sys.executable, str(EXAMPLE)],
        cwd=str(EXAMPLE.parent),
        capture_output=True,
        text=True,
    )
    rows = parse_relative_errors(proc.stdout)
    example_passed = proc.returncode == 0 and "PASSED" in proc.stdout

    summary = {
        "schema": "flintnde_external_report_ep_parallel_recheck_v1",
        "examplePath": str(EXAMPLE.relative_to(REPO_ROOT)),
        "pythonVersion": sys.version.split()[0],
        "exampleExitCode": proc.returncode,
        "examplePrintedPassed": example_passed,
        "gate": gate,
        "epResults": rows,
        "allEpPassed": bool(rows) and all(r["passed"] for r in rows),
        "stdout": proc.stdout,
    }
    OUT_JSON.write_text(
        json.dumps(summary, indent=1, ensure_ascii=False), encoding="utf-8"
    )
    print(f"EP_PARALLEL_RECHECK_JSON_WRITTEN exit={proc.returncode} rows={len(rows)}")
    print(
        "gate: orders="
        f"{gate['primaryOrder']}/{gate['referenceOrder']} "
        f"target={gate['targetRelativeError']} "
        f"usesMet={gate['gateUsesTargetRelativeErrorMet']} "
        f"usesDeclaredTarget={gate['gateComparesAgainstDeclaredTarget']} "
        f"hardcoded1e30={gate['hardcodedAbsDiff1e30GatePresent']}"
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
