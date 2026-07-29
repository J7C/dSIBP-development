"""奇点起点的 power-log 边界输入、精确验证与基常数恢复。

用户以 ``{a,b,C}`` 记录 ``z**a log(z)**b C`` 的最高 log 领头项；``a`` 和
``C`` 必须属于 Q(i)，``b`` 为非负整数。正则奇点直接根据 exact Frobenius manifest
验证 indicial root、log 次数和向量相容性；高阶 pole 则由局部调度器先完成 shearing
或指数 sector 分解，再复用本协议验证各 sector 的 power-log 部分。
"""

from __future__ import annotations

import math
from collections.abc import Iterable, Mapping, Sequence
from dataclasses import dataclass
from typing import Any

from .exact_gaussian import GaussianMatrix, GaussianRational, gaussian_rational
from .frobenius import RegularSingularSystem


@dataclass(frozen=True)
class FrobeniusBoundaryTerm:
    """保存一个经过 exact 解析的 ``z**a log(z)**b C`` 领头项。"""

    a: GaussianRational
    b: int
    C: tuple[GaussianRational, ...]

    def __post_init__(self) -> None:
        """即使用户直接构造 dataclass，也执行与工厂相同的 exact 门禁。"""

        if isinstance(self.b, bool) or not isinstance(self.b, int) or self.b < 0:
            raise TypeError("Frobenius boundary b must be a nonnegative integer")
        if not isinstance(self.C, (list, tuple)) or not self.C:
            raise TypeError("Frobenius boundary C must be a nonempty vector")
        power = gaussian_rational(self.a)
        vector = tuple(gaussian_rational(value) for value in self.C)
        if all(value.is_zero for value in vector):
            raise ValueError("Frobenius boundary C must not be the zero vector")
        object.__setattr__(self, "a", power)
        object.__setattr__(self, "C", vector)

    def to_json(self) -> dict[str, Any]:
        """返回不损失 Q(i) 精度的用户边界记录。"""

        return {"a": str(self.a), "b": self.b, "C": [str(value) for value in self.C]}


@dataclass(frozen=True)
class FrobeniusBoundary:
    """保存一个或多个可叠加的奇点 power-log 领头分支。"""

    terms: tuple[FrobeniusBoundaryTerm, ...]

    def __post_init__(self) -> None:
        """验证直接构造时的 term 类型、非空性和共同维数。"""

        parsed = tuple(_parse_term(term, position) for position, term in enumerate(self.terms, 1))
        if not parsed:
            raise ValueError("Frobenius boundary must contain at least one term")
        if len({len(term.C) for term in parsed}) != 1:
            raise ValueError("all Frobenius boundary C vectors must have the same dimension")
        object.__setattr__(self, "terms", parsed)

    def to_json(self) -> list[dict[str, Any]]:
        """按用户输入顺序序列化全部分支。"""

        return [term.to_json() for term in self.terms]


def _parse_term(record: Any, position: int) -> FrobeniusBoundaryTerm:
    """解析单个字典或三元组，并严格拒绝多余字段和浮点 exact 输入。"""

    if isinstance(record, FrobeniusBoundaryTerm):
        return record
    if isinstance(record, Mapping):
        if set(record) != {"a", "b", "C"}:
            raise ValueError(
                f"Frobenius boundary term {position} must contain exactly a, b, C"
            )
        a_value, b_value, vector_value = record["a"], record["b"], record["C"]
    elif isinstance(record, (list, tuple)) and len(record) == 3:
        a_value, b_value, vector_value = record
    else:
        raise TypeError(
            f"Frobenius boundary term {position} must be a {{a,b,C}} mapping or (a,b,C)"
        )
    if isinstance(b_value, bool) or not isinstance(b_value, int) or b_value < 0:
        raise TypeError(f"Frobenius boundary term {position}: b must be a nonnegative integer")
    if not isinstance(vector_value, (list, tuple)) or not vector_value:
        raise TypeError(f"Frobenius boundary term {position}: C must be a nonempty vector")
    try:
        power = gaussian_rational(a_value)
        vector = tuple(gaussian_rational(value) for value in vector_value)
    except (TypeError, ValueError) as error:
        raise type(error)(
            f"Frobenius boundary term {position}: a and every C entry must be exact Q(i)"
        ) from error
    if all(value.is_zero for value in vector):
        raise ValueError(f"Frobenius boundary term {position}: C must not be the zero vector")
    return FrobeniusBoundaryTerm(power, b_value, vector)


