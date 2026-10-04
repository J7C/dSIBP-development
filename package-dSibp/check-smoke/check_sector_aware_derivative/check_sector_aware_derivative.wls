(* ::Package:: *)
(* 文件用途：验证 full-loop active basis 对 lower-sector master 求导时只进行一次 sector 选择，
   并检查 compact 顶点槽越界和任意 Wolfram message 均会让导数构造 fail closed。 *)


(* ::Chapter:: *)
(*加载 023 模块化源码与 mixed bubble+tree topology*)

Get[FileNameJoin[{DirectoryName[$InputFileName], "..", "_harness.wls"}]];
projectRoot = DirectoryName[DirectoryName[DirectoryName[$InputFileName]]];
dsSmokeLoadPackage[FileNameJoin[{projectRoot, "versions", "023_dSIBP", "Kernel", "dSIBP.wl"}]];
DSMessagesOff[];

caseInput = <|
   "name" -> "CheckSectorAwareDerivative",
   "vertices" -> {
     <|"id" -> v1, "vertexType" -> "+", "externalLegEnergy" -> E1|>,
     <|"id" -> v2, "vertexType" -> "+", "externalLegEnergy" -> E2|>,
     <|"id" -> v3, "vertexType" -> "+", "externalLegEnergy" -> E3|>
     },
   "lines" -> {
     <|"id" -> 1, "endpoints" -> {v1, v2}, "momentum" -> l1,
       "massType" -> "massive", "nu" -> nu1|>,
     <|"id" -> 2, "endpoints" -> {v1, v2}, "momentum" -> l1 + k1 + k2,
       "massType" -> "massless"|>,
     <|"id" -> 3, "endpoints" -> {v2, v3}, "momentum" -> k1 + k2,
       "massType" -> "massless"|>
     },
   "extLegs" -> {
     {bubbleLeg, v1, k1 + k2},
     {treeLeg1, v3, k1},
     {treeLeg2, v3, k2}
     },
   "loopMomenta" -> {l1},
   "loopExternalMomenta" -> {k1 + k2},
   "independentExternalMomenta" -> {k1, k2},
   "ibpMode" -> "full",
   "ispData" -> {},
   "zeroPointRules" -> {
     a0[v1] -> alpha1, a0[v2] -> alpha2, a0[v3] -> alpha3,
     b0[1] -> -2 nu1, b0[2] -> 0, b0[3] -> 0
     },
   "symmetryRules" -> {}
   |>;

context = DSInit[
   caseInput,
   WriteInitializationFiles -> False,
   GenerateDerivativeMetadata -> True,
   RegisterAsCurrent -> False,
   ProgressReporting -> False,
   KinematicRules -> {
     sp[k1 + k2, k1 + k2] -> loopScale^2,
     sp[k1, k1] -> legScale1^2,
     sp[k2, k2] -> legScale2^2
     }
   ];


(* ::Chapter:: *)
(*Lower-sector E3 导数与 fail-closed 反例*)

lowerMaster = J[{0, 0}, {{0, 0, 0}, {0}, {"F", 0, 0}}, {}];
lowerTopology = dSIBP`Private`sectorTopologyForIntegral018[context["topology"], lowerMaster];

Block[{$MessageList = {}},
  lowerDerivative = dSIBP`Private`dsSectorAwareDerivative[
    lowerMaster,
    E3,
    <|"topology" -> context["topology"], "sectors" -> context["sectors"]|>
    ];
  lowerDerivativeMessages = $MessageList;
  ];

expectedLowerDerivative = I J[{0, 1}, {{0, 0, 0}, {0}, {"F", 0, 0}}, {}];
outOfRangeShift = dSIBP`Private`shiftVertexA[lowerMaster, context["topology"], v3, 1];

checkSectorAwareDerivative::probe = "This message is emitted only to verify the derivative fail-closed gate.";
messageCoefficient /: Derivative[1][messageCoefficient] =
  Function[x, Message[checkSectorAwareDerivative::probe]; 0];
messageFailureResult = Quiet@dSIBP`Private`dsSectorAwareDerivative[
    messageCoefficient[E3] lowerMaster,
    E3,
    <|"topology" -> context["topology"], "sectors" -> context["sectors"]|>
    ];
ClearAll[messageCoefficient];


(* ::Chapter:: *)
(*验收*)

checks = <|
   "initialized" -> (Lookup[context, "status", "failed"] === "initialized"),
   "lowerSectorShrunkOnce" -> (Lookup[lowerTopology, "sectorShrunkLines", {}] === {2}),
   "lowerSectorActiveVertices" -> (Lookup[lowerTopology, "activeVertexIds", {}] === {v1, v3}),
   "e3UsesCompactSlot2" -> (dSIBP`Private`vertexASlot[lowerTopology, v3] === 2),
   "lowerDerivativeHasNoMessages" -> (lowerDerivativeMessages === {}),
   "lowerDerivativeSucceeded" -> (lowerDerivative =!= $Failed),
   "lowerDerivativeExact" -> TrueQ[Expand[lowerDerivative - expectedLowerDerivative] === 0],
   "noRootSlotExpansion" -> FreeQ[lowerDerivative, J[a_List /; Length[a] =!= 2, _, _], Infinity],
   "outOfRangeShiftFails" -> (outOfRangeShift === $Failed),
   "messageFailsClosed" -> (messageFailureResult === $Failed)
   |>;

dsSmokeSummary[
  checks,
  "check_sector_aware_derivative",
  <|
   "lowerDerivative" -> lowerDerivative,
   "expectedLowerDerivative" -> expectedLowerDerivative,
   "lowerDerivativeMessages" -> lowerDerivativeMessages,
   "outOfRangeShift" -> outOfRangeShift,
   "messageFailureResult" -> messageFailureResult
   |>
  ];
