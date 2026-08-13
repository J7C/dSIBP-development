(* ::Package:: *)

(***
文件：PathPlanning.wl
用途：实现两阶段多点路径工作流。MSGeneratePath 对用户点的连续复仿射组进行规划并返回计划；MSEvaluatePlannedPath 只执行已保存计划。
范围：裸坐标为保存点，{coordinate,"tmp"} 是临时途经点，{coordinate,"lo"} 请求奇点领头阶数据。SingularityMode 是唯一奇点策略，执行阶段绝不重新规划。
***)

(* ::Chapter:: *)
(* 用户点输入格式 *)

(* 用户点可为缺省保存的裸规则，或带 "tmp"/"lo" 标签的 {rules,tag}。
   其它字符串标签一律拒绝；"lo" 返回奇点轨迹点的领头阶记录而不是有限数值。 *)
msPathPointNormalize[entry_, userIndex_Integer] := Module[{rules, tag},
  Which[
    MatchQ[entry, {_, "tmp" | "lo"}],
      rules = msRuleList[First[entry]];
      tag = Last[entry],
    MatchQ[entry, {_, _String}],
      Return[Failure[
        "PathPointTag",
        <|"userIndex" -> userIndex, "entry" -> HoldForm[entry],
          "allowedTaggedForms" -> {"tmp", "lo"}|>
      ]],
    True,
      rules = msRuleList[entry];
      tag = "saved"
  ];
  If[rules === $Failed,
    Return[Failure[
      "PathPointRulesRequired",
      <|"userIndex" -> userIndex, "entry" -> HoldForm[entry]|>
    ]]
  ];
  <|"coordinate" -> rules, "tag" -> tag, "userIndex" -> userIndex|>
];


$msPlannedPathKeys = {
  "schema", "status", "masterDigest", "boundaryData", "singularBoundaryPlan", "userPoints",
  "removedPoints", "leadingOrderRequests", "reconnections", "pathChain",
  "segments", "singularSegments", "singularityMode", "messageLanguage",
  "workingPrecisionDigits", "minimumPolePathDistance", "backendPlanning",
  "messages", "planningOptions"
};


(* 计划对象必须逐字段符合当前 schema；缺字段和多余字段同样拒绝。 *)
MSPlannedPathQ[expression_] := AssociationQ[expression] &&
  Lookup[expression, "schema", None] === "madstree_planned_path_v3" &&
  Sort[Keys[expression]] === Sort[$msPlannedPathKeys];


msMessageLanguage[value_] := If[
  MemberQ[{"EN", "CN"}, value],
  value,
  Failure["MessageLanguage", <|"value" -> value, "allowed" -> {"EN", "CN"}|>]
];


msSingularityMode[value_] := If[
  MemberQ[{"Avoid", "SingularityJump"}, value],
  value,
  Failure[
    "SingularityMode",
    <|"value" -> value, "allowed" -> {"Avoid", "SingularityJump"}|>
  ]
];


msBackendSingularityMode["Avoid"] := "avoid";
msBackendSingularityMode["SingularityJump"] := "singularity_jump";


msUnknownOptionNames[rawOptions_List, allowedOptions_List] := Complement[
  First /@ rawOptions,
  First /@ allowedOptions
];

msLocalizedPathText[language_String, english_String, chinese_String] :=
  If[language === "CN", chinese, english];

(* Every point must determine all kinematic symbols numerically, otherwise the
   singular-locus test and the affine pullback are not exact decisions. *)
