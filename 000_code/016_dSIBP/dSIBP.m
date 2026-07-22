(* ::Package:: *)

(* 标准 package 入口只定位 Kernel/init.m，不修改当前工作目录。 *)
Get[FileNameJoin[{DirectoryName[$InputFileName], "Kernel", "init.m"}]];
