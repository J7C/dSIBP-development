(* ::Package:: *)
(* 本文件验证 tree 微分方程的两条独立程序路线：投影 dtau 的 naive 线性求解，以及公式型 dlog connection。 *)

(* ::Chapter:: *)
(*加载 package 与固定 family*)

checkDir = DirectoryName[$InputFileName];
codeDir = DirectoryName[checkDir];
packageDir = FileNameJoin[{codeDir, "014_dSIBP"}];
If[! MemberQ[$Path, packageDir], AppendTo[$Path, packageDir]];
Needs["dSIBP`"];
DSMessagesOff[];


treeDECase[name_String, secondSign_String] := <|
   "name" -> name,
   "vertexData" -> {{v1, "+"}, {v2, secondSign}},
   "lineData" -> {
     <|"id" -> 1, "endpoints" -> {v1, v2}, "momentum" -> ell12,
       "treeEnergy" -> ke[3], "nu" -> nu12, "bbType" -> "h", "massType" -> "massive"|>
     },
   "loopMomenta" -> {ell12},
   "externalMomenta" -> {},
   "externalInvariantRules" -> {},
   "vertexEnergies" -> <|v1 -> ke[1], v2 -> ke[2]|>,
   "zeroPointRules" -> {a0[v1] -> alpha1, a0[v2] -> alpha2, b0[1] -> beta12},
   "symmetryRules" -> {},
   "seedPreset" -> "quickCheck"
   |>;


sameContext = DSInit[treeDECase["014TreeNaiveDESame", "+"], RegisterAsCurrent -> False, ProgressReporting -> False];
mixedContext = DSInit[treeDECase["014TreeNaiveDEMixed", "-"], RegisterAsCurrent -> False, ProgressReporting -> False];

(* ::Chapter:: *)
(*同序 master 下的两路线微分方程*)

variables = {ke[1], ke[2], ke[3]};

sameFormula = DSTreeDLogDE[sameContext];
sameNaiveIBP = DSTreeNaiveIBP[sameContext, sameFormula["masters"], ProgressReporting -> False];
sameNaiveDE = DSTreeNaiveDE[sameNaiveIBP, variables, ProgressReporting -> False];
sameFormulaMatrices = Association@Table[variable -> D[sameFormula["omega"], variable], {variable, variables}];
sameMatrixResiduals = Association@Table[
    variable -> (Together /@ Flatten[sameNaiveDE["matrices", variable] - sameFormulaMatrices[variable]]),
    {variable, variables}
    ];

mixedFormula = DSTreeDLogDE[mixedContext];
mixedNaiveIBP = DSTreeNaiveIBP[mixedContext, mixedFormula["masters"], ProgressReporting -> False];
mixedNaiveDE = DSTreeNaiveDE[mixedNaiveIBP, variables, ProgressReporting -> False];
mixedFormulaMatrices = Association@Table[variable -> D[mixedFormula["omega"], variable], {variable, variables}];
mixedMatrixResiduals = Association@Table[
    variable -> (Together /@ Flatten[mixedNaiveDE["matrices", variable] - mixedFormulaMatrices[variable]]),
    {variable, variables}
    ];


