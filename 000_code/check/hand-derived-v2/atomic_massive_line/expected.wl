(* ::Package:: *)
(* atomic_massive_line：按 Hankel 导数、EOM 与参考 Vpm 独立手推。 *)

(* ::Chapter:: *)
(*手推系数*)

manualMassivePhase["+"] := -I;
manualMassivePhase["-"] := I;

manualMassiveC1["h"] := 2 nuM + 1;
manualMassiveC1["H"] := 2 nuM;

manualMassiveZeroShift["h"] := 2 nuM;
manualMassiveZeroShift["H"] := 0;

manualMassiveVpm["++"] := 1;
manualMassiveVpm["--"] := 0;

manualMassiveShrinkPrefactor =
   (4 I/Pi) Exp[Pi Im[nuM]];

manualMassiveEndpointTime[
   mode_String, n1_Integer, n2_Integer, vertex_] := Module[
   {c1 = manualMassiveC1[mode]},
   If[vertex === v1,
    If[n1 === 0,
     -J[{0, 0}, {{-1, 1, n2}}, {}],
     J[{0, 0}, {{-1, 0, n2}}, {}] +
      c1 J[{-1, 0}, {{0, 1, n2}}, {}]
     ],
    If[n2 === 0,
     -J[{0, 0}, {{-1, n1, 1}}, {}],
     J[{0, 0}, {{-1, n1, 0}}, {}] +
      c1 J[{0, -1}, {{0, n1, 1}}, {}]
     ]
    ]
   ];

manualMassiveBoundary[
   signKey_String, n1_Integer, n2_Integer, vertex_] := Module[
   {nEndpoint, offset, shrunk},
   If[n1 + n2 =!= 1, Return[0]];
   nEndpoint = If[vertex === v1, n1, n2];
   offset = manualMassiveVpm[signKey];
   shrunk = J[{-1}, {{1}}, {}];
   manualMassiveShrinkPrefactor (-1)^(nEndpoint + offset) shrunk
   ];

manualMassiveTopTime[
   mode_String, signKey_String, n1_Integer, n2_Integer, vertex_] := Module[
   {signs = atomicMassiveSigns[signKey], int, power, phase, endpoint, boundary},
   int = J[{0, 0}, {{0, n1, n2}}, {}];
   If[vertex === v1,
    power = -alpha1 J[{-1, 0}, {{0, n1, n2}}, {}];
    phase = manualMassivePhase[signs[[1]]] E1 int,
    power = -alpha2 J[{0, -1}, {{0, n1, n2}}, {}];
    phase = manualMassivePhase[signs[[2]]] E2 int
    ];
   endpoint = manualMassiveEndpointTime[mode, n1, n2, vertex];
   boundary = If[MemberQ[{"++", "--"}, signKey],
     manualMassiveBoundary[signKey, n1, n2, vertex],
     0
     ];
   Expand[power + phase + endpoint + boundary]
   ];

manualMassiveEndpointMomentum[
   mode_String, n1_Integer, n2_Integer, vertex_] := Module[
   {c1 = manualMassiveC1[mode]},
   If[vertex === v1,
    If[n1 === 0,
     J[{1, 0}, {{-1, 1, n2}}, {}],
     -J[{1, 0}, {{-1, 0, n2}}, {}] -
      c1 J[{0, 0}, {{0, 1, n2}}, {}]
     ],
    If[n2 === 0,
     J[{0, 1}, {{-1, n1, 1}}, {}],
     -J[{0, 1}, {{-1, n1, 0}}, {}] -
      c1 J[{0, 0}, {{0, n1, 1}}, {}]
     ]
    ]
   ];

manualMassiveTopMomentum[
   mode_String, n1_Integer, n2_Integer] := Module[
   {int = J[{0, 0}, {{0, n1, n2}}, {}]},
   Expand[
    (dim - beta) int +
     manualMassiveEndpointMomentum[mode, n1, n2, v1] +
     manualMassiveEndpointMomentum[mode, n1, n2, v2]
    ]
   ];

manualMassiveShrunkTime[
   mode_String, signKey_String] := Module[
   {shift = manualMassiveZeroShift[mode],
    branch = First[atomicMassiveSigns[signKey]],
    int = J[{0}, {{0}}, {}]},
   Expand[
    -(alpha1 + alpha2 - shift) J[{-1}, {{0}}, {}] +
     manualMassivePhase[branch] (E1 + E2) int
    ]
   ];

manualMassiveShrunkMomentum[mode_String] :=
   (dim - beta - manualMassiveZeroShift[mode]) J[{0}, {{0}}, {}];

(* ::Chapter:: *)
(*全 sector、全生成元 expected*)

