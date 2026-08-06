(* ::Package:: *)
(* 本脚本从 single-massive sunrise 的 general top-sector IBP templates 提取指标 shift，
   在 GF(2) 上核对 odd/odd parity generators 是否被全部 time/momentum seeds 保持。
   它不撒连续指标点、不生成 linearData，也不调用 Kira。 *)

$HistoryLength = 0;


(* ::Chapter:: *)
(*路径、程序与函数族 convention*)

Get[FileNameJoin[{DirectoryName[$InputFileName], "..", "_harness.wls"}]];
projectDirectory = ExpandFileName[FileNameJoin[{DirectoryName[$InputFileName], "..", ".."}]];
packagePath = dsSmokeResolvePackageFile[FileNameJoin[{projectDirectory, "versions", "018_dSIBP", "Kernel", "dSIBP.wl"}]];
exampleDirectory = FileNameJoin[{
    projectDirectory, "independent-benchmark", "package", "examples",
    "03_single_massive_sunrise"
    }];

Get[packagePath];
Get[FileNameJoin[{exampleDirectory, "family_conventions.wl"}]];


(* ::Chapter:: *)
(*General sunrise templates*)

caseInput = <|
   "name" -> "singleMassiveSunriseParityGeneratorCheck",
   "vertexData" -> {{v1, "+"}, {v2, "+"}},
   "lineData" -> {
     <|"id" -> e1, "endpoints" -> {v1, v2}, "momentum" -> l3,
       "massType" -> "massive", "bbType" -> "h", "nu" -> nuM|>,
     <|"id" -> e2, "endpoints" -> {v1, v2}, "momentum" -> k321,
       "massType" -> "massless", "bbType" -> "exp", "nu" -> 0|>,
     <|"id" -> e3, "endpoints" -> {v1, v2}, "momentum" -> l3 - k321 - kL,
       "massType" -> "massless", "bbType" -> "exp", "nu" -> 0|>
     },
   "loopMomenta" -> {l3, k321},
   "loopExternalMomenta" -> {kL},
   "independentExternalMomenta" -> {},
   "ibpMode" -> "full",
   "vertexEnergies" -> <|v1 -> kE, v2 -> kE|>,
   "ispData" -> {
     <|"name" -> rhoMassless2, "expr" -> sp[k321, l3], "range" -> {0, 1}|>,
     <|"name" -> rhoMassless3, "expr" -> sp[l3 - k321 - kL, l3], "range" -> {0, 1}|>
     },
   "zeroPointRules" -> {
     a0[v1] -> alpha, a0[v2] -> alpha,
     b0[e1] -> betaM, b0[e2] -> beta0, b0[e3] -> beta0
     },
   "shrinkPrefactorRules" -> {Exp[Pi Im[nuM]]/Pi -> etaNu},
   "parityConstraints" -> sunriseParityConstraints0,
   "symmetryRules" -> sunriseSymmetryRules0,
   "seedPreset" -> "quickCheck",
   "seedRanges" -> <|"a" -> {0}, "b" -> {0}, "isp" -> {0, 1}|>
   |>;

context = DSInit[
   caseInput,
   WriteInitializationFiles -> False,
   GenerateDerivativeMetadata -> True
   ];
