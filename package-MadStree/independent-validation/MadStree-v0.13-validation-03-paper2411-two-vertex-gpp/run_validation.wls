(* ::Package:: *)

(***
文件：run_validation.wls
用途：独立验证 MadStree v0.13 的论文两顶点 massive G++ 五维 DE、绝对边界与收敛域普通点值。
来源：2411.03088 Sec. 4；论文 exact DE 与级数 oracle 均在加载 MadStree 前冻结。
边界：只运行本 targeted case；不读取 dSIBP，不运行其它 validation 或全量回归。
输出：自动生成 results/summary.wl 与目录首项 000_...report.md，结束时清理 results_temp。
***)

(* ::Chapter:: *)
(*路径、清理与独立论文 oracle*)

$CharacterEncoding = "UTF-8";
validationDirectory = DirectoryName[$InputFileName];
madStreeRoot = DirectoryName[DirectoryName[validationDirectory]];
repositoryRoot = DirectoryName[madStreeRoot];
packageRoot = FileNameJoin[{madStreeRoot, "versions", "MadStree-v0.13"}];
taskDirectory = FileNameJoin[{madStreeRoot, "independent-validation-task"}];
resultsDirectory = FileNameJoin[{validationDirectory, "results"}];
runtimeDirectory = FileNameJoin[{validationDirectory, "results_temp"}];
summaryFile = FileNameJoin[{resultsDirectory, "summary.wl"}];
reportFile = FileNameJoin[{validationDirectory,
  "000_MadStree-v0.13-validation-03-paper2411-two-vertex-gpp-report.md"}];