def frobenius_boundary(records: Iterable[Any] | FrobeniusBoundary) -> FrobeniusBoundary:
    """验证并冻结一列 ``{a,b,C}`` 记录。

    推荐输入为 ``[{"a": ..., "b": ..., "C": [...]}, ...]``；每项也可写成
    ``(a,b,C)``。这里只验证记录结构和 exact 数域，indicial/log 相容性在获得具体
    微分方程与路径起点后验证。指数型局部解不要求用户另填指数：程序从 exact 高阶
    Laurent 矩阵推断指数 sector；若一个 ``C`` 跨越多个 sector，用户必须拆成多项。
    """

    if isinstance(records, FrobeniusBoundary):
        return records
    if isinstance(records, (str, bytes, Mapping)):
        raise TypeError("Frobenius boundary must be a nonempty sequence of {a,b,C} terms")
    try:
        terms = tuple(_parse_term(record, position) for position, record in enumerate(records, 1))
    except TypeError as error:
        if "not iterable" in str(error):
            raise TypeError(
                "Frobenius boundary must be a nonempty sequence of {a,b,C} terms"
            ) from error
        raise
    if not terms:
        raise ValueError("Frobenius boundary must contain at least one term")
    dimensions = {len(term.C) for term in terms}
    if len(dimensions) != 1:
        raise ValueError("all Frobenius boundary C vectors must have the same dimension")
    return FrobeniusBoundary(terms)


def _column(values: Sequence[GaussianRational]) -> GaussianMatrix:
    """把 exact Q(i) 标量序列转换为列矩阵。"""

    return GaussianMatrix.from_records([[value] for value in values])


def _matrix_from_columns(columns: Sequence[GaussianMatrix], dimension: int) -> GaussianMatrix:
    """把同维列向量合成 exact Q(i) 矩阵。"""

    return GaussianMatrix.from_records(
        [
            [column.scalar(row, 0) for column in columns]
            for row in range(dimension)
        ]
    )


def _canonical_exact_solve(left: GaussianMatrix, right: GaussianMatrix) -> GaussianMatrix:
    """用 RREF 求相容系统的规范特解，并把所有自由变量固定为零。"""

    if left.nrows != right.nrows or right.ncols != 1:
        raise ValueError("exact boundary linear solve dimension mismatch")
    augmented = GaussianMatrix.from_records(
        [
            [left.scalar(row, column) for column in range(left.ncols)]
            + [right.scalar(row, 0)]
            for row in range(left.nrows)
        ]
    )
    reduced, _rank, pivots = augmented.rref()
    if left.ncols in pivots:
        raise ValueError("Frobenius leading vector is incompatible with the exact local basis")
    solution = [GaussianRational() for _ in range(left.ncols)]
    for pivot_row, pivot_column in enumerate(pivots):
        if pivot_column < left.ncols:
            solution[pivot_column] = reduced.scalar(pivot_row, left.ncols)
    candidate = _column(solution)
    if not (left * candidate - right).is_zero:
        raise ArithmeticError("exact Frobenius boundary solve failed its substitution check")
    return candidate


def _single_root_constants(
    boundary: FrobeniusBoundary,
    manifest: dict[str, Any],
    dimension: int,
) -> tuple[GaussianMatrix, list[dict[str, Any]]]:
    """由最高 log 领头项恢复单根 Jordan 基常数。"""

    root = gaussian_rational(manifest["root_exact"])
    nilpotent = GaussianMatrix.from_records(manifest["nilpotent_exact"])
    maximum_log_degree = int(manifest["maximum_log_degree"])
    constants = GaussianMatrix.zero(dimension, 1)
    details: list[dict[str, Any]] = []
    for position, term in enumerate(boundary.terms, 1):
        if term.a != root:
            raise ValueError(
                f"Frobenius boundary term {position}: a={term.a} is not the indicial root {root}"
            )
        if term.b > maximum_log_degree:
            raise ValueError(
                f"Frobenius boundary term {position}: b={term.b} exceeds exact maximum log degree "
                f"{maximum_log_degree}"
            )
        leading = _column(term.C)
        if not (nilpotent * leading).is_zero:
            raise ValueError(
                f"Frobenius boundary term {position}: C is not a highest-log coefficient "
                "because the nilpotent residue still acts nontrivially"
            )
        preimage = _canonical_exact_solve(
            nilpotent ** term.b,
            leading * math.factorial(term.b),
        )
        if not (nilpotent ** (term.b + 1) * preimage).is_zero:
            raise ArithmeticError("canonical Jordan preimage has a higher unexpected log power")
        constants += preimage
        details.append(
            {
                "term_index": position,
                "input": term.to_json(),
                "canonical_basis_constants": [
                    str(preimage.scalar(row, 0)) for row in range(dimension)
                ],
                "completion": "lower log powers are generated by exp(N log(z))",
            }
        )
    return constants, details


