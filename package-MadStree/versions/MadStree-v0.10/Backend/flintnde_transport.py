"""MadStree 到 FlintNDE 的中立 JSON 适配器。

本文件只负责 Q(i)(s) 系统、普通点或正则奇点边界、路径和精度参数的转换。
dS topology、边界 normalization、master 顺序、物理 branch 权重全部由 MadStree 持有，
避免数值后端反向猜测物理 convention。

v0.10 的唯一协议由普通折线、领头阶和奇点边界三组 plan/execute schema 组成。
规划阶段生成完整 FlintNDE 计划，执行阶段只恢复计划并输运，禁止重新调用规划器。
所有 schema、嵌套记录、语言值和奇点模式均按唯一现行合同严格校验。
所有 winding 由 Acb/Arb 辐角球计算并认证为唯一整数，不经过 Python complex。
"""

from __future__ import annotations

import json
import sys
import traceback
import warnings
from pathlib import Path
from typing import Any

POLYLINE_PLAN_SCHEMA = "madstree_flintnde_polyline_plan_v2"
POLYLINE_EXECUTE_SCHEMA = "madstree_flintnde_polyline_execute_v2"
LEADING_ORDER_PLAN_SCHEMA = "madstree_flintnde_leading_order_plan_v1"
LEADING_ORDER_EXECUTE_SCHEMA = "madstree_flintnde_leading_order_execute_v1"
SINGULAR_BOUNDARY_PLAN_SCHEMA = "madstree_flintnde_singular_boundary_plan_v1"
SINGULAR_BOUNDARY_EXECUTE_SCHEMA = "madstree_flintnde_singular_boundary_execute_v1"

_SCHEMA_KEYS = {
    POLYLINE_PLAN_SCHEMA: {
        "schema",
        "backendPackagePath",
        "masterDigest",
        "dimension",
        "segments",
        "singularityMode",
        "workingPrecisionDigits",
        "messageLanguage",
    },
    POLYLINE_EXECUTE_SCHEMA: {
        "schema",
        "backendPackagePath",
        "masterDigest",
        "dimension",
        "segments",
        "singularityMode",
        "boundary",
        "workingPrecisionDigits",
        "primaryOrder",
        "referenceOrder",
        "targetRelativeError",
        "certificationMode",
        "messageLanguage",
        "columnVectorConvention",
        "dlogStatus",
    },
    LEADING_ORDER_PLAN_SCHEMA: {
        "schema",
        "backendPackagePath",
        "masterDigest",
        "dimension",
        "letters",
        "start",
        "pole",
        "workingPrecisionDigits",
        "messageLanguage",
    },
    LEADING_ORDER_EXECUTE_SCHEMA: {
        "schema",
        "backendPackagePath",
        "masterDigest",
        "dimension",
        "letters",
        "plan",
        "boundary",
        "start",
        "pole",
        "workingPrecisionDigits",
        "primaryOrder",
        "referenceOrder",
        "targetRelativeError",
        "certificationMode",
        "messageLanguage",
        "columnVectorConvention",
        "dlogStatus",
    },
    SINGULAR_BOUNDARY_PLAN_SCHEMA: {
        "schema",
        "backendPackagePath",
        "masterDigest",
        "dimension",
        "variable",
        "matrix",
        "start",
        "target",
        "workingPrecisionDigits",
        "messageLanguage",
    },
    SINGULAR_BOUNDARY_EXECUTE_SCHEMA: {
        "schema",
        "backendPackagePath",
        "masterDigest",
        "dimension",
        "variable",
        "matrix",
        "branches",
        "plan",
        "start",
        "target",
        "workingPrecisionDigits",
        "primaryOrder",
        "referenceOrder",
        "targetRelativeError",
        "certificationMode",
        "messageLanguage",
        "columnVectorConvention",
        "dlogStatus",
    },
}

def _require_planned_precision(
    record: dict[str, Any],
    requested_digits: int,
    label: str,
) -> int:
    """校验序列化节点的规划精度，禁止执行阶段伪装提升精度。"""

    try:
        planning_digits = int(record["planning_precision_digits"])
    except (KeyError, TypeError, ValueError) as error:
        raise ValueError(
            f"{label} lacks a valid planning precision; replan at the requested "
            "working precision"
        ) from error
    if planning_digits <= 0:
        raise ValueError(f"{label} has a nonpositive planning precision; replan")
    if requested_digits > planning_digits:
        raise ValueError(
            f"{label} was planned at {planning_digits} decimal digits but "
            f"execution requests {requested_digits}; replan at the requested "
            "working precision"
        )
    return planning_digits


def _require_exact_keys(record: Any, expected: set[str], label: str) -> dict[str, Any]:
    """要求 JSON 对象字段集合与当前 schema 完全相同。"""

    if not isinstance(record, dict):
        raise TypeError(f"{label} must be a JSON object")
    actual = set(record)
    if actual != expected:
        missing = sorted(expected - actual)
        unexpected = sorted(actual - expected)
        raise ValueError(
            f"{label} fields do not match the current schema; "
            f"missing={missing}, unexpected={unexpected}"
        )
    return record


def _require_integer(value: Any, label: str, *, minimum: int = 1) -> int:
    """读取严格整数，拒绝 Python bool 冒充整数。"""

    if isinstance(value, bool) or not isinstance(value, int) or value < minimum:
        raise TypeError(f"{label} must be an integer >= {minimum}")
    return value


def _require_string(value: Any, label: str) -> str:
    """读取非空字符串字段。"""

    if not isinstance(value, str) or not value:
        raise TypeError(f"{label} must be a nonempty string")
    return value


def _validate_gaussian_record(record: Any, label: str) -> None:
    """验证 exact Q(i) 或十进制复数的唯一 JSON 表示。"""

    item = _require_exact_keys(record, {"real", "imag"}, label)
    _require_string(item["real"], f"{label}.real")
    _require_string(item["imag"], f"{label}.imag")


