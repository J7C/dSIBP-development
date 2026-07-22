(* ::Package:: *)
(* 014 Kira 结果取回门禁专项：由一个含复数、非原子变量及代数根式生成元的正式 exporter 夹具派生正例和定向负例，
   检查后端安全序列化、可逆变量恢复、完成标记、同源哈希、映射双射、target 覆盖与 RHS master 闭合性。
   package 只读夹具，不运行 reduction。 *)

(* ::Chapter:: *)
(*加载 package 与最小同源 context*)

checkDir = DirectoryName[$InputFileName];
codeDir = DirectoryName[checkDir];
packageDir = FileNameJoin[{codeDir, "014_dSIBP"}];
If[! MemberQ[$Path, packageDir], AppendTo[$Path, packageDir]];
Needs["dSIBP`"];
DSMessagesOff[];

kiraImportCase = <|
   "name" -> "014KiraImportGateFixture",
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
   "vertexEnergies" -> <|v1 -> E1, v2 -> E2|>,
   "zeroPointRules" -> {
     a0[v1] -> alpha1, a0[v2] -> alpha2,
     b0[1] -> beta1, b0[2] -> beta2,
     bS0[1] -> beta1, bS0[2] -> beta2
     },
   "symmetryRules" -> {},
   "seedPreset" -> "quickCheck"
   |>;

kiraImportContext = DSInit[kiraImportCase];


(* ::Chapter:: *)
(*构造三积分 exporter 基准夹具*)

fixtureIntegrals = {
   J[{0, 0}, {{0, 0}, {0, 0}}, {}],
   J[{1, 0}, {{0, 0}, {0, 0}}, {}],
   J[{0, 1}, {{0, 0}, {0, 0}}, {}]
   };

fixtureTopology = Append[
   kiraImportContext["topology"],
   "tadpoleSymmetryData" -> dSIBP`Private`tadpoleSymmetryData[kiraImportContext["topology"]]
   ];

fixtureLinearData = <|
   "status" -> "generated",
   "caseName" -> kiraImportCase["name"],
   "topology" -> fixtureTopology,
   "tadpoleSymmetryData" -> dSIBP`Private`tadpoleSymmetryData[kiraImportContext["topology"]],
   "topologyValidationReport" -> <|"status" -> "valid", "errorCount" -> 0|>,
   "linearEquations" -> {
     <|"linearQ" -> True, "constantTerm" -> 0,
       "coefficientRules" -> {
         1 -> I P1 + kk[1, 1] + Sqrt[kk[1, 1]],
         2 -> -P2,
         3 -> P2 - I P1 - kk[1, 1] - Sqrt[kk[1, 1]]
         }|>
     },
   "integralList" -> fixtureIntegrals,
   "integralRules" -> Thread[fixtureIntegrals -> Range[Length[fixtureIntegrals]]],
   "integralCount" -> Length[fixtureIntegrals],
   "equationCount" -> 1,
   "kiraOrdering" -> <||>,
   "dSIBPContextSummary" -> <|
     "packageVersion" -> kiraImportContext["packageVersion"],
     "inputHash" -> kiraImportContext["inputHash"],
     "caseName" -> kiraImportContext["caseName"],
     "sectorKeys" -> Lookup[kiraImportContext["sectors"], "sectorKey", {}],
     "loopTreeProjectionConvention" -> kiraImportContext["loopTreeProjectionConvention"]
     |>
   |>;

fixtureRoot = FileNameJoin[{codeDir, "test", "results_test", "014_kira_import_negative"}];
baseDir = FileNameJoin[{fixtureRoot, "valid"}];
exportData = DSKiraExport[
   fixtureLinearData,
   OutputDirectory -> baseDir,
   KiraTargetIntegrals -> {1, 2, 3},
   KiraJobOptions -> <|"AppendNumericDummyEquation" -> False|>
   ];
If[Lookup[exportData, "status", "missing"] =!= "ready",
 Print["Kira exporter fixture failed=", exportData];
 Exit[1]
 ];

baseManifest = exportData["dSIBPExportManifest"];
baseJToKira = Get[FileNameJoin[{baseDir, "result", "repJ2kira.m"}]];
baseKiraToJ = Get[FileNameJoin[{baseDir, "result", "repkira2J.m"}]];
ibpText = Import[FileNameJoin[{baseDir, "userSystem", "ibp.kira"}], "Text"];
ibpBytes = BinaryReadList[FileNameJoin[{baseDir, "userSystem", "ibp.kira"}], "Byte"];

