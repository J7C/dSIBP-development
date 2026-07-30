"""高阶 pole 的 exact Moser 降阶、指数广义幂级数及失败门禁测试。

测试覆盖非对角和非交换 projector 制造的表观高阶 pole、严格标量指数 sector、奇点
起点边界以及 ``k=0`` 不能替代缺失 formal gauge 的反例。每条可执行路线都与原方程
或绕开奇点的普通点路径交叉验证。
"""

from __future__ import annotations

import unittest
import warnings

from flint import acb, acb_mat, arb

from flintnde import (
    LocalReductionError,
    NamedPoint,
    RationalMatrixSystem,
    attempt_fuchsian_reduction,
    build_adaptive_path,
    build_adaptive_path_plan,
    build_local_solution_basis,
    column_vector,
    configure_working_precision,
    frobenius_boundary,
    rational_function,
    transport_path,
)


def _forward_diagonal_shearing(
    fuchsian_system: RationalMatrixSystem,
    exponents: tuple[int, ...],
) -> RationalMatrixSystem:
    """独立正向构造 ``I=diag(t**n_i)J`` 对应的原始高阶-pole 系统。

    测试只使用数学正向公式 ``A=S B S^-1+S' S^-1``，不调用包内降阶
    变换生成 expected；因此自动逆变换后的完整矩阵可与输入 ``B`` 严格比较。
    """

    if fuchsian_system.dimension != len(exponents):
        raise ValueError("forward shearing exponent dimension mismatch")
    coordinate = rational_function((0, 1))
    rows = []
    for row in range(fuchsian_system.dimension):
        output_row = []
        for column in range(fuchsian_system.dimension):
            value = fuchsian_system.entries[row][column] * (
                coordinate ** (exponents[row] - exponents[column])
            )
            if row == column and exponents[row] != 0:
                value += exponents[row] / coordinate
            output_row.append(value)
        rows.append(tuple(output_row))
    return RationalMatrixSystem(
        tuple(rows),
        name=f"forward-sheared-{fuchsian_system.name}",
    )


def _constant_similarity(
    system: RationalMatrixSystem,
    basis: tuple[tuple[int, ...], ...],
    inverse_basis: tuple[tuple[int, ...], ...],
) -> RationalMatrixSystem:
    """独立计算 ``P A P^-1``，避免用被测常数换基接口生成输入。"""

    dimension = system.dimension
    rows = []
    for row in range(dimension):
        output_row = []
        for column in range(dimension):
            value = rational_function(0)
            for left in range(dimension):
                for right in range(dimension):
                    value += (
                        basis[row][left]
                        * system.entries[left][right]
                        * inverse_basis[right][column]
                    )
            output_row.append(value)
        rows.append(tuple(output_row))
    return RationalMatrixSystem(tuple(rows), name=f"mixed-{system.name}")


def _forward_mixed_shearing(
    fuchsian_system: RationalMatrixSystem,
    exponents: tuple[int, ...],
    basis: tuple[tuple[int, ...], ...],
    inverse_basis: tuple[tuple[int, ...], ...],
) -> RationalMatrixSystem:
    """用非对角 ``T=P diag(t**n_i)`` 正向制造原始高阶-pole 系统。"""

    aligned = _forward_diagonal_shearing(fuchsian_system, exponents)
    return _constant_similarity(aligned, basis, inverse_basis)


def _constant_acb_matrix(records: list[list[int]]) -> acb_mat:
    """把小整数记录转换为测试解析解所需的 Acb 常数矩阵。"""

    return acb_mat([[acb(value) for value in row] for row in records])


def _mixed_basis_matrix(
    basis: tuple[tuple[int, ...], ...],
    exponents: tuple[int, ...],
    point: acb,
) -> acb_mat:
    """独立计算已知正向变换 ``T(t)=P diag(t**n_i)``。"""

    constant = _constant_acb_matrix([list(row) for row in basis])
    diagonal = acb_mat(len(exponents), len(exponents))
    for index, exponent in enumerate(exponents):
        diagonal[index, index] = point**exponent
    return constant * diagonal


