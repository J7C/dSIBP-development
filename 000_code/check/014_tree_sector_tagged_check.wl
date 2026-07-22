(* ::Package:: *)
(* 本文件验证 014 sector-tagged tree 迭代：两个相同裸 J shape 的 lower sector 必须保持独立身份，
   source-aware 单步继续沿 contact DAG 传播，零点产生的显式系数不得因迭代而脱离原 tagged term。 *)

(* ::Chapter:: *)
(*加载 package 与三顶点函数族*)

checkDir = DirectoryName[$InputFileName];
codeDir = DirectoryName[checkDir];
packageDir = FileNameJoin[{codeDir, "014_dSIBP"}];
If[! MemberQ[$Path, packageDir], AppendTo[$Path, packageDir]];
Needs["dSIBP`"];
DSMessagesOff[];

chainCase = <|
   "name" -> "014SameShapeLowerSectorChain",
   "vertexData" -> {{v1, "+"}, {v2, "+"}, {v3, "+"}},
   "lineData" -> {
     <|"id" -> 1, "endpoints" -> {v1, v2}, "momentum" -> q,
       "treeEnergy" -> k12, "nu" -> nu12, "bbType" -> "h", "massType" -> "massive"|>,
     <|"id" -> 2, "endpoints" -> {v2, v3}, "momentum" -> q - p,
       "treeEnergy" -> k23, "nu" -> nu23, "bbType" -> "h", "massType" -> "massive"|>
     },
   "loopMomenta" -> {q},
   "externalMomenta" -> {p},
   "externalInvariantRules" -> {sp[p, p] -> s11},
   "vertexEnergies" -> <|v1 -> K1, v2 -> K2, v3 -> K3|>,
   "zeroPointRules" -> {
     a0[v1] -> alpha1, a0[v2] -> alpha2, a0[v3] -> alpha3,
     b0[1] -> beta12, b0[2] -> beta23
     },
   "seedPreset" -> "quickCheck"
   |>;

chainContext = DSInit[chainCase];
chainReference = J[{1, 1, 1}, {{b12, 1, 0}, {b23, 1, 0}}, {}];
chainRecord = DSTreeSeeds[v2, chainReference, chainContext];
chainLinearData = chainRecord["treeLinearData"];
familyContext = dSIBP`Private`dsTreeFamilyContext[chainContext];


(* ::Chapter:: *)
(*同 shape 歧义与 tagged 迭代*)

