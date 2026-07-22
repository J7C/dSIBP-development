(* ::Package:: *)
(* 本正式专项验证 016 pure-time 的共同 theta odd-subset、分支门禁、general a seed range
   与三顶点 contact-reachable sector。测试只使用 J[vertexPacks] 生产路径。 *)

(* ::Chapter:: *)
(*加载 016*)

checkDir = DirectoryName[$InputFileName];
codeDir = DirectoryName[checkDir];
packageDir = FileNameJoin[{codeDir, "016_dSIBP"}];
If[! MemberQ[$Path, packageDir], AppendTo[$Path, packageDir]];
Needs["dSIBP`"];
DSMessagesOff[];


(* ::Chapter:: *)
(*两顶点平行 massive family*)

parallelCase[name_String, signs_List, count_Integer] := Module[
   {momenta = Take[{p1, p2, p3}, count], energies = Take[{k1, k2, k3}, count],
    masses = Take[{nu1, nu2, nu3}, count], zeroPoints = Take[{beta1, beta2, beta3}, count]},
   <|
    "name" -> name,
    "vertexData" -> Transpose[{{v1, v2}, signs}],
    "lineData" -> Table[
      <|"id" -> e, "endpoints" -> {v1, v2}, "momentum" -> momenta[[e]],
        "treeEnergy" -> energies[[e]], "nu" -> masses[[e]], "bbType" -> "h", "massType" -> "massive"|>,
      {e, count}
      ],
    "loopMomenta" -> {},
    "loopExternalMomenta" -> {},
    "independentExternalMomenta" -> momenta,
    "ibpMode" -> "timeOnly",
    "ispData" -> {},
    "vertexEnergies" -> <|v1 -> E1, v2 -> E2|>,
    "zeroPointRules" -> Join[
      {a0[v1] -> alpha1, a0[v2] -> alpha2},
      Table[b0[e] -> zeroPoints[[e]], {e, count}]
      ],
    "symmetryRules" -> {},
    "seedPreset" -> "quickCheck"
    |>
   ];


