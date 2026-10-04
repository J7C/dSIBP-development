(* ::Package:: *)

(***
文件：run_validation.wls
用途：独立验证单顶点函数族、最小 cyclic time graph、正规化级数重建和数值结果导出。
独立来源：expected 只由 Gamma 积分和两时间排序 chamber 的闭式积分构造，不读取 MadStree 的
          tree adapter、recurrence metadata、边界向量或既有测试结果。
输出：从空目录生成 results/summary.wl 和 UTF-8 Markdown 报告；backend payload 只进 results_temp。
***)

(* ::Chapter:: *)
(*路径、fresh 清理与公共工具*)

$CharacterEncoding = "UTF-8";
$MaxExtraPrecision = 10000;
validationStart = AbsoluteTime[];
caseRoot = DirectoryName[$InputFileName];
projectRoot = DirectoryName[DirectoryName[DirectoryName[caseRoot]]];
versionRoot = FileNameJoin[{projectRoot, "package-MadStree", "versions", "MadStree-v0.17"}];
resultsRoot = FileNameJoin[{caseRoot, "results"}];
tempRoot = FileNameJoin[{caseRoot, "results_temp"}];
reportPath = FileNameJoin[{caseRoot,
  "000_MadStree-v0.17-validation-06-vertex-timegraph-regulator-report.md"}];
summaryPath = FileNameJoin[{resultsRoot, "summary.wl"}];

