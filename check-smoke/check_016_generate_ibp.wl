(* ::Package:: *)
(* 维护 smoke：检查完整离散模板、统一/精细连续撒点门禁以及 DSLinear 接口。 *)


(* ::Chapter:: *)
(*加载 016 模块化 package*)

projectRoot = DirectoryName[DirectoryName[$InputFileName]];
candidatePath = Environment["DSIBP_PACKAGE_FILE"];
packagePath = If[
   StringQ[candidatePath] && candidatePath =!= "" && FileExistsQ[candidatePath],
   candidatePath,
   FileNameJoin[{projectRoot, "000_code", "016_dSIBP", "Kernel", "dSIBP.wl"}]
   ];
Get[packagePath];


(* ::Chapter:: *)
(*最小 massless bubble*)

caseInput = <|
   "name" -> "016GenerateIBPSmoke",
   "vertexData" -> {{v1, "+"}, {v2, "-"}},
   "lineData" -> {
     <|"id" -> 1, "endpoints" -> {v1, v2}, "momentum" -> q,
       "massType" -> "massless", "bbType" -> "exp", "nu" -> 0|>,
     <|"id" -> 2, "endpoints" -> {v1, v2}, "momentum" -> q - k,
       "massType" -> "massless", "bbType" -> "exp", "nu" -> 0|>
     },
   "extLegs" -> {},
   "loopMomenta" -> {q},
   "loopExternalMomenta" -> {k},
   "independentExternalMomenta" -> {},
   "ibpMode" -> "full",
   "vertexEnergies" -> <|v1 -> P1, v2 -> P2|>,
   "ispData" -> {},
   "numericRules" -> {dim -> 3},
   "zeroPointRules" -> {a0[v1] -> 0, a0[v2] -> 0, b0[1] -> 1, b0[2] -> 1},
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
indices = DeleteDuplicates@Flatten[Lookup[allSeeds, "continuousIndices", {}], Infinity];


(* ::Chapter:: *)
(*统一范围、精细范围与失败门禁*)

uniform = DSGenerateIBP[allSeeds, {0, 0}, ProgressReporting -> False];
detailedSpecs = ({#, 0, 0} & /@ indices);
detailed = DSGenerateIBP[allSeeds, Sequence @@ detailedSpecs, ProgressReporting -> False];
missing = If[Length[detailedSpecs] > 0,
   DSGenerateIBP[allSeeds, Sequence @@ Rest[detailedSpecs], ProgressReporting -> False],
   <|"status" -> "skipped"|>
   ];
unknown = DSGenerateIBP[allSeeds, Sequence @@ Join[detailedSpecs, {{notAnIndex, 0, 0}}], ProgressReporting -> False];
duplicate = If[Length[detailedSpecs] > 0,
   DSGenerateIBP[allSeeds, Sequence @@ Join[detailedSpecs, {First[detailedSpecs]}], ProgressReporting -> False],
   <|"status" -> "skipped"|>
   ];
discrete = DSGenerateIBP[allSeeds, Sequence @@ Join[detailedSpecs, {{n[1, 1], 0, 1}}], ProgressReporting -> False];
linear = DSLinear[uniform, context, ProgressReporting -> False];


(* ::Chapter:: *)
(*确定性检查*)

checks = <|
   "contextInitialized" -> (Lookup[context, "status", "failed"] === "initialized"),
   "seedDataGenerated" -> (Lookup[seedData, "dSIBPStatus", "failed"] === "generated"),
   "allSeedsFlat" -> (ListQ[allSeeds] && FreeQ[allSeeds, _List?(MemberQ[#, _Association] &) , {1}]),
   "allDiscreteStatesPresent" -> And @@ Table[
      With[{group = Select[allSeeds,
          Lookup[#, "sectorKey", None] === key[[1]] && Lookup[#, "generator", None] === key[[2]] &]},
       Length[DeleteDuplicates[Lookup[group, "discreteRules", {}]]] ===
        Lookup[First[group], "discreteStateCountExpected", -1]
       ],
      {key, DeleteDuplicates[Lookup[allSeeds, {"sectorKey", "generator"}]]}
      ],
   "templatesHaveNoSymbolicN" -> FreeQ[Lookup[allSeeds, "equation", {}], _n],
   "templatesEOMCanonical" -> And @@ Lookup[allSeeds, "eomCanonicalQ", {False}],
   "uniformGenerated" -> (Lookup[uniform, "status", "failed"] === "generated"),
   "detailedGenerated" -> (Lookup[detailed, "status", "failed"] === "generated"),
   "uniformEqualsDetailed" -> (Sort[ToString[#, InputForm] & /@ Lookup[uniform, "equations", {}]] ===
      Sort[ToString[#, InputForm] & /@ Lookup[detailed, "equations", {}]]),
   "missingRejected" -> (Lookup[missing, "status", "skipped"] === "skipped" || Lookup[missing, "missingIndices", {}] =!= {}),
   "unknownRejected" -> MemberQ[Lookup[unknown, "unknownIndices", {}], notAnIndex],
   "duplicateRejected" -> (Lookup[duplicate, "status", "skipped"] === "skipped" || Lookup[duplicate, "duplicateIndices", {}] =!= {}),
   "discreteRejected" -> MemberQ[Lookup[discrete, "discreteIndicesInRangeSpec", {}], n[1, 1]],
   "linearGenerated" -> (Lookup[linear, "status", "failed"] === "generated")
   |>;

failedChecks = Keys@Select[checks, Not];
Print[<|"passed" -> Count[Values[checks], True], "total" -> Length[checks],
   "failed" -> failedChecks, "templateCount" -> Length[allSeeds],
   "continuousIndices" -> indices, "checks" -> checks|>];
Exit[If[failedChecks === {}, 0, 1]];
