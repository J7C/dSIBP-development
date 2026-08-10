(* ::Package:: *)

(***
File: 03_time_only_cycle_chart.wl
Purpose: Demonstrates time-only cycle initialization, the common-theta contact sector, the dlog DE and all strict time-rank chart certificates.
Source: configuration already executed as v0.3 T5; this file keeps representative public calls without copying validation assertions or private helper checks.
Run: execute section by section in the Mathematica front end, or run the whole file with wolframscript -file.
***)

(* ::Chapter:: *)
(* Load MadStree *)

packageRoot = DirectoryName[DirectoryName[$InputFileName]];
AppendTo[$Path, FileNameJoin[{packageRoot, "Kernel"}]];
Needs["MadStree`"];


(* ::Chapter:: *)
(* Initialize the triangle time-only graph *)

spec = <|
  "vertices" -> {
    <|"id" -> t1, "energy" -> k1, "timePower" -> a1|>,
    <|"id" -> t2, "energy" -> k2, "timePower" -> a2|>,
    <|"id" -> t3, "energy" -> k3, "timePower" -> a3|>
  },
  "lines" -> {
    <|"id" -> l12, "type" -> "masslessFull", "endpoints" -> {t1, t2},
      "momentum" -> q12, "skType" -> "++", "nu" -> 1/2|>,
    <|"id" -> l23, "type" -> "masslessFull", "endpoints" -> {t2, t3},
      "momentum" -> q23, "skType" -> "++", "nu" -> 1/2|>,
    <|"id" -> l31, "type" -> "masslessFull", "endpoints" -> {t3, t1},
      "momentum" -> q31, "skType" -> "++", "nu" -> 1/2|>
  }
|>;

context = MSInitTimeGraph[spec];
sectors = MSSectors[context];
de = MSDLogDE[context];

Lookup[sectors, {"sectorKey", "contractedLineIds", "masterCount"}]
de["dlogStatus"]


(* ::Chapter:: *)
(* Build all strict-rank chart certificates *)

targetRules = {
  k1 -> -11 I, k2 -> -7 I, k3 -> -5 I,
  a1 -> 0, a2 -> 0, a3 -> 0,
  q12 -> 2, q23 -> 3, q31 -> 4
};

certificate = MSBoundaryChartCertificate[
  context,
  targetRules,
  RankOrder -> All
];

Lookup[certificate["charts"], {"rankOrder", "normalCrossingQ"}]


(* ::Chapter:: *)
(* Generate the Frobenius boundary of one ordered chart *)

boundary = MSBoundaryData[
  context,
  targetRules,
  BoundaryScale -> 3,
  BoundarySeriesOrder -> 12,
  RankOrder -> {t1, t2, t3},
  WorkingPrecision -> 30
];

boundary["method"]
Length[boundary["leadingBranches"]]
