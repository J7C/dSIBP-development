(* ::Package:: *)
(* 本脚本验证 pure massive bubble 的 top 目标包络能通过逐生成元 shift metadata，
   自动得到 017 统一三槽/EOM 公式的四组 top seed 范围；这里只初始化，不展开完整 IBP。 *)

(* ::Chapter:: *)
(*候选加载与 reference family*)

packageFile = Environment["DSIBP_PACKAGE_FILE"];
If[! StringQ[packageFile] || ! FileExistsQ[packageFile], Exit[2]];
Get[packageFile];

projectRoot = DirectoryName[DirectoryName[$InputFileName]];
conventionFile = FileNameJoin[{projectRoot, "independent-benchmark", "package", "examples",
    "04_pure_massive_bubble_closed_loop", "family_conventions.wl"}];
Get[conventionFile];

case = <|
   "name" -> "017ReferenceBubbleSeedOffsets",
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
   "externalInvariantRules" -> {sp[k, k] -> s11},
   "vertexEnergies" -> <|v1 -> P0, v2 -> P0|>,
   "ispData" -> {},
   "zeroPointRules" -> {
     a0[v1] -> 2 nu, a0[v2] -> 2 nu,
     b0[1] -> -2 nu, b0[2] -> -2 nu
     },
   "shrinkPrefactorRules" -> {Exp[Pi Im[nu]]/Pi -> etaNu},
   "symmetryRules" -> exampleSymmetryRules0
   |>;

context = DSInit[case, ProgressReporting -> False];
seedData = DSSeeds[context, ProgressReporting -> False];
seedGroups = DSSeedGroups[seedData];
groupMetadata = DSSeedGroupMetadata[seedData];
allIndices = DeleteDuplicates@Cases[DSAllSeeds[seedData], _a | _b | _bS, Infinity];
meta = DSMetaSeedRange[seedGroups, allIndices];


(* ::Chapter:: *)
(*Top 生成元 offset 与 017 手推范围*)

topGroups = Select[
   Lookup[meta, "groups", {}],
   MemberQ[Lookup[#, "sectorKeys", {}], "top"] &
   ];

targetEnvelope = <|
   a[v1] -> {-1, 4}, a[v2] -> {-1, 4},
   b[1] -> {-2, 5}, b[2] -> {-2, 5}
   |>;

derivedRules[group_] := KeyValueMap[
   Function[{index, offsets}, index -> (targetEnvelope[dsRoot[index]] + offsets)],
   Association[Lookup[group, "seedRangeOffsets", {}]]
   ];
dsRoot[index_] := index /. HoldPattern[bS[e_]] :> b[e];

topRangeData = Association@Table[
    First[Lookup[group, "generators", {}]] -> Association[derivedRules[group]],
    {group, topGroups}
    ];

expectedTopRanges = <|
   {"time", v1} -> <|a[v1] -> {0, 4}, a[v2] -> {-1, 4},
     b[1] -> {-1, 4}, b[2] -> {-1, 4}|>,
   {"time", v2} -> <|a[v1] -> {-1, 4}, a[v2] -> {0, 4},
     b[1] -> {-1, 4}, b[2] -> {-1, 4}|>,
   {"momentum", 1, "loop", 1} -> <|a[v1] -> {-1, 3}, a[v2] -> {-1, 3},
     b[1] -> {0, 5}, b[2] -> {-1, 3}|>,
   {"momentum", 1, "external", 1} -> <|a[v1] -> {-1, 3}, a[v2] -> {-1, 3},
     b[1] -> {0, 3}, b[2] -> {0, 3}|>
   |>;

checks = <|
   "initialized" -> (Lookup[context, "status", "failed"] === "initialized"),
   "groupMetadataAligned" -> (Length[groupMetadata] === Length[seedGroups]),
   "metadataInitialized" -> (Lookup[meta, "status", "failed"] === "initialized"),
   "fourTopGenerators" -> (Length[topGroups] === 4),
   "017TopRangesRecovered" -> (topRangeData === expectedTopRanges)
   |>;

summary = <|
   "passed" -> Count[Values[checks], True],
   "total" -> Length[checks],
   "failed" -> Keys@Select[checks, Not@TrueQ[#] &],
   "groupCount" -> Length[Lookup[meta, "groups", {}]],
   "topRangeData" -> topRangeData,
   "expectedTopRanges" -> expectedTopRanges,
   "checks" -> checks
   |>;

Print[InputForm[summary]];
If[summary["passed"] =!= summary["total"], Exit[1]];
