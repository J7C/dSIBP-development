(* ::Package:: *)

(***
File: test_flintnde_massive_full_edge.wls
Purpose: Verifies the four-state top of a theta-carrying massive full edge, the contact subsector, the 2411 infinity boundary and the FlintNDE transport.
Run: wolframscript -file package-MadStree/versions/MadStree-v0.13/test/test_flintnde_massive_full_edge.wls
***)

(* ::Chapter:: *)
(* Loading and graph input *)

Get[FileNameJoin[{DirectoryName[$InputFileName], "_harness.wls"}]];
packageRoot = msTestLoadKernel[];

context = MSInitTree[<|
  "vertices" -> {
    <|"id" -> v1, "externalLegEnergy" -> k1, "timePower" -> a1, "vertexType" -> "+"|>,
    <|"id" -> v2, "externalLegEnergy" -> k2, "timePower" -> a2, "vertexType" -> "+"|>
  },
  "lines" -> {
    <|"type" -> "massive", "endpoints" -> {v1, v2},
      "momentum" -> q, "nu" -> nu|>
  }
|>];
targetRules = {k1 -> 9 I, k2 -> 3 I, q -> 1, nu -> 1/2, a1 -> 1, a2 -> 1};


(* ::Chapter:: *)
(* Infinity boundary and transport *)

directAtTarget = MSBoundaryData[
  context,
  targetRules,
  BoundaryScale -> 4,
  RankOrder -> {v1, v2},
  WorkingPrecision -> 32
];

transported = MSEvaluatePath[
  context,
  {targetRules},
  PythonExecutable -> msTestPythonExecutable[],
  BoundaryScale -> 4,
  RankOrder -> {v1, v2},
  WorkingPrecision -> 32,
  TransportOrder -> 72,
  ReferenceTransportOrder -> 96,
  TargetRelativeError -> "1e-14"
];


(* ::Chapter:: *)
(* Boundary provenance and transport summary *)

checks = <|
  "asymptoticBoundary" -> Lookup[directAtTarget, "method", None] ===
    "2411GenericSectorLeadingSeries",
  "fiveMasters" -> Length[MSMasterIntegrals[context]] === 5,
  "flintNDEPath" -> Length[transported["segments"]] >= 1,
  "transport" -> Lookup[transported, "status", None] === "computed",
  "sameDigest" -> Lookup[transported, "masterDigest", None] === context["masterDigest"],
  "refinement" -> TrueQ[transported["flintNDE", "targetRelativeErrorMet"]]
|>;

msTestSummary[checks, "MadStree massive full-edge"];

If[! And @@ Values[checks],
  Print["directAtTarget: ", InputForm[directAtTarget]];
  Print["transported: ", InputForm[transported]];
  Exit[1]
];
