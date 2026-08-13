"""检查 0.4.0 的自动规划、直接用户节点、奇点折跃与步内覆盖求值。"""

from __future__ import annotations

import math
import unittest

from flint import acb, acb_mat, arb

from flintnde import (
    PartialFractionSystem,
    SingularityJumpBasis,
    SingularityJumpError,
    SingularPathError,
    column_vector,
    configure_working_precision,
    direct_user_point_path,
    plan_transport_path,
    planned_path_from_json,
    planned_path_to_json,
    relative_difference_inf,
    transport_path,
    transport_planned_path,
    transport_planned_path_refined,
)


def _fractional_diagonal_system(pole: acb | None = None) -> PartialFractionSystem:
    """``A(z)=diag((1/2)/(z-p), (-1/3)/(z+3))``，有闭式解且指数差非整数。

    从 ``y(0)=(1,1)`` 出发的闭式解为 ``y1=-i(z-p)^{1/2}``（主支幂，取
    ``p=1``）与 ``y2=3^{1/3}(z+3)^{-1/3}``。
    """

    singular = pole if pole is not None else acb(1)
    return PartialFractionSystem(
        constant=acb_mat([[acb(0), acb(0)], [acb(0), acb(0)]]),
        residues=(
            acb_mat([[acb("1/2"), acb(0)], [acb(0), acb(0)]]),
            acb_mat([[acb(0), acb(0)], [acb(0), acb("-1/3")]]),
        ),
        poles=(singular, acb(-3)),
        name="fractional-diagonal-test",
    )


def _far_pole_system() -> PartialFractionSystem:
    """极点在 ±100 的近自由系统，闭式解为一次与平方反比函数。"""

    return PartialFractionSystem(
        constant=acb_mat([[acb(0), acb(0)], [acb(0), acb(0)]]),
        residues=(
            acb_mat([[acb(1), acb(0)], [acb(0), acb(0)]]),
            acb_mat([[acb(0), acb(0)], [acb(0), acb(-2)]]),
        ),
        poles=(acb(100), acb(-100)),
        name="far-pole-test",
    )


def _far_pole_closed_form(point: acb) -> acb_mat:
    """``y1=(100-z)/100``、``y2=(100/(z+100))^2``，起点 ``(1,1)``。"""

    first = (acb(100) - point) / acb(100)
    second = (acb(100) / (point + acb(100))) ** 2
    vector = acb_mat(2, 1)
    vector[0, 0] = first
    vector[1, 0] = second
    return vector


class DirectUserPointPathTest(unittest.TestCase):
    """关闭规划时只做安全检查，并保持用户节点链不变。"""

    @classmethod
    def setUpClass(cls) -> None:
        configure_working_precision(60, 32)

    def test_user_points_are_the_exact_node_sequence(self) -> None:
        """公共入口不得插点、删点或生成 dense sample。"""

        system = _far_pole_system()
        points = [acb("1/10"), acb("1/5"), acb("3/10")]
        plan = direct_user_point_path(system, acb(0), points, message_language="CN")
        expected = [acb(0), *points]
        self.assertEqual(len(plan.nodes), len(expected))
        self.assertTrue(all(abs(actual - target).contains(0) for actual, target in zip(plan.nodes, expected)))
        self.assertEqual(plan.sample_assignments, [])
        self.assertEqual(plan.report["planning_action"], "disabled_use_user_points_as_nodes")

    def test_crossing_a_pole_fails_closed(self) -> None:
        """直接节点链穿过奇点时必须拒绝，不得静默绕行。"""

        system = _fractional_diagonal_system()
        with self.assertRaises(SingularPathError):
            direct_user_point_path(system, acb(0), [acb(2)])


