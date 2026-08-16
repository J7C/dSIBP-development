"""独立验证 FlintNDE 0.4.0 正规化角域和显式候选池容量合同。

runner 在数值计算前物理删除本专项旧结果、旧报告和 cache。默认/角域 expected 由旧正实轴
网格公式和已知 Laurent 边界直接生成；候选耗尽 expected 来自调用参数集合与公开状态合同，
不读取 validation-01 或任何旧 summary。
"""

from __future__ import annotations

import hashlib
import json
import platform
import shutil
import sys
import time
import warnings
from fractions import Fraction
from pathlib import Path
from typing import Any


VALIDATION_DIR = Path(__file__).resolve().parent
FLINTNDE_ROOT = VALIDATION_DIR.parents[1]
VERSION_ROOT = FLINTNDE_ROOT / "versions" / "FlintNDE-0.4.0"
RESULTS_DIR = VALIDATION_DIR / "results"
SUMMARY_PATH = RESULTS_DIR / "summary.json"
REPORT_PATH = VALIDATION_DIR / "000_FlintNDE-0.4.0-validation-02-report.md"

sys.dont_write_bytecode = True
sys.path.insert(0, str(VERSION_ROOT))

from flint import acb, acb_mat, arb, ctx, fmpq  # noqa: E402
from flintnde import (  # noqa: E402
    AnalyticMatrixSystem,
    configure_working_precision,
    reconstruct_series_solution,
)


WORKING_PRECISION_DIGITS = 120
COEFFICIENT_ERROR_GATE = 1.0e-35
GEOMETRY_ERROR_GATE = 1.0e-55


def sha256(path: Path) -> str:
    """计算当前被测源码或 runner 的 SHA-256。"""

    digest = hashlib.sha256()
    with path.open("rb") as stream:
        for chunk in iter(lambda: stream.read(1024 * 1024), b""):
            digest.update(chunk)
    return digest.hexdigest()


def write_utf8_lf(path: Path, text: str) -> None:
    """显式写 UTF-8 无 BOM 与 LF，避免 Windows 文本换行转换。"""

    with path.open("w", encoding="utf-8", newline="\n") as stream:
        stream.write(text)


def write_json(path: Path, payload: Any) -> None:
    """显式写 UTF-8/LF JSON，并保留中文。"""

    write_utf8_lf(path, json.dumps(payload, ensure_ascii=False, indent=2) + "\n")


def clean_previous_outputs() -> dict[str, Any]:
    """在计算前删除本专项旧正式输出和 cache；只操作当前 validation-02。"""

    records: list[dict[str, Any]] = []
    targets = [RESULTS_DIR, REPORT_PATH]
    targets.extend(
        path
        for name in ("__pycache__", "results_temp", "cache", "tmp")
        for path in VALIDATION_DIR.rglob(name)
    )
    unique_targets: list[Path] = []
    for target in targets:
        resolved = target.resolve()
        if resolved != REPORT_PATH.resolve() and VALIDATION_DIR.resolve() not in resolved.parents:
            raise RuntimeError(f"unsafe fresh-clean target: {resolved}")
        if resolved not in unique_targets:
            unique_targets.append(resolved)
    for target in unique_targets:
        existed = target.exists()
        if existed:
            if target.is_dir():
                shutil.rmtree(target)
            else:
                target.unlink()
        records.append(
            {
                "path": str(target),
                "existed_before": existed,
                "exists_after": target.exists(),
            }
        )
        if target.exists():
            raise RuntimeError(f"fresh-clean failed for {target}")
    return {
        "performed_before_numeric_work": True,
        "targets": records,
        "all_targets_absent_after_clean": all(not item["exists_after"] for item in records),
    }


def zero_system() -> AnalyticMatrixSystem:
    """返回带远端哑奇点的一维零矩阵 DE，使终点等于边界值。"""

    return AnalyticMatrixSystem(
        lambda _z: acb_mat(1, 1),
        1,
        (acb(-10), acb(10)),
        "validation-02-zero-system",
    )


def support_certificate(power: int) -> dict[str, Any]:
    """声明已知解析边界的最低 Laurent 幂。"""

    return {
        "status": "certified",
        "leading_power": power,
        "method": "validation-02-analytic-boundary",
    }


