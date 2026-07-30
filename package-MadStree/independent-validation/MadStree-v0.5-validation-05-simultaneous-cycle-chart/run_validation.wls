(* ::Package:: *)

$CharacterEncoding = "UTF-8";

(***
文件：run_validation.wls
用途：独立验证共同-theta simultaneous contact、coincident quotient、time-only triangle 与全部 rank chart。
路线：独立枚举奇子集和图 partition，并逐 chart 检查 MadStree 的 normal-crossing 证书。
输出：自动写入 results/summary.wl 与 000_MadStree-v0.5-validation-05-report.md。
***)

(* ::Chapter:: *)
(*路径与检查工具*)

validationDirectory = DirectoryName[$InputFileName];
madStreeRoot = DirectoryName[DirectoryName[validationDirectory]];
packageRoot = FileNameJoin[{madStreeRoot, "versions", "MadStree-v0.5"}];
resultsDirectory = FileNameJoin[{validationDirectory, "results"}];
summaryFile = FileNameJoin[{resultsDirectory, "summary.wl"}];
reportFile = FileNameJoin[{validationDirectory, "000_MadStree-v0.5-validation-05-report.md"}];
If[! DirectoryQ[resultsDirectory], CreateDirectory[resultsDirectory, CreateIntermediateDirectories -> True]];
AppendTo[$Path, FileNameJoin[{packageRoot, "Kernel"}]];
Needs["MadStree`"];
validationStartTime = AbsoluteTime[];

writeValidationText[path_String, text_String] := Module[{stream},
  stream = OpenWrite[path, BinaryFormat -> True];
  BinaryWrite[stream, ToCharacterCode[text, "UTF8"], "Byte"];
  Close[stream];
  path
];


writeValidationExpression[path_String, expression_] := writeValidationText[
  path,
  StringReplace[
    ToString[expression, InputForm, PageWidth -> 120],
    RegularExpression["[ \\t]+(?=\\r?\\n|$)"] -> ""
  ] <> "\n"
];

exactZeroQ[expression_] := And @@ (PossibleZeroQ /@ Flatten[{expression}]);
formatSeconds[value_] := ToString[NumberForm[N[value], {Infinity, 6}], OutputForm];


(* ::Chapter:: *)
(*三条共同 theta 的 massless simultaneous contact*)

masslessIds = {e1, e2, e3};
parallelMasslessSpec = <|
  "normalization" -> 1,
  "vertices" -> {
    <|"id" -> u, "energy" -> ku, "timePower" -> 1/3|>,
    <|"id" -> v, "energy" -> kv, "timePower" -> 2/5|>
  },
  "lines" -> MapThread[
    <|"id" -> #1, "type" -> "masslessFull", "endpoints" -> {u, v},
      "momentum" -> #2, "skType" -> "++", "nu" -> 1/2,
      "pinchNormalization" -> 1|> &,
    {masslessIds, {2, 3, 5}}
  ],
  "contactEvents" -> {masslessIds}
|>;
parallelMassless = MSInitTimeGraph[parallelMasslessSpec];
parallelMasslessTopKey = First[parallelMassless["sectorOrder"]];

