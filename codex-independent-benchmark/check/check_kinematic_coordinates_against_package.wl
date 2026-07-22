(* ::Package:: *)
(* 本检查先读取冻结 root-coordinate expected，再加载 package_015 做单向比较。 *)

ClearAll["Global`*"];


(* ::Chapter:: *)
(*路径、冻结 expected 与 package*)

checkDir = DirectoryName[$InputFileName];
workspaceDir = DirectoryName[checkDir];
projectDir = DirectoryName[workspaceDir];
expectedPath = FileNameJoin[{workspaceDir, "kinematic-coordinates", "expected.wl"}];
packagePath = FileNameJoin[{projectDir, "independent-benchmark", "package", "package_015.wl"}];
resultPath = FileNameJoin[{checkDir, "results", "kinematic-coordinates-015.wl"}];

Get[expectedPath];
Get[packagePath];
DSMessagesOff[];


(* ::Chapter:: *)
(*单外动量与圈外 external-leg 参数*)

rootCase = <|
   "name" -> "Independent015RootCoordinates",
   "vertexData" -> {{v1, "+"}, {v2, "+"}},
   "lineData" -> {
     <|"id" -> 1, "endpoints" -> {v1, v2}, "momentum" -> q,
       "nu" -> nuM, "bbType" -> "h", "massType" -> "massive"|>,
     <|"id" -> 2, "endpoints" -> {v1, v2}, "momentum" -> q - k,
       "nu" -> 0, "bbType" -> "exp", "massType" -> "massless"|>
     },
   "loopMomenta" -> {q},
   "externalMomenta" -> {k},
   "externalLegMomenta" -> {kE1, kE2},
   "vertexEnergies" -> <|
     v1 -> Sqrt[sp[k, k]] + Sqrt[sp[kE1, kE1]] + Sqrt[sp[kE1 + kE2, kE1 + kE2]],
     v2 -> Sqrt[sp[kE2, kE2]]
     |>,
   "zeroPointRules" -> {},
   "symmetryRules" -> {},
   "seedPreset" -> "quickCheck"
   |>;

context = DSInit[rootCase, RegisterAsCurrent -> False, ProgressReporting -> False];
topo = context["topology"];
integral = dSIBP`Private`makeBaseIntegral[topo] /. n[__] -> 0;
atomic = dSIBP`Private`applyIndependentVariableDerivativeSeed[topo, integral, kk[1, 1]];
root = ds[integral, ss11, topo];
externalLeg = ds[integral, sE1, topo];
expectedExternalLeg = expectedPlusPhaseEnergyCoefficient dSIBP`Private`shiftVertexA[integral, topo, v1, 1];

combination = ss11^3 integral + sE1^2 integral + ss11 sE2;
combinationDerivative = ds[combination, ss11, topo];
expectedCombinationDerivative = Expand[
   3 ss11^2 integral + ss11^3 root + sE1^2 root + sE2
   ];


(* ::Chapter:: *)
(*实际外腿原子、秩审计与无圈 massive 线*)

proposal = DSKinematics[rootCase];
customRules = {
   sp[k, k] -> xLoop^2,
   sp[kE1, kE1] -> xE1^2,
   sp[kE1 + kE2, kE1 + kE2] -> xE12^2,
   sp[kE2, kE2] -> xE2^2
   };
customAudit = DSKinematics[rootCase, customRules];
incompleteAudit = DSKinematics[rootCase, Most[customRules]];
constraintAudit = DSKinematics[rootCase, customRules /. xE2 -> xE1];
overcompleteAudit = DSKinematics[rootCase, Append[customRules, sp[2 k, 2 k] -> xFourK^2]];
overcompleteRules = Append[customRules, sp[2 k, 2 k] -> xFourK^2];
overcompleteContext = DSInit[
   rootCase,
   KinematicRules -> overcompleteRules,
   RegisterAsCurrent -> False,
   ProgressReporting -> False
   ];
