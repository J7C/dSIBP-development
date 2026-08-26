(* ::Package:: *)

(***
文件：test_boundary_contact_phase.wls
用途：验证 massive single/double pinch 的通用边界系数只包含 sector normalization 与定义积分系数。
范围：构造两顶点和三顶点纯 massive 树图，逐支 exact 检查；不运行数值输运或外部后端。
运行：wolframscript -file package-MadStree/versions/MadStree-v0.16/test/test_boundary_contact_phase.wls
***)


(* ::Chapter:: *)
(*加载与 exact 比值辅助函数*)

Get[FileNameJoin[{DirectoryName[$InputFileName], "_harness.wls"}]];
packageRoot = msTestLoadKernel[];

ClearAll[boundaryRatiosByContactCount];

(* 输入 context 和数值规则，返回每个 contact 深度下“实际系数/公开定义系数”的去重列表。 *)
boundaryRatiosByContactCount[
  context_?MSContextQ,
  targetRules_List,
  rankOrder_List
] := Module[{boundary, sectorByKey, rows},
  boundary = MSBoundaryData[
    context,
    targetRules,
    BoundaryScale -> 4,
    BoundarySeriesOrder -> 4,
    RankOrder -> rankOrder,
    WorkingPrecision -> 70
  ];
  If[Head[boundary] === Failure, Return[boundary]];
  sectorByKey = AssociationThread[context["sectorOrder"] -> context["sectors"]];
  rows = Function[record,
    With[{sector = sectorByKey[record["sectorKey"]]},
      <|
        "contactCount" -> Length[sector["contractedLineIds"]],
        "ratio" -> FullSimplify[
          record["coefficient"]/
            ((sector["normalization"] /. targetRules)
              Times @@ Lookup[record["componentData"], "coefficient"])
        ]
      |>
    ]
  ] /@ boundary["leadingBranches"];
  Association@KeyValueMap[#1 -> DeleteDuplicates[Lookup[#2, "ratio"]] &,
    GroupBy[rows, #1["contactCount"] &]]
];


(* ::Chapter:: *)
(*两顶点 single-pinch*)

twoVertexContext = MSInitTree[<|
  "name" -> "single-pinch exact phase regression",
  "vertices" -> {
    <|"id" -> 1, "externalLegEnergy" -> e1,
      "timePower" -> a1, "vertexType" -> "+"|>,
    <|"id" -> 2, "externalLegEnergy" -> e2,
      "timePower" -> a2, "vertexType" -> "+"|>
  },
  "lines" -> {
    <|"type" -> "massive", "endpoints" -> {1, 2},
      "momentum" -> q1, "nu" -> nu1|>
  }
|>, NuConvention -> "Negative"];
twoVertexRules = {
  e1 -> -20, e2 -> -4, q1 -> 1,
  nu1 -> 1/5, a1 -> 3, a2 -> 4
};
twoVertexRatios = boundaryRatiosByContactCount[
  twoVertexContext, twoVertexRules, {1, 2}
];


(* ::Chapter:: *)
(*三顶点 double-pinch*)

threeVertexContext = MSInitTree[<|
  "name" -> "double-pinch exact phase regression",
  "vertices" -> {
    <|"id" -> 1, "externalLegEnergy" -> e1,
      "timePower" -> a1, "vertexType" -> "+"|>,
    <|"id" -> 2, "externalLegEnergy" -> e2,
      "timePower" -> a2, "vertexType" -> "+"|>,
    <|"id" -> 3, "externalLegEnergy" -> e3,
      "timePower" -> a3, "vertexType" -> "+"|>
  },
  "lines" -> {
    <|"type" -> "massive", "endpoints" -> {1, 2},
      "momentum" -> q1, "nu" -> nu1|>,
    <|"type" -> "massive", "endpoints" -> {2, 3},
      "momentum" -> q2, "nu" -> nu2|>
  }
|>, NuConvention -> "Negative"];
threeVertexRules = {
  e1 -> -30, e2 -> -10, e3 -> -3,
  q1 -> 1, q2 -> 2,
  nu1 -> 1/5, nu2 -> 1/4,
  a1 -> 5, a2 -> 5, a3 -> 5
};
threeVertexRatios = boundaryRatiosByContactCount[
  threeVertexContext, threeVertexRules, {2, 1, 3}
];


(* ::Chapter:: *)
(*旧重复相位的反事实与验收摘要*)

(* 反事实只在测试结果上恢复旧 I^n，不重引入生产 helper 或兼容代码。 *)
twoVertexLegacyRatios = AssociationMap[
  I^# twoVertexRatios[#] &,
  Keys[twoVertexRatios]
];
threeVertexLegacyRatios = AssociationMap[
  I^# threeVertexRatios[#] &,
  Keys[threeVertexRatios]
];

checks = <|
  "singlePinchDepths" -> Sort[Keys[twoVertexRatios]] === {0, 1},
  "singlePinchDirectIntegralPhase" -> Values[twoVertexRatios] === {{1}, {1}},
  "singlePinchLegacyCounterfactual" ->
    twoVertexLegacyRatios === <|0 -> {1}, 1 -> {I}|>,
  "doublePinchDepths" -> Sort[Keys[threeVertexRatios]] === {0, 1, 2},
  "doublePinchDirectIntegralPhase" -> Values[threeVertexRatios] === {{1}, {1}, {1}},
  "doublePinchLegacyCounterfactual" ->
    threeVertexLegacyRatios === <|0 -> {1}, 1 -> {I}, 2 -> {-1}|>
|>;

msTestSummary[checks, "MadStree massive contact boundary phase"];
Print["twoVertexRatios: ", InputForm[twoVertexRatios]];
Print["threeVertexRatios: ", InputForm[threeVertexRatios]];
Print["legacyTwoVertexRatios: ", InputForm[twoVertexLegacyRatios]];
Print["legacyThreeVertexRatios: ", InputForm[threeVertexLegacyRatios]];

If[! And @@ Values[checks], Exit[1]];
