(* ::Package:: *)
(* 文件用途：在一个固定的 pure massive bubble 上检查 general time/momentum IBP seed templates。
   本脚本只调用 DSSeeds，不连续撒点，不生成 linearData，也不运行 reduction。 *)


(* ::Chapter:: *)
(*加载开发包与限定 topology*)

Get[FileNameJoin[{DirectoryName[$InputFileName], "..", "_harness.wls"}]];
projectRoot = DirectoryName[DirectoryName[DirectoryName[$InputFileName]]];
dsSmokeLoadPackage[FileNameJoin[{projectRoot, "versions", "022_dSIBP", "Kernel", "dSIBP.wl"}]];
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
     a0[v1] -> 2 nu, a0[v2] -> 2 nu,
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
Print["check_general_ibp_seeds: ", Count[Values[checks], True], "/", Length[checks]];
Print["failed: ", InputForm[failed]];
Print[InputForm[<|"passed" -> Count[Values[checks], True], "total" -> Length[checks], "failed" -> failed,
    "topTimeSeedCount" -> Length[timeRecords],
    "topMomentumSeedCount" -> Length[momentumRecords],
    "generalSourceIndices" -> generalSourceIndices,
  "checks" -> checks|>]];
If[Count[Values[checks], True] =!= Length[checks], Exit[1]];
