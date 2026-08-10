(* ::Package:: *)

(***
File: 01_massless_full_edge.wl
Purpose: Demonstrates the minimal flow of a single theta-carrying massless full edge from topology initialization to master integrals, recurrence and the dlog DE;
      with two extensions: a user custom finite boundary (choose any ordinary point as anchor) and batch multi-point evaluation
      (fixed parameters written once, each point only writes its varying values; AnchorPoint shares the singular launch and
      Parallel evaluates the per-point transports concurrently).
Run: execute section by section in the Mathematica front end, or run the whole file with wolframscript -file.
***)

(* ::Chapter:: *)
(* Load MadStree *)

packageRoot = DirectoryName[DirectoryName[$InputFileName]];
AppendTo[$Path, FileNameJoin[{packageRoot, "Kernel"}]];
Needs["MadStree`"];


(* ::Chapter:: *)
(* Define ordered tree topology *)

treeSpec = <|
  "vertices" -> {
    <|"id" -> v1, "energy" -> k1, "timePower" -> a1|>,
    <|"id" -> v2, "energy" -> k2, "timePower" -> a2|>
  },
  "lines" -> {
    <|"id" -> e1, "type" -> "masslessFull", "endpoints" -> {v1, v2},
      "momentum" -> q, "skType" -> "++", "nu" -> 1/2|>
  }
|>;

context = MSInitTree[treeSpec];
topKey = First[context["sectorOrder"]];
MSSectors[context]


(* ::Chapter:: *)
(* Direct formula results *)

masters = MSMasterIntegrals[context];
topMatrices = MSFormulaMatrices[context, topKey];
contactMaps = MSContactMaps[context, topKey];
dlogDE = MSDLogDE[context];

Lookup[masters, "integral"]

dlogDE["omegaPotential"] // MatrixForm


(* ::Chapter:: *)
(* Iterative reduction and automatic numerical boundary *)

shiftedIntegral = MSIntegral[topKey, {1, 0}, {0}];
reduction = MSReduce[shiftedIntegral, context];
reduction["result"]

numericalTemplate = MSNumericalSystem[dlogDE];
numericalTemplate["status"]

targetRules = {k1 -> -9 I, k2 -> -3 I, q -> 1, a1 -> 1, a2 -> 1};
boundary = MSBoundaryData[
  context,
  targetRules,
  BoundaryScale -> 4,
  WorkingPrecision -> 40
];

targetValue = MSEvaluateTree[
  context,
  targetRules,
  BoundaryScale -> 4,
  WorkingPrecision -> 40,
  TransportOrder -> 80,
  ReferenceTransportOrder -> 104,
  TargetRelativeError -> "1e-20"
];

(* Failure gate: stop immediately if the transport failed, so later sections
   do not cascade on a Failure. The package has already printed the backend
   diagnostic message. *)
If[Head[targetValue] === Failure,
  Print["Example failed at MSEvaluateTree: ", targetValue];
  Exit[1]
];

targetValue["values"]
targetValue["flintNDE", "relativeDifferenceInf"]


(* ::Chapter:: *)
(* User custom boundary: choose any ordinary point as the anchor *)

userAnchorRules = {k1 -> -9 I, k2 -> -3 I, q -> 1, a1 -> 1, a2 -> 1};
userAnchorValue = MSEvaluateTree[
  context,
  userAnchorRules,
  BoundaryScale -> 4,
  WorkingPrecision -> 40,
  TransportOrder -> 80,
  ReferenceTransportOrder -> 104,
  TargetRelativeError -> "1e-20"
];

(* Failure gate: the custom-boundary section reuses these anchor values, so a
   failed anchor computation must stop the script here. *)
If[Head[userAnchorValue] === Failure,
  Print["Example failed at the custom-anchor MSEvaluateTree: ", userAnchorValue];
  Exit[1]
];

userAnchorValues = userAnchorValue["values"];

(* Build a finite boundary from the anchor values; every new point is then transported from this anchor without passing through the infinity boundary. *)
userFiniteBoundary[targetRules_] := <|
  "status" -> "generated",
  "method" -> "userChosenFiniteAnchor",
  "boundaryKind" -> "finiteFrobeniusSeries",
  "masterDigest" -> context["masterDigest"],
  "anchorRules" -> userAnchorRules,
  "targetRules" -> targetRules,
  "values" -> userAnchorValues
|>;

userTargetRules = {k1 -> -8 I, k2 -> -2 I, q -> 1, a1 -> 1, a2 -> 1};
userTargetValue = MSFlintNDETransport[
  context,
  userFiniteBoundary[userTargetRules],
  WorkingPrecision -> 40,
  TransportOrder -> 80,
  ReferenceTransportOrder -> 104,
  TargetRelativeError -> "1e-20"
];

userTargetValue["values"]
userTargetValue["flintNDE", "relativeDifferenceInf"]


(* ::Chapter:: *)
(* Batch multi-point evaluation: fixed parameters are written once, each point only writes its varying values.
   Two speed options are provided:
     AnchorPoint -> rules   computes the (expensive) singular launch once at a finite anchor and then transports
                            every point from the anchor by ordinary transport only (per-point cost drops from
                            about 3.5 s to about 0.75 s in this example);
     Parallel -> Automatic|True|False   evaluates the per-point transports concurrently (Automatic enables it
                            for 8 or more points so that subkernel startup is amortized). *)

(* Fixed parameters shared by all points (momenta, time powers, nu and other non-energy quantities) *)
batchFixedRules = {q -> 1, a1 -> 1, a2 -> 1};

(* Numeric tuple table: each row is one point, giving the varying values in the order of batchPointSymbols *)
batchPointSymbols = {k1, k2};
batchPointTable = {
  {-8 I, -2 I},
  {-7 I, -4 I},
  {-6 I, -5 I}
};

