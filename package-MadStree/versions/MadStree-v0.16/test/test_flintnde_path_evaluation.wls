(* ::Package:: *)

(***
文件：test_flintnde_path_evaluation.wls
用途：验证 v0.16 连续复平面分组、FlintNDE 规划开关、fast dense 多点求值和零旧接口。
范围：使用单顶点可解析系统；自动规划与严格用户节点必须逐点互检。
***)

(* ::Chapter:: *)
(*加载与测试输入*)

Get[FileNameJoin[{DirectoryName[$InputFileName], "_harness.wls"}]];
packageRoot = msTestLoadKernel[];

context = MSInitTree[<|
  "vertices" -> {<|"id" -> v, "externalLegEnergy" -> k0, "timePower" -> a, "vertexType" -> "+"|>},
  "lines" -> {}
|>];
pointSequence = Prepend[
  Table[{I (8 - n/20)}, {n, 1, 100}],
  {k0}
];
singlePointSequence = Take[pointSequence, 2];
parameterRules = {a -> 1/3};
runtimeDirectory = FileNameJoin[{
  DirectoryName[$InputFileName], "results_test", "path-evaluation"
}];
commonOptions = {
  ParameterRules -> parameterRules,
  PythonExecutable -> msTestPythonExecutable[],
  MSRuntimeDirectory -> runtimeDirectory,
  BoundaryScale -> 8,
  WorkingPrecision -> 50,
  TransportOrder -> 72,
  ReferenceTransportOrder -> 96,
  TargetRelativeError -> "1e-22",
  MessageLanguage -> "CN"
};


(* ::Chapter:: *)
(*自动规划与严格用户节点*)

planned = MSEvaluatePath[
  context,
  pointSequence,
  FlintNDEPathPlanning -> True,
  Sequence @@ commonOptions
];

direct = MSEvaluatePath[
  context,
  pointSequence,
  FlintNDEPathPlanning -> False,
  Sequence @@ commonOptions
];


(* ::Chapter:: *)
(*负例与结果检查*)

badPlanningOption = MSEvaluatePath[
  context,
  pointSequence,
  FlintNDEPathPlanning -> "True",
  Sequence @@ commonOptions
];

badDirectJump = MSEvaluatePath[
  context,
  pointSequence,
  FlintNDEPathPlanning -> False,
  SingularityMode -> "SingularityJump",
  Sequence @@ DeleteCases[commonOptions, SingularityMode -> _]
];

missingParameterRuntime = FileNameJoin[{
  DirectoryName[$InputFileName], "results_test", "missing-parameter-must-not-start"
}];
missingParameterResult = MSEvaluatePath[
  context,
  singlePointSequence,
  ParameterRules -> {},
  PythonExecutable -> msTestPythonExecutable[],
  MSRuntimeDirectory -> missingParameterRuntime
];
overlappingParameterResult = MSEvaluatePath[
  context,
  singlePointSequence,
  ParameterRules -> {k0 -> 3 I, a -> 1/3}
];
formulaFailureRuntime = FileNameJoin[{
  DirectoryName[$InputFileName], "results_test", "formula-failure-must-not-start"
}];
formulaFailureResult = Block[{
    MadStree`Private`msEnsureFormulaArtifacts =
      Function[Failure["FormulaArtifactWriteFailed", <|"reason" -> "injected"|>]]
  },
  MSEvaluatePath[
    context,
    singlePointSequence,
    ParameterRules -> parameterRules,
    PythonExecutable -> "PYTHON_MUST_NOT_RUN",
    MSRuntimeDirectory -> formulaFailureRuntime
  ]
];
oldPositionalEpPower = MSReconstructEpSeries[context, ep, pointSequence, 0];
badEpSamplePoints = MSReconstructEpSeries[
  context, ep, singlePointSequence,
  ParameterRules -> parameterRules,
  EpSamplePoints -> {1/10, 1/10}
];
badEpMachineSample = MSReconstructEpSeries[
  context, ep, singlePointSequence,
  ParameterRules -> parameterRules,
  EpSamplePoints -> {0.1, 1/20}
];
badEpPointOverlap = MSReconstructEpSeries[
  context, ep, singlePointSequence,
  ParameterRules -> parameterRules,
  EpSamplePoints -> {1/10, 1/20},
  EpValidationPoints -> {1/20, 1/30}
];
badEpInitialPower = MSReconstructEpSeries[
  context, ep, singlePointSequence,
  ParameterRules -> parameterRules,
  MaximumEpPower -> 1,
  EpInitialInternalMaximumPower -> 0
];
badEpAngleRange = MSReconstructEpSeries[
  context, ep, singlePointSequence,
  ParameterRules -> parameterRules,
  EpSampleAngleRange -> {Pi/3, Pi/3}
];
badEpPointAngleCombination = MSReconstructEpSeries[
  context, ep, singlePointSequence,
  ParameterRules -> parameterRules,
  EpSamplePoints -> {1/10, 1/20, 1/30},
  EpSampleAngleRange -> {-Pi/3, Pi/3}
];

plannedValues = Lookup[Lookup[planned, "pointResults", {}], "value"];
directValues = Lookup[Lookup[direct, "pointResults", {}], "value"];
maximumDifference = Max[Abs[Flatten[plannedValues - directValues]]];
plannedSegment = First[Lookup[Lookup[planned, "flintNDE", <||>], "segments", {}]];
directSegment = First[Lookup[Lookup[direct, "flintNDE", <||>], "segments", {}]];
algorithms = DeleteCases[
  Lookup[Lookup[plannedSegment, "pointValues", {}], "evaluationAlgorithm"],
  Null
];
plannedFormulaArtifacts = Lookup[planned, "formulaArtifacts", <||>];
directFormulaArtifacts = Lookup[direct, "formulaArtifacts", <||>];

