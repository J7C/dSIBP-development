(* ::Package:: *)

(***
文件：05_massive_three_vertex_tree.wl
用途：展示三顶点、两传播子的 massive 树图（+++ 顶点结构）从拓扑初始化到主积分、递推与 dlog DE 的最小流程。
结构：v1 --(q12)-- v2 --(q23)-- v3，两条 massiveFull 传播子，三个顶点 phaseSign 均为 +1。
nu 说明：massive 传播子各取非半整数 nu（nu12 = 3/4、nu23 = 1/3），避免半整数导致的表示退化。
运行：在 Mathematica 前端逐节执行，或用 wolframscript -file 运行整个文件。
***)

(* ::Chapter:: *)
(*加载 MadStree*)

packageRoot = DirectoryName[DirectoryName[$InputFileName]];
AppendTo[$Path, FileNameJoin[{packageRoot, "Kernel"}]];
Needs["MadStree`"];


(* ::Chapter:: *)
(*定义有序树拓扑（+++ 顶点结构，两条 massiveFull 传播子）*)

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
(*直接公式结果*)

masters = MSMasterIntegrals[context];
topMatrices = MSFormulaMatrices[context, topKey];
contactMaps = MSContactMaps[context, topKey];
dlogDE = MSDLogDE[context];

Lookup[masters, "integral"]

dlogDE["omegaPotential"] // MatrixForm


(* ::Chapter:: *)
(*迭代约化与自动数值边界*)

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

targetValue = MSEvaluateTree[
  context,
  targetRules,
  BoundaryScale -> 4,
  WorkingPrecision -> 32,
  TransportOrder -> 72,
  ReferenceTransportOrder -> 96,
  TargetRelativeError -> "1e-14"
];

targetValue["values"]
targetValue["flintNDE", "relativeDifferenceInf"]
