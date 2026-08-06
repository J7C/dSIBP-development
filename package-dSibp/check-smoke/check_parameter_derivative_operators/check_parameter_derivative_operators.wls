(* ::Package:: *)
(* 文件用途：用单条 fixed massive line 检查 N_s 的结构化动量幂、normalized contact、
   参数微分中的 D[Log[N_s]]、显式系数乘积法则和被积函数回乘。 *)


(* ::Chapter:: *)
(*加载开发包与单线 topology*)

Get[FileNameJoin[{DirectoryName[$InputFileName], "..", "_harness.wls"}]];
projectRoot = DirectoryName[DirectoryName[DirectoryName[$InputFileName]]];
dsSmokeLoadPackage[FileNameJoin[{projectRoot, "versions", "018_dSIBP", "Kernel", "dSIBP.wl"}]];
DSMessagesOff[];

caseInput = <|
   "name" -> "CheckParameterDerivativeOperators",
   "vertexData" -> {{v1, "+"}, {v2, "+"}},
   "lineData" -> {
     <|"id" -> 1, "endpoints" -> {v1, v2}, "momentum" -> p1,
       "massType" -> "massive", "bbType" -> "h", "nu" -> nu1,
       "skType" -> "++"|>
     },
   "loopMomenta" -> {},
   "loopExternalMomenta" -> {},
   "independentExternalMomenta" -> {p1, p2},
   "ibpMode" -> "timeOnly",
   "vertexEnergies" -> <|v1 -> Sqrt[sp[p2, p2]], v2 -> E2|>,
   "ispData" -> {},
   "zeroPointRules" -> {
     a0[v1] -> 2 nu1, a0[v2] -> 2 nu1, b0[1] -> -2 nu1
     },
   "symmetryRules" -> {},
   "seedPreset" -> "quickCheck"
   |>;

defaultContext = DSInit[caseInput, RegisterAsCurrent -> False, ProgressReporting -> False];
customContext = DSRedefineParameters[
   defaultContext,
   {sp[p1, p1] -> (u + v)^2, sp[p2, p2] -> u^2},
   ProgressReporting -> False
   ];


(* ::Chapter:: *)
(*结构化 prefactor、contact 与参数导数*)

topIntegral = J[{a[v1], a[v2]}, {{"F", 1, 0}}, {}];
lowerPattern = J[_, {{"F"}}, {}];
topData = dSIBP`Private`sectorPrefactorDataForIntegral018[
   customContext["topology"], topIntegral
   ];
topN = dSIBP`Private`materializeSectorPrefactor018[topData];
boundary = Expand@dSIBP`Private`timeThetaBoundaryShrinkTerms[
    customContext["topology"], topIntegral, v1
    ];
contactTerm = SelectFirst[
   If[Head[boundary] === Plus, List @@ boundary, {boundary}],
   ! FreeQ[#, lowerPattern] &,
   Missing["NoContact"]
   ];
lowerIntegral = FirstCase[contactTerm, _J, Missing["NoLowerIntegral"], Infinity];
contactCoefficient = If[
   Head[lowerIntegral] === Missing,
   Missing["NoContactCoefficient"],
   Cancel[contactTerm/lowerIntegral]
   ];

fullDerivative = ds[topIntegral, u, customContext];
bareDerivative = rep2outform[
   dSIBP`Private`sectorAwareCanonical018[
    dSIBP`Private`applyIndependentVariableDerivativeSeed[
     customContext["topology"], topIntegral, u
     ],
    customContext["topology"]
    ],
   customContext["topology"]
   ];
logContribution = Expand[fullDerivative - bareDerivative];
expectedLogContribution = Expand[D[topN, u]/topN topIntegral];

lowerTopology = dSIBP`Private`sectorTopologyForIntegral018[
   customContext["topology"], lowerIntegral
   ];
lowerData = dSIBP`Private`sectorPrefactorDataForIntegral018[
   customContext["topology"], lowerIntegral
   ];
lowerN = dSIBP`Private`materializeSectorPrefactor018[lowerData];
lowerIntegrand = rep2Integrand[lowerIntegral, customContext];
expectedLowerIntegrand = rep2outform[
   lowerN dSIBP`Private`integralToBareInertIntegrand018[lowerTopology, lowerIntegral],
   customContext["topology"]
   ];

(* 这个 fixed-line normalized J 的非平凡 N_s=(u+v)^(2 nu1) 必须进入
   自动 Euler 次数；若遗漏 prefactor，下面的次数不会化为 -2。 *)
scalingMaster = topIntegral /. {a[v1] -> 0, a[v2] -> 0};
scalingDE = <|
   "status" -> "generated",
   "masters" -> {scalingMaster},
   "variables" -> {u, v},
   "matrices" -> <|u -> {{0}}, v -> {{0}}|>,
   "sources" -> <|u -> {0}, v -> {0}|>,
   "activeBasis" -> <|"scalingDegrees" -> Automatic|>,
   "sourceManifest" -> <||>,
   "context" -> customContext
   |>;
scalingData = DSScaleCheck[
   scalingDE,
   <|"relation" -> "LoopTopology", "variables" -> {u, v}, "weights" -> {1, 1}|>
   ];
scalingDegree = First[Lookup[scalingData, "degrees", {$Failed}]];


(* ::Chapter:: *)
(*验收*)

notation = DSParameterNotation[customContext];
checks = <|
   "initialized" -> (Lookup[customContext, "status", "failed"] === "initialized"),
   "stableKEIndices" -> (Lookup[topData, "kEIndices", {}] === {1, 2}),
   "stableKEMomenta" -> (Lookup[topData, "kEMomenta", {}] === {p1, p2}),
   "customKEExpressions" -> (Lookup[topData, "kEParameterExpressions", {}] === {u + v, u}),
   "notationExposesKEMapping" ->
    (Lookup[notation, "kEParameterExpressions", {}] === {u + v, u}),
   "structuralKEPower" -> (Lookup[topData, "kEPower", None] === kEpower[2 nu1, 0]),
   "normalizedContact" -> MemberQ[{1, -1}, FullSimplify[contactCoefficient (u + v)]],
   "dsIncludesLogN" ->
    TrueQ[FullSimplify[logContribution - expectedLogContribution] === 0],
   "coefficientProductRule" ->
    TrueQ[FullSimplify[ds[u topIntegral, u, customContext] - topIntegral - u fullDerivative] === 0],
   "integrandRestoresN" ->
    TrueQ[FullSimplify[lowerIntegrand - expectedLowerIntegrand] === 0],
   "loopScalingIncludesN" -> TrueQ[FullSimplify[scalingDegree + 2] === 0]
   |>;

failed = Keys@Select[checks, Not@TrueQ[#] &];
Print["check_parameter_derivative_operators: ", Count[Values[checks], True], "/", Length[checks]];
Print["failed: ", InputForm[failed]];
Print[InputForm[<|"passed" -> Count[Values[checks], True], "total" -> Length[checks], "failed" -> failed,
    "contactCoefficient" -> contactCoefficient,
    "scalingDegree" -> scalingDegree
  "checks" -> checks|>]];
If[Count[Values[checks], True] =!= Length[checks], Exit[1]];