class HighPoleLocalTest(unittest.TestCase):
    """验证高阶 pole 的三级调度和原始积分基输出。"""

    @classmethod
    def setUpClass(cls) -> None:
        """为指数 sector 条件数和绕行输运固定 70 位十进制工作精度。"""

        configure_working_precision(70, 32)

    def test_exact_shearing_bridge_matches_detour_and_original_solution(self) -> None:
        """表观二阶 pole 应降为 simple pole，并在原始积分基返回结果。"""

        system = RationalMatrixSystem(
            (
                (0, rational_function(1, [0, 0, 1])),
                (0, 0),
            ),
            name="off-diagonal-double-pole",
        )
        with warnings.catch_warnings():
            warnings.simplefilter("ignore")
            bridge_path = build_adaptive_path(
                system,
                NamedPoint("left", -1),
                NamedPoint("right", 1),
                max_step_over_radius=0.25,
            )
            detour_path = build_adaptive_path(
                system,
                NamedPoint("left", -1),
                NamedPoint("right", 1),
                detour_points=(NamedPoint("upper", acb(0, "1/2")),),
                max_step_over_radius=0.25,
            )
        initial = column_vector([1, 2])
        bridge = transport_path(system, initial, bridge_path, order=40, sample_count=128)
        detour = transport_path(system, initial, detour_path, order=40, sample_count=128)
        self.assertTrue(
            any(report["method"] == "fuchsian_reduced_power_log_bridge" for report in bridge[1])
        )
        self.assertLess(float(abs(bridge[0][-1][0, 0] + 3).mid()), 1.0e-11)
        self.assertLess(float(abs(bridge[0][-1][1, 0] - 2).mid()), 1.0e-12)
        for row in range(2):
            self.assertLess(
                float(abs(bridge[0][-1][row, 0] - detour[0][-1][row, 0]).mid()),
                1.0e-11,
            )

    def test_forward_generated_2x2_apparent_high_pole_reduces_exactly(self) -> None:
        """非对角 2x2 混合基制造的二阶 pole 应自动寻找常数基并降阶。"""

        coordinate = rational_function((0, 1))
        inverse_coordinate = 1 / coordinate
        residue = ((1, 2), (0, 3))
        regular = ((2, 8), (0, 10))
        fuchsian = RationalMatrixSystem(
            tuple(
                tuple(residue[row][column] * inverse_coordinate + regular[row][column]
                      for column in range(2))
                for row in range(2)
            ),
            name="known-fuchsian-2x2",
        )
        original = _forward_mixed_shearing(
            fuchsian,
            (0, 1),
            ((1, 1), (1, 2)),
            ((2, -1), (-1, 1)),
        )

        self.assertEqual(original.pole_order_at(0), 2)
        high_pole_positions = [
            (row, column)
            for row in range(2)
            for column in range(2)
            if original.entries[row][column].pole_order_at(0) >= 2
        ]
        self.assertTrue(any(row == column for row, column in high_pole_positions))
        self.assertTrue(any(row != column for row, column in high_pole_positions))
        reduction = attempt_fuchsian_reduction(original, 0)
        self.assertEqual(reduction.status, "reduced_to_fuchsian")
        self.assertEqual(reduction.reduced_pole_order, 1)
        self.assertEqual(
            reduction.transformation.to_json()["route"],
            "exact_lee_moser_projector_balance",
        )

        basis_records = ((1, 1), (1, 2))
        exponents = (0, 1)
        initial = column_vector([2, -1])
        with warnings.catch_warnings():
            warnings.simplefilter("ignore")
            original_path = build_adaptive_path(
                original,
                NamedPoint("left", -1),
                NamedPoint("right", 1),
                max_step_over_radius=0.25,
            )
            direct_path = build_adaptive_path(
                fuchsian,
                NamedPoint("left", -1),
                NamedPoint("right", 1),
                max_step_over_radius=0.25,
            )
        direct_initial = _mixed_basis_matrix(
            basis_records, exponents, acb(-1)
        ).solve(initial)
        automatic = transport_path(
            original, initial, original_path, order=40, sample_count=128
        )
        direct = transport_path(
            fuchsian, direct_initial, direct_path, order=40, sample_count=128
        )
        direct_in_original_basis = (
            _mixed_basis_matrix(basis_records, exponents, acb(1)) * direct[0][-1]
        )
        for row in range(2):
            self.assertLess(
                float(
                    abs(
                        automatic[0][-1][row, 0]
                        - direct_in_original_basis[row, 0]
                    ).mid()
                ),
                1.0e-11,
            )

    def test_forward_generated_3x3_apparent_high_poles_reduce_and_transport(self) -> None:
        """稠密 3x3 正向变换应消去二/三阶 pole，并在原积分基完成输运。"""

        coordinate = rational_function((0, 1))
        inverse_coordinate = 1 / coordinate
        residue = ((0, 1, 1), (0, 1, 1), (0, 0, 2))
        # C=R^2+I 与 residue 对易，使该 case 的绕行不存在额外共振 monodromy 歧义。
        regular = ((1, 1, 3), (0, 2, 3), (0, 0, 5))
        fuchsian = RationalMatrixSystem(
            tuple(
                tuple(residue[row][column] * inverse_coordinate + regular[row][column]
                      for column in range(3))
                for row in range(3)
            ),
            name="known-fuchsian-3x3",
        )
        basis_records = ((1, 1, 1), (1, 2, 2), (1, 2, 3))
        exponents = (0, 1, 2)
        original = _forward_mixed_shearing(
            fuchsian,
            exponents,
            basis_records,
            ((2, -1, 0), (-1, 2, -1), (0, -1, 1)),
        )

        self.assertEqual(original.pole_order_at(0), 3)
        high_pole_positions = [
            (row, column)
            for row in range(3)
            for column in range(3)
            if original.entries[row][column].pole_order_at(0) >= 2
        ]
        self.assertTrue(any(row == column for row, column in high_pole_positions))
        self.assertGreaterEqual(
            sum(row != column for row, column in high_pole_positions),
            2,
        )
        reduction = attempt_fuchsian_reduction(original, 0)
        self.assertEqual(reduction.status, "reduced_to_fuchsian")
        self.assertEqual(reduction.reduced_pole_order, 1)
        self.assertEqual(
            reduction.transformation.to_json()["route"],
            "exact_lee_moser_projector_balance",
        )

        with warnings.catch_warnings():
            warnings.simplefilter("ignore")
            bridge_path = build_adaptive_path(
                original,
                NamedPoint("left", -1),
                NamedPoint("right", 1),
                max_step_over_radius=0.25,
            )
            detour_path = build_adaptive_path(
                original,
                NamedPoint("left", -1),
                NamedPoint("right", 1),
                detour_points=(NamedPoint("upper", acb(0, "1/2")),),
                max_step_over_radius=0.25,
            )
            direct_path = build_adaptive_path(
                fuchsian,
                NamedPoint("left", -1),
                NamedPoint("right", 1),
                max_step_over_radius=0.25,
            )
        initial = column_vector([1, -2, 3])
        direct_initial = _mixed_basis_matrix(
            basis_records, exponents, acb(-1)
        ).solve(initial)
        bridge = transport_path(original, initial, bridge_path, order=40, sample_count=128)
        detour = transport_path(original, initial, detour_path, order=40, sample_count=128)
        direct = transport_path(
            fuchsian, direct_initial, direct_path, order=40, sample_count=128
        )
        direct_in_original_basis = (
            _mixed_basis_matrix(basis_records, exponents, acb(1)) * direct[0][-1]
        )
        self.assertTrue(
            any(report["method"] == "fuchsian_reduced_power_log_bridge"
                for report in bridge[1])
        )
        for row in range(3):
            self.assertLess(
                float(abs(bridge[0][-1][row, 0] - detour[0][-1][row, 0]).mid()),
                1.0e-10,
            )
            self.assertLess(
                float(
                    abs(
                        bridge[0][-1][row, 0]
                        - direct_in_original_basis[row, 0]
                    ).mid()
                ),
                1.0e-10,
            )

    def test_noncommuting_projector_sequence_reduces_and_round_trips(self) -> None:
        """两个不交换 balance 制造的稠密三阶 pole 应逐阶 exact 降到 simple pole。"""

        # 该输入由独立正向公式 T1 T2 生成后硬编码；Q1 Q2 != Q2 Q1，超出单个
        # 常数基对角幂次变换。分子/分母按 z 的升幂记录。
        original = RationalMatrixSystem(
            (
                (
                    rational_function((0, -3, 2, 8, -8, 2), (0, 0, 0, 1)),
                    rational_function((0, 3, -3, -2, 9, -8, 2), (0, 0, 0, 0, 1)),
                ),
                (
                    rational_function((-3, -1, 8, -2), (0, 1)),
                    rational_function((3, 1, -2, 8, -2), (0, 0, 1)),
                ),
            ),
            name="noncommuting-projector-apparent-pole",
        )
        coordinate = rational_function((0, 1))
        fuchsian = RationalMatrixSystem(
            ((1 / coordinate + 1, 2), (3, 4 / coordinate + 5)),
            name="noncommuting-projector-reference",
        )
        reduction = attempt_fuchsian_reduction(original, 0)
        self.assertEqual(reduction.status, "reduced_to_fuchsian")
        self.assertEqual(reduction.pole_order_history, (3, 2, 1))
        self.assertEqual(reduction.transformation.to_json()["balance_count"], 2)
        restored = reduction.transformation.restore_system(reduction.transformed_system)
        for row in range(2):
            for column in range(2):
                self.assertTrue(
                    (restored.entries[row][column] - original.entries[row][column]).is_zero
                )

        q1 = _constant_acb_matrix([[1, 1], [0, 0]])
        q2 = _constant_acb_matrix([[0, 0], [1, 1]])
        identity = _constant_acb_matrix([[1, 0], [0, 1]])

        def source_transformation(point: acb) -> acb_mat:
            """独立计算已知正向 ``T1(point) T2(point)``。"""

            return (identity - q1 + q1 / point) * (identity - q2 + q2 / point)

        initial = column_vector([2, -1])
        with warnings.catch_warnings():
            warnings.simplefilter("ignore")
            original_path = build_adaptive_path(
                original, NamedPoint("left", -1), NamedPoint("right", 1),
                max_step_over_radius=0.25,
            )
            direct_path = build_adaptive_path(
                fuchsian, NamedPoint("left", -1), NamedPoint("right", 1),
                max_step_over_radius=0.25,
            )
        direct_initial = source_transformation(acb(-1)).solve(initial)
        automatic = transport_path(original, initial, original_path, order=40, sample_count=128)
        direct = transport_path(fuchsian, direct_initial, direct_path, order=40, sample_count=128)
        expected = source_transformation(acb(1)) * direct[0][-1]
        for row in range(2):
            self.assertLess(
                float(abs(automatic[0][-1][row, 0] - expected[row, 0]).mid()),
                1.0e-10,
            )

    def test_moser_boundary_is_validated_in_original_basis(self) -> None:
        """原基 leading C 缺少的次阶分量应由完整 exact jet 自动补全。"""

        system = RationalMatrixSystem(
            ((0, rational_function(1, (0, 0, 1))), (0, 0)),
            name="original-basis-boundary-double-pole",
        )
        basis = build_local_solution_basis(system, 0, 8)
        constants, report = basis.resolve_boundary(
            frobenius_boundary([{"a": -1, "b": 0, "C": [-1, 0]}])
        )
        value = basis.evaluate(acb("1/2")) * constants.to_acb()
        self.assertLess(float(abs(value[0, 0] + 2).mid()), 1.0e-14)
        self.assertLess(float(abs(value[1, 0] - 1).mid()), 1.0e-14)
        self.assertEqual(
            report["term_resolutions"][0]["verification"],
            "exact_original_basis_power_log_jet",
        )

    def test_scalar_exponential_bridge_matches_detour(self) -> None:
        """``Y'=Y/t^2`` 应自动得到 ``exp(-1/t)`` 并与绕行一致。"""

        system = RationalMatrixSystem(
            ((rational_function(1, [0, 0, 1]),),),
            name="scalar-rank-one-irregular",
        )
        basis = build_local_solution_basis(system, 0, 24)
        self.assertEqual(basis.method, "exponential_power_log")
        exponent = basis.manifest["sectors"][0]["exponential"]
        self.assertEqual(exponent[0]["derivative_coefficient"], "1")
        self.assertEqual(exponent[0]["phi_coefficient"], "-1")

        with warnings.catch_warnings():
            warnings.simplefilter("ignore")
            bridge_path = build_adaptive_path(
                system,
                NamedPoint("left", -1),
                NamedPoint("right", 1),
                max_step_over_radius=0.25,
            )
            detour_path = build_adaptive_path(
                system,
                NamedPoint("left", -1),
                NamedPoint("right", 1),
                detour_points=(NamedPoint("upper", acb(0, "1/2")),),
                max_step_over_radius=0.25,
            )
        bridge = transport_path(
            system,
            column_vector([1]),
            bridge_path,
            order=40,
            sample_count=128,
        )
        detour = transport_path(
            system,
            column_vector([1]),
            detour_path,
            order=40,
            sample_count=128,
        )
        expected = (-acb(2)).exp()
        self.assertTrue(
            any(report["method"] == "exponential_power_log_bridge" for report in bridge[1])
        )
        self.assertLess(float(abs(bridge[0][-1][0, 0] - expected).mid()), 1.0e-12)
        self.assertLess(
            float(abs(bridge[0][-1][0, 0] - detour[0][-1][0, 0]).mid()),
            1.0e-12,
        )

    def test_three_distinct_exponential_sectors_transport_in_original_basis(self) -> None:
        """非对角输入基中的三个不同 ``exp(-k_i/t)`` sector 应各自成功输运。"""

        denominator = [0, 0, 1]
        # P diag(1,-2,3) P^-1 = [[1,-3,3],[0,-2,5],[0,0,3]]。
        leading = ((1, -3, 3), (0, -2, 5), (0, 0, 3))
        system = RationalMatrixSystem(
            tuple(
                tuple(rational_function(leading[row][column], denominator)
                      for column in range(3))
                for row in range(3)
            ),
            name="three-distinct-exponential-sectors",
        )
        basis = build_local_solution_basis(system, 0, 24)
        self.assertEqual(basis.method, "exponential_power_log")
        self.assertEqual(len(basis.manifest["sectors"]), 3)
        derivative_coefficients = sorted(
            sector["exponential"][0]["derivative_coefficient"]
            for sector in basis.manifest["sectors"]
        )
        self.assertEqual(derivative_coefficients, ["-2", "1", "3"])

        transformation = _constant_acb_matrix([[1, 1, 0], [0, 1, 1], [0, 0, 1]])
        inverse = transformation.inv()
        constants = column_vector([1, 2, -1])

        def fundamental(point: acb) -> acb_mat:
            diagonal = acb_mat(3, 3)
            for index, coefficient in enumerate((1, -2, 3)):
                diagonal[index, index] = (-acb(coefficient) / point).exp()
            return transformation * diagonal * inverse

        initial = fundamental(acb(-1)) * constants
        expected = fundamental(acb(1)) * constants
        with warnings.catch_warnings():
            warnings.simplefilter("ignore")
            bridge_path = build_adaptive_path(
                system,
                NamedPoint("left", -1),
                NamedPoint("right", 1),
                max_step_over_radius=0.25,
            )
            detour_path = build_adaptive_path(
                system,
                NamedPoint("left", -1),
                NamedPoint("right", 1),
                detour_points=(NamedPoint("upper", acb(0, "1/2")),),
                max_step_over_radius=0.25,
            )
        bridge = transport_path(system, initial, bridge_path, order=40, sample_count=128)
        detour = transport_path(system, initial, detour_path, order=40, sample_count=128)
        self.assertTrue(
            any(report["method"] == "exponential_power_log_bridge" for report in bridge[1])
        )
        for row in range(3):
            self.assertLess(
                float(abs(bridge[0][-1][row, 0] - expected[row, 0]).mid()),
                1.0e-11,
            )
            self.assertLess(
                float(abs(bridge[0][-1][row, 0] - detour[0][-1][row, 0]).mid()),
                1.0e-11,
            )

    def test_irregular_start_infers_exponential_sector_from_C(self) -> None:
        """奇点起点沿用 ``{a,b,C}``，指数 sector 由 exact 领头向量自动识别。"""

        system = RationalMatrixSystem(
            ((rational_function(1, [0, 0, 1]),),),
            name="scalar-irregular-start",
        )
        with warnings.catch_warnings():
            warnings.simplefilter("ignore")
            path = build_adaptive_path(
                system,
                NamedPoint("irregular_start", 0),
                NamedPoint("target", 1),
                max_step_over_radius=0.25,
            )
        result = transport_path(
            system,
            frobenius_boundary([{"a": 0, "b": 0, "C": [1]}]),
            path,
            order=32,
            sample_count=96,
        )
        self.assertEqual(result[1][0]["method"], "exponential_power_log_boundary_initialization")
        self.assertEqual(
            result[1][0]["boundary"]["term_resolutions"][0]["inferred_sector"],
            1,
        )
        self.assertLess(
            float(abs(result[0][-1][0, 0] - (-acb(1)).exp()).mid()),
            1.0e-12,
        )

    def test_zero_k_does_not_hide_defective_high_order_matrix(self) -> None:
        """nilpotent 高阶项带反向耦合闭环时不能用 ``k=0`` 掩盖失败。"""

        system = RationalMatrixSystem(
            (
                (0, rational_function(1, [0, 0, 1])),
                (rational_function(1, [0, 1]), 0),
            ),
            name="nilpotent-leading-with-reverse-coupling",
        )
        with self.assertRaisesRegex(LocalReductionError, "defective"):
            build_local_solution_basis(system, 0, 8)

    def test_coupled_simple_sectors_use_start_only_formal_asymptotic(self) -> None:
        """低阶耦合的单重二阶-pole sector 应构造形式渐近基，但不得用于跨点。"""

        denominator = [0, 0, 1]
        system = RationalMatrixSystem(
            (
                (rational_function(1, denominator), 1),
                (0, rational_function(-1, denominator)),
            ),
            name="coupled-exponential-sectors",
        )
        basis = build_local_solution_basis(system, 0, 24)
        self.assertEqual(basis.method, "formal_exponential_asymptotic")
        self.assertFalse(basis.continuation_ready)
        constants, boundary = basis.resolve_boundary(
            frobenius_boundary([{"a": 0, "b": 0, "C": [0, 1]}])
        )
        self.assertEqual(boundary["term_resolutions"][0]["k_exact"], "-1")
        report = basis.evaluation_report(acb("1/20"))
        self.assertIsNotNone(report)
        self.assertEqual(
            report["schema"], "flintnde_formal_asymptotic_evaluation_v1"
        )
        self.assertEqual(constants.nrows, 2)

        with warnings.catch_warnings():
            warnings.simplefilter("ignore")
            path = build_adaptive_path(
                system,
                NamedPoint("irregular_start", 0),
                NamedPoint("target", "1/20"),
                max_step_over_radius=0.25,
            )
        result = transport_path(
            system,
            frobenius_boundary([{"a": 0, "b": 0, "C": [0, 1]}]),
            path,
            order=32,
            sample_count=96,
        )
        self.assertEqual(
            result[1][0]["method"],
            "formal_exponential_asymptotic_boundary_initialization",
        )
        self.assertIn("local_evaluation", result[1][0])

    def test_formal_five_order_metric_and_fixed_requested_order(self) -> None:
        """形式分支固定算到 N，并用前后五项矢量和之比报告趋势。"""

        system = RationalMatrixSystem(
            (
                (rational_function(1, [0, 0, 1]), 1),
                (0, rational_function(-1, [0, 0, 1])),
            ),
            name="formal-five-order-diagnostic",
        )
        report = build_local_solution_basis(system, 0, 24).evaluation_report(acb("1/20"))
        diagnostic = report["branch_diagnostics"][0]
        self.assertEqual(diagnostic["selected_truncation_degree"], 24)
        self.assertEqual(diagnostic["available_maximum_degree"], 29)
        self.assertEqual(
            diagnostic["five_order_block_ratio_definition"],
            "norm_inf(sum(T[N+1:N+6]))/norm_inf(sum(T[N-4:N+1]))",
        )
        explicit_ratio = arb(diagnostic["next_five_sum_norm"]) / arb(
            diagnostic["previous_five_sum_norm"]
        )
        self.assertTrue(
            (explicit_ratio - arb(diagnostic["next_five_over_previous_five"])).contains(0)
        )

    def test_formal_warning_keeps_result_for_user_selected_point(self) -> None:
        """用户选择过远匹配点时，五阶块不下降只警告而不阻断结果。"""

        system = RationalMatrixSystem(
            (
                (rational_function(1, [0, 0, 1]), 1),
                (0, rational_function(-1, [0, 0, 1])),
            ),
            name="formal-user-selected-match",
        )
        with warnings.catch_warnings():
            warnings.simplefilter("ignore")
            path = build_adaptive_path(
                system,
                NamedPoint("irregular_start", 0),
                NamedPoint("target", "3/10"),
                max_step_over_radius=0.25,
            )
        with self.assertWarnsRegex(UserWarning, "five-order block ratio"):
            result = transport_path(
                system,
                frobenius_boundary([{"a": 0, "b": 0, "C": [0, 1]}]),
                path,
                order=24,
                sample_count=96,
                target_relative_error="1e-8",
            )
        self.assertGreater(len(result[0]), 1)
        evaluation = result[1][0]["local_evaluation"]
        self.assertFalse(evaluation["formal_accuracy_checks_passed"])

    def test_formal_automatic_match_uses_root_gap_third_order(self) -> None:
        """自动建路用指数根差令 N 为预计最小项阶数的三分之一。"""

        system = RationalMatrixSystem(
            (
                (rational_function(1, [0, 0, 1]), 1),
                (0, rational_function(-1, [0, 0, 1])),
            ),
            name="formal-automatic-match",
        )
        with warnings.catch_warnings():
            warnings.simplefilter("ignore")
            path = build_adaptive_path(
                system,
                NamedPoint("irregular_start", 0),
                NamedPoint("target", "3/10"),
                max_step_over_radius=0.25,
                formal_asymptotic_order=24,
                formal_minimum_order_factor=3,
            )
        estimate = path.formal_asymptotic_match_estimate
        self.assertIsNotNone(estimate)
        self.assertEqual(estimate["minimum_order_factor"], 3)
        self.assertEqual(estimate["estimated_least_term_degree"], 72)
        self.assertEqual(
            estimate["late_term_model"],
            "n_min approximately abs(k_i-k_j)/abs(z)",
        )
        # 两指数根为 -1 与 1，故建议距离为 2/(3*24)=1/36。
        self.assertTrue((abs(path[0]) - arb("1/36")).contains(0))
        finite_ratios = [
            item["step_over_convergence_radius"]
            for item in path.step_reports
            if item["step_over_convergence_radius"] is not None
        ]
        self.assertLessEqual(max(finite_ratios), 0.25 + 1.0e-12)

    def test_formal_asymptotic_internal_point_requires_stokes_data(self) -> None:
        """同一形式渐近局部基作为内部点时必须在建路阶段 fail closed。"""

        system = RationalMatrixSystem(
            (
                (rational_function(1, [0, 0, 1]), 1),
                (0, rational_function(-1, [0, 0, 1])),
            ),
            name="internal-formal-rank-one-point",
        )
        with warnings.catch_warnings():
            warnings.simplefilter("ignore")
            with self.assertRaisesRegex(LocalReductionError, "Stokes"):
                build_adaptive_path(
                    system,
                    NamedPoint("left", -1),
                    NamedPoint("right", 1),
                    max_step_over_radius=0.25,
                )
            plan = build_adaptive_path_plan(
                system,
                NamedPoint("left", -1),
                NamedPoint("right", 1),
                max_step_over_radius=0.25,
            )
        self.assertFalse(plan.continuation_ready)
        self.assertTrue(any("start-only" in message for message in plan.messages))

    def test_path_plan_certifies_supported_exponential_high_pole(self) -> None:
        """规划器应预检指数局部基，并把可执行高阶 pole 标为 continuation-ready。"""

        system = RationalMatrixSystem(
            ((rational_function(1, [0, 0, 1]),),),
            name="planned-scalar-irregular",
        )
        with warnings.catch_warnings():
            warnings.simplefilter("ignore")
            plan = build_adaptive_path_plan(
                system,
                NamedPoint("left", -1),
                NamedPoint("right", 1),
                max_step_over_radius=0.25,
            )
        self.assertTrue(plan.continuation_ready)
        self.assertTrue(
            any("finite_001=exponential_power_log" in message for message in plan.messages)
        )

    def test_path_plan_reports_unsupported_zero_k_defective_block(self) -> None:
        """规划器必须记录 ``k=0`` defective 高阶块，而不是把它当作可穿越点。"""

        system = RationalMatrixSystem(
            (
                (0, rational_function(1, [0, 0, 1])),
                (rational_function(1, [0, 1]), 0),
            ),
            name="planned-defective-zero-k-reverse-coupling",
        )
        with warnings.catch_warnings():
            warnings.simplefilter("ignore")
            plan = build_adaptive_path_plan(
                system,
                NamedPoint("left", -1),
                NamedPoint("right", 1),
                max_step_over_radius=0.25,
            )
        self.assertFalse(plan.continuation_ready)
        self.assertTrue(any("defective" in message for message in plan.messages))


if __name__ == "__main__":
    unittest.main()
