(* ::Package:: *)
(* 用途：验证 020 tree 公式与表示辅助入口只接受并返回原生 time-only J。 *)


(* ::Chapter:: *)
(*加载 020 开发版本*)

Get[FileNameJoin[{DirectoryName[$InputFileName], "..", "_harness.wls"}]];
projectRoot = ExpandFileName[FileNameJoin[{DirectoryName[$InputFileName], "..", ".."}]];
dsSmokeLoadPackage[FileNameJoin[{projectRoot, "versions", "020_dSIBP", "Kernel", "dSIBP.wl"}]];
DSMessagesOff[];


(* ::Chapter:: *)
(*两顶点 massive time-only family*)

treeInput = <|
   "name" -> "020TreeFormulaPublicRepresentation",
   "vertexData" -> {{v1, "+"}, {v2, "+"}},
   "lineData" -> {
     <|"id" -> 1, "endpoints" -> {v1, v2}, "momentum" -> p12,
       "treeEnergy" -> k12, "nu" -> nu12, "bbType" -> "h", "massType" -> "massive"|>
     },
   "loopMomenta" -> {},
   "loopExternalMomenta" -> {},
   "independentExternalMomenta" -> {p12},
   "ibpMode" -> "timeOnly",
   "vertexEnergies" -> <|v1 -> E1, v2 -> E2|>,
   "ispData" -> {},
   "zeroPointRules" -> {a0[v1] -> alpha1, a0[v2] -> alpha2, b0[1] -> beta12},
   "shrinkPrefactorRules" -> {Exp[Pi Im[nu12]] -> eta12},
   "symmetryRules" -> {},
   "seedPreset" -> "quickCheck"
   |>;

context = DSInit[
   treeInput,
   WriteInitializationFiles -> False,
   GenerateDerivativeMetadata -> False,
   RegisterAsCurrent -> True,
   ProgressReporting -> False
   ];

topIntegral = J["1", {1, 0}, {1, 0}];
seed = DSTreeSeeds[v1, topIntegral, context];
dlog = DSTreeDLogDE[context, AuditLevel -> "full"];
masters = Lookup[dlog, "masters", {}];
reduction = If[masters === {}, $Failed, repIterative[First[masters]["integral"], Automatic, context]];
naiveIBP = If[masters === {}, <||>, DSTreeNaiveIBP[context, masters, ProgressReporting -> False]];
naiveDE = If[
   Lookup[naiveIBP, "status", "failed"] === "solved",
   DSTreeNaiveDE[naiveIBP, {E1, E2, k12}, ProgressReporting -> False],
   <||>
   ];


(* ::Chapter:: *)
(*表示辅助入口与检查*)

innerExpression = rep2innerform[sp[p12, p12] topIntegral, context];
outerExpression = rep2outform[innerExpression, context];
integrand = rep2Integrand[topIntegral, context];
symmetricIntegral = symmetry[topIntegral, context["topology"]];

publicJQ[value_] := FreeQ[value, J[_List, _List, _List]] &&
   And @@ (MatchQ[#, J[_String, _List, _List]] & /@ DeleteDuplicates[Cases[value, _J, {0, Infinity}]]) ;

checks = <|
   "initialized" -> (Lookup[context, "status", "failed"] === "initialized"),
   "topAccepted" -> (outerExpression === sE1^2 topIntegral),
   "integrandExpanded" -> FreeQ[integrand, _J],
   "symmetryPreservesPublicJ" -> (symmetricIntegral === topIntegral),
   "seedGenerated" -> (Lookup[seed, "status", "failed"] === "generated"),
   "seedPublic" -> publicJQ[seed],
   "dlogGenerated" -> (Lookup[dlog, "status", "failed"] === "generated"),
   "dlogPublic" -> publicJQ[dlog],
   "dlogAudit" -> TrueQ[Lookup[Lookup[dlog, "publicRepresentationAudit", <||>], "passQ", False]],
   "reductionPublic" -> (AssociationQ[reduction] && publicJQ[reduction]),
   "naiveIBPSolved" -> (Lookup[naiveIBP, "status", "failed"] === "solved"),
   "naiveIBPPublic" -> publicJQ[naiveIBP],
   "naiveDEGenerated" -> (Lookup[naiveDE, "status", "failed"] === "generated"),
   "naiveDEPublic" -> publicJQ[naiveDE]
   |>;

failed = Keys@Select[checks, Not@TrueQ[#] &];
Print["check_time_only_tree_formula_020: ", Count[Values[checks], True], "/", Length[checks]];
Print["failed: ", InputForm[failed]];
Print[InputForm[<|"passed" -> Count[Values[checks], True], "total" -> Length[checks], "failed" -> failed,
    "masterCount" -> Length[masters],
    "topIntegral" -> topIntegral,
    "firstMaster" -> If[masters === {}, Missing["NoMaster"], First[masters]]
  "checks" -> checks|>]];
If[Count[Values[checks], True] =!= Length[checks], Exit[1]];