def _validate_matrix(
    matrix: Any,
    dimension: int,
    label: str,
    entry_validator: Any,
) -> None:
    """验证方阵维数，并逐项应用给定记录校验器。"""

    if not isinstance(matrix, list) or len(matrix) != dimension:
        raise ValueError(f"{label} must be a {dimension} by {dimension} matrix")
    for row_index, row in enumerate(matrix):
        if not isinstance(row, list) or len(row) != dimension:
            raise ValueError(f"{label}[{row_index}] must have length {dimension}")
        for column_index, entry in enumerate(row):
            entry_validator(entry, f"{label}[{row_index}][{column_index}]")


def _validate_rational_function_record(record: Any, label: str) -> None:
    """验证一个 Q(i)(s) 有理函数的多项式系数记录。"""

    item = _require_exact_keys(record, {"numerator", "denominator"}, label)
    for key in ("numerator", "denominator"):
        coefficients = item[key]
        if not isinstance(coefficients, list) or not coefficients:
            raise ValueError(f"{label}.{key} must be a nonempty coefficient list")
        for index, coefficient in enumerate(coefficients):
            _validate_gaussian_record(coefficient, f"{label}.{key}[{index}]")


def _validate_letter(record: Any, dimension: int, label: str) -> None:
    """验证仿射 dlog letter 与同维 residue 矩阵。"""

    item = _require_exact_keys(record, {"alpha", "beta", "residue"}, label)
    _validate_gaussian_record(item["alpha"], f"{label}.alpha")
    _validate_gaussian_record(item["beta"], f"{label}.beta")
    _validate_matrix(
        item["residue"],
        dimension,
        f"{label}.residue",
        _validate_gaussian_record,
    )


def _validate_letters(records: Any, dimension: int, label: str) -> None:
    """验证 letter 列表；空列表是合法零连接。"""

    if not isinstance(records, list):
        raise TypeError(f"{label} must be a list")
    for index, record in enumerate(records):
        _validate_letter(record, dimension, f"{label}[{index}]")


def _validate_segment(
    record: Any,
    dimension: int,
    label: str,
    *,
    execute: bool,
) -> None:
    """验证一段 MadStree 仿射拉回及其可选执行计划。"""

    expected = {"start", "points", "letters", "fromUserIndex", "userIndices"}
    if execute:
        expected = expected | {"plan"}
    item = _require_exact_keys(record, expected, label)
    _require_string(item["start"], f"{label}.start")
    _require_integer(item["fromUserIndex"], f"{label}.fromUserIndex", minimum=0)
    points = item["points"]
    user_indices = item["userIndices"]
    if not isinstance(points, list) or not points:
        raise ValueError(f"{label}.points must be a nonempty list")
    if not isinstance(user_indices, list) or len(user_indices) != len(points):
        raise ValueError(
            f"{label}.userIndices must have the same nonzero length as points"
        )
    for index, point in enumerate(points):
        _validate_gaussian_record(point, f"{label}.points[{index}]")
        _require_integer(
            user_indices[index],
            f"{label}.userIndices[{index}]",
            minimum=1,
        )
    if len(set(user_indices)) != len(user_indices):
        raise ValueError(f"{label}.userIndices must be distinct within a group")
    _validate_letters(item["letters"], dimension, f"{label}.letters")
    if execute and not isinstance(item["plan"], dict):
        raise TypeError(f"{label}.plan must be a serialized FlintNDE plan object")


def _validate_boundary(records: Any, dimension: int, label: str) -> None:
    """验证一个普通点列向量。"""

    if not isinstance(records, list) or len(records) != dimension:
        raise ValueError(f"{label} must contain {dimension} complex records")
    for index, record in enumerate(records):
        _validate_gaussian_record(record, f"{label}[{index}]")


def _validate_branches(records: Any, dimension: int, label: str) -> None:
    """验证正则奇点分支的唯一 {a,b,C} 记录。"""

    if not isinstance(records, list) or not records:
        raise ValueError(f"{label} must be a nonempty list")
    for index, record in enumerate(records):
        branch = _require_exact_keys(record, {"boundary"}, f"{label}[{index}]")
        boundary = _require_exact_keys(
            branch["boundary"],
            {"a", "b", "C"},
            f"{label}[{index}].boundary",
        )
        _validate_gaussian_record(boundary["a"], f"{label}[{index}].boundary.a")
        _require_integer(boundary["b"], f"{label}[{index}].boundary.b", minimum=0)
        vector = boundary["C"]
        if not isinstance(vector, list) or len(vector) != dimension:
            raise ValueError(
                f"{label}[{index}].boundary.C must contain {dimension} entries"
            )
        for entry_index, entry in enumerate(vector):
            _validate_gaussian_record(
                entry,
                f"{label}[{index}].boundary.C[{entry_index}]",
            )


def _message_language(data: dict[str, Any]) -> str:
    """读取严格区分大小写的消息语言。"""

    language = data["messageLanguage"]
    if language not in {"EN", "CN"}:
        raise ValueError('messageLanguage must be exactly "EN" or "CN"')
    return language


def _singularity_mode(data: dict[str, Any]) -> str:
    """读取唯一奇点策略。"""

    mode = data["singularityMode"]
    if mode not in {"avoid", "singularity_jump"}:
        raise ValueError(
            'singularityMode must be exactly "avoid" or "singularity_jump"'
        )
    return mode


def _validate_execution_controls(
    data: dict[str, Any],
    expected_convention: str = "Y'=A(s)Y",
) -> None:
    """验证 execute schema 共享的精度、认证和 convention 字段。"""

    primary = _require_integer(data["primaryOrder"], "primaryOrder")
    reference = _require_integer(data["referenceOrder"], "referenceOrder")
    if reference <= primary:
        raise ValueError("referenceOrder must exceed primaryOrder")
    _require_string(data["targetRelativeError"], "targetRelativeError")
    if data["certificationMode"] not in {"embedded", "certified"}:
        raise ValueError(
            'certificationMode must be exactly "embedded" or "certified"'
        )
    if data["columnVectorConvention"] != expected_convention:
        raise ValueError(
            f"columnVectorConvention must be exactly {expected_convention}"
        )
    if data["dlogStatus"] != "certifiedByFormulaChecks":
        raise ValueError("dlogStatus must be exactly certifiedByFormulaChecks")


