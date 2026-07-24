(* ::Package:: *)
(* 本脚本核对 016 正式手册正文、附录汇总表与当前公开 API 的覆盖关系。
   可用 DSIBP_PACKAGE_FILE 显式加载候选单文件；脚本只读手册源码，不生成运行产物。 *)


(* ::Chapter:: *)
(*路径与 package 加载*)

smokeDir = DirectoryName[$InputFileName];
projectDir = DirectoryName[smokeDir];
packageDir = FileNameJoin[{projectDir, "000_code", "016_dSIBP"}];
manualPath = FileNameJoin[{
    projectDir, "000_note", "01_dS_ibp_package", "dS_ibp_package.tex"
    }];
packageOverride = Quiet[Environment["DSIBP_PACKAGE_FILE"]];

If[StringQ[packageOverride] && StringLength[StringTrim[packageOverride]] > 0,
  Get[ExpandFileName[packageOverride]],
  If[! MemberQ[$Path, packageDir], AppendTo[$Path, packageDir]];
  Needs["dSIBP`"]
  ];


(* ::Chapter:: *)
(*手册正文与附录覆盖*)

manualSource = Import[manualPath, "Text"];
manualParts = StringSplit[manualSource, "\\appendix", 2];
manualBody = If[Length[manualParts] >= 1, manualParts[[1]], ""];
manualAppendix = If[Length[manualParts] === 2, manualParts[[2]], ""];
publicAPI = Sort@Lookup[DSPublicAPI[], "functions", {}];

missingBody = Select[publicAPI, ! StringContainsQ[manualBody, #] &];
missingAppendix = Select[publicAPI, ! StringContainsQ[manualAppendix, #] &];
forbiddenPrivateWorkflow = {
   "makeCanonicalSeedBatch[", "makeLinearSystemData[",
   "makeSampledLinearSystemData[", "makeKiraExportData[",
   "makeIBPWorkflowData[", "makeIBPReadinessReport["
   };
privateWorkflowResiduals = Select[
   forbiddenPrivateWorkflow,
   StringContainsQ[manualSource, #] &
   ];

requiredContracts = {
   "templateSetHash", "templateIntegrityAudit", "rangeMode", "rangeRules",
   "equationCount", "equations", "preReduction", "formal",
   "preferredIntegrals", "candidateIntegrals", "activeBasis", "numericStage",
   "coefficientRules", "outputDirectory", "jobOptions",
   "analyticDerivativeCertificate", "targetIntegralIDsPreview",
   "minimalTargetsQ", "DSKiraExport[plan]"
   };
missingContracts = Select[requiredContracts, ! StringContainsQ[manualSource, #] &];


(* ::Chapter:: *)
(*确定性结论*)

checks = <|
   "manualExists" -> FileExistsQ[manualPath],
   "allPublicFunctionsInBody" -> missingBody === {},
   "allPublicFunctionsInAppendix" -> missingAppendix === {},
   "noPrivateWorkflowPresented" -> privateWorkflowResiduals === {},
   "newSeedAndKiraContractsPresent" -> missingContracts === {}
   |>;

Print["016 manual coverage: ", Count[Values[checks], True], "/", Length[checks],
  "; public API ", Length[publicAPI]];
If[! And @@ Values[checks],
 Print["FAILED: ", Keys@Select[checks, ! TrueQ[#] &]];
 Print["missing body: ", missingBody];
 Print["missing appendix: ", missingAppendix];
 Print["private workflow residuals: ", privateWorkflowResiduals];
 Print["missing contracts: ", missingContracts];
 Exit[1]
 ];

Exit[0];
