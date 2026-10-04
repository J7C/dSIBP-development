(* ::Package:: *)
(* 文件用途：在一个固定的 pure massive bubble 上检查 general time/momentum IBP seed templates。
   本脚本只调用 DSSeeds，不连续撒点，不生成 linearData，也不运行 reduction。 *)


(* ::Chapter:: *)
(*加载开发包与限定 topology*)

Get[FileNameJoin[{DirectoryName[$InputFileName], "..", "_harness.wls"}]];
projectRoot = DirectoryName[DirectoryName[DirectoryName[$InputFileName]]];
dsSmokeLoadPackage[FileNameJoin[{projectRoot, "versions", "023_dSIBP", "Kernel", "dSIBP.wl"}]];
DSMessagesOff[];

caseInput = <|
   "name" -> "CheckGeneralIBPSeedsPureMassiveBubble",
   "vertices" -> {
     <|"id" -> v1, "vertexType" -> "-", "externalLegEnergy" -> P0|>,
     <|"id" -> v2, "vertexType" -> "-", "externalLegEnergy" -> P0|>
     },
   "lines" -> {
     <|"id" -> 1, "endpoints" -> {v1, v2}, "momentum" -> q,
       "massType" -> "massive", "nu" -> nu|>,
     <|"id" -> 2, "endpoints" -> {v1, v2}, "momentum" -> q - k,
       "massType" -> "massive", "nu" -> nu|>
     },
   "loopMomenta" -> {q},
   "loopExternalMomenta" -> {k},
   "independentExternalMomenta" -> {},
   "ibpMode" -> "full",
   "kinematicRules" -> {sp[k, k] -> ss11^2},
   "ispData" -> {},
   "zeroPointRules" -> {
     a0[v1] -> 2 nu + ep, a0[v2] -> 2 nu + ep,
     b0[1] -> -2 nu, b0[2] -> -2 nu
     },
   "symmetryRules" -> {}
   |>;

context = DSInit[
   caseInput,
   RegisterAsCurrent -> False,
   WriteInitializationFiles -> False,
   GenerateDerivativeMetadata -> False,
   ProgressReporting -> False
   ];


(* ::Chapter:: *)
(*只构造 general seed templates*)

