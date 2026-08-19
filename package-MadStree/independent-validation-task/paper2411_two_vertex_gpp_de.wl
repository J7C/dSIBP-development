(* ::Package:: *)

(***
文件：paper2411_two_vertex_gpp_de.wl
用途：保存 2411.03088 两顶点单条 massive G++ family 的独立五维微分方程基准。
来源：论文 Eqs. (3.3)、(4.4)、(4.5)；Top-to-child 列另与 reference/ref_code 中的既有符号结果核对。
边界：本文件属于独立验证任务输入，不得由 MadStree 或 dSIBP 的当前输出生成，也不得被生产程序加载。
接口：Get 本文件后读取 paper2411TwoVertexGppDE；其中同时保存 potential、三个连接矩阵和 convention 元数据。
***)


(* ::Chapter:: *)
(*论文五维 potential*)

ClearAll[
  paper2411OmegaOne,
  paper2411TopPotential,
  paper2411TopToChildPotential,
  paper2411ReferenceCodeTopToChildPotential,
  paper2411ChildPotential,
  paper2411Potential
];

paper2411OmegaOne[vertexEnergy_, lineEnergy_] := {
  {
    -I (nu0 + 1) (-I Log[vertexEnergy - lineEnergy]/2 - I Log[vertexEnergy + lineEnergy]/2),
    -I (nu0 - 2 nu1) (Log[vertexEnergy + lineEnergy]/2 - Log[vertexEnergy - lineEnergy]/2)
  },
  {
    -I (nu0 + 1) (Log[vertexEnergy - lineEnergy]/2 - Log[vertexEnergy + lineEnergy]/2),
    -(2 nu1 + 1) Log[lineEnergy] -
      I (nu0 - 2 nu1) (-I Log[vertexEnergy - lineEnergy]/2 - I Log[vertexEnergy + lineEnergy]/2)
  }
};

paper2411TopPotential =
  KroneckerProduct[paper2411OmegaOne[k12, ks], IdentityMatrix[2]] +
  KroneckerProduct[IdentityMatrix[2], paper2411OmegaOne[k34, ks]];

paper2411TopToChildPotential = {
  I/2 (Log[k12 - ks] - Log[k12 + ks] + Log[k34 - ks] - Log[k34 + ks]),
  1/2 (Log[k12 - ks] + Log[k12 + ks] - Log[k34 - ks] - Log[k34 + ks]),
  1/2 (-Log[k12 - ks] - Log[k12 + ks] + Log[k34 - ks] + Log[k34 + ks]),
  I/2 (Log[k12 - ks] - Log[k12 + ks] + Log[k34 - ks] - Log[k34 + ks])
};

(* 该列按 reference code 的四行原式独立保留，用 exact residual 防止论文转录时交换中间两行。 *)
paper2411ReferenceCodeTopToChildPotential = {
  I/2 (Log[k12 - ks] - Log[k12 + ks]) + I/2 (Log[k34 - ks] - Log[k34 + ks]),
  (Log[k12 - ks] + Log[k12 + ks])/2 + (-Log[k34 - ks] - Log[k34 + ks])/2,
  (-Log[k12 - ks] - Log[k12 + ks])/2 + (Log[k34 - ks] + Log[k34 + ks])/2,
  I/2 (Log[k12 - ks] - Log[k12 + ks]) + I/2 (Log[k34 - ks] - Log[k34 + ks])
};

paper2411ChildPotential =
  (-2 nu0 + 2 nu1 - 1) Log[k12 + k34] + (-2 nu1 - 1) Log[ks];

paper2411Potential = ArrayFlatten[{
  {paper2411TopPotential, Transpose[{paper2411TopToChildPotential}]},
  {ConstantArray[0, {1, 4}], {{paper2411ChildPotential}}}
}];


(* ::Chapter:: *)
(*机器可读微分方程与边界元数据*)

paper2411TwoVertexGppDE = <|
  "schema" -> "paper2411_two_vertex_gpp_de_v1",
  "authority" -> <|
    "paper" -> "J. Chen, B. Feng, Y.-X. Tao, arXiv:2411.03088v2, JHEP 03 (2025) 075",
    "paperFile" -> "reference/ref_paper/2411.03088_Multivariate hypergeometric solutions of cosmological (dS) correlators by d log-form differential equations.pdf",
    "paperSHA256" -> "34315DA929126E8B455638C168722B6909CD243183B71C4137EEC81B5F0F2EAA",
    "equations" -> {"3.3", "4.4", "4.5", "4.11", "4.13", "4.14"},
    "referenceCodeFile" -> "reference/ref_code/codebubble/Omegatau/validate_TopToR1_against_dsdeppsol.m",
    "referenceCodeSHA256" -> "C6E4C290D9BF1B76CF6A029109521078B843E4A1B2E84EB184A79E6B7C3B1A06",
    "referenceCodeScope" -> "Eq. (4.4) top-to-child 4x1 potential only"
  |>,
  "equationConvention" -> "dI = dOmega . I; column vector",
  "variables" -> {k12, k34, ks},
  "parameters" -> {nu0, nu1},
  "masterOrder" -> {I00, I01, I10, I11, IR},
  "masterDefinitions" -> <|
    "topStateOrder" -> {{0, 0}, {0, 1}, {1, 0}, {1, 1}},
    "child" -> "IR of 2411.03088 Eq. (4.2)",
    "paperToMadStreeBasis" -> IdentityMatrix[5]
  |>,
  "normalization" -> <|
    "top" -> 1,
    "child" -> -(4 I/Pi) Exp[Pi Im[nu1]] ks^(-2 nu1 - 1),
    "nuConvention" -> "Negative: h(nu,0;z)=z^(-nu) HankelH[nu,z]"
  |>,
  "omegaPotential" -> paper2411Potential,
  "connectionMatrices" -> Association@Table[
    variable -> Map[Together, D[paper2411Potential, variable], {2}],
    {variable, {k12, k34, ks}}
  ],
  "topToChildPotential" -> paper2411TopToChildPotential,
  "referenceCodeTopToChildPotential" -> paper2411ReferenceCodeTopToChildPotential,
  "referenceCodeResidual" -> Map[
    Together,
    paper2411TopToChildPotential - paper2411ReferenceCodeTopToChildPotential
  ],
  "contactLeadingVector" -> {0, 1/(2 nu1 - nu0), 1/(nu0 + 1), 0, 1},
  "contactBoundaryCoefficient" ->
    -(4 I/Pi) Exp[Pi Im[nu1]] ks^(-2 nu1 - 1)
      Exp[I Pi (nu1 - nu0)] Gamma[2 nu0 - 2 nu1 + 1],
  "sourceIsolation" -> <|
    "generatedFromCurrentMadStree" -> False,
    "generatedFromCurrentDSIBP" -> False,
    "productionConsumerAllowed" -> False
  |>
|>;

ClearAll[
  paper2411OmegaOne,
  paper2411TopPotential,
  paper2411TopToChildPotential,
  paper2411ReferenceCodeTopToChildPotential,
  paper2411ChildPotential,
  paper2411Potential
];

paper2411TwoVertexGppDE
