#!/usr/bin/env python3
"""Acb patchwise transport for the project's 25D raw-basis system.

The Wolfram adapter exports the already physical, raw-basis column equation

    dY/dz = (C + sum_p R_p/(z-p)) Y,

together with a project-supplied initial vector.  The E2 true-infinity adapter
is one producer; the canonical soft-limit q pullback is another.  When the
optional ``frobenius_seeds`` payload is present, this module also performs the
purely numerical part of the true-infinity Frobenius construction.  The
project still supplies the physical Hankel/SK/pinch seeds; this module only
solves the indicial block cascade and coefficient recurrence in the fixed
Top/LeftPinch/RightPinch/DoublePinch ordering.

All numerical matrix arithmetic uses python-flint Acb/AcbMat.  SymPy is used
only to parse exact rational InputForm scalars exported by Wolfram Language.
"""

from __future__ import annotations

import argparse
import json
import math
import time
from dataclasses import dataclass
from pathlib import Path
from typing import Any

import sympy as sp
from flint import acb, acb_mat, arb, ctx, fmpq


def configure_working_precision(decimal_digits: int, guard_bits: int = 32) -> int:
    """Set the global Acb precision and return the resulting bit precision."""

    if decimal_digits <= 0 or guard_bits < 0:
        raise ValueError("working precision must be positive and guard bits nonnegative")
    ctx.prec = math.ceil(decimal_digits * math.log2(10)) + guard_bits
    return ctx.prec


def _rational_to_fmpq(value: sp.Expr) -> fmpq:
    rational = sp.cancel(value)
    if not isinstance(rational, sp.Rational):
        raise ValueError(f"expected exact rational scalar, got {rational}")
    return fmpq(int(rational.p), int(rational.q))


def exact_inputform_expression(value: Any) -> sp.Expr:
    """Parse one exact Wolfram InputForm rational/complex-rational scalar."""

    expression = sp.expand(sp.sympify(str(value), locals={"I": sp.I}))
    if not bool(expression.is_number):
        raise ValueError(f"non-numeric exact scalar: {value}")
    return expression


def exact_inputform_to_acb(value: Any) -> acb:
    expression = exact_inputform_expression(value)
    return acb(
        _rational_to_fmpq(sp.re(expression)),
        _rational_to_fmpq(sp.im(expression)),
    )


def decimal_record_to_acb(record: dict[str, Any]) -> acb:
    """Read a decimal complex record without passing through binary float."""

    if not isinstance(record, dict) or "re" not in record or "im" not in record:
        raise ValueError(f"invalid decimal complex record: {record}")
    return acb(arb(str(record["re"])), arb(str(record["im"])))


def arb_midpoint_float(value: arb) -> float:
    return float(value.mid())


def arb_record(value: arb, digits: int = 40) -> str:
    return str(value.str(digits))


def acb_record(value: acb, digits: int = 50) -> dict[str, str]:
    return {
        "re": value.real.str(digits, radius=False),
        "im": value.imag.str(digits, radius=False),
        "re_ball": value.real.str(digits),
        "im_ball": value.imag.str(digits),
    }


def acb_midpoint_record(value: acb, digits: int = 50) -> dict[str, str]:
    """Compact complex midpoint record for reusable Taylor coefficients."""

    return {
        "re": value.real.str(digits, radius=False),
        "im": value.imag.str(digits, radius=False),
    }


def vector_records(vector: acb_mat, digits: int = 50) -> list[dict[str, str]]:
    if vector.ncols() != 1:
        raise ValueError("vector serialization requires a column vector")
    return [acb_record(vector[row, 0], digits) for row in range(vector.nrows())]


def coefficient_records(
    coefficients: list[acb_mat], digits: int = 50
) -> list[list[dict[str, str]]]:
    """Serialize local solution-vector Taylor coefficients for later reuse."""

    return [
        [
            acb_midpoint_record(coefficient[row, 0], digits)
            for row in range(coefficient.nrows())
        ]
        for coefficient in coefficients
    ]


def column_vector(values: list[acb]) -> acb_mat:
    return acb_mat([[value] for value in values])


def identity_matrix(dimension: int) -> acb_mat:
    return acb_mat(
        [
            [acb(1 if row == column else 0) for column in range(dimension)]
            for row in range(dimension)
        ]
    )


def matrix_block(
    matrix: acb_mat, rows: range | list[int], columns: range | list[int]
) -> acb_mat:
    return acb_mat([[matrix[row, column] for column in columns] for row in rows])


def matrix_from_columns(columns: list[acb_mat]) -> acb_mat:
    if not columns:
        raise ValueError("at least one column is required")
    row_count = columns[0].nrows()
    if any(column.nrows() != row_count or column.ncols() != 1 for column in columns):
        raise ValueError("column dimensions do not match")
    return acb_mat(
        [
            [column[row, column_index] for column_index, column in enumerate(columns)]
            for row in range(row_count)
        ]
    )


def matrix_column(matrix: acb_mat, column: int) -> acb_mat:
    return acb_mat([[matrix[row, column]] for row in range(matrix.nrows())])


def sum_matrix_columns(matrix: acb_mat) -> acb_mat:
    return acb_mat(
        [
            [sum((matrix[row, column] for column in range(matrix.ncols())), acb(0))]
            for row in range(matrix.nrows())
        ]
    )


def join_sector_columns(
    top: acb_mat, left: acb_mat, right: acb_mat, double: acb_mat
) -> acb_mat:
    column_count = top.ncols()
    if any(block.ncols() != column_count for block in (left, right, double)):
        raise ValueError("sector column counts do not match")
    return acb_mat(
        [
            [block[row, column] for column in range(column_count)]
            for block in (top, left, right, double)
            for row in range(block.nrows())
        ]
    )


