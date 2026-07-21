(* ::Package:: *)
(* mixed_triangle 的固定 benchmark 输入，保留 line 3 的 v3->v1 方向。 *)

familyDir = DirectoryName[$InputFileName];
benchmarkDir = DirectoryName[familyDir];
Get[FileNameJoin[{benchmarkDir, "oracle", "benchmark_family_definitions.wl"}]];


(* ::Chapter:: *)
(*函数族定义*)

familyDefinition = mixedTriangleFamily;
