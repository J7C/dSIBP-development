"""FlintNDE 仓库 check 脚本共享的只读辅助函数。

两个 ``check_01_nde_*`` 脚本与 ``test/`` 中的专项脚本共用 JSON 读取、模块加载、
SHA-256 摘要与 Acb 序列化，避免多份逐字复制漂移。本模块不属于 flintnde package
公开接口，只供仓库内脚本使用。
"""

from __future__ import annotations

import hashlib
import importlib.util
import json
from pathlib import Path
from types import ModuleType
from typing import Any

from flint import acb, acb_mat, arb


def load_json(path: Path) -> dict[str, Any]:
    """读取必需 JSON 对象，输入不完整时 fail closed。"""

    payload = json.loads(path.read_text(encoding="utf-8-sig"))
    if not isinstance(payload, dict):
        raise TypeError(f"JSON root must be an object: {path}")
    return payload


def load_module(path: Path, name: str) -> ModuleType:
    """按绝对路径加载脚本，确保检查调用当前工作树实现。"""

    specification = importlib.util.spec_from_file_location(name, path)
    if specification is None or specification.loader is None:
        raise ImportError(f"cannot load module from {path}")
    module = importlib.util.module_from_spec(specification)
    specification.loader.exec_module(module)
    return module


def sha256_file(path: Path) -> str:
    """返回输入文件的 SHA-256，固定正式检查的数据来源。"""

    digest = hashlib.sha256()
    with path.open("rb") as stream:
        for block in iter(lambda: stream.read(1024 * 1024), b""):
            digest.update(block)
    return digest.hexdigest()


def acb_record(record: dict[str, Any]) -> acb:
    """把 ``{re,im}`` 文本记录恢复为 Acb 数。"""

    return acb(str(record["re"]), str(record["im"]))


def exact_record(record: dict[str, Any]) -> dict[str, str]:
    """把十进制 ``{re,im}`` 作为 exact Q(i) 输入，不经过浮点对象。"""

    return {"real": str(record["re"]), "imag": str(record["im"])}


def value_record(value: acb, digits: int = 35) -> dict[str, str]:
    """保存 Acb 中点和 ball，避免结果退回 binary64。"""

    return {
        "re": value.real.str(digits, radius=False),
        "im": value.imag.str(digits, radius=False),
        "re_ball": value.real.str(digits),
        "im_ball": value.imag.str(digits),
    }


def vector_records(vector: acb_mat, digits: int = 35) -> list[dict[str, str]]:
    """保存完整端点向量的中点与 Acb ball。"""

    if vector.ncols() != 1:
        raise ValueError("vector_records requires a column vector")
    return [value_record(vector[row, 0], digits) for row in range(vector.nrows())]


def relative_difference(left: acb, right: acb) -> arb:
    """按参考值尺度计算相对差；参考值必须严格非零。"""

    scale = abs(right)
    if scale.contains(0):
        raise ZeroDivisionError("reference value contains zero")
    return abs(left - right) / scale