overcompleteTopo = Lookup[overcompleteContext, "topology", <||>];
overcompleteIntegral = dSIBP`Private`makeBaseIntegral[overcompleteTopo] /. n[__] -> 0;
overcompleteIBP = dqq[q, q, overcompleteIntegral, overcompleteTopo];
overcompleteDerivative = ds[overcompleteIntegral, xLoop, overcompleteTopo];
overcompleteInverse = rep2innerform[xLoop, overcompleteTopo];

noLoopLineCase = <|
   "name" -> "Independent015NoLoopMomentumLine",
   "vertexData" -> {{w1, "+"}, {w2, "+"}},
   "lineData" -> {
     <|"id" -> 1, "endpoints" -> {w1, w2}, "momentum" -> q0, "nu" -> nu0, "bbType" -> "h", "massType" -> "massive"|>,
     <|"id" -> 2, "endpoints" -> {w1, w2}, "momentum" -> kE0, "nu" -> nuE0, "bbType" -> "h", "massType" -> "massive"|>
     },
   "loopMomenta" -> {q0},
   "externalMomenta" -> {},
   "externalLegMomenta" -> {kE0},
   "vertexEnergies" -> <|w1 -> Sqrt[sp[kE0, kE0]], w2 -> P2|>,
   "zeroPointRules" -> {},
   "symmetryRules" -> {},
   "seedPreset" -> "quickCheck"
   |>;
noLoopLineContext = DSInit[noLoopLineCase, RegisterAsCurrent -> False, ProgressReporting -> False];
noLoopLineTopo = noLoopLineContext["topology"];
noLoopLineIntegral = J[{a[w1], a[w2]}, {{b[1], 0, 0}, {b[2], 0, 0}}, {}];
noLoopLineActual = ds[noLoopLineIntegral, sE1, noLoopLineTopo];
noLoopLineExpected = Expand[
   expectedNoLoopMassiveDenominatorCoefficient[b[2]] J[{a[w1], a[w2]}, {{b[1], 0, 0}, {1 + b[2], 0, 0}}, {}] +
    expectedNoLoopMassiveEndpointCoefficient J[{1 + a[w1], a[w2]}, {{b[1], 0, 0}, {b[2], 1, 0}}, {}] +
    expectedNoLoopMassiveEndpointCoefficient J[{a[w1], 1 + a[w2]}, {{b[1], 0, 0}, {b[2], 0, 1}}, {}] +
    expectedPlusPhaseEnergyCoefficient J[{1 + a[w1], a[w2]}, {{b[1], 0, 0}, {b[2], 0, 0}}, {}]
   ];


(* ::Chapter:: *)
(*从属无圈模长 binding*)

dependentMagnitudeCase = <|
   "name" -> "Independent015DependentNoLoopMagnitudes",
   "vertexData" -> {{d1, "+"}, {d2, "+"}},
   "lineData" -> {
     <|"id" -> 1, "endpoints" -> {d1, d2}, "momentum" -> qd, "nu" -> nuD0, "bbType" -> "h", "massType" -> "massive"|>,
     <|"id" -> 2, "endpoints" -> {d1, d2}, "momentum" -> kEd, "nu" -> nuD1, "bbType" -> "h", "massType" -> "massive"|>,
     <|"id" -> 3, "endpoints" -> {d1, d2}, "momentum" -> 2 kEd, "nu" -> nuD2, "bbType" -> "h", "massType" -> "massive"|>
     },
   "loopMomenta" -> {qd},
   "externalMomenta" -> {kd},
   "externalLegMomenta" -> {kEd},
   "ispData" -> {
     <|"name" -> rhoD, "expr" -> sp[qd, kd], "range" -> {0}|>
     },
   "vertexEnergies" -> <|
     d1 -> Sqrt[sp[kd + kEd, kd + kEd]],
     d2 -> Sqrt[sp[kd - kEd, kd - kEd]]
     |>,
   "zeroPointRules" -> {},
   "symmetryRules" -> {},
   "seedPreset" -> "quickCheck"
   |>;
