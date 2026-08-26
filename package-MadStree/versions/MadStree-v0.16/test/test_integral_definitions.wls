(* ::Package:: *)

(***
File: test_integral_definitions.wls
Purpose: 检查 normalized master J_s(n;a) 与同指标裸积分 I_s(n;a) 的公开对应。
Scope: 覆盖 massive ++/-- contact normalization、非零 shift、massless quotient/RedundantH 与非法指标；不运行数值输运。
***)

(* ::Chapter:: *)
(*加载与两顶点 massive 输入*)

Get[FileNameJoin[{DirectoryName[$InputFileName], "_harness.wls"}]];
msTestLoadKernel[];

massiveContext = MSInitTree[<|
  "vertices" -> {
    <|"id" -> 1, "externalLegEnergy" -> k1, "timePower" -> a1, "vertexType" -> "+"|>,
    <|"id" -> 2, "externalLegEnergy" -> k2, "timePower" -> a2, "vertexType" -> "+"|>
  },
  "lines" -> {
    <|"type" -> "massive", "endpoints" -> {1, 2}, "momentum" -> ks, "nu" -> nu|>
  }
|>];
massiveMasters = MSMasterIntegrals[massiveContext];
topRecord = First@Select[massiveMasters, #["sectorKey"] === "1" &];
childRecord = First@Select[massiveMasters, #["sectorKey"] === "0" &];
childSector = First@Select[MSSectors[massiveContext], #["sectorKey"] === "0" &];
shiftedIntegral = MSIntegral["1", {1, -2}, {0, 1}];
shiftedDefinition = MSIntegralDefinition[shiftedIntegral, massiveContext];

minusMassiveContext = MSInitTree[<|
  "vertices" -> {
    <|"id" -> 1, "externalLegEnergy" -> k1, "timePower" -> a1, "vertexType" -> "-"|>,
    <|"id" -> 2, "externalLegEnergy" -> k2, "timePower" -> a2, "vertexType" -> "-"|>
  },
  "lines" -> {
    <|"type" -> "massive", "endpoints" -> {1, 2}, "momentum" -> 1, "nu" -> nu|>
  }
|>];
minusMassiveLine = First[minusMassiveContext["lines"]];
minusChildSector = First@Select[MSSectors[minusMassiveContext], #["sectorKey"] === "0" &];
minusChildRecord = First@Select[MSMasterIntegrals[minusMassiveContext], #["sectorKey"] === "0" &];


(* ::Chapter:: *)
(*massless 两种二态因子表示*)

masslessSpec = <|
  "vertices" -> {
    <|"id" -> 1, "externalLegEnergy" -> p1, "timePower" -> b1, "vertexType" -> "+"|>,
    <|"id" -> 2, "externalLegEnergy" -> p2, "timePower" -> b2, "vertexType" -> "+"|>
  },
  "lines" -> {
    <|"type" -> "massless", "endpoints" -> {1, 2}, "momentum" -> q, "nu" -> 1/2|>
  }
|>;
quotientContext = MSInitTree[masslessSpec];
redundantContext = MSInitTree[Join[
  masslessSpec,
  <|"lines" -> {Append[First[masslessSpec["lines"]], "masslessRepresentation" -> "RedundantH"]}|>
]];
quotientDefinition = MSIntegralDefinition[MSIntegral["1", {0, 0}, {1}], quotientContext];
redundantDefinition = MSIntegralDefinition[MSIntegral["1", {0, 0}, {1, 0}], redundantContext];


(* ::Chapter:: *)
(*精确验收*)

expectedTopDefinition = With[
  {normalized = topRecord["integral"], bare = topRecord["bareIntegral"]},
  HoldForm[normalized == bare]
];
expectedChildDefinition = With[
  {
    normalized = childRecord["integral"],
    bare = childRecord["bareIntegral"],
    coefficient = childSector["normalization"]
  },
  HoldForm[normalized == coefficient bare]
];
dlog = MSDLogDE[massiveContext];
childBlock = First@Select[dlog["sectorBlocks"], #["sectorKey"] === "0" &];

checks = <|
  "fiveMasters" -> Length[massiveMasters] === 5,
  "publicUsagePresent" -> StringQ[MSBareIntegral::usage] && StringQ[MSIntegralDefinition::usage],
  "masterOrderUnchanged" -> Lookup[massiveMasters, "integral"] === Lookup[massiveContext["masters"], "integral"],
  "masterDigestUnchanged" -> massiveContext["masterDigest"] === dlog["masterDigest"],
  "definitionFieldsPresent" -> And @@ (SubsetQ[Keys[#], {"bareIntegral", "normalization", "definition"}] & /@ massiveMasters),
  "topNormalizationOne" -> topRecord["normalization"] === 1,
  "topDefinitionJEqualsI" -> topRecord["definition"] === expectedTopDefinition,
  "childNormalizationSameAuthority" -> childRecord["normalization"] === childSector["normalization"],
  "plusPlusChildNormalization" -> Simplify[
    First[massiveContext["lines"]]["pinchNormalization"] /. ks -> 1
  ] === -(4 I/Pi),
  "minusMinusLineNormalization" -> minusMassiveLine["pinchNormalization"] === 4 I/Pi,
  "minusMinusSectorNormalization" -> minusChildSector["normalization"] === 4 I/Pi,
  "minusMinusMasterNormalization" -> minusChildRecord["normalization"] === 4 I/Pi,
  "childDefinitionExplicit" -> childRecord["definition"] === expectedChildDefinition,
  "shiftIndicesPreserved" -> (
    shiftedDefinition["bareIntegral"] === MSBareIntegral["1", {1, -2}, {0, 1}] &&
      shiftedDefinition["normalization"] === 1
  ),
  "quotientSharedStatePreserved" -> quotientDefinition["bareIntegral"] === MSBareIntegral["1", {0, 0}, {1}],
  "redundantEndpointStatesPreserved" -> redundantDefinition["bareIntegral"] === MSBareIntegral["1", {0, 0}, {1, 0}],
  "unknownSectorFails" -> Head[MSIntegralDefinition[MSIntegral["missing", {}, {}], massiveContext]] === Failure,
  "badShiftFails" -> Head[MSIntegralDefinition[MSIntegral["1", {0}, {0, 0}], massiveContext]] === Failure,
  "badStateFails" -> Head[MSIntegralDefinition[MSIntegral["1", {0, 0}, {0}], massiveContext]] === Failure,
  "nonIntegralFails" -> Head[MSIntegralDefinition[MSBareIntegral["1", {0, 0}, {0, 0}], massiveContext]] === Failure,
  "dlogGaugeSameAuthority" -> childBlock["normalizationGauge"] ===
    Log[childRecord["normalization"]] IdentityMatrix[childSector["masterCount"]]
|>;

msTestSummary[checks, "integral definitions"];
