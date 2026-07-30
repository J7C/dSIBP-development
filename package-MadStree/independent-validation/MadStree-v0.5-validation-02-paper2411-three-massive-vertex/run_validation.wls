(* ::Package:: *)

$CharacterEncoding = "UTF-8";

(***
文件：run_validation.wls
用途：独立验证 2411.03088 Eqs. (3.44)-(3.46) 的三 massive 单顶点边界与数值输运。
路线：测试内独立级数、MadStree 生产 Frobenius producer、测试专用定义积分三者分离。
输出：保存机器可读 summary，并自动生成目录首项 `000_MadStree-v0.5-validation-02-report.md`。
***)

(* ::Chapter:: *)
(*路径、程序包与参数*)

validationDirectory = DirectoryName[$InputFileName];
madStreeRoot = DirectoryName[DirectoryName[validationDirectory]];
packageRoot = FileNameJoin[{madStreeRoot, "versions", "MadStree-v0.5"}];
resultsDirectory = FileNameJoin[{validationDirectory, "results"}];
summaryFile = FileNameJoin[{resultsDirectory, "summary.wl"}];
reportFile = FileNameJoin[{validationDirectory, "000_MadStree-v0.5-validation-02-report.md"}];
If[! DirectoryQ[resultsDirectory],
  CreateDirectory[resultsDirectory, CreateIntermediateDirectories -> True]
];
AppendTo[$Path, FileNameJoin[{packageRoot, "Kernel"}]];
Needs["MadStree`"];
Get[FileNameJoin[{validationDirectory, "DirectBoundaryOracle.wl"}]];
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

context = MSInitVertexFamily[
  <|
    "ki" -> {k0, k1, k2, k3},
    "nui" -> {nu0, nu1, nu2, nu3},
    "hankelBranches" -> {2, 2, 2}
  |>,
  NuConvention -> "Negative"
];

targetRules = {
  k0 -> -12 I,
  k1 -> 1,
  k2 -> 2,
  k3 -> 1,
  nu0 -> 31/5,
  nu1 -> 1/5,
  nu2 -> 2/7,
  nu3 -> 1/4
};

seriesOrder = 28;
workingPrecision = 60;
boundaryScale = 6;
transportWorkingPrecision = 50;
transportOrder = 72;
referenceTransportOrder = 96;


(* ::Chapter:: *)
(*独立实现 2411 Eqs. (3.44)-(3.46)*)

paperC[nu_] := 2^(-nu) Gamma[-nu]/(I Pi);
paperEndpoint[0, nu_] := -Exp[I Pi nu] paperC[nu];
paperEndpoint[1, nu_] := paperC[-nu - 1];


