"""一般矩阵微分方程的普通点 Taylor 输运与统一奇点局部桥接。

实现按 ``Y'=A(z)Y`` 的列向量约定递推解系数。路径可以由用户完整指定，也可以在
已声明奇点的前提下沿直线自动分段；自描述 adaptive path 遇到奇点时，先自动选择
Frobenius、shearing 后 Frobenius 或认证的指数广义幂级数，在入射侧反解局部常数，
再在出射侧求值。普通段的 Cauchy 圆和步长严格留在最近奇点以内。
"""

from __future__ import annotations

import time
import warnings
from pathlib import Path
from typing import Any

from flint import acb, acb_mat, arb

from .boundary import ExponentialBoundary, FrobeniusBoundary
from .core import acb_midpoint_matrix, relative_difference_inf
from .local_solutions import build_local_solution_basis
from .savepoints import (
    SavePointWriter,
    singular_boundary_record_from_constants,
    vector_record,
)
from .singularities import RationalMatrixSystem
from .systems import AnalyticMatrixSystem


def vector_taylor_coefficients(
    matrix_coefficients: list[acb_mat], initial_vector: acb_mat
) -> list[acb_mat]:
    """递推 ``Y'=A Y`` 的一个或多个解列的 Taylor 系数。"""

    if not matrix_coefficients:
        raise ValueError("matrix coefficient list must not be empty")
    dimension = matrix_coefficients[0].nrows()
    if initial_vector.nrows() != dimension or initial_vector.ncols() < 1:
        raise ValueError("initial vector dimension mismatch")
    solution = [acb_mat(initial_vector)]
    for degree in range(len(matrix_coefficients)):
        total = acb_mat(dimension, initial_vector.ncols())
        for matrix_degree in range(degree + 1):
            total += matrix_coefficients[matrix_degree] * solution[degree - matrix_degree]
        solution.append(total / acb(degree + 1))
    return solution


def _matrix_column(matrix: acb_mat, column: int) -> acb_mat:
    """复制一个矩阵列，供逐物理解报告使用。"""

    result = acb_mat(matrix.nrows(), 1)
    for row in range(matrix.nrows()):
        result[row, 0] = matrix[row, column]
    return result


def evaluate_vector_series(coefficients: list[acb_mat], delta: acb) -> acb_mat:
    """用 Horner 法计算列向量 Taylor 多项式。"""

    if not coefficients:
        raise ValueError("solution coefficient list must not be empty")
    value = acb_mat(coefficients[-1])
    for coefficient in reversed(coefficients[:-1]):
        value = value * delta + coefficient
    return value


def build_straight_path(
    system: AnalyticMatrixSystem,
    start: acb,
    target: acb,
    *,
    step_fraction: float = 0.20,
) -> list[acb]:
    """按最近奇点距离的一定比例构造直线路径。"""

    if not 0 < step_fraction < 1:
        raise ValueError("step_fraction must lie between zero and one")
    points = [acb(start)]
    current = acb(start)
    direction = target - start
    total_distance = abs(direction)
    if total_distance.contains(0):
        return points
    unit = direction / total_distance
    for _ in range(100000):
        remaining = abs(target - current)
        if remaining.contains(0):
            return points
        radius = system.nearest_singularity_distance(current)
        proposed = radius * step_fraction
        step = remaining if float(remaining.mid()) <= float(proposed.mid()) else proposed
        current = acb(target) if step is remaining else current + unit * step
        points.append(acb(current))
        if abs(target - current).contains(0):
            return points
    raise RuntimeError("automatic path construction exceeded the segment limit")


