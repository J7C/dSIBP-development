(* ::Package:: *)
(* 文件用途：检查 Kira backend 内部虚轴运动学变量 convention。
   覆盖顶点相位参数、fixed massless bridge 模长、cycle/fixed parity 边界和非原子坐标拒绝；
   只构造最小 synthetic linear relation，不写 Kira 文件，也不运行 reduction。 *)


(* ::Chapter:: *)
(*加载开发包与最小 topology*)

Get[FileNameJoin[{DirectoryName[$InputFileName], "..", "_harness.wls"}]];
projectRoot = DirectoryName[DirectoryName[DirectoryName[$InputFileName]]];
dsSmokeLoadPackage[FileNameJoin[{projectRoot, "versions", "023_dSIBP", "Kernel", "dSIBP.wl"}]];
DSMessagesOff[];

caseInput = <|
   "name" -> "CheckKiraEnergyConvention",
   "vertices" -> {
     <|"id" -> v1, "vertexType" -> "-", "externalLegEnergy" -> P0|>,
     <|"id" -> v2, "vertexType" -> "-", "externalLegEnergy" -> P0|>
     },
   "lines" -> {
     <|"id" -> 1, "massType" -> "massive", "endpoints" -> {v1, v2},
       "momentum" -> q, "nu" -> nu|>,
     <|"id" -> 2, "massType" -> "massive", "endpoints" -> {v1, v2},
       "momentum" -> q - k, "nu" -> nu|>
     },
   "loopMomenta" -> {q},
   "loopExternalMomenta" -> {k},
   "independentExternalMomenta" -> {},
   "ibpMode" -> "full",
   "kinematicRules" -> {sp[k, k] -> ss11^2},
   "ispData" -> {},
   "zeroPointRules" -> {
     a0[v1] -> 2 nu + ep, a0[v2] -> 2 nu + ep,
     b0[1] -> -2 nu, b0[2] -> -2 nu
     },
   "symmetryRules" -> {}
   |>;

context = DSInit[
   caseInput,
   RegisterAsCurrent -> False,
   WriteInitializationFiles -> False,
   GenerateDerivativeMetadata -> False,
   ProgressReporting -> False
   ];


(* ::Chapter:: *)
(*backend 映射、单点数值规则与导数 Jacobian*)

linearEquations = {
   <|"linearQ" -> True, "constantTerm" -> 0,
     "coefficientRules" -> {1 -> I P0, 2 -> -1}|>
   };
linearData = <|
   "status" -> "generated",
   "topology" -> context["topology"],
   "linearEquations" -> linearEquations
   |>;

convention = dSIBP`Private`kiraBackendKinematicConventionData[
   linearData, linearEquations
   ];
numericData = dSIBP`Private`kiraKinematicCoefficientRulesData[
   {P0 -> 29/13}, context["topology"], convention
   ];
backendKinematic = First[Lookup[convention, "backendKinematics", {Missing["backendKinematic"]}]];

probe = P0^3 + 2 P0;
backendProbe = probe /. Lookup[convention, "physicalToBackendRules", {}];
ordinaryResidual = Expand[
   (D[probe, P0] /. Lookup[convention, "physicalToBackendRules", {}]) -
    I D[backendProbe, backendKinematic]
   ];
eulerResidual = Expand[
   (P0 D[probe, P0] /. Lookup[convention, "physicalToBackendRules", {}]) -
    backendKinematic D[backendProbe, backendKinematic]
   ];


(* ::Chapter:: *)
(*Fixed massless bridge 的结构识别与 parity 边界*)

cycleParityConstraints = {
   b[1] + n[1, 1] + n[1, 2] -> 0,
   b[2] + n[2, 1] + n[2, 2] -> 0
   };