zeroVectorQ[values_List] := And @@ (TrueQ[# === 0] & /@ values);


(* ::Chapter:: *)
(*Mixed-sign contact 防误用与验收*)

mixedSeedRecords = Lookup[mixedNaiveIBP, "seedRecords", {}];
mixedContactAudit = Flatten[Lookup[mixedSeedRecords, "contactAudit", {}], Infinity];
mixedShrinkTrace = Flatten[Lookup[mixedSeedRecords, "shrinkConsumptionTrace", {}], Infinity];

checks = <|
   "sameContextInitialized" -> Lookup[sameContext, "status", "missing"] === "initialized",
   "mixedContextInitialized" -> Lookup[mixedContext, "status", "missing"] === "initialized",
   "sameFormulaGenerated" -> Lookup[sameFormula, "status", "missing"] === "generated",
   "sameNaiveIBPSolved" -> Lookup[sameNaiveIBP, "status", "missing"] === "solved",
   "sameNaiveDEGenerated" -> Lookup[sameNaiveDE, "status", "missing"] === "generated",
   "sameMasterOrderAndNormalization" -> Lookup[sameNaiveDE, "masters", {}] === Lookup[sameFormula, "masters", Missing["masters"]],
   "sameEquationUnknownCount" -> Lookup[sameNaiveIBP, "equationCount", -1] === Lookup[sameNaiveIBP, "unknownCount", -2],
   "sameIBPSolveResidual" -> zeroVectorQ[Lookup[sameNaiveIBP, "solveResiduals", {1}]],
   "sameNoDEResidual" -> And @@ (zeroVectorQ /@ Values[Lookup[sameNaiveDE, "sources", <||>]]) &&
     And @@ (# === {} & /@ Values[Lookup[sameNaiveDE, "residualObjects", <||>]]),
   "sameMatricesAgree" -> And @@ (zeroVectorQ /@ Values[sameMatrixResiduals]),
   "coefficientDerivativeAudited" -> AnyTrue[
     Lookup[Lookup[Lookup[sameNaiveDE, "variableData", <||>], ke[3], <||>], "derivativeRecords", {}],
     ! TrueQ[Lookup[#, "masterNormalizationDerivative", 0] === 0] &
     ],
   "mixedFormulaGenerated" -> Lookup[mixedFormula, "status", "missing"] === "generated",
   "mixedNaiveIBPSolved" -> Lookup[mixedNaiveIBP, "status", "missing"] === "solved",
   "mixedNaiveDEGenerated" -> Lookup[mixedNaiveDE, "status", "missing"] === "generated",
   "mixedMasterOrderAndNormalization" -> Lookup[mixedNaiveDE, "masters", {}] === Lookup[mixedFormula, "masters", Missing["masters"]],
   "mixedMatricesAgree" -> And @@ (zeroVectorQ /@ Values[mixedMatrixResiduals]),
   "mixedNoContactAudit" -> mixedContactAudit === {},
   "mixedNoShrinkConsumption" -> mixedShrinkTrace === {},
   "mixedOnlyTopSector" -> Lookup[mixedFormula, "sectorOrder", {}] === {"top"},
   "noFormulaRecurrenceInNaiveIBP" -> TrueQ[Lookup[sameNaiveIBP, "formulaRecurrenceUsedQ", True] === False] &&
     TrueQ[Lookup[mixedNaiveIBP, "formulaRecurrenceUsedQ", True] === False],
   "noFormulaDLogInNaiveDE" -> TrueQ[Lookup[sameNaiveDE, "formulaDLogUsedQ", True] === False] &&
     TrueQ[Lookup[mixedNaiveDE, "formulaDLogUsedQ", True] === False]
   |>;


Print["014 tree naive DE check: ", Count[Values[checks], True], "/", Length[checks]];
If[! And @@ Values[checks],
 Print[Select[checks, Not]];
 Print["same IBP status/reason: ", Lookup[sameNaiveIBP, {"status", "reason"}, Missing["sameIBP"]]];
 Print["same DE status: ", Lookup[sameNaiveDE, "status", Missing["sameDE"]]];
 Print["same nonzero residuals: ", Select[sameMatrixResiduals, ! zeroVectorQ[#] &]];
 Print["mixed IBP status/reason: ", Lookup[mixedNaiveIBP, {"status", "reason"}, Missing["mixedIBP"]]];
 Print["mixed DE status: ", Lookup[mixedNaiveDE, "status", Missing["mixedDE"]]];
 Print["mixed nonzero residuals: ", Select[mixedMatrixResiduals, ! zeroVectorQ[#] &]];
 Exit[1]
 ];
