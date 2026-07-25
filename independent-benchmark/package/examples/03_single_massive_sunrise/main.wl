(* ::Package:: *)
(* Single-massive sunrise 示例：两顶点、三条平行边形成两圈，第一条线为 massive h，
   其余两条线为 massless exponential。共同外腿能量 kE 与圈外模长 kL 构成两个标度。 *)


(* ::Chapter:: *)
(*加载标准 package 与本例 convention*)

exampleDir = DirectoryName[$InputFileName];
Get[FileNameJoin[{exampleDir, "..", "load_current_package.wl"}]];
Get[FileNameJoin[{exampleDir, "family_conventions.wl"}]];


(* ::Chapter:: *)
(*详细物理输入*)

(* 两个 ISP 分别以两条 massless line 的动量与 massive line 动量作标量积；
   在 k321 <-> l3-k321-kL 下它们严格互换，因此可与 line 交换共同 canonicalize。 *)
case = <|
   "name" -> "singleMassiveSunriseExample",
   "vertexData" -> {{v1, "+"}, {v2, "+"}},
   "lineData" -> {
     <|"id" -> e1, "endpoints" -> {v1, v2}, "momentum" -> l3,
       "massType" -> "massive", "bbType" -> "h", "nu" -> nuM|>,
     <|"id" -> e2, "endpoints" -> {v1, v2}, "momentum" -> k321,
       "massType" -> "massless", "bbType" -> "exp", "nu" -> 0|>,
     <|"id" -> e3, "endpoints" -> {v1, v2}, "momentum" -> l3 - k321 - kL,
       "massType" -> "massless", "bbType" -> "exp", "nu" -> 0|>
     },
   "loopMomenta" -> {l3, k321},
   "loopExternalMomenta" -> {kL},
   "independentExternalMomenta" -> {},
   "ibpMode" -> "full",
   "vertexEnergies" -> <|v1 -> kE, v2 -> kE|>,
   "ispData" -> {
     <|"name" -> rhoMassless2, "expr" -> sp[k321, l3], "range" -> {0, 1}|>,
     <|"name" -> rhoMassless3, "expr" -> sp[l3 - k321 - kL, l3], "range" -> {0, 1}|>
     },
   "zeroPointRules" -> {
     a0[v1] -> alpha, a0[v2] -> alpha,
     b0[e1] -> betaM, b0[e2] -> beta0, b0[e3] -> beta0
     },
   "symmetryRules" -> sunriseSymmetryRules0,
   "seedPreset" -> "quickCheck",
   "seedRanges" -> <|"a" -> {0}, "b" -> {0}, "isp" -> {0, 1}|>
   |>;


(* ::Chapter:: *)
(*完整模板与单个最小关系*)

kinematicProposal = DSKinematics[case];
context = DSInit[
   case,
   WriteInitializationFiles -> False,
   GenerateDerivativeMetadata -> True
   ];
seedData = DSSeeds[context];
allSeeds = DSAllSeeds[seedData];

