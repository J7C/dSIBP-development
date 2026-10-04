(* ::Package:: *)

(***
文件：test_time_ibp_domain.wls
用途：验证 MadStree 对小 t Frobenius 分支、正整数安全 shift、非正整数发散层和能量导数约化的处理。
范围：只调用当前 MadStree 公开初始化、递推、约化和 dlog 接口；不调用 Python/FlintNDE。
运行：wolframscript -file package-MadStree/versions/MadStree-v0.17/test/test_time_ibp_domain.wls
***)

(* ::Chapter:: *)
(*加载与纯指数单顶点*)

Get[FileNameJoin[{DirectoryName[$InputFileName], "_harness.wls"}]];
packageRoot = msTestLoadKernel[];

integerContext = MSInitTree[<|
  "vertices" -> {
    <|"id" -> 1, "externalLegEnergy" -> e, "timePower" -> 1, "vertexType" -> "+"|>
  },
  "lines" -> {}
|>];

sectorKey = First[integerContext["sectorOrder"]];
master = First@Lookup[MSMasterIntegrals[integerContext], "integral"];
safeNegativeIntegral = MSIntegral[sectorKey, {-1}, {}];
unsafeNegativeIntegral = MSIntegral[sectorKey, {-2}, {}];
raisedIntegral = MSIntegral[sectorKey, {1}, {}];

safeStep = MSRecurrenceStep[safeNegativeIntegral, integerContext];
safeReduction = MSReduce[safeNegativeIntegral, integerContext];
unsafeReduction = MSReduce[unsafeNegativeIntegral, integerContext];


(* ::Chapter:: *)
(*能量求导与公式 dlog 的双路线*)

vertexSign = integerContext["vertices"][[1, "vertexSign"]];
energyDerivativeIntegral = -I vertexSign raisedIntegral;
energyDerivativeReduction = MSReduce[energyDerivativeIntegral, integerContext];
dlog = MSDLogDE[integerContext];
dlogEnergyMatrix = Simplify[D[dlog["omegaPotential"], e]];
energyDerivativeResidual = Simplify[
  energyDerivativeReduction["coefficientVector"] - First[dlogEnergyMatrix]
];

linearExpression = 2 raisedIntegral + (e + 1) safeNegativeIntegral;
linearReduction = MSReduce[linearExpression, integerContext];
batchInput = {
  {raisedIntegral, 2 raisedIntegral + master},
  {safeNegativeIntegral + master}
};
batchReduction = MSReduce[batchInput, integerContext];
batchWithFailure = MSReduce[
  {{raisedIntegral}, {unsafeNegativeIntegral}},
  integerContext
];
emptyBatchReduction = MSReduce[{}, integerContext];
raggedBatchReduction = MSReduce[
  {raisedIntegral, {}, {{safeNegativeIntegral + master}, {raisedIntegral, master}}},
  integerContext
];


(* ::Chapter:: *)
(*两个 h 的四个小 t 分支与初始化拒绝*)

twoHContext = MSInitTree[<|
  "vertices" -> {
    <|"id" -> 7, "externalLegEnergy" -> p, "timePower" -> 1, "vertexType" -> "+"|>
  },
  "lines" -> {
    <|"type" -> "massive", "endpoints" -> {7}, "momentum" -> q1, "nu" -> 1/2|>,
    <|"type" -> "massive", "endpoints" -> {7}, "momentum" -> q2, "nu" -> 1/2|>
  }
|>];

twoHComponent = First[twoHContext["timeIBPDomainCertificate", "componentRecords"]];

masterPoleFailure = MSInitTree[<|
  "vertices" -> {
    <|"id" -> 9, "externalLegEnergy" -> p0, "timePower" -> -1, "vertexType" -> "+"|>
  },
  "lines" -> {}
|>];

regulatedContext = MSInitVertexFamily[<|
  "ki" -> {kr},
  "nui" -> {1 + ep}
|>];


