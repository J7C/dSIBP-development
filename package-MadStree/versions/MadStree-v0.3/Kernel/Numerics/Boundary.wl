(* ::Package:: *)

(***
文件：Boundary.wl
用途：从 2411.03088 的 k0->Infinity Frobenius 解生成与 dlog master 顺序一致的生产边界。
当前范围：任意已完成公式 dlog 与 strict-rank chart 认证的 tree/time-only context；单顶点 massiveExternal
函数族另保留 2411.03088 显式级数作为等价优化，其余情形统一由 sector DAG leading system 生成。
正确性边界：生产代码不计算有限点定义积分，也不调用 NIntegrate；dlog/chart 未认证、pullback 非正则奇点、
晚时幂次不收敛或 leading system 不闭合时返回结构化 Failure。
***)

(* ::Chapter:: *)
(*输入、选点与公共选项*)

Options[MSBoundaryData] = {
  BoundaryScale -> 8,
  BoundarySeriesOrder -> 24,
  RankOrder -> Automatic,
  WorkingPrecision -> 50
};

msRuleList[rules_List] := rules;
msRuleList[association_Association] := Normal[association];
msRuleList[_] := $Failed;

msBoundaryRequiredSymbols[context_?MSContextQ] := DeleteDuplicates@Cases[
  {
    Lookup[context["vertices"], "energy"],
    Lookup[context["vertices"], "timePower"],
    If[context["lines"] === {}, {}, Lookup[context["lines"], "momentum"]],
    If[context["lines"] === {}, {}, Lookup[context["lines"], "nu"]],
    context["rootNormalization"]
  },
  symbol_Symbol /; Context[symbol] =!= "System`",
  Infinity
];

(* preferred 点只决定 strict rank；较大的阻尼能量对应较小的典型 |tau|。 *)
msPreferredVertexOrder[context_?MSContextQ, targetRules_List] := Lookup[
  SortBy[
    context["vertices"],
    Function[vertex,
      With[{value = N[I vertex["phaseSign"] vertex["energy"] /. targetRules]},
        {-Re[value], -Abs[value], vertex["position"]}
      ]
    ]
  ],
  "id"
];

msBoundaryAnchorRules[
  context_?MSContextQ,
  targetRules_List,
  scale_?NumericQ,
  rankOrder_List
] := Module[{vertices = context["vertices"], positions, energyRules, retainedRules},
  positions = AssociationThread[rankOrder -> Range[Length[rankOrder]]];
  energyRules = Map[
    Function[vertex,
      vertex["energy"] -> -I vertex["phaseSign"] scale^(Length[vertices] - positions[vertex["id"]] + 1)
    ],
    vertices
  ];
  retainedRules = DeleteCases[targetRules, Rule[left_, _] /; MemberQ[Lookup[vertices, "energy"], left]];
  Join[energyRules, retainedRules]
];


(* ::Chapter:: *)
(*Nested blow-up、theta 固化与 normal-crossing 证书*)

msBoundaryRankAssociation[rankOrder_List] := AssociationThread[rankOrder -> Range[Length[rankOrder]]];


msBoundaryChartCoordinates[count_Integer] := Table[MSBlowupCoordinate[index], {index, count}];


msBoundaryEnergyChartData[context_?MSContextQ, rankOrder_List] := Module[
  {rank, coordinates, dampingSymbols, dampingRules, energyRules, vertexById, count},
  count = Length[rankOrder];
  rank = msBoundaryRankAssociation[rankOrder];
  coordinates = msBoundaryChartCoordinates[count];
  vertexById = AssociationThread[Lookup[context["vertices"], "id"] -> context["vertices"]];
  dampingSymbols = Association@Table[id -> MSDampingEnergy[id], {id, rankOrder}];
  dampingRules = Table[
    dampingSymbols[id] -> 1/Times @@ coordinates[[rank[id] ;; count]],
    {id, rankOrder}
  ];
  energyRules = Table[
    vertexById[id]["energy"] -> -I vertexById[id]["phaseSign"] dampingSymbols[id],
    {id, rankOrder}
  ];
  <|
    "rank" -> rank,
    "coordinates" -> coordinates,
    "dampingSymbols" -> dampingSymbols,
    "dampingRules" -> dampingRules,
    "energyRules" -> energyRules
  |>
];


