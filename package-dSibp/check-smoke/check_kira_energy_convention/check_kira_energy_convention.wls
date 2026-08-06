(* ::Package:: *)
(* 文件用途：检查 Kira backend 内部的相位能量变量 convention。
   只构造最小 synthetic linear relation，不写 Kira 文件，也不运行 reduction。 *)


(* ::Chapter:: *)
(*加载开发包与最小 topology*)

Get[FileNameJoin[{DirectoryName[$InputFileName], "..", "_harness.wls"}]];
projectRoot = DirectoryName[DirectoryName[DirectoryName[$InputFileName]]];
dsSmokeLoadPackage[FileNameJoin[{projectRoot, "versions", "018_dSIBP", "Kernel", "dSIBP.wl"}]];
DSMessagesOff[];

caseInput = <|
   "name" -> "CheckKiraEnergyConvention",
   "vertexData" -> {{v1, "-"}, {v2, "-"}},
   "lineData" -> {
     <|"id" -> 1, "endpoints" -> {v1, v2}, "momentum" -> q,
       "massType" -> "massive", "bbType" -> "h", "nu" -> nu|>,
     <|"id" -> 2, "endpoints" -> {v1, v2}, "momentum" -> q - k,
       "massType" -> "massive", "bbType" -> "h", "nu" -> nu|>
     },
   "loopMomenta" -> {q},
   "loopExternalMomenta" -> {k},
   "independentExternalMomenta" -> {},
   "ibpMode" -> "full",
   "externalInvariantRules" -> {sp[k, k] -> ss11^2},
   "vertexEnergies" -> <|v1 -> P0, v2 -> P0|>,
   "ispData" -> {},
   "zeroPointRules" -> {
     a0[v1] -> 2 nu, a0[v2] -> 2 nu,
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

convention = dSIBP`Private`kiraBackendEnergyConventionData[
   linearData, linearEquations
   ];
numericData = dSIBP`Private`kiraEnergyCoefficientRulesData[
   {P0 -> 29/13}, convention
   ];
backendEnergy = First[Lookup[convention, "backendEnergies", {Missing["backendEnergy"]}]];

probe = P0^3 + 2 P0;
backendProbe = probe /. Lookup[convention, "physicalToBackendRules", {}];
ordinaryResidual = Expand[
   (D[probe, P0] /. Lookup[convention, "physicalToBackendRules", {}]) -
    I D[backendProbe, backendEnergy]
   ];
eulerResidual = Expand[
   (P0 D[probe, P0] /. Lookup[convention, "physicalToBackendRules", {}]) -
    backendEnergy D[backendProbe, backendEnergy]
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
    (Lookup[numericData, "energyNumericRules", {}] === {ip0 -> 29/13}),
   "physicalPointRestored" ->
    (Lookup[numericData, "physicalPointRules", {}] === {P0 -> -29 I/13}),
   "ordinaryDerivativeJacobian" -> (ordinaryResidual === 0),
   "eulerOperatorInvariant" -> (eulerResidual === 0),
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