Options[batchEvaluateTree] = {
  PointSymbols -> Automatic, AnchorPoint -> Automatic,
  AnchorValues -> Automatic, Parallel -> Automatic
};

batchEvaluateTree[
  context_?MSContextQ,
  fixedRules_List,
  pointSpecs_List,
  boundaryOptions_List,
  transportOptions_List,
  opts : OptionsPattern[]
] := Module[
  {symbols, anchorRules, parallelQ, rawPoints, mergePointRules, points, vertices, energySymbols,
   nonEnergyPart, anchorValue, anchorValues, finiteBoundary, runOne, results},
  symbols = OptionValue[PointSymbols];
  anchorRules = OptionValue[AnchorPoint];
  anchorValues = OptionValue[AnchorValues];
  parallelQ = Switch[OptionValue[Parallel],
    True, True,
    False, False,
    Automatic, Length[pointSpecs] >= 8,
    _, False
  ];
  (* With PointSymbols given, pointSpecs is a table of numeric tuples; otherwise pointSpecs is a list of rules *)
  rawPoints = If[symbols === Automatic,
    pointSpecs,
    Map[Thread[symbols -> #] &, pointSpecs]
  ];
  (* Each point = fixed rules + that point's varying rules; point rules override fixed rules *)
  mergePointRules[fixed_, point_] := Join[
    DeleteCases[fixed, Rule[left_, _] /; MemberQ[point[[All, 1]], left]],
    point
  ];
  points = Map[mergePointRules[fixedRules, #] &, rawPoints];
  vertices = context["vertices"];
  energySymbols = Lookup[vertices, "energy"];
  (* The non-energy parameters (momenta, time powers, nu) of the boundary anchor come from the target rules; only energies may vary freely. *)
  nonEnergyPart[rules_] := Sort@Select[rules, FreeQ[energySymbols, First[#]] &];

  If[anchorRules === Automatic,
    (* Automatic boundary: generating it is cheap (~0.1 s), so it is regenerated per point here.
       This keeps the batch embarrassingly parallel; to share the expensive singular launch instead,
       pass AnchorPoint (and optionally AnchorValues). *)
    runOne[targetRules_] := Module[{bnd},
      bnd = MSBoundaryData[context, targetRules, Sequence @@ boundaryOptions];
      MSFlintNDETransport[
        context,
        Join[KeyDrop[bnd, "targetRules"], <|"targetRules" -> targetRules|>],
        Sequence @@ transportOptions
      ]
    ],
    (* Finite anchor: compute the master values at the anchor once (singular + ordinary transport), then
       every point is transported from the anchor by ordinary transport only. *)
    If[anchorValues === Automatic,
      anchorValue = MSEvaluateTree[
        context,
        anchorRules,
        Sequence @@ boundaryOptions,
        Sequence @@ transportOptions
      ];
      anchorValues = anchorValue["values"];
    ];
    finiteBoundary[targetRules_] := <|
      "status" -> "generated",
      "method" -> "finiteAnchorBatch",
      "boundaryKind" -> "finiteFrobeniusSeries",
      "masterDigest" -> context["masterDigest"],
      "anchorRules" -> anchorRules,
      "targetRules" -> targetRules,
      "values" -> anchorValues
    |>;
    runOne[targetRules_] := MSFlintNDETransport[
      context,
      finiteBoundary[targetRules],
      Sequence @@ transportOptions
    ];
  ];

  results = If[parallelQ,
    ParallelEvaluate[
      If[! MemberQ[$Path, FileNameJoin[{packageRoot, "Kernel"}]],
        AppendTo[$Path, FileNameJoin[{packageRoot, "Kernel"}]]
      ];
      Needs["MadStree`"];
    ];
    ParallelMap[runOne, points],
    Map[runOne, points]
  ];
  results
];

(* Use the finite anchor from the previous section so the singular launch is shared by all points. *)
batchResults = batchEvaluateTree[
  context,
  batchFixedRules,
  batchPointTable,
  {BoundaryScale -> 4, WorkingPrecision -> 40},
  {WorkingPrecision -> 40, TransportOrder -> 80,
   ReferenceTransportOrder -> 104, TargetRelativeError -> "1e-20"},
  PointSymbols -> batchPointSymbols,
  AnchorPoint -> userAnchorRules,
  AnchorValues -> userAnchorValues
];

(* Full-rule points (for labeling results); users only maintain batchFixedRules/batchPointTable above *)
batchPoints = Map[
  Join[batchFixedRules, Thread[batchPointSymbols -> #]] &,
  batchPointTable
];

Lookup[batchResults, "values"]
MapThread[
  {#1, #2, #3} &,
  {batchPoints,
   Lookup[batchResults, "status"],
   Lookup[Lookup[batchResults, "flintNDE"], "relativeDifferenceInf"]}
]

(* Export the batch results (CSV and JSON) so users can plot them with their preferred tool. *)
batchExport = MSExportEvaluationData[
  batchPoints,
  batchResults,
  MSOutputDirectory -> "results/madstree_evaluation",
  SignificantDigits -> 16
];
batchExport


(* ::Chapter:: *)
(* Failure gate *)

(* Exit non-zero when any stage produced a Failure, so a fresh run cannot
   report success while hiding errors. *)
exampleGateFailures = Select[
  Join[{targetValue, userAnchorValue, userTargetValue, batchExport}, batchResults],
  Head[#] === Failure &
];
If[exampleGateFailures =!= {},
  Print["Example FAILED: ", Length[exampleGateFailures], " result(s) are Failure objects."];
  Scan[Print["  ", #] &, exampleGateFailures];
  Exit[1]
];
Print["Example PASSED: all checked results are non-Failure."]