paperIndices[count_Integer, order_Integer] := Select[
  Tuples[Range[0, order], count],
  Total[#] <= order &
];


paperFTilde4[aOne_, aTwo_, bList_List, zList_List, order_Integer] := Total@Map[
  Function[index,
    Pochhammer[aOne, Total[index]] Pochhammer[aTwo, Total[index]] Times @@ MapThread[
      #2^#1/(Pochhammer[#3, #1] #1!) &,
      {index, zList, bList}
    ]
  ],
  paperIndices[Length[bList], order]
];


paperSolutionComponent[aBits_List, bBits_List, k0Value_, order_Integer] := Module[
  {nuZero = nu0 /. targetRules, nuList = {nu1, nu2, nu3} /. targetRules,
   momenta = {k1, k2, k3} /. targetRules, difference, distance, aTilde, bTilde,
   bParameters, x = 1/k0Value, coefficient, prefactor},
  difference = Abs[aBits - bBits];
  distance = Total[difference];
  aTilde = nuZero + 1 - Total[bBits (2 nuList + 1)];
  bTilde = nuList + 1 - bBits (2 nuList + 1);
  bParameters = bTilde + difference;
  coefficient = (-I)^(nuZero + 1) Gamma[aTilde] Times @@ MapThread[
    (-I #1)^(-#2 (2 #3 + 1)) paperEndpoint[#2, #3] &,
    {momenta, bBits, nuList}
  ];
  prefactor = x^aTilde Pochhammer[aTilde, distance]/2^distance Times @@ MapThread[
    If[#1 === 0, 1, (-1)^#2 I #3 x/#4] &,
    {difference, bBits, momenta, bTilde}
  ];
  coefficient prefactor paperFTilde4[
    (aTilde + distance)/2,
    (aTilde + distance + 1)/2,
    bParameters,
    momenta^2 x^2,
    order
  ]
];


paperVector[k0Value_, order_Integer] := Module[
  {stateOrder = First[context["sectors"]]["stateOrder"], branchOrder = Tuples[{0, 1}, 3]},
  N[
    Function[aBits,
      Total[paperSolutionComponent[aBits, #, k0Value, order] & /@ branchOrder]
    ] /@ stateOrder,
    workingPrecision
  ]
];


paperLeadingCoefficients := Module[
  {nuZero = nu0 /. targetRules, nuList = {nu1, nu2, nu3} /. targetRules,
   momenta = {k1, k2, k3} /. targetRules},
  Map[
    Function[bBits,
      (-I)^(nuZero + 1) Gamma[nuZero + 1 - Total[bBits (2 nuList + 1)]] Times @@ MapThread[
        (-I #1)^(-#2 (2 #3 + 1)) paperEndpoint[#2, #3] &,
        {momenta, bBits, nuList}
      ]
    ],
    Tuples[{0, 1}, 3]
  ]
];


(* ::Chapter:: *)
(*生产边界、定义积分 oracle 与 FlintNDE*)

{boundarySeconds, boundary} = AbsoluteTiming[MSBoundaryData[
  context,
  targetRules,
  BoundaryScale -> boundaryScale,
  BoundarySeriesOrder -> seriesOrder,
  WorkingPrecision -> workingPrecision
]];

anchorRules = Lookup[boundary, "anchorRules", {}];
anchorK0 = k0 /. anchorRules;
paperAtAnchor = paperVector[anchorK0, seriesOrder];
paperAtTarget = paperVector[k0 /. targetRules, seriesOrder];

{directOracleSeconds, directAtAnchor} = AbsoluteTiming[
 MadStreeTest`DirectBoundaryOracle`MSDirectBoundaryOracle[
  context,
  anchorRules,
  WorkingPrecision -> transportWorkingPrecision,
  AccuracyGoal -> 32,
  PrecisionGoal -> 32,
  MaxRecursion -> 16
]];

{transportSeconds, transported} = AbsoluteTiming[MSEvaluateVertexFamily[
  context,
  targetRules,
  BoundaryScale -> boundaryScale,
  BoundarySeriesOrder -> seriesOrder,
  WorkingPrecision -> transportWorkingPrecision,
  TransportOrder -> transportOrder,
  ReferenceTransportOrder -> referenceTransportOrder,
  TargetRelativeError -> "1e-20",
  MSRuntimeDirectory -> validationDirectory
]];
transportData = If[AssociationQ[transported], transported, <||>];


(* ::Chapter:: *)
(*比较与退出状态*)

relativeDifference[left_List, right_List] := Max@MapThread[
  Abs[#1 - #2]/Max[Abs[#2], 10^-40] &,
  {left, right}
];

actualLeading = Lookup[Lookup[boundary, "leadingBranches", {}], "coefficient", {}];
checks = <|
  "negativeConvention" -> context["convention", "nuConvention"] === "Negative",
  "eightMasters" -> Length[context["masters"]] === 8,
  "boundaryGenerated" -> Lookup[boundary, "status", None] === "generated",
  "paperAuthority" -> Lookup[boundary, "method", None] === "2411VertexFrobeniusSeries",
  "noDirectFallback" -> Lookup[boundary, "directIntegrationFallbackQ", True] === False,
  "masterDigest" -> Lookup[boundary, "masterDigest", None] === context["masterDigest"],
  "leadingCoefficients" -> And @@ MapThread[TrueQ[FullSimplify[#1 - #2] === 0] &, {actualLeading, paperLeadingCoefficients}],
  "independentSeriesAtAnchor" -> TrueQ[relativeDifference[boundary["values"], paperAtAnchor] < 10^-35],
  "directOracleAtAnchor" -> Lookup[directAtAnchor, "status", None] === "computed" &&
    TrueQ[relativeDifference[boundary["values"], directAtAnchor["values"]] < 10^-24],
  "transportComputed" -> Lookup[transportData, "status", None] === "computed",
  "transportVsPaper" -> Lookup[transportData, "status", None] === "computed" &&
    TrueQ[relativeDifference[transportData["values"], paperAtTarget] < 10^-18],
  "refinement" -> Lookup[transportData, "status", None] === "computed" &&
    TrueQ[transportData["flintNDE", "targetRelativeErrorMet"]]
|>;

Print["MadStree T2 paper-2411 three-massive checks: ", Count[Values[checks], True], "/", Length[checks]];
KeyValueMap[Print[#1, ": ", #2] &, checks];
If[ListQ[Lookup[boundary, "values", None]],
  Print["series-anchor relative difference: ", relativeDifference[boundary["values"], paperAtAnchor]]
];
If[Lookup[directAtAnchor, "status", None] === "computed",
  Print["direct-anchor relative difference: ", relativeDifference[boundary["values"], directAtAnchor["values"]]]
];
If[Lookup[transportData, "status", None] === "computed",
  Print["target relative difference: ", relativeDifference[transportData["values"], paperAtTarget]]
];

seriesAnchorDifference = If[ListQ[Lookup[boundary, "values", None]],
  relativeDifference[boundary["values"], paperAtAnchor], Missing["Unavailable"]
];
directAnchorDifference = If[Lookup[directAtAnchor, "status", None] === "computed",
  relativeDifference[boundary["values"], directAtAnchor["values"]], Missing["Unavailable"]
];
targetDifference = If[Lookup[transportData, "status", None] === "computed",
  relativeDifference[transportData["values"], paperAtTarget], Missing["Unavailable"]
];
validationPassed = And @@ Values[checks];
validationSeconds = N[AbsoluteTime[] - validationStartTime, 10];
validationSecondsText = ToString[NumberForm[validationSeconds, {Infinity, 3}], OutputForm];
flintNDEData = Lookup[transportData, "flintNDE", <||>];
transportPath = Lookup[flintNDEData, "path", Missing["Unavailable"]];
transportPathPointCount = Lookup[flintNDEData, "pathPointCount", Missing["Unavailable"]];
transportPrimarySeconds = Lookup[flintNDEData, "primarySeconds", Missing["Unavailable"]];
transportReferenceSeconds = Lookup[flintNDEData, "referenceSeconds", Missing["Unavailable"]];

summary = <|
  "schema" -> "madstree_independent_validation_v1",
  "version" -> "v0.5",
  "task" -> "T2 paper2411 three massive vertex",
  "status" -> If[validationPassed, "passed", "failed"],
  "checks" -> checks,
  "passedCount" -> Count[Values[checks], True],
  "checkCount" -> Length[checks],
  "seriesAnchorRelativeDifference" -> seriesAnchorDifference,
  "directAnchorRelativeDifference" -> directAnchorDifference,
  "targetRelativeDifference" -> targetDifference,
  "workingPrecision" -> workingPrecision,
  "transportWorkingPrecision" -> transportWorkingPrecision,
  "seriesOrder" -> seriesOrder,
  "transportOrder" -> transportOrder,
  "referenceTransportOrder" -> referenceTransportOrder,
  "targetRules" -> targetRules,
  "anchorRules" -> anchorRules,
  "pathRules" -> Lookup[transportData, "pathRules", Missing["Unavailable"]],
  "adaptivePath" -> transportPath,
  "adaptivePathPointCount" -> transportPathPointCount,
  "boundarySeconds" -> boundarySeconds,
  "directOracleSeconds" -> directOracleSeconds,
  "transportSeconds" -> transportSeconds,
  "transportPrimarySeconds" -> transportPrimarySeconds,
  "transportReferenceSeconds" -> transportReferenceSeconds,
  "elapsedSeconds" -> validationSeconds,
  "masterDigest" -> Lookup[boundary, "masterDigest", Missing["Unavailable"]],
  "runtimeDirectory" -> Lookup[transportData, "runtimeDirectory", Missing["Unavailable"]]
|>;
writeValidationExpression[summaryFile, summary];

reportLines = Join[
  {
    "# MadStree v0.5 independent validation report: T2 one vertex with three massive blocks",
    "",
    "> Generated automatically by `run_validation.wls`.",
    "",
    "## Status",
    "",
    "- status: `" <> summary["status"] <> "`",
    "- checks: `" <> ToString[summary["passedCount"]] <> "/" <> ToString[summary["checkCount"]] <> "`",
    "- version: `MadStree-v0.5`",
    "- explicit convention: `NuConvention -> \"Negative\"`",
    "",
    "## Scope and method",
    "",
    "Validate the eight leading coefficients of 2411.03088 Eqs. (3.44)-(3.46), an independent order-28 multivariate series, the MadStree production Frobenius boundary, a validation-only direct integral oracle, and FlintNDE transport. All routes use the same exact parameters, Hankel branches, normalization, and master order.",
    "",
    "## Numerical point and orders",
    "",
    "- `k0=-12 I, k1=1, k2=2, k3=1`",
    "- `nu0=31/5, nu1=1/5, nu2=2/7, nu3=1/4`",
    "- `seriesOrder=28`, `workingPrecision=60`, `transportWorkingPrecision=50`",
    "- `TransportOrder=72`, `ReferenceTransportOrder=96`",
    "",
    "## Actual boundary and transport path",
    "",
    "- Frobenius boundary: `k0 -> -I Infinity`; truncated evaluation at anchor `" <>
      ToString[anchorRules, InputForm] <> "`",
    "- affine coordinate path from anchor to target: `" <>
      ToString[Lookup[transportData, "pathRules", Missing["Unavailable"]], InputForm] <> "`",
    "- FlintNDE adaptive path points in `s`: `" <> ToString[transportPath, InputForm] <> "`",
    "- adaptive path point count: `" <> ToString[transportPathPointCount, InputForm] <> "`",
    "",
    "## Checks",
    ""
  },
  KeyValueMap["- `" <> #1 <> "`: " <> If[TrueQ[#2], "PASS", "FAIL"] &, checks],
  {
    "",
    "## Numerical evidence",
    "",
    "- production/independent series at anchor: `" <> ToString[seriesAnchorDifference, InputForm] <> "`",
    "- direct oracle/production at anchor: `" <> ToString[directAnchorDifference, InputForm] <> "`",
    "- FlintNDE/independent series at target: `" <> ToString[targetDifference, InputForm] <> "`",
    "- boundary generation wall time in seconds: `" <> ToString[boundarySeconds, InputForm] <> "`",
    "- direct oracle wall time in seconds: `" <> ToString[directOracleSeconds, InputForm] <> "`",
    "- MadStree/FlintNDE transport wall time in seconds: `" <> ToString[transportSeconds, InputForm] <> "`",
    "- FlintNDE primary/reference transport time in seconds: `" <>
      ToString[{transportPrimarySeconds, transportReferenceSeconds}, InputForm] <> "`",
    "- total wall time in seconds: `" <> validationSecondsText <> "`",
    "",
    "## Outputs",
    "",
    "- machine-readable summary: `results/summary.wl`",
    "- runtime intermediates and Python cache: `results_temp/`",
    "- production code did not call direct integration; `DirectBoundaryOracle.wl` belongs only to this validation directory."
  }
];
writeValidationText[reportFile, StringRiffle[reportLines, "\n"] <> "\n"];

If[! validationPassed,
  Print["boundary: ", InputForm[boundary]];
  Print["directAtAnchor: ", InputForm[directAtAnchor]];
  Print["transported: ", InputForm[transported]];
  Exit[1]
];
