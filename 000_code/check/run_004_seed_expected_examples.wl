(* ::Package:: *)
(* 轻量运行入口：加载 004_seed_expected_examples.wl 并执行结构比较。
   本文件只比较 seed 层结构字段，不生成解析 IBP 方程。
   默认只打印紧凑 summary；失败时再打印失败项，避免成功检查刷出巨大 Association。 *)

(* ::Chapter:: *)
(*环境与加载*)

SetDirectory[FileNameJoin[{DirectoryName[$InputFileName], "..", ".."}]];

Get["000_code/check/004_seed_expected_examples.wl"];


(* ::Chapter:: *)
(*执行与退出码*)

res = dSSeedExpected`runSeedExpectedStructureCheck[];

checkedResults = Select[Values[res], AssociationQ[#] && KeyExistsQ[#, "pass"] &];
failedResults = Select[checkedResults, ! TrueQ[Lookup[#, "pass", False]] &];
checkSummary = <|
   "checkedCount" -> Length[checkedResults],
   "passedCount" -> Count[Lookup[#, "pass"] & /@ checkedResults, True],
   "failedNames" -> If[failedResults === {}, {}, Lookup[failedResults, "name", Missing["name"]]]
   |>;

Print[checkSummary];

If[And @@ (Lookup[#, "pass"] & /@ checkedResults),
   Exit[0],
   Print[failedResults];
   Exit[1]
   ];
