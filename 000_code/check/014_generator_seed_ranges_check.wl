(* ::Package:: *)
(* 014 generator-specific seed ranges 专项：验证按 sector/generator 覆盖连续指标范围、
   旧统一 seedRanges 兼容路径，以及重复记录、未知指标和畸形范围的定向门禁。 *)

(* ::Chapter:: *)
(*加载 package 与固定 bubble family*)

checkDir = DirectoryName[$InputFileName];
codeDir = DirectoryName[checkDir];
packageDir = FileNameJoin[{codeDir, "014_dSIBP"}];
If[! MemberQ[$Path, packageDir], AppendTo[$Path, packageDir]];
Needs["dSIBP`"];
DSMessagesOff[];

generatorRanges = {
   <|"sectorKey" -> "top", "generator" -> {"time", v1},
    "ranges" -> {a[v1] -> Range[0, 1]}|>,
   <|"sectorKey" -> "top", "generator" -> {"time", v2},
    "ranges" -> {a[v2] -> Range[0, 2]}|>,
   <|"sectorKey" -> "top", "generator" -> {"momentum", 1, "loop", 1},
    "ranges" -> {b[1] -> Range[0, 1]}|>,
   <|"sectorKey" -> "top", "generator" -> {"momentum", 1, "external", 1},
    "ranges" -> {b[2] -> Range[0, 3]}|>,
   <|"sectorKey" -> "e1", "generator" -> {"time", v1},
    "ranges" -> {bS[1] -> Range[0, 1]}|>,
   <|"sectorKey" -> "e1", "generator" -> {"momentum", 1, "loop", 1},
    "ranges" -> {a[v1] -> Range[0, 1]}|>,
   <|"sectorKey" -> "e1", "generator" -> {"momentum", 1, "external", 1},
    "ranges" -> {b[2] -> Range[0, 2]}|>,
   <|"sectorKey" -> "e2", "generator" -> {"time", v1},
    "ranges" -> {bS[2] -> Range[0, 3]}|>,
   <|"sectorKey" -> "e2", "generator" -> {"momentum", 1, "loop", 1},
    "ranges" -> {b[1] -> Range[0, 1]}|>,
   <|"sectorKey" -> "e2", "generator" -> {"momentum", 1, "external", 1},
    "ranges" -> {a[v1] -> Range[0, 2]}|>
   };

rangeCase = <|
   "name" -> "014GeneratorSeedRangesFixture",
   "vertexData" -> {{v1, "+"}, {v2, "+"}},
   "lineData" -> {
     <|"id" -> 1, "endpoints" -> {v1, v2}, "momentum" -> q,
      "nu" -> nu1, "bbType" -> "h", "massType" -> "massive"|>,
     <|"id" -> 2, "endpoints" -> {v1, v2}, "momentum" -> q - k,
      "nu" -> nu2, "bbType" -> "h", "massType" -> "massive"|>
     },
   "loopMomenta" -> {q},
   "externalMomenta" -> {k},
   "externalInvariantRules" -> {sp[k, k] -> s11},
   "vertexEnergies" -> <|v1 -> P1, v2 -> P2|>,
   "zeroPointRules" -> {
     a0[v1] -> alpha1, a0[v2] -> alpha2,
     b0[1] -> beta1, b0[2] -> beta2,
     bS0[1] -> beta1, bS0[2] -> beta2
     },
   "symmetryRules" -> {},
   "seedPreset" -> "quickCheck",
   "seedRanges" -> <|"a" -> {0}, "b" -> {0}, "isp" -> {0}, "sampleOnly" -> False|>,
   "generatorSeedRanges" -> generatorRanges,
   "seedOptions" -> <|"DiscreteMode" -> "none", "MaxSeedRuleCount" -> 100,
     "MaxEquationCount" -> 100, "MaxShrinkSectorCount" -> 4|>
   |>;

rangeContext = DSInit[rangeCase, RegisterAsCurrent -> False];
If[Lookup[rangeContext, "status", "missing"] =!= "initialized",
 Print["generator range init failed=", rangeContext]
 ];
rangeSeed = DSSeeds[
   rangeContext,
   DiscreteMode -> "none",
   MaxSeedRuleCount -> 100,
   MaxEquationCount -> 100,
   MaxShrinkSectorCount -> 4
   ];


(* ::Chapter:: *)
(*生成元计数与 metadata 检查*)