class LookaheadPlanningTest(unittest.TestCase):
    """前瞻节点选择：一步可达且共线的用户点合并为一步，步内点做代入求值。"""

    @classmethod
    def setUpClass(cls) -> None:
        configure_working_precision(60, 32)

    def test_dense_collinear_points_are_covered_by_one_step(self) -> None:
        system = _far_pole_system()
        user_points = [acb(numerator) / acb(10) for numerator in range(1, 10)]
        plan = plan_transport_path(system, acb(0), user_points)
        # 极点距离 100，全部用户点一步可达：节点只剩起点与末点
        self.assertEqual(len(plan.nodes), 2)
        self.assertEqual(plan.report["singularity_jump_count"], 0)
        self.assertEqual(plan.report["covered_sample_count"], 8)
        result = transport_planned_path(
            system, column_vector([1, 1]), plan, order=48
        )
        endpoint = result[0][-1]
        expected = _far_pole_closed_form(acb("9/10"))
        self.assertLess(
            float(relative_difference_inf(endpoint, expected).mid()), 1.0e-40
        )
        records = {
            record["coordinate"]: record for record in result[3]["sample_results"]
        }
        self.assertEqual(len(records), 8)
        for numerator in range(1, 9):
            point = acb(numerator) / acb(10)
            record = records[point.str(40)]
            self.assertEqual(record["user_point_index"], numerator - 1)
            difference = relative_difference_inf(
                record["value"], _far_pole_closed_form(point)
            )
            self.assertLess(float(difference.mid()), 1.0e-40)

    def test_large_translation_preserves_collinear_lookahead(self) -> None:
        """远超 binary64 间距的平移不能破坏共线点前瞻。"""

        base = acb("1e40")
        system = PartialFractionSystem(
            constant=acb_mat([[acb(0)]]),
            residues=(acb_mat([[acb(1)]]), acb_mat([[acb(-1)]])),
            poles=(base + acb(100), base - acb(100)),
            name="large-translation-lookahead",
        )
        user_points = [base + acb(numerator) / acb(10) for numerator in range(1, 10)]
        plan = plan_transport_path(system, base, user_points)
        self.assertEqual(len(plan.nodes), 2)
        self.assertEqual(plan.report["covered_sample_count"], 8)

    def test_complex_plane_turn_reuses_one_node_patch(self) -> None:
        """同一复参数平面的转角点可由一个无奇点收敛圆盘 dense 求值。"""

        system = _far_pole_system()
        turn = acb("1/2")
        target = acb("1/2") + acb(0, "3/10")
        plan = plan_transport_path(system, acb(0), [turn, target])

        self.assertEqual(len(plan.nodes), 2)
        self.assertEqual(plan.report["covered_sample_count"], 1)
        result = transport_planned_path(
            system, column_vector([1, 1]), plan, order=48
        )
        dense = result[3]["sample_results"]
        self.assertEqual(len(dense), 1)
        self.assertEqual(dense[0]["user_point_index"], 0)
        self.assertLess(
            float(
                relative_difference_inf(
                    dense[0]["value"], _far_pole_closed_form(turn)
                ).mid()
            ),
            1.0e-40,
        )
        expected = _far_pole_closed_form(target)
        self.assertLess(
            float(relative_difference_inf(result[0][-1], expected).mid()), 1.0e-40
        )

    def test_coincident_user_points_are_reported_once_each(self) -> None:
        system = _far_pole_system()
        plan = plan_transport_path(
            system, acb(0), [acb("3/10"), acb("3/10"), acb("3/5")]
        )
        result = transport_planned_path(
            system, column_vector([1, 1]), plan, order=48
        )
        records = result[3]["sample_results"]
        # 两个重复用户点都在步内：各记一条同坐标记录，值一致
        duplicates = [
            record
            for record in records
            if record["coordinate"] == acb("3/10").str(40)
        ]
        self.assertEqual(len(duplicates), 2)
        expected = _far_pole_closed_form(acb("3/10"))
        for record in duplicates:
            self.assertLess(
                float(relative_difference_inf(record["value"], expected).mid()),
                1.0e-40,
            )

    def test_user_point_on_a_pole_is_rejected(self) -> None:
        system = _far_pole_system()
        with self.assertRaises(ValueError):
            plan_transport_path(system, acb(0), [acb("1/2"), acb(100)])


