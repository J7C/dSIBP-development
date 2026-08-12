#!/usr/bin/env python3
"""求解 ``(x-1)^epsilon exp[-k(x-1)]`` 积分族的局部矩阵微分方程。

本模块在固定物理 QNM 数值点保持三条频率严格满足 EC，只把 horizon regulator
实现为作用点平移 ``a2 -> a2-epsilon``。普通点使用截断 epsilon jet 与 FLINT Acb
递推 ``dI/dk=A(k,epsilon)I``；奇点接口保留联合
``epsilon^q k^n log(k)^r`` 局部展开，供完整 scalar 装配后提取有限部。

通用 regulator jet、路径输运与局部基由同一 FlintNDE 包的 regular-point 模块提供；
本模块只把这些中性接口映射为 epsilon 语义，不改变任何物理频率 iw_i。"""

from __future__ import annotations

import time
from dataclasses import dataclass
from typing import Any, Sequence

import sympy as sp
from flint import acb, acb_mat, acb_series


from .regular_point_de import (
    FlintPoleResidueSystem,
    FlintRegulatorRationalSystem as FlintEpsilonRationalSystem,
    RegulatorK0NilpotentLocalBasis as EpsilonK0NilpotentLocalBasis,
    _cu_qnm_bc_regulator_series as _cu_qnm_bc_epsilon_series,
    _derivative_series,
    _exact_matrix_to_acb,
    _exact_vector_to_acb,
    _integer_binomial_series,
    _local_diagonalizable_matrix,
    _multiply_taylor_series_over_regulator as _multiply_taylor_series_over_epsilon,
    _solve_projected_degree,
    arb_midpoint_float,
    build_regulator_k0_nilpotent_local_basis as build_epsilon_k0_nilpotent_local_basis,
    exact_inputform_expression,
    exact_inputform_to_acb,
    matrix_norm_inf,
    relative_difference_inf,
    transport_regulator_path as transport_epsilon_path,
)


@dataclass
class EpsilonRegularTransportResult:
    """保存一条解析 epsilon 普通点路径的边界、快照、报告和耗时。"""

    boundary_vectors: list[acb_mat]
    snapshots: list[list[acb_mat]]
    segment_reports: list[dict[str, Any]]
    boundary_seconds: float
    transport_seconds: float


@dataclass
class EpsilonK0MatchResult:
    """保存解析 epsilon 普通点输运与 ``k=0`` 广义级数匹配结果。

    ``constants`` 是堆叠后局部基的齐次常数；``finite_part_vectors`` 按
    epsilon 阶数保存 ``k^0 log(k)^0`` 的 16 维向量。
    """

    regular_transport: EpsilonRegularTransportResult
    local_basis: EpsilonK0NilpotentLocalBasis
    constants: acb_mat
    stability_constants: acb_mat
    finite_part_vectors: list[acb_mat]
    validation_errors: list[Any]
    stability_errors: list[Any]
    local_basis_seconds: float
    fit_seconds: float


@dataclass
class EpsilonK0FitResult:
    """保存同一局部 power-log 基在一组普通点上的拟合与稳定性结果。"""

    constants: acb_mat
    stability_constants: acb_mat
    finite_part_vectors: list[acb_mat]
    validation_errors: list[Any]
    stability_errors: list[Any]
    fit_seconds: float


@dataclass
class EpsilonK0SequentialResult:
    """保存逐阶受迫 DE 的一个物理解及其普通点验证。"""

    finite_part_vectors: list[acb_mat]
    coefficients: dict[tuple[int, int, int], acb_mat]
    validation_errors: list[Any]
    compatibility_residuals: list[Any]
    elapsed_seconds: float


@dataclass
class K0DiagonalizableSeriesResult:
    """保存 exact-gated 可对角化 Frobenius 物理解的完整 power-log 系数。"""

    coefficients: dict[tuple[int, int], acb_mat]
    constants: acb_mat
    validation_errors: list[Any]
    log_records: list[dict[str, int]]
    elapsed_seconds: float


