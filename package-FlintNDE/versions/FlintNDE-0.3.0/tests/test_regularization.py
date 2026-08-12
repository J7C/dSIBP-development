"""检查幂级数解重构的自动规划、完整 NDE 复用和失败门禁。

测试使用零系数矩阵，使终点值等于 regulator 依赖的普通点边界；每个样本仍真实经过
``transport_path_refined`` 的主/参考链。这样可以独立检查外层采样、最低幂、Acb 方阵
插值、验证点和 caller-local 输出，而不把测试结果依赖于另一个复杂物理系统。
"""

from __future__ import annotations

import json
import tempfile
import unittest
from pathlib import Path

from flint import acb, acb_mat, fmpq

from flintnde import (
    AnalyticMatrixSystem,
    LeadingPowerDetectionError,
    NamedPoint,
    RationalMatrixSystem,
    SeriesValidationError,
    build_adaptive_path,
    configure_working_precision,
    fit_sampled_series,
    frobenius_boundary,
    initialize_output_layout,
    rational_function,
    reconstruct_series_solution,
)


def zero_system(dimension: int) -> AnalyticMatrixSystem:
    """返回有远端哑奇点、可自动控制 Cauchy 圆的零矩阵系统。"""

    return AnalyticMatrixSystem(
        lambda _z: acb_mat(dimension, dimension),
        dimension,
        (acb(-10), acb(10)),
        f"zero-system-{dimension}",
    )


