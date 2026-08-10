(* ::Package:: *)

(***
File: Topology.wl
Purpose: Normalizes and validates the ordered-tree or pure time-only incidence graph inputs required by MadStree.
Scope: Loop momentum, ISP and scalar-product closure are not read; the vertex phases and Hankel branches needed by the numerical boundary are normalized only at initialization and then held fixed by the context.
***)

(* ::Chapter:: *)
(* Input normalization *)

$msSupportedLineTypes = {
  "massiveFull", "massiveCross", "massiveExternal",
  "masslessFull", "masslessCross", "masslessExternal"
};

msAssociationKeysMissing[association_Association, keys_List] := Select[keys, ! KeyExistsQ[association, #] &];

msSKSigma["++"] := 1;
msSKSigma["--"] := -1;
msSKSigma[_] := Missing["NotFullSKType"];

msDefaultPhaseSigns["masslessCross", "+-"] := {1, -1};
msDefaultPhaseSigns["masslessCross", "-+"] := {-1, 1};
msDefaultPhaseSigns["masslessExternal", "+"] := {1};
msDefaultPhaseSigns["masslessExternal", "-"] := {-1};
msDefaultPhaseSigns[_, _] := {};

(* Branch numbering follows HankelH[1|2,nu,z]. The branch of a full propagator is determined dynamically by the time ordering. *)
msDefaultHankelBranches["massiveCross", "+-"] := {2, 1};
msDefaultHankelBranches["massiveCross", "-+"] := {1, 2};
msDefaultHankelBranches["massiveExternal", "+"] := {2};
msDefaultHankelBranches["massiveExternal", "-"] := {1};
msDefaultHankelBranches["massiveFull", "++"] := "timeOrdered++";
msDefaultHankelBranches["massiveFull", "--"] := "timeOrdered--";
msDefaultHankelBranches["masslessFull", "++"] := "timeOrdered++";
msDefaultHankelBranches["masslessFull", "--"] := "timeOrdered--";
msDefaultHankelBranches[_, _] := Missing["NotHankelLine"];

msNormalizeVertex[vertex_Association, position_Integer] := <|
  "id" -> Lookup[vertex, "id", Missing["VertexId", position]],
  "position" -> position,
  "energy" -> Lookup[vertex, "energy", Lookup[vertex, "k0", 0]],
  "timePower" -> Lookup[vertex, "timePower", Lookup[vertex, "baseTimePower", 0]],
  "phaseSign" -> Lookup[vertex, "phaseSign", Lookup[vertex, "vertexSign", 1]]
|>;

msNormalizeLine[line_Association, position_Integer, nuConvention_String] := Module[
  {type, endpoints, momentum, nuMagnitude, hankelOrder, formulaNu, skType, sigma, contactRawPower, pinchNormalization,
   phaseSigns, requestedFunctionSystem, masslessRepresentation, functionSystem, hankelBranches},
  type = Lookup[line, "type", Lookup[line, "packType", Missing["LineType", position]]];
  endpoints = Lookup[line, "endpoints", {}];
  momentum = Lookup[line, "momentum", Lookup[line, "k", Missing["Momentum", position]]];
  nuMagnitude = Lookup[line, "nu", If[StringStartsQ[ToString[type], "massless"], 1/2, Missing["NuMagnitude", position]]];
  hankelOrder = nuMagnitude;
  formulaNu = If[nuConvention === "Positive", -nuMagnitude, nuMagnitude];
  skType = Lookup[line, "skType", If[MemberQ[{"massiveFull", "masslessFull"}, type], "++", None]];
  sigma = Lookup[line, "sigma", msSKSigma[skType]];
  contactRawPower = Lookup[
    line,
    "contactRawPower",
    Switch[type, "massiveFull", -2 formulaNu - 1, "masslessFull", 0, _, Missing["NoContact"]]
  ];
  pinchNormalization = Lookup[
    line,
    "pinchNormalization",
    Switch[
      type,
      (* 2411.03088 Eq. (4.2) defines physical momenta with positive magnitude; do not feed the formal (-k)^power to the Mathematica principal branch, which would produce spurious complex phases for generic real nu. *)
      "massiveFull", -(4 I/Pi) Exp[Pi Im[formulaNu]] momentum^(-2 formulaNu - 1),
      "masslessFull", 1,
      _, 1
    ]
  ];
  phaseSigns = Lookup[line, "phaseSigns", msDefaultPhaseSigns[type, skType]];
  requestedFunctionSystem = Lookup[
    line,
    "functionSystem",
    If[StringStartsQ[ToString[type], "massive"], "h", "exponential"]
  ];
  masslessRepresentation = If[
    type === "masslessFull",
    Lookup[
      line,
      "masslessRepresentation",
      If[requestedFunctionSystem === "h", "RedundantH", "Quotient"]
    ],
    None
  ];
  functionSystem = If[
    type === "masslessFull",
    If[masslessRepresentation === "RedundantH", "h", "masslessQuotient"],
    requestedFunctionSystem
  ];
  hankelBranches = Lookup[line, "hankelBranches", msDefaultHankelBranches[type, skType]];
  <|
    "id" -> Lookup[line, "id", Missing["LineId", position]],
    "position" -> position,
    "type" -> type,
    "endpoints" -> endpoints,
    "momentum" -> momentum,
    "nu" -> nuMagnitude,
    "hankelOrder" -> hankelOrder,
    "hPrefactorPower" -> If[nuConvention === "Positive", nuMagnitude, -nuMagnitude],
    "formulaNu" -> formulaNu,
    "nuConvention" -> nuConvention,
    "skType" -> skType,
    "sigma" -> sigma,
    "phaseSigns" -> phaseSigns,
    "hankelBranches" -> hankelBranches,
    "functionSystem" -> functionSystem,
    "masslessRepresentation" -> masslessRepresentation,
    "contactRawPower" -> contactRawPower,
    "pinchNormalization" -> pinchNormalization
  |>
];


(* ::Section:: *)
(* Correctness boundaries *)

msInternalLineQ[line_Association] := Length[line["endpoints"]] === 2;
msExternalLineQ[line_Association] := Length[line["endpoints"]] === 1;
msFullLineQ[line_Association] := MemberQ[{"massiveFull", "masslessFull"}, line["type"]];

msNormalizeContactBundles[spec_Association, lines_List] := Module[
  {fullLines, fullIds, explicit, explicitGroups, usedIds, remaining, automaticGroups, groups,
   lineById, invalidGroups},
  fullLines = Select[lines, msFullLineQ];
  fullIds = Lookup[fullLines, "id", {}];
  explicit = Lookup[spec, "thetaBundles", Lookup[spec, "contactEvents", Automatic]];
  explicitGroups = Replace[
    explicit,
    {
      Automatic -> {},
      items_List :> Replace[
        items,
        {
          item_Association :> Lookup[item, "lineIds", Missing["LineIds"]],
          item_List :> item,
          item_ :> Missing["MalformedBundle", item]
        },
        {1}
      ],
      other_ :> {Missing["MalformedBundles", other]}
    }
  ];
  If[MemberQ[explicitGroups, _Missing, Infinity],
    Return[Failure["MalformedContactBundles", <|"value" -> explicit|>]]
  ];
  usedIds = Flatten[explicitGroups];
  If[! DuplicateFreeQ[usedIds] || ! SubsetQ[fullIds, usedIds],
    Return[Failure[
      "InvalidContactBundleLines",
      <|"fullLineIds" -> fullIds, "explicitLineIds" -> usedIds|>
    ]]
  ];
  lineById = AssociationThread[Lookup[lines, "id"] -> lines];
  invalidGroups = Select[
    explicitGroups,
    # === {} || Length[DeleteDuplicates[Sort /@ Lookup[lineById /@ #, "endpoints"]]] =!= 1 &
  ];
  If[invalidGroups =!= {},
    Return[Failure[
      "ContactBundleMustShareThetaArgument",
      <|"groups" -> invalidGroups|>
    ]]
  ];
  remaining = Select[fullLines, ! MemberQ[usedIds, # ["id"]] &];
  automaticGroups = Lookup[#, "id"] & /@ GatherBy[remaining, Sort[# ["endpoints"]] &];
  groups = Join[explicitGroups, automaticGroups];
  MapIndexed[
    <|
      "bundleId" -> "thetaBundle:" <> ToString[First[#2]],
      "lineIds" -> #1,
      "rootEndpoints" -> If[#1 === {}, {}, Sort[lineById[First[#1]]["endpoints"]]],
      "source" -> If[MemberQ[explicitGroups, #1], "explicit", "inferredFromCommonEndpoints"]
    |> &,
    groups
  ]
];


msValidateTreeInput[spec_Association, vertices_List, lines_List] := Module[
  {issues = {}, vertexIds, lineIds, internalLines, graph, expectedEndpointCount, graphMode,
   connectedQ, edgeCount, bundleData, allowedSKTypes, expectedBranches},
  vertexIds = Lookup[vertices, "id"];
  lineIds = Lookup[lines, "id"];
  If[MemberQ[vertexIds, _Missing] || ! DuplicateFreeQ[vertexIds],
    AppendTo[issues, <|"code" -> "vertexIdsMustBePresentAndUnique", "ids" -> vertexIds|>]
  ];
  If[MemberQ[lineIds, _Missing] || ! DuplicateFreeQ[lineIds],
    AppendTo[issues, <|"code" -> "lineIdsMustBePresentAndUnique", "ids" -> lineIds|>]
  ];
  Do[
    If[! MemberQ[{-1, 1}, vertex["phaseSign"]],
      AppendTo[issues, <|"code" -> "vertexPhaseSignMustBePlusOrMinusOne", "vertex" -> vertex["id"],
        "value" -> vertex["phaseSign"]|>]
    ],
    {vertex, vertices}
  ];
  Do[
    If[! MemberQ[$msSupportedLineTypes, line["type"]],
      AppendTo[issues, <|"code" -> "unsupportedLineType", "line" -> line["id"], "type" -> line["type"]|>]
    ];
    expectedEndpointCount = If[StringEndsQ[ToString[line["type"]], "External"], 1, 2];
    If[Length[line["endpoints"]] =!= expectedEndpointCount,
      AppendTo[issues, <|"code" -> "wrongEndpointCount", "line" -> line["id"], "expected" -> expectedEndpointCount|>]
    ];
    If[! SubsetQ[vertexIds, line["endpoints"]],
      AppendTo[issues, <|"code" -> "unknownEndpoint", "line" -> line["id"], "endpoints" -> line["endpoints"]|>]
    ];
    If[MemberQ[{"massiveFull", "massiveCross", "massiveExternal"}, line["type"]] && Head[line["nu"]] === Missing,
      AppendTo[issues, <|"code" -> "missingNuMagnitude", "line" -> line["id"]|>]
    ];
    If[Head[line["momentum"]] === Missing,
      AppendTo[issues, <|"code" -> "missingMomentum", "line" -> line["id"]|>]
    ];
    allowedSKTypes = Switch[
      line["type"],
      "massiveFull" | "masslessFull", {"++", "--"},
      "massiveCross" | "masslessCross", {"+-", "-+"},
      "massiveExternal" | "masslessExternal", {"+", "-"},
      _, {}
    ];
    If[! MemberQ[allowedSKTypes, line["skType"]],
      AppendTo[issues, <|"code" -> "skTypeIncompatibleWithLineType", "line" -> line["id"],
        "type" -> line["type"], "skType" -> line["skType"], "allowed" -> allowedSKTypes|>]
    ];
    If[line["type"] === "masslessFull" &&
       ! MemberQ[{"Quotient", "RedundantH"}, line["masslessRepresentation"]],
      AppendTo[issues, <|
        "code" -> "invalidMasslessRepresentation",
        "line" -> line["id"],
        "value" -> line["masslessRepresentation"],
        "allowed" -> {"Quotient", "RedundantH"}
      |>]
    ];
    If[line["type"] === "masslessFull" && line["masslessRepresentation"] === "RedundantH" &&
       ! TrueQ[Simplify[line["nu"] - 1/2] === 0],
      AppendTo[issues, <|
        "code" -> "redundantMasslessHRequiresNuHalf",
        "line" -> line["id"],
        "value" -> line["nu"]
      |>]
    ];
    If[StringStartsQ[line["type"], "massive"] ||
       (line["type"] === "masslessFull" && line["masslessRepresentation"] === "RedundantH"),
      expectedBranches = If[line["type"] === "massiveExternal", 1, 2];
      If[! StringQ[line["hankelBranches"]] &&
         (! ListQ[line["hankelBranches"]] || Length[line["hankelBranches"]] =!= expectedBranches ||
          ! And @@ (MemberQ[{1, 2}, #] & /@ line["hankelBranches"])),
        AppendTo[issues, <|"code" -> "invalidHankelBranches", "line" -> line["id"],
          "value" -> line["hankelBranches"]|>]
      ]
    ],
    {line, lines}
  ];
  internalLines = Select[lines, msInternalLineQ];
  graphMode = Lookup[spec, "graphMode", If[TrueQ[Lookup[spec, "timeOnlyGraph", False]], "TimeOnly", "Tree"]];
  If[! MemberQ[{"Tree", "TimeOnly"}, graphMode],
    AppendTo[issues, <|"code" -> "unknownGraphMode", "value" -> graphMode|>]
  ];
  If[vertexIds =!= {} && FreeQ[vertexIds, _Missing],
    graph = Graph[vertexIds, UndirectedEdge @@@ Lookup[internalLines, "endpoints"]];
    connectedQ = TrueQ[ConnectedGraphQ[graph]];
    edgeCount = Length[internalLines];
    If[Length[vertexIds] > 1 && ! connectedQ,
      AppendTo[issues, <|"code" -> "internalGraphMustBeConnected", "edgeCount" -> edgeCount|>]
    ];
    If[graphMode === "Tree" && Length[vertexIds] > 1 && edgeCount =!= Length[vertexIds] - 1,
      AppendTo[issues, <|"code" -> "internalGraphMustBeATree", "edgeCount" -> edgeCount,
        "vertexCount" -> Length[vertexIds]|>]
    ]
  ];
  bundleData = msNormalizeContactBundles[spec, lines];
  If[Head[bundleData] === Failure,
    AppendTo[issues, <|"code" -> First[bundleData], "data" -> Last[bundleData]|>]
  ];
  issues
];
