(* ::Package:: *)

(***
文件：02_vertex_family_reduction.wl
用途：展示单顶点函数族专用输入、公式矩阵的局部张量逆，以及有限积分线性组合到完整主积分基的约化。
来源：v0.3 T4 已执行配置；本文件只移除验证断言，保留同一物理输入和公开接口。
运行：在 Mathematica 前端逐节执行，或用 wolframscript -file 运行整个文件。
***)

(* ::Chapter:: *)
(*加载 MadStree*)

packageRoot = DirectoryName[DirectoryName[$InputFileName]];
AppendTo[$Path, FileNameJoin[{packageRoot, "Kernel"}]];
Needs["MadStree`"];


(* ::Chapter:: *)
(*初始化单顶点函数族*)

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
(*约化有限线性组合*)

input = 2 MSIntegral[topKey, {1}, {0, 0}] -
  3 MSIntegral[topKey, {-1}, {1, 0}];

reduction = MSReduce[input, context];

reduction["status"]
reduction["masterBasis"]
reduction["coefficientVector"]
reduction["result"]
reduction["singularLayers"]


(* ::Chapter:: *)
(*指定完整主积分排列*)

reversedBasis = Reverse[masters];
reordered = MSReduce[input, context, MasterBasis -> reversedBasis];

reordered["masterBasis"]
reordered["coefficientVector"]