class FlintLocalEpsilonLaurentSystem:
    """从局部 preinverse 矩阵铅笔构造 ``k=0`` 的解析 epsilon Laurent 系数。

    该类只保存奇点递推需要的 ``A_{p,n}``，不生成全局有理函数或其它 pole 的
    部分分式。零本征空间投影由已知非零谱点的多项式直接构造，随后用群逆展开
    ``(P-k I)^(-1)``，因此 epsilon 始终作为截断解析级数处理。
    """

    def __init__(
        self,
        *,
        request_id: str,
        dimension: int,
        epsilon_order: int,
        regular_order: int,
        coefficients: dict[tuple[int, int], acb_mat],
        construction_residuals: list[Any],
    ) -> None:
        self.request_id = request_id
        self.dimension = dimension
        self.epsilon_order = epsilon_order
        self.regular_order = regular_order
        self.coefficients = coefficients
        self.construction_residuals = construction_residuals

    @staticmethod
    def _identity(dimension: int) -> acb_mat:
        """构造指定维数的 Acb 单位矩阵。"""

        result = acb_mat(dimension, dimension)
        for index in range(dimension):
            result[index, index] = acb(1)
        return result

    @classmethod
    def from_pole_residue_system(
        cls,
        system: FlintPoleResidueSystem,
        *,
        regular_order: int,
    ) -> "FlintLocalEpsilonLaurentSystem":
        """把 epsilon^0 pole/residue DE 适配为现有 k=0 局部求解接口。

        输入系统必须来自已验证的 exact payload；此适配器只展开该系统在 k=0 的
        Laurent 系数，输入仅包含 pole/residue 系统与展开阶数。
        """

        if regular_order < 0:
            raise ValueError("local Laurent regular order must be nonnegative")
        residue, regular = system.laurent_at_zero(regular_order + 1)
        coefficients = {(0, -1): residue}
        coefficients.update(
            {(0, power): matrix for power, matrix in enumerate(regular)}
        )
        return cls(
            request_id=f"local_laurent_{system.request_id}",
            dimension=system.dimension,
            epsilon_order=0,
            regular_order=regular_order,
            coefficients=coefficients,
            construction_residuals=[],
        )

    @classmethod
    def from_preinverse_system(
        cls,
        system: "FlintLocalEpsilonPreinverseSystem",
        *,
        regular_order: int,
    ) -> "FlintLocalEpsilonLaurentSystem":
        """由 ``B_000=P-k I+O(epsilon)`` 递推 16 维 DE 的局部 Laurent 系数。"""

        if regular_order < 0:
            raise ValueError("local Laurent regular order must be nonnegative")
        blocks = system._preinverse_block_series(acb(0), 1)
        identity8 = cls._identity(8)
        p_matrix = blocks["000"][0][0]

        # P 的零根在当前 EC 点是半单根；已知六个非零谱点给出其谱投影。
        projector = acb_mat(identity8)
        for pole in system.poles_at_epsilon0[1:]:
            if abs(pole).contains(0):
                raise ArithmeticError("nonzero spectral pole contains zero")
            projector = projector * (p_matrix - identity8 * pole) / (-pole)
        group_inverse = (p_matrix + projector).inv() - projector

        residuals = [
            matrix_norm_inf(p_matrix * projector),
            matrix_norm_inf(projector * projector - projector),
            matrix_norm_inf(
                p_matrix * group_inverse - (identity8 - projector)
            ),
            matrix_norm_inf(group_inverse * projector),
        ]

        # 两个离散槽位依次表示 epsilon 幂次和 k Laurent 幂次。
        maximum_c0_power = regular_order + system.epsilon_order
        inverse_by_epsilon: list[dict[int, acb_mat]] = [
            {-1: -projector}
        ]
        group_power = acb_mat(group_inverse)
        for k_power in range(maximum_c0_power + 1):
            inverse_by_epsilon[0][k_power] = acb_mat(group_power)
            group_power = group_power * group_inverse

        for epsilon_power in range(1, system.epsilon_order + 1):
            maximum_power = regular_order + system.epsilon_order - epsilon_power
            current: dict[int, acb_mat] = {}
            for k_power in range(-epsilon_power - 1, maximum_power + 1):
                total = acb_mat(8, 8)
                for block_power in range(1, epsilon_power + 1):
                    block = blocks["000"][block_power][0]
                    previous = inverse_by_epsilon[epsilon_power - block_power]
                    for left_power, left in inverse_by_epsilon[0].items():
                        right = previous.get(k_power - left_power)
                        if right is not None:
                            total += left * block * right
                current[k_power] = -total
            inverse_by_epsilon.append(current)

        # 对 B_000 B_000^(-1)=I 的每个已保留 Laurent 系数做数值球残差检查。
        for epsilon_power in range(system.epsilon_order + 1):
            for k_power in range(-epsilon_power - 1, regular_order + 1):
                product = acb_mat(8, 8)
                for block_power in range(epsilon_power + 1):
                    inverse = inverse_by_epsilon[epsilon_power - block_power]
                    coefficient = inverse.get(k_power)
                    if coefficient is not None:
                        product += blocks["000"][block_power][0] * coefficient
                shifted = inverse_by_epsilon[epsilon_power].get(k_power - 1)
                if shifted is not None:
                    product -= shifted
                if epsilon_power == 0 and k_power == 0:
                    product -= identity8
                residuals.append(matrix_norm_inf(product))

        coefficients: dict[tuple[int, int], acb_mat] = {}
        for epsilon_power in range(system.epsilon_order + 1):
            for k_power in range(-epsilon_power - 1, regular_order + 1):
                z_block = acb_mat(8, 8)
                left = acb_mat(8, 8)
                right = acb_mat(8, 8)
                for inverse_power in range(epsilon_power + 1):
                    inverse = inverse_by_epsilon[inverse_power].get(k_power)
                    if inverse is None:
                        continue
                    block_power = epsilon_power - inverse_power
                    z_block += inverse * blocks["001"][block_power][0]
                    left += inverse * blocks["010"][block_power][0]
                    right += inverse * blocks["100"][block_power][0]
                coefficients[(epsilon_power, k_power)] = system._assemble_de_matrix(
                    left,
                    right,
                    epsilon_power == 0 and k_power == 0,
                    z_block,
                )

        return cls(
            request_id=f"local_laurent_{system.request_id}",
            dimension=system.dimension,
            epsilon_order=system.epsilon_order,
            regular_order=regular_order,
            coefficients=coefficients,
            construction_residuals=residuals,
        )

    def laurent_matrix_coefficients_at_zero(
        self,
        regular_order: int,
    ) -> dict[tuple[int, int], acb_mat]:
        """返回不超过预构造阶数的 ``A_{epsilon_power,k_power}``。"""

        if not 0 <= regular_order <= self.regular_order:
            raise ValueError(
                "requested Laurent order exceeds the locally constructed order"
            )
        return {
            key: acb_mat(value)
            for key, value in self.coefficients.items()
            if key[1] <= regular_order
        }


def _matrix_contains_zero(matrix: acb_mat) -> bool:
    """判断矩阵每个 ball 是否都包含精确零。"""

    return all(
        matrix[row, column].contains(0)
        for row in range(matrix.nrows())
        for column in range(matrix.ncols())
    )


def _two_root_projectors(residue: acb_mat) -> tuple[dict[int, acb_mat], list[Any]]:
    """用 ball 恒等式认证 ``R(R-rI)=0`` 并返回两个谱投影。

    当前接口只接受半单的两个整数根 ``0,r``。候选 ``r`` 由矩阵恒等式扫描得到，
    不是由 point/channel 名或近似特征值硬编码；候选不唯一时立即阻断。
    """

    dimension = residue.nrows()
    if residue.ncols() != dimension:
        raise ValueError("k0 residue must be square")
    identity = FlintLocalEpsilonLaurentSystem._identity(dimension)
    residue_squared = residue * residue
    candidates = [
        root
        for root in range(-64, 65)
        if root != 0 and _matrix_contains_zero(residue_squared - residue * root)
    ]
    if len(candidates) != 1:
        raise ValueError(
            "k0 residue is not certified to have exactly two roots 0,r: "
            f"integer candidates={candidates}"
        )
    root = candidates[0]
    nonzero_projector = residue / acb(root)
    zero_projector = identity - nonzero_projector
    residuals = [
        matrix_norm_inf(residue_squared - residue * root),
        matrix_norm_inf(zero_projector * zero_projector - zero_projector),
        matrix_norm_inf(
            nonzero_projector * nonzero_projector - nonzero_projector
        ),
        matrix_norm_inf(zero_projector * nonzero_projector),
        matrix_norm_inf(zero_projector + nonzero_projector - identity),
    ]
    if not all(_matrix_contains_zero(matrix) for matrix in (
        residue_squared - residue * root,
        zero_projector * zero_projector - zero_projector,
        nonzero_projector * nonzero_projector - nonzero_projector,
        zero_projector * nonzero_projector,
        zero_projector + nonzero_projector - identity,
    )):
        raise ArithmeticError("k0 two-root projector identities are not ball certified")
    return {0: zero_projector, root: nonzero_projector}, residuals


