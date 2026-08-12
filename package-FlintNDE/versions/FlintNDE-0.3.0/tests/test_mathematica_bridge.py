"""Mathematica bridge 的两阶段、通用系统与自动特化合同测试。"""

from __future__ import annotations

from decimal import Decimal, localcontext

import pytest

from flintnde import mathematica_bridge as bridge


def _rational_system(
    numerator: list[str], denominator: list[str]
) -> dict[str, object]:
    """构造一维 exact Q(x) bridge 系统记录。"""

    return {
        "type": "rationalMatrix",
        "variable": "x",
        "name": "mathematica-bridge-test",
        "matrix": [[{"numerator": numerator, "denominator": denominator}]],
    }


def _plan_request(
    system: dict[str, object],
    points: list[str],
    *,
    singularity_mode: str = "avoid",
    message_language: str = "EN",
) -> dict[str, object]:
    """构造只规划、不执行的 bridge 请求。"""

    return {
        "schema": bridge.REQUEST_SCHEMA,
        "action": "plan",
        "system": system,
        "start": "0",
        "points": points,
        "workingPrecisionDigits": 70,
        "outputDigits": 35,
        "singularityMode": singularity_mode,
        "messageLanguage": message_language,
        "radiusFraction": 0.60,
        "maxStepOverRadius": 0.45,
        "singularityJumpThreshold": 0.5,
        "matchFraction": 0.6,
        "maxSingularityJumps": 16,
    }


def _execute_request(
    system: dict[str, object],
    plan: dict[str, object],
    *,
    digits: int = 70,
) -> dict[str, object]:
    """构造只消费已有计划的 bridge 请求。"""

    return {
        "schema": bridge.REQUEST_SCHEMA,
        "action": "execute",
        "system": system,
        "initialVector": ["1"],
        "plannedResult": plan,
        "workingPrecisionDigits": digits,
        "outputDigits": 35,
        "primaryOrder": 70,
        "referenceOrder": 90,
        "targetRelativeError": "1e-25",
        "certificationMode": "embedded",
        "radiusFraction": 0.60,
        "messageLanguage": "EN",
    }


def test_polynomial_simple_poles_are_discovered_and_executed_without_replanning(
    monkeypatch: pytest.MonkeyPatch,
) -> None:
    """一般有理输入应内部认证为二次多项式加简单极点，执行不得再调规划器。"""

    system = _rational_system(["1", "0", "-2", "1"], ["-2", "1"])
    planned = bridge.run_request(_plan_request(system, ["1"]))

    assert planned["status"] == "complete"
    assert planned["solverKind"] == "certifiedPolynomialSimplePoles"
    assert planned["pathKind"] == "plannedPath"
    assert planned["specialization"]["eligible"] is True
    assert planned["specialization"]["polynomial_degree"] == 2
    assert planned["plan"]["planningPrecisionDigits"] == 70
    assert planned["plan"]["path"]["planning_precision_digits"] == 70

    def fail_if_replanned(*_args: object, **_kwargs: object) -> None:
        raise AssertionError("execute action called the path planner")

    monkeypatch.setattr(bridge, "plan_transport_path", fail_if_replanned)
    executed = bridge.run_request(_execute_request(system, planned))

    assert executed["status"] == "complete"
    assert executed["executionAction"] == "execute_existing_plan_without_replanning"
    assert executed["certificationModeRequested"] == "embedded"
    assert executed["certificationMode"] == "certified"
    with localcontext() as context:
        context.prec = 50
        value = Decimal(executed["referenceFinalVector"][0]["real"])
        expected = (Decimal(1) / Decimal(3)).exp() / Decimal(2)
        assert abs(value - expected) < Decimal("1e-30")
    assert abs(Decimal(executed["referenceFinalVector"][0]["imag"])) < Decimal("1e-30")


def test_polynomial_only_rational_input_uses_formula_route() -> None:
    """无有限极点的任意次多项式也应由内部认证并完成两阶段输运。"""

    system = _rational_system(["1", "2"], ["1"])
    planned = bridge.run_request(_plan_request(system, ["1/2"]))

    assert planned["status"] == "complete"
    assert planned["solverKind"] == "certifiedPolynomialSimplePoles"
    assert planned["specialization"]["eligible"] is True
    assert planned["specialization"]["finite_pole_count"] == 0
    executed = bridge.run_request(_execute_request(system, planned))

    with localcontext() as context:
        context.prec = 50
        value = Decimal(executed["referenceFinalVector"][0]["real"])
        expected = Decimal("0.75").exp()
        assert abs(value - expected) < Decimal("1e-30")


