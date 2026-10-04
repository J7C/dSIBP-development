(* ::Package:: *)

(***
文件：run_validation.wls
用途：独立验证 Gamma 极点、时间-IBP 安全层、+++ massive 三顶点定义求导、局部张量快路与公开反馈。
独立来源：expected 只使用 Gamma 积分、固定的 h 小时间两支领头幂次表和指数因子对外腿能量的导数；
          不读取开发测试、旧 summary 或 MadStree 的 recurrence/time-IBP metadata 生成 expected。
输出：从空目录生成 results/summary.wl 与 UTF-8 Markdown 报告；所有运行时文件只进入本 case 的 results_temp。
***)

(* ::Chapter:: *)
(*路径、fresh 清理与公共工具*)

$CharacterEncoding = "UTF-8";
$MaxExtraPrecision = 10000;
validationStart = AbsoluteTime[];
caseRoot = DirectoryName[$InputFileName];
projectRoot = DirectoryName[DirectoryName[DirectoryName[caseRoot]]];
versionRoot = FileNameJoin[{projectRoot, "package-MadStree", "versions", "MadStree-v0.17"}];
kernelRoot = FileNameJoin[{versionRoot, "Kernel"}];
resultsRoot = FileNameJoin[{caseRoot, "results"}];
tempRoot = FileNameJoin[{caseRoot, "results_temp"}];
reportPath = FileNameJoin[{caseRoot,
  "000_MadStree-v0.17-validation-08-gamma-time-ibp-and-feedback-report.md"}];
summaryPath = FileNameJoin[{resultsRoot, "summary.wl"}];

