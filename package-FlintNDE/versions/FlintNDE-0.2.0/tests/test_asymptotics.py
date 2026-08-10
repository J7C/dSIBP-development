"""公开形式渐近尾项诊断的严格阈值与失败边界测试。"""

from __future__ import annotations

import unittest

from flint import acb, arb

from flintnde import FiveTermTailDiagnostic, five_term_tail_diagnostic


class FiveTermTailDiagnosticTests(unittest.TestCase):
    """验证下游 Wronskian producer 所需的可读取标量门禁。"""

    @staticmethod
    def _terms(previous: list[str], following: list[str]) -> list[acb]:
        """构造 N=4 时恰好覆盖前五项和后五项的测试输入。"""

        return [acb(value) for value in previous + following]

    def test_public_result_exposes_gate_variables(self) -> None:
        diagnostic = five_term_tail_diagnostic(
            self._terms(["1"] * 5, ["1/10", "-1/10", "0", "0", "0"]),
            4,
        )
        self.assertIsInstance(diagnostic, FiveTermTailDiagnostic)
        self.assertTrue(diagnostic.passed)
        self.assertTrue(diagnostic.next_five_sum_absolute.contains(0))
        self.assertTrue((diagnostic.previous_five_absolute_sum - 5).contains(0))
        self.assertEqual(
            diagnostic.as_dict()["definition"],
            "abs(sum(T[N+1:N+6]))/sum(abs(T[N-4:N+1]))",
        )

    def test_ratio_above_threshold_fails(self) -> None:
        diagnostic = five_term_tail_diagnostic(
            self._terms(["1"] * 5, ["1", "0", "0", "0", "0"]),
            4,
        )
        self.assertFalse(diagnostic.passed)
        self.assertTrue((diagnostic.next_over_previous - arb("1/5")).contains(0))

    def test_threshold_equality_is_not_a_pass(self) -> None:
        diagnostic = five_term_tail_diagnostic(
            self._terms(["2"] * 5, ["1", "0", "0", "0", "0"]),
            4,
            threshold="0.1",
        )
        self.assertFalse(diagnostic.passed)
        self.assertTrue((diagnostic.next_over_previous - arb("1/10")).contains(0))

    def test_zero_previous_block_fails_closed(self) -> None:
        with self.assertRaisesRegex(ZeroDivisionError, "contains zero"):
            five_term_tail_diagnostic(
                self._terms(["0"] * 5, ["1", "0", "0", "0", "0"]),
                4,
            )

    def test_missing_lookahead_terms_is_rejected(self) -> None:
        with self.assertRaisesRegex(ValueError, "terms through degree 9"):
            five_term_tail_diagnostic([acb(1)] * 9, 4)


if __name__ == "__main__":
    unittest.main()