def _diagonalizable_constants(
    boundary: FrobeniusBoundary,
    manifest: dict[str, Any],
    dimension: int,
) -> tuple[GaussianMatrix, list[dict[str, Any]]]:
    """把半单 residue 的任意 exact 本征向量展开到 canonical solution columns。"""

    roots = [gaussian_rational(value) for value in manifest["solution_roots_exact"]]
    columns = [
        _column(tuple(gaussian_rational(value) for value in records))
        for records in manifest["initial_vectors_exact"]
    ]
    constants = GaussianMatrix.zero(dimension, 1)
    details: list[dict[str, Any]] = []
    for position, term in enumerate(boundary.terms, 1):
        if term.b != 0:
            raise ValueError(
                f"Frobenius boundary term {position}: a semisimple leading branch requires b=0; "
                "resonance logs generated at higher series order are automatic"
            )
        positions = [index for index, root in enumerate(roots) if root == term.a]
        if not positions:
            spectrum = sorted({str(root) for root in roots})
            raise ValueError(
                f"Frobenius boundary term {position}: a={term.a} is not in the exact indicial "
                f"spectrum {spectrum}"
            )
        eigenbasis = _matrix_from_columns([columns[index] for index in positions], dimension)
        local_constants = _canonical_exact_solve(eigenbasis, _column(term.C))
        full_constants = GaussianMatrix.zero(dimension, 1)
        for local_index, solution_index in enumerate(positions):
            full_constants.real[solution_index, 0] = local_constants.real[local_index, 0]
            full_constants.imag[solution_index, 0] = local_constants.imag[local_index, 0]
        constants += full_constants
        details.append(
            {
                "term_index": position,
                "input": term.to_json(),
                "canonical_basis_constants": [
                    str(full_constants.scalar(row, 0)) for row in range(dimension)
                ],
                "completion": "higher-order resonance log terms are generated automatically",
            }
        )
    return constants, details


def resolve_frobenius_boundary(
    system: RegularSingularSystem,
    manifest: dict[str, Any],
    value: Any,
) -> tuple[FrobeniusBoundary, GaussianMatrix, dict[str, Any]]:
    """验证具体局部系统的边界，并返回 power-log 基常数及审计记录。"""

    boundary = frobenius_boundary(value)
    dimension = system.dimension
    if any(len(term.C) != dimension for term in boundary.terms):
        raise ValueError(
            f"Frobenius boundary C dimension must equal differential-equation dimension {dimension}"
        )
    route = manifest.get("route")
    if route == "single_root_jordan_exact_gate":
        constants, details = _single_root_constants(boundary, manifest, dimension)
    elif route == "diagonalizable_roots_exact_gate":
        constants, details = _diagonalizable_constants(boundary, manifest, dimension)
    else:
        raise ValueError(
            "Frobenius boundary requires a supported exact manifest; numerical or mixed-root "
            "defective structure cannot certify {a,b,C}"
        )
    if constants.is_zero:
        raise ValueError("combined Frobenius boundary selects the zero solution")
    report = {
        "schema": "flintnde_frobenius_boundary_v1",
        "system_name": system.name,
        "exact_field": "Q(i)",
        "terms": boundary.to_json(),
        "canonical_basis_constants": [
            str(constants.scalar(row, 0)) for row in range(dimension)
        ],
        "term_resolutions": details,
    }
    return boundary, constants, report
