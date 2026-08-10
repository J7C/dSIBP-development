(* ::Package:: *)

(***
File: 02_vertex_family_reduction.wl
Purpose: Demonstrates the dedicated single-vertex function-family input, the local tensor inverse of the formula matrices, and the reduction of a finite linear combination of integrals to the full master-integral basis.
Source: configuration already executed as v0.3 T4; this file only removes the validation assertions and keeps the same physical input and public interface.
Run: execute section by section in the Mathematica front end, or run the whole file with wolframscript -file.
***)

(* ::Chapter:: *)
(* Load MadStree *)

packageRoot = DirectoryName[DirectoryName[$InputFileName]];
AppendTo[$Path, FileNameJoin[{packageRoot, "Kernel"}]];
Needs["MadStree`"];


(* ::Chapter:: *)
(* Initialize the single-vertex function family *)

context = MSInitVertexFamily[<|
  "ki" -> {k0, k1, k2},
  "nui" -> {a0, nu1, nu2},
  "hankelBranches" -> {1, 2}
|>];
topKey = First[context["sectorOrder"]];

masters = Lookup[MSMasterIntegrals[context], "integral"];
formula = MSFormulaMatrices[context, topKey];

masters
Simplify[formula["UInverse"].formula["U"]] // MatrixForm


(* ::Chapter:: *)
(* Reduce a finite linear combination *)

input = 2 MSIntegral[topKey, {1}, {0, 0}] -
  3 MSIntegral[topKey, {-1}, {1, 0}];

reduction = MSReduce[input, context];

reduction["status"]
reduction["masterBasis"]
reduction["coefficientVector"]
reduction["result"]
reduction["singularLayers"]


(* ::Chapter:: *)
(* Specify the full master-integral ordering *)

reversedBasis = Reverse[masters];
reordered = MSReduce[input, context, MasterBasis -> reversedBasis];

reordered["masterBasis"]
reordered["coefficientVector"]


(* ::Chapter:: *)
(* Failure gate *)

(* Exit non-zero when any stage produced a Failure, so a fresh run cannot
   report success while hiding errors. *)
exampleGateFailures = Select[
  {context, reduction, reordered},
  Head[#] === Failure &
];
If[exampleGateFailures =!= {},
  Print["Example FAILED: ", Length[exampleGateFailures], " result(s) are Failure objects."];
  Scan[Print["  ", #] &, exampleGateFailures];
  Exit[1]
];
Print["Example PASSED: all checked results are non-Failure."]