class SingularityJumpPlanningTest(unittest.TestCase):
    """奇点节点化：穿过极点的路径自动放入匹配点并走数值局部基奇点折跃。

    奇点折跃基的特征值/系数来自 ``eig(algorithm="approx")`` 与球算术求逆，
    中点精度受工作精度限制，故取 120 bit（纯递推测试用 60 bit 即可）。
    """

    @classmethod
    def setUpClass(cls) -> None:
        configure_working_precision(120, 64)

    def test_message_language_is_case_sensitive(self) -> None:
        """底层 Python 路径接口只接受现行 EN/CN 值。"""

        with self.assertRaisesRegex(ValueError, "EN.*CN"):
            plan_transport_path(
                _fractional_diagonal_system(),
                acb(0),
                [acb("1/2")],
                message_language="en",
            )

    def test_crossing_pole_plans_a_singularity_jump_and_matches_closed_form(self) -> None:
        system = _fractional_diagonal_system()
        plan = plan_transport_path(
            system, acb(0), [acb(2)], singularity_mode="singularity_jump"
        )
        self.assertEqual(plan.report["singularity_jump_count"], 1)
        result = transport_planned_path(
            system, column_vector([1, 1]), plan, order=64
        )
        jump_reports = [
            report
            for report in result[1]
            if report.get("method") == "singularity_jump_bridge"
        ]
        self.assertEqual(len(jump_reports), 1)
        for side in ("incoming_residual", "outgoing_residual"):
            self.assertLess(
                jump_reports[0][side]["relative_residual_midpoint"], 1.0e-30
            )
        endpoint = result[0][-1]
        expected_first = acb(0, -1)
        expected_second = (acb(3) / acb(5)) ** acb("1/3")
        self.assertLess(float(abs(endpoint[0, 0] - expected_first).mid()), 1.0e-30)
        self.assertLess(float(abs(endpoint[1, 0] - expected_second).mid()), 1.0e-30)

    def test_singularity_jump_nodes_track_requested_decimal_digits(self) -> None:
        """70/100 位请求必须提高奇点折跃匹配节点和计划报告的真实 bit 数。"""

        specs: dict[int, object] = {}
        configured: dict[int, int] = {}
        measured_bits: dict[int, float] = {}
        try:
            for decimal_digits in (70, 100):
                with self.subTest(decimal_digits=decimal_digits):
                    configured_bits = configure_working_precision(decimal_digits, 32)
                    system = _fractional_diagonal_system()
                    plan = plan_transport_path(
                        system,
                        acb("1/7"),
                        [acb("19/7")],
                        singularity_mode="singularity_jump",
                    )
                    specs[decimal_digits] = next(iter(plan.singularity_jump_segments.values()))
                    configured[decimal_digits] = configured_bits
                    self.assertEqual(
                        plan.report["working_precision_bits"], configured_bits
                    )

            configure_working_precision(150, 32)
            offset = arb(3) * arb(2).sqrt() / arb(14)
            expected_incoming = acb(arb(1) - offset, offset)
            for decimal_digits, spec in specs.items():
                error = abs(spec.incoming - expected_incoming)
                accuracy_bits = -math.log2(float(error.mid()))
                measured_bits[decimal_digits] = accuracy_bits
                self.assertGreaterEqual(
                    accuracy_bits,
                    configured[decimal_digits] - 10,
                )
        finally:
            configure_working_precision(120, 64)

        self.assertGreater(measured_bits[100], measured_bits[70])

    def test_singularity_jump_gate_tracks_requested_precision(self) -> None:
        """奇点局部基门禁随工作精度收紧，不固定在 30 位输入上限。"""

        tolerances: dict[int, arb] = {}
        try:
            for decimal_digits in (70, 100):
                with self.subTest(decimal_digits=decimal_digits):
                    configured_bits = configure_working_precision(decimal_digits, 32)
                    basis = SingularityJumpBasis(
                        _fractional_diagonal_system(), pole_index=0, order=8
                    )
                    reliable_digits = math.floor(configured_bits / math.log2(10))
                    expected = arb(10) ** (-arb(max(3, reliable_digits // 2)))
                    self.assertTrue((basis.gate_tolerance - expected).contains(0))
                    tolerances[decimal_digits] = basis.gate_tolerance
        finally:
            configure_working_precision(120, 64)

        self.assertLess(tolerances[100], tolerances[70])

    def test_serialized_plan_round_trip_executes_without_replanning(self) -> None:
        system = _fractional_diagonal_system()
        plan = plan_transport_path(
            system, acb(0), [acb(2)], singularity_mode="singularity_jump"
        )
        serialized = planned_path_to_json(plan, digits=70)
        self.assertEqual(serialized["planning_precision_digits"], 70)
        restored = planned_path_from_json(serialized, system=system)
        result = transport_planned_path_refined(
            system,
            column_vector([1, 1]),
            restored,
            primary_order=48,
            reference_order=56,
            certification_mode="embedded",
        )
        self.assertEqual(
            result["execution_action"], "execute_existing_plan_without_replanning"
        )
        self.assertEqual(restored.report["planning_action"], "raw_points_automatic_plan")
        self.assertLess(
            float(abs(result["reference_snapshots"][-1][0, 0] - acb(0, -1)).mid()),
            1.0e-28,
        )



    def test_singularity_jump_matches_upper_detour_transport(self) -> None:
        """奇点折跃结果与绕极点上半圆弧线输运一致（主支分支约定）。"""

        system = _fractional_diagonal_system()
        plan = plan_transport_path(
            system, acb(0), [acb(2)], singularity_mode="singularity_jump"
        )
        jumped = transport_planned_path(
            system, column_vector([1, 1]), plan, order=64
        )
        detour_points = [acb("11/20")]
        arc_steps = 32
        for index in range(arc_steps + 1):
            angle = math.pi * (1 - index / arc_steps)
            detour_points.append(
                acb(1) + acb("9/40") * acb(math.cos(angle), math.sin(angle))
            )
        detour_points.extend([acb("29/20"), acb(2)])
        # 显式绕行点不经过奇点，缺省 avoid 模式会忠实沿弧线细分。
        detour_plan = plan_transport_path(system, acb(0), detour_points)
        detoured = transport_planned_path(
            system,
            column_vector([1, 1]),
            detour_plan,
            order=48,
        )
        difference = relative_difference_inf(jumped[0][-1], detoured[0][-1])
        # 绕行链每步弦长/极点距离约 0.07，48 阶截断约 1e-55；奇点折跃侧尾项
        # (匹配距离/走廊半径)^64 同样远低于 1e-30
        self.assertLess(float(difference.mid()), 1.0e-28)

    def test_near_miss_pole_triggers_threshold_singularity_jump(self) -> None:
        pole = acb(1, "1/100")
        system = _fractional_diagonal_system(pole)
        plan = plan_transport_path(
            system, acb(0), [acb(2)], singularity_mode="singularity_jump"
        )
        self.assertEqual(plan.report["singularity_jump_count"], 1)
        result = transport_planned_path(
            system, column_vector([1, 1]), plan, order=64
        )
        endpoint = result[0][-1]
        # 直线路径从极点下方经过，全程不跨主支割线：闭式用主支幂
        # (2-p)^{1/2}·(0-p)^{-1/2}（起点归一 y1(0)=1）
        expected_first = (acb(2) - pole) ** acb("1/2") * (acb(0) - pole) ** acb(
            "-1/2"
        )
        expected_second = acb(3) ** acb("1/3") * (acb(2) + acb(3)) ** acb("-1/3")
        self.assertLess(
            float(abs(endpoint[0, 0] - expected_first).mid()), 1.0e-30
        )
        self.assertLess(
            float(abs(endpoint[1, 0] - expected_second).mid()), 1.0e-30
        )

    def test_avoid_mode_does_not_jump_near_misses(self) -> None:
        pole = acb(1, "1/2")
        system = _fractional_diagonal_system(pole)
        plan = plan_transport_path(
            system, acb(0), [acb(2)], singularity_mode="avoid"
        )
        self.assertEqual(plan.report["singularity_jump_count"], 0)
        result = transport_planned_path(
            system, column_vector([1, 1]), plan, order=48
        )
        endpoint = result[0][-1]
        # avoid 模式对未落在线段上的奇点使用普通递推；直线路径不跨主支割线。
        expected_first = (acb(2) - pole) ** acb("1/2") * (acb(0) - pole) ** acb(
            "-1/2"
        )
        expected_second = acb(3) ** acb("1/3") * (acb(2) + acb(3)) ** acb("-1/3")
        self.assertLess(float(abs(endpoint[0, 0] - expected_first).mid()), 1.0e-30)
        self.assertLess(float(abs(endpoint[1, 0] - expected_second).mid()), 1.0e-30)

    def test_singularity_jump_budget_is_enforced(self) -> None:
        system = PartialFractionSystem(
            constant=acb_mat([[acb(0), acb(0)], [acb(0), acb(0)]]),
            residues=(
                acb_mat([[acb("1/2"), acb(0)], [acb(0), acb(0)]]),
                acb_mat([[acb(0), acb(0)], [acb(0), acb("-1/3")]]),
                acb_mat([[acb("1/4"), acb(0)], [acb(0), acb(0)]]),
            ),
            poles=(acb(1), acb(3), acb(-4)),
            name="double-crossing-test",
        )
        with self.assertRaises(SingularityJumpError):
            plan_transport_path(
                system, acb(0), [acb(4)], max_singularity_jumps=1, singularity_mode="singularity_jump"
            )


class PlannedCertificationTest(unittest.TestCase):
    """规划路径的嵌入式与双链认证（含奇点折跃段，用 120 bit 工作精度）。"""

    @classmethod
    def setUpClass(cls) -> None:
        configure_working_precision(120, 64)

    def test_embedded_refined_with_singularity_jump_matches_closed_form(self) -> None:
        system = _fractional_diagonal_system()
        plan = plan_transport_path(
            system,
            acb(0),
            [acb("1/2"), acb(2)],
            singularity_mode="singularity_jump",
        )
        result = transport_planned_path_refined(
            system,
            column_vector([1, 1]),
            plan,
            primary_order=48,
            reference_order=56,
            certification_mode="embedded",
            target_relative_error="1e-25",
        )
        endpoint = result["primary_snapshots"][-1]
        expected_first = acb(0, -1)
        expected_second = acb(3) ** acb("1/3") * acb(5) ** acb("-1/3")
        self.assertLess(float(abs(endpoint[0, 0] - expected_first).mid()), 1.0e-28)
        self.assertLess(float(abs(endpoint[1, 0] - expected_second).mid()), 1.0e-28)
        self.assertTrue(result["target_relative_error_met"])
        self.assertEqual(result["plan"]["singularity_jump_count"], 1)

    def test_certified_refined_agrees_with_embedded(self) -> None:
        system = _fractional_diagonal_system()
        plan = plan_transport_path(
            system,
            acb(0),
            [acb("1/4"), acb("1/2"), acb(2)],
            singularity_mode="singularity_jump",
        )
        embedded = transport_planned_path_refined(
            system,
            column_vector([1, 1]),
            plan,
            primary_order=48,
            reference_order=56,
            certification_mode="embedded",
        )
        certified = transport_planned_path_refined(
            system,
            column_vector([1, 1]),
            plan,
            primary_order=48,
            reference_order=56,
            certification_mode="certified",
        )
        difference = relative_difference_inf(
            embedded["primary_snapshots"][-1], certified["primary_snapshots"][-1]
        )
        # 嵌入式前缀链除末段外用参考阶传播，与独立主阶链的差别以逐段截断差
        # 之和为上界：规划封顶后步长/半径比 ≤ 0.225，48 阶截断约 1e-32
        self.assertLess(float(difference.mid()), 1.0e-28)


class AvoidSingularityModeTest(unittest.TestCase):
    """避开奇点模式：不采取奇点节点，极点落在路径上时拒绝并给出端点对。"""

    @classmethod
    def setUpClass(cls) -> None:
        configure_working_precision(60, 32)

    def test_unsupported_singularity_mode_is_rejected(self) -> None:
        system = _fractional_diagonal_system()
        with self.assertRaisesRegex(ValueError, "must be exactly"):
            plan_transport_path(
                system, acb(0), [acb(2)], singularity_mode="unsupported"
            )

    def test_pole_on_path_is_refused_with_structured_pairs(self) -> None:
        system = _fractional_diagonal_system()
        with self.assertRaises(SingularPathError) as context:
            plan_transport_path(system, acb(0), [acb(2)], singularity_mode="avoid")
        pairs = context.exception.singular_path_pairs
        self.assertEqual(len(pairs), 1)
        self.assertTrue((pairs[0][0] - acb(0)).contains(0))
        self.assertTrue((pairs[0][1] - acb(2)).contains(0))

    def test_multiple_singular_segments_are_all_reported(self) -> None:
        system = PartialFractionSystem(
            constant=acb_mat([[acb(0), acb(0)], [acb(0), acb(0)]]),
            residues=(
                acb_mat([[acb("1/2"), acb(0)], [acb(0), acb(0)]]),
                acb_mat([[acb(0), acb(0)], [acb(0), acb("-1/3")]]),
            ),
            poles=(acb(1), acb(3)),
            name="multi-crossing-test",
        )
        with self.assertRaises(SingularPathError) as context:
            plan_transport_path(system, acb(0), [acb(2), acb(4)], singularity_mode="avoid")
        # 两段连线各穿一个极点：两对端点都要报出
        self.assertEqual(len(context.exception.singular_path_pairs), 2)

    def test_avoiding_path_runs_faithfully_and_reports_distances(self) -> None:
        system = _fractional_diagonal_system()
        plan = plan_transport_path(
            system, acb(0), [acb("1/2"), acb("1/2") + acb(0, "3/2"), acb(2)],
            singularity_mode="avoid",
        )
        self.assertEqual(plan.report["singularity_jump_count"], 0)
        self.assertEqual(plan.report["singularity_mode"], "avoid")
        self.assertIsNotNone(plan.report["minimum_pole_path_distance"])
        self.assertIsNotNone(plan.report["minimum_pole_node_distance"])
        result = transport_planned_path(
            system, column_vector([1, 1]), plan, order=120
        )
        endpoint = result[0][-1]
        # 绕极点走上半平面：与显式奇点折跃模式的主支分支约定一致；
        # 规划封顶后步长/半径比 ≤ 0.225，120 阶截断远低于 1e-25
        expected_first = acb(0, -1)
        expected_second = acb(3) ** acb("1/3") * acb(5) ** acb("-1/3")
        self.assertLess(float(abs(endpoint[0, 0] - expected_first).mid()), 1.0e-25)
        self.assertLess(float(abs(endpoint[1, 0] - expected_second).mid()), 1.0e-25)

    def test_default_mode_refuses_and_explains_explicit_singularity_jump(self) -> None:
        system = _fractional_diagonal_system()
        with self.assertRaises(SingularPathError) as context:
            plan_transport_path(system, acb(0), [acb(2)])
        self.assertIn("singularity_mode='singularity_jump'", str(context.exception))

    def test_cn_message_language_localizes_the_refusal(self) -> None:
        system = _fractional_diagonal_system()
        with self.assertRaises(SingularPathError) as context:
            plan_transport_path(
                system, acb(0), [acb(2)], message_language="CN"
            )
        self.assertIn("缺省避开奇点", str(context.exception))


if __name__ == "__main__":
    unittest.main()
