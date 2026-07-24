(* ::Package:: *)
(* Mixed massive/massless 示例：用 017 统一三参数公开入口完成离散模板、连续撒点和 linearData。 *)

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
   "seedPreset" -> "quickCheck"
   |>;


(* ::Chapter:: *)
(*缺省选项*)

(* 缺省不写初始化文件、不生成导数 metadata；DSSeeds 始终完整枚举离散态。 *)
initOptions = {WriteInitializationFiles -> False, GenerateDerivativeMetadata -> False};
linearOptions = {LinearSystemMode -> "symbolic"};


(* ::Chapter:: *)
(*公开工作流*)

context = DSInit[case, Sequence @@ initOptions];
templateSeedData = DSSeeds[context, GenerateShrinkSectors -> True];
allSeeds = DSAllSeeds[templateSeedData];

(* 统一范围：所有 general 连续指标都取 0。 *)
seedData = DSGenerateIBP[allSeeds, {0, 0}];

(* 精细范围：必须把 allSeeds 中实际出现的连续指标逐个完整覆盖。 *)
continuousIndices = DeleteDuplicates@Flatten[Lookup[allSeeds, "continuousIndices", {}], Infinity];
detailedRanges = ({#, 0, 0} & /@ continuousIndices);
seedDataDetailed = generateIBP[allSeeds, Sequence @@ detailedRanges];

linearData = DSLinear[seedData, context, Sequence @@ linearOptions];
kiraPlan = DSKiraPlan[linearData, <|
    "stage" -> "preReduction",
    "candidateIntegrals" -> Take[Lookup[linearData, "integralList", {}], UpTo[3]]
    |>];

summary = <|
   "initStatus" -> Lookup[context, "status", "missing"],
   "sectorCount" -> Length[Lookup[context, "sectors", {}]],
   "templateStatus" -> Lookup[templateSeedData, "dSIBPStatus", "missing"],
   "templateCount" -> Length[allSeeds],
   "seedStatus" -> Lookup[seedData, "dSIBPStatus", "missing"],
   "equationCount" -> Lookup[seedData, "equationCount", Missing["NotAvailable"]],
   "uniformDetailedEqual" -> (Lookup[seedData, "equations", {}] === Lookup[seedDataDetailed, "equations", {}]),
   "linearStatus" -> Lookup[linearData, "dSIBPStatus", "missing"],
   "kiraPlanStatus" -> Lookup[kiraPlan, "status", "missing"]
   |>;

Print[summary];
If[! And[
    ToString[$dSIBPVersion] === currentVersion,
    summary["initStatus"] === "initialized",
    summary["templateStatus"] === "generated",
    summary["seedStatus"] === "generated",
    TrueQ[summary["uniformDetailedEqual"]],
    summary["linearStatus"] === "generated",
    summary["kiraPlanStatus"] === "planned"
    ], Exit[1]];
