(* ::Package:: *)
(* 本文件冻结三个 ISP family 的标量积闭合与 numerator 自身导数插入项。它不加载 package，也不生成 base IBP；check 将这些独立插入项与 package 的 r=1/r=0 关系差分比较。 *)

ClearAll["Global`*"];


(* ::Chapter:: *)
(*标量积闭合*)

(* ::Section::Closed:: *)
(*mixed_sunrise 的五坐标反解*)
mixedSunriseScalarRules = {
  x11 -> den[1],
  x22 -> den[2],
  x1k -> rho[1],
  x2k -> rho[2],
  x12 -> (den[1] + den[2] + s11 - 2 rho[1] + 2 rho[2] - den[3])/2
};

mixedSunriseClosureResiduals = Together /@ ({
  x11 - den[1],
  x22 - den[2],
  x1k - rho[1],
  x2k - rho[2],
  x11 + x22 + s11 - 2 x12 - 2 x1k + 2 x2k - den[3]
} /. mixedSunriseScalarRules);


(* ::Section::Closed:: *)
(*two_loop_isp_toy 的五坐标反解*)
twoLoopToyScalarRules = {
  x11 -> den[1],
  x22 -> den[2],
  x12 -> rho[1] - den[1],
  x1k -> rho[2],
  x2k -> (den[3] - 3 den[1] - den[2] - s11 + 2 rho[1] + 2 rho[2])/2
};

twoLoopToyClosureResiduals = Together /@ ({
  x11 - den[1],
  x22 - den[2],
  x12 + x11 - rho[1],
  x1k - rho[2],
  x11 + x22 + s11 - 2 x12 - 2 x1k + 2 x2k - den[3]
} /. twoLoopToyScalarRules);


(* ::Section::Closed:: *)
(*vertex_energy_signs 的两坐标反解*)
vertexEnergyScalarRules = {
  x1k -> rho[1],
  x11 -> den[1] + 2 rho[1] - s11
};

vertexEnergyClosureResiduals = Together /@ ({
  x1k - rho[1],
  x11 + s11 - 2 x1k - den[1]
} /. vertexEnergyScalarRules);


(* ::Chapter:: *)
(*非零 ISP seed 的独立插入项*)

(* ::Section::Closed:: *)
(*记录格式与构造 helper*)
makeISPRecord[family_, seed_, generator_, insertion_] := <|
  "family" -> family,
  "ispSeed" -> seed,
  "generator" -> generator,
  "insertion" -> insertion,
  "zeroInsertion" -> TrueQ[insertion === 0]
|>;


(* ::Section::Closed:: *)
(*mixed_sunrise：两个非零 ISP 点乘六个生成元*)
mixedSunriseISPInsertions = {
  makeISPRecord["mixed_sunrise", {1, 0}, dqq[1, 1], rho[1]],
  makeISPRecord["mixed_sunrise", {1, 0}, dqq[1, 2], rho[2]],
  makeISPRecord["mixed_sunrise", {1, 0}, dqk[1, 1], s11],
  makeISPRecord["mixed_sunrise", {1, 0}, dqq[2, 1], 0],
  makeISPRecord["mixed_sunrise", {1, 0}, dqq[2, 2], 0],
  makeISPRecord["mixed_sunrise", {1, 0}, dqk[2, 1], 0],
  makeISPRecord["mixed_sunrise", {0, 1}, dqq[1, 1], 0],
  makeISPRecord["mixed_sunrise", {0, 1}, dqq[1, 2], 0],
  makeISPRecord["mixed_sunrise", {0, 1}, dqk[1, 1], 0],
  makeISPRecord["mixed_sunrise", {0, 1}, dqq[2, 1], rho[1]],
  makeISPRecord["mixed_sunrise", {0, 1}, dqq[2, 2], rho[2]],
  makeISPRecord["mixed_sunrise", {0, 1}, dqk[2, 1], s11]
};


(* ::Section::Closed:: *)
(*two_loop_isp_toy：两个非零 ISP 点乘六个生成元*)
twoLoopToyISPInsertions = {
  makeISPRecord["two_loop_isp_toy", {1, 0}, dqq[1, 1], rho[1] + den[1]],
  makeISPRecord["two_loop_isp_toy", {1, 0}, dqq[1, 2], den[2] + 2 rho[1] - 2 den[1]],
  makeISPRecord["two_loop_isp_toy", {1, 0}, dqk[1, 1], (den[3] - 3 den[1] - den[2] - s11 + 2 rho[1] + 6 rho[2])/2],
  makeISPRecord["two_loop_isp_toy", {1, 0}, dqq[2, 1], den[1]],
  makeISPRecord["two_loop_isp_toy", {1, 0}, dqq[2, 2], rho[1] - den[1]],
  makeISPRecord["two_loop_isp_toy", {1, 0}, dqk[2, 1], rho[2]],
  makeISPRecord["two_loop_isp_toy", {0, 1}, dqq[1, 1], rho[2]],
  makeISPRecord["two_loop_isp_toy", {0, 1}, dqq[1, 2], (den[3] - 3 den[1] - den[2] - s11 + 2 rho[1] + 2 rho[2])/2],
  makeISPRecord["two_loop_isp_toy", {0, 1}, dqk[1, 1], s11],
  makeISPRecord["two_loop_isp_toy", {0, 1}, dqq[2, 1], 0],
  makeISPRecord["two_loop_isp_toy", {0, 1}, dqq[2, 2], 0],
  makeISPRecord["two_loop_isp_toy", {0, 1}, dqk[2, 1], 0]
};


(* ::Section::Closed:: *)
(*vertex_energy_signs：固定非零 ISP 点乘两个生成元*)
vertexEnergyISPInsertions = {
  makeISPRecord["vertex_energy_signs", {1}, dqq[1, 1], rho[1]],
  makeISPRecord["vertex_energy_signs", {1}, dqk[1, 1], s11]
};

expectedISPInsertions = Join[
  mixedSunriseISPInsertions,
  twoLoopToyISPInsertions,
  vertexEnergyISPInsertions
];


(* ::Chapter:: *)
(*冻结前自检*)
ispExpectedSelfCheck = <|
  "closureResiduals" -> Join[
    mixedSunriseClosureResiduals,
    twoLoopToyClosureResiduals,
    vertexEnergyClosureResiduals
  ],
  "recordCount" -> Length[expectedISPInsertions],
  "nonzeroCount" -> Count[Lookup[expectedISPInsertions, "zeroInsertion"], False],
  "zeroCount" -> Count[Lookup[expectedISPInsertions, "zeroInsertion"], True]
|>;

Print[InputForm[ispExpectedSelfCheck]];