def _resolve_transport_boundary(
    system: AnalyticMatrixSystem | RationalMatrixSystem,
    boundary: Any,
    path: list[acb],
    order: int,
    target_relative_error: arb | None,
) -> tuple[acb_mat, dict[str, Any] | None]:
    """把普通列向量或奇点 ``{a,b,C}`` 边界转换为首个执行点的列向量。"""

    start = getattr(path, "start_classification", None)
    if start is None or start.kind == "ordinary":
        if isinstance(boundary, (FrobeniusBoundary, ExponentialBoundary)):
            raise TypeError("singular boundary data require a singular path start")
        if not isinstance(boundary, acb_mat):
            raise TypeError("ordinary path start requires an acb_mat initial column vector")
        return acb_mat(boundary), None
    if not isinstance(system, RationalMatrixSystem):
        raise TypeError("singular {a,b,C} boundary requires its RationalMatrixSystem")
    working_system = getattr(path, "_working_system", None)
    if not isinstance(working_system, RationalMatrixSystem):
        raise TypeError("singular-start path lacks its exact working RationalMatrixSystem")
    inventory = working_system.singularity_inventory()
    record = next(
        (
            item
            for item in inventory.finite
            if item.identifier == start.singularity_identifier
        ),
        None,
    )
    if record is None or record.location is None or record.location_exact is None:
        raise ValueError("singular boundary requires an exact Q(i) start point")
    basis = build_local_solution_basis(working_system, record.location_exact, order)
    constants, boundary_report = basis.resolve_boundary(boundary)
    local_point = path[0] - record.location
    vector = acb_midpoint_matrix(basis.evaluate(local_point) * constants.to_acb())
    report = {
        "segment_index": 0,
        "method": (
            "regular_singular_boundary_initialization"
            if basis.method == "regular_singular_power_log"
            else f"{basis.method}_boundary_initialization"
        ),
        "singularity_identifier": record.identifier,
        "singularity": record.location_exact,
        "working_variable": getattr(path, "working_variable", working_system.variable_name),
        "ordinary_match_point": path[0].str(40),
        "local_coordinate": local_point.str(40),
        "order": order,
        "maximum_log_degree": basis.maximum_log_degree,
        "local_basis": basis.manifest,
        "branch_convention": "python-flint principal acb log/power branch",
        "boundary": boundary_report,
    }
    evaluation_report = basis.evaluation_report(local_point)
    if evaluation_report is not None:
        selected_sectors = sorted(
            {
                item["inferred_sector"]
                for item in boundary_report.get("term_resolutions", ())
                if "inferred_sector" in item
            }
        )
        if selected_sectors:
            diagnostics = evaluation_report.get("branch_diagnostics", ())
            evaluation_report["selected_sector_indices"] = selected_sectors
            evaluation_report["selected_branch_diagnostics"] = [
                {**diagnostics[index - 1], "sector_index": index}
                for index in selected_sectors
                if 0 < index <= len(diagnostics)
            ]
        _assess_formal_evaluation(evaluation_report, target_relative_error)
        report["local_evaluation"] = evaluation_report
    return vector, report


def _accuracy_target(value: Any | None) -> arb | None:
    """规范化可选相对精度目标，并拒绝无意义的阈值。"""

    if value is None:
        return None
    target = arb(str(value))
    if not 0 < target < 1:
        raise ValueError("target_relative_error must lie strictly between zero and one")
    return target


def _assess_formal_evaluation(
    evaluation: dict[str, Any],
    target_relative_error: arb | None,
) -> None:
    """评估实际选中分支的五阶诊断；失败只警告并保留计算结果。"""

    diagnostics = evaluation.get(
        "selected_branch_diagnostics", evaluation.get("branch_diagnostics", ())
    )
    issues: list[str] = []
    for index, diagnostic in enumerate(diagnostics, 1):
        sector_index = diagnostic.get("sector_index", index)
        ratio_text = diagnostic.get("next_five_over_previous_five")
        decreasing = diagnostic.get("next_five_over_previous_five_below_one")
        if decreasing is not True:
            ratio_label = "undefined" if ratio_text is None else ratio_text
            issues.append(
                f"sector {sector_index}: five-order block ratio={ratio_label} is not < 1"
            )
        refinement_text = diagnostic.get("five_order_relative_refinement")
        if target_relative_error is not None:
            meets_target = (
                refinement_text is not None
                and arb(refinement_text) < target_relative_error
            )
            diagnostic["target_relative_error"] = target_relative_error.str(30)
            diagnostic["five_order_relative_refinement_meets_target"] = bool(meets_target)
            if not meets_target:
                refinement_label = "undefined" if refinement_text is None else refinement_text
                issues.append(
                    f"sector {sector_index}: five-order relative refinement={refinement_label} "
                    f"does not meet {target_relative_error.str(12)}"
                )
    evaluation["formal_accuracy_checks_passed"] = not issues
    evaluation["formal_accuracy_issues"] = issues
    if issues:
        warnings.warn(
            "formal-asymptotic convergence warning; result retained: " + "; ".join(issues),
            UserWarning,
            stacklevel=3,
        )


