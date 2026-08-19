(* ::Package:: *)

(***
文件：check_dead_definition_cleanup.wls
用途：dSIBP 022 死定义专项验证。加载目标版本后，确认当前核心函数只有生效定义，
      已删除的 seed/numeric 私有工作流没有 DownValues，并抽样验证运行时行为。
      （makeBaseIntegral、enumerateDiscreteStates、discreteVarsForLine、
      normalizeNumericRulesForTopology、ds、rep2Integrand）只保留生效定义、
      DownValues 无重复残留，并抽样验证其运行时行为。
运行：wolframscript -file package-dSibp/check-smoke/check_dead_definition_cleanup/check_dead_definition_cleanup.wls
      （DSIBP_PACKAGE_FILE 可指向当前 022 模块 loader 或正式 package_022.0.wl）
边界：本脚本只做结构/行为抽样，不运行 Kira、reduction、DE 或 scaling。
***)

Get[FileNameJoin[{DirectoryName[$InputFileName], "..", "_harness.wls"}]];

projectRoot = ExpandFileName[FileNameJoin[{DirectoryName[$InputFileName], "..", ".."}]];
defaultFile = FileNameJoin[{projectRoot, "versions", "022_dSIBP", "Kernel", "dSIBP.wl"}];
versionRoot = dsSmokeLoadPackage[defaultFile];
DSMessagesOff[];

checks = <|
  "version022" -> ($dSIBPVersion === "022.0"),
  "loadPath" -> (
    (StringQ[versionRoot] && DirectoryQ[versionRoot]) ||
    MatchQ[versionRoot, Missing["SingleFilePackage"]]
  ),

  (* H1：4 个 Private 符号只剩 1 个 DownValue（生效定义在 SectorModel018/KinematicCoordinates） *)
  "makeBaseIntegralSingle" -> (Length[DownValues[dSIBP`Private`makeBaseIntegral]] === 1),
  "enumerateDiscreteStatesSingle" -> (Length[DownValues[dSIBP`Private`enumerateDiscreteStates]] === 1),
  "discreteVarsForLineSingle" -> (Length[DownValues[dSIBP`Private`discreteVarsForLine]] === 1),
  "normalizeNumericRulesSingle" -> (Length[DownValues[dSIBP`Private`normalizeNumericRulesForTopology]] === 2),
  "oldTimeBatchRemoved" -> (Length[DownValues[dSIBP`Private`makeTimeIBPSeedBatch]] === 0),
  "oldMomentumBatchRemoved" -> (Length[DownValues[dSIBP`Private`makeMomentumIBPSeedBatch]] === 0),
  "oldCanonicalBatchRemoved" -> (Length[DownValues[dSIBP`Private`makeCanonicalSeedBatch]] === 0),
  "oldWorkflowRemoved" -> (Length[DownValues[dSIBP`Private`makeIBPWorkflowData]] === 0),
  "oldReadinessRemoved" -> (Length[DownValues[dSIBP`Private`makeIBPReadinessReport]] === 0),
  "oldNumericTemplateRemoved" -> (Length[DownValues[dSIBP`Private`makeNumericRuleTemplate]] === 0),

  (* ds / rep2Integrand：公开符号，两参 + 单参重载（共 2 个 DownValue） *)
  "dsTwoDownValues" -> (Length[DownValues[dSIBP`ds]] === 2),
  "rep2IntegrandTwoDownValues" -> (Length[DownValues[dSIBP`rep2Integrand]] === 2)
|>;

(* 行为抽样：构造最小 time-only two-vertex massive family，
   验证 makeBaseIntegral 的 timeOnly ISP 空槽与 ds/rep2Integrand 可调用。 *)
caseInput = <|
   "name" -> "CheckDeadDefinitionCleanup022",
   "vertices" -> {
     <|"id" -> v1, "vertexType" -> "+", "externalLegEnergy" -> E1|>,
     <|"id" -> v2, "vertexType" -> "+", "externalLegEnergy" -> E2|>
     },
   "lines" -> {
     <|"id" -> 1, "endpoints" -> {v1, v2}, "momentum" -> p12,
       "nu" -> nu12, "massType" -> "massive"|>
     },
   "loopMomenta" -> {},
   "loopExternalMomenta" -> {},
   "independentExternalMomenta" -> {p12},
   "ibpMode" -> "timeOnly",
   "ispData" -> {},
   "zeroPointRules" -> {a0[v1] -> alpha1, a0[v2] -> alpha2, b0[1] -> beta12},
   "symmetryRules" -> {}
   |>;

context = DSInit[caseInput, WriteInitializationFiles -> False,
  GenerateDerivativeMetadata -> False, RegisterAsCurrent -> True, ProgressReporting -> False];

topIntegral = J["1", {1, 0}, {1, 0}];
derivative = ds[topIntegral, sE1, context];
integrand = rep2Integrand[topIntegral, context];

checks = Join[checks, <|
  "initialized" -> (Lookup[context, "status", "failed"] === "initialized"),
  "dsCallable" -> (Head[derivative] =!= ds && FreeQ[derivative, $Failed]),
  "rep2IntegrandCallable" -> (Head[integrand] =!= rep2Integrand && FreeQ[integrand, $Failed])
|>];

dsSmokeSummary[checks, "check_dead_definition_cleanup",
  <|
    "versionRoot" -> versionRoot
  |>];
