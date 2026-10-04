(* ::Package:: *)
(* 文件用途：验证 Kira export identity 摘要实际序列化的 ibp.kira 文件，而不再次哈希完整 MMA
   linearEquations。测试构造最小 artifact，检查现行 identity schema、文件篡改拒绝和旧字段清理；
   不运行 Kira，也不把合成数据作为 reduction 证据。 *)


(* ::Chapter:: *)
(*加载模块化 package*)

Get[FileNameJoin[{DirectoryName[$InputFileName], "..", "_harness.wls"}]];
projectRoot = ExpandFileName@FileNameJoin[{DirectoryName[$InputFileName], "..", ".."}];
dsSmokeLoadPackage[FileNameJoin[{projectRoot, "versions", "023_dSIBP", "Kernel", "dSIBP.wl"}]];
DSMessagesOff[];


(* ::Chapter:: *)
(*最小序列化 artifact 与 identity*)

resultsTestDirectory = FileNameJoin[{DirectoryName[$InputFileName], "results_test"}];
workspace = FileNameJoin[{resultsTestDirectory, "artifact_identity"}];
ibpPath = FileNameJoin[{workspace, "userSystem", "ibp.kira"}];

If[DirectoryQ[resultsTestDirectory], DeleteDirectory[resultsTestDirectory, DeleteContents -> True]];
CreateDirectory[DirectoryName[ibpPath], CreateIntermediateDirectories -> True];
Export[ibpPath, "1*(1)\n", "Text", CharacterEncoding -> "UTF-8"];

integral = J[{0}, {{0, 0, 0}}, {}];
integralRules = {integral -> 1};
activeBasis = <|"status" -> "disabled", "count" -> 0|>;
linearData = <|
   "artifactContract" -> <|"sourceDigest" -> "synthetic-source-digest"|>,
   "integralRules" -> integralRules,
   "coefficientRulesApplied" -> {},
   "activeBasis" -> activeBasis
   |>;
exportData = <|
   "outputDirectory" -> workspace,
   "filesWritten" -> {ibpPath},
   "targetIntegralIDs" -> {1}
   |>;

identity = dSIBP`Private`dsKiraArtifactIdentity[exportData, linearData];
manifest = <|
   "artifactIdentity" -> identity,
   "linearArtifactContract" -> linearData["artifactContract"],
   "integralRules" -> integralRules,
   "targetIntegralIDs" -> {1},
   "coefficientRulesApplied" -> {},
   "activeBasis" -> activeBasis
   |>;

expectedSerializedDigest = IntegerString[FileHash[ibpPath, "SHA256"], 16, 64];
identityBeforeTamperQ = dSIBP`Private`dsKiraArtifactIdentityQ[
   manifest,
   workspace,
   integralRules
   ];


(* ::Chapter:: *)
(*篡改拒绝与汇总*)

Export[ibpPath, "1*(2)\n", "Text", CharacterEncoding -> "UTF-8"];
identityAfterTamperQ = dSIBP`Private`dsKiraArtifactIdentityQ[
   manifest,
   workspace,
   integralRules
   ];

checks = <|
   "identityVersionIsCurrent" -> (Lookup[identity, "identityVersion", None] === 2),
   "serializedDigestMatchesWrittenKiraInput" ->
    (Lookup[identity, "serializedKiraInputDigest", None] === expectedSerializedDigest),
   "fullLinearEquationDigestRemoved" -> ! KeyExistsQ[identity, "linearEquationsDigest"],
   "identityPassesBeforeTamper" -> TrueQ[identityBeforeTamperQ],
   "tamperedKiraInputRejected" -> ! TrueQ[identityAfterTamperQ]
   |>;

If[DirectoryQ[resultsTestDirectory], DeleteDirectory[resultsTestDirectory, DeleteContents -> True]];
failed = Keys@Select[checks, Not@TrueQ[#] &];
Print["check_kira_export_digest_boundary: ", Count[Values[checks], True], "/", Length[checks]];
Print["failed: ", InputForm[failed]];
Print[InputForm[<|
   "passed" -> Count[Values[checks], True],
   "total" -> Length[checks],
   "failed" -> failed,
   "checks" -> checks
   |>]];
If[failed =!= {}, Exit[1]];