class LaurentBoundary:
    """记录实际 regulator 调用，并返回已知四项 Laurent 多项式。"""

    def __init__(self) -> None:
        self.received: list[dict[str, str]] = []

    def __call__(self, ep: Any) -> list[acb]:
        self.received.append({"type": type(ep).__name__, "value": str(ep)})
        regulator = acb(ep)
        return [
            acb(2) / regulator
            + acb(3)
            + acb(4) * regulator
            + acb(5) * regulator**2
        ]


class ExponentialBoundary:
    """记录候选池实际调用，并返回无法由低阶截断严格覆盖的 exp(ep)。"""

    def __init__(self) -> None:
        self.received: list[dict[str, str]] = []

    def __call__(self, ep: Any) -> list[acb]:
        self.received.append({"type": type(ep).__name__, "value": str(ep)})
        return [acb(ep).exp()]


def expected_radii(count: int = 4) -> list[Fraction]:
    """独立实现旧自动网格模长公式 base*(1+i*spacing)。"""

    base = Fraction(1, 100)
    spacing = Fraction(1, 100)
    return [base * (Fraction(1) + index * spacing) for index in range(1, count + 1)]


def coefficient_records(result: Any) -> tuple[list[dict[str, Any]], float]:
    """逐幂比较已知 Laurent 系数 2,3,4,5。"""

    expected = {-1: 2, 0: 3, 1: 4, 2: 5}
    records: list[dict[str, Any]] = []
    errors: list[float] = []
    for power, value in expected.items():
        actual = result.coefficient(power)[0, 0]
        error = float(abs(actual - acb(value)).mid())
        errors.append(error)
        records.append(
            {
                "power": power,
                "expected": str(value),
                "actual": actual.str(50),
                "absolute_error": error,
            }
        )
    return records, max(errors)


def reconstruction_common(boundary: LaurentBoundary) -> dict[str, Any]:
    """返回默认与角域 case 共用的重构参数。"""

    return {
        "DEmatrix": zero_system(),
        "boundary": boundary,
        "path": [acb(0), acb(1)],
        "maximum_power": 2,
        "leading_power": -1,
        "leading_power_certificate": support_certificate(-1),
        "goal_digits": 12,
        "sample_count": 4,
        "base_sample": "0.01",
        "sample_spacing": "0.01",
        "working_precision_digits": WORKING_PRECISION_DIGITS,
        "transport_order": 4,
        "transport_extra_order": 2,
        "validation_sample_count": 3,
        "validation_scale": "0.5",
        "validation_tolerance": "1e-40",
        "fit_extra_order": 0,
        "fit_max_rounds": 1,
        "parallel_task_count": 1,
    }


def run_default_automatic() -> tuple[Any, dict[str, Any]]:
    """验证缺省 automatic 逐项保持旧正实轴网格、缩模验证点和已知系数。"""

    boundary = LaurentBoundary()
    clock = time.perf_counter()
    result = reconstruct_series_solution(**reconstruction_common(boundary))
    elapsed = time.perf_counter() - clock
    radii = expected_radii()
    point_records: list[dict[str, Any]] = []
    point_errors: list[float] = []
    imaginary_errors: list[float] = []
    for index, (point, radius) in enumerate(zip(result.sample_points, radii, strict=True), start=1):
        expected = acb(radius.numerator) / acb(radius.denominator)
        point_error = float(abs(point - expected).mid())
        imaginary_error = float(abs(point.imag).mid())
        point_errors.append(point_error)
        imaginary_errors.append(imaginary_error)
        point_records.append(
            {
                "index": index,
                "old_formula_fraction": str(radius),
                "expected": expected.str(50),
                "actual": point.str(50),
                "absolute_error": point_error,
                "imaginary_absolute_value": imaginary_error,
            }
        )
    validation_records: list[dict[str, Any]] = []
    validation_errors: list[float] = []
    for index, (validation, production) in enumerate(
        zip(result.validation_points, result.sample_points, strict=False), start=1
    ):
        expected = production * acb("1/2")
        error = float(abs(validation - expected).mid())
        validation_errors.append(error)
        validation_records.append(
            {
                "index": index,
                "production": production.str(50),
                "validation": validation.str(50),
                "expected_scaled": expected.str(50),
                "absolute_error": error,
            }
        )
    coefficients, coefficient_max = coefficient_records(result)
    all_fmpq = all(item["type"] == "fmpq" for item in boundary.received)
    metrics = {
        "wall_seconds": elapsed,
        "sample_source": result.effective_parameters["sample_source"],
        "sample_count": len(result.sample_points),
        "validation_count": len(result.validation_points),
        "points": point_records,
        "validation_points": validation_records,
        "boundary_calls": boundary.received,
        "all_boundary_arguments_exact_fmpq": all_fmpq,
        "maximum_old_formula_point_error": max(point_errors),
        "maximum_imaginary_absolute_value": max(imaginary_errors),
        "maximum_validation_scale_error": max(validation_errors),
        "coefficients": coefficients,
        "maximum_coefficient_absolute_error": coefficient_max,
        "precision_target_met": bool(result.effective_parameters["precision_target_met"]),
        "effective_parameters": result.effective_parameters,
        "passed": all(
            (
                result.effective_parameters["sample_source"] == "automatic",
                len(result.sample_points) == 4,
                len(result.validation_points) == 3,
                all_fmpq,
                max(point_errors) < GEOMETRY_ERROR_GATE,
                max(imaginary_errors) < GEOMETRY_ERROR_GATE,
                max(validation_errors) < GEOMETRY_ERROR_GATE,
                coefficient_max < COEFFICIENT_ERROR_GATE,
                result.effective_parameters["precision_target_met"],
            )
        ),
    }
    return result, metrics


