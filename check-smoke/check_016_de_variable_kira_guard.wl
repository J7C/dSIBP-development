(* ::Package:: *)
(* 维护 smoke：验证 active-basis Kira 导出保留全部微分变量为符号。
   本脚本只生成内存中的 Kira 文本，不启动 reduction，也不写运行产物。 *)

(* ::Chapter:: *)
(*加载候选或模块源码*)

projectRoot = DirectoryName[DirectoryName[$InputFileName]];
packageOverride = Quiet[Environment["DSIBP_PACKAGE_FILE"]];
packagePath = If[
   StringQ[packageOverride] && StringLength[StringTrim[packageOverride]] > 0,
   ExpandFileName[packageOverride],
   FileNameJoin[{projectRoot, "000_code", "016_dSIBP", "Kernel", "dSIBP.wl"}]
   ];
Get[packagePath];


(* ::Chapter:: *)
(*最小一圈符号 DE 系统*)

caseInput = <|
   "name" -> "016DEVariableKiraGuard",
   "vertexData" -> {{v1, "+"}, {v2, "+"}},
   "lineData" -> {
     <|"id" -> 1, "endpoints" -> {v1, v2}, "momentum" -> q,
       "massType" -> "massless", "bbType" -> "exp", "nu" -> 0|>,
     <|"id" -> 2, "endpoints" -> {v1, v2}, "momentum" -> q - k,
       "massType" -> "massless", "bbType" -> "exp", "nu" -> 0|>
     },
   "extLegs" -> {},
   "loopMomenta" -> {q},
   "loopExternalMomenta" -> {k},
   "independentExternalMomenta" -> {},
   "ibpMode" -> "full",
   "vertexEnergies" -> <|v1 -> P1, v2 -> P2|>,
   "ispData" -> {},
   "numericRules" -> {dim -> 3},
   "zeroPointRules" -> {
     a0[v1] -> 0, a0[v2] -> 0,
     b0[1] -> 1, b0[2] -> 1
     },
   "symmetryRules" -> {},
   "seedPreset" -> "quickCheck",
   "seedRanges" -> <|"a" -> {-1, 0, 1}, "b" -> {-1, 0, 1}, "isp" -> {0}|>
   |>;

context = DSInit[
   caseInput,
   GenerateDerivativeMetadata -> True,
   RegisterAsCurrent -> False,
   ProgressReporting -> False
   ];
seedData = DSSeeds[
   context,
   ProgressReporting -> False
   ];
linearData = DSLinear[seedData, context, ProgressReporting -> False];

topIntegral = J[{0, 0}, {{0, 0}, {0, 0}}, {}];
activeBasis = <|
   "names" -> {"m1"},
   "expressions" -> {topIntegral},
   "activeIndices" -> {1},
   "derivativeVariables" -> {ss11, P1, P2},
   "scalingDegrees" -> {-1}
   |>;


(* ::Chapter:: *)
(*正常与非法规则门禁*)

validExport = DSKiraExport[
   linearData,
   KiraActiveBasis -> activeBasis,
   OutputDirectory -> None,
   ProgressReporting -> False
   ];
lhsBlockedExport = DSKiraExport[
   linearData,
   KiraActiveBasis -> activeBasis,
   KiraCoefficientRules -> {ss11 -> 5},
   OutputDirectory -> None,
   ProgressReporting -> False
   ];
rhsBlockedExport = DSKiraExport[
   linearData,
   KiraActiveBasis -> activeBasis,
   KiraCoefficientRules -> {dim -> 1 + P1},
   OutputDirectory -> None,
   ProgressReporting -> False
   ];

validAudit = Lookup[validExport, "deVariableNumericRuleAudit", <||>];
lhsAudit = Lookup[lhsBlockedExport, "deVariableNumericRuleAudit", <||>];
rhsAudit = Lookup[rhsBlockedExport, "deVariableNumericRuleAudit", <||>];

checks = <|
   "contextInitialized" -> (Lookup[context, "status", "failed"] === "initialized"),
   "seedsGenerated" -> (Lookup[seedData, "status", "failed"] === "generated"),
   "linearGenerated" -> (Lookup[linearData, "status", "failed"] === "generated"),
   "validExportReady" -> (Lookup[validExport, "status", "failed"] === "ready"),
   "validAuditPassed" -> TrueQ[Lookup[validAudit, "passQ", False]],
   "validVariables" -> (Lookup[validAudit, "deVariables", {}] === {ss11, P1, P2}),
   "lhsRuleBlocked" -> (Lookup[lhsBlockedExport, "reason", ""] === "differentialVariablesWouldBeNumerical"),
   "lhsIntersectionRecorded" -> (Lookup[lhsAudit, "numericRuleLHSIntersection", {}] === {ss11 -> 5}),
   "rhsRuleBlocked" -> (Lookup[rhsBlockedExport, "reason", ""] === "differentialVariablesWouldBeNumerical"),
   "rhsDependencyRecorded" -> (Lookup[rhsAudit, "numericRuleRHSDependencies", {}] === {dim -> 1 + P1})
   |>;

failedChecks = Keys@Select[checks, Not];
Print[<|
   "packagePath" -> packagePath,
   "passed" -> Count[Values[checks], True],
   "total" -> Length[checks],
   "failed" -> failedChecks,
   "checks" -> checks
   |>];
Exit[If[failedChecks === {}, 0, 1]];
