(* ::Package:: *)
(* 015 高层 root-coordinate seed/linear/Kira-export/DE 与 loop-to-tree 零点显式系数专项。 *)

(* ::Chapter:: *)
(*加载 package 与 loop family*)

checkDir = DirectoryName[$InputFileName];
codeDir = DirectoryName[checkDir];
packageDir = FileNameJoin[{codeDir, "015_dSIBP"}];
If[! MemberQ[$Path, packageDir], AppendTo[$Path, packageDir]];
Needs["dSIBP`"];
DSMessagesOff[];

loopCase = <|
   "name" -> "015WorkflowPureMasslessBubble",
   "vertexData" -> {{v1, "+"}, {v2, "+"}},
   "lineData" -> {
     <|"id" -> 1, "endpoints" -> {v1, v2}, "momentum" -> q,
       "nu" -> 0, "bbType" -> "exp", "massType" -> "massless"|>,
     <|"id" -> 2, "endpoints" -> {v1, v2}, "momentum" -> q - k,
       "nu" -> 0, "bbType" -> "exp", "massType" -> "massless"|>
     },
   "loopMomenta" -> {q},
   "externalMomenta" -> {k},
   "vertexEnergies" -> <|v1 -> E1, v2 -> E2|>,
   "zeroPointRules" -> {
     a0[v1] -> alpha1, a0[v2] -> alpha2,
     b0[1] -> beta1, b0[2] -> beta2,
     bS0[1] -> beta1, bS0[2] -> beta2
     },
   "numericRules" -> {
     dim -> 3, ss11 -> 5, E1 -> 7, E2 -> 11,
     alpha1 -> 0, alpha2 -> 0, beta1 -> 0, beta2 -> 0
     },
   "symmetryRules" -> {},
   "seedPreset" -> "quickCheck",
   "seedRanges" -> <|"a" -> {0, 1}, "b" -> {0}, "isp" -> {0}, "sampleOnly" -> False|>,
   "seedOptions" -> <|"MaxSeedRuleCount" -> 500, "MaxEquationCount" -> 500|>
   |>;

loopContext = DSInit[loopCase];
seedData = DSSeeds[loopContext, DiscreteMode -> "all"];
linearData = DSLinear[
   seedData,
   loopContext,
   LinearSystemMode -> "numeric",
   CoefficientRules -> Automatic
   ];

outputDir = FileNameJoin[{codeDir, "test", "results_test", "015_workflow_smoke", "kira"}];
exportData = DSKiraExport[
   linearData,
   OutputDirectory -> outputDir,
   KiraJobOptions -> <|
     "RunInitiate" -> True,
     "RunFirefly" -> False,
     "WriteKira2MathJob" -> False,
     "AppendNumericDummyEquation" -> Automatic
     |>
   ];

(* 小型 parser fixture 模拟 Kira 已把 3..N 全部约到有序 masters {1,2}；package 本身不运行 reduction。 *)
resultsDir = FileNameJoin[{outputDir, "results"}];
If[! DirectoryQ[resultsDir], CreateDirectory[resultsDir, CreateIntermediateDirectories -> True]];
integralCount = exportData["integralCount"];
fixtureReductionRules = Table[
   Tuserweight[id] -> (id + 1) Tuserweight[1] - (id - 1) Tuserweight[2],
   {id, 3, integralCount}
   ];
Put[fixtureReductionRules, FileNameJoin[{resultsDir, "kira_list.m"}]];
Export[FileNameJoin[{resultsDir, "masters"}], "1 #\n2 #\n", "Text"];
Export[FileNameJoin[{outputDir, "kira.log"}], "Kira finished successfully\n", "Text"];
importData = DSKiraImport[outputDir, loopContext];
deDir = FileNameJoin[{codeDir, "test", "results_test", "015_workflow_smoke", "results", "dlogDE"}];
deData = DSDE[importData, Automatic, OutputDirectory -> deDir];
legacyLoopCase = Join[
   loopCase,
   <|
    "name" -> "015WorkflowPureMasslessBubbleSquaredCoordinate",
    "externalInvariantRules" -> {sp[k, k] -> s11},
    "numericRules" -> {
      dim -> 3, s11 -> 25, E1 -> 7, E2 -> 11,
      alpha1 -> 0, alpha2 -> 0, beta1 -> 0, beta2 -> 0
      }
    |>
   ];
