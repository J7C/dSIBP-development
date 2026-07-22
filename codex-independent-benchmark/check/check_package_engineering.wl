(* ::Package:: *)
(* 本检查从零生成 014 init/seed/linear/export，并用同源 synthetic reduction 重建 importer 正例与五类独立负例；不运行 Kira。 *)

ClearAll["Global`*"];


(* ::Chapter:: *)
(*路径、package 与临时工作区*)
checkDir = DirectoryName[$InputFileName];
workspaceDir = DirectoryName[checkDir];
projectDir = DirectoryName[workspaceDir];
packagePath = FileNameJoin[{projectDir, "independent-benchmark", "package", "package_014.wl"}];
resultsDir = FileNameJoin[{checkDir, "results"}];
resultPath = FileNameJoin[{resultsDir, "package-engineering.wl"}];
tempRoot = FileNameJoin[{workspaceDir, "results_temp", "package-engineering"}];
initDir = FileNameJoin[{tempRoot, "init"}];
exportDir = FileNameJoin[{tempRoot, "kira"}];
If[DirectoryQ[tempRoot], DeleteDirectory[tempRoot, DeleteContents -> True]];
CreateDirectory[tempRoot, CreateIntermediateDirectories -> True];
If[! DirectoryQ[resultsDir], CreateDirectory[resultsDir, CreateIntermediateDirectories -> True]];

Get[packagePath];
DSMessagesOff[];


(* ::Chapter:: *)
(*小型合法 family 与初始化 metadata*)
case = <|
  "name" -> "engineering-atomic-massless",
  "vertexData" -> {{v1, "+"}, {v2, "+"}},
  "lineData" -> {<|"id" -> 1, "endpoints" -> {v1, v2}, "momentum" -> ell,
    "massType" -> "massless", "bbType" -> "exp", "nu" -> 0|>},
  "loopMomenta" -> {ell},
  "externalMomenta" -> {},
  "externalInvariantRules" -> {},
  "vertexEnergies" -> <|v1 -> E1, v2 -> E2|>,
  "ispData" -> {},
  "zeroPointRules" -> {a0[v1] -> 0, a0[v2] -> 0, b0[1] -> 0},
  "numericRules" -> {dim -> 3, E1 -> 2, E2 -> 3},
  "symmetryRules" -> {},
  "seedRanges" -> <|"a" -> {0}, "b" -> {0}, "sampleOnly" -> True|>
|>;

contextNoDerivatives = DSInit[
  case,
  InitializationDirectory -> initDir,
  WriteInitializationFiles -> True,
  GenerateDerivativeMetadata -> False,
  OverwriteInitialization -> False,
  RegisterAsCurrent -> False,
  ProgressReporting -> False
];

