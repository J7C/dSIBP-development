(* ::Package:: *)
(* 本文件冻结 013 第 14 节的独立手推 expected。它只依赖任务书与 arXiv:2401.00129，
   不加载项目 package；所有函数置于独立 context，避免阶段 2 与交付物符号冲突。 *)

BeginPackage["Independent013Expected`"];

indBinaryStates::usage = "indBinaryStates[p] 按最后一个 bit 最快的顺序返回 p-bit master 状态。";
indM1::usage = "indM1[mu,nus] 返回论文 Eq. (3.37) 的 M1。";
indM0::usage = "indM0[k0,ks] 返回论文 Eq. (3.37) 的 M0。";
indAMinus::usage = "indAMinus[mu,k0,ks,nus] 返回 general Aminus。";
indAPlus::usage = "indAPlus[mu,k0,ks,nus] 返回 general Aplus。";
indTwoStepMinus::usage = "indTwoStepMinus[mu,k0,ks,nus] 返回下降两级的矩阵。";
indDlogData::usage = "indDlogData[mu,k0,ks,nus] 返回同序 letters、matrices 与 binary masters。";
indCaseTwoLoopSeeds::usage = "两顶点 G++ case 的 8 条 general loop time seeds。";
indCaseTwoTreeSeeds::usage = "两顶点 G++ case 的 8 条 tree projection expected。";
indCaseThreeLoopSeeds::usage = "三顶点 G++/G+- chain 的 48 条 general loop time seeds。";
indCaseThreeTreeSeeds::usage = "三顶点 G++/G+- chain 的 48 条 tree projection expected。";
indCaseData::usage = "两个固定 family 的计数、master 顺序和局部 vertex 参数。";

Begin["`Private`"];

(* 预先建立比较表达式使用的公共符号，防止它们被 BeginPackage 收进 Private context。 *)
Scan[Symbol["Global`" <> #] &, {
  "J", "a1", "a2", "a3", "b12", "b23", "A1", "A2", "A3", "C12",
  "E1", "E2", "E3", "k12", "k23", "nu12", "nu23", "v1", "v2", "v3"
}];
J = Global`J;
a1 = Global`a1; a2 = Global`a2; a3 = Global`a3;
b12 = Global`b12; b23 = Global`b23;
A1 = Global`A1; A2 = Global`A2; A3 = Global`A3;
C12 = Global`C12;
E1 = Global`E1; E2 = Global`E2; E3 = Global`E3;
k12 = Global`k12; k23 = Global`k23;
nu12 = Global`nu12; nu23 = Global`nu23;
v1 = Global`v1; v2 = Global`v2; v3 = Global`v3;


(* ::Chapter:: *)
(*Binary master 与论文矩阵*)

(* 状态顺序直接实现 j=1+Sum[a_i 2^(p-i)]，因此最后一个 bit 变化最快。 *)
indBinaryStates[p_Integer?NonNegative] := Tuples[{0, 1}, p];


indLambda[p_Integer?Positive, j_Integer?Positive, matrix_] :=
  KroneckerProduct @@ ReplacePart[ConstantArray[IdentityMatrix[2], p], j -> matrix];


indM1[mu_, nus_List] := Module[{p = Length[nus], sigma3, identity},
  sigma3 = {{1, 0}, {0, -1}};
  identity = IdentityMatrix[2^p];
  Sum[(nus[[j]] + 1/2) indLambda[p, j, sigma3], {j, p}] +
    (mu - p/2 - Total[nus]) identity
];


indM0[k0_, ks_List] := Module[{p = Length[ks], sigma2, identity},
  sigma2 = {{0, -I}, {I, 0}};
  identity = IdentityMatrix[2^p];
  -I Sum[ks[[j]] indLambda[p, j, sigma2], {j, p}] + I k0 identity
];


indTransform[p_Integer?Positive] :=
  KroneckerProduct @@ ConstantArray[{{1, -I}, {-I, 1}}/Sqrt[2], p];