legacyLoopContext = DSInit[
   legacyLoopCase,
   RegisterAsCurrent -> False,
   ProgressReporting -> False
   ];
(* reduction rules 和 master 顺序保持不变，只替换 family 的公开动力学坐标。 *)
legacyReductionData = Join[importData, <|"context" -> legacyLoopContext|>];
legacyDEData = DSDE[legacyReductionData, {s11}, ProgressReporting -> False];
rootVsSquaredMatrixResidual = Map[
   Together[Expand[#]] &,
   deData["matrices", ss11] -
    2 ss11 (legacyDEData["matrices", s11] /. s11 -> ss11^2),
   {2}
   ];
rootVsSquaredSourceResidual = Together /@ Expand[
    deData["sources", ss11] -
     2 ss11 (legacyDEData["sources", s11] /. s11 -> ss11^2)
    ];
manualResidualDegree = dim - alpha1 - alpha2 - beta1 - beta2 - 1;
scaleProbeDE = Join[
   deData,
   <|
    "status" -> "generated",
    "variables" -> {scaleX},
    "matrices" -> <|scaleX -> (manualResidualDegree/scaleX) IdentityMatrix[2]|>,
    "sources" -> <|scaleX -> {0, 0}|>
    |>
   ];
scaleData = DSScaleCheck[
   scaleProbeDE,
   <|"relation" -> "PureMassiveBubble", "variables" -> {scaleX}, "weights" -> {1}|>
   ];

(* ::Chapter:: *)
(*非零零点的 pure-time/tree 投影*)

treeCase = <|
   "name" -> "015TreeZeroPointProjection",
   "vertexData" -> {{u1, "+"}, {u2, "+"}},
   "lineData" -> {
     <|"id" -> 1, "endpoints" -> {u1, u2}, "momentum" -> ell12,
       "treeEnergy" -> k12, "nu" -> nu12, "bbType" -> "h", "massType" -> "massive"|>
     },
   "loopMomenta" -> {ell12},
   "externalMomenta" -> {},
   "vertexEnergies" -> <|u1 -> K1, u2 -> K2|>,
   "zeroPointRules" -> {a0[u1] -> alpha1, a0[u2] -> alpha2, b0[1] -> beta12},
   "shrinkPrefactorRules" -> {Exp[Pi Im[nu12]] -> eta12},
   "seedPreset" -> "quickCheck"
   |>;

treeContext = DSInit[treeCase];
treeRecords = Flatten@Table[
    DSTreeSeeds[vertex, J[{a1, a2}, {{b12, n1, n2}}, {}], treeContext],
    {vertex, {u1, u2}}, {n1, 0, 1}, {n2, 0, 1}
    ];
treeSeeds = Lookup[treeRecords, "treeSeed"];
treeLinearData = Lookup[treeRecords, "treeLinearData"];
treePowerAudits = Flatten[Lookup[Flatten[Lookup[treeLinearData, "terms"]], "physicalPowerAudits", {}], 1];
treeDLog = DSTreeDLogDE[treeContext];
treeFamilies = dSIBP`Private`dsTreeFamilyContext[treeContext];
treeBaseIntegral = First[Cases[treeRecords[[1, "treeIntegral"]], _J, {0, Infinity}]];
treeTarget = J[ReplacePart[First[treeBaseIntegral], {{1, 1} -> -1, {2, 1} -> 0}]];
treeReduced = repIterative[treeTarget, {0, 0}, treeContext];

(* ::Section::Closed:: *)
(*三条 massive 线 simultaneous contact 的零点与显式系数*)

tripleCase = <|
   "name" -> "015TripleMassiveContactProjection",
   "vertexData" -> {{w1, "+"}, {w2, "+"}},
   "lineData" -> {
     <|"id" -> 1, "endpoints" -> {w1, w2}, "momentum" -> q1,
       "treeEnergy" -> k1, "nu" -> nu1, "bbType" -> "h", "massType" -> "massive"|>,
     <|"id" -> 2, "endpoints" -> {w1, w2}, "momentum" -> q2,
       "treeEnergy" -> k2, "nu" -> nu2, "bbType" -> "h", "massType" -> "massive"|>,
     <|"id" -> 3, "endpoints" -> {w1, w2}, "momentum" -> q1 + q2,
       "treeEnergy" -> k3, "nu" -> nu3, "bbType" -> "h", "massType" -> "massive"|>
     },
   "loopMomenta" -> {q1, q2},
   "externalMomenta" -> {},
   "vertexEnergies" -> <|w1 -> L1, w2 -> L2|>,
   "zeroPointRules" -> {a0[w1] -> gamma1, a0[w2] -> gamma2,
     b0[1] -> delta1, b0[2] -> delta2, b0[3] -> delta3},
   "seedPreset" -> "quickCheck"
   |>;

tripleContext = DSInit[tripleCase];
tripleRecord = DSTreeSeeds[
   w1,
   J[{c1, c2}, {{d1, 1, 0}, {d2, 1, 0}, {d3, 1, 0}}, {}],
   tripleContext
   ];
tripleTerms = Lookup[tripleRecord["treeLinearData"], "terms", {}];
tripleContactTerms = Select[tripleTerms, Lookup[#, "sectorKey", ""] === "e1_e2_e3" &];
tripleContactAudits = Flatten[Lookup[tripleContactTerms, "physicalPowerAudits", {}], 1];

(* ::Chapter:: *)
(*工作流门禁*)

checks = <|
   "seedGenerated" -> Lookup[seedData, "status", "missing"] === "generated",
   "seedCanonical" -> TrueQ[Lookup[seedData, "completeCanonicalQ", False]],
   "allReachableSectors" -> Sort[Lookup[Lookup[seedData, "sectorMetadataList", {}], "sectorKey", {}]] === {"e1", "e2", "top"},
   "linearGenerated" -> Lookup[linearData, "status", "missing"] === "generated",
   "linearQ" -> TrueQ[Lookup[linearData, "linearQ", False]],
   "numericLinear" -> TrueQ[Lookup[linearData, "numericCoefficientSystemQ", False]],
   "exportReady" -> Lookup[exportData, "status", "missing"] === "ready",
   "packageDoesNotRunReduction" -> ! FileExistsQ[FileNameJoin[{outputDir, "run.sh"}]],
   "exportManifestWritten" -> FileExistsQ[FileNameJoin[{outputDir, "dsibp-export-manifest.wl"}]],
   "exportManifestHash" -> Lookup[exportData["dSIBPExportManifest", "context"], "inputHash", Missing["inputHash"]] === loopContext["inputHash"],
   "projectionConventionSerialized" -> TrueQ[Lookup[exportData["dSIBPExportManifest", "loopTreeProjectionConvention"], "removedLineZeroPointsBecomeExplicitEnergyPowers", False]],
   "imported" -> Lookup[importData, "status", "missing"] === "imported",
   "importValidation" -> Lookup[importData["validationReport"], "status", "missing"] === "passed",
   "masterOrder" -> Lookup[importData, "masterIDs", {}] === {1, 2},
   "reductionUsesJ" -> ! FreeQ[Lookup[importData, "reductionRules", {}], _J] && FreeQ[Lookup[importData, "reductionRules", {}], Tuserweight],
   "sourceHashPreserved" -> Lookup[importData["sourceManifest", "context"], "inputHash", Missing["inputHash"]] === loopContext["inputHash"],
   "deGenerated" -> Lookup[deData, "status", "missing"] === "generated",
   "deUsesRootCoordinates" -> Lookup[deData, "variables", {}] === {ss11, E1, E2},
   "deMasterOrder" -> Lookup[deData, "masters", {}] === Lookup[importData, "masters", {"missing"}],
   "deMatrixDimensions" -> And @@ (Dimensions[#] === {2, 2} & /@ Values[Lookup[deData, "matrices", <||>]]),
    "deNoResidualIntegrals" -> And @@ (# === {} & /@ Values[Lookup[deData, "residualIntegrals", <||>]]),
    "legacySquaredDEGenerated" -> Lookup[legacyDEData, "status", "missing"] === "generated",
    "rootSquaredDEMatrixChainRule" -> rootVsSquaredMatrixResidual === ConstantArray[0, {2, 2}],
    "rootSquaredDESourceChainRule" -> rootVsSquaredSourceResidual === ConstantArray[0, 2],
   "deFilesPaired" -> And @@ (FileExistsQ[FileNameJoin[{deDir, #}]] & /@ {"masters.wl", "de.wl", "manifest.wl"}),
   "scalePassed" -> Lookup[scaleData, "status", "missing"] === "passed",
   "scaleZeroPointsIncluded" -> Lookup[scaleData, "degrees", {}] === ConstantArray[manualResidualDegree, 2],
   "scaleSymbolic" -> TrueQ[Lookup[scaleData, "symbolicQ", False]],
   "treeRecordsGenerated" -> And @@ (Lookup[#, "status", "missing"] === "generated" & /@ treeRecords),
   "treeLinearDataGenerated" -> And @@ (Lookup[#, "status", "missing"] === "generated" & /@ treeLinearData),
   "treeTaggedExpressionExact" -> And @@ MapThread[Together[Expand[#1["expression"] - #2]] === 0 &, {treeLinearData, treeSeeds}],
   "treeSectorTags" -> Sort[DeleteDuplicates[Flatten[Lookup[treeLinearData, "sectorKeys"]]]] === {"e1", "top"},
   "treePhysicalPowerAudit" -> And @@ (TrueQ[Lookup[#, "unsafePowerExpand", True] === False] && TrueQ[Lookup[#, "projectionCoefficientMatchesAudit", False]] & /@ treePowerAudits),
   "treeTaggedContactCoefficient" -> ! FreeQ[Select[Flatten[Lookup[treeLinearData, "terms"]], Lookup[#, "sectorKey", ""] === "e1" &], k12^(-1 - 2 nu12)],
   "a0PreservedAsTreeNu0" -> Lookup[treeContext["conventions"], "zeroPointRules", {}] === treeCase["zeroPointRules"] &&
     Lookup[treeFamilies["topFamily", "vertices"], "nu0"] === {alpha1, alpha2} &&
     Lookup[treeFamilies["families"][[2, "vertices"]], "nu0"] === {alpha1 + alpha2 - 2 nu12},
   "hContactFullEnergyPower" -> ! FreeQ[treeSeeds, k12^(-1 - 2 nu12)],
   "b0NotLeftAsTreeIndex" -> FreeQ[treeSeeds, beta12],
   "singleContactZeroPointAudit" -> AnyTrue[
     Flatten[Lookup[Select[Flatten[Lookup[treeLinearData, "terms"]], Lookup[#, "sectorKey", ""] === "e1" &], "physicalPowerAudits", {}], 1],
     Lookup[#, "deltaLineIntegerPowers", {}] === {1} &&
       Lookup[#, "deltaLineZeroPointPowers", {}] === {2 nu12} &&
       Lookup[#, "deltaLinePhysicalPowers", {}] === {1 + 2 nu12} &&
       Lookup[#, "explicitEnergyPowers", {}] === {-1 - 2 nu12} &
     ],
   "tripleContactGenerated" -> Length[tripleContactTerms] > 0,
   "tripleContactZeroPointAudit" -> AnyTrue[
     tripleContactAudits,
     Lookup[#, "deltaLineIntegerPowers", {}] === {1, 1, 1} &&
       Lookup[#, "deltaLineZeroPointPowers", {}] === {2 nu1, 2 nu2, 2 nu3} &&
       Lookup[#, "explicitEnergyPowers", {}] === {-1 - 2 nu1, -1 - 2 nu2, -1 - 2 nu3} &&
       Lookup[Lookup[#, "target", <||>], "treeNu0", {}] === {gamma1 + gamma2 - 2 nu1 - 2 nu2 - 2 nu3} &
     ],
   "tripleContactCoefficientProduct" -> AnyTrue[
     tripleContactTerms,
     ! FreeQ[Lookup[#, "projectionCoefficient", 0],
       k1^(-1 - 2 nu1) k2^(-1 - 2 nu2) k3^(-1 - 2 nu3)] &
     ],
   "treeDLogContextAPI" -> Lookup[treeDLog, "status", "missing"] === "generated" &&
     Lookup[treeDLog, "masterCount", 0] === 5 && Lookup[treeDLog, "matrixDimension", {}] === {5, 5} &&
     Lookup[treeDLog, "sectorOrder", {}] === {"top", "e1"} &&
     Lookup[treeDLog, "connectionStructure", ""] === "sectorDAGBlockTriangular" &&
     Lookup[treeDLog, "offDiagonalSourceStatus", ""] === "assembledFromLoopTimeIBP" &&
     TrueQ[Lookup[treeDLog, "dlogQ", False]] &&
     Expand[treeDLog["omegaBlocks"][[1, 2]]] =!= ConstantArray[0, {4, 1}] &&
     Expand[treeDLog["omegaBlocks"][[2, 1]]] === ConstantArray[0, {1, 4}] &&
     Keys[Lookup[treeDLog, "sectorNormalizations", <||>]] === {"top", "e1"} &&
     FreeQ[treeDLog, _Table] &&
     Cases[treeDLog, Missing[KeyAbsent, _], Infinity] === {},
   "treeIterativeContextAPI" -> FreeQ[treeReduced, $Failed] && FreeQ[treeReduced, J[packs_List] /; AnyTrue[packs, First[#] =!= 0 &]],
   "noUnsafePowerExpand" -> FreeQ[DownValues[dSIBP`Private`loopTreeProjectionCoefficient], PowerExpand]
   |>;

Print["015 workflow smoke check: ", Count[Values[checks], True], "/", Length[checks]];
If[! And @@ Values[checks],
 Print[Select[checks, Not]];
 Print["linearCoefficientVariables=", Lookup[linearData, "coefficientVariables", Missing["coefficientVariables"]]];
 Print["deStatus=", Lookup[deData, "status", Missing["status"]], ", residuals=", Lookup[deData, "residualIntegrals", Missing["residualIntegrals"]]];
 Print["treeDLogStatus=", Lookup[treeDLog, "status", Missing["status"]], ", reason=", Lookup[treeDLog, "reason", Missing["reason"]],
  ", sectors=", Lookup[treeDLog, "sectorOrder", Missing["sectorOrder"]],
  ", masters=", Lookup[treeDLog, "masterCount", Missing["masterCount"]], ", dimensions=", Lookup[treeDLog, "matrixDimension", Missing["matrixDimension"]],
  ", missing=", DeleteDuplicates[Cases[treeDLog, item_Missing :> item, Infinity]]];
 Print["treeDLog contact diagnostics=", Short[Lookup[treeDLog, "contactData", Missing["contactData"]], 5]];
 Print["treeBaseIntegral=", InputForm[treeBaseIntegral], ", treeTarget=", InputForm[treeTarget], ", treeReduced=", InputForm[treeReduced]];
 Exit[1]
 ];