def _transport_points_and_save_requests(path: list[Any]) -> tuple[list[acb], tuple[dict[str, Any], ...]]:
    """解析普通 ``list`` 中的 ``(coordinate,"save")``，并保留 AdaptivePath 元数据。"""

    adaptive_requests = getattr(path, "save_requests", None)
    if adaptive_requests is not None:
        return path, tuple(adaptive_requests)
    points: list[acb] = []
    requests: list[dict[str, Any]] = []
    for index, item in enumerate(path):
        tagged = isinstance(item, (list, tuple)) and len(item) == 2 and item[1] == "save"
        value = item[0] if tagged else item
        point = acb(value)
        points.append(point)
        if tagged:
            requests.append(
                {
                    "coordinate": point.str(40),
                    "working_coordinate": point.str(40),
                    "classification": "ordinary",
                    "singularity_identifier": None,
                    "role": "path",
                    "execution_index": index,
                }
            )
    return points, tuple(requests)


def _writer_for_requests(
    requests: tuple[dict[str, Any], ...],
    output_directory: str | Path | None,
    summary_filename: str,
    digits: int,
    enabled: bool,
) -> SavePointWriter | None:
    """只在路径确有 save 标签时建立输出根。"""

    if not enabled or not requests:
        return None
    return SavePointWriter(
        Path.cwd() if output_directory is None else Path(output_directory),
        summary_filename=summary_filename,
        digits=digits,
    )


def _write_ordinary_requests(
    writer: SavePointWriter | None,
    requests: tuple[dict[str, Any], ...],
    execution_index: int,
    vector: acb_mat,
) -> None:
    """在指定执行点完成后立即保存全部对应 ordinary 标签。"""

    if writer is None:
        return
    for request in requests:
        if request["classification"] == "ordinary" and request["execution_index"] == execution_index:
            writer.write(
                request,
                {
                    "resultType": "ordinary_vector",
                    "result": vector_record(vector, writer.digits),
                },
            )


def _write_singular_start_request(
    writer: SavePointWriter | None,
    requests: tuple[dict[str, Any], ...],
    path: list[acb],
    boundary: Any,
    order: int,
) -> None:
    """把已验证的奇点起点恢复为对应局部基的可复用边界。"""

    if writer is None:
        return
    start_requests = [
        request
        for request in requests
        if request["classification"] != "ordinary" and request["role"] == "start"
    ]
    if not start_requests:
        return
    working_system = getattr(path, "_working_system", None)
    if not isinstance(working_system, RationalMatrixSystem):
        raise TypeError("saved singular start requires its exact RationalMatrixSystem")
    inventory = working_system.singularity_inventory()
    for request in start_requests:
            if not isinstance(boundary, (FrobeniusBoundary, ExponentialBoundary)):
                raise TypeError("saved singular start requires a certified singular boundary")
            record = next(
                (
                    item
                    for item in inventory.finite
                    if item.identifier == request["singularity_identifier"]
                ),
                None,
            )
            if record is None or record.location_exact is None:
                raise ValueError("saved singular start requires an exact Q(i) finite center")
            basis = build_local_solution_basis(working_system, record.location_exact, order)
            constants, _report = basis.resolve_boundary(boundary)
            if basis.method == "regular_singular_power_log" and isinstance(
                boundary, FrobeniusBoundary
            ):
                result_type = "frobenius_boundary"
                result = {
                    "schema": "flintnde_frobenius_boundary_v1",
                    "terms": boundary.to_json(),
                    "localBasisMethod": basis.method,
                }
            else:
                result_type, result = singular_boundary_record_from_constants(
                    basis, constants.to_acb(), writer.digits
                )
            writer.write(
                request,
                {
                    "resultType": result_type,
                    "result": result,
                },
            )


