(* ::Package:: *)
(* 本文件定向检查 dSIBP 的时间-IBP 小 t 整数端点门禁。它只构造最小 timeOnly
   family，不生成大规模 seed、不调用 Kira，也不读取独立检验 expected。 *)


(* ::Chapter:: *)
(*加载模块包*)

checkDirectory = DirectoryName[$InputFileName];
Get[FileNameJoin[{checkDirectory, "..", "_harness.wls"}]];
packageFile = FileNameJoin[{
    checkDirectory, "..", "..", "versions", "023_dSIBP", "Kernel", "dSIBP.wl"
    }] // ExpandFileName;
dsSmokeLoadPackage[packageFile];


(* ::Chapter:: *)
(*最小无质量 family*)

masslessCase[zeroPointRules_] := <|
   "name" -> "time_ibp_domain_massless",
   "vertices" -> {
     <|"id" -> 1, "vertexType" -> "+", "externalLegEnergy" -> E1|>,
     <|"id" -> 2, "vertexType" -> "+", "externalLegEnergy" -> E2|>
     },
   "lines" -> {
     <|"id" -> 1, "massType" -> "massless", "endpoints" -> {1, 2}, "momentum" -> k|>
     },
   "loopMomenta" -> {},
   "loopExternalMomenta" -> {},
   "independentExternalMomenta" -> {k},
   "ibpMode" -> "timeOnly",
   "zeroPointRules" -> zeroPointRules,
   "symmetryRules" -> {}
   |>;

integerContext = DSInit[
   masslessCase[{a0[1] -> 0, a0[2] -> 1}],
   RegisterAsCurrent -> False,
   ProgressReporting -> False
   ];
regulatedContext = DSInit[
   masslessCase[{a0[1] -> ep, a0[2] -> 2 ep}],
   RegisterAsCurrent -> False,
   ProgressReporting -> False
   ];


(* ::Chapter:: *)
(*h 的 state 与两支领头幂次*)

massiveCase = <|
   "name" -> "time_ibp_domain_massive_h",
   "vertices" -> {
     <|"id" -> 7, "vertexType" -> "+", "externalLegEnergy" -> P1|>,
     <|"id" -> 8, "vertexType" -> "+", "externalLegEnergy" -> P2|>
     },
   "lines" -> {
     <|
      "id" -> 1,
      "massType" -> "massive",
      "endpoints" -> {7, 8},
      "momentum" -> q,
      "nu" -> nuM,
      "functionSystem" -> "h"
      |>
     },
   "loopMomenta" -> {},
   "loopExternalMomenta" -> {},
   "independentExternalMomenta" -> {q},
   "ibpMode" -> "timeOnly",
   "zeroPointRules" -> {a0[7] -> 2 nuM - 1, a0[8] -> ep},
   "symmetryRules" -> {}
   |>;

massiveContext = DSInit[
   massiveCase,
   RegisterAsCurrent -> False,
   ProgressReporting -> False
   ];
massiveCertificate = Lookup[massiveContext, "timeIBPDomainCertificate", <||>];
massiveIssues = Lookup[massiveCertificate, "integerIssues", {}];
massiveRootVertexIssue = SelectFirst[
   massiveIssues,
   Lookup[#, "sectorKey", None] === "1" && Lookup[#, "vertexIds", {}] === {7} &,
   Missing["RootVertexIssue"]
   ];


(* ::Chapter:: *)
(*检查摘要*)

checks = <|
   "zeroAndPositiveIntegerRejected" ->
    Lookup[integerContext, "status", None] === "failed" &&
     Lookup[integerContext, "reason", None] === "timeIBPRequiresRegularization",
   "integerFailureDisablesCapabilities" ->
    ! Or @@ Values[Lookup[integerContext, "capabilities", <||>]],
   "genericRegulatorAccepted" -> Lookup[regulatedContext, "status", None] === "initialized",
   "genericRegulatorCertified" ->
    Lookup[Lookup[regulatedContext, "timeIBPDomainCertificate", <||>], "status", None] === "certified",
   "massiveHIntegerBranchRejected" ->
    Lookup[massiveContext, "reason", None] === "timeIBPRequiresRegularization",
   "massiveHReportsOriginalVertex" -> AssociationQ[massiveRootVertexIssue],
   "massiveHEnumeratesStateAndBranch" ->
    AssociationQ[massiveRootVertexIssue] &&
     Lookup[massiveRootVertexIssue, "branchCount", 0] === 4 &&
     Sort@DeleteDuplicates[
       Lookup[Flatten@Lookup[massiveRootVertexIssue["branchRecords"], "localChoices", {}], "state", {}]
       ] === {0, 1}
   |>;

Print["dSIBP time-IBP domain checks: ", Count[Values[checks], True], "/", Length[checks]];
Print["failed: ", InputForm[Keys@Select[checks, Not]]];

If[! And @@ Values[checks],
 Print["integer context: ", InputForm[integerContext]];
 Print["regulated context: ", InputForm[regulatedContext]];
 Print["massive context: ", InputForm[massiveContext]];
 Exit[1]
 ];
