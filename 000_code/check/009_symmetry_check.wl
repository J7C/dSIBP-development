(* ::Package:: *)
(* 008：用户 symmetryRules、sp Orderless 与 massive Vpm 的极小回归。 *)

(* ::Chapter:: *)
(*初始化*)

Get[FileNameJoin[{DirectoryName[$InputFileName], "..", "009_dS_ibp_general.wl"}]];

swapRule = HoldPattern[
     J[{x_, y_}, {pack1_, pack2_}, isp_List]
     ] :> J[{y, x}, {pack2, pack1}, isp];

symmetricBubbleCase = Join[
   bubbleMassiveCase,
   <|
    "name" -> "symmetricMassiveBubbleInput",
    "lineData" -> {
      <|"id" -> 1, "endpoints" -> {1, 2}, "momentum" -> q1,
        "nu" -> nuM, "bbType" -> "h", "massType" -> "massive"|>,
      <|"id" -> 2, "endpoints" -> {1, 2}, "momentum" -> q1 - k,
        "nu" -> nuM, "bbType" -> "h", "massType" -> "massive"|>
      },
    "vertexEnergies" -> <|1 -> E0, 2 -> E0|>,
    "symmetryRules" -> {swapRule}
    |>
   ];

symmetricTopo = parseTopology[symmetricBubbleCase];
emptySymmetryTopo = parseTopology[bubbleMassiveCase];
shrunkSymmetryTopo = shrinkSectorTopology[symmetricTopo, {1}];

int1 = J[{a1, a2}, {{b1, n11, n12}, {b2, n21, n22}}, {}];
int2 = J[{c1, c2}, {{d1, m11, m12}, {d2, m21, m22}}, {}];
swappedInt1 = J[{a2, a1}, {{b2, n21, n22}, {b1, n11, n12}}, {}];
swappedInt2 = J[{c2, c1}, {{d2, m21, m22}, {d1, m11, m12}}, {}];

badSymmetryCase = Join[
   bubbleMassiveCase,
   <|"name" -> "badSymmetryInput", "symmetryRules" -> {42}|>
   ];
badSymmetryReport = caseInputErrorReport[badSymmetryCase];
badSymmetryCodes = Lookup[Lookup[badSymmetryReport, "issues", {}], "code", {}];

makeOneMassiveCase[sign_String, offset_: Automatic] := <|
   "name" -> "oneMassive" <> sign,
   "vertexData" -> {{v1, StringTake[sign, {1}]}, {v2, StringTake[sign, {2}]}},
   "lineData" -> {
     <|"id" -> 1, "endpoints" -> {v1, v2}, "momentum" -> ell,
       "nu" -> nuM, "bbType" -> "h", "massType" -> "massive"|>
     },
   "loopMomenta" -> {ell},
   "externalMomenta" -> {},
   "thetaBoundarySignOffset" -> offset
   |>;

ppTopo = parseTopology[makeOneMassiveCase["++"]];
mmTopo = parseTopology[makeOneMassiveCase["--"]];
ppOverrideTopo = parseTopology[makeOneMassiveCase["++", 0]];

(* ::Chapter:: *)
(*检查*)

checks = <|
   "spImplementedWithOrderless" -> MemberQ[Attributes[sp], Orderless],
   "spCanonicalExchange" -> SameQ[sp[q1, k], sp[k, q1]],
   "symmetryRulesStored" -> SameQ[repSymmetry0[symmetricTopo], {swapRule}],
   "symmetrySingleApplication" ->
     SameQ[symmetry[int1, symmetricTopo], swappedInt1],
   "symmetryLinearApplication" ->
     SameQ[
      Expand[symmetry[2 int1 + 3 int2, symmetricTopo]],
      Expand[2 swappedInt1 + 3 swappedInt2]
      ],
   "emptySymmetryIsIdentity" ->
     SameQ[repSymmetry0[emptySymmetryTopo], {}] &&
      SameQ[symmetry[int1, emptySymmetryTopo], int1],
   "malformedSymmetryRejectedByPreflight" ->
     MemberQ[badSymmetryCodes, "malformedSymmetryRules"],
   "shrinkSectorInheritsUserRules" ->
     SameQ[repSymmetry0[shrunkSymmetryTopo], {swapRule}],
   "massivePPDefaultVpm" ->
     SameQ[thetaBoundarySignOffset[ppTopo, 1], 1],
   "massiveMMDefaultVpm" ->
     SameQ[thetaBoundarySignOffset[mmTopo, 1], 0],
   "explicitOffsetOverridesDefault" ->
     SameQ[thetaBoundarySignOffset[ppOverrideTopo, 1], 0]
   |>;

Scan[Function[key, Print[key, ": ", checks[key]]], Keys[checks]];
Print["009 symmetry/Vpm checks: ", Count[Values[checks], True], "/", Length[checks]];

If[! And @@ Values[checks], Exit[1]];
