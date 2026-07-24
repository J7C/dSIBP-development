(* ::Package:: *)
(* 维护 smoke：验证 massive h 模板在连续撒点前完整遍历 n=0,1 并完成 EOM。 *)


(* ::Chapter:: *)
(*加载与函数族输入*)

projectRoot = DirectoryName[DirectoryName[$InputFileName]];
candidatePath = Environment["DSIBP_PACKAGE_FILE"];
packagePath = If[
   StringQ[candidatePath] && candidatePath =!= "" && FileExistsQ[candidatePath],
   candidatePath,
   FileNameJoin[{projectRoot, "000_code", "016_dSIBP", "Kernel", "dSIBP.wl"}]
   ];
Get[packagePath];

caseInput = <|
   "name" -> "016GenerateIBPMassiveSmoke",
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
   "vertexEnergies" -> <|v1 -> P0, v2 -> P0|>,
   "ispData" -> {},
   "numericRules" -> {},
   "zeroPointRules" -> {a0[v1] -> 2 nu, a0[v2] -> 2 nu, b0[1] -> -2 nu, b0[2] -> -2 nu},
   "symmetryRules" -> {},
   "seedPreset" -> "quickCheck",
   "seedRanges" -> <|"a" -> {0}, "b" -> {0}, "isp" -> {0}|>
   |>;

context = DSInit[caseInput, RegisterAsCurrent -> True, ProgressReporting -> False];
seedData = DSSeeds[
   context,
   ProgressReporting -> False
   ];
allSeeds = DSAllSeeds[seedData];


(* ::Chapter:: *)
(*离散覆盖与 EOM 检查*)

groups = GatherBy[allSeeds, {Lookup[#, "sectorKey", None], Lookup[#, "generator", None]} &];
discreteCoverageQ = And @@ Table[
    Length[DeleteDuplicates[Lookup[group, "discreteRules", {}]]] ===
     Lookup[First[group], "discreteStateCountExpected", -1],
    {group, groups}
    ];
generated = DSGenerateIBP[allSeeds, {0, 0}, ProgressReporting -> False];

checks = <|
   "contextInitialized" -> (Lookup[context, "status", "failed"] === "initialized"),
   "seedDataGenerated" -> (Lookup[seedData, "dSIBPStatus", "failed"] === "generated"),
   "hasDiscreteVariables" -> (DeleteDuplicates@Flatten[Lookup[allSeeds, "discreteVariables", {}], Infinity] =!= {}),
   "allBinaryStatesCovered" -> discreteCoverageQ,
   "noSymbolicN" -> FreeQ[Lookup[allSeeds, "equation", {}], _n],
   "noForbiddenN" -> (DeleteCases[Flatten[Lookup[allSeeds, "forbiddenNData", {}]], Null] === {}),
   "allEOMCanonical" -> And @@ Lookup[allSeeds, "eomCanonicalQ", {False}],
   "canonicalZeroTemplatesAccepted" -> If[
     MemberQ[Lookup[allSeeds, "equation", {}], 0],
     Lookup[generated, "status", "failed"] === "generated",
     True
     ],
   "generatedIBPReady" -> (Lookup[generated, "status", "failed"] === "generated" && TrueQ[Lookup[generated, "completeCanonicalQ", False]])
   |>;

failedChecks = Keys@Select[checks, Not];
Print[<|"passed" -> Count[Values[checks], True], "total" -> Length[checks],
   "failed" -> failedChecks, "templateCount" -> Length[allSeeds],
   "discreteVariables" -> DeleteDuplicates@Flatten[Lookup[allSeeds, "discreteVariables", {}], Infinity],
   "checks" -> checks|>];
Exit[If[failedChecks === {}, 0, 1]];
