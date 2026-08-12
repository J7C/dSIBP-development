"""验证 MadStree adapter 的六个严格 plan/execute schema。

本文件覆盖普通折线、领头阶和正则奇点边界三条两阶段路线。每条执行路线都在规划后
替换对应规划器为调用即失败的哨兵，确认执行阶段只恢复已保存计划。字段集合、模式值和
大小写均严格按当前 schema 验证。
"""

from __future__ import annotations

import copy
import importlib.util
from decimal import Decimal
from pathlib import Path
from types import ModuleType

import pytest


VERSION_ROOT = Path(__file__).resolve().parents[1]
ADAPTER_FILE = VERSION_ROOT / "Backend" / "flintnde_transport.py"
VENDOR_ROOT = VERSION_ROOT / "Vendor" / "FlintNDE"


def _load_adapter() -> ModuleType:
    """从当前版本路径加载 adapter，避免依赖安装态 MadStree。"""

    spec = importlib.util.spec_from_file_location(
        "madstree_flintnde_transport_test_adapter",
        ADAPTER_FILE,
    )
    if spec is None or spec.loader is None:
        raise RuntimeError("cannot load the MadStree FlintNDE adapter")
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


ADAPTER = _load_adapter()


def _q(value: str, imaginary: str = "0") -> dict[str, str]:
    """构造唯一的 exact Q(i) JSON 标量记录。"""

    return {"real": value, "imag": imaginary}


def _letter(alpha: str, beta: str, residue: str) -> dict[str, object]:
    """构造一维 dlog letter 的 exact Q(i) JSON 记录。"""

    return {
        "alpha": _q(alpha),
        "beta": _q(beta),
        "residue": [[_q(residue)]],
    }


def _segment(
    letter: dict[str, object],
    *,
    plan: dict[str, object] | None = None,
) -> dict[str, object]:
    """构造含明确用户点索引的一段仿射拉回。"""

    record: dict[str, object] = {
        "start": "0",
        "target": "1",
        "letters": [letter],
        "fromUserIndex": 0,
        "toUserIndex": 1,
    }
    if plan is not None:
        record["plan"] = plan
    return record


def _plan_request(
    *,
    letter: dict[str, object],
    singularity_mode: str = "avoid",
    message_language: str = "EN",
    digits: int = 70,
) -> dict[str, object]:
    """构造唯一当前 polyline plan 请求。"""

    return {
        "schema": ADAPTER.POLYLINE_PLAN_SCHEMA,
        "backendPackagePath": str(VENDOR_ROOT),
        "masterDigest": "adapter-two-phase-test",
        "dimension": 1,
        "segments": [_segment(letter)],
        "singularityMode": singularity_mode,
        "workingPrecisionDigits": digits,
        "messageLanguage": message_language,
    }


def _execute_request(
    planned: dict[str, object],
    *,
    letter: dict[str, object],
    digits: int = 70,
) -> dict[str, object]:
    """把当前 plan 输出转为唯一当前 polyline execute 请求。"""

    planned_segment = planned["segments"][0]
    return {
        "schema": ADAPTER.POLYLINE_EXECUTE_SCHEMA,
        "backendPackagePath": str(VENDOR_ROOT),
        "masterDigest": "adapter-two-phase-test",
        "dimension": 1,
        "segments": [
            _segment(letter, plan=planned_segment["serializedPlan"])
        ],
        "singularityMode": planned["singularityMode"],
        "boundary": [_q("1")],
        "workingPrecisionDigits": digits,
        "primaryOrder": 48,
        "referenceOrder": 64,
        "targetRelativeError": "1e-25",
        "certificationMode": "embedded",
        "messageLanguage": "EN",
        "columnVectorConvention": "Y'=A(s)Y",
        "dlogStatus": "certifiedByFormulaChecks",
    }


