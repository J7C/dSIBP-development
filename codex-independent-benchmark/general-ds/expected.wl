(* ::Package:: *)
(* 本文件冻结 general-ds 的 upper-triangular 外动量导数、顶点相位链式法则和表达式乘积法则原语；不加载 dSIBP package。 *)

ClearAll["Global`*"];


(* ::Chapter:: *)
(*外不变量坐标与有序 Dij*)

(* ::Section::Closed:: *)
(*一个外动量的反解*)
upperDMatrix1 = {{2 s11}};
upperDCoefficients1 = Inverse[upperDMatrix1];
upperDResidual1 = Together /@ Flatten[
  upperDMatrix1 . upperDCoefficients1 - IdentityMatrix[1]
];


(* ::Section::Closed:: *)
(*两个外动量的反解*)
upperDMatrix2 = {
  {2 s11, 0, 0},
  {s12, s11, s12},
  {0, 2 s12, 2 s22}
};
upperDCoefficients2 = Simplify[Inverse[upperDMatrix2]];
upperDResidual2 = Together /@ Flatten[
  upperDMatrix2 . upperDCoefficients2 - IdentityMatrix[3]
];


(* ::Chapter:: *)
(*顶点相位与表达式乘积法则*)

(* ::Section::Closed:: *)
(*相位导数只记录独立系数，不绑定 package 的 J 表示*)
phaseShiftCoefficient[sign_Integer, energy_, variable_] := I sign D[energy, variable];

phasePrimitiveChecks = <|
  "plusIndependent" -> phaseShiftCoefficient[1, ke[1], ke[1]],
  "minusIndependent" -> phaseShiftCoefficient[-1, ke[1], ke[1]],
  "sqrtChain" -> phaseShiftCoefficient[1, Sqrt[s11], s11],
  "unrelatedEnergy" -> phaseShiftCoefficient[1, ke[3], s11]
|>;


(* ::Section::Closed:: *)
(*两个积分和纯系数项同时非零的固定模板*)
generalDSProductExpected[variable_, integralOne_, integralTwo_, dIntegralOne_, dIntegralTwo_] := (
  2*variable*integralOne + integralTwo + 3*variable^2 +
    variable^2*dIntegralOne + (variable + 1)*dIntegralTwo
);

generalDSProductResidual = Expand[
  2 x token1 + token2 + 3 x^2
    + x^2 dToken1 + (x + 1) dToken2
    - generalDSProductExpected[x, token1, token2, dToken1, dToken2]
];


(* ::Chapter:: *)
(*十个 loop family 的独立变量清单*)
generalDSVariableInventory = <|
  "atomic_massless_line" -> {E1, E2},
  "atomic_massive_line" -> {E1, E2},
  "pure_massless_bubble" -> {s11, E1, E2},
  "mixed_bubble" -> {s11, E1, E2},
  "mixed_triangle" -> {s11, s12, s22, E1, E2, E3},
  "mixed_sunrise" -> {s11, E1, E2},
  "pure_massive_bubble_reference" -> {s11, E1, E2},
  "two_loop_isp_toy" -> {s11, E1, E2},
  "parallel_massless_bundle_guard" -> {s11, s12, s22, E1, E2},
  "vertex_energy_signs-A" -> {s11, ke[1], ke[2]},
  "vertex_energy_signs-B" -> {s11, ke[2]},
  "vertex_energy_signs-C" -> {s11, ke[3], ke[2]}
|>;


(* ::Chapter:: *)
(*冻结前自检*)
generalDSExpectedSelfCheck = <|
  "upperDResidualCount" -> Length[Join[upperDResidual1, upperDResidual2]],
  "upperDResiduals" -> Join[upperDResidual1, upperDResidual2],
  "phasePrimitiveChecks" -> phasePrimitiveChecks,
  "productResidual" -> generalDSProductResidual,
  "inventoryCaseCount" -> Length[generalDSVariableInventory],
  "inventoryVariableCount" -> Total[Length /@ Values[generalDSVariableInventory]]
|>;

Print[InputForm[generalDSExpectedSelfCheck]];
