"""检查 exact 奇点发现、无穷远变换、统一局部调度和路径规划。"""

from __future__ import annotations

import json
import tempfile
import unittest
import warnings
from pathlib import Path

from flint import acb

from flintnde import (
    LocalReductionError,
    NamedPoint,
    RationalMatrixSystem,
    analyze_singularities,
    build_adaptive_path,
    build_adaptive_path_plan,
    column_vector,
    configure_working_precision,
    frobenius_boundary,
    initialize_output_layout,
    prepare_local_expansion,
    rational_function,
    transport_frobenius_boundaries_refined,
    transport_path,
)


class SingularityRoutingTest(unittest.TestCase):
    """覆盖相消验证、有限/无穷远分类和奇点感知路径。"""

    @classmethod
    def setUpClass(cls) -> None:
        configure_working_precision(70, 32)

    def test_entry_reduction_removes_cancelled_candidate_pole(self) -> None:
        first = rational_function(1, [-1, 1])
        cancelled = first + rational_function(-1, [-1, 1])
        system = RationalMatrixSystem(((cancelled,),), name="cancelled-entry")
        inventory = system.singularity_inventory()
        self.assertEqual(inventory.finite, ())
        self.assertEqual(inventory.infinity.kind, "ordinary")

    def test_finite_roots_and_infinity_are_classified(self) -> None:
        system = RationalMatrixSystem(
            (
                (rational_function(1, [-1, 1]), 0),
                (0, rational_function(1, [1, 0, 1])),
            ),
            name="three-finite-poles",
        )
        inventory = system.singularity_inventory(root_tolerance=1.0e-40)
        self.assertEqual(len(inventory.finite), 3)
        self.assertEqual(sum(record.location_exact == "1" for record in inventory.finite), 1)
        self.assertTrue(all(record.kind == "regular_singular" for record in inventory.finite))
        self.assertEqual(inventory.infinity.kind, "regular_singular")
        self.assertEqual(inventory.infinity.pole_order, 1)

    def test_exact_zero_root_survives_mixed_algebraic_factor(self) -> None:
        """分母同时含零根和非 Q(i) 根时，零根仍必须保留 exact 身份。"""

        system = RationalMatrixSystem(
            ((rational_function(1, [0, 2, 0, 1]),),),
            name="zero-and-algebraic-roots",
        )
        inventory = system.singularity_inventory(root_tolerance=1.0e-40)
        self.assertEqual(len(inventory.finite), 3)
        exact_zero = [record for record in inventory.finite if record.location_exact == "0"]
        self.assertEqual(len(exact_zero), 1)
        self.assertEqual(exact_zero[0].factor_coefficients_exact, ("0", "1"))
        self.assertEqual(exact_zero[0].kind, "regular_singular")

    def test_complex_exact_pole_dispatches_to_exact_frobenius(self) -> None:
        """复系数有理函数必须自动发现 Q(i) pole 并构造复 indicial root。"""

        system = RationalMatrixSystem(
            ((rational_function("1+I", ["-2-3*I", 1]),),),
            name="complex-simple-pole",
        )
        inventory = system.singularity_inventory(root_tolerance=1.0e-40)
        self.assertEqual(len(inventory.finite), 1)
        self.assertEqual(inventory.finite[0].location_exact, "2 + 3*I")
        local = prepare_local_expansion(
            system,
            NamedPoint("complex_pole", "2+3*I"),
            order=6,
        )
        self.assertEqual(local.method, "regular_singular_power_log")
        self.assertEqual(local.manifest["frobenius"]["roots_exact"], ["1 + 1*I"])
        self.assertEqual(local.power_log_basis.maximum_log_degree, 0)

    def test_infinity_transform_includes_derivative_jacobian(self) -> None:
        system = RationalMatrixSystem(((rational_function([1, 1], [1, -1]),),), name="invert")
        transformed = system.inverted()
        point = acb("0.2")
        expected = -(point ** -2) * system.evaluate(1 / point)[0, 0]
        self.assertLess(float(abs(transformed.evaluate(point)[0, 0] - expected).mid()), 1.0e-60)

        constant = RationalMatrixSystem(((1,),), name="constant")
        self.assertEqual(
            constant.singularity_inventory().infinity.kind,
            "non_fuchsian_input_basis",
        )
        self.assertEqual(constant.singularity_inventory().infinity.pole_order, 2)

    def test_off_diagonal_high_order_pole_is_reduced_before_local_dispatch(self) -> None:
        """非对角高阶 pole 应先保持原始分类，再由 exact Moser balance 降阶。"""

        system = RationalMatrixSystem(
            (
                (0, rational_function(1, [0, 0, 1])),
                (0, 0),
            ),
            name="off-diagonal-double-pole",
        )
        record = system.singularity_inventory().finite[0]
        self.assertEqual(record.pole_order, 2)
        self.assertEqual(record.kind, "non_fuchsian_input_basis")
        local = prepare_local_expansion(system, NamedPoint("origin", 0), order=8)
        self.assertEqual(local.method, "fuchsian_reduced_power_log")
        reduction = local.manifest["local_basis"]["fuchsian_reduction"]
        self.assertEqual(reduction["original_pole_order"], 2)
        self.assertEqual(reduction["reduced_pole_order"], 1)
        self.assertEqual(
            reduction["transformation"]["route"],
            "exact_lee_moser_projector_balance",
        )
        self.assertEqual(reduction["transformation"]["balance_count"], 1)
        self.assertEqual(reduction["pole_order_history"], [2, 1])

    def test_unified_local_dispatch_selects_ordinary_and_frobenius(self) -> None:
        system = RationalMatrixSystem(
            ((rational_function(1, [-1, 1]),),),
            name="simple-pole",
        )
        ordinary = prepare_local_expansion(
            system,
            NamedPoint("origin", 0),
            order=8,
            sample_count=128,
        )
        self.assertEqual(ordinary.method, "ordinary_cauchy_dft")
        self.assertLess(float(abs(ordinary.matrix_coefficients[0][0, 0] + 1).mid()), 1.0e-25)

        singular = prepare_local_expansion(system, NamedPoint("pole", 1), order=8)
        self.assertEqual(singular.method, "regular_singular_power_log")
        self.assertEqual(singular.power_log_basis.maximum_log_degree, 0)
        self.assertEqual(singular.manifest["frobenius"]["roots_exact"], ["1"])

    def test_named_path_reports_internal_singularity_and_writes_reusable_files(self) -> None:
        system = RationalMatrixSystem(
            ((rational_function(1, [0, -1, 0, 1]),),),
            name="poles-zero-one-minus-one",
        )
        with tempfile.TemporaryDirectory() as temporary_directory:
            caller = Path(temporary_directory) / "solve_line.py"
            caller.write_text("# caller\n", encoding="utf-8")
            layout = initialize_output_layout(caller, run_name="line_scan")
            with warnings.catch_warnings(record=True) as caught:
                warnings.simplefilter("always")
                plan = build_adaptive_path_plan(
                    system,
                    NamedPoint("left_boundary", "-1"),
                    NamedPoint("right_boundary", "1"),
                    path_name="left_to_right",
                    max_step_over_radius=0.40,
                    output_layout=layout,
                )
            self.assertEqual(plan.start.kind, "regular_singular")
            self.assertEqual(plan.target.kind, "regular_singular")
            self.assertEqual(len(plan.internal_singularities), 1)
            self.assertTrue(plan.continuation_ready)
            self.assertTrue(any("internal singularities" in str(item.message) for item in caught))
            inventory_path = layout.file("singularities", "singularity_inventory.json")
            path_file = layout.file("transport", "left_to_right_path.json")
            self.assertTrue(inventory_path.is_file())
            self.assertTrue(path_file.is_file())
            path_payload = json.loads(path_file.read_text(encoding="utf-8"))
            self.assertEqual(path_payload["max_step_over_convergence_radius"], 0.40)
            self.assertEqual(len(path_payload["internal_singularities"]), 1)
            finite_ratios = [
                segment["step_over_convergence_radius"]
                for segment in path_payload["segments"]
                if segment["step_over_convergence_radius"] is not None
            ]
            self.assertTrue(finite_ratios)
            self.assertLessEqual(max(finite_ratios), 0.40 + 1.0e-12)

    def test_non_gaussian_regular_pole_fails_preflight_and_build(self) -> None:
        """非 Q(i) 正则奇点必须在计划阶段判为超出能力，正式建路立即停止。"""

        system = RationalMatrixSystem(
            ((rational_function(1, [-2, 0, 1]),),),
            name="non-gaussian-regular-poles",
        )
        with warnings.catch_warnings():
            warnings.simplefilter("ignore")
            plan = build_adaptive_path_plan(
                system,
                NamedPoint("left", -2),
                NamedPoint("right", 2),
            )
            with self.assertRaisesRegex(LocalReductionError, r"exact Q\(i\)"):
                build_adaptive_path(
                    system,
                    NamedPoint("left", -2),
                    NamedPoint("right", 2),
                )
        self.assertFalse(plan.continuation_ready)
        self.assertTrue(any("regular_singular" in message for message in plan.messages))

    def test_non_gaussian_indicial_spectrum_fails_preflight_and_build(self) -> None:
        """中心在 Q(i) 但 indicial roots 不受支持时也不能继续输运。"""

        inverse_s = rational_function(1, [0, 1])
        system = RationalMatrixSystem(
            (
                (0, inverse_s),
                (2 * inverse_s, 0),
            ),
            name="non-gaussian-indicial-spectrum",
        )
        with warnings.catch_warnings():
            warnings.simplefilter("ignore")
            plan = build_adaptive_path_plan(
                system,
                NamedPoint("left", -1),
                NamedPoint("right", 1),
            )
            with self.assertRaisesRegex(LocalReductionError, "unsupported regular_singular"):
                build_adaptive_path(
                    system,
                    NamedPoint("left", -1),
                    NamedPoint("right", 1),
                )
        self.assertFalse(plan.continuation_ready)
        self.assertTrue(any("unsupported regular_singular" in message for message in plan.messages))

    def test_infinity_endpoint_uses_sinv_and_is_reported(self) -> None:
        system = RationalMatrixSystem(
            ((rational_function(1, [0, 1]),),),
            variable_name="s",
            name="one-over-s",
        )
        with warnings.catch_warnings(record=True):
            warnings.simplefilter("always")
            plan = build_adaptive_path_plan(
                system,
                NamedPoint("infinity_boundary", "inf"),
                NamedPoint("finite_match", 2),
                max_step_over_radius=0.40,
            )
        self.assertTrue(plan.infinity_transformation)
        self.assertEqual(plan.working_variable, "sinv")
        self.assertEqual(plan.start.kind, "regular_singular")
        local = prepare_local_expansion(
            system,
            NamedPoint("infinity_boundary", "inf"),
            order=6,
        )
        self.assertEqual(local.working_variable, "sinv")
        self.assertEqual(local.method, "regular_singular_power_log")
        self.assertEqual(local.manifest["frobenius"]["roots_exact"], ["-1"])
        with warnings.catch_warnings(record=True):
            warnings.simplefilter("always")
            executable_path = build_adaptive_path(
                system,
                NamedPoint("infinity_boundary", "inf"),
                NamedPoint("finite_match", 2),
                max_step_over_radius=0.40,
            )
        self.assertIsInstance(executable_path, list)
        self.assertFalse(executable_path[0].contains(0))
        self.assertTrue(abs(executable_path[-1] - acb("0.5")).contains(0))

    def test_executable_path_is_direct_transport_path_parameter(self) -> None:
        system = RationalMatrixSystem(
            ((rational_function(1, [-1, 1]),),),
            name="direct-path-system",
        )
        with warnings.catch_warnings(record=True):
            warnings.simplefilter("always")
            path = build_adaptive_path(
                system,
                NamedPoint("start", 0),
                NamedPoint("target", "1/2"),
                max_step_over_radius=0.40,
            )
        self.assertIsInstance(path, list)
        self.assertTrue(all(isinstance(point, acb) for point in path))
        snapshots, reports, _elapsed = transport_path(
            system.to_analytic_system(),
            column_vector([1]),
            path,
            order=24,
            sample_count=96,
            radius_fraction=0.60,
        )
        self.assertTrue(reports)
        self.assertLess(float(abs(snapshots[-1][0, 0] - acb("0.5")).mid()), 1.0e-20)

    def test_internal_singularity_warns_and_uses_frobenius_bridge(self) -> None:
        system = RationalMatrixSystem(
            ((rational_function([-2, 2], [0, -2, 1]),),),
            name="bridge-system",
        )
        with warnings.catch_warnings(record=True) as caught:
            warnings.simplefilter("always")
            path = build_adaptive_path(
                system,
                NamedPoint("left", -1),
                NamedPoint("right", 1),
                max_step_over_radius=0.35,
            )
        self.assertIsInstance(path, list)
        self.assertEqual(
            tuple(item.singularity_identifier for item in path.internal_singularities),
            ("finite_001",),
        )
        self.assertTrue(any("detour_points" in str(item.message) for item in caught))
        ratios = [
            item["step_over_convergence_radius"]
            for item in path.step_reports
            if item["step_over_convergence_radius"] is not None
        ]
        self.assertTrue(ratios)
        self.assertLessEqual(max(ratios), 0.35 + 1.0e-12)
        incoming = next(
            item
            for item in path.step_reports
            if item["side"] == "match_to_singularity"
        )
        self.assertEqual(incoming["radius_owner"], "singularity")
        self.assertAlmostEqual(float(incoming["controlling_convergence_radius"]), 2.0)

        snapshots, reports, _elapsed = transport_path(
            system,
            column_vector([3]),
            path,
            order=32,
            sample_count=96,
            radius_fraction=0.60,
        )
        self.assertTrue(any(item["method"].endswith("bridge") for item in reports))
        self.assertLess(float(abs(snapshots[-1][0, 0] + 1).mid()), 1.0e-18)

        with warnings.catch_warnings(record=True):
            warnings.simplefilter("always")
            detoured_path = build_adaptive_path(
                system,
                NamedPoint("left", -1),
                NamedPoint("right", 1),
                detour_points=(NamedPoint("upper_detour", acb(0, "1/2")),),
                max_step_over_radius=0.35,
            )
        self.assertIsInstance(detoured_path, list)
        self.assertFalse(detoured_path.internal_singularities)
        self.assertGreater(len(detoured_path), 2)
        for left, right in zip(detoured_path[:-1], detoured_path[1:]):
            convergence_radius = abs(left)
            self.assertLessEqual(
                float((abs(right - left) / convergence_radius).mid()),
                0.35 + 1.0e-12,
            )
        detoured_snapshots, _detoured_reports, _detoured_elapsed = transport_path(
            system,
            column_vector([3]),
            detoured_path,
            order=32,
            sample_count=96,
            radius_fraction=0.60,
        )
        self.assertLess(
            float(abs(detoured_snapshots[-1][0, 0] + 1).mid()), 1.0e-18
        )
        self.assertLess(
            float(abs(detoured_snapshots[-1][0, 0] - snapshots[-1][0, 0]).mid()),
            1.0e-18,
        )

    def test_log_bridge_matches_upper_half_plane_detour(self) -> None:
        scalar = rational_function([-2, 2], [0, -2, 1])
        system = RationalMatrixSystem(
            (
                (scalar, rational_function(1, [0, 1])),
                (0, scalar),
            ),
            name="jordan-log-bridge-system",
        )
        with warnings.catch_warnings(record=True):
            warnings.simplefilter("always")
            bridge_path = build_adaptive_path(
                system,
                NamedPoint("left", -1),
                NamedPoint("right", 1),
                max_step_over_radius=0.30,
            )
            detour_path = build_adaptive_path(
                system,
                NamedPoint("left", -1),
                NamedPoint("right", 1),
                detour_points=(NamedPoint("upper_detour", acb(0, "1/2")),),
                max_step_over_radius=0.30,
            )
        initial = column_vector([1, 2])
        bridge_result = transport_path(
            system,
            initial,
            bridge_path,
            order=40,
            sample_count=128,
            radius_fraction=0.60,
        )
        detour_result = transport_path(
            system,
            initial,
            detour_path,
            order=40,
            sample_count=128,
            radius_fraction=0.60,
        )
        bridge_report = next(
            item
            for item in bridge_result[1]
            if item["method"] == "regular_singular_power_log_bridge"
        )
        self.assertEqual(bridge_report["maximum_log_degree"], 1)
        for row in range(2):
            self.assertLess(
                float(
                    abs(
                        bridge_result[0][-1][row, 0]
                        - detour_result[0][-1][row, 0]
                    ).mid()
                ),
                1.0e-16,
            )

    def test_regular_singular_start_accepts_verified_abc_boundary(self) -> None:
        """标量奇点起点必须把 ``{a,b,C}`` 自动换算到首个普通匹配点。"""

        system = RationalMatrixSystem(
            ((rational_function(2, [0, 1]),),),
            name="singular-start-scalar",
        )
        with warnings.catch_warnings():
            warnings.simplefilter("ignore")
            path = build_adaptive_path(
                system,
                NamedPoint("singular_boundary", 0),
                NamedPoint("target", 1),
                max_step_over_radius=0.30,
            )
        boundary = frobenius_boundary([{"a": 2, "b": 0, "C": [3]}])
        snapshots, reports, _elapsed = transport_path(
            system,
            boundary,
            path,
            order=24,
            sample_count=96,
            radius_fraction=0.60,
        )
        self.assertEqual(reports[0]["method"], "regular_singular_boundary_initialization")
        self.assertEqual(reports[0]["boundary"]["terms"][0]["a"], "2")
        self.assertLess(float(abs(snapshots[-1][0, 0] - acb(3)).mid()), 1.0e-10)

        with self.assertRaisesRegex(ValueError, "not the indicial root"):
            transport_path(
                system,
                frobenius_boundary([{"a": 1, "b": 0, "C": [3]}]),
                path,
                order=12,
            )
        with self.assertRaisesRegex(TypeError, r"\{a,b,C\}"):
            transport_path(system, column_vector([3]), path, order=12)
        with self.assertRaisesRegex(TypeError, r"exact Q\(i\)"):
            frobenius_boundary([{"a": 2.0, "b": 0, "C": [3]}])
        with self.assertRaisesRegex(TypeError, "b must be a nonnegative integer"):
            frobenius_boundary([{"a": 2, "b": 0.0, "C": [3]}])
        with self.assertRaisesRegex(ValueError, "must not be the zero vector"):
            frobenius_boundary([{"a": 2, "b": 0, "C": [0]}])
        with self.assertRaisesRegex(ValueError, "dimension must equal"):
            transport_path(
                system,
                frobenius_boundary([{"a": 2, "b": 0, "C": [3, 0]}]),
                path,
                order=12,
            )

    def test_frobenius_batch_shares_system_and_preserves_each_column(self) -> None:
        """多个奇点初值应共享局部基和路径矩阵，同时保留逐列 refinement。"""

        system = RationalMatrixSystem(
            (
                (rational_function(1, [0, 1]), 0),
                (0, rational_function(2, [0, 1])),
            ),
            name="singular-start-batch",
        )
        with warnings.catch_warnings():
            warnings.simplefilter("ignore")
            path = build_adaptive_path(
                system,
                NamedPoint("batch_boundary", 0),
                NamedPoint("target", 1),
                max_step_over_radius=0.30,
            )
        boundaries = [
            frobenius_boundary([{"a": 1, "b": 0, "C": [1, 0]}]),
            frobenius_boundary([{"a": 2, "b": 0, "C": [0, 1]}]),
        ]
        result = transport_frobenius_boundaries_refined(
            system,
            boundaries,
            path,
            primary_order=24,
            reference_order=32,
            target_relative_error="1e-10",
        )
        final = result["reference_snapshots"][-1]
        self.assertEqual((final.nrows(), final.ncols()), (2, 2))
        self.assertLess(float(abs(final[0, 0] - acb(1)).mid()), 1.0e-10)
        self.assertLess(float(abs(final[1, 1] - acb(1)).mid()), 1.0e-10)
        self.assertLess(float(abs(final[0, 1]).mid()), 1.0e-10)
        self.assertLess(float(abs(final[1, 0]).mid()), 1.0e-10)
        self.assertEqual(result["target_relative_error_met"], [True, True])
        self.assertEqual(len(result["reference_boundary_reports"]), 2)

    def test_jordan_start_uses_highest_log_leading_vector(self) -> None:
        """Jordan 边界的最高 log 系数应恢复规范广义本征向量并自动补低次项。"""

        system = RationalMatrixSystem(
            (
                (0, rational_function(1, [0, 1])),
                (0, 0),
            ),
            name="singular-start-jordan",
        )
        with warnings.catch_warnings():
            warnings.simplefilter("ignore")
            path = build_adaptive_path(
                system,
                NamedPoint("jordan_boundary", 0),
                NamedPoint("target", 1),
                max_step_over_radius=0.30,
            )
        boundary = frobenius_boundary(
            [
                {"a": 0, "b": 1, "C": [1, 0]},
                {"a": 0, "b": 0, "C": [2, 0]},
            ]
        )
        snapshots, reports, _elapsed = transport_path(
            system,
            boundary,
            path,
            order=20,
            sample_count=80,
            radius_fraction=0.60,
        )
        self.assertEqual(reports[0]["maximum_log_degree"], 1)
        self.assertLess(float(abs(snapshots[-1][0, 0] - acb(2)).mid()), 1.0e-10)
        self.assertLess(float(abs(snapshots[-1][1, 0] - acb(1)).mid()), 1.0e-10)

    def test_multiroot_start_expands_each_exact_eigenspace(self) -> None:
        """不同 indicial roots 的领头向量必须分别投影到对应 exact 本征子空间。"""

        system = RationalMatrixSystem(
            (
                (0, 0),
                (0, rational_function(1, [0, 1])),
            ),
            name="singular-start-multiroot",
        )
        with warnings.catch_warnings():
            warnings.simplefilter("ignore")
            path = build_adaptive_path(
                system,
                NamedPoint("multiroot_boundary", 0),
                NamedPoint("target", 1),
                max_step_over_radius=0.30,
            )
        boundary = frobenius_boundary(
            [
                {"a": 0, "b": 0, "C": [2, 0]},
                {"a": 1, "b": 0, "C": [0, 3]},
            ]
        )
        snapshots, _reports, _elapsed = transport_path(
            system,
            boundary,
            path,
            order=24,
            sample_count=96,
            radius_fraction=0.60,
        )
        self.assertLess(float(abs(snapshots[-1][0, 0] - acb(2)).mid()), 1.0e-10)
        self.assertLess(float(abs(snapshots[-1][1, 0] - acb(3)).mid()), 1.0e-10)

        with self.assertRaisesRegex(ValueError, "incompatible"):
            transport_path(
                system,
                frobenius_boundary([{"a": 0, "b": 0, "C": [0, 1]}]),
                path,
                order=12,
            )

    def test_infinity_start_boundary_uses_inverted_variable_power(self) -> None:
        """无穷远边界的 ``a`` 必须按 ``sinv=1/s`` 局部变量解释。"""

        system = RationalMatrixSystem(
            ((rational_function(1, [0, 1]),),),
            variable_name="s",
            name="infinity-start-boundary",
        )
        with warnings.catch_warnings():
            warnings.simplefilter("ignore")
            path = build_adaptive_path(
                system,
                NamedPoint("infinity", "inf"),
                NamedPoint("target", 2),
                max_step_over_radius=0.30,
            )
        snapshots, reports, _elapsed = transport_path(
            system,
            frobenius_boundary([{"a": -1, "b": 0, "C": [1]}]),
            path,
            order=24,
            sample_count=96,
            radius_fraction=0.60,
        )
        self.assertEqual(reports[0]["working_variable"], "sinv")
        self.assertLess(float(abs(snapshots[-1][0, 0] - acb(2)).mid()), 1.0e-10)


if __name__ == "__main__":
    unittest.main()
