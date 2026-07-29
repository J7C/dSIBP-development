#!/usr/bin/env python3
"""在 NDE connection 层比较 FlintNDE 与现有 NLQNM 2x2 求解器。

检查读取现有 NLQNM 的 OOO-232 connection summary，并用 FlintNDE 对两个 parent
频率重新输运同一统一 ``u`` 方程。比较量只有单位 horizon seed 在 infinity 行波基中的
``Cout``、``Cin`` 与禁戒分量比例，不进入 Npackage Step4 或任何最终物理量装配。
"""

from __future__ import annotations

import hashlib
import importlib.util
import json
from pathlib import Path
from types import ModuleType
from typing import Any

from flint import acb, arb


CHECK_DIR = Path(__file__).resolve().parent
FLINTNDE_ROOT = CHECK_DIR.parent
PROJECT_ROOT = FLINTNDE_ROOT.parent
QNM_EXAMPLE_PATH = FLINTNDE_ROOT / "code" / "example" / "qnm_2x2.py"
CONFIG_PATH = FLINTNDE_ROOT / "config" / "qnm_u_unified_it0_3_it1_minus1.json"
NLQNM_SUMMARY_PATH = (
    PROJECT_ROOT
    / "000_code_AmpBH"
    / "de_qnm"
    / "04_qnm_connection"
    / "results"
    / "qnm_ooo_232_n0_odd_distinct_parents"
    / "04_qnm_connection_summary.json"
)
RESULT_PATH = CHECK_DIR / "results" / "check_01_nde_nlqnm_2x2_summary.json"
COUT_TOLERANCE = arb("1e-12")
FORBIDDEN_TOLERANCE = arb("1e-10")


def load_json(path: Path) -> dict[str, Any]:
    """读取必需 JSON 对象，缺失或根类型错误时立即阻断。"""

    payload = json.loads(path.read_text(encoding="utf-8-sig"))
    if not isinstance(payload, dict):
        raise TypeError(f"JSON root must be an object: {path}")
    return payload


def load_module(path: Path, name: str) -> ModuleType:
    """按绝对路径加载 QNM 示例，确保检查调用当前工作树实现。"""

    specification = importlib.util.spec_from_file_location(name, path)
    if specification is None or specification.loader is None:
        raise ImportError(f"cannot load module from {path}")
    module = importlib.util.module_from_spec(specification)
    specification.loader.exec_module(module)
    return module


def sha256_file(path: Path) -> str:
    """返回输入文件的 SHA-256，固定正式检查的数据来源。"""

    digest = hashlib.sha256()
    with path.open("rb") as stream:
        for block in iter(lambda: stream.read(1024 * 1024), b""):
            digest.update(block)
    return digest.hexdigest()


def acb_record(record: dict[str, Any]) -> acb:
    """把 ``{re,im}`` 文本记录恢复为 Acb 数。"""

    return acb(str(record["re"]), str(record["im"]))


def exact_record(record: dict[str, Any]) -> dict[str, str]:
    """把十进制 ``{re,im}`` 作为 exact Q(i) 输入，不经过浮点对象。"""

    return {"real": str(record["re"]), "imag": str(record["im"])}


def value_record(value: acb, digits: int = 35) -> dict[str, str]:
    """保存 Acb 中点和 ball，避免结果退回 binary64。"""

    return {
        "re": value.real.str(digits, radius=False),
        "im": value.imag.str(digits, radius=False),
        "re_ball": value.real.str(digits),
        "im_ball": value.imag.str(digits),
    }


def relative_difference(left: acb, right: acb) -> arb:
    """按参考值尺度计算相对差；本检查的 ``Cout`` 严格非零。"""

    scale = abs(right)
    if scale.contains(0):
        raise ZeroDivisionError("reference Cout contains zero")
    return abs(left - right) / scale