mixedInput = <|
   "name" -> "CheckKiraFixedMasslessKinematicConvention",
   "vertices" -> {
     <|"id" -> v1, "vertexType" -> "+", "externalLegEnergy" -> E1|>,
     <|"id" -> v2, "vertexType" -> "+", "externalLegEnergy" -> E2|>,
     <|"id" -> v3, "vertexType" -> "+", "externalLegEnergy" -> E3|>
     },
   "lines" -> {
     <|"id" -> 1, "massType" -> "massive", "endpoints" -> {v1, v2},
       "momentum" -> l1, "nu" -> nu1|>,
     <|"id" -> 2, "massType" -> "massless", "endpoints" -> {v1, v2},
       "momentum" -> l1 + k1 + k2|>,
     <|"id" -> 3, "massType" -> "massless", "endpoints" -> {v2, v3},
       "momentum" -> k1 + k2|>
     },
   "extLegs" -> {
     {bubbleLeg, v1, k1 + k2},
     {treeLeg1, v3, k1},
     {treeLeg2, v3, k2}
     },
   "loopMomenta" -> {l1},
   "loopExternalMomenta" -> {k1 + k2},
   "independentExternalMomenta" -> {k1, k2},
   "ibpMode" -> "full",
   "ispData" -> {},
   "zeroPointRules" -> {
     a0[v1] -> alpha1, a0[v2] -> alpha2, a0[v3] -> alpha3,
     b0[1] -> -2 nu1, b0[2] -> 0, b0[3] -> 0
     },
   "symmetryRules" -> {},
   "parityConstraints" -> cycleParityConstraints
   |>;
mixedKinematicRules = {
   sp[k1 + k2, k1 + k2] -> loopScale^2,
   sp[k1, k1] -> legScale1^2,
   sp[k2, k2] -> legScale2^2
   };
mixedContext = DSInit[
   mixedInput,
   KinematicRules -> mixedKinematicRules,
   RegisterAsCurrent -> False,
   WriteInitializationFiles -> False,
   GenerateDerivativeMetadata -> False,
   ProgressReporting -> False
   ];
mixedLinearEquations = {
   <|"linearQ" -> True, "constantTerm" -> 0,
     "coefficientRules" -> {1 -> I E1 loopScale, 2 -> -1}|>
   };
mixedLinearData = <|
   "status" -> "generated",
   "topology" -> mixedContext["topology"],
   "linearEquations" -> mixedLinearEquations
   |>;
mixedConvention = dSIBP`Private`kiraBackendKinematicConventionData[
   mixedLinearData, mixedLinearEquations
   ];
mixedNumericData = dSIBP`Private`kiraKinematicCoefficientRulesData[
   {
    loopScale -> 43/17, legScale1 -> 47/19, legScale2 -> 53/23,
    E1 -> 29/13, E2 -> 31/17, E3 -> 37/19
    },
   mixedContext["topology"],
   mixedConvention
   ];
mixedExpectedPhysicalPointRules = {
   kk[1, 1] -> -1849/289,
   loopScale -> -43 I/17, legScale1 -> 47/19, legScale2 -> 53/23,
   E1 -> -29 I/13, E2 -> -31 I/17, E3 -> -37 I/19
   };
