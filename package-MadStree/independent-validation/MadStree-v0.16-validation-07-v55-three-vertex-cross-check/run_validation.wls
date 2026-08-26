(* ::Package:: *)

(***
文件：run_validation.wls
用途：独立检验 MadStree v0.16 与 V5.5 三顶点 25 维系统直接计算的全部八个 SK 分支。
范围：V5.5 八支总和先对 arXiv:2309.10849v2 Eq. (103)，通过后才逐支比较 MadStree；两套
      冻结请求均直接调用独立 FlintNDE 0.5.0。V5.5 正式原件只读；额外乘
      Exp[Pi Im[nu]] 的路线只作为必须被论文总和否决的隔离反事实。
输出：fresh 生成 results/summary.wl 与自动 Markdown 报告；中间 payload、cache 和日志只进入
      本 case 的 results_temp，成功或失败都不会写入 reference 或程序包源码目录。
***)


(* ::Chapter:: *)
(*路径、fresh 目录与固定数值设置*)

$CharacterEncoding = "UTF-8";
$MaxExtraPrecision = 10000;
validationStart = AbsoluteTime[];
validationDirectory = DirectoryName[$InputFileName];
madStreeRoot = DirectoryName[DirectoryName[validationDirectory]];
repositoryRoot = DirectoryName[madStreeRoot];
taskRoot = FileNameJoin[{madStreeRoot, "independent-validation-task"}];
versionRoot = FileNameJoin[{madStreeRoot, "versions", "MadStree-v0.16"}];
packageKernel = FileNameJoin[{versionRoot, "Kernel", "MadStree.wl"}];
independentFlintNDERoot = FileNameJoin[{
  repositoryRoot, "package-FlintNDE", "versions", "FlintNDE-0.5.0"
}];
referenceDirectory = FileNameJoin[{
  repositoryRoot, "reference", "ref_code_3vertexanalyticcheck"
}];
referenceFile = FileNameJoin[{referenceDirectory, "001_dsde3vertex_v5.5.wl"}];
referencePythonFile = FileNameJoin[{referenceDirectory, "pyflint_e2_transport.py"}];
paperFile = FileNameJoin[{
  taskRoot, "reference",
  "2309.10849v2-Inflation Correlators with Multiple Massive Exchanges.pdf"
}];
resultsDirectory = FileNameJoin[{validationDirectory, "results"}];
runtimeDirectory = FileNameJoin[{validationDirectory, "results_temp"}];
isolatedReferenceDirectory = FileNameJoin[{runtimeDirectory, "v55"}];
isolatedReferenceFile = FileNameJoin[{
  isolatedReferenceDirectory, "001_dsde3vertex_v5.5_isolated.wl"
}];
summaryFile = FileNameJoin[{resultsDirectory, "summary.wl"}];
reportFile = FileNameJoin[{
  validationDirectory,
  "000_MadStree-v0.16-validation-07-v55-three-vertex-cross-check-report.md"
}];

workingPrecision = 60;
v55BoundaryLowOrder = 8;
v55BoundaryHighOrder = 10;
transportLowOrder = 48;
transportReferenceOrder = 64;
transportHighOrder = 64;
transportHighReferenceOrder = 80;
targetRelativeError = "1e-18";
errorSafetyFactor = 20;
paperLowCutoff = {3, 4};
paperHighCutoff = {5, 7};

