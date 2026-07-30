(* ::Package:: *)

(***
文件：03_time_only_cycle_chart.wl
用途：展示 time-only 圈图初始化、共同-theta contact sector、dlog DE 和全部 strict time-rank chart 证书。
来源：v0.3 T5 已执行配置；本文件保留代表性公开调用，不复制验证断言和私有 helper 检查。
运行：在 Mathematica 前端逐节执行，或用 wolframscript -file 运行整个文件。
***)

(* ::Chapter:: *)
(*加载 MadStree*)

packageRoot = DirectoryName[DirectoryName[$InputFileName]];
AppendTo[$Path, FileNameJoin[{packageRoot, "Kernel"}]];
Needs["MadStree`"];


(* ::Chapter:: *)
(*初始化三角形 time-only 图*)

spec = <|
  "vertices" -> {
    <|"id" -> t1, "energy" -> k1, "timePower" -> a1|>,
    <|"id" -> t2, "energy" -> k2, "timePower" -> a2|>,
    <|"id" -> t3, "energy" -> k3, "timePower" -> a3|>
  },
  "lines" -> {
    <|"id" -> l12, "type" -> "masslessFull", "endpoints" -> {t1, t2},
      "momentum" -> q12, "skType" -> "++", "nu" -> 1/2|>,
    <|"id" -> l23, "type" -> "masslessFull", "endpoints" -> {t2, t3},
      "momentum" -> q23, "skType" -> "++", "nu" -> 1/2|>,
    <|"id" -> l31, "type" -> "masslessFull", "endpoints" -> {t3, t1},
      "momentum" -> q31, "skType" -> "++", "nu" -> 1/2|>
  }
|>;

context = MSInitTimeGraph[spec];
sectors = MSSectors[context];
de = MSDLogDE[context];

Lookup[sectors, {"sectorKey", "contractedLineIds", "masterCount"}]
de["dlogStatus"]


(* ::Chapter:: *)
(*构造全部 strict-rank chart 证书*)

targetRules = {
  k1 -> -11 I, k2 -> -7 I, k3 -> -5 I,
  a1 -> 0, a2 -> 0, a3 -> 0,
  q12 -> 2, q23 -> 3, q31 -> 4
};

certificate = MSBoundaryChartCertificate[
  context,
  targetRules,
  RankOrder -> All
];

Lookup[certificate["charts"], {"rankOrder", "normalCrossingQ"}]


(* ::Chapter:: *)
(*生成一个有序 chart 的 Frobenius 边界*)

boundary = MSBoundaryData[
  context,
  targetRules,
  BoundaryScale -> 3,
  BoundarySeriesOrder -> 12,
  RankOrder -> {t1, t2, t3},
  WorkingPrecision -> 30
];

boundary["method"]
Length[boundary["leadingBranches"]]