seedData = DSSeeds[context, ProgressReporting -> False];
records = DSAllSeeds[seedData];
topSectorKey = Lookup[First[Lookup[context, "sectors", {<||>}]], "sectorKey", Missing["topSectorKey"]];
topRecords = Select[records, Lookup[#, "sectorKey", None] === topSectorKey &];
timeRecords = Select[topRecords, Lookup[#, "ibpClass", None] === "tIBP" &];
momentumRecords = Select[topRecords, Lookup[#, "ibpClass", None] === "qIBP" &];
generalSourceIndices = DeleteDuplicates@Cases[
    Lookup[topRecords, "sourceIntegral", {}],
    _a | _b | _bS,
    Infinity
    ];


(* ::Chapter:: *)
(*参考线平移后的 ISP 定义*)

(* 输入 ISP 使用原始 q；参考线 q-k1 被规范为新 q 后，原 q 必须同步成为 q+k1。 *)
routingCaseInput = <|
   "name" -> "CheckGeneralIBPSeedsRoutingISP",
   "vertices" -> {
     <|"id" -> r1, "vertexType" -> "+", "externalLegEnergy" -> ER1|>,
     <|"id" -> r2, "vertexType" -> "+", "externalLegEnergy" -> ER2|>
     },
   "lines" -> {
     <|"id" -> 1, "endpoints" -> {r1, r2}, "momentum" -> q - k1,
       "massType" -> "massless"|>,
     <|"id" -> 2, "endpoints" -> {r1, r2}, "momentum" -> q - k2,
       "massType" -> "massless"|>
     },
   "loopMomenta" -> {q},
   "loopExternalMomenta" -> {k1, k2},
   "independentExternalMomenta" -> {},
   "ibpMode" -> "full",
   "ispData" -> {<|"name" -> rho, "expr" -> sp[q, k1], "range" -> {0, 1}|>},
   "zeroPointRules" -> {
     a0[r1] -> alpha1 + ep, a0[r2] -> alpha2 + ep,
     b0[1] -> beta1, b0[2] -> beta2
     },
   "symmetryRules" -> {}
   |>;

routingContext = DSInit[
   routingCaseInput,
   RegisterAsCurrent -> False,
   WriteInitializationFiles -> False,
   GenerateDerivativeMetadata -> False,
   ProgressReporting -> False
   ];
routingISPExpression = Lookup[routingContext["topology", "ispData"][[1]], "expr", Missing["expr"]];
routingISPInternal = First[dSIBP`Private`normalizeISPExprs[routingContext["topology"]]];
routingTopology = routingContext["topology"];
routingBaseIntegral = dSIBP`Private`makeBaseIntegral[routingTopology];
routingUserDQQ = SelectFirst[
   dSIBP`Private`makeIBPGenerators[routingTopology],
   Lookup[#, "type", ""] === "momentum" && Lookup[#, "vectorType", ""] === "loop" &
   ];
routingPrimitiveTerms = Lookup[routingUserDQQ, "normalizedPrimitiveTerms", {}];
routingAffineActual = dSIBP`Private`applyMomentumGeneratorSeed[
   routingTopology,
   routingBaseIntegral,
   routingUserDQQ
   ];
routingAffineExpected = Expand@Total[
    Lookup[#, "coefficient", 0] dSIBP`Private`applyMomentumGeneratorSeed[
        routingTopology,
        routingBaseIntegral,
        Lookup[#, "generator", <||>]
        ] & /@ routingPrimitiveTerms
    ];


(* ::Chapter:: *)
(*验收*)

checks = <|
   "initialized" -> (Lookup[context, "status", "failed"] === "initialized"),
   "seedsGenerated" ->
    (Lookup[seedData, "status", Lookup[seedData, "dSIBPStatus", "failed"]] === "generated"),
   "topTimeSeedsPresent" -> (Length[timeRecords] > 0),
   "topMomentumSeedsPresent" -> (Length[momentumRecords] > 0),
   "onlyUnifiedJHead" -> And @@ (MatchQ[Lookup[#, "sourceIntegral", None], _J] & /@ topRecords),
   "continuousIndicesUnassigned" ->
    ContainsAll[generalSourceIndices, {a[v1], a[v2], b[1], b[2]}],
   "routingISPInitialized" -> (Lookup[routingContext, "status", "failed"] === "initialized"),
   "routingISPInputDefinitionPreserved" ->
    SameQ[routingISPExpression, sp[k1 + q, k1]],
   "routingISPInternalShiftPreserved" ->
    SameQ[Expand[routingISPInternal], kk[1, 1] + qk[1, 1]],
   "routingUserDQQCompiledToAffineTerms" -> (
     Lookup[routingPrimitiveTerms, "coefficient", {}] === {1, 1} &&
      Lookup[Lookup[routingPrimitiveTerms, "generator", {}], "vector", {}] === {q, k1}
     ),
   "routingUserDQQAffineIdentity" ->
    TrueQ[Expand[routingAffineActual - routingAffineExpected] === 0]
   |>;

failed = Keys@Select[checks, Not@TrueQ[#] &];
Print["check_general_ibp_seeds: ", Count[Values[checks], True], "/", Length[checks]];
Print["failed: ", InputForm[failed]];
Print[InputForm[<|"passed" -> Count[Values[checks], True], "total" -> Length[checks], "failed" -> failed,
    "topTimeSeedCount" -> Length[timeRecords],
    "topMomentumSeedCount" -> Length[momentumRecords],
    "generalSourceIndices" -> generalSourceIndices,
    "routingISPExpression" -> routingISPExpression,
    "routingISPInternal" -> routingISPInternal,
    "routingPrimitiveTerms" -> routingPrimitiveTerms,
    "routingAffineResidual" -> Expand[routingAffineActual - routingAffineExpected],
  "checks" -> checks|>]];
If[Count[Values[checks], True] =!= Length[checks], Exit[1]];