def vector_norm_inf(vector: acb_mat) -> arb:
    if vector.ncols() != 1:
        raise ValueError("vector norm requires a column vector")
    magnitudes = [abs(vector[row, 0]) for row in range(vector.nrows())]
    if not magnitudes:
        return arb(0)
    return max(magnitudes, key=arb_midpoint_float)


def relative_difference_inf(primary: acb_mat, reference: acb_mat) -> arb:
    if primary.nrows() != reference.nrows() or primary.ncols() != reference.ncols():
        raise ValueError("relative-difference dimensions do not match")
    denominator = vector_norm_inf(reference)
    if denominator.contains(0):
        raise ZeroDivisionError("reference vector infinity norm contains zero")
    return vector_norm_inf(primary - reference) / denominator


def relative_residual_inf(residual: acb_mat, *scales: acb_mat) -> arb:
    denominator_candidates = [vector_norm_inf(scale) for scale in scales]
    denominator = max(denominator_candidates, key=arb_midpoint_float)
    if denominator.contains(0):
        return arb(0) if vector_norm_inf(residual).contains(0) else arb("+inf")
    return vector_norm_inf(residual) / denominator


def midpoint_matrix(matrix: acb_mat) -> acb_mat:
    """Reset interval wrapping between patches; truncation is tracked separately."""

    return acb_mat(
        [
            [
                acb(matrix[row, column].real.mid(), matrix[row, column].imag.mid())
                for column in range(matrix.ncols())
            ]
            for row in range(matrix.nrows())
        ]
    )


def one_vertex_seed_hypergeometric(
    power: acb,
    sign: int,
    energy: acb,
    kind: str,
    nu: acb,
    momentum: acb,
) -> acb_mat:
    """Evaluate the project's one-leg raw 2-vector by Gamma-2F1 formulas.

    This is the exact Laplace transform of ``ProjectRawOneVertexVector`` for
    one Hankel leg after the same Wick rotation.  The component order is the
    unchanged raw derivative-index order ``{0, 1}``.
    """

    if sign not in (-1, 1):
        raise ValueError("one-vertex sign must be +1 or -1")
    if kind not in ("H1", "H2"):
        raise ValueError("one-vertex Hankel kind must be H1 or H2")
    if energy.contains(0):
        raise ZeroDivisionError("one-vertex energy contains zero")

    imaginary = acb(0, 1)
    pi = acb.pi()
    two = acb(2)
    wick_ratio = -imaginary * acb(sign) * momentum / energy
    z = (momentum / energy) ** 2
    csc = acb(1) / (pi * nu).sin()
    phase = (-imaginary * acb(sign) / energy) * (
        -imaginary * acb(sign) / energy
    ) ** power

    def gamma_regularized_2f1(a: acb, c: acb) -> acb:
        return a.gamma() * z.hypgeom_2f1(
            a / two, (acb(1) + a) / two, c, regularized=True
        )

    if kind == "H1":
        first_kind_phase = imaginary * (-imaginary * pi * nu).exp()
        derivative_kind_phase = -imaginary * (-imaginary * pi * nu).exp()
        second_branch_phase = -imaginary
    else:
        first_kind_phase = -imaginary * (imaginary * pi * nu).exp()
        derivative_kind_phase = imaginary * (imaginary * pi * nu).exp()
        second_branch_phase = imaginary

    a00 = power + acb(1)
    a01 = power - two * nu + acb(1)
    component0 = phase * csc * (
        first_kind_phase
        * two ** (-nu)
        * gamma_regularized_2f1(a00, nu + acb(1))
        + second_branch_phase
        * two**nu
        * wick_ratio ** (-two * nu)
        * gamma_regularized_2f1(a01, acb(1) - nu)
    )

    a10 = power + two
    a11 = power - two * nu
    component1 = phase * csc * (
        derivative_kind_phase
        * two ** (-nu - acb(1))
        * wick_ratio
        * gamma_regularized_2f1(a10, nu + two)
        + second_branch_phase
        * two ** (nu + acb(1))
        * wick_ratio ** (-two * nu - acb(1))
        * gamma_regularized_2f1(a11, -nu)
    )
    return column_vector([component0, component1])


def solve_one_vertex_seed_payload(
    payload: dict[str, Any], *, decimal_digits: int, guard_bits: int
) -> dict[str, Any]:
    bit_precision = configure_working_precision(decimal_digits, guard_bits)
    clock = time.perf_counter()
    required = {"power", "sign", "energy", "kind", "nu", "momentum"}
    missing = sorted(required.difference(payload))
    if missing:
        raise ValueError(f"one-vertex payload is missing fields: {missing}")
    vector = one_vertex_seed_hypergeometric(
        decimal_record_to_acb(payload["power"]),
        int(payload["sign"]),
        decimal_record_to_acb(payload["energy"]),
        str(payload["kind"]),
        decimal_record_to_acb(payload["nu"]),
        decimal_record_to_acb(payload["momentum"]),
    )
    return {
        "status": "passed",
        "operation": "one_vertex_seed",
        "request_id": str(payload.get("request_id", "one_vertex_seed")),
        "component_order": [0, 1],
        "working_precision_decimal_digits": decimal_digits,
        "working_precision_bits": bit_precision,
        "guard_bits": guard_bits,
        "raw_vector_2": vector_records(vector, decimal_digits),
        "elapsed_seconds": time.perf_counter() - clock,
    }


@dataclass(frozen=True)
class SegmentGeometry:
    index: int
    start: acb
    target: acb
    nearest_pole: acb
    radius: arb
    step_ratio: arb


