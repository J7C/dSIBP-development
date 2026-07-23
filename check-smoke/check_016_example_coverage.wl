(* ::Package:: *)
(* 本脚本核对当前 016 公开 API、成品 example coverage manifest 与源码调用文本。
   可用 DSIBP_PACKAGE_FILE 显式加载候选单文件；未设置时加载模块源码。 *)

(* ::Chapter:: *)
(*路径与 package 加载*)

smokeDir = DirectoryName[$InputFileName];
projectDir = DirectoryName[smokeDir];
packageDir = FileNameJoin[{projectDir, "000_code", "016_dSIBP"}];
examplesDir = FileNameJoin[{projectDir, "independent-benchmark", "package", "examples"}];
manifestPath = FileNameJoin[{examplesDir, "coverage_manifest.wl"}];
packageOverride = Quiet[Environment["DSIBP_PACKAGE_FILE"]];

If[StringQ[packageOverride] && StringLength[StringTrim[packageOverride]] > 0,
  Get[ExpandFileName[packageOverride]],
  If[! MemberQ[$Path, packageDir], AppendTo[$Path, packageDir]];
  Needs["dSIBP`"]
  ];


(* ::Chapter:: *)
(*Manifest 与源码覆盖*)

manifest = Get[manifestPath];
coverage = Lookup[manifest, "coverage", <||>];
publicAPI = Sort@Lookup[DSPublicAPI[], "functions", {}];
manifestAPI = Sort@DeleteDuplicates@Flatten[Values[coverage]];

missingFiles = Select[Keys[coverage], ! FileExistsQ[FileNameJoin[{examplesDir, #}]] &];
missingSourceCalls = Flatten@KeyValueMap[
    Function[{relativePath, functions},
     Module[{sourcePath, source},
      sourcePath = FileNameJoin[{examplesDir, relativePath}];
      If[! FileExistsQ[sourcePath], Return[Thread[{relativePath, functions}]]];
      source = Import[sourcePath, "Text"];
      ({relativePath, #} & /@ Select[functions, ! StringContainsQ[source, # <> "["] &])
      ]
     ],
    coverage
    ];

checks = <|
   "version" -> ToString[$dSIBPVersion] === ToString[Lookup[manifest, "version", Missing[]]],
   "manifestMatchesPublicAPI" -> publicAPI === manifestAPI,
   "allExampleFilesExist" -> missingFiles === {},
   "allManifestCallsAppearInSource" -> missingSourceCalls === {}
   |>;

Print["016 example coverage: ", Count[Values[checks], True], "/", Length[checks],
  "; public API ", Length[publicAPI], "/", Length[manifestAPI]];
If[! And @@ Values[checks],
 Print["FAILED: ", Keys@Select[checks, ! TrueQ[#] &]];
 Print["public-only: ", Complement[publicAPI, manifestAPI]];
 Print["manifest-only: ", Complement[manifestAPI, publicAPI]];
 Print["missing files: ", missingFiles];
 Print["missing source calls: ", missingSourceCalls];
 Exit[1]
 ];

Exit[0];
