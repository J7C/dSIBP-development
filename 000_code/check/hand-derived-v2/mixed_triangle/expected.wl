(* ::Package:: *)
(* mixed_triangle：两条 massive h 加一条 massless exp 的独立手推 expected。 *)

(* ::Chapter:: *)
(*图与 sector 工具*)

manualTriangleVertices = {v1, v2, v3};
manualTriangleLines = {1, 2, 3};
manualTriangleLineEndpoints[1] := {v1, v2};
manualTriangleLineEndpoints[2] := {v2, v3};
manualTriangleLineEndpoints[3] := {v3, v1};
manualTriangleLineMass[1] := "massive";
manualTriangleLineMass[2] := "massive";
manualTriangleLineMass[3] := "massless";

manualTriangleAlpha[v1] := alpha1;
manualTriangleAlpha[v2] := alpha2;
manualTriangleAlpha[v3] := alpha3;
manualTriangleEnergy[v1] := E1;
manualTriangleEnergy[v2] := E2;
manualTriangleEnergy[v3] := E3;
manualTriangleBeta[1] := beta1;
manualTriangleBeta[2] := beta2;
manualTriangleBeta[3] := beta3;

manualTrianglePhase["+"] := -I;
manualTrianglePhase["-"] := I;
manualTriangleBranchSign["+"] := 1;
manualTriangleBranchSign["-"] := -1;
manualTriangleVpm["++"] := 1;
manualTriangleVpm["--"] := 0;
manualTriangleMassiveC1 := 2 nuM + 1;
manualTriangleMassiveShrinkPrefactor := (4 I/Pi) Exp[Pi Im[nuM]];

manualTriangleLineSigns[signKey_String, line_Integer] := Module[
   {signs = mixedTriangleSigns[signKey], endpoints, positions},
   endpoints = manualTriangleLineEndpoints[line];
   positions = endpoints /. {v1 -> 1, v2 -> 2, v3 -> 3};
   signs[[positions]]
   ];