def _validate_request(data: Any) -> dict[str, Any]:
    """验证六个现行 schema；缺字段和多余字段一律拒绝。"""

    if not isinstance(data, dict):
        raise TypeError("MadStree-FlintNDE request must be a JSON object")
    schema = data.get("schema")
    if schema not in _SCHEMA_KEYS:
        raise ValueError("unsupported MadStree-FlintNDE schema")
    _require_exact_keys(data, _SCHEMA_KEYS[schema], "request")
    _require_string(data["backendPackagePath"], "backendPackagePath")
    _require_string(data["masterDigest"], "masterDigest")
    dimension = _require_integer(data["dimension"], "dimension")
    _require_integer(
        data["workingPrecisionDigits"],
        "workingPrecisionDigits",
        minimum=20,
    )
    _message_language(data)

    if schema in {POLYLINE_PLAN_SCHEMA, POLYLINE_EXECUTE_SCHEMA}:
        _singularity_mode(data)
        segments = data["segments"]
        if not isinstance(segments, list) or not segments:
            raise ValueError("segments must be a nonempty list")
        for index, segment in enumerate(segments):
            _validate_segment(
                segment,
                dimension,
                f"segments[{index}]",
                execute=schema == POLYLINE_EXECUTE_SCHEMA,
            )
        if schema == POLYLINE_EXECUTE_SCHEMA:
            _validate_boundary(data["boundary"], dimension, "boundary")
            _validate_execution_controls(data)
    elif schema in {LEADING_ORDER_PLAN_SCHEMA, LEADING_ORDER_EXECUTE_SCHEMA}:
        _validate_letters(data["letters"], dimension, "letters")
        _require_string(data["start"], "start")
        _require_string(data["pole"], "pole")
        if schema == LEADING_ORDER_EXECUTE_SCHEMA:
            if not isinstance(data["plan"], dict):
                raise TypeError("plan must be a serialized FlintNDE plan object")
            _validate_boundary(data["boundary"], dimension, "boundary")
            _validate_execution_controls(data)
    else:
        _require_string(data["variable"], "variable")
        _require_string(data["start"], "start")
        _require_string(data["target"], "target")
        _validate_matrix(
            data["matrix"],
            dimension,
            "matrix",
            _validate_rational_function_record,
        )
        if schema == SINGULAR_BOUNDARY_EXECUTE_SCHEMA:
            if not isinstance(data["plan"], dict):
                raise TypeError(
                    "plan must be a serialized FlintNDE adaptive path object"
                )
            _validate_branches(data["branches"], dimension, "branches")
            _validate_execution_controls(
                data,
                expected_convention="Y'=A(" + data["variable"] + ")Y",
            )
    return data


def _load_input(path: Path) -> dict[str, Any]:
    """读取并严格验证当前 adapter 请求。"""

    return _validate_request(json.loads(path.read_text(encoding="utf-8")))

def _acb_record(value: Any, digits: int) -> dict[str, str]:
    """把 Acb 中点和球半径写成十进制字符串，避免 binary64 截断。"""

    return {
        "real": value.real.mid().str(digits, radius=False, more=True),
        "imag": value.imag.mid().str(digits, radius=False, more=True),
        "realRadius": value.real.rad().str(digits),
        "imagRadius": value.imag.rad().str(digits),
    }


def _point_record(value: Any, digits: int) -> dict[str, str]:
    """序列化路径普通点。"""

    return _acb_record(value, digits)


def _planned_point_assignments(
    plan: Any,
    points: list[Any],
    user_indices: list[int],
) -> list[dict[str, Any]]:
    """把每个组内用户点唯一映射到节点快照或 dense-output assignment。"""

    sample_by_index = {
        int(item["user_point_index"]): item
        for item in plan.sample_assignments
        if item["user_point_index"] is not None
    }
    assignments: list[dict[str, Any]] = []
    for local_index, (point, user_index) in enumerate(zip(points, user_indices)):
        sample = sample_by_index.get(local_index)
        if sample is not None:
            assignments.append(
                {
                    "userIndex": user_index,
                    "localPointIndex": local_index,
                    "source": str(sample["source"]),
                    "nodeIndex": None,
                    "segmentIndex": int(sample["segment_index"]),
                }
            )
            continue
        matching_nodes = [
            node_index
            for node_index, node in enumerate(plan.nodes)
            if abs(node - point).contains(0)
        ]
        if not matching_nodes:
            raise ValueError(
                f"user point {user_index} is absent from both node snapshots "
                "and dense-output assignments"
            )
        assignments.append(
            {
                "userIndex": user_index,
                "localPointIndex": local_index,
                "source": "node_snapshot",
                "nodeIndex": matching_nodes[-1],
                "segmentIndex": None,
            }
        )
    return assignments


def _executed_point_values(
    result: dict[str, Any],
    assignments: list[dict[str, Any]],
    digits: int,
    dimension: int,
) -> list[dict[str, Any]]:
    """按规划映射合并节点快照和 dense output，完整返回该组用户点值。"""

    sample_by_index = {
        int(item["user_point_index"]): item
        for item in result["sample_results"]
        if item["user_point_index"] is not None
    }
    records: list[dict[str, Any]] = []
    for assignment in assignments:
        local_index = int(assignment["localPointIndex"])
        node_index = assignment["nodeIndex"]
        if node_index is None:
            if local_index not in sample_by_index:
                raise ValueError(
                    f"dense-output value for local point {local_index} is missing"
                )
            vector = sample_by_index[local_index]["value"]
        else:
            vector = result["reference_snapshots"][int(node_index)]
        records.append(
            {
                "userIndex": int(assignment["userIndex"]),
                "localPointIndex": local_index,
                "source": assignment["source"],
                "values": [
                    _acb_record(vector[row, 0], digits) for row in range(dimension)
                ],
            }
        )
    return records


def _nearest_integer_ball(value: Any, label: str) -> int:
    """从 Arb 小区间认证唯一最近整数；区间含混时拒绝猜测分支。"""

    from flint import arb  # pylint: disable=import-outside-toplevel

    rounded = (value + arb("0.5")).floor()
    try:
        integer = rounded.unique_fmpz()
    except ValueError as error:
        raise ArithmeticError(
            f"{label} is not a uniquely certified winding number: {value.str(30)}"
        ) from error
    return int(integer)

