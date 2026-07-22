(* ::Package:: *)
(* 本正式专项验证 016 图论、用户动量声明、bridge 指标和参数重定义门禁；不写结果文件。 *)

(* ::Chapter:: *)
(*加载 016*)

testDir = DirectoryName[$InputFileName];
codeDir = DirectoryName[testDir];
packageDir = FileNameJoin[{codeDir, "016_dSIBP"}];
If[! MemberQ[$Path, packageDir], AppendTo[$Path, packageDir]];
Needs["dSIBP`"];
DSMessagesOff[];


(* ::Chapter:: *)
(*bubble 加 bridge 拓扑*)

lines = {
   <|"id" -> 1, "endpoints" -> {v1, v2}, "momentum" -> q + k0|>,
   <|"id" -> 2, "endpoints" -> {v1, v2}, "momentum" -> q + k0 + k|>,
   <|"id" -> 3, "endpoints" -> {v2, v3}, "momentum" -> p1 + p2|>
   };

exactCase = <|
   "loopMomenta" -> {q},
   "loopExternalMomenta" -> {k},
   "independentExternalMomenta" -> {p1, p2, p1 + p2},
   "ibpMode" -> "full",
   "ispData" -> {},
   "extLegs" -> {{x1, v3, p1}, {x2, v3, p2}},
   "vertexEnergies" -> <||>
   |>;

graphAudit = dSIBP`Private`ds016TopologyGraphAudit[{v1, v2, v3}, lines];
routingAudit = dSIBP`Private`ds016LoopRoutingAudit[exactCase, lines, graphAudit];
declarationAudit = dSIBP`Private`ds016MomentumDeclarationAudit[exactCase, lines, graphAudit, routingAudit];


(* ::Chapter:: *)
(*正式 parser 与 DSInit 接入*)

