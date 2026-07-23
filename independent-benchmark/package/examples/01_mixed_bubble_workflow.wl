(* ::Package:: *)
(* Mixed massive/massless 示例：只用 016 公开入口完成初始化、canonical seed 和 linearData。 *)

(* ::Chapter:: *)
(*加载标准 package*)

exampleDir = DirectoryName[$InputFileName];
Get[FileNameJoin[{exampleDir, "load_current_package.wl"}]];


(* ::Chapter:: *)
(*详细物理输入*)

case = <|
   "name" -> "mixedBubbleExample",
   "vertexData" -> {{v1, "+"}, {v2, "+"}},
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
   "zeroPointRules" -> {
     a0[v1] -> alpha1, a0[v2] -> alpha2,
     b0[e1] -> beta1, b0[e2] -> beta2
     },
   "symmetryRules" -> {},
   (* 成品例固定一个离散分支；全离散态覆盖属于正式 bench，不在用户入门例重复。 *)
   "sampleDiscreteRules" -> {{n[e1, 1] -> 0, n[e1, 2] -> 0, n[e2] -> 0}},
   "seedPreset" -> "quickCheck"
   |>;


(* ::Chapter:: *)
(*缺省选项*)

(* 缺省不写初始化文件、不生成导数 metadata；本例枚举全部离散态但保持最小连续范围。 *)
initOptions = {WriteInitializationFiles -> False, GenerateDerivativeMetadata -> False};
seedOptions = {DiscreteMode -> "sample", GenerateShrinkSectors -> True, MaxEquationCount -> 1000};
linearOptions = {LinearSystemMode -> "symbolic"};


(* ::Chapter:: *)
(*公开工作流*)

context = DSInit[case, Sequence @@ initOptions];
seedData = DSSeeds[context, Sequence @@ seedOptions];
linearData = DSLinear[seedData, context, Sequence @@ linearOptions];

summary = <|
   "initStatus" -> Lookup[context, "status", "missing"],
   "sectorCount" -> Length[Lookup[context, "sectors", {}]],
   "seedStatus" -> Lookup[seedData, "dSIBPStatus", "missing"],
   "equationCount" -> Lookup[seedData, "equationCount", Missing["NotAvailable"]],
   "linearStatus" -> Lookup[linearData, "dSIBPStatus", "missing"]
   |>;

Print[summary];
If[! And[
    ToString[$dSIBPVersion] === currentVersion,
    summary["initStatus"] === "initialized",
    summary["seedStatus"] === "generated",
    summary["linearStatus"] === "generated"
    ], Exit[1]];
