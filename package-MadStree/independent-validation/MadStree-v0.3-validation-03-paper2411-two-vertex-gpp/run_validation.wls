(* ::Package:: *)

$CharacterEncoding = "UTF-8";

(***
文件：run_validation.wls
用途：独立验证 2411.03088 Sec. 4 两顶点单 massive G++ 的五维 dlog、Frobenius 边界与数值输运。
路线：测试内独立编码 Eqs. (3.3)、(4.4)、(4.5)、(4.11)--(4.14)，与 MadStree 生产边界分别调用 FlintNDE。
输出：自动生成机器可读 summary 和目录首项 000_MadStree-v0.3-validation-03-report.md。
***)

(* ::Chapter:: *)
(*路径、函数族与固定参数*)

validationDirectory = DirectoryName[$InputFileName];
madStreeRoot = DirectoryName[DirectoryName[validationDirectory]];
packageRoot = FileNameJoin[{madStreeRoot, "versions", "MadStree-v0.3"}];
resultsDirectory = FileNameJoin[{validationDirectory, "results"}];
summaryFile = FileNameJoin[{resultsDirectory, "summary.wl"}];
reportFile = FileNameJoin[{validationDirectory, "000_MadStree-v0.3-validation-03-report.md"}];
If[! DirectoryQ[resultsDirectory],
  CreateDirectory[resultsDirectory, CreateIntermediateDirectories -> True]
];
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
  "vertices" -> {
    <|"id" -> v1, "energy" -> k12, "timePower" -> nu0, "phaseSign" -> 1|>,
    <|"id" -> v2, "energy" -> k34, "timePower" -> nu0, "phaseSign" -> 1|>
  },
  "lines" -> {
    <|"id" -> internal, "type" -> "massiveFull", "endpoints" -> {v1, v2},
      "momentum" -> ks, "nu" -> nu1, "skType" -> "++"|>
  }
|>, NuConvention -> "Negative"];

targetRules = {k12 -> -30 I, k34 -> -6 I, ks -> 1, nu0 -> 2, nu1 -> 1/5};
boundaryScale = 4;
boundarySeriesOrder = 20;
workingPrecision = 50;
transportOrder = 56;
referenceTransportOrder = 80;
targetRelativeError = "1e-20";

formatSeconds[value_] := ToString[NumberForm[N[value], {Infinity, 6}], OutputForm];


(* ::Chapter:: *)
(*独立论文 potential 与 leading data*)

paperOmegaOne[k0_, k1_] := {
  {
    -I (nu0 + 1) (-I Log[k0 - k1]/2 - I Log[k0 + k1]/2),
    -I (nu0 - 2 nu1) (Log[k0 + k1]/2 - Log[k0 - k1]/2)
  },
  {
    -I (nu0 + 1) (Log[k0 - k1]/2 - Log[k0 + k1]/2),
    -(2 nu1 + 1) Log[k1] -
      I (nu0 - 2 nu1) (-I Log[k0 - k1]/2 - I Log[k0 + k1]/2)
  }
};


paperTopPotential = KroneckerProduct[paperOmegaOne[k12, ks], IdentityMatrix[2]] +
  KroneckerProduct[IdentityMatrix[2], paperOmegaOne[k34, ks]];

paperContactPotential = {
  I/2 (Log[k12 - ks] - Log[k12 + ks] + Log[k34 - ks] - Log[k34 + ks]),
  1/2 (Log[k12 - ks] + Log[k12 + ks] - Log[k34 - ks] - Log[k34 + ks]),
  1/2 (-Log[k12 - ks] - Log[k12 + ks] + Log[k34 - ks] + Log[k34 + ks]),
  I/2 (Log[k12 - ks] - Log[k12 + ks] + Log[k34 - ks] - Log[k34 + ks])
};

paperChildPotential = (-2 nu0 + 2 nu1 - 1) Log[k12 + k34] +
  (-2 nu1 - 1) Log[ks];

paperPotential = ArrayFlatten[{
  {paperTopPotential, Transpose[{paperContactPotential}]},
  {ConstantArray[0, {1, 4}], {{paperChildPotential}}}
}];

paperC[nu_] := 2^(-nu) Gamma[-nu]/(I Pi);
paperEndpoint[1, 0, nu_] := Exp[-I Pi nu] paperC[nu];
paperEndpoint[1, 1, nu_] := -paperC[-nu - 1];
paperEndpoint[2, 0, nu_] := -Exp[I Pi nu] paperC[nu];
paperEndpoint[2, 1, nu_] := paperC[-nu - 1];


