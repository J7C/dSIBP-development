(* ::Package:: *)
(* 文件用途：从标准 Needs 入口端到端验证 FlintNDE 0.3.0 的 Wolfram 接口。
   覆盖一般有理矩阵、内部自动特化、任意次多项式、缺省避奇点、显式奇点折跃、
   EN/CN 语言记录以及已有计划直接执行。 *)

(* ::Chapter:: *)
(*标准包加载与测试环境*)

versionDirectory = DirectoryName[DirectoryName[$InputFileName]];
If[! MemberQ[$Path, versionDirectory], AppendTo[$Path, versionDirectory]];
Needs["FlintNDE`"];

runtimeDirectory = FileNameJoin[{
  DirectoryName[$InputFileName],
  "results_temp",
  "mathematica_interface"
}];
python = Replace[Environment["FLINTNDE_TEST_PYTHON"], {$Failed -> "python", "" -> "python"}];


(* ::Chapter:: *)
(*系统构造与两阶段执行*)

specialSystem = FlintNDERationalSystem[
  {{x^2 + 1/(x - 2)}},
  x,
  "Name" -> "mma-certified-specialization"
];
specialPlan = FlintNDEPlanPath[
  specialSystem,
  0,
  {1},
  "Python" -> python,
  "WorkDirectory" -> runtimeDirectory,
  "WorkingPrecisionDigits" -> 70,
  "OutputDigits" -> 35
];
specialResult = FlintNDEExecutePath[
  specialSystem,
  {1},
  specialPlan,
  "Python" -> python,
  "WorkDirectory" -> runtimeDirectory,
  "WorkingPrecisionDigits" -> 70,
  "OutputDigits" -> 35,
  "PrimaryOrder" -> 70,
  "ReferenceOrder" -> 90,
  "TargetRelativeError" -> "1e-25"
];

generalSystem = FlintNDERationalSystem[{{1/(x - 2)^2}}, x];
generalPlan = FlintNDEPlanPath[
  generalSystem,
  0,
  {1},
  "Python" -> python,
  "WorkDirectory" -> runtimeDirectory,
  "WorkingPrecisionDigits" -> 70,
  "OutputDigits" -> 35
];
generalResult = FlintNDEExecutePath[
  generalSystem,
  {1},
  generalPlan,
  "Python" -> python,
  "WorkDirectory" -> runtimeDirectory,
  "WorkingPrecisionDigits" -> 70,
  "OutputDigits" -> 35,
  "PrimaryOrder" -> 70,
  "ReferenceOrder" -> 90,
  "TargetRelativeError" -> "1e-25",
  MessageLanguage -> "CN"
];

precisionRefusal = FlintNDEExecutePath[
  specialSystem,
  {1},
  specialPlan,
  "WorkingPrecisionDigits" -> 100,
  MessageLanguage -> "CN"
];

polynomialSystem = FlintNDEPartialFractionSystem[
  {{{1}}, {{2}}, {{3}}},
  {{{1/3}}},
  {2}
];


(* ::Chapter:: *)
(*奇点模式与公开接口合同*)

jumpSystem = FlintNDERationalSystem[{{1/(3 (x - 2))}}, x];
defaultRefusal = FlintNDEPlanPath[
  jumpSystem,
  0,
  {3},
  "Python" -> python,
  "WorkDirectory" -> runtimeDirectory,
  "WorkingPrecisionDigits" -> 70,
  "OutputDigits" -> 35
];
jumpPlan = FlintNDEPlanPath[
  jumpSystem,
  0,
  {3},
  SingularityMode -> "SingularityJump",
  MessageLanguage -> "CN",
  "Python" -> python,
  "WorkDirectory" -> runtimeDirectory,
  "WorkingPrecisionDigits" -> 70,
  "OutputDigits" -> 35
];

decodedScientific = FlintNDE`Private`flintNDEDecodeDecimal["1.25e-60", 50];
badLanguage = FlintNDEPlanPath[specialSystem, 0, {1}, MessageLanguage -> "en"];
badMode = FlintNDEPlanPath[specialSystem, 0, {1}, SingularityMode -> "avoid"];
unknownPlanOption = FlintNDEPlanPath[specialSystem, 0, {1}, "UnexpectedOption" -> True];
unknownExecuteOption = FlintNDEExecutePath[
  specialSystem,
  {1},
  specialPlan,
  "UnexpectedOption" -> True
];

