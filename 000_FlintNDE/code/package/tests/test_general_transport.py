"""检查一般解析矩阵的 Cauchy 系数和普通点输运。"""

from __future__ import annotations

import unittest
import warnings

from flint import acb, acb_mat, arb

from flintnde import (
    AnalyticMatrixSystem,
    build_straight_path,
    column_vector,
    configure_working_precision,
    transport_path_refined,
)


class GeneralTransportTest(unittest.TestCase):
    """用非 pole-decomposition 输入验证普通点核心。"""

    @classmethod
    def setUpClass(cls) -> None:
        configure_working_precision(60, 32)

    def test_cauchy_coefficients_for_general_rational_entry(self) -> None:
        system = AnalyticMatrixSystem(
            lambda z: acb_mat([[1 / (1 + z * z)]]),
            1,
            (acb(0, 1), acb(0, -1)),
            "one-over-one-plus-z-squared",
        )
        coefficients = system.taylor_matrix_coefficients(
            acb(0), 10, radius=acb("0.5"), sample_count=80
        )
        for degree, coefficient in enumerate(coefficients):
            expected = acb((-1) ** (degree // 2)) if degree % 2 == 0 else acb(0)
            # 80 点 DFT 的主误差是圆外高阶项混叠，量级约由 (r/R)^80 控制。
            self.assertLess(float(abs(coefficient[0, 0] - expected).mid()), 1.0e-20)

    def test_constant_oscillator_transport(self) -> None:
        system = AnalyticMatrixSystem(
            lambda _z: acb_mat([[0, 1], [-1, 0]]),
            2,
            (acb(0, 2), acb(0, -2)),
            "constant-oscillator",
        )
        path = build_straight_path(system, acb(0), acb(1), step_fraction=0.25)
        result = transport_path_refined(
            system,
            column_vector([1, 0]),
            path,
            primary_order=24,
            reference_order=30,
            primary_sample_count=64,
            reference_sample_count=80,
        )
        endpoint = result["reference_snapshots"][-1]
        self.assertLess(float(abs(endpoint[0, 0] - acb(1).cos()).mid()), 1.0e-30)
        self.assertLess(float(abs(endpoint[1, 0] + acb(1).sin()).mid()), 1.0e-30)
        self.assertLess(result["relative_difference_midpoint"], 1.0e-30)

    def test_refined_transport_reports_unmet_accuracy_without_blocking(self) -> None:
        """基础 NDE 未达到用户精度目标时应保留结果并明确报告失败。"""

        system = AnalyticMatrixSystem(
            lambda z: acb_mat([[1 / (1 + z * z)]]),
            1,
            (acb(0, 1), acb(0, -1)),
            "accuracy-warning-system",
        )
        path = build_straight_path(system, acb(0), acb("1/2"), step_fraction=0.4)
        with self.assertWarnsRegex(UserWarning, "NDE refinement accuracy warning"):
            result = transport_path_refined(
                system,
                column_vector([1]),
                path,
                primary_order=4,
                reference_order=6,
                primary_sample_count=16,
                reference_sample_count=20,
                target_relative_error="1e-40",
            )
        self.assertFalse(result["target_relative_error_met"])
        self.assertEqual(result["target_relative_error"], arb("1e-40").str(30))
        self.assertGreater(len(result["reference_snapshots"]), 1)


if __name__ == "__main__":
    unittest.main()