def _write_singular_bridge_requests(
    writer: SavePointWriter | None,
    requests: tuple[dict[str, Any], ...],
    singularity_identifier: str,
    basis: Any,
    constants: acb_mat,
) -> None:
    """在 continuation-ready bridge 的入射侧反解后即时保存中间奇点边界。"""

    if writer is None:
        return
    for request in requests:
        if (
            request["classification"] != "ordinary"
            and request["role"] == "detour"
            and request["singularity_identifier"] == singularity_identifier
        ):
            result_type, result = singular_boundary_record_from_constants(
                basis, constants, writer.digits
            )
            writer.write(request, {"resultType": result_type, "result": result})


def _write_singular_target_request(
    writer: SavePointWriter | None,
    requests: tuple[dict[str, Any], ...],
    path: list[acb],
    vector: acb_mat,
    order: int,
) -> None:
    """由终点入射匹配值反解局部常数，再输出可复用的 Frobenius 领头数据。"""

    if writer is None:
        return
    target_requests = [
        request
        for request in requests
        if request["classification"] != "ordinary" and request["role"] == "target"
    ]
    if not target_requests:
        return
    working_system = getattr(path, "_working_system", None)
    if not isinstance(working_system, RationalMatrixSystem):
        raise TypeError("saved singular target requires its exact RationalMatrixSystem")
    inventory = working_system.singularity_inventory()
    for request in target_requests:
        record = next(
            (
                item
                for item in inventory.finite
                if item.identifier == request["singularity_identifier"]
            ),
            None,
        )
        if record is None or record.location is None or record.location_exact is None:
            raise ValueError("saved singular target requires an exact Q(i) finite center")
        basis = build_local_solution_basis(working_system, record.location_exact, order)
        if not basis.continuation_ready:
            raise NotImplementedError(
                f"saved singular target requires continuation-ready local data, got {basis.method}"
            )
        constants = basis.evaluate(path[-1] - record.location).solve(vector)
        result_type, result = singular_boundary_record_from_constants(
            basis, constants, writer.digits
        )
        writer.write(
            request,
            {
                "resultType": result_type,
                "result": result,
            },
        )


