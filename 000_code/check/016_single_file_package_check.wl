(* ::Package:: *)
(* 本检查在全新 kernel 中只加载独立交付的 package_016.wl，确认冻结单文件不依赖模块源码目录，
   并核对版本、29 项公开 API、usage、Options 与 016 新增参数/纯时间接口。 *)

(* ::Chapter:: *)
(*加载冻结交付*)

projectRoot = DirectoryName[DirectoryName[DirectoryName[$InputFileName]]];
packageFile = FileNameJoin[{projectRoot, "independent-benchmark", "package", "package_016.wl"}];

Get[packageFile];


(* ::Chapter:: *)
(*公开接口与单文件完整性*)

apiData = DSPublicAPI[];
publicFunctionNames = Lookup[apiData, "functions", {}];
publicFunctions = Symbol /@ ("dSIBP`" <> # & /@ publicFunctionNames);
optionFunctionNames = Keys[Lookup[apiData, "options", <||>]];
optionFunctions = Symbol /@ ("dSIBP`" <> # & /@ optionFunctionNames);

checks = {
   FileExistsQ[packageFile],
   $dSIBPVersion === "016",
   Length[publicFunctions] === 29 && DuplicateFreeQ[publicFunctionNames],
   And @@ (StringQ[#::usage] && StringLength[#::usage] > 0 & /@ publicFunctions),
   And @@ (ListQ[Options[#]] & /@ optionFunctions),
   Length[DownValues[DSInit]] > 0 && Length[DownValues[DSKinematics]] > 0,
   Length[DownValues[DSParameterNotation]] > 0 && Length[DownValues[DSRedefineParameters]] > 0,
   Length[DownValues[DSKiraExport]] > 0 && Length[DownValues[DSKiraImport]] > 0,
   Length[DownValues[DSDE]] > 0 && Length[DownValues[DSScaleCheck]] > 0,
   Length[DownValues[DSTreeSeeds]] > 0 && Length[DownValues[DSTreeNaiveIBP]] > 0 &&
    Length[DownValues[DSTreeNaiveDE]] > 0 && Length[DownValues[DSTreeDLogDE]] > 0
   };

passed = Count[checks, True];
total = Length[checks];

Print["016 single-file package checks: ", passed, "/", total];

If[passed =!= total,
 Print["failed positions: ", Flatten[Position[checks, Except[True]]]];
 Print["empty option functions: ", Select[optionFunctionNames, Length[Options[Symbol["dSIBP`" <> #]]] == 0 &]];
 Exit[1]
 ];