class FlintPoleResidueSystem:
    """Acb representation of C + sum_p R_p/(t-p)."""

    def __init__(
        self,
        *,
        request_id: str,
        dimension: int,
        poles: list[acb],
        constant: acb_mat,
        residues: list[acb_mat],
    ) -> None:
        if constant.nrows() != dimension or constant.ncols() != dimension:
            raise ValueError(f"{request_id}: constant matrix dimension mismatch")
        if len(poles) != len(residues):
            raise ValueError(f"{request_id}: pole/residue count mismatch")
        if any(
            matrix.nrows() != dimension or matrix.ncols() != dimension
            for matrix in residues
        ):
            raise ValueError(f"{request_id}: residue matrix dimension mismatch")
        self.request_id = request_id
        self.dimension = dimension
        self.poles = poles
        self.constant = constant
        self.residues = residues

    @classmethod
    def from_payload(cls, payload: dict[str, Any]) -> "FlintPoleResidueSystem":
        required = {
            "request_id",
            "dimension",
            "equation_orientation",
            "poles_exact",
            "constant_matrix_exact",
            "residue_matrices_exact",
        }
        missing = sorted(required.difference(payload))
        if missing:
            raise ValueError(f"pole/residue payload is missing fields: {missing}")
        if payload["equation_orientation"] != "column":
            raise ValueError("the project adapter accepts only Y'=A.Y column equations")

        cache: dict[str, acb] = {}

        def convert(value: Any) -> acb:
            key = str(value)
            if key not in cache:
                cache[key] = exact_inputform_to_acb(value)
            return cache[key]

        def convert_matrix(records: list[list[Any]]) -> acb_mat:
            return acb_mat([[convert(value) for value in row] for row in records])

        return cls(
            request_id=str(payload["request_id"]),
            dimension=int(payload["dimension"]),
            poles=[convert(value) for value in payload["poles_exact"]],
            constant=convert_matrix(payload["constant_matrix_exact"]),
            residues=[
                convert_matrix(matrix) for matrix in payload["residue_matrices_exact"]
            ],
        )

    def value(self, point: acb) -> acb_mat:
        result = acb_mat(self.constant)
        for pole, residue in zip(self.poles, self.residues):
            result += residue / (point - pole)
        return result

    def taylor_matrix_coefficients(
        self, center: acb, solution_order: int
    ) -> list[acb_mat]:
        if solution_order <= 0:
            raise ValueError("solution order must be positive")
        inverse_offsets = [acb(1) / (center - pole) for pole in self.poles]
        factors = list(inverse_offsets)
        coefficients: list[acb_mat] = []
        for degree in range(solution_order):
            coefficient = (
                acb_mat(self.constant)
                if degree == 0
                else acb_mat(self.dimension, self.dimension)
            )
            for residue, factor in zip(self.residues, factors):
                coefficient += residue * factor
            coefficients.append(coefficient)
            factors = [
                -factor * inverse
                for factor, inverse in zip(factors, inverse_offsets)
            ]
        return coefficients


def matrix_entry_norm_inf(matrix: acb_mat) -> arb:
    magnitudes = [
        abs(matrix[row, column])
        for row in range(matrix.nrows())
        for column in range(matrix.ncols())
    ]
    if not magnitudes:
        return arb(0)
    return max(magnitudes, key=arb_midpoint_float)


def frobenius_residue_and_regular_coefficients(
    system: FlintPoleResidueSystem, order: int
) -> tuple[acb_mat, list[acb_mat]]:
    """Return R and A_m for A(t)=R/t+sum_{m>=0} A_m t^m."""

    zero_poles = [
        index for index, pole in enumerate(system.poles) if abs(pole).contains(0)
    ]
    if len(zero_poles) != 1:
        raise ValueError(
            "Frobenius payload must contain exactly one exact pole at t=0"
        )
    residue = acb_mat(system.residues[zero_poles[0]])
    nonzero_terms = [
        (pole, pole_residue)
        for index, (pole, pole_residue) in enumerate(
            zip(system.poles, system.residues)
        )
        if index != zero_poles[0]
    ]
    regular: list[acb_mat] = []
    for degree in range(order):
        coefficient = (
            acb_mat(system.constant)
            if degree == 0
            else acb_mat(system.dimension, system.dimension)
        )
        for pole, pole_residue in nonzero_terms:
            coefficient -= pole_residue / (pole ** (degree + 1))
        regular.append(coefficient)
    return residue, regular


