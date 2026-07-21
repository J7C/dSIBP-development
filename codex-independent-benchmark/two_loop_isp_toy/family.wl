(* ::Package:: *)
(* two_loop_isp_toy 的固定任意符号名输入，含两个 ISP 与三个 seed 点。 *)

familyDir = DirectoryName[$InputFileName];
benchmarkDir = DirectoryName[familyDir];
Get[FileNameJoin[{benchmarkDir, "oracle", "benchmark_family_definitions.wl"}]];


(* ::Chapter:: *)
(*函数族定义*)

familyDefinition = twoLoopISPToyFamily;
