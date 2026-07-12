(* ::Package:: *)
(* 006 专用轻量检查：用户口统一 sp[p,r]，内部仍可用 qq/qk/kk 编号坐标。 *)

(* ::Chapter:: *)
(*环境与加载*)

SetDirectory[FileNameJoin[{DirectoryName[$InputFileName], "..", ".."}]];

Get["000_code/006_dS_ibp_general.wl"];


(* ::Chapter:: *)
(*sp 用户接口检查*)

spInterfaceCase = <|
   "name" -> "spInterfaceWeirdMomentumNames",
   "vertexData" -> {{1, "+"}, {2, "+"}},
   "lineData" -> {
     <|"id" -> 1, "endpoints" -> {1, 2}, "momentum" -> l3, "nu" -> nuM, "bbType" -> "h", "massType" -> "massive", "skType" -> "++"|>,
     <|"id" -> 2, "endpoints" -> {1, 2}, "momentum" -> k321, "nu" -> 0, "bbType" -> "exp", "massType" -> "massless", "skType" -> "++"|>,
     <|"id" -> 3, "endpoints" -> {1, 2}, "momentum" -> l3 - k321 - wdnmd, "nu" -> 0, "bbType" -> "exp", "massType" -> "massless", "skType" -> "++"|>
     },
   "extLegs" -> {{"kaPlusKb", 1, ke[15]}, {"p2", 2, ke[22]}},
   "vertexEnergies" -> <|1 -> ke[15], 2 -> ke[22]|>,
   "loopMomenta" -> {l3, k321},
   "externalMomenta" -> {wdnmd},
   "externalInvariantRules" -> {sp[wdnmd, wdnmd] -> sigW},
   "ispData" -> {
     {rhoA, sp[l3, wdnmd + l3], {0, 1}},
     {rhoB, sp[k321, wdnmd], {0, 1}}
     },
   "numericRules" -> {dim -> 3, sigW -> 5, nuM -> 2, ke[15] -> 17, ke[22] -> 11},
   "sampleDiscreteRules" -> {{n[1, 1] -> 0, n[1, 2] -> 0, n[2] -> 0, n[3] -> 0}},
   "seedRanges" -> <|"a" -> {0}, "b" -> {0}, "isp" -> {0}, "sampleOnly" -> True|>
   |>;

spTopo = parseTopology[spInterfaceCase];
spRules = makeScalarProductRules[spTopo];
spData = makeScalarProductData[spTopo];
spSummary = summarizeCase[spInterfaceCase];
spNumericReq = numericRuleRequirementReport[spTopo];
spDefaultInvariantCase = Join[
   KeyDrop[spInterfaceCase, {"externalInvariantRules", "numericRules"}],
   <|"numericRules" -> {dim -> 3, s11 -> 5, nuM -> 2, ke[15] -> 17, ke[22] -> 11}|>
   ];