msPathPointCompletenessFailures[points_List, symbols_List] := Select[
  points,
  Function[point,
    AnyTrue[symbols, ! NumericQ[N[# /. point["coordinate"]]] &]
  ]
];


(* ::Chapter:: *)
(* Singular-locus point removal *)

(* A user point on the singular locus makes at least one dlog letter vanish;
   values diverge there, so such points are treated uniformly with the
   singularities and dropped from the user sequence for arbitrary consecutive
   runs. The report keeps the user indices and describes the reconnection. *)
msPathPointOnSingularLocusQ[rules_List, letters_List] := AnyTrue[
  letters,
  TrueQ[PossibleZeroQ[Simplify[# /. rules]]] &
];


msPathRemoveSingularLocusPoints[points_List, letters_List] := Module[
  {annotated, kept, removed, removedIndices, reconnections, runStart, index, before, after},
  annotated = Map[
    Append[#, "onSingularLocus" -> msPathPointOnSingularLocusQ[#"coordinate", letters]] &,
    points
  ];
  kept = Select[annotated, ! TrueQ[#onSingularLocus] &];
  removed = KeyDrop[#, "onSingularLocus"] & /@ Select[annotated, TrueQ[#onSingularLocus] &];
  If[kept === {}, Return[Failure[
    "AllUserPointsOnSingularLocus",
    <|"removedUserIndices" -> (#[["userIndex"]] & /@ removed)|>
  ]]];
  (* Reconnection: from the last computable point before each removed run
     (or the boundary anchor) directly to the first computable point after. *)
  removedIndices = #[["userIndex"]] & /@ removed;
  reconnections = {};
  runStart = None;
  Do[
    If[MemberQ[removedIndices, index],
      If[runStart === None, runStart = index],
      If[runStart =!= None,
        before = MaximalBy[Select[kept, #userIndex < runStart &], #userIndex &];
        after = MinimalBy[Select[kept, #userIndex > index - 1 &], #userIndex &];
        AppendTo[reconnections, <|
          "removedUserIndices" -> Select[removedIndices, runStart <= # <= index - 1 &],
          "reconnectFrom" -> If[before === {}, "boundaryAnchor", First[before]["userIndex"]],
          "reconnectTo" -> If[after === {}, Missing["NoComputablePointAfter"], First[after]["userIndex"]]
        |>];
        runStart = None
      ]
    ],
    {index, points[[All, "userIndex"]]}
  ];
  If[runStart =!= None,
    before = MaximalBy[Select[kept, #userIndex < runStart &], #userIndex &];
    AppendTo[reconnections, <|
      "removedUserIndices" -> Select[removedIndices, # >= runStart &],
      "reconnectFrom" -> If[before === {}, "boundaryAnchor", First[before]["userIndex"]],
      "reconnectTo" -> Missing["NoComputablePointAfter"]
    |>]
  ];
  <|
    "kept" -> (KeyDrop[#, "onSingularLocus"] & /@ kept),
    "removed" -> removed,
    "reconnections" -> reconnections
  |>
];


(* ::Chapter:: *)
(* Singular-point leading-order requests *)

(* Values diverge at a singular-locus point and exact evaluation stays refused;
   a {coordinate,"lo"} point instead requests its leading order: exponents and
   leading vectors resolved from the local Frobenius basis after transport
   along the arrival segment to the incoming match point. The planning-stage
   record is exact MadStree data: the coincident letters, the merged residue
   spectrum, and the direction annotations demanded by the save semantics. *)
msLeadingOrderPlanningData[
  de_Association,
  constantRules_List,
  loRules_List,
  workingPrecision_Integer
] := Module[{letters, matrices, coincident, residue, spectrum, pathDependentQ},
  letters = de["letters"];
  matrices = AssociationMap[Together[# /. constantRules] &, de["letterMatrices"]];
  coincident = Select[
    letters,
    TrueQ[PossibleZeroQ[Simplify[# /. loRules]]] &
  ];
  residue = Total[Lookup[matrices, #] & /@ coincident];
  spectrum = N[Eigensystem[residue], workingPrecision];
  pathDependentQ = ! TrueQ[And @@ Flatten[
    Map[
      Function[pair, PossibleZeroQ[Simplify[
        Lookup[matrices, pair[[1]]] . Lookup[matrices, pair[[2]]] -
          Lookup[matrices, pair[[2]]] . Lookup[matrices, pair[[1]]]
      ]]],
      Subsets[coincident, {2}]
    ]
  ]];
  <|
    "coincidentLetters" -> (ToString[#, InputForm] & /@ coincident),
    "exponents" -> First[spectrum],
    "leadingVectors" -> Last[spectrum],
    "multipleLettersQ" -> Length[coincident] > 1,
    "pathDependentQ" -> pathDependentQ
  |>
];


(* Builds one leading-order request at planning time: arrival direction (the
   last computable chain point before the request), the arrival-segment pole
   scan (no other pole may lie strictly inside), and the exact local spectral
   data. The request stays a plan-time object; the numeric resolution happens
   at execution. *)
msBuildLeadingOrderRequests[
  de_Association,
  chain_List,
  loPoints_List,
  workingPrecision_Integer
] := Module[{requests = {}, lo, constantRules, planningData, before, affine, poles, interior},
  Do[
    lo = loPoint;
    constantRules = Select[lo["coordinate"], FreeQ[de["kinematicSymbols"], First[#]] &];
    planningData = msLeadingOrderPlanningData[de, constantRules, lo["coordinate"], workingPrecision];
    (* The arrival anchor is the last computable chain point (boundary anchor or
       kept user point) preceding the request; other leading-order requests
       are not computable and never serve as anchors. *)
    before = MaximalBy[Select[chain, #["userIndex"] < lo["userIndex"] &], #userIndex &];
    If[before === {},
      Return[Failure[
        "LeadingOrderArrivalAnchorMissing",
        <|
          "userIndex" -> lo["userIndex"],
          "coordinate" -> lo["coordinate"],
          "reason" -> "no computable chain point precedes this leading-order request"
        |>
      ]]
    ];
    affine = msPlanPathSegment[de, First[before]["coordinate"], lo["coordinate"]];
    If[Head[affine] === Failure, Return[affine]];
    poles = affine["poles"];
    interior = Select[poles, TrueQ[#onSegment] &];
    If[interior =!= {},
      Return[Failure[
        "LeadingOrderArrivalSegmentCrossesPole",
        <|
          "userIndex" -> lo["userIndex"],
          "coordinate" -> lo["coordinate"],
          "interiorPoles" -> interior
        |>
      ]]
    ];
    (* The coincident letters must vanish exactly at the arrival endpoint:
       their pullback pole parameter must be 1, otherwise the requested point
       is not the pole the arrival segment reaches. *)
    If[! And @@ Map[
      Function[letter,
        AnyTrue[
          Select[poles, #["letter"] === letter &],
          PossibleZeroQ[Simplify[ToExpression[#["poleParameter"]] - 1]] &
        ]
      ],
      planningData["coincidentLetters"]
    ],
      Return[Failure[
        "LeadingOrderArrivalEndpointMismatch",
        <|
          "userIndex" -> lo["userIndex"],
          "coordinate" -> lo["coordinate"],
          "reason" -> "a coincident letter does not reach its pole at the arrival endpoint"
        |>
      ]]
    ];
    AppendTo[requests, Join[
      <|
        "userIndex" -> lo["userIndex"],
        "coordinate" -> lo["coordinate"],
        "arrival" -> <|
          "fromUserIndex" -> First[before]["userIndex"],
          "fromCoordinate" -> First[before]["coordinate"]
        |>,
        "note" -> If[TrueQ[planningData["multipleLettersQ"]],
          "leading order along this arrival direction; several letters vanish together here, so no unique point leading order is claimed",
          "leading order along this arrival direction"
        ],
        "pathDependenceNote" -> If[TrueQ[planningData["pathDependentQ"]],
          "the coincident letter residue matrices do not commute; the leading order depends on the arrival path",
          Missing["NotApplicable"]
        ]
      |>,
      planningData,
      <|"arrivalLetters" -> affine["letters"]|>
    ]],
    {loPoint, loPoints}
  ];
  requests
];


(* ::Chapter:: *)
(* Segment pole scan and distance *)

(* Distance of a pullback pole parameter to the real segment [0,1]; this is the
   geometric quantity controlling the FlintNDE planner threshold along the
   segment, reported exactly and displayed numerically. *)
msPullbackPoleDistance[poleParameter_] := Module[{clamped},
  clamped = Max[0, Min[1, Re[poleParameter]]];
  Sqrt[(Re[poleParameter] - clamped)^2 + Im[poleParameter]^2]
];


msSegmentPoleScan[
  de_Association,
  pathRules_List,
  constantRules_List,
  parameter_Symbol
] := Module[{results = {}, along, alpha, beta, poleParameter, onSegment},
  Do[
    along = Simplify[letter /. pathRules /. constantRules];
    If[! PolynomialQ[along, parameter] || Exponent[along, parameter] > 1,
      Return[Failure[
        "FlintNDEExactPathRequired",
        <|"reason" -> "dlog letter is not affine with Q(i) data along the segment",
          "letter" -> letter|>
      ]]
    ];
    alpha = Together[along /. parameter -> 0];
    beta = Together[Coefficient[along, parameter, 1]];
    Which[
      beta === 0 && alpha === 0,
        Return[Failure[
          "SegmentOnSingularHyperplane",
          <|"letter" -> letter, "reason" -> "the whole segment lies on the letter hyperplane"|>
        ]],
      beta === 0,
        Null,
      True,
        poleParameter = Together[-alpha/beta];
        (* Exact test: only real parameters strictly inside (0,1) lie on the
           segment; complex comparisons stay unevaluated and give False. Quiet
           suppresses the nord messages from the complex comparisons. *)
        onSegment = Quiet[TrueQ[0 < poleParameter < 1], Less::nord];
        AppendTo[results, <|
          "letter" -> ToString[letter, InputForm],
          "poleParameter" -> ToString[poleParameter, InputForm],
          "onSegment" -> onSegment,
          "polePathDistance" -> msPullbackPoleDistance[poleParameter]
        |>]
    ],
    {letter, de["letters"]}
  ];
  results
];


(* 为 LO 到达路径等单目标请求构造独立计划段；普通多点输运使用下方的
   msPlanPathGroup。 *)
msPlanPathSegment[de_Association, fromRules_List, toRules_List] := Module[
  {parameter, affine, poles},
  parameter = Unique["msSegmentParameter"];
  affine = msAffineLetterData[de, fromRules, toRules, parameter];
  If[Head[affine] === Failure, Return[affine]];
  poles = msSegmentPoleScan[de, affine["pathRules"], affine["constantRules"], parameter];
  If[Head[poles] === Failure, Return[poles]];
  <|
    "letters" -> affine["letterRecords"],
    "poles" -> poles,
    "startRules" -> fromRules,
    "targetRules" -> toRules
  |>
];


(* ::Chapter:: *)
(* 连续复仿射单变量分组 *)

(* 坐标差向量按 exact 复数处理。两个差向量复线性相关即属于同一个
   x(s)=x0+s v 平面；比例允许为任意复数，不能退化为实共线判定。 *)
msPathCoordinateDifference[fromRules_List, toRules_List, symbols_List] :=
  Together[(msRuleValue[#, toRules] - msRuleValue[#, fromRules]) & /@ symbols];

msPathExactZeroQ[value_] := TrueQ[Together[RootReduce[value]] === 0];

msPathZeroDifferenceQ[difference_List] :=
  And @@ (msPathExactZeroQ /@ difference);

msPathComplexDirectionParameter[direction_List, difference_List] := Module[
  {pivot, parameter},
  pivot = FirstPosition[
    msPathExactZeroQ /@ direction,
    False,
    Missing["Absent"]
  ];
  If[pivot === Missing["Absent"],
    Return[Failure["ZeroAffineDirection", <||>]]
  ];
  parameter = Together[difference[[First[pivot]]]/direction[[First[pivot]]]];
  If[
    And @@ (
      msPathExactZeroQ /@
        (Together /@ (difference - parameter direction))
    ),
    parameter,
    Failure["DifferentComplexAffinePlane", <||>]
  ]
];


(* 按输入顺序划分最大连续复仿射组。转角前的最后一点同时作为下一组
   anchor；公共用户点也作为下一组 s=0 点，保证组间只继承数值向量而不共享局部级数。 *)
msPathAffineGroups[chain_List, symbols_List] := Module[
  {groups = {}, start = 1, direction = None, position, difference, parameter},
  Do[
    difference = msPathCoordinateDifference[
      chain[[start, "coordinate"]],
      chain[[position, "coordinate"]],
      symbols
    ];
    If[direction === None,
      If[! msPathZeroDifferenceQ[difference], direction = difference];
      Continue[]
    ];
    parameter = msPathComplexDirectionParameter[direction, difference];
    If[Head[parameter] === Failure,
      AppendTo[groups, <|
        "anchor" -> chain[[start]],
        "points" -> chain[[
          If[chain[[start, "userIndex"]] === 0, start + 1, start] ;;
            position - 1
        ]]
      |>];
      start = position - 1;
      direction = msPathCoordinateDifference[
        chain[[start, "coordinate"]],
        chain[[position, "coordinate"]],
        symbols
      ];
      If[msPathZeroDifferenceQ[direction], direction = None]
    ],
    {position, 2, Length[chain]}
  ];
  AppendTo[groups, <|
    "anchor" -> chain[[start]],
    "points" -> chain[[
      If[chain[[start, "userIndex"]] === 0, start + 1, start] ;;
        Length[chain]
    ]]
  |>];
  groups
];


msComplexSegmentDistance[point_, start_, target_] := Module[
  {direction, normSquared, projection},
  direction = target - start;
  normSquared = ComplexExpand[Re[direction Conjugate[direction]]];
  If[TrueQ[PossibleZeroQ[normSquared]], Return[Abs[point - start]]];
  projection = Together[
    ComplexExpand[Re[(point - start) Conjugate[direction]]]/normSquared
  ];
  projection = Max[0, Min[1, projection]];
  Abs[point - (start + projection direction)]
];


(* 对组内相邻用户点形成的复参数折线逐边扫描极点；onSegment 仍表示
   极点位于某一条实际直线边上，而 dense output 可在同一收敛圆盘内离边求值。 *)
msGroupPoleScan[
  de_Association,
  pathRules_List,
  constantRules_List,
  parameter_Symbol,
  pointParameters_List,
  fromUserIndex_Integer,
  userIndices_List
] := Module[
  {results = {}, along, alpha, beta, poleParameter, edge, edgeStart, edgeTarget,
   edgeDirection, edgeRatio, onSegment, edgeFromIndex},
  Do[
    along = Simplify[letter /. pathRules /. constantRules];
    If[! PolynomialQ[along, parameter] || Exponent[along, parameter] > 1,
      Return[Failure[
        "FlintNDEExactPathRequired",
        <|"reason" -> "dlog letter is not affine with Q(i) data along the group",
          "letter" -> letter|>
      ]]
    ];
    alpha = Together[along /. parameter -> 0];
    beta = Together[Coefficient[along, parameter, 1]];
    Which[
      beta === 0 && alpha === 0,
        Return[Failure[
          "SegmentOnSingularHyperplane",
          <|"letter" -> letter,
            "reason" -> "the whole affine group lies on the letter hyperplane"|>
        ]],
      beta === 0,
        Null,
      True,
        poleParameter = Together[-alpha/beta];
        Do[
          edgeStart = If[edge === 1, 0, pointParameters[[edge - 1]]];
          edgeTarget = pointParameters[[edge]];
          edgeDirection = Together[edgeTarget - edgeStart];
          edgeRatio = If[
            TrueQ[PossibleZeroQ[edgeDirection]],
            Missing["ZeroLengthEdge"],
            Together[(poleParameter - edgeStart)/edgeDirection]
          ];
          onSegment = Head[edgeRatio] =!= Missing &&
            TrueQ[PossibleZeroQ[Im[ComplexExpand[edgeRatio]]]] &&
            Quiet[TrueQ[0 < Re[ComplexExpand[edgeRatio]] < 1], Less::nord];
          edgeFromIndex = If[edge === 1, fromUserIndex, userIndices[[edge - 1]]];
          AppendTo[results, <|
            "letter" -> ToString[letter, InputForm],
            "poleParameter" -> ToString[poleParameter, InputForm],
            "onSegment" -> onSegment,
            "polePathDistance" ->
              msComplexSegmentDistance[poleParameter, edgeStart, edgeTarget],
            "fromUserIndex" -> edgeFromIndex,
            "toUserIndex" -> userIndices[[edge]]
          |>],
          {edge, Length[pointParameters]}
        ]
    ],
    {letter, de["letters"]}
  ];
  results
];


(* 每组只拉回一次 DE。首个非重合用户点定义方向并取参数 1；其余点
   用 exact 复比例参数化。全重合组使用非零虚拟参数保持可执行零连接。 *)
msPlanPathGroup[de_Association, group_Association] := Module[
  {parameter, anchor, points, differences, directionPosition, direction,
   directionTarget, affine, pointParameters, parameterFailure, poles, records},
  parameter = Unique["msGroupParameter"];
  anchor = group["anchor"];
  points = group["points"];
  differences = msPathCoordinateDifference[
    anchor["coordinate"], #["coordinate"], de["kinematicSymbols"]
  ] & /@ points;
  directionPosition = FirstPosition[
    differences,
    difference_ /; ! msPathZeroDifferenceQ[difference],
    Missing["Absent"]
  ];
  If[directionPosition === Missing["Absent"],
    directionTarget = First[points]["coordinate"];
    pointParameters = Range[Length[points]],
    direction = differences[[First[directionPosition]]];
    directionTarget = points[[First[directionPosition], "coordinate"]];
    pointParameters = Map[
      If[
        msPathZeroDifferenceQ[#],
        0,
        msPathComplexDirectionParameter[direction, #]
      ] &,
      differences
    ];
    parameterFailure = FirstCase[pointParameters, _Failure, None];
    If[parameterFailure =!= None, Return[parameterFailure]]
  ];
  affine = msAffineLetterData[
    de, anchor["coordinate"], directionTarget, parameter
  ];
  If[Head[affine] === Failure, Return[affine]];
  records = msGaussianRationalString /@ pointParameters;
  If[MemberQ[records, $Failed],
    Return[Failure[
      "FlintNDEExactPathRequired",
      <|"reason" -> "group parameters are not exact Gaussian rationals"|>
    ]]
  ];
  poles = msGroupPoleScan[
    de, affine["pathRules"], affine["constantRules"], parameter,
    pointParameters, anchor["userIndex"], points[[All, "userIndex"]]
  ];
  If[Head[poles] === Failure, Return[poles]];
  <|
    "letters" -> affine["letterRecords"],
    "poles" -> poles,
    "startRules" -> anchor["coordinate"],
    "targetRules" -> Last[points]["coordinate"],
    "pointParameters" -> records,
    "fromUserIndex" -> anchor["userIndex"],
    "toUserIndex" -> Last[points]["userIndex"],
    "userIndices" -> points[[All, "userIndex"]]
  |>
];


(* 在第一阶段为每个 LO 请求生成到入射匹配点的完整计划。返回记录只保留
   后续执行和审计需要的字段，不把临时进程路径写入计划变量。 *)
msAttachLeadingOrderPlans[
  requests_List,
  de_Association,
  configuration_Association,
  pythonExecutable_,
  runtimeDirectory_String,
  digits_Integer,
  messageLanguage_String
] := Module[{results = {}, inputData, imported},
  Do[
    inputData = <|
      "schema" -> "madstree_flintnde_leading_order_plan_v1",
      "backendPackagePath" -> configuration["resolvedPath"],
      "masterDigest" -> de["masterDigest"],
      "dimension" -> de["masterCount"],
      "letters" -> request["arrivalLetters"],
      "start" -> "0",
      "pole" -> "1",
      "workingPrecisionDigits" -> digits,
      "messageLanguage" -> messageLanguage
    |>;
    imported = msExecuteFlintNDEAdapter[
      inputData, pythonExecutable, runtimeDirectory
    ];
    If[Head[imported] === Failure, Return[imported]];
    If[Lookup[imported, "status", None] =!= "success",
      Return[Failure[
        "LeadingOrderPlanningFailed",
        <|"userIndex" -> request["userIndex"], "backend" -> imported|>
      ]]
    ];
    AppendTo[
      results,
      Append[
        request,
        "flintNDEPlan" -> KeyTake[
          imported,
          {
            "schema", "planningAction", "workingPrecisionDigits", "pole",
            "poleParameter", "incomingMatch", "matchDistance",
            "serializedPlan", "planReport"
          }
        ]
      ]
    ],
    {request, requests}
  ];
  results
];


(* ::Chapter:: *)
(* Public path planner (two-phase workflow, phase one) *)

Options[MSGeneratePath] = DeleteDuplicatesBy[
  Join[
    {
      SingularityMode -> "Avoid",
      MessageLanguage -> "EN",
      PythonExecutable -> Automatic,
      MSRuntimeDirectory -> Automatic
    },
    Options[MSBoundaryData]
  ],
  First
];

MSGeneratePath[
  context_?MSContextQ,
  pointSequence_List,
  opts : OptionsPattern[]
] := Module[
  {de, points, normalizationFailure, completenessFailures, letters, removal,
   keptPoints, removedPoints, reconnections, firstRules, boundary, anchorRules,
   chain, affineGroups, segments, segmentFailure, singularSegments, pairs, messages,
    distances, minimumDistance, singularityMode, workingPrecision, unknownOptions,
   requiredSymbols, segmentIndex, path, notice, messageLanguage,
   leadingOrderPoints, offLocusLeadingOrder, leadingOrderRequests,
   configuration, runtimeDirectory, pythonExecutable, singularBoundaryPlan, segmentInputs,
   planningInput, planningImported, plannedSegments},
  de = MSDLogDE[context];
  If[Lookup[de, "dlogStatus", None] =!= "certifiedByFormulaChecks",
    Return[Failure["CertifiedDLogRequired", <||>]]
  ];
  If[pointSequence === {},
    Return[Failure["PathPointSequenceEmpty", <||>]]
  ];
  unknownOptions = msUnknownOptionNames[{opts}, Options[MSGeneratePath]];
  If[unknownOptions =!= {},
    Return[Failure[
      "UnknownOption",
      <|"function" -> "MSGeneratePath", "options" -> unknownOptions|>
    ]]
  ];
  messageLanguage = msMessageLanguage[OptionValue[MessageLanguage]];
  If[Head[messageLanguage] === Failure, Return[messageLanguage]];
  singularityMode = msSingularityMode[OptionValue[SingularityMode]];
  If[Head[singularityMode] === Failure, Return[singularityMode]];
  workingPrecision = OptionValue[WorkingPrecision];
  messages = {};
  points = MapIndexed[msPathPointNormalize[#1, First[#2]] &, pointSequence];
  normalizationFailure = FirstCase[points, _Failure, None];
  If[normalizationFailure =!= None, Return[normalizationFailure]];
  (* 完整性同时覆盖 DE 变量和边界变量，使路径阶段在调用后端前结构化失败。 *)
  requiredSymbols = DeleteDuplicates@Join[
    de["kinematicSymbols"], msBoundaryRequiredSymbols[context]
  ];
  completenessFailures = msPathPointCompletenessFailures[points, requiredSymbols];
  If[completenessFailures =!= {},
    Return[Failure[
      "IncompletePathPoint",
      <|"points" -> (#[["userIndex"]] & /@ completenessFailures),
        "symbols" -> requiredSymbols|>
    ]]
  ];
  letters = de["letters"];
  removal = msPathRemoveSingularLocusPoints[points, letters];
  If[Head[removal] === Failure, Return[removal]];
  keptPoints = removal["kept"];
  removedPoints = removal["removed"];
  reconnections = removal["reconnections"];
  offLocusLeadingOrder = Select[
    points,
    #["tag"] === "lo" &&
      ! msPathPointOnSingularLocusQ[#["coordinate"], letters] &
  ];
  If[offLocusLeadingOrder =!= {},
    Return[Failure[
      "LeadingOrderRequestOffSingularLocus",
      <|
        "userIndices" -> (#[["userIndex"]] & /@ offLocusLeadingOrder),
        "reason" -> "a leading-order request must lie on the singular locus; use a bare point for ordinary values"
      |>
    ]]
  ];
  leadingOrderPoints = Select[removedPoints, #["tag"] === "lo" &];
  removedPoints = Select[removedPoints, #["tag"] =!= "lo" &];
  If[removedPoints =!= {},
    notice = msLocalizedPathText[
      messageLanguage,
      "User points " <>
        ToString[#[["userIndex"]] & /@ removedPoints, InputForm] <>
        " lie on the singular locus and were removed; the remaining points were reconnected.",
      "用户点 " <> ToString[#[["userIndex"]] & /@ removedPoints, InputForm] <>
        " 位于奇异轨迹上，已移除并重连其余路径点。"
    ];
    Print[notice];
    AppendTo[messages, notice]
  ];
  firstRules = First[keptPoints]["coordinate"];
  boundary = MSBoundaryData[
    context, firstRules,
    Sequence @@ FilterRules[{opts}, Options[MSBoundaryData]]
  ];
  If[Head[boundary] === Failure, Return[boundary]];
  anchorRules = boundary["anchorRules"];
  chain = Prepend[
    keptPoints,
    <|"coordinate" -> anchorRules, "tag" -> "boundaryAnchor", "userIndex" -> 0|>
  ];
  leadingOrderRequests = If[
    leadingOrderPoints === {},
    {},
    msBuildLeadingOrderRequests[
      de, chain, leadingOrderPoints, workingPrecision
    ]
  ];
  If[Head[leadingOrderRequests] === Failure, Return[leadingOrderRequests]];
  affineGroups = msPathAffineGroups[chain, de["kinematicSymbols"]];
  segments = {};
  Do[
    segmentFailure = msPlanPathGroup[de, affineGroups[[segmentIndex]]];
    If[Head[segmentFailure] === Failure, Return[segmentFailure]];
    AppendTo[
      segments,
      Append[segmentFailure, "segmentIndex" -> segmentIndex]
    ],
    {segmentIndex, Length[affineGroups]}
  ];
  singularSegments = Select[
    segments,
    AnyTrue[#poles, TrueQ[#onSegment] &] &
  ];
  If[singularityMode === "Avoid" && singularSegments =!= {},
    pairs = DeleteDuplicates[
      Flatten[
        Map[
          Function[segment,
            Map[
              Function[pole,
                {
                  First[
                    Select[
                      chain,
                      #[["userIndex"]] === pole["fromUserIndex"] &
                    ]
                  ][["coordinate"]],
                  First[
                    Select[
                      chain,
                      #[["userIndex"]] === pole["toUserIndex"] &
                    ]
                  ][["coordinate"]]
                }
              ],
              Select[segment["poles"], TrueQ[#onSegment] &]
            ]
          ],
          singularSegments
        ],
        1
      ]
    ];
    notice = msLocalizedPathText[
      messageLanguage,
      "Avoid-singularity mode (default) refuses this polyline because a singularity lies on an adjacent user-point segment. Reroute the points, or set SingularityMode -> \"SingularityJump\"; a singularity jump selects a multivalued branch equivalent to a detour and must be checked by the user. Offending pairs: " <>
        ToString[pairs, InputForm],
      "缺省避开奇点模式拒绝该折线，因为相邻用户点连线经过奇点。请改选绕行点；也可设置 SingularityMode -> \"SingularityJump\" 显式启用奇点折跃，但奇点折跃选择的多值分支等价于某条绕行路径，必须由用户自行确认。问题点对：" <>
        ToString[pairs, InputForm]
    ];
    Print[notice];
    Return[Failure[
      "SingularPathOnUserPolyline",
      <|
        "message" -> notice,
        "messageLanguage" -> messageLanguage,
        "Singular Path Pair" -> pairs
      |>
    ]]
  ];
  distances = Flatten@Map[
    #[["poles", All, "polePathDistance"]] &,
    segments
  ];
  minimumDistance = If[
    distances === {},
    Missing["NoPoles"],
    Min[distances]
  ];
  If[singularSegments =!= {},
    notice = msLocalizedPathText[
      messageLanguage,
      "Singularities on segments " <>
        ToString[#[["segmentIndex"]] & /@ singularSegments, InputForm] <>
        " will use the stored singularity-jump geometry.",
      "线段 " <>
        ToString[#[["segmentIndex"]] & /@ singularSegments, InputForm] <>
        " 上的奇点将使用已保存的奇点折跃几何。"
    ];
    AppendTo[messages, notice]
  ];
  If[
    Head[minimumDistance] =!= Missing &&
      TrueQ[N[minimumDistance, workingPrecision] < 1/100],
    notice = msLocalizedPathText[
      messageLanguage,
      "The minimum pole-to-path distance is " <>
        ToString[N[minimumDistance, workingPrecision], InputForm] <>
        "; a very small distance can substantially increase the node count.",
      "奇点到路径的最小距离为 " <>
        ToString[N[minimumDistance, workingPrecision], InputForm] <>
        "；距离过小会显著增加节点数。"
    ];
    Print[notice];
    AppendTo[messages, notice]
  ];

  configuration = MSFlintNDEConfiguration[];
  If[! TrueQ[configuration["availableQ"]],
    Return[Failure["FlintNDENotAvailable", configuration]]
  ];
  runtimeDirectory = msResolveRuntimeDirectory[
    OptionValue[MSRuntimeDirectory]
  ];
  If[Head[runtimeDirectory] === Failure, Return[runtimeDirectory]];
  If[msEnsureDirectory[runtimeDirectory] === $Failed,
    Return[Failure[
      "RuntimeDirectoryCreationFailed",
      <|"path" -> runtimeDirectory|>
    ]]
  ];
  pythonExecutable = msResolvePythonExecutable[
    OptionValue[PythonExecutable]
  ];
  singularBoundaryPlan = If[
    Lookup[boundary, "boundaryKind", "finiteFrobeniusSeries"] === "singularFrobenius",
    msPlanSingularBoundary[
      de, boundary, workingPrecision, configuration, pythonExecutable,
      runtimeDirectory, messageLanguage
    ],
    Missing["NotRequired"]
  ];
  If[Head[singularBoundaryPlan] === Failure, Return[singularBoundaryPlan]];
  segmentInputs = Map[
    <|
      "start" -> "0",
      "points" -> #["pointParameters"],
      "letters" -> #["letters"],
      "fromUserIndex" -> #["fromUserIndex"],
      "userIndices" -> #["userIndices"]
    |> &,
    segments
  ];
  planningInput = <|
    "schema" -> "madstree_flintnde_polyline_plan_v2",
    "backendPackagePath" -> configuration["resolvedPath"],
    "masterDigest" -> de["masterDigest"],
    "dimension" -> de["masterCount"],
    "segments" -> segmentInputs,
    "singularityMode" -> msBackendSingularityMode[singularityMode],
    "workingPrecisionDigits" -> workingPrecision,
    "messageLanguage" -> messageLanguage
  |>;
  planningImported = msExecuteFlintNDEAdapter[
    planningInput, pythonExecutable, runtimeDirectory
  ];
  If[Head[planningImported] === Failure, Return[planningImported]];
  If[Lookup[planningImported, "status", None] === "singularPathRefused",
    Return[Failure[
      "SingularPathOnUserPolyline",
      <|
        "message" -> Lookup[
          planningImported,
          "message",
          "FlintNDE refused the planned polyline."
        ],
        "messageLanguage" -> messageLanguage,
        "segmentIndex" -> planningImported["segmentIndex"],
        "Singular Path Pair" -> planningImported["singularPathPairs"]
      |>
    ]]
  ];
  If[Lookup[planningImported, "status", None] =!= "success",
    Return[Failure[
      "FlintNDEPathPlanningFailed",
      <|"backend" -> planningImported|>
    ]]
  ];
  plannedSegments = Lookup[planningImported, "segments", {}];
  If[Length[plannedSegments] =!= Length[segments],
    Return[Failure[
      "FlintNDEPathPlanCount",
      <|
        "expected" -> Length[segments],
        "actual" -> Length[plannedSegments]
      |>
    ]]
  ];
  segments = MapThread[
    Append[
      #1,
      "flintNDEPlan" -> KeyTake[
        #2,
        {
          "segmentIndex", "serializedPlan", "pointAssignments",
          "planReport", "jumpSpecs"
        }
      ]
    ] &,
    {segments, plannedSegments}
  ];
  leadingOrderRequests = msAttachLeadingOrderPlans[
    leadingOrderRequests,
    de,
    configuration,
    pythonExecutable,
    runtimeDirectory,
    workingPrecision,
    messageLanguage
  ];
  If[Head[leadingOrderRequests] === Failure, Return[leadingOrderRequests]];

  notice = Lookup[
    planningImported,
    "message",
    msLocalizedPathText[
      messageLanguage,
      "MadStree planned the supplied points; pass the returned plan to MSEvaluatePlannedPath.",
      "MadStree 已完成输入点规划；请把返回计划交给 MSEvaluatePlannedPath 执行。"
    ]
  ];
  Print[notice];
  AppendTo[messages, notice];
  path = <|
    "schema" -> "madstree_planned_path_v3",
    "status" -> "planned",
    "masterDigest" -> de["masterDigest"],
    "boundaryData" -> boundary,
    "singularBoundaryPlan" -> singularBoundaryPlan,
    "userPoints" -> points,
    "removedPoints" -> removedPoints,
    "leadingOrderRequests" -> leadingOrderRequests,
    "reconnections" -> reconnections,
    "pathChain" -> chain,
    "segments" -> segments,
    "singularSegments" ->
      (#[["segmentIndex"]] & /@ singularSegments),
    "singularityMode" -> singularityMode,
    "messageLanguage" -> messageLanguage,
    "workingPrecisionDigits" -> workingPrecision,
    "minimumPolePathDistance" -> If[
      Head[minimumDistance] === Missing,
      Missing["NoPoles"],
      N[minimumDistance, workingPrecision]
    ],
    "backendPlanning" -> KeyTake[
      planningImported,
      {
        "schema", "planningAction", "backendPackagePath",
        "workingPrecisionDigits", "singularityMode",
        "messageLanguage", "message", "segmentCount"
      }
    ],
    "messages" -> messages,
    "planningOptions" -> <|
      SingularityMode -> singularityMode,
      MessageLanguage -> messageLanguage,
      "BoundaryScale" -> OptionValue[BoundaryScale],
      "BoundarySeriesOrder" -> OptionValue[BoundarySeriesOrder],
      "RankOrder" -> OptionValue[RankOrder]
    |>
  |>;
  path
];

MSGeneratePath[___] := Failure[
  "InitializedContextRequired",
  <|"function" -> "MSGeneratePath"|>
];

(* ::Chapter:: *)
(* Planned path execution (two-phase workflow, phase two) *)

(* Point results pair every coordinate with its value and status, so the user
   never has to align indices by hand (coordinate + value + status + user
   index contract). Transient waypoints keep their transported value but stay
   tagged as not saved; removed points appear with no value; leading-order
   requests carry their LO record instead of a value (values diverge at the
   singular locus and exact evaluation stays refused). *)
msPolylinePointResults[path_Association, imported_Association, leadingOrderResults_List] := Module[
  {kept, removed, pointValues, valueLookup, results, loLookup},
  kept = Select[path["pathChain"], #tag =!= "boundaryAnchor" &];
  removed = path["removedPoints"];
  pointValues = Flatten[
    Lookup[#, "pointValues", {}] & /@ Lookup[imported, "segments", {}]
  ];
  valueLookup = Association[
    #[["userIndex"]] -> msParseFlintVector[#["values"]] & /@ pointValues
  ];
  results = Map[
    Function[point,
      <|
        "coordinate" -> point["coordinate"],
        "userIndex" -> point["userIndex"],
        "status" -> If[point["tag"] === "saved", "saved", "transient"],
        "value" -> Lookup[
          valueLookup,
          point["userIndex"],
          Missing["PlannedPointValueAbsent"]
        ]
      |>
    ],
    kept
  ];
  loLookup = Association[#[["userIndex"]] -> # & /@ leadingOrderResults];
  SortBy[
    Join[
      results,
      <|"coordinate" -> #["coordinate"], "userIndex" -> #["userIndex"],
        "status" -> "removedSingularLocus", "value" -> Missing["SingularLocus"]|> & /@ removed,
      Join[#[["record"]], <|"value" -> Missing["DivergentAtSingularLocus"]|>] & /@ Values[loLookup]
    ],
    #userIndex &
  ]
];


(* Backend distance reports are FLINT ball texts like "[0.123 +/- 1e-30]";
   strip the radius envelope before converting, plain decimals pass through. *)
msReportDecimal[text_String] := Module[{stripped},
  stripped = StringCases[text, "[" ~~ x : NumberString ~~ __ :> x, 1];
  ToExpression[If[stripped === {}, text, First[stripped]]]
];


(* Leading-order execution: for every request the value of the arrival chain
   node is transported along the arrival segment to the incoming match point
   (the transport stops before the pole, it never crosses it) and the local
   Frobenius basis of the pole resolves the constants. A structured backend
   refusal (resonance and friends) keeps the planning-stage direction record
   but carries no numbers; an adapter-level failure aborts the evaluation. *)
msExecuteLeadingOrderRequests[
  path_Association,
  imported_Association,
  de_Association,
  configuration_Association,
  initialVector_List,
  pythonExecutable_,
  runtimeDirectory_String,
  digits_Integer,
  transportOrder_Integer,
  referenceOrder_Integer,
  targetRelativeError_String,
  messageLanguage_String
] := Module[{
  pointValues, valueLookup, requests, fromUserIndex, fromValue,
  inputData, loImported, results = {}
},
  requests = Lookup[path, "leadingOrderRequests", {}];
  If[requests === {}, Return[{}]];
  pointValues = Flatten[
    Lookup[#, "pointValues", {}] & /@ Lookup[imported, "segments", {}]
  ];
  valueLookup = Association[
    #[["userIndex"]] -> msParseFlintVector[#["values"]] & /@ pointValues
  ];
  Do[
    fromUserIndex = Lookup[
      Lookup[request, "arrival", <||>], "fromUserIndex", Missing["Absent"]
    ];
    fromValue = If[
      fromUserIndex === 0,
      initialVector,
      Lookup[valueLookup, fromUserIndex, Missing["Absent"]]
    ];
    If[fromValue === Missing["Absent"],
      Return[Failure[
        "LeadingOrderArrivalValueMissing",
        <|"userIndex" -> request["userIndex"],
          "arrivalUserIndex" -> fromUserIndex|>
      ]]
    ];
    inputData = <|
      "schema" -> "madstree_flintnde_leading_order_execute_v1",
      "backendPackagePath" -> configuration["resolvedPath"],
      "masterDigest" -> de["masterDigest"],
      "dimension" -> de["masterCount"],
      "letters" -> request["arrivalLetters"],
      "plan" -> Lookup[
        Lookup[request, "flintNDEPlan", <||>],
        "serializedPlan",
        Missing["Absent"]
      ],
      "boundary" -> (msComplexDecimalRecord[#, digits] & /@ fromValue),
      "start" -> "0",
      "pole" -> "1",
      "workingPrecisionDigits" -> digits,
      "primaryOrder" -> transportOrder,
      "referenceOrder" -> referenceOrder,
      "targetRelativeError" -> targetRelativeError,
      "certificationMode" -> "embedded",
      "messageLanguage" -> messageLanguage,
      "columnVectorConvention" -> "Y'=A(s)Y",
      "dlogStatus" -> de["dlogStatus"]
    |>;
    loImported = msExecuteFlintNDEAdapter[inputData, pythonExecutable, runtimeDirectory];
    If[Head[loImported] === Failure, Return[loImported]];
    AppendTo[results, <|
      "userIndex" -> request["userIndex"],
      "record" -> Which[
        Lookup[loImported, "status", None] === "leadingOrderRefused",
          <|
            "coordinate" -> request["coordinate"],
            "userIndex" -> request["userIndex"],
            "status" -> "leadingOrderRefused",
            "reason" -> Lookup[loImported, "reason", Missing["Absent"]],
            "executionAction" -> Lookup[
              loImported, "executionAction", Missing["Absent"]
            ],
            "coincidentLetters" -> request["coincidentLetters"],
            "arrivalDirection" -> request["arrival"],
            "note" -> request["note"],
            "pathDependenceNote" -> request["pathDependenceNote"],
            "planningExponents" -> request["exponents"],
            "planningLeadingVectors" -> request["leadingVectors"]
          |>,
        Lookup[loImported, "status", None] === "success",
          <|
            "coordinate" -> request["coordinate"],
            "userIndex" -> request["userIndex"],
            "status" -> "leadingOrderSaved",
            "coincidentLetters" -> request["coincidentLetters"],
            "arrivalDirection" -> request["arrival"],
            "note" -> request["note"],
            "pathDependenceNote" -> request["pathDependenceNote"],
            "exponents" -> (msReportDecimal /@ loImported["exponents"]),
            "leadingVectors" -> (msParseFlintVector /@ loImported["leadingVectors"]),
            "constants" -> msParseFlintVector[loImported["constants"]],
            "executionAction" -> Lookup[
              loImported, "executionAction", Missing["Absent"]
            ],
            "branchRecord" -> <|
              "branchConvention" -> loImported["branchConvention"],
              "incomingWinding" -> loImported["incomingWinding"],
              "incomingResidual" -> loImported["incomingResidual"]
            |>,
            "incomingMatch" -> loImported["incomingMatch"],
            "matchDistance" -> msReportDecimal[loImported["matchDistance"]],
            "targetRelativeErrorMet" -> TrueQ[loImported["targetRelativeErrorMet"]],
            "planningExponents" -> request["exponents"],
            "planningLeadingVectors" -> request["leadingVectors"]
          |>,
        True,
          <|
            "coordinate" -> request["coordinate"],
            "userIndex" -> request["userIndex"],
            "status" -> "leadingOrderFailed",
            "backendReport" -> loImported
          |>
      ]
    |>],
    {request, requests}
  ];
  results
];


(* Singularity report: which segments carry poles on the path (with user
   indices), the singularity-jump geometry returned by the backend, and the minimum
   pole-to-path and pole-to-node distances. *)
msPolylineSingularityReport[path_Association, imported_Association] := Module[
  {polesOnPath, nodeDistances, minimumNodeDistance},
  polesOnPath = Flatten@Map[
    Function[segment,
      Map[
        Function[pole,
          <|
            "segmentIndex" -> segment["segmentIndex"],
            "fromUserIndex" -> pole["fromUserIndex"],
            "toUserIndex" -> pole["toUserIndex"],
            "letter" -> pole["letter"],
            "poleParameter" -> pole["poleParameter"]
          |>
        ],
        Select[segment["poles"], TrueQ[#onSegment] &]
      ]
    ],
    path["segments"]
  ];
  nodeDistances = DeleteCases[
    Lookup[Lookup[#, "planReport", <||>], "minimum_pole_node_distance", None] & /@
      imported["segments"],
    None
  ];
  minimumNodeDistance = If[nodeDistances === {},
    Missing["NoNodes"],
    N[Min[msReportDecimal /@ nodeDistances]]
  ];
  <|
    "polesOnPath" -> polesOnPath,
    "jumpDetails" -> Flatten@Map[
      Function[segment,
        Append[#, "segmentIndex" -> segment["segmentIndex"]] & /@
          Lookup[segment, "jumpSpecs", {}]
      ],
      imported["segments"]
    ],
    "minimumPolePathDistance" -> path["minimumPolePathDistance"],
    "minimumPoleNodeDistance" -> minimumNodeDistance
  |>
];


Options[MSEvaluatePlannedPath] = {
  PythonExecutable -> Automatic,
  MSRuntimeDirectory -> Automatic,
  MessageLanguage -> "EN",
  WorkingPrecision -> 50,
  TransportOrder -> 48,
  ReferenceTransportOrder -> 64,
  TargetRelativeError -> "1e-25"
};

MSEvaluatePlannedPath[
  context_?MSContextQ,
  path_?MSPlannedPathQ,
  opts : OptionsPattern[]
] := Module[
  {de, boundary, configuration, digits, planningDigits, messageLanguage, unknownOptions,
   runtimeDirectory, pythonExecutable, singularBoundaryExecution, singularBoundaryImported,
   initialVector, inputData, imported, segmentInputs, leadingOrderResults,
   pointResults, singularityReport, notice},
  unknownOptions = msUnknownOptionNames[{opts}, Options[MSEvaluatePlannedPath]];
  If[unknownOptions =!= {},
    Return[Failure[
      "UnknownOption",
      <|"function" -> "MSEvaluatePlannedPath", "options" -> unknownOptions|>
    ]]
  ];
  de = MSDLogDE[context];
  If[Lookup[de, "dlogStatus", None] =!= "certifiedByFormulaChecks",
    Return[Failure["CertifiedDLogRequired", <||>]]
  ];
  If[Lookup[path, "masterDigest", None] =!= de["masterDigest"],
    Return[Failure[
      "PlannedPathMasterMismatch",
      <|"expectedDigest" -> de["masterDigest"],
        "actualDigest" -> Lookup[path, "masterDigest", Missing["Absent"]]|>
    ]]
  ];
  boundary = path["boundaryData"];
  If[Lookup[boundary, "status", None] =!= "generated" ||
     Lookup[boundary, "masterDigest", None] =!= de["masterDigest"],
    Return[Failure["BoundaryMasterMismatch", <||>]]
  ];
  configuration = MSFlintNDEConfiguration[];
  If[! TrueQ[configuration["availableQ"]],
    Return[Failure["FlintNDENotAvailable", configuration]]
  ];
  digits = OptionValue[WorkingPrecision];
  messageLanguage = msMessageLanguage[OptionValue[MessageLanguage]];
  If[Head[messageLanguage] === Failure, Return[messageLanguage]];
  planningDigits = Lookup[path, "workingPrecisionDigits", Missing["Absent"]];
  If[! IntegerQ[planningDigits],
    Return[Failure[
      "PlannedPathPrecisionMissing",
      <|"requestedPrecisionDigits" -> digits,
        "reason" -> "the plan does not record its planning precision; replan"|>
    ]]
  ];
  If[TrueQ[digits > planningDigits],
    notice = msLocalizedPathText[
      messageLanguage,
      "Execution requests " <> ToString[digits] <>
        " decimal digits, but this path was planned at " <>
        ToString[planningDigits] <>
        ". Serialized nodes cannot gain precision; rerun MSGeneratePath at the requested precision.",
      "执行请求 " <> ToString[digits] <> " 位十进制精度，但该路径只按 " <>
        ToString[planningDigits] <>
        " 位规划。已序列化节点不能补回精度；请按所需精度重新运行 MSGeneratePath。"
    ];
    Print[notice];
    Return[Failure[
      "PlannedPathPrecisionInsufficient",
      <|
        "message" -> notice,
        "messageLanguage" -> messageLanguage,
        "planningPrecisionDigits" -> planningDigits,
        "requestedPrecisionDigits" -> digits
      |>
    ]]
  ];
  runtimeDirectory = msResolveRuntimeDirectory[OptionValue[MSRuntimeDirectory]];
  If[Head[runtimeDirectory] === Failure, Return[runtimeDirectory]];
  If[msEnsureDirectory[runtimeDirectory] === $Failed,
    Return[Failure["RuntimeDirectoryCreationFailed", <|"path" -> runtimeDirectory|>]]
  ];
  pythonExecutable = msResolvePythonExecutable[OptionValue[PythonExecutable]];
  singularBoundaryImported = Missing["NotUsed"];
  If[Lookup[boundary, "boundaryKind", "finiteFrobeniusSeries"] === "singularFrobenius",
    singularBoundaryExecution = msExecuteSingularBoundary[
      de, boundary, path["singularBoundaryPlan"], digits,
      OptionValue[TransportOrder], OptionValue[ReferenceTransportOrder],
      ToString[OptionValue[TargetRelativeError]],
      configuration, pythonExecutable, runtimeDirectory, messageLanguage
    ];
    If[Head[singularBoundaryExecution] === Failure, Return[singularBoundaryExecution]];
    singularBoundaryImported = singularBoundaryExecution["imported"];
    initialVector = singularBoundaryExecution["anchorValues"],
    If[! ListQ[Lookup[boundary, "values", None]] || Length[boundary["values"]] =!= de["masterCount"],
      Return[Failure["BoundaryVectorDimension", <|"expected" -> de["masterCount"]|>]]
    ];
    initialVector = boundary["values"]
  ];
  segmentInputs = Map[
    <|
      "start" -> "0",
      "points" -> #["pointParameters"],
      "letters" -> #["letters"],
      "plan" -> Lookup[
        Lookup[#, "flintNDEPlan", <||>],
        "serializedPlan",
        Missing["Absent"]
      ],
      "fromUserIndex" -> #["fromUserIndex"],
      "userIndices" -> #["userIndices"]
    |> &,
    path["segments"]
  ];
  If[AnyTrue[segmentInputs, ! AssociationQ[Lookup[#, "plan", None]] &],
    Return[Failure[
      "PlannedPathSegmentPlanMissing",
      <|"reason" -> "every segment must carry a serialized FlintNDE plan; replan"|>
    ]]
  ];
  inputData = <|
    "schema" -> "madstree_flintnde_polyline_execute_v2",
    "backendPackagePath" -> configuration["resolvedPath"],
    "masterDigest" -> de["masterDigest"],
    "dimension" -> de["masterCount"],
    "segments" -> segmentInputs,
    "singularityMode" -> msBackendSingularityMode[path["singularityMode"]],
    "boundary" -> (msComplexDecimalRecord[#, digits] & /@ initialVector),
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
  If[Lookup[imported, "status", None] =!= "success",
    Return[Failure[
      "FlintNDEPathExecutionFailed",
      <|"backend" -> imported|>
    ]]
  ];
  notice = Lookup[
    imported,
    "message",
    msLocalizedPathText[
      messageLanguage,
      "MadStree executed the stored FlintNDE plans directly; no path replanning was performed.",
      "MadStree 已直接执行保存的 FlintNDE 计划；未再次规划路径。"
    ]
  ];
  Print[notice];
  leadingOrderResults = msExecuteLeadingOrderRequests[
    path, imported, de, configuration, initialVector, pythonExecutable,
    runtimeDirectory, digits,
    OptionValue[TransportOrder], OptionValue[ReferenceTransportOrder],
    ToString[OptionValue[TargetRelativeError]], messageLanguage
  ];
  If[Head[leadingOrderResults] === Failure, Return[leadingOrderResults]];
  pointResults = msPolylinePointResults[path, imported, leadingOrderResults];
  singularityReport = msPolylineSingularityReport[path, imported];
  <|
    "status" -> "computed",
    "executionAction" -> Lookup[
      imported, "executionAction", Missing["Absent"]
    ],
    "masters" -> de["masters"],
    "masterDigest" -> de["masterDigest"],
    "values" -> msParseFlintVector[imported["finalValues"]],
    "pointResults" -> pointResults,
    "removedPoints" -> path["removedPoints"],
    "leadingOrderResults" -> (#[["record"]] & /@ leadingOrderResults),
    "singularPointReport" -> singularityReport,
    "boundary" -> boundary,
    "path" -> KeyDrop[path, "segments"],
    "flintNDE" -> If[
      Head[singularBoundaryImported] === Missing,
      imported,
      Join[
        imported,
        <|"singularBoundary" -> singularBoundaryImported|>
      ]
    ],
    "backendConfiguration" -> configuration,
    "runtimeDirectory" -> runtimeDirectory,
    "columnVectorConvention" -> "Y'=A(s)Y"
  |>
];

MSEvaluatePlannedPath[___] := Failure[
  "InitializedContextRequired", <|"function" -> "MSEvaluatePlannedPath"|>
];
