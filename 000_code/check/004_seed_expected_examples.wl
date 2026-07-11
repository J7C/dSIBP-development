(* ::Package:: *)
(* 本文件保存两个小拓扑的手推 seed 层预期，用于和 004_dS_ibp_general.wl 的结构输出直接比较。
   它只比较 pack、离散态计数、生成元计数、手选样本、z 展开和少量 v.Qe 系数。
   本文件不自动运行，不生成解析 IBP 方程，也不做 rank/span/Solve/FullSimplify。 *)

BeginPackage["dSSeedExpected`"];

loadGeneralGenerator::usage = "loadGeneralGenerator[] 加载 004_dS_ibp_general.wl 到 Global` context。";
expectedSeedExamples::usage = "expectedSeedExamples[] 返回两个小拓扑的手推 seed 层预期。";
compareExpectedWithCurrentGenerator::usage = "compareExpectedWithCurrentGenerator[] 比较当前已加载生成器的 mixed case summary。";
runSeedExpectedStructureCheck::usage = "runSeedExpectedStructureCheck[] 加载 004 后做轻量结构比较。";

Begin["`Private`"];

ClearAll[
   seedExpectedBaseDir, projectRootFromCheckDir, loadGeneralGenerator,
   expectedMixedBubble, expectedMixedTriangle, expectedSeedExamples,
   compareExpectedField, compareExpectedCase, compareExpectedMomentumSeedMasslessBubble, compareExpectedMomentumSeedMixedBubbleBuildingBlock, compareExpectedMomentumSeedSunriseISP, compareExpectedMomentumSeedBatch, compareExpectedMomentumSeedBatchMixedBubbleEOM, compareExpectedTimeSeedMixedBubbleCore, compareExpectedTimeSeedBatchMixedBubbleEOM, compareExpectedMasslessEndpointCanonical, compareExpectedCanonicalSeedGateMixedBubble, compareExpectedDoubleShrinkCompactA, compareExpectedThreeVertexMultiShrinkCompactA, compareExpectedTopologyDataInterface, compareExpectedTopologyValidationReport, compareExpectedSectorKeyExactMatch, compareExpectedMasslessBundleMetadata, compareExpectedMasslessCrossTimeSeed, compareExpectedMassiveCrossGate, compareExpectedSeedClassificationAndSampledLinear, compareExpectedSeedMMASaveMixedBubble, compareExpectedKiraWorkspaceExportMixedBubble, compareExpectedKiraIntegralOrderingMixedBubble, compareExpectedMomentumLinearSystem, compareExpectedShrunkLineIBP, compareExpectedEOMCanonical, compareExpectedWithCurrentGenerator,
   compareExpectedMasslessBoxTopologyReplacement,
   dotVectorFromKey, lineMomentumFromKey, compareExpectedDotCoefficients, compareExpectedRepSP2Z,
   runSeedExpectedStructureCheck
   ];


(* ::Chapter:: *)
(*环境入口*)

(* 允许在本文件目录或项目根目录执行；只在用户显式调用 loadGeneralGenerator[] 时加载 004。 *)

seedExpectedBaseDir = If[StringQ[$InputFileName] && $InputFileName =!= "",
   DirectoryName[$InputFileName],
   If[TrueQ[$Notebooks],
    With[{nd = Quiet[NotebookDirectory[]]},
     If[StringQ[nd] && nd =!= $Failed, nd, Directory[]]
     ],
    Directory[]
    ]
   ];


projectRootFromCheckDir[] := Module[{dir = seedExpectedBaseDir},
   If[FileExistsQ[FileNameJoin[{dir, "..", "004_dS_ibp_general.wl"}]],
    ExpandFileName[FileNameJoin[{dir, ".."}]],
    dir
    ]
   ];


loadGeneralGenerator[] := Block[
   {$Context = "Global`", $ContextPath = {"System`", "Global`"}},
   Get[If[FileExistsQ[FileNameJoin[{projectRootFromCheckDir[], "005_dS_ibp_general.wl"}]], FileNameJoin[{projectRootFromCheckDir[], "005_dS_ibp_general.wl"}], FileNameJoin[{projectRootFromCheckDir[], "004_dS_ibp_general.wl"}]]]
   ];


(* ::Chapter:: *)
(*手推预期数据*)

(* 这里显式使用 Global` 符号，以便和 004 生成器的输出 SameQ 比较。 *)

expectedMixedBubble[] := <|
   "name" -> "mixedBubbleMassiveMassless",
   "linePacks" -> {{Global`b[1], Global`n[1, 1], Global`n[1, 2]}, {Global`b[2], Global`n[2]}},
   "baseIntegral" -> Global`J[{Global`a[1], Global`a[2]}, {{Global`b[1], Global`n[1, 1], Global`n[1, 2]}, {Global`b[2], Global`n[2]}}, {}],
   "discreteStateCount" -> 8,
   "momentumGeneratorCount" -> 2,
   "generatorCount" -> 4,
   "maxExpandedSeedCount" -> 32,
   "sampleDiscreteRules" -> {
     {Global`n[1, 1] -> 0, Global`n[1, 2] -> 0, Global`n[2] -> 0},
     {Global`n[1, 1] -> 1, Global`n[1, 2] -> 0, Global`n[2] -> 1}
     },
   "numericRules" -> {Global`dim -> 3, Global`kk[1, 1] -> 5, Global`nuM -> 2},
   "zExprs" -> {Global`qq[1, 1], Global`qq[1, 1] - 2 Global`qk[1, 1] + Global`kk[1, 1]},
   "spToZRules" -> {Global`qq[1, 1] -> Global`z[1], Global`qk[1, 1] -> (Global`z[1] + Global`kk[1, 1] - Global`z[2])/2},
   "dotCoefficients" -> <|
     {"q", 1, 1} -> Global`z[1],
     {"q", 1, 2} -> (Global`z[1] + Global`z[2] - Global`kk[1, 1])/2,
     {"k", 1, 1} -> (Global`z[1] + Global`kk[1, 1] - Global`z[2])/2,
     {"k", 1, 2} -> (Global`z[1] - Global`z[2] - Global`kk[1, 1])/2
     |>
   |>;


expectedMixedTriangle[] := <|
   "name" -> "mixedTriangleTwoMassiveOneMassless",
   "linePacks" -> {
     {Global`b[1], Global`n[1, 1], Global`n[1, 2]},
     {Global`b[2], Global`n[2, 1], Global`n[2, 2]},
     {Global`b[3], Global`n[3]}
     },
   "baseIntegral" -> Global`J[{Global`a[1], Global`a[2], Global`a[3]}, {{Global`b[1], Global`n[1, 1], Global`n[1, 2]}, {Global`b[2], Global`n[2, 1], Global`n[2, 2]}, {Global`b[3], Global`n[3]}}, {}],
   "discreteStateCount" -> 32,
   "momentumGeneratorCount" -> 3,
   "generatorCount" -> 6,
   "maxExpandedSeedCount" -> 192,
   "sampleDiscreteRules" -> {
     {Global`n[1, 1] -> 0, Global`n[1, 2] -> 0, Global`n[2, 1] -> 0, Global`n[2, 2] -> 0, Global`n[3] -> 0},
     {Global`n[1, 1] -> 1, Global`n[1, 2] -> 0, Global`n[2, 1] -> 0, Global`n[2, 2] -> 0, Global`n[3] -> 1},
     {Global`n[1, 1] -> 0, Global`n[1, 2] -> 1, Global`n[2, 1] -> 1, Global`n[2, 2] -> 0, Global`n[3] -> 0}
     },
   "numericRules" -> {Global`dim -> 3, Global`kk[1, 1] -> 5, Global`kk[1, 2] -> -1, Global`kk[2, 2] -> 7, Global`nuM -> 2},
   "zExprs" -> {
     Global`qq[1, 1],
     Global`qq[1, 1] - 2 Global`qk[1, 1] + Global`kk[1, 1],
     Global`qq[1, 1] + 2 Global`qk[1, 2] + Global`kk[2, 2]
     },
   "spToZRules" -> {
     Global`qq[1, 1] -> Global`z[1],
     Global`qk[1, 1] -> (Global`z[1] + Global`kk[1, 1] - Global`z[2])/2,
     Global`qk[1, 2] -> (Global`z[3] - Global`z[1] - Global`kk[2, 2])/2
     },
   "dotCoefficients" -> <|
     {"q", 1, 1} -> Global`z[1],
     {"q", 1, 2} -> (Global`z[1] + Global`z[2] - Global`kk[1, 1])/2,
     {"q", 1, 3} -> (Global`z[1] + Global`z[3] - Global`kk[2, 2])/2,
     {"k", 1, 1} -> (Global`z[1] + Global`kk[1, 1] - Global`z[2])/2,
     {"k", 1, 2} -> (Global`z[1] - Global`z[2] - Global`kk[1, 1])/2,
     {"k", 1, 3} -> (Global`z[1] + Global`kk[1, 1] - Global`z[2])/2 + Global`kk[1, 2],
     {"k", 2, 1} -> (Global`z[3] - Global`z[1] - Global`kk[2, 2])/2,
     {"k", 2, 2} -> (Global`z[3] - Global`z[1] - Global`kk[2, 2])/2 - Global`kk[1, 2],
     {"k", 2, 3} -> (Global`z[3] - Global`z[1] + Global`kk[2, 2])/2
     |>
   |>;

expectedMasslessBubblePerLineMergedTheta[] := <|
   "name" -> "bubbleMasslessMergedTheta",
   "bundleMode" -> "perLineMergedTheta",
   "linePacks" -> {{Global`b[1], Global`n[1]}, {Global`b[2], Global`n[2]}},
   "baseIntegral" -> Global`J[{Global`a[1], Global`a[2]}, {{Global`b[1], Global`n[1]}, {Global`b[2], Global`n[2]}}, {}],
   "discreteStateCount" -> 4,
   "momentumGeneratorCount" -> 2,
   "generatorCount" -> 4,
   "maxExpandedSeedCount" -> 16,
   "sampleDiscreteRules" -> {
     {Global`n[1] -> 0, Global`n[2] -> 0},
     {Global`n[1] -> 1, Global`n[2] -> 0},
     {Global`n[1] -> 0, Global`n[2] -> 1}
     },
   "numericRules" -> {Global`dim -> 3, Global`kk[1, 1] -> 5},
   "zExprs" -> {Global`qq[1, 1], Global`qq[1, 1] - 2 Global`qk[1, 1] + Global`kk[1, 1]},
   "spToZRules" -> {Global`qq[1, 1] -> Global`z[1], Global`qk[1, 1] -> (Global`z[1] + Global`kk[1, 1] - Global`z[2])/2},
   "dotCoefficients" -> <|
     {"q", 1, 1} -> Global`z[1],
     {"q", 1, 2} -> (Global`z[1] + Global`z[2] - Global`kk[1, 1])/2,
     {"k", 1, 1} -> (Global`z[1] + Global`kk[1, 1] - Global`z[2])/2,
     {"k", 1, 2} -> (Global`z[1] - Global`z[2] - Global`kk[1, 1])/2
     |>
   |>;


