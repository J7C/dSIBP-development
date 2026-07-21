(* ::Package:: *)
(* 本文件是 Codex 独立 benchmark 的公式 oracle。它只把任务书中的原始 SK kernel、
   Hankel EOM、共同-theta odd-subset 和 J 指标 convention 机械化；禁止加载 package
   或项目旧 hand-derived helper。输入是 familyDefinition，输出是扁平 expected records。 *)

SetAttributes[sp, Orderless];


(* ::Chapter:: *)
(*基本数据与 sector 图*)

(* ::Section::Closed:: *)
(*固定顺序与 family 查询*)
vertexPosition[family_Association, vertex_] :=
  First@FirstPosition[family["vertexOrder"], vertex];

linePosition[family_Association, lineId_] :=
  First@FirstPosition[family["lineOrder"], lineId];

familyLine[family_Association, lineId_] :=
  family["lineData"][[linePosition[family, lineId]]];

signAssociation[family_Association, signCase_] :=
  AssociationThread[family["vertexOrder"] -> family["vertexSignCases"][signCase]];

zeroPointValue[family_Association, symbol_] := Module[
  {hits = Cases[family["zeroPointRules"], HoldPattern[symbol -> value_] :> value]},
  If[Length[hits] === 1, First[hits], Missing["ZeroPoint", symbol]]
  ];

