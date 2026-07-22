(* ::Package:: *)
(* 本检查在新 kernel 中读取 015 单文件交付，逐项核对版本、root-coordinate usage、sp 属性和用户手册附录 A 的关键缺省选项。 *)

ClearAll["Global`*"];


(* ::Chapter:: *)
(*路径与 package 加载*)
checkDir = DirectoryName[$InputFileName];
workspaceDir = DirectoryName[checkDir];
projectDir = DirectoryName[workspaceDir];
packagePath = FileNameJoin[{projectDir, "independent-benchmark", "package", "package_015.wl"}];
resultsDir = FileNameJoin[{checkDir, "results"}];
resultPath = FileNameJoin[{resultsDir, "package-015-contract.wl"}];
If[! DirectoryQ[resultsDir], CreateDirectory[resultsDir, CreateIntermediateDirectories -> True]];

loadResult = Quiet[Check[Get[packagePath], $Failed]];


(* ::Chapter:: *)
(*公开合同 expected*)

(* ::Section::Closed:: *)
(*手册汇总表与消息接口*)
publicFunctions = {
  DSKinematics, DSInit, DSInfo, DSSeeds, DSLinear, DSKiraExport, DSKiraImport,
  DSDE, DSScaleCheck, DSTreeSeeds, repIterative, DSTreeNaiveIBP, DSTreeNaiveDE, DSTreeDLogDE,
  dtau, dqq, dqk, ds, rep2innerform, rep2outform, rep2Integrand,
  symmetry, DSMessagesOn, DSMessagesOff, DSMessagesQ
};

usageText[symbol_Symbol] := ToString[MessageName[symbol, "usage"] /. HoldPattern[MessageName[_, _]] -> "", InputForm];


(* ::Section::Closed:: *)
(*只核对手册明确承诺的关键缺省，不把未列出的实现选项误判为多余*)
manualOptionDefaults = <|
  DSInit -> <|
    KinematicRules -> Automatic,
    WriteInitializationFiles -> False,
    GenerateDerivativeMetadata -> False,
    OverwriteInitialization -> False
  |>,
  DSSeeds -> <|
    DiscreteMode -> Automatic,
    GenerateShrinkSectors -> True,
    MaxEquationCount -> Automatic
  |>,
  DSLinear -> <|
    CoefficientRules -> Automatic,
    KiraOrdering -> Automatic
  |>,
  DSKiraExport -> <|
    OutputDirectory -> None,
    KiraActiveBasis -> None,
    KiraJobOptions -> Automatic
  |>,
  DSKiraImport -> <|
    KiraReductionFile -> Automatic,
    KiraMasterFile -> Automatic,
    KiraCompletionFile -> Automatic,
    ProgressReporting -> Automatic
  |>,
  DSDE -> <|
    MaxReductionIterations -> 100,
    OutputDirectory -> None
  |>,
  DSScaleCheck -> <|
    ScalingRelation -> "Custom",
    ScalingVariables -> Automatic,
    ScalingWeights -> Automatic,
    ScalingDegrees -> Automatic
  |>,
  repIterative -> <|MaxIterations -> Automatic|>
|>;


(* ::Chapter:: *)
(*逐项检查与结果归档*)

(* ::Section::Closed:: *)
(*统一记录格式*)
checks = {};
appendCheck[label_, actual_, expected_] := AppendTo[checks, <|
  "label" -> label,
  "actual" -> actual,
  "expected" -> expected,
  "passed" -> TrueQ[actual === expected]
|>];

appendCheck["package-loaded", loadResult =!= $Failed, True];
appendCheck["version", $dSIBPVersion, "015"];
appendCheck["sp-orderless", MemberQ[Attributes[sp], Orderless], True];
appendCheck["ds-usage-root-coordinates", StringContainsQ[usageText[ds], "ssij"] && StringContainsQ[usageText[ds], "sE1,sE2"], True];
appendCheck["rep2out-usage-root-coordinates", StringContainsQ[usageText[rep2outform], "ssij/sEe"], True];
appendCheck["kinematics-usage-audit", StringContainsQ[usageText[DSKinematics], "DSKinematics[input,rules]"], True];

Do[
  appendCheck[
    {"usage", SymbolName[Unevaluated[function]]},
    StringQ[usageText[function]] && StringLength[StringTrim[usageText[function], "\""]] > 0,
    True
  ],
  {function, publicFunctions}
];

KeyValueMap[
  Function[{function, expectedDefaults},
    actualDefaults = Association[Options[function]];
    KeyValueMap[
      Function[{option, expected},
        appendCheck[
          {"option", SymbolName[Unevaluated[function]], SymbolName[Unevaluated[option]]},
          Lookup[actualDefaults, option, Missing["Absent"]],
          expected
        ]
      ],
      expectedDefaults
    ]
  ],
  manualOptionDefaults
];

summary = <|
  "packagePath" -> packagePath,
  "packageHash" -> FileHash[packagePath, "SHA256", "HexString"],
  "passed" -> Count[checks, _?(TrueQ[Lookup[#, "passed", False]] &)],
  "total" -> Length[checks],
  "nonconformities" -> Select[checks, ! TrueQ[Lookup[#, "passed", False]] &]
|>;

Put[summary, resultPath];
Print[InputForm[summary]];
If[summary["passed"] =!= summary["total"], Exit[1]];
