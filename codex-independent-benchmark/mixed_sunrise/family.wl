(* ::Package:: *)
(* mixed_sunrise 的固定 benchmark 输入，含两个显式 ISP 与三个 seed 点。 *)

familyDir = DirectoryName[$InputFileName];
benchmarkDir = DirectoryName[familyDir];
Get[FileNameJoin[{benchmarkDir, "oracle", "benchmark_family_definitions.wl"}]];


(* ::Chapter:: *)
(*函数族定义*)

familyDefinition = mixedSunriseFamily;
