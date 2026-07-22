(* ::Package:: *)
(* 本检查验证 015 的 ssij/实际无圈模长初始化、内外转换和基于旧 kk 原子导数的 Jacobian 链式适配。 *)

(* ::Chapter:: *)
(*加载 015 package*)

checkDir = DirectoryName[$InputFileName];
codeDir = DirectoryName[checkDir];
packageDir = FileNameJoin[{codeDir, "015_dSIBP"}];
If[! MemberQ[$Path, packageDir], AppendTo[$Path, packageDir]];
Needs["dSIBP`"];
DSMessagesOff[];


(* ::Chapter:: *)
(*根号坐标函数族*)

rootCase = <|
   "name" -> "015RootKinematicCoordinates",
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
   "numericRules" -> {ss11 -> 5, sE1 -> 7, sE2 -> 11, sE3 -> 13, nuM -> 2},
   "zeroPointRules" -> {},
   "symmetryRules" -> {},
   "seedPreset" -> "quickCheck"
   |>;

context = DSInit[rootCase, GenerateDerivativeMetadata -> True, RegisterAsCurrent -> False, ProgressReporting -> False];
topo = Lookup[context, "topology", <||>];


(* ::Chapter:: *)
(*原子导数与链式关系*)

baseIntegral = dSIBP`Private`makeBaseIntegral[topo] /. n[__] -> 0;
atomicDerivative = dSIBP`Private`applyIndependentVariableDerivativeSeed[topo, baseIntegral, kk[1, 1]];
rootDerivative = ds[baseIntegral, ss11, topo];
atomicPublic = rep2outform[atomicDerivative, topo];
expectedRootDerivative = dSIBP`Private`applySeedCanonical[2 ss11 atomicPublic, topo];

coefficientExpression = ss11^3 baseIntegral + sE1^2 baseIntegral + ss11 sE2;
coefficientDerivative = ds[coefficientExpression, ss11, topo];
expectedCoefficientDerivative = Expand[
   3 ss11^2 baseIntegral + ss11^3 rootDerivative + sE1^2 rootDerivative + sE2
   ];

rootDecomposition = dSIBP`Private`makeExternalInvariantDerivativeDecomposition[topo, ss11];
atomicDecomposition = dSIBP`Private`makeExternalInvariantDerivativeDecomposition[topo, kk[1, 1]];
externalLegDerivative = ds[baseIntegral, sE1, topo];
expectedExternalLegDerivative = rep2outform[
   dSIBP`Private`directVertexEnergyVariableDerivativeSeed[topo, baseIntegral, sE1],
   topo
   ];


(* ::Chapter:: *)
(*实际出现的外腿模长、重选与秩门禁*)

defaultProposal = DSKinematics[rootCase];
customRules = {
   sp[k, k] -> xLoop^2,
   sp[kE1, kE1] -> xE1^2,
   sp[kE1 + kE2, kE1 + kE2] -> xE12^2,
   sp[kE2, kE2] -> xE2^2
   };
customAudit = DSKinematics[rootCase, customRules];
customContext = DSInit[
   rootCase,
   KinematicRules -> customRules,
   RegisterAsCurrent -> False,
   ProgressReporting -> False
   ];
customTopo = Lookup[customContext, "topology", <||>];
customIntegral = dSIBP`Private`makeBaseIntegral[customTopo] /. n[__] -> 0;
customDerivative = ds[customIntegral, xLoop, customTopo];
customAtomic = dSIBP`Private`applyIndependentVariableDerivativeSeed[customTopo, customIntegral, kk[1, 1]];
customExpected = dSIBP`Private`applySeedCanonical[2 xLoop rep2outform[customAtomic, customTopo], customTopo];

incompleteRules = Most[customRules];
incompleteAudit = DSKinematics[rootCase, incompleteRules];
constrainedAudit = DSKinematics[rootCase, customRules /. xE2 -> xE1];
incompleteContext = DSInit[
   rootCase,
   KinematicRules -> incompleteRules,
   RegisterAsCurrent -> False,
   ProgressReporting -> False
   ];

overcompleteRules = Append[customRules, sp[2 k, 2 k] -> xFourK^2];
overcompleteAudit = DSKinematics[rootCase, overcompleteRules];
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


(* ::Chapter:: *)
(*无圈动量传播子的径向求导*)

