(* ::Package:: *)
(* 文件用途：检查 Kira backend 内部的相位能量变量 convention。
   只构造最小 synthetic linear relation，不写 Kira 文件，也不运行 reduction。 *)


(* ::Chapter:: *)
(*加载开发包与最小 topology*)

projectRoot = DirectoryName[DirectoryName[DirectoryName[$InputFileName]]];
packageDir = FileNameJoin[{projectRoot, "000_code", "018_dSIBP"}];
$Path = Prepend[$Path, packageDir];
Needs["dSIBP`"];
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
   "eulerOperatorInvariant" -> (eulerResidual === 0)
   |>;

failed = Keys@Select[checks, Not@TrueQ[#] &];
Print[InputForm[<|
   "passed" -> Count[Values[checks], True],
   "total" -> Length[checks],
   "failed" -> failed,
   "checks" -> checks
   |>]];
Exit[If[failed === {}, 0, 1]];
