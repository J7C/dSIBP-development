(* ::Package:: *)
(* 本脚本轻量验证 017 的 seed 范围 metadata：从 Flatten 后的积分指标自动发现变量，
   按 sector/IBP/生成元分组保存 shift，并由目标包络反推数值 seed 点域。 *)

(* ::Chapter:: *)
(*候选加载与最小 time-only family*)

packageFile = Environment["DSIBP_PACKAGE_FILE"];
If[! StringQ[packageFile] || ! FileExistsQ[packageFile], Exit[2]];
Get[packageFile];

case = <|
   "name" -> "017MetaSeedRange",
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
seedGroups = DSSeedGroups[seedData];
seedGroupMetadata = DSSeedGroupMetadata[seedData];


(* ::Chapter:: *)
(*Metadata 初始化、覆盖与分组*)

flatMeta = DSMetaSeedRange[allSeeds, {a[v1], a[v2]}];
exactMeta = DSMetaSeedRange[seedGroups, {a[v1], a[v2]}];
deepGroups = Join[
   {{First[First[seedGroups]], {Rest[First[seedGroups]]}}},
   Rest[seedGroups]
   ];
deepMeta = DSMetaSeedRange[deepGroups, {a[v1], a[v2]}];
individualMeta = DSMetaSeedRange[List /@ allSeeds, {a[v1], a[v2]}];
mismatchMeta = DSMetaSeedRange[seedGroups, {a[v1], extraIndex}];
restoredMeta = metaSeedRange[seedGroups, {a[v1], a[v2]}];
currentMeta = DSMetaSeedRange[];

groupKeys = Lookup[Lookup[currentMeta, "groups", {}], "groupKey", {}];
sourceDescriptors = Flatten[Lookup[Lookup[currentMeta, "groups", {}], "sourceDescriptors", {}], 1];


(* ::Chapter:: *)
(*目标包络反推、parity 预筛与数值化*)

generated = DSGenerateIBP[allSeeds, {-1, 1}, ProgressReporting -> False];
equations = Lookup[Lookup[generated, "equations", {}], "equation", {}];
actualIndices = Lookup[currentMeta, "discoveredIndices", {}];
remainingIndices = Select[actualIndices, ! FreeQ[equations, #] &];
derivedGroups = Lookup[generated, "derivedSeedRangeAudits", {}];

checks = <|
   "initialized" -> (Lookup[context, "status", "failed"] === "initialized"),
   "seedGroupsMatchFlat" -> (Flatten[seedGroups, 1] === allSeeds &&
      Length[seedGroupMetadata] === Length[seedGroups]),
   "flatInputOneGroup" -> (Lookup[flatMeta, "inputGroupingMode", None] === "flatOverall" &&
      Length[Lookup[flatMeta, "groups", {}]] === 1),
   "exactMetadata" -> (Lookup[exactMeta, "status", "failed"] === "initialized" &&
      TrueQ[Lookup[exactMeta, "declarationExactQ", False]] &&
      Lookup[exactMeta, "inputGroupingMode", None] === "topLevelGroups"),
   "deepNestingFlattensWithinTopGroup" -> (Flatten[deepGroups, Infinity] === allSeeds &&
      Length[Lookup[deepMeta, "groups", {}]] === Length[seedGroups]),
   "individualDiscreteGroupingAllowed" ->
    (Length[Lookup[individualMeta, "groups", {}]] === Length[allSeeds]),
   "mismatchContinues" -> (Lookup[mismatchMeta, "status", "failed"] === "initialized" &&
      MemberQ[Lookup[mismatchMeta, "missingIndices", {}], a[v2]] &&
      MemberQ[Lookup[mismatchMeta, "extraIndices", {}], extraIndex]),
   "laterInitializationOverrides" -> (currentMeta === restoredMeta &&
      TrueQ[Lookup[currentMeta, "declarationExactQ", False]]),
   "groupsSeparated" -> (DuplicateFreeQ[groupKeys] && Length[groupKeys] >= 3 &&
      MemberQ[sourceDescriptors, HoldComplete["top", "tIBP", {"time", v1}]] &&
      MemberQ[sourceDescriptors, HoldComplete["top", "tIBP", {"time", v2}]]),
   "groupShiftBoundsPresent" -> And @@ (Lookup[#, "shiftBounds", {}] =!= {} & /@
       Lookup[currentMeta, "groups", {}]),
   "generated" -> (Lookup[generated, "status", "failed"] === "generated"),
   "targetEnvelopeMode" -> (Lookup[generated, "rangeMode", None] === "targetEnvelope"),
   "derivedPerGroup" -> (Length[derivedGroups] === Length[Lookup[currentMeta, "groups", {}]]),
   "parityBeforeGeneration" -> (Lookup[generated, "candidatePointCount", -1] >=
       Lookup[generated, "parityAcceptedPointCount", Infinity] &&
      Lookup[generated, "parityAcceptedPointCount", -1] === Length[equations]),
   "allIndicesNumeric" -> (remainingIndices === {})
   |>;

summary = <|
   "passed" -> Count[Values[checks], True],
   "total" -> Length[checks],
   "failed" -> Keys@Select[checks, Not@TrueQ[#] &],
   "groupCount" -> Length[groupKeys],
   "candidatePointCount" -> Lookup[generated, "candidatePointCount", Missing["count"]],
   "equationCount" -> Length[equations],
   "remainingIndices" -> remainingIndices,
   "derivedSeedRanges" -> Lookup[derivedGroups, "seedRangeRules", {}],
   "checks" -> checks
   |>;

Print[InputForm[summary]];
If[summary["passed"] =!= summary["total"], Exit[1]];
