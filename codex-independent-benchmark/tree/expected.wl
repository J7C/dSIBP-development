(* ::Package:: *)
(* 本文件从 2401.00129 的公开公式构造 pure-time/tree 矩阵、dlog connection 与共同-theta odd-subset 恒等式。它不加载或调用 dSIBP package。 *)

ClearAll["Global`*"];


(* ::Chapter:: *)
(*n-fold vertex family 的矩阵公式*)

(* ::Section::Closed:: *)
(*Pauli 矩阵、binary master 顺序与嵌入*)
sigma1 = {{0, 1}, {1, 0}};
sigma2 = {{0, -I}, {I, 0}};
sigma3 = {{1, 0}, {0, -1}};
identity2 = IdentityMatrix[2];

binaryMasterOrder[n_Integer?NonNegative] := Tuples[{0, 1}, n];

kronProduct[matrices_List] := If[
  Length[matrices] === 1,
  First[matrices],
  KroneckerProduct @@ matrices
];

embeddedMatrix[matrix_, slot_Integer, n_Integer] := kronProduct[Table[
  If[index === slot, matrix, identity2],
  {index, n}
]];

lambda[pauliIndex_Integer, slot_Integer, n_Integer] := embeddedMatrix[
  {sigma1, sigma2, sigma3}[[pauliIndex]],
  slot,
  n
];


(* ::Section::Closed:: *)
(*Eq. (3.37)、(3.47) 与 (3.50)*)
treeM1[nu0_, nus_List] := Module[{n = Length[nus], identity},
  identity = IdentityMatrix[2^n];
  Sum[(nus[[slot]] + 1/2) lambda[3, slot, n], {slot, n}]
    + (nu0 - n/2 - Total[nus]) identity
];

treeM0[k0_, ks_List] := Module[{n = Length[ks], identity},
  identity = IdentityMatrix[2^n];
  -I Sum[ks[[slot]] lambda[2, slot, n], {slot, n}] + I k0 identity
];

treeT[n_Integer?NonNegative] := If[
  n === 0,
  {{1}},
  kronProduct[ConstantArray[{{1, -I}, {-I, 1}}/Sqrt[2], n]]
];

treeM1Tilde[nu0_, nus_List] := Module[{n = Length[nus], identity},
  identity = IdentityMatrix[2^n];
  -Sum[(nus[[slot]] + 1/2) lambda[2, slot, n], {slot, n}]
    + (nu0 - n/2 - Total[nus]) identity
];

treeM0Tilde[k0_, ks_List] := Module[{n = Length[ks], identity},
  identity = IdentityMatrix[2^n];
  -I Sum[ks[[slot]] lambda[3, slot, n], {slot, n}] + I k0 identity
];

treeAMinus[nu0_, nus_List, k0_, ks_List] := -Inverse[treeM1[nu0, nus]] . treeM0[k0, ks];

treeAPlus[nu0_, nus_List, k0_, ks_List] := Module[{transform = treeT[Length[nus]]},
  -Inverse[transform] . Inverse[treeM0Tilde[k0, ks]] . transform . treeM1[nu0 + 1, nus]
];


