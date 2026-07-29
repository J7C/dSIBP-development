"""把显式标记的路径点结果即时写入调用目录。

逐点文件是中断可恢复的计算记录；汇总文件只在整条输运链完成后写入。默认输出根是
调用 Python 进程的当前工作目录，绝不由本模块回退到 FlintNDE 源码或安装目录。
"""

from __future__ import annotations

import json
import math
from dataclasses import dataclass, field
from pathlib import Path
from typing import Any

from flint import acb, acb_mat

from .exact_gaussian import GaussianMatrix, gaussian_rational


def acb_record(value: acb, digits: int) -> dict[str, str]:
    """保留 Acb 中点和误差球，不经过 binary64。"""

    return {
        "real": value.real.mid().str(digits, radius=False, more=True),
        "imag": value.imag.mid().str(digits, radius=False, more=True),
        "realRadius": value.real.rad().str(digits),
        "imagRadius": value.imag.rad().str(digits),
    }


def acb_exact_input_record(value: acb, digits: int) -> dict[str, str]:
    """返回可直接作为下一次 ``C`` 分量使用的十进制 Q(i) 中点记录。"""

    return {
        "real": value.real.mid().str(digits, radius=False, more=True),
        "imag": value.imag.mid().str(digits, radius=False, more=True),
    }


def vector_record(vector: acb_mat, digits: int) -> list[dict[str, str]]:
    """序列化列向量并验证形状。"""

    if vector.ncols() != 1:
        raise ValueError("saved ordinary result must be a column vector")
    return [acb_record(vector[row, 0], digits) for row in range(vector.nrows())]


def _acb_column_zero(vector: acb_mat) -> bool:
    """按 Acb 包含零语义判断数值列是否可认证为零。"""

    return all(vector[row, 0].contains(0) for row in range(vector.nrows()))


def _canonical_range_preimage(matrix: GaussianMatrix, right: acb_mat) -> acb_mat:
    """对 ``matrix.x=right`` 使用与 exact 边界解析相同的自由变量为零特解。"""

    _reduced, _rank, pivot_columns = matrix.rref()
    if not pivot_columns:
        if _acb_column_zero(right):
            return acb_mat(matrix.ncols, 1)
        raise ValueError("numeric Frobenius coefficient is outside the nilpotent range")
    basis = GaussianMatrix.from_records(
        [
            [matrix.scalar(row, column) for column in pivot_columns]
            for row in range(matrix.nrows)
        ]
    )
    transposed = GaussianMatrix.from_records(
        [
            [basis.scalar(row, column) for row in range(basis.nrows)]
            for column in range(basis.ncols)
        ]
    )
    _row_reduced, _row_rank, pivot_rows = transposed.rref()
    selected_rows = tuple(pivot_rows[: len(pivot_columns)])
    square = GaussianMatrix.from_records(
        [
            [basis.scalar(row, column) for column in range(basis.ncols)]
            for row in selected_rows
        ]
    )
    selected_right = acb_mat([[right[row, 0]] for row in selected_rows])
    coefficients = square.inverse().to_acb() * selected_right
    result = acb_mat(matrix.ncols, 1)
    for local_index, column in enumerate(pivot_columns):
        result[column, 0] = coefficients[local_index, 0]
    return result


