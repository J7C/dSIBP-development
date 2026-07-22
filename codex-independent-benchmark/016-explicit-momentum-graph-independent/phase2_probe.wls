(* ::Chapter:: *)
(*016 package 公开 context 结构探针*)

ClearAll["Global`*"];
workspace = DirectoryName[$InputFileName];
packageFile = FileNameJoin[{workspace, "..", "..", "independent-benchmark", "package", "package_016.wl"}];
Get[packageFile];
DSMessagesOff[];

case = <|
  "name" -> "016IndependentBubbleBridgeProbe",
  "vertexData" -> {{v1, "+"}, {v2, "+"}, {v3, "+"}},
  "lineData" -> {
    <|"id" -> 1, "endpoints" -> {v1, v2}, "momentum" -> ell + arc, "nu" -> nu1, "bbType" -> "h", "massType" -> "massive"|>,
    <|"id" -> 2, "endpoints" -> {v2, v1}, "momentum" -> ell + arc + spur, "nu" -> nu2, "bbType" -> "h", "massType" -> "massive"|>,
    <|"id" -> 3, "endpoints" -> {v2, v3}, "momentum" -> wing1 + wing2, "treeEnergy" -> Sqrt[sp[wing1 + wing2, wing1 + wing2]], "nu" -> nu3, "bbType" -> "h", "massType" -> "massive"|>
  },
  "extLegs" -> {{leg1, v3, wing1}, {leg2, v3, wing2}},
  "loopMomenta" -> {ell},
  "loopExternalMomenta" -> {spur},
  "independentExternalMomenta" -> {wing1, wing2, wing1 + wing2},
  "ibpMode" -> "full",
  "vertexEnergies" -> <|v1 -> E1, v2 -> E2, v3 -> E3|>,
  "ispData" -> {},
  "zeroPointRules" -> {a0[v1] -> alpha1, a0[v2] -> alpha2, a0[v3] -> alpha3, b0[1] -> beta1, b0[2] -> beta2, b0[3] -> beta3},
  "symmetryRules" -> {}, "seedPreset" -> "quickCheck"
|>;

proposal = DSKinematics[case];
context = DSInit[case, RegisterAsCurrent -> False, ProgressReporting -> False];
topo = Lookup[context, "topology", <||>];
Print["VERSION=" <> ToString[$dSIBPVersion, InputForm]];
Print["PROPOSAL=" <> ToString[KeyTake[proposal, {"status", "graphTopologyAudit", "routingAudit", "momentumDeclarationAudit", "missingDirections", "missingMagnitudeSquares", "selectionTemplate"}], InputForm]];
Print["CONTEXT_STATUS=" <> ToString[Lookup[context, "status", Missing[]], InputForm]];
Print["VALIDATION=" <> ToString[Lookup[context, "validationReport", Missing[]], InputForm]];
Print["CONTEXT_KEYS=" <> ToString[Keys[context], InputForm]];
Print["TOPO_KEYS=" <> ToString[Keys[topo], InputForm]];
Print["GRAPH=" <> ToString[Lookup[topo, "graphTopologyAudit", Missing[]], InputForm]];
Print["ROUTING=" <> ToString[Lookup[topo, "routingAudit", Missing[]], InputForm]];
Print["DECLARATION=" <> ToString[Lookup[topo, "momentumDeclarationAudit", Missing[]], InputForm]];
Print["CAPABILITIES=" <> ToString[Lookup[topo, "capabilities", Missing[]], InputForm]];
Print["LINE_SCHEMAS=" <> ToString[Lookup[topo, "lineSchemas", Missing[]], InputForm]];
Print["NOTATION=" <> ToString[DSParameterNotation[context], InputForm]];
Print["SECTOR_KEYS=" <> ToString[Keys[First[Lookup[context, "sectors", {<||>}]]], InputForm]];
Print["SECTOR_SUMMARY=" <> ToString[KeyTake[#, {"sectorKey", "shrunkLines", "graphLoopCount", "cycleLineIndices", "bridgeLineIndices", "lineSchemas", "indexMaps"}] & /@ Lookup[context, "sectors", {}], InputForm]];
Print["SECTOR_METADATA=" <> ToString[Lookup[topo, "sectorMetadataList", {}], InputForm]];
testIntegral = J[{a1, a2, a3}, {{b1, 0, 0}, {b2, 0, 0}, {0, 0}}, {}];
Print["FIXED_DS00=" <> ToString[ds[testIntegral, sE3, topo], InputForm]];
Print["FIXED_DTAU00=" <> ToString[dtau[v3, testIntegral, topo], InputForm]];
overCase = Join[case, <|"name" -> "016ProbeOverLoop", "loopExternalMomenta" -> {spur, arc}|>];
overContext = Quiet[DSInit[overCase, RegisterAsCurrent -> False, ProgressReporting -> False]];
overCodes = DeleteDuplicates@Cases[Lookup[overContext, "validationReport", <||>], item_Association :> Lookup[item, "code", Nothing], Infinity];
Print["OVER_STATUS=" <> ToString[Lookup[overContext, "status", Missing[]], InputForm]];
Print["OVER_CODES=" <> ToString[overCodes, InputForm]];
mixedRules = {
  sp[spur, spur] -> (u + v)^2,
  sp[wing1, wing1] -> (u - v)^2,
  sp[wing2, wing2] -> (u + w)^2,
  sp[wing1 + wing2, wing1 + wing2] -> (u + z)^2
};
mixedContext = DSRedefineParameters[context, mixedRules, ProgressReporting -> False];
mixedTopo = Lookup[mixedContext, "topology", <||>];
mixedNotation = DSParameterNotation[mixedContext];
privateSeed = dSIBP`Private`applyUserKinematicDerivativeSeed[mixedTopo, testIntegral, u];
Print["MIXED_CAPABILITIES=" <> ToString[Lookup[mixedContext, "capabilities", Missing[]], InputForm]];
Print["MIXED_VARIABLES=" <> ToString[Lookup[mixedNotation, "selectedUserVariables", Missing[]], InputForm]];
Print["MIXED_PARAMETER_ORDER=" <> ToString[Lookup[Lookup[mixedTopo, "kinematicCoordinateAudit", <||>], "userParameterOrder", Missing[]], InputForm]];
Print["MIXED_PRIVATE_SEED_FAILED=" <> ToString[privateSeed === $Failed, InputForm]];
DSMessagesOn[];
mixedActual = ds[c[u] testIntegral, u, mixedContext];
Print["MIXED_DS_FAILED=" <> ToString[mixedActual === $Failed, InputForm]];
