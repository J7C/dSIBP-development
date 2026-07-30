(* ::Package:: *)

(***
文件：Sectors.wl
用途：从共同-theta simultaneous contact 事件构造 sector DAG、全图 slot registry 与同序主积分。
关键约定：一个事件只产生一个 delta；多边事件同时收缩所选边并只合并一次顶点。
sector key 按 root propagator 输入顺序编码为定长字符串，0 表示收缩、1 表示未收缩。
***)

(* ::Chapter:: *)
(*Sector 与 component*)

(* 输入为完整 root line 表与 canonical contraction set。不可把结果转成整数，
   否则以已收缩传播子开头的 sector 会丢失前导零并破坏身份。 *)
msSectorKey[{}, contractedIds_List] := "";


msSectorKey[lines_List, contractedIds_List] := StringJoin[
  If[MemberQ[contractedIds, #], "0", "1"] & /@ Lookup[lines, "id"]
];


msSectorKeySchema[lines_List] := <|
  "type" -> "rootPropagatorBitString",
  "rootLineOrder" -> Lookup[lines, "id"],
  "width" -> Length[lines],
  "contractedBit" -> "0",
  "uncontractedBit" -> "1",
  "storageType" -> "String"
|>;

msComponentsForContractions[vertices_List, lines_List, contractedIds_List] := Module[
  {vertexIds, positions, contractedLines, graph, components},
  vertexIds = Lookup[vertices, "id"];
  positions = AssociationThread[vertexIds -> Range[Length[vertexIds]]];
  contractedLines = Select[lines, MemberQ[contractedIds, #["id"]] &];
  graph = Graph[
    vertexIds,
    If[contractedLines === {}, {}, UndirectedEdge @@@ Lookup[contractedLines, "endpoints"]]
  ];
  components = ConnectedComponents[graph];
  components = SortBy[SortBy[#, positions] & /@ components, Min[positions /@ #] &];
  components
];

msRootToComponent[components_List] := Association@Flatten@MapIndexed[
  Function[{component, index}, (# -> First[index]) & /@ component],
  components
];


msLinePositionAssociation[lines_List] := If[
  lines === {},
  <||>,
  AssociationThread[Lookup[lines, "id"] -> Lookup[lines, "position"]]
];


(* 每轮只允许连接两个不同当前 component 的 full line 触发 contact。当前端点相同的
   unselected bundle line 保留为 coincident line，由 sector quotient 处理。 *)
msReachableContactData[vertices_List, lines_List] := Module[
  {fullLines, linePositions, queue = {{}}, seen = <|ToString[{}, InputForm] -> True|>,
   states = {}, transitions = {}, state, components, rootToComponent, eligible, bundles,
   bundle, oddSubsets, selected, selectedIds, target, targetKey, sourceKey},
  fullLines = Select[lines, msFullLineQ];
  linePositions = msLinePositionAssociation[lines];
  While[queue =!= {},
    state = First[queue];
    queue = Rest[queue];
    AppendTo[states, state];
    components = msComponentsForContractions[vertices, lines, state];
    rootToComponent = msRootToComponent[components];
    eligible = Select[
      fullLines,
      ! MemberQ[state, #["id"]] && ! SameQ @@ (rootToComponent /@ #["endpoints"]) &
    ];
    bundles = GatherBy[eligible, Sort[rootToComponent /@ #["endpoints"]] &];
    Do[
      oddSubsets = Select[Rest[Subsets[bundle]], OddQ[Length[#]] &];
      Do[
        selectedIds = Lookup[selected, "id"];
        target = SortBy[Union[state, selectedIds], linePositions];
        sourceKey = msSectorKey[lines, state];
        targetKey = msSectorKey[lines, target];
        AppendTo[
          transitions,
          <|
            "eventId" -> sourceKey <> "->" <> targetKey <> ":" <> ToString[selectedIds, InputForm],
            "sourceContractedLineIds" -> state,
            "targetContractedLineIds" -> target,
            "sourceSector" -> sourceKey,
            "targetSector" -> targetKey,
            "selectedLineIds" -> selectedIds,
            "bundleLineIds" -> Lookup[bundle, "id"],
            "thetaBundleCoefficient" -> 2^(1 - Length[selectedIds]),
            "componentPair" -> Sort[rootToComponent /@ First[selected]["endpoints"]]
          |>
        ];
        If[! KeyExistsQ[seen, ToString[target, InputForm]],
          AssociateTo[seen, ToString[target, InputForm] -> True];
          AppendTo[queue, target]
        ],
        {selected, oddSubsets}
      ],
      {bundle, bundles}
    ]
  ];
  <|
    "contractedSets" -> SortBy[DeleteDuplicates[states], {Length[#] &, linePositions /@ # &}],
    "transitions" -> DeleteDuplicatesBy[
      transitions,
      Lookup[#, {"sourceSector", "targetSector", "selectedLineIds"}] &
    ]
  |>
];

msSectorSlots[lines_List, contractedIds_List] := Flatten@Map[
  Function[line,
    If[MemberQ[contractedIds, line["id"]],
      {},
      Switch[
        line["type"],
        "massiveFull" | "massiveCross",
          MapIndexed[
            <|"key" -> {line["id"], First[#2]}, "kind" -> "massiveEndpoint", "lineId" -> line["id"],
              "linePosition" -> line["position"], "endpointIndex" -> First[#2], "rootVertex" -> #1,
              "momentum" -> line["momentum"], "nu" -> line["nu"], "formulaNu" -> line["formulaNu"],
              "hankelOrder" -> line["hankelOrder"], "hPrefactorPower" -> line["hPrefactorPower"]|> &,
            line["endpoints"]
          ],
        "massiveExternal",
          {<|"key" -> {line["id"], 1}, "kind" -> "massiveEndpoint", "lineId" -> line["id"],
             "linePosition" -> line["position"], "endpointIndex" -> 1, "rootVertex" -> First[line["endpoints"]],
             "momentum" -> line["momentum"], "nu" -> line["nu"], "formulaNu" -> line["formulaNu"],
             "hankelOrder" -> line["hankelOrder"], "hPrefactorPower" -> line["hPrefactorPower"]|>},
        "masslessFull",
          If[
            line["masslessRepresentation"] === "RedundantH",
            MapIndexed[
              <|"key" -> {line["id"], First[#2]}, "kind" -> "masslessEndpointH", "lineId" -> line["id"],
                "linePosition" -> line["position"], "endpointIndex" -> First[#2], "rootVertex" -> #1,
                "momentum" -> line["momentum"], "nu" -> line["nu"], "formulaNu" -> line["formulaNu"],
                "hankelOrder" -> line["hankelOrder"], "hPrefactorPower" -> line["hPrefactorPower"],
                "sigma" -> line["sigma"]|> &,
              line["endpoints"]
            ],
            {<|"key" -> {line["id"], "shared"}, "kind" -> "masslessShared", "lineId" -> line["id"],
               "linePosition" -> line["position"], "endpoints" -> line["endpoints"],
               "momentum" -> line["momentum"], "sigma" -> line["sigma"]|>}
          ],
        _, {}
      ]
    ]
  ],
  lines
];


(* coincident quotient 在 raw binary state space 上构造 embedding S 与 projection P：
   rawVector=S.canonicalVector，canonicalVector=P.rawVector。共享二态 massless 的 odd state 为零；
   RedundantH 明确保留四态，不在这里压缩；massive full 的 10 按既有 convention canonical 到 01。 *)
msSectorCanonicalStateData[sector_Association] := Module[
  {rawStates, slots, slotKeys, activeLines, rootToComponent, constraints, canonicalize,
   images, canonicalStates, canonicalIndex, embedding, projection, mapped, row, column},
  slots = sector["slots"];
  slotKeys = Lookup[slots, "key", {}];
  rawStates = msStateList[Length[slots]];
  activeLines = sector["activeLines"];
  rootToComponent = sector["rootToComponent"];
  constraints = Select[
    activeLines,
    msFullLineQ[#] && SameQ @@ (rootToComponent /@ #["endpoints"]) &
  ];
  canonicalize[bits_List] := Module[{result = bits, positions, zeroQ = False, invalidQ = False},
    Do[
      Switch[line["type"],
        "masslessFull",
          If[line["masslessRepresentation"] === "Quotient",
            positions = FirstPosition[slotKeys, {line["id"], "shared"}, Missing["NoSlot"]];
            If[
              Head[positions] === Missing,
              invalidQ = True,
              If[result[[First[positions]]] === 1, zeroQ = True]
            ]
          ],
        "massiveFull",
          positions = (FirstPosition[slotKeys, {line["id"], #}, Missing["NoSlot"]] &) /@ {1, 2};
          If[
            MemberQ[positions, _Missing, Infinity],
            invalidQ = True,
            positions = First /@ positions;
            If[result[[positions]] === {1, 0}, result = ReplacePart[result, Thread[positions -> {0, 1}]]]
          ]
      ],
      {line, constraints}
    ];
    Which[invalidQ, Missing["MissingCoincidentSlots"], zeroQ, Missing["ZeroCoincidentState"], True, result]
  ];
  images = canonicalize /@ rawStates;
  canonicalStates = DeleteDuplicates[DeleteCases[images, _Missing]];
  canonicalIndex = AssociationThread[ToString[#, InputForm] & /@ canonicalStates, Range[Length[canonicalStates]]];
  embedding = ConstantArray[0, {Length[rawStates], Length[canonicalStates]}];
  Do[
    mapped = images[[row]];
    If[Head[mapped] =!= Missing,
      column = canonicalIndex[ToString[mapped, InputForm]];
      embedding[[row, column]] = 1
    ],
    {row, Length[rawStates]}
  ];
  projection = ConstantArray[0, {Length[canonicalStates], Length[rawStates]}];
  Do[
    row = First@FirstPosition[rawStates, canonicalStates[[column]]];
    projection[[column, row]] = 1,
    {column, Length[canonicalStates]}
  ];
  <|
    "rawStateOrder" -> rawStates,
    "stateOrder" -> canonicalStates,
    "stateEmbedding" -> embedding,
    "stateProjection" -> projection,
    "coincidentLineIds" -> Lookup[constraints, "id", {}],
    "quotientCertifiedQ" -> TrueQ[Simplify[projection.embedding] === IdentityMatrix[Length[canonicalStates]]]
  |>
];

msComponentEnergy[component_List, vertices_List, lines_List] := Module[{energy, endpointPosition},
  (* 顶点指数为 Exp[I phaseSign k0 tau]，所以 M0 的一维能量必须保留同一符号。 *)
  energy = Total[
    (# ["phaseSign"] # ["energy"]) & /@
      Select[vertices, MemberQ[component, #["id"]] &]
  ];
  Do[
    If[MemberQ[{"masslessCross", "masslessExternal"}, line["type"]],
      Do[
        If[MemberQ[component, line["endpoints"][[endpointPosition]]],
          energy += I line["phaseSigns"][[endpointPosition]] line["momentum"]/I
        ],
        {endpointPosition, Length[line["endpoints"]]}
      ]
    ],
    {line, lines}
  ];
  Simplify[energy]
];

msComponentBasePower[component_List, vertices_List, lines_List, contractedIds_List] := Simplify[
  Total[Lookup[Select[vertices, MemberQ[component, #["id"]] &], "timePower"]] +
  Total[
    #["contactRawPower"] & /@
      Select[lines, MemberQ[contractedIds, #["id"]] && SubsetQ[component, #["endpoints"]] &]
  ] + Length[component] - 1
];

msBuildSector[vertices_List, lines_List, contractedIds_List, rootNormalization_] := Module[
  {components, rootToComponent, slots, activeLines, contractedLines, normalization, contactDepth,
   boundaryContactPhase, sector, canonicalData},
  components = msComponentsForContractions[vertices, lines, contractedIds];
  rootToComponent = msRootToComponent[components];
  slots = msSectorSlots[lines, contractedIds];
  activeLines = Select[lines, ! MemberQ[contractedIds, #["id"]] &];
  contractedLines = Select[lines, MemberQ[contractedIds, #["id"]] &];
  normalization = Simplify[
    rootNormalization Times @@ Lookup[contractedLines, "pinchNormalization", 1]
  ];
  contactDepth = Length[vertices] - Length[components];
  boundaryContactPhase = I^Count[contractedLines, line_ /; line["type"] === "massiveFull"];
  sector = <|
    "sectorKey" -> msSectorKey[lines, contractedIds],
    "sectorBits" -> Characters[msSectorKey[lines, contractedIds]],
    "contractedLineIds" -> contractedIds,
    "remainingFullLineCount" -> Count[activeLines, line_ /; msFullLineQ[line]],
    "vertexComponents" -> components,
    "vertexOrder" -> Range[Length[components]],
    "rootToComponent" -> rootToComponent,
    "componentEnergies" -> (msComponentEnergy[#, vertices, activeLines] & /@ components),
    "baseTimePowers" -> (msComponentBasePower[#, vertices, lines, contractedIds] & /@ components),
    "activeLines" -> activeLines,
    "slots" -> slots,
    "slotCount" -> Length[slots],
    "normalization" -> normalization,
    "contactDepth" -> contactDepth,
    "boundaryContactPhase" -> boundaryContactPhase
  |>;
  canonicalData = msSectorCanonicalStateData[sector];
  Join[
    sector,
    canonicalData,
    <|
      "rawStateCount" -> Length[canonicalData["rawStateOrder"]],
      "masterCount" -> Length[canonicalData["stateOrder"]]
    |>
  ]
];

msBuildSectors[vertices_List, lines_List, rootNormalization_] := Module[
  {reachable},
  reachable = msReachableContactData[vertices, lines];
  <|
    "sectors" -> (msBuildSector[vertices, lines, #, rootNormalization] & /@ reachable["contractedSets"]),
    "contactTransitions" -> reachable["transitions"]
  |>
];

msStateList[0] := {{}};
msStateList[count_Integer?Positive] := IntegerDigits[#, 2, count] & /@ Range[0, 2^count - 1];

msBuildMasters[sectors_List] := Module[{offset = 1, records},
  records = Flatten@Map[
    Function[sector,
      With[
        {sectorOffset = offset, shifts = ConstantArray[0, Length[sector["vertexComponents"]]],
         states = sector["stateOrder"]},
        offset += Length[states];
        MapIndexed[
          <|
            "sectorKey" -> sector["sectorKey"],
            "sectorOffset" -> sectorOffset,
            "globalIndex" -> sectorOffset + First[#2] - 1,
            "stateBits" -> #1,
            "integral" -> MSIntegral[sector["sectorKey"], shifts, #1],
            "normalization" -> sector["normalization"]
          |> &,
          states
        ]
      ]
    ],
    sectors
  ];
  records
];


(* ::Section:: *)
(*Sector 与 master 身份证书*)

(*
一次性验证 canonical contraction set、sector key 与全局 master 表的双射关系。
consumer 随后只需读取同源证书和 masterDigest，不必重复扫描完整 context。
*)
msSectorIdentityCertificate[sectors_List, masters_List, rootLines_List] := Module[
  {sectorKeys, contractedSets, masterIntegrals, globalIndices, checks, digest},
  sectorKeys = Lookup[sectors, "sectorKey"];
  contractedSets = Lookup[sectors, "contractedLineIds"];
  masterIntegrals = Lookup[masters, "integral"];
  globalIndices = Lookup[masters, "globalIndex"];
  digest = IntegerString[Hash[masterIntegrals, "SHA256"], 16, 64];
  checks = <|
    "sectorKeysUniqueQ" -> DuplicateFreeQ[sectorKeys],
    "contractedSetsUniqueQ" -> DuplicateFreeQ[contractedSets],
    "sectorKeysCanonicalQ" -> TrueQ[And @@ Map[
      #1["sectorKey"] === msSectorKey[rootLines, #1["contractedLineIds"]] &,
      sectors
    ]],
    "masterIntegralsUniqueQ" -> DuplicateFreeQ[masterIntegrals],
    "masterCountMatchesQ" -> Length[masters] === Total[Lookup[sectors, "masterCount"]],
    "globalIndicesContiguousQ" -> globalIndices === Range[Length[masters]],
    "masterSectorKeysKnownQ" -> SubsetQ[sectorKeys, DeleteDuplicates[Lookup[masters, "sectorKey"]]]
  |>;
  <|
    "status" -> If[And @@ Values[checks], "certified", "collision"],
    "checks" -> checks,
    "sectorCount" -> Length[sectors],
    "masterCount" -> Length[masters],
    "masterDigest" -> digest
  |>
];


(* ::Section:: *)
(*公开初始化与查询*)

Options[MSInitTree] = {NuConvention -> "Positive"};

MSInitTree[spec_Association, OptionsPattern[]] := Module[
  {rawVertices, rawLines, vertices, lines, issues, rootNormalization, sectorData, sectors, masters,
   context, nuConvention, graphMode, contactBundles, sectorIdentityCertificate},
  rawVertices = Lookup[spec, "vertices", {}];
  rawLines = Lookup[spec, "lines", {}];
  If[! ListQ[rawVertices] || ! And @@ (AssociationQ /@ rawVertices) ||
     ! ListQ[rawLines] || ! And @@ (AssociationQ /@ rawLines),
    Message[MSInitTree::badinput, "vertices/lines must be lists of associations"];
    Return[Failure["MalformedTreeSpec", <||>]]
  ];
  nuConvention = OptionValue[NuConvention];
  If[! MemberQ[{"Positive", "Negative"}, nuConvention],
    Message[MSInitTree::badinput, <|"code" -> "unknownNuConvention", "value" -> nuConvention|>];
    Return[Failure["UnknownNuConvention", <|"value" -> nuConvention|>]]
  ];
  vertices = MapIndexed[msNormalizeVertex[#1, First[#2]] &, rawVertices];
  lines = MapIndexed[msNormalizeLine[#1, First[#2], nuConvention] &, rawLines];
  issues = msValidateTreeInput[spec, vertices, lines];
  If[issues =!= {},
    Message[MSInitTree::badinput, issues];
    Return[Failure["InvalidTreeTopology", <|"issues" -> issues|>]]
  ];
  rootNormalization = Lookup[spec, "normalization", 1];
  graphMode = Lookup[spec, "graphMode", If[TrueQ[Lookup[spec, "timeOnlyGraph", False]], "TimeOnly", "Tree"]];
  contactBundles = msNormalizeContactBundles[spec, lines];
  sectorData = msBuildSectors[vertices, lines, rootNormalization];
  sectors = sectorData["sectors"];
  masters = msBuildMasters[sectors];
  sectorIdentityCertificate = msSectorIdentityCertificate[sectors, masters, lines];
  If[sectorIdentityCertificate["status"] =!= "certified",
    Return[Failure["SectorIdentityCollision", sectorIdentityCertificate]]
  ];
  context = <|
    "head" -> "MadStreeContext",
    "version" -> $MadStreeVersion,
    "caseName" -> Lookup[spec, "name", "MadStreeContext"],
    "convention" -> <|
      "timePower" -> "(-tau)^A",
      "functionBasis" -> "h",
      "nuConvention" -> nuConvention,
      "hDefinition" -> If[nuConvention === "Positive", "z^nu H_nu", "z^-nu H_nu"],
      "paperFormulaReplacement" -> If[nuConvention === "Positive", "nuPaper -> -nu", "nuPaper -> nu"]
    |>,
    "vertices" -> vertices,
    "lines" -> lines,
    "graphMode" -> graphMode,
    "topologyClass" -> If[
      Length[Select[lines, msInternalLineQ]] === Max[0, Length[vertices] - 1],
      "tree",
      "cyclicTimeOnly"
    ],
    "contactBundles" -> contactBundles,
    "contactTransitions" -> sectorData["contactTransitions"],
    "sectorKeySchema" -> msSectorKeySchema[lines],
    "energyCoordinates" -> Map[
      <|
        "vertex" -> #["id"],
        "userEnergy" -> #["energy"],
        "phaseSign" -> #["phaseSign"],
        "dampingDefinition" -> I #["phaseSign"] #["energy"]
      |> &,
      vertices
    ],
    "sectors" -> sectors,
    "sectorOrder" -> Lookup[sectors, "sectorKey"],
    "masters" -> masters,
    "masterDigest" -> sectorIdentityCertificate["masterDigest"],
    "sectorIdentityCertificate" -> sectorIdentityCertificate,
    "rootNormalization" -> rootNormalization,
    "capabilities" -> <|
      "formulaRecurrence" -> True,
      "formulaDLog" -> True,
      "simultaneousContact" -> True,
      "timeOnlyCycles" -> True,
      "automaticEuclideanBoundary" -> False,
      "asymptoticBoundaryFormula" -> "2411GenericSectorFrobenius",
      "flintNDETransport" -> True
    |>
  |>;
  context
];


MSInitTimeGraph[spec_Association, OptionsPattern[MSInitTree]] := MSInitTree[
  Join[spec, <|"graphMode" -> "TimeOnly", "timeOnlyGraph" -> True|>],
  NuConvention -> OptionValue[NuConvention]
];

MSContextQ[context_] := AssociationQ[context] && Lookup[context, "head", None] === "MadStreeContext" &&
  ListQ[Lookup[context, "sectors", None]] && ListQ[Lookup[context, "masters", None]];

MSSectors[context_?MSContextQ] := context["sectors"];

msSectorByKey[context_?MSContextQ, key_String] := SelectFirst[
  context["sectors"], #["sectorKey"] === key &, Missing["UnknownSector", key]
];

MSSlotRegistry[context_?MSContextQ, All] := AssociationThread[
  context["sectorOrder"] -> Lookup[context["sectors"], "slots"]
];

MSSlotRegistry[context_?MSContextQ, key_String] := Module[{sector = msSectorByKey[context, key]},
  If[Head[sector] === Missing, sector, sector["slots"]]
];

MSMasterIntegrals[context_?MSContextQ] := context["masters"];
