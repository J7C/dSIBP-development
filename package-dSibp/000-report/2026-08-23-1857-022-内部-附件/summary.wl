(* ::Package:: *)

(***
文件：summary.wl
用途：保存 dSIBP 022 论文 DE 增量独立检验的轻量机器摘要。
边界：只压缩保存正式报告所需计数、hash、差矩阵与失败状态；不作为 package 输入。
***)


(* ::Chapter:: *)
(*增量独立检验摘要*)

<|
  "schema" -> "dsibp_022_incremental_paper_de_report_v1",
  "status" -> "failed",
  "packageSHA256" ->
    "FF8B6F87274C88998D9E38AB31ED27B7FAA2ACC6AAD3B9BCCCF4B5D426C06FF3",
  "tree" -> <|
    "status" -> "passed",
    "paperOracleSHA256" ->
      "A2DBB9921C096FF9A1B775C769167B23B635512BB4AF50F281DA108AE068F0A8",
    "numericRules" -> {k12 -> 30, k34 -> 6, ks -> 1, nu0 -> 2, nu1 -> 1/5},
    "masters" -> {
      J["1", {0, 0}, {0, 0}], J["1", {0, 0}, {0, 1}],
      J["1", {0, 0}, {1, 0}], J["1", {0, 0}, {1, 1}],
      J["0", {0}, {}]/ks
    },
    "seedCount" -> 9,
    "equationCount" -> 50,
    "integralCount" -> 40,
    "unknownCount" -> 35,
    "unknownRank" -> 35,
    "solveResidualZeroCount" -> 250,
    "solveResidualEntryCount" -> 250,
    "deEqualCounts" -> <|k12 -> 25, k34 -> 25, ks -> 25|>,
    "deDifferenceCounts" -> <|k12 -> 0, k34 -> 0, ks -> 0|>,
    "differenceMatrices" -> AssociationThread[
      {k12, k34, ks}, ConstantArray[ConstantArray[0, {5, 5}], 3]
    ],
    "productRuleWitness" -> <|
      "coefficient" -> 1/ks,
      "symbolicThenNumeric" -> -1,
      "prematureNumericThenDerivative" -> 0,
      "fullResidual" -> 0
    |>,
    "timingSeconds" -> 2.2548926
  |>,
  "bubble" -> <|
    "status" -> "packageFailed",
    "diagnosticStatus" -> "passed",
    "referenceSHA256" ->
      "411D0F4766FF63A43406239C300714531F016115EFE12E2110568508F8B4DE05",
    "parameterRules" -> {dim -> 37/11, nu -> 7/13, etaNu -> 23/17},
    "pointRules" -> {ss11 -> 43/17, P0 -> -29 I/13, ip0 -> 29/13},
    "generalSeedCount" -> 88,
    "packageRelationCount" -> 57160,
    "linearIntegralCount" -> 2966,
    "userMIRank" -> 21,
    "activeMasterCount" -> 19,
    "exportedEquationCount" -> 6006,
    "exportedIntegralCount" -> 2987,
    "targetCount" -> 215,
    "kira" -> <|
      "version" -> "2.3 (Git: 2.3-7-geb541f9)",
      "zeroEquationCount" -> 3211,
      "independentEquationCount" -> 2795,
      "selectedEquationCount" -> 1500,
      "masterCount" -> 19,
      "unreducedCount" -> 0,
      "wallTimeSecondsApproximate" -> 100
    |>,
    "publicRoute" -> <|
      "status" -> "notClosed",
      "residualBackendTokenCount" -> 19,
      "failedChecks" -> {"publicDEStatus", "publicDENoResidualBackendTokens"}
    |>,
    "diagnosticRoute" -> <|
      "mappingRuleCount" -> 21,
      "residualBackendTokenCount" -> 0,
      "equalCounts" -> <|P0 -> 361, ip0 -> 361, ks -> 361|>,
      "differenceCounts" -> <|P0 -> 0, ip0 -> 0, ks -> 0|>,
      "differenceMatrices" -> AssociationThread[
        {P0, ip0, ks}, ConstantArray[ConstantArray[0, {19, 19}], 3]
      ],
      "fixedParameterResiduals" -> {}
    |>,
    "timingSeconds" -> <|
      "exportTotal" -> 103.6383704,
      "DSKiraImport" -> 43.8642106,
      "DSDEPublic" -> 4.3525834,
      "DSDEDiagnostic" -> 4.4447258,
      "importAndDETotal" -> 53.0892455
    |>
  |>
|>
