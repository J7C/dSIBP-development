(* ::Package:: *)
(* 独立手推 helper：从 familyDefinition 生成 seed-level time/q-IBP expected。
   本文件不加载 009 package，只使用 benchmark 文档中的通用公式。 *)

(* ::Chapter:: *)
(*基本工具*)

SetAttributes[sp, Orderless];

manualLinearTerms[expr_] := Module[{expanded = Expand[expr]},
   If[Head[expanded] === Plus, List @@ expanded, {expanded}]
   ];

manualVertexPosition[def_Association, vertex_] := First@FirstPosition[def["vertexOrder"], vertex];
manualLineIds[def_Association] := Lookup[def["lineData"], "id"];
manualLinePosition[def_Association, lineId_] := First@FirstPosition[manualLineIds[def], lineId];
manualLineById[def_Association, lineId_] := def["lineData"][[manualLinePosition[def, lineId]]];
manualLineEndpoints[def_Association, lineId_] := manualLineById[def, lineId]["endpoints"];
manualLineMass[def_Association, lineId_] := manualLineById[def, lineId]["massType"];
manualLineNu[def_Association, lineId_] := Lookup[manualLineById[def, lineId], "nu", nu];

manualZeroPoint[def_Association, lhs_, default_: 0] := Module[{hits},
   hits = Cases[Lookup[def, "zeroPointRules", {}], (Rule | RuleDelayed)[x_, y_] /; x === lhs :> y];
   If[hits === {}, default, Last[hits]]
   ];

manualAlpha[def_Association, vertex_] := manualZeroPoint[def, a0[vertex]];
manualBeta[def_Association, lineId_] := manualZeroPoint[def, b0[lineId]];
manualBetaS[def_Association, lineId_] := manualZeroPoint[def, bS0[lineId], manualBeta[def, lineId]];
manualLineZeroShift[def_Association, lineId_] := If[manualLineMass[def, lineId] === "massive", 2 manualLineNu[def, lineId], 0];
manualLineShrinkBShift[def_Association, lineId_] := If[manualLineMass[def, lineId] === "massive", 1, 0];

manualPhase["+"] := -I;
manualPhase["-"] := I;
manualBranchSign["+"] := 1;
manualBranchSign["-"] := -1;
manualVpm["++"] := 1;
manualVpm["--"] := 0;
manualMassiveC1[def_Association, lineId_] := 2 manualLineNu[def, lineId] + 1;
manualMassiveShrinkPrefactor[def_Association, lineId_] := (4 I/Pi) Exp[Pi Im[manualLineNu[def, lineId]]];

