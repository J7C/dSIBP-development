(* ::Package:: *)

(***
文件：test_flintnde_mixed_three_vertex.wls
用途：验证 mixed 三顶点公式系统已闭合，但未认证的自动无穷远边界必须结构化拒绝。
运行：wolframscript -file package-MadStree/test/test_flintnde_mixed_three_vertex.wls
***)

(* ::Chapter:: *)
(*加载与 mixed tree 输入*)

packageRoot = DirectoryName[DirectoryName[$InputFileName]];
AppendTo[$Path, FileNameJoin[{packageRoot, "Kernel"}]];
Needs["MadStree`"];

context = MSInitTree[<|
  "vertices" -> {
    <|"id" -> v1, "energy" -> k1, "timePower" -> a1, "phaseSign" -> 1|>,
    <|"id" -> v2, "energy" -> k2, "timePower" -> a2, "phaseSign" -> 1|>,
    <|"id" -> v3, "energy" -> k3, "timePower" -> a3, "phaseSign" -> 1|>
  },
  "lines" -> {
    <|"id" -> em, "type" -> "massiveFull", "endpoints" -> {v1, v2},
      "momentum" -> qm, "skType" -> "++", "nu" -> nu|>,
    <|"id" -> ez, "type" -> "masslessFull", "endpoints" -> {v2, v3},
      "momentum" -> qz, "skType" -> "++"|>
  }
|>];
targetRules = {
  k1 -> -8 I, k2 -> -4 I, k3 -> -2 I,
  qm -> 1, qz -> 1/2, nu -> 1/2,
  a1 -> 1, a2 -> 1, a3 -> 1
};


(* ::Chapter:: *)
(*自动边界能力边界*)

directAtTarget = MSBoundaryData[
  context,
  targetRules,
  BoundaryScale -> 2,
  RankOrder -> {v1, v2, v3},
  WorkingPrecision -> 26
];

transported = MSEvaluateTree[
  context,
  targetRules,
  BoundaryScale -> 3,
  RankOrder -> {v1, v2, v3},
  WorkingPrecision -> 26,
  TransportOrder -> 64,
  ReferenceTransportOrder -> 84,
  TargetRelativeError -> "1e-10"
];


(* ::Chapter:: *)
(*公式闭合与 fail-closed 汇总*)

checks = <|
  "fourSectors" -> Length[MSSectors[context]] === 4,
  "fifteenMasters" -> Length[MSMasterIntegrals[context]] === 15,
  "dlogClosed" -> MSDLogDE[context]["dlogStatus"] === "certifiedByFormulaChecks",
  "boundaryFailsClosed" -> Head[directAtTarget] === Failure &&
    directAtTarget[[1]] === "AsymptoticBoundaryFamilyUnsupported",
  "evaluationFailsClosed" -> Head[transported] === Failure &&
    transported[[1]] === "AsymptoticBoundaryFamilyUnsupported"
|>;

Print["MadStree mixed three-vertex checks: ", Count[Values[checks], True], "/", Length[checks]];
KeyValueMap[Print[#1, ": ", #2] &, checks];

If[! And @@ Values[checks],
  Print["directAtTarget: ", InputForm[directAtTarget]];
  Print["transported: ", InputForm[transported]];
  Exit[1]
];