independentOddSubsets = Select[Rest@Subsets[masslessIds], OddQ[Length[#]] &];
independentEventData = SortBy[
  <|"selectedLineIds" -> #, "coefficient" -> 2^(1 - Length[#])|> & /@ independentOddSubsets,
  {Length[#["selectedLineIds"]] &, ToString[#["selectedLineIds"], InputForm] &}
];
packageTopEvents = SortBy[
  KeyTake[#, {"selectedLineIds", "thetaBundleCoefficient"}] & /@
    Select[parallelMassless["contactTransitions"], #["sourceSector"] === parallelMasslessTopKey &],
  {Length[#["selectedLineIds"]] &, ToString[#["selectedLineIds"], InputForm] &}
];
packageEventData = packageTopEvents /. Association[
  "selectedLineIds" -> ids_, "thetaBundleCoefficient" -> coefficient_
] :> <|"selectedLineIds" -> ids, "coefficient" -> coefficient|>;

expectedContactMatrix[selectedIds_List, endpointSign_] := Module[
  {sourceStates, sourceBits, sourceRow, selectedPositions, unselectedPositions, coefficient},
  sourceStates = First[MSSectors[parallelMassless]]["stateOrder"];
  selectedPositions = Flatten[FirstPosition[masslessIds, #] & /@ selectedIds];
  unselectedPositions = Complement[Range[3], selectedPositions];
  sourceBits = ConstantArray[0, 3];
  sourceBits[[selectedPositions]] = 1;
  sourceBits[[unselectedPositions]] = 0;
  sourceRow = First@FirstPosition[sourceStates, sourceBits];
  coefficient = 2^(1 - Length[selectedIds]) endpointSign^Length[selectedIds];
  Transpose[{coefficient UnitVector[Length[sourceStates], sourceRow]}]
];

masslessContactResiduals = Flatten@Map[
  Function[event,
    With[{contact = SelectFirst[MSContactMaps[parallelMassless, parallelMasslessTopKey],
      #["selectedLineIds"] === event["selectedLineIds"] &]},
      {
        contact["matricesByComponent"][1] - expectedContactMatrix[event["selectedLineIds"], -2],
        contact["matricesByComponent"][2] - expectedContactMatrix[event["selectedLineIds"], 2]
      }
    ]
  ],
  independentEventData
];
masslessChildren = Rest[MSSectors[parallelMassless]];
simultaneousSeconds = N[AbsoluteTime[] - validationStartTime, 10];


(* ::Chapter:: *)
(*Massive coincident quotient 与 normalization 累积*)

massiveIds = {m1, m2, m3};
massivePinches = {2, 3, 5};
parallelMassiveSpec = <|
  "normalization" -> 1,
  "vertices" -> {
    <|"id" -> u, "energy" -> ku, "timePower" -> 1/3|>,
    <|"id" -> v, "energy" -> kv, "timePower" -> 2/5|>
  },
  "lines" -> MapThread[
    <|"id" -> #1, "type" -> "massiveFull", "endpoints" -> {u, v},
      "momentum" -> #2, "nu" -> #3, "skType" -> "++",
      "pinchNormalization" -> #4|> &,
    {massiveIds, {2, 3, 5}, {1/5, 1/4, 1/3}, massivePinches}
  ],
  "contactEvents" -> {massiveIds}
|>;
parallelMassive = MSInitTimeGraph[parallelMassiveSpec];
singleMassiveSectors = Select[MSSectors[parallelMassive], Length[#["contractedLineIds"]] === 1 &];
tripleMassiveSector = SelectFirst[MSSectors[parallelMassive], Sort[#["contractedLineIds"]] === Sort[massiveIds] &];
massiveNormalizationResiduals = Map[
  #["normalization"] - massivePinches[[First@FirstPosition[massiveIds, First[#["contractedLineIds"]]]]] &,
  singleMassiveSectors
];
massiveRoundTrips = Map[
  With[{formula = MSFormulaMatrices[parallelMassive, #["sectorKey"]]},
    Simplify[formula["UInverse"].formula["U"] - IdentityMatrix[#["masterCount"]]]
  ] &,
  singleMassiveSectors
];


(* ::Chapter:: *)
(*Triangle partitions 与六张 strict charts*)

triangleSpec = <|
  "normalization" -> 1,
  "vertices" -> {
    <|"id" -> t1, "energy" -> k1, "timePower" -> 1/3|>,
    <|"id" -> t2, "energy" -> k2, "timePower" -> 2/5|>,
    <|"id" -> t3, "energy" -> k3, "timePower" -> 3/7|>
  },
  "lines" -> {
    <|"id" -> l12, "type" -> "masslessFull", "endpoints" -> {t1, t2},
      "momentum" -> q12, "skType" -> "++", "nu" -> 1/2, "pinchNormalization" -> 1|>,
    <|"id" -> l23, "type" -> "masslessFull", "endpoints" -> {t2, t3},
      "momentum" -> q23, "skType" -> "++", "nu" -> 1/2, "pinchNormalization" -> 1|>,
    <|"id" -> l31, "type" -> "masslessFull", "endpoints" -> {t3, t1},
      "momentum" -> q31, "skType" -> "++", "nu" -> 1/2, "pinchNormalization" -> 1|>
  }
|>;
triangle = MSInitTimeGraph[triangleSpec];
trianglePoint = {
  k1 -> -11 I, k2 -> -7 I, k3 -> -5 I,
  q12 -> 2, q23 -> 3, q31 -> 4
};
triangleLineIds = {l12, l23, l31};
expectedContractedSets = Join[{{}}, Subsets[triangleLineIds, {1}], Subsets[triangleLineIds, {2}]];
actualContractedSets = Lookup[MSSectors[triangle], "contractedLineIds"];
independentTriangleSectorKey[ids_List] := StringJoin[
  If[MemberQ[ids, #], "0", "1"] & /@ triangleLineIds
];
expectedTriangleKeys = independentTriangleSectorKey /@ expectedContractedSets;
actualTriangleKeys = Lookup[MSSectors[triangle], "sectorKey"];

expectedTransitionPairs = Join[
  ({independentTriangleSectorKey[{}], independentTriangleSectorKey[{#}]} & /@ triangleLineIds),
  Flatten[Map[
    Function[source,
      {independentTriangleSectorKey[source], independentTriangleSectorKey[#]} & /@
        Select[Subsets[triangleLineIds, {2}], MemberQ[#, First[source]] &]
    ],
    Subsets[triangleLineIds, {1}]
  ], 1]
];
actualTransitionPairs = Lookup[triangle["contactTransitions"], {"sourceSector", "targetSector"}];

{chartSeconds, triangleCertificate} = AbsoluteTiming[
  MSBoundaryChartCertificate[triangle, trianglePoint, RankOrder -> All]
];
triangleCharts = Lookup[triangleCertificate, "charts", {}];
rankOrders = Permutations[{t1, t2, t3}];

triangleTargetSector = MSSectors[triangle][[2]];
targetShift = ReplacePart[ConstantArray[0, Length[triangleTargetSector["vertexComponents"]]], 1 -> 1];
shiftReduction = MadStree`Private`msShiftedTargetReduction[
  triangleTargetSector, targetShift, triangle
];
triangleDE = MSDLogDE[triangle];


(* ::Chapter:: *)
(*检查、summary 与自动报告*)

checks = <|
  "oddSubsetIdentity" -> packageEventData === independentEventData,
  "masslessContactMatrices" -> exactZeroQ[masslessContactResiduals],
  "masslessChildCount" -> Length[masslessChildren] === 4,
  "masslessChildBasePower" -> And @@ (#["baseTimePowers"] === {26/15} & /@ masslessChildren),
  "masslessNormalization" -> And @@ (#["normalization"] === 1 & /@ MSSectors[parallelMassless]),
  "masslessCoincidentMasters" -> And @@ (#["masterCount"] === 1 & /@ masslessChildren),
  "massiveSingleCoincidentDimension" -> Lookup[singleMassiveSectors, "masterCount"] === {9, 9, 9},
  "massiveNormalizationAccumulation" -> exactZeroQ[massiveNormalizationResiduals] &&
    tripleMassiveSector["normalization"] === Times @@ massivePinches,
  "massiveLocalDiagonalizers" -> exactZeroQ[massiveRoundTrips],
  "triangleSevenCanonicalSectors" -> Sort[actualContractedSets] === Sort[expectedContractedSets] &&
    actualTriangleKeys === expectedTriangleKeys && DuplicateFreeQ[actualTriangleKeys] &&
    triangle["sectorKeySchema", "storageType"] === "String",
  "triangleNineTransitions" -> Length[actualTransitionPairs] === 9 &&
    Sort[actualTransitionPairs] === Sort[expectedTransitionPairs],
  "allSixRankCharts" -> Length[triangleCharts] === 6 &&
    Sort[Lookup[triangleCharts, "rankOrder"]] === Sort[rankOrders],
  "allChartsNormalCrossing" -> And @@ Lookup[triangleCharts, "normalCrossingQ"],
  "allSectorThetaFixed" -> FreeQ[Lookup[triangleCharts, "thetaFixingBySector"], "unfixed", Infinity],
  "allChartQuotientsCertified" -> And @@ Lookup[triangleCharts, "sectorQuotientCertifiedQ"],
  "shiftedChildReduction" -> Lookup[shiftReduction, "status", None] === "reducedToGlobalMasters" &&
    Dimensions[shiftReduction["matrix"]] === {triangleTargetSector["masterCount"], Length[MSMasterIntegrals[triangle]]},
  "triangleDLogClosed" -> triangleDE["dlogStatus"] === "certifiedByFormulaChecks" &&
    FreeQ[triangleDE, "contactShiftRequiresReduction", Infinity]
|>;

validationPassed = And @@ Values[checks];
elapsedSeconds = N[AbsoluteTime[] - validationStartTime, 10];
sourceFiles = FileNameJoin[{packageRoot, #}] & /@ {
  "Kernel/Core/Sectors.wl", "Kernel/Formula/Recurrence.wl",
  "Kernel/DE/DLog.wl", "Kernel/Numerics/Boundary.wl"
};
sourceDigests = AssociationThread[
  StringReplace[#, packageRoot ~~ ("\\" | "/") -> ""] & /@ sourceFiles,
  IntegerString[FileHash[#, "SHA256"], 16, 64] & /@ sourceFiles
];

summary = <|
  "schema" -> "madstree_independent_validation_v1",
  "version" -> "v0.5",
  "task" -> "T5 simultaneous contact time-only cycle normal-crossing",
  "status" -> If[validationPassed, "passed", "failed"],
  "checks" -> checks,
  "passedCount" -> Count[Values[checks], True],
  "checkCount" -> Length[checks],
  "sourceDigests" -> sourceDigests,
  "masslessNormalization" -> <|"root" -> 1, "linePinches" -> {1, 1, 1}|>,
  "massiveNormalization" -> <|"root" -> 1, "linePinches" -> massivePinches|>,
  "oddSubsetExpected" -> independentEventData,
  "masslessSectorData" -> (KeyTake[#, {"sectorKey", "contractedLineIds", "baseTimePowers", "normalization", "masterCount"}] & /@ MSSectors[parallelMassless]),
  "massiveSectorData" -> (KeyTake[#, {"sectorKey", "contractedLineIds", "baseTimePowers", "normalization", "masterCount"}] & /@ MSSectors[parallelMassive]),
  "trianglePoint" -> trianglePoint,
  "triangleSectors" -> actualContractedSets,
  "triangleSectorKeys" -> actualTriangleKeys,
  "sectorKeySchema" -> triangle["sectorKeySchema"],
  "triangleTransitions" -> actualTransitionPairs,
  "rankOrders" -> rankOrders,
  "chartDivisorCounts" -> (Length[#["divisorRecords"]] & /@ triangleCharts),
  "boundaryPoint" -> "simultaneous K-infinity boundary in all six strict charts",
  "numericalTransportPath" -> Missing["NotApplicable"],
  "frobeniusOrder" -> Missing["NotApplicable"],
  "transportOrder" -> Missing["NotApplicable"],
  "simultaneousSeconds" -> simultaneousSeconds,
  "chartSeconds" -> chartSeconds,
  "elapsedSeconds" -> elapsedSeconds
|>;
writeValidationExpression[summaryFile, summary];

reportLines = Join[
  {
    "# MadStree v0.5 independent validation report: T5 simultaneous/cycle/chart",
    "",
    "> Generated automatically by `run_validation.wls`.",
    "",
    "## Status",
    "",
    "- status: `" <> summary["status"] <> "`",
    "- checks: `" <> ToString[summary["passedCount"]] <> "/" <> ToString[summary["checkCount"]] <> "`",
    "- version: `MadStree-v0.5`",
    "",
    "## Scope and normalization",
    "",
    "- massless common-theta root/line normalization: `1 / {1,1,1}`",
    "- massive quotient root/explicit pinch normalization: `1 / {2,3,5}`",
    "- odd-subset coefficients: `" <> ToString[independentEventData, InputForm] <> "`",
    "- simultaneous child power: `au+av+1=26/15`; a multi-edge event merges the vertices once",
    "",
    "## Boundary point, charts and path",
    "",
    "- exact triangle point: `" <> ToString[trianglePoint, InputForm] <> "`",
    "- strict rank orders: `" <> ToString[rankOrders, InputForm] <> "`",
    "- boundary: all `K_i -> infinity` in each nested chart",
    "- numerical transport path: `not applicable`",
    "- Frobenius/local/transport orders: `not applicable`",
    "",
    "## Timing",
    "",
    "- simultaneous/contact construction: `" <> formatSeconds[simultaneousSeconds] <> " s`",
    "- all-chart certificate: `" <> formatSeconds[chartSeconds] <> " s`",
    "- total wall time: `" <> formatSeconds[elapsedSeconds] <> " s`",
    "",
    "## Checks",
    ""
  },
  KeyValueMap["- `" <> #1 <> "`: " <> If[TrueQ[#2], "PASS", "FAIL"] &, checks],
  {
    "",
    "## Evidence",
    "",
    "- triangle contracted sets: `" <> ToString[actualContractedSets, InputForm] <> "`",
    "- root line order: `" <> ToString[triangleLineIds, InputForm] <> "`; triangle sector keys: `" <>
      ToString[actualTriangleKeys, InputForm] <> "`",
    "- triangle transition count: `" <> ToString[Length[actualTransitionPairs]] <> "`",
    "- chart divisor counts: `" <> ToString[summary["chartDivisorCounts"], InputForm] <> "`",
    "- machine-readable summary: `results/summary.wl`",
    "- no FlintNDE transport or finite-point defining integral was used."
  }
];
writeValidationText[reportFile, StringRiffle[reportLines, "\n"] <> "\n"];

Print["MadStree T5 checks: ", summary["passedCount"], "/", summary["checkCount"]];
KeyValueMap[Print[#1, ": ", #2] &, checks];
If[! validationPassed, Exit[1]];
