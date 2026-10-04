"""FlintNDE unittest 共享的最小测试工具。

集中保存点文件读取、临时目录与精度初始化样板，避免多个测试文件
重复 ``glob``/``json.loads``/``configure_working_precision`` 代码。
"""

from __future__ import annotations

import json
from pathlib import Path
from typing import Any

from flintnde import configure_working_precision


def set_precision(decimal_digits: int, guard_bits: int = 32) -> int:
    """设置 Acb 工作精度并返回实际位数，供测试用例初始化。"""

    return configure_working_precision(decimal_digits, guard_bits)


def save_point_files(directory: Path) -> list[Path]:
    """返回目录中已完成的即时保存点文件（按名称排序）。"""

    return sorted(directory.glob("flintnde_save_[0-9][0-9][0-9].json"))


def read_first_save_record(directory: Path) -> dict[str, Any]:
    """读取目录中第一个保存点 JSON 记录。"""

    target = next(directory.glob("flintnde_save_[0-9][0-9][0-9].json"))
    return json.loads(target.read_text(encoding="utf-8"))


def read_save_summary(directory: Path) -> dict[str, Any]:
    """读取完整保存点汇总 JSON。"""

    target = directory / "flintnde_save_points.json"
    return json.loads(target.read_text(encoding="utf-8"))
