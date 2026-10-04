(* ::Package:: *)
(* 文件用途：通过 FlintNDE 0.5.0 标准 Wolfram 入口执行 Validation-05 的复数普通点和
   精确奇点 case；结果只写入本独立验证目录的 results_temp。 *)

(* ::Chapter:: *)
(*路径与标准包加载*)

caseRoot = DirectoryName[$InputFileName];
packageRoot = DirectoryName[DirectoryName[caseRoot]];
versionRoot = FileNameJoin[{packageRoot, "versions", "FlintNDE-0.5.0"}];
If[! MemberQ[$Path, versionRoot], AppendTo[$Path, versionRoot]];
Needs["FlintNDE`"];

runtimeRoot = FileNameJoin[{caseRoot, "results_temp", "wolfram_bridge"}];
If[! DirectoryQ[runtimeRoot], CreateDirectory[runtimeRoot, CreateIntermediateDirectories -> True]];
python = Replace[Environment["FLINTNDE_TEST_PYTHON"], {$Failed -> "python", "" -> "python"}];


(* ::Chapter:: *)
(*复数普通点路线*)

ordinarySystem = FlintNDERationalSystem[{{1/(x + 2)}}, x, "Name" -> "validation-05-ordinary"];
ordinaryPlan = FlintNDEPlanPath[
  ordinarySystem,
  0,
  {1, 2},
  MessageLanguage -> "CN",
  "Python" -> python,
  "WorkDirectory" -> runtimeRoot,
  "WorkingPrecisionDigits" -> 90,
  "OutputDigits" -> 50
];
ordinaryResult = FlintNDEExecutePath[
  ordinarySystem,
  {1 + I},
  ordinaryPlan,
  MessageLanguage -> "CN",
  "Python" -> python,
  "WorkDirectory" -> runtimeRoot,
  "WorkingPrecisionDigits" -> 90,
  "OutputDigits" -> 50,
  "PrimaryOrder" -> 48,
  "ReferenceOrder" -> 68,
  "TargetRelativeError" -> "1e-25"
];
ordinaryValue = First[ordinaryResult["referenceFinalVector"]];


(* ::Chapter:: *)
(*精确奇点文本类型*)

singularSystem = FlintNDERationalSystem[{{-1/(x - 1)}}, x, "Name" -> "validation-05-pole"];
singularPlan = FlintNDEPlanPath[
  singularSystem,
  0,
  {1/2, 1, 3/2, 2},
  SingularityMode -> "SingularityJump",
  MessageLanguage -> "CN",
  "Python" -> python,
  "WorkDirectory" -> runtimeRoot,
  "WorkingPrecisionDigits" -> 90,
  "OutputDigits" -> 50
];
singularResult = FlintNDEExecutePath[
  singularSystem,
  {1},
  singularPlan,
  MessageLanguage -> "CN",
  "Python" -> python,
  "WorkDirectory" -> runtimeRoot,
  "WorkingPrecisionDigits" -> 90,
  "OutputDigits" -> 50,
  "PrimaryOrder" -> 64,
  "ReferenceOrder" -> 88,
  "TargetRelativeError" -> "1e-25"
];
singularRecord = First[singularResult["singularTargets"]];
infinityValue = First[singularRecord["values"]];


(* ::Chapter:: *)
(*结构化验收与机器摘要*)

checks = <|
  "needsVersion" -> $FlintNDEVersion === "0.5.0",
  "ordinarySchemas" ->
    StringQ[Lookup[ordinaryPlan, "schema", None]] &&
    StringQ[Lookup[ordinaryResult, "schema", None]],
  "ordinaryComplexType" -> NumericQ[ordinaryValue] && ! TrueQ[Im[ordinaryValue] == 0],
  "ordinaryClosedForm" -> TrueQ[Abs[ordinaryValue - (2 + 2 I)] < 10^-25],
  "singularInfinityText" -> infinityValue === "Infinity",
  "singularClassification" ->
    Lookup[singularRecord, "classification", None] === "true_pole" &&
    Lookup[singularRecord, "userPointIndex", None] === 1,
  "messageLanguageCN" ->
    Lookup[ordinaryPlan, "messageLanguage", None] === "CN" &&
    Lookup[singularPlan, "messageLanguage", None] === "CN",
  "callerLocalOutput" -> StringStartsQ[ExpandFileName[runtimeRoot], ExpandFileName[caseRoot]]
|>;

summaryPath = FileNameJoin[{runtimeRoot, "wolfram_summary.json"}];
summary = <|
  "schema" -> "flintnde_0.5.0_validation_05_wolfram_v1",
  "status" -> If[And @@ Values[checks], "passed", "failed"],
  "passedCount" -> Count[Values[checks], True],
  "checkCount" -> Length[checks],
  "ordinaryPlanSchema" -> Lookup[ordinaryPlan, "schema", None],
  "ordinaryResultSchema" -> Lookup[ordinaryResult, "schema", None],
  "ordinaryValueInputForm" -> ToString[InputForm[ordinaryValue]],
  "ordinaryValueHead" -> ToString[InputForm[Head[ordinaryValue]]],
  "infinityValue" -> infinityValue,
  "singularClassification" -> Lookup[singularRecord, "classification", None],
  "messageLanguage" -> Lookup[singularPlan, "messageLanguage", None],
  "runtimeRoot" -> runtimeRoot,
  "summaryPath" -> summaryPath,
  "checks" -> checks
|>;
Export[summaryPath, summary, "RawJSON", CharacterEncoding -> "UTF-8"];

Print["FlintNDE Validation-05 Wolfram bridge: ", Count[Values[checks], True], "/",
  Length[checks], " checks passed."];
If[! And @@ Values[checks], Exit[1]];
