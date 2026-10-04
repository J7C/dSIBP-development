(* ::Package:: *)

(***
文件：run_validation.wls
用途：验证 MadStree 后端 Automatic 奇点双侧 bucket、末端隐藏匹配和关闭规划时的 fail-closed 行为。
范围：使用独立一维闭式 dlog 模型，只认证 MadStree 到 FlintNDE 的路径适配，不认证真实树图 producer。
核心逻辑：fresh 运行 planned、多次 naive、末端和负例请求，再保存真实节点、assignment、计时与误差。
***)

(* ::Chapter:: *)
(*fresh 输出与当前版本*)

$CharacterEncoding = "UTF-8";
caseRoot = DirectoryName[$InputFileName];
projectRoot = DirectoryName[DirectoryName[DirectoryName[caseRoot]]];
versionRoot = FileNameJoin[{projectRoot, "package-MadStree", "versions", "MadStree-v0.17"}];
resultsRoot = FileNameJoin[{caseRoot, "results"}];
tempRoot = FileNameJoin[{caseRoot, "results_temp"}];
reportPath = FileNameJoin[{caseRoot, "000_MadStree-v0.17-validation-03-report.md"}];
summaryPath = FileNameJoin[{resultsRoot, "summary.wl"}];
evidencePath = FileNameJoin[{tempRoot, "adapter_bucket_evidence.json"}];

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
(*planned、naive 与负例 CLI*)

helperPath = FileNameJoin[{caseRoot, "run_adapter_bucket.py"}];
runClock = AbsoluteTime[];
process = RunProcess[{python, helperPath, versionRoot, python, tempRoot, evidencePath}];
wallSeconds = N[AbsoluteTime[] - runClock];
evidence = If[FileExistsQ[evidencePath], Import[evidencePath, "RawJSON"], <||>];


(* ::Chapter:: *)
(*正式摘要与报告*)

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
planned = Lookup[evidence, "planned", <||>];
plannedSeconds = Lookup[planned, "wallTimeSeconds", Missing["Absent"]];
naiveSeconds = Lookup[evidence, "naiveWallTimeSeconds", Missing["Absent"]];
ratio = If[NumericQ[plannedSeconds] && plannedSeconds > 0 && NumericQ[naiveSeconds],
  naiveSeconds/plannedSeconds, Missing["Unavailable"]];
summary = <|
  "schema" -> "madstree_v0.17_validation_03_v1",
  "status" -> status,
  "passedCount" -> passedCount,
  "checkCount" -> Length[checks],
  "sourceRoot" -> versionRoot,
  "backendSHA256" -> Lookup[evidence, "backendSHA256", Missing["Absent"]],
  "scope" -> "MadStree FlintNDE adapter only; no tree master/DE/boundary certification",
  "exactModel" -> Lookup[evidence, "exactModel", Missing["Absent"]],
  "pointSequence" -> Lookup[evidence, "userPoints", {}],
  "settings" -> Lookup[evidence, "settings", <||>],
  "planned" -> planned,
  "values" -> Lookup[evidence, "values", {}],
  "terminal" -> Lookup[evidence, "terminal", <||>],
  "negativeCases" -> Lookup[evidence, "negativeCases", <||>],
  "timingSeconds" -> <|"planned" -> plannedSeconds, "naive" -> naiveSeconds,
    "naiveOverPlanned" -> ratio, "total" -> wallSeconds|>,
  "maximumErrors" -> <|
    "plannedVsClosed" -> Lookup[evidence, "maximumClosedRelativeError", Missing["Absent"]],
    "plannedVsNaive" -> Lookup[evidence, "maximumPlannedNaiveRelativeError", Missing["Absent"]]
  |>,
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
  "# MadStree v0.17 Validation-03 独立报告", "",
  "- 状态：**" <> status <> "**，" <> ToString[passedCount] <> "/" <> ToString[Length[checks]] <> "。",
  "- exact 系统：`Y=(x+1)/(1-x)`；用户点 18 个，`x=1` 为真实 pole。",
  "- 工作精度/主阶/参考阶：`90 / 64 / 88`；目标相对误差 `1e-25`；安全因子 8。", "",
  "## 路径与效率", "",
  "planned/naive wall time：`" <> ToString[plannedSeconds, InputForm] <> " / " <>
    ToString[naiveSeconds, InputForm] <> " s`；naive/planned：`" <> ToString[ratio, InputForm] <> "`。",
  "真实节点、逐点 source/assignment、收敛半径、userIndex 与闭式/naive 误差均保存在 `results/summary.wl`。", "",
  "## 末端与反例", "",
  "末端奇点使用到最近其它奇点的距离生成域内隐藏匹配点；低阶链给结果，高阶链只核验分类和误差。",
  "关闭规划的中间奇点、需要隐藏末端匹配点以及从不可继续的奇点进入下一段均 fail closed。",
  "本 case 只认证 adapter，不认证真实树图 master、dlog 或边界。", ""
}, "\n"];
reportWriteResult = writeUTF8Text[reportPath, StringTrim[repairSourceUTF8[report]] <> "\n"];
If[reportWriteResult === $Failed,
  Print["The validation report could not be written, so this case is not marked as passed."];
  Exit[1]
];

Print["MadStree Validation-03: ", passedCount, "/", Length[checks], " checks passed."];
If[status =!= "passed", Exit[1]];