dependentMagnitudeContext = DSInit[dependentMagnitudeCase, RegisterAsCurrent -> False, ProgressReporting -> False];
dependentMagnitudeTopo = dependentMagnitudeContext["topology"];
dependentMagnitudeReport = dSIBP`Private`externalLegInvariantNamingReport[dependentMagnitudeTopo];
dependentMagnitudeBindings = Lookup[dependentMagnitudeReport, "dependentMagnitudeBindings", {}];
dependentCustomRules = {
   sp[kd, kd] -> uDependent^2,
   sp[kEd, kEd] -> vDependent^2,
   sp[kd - kEd, kd - kEd] -> wDependent^2
   };
dependentCustomAudit = DSKinematics[dependentMagnitudeCase, dependentCustomRules];
dependentCustomContext = DSInit[
   dependentMagnitudeCase,
   KinematicRules -> dependentCustomRules,
   RegisterAsCurrent -> False,
   ProgressReporting -> False
   ];
dependentCustomTopo = dependentCustomContext["topology"];
dependentMagnitudeIntegral = J[
   {a[d1], a[d2]},
   {{b[1], 0, 0}, {b[2], 0, 0}, {b[3], 0, 0}},
   {ispN[1]}
   ];
dependentMagnitudeActual = ds[dependentMagnitudeIntegral, sE1, dependentMagnitudeTopo];
dependentMagnitudeExpected = Expand[
   expectedNoLoopMassiveDenominatorCoefficient[b[2]]
     J[{a[d1], a[d2]}, {{b[1], 0, 0}, {1 + b[2], 0, 0}, {b[3], 0, 0}}, {ispN[1]}] +
    expectedNoLoopMassiveEndpointCoefficient
     J[{1 + a[d1], a[d2]}, {{b[1], 0, 0}, {b[2], 1, 0}, {b[3], 0, 0}}, {ispN[1]}] +
    expectedNoLoopMassiveEndpointCoefficient
     J[{a[d1], 1 + a[d2]}, {{b[1], 0, 0}, {b[2], 0, 1}, {b[3], 0, 0}}, {ispN[1]}] +
    expectedDependentMagnitudeLineScale (
      expectedNoLoopMassiveDenominatorCoefficient[b[3]]
       J[{a[d1], a[d2]}, {{b[1], 0, 0}, {b[2], 0, 0}, {1 + b[3], 0, 0}}, {ispN[1]}] +
      expectedNoLoopMassiveEndpointCoefficient
       J[{1 + a[d1], a[d2]}, {{b[1], 0, 0}, {b[2], 0, 0}, {b[3], 1, 0}}, {ispN[1]}] +
      expectedNoLoopMassiveEndpointCoefficient
       J[{a[d1], 1 + a[d2]}, {{b[1], 0, 0}, {b[2], 0, 0}, {b[3], 0, 1}}, {ispN[1]}]
      ) +
    expectedPlusPhaseEnergyCoefficient expectedDependentMagnitudePhaseScale
     J[{a[d1], 1 + a[d2]}, {{b[1], 0, 0}, {b[2], 0, 0}, {b[3], 0, 0}}, {ispN[1]}]
   ];


(* ::Chapter:: *)
(*非对角根号坐标与旧坐标*)

twoCase = <|
   "name" -> "Independent015OffDiagonalRoot",
   "vertexData" -> {{u1, "+"}, {u2, "+"}},
   "lineData" -> {
     <|"id" -> 1, "endpoints" -> {u1, u2}, "momentum" -> ell, "nu" -> 0, "bbType" -> "exp", "massType" -> "massless"|>,
     <|"id" -> 2, "endpoints" -> {u1, u2}, "momentum" -> ell - k1, "nu" -> 0, "bbType" -> "exp", "massType" -> "massless"|>,
     <|"id" -> 3, "endpoints" -> {u1, u2}, "momentum" -> ell - k2, "nu" -> 0, "bbType" -> "exp", "massType" -> "massless"|>
     },
   "loopMomenta" -> {ell},
   "externalMomenta" -> {k1, k2},
   "vertexEnergies" -> <|u1 -> Sqrt[sp[k1, k1]], u2 -> Sqrt[sp[k2, k2]]|>,
   "zeroPointRules" -> {},
   "symmetryRules" -> {},
   "seedPreset" -> "quickCheck"
   |>;