massiveSameBranchTopRelations = Flatten[
   Table[
    {
     <|
      "sector" -> "top",
      "vertexSigns" -> signKey,
      "mode" -> mode,
      "generator" -> {"time", v1},
      "seedRules" -> {a[v1] -> 0, a[v2] -> 0, b[1] -> 0,
        n[1, 1] -> n1Value, n[1, 2] -> n2Value},
      "equation" -> manualMassiveTopTime[
        mode, signKey, n1Value, n2Value, v1],
      "tags" -> {"massiveFull", "firstEndpoint", "immediateEOM",
        If[n1Value + n2Value === 1, "wronskianShrink", "noShrink"]}
      |>,
     <|
      "sector" -> "top",
      "vertexSigns" -> signKey,
      "mode" -> mode,
      "generator" -> {"time", v2},
      "seedRules" -> {a[v1] -> 0, a[v2] -> 0, b[1] -> 0,
        n[1, 1] -> n1Value, n[1, 2] -> n2Value},
      "equation" -> manualMassiveTopTime[
        mode, signKey, n1Value, n2Value, v2],
      "tags" -> {"massiveFull", "secondEndpoint", "immediateEOM",
        If[n1Value + n2Value === 1, "wronskianShrink", "noShrink"]}
      |>,
     <|
      "sector" -> "top",
      "vertexSigns" -> signKey,
      "mode" -> mode,
      "generator" -> {"momentum", 1, "loop", 1},
      "seedRules" -> {a[v1] -> 0, a[v2] -> 0, b[1] -> 0,
        n[1, 1] -> n1Value, n[1, 2] -> n2Value},
      "equation" -> manualMassiveTopMomentum[
        mode, n1Value, n2Value],
      "tags" -> {"massiveFull", "momentumKernel", "immediateEOM"}
      |>
     },
    {mode, {"h", "H"}},
    {signKey, {"++", "--"}},
    {n1Value, {0, 1}},
    {n2Value, {0, 1}}
    ]
   ];

massiveSameBranchShrunkRelations = Flatten[
   Table[
    {
     <|
      "sector" -> "e1",
      "vertexSigns" -> signKey,
      "mode" -> mode,
      "generator" -> {"time", v1},
      "seedRules" -> {a[v1] -> 0, bS[1] -> 0},
      "equation" -> manualMassiveShrunkTime[mode, signKey],
      "tags" -> {"massiveShrunk", mode, "compactA", "nonzeroZeroPoint"}
      |>,
     <|
      "sector" -> "e1",
      "vertexSigns" -> signKey,
      "mode" -> mode,
      "generator" -> {"momentum", 1, "loop", 1},
      "seedRules" -> {a[v1] -> 0, bS[1] -> 0},
      "equation" -> manualMassiveShrunkMomentum[mode],
      "tags" -> {"massiveShrunk", mode, "bS"}
      |>
     },
    {mode, {"h", "H"}},
    {signKey, {"++", "--"}}
    ]
   ];

massiveCrossRelations = Flatten[
   Table[
    {
     <|
      "sector" -> "top",
      "vertexSigns" -> signKey,
      "mode" -> mode,
      "generator" -> {"time", v1},
      "seedRules" -> {a[v1] -> 0, a[v2] -> 0, b[1] -> 0,
        n[1, 1] -> n1Value, n[1, 2] -> n2Value},
      "equation" -> manualMassiveTopTime[
        mode, signKey, n1Value, n2Value, v1],
      "tags" -> {"massiveCross", "firstEndpoint", "immediateEOM", "noTheta"}
      |>,
     <|
      "sector" -> "top",
      "vertexSigns" -> signKey,
      "mode" -> mode,
      "generator" -> {"time", v2},
      "seedRules" -> {a[v1] -> 0, a[v2] -> 0, b[1] -> 0,
        n[1, 1] -> n1Value, n[1, 2] -> n2Value},
      "equation" -> manualMassiveTopTime[
        mode, signKey, n1Value, n2Value, v2],
      "tags" -> {"massiveCross", "secondEndpoint", "immediateEOM", "noTheta"}
      |>,
     <|
      "sector" -> "top",
      "vertexSigns" -> signKey,
      "mode" -> mode,
      "generator" -> {"momentum", 1, "loop", 1},
      "seedRules" -> {a[v1] -> 0, a[v2] -> 0, b[1] -> 0,
        n[1, 1] -> n1Value, n[1, 2] -> n2Value},
      "equation" -> manualMassiveTopMomentum[
        mode, n1Value, n2Value],
      "tags" -> {"massiveCross", "momentumKernel", "immediateEOM", "noTheta"}
      |>
     },
    {mode, {"h", "H"}},
    {signKey, {"+-", "-+"}},
    {n1Value, {0, 1}},
    {n2Value, {0, 1}}
    ]
   ];

expectedRelations = Join[
   massiveSameBranchTopRelations,
   massiveSameBranchShrunkRelations,
   massiveCrossRelations
   ];
