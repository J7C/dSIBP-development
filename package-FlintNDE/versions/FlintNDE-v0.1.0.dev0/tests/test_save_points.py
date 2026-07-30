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
    exponential_boundary,
    frobenius_boundary,
    rational_function,
    transport_path,
    transport_path_refined,
)


class SavePointTests(unittest.TestCase):
    """逐项验证 ordinary、正则奇点和指数型奇点的保存合同。"""

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

    def test_exponential_start_save_round_trips_phi_a_b_c(self) -> None:
        """本性奇点起点应保存并重新接受完整 ``{phi,a,b,C}``。"""

        system = RationalMatrixSystem(
            ((rational_function(1, [0, 0, 1]),),),
            name="exponential-start-save-system",
        )
        boundary = exponential_boundary(
            [{"phi": [{"power": -1, "coefficient": -1}], "a": 0, "b": 0, "C": [3]}]
        )
        with warnings.catch_warnings():
            warnings.simplefilter("ignore")
            path = build_adaptive_path(system, (0, "save"), 1, max_step_over_radius=0.25)
        with tempfile.TemporaryDirectory() as directory:
            result = transport_path(
                system, boundary, path, order=32, sample_count=96, save_output_directory=directory
            )
            record = json.loads(
                next(Path(directory).glob("flintnde_save_[0-9][0-9][0-9].json")).read_text(
                    encoding="utf-8"
                )
            )
        self.assertEqual(record["resultType"], "exponential_boundary")
        self.assertEqual(
            record["result"]["terms"][0]["phi"],
            [{"power": -1, "coefficient": "-1"}],
        )
        reused = exponential_boundary(record["result"]["terms"])
        self.assertEqual(reused.to_json()[0]["C"], ["3"])
        self.assertLess(float(abs(result[0][-1][0, 0] - 3 * (-acb(1)).exp()).mid()), 1.0e-12)

    def test_exponential_target_save_is_reusable(self) -> None:
        """可桥接指数型终点应从入射匹配值反解原基边界并可再次输运。"""

        system = RationalMatrixSystem(
            ((rational_function(1, [0, 0, 1]),),),
            name="exponential-target-save-system",
        )
        with warnings.catch_warnings():
            warnings.simplefilter("ignore")
            target_path = build_adaptive_path(system, 1, (0, "save"), max_step_over_radius=0.25)
        with tempfile.TemporaryDirectory() as directory:
            transport_path(
                system,
                column_vector([(-acb(1)).exp()]),
                target_path,
                order=36,
                sample_count=112,
                save_output_directory=directory,
            )
            record = json.loads(
                next(Path(directory).glob("flintnde_save_[0-9][0-9][0-9].json")).read_text(
                    encoding="utf-8"
                )
            )
        self.assertEqual(record["resultType"], "exponential_boundary")
        reused = exponential_boundary(record["result"]["terms"])
        with warnings.catch_warnings():
            warnings.simplefilter("ignore")
            return_path = build_adaptive_path(system, 0, 1, max_step_over_radius=0.25)
        result = transport_path(system, reused, return_path, order=36, sample_count=112)
        self.assertLess(float(abs(result[0][-1][0, 0] - (-acb(1)).exp()).mid()), 1.0e-11)

    def test_exponential_internal_save_writes_boundary_at_bridge(self) -> None:
        """带 ``save`` 的中间本性奇点应在 bridge 常数反解后立即落盘。"""

        system = RationalMatrixSystem(
            ((rational_function(1, [0, 0, 1]),),),
            name="exponential-internal-save-system",
        )
        with warnings.catch_warnings():
            warnings.simplefilter("ignore")
            path = build_adaptive_path(
                system,
                -1,
                1,
                detour_points=((0, "save"),),
                max_step_over_radius=0.25,
            )
        with tempfile.TemporaryDirectory() as directory:
            result = transport_path(
                system,
                column_vector([1]),
                path,
                order=40,
                sample_count=128,
                save_output_directory=directory,
            )
            record = json.loads(
                next(Path(directory).glob("flintnde_save_[0-9][0-9][0-9].json")).read_text(
                    encoding="utf-8"
                )
            )
        self.assertEqual((record["role"], record["resultType"]), ("detour", "exponential_boundary"))
        self.assertEqual(record["result"]["localBasisMethod"], "exponential_power_log")
        exponential_boundary(record["result"]["terms"])
        self.assertLess(float(abs(result[0][-1][0, 0] - (-acb(2)).exp()).mid()), 1.0e-11)

    def test_formal_exponential_start_can_be_saved_but_not_continued(self) -> None:
        """start-only 形式渐近边界可保存，能力字段必须明确禁止 continuation。"""

        denominator = [0, 0, 1]
        system = RationalMatrixSystem(
            (
                (rational_function(1, denominator), 1),
                (0, rational_function(-1, denominator)),
            ),
            name="formal-exponential-start-save-system",
        )
        with warnings.catch_warnings():
            warnings.simplefilter("ignore")
            path = build_adaptive_path(system, (0, "save"), "1/20", max_step_over_radius=0.25)
        boundary = frobenius_boundary([{"a": 0, "b": 0, "C": [0, 1]}])
        with tempfile.TemporaryDirectory() as directory:
            transport_path(
                system, boundary, path, order=24, sample_count=80, save_output_directory=directory
            )
            record = json.loads(
                next(Path(directory).glob("flintnde_save_[0-9][0-9][0-9].json")).read_text(
                    encoding="utf-8"
                )
            )
        self.assertEqual(record["resultType"], "exponential_boundary")
        self.assertEqual(record["result"]["localBasisMethod"], "formal_exponential_asymptotic")
        self.assertFalse(record["result"]["continuationReady"])
        exponential_boundary(record["result"]["terms"])

    def test_exponential_boundary_rejects_wrong_phi_signature(self) -> None:
        """用户给出的指数若与 exact Laurent sector 不同，必须在输运前拒绝。"""

        system = RationalMatrixSystem(
            ((rational_function(1, [0, 0, 1]),),),
            name="wrong-exponential-signature-system",
        )
        boundary = exponential_boundary(
            [{"phi": [{"power": -1, "coefficient": -2}], "a": 0, "b": 0, "C": [1]}]
        )
        with warnings.catch_warnings():
            warnings.simplefilter("ignore")
            path = build_adaptive_path(system, 0, 1, max_step_over_radius=0.25)
        with self.assertRaisesRegex(ValueError, "phi does not match inferred sector"):
            transport_path(system, boundary, path, order=24, sample_count=80)

    def test_zero_phi_sector_is_saved_inside_high_pole_system(self) -> None:
        """高阶-pole 系统中的 ``phi=0`` sector 必须能与其它指数 sector 共用格式。"""

        inverse_square = rational_function(1, [0, 0, 1])
        system = RationalMatrixSystem(
            ((0, 0), (0, inverse_square)),
            name="zero-phi-sector-save-system",
        )
        boundary = exponential_boundary(
            [{"phi": [], "a": 0, "b": 0, "C": [1, 0]}]
        )
        with warnings.catch_warnings():
            warnings.simplefilter("ignore")
            path = build_adaptive_path(system, (0, "save"), 1, max_step_over_radius=0.25)
        with tempfile.TemporaryDirectory() as directory:
            result = transport_path(
                system, boundary, path, order=24, sample_count=80, save_output_directory=directory
            )
            record = json.loads(
                next(Path(directory).glob("flintnde_save_[0-9][0-9][0-9].json")).read_text(
                    encoding="utf-8"
                )
            )
        self.assertEqual(record["resultType"], "exponential_boundary")
        self.assertEqual(record["result"]["terms"][0]["phi"], [])
        exponential_boundary(record["result"]["terms"])
        self.assertLess(float(abs(result[0][-1][0, 0] - 1).mid()), 1.0e-12)


if __name__ == "__main__":
    unittest.main()
