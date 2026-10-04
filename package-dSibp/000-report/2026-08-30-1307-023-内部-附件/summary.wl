(* ::Package:: *)

(***
文件：summary.wl
用途：保存 dSIBP 023.0 内部独立检验的轻量机器摘要。
边界：本文件只汇总正式报告所需的身份、计数和证书范围，不作为程序包输入。
***)


(* ::Chapter:: *)
(*正式独立检验摘要*)

<|
  "schema" -> "dsibp_023_internal_independent_validation_report_v1",
  "status" -> "passed",
  "reportTime" -> "2026-08-30T13:07:00+08:00",
  "gitCommitAtValidation" -> "5941383E10D04C1736159EA67DE79D00820234E4",
  "packageVersion" -> "023.0",
  "packageSHA256" ->
    "7B729536E62EC22E8A726F2D245D4A602E73811C531CCDC3982218A80A151740",
  "manualSHA256" ->
    "0779696326FEA10B5DCDA3140E103ACDF06B6F3100B98D31B516825185E258C0",
  "taskBookSHA256" ->
    "FA29D987E0BD4ED6755C36909CD4804CC6FF4EC7D31DCE0A55A954C45893C7EB",
  "phase1AcceptedDigest" ->
    "7E9BC1D72D4D631DDAF8D532C9048D01D3E001F0560587D430D90C2718DD8DFC",
  "phase1" -> <|
    "frozenFileCount" -> 19,
    "authoritySourceCount" -> 4,
    "localChecks" -> {10, 10},
    "familyChecks" -> {171, 171},
    "oracleChecks" -> {34, 34},
    "timeRecordCount" -> 976,
    "momentumRecordCount" -> 1363,
    "parameterOperatorCount" -> 64
  |>,
  "parameterOperatorsAndCapabilities" -> <|
    "operatorChecks" -> {64, 64},
    "contextChecks" -> {18, 18},
    "capabilityChecks" -> {7, 7}
  |>,
  "phase2GeneralAndTree" -> <|
    "generalChecks" -> {15, 15},
    "treeAndGuardChecks" -> {11, 11},
    "singleMassiveSunriseBackendEnabled" -> False,
    "masslessTreeFormulaStatus" -> "PendingRederivation"
  |>,
  "paper2411TwoVertexGpp" -> <|
    "status" -> "passed",
    "seedCount" -> 9,
    "equationCount" -> 50,
    "integralCount" -> 40,
    "unknownCount" -> 35,
    "unknownRank" -> 35,
    "matrixEqualCounts" -> <|"k12" -> {25, 25}, "k34" -> {25, 25}, "ks" -> {25, 25}|>,
    "matrixNonzeroDifferenceCounts" -> <|"k12" -> 0, "k34" -> 0, "ks" -> 0|>
  |>,
  "pureMassiveBubble" -> <|
    "status" -> "passed",
    "sourceIntegralIdentities" -> {33, 33},
    "sourceActiveBasisIdentities" -> {19, 19},
    "seedTemplateCount" -> 88,
    "linearEquationCount" -> 5992,
    "formalEquationCount" -> 6012,
    "integralCount" -> 2966,
    "masterCount" -> 19,
    "targetCount" -> 215,
    "selectedEquationCount" -> 1368,
    "unreducedCount" -> 0,
    "deDimensions" -> {{19, 19}, {19, 19}},
    "scalingCertificateScope" -> "symbolic",
    "referenceEqualCounts" -> <|"P0" -> {361, 361}, "ip0" -> {361, 361}, "ks" -> {361, 361}|>,
    "kira" -> <|
      "version" -> "2.3 (Git: 2.3-7-geb541f9)",
      "parallelConfig" -> "w10*1",
      "wallTimeSeconds" -> 91.03,
      "exitStatus" -> 0
    |>,
    "manifestSHA256" ->
      "B780D4BA52388E794855D520C4126BCE70323E535CD66FD3929B5F7642DBA12D",
    "reductionSHA256" ->
      "4F0A55A033C45CAC293F4297D50DEB95BCD6F52668367E84669F96BF677CD5DE"
  |>,
  "mixBubbleTree" -> <|
    "status" -> "passed",
    "branch" -> "+++",
    "sourceIdentities" -> {81, 81},
    "rawExpandedEquationCount" -> 838694,
    "canonicalEquationCount" -> 818217,
    "formalEquationCount" -> 818297,
    "integralCount" -> 310769,
    "masterCount" -> 81,
    "rawMasterIDs" -> Range[81],
    "derivativeTargetCount" -> 595,
    "formalTargetCount" -> 676,
    "selectedEquationCount" -> 63410,
    "unreducedCount" -> 0,
    "deDimensions" -> ConstantArray[{81, 81}, 6],
    "scalingCertificateScope" -> "exactPoint",
    "scalingSymbolicQ" -> False,
    "matrixResidualNonzeroCount" -> 0,
    "sourceResidualNonzeroCount" -> 0,
    "parityMode" -> "allEvenCyclePropagators",
    "parityConstraints" -> {
      b[1] + n[1, 1] + n[1, 2] -> 0,
      b[2] + n[2, 1] + n[2, 2] -> 0
    },
    "fixedTreeBridgeLine" -> 3,
    "fixedTreeBridgeExcludedFromParity" -> True,
    "ordinaryExportedIntegralsCheckedForBridgePack" -> 310688,
    "kira" -> <|
      "version" -> "2.3 (Git: 2.3-7-geb541f9)",
      "parallelConfig" -> "w10*1",
      "wallTimeSeconds" -> 160.11,
      "exitStatus" -> 0
    |>,
    "manifestSHA256" ->
      "B3C9ED791EB2C0247A114FA2AC29B526A860DB77FD9B1C6921E8AA412A7A7106",
    "reductionSHA256" ->
      "7D66B032E78EB724B7EA643092CEAA1DCACA81AA3A6C2968D362E8127FD9C5BD"
  |>,
  "mixBasisDiscovery" -> <|
    "naturalOrderFoundQualifyingJump" -> False,
    "nonnegativePrefixProbe" -> <|
      "targetCount" -> 24594,
      "masterCount" -> 608,
      "interiorMasterCount" -> 100,
      "boundaryMasterCount" -> 508
    |>,
    "upperEnvelopeStabilityMasterCounts" -> {130, 106, 83, 81},
    "finalDirectionalProbe" -> <|
      "inputCandidateCount" -> 83,
      "stableMasterCount" -> 81,
      "eliminatedHighTimePowerCount" -> 2,
      "unreducedCount" -> 0
    |>
  |>,
  "publicFeedback" -> <|
    "dynamicCases" -> {21, 21},
    "runtimeMessages" -> {100, 100}
  |>,
  "manual" -> <|
    "pageCount" -> 34,
    "allPagesRenderedAndInspected" -> True,
    "undefinedReferenceCount" -> 0,
    "fatalErrorCount" -> 0,
    "overfullBoxCount" -> 0
  |>,
  "formalRelease" -> <|
    "pathChecks" -> {15, 15},
    "runtimeVersion" -> "023.0",
    "publicFunctionCount" -> 37,
    "exampleFileCount" -> 21,
    "executedExamples" -> <|
      "01_mixed_bubble_workflow.wl" -> 0,
      "02_function_system_hankel.wl" -> 0,
      "03_single_massive_sunrise/main.wl" -> 0,
      "05_tree_two_vertex_time_ibp/main.wl" -> 0,
      "06_mix_bubble_tree/main.wl" -> 0
    |>
  |>,
  "finalGates" -> <|
    "strictUTF8Files" -> 99,
    "invalidUTF8Count" -> 0,
    "replacementCharacterCount" -> 0,
    "wolframScriptCount" -> 88,
    "missingPackageHeaderCount" -> 0,
    "missingChapterCount" -> 0,
    "retiredRuntimeEntryCount" -> 0,
    "generatedArtifactFileCount" -> 0,
    "generatedArtifactDirectoryCount" -> 0,
    "exampleRuntimeDirectoryCount" -> 0,
    "gitDiffCheckPassed" -> True,
    "dSIBPStagedPathCount" -> 0,
    "unrelatedMadStreeStagedPathCount" -> 140
  |>,
  "sourceSummarySHA256" -> <|
    "phase1FrozenManifest" ->
      "20B73C443951440EF93C202AA0818B89ACF0E7A7E972A1EBF06201711B0CE8F1",
    "phase1OracleValidation" ->
      "FBE488FAF7B5098DBC0D8DA70ABACDD189F35868E3C9EE68475E783ADC39568B",
    "parameterOperatorsAndCapabilities" ->
      "B8623EFD912D925C57BC1C1798272893117EB05A1C0D741DD118121F400B11A3",
    "publicGuardFeedback" ->
      "907C4A81B6CC6D09418DECC4AB03E1C04431A52845C75729E8BE0A000ED99F7D",
    "paper2411TwoVertexGpp" ->
      "ADCD8935C4792087E9C59131D9DB7B4515ADBB5D094D7A036C73FF6C16B54F65",
    "purePrepare" ->
      "F3046C4572702B4AB2FD74A0F4E8C0550D50C3DB3160092E1F7BE54294F872E1",
    "pureFinish" ->
      "8AD511EB256596702E9D9879777F5E4567471747501B4ADDE3DB57F1B0EF680F",
    "pureReference" ->
      "98C27EEA78012C47F2C4C6BE49FCDF02C0122E9811BFA7DC8556D806517F61D1",
    "mixedPrepare" ->
      "657E39CB41F803D89CD575A79A50A29D560FC5C516D6CCF3779A998748DE8BFD",
    "mixedFinish" ->
      "9D527D97DCD233B8888046367B1D844AB85D44718A2776B069F29547981BE687"
  |>,
  "untestedBoundaries" -> {
    "single-massive sunrise stops after general seeds and parameter operators",
    "massless full-line tree formula routes remain PendingRederivation",
    "the pure-bubble reference producer and reference Kira were not rerun",
    "mixed bubble+tree reduction covers only the declared +++ branch and all-even cycle parity",
    "mixed reduction scaling is certified only at the recorded exact point"
  }
|>
