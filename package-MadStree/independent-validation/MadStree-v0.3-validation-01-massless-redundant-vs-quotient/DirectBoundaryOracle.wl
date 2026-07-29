(* ::Package:: *)

(***
文件：DirectBoundaryOracle.wl
用途：在 T1 验证目录内按定义时间积分计算 quotient 或 RedundantH context 的同序 master 向量。
边界：本文件不属于 MadStree Kernel；只为独立验证提供普通点 anchor/target oracle，生产边界不得调用。
正规化：RedundantH massless endpoint 乘积固定乘 Pi/2，使 h 四态采用任务书的 quotient-compatible normalization。
***)

BeginPackage["MadStreeT1Test`DirectBoundaryOracle`"];

MSDirectBoundaryOracle::usage =
  "MSDirectBoundaryOracle[context,rules] 仅供 T1，按定义积分返回与 context masters 同序的数值向量。";
MSDirectSectorOracle::usage =
  "MSDirectSectorOracle[context,sectorKey,rules] 仅供 T1，按定义积分返回指定 sector 的同序数值向量。";

Begin["`Private`"];


(* ::Chapter:: *)
(*局部 Hankel 与 massless building blocks*)

msOracleHankel[1, nu_, z_] := HankelH1[nu, z];
msOracleHankel[2, nu_, z_] := HankelH2[nu, z];


msOracleHState[0, branch_Integer, nu_, power_, z_] := z^power msOracleHankel[branch, nu, z];
msOracleHState[1, branch_Integer, nu_, power_, z_] :=
  power z^(power - 1) msOracleHankel[branch, nu, z] +
    z^power (msOracleHankel[branch, nu - 1, z] - msOracleHankel[branch, nu + 1, z])/2;

(* nu=1/2、正 prefactor 的精确闭式，避免数值积分采样点反复调用 HankelH。 *)
msOracleHState[0, 1, 1/2, 1/2, z_] := -I Sqrt[2/Pi] Exp[I z];
msOracleHState[0, 2, 1/2, 1/2, z_] := I Sqrt[2/Pi] Exp[-I z];
msOracleHState[1, 1, 1/2, 1/2, z_] := Sqrt[2/Pi] Exp[I z];
msOracleHState[1, 2, 1/2, 1/2, z_] := Sqrt[2/Pi] Exp[-I z];


msOracleFullBranches["++", firstEarlierQ_] := If[firstEarlierQ, {1, 2}, {2, 1}];
msOracleFullBranches["--", firstEarlierQ_] := If[firstEarlierQ, {2, 1}, {1, 2}];


msOracleMasslessShared[state_, sigma_, momentum_, timeU_, timeV_, firstEarlierQ_] := Module[
  {delta = timeV - timeU, phase},
  If[firstEarlierQ,
    phase = Exp[-I sigma momentum delta];
    If[state === 0, phase, -phase],
    phase = Exp[I sigma momentum delta];
    phase
  ]
];


(* ::Section:: *)
(*纯 massless child sector 的解析 chamber 积分*)

msOrderedPowerExponential[a_, b_, lambdaA_, lambdaB_] := Module[{weight = a + b + 2},
  Gamma[weight] lambdaB^(-weight) Hypergeometric2F1[
    weight, a + 1, a + 2, -lambdaA/lambdaB
  ]/(a + 1)
];


msMasslessHChamberCoefficient[{a_, b_}, True] := {{1, -I}, {I, 1}}[[a + 1, b + 1]];
msMasslessHChamberCoefficient[{a_, b_}, False] := {{1, I}, {-I, 1}}[[a + 1, b + 1]];


