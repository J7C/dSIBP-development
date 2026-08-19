(* ::Package:: *)

(***
File: Sectors.wl
Purpose: Builds the sector DAG, the graph-wide slot registry and the ordered master integrals from common-theta simultaneous contact events.
Key convention: one event produces exactly one delta; a multi-edge event contracts the selected lines simultaneously and merges the vertices only once.
Sector keys are fixed-length strings encoding the root propagator input order, with 0 for contracted and 1 for uncontracted.
***)

(* ::Chapter:: *)
(* Sectors and components *)

(* Input is the complete root line table and the canonical contraction set. Never convert the result to an integer; sectors starting with contracted propagators would lose leading zeros and break their identity. *)
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


(* Each round allows contact only from full lines connecting two different current components. Unselected bundle lines whose endpoints coincide are kept as coincident lines and handled by the sector quotient. *)
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
                "fullContourSign" -> line["fullContourSign"]|> &,
              line["endpoints"]
            ],
            {<|"key" -> {line["id"], "shared"}, "kind" -> "masslessShared", "lineId" -> line["id"],
               "linePosition" -> line["position"], "endpoints" -> line["endpoints"],
               "momentum" -> line["momentum"], "fullContourSign" -> line["fullContourSign"]|>}
          ],
        _, {}
      ]
    ]
  ],
  lines
];


(* The coincident quotient builds an embedding S and a projection P on the raw binary state space: rawVector=S.canonicalVector and canonicalVector=P.rawVector. The odd shared state of massless lines is zero; RedundantH explicitly keeps four states and is not compressed here; massive full 10 is canonicalized to 01 according to the existing convention. *)
msSectorCanonicalStateData[sector_Association] := Module[
  {rawStates, slots, activeLines, rootToComponent, constraints, canonicalize,
   images, canonicalStates, canonicalIndex, embedding, projection, mapped, row, column},
  slots = sector["slots"];
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
            positions = msSlotPositionByKey[sector, {line["id"], "shared"}];
            If[
              Head[positions] === Missing,
              invalidQ = True,
              If[result[[First[positions]]] === 1, zeroQ = True]
            ]
          ],
        "massiveFull",
          positions = (msSlotPositionByKey[sector, {line["id"], #}] &) /@ {1, 2};
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
  (* energy 是顶点所附无 theta 指数 Exp[I vertexSign k tau] 的参数，M0 必须保留同一轮廓支符号。 *)
  energy = Total[
    (# ["vertexSign"] # ["externalLegEnergy"]) & /@
      Select[vertices, MemberQ[component, #["id"]] &]
  ];
  Do[
    If[MemberQ[{"masslessCross", "masslessExternal"}, line["type"]],
      Do[
        If[MemberQ[component, line["endpoints"][[endpointPosition]]],
          energy += I line["endpointSigns"][[endpointPosition]] line["momentum"]/I
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
    sector, canonicalData},
  components = msComponentsForContractions[vertices, lines, contractedIds];
  rootToComponent = msRootToComponent[components];
  slots = msSectorSlots[lines, contractedIds];
  activeLines = Select[lines, ! MemberQ[contractedIds, #["id"]] &];
  contractedLines = Select[lines, MemberQ[contractedIds, #["id"]] &];
  normalization = Simplify[
    rootNormalization Times @@ Lookup[contractedLines, "pinchNormalization", 1]
  ];
  contactDepth = Length[vertices] - Length[components];
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
    "contactDepth" -> contactDepth
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
(* Sector and master identity certificates *)

(*
Validates once the bijection between canonical contraction sets, sector keys and the global master table.
Consumers then only read the same-origin certificate and masterDigest, without rescanning the full context.
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
(* Public initialization and queries *)

Options[MSInitTree] = {NuConvention -> "Positive"};

MSInitTree[spec_Association, OptionsPattern[]] := Module[
  {rawVertices, rawLines, vertices, lines, issues, rootNormalization, sectorData, sectors, masters,
   context, nuConvention, graphMode, contactBundles, sectorIdentityCertificate, inputIssues},
  rawVertices = Lookup[spec, "vertices", {}];
  rawLines = Lookup[spec, "lines", {}];
  If[! ListQ[rawVertices] || ! And @@ (AssociationQ /@ rawVertices) ||
     ! ListQ[rawLines] || ! And @@ (AssociationQ /@ rawLines),
    Message[MSInitTree::badinput, "vertices/lines must be lists of associations"];
    Return[Failure["MalformedTreeSpec", <||>]]
  ];
  inputIssues = msInputSchemaIssues[spec, rawVertices, rawLines];
  If[inputIssues =!= {},
    Message[MSInitTree::badinput, inputIssues];
    Return[Failure["InvalidTreeInputFields", <|"issues" -> inputIssues|>]]
  ];
  nuConvention = OptionValue[NuConvention];
  If[! MemberQ[{"Positive", "Negative"}, nuConvention],
    Message[MSInitTree::badinput, <|"code" -> "unknownNuConvention", "value" -> nuConvention|>];
    Return[Failure["UnknownNuConvention", <|"value" -> nuConvention|>]]
  ];
  vertices = MapIndexed[msNormalizeVertex[#1, First[#2]] &, rawVertices];
  lines = MapIndexed[msNormalizeLine[#1, First[#2], nuConvention, vertices] &, rawLines];
  issues = msValidateTreeInput[spec, vertices, lines];
  If[issues =!= {},
    Message[MSInitTree::badinput, issues];
    Return[Failure["InvalidTreeTopology", <|"issues" -> issues|>]]
  ];
  rootNormalization = Lookup[spec, "normalization", 1];
  graphMode = Lookup[spec, "graphMode", "Tree"];
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
        "userExternalLegEnergy" -> #["externalLegEnergy"],
        "vertexType" -> #["vertexType"],
        "vertexSign" -> #["vertexSign"],
        "dampingDefinition" -> I #["vertexSign"] #["externalLegEnergy"]
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
      "asymptoticBoundaryFormula" -> "2411GenericSectorFrobenius"
    |>
  |>;
  context
];


MSInitTimeGraph[spec_Association, OptionsPattern[MSInitTree]] := MSInitTree[
  Join[spec, <|"graphMode" -> "TimeOnly"|>],
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
