(* ::Package:: *)
(* 016 模板撒点/Kira planning 轻量 smoke；只生成内存数据，不运行 Kira。 *)


(* ::Chapter:: *)
(*加载候选或模块 package*)

repoRoot = DirectoryName[DirectoryName[$InputFileName]];
packagePath = Environment["DSIBP_PACKAGE_FILE"];
If[StringQ[packagePath] && packagePath =!= "",
  Get[packagePath],
  AppendTo[$Path, FileNameJoin[{repoRoot, "000_code", "016_dSIBP"}]];
  Needs["dSIBP`"]
  ];


(* ::Chapter:: *)
(*最小 mixed bubble 输入*)

case = <|
   "name" -> "KiraPlanningSmoke",
   "vertexData" -> {{v1, "+"}, {v2, "-"}},
   "lineData" -> {
     <|"id" -> e1, "endpoints" -> {v1, v2}, "momentum" -> q,
       "nu" -> nuM, "bbType" -> "h", "massType" -> "massive"|>,
     <|"id" -> e2, "endpoints" -> {v1, v2}, "momentum" -> q - k,
       "nu" -> 0, "bbType" -> "exp", "massType" -> "massless"|>
     },
   "loopMomenta" -> {q},
   "loopExternalMomenta" -> {k},
   "independentExternalMomenta" -> {},
   "ibpMode" -> "full",
   "vertexEnergies" -> <|v1 -> E1, v2 -> E2|>,
   "ispData" -> {},
   "zeroPointRules" -> {a0[v1] -> 0, a0[v2] -> 0, b0[e1] -> 0, b0[e2] -> 0},
   "symmetryRules" -> {},
   "seedRanges" -> <|"a" -> {0}, "b" -> {0}, "isp" -> {0}|>
   |>;


(* ::Chapter:: *)
(*模板、显式撒点与 linearData*)

context = DSInit[
   case,
   WriteInitializationFiles -> False,
   GenerateDerivativeMetadata -> False,
   RegisterAsCurrent -> True,
   ProgressReporting -> False
   ];
seedData = DSSeeds[
   context,
   ProgressReporting -> False
   ];
allSeeds = DSAllSeeds[seedData];
generatedIBP = DSGenerateIBP[
   allSeeds,
   {-1, 1},
   ProgressReporting -> False
   ];
linearData = DSLinear[generatedIBP, context, ProgressReporting -> False];


(* ::Chapter:: *)
(*Kira 两阶段计划与内存导出*)

prePlan = DSKiraPlan[linearData, <|
    "stage" -> "preReduction",
    "candidateIntegrals" -> Take[linearData["integralList"], UpTo[3]],
    "coefficientRules" -> {dim -> 3, nuM -> 2}
    |>];

activeIntegral = First[linearData["integralList"]];
activeBasis = <|
   "expressions" -> {activeIntegral},
   "names" -> {"m1"},
   "derivativeVariables" -> {ss11, E1, E2},
   "scalingDegrees" -> {0}
   |>;
formalPlan = DSKiraPlan[linearData, <|
    "stage" -> "formal",
    "activeBasis" -> activeBasis,
    "numericStage" -> "postDerivative",
    "coefficientRules" -> {dim -> 3, nuM -> 2, ss11 -> 5, E1 -> 7, E2 -> 11}
    |>, ProgressReporting -> False];
formalExport = If[
   Lookup[formalPlan, "status", "failed"] === "planned",
   DSKiraExport[formalPlan],
   <||>
   ];


(* ::Chapter:: *)
(*确定性检查*)

publicFunctions = Lookup[DSPublicAPI[], "functions", {}];
checks = <|
   "load" -> (Lookup[DSPublicAPI[], "version", ""] === "016"),
   "publicAPI" -> And @@ (MemberQ[publicFunctions, #] & /@
       {"DSAllSeeds", "DSGenerateIBP", "generateIBP", "DSKiraPlan"}),
   "seedTemplates" -> (ListQ[allSeeds] && allSeeds =!= {}),
   "templatesFlat" -> (Length[allSeeds] === Lookup[First[allSeeds], "templateCount", -1]),
   "templatesCanonical" -> (FreeQ[Lookup[allSeeds, "equation", {}], _n] && And @@ Lookup[allSeeds, "eomCanonicalQ", {False}]),
   "generatedIBP" -> (Lookup[generatedIBP, "status", "failed"] === "generated"),
   "linearData" -> (Lookup[linearData, "status", "failed"] === "generated"),
   "prePlan" -> (Lookup[prePlan, "status", "failed"] === "planned"),
   "preTargets" -> (Lookup[prePlan, "targetCount", 0] === Min[3, linearData["integralCount"]]),
   "formalPlan" -> (Lookup[formalPlan, "status", "failed"] === "planned"),
   "analyticCertificate" -> (Lookup[Lookup[formalPlan, "analyticDerivativeCertificate", <||>], "status", "failed"] === "frozenBeforeNumericalRules"),
   "minimalTargets" -> TrueQ[Lookup[formalPlan, "minimalTargetsQ", False]],
   "postDerivativeExport" -> (Lookup[formalExport, "status", "failed"] === "ready"),
   "postDerivativeAudit" -> TrueQ[Lookup[Lookup[formalExport, "deVariableNumericRuleAudit", <||>], "analyticDerivativeConstructedBeforeRulesQ", False]]
   |>;

failedChecks = Keys@Select[checks, Not];
Print[<|"passed" -> Count[Values[checks], True], "total" -> Length[checks],
   "failed" -> failedChecks, "templateCount" -> Length[allSeeds],
   "equationCount" -> Lookup[generatedIBP, "equationCount", Missing["NotGenerated"]],
   "integralCount" -> Lookup[linearData, "integralCount", Missing["NotGenerated"]],
   "checks" -> checks|>];
Exit[If[failedChecks === {}, 0, 1]];
