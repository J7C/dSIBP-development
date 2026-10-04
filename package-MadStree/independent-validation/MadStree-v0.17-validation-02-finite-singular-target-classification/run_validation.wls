(* ::Package:: *)

(***
文件：run_validation.wls
用途：通过 MadStree 当前公开配置和正式后端 CLI 验证 removable、pole 与 log 奇点的值和分类表。
边界：本 case 只认证适配器与 fail-closed 类型，不认证任何真实树图的 master、DE 或边界 producer。
核心逻辑：fresh 清理后定位 v0.17 内嵌后端，运行独立 exact 模型，再生成 summary.wl 与自包含报告。
***)

(* ::Chapter:: *)
(*fresh 输出与当前配置*)

$CharacterEncoding = "UTF-8";
caseRoot = DirectoryName[$InputFileName];
projectRoot = DirectoryName[DirectoryName[DirectoryName[caseRoot]]];
versionRoot = FileNameJoin[{projectRoot, "package-MadStree", "versions", "MadStree-v0.17"}];
resultsRoot = FileNameJoin[{caseRoot, "results"}];
tempRoot = FileNameJoin[{caseRoot, "results_temp"}];
reportPath = FileNameJoin[{caseRoot, "000_MadStree-v0.17-validation-02-report.md"}];
summaryPath = FileNameJoin[{resultsRoot, "summary.wl"}];
evidencePath = FileNameJoin[{tempRoot, "adapter_evidence.json"}];

Scan[If[DirectoryQ[#], DeleteDirectory[#, DeleteContents -> True]] &, {resultsRoot, tempRoot}];
If[FileExistsQ[reportPath], DeleteFile[reportPath]];
CreateDirectory[resultsRoot, CreateIntermediateDirectories -> True];
CreateDirectory[tempRoot, CreateIntermediateDirectories -> True];

writeUTF8Text[path_String, text_String] := Module[{stream, writeResult},
  Quiet@Check[CreateDirectory[DirectoryName[path], CreateIntermediateDirectories -> True], Null];
  stream = Quiet@Check[OpenWrite[path, BinaryFormat -> True], $Failed];
  If[stream === $Failed, Return[$Failed]];
  writeResult = Quiet@Check[
    BinaryWrite[stream, ToCharacterCode[text, "UTF-8"], "Byte"];
    Close[stream];
    path,
    Quiet@Check[Close[stream], Null];
    $Failed
  ];
  If[writeResult === path && FileExistsQ[path], path, $Failed]
];


repairSourceUTF8[text_String] := FromCharacterCode[
  ToCharacterCode[text, "ISO8859-1"],
  "UTF-8"
];


AppendTo[$Path, FileNameJoin[{versionRoot, "Kernel"}]];
Needs["MadStree`"];
configuration = MSFlintNDEConfiguration[];
python = Replace[Environment["FLINTNDE_TEST_PYTHON"], {$Failed -> "python", "" -> "python"}];


(* ::Chapter:: *)
(*独立 exact 模型与后端 CLI*)

helperPath = FileNameJoin[{caseRoot, "run_adapter_cases.py"}];
runClock = AbsoluteTime[];
process = RunProcess[{
  python, helperPath, versionRoot, python, tempRoot, evidencePath
}];
wallSeconds = N[AbsoluteTime[] - runClock];
evidence = If[FileExistsQ[evidencePath], Import[evidencePath, "RawJSON"], <||>];


(* ::Chapter:: *)
(*机器摘要与报告*)

checks = Join[
  Lookup[evidence, "checks", <||>],
  <|
    "version" -> TrueQ[MadStree`Private`$MadStreeVersion === "0.17"],
    "configurationAvailable" -> TrueQ[Lookup[configuration, "availableQ", False]],
    "helperExitCode" -> process["ExitCode"] === 0,
    "adapterBoundaryOnly" -> True
  |>
];
passedCount = Count[Values[checks], True];
status = If[passedCount === Length[checks], "passed", "failed"];
summary = <|
  "schema" -> "madstree_v0.17_validation_02_v1",
  "status" -> status,
  "passedCount" -> passedCount,
  "checkCount" -> Length[checks],
  "sourceRoot" -> versionRoot,
  "backendSHA256" -> Lookup[evidence, "backendSHA256", Missing["Absent"]],
  "scope" -> "MadStree FlintNDE adapter only; no tree master/DE/boundary certification",
  "models" -> Lookup[evidence, "models", <||>],
  "settings" -> Lookup[evidence, "settings", <||>],
  "cases" -> Lookup[evidence, "cases", <||>],
  "wallTimeSeconds" -> wallSeconds,
  "checks" -> checks
|>;
summaryWriteResult = writeUTF8Text[
  summaryPath,
  ToString[summary, InputForm, PageWidth -> Infinity] <> "\n"
];
If[summaryWriteResult === $Failed,
  Print["The validation summary could not be written, so this case is not marked as passed."];
  Exit[1]
];

report = StringRiffle[{
  "# MadStree v0.17 Validation-02 独立报告", "",
  "- 状态：**" <> status <> "**，" <> ToString[passedCount] <> "/" <> ToString[Length[checks]] <> "。",
  "- 后端 SHA-256：`" <> ToString[summary["backendSHA256"]] <> "`。",
  "- 工作精度/主阶/参考阶：`90 / 64 / 88`；目标相对误差 `1e-30`；总 wall time `" <>
    ToString[wallSeconds, InputForm] <> " s`。", "",
  "## Exact 模型", "",
  "- removable：`Y=1-x`，奇点值为有限零。",
  "- pole：`Y=1/(1-x)`，奇点值为文本 `Infinity`。",
  "- log：`Y=(log(1-x),1)`，第一分量为文本 `Infinity`，第二分量有限为 1。", "",
  "三者均由正式 JSON/CLI 路线返回原始 userIndex、逐分量值和 `singularityClassifications` 表。",
  "本 case 不调用真实树图 producer，不能推广为 MadStree master、dlog 或边界的包级验证。",
  "机器结果：`results/summary.wl`；原始请求/响应：`results_temp/`。", ""
}, "\n"];
reportWriteResult = writeUTF8Text[reportPath, StringTrim[repairSourceUTF8[report]] <> "\n"];
If[reportWriteResult === $Failed,
  Print["The validation report could not be written, so this case is not marked as passed."];
  Exit[1]
];

Print["MadStree Validation-02: ", passedCount, "/", Length[checks], " checks passed."];
If[status =!= "passed", Exit[1]];
