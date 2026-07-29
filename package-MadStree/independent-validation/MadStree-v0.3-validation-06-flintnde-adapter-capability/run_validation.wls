(* ::Package:: *)

$CharacterEncoding = "UTF-8";

(***
文件：run_validation.wls
用途：独立验证 MadStree Wolfram 入口对 FlintNDE 的保存点、运行目录、正则奇点与超能力拒绝。
路线：普通点用一维 Laplace 解析解；奇点能力用独立构造的 exact Q(i)(t) 一维系统。
输出：自动写入 results/summary.wl 与 000_MadStree-v0.3-validation-06-report.md。
***)

(* ::Chapter:: *)
(*路径、固定积分与公共参数*)

validationDirectory = DirectoryName[$InputFileName];
madStreeRoot = DirectoryName[DirectoryName[validationDirectory]];
packageRoot = FileNameJoin[{madStreeRoot, "versions", "MadStree-v0.3"}];
resultsDirectory = FileNameJoin[{validationDirectory, "results"}];
summaryFile = FileNameJoin[{resultsDirectory, "summary.wl"}];
reportFile = FileNameJoin[{validationDirectory, "000_MadStree-v0.3-validation-06-report.md"}];
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

context = MSInitTree[<|
  "normalization" -> 1,
  "vertices" -> {
    <|"id" -> v, "energy" -> k0, "timePower" -> a, "phaseSign" -> 1|>
  },
  "lines" -> {}
|>, NuConvention -> "Positive"];
targetRules = {k0 -> 3, a -> 1/3};
boundaryScale = 8;
workingPrecision = 50;
transportOrder = 72;
referenceTransportOrder = 96;
targetRelativeError = "1e-22";
ordinarySaveInput = {{0, "save"}, {1/2, "save"}, {1, "save"}};

formatSeconds[value_] := ToString[NumberForm[N[value], {Infinity, 6}], OutputForm];
parseDecimal[text_String] := ToExpression[StringReplace[text, "e" -> "*^"]];
parseAcbRecord[record_Association] := parseDecimal[record["real"]] + I parseDecimal[record["imag"]];
relativeDifference[left_, right_] := Abs[left - right]/Max[Abs[right], 10^-40];

