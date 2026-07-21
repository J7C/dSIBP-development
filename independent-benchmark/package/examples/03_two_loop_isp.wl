(* Two-loop example: arbitrary momentum names, two ISPs and all generators. *)

exampleDir = DirectoryName[$InputFileName];
packageDir = DirectoryName[exampleDir];
Get[FileNameJoin[{packageDir, "package_012.wl"}]];

case = <|
   "name" -> "twoLoopISPExample",
   "vertexData" -> {{v1, "+"}, {v2, "+"}},
   "lineData" -> {
     <|"id" -> e1, "endpoints" -> {v1, v2}, "momentum" -> l3,
       "massType" -> "massless", "bbType" -> "exp", "nu" -> 0|>,
     <|"id" -> e2, "endpoints" -> {v1, v2}, "momentum" -> k321,
       "massType" -> "massless", "bbType" -> "exp", "nu" -> 0|>,
     <|"id" -> e3, "endpoints" -> {v1, v2},
       "momentum" -> l3 - k321 - wdnmd,
       "massType" -> "massless", "bbType" -> "exp", "nu" -> 0|>
     },
   "loopMomenta" -> {l3, k321},
   "externalMomenta" -> {wdnmd},
   "externalInvariantRules" -> {sp[wdnmd, wdnmd] -> s11},
   "vertexEnergies" -> <|v1 -> E1, v2 -> E2|>,
   "ispData" -> {
     <|"name" -> rhoK321L3, "expr" -> sp[k321, l3], "range" -> {0, 1}|>,
     <|"name" -> rhoL3Wdnmd, "expr" -> sp[l3, wdnmd], "range" -> {0, 1}|>
     },
   "zeroPointRules" -> {
     a0[v1] -> alpha1, a0[v2] -> alpha2,
     b0[e1] -> beta1, b0[e2] -> beta2, b0[e3] -> beta3
     },
   "symmetryRules" -> {},
   "seedPreset" -> "quickCheck"
   |>;

topo = parseTopology[case];
If[topo === $Failed, Exit[1]];

base = makeBaseIntegral[topo];
int = base /. {
   a[v1] -> 0, a[v2] -> 0,
   b[e1] -> 0, b[e2] -> 0, b[e3] -> 0,
   n[e1] -> 0, n[e2] -> 1, n[e3] -> 0,
   ispN[1] -> 1, ispN[2] -> 0
   };
generators = makeIBPGenerators[topo];
generatorLabels = (
    If[#1["type"] === "time", timeGeneratorLabel[#1], momentumGeneratorLabel[#1]] &
    /@ generators
    );
relation = dqq[l3, k321, int, topo];

Print[<|
  "topologyStatus" -> topologyValidationReport[topo]["status"],
  "generatorCount" -> Length[generators],
  "generatorLabels" -> generatorLabels,
  "baseIntegral" -> base,
  "crossLoopRelation" -> relation
|>];