normalizeClasses[family_Association, classes_List] :=
  SortBy[
   SortBy[#, vertexPosition[family, #] &] & /@ classes,
   vertexPosition[family, First[#]] &
   ];

classesFromSelected[family_Association, selected_List] := Module[
  {vertices = family["vertexOrder"], edges, graph},
  edges = (UndirectedEdge @@ familyLine[family, #]["endpoints"]) & /@ selected;
  graph = Graph[vertices, edges];
  normalizeClasses[family, ConnectedComponents[graph]]
  ];

vertexMapFromClasses[classes_List] := Association@Flatten[
   Table[(# -> First[class]) & /@ class, {class, classes}]
   ];

sectorName[selected_List] := If[
   selected === {},
   "top",
   StringRiffle[("e" <> ToString[#]) & /@ Sort[selected], "_"]
   ];


(* ::Section::Closed:: *)
(*line state 只由 sign、contact-selected 集合和当前顶点合并关系决定*)
lineSKType[family_Association, signCase_, line_Association] := Module[
  {signs = signAssociation[family, signCase], endpoints = line["endpoints"]},
  StringJoin[(If[signs[#] === 1, "+", "-"] &) /@ endpoints]
  ];

regularLineState[family_Association, signCase_, line_Association] := Module[
  {sameBranch = SameQ @@ (signAssociation[family, signCase] /@ line["endpoints"])},
  Which[
   line["massType"] === "massive" && sameBranch, "massiveFull",
   line["massType"] === "massive", "massiveCross",
   line["massType"] === "massless" && sameBranch, "masslessFull",
   True, "masslessCross"
   ]
  ];

sectorLineState[family_Association, sector_Association, line_Association] := Module[
  {id = line["id"], mappedEndpoints},
  If[MemberQ[sector["selectedLines"], id], Return["shrunk"]];
  mappedEndpoints = sector["vertexMap"] /@ line["endpoints"];
  If[SameQ @@ mappedEndpoints,
   Return[If[line["massType"] === "massless", "coincidentMassless", "coincidentMassive"]]
   ];
  regularLineState[family, sector["signCase"], line]
  ];

lineIntegerShift[line_Association] := If[line["massType"] === "massive", 1, 0];

lineZeroPointShift[line_Association] := Which[
   line["massType"] === "massless", 0,
   Lookup[line, "bbType", "h"] === "h", 2 line["nu"],
   True, 0
   ];

makeSector[family_Association, signCase_, selected_List] := Module[
  {classes, vertexMap},
  classes = classesFromSelected[family, selected];
  vertexMap = vertexMapFromClasses[classes];
  <|
   "name" -> sectorName[selected],
   "signCase" -> signCase,
   "selectedLines" -> Sort[selected],
   "classes" -> classes,
   "reps" -> First /@ classes,
   "vertexMap" -> vertexMap
   |>
  ];


(* ::Section::Closed:: *)
(*共同-theta event：同一当前代表顶点对的 full lines 只允许非空奇数子集*)
contactBundles[family_Association, sector_Association] := Module[
  {candidates, grouped},
  candidates = Select[
    family["lineData"],
    MemberQ[{"massiveFull", "masslessFull"}, sectorLineState[family, sector, #]] &&
      ! SameQ @@ (sector["vertexMap"] /@ #["endpoints"]) &
    ];
  grouped = GroupBy[
    candidates,
    SortBy[sector["vertexMap"] /@ #["endpoints"], vertexPosition[family, #] &] &
    ];
  Values[grouped]
  ];

oddContactEvents[bundleLines_List] := Select[
   Rest@Subsets[Lookup[bundleLines, "id"]],
   OddQ[Length[#]] &
   ];

reachableSectors[family_Association, signCase_] := Module[
  {queue = {{}}, seen = <|"{}" -> True|>, selectedList = {}, selected,
   sector, events, next, key},
  While[queue =!= {},
   selected = First[queue];
   queue = Rest[queue];
   AppendTo[selectedList, selected];
   sector = makeSector[family, signCase, selected];
   events = Flatten[oddContactEvents /@ contactBundles[family, sector], 1];
   Do[
    next = Sort@Union[selected, event];
    key = ToString[next, InputForm];
    If[! KeyExistsQ[seen, key],
     AssociateTo[seen, key -> True];
     AppendTo[queue, next]
     ],
    {event, events}
    ];
   ];
  SortBy[
   makeSector[family, signCase, #] & /@ selectedList,
   {Length[#1["selectedLines"]], #1["selectedLines"]} &
   ]
  ];


(* ::Chapter:: *)
(*Sector zero-point 与 J 索引*)

(* ::Section::Closed:: *)
(*派生 zero-point 只从原始 a0/b0 与实际 selected contact lines 计算*)
sectorA0[family_Association, sector_Association, rep_] := Module[
  {class, selectedInside},
  class = SelectFirst[sector["classes"], MemberQ[#, rep] &];
  selectedInside = Select[
    sector["selectedLines"],
    SubsetQ[class, familyLine[family, #]["endpoints"]] &
    ];
  Total[zeroPointValue[family, a0[#]] & /@ class] -
   Total[lineZeroPointShift[familyLine[family, #]] & /@ selectedInside]
  ];

sectorLineZeroPoint[family_Association, sector_Association, lineId_] := Module[
  {line = familyLine[family, lineId]},
  zeroPointValue[family, b0[lineId]] +
   If[MemberQ[sector["selectedLines"], lineId], lineZeroPointShift[line], 0]
  ];


(* ::Section::Closed:: *)
(*离散态与基础 index state*)
discreteOptionsForLine[family_Association, sector_Association, line_Association] :=
  Switch[sectorLineState[family, sector, line],
   "massiveFull" | "massiveCross", {{0, 0}, {0, 1}, {1, 0}, {1, 1}},
   "coincidentMassive", {{0, 0}, {0, 1}, {1, 0}, {1, 1}},
   "masslessFull", {{0}, {1}},
   "coincidentMassless", {{0}},
   _, {{}}
   ];

sectorDiscreteChoices[family_Association, sector_Association] :=
  Tuples[discreteOptionsForLine[family, sector, #] & /@ family["lineData"]];

linePackFromChoice[family_Association, sector_Association, line_Association, choice_List] :=
  Switch[sectorLineState[family, sector, line],
   "massiveFull" | "massiveCross" | "coincidentMassive",
   {0, choice[[1]], choice[[2]]},
   "masslessFull", {0, choice[[1]]},
   "coincidentMassless", {0, 0},
   _, {0}
   ];

makeBaseIndex[
   family_Association, sector_Association, discreteChoice_List,
   ispValues_: Automatic
   ] := Module[
  {isp = If[ispValues === Automatic, ConstantArray[0, Length[family["ispData"]]], ispValues]},
  <|
   "a" -> AssociationThread[sector["reps"] -> ConstantArray[0, Length[sector["reps"]]]],
   "linePacks" -> AssociationThread[
     family["lineOrder"] -> MapThread[
       linePackFromChoice[family, sector, #1, #2] &,
       {family["lineData"], discreteChoice}
       ]
     ],
   "isp" -> isp
   |>
  ];

familyISPSeedPoints[family_Association] := Lookup[
   family,
   "ispSeedPoints",
   {ConstantArray[0, Length[family["ispData"]]]}
   ];

indexToJ[family_Association, sector_Association, index_Association] := Module[
  {packs = Lookup[index["linePacks"], family["lineOrder"]], line, canonicalN},
  Do[
   line = familyLine[family, family["lineOrder"][[position]]];
   If[sectorLineState[family, sector, line] === "coincidentMassive" &&
     packs[[position, {2, 3}]] === {1, 0},
    canonicalN = Reverse[packs[[position, {2, 3}]]];
    packs[[position, {2, 3}]] = canonicalN
    ],
   {position, Length[family["lineOrder"]]}
   ];
  J[
   Lookup[index["a"], sector["reps"]],
   packs,
   index["isp"]
   ]
  ];

indexSeedRules[family_Association, sector_Association, index_Association] := Module[
  {aRules, lineRules, ispRules},
  aRules = (a[#] -> index["a"][#]) & /@ sector["reps"];
  lineRules = Flatten@Table[
    Module[{line = familyLine[family, id], state, pack},
     state = sectorLineState[family, sector, line];
     pack = index["linePacks"][id];
     Switch[state,
      "shrunk", {bS[id] -> pack[[1]]},
      "massiveFull" | "massiveCross" | "coincidentMassive",
      {b[id] -> pack[[1]], n[id, 1] -> pack[[2]], n[id, 2] -> pack[[3]]},
      "masslessFull", {b[id] -> pack[[1]], n[id] -> pack[[2]]},
      "coincidentMassless", {b[id] -> pack[[1]], n[id] -> pack[[2]]},
      _, {b[id] -> pack[[1]]}
      ]
     ],
    {id, family["lineOrder"]}
    ];
  ispRules = MapIndexed[ispN[First[#2]] -> #1 &, index["isp"]];
  Join[aRules, lineRules, ispRules]
  ];


(* ::Section::Closed:: *)
(*不可变 index shift helper*)
shiftA[index_Association, rep_, delta_] := Module[{newA = Association[index["a"]]},
  AssociateTo[newA, rep -> newA[rep] + delta];
  Join[index, <|"a" -> newA|>]
  ];

replaceLinePack[index_Association, lineId_, pack_List] := Module[
  {newPacks = Association[index["linePacks"]]},
  AssociateTo[newPacks, lineId -> pack];
  Join[index, <|"linePacks" -> newPacks|>]
  ];

shiftLineB[index_Association, lineId_, delta_] := Module[
  {pack = index["linePacks"][lineId]},
  replaceLinePack[index, lineId, ReplacePart[pack, 1 -> pack[[1]] + delta]]
  ];

setLineN[index_Association, lineId_, slot_, value_] := Module[
  {pack = index["linePacks"][lineId]},
  replaceLinePack[index, lineId, ReplacePart[pack, slot + 1 -> value]]
  ];


(* ::Chapter:: *)
(*Time-IBP regular 原子*)

(* ::Section::Closed:: *)
(*massive endpoint：n=2 在产生处立即按 h/H EOM 消去*)
massiveTimeEndpoint[
   family_Association, sector_Association, index_Association,
   line_Association, endpointSlot_, rep_
   ] := Module[
  {id = line["id"], mode = Lookup[line, "bbType", "h"], nu = line["nu"],
   pack, nValue, otherSlot, otherN, result = 0, shifted},
  pack = index["linePacks"][id];
  nValue = pack[[endpointSlot + 1]];
  otherSlot = If[endpointSlot === 1, 2, 1];
  otherN = pack[[otherSlot + 1]];
  If[nValue === 0,
   shifted = setLineN[shiftLineB[index, id, -1], id, endpointSlot, 1];
   Return[-indexToJ[family, sector, shifted]]
   ];
  shifted = setLineN[shiftLineB[index, id, -1], id, endpointSlot, 0];
  result += indexToJ[family, sector, shifted];
  If[mode === "h",
   result += (2 nu + 1) indexToJ[family, sector, shiftA[index, rep, -1]],
   result += indexToJ[family, sector, shiftA[index, rep, -1]];
   shifted = setLineN[shiftLineB[shiftA[index, rep, -2], id, 1], id, endpointSlot, 0];
   result -= nu^2 indexToJ[family, sector, shifted]
   ];
  Expand[result]
  ];


(* ::Section::Closed:: *)
(*massless full/cross regular endpoint；theta boundary 由共同 bundle 模块统一处理*)
masslessFullTimeEndpoint[
   family_Association, sector_Association, index_Association,
   line_Association, endpointSlot_
   ] := Module[
  {id = line["id"], pack, nValue, sigma, endpointSign, shifted},
  pack = index["linePacks"][id];
  nValue = pack[[2]];
  sigma = If[lineSKType[family, sector["signCase"], line] === "++", 1, -1];
  endpointSign = If[endpointSlot === 1, 1, -1];
  shifted = replaceLinePack[
    shiftLineB[index, id, -1],
    id,
    {pack[[1]] - 1, 1 - nValue}
    ];
  I sigma endpointSign indexToJ[family, sector, shifted]
  ];

masslessCrossTimeEndpoint[
   family_Association, sector_Association, index_Association,
   line_Association, endpointSlot_
   ] := Module[
  {id = line["id"], firstVertexSign, endpointSign, shifted},
  firstVertexSign = signAssociation[family, sector["signCase"]][line["endpoints"][[1]]];
  endpointSign = If[endpointSlot === 1, 1, -1];
  shifted = shiftLineB[index, id, -1];
  I firstVertexSign endpointSign indexToJ[family, sector, shifted]
  ];


(* ::Chapter:: *)
(*共同-theta contact*)

(* ::Section::Closed:: *)
(*selected line 的 A-B；orientation 相对当前代表顶点的固定顺序*)
contactLineDifference[
   family_Association, sector_Association, index_Association,
   line_Association, pair_List
   ] := Module[
  {id = line["id"], endpoints, mapped, orientation, pack, stateSign, branchSign},
  endpoints = line["endpoints"];
  mapped = sector["vertexMap"] /@ endpoints;
  orientation = If[mapped === pair, 1, -1];
  pack = index["linePacks"][id];
  If[line["massType"] === "massless",
   If[pack[[2]] =!= 1, Return[0]];
   Return[-2 orientation]
   ];
  stateSign = Which[
    pack[[{2, 3}]] === {1, 0}, 1,
    pack[[{2, 3}]] === {0, 1}, -1,
    True, 0
    ];
  If[stateSign === 0, Return[0]];
  branchSign = If[lineSKType[family, sector["signCase"], line] === "++", 1, -1];
  orientation branchSign stateSign 4 I Exp[Pi Im[line["nu"]]]/Pi
  ];


(* ::Section::Closed:: *)
(*parent index 映到 child sector；unselected massless n=1 coincidence 使该项严格为零*)
contactChildIndex[
   family_Association, parent_Association, child_Association,
   index_Association, event_List
   ] := Module[
  {newA, newPacks, childRep, childClass, parentReps, eventInsideClass,
   line, id, parentState, childState, pack, canonicalN},
  If[AnyTrue[
    family["lineOrder"],
    Function[lineId,
     Module[{testLine = familyLine[family, lineId], testParentState,
       testChildState, testPack},
      testParentState = sectorLineState[family, parent, testLine];
      testChildState = sectorLineState[family, child, testLine];
      testPack = index["linePacks"][lineId];
      testChildState === "coincidentMassless" &&
       testParentState === "masslessFull" && testPack[[2]] === 1
      ]
     ]
    ],
   Return[$Failed]
   ];
  newA = Association@Table[
     childRep -> (
       childClass = SelectFirst[child["classes"], MemberQ[#1, childRep] &];
       parentReps = Select[parent["reps"], child["vertexMap"][#] === childRep &];
       eventInsideClass = Select[
         event,
         SubsetQ[childClass, familyLine[family, #1]["endpoints"]] &
         ];
       Total[Lookup[index["a"], parentReps]] -
        Total[lineIntegerShift[familyLine[family, #]] & /@ eventInsideClass]
       ),
     {childRep, child["reps"]}
     ];
  newPacks = Association@Table[
     line = familyLine[family, id];
     parentState = sectorLineState[family, parent, line];
     childState = sectorLineState[family, child, line];
     pack = index["linePacks"][id];
     id -> Which[
       MemberQ[event, id], {pack[[1]] + lineIntegerShift[line]},
       parentState === "shrunk", pack,
       childState === "coincidentMassless" && parentState === "masslessFull" && pack[[2]] === 0,
       {pack[[1]], 0},
       childState === "coincidentMassive" && MemberQ[{"massiveFull", "coincidentMassive"}, parentState],
       canonicalN = Sort[pack[[{2, 3}]]]; {pack[[1]], canonicalN[[1]], canonicalN[[2]]},
       True, pack
       ],
     {id, family["lineOrder"]}
     ];
  <|"a" -> newA, "linePacks" -> newPacks, "isp" -> index["isp"]|>
  ];

contactTermsAtVertex[
   family_Association, sectors_List, sector_Association,
   index_Association, rep_
   ] := Module[
  {result = 0, bundle, pair, endpointFactor, event, differences, child,
   childIndex, coefficient, childKey},
  Do[
   pair = SortBy[
     sector["vertexMap"] /@ bundle[[1]]["endpoints"],
     vertexPosition[family, #] &
     ];
   If[! MemberQ[pair, rep], Continue[]];
   endpointFactor = If[rep === pair[[1]], 1, -1];
   Do[
    differences = contactLineDifference[
        family, sector, index, familyLine[family, #], pair
        ] & /@ event;
    If[MemberQ[differences, 0], Continue[]];
    childKey = Sort@Union[sector["selectedLines"], event];
    child = SelectFirst[sectors, #1["selectedLines"] === childKey &];
    childIndex = contactChildIndex[family, sector, child, index, event];
    If[childIndex === $Failed, Continue[]];
    coefficient = endpointFactor 2^(1 - Length[event]) Times @@ differences;
    result += coefficient indexToJ[family, child, childIndex],
    {event, oddContactEvents[bundle]}
    ],
   {bundle, contactBundles[family, sector]}
   ];
  Expand[result]
  ];


(* ::Chapter:: *)
(*Time-IBP relation 与扁平 records*)

timeRelation[
   family_Association, sectors_List, sector_Association,
   index_Association, rep_
   ] := Module[
  {base, result, aValue, phaseCoefficient, line, state, mapped, slots},
  base = indexToJ[family, sector, index];
  aValue = index["a"][rep];
  result = -(aValue + sectorA0[family, sector, rep])
    indexToJ[family, sector, shiftA[index, rep, -1]];
  phaseCoefficient = Total[
    (-I signAssociation[family, sector["signCase"]][#]
        family["vertexEnergies"][#]) & /@
     Select[family["vertexOrder"], sector["vertexMap"][#] === rep &]
    ];
  result += phaseCoefficient base;
  Do[
   state = sectorLineState[family, sector, line];
   mapped = sector["vertexMap"] /@ line["endpoints"];
   slots = Flatten@Position[mapped, rep];
   Do[
    result += Switch[state,
      "massiveFull" | "massiveCross" | "coincidentMassive",
      massiveTimeEndpoint[family, sector, index, line, slot, rep],
      "masslessFull", masslessFullTimeEndpoint[family, sector, index, line, slot],
      "masslessCross", masslessCrossTimeEndpoint[family, sector, index, line, slot],
      _, 0
      ],
    {slot, slots}
    ],
   {line, family["lineData"]}
   ];
  result += contactTermsAtVertex[family, sectors, sector, index, rep];
  Expand[result]
  ];

generateTimeExpected[family_Association] := Flatten@KeyValueMap[
   Function[{signCase, signValues},
    Module[{sectors = reachableSectors[family, signCase]},
     Flatten@Table[
       Module[{index = makeBaseIndex[family, sector, choice, ispPoint]},
        Table[
         <|
          "sector" -> sector["name"],
          "vertexSigns" -> signCase,
          "generator" -> dtau[rep],
          "seedRules" -> indexSeedRules[family, sector, index],
          "equation" -> timeRelation[family, sectors, sector, index, rep],
          "tags" -> {"independentOracle", "timeIBP"}
          |>,
         {rep, sector["reps"]}
         ]
        ],
       {sector, sectors}, {choice, sectorDiscreteChoices[family, sector]},
       {ispPoint, familyISPSeedPoints[family]}]
     ]
    ],
   family["vertexSignCases"]
   ];


(* ::Chapter:: *)
(*Scalar-product 与 ISP 闭合*)

(* ::Section::Closed:: *)
(*向量表达式按 loop/external basis 线性展开，再构造双线性 sp*)
momentumBasis[family_Association] := Join[
   family["loopMomenta"], family["externalMomenta"]
   ];

vectorCoefficients[family_Association, vector_] :=
  Coefficient[Expand[vector], #] & /@ momentumBasis[family];

expandedVectorSP[family_Association, left_, right_] := Module[
  {basis = momentumBasis[family], lc, rc},
  lc = vectorCoefficients[family, left];
  rc = vectorCoefficients[family, right];
  Expand@Sum[
    lc[[i]] rc[[j]] sp[basis[[i]], basis[[j]]],
    {i, Length[basis]}, {j, Length[basis]}
    ]
  ];

expandScalarProducts[family_Association, expr_] := Expand[
   expr /. HoldPattern[sp[left_, right_]] :> expandedVectorSP[family, left, right]
   ];

loopScalarProducts[family_Association] := Module[
  {loops = family["loopMomenta"], external = family["externalMomenta"]},
  Join[
   Flatten@Table[sp[loops[[i]], loops[[j]]], {i, Length[loops]}, {j, i, Length[loops]}],
   Flatten@Table[sp[loops[[i]], external[[j]]], {i, Length[loops]}, {j, Length[external]}]
   ]
  ];

scalarReductionData[family_Association] := Module[
  {unknownSP = loopScalarProducts[family], unknownSymbols, forward, backward,
   lineEquations, ispEquations, equations, solution},
  unknownSymbols = Array[scalarUnknown, Length[unknownSP]];
  forward = Thread[unknownSP -> unknownSymbols];
  backward = Thread[unknownSymbols -> unknownSP];
  lineEquations = Table[
    propSq[line["id"]] == (
       expandedVectorSP[family, line["momentum"], line["momentum"]] /.
        family["externalInvariantRules"] /. forward
       ),
    {line, family["lineData"]}
    ];
  ispEquations = MapIndexed[
    rhoVar[First[#2]] == (
        expandScalarProducts[family, #1["expression"]] /.
         family["externalInvariantRules"] /. forward
        ) &,
    family["ispData"]
    ];
  equations = Join[lineEquations, ispEquations];
  solution = Solve[equations, unknownSymbols];
  If[solution === {}, Return[$Failed]];
  <|
   "unknownScalarProducts" -> unknownSP,
   "rules" -> Thread[unknownSP -> (unknownSymbols /. First[solution])],
   "equations" -> equations,
   "solutionCount" -> Length[solution],
   "completeQ" -> FreeQ[unknownSymbols /. First[solution], Alternatives @@ unknownSymbols]
   |>
  ];

reduceScalarExpression[family_Association, reduction_Association, expr_] := Expand[
   expandScalarProducts[family, expr] /.
    family["externalInvariantRules"] /.
    reduction["rules"]
   ];


(* ::Section::Closed:: *)
(*线性 scalar polynomial 吸收到 propagator/ISP 指标；正 ispN 表示 numerator*)
shiftISP[index_Association, position_, delta_] :=
  Join[index, <|"isp" -> ReplacePart[
      index["isp"], position -> index["isp"][[position]] + delta
      ]|>];

absorbScalarPolynomial[
   family_Association, sector_Association, index_Association, polynomial_
   ] := Module[
  {variables, rules, result = 0, shifted, powers, coefficient},
  variables = Join[
    propSq /@ family["lineOrder"],
    rhoVar /@ Range[Length[family["ispData"]]]
    ];
  rules = CoefficientRules[Expand[polynomial], variables];
  Do[
   powers = First[rule];
   coefficient = Last[rule];
   shifted = index;
   Do[
    If[powers[[p]] =!= 0,
     shifted = shiftLineB[
       shifted, family["lineOrder"][[p]], -2 powers[[p]]
       ]
     ],
    {p, Length[family["lineOrder"]]}
    ];
   Do[
    If[powers[[Length[family["lineOrder"]] + p]] =!= 0,
     shifted = shiftISP[
       shifted, p, powers[[Length[family["lineOrder"]] + p]]
       ]
     ],
    {p, Length[family["ispData"]]}
    ];
   result += coefficient indexToJ[family, sector, shifted],
   {rule, rules}
   ];
  Expand[result]
  ];


(* ::Chapter:: *)
(*Momentum building-block 原子*)

(* ::Section::Closed:: *)
(*每个 radial term 返回 {coefficient,index}，随后统一乘 (V.Q)/q^2*)
massiveRadialTerms[
   family_Association, sector_Association, index_Association,
   line_Association, endpointSlot_, rep_
   ] := Module[
  {id = line["id"], mode = Lookup[line, "bbType", "h"], nu = line["nu"],
   pack, nValue, terms = {}, shifted},
  pack = index["linePacks"][id];
  nValue = pack[[endpointSlot + 1]];
  If[nValue === 0,
   shifted = setLineN[shiftLineB[shiftA[index, rep, 1], id, -1], id, endpointSlot, 1];
   Return[{{1, shifted}}]
   ];
  shifted = setLineN[shiftLineB[shiftA[index, rep, 1], id, -1], id, endpointSlot, 0];
  AppendTo[terms, {-1, shifted}];
  If[mode === "h",
   AppendTo[terms, {-(2 nu + 1), index}],
   AppendTo[terms, {-1, index}];
   shifted = setLineN[shiftLineB[shiftA[index, rep, -1], id, 1], id, endpointSlot, 0];
   AppendTo[terms, {nu^2, shifted}]
   ];
  terms
  ];

masslessFullRadialTerms[
   family_Association, sector_Association, index_Association,
   line_Association
   ] := Module[
  {id = line["id"], pack, nValue, sigma, shiftedU, shiftedV},
  pack = index["linePacks"][id];
  nValue = pack[[2]];
  sigma = If[lineSKType[family, sector["signCase"], line] === "++", 1, -1];
  shiftedU = replaceLinePack[
    shiftLineB[shiftA[index, sector["vertexMap"][line["endpoints"][[1]]], 1], id, -1],
    id, {pack[[1]] - 1, 1 - nValue}
    ];
  shiftedV = replaceLinePack[
    shiftLineB[shiftA[index, sector["vertexMap"][line["endpoints"][[2]]], 1], id, -1],
    id, {pack[[1]] - 1, 1 - nValue}
    ];
  {{-I sigma, shiftedU}, {I sigma, shiftedV}}
  ];

masslessCrossRadialTerms[
   family_Association, sector_Association, index_Association,
   line_Association
   ] := Module[
  {id = line["id"], firstSign, shiftedU, shiftedV},
  firstSign = signAssociation[family, sector["signCase"]][line["endpoints"][[1]]];
  shiftedU = shiftLineB[
    shiftA[index, sector["vertexMap"][line["endpoints"][[1]]], 1], id, -1
    ];
  shiftedV = shiftLineB[
    shiftA[index, sector["vertexMap"][line["endpoints"][[2]]], 1], id, -1
    ];
  {{-I firstSign, shiftedU}, {I firstSign, shiftedV}}
  ];

lineRadialTerms[
   family_Association, sector_Association, index_Association,
   line_Association
   ] := Module[
  {state = sectorLineState[family, sector, line], mapped, result = {}},
  mapped = sector["vertexMap"] /@ line["endpoints"];
  Switch[state,
   "massiveFull" | "massiveCross" | "coincidentMassive",
   Do[
    result = Join[result, massiveRadialTerms[
       family, sector, index, line, slot, mapped[[slot]]
       ]],
    {slot, {1, 2}}],
   "masslessFull", result = masslessFullRadialTerms[family, sector, index, line],
   "masslessCross", result = masslessCrossRadialTerms[family, sector, index, line],
   _, result = {}
   ];
  result
  ];


(* ::Section::Closed:: *)
(*ISP 的 loop-directional derivative 直接作用于展开后的 basis scalar products*)
directionalDerivativeOfSP[
   family_Association, scalarProduct_sp, differentiatedLoop_, vector_
   ] := Module[
  {args = List @@ scalarProduct, result = 0},
  If[args[[1]] === differentiatedLoop,
   result += expandedVectorSP[family, vector, args[[2]]]
   ];
  If[args[[2]] === differentiatedLoop,
   result += expandedVectorSP[family, args[[1]], vector]
   ];
  Expand[result]
  ];

directionalDerivativeOfScalar[
   family_Association, expr_, differentiatedLoop_, vector_
   ] := Module[
  {expanded = expandScalarProducts[family, expr]},
  Expand[expanded /. scalarProduct_sp :>
     directionalDerivativeOfSP[family, scalarProduct, differentiatedLoop, vector]]
  ];


(* ::Chapter:: *)
(*完整 momentum relation*)

momentumRelation[
   family_Association, reduction_Association, sector_Association,
   index_Association, differentiatedLoop_, vector_
   ] := Module[
  {result = 0, base, line, id, qCoefficient, scalarNumerator, physicalB,
   denominatorIndex, radialTerms, radialIndex, ispPower, ispDerivative,
   ispIndex},
  base = indexToJ[family, sector, index];
  If[vector === differentiatedLoop, result += d base];
  Do[
   id = line["id"];
   qCoefficient = Coefficient[Expand[line["momentum"]], differentiatedLoop];
   If[qCoefficient === 0, Continue[]];
   scalarNumerator = reduceScalarExpression[
     family, reduction, expandedVectorSP[family, vector, line["momentum"]]
     ];
   physicalB = index["linePacks"][id][[1]] +
     sectorLineZeroPoint[family, sector, id];
   denominatorIndex = shiftLineB[index, id, 2];
   result += -physicalB qCoefficient absorbScalarPolynomial[
      family, sector, denominatorIndex, scalarNumerator
      ];
   radialTerms = lineRadialTerms[family, sector, index, line];
   Do[
    radialIndex = shiftLineB[term[[2]], id, 2];
    result += qCoefficient term[[1]] absorbScalarPolynomial[
       family, sector, radialIndex, scalarNumerator
       ],
    {term, radialTerms}
    ],
   {line, family["lineData"]}
   ];
  Do[
   ispPower = index["isp"][[r]];
   If[ispPower === 0, Continue[]];
   ispDerivative = directionalDerivativeOfScalar[
     family, family["ispData"][[r]]["expression"], differentiatedLoop, vector
     ];
   ispDerivative = reduceScalarExpression[family, reduction, ispDerivative];
   ispIndex = shiftISP[index, r, -1];
   result += ispPower absorbScalarPolynomial[
      family, sector, ispIndex, ispDerivative
      ],
   {r, Length[family["ispData"]]}
   ];
  Expand[result]
  ];

momentumGenerators[family_Association] := Flatten@Table[
   Join[
    Table[<|"label" -> dqq[l, j], "dLoop" -> family["loopMomenta"][[l]],
      "vector" -> family["loopMomenta"][[j]]|>,
     {j, Length[family["loopMomenta"]]}],
    Table[<|"label" -> dqk[l, j], "dLoop" -> family["loopMomenta"][[l]],
      "vector" -> family["externalMomenta"][[j]]|>,
     {j, Length[family["externalMomenta"]]}]
    ],
   {l, Length[family["loopMomenta"]]}
   ];

generateMomentumExpected[family_Association] := Module[
  {reduction = scalarReductionData[family]},
  If[reduction === $Failed || ! TrueQ[reduction["completeQ"]], Return[$Failed]];
  Flatten@KeyValueMap[
    Function[{signCase, signValues},
     Module[{sectors = reachableSectors[family, signCase]},
      Flatten@Table[
        Module[{index = makeBaseIndex[family, sector, choice, ispPoint]},
         Table[
          <|
           "sector" -> sector["name"],
           "vertexSigns" -> signCase,
           "generator" -> generator["label"],
           "seedRules" -> indexSeedRules[family, sector, index],
           "equation" -> momentumRelation[
             family, reduction, sector, index,
             generator["dLoop"], generator["vector"]
             ],
           "tags" -> {"independentOracle", "momentumIBP"}
           |>,
          {generator, momentumGenerators[family]}]
         ],
        {sector, sectors}, {choice, sectorDiscreteChoices[family, sector]},
        {ispPoint, familyISPSeedPoints[family]}]
      ]
     ],
    family["vertexSignCases"]
    ]
  ];


(* ::Chapter:: *)
(*External invariant 与 ke 总导数*)

(* ::Section::Closed:: *)
(*外部向量 directional derivative 的 invariant 矩阵*)
externalInvariantVariables[family_Association] := DeleteDuplicates[
   Last /@ family["externalInvariantRules"]
   ];

keVariables[family_Association] := DeleteDuplicates@Cases[
   Values[family["vertexEnergies"]],
   _ke,
   Infinity
   ];

initializedDerivativeVariables[family_Association] := Join[
   externalInvariantVariables[family],
   keVariables[family]
   ];

externalOperators[family_Association] := Flatten@Table[
   <|"left" -> family["externalMomenta"][[i]],
    "dExternal" -> family["externalMomenta"][[j]]|>,
   {i, Length[family["externalMomenta"]]},
   {j, Length[family["externalMomenta"]]}
   ];

(* 任务书固定 raw strict-zero representative；Dij 有序，只保留 i<=j 的算符而不是交换其角色。 *)
externalOperatorBasis[family_Association] := Flatten@Table[
   If[i <= j,
    <|"left" -> family["externalMomenta"][[i]],
     "dExternal" -> family["externalMomenta"][[j]]|>,
    Nothing
    ],
   {i, Length[family["externalMomenta"]]},
   {j, Length[family["externalMomenta"]]}
   ];

externalDirectionalDerivativeOfSP[
   family_Association, scalarProduct_sp, leftVector_, differentiatedExternal_
   ] := Module[
  {args = List @@ scalarProduct, result = 0},
  If[args[[1]] === differentiatedExternal,
   result += expandedVectorSP[family, leftVector, args[[2]]]
   ];
  If[args[[2]] === differentiatedExternal,
   result += expandedVectorSP[family, args[[1]], leftVector]
   ];
  Expand[result]
  ];

externalDirectionalDerivativeOfRawScalar[
   family_Association, expr_, leftVector_, differentiatedExternal_
   ] := Module[
  {expanded = expandScalarProducts[family, expr]},
  Expand[expanded /. scalarProduct_sp :>
     externalDirectionalDerivativeOfSP[
      family, scalarProduct, leftVector, differentiatedExternal
      ]]
  ];

invariantDirectionalMatrix[family_Association] := Module[
  {variables = externalInvariantVariables[family], inverseRules, operators},
  inverseRules = Reverse /@ family["externalInvariantRules"];
  operators = externalOperatorBasis[family];
  Table[
   externalDirectionalDerivativeOfRawScalar[
      family, variable /. inverseRules,
      operator["left"], operator["dExternal"]
      ] /. family["externalInvariantRules"] // Expand,
   {operator, operators}, {variable, variables}
   ]
  ];

externalDirectionalDerivativeOfInitializedScalar[
   family_Association, expr_, operator_Association
   ] := Module[
  {variables = externalInvariantVariables[family], inverseRules, directionalRow},
  If[variables === {}, Return[0]];
  inverseRules = Reverse /@ family["externalInvariantRules"];
  directionalRow = Table[
    externalDirectionalDerivativeOfRawScalar[
       family, variable /. inverseRules,
       operator["left"], operator["dExternal"]
       ] /. family["externalInvariantRules"] // Expand,
    {variable, variables}
    ];
  Expand@Total[MapThread[
     D[expr, #1] #2 &,
     {variables, directionalRow}
     ]]
  ];


(* ::Section::Closed:: *)
(*外部向量作用于 J：无 divergence，其余 line/ISP 与 momentum oracle 共用原子*)
externalDirectionalJ[
   family_Association, reduction_Association, sector_Association,
   index_Association, operator_Association
   ] := Module[
  {result = 0, line, id, qCoefficient, scalarNumerator, physicalB,
   denominatorIndex, radialTerms, radialIndex, ispPower, ispDerivative,
   ispIndex, energyDerivative, rep},
  Do[
   energyDerivative = externalDirectionalDerivativeOfInitializedScalar[
     family, family["vertexEnergies"][vertex], operator
     ];
   If[energyDerivative =!= 0,
    rep = sector["vertexMap"][vertex];
    result += I signAssociation[family, sector["signCase"]][vertex]
      energyDerivative indexToJ[family, sector, shiftA[index, rep, 1]]
    ],
   {vertex, family["vertexOrder"]}
   ];
  Do[
   id = line["id"];
   qCoefficient = Coefficient[Expand[line["momentum"]], operator["dExternal"]];
   If[qCoefficient === 0, Continue[]];
   scalarNumerator = reduceScalarExpression[
     family, reduction,
     expandedVectorSP[family, operator["left"], line["momentum"]]
     ];
   physicalB = index["linePacks"][id][[1]] +
     sectorLineZeroPoint[family, sector, id];
   denominatorIndex = shiftLineB[index, id, 2];
   result += -physicalB qCoefficient absorbScalarPolynomial[
      family, sector, denominatorIndex, scalarNumerator
      ];
   radialTerms = lineRadialTerms[family, sector, index, line];
   Do[
    radialIndex = shiftLineB[term[[2]], id, 2];
    result += qCoefficient term[[1]] absorbScalarPolynomial[
       family, sector, radialIndex, scalarNumerator
       ],
    {term, radialTerms}
    ],
   {line, family["lineData"]}
   ];
  Do[
   ispPower = index["isp"][[r]];
   If[ispPower === 0, Continue[]];
   ispDerivative = externalDirectionalDerivativeOfRawScalar[
     family, family["ispData"][[r]]["expression"],
     operator["left"], operator["dExternal"]
     ];
   ispDerivative = reduceScalarExpression[family, reduction, ispDerivative];
   ispIndex = shiftISP[index, r, -1];
   result += ispPower absorbScalarPolynomial[
      family, sector, ispIndex, ispDerivative
      ],
   {r, Length[family["ispData"]]}
   ];
  Expand[result]
  ];


(* ::Section::Closed:: *)
(*验证任务书固定的 i<=j 算符矩阵满秩，再反解每个 external invariant 导数*)
independentInvariantRows[matrix_] := Module[
  {rank = Length[First[matrix]], candidates},
  candidates = Subsets[Range[Length[matrix]], {rank}];
  SelectFirst[
   candidates,
   ! TrueQ[Quiet[FullSimplify[Det[matrix[[#]]] == 0]]] &,
   Missing["NoIndependentRows"]
   ]
  ];

externalInvariantDerivatives[
   family_Association, reduction_Association, sector_Association,
   index_Association
   ] := Module[
  {variables = externalInvariantVariables[family], operators, matrix, rows,
   directionalValues, derivatives},
  If[variables === {}, Return[<||>]];
  operators = externalOperatorBasis[family];
  matrix = invariantDirectionalMatrix[family];
  rows = independentInvariantRows[matrix];
  If[Head[rows] === Missing, Return[$Failed]];
  directionalValues = externalDirectionalJ[
      family, reduction, sector, index, #
      ] & /@ operators[[rows]];
  derivatives = Quiet@FullSimplify[Inverse[matrix[[rows]]].directionalValues];
  AssociationThread[variables -> (Expand /@ derivatives)]
  ];

parameterDerivativeJ[
   family_Association, sector_Association, index_Association, variable_
   ] := Module[
  {result = 0, derivative, rep},
  Do[
   derivative = D[family["vertexEnergies"][vertex], variable];
   If[derivative =!= 0,
    rep = sector["vertexMap"][vertex];
    result += I signAssociation[family, sector["signCase"]][vertex]
      derivative indexToJ[family, sector, shiftA[index, rep, 1]]
    ],
   {vertex, family["vertexOrder"]}
   ];
  Expand[result]
  ];

integralDerivative[
   family_Association, reduction_Association, sector_Association,
   index_Association, variable_
   ] := Module[{invariantDerivatives},
  If[! MemberQ[externalInvariantVariables[family], variable],
   Return[parameterDerivativeJ[family, sector, index, variable]]
   ];
  invariantDerivatives = externalInvariantDerivatives[
    family, reduction, sector, index
    ];
  If[invariantDerivatives === $Failed, Return[$Failed]];
  Lookup[invariantDerivatives, variable, $Failed]
  ];


(* ::Section::Closed:: *)
(*general continuous indices；两个离散态分别取全零和覆盖全部适用 n=1*)
makeGeneralIndex[
   family_Association, sector_Association, discreteChoice_List
   ] := Module[
  {index = makeBaseIndex[
      family, sector, discreteChoice,
      Table[rg[r], {r, Length[family["ispData"]]}]
      ], packs},
  index = Join[index, <|
     "a" -> AssociationThread[
       sector["reps"],
       (ag[vertexPosition[family, #]] &) /@ sector["reps"]
       ]
     |>];
  packs = Association[index["linePacks"]];
  Do[
   AssociateTo[packs, id -> ReplacePart[
      packs[id], 1 -> bg[id]
      ]],
   {id, family["lineOrder"]}
   ];
  Join[index, <|"linePacks" -> packs|>]
  ];

extremeDiscreteChoices[family_Association, sector_Association] := Module[
  {options = discreteOptionsForLine[family, sector, #] & /@ family["lineData"]},
  {First /@ options, Last /@ options}
  ];

familyModeLabel[family_Association] := Which[
   KeyExistsQ[family, "energyCase"], family["energyCase"],
   family["name"] === "atomic_massive_line", Lookup[familyLine[family, 1], "bbType", "h"],
   True, Lookup[family, "mode", "default"]
   ];

generateDerivativeExpected[family_Association] := Module[
  {variables = initializedDerivativeVariables[family], reduction},
  If[variables === {}, Return[{}]];
  reduction = scalarReductionData[family];
  If[reduction === $Failed || ! TrueQ[reduction["completeQ"]], Return[$Failed]];
  Flatten@KeyValueMap[
    Function[{signCase, signValues},
     Module[{sectors = reachableSectors[family, signCase]},
      Flatten@Table[
        Module[{choices = extremeDiscreteChoices[family, sector], index0, index1,
          j0, j1, dj0, dj1, expression, derivative},
         index0 = makeGeneralIndex[family, sector, choices[[1]]];
         index1 = makeGeneralIndex[family, sector, choices[[2]]];
         j0 = indexToJ[family, sector, index0];
         j1 = indexToJ[family, sector, index1];
         dj0 = integralDerivative[family, reduction, sector, index0, variable];
         dj1 = integralDerivative[family, reduction, sector, index1, variable];
         expression = variable j0 + variable^2 j1 + variable^3;
         derivative = Expand[j0 + 2 variable j1 + 3 variable^2 +
            variable dj0 + variable^2 dj1];
         <|
          "sector" -> sector["name"],
          "vertexSigns" -> signCase,
          "mode" -> familyModeLabel[family],
          "variable" -> variable,
          "expression" -> expression,
          "derivative" -> derivative,
          "tags" -> {
            "independentOracle", "totalDerivative", "generalIndex",
            If[
             MemberQ[externalInvariantVariables[family], variable],
             "upperTriangularDijBasis",
             "directParameterDerivative"
             ]
            }
          |>
         ],
        {sector, sectors}, {variable, variables}]
      ]
     ],
    family["vertexSignCases"]
    ]
  ];
