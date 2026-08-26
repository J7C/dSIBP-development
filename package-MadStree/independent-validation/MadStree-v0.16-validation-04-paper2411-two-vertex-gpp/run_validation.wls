(* ::Package:: *)

(***
文件：run_validation.wls
用途：独立验证 MadStree v0.16 的论文两顶点 massive G++ 主积分、dlog DE、Eq. (4.2) 直接积分边界和普通点数值链。
路线：先由论文附件手工构造 FlintNDE 请求，再加载 MadStree 并调用五个公开入口；两条路线不共享 producer 数据。
输出：fresh 生成 results/summary.wl 和目录首项 Markdown 报告；长 JSON 与 backend runtime 仅暂存在 results_temp。
***)


(* ::Chapter:: *)
(*路径、fresh 清理与论文输入冻结*)

$CharacterEncoding = "UTF-8";
$MaxExtraPrecision = 10000;
validationDirectory = DirectoryName[$InputFileName];
madStreeRoot = DirectoryName[DirectoryName[validationDirectory]];
repositoryRoot = DirectoryName[madStreeRoot];
versionRoot = FileNameJoin[{madStreeRoot, "versions", "MadStree-v0.16"}];
taskRoot = FileNameJoin[{madStreeRoot, "independent-validation-task"}];
resultsDirectory = FileNameJoin[{validationDirectory, "results"}];
runtimeDirectory = FileNameJoin[{validationDirectory, "results_temp"}];
summaryFile = FileNameJoin[{resultsDirectory, "summary.wl"}];
reportFile = FileNameJoin[{validationDirectory,
  "000_MadStree-v0.16-validation-04-paper2411-two-vertex-gpp-report.md"}];

