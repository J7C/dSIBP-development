"""检查路径 ``save`` 标签、即时逐点文件和奇点边界输出。"""

from __future__ import annotations

import json
import os
import tempfile
import unittest
import warnings
from pathlib import Path

from flint import acb, acb_mat

from flintnde import (
    AnalyticMatrixSystem,
    NamedPoint,
    RationalMatrixSystem,
    build_adaptive_path,
    column_vector,
    frobenius_boundary,
    rational_function,
    transport_path,
    transport_path_refined,
)


class SavePointTests(unittest.TestCase):
    """逐项验证 ordinary、奇点起点和奇点终点合同。"""

    def test_raw_path_save_tags_write_reference_results_in_cwd(self) -> None:
        system = AnalyticMatrixSystem(
            lambda _point: acb_mat([[0]]),
            1,
            singularities=(acb(10),),
            name="constant-save-system",
        )
        with tempfile.TemporaryDirectory() as directory:
            previous = Path.cwd()
            os.chdir(directory)
            try:
                result = transport_path_refined(
                    system,
                    column_vector([7]),
                    [(acb(0), "save"), acb(1), (acb(2), "save")],
                    primary_order=8,
                    reference_order=12,
                )
            finally:
                os.chdir(previous)
            root = Path(directory)
            point_files = sorted(root.glob("flintnde_save_[0-9][0-9][0-9].json"))
            self.assertEqual(len(point_files), 2)
            summary = json.loads((root / "flintnde_save_points.json").read_text(encoding="utf-8"))
            self.assertEqual(summary["pointCount"], 2)
            self.assertEqual([item["sequence"] for item in summary["points"]], [1, 2])
            self.assertTrue(all(item["resultType"] == "ordinary_vector" for item in summary["points"]))
            self.assertEqual(result["reference_snapshots"][-1][0, 0], acb(7))

    def test_completed_point_survives_later_transport_failure_without_summary(self) -> None:
        system = AnalyticMatrixSystem(
            lambda _point: acb_mat([[0]]),
            1,
            singularities=(acb(1),),
            name="interrupted-save-system",
        )
        with tempfile.TemporaryDirectory() as directory:
            with self.assertRaises(ValueError):
                transport_path(
                    system,
                    column_vector([1]),
                    [(acb(0), "save"), acb("3/4")],
                    order=8,
                    save_output_directory=directory,
                )
            root = Path(directory)
            self.assertEqual(len(list(root.glob("flintnde_save_[0-9][0-9][0-9].json"))), 1)
            self.assertFalse((root / "flintnde_save_points.json").exists())

    def test_singular_start_save_echoes_verified_abc_boundary(self) -> None:
        system = RationalMatrixSystem(
            ((rational_function(2, [0, 1]),),),
            name="singular-start-save-system",
        )
        with warnings.catch_warnings():
            warnings.simplefilter("ignore")
            path = build_adaptive_path(
                system,
                (0, "save"),
                1,
                max_step_over_radius=0.30,
            )
        boundary = frobenius_boundary([{"a": 2, "b": 0, "C": [3]}])
        with tempfile.TemporaryDirectory() as directory:
            transport_path(
                system,
                boundary,
                path,
                order=20,
                sample_count=80,
                save_output_directory=directory,
            )
            record = json.loads(
                next(Path(directory).glob("flintnde_save_[0-9][0-9][0-9].json")).read_text(encoding="utf-8")
            )
        self.assertEqual(record["resultType"], "frobenius_boundary")
        self.assertEqual(record["result"]["terms"], [{"a": "2", "b": 0, "C": ["3"]}])

    def test_singular_target_save_recovers_reusable_abc_boundary(self) -> None:
        system = RationalMatrixSystem(
            ((rational_function(2, [0, 1]),),),
            name="singular-target-save-system",
        )
        with warnings.catch_warnings():
            warnings.simplefilter("ignore")
            path = build_adaptive_path(
                system,
                1,
                (0, "save"),
                max_step_over_radius=0.30,
            )
        with tempfile.TemporaryDirectory() as directory:
            transport_path(
                system,
                column_vector([3]),
                path,
                order=20,
                sample_count=80,
                save_output_directory=directory,
            )
            record = json.loads(
                next(Path(directory).glob("flintnde_save_[0-9][0-9][0-9].json")).read_text(encoding="utf-8")
            )
        term = record["result"]["terms"][0]
        self.assertEqual((term["a"], term["b"]), ("2", 0))
        self.assertLess(abs(float(term["C"][0]["real"]) - 3.0), 1.0e-10)
        self.assertLess(abs(float(term["C"][0]["imag"])), 1.0e-10)


if __name__ == "__main__":
    unittest.main()
