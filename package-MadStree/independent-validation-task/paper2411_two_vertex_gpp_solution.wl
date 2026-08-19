(* ::Package:: *)

(***
文件：paper2411_two_vertex_gpp_solution.wl
用途：在论文级数收敛域内独立求值 2411.03088 Sec. 4 两顶点 massive G++ 的五维物理解。
来源：Eqs. (3.14), (3.16), (4.8), (4.10), (4.11)；公式经本地论文 PDF 页面逐项核对。
边界：仅供独立验证，不属于 MadStree Kernel，不允许被生产程序包加载或公开。
接口：Get 后调用 Paper2411TwoVertexGppValue[rules,cutoff,WorkingPrecision->digits]。
***)

(* ::Chapter:: *)
(*一顶点齐次解与边界系数*)

ClearAll[
  paper2411EndpointCoefficient,
  paper2411OneVertexSolutions,
  paper2411OneVertexValue,
  paper2411ParticularSolution,
  Paper2411TwoVertexGppValue
];

paper2411EndpointCoefficient[1, 0, order_] :=
  Exp[-I Pi order] 2^(-order) Gamma[-order]/(I Pi);
paper2411EndpointCoefficient[1, 1, order_] :=
  -2^(order + 1) Gamma[order + 1]/(I Pi);
paper2411EndpointCoefficient[2, 0, order_] :=
  -Exp[I Pi order] 2^(-order) Gamma[-order]/(I Pi);
paper2411EndpointCoefficient[2, 1, order_] :=
  2^(order + 1) Gamma[order + 1]/(I Pi);

paper2411OneVertexSolutions[energy_, momentum_, power_, order_] := Module[
  {inverseEnergy = 1/energy, argument},
  argument = momentum^2 inverseEnergy^2;
  {
    {
      inverseEnergy^(power + 1) Hypergeometric2F1[
        (power + 1)/2, (power + 2)/2, order + 1, argument
      ],
      inverseEnergy^(power + 1) I momentum (power + 1) inverseEnergy/(2 (order + 1))
        Hypergeometric2F1[(power + 2)/2, (power + 3)/2, order + 2, argument]
    },
    {
      inverseEnergy^(power - 2 order) I momentum (power - 2 order) inverseEnergy/(2 order)
        Hypergeometric2F1[
          (power - 2 order + 1)/2, (power - 2 order + 2)/2,
          1 - order, argument
        ],
      inverseEnergy^(power - 2 order) Hypergeometric2F1[
        (power - 2 order)/2, (power - 2 order + 1)/2,
        -order, argument
      ]
    }
  }
];

paper2411OneVertexValue[branch_, energy_, momentum_, power_, order_] := Module[
  {solutions, coefficients},
  solutions = paper2411OneVertexSolutions[energy, momentum, power, order];
  coefficients = {
    (-I)^(power + 1) Gamma[power + 1]
      paper2411EndpointCoefficient[branch, 0, order],
    (-I)^(power + 1) Gamma[power - 2 order]
      (-I momentum)^(-2 order - 1)
      paper2411EndpointCoefficient[branch, 1, order]
  };
  coefficients . solutions
];


(* ::Chapter:: *)
(*Eq. (4.10) 非齐次五维解*)

paper2411ParticularSolution[x_, y_, momentum_, power_, order_, cutoff_Integer] := Module[
  {contactPower = 2 power - 2 order + 1, common, argument, sum},
  common = x^contactPower y^contactPower;
  argument = momentum^2 x^2 y^2;
  sum[component_Integer] := Total@Table[
    Switch[component,
      1,
      -I momentum x y (-x)^m Pochhammer[contactPower, m + 1]/
        (Factorial[m] (power + m + 1) (power - 2 order + m + 1))
        HypergeometricPFQ[
          {power - order + (m + 2)/2, power - order + (m + 3)/2, 1},
          {(power + m + 3)/2, (power - 2 order + m + 3)/2},
          argument
        ],
      2,
      -(-x)^m Pochhammer[contactPower, m]/
        (Factorial[m] (power - 2 order + m))
        HypergeometricPFQ[
          {power - order + (m + 1)/2, power - order + (m + 2)/2, 1},
          {(power + m + 2)/2, (power - 2 order + m + 2)/2},
          argument
        ],
      3,
      (-x)^m Pochhammer[contactPower, m]/
        (Factorial[m] (power + m + 1))
        HypergeometricPFQ[
          {power - order + (m + 1)/2, power - order + (m + 2)/2, 1},
          {(power + m + 3)/2, (power - 2 order + m + 1)/2},
          argument
        ],
      4,
      -I momentum x y (-x)^m Pochhammer[contactPower, m + 1]/
        (Factorial[m] (power + m + 2) (power - 2 order + m))
        HypergeometricPFQ[
          {power - order + (m + 2)/2, power - order + (m + 3)/2, 1},
          {(power + m + 4)/2, (power - 2 order + m + 2)/2},
          argument
        ]
    ],
    {m, 0, cutoff}
  ];
  common Join[Table[sum[component], {component, 4}], {(1 + x)^(-contactPower)}]
];


(* ::Chapter:: *)
(*独立验证公开入口*)

Options[Paper2411TwoVertexGppValue] = {WorkingPrecision -> 100};

Paper2411TwoVertexGppValue[
  rules_List,
  cutoff_Integer?NonNegative,
  OptionsPattern[]
] := Module[
  {digits, k12Value, k34Value, momentumValue, powerValue, orderValue,
   xValue, yValue, convergenceData, homogeneous, particular, contactCoefficient},
  digits = OptionValue[WorkingPrecision];
  {k12Value, k34Value, momentumValue, powerValue, orderValue} = N[
    {k12, k34, ks, nu0, nu1} /. rules,
    digits
  ];
  xValue = k34Value/k12Value;
  yValue = 1/k34Value;
  convergenceData = <|
    "x" -> xValue,
    "y" -> yValue,
    "oneVertexRatios" -> {Abs[momentumValue/k12Value], Abs[momentumValue/k34Value]},
    "particularArguments" -> {
      Abs[momentumValue^2 xValue yValue/4],
      Abs[momentumValue^2 xValue^2 yValue^2/4],
      Abs[momentumValue^2 xValue^2 yValue/4]
    }
  |>;
  If[! And @@ Thread[convergenceData["oneVertexRatios"] < 1],
    Return[Failure["OutsidePaperSeriesDomain", convergenceData]]
  ];
  homogeneous = Append[
    Flatten@KroneckerProduct[
      paper2411OneVertexValue[1, k12Value, momentumValue, powerValue, orderValue],
      paper2411OneVertexValue[2, k34Value, momentumValue, powerValue, orderValue]
    ],
    0
  ];
  contactCoefficient = -(4 I/Pi) Exp[Pi Im[orderValue]]
    momentumValue^(-2 orderValue - 1)
    Exp[I Pi (orderValue - powerValue)] Gamma[2 powerValue - 2 orderValue + 1];
  particular = paper2411ParticularSolution[
    xValue, yValue, momentumValue, powerValue, orderValue, cutoff
  ];
  <|
    "status" -> "computed",
    "method" -> "paper2411-Eqs-3.14-4.8-4.10-4.11",
    "cutoff" -> cutoff,
    "convergence" -> convergenceData,
    "homogeneousValue" -> homogeneous,
    "particularValue" -> contactCoefficient particular,
    "contactCoefficient" -> contactCoefficient,
    "value" -> homogeneous + contactCoefficient particular
  |>
];

Paper2411TwoVertexGppValue[___] := Failure["Paper2411OracleInput", <||>];