(* ::Chapter:: *)
(*结构摘要*)

checks = <|
  "positiveIntegerContextAccepted" -> MSContextQ[integerContext],
  "safeShiftRecorded" ->
    integerContext["timeIBPDomainCertificate", "componentRecords"][[1, "minimumSafeShift"]] === -1,
  "safeNegativeStep" -> Lookup[safeStep, "status", None] === "reducedOneStep",
  "safeNegativeReduction" -> Lookup[safeReduction, "status", None] === "reduced" &&
    safeReduction["nonMasterResidual"] === 0,
  "unsafeShiftRejected" -> MatchQ[
    unsafeReduction,
    Failure["TimeIBPShiftHitsDivergentLayer", _Association]
  ],
  "unsafeShiftReportsVertex" -> Lookup[
    First@Lookup[unsafeReduction[[2]], "issues", {<||>}],
    "vertexIds",
    {}
  ] === {1},
  "energyDerivativeMatchesDLog" -> energyDerivativeResidual === {0},
  "linearCombinationReduced" -> Lookup[linearReduction, "status", None] === "reduced" &&
    linearReduction["remainingShiftedIntegrals"] === {} &&
    linearReduction["nonMasterResidual"] === 0,
  "nestedBatchShapeAndCoefficients" ->
    Lookup[batchReduction, "status", None] === "reduced" &&
      (Length /@ batchReduction["result"]) === {2, 1} &&
      batchReduction["coefficientVector"][[1, 1]] ===
        energyDerivativeReduction["coefficientVector"]/(-I vertexSign) &&
      batchReduction["nonMasterResidual"] === {{0, 0}, {0}},
  "batchFailurePosition" ->
    Lookup[batchWithFailure, "status", None] === "partiallyReduced" &&
      batchWithFailure["failurePositions"] === {{2, 1}} &&
      MatchQ[
        batchWithFailure["elementResults"][[2, 1, "failure"]],
        Failure["TimeIBPShiftHitsDivergentLayer", _Association]
      ],
  "emptyBatchPreservesShape" ->
    Lookup[emptyBatchReduction, "status", None] === "reduced" &&
      emptyBatchReduction["result"] === {} &&
      emptyBatchReduction["elementResults"] === {} &&
      emptyBatchReduction["failurePositions"] === {},
  "raggedBatchPreservesShape" ->
    Lookup[raggedBatchReduction, "status", None] === "reduced" &&
      raggedBatchReduction["nonMasterResidual"] === {0, {}, {{0}, {0, 0}}} &&
      raggedBatchReduction["remainingShiftedIntegrals"] === {{}, {}, {{{}}, {{}, {}}}} &&
      raggedBatchReduction["failurePositions"] === {},
  "twoHHasFourBranches" -> twoHComponent["hCount"] === 2 &&
    twoHComponent["branchCount"] === 4 &&
    Sort[Lookup[twoHComponent["branchRecords"], "gammaArgumentAtMaster"]] === {2, 3, 3, 4},
  "nonPositiveMasterRejected" -> MatchQ[
    masterPoleFailure,
    Failure["TimeIBPMasterRequiresRegularization", _Association]
  ],
  "regulatedGenericContextAccepted" -> MSContextQ[regulatedContext]
|>;

msTestSummary[checks, "MadStree time-IBP domain"];
Print["time-IBP certificate: ", InputForm[integerContext["timeIBPDomainCertificate"]]];
Print["energy derivative residual: ", InputForm[energyDerivativeResidual]];

If[! And @@ Values[checks],
  Print["safe step: ", InputForm[safeStep]];
  Print["safe reduction: ", InputForm[safeReduction]];
  Print["unsafe reduction: ", InputForm[unsafeReduction]];
  Print["two-h component: ", InputForm[twoHComponent]];
  Print["master-pole failure: ", InputForm[masterPoleFailure]];
  Exit[1]
];