(* ::Section::Closed:: *)
(*Eq. (3.54)--(3.55) 的 dlog connection*)
treeOmegaTilde0[k0_, ks_List] := Module[{states = binaryMasterOrder[Length[ks]]},
  DiagonalMatrix[
    -I Log[k0 + Total[(2 # - 1) ks]] & /@ states
  ]
];

treeOmegaExternal[nus_List, ks_List] := Module[{states = binaryMasterOrder[Length[ks]]},
  DiagonalMatrix[
    (-Total[# (2 nus + 1) Log[ks]]) & /@ states
  ]
];

treeOmega[nu0_, nus_List, k0_, ks_List] := Module[{transform = treeT[Length[nus]]},
  treeOmegaExternal[nus, ks]
    - I Inverse[transform] . treeOmegaTilde0[k0, ks] . transform . treeM1[nu0 + 1, nus]
];

treeExpectedKDerivative[nu0_, nus_List, k0_, ks_List, slot_Integer] := Module[
  {n = Length[nus], identity},
  identity = IdentityMatrix[2^n];
  -(2 nus[[slot]] + 1)/(2 ks[[slot]]) (identity - lambda[3, slot, n])
    - I lambda[2, slot, n] . treeAPlus[nu0, nus, k0, ks]
];


(* ::Chapter:: *)
(*Contact source 与共同-theta*)

(* ::Section::Closed:: *)
(*单条 G++ 的 complementary endpoint contact*)
massivePlusPlusContact[firstState_Integer, secondState_Integer, momentum_, nu_] := If[
  firstState + secondState === 1,
  (-1)^(firstState + 1) (4 I/Pi) Exp[Pi Im[nu]] (-momentum)^(-2 nu - 1),
  0
];


(* ::Section::Closed:: *)
(*共同 theta 的 odd-subset 展开*)
oddSubsets[n_Integer?NonNegative] := Select[Subsets[Range[n]], OddQ[Length[#]] &];

commonThetaDifferenceExpansion[greater_List, less_List] := Module[{n = Length[greater]},
  2^(1 - n) Total[Function[subset,
    Times @@ Join[
      (greater[[#]] - less[[#]] & /@ subset),
      (greater[[#]] + less[[#]] & /@ Complement[Range[n], subset])
    ]
  ] /@ oddSubsets[n]]
];


(* ::Section::Closed:: *)
(*任务书新增 family 的独立覆盖计数*)
treeTaskInventory = {
  <|
    "name" -> "two_vertex_plus_plus",
    "massiveLegCounts" -> {1, 1},
    "discreteStateCount" -> 4,
    "activeTimeGenerators" -> 2,
    "topSeedCount" -> 8,
    "contactEdges" -> {{1, 2}},
    "crossEdges" -> {}
  |>,
  <|
    "name" -> "three_vertex_plus_plus_minus_chain",
    "massiveLegCounts" -> {1, 2, 1},
    "discreteStateCount" -> 16,
    "activeTimeGenerators" -> 3,
    "topSeedCount" -> 48,
    "contactEdges" -> {{1, 2}},
    "crossEdges" -> {{2, 3}}
  |>,
  <|
    "name" -> "three_parallel_massive_h_plus_plus",
    "contactSubsets" -> oddSubsets[3],
    "forbiddenEvenSubsets" -> Select[Subsets[Range[3]], EvenQ[Length[#]] && # =!= {} &]
  |>,
  <|
    "name" -> "three_parallel_massive_h_plus_minus",
    "allLinesCross" -> True,
    "contactSubsets" -> {},
    "usesWT" -> False
  |>
};


(* ::Chapter:: *)
(*冻结前符号自检*)
treeDlogResiduals[n_Integer] := Module[
  {nus = Array[nu, n], ks = Array[k, n], connection, k0Residual, lineResiduals},
  connection = treeOmega[nu0, nus, k0, ks];
  k0Residual = Together /@ Flatten[D[connection, k0] - I treeAPlus[nu0, nus, k0, ks]];
  lineResiduals = Table[
    Together /@ Flatten[D[connection, ks[[slot]]] - treeExpectedKDerivative[nu0, nus, k0, ks, slot]],
    {slot, n}
  ];
  Join[k0Residual, Flatten[lineResiduals]]
];

greaterSymbols = Array[greater, 3];
lessSymbols = Array[less, 3];
commonThetaResidual = Expand[
  Times @@ greaterSymbols - Times @@ lessSymbols
    - commonThetaDifferenceExpansion[greaterSymbols, lessSymbols]
];

treeExpectedSelfCheck = <|
  "binaryOrderN2" -> binaryMasterOrder[2],
  "dlogResidualN1" -> treeDlogResiduals[1],
  "dlogResidualN2" -> treeDlogResiduals[2],
  "commonThetaResidualN3" -> commonThetaResidual,
  "oddSubsetsN3" -> oddSubsets[3],
  "taskCount" -> Length[treeTaskInventory]
|>;

Print[InputForm[treeExpectedSelfCheck]];