expectedMasslessBubbleBundledFuture[] := <|
   "name" -> "bubbleMasslessBundleFuture",
   "bundleMode" -> "bundledFuture",
   "comment" -> "同一对顶点的两条 massless 线共享两个 theta 区域；当前 package 未实现，不参与 check。",
   "linePacksSketch" -> {Global`masslessBundle[{1, 2}, {Global`b[1], Global`b[2]}, Global`nBundle[1, 2]]},
   "discreteStateCountSketch" -> 2,
   "maxExpandedSeedCountSketch" -> 8
   |>;


expectedMixedSunrisePerLineMergedTheta[] := <|
   "name" -> "sunriseOneMassiveTwoMasslessPerLineMergedTheta",
   "bundleMode" -> "perLineMergedTheta",
   "linePacks" -> {
     {Global`b[1], Global`n[1, 1], Global`n[1, 2]},
     {Global`b[2], Global`n[2]},
     {Global`b[3], Global`n[3]}
     },
   "baseIntegral" -> Global`J[{Global`a[1], Global`a[2]}, {{Global`b[1], Global`n[1, 1], Global`n[1, 2]}, {Global`b[2], Global`n[2]}, {Global`b[3], Global`n[3]}}, {Global`ispN[1], Global`ispN[2]}],
   "discreteStateCount" -> 16,
   "momentumGeneratorCount" -> 6,
   "generatorCount" -> 8,
   "maxExpandedSeedCount" -> 128,
   "sampleDiscreteRules" -> {
     {Global`n[1, 1] -> 0, Global`n[1, 2] -> 0, Global`n[2] -> 0, Global`n[3] -> 0},
     {Global`n[1, 1] -> 1, Global`n[1, 2] -> 0, Global`n[2] -> 1, Global`n[3] -> 0},
     {Global`n[1, 1] -> 0, Global`n[1, 2] -> 1, Global`n[2] -> 0, Global`n[3] -> 1}
     },
   "numericRules" -> {Global`dim -> 3, Global`kk[1, 1] -> 5, Global`nuM -> 2},
   "zExprs" -> {
     Global`qq[1, 1],
     Global`qq[2, 2],
     Global`qq[1, 1] - 2 Global`qq[1, 2] + Global`qq[2, 2] - 2 Global`qk[1, 1] + 2 Global`qk[2, 1] + Global`kk[1, 1]
     },
   "spToZRules" -> {
     Global`qq[1, 1] -> Global`z[1],
     Global`qq[2, 2] -> Global`z[2],
     Global`qq[1, 2] -> (Global`z[1] + Global`z[2] - 2 Global`qk[1, 1] + 2 Global`qk[2, 1] + Global`kk[1, 1] - Global`z[3])/2
     },
   "dotCoefficients" -> <|
     {"q", 1, 1} -> Global`z[1],
     {"q", 1, 2} -> (Global`z[1] + Global`z[2] - 2 Global`qk[1, 1] + 2 Global`qk[2, 1] + Global`kk[1, 1] - Global`z[3])/2,
     {"q", 1, 3} -> (Global`z[1] - Global`z[2] - 2 Global`qk[2, 1] - Global`kk[1, 1] + Global`z[3])/2,
     {"q", 2, 1} -> (Global`z[1] + Global`z[2] - 2 Global`qk[1, 1] + 2 Global`qk[2, 1] + Global`kk[1, 1] - Global`z[3])/2,
     {"q", 2, 2} -> Global`z[2],
     {"q", 2, 3} -> (Global`z[1] - Global`z[2] - 2 Global`qk[1, 1] + Global`kk[1, 1] - Global`z[3])/2,
     {"k", 1, 1} -> Global`qk[1, 1],
     {"k", 1, 2} -> Global`qk[2, 1],
     {"k", 1, 3} -> Global`qk[1, 1] - Global`qk[2, 1] - Global`kk[1, 1]
     |>
   |>;


expectedMixedSunriseBundledFuture[] := <|
   "name" -> "sunriseMasslessBundleFuture",
   "bundleMode" -> "bundledFuture",
   "comment" -> "线 2、3 是同一对顶点之间的 massless 线；未来可合并两条线的 theta 区域。当前 package 未实现，不参与 check。",
   "linePacksSketch" -> {
     {Global`b[1], Global`n[1, 1], Global`n[1, 2]},
     Global`masslessBundle[{2, 3}, {Global`b[2], Global`b[3]}, Global`nBundle[2, 3]]
     },
   "discreteStateCountSketch" -> 8,
   "maxExpandedSeedCountSketch" -> 64
   |>;

expectedSeedExamples[] := <|
   "masslessBubble" -> expectedMasslessBubblePerLineMergedTheta[],
   "mixedBubble" -> expectedMixedBubble[],
   "mixedTriangle" -> expectedMixedTriangle[],
   "mixedSunrise" -> expectedMixedSunrisePerLineMergedTheta[],
   "futureBundled" -> <|"masslessBubble" -> expectedMasslessBubbleBundledFuture[], "mixedSunrise" -> expectedMixedSunriseBundledFuture[]|>
   |>;


(* ::Chapter:: *)
(*比较函数*)

(* compareExpectedField 只做 SameQ 结构比较；不尝试化简等价表达式。 *)

compareExpectedField[got_Association, expected_Association, key_] := <|
   "key" -> key,
   "pass" -> TrueQ[Lookup[got, key, Missing["got"]] === Lookup[expected, key, Missing["expected"]]],
   "got" -> Lookup[got, key, Missing["got"]],
   "expected" -> Lookup[expected, key, Missing["expected"]]
   |>;


dotVectorFromKey[topo_Association, key_List] := If[key[[1]] === "q",
   topo["loopMomenta"][[key[[2]]]],
   topo["externalMomenta"][[key[[2]]]]
   ];


lineMomentumFromKey[topo_Association, key_List] := Lookup[topo["lines"], "momentum"][[key[[3]]]];


(* v.Qe 系数只做 Expand 后 SameQ；这些是 tiny seed-level 线性式。 *)
compareExpectedDotCoefficients[case_Association, expected_Association] := Module[
   {topo, rules, checks},
   topo = Global`parseTopology[case];
   rules = expected["spToZRules"];
   checks = (With[
        {key = #[[1]], expectedValue = Expand[#[[2]]]},
        With[
         {gotValue = Expand[Global`expandDotExpr[dotVectorFromKey[topo, key], lineMomentumFromKey[topo, key], topo] /. rules]},
         <|"key" -> key, "pass" -> TrueQ[gotValue === expectedValue], "got" -> gotValue, "expected" -> expectedValue|>
         ]
        ] &) /@ Normal[expected["dotCoefficients"]];
   <|"pass" -> And @@ (Lookup[checks, "pass"]), "checks" -> checks|>
   ];




(* repSP2Z 比较只检查 expected 中列出的规则，允许程序规则顺序不同。 *)
compareExpectedRepSP2Z[case_Association, expected_Association] := Module[
   {topo, ruleData, gotRules, checks},
   topo = Global`parseTopology[case];
   ruleData = Global`makeScalarProductRules[topo];
   gotRules = Lookup[ruleData, "repSP2Z", {}];
   checks = (With[{var = #[[1]], expectedValue = Expand[#[[2]]]},
        With[{gotValue = Expand[var /. gotRules]},
         <|"key" -> var, "pass" -> TrueQ[gotValue === expectedValue], "got" -> gotValue, "expected" -> expectedValue|>
         ]
        ] &) /@ expected["spToZRules"];
   <|
    "status" -> Lookup[ruleData, "status", Missing["status"]],
    "pass" -> TrueQ[Lookup[ruleData, "status"] === "computed"] && And @@ (Lookup[checks, "pass"]),
    "checks" -> checks,
    "solveVars" -> Lookup[ruleData, "solveVars", Missing["solveVars"]],
    "preservedISPVars" -> Lookup[ruleData, "preservedISPVars", Missing["preservedISPVars"]]
    |>
   ];

compareExpectedCase[case_Association, got_Association, expected_Association] := Module[
   {keys, checks, dotChecks, repChecks},
   keys = {"linePacks", "baseIntegral", "discreteStateCount", "momentumGeneratorCount", "generatorCount",
     "maxExpandedSeedCount", "sampleDiscreteRules", "numericRules", "zExprs"};
   checks = compareExpectedField[got, expected, #] & /@ keys;
   dotChecks = compareExpectedDotCoefficients[case, expected];
   repChecks = compareExpectedRepSP2Z[case, expected];
   <|
    "name" -> expected["name"],
    "pass" -> And @@ Join[Lookup[checks, "pass"], {dotChecks["pass"], repChecks["pass"]}],
    "checks" -> checks,
    "dotCoefficientChecks" -> dotChecks,
    "repSP2ZChecks" -> repChecks
    |>
   ];




(* 最小 propagator-only 动量 IBP seed：pure massless bubble, d/dq1 . q1。 *)
expectedMomentumSeedMasslessBubbleQ[] := Module[
   {aList, int0, intB1DownB2Up, intB2Up},
   aList = {Global`a[1], Global`a[2]};
   int0 = Global`J[aList, {{Global`b[1], Global`n[1]}, {Global`b[2], Global`n[2]}}, {}];
   intB1DownB2Up = Global`J[aList, {{Global`b[1] - 2, Global`n[1]}, {Global`b[2] + 2, Global`n[2]}}, {}];
   intB2Up = Global`J[aList, {{Global`b[1], Global`n[1]}, {Global`b[2] + 2, Global`n[2]}}, {}];
   Expand[
    Global`dim int0 - Global`b[1] int0 - (Global`b[2]/2) intB1DownB2Up -
     (Global`b[2]/2) int0 + (Global`b[2] Global`kk[1, 1]/2) intB2Up
    ]
   ];


compareExpectedMomentumSeedMasslessBubble[] := Module[
   {topo, int0, gen, got, expected},
   topo = Global`parseTopology[Global`bubbleMasslessCase];
   int0 = Global`makeBaseIntegral[topo];
   gen = SelectFirst[Global`makeIBPGenerators[topo], #["type"] === "momentum" && #["vectorType"] === "loop" && #["dLoop"] === 1 && #["vectorIndex"] === 1 &];
   got = Expand[Global`applyMomentumGeneratorSeed[topo, int0, gen]];
   expected = expectedMomentumSeedMasslessBubbleQ[];
   <|
    "name" -> "momentumSeedMasslessBubble_q1Dotq1_propagatorOnly",
    "pass" -> TrueQ[got === expected],
    "got" -> got,
    "expected" -> expected
    |>
   ];


expectedMomentumSeedMixedBubbleQ[] := Module[
   {aList, int0, intB1DownB2Up, intB2Up, intN11, intN12},
   aList = {Global`a[1], Global`a[2]};
   int0 = Global`J[aList, {{Global`b[1], Global`n[1, 1], Global`n[1, 2]}, {Global`b[2], Global`n[2]}}, {}];
   intB1DownB2Up = Global`J[aList, {{Global`b[1] - 2, Global`n[1, 1], Global`n[1, 2]}, {Global`b[2] + 2, Global`n[2]}}, {}];
   intB2Up = Global`J[aList, {{Global`b[1], Global`n[1, 1], Global`n[1, 2]}, {Global`b[2] + 2, Global`n[2]}}, {}];
   intN11 = Global`J[{Global`a[1] + 1, Global`a[2]}, {{Global`b[1] - 1, Global`n[1, 1] + 1, Global`n[1, 2]}, {Global`b[2], Global`n[2]}}, {}];
   intN12 = Global`J[{Global`a[1], Global`a[2] + 1}, {{Global`b[1] - 1, Global`n[1, 1], Global`n[1, 2] + 1}, {Global`b[2], Global`n[2]}}, {}];
   Expand[
    Global`dim int0 - Global`b[1] int0 - (Global`b[2]/2) intB1DownB2Up -
     (Global`b[2]/2) int0 + (Global`b[2] Global`kk[1, 1]/2) intB2Up + intN11 + intN12
    ]
   ];


compareExpectedMomentumSeedMixedBubbleBuildingBlock[] := Module[
   {topo, int0, gen, got, expected},
   topo = Global`parseTopology[Global`mixedBubbleCase];
   int0 = Global`makeBaseIntegral[topo];
   gen = SelectFirst[Global`makeIBPGenerators[topo], #["type"] === "momentum" && #["vectorType"] === "loop" && #["dLoop"] === 1 && #["vectorIndex"] === 1 &];
   got = Expand[Global`applyMomentumGeneratorSeed[topo, int0, gen]];
   expected = expectedMomentumSeedMixedBubbleQ[];
   <|
    "name" -> "momentumSeedMixedBubble_q1Dotq1_buildingBlock",
    "pass" -> TrueQ[got === expected],
    "got" -> got,
    "expected" -> expected
    |>
   ];

(* sunrise 的 q1 对外动量 seed 用来检查 ISP 分子指标是否真的参与吸收。 *)
expectedMomentumSeedSunriseQ1DotK[] := Module[
   {aList, intLine1ISP1, intLine3ISP1, intLine3ISP2, intLine3, intLine1N11ISP1, intLine1N12ISP1},
   aList = {Global`a[1], Global`a[2]};
   intLine1ISP1 = Global`J[aList, {{Global`b[1] + 2, Global`n[1, 1], Global`n[1, 2]}, {Global`b[2], Global`n[2]}, {Global`b[3], Global`n[3]}}, {Global`ispN[1] + 1, Global`ispN[2]}];
   intLine3ISP1 = Global`J[aList, {{Global`b[1], Global`n[1, 1], Global`n[1, 2]}, {Global`b[2], Global`n[2]}, {Global`b[3] + 2, Global`n[3]}}, {Global`ispN[1] + 1, Global`ispN[2]}];
   intLine3ISP2 = Global`J[aList, {{Global`b[1], Global`n[1, 1], Global`n[1, 2]}, {Global`b[2], Global`n[2]}, {Global`b[3] + 2, Global`n[3]}}, {Global`ispN[1], Global`ispN[2] + 1}];
   intLine3 = Global`J[aList, {{Global`b[1], Global`n[1, 1], Global`n[1, 2]}, {Global`b[2], Global`n[2]}, {Global`b[3] + 2, Global`n[3]}}, {Global`ispN[1], Global`ispN[2]}];
   intLine1N11ISP1 = Global`J[{Global`a[1] + 1, Global`a[2]}, {{Global`b[1] + 1, Global`n[1, 1] + 1, Global`n[1, 2]}, {Global`b[2], Global`n[2]}, {Global`b[3], Global`n[3]}}, {Global`ispN[1] + 1, Global`ispN[2]}];
   intLine1N12ISP1 = Global`J[{Global`a[1], Global`a[2] + 1}, {{Global`b[1] + 1, Global`n[1, 1], Global`n[1, 2] + 1}, {Global`b[2], Global`n[2]}, {Global`b[3], Global`n[3]}}, {Global`ispN[1] + 1, Global`ispN[2]}];
   Expand[-Global`b[1] intLine1ISP1 - Global`b[3] intLine3ISP1 + Global`b[3] intLine3ISP2 + Global`b[3] Global`kk[1, 1] intLine3 + intLine1N11ISP1 + intLine1N12ISP1]
   ];


compareExpectedMomentumSeedSunriseISP[] := Module[
   {topo, int0, gen, got, expected},
   topo = Global`parseTopology[Global`mixedSunriseCase];
   int0 = Global`makeBaseIntegral[topo];
   gen = SelectFirst[Global`makeIBPGenerators[topo], #["type"] === "momentum" && #["vectorType"] === "external" && #["dLoop"] === 1 && #["vectorIndex"] === 1 &];
   got = Expand[Global`applyMomentumGeneratorSeed[topo, int0, gen]];
   expected = expectedMomentumSeedSunriseQ1DotK[];
   <|
    "name" -> "momentumSeedSunrise_dq1Dotk1_ISPShift_buildingBlock",
    "pass" -> TrueQ[got === expected],
    "got" -> got,
    "expected" -> expected
    |>
   ];


compareExpectedEOMCanonical[] := Module[
   {topo, raw, got, expected, beforeBad, afterBad},
   topo = Global`parseTopology[Global`mixedBubbleCase];
   raw = Global`J[{Global`a[1], Global`a[2]}, {{Global`b[1], 2, 0}, {Global`b[2], Global`n[2]}}, {}];
   got = Expand[Global`applyEOM[raw, topo]];
   expected = Expand[
     -Global`J[{Global`a[1], Global`a[2]}, {{Global`b[1], 0, 0}, {Global`b[2], Global`n[2]}}, {}] -
      (2 Global`nuM + 1) Global`J[{Global`a[1] - 1, Global`a[2]}, {{Global`b[1] + 1, 1, 0}, {Global`b[2], Global`n[2]}}, {}]
     ];
   beforeBad = Global`forbiddenNData[topo, raw];
   afterBad = Global`forbiddenNData[topo, got];
   <|
    "name" -> "eomCanonical_mixedBubble_massiveLine_endpoint1",
    "pass" -> TrueQ[got === expected && Length[beforeBad] === 1 && afterBad === {} && ! Global`containsForbiddenNQ[topo, got]],
    "got" -> got,
    "expected" -> expected,
    "beforeForbiddenN" -> beforeBad,
    "afterForbiddenN" -> afterBad
    |>
   ];

expectedTimeSeedMixedBubbleTau1Core[] := Module[
   {aList, int0, intA1Down, intN11, intMasslessFlip, intBoundary, pref},
   aList = {Global`a[1], Global`a[2]};
   int0 = Global`J[aList, {{Global`b[1], Global`n[1, 1], Global`n[1, 2]}, {Global`b[2], Global`n[2]}}, {}];
   intA1Down = Global`J[{Global`a[1] - 1, Global`a[2]}, {{Global`b[1], Global`n[1, 1], Global`n[1, 2]}, {Global`b[2], Global`n[2]}}, {}];
   intN11 = Global`J[aList, {{Global`b[1] - 1, Global`n[1, 1] + 1, Global`n[1, 2]}, {Global`b[2], Global`n[2]}}, {}];
   intMasslessFlip = Global`J[aList, {{Global`b[1], Global`n[1, 1], Global`n[1, 2]}, {Global`b[2] - 1, 1 - Global`n[2]}}, {}];
   intBoundary = Global`J[{Global`a[1] + Global`a[2] - 1}, {{Global`b[1] + 1}, {Global`b[2], Global`n[2]}}, {}];
   pref = (4 I/Pi) Exp[Pi Im[Global`nuM]];
   Expand[-Global`a[1] intA1Down - I Global`p1 int0 + I intMasslessFlip - intN11 + pref KroneckerDelta[Global`n[1, 1] + Global`n[1, 2], 1] (-1)^Global`n[1, 1] intBoundary]
   ];


compareExpectedTimeSeedMixedBubbleCore[] := Module[
   {topo, int0, gen, got, expected},
   topo = Global`parseTopology[Global`mixedBubbleCase];
   int0 = Global`makeBaseIntegral[topo];
   gen = SelectFirst[Global`makeIBPGenerators[topo], #["type"] === "time" && #["vertex"] === 1 &];
   got = Expand[Global`applyTimeGeneratorSeed[topo, int0, gen]];
   expected = expectedTimeSeedMixedBubbleTau1Core[];
   <|
    "name" -> "timeSeedMixedBubble_tau1_core_withBoundaryShrink",
    "pass" -> TrueQ[got === expected],
    "got" -> got,
    "expected" -> expected
    |>
   ];


compareExpectedMasslessEndpointCanonical[] := Module[
   {topo, raw, got, expected, beforeBad, afterBad},
   topo = Global`parseTopology[Global`bubbleMasslessCase];
   raw = Global`J[{Global`a[1], Global`a[2]}, {{Global`b[1], 2}, {Global`b[2], 0}}, {}];
   got = Expand[Global`applySeedCanonical[raw, topo]];
   expected = Global`J[{Global`a[1], Global`a[2]}, {{Global`b[1] - 2, 0}, {Global`b[2], 0}}, {}];
   beforeBad = Global`forbiddenNData[topo, raw];
   afterBad = Global`forbiddenNData[topo, got];
   <|
    "name" -> "masslessEndpointCanonical_n2_to_bMinus2_n0",
    "pass" -> TrueQ[got === expected && Length[beforeBad] === 1 && afterBad === {} && ! Global`containsForbiddenNQ[topo, got]],
    "got" -> got,
    "expected" -> expected,
    "beforeForbiddenN" -> beforeBad,
    "afterForbiddenN" -> afterBad
    |>
   ];

compareExpectedTimeSeedBatchMixedBubbleEOM[] := Module[
   {topo, batch, equations},
   topo = Global`parseTopology[Global`mixedBubbleCase];
   batch = Global`makeTimeIBPSeedBatch[topo];
   equations = Lookup[Lookup[batch, "equations", {}], "equation", {}];
   <|
    "name" -> "timeSeedBatch_mixedBubble_EOMCanonical_corePending",
    "pass" -> TrueQ[
      batch["status"] === "generated" &&
       batch["continuousSeedRuleCount"] === 1 &&
       batch["discreteRuleCount"] === 2 &&
       batch["timeGeneratorCount"] === 2 &&
       batch["equationCount"] === 4 &&
       TrueQ[batch["eomCanonicalQ"]] &&
       batch["forbiddenNData"] === {} &&
       Sort[batch["pendingFeatures"]] === Sort[{"shrinkSectorSeedGeneration"}] &&
       ! TrueQ[batch["completeTimeIBPQ"]] &&
       ! FreeQ[equations, Global`nuM]
      ],
    "summary" -> KeyDrop[batch, "equations"]
    |>
   ];

compareExpectedMomentumSeedBatch[] := Module[
   {topo, batch, blocked},
   topo = Global`parseTopology[Global`bubbleMasslessCase];
   batch = Global`makeMomentumIBPSeedBatch[topo];
   blocked = Quiet[
    Global`makeContinuousSeedRules[topo, Global`UseSampleOnly -> False, Global`MaxSeedRuleCount -> 1],
    Global`makeContinuousSeedRules::toomany
    ];
   <|
    "name" -> "momentumSeedBatch_masslessBubble_sampleOnly_guard",
    "pass" -> TrueQ[
      batch["status"] === "generated" &&
       batch["continuousSeedRuleCount"] === 1 &&
       batch["discreteRuleCount"] === 3 &&
       batch["momentumGeneratorCount"] === 2 &&
       batch["equationCount"] === 6 &&
       TrueQ[batch["eomCanonicalQ"]] &&
       batch["forbiddenNData"] === {} &&
       blocked["status"] === "tooMany" &&
       blocked["ruleCount"] === 225
      ],
    "batchSummary" -> KeyDrop[batch, "equations"],
    "blockedSummary" -> KeyDrop[blocked, "rules"]
    |>
   ];


compareExpectedMomentumSeedBatchMixedBubbleEOM[] := Module[
   {topo, batch, equations},
   topo = Global`parseTopology[Global`mixedBubbleCase];
   batch = Global`makeMomentumIBPSeedBatch[topo];
   equations = Lookup[Lookup[batch, "equations", {}], "equation", {}];
   <|
    "name" -> "momentumSeedBatch_mixedBubble_EOMCanonical",
    "pass" -> TrueQ[
      batch["status"] === "generated" &&
       batch["continuousSeedRuleCount"] === 1 &&
       batch["discreteRuleCount"] === 2 &&
       batch["momentumGeneratorCount"] === 2 &&
       batch["equationCount"] === 4 &&
       TrueQ[batch["eomCanonicalQ"]] &&
       batch["forbiddenNData"] === {} &&
       ! FreeQ[equations, Global`nuM]
      ],
    "summary" -> KeyDrop[batch, "equations"]
    |>
   ];

compareExpectedCanonicalSeedGateMixedBubble[] := Module[
   {topo, batch, linearData, sectorKeys, integralSectorKeys, aSlotModes, shrinkAListLengths},
   topo = Global`parseTopology[Global`mixedBubbleCase];
   batch = Global`makeCanonicalSeedBatch[topo];
   linearData = Global`makeLinearSystemData[batch, topo];
   sectorKeys = Lookup[linearData["sectorMetadataList"], "sectorKey"];
   integralSectorKeys = DeleteDuplicates[Lookup[linearData["integralMetadata"], "sectorKey"]];
   aSlotModes = Lookup[linearData["sectorMetadataList"], "aSlotMode"];
   shrinkAListLengths = DeleteDuplicates[Cases[linearData["integralList"], Global`J[a_, packs_, isp_] /; (Length /@ packs) === {1, 2} :> Length[a]]];
   <|
    "name" -> "canonicalSeedGate_mixedBubble_autoShrinkSector_readyLinear",
    "pass" -> TrueQ[
      batch["status"] === "generated" &&
       batch["momentumEquationCount"] === 4 &&
       batch["timeEquationCount"] === 4 &&
       batch["shrinkSectorEquationCount"] === 6 &&
       batch["equationCount"] === 14 &&
       TrueQ[batch["eomCanonicalQ"]] &&
       batch["forbiddenNData"] === {} &&
       batch["pendingFeatures"] === {} &&
       TrueQ[batch["completeCanonicalQ"]] &&
       Global`canonicalSeedReadyQ[batch] &&
       linearData["status"] === "generated" &&
       TrueQ[linearData["linearQ"]] &&
       sectorKeys === {"top", "e1"} &&
       aSlotModes === {"compactActiveSlots", "compactActiveSlots"} &&
       shrinkAListLengths === {1} &&
       Sort[integralSectorKeys] === {"e1", "top"}
      ],
    "summary" -> KeyDrop[batch, "equations"],
    "linearData" -> KeyDrop[linearData, {"integralList", "integralRules", "linearEquations"}]
    |>
   ];


compareExpectedDoubleShrinkCompactA[] := Module[
   {case, topo, batch, linearData, sectorKeys, doubleMetadata, doubleIntegrals, doubleAListLengths},
   case = <|
     "name" -> "doubleMassiveBubbleShrinkToy",
     "vertexData" -> {{1, "+"}, {2, "+"}},
     "lineData" -> {
       <|"id" -> 1, "endpoints" -> {1, 2}, "momentum" -> Global`q1, "nu" -> Global`nuM, "bbType" -> "h", "massType" -> "massive"|>,
       <|"id" -> 2, "endpoints" -> {1, 2}, "momentum" -> Global`q1 - Global`k1, "nu" -> Global`nuM, "bbType" -> "h", "massType" -> "massive"|>
       },
     "extLegs" -> {{"p1", 1, Global`p1}, {"p2", 2, Global`p2}},
     "vertexEnergies" -> <|1 -> Global`p1, 2 -> Global`p2|>,
     "loopMomenta" -> {Global`q1},
     "externalMomenta" -> {Global`k1},
     "ispData" -> {},
     "numericRules" -> {Global`dim -> 3, Global`kk[1, 1] -> 5, Global`nuM -> 2},
     "sampleDiscreteRules" -> {{Global`n[1, 1] -> 0, Global`n[1, 2] -> 0, Global`n[2, 1] -> 0, Global`n[2, 2] -> 0}},
     "seedRanges" -> <|"sampleOnly" -> True|>
     |>;
   topo = Global`parseTopology[case];
   batch = Global`makeCanonicalSeedBatch[topo];
   linearData = Global`makeLinearSystemData[batch, topo];
   sectorKeys = Lookup[linearData["sectorMetadataList"], "sectorKey"];
   doubleMetadata = SelectFirst[linearData["sectorMetadataList"], # ["sectorKey"] === "e1_e2" &, <||>];
   doubleIntegrals = Cases[linearData["integralList"], j : Global`J[a_, packs_, isp_] /; (Length /@ packs) === {1, 1} :> j];
   doubleAListLengths = DeleteDuplicates[Cases[doubleIntegrals, Global`J[a_, packs_, isp_] :> Length[a]]];
   <|
    "name" -> "doubleShrinkCompactA_twoMassiveLines",
    "pass" -> TrueQ[
      batch["status"] === "generated" &&
       batch["completeCanonicalQ"] === True &&
       batch["forbiddenNData"] === {} &&
       linearData["status"] === "generated" &&
       TrueQ[linearData["linearQ"]] &&
       sectorKeys === {"top", "e1", "e2", "e1_e2"} &&
       AssociationQ[doubleMetadata] &&
       doubleMetadata["aSlotMode"] === "compactActiveSlots" &&
       Length[doubleMetadata["compactASlots"]] === 1 &&
       doubleMetadata["activeASlots"] === {1} &&
       doubleAListLengths === {1}
      ],
    "sectorKeys" -> sectorKeys,
    "doubleMetadata" -> doubleMetadata,
    "doubleAListLengths" -> doubleAListLengths,
    "summary" -> KeyDrop[batch, "equations"],
    "linearSummary" -> KeyDrop[linearData, {"integralList", "integralRules", "linearEquations"}]
    |>
   ];

compareExpectedThreeVertexMultiShrinkCompactA[] := Module[
   {case, topo, batch, linearData, sectorKeys, metadataByKey, e1Meta, e2Meta, e12Meta,
    e1AListLengths, e2AListLengths, e12AListLengths},
   case = <|
     "name" -> "threeVertexTwoMassiveShrinkToy",
     "vertexData" -> {{1, "+"}, {2, "+"}, {3, "+"}},
     "lineData" -> {
       <|"id" -> 1, "endpoints" -> {1, 2}, "momentum" -> Global`q1, "nu" -> Global`nuM, "bbType" -> "h", "massType" -> "massive"|>,
       <|"id" -> 2, "endpoints" -> {2, 3}, "momentum" -> Global`q1 - Global`k1, "nu" -> Global`nuM, "bbType" -> "h", "massType" -> "massive"|>
       },
     "extLegs" -> {{"p1", 1, Global`p1}, {"p2", 2, Global`p2}, {"p3", 3, Global`p3}},
     "vertexEnergies" -> <|1 -> Global`p1, 2 -> Global`p2, 3 -> Global`p3|>,
     "loopMomenta" -> {Global`q1},
     "externalMomenta" -> {Global`k1},
     "ispData" -> {},
     "numericRules" -> {Global`dim -> 3, Global`kk[1, 1] -> 5, Global`nuM -> 2},
     "sampleDiscreteRules" -> {{Global`n[1, 1] -> 0, Global`n[1, 2] -> 0, Global`n[2, 1] -> 0, Global`n[2, 2] -> 0}},
     "seedRanges" -> <|"sampleOnly" -> True|>
     |>;
   topo = Global`parseTopology[case];
   batch = Global`makeCanonicalSeedBatch[topo];
   linearData = Global`makeLinearSystemData[batch, topo];
   sectorKeys = Lookup[linearData["sectorMetadataList"], "sectorKey"];
   metadataByKey = AssociationThread[sectorKeys -> linearData["sectorMetadataList"]];
   e1Meta = Lookup[metadataByKey, "e1", <||>];
   e2Meta = Lookup[metadataByKey, "e2", <||>];
   e12Meta = Lookup[metadataByKey, "e1_e2", <||>];
   e1AListLengths = DeleteDuplicates[Cases[linearData["integralList"], Global`J[a_, packs_, isp_] /; (Length /@ packs) === {1, 3} :> Length[a]]];
   e2AListLengths = DeleteDuplicates[Cases[linearData["integralList"], Global`J[a_, packs_, isp_] /; (Length /@ packs) === {3, 1} :> Length[a]]];
   e12AListLengths = DeleteDuplicates[Cases[linearData["integralList"], Global`J[a_, packs_, isp_] /; (Length /@ packs) === {1, 1} :> Length[a]]];
   <|
    "name" -> "threeVertexMultiShrinkCompactA_remainingTwoActiveA",
    "pass" -> TrueQ[
      batch["status"] === "generated" &&
       batch["completeCanonicalQ"] === True &&
       batch["forbiddenNData"] === {} &&
       linearData["status"] === "generated" &&
       TrueQ[linearData["linearQ"]] &&
       sectorKeys === {"top", "e1", "e2", "e1_e2"} &&
       AssociationQ[e1Meta] && AssociationQ[e2Meta] && AssociationQ[e12Meta] &&
       Length[e1Meta["compactASlots"]] === 2 &&
       Length[e2Meta["compactASlots"]] === 2 &&
       Length[e12Meta["compactASlots"]] === 1 &&
       e1Meta["activeASlots"] === {1, 2} &&
       e2Meta["activeASlots"] === {1, 2} &&
       e12Meta["activeASlots"] === {1} &&
       e1AListLengths === {2} &&
       e2AListLengths === {2} &&
       e12AListLengths === {1}
      ],
    "sectorKeys" -> sectorKeys,
    "e1CompactASlots" -> Lookup[e1Meta, "compactASlots", Missing["e1"]],
    "e2CompactASlots" -> Lookup[e2Meta, "compactASlots", Missing["e2"]],
    "e12CompactASlots" -> Lookup[e12Meta, "compactASlots", Missing["e1_e2"]],
    "aListLengths" -> <|"e1" -> e1AListLengths, "e2" -> e2AListLengths, "e1_e2" -> e12AListLengths|>,
    "summary" -> KeyDrop[batch, "equations"],
    "linearSummary" -> KeyDrop[linearData, {"integralList", "integralRules", "linearEquations"}]
    |>
   ];

compareExpectedTopologyDataInterface[] := Module[
   {data},
   data = Global`makeTopologyData[Global`mixedBubbleCase, Global`PrecomputeShrinkSectorMetadata -> True];
   <|
    "name" -> "topologyDataInterface_mixedBubble_precomputedMetadata",
    "pass" -> TrueQ[
      AssociationQ[data] &&
       data["name"] === "mixedBubbleMassiveMassless" &&
       Lookup[data["sectorMetadataList"], "sectorKey"] === {"top", "e1"} &&
       KeyExistsQ[data, "indexMaps"] &&
       KeyExistsQ[data["indexMaps"], "lineIdToSlot"] &&
       data["seedSummary", "discreteStateCount"] === 8 &&
       data["seedSummary", "momentumGeneratorCount"] === 2 &&
       data["seedSummary", "timeGeneratorCount"] === 2
      ],
    "sectorKeys" -> Lookup[data["sectorMetadataList"], "sectorKey"],
    "seedSummary" -> Lookup[data, "seedSummary", <||>],
    "indexMapKeys" -> Keys[Lookup[data, "indexMaps", <||>]]
    |>
   ];


compareExpectedTopologyValidationReport[] := Module[
   {goodData, crossData, badCase, redundantCase, singularCase, badReport, redundantReport, singularReport,
    missingNumericCase, missingNumericReport, badCodes, redundantCodes, singularCodes, missingNumericCodes,
    badSeverities, incompleteDiscreteData},
   goodData = Global`makeTopologyData[Global`mixedSunriseCase];
   crossData = Global`makeTopologyData[Global`massiveCrossBubbleCase];
   badCase = <|
     "name" -> "badTopologyValidationToy",
     "vertexData" -> {{1, "+"}, {2, "+"}},
     "lineData" -> {
       <|"id" -> 1, "endpoints" -> {1, 2}, "momentum" -> Global`q1, "nu" -> 0, "bbType" -> "exp", "massType" -> "massless"|>,
       <|"id" -> 2, "endpoints" -> {1, 2}, "momentum" -> Global`q1 - Global`q2 - Global`pBad, "nu" -> 0, "bbType" -> "exp", "massType" -> "massless"|>
       },
     "extLegs" -> {},
     "loopMomenta" -> {Global`q1, Global`q2},
     "externalMomenta" -> {},
     "ispData" -> {},
     "sampleDiscreteRules" -> {{Global`n[99] -> 1, Global`n[1] -> 2}},
     "seedRanges" -> <|"sampleOnly" -> True|>
     |>;
   redundantCase = <|
     "name" -> "redundantZCoordinateToy",
     "vertexData" -> {{1, "+"}, {2, "+"}},
     "lineData" -> {
       <|"id" -> 1, "endpoints" -> {1, 2}, "momentum" -> Global`q1, "nu" -> 0, "bbType" -> "exp", "massType" -> "massless"|>,
       <|"id" -> 2, "endpoints" -> {1, 2}, "momentum" -> Global`q1 - Global`k, "nu" -> 0, "bbType" -> "exp", "massType" -> "massless"|>,
       <|"id" -> 3, "endpoints" -> {1, 2}, "momentum" -> Global`q1 + Global`k, "nu" -> 0, "bbType" -> "exp", "massType" -> "massless"|>
       },
     "extLegs" -> {},
     "loopMomenta" -> {Global`q1},
     "externalMomenta" -> {Global`k},
     "ispData" -> {},
     "sampleDiscreteRules" -> {{Global`n[1] -> 0, Global`n[2] -> 0, Global`n[3] -> 0}},
     "seedRanges" -> <|"sampleOnly" -> True|>
     |>;
   singularCase = <|
     "name" -> "singularZCoordinateToy",
     "vertexData" -> {{1, "+"}, {2, "+"}},
     "lineData" -> {
       <|"id" -> 1, "endpoints" -> {1, 2}, "momentum" -> Global`q1, "nu" -> 0, "bbType" -> "exp", "massType" -> "massless"|>,
       <|"id" -> 2, "endpoints" -> {1, 2}, "momentum" -> -Global`q1, "nu" -> 0, "bbType" -> "exp", "massType" -> "massless"|>
       },
     "extLegs" -> {},
     "loopMomenta" -> {Global`q1},
     "externalMomenta" -> {Global`k},
     "ispData" -> {},
     "sampleDiscreteRules" -> {{Global`n[1] -> 0, Global`n[2] -> 0}},
     "seedRanges" -> <|"sampleOnly" -> True|>
     |>;
   missingNumericCase = <|
     "name" -> "missingNumericInvariantToy",
     "vertexData" -> {{1, "+"}, {2, "+"}},
     "lineData" -> {
       <|"id" -> 1, "endpoints" -> {1, 2}, "momentum" -> Global`q1, "nu" -> 0, "bbType" -> "exp", "massType" -> "massless"|>,
       <|"id" -> 2, "endpoints" -> {1, 2}, "momentum" -> Global`q1 - Global`k, "nu" -> 0, "bbType" -> "exp", "massType" -> "massless"|>
       },
     "extLegs" -> {},
     "loopMomenta" -> {Global`q1},
     "externalMomenta" -> {Global`k},
     "ispData" -> {},
     "numericRules" -> {Global`dim -> 3},
     "sampleDiscreteRules" -> {{Global`n[1] -> 0, Global`n[2] -> 0}},
     "seedRanges" -> <|"sampleOnly" -> True|>
     |>;
   badReport = Global`topologyValidationReport[Global`parseTopology[badCase]];
   redundantReport = Global`topologyValidationReport[Global`parseTopology[redundantCase]];
   singularReport = Global`topologyValidationReport[Global`parseTopology[singularCase]];
   missingNumericReport = Global`topologyValidationReport[Global`parseTopology[missingNumericCase]];
   badCodes = Lookup[badReport["issues"], "code", {}];
   redundantCodes = Lookup[redundantReport["issues"], "code", {}];
   singularCodes = Lookup[singularReport["issues"], "code", {}];
   missingNumericCodes = Lookup[missingNumericReport["issues"], "code", {}];
   badSeverities = Lookup[badReport["issues"], "severity", {}];
   incompleteDiscreteData = Global`selectedDiscreteSeedRules[Global`parseTopology[badCase]];
   <|
    "name" -> "topologyValidationReport_goodPendingBad",
    "pass" -> TrueQ[
      goodData["validationReport", "status"] === "ok" &&
       goodData["validationReport", "pendingFeatures"] === {} &&
       crossData["validationReport", "status"] === "ok" &&
       crossData["validationReport", "pendingFeatures"] === {} &&
       crossData["validationReport", "pendingCount"] === 0 &&
       badReport["status"] === "issues" &&
       badReport["errorCount"] === 3 &&
       badReport["warningCount"] === 2 &&
       MemberQ[badCodes, "undeclaredMomentumVariables"] &&
       MemberQ[badCodes, "insufficientISPData"] &&
       MemberQ[badCodes, "sampleDiscreteRulesMissingVariables"] &&
       MemberQ[badCodes, "sampleDiscreteRulesContainUnknownVariables"] &&
       MemberQ[badCodes, "sampleDiscreteRulesContainNonBinaryValues"] &&
       Count[badSeverities, "error"] === 3 &&
       Count[badSeverities, "warning"] === 2 &&
       redundantReport["status"] === "issues" &&
       redundantReport["errorCount"] === 1 &&
       MemberQ[redundantCodes, "scalarProductCoordinateCountMismatch"] &&
       singularReport["status"] === "issues" &&
       singularReport["errorCount"] === 1 &&
       MemberQ[singularCodes, "scalarProductCoordinateSolveFailed"] &&
       missingNumericReport["status"] === "ok" &&
       missingNumericReport["errorCount"] === 0 &&
       missingNumericReport["warningCount"] === 1 &&
       MemberQ[missingNumericCodes, "numericRulesMissingExternalInvariants"] &&
       incompleteDiscreteData["status"] === "incompleteSampleDiscreteRules"
      ],
    "goodReport" -> goodData["validationReport"],
    "crossReport" -> crossData["validationReport"],
    "badReport" -> badReport,
    "redundantReport" -> redundantReport,
    "singularReport" -> singularReport,
    "missingNumericReport" -> missingNumericReport,
    "incompleteDiscreteData" -> incompleteDiscreteData
    |>
   ];


compareExpectedSectorKeyExactMatch[] := Module[
   {case, topo, meta1, meta2, intE1, intE2, wrongSymbolInt},
   case = <|
     "name" -> "sectorKeyExactTwoLineToy",
     "vertexData" -> {{1, "+"}, {2, "+"}},
     "lineData" -> {
       <|"id" -> 1, "endpoints" -> {1, 2}, "momentum" -> Global`q1, "nu" -> Global`nuM, "bbType" -> "h", "massType" -> "massive"|>,
       <|"id" -> 2, "endpoints" -> {1, 2}, "momentum" -> Global`q1 - Global`k1, "nu" -> Global`nuM, "bbType" -> "h", "massType" -> "massive"|>
       },
     "extLegs" -> {},
     "loopMomenta" -> {Global`q1},
     "externalMomenta" -> {Global`k1},
     "ispData" -> {},
     "seedRanges" -> <|"sampleOnly" -> True|>
     |>;
   topo = Global`parseTopology[case];
   meta1 = Global`makeSectorMetadata[Global`shrinkSectorTopology[topo, {1}]];
   meta2 = Global`makeSectorMetadata[Global`shrinkSectorTopology[topo, {2}]];
   intE1 = Global`J[{Global`a[1] + Global`a[2]}, {{Global`bS[1]}, {Global`b[2], Global`n[2, 1], Global`n[2, 2]}}, {}];
   intE2 = Global`J[{Global`a[1] + Global`a[2]}, {{Global`b[1], Global`n[1, 1], Global`n[1, 2]}, {Global`bS[2]}}, {}];
   wrongSymbolInt = Global`J[{Global`a[1] + Global`a[2]}, {{Global`bS[2]}, {Global`b[2], Global`n[2, 1], Global`n[2, 2]}}, {}];
   <|
    "name" -> "sectorKeyExactMatch_shrunkLinePositionAndSymbol",
    "pass" -> TrueQ[
      Global`integralSectorKey[intE1, {meta1, meta2}] === "e1" &&
       Global`integralSectorKey[intE2, {meta1, meta2}] === "e2" &&
       Head[Global`integralSectorKey[wrongSymbolInt, {meta1, meta2}]] === Missing
      ],
    "sectorE1" -> Global`integralSectorKey[intE1, {meta1, meta2}],
    "sectorE2" -> Global`integralSectorKey[intE2, {meta1, meta2}],
    "wrongSymbolSector" -> Global`integralSectorKey[wrongSymbolInt, {meta1, meta2}]
    |>
   ];


compareExpectedMasslessBundleMetadata[] := Module[
   {bubbleData, sunriseData, bubbleSummary, sunriseSummary, bubbleCandidates, sunriseCandidates},
   bubbleData = Global`makeTopologyData[Global`bubbleMasslessCase];
   sunriseData = Global`makeTopologyData[Global`mixedSunriseCase];
   bubbleSummary = Global`summarizeCase[Global`bubbleMasslessCase];
   sunriseSummary = Global`summarizeCase[Global`mixedSunriseCase];
   bubbleCandidates = Lookup[bubbleData, "masslessBundleCandidates", {}];
   sunriseCandidates = Lookup[sunriseData, "masslessBundleCandidates", {}];
   <|
    "name" -> "masslessBundleMetadata_perLineMainFutureBundle",
    "pass" -> TrueQ[
      Length[bubbleCandidates] === 1 &&
       First[bubbleCandidates]["vertexPair"] === {1, 2} &&
       First[bubbleCandidates]["lineIds"] === {1, 2} &&
       First[bubbleCandidates]["packTemplates"] === {{Global`b[1], Global`n[1]}, {Global`b[2], Global`n[2]}} &&
       Length[sunriseCandidates] === 1 &&
       First[sunriseCandidates]["vertexPair"] === {1, 2} &&
       First[sunriseCandidates]["lineIds"] === {2, 3} &&
       First[sunriseCandidates]["packTemplates"] === {{Global`b[2], Global`n[2]}, {Global`b[3], Global`n[3]}} &&
       Lookup[bubbleSummary, "masslessBundleCandidates", {}] === bubbleCandidates &&
       Lookup[sunriseSummary, "masslessBundleCandidates", {}] === sunriseCandidates
      ],
    "bubbleCandidates" -> bubbleCandidates,
    "sunriseCandidates" -> sunriseCandidates
    |>
   ];


expectedTimeSeedMasslessCrossVertex1[] := Module[
   {int0, intA1Down, intB1Down, intB2Down},
   int0 = Global`J[{Global`a[1], Global`a[2]}, {{Global`b[1]}, {Global`b[2]}}, {}];
   intA1Down = Global`J[{-1 + Global`a[1], Global`a[2]}, {{Global`b[1]}, {Global`b[2]}}, {}];
   intB1Down = Global`J[{Global`a[1], Global`a[2]}, {{-1 + Global`b[1]}, {Global`b[2]}}, {}];
   intB2Down = Global`J[{Global`a[1], Global`a[2]}, {{Global`b[1]}, {-1 + Global`b[2]}}, {}];
   Expand[-Global`a[1] intA1Down - I Global`p1 int0 + I intB1Down + I intB2Down]
   ];


compareExpectedMasslessCrossTimeSeed[] := Module[
   {summary, topo, int0, gen, got, expected, canonicalBatch, linearData},
   summary = Global`summarizeCase[Global`masslessCrossBubbleCase];
   topo = Global`parseTopology[Global`masslessCrossBubbleCase];
   int0 = Global`makeBaseIntegral[topo];
   gen = SelectFirst[Global`makeIBPGenerators[topo], #["type"] === "time" && #["vertex"] === 1 &];
   got = Expand[Global`applyTimeGeneratorSeed[topo, int0, gen]];
   expected = expectedTimeSeedMasslessCrossVertex1[];
   canonicalBatch = Global`makeCanonicalSeedBatch[topo];
   linearData = Global`makeLinearSystemData[canonicalBatch, topo];
   <|
    "name" -> "masslessCross_timeSeed_noThetaPhase",
    "pass" -> TrueQ[
      summary["packTypes"] === {"masslessCross", "masslessCross"} &&
       summary["linePacks"] === {{Global`b[1]}, {Global`b[2]}} &&
       summary["discreteStateCount"] === 1 &&
       got === expected &&
       Lookup[canonicalBatch, "pendingFeatures", {"missing"}] === {} &&
       TrueQ[Global`canonicalSeedReadyQ[canonicalBatch]] &&
       Lookup[linearData, "status", Missing["status"]] === "generated"
      ],
    "got" -> got,
    "expected" -> expected,
    "canonicalSummary" -> KeyDrop[canonicalBatch, "equations"],
    "linearSummary" -> KeyDrop[linearData, {"integralList", "integralRules", "linearEquations"}]
    |>
   ];


compareExpectedMassiveCrossGate[] := Module[
   {summary, topo, baseIntegral, momentumBatch, canonicalBatch, linearData},
   summary = Global`summarizeCase[Global`massiveCrossBubbleCase];
   topo = Global`parseTopology[Global`massiveCrossBubbleCase];
   baseIntegral = Global`makeBaseIntegral[topo];
   momentumBatch = Global`makeMomentumIBPSeedBatch[topo];
   canonicalBatch = Global`makeCanonicalSeedBatch[topo];
   linearData = Global`makeLinearSystemData[canonicalBatch, topo];
   <|
    "name" -> "massiveCross_doubleEndpointPackReady",
    "pass" -> TrueQ[
      summary["packTypes"] === {"massiveCross", "massiveCross"} &&
       summary["linePacks"] === {{Global`b[1], Global`n[1, 1], Global`n[1, 2]}, {Global`b[2], Global`n[2, 1], Global`n[2, 2]}} &&
       summary["discreteStateCount"] === 16 &&
       baseIntegral === Global`J[{Global`a[1], Global`a[2]}, {{Global`b[1], Global`n[1, 1], Global`n[1, 2]}, {Global`b[2], Global`n[2, 1], Global`n[2, 2]}}, {}] &&
       Lookup[momentumBatch, "pendingFeatures", {"missing"}] === {} &&
       Lookup[momentumBatch, "forbiddenNData", {"missing"}] === {} &&
       Lookup[canonicalBatch, "pendingFeatures", {"missing"}] === {} &&
       Lookup[canonicalBatch, "forbiddenNData", {"missing"}] === {} &&
       TrueQ[Lookup[canonicalBatch, "completeCanonicalQ", False]] &&
       TrueQ[Global`canonicalSeedReadyQ[canonicalBatch]] &&
       Lookup[linearData, "status", Missing["status"]] === "generated"
      ],
    "summary" -> KeyTake[summary, {"packTypes", "linePacks", "discreteStateCount"}],
    "momentumSummary" -> KeyDrop[momentumBatch, "equations"],
    "canonicalSummary" -> KeyDrop[canonicalBatch, "equations"],
    "linearData" -> linearData
    |>
   ];


compareExpectedSeedClassificationAndSampledLinear[] := Module[
   {topo, batch, classified, sampled, firstCoeffRules},
   topo = Global`parseTopology[Global`mixedBubbleCase];
   batch = Global`makeCanonicalSeedBatch[topo];
   classified = Global`classifyCanonicalSeedBatch[batch];
   sampled = Global`makeSampledLinearSystemData[batch, topo];
   firstCoeffRules = Lookup[First[Lookup[sampled, "linearEquations", {<||>}]], "coefficientRules", {}];
   <|
    "name" -> "seedClassificationAndSampledLinear_mixedBubble",
    "pass" -> TrueQ[
      classified["status"] === "generated" &&
       classified["sectorKeys"] === {"e1", "top"} &&
       classified["classes"] === {"qIBP", "tIBP"} &&
       Total[Flatten[Values /@ Values[classified["summary"]]]] === batch["equationCount"] &&
       sampled["status"] === "generated" &&
       sampled["coefficientRulesApplied"] === topo["numericRules"] &&
       TrueQ[sampled["linearQ"]] &&
       FreeQ[firstCoeffRules, Global`dim | Global`kk[1, 1] | Global`nuM]
      ],
    "classificationSummary" -> Lookup[classified, "summary", <||>],
    "coefficientRulesApplied" -> Lookup[sampled, "coefficientRulesApplied", Missing["rules"]],
    "firstCoeffRules" -> firstCoeffRules
    |>
   ];

compareExpectedSeedMMASaveMixedBubble[] := Module[
   {topo, batch, outDir, saveData, loaded},
   topo = Global`parseTopology[Global`mixedBubbleCase];
   batch = Global`makeCanonicalSeedBatch[topo];
   outDir = FileNameJoin[{projectRootFromCheckDir[], "check", "results_test", "seed_mma_mixed_bubble"}];
   saveData = Global`writeSeedBatchMMA[batch, Global`OutputDirectory -> outDir, Global`SeedFileBaseName -> "mixed_bubble_canonical_seed"];
   loaded = If[Lookup[saveData, "status", "missing"] === "written", Global`readSeedBatchMMA[saveData["file"]], <||>];
   <|
    "name" -> "seedMMASave_mixedBubble_canonicalBatch",
    "pass" -> TrueQ[
      Lookup[saveData, "status", "missing"] === "written" &&
       FileExistsQ[saveData["file"]] &&
       loaded["status"] === batch["status"] &&
       loaded["equationCount"] === batch["equationCount"] &&
       Lookup[loaded["sectorMetadataList"], "sectorKey"] === {"top", "e1"}
      ],
    "saveData" -> saveData,
    "loadedSummary" -> If[AssociationQ[loaded], KeyDrop[loaded, "equations"], loaded]
    |>
   ];


compareExpectedKiraWorkspaceExportMixedBubble[] := Module[
   {topo, batch, linearData, outDir, kiraData, requiredFiles, ibpText, listText, blocks, blockCount, listCount},
   topo = Global`parseTopology[Global`mixedBubbleCase];
   batch = Global`makeCanonicalSeedBatch[topo];
   linearData = Global`makeLinearSystemData[batch, topo];
   outDir = FileNameJoin[{projectRootFromCheckDir[], "check", "results_test", "kira_export_mixed_bubble"}];
   kiraData = Global`makeKiraExportData[linearData, Global`KiraCoefficientRules -> topo["numericRules"], Global`OutputDirectory -> outDir];
   requiredFiles = FileNameJoin[{outDir, #}] & /@ {
      "userSystem/ibp.kira",
      "list",
      "jobs.yaml",
      "result/repkira2J.m",
      "result/repJ2kira.m",
      "result/kira_export_metadata.m"
      };
   ibpText = If[FileExistsQ[FileNameJoin[{outDir, "userSystem", "ibp.kira"}]], Import[FileNameJoin[{outDir, "userSystem", "ibp.kira"}], "Text"], ""];
   listText = If[FileExistsQ[FileNameJoin[{outDir, "list"}]], Import[FileNameJoin[{outDir, "list"}], "Text"], ""];
   blocks = Select[StringSplit[StringTrim[ibpText], RegularExpression["\\n\\s*\\n"]], StringTrim[#] =!= "" &];
   blockCount = Length[blocks];
   listCount = Length[StringSplit[StringTrim[listText], WhitespaceCharacter ..]];
   <|
    "name" -> "kiraWorkspaceExport_mixedBubble_linearSystemFilesOnly",
    "pass" -> TrueQ[
      kiraData["status"] === "ready" &&
       linearData["status"] === "generated" &&
       Length[kiraData["filesWritten"]] === Length[requiredFiles] &&
       And @@ (FileExistsQ /@ requiredFiles) &&
       StringContainsQ[Import[FileNameJoin[{outDir, "jobs.yaml"}], "Text"], "reduce_user_defined_system"] &&
       blockCount === kiraData["exportedEquationCount"] &&
       listCount === kiraData["integralCount"]
      ],
    "outputDir" -> outDir,
    "filesWritten" -> Lookup[kiraData, "filesWritten", {}],
    "blockCount" -> blockCount,
    "listCount" -> listCount,
    "equationCount" -> Lookup[kiraData, "equationCount", Missing["equationCount"]],
    "exportedEquationCount" -> Lookup[kiraData, "exportedEquationCount", Missing["exportedEquationCount"]],
    "integralCount" -> Lookup[kiraData, "integralCount", Missing["integralCount"]]
    |>
   ];
compareExpectedKiraIntegralOrderingMixedBubble[] := Module[
   {topo, batch, linearData, preferred, missingIntegral, customData, reorderedData, badReorderedData,
    kiraData, exportedLinear},
   topo = Global`parseTopology[Global`mixedBubbleCase];
   batch = Global`makeCanonicalSeedBatch[topo];
   linearData = Global`makeLinearSystemData[batch, topo];
   preferred = linearData["integralList"][[Min[3, linearData["integralCount"]]]];
   missingIntegral = Global`J[{99, 99}, {{99, 0, 0}, {99, 0}}, {}];
   customData = Global`makeLinearSystemData[
     batch,
     topo,
     Global`KiraOrdering -> <|"IntegralOrder" -> {preferred, missingIntegral}, "PreferredPriority" -> "BeforeB"|>
     ];
   reorderedData = Global`reorderLinearSystemIntegrals[linearData, {preferred}];
   badReorderedData = Global`reorderLinearSystemIntegrals[linearData, {preferred, 999, missingIntegral}];
   kiraData = Global`makeKiraExportData[
     linearData,
     Global`KiraIntegralOrder -> {preferred, 999, missingIntegral},
     Global`KiraCoefficientRules -> topo["numericRules"]
     ];
   exportedLinear = Lookup[kiraData, "linearSystem", <||>];
   <|
    "name" -> "kiraIntegralOrdering_mixedBubble_globalAllSectors",
    "pass" -> TrueQ[
      linearData["integralCount"] >= 3 &&
       customData["status"] === "generated" &&
       First[customData["integralList"]] === preferred &&
       customData["kiraOrderingReport", "missingIntegralOrderItems"] === {missingIntegral} &&
       ! TrueQ[customData["kiraOrderingReport", "allRequestedIntegralsMatchedQ"]] &&
       First[reorderedData["integralList"]] === preferred &&
       badReorderedData["manualIntegralOrderReport", "missingIntegralOrderItems"] === {999, missingIntegral} &&
       Lookup[kiraData, "status", Missing["status"]] === "ready" &&
       AssociationQ[exportedLinear] &&
       First[exportedLinear["integralList"]] === preferred &&
       exportedLinear["manualIntegralOrderReport", "missingIntegralOrderItems"] === {999, missingIntegral}
      ],
    "preferred" -> preferred,
    "defaultFirst" -> First[linearData["integralList"]],
    "customFirst" -> If[AssociationQ[customData], First[customData["integralList"]], Missing["customData"]],
    "reorderedFirst" -> If[AssociationQ[reorderedData], First[reorderedData["integralList"]], Missing["reorderedData"]],
    "exportedFirst" -> If[AssociationQ[exportedLinear], First[exportedLinear["integralList"]], Missing["exportedLinear"]],
    "customOrderingReport" -> Lookup[customData, "kiraOrderingReport", <||>],
    "badManualOrderReport" -> Lookup[badReorderedData, "manualIntegralOrderReport", <||>],
    "exportManualOrderReport" -> If[AssociationQ[exportedLinear], Lookup[exportedLinear, "manualIntegralOrderReport", <||>], <||>]
    |>
   ];

compareExpectedMomentumLinearSystem[] := Module[
   {topo, system, firstEquation},
   topo = Global`parseTopology[Global`bubbleMasslessCase];
   system = Global`makeMomentumIBPLinearSystem[topo];
   firstEquation = First[system["linearEquations"]];
   <|
    "name" -> "momentumLinearSystem_masslessBubble_sampleOnly",
    "pass" -> TrueQ[
      system["status"] === "generated" &&
       system["integralCount"] === 3 &&
       system["equationCount"] === 6 &&
       TrueQ[system["linearQ"]] &&
       system["nonlinearEquationCount"] === 0 &&
       firstEquation["coefficientRules"] === {1 -> Global`dim} &&
       firstEquation["constantTerm"] === 0
      ],
    "summary" -> KeyDrop[system, {"integralList", "integralRules", "linearEquations"}],
    "firstEquation" -> firstEquation,
    "integralRules" -> system["integralRules"]
    |>
   ];


compareExpectedMasslessBoxTopologyReplacement[] := Module[
   {topo, summary, spRules, momentumBatch, sampledLinear, expectedZExprs, expectedSPRules},
   topo = Global`parseTopology[Global`masslessBoxCase];
   summary = Global`summarizeCase[Global`masslessBoxCase];
   spRules = Global`makeScalarProductRules[topo];
   momentumBatch = Global`makeMomentumIBPSeedBatch[topo];
   sampledLinear = Global`makeSampledLinearSystemData[momentumBatch, topo];
   expectedZExprs = {
     Global`qq[1, 1],
     Global`kk[1, 1] - 2 Global`qk[1, 1] + Global`qq[1, 1],
     Global`kk[1, 1] + 2 Global`kk[1, 2] + Global`kk[2, 2] - 2 Global`qk[1, 1] - 2 Global`qk[1, 2] + Global`qq[1, 1],
     Global`kk[3, 3] + 2 Global`qk[1, 3] + Global`qq[1, 1]
     };
   expectedSPRules = {
     Global`qq[1, 1] -> Global`z[1],
     Global`qk[1, 1] -> (Global`kk[1, 1] + Global`z[1] - Global`z[2])/2,
     Global`qk[1, 2] -> Global`kk[1, 2] + Global`kk[2, 2]/2 + Global`z[2]/2 - Global`z[3]/2,
     Global`qk[1, 3] -> (-Global`kk[3, 3] - Global`z[1] + Global`z[4])/2
     };
   <|
    "name" -> "masslessBoxTopologyReplacement_sampleMomentumLinear",
    "pass" -> TrueQ[
      summary["validationReport", "status"] === "ok" &&
       summary["nV"] === 4 &&
       summary["nE"] === 4 &&
       summary["nL"] === 1 &&
       summary["nK"] === 3 &&
       summary["packTypes"] === ConstantArray["masslessFull", 4] &&
       summary["linePacks"] === {{Global`b[1], Global`n[1]}, {Global`b[2], Global`n[2]}, {Global`b[3], Global`n[3]}, {Global`b[4], Global`n[4]}} &&
       summary["discreteStateCount"] === 16 &&
       summary["momentumGeneratorCount"] === 4 &&
       summary["generatorCount"] === 8 &&
       summary["zExprs"] === expectedZExprs &&
       Lookup[spRules, "status", Missing["status"]] === "computed" &&
       And @@ ((Expand[#[[1]] /. spRules["repSP2Z"]] === Expand[#[[2]]]) & /@ expectedSPRules) &&
       momentumBatch["status"] === "generated" &&
       momentumBatch["equationCount"] === 12 &&
       TrueQ[momentumBatch["completeMomentumIBPQ"]] &&
       momentumBatch["forbiddenNData"] === {} &&
       sampledLinear["status"] === "generated" &&
       sampledLinear["equationCount"] === 12 &&
       TrueQ[sampledLinear["linearQ"]] &&
       sampledLinear["coefficientRulesApplied"] === topo["numericRules"]
      ],
    "summary" -> KeyDrop[summary, {"generatorList", "sampleIntegrals"}],
    "repSP2Z" -> Lookup[spRules, "repSP2Z", Missing["repSP2Z"]],
    "momentumSummary" -> KeyDrop[momentumBatch, "equations"],
    "linearSummary" -> KeyDrop[sampledLinear, {"integralList", "integralRules", "linearEquations"}]
    |>
   ];


compareExpectedShrunkLineIBP[] := Module[
   {case, topo, int0, gen, gotMomentum, expectedMomentum, timeBatch},
   case = <|
     "name" -> "shrunkOneLineTadpoleToy",
     "vertexData" -> {{1, "+"}, {2, "+"}},
     "lineData" -> {
       <|"id" -> 1, "endpoints" -> {1, 2}, "momentum" -> Global`q1, "nu" -> Global`nuM, "bbType" -> "h", "massType" -> "massive", "state" -> "shrunk"|>
       },
     "extLegs" -> {},
     "loopMomenta" -> {Global`q1},
     "externalMomenta" -> {},
     "ispData" -> {},
     "sampleDiscreteRules" -> {{}},
     "seedRanges" -> <|"sampleOnly" -> True|>
     |>;
   topo = Global`parseTopology[case];
   int0 = Global`makeBaseIntegral[topo];
   gen = SelectFirst[Global`makeIBPGenerators[topo], # ["type"] === "momentum" && # ["vectorType"] === "loop" &];
   gotMomentum = Expand[Global`applyMomentumGeneratorSeed[topo, int0, gen]];
   expectedMomentum = Expand[(Global`dim - Global`bS[1]) int0];
   timeBatch = Global`makeTimeIBPSeedBatch[topo];
   <|
    "name" -> "shrunkLine_momentumUsesBS_timeHasNoPending",
    "pass" -> TrueQ[
      gotMomentum === expectedMomentum &&
       timeBatch["status"] === "generated" &&
       timeBatch["pendingFeatures"] === {} &&
       TrueQ[timeBatch["completeTimeIBPQ"]] &&
       timeBatch["forbiddenNData"] === {}
      ],
    "gotMomentum" -> gotMomentum,
    "expectedMomentum" -> expectedMomentum,
    "timeSummary" -> KeyDrop[timeBatch, "equations"]
    |>
   ];


(* 调用前需先 loadGeneralGenerator[]，或已在当前 kernel 中定义 summarizeCase/mixedBubbleCase/mixedTriangleCase。 *)
compareExpectedWithCurrentGenerator[] := Module[
   {bubbleSummary, triangleSummary, masslessBubbleSummary, sunriseSummary},
   bubbleSummary = Global`summarizeCase[Global`mixedBubbleCase];
   triangleSummary = Global`summarizeCase[Global`mixedTriangleCase];
   masslessBubbleSummary = Global`summarizeCase[Global`bubbleMasslessCase];
   sunriseSummary = Global`summarizeCase[Global`mixedSunriseCase];
   <|
    "masslessBubble" -> compareExpectedCase[Global`bubbleMasslessCase, masslessBubbleSummary, expectedMasslessBubblePerLineMergedTheta[]],
    "mixedBubble" -> compareExpectedCase[Global`mixedBubbleCase, bubbleSummary, expectedMixedBubble[]],
    "mixedTriangle" -> compareExpectedCase[Global`mixedTriangleCase, triangleSummary, expectedMixedTriangle[]],
    "mixedSunrise" -> compareExpectedCase[Global`mixedSunriseCase, sunriseSummary, expectedMixedSunrisePerLineMergedTheta[]],
    "momentumSeedMasslessBubble" -> compareExpectedMomentumSeedMasslessBubble[],
    "momentumSeedMixedBubbleBuildingBlock" -> compareExpectedMomentumSeedMixedBubbleBuildingBlock[],
    "momentumSeedSunriseISP" -> compareExpectedMomentumSeedSunriseISP[],
    "eomCanonical" -> compareExpectedEOMCanonical[],
    "timeSeedMixedBubbleCore" -> compareExpectedTimeSeedMixedBubbleCore[],
    "timeSeedBatchMixedBubbleEOM" -> compareExpectedTimeSeedBatchMixedBubbleEOM[],
    "masslessEndpointCanonical" -> compareExpectedMasslessEndpointCanonical[],
    "momentumSeedBatch" -> compareExpectedMomentumSeedBatch[],
    "momentumSeedBatchMixedBubbleEOM" -> compareExpectedMomentumSeedBatchMixedBubbleEOM[],
    "canonicalSeedGateMixedBubble" -> compareExpectedCanonicalSeedGateMixedBubble[],
    "doubleShrinkCompactA" -> compareExpectedDoubleShrinkCompactA[],
    "threeVertexMultiShrinkCompactA" -> compareExpectedThreeVertexMultiShrinkCompactA[],
    "topologyDataInterface" -> compareExpectedTopologyDataInterface[],
    "topologyValidationReport" -> compareExpectedTopologyValidationReport[],
    "sectorKeyExactMatch" -> compareExpectedSectorKeyExactMatch[],
    "masslessBundleMetadata" -> compareExpectedMasslessBundleMetadata[],
    "masslessCrossTimeSeed" -> compareExpectedMasslessCrossTimeSeed[],
    "massiveCrossGate" -> compareExpectedMassiveCrossGate[],
    "seedClassificationAndSampledLinear" -> compareExpectedSeedClassificationAndSampledLinear[],
    "seedMMASaveMixedBubble" -> compareExpectedSeedMMASaveMixedBubble[],
    "kiraWorkspaceExportMixedBubble" -> compareExpectedKiraWorkspaceExportMixedBubble[],
    "kiraIntegralOrderingMixedBubble" -> compareExpectedKiraIntegralOrderingMixedBubble[],
    "momentumLinearSystem" -> compareExpectedMomentumLinearSystem[],
    "masslessBoxTopologyReplacement" -> compareExpectedMasslessBoxTopologyReplacement[],
    "shrunkLineIBP" -> compareExpectedShrunkLineIBP[],
    "futureBundledNotChecked" -> <|"masslessBubble" -> expectedMasslessBubbleBundledFuture[], "mixedSunrise" -> expectedMixedSunriseBundledFuture[]|>
    |>
   ];


(* 一步式小检查：加载 004 后比较结构摘要。仍然不生成 IBP 方程。 *)
runSeedExpectedStructureCheck[] := Module[{},
   loadGeneralGenerator[];
   compareExpectedWithCurrentGenerator[]
   ];


End[];

EndPackage[];