def _letters_to_partial_fraction_system(
    letter_records: list[dict[str, Any]],
    dimension: int,
    digest: str,
    acb: Any,
    acb_mat: Any,
    gaussian_rational: Any,
) -> Any:
    """由 dlog letters 构造 ``A(s)=Σ M_j/(s-p_j)``（``p_j=-α_j/β_j``，常系数项为零）。

    letter_j 沿仿射路径为 ``α_j+β_j s``，对 ``Log`` 求导得 ``β_j/(α_j+β_j s)``，
    即留数为 letter 矩阵本身、极点在 ``-α_j/β_j`` 的简单极点项；同极点合并留数
    （多 letter 同点消失即多变量简并情形，一律按合并后单变量极点处理）。
    """

    from flintnde import PartialFractionSystem  # pylint: disable=import-outside-toplevel

    merged: list[tuple[Any, Any]] = []
    for record in letter_records:
        beta = gaussian_rational(record["beta"])
        if beta.is_zero:
            continue
        alpha = gaussian_rational(record["alpha"])
        if alpha.is_zero:
            raise ValueError("dlog letter vanishes at the path anchor; singular boundary required")
        residue = acb_mat(
            [
                [
                    acb(entry["real"], entry["imag"])
                    for entry in row
                ]
                for row in record["residue"]
            ]
        )
        if residue.nrows() != dimension or residue.ncols() != dimension:
            raise ValueError("letter residue matrix dimension mismatch")
        pole = -alpha / beta
        for index, (existing_pole, existing_residue) in enumerate(merged):
            if existing_pole == pole:
                merged[index] = (existing_pole, existing_residue + residue)
                break
        else:
            merged.append((pole, residue))
    if merged:
        poles, residues = zip(*merged)
    else:
        # 所有 letters 沿该段均为非零常量时，拉回连接严格为零。
        poles, residues = (), ()
    return PartialFractionSystem(
        constant=acb_mat(dimension, dimension),
        residues=tuple(residues),
        poles=tuple(pole.to_acb() for pole in poles),
        name=f"MadStree-{digest[:12]}",
    )


def _build_rational_system(
    data: dict[str, Any], dimension: int, digest: str, rational_function: Any
) -> Any:
    """由 Q(i)(s) 有理矩阵记录构造 ``RationalMatrixSystem``（奇点段与 v1 普通段）。"""

    from flintnde import RationalMatrixSystem  # pylint: disable=import-outside-toplevel

    matrix_records = data["matrix"]
    if len(matrix_records) != dimension or any(len(row) != dimension for row in matrix_records):
        raise ValueError("serialized matrix dimension mismatch")
    matrix = tuple(
        tuple(
            rational_function(entry["numerator"], entry["denominator"])
            for entry in row
        )
        for row in matrix_records
    )
    return RationalMatrixSystem(
        matrix,
        variable_name=data["variable"],
        name=f"MadStree-{digest[:12]}",
    )


def _resolve_backend_path(data: dict[str, Any]) -> Path:
    """解析并验证内置 FlintNDE 目录。"""

    backend_path = Path(data["backendPackagePath"]).resolve()
    package_file = backend_path / "flintnde" / "__init__.py"
    if not package_file.is_file():
        raise FileNotFoundError(f"FlintNDE package not found: {package_file}")
    if str(backend_path) not in sys.path:
        sys.path.insert(0, str(backend_path))
    return backend_path


def _polyline_segment_system(
    data: dict[str, Any],
    segment: dict[str, Any],
    segment_index: int,
    dimension: int,
    acb: Any,
    acb_mat: Any,
    gaussian_rational: Any,
) -> tuple[Any, Any, list[Any]]:
    """重建一个复仿射组的 dlog 拉回系统，并拒绝用户点处的极点。"""

    system = _letters_to_partial_fraction_system(
        segment["letters"],
        dimension,
        f"{data['masterDigest']}-seg{segment_index}",
        acb,
        acb_mat,
        gaussian_rational,
    )
    start = gaussian_rational(segment["start"]).to_acb()
    points = [gaussian_rational(point).to_acb() for point in segment["points"]]
    for pole in system.singularities:
        if (pole - start).contains(0):
            raise ValueError(
                f"segment {segment_index} anchor coincides with a dlog letter pole"
            )
        for local_index, point in enumerate(points):
            if (pole - point).contains(0):
                raise ValueError(
                    f"segment {segment_index} user point {local_index} "
                    "coincides with a dlog letter pole"
                )
    return system, start, points


def _run_polyline_plan(data: dict[str, Any]) -> dict[str, Any]:
    """只规划各仿射段并序列化完整 FlintNDE 计划，不执行微分方程。"""

    backend_path = _resolve_backend_path(data)
    from flint import acb, acb_mat  # pylint: disable=import-outside-toplevel
    from flintnde import (  # pylint: disable=import-outside-toplevel
        SingularPathError,
        configure_working_precision,
        gaussian_rational,
        plan_transport_path,
        planned_path_to_json,
    )

    digits = int(data["workingPrecisionDigits"])
    configure_working_precision(digits)
    dimension = int(data["dimension"])
    message_language = _message_language(data)
    singularity_mode = _singularity_mode(data)

    planned_segments: list[dict[str, Any]] = []
    for segment_index, segment in enumerate(data["segments"]):
        system, start_point, target_points = _polyline_segment_system(
            data,
            segment,
            segment_index,
            dimension,
            acb,
            acb_mat,
            gaussian_rational,
        )
        try:
            plan = plan_transport_path(
                system,
                start_point,
                target_points,
                singularity_mode=singularity_mode,
                message_language=message_language,
            )
        except SingularPathError as error:
            return {
                "status": "singularPathRefused",
                "schema": data["schema"],
                "masterDigest": data["masterDigest"],
                "segmentIndex": segment_index,
                "messageLanguage": message_language,
                "singularityMode": singularity_mode,
                "message": str(error),
                "singularPathPairs": [
                    [_point_record(first, digits), _point_record(second, digits)]
                    for first, second in error.singular_path_pairs
                ],
            }
        point_assignments = _planned_point_assignments(
            plan,
            target_points,
            [int(index) for index in segment["userIndices"]],
        )
        planned_segments.append(
            {
                "segmentIndex": segment_index,
                "serializedPlan": planned_path_to_json(plan, digits=digits),
                "pointAssignments": point_assignments,
                "planReport": plan.report,
                "jumpSpecs": [
                    {
                        "segmentNodeIndex": node_index,
                        "pole": spec.pole.str(digits),
                        "incoming": _point_record(spec.incoming, digits),
                        "outgoing": _point_record(spec.outgoing, digits),
                        "matchDistance": spec.match_distance.str(digits),
                    }
                    for node_index, spec in sorted(plan.singularity_jump_segments.items())
                ],
            }
        )

    if singularity_mode == "avoid":
        message = (
            "MadStree planned the supplied multivariable polyline in "
            "avoid-singularity mode (default); execution must consume these "
            "stored plans without replanning."
            if message_language == "EN"
            else "MadStree 已按缺省避开奇点模式规划输入的多变量折线；"
            "执行阶段必须直接使用这些已保存计划，不得重新规划。"
        )
    else:
        message = (
            "MadStree planned the supplied multivariable polyline in explicit "
            "singularity-jump mode. A singularity jump fixes a multivalued "
            "branch equivalent to a detour path; the user must confirm that "
            "branch before execution."
            if message_language == "EN"
            else "MadStree 已按显式奇点折跃模式规划输入的多变量折线。"
            "奇点折跃选择的多值分支等价于某条绕行路径，用户必须在执行前"
            "自行确认该分支。"
        )
    return {
        "status": "success",
        "schema": data["schema"],
        "planningAction": "plan_raw_segments_without_execution",
        "masterDigest": data["masterDigest"],
        "dimension": dimension,
        "backendPackagePath": str(backend_path),
        "workingPrecisionDigits": digits,
        "singularityMode": singularity_mode,
        "messageLanguage": message_language,
        "message": message,
        "segmentCount": len(planned_segments),
        "segments": planned_segments,
    }

