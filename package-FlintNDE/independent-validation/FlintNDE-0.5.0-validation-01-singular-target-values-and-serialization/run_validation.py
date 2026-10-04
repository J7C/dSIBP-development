"""FlintNDE 0.5.0 奇点目标值、分类和序列化独立验证。

本脚本用三个独立闭式系统 ``y=x``、``y=1/x`` 和 ``(log(x),1)`` 作为
expected，检查 removable、true pole 与零阶 log divergence。脚本只清理本 case
的结果目录，并自动生成机器 summary 与自包含报告。
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
REPORT_PATH = CASE_ROOT / "000_FlintNDE-0.5.0-validation-01-report.md"


def fresh_output() -> None:
    """删除本 case 的旧正式结果、临时结果和自动报告。"""

    for directory in (RESULTS_ROOT, TEMP_ROOT):
        if directory.exists():
            shutil.rmtree(directory)
    if REPORT_PATH.exists():
        REPORT_PATH.unlink()
    RESULTS_ROOT.mkdir(parents=True)
    TEMP_ROOT.mkdir(parents=True)


def source_digest() -> str:
    """生成相对路径敏感的当前 Python 源码聚合哈希。"""

    digest = hashlib.sha256()
    for path in sorted((VERSION_ROOT / "flintnde").glob("*.py")):
        digest.update(path.name.encode("utf-8"))
        digest.update(path.read_bytes())
    return digest.hexdigest()


def ball_text(value: Any, digits: int = 50) -> str:
    """以稳定文本保存 Acb/Arb 球。"""

    return value.str(digits)


def main() -> int:
    """运行三类 exact 奇点、类型 round-trip 和报告门禁。"""

    fresh_output()
    os.environ["FLINTNDE_SUPPRESS_CITATION_NOTICE"] = "1"
    sys.path.insert(0, str(VERSION_ROOT))

    from flint import acb, acb_mat
    from flintnde import (
        RationalMatrixSystem,
        configure_working_precision,
        evaluate_singular_target,
        rational_function,
    )
    from flintnde import mathematica_bridge

    configure_working_precision(90, 50)
    local_order = 64
    target_relative_error = "1e-25"
    sample_exponents = (8, 12, 16, 20, 24)
    zero = rational_function(0)
    inverse_x = rational_function(1, [0, 1])

    started = time.perf_counter()
    removable_system = RationalMatrixSystem(
        ((inverse_x,),), variable_name="x", name="independent-removable-y-equals-x"
    )
    removable = evaluate_singular_target(
        removable_system,
        1,
        acb_mat([[1]]),
        0,
        order=local_order,
        target_relative_error=target_relative_error,
        sample_exponents=sample_exponents,
    )

    pole_system = RationalMatrixSystem(
        ((-inverse_x,),), variable_name="x", name="independent-pole-y-equals-one-over-x"
    )
    pole = evaluate_singular_target(
        pole_system,
        1,
        acb_mat([[1]]),
        0,
        order=local_order,
        target_relative_error=target_relative_error,
        sample_exponents=sample_exponents,
    )

    log_system = RationalMatrixSystem(
        ((zero, inverse_x), (zero, zero)),
        variable_name="x",
        name="independent-log-vector",
    )
    logarithmic = evaluate_singular_target(
        log_system,
        1,
        acb_mat([[0], [1]]),
        0,
        order=local_order,
        target_relative_error=target_relative_error,
        sample_exponents=sample_exponents,
    )
    elapsed = time.perf_counter() - started

    removable_error = abs(removable.values[0])
    log_finite_error = abs(logarithmic.values[1] - acb(1))
    serialized = {
        "removable": mathematica_bridge._singular_value_records(removable.values, 50),
        "pole": mathematica_bridge._singular_value_records(pole.values, 50),
        "logarithmic": mathematica_bridge._singular_value_records(logarithmic.values, 50),
    }
    restored = json.loads(json.dumps(serialized, ensure_ascii=False))

    checks = {
        "removableOverallClassification": removable.classification == "removable_singularity",
        "removableComponentClassification": removable.component_classifications == (
            "removable_singularity",
        ),
        "removableReturnsAcb": isinstance(removable.values[0], acb),
        "removableClosedLimit": float(removable_error.mid()) < 1.0e-20,
        "poleOverallClassification": pole.classification == "true_pole",
        "poleComponentClassification": pole.component_classifications == ("true_pole",),
        "poleReturnsInfinityText": pole.values == ("Infinity",),
        "logOverallClassification": logarithmic.classification
        == "log_divergent_singularity",
        "logComponentClassifications": logarithmic.component_classifications
        == ("log_divergent_singularity", "removable_singularity"),
        "logTypesAndFiniteLimit": logarithmic.values[0] == "Infinity"
        and isinstance(logarithmic.values[1], acb)
        and float(log_finite_error.mid()) < 1.0e-20,
        "sampleEvidenceComplete": all(
            len(result.report["sampleExponents"]) == len(sample_exponents)
            and len(result.report["sampleMagnitudes"]) == len(result.values)
            for result in (removable, pole, logarithmic)
        ),
        "localOrderRecorded": all(
            result.report["localBasisOrder"] == local_order
            for result in (removable, pole, logarithmic)
        ),
        "roundTripPreservesText": restored["pole"] == [{"text": "Infinity"}]
        and restored["logarithmic"][0] == {"text": "Infinity"},
        "roundTripPreservesNumericRecord": "text" not in restored["removable"][0]
        and set(restored["removable"][0]) == {
            "real",
            "imag",
            "realRadius",
            "imagRadius",
        }
        and "text" not in restored["logarithmic"][1],
    }
    passed_count = sum(value is True for value in checks.values())
    status = "passed" if passed_count == len(checks) else "failed"
    summary = {
        "schema": "flintnde_0.5.0_validation_01_v1",
        "status": status,
        "passedCount": passed_count,
        "checkCount": len(checks),
        "sourceDigestSHA256": source_digest(),
        "settings": {
            "workingPrecisionDigits": 90,
            "outputDigits": 50,
            "localOrder": local_order,
            "targetRelativeError": target_relative_error,
            "sampleExponents": list(sample_exponents),
        },
        "exactModels": {
            "removable": "y'=y/x, y(1)=1, hence y=x and y(0)=0",
            "pole": "y'=-y/x, y(1)=1, hence y=1/x",
            "logarithmic": "y1'=y2/x, y2'=0, y(1)=(0,1), hence y=(log(x),1)",
        },
        "results": {
            "removable": {
                "classification": removable.classification,
                "componentClassifications": list(removable.component_classifications),
                "value": ball_text(removable.values[0]),
                "closedFormAbsoluteError": ball_text(removable_error),
                "report": removable.report,
            },
            "pole": {
                "classification": pole.classification,
                "componentClassifications": list(pole.component_classifications),
                "values": list(pole.values),
                "report": pole.report,
            },
            "logarithmic": {
                "classification": logarithmic.classification,
                "componentClassifications": list(logarithmic.component_classifications),
                "values": [
                    logarithmic.values[0],
                    ball_text(logarithmic.values[1]),
                ],
                "finiteComponentAbsoluteError": ball_text(log_finite_error),
                "report": logarithmic.report,
            },
        },
        "serializedRecords": restored,
        "checks": checks,
        "wallTimeSeconds": elapsed,
    }
    summary_path = RESULTS_ROOT / "summary.json"
    summary_path.write_text(
        json.dumps(summary, ensure_ascii=False, indent=2) + "\n", encoding="utf-8", newline="\n"
    )

    failed = [name for name, value in checks.items() if value is not True]
    report = "\n".join(
        [
            "# FlintNDE 0.5.0 Validation-01 独立报告",
            "",
            f"- 状态：**{status}**，{passed_count}/{len(checks)}。",
            f"- 当前 Python 源码聚合 SHA-256：`{summary['sourceDigestSHA256']}`。",
            f"- wall time：`{elapsed:.9f} s`。",
            "- 工作精度/局部阶/目标误差：`90 / 64 / 1e-25`。",
            "",
            "## 独立模型与结果",
            "",
            "- removable：闭式 `y=x`，目标极限为 0；返回 Acb，分类为 `removable_singularity`。",
            "- true pole：闭式 `y=1/x`；返回文本 `Infinity`，分类为 `true_pole`。",
            "- zero-order log：闭式 `(log(x),1)`；第一分量返回文本 `Infinity`，第二分量返回 Acb 1。",
            "- 三个系统均保存五级趋近样本、局部基方法、局部阶和逐分量 magnitude；bridge round-trip",
            "  保持 `{text: Infinity}` 与 Acb 中点/半径记录为不同类型。",
            "",
            "## 误差与产物",
            "",
            f"- removable 对闭式极限的绝对误差球：`{ball_text(removable_error)}`。",
            f"- log 有限分量对 1 的绝对误差球：`{ball_text(log_finite_error)}`。",
            "- 机器 summary：`results/summary.json`。",
            f"- 失败项：`{failed if failed else '无'}`。",
            "- 本 case 不认证上游物理 DE、master 顺序或 normalization。",
            "",
        ]
    )
    REPORT_PATH.write_text(report, encoding="utf-8", newline="\n")
    print(f"FlintNDE Validation-01: {passed_count}/{len(checks)} checks passed")
    return 0 if status == "passed" else 1


if __name__ == "__main__":
    raise SystemExit(main())
