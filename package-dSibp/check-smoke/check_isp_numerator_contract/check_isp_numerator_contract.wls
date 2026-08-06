(* ::Package:: *)
(* 文件用途：检查 018 的 ISP 指数合同。ISP 定义零点固定为 0，但用户可显式选择
   负整数范围；package 自动反推 seed 域时不得把用户下界继续向负方向扩张。
   本脚本只运行小范围符号检查，不生成 linearData，不调用 Kira 或 reduction。 *)

$HistoryLength = 0;


(* ::Chapter:: *)
(*加载开发 package*)

Get[FileNameJoin[{DirectoryName[$InputFileName], "..", "_harness.wls"}]];
projectDirectory = ExpandFileName[FileNameJoin[{DirectoryName[$InputFileName], "..", ".."}]];
dsSmokeLoadPackage[FileNameJoin[{projectDirectory, "versions", "018_dSIBP", "Kernel", "dSIBP.wl"}]];
DSMessagesOff[];


(* ::Chapter:: *)
(*合法与非法 ISP topology*)

validCase = <|
   "name" -> "ISPNumeratorContract",
   "vertexData" -> {{v1, "+"}, {v2, "+"}},
   "lineData" -> {
     <|"id" -> e1, "endpoints" -> {v1, v2}, "momentum" -> q1,
       "massType" -> "massive", "bbType" -> "h", "nu" -> nuM|>,
     <|"id" -> e2, "endpoints" -> {v1, v2}, "momentum" -> q2,
       "massType" -> "massless", "bbType" -> "exp", "nu" -> 0|>,
     <|"id" -> e3, "endpoints" -> {v1, v2}, "momentum" -> k - q1 - q2,
       "massType" -> "massless", "bbType" -> "exp", "nu" -> 0|>
     },
   "loopMomenta" -> {q1, q2},
   "loopExternalMomenta" -> {k},
   "independentExternalMomenta" -> {},
   "ibpMode" -> "full",
   "vertexEnergies" -> <|v1 -> E, v2 -> E|>,
   "ispData" -> {
     <|"name" -> rho1, "expr" -> sp[q1, k], "range" -> {0, 1}|>,
     <|"name" -> rho2, "expr" -> sp[q2, k], "range" -> {0, 1, 2}|>
     },
   "zeroPointRules" -> {
     a0[v1] -> alpha, a0[v2] -> alpha,
     b0[e1] -> betaM, b0[e2] -> beta0, b0[e3] -> beta0
     },
   "symmetryRules" -> {},
   "parityConstraints" -> {},
   "seedPreset" -> "quickCheck",
   "seedRanges" -> <|"a" -> {0}, "b" -> {0}, "isp" -> {0, 1}|>
   |>;

negativeDefinitionCase = Join[
   validCase,
   <|"name" -> "NegativeISPDefinition",
     "ispData" -> ReplacePart[validCase["ispData"], {1, "range"} -> {-1, 0, 1}]|>
   ];
nonzeroDefinitionCase = Join[
   validCase,
   <|"name" -> "NonzeroISPZeroPoint",
     "ispData" -> ReplacePart[
       validCase["ispData"],
       1 -> Join[validCase["ispData"][[1]], <|"zeroPoint" -> 1|>]
       ]|>
   ];
negativeSeedCase = Join[
   validCase,
   <|"name" -> "NegativeISPSeedRange",
     "seedRanges" -> <|"a" -> {0}, "b" -> {0}, "isp" -> {-1, 1}|>|>
   ];

context = DSInit[
   validCase,
   WriteInitializationFiles -> False,
   GenerateDerivativeMetadata -> False,
   ProgressReporting -> False
   ];
negativeDefinitionContext = DSInit[
   negativeDefinitionCase,
   RegisterAsCurrent -> False,
   WriteInitializationFiles -> False,
   GenerateDerivativeMetadata -> False,
   ProgressReporting -> False
   ];
