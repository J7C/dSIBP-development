(* ::Package:: *)

(***
File: test_flintnde_vertex_family.wls
Purpose: Verifies that the dedicated single-vertex input and the equivalent topology input reuse the same automatic boundary, dlog DE and FlintNDE transport.
Run: wolframscript -file package-MadStree/versions/MadStree-v0.15/test/test_flintnde_vertex_family.wls
***)

(* ::Chapter:: *)
(* Loading and function family *)

Get[FileNameJoin[{DirectoryName[$InputFileName], "_harness.wls"}]];
packageRoot = msTestLoadKernel[];

context = MSInitVertexFamily[<|
  "ki" -> {k0, q},
  "nui" -> {a, nu},
  "hankelBranches" -> {2}
|>];
topologyContext = MSInitTree[<|
  "vertices" -> {
    <|"id" -> v, "externalLegEnergy" -> k0, "timePower" -> a, "vertexType" -> "+"|>
  },
  "lines" -> {
    <|"type" -> "massive", "endpoints" -> {v},
      "momentum" -> q, "nu" -> nu, "hankelBranches" -> {2}|>
  }
|>];
targetRules = {k0 -> 3 I, q -> 1, nu -> 1/2, a -> 2};
parameterRules = {q -> 1, nu -> 1/2, a -> 2};
singlePointSequence = {{k0}, {3 I}};
multipointSequence = {
  {k0},
  {3 I},
  {7 I/2},
  {4 I}
};


(* ::Chapter:: *)
(* Boundary and transport for both initialization interfaces *)

vertexBoundary = MSBoundaryData[
  context,
  targetRules,
  BoundaryScale -> 4,
  WorkingPrecision -> 32
];

topologyBoundary = MSBoundaryData[
  topologyContext,
  targetRules,
  BoundaryScale -> 4,
  WorkingPrecision -> 32
];

vertexResult = MSEvaluatePath[
  context,
  singlePointSequence,
  ParameterRules -> parameterRules,
  PythonExecutable -> msTestPythonExecutable[],
  BoundaryScale -> 4,
  WorkingPrecision -> 32,
  TransportOrder -> 64,
  ReferenceTransportOrder -> 88,
  TargetRelativeError -> "1e-16"
];

(* 单点是同一 pointSequence 表头下的一行值；多点调用只延长等宽值行。 *)
vertexMultipointResult = MSEvaluatePath[
  context,
  multipointSequence,
  ParameterRules -> parameterRules,
  PythonExecutable -> msTestPythonExecutable[],
  BoundaryScale -> 4,
  WorkingPrecision -> 32,
  TransportOrder -> 64,
  ReferenceTransportOrder -> 88,
  TargetRelativeError -> "1e-16"
];

topologyResult = MSEvaluatePath[
  topologyContext,
  singlePointSequence,
  ParameterRules -> parameterRules,
  PythonExecutable -> msTestPythonExecutable[],
  BoundaryScale -> 4,
  WorkingPrecision -> 32,
  TransportOrder -> 64,
  ReferenceTransportOrder -> 88,
  TargetRelativeError -> "1e-16"
];


(* ::Chapter:: *)
(* Comparison *)

relativeDifferences = MapThread[
  Abs[#1 - #2]/Max[Abs[#2], 10^-25] &,
  {vertexResult["values"], topologyResult["values"]}
];
singlePointValue = First[vertexResult["pointResults"]]["value"];
multipointFirstValue = First[vertexMultipointResult["pointResults"]]["value"];
singleMultipointRelativeDifference = Max[Abs[singlePointValue - multipointFirstValue]]/
  Max[Max[Abs[singlePointValue]], 10^-25];
checks = <|
  "vertexContext" -> Lookup[context, "contextKind", None] === "vertexFamily",
  "bothBoundariesGenerated" -> And @@ (
    Lookup[#, "status", None] === "generated" & /@ {vertexBoundary, topologyBoundary}
  ),
  "twoMasters" -> Length[MSMasterIntegrals[context]] === 2 &&
    Length[MSMasterIntegrals[topologyContext]] === 2,
  "dlogEquivalent" -> MSDLogDE[context]["connection"] === MSDLogDE[topologyContext]["connection"],
  "bothPathsReturned" -> Length[vertexResult["segments"]] >= 1 &&
    Length[topologyResult["segments"]] >= 1,
  "bothTransportsComputed" -> And @@ (
    Lookup[#, "status", None] === "computed" & /@ {vertexResult, topologyResult}
  ),
  "multipointTransportComputed" ->
    Lookup[vertexMultipointResult, "status", None] === "computed",
  "singlePointSequenceCount" -> Length[vertexResult["pointResults"]] === 1,
  "multipointSequenceCount" -> Length[vertexMultipointResult["pointResults"]] === 3,
  "singleMultipointCommonPoint" ->
    First[vertexResult["pointResults"]]["coordinate"] ===
      First[vertexMultipointResult["pointResults"]]["coordinate"],
  "singleMultipointAgreement" -> TrueQ[singleMultipointRelativeDifference < 10^-24],
  "numericalEquivalence" -> TrueQ[Max[relativeDifferences] < 10^-24],
  "refinement" -> And @@ (
    TrueQ[#1["flintNDE", "targetRelativeErrorMet"]] & /@ {vertexResult, topologyResult}
  )
|>;

msTestSummary[checks, "MadStree vertex-family NDE"];
Print["relativeDifferences: ", InputForm[relativeDifferences]];
Print["singleMultipointRelativeDifference: ", InputForm[singleMultipointRelativeDifference]];

If[! And @@ Values[checks],
  Print["vertexBoundary: ", InputForm[vertexBoundary]];
  Print["topologyBoundary: ", InputForm[topologyBoundary]];
  Print["vertexResult: ", InputForm[vertexResult]];
  Print["vertexMultipointResult: ", InputForm[vertexMultipointResult]];
  Print["topologyResult: ", InputForm[topologyResult]];
  Exit[1]
];