def _run_polyline_execute(data: dict[str, Any]) -> dict[str, Any]:
    """只恢复并执行已序列化计划；本函数不导入也不调用路径规划器。"""

    backend_path = _resolve_backend_path(data)
    from flint import acb, acb_mat  # pylint: disable=import-outside-toplevel
    from flintnde import (  # pylint: disable=import-outside-toplevel
        configure_working_precision,
        gaussian_rational,
        planned_path_from_json,
        transport_planned_path_refined,
    )

    digits = int(data["workingPrecisionDigits"])
    configure_working_precision(digits)
    dimension = int(data["dimension"])
    message_language = _message_language(data)
    if message_language not in {"EN", "CN"}:
        raise ValueError('messageLanguage must be "EN" or "CN"')
    certification_mode = data["certificationMode"]
    if certification_mode not in ("certified", "embedded"):
        raise ValueError('certificationMode must be "certified" or "embedded"')
    boundary_records = data["boundary"]
    if len(boundary_records) != dimension:
        raise ValueError("serialized boundary dimension mismatch")
    vector = acb_mat([[acb(item["real"], item["imag"])] for item in boundary_records])
    segments = data["segments"]
    if not isinstance(segments, list) or not segments:
        raise ValueError("polyline execution requires at least one planned segment")

    segment_payloads: list[dict[str, Any]] = []
    planning_precisions: list[int] = []
    total_primary_seconds = 0.0
    total_reference_seconds = 0.0
    all_targets_met = True
    actual_certification_modes: list[str] = []
    for segment_index, segment in enumerate(segments):
        system, start, points = _polyline_segment_system(
            data,
            segment,
            segment_index,
            dimension,
            acb,
            acb_mat,
            gaussian_rational,
        )
        if "plan" not in segment:
            raise ValueError(f"segment {segment_index} lacks a serialized FlintNDE plan")
        plan_record = segment["plan"]
        planning_precisions.append(
            _require_planned_precision(
                plan_record, digits, f"segment {segment_index} plan"
            )
        )
        plan = planned_path_from_json(plan_record, system=system)
        if plan.report["singularity_mode"] != data["singularityMode"]:
            raise ValueError(
                f"segment {segment_index} plan singularity mode does not match the request"
            )
        if not abs(plan.nodes[0] - start).contains(0):
            raise ValueError(f"segment {segment_index} plan start does not match its system")
        if not abs(plan.nodes[-1] - points[-1]).contains(0):
            raise ValueError(
                f"segment {segment_index} final plan node does not match its final user point"
            )
        point_assignments = _planned_point_assignments(
            plan,
            points,
            [int(index) for index in segment["userIndices"]],
        )

        result = transport_planned_path_refined(
            system,
            vector,
            plan,
            primary_order=int(data["primaryOrder"]),
            reference_order=int(data["referenceOrder"]),
            radius_fraction=0.60,
            target_relative_error=data["targetRelativeError"],
            certification_mode=certification_mode,
        )
        vector = result["reference_snapshots"][-1]
        actual_mode = str(result["certification_mode"])
        actual_certification_modes.append(actual_mode)
        total_primary_seconds += float(result["primary_seconds"])
        total_reference_seconds += float(result["reference_seconds"])
        segment_payloads.append(
            {
                "segmentIndex": segment_index,
                "planReport": plan.report,
                "jumpSpecs": [
                    {
                        "segmentNodeIndex": node_index,
                        "pole": spec.pole.str(digits),
                        "incoming": _point_record(spec.incoming, digits),
                        "outgoing": _point_record(spec.outgoing, digits),
                        "matchDistance": spec.match_distance.str(digits),
                    }
                    for node_index, spec in sorted(plan.singularity_jump_segments.items())
                ],
                "certificationModeRequested": result[
                    "certification_mode_requested"
                ],
                "certificationMode": actual_mode,
                "relativeDifferenceInf": result["relative_difference_inf"].str(digits),
                "relativeDifferenceMidpoint": result["relative_difference_midpoint"],
                "targetRelativeErrorMet": (
                    True
                    if result["target_relative_error_met"] is None
                    else bool(result["target_relative_error_met"])
                ),
                "pointAssignments": point_assignments,
                "pointValues": _executed_point_values(
                    result,
                    point_assignments,
                    digits,
                    dimension,
                ),
                "endpointValues": [
                    _acb_record(vector[row, 0], digits) for row in range(dimension)
                ],
            }
        )
        all_targets_met = all_targets_met and (
            result["target_relative_error_met"] is None
            or bool(result["target_relative_error_met"])
        )

    actual_mode = (
        actual_certification_modes[0]
        if len(set(actual_certification_modes)) == 1
        else "mixed"
    )
    message = (
        "MadStree executed the stored FlintNDE plans directly; no path "
        "replanning was performed."
        if message_language == "EN"
        else "MadStree 已直接执行保存的 FlintNDE 计划；未再次规划路径。"
    )
    return {
        "status": "success",
        "schema": data["schema"],
        "executionAction": "execute_existing_plans_without_replanning",
        "masterDigest": data["masterDigest"],
        "dimension": dimension,
        "planningPrecisionDigits": min(planning_precisions),
        "workingPrecisionDigits": digits,
        "columnVectorConvention": data["columnVectorConvention"],
        "dlogStatus": data["dlogStatus"],
        "backendPackagePath": str(backend_path),
        "certificationModeRequested": certification_mode,
        "certificationMode": actual_mode,
        "messageLanguage": message_language,
        "message": message,
        "segmentCount": len(segment_payloads),
        "segments": segment_payloads,
        "primaryOrder": int(data["primaryOrder"]),
        "referenceOrder": int(data["referenceOrder"]),
        "primarySeconds": total_primary_seconds,
        "referenceSeconds": total_reference_seconds,
        "targetRelativeErrorMet": all_targets_met,
        "finalValues": [
            _acb_record(vector[row, 0], digits) for row in range(dimension)
        ],
    }


