(* ::Package:: *)

(***
File: 05_massive_three_vertex_tree.wl
Purpose: Demonstrates the minimal flow of a three-vertex, two-propagator massive tree graph (+++ vertex structure) from topology initialization to master integrals, recurrence and the dlog DE, followed by a batch multi-point evaluation (shared finite anchor) with CSV/JSON export.
Structure: v1 --(q12)-- v2 --(q23)-- v3, two massiveFull propagators, and all three vertices with phaseSign +1.
nu note: the massive propagators take non-half-integer nu values (nu12 = 3/4, nu23 = 1/3) to avoid representation degeneracies caused by half-integers.
Run: execute section by section in the Mathematica front end, or run the whole file with wolframscript -file.
***)

(* ::Chapter:: *)
(* Load MadStree *)

packageRoot = DirectoryName[DirectoryName[$InputFileName]];
AppendTo[$Path, FileNameJoin[{packageRoot, "Kernel"}]];
Needs["MadStree`"];


(* ::Chapter:: *)
(* Define ordered tree topology (+++ vertex structure, two massiveFull propagators) *)

treeSpec = <|
  "vertices" -> {
    <|"id" -> v1, "energy" -> k1, "timePower" -> a1, "phaseSign" -> 1|>,
    <|"id" -> v2, "energy" -> k2, "timePower" -> a2, "phaseSign" -> 1|>,
    <|"id" -> v3, "energy" -> k3, "timePower" -> a3, "phaseSign" -> 1|>
  },
  "lines" -> {
    <|"id" -> l12, "type" -> "massiveFull", "endpoints" -> {v1, v2},
      "momentum" -> q12, "skType" -> "++", "nu" -> nu12|>,
    <|"id" -> l23, "type" -> "massiveFull", "endpoints" -> {v2, v3},
      "momentum" -> q23, "skType" -> "++", "nu" -> nu23|>
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
  k1 -> -9 I, k2 -> -3 I, k3 -> -5 I,
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

batchFixedRules = {k3 -> -5 I, q12 -> 1, q23 -> 2, nu12 -> 3/4, nu23 -> 1/3, a1 -> 1, a2 -> 1, a3 -> 1};
batchPointSymbols = {k1, k2};
batchPointTable = {
  {-8 I, -2 I},
  {-7 I, -4 I},
  {-6 I, -3 I},
  {-9 I, -5 I}
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
