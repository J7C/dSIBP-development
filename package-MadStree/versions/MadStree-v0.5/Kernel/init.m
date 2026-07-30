(* ::Package:: *)

(***
文件：init.m
用途：MadStree 标准加载入口。
接口：把当前版本目录加入 $Path 后调用 Needs["MadStree`"]。
***)

Get[FileNameJoin[{DirectoryName[$InputFileName], "MadStree.wl"}]];