def solve_epsilon_k0_sequential(
    system: FlintLocalEpsilonLaurentSystem,
    sample_points: Sequence[acb],
    sample_vectors: Sequence[list[acb_mat]],
    *,
    solution_epsilon_order: int,
    series_order: int,
    fit_position: int = 0,
) -> EpsilonK0SequentialResult:
    """在两个半单整数根的共振齐次算子上逐阶求 epsilon 受迫解。

    第 ``q`` 层只通过 ``A_p I_(q-p)`` 与已知低阶层耦合；所有层共享由
    epsilon 零阶 residue 决定的齐次基本矩阵。递推遇到 ``n=0`` 或第二个整数根时，
    共振投影的 defect 自动进入下一阶 ``log(k)``，不使用伪逆或最小二乘。
    """

    if not 0 <= solution_epsilon_order <= system.epsilon_order:
        raise ValueError("requested solution epsilon order exceeds the local system")
    if series_order <= 0:
        raise ValueError("k0 sequential series order must be positive")
    if len(sample_points) < 2 or len(sample_points) != len(sample_vectors):
        raise ValueError("sequential k0 solve requires at least two aligned samples")
    if not 0 <= fit_position < len(sample_points):
        raise ValueError("fit position is outside the sample list")
    expected_count = solution_epsilon_order + 1
    if any(len(vectors) < expected_count for vectors in sample_vectors):
        raise ValueError("sample vectors do not cover the requested epsilon order")

    import time

    clock = time.perf_counter()
    dimension = system.dimension
    maximum_regular_power = series_order + solution_epsilon_order
    matrix_coefficients = system.laurent_matrix_coefficients_at_zero(
        maximum_regular_power
    )
    matrices_by_epsilon: list[list[tuple[int, acb_mat]]] = [
        [] for _ in range(expected_count)
    ]
    for (epsilon_power, k_power), matrix in matrix_coefficients.items():
        if epsilon_power <= solution_epsilon_order:
            matrices_by_epsilon[epsilon_power].append((k_power, matrix))

    residue = matrix_coefficients.get((0, -1))
    if residue is None:
        raise ValueError("sequential k0 solve requires the p=0 simple-pole residue")
    projectors, projector_residuals = _two_root_projectors(residue)
    roots = sorted(projectors)
    identity = FlintLocalEpsilonLaurentSystem._identity(dimension)

    def solve_projected_power(
        k_power: int,
        right_by_log: list[acb_mat],
    ) -> list[acb_mat]:
        """按谱投影解一个绝对 k 幂次，并在共振处生成所需 log。"""

        existing_log_degree = len(right_by_log) - 1
        if k_power not in projectors:
            inverse = acb_mat(dimension, dimension)
            for root, projector in projectors.items():
                inverse += projector / acb(k_power - root)
            coefficients = [
                acb_mat(dimension, right_by_log[0].ncols())
                for _ in range(existing_log_degree + 1)
            ]
            for log_degree in range(existing_log_degree, -1, -1):
                corrected = acb_mat(right_by_log[log_degree])
                if log_degree < existing_log_degree:
                    corrected -= coefficients[log_degree + 1] * acb(log_degree + 1)
                coefficients[log_degree] = inverse * corrected
            return coefficients

        resonant_projector = projectors[k_power]
        reduced_inverse = acb_mat(dimension, dimension)
        for root, projector in projectors.items():
            if root != k_power:
                reduced_inverse += projector / acb(k_power - root)
        coefficients = [
            acb_mat(dimension, right_by_log[0].ncols())
            for _ in range(existing_log_degree + 2)
        ]
        for log_degree in range(existing_log_degree, -1, -1):
            corrected = acb_mat(right_by_log[log_degree])
            corrected -= coefficients[log_degree + 1] * acb(log_degree + 1)
            defect = resonant_projector * corrected
            coefficients[log_degree + 1] += defect / acb(log_degree + 1)
            corrected -= defect
            coefficients[log_degree] = reduced_inverse * corrected
        return coefficients

    def evaluate(
        coefficients: dict[tuple[int, int], acb_mat],
        point: acb,
        maximum_k_power: int,
    ) -> acb_mat:
        """在正实普通点求值一个截断的 ``k^n log(k)^r`` 级数。"""

        logarithm = point.log()
        first = next(iter(coefficients.values()))
        result = acb_mat(first.nrows(), first.ncols())
        for (k_power, log_degree), coefficient in coefficients.items():
            if k_power <= maximum_k_power:
                result += coefficient * (point**k_power) * (logarithm**log_degree)
        return result

    # Phi 汇总两个根分支，列数仍为 dimension；投影矩阵自动选择各自本征子空间。
    homogeneous: dict[tuple[int, int], acb_mat] = {}
    for root in roots:
        branch: dict[tuple[int, int], acb_mat] = {
            (root, 0): acb_mat(projectors[root])
        }
        for k_power in range(root + 1, maximum_regular_power + 1):
            right_by_log: list[acb_mat] = []
            for matrix_k_power, matrix in matrices_by_epsilon[0]:
                if matrix_k_power == -1:
                    continue
                source_power = k_power - 1 - matrix_k_power
                branch_logs = [
                    log_degree
                    for source_k_power, log_degree in branch
                    if source_k_power == source_power
                ]
                if not branch_logs:
                    continue
                maximum_log = max(branch_logs)
                while len(right_by_log) <= maximum_log:
                    right_by_log.append(acb_mat(dimension, dimension))
                for log_degree in branch_logs:
                    right_by_log[log_degree] += matrix * branch[(source_power, log_degree)]
            if not right_by_log:
                right_by_log = [acb_mat(dimension, dimension)]
            solved = solve_projected_power(k_power, right_by_log)
            for log_degree, coefficient in enumerate(solved):
                branch[(k_power, log_degree)] = coefficient
        for key, coefficient in branch.items():
            homogeneous[key] = homogeneous.get(
                key, acb_mat(dimension, dimension)
            ) + coefficient

    completed: list[dict[tuple[int, int], acb_mat]] = []
    finite_parts: list[acb_mat] = []
    compatibility_residuals: list[Any] = list(projector_residuals)
    for epsilon_power in range(expected_count):
        maximum_k_power = maximum_regular_power - epsilon_power
        particular: dict[tuple[int, int], acb_mat] = {}

        def forced_rhs_by_log(k_power: int) -> list[acb_mat]:
            """收集本层规则项与所有低阶 epsilon 解给出的已知源。"""

            totals: list[acb_mat] = []
            for matrix_epsilon_power in range(epsilon_power + 1):
                source_table = (
                    particular
                    if matrix_epsilon_power == 0
                    else completed[epsilon_power - matrix_epsilon_power]
                )
                for matrix_k_power, matrix in matrices_by_epsilon[matrix_epsilon_power]:
                    if matrix_epsilon_power == 0 and matrix_k_power == -1:
                        continue
                    source_power = k_power - 1 - matrix_k_power
                    source_logs = [
                        log_degree
                        for source_k_power, log_degree in source_table
                        if source_k_power == source_power
                    ]
                    if not source_logs:
                        continue
                    maximum_log = max(source_logs)
                    while len(totals) <= maximum_log:
                        totals.append(acb_mat(dimension, 1))
                    for log_degree in source_logs:
                        totals[log_degree] += matrix * source_table[(source_power, log_degree)]
            return totals or [acb_mat(dimension, 1)]

        for k_power in range(-epsilon_power, maximum_k_power + 1):
            solved = solve_projected_power(k_power, forced_rhs_by_log(k_power))
            for log_degree, coefficient in enumerate(solved):
                particular[(k_power, log_degree)] = coefficient

        fit_point = sample_points[fit_position]
        homogeneous_at_fit = evaluate(homogeneous, fit_point, maximum_k_power)
        particular_at_fit = evaluate(particular, fit_point, maximum_k_power)
        constant = homogeneous_at_fit.solve(
            sample_vectors[fit_position][epsilon_power] - particular_at_fit
        )
        full = {key: acb_mat(value) for key, value in particular.items()}
        for key, coefficient in homogeneous.items():
            if key[0] <= maximum_k_power:
                full[key] = full.get(key, acb_mat(dimension, 1)) + coefficient * constant
        finite_parts.append(full.get((0, 0), acb_mat(dimension, 1)))
        completed.append(full)

    validation_errors: list[Any] = []
    for position, (point, vectors) in enumerate(zip(sample_points, sample_vectors)):
        if position == fit_position:
            continue
        for epsilon_power, coefficients in enumerate(completed):
            maximum_k_power = maximum_regular_power - epsilon_power
            validation_errors.append(
                relative_difference_inf(
                    evaluate(coefficients, point, maximum_k_power),
                    vectors[epsilon_power],
                )
            )

    flattened = {
        (epsilon_power, k_power, log_degree): coefficient
        for epsilon_power, table in enumerate(completed)
        for (k_power, log_degree), coefficient in table.items()
    }
    return EpsilonK0SequentialResult(
        finite_part_vectors=finite_parts,
        coefficients=flattened,
        validation_errors=validation_errors,
        compatibility_residuals=compatibility_residuals,
        elapsed_seconds=time.perf_counter() - clock,
    )


