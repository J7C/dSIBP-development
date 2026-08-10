(* ::Package:: *)

(***
文件：04_three_vertex_tree.wl
用途：展示三顶点、两传播子的 massless 树图（+++ 顶点结构）从拓扑初始化到主积分、递推与 dlog DE 的最小流程。
结构：v1 --(q12)-- v2 --(q23)-- v3，两条 masslessFull 传播子，三个顶点 phaseSign 均为 +1。
运行：在 Mathematica 前端逐节执行，或用 wolframscript -file 运行整个文件。
***)

(* ::Chapter:: *)
(*加载 MadStree*)

packageRoot = DirectoryName[DirectoryName[$InputFileName]];
AppendTo[$Path, FileNameJoin[{packageRoot, "Kernel"}]];
Needs["MadStree`"];


(* ::Chapter:: *)
(*定义有序树拓扑（+++ 顶点结构）*)

treeSpec = <|
  "vertices" -> {
    <|"id" -> v1, "energy" -> k1, "timePower" -> a1, "phaseSign" -> 1|>,
    <|"id" -> v2, "energy" -> k2, "timePower" -> a2, "phaseSign" -> 1|>,
    <|"id" -> v3, "energy" -> k3, "timePower" -> a3, "phaseSign" -> 1|>
  },
  "lines" -> {
    <|"id" -> l12, "type" -> "masslessFull", "endpoints" -> {v1, v2},
      "momentum" -> q12, "skType" -> "++", "nu" -> 1/2|>,
    <|"id" -> l23, "type" -> "masslessFull", "endpoints" -> {v2, v3},
      "momentum" -> q23, "skType" -> "++", "nu" -> 1/2|>
  }
|>;

context = MSInitTree[treeSpec];
topKey = First[context["sectorOrder"]];
MSSectors[context]


(* ::Chapter:: *)
(*直接公式结果*)

masters = MSMasterIntegrals[context];
topMatrices = MSFormulaMatrices[context, topKey];
contactMaps = MSContactMaps[context, topKey];
dlogDE = MSDLogDE[context];

Lookup[masters, "integral"]

dlogDE["omegaPotential"] // MatrixForm


(* ::Chapter:: *)
(*迭代约化与自动数值边界*)

shiftedIntegral = MSIntegral[topKey, {1, 0, 0}, {0, 0}];
reduction = MSReduce[shiftedIntegral, context];
reduction["result"]

numericalTemplate = MSNumericalSystem[dlogDE];
numericalTemplate["status"]

targetRules = {
  k1 -> -9 I, k2 -> -3 I, k3 -> -5 I,
  q12 -> 1, q23 -> 2,
  a1 -> 1, a2 -> 1, a3 -> 1
};
boundary = MSBoundaryData[
  context,
  targetRules,
  BoundaryScale -> 4,
  WorkingPrecision -> 40
];

targetValue = MSEvaluateTree[
  context,
  targetRules,
  BoundaryScale -> 4,
  WorkingPrecision -> 40,
  TransportOrder -> 80,
  ReferenceTransportOrder -> 104,
  TargetRelativeError -> "1e-20"
];

targetValue["values"]
targetValue["flintNDE", "relativeDifferenceInf"]
