"""MadStree 到 FlintNDE 的中立 JSON 适配器。

本文件只负责 Q(i)(s) 矩阵、普通点或正则奇点边界、路径和精度参数的转换。
dS topology、边界 normalization、master 顺序、物理 branch 权重全部由 MadStree 持有，
避免数值后端反向猜测物理 convention。
"""

from __future__ import annotations

import json
import sys
import traceback
import warnings
from pathlib import Path
from typing import Any


def _load_input(path: Path) -> dict[str, Any]:
    """读取并验证适配器版本，防止静默消费旧 schema。"""

    data = json.loads(path.read_text(encoding="utf-8"))
    if data.get("schema") not in {
        "madstree_flintnde_transport_v1",
        "madstree_flintnde_singular_transport_v1",
    }:
        raise ValueError("unsupported MadStree-FlintNDE transport schema")
    return data


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


def _run(data: dict[str, Any]) -> dict[str, Any]:
    """构造 exact rational system，并按 schema 运行普通点或奇点双链输运。"""

    backend_path = Path(data["backendPackagePath"]).resolve()
    package_file = backend_path / "flintnde" / "__init__.py"
    if not package_file.is_file():
        raise FileNotFoundError(f"FlintNDE package not found: {package_file}")
    sys.path.insert(0, str(backend_path))

    from flint import acb, acb_mat  # pylint: disable=import-outside-toplevel
    from flintnde import (  # pylint: disable=import-outside-toplevel
        NamedPoint,
        RationalMatrixSystem,
        analyze_singularities,
        build_adaptive_path,
        classify_point,
        configure_working_precision,
        frobenius_boundary,
        gaussian_rational,
        rational_function,
        transport_path_refined,
    )

    digits = int(data["workingPrecisionDigits"])
    configure_working_precision(digits)
    matrix_records = data["matrix"]
    dimension = int(data["dimension"])
    if len(matrix_records) != dimension or any(len(row) != dimension for row in matrix_records):
        raise ValueError("serialized matrix dimension mismatch")
    matrix = tuple(
        tuple(
            rational_function(entry["numerator"], entry["denominator"])
            for entry in row
        )
        for row in matrix_records
    )
    system = RationalMatrixSystem(
        matrix,
        variable_name=data.get("variable", "s"),
        name=f"MadStree-{data['masterDigest'][:12]}",
    )
    start_value = data.get("start", "0")
    target_value = data.get("target", "1")
    save_points = data.get("savePoints", [])
    if any(record.get("tag") != "save" for record in save_points):
        raise ValueError('save-point tag must be the literal "save"')
    save_coordinates = [record["coordinate"] for record in save_points]
    exact_start = gaussian_rational(start_value)
    exact_target = gaussian_rational(target_value)
    start_saved = [value for value in save_coordinates if gaussian_rational(value) == exact_start]
    target_saved = [value for value in save_coordinates if gaussian_rational(value) == exact_target]
    internal_saved = [
        value
        for value in save_coordinates
        if gaussian_rational(value) not in {exact_start, exact_target}
    ]
    if len(start_saved) > 1 or len(target_saved) > 1:
        raise ValueError("save-point endpoint appears more than once")
    classified_start = NamedPoint("madstree_boundary_anchor", start_value)
    classified_target = NamedPoint("madstree_target", target_value)
    start = (
        (start_value, "save")
        if start_saved
        else classified_start
    )
    target = (
        (target_value, "save")
        if target_saved
        else classified_target
    )
    inventory = analyze_singularities(system)
    start_classification = classify_point(classified_start, inventory)
    target_classification = classify_point(classified_target, inventory)
    singular_schema = data["schema"] == "madstree_flintnde_singular_transport_v1"
    expected_start_kind = "regular_singular" if singular_schema else "ordinary"
    if start_classification.kind != expected_start_kind or target_classification.kind != "ordinary":
        raise ValueError(
            f"MadStree requires a {expected_start_kind} start and ordinary target; "
            f"got {start_classification.kind}, {target_classification.kind}"
        )
    path = build_adaptive_path(
        system,
        start,
        target,
        detour_points=tuple((value, "save") for value in internal_saved),
        path_name="madstree_anchor_to_target",
        max_step_over_radius=0.45,
    )
    boundaries: list[Any]
    if singular_schema:
        branch_records = data.get("branches", [])
        if not branch_records:
            raise ValueError("singular transport requires at least one normalized branch")
        boundaries = [frobenius_boundary([record["boundary"]]) for record in branch_records]
    else:
        boundary_records = data["boundary"]
        if len(boundary_records) != dimension:
            raise ValueError("serialized boundary dimension mismatch")
        boundaries = [
            acb_mat([[acb(item["real"], item["imag"])] for item in boundary_records])
        ]

    results = []
    caught_messages: list[str] = []
    save_output_root = Path(data.get("saveOutputDirectory", Path.cwd())).resolve()
    save_summary_files: list[str] = []
    for boundary_index, boundary in enumerate(boundaries, 1):
        branch_save_directory = (
            save_output_root
            if len(boundaries) == 1
            else save_output_root / f"branch_{boundary_index:03d}"
        )
        with warnings.catch_warnings(record=True) as caught:
            warnings.simplefilter("always")
            result = transport_path_refined(
                system,
                boundary,
                path,
                primary_order=int(data["primaryOrder"]),
                reference_order=int(data["referenceOrder"]),
                radius_fraction=0.60,
                target_relative_error=data.get("targetRelativeError"),
                save_output_directory=branch_save_directory,
            )
        results.append(result)
        caught_messages.extend(str(item.message) for item in caught)
        summary_file = branch_save_directory / "flintnde_save_points.json"
        if summary_file.is_file():
            save_summary_files.append(str(summary_file))

    final_vectors = [result["reference_snapshots"][-1] for result in results]
    payload = {
        "status": "success",
        "schema": data["schema"],
        "masterDigest": data["masterDigest"],
        "dimension": dimension,
        "columnVectorConvention": data["columnVectorConvention"],
        "dlogStatus": data["dlogStatus"],
        "backendPackagePath": str(backend_path),
        "startClassification": start_classification.to_json(),
        "targetClassification": target_classification.to_json(),
        "path": [_point_record(point, digits) for point in path],
        "pathPointCount": len(path),
        "internalSingularityCount": len(path.internal_singularities),
        "primaryOrder": int(data["primaryOrder"]),
        "referenceOrder": int(data["referenceOrder"]),
        "warnings": caught_messages,
        "savePointSummaryFiles": save_summary_files,
    }
    if singular_schema:
        payload["branchResults"] = [
            {
                "branchIndex": index,
                "relativeDifferenceInf": result["relative_difference_inf"].str(digits),
                "relativeDifferenceMidpoint": result["relative_difference_midpoint"],
                "targetRelativeError": result["target_relative_error"],
                "targetRelativeErrorMet": result["target_relative_error_met"],
                "primarySeconds": result["primary_seconds"],
                "referenceSeconds": result["reference_seconds"],
                "finalValues": [
                    _acb_record(final_vectors[index - 1][row, 0], digits)
                    for row in range(dimension)
                ],
                "boundaryInitialization": result["reference_segments"][0],
            }
            for index, result in enumerate(results, 1)
        ]
        payload["targetRelativeErrorMet"] = all(
            result["target_relative_error_met"] for result in results
        )
    else:
        result = results[0]
        final_vector = final_vectors[0]
        payload.update(
            {
                "relativeDifferenceInf": result["relative_difference_inf"].str(digits),
                "relativeDifferenceMidpoint": result["relative_difference_midpoint"],
                "targetRelativeError": result["target_relative_error"],
                "targetRelativeErrorMet": result["target_relative_error_met"],
                "primarySeconds": result["primary_seconds"],
                "referenceSeconds": result["reference_seconds"],
                "finalValues": [
                    _acb_record(final_vector[row, 0], digits) for row in range(dimension)
                ],
            }
        )
    return payload


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