def _leading_order_geometry(
    data: dict[str, Any],
    dimension: int,
    acb: Any,
    acb_mat: Any,
    arb: Any,
    gaussian_rational: Any,
) -> tuple[Any, Any, Any, Any, Any, Any]:
    """构造 LO 到达段、目标极点和保守入射匹配点。"""

    system = _letters_to_partial_fraction_system(
        data["letters"],
        dimension,
        data["masterDigest"],
        acb,
        acb_mat,
        gaussian_rational,
    )
    start = gaussian_rational(data["start"]).to_acb()
    pole_parameter = data["pole"]
    pole_coordinate = gaussian_rational(pole_parameter).to_acb()
    pole_index = None
    for index, singularity in enumerate(system.singularities):
        if (singularity - pole_coordinate).contains(0):
            pole_index = index
            break
    if pole_index is None:
        raise ValueError(
            "the requested leading-order point is not a dlog letter pole "
            "along the arrival segment"
        )
    for index, singularity in enumerate(system.singularities):
        if index != pole_index and (singularity - start).contains(0):
            raise ValueError(
                "arrival segment anchor coincides with another dlog letter pole"
            )
    pole = acb(system.singularities[pole_index])
    corridor = None
    for index, other in enumerate(system.singularities):
        if index == pole_index:
            continue
        separation = abs(other - pole)
        corridor = separation if corridor is None else min(corridor, separation)
    clearance = abs(pole - start)
    if clearance.contains(0):
        raise ValueError("arrival segment degenerates: anchor coincides with the pole")
    match_distance = (
        arb("0.4") * corridor if corridor is not None else arb("0.45") * clearance
    )
    match_distance = min(match_distance, arb("0.45") * clearance)
    unit = (pole - start) / clearance
    incoming = pole - match_distance * unit
    return system, start, pole_index, pole, incoming, match_distance


def _run_leading_order_plan(data: dict[str, Any]) -> dict[str, Any]:
    """只生成到 LO 入射匹配点的计划；局部基反解留给执行阶段。"""

    backend_path = _resolve_backend_path(data)
    from flint import acb, acb_mat, arb  # pylint: disable=import-outside-toplevel
    from flintnde import (  # pylint: disable=import-outside-toplevel
        configure_working_precision,
        gaussian_rational,
        plan_transport_path,
        planned_path_to_json,
    )

    digits = int(data["workingPrecisionDigits"])
    configure_working_precision(digits)
    dimension = int(data["dimension"])
    system, start, _pole_index, pole, incoming, match_distance = (
        _leading_order_geometry(
            data,
            dimension,
            acb,
            acb_mat,
            arb,
            gaussian_rational,
        )
    )
    plan = plan_transport_path(
        system,
        start,
        [incoming],
        singularity_mode="avoid",
        message_language=_message_language(data),
    )
    return {
        "status": "success",
        "schema": data["schema"],
        "planningAction": "plan_leading_order_match_without_execution",
        "masterDigest": data["masterDigest"],
        "backendPackagePath": str(backend_path),
        "workingPrecisionDigits": digits,
        "pole": pole.str(digits),
        "poleParameter": data["pole"],
        "incomingMatch": _point_record(incoming, digits),
        "matchDistance": match_distance.str(digits),
        "serializedPlan": planned_path_to_json(plan, digits=digits),
        "planReport": plan.report,
    }


