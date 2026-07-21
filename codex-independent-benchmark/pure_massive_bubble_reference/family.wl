(* ::Package:: *)
(* pure_massive_bubble_reference 的正式符号 zero-point 输入。reference-only map 另存。 *)

familyDir = DirectoryName[$InputFileName];
benchmarkDir = DirectoryName[familyDir];
Get[FileNameJoin[{benchmarkDir, "oracle", "benchmark_family_definitions.wl"}]];


(* ::Chapter:: *)
(*函数族定义*)

familyDefinition = pureMassiveBubbleReferenceFamily;
