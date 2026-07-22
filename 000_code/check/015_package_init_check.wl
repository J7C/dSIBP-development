(* ::Package:: *)
(* 015 标准 package、root-coordinate metadata、context 隔离和 zero-point 投影契约专项。 *)

(* ::Chapter:: *)
(*加载标准 package*)

checkDir = DirectoryName[$InputFileName];
codeDir = DirectoryName[checkDir];
packageDir = FileNameJoin[{codeDir, "015_dSIBP"}];
If[! MemberQ[$Path, packageDir], AppendTo[$Path, packageDir]];
Needs["dSIBP`"];

(* ::Chapter:: *)
(*定义最小 mixed family*)

case = <|
   "name" -> "015PackageInitMixedBubble",
   "vertexData" -> {{v1, "+"}, {v2, "+"}},
   "lineData" -> {
     <|"id" -> 1, "endpoints" -> {v1, v2}, "momentum" -> q,
       "nu" -> nuM, "bbType" -> "h", "massType" -> "massive"|>,
     <|"id" -> 2, "endpoints" -> {v1, v2}, "momentum" -> q - k,
       "nu" -> 0, "bbType" -> "exp", "massType" -> "massless"|>
     },
   "loopMomenta" -> {q},
   "externalMomenta" -> {k},
   "externalLegMomenta" -> {kE1, kE2},
   "vertexEnergies" -> <|v1 -> Sqrt[sp[k, k]] + Sqrt[sp[kE1, kE1]], v2 -> Sqrt[sp[kE2, kE2]]|>,
   "zeroPointRules" -> {
     a0[v1] -> alpha1, a0[v2] -> alpha2,
     b0[1] -> beta1, b0[2] -> beta2, bS0[2] -> beta2
     },
   "symmetryRules" -> {},
   "seedPreset" -> "quickCheck"
   |>;

DSMessagesOff[];
context = DSInit[case, GenerateDerivativeMetadata -> True];
info = DSInfo[];

resultsDir = FileNameJoin[{codeDir, "test", "results_test", "015_package_init_check"}];
initDir = FileNameJoin[{resultsDir, "init"}];
writeContext = DSInit[
   case,
   WriteInitializationFiles -> True,
   InitializationDirectory -> initDir,
   GenerateDerivativeMetadata -> True,
   OverwriteInitialization -> True,
   RegisterAsCurrent -> False
   ];
sameContext = DSInit[
   case,
   WriteInitializationFiles -> True,
   InitializationDirectory -> initDir,
   GenerateDerivativeMetadata -> True,
   RegisterAsCurrent -> False
   ];
conflictContext = Quiet[DSInit[
    Join[case, <|"name" -> "015PackageInitDifferentInput"|>],
    WriteInitializationFiles -> True,
    InitializationDirectory -> initDir,
    RegisterAsCurrent -> False
    ]];
writtenManifest = Get[FileNameJoin[{initDir, "manifest.wl"}]];

(* ::Chapter:: *)
(*逐项门禁*)

publicSymbols = {J, sp, qq, qk, kk, dtau, dqq, dqk, ds, rep2innerform, rep2outform,
   rep2Integrand, symmetry, repIterative, DSTreeSeeds, DSTreeNaiveIBP, DSTreeNaiveDE, DSTreeDLogDE, DSInit, DSInfo, DSKinematics,
   DSSeeds, DSLinear, DSKiraExport, DSKiraImport, DSDE, DSScaleCheck};
optionSymbols = {WriteInitializationFiles, InitializationDirectory, GenerateDerivativeMetadata,
   OverwriteInitialization, RegisterAsCurrent, ProgressReporting, KinematicRules,
   MaxShrinkSectorDepth, MaxShrinkSectorCount};

checks = <|
   "version" -> SameQ[$dSIBPVersion, "015"],
   "publicContexts" -> And @@ (Context[#] === "dSIBP`" & /@ publicSymbols),
   "coreHelperPrivate" -> NameQ["dSIBP`Private`parseTopology"] && ! NameQ["dSIBP`parseTopology"],
   "messageSwitch" -> SameQ[DSMessagesQ[], False],
   "initialized" -> Lookup[context, "status", "missing"] === "initialized",
   "registeredContext" -> Lookup[info, "inputHash", Missing["inputHash"]] === Lookup[context, "inputHash", Missing["contextHash"]],
   "ispClosure" -> Lookup[context["validationReport"], "errorCount", 1] === 0,
   "fullSectorMetadata" -> Lookup[context["topologyData", "precomputedShrinkSectorSummary"], "completeCoverageQ", False] === True,
   "allSectorCount" -> Length[context["sectors"]] >= 2,
   "derivativeMetadata" -> Lookup[context["derivatives"], "status", "missing"] === "generated",
    "rootDerivativeVariables" -> Lookup[context["derivatives", "operators"], "userVariable", {}] === {ss11, sE1, sE2},
   "rootConventionMetadata" -> Lookup[context["conventions"], "defaultDerivativeCoordinates", "missing"] ===
      "ssij for the complete loop-external Gram basis; sE1,sE2,... for the first-occurrence independent basis of actually appearing no-loop momentum magnitudes",
   "projectionA0ToNu0" -> TrueQ[context["loopTreeProjectionConvention", "targetAZeroPointBecomesTreeNu0"]],
   "projectionB0Explicit" -> TrueQ[context["loopTreeProjectionConvention", "removedLineZeroPointsBecomeExplicitEnergyPowers"]],
   "noPowerExpand" -> SameQ[context["loopTreeProjectionConvention", "unsafePowerExpand"], False],
   "initDefaultNoWrite" -> Lookup[context["initializationWrite"], "status", "missing"] === "notRequested",
   "initFilesWritten" -> And @@ (FileExistsQ[FileNameJoin[{initDir, #}]] & /@ {
      "manifest.wl", "topology.wl", "sectors.wl", "conventions.wl", "derivatives.wl"
      }),
   "manifestHash" -> Lookup[writtenManifest, "inputHash", Missing["inputHash"]] === writeContext["inputHash"],
   "manifestFileMap" -> AssociationQ[Lookup[writtenManifest, "files", None]] &&
     Lookup[writtenManifest, "files", <||>] === <|
       "topology.wl" -> "topology.wl",
       "sectors.wl" -> "sectors.wl",
       "conventions.wl" -> "conventions.wl",
       "derivatives.wl" -> "derivatives.wl"
       |>,
   "sameHashReuse" -> Lookup[sameContext, "status", "missing"] === "initialized",
   "differentHashRejected" -> Lookup[conflictContext, "reason", "missing"] === "initializationConflict",
   "publicOptions" -> And @@ (MemberQ[{"dSIBP`", "System`"}, Context[#]] & /@ optionSymbols)
   |>;

Print["015 package/init check: ", Count[Values[checks], True], "/", Length[checks]];
If[! And @@ Values[checks], Print[Select[checks, Not]]; Print["optionContexts=", Context /@ optionSymbols]; Exit[1]];
