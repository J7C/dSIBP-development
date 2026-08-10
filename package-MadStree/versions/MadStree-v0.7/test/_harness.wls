(* ::Package:: *)

(***
File: _harness.wls
Purpose: Shared loading and summary boilerplate for the MadStree v0.7 development tests. Test scripts include it with
      Get[FileNameJoin[{DirectoryName[$InputFileName], "_harness.wls"}]],
      then call msTestLoadKernel[] and optionally msTestSummary[checks, title].
Conventions: msTestSummary unifies passed/total, failed keys and the exit code; case-specific printing stays in the tests.
***)

(* ::Chapter:: *)
(* Package loading *)

msTestLoadKernel[] := Module[{packageRoot},
  packageRoot = DirectoryName[DirectoryName[$InputFileName]];
  AppendTo[$Path, FileNameJoin[{packageRoot, "Kernel"}]];
  Needs["MadStree`"];
  packageRoot
];


(* On the running machine WolframScript may resolve python to an interpreter without python-flint; tests can fix the backend interpreter via the MADSTREE_PYTHON environment variable, which defaults to "python". *)
msTestPythonExecutable[] := With[{override = Quiet[Environment["MADSTREE_PYTHON"]]},
  If[StringQ[override] && StringLength[StringTrim[override]] > 0,
    StringTrim[override],
    "python"
  ]
];


(* ::Chapter:: *)
(* Summary and exit code *)

msTestSummary[checks_Association, title_String] := Module[{passed, total, failed},
  passed = Count[Values[checks], True];
  total = Length[checks];
  failed = Keys@Select[checks, Not@TrueQ[#] &];
  Print[title, ": ", passed, "/", total];
  Print["failed: ", InputForm[failed]];
  KeyValueMap[Print[#1, ": ", #2] &, checks];
  If[passed =!= total, Exit[1]]
];