def run_angle_range(default_result: Any) -> dict[str, Any]:
    """验证开角域三条均匀内部射线、旧模长、同角缩模和系数恢复。"""

    boundary = LaurentBoundary()
    parameters = reconstruction_common(boundary)
    parameters["sample_angle_range"] = ("-1", "1")
    clock = time.perf_counter()
    result = reconstruct_series_solution(**parameters)
    elapsed = time.perf_counter() - clock
    expected_angles = [arb("-1/2"), arb(0), arb("1/2")]
    angle_records: list[dict[str, Any]] = []
    angle_errors: list[float] = []
    radius_errors: list[float] = []
    open_flags: list[bool] = []
    angle_assignments: list[int] = []
    for index, (point, default_point) in enumerate(
        zip(result.sample_points, default_result.sample_points, strict=True)
    ):
        expected_angle = expected_angles[index % 3]
        actual_angle = point.arg()
        angle_error = float(abs(actual_angle - expected_angle).mid())
        radius_error = float(abs(abs(point) - abs(default_point)).mid())
        inside_open = bool(arb(-1) < actual_angle and actual_angle < arb(1))
        angle_errors.append(angle_error)
        radius_errors.append(radius_error)
        open_flags.append(inside_open)
        angle_assignments.append(
            min(
                range(len(expected_angles)),
                key=lambda angle_index: float(
                    abs(actual_angle - expected_angles[angle_index]).mid()
                ),
            )
        )
        angle_records.append(
            {
                "index": index + 1,
                "point": point.str(50),
                "expected_angle": expected_angle.str(50),
                "actual_angle": actual_angle.str(50),
                "angle_absolute_error": angle_error,
                "default_radius": abs(default_point).str(50),
                "actual_radius": abs(point).str(50),
                "radius_absolute_error": radius_error,
                "inside_open_interval": inside_open,
            }
        )
    validation_records: list[dict[str, Any]] = []
    validation_errors: list[float] = []
    validation_angle_errors: list[float] = []
    for index, (validation, production) in enumerate(
        zip(result.validation_points, result.sample_points, strict=False), start=1
    ):
        expected = production * acb("1/2")
        scale_error = float(abs(validation - expected).mid())
        angle_error = float(abs(validation.arg() - production.arg()).mid())
        validation_errors.append(scale_error)
        validation_angle_errors.append(angle_error)
        validation_records.append(
            {
                "index": index,
                "production": production.str(50),
                "validation": validation.str(50),
                "scale_absolute_error": scale_error,
                "angle_absolute_error": angle_error,
            }
        )
    coefficients, coefficient_max = coefficient_records(result)
    unique_angle_labels = sorted(set(angle_assignments))
    return {
        "wall_seconds": elapsed,
        "sample_source": result.effective_parameters["sample_source"],
        "sample_angle_range": result.effective_parameters["sample_angle_range"],
        "sample_count": len(result.sample_points),
        "validation_count": len(result.validation_points),
        "uniform_internal_angle_count": len(unique_angle_labels),
        "actual_angle_assignment_indices": angle_assignments,
        "expected_angles": [value.str(50) for value in expected_angles],
        "points": angle_records,
        "validation_points": validation_records,
        "boundary_calls": boundary.received,
        "maximum_angle_absolute_error": max(angle_errors),
        "maximum_radius_formula_error": max(radius_errors),
        "maximum_validation_scale_error": max(validation_errors),
        "maximum_validation_angle_error": max(validation_angle_errors),
        "coefficients": coefficients,
        "maximum_coefficient_absolute_error": coefficient_max,
        "precision_target_met": bool(result.effective_parameters["precision_target_met"]),
        "effective_parameters": result.effective_parameters,
        "passed": all(
            (
                result.effective_parameters["sample_source"] == "automatic-angle-range",
                len(result.sample_points) == 4,
                len(result.validation_points) == 3,
                len(unique_angle_labels) == 3,
                all(open_flags),
                max(angle_errors) < GEOMETRY_ERROR_GATE,
                max(radius_errors) < GEOMETRY_ERROR_GATE,
                max(validation_errors) < GEOMETRY_ERROR_GATE,
                max(validation_angle_errors) < GEOMETRY_ERROR_GATE,
                coefficient_max < COEFFICIENT_ERROR_GATE,
                result.effective_parameters["precision_target_met"],
            )
        ),
    }


