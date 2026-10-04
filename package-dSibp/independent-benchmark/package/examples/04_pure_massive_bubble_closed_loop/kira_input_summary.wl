(* ::Package:: *)
(***
文件：kira_input_summary.wl
用途：保存 pure massive bubble 正式 Kira 输入的轻量、可读摘要。
边界：完整输入在仓库外工作区生成并交给 WSL Kira；本文件不含方程表或运行路径，也不作为程序包输入。
***)


(* ::Chapter:: *)
(*023.0 正式输入摘要*)

<|
  "schema" -> "dsibp_023_example_kira_input_summary_v1",
  "case" -> "pureMassiveBubble",
  "packageVersion" -> "023.0",
  "packageSHA256" ->
    "7B729536E62EC22E8A726F2D245D4A602E73811C531CCDC3982218A80A151740",
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
  "canonicalEquationCount" -> 5992,
  "formalEquationCount" -> 6012,
  "integralCount" -> 2966,
  "activeMasterCount" -> 19,
  "formalTargetCount" -> 215,
  "retainedInputFiles" -> {
    "main.wl", "family_conventions.wl", "reference_user_mi_basis.wl",
    "dlog_basis.wl"
  }
|>
