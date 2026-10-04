"""FlintNDE 0.5.0 全回归、Wolfram 端到端和 Vendor 同步独立验证。

脚本执行当前版本完整 unittest、标准 ``Needs["FlintNDE`"]`` 接口脚本，并按相对
路径逐文件比较 MadStree v0.16 Vendor。运行日志只进入本 case 的 ``results_temp``；
标准接口测试在版本目录产生的 runtime 会在本轮结束前删除。
"""

from __future__ import annotations

import hashlib
import json
import os
import re
import shutil
import subprocess
import sys
import time
from pathlib import Path


CASE_ROOT = Path(__file__).resolve().parent
FLINT_ROOT = CASE_ROOT.parents[1]
REPOSITORY_ROOT = FLINT_ROOT.parent
VERSION_ROOT = FLINT_ROOT / "versions" / "FlintNDE-0.5.0"
VENDOR_ROOT = (
    REPOSITORY_ROOT
    / "package-MadStree"
    / "versions"
    / "MadStree-v0.16"
    / "Vendor"
    / "FlintNDE"
)
RESULTS_ROOT = CASE_ROOT / "results"
TEMP_ROOT = CASE_ROOT / "results_temp"
REPORT_PATH = CASE_ROOT / "000_FlintNDE-0.5.0-validation-03-report.md"
TEST_RUNTIME = VERSION_ROOT / "tests" / "results_temp"


def fresh_output() -> None:
    """只清理本 case 和标准测试明确拥有的 runtime。"""

    for directory in (RESULTS_ROOT, TEMP_ROOT):
        if directory.exists():
            shutil.rmtree(directory)
    if TEST_RUNTIME.exists():
        shutil.rmtree(TEST_RUNTIME)
    if REPORT_PATH.exists():
        REPORT_PATH.unlink()
    RESULTS_ROOT.mkdir(parents=True)
    TEMP_ROOT.mkdir(parents=True)


def sha256(path: Path) -> str:
    """返回单文件 SHA-256。"""

    return hashlib.sha256(path.read_bytes()).hexdigest()


def delivery_files(root: Path, *, independent: bool) -> dict[str, Path]:
    """枚举非缓存交付文件；独立包额外排除仅开发者使用的两份计划。"""

    excluded_names = {"DEVELOPMENT_PLAN.md", "todolist.md"} if independent else set()
    files: dict[str, Path] = {}
    for path in sorted(root.rglob("*")):
        if not path.is_file():
            continue
        relative = path.relative_to(root)
        if path.name.endswith(".pyc") or any(
            part in {"__pycache__", "results_temp", "results_test"}
            for part in relative.parts
        ):
            continue
        if relative.as_posix() in excluded_names:
            continue
        files[relative.as_posix()] = path
    return files


def run_logged(command: list[str], cwd: Path, env: dict[str, str], name: str) -> dict[str, object]:
    """运行命令并把完整 stdout/stderr 保存到本 case 临时目录。"""

    started = time.perf_counter()
    process = subprocess.run(
        command,
        cwd=cwd,
        env=env,
        text=True,
        encoding="utf-8",
        errors="replace",
        capture_output=True,
        check=False,
    )
    elapsed = time.perf_counter() - started
    (TEMP_ROOT / f"{name}-stdout.log").write_text(
        process.stdout, encoding="utf-8", newline="\n"
    )
    (TEMP_ROOT / f"{name}-stderr.log").write_text(
        process.stderr, encoding="utf-8", newline="\n"
    )
    return {
        "command": command,
        "returnCode": process.returncode,
        "stdout": process.stdout,
        "stderr": process.stderr,
        "wallTimeSeconds": elapsed,
    }


