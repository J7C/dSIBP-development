(* ::Package:: *)

(***
文件：load_current.wl
用途：从 MadStree 根目录加载 VERSION_INDEX.md 指定的当前工作版本 v0.7。
边界：该入口服务交互使用；正式验证和可复现计算应显式写出版本目录。
***)

(* ::Chapter:: *)
(*当前版本加载*)

madStreeCollectionDirectory = DirectoryName[$InputFileName];
madStreeCurrentVersion = "MadStree-v0.7";
madStreeCurrentVersionDirectory = FileNameJoin[{
  madStreeCollectionDirectory,
  "versions",
  madStreeCurrentVersion
}];

If[! DirectoryQ[madStreeCurrentVersionDirectory],
  Print["MadStree current version directory not found: ", madStreeCurrentVersionDirectory];
  Abort[]
];

If[! MemberQ[$Path, madStreeCurrentVersionDirectory],
  AppendTo[$Path, madStreeCurrentVersionDirectory]
];

Needs["MadStree`"];
