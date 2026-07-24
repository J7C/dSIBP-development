(* ::Package:: *)
(* 017 pure massive bubble：固定 -- branch/parity，从 topology 到 Kira 取回、DE 与标度检查。 *)

(* ::Chapter:: *)
(*标准 package 加载*)

exampleDir = DirectoryName[$InputFileName];
Get[FileNameJoin[{exampleDir, "..", "load_current_package.wl"}]];
Get[FileNameJoin[{exampleDir, "dlog_basis.wl"}]];
Get[FileNameJoin[{exampleDir, "family_conventions.wl"}]];

(* 固定随机种子只记录参数点的来源；规则本身冻结，Kira 与回读端必须逐项复用。 *)
parameterProbeSeed = 20260722;
parameterProbeRules = {dim -> 37/11, nu -> 7/13, etaNu -> 23/17};

(* ::Chapter:: *)
(*详细物理输入*)

(* 两个顶点均在 - branch；这与 reference 的 Vpm=0 convention 对齐。 *)
(* 两条 massive h 内线依次取 q 与 q-k；externalMomenta 只含实际进入线动量的独立向量 k。 *)
(* s11=k.k 与 P0 是 ds 的独立变量；P_pkg=P0=+I k0，reference P1=P2=-P0=-I k0。 *)
(* J 只保存整数指标；a0=2 nu、b0=-2 nu 留在 metadata，并在 shrink/tree 投影时进入完整物理幂次。 *)
caseInput = <|
   "name" -> "017PureMassiveBubbleClosedLoopMinusMinus",
   "vertexData" -> {{v1, "-"}, {v2, "-"}},
   "lineData" -> {
     <|"id" -> 1, "endpoints" -> {v1, v2}, "momentum" -> q,
       "massType" -> "massive", "bbType" -> "h", "nu" -> nu|>,
     <|"id" -> 2, "endpoints" -> {v1, v2}, "momentum" -> q - k,
       "massType" -> "massive", "bbType" -> "h", "nu" -> nu|>
     },
   "loopMomenta" -> {q},
   "loopExternalMomenta" -> {k},
   "independentExternalMomenta" -> {},
   "ibpMode" -> "full",
   "externalInvariantRules" -> {sp[k, k] -> s11},
   "vertexEnergies" -> <|v1 -> P0, v2 -> P0|>,
   "ispData" -> {},
   "numericRules" -> parameterProbeRules,
   "zeroPointRules" -> {
     a0[v1] -> 2 nu, a0[v2] -> 2 nu,
     b0[1] -> -2 nu, b0[2] -> -2 nu
     },
   (* Fermat 只处理有理系数域；massive contact 的非有理归一化打包成独立 prefactor 参数。 *)
   "shrinkPrefactorRules" -> {Exp[Pi Im[nu]]/Pi -> etaNu},
   "symmetryRules" -> exampleSymmetryRules0,
   (* seedPreset/seedRanges 只保留为底层模板兼容输入；连续撒点由后面的目标包络统一控制。 *)
   "seedPreset" -> "quickCheck",
   "seedRanges" -> <|"a" -> {0}, "b" -> {0}, "isp" -> {0}|>
   |>;

(* ::Chapter:: *)
(*缺省选项与本例覆盖*)

(* 缺省：WriteInitializationFiles->False；GenerateDerivativeMetadata->False；OverwriteInitialization->False。 *)
initOptions = {
   WriteInitializationFiles -> True,
   InitializationDirectory -> FileNameJoin[{exampleDir, "init"}],
   GenerateDerivativeMetadata -> True,
   (* 本闭环例会随输入配置刷新同目录 metadata；缺省仍为 False。 *)
   OverwriteInitialization -> True
   };

(* 缺省：LinearSystemMode->"symbolic"；CoefficientRules->Automatic；KiraOrdering->Automatic。 *)
linearOptions = {
   LinearSystemMode -> "symbolic",
   KiraOrdering -> Automatic
   };

(* 缺省：OutputDirectory->None；KiraJobOptions->Automatic；package 只写文件，不运行 Kira。 *)
kiraOptions = {
   OutputDirectory -> FileNameJoin[{exampleDir, "kira"}],
   KiraActiveBasis -> <|
     "names" -> referenceDlogNames,
     "expressions" -> (referenceDlogCandidates /. {P1 -> -P0, P2 -> -P0} /. parameterProbeRules),
     "activeIndices" -> referenceDlogActiveIndices,
     "derivativeVariables" -> {s11, P0}
     |>,
   KiraJobOptions -> <|
     "RunInitiate" -> True,
     "RunFirefly" -> True,
     "WriteKira2MathJob" -> True,
     "WriteRunScript" -> False
     |>
   };

(* ::Chapter:: *)
(*初始化、IBP 与 Kira 输入*)

