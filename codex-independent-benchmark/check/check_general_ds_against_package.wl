(* ::Package:: *)
(* 本检查重建 general-ds 验证：独立比较相位/乘积/链式 expected，并另列 upper-triangular Dij 与表达式线性的 package 自检。 *)

ClearAll["Global`*"];


(* ::Chapter:: *)
(*冻结 expected 与 package*)
Get[FileNameJoin[{DirectoryName[DirectoryName[$InputFileName]], "general-ds", "expected.wl"}]];

checkDir = DirectoryName[$InputFileName];
workspaceDir = DirectoryName[checkDir];
projectDir = DirectoryName[workspaceDir];
packagePath = FileNameJoin[{projectDir, "independent-benchmark", "package", "package_014.wl"}];
resultsDir = FileNameJoin[{checkDir, "results"}];
resultPath = FileNameJoin[{resultsDir, "general-ds-against-package.wl"}];
If[! DirectoryQ[resultsDir], CreateDirectory[resultsDir, CreateIntermediateDirectories -> True]];

Quiet[Get[packagePath], General::shdw];
DSMessagesOff[];


(* ::Chapter:: *)
(*vertex_energy_signs 的 A/B/C 三个能量 convention*)

(* ::Section::Closed:: *)
(*任务书与 014 直接共用 name/expr/range ISP schema*)
vertexEnergyCase[signs_List, energyCase_String] := <|
  "name" -> StringRiffle[{"general-ds-vertex-energy", StringJoin[ToString /@ signs], energyCase}, "-"],
  "vertexData" -> MapThread[{#1, If[#2 === 1, "+", "-"]} &, {{v1, v2}, signs}],
  "lineData" -> {
    <|"id" -> 1, "endpoints" -> {v1, v2}, "momentum" -> ell - k,
      "massType" -> "massless", "bbType" -> "exp", "nu" -> 0|>
  },
  "loopMomenta" -> {ell},
  "externalMomenta" -> {k},
  "externalInvariantRules" -> {sp[k, k] -> s11},
  "vertexEnergies" -> Switch[energyCase,
    "A", <|v1 -> ke[1], v2 -> ke[2]|>,
    "B", <|v1 -> Sqrt[s11], v2 -> ke[2]|>,
    "C", <|v1 -> ke[3], v2 -> ke[2]|>
  ],
  "ispData" -> {<|"name" -> rho1, "expr" -> sp[ell, k], "range" -> {0, 1}|>},
  "zeroPointRules" -> {a0[v1] -> alpha1, a0[v2] -> alpha2, b0[1] -> beta1},
  "symmetryRules" -> {},
  "seedRanges" -> <|"a" -> {0}, "b" -> {0}, "isp" -> {0, 1}, "sampleOnly" -> False|>
|>;

shiftA[int_J, slot_Integer] := ReplacePart[int, {1, slot} -> int[[1, slot]] + 1];

independentPhaseDerivative[int_J, variable_, signs_List, energies_Association] := Expand[Total[
  MapThread[
    Function[{slot, sign}, I*sign*D[Lookup[energies, {v1, v2}[[slot]]], variable]*shiftA[int, slot]],
    {Range[2], signs}
  ]
]];

makeContext[signs_List, energyCase_String] := DSInit[
  vertexEnergyCase[signs, energyCase],
  RegisterAsCurrent -> False,
  ProgressReporting -> False
];


(* ::Section::Closed:: *)
(*独立能量变量的完整两积分乘积法则*)
energyProductChecks = Flatten@Table[
  context = makeContext[signs, energyCase];
  topo = context["topology"];
  energies = Lookup[vertexEnergyCase[signs, energyCase], "vertexEnergies"];
  base = If[SameQ @@ signs,
    J[{a1, a2}, {{b1, 0}}, {r1}],
    J[{a1, a2}, {{b1}}, {r1}]
  ];
  second = shiftA[If[SameQ @@ signs, ReplacePart[base, {2, 1, 2} -> 1], base], 1];
  variables = Switch[energyCase, "A", {ke[1], ke[2]}, "C", {ke[3], ke[2]}];
  Map[Function[variable,
    derivative1 = independentPhaseDerivative[base, variable, signs, energies];
    derivative2 = independentPhaseDerivative[second, variable, signs, energies];
    expected = generalDSProductExpected[variable, base, second, derivative1, derivative2];
    actual = ds[variable^2*base + (variable + 1)*second + variable^3, variable, topo];
    difference = Together[Expand[actual - expected]];
    <|"kind" -> "independent", "label" -> {"energy-product", signs, energyCase, variable},
      "difference" -> difference, "passed" -> TrueQ[difference === 0]|>
  ], variables],
  {signs, {{1, 1}, {-1, 1}}}, {energyCase, {"A", "C"}}
];


(* ::Section::Closed:: *)
(*B-A 差分消去共同 line/ISP 外不变量导数，只留下 Sqrt[s11] 相位链式项*)
sqrtChainChecks = Table[
  contextA = makeContext[signs, "A"];
  contextB = makeContext[signs, "B"];
  base = If[SameQ @@ signs,
    J[{a1, a2}, {{b1, 0}}, {r1}],
    J[{a1, a2}, {{b1}}, {r1}]
  ];
  actualDifference = Expand[
    ds[base, s11, contextB["topology"]] - ds[base, s11, contextA["topology"]]
  ];
  expectedDifference = I*signs[[1]]/(2*Sqrt[s11])*shiftA[base, 1];
  difference = Together[Expand[actualDifference - expectedDifference]];
  <|"kind" -> "independent", "label" -> {"sqrt-chain", signs},
    "difference" -> difference, "passed" -> TrueQ[difference === 0]|>,
  {signs, {{1, 1}, {-1, 1}}}
];


(* ::Chapter:: *)
(*upper-triangular Dij decomposition*)

(* ::Section::Closed:: *)
(*一个外动量：矩阵和唯一系数直接对照冻结反解*)
oneContext = makeContext[{1, 1}, "A"];
oneDecomposition = dSIBP`Private`makeExternalInvariantDerivativeDecomposition[oneContext["topology"], s11];
oneMatrix = rep2outform[Lookup[oneDecomposition, "matrix"], oneContext["topology"]];
oneCoefficients = rep2outform[Lookup[oneDecomposition, "coefficients"], oneContext["topology"]];


(* ::Section::Closed:: *)
(*两个外动量：三条 massless line 闭合 q^2、q.k1、q.k2*)
twoExternalCase = <|
  "name" -> "general-ds-two-external",
  "vertexData" -> {{v1, "-"}, {v2, "-"}},
  "lineData" -> {
    <|"id" -> 1, "endpoints" -> {v1, v2}, "momentum" -> q, "massType" -> "massless", "bbType" -> "exp", "nu" -> 0|>,
    <|"id" -> 2, "endpoints" -> {v1, v2}, "momentum" -> q - k1, "massType" -> "massless", "bbType" -> "exp", "nu" -> 0|>,
    <|"id" -> 3, "endpoints" -> {v1, v2}, "momentum" -> q - k2, "massType" -> "massless", "bbType" -> "exp", "nu" -> 0|>
  },
  "loopMomenta" -> {q},
  "externalMomenta" -> {k1, k2},
  "externalInvariantRules" -> {sp[k1, k1] -> s11, sp[k1, k2] -> s12, sp[k2, k2] -> s22},
  "vertexEnergies" -> <|v1 -> E1, v2 -> E2|>,
  "ispData" -> {},
  "zeroPointRules" -> {a0[v1] -> alpha1, a0[v2] -> alpha2, b0[1] -> beta1, b0[2] -> beta2, b0[3] -> beta3},
  "symmetryRules" -> {}
|>;

twoContext = DSInit[twoExternalCase, RegisterAsCurrent -> False, ProgressReporting -> False];
twoDecompositions = dSIBP`Private`makeExternalInvariantDerivativeDecomposition[twoContext["topology"], #] & /@ {s11, s12, s22};
twoMatrices = rep2outform[Lookup[twoDecompositions, "matrix"], twoContext["topology"]];
twoCoefficientColumns = Transpose[rep2outform[Lookup[twoDecompositions, "coefficients"], twoContext["topology"]]];
twoResiduals = rep2outform[Lookup[twoDecompositions, "residual"], twoContext["topology"]];

decompositionChecks = {
  <|"kind" -> "independent", "label" -> "one-D-matrix", "actual" -> oneMatrix, "expected" -> upperDMatrix1|>,
  <|"kind" -> "independent", "label" -> "one-D-coefficients", "actual" -> oneCoefficients, "expected" -> First[upperDCoefficients1]|>,
  <|"kind" -> "independent", "label" -> "one-D-residual", "actual" -> Lookup[oneDecomposition, "residual"], "expected" -> {0}|>,
  <|"kind" -> "independent", "label" -> "two-D-matrix", "actual" -> First[twoMatrices], "expected" -> upperDMatrix2|>,
  <|"kind" -> "independent", "label" -> "two-D-coefficients", "actual" -> twoCoefficientColumns, "expected" -> upperDCoefficients2|>,
  <|"kind" -> "independent", "label" -> "two-D-residual", "actual" -> twoResiduals, "expected" -> ConstantArray[{0, 0, 0}, 3]|>
};
decompositionChecks = Map[Function[check,
  difference = Together /@ Flatten[{Lookup[check, "actual"] - Lookup[check, "expected"]}];
  Join[check, <|
    "difference" -> difference,
    "passed" -> And @@ (TrueQ[# === 0] & /@ difference)
  |>]
], decompositionChecks];


(* ::Chapter:: *)
(*package 表达式线性与拒绝门禁*)

(* ::Section::Closed:: *)
(*这两项明确标成 self-check，不计入独立 expected 数*)
selfContext = makeContext[{1, 1}, "A"];
selfTopo = selfContext["topology"];
selfBase = J[{a1, a2}, {{b1, 0}}, {r1}];
selfSecond = shiftA[ReplacePart[selfBase, {2, 1, 2} -> 1], 1];
selfProductDifference = Together[Expand[
  ds[s11^2*selfBase + (s11 + 1)*selfSecond + s11^3, s11, selfTopo]
    - (2*s11*selfBase + selfSecond + 3*s11^2
      + s11^2*ds[selfBase, s11, selfTopo] + (s11 + 1)*ds[selfSecond, s11, selfTopo])
]];
selfChecks = {
  <|"kind" -> "package-self", "label" -> "s11-expression-linearity",
    "difference" -> selfProductDifference, "passed" -> TrueQ[selfProductDifference === 0]|>,
  <|"kind" -> "package-self", "label" -> "reject-nonlinear-J",
    "actual" -> Quiet[Check[ds[selfBase*selfSecond, s11, selfTopo], $Failed]], "expected" -> $Failed|>,
  <|"kind" -> "package-self", "label" -> "reject-internal-kk",
    "actual" -> Quiet[Check[ds[selfBase, kk[1, 1], selfTopo], $Failed]], "expected" -> $Failed|>
};
selfChecks = Join[#, <|"passed" -> TrueQ[Lookup[#, "passed", Lookup[#, "actual", None] === Lookup[#, "expected", Missing[]]]]|>] & /@ selfChecks;


(* ::Chapter:: *)
(*汇总与持久化*)
independentChecks = Join[energyProductChecks, sqrtChainChecks, decompositionChecks];
allChecks = Join[independentChecks, selfChecks];

summary = <|
  "packageHash" -> FileHash[packagePath, "SHA256", "HexString"],
  "independentPassed" -> Count[independentChecks, _?(TrueQ[Lookup[#, "passed", False]] &)],
  "independentTotal" -> Length[independentChecks],
  "packageSelfPassed" -> Count[selfChecks, _?(TrueQ[Lookup[#, "passed", False]] &)],
  "packageSelfTotal" -> Length[selfChecks],
  "firstIndependentFailure" -> SelectFirst[independentChecks, ! TrueQ[Lookup[#, "passed", False]] &, Missing["NoFailure"]],
  "firstSelfFailure" -> SelectFirst[selfChecks, ! TrueQ[Lookup[#, "passed", False]] &, Missing["NoFailure"]]
|>;

Put[summary, resultPath];
Print[InputForm[summary]];
If[! And[
  summary["independentPassed"] === summary["independentTotal"],
  summary["packageSelfPassed"] === summary["packageSelfTotal"]
], Exit[1]];
