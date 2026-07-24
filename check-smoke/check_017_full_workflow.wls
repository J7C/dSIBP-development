(* ::Package:: *)
(* 017 小型闭环 smoke：覆盖 full massless loop、mixed bubble+tree fixed line、
   自定义参数重定义、全部 reachable-sector templates、linearData 与内部变量泄漏扫描。 *)

(* ::Chapter:: *)
(*加载显式候选 017*)

packageFile = Environment["DSIBP_PACKAGE_FILE"];
If[! StringQ[packageFile] || ! FileExistsQ[packageFile], Exit[2]];
Get[packageFile];
DSMessagesOff[];


(* ::Chapter:: *)
(*Pure massless bubble*)

masslessCase = <|
   "name" -> "017PureMasslessBubble",
   "vertexData" -> {{v1, "+"}, {v2, "+"}},
   "lineData" -> {
     <|"id" -> 1, "endpoints" -> {v1, v2}, "momentum" -> q,
       "massType" -> "massless", "bbType" -> "exp", "nu" -> 0, "skType" -> "++"|>,
     <|"id" -> 2, "endpoints" -> {v1, v2}, "momentum" -> q - k,
       "massType" -> "massless", "bbType" -> "exp", "nu" -> 0, "skType" -> "++"|>
     },
   "loopMomenta" -> {q},
   "loopExternalMomenta" -> {k},
   "independentExternalMomenta" -> {},
   "ibpMode" -> "full",
   "vertexEnergies" -> <|v1 -> E1, v2 -> E2|>,
   "ispData" -> {},
   "zeroPointRules" -> {a0[v1] -> alpha1, a0[v2] -> alpha2, b0[1] -> beta1, b0[2] -> beta2},
   "symmetryRules" -> {},
   "seedPreset" -> "quickCheck"
   |>;

masslessContext = DSInit[masslessCase, RegisterAsCurrent -> True, ProgressReporting -> False];
masslessSeeds = DSSeeds[masslessContext, ProgressReporting -> False];
masslessGenerated = DSGenerateIBP[DSAllSeeds[masslessSeeds], {-1, 1}, ProgressReporting -> False];
masslessLinear = DSLinear[masslessGenerated, masslessContext, ProgressReporting -> False];


(* ::Chapter:: *)
(*Bubble plus fixed tree line*)

bubbleTreeCase = <|
   "name" -> "017BubbleTree",
   "vertexData" -> {{v1, "+"}, {v2, "+"}, {v3, "+"}},
   "lineData" -> {
     <|"id" -> 1, "endpoints" -> {v1, v2}, "momentum" -> l1,
       "massType" -> "massive", "bbType" -> "h", "nu" -> nu1|>,
     <|"id" -> 2, "endpoints" -> {v1, v2}, "momentum" -> l1 + k1 + k2,
       "massType" -> "massless", "bbType" -> "exp", "nu" -> 0|>,
     <|"id" -> 3, "endpoints" -> {v2, v3}, "momentum" -> k1 + k2,
       "massType" -> "massless", "bbType" -> "exp", "nu" -> 0|>
     },
   "extLegs" -> {{bubbleLeg, v1, k1 + k2}, {treeLeg1, v3, k1}, {treeLeg2, v3, k2}},
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

bubbleTreeContext = DSInit[bubbleTreeCase, RegisterAsCurrent -> True, ProgressReporting -> False];
bubbleTreeCustomRules = {
   sp[k1 + k2, k1 + k2] -> K12^2,
   sp[k1, k1] -> e1^2,
   sp[k2, k2] -> e2^2
   };
bubbleTreeCustomContext = DSRedefineParameters[
   bubbleTreeCustomRules,
   ProgressReporting -> False
   ];

If[Lookup[bubbleTreeCustomContext, "status", "failed"] === "initialized",
 bubbleTreeContext = bubbleTreeCustomContext
 ];
bubbleTreeSeeds = DSSeeds[bubbleTreeContext, ProgressReporting -> False];
bubbleTreeGenerated = DSGenerateIBP[DSAllSeeds[bubbleTreeSeeds], {-1, 1}, ProgressReporting -> False];
bubbleTreeLinear = DSLinear[bubbleTreeGenerated, bubbleTreeContext, ProgressReporting -> False];
bubbleTreeVariables = dSIBP`Private`independentVariableDerivativeVariables[bubbleTreeContext["topology"]];
bubbleTreeTop = dSIBP`Private`makeBaseIntegral[bubbleTreeContext["topology"]] /.
   Thread[dSIBP`Private`continuousIndexVariables[dSIBP`Private`makeBaseIntegral[bubbleTreeContext["topology"]]] -> 0] /.
   _n -> 0;
