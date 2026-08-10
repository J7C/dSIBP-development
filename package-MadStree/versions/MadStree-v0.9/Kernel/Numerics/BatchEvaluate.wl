(* ::Package:: *)

(***
File: BatchEvaluate.wl
Purpose: Provides MSBatchEvaluateTree, a multi-point evaluation entry that reuses one boundary or a finite anchor
         and can run the per-point transports in parallel.
Scope: Each point must differ only in the kinematic variables written per point; the fixed rules supply all other
       parameters. Results are the same associations returned by MSFlintNDETransport, so they can be exported with
       MSExportEvaluationData.
***)

(* ::Chapter:: *)
(* Public batch entry *)

Options[MSBatchEvaluateTree] = {
  PointSymbols -> Automatic,
  AnchorPoint -> Automatic,
  AnchorValues -> Automatic,
  Parallel -> Automatic
};

MSBatchEvaluateTree[
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
  (* With PointSymbols given, pointSpecs is a table of numeric tuples; otherwise pointSpecs is a list of rules. *)
  rawPoints = If[symbols === Automatic,
    pointSpecs,
    Map[Thread[symbols -> #] &, pointSpecs]
  ];
  (* Each point = fixed rules + that point's varying rules; point rules override fixed rules. *)
  mergePointRules[fixed_, point_] := Join[
    DeleteCases[fixed, Rule[left_, _] /; MemberQ[point[[All, 1]], left]],
    point
  ];
  points = Map[mergePointRules[fixedRules, #] &, rawPoints];
  vertices = context["vertices"];
  energySymbols = Lookup[vertices, "energy"];
  (* The non-energy parameters (momenta, time powers, nu) of the boundary anchor come from the target rules;
     only energies may vary freely. *)
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
    With[{kernelDirectory = $MadStreeKernelDirectory},
      ParallelEvaluate[
        If[! MemberQ[$Path, kernelDirectory],
          AppendTo[$Path, kernelDirectory]
        ];
        Needs["MadStree`"];
      ];
      ParallelMap[runOne, points]
    ],
    Map[runOne, points]
  ];
  results
];

MSBatchEvaluateTree[___] := Failure[
  "InitializedContextRequired",
  <|"function" -> "MSBatchEvaluateTree"|>
];
