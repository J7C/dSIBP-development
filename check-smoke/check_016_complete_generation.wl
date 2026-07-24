(* ::Package:: *)
(* 维护 smoke：验证 016 不含资源门禁，完整展开用户范围，并在无动力学变量时给出有效提示。 *)


(* ::Chapter:: *)
(*加载候选或模块化 package*)

projectRoot = DirectoryName[DirectoryName[$InputFileName]];
candidatePath = Environment["DSIBP_PACKAGE_FILE"];
packagePath = If[
   StringQ[candidatePath] && candidatePath =!= "" && FileExistsQ[candidatePath],
   candidatePath,
   FileNameJoin[{projectRoot, "000_code", "016_dSIBP", "Kernel", "dSIBP.wl"}]
   ];
Get[packagePath, CharacterEncoding -> "UTF-8"];


(* ::Chapter:: *)
(*超过旧数量阈值的完整 pure-time family*)

rangeCase = <|
   "name" -> "016CompleteRangeSmoke",
   "vertexData" -> {{v1, "+"}, {v2, "+"}},
   "lineData" -> {
     <|"id" -> 1, "endpoints" -> {v1, v2}, "momentum" -> p12,
       "treeEnergy" -> k12, "nu" -> nu12, "bbType" -> "h", "massType" -> "massive"|>
     },
   "loopMomenta" -> {},
   "loopExternalMomenta" -> {},
   "independentExternalMomenta" -> {p12},
   "ibpMode" -> "timeOnly",
   "vertexEnergies" -> <|v1 -> E1, v2 -> E2|>,
   "ispData" -> {},
   "zeroPointRules" -> {a0[v1] -> alpha1, a0[v2] -> alpha2, b0[1] -> beta12},
   "shrinkPrefactorRules" -> {Exp[Pi Im[nu12]] -> eta12},
   "symmetryRules" -> {},
   "seedRanges" -> <|"a" -> {0, 14}, "b" -> {0}, "isp" -> {0}|>
   |>;

rangeContext = DSInit[rangeCase, RegisterAsCurrent -> False, WriteInitializationFiles -> False,
   ProgressReporting -> False];
rangeSeeds = DSSeeds[rangeContext, ProgressReporting -> False];
topGeneratorData = Select[Lookup[rangeSeeds, "generatorSeedData", {}],
   Lookup[#, "sectorKey", None] === "top" &];


(* ::Chapter:: *)
(*无动力学坐标提示*)

emptyCase = <|
   "name" -> "016NoKinematicsSmoke",
   "vertexData" -> {{v1, "+"}},
   "lineData" -> {},
   "loopMomenta" -> {},
   "loopExternalMomenta" -> {},
   "independentExternalMomenta" -> {},
   "ibpMode" -> "timeOnly",
   "vertexEnergies" -> <|v1 -> E1|>,
   "ispData" -> {},
   "zeroPointRules" -> {a0[v1] -> alpha1},
   "symmetryRules" -> {}
   |>;

emptyKinematics = DSKinematics[emptyCase];
emptyGuide = Lookup[emptyKinematics, "parameterRedefinitionGuide", <||>];


(* ::Chapter:: *)
(*确定性验收*)

forbiddenOptions = {UseSampleOnly, DiscreteMode, MaxSeedRuleCount, MaxDiscreteRuleCount,
   MaxEquationCount, MaxShrinkSectorCount, MaxShrinkSectorDepth, MaxReductionIterations, MaxIterations};
checks = <|
   "version016" -> ($dSIBPVersion === "016"),
   "runtimePlaceholderAbsent" -> ! StringContainsQ[
     Import[packagePath, "Text", CharacterEncoding -> "UTF-8"],
     "English: See the accompanying structured status"
     ],
   "resourceOptionsAbsent" -> FreeQ[Options[DSSeeds], Alternatives @@ forbiddenOptions],
   "rangeContextInitialized" -> (Lookup[rangeContext, "status", "failed"] === "initialized"),
   "rangeSeedsGenerated" -> (Lookup[rangeSeeds, "dSIBPStatus", "failed"] === "generated"),
   "topGeneratorsPresent" -> (Length[topGeneratorData] === 2),
   "all225ContinuousRulesGenerated" -> And @@ (Lookup[#, "ruleCount", -1] === 225 & /@ topGeneratorData),
   "oldEquationThresholdExceeded" -> (Lookup[rangeSeeds, "equationCount", 0] > 80),
   "oldSeedRuleThresholdExceeded" -> (Max[Lookup[topGeneratorData, "ruleCount", {0}]] > 200),
   "emptyKinematicsReturned" -> AssociationQ[emptyKinematics],
   "emptyProposalHasNoMissing" -> FreeQ[
     Lookup[emptyKinematics, {"defaultRules", "selectedRules", "dependentMagnitudeBindings"}, {}],
     _Missing,
     Infinity
     ],
   "emptyGuideHasNoCommand" -> (Lookup[emptyGuide, "commandExample", Missing["command"]] === None),
   "emptyGuideBilingual" -> StringContainsQ[Lookup[emptyGuide, "defaultBehavior", ""],
     {"没有可重定义动力学坐标", "no redefinable kinematic coordinates"}]
   |>;

failedChecks = Keys@Select[checks, Not];
Print[<|
   "passed" -> Count[Values[checks], True],
   "total" -> Length[checks],
   "failed" -> failedChecks,
   "equationCount" -> Lookup[rangeSeeds, "equationCount", Missing["equationCount"]],
   "topGeneratorRuleCounts" -> Lookup[topGeneratorData, "ruleCount", {}],
   "packagePath" -> packagePath,
   "checks" -> checks
   |>];
Exit[If[failedChecks === {}, 0, 1]];
