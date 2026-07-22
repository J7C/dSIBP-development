(* ::Package:: *)
(* Mixed massive/massless 示例：只用 014 公开入口完成初始化、canonical seed 和 linearData。 *)

(* ::Chapter:: *)
(*加载冻结 package*)

exampleDir = DirectoryName[$InputFileName];
packageDir = DirectoryName[exampleDir];
Get[FileNameJoin[{packageDir, "package_014.wl"}]];


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
   "externalMomenta" -> {k},
   "externalInvariantRules" -> {sp[k, k] -> s11},
   "vertexEnergies" -> <|v1 -> E1, v2 -> E2|>,
   "ispData" -> {},
   "zeroPointRules" -> {
     a0[v1] -> alpha1, a0[v2] -> alpha2,
     b0[e1] -> beta1, b0[e2] -> beta2
     },
   "symmetryRules" -> {},
   "seedPreset" -> "quickCheck"
   |>;


(* ::Chapter:: *)
(*缺省选项*)

(* 缺省不写初始化文件、不生成导数 metadata；本例枚举全部离散态但保持最小连续范围。 *)
initOptions = {WriteInitializationFiles -> False, GenerateDerivativeMetadata -> False};
seedOptions = {DiscreteMode -> "all", GenerateShrinkSectors -> True, MaxEquationCount -> 10000};
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
    summary["initStatus"] === "initialized",
    summary["seedStatus"] === "generated",
    summary["linearStatus"] === "generated"
    ], Exit[1]];
