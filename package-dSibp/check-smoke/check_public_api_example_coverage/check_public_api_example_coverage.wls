(* ::Package:: *)
(* 用途：比较 DSPublicAPI[]、成品 example coverage manifest 与 held 源码中的实际函数调用。 *)


(* ::Chapter:: *)
(*候选程序与覆盖清单*)

scriptDirectory = DirectoryName[$InputFileName];
projectRoot = ExpandFileName[FileNameJoin[{scriptDirectory, "..", ".."}]];
examplesDirectory = FileNameJoin[{projectRoot, "independent-benchmark", "package", "examples"}];
manifestPath = FileNameJoin[{examplesDirectory, "coverage_manifest.wl"}];
packageOverride = Quiet[Environment["DSIBP_PACKAGE_FILE"]];

If[StringQ[packageOverride] && StringLength[StringTrim[packageOverride]] > 0,
 Get[ExpandFileName[packageOverride]],
 packageDirectory = FileNameJoin[{projectRoot, "versions", "020_dSIBP"}];
 PrependTo[$Path, packageDirectory];
 Needs["dSIBP`"]
 ];

manifest = Get[manifestPath];
coverage = Lookup[manifest, "coverage", <||>];
publicFunctions = Sort@DeleteDuplicates@Lookup[DSPublicAPI[], "functions", {}];
declaredFunctions = Sort@DeleteDuplicates@Flatten[Values[coverage]];


(* ::Chapter:: *)
(*Held 源码调用提取*)

calledFunctionNames[path_String] := Module[{source, held},
  source = Import[path, "Text", CharacterEncoding -> "UTF-8"];
  held = Quiet@Check[ToExpression[source, InputForm, HoldComplete], $Failed];
  If[held === $Failed,
   Return[$Failed]
   ];
  DeleteDuplicates@Cases[
    held,
    function_Symbol[___] :> SymbolName[Unevaluated[function]],
    Infinity
    ]
  ];

sourceAudit = Association@KeyValueMap[
    Function[{relativePath, expectedFunctions},
     Module[{absolutePath, calledFunctions},
      absolutePath = FileNameJoin[{examplesDirectory, relativePath}];
      calledFunctions = If[FileExistsQ[absolutePath], calledFunctionNames[absolutePath], $Failed];
      relativePath -> <|
        "fileExistsQ" -> FileExistsQ[absolutePath],
        "parseQ" -> ListQ[calledFunctions],
        "missingCalls" -> If[ListQ[calledFunctions], Complement[expectedFunctions, calledFunctions], expectedFunctions]
        |>
      ]
     ],
    coverage
    ];


(* ::Chapter:: *)
(*发布门禁结果*)

checks = <|
   "manifestVersion" -> (Lookup[manifest, "version", Missing["version"]] === ToString[$dSIBPVersion]),
   "noMissingPublicFunctions" -> (Complement[publicFunctions, declaredFunctions] === {}),
   "noUnknownDeclaredFunctions" -> (Complement[declaredFunctions, publicFunctions] === {}),
   "allFilesExist" -> And @@ Lookup[Values[sourceAudit], "fileExistsQ", False],
   "allFilesParse" -> And @@ Lookup[Values[sourceAudit], "parseQ", False],
   "allDeclaredCallsPresent" -> And @@ (# === {} & /@ Lookup[Values[sourceAudit], "missingCalls", {"unknown"}])
   |>;

failed = Keys@Select[checks, Not@*TrueQ];
summary = <|
   "passed" -> Count[Values[checks], True],
   "total" -> Length[checks],
   "failed" -> failed,
   "publicFunctionCount" -> Length[publicFunctions],
   "declaredFunctionCount" -> Length[declaredFunctions],
   "missingPublicFunctions" -> Complement[publicFunctions, declaredFunctions],
   "unknownDeclaredFunctions" -> Complement[declaredFunctions, publicFunctions],
   "sourceAudit" -> sourceAudit,
   "checks" -> checks
   |>;

Print[InputForm[summary]];
If[failed =!= {}, Exit[1]];
