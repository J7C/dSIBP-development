(* Mixed massive/massless example: topology, public relations and canonical batch. *)

exampleDir = DirectoryName[$InputFileName];
packageDir = DirectoryName[exampleDir];
Get[FileNameJoin[{packageDir, "package_012.wl"}]];

case = <|
   "name" -> "mixedBubbleExample",
   "vertexData" -> {{v1, "+"}, {v2, "+"}},
   "lineData" -> {
     <|"id" -> e1, "endpoints" -> {v1, v2}, "momentum" -> q,
       "nu" -> nuM, "bbType" -> "h", "massType" -> "massive"|>,
     <|"id" -> e2, "endpoints" -> {v1, v2}, "momentum" -> q - k,
       "nu" -> 0, "bbType" -> "exp", "massType" -> "massless"|>
     },
   "loopMomenta" -> {q},
   "externalMomenta" -> {k},
   "externalInvariantRules" -> {sp[k, k] -> s11},
   "vertexEnergies" -> <|v1 -> E1, v2 -> E2|>,
   "ispData" -> {},
   "zeroPointRules" -> {
     a0[v1] -> alpha1, a0[v2] -> alpha2,
     b0[e1] -> beta1, b0[e2] -> beta2
     },
   "symmetryRules" -> {},
   "seedPreset" -> "quickCheck"
   |>;

topo = parseTopology[case];
If[topo === $Failed, Exit[1]];

base = makeBaseIntegral[topo];
seedRules = {
   a[v1] -> 0, a[v2] -> 0,
   b[e1] -> 0, b[e2] -> 0,
   n[e1, 1] -> 0, n[e1, 2] -> 1, n[e2] -> 0
   };
int = base /. seedRules;

timeRelation = dtau[v1, int, topo];
qqRelation = dqq[q, q, int, topo];
qkRelation = dqk[q, k, int, topo];

batch = makeCanonicalSeedBatch[
   topo,
   DiscreteMode -> "all",
   GenerateShrinkSectors -> True,
   MaxEquationCount -> 500
   ];
linearData = makeLinearSystemData[batch, topo];

Print[<|
  "topologyStatus" -> topologyValidationReport[topo]["status"],
  "baseIntegral" -> base,
  "timeRelation" -> timeRelation,
  "qqRelation" -> qqRelation,
  "qkRelation" -> qkRelation,
  "batchStatus" -> batch["status"],
  "equationCount" -> Lookup[batch, "equationCount", Missing[]],
  "linearStatus" -> Lookup[linearData, "status", Missing[]]
|>];
