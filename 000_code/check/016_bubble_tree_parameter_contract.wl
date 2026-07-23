(* ::Package:: *)
(* 本正式专项固定 bubble+tree family，验证矢量和模长、独立顶点相位、用户参数绑定及
   exact/over/under capability 合同。它只检查公开 016 接口，不生成独立手推 expected。 *)

(* ::Chapter:: *)
(*加载 016*)

checkDir = DirectoryName[$InputFileName];
codeDir = DirectoryName[checkDir];
packageDir = FileNameJoin[{codeDir, "016_dSIBP"}];
If[! MemberQ[$Path, packageDir], AppendTo[$Path, packageDir]];
Needs["dSIBP`"];
DSMessagesOff[];


(* ::Chapter:: *)
(*固定 bubble+tree 输入*)

caseInput = <|
   "name" -> "016BubbleTreeParameterContract",
   "vertexData" -> {{v1, "+"}, {v2, "+"}, {v3, "+"}},
   "lineData" -> {
     <|"id" -> 1, "endpoints" -> {v1, v2}, "momentum" -> l1,
       "nu" -> nu1, "bbType" -> "h", "massType" -> "massive"|>,
     <|"id" -> 2, "endpoints" -> {v1, v2}, "momentum" -> l1 + k1 + k2,
       "nu" -> nu2, "bbType" -> "h", "massType" -> "massive"|>,
     <|"id" -> 3, "endpoints" -> {v2, v3}, "momentum" -> k1 + k2,
       "nu" -> nu3, "bbType" -> "h", "massType" -> "massive"|>
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
   "vertexEnergies" -> <|v1 -> E1, v2 -> E2, v3 -> E3|>,
   "ispData" -> {},
   "zeroPointRules" -> {
     a0[v1] -> alpha1, a0[v2] -> alpha2, a0[v3] -> alpha3,
     b0[1] -> beta1, b0[2] -> beta2, b0[3] -> beta3
     },
   "symmetryRules" -> {},
   "seedPreset" -> "quickCheck"
   |>;

defaultRules = {
   sp[k1 + k2, k1 + k2] -> ss11^2,
   sp[k1, k1] -> sE1^2,
   sp[k2, k2] -> sE2^2
   };


(* ::Chapter:: *)
(*基准初始化与内部变量闭合*)

proposal = DSKinematics[caseInput];
context = DSInit[
   caseInput,
   WriteInitializationFiles -> False,
   GenerateDerivativeMetadata -> True,
   RegisterAsCurrent -> False,
   ProgressReporting -> False
   ];
topology = Lookup[context, "topology", <||>];
notation = DSParameterNotation[context];
derivativeVariables = Lookup[
   Lookup[context, "derivatives", <||>],
   "operators",
   {}
   ][[All, "userVariable"]];

integral = J[
   {0, 0, 0},
   {{0, 0, 0}, {0, 0, 0}, {0, 0}},
   {}
   ];
derivativeProbe = ds[
   (ss11 + sE1 + E1) integral + ss11*sE2,
   ss11,
   topology
   ];
internalCoordinates = Cases[
   derivativeProbe,
   HoldPattern[(kk | qq | qk | xi | dSIBP`Private`externalLegSquaredCoordinate)[___]],
   Infinity
   ];


(* ::Chapter:: *)
(*保留双外腿的模长和绑定*)

boundInput = Join[
   caseInput,
   <|"name" -> "016BubbleTreeBoundEnergy", "vertexEnergies" -> <|v1 -> E1, v2 -> E2, v3 -> E0|>|>
   ];
boundContext0 = DSInit[
   boundInput,
   WriteInitializationFiles -> False,
   GenerateDerivativeMetadata -> True,
   RegisterAsCurrent -> False,
   ProgressReporting -> False
   ];
boundRules = {
   sp[k1 + k2, k1 + k2] -> ss11^2,
   sp[k1, k1] -> (E0 - sE2)^2,
   sp[k2, k2] -> sE2^2
   };
boundContext = DSRedefineParameters[boundContext0, boundRules, ProgressReporting -> False];
boundVariables = Lookup[
   Lookup[boundContext, "derivatives", <||>],
   "operators",
   {}
   ][[All, "userVariable"]];
boundDerivative = ds[E0^2 integral, E0, Lookup[boundContext, "topology", <||>]];


(* ::Chapter:: *)
(*单一有效外腿 topology*)

singleLegInput = Join[
   caseInput,
   <|
    "name" -> "016BubbleTreeSingleEffectiveLeg",
    "extLegs" -> {
      {bubbleLeg, v1, k1 + k2},
      {treeLeg0, v3, p0}
      },
    "independentExternalMomenta" -> {p0},
    "vertexEnergies" -> <|v1 -> E1, v2 -> E2, v3 -> E0|>
    |>
   ];
singleLegContext0 = DSInit[
   singleLegInput,
   WriteInitializationFiles -> False,
   GenerateDerivativeMetadata -> True,
   RegisterAsCurrent -> False,
   ProgressReporting -> False
   ];
singleLegContext = DSRedefineParameters[
   singleLegContext0,
   {
    sp[k1 + k2, k1 + k2] -> ss11^2,
    sp[p0, p0] -> E0^2
    },
   ProgressReporting -> False
   ];
singleLegVariables = Lookup[
   Lookup[singleLegContext, "derivatives", <||>],
   "operators",
   {}
   ][[All, "userVariable"]];


(* ::Chapter:: *)
(*过完备与欠完备门禁*)

overLoopAudit = DSKinematics[Join[caseInput, <|"loopExternalMomenta" -> {k1 + k2, k1 - k2}|>]];
underLoopAudit = DSKinematics[Join[caseInput, <|"loopExternalMomenta" -> {k1}|>]];
overLegAudit = DSKinematics[Join[caseInput, <|"independentExternalMomenta" -> {k1, k2, k1 - k2}|>]];
underLegAudit = DSKinematics[Join[caseInput, <|"independentExternalMomenta" -> {k1}|>]];

overContext = DSInit[
   Join[caseInput, <|"independentExternalMomenta" -> {k1, k2, k1 - k2}|>],
   WriteInitializationFiles -> False,
   RegisterAsCurrent -> False,
   ProgressReporting -> False
   ];
underContext = DSInit[
   Join[caseInput, <|"independentExternalMomenta" -> {k1}|>],
   WriteInitializationFiles -> False,
   RegisterAsCurrent -> False,
   ProgressReporting -> False
   ];


(* ::Chapter:: *)
(*结果门禁*)

checks = <|
   "version" -> $dSIBPVersion === "016",
   "proposalComplete" -> Lookup[proposal, "status", None] === "complete",
   "defaultRules" -> Lookup[proposal, "defaultRules", {}] === defaultRules,
   "baseInitialized" -> Lookup[context, "status", None] === "initialized",
   "loopRole" -> Lookup[notation, "loopExternalMomenta", {}] === {k1 + k2},
   "independentRole" -> Lookup[notation, "independentExternalMomenta", {}] === {k1, k2},
   "baseCoordinates" -> Lookup[notation, "selectedUserVariables", {}] === {ss11, sE1, sE2},
   "baseDerivativeVariables" -> derivativeVariables === {ss11, sE1, sE2, E1, E2, E3},
   "phaseEnergyIndependent" -> Lookup[topology, "vertexEnergies", <||>] === <|v1 -> E1, v2 -> E2, v3 -> E3|>,
   "vectorSumMagnitudeDistinct" -> ! SameQ[
     Sqrt[sp[k1 + k2, k1 + k2]],
     Sqrt[sp[k1, k1]] + Sqrt[sp[k2, k2]]
     ],
   "guideUsesOriginalSP" -> StringContainsQ[
      Lookup[Lookup[notation, "parameterRedefinitionGuide", <||>], "commandExample", ""],
      "sp[k1 + k2, k1 + k2]"
      ],
   "derivativeHasNoInternalCoordinate" -> internalCoordinates === {},
   "boundInitialized" -> Lookup[boundContext, "status", None] === "initialized",
   "boundVariables" -> boundVariables === {ss11, E0, sE2, E1, E2},
   "boundDerivativeAvailable" -> boundDerivative =!= $Failed,
   "singleLegInitialized" -> Lookup[singleLegContext, "status", None] === "initialized",
   "singleLegMomentumChanged" -> Lookup[Lookup[singleLegContext, "topology", <||>], "independentExternalMomenta", {}] === {p0},
   "singleLegVariables" -> singleLegVariables === {ss11, E0, E1, E2},
   "overLoopStatus" -> Lookup[overLoopAudit, "status", None] === "overcomplete",
   "underLoopStatus" -> Lookup[underLoopAudit, "status", None] === "undercomplete",
   "overLegStatus" -> Lookup[overLegAudit, "status", None] === "overcomplete",
   "underLegStatus" -> Lookup[underLegAudit, "status", None] === "undercomplete",
   "overContinuesSymbolically" -> Lookup[overContext, "status", None] === "initialized",
   "overDerivativeDisabled" -> ! TrueQ[Lookup[Lookup[overContext, "capabilities", <||>], "derivativeUsableQ", True]],
   "underRejected" -> Lookup[underContext, "status", None] === "failed"
   |>;

Print["016 bubble+tree parameter contract: ", Count[Values[checks], True], "/", Length[checks]];
If[! And @@ Values[checks],
 Print["FAILED: ", Keys@Select[checks, ! TrueQ[#] &]];
 Print["internal coordinates: ", InputForm[internalCoordinates]];
 Exit[1]
 ];