paperVertexCoefficient[branch_Integer, bit_Integer] := Module[
  {power = nu0 /. targetRules, nu = nu1 /. targetRules, momentum = ks /. targetRules},
  (-I)^(power + 1) Gamma[power + 1 - bit (2 nu + 1)]
    (-I momentum)^(-bit (2 nu + 1)) paperEndpoint[branch, bit, nu]
];


topStateOrder = First[context["sectors"]]["stateOrder"];
paperTopCoefficients = Map[
  paperVertexCoefficient[1, First[#]] paperVertexCoefficient[2, Last[#]] &,
  topStateOrder
];
paperTopWeights = Map[
  Function[bits,
    With[
      {lambda = (nu0 + 1 - First[bits] (2 nu1 + 1)) /. targetRules,
       lowWeight = (nu0 + 1 - Last[bits] (2 nu1 + 1)) /. targetRules},
      {lambda, lambda + lowWeight}
    ]
  ],
  topStateOrder
];
paperContactExponent = (2 nu0 - 2 nu1 + 1) /. targetRules;
paperC5 = (-4 I/Pi) * Exp[Pi Im[nu1 /. targetRules]] *
  (ks /. targetRules)^(-2 (nu1 /. targetRules) - 1) *
  Exp[I Pi ((nu1 - nu0) /. targetRules)] *
  Gamma[(2 nu0 - 2 nu1 + 1) /. targetRules];
paperContactVector = {
  0,
  1/((2 nu1 - nu0) /. targetRules),
  1/((nu0 + 1) /. targetRules),
  0,
  1
};


(* ::Chapter:: *)
(*生产边界与独立论文边界*)

{boundarySeconds, productionBoundary} = AbsoluteTiming[MSBoundaryData[
  context,
  targetRules,
  RankOrder -> {v1, v2},
  BoundaryScale -> boundaryScale,
  BoundarySeriesOrder -> boundarySeriesOrder,
  WorkingPrecision -> workingPrecision
]];

anchorRules = Lookup[productionBoundary, "anchorRules", {}];
xAnchor = (k34/k12) /. anchorRules;
yAnchor = (1/k34) /. anchorRules;
singularParameter = Unique["paperT"];
paperCurveRules = {
  k12 -> 1/(xAnchor yAnchor singularParameter^2),
  k34 -> 1/(yAnchor singularParameter)
};
paperSingularConnection = Map[
  Cancel[Together[D[#, singularParameter]]] &,
  paperPotential /. paperCurveRules /.
    DeleteCases[targetRules, Rule[left_, _] /; MemberQ[{k12, k34}, left]],
  {2}
];

paperLeadingBranches = Join[
  MapIndexed[
    Function[{bits, position},
      With[
        {lambda = paperTopWeights[[First[position], 1]],
         mu = paperTopWeights[[First[position], 2]],
         coefficient = paperTopCoefficients[[First[position]]]},
        <|
          "kind" -> "paperHomogeneousProduct",
          "binaryState" -> bits,
          "lambda" -> lambda,
          "mu" -> mu,
          "coefficient" -> coefficient,
          "frobeniusExponent" -> lambda + mu,
          "logPower" -> 0,
          "normalizedLeadingVector" -> UnitVector[5, First[position]],
          "physicalWeight" -> coefficient xAnchor^lambda yAnchor^mu
        |>
      ]
    ],
    topStateOrder
  ],
  {
    <|
      "kind" -> "paperContactParticular",
      "lambda" -> paperContactExponent,
      "mu" -> paperContactExponent,
      "coefficient" -> paperC5,
      "frobeniusExponent" -> 2 paperContactExponent,
      "logPower" -> 0,
      "normalizedLeadingVector" -> paperContactVector,
      "physicalWeight" -> paperC5 xAnchor^paperContactExponent yAnchor^paperContactExponent
    |>
  }
];

paperBoundary = Join[
  KeyTake[productionBoundary, {"status", "masterDigest", "anchorRules", "targetRules"}],
  <|
    "method" -> "independent2411ExactSingularSystem",
    "boundaryKind" -> "singularFrobenius",
    "singularParameter" -> singularParameter,
    "singularConnection" -> paperSingularConnection,
    "singularStart" -> 0,
    "singularTarget" -> 1,
    "leadingBranches" -> paperLeadingBranches
  |>
];


(* ::Chapter:: *)
(*Exact basis、connection 与边界系数检查*)

principalBranchCanonical[expression_] := FullSimplify[
  FunctionExpand[
    expression /. {
      Power[base_Integer?Negative, rational_Rational] :>
        Abs[base]^rational Exp[I Pi rational],
      Power[-I, rational_Rational] :> Exp[-I Pi rational/2],
      Power[I, rational_Rational] :> Exp[I Pi rational/2]
    }
  ]
];


exactZeroQ[expression_] := And @@ (PossibleZeroQ /@ Flatten[expression]);


packageDE = MSDLogDE[context];
connectionResiduals = Table[
  Map[Together, D[packageDE["omegaPotential"] - paperPotential, variable], {2}],
  {variable, {k12, k34, ks}}
];
singularConnectionResidual = Map[
  Together,
  (productionBoundary["singularConnection"] /.
      productionBoundary["singularParameter"] -> singularParameter) - paperSingularConnection,
  {2}
];
productionBranches = Lookup[productionBoundary, "leadingBranches", {}];
productionVectors = Lookup[productionBranches, "normalizedLeadingVector", {}];
paperVectors = Lookup[paperLeadingBranches, "normalizedLeadingVector", {}];
productionCoefficients = Lookup[productionBranches, "coefficient", {}];
paperCoefficients = Lookup[paperLeadingBranches, "coefficient", {}];
coefficientResiduals = principalBranchCanonical /@
  MapThread[#1 - #2 &, {productionCoefficients, paperCoefficients}];
paperIRNormalization = (-(4 I/Pi) Exp[Pi Im[nu1]] ks^(-2 nu1 - 1)) /. targetRules;
childNormalization = Last[context["sectors"]]["normalization"] /. targetRules;


(* ::Chapter:: *)
(*两条独立边界路线的 FlintNDE 输运*)

{productionTransportSeconds, productionTransport} = AbsoluteTiming[MSFlintNDETransport[
  context,
  productionBoundary,
  WorkingPrecision -> workingPrecision,
  TransportOrder -> transportOrder,
  ReferenceTransportOrder -> referenceTransportOrder,
  TargetRelativeError -> targetRelativeError,
  MSRuntimeDirectory -> validationDirectory
]];

{paperTransportSeconds, paperTransport} = AbsoluteTiming[MSFlintNDETransport[
  context,
  paperBoundary,
  WorkingPrecision -> workingPrecision,
  TransportOrder -> transportOrder,
  ReferenceTransportOrder -> referenceTransportOrder,
  TargetRelativeError -> targetRelativeError,
  MSRuntimeDirectory -> validationDirectory
]];


(* ::Chapter:: *)
(*比较、summary 与自动报告*)

relativeDifference[left_List, right_List] := Max@MapThread[
  Abs[#1 - #2]/Max[Abs[#2], 10^-40] &,
  {left, right}
];


productionComputedQ = Lookup[productionTransport, "status", None] === "computed";
paperComputedQ = Lookup[paperTransport, "status", None] === "computed";
targetDifference = If[productionComputedQ && paperComputedQ,
  relativeDifference[productionTransport["values"], paperTransport["values"]],
  Missing["Unavailable"]
];
contactTargetDifference = If[productionComputedQ && paperComputedQ,
  Abs[Last[productionTransport["values"]] - Last[paperTransport["values"]]]/
    Max[Abs[Last[paperTransport["values"]]], 10^-40],
  Missing["Unavailable"]
];
productionBackend = Lookup[productionTransport, "flintNDE", <||>];
paperBackend = Lookup[paperTransport, "flintNDE", <||>];
productionRefinementQ = TrueQ[Lookup[productionBackend, "targetRelativeErrorMet", False]];
paperRefinementQ = TrueQ[Lookup[paperBackend, "targetRelativeErrorMet", False]];

checks = <|
  "negativeConvention" -> context["convention", "nuConvention"] === "Negative",
  "fiveMastersInPaperOrder" -> Lookup[context["masters"], "stateBits"] === {{0, 0}, {0, 1}, {1, 0}, {1, 1}, {}},
  "paperIRNormalization" -> TrueQ[principalBranchCanonical[childNormalization - paperIRNormalization] === 0],
  "boundaryGenerated" -> Lookup[productionBoundary, "status", None] === "generated",
  "paperBoundaryNoDirectFallback" -> Lookup[productionBoundary, "directIntegrationFallbackQ", True] === False,
  "thetaRank" -> Lookup[productionBoundary, "thetaFixing", {}] === {1, 2},
  "dlogConnection" -> exactZeroQ[connectionResiduals],
  "singularConnection" -> exactZeroQ[singularConnectionResidual],
  "identityBasisMap" -> productionVectors === paperVectors,
  "fiveBoundaryCoefficients" -> exactZeroQ[coefficientResiduals],
  "homogeneousFactorization" -> exactZeroQ[Take[coefficientResiduals, 4]],
  "contactLeadingVector" -> Last[productionVectors] === paperContactVector,
  "productionTransport" -> productionComputedQ,
  "paperTransport" -> paperComputedQ,
  "fullTargetVector" -> NumericQ[targetDifference] && TrueQ[targetDifference < 10^-18],
  "contactTargetComponent" -> NumericQ[contactTargetDifference] && TrueQ[contactTargetDifference < 10^-18],
  "productionRefinement" -> productionRefinementQ,
  "paperRefinement" -> paperRefinementQ
|>;

validationPassed = And @@ Values[checks];
validationSeconds = N[AbsoluteTime[] - validationStartTime, 10];
productionOrdinary = Lookup[productionBackend, "ordinaryTransport", <||>];
productionSingular = Lookup[productionBackend, "singularLaunch", <||>];
paperOrdinary = Lookup[paperBackend, "ordinaryTransport", <||>];
paperSingular = Lookup[paperBackend, "singularLaunch", <||>];
sourceFiles = FileNameJoin[{packageRoot, #}] & /@ {
  "Kernel/Core/Topology.wl", "Kernel/DE/DLog.wl", "Kernel/Numerics/Boundary.wl"
};
sourceDigests = AssociationThread[
  FileNameTake /@ sourceFiles,
  (IntegerString[FileHash[#, "SHA256"], 16, 64] & /@ sourceFiles)
];

summary = <|
  "schema" -> "madstree_independent_validation_v1",
  "version" -> "v0.3",
  "task" -> "T3 paper2411 two vertex G++",
  "status" -> If[validationPassed, "passed", "failed"],
  "checks" -> checks,
  "passedCount" -> Count[Values[checks], True],
  "checkCount" -> Length[checks],
  "masterDigest" -> context["masterDigest"],
  "sourceDigests" -> sourceDigests,
  "targetRules" -> targetRules,
  "anchorRules" -> anchorRules,
  "blowupChart" -> <|"x" -> k34/k12, "y" -> 1/k34, "curveRules" -> paperCurveRules|>,
  "paperIRNormalization" -> paperIRNormalization,
  "packageChildNormalization" -> childNormalization,
  "basisMapPaperToPackage" -> IdentityMatrix[5],
  "boundarySeriesOrder" -> boundarySeriesOrder,
  "transportOrder" -> transportOrder,
  "referenceTransportOrder" -> referenceTransportOrder,
  "workingPrecision" -> workingPrecision,
  "targetRelativeError" -> targetRelativeError,
  "connectionResidual" -> connectionResiduals,
  "singularConnectionResidual" -> singularConnectionResidual,
  "coefficientResiduals" -> coefficientResiduals,
  "targetRelativeDifference" -> targetDifference,
  "contactTargetRelativeDifference" -> contactTargetDifference,
  "productionOrdinaryPath" -> Lookup[productionOrdinary, "path", Missing["Unavailable"]],
  "paperOrdinaryPath" -> Lookup[paperOrdinary, "path", Missing["Unavailable"]],
  "productionSingularClassification" -> Lookup[productionSingular, "classification", Missing["Unavailable"]],
  "paperSingularClassification" -> Lookup[paperSingular, "classification", Missing["Unavailable"]],
  "boundarySeconds" -> boundarySeconds,
  "productionTransportSeconds" -> productionTransportSeconds,
  "paperTransportSeconds" -> paperTransportSeconds,
  "productionPrimarySeconds" -> Lookup[productionOrdinary, "primarySeconds", Missing["Unavailable"]],
  "productionReferenceSeconds" -> Lookup[productionOrdinary, "referenceSeconds", Missing["Unavailable"]],
  "paperPrimarySeconds" -> Lookup[paperOrdinary, "primarySeconds", Missing["Unavailable"]],
  "paperReferenceSeconds" -> Lookup[paperOrdinary, "referenceSeconds", Missing["Unavailable"]],
  "elapsedSeconds" -> validationSeconds,
  "runtimeDirectory" -> Lookup[productionTransport, "runtimeDirectory", Missing["Unavailable"]]
|>;
writeValidationExpression[summaryFile, summary];

reportLines = Join[
  {
    "# MadStree v0.3 independent validation report: T3 two-vertex G++",
    "",
    "> Generated automatically by `run_validation.wls`.",
    "",
    "## Status",
    "",
    "- status: `" <> summary["status"] <> "`",
    "- checks: `" <> ToString[summary["passedCount"]] <> "/" <> ToString[summary["checkCount"]] <> "`",
    "- version: `MadStree-v0.3`",
    "- master digest: `" <> summary["masterDigest"] <> "`",
    "- explicit convention: `NuConvention -> \"Negative\"`",
    "",
    "## Scope, basis and normalization",
    "",
    "The independent route encodes 2411.03088 Eqs. (3.3), (4.4), (4.5), and (4.11)-(4.14). The production route uses MadStree's topology, dlog, nested blow-up and boundary producer. Both use the paper order `{I00,I01,I10,I11,IR}` and the exact identity basis map.",
    "",
    "- top normalization: `1`",
    "- child normalization Eq. (4.2): `" <> ToString[paperIRNormalization, InputForm] <> "`",
    "- package child normalization: `" <> ToString[childNormalization, InputForm] <> "`",
    "",
    "## Numerical point, chart and path",
    "",
    "- target: `" <> ToString[targetRules, InputForm] <> "`",
    "- anchor: `" <> ToString[anchorRules, InputForm] <> "`",
    "- blow-up chart: `x=k34/k12`, `y=1/k34`; anchor `{x,y}=" <>
      ToString[{xAnchor, yAnchor}, InputForm] <> "`",
    "- singular path: `t:0->1` with `" <> ToString[paperCurveRules, InputForm] <> "`",
    "- production ordinary adaptive path in `s`: `" <>
      ToString[summary["productionOrdinaryPath"], InputForm] <> "`",
    "- paper ordinary adaptive path in `s`: `" <>
      ToString[summary["paperOrdinaryPath"], InputForm] <> "`",
    "",
    "## Orders, precision and timing",
    "",
    "- boundary metadata order: `" <> ToString[boundarySeriesOrder] <> "`",
    "- Frobenius/ordinary transport order: `" <> ToString[transportOrder] <> "`; reference: `" <>
      ToString[referenceTransportOrder] <> "`",
    "- working precision: `" <> ToString[workingPrecision] <> "`; target relative error: `" <>
      targetRelativeError <> "`",
    "- boundary generation wall time: `" <> formatSeconds[boundarySeconds] <> " s`",
    "- production transport wall time: `" <> formatSeconds[productionTransportSeconds] <> " s`",
    "- independent paper transport wall time: `" <> formatSeconds[paperTransportSeconds] <> " s`",
    "- total wall time: `" <> formatSeconds[validationSeconds] <> " s`",
    "",
    "## Checks",
    ""
  },
  KeyValueMap["- `" <> #1 <> "`: " <> If[TrueQ[#2], "PASS", "FAIL"] &, checks],
  {
    "",
    "## Numerical evidence",
    "",
    "- full target-vector relative difference: `" <> ToString[targetDifference, InputForm] <> "`",
    "- contact-component relative difference: `" <> ToString[contactTargetDifference, InputForm] <> "`",
    "- all multivariate and singular-curve connection residuals are exact zero: `" <>
      ToString[TrueQ[checks["dlogConnection"] && checks["singularConnection"]]] <> "`",
    "- all five principal-branch coefficient residuals are exact zero: `" <>
      ToString[checks["fiveBoundaryCoefficients"]] <> "`",
    "",
    "## Outputs",
    "",
    "- machine-readable summary: `results/summary.wl`",
    "- runtime JSON and Python cache: `results_temp/` in this validation directory",
    "- no finite-point defining integral was used as production boundary or as the paper expected value."
  }
];
writeValidationText[reportFile, StringRiffle[reportLines, "\n"] <> "\n"];

Print["MadStree T3 paper-2411 two-vertex G++ checks: ", summary["passedCount"], "/", summary["checkCount"]];
KeyValueMap[Print[#1, ": ", #2] &, checks];
Print["target relative difference: ", targetDifference];
Print["contact target relative difference: ", contactTargetDifference];

If[! validationPassed,
  Print["productionBoundary: ", InputForm[productionBoundary]];
  Print["productionTransport: ", InputForm[productionTransport]];
  Print["paperTransport: ", InputForm[paperTransport]];
  Exit[1]
];