def transport_path(
    system: AnalyticMatrixSystem | RationalMatrixSystem,
    initial_vector: Any,
    path: list[acb],
    *,
    order: int,
    sample_count: int | None = None,
    radius_fraction: float = 0.60,
    target_relative_error: Any | None = None,
    save_output_directory: str | Path | None = None,
    save_summary_filename: str = "flintnde_save_points.json",
    save_digits: int = 40,
    write_save_points: bool = True,
) -> tuple[list[acb_mat], list[dict[str, Any]], float]:
    """沿普通路径或含统一奇点 bridge 的 adaptive path 输运列向量。

    普通 ``list[acb]`` 保持原接口。由 ``build_adaptive_path`` 返回的列表子类可和
    ``RationalMatrixSystem`` 直接配合；主函数在开始计算前读取全部 transition，确认
    哪些线段需要从奇点局部基反向求常数。
    """

    path, save_requests = _transport_points_and_save_requests(path)
    if len(path) < 2:
        raise ValueError("transport path needs at least two points")
    if not 0 < radius_fraction < 1:
        raise ValueError("radius_fraction must lie between zero and one")
    accuracy_target = _accuracy_target(target_relative_error)
    writer = _writer_for_requests(
        save_requests,
        save_output_directory,
        save_summary_filename,
        save_digits,
        write_save_points,
    )
    transitions = getattr(path, "_transitions", None)
    if isinstance(system, RationalMatrixSystem):
        if transitions is None:
            raise TypeError(
                "RationalMatrixSystem transport requires a path returned by build_adaptive_path"
            )
        working_system = getattr(path, "_working_system")
        inventory = working_system.singularity_inventory()
        analytic_system = working_system.to_analytic_system(inventory)
    else:
        if transitions is not None and any(
            item.get("method") == "regular_singular_bridge" for item in transitions
        ):
            raise TypeError(
                "a path with singular local bridges must receive its RationalMatrixSystem"
            )
        working_system = None
        inventory = None
        analytic_system = system

    total_clock = time.perf_counter()
    vector, boundary_report = _resolve_transport_boundary(
        system, initial_vector, path, order, accuracy_target
    )
    snapshots = [acb_mat(vector)]
    reports: list[dict[str, Any]] = (
        [] if boundary_report is None else [boundary_report]
    )
    _write_singular_start_request(writer, save_requests, path, initial_vector, order)
    _write_ordinary_requests(writer, save_requests, 0, vector)
    for index, (start, target) in enumerate(zip(path[:-1], path[1:]), start=1):
        transition = (
            transitions[index - 1]
            if transitions is not None
            else {"method": "ordinary_taylor"}
        )
        step_reports = [
            report
            for report in getattr(path, "step_reports", ())
            if report["execution_segment_index"] == index
        ]
        if transition["method"] == "regular_singular_bridge":
            if working_system is None or inventory is None:
                raise TypeError("singular local bridge requires an exact Q(i) working system")
            singularity = transition["singularity"]
            record = next(
                (
                    item
                    for item in inventory.finite
                    if item.identifier == singularity.singularity_identifier
                ),
                None,
            )
            if record is None or record.location is None:
                raise ValueError("local bridge singularity is absent from the working inventory")
            if record.location_exact is None:
                raise ValueError(
                    f"{record.identifier}: exact local bridge currently requires a Q(i) root"
                )
            segment_clock = time.perf_counter()
            basis = build_local_solution_basis(working_system, record.location_exact, order)
            if not basis.continuation_ready:
                raise NotImplementedError(
                    f"{basis.method} cannot bridge an internal singularity without Stokes data"
                )
            incoming_basis = basis.evaluate(start - record.location)
            constants = incoming_basis.solve(vector)
            _write_singular_bridge_requests(
                writer,
                save_requests,
                record.identifier,
                basis,
                constants,
            )
            vector = acb_midpoint_matrix(
                basis.evaluate(target - record.location) * constants
            )
            elapsed = time.perf_counter() - segment_clock
            snapshots.append(acb_mat(vector))
            _write_ordinary_requests(writer, save_requests, index, vector)
            ratios = [
                report["step_over_convergence_radius"] for report in step_reports
            ]
            bridge_report = {
                    "segment_index": index,
                    "method": f"{basis.method}_bridge",
                    "singularity_identifier": record.identifier,
                    "singularity": record.location_exact,
                    "order": order,
                    "maximum_log_degree": basis.maximum_log_degree,
                    "local_basis": basis.manifest,
                    "branch_convention": "python-flint principal acb log/power branch",
                    "step_over_convergence_radius": ratios,
                    "maximum_step_over_convergence_radius": max(
                        (value for value in ratios if value is not None), default=None
                    ),
                    "elapsed_seconds": elapsed,
                }
            incoming_evaluation = basis.evaluation_report(start - record.location)
            outgoing_evaluation = basis.evaluation_report(target - record.location)
            if incoming_evaluation is not None or outgoing_evaluation is not None:
                if incoming_evaluation is not None:
                    _assess_formal_evaluation(incoming_evaluation, accuracy_target)
                if outgoing_evaluation is not None:
                    _assess_formal_evaluation(outgoing_evaluation, accuracy_target)
                bridge_report["local_evaluation"] = {
                    "incoming": incoming_evaluation,
                    "outgoing": outgoing_evaluation,
                }
            reports.append(bridge_report)
            continue

        nearest = analytic_system.nearest_singularity_distance(start)
        radius = acb(nearest * radius_fraction)
        delta = target - start
        if float(abs(delta).mid()) >= float(abs(radius).mid()):
            raise ValueError(
                f"{analytic_system.name}: segment {index} leaves its Cauchy disk; refine the path"
            )
        segment_clock = time.perf_counter()
        matrix_coefficients = analytic_system.taylor_matrix_coefficients(
            start,
            order,
            radius=radius,
            sample_count=sample_count,
        )
        solution_coefficients = vector_taylor_coefficients(matrix_coefficients, vector)
        vector = acb_midpoint_matrix(evaluate_vector_series(solution_coefficients, delta))
        elapsed = time.perf_counter() - segment_clock
        snapshots.append(acb_mat(vector))
        _write_ordinary_requests(writer, save_requests, index, vector)
        reports.append(
            {
                "segment_index": index,
                "method": "ordinary_taylor",
                "order": order,
                "sample_count": sample_count or max(32, 2 * order),
                "step_over_convergence_radius": float((abs(delta) / nearest).mid()),
                "cauchy_radius_over_nearest_singularity": radius_fraction,
                "elapsed_seconds": elapsed,
            }
        )
    _write_singular_target_request(writer, save_requests, path, vector, order)
    if writer is not None:
        writer.finalize()
    return snapshots, reports, time.perf_counter() - total_clock