def _leading_order_plan_request(
    letter: dict[str, object],
    *,
    digits: int = 100,
) -> dict[str, object]:
    """构造唯一当前 LO plan 请求。"""

    return {
        "schema": ADAPTER.LEADING_ORDER_PLAN_SCHEMA,
        "backendPackagePath": str(VENDOR_ROOT),
        "masterDigest": "adapter-leading-order-test",
        "dimension": 1,
        "letters": [letter],
        "start": "0",
        "pole": "1",
        "workingPrecisionDigits": digits,
        "messageLanguage": "EN",
    }


def _leading_order_execute_request(
    letter: dict[str, object],
    plan: dict[str, object],
    *,
    digits: int = 100,
) -> dict[str, object]:
    """构造唯一当前 LO execute 请求。"""

    return {
        "schema": ADAPTER.LEADING_ORDER_EXECUTE_SCHEMA,
        "backendPackagePath": str(VENDOR_ROOT),
        "masterDigest": "adapter-leading-order-test",
        "dimension": 1,
        "letters": [letter],
        "plan": plan,
        "boundary": [_q("1")],
        "start": "0",
        "pole": "1",
        "workingPrecisionDigits": digits,
        "primaryOrder": 48,
        "referenceOrder": 64,
        "targetRelativeError": "1e-25",
        "certificationMode": "embedded",
        "messageLanguage": "EN",
        "columnVectorConvention": "Y'=A(s)Y",
        "dlogStatus": "certifiedByFormulaChecks",
    }


def _rational_function(
    numerator: list[str],
    denominator: list[str],
) -> dict[str, object]:
    """构造 Q(i)(t) 有理函数的系数列表记录。"""

    return {
        "numerator": [_q(value) for value in numerator],
        "denominator": [_q(value) for value in denominator],
    }


def _singular_boundary_plan_request(
    *,
    digits: int = 70,
) -> dict[str, object]:
    """构造 A(t)=1/(2t) 的奇点边界规划请求，不提供奇点位置。"""

    return {
        "schema": ADAPTER.SINGULAR_BOUNDARY_PLAN_SCHEMA,
        "backendPackagePath": str(VENDOR_ROOT),
        "masterDigest": "adapter-singular-boundary-test",
        "dimension": 1,
        "variable": "t",
        "matrix": [[_rational_function(["1/2"], ["0", "1"])]],
        "start": "0",
        "target": "1",
        "workingPrecisionDigits": digits,
        "messageLanguage": "EN",
    }


def _singular_boundary_execute_request(
    plan: dict[str, object],
    *,
    digits: int = 70,
) -> dict[str, object]:
    """构造 A(t)=1/(2t) 的奇点边界执行请求。"""

    return {
        "schema": ADAPTER.SINGULAR_BOUNDARY_EXECUTE_SCHEMA,
        "backendPackagePath": str(VENDOR_ROOT),
        "masterDigest": "adapter-singular-boundary-test",
        "dimension": 1,
        "variable": "t",
        "matrix": [[_rational_function(["1/2"], ["0", "1"])]],
        "branches": [
            {
                "boundary": {
                    "a": _q("1/2"),
                    "b": 0,
                    "C": [_q("1")],
                }
            }
        ],
        "plan": plan,
        "start": "0",
        "target": "1",
        "workingPrecisionDigits": digits,
        "primaryOrder": 32,
        "referenceOrder": 48,
        "targetRelativeError": "1e-25",
        "certificationMode": "embedded",
        "messageLanguage": "EN",
        "columnVectorConvention": "Y'=A(t)Y",
        "dlogStatus": "certifiedByFormulaChecks",
    }


