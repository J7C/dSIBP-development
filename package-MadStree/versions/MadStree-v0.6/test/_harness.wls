(* ::Package:: *)

(***
文件：_harness.wls
用途：MadStree v0.6 开发测试共享的加载与汇总样板。测试脚本以
      Get[FileNameJoin[{DirectoryName[$InputFileName], "_harness.wls"}]] 引入，
      再调用 msTestLoadKernel[] 与（可选）msTestSummary[checks, title]。
约定：msTestSummary 统一 passed/total、失败键和退出码；case 专属打印由测试保留。
***)

(* ::Chapter:: *)
(*包加载*)

msTestLoadKernel[] := Module[{packageRoot},
  packageRoot = DirectoryName[DirectoryName[$InputFileName]];
  AppendTo[$Path, FileNameJoin[{packageRoot, "Kernel"}]];
  Needs["MadStree`"];
  packageRoot
];


(* 运行机器上 WolframScript 可能把 python 解析到没有 python-flint 的解释器；
  测试可通过环境变量 MADSTREE_PYTHON 固定后端解释器，缺省保持 "python"。 *)
msTestPythonExecutable[] := With[{override = Quiet[Environment["MADSTREE_PYTHON"]]},
  If[StringQ[override] && StringLength[StringTrim[override]] > 0,
    StringTrim[override],
    "python"
  ]
];


(* ::Chapter:: *)
(*汇总与退出码*)

msTestSummary[checks_Association, title_String] := Module[{passed, total, failed},
  passed = Count[Values[checks], True];
  total = Length[checks];
  failed = Keys@Select[checks, Not@TrueQ[#] &];
  Print[title, ": ", passed, "/", total];
  Print["failed: ", InputForm[failed]];
  KeyValueMap[Print[#1, ": ", #2] &, checks];
  If[passed =!= total, Exit[1]]
];