indM0Tilde[k0_, ks_List] := Module[{states = indBinaryStates[Length[ks]]},
  I DiagonalMatrix[(k0 + Total[(2 # - 1) ks]) & /@ states]
];


indAMinus[mu_, k0_, ks_List, nus_List] :=
  -Inverse[indM1[mu, nus]].indM0[k0, ks];


indAPlus[mu_, k0_, ks_List, nus_List] := Module[{transform},
  transform = indTransform[Length[ks]];
  -Inverse[transform].Inverse[indM0Tilde[k0, ks]].transform.indM1[mu + 1, nus]
];


indTwoStepMinus[mu_, k0_, ks_List, nus_List] :=
  indAMinus[mu - 1, k0, ks, nus].indAMinus[mu, k0, ks, nus];


(* ::Chapter:: *)
(*dlog connection*)

(* 每个返回矩阵是对应 letter 的 dlog 系数；letters 与 binary masters 同序冻结。 *)
indDlogData[mu_, k0_, ks_List, nus_List] := Module[
  {p, states, transform, identity, m1Shift, energyLetters, energyMatrices,
   cutLetters, cutMatrices, masters},
  p = Length[ks];
  states = indBinaryStates[p];
  transform = indTransform[p];
  identity = IdentityMatrix[2^p];
  m1Shift = indM1[mu + 1, nus];
  energyLetters = ks;
  energyMatrices = Table[
    -(2 nus[[j]] + 1) DiagonalMatrix[states[[All, j]]],
    {j, p}
  ];
  cutLetters = (k0 + Total[(2 # - 1) ks]) & /@ states;
  cutMatrices = Table[
    -Inverse[transform].SparseArray[{{r, r} -> 1}, {2^p, 2^p}].transform.m1Shift,
    {r, 2^p}
  ];
  masters = J[Join[{mu}, #]] & /@ states;
  <|
    "letters" -> Join[energyLetters, cutLetters],
    "matrices" -> Join[energyMatrices, cutMatrices],
    "masters" -> masters,
    "connection" -> Total[MapThread[#1 Log[#2] &, {Join[energyMatrices, cutMatrices],
        Join[energyLetters, cutLetters]}]]
  |>
];


(* ::Chapter:: *)
(*两顶点 G++ family*)

indTwoLoopJ[n1_, n2_, aa1_: a1, aa2_: a2, bb_: b12] :=
  J[{aa1, aa2}, {{bb, n1, n2}}, {}];


indTwoTreeJ[n1_, n2_, aa1_: A1, aa2_: A2] := J[{{aa1, n1}, {aa2, n2}}];


indCaseTwoLoopSeeds := Flatten[Table[
  With[{d = 2 nu12 + 1, c = C12, top = indTwoLoopJ[n1, n2]},
    {
      <|"vertex" -> v1, "state" -> {n1, n2},
        "regular" -> (-A1 + n1 d) indTwoLoopJ[n1, n2, a1 - 1, a2] - I E1 top +
          k12 (2 n1 - 1) indTwoLoopJ[1 - n1, n2],
        "contact" -> (n1 - n2) c J[{a1 + a2 - 1}, {{b12 + 1}}, {}]|>,
      <|"vertex" -> v2, "state" -> {n1, n2},
        "regular" -> (-A2 + n2 d) indTwoLoopJ[n1, n2, a1, a2 - 1] - I E2 top +
          k12 (2 n2 - 1) indTwoLoopJ[n1, 1 - n2],
        "contact" -> (n2 - n1) c J[{a1 + a2 - 1}, {{b12 + 1}}, {}]|>
    }
  ],
  {n1, 0, 1}, {n2, 0, 1}
], 2];


indCaseTwoTreeSeeds := Flatten[Table[
  With[{d = 2 nu12 + 1, c = C12, top = indTwoTreeJ[n1, n2],
      lower = J[{{A1 + A2 - (2 nu12 + 1)}}]},
    {
      <|"vertex" -> v1, "state" -> {n1, n2},
        "equation" -> (A1 - n1 d) indTwoTreeJ[n1, n2, A1 - 1, A2] - I E1 top +
          k12 (2 n1 - 1) indTwoTreeJ[1 - n1, n2] +
          (n1 - n2) c (-k12)^(-d) lower|>,
      <|"vertex" -> v2, "state" -> {n1, n2},
        "equation" -> (A2 - n2 d) indTwoTreeJ[n1, n2, A1, A2 - 1] - I E2 top +
          k12 (2 n2 - 1) indTwoTreeJ[n1, 1 - n2] +
          (n2 - n1) c (-k12)^(-d) lower|>
    }
  ],
  {n1, 0, 1}, {n2, 0, 1}
], 2];


(* ::Chapter:: *)
(*三顶点 G++/G+- chain family*)

indThreeLoopJ[n11_, n21_, n22_, n31_, aa1_: a1, aa2_: a2, aa3_: a3,
    bb12_: b12, bb23_: b23] :=
  J[{aa1, aa2, aa3}, {{bb12, n11, n21}, {bb23, n22, n31}}, {}];


indThreeTreeJ[n11_, n21_, n22_, n31_, aa1_: A1, aa2_: A2, aa3_: A3] :=
  J[{{aa1, n11}, {aa2, n21, n22}, {aa3, n31}}];


indCaseThreeLoopSeeds := Flatten[Table[
  With[{d12 = 2 nu12 + 1, d23 = 2 nu23 + 1, c = C12,
      top = indThreeLoopJ[n11, n21, n22, n31]},
    {
      <|"vertex" -> v1, "state" -> {n11, n21, n22, n31},
        "regular" -> (-A1 + n11 d12) indThreeLoopJ[n11, n21, n22, n31, a1 - 1] -
          I E1 top + k12 (2 n11 - 1) indThreeLoopJ[1 - n11, n21, n22, n31],
        "contact12" -> (n11 - n21) c J[{a1 + a2 - 1, a3},
          {{b12 + 1}, {b23, n22, n31}}, {}], "contact23" -> 0|>,
      <|"vertex" -> v2, "state" -> {n11, n21, n22, n31},
        "regular" -> (-A2 + n21 d12 + n22 d23)
            indThreeLoopJ[n11, n21, n22, n31, a1, a2 - 1] - I E2 top +
          k12 (2 n21 - 1) indThreeLoopJ[n11, 1 - n21, n22, n31] +
          k23 (2 n22 - 1) indThreeLoopJ[n11, n21, 1 - n22, n31],
        "contact12" -> (n21 - n11) c J[{a1 + a2 - 1, a3},
          {{b12 + 1}, {b23, n22, n31}}, {}], "contact23" -> 0|>,
      <|"vertex" -> v3, "state" -> {n11, n21, n22, n31},
        "regular" -> (-A3 + n31 d23) indThreeLoopJ[n11, n21, n22, n31, a1, a2, a3 - 1] +
          I E3 top + k23 (2 n31 - 1) indThreeLoopJ[n11, n21, n22, 1 - n31],
        "contact12" -> 0, "contact23" -> 0|>
    }
  ],
  {n11, 0, 1}, {n21, 0, 1}, {n22, 0, 1}, {n31, 0, 1}
], 4];


indCaseThreeTreeSeeds := Flatten[Table[
  With[{d12 = 2 nu12 + 1, d23 = 2 nu23 + 1, c = C12,
      top = indThreeTreeJ[n11, n21, n22, n31],
      lower = J[{{A1 + A2 - (2 nu12 + 1), n22}, {A3, n31}}]},
    {
      <|"vertex" -> v1, "state" -> {n11, n21, n22, n31},
        "equation" -> (A1 - n11 d12) indThreeTreeJ[n11, n21, n22, n31, A1 - 1] -
          I E1 top + k12 (2 n11 - 1) indThreeTreeJ[1 - n11, n21, n22, n31] +
          (n11 - n21) c (-k12)^(-d12) lower, "contact23" -> 0|>,
      <|"vertex" -> v2, "state" -> {n11, n21, n22, n31},
        "equation" -> (A2 - n21 d12 - n22 d23)
            indThreeTreeJ[n11, n21, n22, n31, A1, A2 - 1] - I E2 top +
          k12 (2 n21 - 1) indThreeTreeJ[n11, 1 - n21, n22, n31] +
          k23 (2 n22 - 1) indThreeTreeJ[n11, n21, 1 - n22, n31] +
          (n21 - n11) c (-k12)^(-d12) lower, "contact23" -> 0|>,
      <|"vertex" -> v3, "state" -> {n11, n21, n22, n31},
        "equation" -> (A3 - n31 d23) indThreeTreeJ[n11, n21, n22, n31, A1, A2, A3 - 1] +
          I E3 top + k23 (2 n31 - 1) indThreeTreeJ[n11, n21, n22, 1 - n31],
        "contact23" -> 0|>
    }
  ],
  {n11, 0, 1}, {n21, 0, 1}, {n22, 0, 1}, {n31, 0, 1}
], 4];


(* ::Chapter:: *)
(*固定 case 元数据*)

indCaseData = <|
  "two_vertex_pp_full" -> <|
    "vertexSigns" -> {1, 1}, "loopSeedCount" -> 8, "treeSeedCount" -> 8,
    "contactCount" -> 4, "topMasters" -> indBinaryStates[2], "lowerMasters" -> {{}},
    "vertexFamilies" -> {{-E1, {k12}, {nu12}}, {-E2, {k12}, {nu12}}}|>,
  "three_vertex_ppm_chain" -> <|
    "vertexSigns" -> {1, 1, -1}, "loopSeedCount" -> 48, "treeSeedCount" -> 48,
    "contact12Count" -> 16, "contact23Count" -> 0,
    "topMasters" -> indBinaryStates[4], "lowerMasters" -> indBinaryStates[2],
    "vertexFamilies" -> {{-E1, {k12}, {nu12}}, {-E2, {k12, k23}, {nu12, nu23}},
      {E3, {k23}, {nu23}}}|>
|>;

End[];
EndPackage[];
