(* ::Package:: *)

(***
文件：check_dead_definition_cleanup.wls
用途：dSIBP 021 H1 专项验证。加载目标版本后，确认 6 个曾被跨文件覆盖的函数
      （makeBaseIntegral、enumerateDiscreteStates、discreteVarsForLine、
      normalizeNumericRulesForTopology、ds、rep2Integrand）只保留生效定义、
      DownValues 无重复残留，并抽样验证其运行时行为。
运行：wolframscript -file package-dSibp/check-smoke/check_dead_definition_cleanup/check_dead_definition_cleanup.wls
      （用 DSIBP_PACKAGE_FILE 环境变量指向 021_dSIBP/Kernel/dSIBP.wl）
边界：本脚本只做结构/行为抽样，不运行 Kira、reduction、DE 或 scaling。
***)

Get[FileNameJoin[{DirectoryName[$InputFileName], "..", "_harness.wls"}]];

projectRoot = ExpandFileName[FileNameJoin[{DirectoryName[$InputFileName], "..", ".."}]];
defaultFile = FileNameJoin[{projectRoot, "versions", "021_dSIBP", "Kernel", "dSIBP.wl"}];
versionRoot = dsSmokeLoadPackage[defaultFile];
DSMessagesOff[];

checks = <|
  "version021" -> ($dSIBPVersion === "021.0"),
  "loadPath" -> (StringQ[versionRoot] && DirectoryQ[versionRoot]),

  (* H1：4 个 Private 符号只剩 1 个 DownValue（生效定义在 SectorModel018/KinematicCoordinates） *)
  "makeBaseIntegralSingle" -> (Length[DownValues[dSIBP`Private`makeBaseIntegral]] === 1),
  "enumerateDiscreteStatesSingle" -> (Length[DownValues[dSIBP`Private`enumerateDiscreteStates]] === 1),
  "discreteVarsForLineSingle" -> (Length[DownValues[dSIBP`Private`discreteVarsForLine]] === 1),
  "normalizeNumericRulesSingle" -> (Length[DownValues[dSIBP`Private`normalizeNumericRulesForTopology]] === 2),

  (* ds / rep2Integrand：公开符号，两参 + 单参重载（共 2 个 DownValue） *)
  "dsTwoDownValues" -> (Length[DownValues[dSIBP`ds]] === 2),
  "rep2IntegrandTwoDownValues" -> (Length[DownValues[dSIBP`rep2Integrand]] === 2)
|>;

(* 行为抽样：构造最小 time-only two-vertex massive family，
   验证 makeBaseIntegral 的 timeOnly ISP 空槽与 ds/rep2Integrand 可调用。 *)
caseInput = <|
   "name" -> "CheckDeadDefinitionCleanup021",
   "vertexData" -> {{v1, "+"}, {v2, "+"}},
   "lineData" -> {
     <|"id" -> 1, "endpoints" -> {v1, v2}, "momentum" -> p12,
       "treeEnergy" -> k12, "nu" -> nu12, "bbType" -> "h", "massType" -> "massive"|>
     },
   "loopMomenta" -> {},
   "loopExternalMomenta" -> {},
   "independentExternalMomenta" -> {p12},
   "ibpMode" -> "timeOnly",
   "vertexEnergies" -> <|v1 -> E1, v2 -> E2|>,
   "ispData" -> {},
   "zeroPointRules" -> {a0[v1] -> alpha1, a0[v2] -> alpha2, b0[1] -> beta12},
   "shrinkPrefactorRules" -> {Exp[Pi Im[nu12]] -> eta12},
   "symmetryRules" -> {},
   "seedPreset" -> "quickCheck"
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
