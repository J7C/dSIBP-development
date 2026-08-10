"""FlintNDE 的 Wolfram/Mathematica 嵌入桥接。

命令行用法：``python -m flintnde.mathematica_bridge request.json output.m``。

桥接只负责"最终输出"：读取 Wolfram 端写出的 JSON 请求，运行一次
``transport_path_refined``，把末点结果、可选段内采样点与认证摘要写成 Wolfram
``Get`` 可直接加载的 ``.m`` 文件。中间泰勒系数补丁不写盘、不回传；是否把结果
落盘为 MMA 文件由用户在 Wolfram 端用自带输出命令决定。
"""

from __future__ import annotations

import argparse
import json
import re
import sys
import warnings
from pathlib import Path
from typing import Any

from flint import acb, acb_mat, arb

from .core import configure_working_precision, exact_rational, relative_difference_inf
from .systems import PartialFractionSystem
from .transport import transport_path_refined

REQUEST_SCHEMA = "flintnde_mathematica_request_v1"
RESULT_SCHEMA = "flintnde_mathematica_bridge_v1"


def _mma_scalar(text: str) -> Any:
    """把 MMA 风格数值字符串规整为 exact 有理转换可接受的十进制/分数字符串。

    支持 Wolfram ``*^`` 指数记号和反引号精度后缀；``1/3`` 等分数按 exact 有理
    处理，不经过 machine float。
    """

    cleaned = re.sub(r"`\d+\.?\d*$", "", str(text).strip())
    if "*^" in cleaned:
        mantissa, exponent = cleaned.split("*^", 1)
        cleaned = f"{mantissa}e{exponent}"
    return cleaned


def _entry_to_acb(value: Any) -> acb:
    """把请求中的标量（数字、字符串或 ``{re,im}``/``[re,im]``）转为 acb。"""

    if isinstance(value, dict):
        return acb(
            acb(exact_rational(_mma_scalar(value.get("re", 0)))).real,
            acb(exact_rational(_mma_scalar(value.get("im", 0)))).real,
        )
    if isinstance(value, (list, tuple)):
        if len(value) != 2:
            raise ValueError(f"complex entry must have two components, got {value}")
        return acb(
            acb(exact_rational(_mma_scalar(value[0]))).real,
            acb(exact_rational(_mma_scalar(value[1]))).real,
        )
    return acb(exact_rational(_mma_scalar(value)))


def _column_vector(entries: list[Any], name: str) -> acb_mat:
    if not isinstance(entries, list) or not entries:
        raise ValueError(f"{name} must be a nonempty list")
    return acb_mat([[_entry_to_acb(entry)] for entry in entries])


def _matrix_from_records(records: list[list[Any]], name: str) -> acb_mat:
    if not isinstance(records, list) or not records:
        raise ValueError(f"{name} must be a nonempty matrix record list")
    return acb_mat([[_entry_to_acb(entry) for entry in row] for row in records])


def _build_system(record: dict[str, Any]) -> PartialFractionSystem:
    """从请求构造部分分式系统；桥接当前只支持单极点 dlog 型系统。"""

    if record.get("type") != "partialFraction":
        raise ValueError(
            "Mathematica bridge currently supports only partialFraction systems"
        )
    constant = _matrix_from_records(record["constant"], "constant matrix")
    residues = tuple(
        _matrix_from_records(item, f"residue {index}")
        for index, item in enumerate(record.get("residues", ()))
    )
    poles = tuple(_entry_to_acb(item) for item in record.get("poles", ()))
    return PartialFractionSystem(constant=constant, residues=residues, poles=poles)


def _mma_real(value: arb, digits: int) -> str:
    """把 arb 中点写成 Wolfram 任意精度实数字面量（``*^`` 记号 + 精度标记）。"""

    text = value.mid().str(digits, radius=False, more=True)
    if "e" in text:
        mantissa, exponent = text.split("e", 1)
        literal = f"{mantissa}*^{int(exponent)}"
    else:
        literal = text
    if "." not in literal:
        literal += ".0"
    return f"{literal}`{digits}."


def _mma_complex(value: acb, digits: int) -> str:
    return f"Complex[{_mma_real(value.real, digits)}, {_mma_real(value.imag, digits)}]"


def _mma_float_literal(value: float) -> str:
    """把 machine float 写成 Wolfram 可解析的 ``*^`` 科学记号。"""

    mantissa, exponent = f"{value:.16e}".split("e", 1)
    return f"{mantissa}*^{int(exponent)}"


def _mma_vector(vector: acb_mat, digits: int) -> str:
    if vector.ncols() != 1:
        raise ValueError("bridge output vector must be a column")
    entries = ", ".join(_mma_complex(vector[row, 0], digits) for row in range(vector.nrows()))
    return "{" + entries + "}"


def _mma_string(text: str) -> str:
    return '"' + text.replace("\\", "\\\\").replace('"', '\\"') + '"'


def _mma_boolean(value: Any) -> str:
    if value is None:
        return "Null"
    return "True" if value else "False"