noLoopLineCase = <|
   "name" -> "015NoLoopMomentumLine",
   "vertexData" -> {{w1, "+"}, {w2, "+"}},
   "lineData" -> {
     <|"id" -> 1, "endpoints" -> {w1, w2}, "momentum" -> q0,
       "nu" -> nu0, "bbType" -> "h", "massType" -> "massive"|>,
     <|"id" -> 2, "endpoints" -> {w1, w2}, "momentum" -> kE0,
       "nu" -> nuE0, "bbType" -> "h", "massType" -> "massive"|>
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
noLoopLineTopo = Lookup[noLoopLineContext, "topology", <||>];
noLoopLineIntegral = J[
   {a[w1], a[w2]},
   {{b[1], 0, 0}, {b[2], 0, 0}},
   {}
   ];
noLoopLineDerivative = ds[noLoopLineIntegral, sE1, noLoopLineTopo];
noLoopLineExpected = Expand[
   -b[2] J[{a[w1], a[w2]}, {{b[1], 0, 0}, {1 + b[2], 0, 0}}, {}] +
    J[{1 + a[w1], a[w2]}, {{b[1], 0, 0}, {b[2], 1, 0}}, {}] +
    J[{a[w1], 1 + a[w2]}, {{b[1], 0, 0}, {b[2], 0, 1}}, {}] +
    I J[{1 + a[w1], a[w2]}, {{b[1], 0, 0}, {b[2], 0, 0}}, {}]
   ];


(* ::Chapter:: *)
(*无圈模长独立基与从属 binding*)

dependentMagnitudeCase = <|
   "name" -> "015DependentNoLoopMagnitudes",
   "vertexData" -> {{d1, "+"}, {d2, "+"}},
   "lineData" -> {
     <|"id" -> 1, "endpoints" -> {d1, d2}, "momentum" -> qd,
       "nu" -> nuD0, "bbType" -> "h", "massType" -> "massive"|>,
     <|"id" -> 2, "endpoints" -> {d1, d2}, "momentum" -> kEd,
       "nu" -> nuD1, "bbType" -> "h", "massType" -> "massive"|>,
     <|"id" -> 3, "endpoints" -> {d1, d2}, "momentum" -> 2 kEd,
       "nu" -> nuD2, "bbType" -> "h", "massType" -> "massive"|>
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
dependentMagnitudeContext = DSInit[
   dependentMagnitudeCase,
   RegisterAsCurrent -> False,
   ProgressReporting -> False
   ];
dependentMagnitudeTopo = Lookup[dependentMagnitudeContext, "topology", <||>];
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
dependentCustomTopo = Lookup[dependentCustomContext, "topology", <||>];
dependentMagnitudeIntegral = J[
   {a[d1], a[d2]},
   {{b[1], 0, 0}, {b[2], 0, 0}, {b[3], 0, 0}},
   {ispN[1]}
   ];
dependentMagnitudeDerivative = ds[dependentMagnitudeIntegral, sE1, dependentMagnitudeTopo];
dependentLineScale = D[Sqrt[4 sE1^2], sE1];
dependentMagnitudeExpected = Expand[
   -b[2] J[{a[d1], a[d2]}, {{b[1], 0, 0}, {1 + b[2], 0, 0}, {b[3], 0, 0}}, {ispN[1]}] +
    J[{1 + a[d1], a[d2]}, {{b[1], 0, 0}, {b[2], 1, 0}, {b[3], 0, 0}}, {ispN[1]}] +
    J[{a[d1], 1 + a[d2]}, {{b[1], 0, 0}, {b[2], 0, 1}, {b[3], 0, 0}}, {ispN[1]}] +
    dependentLineScale (
      -b[3] J[{a[d1], a[d2]}, {{b[1], 0, 0}, {b[2], 0, 0}, {1 + b[3], 0, 0}}, {ispN[1]}] +
       J[{1 + a[d1], a[d2]}, {{b[1], 0, 0}, {b[2], 0, 0}, {b[3], 1, 0}}, {ispN[1]}] +
       J[{a[d1], 1 + a[d2]}, {{b[1], 0, 0}, {b[2], 0, 0}, {b[3], 0, 1}}, {ispN[1]}]
      ) +
    I (2 sE1/Sqrt[2 ss11^2 + 2 sE1^2 - sE2^2])
      J[{a[d1], 1 + a[d2]}, {{b[1], 0, 0}, {b[2], 0, 0}, {b[3], 0, 0}}, {ispN[1]}]
   ];


(* ::Chapter:: *)
(*两外动量非对角坐标与 014 显式旧坐标兼容*)

twoMomentumCase = <|
   "name" -> "015TwoExternalMomenta",
   "vertexData" -> {{u1, "+"}, {u2, "+"}},
   "lineData" -> {
     <|"id" -> 1, "endpoints" -> {u1, u2}, "momentum" -> ell,
       "nu" -> 0, "bbType" -> "exp", "massType" -> "massless"|>,
     <|"id" -> 2, "endpoints" -> {u1, u2}, "momentum" -> ell - k1,
       "nu" -> 0, "bbType" -> "exp", "massType" -> "massless"|>,
     <|"id" -> 3, "endpoints" -> {u1, u2}, "momentum" -> ell - k2,
       "nu" -> 0, "bbType" -> "exp", "massType" -> "massless"|>
     },
   "loopMomenta" -> {ell},
   "externalMomenta" -> {k1, k2},
   "vertexEnergies" -> <|u1 -> Sqrt[sp[k1, k1]], u2 -> Sqrt[sp[k2, k2]]|>,
   "zeroPointRules" -> {},
   "symmetryRules" -> {},
   "seedPreset" -> "quickCheck"
   |>;

twoMomentumContext = DSInit[twoMomentumCase, RegisterAsCurrent -> False, ProgressReporting -> False];
twoMomentumTopo = Lookup[twoMomentumContext, "topology", <||>];
twoMomentumIntegral = dSIBP`Private`makeBaseIntegral[twoMomentumTopo] /. n[__] -> 0;
twoMomentumAtomic = dSIBP`Private`applyIndependentVariableDerivativeSeed[
   twoMomentumTopo, twoMomentumIntegral, kk[1, 2]
   ];
twoMomentumRoot = ds[twoMomentumIntegral, ss12, twoMomentumTopo];
twoMomentumExpected = dSIBP`Private`applySeedCanonical[
   2 ss12 rep2outform[twoMomentumAtomic, twoMomentumTopo],
   twoMomentumTopo
   ];

mixedRules = {
   sp[k1, k1] -> uMix^2,
   sp[k1, k2] -> uMix vMix,
   sp[k2, k2] -> vMix^2 + wMix^2
   };
mixedAudit = DSKinematics[twoMomentumCase, mixedRules];
mixedContext = DSInit[
   twoMomentumCase,
   KinematicRules -> mixedRules,
   RegisterAsCurrent -> False,
   ProgressReporting -> False
   ];
mixedTopo = Lookup[mixedContext, "topology", <||>];
mixedIntegral = dSIBP`Private`makeBaseIntegral[mixedTopo] /. n[__] -> 0;
mixedAtomic11 = dSIBP`Private`applyIndependentVariableDerivativeSeed[mixedTopo, mixedIntegral, kk[1, 1]];
mixedAtomic12 = dSIBP`Private`applyIndependentVariableDerivativeSeed[mixedTopo, mixedIntegral, kk[1, 2]];
mixedRawActual = dSIBP`Private`applyUserKinematicDerivativeSeed[mixedTopo, mixedIntegral, uMix];
mixedRawExpected = Expand[2 uMix mixedAtomic11 + vMix mixedAtomic12];
mixedDerivative = ds[mixedIntegral, uMix, mixedTopo];
mixedExpected = rep2outform[
   dSIBP`Private`applySeedCanonical[
    2 uMix mixedAtomic11 + vMix mixedAtomic12,
    mixedTopo
    ],
   mixedTopo
   ];
mixedInverse = rep2innerform[uMix, mixedTopo];

legacyCase = Join[
   KeyDrop[rootCase, {"externalLegMomenta"}],
   <|
    "name" -> "015LegacySquaredInvariant",
    "externalInvariantRules" -> {sp[k, k] -> s11},
    "vertexEnergies" -> <|v1 -> E1, v2 -> E2|>,
    "numericRules" -> {s11 -> 5, E1 -> 7, E2 -> 11, nuM -> 2}
    |>
   ];
legacyContext = DSInit[legacyCase, RegisterAsCurrent -> False, ProgressReporting -> False];
legacyTopo = Lookup[legacyContext, "topology", <||>];
legacyIntegral = dSIBP`Private`makeBaseIntegral[legacyTopo] /. n[__] -> 0;
legacyAtomic = dSIBP`Private`applyIndependentVariableDerivativeSeed[legacyTopo, legacyIntegral, kk[1, 1]];
legacyDerivative = ds[legacyIntegral, s11, legacyTopo];


(* ::Chapter:: *)
(*验收*)

checks = <|
   "version" -> SameQ[$dSIBPVersion, "015"],
   "initialized" -> Lookup[context, "status", "missing"] === "initialized",
   "defaultLoopRule" -> Lookup[topo, "externalInvariantRules", {}] === {sp[k, k] -> ss11^2},
    "defaultExternalLegRules" -> Lookup[topo, "externalLegInvariantRules", {}] === {
       sp[kE1, kE1] -> sE1^2,
       sp[kE1 + kE2, kE1 + kE2] -> sE2^2,
       sp[kE2, kE2] -> sE3^2
       },
    "noAutomaticExternalLegCrossProduct" -> FreeQ[Lookup[topo, "externalLegInvariantRules", {}], sp[kE1, kE2]],
    "publicVariables" -> Lookup[context["derivatives"], "operators", {}][[All, "userVariable"]] === {ss11, sE1, sE2, sE3},
   "loopInternalToUser" -> rep2outform[kk[1, 1], topo] === ss11^2,
   "loopRootToInternal" -> rep2innerform[ss11, topo] === Sqrt[kk[1, 1]],
    "externalLegRootInput" -> rep2innerform[Sqrt[sp[kE1, kE1]], topo] === sE1,
   "vertexEnergyOutput" -> dSIBP`Private`scalarProductInternalToUser[
        dSIBP`Private`vertexExternalEnergy[topo, v1], topo] === ss11 + sE1 + sE2,
   "numericRootSquared" -> MemberQ[Lookup[topo, "numericRules", {}], kk[1, 1] -> 25],
   "rootDecompositionSolved" -> Lookup[rootDecomposition, "status", "failed"] === "solved",
   "atomicDecompositionSolved" -> Lookup[atomicDecomposition, "status", "failed"] === "solved",
   "jacobianCoefficient" -> Together[
       First[rootDecomposition["coefficients"]]/First[atomicDecomposition["coefficients"]] - 2 Sqrt[kk[1, 1]]
       ] === 0,
   "integralChainRule" -> Expand[rootDerivative - expectedRootDerivative] === 0,
   "externalLegDerivative" -> Expand[externalLegDerivative - expectedExternalLegDerivative] === 0,
    "coefficientProductRule" -> Expand[coefficientDerivative - expectedCoefficientDerivative] === 0,
    "defaultProposalComplete" -> Lookup[defaultProposal, "status", "failed"] === "complete",
    "defaultBaseCoordinateCount" -> Lookup[defaultProposal, "baseCoordinateCount", -1] === 4,
    "selectionTemplateEvaluated" -> Lookup[defaultProposal, "selectionTemplate", Missing["template"]] ===
      ("kinematicRules" -> Lookup[defaultProposal, "defaultRules", {}]),
    "customSelectionComplete" -> Lookup[customAudit, "status", "failed"] === "complete",
    "customReinitialized" -> Lookup[customContext, "status", "failed"] === "initialized",
    "customChainRule" -> Expand[customDerivative - customExpected] === 0,
    "incompleteAudit" -> Lookup[incompleteAudit, "status", "failed"] === "incomplete" && Lookup[incompleteAudit, "missingDirections", {}] =!= {},
    "implicitConstraintNullSpace" -> Lookup[constrainedAudit, "status", "failed"] === "incomplete" && Lookup[constrainedAudit, "parameterMissingDirections", {}] =!= {},
    "incompleteRejected" -> Lookup[incompleteContext, "status", "missing"] === "failed",
    "overcompleteAudit" -> Lookup[overcompleteAudit, "status", "failed"] === "overcomplete" && ! TrueQ[Lookup[overcompleteAudit, "inverseAvailableQ", True]],
    "overcompleteAllowed" -> Lookup[overcompleteContext, "status", "failed"] === "initialized",
    "overcompleteIBPAllowed" -> overcompleteIBP =!= $Failed,
    "overcompleteDerivativeRejected" -> overcompleteDerivative === $Failed,
    "overcompleteInverseRejected" -> overcompleteInverse === $Failed,
    "noLoopLineInitialized" -> Lookup[noLoopLineContext, "status", "failed"] === "initialized",
    "noLoopLineDefaultRule" -> Lookup[noLoopLineTopo, "externalLegInvariantRules", {}] === {sp[kE0, kE0] -> sE1^2},
    "noLoopLineRadialDerivative" -> Expand[noLoopLineDerivative - noLoopLineExpected] === 0,
    "dependentMagnitudeInitialized" -> Lookup[dependentMagnitudeContext, "status", "failed"] === "initialized",
    "dependentMagnitudeIndependentRules" -> Lookup[dependentMagnitudeTopo, "externalLegInvariantRules", {}] === {
       sp[kEd, kEd] -> sE1^2,
       sp[kd + kEd, kd + kEd] -> sE2^2
       },
    "dependentMagnitudeCount" -> Length[Lookup[dependentMagnitudeReport, "appearingMagnitudeMomenta", {}]] === 4 &&
      Length[Lookup[dependentMagnitudeReport, "independentMagnitudeMomenta", {}]] === 2,
    "dependentDoubleBinding" -> MemberQ[
      Lookup[dependentMagnitudeBindings, "userSquaredExpression", {}],
      4 sE1^2
      ],
    "dependentDifferenceBinding" -> MemberQ[
      Lookup[dependentMagnitudeBindings, "userSquaredExpression", {}],
      2 ss11^2 + 2 sE1^2 - sE2^2
      ],
    "dependentBindingInKinematicAudit" -> Lookup[
       Lookup[dependentMagnitudeTopo, "kinematicCoordinateAudit", <||>],
       "dependentMagnitudeBindings",
       {}
       ] =!= {},
    "dependentOccurrenceCanDefineCoordinate" -> Lookup[dependentCustomAudit, "status", "failed"] === "complete" &&
      Lookup[dependentCustomContext, "status", "failed"] === "initialized",
    "dependentOccurrenceCustomResolution" -> Lookup[dependentCustomTopo, "externalLegInvariantRules", {}] === {
       sp[kEd, kEd] -> vDependent^2,
       sp[kd + kEd, kd + kEd] -> 2 uDependent^2 + 2 vDependent^2 - wDependent^2
       },
    "dependentVertexEnergyBinding" -> dSIBP`Private`scalarProductInternalToUser[
       dSIBP`Private`vertexExternalEnergy[dependentMagnitudeTopo, d2], dependentMagnitudeTopo
       ] === Sqrt[2 ss11^2 + 2 sE1^2 - sE2^2],
    "dependentLineChainRule" -> Together[Expand[
       dependentMagnitudeDerivative - dependentMagnitudeExpected
       ]] === 0,
   "twoMomentumInitialized" -> Lookup[twoMomentumContext, "status", "missing"] === "initialized",
   "twoMomentumDefaultRules" -> Lookup[twoMomentumTopo, "externalInvariantRules", {}] === {
      sp[k1, k1] -> ss11^2, sp[k1, k2] -> ss12^2, sp[k2, k2] -> ss22^2
      },
   "offDiagonalChainRule" -> Expand[twoMomentumRoot - twoMomentumExpected] === 0,
   "mixedCoordinateComplete" -> Lookup[mixedAudit, "status", "failed"] === "complete",
   "mixedCoordinateJacobian" -> Together[Expand[mixedDerivative - mixedExpected]] === 0,
   "mixedCoordinateInverseUnavailable" -> ! TrueQ[Lookup[mixedAudit, "inverseAvailableQ", True]] && mixedInverse === $Failed,
   "legacyInitialized" -> Lookup[legacyContext, "status", "missing"] === "initialized",
   "legacyVariablePreserved" -> MemberQ[
      Lookup[dSIBP`Private`makeIndependentVariableDerivativeGenerators[legacyTopo], "userVariable", {}],
      s11
      ],
   "legacyUnitJacobian" -> Expand[legacyDerivative - rep2outform[legacyAtomic, legacyTopo]] === 0,
   "noExternalLegIBPGenerator" -> Count[
      Lookup[dSIBP`Private`makeIBPGenerators[topo], "type", {}],
      "momentum"
      ] === topo["nL"] (topo["nL"] + topo["nK"])
   |>;

Print["015 kinematic coordinate checks: ", Count[Values[checks], True], "/", Length[checks]];
If[! And @@ Values[checks],
  Print[InputForm[Select[checks, Not]]];
  Print["integralResidual=", InputForm[Expand[rootDerivative - expectedRootDerivative]]];
  Print["externalLegResidual=", InputForm[Expand[externalLegDerivative - expectedExternalLegDerivative]]];
  Print["mixedCoordinateResidual=", InputForm[Together[Expand[mixedDerivative - mixedExpected]]]];
  Print["mixedRawResidual=", InputForm[Together[Expand[rep2outform[mixedRawActual - mixedRawExpected, mixedTopo]]]]];
  Print["dependentMagnitudeResidual=", InputForm[Together[Expand[
      dependentMagnitudeDerivative - dependentMagnitudeExpected
      ]]]];
 Exit[1]
 ];