def leading_mode_from_seed(
    residue: acb_mat, seed: dict[str, Any]
) -> tuple[acb, acb_mat, arb]:
    """Apply the fixed 16+4+4+1 indicial block cascade to one seed."""

    exponent = decimal_record_to_acb(seed["exponent"])
    sector = str(seed["sector"])
    sector_values = [
        decimal_record_to_acb(value) for value in seed["sector_vector"]
    ]
    expected_lengths = {
        "Top": 16,
        "LeftPinch": 4,
        "RightPinch": 4,
        "DoublePinch": 1,
    }
    if sector not in expected_lengths or len(sector_values) != expected_lengths[sector]:
        raise ValueError(f"invalid Frobenius sector seed: {sector}")

    top_rows = list(range(0, 16))
    left_rows = list(range(16, 20))
    right_rows = list(range(20, 24))
    double_rows = [24]
    r_tt = matrix_block(residue, top_rows, top_rows)
    r_tl = matrix_block(residue, top_rows, left_rows)
    r_tr = matrix_block(residue, top_rows, right_rows)
    r_td = matrix_block(residue, top_rows, double_rows)
    r_ll = matrix_block(residue, left_rows, left_rows)
    r_ld = matrix_block(residue, left_rows, double_rows)
    r_rr = matrix_block(residue, right_rows, right_rows)
    r_rd = matrix_block(residue, right_rows, double_rows)

    top = acb_mat(16, 1)
    left = acb_mat(4, 1)
    right = acb_mat(4, 1)
    double = acb_mat(1, 1)
    if sector == "Top":
        top = column_vector(sector_values)
    elif sector == "LeftPinch":
        left = column_vector(sector_values)
        top = (identity_matrix(16) * exponent - r_tt).solve(r_tl * left)
    elif sector == "RightPinch":
        right = column_vector(sector_values)
        top = (identity_matrix(16) * exponent - r_tt).solve(r_tr * right)
    else:
        double = column_vector(sector_values)
        left = (identity_matrix(4) * exponent - r_ll).solve(r_ld * double)
        right = (identity_matrix(4) * exponent - r_rr).solve(r_rd * double)
        top = (identity_matrix(16) * exponent - r_tt).solve(
            r_tl * left + r_tr * right + r_td * double
        )

    full = join_sector_columns(top, left, right, double)
    residual_vector = residue * full - full * exponent
    scale = max(
        matrix_entry_norm_inf(residue * full),
        matrix_entry_norm_inf(full * exponent),
        key=arb_midpoint_float,
    )
    indicial_residual = (
        arb(0)
        if scale.contains(0)
        else matrix_entry_norm_inf(residual_vector) / scale
    )
    return exponent, full, indicial_residual


def frobenius_groups_from_seeds(
    residue: acb_mat, seeds: list[dict[str, Any]]
) -> tuple[list[dict[str, Any]], list[arb]]:
    if not seeds:
        raise ValueError("Frobenius payload has no physical seeds")
    grouped: dict[str, dict[str, Any]] = {}
    residuals: list[arb] = []
    for seed_index, seed in enumerate(seeds):
        exponent, leading, residual = leading_mode_from_seed(residue, seed)
        residuals.append(residual)
        group_key = str(seed.get("exponent_group", seed["exponent"]))
        if group_key not in grouped:
            grouped[group_key] = {
                "exponent": exponent,
                "leading_columns": [],
                "seed_indices": [],
            }
        group = grouped[group_key]
        if abs(group["exponent"] - exponent).contains(0) is False:
            raise ValueError("inconsistent exponents inside a Frobenius group")
        group["leading_columns"].append(leading)
        group["seed_indices"].append(seed_index)
    groups = []
    for group_key, group in grouped.items():
        groups.append(
            {
                "key": group_key,
                "exponent": group["exponent"],
                "coefficients": [matrix_from_columns(group["leading_columns"])],
                "seed_indices": group["seed_indices"],
            }
        )
    return groups, residuals


def frobenius_recurrence(
    residue: acb_mat,
    regular_coefficients: list[acb_mat],
    groups: list[dict[str, Any]],
    order: int,
) -> list[arb]:
    recurrence_residuals: list[arb] = []
    dimension = residue.nrows()
    identity = identity_matrix(dimension)
    for group in groups:
        exponent = group["exponent"]
        coefficients: list[acb_mat] = group["coefficients"]
        for degree in range(1, order + 1):
            rhs = acb_mat(dimension, coefficients[0].ncols())
            for regular_degree in range(degree):
                rhs += (
                    regular_coefficients[regular_degree]
                    * coefficients[degree - 1 - regular_degree]
                )
            recurrence_matrix = identity * (exponent + acb(degree)) - residue
            next_coefficient = recurrence_matrix.solve(rhs)
            residual_matrix = recurrence_matrix * next_coefficient - rhs
            scale = max(
                matrix_entry_norm_inf(recurrence_matrix * next_coefficient),
                matrix_entry_norm_inf(rhs),
                key=arb_midpoint_float,
            )
            recurrence_residuals.append(
                arb(0)
                if scale.contains(0)
                else matrix_entry_norm_inf(residual_matrix) / scale
            )
            coefficients.append(next_coefficient)
    return recurrence_residuals


def evaluate_frobenius_groups(
    groups: list[dict[str, Any]], point: acb, order: int
) -> tuple[acb_mat, acb_mat]:
    dimension = groups[0]["coefficients"][0].nrows()
    value = acb_mat(dimension, 1)
    derivative = acb_mat(dimension, 1)
    for group in groups:
        exponent = group["exponent"]
        coefficients: list[acb_mat] = group["coefficients"]
        for degree, coefficient in enumerate(coefficients[: order + 1]):
            combined = sum_matrix_columns(coefficient)
            shifted_exponent = exponent + acb(degree)
            value += combined * (point ** shifted_exponent)
            derivative += (
                combined
                * shifted_exponent
                * (point ** (shifted_exponent - acb(1)))
            )
    return value, derivative