class SeriesReconstructionTest(unittest.TestCase):
    """验证新高层接口不依赖公开采样计划对象或单独拟合命令。"""

    def test_automatic_leading_power_and_amflow_style_plan(self) -> None:
        """自动识别 ``ep^-1`` 并按通用化 AMFlow 公式生成六个生产点。"""

        system = zero_system(1)

        def boundary(ep: fmpq) -> list[acb]:
            regulator = acb(ep)
            return [acb(2) / regulator + acb(3) + acb(4) * regulator]

        result = reconstruct_series_solution(
            DEmatrix=system,
            boundary=boundary,
            path=[acb(0), acb(1)],
            maximum_power=1,
            goal_digits=8,
            transport_order=4,
            transport_extra_order=2,
        )

        self.assertEqual(result.leading_power, -1)
        self.assertEqual(result.powers, (-1, 0, 1))
        self.assertEqual(result.effective_parameters["sample_count"], 6)
        self.assertEqual(result.internal_maximum_power, 4)
        for power, expected in ((-1, 2), (0, 3), (1, 4)):
            difference = abs(result.coefficient(power)[0, 0] - acb(expected))
            self.assertLess(float(difference.mid()), 1.0e-20)
        self.assertFalse(result.diagnostics["least_squares_used"])
        self.assertEqual(result.diagnostics["pilot"]["source"], "automatic-pilot")
        self.assertEqual(
            len(result.diagnostics["validation_solves"]), 2
        )

    def test_explicit_leading_power_warns_when_pilot_detects_lower_power(self) -> None:
        """用户最低幂遗漏完整边界与 DE 检出的负幂时必须提醒但不代改。"""

        def boundary(ep: fmpq) -> list[acb]:
            regulator = acb(ep)
            return [acb(2) / regulator + acb(3) + acb(4) * regulator]

        with self.assertWarnsRegex(UserWarning, r"boundary\+DE pilot value -1"):
            with self.assertRaises(SeriesValidationError):
                reconstruct_series_solution(
                    DEmatrix=zero_system(1),
                    boundary=boundary,
                    path=[acb(0), acb(1)],
                    maximum_power=1,
                    leading_power=0,
                    goal_digits=8,
                    sample_points=("0.010", "0.011", "0.012", "0.013"),
                    validation_points=("0.008",),
                    validation_tolerance="1e-8",
                    working_precision_digits=60,
                    transport_order=4,
                    transport_extra_order=2,
                )

    def test_explicit_exact_points_vector_coefficients_and_output(self) -> None:
        """显式十进制字符串保持 fmpq 工厂输入，并保存矢量系数 JSON。"""

        received_types: list[type] = []

        def system_factory(ep: fmpq) -> AnalyticMatrixSystem:
            received_types.append(type(ep))
            return zero_system(2)

        def boundary(ep: fmpq) -> list[acb]:
            regulator = acb(ep)
            return [
                acb(2) / regulator + acb(3) + acb(4) * regulator,
                -regulator,
            ]

        with tempfile.TemporaryDirectory() as temporary_directory:
            caller = Path(temporary_directory) / "run_reconstruction.py"
            caller.write_text("# test caller\n", encoding="utf-8")
            layout = initialize_output_layout(caller, run_name="series_case")
            result = reconstruct_series_solution(
                DEmatrix=system_factory,
                boundary=boundary,
                path=[acb(0), acb(1)],
                maximum_power=1,
                goal_digits=20,
                sample_points=("0.010", "0.011", "0.012", "0.013", "0.014"),
                leading_power=-1,
                working_precision_digits=80,
                transport_order=4,
                transport_extra_order=2,
                validation_tolerance="1e-30",
                output_layout=layout,
                result_name="normalization_factor",
            )
            self.assertEqual(
                result.diagnostics["pilot"]["detected_leading_power"], -1
            )
            self.assertEqual(
                result.diagnostics["pilot"]["coverage_status"],
                "covers-detected-leading-power",
            )

            expected_vectors = {
                -1: (2, 0),
                0: (3, 0),
                1: (4, -1),
            }
            for power, expected in expected_vectors.items():
                coefficient = result.coefficient(power)
                for row, scalar in enumerate(expected):
                    self.assertLess(
                        float(abs(coefficient[row, 0] - acb(scalar)).mid()),
                        1.0e-30,
                    )
            self.assertTrue(received_types)
            self.assertTrue(all(value is fmpq for value in received_types))
            output_file = layout.run_root / result.output_file
            self.assertTrue(output_file.is_file())
            payload = json.loads(output_file.read_text(encoding="utf-8"))
            self.assertEqual(payload["maximum_power"], 1)
            self.assertEqual(payload["internal_maximum_power"], 3)
            self.assertEqual(payload["effective_parameters"]["sample_source"], "user")

    def test_fit_sampled_series_accepts_custom_points_and_scalar_values(self) -> None:
        """外部 W 型标量可在不重跑 NDE 的情况下用自定义点拟合并独立验证。"""

        configure_working_precision(90, 32)

        def polynomial(point: str) -> acb:
            regulator = acb(point)
            return 2 + 3 * regulator + 4 * regulator**2 - 5 * regulator**3

        production_points = ("0.006", "0.0041", "0.0027", "0.0013")
        validation_points = ("0.0008", "0.00045")
        result = fit_sampled_series(
            sample_points=production_points,
            sample_values=tuple(polynomial(point) for point in production_points),
            maximum_power=3,
            validation_points=validation_points,
            validation_values=tuple(polynomial(point) for point in validation_points),
            validation_tolerance="1e-60",
            series_parameter="delta",
        )

        for power, expected in enumerate((2, 3, 4, -5)):
            self.assertLess(
                float(abs(result.coefficient(power)[0, 0] - acb(expected)).mid()),
                1.0e-60,
            )
        self.assertEqual(result.series_parameter, "delta")
        self.assertEqual(
            result.effective_parameters["validation_source"],
            "user-supplied-values",
        )
        self.assertFalse(result.diagnostics["least_squares_used"])

    def test_fit_sampled_series_uses_explicit_signed_regularization_points(self) -> None:
        """同一组正 delta 标签可用正负正规化点分别恢复两侧级数。"""

        configure_working_precision(90, 32)
        source_points = ("0.006", "0.004", "0.002", "0.001")
        validation_source = ("0.0008", "0.0005")
        expected = (2, 3, -4, 5)

        for sign in (1, -1):
            prefix = "" if sign > 0 else "-"
            regularization_points = tuple(prefix + point for point in source_points)
            validation_regularization_points = tuple(
                prefix + point for point in validation_source
            )

            def polynomial(point: str) -> acb:
                regulator = acb(point)
                return 2 + 3 * regulator - 4 * regulator**2 + 5 * regulator**3

            result = fit_sampled_series(
                sample_points=source_points,
                sample_values=tuple(
                    polynomial(point) for point in regularization_points
                ),
                regularization_points=regularization_points,
                maximum_power=3,
                validation_points=validation_source,
                validation_values=tuple(
                    polynomial(point)
                    for point in validation_regularization_points
                ),
                validation_regularization_points=validation_regularization_points,
                validation_tolerance="1e-60",
                series_parameter="signed_delta",
            )

            for power, coefficient in enumerate(expected):
                self.assertLess(
                    float(abs(result.coefficient(power)[0, 0] - acb(coefficient)).mid()),
                    1.0e-60,
                )
            summary = result.to_summary()
            self.assertEqual(summary["sample_points"][0], acb("0.006").str(50))
            self.assertIn("regularization_points", summary)
            self.assertIn("validation_regularization_points", summary)

    def test_fit_sampled_series_default_summary_is_unchanged(self) -> None:
        """缺省正规化点继续复用 sample points，且不扩张稳定摘要 schema。"""

        result = fit_sampled_series(
            sample_points=("0.02", "0.01"),
            sample_values=(acb("1.02"), acb("1.01")),
            maximum_power=1,
        )
        summary = result.to_summary()
        self.assertNotIn("regularization_points", summary)
        self.assertNotIn("validation_regularization_points", summary)
        self.assertIsNone(result.regularization_points)

    def test_fit_sampled_series_rejects_invalid_regularization_pairing(self) -> None:
        """正规化点数与 validation 配对不完整时必须立即阻断。"""

        with self.assertRaisesRegex(ValueError, "counts do not match"):
            fit_sampled_series(
                sample_points=("0.02", "0.01"),
                sample_values=(acb(1), acb(1)),
                regularization_points=("0.02",),
                maximum_power=1,
            )
        with self.assertRaisesRegex(ValueError, "require validation_points"):
            fit_sampled_series(
                sample_points=("0.02", "0.01"),
                sample_values=(acb(1), acb(1)),
                maximum_power=1,
                validation_regularization_points=("0.005",),
            )
    def test_fit_sampled_series_validation_fails_on_truncated_tail(self) -> None:
        """返回阶数截断遗漏的高阶项必须由外部验证点阻断。"""

        configure_working_precision(80, 32)
        production_points = ("0.03", "0.02", "0.01")

        def value(point: str) -> acb:
            regulator = acb(point)
            return 1 + regulator + regulator**2

        with self.assertRaises(SeriesValidationError):
            fit_sampled_series(
                sample_points=production_points,
                sample_values=tuple(value(point) for point in production_points),
                maximum_power=1,
                validation_points=("0.007",),
                validation_values=(value("0.007"),),
                validation_tolerance="1e-8",
            )

    def test_reconstruction_accepts_explicit_validation_points(self) -> None:
        """完整 NDE 重构可直接使用调用方给定且不参与拟合的验证点集合。"""

        received: list[fmpq] = []

        def boundary(ep: fmpq) -> list[acb]:
            received.append(ep)
            return [1 + acb(ep)]

        result = reconstruct_series_solution(
            DEmatrix=zero_system(1),
            boundary=boundary,
            path=[acb(0), acb(1)],
            maximum_power=1,
            leading_power=0,
            goal_digits=20,
            sample_points=("0.006", "0.004", "0.002"),
            validation_points=("0.0009", "0.00055", "0.0003"),
            working_precision_digits=80,
            transport_order=4,
            transport_extra_order=2,
            validation_tolerance="1e-30",
        )

        self.assertEqual(len(result.validation_points), 3)
        self.assertEqual(result.effective_parameters["validation_source"], "user")
        self.assertTrue(all(type(point) is fmpq for point in received))

    def test_noninteger_pilot_fails_closed(self) -> None:
        """半整数 regulator 行为不得被四舍五入为 Laurent 整数幂。"""

        with self.assertRaises(LeadingPowerDetectionError):
            reconstruct_series_solution(
                DEmatrix=zero_system(1),
                boundary=lambda ep: [acb(ep).sqrt()],
                path=[acb(0), acb(1)],
                maximum_power=1,
                goal_digits=8,
                transport_order=4,
                transport_extra_order=2,
                pilot_max_rounds=2,
            )

    def test_automatic_points_can_skip_rationalization(self) -> None:
        """关闭 rationalization 时，自动生产点和验证点都以 Acb 传给工厂。"""

        received_types: list[type] = []

        def system_factory(ep: acb) -> AnalyticMatrixSystem:
            received_types.append(type(ep))
            return zero_system(1)

        result = reconstruct_series_solution(
            DEmatrix=system_factory,
            boundary=[1],
            path=[acb(0), acb(1)],
            maximum_power=0,
            goal_digits=6,
            leading_power=0,
            transport_order=3,
            transport_extra_order=2,
            rationalize_sample_points=False,
        )

        self.assertEqual(result.coefficient(0)[0, 0], acb(1))
        self.assertTrue(received_types)
        self.assertTrue(all(value is acb for value in received_types))

    def test_independent_validation_rejects_insufficient_buffer(self) -> None:
        """只拟合最低所需三项时，未建模指数尾项必须触发独立验证失败。"""

        with self.assertRaises(SeriesValidationError):
            reconstruct_series_solution(
                DEmatrix=zero_system(1),
                boundary=lambda ep: [acb(ep).exp() / acb(ep)],
                path=[acb(0), acb(1)],
                maximum_power=1,
                goal_digits=12,
                sample_points=("0.010", "0.011", "0.012"),
                leading_power=-1,
                working_precision_digits=70,
                transport_order=4,
                transport_extra_order=2,
                validation_tolerance="1e-14",
            )

    def test_singular_start_boundary_is_reused_by_series_reconstruction(self) -> None:
        """外层 regulator 重构必须复用基础输运的 ``{a,b,C}`` 验证和初始化。"""

        system = RationalMatrixSystem(
            ((rational_function(1, [0, 1]),),),
            name="reconstruction-singular-start",
        )
        with self.assertWarns(UserWarning):
            singular_path = build_adaptive_path(
                system,
                NamedPoint("boundary", 0),
                NamedPoint("target", 1),
                max_step_over_radius=0.15,
            )

        def boundary(ep: fmpq):
            return frobenius_boundary([{"a": 1, "b": 0, "C": [1 + ep]}])

        result = reconstruct_series_solution(
            DEmatrix=system,
            boundary=boundary,
            path=singular_path,
            maximum_power=1,
            goal_digits=12,
            sample_points=("0.010", "0.011", "0.012", "0.013"),
            leading_power=0,
            working_precision_digits=70,
            transport_order=24,
            transport_extra_order=8,
            transport_sample_count=96,
            transport_extra_sample_count=128,
            validation_tolerance="1e-10",
        )
        self.assertLess(float(abs(result.coefficient(0)[0, 0] - acb(1)).mid()), 1.0e-10)
        self.assertLess(float(abs(result.coefficient(1)[0, 0] - acb(1)).mid()), 1.0e-10)
        boundary_report = result.diagnostics["production_solves"][0][
            "boundary_initialization"
        ]
        self.assertEqual(
            boundary_report["method"], "regular_singular_boundary_initialization"
        )

        with self.assertRaisesRegex(TypeError, r"\{a,b,C\}"):
            reconstruct_series_solution(
                DEmatrix=system,
                boundary=[1],
                path=singular_path,
                maximum_power=0,
                goal_digits=6,
                leading_power=0,
                transport_order=4,
                transport_extra_order=2,
            )


if __name__ == "__main__":
    unittest.main()
