(* ::Package:: *)
(* 文件用途：验证无向多重图第一 Betti 数在普通单边、自环 tadpole 和三平行边 sunrise 上的实现。
   本脚本只初始化三个最小 topology，不生成 seeds、linearData 或 reduction。 *)


(* ::Chapter:: *)
(*加载开发包*)

projectRoot = DirectoryName[DirectoryName[DirectoryName[$InputFileName]]];
packageDir = FileNameJoin[{projectRoot, "000_code", "018_dSIBP"}];
$Path = Prepend[$Path, packageDir];
Needs["dSIBP`"];
DSMessagesOff[];


(* ::Chapter:: *)
(*三个限定 topology*)

singleEdgeCase = <|
   "name" -> "CheckOrdinarySingleEdge",
   "vertexData" -> {{v1, "+"}, {v2, "+"}},
   "lineData" -> {
     <|"id" -> 1, "endpoints" -> {v1, v2}, "momentum" -> p,
       "massType" -> "massive", "bbType" -> "h", "nu" -> nu|>
     },
   "loopMomenta" -> {},
   "loopExternalMomenta" -> {},
   "independentExternalMomenta" -> {p},
   "ibpMode" -> Automatic,
   "vertexEnergies" -> <|v1 -> E1, v2 -> E2|>,
   "ispData" -> {},
   "zeroPointRules" -> {a0[v1] -> 2 nu, a0[v2] -> 2 nu, b0[1] -> -2 nu},
   "symmetryRules" -> {}
   |>;

tadpoleCase = <|
   "name" -> "CheckSelfLoopTadpole",
   "vertexData" -> {{v1, "+"}},
   "lineData" -> {
     <|"id" -> 1, "endpoints" -> {v1, v1}, "momentum" -> q,
       "massType" -> "massive", "bbType" -> "h", "nu" -> nu|>
     },
   "loopMomenta" -> {q},
   "loopExternalMomenta" -> {},
   "independentExternalMomenta" -> {},
   "ibpMode" -> "full",
   "vertexEnergies" -> <|v1 -> E1|>,
   "ispData" -> {},
   "zeroPointRules" -> {a0[v1] -> 2 nu, b0[1] -> -2 nu},
   "symmetryRules" -> {}
   |>;

sunriseCase = <|
   "name" -> "CheckThreeParallelEdgeSunrise",
   "vertexData" -> {{v1, "+"}, {v2, "+"}},
   "lineData" -> {
     <|"id" -> 1, "endpoints" -> {v1, v2}, "momentum" -> q1,
       "massType" -> "massive", "bbType" -> "h", "nu" -> nu|>,
     <|"id" -> 2, "endpoints" -> {v1, v2}, "momentum" -> q2,
       "massType" -> "massless", "bbType" -> "exp", "nu" -> 0|>,
     <|"id" -> 3, "endpoints" -> {v1, v2}, "momentum" -> q1 - q2 - k,
       "massType" -> "massless", "bbType" -> "exp", "nu" -> 0|>
     },
   "loopMomenta" -> {q1, q2},
   "loopExternalMomenta" -> {k},
   "independentExternalMomenta" -> {},
   "ibpMode" -> "full",
   "vertexEnergies" -> <|v1 -> E1, v2 -> E2|>,
   "ispData" -> {
     <|"name" -> rho1, "expr" -> sp[q1, k], "range" -> {0, 1}|>,
     <|"name" -> rho2, "expr" -> sp[q2, k], "range" -> {0, 1}|>
     },
   "zeroPointRules" -> {
     a0[v1] -> alpha1, a0[v2] -> alpha2,
     b0[1] -> beta1, b0[2] -> beta2, b0[3] -> beta3
     },
   "symmetryRules" -> {}
   |>;

singleEdgeContext = DSInit[singleEdgeCase, RegisterAsCurrent -> False, ProgressReporting -> False];
tadpoleContext = DSInit[tadpoleCase, RegisterAsCurrent -> False, ProgressReporting -> False];
sunriseContext = DSInit[sunriseCase, RegisterAsCurrent -> False, ProgressReporting -> False];

singleEdgeTopology = Lookup[singleEdgeContext, "topology", <||>];
tadpoleTopology = Lookup[tadpoleContext, "topology", <||>];
sunriseTopology = Lookup[sunriseContext, "topology", <||>];


(* ::Chapter:: *)
(*验收*)

checks = <|
   "allInitialized" -> And @@
    (Lookup[#, "status", "failed"] === "initialized" & /@
      {singleEdgeContext, tadpoleContext, sunriseContext}),
   "ordinarySingleEdgeIsTree" ->
    (Lookup[singleEdgeTopology, "graphLoopCount", Missing[]] === 0 &&
      Lookup[singleEdgeTopology, "bridgeLineIndices", {}] === {1} &&
      Lookup[singleEdgeTopology, "cycleLineIndices", {}] === {}),
   "tadpoleIsOneSelfLoop" ->
    (Lookup[tadpoleTopology, "graphLoopCount", Missing[]] === 1 &&
      Lookup[tadpoleTopology, "selfLoopLineIndices", {}] === {1} &&
      Lookup[tadpoleTopology, "cycleLineIndices", {}] === {1} &&
      Lookup[tadpoleTopology, "bridgeLineIndices", {}] === {}),
   "tadpoleRoutingRank" ->
    (Lookup[Lookup[tadpoleTopology, "loopMomentumRoutingAudit", <||>],
       "loopCoefficientRank", Missing[]] === 1),
   "tadpoleIncidenceColumnIsZero" ->
    (Lookup[Lookup[tadpoleTopology, "graphTopologyAudit", <||>],
       "incidenceMatrix", Missing[]] === {{0}}),
   "sunriseHasTwoLoops" ->
    (Lookup[sunriseTopology, "graphLoopCount", Missing[]] === 2 &&
      Lookup[sunriseTopology, "cycleLineIndices", {}] === {1, 2, 3} &&
      Lookup[sunriseTopology, "bridgeLineIndices", {}] === {} &&
      Lookup[sunriseTopology, "selfLoopLineIndices", {}] === {}),
   "sunriseRoutingRank" ->
    (Lookup[Lookup[sunriseTopology, "loopMomentumRoutingAudit", <||>],
       "loopCoefficientRank", Missing[]] === 2)
   |>;

failed = Keys@Select[checks, Not@TrueQ[#] &];
Print[InputForm[<|
   "passed" -> Count[Values[checks], True],
   "total" -> Length[checks],
   "failed" -> failed,
   "checks" -> checks
   |>]];
Exit[If[failed === {}, 0, 1]];