Scan[If[DirectoryQ[#], DeleteDirectory[#, DeleteContents -> True]] &, {resultsRoot, tempRoot}];
If[FileExistsQ[reportPath], DeleteFile[reportPath]];
CreateDirectory[resultsRoot, CreateIntermediateDirectories -> True];
CreateDirectory[tempRoot, CreateIntermediateDirectories -> True];

sourceFiles = Sort[FileNames["*.wl", kernelRoot, Infinity]];
sourceDigest = Hash[FileHash[#, "SHA256"] & /@ sourceFiles, "SHA256", "HexString"];
sourceText = StringRiffle[Import[#, "Text", CharacterEncoding -> "UTF-8"] & /@ sourceFiles, "\n"];
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

exactZeroQ[value_] := TrueQ[PossibleZeroQ[Simplify[value]]];
exactZeroMatrixQ[matrix_] := MatrixQ[matrix] && And @@ (exactZeroQ /@ Flatten[matrix]);
offDiagonalPart[matrix_] := Simplify[matrix - DiagonalMatrix[Diagonal[matrix]]];

AppendTo[$Path, kernelRoot];
Needs["MadStree`"];


(* ::Chapter:: *)
(*Gamma 亚纯边界与非正整数极点*)

gammaContext = MSInitVertexFamily[<|"ki" -> {k0}, "nui" -> {a}|>];
finiteGammaArguments = {3/2, -1/2, I/3};
finiteBoundaries = Association@Table[
  alpha -> MSBoundaryData[
    gammaContext,
    {k0 -> 3 I, a -> alpha - 1},
    BoundaryScale -> 4,
    BoundarySeriesOrder -> 12,
    WorkingPrecision -> 70
  ],
  {alpha, finiteGammaArguments}
];
finiteCoefficientResiduals = Association@Table[
  alpha -> Simplify[
    finiteBoundaries[alpha]["leadingBranches"][[1, "componentData", 1, "coefficient"]] -
      (-I)^alpha Gamma[alpha]
  ],
  {alpha, finiteGammaArguments}
];

poleSampleArguments = Range[-16, 0];
poleFailures = Association@Table[
  alpha -> Quiet@MSBoundaryData[
    gammaContext,
    {k0 -> 3 I, a -> alpha - 1},
    BoundaryScale -> 4,
    BoundarySeriesOrder -> 12,
    WorkingPrecision -> 70
  ],
  {alpha, poleSampleArguments}
];
predicateAuditValues = Join[Range[-24, 24], {-7/3, -1/2, I/3, 2/5}];
predicateResiduals = Association@Table[
  value -> (TrueQ[MadStree`Private`msBoundaryGammaPoleQ[value]] ===
    (IntegerQ[value] && value <= 0)),
  {value, predicateAuditValues}
];


(* ::Chapter:: *)
(*固定小时间幂表与时间-IBP 安全层*)

(* 独立表直接写出 h=z^(+/-nu)H_nu 的两支领头幂次；state 1 的零次幂支从下一项开始。 *)
independentSmallTPowers[slot_Association, state_Integer] := Module[
  {nu = slot["hankelOrder"], prefactor = slot["hPrefactorPower"]},
  Which[
    exactZeroQ[prefactor - nu],
      If[state === 0, Simplify /@ {0, 2 nu}, Simplify /@ {1, 2 nu - 1}],
    exactZeroQ[prefactor + nu],
      If[state === 0, Simplify /@ {-2 nu, 0}, Simplify /@ {-2 nu - 1, 1}],
    True,
      Failure["IndependentSmallTTableNotApplicable", <|"slot" -> slot, "state" -> state|>]
  ]
];

independentComponentRecord[sector_Association, componentPosition_Integer, stateBits_List] := Module[
  {component, slots, tables, selections, records, integerRecords, positiveRecords,
   nonPositiveRecords, minimumSafeShift},
  component = sector["vertexComponents"][[componentPosition]];
  slots = Select[
    MapIndexed[Append[#1, "slotPosition" -> First[#2]] &, sector["slots"]],
    #1["kind"] === "massiveEndpoint" && MemberQ[component, #1["rootVertex"]] &
  ];
  tables = independentSmallTPowers[#, stateBits[[#1["slotPosition"]]]] & /@ slots;
  If[! FreeQ[tables, _Failure], Return[FirstCase[tables, _Failure]]];
  selections = If[slots === {}, {{}}, Tuples[ConstantArray[{1, 2}, Length[slots]]]];
  records = MapIndexed[
    Function[{selection, index},
      With[{powers = MapThread[Part, {tables, selection}]},
        <|
          "branchOrdinal" -> First[index],
          "branchSelection" -> selection,
          "slotKeys" -> Lookup[slots, "key", {}],
          "slotStates" -> If[slots === {}, {}, stateBits[[Lookup[slots, "slotPosition"]]]],
          "branchPowers" -> powers,
          "gammaArgumentAtMaster" -> Simplify[
            sector["baseTimePowers"][[componentPosition]] + 1 + Total[powers]
          ]
        |>
      ]
    ],
    selections
  ];
  integerRecords = Select[records, IntegerQ[Simplify[#1["gammaArgumentAtMaster"]]] &];
  positiveRecords = Select[integerRecords, TrueQ[#1["gammaArgumentAtMaster"] > 0] &];
  nonPositiveRecords = Select[integerRecords, TrueQ[#1["gammaArgumentAtMaster"] <= 0] &];
  minimumSafeShift = If[
    positiveRecords === {},
    -Infinity,
    Max[1 - Lookup[positiveRecords, "gammaArgumentAtMaster"]]
  ];
  <|
    "sectorKey" -> sector["sectorKey"],
    "componentPosition" -> componentPosition,
    "vertexIds" -> component,
    "stateBits" -> stateBits,
    "hCount" -> Length[slots],
    "branchCount" -> Length[records],
    "branchRecords" -> records,
    "integerBranchRecords" -> integerRecords,
    "positiveIntegerBranchRecords" -> positiveRecords,
    "nonPositiveIntegerBranchRecords" -> nonPositiveRecords,
    "minimumSafeShift" -> minimumSafeShift
  |>
];

twoHContext = MSInitTree[<|
  "vertices" -> {
    <|"id" -> 7, "externalLegEnergy" -> p, "timePower" -> 1, "vertexType" -> "+"|>
  },
  "lines" -> {
    <|"type" -> "massive", "endpoints" -> {7}, "momentum" -> q1, "nu" -> 1/2|>,
    <|"type" -> "massive", "endpoints" -> {7}, "momentum" -> q2, "nu" -> 1/2|>
  }
|>];
expectedSmallTRecords = Flatten@Table[
  independentComponentRecord[sector, componentPosition, stateBits],
  {sector, twoHContext["sectors"]},
  {stateBits, sector["stateOrder"]},
  {componentPosition, Length[sector["vertexComponents"]]}
];
actualSmallTRecords = twoHContext["timeIBPDomainCertificate", "componentRecords"];
smallTRecordResiduals = MapThread[
  Simplify[#1 === #2] &,
  {actualSmallTRecords, expectedSmallTRecords}
];

integerContext = MSInitTree[<|
  "vertices" -> {
    <|"id" -> 1, "externalLegEnergy" -> e, "timePower" -> 1, "vertexType" -> "+"|>
  },
  "lines" -> {}
|>];
integerSectorKey = First[integerContext["sectorOrder"]];
safeIntegral = MSIntegral[integerSectorKey, {-1}, {}];
unsafeIntegral = MSIntegral[integerSectorKey, {-2}, {}];
safeStep = MSRecurrenceStep[safeIntegral, integerContext];
safeReduction = MSReduce[safeIntegral, integerContext];
unsafeReduction = MSReduce[unsafeIntegral, integerContext];
masterPoleFailure = MSInitTree[<|
  "vertices" -> {
    <|"id" -> 9, "externalLegEnergy" -> epole, "timePower" -> -1,
      "vertexType" -> "+"|>
  },
  "lines" -> {}
|>];


(* ::Chapter:: *)
(*非零 regulator 点的 Laurent 重建*)

epPointSequence = {{k0}, {3 I}};
epProductionCandidates = {1/100, 1/110, 1/120, 1/130, 1/140, 1/150, 1/160, 1/170};
epValidationCandidates = {1/211, 1/223};
{epSeconds, epReconstruction} = AbsoluteTiming[MSReconstructEpSeries[
  gammaContext,
  ep,
  epPointSequence,
  ParameterRules -> {a -> -1 + ep},
  MaximumEpPower -> 0,
  EpGoalDigits -> 5,
  EpFitExtraOrder -> 0,
  EpSamplePoints -> epProductionCandidates,
  EpValidationPoints -> epValidationCandidates,
  EpInitialInternalMaximumPower -> 0,
  EpFitOrderIncrement -> 2,
  EpFitMaximumRounds -> 2,
  ParallelTaskCount -> 4,
  PythonExecutable -> pythonExecutable,
  MSRuntimeDirectory -> FileNameJoin[{tempRoot, "ep-reconstruction"}],
  BoundaryScale -> 4,
  BoundarySeriesOrder -> 18,
  WorkingPrecision -> 50,
  MessageLanguage -> "EN"
]];
directEpZeroBoundary = Quiet@MSBoundaryData[
  gammaContext,
  {k0 -> 3 I, a -> -1},
  BoundaryScale -> 4,
  BoundarySeriesOrder -> 18,
  WorkingPrecision -> 50
];
epComputedQ = AssociationQ[epReconstruction] &&
  MemberQ[{"computed", "computed_with_warning"}, Lookup[epReconstruction, "status", None]];
epPoleDifference = If[
  epComputedQ && KeyExistsQ[Lookup[epReconstruction, "coefficients", <||>], -1],
  Abs[First[epReconstruction["coefficients", -1]] - 1],
  Infinity
];
epFiniteDifference = If[
  epComputedQ && KeyExistsQ[Lookup[epReconstruction, "coefficients", <||>], 0],
  Abs[First[epReconstruction["coefficients", 0]] - N[-EulerGamma - Log[3], 40]],
  Infinity
];
usedEpValues = If[
  AssociationQ[epReconstruction],
  Join[
    Lookup[epReconstruction, "productionEpValues", {}],
    Lookup[epReconstruction, "validationEpValues", {}]
  ],
  {}
];

productionPlanActual = If[
  AssociationQ[epReconstruction],
  Lookup[epReconstruction, "productionPlan", <||>],
  <||>
];

(* 只保留复核数值路线所需的轻量字段，避免把完整向量和局部解缓存写入正式 summary。 *)
epPathSummary[record_Association] := Module[
  {epValue, evaluation, backend, segments, planReports},
  epValue = Lookup[record, "ep", Missing["EpValue"]];
  evaluation = Lookup[record, "evaluation", <||>];
  backend = Lookup[evaluation, "flintNDE", <||>];
  segments = Lookup[backend, "segments", {}];
  planReports = Lookup[segments, "planReport", {}];
  <|
    "ep" -> epValue,
    "role" -> If[MemberQ[Lookup[epReconstruction, "productionEpValues", {}], epValue],
      "production", "validation"],
    "executionAction" -> Lookup[backend, "executionAction", Missing["NotAvailable"]],
    "boundaryPath" -> Lookup[Lookup[backend, "boundary", <||>], "path", {}],
    "boundaryPathPointCount" -> Lookup[
      Lookup[backend, "boundary", <||>], "pathPointCount", 0
    ],
    "segmentCount" -> Lookup[backend, "segmentCount", Length[segments]],
    "segments" -> Map[
      <|
        "segmentIndex" -> Lookup[#, "segmentIndex", Missing["NotAvailable"]],
        "actualNodes" -> Lookup[#, "actualNodes", {}],
        "nodeCount" -> Lookup[#, "nodeCount", 0],
        "relativeDifferenceInf" -> Lookup[#, "relativeDifferenceInf", None],
        "targetRelativeErrorMet" -> Lookup[#, "targetRelativeErrorMet", False],
        "singularityJumpCount" -> Lookup[
          Lookup[#, "planReport", <||>], "singularity_jump_count", 0
        ]
      |> &,
      segments
    ],
    "totalNodeCount" -> Total[Lookup[segments, "nodeCount", 0]],
    "singularityJumpCount" -> Total[
      Lookup[planReports, "singularity_jump_count", 0]
    ],
    "targetRelativeErrorMet" -> Lookup[backend, "targetRelativeErrorMet", False],
    "planningSeconds" -> Lookup[backend, "planningSeconds", Missing["NotAvailable"]],
    "primarySeconds" -> Lookup[backend, "primarySeconds", Missing["NotAvailable"]],
    "referenceSeconds" -> Lookup[backend, "referenceSeconds", Missing["NotAvailable"]]
  |>
];

epPathSummaries = If[
  AssociationQ[epReconstruction],
  epPathSummary /@ Lookup[epReconstruction, "pointEvaluations", {}],
  {}
];


(* ::Chapter:: *)
(*+++ massive 三顶点定义求导与公式 dlog*)

tripleContext = MSInitTree[<|
  "vertices" -> {
    <|"id" -> 1, "externalLegEnergy" -> e1, "timePower" -> 1, "vertexType" -> "+"|>,
    <|"id" -> 2, "externalLegEnergy" -> e2, "timePower" -> 1, "vertexType" -> "+"|>,
    <|"id" -> 3, "externalLegEnergy" -> e3, "timePower" -> 1, "vertexType" -> "+"|>
  },
  "lines" -> {
    <|"type" -> "massive", "endpoints" -> {1, 2}, "momentum" -> s1, "nu" -> 3/4|>,
    <|"type" -> "massive", "endpoints" -> {2, 3}, "momentum" -> s2, "nu" -> 1/3|>
  }
|>];
tripleMasters = Lookup[MSMasterIntegrals[tripleContext], "integral"];
tripleSectorByKey = AssociationThread[tripleContext["sectorOrder"] -> tripleContext["sectors"]];
tripleVertexByEnergy = AssociationThread[
  Lookup[tripleContext["vertices"], "externalLegEnergy"] -> tripleContext["vertices"]
];
tripleDE = MSDLogDE[tripleContext];
energyVariables = {e1, e2, e3};

definitionDerivativeRow[integral_MSIntegral, energy_Symbol] := Module[
  {sector, vertex, componentPosition, shiftedTimes, shiftedIntegral, reduced},
  sector = tripleSectorByKey[integral[[1]]];
  vertex = tripleVertexByEnergy[energy];
  componentPosition = First@FirstPosition[
    sector["vertexComponents"],
    component_ /; MemberQ[component, vertex["id"]]
  ];
  shiftedTimes = ReplacePart[
    integral[[2]],
    componentPosition -> integral[[2, componentPosition]] + 1
  ];
  shiftedIntegral = MSIntegral[integral[[1]], shiftedTimes, integral[[3]]];
  reduced = MSReduce[-I vertex["vertexSign"] shiftedIntegral, tripleContext];
  If[Head[reduced] === Failure || Lookup[reduced, "status", None] =!= "reduced" ||
      Lookup[reduced, "nonMasterResidual", Missing["Absent"]] =!= 0 ||
      Lookup[reduced, "remainingShiftedIntegrals", {Missing["Absent"]}] =!= {},
    Failure["DefinitionDerivativeReductionFailed", <|
      "integral" -> integral, "energy" -> energy, "result" -> reduced|>],
    reduced["coefficientVector"]
  ]
];

{definitionRouteSeconds, definitionMatrices} = AbsoluteTiming[Association@Table[
  energy -> (definitionDerivativeRow[#, energy] & /@ tripleMasters),
  {energy, energyVariables}
]];
definitionFailures = Cases[Values[definitionMatrices], _Failure, Infinity];
directMatrices = Association@Table[
  energy -> Map[Simplify, D[tripleDE["omegaPotential"], energy], {2}],
  {energy, energyVariables}
];
derivativeResidualMatrices = Association@Table[
  energy -> If[
    definitionFailures === {},
    Map[Simplify, definitionMatrices[energy] - directMatrices[energy], {2}],
    Missing["DefinitionRouteFailed"]
  ],
  {energy, energyVariables}
];
derivativeDifferenceCounts = Map[
  If[MatrixQ[#], Count[Flatten[#], value_ /; ! exactZeroQ[value]], Missing["NotCompared"]] &,
  derivativeResidualMatrices
];


(* ::Chapter:: *)
(*局部 Pauli 块与 Kronecker 张量快路*)

sigma1 = MadStree`Private`msSigma1;
sigma2 = MadStree`Private`msSigma2;
paperT = MadStree`Private`msPaperT;
paperTInverse = MadStree`Private`msPaperTInverse;
hadamard = MadStree`Private`msHadamard;
massiveLocalTransformed = Simplify[paperT.sigma2.paperTInverse];
masslessLocalTransformed = Simplify[hadamard.sigma1.hadamard];

masslessContext = MSInitTree[<|
  "vertices" -> {
    <|"id" -> 1, "externalLegEnergy" -> m1, "timePower" -> 1, "vertexType" -> "+"|>,
    <|"id" -> 2, "externalLegEnergy" -> m2, "timePower" -> 1, "vertexType" -> "+"|>
  },
  "lines" -> {
    <|"type" -> "massless", "endpoints" -> {1, 2}, "momentum" -> z1|>
  }
|>];
mixedContext = MSInitTree[<|
  "vertices" -> {
    <|"id" -> 1, "externalLegEnergy" -> x1, "timePower" -> 1, "vertexType" -> "+"|>,
    <|"id" -> 2, "externalLegEnergy" -> x2, "timePower" -> 1, "vertexType" -> "+"|>,
    <|"id" -> 3, "externalLegEnergy" -> x3, "timePower" -> 1, "vertexType" -> "+"|>
  },
  "lines" -> {
    <|"type" -> "massive", "endpoints" -> {1, 2}, "momentum" -> r1, "nu" -> 2/5|>,
    <|"type" -> "massless", "endpoints" -> {2, 3}, "momentum" -> r2|>
  }
|>];

tensorContexts = <|"massive" -> tripleContext, "massless" -> masslessContext,
  "mixed" -> mixedContext|>;
tensorRecords = Flatten@KeyValueMap[
  Function[{name, context},
    Flatten@Table[
      With[{data = MadStree`Private`msSectorM0DiagonalizationData[sector, componentPosition]},
        <|
          "context" -> name,
          "sectorKey" -> sector["sectorKey"],
          "componentPosition" -> componentPosition,
          "dimension" -> sector["masterCount"],
          "status" -> If[Head[data] === Failure, "failed", "certified"],
          "roundTripZeroQ" -> If[Head[data] === Failure, False,
            exactZeroMatrixQ[data["U"].data["UInverse"] -
              IdentityMatrix[sector["masterCount"]]]],
          "offDiagonalZeroQ" -> If[Head[data] === Failure, False,
            exactZeroMatrixQ[offDiagonalPart[data["diagonalMatrix"]]]]
        |>
      ],
      {sector, context["sectors"]},
      {componentPosition, Length[sector["vertexComponents"]]}
    ]
  ],
  tensorContexts
];

mixedTopSector = First@Select[mixedContext["sectors"], #1["sectorKey"] === "11" &];
mixedTopData = MadStree`Private`msSectorM0DiagonalizationData[mixedTopSector, 1];
expectedMixedSlotKinds = {"massiveEndpoint", "massiveEndpoint", "masslessShared"};
expectedMixedTransform = KroneckerProduct[paperT, paperT, hadamard];
mixedTransformResidual = Simplify[mixedTopData["U"] - expectedMixedTransform];

conflictingLocalBlock = sigma1 + sigma2;
conflictingBlockRejectsSingleBasisQ =
  ! exactZeroMatrixQ[offDiagonalPart[paperT.conflictingLocalBlock.paperTInverse]] &&
  ! exactZeroMatrixQ[offDiagonalPart[hadamard.conflictingLocalBlock.hadamard]];

formulaAndDESourceFiles = Select[
  sourceFiles,
  StringContainsQ[#, FileNameJoin[{"Kernel", "Formula"}]] ||
    StringContainsQ[#, FileNameJoin[{"Kernel", "DE"}]] &
];
formulaAndDESourceText = StringRiffle[
  Import[#, "Text", CharacterEncoding -> "UTF-8"] & /@ formulaAndDESourceFiles,
  "\n"
];
generalInverseMatches = StringCases[
  formulaAndDESourceText,
  RegularExpression["(^|[^A-Za-z0-9$`])Inverse\\["]
];
unstructuredSolveMatches = StringCases[
  formulaAndDESourceText,
  RegularExpression["(^|[^A-Za-z0-9$`])LinearSolve\\["]
];
legacyMasslessTokens = Select[
  {"RedundantH", "masslessEndpointH"},
  StringContainsQ[sourceText, #] &
];


(* ::Chapter:: *)
(*公开反馈触发矩阵*)

feedbackPointSequence = {{k0}, {3 I}};
backendCalls = 0;
missingParameterFailure = Block[{
    MadStree`Private`msExecuteFlintNDEAdapter = Function[{input, executable, runtime},
      backendCalls++; <|"status" -> "unexpected"|>]
  },
  MSEvaluatePath[
    gammaContext, feedbackPointSequence,
    ParameterRules -> "not-rules",
    MSRuntimeDirectory -> FileNameJoin[{tempRoot, "must-not-start-parameter"}]
  ]
];
missingParameterBackendCalls = backendCalls;

backendCalls = 0;
badHeaderFailure = Block[{
    MadStree`Private`msExecuteFlintNDEAdapter = Function[{input, executable, runtime},
      backendCalls++; <|"status" -> "unexpected"|>]
  },
  MSEvaluatePath[
    gammaContext, {{k0 -> 1}, {3 I}},
    ParameterRules -> {a -> 1/2},
    MSRuntimeDirectory -> FileNameJoin[{tempRoot, "must-not-start-header"}]
  ]
];
badHeaderBackendCalls = backendCalls;

backendCalls = 0;
uncertifiedDLogFailure = Block[{
    MadStree`MSDLogDE = Function[<|"dlogStatus" -> "nonDLogResidual"|>],
    MadStree`Private`msExecuteFlintNDEAdapter = Function[{input, executable, runtime},
      backendCalls++; <|"status" -> "unexpected"|>]
  },
  MSEvaluatePath[
    gammaContext, feedbackPointSequence,
    ParameterRules -> {a -> 1/2},
    MSRuntimeDirectory -> FileNameJoin[{tempRoot, "must-not-start-dlog"}]
  ]
];
uncertifiedDLogBackendCalls = backendCalls;

badBoundaryOrderFailure = MSBoundaryData[
  gammaContext,
  {k0 -> 3 I, a -> 1/2},
  BoundarySeriesOrder -> -1
];

backendCalls = 0;
badLanguageFailure = Block[{
    MadStree`Private`msExecuteFlintNDEAdapter = Function[{input, executable, runtime},
      backendCalls++; <|"status" -> "unexpected"|>]
  },
  MSEvaluatePath[
    gammaContext, feedbackPointSequence,
    ParameterRules -> {a -> 1/2},
    MessageLanguage -> "ZH",
    MSRuntimeDirectory -> FileNameJoin[{tempRoot, "must-not-start-language"}]
  ]
];
badLanguageBackendCalls = backendCalls;

backendCalls = 0;
flintUnavailableFailure = Block[{
    MadStree`Private`$MSFlintNDERelativePath = FileNameJoin[{"Vendor", "MissingFlintNDE"}],
    MadStree`Private`msExecuteFlintNDEAdapter = Function[{input, executable, runtime},
      backendCalls++; <|"status" -> "unexpected"|>]
  },
  MSEvaluatePath[
    gammaContext, feedbackPointSequence,
    ParameterRules -> {a -> 1/2},
    MSRuntimeDirectory -> FileNameJoin[{tempRoot, "must-not-start-flint"}]
  ]
];
flintUnavailableBackendCalls = backendCalls;

backendCalls = 0;
overlongRuntime = FileNameJoin[{tempRoot, StringJoin[ConstantArray["x", 300]]}];
overlongRuntimeFailure = Block[{
    MadStree`Private`msExecuteFlintNDEAdapter = Function[{input, executable, runtime},
      backendCalls++; <|"status" -> "unexpected"|>]
  },
  MSEvaluatePath[
    gammaContext, feedbackPointSequence,
    ParameterRules -> {a -> 1/2},
    MSRuntimeDirectory -> overlongRuntime
  ]
];
overlongRuntimeBackendCalls = backendCalls;

backendCalls = 0;
singularRouteFailure = Block[{
    MadStree`Private`msExecuteFlintNDEAdapter = Function[{input, executable, runtime},
      backendCalls++;
      <|"status" -> "singularPathRefused",
        "message" -> "The supplied user segment crosses a certified singularity. Change the point sequence or enable the documented singular route.",
        "segmentIndex" -> 1,
        "singularPathPairs" -> {{0, 1}}|>
    ]
  },
  MSEvaluatePath[
    gammaContext, feedbackPointSequence,
    ParameterRules -> {a -> 1/2},
    SingularityMode -> "Avoid",
    PythonExecutable -> "MOCKED_BY_VALIDATION",
    MSRuntimeDirectory -> FileNameJoin[{tempRoot, "singular-route-mock"}]
  ]
];
singularRouteBackendCalls = backendCalls;

minimalEvaluation = <|
  "status" -> "computed",
  "pointResults" -> {<|
    "coordinate" -> {x -> 1/2},
    "userIndex" -> 1,
    "status" -> "saved",
    "value" -> {1 + I},
    "flintNDE" -> <|"relativeDifferenceInf" -> "0", "targetRelativeErrorMet" -> True|>
  |>}|>;
partialExportDirectory = FileNameJoin[{tempRoot, "partial-export"}];
CreateDirectory[
  FileNameJoin[{partialExportDirectory, "evaluation_data.json"}],
  CreateIntermediateDirectories -> True
];
partialExportFailure = MSExportEvaluationData[
  minimalEvaluation,
  MSOutputDirectory -> partialExportDirectory,
  ExportFormats -> {"CSV", "JSON"}
];

feedbackExpectations = <|
  "BoundaryGammaPole" -> <|"reason" -> "undefined because", "action" -> "add"|>,
  "TimeIBPMasterRequiresRegularization" -> <|"reason" -> "because", "action" -> "add"|>,
  "ParameterRulesRequired" -> <|"reason" -> "missing or incomplete", "action" -> "supply"|>,
  "EvaluationCoordinateHeader" -> <|"reason" -> "not a valid", "action" -> "correct"|>,
  "CertifiedDLogRequired" -> <|"reason" -> "not available", "action" -> "resolve"|>,
  "BoundarySeriesOrderMustBeNonNegative" -> <|"reason" -> "invalid", "action" -> "replace"|>,
  "MessageLanguage" -> <|"reason" -> "invalid", "action" -> "replace"|>,
  "FlintNDENotAvailable" -> <|"reason" -> "cannot find", "action" -> "check"|>,
  "RuntimePathTooLong" -> <|"reason" -> "too long", "action" -> "move"|>,
  "SingularPathOnUserPolyline" -> <|"reason" -> "crosses", "action" -> "change"|>,
  "EvaluationExportFailed" -> <|"reason" -> "could not", "action" -> "check"|>
|>;

feedbackRecord[name_String, expectedTag_String, value_, backendCallCount_Integer,
  expectedBackendCalls_Integer] := Module[
  {data, english, chinese, template, expectation, lastChineseCode},
  data = If[Head[value] === Failure, value[[2]], <||>];
  english = Lookup[data, "message", ""];
  chinese = Lookup[data, "messageCN", ""];
  template = Lookup[data, "MessageTemplate", ""];
  expectation = feedbackExpectations[expectedTag];
  lastChineseCode = If[chinese === "", Missing["Empty"],
    First@ToCharacterCode[StringTake[chinese, -1]]];
  <|
    "name" -> name,
    "expectedTag" -> expectedTag,
    "actualTag" -> If[Head[value] === Failure, value[[1]], Head[value]],
    "tagMatchedQ" -> MatchQ[value, Failure[expectedTag, _Association]],
    "message" -> english,
    "messageCN" -> chinese,
    "wolframDisplayText" -> template,
    "englishSentenceQ" -> StringLength[english] > 20 &&
      StringMatchQ[english, ___ ~~ ("." | "?" | "!")],
    "chineseSentenceQ" -> StringLength[chinese] > 10 &&
      MemberQ[{12290, 65311, 65281}, lastChineseCode],
    "reasonPresentQ" -> StringContainsQ[
      ToLowerCase[english], expectation["reason"]
    ],
    "nextStepPresentQ" -> StringContainsQ[
      ToLowerCase[english], expectation["action"]
    ],
    "backendCallCount" -> backendCallCount,
    "expectedBackendCallCount" -> expectedBackendCalls,
    "downstreamControlQ" -> backendCallCount === expectedBackendCalls
  |>
];

feedbackRecords = {
  feedbackRecord["Gamma pole", "BoundaryGammaPole", poleFailures[0], 0, 0],
  feedbackRecord["Integer time-IBP master", "TimeIBPMasterRequiresRegularization",
    masterPoleFailure, 0, 0],
  feedbackRecord["Missing ParameterRules", "ParameterRulesRequired",
    missingParameterFailure, missingParameterBackendCalls, 0],
  feedbackRecord["Invalid pointSequence header", "EvaluationCoordinateHeader",
    badHeaderFailure, badHeaderBackendCalls, 0],
  feedbackRecord["Uncertified dlog", "CertifiedDLogRequired",
    uncertifiedDLogFailure, uncertifiedDLogBackendCalls, 0],
  feedbackRecord["Negative boundary order", "BoundarySeriesOrderMustBeNonNegative",
    badBoundaryOrderFailure, 0, 0],
  feedbackRecord["Invalid message language", "MessageLanguage",
    badLanguageFailure, badLanguageBackendCalls, 0],
  feedbackRecord["FlintNDE unavailable", "FlintNDENotAvailable",
    flintUnavailableFailure, flintUnavailableBackendCalls, 0],
  feedbackRecord["Overlong runtime path", "RuntimePathTooLong",
    overlongRuntimeFailure, overlongRuntimeBackendCalls, 0],
  feedbackRecord["Singular route refused", "SingularPathOnUserPolyline",
    singularRouteFailure, singularRouteBackendCalls, 1],
  feedbackRecord["Partial export", "EvaluationExportFailed",
    partialExportFailure, 0, 0]
};

staticFailureTags = Sort@DeleteDuplicates@Flatten[StringCases[
  Import[#, "Text", CharacterEncoding -> "UTF-8"],
  RegularExpression["msFailure\\[\\s*\"([^\"]+)\""] -> "$1"
] & /@ sourceFiles];
triggeredFailureTags = Sort@DeleteDuplicates[Lookup[feedbackRecords, "actualTag"]];
uncoveredFailureTags = Complement[staticFailureTags, triggeredFailureTags];
publicExitInventory = <|
  "staticFailureTagCount" -> Length[staticFailureTags],
  "triggeredFailureTagCount" -> Length[triggeredFailureTags],
  "staticOnlyFailureTags" -> uncoveredFailureTags,
  "MessageCallCount" -> StringCount[sourceText, "Message["],
  "PrintCallCount" -> StringCount[sourceText, "Print["]
|>;


(* ::Chapter:: *)
(*验收、机器摘要与报告*)

checks = <|
  "version" -> TrueQ[MadStree`Private`$MadStreeVersion === "0.17"],
  "finiteGammaArgumentsAccepted" -> And @@ (
    Lookup[finiteBoundaries[#], "status", None] === "generated" & /@ finiteGammaArguments
  ),
  "finiteGammaCoefficientsExact" -> And @@ (exactZeroQ /@ Values[finiteCoefficientResiduals]),
  "allSampledNonPositiveIntegersRejected" -> And @@ (
    MatchQ[poleFailures[#], Failure["BoundaryGammaPole", _Association]] & /@ poleSampleArguments
  ),
  "singlePredicateMatchesMathematicalSet" -> And @@ Values[predicateResiduals],
  "allSmallTRecordsRebuiltIndependently" -> Length[actualSmallTRecords] ===
    Length[expectedSmallTRecords] && And @@ smallTRecordResiduals,
  "twoHEnumeratesFourBranches" -> And @@ (
    Lookup[#, "branchCount"] === 2^Lookup[#, "hCount"] & /@ actualSmallTRecords
  ),
  "positiveIntegerSafeShiftRecorded" ->
    integerContext["timeIBPDomainCertificate", "componentRecords"][[1, "minimumSafeShift"]] === -1,
  "safeShiftReduces" -> Lookup[safeStep, "status", None] === "reducedOneStep" &&
    Lookup[safeReduction, "status", None] === "reduced" &&
    safeReduction["nonMasterResidual"] === 0,
  "unsafeShiftRejected" -> MatchQ[
    unsafeReduction, Failure["TimeIBPShiftHitsDivergentLayer", _Association]
  ],
  "zeroShiftPoleRejectedAtInitialization" -> MatchQ[
    masterPoleFailure, Failure["TimeIBPMasterRequiresRegularization", _Association]
  ],
  "epSeriesComputed" -> epComputedQ,
  "epOnlyUsesNonzeroPoints" -> usedEpValues =!= {} && FreeQ[usedEpValues, 0],
  "directEpZeroBoundaryRejected" -> MatchQ[
    directEpZeroBoundary, Failure["BoundaryGammaPole", _Association]
  ],
  "epPoleCoefficient" -> TrueQ[N[epPoleDifference, 30] < 10^-4],
  "epFiniteCoefficient" -> TrueQ[N[epFiniteDifference, 30] < 10^-3],
  "actualProductionPlanRecorded" -> AssociationQ[productionPlanActual] &&
    And @@ (KeyExistsQ[productionPlanActual, #] & /@
      {"workingPrecisionDigits", "primaryOrder", "referenceOrder", "targetRelativeError"}),
  "actualEpPathsRecorded" -> Length[epPathSummaries] === Length[usedEpValues] &&
    epPathSummaries =!= {} && And @@ Map[
      Lookup[#, "executionAction", None] === "plan_and_execute" &&
        Lookup[#, "segmentCount", 0] >= 1 &&
        Lookup[#, "boundaryPathPointCount", 0] >= 2 &&
        TrueQ[Lookup[#, "targetRelativeErrorMet", False]] &,
      epPathSummaries
    ],
  "tripleMasterCount" -> Length[tripleMasters] === 25,
  "definitionDerivativeReductionsClosed" -> definitionFailures === {},
  "threeEnergyMatricesExact" -> Values[derivativeDifferenceCounts] === {0, 0, 0},
  "massiveLocalTransform" -> exactZeroMatrixQ[offDiagonalPart[massiveLocalTransformed]] &&
    exactZeroMatrixQ[paperT.paperTInverse - IdentityMatrix[2]],
  "masslessLocalTransform" -> exactZeroMatrixQ[offDiagonalPart[masslessLocalTransformed]] &&
    exactZeroMatrixQ[hadamard.hadamard - IdentityMatrix[2]],
  "allSectorTensorIdentities" -> And @@ Lookup[tensorRecords, "roundTripZeroQ"] &&
    And @@ Lookup[tensorRecords, "offDiagonalZeroQ"],
  "mixedKroneckerTransform" ->
    Lookup[mixedTopSector["slots"], "kind"] === expectedMixedSlotKinds &&
    exactZeroMatrixQ[mixedTransformResidual],
  "conflictingPauliDirectionsDetected" -> TrueQ[conflictingBlockRejectsSingleBasisQ],
  "noLegacyMasslessProductionTokens" -> legacyMasslessTokens === {},
  "noDenseInverseInFormulaRoute" -> generalInverseMatches === {} &&
    unstructuredSolveMatches === {},
  "allFeedbackTagsAndSentences" -> And @@ Map[
    And @@ Lookup[#, {"tagMatchedQ", "englishSentenceQ", "chineseSentenceQ",
      "reasonPresentQ", "nextStepPresentQ", "downstreamControlQ"}] &,
    feedbackRecords
  ],
  "partialExportCannotClaimWritten" -> MatchQ[
    partialExportFailure, Failure["EvaluationExportFailed", _Association]
  ] && FileExistsQ[FileNameJoin[{partialExportDirectory, "evaluation_data.csv"}]]
|>;

passedCount = Count[Values[checks], True];
status = If[passedCount === Length[checks], "passed", "failed"];
wallTimeSeconds = N[AbsoluteTime[] - validationStart];

summary = <|
  "schema" -> "madstree_v0.17_validation_08_v1",
  "status" -> status,
  "passedCount" -> passedCount,
  "checkCount" -> Length[checks],
  "sourceRoot" -> versionRoot,
  "sourceDigestSHA256" -> sourceDigest,
  "conventions" -> <|
    "gammaIntegral" -> "Integral[t^(alpha-1) Exp[-lambda t],{0,Infinity}]=Gamma[alpha] lambda^(-alpha)",
    "smallTTable" -> "h=z^(+/-nu) H_nu; state 1 is partial_z h",
    "energyDerivative" -> "partial_E Exp[-I vertexSign E t]=-I vertexSign t Exp[-I vertexSign E t]",
    "tensorRoute" -> "massive sigma2/paper T; massless quotient sigma1/Hadamard"
  |>,
  "gamma" -> <|
    "finiteArguments" -> finiteGammaArguments,
    "coefficientResiduals" -> finiteCoefficientResiduals,
    "poleSampleArguments" -> poleSampleArguments,
    "poleFailures" -> poleFailures,
    "predicateAudit" -> predicateResiduals
  |>,
  "timeIBP" -> <|
    "independentRecords" -> expectedSmallTRecords,
    "actualRecords" -> actualSmallTRecords,
    "recordResiduals" -> smallTRecordResiduals,
    "safeStep" -> safeStep,
    "safeReduction" -> safeReduction,
    "unsafeReduction" -> unsafeReduction,
    "masterPoleFailure" -> masterPoleFailure
  |>,
  "regulator" -> <|
    "closedForm" -> "Gamma[ep] 3^(-ep)",
    "expectedPole" -> 1,
    "expectedFinite" -> (-EulerGamma - Log[3]),
    "result" -> If[AssociationQ[epReconstruction],
      KeyDrop[epReconstruction, "pointEvaluations"], epReconstruction],
    "usedEpValues" -> usedEpValues,
    "pointPathSummaries" -> epPathSummaries,
    "poleDifference" -> epPoleDifference,
    "finiteDifference" -> epFiniteDifference,
    "directZero" -> directEpZeroBoundary
  |>,
  "definitionDerivative" -> <|
    "topology" -> "+++ three vertices with two massive lines",
    "masterOrder" -> tripleMasters,
    "matrixDimensions" -> AssociationMap[Dimensions, definitionMatrices],
    "definitionMatrices" -> definitionMatrices,
    "formulaMatrices" -> directMatrices,
    "residualMatrices" -> derivativeResidualMatrices,
    "differenceCounts" -> derivativeDifferenceCounts,
    "failures" -> definitionFailures
  |>,
  "tensorRoute" -> <|
    "massiveLocalTransformed" -> massiveLocalTransformed,
    "masslessLocalTransformed" -> masslessLocalTransformed,
    "sectorRecords" -> tensorRecords,
    "mixedTopSlotKinds" -> Lookup[mixedTopSector["slots"], "kind"],
    "expectedMixedTopSlotKinds" -> expectedMixedSlotKinds,
    "mixedTransformResidual" -> mixedTransformResidual,
    "conflictingLocalBlock" -> conflictingLocalBlock,
    "conflictingBlockRejectsSingleBasisQ" -> conflictingBlockRejectsSingleBasisQ,
    "legacyTokens" -> legacyMasslessTokens,
    "generalInverseMatches" -> generalInverseMatches,
    "unstructuredSolveMatches" -> unstructuredSolveMatches
  |>,
  "feedback" -> <|
    "records" -> feedbackRecords,
    "inventory" -> publicExitInventory
  |>,
  "ordersAndPrecision" -> <|
    "gammaBoundarySeriesOrder" -> 12,
    "regulatorBoundarySeriesOrder" -> 18,
    "workingPrecision" -> Lookup[
      productionPlanActual, "workingPrecisionDigits", Missing["NotAvailable"]
    ],
    "transportOrder" -> Lookup[
      productionPlanActual, "primaryOrder", Missing["NotAvailable"]
    ],
    "referenceTransportOrder" -> Lookup[
      productionPlanActual, "referenceOrder", Missing["NotAvailable"]
    ],
    "targetRelativeError" -> Lookup[
      productionPlanActual, "targetRelativeError", Missing["NotAvailable"]
    ]
  |>,
  "timingsSeconds" -> <|
    "regulator" -> epSeconds,
    "definitionDerivative" -> definitionRouteSeconds,
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
  "# MadStree v0.17 Validation-08 独立报告", "",
  "- 状态：**" <> status <> "**，" <> ToString[passedCount] <> "/" <>
    ToString[Length[checks]] <> "。",
  "- 源码聚合 SHA-256：`" <> sourceDigest <> "`。",
  "- 独立来源：Gamma 积分、固定 h 小时间两支表、外腿指数因子的定义求导。", "",
  "## Gamma 与时间-IBP", "",
  "正非整数、负非整数和非零纯虚 Gamma 参数均与直接 Gamma 公式 exact 一致；参数化样本覆盖 `-16..0`，数学拒绝集合由同一个非正整数谓词定义。",
  "每个实际 master state 的 `2^n` 小时间分支均由 runner 内的固定表重建；正整数只记录有限安全 shift，实际越过首个非正整数层时才拒绝。", "",
  "## Regulator 与三顶点双路线", "",
  "正规化闭式为 `Gamma[ep] 3^(-ep)`；生产/验证样点全部非零，直接 `ep=0` 边界返回 `BoundaryGammaPole`。",
  "`+++`、两条 massive 线的 25 个 master 对 `e1,e2,e3` 分别按定义增加所在 component 的时间幂，再经 `MSReduce` 约回；三张 `25x25` 矩阵与公式 dlog 导数逐项 exact 比较。", "",
  "## 张量快路与用户反馈", "",
  "massive `sigma2/T`、massless quotient `sigma1/Hadamard` 及 mixed Kronecker 基均通过 exact round-trip/off-diagonal 检查；同一局部槽混入不共线 Pauli 方向不能由任一单一局部基对角化。",
  "公式/递推路线未发现一般大矩阵 `Inverse` 或无结构 `LinearSolve`，生产源码未发现 `RedundantH` 或 `masslessEndpointH`。",
  "实际触发 11 类公开 Failure；每项均保存 tag、中英文句子、Wolfram 显示文本、原因/下一步词和后端调用计数。静态扫描尚未触发的出口列表保存在 `results/summary.wl`，不冒充动态覆盖。", "",
  "## 数值路径、展开与耗时", "",
  "本 case 只有 regulator 部分调用数值 NDE；边界阶 18、主/参考输运阶 " <>
    ToString[Lookup[productionPlanActual, "primaryOrder", Missing["NotAvailable"]]] <> "/" <>
    ToString[Lookup[productionPlanActual, "referenceOrder", Missing["NotAvailable"]]] <>
    "、工作精度 " <>
    ToString[Lookup[productionPlanActual, "workingPrecisionDigits", Missing["NotAvailable"]]] <>
    "、目标相对误差 `" <>
    ToString[Lookup[productionPlanActual, "targetRelativeError", Missing["NotAvailable"]]] <>
    "`。其余检查为 exact symbolic 或隔离 mock，不适用普通物理路径。",
  "每个生产/验证 ep 点的实际边界路径、输运节点、段数、奇点跳跃次数、主/参考差值和分项耗时保存在 `results/summary.wl` 的 `regulator.pointPathSummaries`；完整重型 point evaluation 不进入正式 summary。",
  "regulator wall time：`" <> ToString[epSeconds] <> " s`；三顶点定义求导：`" <>
    ToString[definitionRouteSeconds] <> " s`；总 wall time：`" <>
    ToString[wallTimeSeconds] <> " s`。", ""
}, "\n"];
reportWriteResult = writeUTF8Text[reportPath, StringTrim[repairSourceUTF8[report]] <> "\n"];
If[reportWriteResult === $Failed,
  Print["The validation report could not be written, so this case is not marked as passed."];
  Exit[1]
];

Print["MadStree Validation-08: ", passedCount, "/", Length[checks], " checks passed."];
If[status =!= "passed",
  Print["Failed checks: ", InputForm[Keys@Select[checks, Not@TrueQ[#] &]]];
  Print["Feedback records: ", InputForm[feedbackRecords]];
  Exit[1]
];
