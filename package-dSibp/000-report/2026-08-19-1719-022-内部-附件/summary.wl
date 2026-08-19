(* ::Package:: *)
(* 文件用途：保存 dSIBP 022 第 15.6 节正式路径独立检验的精简机器摘要。
   数据来自原始 formal summary；原始文件哈希记录在 hash_manifest.txt。
   本附件不作为 package、expected 或后续计算输入。 *)


(* ::Chapter:: *)
(*正式路径检验摘要*)

<|
  "executor" -> "46449-Codex022Independent",
  "task" -> "independent-benchmark.md section 15.6 only",
  "packageVersion" -> "022.0",
  "packageSHA256" -> "15393749586EB2D515801003765DBD2C19B27CC2E6E11157C049AD25961C1CCE",
  "runnerSHA256" -> "D7B59C78670D2D345E6E7228E33B354223AF999D952A71455D67EFF573346816",
  "originalFormalSummarySHA256" -> "DB4D4589DBDF6D2AEA7D91E74979FC2D82A3E8BE76C5F50A7DEC9F09050BBDC5",
  "status" -> "passed",
  "allPassed" -> True,
  "matrixComparisons" -> <|
    "naiveVsPaper" -> <|"k12" -> {25, 25}, "k34" -> {25, 25}, "ks" -> {25, 25}|>,
    "directVsPaper" -> <|"k12" -> {25, 25}, "k34" -> {25, 25}, "ks" -> {25, 25}|>,
    "naiveVsDirect" -> <|"k12" -> {25, 25}, "k34" -> {25, 25}, "ks" -> {25, 25}|>
  |>,
  "child55" -> <|
    "k12" -> (-1 - 2 nu0 + 2 nu1)/(k12 + k34),
    "k34" -> (-1 - 2 nu0 + 2 nu1)/(k12 + k34),
    "ks" -> (-1 - 2 nu1)/ks
  |>,
  "naiveIBPZeroResiduals" -> {9, 9},
  "naiveDEZeroSources" -> {15, 15},
  "directDLogZeroResiduals" -> {25, 25},
  "forbiddenContinuousKinematicPowers" -> <|
    "naiveIBPReduction" -> {},
    "naiveDE" -> {},
    "directDE" -> {}
  |>,
  "timingsSeconds" -> <|
    "DSInit" -> 0.1519952,
    "DSTreeDLogDE" -> 0.8325325,
    "DSTreeNaiveIBP" -> 1.3540736,
    "DSTreeNaiveDE" -> 2.0995986
  |>
|>
