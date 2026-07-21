(* ::Package:: *)
(* pure_massless_bubble 的固定 benchmark 输入。 *)

familyDir = DirectoryName[$InputFileName];
benchmarkDir = DirectoryName[familyDir];
Get[FileNameJoin[{benchmarkDir, "oracle", "benchmark_family_definitions.wl"}]];


(* ::Chapter:: *)
(*函数族定义*)

familyDefinition = pureMasslessBubbleFamily;
