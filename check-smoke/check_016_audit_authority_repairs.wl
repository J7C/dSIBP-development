(* ::Package:: *)
(* 最新审阅报告 authority 修复的维护 smoke：只验证公开初始化合同，不生成独立 expected。 *)

(* ::Chapter:: *)
(*加载候选或正式 016 交付*)

projectRoot = DirectoryName[DirectoryName[$InputFileName]];
packageOverride = Quiet[Environment["DSIBP_PACKAGE_FILE"]];
packagePath = If[
   StringQ[packageOverride] && StringLength[StringTrim[packageOverride]] > 0,
   ExpandFileName[packageOverride],
   FileNameJoin[{projectRoot, "independent-benchmark", "package", "package_016.wl"}]
   ];
Get[packagePath];
DSMessagesOff[];


(* ::Chapter:: *)
(*公共检查工具*)

checks = <||>;
recordCheck[name_String, value_] := AssociateTo[checks, name -> TrueQ[value]];
initCase[input_Association] := DSInit[
   input,
   WriteInitializationFiles -> False,
   GenerateDerivativeMetadata -> True,
   RegisterAsCurrent -> False,
   ProgressReporting -> False
   ];
initializedQ[context_] := AssociationQ[context] && Lookup[context, "status", ""] === "initialized";
topologyOf[context_] := Lookup[context, "topology", <||>];
derivativeVariablesOf[context_] := Lookup[
   Lookup[context, "derivatives", <||>],
   "operators",
   {}
   ][[All, "userVariable"]];


(* ::Chapter:: *)
(*一圈 mixed triangle*)

triangleInput = <|
   "name" -> "016AuthorityMixedTriangle",
   "vertexData" -> {{v1, "-"}, {v2, "-"}, {v3, "-"}},
   "lineData" -> {
     <|"id" -> 1, "endpoints" -> {v1, v2}, "momentum" -> q,
       "massType" -> "massive", "bbType" -> "h", "nu" -> nuM|>,
     <|"id" -> 2, "endpoints" -> {v2, v3}, "momentum" -> q - k1,
       "massType" -> "massive", "bbType" -> "h", "nu" -> nuM|>,
     <|"id" -> 3, "endpoints" -> {v3, v1}, "momentum" -> q + k2,
       "massType" -> "massless", "bbType" -> "exp", "nu" -> 0|>
     },
   "loopMomenta" -> {q},
   "loopExternalMomenta" -> {k1, k2},
   "independentExternalMomenta" -> {},
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
triangleContext = initCase[triangleInput];
triangleTopology = topologyOf[triangleContext];
recordCheck["mixedTriangleInitialized", initializedQ[triangleContext]];
recordCheck["mixedTriangleGraphLoopCount", Lookup[triangleTopology, "graphLoopCount", -1] === 1];
recordCheck["mixedTriangleLoopRole", Lookup[triangleTopology, "loopMomenta", {}] === {q}];
recordCheck["mixedTriangleExternalRole", Lookup[triangleTopology, "loopExternalMomenta", {}] === {k1, k2}];
recordCheck["mixedTriangleNoISP", Lookup[triangleTopology, "ispData", {}] === {}];


(* ::Chapter:: *)
(*双 kL vertex-energy exact 自定义坐标*)

energyInput = <|
   "name" -> "016AuthorityVertexEnergyCaseA",
   "vertexData" -> {{v1, "+"}, {v2, "+"}},
   "lineData" -> {
     <|"id" -> 1, "endpoints" -> {v1, v2}, "momentum" -> ell - k1,
       "massType" -> "massless", "bbType" -> "exp", "nu" -> 0|>,
     <|"id" -> 2, "endpoints" -> {v1, v2}, "momentum" -> ell - k2,
       "massType" -> "massless", "bbType" -> "exp", "nu" -> 0|>
     },
   "loopMomenta" -> {ell},
   "loopExternalMomenta" -> {k1, k2},
   "independentExternalMomenta" -> {p1, p2},
   "ibpMode" -> "full",
   "vertexEnergies" -> <|v1 -> Sqrt[sp[p1, p1]], v2 -> Sqrt[sp[p2, p2]]|>,
   "ispData" -> {<|"name" -> rho1, "expr" -> sp[ell, k1], "range" -> {0, 1}|>},
   "zeroPointRules" -> {
     a0[v1] -> alpha1, a0[v2] -> alpha2,
     b0[1] -> beta1, b0[2] -> beta2
     },
   "symmetryRules" -> {},
   "seedPreset" -> "quickCheck"
   |>;