twoContext = DSInit[twoCase, RegisterAsCurrent -> False, ProgressReporting -> False];
twoTopo = twoContext["topology"];
twoIntegral = dSIBP`Private`makeBaseIntegral[twoTopo] /. n[__] -> 0;
twoAtomic = dSIBP`Private`applyIndependentVariableDerivativeSeed[twoTopo, twoIntegral, kk[1, 2]];
twoRoot = ds[twoIntegral, ss12, twoTopo];

mixedRules = {
   sp[k1, k1] -> uMix^2,
   sp[k1, k2] -> uMix vMix,
   sp[k2, k2] -> vMix^2 + wMix^2
   };
mixedAudit = DSKinematics[twoCase, mixedRules];
mixedContext = DSInit[
   twoCase,
   KinematicRules -> mixedRules,
   RegisterAsCurrent -> False,
   ProgressReporting -> False
   ];
mixedTopo = mixedContext["topology"];
mixedIntegral = dSIBP`Private`makeBaseIntegral[mixedTopo] /. n[__] -> 0;
mixedAtomic = dSIBP`Private`applyIndependentVariableDerivativeSeed[mixedTopo, mixedIntegral, #] & /@
   {kk[1, 1], kk[1, 2], kk[2, 2]};
mixedDerivative = ds[mixedIntegral, uMix, mixedTopo];
mixedExpected = rep2outform[
   dSIBP`Private`applySeedCanonical[
    expectedMixedSquaredJacobians[uMix] . mixedAtomic,
    mixedTopo
    ],
   mixedTopo
   ];
mixedInverse = rep2innerform[uMix, mixedTopo];

legacyContext = DSInit[
   Join[rootCase, <|
     "name" -> "Independent015LegacyCoordinate",
     "externalInvariantRules" -> {sp[k, k] -> s11},
     "externalLegMomenta" -> {},
     "vertexEnergies" -> <|v1 -> E1, v2 -> E2|>
     |>],
   RegisterAsCurrent -> False,
   ProgressReporting -> False
   ];
legacyTopo = legacyContext["topology"];
legacyIntegral = dSIBP`Private`makeBaseIntegral[legacyTopo] /. n[__] -> 0;
legacyAtomic = dSIBP`Private`applyIndependentVariableDerivativeSeed[legacyTopo, legacyIntegral, kk[1, 1]];
legacyDerivative = ds[legacyIntegral, s11, legacyTopo];


(* ::Chapter:: *)
(*汇总*)

checks = <|
   "packageVersion" -> $dSIBPVersion === "015",
   "oneMomentumRules" -> topo["externalInvariantRules"] === Thread[{sp[k, k]} -> expectedOneMomentumLoopRHS],
    "externalLegRules" -> topo["externalLegInvariantRules"] === Thread[
       {sp[kE1, kE1], sp[kE1 + kE2, kE1 + kE2], sp[kE2, kE2]} -> expectedExternalLegRHS
       ],
    "noExternalLegCrossProduct" -> FreeQ[topo["externalLegInvariantRules"], sp[kE1, kE2]],
   "rootJacobian" -> Expand[root - expectedRootJacobians[ss11] rep2outform[atomic, topo]] === 0,
   "externalLegPhase" -> Expand[externalLeg - expectedExternalLeg] === 0,
    "coefficientProductRule" -> Expand[combinationDerivative - expectedCombinationDerivative] === 0,
    "defaultProposal" -> Lookup[proposal, "status", "failed"] === "complete" && Lookup[proposal, "baseCoordinateCount", -1] === 4,
    "selectionTemplate" -> Lookup[proposal, "selectionTemplate", Missing["template"]] ===
      ("kinematicRules" -> Lookup[proposal, "defaultRules", {}]),
    "customComplete" -> Lookup[customAudit, "status", "failed"] === "complete",
    "incompleteMissingDirection" -> Lookup[incompleteAudit, "status", "failed"] === "incomplete" && Lookup[incompleteAudit, "missingDirections", {}] =!= {},
    "implicitConstraintNullSpace" -> Lookup[constraintAudit, "status", "failed"] === "incomplete" && Lookup[constraintAudit, "parameterMissingDirections", {}] =!= {},
    "overcompleteWarningData" -> Lookup[overcompleteAudit, "status", "failed"] === "overcomplete" && Lookup[overcompleteAudit, "constraintResiduals", {}] =!= {},
    "overcompleteIBPAllowed" -> overcompleteIBP =!= $Failed,
    "overcompleteDerivativeRejected" -> overcompleteDerivative === $Failed,
    "overcompleteInverseRejected" -> overcompleteInverse === $Failed,
    "noLoopLineDerivative" -> Expand[noLoopLineActual - noLoopLineExpected] === 0,
    "dependentMagnitudeIndependentBasis" -> Join[
       Last /@ dependentMagnitudeTopo["externalInvariantRules"],
       Last /@ dependentMagnitudeTopo["externalLegInvariantRules"]
       ] === expectedDependentMagnitudeIndependentRHS,
    "dependentMagnitudeOccurrenceCount" -> Length[Lookup[dependentMagnitudeReport, "appearingMagnitudeMomenta", {}]] === 4 &&
      Length[Lookup[dependentMagnitudeReport, "independentMagnitudeMomenta", {}]] === 2,
    "dependentMagnitudeBindings" -> Sort[Lookup[dependentMagnitudeBindings, "userSquaredExpression", {}]] ===
      Sort[expectedDependentMagnitudeSquaredBindings],
    "dependentBindingInAudit" -> Lookup[
       dependentMagnitudeTopo["kinematicCoordinateAudit"],
       "dependentMagnitudeBindings",
       {}
       ] =!= {},
    "dependentOccurrenceCanDefineCoordinate" -> Lookup[dependentCustomAudit, "status", "failed"] === "complete" &&
      Lookup[dependentCustomContext, "status", "failed"] === "initialized",
    "dependentOccurrenceCustomResolution" -> Last /@ dependentCustomTopo["externalLegInvariantRules"] ===
      expectedDependentCustomResolvedRHS,
    "dependentMagnitudeDerivative" -> Together[Expand[
       dependentMagnitudeActual - dependentMagnitudeExpected
       ]] === 0,
   "twoMomentumRules" -> twoTopo["externalInvariantRules"] === Thread[
      {sp[k1, k1], sp[k1, k2], sp[k2, k2]} -> expectedTwoMomentumLoopRHS
      ],
   "offDiagonalJacobian" -> Expand[twoRoot - expectedRootJacobians[ss12] rep2outform[twoAtomic, twoTopo]] === 0,
   "mixedCoordinateComplete" -> Lookup[mixedAudit, "status", "failed"] === "complete",
   "mixedCoordinateJacobian" -> Together[Expand[mixedDerivative - mixedExpected]] === 0,
   "mixedCoordinateInverseUnavailable" -> ! TrueQ[Lookup[mixedAudit, "inverseAvailableQ", True]] && mixedInverse === $Failed,
   "legacyUnitJacobian" -> Expand[legacyDerivative - expectedLegacyJacobian rep2outform[legacyAtomic, legacyTopo]] === 0,
   "externalLegNotIBPGenerator" -> Count[
      Lookup[dSIBP`Private`makeIBPGenerators[topo], "type", {}], "momentum"] ===
     expectedMomentumGeneratorCount[topo["nL"], topo["nK"]],
   "noResidualInternalRoot" -> FreeQ[{root, externalLeg, combinationDerivative, twoRoot}, _kk | _qk | _qq]
   |>;

summary = <|
   "packageHash" -> FileHash[packagePath, "SHA256", "HexString"],
   "passed" -> Count[Values[checks], True],
   "total" -> Length[checks],
   "nonconformities" -> Select[checks, Not]
   |>;

If[! DirectoryQ[DirectoryName[resultPath]], CreateDirectory[DirectoryName[resultPath], CreateIntermediateDirectories -> True]];
Put[summary, resultPath];
Print[InputForm[summary]];
If[summary["passed"] =!= summary["total"], Exit[1]];