def frobenius_terms_from_constants(
    local_basis: Any,
    constants: acb_mat,
    digits: int,
) -> list[dict[str, Any]]:
    """把 regular-singular canonical 常数恢复为可再次输入的 ``{a,b,C}`` 项。

    当前只认证未作 Lee--Moser gauge 变换的 exact Q(i) Frobenius 基。高阶不规则基和
    已变换原基需要额外 jet 反演，不能用一个普通点数值冒充奇点边界。
    """

    if local_basis.method != "regular_singular_power_log":
        raise NotImplementedError(
            "saved singular output currently requires a direct regular-singular power-log basis"
        )
    manifest = local_basis.manifest["frobenius"]
    route = manifest.get("route")
    terms: list[dict[str, Any]] = []
    if route == "diagonalizable_roots_exact_gate":
        roots = [gaussian_rational(value) for value in manifest["solution_roots_exact"]]
        initial = [
            acb_mat([[gaussian_rational(value).to_acb()] for value in vector])
            for vector in manifest["initial_vectors_exact"]
        ]
        for root in dict.fromkeys(roots):
            coefficient = acb_mat(local_basis.dimension, 1)
            for index, candidate_root in enumerate(roots):
                if candidate_root == root:
                    coefficient += initial[index] * constants[index, 0]
            if not _acb_column_zero(coefficient):
                terms.append(
                    {
                        "a": str(root),
                        "b": 0,
                        "C": [
                            acb_exact_input_record(coefficient[row, 0], digits)
                            for row in range(local_basis.dimension)
                        ],
                        "CBalls": [
                            acb_record(coefficient[row, 0], digits)
                            for row in range(local_basis.dimension)
                        ],
                    }
                )
        return terms
    if route != "single_root_jordan_exact_gate":
        raise NotImplementedError(f"unsupported saved Frobenius route: {route}")

    nilpotent = GaussianMatrix.from_records(manifest["nilpotent_exact"])
    remaining = acb_mat(constants)
    for log_degree in range(int(manifest["maximum_log_degree"]), -1, -1):
        power = nilpotent ** log_degree
        coefficient = power.to_acb() * remaining / acb(math.factorial(log_degree))
        if _acb_column_zero(coefficient):
            continue
        terms.append(
            {
                "a": str(gaussian_rational(manifest["root_exact"])),
                "b": log_degree,
                "C": [
                    acb_exact_input_record(coefficient[row, 0], digits)
                    for row in range(local_basis.dimension)
                ],
                "CBalls": [
                    acb_record(coefficient[row, 0], digits)
                    for row in range(local_basis.dimension)
                ],
            }
        )
        preimage = _canonical_range_preimage(
            power,
            coefficient * acb(math.factorial(log_degree)),
        )
        remaining -= preimage
    if not _acb_column_zero(remaining):
        raise ArithmeticError("saved Jordan boundary decomposition left nonzero constants")
    return terms


@dataclass
class SavePointWriter:
    """管理一次输运的即时逐点文件和最终有序汇总。"""

    output_directory: Path
    summary_filename: str = "flintnde_save_points.json"
    digits: int = 40
    records: list[dict[str, Any]] = field(default_factory=list)

    def __post_init__(self) -> None:
        """冻结输出根并拒绝跨目录汇总文件名。"""

        self.output_directory = Path(self.output_directory).resolve()
        summary = Path(self.summary_filename)
        if summary.is_absolute() or summary.name != self.summary_filename:
            raise ValueError("save summary filename must be one path name")
        self.output_directory.mkdir(parents=True, exist_ok=True)

    def write(self, request: dict[str, Any], payload: dict[str, Any]) -> Path:
        """完成一个标记点后立即写文件，并把同一记录加入内存汇总。"""

        sequence = len(self.records) + 1
        record = {
            "schema": "flintnde_saved_point_v1",
            "sequence": sequence,
            "coordinate": request["coordinate"],
            "workingCoordinate": request.get("working_coordinate", request["coordinate"]),
            "classification": request["classification"],
            "singularityIdentifier": request.get("singularity_identifier"),
            "role": request.get("role", "path"),
            **payload,
        }
        filename = f"flintnde_save_{sequence:03d}.json"
        target = self.output_directory / filename
        target.write_text(
            json.dumps(record, ensure_ascii=False, indent=2) + "\n",
            encoding="utf-8",
        )
        record["file"] = filename
        self.records.append(record)
        return target

    def finalize(self) -> Path:
        """整条链完成后写一次汇总；逐点文件此前已经存在。"""

        target = self.output_directory / self.summary_filename
        target.write_text(
            json.dumps(
                {
                    "schema": "flintnde_saved_points_v1",
                    "status": "complete",
                    "pointCount": len(self.records),
                    "points": self.records,
                },
                ensure_ascii=False,
                indent=2,
            )
            + "\n",
            encoding="utf-8",
        )
        return target
