(* ::Package:: *)

(***
文件：run_validation.wls
用途：独立验证省略外腿能量与显式零外腿能量生成同一解析系统，并从私有辅助能量边界输运到物理零点。
范围：两条路线分别调用当前 v0.17 的完整公开 producer；结果只写入本 case 的 results/results_temp。
核心逻辑：先冻结等价输入与源码哈希，再比较 master、dlog、边界、辅助坐标隔离和同点数值结果。
***)

(* ::Chapter:: *)
(*路径、fresh 输出与源码身份*)

$CharacterEncoding = "UTF-8";
caseRoot = DirectoryName[$InputFileName];
projectRoot = DirectoryName[DirectoryName[DirectoryName[caseRoot]]];
versionRoot = FileNameJoin[{projectRoot, "package-MadStree", "versions", "MadStree-v0.17"}];
resultsRoot = FileNameJoin[{caseRoot, "results"}];
tempRoot = FileNameJoin[{caseRoot, "results_temp"}];
reportPath = FileNameJoin[{caseRoot, "000_MadStree-v0.17-validation-01-report.md"}];
summaryPath = FileNameJoin[{resultsRoot, "summary.wl"}];

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


sourceFiles = Sort[FileNames["*.wl", FileNameJoin[{versionRoot, "Kernel"}], Infinity]];
sourceDigest = Hash[FileHash[#, "SHA256"] & /@ sourceFiles, "SHA256", "HexString"];


(* ::Chapter:: *)
(*独立输入与预先固定判据*)

verticesOmitted = {
  <|"id" -> 1, "timePower" -> 1, "vertexType" -> "+"|>,
  <|"id" -> 2, "externalLegEnergy" -> k2, "timePower" -> 1, "vertexType" -> "+"|>
};
verticesZero = ReplacePart[
  verticesOmitted,
  1 -> Append[First[verticesOmitted], "externalLegEnergy" -> 0]
];
lines = {<|"type" -> "massless", "endpoints" -> {1, 2}, "momentum" -> q|>};
pointSequence = {{k2}, {3 I}};
parameterRules = {q -> 1};
targetRelativeError = 10^-20;
safetyFactor = 8;
jointRelativeBudget = 2 targetRelativeError;

AppendTo[$Path, FileNameJoin[{versionRoot, "Kernel"}]];
Needs["MadStree`"];
python = Replace[Environment["FLINTNDE_TEST_PYTHON"], {$Failed -> "python", "" -> "python"}];


(* ::Chapter:: *)
(*省略外腿能量路线*)

omittedClock = AbsoluteTime[];
omittedContext = MSInitTree[<|"vertices" -> verticesOmitted, "lines" -> lines|>];
omittedMasters = MSMasterIntegrals[omittedContext];
omittedDE = MSDLogDE[omittedContext];
omittedAuxiliary = omittedContext["vertices"][[1, "externalLegEnergy"]];
omittedBoundary = MSBoundaryData[
  omittedContext,
  {omittedAuxiliary -> 0, k2 -> 3 I, q -> 1},
  BoundaryScale -> 4,
  WorkingPrecision -> 40
];
omittedResult = MSEvaluatePath[
  omittedContext,
  pointSequence,
  ParameterRules -> parameterRules,
  PythonExecutable -> python,
  MSRuntimeDirectory -> FileNameJoin[{tempRoot, "omitted"}],
  BoundaryScale -> 4,
  WorkingPrecision -> 40,
  TransportOrder -> 80,
  ReferenceTransportOrder -> 104,
  TargetRelativeError -> "1e-20",
  MessageLanguage -> "CN"
];
omittedSeconds = N[AbsoluteTime[] - omittedClock];
Put[<|"status" -> "partial", "completedRoute" -> "omitted", "sourceDigest" -> sourceDigest|>, summaryPath];


(* ::Chapter:: *)
(*显式零外腿能量路线*)

zeroClock = AbsoluteTime[];
zeroContext = MSInitTree[<|"vertices" -> verticesZero, "lines" -> lines|>];
zeroMasters = MSMasterIntegrals[zeroContext];
zeroDE = MSDLogDE[zeroContext];
zeroAuxiliary = zeroContext["vertices"][[1, "externalLegEnergy"]];
zeroBoundary = MSBoundaryData[
  zeroContext,
  {zeroAuxiliary -> 0, k2 -> 3 I, q -> 1},
  BoundaryScale -> 4,
  WorkingPrecision -> 40
];
zeroResult = MSEvaluatePath[
  zeroContext,
  pointSequence,
  ParameterRules -> parameterRules,
  PythonExecutable -> python,
  MSRuntimeDirectory -> FileNameJoin[{tempRoot, "zero"}],
  BoundaryScale -> 4,
  WorkingPrecision -> 40,
  TransportOrder -> 80,
  ReferenceTransportOrder -> 104,
  TargetRelativeError -> "1e-20",
  MessageLanguage -> "CN"
];
zeroSeconds = N[AbsoluteTime[] - zeroClock];


(* ::Chapter:: *)
(*逐阶段比较与报告*)

omittedValue = Lookup[First[Lookup[omittedResult, "pointResults", {<||>}]], "value", {}];
zeroValue = Lookup[First[Lookup[zeroResult, "pointResults", {<||>}]], "value", {}];
relativeDifference = If[
  VectorQ[omittedValue, NumericQ] && VectorQ[zeroValue, NumericQ],
  Max[Abs[omittedValue - zeroValue]]/Max[Join[Abs[zeroValue], {10^-40}]],
  Infinity
];
checks = <|
  "version" -> TrueQ[MadStree`Private`$MadStreeVersion === "0.17"],
  "contexts" -> And @@ (MSContextQ /@ {omittedContext, zeroContext}),
  "masterOrder" -> Lookup[omittedMasters, "integral"] === Lookup[zeroMasters, "integral"],
  "masterDigest" -> omittedContext["masterDigest"] === zeroContext["masterDigest"],
  "analyticDLog" -> omittedDE["connection"] === zeroDE["connection"],
  "boundaryGenerated" -> And @@ (Lookup[#, "status", None] === "generated" & /@ {omittedBoundary, zeroBoundary}),
  "privateAuxiliary" -> omittedAuxiliary === zeroAuxiliary &&
    TrueQ[omittedContext["vertices"][[1, "auxiliaryExternalLegEnergyQ"]]] &&
    TrueQ[zeroContext["vertices"][[1, "auxiliaryExternalLegEnergyQ"]]],
  "auxiliaryTargetsZero" -> omittedContext["vertices"][[1, "externalLegEnergyTarget"]] === 0 &&
    zeroContext["vertices"][[1, "externalLegEnergyTarget"]] === 0,
  "publicInputIsolated" -> FreeQ[{pointSequence, parameterRules}, omittedAuxiliary | zeroAuxiliary],
  "computed" -> And @@ (Lookup[#, "status", None] === "computed" & /@ {omittedResult, zeroResult}),
  "refinementMet" -> And @@ (TrueQ[Lookup[Lookup[#, "flintNDE", <||>], "targetRelativeErrorMet", False]] & /@
    {omittedResult, zeroResult}),
  "jointBudget" -> TrueQ[relativeDifference <= safetyFactor jointRelativeBudget]
|>;
passedCount = Count[Values[checks], True];
status = If[passedCount === Length[checks], "passed", "failed"];

summary = <|
  "schema" -> "madstree_v0.17_validation_01_v1",
  "status" -> status,
  "passedCount" -> passedCount,
  "checkCount" -> Length[checks],
  "sourceRoot" -> versionRoot,
  "sourceDigestSHA256" -> sourceDigest,
  "convention" -> "vertexType + means Exp[-I externalLegEnergy tau]; private auxiliary target is zero",
  "pointSequence" -> pointSequence,
  "parameterRules" -> parameterRules,
  "privateAuxiliarySymbols" -> {omittedAuxiliary, zeroAuxiliary},
  "masterCount" -> Length[omittedMasters],
  "masterDigest" -> omittedContext["masterDigest"],
  "boundaryMethods" -> Lookup[{omittedBoundary, zeroBoundary}, "method"],
  "boundaryAnchors" -> Lookup[{omittedBoundary, zeroBoundary}, "anchorRules"],
  "orders" -> <|"boundary" -> Lookup[omittedBoundary, "seriesOrder", "automatic"],
    "primary" -> 80, "reference" -> 104, "workingPrecision" -> 40|>,
  "jointErrorBudget" -> <|"targetPerRoute" -> targetRelativeError,
    "combined" -> jointRelativeBudget, "safetyFactor" -> safetyFactor,
    "observedRelativeDifference" -> relativeDifference|>,
  "routes" -> <|
    "omitted" -> <|"wallTimeSeconds" -> omittedSeconds, "segments" -> omittedResult["segments"],
      "flintNDE" -> KeyTake[omittedResult["flintNDE"], {"primarySeconds", "referenceSeconds", "targetRelativeErrorMet"}]|>,
    "zero" -> <|"wallTimeSeconds" -> zeroSeconds, "segments" -> zeroResult["segments"],
      "flintNDE" -> KeyTake[zeroResult["flintNDE"], {"primarySeconds", "referenceSeconds", "targetRelativeErrorMet"}]|>
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
  "# MadStree v0.17 Validation-01 独立报告", "",
  "- 状态：**" <> status <> "**，" <> ToString[passedCount] <> "/" <> ToString[Length[checks]] <> "。",
  "- 源码聚合 SHA-256：`" <> sourceDigest <> "`。",
  "- 输入点：`{{k2},{3 I}}`；固定参数：`{q->1}`；私有辅助坐标未进入用户输入。",
  "- boundary/主/参考阶：`Automatic / 80 / 104`；工作精度 40 位。", "",
  "## 路线与误差", "",
  "两条路线分别从非零阻尼 boundary anchor 输运到私有辅助能量的物理值 0。省略/显式零 wall time 为 `" <>
    ToString[omittedSeconds, InputForm] <> " / " <> ToString[zeroSeconds, InputForm] <> " s`。",
  "联合相对误差预算为 `" <> ToString[jointRelativeBudget, InputForm] <> "`，安全因子 8；观察差为 `" <>
    ToString[relativeDifference, InputForm] <> "`。实际 segment、anchor 和计时保存在 `results/summary.wl`。", "",
  "## 结论", "",
  "两种公开输入生成相同 master 顺序、digest 和解析 dlog；辅助符号互相独立且均不泄漏到 pointSequence/ParameterRules。",
  "机器结果：`results/summary.wl`。", ""
}, "\n"];
reportWriteResult = writeUTF8Text[reportPath, StringTrim[repairSourceUTF8[report]] <> "\n"];
If[reportWriteResult === $Failed,
  Print["The validation report could not be written, so this case is not marked as passed."];
  Exit[1]
];

Print["MadStree Validation-01: ", passedCount, "/", Length[checks], " checks passed."];
If[status =!= "passed", Exit[1]];
