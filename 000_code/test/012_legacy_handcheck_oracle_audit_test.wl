(* ::Package:: *)

testDir = DirectoryName[$InputFileName];
codeDir = DirectoryName[testDir];
legacyHandDir = FileNameJoin[{codeDir, "check", "hand-derived-v2"}];

Get[FileNameJoin[{codeDir, "011_dS_ibp_general.wl"}]];
Get[FileNameJoin[{legacyHandDir, "atomic_massless_line", "family.wl"}]];
Get[FileNameJoin[{legacyHandDir, "atomic_massless_line", "expected.wl"}]];

legacyTopo = parseTopology[makeAtomicMasslessCase["++"]];
legacySeed = makeBaseIntegral[legacyTopo] /. {
    a[v1] -> 0, a[v2] -> 0, b[1] -> 0, n[1] -> 1
    };
legacyActual = dtau[v1, legacySeed, legacyTopo];
legacyExpected = SelectFirst[
    expectedRelations,
    #1["sector"] === "top" && #1["vertexSigns"] === "++" &&
      #1["generator"] === {"time", v1} && MemberQ[#1["seedRules"], n[1] -> 1] &
    ]["equation"];

legacyHelperText = Import[
   FileNameJoin[{legacyHandDir, "_manual_ibp_engine.wl"}], "Text",
   CharacterEncoding -> "UTF-8"
   ];

checks = <|
   "legacy package and legacy expected agree" -> (Expand[legacyActual - legacyExpected] === 0),
   "legacy agreement contains the wrong massless a=-1 contact" ->
    ! FreeQ[legacyActual, J[{-1}, {{0}}, {}]],
   "legacy helper enumerates the full powerset" ->
    StringContainsQ[legacyHelperText, "Subsets[manualFullLines[def, signKey]]"],
   "legacy helper applies the same minus-one shift to every shrink" ->
    StringContainsQ[legacyHelperText, "Total[aList[[oldSlots]]] - 1"],
   "legacy helper generates theta boundaries line by line" ->
    StringContainsQ[legacyHelperText, "manualTimeLineTerms"] &&
     StringContainsQ[legacyHelperText, "manualMassiveBoundary"] &&
     StringContainsQ[legacyHelperText, "manualMasslessTimeTerms"]
   |>;

Get[FileNameJoin[{codeDir, "012_dS_ibp_general.wl"}]];
currentTopo = parseTopology[makeAtomicMasslessCase["++"]];
currentSeed = makeBaseIntegral[currentTopo] /. {
    a[v1] -> 0, a[v2] -> 0, b[1] -> 0, n[1] -> 1
    };
currentActual = dtau[v1, currentSeed, currentTopo];
AssociateTo[checks,
 "012 replaces the shared wrong oracle result by a=0" ->
  (! FreeQ[currentActual, J[{0}, {{0}}, {}]] &&
    FreeQ[currentActual, J[{-1}, {{0}}, {}]])
 ];

failed = Keys@Select[checks, Not];
Print["legacy hand-check oracle audit: ", Count[Values[checks], True], "/", Length[checks]];
If[failed =!= {}, Print["FAILED: ", failed]; Exit[1]];
Exit[0];