def solve_k0_diagonalizable_series(
    system: FlintLocalEpsilonLaurentSystem,
    manifest: dict[str, Any],
    sample_points: Sequence[acb],
    sample_vectors: Sequence[acb_mat],
    *,
    series_order: int,
    fit_position: int = 0,
) -> K0DiagonalizableSeriesResult:
    """按 exact projector/gate 递推可对角化 k=0 系统并匹配物理解。

    输入系统只允许 ``epsilon^0``；manifest 决定指标根、初始特征向量和整数差
    共振是否生成 log。返回全部整数 ``(k_power, log_degree)`` 系数，供上层
    与 Laurent 约化系数逐阶配对，而不是只返回有限部。
    """

    if system.epsilon_order != 0:
        raise ValueError("diagonalizable k0 series currently requires epsilon_order=0")
    if manifest.get("status") != "passed":
        raise ValueError("exact diagonalizable manifest status is not passed")
    if manifest.get("route") != "diagonalizable_real_roots_exact_gate":
        raise ValueError("exact manifest does not describe a diagonalizable route")
    if int(manifest.get("dimension", -1)) != system.dimension:
        raise ValueError("exact manifest dimension does not match the local system")
    if not 0 <= fit_position < len(sample_points):
        raise ValueError("diagonalizable fit position is outside the sample list")
    if len(sample_points) < 2 or len(sample_points) != len(sample_vectors):
        raise ValueError("diagonalizable k0 solve requires aligned sample lists")
    if series_order <= 0 or series_order > system.regular_order:
        raise ValueError("diagonalizable series order exceeds local-system coverage")

    import time

    clock = time.perf_counter()
    matrix_coefficients = system.laurent_matrix_coefficients_at_zero(series_order - 1)
    regular = [matrix_coefficients[(0, power)] for power in range(series_order)]
    roots_exact = [
        exact_inputform_expression(value) for value in manifest["roots_exact"]
    ]
    projectors = {
        root: _exact_matrix_to_acb(records)
        for root, records in zip(roots_exact, manifest["projectors_exact"])
    }
    solution_roots_exact = [
        exact_inputform_expression(value)
        for value in manifest["solution_roots_exact"]
    ]
    solution_roots = [
        exact_inputform_to_acb(value) for value in solution_roots_exact
    ]
    initial_vectors = [
        _exact_vector_to_acb(records)
        for records in manifest["initial_vectors_exact"]
    ]
    resonance_gates = {
        str(key): bool(value) for key, value in manifest["resonance_gates"].items()
    }
    if len(initial_vectors) != system.dimension:
        raise ValueError("exact manifest does not provide a full solution basis")

    series_by_solution: list[list[list[acb_mat]]] = []
    log_records: list[dict[str, int]] = []
    for solution_index, (root_exact, initial) in enumerate(
        zip(solution_roots_exact, initial_vectors), start=1
    ):
        series: list[list[acb_mat]] = [[initial]]
        for degree in range(1, series_order + 1):
            previous_log_degree = max(len(item) for item in series) - 1
            right_by_log = [
                acb_mat(system.dimension, 1)
                for _ in range(previous_log_degree + 1)
            ]
            for regular_degree in range(degree):
                earlier = series[degree - 1 - regular_degree]
                for log_degree, coefficient in enumerate(earlier):
                    right_by_log[log_degree] += regular[regular_degree] * coefficient
            coefficients = _solve_projected_degree(
                projectors,
                root_exact + degree,
                right_by_log,
                solution_index=solution_index,
                resonance_gates=resonance_gates,
            )
            if len(coefficients) - 1 > previous_log_degree:
                log_records.append(
                    {
                        "solution_index": solution_index,
                        "series_degree": degree,
                        "new_maximum_log_degree": len(coefficients) - 1,
                    }
                )
            series.append(coefficients)
        series_by_solution.append(series)

    fit_matrix = _local_diagonalizable_matrix(
        sample_points[fit_position], solution_roots, series_by_solution
    )
    constants = fit_matrix.solve(sample_vectors[fit_position])
    validation_errors = [
        relative_difference_inf(
            _local_diagonalizable_matrix(point, solution_roots, series_by_solution)
            * constants,
            vector,
        )
        for position, (point, vector) in enumerate(zip(sample_points, sample_vectors))
        if position != fit_position
    ]

    physical: dict[tuple[int, int], acb_mat] = {}
    for solution_index, (root_exact, series) in enumerate(
        zip(solution_roots_exact, series_by_solution)
    ):
        for degree, by_log in enumerate(series):
            absolute_power = sp.simplify(root_exact + degree)
            if absolute_power.is_Integer is not True:
                raise ValueError(f"noninteger k power in local series: {absolute_power}")
            power = int(absolute_power)
            for log_degree, coefficient in enumerate(by_log):
                key = (power, log_degree)
                physical[key] = physical.get(
                    key, acb_mat(system.dimension, 1)
                ) + coefficient * constants[solution_index, 0]

    return K0DiagonalizableSeriesResult(
        coefficients=physical,
        constants=constants,
        validation_errors=validation_errors,
        log_records=log_records,
        elapsed_seconds=time.perf_counter() - clock,
    )


