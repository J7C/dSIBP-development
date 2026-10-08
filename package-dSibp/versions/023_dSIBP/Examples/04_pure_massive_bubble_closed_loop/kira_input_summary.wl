(* ::Package:: *)
(***
文件：kira_input_summary.wl
用途：保存 pure massive bubble 正式 Kira 输入的轻量、可读摘要。
边界：完整输入在仓库外工作区生成并交给 WSL Kira；本文件不含方程表或运行路径，也不作为程序包输入。
***)


(* ::Chapter:: *)
(*正式输入摘要*)

<|
  "schema" -> "dsibp_example_kira_input_summary_v1",
  "case" -> "pureMassiveBubble",
  "packageVersion" -> "1.0",
  "packageSHA256" ->
    "F44E63D6909616A9BF548C403032A6CAA0EDD0E92CDA5C7558F547F6C42B5E28",
  "executionBoundary" -> <|
    "wolframInputDirectory" -> "external workspace selected by DSIBP_KIRA_WORKSPACE",
    "kiraRuntime" -> "WSL",
    "kiraRunInsideExampleDirectory" -> False,
    "intermediateArtifactsRetainedInRepository" -> False
  |>,
  "topology" -> <|
    "branch" -> "--",
    "massiveCycleLineCount" -> 2,
    "loopCount" -> 1,
    "parity" -> "both cycle propagators are even"
  |>,
  "parameterRules" -> {
    dim -> 37/11, nu -> 7/13, etaNu -> 23/17,
    analyticRegulator -> 0
  },
  "numericStage" -> "postDerivative",
  "seedTemplateCount" -> 88,
  "canonicalEquationCount" -> 14986,
  "formalEquationCount" -> 15004,
  "integralCount" -> 5728,
  "activeMasterCount" -> 19,
  "formalTargetCount" -> 300,
  "retainedInputFiles" -> {
    "main.wl", "family_conventions.wl", "reference_user_mi_basis.wl",
    "dlog_basis.wl"
  }
|>
