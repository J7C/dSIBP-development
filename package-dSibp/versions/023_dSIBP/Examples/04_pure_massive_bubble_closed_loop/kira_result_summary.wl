(* ::Package:: *)
(***
文件：kira_result_summary.wl
用途：保存 pure massive bubble 的 fresh WSL Kira、DE 与 scaling 最终摘要。
边界：本文件不保留 reduction table、日志、database 或 cache；正式证据见 023.0 独立检验报告。
***)


(* ::Chapter:: *)
(*023.0 正式结果摘要*)

<|
  "schema" -> "dsibp_023_example_kira_result_summary_v1",
  "status" -> "passed",
  "case" -> "pureMassiveBubble",
  "packageVersion" -> "023.0",
  "kira" -> <|
    "version" -> "2.3 (Git: 2.3-7-geb541f9)",
    "runtime" -> "WSL",
    "parallelConfig" -> "w10*1",
    "wallTimeSeconds" -> 91.03,
    "exitStatus" -> 0
  |>,
  "masterIDs" -> Range[19],
  "masterCount" -> 19,
  "targetCount" -> 215,
  "selectedEquationCount" -> 1368,
  "unreducedCount" -> 0,
  "deVariables" -> {ss11, P0},
  "deDimensions" -> {{19, 19}, {19, 19}},
  "scalingCertificateScope" -> "symbolic",
  "sourceIntegralIdentities" -> {33, 33},
  "sourceActiveBasisIdentities" -> {19, 19},
  "referenceMatrixEqualCounts" -> <|
    "P0" -> {361, 361}, "ip0" -> {361, 361}, "ks" -> {361, 361}
  |>,
  "formalValidationManifestSHA256" ->
    "B780D4BA52388E794855D520C4126BCE70323E535CD66FD3929B5F7642DBA12D",
  "formalValidationReductionSHA256" ->
    "4F0A55A033C45CAC293F4297D50DEB95BCD6F52668367E84669F96BF677CD5DE",
  "intermediateArtifactsRetainedInRepository" -> False
|>
