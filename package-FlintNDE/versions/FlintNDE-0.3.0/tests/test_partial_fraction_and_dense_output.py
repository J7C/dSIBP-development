"""检查 0.2.0 的三条新路线：极点--留数递推、嵌入式截断认证与段内 dense output。"""

from __future__ import annotations

import unittest

from flint import acb, acb_mat

from flintnde import (
    AnalyticMatrixSystem,
    PartialFractionSystem,
    build_straight_path,
    column_vector,
    configure_working_precision,
    plan_transport_path,
    relative_difference_inf,
    transport_path,
    transport_planned_path,
    transport_path_refined,
)


def _diagonal_dlog_partial_fraction() -> PartialFractionSystem:
    """A(z)=diag(1/(z-1), -2/(z+3))，有闭式解可供对照。"""

    return PartialFractionSystem(
        constant=acb_mat([[0, 0], [0, 0]]),
        residues=(
            acb_mat([[1, 0], [0, 0]]),
            acb_mat([[0, 0], [0, -2]]),
        ),
        poles=(acb(1), acb(-3)),
        name="diagonal-dlog-test",
    )


def _diagonal_dlog_analytic() -> AnalyticMatrixSystem:
    """与 ``_diagonal_dlog_partial_fraction`` 相同系统的黑盒 Cauchy--DFT 版本。"""

    return AnalyticMatrixSystem(
        lambda z: acb_mat([[1 / (z - 1), 0], [0, -2 / (z + 3)]]),
        2,
        (acb(1), acb(-3)),
        "diagonal-dlog-analytic",
    )


class AdaptivePathPrecisionTest(unittest.TestCase):
    """检查比例节点继承当前 FLINT 精度，而不是停留在 binary64。"""

    def test_node_bit_accuracy_tracks_requested_decimal_digits(self) -> None:
        """70/100 位请求生成的真实节点应分别提升到对应 bit 精度。"""

        system = _diagonal_dlog_partial_fraction()
        measured_bits: dict[int, int] = {}
        for decimal_digits in (70, 100):
            with self.subTest(decimal_digits=decimal_digits):
                configured_bits = configure_working_precision(decimal_digits, 32)
                path = build_straight_path(
                    system,
                    acb(0),
                    acb("1/2"),
                    step_fraction=0.20,
                )
                node_bits = path[1].real.rel_accuracy_bits()
                measured_bits[decimal_digits] = node_bits
                self.assertGreaterEqual(node_bits, configured_bits - 1)

        self.assertGreater(measured_bits[100], measured_bits[70])

    def test_polynomial_only_system_plans_without_finite_poles(self) -> None:
        """纯多项式连接没有有限极点，也必须完成多点规划与公式递推。"""

        system = PartialFractionSystem(
            constant=acb_mat([[1]]),
            polynomial_coefficients=(acb_mat([[2]]),),
            residues=(),
            poles=(),
            name="polynomial-only-test",
        )
        plan = plan_transport_path(system, acb(0), [acb("1/4"), acb("1/2")])
        self.assertEqual(plan.report["singularity_jump_count"], 0)
        self.assertIsNone(plan.report["minimum_pole_path_distance"])
        snapshots, _reports, _elapsed, _dense = transport_planned_path(
            system,
            column_vector([1]),
            plan,
            order=48,
        )
        self.assertLess(
            float(abs(snapshots[-1][0, 0] - acb("3/4").exp()).mid()),
            1.0e-35,
        )


