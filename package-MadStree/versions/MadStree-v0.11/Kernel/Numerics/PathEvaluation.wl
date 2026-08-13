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
      WorkingPrecision -> 50,
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
