(* ::Package:: *)
(* 本正式专项验证 016 tree 原生导数、direct time-IBP 与公式型 dlog DE。
   family 使用 timeOnly，因此测试不能依赖伪造的 loop routing 或 tree-to-loop 反投影。 *)

(* ::Chapter:: *)
(*加载 016*)

testDir = DirectoryName[$InputFileName];
codeDir = DirectoryName[testDir];
packageDir = FileNameJoin[{codeDir, "016_dSIBP"}];
If[! MemberQ[$Path, packageDir], AppendTo[$Path, packageDir]];
Needs["dSIBP`"];
DSMessagesOff[];


(* ::Chapter:: *)
(*固定两顶点 timeOnly family*)

treeDECase[name_String, secondSign_String] := <|
   "name" -> name,
   "vertexData" -> {{v1, "+"}, {v2, secondSign}},
   "lineData" -> {
     <|"id" -> 1, "endpoints" -> {v1, v2}, "momentum" -> p12,
       "treeEnergy" -> e12, "nu" -> nu12, "bbType" -> "h", "massType" -> "massive"|>
     },
   "loopMomenta" -> {},
   "loopExternalMomenta" -> {},
   "independentExternalMomenta" -> {p12},
   "ibpMode" -> "timeOnly",
   "ispData" -> {},
   "vertexEnergies" -> <|v1 -> e1, v2 -> e2|>,
   "zeroPointRules" -> {a0[v1] -> alpha1, a0[v2] -> alpha2, b0[1] -> beta12},
   "symmetryRules" -> {},
   "seedPreset" -> "quickCheck"
   |>;


sameContext = DSInit[
   treeDECase["016DirectTreeDESame", "+"],
   RegisterAsCurrent -> False,
   ProgressReporting -> False
   ];

mixedContext = DSInit[
   treeDECase["016DirectTreeDEMixed", "-"],
   RegisterAsCurrent -> False,
   ProgressReporting -> False
   ];

sameSeedBatch = DSSeeds[sameContext, ProgressReporting -> False];
mixedSeedBatch = DSSeeds[mixedContext, ProgressReporting -> False];
sameLinearData = DSLinear[sameSeedBatch, sameContext, ProgressReporting -> False];
mixedLinearData = DSLinear[mixedSeedBatch, mixedContext, ProgressReporting -> False];
sameNumericLinearData = DSLinear[
   sameSeedBatch,
   sameContext,
   LinearSystemMode -> "numeric",
   CoefficientRules -> {e1 -> 2, e2 -> 3, e12 -> 5, nu12 -> 1/2,
     alpha1 -> 7/3, alpha2 -> 11/5, beta12 -> 13/7, Pi -> 17/11},
   ProgressReporting -> False
   ];
sameKiraData = DSKiraExport[sameNumericLinearData, ProgressReporting -> False];

(* ::Chapter:: *)
(*Naive 与公式型 DE*)

variables = {e1, e2, e12};

sameFormula = DSTreeDLogDE[sameContext];
sameNaiveIBP = DSTreeNaiveIBP[sameContext, sameFormula["masters"], ProgressReporting -> False];
sameNaiveDE = DSTreeNaiveDE[sameNaiveIBP, variables, ProgressReporting -> False];
sameFamilyContext = dSIBP`Private`dsTreeFamilyContext[sameContext];
sameReferenceMaster = First[sameFormula["masters"]];
sameReferenceFamily = dSIBP`Private`dsTreeFamilyBySector[sameReferenceMaster["sectorKey"], sameFamilyContext];
sameReferenceLoopIntegral = dSIBP`Private`treeLoopIntegralFromTree[sameReferenceMaster["integral"], sameReferenceFamily];
sameDirectPhaseResidual = Expand[
   dSIBP`Private`dsTreePhaseDerivativeDirect[
      sameReferenceMaster["integral"], e1, sameReferenceFamily, sameContext["topology"]
      ]["internalExpression"] -
    dSIBP`Private`dsTreePhaseDerivativeProjectionOracle[
      sameReferenceLoopIntegral, e1, sameReferenceFamily, sameContext["topology"]
      ]["internalExpression"]
   ];
sameFormulaMatrices = Association@Table[variable -> D[sameFormula["omega"], variable], {variable, variables}];
sameResiduals = Association@Table[
    variable -> Together /@ Flatten[sameNaiveDE["matrices", variable] - sameFormulaMatrices[variable]],
    {variable, variables}
    ];

mixedFormula = DSTreeDLogDE[mixedContext];
mixedNaiveIBP = DSTreeNaiveIBP[mixedContext, mixedFormula["masters"], ProgressReporting -> False];
mixedNaiveDE = DSTreeNaiveDE[mixedNaiveIBP, variables, ProgressReporting -> False];
mixedFormulaMatrices = Association@Table[variable -> D[mixedFormula["omega"], variable], {variable, variables}];
mixedResiduals = Association@Table[
    variable -> Together /@ Flatten[mixedNaiveDE["matrices", variable] - mixedFormulaMatrices[variable]],
    {variable, variables}
    ];