class PoleRecurrenceTest(unittest.TestCase):
    """极点状态递推与 Cauchy--DFT 采样重建的逐分量一致性。"""

    @classmethod
    def setUpClass(cls) -> None:
        configure_working_precision(60, 32)

    def test_matrix_coefficients_match_closed_form(self) -> None:
        system = _diagonal_dlog_partial_fraction()
        coefficients = system.taylor_matrix_coefficients(acb(0), 12)
        for degree, coefficient in enumerate(coefficients):
            # 1/(z-1)=-1/(1-z)；-2/(z+3)=-2/3·1/(1+z/3)，含交错符号
            expected_11 = -acb(1)
            expected_22 = acb(2 * (-1) ** (degree + 1)) / acb(3) ** (degree + 1)
            self.assertLess(
                float(abs(coefficient[0, 0] - expected_11).mid()), 1.0e-40
            )
            self.assertLess(
                float(abs(coefficient[1, 1] - expected_22).mid()), 1.0e-40
            )
            self.assertLess(float(abs(coefficient[0, 1]).mid()), 1.0e-45)
            self.assertLess(float(abs(coefficient[1, 0]).mid()), 1.0e-45)

    def test_recurrence_transport_matches_cauchy_dft_componentwise(self) -> None:
        pole_system = _diagonal_dlog_partial_fraction()
        analytic_system = _diagonal_dlog_analytic()
        path = build_straight_path(pole_system, acb(0), acb("1/2"), step_fraction=0.25)
        pole_result = transport_path(
            pole_system, column_vector([1, 1]), path, order=48
        )
        cauchy_result = transport_path(
            analytic_system, column_vector([1, 1]), path, order=48, sample_count=160
        )
        difference = relative_difference_inf(pole_result[0][-1], cauchy_result[0][-1])
        # Cauchy--DFT 侧的混叠/球误差主导差值；递推本身对单极点系统是精确的
        self.assertLess(float(difference.mid()), 1.0e-30)

    def test_recurrence_transport_matches_closed_form(self) -> None:
        system = _diagonal_dlog_partial_fraction()
        path = build_straight_path(system, acb(0), acb("1/2"), step_fraction=0.25)
        result = transport_path(system, column_vector([1, 1]), path, order=64)
        endpoint = result[0][-1]
        # y1(1/2)=1/2、y2(1/2)=(7/6)^(-2)=36/49
        self.assertLess(float(abs(endpoint[0, 0] - acb("1/2")).mid()), 1.0e-40)
        self.assertLess(
            float(abs(endpoint[1, 0] - acb("36/49")).mid()), 1.0e-40
        )

    def test_prefix_coefficients_are_order_independent(self) -> None:
        """递推前缀性质：高阶运行的低阶系数与低阶运行逐位一致。"""

        system = _diagonal_dlog_partial_fraction()
        initial = column_vector([1, 1])
        short = system.solution_taylor_coefficients(acb(0), 20, initial)
        long = system.solution_taylor_coefficients(acb(0), 40, initial)
        for degree in range(21):
            difference = relative_difference_inf(short[degree], long[degree])
            self.assertEqual(float(difference.mid()), 0.0)


class EmbeddedCertificationTest(unittest.TestCase):
    """嵌入式单链截断认证与独立双链认证的一致性。"""

    @classmethod
    def setUpClass(cls) -> None:
        configure_working_precision(60, 32)

    def test_embedded_primary_matches_certified_primary(self) -> None:
        system = _diagonal_dlog_partial_fraction()
        path = [acb(0), acb("1/2")]
        embedded = transport_path_refined(
            system,
            column_vector([1, 1]),
            path,
            primary_order=40,
            reference_order=45,
            certification_mode="embedded",
        )
        certified = transport_path_refined(
            system,
            column_vector([1, 1]),
            path,
            primary_order=40,
            reference_order=45,
            certification_mode="certified",
        )
        self.assertEqual(embedded["certification_mode"], "embedded")
        primary_difference = relative_difference_inf(
            embedded["primary_snapshots"][-1], certified["primary_snapshots"][-1]
        )
        # 前缀性质保证系数逐位一致；残差只来自段末中点重启的球舍入，
        # 量级在工作精度末位（~1e-43），与目标 1e-30 相比可忽略
        self.assertLess(float(primary_difference.mid()), 1.0e-38)
        reference_difference = relative_difference_inf(
            embedded["reference_snapshots"][-1], certified["reference_snapshots"][-1]
        )
        self.assertLess(float(reference_difference.mid()), 1.0e-38)
        self.assertEqual(
            len(embedded["segment_truncation_differences_inf"]), len(path) - 1
        )
        for truncation in embedded["segment_truncation_differences_inf"]:
            self.assertLess(float(truncation.mid()), 1.0e-20)

    def test_embedded_matches_closed_form(self) -> None:
        system = _diagonal_dlog_partial_fraction()
        path = [acb(0), acb("1/2")]
        result = transport_path_refined(
            system,
            column_vector([1, 1]),
            path,
            primary_order=40,
            reference_order=45,
            certification_mode="embedded",
            target_relative_error="1e-30",
        )
        endpoint = result["primary_snapshots"][-1]
        self.assertLess(float(abs(endpoint[0, 0] - acb("1/2")).mid()), 1.0e-35)
        self.assertLess(float(abs(endpoint[1, 0] - acb("36/49")).mid()), 1.0e-29)
        self.assertTrue(result["target_relative_error_met"])


    def test_multisegment_embedded_request_upgrades_to_certified(self) -> None:
        """多段前缀不能传播低阶初值误差，必须自动改跑独立双链。"""

        system = _diagonal_dlog_partial_fraction()
        path = [acb(0), acb("1/4"), acb("1/2")]
        with self.assertWarns(UserWarning):
            result = transport_path_refined(
                system,
                column_vector([1, 1]),
                path,
                primary_order=32,
                reference_order=40,
                certification_mode="embedded",
            )
        self.assertEqual(result["certification_mode_requested"], "embedded")
        self.assertEqual(result["certification_mode"], "certified")
        self.assertTrue(result["multi_segment_forced_certified"])
        self.assertFalse(result["singular_local_forced_certified"])