def _run_leading_order_execute(data: dict[str, Any]) -> dict[str, Any]:
    """恢复 LO 入射计划并反解局部基；本函数不调用路径规划器。"""

    backend_path = _resolve_backend_path(data)
    from flint import acb, acb_mat, arb  # pylint: disable=import-outside-toplevel
    from flintnde import (  # pylint: disable=import-outside-toplevel
        SingularityJumpBasis,
        SingularityJumpError,
        configure_working_precision,
        gaussian_rational,
        planned_path_from_json,
        transport_planned_path_refined,
    )

    digits = int(data["workingPrecisionDigits"])
    configure_working_precision(digits)
    dimension = int(data["dimension"])
    boundary_records = data["boundary"]
    if len(boundary_records) != dimension:
        raise ValueError("serialized boundary dimension mismatch")
    vector = acb_mat([[acb(item["real"], item["imag"])] for item in boundary_records])
    system, start, pole_index, pole, expected_incoming, match_distance = (
        _leading_order_geometry(
            data,
            dimension,
            acb,
            acb_mat,
            arb,
            gaussian_rational,
        )
    )
    if "plan" not in data:
        raise ValueError("leading-order execution lacks a serialized FlintNDE plan")
    plan_record = data["plan"]
    planning_digits = _require_planned_precision(
        plan_record, digits, "leading-order plan"
    )
    plan = planned_path_from_json(plan_record, system=system)
    if not abs(plan.nodes[0] - start).contains(0):
        raise ValueError("leading-order plan start does not match its arrival segment")
    if not abs(plan.nodes[-1] - expected_incoming).contains(0):
        raise ValueError("leading-order plan target does not match its incoming point")
    incoming = plan.nodes[-1]
    result = transport_planned_path_refined(
        system,
        vector,
        plan,
        primary_order=int(data["primaryOrder"]),
        reference_order=int(data["referenceOrder"]),
        radius_fraction=0.60,
        target_relative_error=data["targetRelativeError"],
        certification_mode=data["certificationMode"],
    )
    match_vector = result["reference_snapshots"][-1]
    try:
        basis = SingularityJumpBasis(system, pole_index, int(data["referenceOrder"]))
        incoming_local = incoming - pole
        lift = (plan.nodes[0] - pole).arg()
        for previous_node, node in zip(plan.nodes[:-1], plan.nodes[1:]):
            lift += ((node - pole) / (previous_node - pole)).arg()
        incoming_lift = incoming_local.arg()
        winding = _nearest_integer_ball(
            (lift - incoming_lift) / (arb(2) * arb.pi()),
            "leading-order incoming winding",
        )
        constants = basis.lifted_evaluate(incoming_local, winding).solve(match_vector)
    except (SingularityJumpError, ArithmeticError) as error:
        return {
            "status": "leadingOrderRefused",
            "schema": data["schema"],
            "executionAction": "execute_existing_leading_order_plan_without_replanning",
            "masterDigest": data["masterDigest"],
            "planningPrecisionDigits": planning_digits,
            "workingPrecisionDigits": digits,
            "pole": pole.str(digits),
            "poleParameter": data["pole"],
            "reason": str(error),
        }

    eigenvectors = [
        [
            _acb_record(basis.eigenvector_matrix[row, column], digits)
            for row in range(dimension)
        ]
        for column in range(dimension)
    ]
    return {
        "status": "success",
        "schema": data["schema"],
        "executionAction": "execute_existing_leading_order_plan_without_replanning",
        "masterDigest": data["masterDigest"],
        "dimension": dimension,
        "planningPrecisionDigits": planning_digits,
        "workingPrecisionDigits": digits,
        "columnVectorConvention": data["columnVectorConvention"],
        "backendPackagePath": str(backend_path),
        "pole": pole.str(digits),
        "poleParameter": data["pole"],
        "branchConvention": basis.manifest["branch_convention"],
        "exponents": [exponent.str(digits) for exponent in basis.exponents],
        "leadingVectors": eigenvectors,
        "constants": [
            _acb_record(constants[row, 0], digits) for row in range(dimension)
        ],
        "incomingMatch": _point_record(incoming, digits),
        "matchDistance": match_distance.str(digits),
        "incomingWinding": winding,
        "incomingResidual": basis.residual_report(incoming_local),
        "certificationModeRequested": result["certification_mode_requested"],
        "certificationMode": result["certification_mode"],
        "relativeDifferenceInf": result["relative_difference_inf"].str(digits),
        "relativeDifferenceMidpoint": result["relative_difference_midpoint"],
        "targetRelativeErrorMet": (
            True
            if result["target_relative_error_met"] is None
            else bool(result["target_relative_error_met"])
        ),
        "primarySeconds": float(result["primary_seconds"]),
        "referenceSeconds": float(result["reference_seconds"]),
    }


def _singular_boundary_geometry(data: dict[str, Any]) -> tuple[Any, Any, Any]:
    """构造一般有理矩阵，并验证正则奇点起点与普通终点。"""

    from flintnde import (  # pylint: disable=import-outside-toplevel
        NamedPoint,
        analyze_singularities,
        classify_point,
        gaussian_rational,
        rational_function,
    )

    dimension = int(data["dimension"])
    system = _build_rational_system(
        data,
        dimension,
        data["masterDigest"],
        rational_function,
    )
    start = gaussian_rational(data["start"]).to_acb()
    target = gaussian_rational(data["target"]).to_acb()
    inventory = analyze_singularities(system)
    start_classification = classify_point(
        NamedPoint("madstree_singular_boundary", start),
        inventory,
    )
    target_classification = classify_point(
        NamedPoint("madstree_boundary_anchor", target),
        inventory,
    )
    if start_classification.kind != "regular_singular":
        raise ValueError(
            "MadStree singular boundary start must be an internally verified "
            f"regular singular point; got {start_classification.kind}"
        )
    if target_classification.kind != "ordinary":
        raise ValueError(
            "MadStree singular boundary target must be ordinary; "
            f"got {target_classification.kind}"
        )
    return system, start, target


def _run_singular_boundary_plan(data: dict[str, Any]) -> dict[str, Any]:
    """规划正则奇点边界到有限 anchor 的完整 AdaptivePath。"""

    backend_path = _resolve_backend_path(data)
    from flintnde import (  # pylint: disable=import-outside-toplevel
        NamedPoint,
        adaptive_path_to_json,
        build_adaptive_path,
        configure_working_precision,
    )

    digits = int(data["workingPrecisionDigits"])
    configure_working_precision(digits)
    language = _message_language(data)
    system, start, target = _singular_boundary_geometry(data)
    path = build_adaptive_path(
        system,
        NamedPoint("madstree_singular_boundary", start),
        NamedPoint("madstree_boundary_anchor", target),
        path_name="madstree_singular_boundary_to_anchor",
        max_step_over_radius=0.45,
        singularity_mode="avoid",
        message_language=language,
    )
    return {
        "status": "success",
        "schema": data["schema"],
        "planningAction": "plan_singular_boundary_without_execution",
        "masterDigest": data["masterDigest"],
        "dimension": int(data["dimension"]),
        "backendPackagePath": str(backend_path),
        "workingPrecisionDigits": digits,
        "messageLanguage": language,
        "serializedPlan": adaptive_path_to_json(path, digits=digits),
        "pathPointCount": len(path),
        "internalSingularityCount": len(path.internal_singularities),
        "startClassification": path.start_classification.to_json(),
        "targetClassification": path.target_classification.to_json(),
        "stepReports": list(path.step_reports),
    }


