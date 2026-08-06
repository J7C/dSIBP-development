(* ::Package:: *)
(* 验证 linearData["integralList"] 是 plan/export 前唯一的积分编号顺序来源。 *)

(* ::Chapter:: *)
(*加载模块化 package*)

Get[FileNameJoin[{DirectoryName[$InputFileName], "..", "_harness.wls"}]];
projectRoot = ExpandFileName@FileNameJoin[{DirectoryName[$InputFileName], "..", ".."}];
dsSmokeLoadPackage[FileNameJoin[{projectRoot, "versions", "018_dSIBP", "Kernel", "dSIBP.wl"}]];
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

failed = Keys@Select[checks, Not@TrueQ[#] &];
Print["check_integral_order_authority: ", Count[Values[checks], True], "/", Length[checks]];
Print["failed: ", InputForm[failed]];
Print[InputForm[<|"passed" -> Count[Values[checks], True], "total" -> Length[checks], "failed" -> failed,"checks" -> checks|>]];
If[Count[Values[checks], True] =!= Length[checks], Exit[1]];
