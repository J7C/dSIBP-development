(* ::Package:: *)

(***
文件：load_current.wl
用途：从 MadStree 根目录加载 VERSION_INDEX.md 指定的当前工作版本 v0.3。
边界：该入口服务交互使用；正式验证和可复现计算应显式写出版本目录。
***)

(* ::Chapter:: *)
(*当前版本加载*)

madStreeCollectionDirectory = DirectoryName[$InputFileName];
madStreeCurrentVersion = "MadStree-v0.3";
madStreeCurrentKernelDirectory = FileNameJoin[{
  madStreeCollectionDirectory,
  "versions",
  madStreeCurrentVersion,
  "Kernel"
}];

If[! DirectoryQ[madStreeCurrentKernelDirectory],
  Print["MadStree current version directory not found: ", madStreeCurrentKernelDirectory];
  Abort[]
];

If[! MemberQ[$Path, madStreeCurrentKernelDirectory],
  AppendTo[$Path, madStreeCurrentKernelDirectory]
];

Needs["MadStree`"];
