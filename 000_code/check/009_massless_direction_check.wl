(* ::Package:: *)
(* 009 massless 有方向单 n 与 theta-boundary 的极小回归。 *)

(* ::Chapter:: *)
(*初始化*)

Get[FileNameJoin[{DirectoryName[$InputFileName], "..", "009_dS_ibp_general.wl"}]];

masslessCase = <|
   "name" -> "masslessDirectedOneLine",
   "vertexData" -> {{v1, "+"}, {v2, "+"}},
   "lineData" -> {
     <|"id" -> 1, "endpoints" -> {v1, v2}, "momentum" -> ell,
       "nu" -> 0, "bbType" -> "exp", "massType" -> "massless", "skType" -> "++"|>
     },
   "loopMomenta" -> {ell},
   "externalMomenta" -> {},
   "vertexEnergies" -> <|v1 -> ke[1], v2 -> ke[2]|>,
   "numericRules" -> {ke[1] -> 2, ke[2] -> 3},
   "zeroPointRules" -> {
     a0[v1] -> alpha1, a0[v2] -> alpha2,
     b0[1] -> beta1, bS0[1] -> betaS1
     },
   "sampleDiscreteRules" -> {{n[1] -> 0}, {n[1] -> 1}}
   |>;

topo = parseTopology[masslessCase];
reversedTopo = parseTopology[
   Join[masslessCase, <|
     "name" -> "masslessDirectedOneLineReversed",
     "lineData" -> {
       <|"id" -> 1, "endpoints" -> {v2, v1}, "momentum" -> ell,
         "nu" -> 0, "bbType" -> "exp", "massType" -> "massless", "skType" -> "++"|>
       }
     |>]
   ];

minusTopo = parseTopology[
   Join[masslessCase, <|
     "name" -> "masslessDirectedOneLineMinusMinus",
     "vertexData" -> {{v1, "-"}, {v2, "-"}},
     "lineData" -> {
       <|"id" -> 1, "endpoints" -> {v1, v2}, "momentum" -> ell,
         "nu" -> 0, "bbType" -> "exp", "massType" -> "massless", "skType" -> "--"|>
       }
     |>]
   ];

crossPMTopo = parseTopology[
   Join[masslessCase, <|
     "name" -> "masslessCrossPlusMinus",
     "vertexData" -> {{v1, "+"}, {v2, "-"}},
     "lineData" -> {
       <|"id" -> 1, "endpoints" -> {v1, v2}, "momentum" -> ell,
         "nu" -> 0, "bbType" -> "exp", "massType" -> "massless", "skType" -> "+-"|>
       },
     "sampleDiscreteRules" -> {{}}
     |>]
   ];

crossMPTopo = parseTopology[
   Join[masslessCase, <|
     "name" -> "masslessCrossMinusPlus",
     "vertexData" -> {{v1, "-"}, {v2, "+"}},
     "lineData" -> {
       <|"id" -> 1, "endpoints" -> {v1, v2}, "momentum" -> ell,
         "nu" -> 0, "bbType" -> "exp", "massType" -> "massless", "skType" -> "-+"|>
       },
     "sampleDiscreteRules" -> {{}}
     |>]
   ];

int0 = J[{aa1, aa2}, {{bb, 0}}, {}];
int1 = J[{aa1, aa2}, {{bb, 1}}, {}];
shrunk = J[{aa1 + aa2 - 1}, {{bb}}, {}];
crossInt = J[{aa1, aa2}, {{bb}}, {}];

(* ::Chapter:: *)
(*端点方向与时间导数*)

timeU0 = Expand[timeMasslessEndpointDerivativeTerms[topo, int0, v1]];
timeV0 = Expand[timeMasslessEndpointDerivativeTerms[topo, int0, v2]];
timeU1 = Expand[timeMasslessEndpointDerivativeTerms[topo, int1, v1]];
timeReversedAtV1 = Expand[timeMasslessEndpointDerivativeTerms[reversedTopo, int0, v1]];

secondRegular = Expand[
   timeU0 /. (x_J :> timeMasslessEndpointDerivativeTerms[topo, x, v1])
   ];

boundaryU1 = Expand[timeThetaBoundaryShrinkTerms[topo, int1, v1]];
boundaryV1 = Expand[timeThetaBoundaryShrinkTerms[topo, int1, v2]];

timeMinusU0 = Expand[timeMasslessEndpointDerivativeTerms[minusTopo, int0, v1]];
timeMinusV0 = Expand[timeMasslessEndpointDerivativeTerms[minusTopo, int0, v2]];
timeCrossPMU = Expand[timeMasslessEndpointDerivativeTerms[crossPMTopo, crossInt, v1]];
timeCrossPMV = Expand[timeMasslessEndpointDerivativeTerms[crossPMTopo, crossInt, v2]];
timeCrossMPU = Expand[timeMasslessEndpointDerivativeTerms[crossMPTopo, crossInt, v1]];
timeCrossMPV = Expand[timeMasslessEndpointDerivativeTerms[crossMPTopo, crossInt, v2]];
externalPlus = Expand[timeExternalEnergyTerm[topo, int0, v1]];
externalMinus = Expand[timeExternalEnergyTerm[minusTopo, int0, v1]];

(* ::Chapter:: *)
(*圈动量导数*)

