(* ::Package:: *)
(* 文件用途：检查同分支 massive line 的原始 theta contact 与 child normalization。
   本检查覆盖 ++/--、两个端点、10/01 状态和 general/pure-time 两条 producer；
   expected 直接使用 endpoint orientation 与 contour sign，不读取 package 生成的参考矩阵。 *)


(* ::Chapter:: *)
(*加载当前开发包*)

Get[FileNameJoin[{DirectoryName[$InputFileName], "..", "_harness.wls"}]];
projectRoot = DirectoryName[DirectoryName[DirectoryName[$InputFileName]]];
dsSmokeLoadPackage[
  FileNameJoin[{projectRoot, "versions", "023_dSIBP", "Kernel", "dSIBP.wl"}]
  ];
DSMessagesOff[];


(* ::Chapter:: *)
(*单条 massive line 的原始与 pure-time contact*)

(* 每个分支单独初始化；generic ep 避免时间-IBP 的整数端点门禁干扰 contact 专项。 *)
makeContactContext[vertexType_String] := DSInit[
   <|
    "name" -> ("MassiveContact" <> vertexType),
    "vertices" -> {
      <|"id" -> v1, "vertexType" -> vertexType, "externalLegEnergy" -> E1|>,
      <|"id" -> v2, "vertexType" -> vertexType, "externalLegEnergy" -> E2|>
      },
    "lines" -> {
      <|"id" -> 1, "massType" -> "massive", "endpoints" -> {v1, v2},
        "momentum" -> p12, "nu" -> nu1|>
      },
    "loopMomenta" -> {},
    "loopExternalMomenta" -> {},
    "independentExternalMomenta" -> {p12},
    "ibpMode" -> "timeOnly",
    "ispData" -> {},
    "zeroPointRules" -> {
      a0[v1] -> 2 nu1 + ep, a0[v2] -> 2 nu1 + ep, b0[1] -> -2 nu1
      },
    "symmetryRules" -> {}
    |>,
   RegisterAsCurrent -> False,
   ProgressReporting -> False
   ];


(* 返回一个 branch/state/endpoint 的 raw 系数、pure-time 系数与归一化比值。
   n1+n2=1 时 endpointOrientation (n2-n1) 等价于端点处的离散态符号。 *)
contactRecord[vertexType_String, state_List, endpointSlot_Integer] := Module[
   {context, topo, line, contourSign, endpointOrientation, expectedStateSign,
    baseIntegral, loopIntegral, rawChoices, rawCoefficient, wronskianCoefficient,
    childNormalization, familyContext, topFamily, treeIntegral, treeChoices,
    treeCoefficient},
   context = makeContactContext[vertexType];
   topo = context["topology"];
   line = First[topo["lines"]];
   contourSign = If[vertexType === "+", 1, -1];
   endpointOrientation = If[endpointSlot === 1, 1, -1];
   expectedStateSign = -endpointOrientation (state[[2]] - state[[1]]);

   baseIntegral = dSIBP`Private`makeBaseIntegral[topo];
   loopIntegral = baseIntegral /. {
      n[1, 1] -> state[[1]], n[1, 2] -> state[[2]]
      };
   rawChoices = dSIBP`Private`thetaBoundaryAtomicTerms[
     topo, loopIntegral, 1, {v1, v2}[[endpointSlot]]
     ];
   rawCoefficient = First@Lookup[rawChoices, "coefficient", {}];
   wronskianCoefficient = First@Select[
      Expand@Lookup[dSIBP`Private`lineCompiledShrinkTerms[line], "coefficient", {}],
      ! TrueQ[# === 0] &
      ];
   childNormalization = dSIBP`Private`lineShrinkNormalizationFactor018[topo, 1];

   familyContext = dSIBP`Private`dsTreeFamilyContext[context];
   topFamily = familyContext["topFamily"];
   treeIntegral = J[{{0, state[[1]]}, {0, state[[2]]}}];
   treeChoices = dSIBP`Private`dsDirectTreeAtomicContactChoices[
     {v1, v2}[[endpointSlot]], treeIntegral, topFamily, 1
     ];
   treeCoefficient = First@Lookup[treeChoices, "coefficient", {}];

   <|
    "vertexType" -> vertexType,
    "state" -> state,
    "endpointSlot" -> endpointSlot,
    "contourSign" -> contourSign,
    "expectedStateSign" -> expectedStateSign,
    "wronskianCoefficient" -> wronskianCoefficient,
    "rawCoefficient" -> rawCoefficient,
    "treeCoefficient" -> treeCoefficient,
    "childNormalization" -> childNormalization,
    "rawRatio" -> FullSimplify[rawCoefficient/wronskianCoefficient],
    "treeRatio" -> FullSimplify[treeCoefficient/wronskianCoefficient],
    "normalizationRatio" -> FullSimplify[childNormalization/wronskianCoefficient],
    "normalizedContactRatio" -> FullSimplify[rawCoefficient/childNormalization]
    |>
   ];


records = Flatten@Table[
    contactRecord[vertexType, state, endpointSlot],
    {vertexType, {"+", "-"}},
    {state, {{1, 0}, {0, 1}}},
    {endpointSlot, {1, 2}}
    ];


(* ::Chapter:: *)
(*验收*)

checks = <|
   "allContextsInitialized" -> AllTrue[
     DeleteDuplicates[makeContactContext /@ {"+", "-"}],
     Lookup[#, "status", "failed"] === "initialized" &
     ],
   "rawContactUsesContourEndpointAndWronskianOrderSigns" -> AllTrue[
     records,
     TrueQ[FullSimplify[
         #rawRatio - #contourSign #expectedStateSign
         ] === 0] &
     ],
   "pureTimeMatchesGeneralRawContact" -> AllTrue[
     records,
     TrueQ[FullSimplify[#treeRatio - #rawRatio] === 0] &
     ],
   "childNormalizationAbsorbsPhysicalWronskian" -> AllTrue[
     records,
     TrueQ[FullSimplify[#normalizationRatio + #contourSign] === 0] &
     ],
   "normalizedContactUsesPhysicalWronskianOrder" -> AllTrue[
     records,
     TrueQ[FullSimplify[
         #normalizedContactRatio + #expectedStateSign
         ] === 0] &
     ],
   "allEightCasesCovered" -> (Length[records] === 8)
   |>;

dsSmokeSummary[
  checks,
  "check_massive_contact_convention",
  <|"records" -> records|>
  ];