class FlintLocalEpsilonPreinverseSystem:
    """按局部 ``(k-center,epsilon)`` 双级数数值构造 16/24 维 DE。

    三条频率固定为 metadata 中的 exact EC 值。epsilon 只实现
    ``a2 -> a2-epsilon``，因此 preinverse 的 `010` block 在线性 epsilon 阶
    增加单位矩阵；积分标签与 Taylor 次数始终保持整数。无 Z 输入使用
    ``[XMinusOne,X]`` 16 维 basis，active-Z 输入使用
    ``[Z,XMinusOne,X]`` 24 维 basis。
    """

    def __init__(
        self,
        metadata: dict[str, Any],
        *,
        epsilon_order: int,
        it0: int,
        it1: int,
        a_x_zero: int,
        regulator_name: str = "epsilon",
    ) -> None:
        if epsilon_order < 0:
            raise ValueError("epsilon_order must be nonnegative")
        if regulator_name != "epsilon":
            raise ValueError("FlintNDE epsilon-jet interface accepts only regulator_name='epsilon'")
        point = metadata["numeric_point"]
        self.request_id = f"local_numeric_{metadata['request_id']}"
        physical_basis_keys = metadata["physical_basis_keys"]
        self.dimension = len(physical_basis_keys)
        if self.dimension not in {16, 24}:
            raise ValueError(
                f"epsilon preinverse system requires dimension 16 or 24, got {self.dimension}"
            )
        self.basis_mode = "subsector16" if self.dimension == 16 else "top24"
        # 共享 jet 输运器使用 regulator-neutral 协议；本模块固定解释为 epsilon。
        self.epsilon_order = epsilon_order
        self.regulator_order = epsilon_order
        self.regulator_name = regulator_name
        self.iws = [
            exact_inputform_to_acb(point["iw1"]),
            exact_inputform_to_acb(point["iw2"]),
            exact_inputform_to_acb(point["iw3"]),
        ]
        if not abs(self.iws[2] - self.iws[1] - self.iws[0]).contains(0):
            raise ValueError("epsilon route requires exact EC frequencies")
        self.cls = [
            exact_inputform_to_acb(point[f"cl2{leg}"])
            for leg in range(1, 4)
        ]
        self.it0 = acb(it0)
        self.it1 = acb(it1)
        self.a_x_zero = acb(a_x_zero)
        labels = [
            tuple(int(value) for value in key[:3])
            for key in physical_basis_keys[:8]
        ]
        expected = {
            (n1, n2, n3)
            for n1 in range(2)
            for n2 in range(2)
            for n3 in range(2)
        }
        if len(labels) != 8 or set(labels) != expected:
            raise ValueError(
                "physical basis does not contain the expected binary derivative labels"
            )
        self.labels = labels
        self.label_positions = {label: index for index, label in enumerate(labels)}
        self.active_z_sector = int(metadata.get("active_z_sector", 0))
        if self.basis_mode == "subsector16":
            if self.active_z_sector != 0:
                raise ValueError("subsector16 metadata must use active_z_sector=0")
            self.active_z_coefficient = acb(1)
        else:
            if self.active_z_sector not in {1, 2, 3}:
                raise ValueError("top24 metadata requires active_z_sector in {1,2,3}")
            expected_z_powers = [0, 0, 0]
            expected_z_powers[self.active_z_sector - 1] = 1
            if any(
                [int(value) for value in key[5:]] != expected_z_powers
                for key in physical_basis_keys[:8]
            ):
                raise ValueError(
                    "top24 first block does not match the declared physical active-Z sector"
                )
            self.active_z_coefficient = self.cls[self.active_z_sector - 1]
        self.poles_at_epsilon0 = [
            acb(0),
            *[sign * 2 * iw for iw in self.iws for sign in (1, -1)],
        ]
        # `transport_epsilon_path` 读取上面的 regulator-neutral 协议属性。

    def _zero_biseries(self, k_taylor_order: int) -> list[list[acb_mat]]:
        """创建布局为 ``[epsilon power][k Taylor degree]`` 的 8x8 零矩阵表。"""

        return [
            [acb_mat(8, 8) for _ in range(k_taylor_order)]
            for _ in range(self.epsilon_order + 1)
        ]

    def _preinverse_block_series(
        self,
        center: acb,
        k_taylor_order: int,
    ) -> dict[str, list[list[acb_mat]]]:
        """直接数值生成 generic ``000/100/010/001`` preinverse 双级数。"""

        if k_taylor_order <= 0:
            raise ValueError("k_taylor_order must be positive")
        blocks = {
            axis: self._zero_biseries(k_taylor_order)
            for axis in ("000", "100", "010", "001")
        }
        identity8 = acb_mat(8, 8)
        for index in range(8):
            identity8[index, index] = acb(1)
        blocks["000"][0][0] -= identity8 * center
        if k_taylor_order > 1:
            blocks["000"][0][1] -= identity8

        if self.epsilon_order >= 1:
            blocks["010"][1][0] += identity8
        for row, label in enumerate(self.labels):
            blocks["100"][0][0][row, row] += -self.a_x_zero + sum(
                acb(value) * (1 - 2 * self.it0) for value in label
            )
            blocks["010"][0][0][row, row] += self.it1 * sum(
                self.iws,
                acb(0),
            )
            for leg, derivative_power in enumerate(label):
                iw0 = self.iws[leg]
                blocks["010"][0][0][row, row] += acb(derivative_power) * (
                    -1 - 2 * self.it1 * iw0
                )

                toggled = list(label)
                toggled[leg] = 1 - derivative_power
                column = self.label_positions[tuple(toggled)]
                if derivative_power == 0:
                    blocks["000"][0][0][row, column] += 1
                    continue

                blocks["000"][0][0][row, column] += iw0 * iw0

                x_constant = 1 - 2 * self.cls[leg] + self.it0
                x_linear = self.it1 * (2 * self.it0 - 1)
                blocks["100"][0][0][row, column] += x_constant + x_linear * iw0

                xm_constant = -1 + 2 * self.cls[leg] - self.it0
                xm_linear = self.it1 * (1 - 2 * self.it0)
                blocks["010"][0][0][row, column] += (
                    xm_constant + xm_linear * iw0 + 2 * iw0 * iw0
                )
        return blocks

    def _inverse_biseries_generic(
        self,
        block: list[list[acb_mat]],
        k_taylor_order: int,
    ) -> list[list[acb_mat]]:
        """在截断双级数环中递推矩阵逆，仅供独立回归检查。"""

        inverse = self._zero_biseries(k_taylor_order)
        identity8 = acb_mat(8, 8)
        for index in range(8):
            identity8[index, index] = acb(1)
        inverse[0][0] = block[0][0].solve(identity8)
        for k_degree in range(k_taylor_order):
            for epsilon_power in range(self.epsilon_order + 1):
                if k_degree == 0 and epsilon_power == 0:
                    continue
                total = acb_mat(8, 8)
                for left_k in range(k_degree + 1):
                    for left_epsilon in range(epsilon_power + 1):
                        if left_k == 0 and left_epsilon == 0:
                            continue
                        total += (
                            block[left_epsilon][left_k]
                            * inverse[epsilon_power - left_epsilon][k_degree - left_k]
                        )
                inverse[epsilon_power][k_degree] = -(inverse[0][0] * total)
        return inverse

    def _inverse_preinverse000_biseries(
        self,
        block: list[list[acb_mat]],
        k_taylor_order: int,
    ) -> list[list[acb_mat]]:
        """利用截断 ``(epsilon,k)`` 卷积结构递推矩阵逆。

        输入采用 ``[epsilon power][k Taylor degree]`` 布局。固定数值频率后，
        本路线的 ``000`` block 与 epsilon 无关且对 k 只含线性项；保留通用卷积
        写法是为了和完整矩阵输入接口交叉检查。
        """

        inverse = self._zero_biseries(k_taylor_order)
        identity8 = acb_mat(8, 8)
        for index in range(8):
            identity8[index, index] = acb(1)
        inverse000 = block[0][0].solve(identity8)
        inverse[0][0] = inverse000
        epsilon_linear = block[1][0] if self.epsilon_order >= 1 else None
        epsilon_quadratic = block[2][0] if self.epsilon_order >= 2 else None

        for k_degree in range(k_taylor_order):
            for epsilon_power in range(self.epsilon_order + 1):
                if k_degree == 0 and epsilon_power == 0:
                    continue
                right_hand_side = acb_mat(8, 8)
                if k_degree >= 1:
                    right_hand_side += inverse[epsilon_power][k_degree - 1]
                if epsilon_power >= 1:
                    right_hand_side -= (
                        epsilon_linear * inverse[epsilon_power - 1][k_degree]
                    )
                if epsilon_power >= 2:
                    right_hand_side -= (
                        epsilon_quadratic * inverse[epsilon_power - 2][k_degree]
                    )
                inverse[epsilon_power][k_degree] = inverse000 * right_hand_side
        return inverse

    def _multiply_biseries(
        self,
        left: list[list[acb_mat]],
        right: list[list[acb_mat]],
        k_taylor_order: int,
    ) -> list[list[acb_mat]]:
        """卷积两个同截断范围的 8×8 双级数。"""

        product = self._zero_biseries(k_taylor_order)
        for k_degree in range(k_taylor_order):
            for epsilon_power in range(self.epsilon_order + 1):
                total = acb_mat(8, 8)
                for left_k in range(k_degree + 1):
                    for left_epsilon in range(epsilon_power + 1):
                        total += (
                            left[left_epsilon][left_k]
                            * right[epsilon_power - left_epsilon][k_degree - left_k]
                        )
                product[epsilon_power][k_degree] = total
        return product

    def _assemble_de_matrix(
        self,
        left: acb_mat,
        right: acb_mat,
        add_identity: bool,
        z_block: acb_mat | None = None,
    ) -> acb_mat:
        """按 16/24 维物理 basis 顺序组装 k-DE 矩阵。"""

        if self.basis_mode == "subsector16":
            return acb_mat(
                [
                    [
                        (
                            left[row % 8, column]
                            if column < 8
                            else right[row % 8, column - 8]
                            + (
                                acb(1)
                                if add_identity
                                and row >= 8
                                and row - 8 == column - 8
                                else acb(0)
                            )
                        )
                        for column in range(16)
                    ]
                    for row in range(16)
                ]
            )

        if z_block is None:
            raise ValueError("top24 DE assembly requires the active-Z source block")
        inverse_two_z = acb(1) / (acb(2) * self.active_z_coefficient)
        z_diagonal = acb(1) + acb(3) * inverse_two_z
        rows: list[list[acb]] = []
        for row in range(24):
            source_row = row % 8
            values: list[acb] = []
            for column in range(24):
                block = column // 8
                source_column = column % 8
                if row < 8:
                    base = (z_block, left, right)[block][source_row, source_column]
                    value = base * inverse_two_z
                    if add_identity and block == 0 and source_row == source_column:
                        value += z_diagonal
                else:
                    value = (z_block, left, right)[block][source_row, source_column]
                    if (
                        add_identity
                        and row >= 16
                        and block == 2
                        and source_row == source_column
                    ):
                        value += acb(1)
                values.append(value)
            rows.append(values)
        return acb_mat(rows)

    def taylor_matrix_coefficients(
        self,
        center: acb,
        solution_order: int,
    ) -> list[list[acb_mat]]:
        """返回 ``A[epsilon_power][k_taylor_degree]`` 供 regulator-jet 后端调用。"""

        blocks = self._preinverse_block_series(center, solution_order)
        inverse000 = self._inverse_preinverse000_biseries(
            blocks["000"],
            solution_order,
        )
        de_left = self._multiply_biseries(
            inverse000,
            blocks["010"],
            solution_order,
        )
        de_right = self._multiply_biseries(
            inverse000,
            blocks["100"],
            solution_order,
        )
        de_z = self._multiply_biseries(
            inverse000,
            blocks["001"],
            solution_order,
        )
        return [
            [
                self._assemble_de_matrix(
                    de_left[epsilon_power][k_degree],
                    de_right[epsilon_power][k_degree],
                    epsilon_power == 0 and k_degree == 0,
                    de_z[epsilon_power][k_degree],
                )
                for k_degree in range(solution_order)
            ]
            for epsilon_power in range(self.epsilon_order + 1)
        ]


