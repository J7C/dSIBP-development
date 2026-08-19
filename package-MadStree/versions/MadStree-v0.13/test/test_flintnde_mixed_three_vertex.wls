(* ::Package:: *)

(***
File: test_flintnde_mixed_three_vertex.wls
Purpose: Verifies the generic Frobenius leading system of the four sectors of a mixed three-vertex graph and the FlintNDE transport.
Run: wolframscript -file package-MadStree/versions/MadStree-v0.13/test/test_flintnde_mixed_three_vertex.wls
***)

(* ::Chapter:: *)
(* Loading and mixed tree input *)

Get[FileNameJoin[{DirectoryName[$InputFileName], "_harness.wls"}]];
packageRoot = msTestLoadKernel[];

context = MSInitTree[<|
  "vertices" -> {
    <|"id" -> v1, "externalLegEnergy" -> k1, "timePower" -> a1, "vertexType" -> "+"|>,
    <|"id" -> v2, "externalLegEnergy" -> k2, "timePower" -> a2, "vertexType" -> "+"|>,
    <|"id" -> v3, "externalLegEnergy" -> k3, "timePower" -> a3, "vertexType" -> "+"|>
  },
  "lines" -> {
    <|"type" -> "massive", "endpoints" -> {v1, v2},
      "momentum" -> qm, "nu" -> nu|>,
    <|"type" -> "massless", "endpoints" -> {v2, v3},
      "momentum" -> qz|>
  }
|>];
targetRules = {
  k1 -> 8 I, k2 -> 4 I, k3 -> 2 I,
  qm -> 1, qz -> 1/2, nu -> 1/2,
  a1 -> 1, a2 -> 1, a3 -> 1
};


(* ::Chapter:: *)
(* Generic infinity boundary *)

directAtTarget = MSBoundaryData[
  context,
  targetRules,
  BoundaryScale -> 3,
  BoundarySeriesOrder -> 18,
  RankOrder -> {v1, v2, v3},
  WorkingPrecision -> 26
];

transported = MSEvaluatePath[
  context,
  {targetRules},
  PythonExecutable -> msTestPythonExecutable[],
  BoundaryScale -> 3,
  BoundarySeriesOrder -> 18,
  RankOrder -> {v1, v2, v3},
  WorkingPrecision -> 26,
  TransportOrder -> 36,
  ReferenceTransportOrder -> 48,
  TargetRelativeError -> "1e-10"
];


(* ::Chapter:: *)
(* Formula closure and transport summary *)

checks = <|
  "fourSectors" -> Length[MSSectors[context]] === 4,
  "fifteenMasters" -> Length[MSMasterIntegrals[context]] === 15,
  "dlogClosed" -> MSDLogDE[context]["dlogStatus"] === "certifiedByFormulaChecks",
  "genericBoundary" -> Lookup[directAtTarget, "method", None] ===
    "2411GenericSectorLeadingSeries" &&
    Length[Lookup[directAtTarget, "leadingBranches", {}]] === 15,
  "leadingResidual" -> And @@ Flatten[Map[
    PossibleZeroQ,
    Together[(#["frobeniusExponent"] IdentityMatrix[15] - directAtTarget["singularResidue"]).
      #["normalizedLeadingVector"]] & /@ directAtTarget["leadingBranches"],
    {2}
  ]],
  "flintNDEPath" -> Length[transported["segments"]] >= 1,
  "evaluationComputed" -> Lookup[transported, "status", None] === "computed",
  "sameDigest" -> Lookup[transported, "masterDigest", None] === context["masterDigest"]
|>;

msTestSummary[checks, "MadStree mixed three-vertex"];

If[! And @@ Values[checks],
  Print["directAtTarget: ", InputForm[directAtTarget]];
  Print["transported: ", InputForm[transported]];
  Exit[1]
];