spDefaultTopo = parseTopology[spDefaultInvariantCase];
spDefaultSummary = summarizeCase[spDefaultInvariantCase];
spDefaultTemplate = makeNumericRuleTemplate[KeyDrop[spDefaultInvariantCase, "numericRules"], NumericRuleTemplateScope -> "externalInvariants"];
spBaseIntegral = makeBaseIntegral[spTopo];
spMomentumGen = SelectFirst[makeIBPGenerators[spTopo], #["type"] === "momentum" && #["vectorType"] === "external" && #["dLoop"] === 1 &];
spMomentumSeed = applySeedCanonical[Expand[applyMomentumGeneratorSeed[spTopo, spBaseIntegral, spMomentumGen]], spTopo];
spUserCoeffRules = {sigW -> 5, ke[15] -> 17};
spInternalCoeffRules = {kk[1, 1] -> 5, ke[15] -> 17};
spLinearToy = <|
   "status" -> "generated",
   "caseName" -> "spLinearToy",
   "topology" -> spTopo,
   "topologyValidationReport" -> topologyValidationReport[spTopo],
   "linearEquations" -> {<|"coefficientRules" -> {1 -> kk[1, 1] + ke[15]}, "constantTerm" -> 0, "linearQ" -> True|>},
   "integralList" -> {spBaseIntegral},
   "integralRules" -> {spBaseIntegral -> 1},
   "integralCount" -> 1,
   "equationCount" -> 1
   |>;
spSampledLinear = applyCoefficientRulesToLinearSystem[spLinearToy, CoefficientRules -> spUserCoeffRules];
spKiraStrings = makeKiraInputStrings[spLinearToy, spUserCoeffRules, <|"AppendNumericDummyEquation" -> False|>];

spWorkflowData = makeIBPWorkflowData[
   spInterfaceCase,
   LinearSystemMode -> "sampled",
   CoefficientRules -> spInterfaceCase["numericRules"],
   ExportKira -> True,
   OutputDirectory -> None,
   KiraCoefficientRules -> {},
   KiraJobOptions -> <|"AppendNumericDummyEquation" -> False|>
   ];

spWorkflowDefaultRulesData = makeIBPWorkflowData[
   spInterfaceCase,
   LinearSystemMode -> "sampled",
   ExportKira -> True,
   OutputDirectory -> None,
   KiraJobOptions -> <|"AppendNumericDummyEquation" -> False|>
   ];

spEnergyConventionCase = Join[
   KeyDrop[spInterfaceCase, {"vertexEnergies", "numericRules"}],
   <|
    "vertexEnergies" -> <|1 -> Sqrt[sigW], 2 -> ke[3]|>,
    "numericRules" -> {dim -> 3, sigW -> 5, nuM -> 2, ke[3] -> 7}
    |>
   ];
spEnergyTopo = parseTopology[spEnergyConventionCase];
spEnergyReq = numericRuleRequirementReport[spEnergyTopo];
spEnergyReport = vertexEnergyNamingReport[spEnergyTopo];

spDefaultEnergyCase = Join[
   KeyDrop[spInterfaceCase, {"vertexEnergies", "numericRules"}],
   <|"numericRules" -> {dim -> 3, sigW -> 5, nuM -> 2, ke[1] -> 11, ke[2] -> 13}|>
   ];
spDefaultEnergyTopo = parseTopology[spDefaultEnergyCase];
spDefaultEnergyReport = vertexEnergyNamingReport[spDefaultEnergyTopo];

spKeIndependenceCase = Join[
   KeyDrop[spInterfaceCase, {"vertexEnergies", "numericRules"}],
   <|
    "vertexEnergies" -> <|1 -> ke[3], 2 -> ke[1] + ke[2]|>,
    "numericRules" -> {dim -> 3, sigW -> 5, nuM -> 2, ke[1] -> 11, ke[2] -> 13, ke[3] -> 17}
    |>
   ];
spKeIndependenceTopo = parseTopology[spKeIndependenceCase];
spKeIndependenceReport = vertexEnergyNamingReport[spKeIndependenceTopo];

spNonLinearMomentumCase = Join[
   spInterfaceCase,
   <|
    "lineData" -> ReplacePart[spInterfaceCase["lineData"], {1, "momentum"} -> l3^2],
    "ispData" -> {{rhoBad, sp[l3^2, wdnmd], {0}}}
    |>
   ];
spNonLinearMomentumReport = topologyValidationReport[parseTopology[spNonLinearMomentumCase]];
spNonLinearMomentumIssueCodes = Lookup[spNonLinearMomentumReport["issues"], "code", {}];

spCheckResults = <|
   "spOrderless" -> TrueQ[MemberQ[Attributes[sp], Orderless] && sp[l3, wdnmd + l3] === sp[wdnmd + l3, l3]],
   "internalNumericRule" -> TrueQ[MemberQ[spTopo["numericRules"], kk[1, 1] -> 5]],
   "userNumericRule" -> TrueQ[MemberQ[spSummary["numericRules"], sigW -> 5]],
   "externalInvariantOutputNaming" -> TrueQ[
     spData["externalInvariants"] === {sigW} &&
      MemberQ[spNumericReq["requiredExternalInvariants"], sigW] &&
      FreeQ[spSummary["zExprs"], sp[wdnmd, wdnmd] | kk]
     ],
   "defaultExternalInvariantNaming" -> TrueQ[
     MemberQ[spDefaultSummary["numericRules"], s11 -> 5] &&
      spDefaultTemplate === {s11 -> numericValue[s11]} &&
      spDefaultSummary["externalInvariantNamingReport", "externalInvariantRules"] === {sp[wdnmd, wdnmd] -> s11}
     ],
   "vertexEnergyNotExternalMomentum" -> TrueQ[FreeQ[spTopo["externalMomenta"], ke[15]] && FreeQ[spData["scalarProducts"], ke[15]] && MemberQ[spNumericReq["requiredVertexEnergies"], ke[15]]],
   "vertexEnergyUsesExternalInvariantWhenSpecified" -> TrueQ[
     vertexExternalEnergy[spEnergyTopo, 1] === Sqrt[kk[1, 1]] &&
      vertexExternalEnergy[spEnergyTopo, 2] === ke[3] &&
      Sort[spEnergyReq["internalRequiredVertexEnergies"]] === Sort[{kk[1, 1], ke[3]}] &&
      Sort[spEnergyReq["requiredVertexEnergies"]] === Sort[{sigW, ke[3]}] &&
      spEnergyReport["userVertexEnergies"][1] === Sqrt[sigW]
     ],
   "vertexEnergyDefaultDoesNotSumExtLegs" -> TrueQ[
     vertexExternalEnergy[spDefaultEnergyTopo, 1] === ke[1] &&
      vertexExternalEnergy[spDefaultEnergyTopo, 2] === ke[2] &&
      FreeQ[Values[spDefaultEnergyReport["internalVertexEnergies"]], ke[15] | ke[22]]
     ],
   "vertexEnergyDependencyReport" -> TrueQ[
     spEnergyReport["dependencyData"][1]["kind"] === "externalInvariantExpression" &&
      spEnergyReport["dependencyData"][1]["externalInvariantVariables"] === {sigW} &&
      spEnergyReport["dependencyData"][2]["kind"] === "independentVertexEnergyParameter" &&
      spEnergyReport["dependencyData"][2]["independentVertexEnergyParameters"] === {ke[3]}
     ],
   "keCombinationKeptIndependent" -> TrueQ[
     vertexExternalEnergy[spKeIndependenceTopo, 1] === ke[3] &&
      vertexExternalEnergy[spKeIndependenceTopo, 2] === ke[1] + ke[2] &&
      vertexExternalEnergy[spKeIndependenceTopo, 1] =!= vertexExternalEnergy[spKeIndependenceTopo, 2] &&
      spKeIndependenceReport["dependencyData"][1]["independentVertexEnergyParameters"] === {ke[3]} &&
      Sort[spKeIndependenceReport["dependencyData"][2]["independentVertexEnergyParameters"]] === Sort[{ke[1], ke[2]}]
     ],
   "sampledCoefficientRulesAcceptSP" -> TrueQ[
     spSampledLinear["coefficientRulesApplied"] === spInternalCoeffRules &&
      spSampledLinear["userCoefficientRulesApplied"] === spUserCoeffRules &&
      spSampledLinear["linearEquations"][[1]]["coefficientRules"] === {1 -> 22}
     ],
   "kiraCoefficientRulesAcceptSP" -> TrueQ[
     spKiraStrings["status"] === "generated" &&
      spKiraStrings["kiraCoefficientRulesApplied"] === spInternalCoeffRules &&
      spKiraStrings["userKiraCoefficientRulesApplied"] === spUserCoeffRules &&
      TrueQ[spKiraStrings["numericCoefficientSystemQ"]] &&
      FreeQ[spKiraStrings["coefficientVariables"], kk | ke[15]]
     ],
   "spWorkflowSampledKiraReady" -> TrueQ[
     spWorkflowData["status"] === "ready" &&
      spWorkflowData["stage"] === "kira" &&
      spWorkflowData["seedBatch", "status"] === "generated" &&
      TrueQ[spWorkflowData["seedBatch", "completeCanonicalQ"]] &&
      spWorkflowData["linearSystem", "status"] === "generated" &&
      TrueQ[spWorkflowData["linearSystem", "linearQ"]] &&
      TrueQ[spWorkflowData["linearSystem", "numericCoefficientSystemQ"]] &&
      spWorkflowData["kiraExport", "status"] === "ready" &&
      ! TrueQ[spWorkflowData["kiraExport", "writeFilesQ"]] &&
      spWorkflowData["kiraExport", "exportedEquationCount"] > 0 &&
      FreeQ[spWorkflowData["kiraExport", "coefficientVariables"], kk | qk | qq | ke[15] | ke[22] | sigW]
     ],
   "spWorkflowSampledDefaultsUseNumericRules" -> TrueQ[
     spWorkflowDefaultRulesData["status"] === "ready" &&
      spWorkflowDefaultRulesData["stage"] === "kira" &&
      TrueQ[spWorkflowDefaultRulesData["linearSystem", "numericCoefficientSystemQ"]] &&
      spWorkflowDefaultRulesData["linearSystem", "coefficientRulesApplied"] === spTopo["numericRules"] &&
      spWorkflowDefaultRulesData["kiraExport", "kiraInput", "kiraCoefficientRulesApplied"] === {} &&
      FreeQ[spWorkflowDefaultRulesData["kiraExport", "coefficientVariables"], kk | qk | qq | ke[15] | ke[22] | sigW]
     ],
   "nonLinearMomentumInputRejected" -> TrueQ[
     spNonLinearMomentumReport["status"] === "issues" &&
      MemberQ[spNonLinearMomentumIssueCodes, "nonLinearLineMomenta"] &&
      MemberQ[spNonLinearMomentumIssueCodes, "nonLinearScalarProductArguments"]
     ],
   "rulesComputed" -> TrueQ[spRules["status"] === "computed"],
   "ispInternalExprs" -> TrueQ[spData["internalISPExprs"] === {qk[1, 1] + qq[1, 1], qk[2, 1]}],
   "ispUserExprs" -> TrueQ[spData["ispExprs"] === {sp[l3, l3] + sp[l3, wdnmd], sp[k321, wdnmd]}],
   "summaryScalarProductsUseSP" -> TrueQ[! FreeQ[spSummary["scalarProducts"], sp] && FreeQ[spSummary["scalarProducts"], qq | qk | kk]],
   "summaryZExprsUseSP" -> TrueQ[! FreeQ[spSummary["zExprs"], sp] && FreeQ[spSummary["zExprs"], qq | qk | kk]],
   "userRulesUseSP" -> TrueQ[! FreeQ[spRules["userRepSP2Z"], sp] && FreeQ[spRules["userRepSP2Z"], qq | qk | kk]],
   "momentumSeedGenerated" -> TrueQ[spMomentumSeed =!= $Failed && ! containsForbiddenNQ[spTopo, spMomentumSeed] && ! FreeQ[spMomentumSeed, ispN[1]]]
   |>;

spCheckSummary = <|
   "checkedCount" -> Length[spCheckResults],
   "passedCount" -> Count[Values[spCheckResults], True],
   "failedNames" -> Keys@Select[spCheckResults, ! TrueQ[#] &]
   |>;

Print[spCheckSummary];

If[And @@ Values[spCheckResults], Exit[0], Print[spCheckResults]; Exit[1]];
