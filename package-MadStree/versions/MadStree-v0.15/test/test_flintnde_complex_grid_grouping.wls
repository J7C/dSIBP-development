(* ::Package:: *)

(***
文件：test_flintnde_complex_grid_grouping.wls
用途：验证 MadStree 按输入顺序把二维复格点划为最大连续复仿射单变量组。
范围：使用新 pointSequence 表头/值行 schema 的 900 个 exact 点；固定 x1 的 300 个复数 x2
      点必须归入同一组，
      x1 改变时通过独立过渡组衔接，且不同组不共享局部级数。
运行：wolframscript -file package-MadStree/versions/MadStree-v0.15/test/test_flintnde_complex_grid_grouping.wls
***)

(* ::Chapter:: *)
(*加载与二维复格点*)

Get[FileNameJoin[{DirectoryName[$InputFileName], "_harness.wls"}]];
packageRoot = msTestLoadKernel[];

x10 = 2;
x20 = 3 + I;
context = MSInitTree[<|
  "vertices" -> {
    <|"id" -> 1, "externalLegEnergy" -> x1, "timePower" -> a1,
      "vertexType" -> "+"|>,
    <|"id" -> 2, "externalLegEnergy" -> x2, "timePower" -> a2,
      "vertexType" -> "+"|>
  },
  "lines" -> {
    <|"type" -> "massless", "endpoints" -> {1, 2}, "momentum" -> q,
      "nu" -> 1/2|>
  }
|>];
de = MSDLogDE[context];
parameterRules = {q -> 1, a1 -> 1, a2 -> 1};
gridPointValues = Flatten[
  Table[
    {
      x10 + a/10,
      x20 + n/10 + I m/10
    },
    {a, 0, 2},
    {n, 0, 99},
    {m, 0, 2}
  ],
  {{1, 2, 3}}
];
pointSequence = Prepend[gridPointValues, {x1, x2}];


(* ::Chapter:: *)
(*连续复仿射组识别*)

normalizedInput = MadStree`Private`msEvaluationPointSequenceNormalize[
  context,
  de,
  pointSequence,
  parameterRules
];
If[Head[normalizedInput] === Failure,
  Print["pointSequence normalization failed: ", InputForm[normalizedInput]];
  Exit[1]
];
normalizedPoints = normalizedInput["points"];
anchor = <|
  "coordinate" -> First[normalizedPoints]["coordinate"],
  "tag" -> "boundaryAnchor",
  "userIndex" -> 0
|>;
groups = MadStree`Private`msEvaluationAffineGroups[
  Prepend[normalizedPoints, anchor],
  {x1, x2}
];
groupPointLists = Lookup[#, "points", {}] & /@ groups;
groupUserIndices = (Lookup[#, "userIndex", Missing["Absent"]] & /@ #) & /@
  groupPointLists;

fixedX1Blocks = {
  Range[1, 300],
  Range[301, 600],
  Range[601, 900]
};
fixedX1Groups = Table[
  SelectFirst[
    groups,
    (Lookup[#, "userIndex", Missing["Absent"]] & /@
      Lookup[#, "points", {}]) === block &,
    Missing["Absent"]
  ],
  {block, fixedX1Blocks}
];


(* ::Chapter:: *)
(*结构断言*)

checks = <|
  "pointCount900" -> Length[gridPointValues] === 900,
  "newPointSequenceSchema" -> First[pointSequence] === {x1, x2} &&
    normalizedInput["parameterRules"] === parameterRules,
  "nMajorInputOrder" -> gridPointValues[[1 ;; 6]] === {
    {x10, x20},
    {x10, x20 + I/10},
    {x10, x20 + I/5},
    {x10, x20 + 1/10},
    {x10, x20 + 1/10 + I/10},
    {x10, x20 + 1/10 + I/5}
  },
  "threeFixedX1ComplexPlaneGroups" -> FreeQ[fixedX1Groups, _Missing],
  "eachFixedX1GroupHas300Points" -> And @@ (
    Length[Lookup[#, "points", {}]] === 300 & /@ fixedX1Groups
  ),
  "x1ConstantInsideEachGroup" -> And @@ MapThread[
    Function[{group, value},
      DeleteDuplicates[
        x1 /. (Lookup[#, "coordinate", {}] & /@ Lookup[group, "points", {}])
      ] === {value}
    ],
    {fixedX1Groups, x10 + Range[0, 2]/10}
  ],
  "eachGroupUsesRealAndImaginaryX2Directions" -> And @@ Map[
    Function[group,
      With[{
        values = x2 /. (Lookup[#, "coordinate", {}] & /@ Lookup[group, "points", {}])
      },
        Length[DeleteDuplicates[Re[values]]] === 100 &&
        Length[DeleteDuplicates[Im[values]]] === 3
      ]
    ],
    fixedX1Groups
  ],
  "groupBoundariesReuseOnlyCommonPoints" -> groupUserIndices === {
    Range[1, 300],
    {300, 301},
    Range[301, 600],
    {600, 601},
    Range[601, 900]
  }
|>;


(* ::Chapter:: *)
(*汇总*)

msTestSummary[checks, "MadStree complex-grid affine grouping"];