topSeeds = Select[allSeeds, Lookup[#, "sectorKey", None] === "top" &];
topGenerators = DeleteDuplicates[Lookup[topSeeds, "generator", {}]];
singleTemplate = SelectFirst[
   topSeeds,
   Lookup[#, "ibpClass", ""] === "qIBP" &,
   Missing["NoTopQIBPTemplate"]
   ];
singleOrdinal = Lookup[singleTemplate, "templateOrdinal", Missing["NoTemplateOrdinal"]];
singleSeedRecord = SelectFirst[
   Lookup[Lookup[seedData, "seedRangeMetadata", <||>], "records", {}],
   Lookup[#, "templateOrdinal", None] === singleOrdinal &,
   Missing["NoSeedMetadata"]
   ];
singleIndices = Lookup[singleSeedRecord, "continuousIndices", {}];
singleRangeMetadata = DSMetaSeedRange[{singleTemplate}, singleIndices];
singleShiftBounds = Lookup[
   First[Lookup[singleRangeMetadata, "groups", {<||>}]],
   "shiftBounds",
   {}
   ];

(* 目标包络直接取该模板的 shift 上下界，所以每个连续指标反推出的 seed 域恰为 {0,0}。 *)
singleTargetEnvelope = Replace[
   singleShiftBounds,
   Rule[index_, {minimum_, maximum_}] :> {index, minimum, maximum},
   {1}
   ];
generatedIBP = DSGenerateIBP[{singleTemplate}, Sequence @@ singleTargetEnvelope];
linearData = DSLinear[generatedIBP, context, LinearSystemMode -> "symbolic"];


(* ::Chapter:: *)
(*结果检查*)

topology = Lookup[context, "topology", <||>];
routingAudit = Lookup[topology, "loopMomentumRoutingAudit", <||>];
canonicalWitness = symmetry[
   J[
    {1, 0},
    {{0, 0, 1}, {2, 0, 1}, {1, 1, 0}},
    {3, 1}
    ],
   topology
   ];
expectedCanonicalWitness = J[
   {0, 1},
   {{0, 1, 0}, {1, 0, 1}, {2, 1, 0}},
   {1, 3}
   ];

summary = <|
   "initStatus" -> Lookup[context, "status", "missing"],
   "kinematicStatus" -> Lookup[kinematicProposal, "status", "missing"],
   "graphLoopCount" -> Lookup[topology, "graphLoopCount", Missing["loopCount"]],
   "cycleLineIndices" -> Lookup[topology, "cycleLineIndices", {}],
   "bridgeLineIndices" -> Lookup[topology, "bridgeLineIndices", {}],
   "loopRoutingRank" -> Lookup[routingAudit, "loopCoefficientRank", Missing["routingRank"]],
   "vertexEnergies" -> Lookup[topology, "vertexEnergies", <||>],
   "massiveLineCount" -> Count[Lookup[Lookup[topology, "lines", {}], "massType", {}], "massive"],
   "ispCount" -> Length[Lookup[topology, "ispData", {}]],
   "topGeneratorCount" -> Length[topGenerators],
   "symmetryRuleCount" -> Length[repSymmetry0[topology]],
   "canonicalWitness" -> canonicalWitness,
   "seedStatus" -> Lookup[seedData, "dSIBPStatus", "missing"],
   "singleRangeStatus" -> Lookup[singleRangeMetadata, "status", "missing"],
   "singleTargetEnvelope" -> singleTargetEnvelope,
   "derivedSeedRanges" -> Lookup[generatedIBP, "derivedSeedRanges", {}],
   "generatedStatus" -> Lookup[generatedIBP, "dSIBPStatus", "missing"],
   "equationCount" -> Lookup[generatedIBP, "equationCount", 0],
   "subsetQ" -> TrueQ[Lookup[Lookup[generatedIBP, "artifactContract", <||>], "subsetQ", False]],
   "linearStatus" -> Lookup[linearData, "dSIBPStatus", "missing"],
   "linearCompleteSystemQ" -> TrueQ[Lookup[linearData, "completeSystemQ", True]]
   |>;

Print[summary];
If[! And[
    ToString[$dSIBPVersion] === currentVersion,
    summary["initStatus"] === "initialized",
    summary["kinematicStatus"] === "complete",
    summary["graphLoopCount"] === 2,
    summary["cycleLineIndices"] === {1, 2, 3},
    summary["bridgeLineIndices"] === {},
    summary["loopRoutingRank"] === 2,
    summary["vertexEnergies"] === <|v1 -> kE, v2 -> kE|>,
    summary["massiveLineCount"] === 1,
    summary["ispCount"] === 2,
    summary["topGeneratorCount"] === 8,
    summary["symmetryRuleCount"] === 1,
    summary["canonicalWitness"] === expectedCanonicalWitness,
    summary["seedStatus"] === "generated",
    summary["singleRangeStatus"] === "initialized",
    summary["generatedStatus"] === "generated",
    summary["equationCount"] > 0,
    summary["subsetQ"],
    summary["linearStatus"] === "generated",
    ! summary["linearCompleteSystemQ"]
    ], Exit[1]];