class DenseOutputTest(unittest.TestCase):
    """段内采样点求值与逐点重建路径的一致性。"""

    @classmethod
    def setUpClass(cls) -> None:
        configure_working_precision(60, 32)

    def test_sample_points_match_pointwise_rebuild(self) -> None:
        system = _diagonal_dlog_partial_fraction()
        # 靠近极点 1 时收敛半径缩短，路径需按最近奇点加密
        natural_path = [acb(0), acb("1/4"), acb("1/2"), acb("3/4")]
        samples = [acb("1/8"), acb("5/8")]
        dense_result = transport_path(
            system,
            column_vector([1, 1]),
            natural_path,
            order=48,
            sample_points=samples,
        )
        dense_values = {
            record["coordinate"]: record["value"]
            for record in dense_result[3]["sample_results"]
        }
        self.assertEqual(len(dense_values), 2)
        # 逐点重建：把采样点插入路径作为真节点独立输运
        rebuild_paths = {
            samples[0].str(40): [acb(0), samples[0]],
            samples[1].str(40): [acb(0), acb("1/4"), acb("1/2"), samples[1]],
        }
        closed_forms = {samples[0].str(40): ("7/8", "576/625"),
                        samples[1].str(40): ("3/8", "576/841")}
        for key, rebuild_path in rebuild_paths.items():
            rebuild = transport_path(
                system, column_vector([1, 1]), rebuild_path, order=48
            )
            dense_value = dense_values[key]
            difference = relative_difference_inf(dense_value, rebuild[0][-1])
            self.assertLess(float(difference.mid()), 1.0e-35)
            closed_1, closed_2 = closed_forms[key]
            self.assertLess(
                float(abs(dense_value[0, 0] - acb(closed_1)).mid()), 1.0e-35
            )
            self.assertLess(
                float(abs(dense_value[1, 0] - acb(closed_2)).mid()), 1.0e-35
            )
        # dense output 不改变路径：snapshot 数仍为自然节点数
        self.assertEqual(len(dense_result[0]), 4)

    def test_sample_point_outside_segments_is_rejected(self) -> None:
        system = _diagonal_dlog_partial_fraction()
        with self.assertRaises(ValueError):
            transport_path(
                system,
                column_vector([1, 1]),
                [acb(0), acb("1/2")],
                order=24,
                sample_points=[acb(2)],
            )

    def test_refined_transport_returns_sample_results(self) -> None:
        system = _diagonal_dlog_partial_fraction()
        result = transport_path_refined(
            system,
            column_vector([1, 1]),
            [acb(0), acb("2/5")],
            primary_order=32,
            reference_order=36,
            certification_mode="embedded",
            sample_points=[acb("1/5")],
        )
        records = result["sample_results"]
        self.assertEqual(len(records), 1)
        value = records[0]["value"]
        # y1(1/5)=4/5、y2(1/5)=(16/15)^(-2)=225/256
        self.assertLess(float(abs(value[0, 0] - acb("4/5")).mid()), 1.0e-35)
        self.assertLess(
            float(abs(value[1, 0] - acb("225/256")).mid()), 1.0e-35
        )


if __name__ == "__main__":
    unittest.main()
