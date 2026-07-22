(* ::Package:: *)
(* 本检查从冻结 H/h 系统出发，比较两个指定 family 的 direct-h、bare-H 与 H-to-h 编译系统及全部 canonical seeds。 *)

ClearAll["Global`*"];


(* ::Chapter:: *)
(*冻结 expected 与 package*)
Get[FileNameJoin[{DirectoryName[DirectoryName[$InputFileName]], "h-routes", "expected.wl"}]];

checkDir = DirectoryName[$InputFileName];
workspaceDir = DirectoryName[checkDir];
projectDir = DirectoryName[workspaceDir];
packagePath = FileNameJoin[{projectDir, "independent-benchmark", "package", "package_014.wl"}];
resultsDir = FileNameJoin[{checkDir, "results"}];
resultPath = FileNameJoin[{resultsDir, "h-against-package.wl"}];
If[! DirectoryQ[resultsDir], CreateDirectory[resultsDir, CreateIntermediateDirectories -> True]];

Quiet[Get[packagePath], General::shdw];
DSMessagesOff[];


(* ::Chapter:: *)
(*三条 basis route 的正式输入*)

(* ::Section::Closed:: *)
(*裸 H 与独立 T_Htoh 都显式给 P/Q/T/W，不调用 package preset*)
massiveLine[id_, momentum_, route_] := Module[{normalization, functionSystem},
  normalization = (4 I/Pi) Exp[Pi Im[nuM]];
  functionSystem = Switch[route,
    "direct-h", Automatic,
    "bare-H", <|
      "variable" -> x,
      "P" -> 1/x,
      "Q" -> 1 - nuM^2/x^2,
      "T" -> IdentityMatrix[2],
      "W" -> -normalization/x,
      "WT" -> Automatic,
      "shrinkBShift" -> 1,
      "shrinkZeroPointShift" -> 0
    |>,
    "H-to-h", <|
      "variable" -> x,
      "P" -> 1/x,
      "Q" -> 1 - nuM^2/x^2,
      "T" -> hTohTransform[x, nuM],
      "W" -> -normalization/x,
      "WT" -> Automatic,
      "shrinkBShift" -> 1,
      "shrinkZeroPointShift" -> 2 nuM
    |>
  ];
  If[functionSystem === Automatic,
    <|"id" -> id, "endpoints" -> {v1, v2}, "momentum" -> momentum,
      "massType" -> "massive", "bbType" -> "h", "nu" -> nuM|>,
    <|"id" -> id, "endpoints" -> {v1, v2}, "momentum" -> momentum,
      "massType" -> "massive", "functionSystem" -> functionSystem, "nu" -> nuM|>
  ]
];