Scan[
  If[DirectoryQ[#], DeleteDirectory[#, DeleteContents -> True]] &,
  {resultsDirectory, runtimeDirectory}
];
If[FileExistsQ[reportFile], DeleteFile[reportFile]];
CreateDirectory[resultsDirectory, CreateIntermediateDirectories -> True];
CreateDirectory[isolatedReferenceDirectory, CreateIntermediateDirectories -> True];


(* ::Chapter:: *)
(*通用 helper 与逐阶段保存*)

ClearAll[
  hashFile, sha256Text, exactZeroCount, nonzeroPositions,
  relativeVectorResidual, scalarRelativeResidual, componentRelativeResiduals, midpointValue,
  importedVector, requestDigest, persistProgress, branchDirectoryName,
  v55StateDirectoryName, successfulAdapterVector, allBranchTransportsComputedQ,
  exactDENonzeroCounts, repairSourceUTF8, failClosed, paperBranchValuesFromRaw25,
  paperTotalFromRaw25, paperConjugationChecks, writeUTF8Text
];

hashFile[path_String] := ToUpperCase@IntegerString[FileHash[path, "SHA256"], 16, 64];

sha256Text[text_String] := ToUpperCase@IntegerString[
  Hash[text, "SHA256"],
  16,
  64
];

writeUTF8Text[path_String, text_String] := Module[{stream},
  stream = OpenWrite[path, BinaryFormat -> True];
  BinaryWrite[stream, ToCharacterCode[text, "UTF-8"], "Byte"];
  Close[stream];
  path
];

exactZeroCount[matrix_?MatrixQ] := Count[Flatten[matrix], 0];

nonzeroPositions[matrix_?MatrixQ] := Select[
  Tuples[Range /@ Dimensions[matrix]],
  ! TrueQ[matrix[[Sequence @@ #]] === 0] &
];

relativeVectorResidual[x_List, y_List] := N[
  Norm[x - y]/Max[Norm[x], Norm[y], 10^-100],
  40
];

scalarRelativeResidual[x_, y_] := N[
  Abs[x - y]/Max[Abs[x], Abs[y], 10^-100],
  40
];

componentRelativeResiduals[x_List, y_List] := MapThread[
  N[Abs[#1 - #2]/Max[Abs[#1], Abs[#2], 10^-100], 40] &,
  {x, y}
];

midpointValue[text_String] := ToExpression[StringReplace[text, "e" -> "*^"]];

importedVector[result_Association] := MadStree`Private`msParseFlintVector[
  Lookup[result, "finalValues", {}]
];

requestDigest[request_Association] := sha256Text[ExportString[request, "RawJSON"]];

branchDirectoryName[label_String] := StringReplace[label, {"+" -> "p", "-" -> "m"}];

v55StateDirectoryName["original"] := "vo";
v55StateDirectoryName["extra-factor-counterfactual"] := "vc";

successfulAdapterVector[result_, expectedDimension_Integer] := Module[{values},
  If[
    ! AssociationQ[result] || Lookup[result, "status", None] =!= "success",
    Return[Failure[
      "AdapterDidNotSucceed",
      <|"expectedDimension" -> expectedDimension, "result" -> result|>
    ]]
  ];
  values = importedVector[result];
  If[
    Length[values] =!= expectedDimension,
    Return[Failure[
      "AdapterVectorDimensionMismatch",
      <|"expectedDimension" -> expectedDimension, "actualDimension" -> Length[values]|>
    ]]
  ];
  values
];

allBranchTransportsComputedQ[records_Association] :=
  Length[records] === 8 && And @@ (Lookup[#, "status", None] === "success" & /@ Values[records]);

exactDENonzeroCounts[records_Association] := Association@KeyValueMap[
  #1 -> Lookup[Values[#2], "nonzeroDifferenceCount"] &,
  records
];

repairSourceUTF8[text_String] := FromCharacterCode[
  ToCharacterCode[text, "ISO8859-1"],
  "UTF-8"
];

progress = <|
  "schema" -> "madstree_v0.16_validation_07_progress_v1",
  "status" -> "running",
  "completedStages" -> {},
  "branchResults" -> <||>
|>;

persistProgress[stage_String] := Module[{},
  progress["completedStages"] = Append[progress["completedStages"], stage];
  writeUTF8Text[
    summaryFile,
    ToString[progress, InputForm, PageWidth -> Infinity] <> "\n"
  ]
];

failClosed[stage_String, details_] := Module[{failureSummary, failureReport},
  failureSummary = <|
    "schema" -> "madstree_v0.16_validation_07_v55_three_vertex_v3",
    "status" -> "failed",
    "failedStage" -> stage,
    "details" -> details,
    "completedStages" -> progress["completedStages"],
    "branchResults" -> progress["branchResults"],
    "timingsSeconds" -> <|"total" -> N[AbsoluteTime[] - validationStart, 12]|>
  |>;
  writeUTF8Text[
    summaryFile,
    ToString[failureSummary, InputForm, PageWidth -> Infinity] <> "\n"
  ];
  failureReport = repairSourceUTF8 /@ {
    "# MadStree v0.16 Validation-07：V5.5 三顶点八分支交叉检验",
    "",
    "## 状态",
    "",
    "- 状态：`failed`。",
    "- 首个阻断阶段：`" <> stage <> "`。",
    "- 已完成阶段：`" <> ToString[progress["completedStages"], InputForm] <> "`。",
    "- 结构化失败详情与已完成分支见 `results/summary.wl`；后续比较未执行。"
  };
  writeUTF8Text[
    reportFile,
    StringRiffle[failureReport, "\n"] <> "\n"
  ];
  Exit[1]
];

paperBranchValuesFromRaw25[raw25_Association] := Module[{commonFactor},
  commonFactor = StandaloneCommonFactorAtPoint[
    targetParameters, targetPoint, workingPrecision
  ];
  Association@KeyValueMap[
    #1 -> N[XYZZVertexFactor[#1] commonFactor #2[[1]], workingPrecision] &,
    raw25
  ]
];

paperTotalFromRaw25[raw25_Association] := Total[Values[paperBranchValuesFromRaw25[raw25]]];

paperConjugationChecks[lowRaw25_Association, highRaw25_Association] := Module[
  {lowPaper, highPaper},
  lowPaper = paperBranchValuesFromRaw25[lowRaw25];
  highPaper = paperBranchValuesFromRaw25[highRaw25];
  Association@Table[
    signs -> Module[{opposite, difference, budget},
      opposite = -signs;
      difference = Abs[lowPaper[opposite] - Conjugate[lowPaper[signs]]];
      budget = errorSafetyFactor (
        Abs[highPaper[opposite] - lowPaper[opposite]] +
          Abs[highPaper[signs] - lowPaper[signs]] +
          10^-40 Max[Abs[lowPaper[opposite]], Abs[lowPaper[signs]], 1]
      );
      <|
        "oppositeSigns" -> opposite,
        "absoluteDifference" -> difference,
        "jointBudget" -> budget,
        "withinBudgetQ" -> TrueQ[difference <= budget]
      |>
    ],
    {signs, Tuples[{1, -1}, 3]}
  ]
];


(* ::Chapter:: *)
(*只读参考副本与程序包加载*)

referenceHash = hashFile[referenceFile];
referencePythonHash = hashFile[referencePythonFile];
paperHash = hashFile[paperFile];
referenceText = Import[referenceFile, "Text", CharacterEncoding -> "UTF-8"];
autoRunNeedle = "v55RunNow = True;";
autoRunOccurrenceCount = StringCount[referenceText, autoRunNeedle];
isolatedReferenceText = StringReplace[
  referenceText,
  autoRunNeedle -> "v55RunNow = False;"
];
Export[
  isolatedReferenceFile,
  isolatedReferenceText,
  "Text",
  CharacterEncoding -> "UTF-8"
];

{referenceLoadSeconds, referenceLoadResult} = AbsoluteTiming[Get[isolatedReferenceFile]];
{referenceCoreSeconds, referenceCoreLoadedQ} = AbsoluteTiming[XYZZLoadProjectCore[]];
{packageLoadSeconds, packageLoadResult} = AbsoluteTiming[Get[packageKernel]];
persistProgress["sources-loaded"];


(* ::Chapter:: *)
(*八分支 master、normalization 与五变量 exact DE*)

ClearAll[
  v55VertexType, buildContext, sectorEmbedding, embedConnection,
  madStreeConnectionForVariable, v55ConnectionForVariable
];

v55VertexType[1] := "+";
v55VertexType[-1] := "-";

buildContext[signs_List] := MSInitTree[<|
  "name" -> "Validation-07 V5.5 three-vertex " <> StringJoin[v55VertexType /@ signs],
  "vertices" -> {
    <|"id" -> 1, "externalLegEnergy" -> k1,
      "timePower" -> a1, "vertexType" -> v55VertexType[signs[[1]]]|>,
    <|"id" -> 2, "externalLegEnergy" -> k2,
      "timePower" -> a2, "vertexType" -> v55VertexType[signs[[2]]]|>,
    <|"id" -> 3, "externalLegEnergy" -> k3,
      "timePower" -> a3, "vertexType" -> v55VertexType[signs[[3]]]|>
  },
  "lines" -> {
    <|"type" -> "massive", "endpoints" -> {1, 2},
      "momentum" -> q1, "nu" -> n1|>,
    <|"type" -> "massive", "endpoints" -> {2, 3},
      "momentum" -> q2, "nu" -> n2|>
  }
|>, NuConvention -> "Negative"];

sectorIndexMap = <|
  "11" -> Range[1, 16],
  "01" -> Range[17, 20],
  "10" -> Range[21, 24],
  "00" -> {25}
|>;

sectorEmbedding[context_Association] := Module[{activeIndices},
  activeIndices = Flatten[Lookup[sectorIndexMap, context["sectorOrder"]]];
  SparseArray[
    Thread[Transpose[{activeIndices, Range[Length[activeIndices]]}] -> 1],
    {25, Length[activeIndices]}
  ]
];

embedConnection[context_Association, matrix_?MatrixQ] := Module[{embedding},
  embedding = sectorEmbedding[context];
  Normal[embedding . matrix . Transpose[embedding]]
];

deProbeMadStreeRules = {
  k1 -> -7, k2 -> -11, k3 -> -13,
  q1 -> 2, q2 -> 3,
  n1 -> 2/5, n2 -> 1/3,
  a1 -> 5/4, a2 -> 7/6, a3 -> 9/8
};
deProbeV55Rules = {
  E1 -> 7, E2 -> 11, E3 -> 13,
  s1 -> 2, s2 -> 3,
  nu1 -> 2/5, nu2 -> 1/3,
  nu0L -> 5/4, nu0M -> 7/6, nu0R -> 9/8
};
variableMap = <|"E1" -> E1, "E2" -> E2, "E3" -> E3, "s1" -> s1, "s2" -> s2|>;
madStreeVariableMap = <|"E1" -> k1, "E2" -> k2, "E3" -> k3, "s1" -> q1, "s2" -> q2|>;

madStreeConnectionForVariable[context_Association, variableName_String] := Module[
  {de, variable, chainFactor},
  de = MSDLogDE[context];
  variable = madStreeVariableMap[variableName];
  chainFactor = If[MemberQ[{"E1", "E2", "E3"}, variableName], -1, 1];
  embedConnection[
    context,
    Map[
      Cancel[Together[#]] &,
      chainFactor D[de["omegaPotential"], variable] /. deProbeMadStreeRules,
      {2}
    ]
  ]
];

v55ConnectionForVariable[signs_List, variableName_String] := Module[{variable},
  variable = variableMap[variableName];
  Map[
    Cancel[Together[#]] &,
    If[
      variableName === "s1",
      XYZZProjectRawBranchMatrix[signs],
      XYZZProjectRawBranchMatrixForVariable[signs, variable]
    ] /. deProbeV55Rules,
    {2}
  ]
];

branchSpecs = Function[signs,
  <|"label" -> StringJoin[v55VertexType /@ signs], "signs" -> signs|>
] /@ Tuples[{1, -1}, 3];

contexts = Association@Table[
  spec["label"] -> buildContext[spec["signs"]],
  {spec, branchSpecs}
];

exactDERecords = Association@Table[
  label = spec["label"];
  signs = spec["signs"];
  context = contexts[label];
  label -> Association@Table[
    {madSeconds, madMatrix} = AbsoluteTiming[
      madStreeConnectionForVariable[context, variableName]
    ];
    {v55Seconds, v55Matrix} = AbsoluteTiming[
      v55ConnectionForVariable[signs, variableName]
    ];
    residual = Map[Cancel[Together[#]] &, madMatrix - v55Matrix, {2}];
    positions = nonzeroPositions[residual];
    variableName -> <|
      "dimensions" -> Dimensions[residual],
      "exactEqualCount" -> exactZeroCount[residual],
      "nonzeroDifferenceCount" -> Length[positions],
      "firstNonzeroPosition" -> If[positions === {}, None, First[positions]],
      "firstNonzeroValue" -> If[positions === {}, 0, residual[[Sequence @@ First[positions]]]],
      "timingsSeconds" -> <|"MadStree" -> madSeconds, "V5.5" -> v55Seconds|>
    |>,
    {variableName, Keys[variableMap]}
  ],
  {spec, branchSpecs}
];

masterNormalizationRecords = Association@Table[
  label = spec["label"];
  context = contexts[label];
  label -> <|
    "signs" -> spec["signs"],
    "sectorOrder" -> context["sectorOrder"],
    "masterCount" -> Length[context["masters"]],
    "masters" -> MSMasterIntegrals[context],
    "sectorNormalizations" -> AssociationThread[
      context["sectorOrder"], Lookup[context["sectors"], "normalization"]
    ],
    "contactDepths" -> AssociationThread[
      context["sectorOrder"], Lookup[context["sectors"], "contactDepth"]
    ],
    "embeddedIndices" -> Flatten[Lookup[sectorIndexMap, context["sectorOrder"]]]
  |>,
  {spec, branchSpecs}
];
persistProgress["exact-five-variable-de"];


(* ::Chapter:: *)
(*Contact coefficient 修复与旧 I^n 反事实*)

phaseContext = contexts["+++"];
phaseRules = {
  k1 -> -30, k2 -> -10, k3 -> -3,
  q1 -> 1, q2 -> 2,
  n1 -> 1/5, n2 -> 1/4,
  a1 -> 5, a2 -> 5, a3 -> 5
};
phaseBoundary = MSBoundaryData[
  phaseContext,
  phaseRules,
  BoundaryScale -> 4,
  BoundarySeriesOrder -> 4,
  RankOrder -> {2, 1, 3},
  WorkingPrecision -> 80
];
phaseSectorByKey = AssociationThread[
  phaseContext["sectorOrder"] -> phaseContext["sectors"]
];
phaseRows = Function[record,
  With[{sector = phaseSectorByKey[record["sectorKey"]]},
    <|
      "sectorKey" -> record["sectorKey"],
      "contactCount" -> Length[sector["contractedLineIds"]],
      "ratio" -> FullSimplify[
        record["coefficient"]/
          ((sector["normalization"] /. phaseRules)
            Times @@ Lookup[record["componentData"], "coefficient"])
      ]
    |>
  ]
] /@ phaseBoundary["leadingBranches"];
phaseRatiosByContactCount = Association@KeyValueMap[
  #1 -> DeleteDuplicates[Lookup[#2, "ratio"]] &,
  GroupBy[phaseRows, #1["contactCount"] &]
];
legacyPhaseRatiosByContactCount = AssociationMap[
  I^# phaseRatiosByContactCount[#] &,
  Keys[phaseRatiosByContactCount]
];
persistProgress["contact-phase-counterfactual"];


(* ::Chapter:: *)
(*V5.5 E2 无穷远边界到独立 FlintNDE 的冻结请求*)

ClearAll[
  buildV55LetterRecords, buildV55Request, runV55Branch,
  runV55BranchSet, applyV55ExtraPinchNormalizationCounterfactual,
  restoreV55PinchNormalizations, stripCitationNotice
];

targetParameters = StandaloneDefaultParameters[];
targetPoint = StandaloneDefaultTargetPoint[];
targetRules = StandaloneRulesFromPoint[targetParameters, targetPoint];
tEnd = 1/targetPoint["E2"];
tStart = tEnd/2;


(* 验证 summary 不保存用户引用提醒；数值、路径与误差 metadata 原样保留。 *)
stripCitationNotice[result_Association] := If[
  AssociationQ[Lookup[result, "metadata", Missing["NotAvailable"]]],
  ReplacePart[result, "metadata" -> KeyDrop[result["metadata"], "citationNotice"]],
  result
];
stripCitationNotice[result_] := result;


buildV55LetterRecords[poleData_Association] := Module[{beta},
  beta = tEnd - tStart;
  MapThread[
    <|
      "alpha" -> MadStree`Private`msGaussianRationalString[tStart - #1],
      "beta" -> MadStree`Private`msGaussianRationalString[beta],
      "residue" -> Map[MadStree`Private`msGaussianRationalString, #2, {2}]
    |> &,
    {poleData["TPoles"], poleData["TResidueMatrices"]}
  ]
];

buildV55Request[
  label_String,
  boundaryVector_List,
  poleData_Association,
  primaryOrder_Integer,
  referenceOrder_Integer
] := <|
  "schema" -> "madstree_flintnde_evaluate_v1",
  "backendPackagePath" -> independentFlintNDERoot,
  "masterDigest" -> "v55-raw25-" <> branchDirectoryName[label],
  "dimension" -> 25,
  "segments" -> {<|
    "start" -> "0",
    "points" -> {MadStree`Private`msGaussianRationalString[1]},
    "letters" -> buildV55LetterRecords[poleData],
    "fromUserIndex" -> 0,
    "userIndices" -> {1}
  |>},
  "pathPlanning" -> True,
  "singularityMode" -> "avoid",
  "boundary" -> <|
    "kind" -> "finite",
    "values" -> (MadStree`Private`msComplexDecimalRecord[#, workingPrecision] & /@ boundaryVector)
  |>,
  "workingPrecisionDigits" -> workingPrecision,
  "primaryOrder" -> primaryOrder,
  "referenceOrder" -> referenceOrder,
  "targetRelativeError" -> targetRelativeError,
  "certificationMode" -> "embedded",
  "messageLanguage" -> "EN",
  "columnVectorConvention" -> "Y'=A(s)Y",
  "dlogStatus" -> "certifiedByFormulaChecks"
|>;

runV55Branch[spec_Association, stateLabel_String] := Module[
  {label, signs, branchRuntime, dataSeconds, data, poleSeconds, poleData,
    lowBoundary, highBoundary, lowResidual, highResidual, leadingResiduals,
    lowRequest, highRequest, lowSeconds, lowResult, highSeconds, highResult,
    lowValues, highValues},
  label = spec["label"];
  signs = spec["signs"];
  branchRuntime = FileNameJoin[{
    runtimeDirectory, "r", v55StateDirectoryName[stateLabel], branchDirectoryName[label]
  }];
  CreateDirectory[branchRuntime, CreateIntermediateDirectories -> True];
  {dataSeconds, data} = AbsoluteTiming[
    XYZZProjectE2InfinityFrobeniusData[
      signs,
      targetRules,
      "WorkingPrecision" -> workingPrecision,
      "SeriesOrder" -> v55BoundaryHighOrder,
      "AccuracyGoal" -> 30,
      "PrecisionGoal" -> 30,
      "MaxRecursion" -> 14,
      "Cutoff" -> 35,
      "LowerCutoff" -> 10^-8,
      "OuterVertexEvaluation" -> "Series",
      "OuterVertexSeriesOrder" -> 16
    ]
  ];
  If[! AssociationQ[data], Return[Failure[
    "V55BoundaryDataFailed", <|"label" -> label, "state" -> stateLabel|>
  ]]];
  {poleSeconds, poleData} = AbsoluteTiming[
    XYZZProjectE2InfinityPoleResidueData[signs, targetRules]
  ];
  If[! AssociationQ[poleData], Return[poleData]];
  lowBoundary = XYZZProjectE2InfinityEvaluate[data, tStart, v55BoundaryLowOrder];
  highBoundary = XYZZProjectE2InfinityEvaluate[data, tStart, v55BoundaryHighOrder];
  lowResidual = XYZZProjectE2InfinitySeriesResidual[
    data, tStart, v55BoundaryLowOrder
  ];
  highResidual = XYZZProjectE2InfinitySeriesResidual[
    data, tStart, v55BoundaryHighOrder
  ];
  leadingResiduals = N[
    Norm[
      (data["ResidueMatrix"] - #1["Exponent"] IdentityMatrix[25]) .
        #1["LeadingVector"]
    ]/Max[Norm[#1["LeadingVector"]], 10^-100] & /@ data["Modes"],
    40
  ];
  lowRequest = buildV55Request[
    label, lowBoundary, poleData, transportLowOrder, transportReferenceOrder
  ];
  highRequest = buildV55Request[
    label, highBoundary, poleData, transportHighOrder, transportHighReferenceOrder
  ];
  {lowSeconds, lowResult} = AbsoluteTiming[
    MadStree`Private`msExecuteFlintNDEAdapter[
      lowRequest,
      "python",
      FileNameJoin[{branchRuntime, "l"}]
    ]
  ];
  {highSeconds, highResult} = AbsoluteTiming[
    MadStree`Private`msExecuteFlintNDEAdapter[
      highRequest,
      "python",
      FileNameJoin[{branchRuntime, "h"}]
    ]
  ];
  lowValues = successfulAdapterVector[lowResult, 25];
  If[FailureQ[lowValues], Return[Failure[
    "V55LowTransportFailed",
    <|"label" -> label, "state" -> stateLabel, "cause" -> lowValues|>
  ]]];
  highValues = successfulAdapterVector[highResult, 25];
  If[FailureQ[highValues], Return[Failure[
    "V55HighTransportFailed",
    <|"label" -> label, "state" -> stateLabel, "cause" -> highValues|>
  ]]];
  <|
    "status" -> "success",
    "label" -> label,
    "signs" -> signs,
    "state" -> stateLabel,
    "chart" -> "t=1/E2, E2->Infinity with E1,E3,s1,s2 fixed",
    "tStart" -> tStart,
    "tEnd" -> tEnd,
    "poleCount" -> Length[poleData["TPoles"]],
    "residueAtInfinity" -> poleData["TResidueAtZero"],
    "modeCount" -> Length[data["Modes"]],
    "leadingModeResiduals" -> leadingResiduals,
    "lowSeriesResidual" -> lowResidual,
    "highSeriesResidual" -> highResidual,
    "boundaryLowHighResidual" -> relativeVectorResidual[lowBoundary, highBoundary],
    "lowRequestDigest" -> requestDigest[lowRequest],
    "highRequestDigest" -> requestDigest[highRequest],
    "lowResult" -> stripCitationNotice[lowResult],
    "highResult" -> stripCitationNotice[highResult],
    "lowValues" -> lowValues,
    "highValues" -> highValues,
    "timingsSeconds" -> <|
      "boundary" -> dataSeconds,
      "poleResidue" -> poleSeconds,
      "lowTransport" -> lowSeconds,
      "highTransport" -> highSeconds
    |>
  |>
];

runV55BranchSet[stateLabel_String] := Module[{records, record},
  records = <||>;
  Do[
    record = runV55Branch[spec, stateLabel];
    If[
      FailureQ[record],
      Return[Failure[
        "V55BranchSetFailed",
        <|
          "state" -> stateLabel,
          "failedLabel" -> spec["label"],
          "completedRecords" -> records,
          "cause" -> record
        |>
      ]]
    ];
    AssociateTo[records, spec["label"] -> record],
    {spec, branchSpecs}
  ];
  records
];

savedProjectPinchNormalization = DownValues[ProjectPinchNormalization];
savedXYZZProjectPinchNormalization = DownValues[XYZZProjectPinchNormalization];

applyV55ExtraPinchNormalizationCounterfactual[] := Module[{},
  Clear[ProjectPinchNormalization, XYZZProjectPinchNormalization];
  ProjectPinchNormalization[nu_, momentum_, sign_Integer] :=
    -sign 4 I/Pi Exp[Pi Im[nu]] momentum^(-2 nu - 1);
  XYZZProjectPinchNormalization[nu_, momentum_, sign_] :=
    -sign 4 I/Pi Exp[Pi Im[nu]] momentum^(-2 nu - 1);
];

restoreV55PinchNormalizations[] := Module[{},
  Clear[ProjectPinchNormalization, XYZZProjectPinchNormalization];
  DownValues[ProjectPinchNormalization] = savedProjectPinchNormalization;
  DownValues[XYZZProjectPinchNormalization] = savedXYZZProjectPinchNormalization;
];

If[NameQ["XYZZClearInfinityBoundaryCaches"], XYZZClearInfinityBoundaryCaches[]];
v55OriginalResults = runV55BranchSet["original"];
If[FailureQ[v55OriginalResults], failClosed["v55-original-transport", v55OriginalResults]];
progress["branchResults"] = Append[
  progress["branchResults"],
  "v55Original" -> (KeyTake[
    #,
    {"label", "state", "lowRequestDigest", "highRequestDigest", "timingsSeconds"}
  ] & /@ v55OriginalResults)
];
persistProgress["v55-original-eight-branches"];

applyV55ExtraPinchNormalizationCounterfactual[];
If[NameQ["XYZZClearInfinityBoundaryCaches"], XYZZClearInfinityBoundaryCaches[]];
v55CounterfactualResults = runV55BranchSet["extra-factor-counterfactual"];
restoreV55PinchNormalizations[];
If[NameQ["XYZZClearInfinityBoundaryCaches"], XYZZClearInfinityBoundaryCaches[]];
If[FailureQ[v55CounterfactualResults], failClosed[
  "v55-counterfactual-transport", v55CounterfactualResults
]];
progress["branchResults"] = Append[
  progress["branchResults"],
  "v55ExtraFactorCounterfactual" -> (KeyTake[
    #,
    {"label", "state", "lowRequestDigest", "highRequestDigest", "timingsSeconds"}
  ] & /@ v55CounterfactualResults)
];
persistProgress["v55-extra-factor-counterfactual-eight-branches"];


(* ::Chapter:: *)
(*V5.5 八支总和先对 arXiv:2309.10849v2 Eq. (103)*)

v55OriginalLowRaw25 = Association@Table[
  spec["signs"] -> v55OriginalResults[spec["label"], "lowValues"],
  {spec, branchSpecs}
];
v55OriginalHighRaw25 = Association@Table[
  spec["signs"] -> v55OriginalResults[spec["label"], "highValues"],
  {spec, branchSpecs}
];
v55CounterfactualLowRaw25 = Association@Table[
  spec["signs"] -> v55CounterfactualResults[spec["label"], "lowValues"],
  {spec, branchSpecs}
];
v55CounterfactualHighRaw25 = Association@Table[
  spec["signs"] -> v55CounterfactualResults[spec["label"], "highValues"],
  {spec, branchSpecs}
];

{paperSeriesSeconds, paperSeriesData} = AbsoluteTiming[
  paperEq103Low = StandaloneEq103AtPoint[
    targetParameters, targetPoint, paperLowCutoff, workingPrecision
  ];
  paperEq103High = StandaloneEq103AtPoint[
    targetParameters, targetPoint, paperHighCutoff, workingPrecision
  ];
  paperCorrectionLow = StandaloneEq103ProjectConventionCorrectionAtPoint[
    targetParameters, targetPoint, paperLowCutoff, workingPrecision
  ];
  paperCorrectionHigh = StandaloneEq103ProjectConventionCorrectionAtPoint[
    targetParameters, targetPoint, paperHighCutoff, workingPrecision
  ];
  <|
    "eq103Low" -> paperEq103Low,
    "eq103High" -> paperEq103High,
    "projectConventionCorrectionLow" -> paperCorrectionLow,
    "projectConventionCorrectionHigh" -> paperCorrectionHigh
  |>
];

v55OriginalConjugationChecks = paperConjugationChecks[
  v55OriginalLowRaw25, v55OriginalHighRaw25
];
v55CounterfactualConjugationChecks = paperConjugationChecks[
  v55CounterfactualLowRaw25, v55CounterfactualHighRaw25
];

v55PaperTotals = <|
  "V5.5OriginalLow" -> (
    paperTotalFromRaw25[v55OriginalLowRaw25] - paperCorrectionLow
  ),
  "V5.5OriginalHigh" -> (
    paperTotalFromRaw25[v55OriginalHighRaw25] - paperCorrectionHigh
  ),
  "V5.5ExtraFactorCounterfactualLow" -> (
    paperTotalFromRaw25[v55CounterfactualLowRaw25] - paperCorrectionLow
  ),
  "V5.5ExtraFactorCounterfactualHigh" -> (
    paperTotalFromRaw25[v55CounterfactualHighRaw25] - paperCorrectionHigh
  )
|>;

paperCutoffError = Abs[paperEq103High - paperEq103Low];
v55PaperComparison = Association@Map[
  Function[row,
    Module[{route, lowValue, highValue, difference, budget},
      route = row[[1]];
      lowValue = v55PaperTotals[row[[2]]];
      highValue = v55PaperTotals[row[[3]]];
      difference = Abs[lowValue - paperEq103Low];
      budget = errorSafetyFactor (
        Abs[highValue - lowValue] + paperCutoffError +
          10^-40 Max[Abs[paperEq103Low], 1]
      );
      route -> <|
        "lowValue" -> lowValue,
        "highValue" -> highValue,
        "paperLow" -> paperEq103Low,
        "paperHigh" -> paperEq103High,
        "absoluteDifference" -> difference,
        "jointBudget" -> budget,
        "withinBudgetQ" -> TrueQ[difference <= budget]
      |>
    ]
  ],
  {
    {"V5.5Original", "V5.5OriginalLow", "V5.5OriginalHigh"},
    {"V5.5ExtraFactorCounterfactual", "V5.5ExtraFactorCounterfactualLow",
      "V5.5ExtraFactorCounterfactualHigh"}
  }
];

v55PaperGateQ = And[
  TrueQ[
    XYZZThreeVertexF2ConvergenceQ[
      StandaloneXYZZRatiosAtPoint[targetPoint, workingPrecision]
    ]
  ],
  TrueQ[v55PaperComparison["V5.5Original", "withinBudgetQ"]],
  ! TrueQ[v55PaperComparison["V5.5ExtraFactorCounterfactual", "withinBudgetQ"]],
  And @@ Lookup[Values[v55OriginalConjugationChecks], "withinBudgetQ"]
];
progress["branchResults"] = Append[
  progress["branchResults"],
  "v55PaperGate" -> <|
    "passed" -> v55PaperGateQ,
    "comparison" -> v55PaperComparison,
    "originalConjugationChecks" -> v55OriginalConjugationChecks,
    "counterfactualConjugationChecks" -> v55CounterfactualConjugationChecks
  |>
];
persistProgress["v55-eight-branch-paper-gate"];
If[
  ! TrueQ[v55PaperGateQ],
  failClosed[
    "v55-eight-branch-paper-gate",
    <|
      "paperComparison" -> v55PaperComparison,
      "originalConjugationChecks" -> v55OriginalConjugationChecks,
      "counterfactualConjugationChecks" -> v55CounterfactualConjugationChecks
    |>
  ]
];


(* ::Chapter:: *)
(*MadStree 严格 rank 边界冻结后直输独立 FlintNDE*)

ClearAll[runMadStreeBranch];

madStreeParameterRules = {
  q1 -> targetPoint["s1"],
  q2 -> targetPoint["s2"],
  n1 -> targetParameters["nu"][[1]],
  n2 -> targetParameters["nu"][[2]],
  a1 -> targetParameters["nu0"][[1]],
  a2 -> targetParameters["nu0"][[2]],
  a3 -> targetParameters["nu0"][[3]]
};
madStreePointSequence = {
  {k1, k2, k3},
  {-targetPoint["E1"], -targetPoint["E2"], -targetPoint["E3"]}
};

runMadStreeBranch[spec_Association] := Module[
  {label, context, branchRuntime, optionValues, taskSeconds, task,
   lowRequest, highRequest, lowSeconds, lowResult, highSeconds, highResult,
   embedding, lowActive, highActive},
  label = spec["label"];
  context = contexts[label];
  branchRuntime = FileNameJoin[{
    runtimeDirectory, "r", "ms", branchDirectoryName[label]
  }];
  CreateDirectory[branchRuntime, CreateIntermediateDirectories -> True];
  optionValues = Association[Options[MSEvaluatePath]];
  AssociateTo[optionValues, {
    ParameterRules -> madStreeParameterRules,
    FlintNDEPathPlanning -> True,
    SingularityMode -> "Automatic",
    PythonExecutable -> "python",
    MSRuntimeDirectory -> branchRuntime,
    MessageLanguage -> "EN",
    WorkingPrecision -> workingPrecision,
    TransportOrder -> transportLowOrder,
    ReferenceTransportOrder -> transportReferenceOrder,
    TargetRelativeError -> targetRelativeError,
    BoundaryScale -> 4,
    BoundarySeriesOrder -> 24,
    RankOrder -> {2, 1, 3}
  }];
  {taskSeconds, task} = AbsoluteTiming[
    MadStree`Private`msPrepareEpEvaluationTask[
      context,
      madStreePointSequence,
      optionValues
    ]
  ];
  If[! AssociationQ[task], Return[task]];
  lowRequest = ReplacePart[
    task["inputData"],
    "backendPackagePath" -> independentFlintNDERoot
  ];
  highRequest = Join[
    lowRequest,
    <|
      "primaryOrder" -> transportHighOrder,
      "referenceOrder" -> transportHighReferenceOrder
    |>
  ];
  {lowSeconds, lowResult} = AbsoluteTiming[
    MadStree`Private`msExecuteFlintNDEAdapter[
      lowRequest,
      "python",
      FileNameJoin[{branchRuntime, "l"}]
    ]
  ];
  {highSeconds, highResult} = AbsoluteTiming[
    MadStree`Private`msExecuteFlintNDEAdapter[
      highRequest,
      "python",
      FileNameJoin[{branchRuntime, "h"}]
    ]
  ];
  embedding = sectorEmbedding[context];
  lowActive = successfulAdapterVector[lowResult, Length[context["masters"]]];
  If[FailureQ[lowActive], Return[Failure[
    "MadStreeLowTransportFailed",
    <|"label" -> label, "cause" -> lowActive|>
  ]]];
  highActive = successfulAdapterVector[highResult, Length[context["masters"]]];
  If[FailureQ[highActive], Return[Failure[
    "MadStreeHighTransportFailed",
    <|"label" -> label, "cause" -> highActive|>
  ]]];
  <|
    "status" -> "success",
    "label" -> label,
    "signs" -> spec["signs"],
    "chart" -> "MadStree strict rank blow-up chart {2,1,3}",
    "sectorOrder" -> context["sectorOrder"],
    "masterCount" -> Length[context["masters"]],
    "boundaryKind" -> Lookup[task["inputData", "boundary"], "kind", Missing["kind"]],
    "boundary" -> task["boundary"],
    "lowRequestDigest" -> requestDigest[lowRequest],
    "highRequestDigest" -> requestDigest[highRequest],
    "lowResult" -> stripCitationNotice[lowResult],
    "highResult" -> stripCitationNotice[highResult],
    "lowValuesActive" -> lowActive,
    "highValuesActive" -> highActive,
    "lowValues25" -> Normal[embedding . lowActive],
    "highValues25" -> Normal[embedding . highActive],
    "timingsSeconds" -> <|
      "boundaryAndPayload" -> taskSeconds,
      "lowTransport" -> lowSeconds,
      "highTransport" -> highSeconds
    |>
  |>
];

madStreeResults = Module[{records = <||>, record},
  Do[
    record = runMadStreeBranch[spec];
    If[
      FailureQ[record],
      failClosed[
        "madstree-transport",
        <|
          "failedLabel" -> spec["label"],
          "completedRecords" -> records,
          "cause" -> record
        |>
      ]
    ];
    AssociateTo[records, spec["label"] -> record],
    {spec, branchSpecs}
  ];
  records
];
progress["branchResults"] = Append[
  progress["branchResults"],
  "madStree" -> (KeyTake[
    #,
    {"label", "lowRequestDigest", "highRequestDigest", "timingsSeconds"}
  ] & /@ madStreeResults)
];
persistProgress["madstree-eight-branches"];


(* ::Chapter:: *)
(*逐分支普通点误差预算与论文 Eq. (103) 总和*)

branchComparisons = Association@Table[
  label = spec["label"];
  madLow = madStreeResults[label, "lowValues25"];
  madHigh = madStreeResults[label, "highValues25"];
  v55OriginalLow = v55OriginalResults[label, "lowValues"];
  v55OriginalHigh = v55OriginalResults[label, "highValues"];
  v55CounterfactualLow = v55CounterfactualResults[label, "lowValues"];
  v55CounterfactualHigh = v55CounterfactualResults[label, "highValues"];
  scale = MapThread[Max[Abs[#1], Abs[#2], 10^-100] &, {madLow, v55OriginalLow}];
  jointBudget = errorSafetyFactor (
    Abs[madHigh - madLow] + Abs[v55OriginalHigh - v55OriginalLow] +
      10^-40 scale
  );
  differences = Abs[madLow - v55OriginalLow];
  label -> <|
    "madStreeVsOriginalV55VectorRelativeResidual" ->
      relativeVectorResidual[madLow, v55OriginalLow],
    "madStreeVsExtraFactorCounterfactualVectorRelativeResidual" ->
      relativeVectorResidual[madLow, v55CounterfactualLow],
    "componentAbsoluteDifferences" -> differences,
    "componentRelativeDifferences" ->
      componentRelativeResiduals[madLow, v55OriginalLow],
    "componentJointBudgets" -> jointBudget,
    "componentWithinBudgetQ" -> MapThread[TrueQ[#1 <= #2] &, {differences, jointBudget}],
    "allComponentsWithinBudgetQ" -> And @@ MapThread[
      TrueQ[#1 <= #2] &,
      {differences, jointBudget}
    ],
    "madStreeLowHighResidual" -> relativeVectorResidual[madLow, madHigh],
    "v55OriginalLowHighResidual" ->
      relativeVectorResidual[v55OriginalLow, v55OriginalHigh],
    "v55ExtraFactorCounterfactualLowHighResidual" ->
      relativeVectorResidual[v55CounterfactualLow, v55CounterfactualHigh]
  |>,
  {spec, branchSpecs}
];

madStreeLowRaw25 = Association@Table[
  spec["signs"] -> madStreeResults[spec["label"], "lowValues25"],
  {spec, branchSpecs}
];
madStreeHighRaw25 = Association@Table[
  spec["signs"] -> madStreeResults[spec["label"], "highValues25"],
  {spec, branchSpecs}
];

madStreeConjugationChecks = paperConjugationChecks[
  madStreeLowRaw25, madStreeHighRaw25
];
madStreePaperTotals = <|
  "MadStreeLow" -> (
    paperTotalFromRaw25[madStreeLowRaw25] - paperCorrectionLow
  ),
  "MadStreeHigh" -> (
    paperTotalFromRaw25[madStreeHighRaw25] - paperCorrectionHigh
  )
|>;
madStreePaperDifference = Abs[madStreePaperTotals["MadStreeLow"] - paperEq103Low];
madStreePaperBudget = errorSafetyFactor (
  Abs[madStreePaperTotals["MadStreeHigh"] - madStreePaperTotals["MadStreeLow"]] +
    paperCutoffError + 10^-40 Max[Abs[paperEq103Low], 1]
);
madStreePaperComparison = <|
  "lowValue" -> madStreePaperTotals["MadStreeLow"],
  "highValue" -> madStreePaperTotals["MadStreeHigh"],
  "paperLow" -> paperEq103Low,
  "paperHigh" -> paperEq103High,
  "absoluteDifference" -> madStreePaperDifference,
  "jointBudget" -> madStreePaperBudget,
  "withinBudgetQ" -> TrueQ[madStreePaperDifference <= madStreePaperBudget]
|>;
paperTotals = Join[v55PaperTotals, madStreePaperTotals];
paperComparison = Join[
  v55PaperComparison,
  <|"MadStree" -> madStreePaperComparison|>
];
persistProgress["ordinary-point-and-paper-total"];


(* ::Chapter:: *)
(*验收、机器 summary 与自动报告*)

deNonzeroCounts = exactDENonzeroCounts[exactDERecords];
allDEExactQ = Flatten[Values[deNonzeroCounts]] === ConstantArray[0, 40];
allV55OriginalComputedQ = allBranchTransportsComputedQ[v55OriginalResults];
allV55CounterfactualComputedQ = allBranchTransportsComputedQ[v55CounterfactualResults];
allMadStreeComputedQ = allBranchTransportsComputedQ[madStreeResults];
counterfactualMismatchCount = Count[
  Lookup[
    Values[branchComparisons],
    "madStreeVsExtraFactorCounterfactualVectorRelativeResidual"
  ],
  value_ /; TrueQ[value > 10^-8]
];

checks = <|
  "referenceHash" -> referenceHash ===
    "F5152B6FDED43971C8B6AFEC8D421AAAEF080B3FCC8A8D8A36363F84ABD63AF9",
  "referencePythonHash" -> referencePythonHash ===
    "78891A14C2A5A20C8F2C6082E64561A883FD6DD31C4CFA3D1662626BA96BFA44",
  "paperHash" -> paperHash ===
    "4C416F8A7B179E5B5A59B958F73610D4560DF3431AF5A3632424A73BDAFB9D07",
  "singleAutoRunReplacement" -> autoRunOccurrenceCount === 1,
  "referenceCoreLoaded" -> TrueQ[referenceCoreLoadedQ],
  "independentFlintNDEExists" -> FileExistsQ[
    FileNameJoin[{independentFlintNDERoot, "flintnde", "__init__.py"}]
  ],
  "eightBranchesFiveVariablesExactDE" -> TrueQ[allDEExactQ],
  "contactDepthRatios" ->
    phaseRatiosByContactCount === <|0 -> {1}, 1 -> {1}, 2 -> {1}|>,
  "legacyContactPhaseRejected" ->
    legacyPhaseRatiosByContactCount === <|0 -> {1}, 1 -> {I}, 2 -> {-1}|>,
  "v55OriginalEightBranchesComputed" -> TrueQ[allV55OriginalComputedQ],
  "v55ExtraFactorCounterfactualEightBranchesComputed" ->
    TrueQ[allV55CounterfactualComputedQ],
  "madStreeEightBranchesComputed" -> TrueQ[allMadStreeComputedQ],
  "v55PaperGatePassedBeforeMadStree" -> TrueQ[v55PaperGateQ],
  "v55OriginalDirectConjugation" -> And @@ Lookup[
    Values[v55OriginalConjugationChecks], "withinBudgetQ"
  ],
  "madStreeDirectConjugation" -> And @@ Lookup[
    Values[madStreeConjugationChecks], "withinBudgetQ"
  ],
  "extraFactorCounterfactualMismatchExposed" -> counterfactualMismatchCount >= 1,
  "originalV55AllComponentsWithinBudget" -> And @@ Lookup[
    Values[branchComparisons], "allComponentsWithinBudgetQ"
  ],
  "paperConvergenceInterior" -> TrueQ[
    XYZZThreeVertexF2ConvergenceQ[
      StandaloneXYZZRatiosAtPoint[targetPoint, workingPrecision]
    ]
  ],
  "v55OriginalPaperTotalWithinBudget" -> TrueQ[
    paperComparison["V5.5Original", "withinBudgetQ"]
  ],
  "v55ExtraFactorCounterfactualRejectedByPaperTotal" -> ! TrueQ[
    paperComparison["V5.5ExtraFactorCounterfactual", "withinBudgetQ"]
  ],
  "madStreePaperTotalWithinBudget" -> TrueQ[
    paperComparison["MadStree", "withinBudgetQ"]
  ]
|>;
status = If[And @@ Values[checks], "passed", "failed"];
elapsedSeconds = N[AbsoluteTime[] - validationStart, 12];

summary = <|
  "schema" -> "madstree_v0.16_validation_07_v55_three_vertex_v3",
  "status" -> status,
  "checks" -> checks,
  "passedCount" -> Count[Values[checks], True],
  "checkCount" -> Length[checks],
  "sourceIdentity" -> <|
    "V5.5File" -> referenceFile,
    "V5.5SHA256" -> referenceHash,
    "V5.5PythonFile" -> referencePythonFile,
    "V5.5PythonSHA256" -> referencePythonHash,
    "paperFile" -> paperFile,
    "paperSHA256" -> paperHash,
    "paper" -> "arXiv:2309.10849v2",
    "MadStreeKernelSHA256" -> hashFile[packageKernel],
    "MadStreeBoundarySHA256" -> hashFile[
      FileNameJoin[{versionRoot, "Kernel", "Numerics", "Boundary.wl"}]
    ],
    "independentFlintNDERoot" -> independentFlintNDERoot
  |>,
  "evidenceBoundary" -> <|
    "paperBranchCoverage" ->
      "Eqs. (148)-(151) list four independent SK integral branches; Eq. (103) is the completed eight-branch sum, not a per-branch closed form.",
    "paperGateOrder" ->
      "V5.5 computes all eight branches directly; their paper-convention sum is checked against arXiv:2309.10849v2 Eq. (103) before V5.5 is used as the per-branch reference for MadStree.",
    "singleBranchDEBoundaryComparison" -> "certified V5.5 batch versus MadStree",
    "physicalTotalComparison" -> "V5.5 and MadStree separately versus arXiv:2309.10849v2 Eq. (103)"
  |>,
  "convention" -> <|
    "vertexMap" -> "V5.5 a=+1/-1 <-> MadStree vertexType='+'/'-'",
    "energyMap" -> "externalLegEnergy_MadStree=-E_V5.5",
    "nuConvention" -> "Negative",
    "masterOrder" -> "Top16 + LeftPinch4 + RightPinch4 + DoublePinch1",
    "columnConvention" -> "Y'=A Y"
  |>,
  "masterAndNormalization" -> masterNormalizationRecords,
  "exactDE" -> exactDERecords,
  "contactBoundary" -> <|
    "actualRatiosByDepth" -> phaseRatiosByContactCount,
    "legacyCounterfactualRatiosByDepth" -> legacyPhaseRatiosByContactCount
  |>,
  "boundaryCharts" -> <|
    "V5.5" -> "t=1/E2, E2->Infinity with other variables fixed",
    "MadStree" -> "strict rank blow-up chart {2,1,3}",
    "comparisonRule" ->
      "Raw Frobenius vectors in different charts are not equated; each germ is checked against its own residue, then transported to the common ordinary point."
  |>,
  "V5.5Original" -> v55OriginalResults,
  "V5.5ExtraFactorCounterfactual" -> v55CounterfactualResults,
  "MadStree" -> madStreeResults,
  "branchComparisons" -> branchComparisons,
  "directConjugationChecks" -> <|
    "V5.5Original" -> v55OriginalConjugationChecks,
    "V5.5ExtraFactorCounterfactual" -> v55CounterfactualConjugationChecks,
    "MadStree" -> madStreeConjugationChecks
  |>,
  "paperComparison" -> <|
    "point" -> targetPoint,
    "ratios" -> StandaloneXYZZRatiosAtPoint[targetPoint, workingPrecision],
    "lowCutoff" -> paperLowCutoff,
    "highCutoff" -> paperHighCutoff,
    "series" -> paperSeriesData,
    "totals" -> paperTotals,
    "comparisons" -> paperComparison
  |>,
  "ordersAndPrecision" -> <|
    "workingPrecision" -> workingPrecision,
    "V5.5BoundaryLowOrder" -> v55BoundaryLowOrder,
    "V5.5BoundaryHighOrder" -> v55BoundaryHighOrder,
    "TransportLowOrder" -> transportLowOrder,
    "TransportReferenceOrder" -> transportReferenceOrder,
    "TransportHighOrder" -> transportHighOrder,
    "TransportHighReferenceOrder" -> transportHighReferenceOrder,
    "targetRelativeError" -> targetRelativeError,
    "errorSafetyFactor" -> errorSafetyFactor
  |>,
  "timingsSeconds" -> <|
    "referenceLoad" -> referenceLoadSeconds,
    "referenceCoreLoad" -> referenceCoreSeconds,
    "packageLoad" -> packageLoadSeconds,
    "paperSeries" -> paperSeriesSeconds,
    "total" -> elapsedSeconds
  |>,
  "runtimePolicy" ->
    "results and reports are fresh; isolated reference, payloads, cache and logs remain only in results_temp during execution"
|>;

writeUTF8Text[
  summaryFile,
  ToString[summary, InputForm, PageWidth -> Infinity] <> "\n"
];


(* 报告正文只写普通数值，避免 Wolfram 精度标记破坏 Markdown 反引号。 *)
reportNumericString[value_] := ToString[N[value, MachinePrecision], InputForm];


reportLines = repairSourceUTF8 /@ {
  "# MadStree v0.16 Validation-07：V5.5 三顶点八分支交叉检验",
  "",
  "## 状态",
  "",
  "- 状态：`" <> status <> "`；通过：`" <>
    ToString[summary["passedCount"]] <> "/" <> ToString[summary["checkCount"]] <> "`。",
  "- 总 wall time：`" <> reportNumericString[elapsedSeconds] <> " s`。",
  "- V5.5 SHA-256：`" <> referenceHash <> "`；Python companion：`" <>
    referencePythonHash <> "`。",
  "",
  "## 数据来源与覆盖边界",
  "",
  "- 论文来源：arXiv:2309.10849v2。Eq. (83) 定义八个 SK 分支，Appendix B Eqs. (148)--(151) 明列四个独立积分分支；Eq. (103) 是八支总和，不是单支闭式。",
  "- V5.5 直接计算全部八支并先组合对 Eq. (103)；只有该门禁通过后，同一批 V5.5 八支才作为 MadStree 的逐支外部参考。",
  "- 复共轭只检查八支直接结果之间的 identity，没有用于生成或补齐待检分支。",
  "",
  "## Exact DE、master 与 contact",
  "",
  "- 八支 `{+++,++-,+-+,+--,-++,-+-,--+,---}` 的 `{E1,E2,E3,s1,s2}` 五个 `25x25` 矩阵全部逐项 exact 比较。非零差计数：`" <>
    ToString[deNonzeroCounts, InputForm] <> "`。",
  "- MadStree contact 深度 `0/1/2` 的实际系数比：`" <>
    ToString[phaseRatiosByContactCount, InputForm] <> "`；恢复旧重复相位后的反事实为 `" <>
    ToString[legacyPhaseRatiosByContactCount, InputForm] <> "`。",
  "",
  "## 边界与独立 FlintNDE",
  "",
  "- V5.5 使用 `t=1/E2` 的单参数无穷远 chart；MadStree 使用 strict-rank `{2,1,3}` blow-up chart。原始 Frobenius 向量不在同一 chart，未作伪逐项相等。",
  "- 两边各自检查 residue/Frobenius residual，再把冻结 payload 的 `backendPackagePath` 指向独立 `package-FlintNDE/versions/FlintNDE-0.5.0/`。",
  "- 低阶 `TransportOrder=" <> ToString[transportLowOrder] <> "` 是正式输出；高阶链只作 refinement。所有八支路径、节点、主/参考差、逐分量预算和计时见 `results/summary.wl`。",
  "- V5.5 原始 complex-`nu` pinch normalization 与补入 `Exp[Pi Im[nu]]` 的隔离反事实分开保存；reference 原件未修改。",
  "",
  "## 普通点与论文总和",
  "",
  "- 共同 V5.5 坐标：`" <> ToString[targetPoint, InputForm] <> "`；MadStree 外腿能量取相反号。",
  "- 八支 MadStree 对已通过论文总和门禁的原始 V5.5 vector residual：`" <>
    reportNumericString[Lookup[Values[branchComparisons], "madStreeVsOriginalV55VectorRelativeResidual"]] <> "`。",
  "- 八支逐分量联合误差门禁：`" <>
    ToString[Lookup[Values[branchComparisons], "allComponentsWithinBudgetQ"], InputForm] <>
    "`；八支全部通过。",
  "- V5.5 原始八支总和对 Eq. (103)：差 `" <>
    reportNumericString[paperComparison["V5.5Original", "absoluteDifference"]] <>
    "`，联合预算 `" <>
    reportNumericString[paperComparison["V5.5Original", "jointBudget"]] <> "`，通过。",
  "- 额外 `Exp[Pi Im[nu]]` 反事实对 Eq. (103)：差 `" <>
    reportNumericString[paperComparison["V5.5ExtraFactorCounterfactual", "absoluteDifference"]] <>
    "`，联合预算 `" <>
    reportNumericString[paperComparison["V5.5ExtraFactorCounterfactual", "jointBudget"]] <> "`，被否决。",
  "- MadStree 八支总和对 Eq. (103)：差 `" <>
    reportNumericString[paperComparison["MadStree", "absoluteDifference"]] <>
    "`，联合预算 `" <>
    reportNumericString[paperComparison["MadStree", "jointBudget"]] <> "`，通过。",
  "- Eq. (103) cutoff：低阶 `" <> ToString[paperLowCutoff, InputForm] <>
    "`，高阶核验 `" <> ToString[paperHighCutoff, InputForm] <> "`。",
  "",
  "## 产物",
  "",
  "- 机器证据：`results/summary.wl`。",
  "- 隔离副本、输入 JSON、cache 与日志在运行时只写入 `results_temp/`；它们不是程序包输入或正式轻量证据。"
};
writeUTF8Text[
  reportFile,
  StringRiffle[reportLines, "\n"] <> "\n"
];

Print[InputForm[<|
  "status" -> status,
  "passed" -> summary["passedCount"],
  "total" -> summary["checkCount"],
  "contactRatios" -> phaseRatiosByContactCount,
  "originalBranchResiduals" -> Lookup[
    Values[branchComparisons], "madStreeVsOriginalV55VectorRelativeResidual"
  ],
  "paperChecks" -> Lookup[Values[paperComparison], "withinBudgetQ"]
|>]];

If[status =!= "passed", Exit[1]];
Exit[0];