baseInitFiles = FileNameJoin[{initDir, #}] & /@ {
  "manifest.wl", "topology.wl", "sectors.wl", "conventions.wl"
};
derivativePath = FileNameJoin[{initDir, "derivatives.wl"}];
derivativeAbsentBefore = ! FileExistsQ[derivativePath];

contextWithDerivatives = DSInit[
  case,
  InitializationDirectory -> initDir,
  WriteInitializationFiles -> True,
  GenerateDerivativeMetadata -> True,
  OverwriteInitialization -> False,
  RegisterAsCurrent -> False,
  ProgressReporting -> False
];

conflictingCase = Join[case, <|"vertexEnergies" -> <|v1 -> E1 + 1, v2 -> E2|>|>];
conflictContext = DSInit[
  conflictingCase,
  InitializationDirectory -> initDir,
  WriteInitializationFiles -> True,
  GenerateDerivativeMetadata -> False,
  OverwriteInitialization -> False,
  RegisterAsCurrent -> False,
  ProgressReporting -> False
];


(* ::Chapter:: *)
(*seed、linearData 与 serializer*)
context = DSInit[case, RegisterAsCurrent -> False, ProgressReporting -> False];
seeds = DSSeeds[
  context,
  UseSampleOnly -> True,
  DiscreteMode -> "all",
  GenerateShrinkSectors -> True,
  ProgressReporting -> False
];
linear = DSLinear[
  seeds,
  context,
  LinearSystemMode -> "numeric",
  CoefficientRules -> Lookup[case, "numericRules"],
  ProgressReporting -> False
];
export = DSKiraExport[
  linear,
  OutputDirectory -> exportDir,
  ProgressReporting -> False
];


(* ::Chapter:: *)
(*同源 synthetic Kira import 正例*)

(* ::Section::Closed:: *)
(*所有非 master target 都显式约到 ID 1，dummy target 由 importer 按 manifest 排除*)
manifestPath = FileNameJoin[{exportDir, "dsibp-export-manifest.wl"}];
forwardMapPath = FileNameJoin[{exportDir, "result", "repJ2kira.m"}];
backwardMapPath = FileNameJoin[{exportDir, "result", "repkira2J.m"}];
reductionDir = FileNameJoin[{exportDir, "results"}];
reductionPath = FileNameJoin[{reductionDir, "kira_list.m"}];
mastersPath = FileNameJoin[{reductionDir, "masters"}];
completionPath = FileNameJoin[{exportDir, "kira.log"}];
exportDidNotRunKiraQ = ! FileExistsQ[completionPath] && ! DirectoryQ[reductionDir];
If[! DirectoryQ[reductionDir], CreateDirectory[reductionDir, CreateIntermediateDirectories -> True]];

manifest = Get[manifestPath];
forwardMap = Get[forwardMapPath];
backwardMap = Get[backwardMapPath];
mapIDs = Last /@ forwardMap;
masterID = First[mapIDs];
positiveRules = Table[Tuserweight[id] -> Tuserweight[masterID], {id, Rest[mapIDs]}];

Put[positiveRules, reductionPath];
Export[mastersPath, ToString[masterID] <> " #\n", "Text"];
Export[completionPath, "Kira finished successfully\nunreduced integrals: 0\n", "Text"];

positiveImport = DSKiraImport[exportDir, context, ProgressReporting -> False];


(* ::Chapter:: *)
(*completion/hash/maps/targets/RHS 五类独立负例*)

(* ::Section::Closed:: *)
(*completion marker 缺失*)
badCompletionPath = FileNameJoin[{exportDir, "bad-completion.log"}];
Export[badCompletionPath, "Kira started but did not finish\n", "Text"];
badCompletion = DSKiraImport[
  exportDir, context,
  KiraCompletionFile -> badCompletionPath,
  ProgressReporting -> False
];


(* ::Section::Closed:: *)
(*manifest input hash 与当前 context 不同*)
badManifest = Join[manifest, <|
  "context" -> Join[Lookup[manifest, "context"], <|"inputHash" -> "deliberately-wrong-hash"|>]
|>];
Put[badManifest, manifestPath];
badHash = DSKiraImport[exportDir, context, ProgressReporting -> False];
Put[manifest, manifestPath];


(* ::Section::Closed:: *)
(*双向 map 少一项，破坏可逆性*)
Put[Most[backwardMap], backwardMapPath];
badMaps = DSKiraImport[exportDir, context, ProgressReporting -> False];
Put[backwardMap, backwardMapPath];


(* ::Section::Closed:: *)
(*少一个 target 的 reduction，且该 ID 不是 master*)
badTargetPath = FileNameJoin[{reductionDir, "bad-target.m"}];
Put[Most[positiveRules], badTargetPath];
badTargets = DSKiraImport[
  exportDir, context,
  KiraReductionFile -> badTargetPath,
  ProgressReporting -> False
];


(* ::Section::Closed:: *)
(*RHS 故意保留非 master ID*)
badRHSPath = FileNameJoin[{reductionDir, "bad-rhs.m"}];
badRHSRules = ReplacePart[positiveRules, 1 -> (First[positiveRules][[1]] -> Tuserweight[Last[mapIDs]])];
Put[badRHSRules, badRHSPath];
badRHS = DSKiraImport[
  exportDir, context,
  KiraReductionFile -> badRHSPath,
  ProgressReporting -> False
];


(* ::Chapter:: *)
(*消息开关与汇总*)
DSMessagesOn[];
messagesOnQ = DSMessagesQ[];
DSMessagesOff[];
messagesOffQ = ! DSMessagesQ[];

checks = {
  <|"label" -> "init-no-derivatives-status", "actual" -> Lookup[contextNoDerivatives, "status"], "expected" -> "initialized"|>,
  <|"label" -> "init-base-files", "actual" -> And @@ (FileExistsQ /@ baseInitFiles), "expected" -> True|>,
  <|"label" -> "init-derivatives-default-off", "actual" -> derivativeAbsentBefore, "expected" -> True|>,
  <|"label" -> "init-derivatives-explicit-on", "actual" -> Lookup[contextWithDerivatives, "status"] === "initialized" && FileExistsQ[derivativePath], "expected" -> True|>,
  <|"label" -> "init-hash-conflict-rejected", "actual" -> Lookup[conflictContext, "status"], "expected" -> "failed"|>,
  <|"label" -> "messages-on", "actual" -> messagesOnQ, "expected" -> True|>,
  <|"label" -> "messages-off", "actual" -> messagesOffQ, "expected" -> True|>,
  <|"label" -> "seed-status", "actual" -> Lookup[seeds, "dSIBPStatus"], "expected" -> "generated"|>,
  <|"label" -> "seed-canonical", "actual" -> TrueQ[Lookup[seeds, "completeCanonicalQ", False]], "expected" -> True|>,
  <|"label" -> "linear-status", "actual" -> Lookup[linear, "dSIBPStatus"], "expected" -> "generated"|>,
  <|"label" -> "export-status", "actual" -> Lookup[export, "status"], "expected" -> "ready"|>,
  <|"label" -> "export-manifest", "actual" -> FileExistsQ[manifestPath], "expected" -> True|>,
  <|"label" -> "export-did-not-run-kira", "actual" -> exportDidNotRunKiraQ, "expected" -> True|>,
  <|"label" -> "positive-import", "actual" -> Lookup[positiveImport, "status"], "expected" -> "imported"|>,
  <|"label" -> "negative-completion", "actual" -> Lookup[badCompletion, "status"], "expected" -> "failed"|>,
  <|"label" -> "negative-hash", "actual" -> Lookup[badHash, "status"], "expected" -> "failed"|>,
  <|"label" -> "negative-maps", "actual" -> Lookup[badMaps, "status"], "expected" -> "failed"|>,
  <|"label" -> "negative-targets", "actual" -> Lookup[badTargets, "status"], "expected" -> "failed"|>,
  <|"label" -> "negative-rhs", "actual" -> Lookup[badRHS, "status"], "expected" -> "failed"|>
};

checks = Join[#, <|"passed" -> TrueQ[Lookup[#, "actual"] === Lookup[#, "expected"]]|>] & /@ checks;
summary = <|
  "packageHash" -> FileHash[packagePath, "SHA256", "HexString"],
  "passed" -> Count[checks, _?(TrueQ[Lookup[#, "passed", False]] &)],
  "total" -> Length[checks],
  "nonconformities" -> Select[checks, ! TrueQ[Lookup[#, "passed", False]] &],
  "importNegativeReasons" -> <|
    "completion" -> Lookup[badCompletion, "reason", Missing["Absent"]],
    "hash" -> Lookup[badHash, "reason", Missing["Absent"]],
    "maps" -> Lookup[badMaps, "reason", Missing["Absent"]],
    "targets" -> Lookup[badTargets, "reason", Missing["Absent"]],
    "rhs" -> Lookup[badRHS, "reason", Missing["Absent"]]
  |>
|>;

Put[summary, resultPath];
Print[InputForm[summary]];
If[summary["passed"] =!= summary["total"], Exit[1]];
