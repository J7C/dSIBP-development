(* ::Package:: *)

(***
文件：test_vertex_family_reduce.wls
用途：检查单顶点专用入口、局部张量逆、线性组合约化和用户主积分顺序。
运行：wolframscript -file package-MadStree/test/test_vertex_family_reduce.wls
***)

(* ::Chapter:: *)
(*加载与工具*)

packageRoot = DirectoryName[DirectoryName[$InputFileName]];
AppendTo[$Path, FileNameJoin[{packageRoot, "Kernel"}]];
Needs["MadStree`"];

checks = <||>;
record[name_, value_] := AssociateTo[checks, name -> TrueQ[value]];


(* ::Chapter:: *)
(*单顶点函数族*)

vertexContext = MSInitVertexFamily[<|
  "ki" -> {k0, k1, k2},
  "nui" -> {a0, nu1, nu2},
  "hankelBranches" -> {1, 2}
|>];

treeContext = MSInitTree[<|
  "vertices" -> {
    <|"id" -> v, "energy" -> k0, "timePower" -> a0|>
  },
  "lines" -> {
    <|"id" -> e1, "type" -> "massiveExternal", "endpoints" -> {v},
      "momentum" -> k1, "nu" -> nu1, "skType" -> "-", "hankelBranches" -> {1}|>,
    <|"id" -> e2, "type" -> "massiveExternal", "endpoints" -> {v},
      "momentum" -> k2, "nu" -> nu2, "skType" -> "+", "hankelBranches" -> {2}|>
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
  "k0" -> p0,
  "timePower" -> b0,
  "exponentialBlocks" -> {
    <|"momentum" -> q1, "phaseSign" -> 1|>,
    <|"momentum" -> q2, "phaseSign" -> -1|>
  },
  "hBlocks" -> {
    <|"momentum" -> x, "nu" -> mu, "hankelBranch" -> 1|>
  }
|>];
record["phaseBlocksAreOneDimensional", Lookup[explicitContext["vertexFamily", "exponentialBlocks"], "dimension"] === {1, 1}];
record["effectiveEnergy", explicitContext["vertexFamily", "effectiveEnergy"] === p0 + q1 - q2];


(* ::Chapter:: *)
(*局部逆与完整约化*)

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
(*汇总*)

passed = Count[Values[checks], True];
total = Length[checks];
Print["MadStree vertex/reduce checks: ", passed, "/", total];
KeyValueMap[Print[#1, ": ", #2] &, checks];
If[passed =!= total, Exit[1]];
