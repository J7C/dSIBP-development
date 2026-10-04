(* ::Package:: *)
(* 验证 linearData["integralList"] 是 plan/export 前唯一的积分编号顺序来源。 *)

(* ::Chapter:: *)
(*加载模块化 package*)

Get[FileNameJoin[{DirectoryName[$InputFileName], "..", "_harness.wls"}]];
projectRoot = ExpandFileName@FileNameJoin[{DirectoryName[$InputFileName], "..", ".."}];
dsSmokeLoadPackage[FileNameJoin[{projectRoot, "versions", "023_dSIBP", "Kernel", "dSIBP.wl"}]];
DSMessagesOff[];


(* ::Chapter:: *)
(*两积分顺序与方程编号*)

integral1 = J[{0}, {{b[1], n[1, 0, 0]}}, {}];
integral2 = J[{1}, {{b[1], n[1, 0, 0]}}, {}];
linearData = <|
   "status" -> "generated",
   "dSIBPStatus" -> "generated",
   "caseName" -> "integralOrderAuthoritySmoke",
   "integralList" -> {integral1, integral2},
   "integralCount" -> 2,
   "integralRules" -> {integral1 -> 1, integral2 -> 2},
   "linearEquations" -> {<|"coefficientRules" -> {1 -> 3, 2 -> -5}|>}
   |>;

defaultPlan = DSKiraPlan[
   linearData,
   <|"stage" -> "preReduction", "preferredIntegrals" -> {integral2}|>
   ];
Block[{$MessageList = {}},
 reordered = DSReorderIntegrals[linearData, {integral2}];
 reorderMessages = $MessageList
 ];
reorderedPlan = DSKiraPlan[
   reordered,
   <|"stage" -> "preReduction", "preferredIntegrals" -> {integral1}|>
   ];


(* ::Chapter:: *)
(*数值 line pack 的复杂度排序*)

zeroPackIntegral = J[{0}, {{0, 0, 0}}, {}];
positiveBIntegral = J[{0}, {{2, 0, 0}}, {}];
negativeBIntegral = J[{0}, {{-2, 0, 0}}, {}];
discreteIntegral = J[{0}, {{0, 1, 0}}, {}];
shrunkIntegral = J[{0}, {{3}}, {}];
fixedIntegral = J[{0}, {{"F", 1, 0}}, {}];
unitBIntegral = J[{0}, {{1, 0, 0}}, {}];
twoAIntegral = J[{2}, {{0, 0, 0}}, {}];
negativeAIntegral = J[{-1}, {{0, 0, 0}}, {}];
twoNegativeIntegral = J[{-1}, {{-1, 0, 0}}, {}];
positiveSixIntegral = J[{6}, {{0, 0, 0}}, {}];
positiveNineIntegral = J[{9}, {{0, 0, 0}}, {}];
positiveHundredIntegral = J[{100}, {{0, 0, 0}}, {}];

zeroPackKey = dSIBP`Private`integralSortKey[zeroPackIntegral];
positiveBKey = dSIBP`Private`integralSortKey[positiveBIntegral];
negativeBKey = dSIBP`Private`integralSortKey[negativeBIntegral];
discreteKey = dSIBP`Private`integralSortKey[discreteIntegral];
shrunkKey = dSIBP`Private`integralSortKey[shrunkIntegral];
fixedKey = dSIBP`Private`integralSortKey[fixedIntegral];
unitBKey = dSIBP`Private`integralSortKey[unitBIntegral];
twoAKey = dSIBP`Private`integralSortKey[twoAIntegral];
negativeAKey = dSIBP`Private`integralSortKey[negativeAIntegral];
twoNegativeKey = dSIBP`Private`integralSortKey[twoNegativeIntegral];
positiveSixKey = dSIBP`Private`integralSortKey[positiveSixIntegral];
positiveNineKey = dSIBP`Private`integralSortKey[positiveNineIntegral];
positiveHundredKey = dSIBP`Private`integralSortKey[positiveHundredIntegral];


(* ::Chapter:: *)
(*Lower-sector 自动排序与显式覆盖*)

topSectorMetadata = <|
   "sectorKey" -> "top",
   "sectorShrunkLines" -> {},
   "compactASlots" -> {1, 2, 3},
   "lineSlots" -> {
     <|"packTemplate" -> {0, 0, 0}, "bSymbol" -> None|>,
     <|"packTemplate" -> {0, 0, 0}, "bSymbol" -> None|>,
     <|"packTemplate" -> {"F", 0, 0}, "bSymbol" -> None|>
     },
   "ispSlots" -> {}
   |>;
