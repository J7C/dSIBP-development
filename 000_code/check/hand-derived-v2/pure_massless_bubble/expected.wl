(* ::Package:: *)
(* pure_massless_bubble：从指数核与 z1/z2 恒等式独立生成扁平 expected。 *)

(* ::Chapter:: *)
(*sector 与指标工具*)

manualBubbleShrunkLines["top"] := {};
manualBubbleShrunkLines["e1"] := {1};
manualBubbleShrunkLines["e2"] := {2};
manualBubbleShrunkLines["e1_e2"] := {1, 2};

manualBubbleSectorKey[lines_List] := Switch[Sort[lines],
   {}, "top",
   {1}, "e1",
   {2}, "e2",
   {1, 2}, "e1_e2"
   ];

manualBubbleActiveVertices["top"] := {v1, v2};
manualBubbleActiveVertices[_String] := {v1};

manualBubblePhase["+"] := -I;
manualBubblePhase["-"] := I;
manualBubbleBranchSign["+"] := 1;
manualBubbleBranchSign["-"] := -1;
manualBubbleSigma["++"] := 1;
manualBubbleSigma["--"] := -1;

manualBubbleShiftA[J[aList_, packs_, isps_], sector_String, vertex_, delta_] := Module[
   {newA = aList, slot},
   slot = If[sector === "top", If[vertex === v1, 1, 2], 1];
   newA[[slot]] = newA[[slot]] + delta;
   J[newA, packs, isps]
   ];

manualBubbleShiftB[J[aList_, packs_, isps_], line_Integer, delta_] := Module[
   {newPacks = packs},
   newPacks[[line, 1]] = newPacks[[line, 1]] + delta;
   J[aList, newPacks, isps]
   ];

manualBubbleToggleN[J[aList_, packs_, isps_], line_Integer] := Module[
   {newPacks = packs},
   newPacks[[line, 2]] = 1 - newPacks[[line, 2]];
   J[aList, newPacks, isps]
   ];

manualBubbleAbsorb[factor_, int_J] := Expand[
   Coefficient[Expand[factor], z1] manualBubbleShiftB[int, 1, -2] +
    Coefficient[Expand[factor], z2] manualBubbleShiftB[int, 2, -2] +
    (Expand[factor] /. {z1 -> 0, z2 -> 0}) int
   ];