def test_polyline_execute_uses_stored_plan_without_replanning(
    monkeypatch: pytest.MonkeyPatch,
) -> None:
    """缺省避奇点计划可执行，且执行期规划器哨兵不得被触发。"""

    letter = _letter("2", "-1", "1")
    planned = ADAPTER._run(_plan_request(letter=letter))

    assert planned["status"] == "success"
    assert planned["singularityMode"] == "avoid"
    assert planned["planningAction"] == "plan_raw_segments_without_execution"
    assert planned["segments"][0]["serializedPlan"]["schema"] == (
        "flintnde_planned_path_serialized_v1"
    )
    assert planned["segments"][0]["serializedPlan"][
        "planning_precision_digits"
    ] == 70

    import flintnde

    def fail_if_replanned(*_args: object, **_kwargs: object) -> None:
        raise AssertionError("execute-only adapter called plan_transport_path")

    monkeypatch.setattr(flintnde, "plan_transport_path", fail_if_replanned)
    executed = ADAPTER._run(_execute_request(planned, letter=letter))

    assert executed["status"] == "success"
    assert executed["executionAction"] == (
        "execute_existing_plans_without_replanning"
    )
    assert Decimal(executed["finalValues"][0]["real"]) == pytest.approx(
        Decimal("0.5"),
        abs=Decimal("1e-25"),
    )


def test_constant_letters_form_an_executable_zero_connection() -> None:
    """所有 dlog letters 沿线段为常量时，应按零连接规划并保持边界值。"""

    letter = _letter("2", "0", "7")
    planned = ADAPTER._run(_plan_request(letter=letter))

    assert planned["status"] == "success"
    assert planned["segments"][0]["jumpSpecs"] == []
    assert planned["segments"][0]["planReport"][
        "minimum_pole_path_distance"
    ] is None

    executed = ADAPTER._run(_execute_request(planned, letter=letter))
    assert executed["status"] == "success"
    assert Decimal(executed["finalValues"][0]["real"]) == pytest.approx(
        Decimal("1"),
        abs=Decimal("1e-30"),
    )
    assert abs(Decimal(executed["finalValues"][0]["imag"])) < Decimal("1e-30")


def test_polyline_higher_execution_precision_requires_replanning() -> None:
    """低精度计划不得用于更高精度执行。"""

    letter = _letter("2", "-1", "1")
    planned = ADAPTER._run(_plan_request(letter=letter, digits=70))

    with pytest.raises(
        ValueError,
        match="replan at the requested working precision",
    ):
        ADAPTER._run(_execute_request(planned, letter=letter, digits=100))


def test_explicit_singularity_jump_plan_reports_cn_branch_responsibility() -> None:
    """显式奇点折跃计划必须含 jump 几何和中文多值分支责任提示。"""

    planned = ADAPTER._run(
        _plan_request(
            letter=_letter("-1", "2", "1/2"),
            singularity_mode="singularity_jump",
            message_language="CN",
        )
    )

    assert planned["status"] == "success"
    assert planned["singularityMode"] == "singularity_jump"
    assert planned["segments"][0]["jumpSpecs"]
    assert "多值分支" in planned["message"]


def test_avoid_mode_refuses_a_singularity_crossing() -> None:
    """缺省避开奇点模式必须结构化拒绝正穿奇点的线段。"""

    refused = ADAPTER._run(
        _plan_request(letter=_letter("-1", "2", "1/2"))
    )

    assert refused["status"] == "singularPathRefused"
    assert refused["singularityMode"] == "avoid"
    assert refused["singularPathPairs"]


def test_explicit_nonresonant_singularity_jump_executes_serialized_arb_plan(
    monkeypatch: pytest.MonkeyPatch,
) -> None:
    """非共振奇点折跃须从 Arb 球计划恢复，执行阶段不得重新规划。"""

    letter = _letter("-1", "2", "1/2")
    planned = ADAPTER._run(
        _plan_request(
            letter=letter,
            singularity_mode="singularity_jump",
            digits=100,
        )
    )

    assert planned["status"] == "success"
    serialized = planned["segments"][0]["serializedPlan"]
    jump = serialized["singularity_jump_segments"][0]
    assert serialized["planning_precision_digits"] == 100
    assert set(jump["pole"]["real_ball"]) == {
        "midpoint",
        "radius",
        "exponent",
    }

    import flintnde

    def fail_if_replanned(*_args: object, **_kwargs: object) -> None:
        raise AssertionError("jump execute-only adapter called plan_transport_path")

    monkeypatch.setattr(flintnde, "plan_transport_path", fail_if_replanned)
    executed = ADAPTER._run(
        _execute_request(planned, letter=letter, digits=100)
    )

    assert executed["status"] == "success"
    assert executed["segments"][0]["jumpSpecs"]
    assert executed["certificationMode"] == "certified"
    assert Decimal(executed["finalValues"][0]["real"]).is_finite()
    assert Decimal(executed["finalValues"][0]["imag"]).is_finite()