def main() -> None:
    """重算两个 parent 的 FlintNDE connection 并写出正式 NDE 层比较。"""

    source = load_json(NLQNM_SUMMARY_PATH)
    if source.get("status") != "passed":
        raise ValueError("NLQNM source connection summary is not passed")
    qnm_example = load_module(QNM_EXAMPLE_PATH, "flintnde_qnm_2x2_check_source")
    convention = qnm_example.load_convention_config(CONFIG_PATH)
    for field in ("ConventionName", "it0", "it1", "EnergyCondition"):
        if convention[field] != source[field]:
            raise ValueError(f"FlintNDE config and NLQNM source disagree on {field}")

    comparisons = []
    for parent in source["parents"]:
        iw = exact_record(parent["iw"])
        ell = int(parent["ell"])
        fresh = qnm_example.run_frequency(
            parent["label"], iw, ell=ell, config_path=CONFIG_PATH
        )
        fresh_out = acb_record(
            fresh["horizon_start_to_infinity_basis"]["allowed_outgoing_coefficient"]
        )
        fresh_in = acb_record(
            fresh["horizon_start_to_infinity_basis"]["forbidden_incoming_coefficient"]
        )
        fresh_ratio = acb_record(
            fresh["horizon_start_to_infinity_basis"]["forbidden_over_allowed"]
        ).real
        nlqnm_out = acb_record(parent["C_out_RW_horizon_normalized"])
        nlqnm_in = acb_record(parent["C_in_RW_horizon_normalized"])
        cout_error = relative_difference(fresh_out, nlqnm_out)
        cin_difference_over_cout = abs(fresh_in - nlqnm_in) / abs(nlqnm_out)
        nlqnm_ratio = arb(parent["absolute_Cin_over_Cout"])
        infinity_start_ratio = acb_record(
            fresh["infinity_start_to_horizon_basis"]["forbidden_over_allowed"]
        ).real
        outgoing_local_error = arb(
            fresh["infinity_asymptotic_diagnostics"]
            ["independent_scalar_recurrence_relative_difference_at_first_match"]
            ["outgoing"]
        )
        incoming_local_error = arb(
            fresh["infinity_asymptotic_diagnostics"]
            ["independent_scalar_recurrence_relative_difference_at_first_match"]
            ["incoming"]
        )
        passed = (
            cout_error < COUT_TOLERANCE
            and fresh_ratio < FORBIDDEN_TOLERANCE
            and nlqnm_ratio < FORBIDDEN_TOLERANCE
            and cin_difference_over_cout < FORBIDDEN_TOLERANCE
            and infinity_start_ratio < FORBIDDEN_TOLERANCE
            and outgoing_local_error < FORBIDDEN_TOLERANCE
            and incoming_local_error < FORBIDDEN_TOLERANCE
        )
        comparisons.append(
            {
                "label": parent["label"],
                "ell": ell,
                "iw": parent["iw"],
                "status": "passed" if passed else "failed",
                "flintnde_Cout": value_record(fresh_out),
                "nlqnm_Cout": value_record(nlqnm_out),
                "Cout_relative_difference": cout_error.str(20),
                "flintnde_Cin": value_record(fresh_in),
                "nlqnm_Cin": value_record(nlqnm_in),
                "Cin_difference_over_Cout": cin_difference_over_cout.str(20),
                "flintnde_forbidden_over_allowed": fresh_ratio.str(20),
                "nlqnm_forbidden_over_allowed": nlqnm_ratio.str(20),
                "literal_inf_start_forbidden_horizon_over_allowed": infinity_start_ratio.str(20),
                "infinity_method": fresh["literal_singular_starts"]["infinity_method"],
                "infinity_first_ordinary_match_x": fresh["literal_singular_starts"]
                ["infinity_first_ordinary_match_x"],
                "infinity_asymptotic_diagnostics": fresh["infinity_asymptotic_diagnostics"],
                "transport_refinement_maximum": fresh["transport_refinement_maximum"],
                "flintnde_elapsed_seconds": fresh["elapsed_seconds"],
            }
        )

    status = "passed" if all(item["status"] == "passed" for item in comparisons) else "failed"
    summary = {
        "schema": "flintnde_check_nde_nlqnm_2x2_v2",
        "status": status,
        "scope": "NDE connection coefficients only; no Step4 or Rhat comparison",
        "ConfigPath": convention["ConfigPath"],
        "ConventionName": convention["ConventionName"],
        "it0": convention["it0"],
        "it1": convention["it1"],
        "EnergyCondition": convention["EnergyCondition"],
        "check_id": source["check_id"],
        "basis_normalization": source["basis_normalization"],
        "acceptance": {
            "Cout_relative_difference": "1e-12",
            "forbidden_over_allowed": "1e-10",
            "Cin_difference_over_Cout": "1e-10",
            "literal_inf_start_forbidden_over_allowed": "1e-10",
            "independent_infinity_recurrence_relative_difference": "1e-10",
        },
        "comparisons": comparisons,
        "sources": {
            "flintnde_qnm_example": str(QNM_EXAMPLE_PATH.relative_to(PROJECT_ROOT)).replace("\\", "/"),
            "flintnde_qnm_example_sha256": sha256_file(QNM_EXAMPLE_PATH),
            "flintnde_config": str(CONFIG_PATH.relative_to(PROJECT_ROOT)).replace("\\", "/"),
            "flintnde_config_sha256": sha256_file(CONFIG_PATH),
            "nlqnm_summary": str(NLQNM_SUMMARY_PATH.relative_to(PROJECT_ROOT)).replace("\\", "/"),
            "nlqnm_summary_sha256": sha256_file(NLQNM_SUMMARY_PATH),
            "nlqnm_source_ConfigPath": source["ConfigPath"],
        },
    }
    RESULT_PATH.parent.mkdir(parents=True, exist_ok=True)
    RESULT_PATH.write_text(
        json.dumps(summary, ensure_ascii=False, indent=2) + "\n", encoding="utf-8"
    )
    print(json.dumps({"status": status, "result": str(RESULT_PATH)}, indent=2))
    if status != "passed":
        raise SystemExit(1)


if __name__ == "__main__":
    main()