manualBubbleCoincidentOddQ[J[aList_, packs_, isps_]] := Module[
   {hasShrunk, hasOddFull},
   hasShrunk = AnyTrue[packs, Length[#] === 1 &];
   hasOddFull = AnyTrue[packs, Length[#] === 2 && #[[2]] === 1 &];
   TrueQ[hasShrunk && hasOddFull]
   ];

manualBubbleCanonical[expr_] := Expand[
   expr /. (int_J /; manualBubbleCoincidentOddQ[int]) :> 0
   ];

manualBubbleBaseIntegral[signKey_String, sector_String, stateRules_List] := Module[
   {sameBranch, shrunk, packs, aList},
   sameBranch = MemberQ[{"++", "--"}, signKey];
   shrunk = manualBubbleShrunkLines[sector];
   aList = If[sector === "top", {0, 0}, {0}];
   packs = Table[
     Which[
      MemberQ[shrunk, line], {0},
      sameBranch, {0, n[line] /. stateRules},
      True, {0}
      ],
     {line, 2}
     ];
   J[aList, packs, {}]
   ];

manualBubbleStateRules[signKey_String, sector_String] := Module[
   {sameBranch, fullLines},
   sameBranch = MemberQ[{"++", "--"}, signKey];
   If[! sameBranch, Return[{{}}]];
   fullLines = Complement[{1, 2}, manualBubbleShrunkLines[sector]];
   If[fullLines === {}, {{}},
    Thread[n /@ fullLines -> #] & /@ Tuples[ConstantArray[{0, 1}, Length[fullLines]]]
    ]
   ];

manualBubbleSeedRules[signKey_String, sector_String, stateRules_List] := Join[
   If[sector === "top", {a[v1] -> 0, a[v2] -> 0}, {a[v1] -> 0}],
   Table[
    If[MemberQ[manualBubbleShrunkLines[sector], line],
     bS[line] -> 0,
     b[line] -> 0
     ],
    {line, 2}
    ],
   stateRules
   ];

(* ::Chapter:: *)
(*time-IBP 手推*)

manualBubbleVertexZeroPoint["top", v1] := alpha1;
manualBubbleVertexZeroPoint["top", v2] := alpha2;
manualBubbleVertexZeroPoint[_String, v1] := alpha1 + alpha2;

manualBubbleVertexEnergy["top", v1] := E1;
manualBubbleVertexEnergy["top", v2] := E2;
manualBubbleVertexEnergy[_String, v1] := E1 + E2;

manualBubbleVertexBranch[signKey_String, "top", v1] :=
   pureMasslessBubbleSigns[signKey][[1]];
manualBubbleVertexBranch[signKey_String, "top", v2] :=
   pureMasslessBubbleSigns[signKey][[2]];
manualBubbleVertexBranch[signKey_String, _String, v1] :=
   First[pureMasslessBubbleSigns[signKey]];

manualBubbleEndpointSlots[sector_String, vertex_] := If[
   sector === "top",
   If[vertex === v1, {1}, {2}],
   If[vertex === v1, {1, 2}, {}]
   ];

manualBubbleShrinkIntegral[int_J, sector_String, line_Integer] := Module[
   {aList, packs, isps, newSector, newA, newPacks},
   {aList, packs, isps} = List @@ int;
   newSector = manualBubbleSectorKey[
     Union[manualBubbleShrunkLines[sector], {line}]
     ];
   newA = If[sector === "top", {Total[aList] - 1}, {2 First[aList] - 1}];
   newPacks = packs;
   newPacks[[line]] = {packs[[line, 1]]};
   manualBubbleCanonical[J[newA, newPacks, isps]]
   ];

manualBubbleTimeLineTerms[
   signKey_String, sector_String, int_J, vertex_, line_Integer] := Module[
   {shrunk = manualBubbleShrunkLines[sector], sameBranch,
    slots, sigma, branchSigns, regular, boundary, nValue},
   If[MemberQ[shrunk, line], Return[0]];
   sameBranch = MemberQ[{"++", "--"}, signKey];
   slots = manualBubbleEndpointSlots[sector, vertex];
   If[slots === {}, Return[0]];
   If[sameBranch,
    sigma = manualBubbleSigma[signKey];
    nValue = int[[2, line, 2]];
    regular = Total[
      Table[
       I sigma If[slot === 1, 1, -1] *
        manualBubbleShiftB[
         manualBubbleToggleN[int, line],
         line,
         -1
         ],
       {slot, slots}
       ]
      ];
    boundary = If[Length[slots] === 1 && nValue === 1,
      -2 If[First[slots] === 1, 1, -1] *
       manualBubbleShrinkIntegral[int, sector, line],
      0
      ],
    branchSigns = manualBubbleBranchSign /@ pureMasslessBubbleSigns[signKey];
    regular = Total[
      Table[
       I branchSigns[[slot]] manualBubbleShiftB[int, line, -1],
       {slot, slots}
       ]
      ];
    boundary = 0
    ];
   Expand[regular + boundary]
   ];

manualBubbleTimeEquation[
   signKey_String, sector_String, stateRules_List, vertex_] := Module[
   {int, power, phase, lineTerms},
   int = manualBubbleBaseIntegral[signKey, sector, stateRules];
   power = -manualBubbleVertexZeroPoint[sector, vertex] *
     manualBubbleShiftA[int, sector, vertex, -1];
   phase = manualBubblePhase[
      manualBubbleVertexBranch[signKey, sector, vertex]
      ] manualBubbleVertexEnergy[sector, vertex] int;
   lineTerms = Total[
     manualBubbleTimeLineTerms[signKey, sector, int, vertex, #] & /@ {1, 2}
     ];
   manualBubbleCanonical[Expand[power + phase + lineTerms]]
   ];

(* ::Chapter:: *)
(*momentum-IBP 手推*)

manualBubbleVDotQ["loop", 1] := z1;
manualBubbleVDotQ["loop", 2] := (z1 - s11 + z2)/2;
manualBubbleVDotQ["external", 1] := (z1 + s11 - z2)/2;
manualBubbleVDotQ["external", 2] := (z1 - s11 - z2)/2;

manualBubbleLineZeroPoint[1] := beta1;
manualBubbleLineZeroPoint[2] := beta2;

manualBubbleMomentumLineTerms[
   signKey_String, sector_String, int_J, vectorType_String, line_Integer] := Module[
   {factor, denominator, sameBranch, shrunk, sigma, branchSigns,
    endpoints, shifted, building},
   factor = manualBubbleVDotQ[vectorType, line];
   denominator = -manualBubbleLineZeroPoint[line] *
     manualBubbleAbsorb[
      factor,
      manualBubbleShiftB[int, line, 2]
      ];
   shrunk = MemberQ[manualBubbleShrunkLines[sector], line];
   If[shrunk, Return[Expand[denominator]]];
   sameBranch = MemberQ[{"++", "--"}, signKey];
   endpoints = If[sector === "top", {v1, v2}, {v1, v1}];
   If[sameBranch,
    sigma = manualBubbleSigma[signKey];
    shifted = manualBubbleShiftB[
      manualBubbleToggleN[int, line],
      line,
      1
      ];
    building =
      -I sigma manualBubbleAbsorb[
        factor,
        manualBubbleShiftA[shifted, sector, endpoints[[1]], 1]
        ] +
       I sigma manualBubbleAbsorb[
        factor,
        manualBubbleShiftA[shifted, sector, endpoints[[2]], 1]
        ],
    branchSigns = manualBubbleBranchSign /@ pureMasslessBubbleSigns[signKey];
    shifted = manualBubbleShiftB[int, line, 1];
    building = Total[
      Table[
       -I branchSigns[[slot]] manualBubbleAbsorb[
         factor,
         manualBubbleShiftA[shifted, sector, endpoints[[slot]], 1]
         ],
       {slot, 2}
       ]
      ]
    ];
   Expand[denominator + building]
   ];

manualBubbleMomentumEquation[
   signKey_String, sector_String, stateRules_List, vectorType_String] := Module[
   {int, divergence},
   int = manualBubbleBaseIntegral[signKey, sector, stateRules];
   divergence = If[vectorType === "loop", dim int, 0];
   manualBubbleCanonical @ Expand[
     divergence +
      manualBubbleMomentumLineTerms[signKey, sector, int, vectorType, 1] +
      manualBubbleMomentumLineTerms[signKey, sector, int, vectorType, 2]
     ]
   ];

(* ::Chapter:: *)
(*扁平 expectedRelations*)

manualBubbleSectors[signKey_String] := If[
   MemberQ[{"++", "--"}, signKey],
   {"top", "e1", "e2", "e1_e2"},
   {"top"}
   ];

manualBubbleGenerators[sector_String] := Join[
   {"time", #} & /@ manualBubbleActiveVertices[sector],
   {
    {"momentum", 1, "loop", 1},
    {"momentum", 1, "external", 1}
    }
   ];

manualBubbleEquation[
   signKey_String, sector_String, stateRules_List, {"time", vertex_}] :=
   manualBubbleTimeEquation[signKey, sector, stateRules, vertex];

manualBubbleEquation[
   signKey_String, sector_String, stateRules_List,
   {"momentum", 1, vectorType_String, 1}] :=
   manualBubbleMomentumEquation[signKey, sector, stateRules, vectorType];

expectedRelations = Flatten[
   Table[
    Table[
     Table[
      Table[
       <|
        "sector" -> sector,
        "vertexSigns" -> signKey,
        "generator" -> generator,
        "seedRules" -> manualBubbleSeedRules[signKey, sector, stateRules],
        "equation" -> manualBubbleEquation[
          signKey, sector, stateRules, generator],
        "tags" -> DeleteCases[
          {
           If[MemberQ[{"++", "--"}, signKey], "masslessFull", "masslessCross"],
           If[sector === "top", "top", "coincidentEndpointSector"],
           If[MemberQ[Values[Association[stateRules]], 1],
            "containsN1", Nothing]
           },
          Nothing
          ]
        |>,
       {generator, manualBubbleGenerators[sector]}
       ],
      {stateRules, manualBubbleStateRules[signKey, sector]}
      ],
     {sector, manualBubbleSectors[signKey]}
     ],
    {signKey, {"++", "--", "+-", "-+"}}
    ]
   ];