seedData = DSSeeds[context, ProgressReporting -> False];
topTemplates = Select[
   DSAllSeeds[seedData],
   Lookup[#, "sectorKey", None] === "top" &
   ];
timeGeneratorLabels = DeleteDuplicates @ Lookup[
    Select[topTemplates, Lookup[#, "ibpClass", ""] === "tIBP" &],
    "generator",
    {}
    ];
momentumGeneratorLabels = DeleteDuplicates @ Lookup[
    Select[topTemplates, Lookup[#, "ibpClass", ""] === "qIBP" &],
    "generator",
    {}
    ];
expectedMomentumGeneratorLabels = Join[
   Flatten[
    Table[{"momentum", derivativeLoop, "loop", contractionLoop},
     {derivativeLoop, 2}, {contractionLoop, 2}],
    1
    ],
   Table[{"momentum", derivativeLoop, "external", 1},
    {derivativeLoop, 2}]
   ];
canonicalGeneratorOrder[labels_List] := SortBy[labels, ToString[#, InputForm] &];
momentumGeneratorCoverageQ =
  canonicalGeneratorOrder[momentumGeneratorLabels] ===
   canonicalGeneratorOrder[expectedMomentumGeneratorLabels];


(* ::Chapter:: *)
(*GF(2) shift matrix 与 generators*)

rootSlots = {
   b[e1], n[e1, 1], n[e1, 2],
   b[e2], n[e2, 1], n[e2, 2],
   b[e3], n[e3, 1], n[e3, 2],
   ispN[1], ispN[2]
   };
zeroSlotRules = Thread[rootSlots -> 0];

rootTopIntegralQ[J[_, linePacks_List, ispList_List]] :=
  Length[linePacks] === 3 && And @@ (Length[#] === 3 & /@ linePacks) &&
   Length[ispList] === 2;
rootTopIntegralQ[_] := False;

rootIndexVector[J[_, linePacks_List, ispList_List]] :=
  Flatten[{linePacks, ispList}] /. zeroSlotRules // Expand;

templateShiftRows[entry_Association] := Module[{integrals, vectors},
   integrals = Select[
     DeleteDuplicates[Cases[Lookup[entry, "equation", 0], _J, Infinity]],
     rootTopIntegralQ
     ];
   vectors = rootIndexVector /@ integrals;
   If[vectors === {}, {}, Mod[# - First[vectors], 2] & /@ Rest[vectors]]
   ];

shiftRows = DeleteDuplicates@DeleteCases[
    Flatten[templateShiftRows /@ topTemplates, 1],
    row_ /; row === ConstantArray[0, Length[rootSlots]]
    ];
shiftRank = MatrixRank[shiftRows, Modulus -> 2];
parityGenerators = NullSpace[shiftRows, Modulus -> 2];
generatorExpressions = Expand[# . rootSlots] & /@ parityGenerators;
requestedParityVectors = {
   {1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0},
   {0, 0, 0, 1, 1, 1, 1, 1, 1, 0, 0}
   };
requestedParityExpressions = Expand[# . rootSlots] & /@ requestedParityVectors;
requestedParityRemainders = {1, 1};
requestedParityPreservedQ = TrueQ[
   Mod[shiftRows . Transpose[requestedParityVectors], 2] ===
    ConstantArray[0, {Length[shiftRows], Length[requestedParityVectors]}]
   ];
masslessLineSwapPermutation = {1, 2, 3, 7, 8, 9, 4, 5, 6, 11, 10};
masslessLineSwapInvariantQ = And @@ (
    #[[masslessLineSwapPermutation]] === # & /@ requestedParityVectors
    );
ispParityFreeQ = FreeQ[sunriseParityConstraints0, _ispN] &&
   And @@ (Take[#, -2] === {0, 0} & /@ requestedParityVectors);
sectorParitySummary = Function[metadata,
    With[{data = Lookup[metadata, "parityData", <||>]},
     <|
      "sectorKey" -> Lookup[metadata, "sectorKey", Missing["sectorKey"]],
      "sectorShrunkLines" -> Lookup[metadata, "sectorShrunkLines", {}],
      "status" -> Lookup[data, "status", "missing"],
      "expressions" -> Lookup[Lookup[data, "constraints", {}], "expression", {}],
      "remainders" -> Lookup[Lookup[data, "constraints", {}], "remainder", {}],
      "masslessCycleFlipCount" -> Lookup[data, "masslessCycleFlipCount", Missing["flipCount"]]
      |>
     ]
    ] /@ Lookup[context, "sectors", {}];

summary = <|
   "packageVersion" -> ToString[$dSIBPVersion],
   "contextStatus" -> Lookup[context, "status", "missing"],
   "numericRulesAppliedBeforeSeeds" ->
    TrueQ[Lookup[seedData, "numericRulesAppliedBeforeSeeds", False]],
   "topTemplateCount" -> Length[topTemplates],
   "timeGeneratorCount" -> Length[timeGeneratorLabels],
   "timeGeneratorLabels" -> timeGeneratorLabels,
   "momentumGeneratorCount" -> Length[momentumGeneratorLabels],
   "momentumGeneratorLabels" -> momentumGeneratorLabels,
   "expectedMomentumGeneratorLabels" -> expectedMomentumGeneratorLabels,
   "momentumGeneratorCoverageQ" -> momentumGeneratorCoverageQ,
   "slotCount" -> Length[rootSlots],
   "shiftRowCount" -> Length[shiftRows],
   "shiftRank" -> shiftRank,
   "fullInvariantCount" -> Length[parityGenerators],
   "fullInvariantVectors" -> parityGenerators,
   "fullInvariantExpressions" -> generatorExpressions,
   "requestedParityVectors" -> requestedParityVectors,
   "requestedParityExpressions" -> requestedParityExpressions,
   "requestedParityRemainders" -> requestedParityRemainders,
   "requestedParityPreservedQ" -> requestedParityPreservedQ,
   "ispParityFreeQ" -> ispParityFreeQ,
   "masslessLineSwapInvariantQ" -> masslessLineSwapInvariantQ,
   "sectorParitySummary" -> sectorParitySummary
   |>;

Print[summary];
If[! And[
    summary["contextStatus"] === "initialized",
    ! summary["numericRulesAppliedBeforeSeeds"],
    summary["topTemplateCount"] > 0,
    summary["timeGeneratorCount"] === 2,
    summary["momentumGeneratorCount"] === 6,
    summary["momentumGeneratorCoverageQ"],
    MatrixQ[shiftRows, IntegerQ],
    MatrixQ[parityGenerators, IntegerQ],
    summary["requestedParityPreservedQ"],
    summary["ispParityFreeQ"],
    summary["masslessLineSwapInvariantQ"],
    Length[summary["sectorParitySummary"]] === 5,
    Lookup[summary["sectorParitySummary"], "status", {}] ===
     ConstantArray["enabled", 5]
    ], Exit[1]];
