"""检查有限奇点目标的分类、文本输出与局部收敛域门禁。"""

import unittest

from flint import acb, acb_mat

from flintnde import (
    RationalMatrixSystem,
    evaluate_singular_target,
    gaussian_rational,
    plan_singular_target_match,
    rational_function,
)


class SingularTargetTests(unittest.TestCase):
    def test_removable_component_returns_numeric_value(self):
        system = RationalMatrixSystem(
            (
                (rational_function(1, [0, 1]), 0),
                (0, 0),
            ),
            variable_name="z",
        )
        result = evaluate_singular_target(system, 1, acb_mat([[1], [2]]), 0)
        self.assertEqual(result.classification, "removable_singularity")
        self.assertEqual(result.component_classifications, ("removable_singularity", "removable_singularity"))
        self.assertNotIsInstance(result.values[0], str)

    def test_shifted_complex_target_with_other_letter_classifies_each_component(self):
        """非零复奇点和其它 finite letter 共存时仍只按局部解分类。"""

        target_term = rational_function(1, [(-2, -1), 1])
        spectator_term = rational_function(1, [(-5, -1), 1])
        system = RationalMatrixSystem(
            (
                (target_term + spectator_term, 0),
                (0, -target_term + spectator_term),
            ),
            variable_name="w",
        )
        result = evaluate_singular_target(
            system,
            acb("5/2", 1),
            acb_mat([[1], [1]]),
            gaussian_rational((2, 1)),
        )
        self.assertEqual(
            result.component_classifications,
            ("removable_singularity", "true_pole"),
        )
        self.assertEqual(result.classification, "true_pole")
        self.assertNotIsInstance(result.values[0], str)
        self.assertEqual(result.values[1], "Infinity")
        self.assertIsNotNone(result.report["convergenceRadius"])

    def test_true_pole_returns_infinity_text(self):
        system = RationalMatrixSystem(
            ((rational_function(-1, [0, 1]), 0), (0, 0)),
            variable_name="z",
        )
        result = evaluate_singular_target(system, 1, acb_mat([[1], [2]]), 0)
        self.assertEqual(result.component_classifications[0], "true_pole")
        self.assertEqual(result.values[0], "Infinity")

    def test_zero_order_log_returns_infinity_text_and_log_classification(self):
        system = RationalMatrixSystem(
            ((0, rational_function(1, [0, 1])), (0, 0)),
            variable_name="z",
        )
        result = evaluate_singular_target(system, 1, acb_mat([[1], [1]]), 0)
        self.assertEqual(result.classification, "log_divergent_singularity")
        self.assertEqual(result.values[0], "Infinity")

    def test_sampling_scale_tracks_nearest_other_singularity(self):
        """分类样本必须落在目标奇点到最近其它奇点的收敛圆盘内。"""

        system = RationalMatrixSystem(
            ((
                rational_function(-1, [0, 1])
                + rational_function(1, ["-1/1000000", 1]),
            ),),
            variable_name="z",
        )
        result = evaluate_singular_target(
            system,
            "1/2000000",
            acb_mat([[1]]),
            0,
        )
        self.assertEqual(result.classification, "true_pole")
        self.assertIsNotNone(result.report["convergenceRadius"])
        self.assertIsNotNone(result.report["sampleScale"])
        with self.assertRaisesRegex(ValueError, "outside.*convergence disk"):
            evaluate_singular_target(system, "1/500000", acb_mat([[1]]), 0)

    def test_terminal_match_plan_inserts_point_inside_target_convergence_disk(self):
        """域外来点必须按目标奇点的最近其它奇点距离插入隐藏匹配点。"""

        system = RationalMatrixSystem(
            ((
                rational_function(-1, [-1, 1])
                + rational_function(1, ["-11/10", 1]),
            ),),
            variable_name="z",
        )
        plan = plan_singular_target_match(system, 0, 1)
        self.assertTrue(plan.inserted)
        self.assertIsNotNone(plan.convergence_radius)
        self.assertTrue(abs(plan.match_point - acb(1)) < plan.convergence_radius)
        self.assertTrue(abs(plan.match_point - acb("39/40")).contains(0))

    def test_terminal_match_plan_reuses_in_disk_point(self):
        """已在保守局部圆内的普通点不应制造重复输运节点。"""

        system = RationalMatrixSystem(
            ((
                rational_function(-1, [-1, 1])
                + rational_function(1, ["-11/10", 1]),
            ),),
            variable_name="z",
        )
        plan = plan_singular_target_match(system, "99/100", 1)
        self.assertFalse(plan.inserted)
        self.assertTrue(abs(plan.match_point - acb("99/100")).contains(0))


if __name__ == "__main__":
    unittest.main()
