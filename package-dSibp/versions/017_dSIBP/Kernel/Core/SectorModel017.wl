(* ::Package:: *)
(* 本模块定义 017 唯一积分表示与 sector 身份层。所有 root line 槽位永久保留；
   full line 使用三槽，shrunk line 使用单槽，fixed line 用短字符串 "F" 标记无整数动量幂。
   sector prefactor 只保存结构化参数、幂次和来源，物化表达式由一个统一 helper 完成。 *)

(* ::Chapter:: *)
(*统一 line-pack schema*)

fixedLineSentinel017[] := "F";


linePackNPositions[line_Association, packType_String] := Switch[packType,
   "massiveFull" | "massiveCross" | "masslessFull", {2, 3},
   _, {}
   ];


linePackBPosition[line_Association] := If[lineIndexedPowerQ[line], 1, Missing["FixedLinePower"]];


makeLinePack[line_Association] := Module[
   {id = line["id"], indexedQ = lineIndexedPowerQ[line], firstSlot},
   firstSlot = If[indexedQ, b[id], fixedLineSentinel017[]];
   Switch[line["packType"],
    "massiveFull" | "massiveCross" | "masslessFull",
    {firstSlot, n[id, 1], n[id, 2]},
    "masslessCross",
    {firstSlot, 0, 0},
    "shrunk",
    If[indexedQ, {bS[id]}, {fixedLineSentinel017[]}],
    _, Message[makeLinePack::badtype, line["packType"], id]; $Failed
    ]
   ];


actualLinePackType[topo_Association, e_Integer, pack_List] := Module[
   {line = topo["lines"][[e]], declared},
   declared = line["packType"];
   Which[
    declared === "shrunk", "shrunk",
    Length[pack] === 1 && lineIndexedPowerQ[line] && pack[[1]] =!= fixedLineSentinel017[], "shrunk",
    Length[pack] === 1 && ! lineIndexedPowerQ[line] && pack[[1]] === fixedLineSentinel017[], "shrunk",
    True, declared
    ]
   ];


lineIntegerPowerIndex[topo_Association, J[_, linePacks_, _], e_Integer] := If[
   lineIndexedPowerQ[topo["lines"][[e]]],
   linePacks[[e, 1]],
   0
   ];


discreteVarsForLine[line_Association] := If[
   Lookup[line, "state", "full"] === "shrunk" || Lookup[line, "packType", ""] === "shrunk",
   {},
   Switch[line["packType"],
    "massiveFull" | "massiveCross" | "masslessFull", {n[line["id"], 1], n[line["id"], 2]},
    _, {}
    ]
   ];


discreteStateCountForLine[line_Association] := 2^Length[discreteVarsForLine[line]];


publicExpectedPackLength[_Association, "shrunk"] := 1;
publicExpectedPackLength[_Association, "massiveFull" | "massiveCross" | "masslessFull" | "masslessCross"] := 3;
publicExpectedPackLength[_Association, packType_String] := Missing["UnknownPackType", packType];


makeBaseIntegral[topo_Association] := Module[
   {active = Lookup[topo, "activeVertexIds", topo["vertexIds"]],
    fixedA = Lookup[topo, "fixedAVertexValues", <||>], ispList},
   ispList = If[
     Lookup[topo, "ibpMode", "full"] === "timeOnly",
     {},
     Table[ispN[j], {j, Length[topo["ispData"]]}]
     ];
   J[
    Table[If[AssociationQ[fixedA] && KeyExistsQ[fixedA, v], fixedA[v], a[v]], {v, active}],
    makeLinePacks[topo],
    ispList
    ]
   ];


dsTimeOnlyNeedsLinePackStateQ[_Association] := True;


(* ::Chapter:: *)
(*Sector pattern 与唯一解析*)

sectorLinePattern017[line_Association, pack_List] := <|
   "powerKind" -> If[lineIndexedPowerQ[line], "cycle", "fixed"],
   "state" -> If[Length[pack] === 1, "shrunk", "full"]
   |>;


sectorPattern017[topo_Association, linePacks_List] := MapThread[
   sectorLinePattern017,
   {topo["lines"], linePacks}
   ];


sectorShrunkLinesFromPattern017[pattern_List] := Flatten@Position[Lookup[pattern, "state", {}], "shrunk"];


sectorKeyFromPattern017[pattern_List] := sectorKeyFromShrunkLines[sectorShrunkLinesFromPattern017[pattern]];