makeHCase[family_, signs_List, route_] := Module[{lines, loops, externals, invariants},
  Switch[family,
    "atomic_massive_line",
      lines = {massiveLine[1, ell, route]}; loops = {ell}; externals = {}; invariants = {},
    "pure_massive_bubble_reference",
      lines = {massiveLine[1, q, route], massiveLine[2, q - k, route]};
      loops = {q}; externals = {k}; invariants = {sp[k, k] -> s11}
  ];
  <|
    "name" -> StringRiffle[{family, StringJoin[ToString /@ signs], route}, "-"],
    "vertexData" -> MapThread[{#1, If[#2 === 1, "+", "-"]} &, {{v1, v2}, signs}],
    "lineData" -> lines,
    "loopMomenta" -> loops,
    "externalMomenta" -> externals,
    "externalInvariantRules" -> invariants,
    "vertexEnergies" -> <|v1 -> E1, v2 -> E2|>,
    "ispData" -> {},
    "zeroPointRules" -> Join[
      {a0[v1] -> alpha1, a0[v2] -> alpha2},
      Map[b0[Lookup[#, "id"]] -> Symbol["beta" <> ToString[Lookup[#, "id"]]] &, lines]
    ],
    "symmetryRules" -> {},
    "seedRanges" -> <|"a" -> {0}, "b" -> {0}, "sampleOnly" -> True|>
  |>
];


(* ::Chapter:: *)
(*编译系统与 seed 记录*)

(* ::Section::Closed:: *)
(*functionSystem 的局部 x 可能位于 private context，只按 SymbolName 归一*)
normalizeX[expr_] := expr /. symbol_Symbol /; SymbolName[Unevaluated[symbol]] === "x" :> Global`x;

compiledSystems[context_Association] := Lookup[
  Lookup[Lookup[context, "topology", <||>], "lines", {}],
  "compiledFunctionSystem",
  {}
];

expectedAT[route_] := Switch[route,
  "bare-H", bareHSystem[x, nuM],
  "direct-h" | "H-to-h", directHSystem[x, nuM]
];

expectedWT[route_] := Switch[route,
  "bare-H", -(4 I/Pi) Exp[Pi Im[nuM]]/x,
  "direct-h" | "H-to-h", -(4 I/Pi) Exp[Pi Im[nuM]] x^(-2 nuM - 1)
];

compiledChecks[context_Association, route_] := Map[
  Function[system, <|
    "atDifference" -> Simplify[Together[normalizeX[Lookup[system, "AT"]] - expectedAT[route]]],
    "wtDifference" -> Simplify[Together[normalizeX[Lookup[system, "WT"]] - expectedWT[route]]],
    "shrinkTerms" -> normalizeX[Lookup[system, "shrinkTerms", Missing["Absent"]]]
  |>],
  compiledSystems[context]
];

generateRoute[family_, signs_List, route_] := Module[{context, seeds},
  context = DSInit[
    makeHCase[family, signs, route],
    WriteInitializationFiles -> False,
    GenerateDerivativeMetadata -> False,
    RegisterAsCurrent -> False,
    ProgressReporting -> False
  ];
  seeds = DSSeeds[
    context,
    UseSampleOnly -> True,
    DiscreteMode -> "all",
    GenerateShrinkSectors -> True,
    MaxEquationCount -> 5000,
    ProgressReporting -> False
  ];
  <|
    "context" -> context,
    "records" -> Lookup[seeds, "equations", {}],
    "compiledChecks" -> compiledChecks[context, route]
  |>
];

recordKey[record_] := ToString[{
  Lookup[record, "source"], Lookup[record, "generator"],
  Lookup[record, "continuousRules"], Lookup[record, "discreteRules"]
}, InputForm];

recordIndex[records_List] := Association[recordKey[#] -> # & /@ records];


(* ::Chapter:: *)
(*全部 fixed branch 对照*)
runSpecs = {
  {"atomic_massive_line", {-1, -1}},
  {"atomic_massive_line", {-1, 1}},
  {"pure_massive_bubble_reference", {-1, -1}},
  {"pure_massive_bubble_reference", {-1, 1}}
};

compareSpec[spec_List] := Module[
  {family = spec[[1]], signs = spec[[2]], direct, bare, transformed,
   directIndex, transformedIndex, keys, relationChecks, bareChecks,
   directCompiled, bareCompiled, transformedCompiled, compiledRouteChecks},
  direct = generateRoute[family, signs, "direct-h"];
  bare = generateRoute[family, signs, "bare-H"];
  transformed = generateRoute[family, signs, "H-to-h"];
  directIndex = recordIndex[Lookup[direct, "records"]];
  transformedIndex = recordIndex[Lookup[transformed, "records"]];
  keys = Union[Keys[directIndex], Keys[transformedIndex]];
  relationChecks = Map[Function[key,
    directRecord = Lookup[directIndex, key, Missing["MissingDirect"]];
    transformedRecord = Lookup[transformedIndex, key, Missing["MissingTransformed"]];
    difference = If[MissingQ[directRecord] || MissingQ[transformedRecord],
      Missing["KeySetMismatch"],
      Expand[Lookup[directRecord, "equation"] - Lookup[transformedRecord, "equation"]]
    ];
    <|"family" -> family, "signs" -> signs, "key" -> key,
      "difference" -> difference, "passed" -> TrueQ[difference === 0]|>
  ], keys];
  bareChecks = Map[Function[record, <|
    "family" -> family,
    "signs" -> signs,
    "passed" -> TrueQ[Lookup[record, "eomCanonicalQ", False]] && Lookup[record, "forbiddenNData", {1}] === {},
    "forbiddenNData" -> Lookup[record, "forbiddenNData", Missing["Absent"]]
  |>], Lookup[bare, "records"]];
  directCompiled = Lookup[direct, "compiledChecks"];
  bareCompiled = Lookup[bare, "compiledChecks"];
  transformedCompiled = Lookup[transformed, "compiledChecks"];
  compiledRouteChecks = {
    <|"label" -> {family, signs, "direct-h-AT-WT"},
      "passed" -> And @@ (TrueQ[Lookup[#, "atDifference"] === ConstantArray[0, {2, 2}]
        && Lookup[#, "wtDifference"] === 0] & /@ directCompiled)|>,
    <|"label" -> {family, signs, "bare-H-AT-WT"},
      "passed" -> And @@ (TrueQ[Lookup[#, "atDifference"] === ConstantArray[0, {2, 2}]
        && Lookup[#, "wtDifference"] === 0] & /@ bareCompiled)|>,
    <|"label" -> {family, signs, "H-to-h-AT-WT"},
      "passed" -> And @@ (TrueQ[Lookup[#, "atDifference"] === ConstantArray[0, {2, 2}]
        && Lookup[#, "wtDifference"] === 0] & /@ transformedCompiled)|>,
    <|"label" -> {family, signs, "H-to-h-shrinkTerms"},
      "passed" -> TrueQ[Lookup[directCompiled, "shrinkTerms"] === Lookup[transformedCompiled, "shrinkTerms"]]|>
  };
  <|
    "family" -> family,
    "signs" -> signs,
    "relationChecks" -> relationChecks,
    "bareChecks" -> bareChecks,
    "compiledChecks" -> compiledRouteChecks,
    "counts" -> <|
      "direct" -> Length[Lookup[direct, "records"]],
      "bare" -> Length[Lookup[bare, "records"]],
      "transformed" -> Length[Lookup[transformed, "records"]]
    |>
  |>
];

runResults = compareSpec /@ runSpecs;
relationChecks = Flatten[Lookup[runResults, "relationChecks"]];
bareChecks = Flatten[Lookup[runResults, "bareChecks"]];
compiledRouteChecks = Flatten[Lookup[runResults, "compiledChecks"]];

summary = <|
  "packageHash" -> FileHash[packagePath, "SHA256", "HexString"],
  "hTohVsDirectPassed" -> Count[relationChecks, _?(TrueQ[Lookup[#, "passed", False]] &)],
  "hTohVsDirectTotal" -> Length[relationChecks],
  "hTohNonzeroDifferenceCount" -> Count[Lookup[relationChecks, "difference"], Except[0]],
  "bareCanonicalPassed" -> Count[bareChecks, _?(TrueQ[Lookup[#, "passed", False]] &)],
  "bareCanonicalTotal" -> Length[bareChecks],
  "compiledPassed" -> Count[compiledRouteChecks, _?(TrueQ[Lookup[#, "passed", False]] &)],
  "compiledTotal" -> Length[compiledRouteChecks],
  "byRun" -> (KeyTake[#, {"family", "signs", "counts"}] & /@ runResults),
  "firstRelationFailure" -> SelectFirst[relationChecks, ! TrueQ[Lookup[#, "passed", False]] &, Missing["NoFailure"]],
  "firstBareFailure" -> SelectFirst[bareChecks, ! TrueQ[Lookup[#, "passed", False]] &, Missing["NoFailure"]],
  "firstCompiledFailure" -> SelectFirst[compiledRouteChecks, ! TrueQ[Lookup[#, "passed", False]] &, Missing["NoFailure"]]
|>;

Put[summary, resultPath];
Print[InputForm[summary]];
If[! And[
  summary["hTohVsDirectPassed"] === summary["hTohVsDirectTotal"],
  summary["bareCanonicalPassed"] === summary["bareCanonicalTotal"],
  summary["compiledPassed"] === summary["compiledTotal"]
], Exit[1]];