fullLines = Map[
   Join[#, <|"nu" -> nu, "bbType" -> "h", "massType" -> "massive"|>] &,
   lines
   ];

initCase = Join[exactCase, <|
    "name" -> "016BubbleBridgeInit",
    "vertexData" -> {{v1, "+"}, {v2, "+"}, {v3, "+"}},
    "lineData" -> fullLines,
    "zeroPointRules" -> {
      a0[v1] -> av1, a0[v2] -> av2, a0[v3] -> av3,
      b0[1] -> be1, b0[2] -> be2, b0[3] -> be3
      },
    "symmetryRules" -> {},
    "seedPreset" -> "quickCheck"
    |>];

parsedInitTopology = dSIBP`Private`parseTopology[initCase];
initContext = DSInit[initCase, RegisterAsCurrent -> False, ProgressReporting -> False];
baseIntegral = dSIBP`Private`makeBaseIntegral[parsedInitTopology];
sectorMetadata = dSIBP`Private`makeSectorMetadata[parsedInitTopology];
resolvedBaseIntegral = baseIntegral /. {
    a[_] -> 0, b[_] -> 0, bS[_] -> 0, ispN[_] -> 0,
    n[_, _] -> 0, n[_] -> 0
    };
bridgeTimeSeed = dSIBP`Private`applyTimeGeneratorSeed[
   parsedInitTopology,
   resolvedBaseIntegral,
   <|"type" -> "time", "vertex" -> v3|>
   ];
bridgeTimeSeedIntegrals = DeleteDuplicates@Cases[bridgeTimeSeed, int_J :> int, Infinity];
bridgeMomentumSeed = dSIBP`Private`applyMomentumGeneratorSeed[
   parsedInitTopology,
   resolvedBaseIntegral,
   <|"type" -> "momentum", "dLoop" -> 1, "vectorType" -> "external",
    "vectorIndex" -> 1, "vector" -> k|>
   ];
bridgeMomentumSeedIntegrals = DeleteDuplicates@Cases[bridgeMomentumSeed, int_J :> int, Infinity];
parameterNotation = DSParameterNotation[initContext];
redefinedContext = DSRedefineParameters[
   initContext,
   {
    sp[k, k] -> loopScale^2,
    sp[p1, p1] -> legScale1^2,
    sp[p2, p2] -> legScale2^2,
    sp[p1 + p2, p1 + p2] -> legScale12^2
    },
   ProgressReporting -> False
   ];
bridgeMagnitudeDerivative = ds[resolvedBaseIntegral, sE3, parsedInitTopology];
bridgeMagnitudeDerivativeIntegrals = DeleteDuplicates@Cases[bridgeMagnitudeDerivative, int_J :> int, Infinity];
bridgeIntegrand = rep2Integrand[resolvedBaseIntegral, parsedInitTopology];
bridgeContactIntegral = ReplacePart[resolvedBaseIntegral, {2, 3} -> {0, 1}];
bridgeShrunkExpression = dSIBP`Private`shrinkLineIntegral[parsedInitTopology, bridgeContactIntegral, 3];
bridgeShrunkIntegral = FirstCase[bridgeShrunkExpression, int_J :> int, Missing["NoIntegral"], Infinity];
bridgeShrunkTopology = dSIBP`Private`shrinkSectorTopology[parsedInitTopology, {3}];
bridgeShrunkPhysicalPower = dSIBP`Private`linePowerIndex[bridgeShrunkTopology, bridgeShrunkIntegral, 3];
cycleShrunkTopology = dSIBP`Private`shrinkSectorTopology[parsedInitTopology, {1}];
allCycleShrunkTopology = dSIBP`Private`shrinkSectorTopology[parsedInitTopology, {1, 2}];
treeProjectionAudit = dSIBP`Private`dsLoopTermTreeTag[resolvedBaseIntegral, parsedInitTopology, resolvedBaseIntegral];
bridgeTreeIntegral = dSIBP`Private`projectLoopIntegralToTree[
   bridgeContactIntegral, parsedInitTopology, bridgeContactIntegral
   ];
directTreeSeedRecord = DSTreeSeeds[v3, bridgeTreeIntegral, initContext];
loopProjectionSeedRecord = DSTreeSeeds[v3, bridgeContactIntegral, initContext];
directLoopSeedDifference = Expand[
   Lookup[directTreeSeedRecord, "treeSeed", $Failed] - Lookup[loopProjectionSeedRecord, "treeSeed", $Failed]
   ];


(* ::Chapter:: *)
(*过完备与欠完备*)

overCase = Join[exactCase, <|"loopExternalMomenta" -> {k, p1}|>];
overAudit = dSIBP`Private`ds016TopologyAndMomentumAudit[overCase, lines, {v1, v2, v3}];

underCase = Join[exactCase, <|"independentExternalMomenta" -> {p1, p2}|>];
underAudit = dSIBP`Private`ds016TopologyAndMomentumAudit[underCase, lines, {v1, v2, v3}];

overInitCase = Join[initCase, <|
    "independentExternalMomenta" -> {p1, p2, p1 + p2, 2 p1}
    |>];
overInitContext = DSInit[overInitCase, RegisterAsCurrent -> False, ProgressReporting -> False];

overLoopInitCase = Join[initCase, <|"loopExternalMomenta" -> {k, k0}|>];
overLoopInitContext = DSInit[overLoopInitCase, RegisterAsCurrent -> False, ProgressReporting -> False];
overLoopInverse = rep2innerform[sp[k, k], overLoopInitContext];

underInitCase = Join[initCase, <|
    "independentExternalMomenta" -> {p1, p2}
    |>];
underInitContext = DSInit[underInitCase, RegisterAsCurrent -> False, ProgressReporting -> False];

mixedRedefinitionContext = DSRedefineParameters[
   initContext,
   {
    sp[k, k] -> (u + v)^2,
    sp[p1, p1] -> (u - v)^2,
    sp[p2, p2] -> (u + w)^2,
    sp[p1 + p2, p1 + p2] -> (u + z)^2
    },
   ProgressReporting -> False
   ];
mixedContextDerivative = ds[c[u] resolvedBaseIntegral, u, mixedRedefinitionContext];
overRedefinitionContext = DSRedefineParameters[
   initContext,
   {
    sp[k, k] -> (u + v + t)^2,
    sp[p1, p1] -> (u - v)^2,
    sp[p2, p2] -> (u + w)^2,
    sp[p1 + p2, p1 + p2] -> (u + z)^2
    },
   ProgressReporting -> False
   ];

bridgeState10 = ReplacePart[resolvedBaseIntegral, {2, 3} -> {1, 0}];
bridgeState10Derivative = ds[bridgeState10, sE3, parsedInitTopology];


(* ::Chapter:: *)
(*补零命名边界*)

paddingNames = <|
   "root9" -> dSIBP`Private`externalRootSymbolName[1, 9, 9],
   "leg9" -> dSIBP`Private`externalLegRootSymbolName[9, 9],
   "root10Diagonal" -> dSIBP`Private`externalRootSymbolName[1, 1, 10],
   "root10OffDiagonal" -> dSIBP`Private`externalRootSymbolName[1, 10, 10],
   "leg10" -> dSIBP`Private`externalLegRootSymbolName[1, 10],
   "root100" -> dSIBP`Private`externalRootSymbolName[1, 100, 100],
   "leg100" -> dSIBP`Private`externalLegRootSymbolName[1, 100],
   "legacy10" -> dSIBP`Private`externalInvariantSymbolName[1, 10, 10]
   |>;


(* ::Chapter:: *)
(*图论与路由边界*)

wrongLoopCountCase = Join[exactCase, <|"loopMomenta" -> {}|>];
wrongLoopCountAudit = dSIBP`Private`ds016TopologyAndMomentumAudit[wrongLoopCountCase, lines, {v1, v2, v3}];

bridgeLoopLines = ReplacePart[lines, 3 -> Join[lines[[3]], <|"momentum" -> q + p1 + p2|>]];
bridgeLoopAudit = dSIBP`Private`ds016TopologyAndMomentumAudit[exactCase, bridgeLoopLines, {v1, v2, v3}];

triangleLines = {
   <|"id" -> 1, "endpoints" -> {v1, v2}, "momentum" -> q|>,
   <|"id" -> 2, "endpoints" -> {v2, v3}, "momentum" -> q + k|>,
   <|"id" -> 3, "endpoints" -> {v3, v1}, "momentum" -> k|>
   };
badCycleAudit = dSIBP`Private`ds016TopologyAndMomentumAudit[
   <|"loopMomenta" -> {q}, "loopExternalMomenta" -> {k},
    "independentExternalMomenta" -> {}, "ibpMode" -> "full"|>,
   triangleLines,
   {v1, v2, v3}
   ];

selfLoopLines = {<|"id" -> 1, "endpoints" -> {v1, v1}, "momentum" -> q + alice - bob|>};
selfLoopGraph = dSIBP`Private`ds016TopologyGraphAudit[{v1}, selfLoopLines];

parallelGraph = dSIBP`Private`ds016TopologyGraphAudit[{v1, v2}, Take[lines, 2]];

namedMomentumLines = {
   <|"id" -> 1, "endpoints" -> {v1, v2}, "momentum" -> q + alice - bob|>,
   <|"id" -> 2, "endpoints" -> {v1, v2}, "momentum" -> q + alice - bob + carol|>
   };
namedMomentumAudit = dSIBP`Private`ds016TopologyAndMomentumAudit[
   <|"loopMomenta" -> {q}, "loopExternalMomenta" -> {carol},
    "independentExternalMomenta" -> {}, "ibpMode" -> "full"|>,
   namedMomentumLines,
   {v1, v2}
   ];

signedReorderedLines = {
   Join[lines[[2]], <|"momentum" -> -Lookup[lines[[2]], "momentum"]|>],
   Join[lines[[1]], <|"momentum" -> -Lookup[lines[[1]], "momentum"]|>],
   lines[[3]]
   };
signedReorderedAudit = dSIBP`Private`ds016TopologyAndMomentumAudit[exactCase, signedReorderedLines, {v1, v2, v3}];

timeOnlyCase = Join[exactCase, <|
    "loopMomenta" -> {},
    "loopExternalMomenta" -> {},
    "independentExternalMomenta" -> {q + k0, q + k0 + k, p1, p2, p1 + p2},
    "ibpMode" -> "timeOnly"
    |>];
timeOnlyAudit = dSIBP`Private`ds016TopologyAndMomentumAudit[timeOnlyCase, lines, {v1, v2, v3}];


(* ::Chapter:: *)
(*断言*)

checks = <|
   "version" -> SameQ[$dSIBPVersion, "016"],
   "graphLoopCount" -> SameQ[Lookup[graphAudit, "graphLoopCount"], 1],
   "bridgeClassification" -> SameQ[Lookup[graphAudit, "bridgeLineIndices"], {3}],
   "cycleClassification" -> SameQ[Lookup[graphAudit, "cycleLineIndices"], {1, 2}],
   "routingValid" -> SameQ[Lookup[routingAudit, "status"], "valid"],
   "commonShiftRemoved" -> SameQ[Lookup[routingAudit, "shiftInvariantLineResiduals"], {0, k, p1 + p2}],
   "exactDeclarations" -> SameQ[Lookup[declarationAudit, "status"], "exact"],
   "requiredLoopDirection" -> SameQ[Lookup[declarationAudit, "requiredLoopExternalDirections"], {k}],
   "threeIndependentMagnitudes" -> SameQ[
     Lookup[Lookup[declarationAudit, "independentExternalAudit"], "requiredIndependentMagnitudeCount"],
     3
     ],
   "parserNormalizesLoopShift" -> SameQ[Lookup[parsedInitTopology, "normalizedLineMomenta", {}], {q, q + k, p1 + p2}],
   "parserStoresCapabilities" -> TrueQ[Lookup[Lookup[parsedInitTopology, "capabilities", <||>], "initializationUsableQ", False]],
   "dsInitAcceptsExactDeclarations" -> Lookup[initContext, "status", "failed"] === "initialized",
   "bridgePackHasNoB" -> baseIntegral[[2, 3]] === {n[3, 1], n[3, 2]} && FreeQ[baseIntegral[[2, 3]], _b | _bS],
   "metadataIndexesOnlyCyclePowers" -> Sort[Values[Lookup[sectorMetadata, "bSymbolToLineSlot", <||>]]] === {1, 2},
   "bridgeTimeSeedWellShaped" -> FreeQ[bridgeTimeSeed, $Failed] &&
     And @@ (MemberQ[{0, 2}, Length[#[[2, 3]]]] & /@ bridgeTimeSeedIntegrals),
   "declaredMagnitudeNotation" -> Lookup[parameterNotation, "selectedUserVariables", {}] === {ss11, sE1, sE2, sE3},
   "bridgeTimeSeedHasExplicitMagnitude" -> ! FreeQ[bridgeTimeSeed, sE3],
   "momentumSeedLeavesBridgePack" -> FreeQ[bridgeMomentumSeed, $Failed] &&
     And @@ (#[[2, 3]] === resolvedBaseIntegral[[2, 3]] & /@ bridgeMomentumSeedIntegrals),
   "parameterRedefinitionReinitializes" -> Lookup[redefinedContext, "status", "failed"] === "initialized" &&
     Lookup[DSParameterNotation[redefinedContext], "selectedUserVariables", {}] === {loopScale, legScale1, legScale2, legScale12},
   "bridgeMagnitudeDerivative" -> FreeQ[bridgeMagnitudeDerivative, $Failed] &&
     ! FreeQ[bridgeMagnitudeDerivative, sE3] &&
     And @@ (MemberQ[{0, 2}, Length[#[[2, 3]]]] & /@ bridgeMagnitudeDerivativeIntegrals),
   "bridgeIntegrandUsesFixedMagnitude" -> ! FreeQ[bridgeIntegrand, sE3] && FreeQ[bridgeIntegrand, xi[3]],
   "bridgeShrinkMovesPowerToCoefficient" -> Head[bridgeShrunkIntegral] === J &&
     bridgeShrunkIntegral[[2, 3]] === {} &&
     Together[(bridgeShrunkExpression /. bridgeShrunkIntegral -> 1) - 1/sE3] === 0,
   "bridgeShrinkPhysicalZeroPoint" -> Expand[bridgeShrunkPhysicalPower - (be3 + 2 nu)] === 0,
   "cycleShrinkPreservesLoopCount" -> AssociationQ[cycleShrunkTopology] &&
     Lookup[cycleShrunkTopology, "graphLoopCount", Missing["loopCount"]] === 1 &&
     Lookup[cycleShrunkTopology, "nL", Missing["nL"]] === 1,
   "allCycleContactsPreserveRootLoopSpace" -> AssociationQ[allCycleShrunkTopology] &&
     Lookup[allCycleShrunkTopology, "graphLoopCount", Missing["loopCount"]] === 1 &&
     Lookup[allCycleShrunkTopology, "cycleLineIndices", {}] === {1, 2} &&
     And @@ (TrueQ[dSIBP`Private`lineIndexedPowerQ[#]] & /@ allCycleShrunkTopology["lines"][[{1, 2}]]),
   "treeProjectionDoesNotReadBridgeNAsB" -> AssociationQ[treeProjectionAudit] &&
     treeProjectionAudit["physicalPowerAudit", "target", "bInteger"] === {0, 0, 0},
   "directPureTimeMatchesLoopProjection" -> TrueQ[directLoopSeedDifference === 0],
   "directPureTimeDoesNotBuildLoopSeed" -> Lookup[directTreeSeedRecord, "generationRoute", None] === "directPureTime" &&
     MatchQ[Lookup[directTreeSeedRecord, "loopSeed", None], Missing["NotUsed"]],
   "overcompleteWarns" -> SameQ[Lookup[overAudit, "status"], "overcomplete"],
   "undercompleteBlocks" -> SameQ[Lookup[underAudit, "status"], "undercomplete"] &&
     ! TrueQ[Lookup[Lookup[underAudit, "capabilities", <||>], "initializationUsableQ", True]],
   "overcompleteInitializationContinues" -> Lookup[overInitContext, "status", "failed"] === "initialized" &&
      ! TrueQ[Lookup[Lookup[overInitContext, "capabilities", <||>], "derivativeUsableQ", True]],
   "overcompleteLoopInitializationContinues" -> Lookup[overLoopInitContext, "status", "failed"] === "initialized" &&
      Lookup[Lookup[overLoopInitContext, "topology", <||>], "externalMomenta", {}] === {k} &&
      Lookup[DSParameterNotation[overLoopInitContext], "effectiveLoopExternalMomenta", {}] === {k} &&
      ! TrueQ[Lookup[Lookup[overLoopInitContext, "capabilities", <||>], "derivativeUsableQ", True]],
   "overcompleteLoopInverseRejected" -> overLoopInverse === $Failed,
   "fixedLineN1DerivativeIsResolved" -> FreeQ[bridgeState10Derivative, $Failed | dSIBP`Private`shiftVertexA],
   "mixedCoordinateJacobian" -> Lookup[mixedRedefinitionContext, "status", "failed"] === "initialized" &&
      Lookup[DSParameterNotation[mixedRedefinitionContext], "selectedUserVariables", {}] === {u, v, w, z} &&
      TrueQ[Lookup[Lookup[mixedRedefinitionContext, "capabilities", <||>], "derivativeUsableQ", False]],
   "mixedContextDerivativeProductRule" -> mixedContextDerivative =!= $Failed &&
      ! FreeQ[mixedContextDerivative, c'[u]] && FreeQ[mixedContextDerivative, kk],
   "overcompleteCoordinateDisablesDerivative" -> Lookup[overRedefinitionContext, "status", "failed"] === "initialized" &&
      ! TrueQ[Lookup[Lookup[overRedefinitionContext, "capabilities", <||>], "derivativeUsableQ", True]] &&
      ! TrueQ[Lookup[Lookup[overRedefinitionContext, "capabilities", <||>], "inverseKinematicsUsableQ", True]],
   "undercompleteInitializationRejected" -> Lookup[underInitContext, "status", "initialized"] === "failed" &&
     Lookup[underInitContext, "reason", None] === "invalidInputOrTopology",
   "paddingBoundary9" -> Lookup[paddingNames, {"root9", "leg9"}] === {ss19, sE9},
   "paddingBoundary10" -> Lookup[paddingNames,
      {"root10Diagonal", "root10OffDiagonal", "leg10", "legacy10"}] ===
     {ss0101, ss0110, sE01, s0110},
   "paddingBoundary100" -> Lookup[paddingNames, {"root100", "leg100"}] === {ss001100, sE001},
   "wrongLoopCountRejected" -> MemberQ[Lookup[wrongLoopCountAudit, "issues", {}][[All, "code"]], "loopMomentumCountMismatch"],
   "bridgeLoopMomentumRejected" -> MemberQ[Lookup[bridgeLoopAudit, "issues", {}][[All, "code"]], "bridgeCarriesLoopMomentum"],
   "badCycleSupportRejected" -> MemberQ[Lookup[badCycleAudit, "issues", {}][[All, "code"]], "loopRoutingOutsideCycleSpace"],
   "selfLoopCountsAsLoop" -> Lookup[selfLoopGraph, "graphLoopCount", 0] === 1 &&
     Lookup[selfLoopGraph, "selfLoopLineIndices", {}] === {1},
   "parallelEdgesCountAsLoop" -> Lookup[parallelGraph, "graphLoopCount", 0] === 1 &&
     Lookup[parallelGraph, "bridgeLineIndices", {-1}] === {},
   "arbitraryMomentumNames" -> Lookup[namedMomentumAudit, "status", "invalid"] === "exact" &&
     Lookup[Lookup[namedMomentumAudit, "routing", <||>], "shiftInvariantLineResiduals", {-1}] === {0, carol},
   "lineOrderAndSignInvariant" -> Lookup[signedReorderedAudit, "status", "invalid"] === "exact",
   "timeOnlySkipsLoopCountGate" -> Lookup[timeOnlyAudit, "status", "invalid"] === "exact" &&
     TrueQ[Lookup[Lookup[timeOnlyAudit, "capabilities", <||>], "timeIBPUsableQ", False]]
   |>;

Print["016 topology audit smoke: ", Count[Values[checks], True], "/", Length[checks]];
If[! And @@ Values[checks],
 Print["FAILED: ", Keys@Select[checks, ! TrueQ[#] &]];
 Print["graph: ", graphAudit];
 Print["routing: ", routingAudit];
 Print["exact: ", declarationAudit];
 Print["over: ", overAudit];
 Print["under: ", underAudit];
 Print["direct/loop seed difference: ", directLoopSeedDifference];
 Print["direct seed: ", Lookup[directTreeSeedRecord, "treeSeed", Missing["NoDirect"]]];
 Print["loop-projected seed: ", Lookup[loopProjectionSeedRecord, "treeSeed", Missing["NoLoop"]]];
 Print["init validation: ", Lookup[initContext, "validationReport", Missing["NoValidation"]]];
 Exit[1]
 ];