def _constant_epsilon_series(value: acb, epsilon_order: int) -> acb_series:
    """把 Acb 常数提升为指定截断阶数的 epsilon 级数。"""

    return acb_series([value], epsilon_order + 1)


def watson_epsilon_boundary_coefficients(
    system_payload: dict[str, Any],
    *,
    k_start: acb,
    taylor_order: int,
    epsilon_order: int,
    it0: int,
    it1: int,
) -> tuple[list[acb_mat], float]:
    """构造 fixed-EC QNM Watson 边界的解析 epsilon 系数。

    单腿 QNM 解与频率均不随 epsilon 改变；horizon regulator 只把每个积分分量的
    Laplace/Gamma 指数从 ``sigma`` 平移为 ``sigma+epsilon``。
    """

    required = {"physical_basis_keys", "numeric_point"}
    missing = sorted(required.difference(system_payload))
    if missing:
        raise ValueError(f"epsilon Watson payload is missing fields: {missing}")
    if taylor_order < 0 or epsilon_order < 0:
        raise ValueError("Watson Taylor/epsilon orders must be nonnegative")
    clock = time.perf_counter()
    point = system_payload["numeric_point"]
    iws_scalar = [
        exact_inputform_to_acb(point["iw1"]),
        exact_inputform_to_acb(point["iw2"]),
        exact_inputform_to_acb(point["iw3"]),
    ]
    if not abs(iws_scalar[2] - iws_scalar[1] - iws_scalar[0]).contains(0):
        raise ValueError("epsilon Watson boundary requires exact EC frequencies")
    iws = [_constant_epsilon_series(value, epsilon_order) for value in iws_scalar]
    cls = [exact_inputform_to_acb(point[f"cl2{leg}"]) for leg in range(1, 4)]
    leg_u = [
        _cu_qnm_bc_epsilon_series(
            iw,
            lam,
            taylor_order + 2,
            epsilon_order,
            it0=it0,
            it1=it1,
        )
        for iw, lam in zip(iws, cls)
    ]
    leg_du = [_derivative_series(coefficients) for coefficients in leg_u]
    z_value = acb(1) / k_start
    iw_sum = sum(iws, _constant_epsilon_series(acb(0), epsilon_order))
    epsilon_series = (
        acb_series([acb(0), acb(1)], epsilon_order + 1)
        if epsilon_order >= 1
        else _constant_epsilon_series(acb(0), 0)
    )
    component_series: list[acb_series] = []
    for key in system_payload["physical_basis_keys"]:
        n_values = key[:3]
        a_x, a_x_minus_one = key[3:5]
        z_powers = key[5:]
        active_legs = [index for index, power in enumerate(z_powers) if power != 0]
        if len(active_legs) > 1:
            raise ValueError(f"multiple active Z factors are unsupported: {key}")
        x_factor = [
            _constant_epsilon_series(value, epsilon_order)
            for value in _integer_binomial_series(-a_x, taylor_order)
        ]
        if not active_legs:
            z_factor = [_constant_epsilon_series(acb(1), epsilon_order)] + [
                _constant_epsilon_series(acb(0), epsilon_order)
                for _ in range(taylor_order)
            ]
        else:
            active_leg = active_legs[0]
            z_power = z_powers[active_leg]
            z_horizon = 3 + 2 * cls[active_leg]
            ratio = 2 * cls[active_leg] / z_horizon
            z_factor = [
                _constant_epsilon_series(
                    coefficient * ratio**degree * z_horizon ** (-z_power),
                    epsilon_order,
                )
                for degree, coefficient in enumerate(
                    _integer_binomial_series(-z_power, taylor_order)
                )
            ]
        modes = [
            leg_u[leg] if n_values[leg] == 0 else leg_du[leg]
            for leg in range(3)
        ]
        endpoint = _multiply_taylor_series_over_epsilon(
            [x_factor, z_factor, *modes],
            taylor_order,
            epsilon_order,
        )
        sigma = it1 * iw_sum - a_x_minus_one + epsilon_series
        component = _constant_epsilon_series(acb(0), epsilon_order)
        for degree in range(taylor_order + 1):
            gamma_argument = sigma + degree + 1
            if abs(gamma_argument[0]).contains(0):
                raise ArithmeticError(
                    f"epsilon Watson Gamma argument contains zero for {key}, degree {degree}"
                )
            laplace_power = (gamma_argument * z_value.log()).exp()
            component += endpoint[degree] * gamma_argument.gamma() * laplace_power
        component_series.append(component)
    coefficients = [
        acb_mat([[component[power]] for component in component_series])
        for power in range(epsilon_order + 1)
    ]
    return coefficients, time.perf_counter() - clock


