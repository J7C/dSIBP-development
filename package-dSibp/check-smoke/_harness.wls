(* ::Package:: *)

(***
文件：_harness.wls
用途：check-smoke 专用共享样板。统一当前版本入口解析、package 加载、checks 汇总、
      失败键与退出码。每个 smoke 保留自己的 case 输入、断言与额外摘要字段。
运行：各 check 脚本头部 Get[FileNameJoin[{DirectoryName[$InputFileName], "_harness.wls"}]]。
边界：本文件只被维护侧 check-smoke 读取；独立验证与正式 package 不得依赖它。
***)

(* ::Chapter:: *)
(*版本入口解析*)

(* 解析最终 package 入口：
   1) $ScriptCommandLine 中的 package_*.wl 候选（存在且为文件）；
   2) DSIBP_PACKAGE_FILE 环境变量；
   3) defaultFile 兜底。 *)
dsSmokeResolvePackageFile[defaultFile_String] := Module[{candidates, envPrimary},
  candidates = Select[
    $ScriptCommandLine,
    StringQ[#] && StringMatchQ[FileNameTake[#], "package_" ~~ __ ~~ ".wl"] && FileExistsQ[#] &
  ];
  If[candidates =!= {}, Return[Last[candidates]]];
  envPrimary = Quiet[Environment["DSIBP_PACKAGE_FILE"]];
  If[StringQ[envPrimary] && StringLength[StringTrim[envPrimary]] > 0,
    Return[StringTrim[envPrimary]]
  ];
  defaultFile
];


(* 加载 package 并返回版本根目录。入口是 Kernel/dSIBP.wl 时按模块化路径
   AppendTo $Path + Needs；入口是单文件 package_xxx.wl 时直接 Get。 *)
dsSmokeLoadPackage[defaultFile_String] := Module[{file, versionRoot},
  file = dsSmokeResolvePackageFile[defaultFile];
  If[FileNameTake[file] === "dSIBP.wl",
    versionRoot = DirectoryName[DirectoryName[file]];
    If[! MemberQ[$Path, versionRoot], PrependTo[$Path, versionRoot]];
    Needs["dSIBP`"],
    Get[file];
    versionRoot = Missing["SingleFilePackage"]
  ];
  versionRoot
];


(* ::Chapter:: *)
(*汇总与退出码*)

(* 打印 passed/total、失败键与完整 summary；可附加 smoke 专属摘要字段。 *)
dsSmokeSummary[checks_Association, title_String, extras_Association : <||>] := Module[
  {passed, total, failed, summary},
  passed = Count[Values[checks], True];
  total = Length[checks];
  failed = Keys@Select[checks, Not@TrueQ[#] &];
  Print[title, ": ", passed, "/", total];
  Print["failed: ", InputForm[failed]];
  summary = <|
    "passed" -> passed,
    "total" -> total,
    "failed" -> failed,
    "checks" -> checks
    |>;
  If[extras =!= <||>, summary = Join[summary, extras]];
  Print[InputForm[summary]];
  If[passed =!= total, Exit[1]];
  summary
];
