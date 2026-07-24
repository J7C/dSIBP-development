(* ::Package:: *)
(* 本脚本通过公开入口验证窄目标包络的空 seed 组：程序必须逐组打印反推范围，
   解释 IBP 撒点为空的原因，并关闭完整约化能力而不是静默接受。 *)


(* ::Chapter:: *)
(*候选加载与最小 time-only family*)

packageFile = Environment["DSIBP_PACKAGE_FILE"];
If[! StringQ[packageFile] || ! FileExistsQ[packageFile], Exit[2]];
Get[packageFile];

case = <|
   "name" -> "017EmptySeedRangeWarning",
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
   "symmetryRules" -> {}
   |>;

context = DSInit[case, ProgressReporting -> False];
seedData = DSSeeds[context, ProgressReporting -> False];
allSeeds = DSAllSeeds[seedData];
customGroups = {Take[allSeeds, 2], Drop[allSeeds, 2]};
customMetadata = DSMetaSeedRange[customGroups, {a[v1], a[v2]}];


(* ::Chapter:: *)
(*公开打印、空组 metadata 与 capability*)

capturedPrint = {};
capturePrint017[args___] := AppendTo[capturedPrint, StringJoin[ToString /@ {args}]];

generated = Block[
   {Print = capturePrint017},
   DSGenerateIBP[allSeeds, {0, 0}, ProgressReporting -> True]
   ];

capturedText = StringRiffle[capturedPrint, "\n"];
capturedLines = StringSplit[capturedText, "\n"];
groupOneLine = SelectFirst[capturedLines, StringContainsQ[#, "Group 1"] &, ""];
emptyWarningLine = SelectFirst[
   capturedLines,
   StringContainsQ[#, "no seed point can keep every shifted integral inside the target envelope"] &,
   ""
   ];
nonASCIIQ[text_String] := AnyTrue[ToCharacterCode[text, "Unicode"], # > 127 &];
emptyGroups = Lookup[generated, "emptySeedRangeGroups", {}];
emptyOrdinals = Lookup[emptyGroups, "groupOrdinal", {}];
equations = Lookup[generated, "equations", {}];

checks = <|
   "generatedWithStructuredIncompleteState" ->
    (Lookup[generated, "status", "failed"] === "generated" && emptyGroups =!= {}),
   "customGroupingUsed" ->
    (Lookup[customMetadata, "inputGroupingMode", None] === "topLevelGroups" &&
      Length[Lookup[customMetadata, "groups", {}]] === 2 &&
      Length[Lookup[generated, "derivedSeedRangeAudits", {}]] === 2),
   "numberedBilingualRangesPrinted" ->
    (StringContainsQ[groupOneLine, "Group 1"] &&
      nonASCIIQ[First[StringSplit[groupOneLine, "Group 1"]]]),
   "customGroupsNotCalledIBPOperators" ->
    (! StringContainsQ[capturedText, "IBP 算符"] && ! StringContainsQ[capturedText, "IBP operator"]),
   "emptyRangeCauseExplainedBilingually" ->
    (nonASCIIQ[First[StringSplit[emptyWarningLine, "For the following groups"]]] &&
      StringContainsQ[emptyWarningLine, "no seed point can keep every shifted integral inside the target envelope"] &&
      StringContainsQ[emptyWarningLine, "IBP sampling is empty for these groups"]),
   "incompleteReductionExplained" ->
    StringContainsQ[emptyWarningLine, "cannot be used as a complete reduction system"],
   "emptyGroupsCarryRanges" ->
    (DuplicateFreeQ[emptyOrdinals] &&
      And @@ (TrueQ[Lookup[#, "emptySeedDomainQ", False]] &&
          AnyTrue[Last /@ Lookup[#, "seedRangeRules", {}], First[#] > Last[#] &] & /@ emptyGroups)),
   "equationCountConsistent" -> (Lookup[generated, "equationCount", -1] === Length[equations]),
   "completeTimeCapabilityDisabled" -> ! TrueQ[Lookup[generated, "completeTimeIBPQ", True]],
   "completeCanonicalCapabilityDisabled" -> ! TrueQ[Lookup[generated, "completeCanonicalQ", True]]
   |>;

summary = <|
   "passed" -> Count[Values[checks], True],
   "total" -> Length[checks],
   "failed" -> Keys@Select[checks, Not@TrueQ[#] &],
   "emptyGroupOrdinals" -> emptyOrdinals,
   "equationCount" -> Length[equations],
   "capturedText" -> capturedText,
   "checks" -> checks
   |>;

Print[InputForm[summary]];
If[summary["passed"] =!= summary["total"], Exit[1]];