energyContext = initCase[energyInput];
energyCustomRules = {
   sp[k1, k1] -> r11^2,
   sp[k1, k2] -> r12^2,
   sp[k2, k2] -> r22^2,
   sp[p1, p1] -> e1^2,
   sp[p2, p2] -> e2^2
   };
energyCustomContext = DSRedefineParameters[
   energyContext,
   energyCustomRules,
   ProgressReporting -> False
   ];
recordCheck["vertexEnergyDefaultInitialized", initializedQ[energyContext]];
recordCheck["vertexEnergyCustomInitialized", initializedQ[energyCustomContext]];
recordCheck[
   "vertexEnergyCustomVariables",
   derivativeVariablesOf[energyCustomContext] === {r11, r12, r22, e1, e2}
   ];


(* ::Chapter:: *)
(*bubble+tree 固定同号与混合分支*)

bubbleTreeBase = <|
   "lineData" -> {
     <|"id" -> 1, "endpoints" -> {v1, v2}, "momentum" -> l1,
       "massType" -> "massive", "bbType" -> "h", "nu" -> nu1|>,
     <|"id" -> 2, "endpoints" -> {v1, v2}, "momentum" -> l1 + k1 + k2,
       "massType" -> "massless", "bbType" -> "exp", "nu" -> 0|>,
     <|"id" -> 3, "endpoints" -> {v2, v3}, "momentum" -> k1 + k2,
       "massType" -> "massless", "bbType" -> "exp", "nu" -> 0|>
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
bubbleTreePlus = initCase[Join[
    bubbleTreeBase,
    <|"name" -> "016AuthorityBubbleTreePlus", "vertexData" -> {{v1, "+"}, {v2, "+"}, {v3, "+"}}|>
    ]];
bubbleTreeMixed = initCase[Join[
    bubbleTreeBase,
    <|"name" -> "016AuthorityBubbleTreeMixed", "vertexData" -> {{v1, "+"}, {v2, "+"}, {v3, "-"}}|>
    ]];
plusStates = Lookup[Lookup[topologyOf[bubbleTreePlus], "lines", {}], "state", {}];
plusPackTypes = Lookup[Lookup[topologyOf[bubbleTreePlus], "lines", {}], "packType", {}];
mixedSKAndPackTypes = Lookup[
   Lookup[topologyOf[bubbleTreeMixed], "lines", {}],
   {"skType", "packType"}
   ];
recordCheck["bubbleTreePlusInitialized", initializedQ[bubbleTreePlus]];
recordCheck["bubbleTreeMixedInitialized", initializedQ[bubbleTreeMixed]];
recordCheck["bubbleTreePlusStates", plusStates === {"full", "full", "full"}];
recordCheck[
   "bubbleTreePlusPackTypes",
   plusPackTypes === {"massiveFull", "masslessFull", "masslessFull"}
   ];
(* masslessCross 没有离散 n 槽，也不得消费 theta/contact；按 skType/packType 判断。 *)
recordCheck[
   "bubbleTreeMixedStates",
   mixedSKAndPackTypes === {{"++", "massiveFull"}, {"++", "masslessFull"}, {"+-", "masslessCross"}}
   ];


(* ::Chapter:: *)
(*汇总*)

failedChecks = Keys@Select[checks, Not];
Print[<|"passed" -> Count[Values[checks], True], "total" -> Length[checks],
   "failed" -> failedChecks, "checks" -> checks, "packagePath" -> packagePath,
   "bubbleTreePlusLineStates" -> Lookup[
     Lookup[topologyOf[bubbleTreePlus], "lines", {}],
     {"skType", "state", "packType"}
     ],
   "bubbleTreeMixedLineStates" -> Lookup[
     Lookup[topologyOf[bubbleTreeMixed], "lines", {}],
     {"skType", "state", "packType"}
     ]|>];
Exit[If[failedChecks === {}, 0, 1]];
