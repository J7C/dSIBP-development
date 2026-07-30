(* ::Package:: *)
(***
文件：check_time_only_public_representation_020.wls
用途：验证 020 time-only 公开 J 只使用 sectorKey、timeShifts 与 stateBits。
核心检查：mixed 三顶点全 sector 往返、DSSeeds/DSGenerateIBP/DSLinear 与 ds/dtau 输出均无旧三槽 J。
边界：只取很小的连续指标范围，不运行 Kira、reduction、DE 或 scaling。
***)


(* ::Chapter:: *)
(*加载与 mixed 三顶点输入*)

projectRoot = DirectoryName[DirectoryName[DirectoryName[$InputFileName]]];
packageOverride = Quiet[Environment["DSIBP_PACKAGE_FILE"]];
If[StringQ[packageOverride] && StringLength[StringTrim[packageOverride]] > 0,
 Get[ExpandFileName[packageOverride]],
 packageDirectory = FileNameJoin[{projectRoot, "versions", "020_dSIBP"}];
 $Path = Prepend[$Path, packageDirectory];
 Needs["dSIBP`"]
 ];
DSMessagesOff[];

caseInput = <|
   "name" -> "CheckTimeOnlyPublicRepresentation020",
   "vertexData" -> {{v1, "+"}, {v2, "+"}, {v3, "+"}},
   "lineData" -> {
     <|"id" -> em, "endpoints" -> {v1, v2}, "momentum" -> pM,
       "treeEnergy" -> sE1, "nu" -> -mu, "bbType" -> "h",
       "massType" -> "massive", "skType" -> "++"|>,
     <|"id" -> ez, "endpoints" -> {v2, v3}, "momentum" -> pZ,
       "treeEnergy" -> sE2, "nu" -> 0, "bbType" -> "exp",
       "massType" -> "massless", "skType" -> "++"|>
     },
   "loopMomenta" -> {},
   "loopExternalMomenta" -> {},
   "independentExternalMomenta" -> {pM, pZ},
   "ibpMode" -> "timeOnly",
   "vertexEnergies" -> <|v1 -> k1, v2 -> k2, v3 -> k3|>,
   "ispData" -> {},
   "zeroPointRules" -> {
     a0[v1] -> alpha1, a0[v2] -> alpha2, a0[v3] -> alpha3,
     b0[em] -> 0, b0[ez] -> 0
     },
   "symmetryRules" -> {}
   |>;

context = DSInit[
   caseInput,
   RegisterAsCurrent -> True,
   WriteInitializationFiles -> False,
   GenerateDerivativeMetadata -> True,
   ProgressReporting -> False
   ];


(* ::Chapter:: *)
(*全 sector 往返与公开生产者*)

internalTop = J[{0, 0, 0}, {{"F", 0, 1}, {"F", 1, 0}}, {}];
publicTop = dSIBP`Private`dsTimeOnlyInternalIntegralToPublic020[internalTop, context];
roundTripTop = dSIBP`Private`dsTimeOnlyPublicIntegralToInternal020[publicTop, context];

internalChild = J[{0, 0}, {{"F"}, {"F", 1, 0}}, {}];
publicChild = dSIBP`Private`dsTimeOnlyInternalIntegralToPublic020[internalChild, context];
roundTripChild = dSIBP`Private`dsTimeOnlyPublicIntegralToInternal020[publicChild, context];

