(* ::Package:: *)
(* atomic_massless_line 的固定 benchmark 输入。 *)

familyDir = DirectoryName[$InputFileName];
benchmarkDir = DirectoryName[familyDir];
Get[FileNameJoin[{benchmarkDir, "oracle", "atomic_family_definitions.wl"}]];


(* ::Chapter:: *)
(*函数族定义*)

familyDefinition = atomicMasslessFamily;