e1Terms = Select[chainLinearData["terms"], Lookup[#, "sectorKey", ""] === "e1" &];
e2Terms = Select[chainLinearData["terms"], Lookup[#, "sectorKey", ""] === "e2" &];
e1Integral = If[e1Terms === {}, Missing["NoE1"], First[e1Terms]["integral"]];
e2Integral = If[e2Terms === {}, Missing["NoE2"], First[e2Terms]["integral"]];
sameShapeQ = MatchQ[{e1Integral, e2Integral}, {_J, _J}] && (Length /@ First[e1Integral]) === (Length /@ First[e2Integral]);
e1BareMatches = If[Head[e1Integral] === J,
   Select[familyContext["families"], dSIBP`Private`treeIntegralQ[e1Integral, #] &],
   {}
   ];

reducedData = repIterative[chainLinearData, Automatic, chainContext, MaxIterations -> 400];
reducedTerms = Lookup[reducedData, "terms", {}];
dlogData = DSTreeDLogDE[chainContext, chainLinearData];
dlogOffsets = Lookup[dlogData, "masterSectorOffsets", {}];
dlogOmegaBlocks = Lookup[dlogData, "omegaBlocks", {}];
dlogNormalizations = Lookup[dlogData, "sectorNormalizations", <||>];
dlogNormalizationAudits = Lookup[dlogData, "normalizationAudits", {}];
reducedEndpointQ = And @@ Map[
    Function[term,
     With[{sectorFamily = dSIBP`Private`dsTreeFamilyBySector[term["sectorKey"], familyContext]},
      AssociationQ[sectorFamily] && First[term["integral"]][[All, 1]] === ConstantArray[0, Length[sectorFamily["vertices"]]]
      ]
     ],
    reducedTerms
    ];

inputPowerAudits = Flatten[Lookup[chainLinearData["terms"], "physicalPowerAudits", {}], 1];
inputContactAudits = Select[inputPowerAudits, Lookup[Lookup[#, "target", <||>], "sectorKey", "top"] =!= "top" &];

zeroMatrixQ[matrix_List] := TrueQ[Expand[matrix] === ConstantArray[0, Dimensions[matrix]]];


(* ::Chapter:: *)
(*验收*)

checks = <|
   "contextInitialized" -> Lookup[chainContext, "status", "missing"] === "initialized",
   "seedGenerated" -> Lookup[chainRecord, "status", "missing"] === "generated",
   "bothLowerSectorsPresent" -> e1Terms =!= {} && e2Terms =!= {},
   "lowerSectorsHaveSameBareShape" -> TrueQ[sameShapeQ],
   "bareShapeIsActuallyAmbiguous" -> Length[e1BareMatches] === 2 && Sort[Lookup[e1BareMatches, "sector"]] === {"e1", "e2"},
   "taggedReductionCompleted" -> Lookup[reducedData, "status", "missing"] === "reduced",
   "taggedReductionReachedEndpoints" -> TrueQ[reducedEndpointQ],
   "taggedReductionKeepsBothBranches" -> ContainsAll[Lookup[reducedTerms, "sectorKey", {}], {"e1", "e2"}],
   "taggedReductionKeepsSectorIdentity" -> And @@ (StringQ[Lookup[#, "sectorKey", None]] && MatchQ[Lookup[#, "integral", None], _J] & /@ reducedTerms),
   "taggedReductionHasNoPrivateToken" -> FreeQ[reducedData, dSIBP`Private`dsTreeToken],
   "contactPowerAuditExact" -> inputContactAudits =!= {} && And @@ (TrueQ[Lookup[#, "projectionCoefficientMatchesAudit", False]] & /@ inputContactAudits),
   "multiSectorDLogGenerated" -> Lookup[dlogData, "status", "missing"] === "generated" &&
     Lookup[dlogData, "sectorOrder", {}] === {"top", "e1", "e2", "e1_e2"},
   "multiSectorMasterOffsets" -> Lookup[dlogOffsets, "start", {}] === {1, 17, 21, 25} &&
     Lookup[dlogOffsets, "end", {}] === {16, 20, 24, 25} &&
     Total[Lookup[dlogOffsets, "count", {}]] === Lookup[dlogData, "masterCount", -1],
   "multiSectorMatrixOrder" -> Lookup[dlogData, "matrixDimension", {}] === {25, 25} &&
     And @@ (Dimensions[#] === {25, 25} & /@ Values[Lookup[dlogData, "letterMatrices", <||>]]),
   "multiSectorMastersTagged" -> Length[Lookup[dlogData, "masters", {}]] === 25 &&
     And @@ (StringQ[Lookup[#, "sectorKey", None]] && MatchQ[Lookup[#, "integral", None], _J] & /@ dlogData["masters"]),
   "multiSectorSourcesAssembled" -> Lookup[dlogData, "connectionStructure", ""] === "sectorDAGBlockTriangular" &&
     Lookup[dlogData, "offDiagonalSourceStatus", ""] === "assembledFromLoopTimeIBP" &&
     Lookup[dlogData, "inputSourceData", Missing["source"]] === chainLinearData &&
     ListQ[Lookup[dlogData, "sourceEquations", Missing["sourceEquations"]]] &&
     TrueQ[Lookup[dlogData, "dlogQ", False]] && FreeQ[dlogData, _Table] &&
     Cases[dlogData, Missing[KeyAbsent, _], Infinity] === {},
   "multiSectorDAGEdges" -> Length[dlogOmegaBlocks] === 4 &&
     And @@ (! zeroMatrixQ[dlogOmegaBlocks[[Sequence @@ #]]] & /@ {{1, 2}, {1, 3}, {2, 4}, {3, 4}}),
   "multiSectorDAGDirection" -> And @@ (zeroMatrixQ[dlogOmegaBlocks[[Sequence @@ #]]] & /@
      {{2, 1}, {3, 1}, {4, 1}, {3, 2}, {2, 3}, {4, 2}, {4, 3}}),
   "sectorNormalizationAudit" -> Keys[dlogNormalizations] === {"top", "e1", "e2", "e1_e2"} &&
     And @@ (TrueQ[Lookup[#, "energyIndependentRatiosQ", False]] & /@ dlogNormalizationAudits) &&
     And @@ (Lookup[#, "coefficient", Missing["coefficient"]] ===
          Lookup[dlogNormalizations, Lookup[#, "sectorKey", "missing"], Missing["normalization"]] & /@ dlogData["masters"]),
   "noUnsafePowerExpand" -> FreeQ[
     {DownValues[dSIBP`Private`dsRepIterativeTreeLinearData], DownValues[dSIBP`Private`dsTreeTaggedSourceAwareStep]},
     PowerExpand
     ]
   |>;

Print["014 tree sector-tagged check: ", Count[Values[checks], True], "/", Length[checks]];
If[! And @@ Values[checks],
 Print[Select[checks, Not]];
 Print["context reason=", Lookup[chainContext, "reason", None],
  ", validation=", Lookup[chainContext, "validationReport", Missing["validationReport"]]];
 Print["input sectors=", Lookup[chainLinearData, "sectorKeys", Missing["sectorKeys"]]];
 Print["reduced status=", Lookup[reducedData, "status", Missing["status"]],
  ", reason=", Lookup[reducedData, "reason", None], ", steps=", Lookup[reducedData, "steps", Missing["steps"]]];
 Print["reduced sectors=", Lookup[reducedTerms, "sectorKey", {}]];
 Exit[1]
 ];
