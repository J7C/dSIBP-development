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
    <|"id" -> 1, "externalLegEnergy" -> k1, "timePower" -> a1, "vertexType" -> "+"|>,
    <|"id" -> 2, "externalLegEnergy" -> k2, "timePower" -> a2, "vertexType" -> "+"|>,
    <|"id" -> 3, "externalLegEnergy" -> k3, "timePower" -> a3, "vertexType" -> "+"|>
  },
  "lines" -> {
    <|"type" -> "massless", "endpoints" -> {1, 2}, "momentum" -> q12, "nu" -> 1/2|>,
    <|"type" -> "massless", "endpoints" -> {2, 3}, "momentum" -> q23, "nu" -> 1/2|>
  }
|>;
context = MSInitTree[treeSpec];
de = MSDLogDE[context];
targetRules = {
  k1 -> 9 I, k2 -> 3 I, k3 -> 5 I,
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
  {1, 2, 3},
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
(*零边界能量失败传播*)

zeroEnergyParameter = Unique["msZeroEnergyT"];
zeroEnergyCurveData = <|
  "rank" -> AssociationThread[{1, 2, 3} -> Range[3]],
  "parameter" -> zeroEnergyParameter,
  "curveRules" -> {k1 -> 0, k2 -> 0, k3 -> 0},
  "retainedRules" -> {}
|>;
zeroEnergyMessageFreeQ = True;
zeroEnergySeries = Quiet@Check[
  MadStree`Private`msGenericSectorLeadingRecord[
    context,
    First[context["sectors"]],
    {0, 0},
    1,
    targetRules,
    zeroEnergyCurveData,
    80,
    {ep -> 0}
  ],
  zeroEnergyMessageFreeQ = False;
  $Failed
];
zeroEnergyFailureQ = MatchQ[
  zeroEnergySeries,
  Failure["VanishingComponentBoundaryEnergy", _Association]
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
certificateOptions[RankOrder] = {1, 2, 3};
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
Print["zero-energy failure: ", InputForm[zeroEnergySeries]];
If[
  Head[certificate] === Failure ||
    ! zeroEnergyMessageFreeQ ||
    ! zeroEnergyFailureQ ||
    certificate["status"] =!= "certified" ||
    certificate["leadingPower"] =!= 0 ||
    ! TrueQ[certificate["differentialEquationRegularAtEpZeroQ"]] ||
    ! TrueQ[certificate["boundaryFiniteLaurentAtEpZeroQ"]] ||
    ! TrueQ[certificate["boundaryDefinitionAnalyticAtEpZeroQ"]] ||
    Length[certificate["frobeniusResonanceRecords"]] =!= 3,
  Exit[1]
];
Quit[];
