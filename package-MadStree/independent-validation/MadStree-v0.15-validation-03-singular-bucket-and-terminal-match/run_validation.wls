(* ::Package:: *)

(***
文件：run_validation.wls
用途：从空结果目录运行 MadStree v0.15 Automatic 奇点双侧 bucket、末端隐藏匹配点与
      fail-closed 反例的独立验证，并自动生成 summary.wl 和 Markdown 报告。
输入：无命令行参数；数值证据由同目录 run_validation.py 生成。
输出：results/summary.wl、results/evidence.json 和 000_MadStree-v0.15-validation-03-report.md。
***)

$CharacterEncoding = "UTF-8";


(* ::Chapter:: *)
(*路径与 fresh 输出*)

caseRoot = DirectoryName[$InputFileName];
packageRoot = DirectoryName[DirectoryName[caseRoot]];
versionRoot = FileNameJoin[{packageRoot, "versions", "MadStree-v0.15"}];
resultsRoot = FileNameJoin[{caseRoot, "results"}];
tempRoot = FileNameJoin[{caseRoot, "results_temp"}];
reportPath = FileNameJoin[{caseRoot, "000_MadStree-v0.15-validation-03-report.md"}];
summaryPath = FileNameJoin[{resultsRoot, "summary.wl"}];
evidencePath = FileNameJoin[{resultsRoot, "evidence.json"}];
pythonScript = FileNameJoin[{caseRoot, "run_validation.py"}];