def _resolve_frobenius_boundary_batch(
    system: RationalMatrixSystem,
    boundaries: list[FrobeniusBoundary],
    path: list[acb],
    order: int,
    target_relative_error: arb | None,
) -> tuple[acb_mat, list[dict[str, Any]]]:
    """一次构造局部基，并把多个 Frobenius 边界变成同一匹配点的解列。"""

    start = getattr(path, "start_classification", None)
    if start is None or start.kind != "regular_singular":
        raise TypeError("Frobenius batch requires a regular-singular path start")
    working_system = getattr(path, "_working_system", None)
    if not isinstance(working_system, RationalMatrixSystem):
        raise TypeError("Frobenius batch path lacks its exact working RationalMatrixSystem")
    inventory = working_system.singularity_inventory()
    record = next(
        (
            item
            for item in inventory.finite
            if item.identifier == start.singularity_identifier
        ),
        None,
    )
    if record is None or record.location is None or record.location_exact is None:
        raise ValueError("Frobenius batch requires an exact Q(i) start point")
    basis = build_local_solution_basis(working_system, record.location_exact, order)
    local_point = path[0] - record.location
    evaluated_basis = basis.evaluate(local_point)
    vectors = acb_mat(system.dimension, len(boundaries))
    reports: list[dict[str, Any]] = []
    for column, boundary in enumerate(boundaries):
        constants, boundary_report = basis.resolve_boundary(boundary)
        vector = acb_midpoint_matrix(evaluated_basis * constants.to_acb())
        for row in range(system.dimension):
            vectors[row, column] = vector[row, 0]
        report = {
            "segment_index": 0,
            "method": "regular_singular_boundary_initialization_batch",
            "singularity_identifier": record.identifier,
            "singularity": record.location_exact,
            "working_variable": getattr(path, "working_variable", working_system.variable_name),
            "ordinary_match_point": path[0].str(40),
            "local_coordinate": local_point.str(40),
            "order": order,
            "maximum_log_degree": basis.maximum_log_degree,
            "local_basis": basis.manifest,
            "branch_convention": "python-flint principal acb log/power branch",
            "boundary": boundary_report,
        }
        evaluation_report = basis.evaluation_report(local_point)
        if evaluation_report is not None:
            selected_sectors = sorted(
                {
                    item["inferred_sector"]
                    for item in boundary_report.get("term_resolutions", ())
                    if "inferred_sector" in item
                }
            )
            if selected_sectors:
                diagnostics = evaluation_report.get("branch_diagnostics", ())
                evaluation_report["selected_sector_indices"] = selected_sectors
                evaluation_report["selected_branch_diagnostics"] = [
                    {**diagnostics[index - 1], "sector_index": index}
                    for index in selected_sectors
                    if 0 < index <= len(diagnostics)
                ]
            _assess_formal_evaluation(evaluation_report, target_relative_error)
            report["local_evaluation"] = evaluation_report
        reports.append(report)
    return vectors, reports