def run_candidate_pool_exhaustion() -> dict[str, Any]:
    """耗尽显式候选池并证明仍返回系数、标记未认证且没有生成池外点。"""

    candidates = ("0.10", "0.09", "0.08", "0.07")
    validation = ("0.04", "0.03")
    boundary = ExponentialBoundary()
    clock = time.perf_counter()
    with warnings.catch_warnings(record=True) as captured:
        warnings.simplefilter("always")
        result = reconstruct_series_solution(
            DEmatrix=zero_system(),
            boundary=boundary,
            path=[acb(0), acb(1)],
            maximum_power=0,
            leading_power=0,
            leading_power_certificate=support_certificate(0),
            goal_digits=8,
            sample_points=candidates,
            validation_points=validation,
            initial_internal_maximum_power=1,
            fit_order_increment=2,
            fit_max_rounds=3,
            working_precision_digits=WORKING_PRECISION_DIGITS,
            transport_order=4,
            transport_extra_order=2,
            validation_tolerance="1e-40",
            parallel_task_count=1,
        )
    elapsed = time.perf_counter() - clock
    warning_records = [
        {"category": item.category.__name__, "message": str(item.message)}
        for item in captured
    ]
    expected_arguments = set()
    for value in (*candidates, *validation):
        fraction = Fraction(value)
        expected_arguments.add(str(fmpq(fraction.numerator, fraction.denominator)))
    received_values = [item["value"] for item in boundary.received]
    received_set = set(received_values)
    runtime_warning_matches = [
        item
        for item in warning_records
        if item["category"] == "RuntimeWarning"
        and "candidate pool was exhausted" in item["message"]
        and "no points outside" in item["message"]
    ]
    coefficient = result.coefficient(0)[0, 0]
    effective = result.effective_parameters
    no_outside_points = received_set == expected_arguments
    no_duplicate_solves = len(received_values) == len(received_set)
    return {
        "wall_seconds": elapsed,
        "candidate_points": list(candidates),
        "validation_points": list(validation),
        "expected_argument_set": sorted(expected_arguments),
        "boundary_calls": boundary.received,
        "received_argument_set": sorted(received_set),
        "no_outside_points": no_outside_points,
        "no_duplicate_solves": no_duplicate_solves,
        "warnings": warning_records,
        "matching_runtime_warning_count": len(runtime_warning_matches),
        "returned_powers": list(result.powers),
        "returned_coefficient_count": len(result.coefficients),
        "returned_coefficient_0": coefficient.str(50),
        "precision_target_met": bool(effective["precision_target_met"]),
        "precision_failure_reason": effective["precision_failure_reason"],
        "sample_count": effective["sample_count"],
        "sample_candidate_count": effective["sample_candidate_count"],
        "unused_sample_candidate_count": effective["unused_sample_candidate_count"],
        "fit_rounds_used": effective["fit_rounds_used"],
        "effective_parameters": effective,
        "passed": all(
            (
                result.powers == (0,),
                len(result.coefficients) == 1,
                not effective["precision_target_met"],
                effective["precision_failure_reason"] == "candidate_pool_exhausted",
                effective["sample_count"] == 4,
                effective["sample_candidate_count"] == 4,
                effective["unused_sample_candidate_count"] == 0,
                no_outside_points,
                no_duplicate_solves,
                len(runtime_warning_matches) >= 1,
            )
        ),
    }


