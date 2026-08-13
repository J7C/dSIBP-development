"""锁定 FlintNDE 各 Acb 序列化器的字段合同。

不同 serializer 的字段差异是有意的数据合同（保存点需要独立球径、numeric
manifest 不需要 ball、regular-point 结果需要 abs 汇总）。本测试把这些合同
固定下来：字段漂移会立即失败，但不要求把它们统一成单一 schema。
"""

from __future__ import annotations

import unittest

from flint import acb, acb_mat

from flintnde import savepoints
import flintnde.numeric_structure
import flintnde.regular_point_de as regular_de


class SerializerContractTests(unittest.TestCase):
    """逐项锁定各 Acb JSON serializer 的必需字段。"""

    def test_savepoints_acb_record_has_midpoint_and_radius_fields(self) -> None:
        record = savepoints.acb_record(acb("3/2", "-5/4"), 20)
        self.assertEqual(
            set(record),
            {"real", "imag", "realRadius", "imagRadius"},
        )

    def test_savepoints_acb_exact_input_record_has_midpoint_only(self) -> None:
        record = savepoints.acb_exact_input_record(acb("3/2", "-5/4"), 20)
        self.assertEqual(set(record), {"real", "imag"})

    def test_numeric_structure_manifest_record_has_midpoint_only(self) -> None:
        record = flintnde.numeric_structure._acb_record(acb("3/2", "-5/4"))
        self.assertEqual(set(record), {"real", "imag"})

    def test_regular_point_acb_record_has_ball_fields(self) -> None:
        record = regular_de.acb_record(acb("3/2", "-5/4"), 20)
        self.assertEqual(set(record), {"re_ball", "im_ball", "abs_ball"})

    def test_regular_point_acb_value_record_has_midpoint_and_ball(self) -> None:
        record = regular_de.acb_value_record(acb("3/2", "-5/4"), 20)
        self.assertEqual(set(record), {"re", "im", "abs", "re_ball", "im_ball"})

    def test_regular_point_vector_value_records_require_column(self) -> None:
        vector = acb_mat([[acb(1)], [acb(2)]])
        records = regular_de.vector_value_records(vector, 20)
        self.assertEqual(len(records), 2)
        self.assertEqual(set(records[0]), {"re", "im", "abs", "re_ball", "im_ball"})
        with self.assertRaises(ValueError):
            regular_de.vector_value_records(acb_mat([[acb(1), acb(2)]]), 20)

    def test_arb_record_is_radius_including_string(self) -> None:
        text = regular_de.arb_record(regular_de.vector_norm_inf(acb_mat([[acb(3)]])), 10)
        self.assertIsInstance(text, str)
        self.assertTrue(text)


if __name__ == "__main__":
    unittest.main()
