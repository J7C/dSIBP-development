(* ::Package:: *)
(* parallel_massless_bundle_guard 的三线共同-theta 固定输入。 *)

familyDir = DirectoryName[$InputFileName];
benchmarkDir = DirectoryName[familyDir];
Get[FileNameJoin[{benchmarkDir, "oracle", "benchmark_family_definitions.wl"}]];


(* ::Chapter:: *)
(*函数族定义*)

familyDefinition = parallelMasslessBundleFamily;
