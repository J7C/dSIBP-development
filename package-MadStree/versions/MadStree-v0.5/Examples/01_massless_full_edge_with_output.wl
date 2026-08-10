(* ::Package:: *)

(***
文件：01_massless_full_edge_with_output.wl
用途：示例 01（含用户自定义边界与批量多点求值扩展，固定参数只写一次）的带输出副本；内容与更新后的原示例一致，仅把顶层结果包上 Print。
运行：wolframscript -file 01_massless_full_edge_with_output.wl，输出落盘新文件 01_massless_full_edge_output_v2.txt。
***)

(* ::Chapter:: *)
(*加载 MadStree*)

packageRoot = DirectoryName[DirectoryName[$InputFileName]];
AppendTo[$Path, FileNameJoin[{packageRoot, "Kernel"}]];
Needs["MadStree`"];

Print["== MadStree example 01: massless full edge (with custom boundary and batch) =="];


(* ::Chapter:: *)
(*定义有序树拓扑*)

treeSpec = <|
  "vertices" -> {
    <|"id" -> v1, "energy" -> k1, "timePower" -> a1|>,
    <|"id" -> v2, "energy" -> k2, "timePower" -> a2|>
  },
  "lines" -> {
    <|"id" -> e1, "type" -> "masslessFull", "endpoints" -> {v1, v2},
      "momentum" -> q, "skType" -> "++", "nu" -> 1/2|>
  }
|>;

context = MSInitTree[treeSpec];
topKey = First[context["sectorOrder"]];
Print["sectors = ", MSSectors[context]];


(* ::Chapter:: *)
(*直接公式结果*)

masters = MSMasterIntegrals[context];
topMatrices = MSFormulaMatrices[context, topKey];
contactMaps = MSContactMaps[context, topKey];
dlogDE = MSDLogDE[context];

Print["masters = ", Lookup[masters, "integral"]];

Print["omegaPotential = ", MatrixForm[dlogDE["omegaPotential"]]];


(* ::Chapter:: *)
(*迭代约化与自动数值边界*)

shiftedIntegral = MSIntegral[topKey, {1, 0}, {0}];
reduction = MSReduce[shiftedIntegral, context];
Print["reductionResult = ", reduction["result"]];

numericalTemplate = MSNumericalSystem[dlogDE];
Print["numericalStatus = ", numericalTemplate["status"]];

targetRules = {k1 -> -9 I, k2 -> -3 I, q -> 1, a1 -> 1, a2 -> 1};
boundary = MSBoundaryData[
  context,
  targetRules,
  BoundaryScale -> 4,
  WorkingPrecision -> 40
];

targetValue = MSEvaluateTree[
  context,
  targetRules,
  BoundaryScale -> 4,
  WorkingPrecision -> 40,
  TransportOrder -> 80,
  ReferenceTransportOrder -> 104,
  TargetRelativeError -> "1e-20"
];

Print["targetValues = ", targetValue["values"]];
Print["relativeDifferenceInf = ", targetValue["flintNDE", "relativeDifferenceInf"]];


(* ::Chapter:: *)
(*用户自定义边界：任选一个普通点作为锚点*)

userAnchorRules = {k1 -> -9 I, k2 -> -3 I, q -> 1, a1 -> 1, a2 -> 1};
userAnchorValue = MSEvaluateTree[
  context,
  userAnchorRules,
  BoundaryScale -> 4,
  WorkingPrecision -> 40,
  TransportOrder -> 80,
  ReferenceTransportOrder -> 104,
  TargetRelativeError -> "1e-20"
];
userAnchorValues = userAnchorValue["values"];
Print["userAnchorStatus = ", userAnchorValue["status"]];
Print["userAnchorValues = ", userAnchorValues];

(* 用锚点值构造有限边界；之后每个新点都从该锚点输运，不再经过无穷远边界。 *)
userFiniteBoundary[targetRules_] := <|
  "status" -> "generated",
  "method" -> "userChosenFiniteAnchor",
  "boundaryKind" -> "finiteFrobeniusSeries",
  "masterDigest" -> context["masterDigest"],
  "anchorRules" -> userAnchorRules,
  "targetRules" -> targetRules,
  "values" -> userAnchorValues
|>;

