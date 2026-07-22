(* ::Package:: *)
(* 本检查把冻结的 tree/dlog/common-theta 公式单向对照 014，覆盖 8/48 seeds、递推门禁和三平行 massive h contact。 *)

ClearAll["Global`*"];


(* ::Chapter:: *)
(*冻结 expected 与 package*)
Get[FileNameJoin[{DirectoryName[DirectoryName[$InputFileName]], "tree", "expected.wl"}]];

checkDir = DirectoryName[$InputFileName];
workspaceDir = DirectoryName[checkDir];
projectDir = DirectoryName[workspaceDir];
packagePath = FileNameJoin[{projectDir, "independent-benchmark", "package", "package_014.wl"}];
resultsDir = FileNameJoin[{checkDir, "results"}];
resultPath = FileNameJoin[{resultsDir, "tree-against-package.wl"}];
If[! DirectoryQ[resultsDir], CreateDirectory[resultsDir, CreateIntermediateDirectories -> True]];

Quiet[Get[packagePath], General::shdw];
DSMessagesOff[];


(* ::Chapter:: *)
(*两顶点与三顶点 loop 输入*)

(* ::Section::Closed:: *)
(*massive h line 同时保存 loop momentum 和 tree energy*)
treeLine[id_, endpoints_, momentum_, energy_, nu_] := <|
  "id" -> id,
  "endpoints" -> endpoints,
  "momentum" -> momentum,
  "treeEnergy" -> energy,
  "nu" -> nu,
  "bbType" -> "h",
  "massType" -> "massive"
|>;

