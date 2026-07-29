(* ::Package:: *)

(***
文件：test_flintnde_massive_full_edge.wls
用途：验证含 theta 的 massive full edge 四态 top、contact subsector、2411 无穷远边界及 FlintNDE 输运。
运行：wolframscript -file package-MadStree/test/test_flintnde_massive_full_edge.wls
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
    <|"id" -> e, "type" -> "massiveFull", "endpoints" -> {v1, v2},
      "momentum" -> q, "skType" -> "++", "nu" -> nu|>
  }
|>];
targetRules = {k1 -> -9 I, k2 -> -3 I, q -> 1, nu -> 1/2, a1 -> 1, a2 -> 1};


(* ::Chapter:: *)
(*无穷远边界与输运*)

directAtTarget = MSBoundaryData[
  context,
  targetRules,
  BoundaryScale -> 4,
  RankOrder -> {v1, v2},
  WorkingPrecision -> 32
];

transported = MSEvaluateTree[
  context,
  targetRules,
  BoundaryScale -> 4,
  RankOrder -> {v1, v2},
  WorkingPrecision -> 32,
  TransportOrder -> 72,
  ReferenceTransportOrder -> 96,
  TargetRelativeError -> "1e-14"
];


(* ::Chapter:: *)
(*边界来源与输运汇总*)

checks = <|
  "asymptoticBoundary" -> Lookup[directAtTarget, "method", None] ===
    "2411TwoVertexSectorLeadingSeries" &&
    Lookup[directAtTarget, "directIntegrationFallbackQ", True] === False,
  "fiveMasters" -> Length[MSMasterIntegrals[context]] === 5,
  "transport" -> Lookup[transported, "status", None] === "computed",
  "sameDigest" -> Lookup[transported, "masterDigest", None] === context["masterDigest"],
  "refinement" -> TrueQ[transported["flintNDE", "targetRelativeErrorMet"]]
|>;

Print["MadStree massive full-edge checks: ", Count[Values[checks], True], "/", Length[checks]];
KeyValueMap[Print[#1, ": ", #2] &, checks];

If[! And @@ Values[checks],
  Print["directAtTarget: ", InputForm[directAtTarget]];
  Print["transported: ", InputForm[transported]];
  Exit[1]
];
