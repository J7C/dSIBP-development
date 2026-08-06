(* ::Package:: *)

(***
文件：Paths.wl
用途：集中定义调用目录解析、绝对路径判定与受控目录创建，供 Artifacts.wl 和
      FlintNDE.wl 共用；两个使用方各自保留 Automatic 语义的专属 resolver。
约定：本模块只依赖 System`，不引用其它 MadStree 内部符号。
***)

(* ::Chapter:: *)
(*调用目录解析*)

msRuntimeDirectory[] := Module[{inputFile = $InputFileName, notebookDirectory},
  If[StringQ[inputFile] && inputFile =!= "",
    Return[DirectoryName[ExpandFileName[inputFile]]]
  ];
  notebookDirectory = Quiet@Check[NotebookDirectory[], $Failed];
  If[StringQ[notebookDirectory], ExpandFileName[notebookDirectory], Directory[]]
];


(* ::Section:: *)
(*绝对路径判定*)

(* 绝对路径直接展开；相对路径始终以调用脚本目录为基准，避免依赖当前进程目录。 *)
msAbsolutePathQ[path_String] := StringMatchQ[
  StringReplace[path, "\\" -> "/"],
  Alternatives[LetterCharacter ~~ ":/" ~~ ___, "/" ~~ ___]
];


(* ::Section:: *)
(*受控目录创建*)

(* 成功返回目录路径；失败返回 $Failed，由调用方决定 Failure 标签与诊断字段。 *)
msEnsureDirectory[path_String] := If[
  DirectoryQ[path],
  path,
  Quiet@Check[
    CreateDirectory[path, CreateIntermediateDirectories -> True],
    $Failed
  ]
];
