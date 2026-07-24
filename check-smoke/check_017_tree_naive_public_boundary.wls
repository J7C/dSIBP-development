(* ::Package:: *)
(* 本脚本定向验证 017 tree naive 路线的公开三槽 master 到 Private vertex basis 映射。
   它只加载候选 package，不读取独立 benchmark expected，也不运行外部 reduction。 *)

(* ::Chapter:: *)
(*候选加载与两顶点 massive family*)

packageFile = Environment["DSIBP_PACKAGE_FILE"];
If[! StringQ[packageFile] || ! FileExistsQ[packageFile], Exit[2]];
Get[packageFile];

case = <|
   "name" -> "017TreeNaivePublicBoundary",
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
   "symmetryRules" -> {}
   |>;

context = DSInit[case, RegisterAsCurrent -> True, ProgressReporting -> False];
dlog = DSTreeDLogDE[context];
formulaMasters = dSIBP`Private`dsTreeMasterToFormula017[#, context] & /@ dlog["masters"];
familyContext = dSIBP`Private`dsTreeFamilyContext[context];
familyRecords = dSIBP`Private`dsTreeMasterFamilyRecords[formulaMasters, familyContext];


(* ::Chapter:: *)
(*Raw 与公开 naive 路线*)

Print["PUBLIC_MASTERS=", InputForm[dlog["masters"]]];
Print["FORMULA_MASTERS=", InputForm[formulaMasters]];
Print["FAMILY_RECORD_INTEGRALS=", InputForm[Lookup[Lookup[familyRecords, "master", {}], "integral", {}]]];

raw = dSIBP`Private`dsTreeNaiveIBPRaw017[context, formulaMasters, ProgressReporting -> False];
public = DSTreeNaiveIBP[context, dlog["masters"], ProgressReporting -> False];
selectedSeed = DSTreeSeeds[v1, J[{1, 0}, {{"F", 1, 0}}, {}], context];
Print["RAW_STATUS=", InputForm[Lookup[raw, {"status", "reason"}, Missing["raw"]]]];
Print["PUBLIC_STATUS=", InputForm[Lookup[public, {"status", "reason"}, Missing["public"]]]];
Print["SELECTED_SEED=", InputForm[selectedSeed]];
Print["PUBLIC_REDUCTION_SAMPLE=", InputForm[First[Lookup[public, "reductions", {}], Missing["none"]]]];
Print["FAMILY_VERTEX_DATA=", InputForm[
  ({Lookup[#, "sector"], Lookup[#, "vertexOrder"], Lookup[#, "vertices"]} &) /@
   familyContext["families"]
  ]];
Do[
 Print["MASTER_DERIVATIVE=", InputForm[{master["sectorKey"], variable,
    dSIBP`Private`dsTreeNaiveMasterDerivative[master, variable, familyContext, context]}]],
 {master, formulaMasters}, {variable, {E1, E2, k12}}
 ];

publicDE = DSTreeNaiveDE[public, {E1, E2, k12}, ProgressReporting -> False];
Print["PUBLIC_DE_STATUS=", InputForm[Lookup[publicDE, {"status", "reason"}, Missing["de"]]]];
Print["PUBLIC_DE_VARIABLE_STATUS=", InputForm[
  KeyValueMap[{#1, Lookup[#2, {"status", "reason", "residualObjects"}, Missing["record"]]} &,
   Lookup[publicDE, "variableData", <||>]]
  ]];

If[! And[
    FreeQ[{raw, public}, $Failed],
    Lookup[raw, "status", "failed"] === "solved",
    Lookup[public, "status", "failed"] === "solved",
    TrueQ[Lookup[Lookup[public, "publicRepresentationAudit", <||>], "passQ", False]]
    ], Exit[1]];