bubbleTreeDerivatives = ds[bubbleTreeTop, #, bubbleTreeContext] & /@ bubbleTreeVariables;


(* ::Chapter:: *)
(*结构与参数闭合断言*)

masslessEquations = Lookup[Lookup[masslessGenerated, "equations", {}], "equation", {}];
bubbleTreeEquations = Lookup[Lookup[bubbleTreeGenerated, "equations", {}], "equation", {}];
allPublicExpressions = Join[
   masslessEquations,
   bubbleTreeEquations,
   Lookup[masslessLinear, "linearExpressions", {}],
   Lookup[bubbleTreeLinear, "linearExpressions", {}],
   bubbleTreeDerivatives
   ];
internalLeaks = DeleteDuplicates@Cases[
    allPublicExpressions,
    _qq | _qk | _kk | _z | _xi,
    Infinity
    ];
internalLeaksByLayer = Map[
   DeleteDuplicates@Cases[#, _qq | _qk | _kk | _z | _xi, Infinity] &,
   <|
    "masslessEquations" -> masslessEquations,
    "bubbleTreeEquations" -> bubbleTreeEquations,
    "masslessLinear" -> Lookup[masslessLinear, "linearExpressions", {}],
    "bubbleTreeLinear" -> Lookup[bubbleTreeLinear, "linearExpressions", {}],
    "bubbleTreeDerivatives" -> bubbleTreeDerivatives
    |>
   ];
masslessN2Residuals = Cases[
   masslessEquations,
   int : J[_, packs_List, _] /; AnyTrue[packs, Length[#] === 3 && Last[#] === 1 &] :> int,
   Infinity
   ];
bubbleFixedTopPack = dSIBP`Private`makeBaseIntegral[bubbleTreeContext["topology"]][[2, 3]];
bubblePrefactorData = Lookup[Lookup[bubbleTreeContext, "sectors", {}], "sectorPrefactorData", {}];

checks = <|
   "masslessInitialized" -> (Lookup[masslessContext, "status", "failed"] === "initialized"),
   "masslessSeeds" -> (Lookup[masslessSeeds, "dSIBPStatus", "failed"] === "generated"),
   "masslessGenerated" -> (Lookup[masslessGenerated, "status", "failed"] === "generated"),
   "masslessSeedEnvelopeComplete" ->
    (Lookup[masslessGenerated, "emptySeedRangeGroups", {"missing"}] === {}),
   "masslessLinear" -> (Lookup[masslessLinear, "status", "failed"] === "generated"),
   "masslessQuotientCanonical" -> (masslessN2Residuals === {}),
   "bubbleTreeInitialized" -> (Lookup[bubbleTreeContext, "status", "failed"] === "initialized"),
   "bubbleTreeCustomVariables" -> (bubbleTreeVariables === {K12, e1, e2, E1, E2, E3}),
   "bubbleFixedThreeSlot" -> (Length[bubbleFixedTopPack] === 3 && First[bubbleFixedTopPack] === "F"),
   "bubbleStructuredPrefactor" -> And @@ (AssociationQ[#] && KeyExistsQ[#, "parameterList"] && KeyExistsQ[#, "powerList"] & /@ bubblePrefactorData),
   "bubbleTreeSeeds" -> (Lookup[bubbleTreeSeeds, "dSIBPStatus", "failed"] === "generated"),
   "bubbleTreeGenerated" -> (Lookup[bubbleTreeGenerated, "status", "failed"] === "generated"),
   "bubbleTreeSeedEnvelopeComplete" ->
    (Lookup[bubbleTreeGenerated, "emptySeedRangeGroups", {"missing"}] === {}),
   "bubbleTreeLinear" -> (Lookup[bubbleTreeLinear, "status", "failed"] === "generated"),
   "bubbleTreeAllDs" -> FreeQ[bubbleTreeDerivatives, $Failed],
   "noInternalLeaks" -> (internalLeaks === {})
   |>;

failed = Keys@Select[checks, Not];
Print[<|
  "passed" -> Count[Values[checks], True],
  "total" -> Length[checks],
  "failed" -> failed,
  "masslessEquationCount" -> Length[masslessEquations],
  "bubbleTreeEquationCount" -> Length[bubbleTreeEquations],
  "bubbleTreeVariables" -> bubbleTreeVariables,
  "bubbleFixedTopPack" -> bubbleFixedTopPack,
  "bubblePrefactorData" -> bubblePrefactorData,
  "internalLeaks" -> internalLeaks,
  "internalLeaksByLayer" -> internalLeaksByLayer,
  "checks" -> checks
  |>];

Exit[If[failed === {}, 0, 1]];
