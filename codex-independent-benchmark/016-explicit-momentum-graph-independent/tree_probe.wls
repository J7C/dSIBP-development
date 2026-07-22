(* ::Chapter:: *)
(*pure-time 返回结构探针*)

ClearAll["Global`*"];
workspace = DirectoryName[$InputFileName];
Get[FileNameJoin[{workspace, "..", "..", "independent-benchmark", "package", "package_016.wl"}]];
DSMessagesOff[];

treeCase = <|
  "name" -> "016IndependentTreeProbe",
  "vertexData" -> {{v1, "+"}, {v2, "+"}},
  "lineData" -> {<|"id" -> 1, "endpoints" -> {v1, v2}, "momentum" -> p12,
    "treeEnergy" -> k12, "nu" -> nu12, "bbType" -> "h", "massType" -> "massive"|>},
  "loopMomenta" -> {}, "loopExternalMomenta" -> {},
  "independentExternalMomenta" -> {p12}, "ibpMode" -> "timeOnly",
  "vertexEnergies" -> <|v1 -> E1, v2 -> E2|>, "ispData" -> {},
  "zeroPointRules" -> {a0[v1] -> alpha1, a0[v2] -> alpha2, b0[1] -> beta12},
  "shrinkPrefactorRules" -> {Exp[Pi Im[nu12]] -> eta12},
  "symmetryRules" -> {}, "seedPreset" -> "quickCheck"
|>;

context = DSInit[treeCase, RegisterAsCurrent -> False, ProgressReporting -> False];
integral = J[{{a1, 0}, {a2, 0}}];
seed = DSTreeSeeds[v1, integral, context];
Print["STATUS=" <> ToString[Lookup[context, "status", Missing[]], InputForm]];
Print["SEED_HEAD=" <> ToString[Head[seed], InputForm]];
Print["SEED_KEYS=" <> ToString[If[AssociationQ[seed], Keys[seed], {}], InputForm]];
Print["SEED=" <> ToString[seed, InputForm]];
reduction = repIterative[J[{{-1, 1}, {0, 0}}], {0, 0}, context];
Print["REDUCTION=" <> ToString[reduction, InputForm]];
dlog = DSTreeDLogDE[context];
Print["DLOG_SUMMARY=" <> ToString[KeyTake[dlog, {"status", "masters", "omega", "letters"}], InputForm]];
naive = DSTreeNaiveIBP[context, dlog["masters"], ProgressReporting -> False];
Print["NAIVE_KEYS=" <> ToString[Keys[naive], InputForm]];
Print["NAIVE_SUMMARY=" <> ToString[KeyTake[naive, {"status", "equationCount", "unknownCount", "rules", "solveResiduals", "unknowns"}], InputForm]];
Print["NAIVE_REDUCTIONS=" <> ToString[naive["reductions"], InputForm]];