def construct_frobenius_boundary(
    system: FlintPoleResidueSystem,
    payload: dict[str, Any],
    *,
    decimal_digits: int,
) -> tuple[acb_mat, acb_mat, dict[str, Any]]:
    """Build high/low true-infinity boundary vectors from physical seeds."""

    total_clock = time.perf_counter()
    high_order = int(payload["frobenius_high_order"])
    low_order = int(payload["frobenius_low_order"])
    if not 1 <= low_order < high_order:
        raise ValueError("Frobenius orders must satisfy 1 <= low < high")
    point = decimal_record_to_acb(payload["frobenius_evaluation_point"])
    if point.real.contains(0) or arb_midpoint_float(point.real) <= 0 or not point.imag.contains(0):
        raise ValueError("Frobenius evaluation point must be positive real")

    coefficient_clock = time.perf_counter()
    residue, regular = frobenius_residue_and_regular_coefficients(
        system, high_order
    )
    coefficient_seconds = time.perf_counter() - coefficient_clock

    leading_clock = time.perf_counter()
    groups, indicial_residuals = frobenius_groups_from_seeds(
        residue, payload["frobenius_seeds"]
    )
    leading_seconds = time.perf_counter() - leading_clock

    recurrence_clock = time.perf_counter()
    recurrence_residuals = frobenius_recurrence(
        residue, regular, groups, high_order
    )
    recurrence_seconds = time.perf_counter() - recurrence_clock

    evaluation_clock = time.perf_counter()
    high, high_derivative = evaluate_frobenius_groups(groups, point, high_order)
    high_previous, _ = evaluate_frobenius_groups(groups, point, high_order - 1)
    low, low_derivative = evaluate_frobenius_groups(groups, point, low_order)
    low_previous, _ = evaluate_frobenius_groups(groups, point, low_order - 1)
    high_rhs = system.value(point) * high
    low_rhs = system.value(point) * low
    high_ode_residual = relative_residual_inf(
        high_derivative - high_rhs, high_derivative, high_rhs
    )
    low_ode_residual = relative_residual_inf(
        low_derivative - low_rhs, low_derivative, low_rhs
    )
    high_truncation = relative_difference_inf(high, high_previous)
    low_truncation = relative_difference_inf(low, low_previous)
    high_low_delta = relative_difference_inf(high, low)
    evaluation_seconds = time.perf_counter() - evaluation_clock

    diagnostic = {
        "evaluation_point": acb_record(point, decimal_digits),
        "high_order": high_order,
        "low_order": low_order,
        "physical_seed_count": len(payload["frobenius_seeds"]),
        "exponent_group_count": len(groups),
        "maximum_indicial_relative_residual_midpoint": max(
            (arb_midpoint_float(value) for value in indicial_residuals),
            default=0.0,
        ),
        "maximum_recurrence_relative_residual_midpoint": max(
            (arb_midpoint_float(value) for value in recurrence_residuals),
            default=0.0,
        ),
        "high_estimated_truncation_midpoint": arb_midpoint_float(high_truncation),
        "low_estimated_truncation_midpoint": arb_midpoint_float(low_truncation),
        "high_low_relative_delta_midpoint": arb_midpoint_float(high_low_delta),
        "high_ode_relative_residual_midpoint": arb_midpoint_float(high_ode_residual),
        "low_ode_relative_residual_midpoint": arb_midpoint_float(low_ode_residual),
        "raw_frobenius_boundary_25": vector_records(high, decimal_digits),
        "raw_frobenius_boundary_25_low_order": vector_records(low, decimal_digits),
        "timings": {
            "regular_coefficient_seconds": coefficient_seconds,
            "leading_mode_seconds": leading_seconds,
            "recurrence_seconds": recurrence_seconds,
            "evaluation_seconds": evaluation_seconds,
            "total_seconds": time.perf_counter() - total_clock,
        },
    }
    return high, low, diagnostic


def vector_taylor_coefficients(
    matrix_coefficients: list[acb_mat], initial_vector: acb_mat
) -> list[acb_mat]:
    """Quadratic convolution recurrence retained as a validation oracle."""

    if initial_vector.ncols() != 1:
        raise ValueError("initial value must be a column vector")
    coefficients = [acb_mat(initial_vector)]
    for degree in range(len(matrix_coefficients)):
        total = acb_mat(initial_vector.nrows(), 1)
        for matrix_degree in range(degree + 1):
            total += (
                matrix_coefficients[matrix_degree]
                * coefficients[degree - matrix_degree]
            )
        coefficients.append(total / acb(degree + 1))
    return coefficients


def vector_taylor_coefficients_from_poles(
    system: FlintPoleResidueSystem,
    center: acb,
    solution_order: int,
    initial_vector: acb_mat,
) -> list[acb_mat]:
    """Generate one local solution in O(P N) matrix-vector products.

    For ``A(z) = C + sum_j R_j/(z-p_j)`` and ``a_j = 1/(center-p_j)``,
    the pole convolution state

        u[j,n] = a_j * (c[n] - u[j,n-1]),  u[j,-1] = 0

    equals the coefficient of degree ``n`` in
    ``(z-p_j)^(-1) sum_n c[n] (z-center)^n``.  This avoids constructing
    every matrix Taylor coefficient and the O(N^2) vector convolution.
    """

    if solution_order <= 0:
        raise ValueError("solution order must be positive")
    if initial_vector.ncols() != 1:
        raise ValueError("initial value must be a column vector")
    if initial_vector.nrows() != system.dimension:
        raise ValueError("initial value dimension does not match the system")

    inverse_offsets = [acb(1) / (center - pole) for pole in system.poles]
    pole_states = [
        acb_mat(system.dimension, 1) for _ in system.poles
    ]
    coefficients = [acb_mat(initial_vector)]
    for degree in range(solution_order):
        current = coefficients[degree]
        total = system.constant * current
        next_states: list[acb_mat] = []
        for inverse, residue, previous_state in zip(
            inverse_offsets, system.residues, pole_states
        ):
            state = (current - previous_state) * inverse
            total += residue * state
            next_states.append(state)
        pole_states = next_states
        coefficients.append(total / acb(degree + 1))
    return coefficients


def evaluate_vector_series(coefficients: list[acb_mat], delta: acb) -> acb_mat:
    value = acb_mat(coefficients[0].nrows(), 1)
    for coefficient in reversed(coefficients):
        value = value * delta + coefficient
    return value