manualTriangleSameBranchQ[signKey_String, line_Integer] := SameQ @@ manualTriangleLineSigns[signKey, line];
manualTriangleLineSk[signKey_String, line_Integer] := StringJoin[manualTriangleLineSigns[signKey, line]];
manualTriangleFullLines[signKey_String] := Select[manualTriangleLines, manualTriangleSameBranchQ[signKey, #] &];

manualTriangleSectorName[{}] := "top";
manualTriangleSectorName[lines_List] := StringRiffle["e" <> ToString[#] & /@ Sort[lines], "_"];
manualTriangleShrunkLines["top"] := {};
manualTriangleShrunkLines[sector_String] := ToExpression /@ StringDrop[StringSplit[sector, "_"], 1];

manualTriangleSectors[signKey_String] := manualTriangleSectorName /@ Subsets[manualTriangleFullLines[signKey]];

manualTriangleRepMap[shrunk_List] := Module[
   {parent, pos, find, union},
   parent = AssociationThread[manualTriangleVertices -> manualTriangleVertices];
   pos = AssociationThread[manualTriangleVertices -> Range[Length[manualTriangleVertices]]];
   find[x_] := If[parent[x] === x, x, parent[x] = find[parent[x]]];
   union[x_, y_] := Module[{rx = find[x], ry = find[y], rep, other},
     If[rx === ry, Return[]];
     rep = If[pos[rx] <= pos[ry], rx, ry];
     other = If[rep === rx, ry, rx];
     parent[other] = rep;
     ];
   Scan[(union @@ manualTriangleLineEndpoints[#]) &, shrunk];
   Association[Table[v -> find[v], {v, manualTriangleVertices}]]
   ];

manualTriangleActiveVertices[sector_String] := DeleteDuplicates[
   Lookup[manualTriangleRepMap[manualTriangleShrunkLines[sector]], manualTriangleVertices]
   ];

manualTriangleASlot[sector_String, vertex_] := Module[
   {repMap = manualTriangleRepMap[manualTriangleShrunkLines[sector]], active},
   active = manualTriangleActiveVertices[sector];
   First@FirstPosition[active, Lookup[repMap, vertex]]
   ];

manualTriangleShiftA[J[aList_, packs_, isps_], sector_String, vertex_, delta_] := Module[
   {newA = aList, slot},
   slot = manualTriangleASlot[sector, vertex];
   newA[[slot]] = newA[[slot]] + delta;
   J[newA, packs, isps]
   ];

manualTriangleShiftB[J[aList_, packs_, isps_], line_Integer, delta_] := Module[
   {newPacks = packs},
   newPacks[[line, 1]] = newPacks[[line, 1]] + delta;
   J[aList, newPacks, isps]
   ];

manualTriangleSetMassiveN[J[aList_, packs_, isps_], line_Integer, endpointSlot_Integer, value_Integer] := Module[
   {newPacks = packs},
   newPacks[[line, endpointSlot + 1]] = value;
   J[aList, newPacks, isps]
   ];

manualTriangleToggleMassless[J[aList_, packs_, isps_]] := Module[
   {newPacks = packs},
   newPacks[[3, 2]] = 1 - newPacks[[3, 2]];
   J[aList, newPacks, isps]
   ];

manualTriangleAbsorb[factor_, int_J] := Expand[
   Coefficient[Expand[factor], z1] manualTriangleShiftB[int, 1, -2] +
    Coefficient[Expand[factor], z2] manualTriangleShiftB[int, 2, -2] +
    Coefficient[Expand[factor], z3] manualTriangleShiftB[int, 3, -2] +
    (Expand[factor] /. {z1 -> 0, z2 -> 0, z3 -> 0}) int
   ];

manualTriangleCanonical[expr_, sector_String] := Module[
   {repMap = manualTriangleRepMap[manualTriangleShrunkLines[sector]], endpoints},
   endpoints = Lookup[repMap, manualTriangleLineEndpoints[3]];
   Expand[
    expr /. (int_J /; Length[int[[2, 3]]] === 2 && int[[2, 3, 2]] === 1 && endpoints[[1]] === endpoints[[2]]) :> 0
    ]
   ];

manualTriangleLineShrinkShift[line_Integer] := If[manualTriangleLineMass[line] === "massive", 1, 0];
manualTriangleLineZeroShift[line_Integer] := If[manualTriangleLineMass[line] === "massive", 2 nuM, 0];

manualTriangleVertexZeroPoint[sector_String, vertex_] := Module[
   {shrunk = manualTriangleShrunkLines[sector], repMap, rep, class, classShrunk},
   repMap = manualTriangleRepMap[shrunk];
   rep = Lookup[repMap, vertex];
   class = Select[manualTriangleVertices, Lookup[repMap, #] === rep &];
   classShrunk = Select[
     shrunk,
     And @@ (Lookup[repMap, #] === rep & /@ manualTriangleLineEndpoints[#]) &
     ];
   Total[manualTriangleAlpha /@ class] - Total[manualTriangleLineZeroShift /@ classShrunk]
   ];

manualTriangleVertexEnergy[sector_String, vertex_] := Module[
   {repMap, rep, class},
   repMap = manualTriangleRepMap[manualTriangleShrunkLines[sector]];
   rep = Lookup[repMap, vertex];
   class = Select[manualTriangleVertices, Lookup[repMap, #] === rep &];
   Total[manualTriangleEnergy /@ class]
   ];

manualTriangleVertexBranch[signKey_String, sector_String, vertex_] := Module[
   {repMap, rep, signs = mixedTriangleSigns[signKey]},
   repMap = manualTriangleRepMap[manualTriangleShrunkLines[sector]];
   rep = Lookup[repMap, vertex];
   signs[[rep /. {v1 -> 1, v2 -> 2, v3 -> 3}]]
   ];

manualTriangleEndpointSlots[sector_String, vertex_, line_Integer] := Module[
   {repMap, rep, endpoints},
   repMap = manualTriangleRepMap[manualTriangleShrunkLines[sector]];
   rep = Lookup[repMap, vertex];
   endpoints = Lookup[repMap, manualTriangleLineEndpoints[line]];
   Flatten@Position[endpoints, rep]
   ];

manualTriangleShrinkIntegral[int_J, sector_String, line_Integer] := Module[
   {aList, packs, isps, shrunk, newSector, oldActive, newActive, repOld, repNew,
    newA, newPacks},
   {aList, packs, isps} = List @@ int;
   shrunk = manualTriangleShrunkLines[sector];
   newSector = manualTriangleSectorName[Union[shrunk, {line}]];
   oldActive = manualTriangleActiveVertices[sector];
   newActive = manualTriangleActiveVertices[newSector];
   repOld = manualTriangleRepMap[shrunk];
   repNew = manualTriangleRepMap[manualTriangleShrunkLines[newSector]];
   newA = Table[
     Module[{oldSlots = Flatten@Position[Lookup[repNew, oldActive], newActive[[i]]]},
      If[MemberQ[Lookup[repNew, manualTriangleLineEndpoints[line]], newActive[[i]]] &&
        SameQ @@ Lookup[repNew, manualTriangleLineEndpoints[line]],
       Total[aList[[oldSlots]]] - 1,
       Total[aList[[oldSlots]]]
       ]
      ],
     {i, Length[newActive]}
     ];
   newPacks = packs;
   newPacks[[line]] = {packs[[line, 1]] + manualTriangleLineShrinkShift[line]};
   manualTriangleCanonical[J[newA, newPacks, isps], newSector]
   ];

manualTriangleBaseIntegral[signKey_String, sector_String, stateRules_List] := Module[
   {shrunk = manualTriangleShrunkLines[sector], aList, packs},
   aList = ConstantArray[0, Length[manualTriangleActiveVertices[sector]]];
   packs = Table[
     Which[
      MemberQ[shrunk, line], {0},
      manualTriangleLineMass[line] === "massive", {0, n[line, 1] /. stateRules, n[line, 2] /. stateRules},
      manualTriangleSameBranchQ[signKey, line], {0, n[line] /. stateRules},
      True, {0}
      ],
     {line, manualTriangleLines}
     ];
   J[aList, packs, {}]
   ];

manualTriangleStateRules[signKey_String, sector_String] := Module[
   {shrunk = manualTriangleShrunkLines[sector], vars = {}},
   Do[
    If[! MemberQ[shrunk, line],
     If[manualTriangleLineMass[line] === "massive",
      vars = Join[vars, {n[line, 1], n[line, 2]}],
      If[manualTriangleSameBranchQ[signKey, line], vars = Append[vars, n[line]]]
      ]
     ],
    {line, manualTriangleLines}
    ];
   If[vars === {}, {{}}, Thread[vars -> #] & /@ Tuples[ConstantArray[{0, 1}, Length[vars]]]]
   ];

manualTriangleSeedRules[signKey_String, sector_String, stateRules_List] := Join[
   Thread[(a /@ manualTriangleActiveVertices[sector]) -> 0],
   Table[
    If[MemberQ[manualTriangleShrunkLines[sector], line],
     bS[line] -> 0,
     b[line] -> 0
     ],
    {line, manualTriangleLines}
    ],
   stateRules
   ];

(* ::Chapter:: *)
(*time-IBP 手推*)

manualTriangleMassiveTimeEndpoint[int_J, sector_String, line_Integer, endpointSlot_Integer] := Module[
   {nValue = int[[2, line, endpointSlot + 1]], endpointVertex},
   endpointVertex = manualTriangleLineEndpoints[line][[endpointSlot]];
   If[nValue === 0,
    -manualTriangleShiftB[manualTriangleSetMassiveN[int, line, endpointSlot, 1], line, -1],
    manualTriangleShiftB[manualTriangleSetMassiveN[int, line, endpointSlot, 0], line, -1] +
     manualTriangleMassiveC1 manualTriangleShiftA[int, sector, endpointVertex, -1]
    ]
   ];

manualTriangleMassiveBoundary[signKey_String, sector_String, int_J, line_Integer, endpointSlot_Integer] := Module[
   {n1 = int[[2, line, 2]], n2 = int[[2, line, 3]], nEndpoint, sk},
   If[n1 + n2 =!= 1, Return[0]];
   sk = manualTriangleLineSk[signKey, line];
   nEndpoint = If[endpointSlot === 1, n1, n2];
   manualTriangleMassiveShrinkPrefactor *
    (-1)^(nEndpoint + manualTriangleVpm[sk]) *
    manualTriangleShrinkIntegral[int, sector, line]
   ];

manualTriangleMasslessTimeTerms[signKey_String, sector_String, int_J, slots_List] := Module[
   {sameBranch, sigma, nValue, branchSigns, regular, boundary},
   If[slots === {}, Return[0]];
   sameBranch = manualTriangleSameBranchQ[signKey, 3];
   If[sameBranch,
    sigma = If[manualTriangleLineSk[signKey, 3] === "++", 1, -1];
    nValue = int[[2, 3, 2]];
    regular = Total[
      Table[
       I sigma If[slot === 1, 1, -1] *
        manualTriangleShiftB[manualTriangleToggleMassless[int], 3, -1],
       {slot, slots}
       ]
      ];
    boundary = If[Length[slots] === 1 && nValue === 1,
      -2 If[First[slots] === 1, 1, -1] *
       manualTriangleShrinkIntegral[int, sector, 3],
      0
      ],
    branchSigns = manualTriangleBranchSign /@ manualTriangleLineSigns[signKey, 3];
    regular = Total[
      Table[
       I branchSigns[[slot]] manualTriangleShiftB[int, 3, -1],
       {slot, slots}
       ]
      ];
    boundary = 0
    ];
   Expand[regular + boundary]
   ];

manualTriangleTimeLineTerms[signKey_String, sector_String, int_J, vertex_, line_Integer] := Module[
   {slots},
   If[MemberQ[manualTriangleShrunkLines[sector], line], Return[0]];
   slots = manualTriangleEndpointSlots[sector, vertex, line];
   If[manualTriangleLineMass[line] === "massive",
    Total[
     Table[
      manualTriangleMassiveTimeEndpoint[int, sector, line, slot] +
       If[Length[slots] === 1 && manualTriangleSameBranchQ[signKey, line],
        manualTriangleMassiveBoundary[signKey, sector, int, line, slot],
        0
        ],
      {slot, slots}
      ]
     ],
    manualTriangleMasslessTimeTerms[signKey, sector, int, slots]
    ]
   ];

manualTriangleTimeEquation[signKey_String, sector_String, stateRules_List, vertex_] := Module[
   {int, power, phase, lineTerms},
   int = manualTriangleBaseIntegral[signKey, sector, stateRules];
   power = -manualTriangleVertexZeroPoint[sector, vertex] *
     manualTriangleShiftA[int, sector, vertex, -1];
   phase = manualTrianglePhase[manualTriangleVertexBranch[signKey, sector, vertex]] *
     manualTriangleVertexEnergy[sector, vertex] int;
   lineTerms = Total[manualTriangleTimeLineTerms[signKey, sector, int, vertex, #] & /@ manualTriangleLines];
   manualTriangleCanonical[Expand[power + phase + lineTerms], sector]
   ];

(* ::Chapter:: *)
(*momentum-IBP 手推*)

manualTriangleVDotQ["loop", 1, 1] := z1;
manualTriangleVDotQ["loop", 1, 2] := (z1 - s11 + z2)/2;
manualTriangleVDotQ["loop", 1, 3] := (z1 + z3 - s22)/2;
manualTriangleVDotQ["external", 1, 1] := (z1 + s11 - z2)/2;
manualTriangleVDotQ["external", 1, 2] := (z1 - s11 - z2)/2;
manualTriangleVDotQ["external", 1, 3] := (z1 + s11 - z2)/2 + s12;
manualTriangleVDotQ["external", 2, 1] := (z3 - z1 - s22)/2;
manualTriangleVDotQ["external", 2, 2] := (z3 - z1 - s22)/2 - s12;
manualTriangleVDotQ["external", 2, 3] := (z3 - z1 + s22)/2;

manualTriangleLineZeroPoint[sector_String, line_Integer] := If[
   MemberQ[manualTriangleShrunkLines[sector], line],
   manualTriangleBeta[line] + manualTriangleLineZeroShift[line],
   manualTriangleBeta[line]
   ];

manualTriangleMassiveMomentumEndpoint[int_J, sector_String, line_Integer, endpointSlot_Integer, factor_] := Module[
   {nValue = int[[2, line, endpointSlot + 1]], endpointVertex},
   endpointVertex = manualTriangleLineEndpoints[line][[endpointSlot]];
   If[nValue === 0,
    manualTriangleAbsorb[
     factor,
     manualTriangleShiftA[
      manualTriangleShiftB[manualTriangleSetMassiveN[int, line, endpointSlot, 1], line, 1],
      sector, endpointVertex, 1]
     ],
    -manualTriangleAbsorb[
      factor,
      manualTriangleShiftA[
       manualTriangleShiftB[manualTriangleSetMassiveN[int, line, endpointSlot, 0], line, 1],
       sector, endpointVertex, 1]
      ] -
     manualTriangleMassiveC1 manualTriangleAbsorb[
      factor,
      manualTriangleShiftB[int, line, 2]
      ]
    ]
   ];

manualTriangleMasslessMomentumBuilding[signKey_String, sector_String, int_J, factor_] := Module[
   {sameBranch, sigma, endpoints, branchSigns, shifted},
   sameBranch = manualTriangleSameBranchQ[signKey, 3];
   endpoints = manualTriangleLineEndpoints[3];
   If[sameBranch,
    sigma = If[manualTriangleLineSk[signKey, 3] === "++", 1, -1];
    shifted = manualTriangleShiftB[manualTriangleToggleMassless[int], 3, 1];
    -I sigma manualTriangleAbsorb[
      factor,
      manualTriangleShiftA[shifted, sector, endpoints[[1]], 1]
      ] +
     I sigma manualTriangleAbsorb[
      factor,
      manualTriangleShiftA[shifted, sector, endpoints[[2]], 1]
      ],
    branchSigns = manualTriangleBranchSign /@ manualTriangleLineSigns[signKey, 3];
    shifted = manualTriangleShiftB[int, 3, 1];
    Total[
     Table[
      -I branchSigns[[slot]] manualTriangleAbsorb[
        factor,
        manualTriangleShiftA[shifted, sector, endpoints[[slot]], 1]
        ],
      {slot, 2}
      ]
     ]
    ]
   ];

manualTriangleMomentumLineTerms[signKey_String, sector_String, int_J, vectorType_String, vectorIndex_Integer, line_Integer] := Module[
   {factor, denominator},
   factor = manualTriangleVDotQ[vectorType, vectorIndex, line];
   denominator = -manualTriangleLineZeroPoint[sector, line] *
     manualTriangleAbsorb[factor, manualTriangleShiftB[int, line, 2]];
   If[MemberQ[manualTriangleShrunkLines[sector], line],
    Return[Expand[denominator]]
    ];
   If[manualTriangleLineMass[line] === "massive",
    Expand[
     denominator +
      Total[manualTriangleMassiveMomentumEndpoint[int, sector, line, #, factor] & /@ {1, 2}]
     ],
    Expand[
     denominator +
      manualTriangleMasslessMomentumBuilding[signKey, sector, int, factor]
     ]
    ]
   ];

manualTriangleMomentumEquation[signKey_String, sector_String, stateRules_List, vectorType_String, vectorIndex_Integer] := Module[
   {int, divergence},
   int = manualTriangleBaseIntegral[signKey, sector, stateRules];
   divergence = If[vectorType === "loop", dim int, 0];
   manualTriangleCanonical[
    Expand[
     divergence +
      Total[
       manualTriangleMomentumLineTerms[signKey, sector, int, vectorType, vectorIndex, #] & /@ manualTriangleLines
       ]
     ],
    sector
    ]
   ];

(* ::Chapter:: *)
(*扁平 expectedRelations*)

manualTriangleGenerators[sector_String] := Join[
   {"time", #} & /@ manualTriangleActiveVertices[sector],
   {
    {"momentum", 1, "loop", 1},
    {"momentum", 1, "external", 1},
    {"momentum", 1, "external", 2}
    }
   ];

manualTriangleEquation[signKey_String, sector_String, stateRules_List, {"time", vertex_}] :=
   manualTriangleTimeEquation[signKey, sector, stateRules, vertex];

manualTriangleEquation[
   signKey_String, sector_String, stateRules_List,
   {"momentum", 1, vectorType_String, vectorIndex_Integer}] :=
   manualTriangleMomentumEquation[signKey, sector, stateRules, vectorType, vectorIndex];

expectedRelations = Flatten[
   Table[
    Table[
     Table[
      Table[
       <|
        "sector" -> sector,
        "vertexSigns" -> signKey,
        "generator" -> generator,
        "seedRules" -> manualTriangleSeedRules[signKey, sector, stateRules],
        "equation" -> manualTriangleEquation[signKey, sector, stateRules, generator],
        "tags" -> DeleteCases[
          {
           "mixedTriangle",
           If[sector === "top", "top", "shrinkSector"],
           If[MemberQ[Values[Association[stateRules]], 1], "containsN1", Nothing]
           },
          Nothing
          ]
        |>,
       {generator, manualTriangleGenerators[sector]}
       ],
      {stateRules, manualTriangleStateRules[signKey, sector]}
      ],
     {sector, manualTriangleSectors[signKey]}
     ],
    {signKey, Keys[mixedTriangleSigns]}
    ]
   ];

manualTriangleExpectedCounts = Counts[
   ({#["vertexSigns"], #["sector"]} &) /@ expectedRelations
   ];

manualTriangleExpectedTotal = Length[expectedRelations];