context = DSInit[caseInput, Sequence @@ initOptions];
DSInfo[context]

seedData = DSSeeds[context, ApplyNumericRules -> True];
allSeeds = DSAllSeeds[seedData];
seedGroups = DSSeedGroups[seedData];
seedGroupMetadata = DSSeedGroupMetadata[seedData];
seedRangeMetadata = DSMetaSeedRange[seedGroups, referenceSeedIndices];
(* 输入描述 top 目标积分包络；程序逐组反推 seed 点域、先筛 parity，再代入数值点。 *)
generatedIBP = DSGenerateIBP[allSeeds, Sequence @@ referenceTopTargetEnvelope];
linearData = DSLinear[generatedIBP, context, Sequence @@ linearOptions];
kiraExport = DSKiraExport[linearData, Sequence @@ kiraOptions];
exportSyntaxReport = Lookup[
   kiraExport,
   "backendCoefficientSyntaxReport",
   Lookup[Lookup[kiraExport, "kiraInput", <||>], "backendCoefficientSyntaxReport", <||>]
   ];

(* ::Chapter:: *)
(*完整 Kira 结果取回、DE 与标度关系*)

kiraDir = FileNameJoin[{exampleDir, "kira"}];
requiredKiraResults = {
   FileNameJoin[{kiraDir, "kira.log"}],
   FileNameJoin[{kiraDir, "results", "Tuserweight", "kira_list.m"}],
   FileNameJoin[{kiraDir, "results", "Tuserweight", "masters"}]
   };
exportReadyQ = Lookup[kiraExport, "status", "missing"] === "ready";
reductionReadyQ = exportReadyQ && And @@ (FileExistsQ /@ requiredKiraResults);
reductionReadyQ = reductionReadyQ && Quiet[Check[
     FileDate[FileNameJoin[{kiraDir, "kira.log"}]] >= FileDate[FileNameJoin[{kiraDir, "dsibp-export-manifest.wl"}]],
     False
     ]];

closedLoopResult = If[
   reductionReadyQ,
   reductionData = DSKiraImport[kiraDir, context];
   deData = DSDE[
     reductionData,
     {s11, P0},
     OutputDirectory -> FileNameJoin[{exampleDir, "results", "dlogDE"}]
     ];
   scaleData = DSScaleCheck[
     deData,
     <|
      "relation" -> "PureMassiveBubble",
      "variables" -> {s11, P0},
      (* ks d/dks = 2 s11 d/ds11。 *)
      "weights" -> {2, 1}
      |>
     ];
   <|"status" -> scaleData["status"], "reduction" -> reductionData, "de" -> deData, "scaling" -> scaleData|>,
   <|"status" -> If[exportReadyQ, "awaitingExternalKira", "exportNotReady"],
    "requiredFiles" -> requiredKiraResults|>
   ];

closedLoopSummary = If[
   reductionReadyQ,
   <|
    "status" -> Lookup[closedLoopResult, "status", "missing"],
    "exportStatus" -> Lookup[kiraExport, "status", "missing"],
    "exportReason" -> Lookup[kiraExport, "reason", None],
    "parameterProbeSeed" -> parameterProbeSeed,
    "parameterProbeRules" -> parameterProbeRules,
    "numericRulesAppliedBeforeSeeds" -> Lookup[Lookup[kiraExport, "dSIBPExportManifest", <||>], "numericRulesAppliedBeforeSeeds", False],
    "exportSyntaxBadStrings" -> Take[DeleteDuplicates[Lookup[exportSyntaxReport, "badStrings", {}]], UpTo[8]],
    "reductionStatus" -> Lookup[reductionData, "status", "missing"],
    "masterCount" -> Length[Lookup[reductionData, "masters", {}]],
    "deStatus" -> Lookup[deData, "status", "missing"],
    "deResidualCounts" -> Map[Length, Lookup[deData, "residualIntegrals", <||>]],
    "scalingStatus" -> Lookup[scaleData, "status", "missing"],
    "scalingReason" -> Lookup[scaleData, "reason", None]
    |>,
   <|
    "status" -> If[exportReadyQ, "awaitingExternalKira", "exportNotReady"],
    "exportStatus" -> Lookup[kiraExport, "status", "missing"],
    "exportReason" -> Lookup[kiraExport, "reason", None],
    "parameterProbeSeed" -> parameterProbeSeed,
    "parameterProbeRules" -> parameterProbeRules,
    "exportSyntaxBadStrings" -> Take[DeleteDuplicates[Lookup[exportSyntaxReport, "badStrings", {}]], UpTo[8]],
    "requiredFiles" -> requiredKiraResults
    |>
   ];
Print["017 pure massive bubble closed-loop summary: ", closedLoopSummary];

If[! exportReadyQ, Exit[1]];

closedLoopResult