Scan[If[DirectoryQ[#], DeleteDirectory[#, DeleteContents -> True]] &, {resultsRoot, tempRoot}];
If[FileExistsQ[reportPath], DeleteFile[reportPath]];
CreateDirectory[resultsRoot, CreateIntermediateDirectories -> True];
CreateDirectory[tempRoot, CreateIntermediateDirectories -> True];

sourceFiles = Sort[FileNames["*.wl", FileNameJoin[{versionRoot, "Kernel"}], Infinity]];
sourceDigest = Hash[FileHash[#, "SHA256"] & /@ sourceFiles, "SHA256", "HexString"];
pythonExecutable = With[{override = Quiet[Environment["MADSTREE_PYTHON"]]},
  If[StringQ[override] && StringLength[StringTrim[override]] > 0,
    StringTrim[override], "python"]
];

writeUTF8Text[path_String, text_String] := Module[{stream, writeResult},
  Quiet@Check[CreateDirectory[DirectoryName[path], CreateIntermediateDirectories -> True], Null];
  stream = Quiet@Check[OpenWrite[path, BinaryFormat -> True], $Failed];
  If[stream === $Failed, Return[$Failed]];
  writeResult = Quiet@Check[
    BinaryWrite[stream, ToCharacterCode[text, "UTF-8"], "Byte"];
    Close[stream];
    path,
    Quiet@Check[Close[stream], Null];
    $Failed
  ];
  If[writeResult === path && FileExistsQ[path], path, $Failed]
];
repairSourceUTF8[text_String] := FromCharacterCode[
  ToCharacterCode[text, "ISO8859-1"],
  "UTF-8"
];
relativeVectorDifference[actual_List, expected_List, floor_] := Max@MapThread[
  Abs[#1 - #2]/Max[Abs[#2], floor] &,
  {actual, expected}
];

AppendTo[$Path, FileNameJoin[{versionRoot, "Kernel"}]];
Needs["MadStree`"];


(* ::Chapter:: *)
(*单顶点 Gamma 闭式、dlog、边界和普通点*)

(* 对 vertexType="+" 和 k0 位于正虚轴，lambda=-i k0>0，裸积分是
   Integral[t^a Exp[-lambda t],{t,0,Infinity}]=Gamma[a+1] lambda^(-a-1)。 *)
vertexClosedForm[aValue_, kValue_] := Gamma[aValue + 1] (-I kValue)^(-aValue - 1);
vertexContext = MSInitVertexFamily[<|"ki" -> {k0}, "nui" -> {a}|>];
vertexMasters = MSMasterIntegrals[vertexContext];
vertexDE = MSDLogDE[vertexContext];
vertexExpectedSymbolic = {vertexClosedForm[a, k0]};
vertexConnection = Map[D[#, k0] &, vertexDE["omegaPotential"], {2}];
vertexDEResidual = Together@FullSimplify[
  D[vertexExpectedSymbolic, k0] - vertexConnection.vertexExpectedSymbolic
];
vertexTargetRules = {k0 -> 3 I, a -> 1};
vertexPointSequence = {{k0}, {3 I}};
vertexBoundary = MSBoundaryData[
  vertexContext,
  vertexTargetRules,
  BoundaryScale -> 4,
  BoundarySeriesOrder -> 16,
  WorkingPrecision -> 50
];
vertexBoundaryBranch = First[vertexBoundary["leadingBranches"]];
vertexBoundaryExpected = vertexClosedForm[1, 4 I];
vertexBoundaryResidual = FullSimplify[
  vertexBoundaryBranch["physicalWeight"] - vertexBoundaryExpected
];
{vertexTransportSeconds, vertexEvaluation} = AbsoluteTiming[MSEvaluatePath[
  vertexContext,
  vertexPointSequence,
  ParameterRules -> {a -> 1},
  PythonExecutable -> pythonExecutable,
  MSRuntimeDirectory -> FileNameJoin[{tempRoot, "vertex"}],
  FlintNDEPathPlanning -> True,
  BoundaryScale -> 4,
  BoundarySeriesOrder -> 16,
  WorkingPrecision -> 50,
  TransportOrder -> 64,
  ReferenceTransportOrder -> 88,
  TargetRelativeError -> "1e-22"
]];
vertexExpectedValue = N[{vertexClosedForm[1, 3 I]}, 45];
vertexValueDifference = relativeVectorDifference[
  vertexEvaluation["values"], vertexExpectedValue, 10^-40
];


(* ::Chapter:: *)
(*平行双线 cyclic time graph 的独立 chamber 解*)

timeSpec = <|
  "vertices" -> {
    <|"id" -> 1, "externalLegEnergy" -> k1, "timePower" -> a1, "vertexType" -> "+"|>,
    <|"id" -> 2, "externalLegEnergy" -> k2, "timePower" -> a2, "vertexType" -> "+"|>
  },
  "lines" -> {
    <|"type" -> "massless", "endpoints" -> {1, 2}, "momentum" -> q1|>,
    <|"type" -> "massless", "endpoints" -> {1, 2}, "momentum" -> q2|>
  },
  "thetaBundles" -> {{1, 2}}
|>;
timeContext = MSInitTimeGraph[timeSpec];
timeMasters = MSMasterIntegrals[timeContext];
timeDE = MSDLogDE[timeContext];

(* 一个 chamber 先积较靠近零点的时间，得到标准 Gauss 2F1；另一 chamber 交换两顶点。
   两条共 theta 的 massless 线只通过 Q=q1+q2 进入指数，状态奇偶给出 m0/m1。 *)
orderedIntegral[aValue_, bValue_, lambdaA_, lambdaB_] := Module[
  {weight = aValue + bValue + 2},
  Gamma[weight] lambdaB^(-weight) Hypergeometric2F1[
    weight, aValue + 1, aValue + 2, -lambdaA/lambdaB
  ]/(aValue + 1)
];
qTotal = q1 + q2;
firstChamber = orderedIntegral[1, 1, -I k1 - I qTotal, -I k2 + I qTotal];
secondChamber = orderedIntegral[1, 1, -I k2 - I qTotal, -I k1 + I qTotal];
timeEven = firstChamber + secondChamber;
timeOdd = -firstChamber + secondChamber;
timeChild = Gamma[4] (-I (k1 + k2))^-4;
timeExpectedSymbolic = {timeEven, timeOdd, timeOdd, timeEven, timeChild, timeChild};
timeConnectionK1 = Map[D[#, k1] &, timeDE["omegaPotential"], {2}];
timeConnectionK2 = Map[D[#, k2] &, timeDE["omegaPotential"], {2}];
timeDEResidual = Together@FullSimplify@FunctionExpand@Join[
  D[timeExpectedSymbolic, k1] - timeConnectionK1.timeExpectedSymbolic,
  D[timeExpectedSymbolic, k2] - timeConnectionK2.timeExpectedSymbolic
] /. {a1 -> 1, a2 -> 1};
timeTargetRules = {k1 -> 9 I, k2 -> 3 I, q1 -> 1, q2 -> 2, a1 -> 1, a2 -> 1};
timePointSequence = {{k1, k2}, {9 I, 3 I}};
timeBoundary = MSBoundaryData[
  timeContext,
  timeTargetRules,
  BoundaryScale -> 4,
  BoundarySeriesOrder -> 18,
  RankOrder -> {1, 2},
  WorkingPrecision -> 50
];

(* 所有六个 mode 在 a1=a2=1 时同为 t^4。闭式沿 package 公开的 singular curve
   展开，但系数由上面的独立 chamber 解给出，不读取 package leading vector 生成 expected。 *)
timeSingularParameter = timeBoundary["singularParameter"];
timeExpectedAlongBoundary = timeExpectedSymbolic /.
  {q1 -> 1, q2 -> 2, a1 -> 1, a2 -> 1} /.
  timeBoundary["singularCurveRules"];
timeExpectedLeadingVector = Map[
  SeriesCoefficient[FunctionExpand[#], {timeSingularParameter, 0, 4}] &,
  timeExpectedAlongBoundary
];
timePackageLeadingVector = Total[
  (# ["physicalWeight"] # ["normalizedLeadingVector"]) & /@
    Select[timeBoundary["leadingBranches"], # ["frobeniusExponent"] === 4 &]
];
timeBoundaryDifference = Max[Abs@N[
  timePackageLeadingVector - timeExpectedLeadingVector,
  40
]];
{timeTransportSeconds, timeEvaluation} = AbsoluteTiming[MSEvaluatePath[
  timeContext,
  timePointSequence,
  ParameterRules -> {q1 -> 1, q2 -> 2, a1 -> 1, a2 -> 1},
  PythonExecutable -> pythonExecutable,
  MSRuntimeDirectory -> FileNameJoin[{tempRoot, "timegraph"}],
  FlintNDEPathPlanning -> True,
  BoundaryScale -> 4,
  BoundarySeriesOrder -> 18,
  RankOrder -> {1, 2},
  WorkingPrecision -> 50,
  TransportOrder -> 72,
  ReferenceTransportOrder -> 96,
  TargetRelativeError -> "1e-20"
]];
timeExpectedValue = N[timeExpectedSymbolic /. timeTargetRules, 45];
timeValueDifference = relativeVectorDifference[
  timeEvaluation["values"], timeExpectedValue, 10^-40
];


(* ::Chapter:: *)
(*自适应 regulator 重建与候选池耗尽反例*)

(* 保持晚时幂 2+ep 正则，并由 normalization r=(1+ep)/ep 引入 pole。
   精确解是 ((1+ep)/ep) Gamma[2+ep] 3^(-2-ep)。 *)
epPointSequence = {{k0}, {3 I}};
regulatorContext = MSInitVertexFamily[
  <|"ki" -> {k0}, "nui" -> {a}, "normalization" -> r|>
];
epProductionCandidates = {
  1/100, 1/110, 1/120, 1/130, 1/140, 1/150, 1/160, 1/170
};
epValidationCandidates = {1/211, 1/223};
{adaptiveEpSeconds, adaptiveEp} = AbsoluteTiming[MSReconstructEpSeries[
  regulatorContext,
  ep,
  epPointSequence,
  ParameterRules -> {a -> 1 + ep, r -> (1 + ep)/ep},
  MaximumEpPower -> 0,
  EpGoalDigits -> 6,
  EpFitExtraOrder -> 0,
  EpSamplePoints -> epProductionCandidates,
  EpValidationPoints -> epValidationCandidates,
  EpInitialInternalMaximumPower -> 0,
  EpFitOrderIncrement -> 2,
  EpFitMaximumRounds -> 3,
  ParallelTaskCount -> 4,
  PythonExecutable -> pythonExecutable,
  MSRuntimeDirectory -> FileNameJoin[{tempRoot, "ep-adaptive"}],
  BoundaryScale -> 4,
  BoundarySeriesOrder -> 18,
  FlintNDEPathPlanning -> True,
  MessageLanguage -> "EN"
]];
expectedPoleCoefficient = 1/9;
expectedFiniteCoefficient = (2 - EulerGamma - Log[3])/9;
adaptivePoleDifference = Abs[First[adaptiveEp["coefficients", -1]] - expectedPoleCoefficient];
adaptiveFiniteDifference = Abs[
  First[adaptiveEp["coefficients", 0]] - N[expectedFiniteCoefficient, 40]
];
adaptiveHistory = adaptiveEp["productionHistory"];

{exhaustedEpSeconds, exhaustedEp} = AbsoluteTiming[MSReconstructEpSeries[
  regulatorContext,
  ep,
  epPointSequence,
  ParameterRules -> {a -> 1 + ep, r -> (1 + ep)/ep},
  MaximumEpPower -> 0,
  EpGoalDigits -> 12,
  EpFitExtraOrder -> 0,
  EpSamplePoints -> Take[epProductionCandidates, 2],
  EpValidationPoints -> epValidationCandidates,
  EpInitialInternalMaximumPower -> 0,
  EpFitOrderIncrement -> 2,
  EpFitMaximumRounds -> 1,
  ParallelTaskCount -> 4,
  PythonExecutable -> pythonExecutable,
  MSRuntimeDirectory -> FileNameJoin[{tempRoot, "ep-exhausted"}],
  BoundaryScale -> 4,
  BoundarySeriesOrder -> 18,
  FlintNDEPathPlanning -> True,
  MessageLanguage -> "EN"
]];


(* ::Chapter:: *)
(*CSV/JSON round-trip 与缺点负例*)

savedOrdinary = First[timeEvaluation["pointResults"]];
transientWaypoint = Join[
  savedOrdinary,
  <|"coordinate" -> {k1 -> 8 I, k2 -> 4 I}, "status" -> "waypoint",
    "value" -> ConstantArray[999, 6]|>
];
savedInfinity = <|
  "coordinate" -> {k1 -> 12 I, k2 -> 0},
  "userIndex" -> 2,
  "status" -> "saved",
  "value" -> Join[{"Infinity"}, ConstantArray[0, 5]],
  "flintNDE" -> <|"relativeDifferenceInf" -> "1e-30",
    "targetRelativeErrorMet" -> True|>
|>;
exportInput = <|
  "status" -> "computed",
  "pointResults" -> {savedOrdinary, transientWaypoint, savedInfinity}
|>;
exportDirectory = FileNameJoin[{tempRoot, "export-roundtrip"}];
exportResult = MSExportEvaluationData[
  exportInput,
  MSOutputDirectory -> exportDirectory,
  ExportFormats -> {"CSV", "JSON"},
  SignificantDigits -> 24
];
jsonPath = FileNameJoin[{exportDirectory, "evaluation_data.json"}];
csvPath = FileNameJoin[{exportDirectory, "evaluation_data.csv"}];
jsonRoundTrip = Import[jsonPath, "RawJSON"];
csvRoundTrip = Import[csvPath, "CSV"];
missingSavedPoint = MSExportEvaluationData[
  <|"status" -> "computed", "pointResults" -> {transientWaypoint}|>,
  MSOutputDirectory -> FileNameJoin[{tempRoot, "missing-saved"}]
];


(* ::Chapter:: *)
(*验收、机器摘要与 UTF-8 报告*)

checks = <|
  "version" -> TrueQ[MadStree`Private`$MadStreeVersion === "0.17"],
  "vertexContextKind" -> Lookup[vertexContext, "contextKind", None] === "vertexFamily",
  "vertexOneMaster" -> Length[vertexMasters] === 1,
  "vertexDLogExact" -> vertexDEResidual === {0},
  "vertexBoundaryClosedForm" -> vertexBoundaryResidual === 0 &&
    vertexBoundaryBranch["frobeniusExponent"] === 2,
  "vertexOrdinaryClosedForm" -> TrueQ[vertexValueDifference < 10^-20],
  "timeGraphIsCyclic" -> Lookup[timeContext, "topologyClass", None] === "cyclicTimeOnly",
  "timeGraphMasterOrder" -> Lookup[timeMasters, "integral"] === {
    MSIntegral["11", {0, 0}, {0, 0}], MSIntegral["11", {0, 0}, {0, 1}],
    MSIntegral["11", {0, 0}, {1, 0}], MSIntegral["11", {0, 0}, {1, 1}],
    MSIntegral["01", {0}, {0}], MSIntegral["10", {0}, {0}]
  },
  "timeGraphDLogExact" -> And @@ (PossibleZeroQ /@ timeDEResidual),
  "timeGraphBoundaryClosedForm" -> TrueQ[timeBoundaryDifference < 10^-28],
  "timeGraphOrdinaryClosedForm" -> TrueQ[timeValueDifference < 10^-18],
  "adaptiveLeadingPower" -> adaptiveEp["leadingPower"] === -1,
  "adaptivePointsDisjoint" -> Intersection[
    adaptiveEp["productionEpValues"], adaptiveEp["validationEpValues"]
  ] === {},
  "adaptiveExpandedAndReused" -> Length[adaptiveHistory] >= 2 &&
    Lookup[adaptiveHistory[[2]], "reusedProductionPointCount", 0] > 0 &&
    Lookup[adaptiveHistory[[2]], "newProductionPointCount", 0] > 0 &&
    Lookup[adaptiveHistory[[2]], "reusedValidationPointCount", 0] > 0,
  "adaptivePrecisionMet" -> TrueQ[adaptiveEp["precisionTargetMet"]],
  "adaptivePoleCoefficient" -> TrueQ[N[adaptivePoleDifference, 30] < 10^-5],
  "adaptiveFiniteCoefficient" -> TrueQ[N[adaptiveFiniteDifference, 30] < 10^-4],
  "candidatePoolWarningReturned" -> AssociationQ[exhaustedEp] &&
    exhaustedEp["status"] === "computed_with_warning" &&
    ! TrueQ[exhaustedEp["precisionTargetMet"]] &&
    exhaustedEp["precisionFailureReason"] === "candidate_pool_exhausted" &&
    KeyExistsQ[exhaustedEp["coefficients"], 0],
  "exportWritten" -> exportResult["status"] === "written" &&
    exportResult["pointCount"] === 2,
  "waypointExcluded" -> jsonRoundTrip["pointCount"] === 2 &&
    FreeQ[jsonRoundTrip, 999],
  "infinityAndPrecisionRoundTrip" ->
    jsonRoundTrip["values"][[2, 1, "real"]] === "Infinity" &&
    jsonRoundTrip["relativeDifferenceInf"][[2]] === "1e-30" &&
    TrueQ[jsonRoundTrip["targetRelativeErrorMet"][[2]]],
  "csvRoundTrip" -> Length[csvRoundTrip] === 3 &&
    MemberQ[First[csvRoundTrip], "relativeDifferenceInf"],
  "missingSavedPointFailsClosed" -> MatchQ[
    missingSavedPoint, Failure["SavedPointResultsRequired", _Association]
  ]
|>;
passedCount = Count[Values[checks], True];
status = If[passedCount === Length[checks], "passed", "failed"];
wallTimeSeconds = N[AbsoluteTime[] - validationStart];

summary = <|
  "schema" -> "madstree_v0.17_validation_06_v1",
  "status" -> status,
  "passedCount" -> passedCount,
  "checkCount" -> Length[checks],
  "sourceRoot" -> versionRoot,
  "sourceDigestSHA256" -> sourceDigest,
  "convention" -> <|
    "vertexIntegral" -> "Gamma[a+1] (-I k0)^(-a-1)",
    "timeGraph" -> "two parallel massless ++ lines with one common theta bundle",
    "masterOrder" -> Lookup[timeMasters, "integral"]
  |>,
  "numericalPoints" -> <|"vertex" -> vertexTargetRules, "timeGraph" -> timeTargetRules|>,
  "actualPaths" -> <|
    "vertex" -> Lookup[vertexEvaluation, "segments", {}],
    "timeGraph" -> Lookup[timeEvaluation, "segments", {}]
  |>,
  "ordersAndPrecision" -> <|
    "vertex" -> <|"workingPrecision" -> 50, "boundarySeriesOrder" -> 16,
      "transportOrder" -> 64, "referenceTransportOrder" -> 88,
      "targetRelativeError" -> "1e-22"|>,
    "timeGraph" -> <|"workingPrecision" -> 50, "boundarySeriesOrder" -> 18,
      "transportOrder" -> 72, "referenceTransportOrder" -> 96,
      "targetRelativeError" -> "1e-20"|>,
    "regulator" -> <|"goalDigits" -> 6, "initialInternalMaximumPower" -> 0,
      "fitOrderIncrement" -> 2, "maximumRounds" -> 3|>
  |>,
  "exactResiduals" -> <|
    "vertexDE" -> vertexDEResidual,
    "vertexBoundary" -> vertexBoundaryResidual,
    "timeGraphDE" -> timeDEResidual,
    "timeGraphBoundaryMaximumDifference" -> timeBoundaryDifference
  |>,
  "ordinaryPointDifferences" -> <|
    "vertexRelative" -> vertexValueDifference,
    "timeGraphRelative" -> timeValueDifference
  |>,
  "regulator" -> <|
    "expectedPole" -> expectedPoleCoefficient,
    "expectedFinite" -> expectedFiniteCoefficient,
    "adaptiveResult" -> KeyDrop[adaptiveEp, "pointEvaluations"],
    "poleDifference" -> adaptivePoleDifference,
    "finiteDifference" -> adaptiveFiniteDifference,
    "exhaustedResult" -> KeyDrop[exhaustedEp, "pointEvaluations"]
  |>,
  "export" -> <|"result" -> exportResult, "json" -> jsonRoundTrip,
    "csvRowCount" -> Length[csvRoundTrip], "missingSavedPoint" -> missingSavedPoint|>,
  "timingsSeconds" -> <|
    "vertexTransport" -> vertexTransportSeconds,
    "timeGraphTransport" -> timeTransportSeconds,
    "adaptiveRegulator" -> adaptiveEpSeconds,
    "exhaustedRegulator" -> exhaustedEpSeconds,
    "total" -> wallTimeSeconds
  |>,
  "checks" -> checks
|>;
summaryWriteResult = writeUTF8Text[
  summaryPath,
  ToString[summary, InputForm, PageWidth -> Infinity] <> "\n"
];
If[summaryWriteResult === $Failed,
  Print["The validation summary could not be written, so this case is not marked as passed."];
  Exit[1]
];

report = StringRiffle[{
  "# MadStree v0.17 Validation-06 独立报告", "",
  "- 状态：**" <> status <> "**，" <> ToString[passedCount] <> "/" <>
    ToString[Length[checks]] <> "。",
  "- 源码聚合 SHA-256：`" <> sourceDigest <> "`。",
  "- 独立 oracle：单顶点 Gamma 积分；平行双 massless 线的两时间排序 chamber 闭式。", "",
  "## 单顶点与 cyclic time graph", "",
  "单顶点 master/dlog、边界 `t^2` leading weight 和 `k0=3 i` 普通点均与 `Gamma[a+1](-i k0)^(-a-1)` 比较。",
  "time graph 为两条平行 massless `++` 线的真实 cycle；四个 top 状态和两个 contact child 共 6 个 master。",
  "time graph 两变量 DE exact residual、边界 `t^4` leading vector 与普通点六分量差均写入 `results/summary.wl`。", "",
  "## Regulator", "",
  "令 `a=1+ep` 且 normalization 为 `(1+ep)/ep`，闭式为 `((1+ep)/ep) Gamma[2+ep] 3^(-2-ep)`；最低幂为 `ep^-1`。",
  "生产点与验证点不相交；首轮内部最高幂 0，失败后增 2 阶并复用旧生产/验证点。",
  "两点候选池反例返回 `computed_with_warning/candidate_pool_exhausted`，同时保留当前最佳系数。", "",
  "## 导出、路径与耗时", "",
  "CSV/JSON 只保留两个 `saved` 记录，排除临时 waypoint；字符串 `Infinity`、相对差和精度门禁字段完成 round-trip。",
  "无 saved 点时返回 `SavedPointResultsRequired`。",
  "实际路径、边界/输运阶和各阶段 wall time 均见机器摘要；总 wall time：`" <>
    ToString[wallTimeSeconds] <> " s`。", ""
}, "\n"];
reportWriteResult = writeUTF8Text[reportPath, StringTrim[repairSourceUTF8[report]] <> "\n"];
If[reportWriteResult === $Failed,
  Print["The validation report could not be written, so this case is not marked as passed."];
  Exit[1]
];

Print["MadStree Validation-06: ", passedCount, "/", Length[checks], " checks passed."];
If[status =!= "passed",
  Print["Failed checks: ", InputForm[Keys@Select[checks, Not@TrueQ[#] &]]];
  Exit[1]
];