shrinkSummaries = Association @ Map[
    Lookup[#, "sectorKey"] -> # &,
    Lookup[Lookup[rangeSeed, "shrinkSectorSummary", <||>], "sectorSummaries", {}]
    ];
topTimeData = Lookup[Lookup[rangeSeed, "timeSummary", <||>], "generatorContinuousSeedData", {}];
topMomentumData = Lookup[Lookup[rangeSeed, "momentumSummary", <||>], "generatorContinuousSeedData", {}];
e1Summary = Lookup[shrinkSummaries, "e1", <||>];
e2Summary = Lookup[shrinkSummaries, "e2", <||>];

generatorRuleCount[data_List, label_List] := Lookup[
   SelectFirst[data, Lookup[#, "generator", Missing["generator"]] === label &, <||>],
   "ruleCount",
   -1
   ];

e1TimeData = Lookup[Lookup[e1Summary, "timeSummary", <||>], "generatorContinuousSeedData", {}];
e1MomentumData = Lookup[Lookup[e1Summary, "momentumSummary", <||>], "generatorContinuousSeedData", {}];
e2TimeData = Lookup[Lookup[e2Summary, "timeSummary", <||>], "generatorContinuousSeedData", {}];
e2MomentumData = Lookup[Lookup[e2Summary, "momentumSummary", <||>], "generatorContinuousSeedData", {}];

uniformCase = KeyDrop[rangeCase, "generatorSeedRanges"];
uniformContext = DSInit[uniformCase, RegisterAsCurrent -> False];
uniformTime = dSIBP`Private`makeTimeIBPSeedBatch[
   uniformContext["topology"],
   UseSampleOnly -> False,
   DiscreteMode -> "none",
   MaxSeedRuleCount -> 100,
   MaxEquationCount -> 100
   ];


(* ::Chapter:: *)
(*负例门禁*)

duplicateCase = Join[rangeCase, <|"generatorSeedRanges" -> Append[generatorRanges, First[generatorRanges]]|>];
duplicateContext = DSInit[duplicateCase, RegisterAsCurrent -> False];
duplicateTime = dSIBP`Private`makeTimeIBPSeedBatch[
   duplicateContext["topology"], UseSampleOnly -> False, DiscreteMode -> "none",
   MaxSeedRuleCount -> 100, MaxEquationCount -> 100
   ];

unknownRangeEntry = Join[First[generatorRanges], <|"ranges" -> {ghostIndex -> Range[0, 1]}|>];
unknownCase = Join[rangeCase, <|"generatorSeedRanges" -> ReplacePart[generatorRanges, 1 -> unknownRangeEntry]|>];
unknownContext = DSInit[unknownCase, RegisterAsCurrent -> False];
unknownTime = dSIBP`Private`makeTimeIBPSeedBatch[
   unknownContext["topology"], UseSampleOnly -> False, DiscreteMode -> "none",
   MaxSeedRuleCount -> 100, MaxEquationCount -> 100
   ];

malformedCase = Join[rangeCase, <|"generatorSeedRanges" -> {
      <|"sectorKey" -> "top", "generator" -> {"time", v1}, "ranges" -> {a[v1] -> "bad"}|>
      }|>];
malformedContext = Quiet[DSInit[malformedCase, RegisterAsCurrent -> False]];


(* ::Chapter:: *)
(*汇总*)

checks = <|
   "initialized" -> Lookup[rangeContext, "status", "missing"] === "initialized",
   "canonicalGenerated" -> Lookup[rangeSeed, "status", "missing"] === "generated",
   "allSectorEquationCount" -> Lookup[rangeSeed, "equationCount", -1] === 27,
   "topTimeCounts" -> (generatorRuleCount[topTimeData, #] & /@ {
       {"time", v1}, {"time", v2}
       }) === {2, 3},
   "topMomentumCounts" -> (generatorRuleCount[topMomentumData, #] & /@ {
       {"momentum", 1, "loop", 1}, {"momentum", 1, "external", 1}
       }) === {2, 4},
   "e1TimeCount" -> generatorRuleCount[e1TimeData, {"time", v1}] === 2,
   "e1MomentumCounts" -> ((generatorRuleCount[e1MomentumData, #] & /@ {
       {"momentum", 1, "loop", 1}, {"momentum", 1, "external", 1}
       }) === {2, 3}),
   "e2TimeCount" -> generatorRuleCount[e2TimeData, {"time", v1}] === 4,
   "e2MomentumCounts" -> ((generatorRuleCount[e2MomentumData, #] & /@ {
       {"momentum", 1, "loop", 1}, {"momentum", 1, "external", 1}
       }) === {2, 3}),
   "metadataRangeSource" -> And @@ (# === "generatorOverride" & /@ Lookup[Join[topTimeData, topMomentumData], "rangeSource", "missing"]),
   "uniformCompatibility" -> Lookup[uniformTime, "status", "missing"] === "generated" &&
     Lookup[uniformTime, "equationCount", -1] === 2 &&
     ! TrueQ[Lookup[uniformTime, "generatorSpecificContinuousRangesQ", True]],
   "duplicateRejected" -> Lookup[duplicateTime, "status", "missing"] === "invalidGeneratorSeedRanges",
   "unknownVariableRejected" -> Lookup[unknownTime, "status", "missing"] === "invalidGeneratorSeedRanges",
   "malformedInputRejected" -> Lookup[malformedContext, "status", "missing"] === "failed" &&
     Lookup[Lookup[malformedContext, "topologyData", <||>], "status", "missing"] === "invalidInput"
   |>;

Print["014 generator seed ranges check: ", Count[Values[checks], True], "/", Length[checks]];
If[! And @@ Values[checks],
 Print[Select[checks, Not]];
 Exit[1]
 ];