momentumGenerator = First @ Select[makeIBPGenerators[topo], #["type"] === "momentum" &];
spRules = makeScalarProductRules[topo];
momentumMassless = Expand[
   momentumBuildingBlockDerivativeTerms[
    topo, int0, momentumGenerator, spRules["repSP2Z"]
    ]
   ];
expectedMomentumMassless =
   -I J[{aa1 + 1, aa2}, {{bb - 1, 1}}, {}] +
    I J[{aa1, aa2 + 1}, {{bb - 1, 1}}, {}];

(* ::Chapter:: *)
(*Canonical 与 sector*)

explicitN2 = J[{aa1, aa2}, {{bb, 2}}, {}];
coincidentTopo = Join[
   topo,
   <|"lines" -> {Join[topo["lines"][[1]], <|"endpoints" -> {v1, v1}|>]}|>
   ];
coincidentN1 = J[{aa1, aa2}, {{bb, 1}}, {}];
(* 同一 active vertex 上共同 time derivative 的 regular 与 theta-delta 项必须分别抵消。 *)
coincidentRegular = Expand[timeMasslessEndpointDerivativeTerms[coincidentTopo, int0, v1]];
coincidentBoundary = Expand[timeThetaBoundaryShrinkTerms[coincidentTopo, int1, v1]];


preparedTopo = makeTopologyData[
   masslessCase,
   PrecomputeShrinkSectorMetadata -> True,
   MaxShrinkSectorDepth -> Automatic,
   MaxShrinkSectorCount -> 4
   ];
canonicalBatch = makeCanonicalSeedBatch[
   preparedTopo,
   DiscreteMode -> "sample",
   MaxSeedRuleCount -> 4,
   MaxDiscreteRuleCount -> 4,
   MaxEquationCount -> 40,
   MaxShrinkSectorDepth -> Automatic,
   MaxShrinkSectorCount -> 4
   ];
coverageReport = makeCanonicalSeedCoverageReport[canonicalBatch];

checks = <|
   "referenceEndpointRecorded" ->
     (topo["lines"][[1]]["masslessN1ReferenceEndpoint"] === v1),
   "oppositeEndpointRecorded" ->
     (topo["lines"][[1]]["masslessN1OppositeEndpoint"] === v2),
   "timeFirstEndpointN0" ->
     (timeU0 === I J[{aa1, aa2}, {{bb - 1, 1}}, {}]),
   "timeSecondEndpointN0" ->
     (timeV0 === -I J[{aa1, aa2}, {{bb - 1, 1}}, {}]),
   "timeFirstEndpointN1" ->
     (timeU1 === I J[{aa1, aa2}, {{bb - 1, 0}}, {}]),
   "endpointReversalFlipsN1Direction" ->
     (timeReversedAtV1 === -I J[{aa1, aa2}, {{bb - 1, 1}}, {}]),
   "sameEndpointSecondDerivativeReturnsN0WithMinus" ->
     (secondRegular === -J[{aa1, aa2}, {{bb - 2, 0}}, {}]),
   "masslessBoundaryFirstEndpoint" -> (boundaryU1 === -2 shrunk),
   "masslessBoundarySecondEndpoint" -> (boundaryV1 === 2 shrunk),
   "minusMinusFirstEndpointSign" ->
     (timeMinusU0 === -I J[{aa1, aa2}, {{bb - 1, 1}}, {}]),
   "minusMinusSecondEndpointSign" ->
     (timeMinusV0 === I J[{aa1, aa2}, {{bb - 1, 1}}, {}]),
   "plusMinusCrossEndpointSigns" ->
     (timeCrossPMU === I J[{aa1, aa2}, {{bb - 1}}, {}] &&
       timeCrossPMV === -I J[{aa1, aa2}, {{bb - 1}}, {}]),
   "minusPlusCrossEndpointSigns" ->
     (timeCrossMPU === -I J[{aa1, aa2}, {{bb - 1}}, {}] &&
       timeCrossMPV === I J[{aa1, aa2}, {{bb - 1}}, {}]),
   "plusVertexExternalPhaseSign" -> (externalPlus === -I ke[1] int0),
   "minusVertexExternalPhaseSign" -> (externalMinus === I ke[1] int0),
   "masslessMomentumKernelDerivative" ->
     (Expand[momentumMassless - expectedMomentumMassless] === 0),
   "masslessN2IsRejectedNotAmbiguouslyReduced" ->
     (forbiddenNData[topo, explicitN2] =!= {} &&
       applySeedCanonical[explicitN2, topo] === explicitN2),
   "coincidentAntisymmetricStateVanishes" ->
     (applyMasslessEndpointCanonical[coincidentN1, coincidentTopo] === 0),
   "coincidentRegularTermsCancel" ->
     (coincidentRegular === 0),
   "coincidentThetaDeltaTermsCancel" ->
     (coincidentBoundary === 0),
   "masslessLineParticipatesInShrinkSubsets" ->
     (shrinkSectorSubsets[topo, Automatic, 4]["subsets"] === {{1}}),
   "masslessShrinkKeepsB" ->
     (shrinkLineIntegral[topo, int1, 1] === shrunk),
   "topologyValidationOK" ->
     (preparedTopo["validationReport"]["status"] === "ok"),
   "canonicalBatchReady" ->
     TrueQ[canonicalBatch["completeCanonicalQ"]],
   "canonicalBatchHasMasslessShrinkSector" ->
     MemberQ[Lookup[canonicalBatch["sectorMetadataList"], "sectorKey"], "e1"],
   "canonicalBatchCoverageComplete" ->
     TrueQ[coverageReport["passQ"]],
   "canonicalBatchHasNoForbiddenN" ->
     TrueQ[canonicalBatch["forbiddenNData"] === {}]
   |>;

Scan[
  Function[key,
   Print[key, ": ", checks[key]]
   ],
  Keys[checks]
  ];
Print["009 massless checks: ", Count[Values[checks], True], "/", Length[checks]];

If[! And @@ Values[checks], Exit[1]];
