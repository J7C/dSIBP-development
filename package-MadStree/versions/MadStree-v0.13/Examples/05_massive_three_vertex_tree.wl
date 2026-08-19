(* ::Package:: *)

(***
File: 05_massive_three_vertex_tree.wl
Purpose: Demonstrates the minimal flow of a three-vertex, two-propagator massive tree graph (+++ contour vertices) from topology initialization to master integrals, recurrence and the dlog DE, followed by a batch multi-point evaluation (shared finite anchor) with CSV/JSON export.
Structure: 1 --(q12)-- 2 --(q23)-- 3. Vertex IDs are integers; propagators are internally numbered 1 and 2 in input order.
nu note: the massive propagators take non-half-integer nu values (nu12 = 3/4, nu23 = 1/3) to avoid representation degeneracies caused by half-integers.
Run: execute section by section in the Mathematica front end, or run the whole file with wolframscript -file.
***)

(* ::Chapter:: *)
(* Load MadStree *)

packageRoot = DirectoryName[DirectoryName[$InputFileName]];
AppendTo[$Path, FileNameJoin[{packageRoot, "Kernel"}]];
Needs["MadStree`"];


(* ::Chapter:: *)
(* Define ordered tree topology (+++ contour vertices; internal type is derived as massiveFull) *)

treeSpec = <|
  "vertices" -> {
    <|"id" -> 1, "externalLegEnergy" -> k1, "timePower" -> a1, "vertexType" -> "+"|>,
    <|"id" -> 2, "externalLegEnergy" -> k2, "timePower" -> a2, "vertexType" -> "+"|>,
    <|"id" -> 3, "externalLegEnergy" -> k3, "timePower" -> a3, "vertexType" -> "+"|>
  },
  "lines" -> {
    <|"type" -> "massive", "endpoints" -> {1, 2},
      "momentum" -> q12, "nu" -> nu12|>,
    <|"type" -> "massive", "endpoints" -> {2, 3},
      "momentum" -> q23, "nu" -> nu23|>
  }
|>;

context = MSInitTree[treeSpec];
topKey = First[context["sectorOrder"]];
MSSectors[context]


(* ::Chapter:: *)
(* Direct formula results *)

masters = MSMasterIntegrals[context];
topMatrices = MSFormulaMatrices[context, topKey];
contactMaps = MSContactMaps[context, topKey];
dlogDE = MSDLogDE[context];

Lookup[masters, "integral"]

dlogDE["omegaPotential"] // MatrixForm


(* ::Chapter:: *)
(* Iterative reduction and automatic numerical boundary *)

shiftedIntegral = MSIntegral[topKey, {1, 0, 0}, {0, 0, 0, 0}];
reduction = MSReduce[shiftedIntegral, context];
reduction["result"]

numericalTemplate = MSNumericalSystem[dlogDE];
numericalTemplate["status"]

targetRules = {
  k1 -> 9 I, k2 -> 3 I, k3 -> 5 I,
  q12 -> 1, q23 -> 2,
  nu12 -> 3/4, nu23 -> 1/3,
  a1 -> 1, a2 -> 1, a3 -> 1
};
boundary = MSBoundaryData[
  context,
  targetRules,
  BoundaryScale -> 4,
  WorkingPrecision -> 32
];

targetValue = MSEvaluatePath[
  context,
  {targetRules},
  BoundaryScale -> 4,
  WorkingPrecision -> 32,
  TransportOrder -> 72,
  ReferenceTransportOrder -> 96,
  TargetRelativeError -> "1e-14"
];

(* Failure gate: stop immediately if the transport failed, so the batch
   section (which reuses targetValue["values"]) does not cascade on a
   Failure. The package has already printed the backend diagnostic message. *)
If[Head[targetValue] === Failure,
  Print["Example failed at MSEvaluatePath: ", targetValue];
  Exit[1]
];

targetValue["values"]
Lookup[targetValue["flintNDE", "segments"], "relativeDifferenceInf"]


(* ::Chapter:: *)
(* Multipoint evaluation and export *)

batchFixedRules = {k3 -> 5 I, q12 -> 1, q23 -> 2, nu12 -> 3/4, nu23 -> 1/3, a1 -> 1, a2 -> 1, a3 -> 1};
batchPointSymbols = {k1, k2};
batchPointTable = {
  {8 I, 2 I},
  {7 I, 4 I},
  {6 I, 3 I},
  {9 I, 5 I}
};
batchPoints = Map[
  Join[batchFixedRules, Thread[batchPointSymbols -> #]] &,
  batchPointTable
];

batchEvaluation = MSEvaluatePath[
  context,
  batchPoints,
  FlintNDEPathPlanning -> True,
  BoundaryScale -> 4,
  WorkingPrecision -> 32,
  TransportOrder -> 72,
  ReferenceTransportOrder -> 96,
  TargetRelativeError -> "1e-14"
];
batchPointResults = If[
  AssociationQ[batchEvaluation],
  Lookup[batchEvaluation, "pointResults", {}],
  {}
];

Lookup[batchPointResults, "value"]
Lookup[batchPointResults, "status"]

batchExport = If[
  Head[batchEvaluation] === Failure,
  batchEvaluation,
  MSExportEvaluationData[
    batchEvaluation,
    MSOutputDirectory -> "results/madstree_evaluation_05",
    SignificantDigits -> 16
  ]
];
batchExport

(* ::Chapter:: *)
(* Failure gate *)

(* Exit non-zero when any stage produced a Failure, so a fresh run cannot
   report success while hiding errors. *)
exampleGateFailures = Select[
  {targetValue, batchEvaluation, batchExport},
  Head[#] === Failure &
];
If[exampleGateFailures =!= {},
  Print["Example FAILED: ", Length[exampleGateFailures], " result(s) are Failure objects."];
  Scan[Print["  ", #] &, exampleGateFailures];
  Exit[1]
];
Print["Example PASSED: all checked results are non-Failure."]
