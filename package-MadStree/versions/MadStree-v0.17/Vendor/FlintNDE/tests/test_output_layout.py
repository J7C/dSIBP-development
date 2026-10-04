"""检查 FlintNDE 输出目录始终锚定调用脚本并按固定用途分类。"""

from __future__ import annotations

import json
import tempfile
import unittest
from pathlib import Path

from flintnde import initialize_output_layout


class OutputLayoutTest(unittest.TestCase):
    """验证缺省命名、安全路径和 JSON 写入接口。"""

    def test_default_layout_is_parallel_to_caller_script(self) -> None:
        with tempfile.TemporaryDirectory() as temporary_directory:
            caller_script = Path(temporary_directory) / "solve_example.py"
            caller_script.write_text("# test caller\n", encoding="utf-8")
            layout = initialize_output_layout(caller_script)
            expected_root = caller_script.parent / "results" / "solve_example"
            self.assertEqual(layout.run_root, expected_root)
            manifest_path = expected_root / "configuration" / "output_layout.json"
            manifest = json.loads(manifest_path.read_text(encoding="utf-8"))
            self.assertEqual(manifest["caller_script"], "solve_example.py")
            self.assertEqual(manifest["schema"], "flintnde_output_layout_v1")
            self.assertEqual(
                manifest["results_directory"],
                str(Path("results") / "solve_example"),
            )

    def test_custom_run_name_and_category_json(self) -> None:
        with tempfile.TemporaryDirectory() as temporary_directory:
            caller_script = Path(temporary_directory) / "solve_example.py"
            caller_script.write_text("# test caller\n", encoding="utf-8")
            layout = initialize_output_layout(caller_script, run_name="physical_point_01")
            target = layout.write_json("summary", "result_summary.json", {"status": "passed"})
            self.assertEqual(
                target,
                caller_script.parent
                / "results"
                / "physical_point_01"
                / "summary"
                / "result_summary.json",
            )
            self.assertEqual(json.loads(target.read_text(encoding="utf-8"))["status"], "passed")

    def test_layout_rejects_unplanned_paths(self) -> None:
        with tempfile.TemporaryDirectory() as temporary_directory:
            caller_script = Path(temporary_directory) / "solve_example.py"
            caller_script.write_text("# test caller\n", encoding="utf-8")
            layout = initialize_output_layout(caller_script)
            with self.assertRaisesRegex(ValueError, "unknown output category"):
                layout.file("misc", "value.json")
            with self.assertRaisesRegex(ValueError, "one nonempty path name"):
                layout.file("summary", "nested/value.json")
            with self.assertRaisesRegex(ValueError, "one nonempty path name"):
                initialize_output_layout(caller_script, run_name="../outside")


if __name__ == "__main__":
    unittest.main()