def evaluate_vector_series_derivative(
    coefficients: list[acb_mat], delta: acb
) -> acb_mat:
    derivative = acb_mat(coefficients[0].nrows(), 1)
    for degree in range(len(coefficients) - 1, 0, -1):
        derivative = derivative * delta + coefficients[degree] * acb(degree)
    return derivative


def segment_geometry(
    system: FlintPoleResidueSystem,
    index: int,
    start: acb,
    target: acb,
    safety_fraction: arb,
) -> SegmentGeometry:
    if not system.poles:
        raise ValueError("at least one finite pole is required for the safety audit")
    nearest = min(
        system.poles,
        key=lambda pole: arb_midpoint_float(abs(start - pole)),
    )
    radius = abs(start - nearest)
    if radius.contains(0):
        raise ValueError(f"segment {index} starts on a pole")
    ratio = abs(target - start) / radius
    if arb_midpoint_float(ratio) >= arb_midpoint_float(safety_fraction):
        raise ValueError(
            f"segment {index} is outside the requested Taylor safety fraction: "
            f"step/radius={ratio}, safety={safety_fraction}"
        )
    return SegmentGeometry(index, start, target, nearest, radius, ratio)


def transport_one_step(
    system: FlintPoleResidueSystem,
    initial_vector: acb_mat,
    start: acb,
    target: acb,
    order: int,
    compare_order_drop: int,
    *,
    recurrence: str = "pole_state",
    sample_points: list[tuple[int, acb]] | None = None,
    return_patch_data: bool = False,
    decimal_digits: int = 50,
) -> tuple[acb_mat, dict[str, Any]]:
    clock = time.perf_counter()
    if recurrence == "pole_state":
        coefficients = vector_taylor_coefficients_from_poles(
            system, start, order, initial_vector
        )
    elif recurrence == "convolution":
        matrix_coefficients = system.taylor_matrix_coefficients(start, order)
        coefficients = vector_taylor_coefficients(
            matrix_coefficients, initial_vector
        )
    else:
        raise ValueError(
            "recurrence must be either 'pole_state' or 'convolution'"
        )
    delta = target - start
    value = evaluate_vector_series(coefficients, delta)
    compare_value = evaluate_vector_series(
        coefficients[: order - compare_order_drop + 1], delta
    )
    derivative = evaluate_vector_series_derivative(coefficients, delta)
    rhs = system.value(target) * value
    sample_clock = time.perf_counter()
    samples = [
        {
            "sample_index": sample_index,
            "point": acb_record(point),
            "raw_vector": vector_records(
                evaluate_vector_series(coefficients, point - start)
            ),
        }
        for sample_index, point in (sample_points or [])
    ]
    sample_seconds = time.perf_counter() - sample_clock
    ode_scale = max(
        [vector_norm_inf(derivative), vector_norm_inf(rhs)],
        key=arb_midpoint_float,
    )
    if ode_scale.contains(0):
        ode_residual = arb(0)
    else:
        ode_residual = vector_norm_inf(derivative - rhs) / ode_scale
    truncation = relative_difference_inf(value, compare_value)
    report = {
        "recurrence": recurrence,
        "order": order,
        "compare_order": order - compare_order_drop,
        "estimated_relative_truncation_inf": arb_record(truncation),
        "estimated_relative_truncation_midpoint": arb_midpoint_float(truncation),
        "endpoint_ode_relative_residual_inf": arb_record(ode_residual),
        "endpoint_ode_relative_residual_midpoint": arb_midpoint_float(ode_residual),
        "samples": samples,
        "sample_evaluation_seconds": sample_seconds,
        "elapsed_seconds": time.perf_counter() - clock,
    }
    if return_patch_data:
        report["solution_coefficients"] = coefficient_records(
            coefficients, decimal_digits
        )
    return value, report


def complex_midpoint(value: acb) -> complex:
    return complex(float(value.real.mid()), float(value.imag.mid()))


def point_on_segment(point: acb, start: acb, target: acb) -> bool:
    """Midpoint geometry test used only to route requested output samples."""

    p = complex_midpoint(point)
    a = complex_midpoint(start)
    b = complex_midpoint(target)
    direction = b - a
    scale = max(1.0, abs(a), abs(b), abs(p))
    tolerance = 5.0e-13 * scale
    if abs(direction) <= tolerance:
        return abs(p - a) <= tolerance
    parameter = ((p - a) * direction.conjugate()).real / (abs(direction) ** 2)
    perpendicular = abs((p - a) - parameter * direction)
    return -5.0e-13 <= parameter <= 1.0 + 5.0e-13 and perpendicular <= tolerance