def run_request(request: dict[str, Any]) -> dict[str, Any]:
    """执行一次桥接输运并返回 Wolfram 端需要的最终结果结构。"""

    if request.get("schema") != REQUEST_SCHEMA:
        raise ValueError(f"unsupported bridge request schema: {request.get('schema')}")
    digits = int(request.get("outputDigits", 40))
    configure_working_precision(int(request.get("workingPrecisionDigits", 80)))
    system = _build_system(request["system"])
    initial_vector = _column_vector(request["initialVector"], "initialVector")
    path: list[Any] = []
    save_indices: list[int] = []
    for index, item in enumerate(request.get("path", ())):
        if isinstance(item, dict) and item.get("tag") == "save":
            path.append((item["coordinate"], "save"))
            save_indices.append(index)
        else:
            path.append(item)
    if len(path) < 2:
        raise ValueError("bridge path needs at least two points")
    sample_points = request.get("samplePoints")
    with warnings.catch_warnings():
        # 精度警告随认证摘要回传，不在桥接进程里重复打印
        warnings.simplefilter("ignore", UserWarning)
        result = transport_path_refined(
            system,
            initial_vector,
            path,
            primary_order=int(request["primaryOrder"]),
            reference_order=int(request["referenceOrder"]),
            radius_fraction=float(request.get("radiusFraction", 0.60)),
            target_relative_error=request.get("targetRelativeError"),
            certification_mode=request.get("certificationMode", "embedded"),
            sample_points=sample_points,
        )
    primary_final = result["primary_snapshots"][-1]
    reference_final = result["reference_snapshots"][-1]
    output: dict[str, Any] = {
        "certificationMode": result["certification_mode"],
        "primaryFinalVector": _mma_vector(primary_final, digits),
        "referenceFinalVector": _mma_vector(reference_final, digits),
        "relativeDifferenceInf": result["relative_difference_inf"].mid().str(digits),
        "targetRelativeErrorMet": _mma_boolean(result["target_relative_error_met"]),
        "primarySeconds": result["primary_seconds"],
        "referenceSeconds": result["reference_seconds"],
    }
    if "segment_truncation_differences_midpoint" in result:
        output["segmentTruncationDifferences"] = result[
            "segment_truncation_differences_midpoint"
        ]
    if save_indices:
        output["savePoints"] = [
            {
                "coordinate": request["path"][index]["coordinate"],
                "value": _mma_vector(result["reference_snapshots"][index], digits),
            }
            for index in save_indices
        ]
    if sample_points is not None:
        output["samplePoints"] = [
            {
                "coordinate": record["coordinate"],
                "value": _mma_vector(record["value"], digits),
            }
            for record in result.get("sample_results", ())
        ]
    return output


def _serialize_result(output: dict[str, Any]) -> str:
    """把最终结果写成 Wolfram ``Get`` 可加载的单变量赋值。"""

    rules: list[str] = [
        f"{_mma_string('schema')} -> {_mma_string(RESULT_SCHEMA)}",
        f"{_mma_string('status')} -> {_mma_string('complete')}",
        f"{_mma_string('certificationMode')} -> {_mma_string(output['certificationMode'])}",
        f"{_mma_string('primaryFinalVector')} -> {output['primaryFinalVector']}",
        f"{_mma_string('referenceFinalVector')} -> {output['referenceFinalVector']}",
        f"{_mma_string('relativeDifferenceInf')} -> {_mma_string(output['relativeDifferenceInf'])}",
        f"{_mma_string('targetRelativeErrorMet')} -> {output['targetRelativeErrorMet']}",
        f"{_mma_string('primarySeconds')} -> {output['primarySeconds']:.6f}",
        f"{_mma_string('referenceSeconds')} -> {output['referenceSeconds']:.6f}",
    ]
    if "segmentTruncationDifferences" in output:
        entries = ", ".join(
            _mma_float_literal(float(value))
            for value in output["segmentTruncationDifferences"]
        )
        rules.append(f"{_mma_string('segmentTruncationDifferences')} -> {{{entries}}}")
    for key in ("savePoints", "samplePoints"):
        if key not in output:
            continue
        items = []
        for record in output[key]:
            coordinate = record["coordinate"]
            coordinate_text = (
                _mma_string(coordinate)
                if isinstance(coordinate, str)
                else _mma_complex(_entry_to_acb(coordinate), 40)
            )
            items.append(
                "<|"
                f"{_mma_string('coordinate')} -> {coordinate_text}, "
                f"{_mma_string('value')} -> {record['value']}"
                "|>"
            )
        rules.append(f"{_mma_string(key)} -> {{{', '.join(items)}}}")
    return "FlintNDEBridgeResult = <| " + ", ".join(rules) + " |>;\n"


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description="FlintNDE Wolfram bridge")
    parser.add_argument("request", help="JSON request file written by the Wolfram loader")
    parser.add_argument("output", help="target .m file loadable by Wolfram Get")
    args = parser.parse_args(argv)
    try:
        request = json.loads(Path(args.request).read_text(encoding="utf-8"))
        output = run_request(request)
        Path(args.output).write_text(_serialize_result(output), encoding="utf-8")
    except Exception as error:  # noqa: BLE001 - 桥接把任何失败回传给 Wolfram 端
        failure = f'FlintNDEBridgeResult = <| "schema" -> "{RESULT_SCHEMA}", "status" -> "error", "message" -> {_mma_string(str(error))} |>;\n'
        Path(args.output).write_text(failure, encoding="utf-8")
        print(f"flintnde.mathematica_bridge: {error}", file=sys.stderr)
        return 1
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