def make_report(summary: dict[str, Any]) -> str:
    """由 fresh 机器结果生成自包含中文报告。"""

    default = summary["default_automatic"]
    angle = summary["angle_range"]
    pool = summary["candidate_pool_exhaustion"]
    clean = summary["fresh_clean"]
    return f"""# FlintNDE 0.4.0 正规化角域/候选容量独立检验报告

日期：2026-08-16
对象：当前 `versions/FlintNDE-0.4.0/flintnde/regularization.py`
结论：**{'通过' if summary['overall_passed'] else '未通过'}**

## 快照与 fresh-clean

本 runner 未读取 validation-01 或旧 summary。数值计算前检查并删除本专项旧 `results/`、旧报告
和 cache；清理目标 {len(clean['targets'])} 个，清理后全部不存在：
`{clean['all_targets_absent_after_clean']}`。当前工作精度为
{summary['configuration']['working_precision_digits']} 位十进制，单进程执行。

当前关键 SHA-256：

- `regularization.py`：`{summary['source_sha256']['regularization_py']}`
- `flintnde/__init__.py`：`{summary['source_sha256']['flintnde_init_py']}`
- `run_validation.py`：`{summary['source_sha256']['runner_py']}`

## 默认 Automatic 基线

使用 `F(ep)=2/ep+3+4 ep+5 ep^2`。生产点数 {default['sample_count']}，验证点数
{default['validation_count']}；`sample_source={default['sample_source']}`。四个生产点逐项与旧公式
`(1/100)(1+i/100)` 比较，最大复数绝对差
`{default['maximum_old_formula_point_error']:.6e}`，最大虚部绝对值
`{default['maximum_imaginary_absolute_value']:.6e}`。边界收到的全部 regulator 参数均为 exact
`fmpq`：`{default['all_boundary_arguments_exact_fmpq']}`。

前三个自动验证点与对应生产点同角、模长缩为 1/2；直接复数缩放最大差
`{default['maximum_validation_scale_error']:.6e}`。四个已知 Laurent 系数最大绝对差
`{default['maximum_coefficient_absolute_error']:.6e}`，`precision_target_met=`
`{default['precision_target_met']}`。

## 开角域

只增加 `sample_angle_range=(-1,1)`，其余网格参数与默认 case 相同。实际角数量
{angle['uniform_internal_angle_count']}，按点循环匹配内部均匀角 `-1/2,0,1/2`；最大角差
`{angle['maximum_angle_absolute_error']:.6e}`。所有点严格位于开区间内部，且模长相对默认同索引
旧公式最大差 `{angle['maximum_radius_formula_error']:.6e}`。

自动验证点与对应生产点同角且整体缩为 1/2：最大复数缩放差
`{angle['maximum_validation_scale_error']:.6e}`，最大角差
`{angle['maximum_validation_angle_error']:.6e}`。相同 Laurent 系数恢复最大差
`{angle['maximum_coefficient_absolute_error']:.6e}`，`precision_target_met=`
`{angle['precision_target_met']}`。

## 显式候选池耗尽

候选点 4 个，独立验证点 2 个。严格容差下实际使用 {pool['fit_rounds_used']} 轮，最终
`sample_count={pool['sample_count']}`、`sample_candidate_count={pool['sample_candidate_count']}`、
`unused={pool['unused_sample_candidate_count']}`。程序仍返回 powers
`{pool['returned_powers']}` 和 {pool['returned_coefficient_count']} 个系数，但
`precision_target_met={pool['precision_target_met']}`，失败原因
`{pool['precision_failure_reason']}`。

边界工厂实际调用 {len(pool['boundary_calls'])} 次，无重复：`{pool['no_duplicate_solves']}`；调用
参数集合严格等于四个候选点和两个验证点：`{pool['no_outside_points']}`。匹配“候选池耗尽且未
生成池外点”的 RuntimeWarning 数量为 {pool['matching_runtime_warning_count']}。

## 门禁结论

| case | status | wall time |
| --- | --- | ---: |
| default Automatic | {'passed' if default['passed'] else 'failed'} | {default['wall_seconds']:.6f} s |
| sample angle range | {'passed' if angle['passed'] else 'failed'} | {angle['wall_seconds']:.6f} s |
| candidate pool exhausted | {'passed' if pool['passed'] else 'failed'} | {pool['wall_seconds']:.6f} s |

机器 summary 保留全部生产/验证点、角、模长、系数误差、边界调用和 warning。所有正式输出为
UTF-8 无 BOM、无 replacement character；本专项目录无 cache/temp。该结论只覆盖本任务列出的
正规化采样与容量合同，不扩大为其它 DE/边界类型的完整认证。

复核命令：

```powershell
python -B package-FlintNDE/independent-validation/FlintNDE-0.4.0-validation-02-regularization-angle-and-candidate-capacity/run_validation.py
```
"""