def transport_refined(
    system: FlintPoleResidueSystem,
    initial_vector: acb_mat,
    waypoints: list[acb],
    *,
    lower_initial_vector: acb_mat | None = None,
    high_order: int,
    low_order: int,
    compare_order_drop: int,
    safety_fraction: arb,
    recurrence: str = "pole_state",
    sample_points: list[tuple[int, acb]] | None = None,
    return_patch_data: bool = False,
    decimal_digits: int = 50,
) -> tuple[acb_mat, acb_mat, list[dict[str, Any]], float]:
    if len(waypoints) < 2:
        raise ValueError("at least two waypoints are required")
    if not 1 <= compare_order_drop < low_order < high_order:
        raise ValueError("orders must satisfy 1 <= drop < low < high")
    high = acb_mat(initial_vector)
    low = acb_mat(
        initial_vector if lower_initial_vector is None else lower_initial_vector
    )
    reports: list[dict[str, Any]] = []
    requested_samples = sample_points or []
    total_clock = time.perf_counter()
    for index, (start, target) in enumerate(
        zip(waypoints[:-1], waypoints[1:]), start=1
    ):
        geometry = segment_geometry(
            system, index, start, target, safety_fraction
        )
        segment_samples = [
            (sample_index, point)
            for sample_index, point in requested_samples
            if point_on_segment(point, start, target)
        ]
        high, high_report = transport_one_step(
            system,
            high,
            start,
            target,
            high_order,
            compare_order_drop,
            recurrence=recurrence,
            sample_points=segment_samples,
            return_patch_data=return_patch_data,
            decimal_digits=decimal_digits,
        )
        low, low_report = transport_one_step(
            system,
            low,
            start,
            target,
            low_order,
            compare_order_drop,
            recurrence=recurrence,
            sample_points=segment_samples,
            return_patch_data=False,
            decimal_digits=decimal_digits,
        )
        high = midpoint_matrix(high)
        low = midpoint_matrix(low)
        cumulative = relative_difference_inf(high, low)
        reports.append(
            {
                "segment_index": index,
                "start": acb_record(start),
                "target": acb_record(target),
                "nearest_pole": acb_record(geometry.nearest_pole),
                "convergence_radius": arb_record(geometry.radius),
                "step_over_radius": arb_record(geometry.step_ratio),
                "step_over_radius_midpoint": arb_midpoint_float(
                    geometry.step_ratio
                ),
                "high": high_report,
                "low": low_report,
                "cumulative_high_low_relative_delta_inf": arb_record(cumulative),
                "cumulative_high_low_relative_delta_midpoint": (
                    arb_midpoint_float(cumulative)
                ),
            }
        )
    return high, low, reports, time.perf_counter() - total_clock


def solve_payload(
    payload: dict[str, Any],
    *,
    decimal_digits: int,
    guard_bits: int,
    high_order: int,
    low_order: int,
    compare_order_drop: int,
    safety_fraction_exact: str,
) -> dict[str, Any]:
    if payload.get("operation") == "one_vertex_seed":
        return solve_one_vertex_seed_payload(
            payload, decimal_digits=decimal_digits, guard_bits=guard_bits
        )
    bit_precision = configure_working_precision(decimal_digits, guard_bits)
    parse_clock = time.perf_counter()
    system = FlintPoleResidueSystem.from_payload(payload)
    pole_residue_parse_seconds = time.perf_counter() - parse_clock
    if system.dimension != 25:
        raise ValueError(
            f"{system.request_id}: project adapter requires dimension 25"
        )
    basis_order = payload.get("basis_order")
    if basis_order != ["Top:16", "LeftPinch:4", "RightPinch:4", "DoublePinch:1"]:
        raise ValueError(f"{system.request_id}: unexpected 25D sector ordering")

    frobenius_diagnostic: dict[str, Any] | None = None
    lower_boundary: acb_mat | None = None
    if "frobenius_seeds" in payload:
        initial, lower_boundary, frobenius_diagnostic = construct_frobenius_boundary(
            system, payload, decimal_digits=decimal_digits
        )
    else:
        initial = column_vector(
            [decimal_record_to_acb(value) for value in payload["initial_vector"]]
        )
    if initial.nrows() != system.dimension:
        raise ValueError(f"{system.request_id}: initial vector dimension mismatch")
    if bool(payload.get("frobenius_only", False)):
        if lower_boundary is None or frobenius_diagnostic is None:
            raise ValueError("frobenius_only requires Frobenius seeds and two orders")
        boundary_delta = relative_difference_inf(initial, lower_boundary)
        return {
            "status": "passed",
            "request_id": system.request_id,
            "dimension": system.dimension,
            "basis_order": basis_order,
            "equation_orientation": "column",
            "evolution_variable": payload.get("evolution_variable", "unspecified"),
            "working_precision_decimal_digits": decimal_digits,
            "working_precision_bits": bit_precision,
            "guard_bits": guard_bits,
            "boundary_high_low_relative_delta_inf": arb_record(boundary_delta),
            "boundary_high_low_relative_delta_midpoint": arb_midpoint_float(
                boundary_delta
            ),
            "raw_boundary_25": vector_records(initial, decimal_digits),
            "raw_boundary_25_low_order": vector_records(
                lower_boundary, decimal_digits
            ),
            "automatic_ode_solver_used": False,
            "elapsed_seconds": frobenius_diagnostic["timings"]["total_seconds"],
            "pole_residue_parse_seconds": pole_residue_parse_seconds,
            "frobenius": frobenius_diagnostic,
            "payload_metadata": payload.get("metadata", {}),
        }
    if "waypoints_complex" in payload:
        waypoints = [
            decimal_record_to_acb(value) for value in payload["waypoints_complex"]
        ]
    else:
        waypoints = [acb(arb(str(value))) for value in payload["waypoints_real"]]
    if "sample_points_complex" in payload:
        sample_points = [
            decimal_record_to_acb(value)
            for value in payload["sample_points_complex"]
        ]
    else:
        sample_points = [
            acb(arb(str(value)))
            for value in payload.get("sample_points_real", [])
        ]
    safety_fraction = arb(_rational_to_fmpq(sp.Rational(safety_fraction_exact)))

    if sample_points:
        outside = [
            index
            for index, point in enumerate(sample_points)
            if not any(
                point_on_segment(point, start, target)
                for start, target in zip(waypoints[:-1], waypoints[1:])
            ) and not point_on_segment(point, waypoints[0], waypoints[0])
        ]
        if outside:
            raise ValueError(
                f"sample points outside the waypoint path at indices {outside}"
            )

    boundary_delta: arb | None = None
    if lower_boundary is not None:
        boundary_delta = relative_difference_inf(initial, lower_boundary)
    elif "initial_vector_lower" in payload:
        lower_boundary = column_vector(
            [
                decimal_record_to_acb(value)
                for value in payload["initial_vector_lower"]
            ]
        )
        boundary_delta = relative_difference_inf(initial, lower_boundary)

    high, low, reports, elapsed = transport_refined(
        system,
        initial,
        waypoints,
        lower_initial_vector=lower_boundary,
        high_order=high_order,
        low_order=low_order,
        compare_order_drop=compare_order_drop,
        safety_fraction=safety_fraction,
        recurrence=str(payload.get("taylor_recurrence", "pole_state")),
        sample_points=list(enumerate(sample_points)),
        return_patch_data=bool(payload.get("return_patch_data", False)),
        decimal_digits=decimal_digits,
    )
    final_delta = relative_difference_inf(high, low)
    sample_records: dict[int, dict[str, Any]] = {}
    if sample_points:
        path_start = complex_midpoint(waypoints[0])
        for sample_index, point in enumerate(sample_points):
            if abs(complex_midpoint(point) - path_start) <= 5.0e-13:
                sample_records[sample_index] = {
                    "sample_index": sample_index,
                    "point": acb_record(point),
                    "raw_vector": vector_records(initial, decimal_digits),
                    "raw_vector_low_order": vector_records(
                        initial if lower_boundary is None else lower_boundary,
                        decimal_digits,
                    ),
                }
        for report in reports:
            for sample in report["high"]["samples"]:
                sample_records[int(sample["sample_index"])] = sample
            for sample in report["low"]["samples"]:
                sample_index = int(sample["sample_index"])
                if sample_index not in sample_records:
                    raise ValueError(
                        f"low-order sample {sample_index} has no high-order partner"
                    )
                sample_records[sample_index]["raw_vector_low_order"] = sample[
                    "raw_vector"
                ]
        missing_samples = sorted(set(range(len(sample_points))) - set(sample_records))
        if missing_samples:
            raise ValueError(f"sample points were not evaluated: {missing_samples}")
        missing_low_samples = sorted(
            index
            for index, sample in sample_records.items()
            if "raw_vector_low_order" not in sample
        )
        if missing_low_samples:
            raise ValueError(
                f"low-order sample vectors were not evaluated: {missing_low_samples}"
            )
    ordered_samples = [sample_records[index] for index in sorted(sample_records)]
    sample_evaluation_seconds = sum(
        float(report["high"]["sample_evaluation_seconds"])
        for report in reports
    )
    result = {
        "status": "passed",
        "request_id": system.request_id,
        "dimension": system.dimension,
        "basis_order": basis_order,
        "equation_orientation": "column",
        "evolution_variable": payload.get("evolution_variable", "unspecified"),
        "working_precision_decimal_digits": decimal_digits,
        "working_precision_bits": bit_precision,
        "guard_bits": guard_bits,
        "high_order": high_order,
        "low_order": low_order,
        "compare_order_drop": compare_order_drop,
        "safety_fraction_exact": safety_fraction_exact,
        "taylor_recurrence": str(payload.get("taylor_recurrence", "pole_state")),
        "boundary_high_low_relative_delta_inf": (
            None if boundary_delta is None else arb_record(boundary_delta)
        ),
        "boundary_high_low_relative_delta_midpoint": (
            None if boundary_delta is None else arb_midpoint_float(boundary_delta)
        ),
        "final_high_low_relative_delta_inf": arb_record(final_delta),
        "final_high_low_relative_delta_midpoint": arb_midpoint_float(final_delta),
        "requested_sample_count": len(sample_points),
        "sample_results": ordered_samples,
        "sample_evaluation_seconds": sample_evaluation_seconds,
        "raw_boundary_25": vector_records(high, decimal_digits),
        "raw_boundary_25_low_order": vector_records(low, decimal_digits),
        "segments": reports,
        "automatic_ode_solver_used": False,
        "elapsed_seconds": elapsed,
        "pole_residue_parse_seconds": pole_residue_parse_seconds,
        "payload_metadata": payload.get("metadata", {}),
    }
    if frobenius_diagnostic is not None:
        result["frobenius"] = frobenius_diagnostic
    return result


