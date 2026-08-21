(* ::Package:: *)
(* 文件用途：验证 MadStree 浅层运行目录、Windows 长路径分类、导出完整性和模块加载契约。
   核心逻辑：只构造最小输入并检查错误标签；临时产物统一写入 test/results_test。 *)

(* ::Chapter:: *)
(*程序包加载与测试目录*)

Get[FileNameJoin[{DirectoryName[$InputFileName], "_harness.wls"}]];
packageRoot = msTestLoadKernel[];
testRoot = FileNameJoin[{DirectoryName[$InputFileName], "results_test", "runtime-paths"}];
If[! DirectoryQ[testRoot], CreateDirectory[testRoot, CreateIntermediateDirectories -> True]];


(* ::Chapter:: *)
(*模块契约与浅层目录*)

moduleContracts = MadStree`Private`$MadStreeModuleContracts;
moduleContractsPresent = And @@ Map[
  MadStree`Private`$MadStreeDefinitionPresentQ[Last[#]] &,
  moduleContracts
];
defaultRuntime = MadStree`Private`msDefaultRuntimeDirectory[];
explicitRuntime = MadStree`Private`msResolveRuntimeDirectory[testRoot];


(* ::Chapter:: *)
(*路径长度与导出门禁*)

path259 = StringJoin[ConstantArray["x", 259]];
path260 = StringJoin[ConstantArray["x", 260]];
length259Result = MadStree`Private`msRuntimePathLengthFailure[{path259}];
length260Result = MadStree`Private`msRuntimePathLengthFailure[{path260}];

minimalEvaluation = <|
  "status" -> "computed",
  "pointResults" -> {<|
    "coordinate" -> {x -> 1/2},
    "userIndex" -> 1,
    "status" -> "saved",
    "value" -> {1 + I},
    "flintNDE" -> <|"relativeDifferenceInf" -> "0",
      "targetRelativeErrorMet" -> True|>
  |>}
|>;
successfulExport = MSExportEvaluationData[
  minimalEvaluation,
  MSOutputDirectory -> FileNameJoin[{testRoot, "export-ok"}]
];
longExport = MSExportEvaluationData[
  minimalEvaluation,
  MSOutputDirectory -> path260
];
partialExportDirectory = FileNameJoin[{testRoot, "export-partial"}];
jsonConflict = FileNameJoin[{partialExportDirectory, "evaluation_data.json"}];
If[! DirectoryQ[jsonConflict],
  CreateDirectory[jsonConflict, CreateIntermediateDirectories -> True]
];
partialExport = MSExportEvaluationData[
  minimalEvaluation,
  MSOutputDirectory -> partialExportDirectory
];

inputFailureRuntime = FileNameJoin[{testRoot, "input-write"}];
inputConflict = FileNameJoin[{inputFailureRuntime, "nde", "i-fixed.json"}];
If[! DirectoryQ[inputConflict],
  CreateDirectory[inputConflict, CreateIntermediateDirectories -> True]
];
inputWriteFailure = Block[{
    MadStree`Private`msFlintNDECreateToken = Function["fixed"]
  },
  MadStree`Private`msExecuteFlintNDEAdapter[
    <|"backendPackagePath" -> FileNameJoin[{packageRoot, "Vendor", "FlintNDE"}]|>,
    "PYTHON_MUST_NOT_RUN",
    inputFailureRuntime
  ]
];


(* ::Chapter:: *)
(*结果检查*)

checks = <|
  "allModuleContractsPresent" -> TrueQ[moduleContractsPresent],
  "moduleContractCount" -> Length[moduleContracts] === 16,
  "automaticAddsResultsTempOnce" ->
    FileNameTake[defaultRuntime] === "results_temp" &&
    Count[FileNameSplit[defaultRuntime], "results_temp"] === 1,
  "explicitRuntimeUsedDirectly" -> explicitRuntime === ExpandFileName[testRoot],
  "length259Accepted" -> length259Result === None,
  "length260Separated" -> MatchQ[length260Result, Failure["RuntimePathTooLong", _Association]],
  "successfulExportComplete" ->
    Lookup[successfulExport, "status", None] === "written" &&
    Length[Lookup[successfulExport, "files", {}]] === 2 &&
    And @@ FileExistsQ /@ Lookup[successfulExport, "files", {}],
  "longExportSeparated" -> MatchQ[longExport, Failure["RuntimePathTooLong", _Association]],
  "partialExportCannotClaimWritten" ->
    MatchQ[partialExport, Failure["EvaluationExportFailed", _Association]] &&
    FileExistsQ[FileNameJoin[{partialExportDirectory, "evaluation_data.csv"}]],
  "inputWriteFailsBeforePython" ->
    MatchQ[inputWriteFailure, Failure["RuntimeInputWriteFailed", _Association]]
|>;

msTestSummary[checks, "MadStree v0.15 runtime paths and exports"];
