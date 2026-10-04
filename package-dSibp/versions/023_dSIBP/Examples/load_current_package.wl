(* ::Package:: *)
(* 本文件为模块源码与成品 examples 提供统一加载入口。模块目录使用标准 Needs 入口；
   正式交付自动绑定唯一的同版本程序与手册。维护者可用成对环境变量检查候选字节。 *)

(* ::Chapter:: *)
(*解析唯一交付件*)

exampleLoaderDirectory = DirectoryName[$InputFileName];
packageDeliveryDirectory = DirectoryName[exampleLoaderDirectory];
modulePackageQ = FileExistsQ[FileNameJoin[{packageDeliveryDirectory, "dSIBP.m"}]] &&
   DirectoryQ[FileNameJoin[{packageDeliveryDirectory, "Kernel"}]];
packageOverride = Quiet[Environment["DSIBP_PACKAGE_FILE"]];
manualOverride = Quiet[Environment["DSIBP_PDF_FILE"]];
packageOverrideQ = StringQ[packageOverride] && StringLength[StringTrim[packageOverride]] > 0;
manualOverrideQ = StringQ[manualOverride] && StringLength[StringTrim[manualOverride]] > 0;

If[Xor[packageOverrideQ, manualOverrideQ],
  Print[Style["ERROR: 候选检查必须同时设置 DSIBP_PACKAGE_FILE 与 DSIBP_PDF_FILE。", Red]];
  Abort[]
  ];

If[modulePackageQ && ! packageOverrideQ,
  PrependTo[$Path, packageDeliveryDirectory];
  Needs["dSIBP`"];
  currentVersion = ToString[dSIBP`$dSIBPVersion];
  currentPackagePath = FileNameJoin[{packageDeliveryDirectory, "dSIBP.m"}];
  currentManualPath = Missing["NotRequiredForModuleExamples"],
 If[packageOverrideQ,
  currentPackageCandidates = {ExpandFileName[packageOverride]};
  currentManualCandidates = {ExpandFileName[manualOverride]},
  currentPackageCandidates = Select[
    FileNames["package_*.wl", packageDeliveryDirectory],
    StringMatchQ[FileBaseName[#], RegularExpression["package_[0-9]{3}(\\.[0-9]+)?"]] &
    ];
  currentManualCandidates = Select[
    FileNames["package_*.pdf", packageDeliveryDirectory],
    StringMatchQ[FileBaseName[#], RegularExpression["package_[0-9]{3}(\\.[0-9]+)?"]] &
    ]
  ];

If[Length[currentPackageCandidates] =!= 1 || Length[currentManualCandidates] =!= 1,
  Print[Style["ERROR: package/ 必须恰有一个当前程序和一个同版本手册。", Red]];
  Abort[]
  ];

currentPackagePath = First[currentPackageCandidates];
currentManualPath = First[currentManualCandidates];
currentVersion = FirstCase[
   StringCases[FileBaseName[currentPackagePath], RegularExpression["package_([0-9]{3}(?:\\.[0-9]+)?)"] -> "$1"],
   value_String,
   Missing["VersionToken"]
   ];
currentManualVersion = FirstCase[
   StringCases[FileBaseName[currentManualPath], RegularExpression["package_([0-9]{3}(?:\\.[0-9]+)?)"] -> "$1"],
   value_String,
   Missing["VersionToken"]
   ];

If[Head[currentVersion] === Missing || currentVersion =!= currentManualVersion,
  Print[Style["ERROR: 当前程序与手册的版本 token 不一致。", Red]];
  Abort[]
  ];


(* ::Chapter:: *)
(*加载并核对运行时版本*)

Get[currentPackagePath, CharacterEncoding -> "UTF-8"];

If[ToString[dSIBP`$dSIBPVersion] =!= currentVersion,
  Print[Style["ERROR: 运行时 package 版本与交付文件 token 不一致。", Red]];
  Abort[]
  ];
 ];