def test_leading_order_execute_uses_stored_plan_and_arb_winding(
    monkeypatch: pytest.MonkeyPatch,
) -> None:
    """LO 执行只恢复计划，并返回由 Arb 辐角认证的整数 winding。"""

    letter = _letter("-1", "1", "1/2")
    planned = ADAPTER._run(_leading_order_plan_request(letter))
    assert planned["status"] == "success"
    assert planned["serializedPlan"]["planning_precision_digits"] == 100

    import flintnde

    def fail_if_replanned(*_args: object, **_kwargs: object) -> None:
        raise AssertionError("LO execute-only adapter called plan_transport_path")

    monkeypatch.setattr(flintnde, "plan_transport_path", fail_if_replanned)
    executed = ADAPTER._run(
        _leading_order_execute_request(
            letter,
            planned["serializedPlan"],
        )
    )

    assert executed["status"] == "success"
    assert executed["executionAction"] == (
        "execute_existing_leading_order_plan_without_replanning"
    )
    assert executed["incomingWinding"] == 0
    assert executed["certificationMode"] == "certified"


def test_singular_boundary_execute_uses_stored_general_rational_plan(
    monkeypatch: pytest.MonkeyPatch,
) -> None:
    """奇点由一般有理矩阵内部发现，执行只恢复 AdaptivePath。"""

    planned = ADAPTER._run(_singular_boundary_plan_request())
    assert planned["status"] == "success"
    assert planned["startClassification"]["classification"] == "regular_singular"
    assert planned["targetClassification"]["classification"] == "ordinary"
    assert planned["serializedPlan"]["schema"] == (
        "flintnde_adaptive_path_serialized_v1"
    )

    import flintnde

    def fail_if_replanned(*_args: object, **_kwargs: object) -> None:
        raise AssertionError("singular-boundary execute called build_adaptive_path")

    monkeypatch.setattr(flintnde, "build_adaptive_path", fail_if_replanned)
    executed = ADAPTER._run(
        _singular_boundary_execute_request(planned["serializedPlan"])
    )

    assert executed["status"] == "success"
    assert executed["executionAction"] == (
        "execute_existing_singular_boundary_plan_without_replanning"
    )
    assert executed["certificationMode"] == "certified"
    assert Decimal(
        executed["branchResults"][0]["finalValues"][0]["real"]
    ) == pytest.approx(Decimal("1"), abs=Decimal("1e-18"))



def test_missing_and_extra_top_level_fields_are_rejected() -> None:
    """当前 schema 同时拒绝缺字段和任意多余字段。"""

    request = _plan_request(letter=_letter("2", "-1", "1"))
    missing = copy.deepcopy(request)
    del missing["singularityMode"]
    with pytest.raises(ValueError, match="missing=.*singularityMode"):
        ADAPTER._run(missing)

    extra = copy.deepcopy(request)
    extra["unexpectedField"] = False
    with pytest.raises(ValueError, match="unexpected=.*unexpectedField"):
        ADAPTER._run(extra)


def test_nested_extra_fields_and_language_case_folding_are_rejected() -> None:
    """嵌套记录不可带多余字段，语言值不可自动改大小写。"""

    nested = _plan_request(letter=_letter("2", "-1", "1"))
    nested["segments"][0]["unexpectedField"] = True
    with pytest.raises(ValueError, match="unexpected=.*unexpectedField"):
        ADAPTER._run(nested)

    language = _plan_request(
        letter=_letter("2", "-1", "1"),
        message_language="en",
    )
    with pytest.raises(ValueError, match="exactly"):
        ADAPTER._run(language)