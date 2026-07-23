(* ::Package:: *)
(* 016 pure-time 示例：两顶点同号 massive line 的 direct tree 路线，以及 atomic
   massless line 保留逐线 n 状态的 canonical 路线。两者都不生成 momentum IBP。 *)

(* ::Chapter:: *)
(*加载标准 package*)

exampleDir = DirectoryName[$InputFileName];
Get[FileNameJoin[{exampleDir, "..", "load_current_package.wl"}]];


(* ::Chapter:: *)
(*详细物理输入*)

(* 图论圈数为零，因此缺省就是 timeOnly。这里仍显式写出模式，作为用户输入模板。
   p12 是 lineData 中实际出现的独立无圈动量；程序只为其模长建立 sE1。
   treeEnergy=k12 是 time-IBP/dlog 公式使用的物理线能量。 *)
treeCaseInput = <|
   "name" -> "016TreeTwoVertexPlusPlus",
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

(* masslessFull 的单个有向 n 属于整条 line，不能塞进某一个 vertex pack。
   DSSeeds 会自动保留三槽 fixed line-pack 表示，不需要私有状态选项。 *)
atomicMasslessInput = <|
   "name" -> "016AtomicMasslessTimeOnly",
   "vertexData" -> {{u1, "+"}, {u2, "+"}},
   "lineData" -> {
     <|"id" -> 1, "endpoints" -> {u1, u2}, "momentum" -> pM,
       "nu" -> 0, "bbType" -> "exp", "massType" -> "massless"|>
     },
   "loopMomenta" -> {},
   "loopExternalMomenta" -> {},
   "independentExternalMomenta" -> {pM},
   "ibpMode" -> "timeOnly",
   "vertexEnergies" -> <|u1 -> EM1, u2 -> EM2|>,
   "ispData" -> {},
   "zeroPointRules" -> {a0[u1] -> gamma1, a0[u2] -> gamma2, b0[1] -> deltaM},
   "symmetryRules" -> {},
   "seedPreset" -> "fullDiscrete"
   |>;


(* ::Chapter:: *)
(*缺省选项*)

(* 缺省为 WriteInitializationFiles->False、GenerateDerivativeMetadata->False、
   OverwriteInitialization->False、RegisterAsCurrent->True、ProgressReporting->Automatic。 *)
treeInitOptions = {
   WriteInitializationFiles -> True,
   InitializationDirectory -> FileNameJoin[{exampleDir, "init"}],
   GenerateDerivativeMetadata -> False,
   OverwriteInitialization -> True,
   ProgressReporting -> True
   };

(* 缺省：repIterative 的终点为每个顶点 a=0；这里显式给出相同终点。 *)
treeReductionEndpoint = {0, 0};


(* ::Chapter:: *)
(*原生 pure-time seeds 与 linearData*)

DSMessagesOn[];
treeContext = DSInit[treeCaseInput, Sequence @@ treeInitOptions];
treeSeedBatch = DSSeeds[treeContext, ProgressReporting -> True];
treeLinearData = DSLinear[treeSeedBatch, treeContext, ProgressReporting -> True];

atomicContext = DSInit[
   atomicMasslessInput,
   RegisterAsCurrent -> False,
   WriteInitializationFiles -> False,
   GenerateDerivativeMetadata -> False,
   ProgressReporting -> True
   ];
atomicSeedBatch = DSSeeds[
   atomicContext,
   DiscreteMode -> "all",
   ProgressReporting -> True
   ];
atomicLinearData = DSLinear[atomicSeedBatch, atomicContext, ProgressReporting -> True];
atomicStates = DeleteDuplicates@Flatten[
    Lookup[Lookup[atomicSeedBatch, "equations", {}], "discreteRules", {}]
    ];
atomicSectors = Sort@Lookup[Lookup[atomicSeedBatch, "sectorMetadataList", {}], "sectorKey", {}];

selectedIntegral = J[{{1, 1}, {0, 0}}];
selectedSeed = DSTreeSeeds[v1, selectedIntegral, treeContext];


(* ::Chapter:: *)
(*迭代约化、naive IBP/DE 与公式型 dlog DE*)

treeTarget = J[{{-1, 1}, {0, 0}}];
treeReduction = repIterative[treeTarget, treeReductionEndpoint, treeContext];
treeDLog = DSTreeDLogDE[treeContext];

treeDEVariables = {E1, E2, k12};
treeNaiveIBP = DSTreeNaiveIBP[treeContext, treeDLog["masters"], ProgressReporting -> True];
treeNaiveDE = DSTreeNaiveDE[treeNaiveIBP, treeDEVariables, ProgressReporting -> True];
treeDEResiduals = Association@Table[
    variable -> (Together /@ Flatten[treeNaiveDE["matrices", variable] - D[treeDLog["omega"], variable]]),
    {variable, treeDEVariables}
    ];
treeDERoutesAgree = And @@ Flatten[Map[TrueQ[# === 0] &, Values[treeDEResiduals], {2}]];

summary = <|
   "version" -> $dSIBPVersion,
   "initStatus" -> Lookup[treeContext, "status", "missing"],
   "seedRepresentation" -> Lookup[treeSeedBatch, "representation", Missing["representation"]],
   "linearRepresentation" -> Lookup[treeLinearData, "representation", Missing["representation"]],
   "selectedSeedRoute" -> Lookup[selectedSeed, "generationRoute", Missing["route"]],
   "iterativeReductionFreeOfFailure" -> FreeQ[treeReduction, $Failed],
   "dlogStatus" -> Lookup[treeDLog, "status", "missing"],
   "naiveIBPStatus" -> Lookup[treeNaiveIBP, "status", "missing"],
   "naiveDEStatus" -> Lookup[treeNaiveDE, "status", "missing"],
   "deRoutesAgree" -> treeDERoutesAgree,
   "masters" -> Lookup[treeDLog, "masters", {}],
   "atomicInitStatus" -> Lookup[atomicContext, "status", "missing"],
   "atomicSeedStatus" -> Lookup[atomicSeedBatch, "status", "missing"],
   "atomicRepresentation" -> Lookup[atomicSeedBatch, "representation", Missing["representation"]],
   "atomicStates" -> atomicStates,
   "atomicSectors" -> atomicSectors,
   "atomicLinearStatus" -> Lookup[atomicLinearData, "status", "missing"]
   |>;

Print[InputForm[summary]];
If[! And[
    ToString[summary["version"]] === currentVersion,
    summary["initStatus"] === "initialized",
    summary["seedRepresentation"] === "J[vertexPacks]",
    summary["linearRepresentation"] === "sectorTaggedJ[vertexPacks]",
    summary["selectedSeedRoute"] === "directPureTime",
    summary["iterativeReductionFreeOfFailure"],
    summary["dlogStatus"] === "generated",
    summary["naiveIBPStatus"] === "solved",
    summary["naiveDEStatus"] === "generated",
    summary["deRoutesAgree"],
    summary["atomicInitStatus"] === "initialized",
    summary["atomicSeedStatus"] === "generated",
    summary["atomicRepresentation"] === "J[timePowers,linePacks,isp]",
    And @@ (MemberQ[summary["atomicStates"], #] & /@ {n[1] -> 0, n[1] -> 1}),
    summary["atomicSectors"] === {"e1", "top"},
    summary["atomicLinearStatus"] === "generated"
    ], Exit[1]];
