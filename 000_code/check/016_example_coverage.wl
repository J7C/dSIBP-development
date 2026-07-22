(* ::Package:: *)
(* 本正式专项比较 016 公开函数清单与成品 example 覆盖 manifest，并核对每个声明的
   函数调用确实出现在对应源文件。它不运行外部 Kira。 *)

(* ::Chapter:: *)
(*加载 package 与 manifest*)

checkDir = DirectoryName[$InputFileName];
codeDir = DirectoryName[checkDir];
projectDir = DirectoryName[codeDir];
packageDir = FileNameJoin[{codeDir, "016_dSIBP"}];
examplesDir = FileNameJoin[{projectDir, "independent-benchmark", "package", "examples"}];
manifestPath = FileNameJoin[{examplesDir, "coverage_manifest.wl"}];

If[! MemberQ[$Path, packageDir], AppendTo[$Path, packageDir]];
Needs["dSIBP`"];
DSMessagesOff[];

publicAPI = DSPublicAPI[];
manifest = Get[manifestPath];
coverage = Lookup[manifest, "coverage", <||>];


(* ::Chapter:: *)
(*覆盖与源码调用门禁*)

publicFunctions = Sort[Lookup[publicAPI, "functions", {}]];
declaredFunctions = Sort@DeleteDuplicates@Flatten[Values[coverage]];
examplePaths = AssociationMap[FileNameJoin[{examplesDir, #}] &, Keys[coverage]];
missingFiles = Keys@Select[examplePaths, ! FileExistsQ[#] &];
sourceTexts = Association@KeyValueMap[
    Function[{relativePath, path}, relativePath -> If[FileExistsQ[path], Import[path, "Text"], ""]],
    examplePaths
    ];

missingDeclaredCalls = Flatten@KeyValueMap[
    Function[{relativePath, functions},
     ({relativePath, #} &) /@ Select[
       functions,
       ! StringContainsQ[Lookup[sourceTexts, relativePath, ""], # <> "["] &
       ]
     ],
    coverage
    ];

checks = <|
   "versionMatches" -> Lookup[manifest, "version", None] === $dSIBPVersion,
   "allExampleFilesExist" -> missingFiles === {},
   "manifestCoversEveryPublicFunction" -> Complement[publicFunctions, declaredFunctions] === {},
   "manifestHasNoUnknownFunction" -> Complement[declaredFunctions, publicFunctions] === {},
   "declaredCallsExistInSources" -> missingDeclaredCalls === {},
   "runtimeSmokeListIsCovered" -> Complement[
      Lookup[manifest, "runtimeSmokeExamples", {}], Keys[coverage]] === {},
   "externalWorkflowIsCovered" -> MemberQ[
      Keys[coverage], Lookup[manifest, "externalWorkflowExample", None]]
   |>;

Print["016 example coverage: ", Count[Values[checks], True], "/", Length[checks],
  "; public functions ", Length[publicFunctions], "/", Length[declaredFunctions]];
If[! And @@ Values[checks],
 Print["FAILED: ", Keys@Select[checks, ! TrueQ[#] &]];
 Print["missing files: ", missingFiles];
 Print["uncovered public functions: ", Complement[publicFunctions, declaredFunctions]];
 Print["unknown manifest functions: ", Complement[declaredFunctions, publicFunctions]];
 Print["missing declared calls: ", missingDeclaredCalls];
 Exit[1]
 ];
