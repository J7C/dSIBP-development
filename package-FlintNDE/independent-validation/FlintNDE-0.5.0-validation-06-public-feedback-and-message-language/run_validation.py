"""FlintNDE 0.5.0 公开反馈与异常语言独立验证（Validation-06）。

本 runner 从三个公开通道动态触发代表性错误并核验反馈质量：

1. Python 公开 API（PY01-PY15，端口自 results_temp 中已验证的 probe_python.py）；
2. CLI 桥接 ``python -m flintnde.mathematica_bridge req.json out.m``（CLI01-CLI07）；
3. Wolfram 桥接 ``Mathematica/FlintNDE.wl``（WM 系列，端口自 probe_wolfram.wls 与
   probe_wolfram2.wls；stub 解释器在运行时重建于 results_temp 下）。

每项触发记录通道、错误类别、异常类型/Failure tag/status+reason、中英文用户句子、
raise 站点 file:line 和 naturalLanguageOk 判定；随后构建公开提醒出口矩阵
（动态触发 / 仅静态审阅 / 无法安全触发），写出报告与 results/summary.json。
本脚本只读被测源码；发现的消息质量问题记录为 finding，不修改源文件。
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
import traceback
import warnings
from pathlib import Path
from typing import Any, Callable

CASE_ROOT = Path(__file__).resolve().parent
SUMMARY_SCHEMA = "flintnde_0.5.0_validation_06_v1"
REPORT_PATH = CASE_ROOT / "000_FlintNDE-0.5.0-validation-06-report.md"
RESULTS_ROOT = CASE_ROOT / "results"
TEMP_ROOT = CASE_ROOT / "results_temp"
DEFAULT_MATHEMATICA = r"D:\Wolfram Research\Wolfram\15.0\math.exe"
WOLFRAM_EXE = Path(os.environ.get("FLINTNDE_TEST_MATHEMATICA", DEFAULT_MATHEMATICA))
WOLFRAM_TIMEOUT_SECONDS = 2400
CLI_TIMEOUT_SECONDS = 600


def find_version_root() -> Path:
    """从本文件位置向上寻找 package-FlintNDE 的 versions/FlintNDE-0.5.0。"""

    for ancestor in (CASE_ROOT, *CASE_ROOT.parents):
        candidate = ancestor / "versions" / "FlintNDE-0.5.0"
        if (candidate / "flintnde" / "__init__.py").is_file():
            return candidate
    raise FileNotFoundError(
        "cannot locate versions/FlintNDE-0.5.0 above "
        f"{CASE_ROOT}; run this script from the validation-06 case directory"
    )


VERSION_ROOT = find_version_root()
FLINTNDE_WL = VERSION_ROOT / "Mathematica" / "FlintNDE.wl"

CJK_RE = re.compile(r"[\u4e00-\u9fff]")
CAUSE_MARKERS = (
    "must", "cannot", "could not", "not ", "missing", "exceeds", "failed",
    "failure", "refuse", "violat", "needs", "requires", "expects", "coincides",
    "does not", "received", "empty", "without", "unsupported",
    "无法", "不是", "缺少", "超过", "失败", "拒绝", "只接受",
    "必须", "不含", "没有", "不能", "收到", "未知", "未能",
)
NEXT_STEP_MARKERS = (
    "please", "try again", "rerun", "re-run", "replan", "regenerate", "supply",
    "provide", "set ", "use ", "pass ", "check", "verify", "install",
    "correct", "adjust", "replace", "rewrite", "remove", "specify", "select",
    "should", "needs", "must", "confirm",
    "请", "重试", "必须", "应", "需", "改为", "把", "检查", "核对", "安装",
    "调整", "补齐", "重新", "指定", "交给", "确认", "改用", "删除",
)


def has_cjk(text: Any) -> bool:
    """判断字符串是否含中文字符。"""

    return isinstance(text, str) and bool(CJK_RE.search(text))


def natural_language_ok(text: Any, *, require_cause: bool = True) -> bool:
    """判定用户句子是否为完整自然语言：有原因、有下一步、非黑话、非原始 <|...|> 转储。

    ``require_cause=False`` 用于规划 notice 类提醒：它们陈述已发生的事实并给出
    下一步，不含错误原因子句。
    """

    if not isinstance(text, str):
        return False
    body = text.strip()
    if not body or len(body) < 20:
        return False
    if body.startswith("<|") or "MessageTemplate" in body or body.startswith("Association["):
        return False
    if not (CJK_RE.search(body) or " " in body):
        return False
    has_cause = any(marker in body for marker in CAUSE_MARKERS)
    has_next_step = any(marker in body for marker in NEXT_STEP_MARKERS)
    return bool(has_next_step and (has_cause or not require_cause))


def fresh_output() -> None:
    """删除本 case 的旧正式结果、旧报告和全部临时 scratch。

    Windows 下 results_temp 可能正被某个 shell 用作工作目录，因此只清空其内容
    而不删除目录本身。
    """

    if RESULTS_ROOT.exists():
        shutil.rmtree(RESULTS_ROOT)
    if TEMP_ROOT.exists():
        for entry in TEMP_ROOT.iterdir():
            if entry.is_dir():
                shutil.rmtree(entry, ignore_errors=True)
            else:
                entry.unlink(missing_ok=True)
    if REPORT_PATH.exists():
        REPORT_PATH.unlink()
    RESULTS_ROOT.mkdir(parents=True, exist_ok=True)
    TEMP_ROOT.mkdir(parents=True, exist_ok=True)


def source_digest() -> str:
    """生成被测源码聚合哈希：flintnde/*.py + Mathematica/FlintNDE.wl。"""

    digest = hashlib.sha256()
    for path in sorted((VERSION_ROOT / "flintnde").glob("*.py")):
        digest.update(path.name.encode("utf-8"))
        digest.update(path.read_bytes())
    digest.update(FLINTNDE_WL.name.encode("utf-8"))
    digest.update(FLINTNDE_WL.read_bytes())
    return digest.hexdigest()


def find_source_line(relative_path: str, needle: str, occurrence: int = 1) -> str:
    """在只读源码中按字面串定位 file:line（第 occurrence 次出现）。"""

    text = (VERSION_ROOT / relative_path).read_text(encoding="utf-8")
    seen = 0
    for index, line in enumerate(text.splitlines(), start=1):
        if needle in line:
            seen += 1
            if seen == occurrence:
                return f"{relative_path}:{index}"
    return f"{relative_path}:?"


def inventory_wolfram_failure_tags() -> dict[str, str]:
    """枚举 FlintNDE.wl 中全部公开 Failure tag 及首次出现行号。"""

    text = FLINTNDE_WL.read_text(encoding="utf-8")
    pattern = re.compile(r'Failure\[\s*"([A-Za-z][A-Za-z0-9]*)"')
    inventory: dict[str, str] = {}
    for match in pattern.finditer(text):
        tag = match.group(1)
        if tag not in inventory:
            line = text.count("\n", 0, match.start(1)) + 1
            inventory[tag] = f"Mathematica/FlintNDE.wl:{line}"
    return inventory


def inventory_wolfram_message_templates() -> dict[str, str]:
    """枚举 FlintNDE.wl 中 FlintNDEBridgeError 的公开 Message 模板及行号。"""

    text = FLINTNDE_WL.read_text(encoding="utf-8")
    pattern = re.compile(r"^(FlintNDEBridgeError::\w+)\s*=", re.MULTILINE)
    inventory: dict[str, str] = {}
    for match in pattern.finditer(text):
        line = text.count("\n", 0, match.start()) + 1
        inventory[match.group(1)] = f"Mathematica/FlintNDE.wl:{line}"
    return inventory


def inventory_python_warning_sites() -> list[tuple[str, str]]:
    """枚举 flintnde/*.py 中全部 warnings.warn 公开提醒出口。"""

    sites: list[tuple[str, str]] = []
    for path in sorted((VERSION_ROOT / "flintnde").glob("*.py")):
        relative = f"flintnde/{path.name}"
        for index, line in enumerate(
            path.read_text(encoding="utf-8").splitlines(), start=1
        ):
            if "warnings.warn(" in line:
                sites.append((f"{relative}:{index}", line.strip()))
    return sites


def capture_raise(fn: Callable[[], Any]) -> dict[str, Any]:
    """执行一个预期失败的调用，记录异常类型、flintnde 内 raise 站点与消息。"""

    try:
        result = fn()
    except BaseException as error:  # noqa: BLE001 - 验证需要捕获一切公开异常
        frames = [
            frame
            for frame in traceback.extract_tb(error.__traceback__)
            if "flintnde" in frame.filename.replace("\\", "/")
        ]
        site = (
            f"{Path(frames[-1].filename).name}:{frames[-1].lineno}" if frames else "?"
        )
        return {
            "raised": True,
            "exceptionType": type(error).__name__,
            "raiseSite": site,
            "message": str(error),
        }
    return {
        "raised": False,
        "exceptionType": type(result).__name__,
        "raiseSite": None,
        "message": "",
        "unexpectedResult": repr(result)[:200],
    }


WOLFRAM_SCRIPT_TEMPLATE = r'''(* ::Package:: *)
(* Validation-06 Wolfram channel runner. ASCII-only by design: math.exe reads
   this script with the system code page, while every non-ASCII sentence under
   test comes from the UTF-8 package file loaded below. The script exercises
   public Failure branches, stub-interpreter bridge failures and real backend
   refusals, then exports one UTF-8 summary JSON for the Python runner. *)

(* ::Chapter:: *)
(*Setup*)

$CharacterEncoding = "UTF-8";
versionRoot = "@@VERSIONROOT@@";
workRoot = "@@WORKROOT@@";
python = "@@PYTHON@@";
Get[FileNameJoin[{versionRoot, "Mathematica", "FlintNDE.wl"}], CharacterEncoding -> "UTF-8"];
If[! DirectoryQ[workRoot], CreateDirectory[workRoot, CreateIntermediateDirectories -> True]];
stubRoot = FileNameJoin[{workRoot, "stubs"}];
If[! DirectoryQ[stubRoot], CreateDirectory[stubRoot, CreateIntermediateDirectories -> True]];
blockerFile = FileNameJoin[{workRoot, "blocker.txt"}];
Export[blockerFile, "blocked", "Text"];
longPath = FileNameJoin[{workRoot, StringRepeat["z", 300]}];
badNameDirectory = FileNameJoin[{workRoot, "bad-name-with-star-char*"}];
pyStub = FileNameJoin[{stubRoot, "pystub"}];
If[! DirectoryQ[FileNameJoin[{pyStub, "flint"}]],
  CreateDirectory[FileNameJoin[{pyStub, "flint"}], CreateIntermediateDirectories -> True]];
Export[FileNameJoin[{pyStub, "flint", "__init__.py"}],
  "raise ModuleNotFoundError(\"No module named 'flint'\")\n", "Text"];


(* ::Chapter:: *)
(*Helpers*)

sanitize[None] := "None";
sanitize[$Failed] := "$Failed";
sanitize[missing_Missing] := "Missing";
sanitize[assoc_Association] := AssociationMap[sanitize, assoc];
sanitize[list_List] := sanitize /@ list;
sanitize[a_ -> b_] := If[StringQ[a], a, ToString[InputForm[a]]] -> sanitize[b];
sanitize[text_String] := text;
sanitize[other_] := If[AtomQ[other], other, ToString[InputForm[other]]];

cjkQ[text_String] := Length[Select[Characters[text], First[ToCharacterCode[#]] > 127 &]] > 0;

failureRecord[expr_] := Module[{result},
  result = expr;
  If[Head[result] =!= Failure,
    <|"isFailure" -> False,
      "resultForm" -> ToString[Head[result]],
      "status" -> If[AssociationQ[result], sanitize[Lookup[result, "status", "None"]], "NotAssociation"],
      "message" -> If[AssociationQ[result], sanitize[Lookup[result, "message", "None"]], "None"],
      "messageLanguage" -> If[AssociationQ[result], sanitize[Lookup[result, "messageLanguage", "None"]], "None"]|>,
    <|"isFailure" -> True,
      "resultForm" -> "Failure",
      "tag" -> sanitize[result[[1]]],
      "keys" -> Map[ToString, Keys[result[[2]]]],
      "messageTemplate" -> sanitize[Lookup[result[[2]], "MessageTemplate", None]],
      "message" -> sanitize[Lookup[result[[2]], "message", None]],
      "messageLanguage" -> sanitize[Lookup[result[[2]], "messageLanguage", None]]|>]
];

epBatchRecord[expr_] := Module[{result, first},
  result = expr;
  first = If[AssociationQ[result] && KeyExistsQ[result, "results"] && result["results"] =!= {},
    First[result["results"]], <||>];
  <|"isFailure" -> (Head[result] === Failure),
    "resultForm" -> ToString[Head[result]],
    "status" -> If[AssociationQ[result], sanitize[Lookup[result, "status", "None"]], "NotAssociation"],
    "epFirstStatus" -> sanitize[Lookup[first, "status", "None"]],
    "epFirstPlanStatus" -> sanitize[Lookup[Lookup[first, "plan", <||>], "status", "None"]],
    "epFirstPlanMessage" -> sanitize[Lookup[Lookup[first, "plan", <||>], "message", "None"]],
    "epFirstPlanMessageLanguage" ->
      sanitize[Lookup[Lookup[first, "plan", <||>], "messageLanguage", "None"]]|>
];


(* ::Chapter:: *)
(*Stub interpreters*)

writeStub[name_String, body_String] := Export[FileNameJoin[{stubRoot, name}], body, "Text"];
writeStub["stub_flint_missing.bat", StringJoin[
  "@echo off\r\n",
  "set PYTHONPATH=", pyStub, ";", versionRoot, "\r\n",
  "\"", python, "\" -m flintnde.mathematica_bridge %3 %4\r\n",
  "exit /b %ERRORLEVEL%\r\n"]];
writeStub["stub_no_output.bat", "@echo off\r\nexit /b 0\r\n"];
writeStub["stub_exit1.bat", "@echo off\r\nexit /b 3\r\n"];
writeStub["stub_bad_output.bat", StringJoin[
  "@echo off\r\n",
  "\"", python, "\" -c \"import sys; open(sys.argv[1], 'w').write('(unclosed[')\" %4\r\n",
  "exit /b 0\r\n"]];
writeStub["stub_symbol_output.bat", StringJoin[
  "@echo off\r\n",
  "\"", python, "\" -c \"import sys; open(sys.argv[1], 'w').write('someUndefinedSymbol')\" %4\r\n",
  "exit /b 0\r\n"]];
writeStub["stub_error_status.bat", StringJoin[
  "@echo off\r\n",
  "\"", python, "\" \"", FileNameJoin[{stubRoot, "stub_err_write.py"}], "\" %4\r\n",
  "exit /b 0\r\n"]];
Export[FileNameJoin[{stubRoot, "stub_err_write.py"}], StringJoin[
  "import sys\n",
  "text = 'FlintNDEBridgeResult = <|\"schema\" -> \"flintnde_mathematica_bridge_v1\", \"status\" -> \"error\", \"message\" -> \"simulated backend failure for the validation-06 runner\"|>;\\n'\n",
  "open(sys.argv[1], 'w', encoding='utf-8').write(text)\n"], "Text"];


(* ::Chapter:: *)
(*Cheap public failure branches*)

goodSystem = FlintNDERationalSystem[{{1/(x + 2)}}, x, "Name" -> "v06-good"];
cases = <||>;
cases["nonRational"] = failureRecord[FlintNDERationalSystem[{{Sin[x]}}, x]];
cases["inexact"] = failureRecord[FlintNDERationalSystem[{{1.5/(x + 2)}}, x]];
cases["nonSquare"] = failureRecord[FlintNDERationalSystem[{{1/(x + 2), 0}}, x]];
cases["badLanguage"] = failureRecord[FlintNDEPlanPath[goodSystem, 0, {1}, MessageLanguage -> "FR", "Python" -> python, "WorkDirectory" -> workRoot]];
cases["badModeString"] = failureRecord[FlintNDEPlanPath[goodSystem, 0, {1}, SingularityMode -> "Warp", "Python" -> python, "WorkDirectory" -> workRoot]];
cases["badModeType"] = failureRecord[FlintNDEPlanPath[goodSystem, 0, {1}, SingularityMode -> 42, "Python" -> python, "WorkDirectory" -> workRoot]];
cases["unknownOption"] = failureRecord[FlintNDEPlanPath[goodSystem, 0, {1}, "BogusOption" -> 1, "Python" -> python, "WorkDirectory" -> workRoot]];
cases["badPythonType"] = failureRecord[FlintNDEPlanPath[goodSystem, 0, {1}, "Python" -> 42, "WorkDirectory" -> workRoot]];
cases["badWorkDirType"] = failureRecord[FlintNDEPlanPath[goodSystem, 0, {1}, "Python" -> python, "WorkDirectory" -> 42]];
cases["pathTooLong"] = failureRecord[FlintNDEPlanPath[goodSystem, 0, {1}, "Python" -> python, "WorkDirectory" -> longPath]];
cases["workDirWriteBlocked"] = failureRecord[FlintNDEPlanPath[goodSystem, 0, {1}, "Python" -> python, "WorkDirectory" -> blockerFile]];
cases["workDirCreationBadName"] = failureRecord[FlintNDEPlanPath[goodSystem, 0, {1}, "Python" -> python, "WorkDirectory" -> badNameDirectory]];
cases["launchFailed"] = failureRecord[FlintNDEPlanPath[goodSystem, 0, {1}, "Python" -> "flintnde-v06-nonexistent-python", "WorkDirectory" -> workRoot]];
cases["invalidPlanAssoc"] = failureRecord[FlintNDEExecutePath[goodSystem, {1}, <|"junk" -> 1|>, "Python" -> python, "WorkDirectory" -> workRoot]];
cases["precisionMissing"] = failureRecord[FlintNDEExecutePath[goodSystem, {1}, <|"schema" -> "flintnde_mathematica_bridge_v1", "status" -> "complete", "operation" -> "plan", "plan" -> <|"junk" -> 1|>|>, "Python" -> python, "WorkDirectory" -> workRoot]];
cases["epBatchEmpty"] = failureRecord[FlintNDEEvaluateEpBatch[{}, "Python" -> python, "WorkDirectory" -> workRoot]];
cases["epJobMissing"] = failureRecord[FlintNDEEvaluateEpBatch[{<|"ep" -> 0|>}, "Python" -> python, "WorkDirectory" -> workRoot]];
cases["parallelCount"] = failureRecord[FlintNDEEvaluateEpBatch[{<||>}, ParallelTaskCount -> 0, "Python" -> python, "WorkDirectory" -> workRoot]];
cases["invalidPlanArguments"] = failureRecord[FlintNDEPlanPath[1, 2, 3]];
cases["invalidSystemArguments"] = failureRecord[FlintNDERationalSystem[x]];
cases["pfNonList"] = failureRecord[FlintNDEPartialFractionSystem[5, {}, {}]];
cases["pfDimensions"] = failureRecord[FlintNDEPartialFractionSystem[{{{1, 2}}}, {{{1}}}, {}]];
cases["pfPoleMismatch"] = failureRecord[FlintNDEPartialFractionSystem[{{{1}}}, {{{1}}}, {1, 2}]];
cases["pfArguments"] = failureRecord[FlintNDEPartialFractionSystem[x]];
cases["executeArguments"] = failureRecord[FlintNDEExecutePath[1, 2]];
cases["epBatchArguments"] = failureRecord[FlintNDEEvaluateEpBatch[5]];


(* ::Chapter:: *)
(*Stub-driven bridge failures*)

stubCases = <||>;
stubCases["flintMissing"] = failureRecord[FlintNDEPlanPath[goodSystem, 0, {1},
  "Python" -> FileNameJoin[{stubRoot, "stub_flint_missing.bat"}],
  "WorkDirectory" -> workRoot, "WorkingPrecisionDigits" -> 60, "OutputDigits" -> 30]];
stubCases["noOutput"] = failureRecord[FlintNDEPlanPath[goodSystem, 0, {1},
  "Python" -> FileNameJoin[{stubRoot, "stub_no_output.bat"}],
  "WorkDirectory" -> workRoot, "WorkingPrecisionDigits" -> 60, "OutputDigits" -> 30]];
stubCases["exitNonzero"] = failureRecord[FlintNDEPlanPath[goodSystem, 0, {1},
  "Python" -> FileNameJoin[{stubRoot, "stub_exit1.bat"}],
  "WorkDirectory" -> workRoot, "WorkingPrecisionDigits" -> 60, "OutputDigits" -> 30]];
stubCases["badOutput"] = failureRecord[FlintNDEPlanPath[goodSystem, 0, {1},
  "Python" -> FileNameJoin[{stubRoot, "stub_bad_output.bat"}],
  "WorkDirectory" -> workRoot, "WorkingPrecisionDigits" -> 60, "OutputDigits" -> 30]];
stubCases["symbolOutput"] = failureRecord[FlintNDEPlanPath[goodSystem, 0, {1},
  "Python" -> FileNameJoin[{stubRoot, "stub_symbol_output.bat"}],
  "WorkDirectory" -> workRoot, "WorkingPrecisionDigits" -> 60, "OutputDigits" -> 30]];
stubCases["errorStatus"] = failureRecord[FlintNDEPlanPath[goodSystem, 0, {1},
  "Python" -> FileNameJoin[{stubRoot, "stub_error_status.bat"}],
  "WorkDirectory" -> workRoot, "WorkingPrecisionDigits" -> 60, "OutputDigits" -> 30]];


(* ::Chapter:: *)
(*Real backend refusals and precision gates*)

realCases = <||>;
singularSystem = FlintNDERationalSystem[{{-1/(x - 1)}}, x, "Name" -> "v06-pole"];
realCases["refusedCN"] = failureRecord[FlintNDEPlanPath[singularSystem, 0, {1/2, 1, 3/2, 2},
  MessageLanguage -> "CN", "Python" -> python, "WorkDirectory" -> workRoot,
  "WorkingPrecisionDigits" -> 60, "OutputDigits" -> 30]];
realCases["refusedEN"] = failureRecord[FlintNDEPlanPath[singularSystem, 0, {1/2, 1, 3/2, 2},
  MessageLanguage -> "EN", "Python" -> python, "WorkDirectory" -> workRoot,
  "WorkingPrecisionDigits" -> 60, "OutputDigits" -> 30]];
realCases["plan60"] = "pending";
plan60 = FlintNDEPlanPath[goodSystem, 0, {1},
  MessageLanguage -> "CN", "Python" -> python, "WorkDirectory" -> workRoot,
  "WorkingPrecisionDigits" -> 60, "OutputDigits" -> 30];
realCases["plan60"] = failureRecord[plan60];
realCases["precisionCN"] = failureRecord[FlintNDEExecutePath[goodSystem, {1}, plan60,
  MessageLanguage -> "CN", "Python" -> python, "WorkDirectory" -> workRoot,
  "WorkingPrecisionDigits" -> 90, "OutputDigits" -> 30,
  "PrimaryOrder" -> 12, "ReferenceOrder" -> 16, "TargetRelativeError" -> "1e-10"]];
realCases["precisionEN"] = failureRecord[FlintNDEExecutePath[goodSystem, {1}, plan60,
  MessageLanguage -> "EN", "Python" -> python, "WorkDirectory" -> workRoot,
  "WorkingPrecisionDigits" -> 90, "OutputDigits" -> 30,
  "PrimaryOrder" -> 12, "ReferenceOrder" -> 16, "TargetRelativeError" -> "1e-10"]];
realCases["epBatchRefused"] = epBatchRecord[FlintNDEEvaluateEpBatch[
  {<|"ep" -> 0, "system" -> singularSystem, "start" -> 0,
    "points" -> {1/2, 1, 3/2, 2}, "initialVector" -> {1}|>},
  ParallelTaskCount -> 1, MessageLanguage -> "EN", SingularityMode -> "Avoid",
  "Python" -> python, "WorkDirectory" -> workRoot,
  "WorkingPrecisionDigits" -> 60, "OutputDigits" -> 30,
  "PrimaryOrder" -> 12, "ReferenceOrder" -> 16, "TargetRelativeError" -> "1e-10"]];


(* ::Chapter:: *)
(*Export*)

templates = <|
  "error" -> FlintNDEBridgeError::error,
  "pythonFlintMissing" -> FlintNDEBridgeError::pythonFlintMissing,
  "launchFailed" -> FlintNDEBridgeError::launchFailed,
  "outputMissing" -> FlintNDEBridgeError::outputMissing
|>;
templateCjk = Association[First[#] -> cjkQ[Last[#]] & /@ Normal[templates]];
payload = <|
  "packageVersion" -> $FlintNDEVersion,
  "cases" -> cases,
  "stubs" -> stubCases,
  "real" -> realCases,
  "templates" -> templates,
  "templateCjk" -> templateCjk
|>;
Export[FileNameJoin[{workRoot, "wolfram_summary.json"}], sanitize[payload],
  "RawJSON", CharacterEncoding -> "UTF-8"];
Print["validation-06 wolfram channel done"];
'''


def write_wolfram_script(work_root: Path) -> Path:
    """把 ASCII-only 的 Wolfram 通道脚本写入 results_temp 并返回路径。"""

    script = (
        WOLFRAM_SCRIPT_TEMPLATE
        .replace("@@VERSIONROOT@@", VERSION_ROOT.as_posix())
        .replace("@@WORKROOT@@", work_root.as_posix())
        .replace("@@PYTHON@@", Path(sys.executable).as_posix())
    )
    if not script.isascii():
        raise RuntimeError("internal error: Wolfram wrapper must stay ASCII-only")
    script_path = work_root / "run_wolfram_channel.wls"
    work_root.mkdir(parents=True, exist_ok=True)
    script_path.write_text(script, encoding="ascii", newline="\n")
    return script_path


def run_wolfram_channel() -> tuple[dict[str, Any], str, int]:
    """通过 math.exe -noprompt -script 执行 Wolfram 通道并读取 UTF-8 summary。"""

    work_root = TEMP_ROOT / "wolfram"
    script_path = write_wolfram_script(work_root)
    environment = os.environ.copy()
    environment["FLINTNDE_TEST_PYTHON"] = sys.executable
    environment["FLINTNDE_SUPPRESS_CITATION_NOTICE"] = "1"
    environment["PYTHONDONTWRITEBYTECODE"] = "1"
    process = subprocess.run(
        [str(WOLFRAM_EXE), "-noprompt", "-script", str(script_path)],
        cwd=str(work_root),
        env=environment,
        text=True,
        encoding="utf-8",
        errors="replace",
        capture_output=True,
        check=False,
        timeout=WOLFRAM_TIMEOUT_SECONDS,
    )
    (TEMP_ROOT / "wolfram-stdout.log").write_text(
        process.stdout, encoding="utf-8", newline="\n"
    )
    (TEMP_ROOT / "wolfram-stderr.log").write_text(
        process.stderr, encoding="utf-8", newline="\n"
    )
    summary_path = work_root / "wolfram_summary.json"
    try:
        summary = json.loads(summary_path.read_text(encoding="utf-8-sig"))
    except (OSError, json.JSONDecodeError):
        summary = {}
    return summary, process.stdout + process.stderr, process.returncode


def run_cli_case(case_id: str, request: Any, *, missing_request: bool = False) -> dict[str, Any]:
    """执行一个 CLI 桥接 case，记录退出码、status 关联、message 与 stderr 句子。"""

    cli_root = TEMP_ROOT / "cli"
    cli_root.mkdir(parents=True, exist_ok=True)
    request_path = cli_root / f"{case_id}-req.json"
    output_path = cli_root / f"{case_id}-out.m"
    if output_path.exists():
        output_path.unlink()
    if missing_request:
        request_arg = str(cli_root / f"{case_id}-absent.json")
    else:
        request_path.write_text(
            json.dumps(request, ensure_ascii=False), encoding="utf-8", newline="\n"
        )
        request_arg = str(request_path)
    environment = os.environ.copy()
    environment["PYTHONPATH"] = str(VERSION_ROOT)
    environment["FLINTNDE_SUPPRESS_CITATION_NOTICE"] = "1"
    environment["PYTHONIOENCODING"] = "utf-8"
    environment["PYTHONDONTWRITEBYTECODE"] = "1"
    process = subprocess.run(
        [
            sys.executable,
            "-m",
            "flintnde.mathematica_bridge",
            request_arg,
            str(output_path),
        ],
        cwd=str(VERSION_ROOT),
        env=environment,
        text=True,
        encoding="utf-8",
        errors="replace",
        capture_output=True,
        check=False,
        timeout=CLI_TIMEOUT_SECONDS,
    )
    output_text = (
        output_path.read_text(encoding="utf-8") if output_path.exists() else ""
    )
    status_match = re.search(r'"status"\s*->\s*"([A-Za-z]+)"', output_text)
    message_match = re.search(r'"message"\s*->\s*"((?:[^"\\]|\\.)*)"', output_text)
    message = (
        message_match.group(1).replace('\\"', '"').replace("\\\\", "\\")
        if message_match
        else ""
    )
    return {
        "exitCode": process.returncode,
        "status": status_match.group(1) if status_match else None,
        "message": message,
        "outputHead": output_text.split("\n", 1)[0][:80],
        "stderr": process.stderr.strip()[:500],
        "outputIsAssociation": output_text.startswith("FlintNDEBridgeResult = <|"),
    }


def bridge_plan_request(
    matrix: list[list[dict[str, list[str]]]],
    name: str,
    points: list[str],
    language: str,
    *,
    drop_fields: tuple[str, ...] = (),
) -> dict[str, Any]:
    """构造当前 bridge schema 的完整 plan 请求（可去掉字段做 schema 反例）。"""

    sys.path.insert(0, str(VERSION_ROOT))
    from flintnde import mathematica_bridge

    request: dict[str, Any] = {
        "schema": mathematica_bridge.REQUEST_SCHEMA,
        "action": "plan",
        "system": {"type": "rationalMatrix", "variable": "x", "name": name, "matrix": matrix},
        "start": "0",
        "points": points,
        "workingPrecisionDigits": 60,
        "outputDigits": 30,
        "singularityMode": "avoid",
        "messageLanguage": language,
        "radiusFraction": 0.6,
        "maxStepOverRadius": 0.45,
        "singularityJumpThreshold": 0.5,
        "matchFraction": 0.6,
        "maxSingularityJumps": 16,
    }
    for field in drop_fields:
        request.pop(field, None)
    return request


def inspect_public_cli() -> dict[str, Any]:
    """程序化核实 FlintNDE 0.5.0 是否存在公开 console-script CLI。

    判据：pyproject.toml 的 [project.scripts]/[project.gui-scripts] 与
    flintnde/__main__.py（``python -m flintnde``）是否存在。桥接模块命令行
    ``python -m flintnde.mathematica_bridge`` 是 Wolfram 桥协议入口，
    本验证将其用作 CLI 通道并如实说明。
    """

    pyproject_path = VERSION_ROOT / "pyproject.toml"
    console_scripts: list[str] = []
    gui_scripts: list[str] = []
    if pyproject_path.is_file():
        import tomllib

        data = tomllib.loads(pyproject_path.read_text(encoding="utf-8"))
        project = data.get("project", {})
        console_scripts = sorted((project.get("scripts") or {}).keys())
        gui_scripts = sorted((project.get("gui-scripts") or {}).keys())
    has_main = (VERSION_ROOT / "flintnde" / "__main__.py").is_file()
    return {
        "consoleScripts": console_scripts,
        "guiScripts": gui_scripts,
        "hasMainModule": has_main,
        "publicCliExists": bool(console_scripts or gui_scripts or has_main),
        "cliChannelUsed": [
            sys.executable, "-m", "flintnde.mathematica_bridge",
            "<request.json>", "<output.m>",
        ],
        "statement": (
            "not applicable / no public CLI"
            if not (console_scripts or gui_scripts or has_main)
            else "public console-script CLI present"
        ),
    }


def run_unittest_suite() -> dict[str, Any]:
    """从版本目录以 ``-s tests -t tests`` 运行自带 unittest 套件一次并记录计数。"""

    environment = os.environ.copy()
    environment["PYTHONDONTWRITEBYTECODE"] = "1"
    environment["FLINTNDE_SUPPRESS_CITATION_NOTICE"] = "1"
    command = [
        sys.executable, "-m", "unittest", "discover", "-s", "tests", "-t", "tests",
    ]
    process = subprocess.run(
        command,
        cwd=str(VERSION_ROOT),
        env=environment,
        text=True,
        encoding="utf-8",
        errors="replace",
        capture_output=True,
        check=False,
        timeout=3600,
    )
    combined = f"{process.stdout}\n{process.stderr}"
    match = re.search(r"^Ran (\d+) tests?", combined, re.MULTILINE)
    return {
        "command": command,
        "cwd": str(VERSION_ROOT),
        "exitCode": process.returncode,
        "testsRun": int(match.group(1)) if match else None,
        "ok": process.returncode == 0
        and bool(re.search(r"^OK", combined, re.MULTILINE)),
        "tail": combined.strip()[-500:],
    }


def main() -> int:
    """执行 Python/CLI/Wolfram 三通道动态触发、出口矩阵与报告输出。"""

    started = time.perf_counter()
    fresh_output()
    sys.dont_write_bytecode = True
    os.environ["FLINTNDE_SUPPRESS_CITATION_NOTICE"] = "1"
    sys.path.insert(0, str(VERSION_ROOT))

    from flint import acb, acb_mat
    from flintnde import (
        NamedPoint,
        RationalMatrixSystem,
        adaptive_path_from_json,
        adaptive_path_to_json,
        build_adaptive_path,
        configure_working_precision,
        rational_function,
        transport_path,
    )
    from flintnde import mathematica_bridge

    configure_working_precision(90, 50)

    ordinary = RationalMatrixSystem(
        ((rational_function(1, [2, 1]),),), variable_name="x", name="v06-ordinary"
    )
    pole = RationalMatrixSystem(
        ((rational_function([-1], [-1, 1]),),), variable_name="x", name="v06-pole"
    )

    checks: dict[str, bool] = {}
    findings: list[dict[str, Any]] = []
    triggers: list[dict[str, Any]] = []

    def record_python_trigger(
        case_id: str,
        category: str,
        capture: dict[str, Any],
        *,
        expected_type: str,
        expected_site_file: str,
        language: str | None = None,
    ) -> dict[str, Any]:
        """登记一个 Python 通道触发记录并生成机器可判定的硬 check。"""

        record = {
            "id": case_id,
            "channel": "python",
            "category": category,
            "language": language,
            **capture,
        }
        record["naturalLanguageOk"] = natural_language_ok(record["message"])
        record["noFalseSuccess"] = bool(capture["raised"])
        triggers.append(record)
        checks[f"{case_id}RaisesExpectedType"] = (
            capture["raised"]
            and capture["exceptionType"] == expected_type
            and str(capture["raiseSite"]).startswith(expected_site_file + ":")
            and bool(capture["message"].strip())
        )
        if not record["naturalLanguageOk"]:
            findings.append(
                {
                    "id": f"F-{case_id}",
                    "channel": "python",
                    "caseId": case_id,
                    "site": f"flintnde/{capture['raiseSite']}",
                    "issue": "共同判据 4：用户句子缺少明确的可行下一步（原始操作系统/内部消息直达用户）",
                    "offendingText": capture["message"][:400],
                }
            )
        # 任务书要求：源码消息不合规时该 case 记为失败（finding 只记录、不改源）。
        checks[f"{case_id}MessageCompliant"] = record["naturalLanguageOk"]
        return record

    # ---------------- Python 通道：PY01-PY15 ----------------
    record_python_trigger(
        "PY01", "input-type",
        capture_raise(lambda: build_adaptive_path(
            ordinary, NamedPoint("start", acb(0)), NamedPoint("target", acb(2)),
            message_language=2024)),
        expected_type="TypeError", expected_site_file="routing.py",
    )
    record_python_trigger(
        "PY02", "input-type",
        capture_raise(lambda: build_adaptive_path(
            ordinary, NamedPoint("start", acb(0)), NamedPoint("target", acb(2)),
            singularity_mode="teleport")),
        expected_type="ValueError", expected_site_file="routing.py",
    )
    record_python_trigger(
        "PY03", "dimension",
        capture_raise(lambda: RationalMatrixSystem(
            ((rational_function(1, [2, 1]), rational_function(0, [1])),),
            variable_name="x", name="v06-nonsquare")),
        expected_type="ValueError", expected_site_file="singularities.py",
    )
    record_python_trigger(
        "PY04", "precision",
        capture_raise(lambda: configure_working_precision(0)),
        expected_type="ValueError", expected_site_file="core.py",
    )
    record_python_trigger(
        "PY05", "path",
        capture_raise(lambda: transport_path(ordinary, acb_mat([[1]]), [acb(0)], order=8)),
        expected_type="ValueError", expected_site_file="transport.py",
    )
    refusal_cn = record_python_trigger(
        "PY06", "singularity",
        capture_raise(lambda: build_adaptive_path(
            pole, NamedPoint("start", acb(0)), NamedPoint("target", acb(2)),
            message_language="CN")),
        expected_type="AdaptivePathSingularityError", expected_site_file="routing.py",
        language="CN",
    )
    refusal_en = record_python_trigger(
        "PY07", "singularity",
        capture_raise(lambda: build_adaptive_path(
            pole, NamedPoint("start", acb(0)), NamedPoint("target", acb(2)),
            message_language="EN")),
        expected_type="AdaptivePathSingularityError", expected_site_file="routing.py",
        language="EN",
    )
    checks["py06py07BilingualRefusal"] = (
        has_cjk(refusal_cn["message"])
        and not has_cjk(refusal_en["message"])
        and "singularity_jump" in refusal_cn["message"]
        and "singularity_jump" in refusal_en["message"]
        and "detour_points" in refusal_en["message"]
    )
    record_python_trigger(
        "PY08", "singularity",
        capture_raise(lambda: build_adaptive_path(
            pole, NamedPoint("start", acb(0)), NamedPoint("target", acb(2)),
            detour_points=(acb(1),))),
        expected_type="ValueError", expected_site_file="routing.py",
    )

    def py09() -> Any:
        path = build_adaptive_path(
            ordinary, NamedPoint("start", acb(0)), NamedPoint("target", acb(1))
        )
        record = adaptive_path_to_json(path, digits=40)
        record["transitions"][0]["method"] = "quantum_tunnel"
        return adaptive_path_from_json(ordinary, record)

    record_python_trigger(
        "PY09", "serialization", capture_raise(py09),
        expected_type="ValueError", expected_site_file="routing.py",
    )

    def py10() -> Any:
        blocker = TEMP_ROOT / "py10_file_write_blocker.txt"
        blocker.write_text("this file blocks the save directory", encoding="utf-8")
        save_path = build_adaptive_path(
            ordinary, NamedPoint("start", acb(0)), NamedPoint("target", acb(1)),
            detour_points=((acb("0.5"), "save"),),
        )
        return transport_path(
            ordinary, acb_mat([[1]]), save_path, order=8,
            save_output_directory=blocker / "subdir",
        )

    record_python_trigger(
        "PY10", "savepoint+file-write", capture_raise(py10),
        expected_type="FileExistsError", expected_site_file="savepoints.py",
    )

    # PY11：CN 与 EN 规划 notice（warning 通道），raise 站点静态定位。
    notice_site = find_source_line(
        "flintnde/routing.py", 'warnings.warn("; ".join(messages)'
    )
    notice_records: dict[str, dict[str, Any]] = {}
    for language in ("CN", "EN"):
        with warnings.catch_warnings(record=True) as caught:
            warnings.simplefilter("always")
            build_adaptive_path(
                ordinary, NamedPoint("start", acb(0)), NamedPoint("target", acb(1)),
                message_language=language,
            )
        texts = [str(item.message) for item in caught]
        notice_records[language] = {
            "id": f"PY11-{language}",
            "channel": "python",
            "category": "notice",
            "language": language,
            "raised": False,
            "exceptionType": "UserWarning",
            "raiseSite": notice_site,
            "message": texts[0] if texts else "",
            "warningCount": len(texts),
        }
        notice_records[language]["naturalLanguageOk"] = natural_language_ok(
            texts[0] if texts else "", require_cause=False
        )
        notice_records[language]["noFalseSuccess"] = True
        triggers.append(notice_records[language])
    checks["py11NoticesBilingual"] = (
        notice_records["CN"]["warningCount"] == 1
        and notice_records["EN"]["warningCount"] == 1
        and has_cjk(notice_records["CN"]["message"])
        and "Raw endpoints were supplied" in notice_records["EN"]["message"]
        and notice_records["CN"]["naturalLanguageOk"]
        and notice_records["EN"]["naturalLanguageOk"]
    )
    if "every transport step stays within" in notice_records["CN"]["message"]:
        findings.append(
            {
                "id": "F-PY11-CN",
                "channel": "python",
                "caseId": "PY11-CN",
                "site": find_source_line(
                    "flintnde/routing.py", "every transport step stays within"
                ),
                "issue": "Validation-06 第 3 条：CN 规划 notice 的步长/半径诊断子句保持英文，未按 message_language 翻译（主体句子为完整中文）",
                "offendingText": notice_records["CN"]["message"][:400],
            }
        )
        checks["PY11-CNMessageCompliant"] = False

    record_python_trigger(
        "PY13", "unsupported-capability",
        capture_raise(lambda: mathematica_bridge.run_request(
            {"schema": mathematica_bridge.REQUEST_SCHEMA, "action": "teleport"})),
        expected_type="ValueError", expected_site_file="mathematica_bridge.py",
    )

    def py14() -> Any:
        plan = mathematica_bridge.run_request(bridge_plan_request(
            [[{"numerator": ["1"], "denominator": ["2", "1"]}]],
            "v06-bridge", ["1"], "EN",
        ))
        if plan.get("status") != "complete":
            raise AssertionError(f"PY14 precondition failed: plan status {plan.get('status')!r}")
        return mathematica_bridge.run_request({
            "schema": mathematica_bridge.REQUEST_SCHEMA,
            "action": "execute",
            "system": {
                "type": "rationalMatrix", "variable": "x", "name": "v06-bridge",
                "matrix": [[{"numerator": ["1"], "denominator": ["2", "1"]}]],
            },
            "initialVector": ["1"], "plannedResult": plan,
            "workingPrecisionDigits": 90, "outputDigits": 30,
            "primaryOrder": 12, "referenceOrder": 16,
            "targetRelativeError": "1e-10", "certificationMode": "certified",
            "radiusFraction": 0.6, "messageLanguage": "EN",
        })

    py14_capture = capture_raise(py14)
    record_python_trigger(
        "PY14", "precision", py14_capture,
        expected_type="ValueError", expected_site_file="mathematica_bridge.py",
    )
    checks["py14NoTransportAfterGate"] = (
        py14_capture["raised"]
        and "exceeds planned precision" in py14_capture["message"]
        and "replan" in py14_capture["message"]
    )
    py15_capture = capture_raise(lambda: mathematica_bridge.run_request(
        bridge_plan_request(
            [[{"numerator": ["1"], "denominator": ["2", "1"]}]],
            "v06-bridge", ["1"], "EN",
            drop_fields=(
                "radiusFraction", "maxStepOverRadius", "singularityJumpThreshold",
                "matchFraction", "maxSingularityJumps",
            ),
        )
    ))
    record_python_trigger(
        "PY15", "serialization", py15_capture,
        expected_type="ValueError", expected_site_file="core.py",
    )
    checks["py15SchemaSentence"] = (
        "missing the required fields" in py15_capture["message"]
        and "supply exactly the required fields" in py15_capture["message"]
    )

    # ---------------- CLI 通道：CLI01-CLI07 ----------------
    cli_error_cases = {
        "CLI01": (
            "serialization",
            {"schema": "flintnde_mathematica_request_v0_bogus", "action": "plan"},
            "unsupported bridge request schema",
        ),
        "CLI02": (
            "unsupported-capability",
            {"schema": mathematica_bridge.REQUEST_SCHEMA, "action": "teleport"},
            'action must be exactly "plan"',
        ),
        "CLI03": (
            "serialization",
            bridge_plan_request(
                [[{"numerator": ["1"], "denominator": ["2", "1"]}]],
                "v06-cli", ["1"], "EN",
                drop_fields=("matchFraction", "maxSingularityJumps"),
            ),
            "missing the required fields",
        ),
        "CLI04": (
            "input-type",
            bridge_plan_request(
                [[{"numerator": ["1"], "denominator": ["2", "1"]}]],
                "v06-cli", ["1"], "FR",
            ),
            'messageLanguage must be exactly "EN" or "CN"',
        ),
    }
    cli_records: dict[str, dict[str, Any]] = {}
    for case_id, (category, request, expected_fragment) in cli_error_cases.items():
        outcome = run_cli_case(case_id, request)
        record = {
            "id": case_id,
            "channel": "cli",
            "category": category,
            "language": None,
            "raised": False,
            "exceptionType": f"status={outcome['status']}",
            "raiseSite": None,
            "message": outcome["message"],
            "exitCode": outcome["exitCode"],
            "status": outcome["status"],
            "stderr": outcome["stderr"],
            "noFalseSuccess": outcome["status"] == "error" and outcome["exitCode"] == 1,
        }
        record["naturalLanguageOk"] = natural_language_ok(
            outcome["stderr"] or outcome["message"]
        )
        cli_records[case_id] = record
        triggers.append(record)
        checks[f"{case_id}ErrorAssociation"] = (
            outcome["exitCode"] == 1
            and outcome["status"] == "error"
            and outcome["outputIsAssociation"]
            and expected_fragment in outcome["message"]
            and "The FlintNDE Wolfram bridge failed:" in outcome["stderr"]
        )
        if not record["naturalLanguageOk"]:
            findings.append(
                {
                    "id": f"F-{case_id}",
                    "channel": "cli",
                    "caseId": case_id,
                    "site": find_source_line(
                        "flintnde/mathematica_bridge.py",
                        "The FlintNDE Wolfram bridge failed",
                    ),
                    "issue": "共同判据 4：CLI 失败句子内嵌原始异常/操作系统消息，缺少明确可行下一步",
                    "offendingText": (outcome["stderr"] or outcome["message"])[:400],
                }
            )
        checks[f"{case_id}MessageCompliant"] = record["naturalLanguageOk"]

    singular_matrix = [[{"numerator": ["-1"], "denominator": ["-1", "1"]}]]
    for case_id, language in (("CLI05", "CN"), ("CLI06", "EN")):
        outcome = run_cli_case(
            case_id,
            bridge_plan_request(singular_matrix, "v06-cli-pole", ["2"], language),
        )
        record = {
            "id": case_id,
            "channel": "cli",
            "category": "singularity",
            "language": language,
            "raised": False,
            "exceptionType": f"status={outcome['status']}",
            "raiseSite": None,
            "message": outcome["message"],
            "exitCode": outcome["exitCode"],
            "status": outcome["status"],
            "stderr": outcome["stderr"],
            "noFalseSuccess": outcome["status"] == "singularPathRefused",
        }
        record["naturalLanguageOk"] = natural_language_ok(outcome["message"])
        cli_records[case_id] = record
        triggers.append(record)
        checks[f"{case_id}MessageCompliant"] = record["naturalLanguageOk"]
    checks["cli05RefusalCN"] = (
        cli_records["CLI05"]["exitCode"] == 0
        and cli_records["CLI05"]["status"] == "singularPathRefused"
        and has_cjk(cli_records["CLI05"]["message"])
        and "singularity_jump" in cli_records["CLI05"]["message"]
    )
    checks["cli06RefusalEN"] = (
        cli_records["CLI06"]["exitCode"] == 0
        and cli_records["CLI06"]["status"] == "singularPathRefused"
        and not has_cjk(cli_records["CLI06"]["message"])
        and "avoid-singularity mode refuses" in cli_records["CLI06"]["message"]
    )

    cli07 = run_cli_case("CLI07", None, missing_request=True)
    cli07_record = {
        "id": "CLI07",
        "channel": "cli",
        "category": "file-write",
        "language": None,
        "raised": False,
        "exceptionType": f"status={cli07['status']}",
        "raiseSite": find_source_line(
            "flintnde/mathematica_bridge.py", "The FlintNDE Wolfram bridge failed"
        ),
        "message": cli07["message"],
        "exitCode": cli07["exitCode"],
        "status": cli07["status"],
        "stderr": cli07["stderr"],
        "noFalseSuccess": cli07["status"] == "error" and cli07["exitCode"] == 1,
    }
    cli07_record["naturalLanguageOk"] = natural_language_ok(
        cli07["stderr"] or cli07["message"]
    )
    cli_records["CLI07"] = cli07_record
    triggers.append(cli07_record)
    checks["cli07MissingRequestFile"] = (
        cli07["exitCode"] == 1
        and cli07["status"] == "error"
        and "No such file or directory" in cli07["message"]
        and "The FlintNDE Wolfram bridge failed:" in cli07["stderr"]
    )
    if not cli07_record["naturalLanguageOk"]:
        findings.append(
            {
                "id": "F-CLI07",
                "channel": "cli",
                "caseId": "CLI07",
                "site": cli07_record["raiseSite"],
                "issue": "共同判据 4：CLI 失败句子内嵌原始操作系统消息（Errno 文本），缺少明确可行下一步",
                "offendingText": (cli07["stderr"] or cli07["message"])[:400],
            }
        )
    checks["CLI07MessageCompliant"] = cli07_record["naturalLanguageOk"]

    # ---------------- Wolfram 通道 ----------------
    wolfram_summary, wolfram_stdout, wolfram_returncode = run_wolfram_channel()
    wm_cases = wolfram_summary.get("cases", {})
    wm_stubs = wolfram_summary.get("stubs", {})
    wm_real = wolfram_summary.get("real", {})
    wm_templates = wolfram_summary.get("templates", {})

    expected_cheap_tags = {
        "nonRational": "NonRationalMatrixEntry",
        "inexact": "InexactRationalMatrixEntry",
        "nonSquare": "SquareMatrixRequired",
        "badLanguage": "InvalidMessageLanguage",
        "badModeString": "InvalidSingularityMode",
        "badModeType": "InvalidSingularityMode",
        "unknownOption": "UnknownOption",
        "badPythonType": "InvalidPythonExecutable",
        "badWorkDirType": "InvalidWorkDirectory",
        "pathTooLong": "RuntimePathTooLong",
        "workDirWriteBlocked": "RuntimeInputWriteFailed",
        "launchFailed": "BridgeLaunchFailed",
        "invalidPlanAssoc": "InvalidExecutionPlan",
        "precisionMissing": "PlannedPathPrecisionMissing",
        "epBatchEmpty": "EpJobListEmpty",
        "epJobMissing": "InvalidEpJob",
        "parallelCount": "ParallelTaskCountPositiveIntegerRequired",
        "invalidPlanArguments": "InvalidPlanArguments",
        "invalidSystemArguments": "InvalidRationalSystemArguments",
        "pfNonList": "InvalidPartialFractionSystemArguments",
        "pfDimensions": "ConsistentSquareMatricesRequired",
        "pfPoleMismatch": "PoleResidueLengthMismatch",
        "pfArguments": "InvalidPartialFractionSystemArguments",
        "executeArguments": "InvalidExecuteArguments",
        "epBatchArguments": "InvalidEpBatchArguments",
    }
    expected_stub_tags = {
        "flintMissing": "PythonFlintUnavailable",
        "noOutput": "BridgeOutputMissing",
        "exitNonzero": "BridgeLaunchFailed",
        "badOutput": "BridgeOutputInvalid",
        "symbolOutput": "InvalidBridgeResult",
        "errorStatus": "BridgeFailure",
    }
    observed_wolfram_tags: set[str] = set()
    wolfram_case_rows: list[dict[str, Any]] = []
    usage_only_failures: list[tuple[str, str]] = []
    wolfram_tag_inventory = inventory_wolfram_failure_tags()

    def register_wolfram_failure(
        case_id: str, category: str, record: dict[str, Any], expected_tag: str | None
    ) -> None:
        """登记一个 Wolfram Failure case，校验 tag 与双语 MessageTemplate 质量。"""

        tag = record.get("tag")
        if isinstance(tag, str) and tag:
            observed_wolfram_tags.add(tag)
        template = record.get("messageTemplate")
        template_ok = template not in (None, "None", "")
        row = {
            "id": case_id,
            "channel": "wolfram",
            "category": category,
            "isFailure": record.get("isFailure"),
            "tag": tag,
            "keys": record.get("keys", []),
            "messageTemplate": template if template_ok else None,
            "message": record.get("message"),
            "status": record.get("status"),
        }
        sentence = template if template_ok else record.get("message")
        if not template_ok and record.get("tag") == "BridgeFailure":
            # BridgeFailure 的用户句子是 stdout 上的 FlintNDEBridgeError::error 模板。
            sentence = wm_templates.get("error")
        row["naturalLanguageOk"] = natural_language_ok(sentence)
        row["noFalseSuccess"] = record.get("isFailure") is True
        wolfram_case_rows.append(row)
        if expected_tag is None:
            checks[f"{case_id}Failure"] = bool(record.get("isFailure"))
        else:
            checks[f"{case_id}Failure"] = (
                record.get("isFailure") is True and tag == expected_tag
            )
        if template_ok:
            checks[f"{case_id}TemplateBilingual"] = (
                has_cjk(template)
                and bool(re.search(r"[A-Za-z]{4}", template))
                and natural_language_ok(template)
            )
        elif record.get("isFailure") is True and "usage" in record.get("keys", []):
            usage_only_failures.append((case_id, tag))
            # 任务书要求：消息不合规的 case 记为失败（不改源，只标记）。
            checks[f"{case_id}MessageCompliant"] = False

    category_map = {
        "nonRational": "input-type", "inexact": "input-type",
        "nonSquare": "dimension", "badLanguage": "input-type",
        "badModeString": "input-type", "badModeType": "input-type",
        "unknownOption": "unsupported-capability", "badPythonType": "input-type",
        "badWorkDirType": "input-type", "pathTooLong": "file-write",
        "workDirWriteBlocked": "file-write", "launchFailed": "file-write",
        "invalidPlanAssoc": "serialization", "precisionMissing": "precision",
        "epBatchEmpty": "input-type", "epJobMissing": "input-type",
        "parallelCount": "input-type", "invalidPlanArguments": "input-type",
        "invalidSystemArguments": "input-type", "pfNonList": "input-type",
        "pfDimensions": "dimension", "pfPoleMismatch": "dimension",
        "pfArguments": "input-type", "executeArguments": "input-type",
        "epBatchArguments": "input-type",
        "flintMissing": "unsupported-capability", "noOutput": "file-write",
        "exitNonzero": "file-write", "badOutput": "serialization",
        "symbolOutput": "serialization", "errorStatus": "unsupported-capability",
    }
    for case_id, expected_tag in expected_cheap_tags.items():
        register_wolfram_failure(
            f"WM-{case_id}", category_map[case_id], wm_cases.get(case_id, {}), expected_tag
        )
    for case_id, expected_tag in expected_stub_tags.items():
        register_wolfram_failure(
            f"WM-stub-{case_id}", category_map[case_id], wm_stubs.get(case_id, {}), expected_tag
        )
    if usage_only_failures:
        findings.append(
            {
                "id": "F-WM-usage-only",
                "channel": "wolfram",
                "caseId": ", ".join(case_id for case_id, _tag in usage_only_failures),
                "site": "; ".join(
                    wolfram_tag_inventory.get(tag, "Mathematica/FlintNDE.wl:?")
                    for _case_id, tag in usage_only_failures
                ),
                "issue": "共同判据 4：参数形态 catch-all Failure 只带 usage 字段（正确调用形态提示），"
                "没有解释原因的完整自然语言句子",
                "offendingText": "; ".join(
                    f"{tag}: usage-only" for _case_id, tag in usage_only_failures
                ),
            }
        )

    # WorkDirectoryCreationFailed 尝试：接受两种运行目录写失败 tag，按实际观察归类。
    workdir_attempt = wm_cases.get("workDirCreationBadName", {})
    register_wolfram_failure("WM-workDirCreationBadName", "file-write", workdir_attempt, None)
    checks["wmWorkDirCreationAttempt"] = workdir_attempt.get("isFailure") is True and (
        workdir_attempt.get("tag")
        in {"WorkDirectoryCreationFailed", "RuntimeInputWriteFailed"}
    )
    if workdir_attempt.get("tag") == "WorkDirectoryCreationFailed":
        observed_wolfram_tags.add("WorkDirectoryCreationFailed")

    # 真实后端：拒绝、60 位规划、精度门禁 CN/EN、ep 批处理拒绝。
    refused_cn = wm_real.get("refusedCN", {})
    refused_en = wm_real.get("refusedEN", {})
    for case_id, record, language in (
        ("WM-refusedCN", refused_cn, "CN"), ("WM-refusedEN", refused_en, "EN")
    ):
        wolfram_case_rows.append({
            "id": case_id, "channel": "wolfram", "category": "singularity",
            "isFailure": record.get("isFailure"),
            "status": record.get("status"),
            "message": record.get("message"),
            "messageLanguage": record.get("messageLanguage"),
            "naturalLanguageOk": natural_language_ok(record.get("message")),
            "noFalseSuccess": record.get("status") == "singularPathRefused",
        })
    checks["wmRefusalsMachineDecidable"] = (
        refused_cn.get("status") == "singularPathRefused"
        and refused_en.get("status") == "singularPathRefused"
        and refused_cn.get("messageLanguage") == "CN"
        and refused_en.get("messageLanguage") == "EN"
        and natural_language_ok(refused_en.get("message"))
    )
    if isinstance(refused_cn.get("message"), str) and not has_cjk(refused_cn["message"]):
        findings.append(
            {
                "id": "F-WM-refusedCN",
                "channel": "wolfram",
                "caseId": "WM-refusedCN",
                "site": find_source_line(
                    "flintnde/singularity_jump.py",
                    'f"user point {waypoint_index} coincides with pole',
                ),
                "issue": "Validation-06 第 3 条：messageLanguage=CN 的 singularPathRefused 消息为英文（SingularPathError 消息不随 message_language 切换）",
                "offendingText": refused_cn["message"][:400],
            }
        )
        checks["WM-refusedCNMessageCompliant"] = False
    checks["WM-refusedENMessageCompliant"] = natural_language_ok(refused_en.get("message"))

    plan60 = wm_real.get("plan60", {})
    checks["wmPlan60Complete"] = plan60.get("status") == "complete"
    precision_cn = wm_real.get("precisionCN", {})
    precision_en = wm_real.get("precisionEN", {})
    for record in (precision_cn, precision_en):
        tag = record.get("tag")
        if isinstance(tag, str) and tag:
            observed_wolfram_tags.add(tag)
    wolfram_case_rows.append({
        "id": "WM-precisionCN", "channel": "wolfram", "category": "precision",
        "isFailure": precision_cn.get("isFailure"),
        "tag": precision_cn.get("tag"),
        "message": precision_cn.get("message"),
        "messageLanguage": precision_cn.get("messageLanguage"),
        "naturalLanguageOk": natural_language_ok(precision_cn.get("message")),
        "noFalseSuccess": precision_cn.get("isFailure") is True,
    })
    wolfram_case_rows.append({
        "id": "WM-precisionEN", "channel": "wolfram", "category": "precision",
        "isFailure": precision_en.get("isFailure"),
        "tag": precision_en.get("tag"),
        "message": precision_en.get("message"),
        "messageLanguage": precision_en.get("messageLanguage"),
        "naturalLanguageOk": natural_language_ok(precision_en.get("message")),
        "noFalseSuccess": precision_en.get("isFailure") is True,
    })
    checks["wmPrecisionGateBilingual"] = (
        wolfram_returncode == 0
        and precision_cn.get("isFailure") is True
        and precision_cn.get("tag") == "PlannedPathPrecisionInsufficient"
        and precision_cn.get("messageLanguage") == "CN"
        and has_cjk(precision_cn.get("message"))
        and natural_language_ok(precision_cn.get("message"))
        and precision_en.get("isFailure") is True
        and precision_en.get("tag") == "PlannedPathPrecisionInsufficient"
        and precision_en.get("messageLanguage") == "EN"
        and not has_cjk(precision_en.get("message"))
        and "rerun FlintNDEPlanPath" in str(precision_en.get("message"))
        and natural_language_ok(precision_en.get("message"))
    )

    ep_batch = wm_real.get("epBatchRefused", {})
    wolfram_case_rows.append({
        "id": "WM-epBatchRefused", "channel": "wolfram", "category": "singularity",
        "status": ep_batch.get("status"),
        "epFirstStatus": ep_batch.get("epFirstStatus"),
        "epFirstPlanStatus": ep_batch.get("epFirstPlanStatus"),
        "message": ep_batch.get("epFirstPlanMessage"),
        "naturalLanguageOk": natural_language_ok(ep_batch.get("epFirstPlanMessage")),
        "noFalseSuccess": ep_batch.get("epFirstStatus") == "planFailed",
    })
    checks["wmEpBatchRefusedNoFalseSuccess"] = (
        ep_batch.get("status") == "complete"
        and ep_batch.get("epFirstStatus") == "planFailed"
        and ep_batch.get("epFirstPlanStatus") == "singularPathRefused"
        and natural_language_ok(ep_batch.get("epFirstPlanMessage"))
    )

    # Message 模板：四个 FlintNDEBridgeError 模板均双语，且 stub case 让模板真实发到 stdout。
    template_names = ("error", "pythonFlintMissing", "launchFailed", "outputMissing")
    checks["wmMessageTemplatesBilingual"] = all(
        has_cjk(wm_templates.get(name)) and natural_language_ok(wm_templates.get(name))
        for name in template_names
    ) and all(
        wolfram_summary.get("templateCjk", {}).get(name) is True
        for name in template_names
    )
    checks["wmMessageTemplatesEmitted"] = all(
        f"FlintNDEBridgeError::{name}" in wolfram_stdout for name in template_names
    )
    checks["wmPlanningNoticePrinted"] = "FlintNDEPlanPath" in wolfram_stdout
    checks["wolframRunnerLocalOutput"] = (
        wolfram_returncode == 0
        and bool(wolfram_summary)
        and (TEMP_ROOT / "wolfram" / "wolfram_summary.json").exists()
    )

    # ---------------- 公开 CLI 存在性核实与 unittest 套件 ----------------
    cli_presence = inspect_public_cli()
    checks["noPublicConsoleScriptCli"] = not cli_presence["publicCliExists"]
    unittest_result = run_unittest_suite()
    checks["unittestSuiteOk"] = bool(unittest_result["ok"])
    checks["unittestCountMatchesExpected181"] = unittest_result["testsRun"] == 181

    # ---------------- 公开提醒出口矩阵 ----------------
    matrix_rows: list[dict[str, str]] = []
    for tag, site in sorted(wolfram_tag_inventory.items()):
        dynamic = tag in observed_wolfram_tags
        matrix_rows.append({
            "section": "wolframFailureTag",
            "name": tag,
            "site": site,
            "classification": "dynamic" if dynamic else "static-only",
        })
    template_inventory = inventory_wolfram_message_templates()
    for name, site in sorted(template_inventory.items()):
        dynamic = name in wolfram_stdout
        matrix_rows.append({
            "section": "wolframMessageTemplate",
            "name": name,
            "site": site,
            "classification": "dynamic" if dynamic else "static-only",
        })
    dynamic_warning_sites = {notice_site}
    for site, _line in inventory_python_warning_sites():
        matrix_rows.append({
            "section": "pythonWarningSite",
            "name": "warnings.warn",
            "site": site,
            "classification": "dynamic" if site in dynamic_warning_sites else "static-only",
        })
    dynamic_raise_sites: dict[str, str] = {}
    for record in triggers:
        site = record.get("raiseSite")
        if record["channel"] == "python" and site and site != "?":
            module = site.split(":", 1)[0]
            relative = f"flintnde/{module}"
            if (VERSION_ROOT / relative).exists():
                dynamic_raise_sites.setdefault(site, record["id"])
    cli_static_sites = {
        "CLI01/CLI02": find_source_line(
            "flintnde/mathematica_bridge.py", "unsupported bridge request schema"
        ),
        "CLI07": find_source_line(
            "flintnde/mathematica_bridge.py", "The FlintNDE Wolfram bridge failed"
        ),
    }
    for site, case_id in sorted(dynamic_raise_sites.items()):
        matrix_rows.append({
            "section": "pythonRaiseSite",
            "name": case_id,
            "site": f"flintnde/{site}",
            "classification": "dynamic",
        })
    for label, site in sorted(cli_static_sites.items()):
        if not any(row["site"] == site and row["section"] == "pythonRaiseSite" for row in matrix_rows):
            matrix_rows.append({
                "section": "pythonRaiseSite",
                "name": label,
                "site": site,
                "classification": "dynamic",
            })
    cannot_trigger = [
        (
            "Mathematica/FlintNDE.wl",
            '$OperatingSystem =!= "Windows"',
            "路径长度门禁的非 Windows 分支：本机为 Windows，只读验证无法切换操作系统",
        ),
        (
            "flintnde/routing.py",
            "generated path violates max_step_over_radius",
            "规划器内部不变量：公开输入无法在不修改源码的情况下构造违例路径",
        ),
        (
            "flintnde/mathematica_bridge.py",
            "cannot serialize bridge result value of type",
            "序列化器内部守卫：公开 schema 请求产生的结果均为 JSON 型，无法安全触达",
        ),
        (
            "flintnde/savepoints.py",
            "target.write_text(",
            "savepoint 写盘时磁盘满/权限中途丢失：无法在本机安全模拟磁盘满",
        ),
    ]
    for relative, needle, reason in cannot_trigger:
        matrix_rows.append({
            "section": "cannotSafelyTrigger",
            "name": reason,
            "site": find_source_line(relative, needle),
            "classification": "cannot-safely-trigger",
        })
    dynamic_count = sum(row["classification"] == "dynamic" for row in matrix_rows)
    static_only_count = sum(row["classification"] == "static-only" for row in matrix_rows)
    cannot_count = sum(row["classification"] == "cannot-safely-trigger" for row in matrix_rows)
    # 结构性完整判据（无数值阈值）：五个 section 均非空、每类计数非零、
    # 全部站点均已解析出具体行号（无 ":?"）。
    checks["exitMatrixComplete"] = (
        all(
            any(row["section"] == section for row in matrix_rows)
            for section in (
                "wolframFailureTag", "wolframMessageTemplate",
                "pythonWarningSite", "pythonRaiseSite", "cannotSafelyTrigger",
            )
        )
        and dynamic_count >= 1
        and static_only_count >= 1
        and cannot_count >= 1
        and all(
            row["site"].rpartition(":")[2].isdigit() for row in matrix_rows
        )
    )

    # ---------------- summary 与报告 ----------------
    elapsed = time.perf_counter() - started
    checks = {name: bool(value) for name, value in checks.items()}
    passed_count = sum(value is True for value in checks.values())
    status = "passed" if passed_count == len(checks) else "failed"
    digest = source_digest()
    summary = {
        "schema": SUMMARY_SCHEMA,
        "status": status,
        "passedCount": passed_count,
        "checkCount": len(checks),
        "sourceDigestSHA256": digest,
        "settings": {
            "workingPrecisionDigits": 90,
            "guardBits": 50,
            "wolframPlanningDigits": 60,
            "wolframExecutionDigitsRequested": 90,
            "cliOrder": [sys.executable, "-m", "flintnde.mathematica_bridge"],
            "mathematicaExecutable": str(WOLFRAM_EXE),
            "packageVersion": wolfram_summary.get("packageVersion"),
        },
        "exitMatrix": {
            "counts": {
                "dynamic": dynamic_count,
                "staticOnly": static_only_count,
                "cannotSafelyTrigger": cannot_count,
            },
            "rows": matrix_rows,
        },
        "triggers": triggers,
        "wolframCases": wolfram_case_rows,
        "wolframMessageTemplates": wm_templates,
        "cli": {case_id: cli_records[case_id] for case_id in sorted(cli_records)},
        "cliPresence": cli_presence,
        "unittest": unittest_result,
        "findings": findings,
        "checks": checks,
        "wallTimeSeconds": elapsed,
    }
    (RESULTS_ROOT / "summary.json").write_text(
        json.dumps(summary, ensure_ascii=False, indent=2) + "\n",
        encoding="utf-8",
        newline="\n",
    )

    def trigger_table(channel: str) -> list[str]:
        rows = [
            "| case | 类别 | 类型/tag/status | 站点 | NL 句子 |",
            "| --- | --- | --- | --- | --- |",
        ]
        for record in triggers:
            if record["channel"] != channel:
                continue
            kind = record.get("exceptionType") or record.get("status") or ""
            rows.append(
                f"| {record['id']} | {record['category']} | `{kind}` | "
                f"{record.get('raiseSite') or '-'} | "
                f"{'yes' if record.get('naturalLanguageOk') else 'NO'} |"
            )
        for record in wolfram_case_rows:
            if channel != "wolfram":
                continue
            kind = record.get("tag") or record.get("status") or ""
            rows.append(
                f"| {record['id']} | {record['category']} | `{kind}` | "
                f"Mathematica/FlintNDE.wl（见出口矩阵） | "
                f"{'yes' if record.get('naturalLanguageOk') else 'NO'} |"
            )
        return rows

    matrix_sections = ("wolframFailureTag", "wolframMessageTemplate", "pythonWarningSite", "pythonRaiseSite", "cannotSafelyTrigger")
    matrix_lines: list[str] = []
    for section in matrix_sections:
        rows = [row for row in matrix_rows if row["section"] == section]
        matrix_lines.append(f"### {section}（{len(rows)} 行）")
        matrix_lines.append("")
        matrix_lines.append("| 名称 | 站点 | 归类 |")
        matrix_lines.append("| --- | --- | --- |")
        for row in rows:
            matrix_lines.append(f"| {row['name']} | `{row['site']}` | {row['classification']} |")
        matrix_lines.append("")

    failed = [name for name, value in checks.items() if value is not True]
    finding_lines = []
    if findings:
        for item in findings:
            finding_lines.append(
                f"- **{item['id']}**（{item['channel']} / {item['caseId']}，站点 `{item['site']}`）：{item['issue']}。"
            )
            finding_lines.append(f"  - 原文：`{item['offendingText'][:200]}`")
    else:
        finding_lines.append("- 无。全部动态触发的用户句子均为含原因与下一步的完整自然语言句子。")

    static_warning_rows = [
        row for row in matrix_rows
        if row["section"] == "pythonWarningSite" and row["classification"] == "static-only"
    ]
    static_tag_rows = [
        row for row in matrix_rows
        if row["section"] == "wolframFailureTag" and row["classification"] == "static-only"
    ]
    report = "\n".join(
        [
            "# FlintNDE 0.5.0 Validation-06 独立报告：公开反馈与异常语言",
            "",
            f"- 状态：**{status}**，硬 check {passed_count}/{len(checks)} 通过。",
            f"- 被测源码聚合 SHA-256（flintnde/*.py + Mathematica/FlintNDE.wl）：`{digest}`。",
            f"- Wolfram 程序包版本：`{wolfram_summary.get('packageVersion')}`；math.exe：`{WOLFRAM_EXE}`。",
            f"- 工作精度/守卫位（Python 通道）：`90 / 50`；Wolfram 规划精度 `60`，执行门禁请求 `90`。",
            f"- unittest 套件（版本目录 `python -m unittest discover -s tests -t tests` 运行一次）："
            f"`Ran {unittest_result['testsRun']} tests`，OK=`{unittest_result['ok']}`（任务书预期 181）。",
            f"- 公开 CLI：**{cli_presence['statement']}**——pyproject.toml 无 "
            f"`[project.scripts]`/`[project.gui-scripts]`（{cli_presence['consoleScripts'] or '空'} / "
            f"{cli_presence['guiScripts'] or '空'}），无 `flintnde/__main__.py`"
            f"（hasMainModule=`{cli_presence['hasMainModule']}`）。CLI 通道按任务书标记"
            "“not applicable / no public CLI”，实际以桥接模块命令行 "
            "`python -m flintnde.mathematica_bridge <request.json> <output.m>` 作为公开命令行入口验证。",
            f"- 总 wall time：`{elapsed:.3f} s`。",
            f"- 出口矩阵计数：动态触发 `{dynamic_count}`，仅静态审阅 `{static_only_count}`，无法安全触发 `{cannot_count}`；后两类不计为动态通过。",
            f"- findings（记录不改源）：`{len(findings)}` 条，见下文。",
            "",
            "## 方法与范围",
            "",
            "- 三个公开通道全部真实执行并捕获：Python API 直接调用；CLI 用 "
            "`python -m flintnde.mathematica_bridge <req.json> <out.m>` 喂入坏请求；"
            "Wolfram 通道由 math.exe -noprompt -script 执行 ASCII-only 包装脚本 "
            "`results_temp/wolfram/run_wolfram_channel.wls`（stub 解释器运行时重建于 results_temp）。",
            "- 每项触发记录异常类型 / Failure tag / status+reason（机器可判定未变）、中英文用户句子、"
            "raise 站点 file:line，以及 naturalLanguageOk（完整自然语言句子、含具体原因与可行下一步、"
            "非黑话、非原始 `<|...|>` 转储）。",
            "- 失败后未继续输运/未写假成功：Python 通道以异常传播为准（无返回值）；CLI 以 "
            "`status -> \"error\"` 关联 + 退出码 1 为准；Wolfram 以 `Failure[...]` 头或 "
            "`singularPathRefused`/`planFailed` status 为准；精度门禁在启动输运前返回。",
            "- 本 case 不运行数值输运，不产生数值点/逐分量误差；数值一致性由 Validation-01~05 覆盖。",
            "",
            "## Python 通道（PY01-PY15，无 PY12）",
            "",
            *trigger_table("python"),
            "",
            "## CLI 通道（CLI01-CLI07）",
            "",
            f"- 公开 console-script CLI：**{cli_presence['statement']}**。以下 case 通过桥接模块"
            "命令行 `python -m flintnde.mathematica_bridge <request.json> <output.m>` 动态触发。",
            "",
            *trigger_table("cli"),
            "",
            "## Wolfram 通道",
            "",
            *trigger_table("wolfram"),
            "",
            f"- 四个 `FlintNDEBridgeError` Message 模板均为中英双语完整句子，且 stub case 使 "
            f"`::error/::pythonFlintMissing/::launchFailed/::outputMissing` 全部真实发送到会话输出。",
            f"- 精度门禁 `PlannedPathPrecisionInsufficient` 在 CN 与 EN 下均返回 Failure，"
            f"消息分别为完整中文/英文句子（验收第 2 条）。",
            "",
            "## 公开提醒出口矩阵",
            "",
            f"- 计数：动态触发 `{dynamic_count}`；仅静态审阅 `{static_only_count}`；无法安全触发 `{cannot_count}`。",
            "",
            *matrix_lines,
            "",
            "## Findings（记录，不修改源码）",
            "",
            *finding_lines,
            "",
            "- 按任务书要求，上述每条 finding 对应的 case 均以失败硬 check"
            "（`*MessageCompliant` 系列，见 summary.checks）标记为 failed；源码未被修改。"
            if findings
            else "- 无 finding，全部消息合规 case 的 `*MessageCompliant` 硬 check 均通过。",
            "",
            "## 未执行边界",
            "",
            f"- 仅静态审阅的 Wolfram Failure tag（{len(static_tag_rows)} 个）："
            + (", ".join(row["name"] for row in static_tag_rows) if static_tag_rows else "无")
            + "。",
            f"- `PolynomialMatrixListRequired`（`{find_source_line('Mathematica/FlintNDE.wl', 'PolynomialMatrixListRequired')}`）"
            "为防御性分支：公开入口的 `_List /; flintNDEPolynomialMatricesQ` guard 使非矩阵列表输入"
            "实际落入 catch-all `InvalidPartialFractionSystemArguments`，公开调用形态无法到达该分支。",
            f"- 仅静态审阅的 Python warnings.warn 出口（{len(static_warning_rows)} 个）：位于数值输运/"
            "正规化/奇点折跃深层流程，需要长时数值运行或内部状态才能到达，本 case 不动态触发。",
            "- 无法安全触发项见出口矩阵 cannotSafelyTrigger 段（非 Windows 分支、内部不变量、"
            "序列化器守卫、磁盘满写盘失败）。",
            "- Wolfram 公开面没有 savepoint 落盘入口，savepoint 错误类别仅由 Python 通道（PY10）覆盖。",
            "- flintnde/*.py 中数百处内部 raise 守卫不在逐项动态触发范围内；矩阵覆盖三通道公开出口"
            "与九类代表性错误（输入类型、维数、精度、路径、奇点、savepoint、unsupported capability、"
            "序列化、文件写出）。",
            f"- 失败硬 check：`{failed if failed else '无'}`。",
            "- 机器 summary：`results/summary.json`；Wolfram 会话日志：`results_temp/wolfram-stdout.log`。",
            "",
        ]
    )
    REPORT_PATH.write_text(report, encoding="utf-8", newline="\n")
    print(
        f"FlintNDE Validation-06: {passed_count}/{len(checks)} checks passed, "
        f"matrix dynamic/static-only/cannot-trigger = "
        f"{dynamic_count}/{static_only_count}/{cannot_count}, findings = {len(findings)}"
    )
    if failed:
        print(f"failed checks: {failed}")
    return 0 if status == "passed" else 1


if __name__ == "__main__":
    raise SystemExit(main())
