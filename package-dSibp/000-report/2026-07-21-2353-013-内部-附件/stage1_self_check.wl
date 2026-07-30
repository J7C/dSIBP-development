(* ::Package:: *)
(* 本脚本只检查独立 expected 的内部代数一致性，不加载 013 package。
   输出是阶段 1 冻结前的确定性门禁与计数摘要。 *)

ClearAll["Global`*"];


(* ::Chapter:: *)
(*定义与加载*)

baseDir = If[$InputFileName =!= "", DirectoryName[$InputFileName], NotebookDirectory[]];
Get[FileNameJoin[{baseDir, "expected_013.wl"}]];


check[name_, condition_] := <|"name" -> name, "pass" -> TrueQ[condition]|>;


(* ::Chapter:: *)
(*论文矩阵与 general 迭代*)

states2 = Independent013Expected`indBinaryStates[2];
m1ExpectedDiagonal = DiagonalMatrix[
  (mu - Total[# (2 {nu1, nu2} + 1)]) & /@ states2
];


matrixChecks = {
  check["binary-order-p2", states2 === {{0, 0}, {0, 1}, {1, 0}, {1, 1}}],
  check["M1-diagonal-form", Simplify[
    Independent013Expected`indM1[mu, {nu1, nu2}] - m1ExpectedDiagonal] === ConstantArray[0, {4, 4}]],
  check["Aminus-solves-IBP", Simplify[
    Independent013Expected`indM1[mu, {nu1, nu2}].
      Independent013Expected`indAMinus[mu, k0, {k1, k2}, {nu1, nu2}] +
      Independent013Expected`indM0[k0, {k1, k2}]] === ConstantArray[0, {4, 4}]],
  check["Aplus-inverse-shift", Simplify[
    Independent013Expected`indAPlus[mu, k0, {k1, k2}, {nu1, nu2}].
      Independent013Expected`indAMinus[mu + 1, k0, {k1, k2}, {nu1, nu2}] - IdentityMatrix[4]] ===
      ConstantArray[0, {4, 4}]],
  check["two-step-product", Simplify[
    Independent013Expected`indTwoStepMinus[mu, k0, {k1, k2}, {nu1, nu2}] -
      Independent013Expected`indAMinus[mu - 1, k0, {k1, k2}, {nu1, nu2}].
       Independent013Expected`indAMinus[mu, k0, {k1, k2}, {nu1, nu2}]] === ConstantArray[0, {4, 4}]]
};


(* ::Chapter:: *)
(*两个固定 family 的计数与 guard*)

twoLoop = Independent013Expected`indCaseTwoLoopSeeds;
twoTree = Independent013Expected`indCaseTwoTreeSeeds;
threeLoop = Independent013Expected`indCaseThreeLoopSeeds;
threeTree = Independent013Expected`indCaseThreeTreeSeeds;


countChecks = {
  check["two-loop-count", Length[twoLoop] === 8],
  check["two-tree-count", Length[twoTree] === 8],
  check["two-contact-count", Count[twoLoop[[All, "contact"]], x_ /; x =!= 0] === 4],
  check["three-loop-count", Length[threeLoop] === 48],
  check["three-tree-count", Length[threeTree] === 48],
  check["three-contact12-count", Count[threeLoop[[All, "contact12"]], x_ /; x =!= 0] === 16],
  check["G+-contact23-zero", DeleteDuplicates[threeLoop[[All, "contact23"]]] === {0}],
  check["G+-tree-contact23-zero", DeleteDuplicates[threeTree[[All, "contact23"]]] === {0}]
};


(* ::Chapter:: *)
(*dlog 顺序和确定性有理 probe*)

dlogP2 = Independent013Expected`indDlogData[mu, k0, {k1, k2}, {nu1, nu2}];
probeRules = {mu -> 7/3, nu1 -> 1/5, nu2 -> 2/7, k0 -> 11/3, k1 -> 2/3, k2 -> 3/5};
masterProbe = Thread[dlogP2["masters"] -> {2/11, 3/13, 5/17, 7/19}];


dlogChecks = {
  check["dlog-letter-order", dlogP2["letters"] ===
    {k1, k2, k0 - k1 - k2, k0 - k1 + k2, k0 + k1 - k2, k0 + k1 + k2}],
  check["dlog-matrix-count", Length[dlogP2["matrices"]] === 6],
  check["dlog-master-order", dlogP2["masters"] ===
    {J[{mu, 0, 0}], J[{mu, 0, 1}], J[{mu, 1, 0}], J[{mu, 1, 1}]}],
  check["probe-M1-nonsingular", Numerator[Together[Det[
    Independent013Expected`indM1[mu, {nu1, nu2}] /. probeRules]]] =!= 0],
  check["probe-M0tilde-nonsingular", And @@ Thread[
    ({k0 - k1 - k2, k0 - k1 + k2, k0 + k1 - k2, k0 + k1 + k2} /. probeRules) != 0]],
  check["master-probe-complete", Length[masterProbe] === 4]
};


(* ::Chapter:: *)
(*输出*)

allChecks = Join[matrixChecks, countChecks, dlogChecks];
summary = <|
  "pass" -> Count[allChecks[[All, "pass"]], True],
  "fail" -> Count[allChecks[[All, "pass"]], False],
  "checks" -> allChecks,
  "parameterProbe" -> probeRules,
  "masterProbe" -> masterProbe
|>;

Put[summary, FileNameJoin[{baseDir, "stage1_self_check_result.wl"}]];
Print[InputForm[summary]];
summary
