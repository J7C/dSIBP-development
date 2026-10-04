"""通过 MadStree 后端正式 CLI 验证三类有限奇点目标。

输入由本脚本独立定义，闭式解分别为 ``1-x``、``1/(1-x)`` 和
``(log(1-x),1)``。脚本不加载 MadStree producer 输出，只把结构化证据写入调用方指定路径。
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


def complex_record(real: str, imag: str = "0") -> dict[str, str]:
    """返回后端唯一接受的 exact 复数记录。"""

    return {"real": real, "imag": imag}


def request(
    vendor_root: Path,
    name: str,
    dimension: int,
    residue: list[list[dict[str, str]]],
    boundary: list[dict[str, str]],
) -> dict[str, Any]:
    """构造单段、单奇点用户目标的当前 evaluate schema。"""

    return {
        "schema": "madstree_flintnde_evaluate_v1",
        "backendPackagePath": str(vendor_root),
        "masterDigest": f"independent-{name}",
        "dimension": dimension,
        "segments": [{
            "start": "0",
            "points": [complex_record("1")],
            "letters": [{
                "alpha": complex_record("-1"),
                "beta": complex_record("1"),
                "residue": residue,
            }],
            "fromUserIndex": 0,
            "userIndices": [1],
        }],
        "pathPlanning": True,
        "singularityMode": "singularity_jump",
        "boundary": {"kind": "finite", "values": boundary},
        "workingPrecisionDigits": 90,
        "primaryOrder": 64,
        "referenceOrder": 88,
        "targetRelativeError": "1e-30",
        "certificationMode": "certified",
        "messageLanguage": "CN",
        "columnVectorConvention": "Y'=A(s)Y",
        "dlogStatus": "certifiedByFormulaChecks",
    }


def run_case(
    python: str,
    backend: Path,
    temp_root: Path,
    name: str,
    payload: dict[str, Any],
) -> dict[str, Any]:
    """写入一次正式请求、执行 CLI，并返回含 wall time 的响应。"""

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
        raise RuntimeError(f"{name}: backend produced no output: {process.stderr}")
    response = json.loads(output_path.read_text(encoding="utf-8"))
    return {
        "name": name,
        "wallTimeSeconds": elapsed,
        "returnCode": process.returncode,
        "stdout": process.stdout,
        "stderr": process.stderr,
        "requestPath": str(input_path),
        "responsePath": str(output_path),
        "response": response,
    }


def main() -> int:
    """执行三类 exact 奇点并保存机器证据。"""

    if len(sys.argv) != 5:
        raise SystemExit("usage: run_adapter_cases.py VERSION_ROOT PYTHON TEMP_ROOT EVIDENCE")
    version_root = Path(sys.argv[1]).resolve()
    python = sys.argv[2]
    temp_root = Path(sys.argv[3]).resolve()
    evidence_path = Path(sys.argv[4]).resolve()
    backend = version_root / "Backend" / "flintnde_transport.py"
    vendor_root = version_root / "Vendor" / "FlintNDE"
    temp_root.mkdir(parents=True, exist_ok=True)

    models = {
        "removable": request(
            vendor_root,
            "removable-y-equals-one-minus-x",
            1,
            [[complex_record("1")]],
            [complex_record("1")],
        ),
        "pole": request(
            vendor_root,
            "pole-y-equals-one-over-one-minus-x",
            1,
            [[complex_record("-1")]],
            [complex_record("1")],
        ),
        "log": request(
            vendor_root,
            "log-y-equals-log-one-minus-x",
            2,
            [
                [complex_record("0"), complex_record("1")],
                [complex_record("0"), complex_record("0")],
            ],
            [complex_record("0"), complex_record("1")],
        ),
    }
    cases = {
        name: run_case(python, backend, temp_root, name, payload)
        for name, payload in models.items()
    }

    expected = {
        "removable": {"classification": "removable_singularity", "values": "finite-zero"},
        "pole": {"classification": "true_pole", "values": "Infinity"},
        "log": {"classification": "log_divergent_singularity", "values": "Infinity-and-finite-one"},
    }
    checks: dict[str, bool] = {}
    for name, case in cases.items():
        response = case["response"]
        classifications = response.get("singularityClassifications", [])
        point_values = response.get("segments", [{}])[0].get("pointValues", [])
        checks[f"{name}BackendSuccess"] = (
            case["returnCode"] == 0 and response.get("status") == "success"
        )
        checks[f"{name}Classification"] = (
            len(classifications) == 1
            and classifications[0].get("classification") == expected[name]["classification"]
            and classifications[0].get("userIndex") == 1
        )
        checks[f"{name}ClassificationTable"] = (
            len(point_values) == 1
            and point_values[0].get("source") == "singular_target"
        )

    removable_values = cases["removable"]["response"]["segments"][0]["pointValues"][0]["values"]
    pole_values = cases["pole"]["response"]["segments"][0]["pointValues"][0]["values"]
    log_values = cases["log"]["response"]["segments"][0]["pointValues"][0]["values"]
    removable_classification = cases["removable"]["response"]["singularityClassifications"][0]
    last_exponent = removable_classification["sampleExponents"][-1]
    sample_scale = float(removable_classification["sampleScale"])
    removable_expected_sample = sample_scale * 10.0 ** (-last_exponent)
    checks["removableFiniteSampleMatchesClosedModel"] = (
        "real" in removable_values[0]
        and abs(float(removable_values[0]["real"]) - removable_expected_sample) < 1.0e-35
    )
    checks["poleInfinityText"] = pole_values == [{"text": "Infinity"}]
    checks["logInfinityAndFiniteOne"] = (
        log_values[0] == {"text": "Infinity"}
        and "real" in log_values[1]
        and abs(float(log_values[1]["real"]) - 1.0) < 1.0e-25
    )

    evidence = {
        "schema": "madstree_v0.17_validation_02_adapter_v1",
        "backendSHA256": hashlib.sha256(backend.read_bytes()).hexdigest(),
        "models": {
            "removable": "Y'=Y/(x-1), Y(0)=1, Y=1-x",
            "pole": "Y'=-Y/(x-1), Y(0)=1, Y=1/(1-x)",
            "log": "Y'=N Y/(x-1), N12=1, Y(0)=(0,1), Y=(log(1-x),1)",
        },
        "settings": {
            "workingPrecisionDigits": 90,
            "primaryOrder": 64,
            "referenceOrder": 88,
            "targetRelativeError": "1e-30",
        },
        "expected": expected,
        "cases": cases,
        "checks": checks,
        "passedCount": sum(checks.values()),
        "checkCount": len(checks),
    }
    evidence["status"] = (
        "passed" if evidence["passedCount"] == evidence["checkCount"] else "failed"
    )
    evidence_path.write_text(json.dumps(evidence, ensure_ascii=False, indent=2), encoding="utf-8")
    print(f"MadStree Validation-02 adapter: {evidence['passedCount']}/{evidence['checkCount']}")
    return 0 if evidence["status"] == "passed" else 1


if __name__ == "__main__":
    raise SystemExit(main())