contactSectorKeys[record_Association] := Sort@DeleteDuplicates@Lookup[
    Select[Lookup[Lookup[record, "treeLinearData", <||>], "terms", {}],
      Lookup[#, "sectorKey", "top"] =!= "top" &],
    "sectorKey",
    {}
    ];


makeSelectedStateIntegral[context_Association, endpointOneState_Integer, endpointTwoState_Integer] := Module[
   {family = dSIBP`Private`dsTreeFamilyContext[context]["topFamily"], count},
   count = Lookup[family["vertices"][[1]], "p", 0];
   J[{
     Join[{1}, ConstantArray[endpointOneState, count]],
     Join[{0}, ConstantArray[endpointTwoState, count]]
     }]
   ];


plusTwoContext = DSInit[parallelCase["016ParallelTwoPlus", {"+", "+"}, 2],
   RegisterAsCurrent -> False, ProgressReporting -> False];
minusTwoContext = DSInit[parallelCase["016ParallelTwoMinus", {"-", "-"}, 2],
   RegisterAsCurrent -> False, ProgressReporting -> False];
mixedTwoContext = DSInit[parallelCase["016ParallelTwoMixed", {"+", "-"}, 2],
   RegisterAsCurrent -> False, ProgressReporting -> False];
plusThreeContext = DSInit[parallelCase["016ParallelThreePlus", {"+", "+"}, 3],
   RegisterAsCurrent -> False, ProgressReporting -> False];

plusTwoRecord = DSTreeSeeds[v1, makeSelectedStateIntegral[plusTwoContext, 1, 0], plusTwoContext];
minusTwoRecord = DSTreeSeeds[v1, makeSelectedStateIntegral[minusTwoContext, 1, 0], minusTwoContext];
mixedTwoRecord = DSTreeSeeds[v1, makeSelectedStateIntegral[mixedTwoContext, 1, 0], mixedTwoContext];
plusThreeRecord = DSTreeSeeds[v1, makeSelectedStateIntegral[plusThreeContext, 1, 0], plusThreeContext];


(* ::Chapter:: *)
(*三顶点 massive 链*)

chainCase = <|
   "name" -> "016ThreeVertexMassiveChain",
   "vertexData" -> {{v1, "+"}, {v2, "+"}, {v3, "+"}},
   "lineData" -> {
     <|"id" -> 1, "endpoints" -> {v1, v2}, "momentum" -> p12,
       "treeEnergy" -> k12, "nu" -> nu12, "bbType" -> "h", "massType" -> "massive"|>,
     <|"id" -> 2, "endpoints" -> {v2, v3}, "momentum" -> p23,
       "treeEnergy" -> k23, "nu" -> nu23, "bbType" -> "h", "massType" -> "massive"|>
     },
   "loopMomenta" -> {},
   "loopExternalMomenta" -> {},
   "independentExternalMomenta" -> {p12, p23},
   "ibpMode" -> "timeOnly",
   "ispData" -> {},
   "vertexEnergies" -> <|v1 -> E1, v2 -> E2, v3 -> E3|>,
   "zeroPointRules" -> {a0[v1] -> alpha1, a0[v2] -> alpha2, a0[v3] -> alpha3,
     b0[1] -> beta12, b0[2] -> beta23},
   "symmetryRules" -> {},
   "seedPreset" -> "quickCheck"
   |>;

chainContext = DSInit[chainCase, RegisterAsCurrent -> False, ProgressReporting -> False];
chainBatch = DSSeeds[chainContext, ProgressReporting -> False];


(* ::Section::Closed:: *)
(*direct seed 与公式迭代的显式 treeEnergy 对照*)

singleLineContext = DSInit[parallelCase["016SingleLineIteration", {"+", "+"}, 1],
   RegisterAsCurrent -> False, ProgressReporting -> False];
singleLineSeedIntegral = J[{{0, 0}, {0, 0}}];
singleLineTarget = J[{{-1, 0}, {0, 0}}];
singleLineSeed = Lookup[DSTreeSeeds[v1, singleLineSeedIntegral, singleLineContext], "treeSeed", $Failed];
singleLineRule = If[singleLineSeed === $Failed, $Failed,
   FirstCase[Solve[singleLineSeed == 0, singleLineTarget], rule_List :> rule, $Failed]];
singleLineSeedReduction = If[ListQ[singleLineRule], singleLineTarget /. singleLineRule, $Failed];
singleLineFormulaReduction = repIterative[singleLineTarget, {0, 0}, singleLineContext];
singleLineIterationDifference = Together[Expand[singleLineFormulaReduction - singleLineSeedReduction]];

chainSeedIntegral = J[{{0, 0}, {0, 0, 0}, {0, 0}}];
chainTarget = J[{{0, 0}, {0, 0, 0}, {-1, 0}}];
chainSeed = Lookup[DSTreeSeeds[v3, chainSeedIntegral, chainContext], "treeSeed", $Failed];
chainRule = If[chainSeed === $Failed, $Failed,
   FirstCase[Solve[chainSeed == 0, chainTarget], rule_List :> rule, $Failed]];
chainSeedReduction = If[ListQ[chainRule], chainTarget /. chainRule, $Failed];
chainFormulaReduction = repIterative[chainTarget, {0, 0, 0}, chainContext];
chainIterationDifference = Together[Expand[chainFormulaReduction - chainSeedReduction]];

iterationProbeRules = {alpha1 -> 5/7, alpha2 -> 7/9, alpha3 -> 11/13,
   nu1 -> 2/5, nu12 -> 3/8, nu23 -> 4/9, E1 -> 11/6, E2 -> 13/7, E3 -> 17/8,
   k1 -> 19/11, k12 -> 23/10, k23 -> 29/12, sE1 -> 31/14, sE2 -> 37/15,
   HoldPattern[_J] -> 7/11};


(* ::Chapter:: *)
(*General a 与 massless tree-state 门禁*)

generalACase = Join[parallelCase["016GeneralA", {"+", "-"}, 1], <|
    "seedPreset" -> "bounded",
    "seedRanges" -> <|"a" -> {-1, 1}, "b" -> {0}, "isp" -> {0}, "sampleOnly" -> False|>,
    "seedOptions" -> <|"MaxSeedRuleCount" -> 20, "MaxDiscreteRuleCount" -> 16,
      "MaxEquationCount" -> 100|>
    |>];
generalAContext = DSInit[generalACase, RegisterAsCurrent -> False, ProgressReporting -> False];
generalABatch = DSSeeds[generalAContext, UseSampleOnly -> False, ProgressReporting -> False];
generalAValues = DeleteDuplicates@Flatten[
    First[Lookup[#, "treeIntegral"]][[All, 1]] & /@ Lookup[generalABatch, "seedRecords", {}]
    ];

masslessCase = Join[parallelCase["016MasslessTreeGuard", {"+", "+"}, 1], <|
    "lineData" -> {
      <|"id" -> 1, "endpoints" -> {v1, v2}, "momentum" -> p1,
        "treeEnergy" -> k1, "nu" -> 0, "bbType" -> "exp", "massType" -> "massless"|>
      }
    |>];
masslessContext = DSInit[masslessCase, RegisterAsCurrent -> False, ProgressReporting -> False];
masslessBatch = Quiet[DSSeeds[masslessContext, ProgressReporting -> False], DSSeeds::failed];


(* ::Chapter:: *)
(*断言*)

checks = <|
   "parallelContextsInitialized" -> And @@ (
      Lookup[#, "status", "failed"] === "initialized" & /@
       {plusTwoContext, minusTwoContext, mixedTwoContext, plusThreeContext}
      ),
   "twoLinePlusOnlySingleContacts" -> contactSectorKeys[plusTwoRecord] === {"e1", "e2"},
   "twoLineMinusOnlySingleContacts" -> contactSectorKeys[minusTwoRecord] === {"e1", "e2"},
   "mixedBranchHasNoContacts" -> contactSectorKeys[mixedTwoRecord] === {},
   "threeLineOddSubsets" -> contactSectorKeys[plusThreeRecord] ===
     {"e1", "e1_e2_e3", "e2", "e3"},
   "threeLineNoPairContacts" -> Intersection[
      contactSectorKeys[plusThreeRecord], {"e1_e2", "e1_e3", "e2_e3"}] === {},
   "directRecordsDoNotBuildLoopSeeds" -> And @@ (
      Lookup[#, "generationRoute", None] === "directPureTime" &&
        MatchQ[Lookup[#, "loopSeed", None], Missing["NotUsed"]] & /@
       {plusTwoRecord, minusTwoRecord, mixedTwoRecord, plusThreeRecord}
      ),
   "threeVertexChainBatch" -> Lookup[chainBatch, "status", "failed"] === "generated" &&
     Lookup[chainBatch, "representation", None] === "J[vertexPacks]" &&
     Lookup[chainBatch, "sectorCount", 0] === 4,
   "singleLineIterationMatchesDirectSeed" -> TrueQ[singleLineIterationDifference === 0],
   "singleLineIterationProbe" -> TrueQ[Together[singleLineIterationDifference /. iterationProbeRules] === 0],
   "chainIterationMatchesDirectSeed" -> TrueQ[chainIterationDifference === 0],
   "chainIterationProbe" -> TrueQ[Together[chainIterationDifference /. iterationProbeRules] === 0],
   "generalARangePreserved" -> Lookup[generalABatch, "status", "failed"] === "generated" &&
     Sort[generalAValues] === {-1, 0, 1},
   "masslessFullExplicitlyRejected" -> Lookup[masslessBatch, "status", "generated"] === "unsupportedTreeState" &&
     Lookup[masslessBatch, "reason", None] === "masslessFullNeedsTreeState"
   |>;


Print["016 pure-time theta: ", Count[Values[checks], True], "/", Length[checks]];
If[! And @@ Values[checks],
 Print["FAILED: ", Keys@Select[checks, ! TrueQ[#] &]];
 Print["plus two sectors: ", contactSectorKeys[plusTwoRecord]];
 Print["minus two sectors: ", contactSectorKeys[minusTwoRecord]];
 Print["plus three sectors: ", contactSectorKeys[plusThreeRecord]];
 Print["chain batch: ", Lookup[chainBatch, {"status", "sectorCount", "equationCount"}, Missing["chain"]]];
 Print["single iteration difference: ", singleLineIterationDifference];
 Print["chain iteration difference: ", chainIterationDifference];
 Print["general a: ", generalAValues];
 Print["massless: ", Lookup[masslessBatch, {"status", "reason"}, Missing["massless"]]];
 Exit[1]
 ];