def _transport_frobenius_boundary_batch(
    system: RationalMatrixSystem,
    boundaries: list[FrobeniusBoundary],
    path: list[acb],
    *,
    order: int,
    radius_fraction: float,
    target_relative_error: arb | None,
) -> tuple[list[acb_mat], list[dict[str, Any]], list[dict[str, Any]], float]:
    """共享局部基和普通段矩阵系数，批量输运多个 Frobenius 解列。"""

    path, save_requests = _transport_points_and_save_requests(path)
    if save_requests:
        raise NotImplementedError("Frobenius batch does not yet support save points")
    if len(path) < 2:
        raise ValueError("transport path needs at least two points")
    if not 0 < radius_fraction < 1:
        raise ValueError("radius_fraction must lie between zero and one")
    transitions = getattr(path, "_transitions", None)
    if transitions is None or any(
        item.get("method") != "ordinary_taylor" for item in transitions
    ):
        raise NotImplementedError(
            "Frobenius batch currently requires an ordinary path after the singular launch"
        )
    working_system = getattr(path, "_working_system", None)
    if not isinstance(working_system, RationalMatrixSystem):
        raise TypeError("Frobenius batch path lacks its exact working RationalMatrixSystem")
    inventory = working_system.singularity_inventory()
    analytic_system = working_system.to_analytic_system(inventory)
    total_clock = time.perf_counter()
    vectors, boundary_reports = _resolve_frobenius_boundary_batch(
        system, boundaries, path, order, target_relative_error
    )
    snapshots = [acb_mat(vectors)]
    reports: list[dict[str, Any]] = []
    for index, (start, target) in enumerate(zip(path[:-1], path[1:]), start=1):
        nearest = analytic_system.nearest_singularity_distance(start)
        radius = acb(nearest * radius_fraction)
        delta = target - start
        if float(abs(delta).mid()) >= float(abs(radius).mid()):
            raise ValueError(
                f"{analytic_system.name}: segment {index} leaves its Cauchy disk; refine the path"
            )
        segment_clock = time.perf_counter()
        matrix_coefficients = analytic_system.taylor_matrix_coefficients(
            start,
            order,
            radius=radius,
            sample_count=None,
        )
        solution_coefficients = vector_taylor_coefficients(matrix_coefficients, vectors)
        vectors = acb_midpoint_matrix(evaluate_vector_series(solution_coefficients, delta))
        elapsed = time.perf_counter() - segment_clock
        snapshots.append(acb_mat(vectors))
        reports.append(
            {
                "segment_index": index,
                "method": "ordinary_taylor_batch",
                "order": order,
                "sample_count": max(32, 2 * order),
                "step_over_convergence_radius": float((abs(delta) / nearest).mid()),
                "cauchy_radius_over_nearest_singularity": radius_fraction,
                "elapsed_seconds": elapsed,
                "column_count": len(boundaries),
            }
        )
    return snapshots, reports, boundary_reports, time.perf_counter() - total_clock


