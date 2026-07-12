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
   "extLegs" -> {{"p1", 1, p1}, {"p2", 2, p2}},
   "vertexEnergies" -> <|1 -> p1, 2 -> p2|>,
   "loopMomenta" -> {l3, k321},
   "externalMomenta" -> {wdnmd},
   "ispData" -> {
     {rhoA, sp[l3, wdnmd + l3], {0, 1}},
     {rhoB, sp[k321, wdnmd], {0, 1}}
     },
   "numericRules" -> {dim -> 3, sp[wdnmd, wdnmd] -> 5, nuM -> 2, p1 -> 7, p2 -> 11},
   "sampleDiscreteRules" -> {{n[1, 1] -> 0, n[1, 2] -> 0, n[2] -> 0, n[3] -> 0}},
   "seedRanges" -> <|"a" -> {0}, "b" -> {0}, "isp" -> {0}, "sampleOnly" -> True|>
   |>;

spTopo = parseTopology[spInterfaceCase];
spRules = makeScalarProductRules[spTopo];
spData = makeScalarProductData[spTopo];
spSummary = summarizeCase[spInterfaceCase];
spBaseIntegral = makeBaseIntegral[spTopo];
spMomentumGen = SelectFirst[makeIBPGenerators[spTopo], #["type"] === "momentum" && #["vectorType"] === "external" && #["dLoop"] === 1 &];
spMomentumSeed = applySeedCanonical[Expand[applyMomentumGeneratorSeed[spTopo, spBaseIntegral, spMomentumGen]], spTopo];

spCheckResults = <|
   "spOrderless" -> TrueQ[MemberQ[Attributes[sp], Orderless] && sp[l3, wdnmd + l3] === sp[wdnmd + l3, l3]],
   "internalNumericRule" -> TrueQ[MemberQ[spTopo["numericRules"], kk[1, 1] -> 5]],
   "userNumericRule" -> TrueQ[MemberQ[spSummary["numericRules"], sp[wdnmd, wdnmd] -> 5]],
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