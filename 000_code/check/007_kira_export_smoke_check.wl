(* ::Package:: *)
(* 本文件生成 pure massless bubble 的最小 numeric Kira workspace，并检查 007 的基础文件导出门禁。
   它只构造 39 条小样本 canonical seed（含 massless shrink sectors），不运行 Kira，也不依赖任何本机 Kira/Fermat 路径。 *)


(* ::Chapter:: *)
(*环境与主线加载*)

projectRoot = ExpandFileName[FileNameJoin[{DirectoryName[$InputFileName], "..", ".."}]];
SetDirectory[projectRoot];

directoryBeforePackageLoad = Directory[];
packageLoadSentinel = 173;

Get["000_code/007_dS_ibp_general.wl"];

directoryAfterPackageLoad = Directory[];
directoryPreservedQ = TrueQ[directoryAfterPackageLoad === directoryBeforePackageLoad];
globalContextPreservedQ = TrueQ[packageLoadSentinel === 173];


(* ::Chapter:: *)
(*最小 numeric Kira workspace*)

smokeCase = Join[
   bubbleMasslessCase,
   <|
    "name" -> "kiraExportSmokeMasslessBubble",
    "numericRules" -> {dim -> 3, s11 -> 5, ke[1] -> 7, ke[2] -> 11}
    |>
   ];

smokeOutputDirectory = FileNameJoin[{
    projectRoot, "000_code", "check", "results_test", "kira_export_smoke_massless_bubble"
    }];

smokeWorkflow = If[directoryPreservedQ,
   makeIBPWorkflowData[
    smokeCase,
    LinearSystemMode -> "numeric",
    CoefficientRules -> Automatic,
    ExportKira -> True,
    OutputDirectory -> smokeOutputDirectory,
    KiraCoefficientRules -> {},
    KiraJobOptions -> <|
      "RunInitiate" -> True,
      "RunFirefly" -> False,
      "WriteKira2MathJob" -> False,
      "AppendNumericDummyEquation" -> Automatic
      |>
    ],
   <|"status" -> "notReady", "stage" -> "packageLoad", "reason" -> "packageChangedWorkingDirectory"|>
   ];

smokeSeedBatch = Lookup[smokeWorkflow, "seedBatch", <||>];
smokeLinearSystem = Lookup[smokeWorkflow, "linearSystem", <||>];
smokeKiraExport = Lookup[smokeWorkflow, "kiraExport", <||>];
smokeKiraInput = Lookup[smokeKiraExport, "kiraInput", <||>];

expectedKiraFiles = {
   FileNameJoin[{smokeOutputDirectory, "userSystem", "ibp.kira"}],
   FileNameJoin[{smokeOutputDirectory, "list"}],
   FileNameJoin[{smokeOutputDirectory, "jobs.yaml"}],
   FileNameJoin[{smokeOutputDirectory, "result", "repkira2J.m"}],
   FileNameJoin[{smokeOutputDirectory, "result", "repJ2kira.m"}],
   FileNameJoin[{smokeOutputDirectory, "result", "kira_export_metadata.m"}]
   };

smokeJobsText = If[
   FileExistsQ[FileNameJoin[{smokeOutputDirectory, "jobs.yaml"}]],
   Import[FileNameJoin[{smokeOutputDirectory, "jobs.yaml"}], "Text"],
   ""
   ];


(* ::Chapter:: *)
(*导出结构门禁*)

smokeCheckResults = <|
   "packageLoadPreservesDirectory" -> directoryPreservedQ,
   "packageLoadPreservesGlobalContext" -> globalContextPreservedQ,
   "workflowReady" -> TrueQ[
     Lookup[smokeWorkflow, "status", Missing["status"]] === "ready" &&
      Lookup[smokeWorkflow, "stage", Missing["stage"]] === "kira"
     ],
   "canonicalSeedCoverageReady" -> TrueQ[
     Lookup[Lookup[smokeWorkflow, "seedCoverageReport", <||>], "status", Missing["status"]] === "ready" &&
      Lookup[smokeSeedBatch, "completeCanonicalQ", False]
     ],
   "smallSeedAndLinearSystem" -> TrueQ[
     Lookup[smokeSeedBatch, "equationCount", 0] === 39 &&
      Lookup[smokeLinearSystem, "equationCount", 0] === 39 &&
      Lookup[smokeLinearSystem, "integralCount", 0] === 50 &&
      Sort[Lookup[Lookup[smokeSeedBatch, "sectorMetadataList", {}], "sectorKey"]] ===
       {"e1", "e1_e2", "e2", "top"}
     ],
   "numericCoefficientSystem" -> TrueQ[
     Lookup[smokeLinearSystem, "numericCoefficientSystemQ", False] &&
      Lookup[smokeLinearSystem, "coefficientVariables", {"missing"}] === {}
     ],
   "numericDummyAppended" -> TrueQ[
     Lookup[smokeKiraInput, "numericDummyAppendedQ", False] &&
      Lookup[smokeKiraInput, "numericDummyIntegralId", 0] === Lookup[smokeLinearSystem, "integralCount", -1] + 1
     ],
   "initiateOnlyJobsYAML" -> TrueQ[
     StringContainsQ[smokeJobsText, "run_initiate: true"] &&
      StringContainsQ[smokeJobsText, "run_firefly: false"] &&
      ! StringContainsQ[smokeJobsText, "kira2math"]
     ],
   "allKiraFilesWritten" -> And @@ (FileExistsQ /@ expectedKiraFiles),
   "runScriptDisabledByDefault" -> TrueQ[
     ! FileExistsQ[FileNameJoin[{smokeOutputDirectory, "run.sh"}]] &&
      ! StringQ[Lookup[smokeKiraInput, "run.sh", Missing["runScriptDisabled"]]]
     ],
   "noForbiddenDerivativeIndices" -> TrueQ[
     Lookup[smokeSeedBatch, "forbiddenNData", {"missing"}] === {} &&
      Lookup[smokeSeedBatch, "eomCanonicalQ", False]
     ]
   |>;

smokeCheckSummary = <|
   "checkedCount" -> Length[smokeCheckResults],
   "passedCount" -> Count[Values[smokeCheckResults], True],
   "failedNames" -> Keys@Select[smokeCheckResults, ! TrueQ[#] &],
   "workspace" -> smokeOutputDirectory
   |>;

Print[smokeCheckSummary];

If[And @@ Values[smokeCheckResults], Exit[0], Print[smokeCheckResults]; Exit[1]];