Scan[
  If[DirectoryQ[#], DeleteDirectory[#, DeleteContents -> True]] &,
  {resultsRoot, tempRoot}
];
If[FileExistsQ[reportPath], DeleteFile[reportPath]];
CreateDirectory[resultsRoot, CreateIntermediateDirectories -> True];
CreateDirectory[tempRoot, CreateIntermediateDirectories -> True];


(* ::Chapter:: *)
(*加载当前版本并核对 Automatic 映射*)

AppendTo[$Path, FileNameJoin[{versionRoot, "Kernel"}]];
Needs["MadStree`"];

versionLoadedQ = NameQ["MadStree`Private`$MadStreeVersion"] &&
  MadStree`Private`$MadStreeVersion === "0.15";
automaticDefaultQ = MemberQ[Options[MSEvaluatePath], SingularityMode -> "Automatic"];
automaticBackendModeQ =
  MadStree`Private`msBackendSingularityMode["Automatic"] === "singularity_jump";


(* ::Chapter:: *)
(*运行独立 Python 数值证据*)

pythonArgumentCandidates = Select[
  $ScriptCommandLine,
  StringQ[#] && FileExistsQ[#] &&
    MemberQ[{"python", "python.exe"}, ToLowerCase[FileNameTake[#]]] &
];
pythonEnvironment = Environment["FLINTNDE_PYTHON"];
pythonExecutable = Which[
  pythonArgumentCandidates =!= {}, First[pythonArgumentCandidates],
  StringQ[pythonEnvironment] && FileExistsQ[pythonEnvironment], pythonEnvironment,
  True, FindExecutable["python"]
];
process = If[
  StringQ[pythonExecutable],
  RunProcess[{pythonExecutable, pythonScript}, All, ProcessDirectory -> caseRoot],
  <|"ExitCode" -> -1, "StandardOutput" -> "", "StandardError" -> "python executable not found"|>
];
processExitCode = Lookup[process, "ExitCode", -1];
evidence = If[
  processExitCode === 0 && FileExistsQ[evidencePath],
  Import[evidencePath, "RawJSON", CharacterEncoding -> "UTF-8"],
  <|
    "status" -> "failed",
    "pythonPassed" -> 0,
    "pythonTotal" -> 1,
    "checks" -> <|"pythonEvidenceGenerated" -> False|>,
    "sourceRoot" -> versionRoot,
    "sourceDigestSha256" -> "unavailable",
    "actualNodes" -> {},
    "pointValues" -> {},
    "singularityClassifications" -> {},
    "timingSeconds" -> <||>,
    "maximumRelativeErrors" -> <||>,
    "terminalSingularMatch" -> <||>,
    "negativeStatuses" -> <||>
  |>
];


(* ::Chapter:: *)
(*汇总门禁与机器结果*)

pythonChecks = Association[Lookup[evidence, "checks", <||>]];
checks = Join[
  pythonChecks,
  <|
    "versionLoaded" -> versionLoadedQ,
    "automaticIsPublicDefault" -> automaticDefaultQ,
    "automaticMapsToFlintNDEJump" -> automaticBackendModeQ,
    "pythonProcessExitedZero" -> (processExitCode === 0)
  |>
];
passed = Count[Values[checks], True];
total = Length[checks];
status = If[passed === total, "passed", "failed"];

summary = Join[
  KeyDrop[evidence, {"checks"}],
  <|
    "schema" -> "madstree_v0_15_validation_03_summary_v1",
    "status" -> status,
    "passed" -> passed,
    "total" -> total,
    "wolframChecks" -> <|
      "versionLoaded" -> versionLoadedQ,
      "automaticIsPublicDefault" -> automaticDefaultQ,
      "automaticMapsToFlintNDEJump" -> automaticBackendModeQ
    |>,
    "checks" -> checks,
    "pythonProcess" -> <|
      "exitCode" -> processExitCode,
      "stdout" -> Lookup[process, "StandardOutput", ""],
      "stderr" -> Lookup[process, "StandardError", ""]
    |>,
    "outputs" -> <|
      "summary" -> summaryPath,
      "evidence" -> evidencePath,
      "report" -> reportPath
    |>
  |>
];

summaryStream = OpenWrite[summaryPath, CharacterEncoding -> "UTF-8"];
Put[summary, summaryStream];
Close[summaryStream];


(* ::Chapter:: *)
(*自包含 Markdown 报告*)

nodeLines = If[
  Lookup[summary, "actualNodes", {}] === {},
  "- 未执行",
  StringRiffle[
    MapIndexed[
      "- `" <> ToString[First[#2] - 1] <> "`: `" <>
        ToString[InputForm[#1]] <> "`" &,
      summary["actualNodes"]
    ],
    "\n"
  ]
];
classificationText = ToString[InputForm[Lookup[summary, "singularityClassifications", {}]]];
terminalText = ToString[InputForm[Lookup[summary, "terminalSingularMatch", <||>]]];
negativeText = ToString[InputForm[Lookup[summary, "negativeStatuses", <||>]]];
timing = Lookup[summary, "timingSeconds", <||>];
errors = Lookup[summary, "maximumRelativeErrors", <||>];

reportText = StringRiffle[{
  "# MadStree v0.15 Validation-03 独立报告",
  "",
  "- 状态：**" <> status <> "**，" <> ToString[passed] <> "/" <> ToString[total] <> "。",
  "- 源码：`" <> Lookup[summary, "sourceRoot", versionRoot] <> "`",
  "- Adapter+Vendor 聚合 SHA-256：`" <> Lookup[summary, "sourceDigestSha256", "unavailable"] <> "`",
  "- convention：`" <> Lookup[summary, "convention", "未执行"] <> "`",
  "",
  "## 数值点与实际路径",
  "",
  "闭式系统：`" <> Lookup[summary, "system", "未执行"] <> "`。输入 pointSequence：`" <>
    ToString[InputForm[Lookup[summary, "pointSequenceExact", {}]]] <> "`。",
  "",
  "实际普通节点：",
  "",
  nodeLines,
  "",
  "奇点分类表：`" <> classificationText <> "`。",
  "",
  "## 展开、精度与计时",
  "",
  "- 主阶/参考阶：`" <> ToString[InputForm[Lookup[summary, "orders", <||>]]] <> "`；高阶只作核验。",
  "- 工作精度：" <> ToString[Lookup[summary, "workingPrecisionDigits", "未执行"]] <>
    " decimal digits；目标相对误差：`" <> Lookup[summary, "targetRelativeError", "未执行"] <> "`。",
  "- planned adapter wall time：" <> ToString[Lookup[timing, "plannedAdapter", "未执行"]] <> " s。",
  "- naive 逐点 adapter wall time：" <> ToString[Lookup[timing, "naivePointwiseAdapter", "未执行"]] <> " s。",
  "- naive/planned：" <> ToString[Lookup[timing, "naiveOverPlanned", "未执行"]] <> "。",
  "- planned/闭式、naive/闭式、planned/naive 最大相对误差：`" <>
    ToString[InputForm[errors]] <> "`。",
  "",
  "## 末端奇点与反例",
  "",
  "末端隐藏匹配计划：`" <> terminalText <> "`。低阶主链输出用户值，高阶参考链只检查分类和有限值误差。",
  "",
  "反例状态：`" <> negativeText <> "`。关闭规划后的中间奇点、必须插入隐藏点的末端奇点以及奇点处非共线转向均明确失败。",
  "",
  "## 结论与边界",
  "",
  "本 case 同时核对了 MadStree 公开缺省 Automatic、到 FlintNDE singularity_jump 的实际映射、双侧局部 bucket、Infinity 文本、原始 userIndex、后续普通点和末端隐藏匹配。一般 blow-up、连续奇点、未认证局部基和缺 Stokes 数据不在本报告认证范围内。",
  "",
  "机器结果：`" <> summaryPath <> "`；Python 数值证据：`" <> evidencePath <> "`。"
}, "\n"];

(* Windows 的 wolframscript 可能在执行本文件前按单字节读取 UTF-8；仅在整份报告仍是
   单字节码点时恢复原字节，已正确解码的中文报告保持不变。 *)
reportCodePoints = ToCharacterCode[reportText];
If[reportCodePoints =!= {} && Max[reportCodePoints] <= 255,
  reportText = FromCharacterCode[
    ToCharacterCode[reportText, "ISO8859-1"],
    "UTF8"
  ]
];

Export[reportPath, reportText, "Text", CharacterEncoding -> "UTF-8"];

Print["MadStree Validation-03 ", status, ": ", passed, "/", total];
Print["Python: ", Lookup[process, "StandardOutput", ""]];
If[status =!= "passed", Print["Python stderr: ", Lookup[process, "StandardError", ""]]; Exit[1]];
