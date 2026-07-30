(* ::Package:: *)
(* 验证 linearData["integralList"] 是 plan/export 前唯一的积分编号顺序来源。 *)

(* ::Chapter:: *)
(*加载模块化 package*)

projectRoot = ExpandFileName@FileNameJoin[{DirectoryName[$InputFileName], "..", ".."}];
packageRoot = FileNameJoin[{projectRoot, "versions", "018_dSIBP"}];
candidateArguments = Select[
   $ScriptCommandLine,
   StringQ[#] && StringMatchQ[FileNameTake[#], "package_" ~~ __ ~~ ".wl"] && FileExistsQ[#] &
   ];
candidatePackage = If[candidateArguments =!= {}, Last[candidateArguments], Quiet@Environment["DSIBP_CHECK_PACKAGE"]];
If[StringQ[candidatePackage] && candidatePackage =!= "",
 Get[ExpandFileName[candidatePackage]],
 If[! MemberQ[$Path, packageRoot], AppendTo[$Path, packageRoot]];
 Needs["dSIBP`"]
 ];
DSMessagesOff[];


(* ::Chapter:: *)
(*两积分顺序与方程编号*)

integral1 = J[{0}, {{b[1], n[1, 0, 0]}}, {}];
integral2 = J[{1}, {{b[1], n[1, 0, 0]}}, {}];
linearData = <|
   "status" -> "generated",
   "dSIBPStatus" -> "generated",
   "caseName" -> "integralOrderAuthoritySmoke",
   "integralList" -> {integral1, integral2},
   "integralCount" -> 2,
   "integralRules" -> {integral1 -> 1, integral2 -> 2},
   "linearEquations" -> {<|"coefficientRules" -> {1 -> 3, 2 -> -5}|>}
   |>;

defaultPlan = DSKiraPlan[
   linearData,
   <|"stage" -> "preReduction", "preferredIntegrals" -> {integral2}|>
   ];
reordered = DSReorderIntegrals[linearData, {integral2}];
reorderedPlan = DSKiraPlan[
   reordered,
   <|"stage" -> "preReduction", "preferredIntegrals" -> {integral1}|>
   ];

checks = <|
   "defaultOrderPreserved" -> (defaultPlan["integralOrder"] === {integral1, integral2}),
   "preferredDoesNotReorder" -> (defaultPlan["linearData", "integralRules"] === linearData["integralRules"]),
   "explicitOrderAppliedOnce" -> (reordered["integralList"] === {integral2, integral1}),
   "equationIDsReindexed" -> (Lookup[First[reordered["linearEquations"]], "coefficientRules"] === {2 -> 3, 1 -> -5}),
   "planReadsExplicitOrder" -> (reorderedPlan["integralOrder"] === reordered["integralList"]),
   "orderingConvention" -> (reorderedPlan["orderingConvention"] === "linearDataIntegralList"),
   "publicAPI" -> MemberQ[DSPublicAPI[]["functions"], "DSReorderIntegrals"],
   "legacyExportOptionRemoved" -> FreeQ[Options[DSKiraExport], KiraIntegralOrder]
   |>;

failed = Keys@Select[checks, ! TrueQ[#] &];
Print[<|"passed" -> Count[Values[checks], True], "total" -> Length[checks], "failed" -> failed|>];
If[failed =!= {}, Exit[1]];
