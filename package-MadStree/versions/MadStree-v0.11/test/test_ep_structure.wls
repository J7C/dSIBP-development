(* ::Package:: *)

(***
文件：test_ep_structure.wls
用途：检查真实三顶点共同 ep 正规化在符号 dlog DE 与生产 Frobenius 边界中的 Laurent 结构。
范围：只读取同源生产者对象，不调用 Python/FlintNDE，不生成正式验证结果。
***)

(* ::Chapter:: *)
(*加载与真实三顶点输入*)

Get[FileNameJoin[{DirectoryName[$InputFileName], "_harness.wls"}]];
packageRoot = msTestLoadKernel[];

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
de = MSDLogDE[context];
targetRules = {
  k1 -> -9 I, k2 -> -3 I, k3 -> -5 I,
  q12 -> 1, q23 -> 2,
  a1 -> 1 + ep, a2 -> 1 + ep, a3 -> 1 + ep
};


(* ::Chapter:: *)
(*同源符号边界对象*)

seriesData = MadStree`Private`msGenericSectorFrobeniusData[
  context,
  de,
  targetRules,
  4,
  {v1, v2, v3},
  8,
  80,
  {ep -> 0}
];

Print["seriesData head: ", Head[seriesData]];
If[Head[seriesData] === Failure,
  Print[InputForm[seriesData]];
  Exit[1]
];


(* ::Chapter:: *)
(*结构摘要*)

residue = Simplify[de["letterMatrices"] /. targetRules];
branchSummary = Map[
  <|
    "sectorKey" -> #["sectorKey"],
    "frobeniusExponent" -> #["frobeniusExponent"],
    "physicalWeight" -> #["physicalWeight"],
    "normalizedLeadingVector" -> #["normalizedLeadingVector"]
  |> &,
  seriesData["leadingBranches"]
];

Print["master count: ", de["masterCount"]];
Print["branch count: ", Length[branchSummary]];
Print["residue ep free: ", FreeQ[residue, ep]];
Print["branch summary: ", InputForm[branchSummary]];
certificateOptions = Association[Options[MSReconstructEpSeries]];
certificateOptions[BoundaryScale] = 4;
certificateOptions[BoundarySeriesOrder] = 8;
certificateOptions[WorkingPrecision] = 80;
certificateOptions[RankOrder] = {v1, v2, v3};
certificate = MadStree`Private`msEpLaurentSupportCertificate[
  context,
  ep,
  {targetRules},
  0,
  certificateOptions
];
Print["certificate: ", InputForm[certificate]];
deEntries = Flatten[{
  Values[de["letterMatrices"]] /. targetRules,
  seriesData["singularConnection"],
  seriesData["singularResidue"]
}];
deValuations = MadStree`Private`msEpLaurentValuation[#, ep, 0] & /@ deEntries;
negativePositions = Flatten@Position[deValuations, value_ /; NumberQ[value] && value < 0];
Print["negative DE entry count: ", Length[negativePositions]];
Print["negative DE entries: ", InputForm[
  ({#, deValuations[[#]], deEntries[[#]]} & /@ negativePositions)
]];
If[
  Head[certificate] === Failure ||
    certificate["status"] =!= "certified" ||
    certificate["leadingPower"] =!= 0 ||
    ! TrueQ[certificate["differentialEquationRegularAtEpZeroQ"]] ||
    ! TrueQ[certificate["boundaryFiniteLaurentAtEpZeroQ"]] ||
    ! TrueQ[certificate["boundaryDefinitionAnalyticAtEpZeroQ"]] ||
    Length[certificate["frobeniusResonanceRecords"]] =!= 3,
  Exit[1]
];
Quit[];
