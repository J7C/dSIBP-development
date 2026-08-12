"""检查 Jordan log 和整数差共振 log 的 exact gate。"""

from __future__ import annotations

import unittest

from flint import acb, acb_mat, arb, fmpq

from flintnde import (
    NumericalFrobeniusOptions,
    NumericalRegularSingularSystem,
    RegularSingularSystem,
    build_exact_frobenius_manifest,
    build_frobenius_manifest,
    build_numerical_frobenius_manifest,
    build_power_log_basis,
    configure_working_precision,
    gaussian_rational,
)


class FrobeniusTest(unittest.TestCase):
    """验证重根、Jordan 和 resonance 三者没有被混同。"""

    @classmethod
    def setUpClass(cls) -> None:
        configure_working_precision(60, 32)

    def test_exact_gaussian_public_input_forms(self) -> None:
        """公开 exact 标量入口必须统一解析全部承诺的 Q(i) 输入格式。"""

        expected = gaussian_rational((fmpq(3, 2), fmpq(-5, 7)))
        inputs = (
            (fmpq(3, 2), fmpq(-5, 7)),
            {"real": "3/2", "imag": "-5/7"},
            "3/2-5/7*I",
        )
        for value in inputs:
            with self.subTest(value=value):
                self.assertEqual(gaussian_rational(value), expected)
        self.assertEqual(gaussian_rational(3), gaussian_rational("3"))
        self.assertEqual(gaussian_rational("0.125"), gaussian_rational("1/8"))
        for value in (0.125, 0.125j, acb("0.125")):
            with self.subTest(rejected=value):
                with self.assertRaises(TypeError):
                    gaussian_rational(value)

    def test_length_three_jordan_generates_log_squared(self) -> None:
        system = RegularSingularSystem(
            [["0", "1", "0"], ["0", "0", "1"], ["0", "0", "0"]],
            (),
            "length-three-jordan",
        )
        manifest = build_exact_frobenius_manifest(system)
        self.assertEqual(manifest["maximum_log_degree"], 2)
        basis = build_power_log_basis(system, manifest, series_order=4)
        point = acb("0.2")
        residue = acb_mat([[0, 1, 0], [0, 0, 1], [0, 0, 0]])
        expected = (residue * point.log()).exp()
        actual = basis.evaluate(point)
        for row in range(3):
            for column in range(3):
                self.assertLess(float(abs(actual[row, column] - expected[row, column]).mid()), 1.0e-40)

    def test_complex_indicial_root_and_jordan_chain_are_exact(self) -> None:
        """共同复根 ``I`` 的长度二 Jordan 链必须严格生成一阶 log。"""

        system = RegularSingularSystem(
            [["I", "1"], ["0", "I"]],
            (),
            "complex-jordan",
        )
        manifest = build_exact_frobenius_manifest(system)
        self.assertEqual(manifest["roots_exact"], ["1*I"])
        self.assertEqual(manifest["maximum_log_degree"], 1)
        basis = build_power_log_basis(system, manifest, series_order=4)
        point = acb("0.2")
        residue = acb_mat([[acb(0, 1), 1], [0, acb(0, 1)]])
        expected = (residue * point.log()).exp()
        actual = basis.evaluate(point)
        for row in range(2):
            for column in range(2):
                self.assertLess(
                    float(abs(actual[row, column] - expected[row, column]).mid()),
                    1.0e-40,
                )

    def test_complex_roots_with_integer_difference_trigger_resonance(self) -> None:
        """根 ``I`` 与 ``1+I`` 的严格整数差必须进入 resonance gate。"""

        system = RegularSingularSystem(
            [["I", "0"], ["0", "1+I"]],
            ([['0', '0'], ['1', '0']],),
            "complex-integer-difference",
        )
        manifest = build_exact_frobenius_manifest(system)
        self.assertEqual(manifest["roots_exact"], ["1*I", "1 + 1*I"])
        self.assertTrue(any(manifest["resonance_gates"].values()))
        self.assertEqual(manifest["maximum_log_degree"], 1)

    def test_integer_difference_resonance_generates_log(self) -> None:
        system = RegularSingularSystem(
            [["0", "0"], ["0", "1"]],
            ([["0", "0"], ["1", "0"]],),
            "integer-difference-resonance",
        )
        manifest = build_exact_frobenius_manifest(system)
        self.assertTrue(any(manifest["resonance_gates"].values()))
        self.assertEqual(manifest["maximum_log_degree"], 1)
        basis = build_power_log_basis(system, manifest, series_order=5)
        self.assertEqual(basis.maximum_log_degree, 1)
        point = acb("0.2")
        actual = basis.evaluate(point)
        expected = acb_mat([[1, 0], [point * point.log(), point]])
        for row in range(2):
            for column in range(2):
                self.assertLess(float(abs(actual[row, column] - expected[row, column]).mid()), 1.0e-40)

    def test_repeated_semisimple_root_does_not_generate_log(self) -> None:
        system = RegularSingularSystem(
            [["0", "0"], ["0", "0"]],
            (),
            "repeated-semisimple-root",
        )
        manifest = build_exact_frobenius_manifest(system)
        self.assertEqual(manifest["maximum_log_degree"], 0)
        basis = build_power_log_basis(system, manifest, series_order=3)
        self.assertEqual(basis.maximum_log_degree, 0)

    def test_default_dispatch_uses_exact_route_for_exact_input(self) -> None:
        system = RegularSingularSystem(
            [["0", "0"], ["0", "1"]],
            (),
            "default-exact-route",
        )
        manifest = build_frobenius_manifest(system)
        self.assertEqual(manifest["schema"], "flintnde_exact_frobenius_manifest_v1")
        self.assertTrue(manifest["route"].endswith("_exact_gate"))

    def test_exact_input_failure_remains_on_exact_route(self) -> None:
        system = RegularSingularSystem(
            [["0", "2"], ["1", "0"]],
            (),
            "exact-failure-stays-exact",
        )
        with self.assertRaisesRegex(ValueError, "splits completely over"):
            build_frobenius_manifest(system)

    def test_float_dispatch_caps_precision_at_binary64_input(self) -> None:
        system = NumericalRegularSingularSystem(
            [[0.0, 0.0], [0.0, 1.0]],
            (),
            "binary64-route",
        )
        with self.assertWarns(UserWarning):
            manifest = build_frobenius_manifest(
                system,
                NumericalFrobeniusOptions(precision_digits=80),
            )
        diagnostics = manifest["numeric_diagnostics"]
        self.assertEqual(diagnostics["precision_digits"], 15)
        self.assertIn("python_binary64_input", diagnostics["tolerance_source"])
        self.assertTrue(manifest["route"].endswith("_numeric_gate"))

    def test_unannotated_decimal_numeric_input_fails_closed(self) -> None:
        system = NumericalRegularSingularSystem(
            [["0.0", "0.0"], ["0.0", "1.0"]],
            (),
            "unknown-decimal-precision",
        )
        with self.assertRaisesRegex(ValueError, "input precision is unknown"):
            build_frobenius_manifest(system)

    def test_numerical_resonance_still_uses_power_log_basis(self) -> None:
        system = NumericalRegularSingularSystem(
            [[0.0, 0.0], [0.0, 1.0]],
            ([[0.0, 0.0], [1.0, 0.0]],),
            "numerical-integer-difference-resonance",
        )
        options = NumericalFrobeniusOptions(precision_digits=60)
        with self.assertWarnsRegex(UserWarning, "relative to matrix scale"):
            manifest = build_numerical_frobenius_manifest(system, options)
        self.assertEqual(manifest["numeric_diagnostics"]["classification"], "numerical_threshold")
        self.assertTrue(any(manifest["resonance_gates"].values()))
        self.assertEqual(manifest["maximum_log_degree"], 1)
        basis = build_power_log_basis(system, manifest, series_order=5)
        self.assertEqual(basis.maximum_log_degree, 1)

    def test_numerical_threshold_reports_largest_zeroed_value(self) -> None:
        system = NumericalRegularSingularSystem(
            [["0", "1e-210"], ["0", "1"]],
            (),
            "numerical-zero-audit",
        )
        with self.assertWarnsRegex(UserWarning, "matrix scale") as warning_context:
            manifest = build_numerical_frobenius_manifest(
                system,
                NumericalFrobeniusOptions(precision_digits=200),
            )
        diagnostics = manifest["numeric_diagnostics"]
        self.assertTrue(arb(diagnostics["absolute_zero_cutoff"]).overlaps(arb("2e-200")))
        self.assertTrue(
            arb(diagnostics["largest_zeroed_absolute_value"]).overlaps(arb("1e-210"))
        )
        self.assertTrue(
            arb(diagnostics["largest_zeroed_relative_to_matrix_scale"]).overlaps(
                arb("1e-210")
            )
        )
        self.assertIsNotNone(diagnostics["smallest_retained_absolute_value"])
        self.assertIsNotNone(
            diagnostics["smallest_retained_relative_to_matrix_scale"]
        )
        warning_text = str(warning_context.warning)
        self.assertIn(diagnostics["absolute_zero_cutoff"], warning_text)
        self.assertIn(diagnostics["relative_zero_tolerance"], warning_text)
        self.assertIn(diagnostics["matrix_scale"], warning_text)

    def test_custom_numerical_threshold_still_reports_absolute_and_relative_values(self) -> None:
        system = NumericalRegularSingularSystem(
            [["0", "1e-30"], ["0", "2"]],
            (),
            "custom-numerical-zero-audit",
        )
        with self.assertWarnsRegex(UserWarning, "smallest retained value"):
            manifest = build_numerical_frobenius_manifest(
                system,
                NumericalFrobeniusOptions(
                    precision_digits=80,
                    relative_zero_tolerance="1e-20",
                ),
            )
        diagnostics = manifest["numeric_diagnostics"]
        self.assertEqual(diagnostics["tolerance_source"], "user")
        self.assertTrue(
            arb(diagnostics["largest_zeroed_absolute_value"]).overlaps(arb("1e-30"))
        )
        self.assertTrue(
            arb(diagnostics["largest_zeroed_relative_to_matrix_scale"]).overlaps(
                arb("5e-31")
            )
        )

    def test_zero_matrix_scale_marks_relative_values_undefined(self) -> None:
        system = NumericalRegularSingularSystem(
            [["0", "0"], ["0", "0"]],
            (),
            "zero-scale-audit",
        )
        with self.assertWarnsRegex(UserWarning, "matrix scale is zero"):
            manifest = build_numerical_frobenius_manifest(
                system,
                NumericalFrobeniusOptions(precision_digits=60),
            )
        diagnostics = manifest["numeric_diagnostics"]
        self.assertTrue(diagnostics["matrix_scale_is_zero"])
        self.assertIsNone(diagnostics["largest_zeroed_relative_to_matrix_scale"])
        self.assertIsNone(diagnostics["smallest_retained_relative_to_matrix_scale"])

    def test_nonrational_exact_spectrum_fails_closed(self) -> None:
        system = RegularSingularSystem(
            [["0", "2"], ["1", "0"]],
            (),
            "nonrational-spectrum",
        )
        with self.assertRaisesRegex(ValueError, "splits completely over"):
            build_exact_frobenius_manifest(system)

    def test_exact_gate_rejects_python_float_input(self) -> None:
        system = RegularSingularSystem(
            [[0.0, 0.0], [0.0, 1.0]],
            (),
            "float-sent-to-exact-gate",
        )
        with self.assertRaisesRegex(TypeError, "NumericalRegularSingularSystem"):
            build_exact_frobenius_manifest(system)

    def test_numerical_jordan_block_generates_log(self) -> None:
        system = NumericalRegularSingularSystem(
            [[0.0, 1.0], [0.0, 0.0]],
            (),
            "numerical-jordan",
        )
        with self.assertWarns(UserWarning):
            manifest = build_numerical_frobenius_manifest(
                system,
                NumericalFrobeniusOptions(precision_digits=60),
            )
        basis = build_power_log_basis(system, manifest, series_order=3)
        self.assertEqual(basis.maximum_log_degree, 1)

    def test_numerical_repeated_semisimple_root_has_no_log(self) -> None:
        system = NumericalRegularSingularSystem(
            [[0.0, 0.0], [0.0, 0.0]],
            (),
            "numerical-repeated-semisimple",
        )
        with self.assertWarns(UserWarning):
            manifest = build_numerical_frobenius_manifest(
                system,
                NumericalFrobeniusOptions(precision_digits=60),
            )
        basis = build_power_log_basis(system, manifest, series_order=3)
        self.assertEqual(manifest["maximum_log_degree"], 0)
        self.assertEqual(basis.maximum_log_degree, 0)


if __name__ == "__main__":
    unittest.main()
