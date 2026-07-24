(* ::Package:: *)
(* 维护 smoke：验证 direct pure-time/tree 模板可进入统一的连续撒点与 linearData 路线。 *)


(* ::Chapter:: *)
(*加载 016 package*)

projectRoot = DirectoryName[DirectoryName[$InputFileName]];
candidatePath = Environment["DSIBP_PACKAGE_FILE"];
packagePath = If[
   StringQ[candidatePath] && candidatePath =!= "" && FileExistsQ[candidatePath],
   candidatePath,
   FileNameJoin[{projectRoot, "000_code", "016_dSIBP", "Kernel", "dSIBP.wl"}]
   ];
Get[packagePath];


(* ::Chapter:: *)
(*两顶点 massive tree 输入*)

caseInput = <|
   "name" -> "016GenerateIBPTreeSmoke",
   "vertexData" -> {{v1, "+"}, {v2, "+"}},
   "lineData" -> {
     <|"id" -> 1, "endpoints" -> {v1, v2}, "momentum" -> p12,
       "treeEnergy" -> k12, "nu" -> nu12, "bbType" -> "h", "massType" -> "massive"|>
     },
   "loopMomenta" -> {},
   "loopExternalMomenta" -> {},
   "independentExternalMomenta" -> {p12},
   "ibpMode" -> "timeOnly",
   "vertexEnergies" -> <|v1 -> E1, v2 -> E2|>,
   "ispData" -> {},
   "zeroPointRules" -> {a0[v1] -> alpha1, a0[v2] -> alpha2, b0[1] -> beta12},
   "shrinkPrefactorRules" -> {Exp[Pi Im[nu12]] -> eta12},
   "symmetryRules" -> {},
   "seedPreset" -> "quickCheck"
   |>;

context = DSInit[caseInput, RegisterAsCurrent -> True, ProgressReporting -> False];
templateData = DSSeeds[
   context,
   ProgressReporting -> False
   ];
allSeeds = DSAllSeeds[templateData];
indices = DeleteDuplicates@Flatten[Lookup[allSeeds, "continuousIndices", {}], Infinity];


(* ::Chapter:: *)
(*统一与逐指标撒点*)

uniform = DSGenerateIBP[allSeeds, {0, 0}, ProgressReporting -> False];
detailedSpecs = ({#, 0, 0} & /@ indices);
detailed = DSGenerateIBP[allSeeds, Sequence @@ detailedSpecs, ProgressReporting -> False];
linear = DSLinear[uniform, context, ProgressReporting -> False];
contactTarget = J[{{-2, 1}, {0, 0}}];
contactReduction = repIterative[contactTarget, {0, 0}, context];
contactReductionA = Cases[contactReduction, J[packs_List] :> packs[[All, 1]], {0, Infinity}];

longFamily = dSIBP`Private`makeTreeFamilyData[<|
    "name" -> "longDistanceOneVertex",
    "vertices" -> {
      <|"id" -> w1, "sign" -> "+", "nu0" -> alphaW, "energy" -> EW,
        "massiveLegs" -> {}|>
      }
    |>];
longTarget = J[{{-25}}];
longReduction = repIterative[longTarget, {0}, longFamily];
longReductionA = Cases[longReduction, J[packs_List] :> packs[[All, 1]], {0, Infinity}];


(* ::Chapter:: *)
(*确定性检查*)

checks = <|
   "contextInitialized" -> (Lookup[context, "status", "failed"] === "initialized"),
   "templateDataGenerated" -> (Lookup[templateData, "dSIBPStatus", "failed"] === "generated"),
   "directTreeRepresentation" -> (Lookup[templateData, "representation", None] === "J[vertexPacks]"),
   "allSeedsFlat" -> (ListQ[allSeeds] && VectorQ[allSeeds, AssociationQ]),
   "continuousIndicesAreVertexPowers" -> (Sort[indices] === Sort[{a[v1], a[v2]}]),
   "uniformGenerated" -> (Lookup[uniform, "status", "failed"] === "generated"),
   "detailedGenerated" -> (Lookup[detailed, "status", "failed"] === "generated"),
   "uniformEqualsDetailed" -> (Lookup[uniform, "equations", {}] === Lookup[detailed, "equations", {}]),
   "linearGenerated" -> (Lookup[linear, "status", "failed"] === "generated"),
   "linearKeepsTreeRepresentation" -> (Lookup[linear, "representation", None] === "sectorTaggedJ[vertexPacks]"),
   "contactTreeReductionCompleted" -> (contactReduction =!= $Failed),
   "contactTreeReductionAtEndpoint" -> And @@ (And @@ (# === 0 & /@ #) & /@ contactReductionA),
   "longTreeReductionCompleted" -> (longReduction =!= $Failed),
   "longTreeReductionAtEndpoint" -> And @@ (And @@ (# === 0 & /@ #) & /@ longReductionA)
   |>;

failedChecks = Keys@Select[checks, Not];
Print[<|
   "passed" -> Count[Values[checks], True],
   "total" -> Length[checks],
   "failed" -> failedChecks,
   "templateCount" -> Length[allSeeds],
   "continuousIndices" -> indices,
   "packagePath" -> packagePath,
   "checks" -> checks
   |>];
Exit[If[failedChecks === {}, 0, 1]];
