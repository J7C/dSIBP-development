(* ::Package:: *)
(* 文件用途：在一个固定的 pure massive bubble 上检查 general time/momentum IBP seed templates。
   本脚本只调用 DSSeeds，不连续撒点，不生成 linearData，也不运行 reduction。 *)


(* ::Chapter:: *)
(*加载开发包与限定 topology*)

projectRoot = DirectoryName[DirectoryName[DirectoryName[$InputFileName]]];
packageDir = FileNameJoin[{projectRoot, "000_code", "018_dSIBP"}];
$Path = Prepend[$Path, packageDir];
Needs["dSIBP`"];
DSMessagesOff[];

caseInput = <|
   "name" -> "CheckGeneralIBPSeedsPureMassiveBubble",
   "vertexData" -> {{v1, "-"}, {v2, "-"}},
   "lineData" -> {
     <|"id" -> 1, "endpoints" -> {v1, v2}, "momentum" -> q,
       "massType" -> "massive", "bbType" -> "h", "nu" -> nu|>,
     <|"id" -> 2, "endpoints" -> {v1, v2}, "momentum" -> q - k,
       "massType" -> "massive", "bbType" -> "h", "nu" -> nu|>
     },
   "loopMomenta" -> {q},
   "loopExternalMomenta" -> {k},
   "independentExternalMomenta" -> {},
   "ibpMode" -> "full",
   "externalInvariantRules" -> {sp[k, k] -> ss11^2},
   "vertexEnergies" -> <|v1 -> P0, v2 -> P0|>,
   "ispData" -> {},
   "zeroPointRules" -> {
     a0[v1] -> 2 nu, a0[v2] -> 2 nu,
     b0[1] -> -2 nu, b0[2] -> -2 nu
     },
   "symmetryRules" -> {},
   "seedPreset" -> "quickCheck"
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
topRecords = Select[records, Lookup[#, "sectorKey", None] === "top" &];
timeRecords = Select[topRecords, Lookup[#, "ibpClass", None] === "tIBP" &];
momentumRecords = Select[topRecords, Lookup[#, "ibpClass", None] === "mIBP" &];
generalSourceIndices = DeleteDuplicates@Cases[
    Lookup[topRecords, "sourceIntegral", {}],
    _a | _b | _bS,
    Infinity
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
    ContainsAll[generalSourceIndices, {a[v1], a[v2], b[1], b[2]}]
   |>;

failed = Keys@Select[checks, Not@TrueQ[#] &];
Print[InputForm[<|
   "passed" -> Count[Values[checks], True],
   "total" -> Length[checks],
   "failed" -> failed,
   "topTimeSeedCount" -> Length[timeRecords],
   "topMomentumSeedCount" -> Length[momentumRecords],
   "generalSourceIndices" -> generalSourceIndices,
   "checks" -> checks
   |>]];
Exit[If[failed === {}, 0, 1]];