(* synthetic Kira 输出必须只含 backend 原子；原变量只用于定义预期的恢复结果。 *)
backendCoefficientRules = Join[
   (Lookup[#, "original"] -> Symbol["Global`" <> Lookup[#, "backend"]]) & /@
    Lookup[baseManifest, "coefficientVariableMap", {}],
   If[StringQ[Lookup[baseManifest, "backendImaginaryUnit", None]],
    {I -> Symbol["Global`" <> baseManifest["backendImaginaryUnit"]]},
    {}
    ]
   ];
validReductionOriginal = {
   Tuserweight[2] -> (I P1 + kk[1, 1] + Sqrt[kk[1, 1]]) Tuserweight[1],
   Tuserweight[3] -> P2 Tuserweight[1]
   };
validReduction = validReductionOriginal /. backendCoefficientRules;


(* ::Section::Closed:: *)
(*夹具写入器*)

(* 每个 case 都写完整文件集，避免负例共享可变文件；已有目录只覆盖同名小文件。 *)
writeImportFixture[
   directory_String,
   manifest_Association,
   jToKira_List,
   kiraToJ_List,
   reduction_List,
   mastersText_String,
   completionText_String
   ] := Module[{resultDir},
   resultDir = FileNameJoin[{directory, "result"}];
   If[! DirectoryQ[resultDir], CreateDirectory[resultDir, CreateIntermediateDirectories -> True]];
   If[! DirectoryQ[FileNameJoin[{directory, "results"}]],
    CreateDirectory[FileNameJoin[{directory, "results"}], CreateIntermediateDirectories -> True]
    ];
   Put[manifest, FileNameJoin[{directory, "dsibp-export-manifest.wl"}]];
   Put[jToKira, FileNameJoin[{resultDir, "repJ2kira.m"}]];
   Put[kiraToJ, FileNameJoin[{resultDir, "repkira2J.m"}]];
   Put[reduction, FileNameJoin[{directory, "results", "kira_list.m"}]];
   Export[FileNameJoin[{directory, "results", "masters"}], mastersText, "Text"];
   Export[FileNameJoin[{directory, "kira.log"}], completionText, "Text"];
   directory
   ];

writeImportFixture[baseDir, baseManifest, baseJToKira, baseKiraToJ,
  validReduction, "1 #\n", "Kira finished successfully\n"];


(* ::Chapter:: *)
(*派生相互隔离的定向负例*)

caseDirs = AssociationMap[FileNameJoin[{fixtureRoot, #}] &, {
    "missing_completion", "mismatched_hash", "noninverse_maps",
    "duplicate_maps", "incomplete_targets", "rhs_nonmaster"
    }];

writeImportFixture[
  caseDirs["missing_completion"], baseManifest, baseJToKira, baseKiraToJ,
  validReduction, "1 #\n", "Kira started but has no completion marker\n"
  ];

hashMismatchManifest = ReplacePart[baseManifest, {"context", "inputHash"} -> "deliberately-mismatched-input-hash"];
writeImportFixture[
  caseDirs["mismatched_hash"], hashMismatchManifest, baseJToKira, baseKiraToJ,
  validReduction, "1 #\n", "Kira finished successfully\n"
  ];

noninverseKiraToJ = ReplacePart[
   baseKiraToJ,
   3 -> (Tuserweight[3] -> Last[baseKiraToJ[[2]]])
   ];
writeImportFixture[
  caseDirs["noninverse_maps"], baseManifest, baseJToKira, noninverseKiraToJ,
  validReduction, "1 #\n", "Kira finished successfully\n"
  ];

duplicateJToKira = {
   fixtureIntegrals[[1]] -> 1,
   fixtureIntegrals[[1]] -> 2,
   fixtureIntegrals[[3]] -> 3
   };
duplicateKiraToJ = {
   Tuserweight[1] -> fixtureIntegrals[[1]],
   Tuserweight[2] -> fixtureIntegrals[[1]],
   Tuserweight[3] -> fixtureIntegrals[[3]]
   };
duplicateManifest = ReplacePart[baseManifest, "integralRules" -> duplicateJToKira];
writeImportFixture[
  caseDirs["duplicate_maps"], duplicateManifest, duplicateJToKira, duplicateKiraToJ,
  validReduction, "1 #\n", "Kira finished successfully\n"
  ];

writeImportFixture[
  caseDirs["incomplete_targets"], baseManifest, baseJToKira, baseKiraToJ,
  {Tuserweight[2] -> 2 Tuserweight[1]}, "1 #\n", "Kira finished successfully\n"
  ];

writeImportFixture[
  caseDirs["rhs_nonmaster"], baseManifest, baseJToKira, baseKiraToJ,
  {Tuserweight[2] -> Tuserweight[3], Tuserweight[3] -> Tuserweight[1]},
  "1 #\n", "Kira finished successfully\n"
  ];


(* ::Chapter:: *)
(*调用公开 importer 并核对命中的门禁*)

contextConventionChecks = <|
   "packageVersion" -> Lookup[baseManifest, "packageVersion", Missing["packageVersion"]] === kiraImportContext["packageVersion"],
   "inputHash" -> Lookup[baseManifest["context"], "inputHash", Missing["inputHash"]] === kiraImportContext["inputHash"],
   "zeroPointRules" -> Lookup[baseManifest, "zeroPointRules", Missing["zeroPointRules"]] === Lookup[kiraImportContext["topology"], "zeroPointRules", Missing["zeroPointRules"]],
   "symmetryRules" -> Lookup[baseManifest, "symmetryRules", Missing["symmetryRules"]] === Lookup[kiraImportContext["topology"], "symmetryRules", Missing["symmetryRules"]],
   "tadpoleSymmetryData" -> Lookup[baseManifest, "tadpoleSymmetryData", Missing["tadpoleSymmetryData"]] === KeyDrop[dSIBP`Private`tadpoleSymmetryData[kiraImportContext["topology"]], {"automaticRules"}],
   "loopTreeProjectionConvention" -> Lookup[baseManifest, "loopTreeProjectionConvention", Missing["loopTreeProjectionConvention"]] === kiraImportContext["loopTreeProjectionConvention"]
   |>;

positiveResult = DSKiraImport[baseDir, kiraImportContext];
negativeResults = Map[DSKiraImport[#, kiraImportContext] &, caseDirs];

issueList[result_Association] := Lookup[Lookup[result, "validationReport", <||>], "issues", {}];

checks = <|
   "exportReady" -> Lookup[exportData, "status", "missing"] === "ready",
   "backendSyntaxReport" -> Lookup[Lookup[exportData, "backendCoefficientSyntaxReport", <||>], "status", "missing"] === "valid",
   "backendMapOriginals" -> SortBy[Lookup[baseManifest["coefficientVariableMap"], "original", {}], ToString[InputForm[#]] &] === SortBy[{P1, P2, kk[1, 1], Sqrt[kk[1, 1]]}, ToString[InputForm[#]] &],
   "algebraicGeneratorManifest" -> Lookup[baseManifest, "coefficientAlgebraicGenerators", {}] === {Sqrt[kk[1, 1]]},
   "backendImaginaryUnit" -> Lookup[baseManifest, "backendImaginaryUnit", None] === "dsii",
   "ibpNoBracketsOrContexts" -> FreeQ[StringCases[ibpText, "[" | "]" | "`"], _String],
   "ibpNoUppercaseTokens" -> StringCases[ibpText, RegularExpression["[A-Z]"]] === {},
   "ibpUsesLFOnly" -> FreeQ[ibpBytes, 13] && MemberQ[ibpBytes, 10],
   "positiveImported" -> Lookup[positiveResult, "status", "missing"] === "imported",
   "positiveValidationPassed" -> Lookup[positiveResult["validationReport"], "status", "missing"] === "passed",
   "positiveMasterOrder" -> Lookup[positiveResult, "masterIDs", {}] === {1},
   "positiveRestoresOriginalReduction" -> Lookup[positiveResult, "reductionRules", {}] === (validReductionOriginal /. Normal[Association[baseKiraToJ]]),
   "positiveNoBackendSymbols" -> Cases[
      Lookup[positiveResult, "reductionRules", {}],
      symbol_Symbol /; StringMatchQ[SymbolName[symbol], RegularExpression["dsc[0-9]+|dsii"]],
      Infinity
      ] === {},
   "missingCompletionReason" -> Lookup[negativeResults["missing_completion"], "reason", "missing"] === "completionMarkerMissing",
   "hashMismatchReason" -> Lookup[negativeResults["mismatched_hash"], "reason", "missing"] === "validationFailed",
   "hashMismatchIssue" -> issueList[negativeResults["mismatched_hash"]] === {"contextConventionMatch"},
   "noninverseReason" -> Lookup[negativeResults["noninverse_maps"], "reason", "missing"] === "validationFailed",
   "noninverseIssue" -> issueList[negativeResults["noninverse_maps"]] === {"inverseIntegralMaps"},
   "duplicateMapRejected" -> issueList[negativeResults["duplicate_maps"]] === {"inverseIntegralMaps"},
   "incompleteTargetReason" -> Lookup[negativeResults["incomplete_targets"], "reason", "missing"] === "validationFailed",
   "incompleteTargetIssue" -> issueList[negativeResults["incomplete_targets"]] === {"completeTargetCoverage"},
   "rhsResidualReason" -> Lookup[negativeResults["rhs_nonmaster"], "reason", "missing"] === "validationFailed",
   "rhsResidualIssue" -> issueList[negativeResults["rhs_nonmaster"]] === {"rhsContainsOnlyMasters"},
   "rhsResidualIDsRecognized" -> TrueQ[
     Lookup[
      Lookup[Lookup[negativeResults["rhs_nonmaster"], "validationReport", <||>], "checks", <||>],
      "allReductionIDsRecognized",
      False
      ]
     ]
   |>;

Print["014 Kira import negative check: ", Count[Values[checks], True], "/", Length[checks]];
If[! And @@ Values[checks],
 Print[Select[checks, Not]];
 Print["context convention components=", contextConventionChecks];
 Print["positive validation=", Lookup[positiveResult, "validationReport", Missing["validationReport"]]];
 Print["negative issues=", Map[issueList, negativeResults]];
 Exit[1]
 ];
