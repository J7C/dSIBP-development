(* ::Package:: *)
(* 014 Kira active-basis 专项：验证用户侧仍只使用 J，而有序线性组合在 backend 中占用前置 ID；
   exporter 自动收集 active basis 的导数 target，importer 分离 backend boundary masters，DSDE 对定义求导并按 token 抽取矩阵。 *)

(* ::Chapter:: *)
(*加载 package 与最小 family*)

checkDir = DirectoryName[$InputFileName];
codeDir = DirectoryName[checkDir];
packageDir = FileNameJoin[{codeDir, "014_dSIBP"}];
If[! MemberQ[$Path, packageDir], AppendTo[$Path, packageDir]];
Needs["dSIBP`"];
DSMessagesOff[];

activeCase = <|
   "name" -> "014KiraActiveBasisFixture",
   "vertexData" -> {{v1, "+"}, {v2, "+"}},
   "lineData" -> {
     <|"id" -> 1, "endpoints" -> {v1, v2}, "momentum" -> q,
       "nu" -> 0, "bbType" -> "exp", "massType" -> "massless"|>,
     <|"id" -> 2, "endpoints" -> {v1, v2}, "momentum" -> q - k,
       "nu" -> 0, "bbType" -> "exp", "massType" -> "massless"|>
     },
   "loopMomenta" -> {q},
   "externalMomenta" -> {k},
   "externalInvariantRules" -> {sp[k, k] -> s11},
   "vertexEnergies" -> <|v1 -> P1, v2 -> P2|>,
   "zeroPointRules" -> {
     a0[v1] -> alpha1, a0[v2] -> alpha2,
     b0[1] -> beta1, b0[2] -> beta2,
     bS0[1] -> beta1, bS0[2] -> beta2
     },
   "symmetryRules" -> {},
   "seedPreset" -> "quickCheck"
   |>;

activeContext = DSInit[activeCase];
activeTopology = activeContext["topology"];


(* ::Chapter:: *)
(*构造 active basis 与覆盖其导数的线性系统*)

baseJ1 = J[{0, 0}, {{0, 0}, {0, 0}}, {}];
baseJ2 = J[{1, 0}, {{0, 0}, {0, 0}}, {}];
activeExpressions = {(1 + s11) baseJ1, P1 baseJ2};
relationExpressions = Append[activeExpressions, baseJ1 + baseJ2];
activeVariables = {s11, P1};

activeRawDerivatives = Table[
   dSIBP`Private`dsSectorAwareDerivative[activeExpressions[[i]], activeVariables[[j]], activeContext],
   {i, Length[activeExpressions]}, {j, Length[activeVariables]}
   ];
fixtureIntegrals = DeleteDuplicates[Cases[{activeExpressions, activeRawDerivatives}, _J, Infinity]];
fixtureIndex = AssociationThread[fixtureIntegrals, Range[Length[fixtureIntegrals]]];

fixtureTopology = Append[
   activeTopology,
   "tadpoleSymmetryData" -> dSIBP`Private`tadpoleSymmetryData[activeTopology]
   ];

fixtureLinearData = <|
   "status" -> "generated",
   "caseName" -> activeCase["name"],
   "topology" -> fixtureTopology,
   "tadpoleSymmetryData" -> dSIBP`Private`tadpoleSymmetryData[activeTopology],
   "topologyValidationReport" -> <|"status" -> "valid", "errorCount" -> 0|>,
   "linearEquations" -> {
     <|"linearQ" -> True, "constantTerm" -> 0,
       "coefficientRules" -> Thread[Range[Length[fixtureIntegrals]] -> 1]|>
     },
   "integralList" -> fixtureIntegrals,
   "integralRules" -> Normal[fixtureIndex],
   "integralCount" -> Length[fixtureIntegrals],
   "equationCount" -> 1,
   "kiraOrdering" -> <||>,
   "sectorMetadataList" -> activeContext["sectors"],
   "dSIBPContextSummary" -> <|
     "packageVersion" -> activeContext["packageVersion"],
     "inputHash" -> activeContext["inputHash"],
     "caseName" -> activeContext["caseName"],
     "sectorKeys" -> Lookup[activeContext["sectors"], "sectorKey", {}],
     "loopTreeProjectionConvention" -> activeContext["loopTreeProjectionConvention"]
     |>
   |>;

fixtureRoot = FileNameJoin[{codeDir, "test", "results_test", "014_kira_active_basis"}];
validDir = FileNameJoin[{fixtureRoot, "valid"}];
invalidDir = FileNameJoin[{fixtureRoot, "missing_active_master"}];

exportData = DSKiraExport[
   fixtureLinearData,
   OutputDirectory -> validDir,
   KiraActiveBasis -> <|
     "names" -> {"dlog1", "dlog2", "aux1"},
     "expressions" -> relationExpressions,
     "activeIndices" -> {1, 2},
     "derivativeVariables" -> activeVariables
     |>,
   KiraJobOptions -> <|"AppendNumericDummyEquation" -> False|>
   ];
If[Lookup[exportData, "status", "missing"] =!= "ready",
 Print["active-basis export failed=", exportData]; Exit[1]
 ];


(* ::Chapter:: *)
(*构造 synthetic reduction 并取回*)

