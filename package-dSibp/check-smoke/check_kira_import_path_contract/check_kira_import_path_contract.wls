(* ::Package:: *)
(* 文件用途：验证 DSKiraImport 的缺省 Kira family 路径合同。
   测试只构造最小文件骨架，不运行 Kira，也不把 synthetic 数据作为 reduction 证据。 *)


(* ::Chapter:: *)
(*加载 022 程序包与最小 context*)

Get[FileNameJoin[{DirectoryName[$InputFileName], "..", "_harness.wls"}]];
projectRoot = DirectoryName[DirectoryName[DirectoryName[$InputFileName]]];
dsSmokeLoadPackage[FileNameJoin[{projectRoot, "versions", "022_dSIBP", "Kernel", "dSIBP.wl"}]];
DSMessagesOff[];

caseInput = <|
   "name" -> "CheckKiraImportPathContract",
   "vertices" -> {
     <|"id" -> 1, "vertexType" -> "+", "externalLegEnergy" -> E1|>,
     <|"id" -> 2, "vertexType" -> "+", "externalLegEnergy" -> E2|>
     },
   "lines" -> {
     <|"id" -> 1, "massType" -> "massive", "endpoints" -> {1, 2},
       "momentum" -> q, "nu" -> nu|>,
     <|"id" -> 2, "massType" -> "massive", "endpoints" -> {1, 2},
       "momentum" -> q - k, "nu" -> nu|>
     },
   "loopMomenta" -> {q},
   "loopExternalMomenta" -> {k},
   "independentExternalMomenta" -> {},
   "ibpMode" -> "full",
   "kinematicRules" -> {sp[k, k] -> ss11^2},
   "ispData" -> {},
   "zeroPointRules" -> {
     a0[1] -> 2 nu, a0[2] -> 2 nu,
     b0[1] -> -2 nu, b0[2] -> -2 nu
     },
   "symmetryRules" -> {}
   |>;

context = DSInit[
   caseInput,
   RegisterAsCurrent -> False,
   WriteInitializationFiles -> False,
   GenerateDerivativeMetadata -> False,
   ProgressReporting -> False
   ];


(* ::Chapter:: *)
(*受控 workspace 与旧路径拒绝*)

resultsTestDirectory = FileNameJoin[{DirectoryName[$InputFileName], "results_test"}];
workspace = FileNameJoin[{resultsTestDirectory, "path_contract"}];
If[DirectoryQ[resultsTestDirectory], DeleteDirectory[resultsTestDirectory, DeleteContents -> True]];
CreateDirectory[FileNameJoin[{workspace, "result"}], CreateIntermediateDirectories -> True];
CreateDirectory[FileNameJoin[{workspace, "results"}], CreateIntermediateDirectories -> True];

Put[<||>, FileNameJoin[{workspace, "dsibp-export-manifest.wl"}]];
Put[{}, FileNameJoin[{workspace, "result", "repJ2kira.m"}]];
Put[{}, FileNameJoin[{workspace, "result", "repkira2J.m"}]];
Put[{}, FileNameJoin[{workspace, "results", "kira_list.m"}]];
Export[FileNameJoin[{workspace, "results", "masters"}], "1 #\n", "Text"];

oldOnlyResult = Quiet@DSKiraImport[workspace, context, ProgressReporting -> False];
expectedReductionPath = FileNameJoin[{workspace, "results", "Tuserweight", "kira_list.m"}];
expectedMasterPath = FileNameJoin[{workspace, "results", "Tuserweight", "masters"}];


(* ::Chapter:: *)
(*当前 family 路径发现与清理*)

CreateDirectory[FileNameJoin[{workspace, "results", "Tuserweight"}], CreateIntermediateDirectories -> True];
Put[{}, expectedReductionPath];
Export[expectedMasterPath, "1 #\n", "Text"];
currentPathResult = Quiet@DSKiraImport[workspace, context, ProgressReporting -> False];

checks = <|
   "initialized" -> (Lookup[context, "status", "failed"] === "initialized"),
   "oldRootFilesRejected" -> (Lookup[oldOnlyResult, "reason", None] === "missingFiles"),
   "reportedCurrentReductionPath" ->
    (Lookup[Lookup[oldOnlyResult, "files", <||>], "reduction", None] === expectedReductionPath),
   "reportedCurrentMasterPath" ->
    (Lookup[Lookup[oldOnlyResult, "files", <||>], "masters", None] === expectedMasterPath),
   "currentFamilyFilesDiscovered" ->
    (Lookup[currentPathResult, "reason", "missingFiles"] =!= "missingFiles"),
   "automaticResolverUsesCurrentReductionPath" ->
    (dSIBP`Private`dsKiraResolveFile[
       workspace, Automatic, {"results", "Tuserweight", "kira_list.m"}
       ] === expectedReductionPath),
   "automaticResolverUsesCurrentMasterPath" ->
    (dSIBP`Private`dsKiraResolveFile[
       workspace, Automatic, {"results", "Tuserweight", "masters"}
       ] === expectedMasterPath)
   |>;

If[DirectoryQ[resultsTestDirectory], DeleteDirectory[resultsTestDirectory, DeleteContents -> True]];
failed = Keys@Select[checks, Not@TrueQ[#] &];
Print["check_kira_import_path_contract: ", Count[Values[checks], True], "/", Length[checks]];
Print["failed: ", InputForm[failed]];
Print[InputForm[<|
   "passed" -> Count[Values[checks], True],
   "total" -> Length[checks],
   "failed" -> failed,
   "checks" -> checks
   |>]];
If[failed =!= {}, Exit[1]];
