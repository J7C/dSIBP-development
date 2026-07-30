(* ::Package:: *)

(***
文件：test_flintnde_massless_edge.wls
用途：验证 massless full edge 的通用 multi-sector Frobenius 边界与 FlintNDE 输运。
运行：wolframscript -file package-MadStree/test/test_flintnde_massless_edge.wls
***)

(* ::Chapter:: *)
(*加载与图输入*)

packageRoot = DirectoryName[DirectoryName[$InputFileName]];
AppendTo[$Path, FileNameJoin[{packageRoot, "Kernel"}]];
Needs["MadStree`"];

context = MSInitTree[<|
  "vertices" -> {
    <|"id" -> v1, "energy" -> k1, "timePower" -> a1, "phaseSign" -> 1|>,
    <|"id" -> v2, "energy" -> k2, "timePower" -> a2, "phaseSign" -> 1|>
  },
  "lines" -> {
    <|"id" -> e, "type" -> "masslessFull", "endpoints" -> {v1, v2},
      "momentum" -> q, "skType" -> "++"|>
  }
|>];
targetRules = {k1 -> -9 I, k2 -> -3 I, q -> 1, a1 -> 1, a2 -> 1};


(* ::Chapter:: *)
(*通用无穷远边界*)

directAtTarget = MSBoundaryData[
  context,
  targetRules,
  BoundaryScale -> 3,
  RankOrder -> {v1, v2},
  WorkingPrecision -> 40
];

transported = MSEvaluateTree[
  context,
  targetRules,
  BoundaryScale -> 4,
  RankOrder -> {v1, v2},
  WorkingPrecision -> 40,
  TransportOrder -> 80,
  ReferenceTransportOrder -> 104,
  TargetRelativeError -> "1e-20"
];


(* ::Chapter:: *)
(*解析 time chambers 与 dlog 残差*)

(* 两个有序时间积分可化为同一个 Gauss 超几何闭式，用于防止 contact 符号漂移。 *)
orderedIntegral[a_, b_, lambdaA_, lambdaB_] := Module[{weight = a + b + 2},
  Gamma[weight] lambdaB^(-weight) Hypergeometric2F1[
    weight, a + 1, a + 2, -lambdaA/lambdaB
  ]/(a + 1)
];


definitionVector = {
  orderedIntegral[1, 1, I k1 - I q, I k2 + I q] +
    orderedIntegral[1, 1, I k2 - I q, I k1 + I q],
  -orderedIntegral[1, 1, I k1 - I q, I k2 + I q] +
    orderedIntegral[1, 1, I k2 - I q, I k1 + I q],
  Gamma[4] (I (k1 + k2))^-4
};
de = MSDLogDE[context];
connectionK1 = Map[D[#, k1] &, de["omegaPotential"], {2}];
connectionK2 = Map[D[#, k2] &, de["omegaPotential"], {2}];
definitionDEResidual = Together@FullSimplify@FunctionExpand@Join[
  D[definitionVector, k1] - connectionK1.definitionVector,
  D[definitionVector, k2] - connectionK2.definitionVector
] /. {a1 -> 1, a2 -> 1};
definitionValues = N[definitionVector /. targetRules, 40];
definitionRelativeDifference = Max@MapThread[
  Abs[#1 - #2]/Max[Abs[#2], 10^-35] &,
  {transported["values"], definitionValues}
];
residue = directAtTarget["singularResidue"];
indicialResiduals = Together[
    (#1 IdentityMatrix[Length[residue]] - residue).#2
  ] & @@@ ({#1["frobeniusExponent"], #1["normalizedLeadingVector"]} & /@
    directAtTarget["leadingBranches"]);


(* ::Chapter:: *)
(*公式闭合与输运汇总*)

checks = <|
  "threeMasters" -> Length[MSMasterIntegrals[context]] === 3,
  "dlogClosed" -> de["dlogStatus"] === "certifiedByFormulaChecks",
  "definitionDLogResidual" -> TrueQ[And @@ (PossibleZeroQ /@ definitionDEResidual)],
  "genericBoundary" -> Lookup[directAtTarget, "method", None] ===
    "2411GenericSectorLeadingSeries" &&
    Length[Lookup[directAtTarget, "leadingBranches", {}]] === 3,
  "indicialResidual" -> TrueQ[And @@ (PossibleZeroQ /@ Flatten[indicialResiduals])],
  "evaluationComputed" -> Lookup[transported, "status", None] === "computed",
  "sameDigest" -> Lookup[transported, "masterDigest", None] === context["masterDigest"],
  "definitionValue" -> TrueQ[definitionRelativeDifference < 10^-20]
|>;

Print["MadStree massless boundary checks: ", Count[Values[checks], True], "/", Length[checks]];
KeyValueMap[Print[#1, ": ", #2] &, checks];

If[! And @@ Values[checks],
  Print["directAtTarget: ", InputForm[directAtTarget]];
  Print["transported: ", InputForm[transported]];
  Print["definitionDEResidual: ", InputForm[definitionDEResidual]];
  Print["definitionRelativeDifference: ", InputForm[definitionRelativeDifference]];
  Exit[1]
];