def solve_epsilon_regular_path(
    metadata: dict[str, Any],
    path: list[acb],
    *,
    epsilon_order: int,
    k_taylor_order: int,
    watson_taylor_order: int,
    it0: int,
    it1: int,
    a_x_zero: int,
) -> EpsilonRegularTransportResult:
    """从解析 Watson 边界沿 ``path`` 输运全部 epsilon 系数。"""

    if len(path) < 2:
        raise ValueError("path must contain at least two k points")
    system = FlintLocalEpsilonPreinverseSystem(
        metadata,
        epsilon_order=epsilon_order,
        it0=it0,
        it1=it1,
        a_x_zero=a_x_zero,
    )
    boundary, boundary_seconds = watson_epsilon_boundary_coefficients(
        metadata,
        k_start=path[0],
        taylor_order=watson_taylor_order,
        epsilon_order=epsilon_order,
        it0=it0,
        it1=it1,
    )
    snapshots, reports, transport_seconds = transport_epsilon_path(
        system,
        boundary,
        path,
        k_taylor_order,
    )
    return EpsilonRegularTransportResult(
        boundary_vectors=boundary,
        snapshots=snapshots,
        segment_reports=reports,
        boundary_seconds=boundary_seconds,
        transport_seconds=transport_seconds,
    )


