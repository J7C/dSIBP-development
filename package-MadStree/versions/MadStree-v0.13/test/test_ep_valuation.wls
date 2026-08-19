(* ::Package:: *)

(***
文件：test_ep_valuation.wls
用途：验证 ep Laurent valuation 对常数、零点、pole、Gamma 和相消表达式的精确下标。
范围：只测试结构 helper，不调用数值后端。
***)

(* ::Chapter:: *)
(*加载与精确正反例*)

Get[FileNameJoin[{DirectoryName[$InputFileName], "_harness.wls"}]];
msTestLoadKernel[];

expressions = {
  (-4 - 2 ep)/2,
  ep,
  ep^2 (1 + ep),
  1/ep,
  1/ep^3 + 2,
  Gamma[2 + ep],
  Gamma[ep],
  Exp[ep logX] - 1
};
expected = {0, 1, 2, -1, -3, 0, -1, 1};
actual = MadStree`Private`msEpLaurentValuation[#, ep, 3] & /@ expressions;

Print["series forms: ", InputForm[Series[#, {ep, 0, 3}] & /@ expressions]];
Print["valuation expected: ", InputForm[expected]];
Print["valuation actual: ", InputForm[actual]];
If[actual =!= expected, Exit[1]];
Quit[];