zeroVectorQ[values_List] := And @@ (TrueQ[# === 0] & /@ values);


(* ::Chapter:: *)
(*断言*)

sameDerivativeRecords = Flatten[Lookup[Values[Lookup[sameNaiveDE, "variableData", <||>]], "derivativeRecords", {}], 1];
mixedDerivativeRecords = Flatten[Lookup[Values[Lookup[mixedNaiveDE, "variableData", <||>]], "derivativeRecords", {}], 1];

checks = <|
   "sameInitializedTimeOnly" -> Lookup[sameContext, "status", "failed"] === "initialized" &&
     Lookup[sameContext["topology"], "ibpMode", None] === "timeOnly",
   "mixedInitializedTimeOnly" -> Lookup[mixedContext, "status", "failed"] === "initialized",
   "samePublicSeedBatch" -> Lookup[sameSeedBatch, "status", "failed"] === "generated" &&
     Lookup[sameSeedBatch, "representation", None] === "J[vertexPacks]",
   "mixedPublicSeedBatch" -> Lookup[mixedSeedBatch, "status", "failed"] === "generated" &&
     Lookup[mixedSeedBatch, "representation", None] === "J[vertexPacks]",
   "publicSeedsAreDirectTree" -> And @@ (
      MatchQ[Lookup[#, "treeIntegral", None], J[_List]] &&
        Lookup[#, "generationRoute", None] === "directPureTime" &&
        MatchQ[Lookup[#, "loopSeed", None], Missing["NotUsed"]] & /@
       Join[Lookup[sameSeedBatch, "seedRecords", {}], Lookup[mixedSeedBatch, "seedRecords", {}]]
      ),
   "sameTreeLinearData" -> Lookup[sameLinearData, "status", "failed"] === "generated" &&
     Lookup[sameLinearData, "representation", None] === "sectorTaggedJ[vertexPacks]" &&
     TrueQ[Lookup[sameLinearData, "linearQ", False]],
   "mixedTreeLinearData" -> Lookup[mixedLinearData, "status", "failed"] === "generated" &&
     TrueQ[Lookup[mixedLinearData, "linearQ", False]],
   "treeNumericLinearData" -> Lookup[sameNumericLinearData, "status", "failed"] === "generated" &&
     TrueQ[Lookup[sameNumericLinearData, "numericCoefficientSystemQ", False]],
   "treeLinearSectorTagsPreserved" -> And @@ (
      StringQ[Lookup[#, "sectorKey", None]] && MatchQ[Lookup[#, "integral", None], J[_List]] & /@
       Join[Lookup[sameLinearData, "publicIntegralList", {}], Lookup[mixedLinearData, "publicIntegralList", {}]]
      ),
   "treeKiraSerializerReady" -> Lookup[sameKiraData, "status", "failed"] === "ready" &&
     StringContainsQ[Lookup[Lookup[sameKiraData, "kiraInput", <||>], "result/repkira2J.m", ""], "dsTreeToken"],
   "sameNaiveSolved" -> Lookup[sameNaiveIBP, "status", "failed"] === "solved",
   "mixedNaiveSolved" -> Lookup[mixedNaiveIBP, "status", "failed"] === "solved",
   "sameDEGenerated" -> Lookup[sameNaiveDE, "status", "failed"] === "generated",
   "mixedDEGenerated" -> Lookup[mixedNaiveDE, "status", "failed"] === "generated",
   "sameMatricesAgree" -> And @@ (zeroVectorQ /@ Values[sameResiduals]),
   "mixedMatricesAgree" -> And @@ (zeroVectorQ /@ Values[mixedResiduals]),
   "directPhaseMatchesProjectionOracle" -> sameDirectPhaseResidual === 0,
   "sameDirectPhaseRoute" -> sameDerivativeRecords =!= {} &&
     And @@ (Lookup[#, "phaseDerivativeRoute", None] === "directTreePhase" & /@ sameDerivativeRecords),
   "mixedDirectPhaseRoute" -> mixedDerivativeRecords =!= {} &&
     And @@ (Lookup[#, "phaseDerivativeRoute", None] === "directTreePhase" & /@ mixedDerivativeRecords),
   "noLoopRepresentative" -> FreeQ[{sameDerivativeRecords, mixedDerivativeRecords}, "loopRepresentative" | "loopPhaseDerivative"],
   "directSeedRoute" -> And @@ (
      Lookup[#, "generationRoute", None] === "directPureTime" && MatchQ[Lookup[#, "loopSeed", None], Missing["NotUsed"]] & /@
       Join[Lookup[sameNaiveIBP, "seedRecords", {}], Lookup[mixedNaiveIBP, "seedRecords", {}]]
      ),
   "mixedHasNoContactSector" -> Lookup[mixedFormula, "sectorOrder", {}] === {"top"}
   |>;


Print["016 direct tree DE: ", Count[Values[checks], True], "/", Length[checks]];
If[! And @@ Values[checks],
 Print["FAILED: ", Keys@Select[checks, ! TrueQ[#] &]];
 Print["same IBP: ", Lookup[sameNaiveIBP, {"status", "reason"}, Missing["sameIBP"]]];
 Print["same DE: ", Lookup[sameNaiveDE, {"status", "reason"}, Missing["sameDE"]]];
 Print["same residuals: ", Select[sameResiduals, ! zeroVectorQ[#] &]];
 Print["mixed IBP: ", Lookup[mixedNaiveIBP, {"status", "reason"}, Missing["mixedIBP"]]];
 Print["mixed DE: ", Lookup[mixedNaiveDE, {"status", "reason"}, Missing["mixedDE"]]];
 Print["mixed residuals: ", Select[mixedResiduals, ! zeroVectorQ[#] &]];
 Print["tree Kira: ", Lookup[sameKiraData, {"status", "reason"}, Missing["treeKira"]]];
 Exit[1]
 ];