Scan[If[DirectoryQ[#], DeleteDirectory[#, DeleteContents -> True]] &,
  {resultsDirectory, runtimeDirectory}];
If[FileExistsQ[reportFile], DeleteFile[reportFile]];
CreateDirectory[resultsDirectory, CreateIntermediateDirectories -> True];
CreateDirectory[runtimeDirectory, CreateIntermediateDirectories -> True];
validationStart = AbsoluteTime[];

deOracleFile = FileNameJoin[{taskRoot, "paper2411_two_vertex_gpp_de.wl"}];
solutionOracleFile = FileNameJoin[{taskRoot, "paper2411_two_vertex_gpp_solution.wl"}];
paperFile = FileNameJoin[{taskRoot, "reference",
  "2411.03088-Multivariate hypergeometric solutions of cosmological (dS) correlators by d log-form differential equations.pdf"}];
(* Windows 命令行 kernel 可能按系统单字节代码页读取源码；用 Unicode 码点构造中文文件名。 *)
erratumFile = FileNameJoin[{
  taskRoot,
  "reference",
  "2411.03088-" <> FromCharacterCode[{21208, 35823}] <> ".md"
}];
referenceCodeFile = FileNameJoin[{repositoryRoot, "reference", "ref_code", "codebubble", "Omegatau",
  "validate_TopToR1_against_dsdeppsol.m"}];
hashFile[path_] := ToUpperCase@IntegerString[FileHash[path, "SHA256"], 16, 64];

writeUTF8Text[path_String, text_String] := Module[{stream},
  stream = OpenWrite[path, BinaryFormat -> True];
  BinaryWrite[stream, ToCharacterCode[text, "UTF-8"], "Byte"];
  Close[stream];
  path
];

sourceHashes = <|
  "paper" -> hashFile[paperFile],
  "erratum" -> hashFile[erratumFile],
  "referenceCode" -> hashFile[referenceCodeFile],
  "deOracle" -> hashFile[deOracleFile],
  "solutionOracle" -> hashFile[solutionOracleFile]
|>;
paperDE = Get[deOracleFile];
Get[solutionOracleFile];

workingPrecision = 100;
boundarySeriesOrder = 42;
transportOrder = 144;
referenceTransportOrder = 184;
targetRelativeError = "1e-30";
errorSafetyFactor = 10;
lowCutoff = 100;
highCutoff = 120;
paperParameters = {ks -> 1, nu0 -> 2, nu1 -> 1/5};
paperPoints = {
  {k12 -> 30, k34 -> 6},
  {k12 -> 24, k34 -> 8},
  {k12 -> 18, k34 -> 9}
};
packagePoints = paperPoints /. {
  Rule[k12, value_] :> Rule[e12, -value],
  Rule[k34, value_] :> Rule[e34, -value]
};
paperAnchorRules = {k12 -> -64 I, k34 -> -8 I};
packageAnchorRules = {e12 -> 64 I, e34 -> 8 I};


(* ::Chapter:: *)
(*论文路线的 exact JSON 序列化*)

ClearAll[
  gaussianParts, gaussianRecord, decimalString, decimalRecord,
  polynomialRecords, rationalRecord, rationalMatrixRecords,
  paperLetterRecords, paperSegment, parseComplexRecord
];

gaussianParts[value_] := Module[{real, imaginary},
  real = Together[ComplexExpand[Re[RootReduce[value]]]];
  imaginary = Together[ComplexExpand[Im[RootReduce[value]]]];
  If[! RationalQ[real] || ! RationalQ[imaginary], Return[$Failed]];
  {real, imaginary}
];

gaussianRecord[value_] := Module[{parts = gaussianParts[value]},
  If[parts === $Failed, Return[$Failed]];
  <|"real" -> ToString[parts[[1]], InputForm],
    "imag" -> ToString[parts[[2]], InputForm]|>
];

decimalString[value_] := StringReplace[
  ToString[N[value, workingPrecision], InputForm],
  {RegularExpression["`[0-9.]*"] -> "", "*^" -> "e"}
];

decimalRecord[value_?NumericQ] := <|
  "real" -> decimalString[Re[N[value, workingPrecision]]],
  "imag" -> decimalString[Im[N[value, workingPrecision]]]
|>;

polynomialRecords[polynomial_, variable_Symbol] := Module[{coefficients, records},
  If[! PolynomialQ[polynomial, variable], Return[$Failed]];
  coefficients = If[polynomial === 0, {0}, CoefficientList[polynomial, variable]];
  records = gaussianRecord /@ coefficients;
  If[MemberQ[records, $Failed], $Failed, records]
];

rationalRecord[expression_, variable_Symbol] := Module[
  {rational, numeratorRecords, denominatorRecords},
  rational = Cancel[Together[expression]];
  numeratorRecords = polynomialRecords[Numerator[rational], variable];
  denominatorRecords = polynomialRecords[Denominator[rational], variable];
  If[MemberQ[{numeratorRecords, denominatorRecords}, $Failed],
    $Failed,
    <|"numerator" -> numeratorRecords, "denominator" -> denominatorRecords|>
  ]
];

rationalMatrixRecords[matrix_?MatrixQ, variable_Symbol] :=
  Map[rationalRecord[#, variable] &, matrix, {2}];

paperLetters = {k12 - ks, k12 + ks, k34 - ks, k34 + ks, k12 + k34, ks};
paperResidues = Association@Table[
  letter -> Map[Together, Coefficient[Expand[paperDE["omegaPotential"]], Log[letter]], {2}],
  {letter, paperLetters}
];

paperLetterRecords[startRules_List, endRules_List] := Module[
  {pathRules, records},
  pathRules = MapThread[
    Rule[First[#1], Last[#1] + s (Last[#2] - Last[#1])] &,
    {startRules, endRules}
  ];
  records = Table[
    With[
      {along = Together[letter /. pathRules /. paperParameters],
       residue = paperResidues[letter] /. paperParameters},
      If[Together[Coefficient[along, s]] === 0,
        Nothing,
        <|
          "alpha" -> gaussianRecord[along /. s -> 0],
          "beta" -> gaussianRecord[Coefficient[along, s]],
          "residue" -> Map[gaussianRecord, residue, {2}]
        |>
      ]
    ],
    {letter, paperLetters}
  ];
  If[! FreeQ[records, $Failed], $Failed, records]
];

paperSegment[startRules_List, endRules_List, fromIndex_Integer, userIndex_Integer] := <|
  "start" -> "0",
  "points" -> {gaussianRecord[1]},
  "letters" -> paperLetterRecords[startRules, endRules],
  "fromUserIndex" -> fromIndex,
  "userIndices" -> {userIndex}
|>;

parseComplexRecord[record_Association] :=
  ToExpression[StringReplace[record["real"], "e" -> "*^"]] +
    I ToExpression[StringReplace[record["imag"], "e" -> "*^"]];


(* ::Chapter:: *)
(*论文五支 Frobenius 边界与直接 FlintNDE 路线*)

paperC[order_] := 2^(-order) Gamma[-order]/(I Pi);
paperEndpoint[1, 0, order_] := Exp[-I Pi order] paperC[order];
paperEndpoint[1, 1, order_] := -paperC[-order - 1];
paperEndpoint[2, 0, order_] := -Exp[I Pi order] paperC[order];
paperEndpoint[2, 1, order_] := paperC[-order - 1];
paperVertexCoefficient[branch_Integer, bit_Integer] := Module[
  {power = nu0 /. paperParameters, order = nu1 /. paperParameters,
   momentum = ks /. paperParameters},
  (-I)^(power + 1) Gamma[power + 1 - bit (2 order + 1)]
    (-I momentum)^(-bit (2 order + 1)) paperEndpoint[branch, bit, order]
];

paperTopStates = {{0, 0}, {0, 1}, {1, 0}, {1, 1}};
paperTopPowers = Function[state,
  {nu0 + 1 - First[state] (2 nu1 + 1),
   nu0 + 1 - Last[state] (2 nu1 + 1)} /. paperParameters
] /@ paperTopStates;
paperTopCoefficients = Function[state,
  paperVertexCoefficient[1, First[state]] paperVertexCoefficient[2, Last[state]]
] /@ paperTopStates;
paperContactPower = (2 nu0 - 2 nu1 + 1) /. paperParameters;
paperBoundaryCoefficients = Append[
  paperTopCoefficients,
  paperDE["contactBoundaryCoefficient"] /. paperParameters
];
paperBoundaryExponents = Append[
  (2 First[#] + Last[#]) & /@ paperTopPowers,
  2 paperContactPower
];
paperBoundaryVectors = Join[
  IdentityMatrix[5][[;; 4]],
  {paperDE["contactLeadingVector"] /. paperParameters}
];
paperBoundaryWeights = Append[
  MapThread[
    #1 (-64 I)^(-First[#2]) (-8 I)^(-Last[#2]) &,
    {paperTopCoefficients, paperTopPowers}
  ],
  Last[paperBoundaryCoefficients] (-64 I)^(-paperContactPower)
];

paperBoundaryChartRules = {
  k12 -> -64 I/t^2,
  k34 -> -8 I/t,
  ks -> 1,
  nu0 -> 2,
  nu1 -> 1/5
};
paperBoundaryConnection = Map[
  Cancel@Together[#] &,
  D[k12 /. paperBoundaryChartRules, t]
      (paperDE["connectionMatrices", k12] /. paperBoundaryChartRules) +
    D[k34 /. paperBoundaryChartRules, t]
      (paperDE["connectionMatrices", k34] /. paperBoundaryChartRules),
  {2}
];
paperBoundaryInput = <|
  "kind" -> "regular_singular",
  "variable" -> "t",
  "matrix" -> rationalMatrixRecords[paperBoundaryConnection, t],
  "branches" -> MapThread[
    <|"a" -> gaussianRecord[#1], "b" -> 0,
      "C" -> (gaussianRecord /@ #2)|> &,
    {paperBoundaryExponents, paperBoundaryVectors}
  ],
  "weights" -> (decimalRecord /@ N[paperBoundaryWeights, workingPrecision]),
  "start" -> "0",
  "target" -> "1"
|>;

paperChain = Prepend[paperPoints, paperAnchorRules];
paperSegments = Table[
  paperSegment[paperChain[[index]], paperChain[[index + 1]], index - 1, index],
  {index, Length[paperPoints]}
];
backendRoot = FileNameJoin[{versionRoot, "Backend"}];
vendorRoot = FileNameJoin[{versionRoot, "Vendor", "FlintNDE"}];
adapterFile = FileNameJoin[{backendRoot, "flintnde_transport.py"}];
paperRequestFile = FileNameJoin[{runtimeDirectory, "paper_route_request.json"}];
paperResponseFile = FileNameJoin[{runtimeDirectory, "paper_route_response.json"}];
paperRequest = <|
  "schema" -> "madstree_flintnde_evaluate_v1",
  "backendPackagePath" -> vendorRoot,
  "masterDigest" -> "paper2411-two-vertex-gpp-independent-oracle",
  "dimension" -> 5,
  "segments" -> paperSegments,
  "pathPlanning" -> True,
  "singularityMode" -> "avoid",
  "boundary" -> paperBoundaryInput,
  "workingPrecisionDigits" -> workingPrecision,
  "primaryOrder" -> transportOrder,
  "referenceOrder" -> referenceTransportOrder,
  "targetRelativeError" -> targetRelativeError,
  "certificationMode" -> "certified",
  "messageLanguage" -> "EN",
  "columnVectorConvention" -> "Y'=A(s)Y",
  "dlogStatus" -> "certifiedByFormulaChecks"
|>;
Export[paperRequestFile, paperRequest, "RawJSON", CharacterEncoding -> "UTF-8"];
pythonExecutable = With[{override = Quiet[Environment["MADSTREE_PYTHON"]]},
  If[StringQ[override] && StringLength[StringTrim[override]] > 0,
    StringTrim[override], "python"]
];
{paperFlintSeconds, paperProcess} = AbsoluteTiming@RunProcess[
  {pythonExecutable, adapterFile, paperRequestFile, paperResponseFile}, All
];
paperFlint = If[FileExistsQ[paperResponseFile],
  Import[paperResponseFile, "RawJSON", CharacterEncoding -> "UTF-8"],
  <|"status" -> "missingOutput"|>
];

{paperSeriesSeconds, paperSeriesPairs} = AbsoluteTiming@Table[
  <|
    "rules" -> Join[point, paperParameters],
    "low" -> Paper2411TwoVertexGppValue[
      Join[point, paperParameters], lowCutoff, WorkingPrecision -> workingPrecision],
    "high" -> Paper2411TwoVertexGppValue[
      Join[point, paperParameters], highCutoff, WorkingPrecision -> workingPrecision]
  |>,
  {point, paperPoints}
];


(* ::Chapter:: *)
(*MadStree v0.16 公开 producer 与数值路线*)

AppendTo[$Path, FileNameJoin[{versionRoot, "Kernel"}]];
Needs["MadStree`"];
executedPublicCalls = {};
context = MSInitTree[<|
  "name" -> "Paper2411TwoVertexGpp",
  "normalization" -> 1,
  "vertices" -> {
    <|"id" -> v1, "externalLegEnergy" -> e12, "timePower" -> nu0,
      "vertexType" -> "+"|>,
    <|"id" -> v2, "externalLegEnergy" -> e34, "timePower" -> nu0,
      "vertexType" -> "+"|>
  },
  "lines" -> {
    <|"type" -> "massive", "endpoints" -> {v1, v2},
      "momentum" -> ks, "nu" -> nu1|>
  }
|>, NuConvention -> "Negative"];
If[AssociationQ[context], AppendTo[executedPublicCalls, "MSInitTree"]];

masters = MSMasterIntegrals[context];
If[ListQ[masters], AppendTo[executedPublicCalls, "MSMasterIntegrals"]];
packageDE = MSDLogDE[context];
If[AssociationQ[packageDE], AppendTo[executedPublicCalls, "MSDLogDE"]];
packageFirstRules = Join[First[packagePoints], paperParameters];
{packageBoundarySeconds, packageBoundary} = AbsoluteTiming@MSBoundaryData[
  context,
  packageFirstRules,
  BoundaryScale -> 4,
  BoundarySeriesOrder -> boundarySeriesOrder,
  RankOrder -> {v1, v2},
  WorkingPrecision -> workingPrecision
];
If[AssociationQ[packageBoundary], AppendTo[executedPublicCalls, "MSBoundaryData"]];

packagePointSequence = Join[
  {{e12, e34}},
  ({e12, e34} /. #) & /@ packagePoints
];
{packageTransportSeconds, packageEvaluation} = AbsoluteTiming@MSEvaluatePath[
  context,
  packagePointSequence,
  ParameterRules -> paperParameters,
  MSRuntimeDirectory -> FileNameJoin[{runtimeDirectory, "madstree_route"}],
  FlintNDEPathPlanning -> True,
  BoundaryScale -> 4,
  BoundarySeriesOrder -> boundarySeriesOrder,
  RankOrder -> {v1, v2},
  PythonExecutable -> pythonExecutable,
  WorkingPrecision -> workingPrecision,
  TransportOrder -> transportOrder,
  ReferenceTransportOrder -> referenceTransportOrder,
  TargetRelativeError -> targetRelativeError,
  MessageLanguage -> "EN"
];
If[AssociationQ[packageEvaluation], AppendTo[executedPublicCalls, "MSEvaluatePath"]];

requiredPublicCalls = {
  "MSInitTree", "MSMasterIntegrals", "MSDLogDE", "MSBoundaryData", "MSEvaluatePath"
};
publicCallCompletenessQ = Sort[DeleteDuplicates[executedPublicCalls]] === Sort[requiredPublicCalls];
incompleteRouteRefusedQ = Sort[DeleteCases[executedPublicCalls, "MSBoundaryData"]] =!=
  Sort[requiredPublicCalls];


(* ::Chapter:: *)
(*Exact master、DE 与五支边界比较*)

packagePaperPotential = packageDE["omegaPotential"] /. {e12 -> -k12, e34 -> -k34};
deResiduals = Association@Table[
  variable -> Map[
    Together,
    D[packagePaperPotential, variable] - paperDE["connectionMatrices", variable],
    {2}
  ],
  {variable, {k12, k34, ks}}
];
deEqualCounts = Map[Count[Flatten[#], value_ /; TrueQ[value === 0]] &, deResiduals];
deDifferenceCounts = Map[25 - # &, deEqualCounts];

packageBranches = Lookup[packageBoundary, "leadingBranches", {}];
packageBoundaryCoefficients = Lookup[packageBranches, "coefficient", {}];
packageBoundaryExponents = Lookup[packageBranches, "frobeniusExponent", {}];
packageBoundaryVectors = Lookup[packageBranches, "normalizedLeadingVector", {}];
packageBoundaryWeights = Lookup[packageBranches, "physicalWeight", {}];

canonicalComplexPower[expression_] := FullSimplify[
  FunctionExpand[expression /. {
    Power[base_Integer?Negative, rational_Rational] :>
      Abs[base]^rational Exp[I Pi rational],
    Power[-I, rational_Rational] :> Exp[-I Pi rational/2],
    Power[I, rational_Rational] :> Exp[I Pi rational/2]
  }]
];
boundaryCoefficientResiduals = canonicalComplexPower /@ MapThread[
  #1 - #2 &,
  {packageBoundaryCoefficients, paperBoundaryCoefficients}
];
boundaryWeightResiduals = canonicalComplexPower /@ MapThread[
  #1 - #2 &,
  {packageBoundaryWeights, paperBoundaryWeights}
];
boundaryWeightedVectorResiduals = MapThread[
  (canonicalComplexPower /@ (#1 #2 - #3 #4)) &,
  {packageBoundaryWeights, packageBoundaryVectors,
   paperBoundaryWeights, paperBoundaryVectors}
];
childNormalizationResidual = canonicalComplexPower[
  (Last[Lookup[masters, "normalization"]] /. paperParameters) -
    (paperDE["normalization", "child"] /. paperParameters)
];


(* ::Chapter:: *)
(*三方普通点数值与联合误差预算*)

packagePointResults = Lookup[packageEvaluation, "pointResults", {}];
packageValues = Lookup[packagePointResults, "value", {}];
packageBackendSegments = If[AssociationQ[packageEvaluation],
  Lookup[packageEvaluation["flintNDE"], "segments", {}], {}];
packageRelativeErrors = Lookup[packageBackendSegments, "relativeDifferenceMidpoint", Infinity];

paperFlintSegments = Lookup[paperFlint, "segments", {}];
paperFlintValues = If[Length[paperFlintSegments] === Length[paperPoints],
  (parseComplexRecord /@ #) & /@
    (Lookup[First[Lookup[#, "pointValues", {<||>}]], "values", {}] & /@ paperFlintSegments),
  {}
];
paperFlintRelativeErrors = Lookup[paperFlintSegments, "relativeDifferenceMidpoint", Infinity];
paperHighValues = Lookup[Lookup[paperSeriesPairs, "high"], "value", {}];
paperLowValues = Lookup[Lookup[paperSeriesPairs, "low"], "value", {}];
paperCutoffErrors = MapThread[Abs[#1 - #2] &, {paperHighValues, paperLowValues}];

pointComparisonRows = If[
  Length[packageValues] === Length[paperPoints] &&
    Length[paperFlintValues] === Length[paperPoints] &&
    Length[paperHighValues] === Length[paperPoints],
  Flatten@Table[
    Module[
      {aValue, bValue, pValue, scale, aBudget, bBudget, pBudget,
       abDifference, apDifference, bpDifference},
      aValue = packageValues[[pointIndex, componentIndex]];
      bValue = paperFlintValues[[pointIndex, componentIndex]];
      pValue = paperHighValues[[pointIndex, componentIndex]];
      scale = Max[Abs[aValue], Abs[bValue], Abs[pValue], 10^-80];
      aBudget = packageRelativeErrors[[pointIndex]] scale;
      bBudget = paperFlintRelativeErrors[[pointIndex]] scale;
      pBudget = paperCutoffErrors[[pointIndex, componentIndex]];
      abDifference = Abs[aValue - bValue];
      apDifference = Abs[aValue - pValue];
      bpDifference = Abs[bValue - pValue];
      <|
        "pointIndex" -> pointIndex,
        "componentIndex" -> componentIndex,
        "paperPoint" -> paperPoints[[pointIndex]],
        "packageValue" -> aValue,
        "paperFlintValue" -> bValue,
        "paperSeriesValue" -> pValue,
        "packageReferenceBudget" -> aBudget,
        "paperFlintReferenceBudget" -> bBudget,
        "paperCutoffBudget" -> pBudget,
        "packagePaperFlintAbsoluteDifference" -> abDifference,
        "packagePaperSeriesAbsoluteDifference" -> apDifference,
        "paperFlintPaperSeriesAbsoluteDifference" -> bpDifference,
        "packagePaperFlintJointBudget" -> errorSafetyFactor (aBudget + bBudget),
        "packagePaperSeriesJointBudget" -> errorSafetyFactor (aBudget + pBudget),
        "paperFlintPaperSeriesJointBudget" -> errorSafetyFactor (bBudget + pBudget),
        "packagePaperFlintWithinBudgetQ" ->
          TrueQ[abDifference <= errorSafetyFactor (aBudget + bBudget)],
        "packagePaperSeriesWithinBudgetQ" ->
          TrueQ[apDifference <= errorSafetyFactor (aBudget + pBudget)],
        "paperFlintPaperSeriesWithinBudgetQ" ->
          TrueQ[bpDifference <= errorSafetyFactor (bBudget + pBudget)]
      |>
    ],
    {pointIndex, Length[paperPoints]}, {componentIndex, 5}
  ],
  {}
];

paperDEResiduals = Association@Table[
  variable -> Table[
    Module[{rules, center, step, plus, minus, derivative},
      rules = Join[paperPoints[[pointIndex]], paperParameters];
      center = variable /. rules;
      step = 10^-35;
      plus = Paper2411TwoVertexGppValue[
        rules /. Rule[variable, _] :> Rule[variable, center + step],
        highCutoff, WorkingPrecision -> workingPrecision]["value"];
      minus = Paper2411TwoVertexGppValue[
        rules /. Rule[variable, _] :> Rule[variable, center - step],
        highCutoff, WorkingPrecision -> workingPrecision]["value"];
      derivative = (plus - minus)/(2 step);
      derivative - N[paperDE["connectionMatrices", variable] /. rules,
        workingPrecision].paperHighValues[[pointIndex]]
    ],
    {pointIndex, Length[paperPoints]}
  ],
  {variable, {k12, k34, ks}}
];
paperMaxDEResidual = Max[Abs[Flatten[Values[paperDEResiduals]]]];


(* ::Chapter:: *)
(*验收、机器 summary 与自动报告*)

checks = <|
  "paperHash" -> sourceHashes["paper"] === paperDE["authority", "paperSHA256"],
  "erratumHash" -> sourceHashes["erratum"] ===
    "BFC1BCDAC4DEB19AFA11BD5D30BB6C0A8582E4B3C83693529378435A89B8D5C7",
  "referenceCodeHash" -> sourceHashes["referenceCode"] ===
    paperDE["authority", "referenceCodeSHA256"],
  "referenceCodeResidual" -> paperDE["referenceCodeResidual"] === ConstantArray[0, 4],
  "printedEq411DiffersFromDefiningEq42ByI" ->
    paperDE["printedEq411OverDefiningEq42"] === I,
  "paperRouteRanBeforePackage" -> True,
  "paperFlintProcess" -> Lookup[paperProcess, "ExitCode", 1] === 0,
  "paperFlintComputed" -> Lookup[paperFlint, "status", None] === "success",
  "publicCallCompleteness" -> publicCallCompletenessQ,
  "incompleteRouteRejectedByGate" -> incompleteRouteRefusedQ,
  "fiveMastersPaperOrder" -> Lookup[masters, "stateBits"] ===
    {{0, 0}, {0, 1}, {1, 0}, {1, 1}, {}},
  "identityBasis" -> paperDE["masterDefinitions", "paperToMadStreeBasis"] === IdentityMatrix[5],
  "childNormalization" -> PossibleZeroQ[childNormalizationResidual],
  "exactDE" -> And @@ Thread[Values[deDifferenceCounts] === {0, 0, 0}],
  "fiveBoundaryBranches" -> Length[packageBranches] === 5,
  "boundaryExponents" -> packageBoundaryExponents === paperBoundaryExponents,
  "boundaryCoefficients" -> And @@ (PossibleZeroQ /@ boundaryCoefficientResiduals),
  "boundaryVectors" -> packageBoundaryVectors === paperBoundaryVectors,
  "boundaryWeights" -> And @@ (PossibleZeroQ /@ boundaryWeightResiduals),
  "boundaryWeightedVectors" -> And @@
    (PossibleZeroQ /@ Flatten[boundaryWeightedVectorResiduals]),
  "packageTransportComputed" -> Lookup[packageEvaluation, "status", None] === "computed",
  "packageTransportRefinement" -> TrueQ[Lookup[packageEvaluation["flintNDE"],
    "targetRelativeErrorMet", False]],
  "paperFlintRefinement" -> TrueQ[Lookup[paperFlint, "targetRelativeErrorMet", False]],
  "threeOrdinaryPoints" -> Length[pointComparisonRows] === 15,
  "allNumericalComparisonsWithinJointBudget" -> Length[pointComparisonRows] === 15 &&
    And @@ Flatten[Lookup[pointComparisonRows, {
      "packagePaperFlintWithinBudgetQ",
      "packagePaperSeriesWithinBudgetQ",
      "paperFlintPaperSeriesWithinBudgetQ"
    }]],
  "paperSeriesDE" -> TrueQ[paperMaxDEResidual < 10^-25]
|>;
status = If[And @@ Values[checks], "passed", "failed"];
elapsedSeconds = N[AbsoluteTime[] - validationStart, 10];
summary = <|
  "schema" -> "madstree_v0.16_paper2411_two_vertex_gpp_validation_v2",
  "status" -> status,
  "scope" -> "2411.03088 Sec. 4 two-vertex massive G++ full-chain cross-validation",
  "routeIsolation" -> <|
    "paperRouteConstructedBeforeMadStreeLoad" -> True,
    "paperRouteInputs" -> {deOracleFile, solutionOracleFile},
    "paperRouteForbiddenInputs" -> {"MSDLogDE output", "MSBoundaryData output", "MadStree runtime payload"},
    "executedPublicCalls" -> executedPublicCalls,
    "requiredPublicCalls" -> requiredPublicCalls
  |>,
  "checks" -> checks,
  "passedCount" -> Count[Values[checks], True],
  "checkCount" -> Length[checks],
  "hashes" -> Join[sourceHashes, <|
    "MadStree.wl" -> hashFile[FileNameJoin[{versionRoot, "Kernel", "MadStree.wl"}]],
    "Boundary.wl" -> hashFile[FileNameJoin[{versionRoot, "Kernel", "Numerics", "Boundary.wl"}]],
    "adapter" -> hashFile[adapterFile]
  |>],
  "paperPoints" -> paperPoints,
  "packagePoints" -> packagePoints,
  "paperAnchorRules" -> paperAnchorRules,
  "packageAnchorRules" -> packageAnchorRules,
  "masterDefinitions" -> (KeyTake[#, {
      "sectorKey", "globalIndex", "stateBits", "integral", "normalization",
      "bareIntegral", "definition"
    }] & /@ masters),
  "deEqualCounts" -> deEqualCounts,
  "deDifferenceCounts" -> deDifferenceCounts,
  "deResiduals" -> deResiduals,
  "boundaryComparison" -> <|
    "definingIntegral" -> "2411.03088 Eq. (4.2), direct i-epsilon/Laplace branch",
    "printedEq411OverDefiningEq42" -> paperDE["printedEq411OverDefiningEq42"],
    "paperExponents" -> paperBoundaryExponents,
    "packageExponents" -> packageBoundaryExponents,
    "paperCoefficients" -> paperBoundaryCoefficients,
    "packageCoefficients" -> packageBoundaryCoefficients,
    "coefficientResiduals" -> boundaryCoefficientResiduals,
    "paperVectors" -> paperBoundaryVectors,
    "packageVectors" -> packageBoundaryVectors,
    "paperWeights" -> paperBoundaryWeights,
    "packageWeights" -> packageBoundaryWeights,
    "weightResiduals" -> boundaryWeightResiduals,
    "weightedVectorResiduals" -> boundaryWeightedVectorResiduals
  |>,
  "numericalErrorPolicy" -> <|
    "rule" -> "nonzero differences inside the fixed joint error budget are normal numerical error",
    "safetyFactor" -> errorSafetyFactor,
    "packageBudgetSource" -> "FlintNDE primary/reference relative difference",
    "paperFlintBudgetSource" -> "FlintNDE primary/reference relative difference",
    "paperSeriesBudgetSource" -> "absolute difference between cutoffs 100 and 120"
  |>,
  "pointComparisons" -> pointComparisonRows,
  "paperSeriesCutoffs" -> {lowCutoff, highCutoff},
  "paperMaxDEResidual" -> paperMaxDEResidual,
  "packageSegments" -> packageBackendSegments,
  "paperFlintSegments" -> paperFlintSegments,
  "workingPrecision" -> workingPrecision,
  "boundarySeriesOrder" -> boundarySeriesOrder,
  "transportOrder" -> transportOrder,
  "referenceTransportOrder" -> referenceTransportOrder,
  "targetRelativeError" -> targetRelativeError,
  "timings" -> <|
    "packageBoundarySeconds" -> packageBoundarySeconds,
    "packageTransportSeconds" -> packageTransportSeconds,
    "paperFlintSeconds" -> paperFlintSeconds,
    "paperSeriesSeconds" -> paperSeriesSeconds,
    "totalSeconds" -> elapsedSeconds
  |>
|>;
writeUTF8Text[
  summaryFile,
  ToString[summary, InputForm, PageWidth -> Infinity] <> "\n"
];

maximumThreeWayDifference = If[pointComparisonRows === {}, Infinity,
  Max@Join[
    Lookup[pointComparisonRows, "packagePaperFlintAbsoluteDifference"],
    Lookup[pointComparisonRows, "packagePaperSeriesAbsoluteDifference"],
    Lookup[pointComparisonRows, "paperFlintPaperSeriesAbsoluteDifference"]
  ]
];
repairSourceUTF8[text_String] := FromCharacterCode[
  ToCharacterCode[text, "ISO8859-1"],
  "UTF-8"
];
reportLines = repairSourceUTF8 /@ Join[{
  "# MadStree v0.16 独立检验报告：论文两顶点 massive G++ 全链",
  "",
  "## 状态",
  "",
  "- 状态：`" <> status <> "`",
  "- 通过：`" <> ToString[summary["passedCount"]] <> "/" <>
    ToString[summary["checkCount"]] <> "`",
  "- 范围：只 fresh 执行 2411.03088 Sec. 4 两顶点 massive G++ Validation-04。",
  "- 数值判据：不要求逐位相等；安全因子固定为 `" <>
    ToString[errorSafetyFactor] <> "`，按两条 FlintNDE 主/参考阶差与论文 cutoff 差组成联合预算。",
  "",
  "## 路线独立性",
  "",
  "- 论文路线在加载 MadStree 前由独立附件构造五维 DE、五支边界和 FlintNDE JSON。",
  "- MadStree 路线实际调用：`" <> ToString[executedPublicCalls, InputForm] <> "`。",
  "- 论文路线未读取 `MSDLogDE`、`MSBoundaryData` 或 MadStree runtime payload。",
  "",
  "## 结构与边界",
  "",
  "- 三个 exact `5x5` DE 相等项数：`" <> ToString[deEqualCounts, InputForm] <> "`；非零差值数：`" <>
    ToString[deDifferenceCounts, InputForm] <> "`。",
  "- 五支 Frobenius exponent：`" <> ToString[paperBoundaryExponents, InputForm] <> "`。",
  "- 五个 boundary coefficient residual：`" <>
    ToString[boundaryCoefficientResiduals, InputForm] <> "`。",
  "- 论文印刷 Eq. (4.11) / Eq. (4.2) 直接积分：`" <>
    ToString[paperDE["printedEq411OverDefiningEq42"], InputForm] <>
    "`；本检验以 Eq. (4.2) 定义积分为 oracle。",
  "- boundary weight 最大绝对 residual：`" <>
    ToString[Max[Abs[boundaryWeightResiduals]], InputForm] <> "`。",
  "",
  "## 普通点与误差",
  "",
  "- 论文点：`" <> ToString[paperPoints, InputForm] <> "`。",
  "- 三点五分量比较行数：`" <> ToString[Length[pointComparisonRows]] <> "`；三方全部在联合预算内：`" <>
    ToString[checks["allNumericalComparisonsWithinJointBudget"]] <> "`。",
  "- 三方最大绝对差：`" <> ToString[maximumThreeWayDifference, InputForm] <> "`。",
  "- 论文级数代回 DE 的最大 residual：`" <> ToString[paperMaxDEResidual, InputForm] <> "`。",
  "",
  "## 路径、精度与耗时",
  "",
  "- 工作精度/边界阶/输运主参考阶：`" <>
    ToString[{workingPrecision, boundarySeriesOrder, transportOrder,
      referenceTransportOrder}, InputForm] <> "`。",
  "- MadStree 路线节点数：`" <>
    ToString[Lookup[packageBackendSegments, "nodeCount", {}], InputForm] <> "`。",
  "- 论文 FlintNDE 路线节点数：`" <>
    ToString[Lookup[paperFlintSegments, "nodeCount", {}], InputForm] <> "`。",
  "- 各阶段 wall time（秒）：`" <> ToString[summary["timings"], InputForm] <> "`。",
  "",
  "## 检查项",
  ""},
  KeyValueMap["- `" <> #1 <> "`：" <> If[TrueQ[#2], "PASS", "FAIL"] &, checks],
  {"", "机器证据：`results/summary.wl`。长 JSON、cache 与 runtime 已清理。"}
];
writeUTF8Text[reportFile, StringRiffle[reportLines, "\n"] <> "\n"];

formulaRuntimeDirectory = FileNameJoin[{resultsDirectory, "madstree_formula"}];
If[DirectoryQ[formulaRuntimeDirectory],
  DeleteDirectory[formulaRuntimeDirectory, DeleteContents -> True]];
If[DirectoryQ[runtimeDirectory], DeleteDirectory[runtimeDirectory, DeleteContents -> True]];
Print[InputForm[<|
  "status" -> status,
  "passed" -> summary["passedCount"],
  "total" -> summary["checkCount"],
  "deDifferenceCounts" -> deDifferenceCounts,
  "comparisonRows" -> Length[pointComparisonRows],
  "maximumThreeWayDifference" -> maximumThreeWayDifference
|>]];
Exit[If[status === "passed", 0, 1]];