def cache_temp_paths() -> list[str]:
    """列出本专项目录内不应保留的 cache/temp 路径。"""

    bad_names = {"__pycache__", "results_temp", "cache", "tmp"}
    return [
        str(path.resolve())
        for path in VALIDATION_DIR.rglob("*")
        if path.is_dir() and path.name in bad_names
    ]


def main() -> None:
    """fresh-clean 后依次执行三组独立验收并写机器结果和报告。"""

    fresh_clean = clean_previous_outputs()
    RESULTS_DIR.mkdir(parents=True, exist_ok=False)
    configured_bits = configure_working_precision(WORKING_PRECISION_DIGITS, 32)

    default_result, default_metrics = run_default_automatic()
    angle_metrics = run_angle_range(default_result)
    pool_metrics = run_candidate_pool_exhaustion()
    cache_paths = cache_temp_paths()
    overall_passed = all(
        (
            fresh_clean["all_targets_absent_after_clean"],
            default_metrics["passed"],
            angle_metrics["passed"],
            pool_metrics["passed"],
            not cache_paths,
        )
    )
    summary = {
        "schema": "flintnde_0_4_0_regularization_angle_candidate_validation_v1",
        "date": "2026-08-16",
        "target": "package-FlintNDE/versions/FlintNDE-0.4.0",
        "environment": {
            "python": sys.version.replace("\n", " "),
            "python_flint": getattr(sys.modules["flint"], "__version__", "unknown"),
            "platform": platform.platform(),
            "parallel": "single process",
        },
        "configuration": {
            "working_precision_digits": WORKING_PRECISION_DIGITS,
            "working_precision_bits": configured_bits,
            "flint_context_precision_bits_after_runs": int(ctx.prec),
            "coefficient_error_gate": COEFFICIENT_ERROR_GATE,
            "geometry_error_gate": GEOMETRY_ERROR_GATE,
        },
        "source_sha256": {
            "regularization_py": sha256(VERSION_ROOT / "flintnde" / "regularization.py"),
            "flintnde_init_py": sha256(VERSION_ROOT / "flintnde" / "__init__.py"),
            "runner_py": sha256(Path(__file__).resolve()),
        },
        "fresh_clean": fresh_clean,
        "default_automatic": default_metrics,
        "angle_range": angle_metrics,
        "candidate_pool_exhaustion": pool_metrics,
        "cache_temp_paths_after_run": cache_paths,
        "overall_passed": overall_passed,
    }
    write_json(SUMMARY_PATH, summary)
    write_utf8_lf(REPORT_PATH, make_report(summary))

    for path in (SUMMARY_PATH, REPORT_PATH):
        raw = path.read_bytes()
        if raw.startswith(b"\xef\xbb\xbf"):
            raise RuntimeError(f"UTF-8 BOM found in {path}")
        text = raw.decode("utf-8", errors="strict")
        if "\ufffd" in text:
            raise RuntimeError(f"replacement character found in {path}")
    if cache_temp_paths():
        raise RuntimeError("validation-02 left cache/temp directories")
    if not overall_passed:
        raise RuntimeError("FlintNDE 0.4.0 validation-02 failed")
    print(
        json.dumps(
            {"overall_passed": True, "summary": str(SUMMARY_PATH)},
            ensure_ascii=True,
        )
    )


if __name__ == "__main__":
    main()