def main() -> int:
    """执行三条互不替代的回归/同步门禁并生成报告。"""

    fresh_output()
    environment = os.environ.copy()
    environment["PYTHONDONTWRITEBYTECODE"] = "1"
    environment["PYTHONPATH"] = str(VERSION_ROOT)
    environment["FLINTNDE_TEST_PYTHON"] = sys.executable
    environment["FLINTNDE_SUPPRESS_CITATION_NOTICE"] = "1"

    python_run = run_logged(
        [sys.executable, "-m", "unittest", "discover", "-s", "tests", "-p", "test*.py", "-v"],
        VERSION_ROOT,
        environment,
        "python-unittest",
    )
    python_text = str(python_run["stdout"]) + "\n" + str(python_run["stderr"])
    python_match = re.search(r"Ran\s+(\d+)\s+tests?", python_text)
    python_count = int(python_match.group(1)) if python_match else None
    python_ok = python_run["returnCode"] == 0 and re.search(r"\nOK\s*$", python_text) is not None

    wolfram_run = run_logged(
        ["wolframscript", "-file", str(VERSION_ROOT / "tests" / "test_mathematica_interface.wls")],
        VERSION_ROOT,
        environment,
        "wolfram-interface",
    )
    wolfram_text = str(wolfram_run["stdout"]) + "\n" + str(wolfram_run["stderr"])
    wolfram_match = re.search(r"Mathematica interface:\s*(\d+)/(\d+) checks passed", wolfram_text)
    wolfram_passed = int(wolfram_match.group(1)) if wolfram_match else None
    wolfram_total = int(wolfram_match.group(2)) if wolfram_match else None
    wolfram_ok = (
        wolfram_run["returnCode"] == 0
        and wolfram_passed is not None
        and wolfram_passed == wolfram_total
    )

    independent_files = delivery_files(VERSION_ROOT, independent=True)
    vendor_files = delivery_files(VENDOR_ROOT, independent=False)
    independent_only = sorted(set(independent_files) - set(vendor_files))
    vendor_only = sorted(set(vendor_files) - set(independent_files))
    shared = sorted(set(independent_files) & set(vendor_files))
    digest_rows = []
    mismatches = []
    for relative in shared:
        independent_hash = sha256(independent_files[relative])
        vendor_hash = sha256(vendor_files[relative])
        same = independent_hash == vendor_hash
        digest_rows.append(
            {
                "relativePath": relative,
                "independentSHA256": independent_hash,
                "vendorSHA256": vendor_hash,
                "same": same,
            }
        )
        if not same:
            mismatches.append(relative)
    vendor_sync_ok = not independent_only and not vendor_only and not mismatches

    runtime_existed = TEST_RUNTIME.exists()
    if runtime_existed:
        shutil.rmtree(TEST_RUNTIME)
    runtime_cleaned = not TEST_RUNTIME.exists()
    checks = {
        "pythonFullSuite": python_ok,
        "pythonTestCountRecorded": python_count is not None and python_count > 0,
        "wolframNeedsEndToEnd": wolfram_ok,
        "wolframCheckCountRecorded": wolfram_total is not None and wolfram_total > 0,
        "vendorRelativeFileSetExact": not independent_only and not vendor_only,
        "vendorAllSHA256Exact": not mismatches and len(shared) > 0,
        "versionRuntimeCleaned": runtime_cleaned,
    }
    passed_count = sum(value is True for value in checks.values())
    status = "passed" if passed_count == len(checks) else "failed"
    summary = {
        "schema": "flintnde_0.5.0_validation_03_v1",
        "status": status,
        "passedCount": passed_count,
        "checkCount": len(checks),
        "python": {
            "returnCode": python_run["returnCode"],
            "testCount": python_count,
            "wallTimeSeconds": python_run["wallTimeSeconds"],
            "stdoutLog": "results_temp/python-unittest-stdout.log",
            "stderrLog": "results_temp/python-unittest-stderr.log",
        },
        "wolfram": {
            "returnCode": wolfram_run["returnCode"],
            "passedCount": wolfram_passed,
            "checkCount": wolfram_total,
            "wallTimeSeconds": wolfram_run["wallTimeSeconds"],
            "stdoutLog": "results_temp/wolfram-interface-stdout.log",
            "stderrLog": "results_temp/wolfram-interface-stderr.log",
        },
        "vendorSync": {
            "independentRoot": str(VERSION_ROOT),
            "vendorRoot": str(VENDOR_ROOT),
            "sharedFileCount": len(shared),
            "independentOnly": independent_only,
            "vendorOnly": vendor_only,
            "mismatches": mismatches,
            "files": digest_rows,
            "passed": vendor_sync_ok,
        },
        "testRuntimeExistedAfterRun": runtime_existed,
        "testRuntimeCleaned": runtime_cleaned,
        "checks": checks,
        "wallTimeSeconds": float(python_run["wallTimeSeconds"]) + float(wolfram_run["wallTimeSeconds"]),
    }
    (RESULTS_ROOT / "summary.json").write_text(
        json.dumps(summary, ensure_ascii=False, indent=2) + "\n", encoding="utf-8", newline="\n"
    )

    failed = [name for name, value in checks.items() if value is not True]
    report = "\n".join(
        [
            "# FlintNDE 0.5.0 Validation-03 独立报告",
            "",
            f"- 状态：**{status}**，{passed_count}/{len(checks)}。",
            f"- Python 完整回归：`{python_count if python_count is not None else '未解析'}` 项，退出码 `{python_run['returnCode']}`，wall time `{python_run['wallTimeSeconds']:.6f} s`。",
            f"- Wolfram `Needs` 端到端：`{wolfram_passed}/{wolfram_total}`，退出码 `{wolfram_run['returnCode']}`，wall time `{wolfram_run['wallTimeSeconds']:.6f} s`。",
            f"- 独立包与 MadStree v0.16 Vendor：相对文件集合 `{len(shared)}` 项；SHA-256 不同 `{len(mismatches)}` 项。",
            "",
            "## 同步边界",
            "",
            "- 独立包仅开发用的 `DEVELOPMENT_PLAN.md` 与 `todolist.md` 不属于 Vendor 交付集合。",
            "- cache、pyc、results_temp/results_test 不参与同源比较；MadStree 自有 adapter 不在 Vendor 根中。",
            f"- independent-only：`{independent_only}`；vendor-only：`{vendor_only}`；digest mismatch：`{mismatches}`。",
            f"- 标准 Wolfram 测试曾创建版本内 runtime：`{runtime_existed}`；报告前已清理：`{runtime_cleaned}`。",
            "",
            "## 产物",
            "",
            "- 机器 summary：`results/summary.json`，含全部逐文件 SHA-256。",
            "- 完整 Python/Wolfram stdout、stderr：`results_temp/`，属于可重跑临时证据。",
            f"- 失败项：`{failed if failed else '无'}`。",
            "",
        ]
    )
    REPORT_PATH.write_text(report, encoding="utf-8", newline="\n")
    print(f"FlintNDE Validation-03: {passed_count}/{len(checks)} checks passed")
    return 0 if status == "passed" else 1


if __name__ == "__main__":
    raise SystemExit(main())
