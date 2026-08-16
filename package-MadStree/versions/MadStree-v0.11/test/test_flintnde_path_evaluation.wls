(* ::Package:: *)

(***
文件：test_flintnde_path_evaluation.wls
用途：验证 v0.11 连续复平面分组、FlintNDE 规划开关、fast dense 多点求值和零旧接口。
范围：使用单顶点可解析系统；自动规划与严格用户节点必须逐点互检。
***)

(* ::Chapter:: *)
(*加载与测试输入*)

Get[FileNameJoin[{DirectoryName[$InputFileName], "_harness.wls"}]];
packageRoot = msTestLoadKernel[];

context = MSInitTree[<|
  "vertices" -> {<|"id" -> v, "energy" -> k0, "timePower" -> a, "phaseSign" -> 1|>},
  "lines" -> {}
|>];
points = Table[{k0 -> -I (8 - n/20), a -> 1/3}, {n, 1, 100}];
runtimeDirectory = FileNameJoin[{
  DirectoryName[$InputFileName], "results_test", "path-evaluation"
}];
commonOptions = {
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
  points,
  FlintNDEPathPlanning -> True,
  Sequence @@ commonOptions
];

direct = MSEvaluatePath[
  context,
  points,
  FlintNDEPathPlanning -> False,
  Sequence @@ commonOptions
];


(* ::Chapter:: *)
(*负例与结果检查*)

badPlanningOption = MSEvaluatePath[
  context,
  points,
  FlintNDEPathPlanning -> "True",
  Sequence @@ commonOptions
];

badDirectJump = MSEvaluatePath[
  context,
  points,
  FlintNDEPathPlanning -> False,
  SingularityMode -> "SingularityJump",
  Sequence @@ DeleteCases[commonOptions, SingularityMode -> _]
];

oldPositionalEpPower = MSReconstructEpSeries[context, ep, points, 0];
badEpSamplePoints = MSReconstructEpSeries[
  context, ep, First[points],
  EpSamplePoints -> {1/10, 1/10}
];
badEpMachineSample = MSReconstructEpSeries[
  context, ep, First[points],
  EpSamplePoints -> {0.1, 1/20}
];
badEpPointOverlap = MSReconstructEpSeries[
  context, ep, First[points],
  EpSamplePoints -> {1/10, 1/20},
  EpValidationPoints -> {1/20, 1/30}
];
badEpInitialPower = MSReconstructEpSeries[
  context, ep, First[points],
  MaximumEpPower -> 1,
  EpInitialInternalMaximumPower -> 0
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

checks = <|
  "plannedComputed" -> Lookup[planned, "status", None] === "computed",
  "directComputed" -> Lookup[direct, "status", None] === "computed",
  "oneAffineSegment" -> Length[planned["segments"]] === 1 && Length[direct["segments"]] === 1,
  "plannedDense" -> Lookup[plannedSegment, "coveredSampleCount", 0] > 0,
  "fastMultipoint" -> MemberQ[algorithms, "fast"],
  "directUserNodes" -> Lookup[directSegment, "nodeCount", 0] === Length[points] + 1,
  "directNoDense" -> Lookup[directSegment, "coveredSampleCount", -1] === 0,
  "pointwiseAgreement" -> TrueQ[maximumDifference < 10^-20],
  "booleanRequired" -> MatchQ[badPlanningOption, Failure["FlintNDEPathPlanningBooleanRequired", _]],
  "directJumpRejected" -> MatchQ[badDirectJump, Failure["DirectTransportAvoidModeRequired", _]],
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
  "adaptiveEpSeriesDefaults" ->
    MemberQ[Options[MSReconstructEpSeries], MaximumEpPower -> 0] &&
    MemberQ[Options[MSReconstructEpSeries], EpGoalDigits -> 20] &&
    MemberQ[Options[MSReconstructEpSeries], EpSamplePoints -> Automatic] &&
    MemberQ[Options[MSReconstructEpSeries], EpValidationPoints -> Automatic] &&
    MemberQ[Options[MSReconstructEpSeries],
      EpInitialInternalMaximumPower -> Automatic] &&
    MemberQ[Options[MSReconstructEpSeries], ParallelTaskCount -> 12],
  "defaultWorkingPrecision" ->
    MemberQ[Options[MSBoundaryData], WorkingPrecision -> 200] &&
    MemberQ[Options[MSEvaluatePath], WorkingPrecision -> 200]
|>;

msTestSummary[checks, "MadStree v0.11 path evaluation"];
Print["maximumDifference: ", InputForm[maximumDifference]];
If[! And @@ Values[checks],
  Print["planned: ", InputForm[planned]];
  Print["direct: ", InputForm[direct]];
  Exit[1]
];
