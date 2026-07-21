(* ::Package:: *)
(* mixed_bubble：massive h + massless exp 的独立手推 expected。 *)

(* ::Chapter:: *)
(*sector 与通用指标工具*)

manualMixedShrunkLines["top"] := {};
manualMixedShrunkLines["e1"] := {1};
manualMixedShrunkLines["e2"] := {2};
manualMixedShrunkLines["e1_e2"] := {1, 2};

manualMixedSectorKey[lines_List] := Switch[Sort[lines],
   {}, "top",
   {1}, "e1",
   {2}, "e2",
   {1, 2}, "e1_e2"
   ];

manualMixedActiveVertices["top"] := {v1, v2};
manualMixedActiveVertices[_String] := {v1};

manualMixedPhase["+"] := -I;
manualMixedPhase["-"] := I;
manualMixedBranchSign["+"] := 1;
manualMixedBranchSign["-"] := -1;
manualMixedSigma["++"] := 1;
manualMixedSigma["--"] := -1;
manualMixedVpm["++"] := 1;
manualMixedVpm["--"] := 0;

manualMixedMassiveC1 := 2 nuM + 1;
manualMixedMassiveShrinkPrefactor := (4 I/Pi) Exp[Pi Im[nuM]];

manualMixedShiftA[J[aList_, packs_, isps_], sector_String, vertex_, delta_] := Module[
   {newA = aList, slot},
   slot = If[sector === "top", If[vertex === v1, 1, 2], 1];
   newA[[slot]] = newA[[slot]] + delta;
   J[newA, packs, isps]
   ];

manualMixedShiftB[J[aList_, packs_, isps_], line_Integer, delta_] := Module[
   {newPacks = packs},
   newPacks[[line, 1]] = newPacks[[line, 1]] + delta;
   J[aList, newPacks, isps]
   ];

manualMixedSetMassiveN[J[aList_, packs_, isps_], endpointSlot_Integer, value_Integer] := Module[
   {newPacks = packs},
   newPacks[[1, endpointSlot + 1]] = value;
   J[aList, newPacks, isps]
   ];

manualMixedToggleMassless[J[aList_, packs_, isps_]] := Module[
   {newPacks = packs},
   newPacks[[2, 2]] = 1 - newPacks[[2, 2]];
   J[aList, newPacks, isps]
   ];

manualMixedAbsorb[factor_, int_J] := Expand[
   Coefficient[Expand[factor], z1] manualMixedShiftB[int, 1, -2] +
    Coefficient[Expand[factor], z2] manualMixedShiftB[int, 2, -2] +
    (Expand[factor] /. {z1 -> 0, z2 -> 0}) int
   ];