checks = <|
  "needsVersion" -> $FlintNDEVersion === "0.3.0",
  "strictMessageLanguage" ->
    MatchQ[badLanguage, Failure["InvalidMessageLanguage", _Association]],
  "strictSingularityModes" ->
    FlintNDE`Private`flintNDENormalizeMode["Avoid"] === "avoid" &&
    FlintNDE`Private`flintNDENormalizeMode["SingularityJump"] === "singularity_jump" &&
    MatchQ[badMode, Failure["InvalidSingularityMode", _Association]],
  "publicOptionSymbols" ->
    Context[MessageLanguage] === StringJoin["FlintNDE", FromCharacterCode[96]] &&
    Context[SingularityMode] === StringJoin["FlintNDE", FromCharacterCode[96]] &&
    MemberQ[Options[FlintNDEPlanPath], MessageLanguage -> "EN"] &&
    MemberQ[Options[FlintNDEPlanPath], SingularityMode -> "Avoid"] &&
    MemberQ[Options[FlintNDEExecutePath], MessageLanguage -> "EN"],
  "unknownOptionsRejected" ->
    MatchQ[unknownPlanOption, Failure["UnknownOption", _Association]] &&
    MatchQ[unknownExecuteOption, Failure["UnknownOption", _Association]],
  "polynomialDegreeTwo" ->
    Length[Lookup[polynomialSystem, "polynomialCoefficients", {}]] === 3,
  "specializedInternally" ->
    Lookup[specialPlan, "solverKind", None] === "certifiedPolynomialSimplePoles" &&
    Lookup[Lookup[specialPlan, "specialization", <||>], "polynomial_degree", -1] === 2,
  "specialExecutionNoReplan" ->
    Lookup[specialResult, "executionAction", None] ===
      "execute_existing_plan_without_replanning",
  "planningPrecisionRecorded" ->
    Lookup[Lookup[specialPlan, "plan", <||>], "planningPrecisionDigits", None] === 70 &&
    Lookup[Lookup[Lookup[specialPlan, "plan", <||>], "path", <||>],
      "planning_precision_digits", None] === 70,
  "precisionUpgradeRefused" -> MatchQ[
    precisionRefusal,
    Failure["PlannedPathPrecisionInsufficient", _Association]
  ],
  "specialValue" -> TrueQ[
    Abs[First[specialResult["referenceFinalVector"]] - Exp[1/3]/2] < 10^-20
  ],
  "generalRoute" ->
    Lookup[generalPlan, "solverKind", None] === "generalRationalMatrix" &&
    Lookup[generalPlan, "pathKind", None] === "adaptivePath",
  "generalExecutionNoReplan" ->
    Lookup[generalResult, "executionAction", None] ===
      "execute_existing_plan_without_replanning",
  "generalValue" -> TrueQ[
    Abs[First[generalResult["referenceFinalVector"]] - Exp[1/2]] < 10^-25
  ],
  "multisegmentCertifiedUpgrade" ->
    Lookup[generalResult, "certificationMode", None] === "certified",
  "defaultAvoidRefusal" ->
    Lookup[defaultRefusal, "status", None] === "singularPathRefused" &&
    Lookup[defaultRefusal, "singularityMode", None] === "avoid",
  "explicitJump" ->
    Lookup[jumpPlan, "status", None] === "complete" &&
    Lookup[jumpPlan, "singularityMode", None] === "singularity_jump" &&
    Lookup[jumpPlan, "messageLanguage", None] === "CN",
  "scientificDecode" -> TrueQ[
    Precision[decodedScientific] >= 49 &&
    Abs[decodedScientific - 1.25 10^-60] < 10^-100
  ]
|>;

Print["FlintNDE Mathematica interface: ", Count[Values[checks], True], "/",
  Length[checks], " checks passed."];

If[! And @@ Values[checks],
  Print[InputForm[Select[Normal[checks], Last[#] =!= True &]]];
  Print["general reference value: ",
    InputForm[Lookup[generalResult, "referenceFinalVector", Missing["Absent"]]]];
  Print["general absolute difference: ",
    InputForm[Abs[First[generalResult["referenceFinalVector"]] - Exp[1/2]]]];
  Exit[1]
];
