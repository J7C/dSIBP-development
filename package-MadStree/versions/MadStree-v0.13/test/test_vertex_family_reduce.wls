(* ::Package:: *)

(***
File: test_vertex_family_reduce.wls
Purpose: Checks the dedicated single-vertex entry, the local tensor inverse, the reduction of linear combinations and user master-integral orderings.
Run: wolframscript -file package-MadStree/versions/MadStree-v0.13/test/test_vertex_family_reduce.wls
***)

(* ::Chapter:: *)
(* Loading and utilities *)

Get[FileNameJoin[{DirectoryName[$InputFileName], "_harness.wls"}]];
packageRoot = msTestLoadKernel[];

checks = <||>;
record[name_, value_] := AssociateTo[checks, name -> TrueQ[value]];


(* ::Chapter:: *)
(* Single-vertex function family *)

vertexContext = MSInitVertexFamily[<|
  "ki" -> {k0, k1, k2},
  "nui" -> {a0, nu1, nu2},
  "hankelBranches" -> {1, 2}
|>];

unknownCompactField = MSInitVertexFamily[<|
  "ki" -> {k0, k1},
  "nui" -> {a0, nu1},
  "unexpectedField" -> True
|>];

treeContext = MSInitTree[<|
  "vertices" -> {
    <|"id" -> v, "externalLegEnergy" -> k0, "timePower" -> a0, "vertexType" -> "+"|>
  },
  "lines" -> {
    <|"type" -> "massive", "endpoints" -> {v},
      "momentum" -> k1, "nu" -> nu1, "hankelBranches" -> {1}|>,
    <|"type" -> "massive", "endpoints" -> {v},
      "momentum" -> k2, "nu" -> nu2, "hankelBranches" -> {2}|>
  }
|>];
vertexTopKey = First[vertexContext["sectorOrder"]];
treeTopKey = First[treeContext["sectorOrder"]];

record["vertexContext", MSContextQ[vertexContext] && vertexContext["contextKind"] === "vertexFamily"];
record["vertexSlots", MSSectors[vertexContext][[1, "slotCount"]] === 2];
record["vertexMasters", Length[MSMasterIntegrals[vertexContext]] === 4];
record[
  "formulaEquivalent",
  Simplify[
    MSFormulaMatrices[vertexContext, vertexTopKey]["components"][[1, {"M1", "M0", "M0Diagonal"}]] -
    MSFormulaMatrices[treeContext, treeTopKey]["components"][[1, {"M1", "M0", "M0Diagonal"}]]
  ] === <|"M1" -> ConstantArray[0, {4, 4}], "M0" -> ConstantArray[0, {4, 4}],
    "M0Diagonal" -> ConstantArray[0, {4, 4}]|>
];
record[
  "deEquivalent",
  Simplify[MSDLogDE[vertexContext]["omegaPotential"] - MSDLogDE[treeContext]["omegaPotential"]] ===
    ConstantArray[0, {4, 4}]
];

explicitContext = MSInitVertexFamily[<|
  "externalLegEnergy" -> p0,
  "timePower" -> b0,
  "exponentialBlocks" -> {
    <|"momentum" -> q1, "exponentType" -> "+"|>,
    <|"momentum" -> q2, "exponentType" -> "-"|>
  },
  "hBlocks" -> {
    <|"momentum" -> x, "nu" -> mu, "hankelBranch" -> 1|>
  }
|>];
unknownBlockField = MSInitVertexFamily[<|
  "externalLegEnergy" -> p0,
  "timePower" -> b0,
  "hBlocks" -> {
    <|"momentum" -> x, "nu" -> mu, "unexpectedField" -> True|>
  }
|>];
record["strictVertexFamilyFields",
  MatchQ[unknownCompactField, Failure["InvalidVertexFamilyInputFields", _Association]] &&
  MatchQ[unknownBlockField, Failure["InvalidVertexFamilyInput", _Association]]
];
record["phaseBlocksAreOneDimensional", Lookup[explicitContext["vertexFamily", "exponentialBlocks"], "dimension"] === {1, 1}];
record[
  "effectiveExternalLegEnergy",
  explicitContext["vertexFamily", "effectiveExternalLegEnergy"] === p0 + q1 - q2
];


(* ::Chapter:: *)
(* Local inverse and full reduction *)

formula = MSFormulaMatrices[vertexContext, vertexTopKey];
record["localTensorInverse", Simplify[formula["UInverse"].formula["U"]] === IdentityMatrix[4]];
record["M0Diagonal", DiagonalMatrixQ[formula["components"][[1, "M0Diagonal"]]]];

input = 2 MSIntegral[vertexTopKey, {1}, {0, 0}] - 3 MSIntegral[vertexTopKey, {-1}, {1, 0}];
reduced = MSReduce[input, vertexContext];
record["linearCombinationReduced", reduced["status"] === "reduced"];
record["noShiftedResidual", reduced["remainingShiftedIntegrals"] === {} && reduced["nonMasterResidual"] === 0];
record[
  "coefficientReconstructs",
  Simplify[Together[reduced["coefficientVector"].reduced["masterBasis"] - reduced["result"]]] === 0
];
record["memoUsed", IntegerQ[reduced["memoizedIntegralCount"]] && reduced["memoizedIntegralCount"] > 0];
record["singularLayersReported", Length[reduced["singularLayers"]] >= 2];

reversedBasis = Reverse[Lookup[MSMasterIntegrals[vertexContext], "integral"]];
reversed = MSReduce[input, vertexContext, MasterBasis -> reversedBasis];
record["customMasterOrder", reversed["masterBasis"] === reversedBasis];
record["customCoefficientOrder", reversed["coefficientVector"] === Reverse[reduced["coefficientVector"]]];
record["incompleteBasisRejected", Head[MSReduce[input, vertexContext, MasterBasis -> Rest[reversedBasis]]] === Failure];

kernelFiles = FileNames["*.wl", FileNameJoin[{packageRoot, "Kernel"}], Infinity];
record[
  "noGeneralInverseInFormulaCode",
  Select[
    kernelFiles,
    (StringContainsQ[#, "Formula"] || StringContainsQ[#, "DE"]) &&
      StringCases[Import[#, "Text"], RegularExpression["(^|[^A-Za-z0-9])Inverse\\["]] =!= {} &
  ] === {}
];


(* ::Chapter:: *)
(* Summary *)

msTestSummary[checks, "MadStree vertex/reduce checks"];