def test_higher_execution_precision_requires_replanning() -> None:
    """已序列化节点不能在执行阶段补回更高精度。"""

    system = _rational_system(["1", "0", "-2", "1"], ["-2", "1"])
    planned = bridge.run_request(_plan_request(system, ["1"]))

    with pytest.raises(ValueError, match="replan at the requested working precision"):
        bridge.run_request(
            _execute_request(system, planned, digits=100)
        )


def test_high_order_pole_uses_general_rational_route() -> None:
    """二阶极点不得误入简单极点特例，通用局部基路线仍应可计划并执行。"""

    system = _rational_system(["1"], ["4", "-4", "1"])
    planned = bridge.run_request(_plan_request(system, ["1"]))

    assert planned["status"] == "complete"
    assert planned["solverKind"] == "generalRationalMatrix"
    assert planned["pathKind"] == "adaptivePath"
    assert planned["specialization"]["eligible"] is False

    executed = bridge.run_request(_execute_request(system, planned))
    assert executed["status"] == "complete"
    assert executed["executionAction"] == "execute_existing_plan_without_replanning"
    with localcontext() as context:
        context.prec = 50
        value = Decimal(executed["referenceFinalVector"][0]["real"])
        expected = Decimal("0.5").exp()
        assert abs(value - expected) < Decimal("1e-25")


def test_default_avoid_refuses_and_explicit_jump_plans() -> None:
    """缺省避奇点必须结构化拒绝；只有显式 singularity_jump 才生成奇点折跃计划。"""

    system = _rational_system(["1"], ["-6", "3"])
    refused = bridge.run_request(_plan_request(system, ["3"]))

    assert refused["status"] == "singularPathRefused"
    assert refused["singularityMode"] == "avoid"
    assert refused["messageLanguage"] == "EN"

    jumped = bridge.run_request(
        _plan_request(
            system,
            ["3"],
            singularity_mode="singularity_jump",
            message_language="CN",
        )
    )
    assert jumped["status"] == "complete"
    assert jumped["singularityMode"] == "singularity_jump"
    assert jumped["messageLanguage"] == "CN"
    assert jumped["plan"]["path"]["singularity_jump_segments"]


@pytest.mark.parametrize(
    ("literal", "expected"),
    [
        ("1.25`60.*^3", "1.25e3"),
        ("-2.5`45.*^-7", "-2.5e-7"),
        ("3/7", "3/7"),
    ],
)
def test_wolfram_precision_markers_are_removed_before_exact_parsing(
    literal: str, expected: str
) -> None:
    """Wolfram 精度标记位于指数前时也必须按 exact 十进制解析。"""

    assert bridge._mma_scalar(literal) == expected


def test_partial_fraction_schema_rejects_unexpected_field() -> None:
    """Partial-fraction 记录必须严格使用当前字段集合。"""

    current = {
        "type": "partialFraction",
        "polynomialCoefficients": [[["1"]], [["2"]]],
        "residues": [[["1/3"]]],
        "poles": ["2"],
    }
    system = bridge._build_system(current)
    assert system.polynomial_degree == 1

    unexpected = dict(current)
    unexpected["unexpectedField"] = True
    with pytest.raises(ValueError, match="current schema"):
        bridge._build_system(unexpected)


def test_execute_rejects_internal_raw_plan() -> None:
    """执行入口只消费完整 plan 结果，内部 execution-plan 不是公开输入。"""

    system = _rational_system(["1", "2"], ["1"])
    planned = bridge.run_request(_plan_request(system, ["1/2"]))
    request = _execute_request(system, planned["plan"])

    with pytest.raises(ValueError, match="plannedResult"):
        bridge.run_request(request)


def test_plan_request_rejects_missing_current_field() -> None:
    """当前 plan schema 的字段缺失时必须失败，不补缺省值。"""

    system = _rational_system(["1"], ["1"])
    request = _plan_request(system, ["1/2"])
    del request["messageLanguage"]

    with pytest.raises(ValueError, match="missing=.*messageLanguage"):
        bridge.run_request(request)