manualMixedCoincidentMasslessOddQ[J[aList_, packs_, isps_]] := Module[
   {line2FullOdd, hasAnyShrunk},
   hasAnyShrunk = AnyTrue[packs, Length[#] === 1 &];
   line2FullOdd = Length[packs[[2]]] === 2 && packs[[2, 2]] === 1;
   TrueQ[hasAnyShrunk && line2FullOdd]
   ];

manualMixedMassiveCoincidentCanonical[J[aList_, packs_, isps_]] := Module[{newPacks = packs},
   If[Length[aList] === 1 && Length[packs[[1]]] === 3 &&
     packs[[1, {2, 3}]] === {1, 0},
    newPacks[[1, {2, 3}]] = packs[[1, {3, 2}]]
    ];
   J[aList, newPacks, isps]
   ];

manualMixedCanonical[expr_] := Module[{massiveCanonical},
   massiveCanonical = Expand[expr /. int_J :> manualMixedMassiveCoincidentCanonical[int]];
   Expand[massiveCanonical /. (int_J /; manualMixedCoincidentMasslessOddQ[int]) :> 0]
   ];

manualMixedBaseIntegral[signKey_String, sector_String, stateRules_List] := Module[
   {sameBranch, shrunk, packs, aList},
   sameBranch = MemberQ[{"++", "--"}, signKey];
   shrunk = manualMixedShrunkLines[sector];
   aList = If[sector === "top", {0, 0}, {0}];
   packs = {
     If[MemberQ[shrunk, 1],
      {0},
      {0, n[1, 1] /. stateRules, n[1, 2] /. stateRules}
      ],
     Which[
      MemberQ[shrunk, 2], {0},
      sameBranch, {0, n[2] /. stateRules},
      True, {0}
      ]
     };
   J[aList, packs, {}]
   ];

manualMixedStateRules[signKey_String, sector_String] := Module[
   {sameBranch, vars},
   sameBranch = MemberQ[{"++", "--"}, signKey];
   vars = {};
   If[! MemberQ[manualMixedShrunkLines[sector], 1],
    vars = Join[vars, {n[1, 1], n[1, 2]}]
    ];
   If[sameBranch && ! MemberQ[manualMixedShrunkLines[sector], 2],
    vars = Join[vars, {n[2]}]
    ];
   If[vars === {}, {{}}, Thread[vars -> #] & /@ Tuples[ConstantArray[{0, 1}, Length[vars]]]]
   ];

manualMixedSeedRules[signKey_String, sector_String, stateRules_List] := Join[
   If[sector === "top", {a[v1] -> 0, a[v2] -> 0}, {a[v1] -> 0}],
   Table[
    If[MemberQ[manualMixedShrunkLines[sector], line],
     bS[line] -> 0,
     b[line] -> 0
     ],
    {line, 2}
    ],
   stateRules
   ];

(* ::Chapter:: *)
(*time-IBP 手推*)

manualMixedVertexZeroPoint["top", v1] := alpha1;
manualMixedVertexZeroPoint["top", v2] := alpha2;
manualMixedVertexZeroPoint["e1", v1] := alpha1 + alpha2 - 2 nuM;
manualMixedVertexZeroPoint["e2", v1] := alpha1 + alpha2;
manualMixedVertexZeroPoint["e1_e2", v1] := alpha1 + alpha2 - 2 nuM;

manualMixedVertexEnergy["top", v1] := E1;
manualMixedVertexEnergy["top", v2] := E2;
manualMixedVertexEnergy[_String, v1] := E1 + E2;

manualMixedVertexBranch[signKey_String, "top", v1] := mixedBubbleSigns[signKey][[1]];
manualMixedVertexBranch[signKey_String, "top", v2] := mixedBubbleSigns[signKey][[2]];
manualMixedVertexBranch[signKey_String, _String, v1] := First[mixedBubbleSigns[signKey]];

manualMixedEndpointSlots[sector_String, vertex_] := If[
   sector === "top",
   If[vertex === v1, {1}, {2}],
   If[vertex === v1, {1, 2}, {}]
   ];

manualMixedShrinkIntegral[int_J, sector_String, line_Integer] := Module[
   {aList, packs, isps, newA, newPacks = int[[2]]},
   {aList, packs, isps} = List @@ int;
   newA = If[
     sector === "top",
     {Total[aList] - If[line === 1, 1, 0]},
     {2 First[aList] - If[line === 1, 1, 0]}
     ];
   newPacks = packs;
   newPacks[[line]] = {packs[[line, 1]] + If[line === 1, 1, 0]};
   manualMixedCanonical[J[newA, newPacks, isps]]
   ];

manualMixedMassiveTimeEndpoint[int_J, sector_String, endpointSlot_Integer] := Module[
   {nValue = int[[2, 1, endpointSlot + 1]], endpointVertex},
   endpointVertex = If[endpointSlot === 1, v1, v2];
   If[nValue === 0,
    -manualMixedShiftB[manualMixedSetMassiveN[int, endpointSlot, 1], 1, -1],
    manualMixedShiftB[manualMixedSetMassiveN[int, endpointSlot, 0], 1, -1] +
     manualMixedMassiveC1 manualMixedShiftA[int, sector, endpointVertex, -1]
    ]
   ];

manualMixedMassiveBoundary[
   signKey_String, sector_String, int_J, endpointSlot_Integer] := Module[
   {n1 = int[[2, 1, 2]], n2 = int[[2, 1, 3]], nEndpoint},
   If[n1 + n2 =!= 1, Return[0]];
   nEndpoint = If[endpointSlot === 1, n1, n2];
   manualMixedMassiveShrinkPrefactor *
    (-1)^(nEndpoint + manualMixedVpm[signKey]) *
    manualMixedShrinkIntegral[int, sector, 1]
   ];

manualMixedMasslessTimeTerms[
   signKey_String, sector_String, int_J, slots_List] := Module[
   {sameBranch, sigma, nValue, branchSigns, regular, boundary},
   If[slots === {}, Return[0]];
   sameBranch = MemberQ[{"++", "--"}, signKey];
   If[sameBranch,
    sigma = manualMixedSigma[signKey];
    nValue = int[[2, 2, 2]];
    regular = Total[
      Table[
       I sigma If[slot === 1, 1, -1] *
        manualMixedShiftB[manualMixedToggleMassless[int], 2, -1],
       {slot, slots}
       ]
      ];
    boundary = If[Length[slots] === 1 && nValue === 1,
      -2 If[First[slots] === 1, 1, -1] *
       manualMixedShrinkIntegral[int, sector, 2],
      0
      ],
    branchSigns = manualMixedBranchSign /@ mixedBubbleSigns[signKey];
    regular = Total[
      Table[
       I branchSigns[[slot]] manualMixedShiftB[int, 2, -1],
       {slot, slots}
       ]
      ];
    boundary = 0
    ];
   Expand[regular + boundary]
   ];

manualMixedTimeLineTerms[
   signKey_String, sector_String, int_J, vertex_, line_Integer] := Module[
   {shrunk = manualMixedShrunkLines[sector], slots},
   If[MemberQ[shrunk, line], Return[0]];
   slots = manualMixedEndpointSlots[sector, vertex];
   If[line === 1,
    Total[
     Table[
      manualMixedMassiveTimeEndpoint[int, sector, slot] +
       If[Length[slots] === 1 && MemberQ[{"++", "--"}, signKey],
        manualMixedMassiveBoundary[signKey, sector, int, slot],
        0
        ],
      {slot, slots}
      ]
     ],
    manualMixedMasslessTimeTerms[signKey, sector, int, slots]
    ]
   ];

manualMixedTimeEquation[
   signKey_String, sector_String, stateRules_List, vertex_] := Module[
   {int, power, phase, lineTerms},
   int = manualMixedBaseIntegral[signKey, sector, stateRules];
   power = -manualMixedVertexZeroPoint[sector, vertex] *
     manualMixedShiftA[int, sector, vertex, -1];
   phase = manualMixedPhase[
      manualMixedVertexBranch[signKey, sector, vertex]
      ] manualMixedVertexEnergy[sector, vertex] int;
   lineTerms = Total[
     manualMixedTimeLineTerms[signKey, sector, int, vertex, #] & /@ {1, 2}
     ];
   manualMixedCanonical[Expand[power + phase + lineTerms]]
   ];

(* ::Chapter:: *)
(*momentum-IBP 手推*)

manualMixedVDotQ["loop", 1] := z1;
manualMixedVDotQ["loop", 2] := (z1 - s11 + z2)/2;
manualMixedVDotQ["external", 1] := (z1 + s11 - z2)/2;
manualMixedVDotQ["external", 2] := (z1 - s11 - z2)/2;

manualMixedLineZeroPoint[sector_String, 1] := If[MemberQ[manualMixedShrunkLines[sector], 1], beta1 + 2 nuM, beta1];
manualMixedLineZeroPoint[sector_String, 2] := beta2;

manualMixedMassiveMomentumEndpoint[
   int_J, sector_String, endpointSlot_Integer, factor_] := Module[
   {nValue = int[[2, 1, endpointSlot + 1]], endpointVertex},
   endpointVertex = If[endpointSlot === 1, v1, v2];
   If[nValue === 0,
    manualMixedAbsorb[
     factor,
     manualMixedShiftA[
      manualMixedShiftB[manualMixedSetMassiveN[int, endpointSlot, 1], 1, 1],
      sector, endpointVertex, 1]
     ],
    -manualMixedAbsorb[
      factor,
      manualMixedShiftA[
       manualMixedShiftB[manualMixedSetMassiveN[int, endpointSlot, 0], 1, 1],
       sector, endpointVertex, 1]
      ] -
     manualMixedMassiveC1 manualMixedAbsorb[
      factor,
      manualMixedShiftB[int, 1, 2]
      ]
    ]
   ];

manualMixedMasslessMomentumBuilding[
   signKey_String, sector_String, int_J, factor_] := Module[
   {sameBranch, sigma, endpoints, branchSigns, shifted},
   sameBranch = MemberQ[{"++", "--"}, signKey];
   endpoints = If[sector === "top", {v1, v2}, {v1, v1}];
   If[sameBranch,
    sigma = manualMixedSigma[signKey];
    shifted = manualMixedShiftB[manualMixedToggleMassless[int], 2, 1];
    -I sigma manualMixedAbsorb[
      factor,
      manualMixedShiftA[shifted, sector, endpoints[[1]], 1]
      ] +
     I sigma manualMixedAbsorb[
      factor,
      manualMixedShiftA[shifted, sector, endpoints[[2]], 1]
      ],
    branchSigns = manualMixedBranchSign /@ mixedBubbleSigns[signKey];
    shifted = manualMixedShiftB[int, 2, 1];
    Total[
     Table[
      -I branchSigns[[slot]] manualMixedAbsorb[
        factor,
        manualMixedShiftA[shifted, sector, endpoints[[slot]], 1]
        ],
      {slot, 2}
      ]
     ]
    ]
   ];

manualMixedMomentumLineTerms[
   signKey_String, sector_String, int_J, vectorType_String, line_Integer] := Module[
   {factor, denominator, shrunk, slots},
   factor = manualMixedVDotQ[vectorType, line];
   denominator = -manualMixedLineZeroPoint[sector, line] *
     manualMixedAbsorb[
      factor,
      manualMixedShiftB[int, line, 2]
      ];
   shrunk = MemberQ[manualMixedShrunkLines[sector], line];
   If[shrunk, Return[Expand[denominator]]];
   If[line === 1,
    slots = If[sector === "top", {1, 2}, {1, 2}];
    Expand[
     denominator +
      Total[
       manualMixedMassiveMomentumEndpoint[int, sector, #, factor] & /@ slots
       ]
     ],
    Expand[
     denominator +
      manualMixedMasslessMomentumBuilding[signKey, sector, int, factor]
     ]
    ]
   ];

manualMixedMomentumEquation[
   signKey_String, sector_String, stateRules_List, vectorType_String] := Module[
   {int, divergence},
   int = manualMixedBaseIntegral[signKey, sector, stateRules];
   divergence = If[vectorType === "loop", dim int, 0];
   manualMixedCanonical @ Expand[
     divergence +
      manualMixedMomentumLineTerms[signKey, sector, int, vectorType, 1] +
      manualMixedMomentumLineTerms[signKey, sector, int, vectorType, 2]
     ]
   ];

(* ::Chapter:: *)
(*扁平 expectedRelations*)

manualMixedSectors[signKey_String] := If[
   MemberQ[{"++", "--"}, signKey],
   {"top", "e1", "e2"},
   {"top"}
   ];

manualMixedGenerators[sector_String] := Join[
   {"time", #} & /@ manualMixedActiveVertices[sector],
   {
    {"momentum", 1, "loop", 1},
    {"momentum", 1, "external", 1}
    }
   ];

manualMixedEquation[
   signKey_String, sector_String, stateRules_List, {"time", vertex_}] :=
   manualMixedTimeEquation[signKey, sector, stateRules, vertex];

manualMixedEquation[
   signKey_String, sector_String, stateRules_List,
   {"momentum", 1, vectorType_String, 1}] :=
   manualMixedMomentumEquation[signKey, sector, stateRules, vectorType];

expectedRelations = Flatten[
   Table[
    Table[
     Table[
      Table[
       <|
        "sector" -> sector,
        "vertexSigns" -> signKey,
        "generator" -> generator,
        "seedRules" -> manualMixedSeedRules[signKey, sector, stateRules],
        "equation" -> manualMixedEquation[
          signKey, sector, stateRules, generator],
        "tags" -> DeleteCases[
          {
           If[MemberQ[{"++", "--"}, signKey], "sameBranch", "cross"],
           If[sector === "top", "top", "shrinkSector"],
           If[! MemberQ[manualMixedShrunkLines[sector], 1], "massiveActive", "massiveShrunk"],
           If[! MemberQ[manualMixedShrunkLines[sector], 2],
            If[MemberQ[{"++", "--"}, signKey], "masslessFull", "masslessCross"],
            "masslessShrunk"],
           If[MemberQ[Values[Association[stateRules]], 1], "containsN1", Nothing]
           },
          Nothing
          ]
        |>,
       {generator, manualMixedGenerators[sector]}
       ],
      {stateRules, manualMixedStateRules[signKey, sector]}
      ],
     {sector, manualMixedSectors[signKey]}
     ],
    {signKey, {"++", "--", "+-", "-+"}}
    ]
   ];