def transport_frobenius_boundaries_refined(
    system: RationalMatrixSystem,
    boundaries: list[FrobeniusBoundary],
    path: list[acb],
    *,
    primary_order: int,
    reference_order: int,
    radius_fraction: float = 0.60,
    target_relative_error: Any | None = None,
) -> dict[str, Any]:
    """对同一系统的多个 Frobenius 初值共享构造，并逐列报告 refinement。"""

    if not boundaries:
        raise ValueError("Frobenius boundary batch must not be empty")
    if reference_order <= primary_order:
        raise ValueError("reference_order must exceed primary_order")
    accuracy_target = _accuracy_target(target_relative_error)
    primary = _transport_frobenius_boundary_batch(
        system,
        boundaries,
        path,
        order=primary_order,
        radius_fraction=radius_fraction,
        target_relative_error=accuracy_target,
    )
    reference = _transport_frobenius_boundary_batch(
        system,
        boundaries,
        path,
        order=reference_order,
        radius_fraction=radius_fraction,
        target_relative_error=accuracy_target,
    )
    primary_final = primary[0][-1]
    reference_final = reference[0][-1]
    differences = [
        relative_difference_inf(
            _matrix_column(primary_final, column),
            _matrix_column(reference_final, column),
        )
        for column in range(len(boundaries))
    ]
    meets_target = [
        None if accuracy_target is None else bool(difference < accuracy_target)
        for difference in differences
    ]
    if any(value is False for value in meets_target):
        warnings.warn(
            "NDE batch refinement accuracy warning; results retained",
            UserWarning,
            stacklevel=2,
        )
    return {
        "primary_snapshots": primary[0],
        "reference_snapshots": reference[0],
        "primary_segments": primary[1],
        "reference_segments": reference[1],
        "primary_boundary_reports": primary[2],
        "reference_boundary_reports": reference[2],
        "primary_seconds": primary[3],
        "reference_seconds": reference[3],
        "relative_differences_inf": differences,
        "relative_differences_midpoint": [float(value.mid()) for value in differences],
        "target_relative_error": None if accuracy_target is None else accuracy_target.str(20),
        "target_relative_error_met": meets_target,
    }


def transport_path_refined(
    system: AnalyticMatrixSystem | RationalMatrixSystem,
    initial_vector: Any,
    path: list[acb],
    *,
    primary_order: int,
    reference_order: int,
    primary_sample_count: int | None = None,
    reference_sample_count: int | None = None,
    radius_fraction: float = 0.60,
    target_relative_error: Any | None = None,
    save_output_directory: str | Path | None = None,
    save_summary_filename: str = "flintnde_save_points.json",
    save_digits: int = 40,
) -> dict[str, Any]:
    """独立运行两条阶数/采样链，报告末点相对差是否达到用户精度目标。"""

    if reference_order <= primary_order:
        raise ValueError("reference_order must exceed primary_order")
    accuracy_target = _accuracy_target(target_relative_error)
    primary = transport_path(
        system,
        initial_vector,
        path,
        order=primary_order,
        sample_count=primary_sample_count,
        radius_fraction=radius_fraction,
        target_relative_error=accuracy_target,
        write_save_points=False,
    )
    reference = transport_path(
        system,
        initial_vector,
        path,
        order=reference_order,
        sample_count=reference_sample_count,
        radius_fraction=radius_fraction,
        target_relative_error=accuracy_target,
        save_output_directory=save_output_directory,
        save_summary_filename=save_summary_filename,
        save_digits=save_digits,
    )
    difference = relative_difference_inf(primary[0][-1], reference[0][-1])
    meets_target = None if accuracy_target is None else bool(difference < accuracy_target)
    if meets_target is False:
        warnings.warn(
            "NDE refinement accuracy warning; result retained: relative difference "
            f"{difference.str(20)} does not meet {accuracy_target.str(20)}",
            UserWarning,
            stacklevel=2,
        )
    return {
        "primary_snapshots": primary[0],
        "reference_snapshots": reference[0],
        "primary_segments": primary[1],
        "reference_segments": reference[1],
        "primary_seconds": primary[2],
        "reference_seconds": reference[2],
        "relative_difference_inf": difference,
        "relative_difference_midpoint": float(difference.mid()),
        "target_relative_error": (
            None if accuracy_target is None else accuracy_target.str(30)
        ),
        "target_relative_error_met": meets_target,
    }