checks = <|
  "plannedComputed" -> Lookup[planned, "status", None] === "computed",
  "directComputed" -> Lookup[direct, "status", None] === "computed",
  "oneAffineSegment" -> Length[planned["segments"]] === 1 && Length[direct["segments"]] === 1,
  "plannedDense" -> Lookup[plannedSegment, "coveredSampleCount", 0] > 0,
  "fastMultipoint" -> MemberQ[algorithms, "fast"],
  "directUserNodes" -> Lookup[directSegment, "nodeCount", 0] === Length[Rest[pointSequence]] + 1,
  "directNoDense" -> Lookup[directSegment, "coveredSampleCount", -1] === 0,
  "pointwiseAgreement" -> TrueQ[maximumDifference < 10^-20],
  "analyticFormulaWrittenBeforeNDE" ->
    And @@ (FileExistsQ /@ Values[Lookup[plannedFormulaArtifacts, "files", <||>]]) &&
      Get[plannedFormulaArtifacts["files", "dlogDE"]] === MSDLogDE[context],
  "analyticFormulaReusedForSameContext" ->
    plannedFormulaArtifacts["outputDirectory"] === directFormulaArtifacts["outputDirectory"],
  "backendSchemaUnchanged" ->
    FreeQ[Lookup[planned, "flintNDE", <||>], "formulaArtifacts"],
  "formulaWriteFailureStopsBeforeNDE" ->
    MatchQ[formulaFailureResult, Failure["FormulaArtifactWriteFailed", _Association]] &&
      ! DirectoryQ[formulaFailureRuntime],
  "booleanRequired" -> MatchQ[badPlanningOption, Failure["FlintNDEPathPlanningBooleanRequired", _]],
  "directJumpRejected" -> MatchQ[badDirectJump, Failure["DirectTransportAvoidModeRequired", _]],
  "automaticUsesSingularLocalMode" ->
    MadStree`Private`msBackendSingularityMode["Automatic"] === "singularity_jump" &&
      MemberQ[Options[MSEvaluatePath], SingularityMode -> "Automatic"],
  "infinityTextPreserved" ->
    MadStree`Private`msParseFlintVector[{<|"text" -> "Infinity"|>}] === {"Infinity"},
  "missingParameterStopsBeforeNDE" ->
    MatchQ[missingParameterResult, Failure["IncompleteEvaluationParameters", _]] &&
    ! DirectoryQ[missingParameterRuntime] &&
    StringContainsQ[missingParameterResult[[2, "message"]], "NDE was not started"],
  "parameterCoordinateOverlapRejected" ->
    MatchQ[overlappingParameterResult, Failure["FixedAndRunningCoordinateOverlap", _]],
  "oldPublicSymbolsAbsent" -> And @@ (! NameQ[#] & /@ {
    "MadStree`MSGeneratePath", "MadStree`MSEvaluatePlannedPath", "MadStree`MSPlannedPathQ",
    "MadStree`MSEvaluateEpBatch"
  }),
  "adaptiveEpSeriesPublic" -> NameQ["MadStree`MSReconstructEpSeries"],
  "oldPositionalEpPowerRejected" ->
    MatchQ[oldPositionalEpPower, Failure["InvalidEpSeriesArguments", _]],
  "duplicateEpCandidatesRejected" ->
    MatchQ[badEpSamplePoints,
      Failure["EpSamplePointsExactDistinctNonzeroListRequired", _]],
  "machineEpCandidateRejected" ->
    MatchQ[badEpMachineSample,
      Failure["EpSamplePointsExactDistinctNonzeroListRequired", _]],
  "productionValidationOverlapRejected" ->
    MatchQ[badEpPointOverlap,
      Failure["EpProductionAndValidationPointsMustBeDisjoint", _]],
  "initialInternalPowerRangeChecked" ->
    MatchQ[badEpInitialPower, Failure["EpInitialInternalMaximumPowerRequired", _]],
  "openEpAngleRangeRequired" ->
    MatchQ[badEpAngleRange,
      Failure["EpSampleAngleRangeOpenRealIntervalRequired", _]],
  "epPointsAndAngleRangeExclusive" ->
    MatchQ[badEpPointAngleCombination,
      Failure["EpSamplePointsAndAngleRangeMutuallyExclusive", _]],
  "adaptiveEpSeriesDefaults" ->
    MemberQ[Options[MSReconstructEpSeries], MaximumEpPower -> 0] &&
    MemberQ[Options[MSReconstructEpSeries], EpGoalDigits -> 20] &&
    MemberQ[Options[MSReconstructEpSeries], EpSamplePoints -> Automatic] &&
    MemberQ[Options[MSReconstructEpSeries], EpSampleAngleRange -> Automatic] &&
    MemberQ[Options[MSReconstructEpSeries], EpValidationPoints -> Automatic] &&
    MemberQ[Options[MSReconstructEpSeries],
      EpInitialInternalMaximumPower -> Automatic] &&
    MemberQ[Options[MSReconstructEpSeries], ParallelTaskCount -> 12],
  "defaultWorkingPrecision" ->
    MemberQ[Options[MSBoundaryData], WorkingPrecision -> 200] &&
    MemberQ[Options[MSEvaluatePath], WorkingPrecision -> 200]
|>;

msTestSummary[checks, "MadStree v0.16 path evaluation"];
Print["maximumDifference: ", InputForm[maximumDifference]];
If[! And @@ Values[checks],
  Print["planned: ", InputForm[planned]];
  Print["direct: ", InputForm[direct]];
  Exit[1]
];
