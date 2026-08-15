(* ::Package:: *)

(***
文件：PathEvaluation.wl
用途：把有序多变量用户点划分为最大连续复仿射单变量段，逐段拉回 dlog DE，
      并以一次请求交给 FlintNDE 规划/输运和批量多点求值。
边界：MadStree 不选择输运节点、不构造绕行、不保存路径计划；FlintNDEPathPlanning
      只控制后端对每段自动规划，或严格使用用户点作为顺序节点。
***)

(* ::Chapter:: *)
(*用户点与公开选项*)

(* 裸规则为保存点；{rules,"tmp"} 只参与输运、不进入正式导出。 *)
msEvaluationPointNormalize[entry_, userIndex_Integer] := Module[{rules, tag},
  Which[
    MatchQ[entry, {_, "tmp"}],
      rules = msRuleList[First[entry]];
      tag = "tmp",
    MatchQ[entry, {_, _String}],
      Return[Failure[
        "EvaluationPointTag",
        <|"userIndex" -> userIndex, "entry" -> HoldForm[entry],
          "allowedTaggedForms" -> {"tmp"}|>
      ]],
    True,
      rules = msRuleList[entry];
      tag = "saved"
  ];
  If[rules === $Failed,
    Return[Failure[
      "EvaluationPointRulesRequired",
      <|"userIndex" -> userIndex, "entry" -> HoldForm[entry]|>
    ]]
  ];
  <|"coordinate" -> rules, "tag" -> tag, "userIndex" -> userIndex|>
];


msMessageLanguage[value_] := If[
  MemberQ[{"EN", "CN"}, value],
  value,
  Failure["MessageLanguage", <|"value" -> value, "allowed" -> {"EN", "CN"}|>]
];


msSingularityMode[value_] := If[
  MemberQ[{"Avoid", "SingularityJump"}, value],
  value,
  Failure["SingularityMode", <|"value" -> value,
    "allowed" -> {"Avoid", "SingularityJump"}|>]
];


msBackendSingularityMode["Avoid"] := "avoid";
msBackendSingularityMode["SingularityJump"] := "singularity_jump";


msUnknownOptionNames[rawOptions_List, allowedOptions_List] := Complement[
  First /@ rawOptions,
  First /@ allowedOptions
];


msLocalizedEvaluationText[language_String, english_String, chinese_String] :=
  If[language === "CN", chinese, english];