msOraclePureMasslessSectorValues[
  masters_List,
  sector_Association,
  line_Association,
  numericalRules_List,
  workingPrecision_Integer
] := Module[
  {endpointComponents, firstComponent, secondComponent, powers, energies, momentum, sigma,
   lambdaFirstEarly, lambdaSecondEarly, lambdaFirstLate, lambdaSecondLate, normalization,
   keys, sharedPosition, endpointPositions, coefficientEarly, coefficientLate, bits},
  endpointComponents = sector["rootToComponent"] /@ line["endpoints"];
  {firstComponent, secondComponent} = endpointComponents;
  powers = sector["baseTimePowers"] /. numericalRules;
  energies = sector["componentEnergies"] /. numericalRules;
  momentum = line["momentum"] /. numericalRules;
  sigma = line["sigma"];
  normalization = sector["normalization"] /. numericalRules;
  lambdaFirstEarly = I energies[[firstComponent]] - I sigma momentum;
  lambdaSecondEarly = I energies[[secondComponent]] + I sigma momentum;
  lambdaFirstLate = I energies[[firstComponent]] + I sigma momentum;
  lambdaSecondLate = I energies[[secondComponent]] - I sigma momentum;
  keys = Lookup[sector["slots"], "key", {}];
  sharedPosition = FirstPosition[keys, {line["id"], "shared"}, Missing["NotShared"]];
  endpointPositions = FirstPosition[keys, {line["id"], #}, Missing["NotEndpoint"]] & /@ {1, 2};
  N[Map[
    Function[master,
      bits = master["stateBits"];
      If[Head[sharedPosition] =!= Missing,
        coefficientEarly = If[bits[[First[sharedPosition]]] === 0, 1, -1];
        coefficientLate = 1,
        coefficientEarly = msMasslessHChamberCoefficient[bits[[First /@ endpointPositions]], True];
        coefficientLate = msMasslessHChamberCoefficient[bits[[First /@ endpointPositions]], False]
      ];
      normalization (
        coefficientEarly msOrderedPowerExponential[
          powers[[firstComponent]], powers[[secondComponent]],
          lambdaFirstEarly, lambdaSecondEarly
        ] +
        coefficientLate msOrderedPowerExponential[
          powers[[secondComponent]], powers[[firstComponent]],
          lambdaSecondLate, lambdaFirstLate
        ]
      )
    ],
    masters
  ], workingPrecision]
];


(* ::Chapter:: *)
(*单个 master 的定义积分*)

msOracleIntegrand[
  master_Association,
  sector_Association,
  componentTimes_List,
  permutation_List,
  numericalRules_List
] := Module[
  {bitsByKey, orderPosition, factor, endpointComponents, endpointTimes, endpointStates,
   branches, firstEarlierQ, slotState, zValues},
  bitsByKey = AssociationThread[Lookup[sector["slots"], "key"] -> master["stateBits"]];
  orderPosition = AssociationThread[permutation -> Range[Length[permutation]]];
  factor = sector["normalization"] Times @@ MapThread[
    #1^#2 Exp[-I #3 #1] &,
    {componentTimes, sector["baseTimePowers"], sector["componentEnergies"]}
  ];
  Do[
    Switch[line["type"],
      "massiveFull" | "massiveCross",
        endpointComponents = sector["rootToComponent"] /@ line["endpoints"];
        endpointTimes = componentTimes[[endpointComponents]];
        endpointStates = Table[bitsByKey[{line["id"], endpointIndex}], {endpointIndex, 2}];
        firstEarlierQ = orderPosition[endpointComponents[[1]]] < orderPosition[endpointComponents[[2]]];
        branches = If[
          line["type"] === "massiveFull",
          msOracleFullBranches[line["skType"], firstEarlierQ],
          line["hankelBranches"]
        ];
        zValues = (line["momentum"] /. numericalRules) endpointTimes;
        factor *= Times @@ Table[
          msOracleHState[
            endpointStates[[endpointIndex]], branches[[endpointIndex]],
            line["nu"] /. numericalRules, line["hPrefactorPower"] /. numericalRules,
            zValues[[endpointIndex]]
          ],
          {endpointIndex, 2}
        ],

      "massiveExternal",
        endpointComponents = {sector["rootToComponent"][First[line["endpoints"]]]};
        endpointStates = {bitsByKey[{line["id"], 1}]};
        factor *= msOracleHState[
          First[endpointStates], First[line["hankelBranches"]], line["nu"] /. numericalRules,
          line["hPrefactorPower"] /. numericalRules,
          (line["momentum"] /. numericalRules) componentTimes[[First[endpointComponents]]]
        ],

      "masslessFull",
        endpointComponents = sector["rootToComponent"] /@ line["endpoints"];
        endpointTimes = componentTimes[[endpointComponents]];
        firstEarlierQ = orderPosition[endpointComponents[[1]]] < orderPosition[endpointComponents[[2]]];
        If[line["masslessRepresentation"] === "RedundantH",
          endpointStates = Table[bitsByKey[{line["id"], endpointIndex}], {endpointIndex, 2}];
          branches = msOracleFullBranches[line["skType"], firstEarlierQ];
          zValues = (line["momentum"] /. numericalRules) endpointTimes;
          factor *= (Pi/2) Times @@ Table[
            msOracleHState[
              endpointStates[[endpointIndex]], branches[[endpointIndex]],
              line["nu"] /. numericalRules, line["hPrefactorPower"] /. numericalRules,
              zValues[[endpointIndex]]
            ],
            {endpointIndex, 2}
          ],
          slotState = bitsByKey[{line["id"], "shared"}];
          factor *= msOracleMasslessShared[
            slotState, line["sigma"], line["momentum"] /. numericalRules,
            endpointTimes[[1]], endpointTimes[[2]], firstEarlierQ
          ]
        ],

      _, Null
    ],
    {line, sector["activeLines"]}
  ];
  factor /. numericalRules
];


Options[msOracleMasterValue] = {
  WorkingPrecision -> 50,
  AccuracyGoal -> 25,
  PrecisionGoal -> 25,
  MaxRecursion -> 12
};

msOracleMasterValue[
  master_Association,
  sector_Association,
  numericalRules_List,
  OptionsPattern[]
] := Module[
  {componentCount, permutations, increments, orderedTimes, componentTimes, integrand, ranges, values},
  componentCount = Length[sector["vertexComponents"]];
  permutations = Permutations[Range[componentCount]];
  values = Map[
    Function[permutation,
      increments = Array[Unique["msOracleIncrement"] &, componentCount];
      orderedTimes = Accumulate[increments];
      componentTimes = ConstantArray[0, componentCount];
      Do[
        componentTimes[[permutation[[position]]]] = orderedTimes[[position]],
        {position, componentCount}
      ];
      integrand = msOracleIntegrand[master, sector, componentTimes, permutation, numericalRules];
      ranges = ({#, 0, Infinity} & /@ increments);
      Check[
        NIntegrate[
          Evaluate[integrand],
          Evaluate[Sequence @@ ranges],
          WorkingPrecision -> OptionValue[WorkingPrecision],
          AccuracyGoal -> OptionValue[AccuracyGoal],
          PrecisionGoal -> OptionValue[PrecisionGoal],
          MaxRecursion -> OptionValue[MaxRecursion],
          Method -> {"GlobalAdaptive", "SymbolicProcessing" -> 0}
        ],
        $Failed
      ]
    ],
    permutations
  ];
  If[MemberQ[values, $Failed], $Failed, Total[values]]
];


(* 同一 sector 的状态 integrands 共享 chamber 和自适应采样，避免逐 master 重复三维积分。 *)
msOracleSectorValues[
  masters_List,
  sector_Association,
  numericalRules_List,
  OptionsPattern[msOracleMasterValue]
] := Module[
  {componentCount, permutations, increments, orderedTimes, componentTimes, integrands, ranges, chamberValues},
  componentCount = Length[sector["vertexComponents"]];
  permutations = Permutations[Range[componentCount]];
  chamberValues = Map[
    Function[permutation,
      increments = Array[Unique["msOracleIncrement"] &, componentCount];
      orderedTimes = Accumulate[increments];
      componentTimes = ConstantArray[0, componentCount];
      Do[
        componentTimes[[permutation[[position]]]] = orderedTimes[[position]],
        {position, componentCount}
      ];
      integrands = msOracleIntegrand[#, sector, componentTimes, permutation, numericalRules] & /@ masters;
      ranges = ({#, 0, Infinity} & /@ increments);
      Check[
        NIntegrate[
          Evaluate[integrands],
          Evaluate[Sequence @@ ranges],
          WorkingPrecision -> OptionValue[WorkingPrecision],
          AccuracyGoal -> OptionValue[AccuracyGoal],
          PrecisionGoal -> OptionValue[PrecisionGoal],
          MaxRecursion -> OptionValue[MaxRecursion],
          Method -> {"GlobalAdaptive", "SymbolicProcessing" -> 0}
        ],
        $Failed
      ]
    ],
    permutations
  ];
  If[MemberQ[chamberValues, $Failed], $Failed, Total[chamberValues]]
];


(* ::Chapter:: *)
(*测试公开入口*)

Options[MSDirectBoundaryOracle] = Options[msOracleMasterValue];
Options[MSDirectSectorOracle] = Options[msOracleMasterValue];

MSDirectSectorOracle[
  context_Association,
  sectorKey_String,
  numericalRules_List,
  opts : OptionsPattern[]
] := Module[{sector, masters, values},
  sector = SelectFirst[context["sectors"], #["sectorKey"] === sectorKey &, Missing["UnknownSector"]];
  If[Head[sector] === Missing, Return[Failure["UnknownSector", <|"sectorKey" -> sectorKey|>]]];
  masters = Select[context["masters"], #["sectorKey"] === sectorKey &];
  values = If[
    Length[sector["activeLines"]] === 1 && First[sector["activeLines"]]["type"] === "masslessFull" &&
      Length[sector["vertexComponents"]] === 2,
    msOraclePureMasslessSectorValues[
      masters, sector, First[sector["activeLines"]], numericalRules, OptionValue[WorkingPrecision]
    ],
    msOracleSectorValues[
      masters, sector, numericalRules,
      Sequence @@ FilterRules[{opts}, Options[msOracleMasterValue]]
    ]
  ];
  If[values === $Failed,
    Failure["DirectSectorOracleFailed", <|"sectorKey" -> sectorKey|>],
    <|
      "status" -> "computed", "method" -> If[
        Length[sector["activeLines"]] === 1 && First[sector["activeLines"]]["type"] === "masslessFull",
        "testOnlyAnalyticTimeOrderChambers", "testOnlyDefiningTimeIntegral"
      ],
      "sectorKey" -> sectorKey, "normalization" -> "RedundantH uses Pi/2 per active massless line",
      "masters" -> masters, "values" -> values, "productionBoundaryQ" -> False
    |>
  ]
];

MSDirectSectorOracle[___] := Failure["DirectSectorOracleInput", <||>];

MSDirectBoundaryOracle[
  context_Association,
  numericalRules_List,
  opts : OptionsPattern[]
] := Module[{sectorByKey, values},
  sectorByKey = AssociationThread[context["sectorOrder"] -> context["sectors"]];
  values = Flatten@Map[
    Function[sectorKey,
      msOracleSectorValues[
        Select[context["masters"], #["sectorKey"] === sectorKey &],
        sectorByKey[sectorKey],
        numericalRules,
        Sequence @@ FilterRules[{opts}, Options[msOracleMasterValue]]
      ]
    ],
    context["sectorOrder"]
  ];
  If[MemberQ[values, $Failed],
    Failure["DirectBoundaryOracleFailed", <|"values" -> values|>],
    <|
      "status" -> "computed",
      "method" -> "testOnlyDefiningTimeIntegral",
      "normalization" -> "RedundantH uses Pi/2 per active massless line",
      "masters" -> context["masters"],
      "masterDigest" -> context["masterDigest"],
      "values" -> values,
      "productionBoundaryQ" -> False
    |>
  ]
];

MSDirectBoundaryOracle[___] := Failure["DirectBoundaryOracleInput", <||>];

End[];
EndPackage[];
