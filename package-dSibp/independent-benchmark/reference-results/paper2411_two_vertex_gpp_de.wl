(* ::Package:: *)

(***
文件：paper2411_two_vertex_gpp_de.wl
用途：保存 2411.03088 Sec. 4 两顶点 massive G++ 的 dSIBP 独立五维 DE 与 master 定义基准。
来源：论文 Eqs. (3.3), (4.2), (4.4), (4.5)；top-to-child 列另与论文参考代码核对。
边界：仅供 dSIBP Phase 2 独立检验；不读取 MadStree 文件，不允许被生产 package 加载。
接口：Get 后读取 paper2411DSIBPTwoVertexGppDE。
***)

(* ::Chapter:: *)
(*论文 exact 五维 potential*)

ClearAll[
  paper2411DSIBPOmegaOne,
  paper2411DSIBPTopPotential,
  paper2411DSIBPTopToChild,
  paper2411DSIBPChildPotential,
  paper2411DSIBPPotential
];

paper2411DSIBPOmegaOne[vertexEnergy_, lineEnergy_] := {
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

paper2411DSIBPTopPotential =
  KroneckerProduct[paper2411DSIBPOmegaOne[k12, ks], IdentityMatrix[2]] +
    KroneckerProduct[IdentityMatrix[2], paper2411DSIBPOmegaOne[k34, ks]];

paper2411DSIBPTopToChild = {
  I/2 (Log[k12 - ks] - Log[k12 + ks] + Log[k34 - ks] - Log[k34 + ks]),
  1/2 (Log[k12 - ks] + Log[k12 + ks] - Log[k34 - ks] - Log[k34 + ks]),
  1/2 (-Log[k12 - ks] - Log[k12 + ks] + Log[k34 - ks] + Log[k34 + ks]),
  I/2 (Log[k12 - ks] - Log[k12 + ks] + Log[k34 - ks] - Log[k34 + ks])
};

paper2411DSIBPChildPotential =
  (-2 nu0 + 2 nu1 - 1) Log[k12 + k34] + (-2 nu1 - 1) Log[ks];

paper2411DSIBPPotential = ArrayFlatten[{
  {paper2411DSIBPTopPotential, Transpose[{paper2411DSIBPTopToChild}]},
  {ConstantArray[0, {1, 4}], {{paper2411DSIBPChildPotential}}}
}];


(* ::Chapter:: *)
(*dSIBP master 与 normalization authority*)

paper2411DSIBPTwoVertexGppDE = <|
  "schema" -> "paper2411_dsibp_two_vertex_gpp_v1",
  "paperSHA256" -> "34315DA929126E8B455638C168722B6909CD243183B71C4137EEC81B5F0F2EAA",
  "referenceCodeSHA256" -> "C6E4C290D9BF1B76CF6A029109521078B843E4A1B2E84EB184A79E6B7C3B1A06",
  "variables" -> {k12, k34, ks},
  "parameters" -> {nu0, nu1},
  "paperMasterOrder" -> {I00, I01, I10, I11, IR},
  "packageToPaperBasisMatrix" -> DiagonalMatrix[{1, -1, -1, 1, 1}],
  "packageToPaperBasisReason" ->
    "Each endpoint state n=1 in the dSIBP h convention differs by a minus sign from paper Eq. (4.1).",
  "paperDefinitions" -> {
    "top" -> "Eq. (4.1), state order {{0,0},{0,1},{1,0},{1,1}}",
    "child" -> "Eq. (4.2): IR=-(4 I/Pi) Exp[Pi Im[nu1]] ks^(-2 nu1-1) times the one-time bare integral"
  },
  "dSIBPNormalizedMasterMap" -> <|
    "topCoefficients" -> ConstantArray[1, 4],
    "childCoefficient" -> -(-1)^(-1 - 2 nu1) ks^(-1 - 2 nu1) sE1^(2 nu1),
    "childSectorPrefactor" -> (4 I/Pi) Exp[Pi Im[nu1]] sE1^(-2 nu1),
    "childPhysicalDefinition" -> -(-1)^(-1 - 2 nu1)
      ks^(-1 - 2 nu1) sE1^(2 nu1)
  |>,
  "paperChildNormalization" -> -(4 I/Pi) Exp[Pi Im[nu1]] ks^(-2 nu1 - 1),
  "omegaPotential" -> paper2411DSIBPPotential,
  "connectionMatrices" -> Association@Table[
    variable -> Map[Together, D[paper2411DSIBPPotential, variable], {2}],
    {variable, {k12, k34, ks}}
  ],
  "sourceIsolation" -> <|
    "generatedFromCurrentDSIBP" -> False,
    "readsMadStree" -> False,
    "productionConsumerAllowed" -> False
  |>
|>;

ClearAll[
  paper2411DSIBPOmegaOne,
  paper2411DSIBPTopPotential,
  paper2411DSIBPTopToChild,
  paper2411DSIBPChildPotential,
  paper2411DSIBPPotential
];

paper2411DSIBPTwoVertexGppDE
