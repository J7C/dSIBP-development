(* ::Package:: *)
(* 本脚本补充执行 repIterative0/repIterative 的 source-aware 单步、两级与确定性 probe。
   它复用已逐条通过的独立 expected 与 actual checker 定义，不读取其它项目文件。 *)

ClearAll["Global`*"];


(* ::Chapter:: *)
(*加载已验证的 fixed-family checker*)

workDir = If[$InputFileName =!= "", DirectoryName[$InputFileName], NotebookDirectory[]];
Get[FileNameJoin[{workDir, "actual_013_check.wl"}]];


(* ::Chapter:: *)
(*从全 seed 构造 source-aware rules*)

(* loop baseline a=0、b=0；每个 spectator state 均包含完整 local binary block。 *)
twoRecordsZero = Flatten[Table[
  DSTreeSeeds[vertex, J[{0, 0}, {{0, state[[1]], state[[2]]}}, {}], topoTwo],
  {state, twoStates}, {vertex, {v1, v2}}
], 1];


threeRecordsZero = Flatten[Table[
  DSTreeSeeds[vertex, J[{0, 0, 0}, {{0, state[[1]], state[[2]]}, {0, state[[3]], state[[4]]}}, {}], topoThree],
  {state, threeStates}, {vertex, {v1, v2, v3}}
], 1];


twoRuleData = makeTreeTimeReductionRules[twoRecordsZero, familyTwo];
threeRuleData = makeTreeTimeReductionRules[threeRecordsZero, familyThree];
twoContext = attachTreeTimeReductionRules[makeTreeSectorFamilies[topoTwo], twoRuleData];
threeContext = attachTreeTimeReductionRules[makeTreeSectorFamilies[topoThree], threeRuleData];


(* ::Chapter:: *)
(*repIterative0 单步与 repIterative 两级*)

setTreeFamilyContext[twoContext];
twoOneInput = J[{{-1, 1}, {0, 0}}];
twoOneRawStep = Expand[twoOneInput /. repIterative0];
twoOneByRule = FixedPoint[Expand[# /. repIterative0] &, twoOneInput, 20];
twoOneByAPI = Expand[repIterative[twoOneInput, Automatic, twoContext, MaxIterations -> 20]];


twoTwoInput = J[{{-2, 1}, {0, 0}}];
twoTwoByRules = FixedPoint[Expand[# /. repIterative0] &, twoTwoInput, 20];
twoTwoByAPI = Expand[repIterative[twoTwoInput, Automatic, twoContext, MaxIterations -> 40]];


setTreeFamilyContext[threeContext];
threeOneInput = J[{{0, 1}, {0, 0, 1}, {-1, 0}}];
threeOneRawStep = Expand[threeOneInput /. repIterative0];
threeOneByRule = FixedPoint[Expand[# /. repIterative0] &, threeOneInput, 20];
threeOneByAPI = Expand[repIterative[threeOneInput, Automatic, threeContext, MaxIterations -> 30]];


threeTwoInput = J[{{0, 1}, {0, 0, 1}, {-2, 0}}];
threeTwoByRules = FixedPoint[Expand[# /. repIterative0] &, threeTwoInput, 20];
threeTwoByAPI = Expand[repIterative[threeTwoInput, Automatic, threeContext, MaxIterations -> 40]];


(* v3 只连接 G+-，无 source；两级结果应等于独立 Aminus(mu-1).Aminus(mu)。 *)
v3 = familyThree["vertices"][[3]];
v3TwoStep = expectedTwoStep[v3["nu0"], v3["signedEnergy"],
  Lookup[v3["massiveLegs"], "energy"], Lookup[v3["massiveLegs"], "nu"]];
v3States = Independent013Expected`indBinaryStates[1];
v3Expected = Total[MapIndexed[
  v3TwoStep[[1, First[#2]]] J[{{0, 1}, {0, 0, 1}, Prepend[#1, 0]}] &,
  v3States
]];


(* ::Chapter:: *)
(*确定性参数与 master probe*)

allReducedMasters = DeleteDuplicates[Cases[
  {twoTwoByAPI, threeTwoByAPI}, int_J, {0, Infinity}
]];
deterministicMasterRules = MapIndexed[#1 -> Prime[First[#2] + 10]/Prime[First[#2] + 40] &, allReducedMasters];
twoNumericA = Together[twoTwoByRules /. parameterProbe /. deterministicMasterRules];
twoNumericB = Together[twoTwoByAPI /. parameterProbe /. deterministicMasterRules];
threeNumericA = Together[threeTwoByRules /. parameterProbe /. deterministicMasterRules];
threeNumericB = Together[threeTwoByAPI /. parameterProbe /. deterministicMasterRules];


rows = {
  <|"name" -> "two repIterative0 changes input", "pass" -> Not[SameQ[twoOneRawStep, twoOneInput]]|>,
  <|"name" -> "two source-aware single-step closure", "pass" -> strictZeroQ[twoOneByRule - twoOneByAPI]|>,
  <|"name" -> "two source-aware two level", "pass" -> strictZeroQ[twoTwoByRules - twoTwoByAPI]|>,
  <|"name" -> "three repIterative0 changes input", "pass" -> Not[SameQ[threeOneRawStep, threeOneInput]]|>,
  <|"name" -> "three source-aware single-step closure", "pass" -> strictZeroQ[threeOneByRule - threeOneByAPI]|>,
  <|"name" -> "three source-aware two level", "pass" -> strictZeroQ[threeTwoByRules - threeTwoByAPI]|>,
  <|"name" -> "three G+- independent two-step", "pass" -> strictZeroQ[threeTwoByAPI - v3Expected]|>,
  <|"name" -> "two deterministic probe", "pass" -> TrueQ[twoNumericA === twoNumericB],
    "routeA" -> twoNumericA, "routeB" -> twoNumericB|>,
  <|"name" -> "three deterministic probe", "pass" -> TrueQ[threeNumericA === threeNumericB],
    "routeA" -> threeNumericA, "routeB" -> threeNumericB|>
};


summary = <|
  "ruleStatusTwo" -> twoRuleData["status"], "ruleStatusThree" -> threeRuleData["status"],
  "sourceQTwo" -> twoRuleData["sourceQ"], "sourceQThree" -> threeRuleData["sourceQ"],
  "rows" -> rows, "pass" -> Count[rows[[All, "pass"]], True],
  "fail" -> Count[rows[[All, "pass"]], False],
  "parameterProbe" -> parameterProbe, "masterRules" -> deterministicMasterRules
|>;

Put[summary, FileNameJoin[{workDir, "iterative_013_check_result.wl"}]];
Print[InputForm[KeyTake[summary, {"ruleStatusTwo", "ruleStatusThree", "sourceQTwo", "sourceQThree", "pass", "fail", "rows"}]]];
