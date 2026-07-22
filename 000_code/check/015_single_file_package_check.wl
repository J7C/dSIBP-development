(* ::Package:: *)
(* 本检查在全新 kernel 中只加载独立交付的 package_015.wl，确认冻结单文件不依赖模块源码目录，
   并核对版本、公开接口 usage、Options 与关键高层定义。 *)

(* ::Chapter:: *)
(*加载冻结交付*)

projectRoot = DirectoryName[DirectoryName[DirectoryName[$InputFileName]]];
packageFile = FileNameJoin[{projectRoot, "independent-benchmark", "package", "package_015.wl"}];

Get[packageFile];


(* ::Chapter:: *)
(*公开接口与单文件完整性*)

publicFunctions = {
   DSInit, DSInfo, DSSeeds, DSLinear, DSKiraExport, DSKiraImport, DSDE, DSScaleCheck,
   DSTreeSeeds, repIterative, DSTreeNaiveIBP, DSTreeNaiveDE, DSTreeDLogDE, dtau, dqq, dqk, ds, rep2innerform,
   rep2outform, rep2Integrand, symmetry, DSMessagesOn, DSMessagesOff, DSMessagesQ
   };

optionFunctions = {DSInit, DSSeeds, DSLinear, DSKiraExport, DSKiraImport, DSDE, DSScaleCheck};

checks = {
   FileExistsQ[packageFile],
   $dSIBPVersion === "015",
   And @@ (StringQ[#::usage] && StringLength[#::usage] > 0 & /@ publicFunctions),
   And @@ (ListQ[Options[#]] && Length[Options[#]] > 0 & /@ optionFunctions),
   Length[DownValues[DSInit]] > 0,
   Length[DownValues[DSKiraExport]] > 0,
   Length[DownValues[DSKiraImport]] > 0,
   Length[DownValues[DSDE]] > 0,
   Length[DownValues[DSScaleCheck]] > 0,
   Length[DownValues[DSTreeNaiveIBP]] > 0 && Length[DownValues[DSTreeNaiveDE]] > 0 &&
   Length[DownValues[DSTreeDLogDE]] > 0
   };

passed = Count[checks, True];
total = Length[checks];

Print["015 single-file package checks: ", passed, "/", total];

If[passed =!= total,
 Print["failed positions: ", Flatten[Position[checks, Except[True]]]];
 Exit[1]
 ];
