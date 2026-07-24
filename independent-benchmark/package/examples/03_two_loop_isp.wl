(* ::Package:: *)
(* Two-loop ISP 示例：任意动量名、两个 ISP、完整生成元集合与 backend-neutral linearData。 *)

(* ::Chapter:: *)
(*加载标准 package*)

exampleDir = DirectoryName[$InputFileName];
Get[FileNameJoin[{exampleDir, "load_current_package.wl"}]];


(* ::Chapter:: *)
(*详细物理输入*)

case = <|
   "name" -> "twoLoopISPExample",
   "vertexData" -> {{v1, "+"}, {v2, "+"}},
   "lineData" -> {
     <|"id" -> e1, "endpoints" -> {v1, v2}, "momentum" -> l3,
       "massType" -> "massless", "bbType" -> "exp", "nu" -> 0|>,
     <|"id" -> e2, "endpoints" -> {v1, v2}, "momentum" -> k321,
       "massType" -> "massless", "bbType" -> "exp", "nu" -> 0|>,
     <|"id" -> e3, "endpoints" -> {v1, v2}, "momentum" -> l3 - k321 - wdnmd,
       "massType" -> "massless", "bbType" -> "exp", "nu" -> 0|>
     },
   "loopMomenta" -> {l3, k321},
   "loopExternalMomenta" -> {wdnmd},
   "independentExternalMomenta" -> {},
   "ibpMode" -> "full",
   "vertexEnergies" -> <|v1 -> E1, v2 -> E2|>,
   "ispData" -> {
     <|"name" -> rhoK321L3, "expr" -> sp[k321, l3], "range" -> {0, 1}|>,
     <|"name" -> rhoL3Wdnmd, "expr" -> sp[l3, wdnmd], "range" -> {0, 1}|>
     },
   "zeroPointRules" -> {
     a0[v1] -> alpha1, a0[v2] -> alpha2,
     b0[e1] -> beta1, b0[e2] -> beta2, b0[e3] -> beta3
     },
   "symmetryRules" -> {},
   "seedPreset" -> "quickCheck",
   "seedRanges" -> <|"a" -> {0}, "b" -> {0}, "isp" -> {0, 1}|>
   |>;


(* ::Chapter:: *)
(*公开工作流*)

context = DSInit[
   case,
   WriteInitializationFiles -> False,
   GenerateDerivativeMetadata -> False
   ];
seedData = DSSeeds[
   context,
   GenerateShrinkSectors -> True
   ];
allSeeds = DSAllSeeds[seedData];
(* 本例只验证两圈 ISP 与完整生成元闭合；所有连续指标在零点各展开一次。 *)
generatedIBP = DSGenerateIBP[allSeeds, {0, 0}];
linearData = DSLinear[generatedIBP, context, LinearSystemMode -> "symbolic"];

summary = <|
   "initStatus" -> Lookup[context, "status", "missing"],
   "ispCount" -> Length[Lookup[Lookup[context, "topology", <||>], "ispData", {}]],
   "generatorCount" -> Total[Length /@ {
       Lookup[Lookup[generatedIBP, "momentumSummary", <||>], "generators", {}],
       Lookup[Lookup[generatedIBP, "timeSummary", <||>], "generators", {}]
       }],
   "seedStatus" -> Lookup[seedData, "dSIBPStatus", "missing"],
   "generatedStatus" -> Lookup[generatedIBP, "dSIBPStatus", "missing"],
   "equationCount" -> Lookup[generatedIBP, "equationCount", 0],
   "linearStatus" -> Lookup[linearData, "dSIBPStatus", "missing"],
   "linearReason" -> Lookup[linearData, "reason", None],
   "pendingFeatures" -> Lookup[linearData, "pendingFeatures", Lookup[seedData, "pendingFeatures", {}]]
   |>;

Print[summary];
If[! And[
    ToString[$dSIBPVersion] === currentVersion,
    summary["initStatus"] === "initialized",
    summary["ispCount"] === 2,
    summary["seedStatus"] === "generated",
    summary["generatedStatus"] === "generated",
    summary["generatorCount"] === 8,
    summary["equationCount"] > 0,
    summary["linearStatus"] === "generated"
    ], Exit[1]];