def _stack_epsilon_vectors(vectors: list[acb_mat]) -> acb_mat:
    """按 epsilon 幂次由低到高堆叠等长列向量。"""

    if not vectors:
        raise ValueError("epsilon vector list must not be empty")
    dimension = vectors[0].nrows()
    if any(vector.ncols() != 1 or vector.nrows() != dimension for vector in vectors):
        raise ValueError("epsilon vectors must be equal-sized columns")
    return acb_mat(
        [[vector[row, 0]] for vector in vectors for row in range(dimension)]
    )


def fit_epsilon_k0_local_basis(
    local_basis: EpsilonK0NilpotentLocalBasis,
    sample_points: Sequence[acb],
    sample_vectors: Sequence[list[acb_mat]],
) -> EpsilonK0FitResult:
    """用三个或更多普通点拟合、验证同一个 ``k=0`` power-log 局部基。

    第一个点确定结果常数，第二个点独立确定稳定性常数，其余点只验证第一组常数。
    每个普通点必须提供从 ``epsilon^0`` 到 ``epsilon^P`` 的完整 16 维列向量。
    """

    if len(sample_points) < 3 or len(sample_points) != len(sample_vectors):
        raise ValueError("k0 local fit requires equally sized lists with at least three samples")
    expected_count = local_basis.regulator_order + 1
    if any(len(vectors) != expected_count for vectors in sample_vectors):
        raise ValueError("sample vectors do not cover the local-basis epsilon order")

    import time

    local_matrices = [local_basis.evaluate(point) for point in sample_points]
    stacked_vectors = [_stack_epsilon_vectors(vectors) for vectors in sample_vectors]
    fit_clock = time.perf_counter()
    constants = local_matrices[0].solve(stacked_vectors[0])
    stability_constants = local_matrices[1].solve(stacked_vectors[1])
    validation_errors = [
        relative_difference_inf(matrix * constants, vector)
        for matrix, vector in zip(local_matrices[1:], stacked_vectors[1:])
    ]
    finite_parts = [
        local_basis.finite_part_matrix(power) * constants
        for power in range(expected_count)
    ]
    stability_parts = [
        local_basis.finite_part_matrix(power) * stability_constants
        for power in range(expected_count)
    ]
    stability_errors = [
        relative_difference_inf(primary, reference)
        for primary, reference in zip(finite_parts, stability_parts)
    ]
    return EpsilonK0FitResult(
        constants=constants,
        stability_constants=stability_constants,
        finite_part_vectors=finite_parts,
        validation_errors=validation_errors,
        stability_errors=stability_errors,
        fit_seconds=time.perf_counter() - fit_clock,
    )


def _epsilon_payload_for_jet_backend(payload: dict[str, Any]) -> dict[str, Any]:
    """把公开 epsilon schema 映射到共享 regulator-jet 后端的内部字段。"""

    required = {"epsilon_order", "epsilon_coefficients"}
    missing = sorted(required.difference(payload))
    if missing:
        raise ValueError(f"epsilon rational payload is missing fields: {missing}")
    records = []
    for record in payload["epsilon_coefficients"]:
        converted = dict(record)
        converted["regulator_power"] = int(record["epsilon_power"])
        records.append(converted)
    converted_payload = dict(payload)
    converted_payload["regulator_order"] = int(payload["epsilon_order"])
    converted_payload["regulator_coefficients"] = records
    return converted_payload


def solve_epsilon_k0_finite_parts(
    metadata: dict[str, Any],
    rational_payload: dict[str, Any],
    path: list[acb],
    sample_positions: Sequence[int],
    *,
    epsilon_order: int,
    k_taylor_order: int,
    watson_taylor_order: int,
    k0_series_order: int,
    it0: int,
    it1: int,
    a_x_zero: int,
) -> EpsilonK0MatchResult:
    """输运 ``I_0..I_P``，并在三个近零常点匹配 ``k=0`` power-log 基。

    第一个 sample 用于求齐次常数，第二个独立重求常数并检查有限部稳定性，其余
    sample 只验证局部级数。payload 必须至少覆盖请求的 ``epsilon_order``；任何身份、
    维数或阶数不一致都直接阻断。
    """

    if len(sample_positions) < 3:
        raise ValueError("k0 matching requires at least three sample positions")
    if any(position < 0 or position >= len(path) for position in sample_positions):
        raise ValueError("k0 sample position is outside the transport path")
    for key, expected in (
        ("dimension", 16),
        ("it0", it0),
        ("it1", it1),
        ("a_x_zero", a_x_zero),
    ):
        if int(rational_payload[key]) != expected:
            raise ValueError(
                f"rational payload {key}={rational_payload[key]!r}, expected {expected!r}"
            )
    if int(rational_payload["epsilon_order"]) < epsilon_order:
        raise ValueError("rational payload does not cover the requested epsilon order")

    regular = solve_epsilon_regular_path(
        metadata,
        path,
        epsilon_order=epsilon_order,
        k_taylor_order=k_taylor_order,
        watson_taylor_order=watson_taylor_order,
        it0=it0,
        it1=it1,
        a_x_zero=a_x_zero,
    )
    rational_system = FlintEpsilonRationalSystem.from_payload(
        _epsilon_payload_for_jet_backend(rational_payload)
    )
    local_basis, local_seconds = build_epsilon_k0_nilpotent_local_basis(
        rational_system,
        solution_regulator_order=epsilon_order,
        series_order=k0_series_order,
    )
    sample_vectors = [
        _stack_epsilon_vectors(regular.snapshots[position])
        for position in sample_positions
    ]
    # 局部拟合统一走预计算向量接口；完整 scalar 的有限部仍由上层统一提取。
    fit = fit_epsilon_k0_local_basis(
        local_basis,
        [path[position] for position in sample_positions],
        [regular.snapshots[position] for position in sample_positions],
    )
    maximum_error = max(
        [
            *(arb_midpoint_float(error) for error in local_basis.compatibility_residuals),
            *(arb_midpoint_float(error) for error in fit.validation_errors),
            *(arb_midpoint_float(error) for error in fit.stability_errors),
        ],
        default=0.0,
    )
    if not maximum_error < 1.0:
        raise ArithmeticError(f"epsilon k0 matching is numerically unstable: {maximum_error}")
    return EpsilonK0MatchResult(
        regular_transport=regular,
        local_basis=local_basis,
        constants=fit.constants,
        stability_constants=fit.stability_constants,
        finite_part_vectors=fit.finite_part_vectors,
        validation_errors=fit.validation_errors,
        stability_errors=fit.stability_errors,
        local_basis_seconds=local_seconds,
        fit_seconds=fit.fit_seconds,
    )