manifest = exportData["dSIBPExportManifest"];
activeData = manifest["activeBasis"];
relationIDs = activeData["ids"];
activeIDs = activeData["activeIDs"];
auxiliaryIDs = activeData["auxiliaryIDs"];
targetIDs = manifest["targetIntegralIDs"];
targetJIDs = Complement[targetIDs, activeIDs];
backendReduction = Join[
   Thread[(Tuserweight /@ auxiliaryIDs) -> Total[Tuserweight /@ activeIDs]],
   MapIndexed[
   Tuserweight[#1] -> Tuserweight[activeIDs[[1 + Mod[First[#2] - 1, Length[activeIDs]]]]] &,
   targetJIDs
   ]
   ];

writeFixture[directory_String, masterIDs_List] := Module[{resultDir, reductionDir},
   resultDir = FileNameJoin[{directory, "result"}];
   reductionDir = FileNameJoin[{directory, "results", "Tuserweight"}];
   If[! DirectoryQ[resultDir], CreateDirectory[resultDir, CreateIntermediateDirectories -> True]];
   If[! DirectoryQ[reductionDir], CreateDirectory[reductionDir, CreateIntermediateDirectories -> True]];
   Put[manifest, FileNameJoin[{directory, "dsibp-export-manifest.wl"}]];
   Put[Get[FileNameJoin[{validDir, "result", "repJ2kira.m"}]], FileNameJoin[{resultDir, "repJ2kira.m"}]];
   Put[Get[FileNameJoin[{validDir, "result", "repkira2J.m"}]], FileNameJoin[{resultDir, "repkira2J.m"}]];
   Put[backendReduction, FileNameJoin[{reductionDir, "kira_list.m"}]];
   Export[FileNameJoin[{reductionDir, "masters"}], StringRiffle[(ToString[#] <> " #") & /@ masterIDs, "\n"] <> "\n", "Text"];
   Export[FileNameJoin[{directory, "kira.log"}], "unreduced integrals: 0.\n", "Text"];
   directory
   ];

writeFixture[validDir, activeIDs];
writeFixture[invalidDir, Rest[activeIDs]];

reductionData = DSKiraImport[validDir, activeContext];
invalidReductionData = DSKiraImport[invalidDir, activeContext];
deData = DSDE[reductionData, activeVariables];


(* ::Chapter:: *)
(*验收*)

preparedLinear = exportData["linearSystem"];
shiftedJIDs = Last /@ preparedLinear["integralRules"];
invalidIssues = Lookup[Lookup[invalidReductionData, "validationReport", <||>], "issues", {}];

checks = <|
   "rawDerivativeGenerated" -> FreeQ[activeRawDerivatives, $Failed],
   "activeIDsFirst" -> activeIDs === Range[Length[activeExpressions]],
   "jIDsShifted" -> Min[shiftedJIDs] === Length[relationExpressions] + 1,
   "activeRelationsPrepended" -> Lookup[Take[preparedLinear["linearEquations"], Length[relationExpressions]], "activeBasisID", {}] === relationIDs,
   "automaticTargetClosure" -> Sort[targetIDs] === Sort[DeleteDuplicates[Join[activeIDs, activeData["derivativeTargetIDs"]]]],
   "auxiliaryNotTargeted" -> Intersection[auxiliaryIDs, targetIDs] === {},
   "manifestKeepsDefinitions" -> activeData["expressions"] === relationExpressions && activeData["activeExpressions"] === activeExpressions,
   "manifestKeepsOrder" -> activeData["names"] === {"dlog1", "dlog2", "aux1"} && activeData["activeNames"] === {"dlog1", "dlog2"},
   "imported" -> Lookup[reductionData, "status", "missing"] === "imported",
   "activeMasters" -> Lookup[reductionData, "masters", {}] === activeExpressions,
   "activeTokens" -> Lookup[reductionData, "masterTokens", {}] === (Tuserweight /@ activeIDs),
   "noBoundaryMasters" -> Lookup[reductionData, "boundaryMasterIDs", {1}] === {},
   "auxiliaryNotMaster" -> Intersection[Lookup[reductionData, "backendMasterIDs", {}], auxiliaryIDs] === {},
   "missingActiveMasterRejected" -> And[
     MemberQ[invalidIssues, "activeBasisIDsAreMasters"],
     MemberQ[invalidIssues, "activeBasisMasterOrder"]
     ],
   "deGenerated" -> Lookup[deData, "status", "missing"] === "generated",
    "deDimensions" -> And @@ (Dimensions[#] === {2, 2} & /@ Values[Lookup[deData, "matrices", <||>]]),
    "deNoResidualJ" -> And @@ (# === {} & /@ Values[Lookup[deData, "residualIntegrals", <||>]]),
    "deNoResidualBackendToken" -> And @@ (# === {} & /@ Values[Lookup[deData, "residualBackendTokens", <||>]]),
    "deUsesExternalInvariantNames" -> FreeQ[Lookup[deData, {"matrices", "sources"}, {}], _kk],
    "coefficientDerivativeKept" -> ! FreeQ[deData["variableData", s11, "rawDerivatives", 1], baseJ1]
   |>;

Print["014 Kira active-basis check: ", Count[Values[checks], True], "/", Length[checks]];
If[! And @@ Values[checks],
 Print[Select[checks, Not]];
 Print["activeData=", activeData];
 Print["invalidIssues=", invalidIssues];
 Print["deResidual=", Lookup[deData, "residualObjects", Missing["residualObjects"]]];
 Exit[1]
 ];