nonzeroDefinitionContext = DSInit[
   nonzeroDefinitionCase,
   RegisterAsCurrent -> False,
   WriteInitializationFiles -> False,
   GenerateDerivativeMetadata -> False,
   ProgressReporting -> False
   ];
negativeSeedContext = DSInit[
   negativeSeedCase,
   RegisterAsCurrent -> False,
   WriteInitializationFiles -> False,
   GenerateDerivativeMetadata -> False,
   ProgressReporting -> False
   ];


(* ::Chapter:: *)
(*求导、target envelope 与 integrand*)

topology = context["topology"];
baseIntegral = dSIBP`Private`makeBaseIntegral[topology];
zeroIntegral = baseIntegral /. {
    HoldPattern[a[_]] -> 0,
    HoldPattern[b[_]] -> 0,
    HoldPattern[bS[_]] -> 0,
    HoldPattern[n[__]] -> 0,
    HoldPattern[ispN[_]] -> 0
    };
positiveIntegral = ReplacePart[zeroIntegral, {{3, 1} -> 2, {3, 2} -> 1}];
negativeIntegral = ReplacePart[zeroIntegral, {3, 1} -> -1];

momentumGenerator = SelectFirst[
   dSIBP`Private`makeIBPGenerators[topology],
   Lookup[#, "type", ""] === "momentum" &
   ];
scalarProductRules = dSIBP`Private`makeScalarProductRules[topology];
zeroISPDerivative = dSIBP`Private`momentumISPDerivativeTerms[
   topology,
   zeroIntegral,
   momentumGenerator,
   scalarProductRules["repSP2Z"]
   ];

validRangeAudit = dSIBP`Private`dsRangeSpecificationAudit[
   {ispN[1]},
   {{ispN[1], 0, 2}}
   ];
negativeRangeAudit = dSIBP`Private`dsRangeSpecificationAudit[
   {ispN[1]},
   {{ispN[1], -1, 1}}
   ];
derivedRangeAudit = dSIBP`Private`dsDerivedSeedRangeAudit[
   <|
    "groupOrdinal" -> 1,
    "continuousIndices" -> {ispN[1]},
    "shiftBounds" -> {ispN[1] -> {1, 1}},
    "seedRangeOffsets" -> {ispN[1] -> {-1, -1}}
    |>,
   Association[ispN[1] -> {0, 2}]
   ];
negativeDerivedRangeAudit = dSIBP`Private`dsDerivedSeedRangeAudit[
   <|
    "groupOrdinal" -> 1,
    "continuousIndices" -> {ispN[1]},
    "shiftBounds" -> {ispN[1] -> {1, 1}},
    "seedRangeOffsets" -> {ispN[1] -> {-1, -1}}
    |>,
   Association[ispN[1] -> {-2, 2}]
   ];

rawSeedIntegral = ReplacePart[zeroIntegral, {3, 1} -> ispN[1]];
rawShiftedIntegral = ReplacePart[zeroIntegral, {3, 1} -> ispN[1] + 1];
rawSeed = rawSeedIntegral - rawShiftedIntegral;
rawSeedMetadata = DSMetaSeedRange[{rawSeed}, {ispN[1]}];
rawISPIndex = First[Lookup[rawSeedMetadata, "discoveredIndices", {ispN[1]}]];
negativeTargetResult = DSGenerateIBP[
   {rawSeed},
   {rawISPIndex, -1, 1},
   ProgressReporting -> False
   ];
validTargetResult = DSGenerateIBP[
   {rawSeed},
   {0, 1},
   ProgressReporting -> False
   ];

positiveIntegrand = rep2Integrand[positiveIntegral, context];
negativeIntegrand = Quiet[rep2Integrand[negativeIntegral, context]];
zeroIntegrand = rep2Integrand[zeroIntegral, context];
generatedIntegrals = Cases[Lookup[validTargetResult, "equations", {}], _J, Infinity];
negativeGeneratedIntegrals = Cases[Lookup[negativeTargetResult, "equations", {}], _J, Infinity];
negativeGeneratedISPValues = Cases[negativeGeneratedIntegrals, J[_, _, values_] :> values[[1]]];


(* ::Chapter:: *)
(*验收*)

checks = <|
   "validInitialization" -> (Lookup[context, "status", "failed"] === "initialized"),
   "zeroPointStored" -> (Lookup[topology["ispData"], "zeroPoint", Missing["zeroPoint"]] === {0, 0}),
   "negativeDefinitionAccepted" -> (Lookup[negativeDefinitionContext, "status", "failed"] === "initialized"),
   "nonzeroInputNormalizedToZero" -> (
     Lookup[nonzeroDefinitionContext, "status", "failed"] === "initialized" &&
      Lookup[nonzeroDefinitionContext["topology"]["ispData"], "zeroPoint", Missing["zeroPoint"]] === {0, 0}
     ),
   "negativeSeedRangeAccepted" -> (Lookup[negativeSeedContext, "status", "failed"] === "initialized"),
   "zeroExponentDerivativeIsZero" -> TrueQ[Expand[zeroISPDerivative] === 0],
   "validTargetRangeAccepted" -> (Lookup[validRangeAudit, "status", "failed"] === "passed"),
   "negativeTargetRangeAccepted" -> (Lookup[negativeRangeAudit, "status", "failed"] === "passed"),
   "positiveLowerBoundPreserved" -> (
     Lookup[derivedRangeAudit, "unclippedSeedRangeRules", {}] === {ispN[1] -> {-1, 1}} &&
      Lookup[derivedRangeAudit, "seedRangeRules", {}] === {ispN[1] -> {0, 1}}
     ),
   "negativeUserLowerBoundPreserved" -> (
     Lookup[negativeDerivedRangeAudit, "unclippedSeedRangeRules", {}] === {ispN[1] -> {-3, 1}} &&
      Lookup[negativeDerivedRangeAudit, "seedRangeRules", {}] === {ispN[1] -> {-2, 1}}
     ),
   "publicNegativeTargetAccepted" -> (
     Lookup[negativeTargetResult, "status", "failed"] === "generated" &&
      MemberQ[negativeGeneratedISPValues, -1]
     ),
   "validGenerationHasNoNegativeISP" -> (
     Lookup[validTargetResult, "status", "failed"] === "generated" &&
      FreeQ[generatedIntegrals, J[_, _, values_] /; AnyTrue[values, IntegerQ[#] && # < 0 &]]
     ),
   "integrandKeepsNumeratorPowers" -> (
     positiveIntegrand =!= $Failed &&
      Exponent[positiveIntegrand, rho1] === 2 && Exponent[positiveIntegrand, rho2] === 1
     ),
   "publicNegativeIntegralRestored" -> (
     negativeIntegrand =!= $Failed &&
      TrueQ[FullSimplify[negativeIntegrand rho1 - zeroIntegrand] === 0]
     )
   |>;

failed = Keys@Select[checks, Not@TrueQ[#] &];
Print["check_isp_numerator_contract: ", Count[Values[checks], True], "/", Length[checks]];
Print["failed: ", InputForm[failed]];
Print[InputForm[<|"passed" -> Count[Values[checks], True], "total" -> Length[checks], "failed" -> failed,
    "negativeDefinitionStatus" -> Lookup[negativeDefinitionContext, "status", Missing["status"]],
    "negativeTargetStatus" -> Lookup[negativeTargetResult, "status", Missing["status"]],
    "negativeGeneratedISPValues" -> negativeGeneratedISPValues,
    "derivedSeedRangeRules" -> Lookup[derivedRangeAudit, "seedRangeRules", {}],
    "negativeDerivedSeedRangeRules" -> Lookup[negativeDerivedRangeAudit, "seedRangeRules", {}],
    "zeroIntegral" -> zeroIntegral,
    "negativeIntegral" -> negativeIntegral,
    "validTargetStatus" -> Lookup[validTargetResult, "status", Missing["status"]]
  "checks" -> checks|>]];
If[Count[Values[checks], True] =!= Length[checks], Exit[1]];