def _build_argument_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--input", required=True, type=Path)
    parser.add_argument("--output", required=True, type=Path)
    parser.add_argument("--digits", type=int, default=60)
    parser.add_argument("--guard-bits", type=int, default=32)
    parser.add_argument("--high-order", type=int, default=60)
    parser.add_argument("--low-order", type=int, default=58)
    parser.add_argument("--compare-order-drop", type=int, default=2)
    parser.add_argument("--safety-fraction", default="1/2")
    return parser


def main() -> int:
    args = _build_argument_parser().parse_args()
    with args.input.open("r", encoding="utf-8") as handle:
        payload = json.load(handle)
    try:
        result = solve_payload(
            payload,
            decimal_digits=args.digits,
            guard_bits=args.guard_bits,
            high_order=args.high_order,
            low_order=args.low_order,
            compare_order_drop=args.compare_order_drop,
            safety_fraction_exact=args.safety_fraction,
        )
    except Exception as error:  # CLI preserves a machine-readable failure record.
        result = {
            "status": "failed",
            "request_id": payload.get("request_id", "unknown"),
            "error_type": type(error).__name__,
            "error": str(error),
        }
        args.output.parent.mkdir(parents=True, exist_ok=True)
        with args.output.open("w", encoding="utf-8") as handle:
            json.dump(result, handle, ensure_ascii=False, indent=2)
        return 1
    args.output.parent.mkdir(parents=True, exist_ok=True)
    with args.output.open("w", encoding="utf-8") as handle:
        json.dump(result, handle, ensure_ascii=False, indent=2)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
