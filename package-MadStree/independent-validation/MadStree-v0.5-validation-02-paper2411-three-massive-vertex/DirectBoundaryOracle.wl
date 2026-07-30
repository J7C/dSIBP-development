(* ::Package:: *)

(***
文件：DirectBoundaryOracle.wl
用途：在测试目录内按定义积分独立计算 MadStree master 向量，用于和 Frobenius 边界路线交叉验证。
边界：本文件不是 MadStree Kernel 的组成部分；生产入口不得加载或调用这里的函数。
方法：逐 time-order chamber 改用正增量变量，再以 NIntegrate 计算每个 sector 的完整定义积分。
***)

BeginPackage["MadStreeTest`DirectBoundaryOracle`"];

MSDirectBoundaryOracle::usage =
  "MSDirectBoundaryOracle[context,rules] 仅供测试，按定义积分返回与 context masters 同序的数值向量。";

Begin["`Private`"];


(* ::Chapter:: *)
(*局部 building blocks*)

msOracleHankel[1, nu_, z_] := HankelH1[nu, z];
msOracleHankel[2, nu_, z_] := HankelH2[nu, z];


msOracleHState[0, branch_Integer, nu_, power_, z_] := z^power msOracleHankel[branch, nu, z];
msOracleHState[1, branch_Integer, nu_, power_, z_] :=
  power z^(power - 1) msOracleHankel[branch, nu, z] +
    z^power (msOracleHankel[branch, nu - 1, z] - msOracleHankel[branch, nu + 1, z])/2;


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
        slotState = bitsByKey[{line["id"], "shared"}];
        factor *= msOracleMasslessShared[
          slotState, line["sigma"], line["momentum"] /. numericalRules,
          endpointTimes[[1]], endpointTimes[[2]], firstEarlierQ
        ],

      _, Null
    ],
    {line, sector["activeLines"]}
  ];
  factor /. numericalRules
];


Options[msOracleMasterValue] = {
  WorkingPrecision -> 50,
  AccuracyGoal -> 30,
  PrecisionGoal -> 30,
  MaxRecursion -> 18
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
      integrand = msOracleIntegrand[
        master, sector, componentTimes, permutation, numericalRules
      ];
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


(* ::Chapter:: *)
(*测试公开入口*)

Options[MSDirectBoundaryOracle] = Options[msOracleMasterValue];

MSDirectBoundaryOracle[
  context_Association,
  numericalRules_List,
  opts : OptionsPattern[]
] := Module[{sectorByKey, values},
  sectorByKey = AssociationThread[context["sectorOrder"] -> context["sectors"]];
  values = Map[
    msOracleMasterValue[
      #,
      sectorByKey[#["sectorKey"]],
      numericalRules,
      Sequence @@ FilterRules[{opts}, Options[msOracleMasterValue]]
    ] &,
    context["masters"]
  ];
  If[MemberQ[values, $Failed],
    Failure["DirectBoundaryOracleFailed", <|"values" -> values|>],
    <|
      "status" -> "computed",
      "method" -> "testOnlyDefiningTimeIntegral",
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