allPublicStates = Flatten@Table[
    With[
     {sectorKey = metadata["sectorKey"],
      timeCount = Length[metadata["compactASlots"]],
      stateCount = metadata["timeOnlyStateCount"]},
     J[sectorKey, ConstantArray[0, timeCount], #] & /@ Tuples[{0, 1}, stateCount]
     ],
    {metadata, context["sectors"]}
    ];
allStateRoundTrips = Map[
   Function[int,
    dSIBP`Private`dsTimeOnlyInternalIntegralToPublic020[
      dSIBP`Private`dsTimeOnlyPublicIntegralToInternal020[int, context],
      context
      ]
    ],
   allPublicStates
   ];

seedData = DSSeeds[context, ApplyNumericRules -> False, ProgressReporting -> False];
generated = DSGenerateIBP[DSAllSeeds[seedData], {-1, 1}, ProgressReporting -> False];
linearData = DSLinear[generated, context, ProgressReporting -> False];

topDerivative = ds[publicTop, sE1, context];
childDerivative = ds[publicChild, sE1, context];
simultaneousChild = J["00", {0}, {}];
simultaneousChildDerivative = ds[simultaneousChild, sE2, context];
topTimeIBP = dtau[v2, publicTop, context];
oldDerivative = ds[internalTop, sE1, context];
oldTimeIBP = dtau[v2, internalTop, context];


(* ::Chapter:: *)
(*验收摘要*)

oldLeakQ[value_] := dSIBP`Private`dsTimeOnlyOldIntegralLeakQ020[value];
publicIntegralQ[int_] := MatchQ[int, J[_String, _List, _List]];

checks = <|
   "initialized" -> (Lookup[context, "status", None] === "initialized"),
   "version020" -> ($dSIBPVersion === "020.0"),
   "sectorOrder" -> (Lookup[context["sectors"], "sectorKey"] === {"11", "01", "10", "00"}),
   "stateSlotCounts" -> (Lookup[context["sectors"], "timeOnlyStateCount"] === {3, 1, 2, 0}),
   "topShape" -> (publicTop === J["11", {0, 0, 0}, {0, 1, 1}]),
   "topRoundTrip" -> (roundTripTop === internalTop),
   "childShape" -> (publicChild === J["01", {0, 0}, {1}]),
   "childRoundTrip" -> (roundTripChild === internalChild),
   "allSectorStatesRoundTrip" -> (allStateRoundTrips === allPublicStates),
   "massiveFourStatesPresent" -> (Count[allPublicStates, J["10", {0, 0}, {_Integer, _Integer}]] === 4),
   "masslessTwoStatesPresent" -> (Count[allPublicStates, J["01", {0, 0}, {_Integer}]] === 2),
   "seedGenerated" -> (Lookup[seedData, "status", None] === "generated"),
   "seedRepresentation" -> (Lookup[seedData, "representation", None] === "J[sectorKey,timeShifts,stateBits]"),
   "seedNoOldJ" -> ! oldLeakQ[KeyTake[seedData, {"allSeeds", "seedGroups"}]],
   "generatedIBP" -> (Lookup[generated, "status", None] === "generated"),
   "generatedNoOldJ" -> ! oldLeakQ[Lookup[generated, "equations", {}]],
   "linearGenerated" -> (Lookup[linearData, "status", None] === "generated"),
   "linearNoOldJ" -> ! oldLeakQ[KeyTake[linearData, {"integralList", "integralRules", "linearEquations"}]],
    "derivativePublic" -> (topDerivative =!= $Failed && ! oldLeakQ[topDerivative] && And @@ (publicIntegralQ /@ Cases[topDerivative, _J, Infinity])),
    "lowerSectorDerivativePublic" -> (childDerivative =!= $Failed && ! oldLeakQ[childDerivative] && And @@ (publicIntegralQ /@ Cases[childDerivative, _J, Infinity])),
    "lowerSectorPrefactorDerivative" -> TrueQ[
      Simplify[childDerivative - (2 mu/sE1) publicChild] === 0
      ],
    "simultaneousSectorDerivativePublic" -> (simultaneousChildDerivative =!= $Failed && ! oldLeakQ[simultaneousChildDerivative] && And @@ (publicIntegralQ /@ Cases[simultaneousChildDerivative, _J, Infinity])),
   "timeIBPPublic" -> (topTimeIBP =!= $Failed && ! oldLeakQ[topTimeIBP] && And @@ (publicIntegralQ /@ Cases[topTimeIBP, _J, Infinity])),
   "oldDerivativeRejected" -> (oldDerivative === $Failed),
   "oldTimeIBPRejected" -> (oldTimeIBP === $Failed)
   |>;

failed = Keys@Select[checks, Not@TrueQ[#] &];
Print[InputForm[<|
   "passed" -> Count[Values[checks], True],
   "total" -> Length[checks],
   "failed" -> failed,
   "publicTop" -> publicTop,
   "publicTopArgumentHeads" -> (Head /@ List @@ publicTop),
   "publicTopMatchesOldPattern" -> MatchQ[publicTop, J[_List, _List, _List]],
   "roundTripTop" -> roundTripTop,
    "publicChild" -> publicChild,
    "roundTripChild" -> roundTripChild,
    "childDerivative" -> childDerivative,
   "firstSeedSourceIntegral" -> Lookup[First[Lookup[seedData, "allSeeds", {<||>}]], "sourceIntegral", Missing["NoSource"]],
   "firstSeedEquation" -> Lookup[First[Lookup[seedData, "allSeeds", {<||>}]], "equation", Missing["NoEquation"]],
   "generatedStatus" -> KeyTake[generated, {"status", "reason", "invalidSectorKeys", "ibpMode", "rootLineCount", "invalidEntries", "templateIntegrityAudit"}],
   "linearStatus" -> KeyTake[linearData, {"status", "reason"}],
   "seedCount" -> Length[Lookup[seedData, "allSeeds", {}]],
   "equationCount" -> Lookup[generated, "equationCount", Missing["NotGenerated"]],
   "integralCount" -> Lookup[linearData, "integralCount", Missing["NotGenerated"]],
   "checks" -> checks
   |>]];

Exit[If[failed === {}, 0, 1]];