Scan[If[DirectoryQ[#], DeleteDirectory[#, DeleteContents -> True]] &,
  {resultsDirectory, runtimeDirectory}];
If[FileExistsQ[reportFile], DeleteFile[reportFile]];
CreateDirectory[resultsDirectory, CreateIntermediateDirectories -> True];
CreateDirectory[runtimeDirectory, CreateIntermediateDirectories -> True];
validationStart = AbsoluteTime[];

deOracleFile = FileNameJoin[{taskDirectory, "paper2411_two_vertex_gpp_de.wl"}];
solutionOracleFile = FileNameJoin[{taskDirectory, "paper2411_two_vertex_gpp_solution.wl"}];
deOracleHash = IntegerString[FileHash[deOracleFile, "SHA256"], 16, 64];
solutionOracleHash = IntegerString[FileHash[solutionOracleFile, "SHA256"], 16, 64];
paperFile = FileNameJoin[{repositoryRoot, "reference", "ref_paper",
  "2411.03088_Multivariate hypergeometric solutions of cosmological (dS) correlators by d log-form differential equations.pdf"}];
referenceCodeFile = FileNameJoin[{repositoryRoot, "reference", "ref_code", "codebubble", "Omegatau",
  "validate_TopToR1_against_dsdeppsol.m"}];
paperHash = ToUpperCase@IntegerString[FileHash[paperFile, "SHA256"], 16, 64];
referenceCodeHash = ToUpperCase@IntegerString[FileHash[referenceCodeFile, "SHA256"], 16, 64];
paperDE = Get[deOracleFile];
Get[solutionOracleFile];


(* ::Chapter:: *)
(*MadStree 两顶点 G++ 与固定收敛域点*)

AppendTo[$Path, FileNameJoin[{packageRoot, "Kernel"}]];
Needs["MadStree`"];
context = MSInitTree[<|
  "name" -> "Paper2411TwoVertexGpp",
  "normalization" -> 1,
  "vertices" -> {
    <|"id" -> 1, "externalLegEnergy" -> e12, "timePower" -> nu0, "vertexType" -> "+"|>,
    <|"id" -> 2, "externalLegEnergy" -> e34, "timePower" -> nu0, "vertexType" -> "+"|>
  },
  "lines" -> {
    <|"type" -> "massive", "endpoints" -> {1, 2}, "momentum" -> ks, "nu" -> nu1|>
  }
|>, NuConvention -> "Negative"];
targetRules = {k12 -> 30, k34 -> 6, ks -> 1, nu0 -> 2, nu1 -> 1/5};
packageTargetRules = {e12 -> -30, e34 -> -6, ks -> 1, nu0 -> 2, nu1 -> 1/5};
workingPrecision = 100;
lowCutoff = 30;
highCutoff = 42;


(* ::Chapter:: *)
(*Exact DE、master 与绝对边界*)

packageDE = MSDLogDE[context];
packagePaperPotential = packageDE["omegaPotential"] /. {e12 -> -k12, e34 -> -k34};
masters = MSMasterIntegrals[context];
deResiduals = Association@Table[
  variable -> Map[Together,
    D[packagePaperPotential, variable] - paperDE["connectionMatrices", variable],
    {2}],
  {variable, {k12, k34, ks}}
];
deDifferenceCounts = Map[Count[Flatten[#], value_ /; ! TrueQ[value === 0]] &, deResiduals];

paperC[order_] := 2^(-order) Gamma[-order]/(I Pi);
paperEndpoint[1, 0, order_] := Exp[-I Pi order] paperC[order];
paperEndpoint[1, 1, order_] := -paperC[-order - 1];
paperEndpoint[2, 0, order_] := -Exp[I Pi order] paperC[order];
paperEndpoint[2, 1, order_] := paperC[-order - 1];
paperVertexCoefficient[branch_Integer, bit_Integer] := Module[
  {power = nu0 /. targetRules, order = nu1 /. targetRules, momentum = ks /. targetRules},
  (-I)^(power + 1) Gamma[power + 1 - bit (2 order + 1)]
    (-I momentum)^(-bit (2 order + 1)) paperEndpoint[branch, bit, order]
];
topStateOrder = Take[Lookup[masters, "stateBits"], 4];
paperTopCoefficients = paperVertexCoefficient[1, First[#]] paperVertexCoefficient[2, Last[#]] & /@ topStateOrder;
paperContactCoefficient = paperDE["contactBoundaryCoefficient"] /. targetRules;
paperBoundaryCoefficients = Append[paperTopCoefficients, paperContactCoefficient];
paperContactVector = paperDE["contactLeadingVector"] /. targetRules;

{boundarySeconds, boundary} = AbsoluteTiming[MSBoundaryData[
  context,
  packageTargetRules,
  RankOrder -> {1, 2},
  BoundaryScale -> 4,
  BoundarySeriesOrder -> 42,
  WorkingPrecision -> workingPrecision
]];
productionBranches = Lookup[boundary, "leadingBranches", {}];
productionCoefficients = Lookup[productionBranches, "coefficient", {}];
productionVectors = Lookup[productionBranches, "normalizedLeadingVector", {}];
coefficientResiduals = FullSimplify[
  FunctionExpand[# /. {
    Power[base_Integer?Negative, rational_Rational] :>
      Abs[base]^rational Exp[I Pi rational],
    Power[-I, rational_Rational] :> Exp[-I Pi rational/2],
    Power[I, rational_Rational] :> Exp[I Pi rational/2]
  }]
] & /@ MapThread[#1 - #2 &, {productionCoefficients, paperBoundaryCoefficients}];
childNormalization = Last[context["sectors"]]["normalization"] /. targetRules;
paperChildNormalization = paperDE["normalization", "child"] /. targetRules;
childBoundaryRatio = FullSimplify[Last[productionCoefficients]/paperContactCoefficient];


(* ::Chapter:: *)
(*论文收敛级数与 MadStree 单点输运*)

{paperSeconds, paperLow} = AbsoluteTiming[
  Paper2411TwoVertexGppValue[targetRules, lowCutoff, WorkingPrecision -> workingPrecision]
];
paperHigh = Paper2411TwoVertexGppValue[targetRules, highCutoff, WorkingPrecision -> workingPrecision];
paperCutoffDifference = Max[Abs[paperLow["value"] - paperHigh["value"]]];
derivativeStep = 10^-35;
paperValueAt[variable_, value_] := Paper2411TwoVertexGppValue[
  targetRules /. Rule[variable, _] :> Rule[variable, value],
  highCutoff,
  WorkingPrecision -> workingPrecision
]["value"];
paperDEResiduals = Association@Table[
  variable -> With[{center = variable /. targetRules},
    (paperValueAt[variable, center + derivativeStep] -
       paperValueAt[variable, center - derivativeStep])/(2 derivativeStep) -
      N[paperDE["connectionMatrices", variable] /. targetRules, workingPrecision].paperHigh["value"]
  ],
  {variable, {k12, k34, ks}}
];
paperMaxDEResidual = Max[Abs[Flatten[Values[paperDEResiduals]]]];

{transportSeconds, evaluation} = AbsoluteTiming[MSEvaluatePath[
  context,
  {packageTargetRules},
  MSRuntimeDirectory -> runtimeDirectory,
  BoundaryScale -> 4,
  BoundarySeriesOrder -> 42,
  RankOrder -> {1, 2},
  WorkingPrecision -> workingPrecision,
  TransportOrder -> 144,
  ReferenceTransportOrder -> 184,
  TargetRelativeError -> "1e-30"
]];
productionValue = If[AssociationQ[evaluation], Lookup[evaluation, "values", {}], {}];
componentRelativeDifferences = If[Length[productionValue] === 5,
  MapThread[Abs[#1 - #2]/Max[Abs[#2], 10^-80] &, {productionValue, paperHigh["value"]}],
  ConstantArray[Infinity, 5]
];
maximumRelativeDifference = Max[componentRelativeDifferences];
childValueRatio = If[Length[productionValue] === 5,
  Last[productionValue]/Last[paperHigh["value"]],
  Missing["NoProductionValue"]
];


(* ::Chapter:: *)
(*验收、summary 与报告*)

checks = <|
  "paperHash" -> paperHash === "34315DA929126E8B455638C168722B6909CD243183B71C4137EEC81B5F0F2EAA",
  "referenceCodeHash" -> referenceCodeHash === "C6E4C290D9BF1B76CF6A029109521078B843E4A1B2E84EB184A79E6B7C3B1A06",
  "referenceCodeResidual" -> paperDE["referenceCodeResidual"] === ConstantArray[0, 4],
  "fiveMastersPaperOrder" -> Lookup[masters, "stateBits"] === {{0, 0}, {0, 1}, {1, 0}, {1, 1}, {}},
  "exactDE" -> And @@ Thread[Values[deDifferenceCounts] === {0, 0, 0}],
  "boundaryGenerated" -> Lookup[boundary, "status", None] === "generated",
  "fiveBoundaryCoefficients" -> Length[coefficientResiduals] === 5 && And @@ (PossibleZeroQ /@ coefficientResiduals),
  "contactLeadingVector" -> Last[productionVectors] === paperContactVector,
  "childNormalization" -> PossibleZeroQ[childNormalization - paperChildNormalization],
  "childBoundaryRatio" -> PossibleZeroQ[childBoundaryRatio - 1],
  "paperSeriesConvergence" -> TrueQ[paperCutoffDifference < 10^-20],
  "paperSeriesDE" -> TrueQ[paperMaxDEResidual < 10^-25],
  "transportComputed" -> AssociationQ[evaluation] && Lookup[evaluation, "status", None] === "computed",
  "transportRefinement" -> AssociationQ[evaluation] && TrueQ[Lookup[evaluation["flintNDE"], "targetRelativeErrorMet", False]],
  "fullOrdinaryPointValue" -> TrueQ[maximumRelativeDifference < 10^-18],
  "childOrdinaryPointValue" -> TrueQ[Last[componentRelativeDifferences] < 10^-18]
|>;
status = If[And @@ Values[checks], "passed", "failed"];
elapsedSeconds = N[AbsoluteTime[] - validationStart, 10];
summary = <|
  "schema" -> "madstree_v0.13_paper2411_two_vertex_gpp_validation_v1",
  "status" -> status,
  "scope" -> "2411.03088 Sec. 4 two-vertex massive G++ only",
  "paperOracleBoundary" -> "independent validation only; not a MadStree package feature",
  "excluded" -> {"NIntegrate", "full regression", "other graph families"},
  "checks" -> checks,
  "passedCount" -> Count[Values[checks], True],
  "checkCount" -> Length[checks],
  "hashes" -> <|"paper" -> paperHash, "referenceCode" -> referenceCodeHash,
    "deOracle" -> deOracleHash, "solutionOracle" -> solutionOracleHash,
    "Sectors.wl" -> IntegerString[FileHash[FileNameJoin[{packageRoot, "Kernel", "Core", "Sectors.wl"}], "SHA256"], 16, 64],
    "Boundary.wl" -> IntegerString[FileHash[FileNameJoin[{packageRoot, "Kernel", "Numerics", "Boundary.wl"}], "SHA256"], 16, 64]|>,
  "targetRules" -> targetRules,
  "packageTargetRules" -> packageTargetRules,
  "blowupPoint" -> <|"x" -> (k34/k12 /. targetRules), "y" -> (1/k34 /. targetRules)|>,
  "masters" -> masters,
  "deDifferenceCounts" -> deDifferenceCounts,
  "deResiduals" -> deResiduals,
  "coefficientResiduals" -> coefficientResiduals,
  "productionLeadingVectors" -> productionVectors,
  "paperContactLeadingVector" -> paperContactVector,
  "paperChildNormalization" -> paperChildNormalization,
  "packageChildNormalization" -> childNormalization,
  "childBoundaryRatio" -> childBoundaryRatio,
  "paperCutoffs" -> {lowCutoff, highCutoff},
  "paperCutoffDifference" -> paperCutoffDifference,
  "paperMaxDEResidual" -> paperMaxDEResidual,
  "paperConvergence" -> paperHigh["convergence"],
  "paperValue" -> paperHigh["value"],
  "packageValue" -> productionValue,
  "componentRelativeDifferences" -> componentRelativeDifferences,
  "maximumRelativeDifference" -> maximumRelativeDifference,
  "childValueRatio" -> childValueRatio,
  "path" -> If[AssociationQ[evaluation], Lookup[evaluation["flintNDE"], "segments", {}], {}],
  "workingPrecision" -> workingPrecision,
  "boundarySeriesOrder" -> 42,
  "transportOrder" -> 144,
  "referenceTransportOrder" -> 184,
  "targetRelativeError" -> "1e-30",
  "timings" -> <|"boundarySeconds" -> boundarySeconds, "paperSeconds" -> paperSeconds,
    "transportSeconds" -> transportSeconds, "totalSeconds" -> elapsedSeconds|>
|>;
Export[summaryFile, ToString[summary, InputForm, PageWidth -> Infinity] <> "\n", "Text",
  CharacterEncoding -> "UTF-8"];

reportLines = Join[{
  "# MadStree v0.13 \:72ec\:7acb\:68c0\:9a8c\:62a5\:544a\:ff1a\:8bba\:6587\:4e24\:9876\:70b9 massive G++",
  "",
  "## \:72b6\:6001",
  "",
  "- \:72b6\:6001\:ff1a`" <> status <> "`",
  "- \:901a\:8fc7\:ff1a`" <> ToString[summary["passedCount"]] <> "/" <> ToString[summary["checkCount"]] <> "`",
  "- \:8303\:56f4\:ff1a\:53ea\:8fd0\:884c 2411.03088 Sec. 4 \:4e24\:9876\:70b9 G++ targeted validation\:ff1b\:672a\:8fd0\:884c\:5168\:91cf\:56de\:5f52\:3002",
  "- \:8bba\:6587\:7ea7\:6570/\:8d85\:51e0\:4f55 oracle \:53ea\:5b58\:5728\:72ec\:7acb\:9a8c\:8bc1\:76ee\:5f55\:ff0c\:4e0d\:662f MadStree \:7a0b\:5e8f\:5305\:529f\:80fd\:ff1b\:672a\:4f7f\:7528 NIntegrate\:3002",
  "",
  "## \:6838\:5fc3\:8bc1\:636e",
  "",
  "- master \:987a\:5e8f\:ff1a`{I00,I01,I10,I11,IR}`\:ff1bpackage \:8bb0\:5f55\:89c1 `results/summary.wl`\:3002",
  "- \:4e09\:4e2a exact 5x5 DE \:975e\:96f6\:5dee\:503c\:6570\:ff1a`" <> ToString[deDifferenceCounts, InputForm] <> "`\:3002",
  "- \:4e94\:4e2a\:8fb9\:754c coefficient residual\:ff1a`" <> ToString[coefficientResiduals, InputForm] <> "`\:3002",
  "- child \:8fb9\:754c ratio\:ff08package/paper\:ff09\:ff1a`" <> ToString[childBoundaryRatio, InputForm] <> "`\:3002",
  "- \:8bba\:6587\:7ea7\:6570 cutoff 30/42 \:6700\:5927\:53d8\:5316\:ff1a`" <> ToString[paperCutoffDifference, InputForm] <> "`\:3002",
  "- \:8bba\:6587\:7ea7\:6570\:4ee3\:5165\:4e94\:7ef4 DE \:6700\:5927 residual\:ff1a`" <> ToString[paperMaxDEResidual, InputForm] <> "`\:3002",
  "- \:666e\:901a\:70b9\:4e94\:5206\:91cf\:6700\:5927\:76f8\:5bf9\:5dee\:ff1a`" <> ToString[maximumRelativeDifference, InputForm] <> "`\:3002",
  "- child \:666e\:901a\:70b9\:76f8\:5bf9\:5dee\:ff1a`" <> ToString[Last[componentRelativeDifferences], InputForm] <> "`\:ff1bratio\:ff1a`" <>
    ToString[childValueRatio, InputForm] <> "`\:3002",
  "",
  "## \:70b9\:3001\:7cbe\:5ea6\:4e0e\:8017\:65f6",
  "",
  "- \:70b9\:ff1a`" <> ToString[targetRules, InputForm] <> "`\:ff1b`x=1/5, y=1/6`\:ff0c\:4f4d\:4e8e\:8bba\:6587\:7ea7\:6570\:6536\:655b\:57df\:5185\:4e14\:4e0d\:8de8\:590d\:5e42 branch cut\:3002",
  "- \:5de5\:4f5c\:7cbe\:5ea6\:ff1a`100`\:ff1b\:8fb9\:754c\:9636\:ff1a`42`\:ff1b\:8f93\:8fd0\:9636\:ff1a`144/184`\:ff1b\:76ee\:6807\:76f8\:5bf9\:8bef\:5dee\:ff1a`1e-30`\:3002",
  "- \:8fb9\:754c/\:8bba\:6587\:7ea7\:6570/\:8f93\:8fd0/\:603b wall time\:ff08\:79d2\:ff09\:ff1a`" <>
    ToString[{boundarySeconds, paperSeconds, transportSeconds, elapsedSeconds}, InputForm] <> "`\:3002",
  "",
  "## \:68c0\:67e5\:9879",
  ""},
  KeyValueMap["- `" <> #1 <> "`\:ff1a" <> If[TrueQ[#2], "PASS", "FAIL"] &, checks],
  {"", "\:673a\:5668\:8bc1\:636e\:ff1a`results/summary.wl`\:3002\:8fd0\:884c\:4e34\:65f6\:76ee\:5f55\:5df2\:6e05\:7406\:3002"}
];
Export[reportFile, StringRiffle[reportLines, "\n"] <> "\n", "Text", CharacterEncoding -> "UTF-8"];
If[DirectoryQ[runtimeDirectory], DeleteDirectory[runtimeDirectory, DeleteContents -> True]];
Print[InputForm[<|"status" -> status, "passed" -> summary["passedCount"],
  "total" -> summary["checkCount"], "maxRelativeDifference" -> maximumRelativeDifference,
  "childRatio" -> childValueRatio|>]];
Exit[If[status === "passed", 0, 1]];