def _run_singular_boundary_execute(data: dict[str, Any]) -> dict[str, Any]:
    """恢复奇点边界计划并共享局部基输运全部分支；不调用规划器。"""

    backend_path = _resolve_backend_path(data)
    from flint import acb_mat  # pylint: disable=import-outside-toplevel
    from flintnde import (  # pylint: disable=import-outside-toplevel
        adaptive_path_from_json,
        configure_working_precision,
        frobenius_boundary,
        transport_frobenius_boundaries_refined,
    )

    digits = int(data["workingPrecisionDigits"])
    configure_working_precision(digits)
    language = _message_language(data)
    system, start, target = _singular_boundary_geometry(data)
    planning_digits = _require_planned_precision(
        data["plan"],
        digits,
        "singular-boundary plan",
    )
    path = adaptive_path_from_json(system, data["plan"])
    if path.singularity_mode != "avoid":
        raise ValueError("singular-boundary plan must use avoid mode")
    if (
        path.start_classification.value is None
        or not abs(path.start_classification.value - start).contains(0)
    ):
        raise ValueError(
            "singular-boundary plan classification does not match its start"
        )
    if (
        path.target_classification.value is None
        or not abs(path.target_classification.value - target).contains(0)
        or not abs(path[-1] - target).contains(0)
    ):
        raise ValueError(
            "singular-boundary plan classification does not match its target"
        )
    if path.start_classification.kind != "regular_singular":
        raise ValueError("singular-boundary plan start is not regular singular")
    if path.target_classification.kind != "ordinary":
        raise ValueError("singular-boundary plan target is not ordinary")

    boundaries = [
        frobenius_boundary([record["boundary"]])
        for record in data["branches"]
    ]
    with warnings.catch_warnings(record=True) as caught:
        warnings.simplefilter("always")
        result = transport_frobenius_boundaries_refined(
            system,
            boundaries,
            path,
            primary_order=int(data["primaryOrder"]),
            reference_order=int(data["referenceOrder"]),
            radius_fraction=0.60,
            target_relative_error=data["targetRelativeError"],
            certification_mode=data["certificationMode"],
        )
    final_matrix = result["reference_snapshots"][-1]
    final_vectors: list[Any] = []
    for column in range(len(boundaries)):
        vector = acb_mat(int(data["dimension"]), 1)
        for row in range(int(data["dimension"])):
            vector[row, 0] = final_matrix[row, column]
        final_vectors.append(vector)

    return {
        "status": "success",
        "schema": data["schema"],
        "executionAction": (
            "execute_existing_singular_boundary_plan_without_replanning"
        ),
        "masterDigest": data["masterDigest"],
        "dimension": int(data["dimension"]),
        "planningPrecisionDigits": planning_digits,
        "workingPrecisionDigits": digits,
        "columnVectorConvention": data["columnVectorConvention"],
        "dlogStatus": data["dlogStatus"],
        "backendPackagePath": str(backend_path),
        "certificationModeRequested": result[
            "certification_mode_requested"
        ],
        "certificationMode": result["certification_mode"],
        "messageLanguage": language,
        "message": (
            "MadStree executed the stored singular-boundary plan directly; "
            "no path replanning was performed."
            if language == "EN"
            else "MadStree 已直接执行保存的奇点边界计划；未再次规划路径。"
        ),
        "startClassification": path.start_classification.to_json(),
        "targetClassification": path.target_classification.to_json(),
        "path": [_point_record(point, digits) for point in path],
        "pathPointCount": len(path),
        "internalSingularityCount": len(path.internal_singularities),
        "primaryOrder": int(data["primaryOrder"]),
        "referenceOrder": int(data["referenceOrder"]),
        "primarySeconds": float(result["primary_seconds"]),
        "referenceSeconds": float(result["reference_seconds"]),
        "warnings": [str(item.message) for item in caught],
        "targetRelativeErrorMet": all(
            value is None or bool(value)
            for value in result["target_relative_error_met"]
        ),
        "branchResults": [
            {
                "branchIndex": index,
                "relativeDifferenceInf": result[
                    "relative_differences_inf"
                ][index - 1].str(digits),
                "relativeDifferenceMidpoint": result[
                    "relative_differences_midpoint"
                ][index - 1],
                "targetRelativeError": result["target_relative_error"],
                "targetRelativeErrorMet": result[
                    "target_relative_error_met"
                ][index - 1],
                "finalValues": [
                    _acb_record(
                        final_vectors[index - 1][row, 0],
                        digits,
                    )
                    for row in range(int(data["dimension"]))
                ],
                "boundaryInitialization": result[
                    "reference_boundary_reports"
                ][index - 1],
            }
            for index in range(1, len(boundaries) + 1)
        ],
    }


def _run(data: dict[str, Any]) -> dict[str, Any]:
    """严格分派六个现行 plan/execute schema。"""

    request = _validate_request(data)
    handlers = {
        POLYLINE_PLAN_SCHEMA: _run_polyline_plan,
        POLYLINE_EXECUTE_SCHEMA: _run_polyline_execute,
        LEADING_ORDER_PLAN_SCHEMA: _run_leading_order_plan,
        LEADING_ORDER_EXECUTE_SCHEMA: _run_leading_order_execute,
        SINGULAR_BOUNDARY_PLAN_SCHEMA: _run_singular_boundary_plan,
        SINGULAR_BOUNDARY_EXECUTE_SCHEMA: _run_singular_boundary_execute,
    }
    return handlers[request["schema"]](request)

def main() -> int:
    """命令行入口；即使失败也写结构化 JSON，供 Wolfram 端保留完整原因。"""

    if len(sys.argv) != 3:
        raise SystemExit("usage: flintnde_transport.py INPUT.json OUTPUT.json")
    input_path = Path(sys.argv[1])
    output_path = Path(sys.argv[2])
    try:
        result = _run(_load_input(input_path))
        exit_code = 0
    except Exception as error:  # noqa: BLE001 - CLI 边界必须序列化所有后端错误
        result = {
            "status": "failed",
            "errorType": type(error).__name__,
            "error": str(error),
            "traceback": traceback.format_exc(),
        }
        exit_code = 1
    output_path.write_text(json.dumps(result, ensure_ascii=False, indent=2), encoding="utf-8")
    return exit_code


if __name__ == "__main__":
    raise SystemExit(main())