contactSectorMetadata = <|
   "sectorKey" -> "e3",
   "sectorShrunkLines" -> {3},
   "compactASlots" -> {1, 2},
   "lineSlots" -> {
     <|"packTemplate" -> {0, 0, 0}, "bSymbol" -> None|>,
     <|"packTemplate" -> {0, 0, 0}, "bSymbol" -> None|>,
     <|"packTemplate" -> {"F"}, "bSymbol" -> None|>
     },
   "ispSlots" -> {}
   |>;
sectorMetadataList = {topSectorMetadata, contactSectorMetadata};

parentIntegral = J[{0, 0, 1}, {{0, 0, 0}, {0, 0, 0}, {"F", 0, 0}}, {}];
contactIntegral = J[{0, 1}, {{0, 0, 0}, {0, 0, 0}, {"F"}}, {}];
parentAutomaticKey = dSIBP`Private`integralSortKey[parentIntegral, <||>, sectorMetadataList];
contactAutomaticKey = dSIBP`Private`integralSortKey[contactIntegral, <||>, sectorMetadataList];

explicitSectorRank = <|"SectorRank" -> <|"top" -> -2, "e3" -> 3|>|>;
parentExplicitKey = dSIBP`Private`integralSortKey[parentIntegral, explicitSectorRank, sectorMetadataList];
contactExplicitKey = dSIBP`Private`integralSortKey[contactIntegral, explicitSectorRank, sectorMetadataList];

checks = <|
   "defaultOrderPreserved" -> (defaultPlan["integralOrder"] === {integral1, integral2}),
   "preferredDoesNotReorder" -> (defaultPlan["linearData", "integralRules"] === linearData["integralRules"]),
   "explicitOrderAppliedOnce" -> (reordered["integralList"] === {integral2, integral1}),
   "orderingSpecIsAssociation" -> AssociationQ[reordered["kiraOrdering"]],
   "reorderMessagesClean" -> (reorderMessages === {}),
   "equationIDsReindexed" -> (Lookup[First[reordered["linearEquations"]], "coefficientRules"] === {2 -> 3, 1 -> -5}),
   "planReadsExplicitOrder" -> (reorderedPlan["integralOrder"] === reordered["integralList"]),
   "orderingConvention" -> (reorderedPlan["orderingConvention"] === "linearDataIntegralList"),
   "publicAPI" -> MemberQ[DSPublicAPI[]["functions"], "DSReorderIntegrals"],
   "legacyExportOptionRemoved" -> FreeQ[Options[DSKiraExport], KiraIntegralOrder],
   "positiveBEntersSortKey" -> (Take[positiveBKey, 5] === {0, 2, 0, 2, 2}),
   "negativeBReceivesOneIndexPenalty" -> (Take[negativeBKey, 5] === {1, 7, 1, 2, 0}),
   "shrunkBEntersSortKey" -> (Take[shrunkKey, 5] === {0, 3, 0, 3, 3}),
   "oneNegativeIndexAddsFive" -> (negativeAKey[[2]] === 6),
   "twoNegativeIndicesAddSeven" -> (twoNegativeKey[[2]] === 9),
   "allNonnegativeIndicesPrecedeNegativeIndices" -> (
     OrderedQ[{positiveSixKey, negativeAKey}] &&
       OrderedQ[{positiveNineKey, twoNegativeKey}] &&
       OrderedQ[{positiveHundredKey, negativeAKey}]
   ),
   "discreteIndexExcludedFromPenalty" -> (Take[discreteKey, 3] === {0, 0, 0} && discreteKey[[10]] === 1),
   "fixedIndexExcludedFromPenalty" -> (Take[fixedKey, 3] === {0, 0, 0} && fixedKey[[10]] === 1),
   "zeroPackIsSimplerThanNonzeroB" -> OrderedQ[{zeroPackKey, positiveBKey}],
   "jointPowerComplexityPreventsBZeroTower" -> OrderedQ[{unitBKey, twoAKey}],
   "automaticContactSectorPrecedesParentAtEqualComplexity" -> OrderedQ[{contactAutomaticKey, parentAutomaticKey}],
   "automaticSectorRankUsesShrinkDepth" -> (contactAutomaticKey[[7]] === -1 && parentAutomaticKey[[7]] === 0),
   "explicitSectorRankOverridesAutomaticDepth" -> OrderedQ[{parentExplicitKey, contactExplicitKey}]
   |>;

failed = Keys@Select[checks, Not@TrueQ[#] &];
Print["check_integral_order_authority: ", Count[Values[checks], True], "/", Length[checks]];
Print["failed: ", InputForm[failed]];
Print[InputForm[<|"passed" -> Count[Values[checks], True], "total" -> Length[checks], "failed" -> failed,"checks" -> checks|>]];
If[Count[Values[checks], True] =!= Length[checks], Exit[1]];