msAffineLetterChartRecord[letter_, context_?MSContextQ, chart_Association] := Module[
  {dampingVariables, affineExpression, coefficientRules, activeRanks, dominantRank,
   monomial, strictTransform, boundaryValue, affineQ, unitQ, coordinates},
  dampingVariables = Values[chart["dampingSymbols"]];
  coordinates = chart["coordinates"];
  affineExpression = Together[letter /. chart["energyRules"]];
  coefficientRules = If[PolynomialQ[affineExpression, dampingVariables],
    CoefficientRules[affineExpression, dampingVariables], {}
  ];
  affineQ = PolynomialQ[affineExpression, dampingVariables] &&
    Max[0, Sequence @@ (Total[First[#]] & /@ coefficientRules)] <= 1;
  If[! TrueQ[affineQ],
    Return[<|
      "letter" -> letter,
      "status" -> "unsupportedNonAffineBoundaryDivisor",
      "affineExpression" -> affineExpression,
      "normalCrossingQ" -> False
    |>]
  ];
  activeRanks = Select[
    Range[Length[dampingVariables]],
    ! TrueQ[Simplify[Coefficient[affineExpression, dampingVariables[[#]]]] === 0] &
  ];
  dominantRank = If[activeRanks === {}, Missing["NoDampingEnergy"], Min[activeRanks]];
  monomial = If[
    Head[dominantRank] === Missing,
    1,
    1/Times @@ coordinates[[dominantRank ;; Length[coordinates]]]
  ];
  strictTransform = Simplify[(affineExpression /. chart["dampingRules"])/monomial];
  boundaryValue = Simplify[strictTransform /. Thread[coordinates -> 0]];
  unitQ = ! TrueQ[boundaryValue === 0] &&
    FreeQ[boundaryValue, Indeterminate | ComplexInfinity | DirectedInfinity];
  <|
    "letter" -> letter,
    "status" -> If[unitQ, "monomialTimesUnit", "strictTransformVanishes"],
    "affineExpression" -> affineExpression,
    "dominantRank" -> dominantRank,
    "coordinateMonomial" -> monomial,
    "strictTransform" -> strictTransform,
    "boundaryValue" -> boundaryValue,
    "normalCrossingQ" -> unitQ
  |>
];


msSectorThetaFixing[sector_Association, rank_Association] := Module[{componentDominantRank},
  componentDominantRank[component_List] := Min[rank /@ component];
  Map[
    Function[line,
      With[{components = sector["rootToComponent"] /@ line["endpoints"]},
        If[SameQ @@ components,
          <|"lineId" -> line["id"], "status" -> "coincident", "thetaUV" -> "equalTime"|>,
          With[{ranks = componentDominantRank /@ sector["vertexComponents"][[components]]},
            <|
              "lineId" -> line["id"],
              "status" -> "fixed",
              "endpointComponentRanks" -> ranks,
              "thetaUV" -> If[ranks[[1]] < ranks[[2]], 1, 0],
              "thetaVU" -> If[ranks[[2]] < ranks[[1]], 1, 0]
            |>
          ]
        ]
      ]
    ],
    Select[sector["activeLines"], msFullLineQ]
  ]
];


msDLogShiftDenominators[de_Association] := DeleteDuplicates@Flatten@Cases[
  Lookup[de, "contactBlocks", {}],
  layer_Association /; KeyExistsQ[layer, "surfaces"] :> layer["surfaces"],
  Infinity
];


msNormalizationDivisors[context_?MSContextQ] := DeleteDuplicates@Flatten[
  FactorList[Denominator[Together[#["normalization"]]]][[All, 1]] & /@ context["sectors"]
];


msSingleBoundaryChartCertificate[
  context_?MSContextQ,
  de_Association,
  rankOrder_List
] := Module[
  {chart, letters, records, theta, energyVector, jacobian, jacobianDeterminant,
   quotientQ, passedQ},
  chart = msBoundaryEnergyChartData[context, rankOrder];
  letters = DeleteDuplicates@Join[
    Lookup[de, "letters", {}],
    msDLogShiftDenominators[de],
    DeleteCases[msNormalizationDivisors[context], 1]
  ];
  records = msAffineLetterChartRecord[#, context, chart] & /@ letters;
  theta = AssociationThread[
    context["sectorOrder"] -> (msSectorThetaFixing[#, chart["rank"]] & /@ context["sectors"])
  ];
  energyVector = Lookup[
    Association[Rule @@@ ({#["energy"], #["energy"] /. chart["energyRules"] /. chart["dampingRules"]} & /@
      context["vertices"])],
    Lookup[context["vertices"], "energy"]
  ];
  jacobian = Outer[D, energyVector, chart["coordinates"]];
  jacobianDeterminant = Simplify[Det[jacobian]];
  quotientQ = And @@ Lookup[context["sectors"], "quotientCertifiedQ", False];
  passedQ = And @@ Lookup[records, "normalCrossingQ", True] &&
    ! TrueQ[jacobianDeterminant === 0] && quotientQ;
  <|
    "status" -> If[passedQ, "certifiedNormalCrossingChart", "normalCrossingCertificationFailed"],
    "normalCrossingQ" -> passedQ,
    "rankOrder" -> rankOrder,
    "coordinates" -> chart["coordinates"],
    "dampingDefinition" -> (I #["phaseSign"] #["energy"] & /@ context["vertices"]),
    "energyRules" -> chart["energyRules"],
    "dampingRules" -> chart["dampingRules"],
    "coordinateJacobian" -> jacobian,
    "coordinateJacobianDeterminant" -> jacobianDeterminant,
    "divisorRecords" -> records,
    "thetaFixingBySector" -> theta,
    "sectorQuotientCertifiedQ" -> quotientQ,
    "proofScope" -> "affine K-dependent dlog, normalization and shifted-recurrence divisors"
  |>
];


MSBoundaryChartCertificate[
  context_?MSContextQ,
  targetRulesInput_,
  OptionsPattern[{RankOrder -> Automatic}]
] := Module[{targetRules, vertexIds, requestedOrders, de, certificates},
  targetRules = msRuleList[targetRulesInput];
  If[targetRules === $Failed, Return[Failure["NumericalRulesRequired", <||>]]];
  vertexIds = Lookup[context["vertices"], "id"];
  requestedOrders = Replace[
    OptionValue[RankOrder],
    {
      Automatic :> {msPreferredVertexOrder[context, targetRules]},
      All :> Permutations[vertexIds],
      order_List :> {order}
    }
  ];
  If[AnyTrue[requestedOrders, Sort[#] =!= Sort[vertexIds] || ! DuplicateFreeQ[#] &],
    Return[Failure["InvalidRankOrder", <|"expected" -> vertexIds, "actual" -> requestedOrders|>]]
  ];
  de = MSDLogDE[context];
  certificates = msSingleBoundaryChartCertificate[context, de, #] & /@ requestedOrders;
  If[Length[certificates] === 1, First[certificates], <|"status" -> "generated", "charts" -> certificates|>]
];


(* ::Chapter:: *)
(*2411 Sec. 3.3 单顶点 Frobenius 系数*)

msPaperC[nu_] := 2^(-nu) Gamma[-nu]/(I Pi);

(* 返回 h=z^(+/-nu) H_nu 的两个 endpoint branch 系数；bit=0/1 对应 MadStree state。 *)
msVertexEndpointCoefficient["Negative", 1, 0, nu_] := Exp[-I Pi nu] msPaperC[nu];
msVertexEndpointCoefficient["Negative", 1, 1, nu_] := -msPaperC[-nu - 1];
msVertexEndpointCoefficient["Negative", 2, 0, nu_] := -Exp[I Pi nu] msPaperC[nu];
msVertexEndpointCoefficient["Negative", 2, 1, nu_] := msPaperC[-nu - 1];
msVertexEndpointCoefficient["Positive", 1, 0, nu_] := msPaperC[-nu];
msVertexEndpointCoefficient["Positive", 1, 1, nu_] := 2 nu Exp[-I Pi nu] msPaperC[nu];
msVertexEndpointCoefficient["Positive", 2, 0, nu_] := -msPaperC[-nu];
msVertexEndpointCoefficient["Positive", 2, 1, nu_] := -2 nu Exp[I Pi nu] msPaperC[nu];


msMultiIndices[count_Integer, order_Integer] := Select[
  Tuples[Range[0, order], count],
  Total[#] <= order &
];


msPaperFTilde4[aOne_, aTwo_, bList_List, zList_List, order_Integer] := If[
  bList === {},
  1,
  Total@Map[
    Function[index,
      Pochhammer[aOne, Total[index]] Pochhammer[aTwo, Total[index]] Times @@ MapThread[
        #2^#1/(Pochhammer[#3, #1] #1!) &,
        {index, zList, bList}
      ]
    ],
    msMultiIndices[Length[bList], order]
  ]
];


msVertexFrobeniusComponent[
  aBits_List,
  bBits_List,
  nuZero_,
  nuList_List,
  momenta_List,
  x_,
  branches_List,
  nuConvention_String,
  order_Integer
] := Module[
  {difference, distance, formulaNuList, aTilde, bTilde, bParameters, aOne, aTwo,
   coefficient, prefactor},
  difference = Abs[aBits - bBits];
  distance = Total[difference];
  formulaNuList = If[nuConvention === "Positive", -nuList, nuList];
  aTilde = nuZero + 1 - Total[bBits (2 formulaNuList + 1)];
  bTilde = formulaNuList + 1 - bBits (2 formulaNuList + 1);
  bParameters = bTilde + difference;
  If[AnyTrue[MapThread[{#1, #2} &, {bTilde, difference}],
      Last[#] === 1 && TrueQ[PossibleZeroQ[First[#]]] &],
    Return[$Failed]
  ];
  aOne = (aTilde + distance)/2;
  aTwo = (aTilde + distance + 1)/2;
  coefficient = (-I)^(nuZero + 1) Gamma[aTilde] Times @@ MapThread[
    (-I #1)^(-#2 (2 #3 + 1)) msVertexEndpointCoefficient[nuConvention, #4, #2, #5] &,
    {momenta, bBits, formulaNuList, branches, nuList}
  ];
  prefactor = x^aTilde Pochhammer[aTilde, distance]/2^distance Times @@ MapThread[
    If[#1 === 0, 1, ((-1)^#2 I #3 x/#4)] &,
    {difference, bBits, momenta, bTilde}
  ];
  coefficient prefactor msPaperFTilde4[
    aOne, aTwo, bParameters, momenta^2 x^2, order
  ]
];


msSingleVertexFrobeniusData[
  context_?MSContextQ,
  targetRules_List,
  scale_,
  order_Integer,
  workingPrecision_Integer
] := Module[
  {sector, vertex, lines, energy, phaseSign, nuZero, momenta, nuList, branches,
   nuConvention, stateOrder, branchOrder, momentumSizes, dampingScale, anchorEnergy,
   anchorRules, x, valuesAtOrder, valuesAtLowerOrder, normalization, leadingBranches,
   convergenceRatio, errors, formulaNuList, lateTimeExponents},
  sector = First[context["sectors"]];
  vertex = First[context["vertices"]];
  lines = context["lines"];
  energy = vertex["energy"];
  phaseSign = vertex["phaseSign"];
  If[! MatchQ[energy, _Symbol],
    Return[Failure["AsymptoticBoundaryEnergyCoordinateRequired", <|"energy" -> energy|>]]
  ];
  If[! And @@ (#["type"] === "massiveExternal" & /@ lines),
    Return[Failure[
      "AsymptoticBoundaryFamilyUnsupported",
      <|"reason" -> "single-vertex producer currently accepts only massiveExternal h blocks"|>
    ]]
  ];
  nuConvention = context["convention", "nuConvention"];
  nuZero = sector["baseTimePowers"][[1]] /. targetRules;
  momenta = If[lines === {}, {}, Lookup[lines, "momentum"]] /. targetRules;
  nuList = If[lines === {}, {}, Lookup[lines, "nu"]] /. targetRules;
  branches = If[lines === {}, {}, First /@ Lookup[lines, "hankelBranches"]];
  If[! And @@ (TrueQ[PossibleZeroQ[Im[N[#, workingPrecision]]]] & /@ Join[{nuZero}, nuList]),
    Return[Failure[
      "AsymptoticBoundaryComplexNuUnsupported",
      <|"reason" -> "current endpoint coefficient selector is certified for real nu only"|>
    ]]
  ];
  If[! And @@ (NumericQ[N[#, workingPrecision]] & /@ Join[{nuZero}, momenta, nuList]),
    Return[Failure["IncompleteNumericalPoint", <||>]]
  ];
  momentumSizes = Abs[N[momenta, workingPrecision]];
  dampingScale = Max[2, Ceiling[N[scale (1 + Total[momentumSizes]), 20]]];
  anchorEnergy = -I phaseSign dampingScale;
  anchorRules = Join[
    {energy -> anchorEnergy},
    DeleteCases[targetRules, Rule[left_, _] /; left === energy]
  ];
  x = 1/anchorEnergy;
  convergenceRatio = Total[Abs[N[momenta x, workingPrecision]]];
  If[! TrueQ[convergenceRatio < 1],
    Return[Failure[
      "FrobeniusAnchorOutsideConvergenceDomain",
      <|"ratio" -> convergenceRatio, "required" -> "Sum[Abs[ki/k0]] < 1"|>
    ]]
  ];
  stateOrder = sector["stateOrder"];
  branchOrder = Tuples[{0, 1}, Length[lines]];
  formulaNuList = If[nuConvention === "Positive", -nuList, nuList];
  lateTimeExponents = nuZero + 1 - Total[# (2 formulaNuList + 1)] & /@ branchOrder;
  If[AnyTrue[lateTimeExponents, ! TrueQ[Re[N[#, workingPrecision]] > 0] &],
    Return[Failure[
      "LateTimeBoundaryNotVanishing",
      <|
        "frobeniusExponents" -> lateTimeExponents,
        "condition" -> "Re[nu0+1-b.(2 formulaNu+1)]>0 for every endpoint branch",
        "fallbackUsedQ" -> False
      |>
    ]]
  ];
  normalization = sector["normalization"] /. targetRules;
  valuesAtOrder = Map[
    Function[aBits,
      normalization Total[
        msVertexFrobeniusComponent[
          aBits, #, nuZero, nuList,
          momenta, x, branches, nuConvention, order
        ] & /@ branchOrder
      ]
    ],
    stateOrder
  ];
  If[MemberQ[valuesAtOrder, $Failed] || ! And @@ (NumericQ[N[#, workingPrecision]] & /@ valuesAtOrder),
    Return[Failure["FrobeniusSeriesEvaluationFailed", <|"values" -> valuesAtOrder|>]]
  ];
  valuesAtLowerOrder = If[
    order < 2,
    valuesAtOrder,
    Map[
      Function[aBits,
        normalization Total[
          msVertexFrobeniusComponent[
            aBits, #, nuZero, nuList,
            momenta, x, branches, nuConvention, order - 2
          ] & /@ branchOrder
        ]
      ],
      stateOrder
    ]
  ];
  errors = Abs[N[valuesAtOrder - valuesAtLowerOrder, workingPrecision]];
  leadingBranches = Map[
    Function[bBits,
      <|
        "binaryState" -> bBits,
        "masterPosition" -> First@FirstPosition[stateOrder, bBits],
        "exponent" -> Simplify[nuZero + 1 - Total[bBits (2 formulaNuList + 1)]],
        "coefficient" -> Simplify[
          normalization (-I)^(nuZero + 1)
            Gamma[nuZero + 1 - Total[bBits (2 formulaNuList + 1)]]
            Times @@ MapThread[
              (-I #1)^(-#2 (2 #3 + 1)) msVertexEndpointCoefficient[nuConvention, #4, #2, #5] &,
              {momenta, bBits, formulaNuList, branches, nuList}
            ]
        ]
      |>
    ],
    branchOrder
  ];
  <|
    "values" -> N[valuesAtOrder, workingPrecision],
    "errorEstimate" -> errors,
    "anchorRules" -> anchorRules,
    "convergenceRatio" -> convergenceRatio,
    "lateTimeExponents" -> lateTimeExponents,
    "leadingBranches" -> leadingBranches,
    "seriesOrder" -> order
  |>
];


(* ::Chapter:: *)
(*任意 sector DAG 的 Frobenius leading system*)

(* full propagator 的 Hankel branches 只由 SK 类型和 strict time rank 决定。 *)
msBoundaryFullBranches["++", firstDominantQ_] := If[firstDominantQ, {1, 2}, {2, 1}];
msBoundaryFullBranches["--", firstDominantQ_] := If[firstDominantQ, {2, 1}, {1, 2}];


msBoundaryComponentRank[sector_Association, componentPosition_Integer, rank_Association] := Min[
  rank /@ sector["vertexComponents"][[componentPosition]]
];


(* 输入一个 endpoint slot，返回初始化后固定或 strict-rank 固定的 Hankel branch。 *)
msBoundaryHankelBranch[
  slot_Association,
  sector_Association,
  rank_Association,
  context_?MSContextQ
] := Module[{line, endpointComponents, firstDominantQ, branches},
  line = msLineById[context, slot["lineId"]];
  Switch[line["type"],
    "massiveExternal",
      First[line["hankelBranches"]],
    "massiveCross",
      line["hankelBranches"][[slot["endpointIndex"]]],
    "massiveFull" | "masslessFull",
      endpointComponents = sector["rootToComponent"] /@ line["endpoints"];
      firstDominantQ = If[
        SameQ @@ endpointComponents,
        True,
        msBoundaryComponentRank[sector, First[endpointComponents], rank] <
          msBoundaryComponentRank[sector, Last[endpointComponents], rank]
      ];
      branches = msBoundaryFullBranches[line["skType"], firstDominantQ];
      branches[[slot["endpointIndex"]]],
    _,
      Missing["NoHankelBranch", slot["key"]]
  ]
];


(* quotient massless slot 在 strict chamber 中是一个固定指数；bit=1 只留下方向符号。 *)
msBoundaryMasslessSharedFactor[
  slot_Association,
  bit_Integer,
  sector_Association,
  rank_Association,
  context_?MSContextQ
] := Module[{line, endpointComponents, firstDominantQ},
  line = msLineById[context, slot["lineId"]];
  endpointComponents = sector["rootToComponent"] /@ line["endpoints"];
  If[SameQ @@ endpointComponents, Return[If[bit === 0, 1, 0]]];
  firstDominantQ = msBoundaryComponentRank[sector, First[endpointComponents], rank] <
    msBoundaryComponentRank[sector, Last[endpointComponents], rank];
  If[bit === 0, 1, If[firstDominantQ, -1, 1]]
];


(* 所有 blow-up 坐标沿同一个 t 射线缩放；t=1 是有限匹配点。 *)
msGenericBoundaryCurveData[
  context_?MSContextQ,
  de_Association,
  targetRules_List,
  scale_,
  rankOrder_List,
  workingPrecision_Integer
] := Module[
  {rank, vertexCount, vertexById, momentumSizes, dampingBase, parameter, curveRules,
   retainedRules, anchorRules, omegaAlongCurve, connection, residue, convergenceRatio},
  rank = msBoundaryRankAssociation[rankOrder];
  vertexCount = Length[rankOrder];
  vertexById = AssociationThread[Lookup[context["vertices"], "id"] -> context["vertices"]];
  momentumSizes = Abs[N[Lookup[context["lines"], "momentum", {}] /. targetRules, workingPrecision]];
  dampingBase = Max[2, Ceiling[N[scale (1 + Total[momentumSizes]), 20]]];
  parameter = Unique["msBoundaryT"];
  curveRules = Table[
    With[{vertex = vertexById[id], weight = vertexCount - rank[id] + 1},
      vertex["energy"] -> -I vertex["phaseSign"] dampingBase^weight parameter^-weight
    ],
    {id, rankOrder}
  ];
  retainedRules = DeleteCases[
    targetRules,
    Rule[left_, _] /; MemberQ[Lookup[context["vertices"], "energy"], left]
  ];
  anchorRules = Join[curveRules /. parameter -> 1, retainedRules];
  omegaAlongCurve = de["omegaPotential"] /. curveRules /. retainedRules;
  connection = Map[Cancel[Together[D[#, parameter]]] &, omegaAlongCurve, {2}];
  If[! FreeQ[connection, _Real],
    Return[Failure[
      "ExactSingularConnectionRequired",
      <|"reason" -> "generic sector pullback must remain exact Q(i)(t)"|>
    ]]
  ];
  residue = Map[Together[Limit[parameter #, parameter -> 0]] &, connection, {2}];
  If[! FreeQ[residue, Indeterminate | ComplexInfinity | DirectedInfinity],
    Return[Failure["RegularSingularPullbackRequired", <|"residue" -> residue|>]]
  ];
  convergenceRatio = If[momentumSizes === {}, 1/dampingBase, (1 + Total[momentumSizes])/dampingBase];
  <|
    "rank" -> rank,
    "dampingBase" -> dampingBase,
    "parameter" -> parameter,
    "curveRules" -> curveRules,
    "retainedRules" -> retainedRules,
    "anchorRules" -> anchorRules,
    "connection" -> connection,
    "residue" -> residue,
    "convergenceRatio" -> convergenceRatio
  |>
];


msBoundaryAncestorSectorKeys[context_?MSContextQ, sectorKey_String] := FixedPoint[
  Function[keys,
    Union[
      keys,
      Lookup[
        Select[context["contactTransitions"], MemberQ[keys, #["targetSector"]] &],
        "sourceSector",
        {}
      ]
    ]
  ],
  {sectorKey}
];


(* 固定 root sector 的单位分量并令非 ancestor sectors 为零，线性解出全部 ancestor 分量。 *)
msBoundaryRootedIndicialVector[
  context_?MSContextQ,
  residue_?MatrixQ,
  exponent_,
  sectorKey_String,
  rootIndex_Integer
] := Module[
  {dimension, identity, matrix, ancestorKeys, allowedIndices, rootIndices, fixedIndices,
   fixedValues, constraints, solution, residual},
  dimension = Length[residue];
  identity = IdentityMatrix[dimension];
  matrix = exponent identity - residue;
  ancestorKeys = msBoundaryAncestorSectorKeys[context, sectorKey];
  allowedIndices = Lookup[
    Select[context["masters"], MemberQ[ancestorKeys, #["sectorKey"]] &],
    "globalIndex"
  ];
  rootIndices = Lookup[Select[context["masters"], #["sectorKey"] === sectorKey &], "globalIndex"];
  fixedIndices = Union[Complement[Range[dimension], allowedIndices], rootIndices];
  fixedValues = If[# === rootIndex, 1, 0] & /@ fixedIndices;
  constraints = UnitVector[dimension, #] & /@ fixedIndices;
  solution = Quiet@Check[
    LinearSolve[
      Join[matrix, constraints],
      Join[ConstantArray[0, dimension], fixedValues]
    ],
    $Failed
  ];
  If[solution === $Failed,
    Return[Failure[
      "SectorLeadingSystemFailed",
      <|"sectorKey" -> sectorKey, "rootIndex" -> rootIndex, "frobeniusExponent" -> exponent|>
    ]]
  ];
  residual = Together[matrix.solution];
  If[
    ! TrueQ[And @@ (PossibleZeroQ /@ residual)] ||
      ! TrueQ[And @@ MapThread[PossibleZeroQ[#1 - #2] &, {solution[[fixedIndices]], fixedValues}]],
    Return[Failure[
      "SectorLeadingSystemResidual",
      <|"sectorKey" -> sectorKey, "rootIndex" -> rootIndex, "residual" -> residual|>
    ]]
  ];
  Together[solution]
];


(* 单个 sector master 的定义积分 leading coefficient；全部数据来自 sector slots/components。 *)
msGenericSectorLeadingRecord[
  context_?MSContextQ,
  sector_Association,
  stateBits_List,
  globalIndex_Integer,
  targetRules_List,
  curveData_Association,
  workingPrecision_Integer
] := Module[
  {rank, parameter, vertexCount, componentRecords, hSlots, timePower, alpha,
   componentRank, weight, energyExpression, energyConstant, endpointFactor, slotBit,
   line, momentum, physicalNu, formulaNu, branch, sharedFactor, redundantNormalization,
   coefficient, exponent, lateTimeExponents},
  rank = curveData["rank"];
  parameter = curveData["parameter"];
  vertexCount = Length[context["vertices"]];
  componentRecords = Table[
    hSlots = msHankelSlotsAtComponent[sector, componentPosition];
    timePower = sector["baseTimePowers"][[componentPosition]] /. targetRules;
    alpha = Simplify[
      timePower + 1 - Total[
        Function[slot,
          slotBit = stateBits[[slot["slotPosition"]]];
          slotBit (2 (slot["formulaNu"] /. targetRules) + 1)
        ] /@ hSlots
      ]
    ];
    componentRank = msBoundaryComponentRank[sector, componentPosition, rank];
    weight = vertexCount - componentRank + 1;
    energyExpression = Together[
      sector["componentEnergies"][[componentPosition]] /.
        curveData["curveRules"] /. curveData["retainedRules"]
    ];
    energyConstant = Together[Limit[parameter^weight energyExpression, parameter -> 0]];
    If[TrueQ[PossibleZeroQ[energyConstant]],
      Return[Failure[
        "VanishingComponentBoundaryEnergy",
        <|"sectorKey" -> sector["sectorKey"], "componentPosition" -> componentPosition|>
      ]]
    ];
    endpointFactor = Times @@ Map[
      Function[slot,
        slotBit = stateBits[[slot["slotPosition"]]];
        line = msLineById[context, slot["lineId"]];
        momentum = line["momentum"] /. targetRules;
        physicalNu = line["nu"] /. targetRules;
        formulaNu = line["formulaNu"] /. targetRules;
        branch = msBoundaryHankelBranch[slot, sector, rank, context];
        (-I momentum)^(-slotBit (2 formulaNu + 1))
          msVertexEndpointCoefficient[
            context["convention", "nuConvention"], branch, slotBit, physicalNu
          ]
      ],
      hSlots
    ];
    <|
      "componentPosition" -> componentPosition,
      "timePower" -> timePower,
      "frobeniusPower" -> alpha,
      "rankWeight" -> weight,
      "energyLeadingConstant" -> energyConstant,
      "coefficient" -> Simplify[
        (-I)^(timePower + 1) Gamma[alpha] endpointFactor
      ],
      "anchorFactor" -> Simplify[energyConstant^-alpha]
    |>,
    {componentPosition, Length[sector["vertexComponents"]]}
  ];
  If[Head[componentRecords] === Failure || MemberQ[componentRecords, _Failure],
    Return[FirstCase[componentRecords, _Failure, componentRecords]]
  ];
  lateTimeExponents = Lookup[componentRecords, "frobeniusPower"];
  If[AnyTrue[lateTimeExponents, ! TrueQ[Re[N[#, workingPrecision]] > 0] &],
    Return[Failure[
      "LateTimeBoundaryNotVanishing",
      <|
        "sectorKey" -> sector["sectorKey"],
        "stateBits" -> stateBits,
        "componentExponents" -> lateTimeExponents
      |>
    ]]
  ];
  sharedFactor = Times @@ MapIndexed[
    Function[{slot, position},
      If[
        slot["kind"] === "masslessShared",
        msBoundaryMasslessSharedFactor[
          slot, stateBits[[First[position]]], sector, rank, context
        ],
        1
      ]
    ],
    sector["slots"]
  ];
  redundantNormalization = (Pi/2)^Count[
    sector["activeLines"],
    line_ /; line["type"] === "masslessFull" && line["masslessRepresentation"] === "RedundantH"
  ];
  coefficient = Simplify[
    (sector["normalization"] /. targetRules)
      sector["boundaryContactPhase"]
      redundantNormalization sharedFactor Times @@ Lookup[componentRecords, "coefficient"]
  ];
  exponent = Simplify[Total[
    Lookup[componentRecords, "rankWeight"] Lookup[componentRecords, "frobeniusPower"]
  ]];
  <|
    "kind" -> "genericSectorDefinitionBranch",
    "sectorKey" -> sector["sectorKey"],
    "binaryState" -> stateBits,
    "rootGlobalIndex" -> globalIndex,
    "componentData" -> componentRecords,
    "frobeniusExponent" -> exponent,
    "logPower" -> 0,
    "coefficient" -> coefficient,
    "physicalWeight" -> Simplify[
      coefficient Times @@ Lookup[componentRecords, "anchorFactor"]
    ]
  |>
];


msGenericSectorFrobeniusData[
  context_?MSContextQ,
  de_Association,
  targetRules_List,
  scale_,
  rankOrder_List,
  order_Integer,
  workingPrecision_Integer
] := Module[
  {curveData, sectorByKey, localRecords, failure, branches, normalizedVector, thetaFixing},
  curveData = msGenericBoundaryCurveData[
    context, de, targetRules, scale, rankOrder, workingPrecision
  ];
  If[Head[curveData] === Failure, Return[curveData]];
  sectorByKey = AssociationThread[context["sectorOrder"] -> context["sectors"]];
  localRecords = Map[
    Function[master,
      msGenericSectorLeadingRecord[
        context,
        sectorByKey[master["sectorKey"]],
        master["stateBits"],
        master["globalIndex"],
        targetRules,
        curveData,
        workingPrecision
      ]
    ],
    context["masters"]
  ];
  failure = FirstCase[localRecords, _Failure, Missing["NoFailure"]];
  If[Head[failure] === Failure, Return[failure]];
  localRecords = Select[localRecords, ! TrueQ[PossibleZeroQ[#["physicalWeight"]]] &];
  branches = Map[
    Function[record,
      normalizedVector = msBoundaryRootedIndicialVector[
        context,
        curveData["residue"],
        record["frobeniusExponent"],
        record["sectorKey"],
        record["rootGlobalIndex"]
      ];
      If[
        Head[normalizedVector] === Failure,
        normalizedVector,
        Join[record, <|"normalizedLeadingVector" -> normalizedVector|>]
      ]
    ],
    localRecords
  ];
  failure = FirstCase[branches, _Failure, Missing["NoFailure"]];
  If[Head[failure] === Failure, Return[failure]];
  thetaFixing = AssociationThread[
    context["sectorOrder"] ->
      (msSectorThetaFixing[#, curveData["rank"]] & /@ context["sectors"])
  ];
  <|
    "boundaryKind" -> "singularFrobenius",
    "anchorRules" -> curveData["anchorRules"],
    "convergenceRatio" -> curveData["convergenceRatio"],
    "leadingBranches" -> branches,
    "seriesOrder" -> order,
    "blowupVariables" -> msBoundaryEnergyChartData[context, rankOrder],
    "singularParameter" -> curveData["parameter"],
    "singularCurveRules" -> curveData["curveRules"],
    "singularConnection" -> curveData["connection"],
    "singularResidue" -> curveData["residue"],
    "singularStart" -> 0,
    "singularTarget" -> 1,
    "thetaFixing" -> thetaFixing,
    "sectorLeadingSystemQ" -> True,
    "genericSectorProducerQ" -> True
  |>
];


(* ::Chapter:: *)
(*公开生产边界*)

MSBoundaryData[
  context_?MSContextQ,
  targetRulesInput_,
  OptionsPattern[]
] := Module[
  {de, targetRules, scale, order, workingPrecision, rankOrder, vertexIds, requiredSymbols,
   unresolved, chartCertificate, seriesData, anchorLetters},
  de = MSDLogDE[context];
  If[Lookup[de, "dlogStatus", None] =!= "certifiedByFormulaChecks",
    Return[Failure["CertifiedDLogRequired", <|"status" -> Lookup[de, "dlogStatus", Missing["Absent"]]|>]]
  ];
  targetRules = msRuleList[targetRulesInput];
  If[targetRules === $Failed, Return[Failure["NumericalRulesRequired", <||>]]];
  requiredSymbols = msBoundaryRequiredSymbols[context];
  unresolved = Select[requiredSymbols, ! NumericQ[N[# /. targetRules]] &];
  If[unresolved =!= {}, Return[Failure["IncompleteNumericalPoint", <|"symbols" -> unresolved|>]]];
  scale = OptionValue[BoundaryScale];
  order = OptionValue[BoundarySeriesOrder];
  workingPrecision = OptionValue[WorkingPrecision];
  If[! NumericQ[scale] || ! TrueQ[N[scale] > 1],
    Return[Failure["BoundaryScaleMustExceedOne", <|"value" -> scale|>]]
  ];
  If[! IntegerQ[order] || order < 0,
    Return[Failure["BoundarySeriesOrderMustBeNonNegative", <|"value" -> order|>]]
  ];
  vertexIds = Lookup[context["vertices"], "id"];
  rankOrder = Replace[OptionValue[RankOrder], Automatic :> msPreferredVertexOrder[context, targetRules]];
  If[Sort[rankOrder] =!= Sort[vertexIds] || ! DuplicateFreeQ[rankOrder],
    Return[Failure["InvalidRankOrder", <|"expected" -> vertexIds, "actual" -> rankOrder|>]]
  ];
  chartCertificate = MSBoundaryChartCertificate[context, targetRules, RankOrder -> rankOrder];
  If[Head[chartCertificate] === Failure || ! TrueQ[chartCertificate["normalCrossingQ"]],
    Return[Failure["BoundaryChartNotCertified", <|"certificate" -> chartCertificate|>]]
  ];
  seriesData = Which[
    Length[context["vertices"]] === 1 && Length[context["sectors"]] === 1 &&
      And @@ (#["type"] === "massiveExternal" & /@ context["lines"]),
      msSingleVertexFrobeniusData[
        context, targetRules, scale, order, workingPrecision
      ],
    True,
      msGenericSectorFrobeniusData[
        context, de, targetRules, scale, rankOrder, order, workingPrecision
      ]
  ];
  If[Head[seriesData] === Failure, Return[seriesData]];
  anchorLetters = N[de["letters"] /. seriesData["anchorRules"], workingPrecision];
  If[AnyTrue[anchorLetters, ! NumericQ[#] || TrueQ[PossibleZeroQ[#]] &],
    Return[Failure[
      "SingularBoundaryAnchor",
      <|"letters" -> anchorLetters, "rules" -> seriesData["anchorRules"]|>
    ]]
  ];
  Join[
  <|
    "status" -> "generated",
    "method" -> If[
      TrueQ[Lookup[seriesData, "sectorLeadingSystemQ", False]],
      "2411GenericSectorLeadingSeries",
      "2411VertexFrobeniusSeries"
    ],
    "masters" -> de["masters"],
    "masterDigest" -> de["masterDigest"],
    "boundaryKind" -> Lookup[seriesData, "boundaryKind", "finiteFrobeniusSeries"],
    "rankOrder" -> rankOrder,
    "boundaryChartCertificate" -> chartCertificate,
    "boundaryScale" -> scale,
    "seriesOrder" -> seriesData["seriesOrder"],
    "convergenceRatio" -> seriesData["convergenceRatio"],
    "lateTimeExponents" -> Lookup[seriesData, "lateTimeExponents", Lookup[seriesData["leadingBranches"], "frobeniusExponent", {}]],
    "leadingBranches" -> seriesData["leadingBranches"],
    "blowupVariables" -> Lookup[seriesData, "blowupVariables", Missing["SingleVariable"]],
    "thetaFixing" -> Lookup[seriesData, "thetaFixing", {}],
    "sectorLeadingSystemQ" -> Lookup[seriesData, "sectorLeadingSystemQ", False],
    "anchorRules" -> seriesData["anchorRules"],
    "targetRules" -> targetRules,
    "anchorLetters" -> anchorLetters,
    "branchConvention" -> "HankelH[1|2] and h prefactor fixed by initialized context",
    "normalizationIncludedQ" -> True,
    "ordinaryAnchorQ" -> Lookup[seriesData, "boundaryKind", "finiteFrobeniusSeries"] === "finiteFrobeniusSeries",
    "directIntegrationFallbackQ" -> False,
    "formulaAuthority" -> If[
      TrueQ[Lookup[seriesData, "sectorLeadingSystemQ", False]],
      "2411.03088 Secs. 3.3 and 4.2; sector-DAG power-log recurrence delegated to FlintNDE",
      "2411.03088 Eqs. (3.44)-(3.46), with endpoint coefficients from Eqs. (3.51)-(3.54)"
    ]
  |>,
  KeyTake[
    seriesData,
    {
      "values", "errorEstimate", "singularParameter", "singularCurveRules",
      "singularConnection", "singularResidue", "singularStart", "singularTarget"
    }
  ]
  ]
];

MSBoundaryData[___] := Failure["InitializedContextRequired", <|"function" -> "MSBoundaryData"|>];
