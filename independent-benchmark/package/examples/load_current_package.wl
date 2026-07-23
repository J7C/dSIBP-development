(* ::Package:: *)
(* 本文件为成品 examples 提供统一加载入口：正式运行只接受交付目录中唯一的版本化程序
   和同 token 手册。维护者发布前可同时设置 DSIBP_PACKAGE_FILE/DSIBP_PDF_FILE，
   让同一 example 显式加载候选字节；只设置其中一个会被拒绝。 *)

(* ::Chapter:: *)
(*解析唯一交付件*)

exampleLoaderDirectory = DirectoryName[$InputFileName];
packageDeliveryDirectory = DirectoryName[exampleLoaderDirectory];
packageOverride = Quiet[Environment["DSIBP_PACKAGE_FILE"]];
manualOverride = Quiet[Environment["DSIBP_PDF_FILE"]];
packageOverrideQ = StringQ[packageOverride] && StringLength[StringTrim[packageOverride]] > 0;
manualOverrideQ = StringQ[manualOverride] && StringLength[StringTrim[manualOverride]] > 0;

If[Xor[packageOverrideQ, manualOverrideQ],
  Print[Style["ERROR: 候选检查必须同时设置 DSIBP_PACKAGE_FILE 与 DSIBP_PDF_FILE。", Red]];
  Abort[]
  ];

If[packageOverrideQ,
  currentPackageCandidates = {ExpandFileName[packageOverride]};
  currentManualCandidates = {ExpandFileName[manualOverride]},
  currentPackageCandidates = Select[
    FileNames["package_*.wl", packageDeliveryDirectory],
    StringMatchQ[FileBaseName[#], "package_" ~~ DigitCharacter ~~ DigitCharacter ~~ DigitCharacter] &
    ];
  currentManualCandidates = Select[
    FileNames["package_*.pdf", packageDeliveryDirectory],
    StringMatchQ[FileBaseName[#], "package_" ~~ DigitCharacter ~~ DigitCharacter ~~ DigitCharacter] &
    ]
  ];

If[Length[currentPackageCandidates] =!= 1 || Length[currentManualCandidates] =!= 1,
  Print[Style["ERROR: package/ 必须恰有一个当前程序和一个同版本手册。", Red]];
  Abort[]
  ];

currentPackagePath = First[currentPackageCandidates];
currentManualPath = First[currentManualCandidates];
currentVersion = FirstCase[
   StringCases[FileBaseName[currentPackagePath], RegularExpression["package_([0-9]{3})"] -> "$1"],
   value_ /; StringLength[value] === 3,
   Missing["VersionToken"]
   ];
currentManualVersion = FirstCase[
   StringCases[FileBaseName[currentManualPath], RegularExpression["package_([0-9]{3})"] -> "$1"],
   value_ /; StringLength[value] === 3,
   Missing["VersionToken"]
   ];

If[Head[currentVersion] === Missing || currentVersion =!= currentManualVersion,
  Print[Style["ERROR: 当前程序与手册的版本 token 不一致。", Red]];
  Abort[]
  ];


(* ::Chapter:: *)
(*加载并核对运行时版本*)

Get[currentPackagePath];

If[ToString[$dSIBPVersion] =!= currentVersion,
  Print[Style["ERROR: 运行时 package 版本与交付文件 token 不一致。", Red]];
  Abort[]
  ];
