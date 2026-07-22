(* ::Package:: *)

(* ::Chapter:: *)
(*015 版本入口*)

(* 兼容直接 Get 版本文件的开发流程；正式 examples 应把 015_dSIBP 加入 $Path 后使用 Needs["dSIBP`"]。 *)
Module[{packageRoot = FileNameJoin[{DirectoryName[$InputFileName], "015_dSIBP"}]},
 If[! MemberQ[$Path, packageRoot], AppendTo[$Path, packageRoot]];
 Needs["dSIBP`"]
 ];