manualLineSigns[def_Association, signKey_String, lineId_] := Module[
   {signs = def["vertexSignCases"][signKey], endpoints},
   endpoints = manualLineEndpoints[def, lineId];
   signs[[manualVertexPosition[def, #] & /@ endpoints]]
   ];

manualSameBranchQ[def_Association, signKey_String, lineId_] := SameQ @@ manualLineSigns[def, signKey, lineId];
manualLineSk[def_Association, signKey_String, lineId_] := StringJoin[manualLineSigns[def, signKey, lineId]];
manualFullLines[def_Association, signKey_String] := Select[manualLineIds[def], manualSameBranchQ[def, signKey, #] &];

manualSectorName[{}] := "top";
manualSectorName[lines_List] := StringRiffle["e" <> ToString[#] & /@ Sort[lines], "_"];
manualShrunkLines["top"] := {};
manualShrunkLines[sector_String] := ToExpression /@ StringDrop[StringSplit[sector, "_"], 1];
manualSectors[def_Association, signKey_String] := manualSectorName /@ Subsets[manualFullLines[def, signKey]];

(* ::Chapter:: *)
(*sector 合并与 J 指标操作*)

manualRepMap[def_Association, shrunk_List] := Module[
   {vertices = def["vertexOrder"], parent, pos, find, union},
   parent = AssociationThread[vertices -> vertices];
   pos = AssociationThread[vertices -> Range[Length[vertices]]];
   find[x_] := If[parent[x] === x, x, parent[x] = find[parent[x]]];
   union[x_, y_] := Module[{rx = find[x], ry = find[y], rep, other},
     If[rx === ry, Return[]];
     rep = If[pos[rx] <= pos[ry], rx, ry];
     other = If[rep === rx, ry, rx];
     parent[other] = rep;
     ];
   Scan[(union @@ manualLineEndpoints[def, #]) &, shrunk];
   Association[Table[v -> find[v], {v, vertices}]]
   ];

manualActiveVertices[def_Association, sector_String] := DeleteDuplicates[
   Lookup[manualRepMap[def, manualShrunkLines[sector]], def["vertexOrder"]]
   ];

manualASlot[def_Association, sector_String, vertex_] := Module[{active, rep},
   active = manualActiveVertices[def, sector];
   rep = Lookup[manualRepMap[def, manualShrunkLines[sector]], vertex];
   First@FirstPosition[active, rep]
   ];

manualShiftA[def_Association, J[aList_, packs_, isps_], sector_String, vertex_, delta_] := Module[
   {newA = aList, slot},
   slot = manualASlot[def, sector, vertex];
   newA[[slot]] = newA[[slot]] + delta;
   J[newA, packs, isps]
   ];

manualShiftB[J[aList_, packs_, isps_], line_Integer, delta_] := Module[{newPacks = packs},
   newPacks[[line, 1]] = newPacks[[line, 1]] + delta;
   J[aList, newPacks, isps]
   ];

manualShiftISP[J[aList_, packs_, isps_], r_Integer, delta_] := Module[{newIsps = isps},
   newIsps[[r]] = newIsps[[r]] + delta;
   J[aList, packs, newIsps]
   ];

manualSetN[J[aList_, packs_, isps_], line_Integer, endpointSlot_Integer, value_Integer] := Module[
   {newPacks = packs},
   newPacks[[line, endpointSlot + 1]] = value;
   J[aList, newPacks, isps]
   ];

manualToggleMassless[J[aList_, packs_, isps_], line_Integer] := Module[{newPacks = packs},
   newPacks[[line, 2]] = 1 - newPacks[[line, 2]];
   J[aList, newPacks, isps]
   ];

manualCanonical[def_Association, expr_, sector_String] := Module[
   {repMap = manualRepMap[def, manualShrunkLines[sector]], lineIds = manualLineIds[def]},
   Expand[
    expr /. (int_J /; AnyTrue[lineIds,
         Function[lineId,
          Module[{line = manualLinePosition[def, lineId], endpoints},
           endpoints = Lookup[repMap, manualLineEndpoints[def, lineId]];
           manualLineMass[def, lineId] === "massless" &&
            Length[int[[2, line]]] === 2 &&
            int[[2, line, 2]] === 1 &&
            endpoints[[1]] === endpoints[[2]]
           ]
          ]
         ]) :> 0
    ]
   ];

manualShrinkIntegral[def_Association, int_J, sector_String, lineId_] := Module[
   {aList, packs, isps, shrunk, newSector, oldActive, newActive, repNew,
    newA, linePos},
   {aList, packs, isps} = List @@ int;
   shrunk = manualShrunkLines[sector];
   newSector = manualSectorName[Union[shrunk, {lineId}]];
   oldActive = manualActiveVertices[def, sector];
   newActive = manualActiveVertices[def, newSector];
   repNew = manualRepMap[def, manualShrunkLines[newSector]];
   newA = Table[
     Module[{oldSlots = Flatten@Position[Lookup[repNew, oldActive], newActive[[i]]]},
      If[MemberQ[Lookup[repNew, manualLineEndpoints[def, lineId]], newActive[[i]]] &&
        SameQ @@ Lookup[repNew, manualLineEndpoints[def, lineId]],
       Total[aList[[oldSlots]]] - 1,
       Total[aList[[oldSlots]]]
       ]
      ],
     {i, Length[newActive]}
     ];
   linePos = manualLinePosition[def, lineId];
   packs[[linePos]] = {packs[[linePos, 1]] + manualLineShrinkBShift[def, lineId]};
   manualCanonical[def, J[newA, packs, isps], newSector]
   ];

manualVertexZeroPoint[def_Association, sector_String, vertex_] := Module[
   {shrunk = manualShrunkLines[sector], repMap, rep, class, classShrunk},
   repMap = manualRepMap[def, shrunk];
   rep = Lookup[repMap, vertex];
   class = Select[def["vertexOrder"], Lookup[repMap, #] === rep &];
   classShrunk = Select[shrunk, And @@ (Lookup[repMap, #] === rep & /@ manualLineEndpoints[def, #]) &];
   Total[manualAlpha[def, #] & /@ class] - Total[manualLineZeroShift[def, #] & /@ classShrunk]
   ];

manualLineZeroPoint[def_Association, sector_String, lineId_] := If[
   MemberQ[manualShrunkLines[sector], lineId],
   manualBeta[def, lineId] + manualLineZeroShift[def, lineId],
   manualBeta[def, lineId]
   ];

manualVertexEnergy[def_Association, signKey_String, sector_String, vertex_] := Module[
   {repMap, rep, class, energyAssoc},
   energyAssoc = If[
     KeyExistsQ[def, "vertexEnergyCases"],
     def["vertexEnergyCases"][signKey],
     def["vertexEnergies"]
     ];
   repMap = manualRepMap[def, manualShrunkLines[sector]];
   rep = Lookup[repMap, vertex];
   class = Select[def["vertexOrder"], Lookup[repMap, #] === rep &];
   Total[Lookup[energyAssoc, #] & /@ class]
   ];

manualVertexBranch[def_Association, signKey_String, sector_String, vertex_] := Module[
   {repMap, rep, signs = def["vertexSignCases"][signKey]},
   repMap = manualRepMap[def, manualShrunkLines[sector]];
   rep = Lookup[repMap, vertex];
   signs[[manualVertexPosition[def, rep]]]
   ];

manualEndpointSlots[def_Association, sector_String, vertex_, lineId_] := Module[
   {repMap, rep, endpoints},
   repMap = manualRepMap[def, manualShrunkLines[sector]];
   rep = Lookup[repMap, vertex];
   endpoints = Lookup[repMap, manualLineEndpoints[def, lineId]];
   Flatten@Position[endpoints, rep]
   ];

manualBaseIntegral[def_Association, signKey_String, sector_String, stateRules_List, ispRules_List] := Module[
   {shrunk = manualShrunkLines[sector], aList, packs, lineIds = manualLineIds[def]},
   aList = ConstantArray[0, Length[manualActiveVertices[def, sector]]];
   packs = Table[
     Which[
      MemberQ[shrunk, lineId], {0},
      manualLineMass[def, lineId] === "massive",
      {0, n[lineId, 1] /. stateRules, n[lineId, 2] /. stateRules},
      manualSameBranchQ[def, signKey, lineId],
      {0, n[lineId] /. stateRules},
      True, {0}
      ],
     {lineId, lineIds}
     ];
   J[aList, packs, Table[ispN[r] /. ispRules, {r, Length[Lookup[def, "ispData", {}]]}]]
   ];

manualStateRules[def_Association, signKey_String, sector_String] := Module[
   {shrunk = manualShrunkLines[sector], vars = {}},
   Do[
    If[! MemberQ[shrunk, lineId],
     If[manualLineMass[def, lineId] === "massive",
      vars = Join[vars, {n[lineId, 1], n[lineId, 2]}],
      If[manualSameBranchQ[def, signKey, lineId], vars = Append[vars, n[lineId]]]
      ]
     ],
    {lineId, manualLineIds[def]}
    ];
   If[vars === {}, {{}}, Thread[vars -> #] & /@ Tuples[ConstantArray[{0, 1}, Length[vars]]]]
   ];

manualISPRules[def_Association] := Module[{n = Length[Lookup[def, "ispData", {}]], seeds},
   seeds = Lookup[def, "ispSeedRules", Automatic];
   Which[
    n === 0, {{}},
    ListQ[seeds], seeds,
    True, Module[{zeroSeed = Thread[Table[ispN[r], {r, n}] -> ConstantArray[0, n]]},
      Join[
       {zeroSeed},
       Table[ReplacePart[zeroSeed, r -> (ispN[r] -> 1)], {r, n}]
       ]
      ]
    ]
   ];

manualSeedRules[def_Association, signKey_String, sector_String, stateRules_List, ispRules_List] := Join[
   Thread[(a /@ manualActiveVertices[def, sector]) -> 0],
   Table[
    If[MemberQ[manualShrunkLines[sector], lineId], bS[lineId] -> 0, b[lineId] -> 0],
    {lineId, manualLineIds[def]}
    ],
   stateRules,
   ispRules
   ];

(* ::Chapter:: *)
(*time-IBP*)

manualMassiveTimeEndpoint[def_Association, int_J, sector_String, lineId_, endpointSlot_Integer] := Module[
   {line = manualLinePosition[def, lineId], nValue, endpointVertex},
   nValue = int[[2, line, endpointSlot + 1]];
   endpointVertex = manualLineEndpoints[def, lineId][[endpointSlot]];
   If[nValue === 0,
    -manualShiftB[manualSetN[int, line, endpointSlot, 1], line, -1],
    manualShiftB[manualSetN[int, line, endpointSlot, 0], line, -1] +
     manualMassiveC1[def, lineId] manualShiftA[def, int, sector, endpointVertex, -1]
    ]
   ];

manualMassiveBoundary[def_Association, signKey_String, sector_String, int_J, lineId_, endpointSlot_Integer] := Module[
   {line = manualLinePosition[def, lineId], n1, n2, nEndpoint, sk},
   {n1, n2} = int[[2, line, {2, 3}]];
   If[n1 + n2 =!= 1, Return[0]];
   sk = manualLineSk[def, signKey, lineId];
   nEndpoint = If[endpointSlot === 1, n1, n2];
   manualMassiveShrinkPrefactor[def, lineId] *
    (-1)^(nEndpoint + manualVpm[sk]) *
    manualShrinkIntegral[def, int, sector, lineId]
   ];

manualMasslessTimeTerms[def_Association, signKey_String, sector_String, int_J, lineId_, slots_List] := Module[
   {sameBranch, sigma, nValue, branchSigns, regular, boundary, line = manualLinePosition[def, lineId]},
   If[slots === {}, Return[0]];
   sameBranch = manualSameBranchQ[def, signKey, lineId];
   If[sameBranch,
    sigma = If[manualLineSk[def, signKey, lineId] === "++", 1, -1];
    nValue = int[[2, line, 2]];
    regular = Total[
      I sigma If[# === 1, 1, -1] manualShiftB[manualToggleMassless[int, line], line, -1] & /@ slots
      ];
    boundary = If[Length[slots] === 1 && nValue === 1,
      -2 If[First[slots] === 1, 1, -1] manualShrinkIntegral[def, int, sector, lineId],
      0
      ],
    branchSigns = manualBranchSign /@ manualLineSigns[def, signKey, lineId];
    regular = Total[
      I branchSigns[[#]] manualShiftB[int, line, -1] & /@ slots
      ];
    boundary = 0
    ];
   Expand[regular + boundary]
   ];

manualTimeLineTerms[def_Association, signKey_String, sector_String, int_J, vertex_, lineId_] := Module[
   {slots},
   If[MemberQ[manualShrunkLines[sector], lineId], Return[0]];
   slots = manualEndpointSlots[def, sector, vertex, lineId];
   If[manualLineMass[def, lineId] === "massive",
    Total[
     Table[
      manualMassiveTimeEndpoint[def, int, sector, lineId, slot] +
       If[Length[slots] === 1 && manualSameBranchQ[def, signKey, lineId],
        manualMassiveBoundary[def, signKey, sector, int, lineId, slot],
        0
        ],
      {slot, slots}
      ]
     ],
    manualMasslessTimeTerms[def, signKey, sector, int, lineId, slots]
    ]
   ];

manualTimeEquation[def_Association, signKey_String, sector_String, stateRules_List, ispRules_List, vertex_] := Module[
   {int, power, phase, lineTerms},
   int = manualBaseIntegral[def, signKey, sector, stateRules, ispRules];
   power = -manualVertexZeroPoint[def, sector, vertex] manualShiftA[def, int, sector, vertex, -1];
   phase = manualPhase[manualVertexBranch[def, signKey, sector, vertex]] manualVertexEnergy[def, signKey, sector, vertex] int;
   lineTerms = Total[manualTimeLineTerms[def, signKey, sector, int, vertex, #] & /@ manualLineIds[def]];
   manualCanonical[def, Expand[power + phase + lineTerms], sector]
   ];

(* ::Chapter:: *)
(*momentum-IBP*)

manualSPVars[def_Association] := Module[{loops = def["loopMomenta"], exts = def["externalMomenta"]},
   Join[
    Flatten[Table[sp[loops[[i]], loops[[j]]], {i, Length[loops]}, {j, i, Length[loops]}]],
    Flatten[Table[sp[loops[[i]], exts[[j]]], {i, Length[loops]}, {j, Length[exts]}]]
    ]
   ];

manualExpandDot[p_, r_, def_Association] := Module[
   {basis = Join[def["loopMomenta"], def["externalMomenta"]], cp, cr, raw},
   cp = Coefficient[p, #] & /@ basis;
   cr = Coefficient[r, #] & /@ basis;
   raw = Sum[cp[[i]] cr[[j]] sp[basis[[i]], basis[[j]]], {i, Length[basis]}, {j, Length[basis]}];
   Expand[raw /. Lookup[def, "externalInvariantRules", {}]]
   ];

manualScalarRules[def_Association] := Module[
   {spVars, zVars, zExprs, ispVars, ispExprs, coordExprs, coordVars, mat, const, sol},
   spVars = manualSPVars[def];
   zVars = z /@ manualLineIds[def];
   zExprs = manualExpandDot[#["momentum"], #["momentum"], def] & /@ def["lineData"];
   ispVars = Table[rho[r], {r, Length[Lookup[def, "ispData", {}]]}];
   ispExprs = Lookup[Lookup[def, "ispData", {}], "expression", {}];
   If[ispExprs === {}, ispExprs = Lookup[Lookup[def, "ispData", {}], "expr", {}]];
   ispExprs = manualExpandDot[1, 1, def] 0 + # & /@ ispExprs;
   coordExprs = Join[zExprs, Expand /@ ispExprs];
   coordVars = Join[zVars, ispVars];
   If[Length[coordExprs] =!= Length[spVars], Return[$Failed]];
   mat = Table[Coefficient[coordExprs[[i]], spVars[[j]]], {i, Length[coordExprs]}, {j, Length[spVars]}];
   const = coordExprs /. Thread[spVars -> 0];
   sol = Check[LinearSolve[mat, coordVars - const], $Failed];
   If[sol === $Failed, Return[$Failed]];
   Thread[spVars -> (Expand /@ sol)]
   ];

manualAbsorbTerm[def_Association, term_, int_J] := Module[
   {vars = Join[z /@ manualLineIds[def], Table[rho[r], {r, Length[Lookup[def, "ispData", {}]]}]],
    rules, rebuild},
   If[vars === {}, Return[term int]];
   rebuild[powers_] := Times @@ MapThread[#1^#2 &, {vars, powers}];
   rules = CoefficientRules[term, vars];
   Total[
    rules /. (powers_ -> coeff_) :> Module[{degree = Total[powers], pos, var},
       If[degree === 0, coeff int,
        If[degree === 1 && Count[powers, 1] === 1 && Count[powers, Except[0 | 1]] === 0,
         pos = First@FirstPosition[powers, 1];
         var = vars[[pos]];
         Which[
          MatchQ[var, z[_]], coeff manualShiftB[int, manualLinePosition[def, var[[1]]], -2],
          MatchQ[var, rho[_]], coeff manualShiftISP[int, var[[1]], 1],
          True, coeff var int
          ],
         coeff rebuild[powers] int
         ]
        ]
       ]
    ]
   ];

manualAbsorb[def_Association, factor_, int_J] := Total[manualAbsorbTerm[def, #, int] & /@ manualLinearTerms[factor]];

manualVDotQ[def_Association, scalarRules_, vectorType_String, vectorIndex_Integer, lineId_] := Module[
   {vector, qLine},
   vector = If[vectorType === "loop", def["loopMomenta"][[vectorIndex]], def["externalMomenta"][[vectorIndex]]];
   qLine = manualLineById[def, lineId]["momentum"];
   Expand[manualExpandDot[vector, qLine, def] /. scalarRules]
   ];

manualMassiveMomentumEndpoint[def_Association, int_J, sector_String, lineId_, endpointSlot_Integer, factor_] := Module[
   {line = manualLinePosition[def, lineId], nValue, endpointVertex},
   nValue = int[[2, line, endpointSlot + 1]];
   endpointVertex = manualLineEndpoints[def, lineId][[endpointSlot]];
   If[nValue === 0,
    manualAbsorb[def, factor,
     manualShiftA[def, manualShiftB[manualSetN[int, line, endpointSlot, 1], line, 1], sector, endpointVertex, 1]],
    -manualAbsorb[def, factor,
      manualShiftA[def, manualShiftB[manualSetN[int, line, endpointSlot, 0], line, 1], sector, endpointVertex, 1]] -
     manualMassiveC1[def, lineId] manualAbsorb[def, factor, manualShiftB[int, line, 2]]
    ]
   ];

manualMasslessMomentumBuilding[def_Association, signKey_String, sector_String, int_J, lineId_, factor_] := Module[
   {sameBranch, sigma, endpoints, branchSigns, shifted, line = manualLinePosition[def, lineId]},
   sameBranch = manualSameBranchQ[def, signKey, lineId];
   endpoints = manualLineEndpoints[def, lineId];
   If[sameBranch,
    sigma = If[manualLineSk[def, signKey, lineId] === "++", 1, -1];
    shifted = manualShiftB[manualToggleMassless[int, line], line, 1];
    -I sigma manualAbsorb[def, factor, manualShiftA[def, shifted, sector, endpoints[[1]], 1]] +
     I sigma manualAbsorb[def, factor, manualShiftA[def, shifted, sector, endpoints[[2]], 1]],
    branchSigns = manualBranchSign /@ manualLineSigns[def, signKey, lineId];
    shifted = manualShiftB[int, line, 1];
    Total[
     Table[
      -I branchSigns[[slot]] manualAbsorb[def, factor, manualShiftA[def, shifted, sector, endpoints[[slot]], 1]],
      {slot, 2}
      ]
     ]
    ]
   ];

manualDirectionalSPDerivative[def_Association, expr_, loop_, vector_] := Expand[
   expr /. sp[x_, y_] :>
     Coefficient[x, loop] manualExpandDot[vector, y, def] +
      Coefficient[y, loop] manualExpandDot[x, vector, def]
   ];

manualISPDerivativeTerms[def_Association, scalarRules_, int_J, dLoop_Integer, vectorType_String, vectorIndex_Integer] := Module[
   {ispData = Lookup[def, "ispData", {}], vector, loop, expr, deriv},
   If[ispData === {}, Return[0]];
   vector = If[vectorType === "loop", def["loopMomenta"][[vectorIndex]], def["externalMomenta"][[vectorIndex]]];
   loop = def["loopMomenta"][[dLoop]];
   Total[
    Table[
     If[int[[3, r]] === 0, 0,
      expr = Lookup[ispData[[r]], "expression", Lookup[ispData[[r]], "expr"]];
      deriv = Expand[manualDirectionalSPDerivative[def, expr, loop, vector] /. scalarRules];
      int[[3, r]] manualAbsorb[def, deriv, manualShiftISP[int, r, -1]]
      ],
     {r, Length[ispData]}
     ]
    ]
   ];

manualMomentumLineTerms[def_Association, signKey_String, sector_String, scalarRules_, int_J, dLoop_Integer, vectorType_String, vectorIndex_Integer, lineId_] := Module[
   {line = manualLinePosition[def, lineId], loopCoeff, factor, denominator},
   loopCoeff = Coefficient[manualLineById[def, lineId]["momentum"], def["loopMomenta"][[dLoop]]];
   If[loopCoeff === 0, Return[0]];
   factor = manualVDotQ[def, scalarRules, vectorType, vectorIndex, lineId];
   denominator = -loopCoeff manualLineZeroPoint[def, sector, lineId] *
     manualAbsorb[def, factor, manualShiftB[int, line, 2]];
   If[MemberQ[manualShrunkLines[sector], lineId], Return[Expand[denominator]]];
   If[manualLineMass[def, lineId] === "massive",
    Expand[denominator + loopCoeff Total[
       manualMassiveMomentumEndpoint[def, int, sector, lineId, #, factor] & /@ {1, 2}
       ]],
    Expand[denominator + loopCoeff manualMasslessMomentumBuilding[def, signKey, sector, int, lineId, factor]]
    ]
   ];

manualMomentumEquation[def_Association, signKey_String, sector_String, stateRules_List, ispRules_List, dLoop_Integer, vectorType_String, vectorIndex_Integer] := Module[
   {int, scalarRules, divergence, lineTerms, ispTerms},
   int = manualBaseIntegral[def, signKey, sector, stateRules, ispRules];
   scalarRules = manualScalarRules[def];
   If[scalarRules === $Failed, Return[$Failed]];
   divergence = If[vectorType === "loop" && dLoop === vectorIndex, dim int, 0];
   lineTerms = Total[
     manualMomentumLineTerms[def, signKey, sector, scalarRules, int, dLoop, vectorType, vectorIndex, #] & /@ manualLineIds[def]
     ];
   ispTerms = manualISPDerivativeTerms[def, scalarRules, int, dLoop, vectorType, vectorIndex];
   manualCanonical[def, Expand[divergence + lineTerms + ispTerms], sector]
   ];

(* ::Chapter:: *)
(*扁平 relations*)

manualGeneratorList[def_Association, sector_String] := Join[
   {"time", #} & /@ manualActiveVertices[def, sector],
   Flatten[
    {
     Table[{"momentum", l, "loop", m}, {l, Length[def["loopMomenta"]]}, {m, Length[def["loopMomenta"]]}],
     Table[{"momentum", l, "external", j}, {l, Length[def["loopMomenta"]]}, {j, Length[def["externalMomenta"]]}]
     },
    2
    ]
   ];

manualEquation[def_Association, signKey_, sector_, stateRules_, ispRules_, {"time", vertex_}] :=
   manualTimeEquation[def, signKey, sector, stateRules, ispRules, vertex];

manualEquation[def_Association, signKey_, sector_, stateRules_, ispRules_, {"momentum", l_, vectorType_, vectorIndex_}] :=
   manualMomentumEquation[def, signKey, sector, stateRules, ispRules, l, vectorType, vectorIndex];

manualExpectedRelations[def_Association] := Flatten[
   Table[
    Table[
     Table[
      Table[
       Table[
        <|
         "sector" -> sector,
         "vertexSigns" -> signKey,
         "generator" -> generator,
         "seedRules" -> manualSeedRules[def, signKey, sector, stateRules, ispRules],
         "equation" -> manualEquation[def, signKey, sector, stateRules, ispRules, generator],
         "tags" -> DeleteCases[
           {
            Lookup[def, "name", "manualFamily"],
            If[sector === "top", "top", "shrinkSector"],
            If[MemberQ[Values[Association[stateRules]], 1], "containsN1", Nothing],
            If[MemberQ[Values[Association[ispRules]], 1], "containsISP1", Nothing]
            },
           Nothing
           ]
         |>,
        {generator, manualGeneratorList[def, sector]}
        ],
       {ispRules, manualISPRules[def]}
       ],
      {stateRules, manualStateRules[def, signKey, sector]}
      ],
     {sector, manualSectors[def, signKey]}
     ],
    {signKey, Keys[def["vertexSignCases"]]}
    ]
   ];