sourceRuntimePatterns = {"*.json", "*.pyc"};
packageRuntimeFilesBefore = Sort@Flatten[
  FileNames[#, packageRoot, Infinity] & /@ sourceRuntimePatterns
];


(* ::Chapter:: *)
(*无穷远边界、非法格式与普通点保存路线*)

{boundarySeconds, boundary} = AbsoluteTiming[
  MSBoundaryData[
    context,
    targetRules,
    BoundaryScale -> boundaryScale,
    WorkingPrecision -> workingPrecision
  ]
];
transportJsonDirectory = FileNameJoin[{validationDirectory, "results_temp", "flintnde_transport"}];
jsonBeforeInvalid = If[DirectoryQ[transportJsonDirectory], FileNames["*.json", transportJsonDirectory], {}];
invalidSaveResult = MSFlintNDETransport[
  context,
  boundary,
  FlintNDESavePoints -> {{1/2, "save", "forbiddenName"}},
  MSRuntimeDirectory -> validationDirectory
];
jsonAfterInvalid = If[DirectoryQ[transportJsonDirectory], FileNames["*.json", transportJsonDirectory], {}];

{ordinarySeconds, ordinaryResult} = AbsoluteTiming[
  MSFlintNDETransport[
    context,
    boundary,
    FlintNDESavePoints -> ordinarySaveInput,
    WorkingPrecision -> workingPrecision,
    TransportOrder -> transportOrder,
    ReferenceTransportOrder -> referenceTransportOrder,
    TargetRelativeError -> targetRelativeError,
    MSRuntimeDirectory -> validationDirectory
  ]
];

ordinarySaveEvidence = Lookup[ordinaryResult, "savePoints", <||>];
ordinaryAggregate = If[
  StringQ[Lookup[ordinarySaveEvidence, "summaryFile", None]] &&
    FileExistsQ[ordinarySaveEvidence["summaryFile"]],
  Import[ordinarySaveEvidence["summaryFile"], "RawJSON"],
  <||>
];
ordinaryPoints = Lookup[ordinaryAggregate, "points", {}];
ordinaryCoordinates = {0, 1/2, 1};
anchorRules = Lookup[boundary, "anchorRules", {}];
anchorK0 = k0 /. anchorRules;
physicalK0At[s_] := anchorK0 + s ((k0 /. targetRules) - anchorK0);
analyticValueAt[s_] := N[Gamma[4/3]/(I physicalK0At[s])^(4/3), 45];
savedOrdinaryValues = If[
  Length[ordinaryPoints] === 3,
  parseAcbRecord[First[#["result"]]] & /@ ordinaryPoints,
  {}
];
ordinaryResiduals = If[
  Length[savedOrdinaryValues] === 3,
  MapThread[relativeDifference, {savedOrdinaryValues, analyticValueAt /@ ordinaryCoordinates}],
  {Infinity}
];


(* ::Chapter:: *)
(*正则奇点保存与二阶 pole 能力边界*)

singularParameter = Unique["t"];
singularBoundary = <|
  "status" -> "generated",
  "method" -> "validationExactRegularSingularProbe",
  "boundaryKind" -> "singularFrobenius",
  "masterDigest" -> context["masterDigest"],
  "singularParameter" -> singularParameter,
  "singularConnection" -> {{2/singularParameter}},
  "leadingBranches" -> {
    <|"frobeniusExponent" -> 2, "logPower" -> 0,
      "normalizedLeadingVector" -> {1}, "physicalWeight" -> 1|>
  },
  "anchorRules" -> anchorRules,
  "targetRules" -> targetRules
|>;

{singularSeconds, singularResult} = AbsoluteTiming[
  MSFlintNDETransport[
    context,
    singularBoundary,
    FlintNDESavePoints -> <|
      "singular" -> {{0, "save"}},
      "ordinary" -> {{1, "save"}}
    |>,
    WorkingPrecision -> workingPrecision,
    TransportOrder -> transportOrder,
    ReferenceTransportOrder -> referenceTransportOrder,
    TargetRelativeError -> targetRelativeError,
    MSRuntimeDirectory -> validationDirectory
  ]
];

singularSaveEvidence = Lookup[singularResult, "savePoints", <||>];
singularAggregate = If[
  StringQ[Lookup[singularSaveEvidence, "summaryFile", None]] &&
    FileExistsQ[singularSaveEvidence["summaryFile"]],
  Import[singularSaveEvidence["summaryFile"], "RawJSON"],
  <||>
];
singularSavedPoints = Lookup[singularAggregate, "points", {}];
savedFrobeniusPoint = SelectFirst[
  singularSavedPoints,
  Lookup[#, "stage", None] === "singular" &,
  <||>
];

unsupportedBoundary = Join[
  singularBoundary,
  <|
    "method" -> "validationUnsupportedSecondOrderPoleProbe",
    "singularConnection" -> {{2/singularParameter^2}}
  |>
];
{failClosedSeconds, unsupportedResult} = AbsoluteTiming[
  MSFlintNDETransport[
    context,
    unsupportedBoundary,
    WorkingPrecision -> 40,
    TransportOrder -> 24,
    ReferenceTransportOrder -> 32,
    TargetRelativeError -> "1e-16",
    MSRuntimeDirectory -> validationDirectory
  ]
];
unsupportedEvidence = If[
  Head[unsupportedResult] === Failure,
  Association[unsupportedResult[[2]]],
  <||>
];
unsupportedBackend = Lookup[unsupportedEvidence, "backend", <||>];


(* ::Chapter:: *)
(*目录、检查、summary 与自动报告*)

packageRuntimeFilesAfter = Sort@Flatten[
  FileNames[#, packageRoot, Infinity] & /@ sourceRuntimePatterns
];
ordinaryBackend = Lookup[ordinaryResult, "flintNDE", <||>];
singularBackend = Lookup[singularResult, "flintNDE", <||>];
ordinaryRefinementDifference = Lookup[ordinaryBackend, "relativeDifferenceInf", Missing["Unavailable"]];
singularOrdinaryBackend = Lookup[singularBackend, "ordinaryTransport", <||>];
singularExpectedFinal = analyticValueAt[1]/analyticValueAt[0];
singularFinalValue = If[
  Lookup[singularResult, "status", None] === "computed",
  First[singularResult["values"]],
  Indeterminate
];

checks = <|
  "contextAndNormalization" -> MSContextQ[context] && context["rootNormalization"] === 1,
  "boundaryGeneratedWithoutDirectFallback" -> Lookup[boundary, "status", None] === "generated" &&
    Lookup[boundary, "directIntegrationFallbackQ", False] === False,
  "invalidNamedSaveRejectedBeforePython" -> Head[invalidSaveResult] === Failure &&
    invalidSaveResult[[1]] === "FlintNDESavePointFormat" && jsonAfterInvalid === jsonBeforeInvalid,
  "ordinaryTransportComputed" -> Lookup[ordinaryResult, "status", None] === "computed",
  "ordinaryThreeSavedPoints" -> Lookup[ordinaryAggregate, "pointCount", 0] === 3 &&
    Lookup[ordinaryPoints, "resultType"] === ConstantArray["ordinary_vector", 3],
  "ordinarySavedPointFilesExist" -> And @@ (FileExistsQ /@ Lookup[ordinaryPoints, "sourceFile", {}]),
  "ordinaryAnalyticAgreement" -> Length[ordinaryResiduals] === 3 && Max[ordinaryResiduals] < 10^-18,
  "ordinaryFinalMatchesReturn" -> Length[savedOrdinaryValues] === 3 &&
    relativeDifference[Last[savedOrdinaryValues], First[ordinaryResult["values"]]] < 10^-30,
  "ordinaryRefinement" -> TrueQ[Lookup[ordinaryBackend, "targetRelativeErrorMet", False]],
  "regularSingularTransportComputed" -> Lookup[singularResult, "status", None] === "computed",
  "regularSingularClassification" -> Lookup[
    Lookup[singularBackend, "singularLaunch", <||>], "startClassification", <||>
  ]["classification"] === "regular_singular",
  "regularSingularOrdinaryContinuation" -> NumericQ[singularFinalValue] &&
    relativeDifference[singularFinalValue, singularExpectedFinal] < 10^-18 &&
    TrueQ[Lookup[singularOrdinaryBackend, "targetRelativeErrorMet", False]],
  "savedFrobeniusBoundary" -> Lookup[savedFrobeniusPoint, "resultType", None] === "frobenius_boundary" &&
    Lookup[Lookup[savedFrobeniusPoint, "result", <||>], "terms", {}] ===
      {<|"a" -> "2", "b" -> 0, "C" -> {"1"}|>},
  "unsupportedPoleFailsClosed" -> Head[unsupportedResult] === Failure &&
    Lookup[unsupportedBackend, "status", None] === "failed" &&
    StringContainsQ[Lookup[unsupportedBackend, "error", ""], "non_fuchsian_input_basis"],
  "callerDirectoryOwnsSaveOutputs" -> StringStartsQ[
    ExpandFileName[ordinarySaveEvidence["summaryFile"]], ExpandFileName[validationDirectory]
  ] && StringStartsQ[
    ExpandFileName[singularSaveEvidence["summaryFile"]], ExpandFileName[validationDirectory]
  ],
  "packageDirectoryUnchangedByRuntime" -> packageRuntimeFilesAfter === packageRuntimeFilesBefore
|>;

validationPassed = And @@ Values[checks];
elapsedSeconds = N[AbsoluteTime[] - validationStartTime, 10];
sourceFiles = FileNameJoin[{packageRoot, #}] & /@ {
  "Kernel/Numerics/FlintNDE.wl", "Backend/flintnde_transport.py",
  "Kernel/Numerics/Boundary.wl"
};
sourceDigests = AssociationThread[
  StringReplace[#, packageRoot ~~ ("\\" | "/") -> ""] & /@ sourceFiles,
  IntegerString[FileHash[#, "SHA256"], 16, 64] & /@ sourceFiles
];

summary = <|
  "schema" -> "madstree_independent_validation_v1",
  "version" -> "v0.3",
  "task" -> "T6 MadStree-FlintNDE adapter save points and capability boundary",
  "status" -> If[validationPassed, "passed", "failed"],
  "checks" -> checks,
  "passedCount" -> Count[Values[checks], True],
  "checkCount" -> Length[checks],
  "sourceDigests" -> sourceDigests,
  "normalization" -> <|"root" -> 1, "integral" -> "Integral[(-tau)^a Exp[I k0 tau]]"|>,
  "targetRules" -> targetRules,
  "anchorRules" -> anchorRules,
  "ordinaryPathRules" -> Lookup[ordinaryResult, "pathRules", Missing["Unavailable"]],
  "ordinaryAdaptivePath" -> Lookup[ordinaryBackend, "path", Missing["Unavailable"]],
  "ordinarySaveInput" -> ordinarySaveInput,
  "ordinarySavedPoints" -> ordinaryPoints,
  "ordinaryPhysicalK0" -> (physicalK0At /@ ordinaryCoordinates),
  "ordinaryResiduals" -> ordinaryResiduals,
  "ordinaryRefinementDifference" -> ordinaryRefinementDifference,
  "singularSystem" -> HoldForm[{{2/t}}],
  "singularBoundary" -> HoldForm[{a -> 2, b -> 0, C -> {1}}],
  "singularOrdinaryAnchorRules" -> anchorRules,
  "singularOrdinaryTargetRules" -> targetRules,
  "singularExpectedFinal" -> singularExpectedFinal,
  "singularFinalValue" -> singularFinalValue,
  "singularSavedPoints" -> singularSavedPoints,
  "unsupportedClassificationEvidence" -> unsupportedBackend,
  "boundarySeriesOrder" -> Lookup[boundary, "seriesOrder", Missing["NotReported"]],
  "singularTransportOrder" -> {transportOrder, referenceTransportOrder},
  "ordinaryTransportOrder" -> {transportOrder, referenceTransportOrder},
  "workingPrecision" -> workingPrecision,
  "targetRelativeError" -> targetRelativeError,
  "boundarySeconds" -> boundarySeconds,
  "ordinarySeconds" -> ordinarySeconds,
  "singularSeconds" -> singularSeconds,
  "failClosedSeconds" -> failClosedSeconds,
  "elapsedSeconds" -> elapsedSeconds,
  "ordinarySaveSummary" -> Lookup[ordinarySaveEvidence, "summaryFile", Missing["Unavailable"]],
  "singularSaveSummary" -> Lookup[singularSaveEvidence, "summaryFile", Missing["Unavailable"]],
  "runtimeDirectory" -> validationDirectory
|>;
writeValidationExpression[summaryFile, summary];

reportLines = Join[
  {
    "# MadStree v0.3 independent validation report: T6 FlintNDE adapter",
    "",
    "> Generated automatically by `run_validation.wls`.",
    "",
    "## Status",
    "",
    "- status: `" <> summary["status"] <> "`",
    "- checks: `" <> ToString[summary["passedCount"]] <> "/" <> ToString[summary["checkCount"]] <> "`",
    "- version: `MadStree-v0.3`",
    "",
    "## Scope, point and normalization",
    "",
    "- ordinary family: `Integral[(-tau)^a Exp[I k0 tau], tau=-Infinity..0]`, normalization `1`",
    "- target: `" <> ToString[targetRules, InputForm] <> "`; anchor: `" <> ToString[anchorRules, InputForm] <> "`",
    "- ordinary save input: `" <> ToString[ordinarySaveInput, InputForm] <> "` (no point names)",
    "- physical k0 at saved points: `" <> ToString[summary["ordinaryPhysicalK0"], InputForm] <> "`",
    "- regular-singular probe: `A(t)=2/t`, `{a,b,C}={2,0,{1}}`, weight `1`",
    "- post-singular ordinary segment: `" <> ToString[anchorRules, InputForm] <> "` to `" <>
      ToString[targetRules, InputForm] <> "`",
    "- unsupported probe: `A(t)=2/t^2`",
    "",
    "## Actual paths, orders and precision",
    "",
    "- affine physical path: `" <> ToString[summary["ordinaryPathRules"], InputForm] <> "`",
    "- FlintNDE adaptive path: `" <> ToString[summary["ordinaryAdaptivePath"], InputForm] <> "`",
    "- ordinary and singular orders: `" <>
      ToString[{transportOrder, referenceTransportOrder}] <> "`",
    "- working precision: `" <> ToString[workingPrecision] <> "`; target relative error: `" <> targetRelativeError <> "`",
    "- boundary series order: `" <> ToString[summary["boundarySeriesOrder"], InputForm] <> "`",
    "",
    "## Timing",
    "",
    "- boundary generation: `" <> formatSeconds[boundarySeconds] <> " s`",
    "- ordinary save-point transport: `" <> formatSeconds[ordinarySeconds] <> " s`",
    "- regular-singular transport: `" <> formatSeconds[singularSeconds] <> " s`",
    "- unsupported-pole preflight: `" <> formatSeconds[failClosedSeconds] <> " s`",
    "- total wall time: `" <> formatSeconds[elapsedSeconds] <> " s`",
    "",
    "## Checks",
    ""
  },
  KeyValueMap["- `" <> #1 <> "`: " <> If[TrueQ[#2], "PASS", "FAIL"] &, checks],
  {
    "",
    "## Numerical and file evidence",
    "",
    "- ordinary saved-point relative residuals: `" <> ToString[ordinaryResiduals, InputForm] <> "`",
    "- ordinary primary/reference relative difference: `" <>
      ToString[ordinaryRefinementDifference, InputForm] <> "`",
    "- singular-to-ordinary final/expected: `" <> ToString[
      {singularFinalValue, singularExpectedFinal}, InputForm
    ] <> "`",
    "- ordinary aggregate: `" <> ToString[summary["ordinarySaveSummary"], InputForm] <> "`",
    "- singular aggregate: `" <> ToString[summary["singularSaveSummary"], InputForm] <> "`",
    "- unsupported backend error: `" <> Lookup[unsupportedBackend, "error", "missing"] <> "`",
    "- machine-readable validation summary: `results/summary.wl`",
    "- adapter JSON and Python cache: `results_temp/` in this validation directory."
  }
];
writeValidationText[reportFile, StringRiffle[reportLines, "\n"] <> "\n"];

Print["MadStree T6 checks: ", summary["passedCount"], "/", summary["checkCount"]];
KeyValueMap[Print[#1, ": ", #2] &, checks];
Print["ordinary residuals: ", InputForm[ordinaryResiduals]];
If[! validationPassed, Exit[1]];