treeLoopCase[name_, vertexData_, lines_List, loops_List, energies_Association, zeroPoints_List, ispExpressions_List : {}] := <|
  "name" -> name,
  "vertexData" -> vertexData,
  "lineData" -> lines,
  "loopMomenta" -> loops,
  "externalMomenta" -> {},
  "externalInvariantRules" -> {},
  "vertexEnergies" -> energies,
  "ispData" -> MapIndexed[
    <|"name" -> Symbol["treeRho" <> ToString[First[#2]]], "expr" -> #1, "range" -> {0}|> &,
    ispExpressions
  ],
  "zeroPointRules" -> zeroPoints,
  "symmetryRules" -> {},
  "seedRanges" -> <|"a" -> {0}, "b" -> {0}, "sampleOnly" -> True|>
|>;

twoCase = treeLoopCase[
  "tree-two-plus-plus",
  {{v1, "+"}, {v2, "+"}},
  {treeLine[1, {v1, v2}, ell12, k12, nu12]},
  {ell12},
  <|v1 -> K1, v2 -> K2|>,
  {a0[v1] -> mu1, a0[v2] -> mu2, b0[1] -> beta12}
];

threeCase = treeLoopCase[
  "tree-three-plus-plus-minus",
  {{v1, "+"}, {v2, "+"}, {v3, "-"}},
  {
    treeLine[1, {v1, v2}, ell12, k12, nu12],
    treeLine[2, {v2, v3}, ell23, k23, nu23]
  },
  {ell12, ell23},
  <|v1 -> K1, v2 -> K2, v3 -> K3|>,
  {a0[v1] -> mu1, a0[v2] -> mu2, a0[v3] -> mu3, b0[1] -> beta12, b0[2] -> beta23},
  {sp[ell12, ell23]}
];


(* ::Section::Closed:: *)
(*固定全离散态并只调用 time/tree API*)
twoLoopIntegrals = Flatten@Table[
  J[{a1, a2}, {{b12, n11, n12}}, {}],
  {n11, 0, 1}, {n12, 0, 1}
];

threeLoopIntegrals = Flatten@Table[
  J[{a1, a2, a3}, {{b12, n11, n12}, {b23, n21, n22}}, {0}],
  {n11, 0, 1}, {n12, 0, 1}, {n21, 0, 1}, {n22, 0, 1}
];

twoContext = DSInit[twoCase, RegisterAsCurrent -> False, ProgressReporting -> False];
threeContext = DSInit[threeCase, RegisterAsCurrent -> False, ProgressReporting -> False];
twoMixedCase = Join[twoCase, <|"name" -> "tree-two-plus-minus", "vertexData" -> {{v1, "+"}, {v2, "-"}}|>];
twoMixedContext = DSInit[twoMixedCase, RegisterAsCurrent -> False, ProgressReporting -> False];

twoRecords = Flatten@Table[
  DSTreeSeeds[vertex, integral, twoContext],
  {vertex, {v1, v2}}, {integral, twoLoopIntegrals}
];
threeRecords = Flatten@Table[
  DSTreeSeeds[vertex, integral, threeContext],
  {vertex, {v1, v2, v3}}, {integral, threeLoopIntegrals}
];


(* ::Chapter:: *)
(*从 IBP seed 方程独立抽取 general recurrence*)

(* ::Section::Closed:: *)
(*固定其它顶点为零态，完整收集当前顶点的 local binary block*)
treeSeedVertexBlock[records_List, data_Association, vertexIndex_Integer] := Module[
  {vertex, vertexId, vertexRecords, selected, ordered, current, lower, equations,
    currentMatrix, lowerMatrix, minusMatrix, plusMatrix, minusRules, plusRules, aSymbol},
  vertex = Lookup[data, "vertices"][[vertexIndex]];
  vertexId = Lookup[vertex, "id"];
  vertexRecords = Select[records, Lookup[#, "generator", None] === dtau[vertexId] &];
  selected = Select[vertexRecords, Function[record,
    With[{packs = First[Lookup[record, "treeIntegral"]]},
      And @@ Table[
        index === vertexIndex || Rest[packs[[index]]] === ConstantArray[0, Lookup[Lookup[data, "vertices"][[index]], "p"]],
        {index, Length[packs]}
      ]
    ]
  ]];
  ordered = SortBy[selected, Rest[First[Lookup[#, "treeIntegral"]][[vertexIndex]]] &];
  If[Length[ordered] =!= 2^Lookup[vertex, "p"],
    Return[<|"status" -> "error", "vertex" -> vertexId, "recordCount" -> Length[ordered]|>]
  ];
  current = Lookup[ordered, "treeIntegral"];
  lower = Map[
    Function[integral,
      J[ReplacePart[
        First[integral],
        vertexIndex -> ReplacePart[
          First[integral][[vertexIndex]],
          1 -> First[integral][[vertexIndex, 1]] - 1
        ]
      ]]
    ],
    current
  ];
  equations = Lookup[ordered, "treeSeed"];
  currentMatrix = Table[
    Coefficient[equations[[row]], current[[column]]],
    {row, Length[equations]}, {column, Length[current]}
  ];
  lowerMatrix = Table[
    Coefficient[equations[[row]], lower[[column]]],
    {row, Length[equations]}, {column, Length[lower]}
  ];
  minusMatrix = LinearSolve[lowerMatrix, -currentMatrix];
  plusMatrix = LinearSolve[currentMatrix, -lowerMatrix];
  minusRules = Thread[lower -> LinearSolve[lowerMatrix, -(equations /. Thread[lower -> 0])]];
  plusRules = Thread[current -> LinearSolve[currentMatrix, -(equations /. Thread[current -> 0])]];
  aSymbol = First[current[[1]]][[vertexIndex, 1]];
  <|
    "status" -> "generated", "vertex" -> vertexId, "aSymbol" -> aSymbol,
    "current" -> current, "lower" -> lower, "equations" -> equations,
    "minus" -> minusMatrix, "plus" -> plusMatrix,
    "minusRules" -> minusRules, "plusRules" -> plusRules
  |>
];


(* ::Chapter:: *)
(*独立 dlog 矩阵、letters 与 masters*)

(* ::Section::Closed:: *)
(*只按冻结公式构造 package 接受的 tree data*)
treeVertex[id_, sign_, nu0_, energy_, legs_List] := <|
  "id" -> id,
  "sign" -> sign,
  "nu0" -> nu0,
  "energy" -> energy,
  "signedEnergy" -> If[sign === "+", -energy, energy],
  "massiveLegs" -> legs,
  "p" -> Length[legs]
|>;

treeLeg[id_, nu_, energy_] := <|"id" -> id, "nu" -> nu, "energy" -> energy|>;

twoTreeData = <|
  "vertices" -> {
    treeVertex[v1, "+", mu1, K1, {treeLeg[{1, 1}, nu12, k12]}],
    treeVertex[v2, "+", mu2, K2, {treeLeg[{1, 2}, nu12, k12]}]
  },
  "vertexOrder" -> {v1, v2}, "packLengths" -> {2, 2},
  "sector" -> "top", "sourceStructure" -> {}
|>;

threeTreeData = <|
  "vertices" -> {
    treeVertex[v1, "+", mu1, K1, {treeLeg[{1, 1}, nu12, k12]}],
    treeVertex[v2, "+", mu2, K2, {treeLeg[{1, 2}, nu12, k12], treeLeg[{2, 1}, nu23, k23]}],
    treeVertex[v3, "-", mu3, K3, {treeLeg[{2, 2}, nu23, k23]}]
  },
  "vertexOrder" -> {v1, v2, v3}, "packLengths" -> {2, 3, 2},
  "sector" -> "top", "sourceStructure" -> {}
|>;

twoSeedBlocks = Table[treeSeedVertexBlock[twoRecords, twoTreeData, vertexIndex], {vertexIndex, 2}];
threeSeedBlocks = Table[treeSeedVertexBlock[threeRecords, threeTreeData, vertexIndex], {vertexIndex, 3}];

expectedVertexOmega[vertex_Association] := treeOmega[
  Lookup[vertex, "nu0"],
  Lookup[Lookup[vertex, "massiveLegs"], "nu"],
  Lookup[vertex, "signedEnergy"],
  Lookup[Lookup[vertex, "massiveLegs"], "energy"]
];

embedMixedVertex[matrix_, slot_Integer, dimensions_List] := kronProduct[
  Table[If[index === slot, matrix, IdentityMatrix[dimensions[[index]]]], {index, Length[dimensions]}]
];

expectedGlobalOmega[data_Association] := Module[{vertices, dimensions},
  vertices = Lookup[data, "vertices"];
  dimensions = 2^Lookup[vertices, "p"];
  Total[MapIndexed[embedMixedVertex[expectedVertexOmega[#1], First[#2], dimensions] &, vertices]]
];

expectedLetters[data_Association] := DeleteDuplicates[Flatten[Map[
  Function[vertex,
    states = binaryMasterOrder[Lookup[vertex, "p"]];
    energies = Lookup[Lookup[vertex, "massiveLegs"], "energy"];
    Join[
      energies,
      (Lookup[vertex, "signedEnergy"] + Total[(2 # - 1) energies] & /@ states)
    ]
  ],
  Lookup[data, "vertices"]
]]];

expectedMasters[data_Association] := Module[{perVertex},
  perVertex = (Prepend[#, 0] & /@ binaryMasterOrder[Lookup[#, "p"]]) & /@ Lookup[data, "vertices"];
  J[#] & /@ Tuples[perVertex]
];

twoDLog = DSTreeDLogDE[twoTreeData];
threeDLog = DSTreeDLogDE[threeTreeData];


(* ::Section::Closed:: *)
(*general seed recurrence 与冻结直接公式逐顶点比较*)
treeSeedRecurrenceRows[caseName_String, data_Association, blocks_List] := Flatten[MapThread[
  Function[{vertex, block},
    With[
      {
        a = Lookup[block, "aSymbol"],
        nus = Lookup[Lookup[vertex, "massiveLegs"], "nu"],
        energies = Lookup[Lookup[vertex, "massiveLegs"], "energy"],
        signedEnergy = Lookup[vertex, "signedEnergy"],
        nu0 = Lookup[vertex, "nu0"]
      },
      {
        <|
          "label" -> caseName <> "-" <> ToString[Lookup[vertex, "id"]] <> "-seed-Aminus-general",
          "actual" -> Together /@ Flatten[Lookup[block, "minus"] - treeAMinus[nu0 + a, nus, signedEnergy, energies]],
          "expected" -> ConstantArray[0, 4^Length[nus]]
        |>,
        <|
          "label" -> caseName <> "-" <> ToString[Lookup[vertex, "id"]] <> "-seed-Aplus-general",
          "actual" -> Together /@ Flatten[Lookup[block, "plus"] - treeAPlus[nu0 + a - 1, nus, signedEnergy, energies]],
          "expected" -> ConstantArray[0, 4^Length[nus]]
        |>
      }
    ]
  ],
  {Lookup[data, "vertices"], blocks}
]];

seedRecurrenceRows = Join[
  treeSeedRecurrenceRows["two", twoTreeData, twoSeedBlocks],
  treeSeedRecurrenceRows["three", threeTreeData, threeSeedBlocks]
];


(* ::Section::Closed:: *)
(*用 seed-derived A+ 重建 connection 的全部能量方向导数*)
seedLocalDEDerivative[vertex_Association, plusMatrix_, variable_] := Module[
  {p, identity, signedEnergy, legs, result},
  p = Lookup[vertex, "p"];
  identity = IdentityMatrix[2^p];
  signedEnergy = Lookup[vertex, "signedEnergy"];
  legs = Lookup[vertex, "massiveLegs"];
  result = D[signedEnergy, variable] I plusMatrix;
  Do[
    result += D[Lookup[legs[[slot]], "energy"], variable] (
      -(2 Lookup[legs[[slot]], "nu"] + 1)/(2 Lookup[legs[[slot]], "energy"]) (identity - lambda[3, slot, p])
        - I lambda[2, slot, p] . plusMatrix
    ),
    {slot, p}
  ];
  result
];

seedGlobalDEDerivative[data_Association, blocks_List, variable_] := Module[
  {vertices, dimensions, masterPlus},
  vertices = Lookup[data, "vertices"];
  dimensions = 2^Lookup[vertices, "p"];
  masterPlus = Map[Lookup[#, "plus"] /. Lookup[#, "aSymbol"] -> 1 &, blocks];
  Total[MapIndexed[
    embedMixedVertex[
      seedLocalDEDerivative[vertices[[First[#2]]], #1, variable],
      First[#2],
      dimensions
    ] &,
    masterPlus
  ]]
];

twoDEVariables = {K1, K2, k12};
threeDEVariables = {K1, K2, K3, k12, k23};
seedDERows = Join[
  Map[Function[variable, <|
    "label" -> "two-seed-derived-DE-" <> ToString[variable],
    "actual" -> Together /@ Flatten[D[Lookup[twoDLog, "omega"], variable] - seedGlobalDEDerivative[twoTreeData, twoSeedBlocks, variable]],
    "expected" -> ConstantArray[0, 16]
  |>], twoDEVariables],
  Map[Function[variable, <|
    "label" -> "three-seed-derived-DE-" <> ToString[variable],
    "actual" -> Together /@ Flatten[D[Lookup[threeDLog, "omega"], variable] - seedGlobalDEDerivative[threeTreeData, threeSeedBlocks, variable]],
    "expected" -> ConstantArray[0, 256]
  |>], threeDEVariables]
];


(* ::Section::Closed:: *)
(*Naive time-IBP/DE 与公式 dlog 的同 basis 互查*)
twoMixedTreeData = Join[twoTreeData, <|"vertices" -> {
      treeVertex[v1, "+", mu1, K1, {treeLeg[{1, 1}, nu12, k12]}],
      treeVertex[v2, "-", mu2, K2, {treeLeg[{1, 2}, nu12, k12]}]
      }|>];

treeDEVariables = {K1, K2, k12};
twoGlobalDLog = DSTreeDLogDE[twoContext];
twoNaiveIBP = DSTreeNaiveIBP[twoContext, twoGlobalDLog["masters"], ProgressReporting -> False];
twoNaiveDE = DSTreeNaiveDE[twoNaiveIBP, treeDEVariables, ProgressReporting -> False];
twoRouteResidual = Flatten@Table[
    Together /@ Flatten[twoNaiveDE["matrices", variable] - D[twoGlobalDLog["omega"], variable]],
    {variable, treeDEVariables}
    ];
twoIndependentTopResidual = Flatten@Table[
    Together /@ Flatten[
      Take[twoNaiveDE["matrices", variable], {1, 4}, {1, 4}] - D[expectedGlobalOmega[twoTreeData], variable]
      ],
    {variable, treeDEVariables}
    ];

twoMixedGlobalDLog = DSTreeDLogDE[twoMixedContext];
twoMixedNaiveIBP = DSTreeNaiveIBP[twoMixedContext, twoMixedGlobalDLog["masters"], ProgressReporting -> False];
twoMixedNaiveDE = DSTreeNaiveDE[twoMixedNaiveIBP, treeDEVariables, ProgressReporting -> False];
twoMixedRouteResidual = Flatten@Table[
    Together /@ Flatten[twoMixedNaiveDE["matrices", variable] - D[twoMixedGlobalDLog["omega"], variable]],
    {variable, treeDEVariables}
    ];
twoMixedIndependentResidual = Flatten@Table[
    Together /@ Flatten[twoMixedNaiveDE["matrices", variable] - D[expectedGlobalOmega[twoMixedTreeData], variable]],
    {variable, treeDEVariables}
    ];


(* ::Chapter:: *)
(*contact、递推与三平行线门禁*)

(* ::Section::Closed:: *)
(*G++ 允许 contact；G+- 绝不进入 audit/WT trace*)
twoContactLines = DeleteDuplicates[Cases[Lookup[twoRecords, "contactAudit", {}], item_Association :> Lookup[item, "lineId"], Infinity]];
threeContactLines = DeleteDuplicates[Cases[Lookup[threeRecords, "contactAudit", {}], item_Association :> Lookup[item, "lineId"], Infinity]];
threeConsumedLines = DeleteDuplicates[Cases[Lookup[threeRecords, "shrinkConsumptionTrace", {}], item_Association :> Lookup[item, "lineId"], Infinity]];


(* ::Section::Closed:: *)
(*repIterative 正例和三个拒绝门禁*)
treeTarget = J[{{-2, 1}, {1, 0}}];
validReduction = Quiet[Check[repIterative[treeTarget, {0, 0}, twoContext], $Failed]];
badLength = Quiet[Check[repIterative[treeTarget, {0}, twoContext], $Failed]];
badNonInteger = Quiet[Check[repIterative[treeTarget, {1/2, 0}, twoContext], $Failed]];
badMaxSteps = Quiet[Check[repIterative[treeTarget, {0, 0}, twoContext, MaxIterations -> 0], $Failed]];


(* ::Section::Closed:: *)
(*seed 方程路线与公开原始规则/API 的同终点约化*)
twoSeedTarget = J[{{-1, 1}, {1, 0}}];
twoSeedRoute = Expand[
  twoSeedTarget /. (Lookup[twoSeedBlocks[[1]], "minusRules"] /. {a1 -> 0, a2 -> 1})
];
twoDirectRoute = Expand[repIterative[twoSeedTarget, {0, 1}, twoContext, MaxIterations -> 10]];
twoRepIterative0 = repIterative0;
twoRawStep = Expand[twoSeedTarget /. twoRepIterative0];

threeSeedTarget = J[{{0, 0}, {0, 0, 0}, {-2, 0}}];
threeStepRules1 = Lookup[threeSeedBlocks[[3]], "minusRules"] /. {a1 -> 0, a2 -> 0, a3 -> -1};
threeStepRules2 = Lookup[threeSeedBlocks[[3]], "minusRules"] /. {a1 -> 0, a2 -> 0, a3 -> 0};
threeSeedStep1 = Expand[threeSeedTarget /. threeStepRules1];
threeSeedRoute = Expand[threeSeedStep1 /. threeStepRules2];
threeDirectRoute = Expand[repIterative[threeSeedTarget, {0, 0, 0}, threeContext, MaxIterations -> 10]];
threeRepIterative0 = repIterative0;
threeRawStep = Expand[threeSeedTarget /. threeRepIterative0];

treeProbeRules = {
  mu1 -> 7/3, mu2 -> 5/4, mu3 -> 9/5,
  nu12 -> 1/5, nu23 -> 2/7,
  K1 -> 11/3, K2 -> 13/4, K3 -> 17/5,
  k12 -> 2/3, k23 -> 3/5, beta12 -> 1/7, beta23 -> 2/9
};
treeProbeMasters = DeleteDuplicates[Cases[
  {twoSeedRoute, twoDirectRoute, threeSeedRoute, threeDirectRoute},
  _J,
  Infinity
]];
treeProbeMasterRules = MapIndexed[
  #1 -> Prime[First[#2] + 10]/Prime[First[#2] + 40] &,
  treeProbeMasters
];
twoSeedProbe = Together[twoSeedRoute /. treeProbeRules /. treeProbeMasterRules];
twoDirectProbe = Together[twoDirectRoute /. treeProbeRules /. treeProbeMasterRules];
threeSeedProbe = Together[threeSeedRoute /. treeProbeRules /. treeProbeMasterRules];
threeDirectProbe = Together[threeDirectRoute /. treeProbeRules /. treeProbeMasterRules];

seedEndpointRows = {
  <|"label" -> "two-repIterative0-nonempty", "actual" -> Length[twoRepIterative0] > 0, "expected" -> True|>,
  <|"label" -> "two-seed-vs-repIterative0-step", "actual" -> Together[Expand[twoSeedRoute - twoRawStep]], "expected" -> 0|>,
  <|"label" -> "two-seed-vs-repIterative-endpoint", "actual" -> Together[Expand[twoSeedRoute - twoDirectRoute]], "expected" -> 0|>,
  <|"label" -> "three-repIterative0-nonempty", "actual" -> Length[threeRepIterative0] > 0, "expected" -> True|>,
  <|"label" -> "three-seed-vs-repIterative0-first-step", "actual" -> Together[Expand[threeSeedStep1 - threeRawStep]], "expected" -> 0|>,
  <|"label" -> "three-seed-vs-repIterative-two-level", "actual" -> Together[Expand[threeSeedRoute - threeDirectRoute]], "expected" -> 0|>,
  <|"label" -> "two-deterministic-rational-probe", "actual" -> twoSeedProbe, "expected" -> twoDirectProbe|>,
  <|"label" -> "three-deterministic-rational-probe", "actual" -> threeSeedProbe, "expected" -> threeDirectProbe|>
};


(* ::Section::Closed:: *)
(*三条平行 massive h 的共同 theta odd subsets*)
parallelCase[signs_List] := treeLoopCase[
  "three-parallel-massive-h",
  MapThread[{#1, If[#2 === 1, "+", "-"]} &, {{v1, v2}, signs}],
  {
    treeLine[1, {v1, v2}, p1, k1, nu1],
    treeLine[2, {v1, v2}, p2, k2, nu2],
    treeLine[3, {v1, v2}, p3, k3, nu3]
  },
  {p1, p2, p3},
  <|v1 -> K1, v2 -> K2|>,
  {a0[v1] -> mu1, a0[v2] -> mu2, b0[1] -> beta1, b0[2] -> beta2, b0[3] -> beta3},
  {sp[p1, p2], sp[p1, p3], sp[p2, p3]}
];

parallelIntegral = J[{a1, a2}, {{b1, 0, 1}, {b2, 0, 1}, {b3, 0, 1}}, {0, 0, 0}];
parallelSameContext = DSInit[parallelCase[{1, 1}], RegisterAsCurrent -> False, ProgressReporting -> False];
parallelMixedContext = DSInit[parallelCase[{1, -1}], RegisterAsCurrent -> False, ProgressReporting -> False];
parallelSameRecord = DSTreeSeeds[v1, parallelIntegral, parallelSameContext];
parallelMixedRecord = DSTreeSeeds[v1, parallelIntegral, parallelMixedContext];

sameShrinkSets = Sort[DeleteDuplicates[Select[
  Values[Lookup[parallelSameRecord, "shrunkLinesByIntegral", <||>]],
  # =!= {} &
]]];
mixedShrinkSets = DeleteDuplicates[Select[
  Values[Lookup[parallelMixedRecord, "shrunkLinesByIntegral", <||>]],
  # =!= {} &
]];
tripleEnergyFactor = Times @@ {
  (-k1)^(-2 nu1 - 1), (-k2)^(-2 nu2 - 1), (-k3)^(-2 nu3 - 1)
};
tripleEnergyFactorQ = And[
  ! FreeQ[Lookup[parallelSameRecord, "treeSeed"], k1^(-2 nu1 - 1)],
  ! FreeQ[Lookup[parallelSameRecord, "treeSeed"], k2^(-2 nu2 - 1)],
  ! FreeQ[Lookup[parallelSameRecord, "treeSeed"], k3^(-2 nu3 - 1)],
  ! FreeQ[Lookup[parallelSameRecord, "treeSeed"], (-1)^(-3 - 2 nu1 - 2 nu2 - 2 nu3)]
];


(* ::Chapter:: *)
(*汇总与持久化*)
checks = {
  <|"label" -> "two-seed-count", "actual" -> Length[twoRecords], "expected" -> 8|>,
  <|"label" -> "three-seed-count", "actual" -> Length[threeRecords], "expected" -> 48|>,
  <|"label" -> "two-generated", "actual" -> And @@ (Lookup[#, "status", ""] === "generated" & /@ twoRecords), "expected" -> True|>,
  <|"label" -> "three-generated", "actual" -> And @@ (Lookup[#, "status", ""] === "generated" & /@ threeRecords), "expected" -> True|>,
  <|"label" -> "two-contact-line", "actual" -> twoContactLines, "expected" -> {1}|>,
  <|"label" -> "three-contact-line", "actual" -> threeContactLines, "expected" -> {1}|>,
  <|"label" -> "three-consumed-line", "actual" -> threeConsumedLines, "expected" -> {1}|>,
  <|"label" -> "two-complete-contact-power", "actual" -> ! FreeQ[Lookup[twoRecords, "treeSeed"], k12^(-2 nu12 - 1)], "expected" -> True|>,
  <|"label" -> "two-dlog-matrix", "actual" -> Together /@ Flatten[Lookup[twoDLog, "omega"] - expectedGlobalOmega[twoTreeData]], "expected" -> ConstantArray[0, 16]|>,
  <|"label" -> "three-dlog-matrix", "actual" -> Together /@ Flatten[Lookup[threeDLog, "omega"] - expectedGlobalOmega[threeTreeData]], "expected" -> ConstantArray[0, 256]|>,
  <|"label" -> "two-letters", "actual" -> Lookup[twoDLog, "letters"], "expected" -> expectedLetters[twoTreeData]|>,
  <|"label" -> "three-letters", "actual" -> Lookup[threeDLog, "letters"], "expected" -> expectedLetters[threeTreeData]|>,
  <|"label" -> "two-masters", "actual" -> Lookup[twoDLog, "masters"], "expected" -> expectedMasters[twoTreeData]|>,
  <|"label" -> "three-masters", "actual" -> Lookup[threeDLog, "masters"], "expected" -> expectedMasters[threeTreeData]|>,
  <|"label" -> "two-naive-ibp-solved", "actual" -> Lookup[twoNaiveIBP, "status", "failed"], "expected" -> "solved"|>,
  <|"label" -> "two-naive-de-generated", "actual" -> Lookup[twoNaiveDE, "status", "failed"], "expected" -> "generated"|>,
  <|"label" -> "two-naive-formula-same-masters", "actual" -> Lookup[twoNaiveDE, "masters", {}], "expected" -> Lookup[twoGlobalDLog, "masters", Missing["masters"]]|>,
  <|"label" -> "two-naive-formula-de", "actual" -> twoRouteResidual, "expected" -> ConstantArray[0, Length[twoRouteResidual]]|>,
  <|"label" -> "two-naive-independent-top-de", "actual" -> twoIndependentTopResidual, "expected" -> ConstantArray[0, Length[twoIndependentTopResidual]]|>,
  <|"label" -> "two-mixed-naive-ibp-solved", "actual" -> Lookup[twoMixedNaiveIBP, "status", "failed"], "expected" -> "solved"|>,
  <|"label" -> "two-mixed-naive-formula-de", "actual" -> twoMixedRouteResidual, "expected" -> ConstantArray[0, Length[twoMixedRouteResidual]]|>,
  <|"label" -> "two-mixed-independent-de", "actual" -> twoMixedIndependentResidual, "expected" -> ConstantArray[0, Length[twoMixedIndependentResidual]]|>,
  <|"label" -> "two-mixed-no-contact-sector", "actual" -> Lookup[twoMixedGlobalDLog, "sectorOrder", {}], "expected" -> {"top"}|>,
  <|"label" -> "valid-recurrence", "actual" -> FreeQ[validReduction, $Failed], "expected" -> True|>,
  <|"label" -> "bad-end-length", "actual" -> badLength, "expected" -> $Failed|>,
  <|"label" -> "bad-noninteger-end", "actual" -> badNonInteger, "expected" -> $Failed|>,
  <|"label" -> "bad-max-steps", "actual" -> badMaxSteps, "expected" -> $Failed|>,
  <|"label" -> "parallel-odd-subsets", "actual" -> Sort[sameShrinkSets], "expected" -> Sort[oddSubsets[3]]|>,
  <|"label" -> "parallel-triple-energy-factor", "actual" -> tripleEnergyFactorQ, "expected" -> True|>,
  <|"label" -> "parallel-mixed-no-contact", "actual" -> mixedShrinkSets, "expected" -> {}|>,
  <|"label" -> "parallel-mixed-no-WT", "actual" -> Lookup[parallelMixedRecord, "shrinkConsumptionTrace", {}], "expected" -> {}|>
};

checks = Join[checks, seedRecurrenceRows, seedEndpointRows, seedDERows];
checks = Join[#, <|"passed" -> TrueQ[Lookup[#, "actual"] === Lookup[#, "expected"]]|>] & /@ checks;
summary = <|
  "packageHash" -> FileHash[packagePath, "SHA256", "HexString"],
  "passed" -> Count[checks, _?(TrueQ[Lookup[#, "passed", False]] &)],
  "total" -> Length[checks],
  "seedGeneralRecurrence" -> <|
    "passed" -> Count[seedRecurrenceRows, row_ /; Lookup[row, "actual"] === Lookup[row, "expected"]],
    "total" -> Length[seedRecurrenceRows]
  |>,
  "seedEndpointReduction" -> <|
    "passed" -> Count[seedEndpointRows, row_ /; Lookup[row, "actual"] === Lookup[row, "expected"]],
    "total" -> Length[seedEndpointRows]
  |>,
  "seedDerivedDE" -> <|
    "passed" -> Count[seedDERows, row_ /; Lookup[row, "actual"] === Lookup[row, "expected"]],
    "total" -> Length[seedDERows]
  |>,
  "parameterProbe" -> treeProbeRules,
  "masterProbe" -> treeProbeMasterRules,
  "nonconformities" -> Select[checks, ! TrueQ[Lookup[#, "passed", False]] &]
|>;

Put[summary, resultPath];
Print[InputForm[summary]];
If[summary["passed"] =!= summary["total"], Exit[1]];
