(* ::Package:: *)

(***
文件：Boundary.wl
用途：从 2411.03088 的 k0->Infinity Frobenius 解生成与 dlog master 顺序一致的生产边界。
当前范围：任意个 massiveExternal h block 的单顶点函数族，以及 n=0 的纯指数顶点。
正确性边界：生产代码不计算有限点定义积分，也不调用 NIntegrate；未覆盖的积分族返回结构化 Failure。
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
(*两顶点单 massive G++ 的奇点 leading system*)

(* 只解 indicial leading vector；完整 power-log 递推由 FlintNDE 的奇点模块负责。 *)
msNormalizedIndicialVector[
  residue_?MatrixQ,
  exponent_,
  fixedIndex_Integer
] := Module[{dimension, identity, zero, constraint, solution, residual},
  dimension = Length[residue];
  identity = IdentityMatrix[dimension];
  zero = ConstantArray[0, dimension];
  constraint = UnitVector[dimension, fixedIndex];
  solution = Quiet@Check[
    LinearSolve[
      Join[exponent identity - residue, {constraint}],
      Join[zero, {1}]
    ],
    $Failed
  ];
  If[solution === $Failed,
    Return[Failure[
      "SectorLeadingSystemFailed",
      <|"frobeniusExponent" -> exponent, "fixedIndex" -> fixedIndex|>
    ]]
  ];
  residual = Together[(exponent identity - residue).solution];
  If[! TrueQ[And @@ (PossibleZeroQ /@ residual)] || ! TrueQ[PossibleZeroQ[solution[[fixedIndex]] - 1]],
    Return[Failure[
      "SectorLeadingSystemResidual",
      <|"frobeniusExponent" -> exponent, "fixedIndex" -> fixedIndex, "residual" -> residual|>
    ]]
  ];
  Together[solution]
];


msSingleVertexLeadingCoefficient[
  timePower_,
  physicalNu_,
  formulaNu_,
  momentum_,
  branch_Integer,
  bit_Integer,
  nuConvention_String
] := (-I)^(timePower + 1) *
  Gamma[timePower + 1 - bit (2 formulaNu + 1)] *
  (-I momentum)^(-bit (2 formulaNu + 1)) *
  msVertexEndpointCoefficient[nuConvention, branch, bit, physicalNu];


msTwoVertexMassiveFullQ[context_?MSContextQ] := Module[{lines = context["lines"]},
  Length[context["vertices"]] === 2 &&
    Length[lines] === 1 &&
    First[lines]["type"] === "massiveFull" &&
    First[lines]["skType"] === "++" &&
    Length[context["sectors"]] === 2 &&
    Length[context["masters"]] === 5
];


msTwoVertexFrobeniusData[
  context_?MSContextQ,
  de_Association,
  targetRules_List,
  scale_,
  rankOrder_List,
  order_Integer,
  workingPrecision_Integer
] := Module[
  {topSector, childSector, line, vertexById, highVertex, lowVertex, highPosition, lowPosition,
   highEnergy, lowEnergy, highPower, lowPower, physicalNu, formulaNu, momentum,
   nuConvention, endpointRanks, endpointBranches, topStateOrder, branchRecords,
    childPower, childCoefficient, dimension, childIndex,
   dampingLow, dampingHigh, anchorRules, xValue, yValue, parameter, curveRules,
   omegaAlongCurve, connection, residue, identity, zero, leadingVector, normalizedVector,
   branches, lambda, mu, exponent, highBit, lowBit, coefficient, convergenceRatio,
   topResiduals},
  topSector = First[context["sectors"]];
  childSector = Last[context["sectors"]];
  line = First[context["lines"]];
  vertexById = AssociationThread[Lookup[context["vertices"], "id"] -> context["vertices"]];
  highVertex = First[rankOrder];
  lowVertex = Last[rankOrder];
  highPosition = First@FirstPosition[line["endpoints"], highVertex];
  lowPosition = First@FirstPosition[line["endpoints"], lowVertex];
  highEnergy = vertexById[highVertex]["energy"];
  lowEnergy = vertexById[lowVertex]["energy"];
  If[! MatchQ[highEnergy, _Symbol] || ! MatchQ[lowEnergy, _Symbol],
    Return[Failure[
      "AsymptoticBoundaryEnergyCoordinateRequired",
      <|"energies" -> {highEnergy, lowEnergy}|>
    ]]
  ];
  highPower = vertexById[highVertex]["timePower"] /. targetRules;
  lowPower = vertexById[lowVertex]["timePower"] /. targetRules;
  physicalNu = line["nu"] /. targetRules;
  formulaNu = line["formulaNu"] /. targetRules;
  momentum = line["momentum"] /. targetRules;
  nuConvention = context["convention", "nuConvention"];
  If[! And @@ (TrueQ[PossibleZeroQ[Im[N[#, workingPrecision]]]] & /@
      {highPower, lowPower, physicalNu, formulaNu, momentum}),
    Return[Failure[
      "AsymptoticBoundaryComplexNuUnsupported",
      <|"reason" -> "two-vertex leading system is currently certified for real parameters"|>
    ]]
  ];
  endpointRanks = AssociationThread[rankOrder -> Range[2]];
  endpointBranches = If[
    endpointRanks[line["endpoints"][[1]]] < endpointRanks[line["endpoints"][[2]]],
    {1, 2},
    {2, 1}
  ];
  topStateOrder = topSector["stateOrder"];
  branchRecords = MapIndexed[
    Function[{bits, position},
      highBit = bits[[highPosition]];
      lowBit = bits[[lowPosition]];
      lambda = highPower + 1 - highBit (2 formulaNu + 1);
      mu = lambda + lowPower + 1 - lowBit (2 formulaNu + 1);
      coefficient =
        msSingleVertexLeadingCoefficient[
          highPower, physicalNu, formulaNu, momentum,
          endpointBranches[[highPosition]], highBit, nuConvention
        ]
        msSingleVertexLeadingCoefficient[
          lowPower, physicalNu, formulaNu, momentum,
          endpointBranches[[lowPosition]], lowBit, nuConvention
        ];
      <|
        "kind" -> "homogeneousProduct",
        "binaryState" -> bits,
        "topPosition" -> First[position],
        "lambda" -> lambda,
        "mu" -> mu,
        "coefficient" -> coefficient
      |>
    ],
    topStateOrder
  ];
  childPower = First[childSector["baseTimePowers"]] /. targetRules;
  If[! TrueQ[PossibleZeroQ[highPower - lowPower]],
    Return[Failure[
      "TwoVertexUnequalTimePowersUnsupported",
      <|
        "highTimePower" -> highPower,
        "lowTimePower" -> lowPower,
        "reason" -> "2411.03088 Eq. (4.11) is certified here only for equal vertex time powers"
      |>
    ]]
  ];
  (* 2411.03088 Eq. (4.11)。正 prefactor context 只通过 formulaNu=-|nu|
     复用论文公式，避免从 child normalization 再猜一次 Wick/branch 相位。 *)
  childCoefficient = Simplify[
    -(4 I/Pi) Exp[Pi Im[formulaNu]] momentum^(-2 formulaNu - 1)
      Exp[I Pi (formulaNu - highPower)] Gamma[childPower + 1]
  ];
  If[AnyTrue[
      Join[Lookup[branchRecords, "lambda"], Lookup[branchRecords, "mu"], {childPower + 1}],
      ! TrueQ[Re[N[#, workingPrecision]] > 0] &
    ],
    Return[Failure[
      "LateTimeBoundaryNotVanishing",
      <|"branchWeights" -> Lookup[branchRecords, {"lambda", "mu"}], "childWeight" -> childPower + 1|>
    ]]
  ];
  dampingLow = Max[2, Ceiling[N[scale (1 + Abs[momentum]), 20]]];
  dampingHigh = Max[dampingLow + 1, Ceiling[N[scale dampingLow, 20]]];
  anchorRules = Join[
    {highEnergy -> -I vertexById[highVertex]["phaseSign"] dampingHigh,
     lowEnergy -> -I vertexById[lowVertex]["phaseSign"] dampingLow},
    DeleteCases[targetRules, Rule[left_, _] /; MemberQ[{highEnergy, lowEnergy}, left]]
  ];
  xValue = (lowEnergy/highEnergy) /. anchorRules;
  yValue = (1/lowEnergy) /. anchorRules;
  convergenceRatio = Abs[N[momentum yValue, workingPrecision]] + Abs[N[xValue, workingPrecision]];
  If[! TrueQ[convergenceRatio < 1],
    Return[Failure[
      "FrobeniusAnchorOutsideConvergenceDomain",
      <|"ratioBound" -> convergenceRatio, "required" -> "Abs[x]+Abs[ks y]<1"|>
    ]]
  ];
  parameter = Unique["msBoundaryT"];
  curveRules = {
    highEnergy -> 1/(xValue yValue parameter^2),
    lowEnergy -> 1/(yValue parameter)
  };
  omegaAlongCurve = de["omegaPotential"] /. curveRules /.
    DeleteCases[targetRules, Rule[left_, _] /; MemberQ[{highEnergy, lowEnergy}, left]];
  connection = Map[Cancel[Together[D[#, parameter]]] &, omegaAlongCurve, {2}];
  If[! FreeQ[connection, _Real],
    Return[Failure[
      "ExactSingularConnectionRequired",
      <|"reason" -> "the pulled-back connection must remain exact Q(i)(t)"|>
    ]]
  ];
  dimension = de["masterCount"];
  identity = IdentityMatrix[dimension];
  zero = ConstantArray[0, dimension];
  residue = Map[Together[Limit[parameter #, parameter -> 0]] &, connection, {2}];
  If[! FreeQ[residue, Indeterminate | ComplexInfinity | DirectedInfinity],
    Return[Failure[
      "RegularSingularPullbackRequired",
      <|"residue" -> residue|>
    ]]
  ];
  branches = Map[
    Function[record,
      leadingVector = zero;
      leadingVector[[record["topPosition"]]] = 1;
      exponent = Together[record["lambda"] + record["mu"]];
      Join[
        record,
        <|
          "frobeniusExponent" -> exponent,
          "logPower" -> 0,
          "normalizedLeadingVector" -> leadingVector,
          "physicalWeight" -> record["coefficient"] xValue^record["lambda"] yValue^record["mu"]
        |>
      ]
    ],
    branchRecords
  ];
  topResiduals = Map[
    Together[(#["frobeniusExponent"] identity - residue).#["normalizedLeadingVector"]] &,
    branches
  ];
  If[! And @@ Flatten[Map[PossibleZeroQ, topResiduals, {2}]],
    Return[Failure[
      "FrobeniusLeadingVectorMismatch",
      <|"residuals" -> topResiduals|>
    ]]
  ];
  childIndex = Last[Lookup[de["masters"], "globalIndex"]];
  exponent = Together[2 (childPower + 1)];
  normalizedVector = msNormalizedIndicialVector[
    residue, exponent, childIndex
  ];
  If[Head[normalizedVector] === Failure, Return[normalizedVector]];
  branches = Append[
    branches,
    <|
      "kind" -> "contactSectorParticular",
      "binaryState" -> Missing["ChildSector"],
      "topPosition" -> childIndex,
      "lambda" -> childPower + 1,
      "mu" -> childPower + 1,
      "coefficient" -> childCoefficient,
      "frobeniusExponent" -> exponent,
      "logPower" -> 0,
      "normalizedLeadingVector" -> normalizedVector,
      "leadingVector" -> Together[childCoefficient normalizedVector],
      "physicalWeight" -> childCoefficient xValue^(childPower + 1) yValue^(childPower + 1)
    |>
  ];
  <|
    "boundaryKind" -> "singularFrobenius",
    "anchorRules" -> anchorRules,
    "convergenceRatio" -> convergenceRatio,
    "leadingBranches" -> branches,
    "seriesOrder" -> order,
    "blowupVariables" -> <|"x" -> lowEnergy/highEnergy, "y" -> 1/lowEnergy|>,
    "singularParameter" -> parameter,
    "singularCurveRules" -> curveRules,
    "singularConnection" -> connection,
    "singularResidue" -> residue,
    "singularStart" -> 0,
    "singularTarget" -> 1,
    "thetaFixing" -> endpointBranches,
    "sectorLeadingSystemQ" -> True
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
    Length[context["vertices"]] === 1 && Length[context["sectors"]] === 1,
      msSingleVertexFrobeniusData[
        context, targetRules, scale, order, workingPrecision
      ],
    msTwoVertexMassiveFullQ[context],
      msTwoVertexFrobeniusData[
        context, de, targetRules, scale, rankOrder, order, workingPrecision
      ],
    True,
      Failure[
        "AsymptoticBoundaryFamilyUnsupported",
        <|
          "supportedFamilies" -> {"singleVertexMassiveExternal", "twoVertexSingleMassiveG++"},
          "vertexCount" -> Length[context["vertices"]],
          "sectorCount" -> Length[context["sectors"]],
          "fallbackUsedQ" -> False
        |>
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
      "2411TwoVertexSectorLeadingSeries",
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
      "2411.03088 Eqs. (4.5)-(4.14); power-log recurrence delegated to FlintNDE",
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