msEvaluationPointCompletenessFailures[points_List, symbols_List] := Select[
  points,
  Function[point, AnyTrue[symbols, ! NumericQ[N[# /. point["coordinate"]]] &]]
];


(* ::Chapter:: *)
(*连续复仿射单变量分组*)

(* 差向量按 exact 复数处理；复线性相关表示属于同一个参数平面。 *)
msEvaluationCoordinateDifference[fromRules_List, toRules_List, symbols_List] :=
  Together[(msRuleValue[#, toRules] - msRuleValue[#, fromRules]) & /@ symbols];


msEvaluationExactZeroQ[value_] := TrueQ[Together[RootReduce[value]] === 0];


msEvaluationZeroDifferenceQ[difference_List] :=
  And @@ (msEvaluationExactZeroQ /@ difference);


msEvaluationComplexParameter[direction_List, difference_List] := Module[
  {pivot, parameter},
  pivot = FirstPosition[
    msEvaluationExactZeroQ /@ direction,
    False,
    Missing["Absent"]
  ];
  If[pivot === Missing["Absent"],
    Return[Failure["ZeroAffineDirection", <||>]]
  ];
  parameter = Together[difference[[First[pivot]]]/direction[[First[pivot]]]];
  If[
    And @@ (msEvaluationExactZeroQ /@ (Together /@ (difference - parameter direction))),
    parameter,
    Failure["DifferentComplexAffinePlane", <||>]
  ]
];


(* 按输入顺序取最大连续组；转角公共端点作为下一组 anchor，使各组只继承端点值。 *)
msEvaluationAffineGroups[chain_List, symbols_List] := Module[
  {groups = {}, start = 1, direction = None, position, difference, parameter},
  Do[
    difference = msEvaluationCoordinateDifference[
      chain[[start, "coordinate"]], chain[[position, "coordinate"]], symbols
    ];
    If[direction === None,
      If[! msEvaluationZeroDifferenceQ[difference], direction = difference];
      Continue[]
    ];
    parameter = msEvaluationComplexParameter[direction, difference];
    If[Head[parameter] === Failure,
      AppendTo[groups, <|
        "anchor" -> chain[[start]],
        "points" -> chain[[If[chain[[start, "userIndex"]] === 0, start + 1, start] ;; position - 1]]
      |>];
      start = position - 1;
      direction = msEvaluationCoordinateDifference[
        chain[[start, "coordinate"]], chain[[position, "coordinate"]], symbols
      ];
      If[msEvaluationZeroDifferenceQ[direction], direction = None]
    ],
    {position, 2, Length[chain]}
  ];
  AppendTo[groups, <|
    "anchor" -> chain[[start]],
    "points" -> chain[[If[chain[[start, "userIndex"]] === 0, start + 1, start] ;; Length[chain]]]
  |>];
  groups
];


(* 每组只构造一次 x=x0+s v 拉回；全部用户点以 exact Q(i) 参数传给 FlintNDE。 *)
msEvaluationPullbackGroup[de_Association, group_Association] := Module[
  {parameter, anchor, points, differences, directionPosition, directionTarget,
   direction, affine, pointParameters, failure, records},
  parameter = Unique["msEvaluationParameter"];
  anchor = group["anchor"];
  points = group["points"];
  differences = msEvaluationCoordinateDifference[
    anchor["coordinate"], #["coordinate"], de["kinematicSymbols"]
  ] & /@ points;
  directionPosition = FirstPosition[
    differences,
    difference_ /; ! msEvaluationZeroDifferenceQ[difference],
    Missing["Absent"]
  ];
  If[directionPosition === Missing["Absent"],
    directionTarget = First[points]["coordinate"];
    pointParameters = ConstantArray[0, Length[points]],
    direction = differences[[First[directionPosition]]];
    directionTarget = points[[First[directionPosition], "coordinate"]];
    pointParameters = Map[
      If[msEvaluationZeroDifferenceQ[#], 0,
        msEvaluationComplexParameter[direction, #]] &,
      differences
    ];
    failure = FirstCase[pointParameters, _Failure, None];
    If[failure =!= None, Return[failure]]
  ];
  affine = msAffineLetterData[de, anchor["coordinate"], directionTarget, parameter];
  If[Head[affine] === Failure, Return[affine]];
  records = msGaussianRationalString /@ pointParameters;
  If[MemberQ[records, $Failed],
    Return[Failure[
      "FlintNDEExactPathRequired",
      <|"reason" -> "group parameters must lie in Q(i)"|>
    ]]
  ];
  <|
    "letters" -> affine["letterRecords"],
    "startRules" -> anchor["coordinate"],
    "targetRules" -> Last[points]["coordinate"],
    "pointParameters" -> records,
    "fromUserIndex" -> anchor["userIndex"],
    "toUserIndex" -> Last[points]["userIndex"],
    "userIndices" -> points[[All, "userIndex"]]
  |>
];


(* ::Chapter:: *)
(*边界与后端请求*)

msEvaluationBoundaryInput[boundary_Association, de_Association, digits_Integer] := Module[
  {parameter, matrix, branches, weights},
  If[Lookup[boundary, "boundaryKind", "finiteFrobeniusSeries"] =!= "singularFrobenius",
    If[! ListQ[Lookup[boundary, "values", None]] ||
       Length[boundary["values"]] =!= de["masterCount"],
      Return[Failure["BoundaryVectorDimension", <|"expected" -> de["masterCount"]|>]]
    ];
    Return[<|
      "kind" -> "finite",
      "values" -> (msComplexDecimalRecord[#, digits] & /@ boundary["values"])
    |>]
  ];
  parameter = boundary["singularParameter"];
  matrix = msRationalMatrixRecords[boundary["singularConnection"], parameter];
  branches = msFrobeniusBranchRecord /@ boundary["leadingBranches"];
  weights = msComplexDecimalRecord[#, digits] & /@
    N[Lookup[boundary["leadingBranches"], "physicalWeight"], digits];
  If[matrix === $Failed || MemberQ[branches, $Failed],
    Return[Failure[
      "FlintNDEExactFrobeniusBoundaryRequired",
      <|"reason" -> "singular connection and branch data must lie in Q(i)(t)"|>
    ]]
  ];
  <|
    "kind" -> "regular_singular",
    "variable" -> "t",
    "matrix" -> matrix,
    "branches" -> branches,
    "weights" -> weights,
    "start" -> "0",
    "target" -> "1"
  |>
];


(* ::Chapter:: *)
(*结果映回*)

msEvaluationPointResults[points_List, imported_Association] := Module[
  {pointValues, lookup},
  pointValues = Flatten[
    Function[segment,
      Append[
        #,
        "flintNDE" -> <|
          "segmentIndex" -> segment["segmentIndex"],
          "relativeDifferenceInf" -> segment["relativeDifferenceInf"],
          "targetRelativeErrorMet" -> segment["targetRelativeErrorMet"]
        |>
      ] & /@ Lookup[segment, "pointValues", {}]
    ] /@ Lookup[imported, "segments", {}]
  ];
  lookup = Association[
    #["userIndex"] -> # & /@ pointValues
  ];
  Map[
    Function[point,
      With[{record = Lookup[lookup, point["userIndex"], Missing["BackendValueAbsent"]]},
        <|
          "coordinate" -> point["coordinate"],
          "userIndex" -> point["userIndex"],
          "status" -> If[point["tag"] === "saved", "saved", "transient"],
          "value" -> If[AssociationQ[record],
            msParseFlintVector[record["values"]], record],
          "flintNDE" -> If[AssociationQ[record], record["flintNDE"], <||>]
        |>
      ]
    ],
    points
  ]
];


msEvaluationSegmentReports[segments_List, imported_Association] := MapThread[
  <|
    "segmentIndex" -> #1["segmentIndex"],
    "fromUserIndex" -> #1["fromUserIndex"],
    "toUserIndex" -> #1["toUserIndex"],
    "startRules" -> #1["startRules"],
    "targetRules" -> #1["targetRules"],
    "userIndices" -> #1["userIndices"],
    "flintNDE" -> #2
  |> &,
  {segments, Lookup[imported, "segments", {}]}
];


(* ::Chapter:: *)
(*公开单阶段求值*)

Options[MSEvaluatePath] = DeleteDuplicatesBy[
  Join[
    {
      FlintNDEPathPlanning -> True,
      SingularityMode -> "Avoid",
      PythonExecutable -> Automatic,
      MSRuntimeDirectory -> Automatic,
      MessageLanguage -> "EN",
      WorkingPrecision -> 200,
      TransportOrder -> 48,
      ReferenceTransportOrder -> 64,
      TargetRelativeError -> "1e-25"
    },
    Options[MSBoundaryData]
  ],
  First
];


MSEvaluatePath[
  context_?MSContextQ,
  pointSequence_List,
  opts : OptionsPattern[]
] := Module[
  {unknownOptions, planningQ, messageLanguage, singularityMode, digits, de, points,
   failure, requiredSymbols, incomplete, boundary, chain, groups, segments,
   segmentInputs, configuration, runtimeDirectory, pythonExecutable, boundaryInput,
   inputData, imported, pointResults, notice},
  unknownOptions = msUnknownOptionNames[{opts}, Options[MSEvaluatePath]];
  If[unknownOptions =!= {},
    Return[Failure["UnknownOption", <|"function" -> "MSEvaluatePath",
      "options" -> unknownOptions|>]]
  ];
  If[pointSequence === {}, Return[Failure["EvaluationPointSequenceEmpty", <||>]]];
  planningQ = OptionValue[FlintNDEPathPlanning];
  If[! BooleanQ[planningQ],
    Return[Failure["FlintNDEPathPlanningBooleanRequired", <|"value" -> planningQ|>]]
  ];
  messageLanguage = msMessageLanguage[OptionValue[MessageLanguage]];
  If[Head[messageLanguage] === Failure, Return[messageLanguage]];
  singularityMode = msSingularityMode[OptionValue[SingularityMode]];
  If[Head[singularityMode] === Failure, Return[singularityMode]];
  If[! planningQ && singularityMode =!= "Avoid",
    Return[Failure[
      "DirectTransportAvoidModeRequired",
      <|"reason" -> "singularity jumps require FlintNDE path planning"|>
    ]]
  ];
  digits = OptionValue[WorkingPrecision];
  de = MSDLogDE[context];
  If[Lookup[de, "dlogStatus", None] =!= "certifiedByFormulaChecks",
    Return[Failure["CertifiedDLogRequired", <||>]]
  ];
  points = MapIndexed[msEvaluationPointNormalize[#1, First[#2]] &, pointSequence];
  failure = FirstCase[points, _Failure, None];
  If[failure =!= None, Return[failure]];
  requiredSymbols = DeleteDuplicates@Join[
    de["kinematicSymbols"], msBoundaryRequiredSymbols[context]
  ];
  incomplete = msEvaluationPointCompletenessFailures[points, requiredSymbols];
  If[incomplete =!= {},
    Return[Failure[
      "IncompleteEvaluationPoint",
      <|"points" -> Lookup[incomplete, "userIndex"], "symbols" -> requiredSymbols|>
    ]]
  ];
  boundary = MSBoundaryData[
    context, First[points]["coordinate"],
    Sequence @@ FilterRules[{opts}, Options[MSBoundaryData]]
  ];
  If[Head[boundary] === Failure, Return[boundary]];
  chain = Prepend[
    points,
    <|"coordinate" -> boundary["anchorRules"], "tag" -> "boundaryAnchor",
      "userIndex" -> 0|>
  ];
  groups = msEvaluationAffineGroups[chain, de["kinematicSymbols"]];
  segments = MapIndexed[
    Append[msEvaluationPullbackGroup[de, #1], "segmentIndex" -> First[#2]] &,
    groups
  ];
  failure = FirstCase[segments, _Failure, None];
  If[failure =!= None, Return[failure]];
  configuration = MSFlintNDEConfiguration[];
  If[! TrueQ[configuration["availableQ"]],
    Return[Failure["FlintNDENotAvailable", configuration]]
  ];
  runtimeDirectory = msResolveRuntimeDirectory[OptionValue[MSRuntimeDirectory]];
  If[Head[runtimeDirectory] === Failure, Return[runtimeDirectory]];
  failure = msRuntimePathLengthFailure[{runtimeDirectory}];
  If[Head[failure] === Failure, Return[failure]];
  If[msEnsureDirectory[runtimeDirectory] === $Failed,
    Return[Failure["RuntimeDirectoryCreationFailed", <|"path" -> runtimeDirectory|>]]
  ];
  pythonExecutable = msResolvePythonExecutable[OptionValue[PythonExecutable]];
  boundaryInput = msEvaluationBoundaryInput[boundary, de, digits];
  If[Head[boundaryInput] === Failure, Return[boundaryInput]];
  segmentInputs = <|
    "start" -> "0",
    "points" -> #["pointParameters"],
    "letters" -> #["letters"],
    "fromUserIndex" -> #["fromUserIndex"],
    "userIndices" -> #["userIndices"]
  |> & /@ segments;
  inputData = <|
    "schema" -> "madstree_flintnde_evaluate_v1",
    "backendPackagePath" -> configuration["resolvedPath"],
    "masterDigest" -> de["masterDigest"],
    "dimension" -> de["masterCount"],
    "segments" -> segmentInputs,
    "pathPlanning" -> planningQ,
    "singularityMode" -> msBackendSingularityMode[singularityMode],
    "boundary" -> boundaryInput,
    "workingPrecisionDigits" -> digits,
    "primaryOrder" -> OptionValue[TransportOrder],
    "referenceOrder" -> OptionValue[ReferenceTransportOrder],
    "targetRelativeError" -> ToString[OptionValue[TargetRelativeError]],
    "certificationMode" -> "embedded",
    "messageLanguage" -> messageLanguage,
    "columnVectorConvention" -> "Y'=A(s)Y",
    "dlogStatus" -> de["dlogStatus"]
  |>;
  imported = msExecuteFlintNDEAdapter[inputData, pythonExecutable, runtimeDirectory];
  If[Head[imported] === Failure, Return[imported]];
  If[Lookup[imported, "status", None] === "singularPathRefused",
    Return[Failure[
      "SingularPathOnUserPolyline",
      <|"message" -> imported["message"],
        "segmentIndex" -> imported["segmentIndex"],
        "Singular Path Pair" -> imported["singularPathPairs"]|>
    ]]
  ];
  If[Lookup[imported, "status", None] =!= "success",
    Return[Failure["FlintNDEPathEvaluationFailed", <|"backend" -> imported|>]]
  ];
  notice = imported["message"];
  Print[notice];
  pointResults = msEvaluationPointResults[points, imported];
  <|
    "status" -> "computed",
    "executionAction" -> imported["executionAction"],
    "pathPlanning" -> planningQ,
    "masters" -> de["masters"],
    "masterDigest" -> de["masterDigest"],
    "values" -> msParseFlintVector[imported["finalValues"]],
    "pointResults" -> pointResults,
    "boundary" -> boundary,
    "segments" -> msEvaluationSegmentReports[segments, imported],
    "flintNDE" -> imported,
    "backendConfiguration" -> configuration,
    "runtimeDirectory" -> runtimeDirectory,
    "message" -> notice,
    "columnVectorConvention" -> "Y'=A(s)Y"
  |>
];


MSEvaluatePath[___] := Failure[
  "InitializedContextRequired",
  <|"function" -> "MSEvaluatePath"|>
];


(* ::Chapter:: *)
(*不同 ep 的有界并行求值*)

Options[msEvaluateEpBatch] = DeleteDuplicatesBy[
  Join[{ParallelTaskCount -> 12}, Options[MSEvaluatePath]],
  First
];


(* 实现思路：每个 ep 先在 Wolfram 侧独立生成正规化后的边界、复仿射分段和 exact
   FlintNDE 请求；随后只把这些自包含请求交给 Python 有界进程池。 *)
msPrepareEpEvaluationTask[
  context_?MSContextQ,
  pointSequence_List,
  optionValues_Association
] := Module[
  {planningQ, messageLanguage, singularityMode, digits, de, points, failure,
   requiredSymbols, incomplete, boundary, chain, groups, segments, configuration,
   runtimeDirectory, pythonExecutable, boundaryInput, segmentInputs, inputData},
  If[pointSequence === {}, Return[Failure["EvaluationPointSequenceEmpty", <||>]]];
  planningQ = optionValues[FlintNDEPathPlanning];
  If[! BooleanQ[planningQ],
    Return[Failure["FlintNDEPathPlanningBooleanRequired", <|"value" -> planningQ|>]]
  ];
  messageLanguage = msMessageLanguage[optionValues[MessageLanguage]];
  If[Head[messageLanguage] === Failure, Return[messageLanguage]];
  singularityMode = msSingularityMode[optionValues[SingularityMode]];
  If[Head[singularityMode] === Failure, Return[singularityMode]];
  If[! planningQ && singularityMode =!= "Avoid",
    Return[Failure["DirectTransportAvoidModeRequired",
      <|"reason" -> "singularity jumps require FlintNDE path planning"|>]]
  ];
  digits = optionValues[WorkingPrecision];
  de = MSDLogDE[context];
  If[Lookup[de, "dlogStatus", None] =!= "certifiedByFormulaChecks",
    Return[Failure["CertifiedDLogRequired", <||>]]
  ];
  points = MapIndexed[msEvaluationPointNormalize[#1, First[#2]] &, pointSequence];
  failure = FirstCase[points, _Failure, None];
  If[failure =!= None, Return[failure]];
  requiredSymbols = DeleteDuplicates@Join[
    de["kinematicSymbols"], msBoundaryRequiredSymbols[context]
  ];
  incomplete = msEvaluationPointCompletenessFailures[points, requiredSymbols];
  If[incomplete =!= {},
    Return[Failure["IncompleteEvaluationPoint",
      <|"points" -> Lookup[incomplete, "userIndex"], "symbols" -> requiredSymbols|>]]
  ];
  boundary = MSBoundaryData[
    context, First[points]["coordinate"],
    Sequence @@ FilterRules[Normal[optionValues], Options[MSBoundaryData]]
  ];
  If[Head[boundary] === Failure, Return[boundary]];
  chain = Prepend[points, <|"coordinate" -> boundary["anchorRules"],
    "tag" -> "boundaryAnchor", "userIndex" -> 0|>];
  groups = msEvaluationAffineGroups[chain, de["kinematicSymbols"]];
  segments = MapIndexed[
    Append[msEvaluationPullbackGroup[de, #1], "segmentIndex" -> First[#2]] &,
    groups
  ];
  failure = FirstCase[segments, _Failure, None];
  If[failure =!= None, Return[failure]];
  configuration = MSFlintNDEConfiguration[];
  If[! TrueQ[configuration["availableQ"]],
    Return[Failure["FlintNDENotAvailable", configuration]]
  ];
  runtimeDirectory = msResolveRuntimeDirectory[optionValues[MSRuntimeDirectory]];
  If[Head[runtimeDirectory] === Failure, Return[runtimeDirectory]];
  failure = msRuntimePathLengthFailure[{runtimeDirectory}];
  If[Head[failure] === Failure, Return[failure]];
  If[msEnsureDirectory[runtimeDirectory] === $Failed,
    Return[Failure["RuntimeDirectoryCreationFailed", <|"path" -> runtimeDirectory|>]]
  ];
  pythonExecutable = msResolvePythonExecutable[optionValues[PythonExecutable]];
  boundaryInput = msEvaluationBoundaryInput[boundary, de, digits];
  If[Head[boundaryInput] === Failure, Return[boundaryInput]];
  segmentInputs = <|"start" -> "0", "points" -> #["pointParameters"],
    "letters" -> #["letters"], "fromUserIndex" -> #["fromUserIndex"],
    "userIndices" -> #["userIndices"]|> & /@ segments;
  inputData = <|
    "schema" -> "madstree_flintnde_evaluate_v1",
    "backendPackagePath" -> configuration["resolvedPath"],
    "masterDigest" -> de["masterDigest"],
    "dimension" -> de["masterCount"],
    "segments" -> segmentInputs,
    "pathPlanning" -> planningQ,
    "singularityMode" -> msBackendSingularityMode[singularityMode],
    "boundary" -> boundaryInput,
    "workingPrecisionDigits" -> digits,
    "primaryOrder" -> optionValues[TransportOrder],
    "referenceOrder" -> optionValues[ReferenceTransportOrder],
    "targetRelativeError" -> ToString[optionValues[TargetRelativeError]],
    "certificationMode" -> "embedded",
    "messageLanguage" -> messageLanguage,
    "columnVectorConvention" -> "Y'=A(s)Y",
    "dlogStatus" -> de["dlogStatus"]
  |>;
  <|"points" -> points, "segments" -> segments, "boundary" -> boundary,
    "de" -> de, "configuration" -> configuration,
    "runtimeDirectory" -> runtimeDirectory, "pythonExecutable" -> pythonExecutable,
    "inputData" -> inputData|>
];


msFinalizeEpEvaluationTask[task_Association, imported_Association] := Module[
  {pointResults},
  If[Lookup[imported, "status", None] =!= "success",
    Return[Failure["FlintNDEPathEvaluationFailed", <|"backend" -> imported|>]]
  ];
  pointResults = msEvaluationPointResults[task["points"], imported];
  <|
    "status" -> "computed",
    "executionAction" -> imported["executionAction"],
    "pathPlanning" -> imported["pathPlanning"],
    "masters" -> task["de", "masters"],
    "masterDigest" -> task["de", "masterDigest"],
    "values" -> msParseFlintVector[imported["finalValues"]],
    "pointResults" -> pointResults,
    "boundary" -> task["boundary"],
    "segments" -> msEvaluationSegmentReports[task["segments"], imported],
    "flintNDE" -> imported,
    "backendConfiguration" -> task["configuration"],
    "runtimeDirectory" -> task["runtimeDirectory"],
    "message" -> imported["message"],
    "columnVectorConvention" -> "Y'=A(s)Y"
  |>
];


msEvaluateEpBatch[
  context_?MSContextQ,
  Rule[epSymbol_Symbol, epValues_List],
  pointTemplate_List,
  opts : OptionsPattern[]
] := Module[
  {unknownOptions, parallelCount, optionValues, tasks, failure, pythonExecutables,
   runtimeDirectories, batchInput, imported, results, messageLanguage},
  unknownOptions = msUnknownOptionNames[{opts}, Options[msEvaluateEpBatch]];
  If[unknownOptions =!= {},
    Return[Failure["UnknownOption", <|"function" -> "msEvaluateEpBatch",
      "options" -> unknownOptions|>]]
  ];
  If[epValues === {}, Return[Failure["EpValueListEmpty", <||>]]];
  parallelCount = OptionValue[ParallelTaskCount];
  If[! IntegerQ[parallelCount] || parallelCount < 1,
    Return[Failure["ParallelTaskCountPositiveIntegerRequired",
      <|"value" -> parallelCount, "default" -> 12|>]]
  ];
  optionValues = Join[
    Association[Options[MSEvaluatePath]],
    Association[FilterRules[{opts}, Options[MSEvaluatePath]]]
  ];
  tasks = msPrepareEpEvaluationTask[
    context, pointTemplate /. epSymbol -> #, optionValues
  ] & /@ epValues;
  failure = FirstCase[tasks, _Failure, None];
  If[failure =!= None, Return[failure]];
  pythonExecutables = DeleteDuplicates[Lookup[tasks, "pythonExecutable"]];
  runtimeDirectories = DeleteDuplicates[Lookup[tasks, "runtimeDirectory"]];
  If[Length[pythonExecutables] =!= 1 || Length[runtimeDirectories] =!= 1,
    Return[Failure["EpBatchExecutionConfigurationMismatch", <||>]]
  ];
  messageLanguage = optionValues[MessageLanguage];
  Print[msLocalizedEvaluationText[
    messageLanguage,
    "MadStree: independent ep tasks default to 12 workers; requested " <>
      ToString[parallelCount] <> ", effective " <>
      ToString[Min[parallelCount, Length[epValues]]] <>
      ". Queued tasks start automatically as workers finish.",
    "MadStree：不同 ep 任务缺省并行数为 12；本次请求 " <>
      ToString[parallelCount] <> "，实际并行数为 " <>
      ToString[Min[parallelCount, Length[epValues]]] <>
      "。任务完成后自动续交队列。"
  ]];
  batchInput = <|
    "schema" -> "madstree_flintnde_ep_batch_v1",
    "parallelTaskCount" -> parallelCount,
    "tasks" -> MapThread[<|"ep" -> ToString[#1, InputForm],
      "request" -> #2["inputData"]|> &, {epValues, tasks}],
    "messageLanguage" -> messageLanguage
  |>;
  imported = msExecuteFlintNDEAdapter[
    batchInput, First[pythonExecutables], First[runtimeDirectories]
  ];
  If[Head[imported] === Failure, Return[imported]];
  If[Lookup[imported, "status", None] =!= "success",
    Return[Failure["FlintNDEEpBatchFailed", <|"backend" -> imported|>]]
  ];
  results = MapThread[
    <|"ep" -> #1, "evaluation" -> msFinalizeEpEvaluationTask[#2, #3["result"]]|> &,
    {epValues, tasks, imported["results"]}
  ];
  <|
    "status" -> If[FreeQ[results, _Failure, Infinity], "computed", "failed"],
    "epSymbol" -> HoldForm[epSymbol],
    "epValues" -> epValues,
    "parallelTaskCountRequested" -> imported["parallelTaskCountRequested"],
    "parallelTaskCountEffective" -> imported["parallelTaskCountEffective"],
    "results" -> results,
    "message" -> imported["message"],
    "runtimeDirectory" -> First[runtimeDirectories]
  |>
];


(* ::Chapter:: *)
(*自适应 ep Laurent 重构*)

(* 对有限阶 Laurent 展开提取第一个可证明非零的整数幂。返回 Missing 表示给定阶数内
   没有非零项；Failure 表示表达式不是程序当前可认证的有限 Laurent 型。 *)
msEpLaurentValuation[expression_, epSymbol_Symbol, maximumPower_Integer] := Module[
  {simplified, series, valuation},
  simplified = Together[PowerExpand[Refine[expression, Element[epSymbol, Reals]]]];
  If[TrueQ[PossibleZeroQ[simplified]], Return[Infinity]];
  If[FreeQ[simplified, epSymbol], Return[0]];
  series = Quiet@Check[Series[simplified, {epSymbol, 0, maximumPower}], $Failed];
  If[series === $Failed || ! FreeQ[series, Indeterminate | ComplexInfinity | DirectedInfinity],
    Return[Failure["EpNonLaurentExpression", <|"expression" -> HoldForm[expression]|>]]
  ];
  valuation = Replace[
    series,
    HoldPattern[SeriesData[epSymbol, 0, coefficients_, minimum_, _, denominator_]] :>
      Module[{position},
        position = FirstPosition[
          coefficients,
          coefficient_ /; ! TrueQ[PossibleZeroQ[coefficient]],
          Missing["NoCoefficient"],
          {1},
          Heads -> False
        ];
        If[
          MissingQ[position],
          Missing["AboveCheckedOrder", <|"minimumPossiblePower" -> minimum/denominator|>],
          (minimum + First[position] - 1)/denominator
        ]
      ],
    {0}
  ];
  If[Head[valuation] === SeriesData,
    Return[Failure["EpLaurentSeriesUnresolved", <|"series" -> HoldForm[series]|>]]
  ];
  If[NumberQ[valuation] && ! IntegerQ[valuation],
    Return[Failure["EpNonIntegerPower", <|"power" -> valuation,
      "expression" -> HoldForm[expression]|>]]
  ];
  valuation
];


(* 在任何 ep 数值求解之前，从同源 dlog residue 与生产 Frobenius 边界认证最低阶。
   正则 DE 的基本解在 ep 上解析可逆，因而保持非零边界 formal data 的 valuation。 *)
msEpLaurentSupportCertificate[
  context_?MSContextQ,
  epSymbol_Symbol,
  pointTemplate_List,
  maximumPower_Integer,
  optionValues_Association
] := Module[
  {de, points, failure, targetRules, limitRules, requiredSymbols, unresolved,
   scale, order, workingPrecision, vertexIds, rankOrder, chartCertificate,
   seriesData, deEntries, deValuations, boundaryGroups, boundaryRecords,
   boundaryValuations, finiteBoundaryValuations, leadingPower,
   formalLog = Unique["msEpLog"], groupKey, residue, identity,
   distinctExponents, recurrenceRankRecords, resonanceRecords,
   finiteDeValuations},
  If[pointTemplate === {},
    Return[Failure["EvaluationPointSequenceEmpty", <||>]]
  ];
  points = MapIndexed[msEvaluationPointNormalize[#1, First[#2]] &, pointTemplate];
  failure = FirstCase[points, _Failure, None];
  If[failure =!= None, Return[failure]];
  targetRules = First[points]["coordinate"];
  limitRules = {epSymbol -> 0};
  de = MSDLogDE[context];
  If[Lookup[de, "dlogStatus", None] =!= "certifiedByFormulaChecks",
    Return[Failure["CertifiedDLogRequired", <||>]]
  ];
  If[AnyTrue[
      de["kinematicSymbols"],
      ! FreeQ[msRuleValue[#, targetRules], epSymbol] &
    ],
    Return[Failure["EpDependentPathCoordinatesNotCertified", <|
      "symbols" -> Select[
        de["kinematicSymbols"],
        ! FreeQ[msRuleValue[#, targetRules], epSymbol] &
      ]
    |>]]
  ];
  requiredSymbols = msBoundaryRequiredSymbols[context];
  unresolved = Select[
    requiredSymbols,
    ! NumericQ[N[# /. targetRules /. limitRules, optionValues[WorkingPrecision]]] &
  ];
  If[unresolved =!= {},
    Return[Failure["IncompleteRegularizationLimitPoint", <|"symbols" -> unresolved|>]]
  ];
  scale = optionValues[BoundaryScale];
  order = optionValues[BoundarySeriesOrder];
  workingPrecision = optionValues[WorkingPrecision];
  If[! NumericQ[N[scale]] || ! TrueQ[N[scale] > 1],
    Return[Failure["BoundaryScaleMustExceedOne", <|"value" -> scale|>]]
  ];
  If[! IntegerQ[order] || order < 0,
    Return[Failure["BoundarySeriesOrderMustBeNonNegative", <|"value" -> order|>]]
  ];
  vertexIds = Lookup[context["vertices"], "id"];
  rankOrder = Replace[
    optionValues[RankOrder],
    Automatic :> msPreferredVertexOrder[context, targetRules /. limitRules]
  ];
  If[Sort[rankOrder] =!= Sort[vertexIds] || ! DuplicateFreeQ[rankOrder],
    Return[Failure["InvalidRankOrder", <|"expected" -> vertexIds,
      "actual" -> rankOrder|>]]
  ];
  chartCertificate = MSBoundaryChartCertificate[
    context, targetRules /. limitRules, RankOrder -> rankOrder
  ];
  If[Head[chartCertificate] === Failure ||
      ! TrueQ[chartCertificate["normalCrossingQ"]],
    Return[Failure["BoundaryChartNotCertified", <|"certificate" -> chartCertificate|>]]
  ];
  seriesData = msGenericSectorFrobeniusData[
    context, de, targetRules, scale, rankOrder, order, workingPrecision, limitRules
  ];
  If[Head[seriesData] === Failure, Return[seriesData]];

  deEntries = Flatten[{
    Values[de["letterMatrices"]] /. targetRules,
    seriesData["singularConnection"],
    seriesData["singularResidue"]
  }];
  deValuations = msEpLaurentValuation[#, epSymbol, 0] & /@ deEntries;
  failure = FirstCase[deValuations, _Failure, None];
  If[failure =!= None, Return[failure]];
  finiteDeValuations = DeleteCases[deValuations, Infinity];
  If[finiteDeValuations === {},
    Return[Failure["EmptyDifferentialEquationSupport", <||>]]
  ];
  If[AnyTrue[finiteDeValuations, # < 0 &],
    Return[Failure["EpSingularDifferentialEquation", <|
      "minimumDifferentialEquationPower" -> Min[finiteDeValuations]
    |>]]
  ];

  (* 记录共振层供诊断。这里不能把单个递推矩阵的降秩直接当成物理解的 ep pole：
     生产边界来自收敛的定义积分，所有物理分支必须先组合后再判断 Laurent 支撑。 *)
  residue = seriesData["singularResidue"];
  identity = IdentityMatrix[Length[residue]];
  distinctExponents = DeleteDuplicates[
    Lookup[seriesData["leadingBranches"], "frobeniusExponent"],
    TrueQ[Simplify[#1 - #2] === 0] &
  ];
  recurrenceRankRecords = Flatten@Table[
    With[
      {operator = Together[(exponent + degree) identity - residue]},
      <|
        "frobeniusExponent" -> exponent,
        "degree" -> degree,
        "genericRank" -> MatrixRank[operator],
        "limitRank" -> MatrixRank[operator /. limitRules]
      |>
    ],
    {exponent, distinctExponents},
    {degree, 0, order}
  ];
  resonanceRecords = Select[
    recurrenceRankRecords,
    #["genericRank"] =!= #["limitRank"] &
  ];

  groupKey[branch_Association] := ToString[
    InputForm[{Simplify[branch["frobeniusExponent"] /. limitRules],
      branch["logPower"]}]
  ];
  boundaryGroups = GatherBy[seriesData["leadingBranches"], groupKey];
  boundaryRecords = Map[
    Function[group,
      With[
        {limitExponent = Simplify[First[group]["frobeniusExponent"] /. limitRules],
         logPower = First[group]["logPower"]},
        <|
          "limitExponent" -> limitExponent,
          "logPower" -> logPower,
          "branchCount" -> Length[group],
          "formalVector" -> Simplify[Total[
            Function[branch,
              branch["physicalWeight"] branch["normalizedLeadingVector"]
                Exp[(branch["frobeniusExponent"] - limitExponent) formalLog]
            ] /@ group
          ]]
        |>
      ]
    ],
    boundaryGroups
  ];
  boundaryValuations = Map[
    Function[record,
      With[{valuations = msEpLaurentValuation[#, epSymbol, maximumPower] & /@
          record["formalVector"]},
        failure = FirstCase[valuations, _Failure, None];
        If[failure =!= None, failure,
          Append[record, "componentValuations" -> valuations]]
      ]
    ],
    boundaryRecords
  ];
  failure = FirstCase[boundaryValuations, _Failure, None];
  If[failure =!= None, Return[failure]];
  finiteBoundaryValuations = DeleteCases[
    Flatten[Lookup[boundaryValuations, "componentValuations"]],
    Infinity | _Missing
  ];
  If[finiteBoundaryValuations === {},
    Return[Failure["EpLeadingPowerAboveRequestedRange", <|
      "maximumPower" -> maximumPower,
      "boundaryRecords" -> (KeyDrop[#, "formalVector"] & /@ boundaryValuations)
    |>]]
  ];
  leadingPower = Min[finiteBoundaryValuations];
  If[! IntegerQ[leadingPower],
    Return[Failure["EpLeadingPowerAboveRequestedRange", <|
      "maximumPower" -> maximumPower,
      "boundaryRecords" -> (KeyDrop[#, "formalVector"] & /@ boundaryValuations)
    |>]]
  ];
  <|
    "status" -> "certified",
    "method" -> "symbolicBoundaryAndRegularDLogValuation",
    "leadingPower" -> leadingPower,
    "maximumPowerChecked" -> maximumPower,
    "minimumDifferentialEquationPower" ->
      Min[0, Sequence @@ finiteDeValuations],
    "differentialEquationRegularAtEpZeroQ" -> True,
    "boundaryFiniteLaurentAtEpZeroQ" -> True,
    "boundaryDefinitionAnalyticAtEpZeroQ" -> TrueQ[leadingPower >= 0],
    "frobeniusRecurrenceRankStableQ" -> (resonanceRecords === {}),
    "frobeniusRecurrenceOperatorCount" -> Length[recurrenceRankRecords],
    "frobeniusResonanceRecords" -> resonanceRecords,
    "boundaryRecords" -> (KeyDrop[#, "formalVector"] & /@ boundaryValuations),
    "rankOrder" -> rankOrder,
    "normalCrossingQ" -> True,
    "proof" -> "The formal boundary valuation is preserved by an ep-analytic invertible fundamental matrix."
  |>
];

Options[MSReconstructEpSeries] = DeleteDuplicatesBy[
  Join[
    {
      EpGoalDigits -> 20,
      MaximumEpPower -> 0,
      EpFitExtraOrder -> 2,
      EpFitOrderIncrement -> 2,
      EpFitMaximumRounds -> 3,
      ParallelTaskCount -> 12,
      BoundarySeriesOrder -> Automatic
    },
    DeleteCases[
      Options[MSEvaluatePath],
      HoldPattern[(TransportOrder | ReferenceTransportOrder |
        TargetRelativeError | BoundarySeriesOrder) -> _]
    ]
  ],
  First
];


(* 控制请求只生成 exact ep 网格或消费 Acb 球；图、dlog 和边界始终由 MadStree 按每个
   ep 单独建立，FlintNDE 不读取任何 MadStree 物理 metadata。 *)
msEpSeriesControl[
  action_String,
  payload_Association,
  configuration_Association,
  pythonExecutable_,
  runtimeDirectory_String
] := msExecuteFlintNDEAdapter[
  Join[
    <|
      "schema" -> "madstree_flintnde_ep_series_control_v1",
      "action" -> action,
      "backendPackagePath" -> configuration["resolvedPath"]
    |>,
    payload
  ],
  pythonExecutable,
  runtimeDirectory
];


msEpSeriesPointValues[epBatch_Association] := Module[{evaluations},
  evaluations = Lookup[epBatch["results"], "evaluation"];
  If[
    ! AllTrue[evaluations, AssociationQ[#] && # ["status"] === "computed" &],
    Return[Failure["EpSeriesPointEvaluationFailed", <|"batch" -> epBatch|>]]
  ];
  Lookup[Lookup[evaluations, "flintNDE"], "finalValues"]
];


msEpSeriesStageOptions[
  baseOptions_Association,
  plan_Association,
  goalDigits_Integer
] := Module[{boundaryOrder, boundaryScale},
  boundaryScale = baseOptions[BoundaryScale];
  boundaryOrder = baseOptions[BoundarySeriesOrder];
  If[boundaryOrder === Automatic,
    If[! NumericQ[N[boundaryScale]] || ! TrueQ[N[boundaryScale] > 1],
      Return[Failure["BoundaryScaleGreaterThanOneRequired",
        <|"value" -> boundaryScale|>]]
    ];
    boundaryOrder = Max[
      24,
      Ceiling[(goalDigits + 10)/Log[10, N[boundaryScale, 30]]]
    ]
  ];
  If[! IntegerQ[boundaryOrder] || boundaryOrder < 0,
    Return[Failure["BoundarySeriesOrderMustBeNonNegative",
      <|"value" -> boundaryOrder|>]]
  ];
  Join[
    baseOptions,
    <|
      WorkingPrecision -> plan["workingPrecisionDigits"],
      TransportOrder -> plan["primaryOrder"],
      ReferenceTransportOrder -> plan["referenceOrder"],
      TargetRelativeError -> plan["targetRelativeError"],
      BoundarySeriesOrder -> boundaryOrder
    |>
  ]
];


msEvaluateAutomaticEpPoints[
  context_?MSContextQ,
  epSymbol_Symbol,
  pointStrings_List,
  pointTemplate_List,
  parallelCount_Integer,
  stageOptions_Association
] := Module[{epValues},
  epValues = ToExpression /@ pointStrings;
  msEvaluateEpBatch[
    context,
    epSymbol -> epValues,
    pointTemplate,
    ParallelTaskCount -> parallelCount,
    Sequence @@ FilterRules[Normal[stageOptions], Options[MSEvaluatePath]]
  ]
];


MSReconstructEpSeries[
  context_?MSContextQ,
  epSymbol_Symbol,
  pointTemplate_List,
  opts : OptionsPattern[]
] := Module[
  {unknownOptions, maximumPower, goalDigits, parallelCount, baseOptions, configuration, failure,
   runtimeDirectory, pythonExecutable, supportCertificate,
   leadingPower, fitExtraOrder, fitOrderIncrement,
   fitMaximumRounds,
   productionHistory = {}, productionPlan, productionOptions,
   productionCache = <||>, productionEvaluationCache = <||>,
   validationCache = <||>, validationEvaluationCache = <||>,
   newProductionStrings, newValidationStrings, newPointStrings, newBatch,
   newValues, productionStrings, validationStrings, fit, coefficients,
   pointEvaluations, messageLanguage, productionRound,
   maximumEffectiveParallelCount = 0},
  unknownOptions = msUnknownOptionNames[{opts}, Options[MSReconstructEpSeries]];
  If[unknownOptions =!= {},
    Return[Failure["UnknownOption", <|"function" -> "MSReconstructEpSeries",
      "options" -> unknownOptions|>]]
  ];
  maximumPower = OptionValue[MaximumEpPower];
  If[! IntegerQ[maximumPower],
    Return[Failure["MaximumEpPowerIntegerRequired", <|"value" -> maximumPower|>]]
  ];
  goalDigits = OptionValue[EpGoalDigits];
  fitExtraOrder = OptionValue[EpFitExtraOrder];
  fitOrderIncrement = OptionValue[EpFitOrderIncrement];
  fitMaximumRounds = OptionValue[EpFitMaximumRounds];
  parallelCount = OptionValue[ParallelTaskCount];
  If[! IntegerQ[goalDigits] || goalDigits < 1,
    Return[Failure["EpGoalDigitsPositiveIntegerRequired", <|"value" -> goalDigits|>]]
  ];
  If[! IntegerQ[parallelCount] || parallelCount < 1,
    Return[Failure["ParallelTaskCountPositiveIntegerRequired",
      <|"value" -> parallelCount, "default" -> 12|>]]
  ];
  If[! IntegerQ[fitExtraOrder] || fitExtraOrder < 0,
    Return[Failure["EpFitExtraOrderNonNegativeIntegerRequired",
      <|"value" -> fitExtraOrder, "default" -> 2|>]]
  ];
  If[! IntegerQ[fitOrderIncrement] || fitOrderIncrement < 1,
    Return[Failure["EpFitOrderIncrementPositiveIntegerRequired",
      <|"value" -> fitOrderIncrement, "default" -> 2|>]]
  ];
  If[! IntegerQ[fitMaximumRounds] || fitMaximumRounds < 1,
    Return[Failure["EpFitMaximumRoundsPositiveIntegerRequired",
      <|"value" -> fitMaximumRounds, "default" -> 3|>]]
  ];
  baseOptions = Join[
    Association[Options[MSReconstructEpSeries]],
    Association[FilterRules[{opts}, Options[MSReconstructEpSeries]]]
  ];
  messageLanguage = msMessageLanguage[baseOptions[MessageLanguage]];
  If[Head[messageLanguage] === Failure, Return[messageLanguage]];
  If[baseOptions[BoundarySeriesOrder] === Automatic,
    If[! NumericQ[N[baseOptions[BoundaryScale]]] ||
        ! TrueQ[N[baseOptions[BoundaryScale]] > 1],
      Return[Failure["BoundaryScaleGreaterThanOneRequired",
        <|"value" -> baseOptions[BoundaryScale]|>]]
    ];
    baseOptions[BoundarySeriesOrder] = Max[
      24,
      Ceiling[(goalDigits + 10)/Log[10, N[baseOptions[BoundaryScale], 30]]]
    ]
  ];
  configuration = MSFlintNDEConfiguration[];
  If[! TrueQ[configuration["availableQ"]],
    Return[Failure["FlintNDENotAvailable", configuration]]
  ];
  runtimeDirectory = msResolveRuntimeDirectory[baseOptions[MSRuntimeDirectory]];
  If[Head[runtimeDirectory] === Failure, Return[runtimeDirectory]];
  failure = msRuntimePathLengthFailure[{runtimeDirectory}];
  If[Head[failure] === Failure, Return[failure]];
  If[msEnsureDirectory[runtimeDirectory] === $Failed,
    Return[Failure["RuntimeDirectoryCreationFailed", <|"path" -> runtimeDirectory|>]]
  ];
  pythonExecutable = msResolvePythonExecutable[baseOptions[PythonExecutable]];
  supportCertificate = msEpLaurentSupportCertificate[
    context, epSymbol, pointTemplate, maximumPower, baseOptions
  ];
  If[Head[supportCertificate] === Failure, Return[supportCertificate]];
  leadingPower = supportCertificate["leadingPower"];
  If[maximumPower < leadingPower,
    Return[Failure["MaximumEpPowerBelowLeadingPower",
      <|"maximumPower" -> maximumPower, "leadingPower" -> leadingPower|>]]
  ];

  fit = Missing["NotAccepted"];
  Do[
    productionPlan = msEpSeriesControl[
      "production_plan",
      <|"maximumPower" -> maximumPower, "goalDigits" -> goalDigits,
        "leadingPower" -> leadingPower, "sampleSpacing" -> "0.01",
        "validationSampleCount" -> 2, "validationScale" -> "0.5",
        "maximumSamples" -> 100, "extraWorkingPrecision" -> 0.,
        "productionRound" -> productionRound,
        "fitExtraOrder" -> fitExtraOrder,
        "fitOrderIncrement" -> fitOrderIncrement,
        "fitMaximumRounds" -> fitMaximumRounds|>,
      configuration, pythonExecutable, runtimeDirectory
    ];
    If[Head[productionPlan] === Failure, Return[productionPlan]];
    productionOptions = msEpSeriesStageOptions[baseOptions, productionPlan, goalDigits];
    If[Head[productionOptions] === Failure, Return[productionOptions]];
    productionStrings = productionPlan["points"];
    validationStrings = productionPlan["validationPoints"];
    newProductionStrings = Select[
      productionStrings, ! KeyExistsQ[productionCache, #] &
    ];
    newValidationStrings = Select[
      validationStrings, ! KeyExistsQ[validationCache, #] &
    ];
    newPointStrings = Join[newProductionStrings, newValidationStrings];
    If[newPointStrings =!= {},
      newBatch = msEvaluateAutomaticEpPoints[
        context, epSymbol, newPointStrings, pointTemplate,
        parallelCount, productionOptions
      ];
      If[Head[newBatch] === Failure, Return[newBatch]];
      maximumEffectiveParallelCount = Max[
        maximumEffectiveParallelCount,
        newBatch["parallelTaskCountEffective"]
      ];
      newValues = msEpSeriesPointValues[newBatch];
      If[Head[newValues] === Failure, Return[newValues]];
      KeyValueMap[
        AssociateTo[productionCache, #1 -> #2] &,
        AssociationThread[
          newProductionStrings,
          Take[newValues, Length[newProductionStrings]]
        ]
      ];
      KeyValueMap[
        AssociateTo[validationCache, #1 -> #2] &,
        AssociationThread[
          newValidationStrings,
          Drop[newValues, Length[newProductionStrings]]
        ]
      ];
      KeyValueMap[
        AssociateTo[productionEvaluationCache, #1 -> #2] &,
        AssociationThread[
          newProductionStrings,
          Take[newBatch["results"], Length[newProductionStrings]]
        ]
      ];
      KeyValueMap[
        AssociateTo[validationEvaluationCache, #1 -> #2] &,
        AssociationThread[
          newValidationStrings,
          Drop[newBatch["results"], Length[newProductionStrings]]
        ]
      ]
    ];
    fit = msEpSeriesControl[
      "fit",
      <|"maximumPower" -> maximumPower, "goalDigits" -> goalDigits,
        "leadingPower" -> leadingPower,
        "workingPrecisionDigits" -> productionPlan["workingPrecisionDigits"],
        "points" -> productionStrings,
        "values" -> Lookup[productionCache, productionStrings],
        "validationPoints" -> validationStrings,
        "validationValues" -> Lookup[validationCache, validationStrings],
        "validationTolerance" -> "1e-" <> ToString[goalDigits]|>,
      configuration, pythonExecutable, runtimeDirectory
    ];
    If[Head[fit] === Failure, Return[fit]];
    AppendTo[productionHistory, <|
      "round" -> productionRound,
      "internalMaximumPower" -> productionPlan["internalMaximumPower"],
      "newProductionPointCount" -> Length[newProductionStrings],
      "reusedProductionPointCount" ->
        Length[productionStrings] - Length[newProductionStrings],
      "newValidationPointCount" -> Length[newValidationStrings],
      "reusedValidationPointCount" ->
        Length[validationStrings] - Length[newValidationStrings],
      "fitStatus" -> fit["fitStatus"],
      "maximumValidationRelativeResidual" -> Lookup[
        Lookup[fit, "diagnostics", <||>],
        "maximum_validation_relative_residual",
        Missing["NotAvailable"]
      ],
      "reason" -> Lookup[fit, "reason", None]
    |>];
    If[fit["fitStatus"] === "accepted", Break[]],
    {productionRound, 1, fitMaximumRounds}
  ];
  If[! AssociationQ[fit] || Lookup[fit, "fitStatus", None] =!= "accepted",
    Return[Failure["EpSeriesValidationFailed",
      <|"productionRounds" -> productionHistory|>]]
  ];
  coefficients = Association@KeyValueMap[
    ToExpression[#1] -> msParseFlintVector[#2] &,
    fit["coefficients"]
  ];
  Print[msLocalizedEvaluationText[
    messageLanguage,
    "MadStree reconstructed ep powers " <> ToString[leadingPower] <> " through " <>
      ToString[maximumPower] <> " with " <> ToString[Length[productionStrings]] <>
      " automatic production points and " <>
      ToString[Length[productionPlan["validationPoints"]]] <>
      " independent validation points; the ep worker limit was " <>
      ToString[parallelCount] <> " (default 12).",
    "MadStree 已自适应重构 ep^" <> ToString[leadingPower] <> " 至 ep^" <>
      ToString[maximumPower] <> "；程序自动使用 " <> ToString[Length[productionStrings]] <>
      " 个生产点和 " <> ToString[Length[productionPlan["validationPoints"]]] <>
      " 个独立验证点，ep 任务并行上限为 " <> ToString[parallelCount] <>
      "（缺省 12）。"
  ]];
  <|
    "status" -> "computed",
    "epSymbol" -> HoldForm[epSymbol],
    "leadingPower" -> leadingPower,
    "maximumPower" -> maximumPower,
    "internalMaximumPower" -> fit["internalMaximumPower"],
    "initialInternalMaximumPower" ->
      First[productionHistory]["internalMaximumPower"],
    "fitExpansionRoundCount" -> Length[productionHistory] - 1,
    "coefficients" -> coefficients,
    "poleCoefficients" -> KeySelect[coefficients, # < 0 &],
    "finitePart" -> Lookup[coefficients, 0, Missing["NotRequested"]],
    "productionEpValues" -> (ToExpression /@ productionPlan["points"]),
    "validationEpValues" -> (ToExpression /@ productionPlan["validationPoints"]),
    "laurentSupportCertificate" -> supportCertificate,
    "productionHistory" -> productionHistory,
    "productionPlan" -> productionPlan,
    "validation" -> Lookup[fit["diagnostics"], "validation_samples"],
    "maximumValidationRelativeResidual" ->
      Lookup[fit["diagnostics"], "maximum_validation_relative_residual"],
    "parallelTaskCountRequested" -> parallelCount,
    "parallelTaskCountEffective" -> maximumEffectiveParallelCount,
    "pointEvaluations" -> Join[
      Lookup[productionEvaluationCache, productionStrings],
      Lookup[validationEvaluationCache, validationStrings]
    ],
    "runtimeDirectory" -> runtimeDirectory
  |>
];


MSReconstructEpSeries[___] := Failure[
  "InvalidEpSeriesArguments",
  <|"usage" ->
    "MSReconstructEpSeries[context, ep, pointTemplate, MaximumEpPower->0]"|>
];
