(* ::Package:: *)

(***
文件：test_flintnde_massless_edge.wls
用途：验证 massless full edge 的公式系统闭合，并对尚未认证的自动无穷远边界 fail closed。
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
(*自动边界能力边界*)

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
(*公式闭合与 fail-closed 汇总*)

checks = <|
  "threeMasters" -> Length[MSMasterIntegrals[context]] === 3,
  "dlogClosed" -> MSDLogDE[context]["dlogStatus"] === "certifiedByFormulaChecks",
  "boundaryFailsClosed" -> Head[directAtTarget] === Failure &&
    directAtTarget[[1]] === "AsymptoticBoundaryFamilyUnsupported",
  "evaluationFailsClosed" -> Head[transported] === Failure &&
    transported[[1]] === "AsymptoticBoundaryFamilyUnsupported"
|>;

Print["MadStree massless boundary checks: ", Count[Values[checks], True], "/", Length[checks]];
KeyValueMap[Print[#1, ": ", #2] &, checks];

If[! And @@ Values[checks],
  Print["directAtTarget: ", InputForm[directAtTarget]];
  Print["transported: ", InputForm[transported]];
  Exit[1]
];
