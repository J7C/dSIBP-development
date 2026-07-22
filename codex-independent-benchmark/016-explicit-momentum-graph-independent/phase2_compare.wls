(* ::Chapter:: *)
(*016 frozen expected 对 package_016 的单向比较*)

(* ::Section:: *)
(*初始化与结果记录*)

ClearAll["Global`*"];
workspace = DirectoryName[$InputFileName];
packageDir = FileNameJoin[{workspace, "..", "..", "independent-benchmark", "package"}];
packageFile = FileNameJoin[{packageDir, "package_016.wl"}];
manualTextFile = FileNameJoin[{workspace, "tmp", "pdfs", "package_016_final.txt"}];
Get[packageFile];
Get[FileNameJoin[{workspace, "expected_016.wl"}]];
DSMessagesOff[];

checks = {};
zeroQ[expr_] := If[
  ListQ[expr],
  AllTrue[Flatten[expr], TrueQ[Together[#] === 0] &],
  TrueQ[Together[expr] === 0]
];
recordCheck[group_String, name_String, passed_, actual_, expected_] := AppendTo[
  checks,
  <|"group" -> group, "name" -> name, "passed" -> TrueQ[passed],
    "actual" -> actual, "expected" -> expected,
    "difference" -> If[TrueQ[passed], 0, HoldForm[actual - expected]]|>
];
checkSame[group_, name_, actual_, expected_] := recordCheck[group, name, SameQ[actual, expected], actual, expected];
checkZero[group_, name_, actual_, expected_] := Module[{difference = Together[actual - expected]},
  recordCheck[group, name, zeroQ[difference], actual, expected]
];
(* 用户变量组合表示独立模长时，只在声明的物理正支上消去 Sqrt[x^2]。 *)
checkZeroAssuming[group_, name_, actual_, expected_, assumptions_] := Module[
  {difference = Refine[Together[actual - expected], assumptions]},
  recordCheck[group, name, zeroQ[difference], actual, expected]
];
checkTrue[group_, name_, actual_] := recordCheck[group, name, TrueQ[actual], actual, True];

issueCodes[object_] := DeleteDuplicates@Cases[object, item_Association :> Lookup[item, "code", Nothing], Infinity];

(* ::Section:: *)
(*主图输入*)

mainCase = <|
  "name" -> "016IndependentBubbleBridge",
  "vertexData" -> {{v1, "+"}, {v2, "+"}, {v3, "+"}},
  "lineData" -> {
    <|"id" -> 1, "endpoints" -> {v1, v2}, "momentum" -> ell + arc,
      "nu" -> nu1, "bbType" -> "h", "massType" -> "massive"|>,
    <|"id" -> 2, "endpoints" -> {v2, v1}, "momentum" -> ell + arc + spur,
      "nu" -> nu2, "bbType" -> "h", "massType" -> "massive"|>,
    <|"id" -> 3, "endpoints" -> {v2, v3}, "momentum" -> wing1 + wing2,
      "treeEnergy" -> Sqrt[sp[wing1 + wing2, wing1 + wing2]],
      "nu" -> nu3, "bbType" -> "h", "massType" -> "massive"|>
  },
  "extLegs" -> {{leg1, v3, wing1}, {leg2, v3, wing2}},
  "loopMomenta" -> {ell},
  "loopExternalMomenta" -> {spur},
  "independentExternalMomenta" -> {wing1, wing2, wing1 + wing2},
  "ibpMode" -> "full",
  "vertexEnergies" -> <|v1 -> E1, v2 -> E2, v3 -> E3|>,
  "ispData" -> {},
  "zeroPointRules" -> {
    a0[v1] -> alpha1, a0[v2] -> alpha2, a0[v3] -> alpha3,
    b0[1] -> beta1, b0[2] -> beta2, b0[3] -> beta3
  },
  "symmetryRules" -> {}, "seedPreset" -> "quickCheck"
|>;

mainProposal = DSKinematics[mainCase];
mainContext = DSInit[mainCase, RegisterAsCurrent -> False, ProgressReporting -> False];
mainTopo = Lookup[mainContext, "topology", <||>];
mainGraph = Lookup[mainTopo, "graphTopologyAudit", <||>];
mainRouting = Lookup[mainTopo, "loopMomentumRoutingAudit", <||>];
mainDeclaration = Lookup[mainTopo, "momentumDeclarationAudit", <||>];
mainCapabilities = Lookup[mainTopo, "capabilities", <||>];

checkSame["graphRouting", "package version", $dSIBPVersion, "016"];
checkSame["graphRouting", "main initialization", Lookup[mainContext, "status", Missing[]], "initialized"];
checkSame["graphRouting", "main graph status", Lookup[mainGraph, "status", Missing[]], "valid"];
checkSame["graphRouting", "main counts", KeyTake[mainGraph, {"internalLineCount", "vertexCount", "connectedComponentCount", "graphLoopCount"}], <|"internalLineCount" -> 3, "vertexCount" -> 3, "connectedComponentCount" -> 1, "graphLoopCount" -> 1|>];
checkSame["graphRouting", "main cycle lines", Lookup[mainGraph, "cycleLineIndices", {}], {1, 2}];
checkSame["graphRouting", "main bridge", Lookup[mainGraph, "bridgeLineIndices", {}], {3}];
checkSame["graphRouting", "routing status", Lookup[mainRouting, "status", Missing[]], "valid"];
checkSame["graphRouting", "required loop external", Lookup[mainDeclaration, "requiredLoopExternalDirections", {}], {spur}];
checkSame["graphRouting", "exact declaration status", Lookup[mainDeclaration, "status", Missing[]], "exact"];
checkSame["graphRouting", "exact no-loop magnitude count", Lookup[Lookup[mainDeclaration, "independentExternalAudit", <||>], "requiredIndependentMagnitudeCount", Missing[]], 3];
checkSame["graphRouting", "no missing directions", Lookup[mainProposal, "missingDirections", Missing[]], {}];
checkSame["graphRouting", "no missing magnitudes", Lookup[mainProposal, "missingMagnitudeSquares", Missing[]], {}];

(* 自环只贡献一圈。 *)
selfLoopCase = <|
  "name" -> "016SelfLoopProbe", "vertexData" -> {{sv, "+"}},
  "lineData" -> {<|"id" -> 1, "endpoints" -> {sv, sv}, "momentum" -> sl,
    "nu" -> snu, "bbType" -> "h", "massType" -> "massive"|>},
  "loopMomenta" -> {sl}, "loopExternalMomenta" -> {}, "independentExternalMomenta" -> {},
  "ibpMode" -> "full", "vertexEnergies" -> <|sv -> sE|>, "ispData" -> {},
  "zeroPointRules" -> {a0[sv] -> sa0, b0[1] -> sb0}, "symmetryRules" -> {}, "seedPreset" -> "quickCheck"
|>;
selfContext = DSInit[selfLoopCase, RegisterAsCurrent -> False, ProgressReporting -> False];
selfGraph = Lookup[Lookup[selfContext, "topology", <||>], "graphTopologyAudit", <||>];
checkSame["graphRouting", "self-loop count", Lookup[selfGraph, "graphLoopCount", Missing[]], 1];
checkSame["graphRouting", "self-loop classification", Lookup[selfGraph, "selfLoopLineIndices", {}], {1}];
checkSame["graphRouting", "self-loop is not bridge", Lookup[selfGraph, "bridgeLineIndices", {}], {}];

(* 三平行 cycle lines 加 bridge 同时检查 L=2 与 triple-contact 继承。 *)
tripleCase = <|
  "name" -> "016ThreeParallelBridge", "vertexData" -> {{tv1, "+"}, {tv2, "+"}, {tv3, "+"}},
  "lineData" -> {
    <|"id" -> 1, "endpoints" -> {tv1, tv2}, "momentum" -> l1, "nu" -> tnu1, "bbType" -> "h", "massType" -> "massive"|>,
    <|"id" -> 2, "endpoints" -> {tv1, tv2}, "momentum" -> l2, "nu" -> tnu2, "bbType" -> "h", "massType" -> "massive"|>,
    <|"id" -> 3, "endpoints" -> {tv1, tv2}, "momentum" -> -l1 - l2, "nu" -> tnu3, "bbType" -> "h", "massType" -> "massive"|>,
    <|"id" -> 4, "endpoints" -> {tv2, tv3}, "momentum" -> tail,
      "treeEnergy" -> Sqrt[sp[tail, tail]], "nu" -> tnu4, "bbType" -> "h", "massType" -> "massive"|>
  },
  "loopMomenta" -> {l1, l2}, "loopExternalMomenta" -> {}, "independentExternalMomenta" -> {tail},
  "ibpMode" -> "full", "vertexEnergies" -> <|tv1 -> TE1, tv2 -> TE2, tv3 -> TE3|>, "ispData" -> {},
  "zeroPointRules" -> {a0[tv1] -> ta1, a0[tv2] -> ta2, a0[tv3] -> ta3, b0[1] -> tb1, b0[2] -> tb2, b0[3] -> tb3, b0[4] -> tb4},
  "symmetryRules" -> {}, "seedPreset" -> "quickCheck"
|>;
tripleContext = DSInit[tripleCase, RegisterAsCurrent -> False, ProgressReporting -> False];
tripleTopo = Lookup[tripleContext, "topology", <||>];
tripleGraph = Lookup[tripleTopo, "graphTopologyAudit", <||>];
tripleMetadata = Lookup[tripleTopo, "sectorMetadataList", {}];
tripleSector = SelectFirst[tripleMetadata, Sort[Lookup[#, "sectorShrunkLines", {}]] === {1, 2, 3} &, Missing["NotFound"]];
checkSame["graphRouting", "three-parallel loop count", Lookup[tripleGraph, "graphLoopCount", Missing[]], 2];
checkSame["graphRouting", "three-parallel cycle lines", Lookup[tripleGraph, "cycleLineIndices", {}], {1, 2, 3}];
checkSame["graphRouting", "three-parallel bridge", Lookup[tripleGraph, "bridgeLineIndices", {}], {4}];
checkTrue["graphRouting", "triple-contact sector reachable", AssociationQ[tripleSector]];

(* ::Section:: *)
(*声明完备性与 capability gate*)

underLoopCase = Join[mainCase, <|"name" -> "016UnderLoop", "loopExternalMomenta" -> {}|>];
underLoopProposal = DSKinematics[underLoopCase];
underLoopContext = Quiet[DSInit[underLoopCase, RegisterAsCurrent -> False, ProgressReporting -> False]];
checkSame["capability", "under loop status", Lookup[underLoopProposal, "status", Missing[]], "undercomplete"];
checkSame["capability", "under loop missing", Lookup[underLoopProposal, "missingDirections", {}], {spur}];
underLoopRejectedQ = Lookup[underLoopContext, "status", Missing[]] === "failed";

underMagnitudeCase = Join[mainCase, <|"name" -> "016UnderMagnitude", "independentExternalMomenta" -> {wing1, wing2}|>];
underMagnitudeProposal = DSKinematics[underMagnitudeCase];
underMagnitudeContext = Quiet[DSInit[underMagnitudeCase, RegisterAsCurrent -> False, ProgressReporting -> False]];
checkSame["capability", "under magnitude status", Lookup[underMagnitudeProposal, "status", Missing[]], "undercomplete"];
checkTrue["capability", "under magnitude missing", Lookup[underMagnitudeProposal, "missingMagnitudeSquares", {}] =!= {}];
checkSame["capability", "under magnitude rejected", Lookup[underMagnitudeContext, "status", Missing[]], "failed"];

overLoopCase = Join[mainCase, <|"name" -> "016OverLoop", "loopExternalMomenta" -> {spur, arc}|>];
overLoopContext = DSInit[overLoopCase, RegisterAsCurrent -> False, ProgressReporting -> False];
overLoopCapabilities = Lookup[overLoopContext, "capabilities", <||>];
checkSame["capability", "over loop continues", Lookup[overLoopContext, "status", Missing[]], "initialized"];
checkSame["capability", "over loop derivative disabled", Lookup[overLoopCapabilities, "derivativeUsableQ", Missing[]], False];
checkSame["capability", "over loop inverse disabled", Lookup[overLoopCapabilities, "inverseKinematicsUsableQ", Missing[]], False];
checkTrue["capability", "over loop symbolic seed available", AssociationQ[DSSeeds[overLoopContext, DiscreteMode -> "sample", GenerateShrinkSectors -> False, ProgressReporting -> False]]];
checkSame["capability", "over loop ds blocked", ds[J[{0, 0, 0}, {{0, 0, 0}, {0, 0, 0}, {0, 0}}, {}], ss11, overLoopContext], $Failed];
checkSame["capability", "over loop inverse blocked", rep2innerform[sp[spur, spur], overLoopContext], $Failed];

(* 欠完备 context 的公开入口均不得绕过初始化门禁。 *)
{blockedSeed, blockedDtau, blockedDqq, blockedDqk, blockedDs, blockedLinear, blockedExport, blockedDE} = Quiet@{
  DSSeeds[underLoopContext, ProgressReporting -> False],
  dtau[v1, J[{0, 0, 0}, {{0, 0, 0}, {0, 0, 0}, {0, 0}}, {}], underLoopContext],
  dqq[1, 1, J[{0, 0, 0}, {{0, 0, 0}, {0, 0, 0}, {0, 0}}, {}], underLoopContext],
  dqk[1, 1, J[{0, 0, 0}, {{0, 0, 0}, {0, 0, 0}, {0, 0}}, {}], underLoopContext],
  ds[J[{0, 0, 0}, {{0, 0, 0}, {0, 0, 0}, {0, 0}}, {}], ss11, underLoopContext],
  DSLinear[<||>, underLoopContext, ProgressReporting -> False],
  DSKiraExport[<|"status" -> "failed"|>, OutputDirectory -> None, ProgressReporting -> False],
  DSDE[<||>, {ss11}, ProgressReporting -> False]
};
blockedGateResults = {
  {"DSSeeds", blockedSeed}, {"dtau", blockedDtau}, {"dqq", blockedDqq}, {"dqk", blockedDqk},
  {"ds", blockedDs}, {"DSLinear", blockedLinear}, {"DSKiraExport", blockedExport}, {"DSDE", blockedDE}
};
(* 作为一个门禁计数，但要求八个公开入口全部拒绝欠完备 context。 *)
blockedGateFailures = Select[
  blockedGateResults,
  Function[gateItem,
    With[{gateResult = gateItem[[2]]},
      ! TrueQ[gateResult === $Failed || Lookup[gateResult, "status", "failed"] === "failed"]
    ]
  ]
];
checkTrue[
  "capability",
  "under loop rejected and all downstream blocked",
  underLoopRejectedQ && blockedGateFailures === {}
];

(* 三种 routing 负例。 *)
loopCountCase = Join[mainCase, <|"name" -> "016LoopCountMismatch", "loopMomenta" -> {ell, ghostLoop}|>];
bridgeFlowCase = Join[mainCase, <|"name" -> "016BridgeFlow", "lineData" -> ReplacePart[mainCase["lineData"], 3 -> Join[mainCase["lineData"][[3]], <|"momentum" -> ell + wing1 + wing2|>]]|>];
illegalSupportCase = Join[mainCase, <|"name" -> "016IllegalSupport", "lineData" -> ReplacePart[mainCase["lineData"], 2 -> Join[mainCase["lineData"][[2]], <|"momentum" -> -ell + arc + spur|>]]|>];
loopCountAudit = DSKinematics[loopCountCase];
bridgeFlowAudit = DSKinematics[bridgeFlowCase];
illegalSupportAudit = DSKinematics[illegalSupportCase];
checkTrue["capability", "loop count mismatch rejected", Lookup[loopCountAudit, "status", "complete"] =!= "complete"];
checkTrue["capability", "bridge loop flow rejected", Lookup[bridgeFlowAudit, "status", "complete"] =!= "complete"];
checkTrue["capability", "illegal cycle support rejected", Lookup[illegalSupportAudit, "status", "complete"] =!= "complete"];

(* ::Section:: *)
(*cycle/fixed pack 与显式径向系数*)

topMetadata = First[Lookup[mainTopo, "sectorMetadataList", {}]];
lineSlots = Lookup[topMetadata, "lineSlots", {}];
checkSame["cycleFixed", "cycle massive pack 1", Lookup[lineSlots[[1]], "packTemplate", Missing[]], {b[1], n[1, 1], n[1, 2]}];
checkSame["cycleFixed", "cycle massive pack 2", Lookup[lineSlots[[2]], "packTemplate", Missing[]], {b[2], n[2, 1], n[2, 2]}];
checkSame["cycleFixed", "fixed massive pack", Lookup[lineSlots[[3]], "packTemplate", Missing[]], {n[3, 1], n[3, 2]}];
checkSame["cycleFixed", "fixed line power mode", Lookup[lineSlots[[3]], "linePowerMode", Missing[]], "fixedCoefficient"];
checkSame["cycleFixed", "fixed line has no b", Lookup[lineSlots[[3]], "bPosition", Missing[]], Missing["FixedLinePower"]];

baseIntegral[nuState_, nvState_] := J[{a1, a2, a3}, {{b1, 0, 0}, {b2, 0, 0}, {nuState, nvState}}, {}];
radialExpected = <|
  {0, 0} -> -beta3/sE3 baseIntegral[0, 0] + J[{a1, a2 + 1, a3}, {{b1, 0, 0}, {b2, 0, 0}, {1, 0}}, {}] + J[{a1, a2, a3 + 1}, {{b1, 0, 0}, {b2, 0, 0}, {0, 1}}, {}],
  {1, 0} -> -(beta3 + 2 nu3 + 1)/sE3 baseIntegral[1, 0] - J[{a1, a2 + 1, a3}, {{b1, 0, 0}, {b2, 0, 0}, {0, 0}}, {}] + J[{a1, a2, a3 + 1}, {{b1, 0, 0}, {b2, 0, 0}, {1, 1}}, {}],
  {0, 1} -> -(beta3 + 2 nu3 + 1)/sE3 baseIntegral[0, 1] + J[{a1, a2 + 1, a3}, {{b1, 0, 0}, {b2, 0, 0}, {1, 1}}, {}] - J[{a1, a2, a3 + 1}, {{b1, 0, 0}, {b2, 0, 0}, {0, 0}}, {}],
  {1, 1} -> -(beta3 + 2 (2 nu3 + 1))/sE3 baseIntegral[1, 1] - J[{a1, a2 + 1, a3}, {{b1, 0, 0}, {b2, 0, 0}, {0, 1}}, {}] - J[{a1, a2, a3 + 1}, {{b1, 0, 0}, {b2, 0, 0}, {1, 0}}, {}]
|>;
Do[
  checkZero["cycleFixed", "fixed radial " <> ToString[state, InputForm], ds[baseIntegral @@ state, sE3, mainTopo], radialExpected[state]],
  {state, Keys[radialExpected]}
];

dtau00Expected = -(a3 + alpha3) J[{a1, a2, a3 - 1}, {{b1, 0, 0}, {b2, 0, 0}, {0, 0}}, {}] - I E3 baseIntegral[0, 0] - sE3 J[{a1, a2, a3}, {{b1, 0, 0}, {b2, 0, 0}, {0, 1}}, {}];
dtau01Expected = (-(a3 + alpha3) + 2 nu3 + 1) J[{a1, a2, a3 - 1}, {{b1, 0, 0}, {b2, 0, 0}, {0, 1}}, {}] - I E3 baseIntegral[0, 1] + sE3 J[{a1, a2, a3}, {{b1, 0, 0}, {b2, 0, 0}, {0, 0}}, {}];
checkZero["cycleFixed", "fixed endpoint dtau n0", dtau[v3, baseIntegral[0, 0], mainTopo], dtau00Expected];
topLoopSectorOnly[expr_, vertexCount_Integer] := expr /. j : J[a_List, _, _] /; Length[a] < vertexCount :> 0;
checkZero["cycleFixed", "fixed endpoint dtau n1 regular", topLoopSectorOnly[dtau[v3, baseIntegral[0, 1], mainTopo], 3], dtau01Expected];

loopSeed = dqq[1, 1, baseIntegral[0, 0], mainTopo];
externalSeed = dqk[1, 1, baseIntegral[0, 0], mainTopo];
bridgePacks = Cases[{loopSeed, externalSeed}, J[_, packs_, _] :> packs[[3]], Infinity];
checkTrue["cycleFixed", "momentum seeds keep fixed pack length", And @@ (Length[#] == 2 & /@ bridgePacks)];
checkTrue["cycleFixed", "momentum seeds do not shift fixed b", FreeQ[{loopSeed, externalSeed}, b[3] | bS[3]]];

If[AssociationQ[tripleSector],
  tripleSlots = Lookup[tripleSector, "lineSlots", {}];
  checkSame["cycleFixed", "triple shrunk cycle packs", Lookup[tripleSlots[[1 ;; 3]], "packTemplate", {}], {{bS[1]}, {bS[2]}, {bS[3]}}];
  checkSame["cycleFixed", "triple fixed bridge mode inherited", Lookup[tripleSlots[[4]], "linePowerMode", Missing[]], "fixedCoefficient"];
  checkSame["cycleFixed", "triple root L inherited", Lookup[tripleTopo, "graphLoopCount", Missing[]], 2],
  checkTrue["cycleFixed", "triple metadata unavailable", False]
];

(* ::Section:: *)
(*direct pure-time 两/三顶点*)

treeTwoCase = <|
  "name" -> "016IndependentTreeTwo", "vertexData" -> {{x1, "+"}, {x2, "+"}},
  "lineData" -> {<|"id" -> 1, "endpoints" -> {x1, x2}, "momentum" -> p12,
    "treeEnergy" -> k12, "nu" -> nu12, "bbType" -> "h", "massType" -> "massive"|>},
  "loopMomenta" -> {}, "loopExternalMomenta" -> {}, "independentExternalMomenta" -> {p12}, "ibpMode" -> "timeOnly",
  "vertexEnergies" -> <|x1 -> X1, x2 -> X2|>, "ispData" -> {},
  "zeroPointRules" -> {a0[x1] -> xa1, a0[x2] -> xa2, b0[1] -> xb1},
  "shrinkPrefactorRules" -> {Exp[Pi Im[nu12]] -> eta12}, "symmetryRules" -> {}, "seedPreset" -> "quickCheck"
|>;
treeTwoContext = DSInit[treeTwoCase, RegisterAsCurrent -> False, ProgressReporting -> False];
treeTwoTopo = Lookup[treeTwoContext, "topology", <||>];
twoJ0 = J[{{ta, 0}, {tb, 0}}];
twoJ1 = J[{{ta, 1}, {tb, 0}}];
twoSeed0 = DSTreeSeeds[x1, twoJ0, treeTwoContext];
twoSeed1 = DSTreeSeeds[x1, twoJ1, treeTwoContext];
twoExpected0 = (ta + xa1) J[{{ta - 1, 0}, {tb, 0}}] - I X1 twoJ0 - k12 twoJ1;
twoExpected1 = (ta + xa1 - 2 nu12 - 1) J[{{ta - 1, 1}, {tb, 0}}] - I X1 twoJ1 + k12 twoJ0;
checkSame["pureTime", "two timeOnly mode", Lookup[treeTwoTopo, "ibpMode", Missing[]], "timeOnly"];
checkSame["pureTime", "two no momentum generators", Lookup[treeTwoTopo, "nL", Missing[]], 0];
checkSame["pureTime", "two direct route", Lookup[twoSeed0, "generationRoute", Missing[]], "directPureTime"];
checkZero["pureTime", "two direct seed n0", Lookup[twoSeed0, "treeSeed", 0], twoExpected0];
topSectorOnly[expr_, vertexCount_Integer] := expr /. j : J[packs_] /; Length[packs] < vertexCount :> 0;
checkZero["pureTime", "two direct seed n1 regular", topSectorOnly[Lookup[twoSeed1, "treeSeed", 0], 2], twoExpected1];

twoDLog = DSTreeDLogDE[treeTwoContext];
twoNaive = DSTreeNaiveIBP[treeTwoContext, twoDLog["masters"], ProgressReporting -> False];
twoNaiveDE = DSTreeNaiveDE[twoNaive, {X1, X2, k12}, ProgressReporting -> False];
checkSame["pureTime", "two dlog generated", Lookup[twoDLog, "status", Missing[]], "generated"];
checkSame["pureTime", "two naive solved", Lookup[twoNaive, "status", Missing[]], "solved"];
checkSame["pureTime", "two equation unknown count", Lookup[twoNaive, "equationCount", -1], Lookup[twoNaive, "unknownCount", -2]];
checkTrue["pureTime", "two solve residuals", And @@ (zeroQ /@ Lookup[twoNaive, "solveResiduals", {1}])];
Do[
  checkZero["pureTime", "two naive dlog " <> ToString[var, InputForm], Lookup[twoNaiveDE, "matrices", <||>][var], D[twoDLog["omega"], var]],
  {var, {X1, X2, k12}}
];
twoTarget = J[{{-1, 0}, {0, 0}}];
twoSeedForIteration = Lookup[DSTreeSeeds[x1, J[{{0, 0}, {0, 0}}], treeTwoContext], "treeSeed", $Failed];
twoSeedRule = If[twoSeedForIteration === $Failed, $Failed, FirstCase[Solve[twoSeedForIteration == 0, twoTarget], rule_List :> rule, $Failed]];
twoSeedReduction = If[ListQ[twoSeedRule], twoTarget /. twoSeedRule, $Failed];
twoFormulaReduction = repIterative[twoTarget, {0, 0}, treeTwoContext];
checkZero["pureTime", "two iteration vs direct seed symbolic", twoFormulaReduction, twoSeedReduction];
twoProbeRules = {xa1 -> 5/7, xa2 -> 7/9, nu12 -> 2/5, X1 -> 11/6, X2 -> 13/7, k12 -> 17/8, eta12 -> 19/11,
  sE1 -> 23/10, J[{{0}}] -> 2/3, J[{{0, 0}, {0, 0}}] -> 3/5, J[{{0, 1}, {0, 0}}] -> 5/8};
checkZero["pureTime", "two deterministic rational iteration", twoFormulaReduction /. twoProbeRules, twoSeedReduction /. twoProbeRules];

treeThreeCase = <|
  "name" -> "016IndependentTreeThree", "vertexData" -> {{y1, "+"}, {y2, "+"}, {y3, "-"}},
  "lineData" -> {
    <|"id" -> 1, "endpoints" -> {y1, y2}, "momentum" -> pA, "treeEnergy" -> kA, "nu" -> muA, "bbType" -> "h", "massType" -> "massive"|>,
    <|"id" -> 2, "endpoints" -> {y2, y3}, "momentum" -> pB, "treeEnergy" -> kB, "nu" -> muB, "bbType" -> "h", "massType" -> "massive"|>
  },
  "loopMomenta" -> {}, "loopExternalMomenta" -> {}, "independentExternalMomenta" -> {pA, pB}, "ibpMode" -> "timeOnly",
  "vertexEnergies" -> <|y1 -> Y1, y2 -> Y2, y3 -> Y3|>, "ispData" -> {},
  "zeroPointRules" -> {a0[y1] -> ya1, a0[y2] -> ya2, a0[y3] -> ya3, b0[1] -> yb1, b0[2] -> yb2},
  "shrinkPrefactorRules" -> {Exp[Pi Im[muA]] -> etaA, Exp[Pi Im[muB]] -> etaB},
  "symmetryRules" -> {}, "seedPreset" -> "quickCheck"
|>;
treeThreeContext = DSInit[treeThreeCase, RegisterAsCurrent -> False, ProgressReporting -> False];
threeJ = J[{{ca, 0}, {cb, 0, 1}, {cc, 1}}];
threeSeed = DSTreeSeeds[y2, threeJ, treeThreeContext];
threeExpected = Plus[
  (cb + ya2 - (2 muB + 1)) J[{{ca, 0}, {cb - 1, 0, 1}, {cc, 1}}],
  -I Y2 threeJ,
  -kA J[{{ca, 0}, {cb, 1, 1}, {cc, 1}}],
  kB J[{{ca, 0}, {cb, 0, 0}, {cc, 1}}]
];
checkSame["pureTime", "three initialization", Lookup[treeThreeContext, "status", Missing[]], "initialized"];
checkSame["pureTime", "three direct route", Lookup[threeSeed, "generationRoute", Missing[]], "directPureTime"];
checkZero["pureTime", "three two-leg vertex seed regular", topSectorOnly[Lookup[threeSeed, "treeSeed", 0], 3], threeExpected];
threeDLog = DSTreeDLogDE[treeThreeContext];
threeNaive = DSTreeNaiveIBP[treeThreeContext, threeDLog["masters"], ProgressReporting -> False];
threeNaiveDE = DSTreeNaiveDE[threeNaive, {Y1, Y2, Y3, kA, kB}, ProgressReporting -> False];
checkSame["pureTime", "three dlog generated", Lookup[threeDLog, "status", Missing[]], "generated"];
checkSame["pureTime", "three naive solved", Lookup[threeNaive, "status", Missing[]], "solved"];
checkSame["pureTime", "three equation unknown count", Lookup[threeNaive, "equationCount", -1], Lookup[threeNaive, "unknownCount", -2]];
checkTrue["pureTime", "three solve residuals", And @@ (zeroQ /@ Lookup[threeNaive, "solveResiduals", {1}])];
Do[
  checkZero["pureTime", "three naive dlog " <> ToString[var, InputForm], Lookup[threeNaiveDE, "matrices", <||>][var], D[threeDLog["omega"], var]],
  {var, {Y1, Y2, Y3, kA, kB}}
];
threeTarget = J[{{0, 0}, {0, 0, 0}, {-1, 0}}];
threeSeedForIteration = Lookup[DSTreeSeeds[y3, J[{{0, 0}, {0, 0, 0}, {0, 0}}], treeThreeContext], "treeSeed", $Failed];
threeSeedRule = If[threeSeedForIteration === $Failed, $Failed, FirstCase[Solve[threeSeedForIteration == 0, threeTarget], rule_List :> rule, $Failed]];
threeSeedReduction = If[ListQ[threeSeedRule], threeTarget /. threeSeedRule, $Failed];
threeFormulaReduction = repIterative[threeTarget, {0, 0, 0}, treeThreeContext];
checkZero["pureTime", "three iteration vs direct seed symbolic", threeFormulaReduction, threeSeedReduction];
threeProbeRules = {ya1 -> 2/7, ya2 -> 3/8, ya3 -> 4/9, muA -> 1/5, muB -> 2/9,
  Y1 -> 11/5, Y2 -> 13/6, Y3 -> 17/7, kA -> 19/8, kB -> 23/9, sE1 -> 29/10, sE2 -> 31/11, etaA -> 5/11, etaB -> 7/13};
checkZero["pureTime", "three deterministic rational iteration", threeFormulaReduction /. threeProbeRules /. (j_J :> 1/17), threeSeedReduction /. threeProbeRules /. (j_J :> 1/17)];

(* ::Section:: *)
(*notation、参数重定义与总导数*)

notation = DSParameterNotation[mainContext];
checkSame["parameters", "main notation variables", Lookup[notation, "selectedUserVariables", {}], {ss11, sE1, sE2, sE3}];
checkSame["parameters", "main notation complete", Lookup[notation, "coordinateStatus", Missing[]], "complete"];
checkSame["parameters", "no dependent magnitudes", Lookup[notation, "dependentMagnitudeBindings", Missing[]], {}];

rootName = Symbol["dSIBP`Private`externalRootSymbolName"];
legName = Symbol["dSIBP`Private`externalLegRootSymbolName"];
checkSame["parameters", "notation N9 gram", rootName[1, 9, 9], ss19];
checkSame["parameters", "notation N9 leg", legName[9, 9], sE9];
checkSame["parameters", "notation N10 first", rootName[1, 1, 10], ss0101];
checkSame["parameters", "notation N10 mixed", rootName[1, 10, 10], ss0110];
checkSame["parameters", "notation N10 leg", legName[1, 10], sE01];
checkSame["parameters", "notation N100 gram", rootName[1, 100, 100], ss001100];
checkSame["parameters", "notation N100 leg", legName[1, 100], sE001];

mixedRules = {
  sp[spur, spur] -> (u + v)^2,
  sp[wing1, wing1] -> (u - v)^2,
  sp[wing2, wing2] -> (u + w)^2,
  sp[wing1 + wing2, wing1 + wing2] -> (u + z)^2
};
mixedContext = DSRedefineParameters[mainContext, mixedRules, ProgressReporting -> False];
mixedNotation = If[AssociationQ[mixedContext], DSParameterNotation[mixedContext], $Failed];
checkSame["parameters", "mixed redefine initialized", Lookup[mixedContext, "status", Missing[]], "initialized"];
checkSame["parameters", "mixed variables", Lookup[mixedNotation, "selectedUserVariables", {}], {u, v, w, z}];
checkTrue["parameters", "mixed input hash changed", Lookup[mixedContext, "inputHash", None] =!= Lookup[mainContext, "inputHash", None]];

j1 = baseIntegral[0, 0];
j2 = J[{a1 + 1, a2, a3}, {{b1, 0, 0}, {b2, 0, 0}, {1, 0}}, {}];
mixedActual = ds[c[u] j1 + d[u] j2, u, Lookup[mixedContext, "topology", <||>]];
baseToMixed = {ss11 -> u + v, sE1 -> u - v, sE2 -> u + w, sE3 -> u + z};
mixedExpected = D[c[u], u] j1 + D[d[u], u] j2 +
  c[u] Total[(ds[j1, #, mainTopo] & /@ {ss11, sE1, sE2, sE3})] +
  d[u] Total[(ds[j2, #, mainTopo] & /@ {ss11, sE1, sE2, sE3})];
mixedExpected = mixedExpected /. baseToMixed;
checkZeroAssuming["parameters", "mixed product and chain rule", mixedActual, mixedExpected, u + z > 0];

underRules = Take[mixedRules, 3];
underRedef = DSRedefineParameters[mainContext, underRules, ProgressReporting -> False];
checkTrue["parameters", "under redefinition rejected", underRedef === $Failed || Lookup[underRedef, "status", "failed"] === "failed"];
overRules = {
  sp[spur, spur] -> (u + v + t)^2,
  sp[wing1, wing1] -> (u - v)^2,
  sp[wing2, wing2] -> (u + w)^2,
  sp[wing1 + wing2, wing1 + wing2] -> (u + z)^2
};
overRedef = DSRedefineParameters[mainContext, overRules, ProgressReporting -> False];
overRedefCapabilities = If[AssociationQ[overRedef], Lookup[overRedef, "capabilities", <||>], <||>];
checkSame["parameters", "over redefinition continues", Lookup[overRedef, "status", Missing[]], "initialized"];
checkSame["parameters", "over redefine inverse disabled", Lookup[overRedefCapabilities, "inverseKinematicsUsableQ", Missing[]], False];
checkSame["parameters", "over redefine derivative disabled", Lookup[overRedefCapabilities, "derivativeUsableQ", Missing[]], False];

(* ::Section:: *)
(*公开 API、example 与 PDF 手册*)

publicAPI = DSPublicAPI[];
publicFunctions = Lookup[publicAPI, "functions", {}];
manifest = Get[FileNameJoin[{packageDir, "examples", "coverage_manifest.wl"}]];
coverage = Lookup[manifest, "coverage", <||>];
coveredFunctions = DeleteDuplicates@Flatten[Values[coverage]];
checkSame["coverage", "public API version", Lookup[publicAPI, "version", Missing[]], "016"];
checkSame["coverage", "public function count", Length[publicFunctions], 29];
checkSame["coverage", "manifest version", Lookup[manifest, "version", Missing[]], "016"];
checkSame["coverage", "manifest exact API set", Sort[coveredFunctions], Sort[publicFunctions]];

Do[
  exampleFile = FileNameJoin[{packageDir, "examples", relativeFile}];
  exampleText = Import[exampleFile, "Text"];
  Do[
    checkTrue["coverage", "example call " <> function <> " in " <> relativeFile, StringContainsQ[exampleText, function <> "["]],
    {function, coverage[relativeFile]}
  ],
  {relativeFile, Keys[coverage]}
];

manualText = Import[manualTextFile, "Text"];
manualFunctionPresentQ[function_String] := Which[
  MemberQ[{"DSMessagesOn", "DSMessagesOff", "DSMessagesQ"}, function], StringContainsQ[manualText, "DSMessagesOn/Off/Q"],
  MemberQ[{"dqq", "dqk"}, function], StringContainsQ[manualText, "dqq/dqk"],
  True, StringContainsQ[manualText, function]
];
Do[checkTrue["coverage", "manual API " <> function, manualFunctionPresentQ[function]], {function, publicFunctions}];
renderedPages = FileNames["*.png", FileNameJoin[{workspace, "tmp", "pdfs"}]];
checkTrue["coverage", "manual rendered page count", Length[renderedPages] >= 5];
checkTrue["coverage", "manual rendered pages nonblank", And @@ (FileByteCount[#] > 10000 & /@ renderedPages)];

(* ::Section:: *)
(*汇总与证据输出*)

groupOrder = {"graphRouting", "capability", "cycleFixed", "pureTime", "parameters", "coverage"};
groupSummaries = Association@Table[
  groupChecks = Select[checks, Lookup[#, "group", ""] === group &];
  failed = Select[groupChecks, ! TrueQ[Lookup[#, "passed", False]] &];
  group -> <|
    "passed" -> Count[groupChecks, item_ /; TrueQ[item["passed"]]],
    "total" -> Length[groupChecks],
    "nonzeroDifferenceCount" -> Length[failed],
    "firstFailure" -> If[failed === {}, None, First[failed]]
  |>,
  {group, groupOrder}
];
allFailed = Select[checks, ! TrueQ[Lookup[#, "passed", False]] &];
summary = <|
  "version" -> $dSIBPVersion,
  "groups" -> groupSummaries,
  "passed" -> Count[checks, item_ /; TrueQ[item["passed"]]],
  "total" -> Length[checks],
  "nonzeroDifferenceCount" -> Length[allFailed],
  "firstFailure" -> If[allFailed === {}, None, First[allFailed]]
|>;

Put[<|"summary" -> summary, "checks" -> checks|>, FileNameJoin[{workspace, "phase2_results.wl"}]];
Print["PHASE2_SUMMARY=" <> ToString[summary, InputForm]];
If[allFailed =!= {}, Exit[1]];
