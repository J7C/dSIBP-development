(* ::Package:: *)
(***
文件：kira_result_summary.wl
用途：保存 pure massive bubble 的 fresh WSL Kira、DE 与 scaling 最终摘要。
边界：本文件不保留 reduction table、日志、database 或 cache；正式证据见独立检验报告。
***)


(* ::Chapter:: *)
(*正式结果摘要*)

<|
  "schema" -> "dsibp_example_kira_result_summary_v1",
  "status" -> "passed",
  "case" -> "pureMassiveBubble",
  "packageVersion" -> "1.0",
  "kira" -> <|
    "version" -> "2.3 (Git: 2.3-7-geb541f9)",
    "runtime" -> "WSL",
    "parallelConfig" -> "w10*1",
    "wallTimeSeconds" -> 109.09,
    "exitStatus" -> 0
  |>,
  "masterIDs" -> Range[19],
  "masterCount" -> 19,
  "targetCount" -> 300,
  "selectedEquationCount" -> 2179,
  "unreducedCount" -> 0,
  "deVariables" -> {ss11, P0},
  "deDimensions" -> {{19, 19}, {19, 19}},
  "scalingCertificateScope" -> "symbolic",
  "sourceIntegralIdentities" -> {53, 53},
  "sourceActiveBasisIdentities" -> {19, 19},
  "referenceMatrixEqualCounts" -> <|
    "P0" -> {361, 361}, "ip0" -> {361, 361}, "ks" -> {361, 361}
  |>,
  "formalValidationManifestSHA256" ->
    "2E287F7373B117D196EBF664D5C762966BFB30C069A96427CFB31C0F6CE54382",
  "formalValidationReductionSHA256" ->
    "7E0CD3952664B90C3A76E5F1B2907A074D93D063D38735E40FF477AFD92B5A24",
  "intermediateArtifactsRetainedInRepository" -> False
|>