mixedPhysicalKinematics = Lookup[mixedConvention, "physicalKinematics", {}];
mixedSourceOccurrences = Lookup[mixedConvention, "sourceOccurrences", {}];
mixedConventionValidator = dSIBP`Private`dsKiraBackendKinematicConventionDataQ[mixedConvention];
mixedLoopScaleRecord = SelectFirst[
   Lookup[mixedConvention, "records", {}],
   Lookup[#, "physical", None] === loopScale &,
   <||>
   ];
mixedBackendLoopScale = Lookup[mixedLoopScaleRecord, "backend", Missing["backendLoopScale"]];
mixedRestoredRule = dSIBP`Private`dsKiraRestorePhysicalKinematicVariables[
   {restoreProbe -> mixedBackendLoopScale^2},
   mixedConvention
   ];
mixedBackendDerivativeView = dSIBP`Private`dsDEBackendKinematicDerivativeView[
   <|loopScale -> {{loopScale}}, legScale1 -> {{legScale1}}, E1 -> {{E1}}|>,
   <|loopScale -> {loopScale}, legScale1 -> {legScale1}, E1 -> {E1}|>,
   {loopScale, legScale1, E1},
   mixedConvention
   ];


(* ::Chapter:: *)
(*Post-derivative 数值时序门禁*)

(* active-basis 内容只用于触发导出时序审计；本专项不构造或运行 reduction。 *)
auditActiveBasis = <|
   "status" -> "configured",
   "derivativeVariables" -> {loopScale, legScale1, legScale2, E1, E2, E3},
   "rawDerivatives" -> {{mixedLinearEquations[[1]]}},
   "derivativeTargetIntegrals" -> {1}
   |>;
postDerivativeRules = {
   loopScale -> 43/17, legScale1 -> 47/19, legScale2 -> 53/23,
   E1 -> 29/13, E2 -> 31/17, E3 -> 37/19
   };
symbolicPostDerivativeAudit = dSIBP`Private`dsKiraDEVariableRuleAudit[
   <|
    "topology" -> mixedContext["topology"],
    "activeBasis" -> auditActiveBasis,
    "coefficientRulesApplied" -> {}
    |>,
   postDerivativeRules,
   "postDerivative"
   ];
earlyKinematicAudit = dSIBP`Private`dsKiraDEVariableRuleAudit[
   <|
    "topology" -> mixedContext["topology"],
    "activeBasis" -> auditActiveBasis,
    "coefficientRulesApplied" -> {
      loopScale -> 43/17, E1 -> 29/13, E2 -> 31/17, E3 -> 37/19
      }
    |>,
   postDerivativeRules,
   "postDerivative"
   ];
unrotatedPreAppliedAudit = dSIBP`Private`dsKiraDEVariableRuleAudit[
   <|
    "topology" -> mixedContext["topology"],
    "activeBasis" -> auditActiveBasis,
    "coefficientRulesApplied" -> {legScale1 -> 47/19, legScale2 -> 53/23}
    |>,
   postDerivativeRules,
   "postDerivative"
   ];


(* ::Chapter:: *)
(*非原子 fixed massless 模长的自然语言失败*)

nonAtomicInput = Join[mixedInput, <|"name" -> "CheckKiraNonAtomicFixedMasslessMagnitude"|>];
nonAtomicContext = DSInit[
   nonAtomicInput,
   KinematicRules -> {
     sp[k1 + k2, k1 + k2] -> loopScale^2 + legScale1^2,
     sp[k1, k1] -> legScale1^2,
     sp[k2, k2] -> legScale2^2
     },
   RegisterAsCurrent -> False,
   WriteInitializationFiles -> False,
   GenerateDerivativeMetadata -> False,
   ProgressReporting -> False
   ];
nonAtomicBaseIntegral = dSIBP`Private`makeBaseIntegral[nonAtomicContext["topology"]];
nonAtomicSerializer = dSIBP`Private`makeKiraInputStrings[
   <|
    "status" -> "generated",
    "topology" -> nonAtomicContext["topology"],
    "topologyValidationReport" -> Lookup[nonAtomicContext["topology"], "validationReport", <|"status" -> "ok"|>],
    "linearEquations" -> {
      <|"linearQ" -> True, "constantTerm" -> 0, "coefficientRules" -> {1 -> E1}|>
      },
    "integralRules" -> {nonAtomicBaseIntegral -> 1},
    "integralCount" -> 1,
    "equationCount" -> 1
    |>,
   {},
   <|"AppendNumericDummyEquation" -> False|>,
   {1}
   ];


(* ::Chapter:: *)
(*符号与数值 Kira 实数化*)

(* 这两个积分只承载 serializer 的相位约束；不生成 IBP，也不写后端文件。 *)
serializerLinearData = <|
   "status" -> "generated",
   "topology" -> context["topology"],
   "topologyValidationReport" -> Lookup[context["topology"], "validationReport", <|"status" -> "ok"|>],
   "linearEquations" -> {
     <|"linearQ" -> True, "constantTerm" -> 0,
       "coefficientRules" -> {1 -> P0, 2 -> 1}|>
     },
   "integralRules" -> {
     J[{0, 0}, {{0, 0, 0}, {0, 0, 0}}, {}] -> 1,
     J[{1, 0}, {{0, 0, 0}, {0, 0, 0}}, {}] -> 2
     },
   "integralCount" -> 2,
   "equationCount" -> 1
   |>;

symbolicSerializer = dSIBP`Private`makeKiraInputStrings[
   serializerLinearData,
   {},
   <|"AppendNumericDummyEquation" -> False|>,
   {1, 2}
   ];
numericSerializer = dSIBP`Private`makeKiraInputStrings[
   serializerLinearData,
   {P0 -> 29/13},
   <|"AppendNumericDummyEquation" -> False|>,
   {1, 2}
   ];

symbolicPhaseGauge = dSIBP`Private`kiraGaussianPhaseRationalize[
   {
    <|"linearQ" -> True, "constantTerm" -> 0,
      "coefficientRules" -> {1 -> I x/(1 + x), 2 -> -1/(1 + x)}|>
    },
   2
   ];
mixedAxisFailure = dSIBP`Private`kiraGaussianPhaseRationalize[
   {
    <|"linearQ" -> True, "constantTerm" -> 0,
      "coefficientRules" -> {1 -> 1 + I x, 2 -> 1}|>
    },
   2
   ];

symbolicKiraText = Lookup[symbolicSerializer, "ibp.kira", ""];
numericKiraText = Lookup[numericSerializer, "ibp.kira", ""];
forbiddenBackendTokenQ[text_String] := Or @@ (StringContainsQ[text, #] & /@ {"I", "Complex", "dsii"});


(* ::Chapter:: *)
(*验收*)

checks = <|
   "initialized" -> (Lookup[context, "status", "failed"] === "initialized"),
   "backendOnlyScope" -> (Lookup[convention, "scope", None] === "KiraBackendOnly"),
   "physicalToBackend" ->
    (Lookup[convention, "physicalToBackendRules", {}] === {P0 -> -I ip0}),
   "singleRealRationalPoint" ->
    (Lookup[numericData, "kinematicNumericRules", {}] === {ip0 -> 29/13}),
   "physicalPointRestored" ->
    (Lookup[numericData, "physicalPointRules", {}] === {P0 -> -29 I/13}),
   "ordinaryDerivativeJacobian" -> (ordinaryResidual === 0),
   "eulerOperatorInvariant" -> (eulerResidual === 0),
   "mixedInitialized" -> (Lookup[mixedContext, "status", "failed"] === "initialized"),
   "cycleLinesIndexedBridgeFixed" ->
    (Lookup[mixedContext["topology"]["lines"], "linePowerMode", {}] === {"indexed", "indexed", "fixedCoefficient"}),
   "cyclePropagatorsAllEven" ->
    (Lookup[mixedContext["topology"], "parityConstraints", {}] === cycleParityConstraints),
   "fixedBridgeExcludedFromParity" -> FreeQ[cycleParityConstraints, b[3] | n[3, _]],
   "mixedKinematicsIncludeFixedBridge" ->
    (Sort[mixedPhysicalKinematics] === Sort[{E1, E2, E3, loopScale}]),
   "cycleCoordinateExcludedFromKinematics" -> FreeQ[mixedPhysicalKinematics, xi[_]],
   "independentLegScalesNotRotated" -> FreeQ[mixedPhysicalKinematics, legScale1 | legScale2],
   "fixedBridgeOccurrenceRecorded" -> AnyTrue[
     mixedSourceOccurrences,
     Lookup[#, "role", None] === "fixedMasslessPropagatorMomentumMagnitude" &&
       Lookup[#, "lineId", None] === 3 && Lookup[#, "physical", None] === loopScale &
     ],
   "mixedConventionPassesImportValidator" -> TrueQ[mixedConventionValidator],
   "mixedImportRestoresFixedBridgeCoordinate" ->
    (mixedRestoredRule === {restoreProbe -> -loopScale^2}),
   "mixedDEBackendViewIncludesFixedBridge" ->
    MemberQ[Lookup[mixedBackendDerivativeView, "backendVariables", {}], mixedBackendLoopScale],
   "mixedDEBackendViewExcludesUnrotatedLegScale" ->
    FreeQ[Lookup[mixedBackendDerivativeView, "records", {}], legScale1],
   "mixedPhysicalPointRotatesRequiredKinematics" -> With[
     {actual = Lookup[mixedNumericData, "physicalPointRules", {}]},
     Length[actual] === Length[mixedExpectedPhysicalPointRules] &&
       And @@ (MemberQ[actual, #] & /@ mixedExpectedPhysicalPointRules)
     ],
   "mixedBackendLoopScaleIsPositiveRational" ->
    MemberQ[Lookup[mixedNumericData, "backendRules", {}], mixedBackendLoopScale -> 43/17],
   "mixedDependentLoopCoordinateIsConsistent" ->
    MemberQ[Lookup[mixedNumericData, "normalizedPhysicalRules", {}], kk[1, 1] -> -1849/289] &&
      TrueQ[Lookup[mixedNumericData, "coordinateConsistencyQ", False]],
   "symbolicLinearDataAcceptedAtPostDerivative" ->
    TrueQ[Lookup[symbolicPostDerivativeAudit, "passQ", False]],
   "earlyImaginaryAxisKinematicsRejected" ->
    (Lookup[earlyKinematicAudit, "reason", None] === "imaginaryAxisKinematicsAlreadyNumerical"),
   "earlyDependentCoordinateReported" ->
    MemberQ[Lookup[earlyKinematicAudit, "imaginaryAxisProtectedAtoms", {}], kk[1, 1]],
   "unrotatedPreAppliedCoordinatesAllowed" ->
    TrueQ[Lookup[unrotatedPreAppliedAudit, "passQ", False]],
   "nonAtomicFixedMagnitudeRejected" ->
    (Lookup[nonAtomicSerializer, "status", "missing"] === "invalidBackendKinematicConvention"),
   "nonAtomicFailureNamesKinematicRules" -> StringContainsQ[
     ToString[Lookup[nonAtomicSerializer, "message", ""]],
     "KinematicRules"
     ],
   "symbolicPhaseGaugeAccepted" ->
    MemberQ[{"applied", "notRequired"}, Lookup[symbolicPhaseGauge, "status", "failed"]],
   "symbolicPhaseGaugeReal" ->
    FreeQ[Lookup[symbolicPhaseGauge, "linearEquations", {}], _Complex],
   "mixedRealImaginaryRejected" ->
    (Lookup[mixedAxisFailure, "status", "missing"] === "notRationalizable"),
   "symbolicSerializerGenerated" ->
    (Lookup[symbolicSerializer, "status", "missing"] === "generated"),
   "symbolicBackendTextReal" -> ! forbiddenBackendTokenQ[symbolicKiraText],
   "numericSerializerGenerated" ->
    (Lookup[numericSerializer, "status", "missing"] === "generated"),
   "numericBackendPureRational" ->
    TrueQ[Lookup[numericSerializer, "pureRationalBackendQ", False]],
   "numericBackendVariablesEmpty" ->
    (Lookup[numericSerializer, "backendCoefficientVariables", Missing["variables"]] === {}),
   "numericBackendTextReal" -> ! forbiddenBackendTokenQ[numericKiraText]
   |>;

failed = Keys@Select[checks, Not@TrueQ[#] &];
Print["check_kira_energy_convention: ", Count[Values[checks], True], "/", Length[checks]];
Print["failed: ", InputForm[failed]];
Print[InputForm[<|"passed" -> Count[Values[checks], True], "total" -> Length[checks], "failed" -> failed,"checks" -> checks|>]];
If[Count[Values[checks], True] =!= Length[checks], Exit[1]];
