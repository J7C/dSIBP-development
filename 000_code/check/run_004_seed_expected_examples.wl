(* ::Package:: *)
(* 轻量运行入口：加载 004_seed_expected_examples.wl 并执行结构比较。
   本文件只比较 seed 层结构字段，不生成解析 IBP 方程。 *)

SetDirectory[FileNameJoin[{DirectoryName[$InputFileName], "..", ".."}]];

Get["000_code/check/004_seed_expected_examples.wl"];

res = dSSeedExpected`runSeedExpectedStructureCheck[];
Print[res];

checkedResults = Select[Values[res], AssociationQ[#] && KeyExistsQ[#, "pass"] &];

If[And @@ (Lookup[#, "pass"] & /@ checkedResults),
   Exit[0],
   Exit[1]
   ];