linePackMatchesSlotQ[pack_List, slot_Association] := Module[
   {template = Lookup[slot, "packTemplate", {}], firstTemplate, fixedQ},
   If[Length[pack] =!= Length[template], Return[False]];
   If[template === {}, Return[pack === {}]];
   firstTemplate = First[template];
   fixedQ = SameQ[firstTemplate, fixedLineSentinel017[]];
   TrueQ[
    If[fixedQ, SameQ[First[pack], fixedLineSentinel017[]], First[pack] =!= fixedLineSentinel017[]]
    ]
   ];


(* ::Chapter:: *)
(*结构化 fixed-line sector prefactor*)

zeroPointRuleValue017[rules_List, symbol_, default_: 0] := Module[{hits},
   hits = Cases[rules, (Rule | RuleDelayed)[lhs_, rhs_] /; lhs === symbol :> rhs];
   If[hits === {}, default, Last[hits]]
   ];


explicitZeroPointRuleValue017[rules_List, symbol_] := Module[{hits},
   hits = Cases[rules, (Rule | RuleDelayed)[lhs_, rhs_] /; lhs === symbol :> rhs];
   If[hits === {}, Missing["NoExplicitZeroPoint", symbol], Last[hits]]
   ];


lineDerivedShrinkZeroPoint017[topo_Association, e_Integer] := Expand[
   zeroPointRuleValue017[
     Lookup[topo, "rootZeroPointRules", topo["zeroPointRules"]],
     b0[topo["lines"][[e, "id"]]],
     0
     ] + lineShrinkZeroPointShift[topo["lines"][[e]]]
   ];


lineTargetShrinkZeroPoint017[topo_Association, e_Integer] := Module[
   {rootRules, id, explicit},
   rootRules = Lookup[topo, "rootZeroPointRules", topo["zeroPointRules"]];
   id = topo["lines"][[e, "id"]];
   explicit = explicitZeroPointRuleValue017[rootRules, bS0[id]];
   If[Head[explicit] === Missing, lineDerivedShrinkZeroPoint017[topo, e], explicit]
   ];


lineShrinkZeroPointSource017[topo_Association, e_Integer] := Module[
   {rootRules, id},
   rootRules = Lookup[topo, "rootZeroPointRules", topo["zeroPointRules"]];
   id = topo["lines"][[e, "id"]];
   If[Head[explicitZeroPointRuleValue017[rootRules, bS0[id]]] === Missing,
    "compiledDefault",
    "userBS0Override"
    ]
   ];