userTargetRules = {k1 -> -8 I, k2 -> -2 I, q -> 1, a1 -> 1, a2 -> 1};
userTargetValue = MSFlintNDETransport[
  context,
  userFiniteBoundary[userTargetRules],
  WorkingPrecision -> 40,
  TransportOrder -> 80,
  ReferenceTransportOrder -> 104,
  TargetRelativeError -> "1e-20"
];

Print["userTargetStatus = ", userTargetValue["status"]];
Print["userTargetValues = ", userTargetValue["values"]];
Print["userTargetRelativeDifferenceInf = ",
  userTargetValue["flintNDE", "relativeDifferenceInf"]];


(* ::Chapter:: *)
(*批量多点求值：固定参数只写一次，每个点只写变化量；自动边界只生成一次，逐点复用*)

(* 所有点共享的固定参数（动量、timePower、nu 等非能量量）*)
batchFixedRules = {q -> 1, a1 -> 1, a2 -> 1};

(* 数值元组表：每一行是一个点，按 batchPointSymbols 的顺序给出变化量的值 *)
batchPointSymbols = {k1, k2};
batchPointTable = {
  {-8 I, -2 I},
  {-7 I, -4 I},
  {-6 I, -5 I}
};

Options[batchEvaluateTree] = {PointSymbols -> Automatic};

batchEvaluateTree[
  context_?MSContextQ,
  fixedRules_List,
  pointSpecs_List,
  boundaryOptions_List,
  transportOptions_List,
  opts : OptionsPattern[]
] := Module[
  {symbols, rawPoints, mergePointRules, points, vertices, energySymbols,
   nonEnergyPart, firstPoint, boundary, results},
  symbols = OptionValue[PointSymbols];
  (* PointSymbols 给定时 pointSpecs 是数值元组表；缺省时 pointSpecs 是规则列表 *)
  rawPoints = If[symbols === Automatic,
    pointSpecs,
    Map[Thread[symbols -> #] &, pointSpecs]
  ];
  (* 每个点 = 固定规则 + 该点变化规则，点规则覆盖固定规则 *)
  mergePointRules[fixed_, point_] := Join[
    DeleteCases[fixed, Rule[left_, _] /; MemberQ[point[[All, 1]], left]],
    point
  ];
  points = Map[mergePointRules[fixedRules, #] &, rawPoints];
  vertices = context["vertices"];
  energySymbols = Lookup[vertices, "energy"];
  (* 边界锚点的非能量参数（动量、timePower、nu）来自目标规则；只有能量可自由变化。 *)
  nonEnergyPart[rules_] := Sort@Select[rules, FreeQ[energySymbols, First[#]] &];
  firstPoint = First[points];
  boundary = MSBoundaryData[
    context,
    firstPoint,
    Sequence @@ boundaryOptions
  ];
  results = Map[
    Function[targetRules,
      If[nonEnergyPart[targetRules] =!= nonEnergyPart[firstPoint],
        (* 非能量参数变化时边界本身随之变化，必须重新生成。 *)
        boundary = MSBoundaryData[
          context,
          targetRules,
          Sequence @@ boundaryOptions
        ];
        firstPoint = targetRules;
      ];
      MSFlintNDETransport[
        context,
        Join[KeyDrop[boundary, "targetRules"], <|"targetRules" -> targetRules|>],
        Sequence @@ transportOptions
      ]
    ],
    points
  ];
  results
];

batchResults = batchEvaluateTree[
  context,
  batchFixedRules,
  batchPointTable,
  {BoundaryScale -> 4, WorkingPrecision -> 40},
  {WorkingPrecision -> 40, TransportOrder -> 80,
   ReferenceTransportOrder -> 104, TargetRelativeError -> "1e-20"},
  PointSymbols -> batchPointSymbols
];

(* 完整规则点（供结果标注用）；用户只需维护上面的 batchFixedRules/batchPointTable *)
batchPoints = Map[
  Join[batchFixedRules, Thread[batchPointSymbols -> #]] &,
  batchPointTable
];

Print["batchValues = ",
  MapThread[Rule, {batchPoints, Lookup[batchResults, "values"]}]];
Print["batchDiagnostics = ",
  MapThread[
    {#1, #2, #3} &,
    {batchPoints,
     Lookup[batchResults, "status"],
     Lookup[Lookup[batchResults, "flintNDE"], "relativeDifferenceInf"]}
  ]];