(* child sector 继承 root 的显式 bS0 override；未给出时仍严格使用函数系统编译的 z shift。 *)
sectorZeroPointRules[
   topo_Association,
   shrunkLines_List,
   repMap_Association,
   activeVertices_List
   ] := Module[
   {lineRules, vertexRules, classVertices, classShrunkLines, shiftSum, rep},
   lineRules = Table[
     If[MemberQ[shrunkLines, e],
      bS0[topo["lines"][[e, "id"]]] -> lineTargetShrinkZeroPoint017[topo, e],
      Switch[actualLinePackType[topo, e, makeLinePack[topo["lines"][[e]]]],
       "shrunk", bS0[topo["lines"][[e, "id"]]] -> lineBSZeroPoint[topo, e],
       _, b0[topo["lines"][[e, "id"]]] -> lineBZeroPoint[topo, e]
       ]
      ],
     {e, topo["nE"]}
     ];
   vertexRules = Table[
     rep = activeVertices[[i]];
     classVertices = Select[topo["vertexIds"], Lookup[repMap, #] === rep &];
     classShrunkLines = Select[
       shrunkLines,
       Function[e, And @@ (Function[v, Lookup[repMap, v] === rep] /@ topo["lines"][[e, "endpoints"]])]
       ];
     shiftSum = Total[lineShrinkZeroPointShift[topo["lines"][[#]]] & /@ classShrunkLines];
     a0[rep] -> Total[vertexZeroPoint[topo, #] & /@ classVertices] - shiftSum,
     {i, Length[activeVertices]}
     ];
   DeleteDuplicates@Join[vertexRules, lineRules]
   ];


fixedLinePrefactorRecord017[topo_Association, e_Integer] := Module[
   {line = topo["lines"][[e]], id, shrunkQ, rootRules, sourcePower, targetPower,
    integerShift, zeroPointShift, targetMinusSource, residualPower, parameter,
    derivedTarget, overrideSource},
   id = line["id"];
   shrunkQ = Lookup[line, "state", "full"] === "shrunk" || Lookup[line, "packType", ""] === "shrunk";
   rootRules = Lookup[topo, "rootZeroPointRules", topo["zeroPointRules"]];
   sourcePower = zeroPointRuleValue017[rootRules, b0[id], 0];
   targetPower = If[shrunkQ, lineBSZeroPoint[topo, e], lineBZeroPoint[topo, e]];
   integerShift = If[shrunkQ, lineShrinkBShift[line], 0];
   zeroPointShift = If[shrunkQ, lineShrinkZeroPointShift[line], 0];
   derivedTarget = If[shrunkQ, lineDerivedShrinkZeroPoint017[topo, e], sourcePower];
   overrideSource = If[shrunkQ, lineShrinkZeroPointSource017[topo, e], "sourceSector"];
   targetMinusSource = Expand[targetPower - sourcePower];
   residualPower = Expand[integerShift + zeroPointShift - targetMinusSource];
   parameter = fixedLineMomentumMagnitude[topo, e];
   <|
    "lineIndex" -> e,
    "lineId" -> id,
    "parameterKey" -> ("fixedLine:" <> ToString[id, InputForm]),
    "parameter" -> parameter,
    "state" -> If[shrunkQ, "shrunk", "full"],
    "sourceZeroPoint" -> sourcePower,
    "targetZeroPoint" -> targetPower,
    "derivedTargetZeroPoint" -> derivedTarget,
    "zeroPointOverrideSource" -> overrideSource,
    "integerShift" -> integerShift,
    "compiledIntegerShift" -> integerShift,
    "zeroPointShift" -> zeroPointShift,
    "compiledZeroPointShift" -> zeroPointShift,
    "targetMinusSource" -> targetMinusSource,
    "normalizedResidualPower" -> residualPower,
    "prefactorPower" -> Expand[-targetPower]
    |>
   ];


sectorPrefactorData017[topo_Association] := Module[{records},
   records = fixedLinePrefactorRecord017[topo, #] & /@ Select[
      Range[topo["nE"]],
      ! lineIndexedPowerQ[topo["lines"][[#]]] &
      ];
   <|
    "lineIndices" -> Lookup[records, "lineIndex", {}],
    "parameterKeys" -> Lookup[records, "parameterKey", {}],
    "parameterList" -> Lookup[records, "parameter", {}],
    "powerList" -> Lookup[records, "prefactorPower", {}],
    "powerParts" -> records,
    "constantPrefactor" -> 1,
    "normalizationConvention" -> "zeroPointOnly"
    |>
   ];


materializeSectorPrefactor017[data_Association] := Expand[
   Lookup[data, "constantPrefactor", 1] Times @@ MapThread[
      Power,
      {Lookup[data, "parameterList", {}], Lookup[data, "powerList", {}]}
      ]
   ];


sectorPrefactorRatio017[source_Association, target_Association] := Cancel[
   materializeSectorPrefactor017[Lookup[source, "sectorPrefactorData", <||>]]/
    materializeSectorPrefactor017[Lookup[target, "sectorPrefactorData", <||>]]
   ];


sectorPrefactorLogDerivative017[metadata_Association, variable_] := Cancel[
   D[materializeSectorPrefactor017[Lookup[metadata, "sectorPrefactorData", <||>]], variable]/
    materializeSectorPrefactor017[Lookup[metadata, "sectorPrefactorData", <||>]]
   ];


(* 旧 016 metadata builder 已改名为 makeSectorMetadataBase017；此包装层只增加 017
   不变量，不复制 vertex/line slot 的既有构造。 *)
makeSectorMetadata[topo_Association] := Module[
   {base, pattern, shrunkLines, lineSlots, ispSlots, parityData},
   base = makeSectorMetadataBase017[topo];
   pattern = sectorPattern017[topo, Lookup[Lookup[base, "lineSlots", {}], "packTemplate", {}]];
   shrunkLines = sectorShrunkLinesFromPattern017[pattern];
   lineSlots = MapThread[
     Join[#1, <|
        "rootLinePosition" -> #2,
        "powerSlotKind" -> Lookup[pattern[[#2]], "powerKind"],
        "shrunkQ" -> (Lookup[pattern[[#2]], "state"] === "shrunk")
        |>] &,
     {Lookup[base, "lineSlots", {}], Range[Length[pattern]]}
     ];
   ispSlots = If[Lookup[topo, "ibpMode", "full"] === "timeOnly", {}, Lookup[base, "ispSlots", {}]];
   parityData = If[Length[DownValues[parityMetadataForSector017]] > 0,
     parityMetadataForSector017[topo],
     <|"status" -> "notLoaded"|>
     ];
   Join[base, <|
     "sectorShrunkLines" -> shrunkLines,
     "sectorPattern" -> pattern,
     "sectorKey" -> sectorKeyFromPattern017[pattern],
     "lineSlots" -> lineSlots,
     "ispSlots" -> ispSlots,
     "sectorPrefactorData" -> sectorPrefactorData017[topo],
     "builtInRelationData" -> If[Length[DownValues[masslessBuiltInRelationData017]] > 0,
       masslessBuiltInRelationData017[topo],
       {}
       ],
     "parityData" -> parityData,
     "representation" -> "J[aList,linePacks,ispList]"
     |>]
   ];


integralSectorMetadata017[topo_Association, int_J] := Module[{metadataList, matches},
   metadataList = Lookup[topo, "sectorMetadataList", {makeSectorMetadata[topo]}];
   matches = Select[metadataList, integralMatchesSectorMetadataQ[int, #] &];
   Which[
    Length[matches] === 1, First[matches],
    Length[matches] === 0, Missing["NoMatchingSector"],
    True, Missing["AmbiguousSector", Lookup[matches, "sectorKey", {}]]
    ]
   ];


sectorTopologyForMetadata017[rootTopo_Association, metadata_Association] := Module[{shrunk},
   shrunk = Lookup[metadata, "sectorShrunkLines", {}];
   If[shrunk === {}, rootTopo, shrinkSectorTopology[rootTopo, shrunk]]
   ];


sectorTopologyForIntegral017[rootTopo_Association, int_J] := Module[{metadata},
   metadata = integralSectorMetadata017[rootTopo, int];
   If[Head[metadata] === Missing, metadata, sectorTopologyForMetadata017[rootTopo, metadata]]
   ];


(* ::Chapter:: *)
(*Sector-aware 公开 shape gate*)

publicIntegralShapeIssues[topo_Association, int : J[aList_, linePacks_, ispList_]] := Module[
   {metadata, issues = {}, lineSlots, expectedISP},
   metadata = integralSectorMetadata017[topo, int];
   If[Head[metadata] === Missing,
    Return[{<|"slot" -> "sector", "reason" -> metadata|>}]
    ];
   lineSlots = Lookup[metadata, "lineSlots", {}];
   expectedISP = Length[Lookup[metadata, "ispSlots", {}]];
   If[Length[aList] =!= Length[Lookup[metadata, "compactASlots", {}]],
    AppendTo[issues, <|"slot" -> "aList", "expected" -> Length[Lookup[metadata, "compactASlots", {}]], "actual" -> Length[aList]|>]
    ];
   If[Length[linePacks] =!= Length[lineSlots],
    AppendTo[issues, <|"slot" -> "linePacks", "expected" -> Length[lineSlots], "actual" -> Length[linePacks]|>],
    Do[
     If[! ListQ[linePacks[[e]]] || ! linePackMatchesSlotQ[linePacks[[e]], lineSlots[[e]]],
      AppendTo[issues, <|"slot" -> "linePack", "lineIndex" -> e,
        "expected" -> Lookup[lineSlots[[e]], "packTemplate", {}], "actual" -> linePacks[[e]]|>]
      ],
     {e, Length[linePacks]}
     ]
    ];
   If[Length[ispList] =!= expectedISP,
    AppendTo[issues, <|"slot" -> "ispList", "expected" -> expectedISP, "actual" -> Length[ispList]|>]
    ];
   issues
   ];


publicResolvedDiscreteStateIssues[topo_Association, int : J[_, linePacks_, _]] := Module[
   {metadata, issues = {}, lineSlots, positions},
   metadata = integralSectorMetadata017[topo, int];
   If[Head[metadata] === Missing, Return[{<|"slot" -> "sector", "reason" -> metadata|>}]];
   lineSlots = Lookup[metadata, "lineSlots", {}];
   Do[
    positions = Lookup[lineSlots[[e]], "nPositions", {}];
    Do[
     If[! MemberQ[{0, 1}, linePacks[[e, p]]],
      AppendTo[issues, <|"lineIndex" -> e, "packPosition" -> p, "value" -> linePacks[[e, p]]|>]
      ],
     {p, positions}
     ],
    {e, Length[lineSlots]}
    ];
   issues
   ];


validatePublicExpression[expr_, topo_Association, requireDiscreteQ_: False] := Module[
   {integrals = publicExpressionIntegrals[expr], shapeIssues, stateIssues},
   shapeIssues = Flatten[publicIntegralShapeIssues[topo, #] & /@ integrals];
   If[shapeIssues =!= {}, Message[dSIBPPublicAPI::badshape, shapeIssues]; Return[False]];
   If[TrueQ[requireDiscreteQ],
    stateIssues = Flatten[publicResolvedDiscreteStateIssues[topo, #] & /@ integrals];
    If[stateIssues =!= {}, Message[dSIBPPublicAPI::badstate, stateIssues]; Return[False]]
    ];
   True
   ];
