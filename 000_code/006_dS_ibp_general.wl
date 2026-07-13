(* ::Package:: *)
(* 本文件是 dS IBP package 的通用生成器骨架。
   目标是先把 topology-driven 的结构层做实：拓扑解析、传播子 metadata、统一 J 指标包、
   离散态枚举、完整圈动量 IBP 生成元列表、标量积/ISP 覆盖性验证。
   当前文件生成 momentum seed、time-core seed 与受保护的自动 shrink-sector seed；EOM、per-line massless endpoint canonical 与 massive theta boundary shrink 项已作为 seed 门禁接入，并提供 linear-system 层与 Kira user-defined system 导出门禁。
   性能原则：默认只定义函数和示例输入，不自动运行检查；验证必须是 seed/metadata 层或代数赋值后的小检查。 *)

ClearAll["Global`*"];


(* ::Chapter:: *)
(*环境与通用工具*)

(* 本章只处理工作目录和小工具函数。脚本可由 wolframscript 执行，也可在 notebook 中逐段运行。 *)

baseDir = If[StringQ[$InputFileName] && $InputFileName =!= "",
   DirectoryName[$InputFileName],
   If[TrueQ[$Notebooks],
    With[{nd = Quiet[NotebookDirectory[]]},
     If[StringQ[nd] && nd =!= $Failed, nd, Directory[]]
     ],
    Directory[]
    ]
   ];
SetDirectory[baseDir];


(* 只做结构零判断；解析化简应放到单独的小规模 specialized check 中。 *)
zeroQ[expr_] := TrueQ[expr === 0];


(* 用户口统一用 sp 表示 scalar product；内部仍用 qq/qk/kk 编号坐标做线性代数。 *)
SetAttributes[sp, Orderless];
SetAttributes[qq, Orderless];
SetAttributes[kk, Orderless];


(* 对称标量积记号。qq/kk 只保留上三角索引，避免同一个标量积出现两种名字。 *)
qqSym[i_, j_] := If[i <= j, qq[i, j], qq[j, i]];
kkSym[i_, j_] := If[i <= j, kk[i, j], kk[j, i]];


(* ::Chapter:: *)
(*拓扑输入规范化*)

(* 本章把用户输入的 vertexData/lineData/extLegs/loopMomenta/ispData 规范化为 Association。
   lineData 可用旧的五元组，也可用 Association；后者可显式指定 massType/skType/packType。 *)


(* 旧格式兼容：{id,{u,v},Q,nu,bbType} 默认是 massive 完整线。 *)
normalizeLine[line_Association] := line;
normalizeLine[{id_, endpoints_, momentum_, nu_, bbType_}] := <|
   "id" -> id,
   "endpoints" -> endpoints,
   "momentum" -> momentum,
   "nu" -> nu,
   "bbType" -> bbType,
   "massType" -> "massive",
   "state" -> "full"
   |>;


(* ISP 可用 {name, expr, range} 或 Association。006 用户口 expr 写成 sp[p,r] 或其线性组合。 *)
normalizeISP[isp_Association] := isp;
normalizeISP[{name_, expr_, range_}] := <|
   "name" -> name,
   "expr" -> expr,
   "range" -> range
   |>;


requiredCaseInputKeys[] := {"vertexData", "lineData", "loopMomenta"};


optionalCaseInputKeys[] := {
   "name", "extLegs", "externalMomenta", "externalInvariantRules", "rawExternalInvariantRules", "ispData", "vertexEnergies", "activeVertexIds",
   "fixedAVertexValues", "numericRules", "sampleDiscreteRules", "seedPreset", "seedRanges",
   "seedOptions", "zeroPointRules", "shrinkPrefactorRules", "kiraOrdering"
   };


validVertexEntryQ[entry_] := ListQ[entry] && Length[entry] >= 2;


validLineEntryShapeQ[entry_] := AssociationQ[entry] || MatchQ[entry, {_, _, _, _, _}];


lineEntryAssociationMissingKeys[entry_Association] := Complement[{"id", "endpoints", "momentum"}, Keys[entry]];
lineEntryAssociationMissingKeys[_] := {};


lineEntryEndpointValue[entry_Association] := Lookup[entry, "endpoints", Missing["NoEndpoints"]];
lineEntryEndpointValue[{_, endpoints_, ___}] := endpoints;
lineEntryEndpointValue[_] := Missing["NoEndpoints"];


validEndpointPairQ[endpoints_] := ListQ[endpoints] && Length[endpoints] == 2;


validISPEntryShapeQ[entry_] := AssociationQ[entry] || MatchQ[entry, {_, _, _}];


ispEntryAssociationMissingKeys[entry_Association] := Complement[{"name", "expr"}, Keys[entry]];
ispEntryAssociationMissingKeys[_] := {};


validIndexRangeSpecQ[spec_] := IntegerQ[spec] || (ListQ[spec] && Length[spec] > 0 && And @@ (IntegerQ /@ spec));


validNonNegativeIntegerQ[value_] := IntegerQ[value] && value >= 0;


allowedSeedOptionKeys[] := {
   "DiscreteMode", "MaxSeedRuleCount", "MaxDiscreteRuleCount", "MaxEquationCount",
   "MaxShrinkSectorDepth", "MaxShrinkSectorCount"
   };


validSeedOptionValueQ["DiscreteMode", value_] := MemberQ[{"sample", "all", "none"}, value];
validSeedOptionValueQ["MaxShrinkSectorDepth", value_] := value === Automatic || validNonNegativeIntegerQ[value];
validSeedOptionValueQ[key_, value_] /; MemberQ[{"MaxSeedRuleCount", "MaxDiscreteRuleCount", "MaxEquationCount", "MaxShrinkSectorCount"}, key] := validNonNegativeIntegerQ[value];
validSeedOptionValueQ[_, _] := False;


validDiscreteReplacementRuleQ[rule_] := MatchQ[Unevaluated[rule], _Rule | _RuleDelayed];


sampleDiscreteRuleSetShapeIssue[ruleSet_, index_] := Module[{badRulePositions},
   If[! ListQ[ruleSet],
    Return[<|"ruleSetIndex" -> index, "reason" -> "each sample entry must be a list of replacement rules", "entry" -> ruleSet|>]
    ];
   badRulePositions = Flatten @ Position[ruleSet, rule_ /; ! validDiscreteReplacementRuleQ[rule], {1}, Heads -> False];
   If[badRulePositions === {},
    Nothing,
    <|"ruleSetIndex" -> index, "badRulePositions" -> badRulePositions, "entry" -> ruleSet|>
    ]
   ];


sampleDiscreteRulesShapeIssues[rules_] := Module[{badEntries},
   If[! ListQ[rules],
    Return[{<|"reason" -> "sampleDiscreteRules must be a list of replacement-rule lists", "value" -> rules|>}]
    ];
   badEntries = DeleteCases[
     MapIndexed[sampleDiscreteRuleSetShapeIssue[#1, First[#2]] &, rules],
     Nothing
     ];
   badEntries
   ];


sampleDiscreteRulePairs[rules_] := Cases[
   rules,
   (Verbatim[Rule] | Verbatim[RuleDelayed])[lhs_, rhs_] :> {lhs, rhs},
   {0, Infinity}
   ];


caseInputMalformedIssues[case_Association] := Module[
   {issues = {}, vertexData, lineData, loopMomenta, externalMomenta, ispData, seedRanges, seedOptions, badVertexPositions,
    badLineShapePositions, lineMissingKeyData, badEndpointData, badISPShapePositions, ispMissingKeyData,
    sampleDiscreteRules, sampleRuleShapeIssues},
   If[KeyExistsQ[case, "vertexData"],
    vertexData = case["vertexData"];
    If[! ListQ[vertexData],
     AppendTo[issues, <|"severity" -> "error", "code" -> "malformedVertexData", "reason" -> "vertexData must be a list of {id, sign} entries"|>],
     badVertexPositions = Flatten @ Position[vertexData, entry_ /; ! validVertexEntryQ[entry], {1}, Heads -> False];
     If[badVertexPositions =!= {},
      AppendTo[issues, <|"severity" -> "error", "code" -> "malformedVertexData", "badPositions" -> badVertexPositions|>]
      ]
     ]
    ];
   If[KeyExistsQ[case, "lineData"],
    lineData = case["lineData"];
    If[! ListQ[lineData],
     AppendTo[issues, <|"severity" -> "error", "code" -> "malformedLineData", "reason" -> "lineData must be a list of line associations or {id,endpoints,momentum,nu,bbType} entries"|>],
     badLineShapePositions = Flatten @ Position[lineData, entry_ /; ! validLineEntryShapeQ[entry], {1}, Heads -> False];
     If[badLineShapePositions =!= {},
      AppendTo[issues, <|"severity" -> "error", "code" -> "malformedLineData", "badPositions" -> badLineShapePositions|>]
      ];
     lineMissingKeyData = DeleteCases[
       MapIndexed[
        If[AssociationQ[#1] && lineEntryAssociationMissingKeys[#1] =!= {},
          <|"linePosition" -> First[#2], "missingKeys" -> lineEntryAssociationMissingKeys[#1]|>,
          Nothing
          ] &,
        lineData
        ],
       Nothing
       ];
     If[lineMissingKeyData =!= {},
      AppendTo[issues, <|"severity" -> "error", "code" -> "lineDataMissingRequiredKeys", "lines" -> lineMissingKeyData|>]
      ];
     badEndpointData = DeleteCases[
       MapIndexed[
        If[validLineEntryShapeQ[#1] && lineEntryAssociationMissingKeys[#1] === {} && ! validEndpointPairQ[lineEntryEndpointValue[#1]],
          <|"linePosition" -> First[#2], "endpoints" -> lineEntryEndpointValue[#1]|>,
          Nothing
          ] &,
        lineData
        ],
       Nothing
       ];
     If[badEndpointData =!= {},
      AppendTo[issues, <|"severity" -> "error", "code" -> "malformedLineEndpoints", "lines" -> badEndpointData|>]
      ]
     ]
    ];
   If[KeyExistsQ[case, "loopMomenta"],
    loopMomenta = case["loopMomenta"];
    If[! ListQ[loopMomenta],
     AppendTo[issues, <|"severity" -> "error", "code" -> "malformedLoopMomenta", "reason" -> "loopMomenta must be a list"|>]
     ]
    ];
   If[KeyExistsQ[case, "externalMomenta"],
    externalMomenta = case["externalMomenta"];
    If[! ListQ[externalMomenta],
     AppendTo[issues, <|"severity" -> "error", "code" -> "malformedExternalMomenta", "reason" -> "externalMomenta must be a list"|>]
     ]
    ];
   If[KeyExistsQ[case, "seedRanges"],
    seedRanges = case["seedRanges"];
    If[! AssociationQ[seedRanges],
     AppendTo[issues, <|"severity" -> "error", "code" -> "malformedSeedRanges", "reason" -> "seedRanges must be an Association"|>]
     ]
    ];
   If[KeyExistsQ[case, "seedOptions"],
    seedOptions = case["seedOptions"];
    If[! AssociationQ[seedOptions],
     AppendTo[issues, <|"severity" -> "error", "code" -> "malformedSeedOptions", "reason" -> "seedOptions must be an Association"|>]
     ]
    ];
   If[KeyExistsQ[case, "ispData"],
    ispData = case["ispData"];
    If[! ListQ[ispData],
     AppendTo[issues, <|"severity" -> "error", "code" -> "malformedISPData", "reason" -> "ispData must be a list of ISP associations or {name,expr,range} entries"|>],
     badISPShapePositions = Flatten @ Position[ispData, entry_ /; ! validISPEntryShapeQ[entry], {1}, Heads -> False];
     If[badISPShapePositions =!= {},
      AppendTo[issues, <|"severity" -> "error", "code" -> "malformedISPData", "badPositions" -> badISPShapePositions|>]
      ];
     ispMissingKeyData = DeleteCases[
       MapIndexed[
        If[AssociationQ[#1] && ispEntryAssociationMissingKeys[#1] =!= {},
          <|"ispPosition" -> First[#2], "missingKeys" -> ispEntryAssociationMissingKeys[#1]|>,
          Nothing
          ] &,
        ispData
        ],
       Nothing
       ];
     If[ispMissingKeyData =!= {},
      AppendTo[issues, <|"severity" -> "error", "code" -> "ispDataMissingRequiredKeys", "isps" -> ispMissingKeyData|>]
      ]
     ]
     ];
    If[KeyExistsQ[case, "sampleDiscreteRules"],
     sampleDiscreteRules = case["sampleDiscreteRules"];
     sampleRuleShapeIssues = sampleDiscreteRulesShapeIssues[sampleDiscreteRules];
     If[sampleRuleShapeIssues =!= {},
      AppendTo[issues, <|"severity" -> "error", "code" -> "malformedSampleDiscreteRules", "issues" -> sampleRuleShapeIssues|>]
      ]
     ];
    issues
    ];


(* raw case 入口的轻量 preflight；避免缺必需字段时 parser 先抛底层 Part 消息。 *)
caseInputRequirementReport[case_Association] := Module[
   {keys = Keys[case], required = requiredCaseInputKeys[], optional = optionalCaseInputKeys[], malformedIssues},
   malformedIssues = caseInputMalformedIssues[case];
   <|
    "providedKeys" -> keys,
    "requiredKeys" -> required,
    "optionalKeys" -> optional,
    "missingRequiredKeys" -> Complement[required, keys],
    "unknownKeys" -> Complement[keys, Join[required, optional]],
    "malformedInputIssues" -> malformedIssues,
    "completeRequiredKeysQ" -> TrueQ[Complement[required, keys] === {}],
    "inputPreflightPassQ" -> TrueQ[Complement[required, keys] === {} && malformedIssues === {}]
    |>
   ];


caseInputErrorReport[case_Association] := Module[{report = caseInputRequirementReport[case]},
   With[{issues = Join[
       If[report["missingRequiredKeys"] === {}, {}, {<|"severity" -> "error", "code" -> "missingRequiredCaseKeys", "missingRequiredKeys" -> report["missingRequiredKeys"]|>}],
       report["malformedInputIssues"]
       ]},
   <|
    "status" -> If[issues === {}, "ok", "issues"],
    "errorCount" -> Length[issues],
    "warningCount" -> 0,
    "pendingCount" -> 0,
    "pendingFeatures" -> {},
    "inputRequirementReport" -> report,
    "issues" -> issues
    |>
    ]
   ];


caseInputMissingRequiredKeysQ[case_Association] := ! TrueQ[caseInputRequirementReport[case]["completeRequiredKeysQ"]];


caseInputPreflightErrorQ[case_Association] := ! TrueQ[caseInputRequirementReport[case]["inputPreflightPassQ"]];


seedPresetAssociation[preset_] := Switch[preset,
   "quickCheck" | Automatic | Missing["NotSet"],
   <|
    "seedRanges" -> <|"a" -> {0}, "b" -> {0}, "isp" -> {0}, "sampleOnly" -> True|>,
    "seedOptions" -> <|"DiscreteMode" -> "sample", "MaxSeedRuleCount" -> 200, "MaxDiscreteRuleCount" -> 64, "MaxEquationCount" -> 80, "MaxShrinkSectorDepth" -> Automatic, "MaxShrinkSectorCount" -> 16|>
    |>,
   "fullDiscrete",
   <|
    "seedRanges" -> <|"a" -> {0}, "b" -> {0}, "isp" -> {0}, "sampleOnly" -> True|>,
    "seedOptions" -> <|"DiscreteMode" -> "all", "MaxSeedRuleCount" -> 200, "MaxDiscreteRuleCount" -> 64, "MaxEquationCount" -> 200, "MaxShrinkSectorDepth" -> Automatic, "MaxShrinkSectorCount" -> 16|>
    |>,
   "bounded",
   <|
    "seedRanges" -> <|"a" -> {-1, 1}, "b" -> {-2, 2}, "isp" -> {0, 1}, "sampleOnly" -> False|>,
    "seedOptions" -> <|"DiscreteMode" -> "all", "MaxSeedRuleCount" -> 200, "MaxDiscreteRuleCount" -> 64, "MaxEquationCount" -> 200, "MaxShrinkSectorDepth" -> Automatic, "MaxShrinkSectorCount" -> 16|>
    |>,
   _,
   <|
    "seedRanges" -> <|"a" -> {0}, "b" -> {0}, "isp" -> {0}, "sampleOnly" -> True|>,
    "seedOptions" -> <|"DiscreteMode" -> "sample", "MaxSeedRuleCount" -> 200, "MaxDiscreteRuleCount" -> 64, "MaxEquationCount" -> 80, "MaxShrinkSectorDepth" -> Automatic, "MaxShrinkSectorCount" -> 16|>,
    "unknownPreset" -> preset
    |>
   ];


normalizeSeedConfig[case_Association] := Module[
   {preset = Lookup[case, "seedPreset", "quickCheck"], presetData, seedRanges, seedOptions},
   presetData = seedPresetAssociation[preset];
   seedRanges = Join[Lookup[presetData, "seedRanges", <||>], Lookup[case, "seedRanges", <||>]];
   seedOptions = Join[Lookup[presetData, "seedOptions", <||>], Lookup[case, "seedOptions", <||>]];
   <|
    "seedPreset" -> preset,
    "seedRanges" -> seedRanges,
    "seedOptions" -> seedOptions,
    "unknownSeedPreset" -> Lookup[presetData, "unknownPreset", None]
    |>
   ];


(* 由端点顶点的 +/- 标记推断 SK 类型。 *)
inferSKType[endpoints_, vertexSignAssoc_] := StringJoin[
   ToString[Lookup[vertexSignAssoc, endpoints[[1]], "+"]],
   ToString[Lookup[vertexSignAssoc, endpoints[[2]], "+"]]
   ];


(* packType 是后续统一 J 表示的核心分派键。massless 统一走双 theta 合并路线。 *)
inferPackType[massType_, skType_, state_] := Which[
   state === "shrunk", "shrunk",
   massType === "massive" && MemberQ[{"+-", "-+"}, skType], "massiveCross",
   massType === "massless" && MemberQ[{"++", "--"}, skType], "masslessFull",
   massType === "massless" && MemberQ[{"+-", "-+"}, skType], "masslessCross",
   True, "massiveFull"
   ];


(* 补齐每条线的默认 metadata。thetaConvention 固定为 mergedTwoTheta，避免主线再切到单 theta 路线。 *)
completeLineMetadata[line_, vertexSignAssoc_] := Module[
   {endpoints, massType, skType, state, packType},
   endpoints = line["endpoints"];
   massType = Lookup[line, "massType", "massive"];
   skType = Lookup[line, "skType", inferSKType[endpoints, vertexSignAssoc]];
   state = Lookup[line, "state", "full"];
   packType = Lookup[line, "packType", inferPackType[massType, skType, state]];
   Join[
    line,
    <|
     "massType" -> massType,
     "skType" -> skType,
     "state" -> state,
     "thetaConvention" -> "mergedTwoTheta",
     "packType" -> packType
     |>
    ]
   ];


(* 将一个 case 解析为通用拓扑对象。externalMomenta 必须给出独立外动量基。 *)
parseTopology::missingkeys = "case 缺少必需字段：`1`。";
parseTopology::badinput = "case 输入 preflight 失败：`1`。";


parseTopology[case_Association] := Module[
   {vertexData, vertexIds, vertexSignAssoc, rawLines, lines, loopMomenta,
   externalMomenta, rawExternalInvariantRules, externalInvariantRules, ispData, nV, nE, nL, nK, bMatrix, vertexLines,
    eMomenta, loopCoeffMatrix, externalCoeffMatrix, externalPartList, seedConfig, topoContext},
   If[caseInputPreflightErrorQ[case],
    If[caseInputMissingRequiredKeysQ[case],
     Message[parseTopology::missingkeys, caseInputRequirementReport[case]["missingRequiredKeys"]],
     Message[parseTopology::badinput, Lookup[caseInputErrorReport[case], "issues", {}]]
     ];
    Return[$Failed]
    ];
   vertexData = case["vertexData"];
   vertexIds = vertexData[[All, 1]];
   vertexSignAssoc = Association[Rule @@@ vertexData];
   rawLines = normalizeLine /@ case["lineData"];
   lines = completeLineMetadata[#, vertexSignAssoc] & /@ rawLines;
   loopMomenta = case["loopMomenta"];
   externalMomenta = Lookup[case, "externalMomenta", {}];
   ispData = normalizeISP /@ Lookup[case, "ispData", {}];
   nV = Length[vertexIds];
   nE = Length[lines];
   nL = Length[loopMomenta];
   nK = Length[externalMomenta];
   eMomenta = Lookup[lines, "momentum"];
   bMatrix = Table[
     Which[
      lines[[e]]["endpoints"][[1]] === vertexIds[[v]], 1,
      lines[[e]]["endpoints"][[2]] === vertexIds[[v]], -1,
      True, 0
      ],
     {v, nV}, {e, nE}
     ];
   vertexLines = Table[
     Select[Table[{e, bMatrix[[v, e]]}, {e, nE}], #[[2]] =!= 0 &],
     {v, nV}
     ];
   loopCoeffMatrix = Table[
     Coefficient[eMomenta[[e]], loopMomenta[[l]]],
     {e, nE}, {l, nL}
     ];
   externalCoeffMatrix = Table[
     Coefficient[eMomenta[[e]], externalMomenta[[j]]],
     {e, nE}, {j, nK}
     ];
   externalPartList = Table[
     eMomenta[[e]] - Sum[loopCoeffMatrix[[e, l]] loopMomenta[[l]], {l, nL}],
     {e, nE}
     ];
   topoContext = <|"loopMomenta" -> loopMomenta, "externalMomenta" -> externalMomenta, "nL" -> nL, "nK" -> nK|>;
   rawExternalInvariantRules = Lookup[case, "rawExternalInvariantRules", Lookup[case, "externalInvariantRules", Automatic]];
   externalInvariantRules = normalizeExternalInvariantRulesForTopology[rawExternalInvariantRules, topoContext];
   topoContext = Join[topoContext, <|"externalInvariantRules" -> externalInvariantRules|>];
   seedConfig = normalizeSeedConfig[case];
   <|
    "name" -> Lookup[case, "name", "unnamed"],
    "vertexData" -> vertexData,
    "vertexIds" -> vertexIds,
    "vertexSignAssoc" -> vertexSignAssoc,
    "lines" -> lines,
    "extLegs" -> Lookup[case, "extLegs", {}],
    "vertexEnergies" -> Lookup[case, "vertexEnergies", <||>],
    "activeVertexIds" -> Lookup[case, "activeVertexIds", vertexIds],
    "fixedAVertexValues" -> Lookup[case, "fixedAVertexValues", <||>],
    "loopMomenta" -> loopMomenta,
    "externalMomenta" -> externalMomenta,
    "rawExternalInvariantRules" -> rawExternalInvariantRules,
    "externalInvariantRules" -> externalInvariantRules,
    "ispData" -> ispData,
    "nV" -> nV,
    "nE" -> nE,
    "nL" -> nL,
    "nK" -> nK,
    "bMatrix" -> bMatrix,
    "vertexLines" -> vertexLines,
    "loopCoeffMatrix" -> loopCoeffMatrix,
    "externalCoeffMatrix" -> externalCoeffMatrix,
    "externalPartList" -> externalPartList,
    "numericRules" -> normalizeNumericRulesForTopology[Lookup[case, "numericRules", {}], topoContext],
    "sampleDiscreteRules" -> Lookup[case, "sampleDiscreteRules", {}],
    "seedPreset" -> seedConfig["seedPreset"],
    "seedRanges" -> seedConfig["seedRanges"],
    "seedOptions" -> seedConfig["seedOptions"],
    "unknownSeedPreset" -> seedConfig["unknownSeedPreset"],
    "zeroPointRules" -> Lookup[case, "zeroPointRules", {}],
    "shrinkPrefactorRules" -> Lookup[case, "shrinkPrefactorRules", {}],
    "kiraOrdering" -> Lookup[case, "kiraOrdering", <||>],
    "sectorVertexRepresentativeMap" -> Lookup[case, "sectorVertexRepresentativeMap", AssociationThread[vertexIds -> vertexIds]]
    |>
   ];


(* ::Chapter:: *)
(*统一 J 指标包与离散态枚举*)

(* 本章实现 massive/massless 的自然指标打包。离散态按每条线 metadata 枚举，
   不再使用旧 bubble 原型中的 Tuples[{0,1}, 2 nE]。 *)


makeLinePack[line_Association] := Module[{id = line["id"]},
   Switch[line["packType"],
    "massiveFull", {b[id], n[id, 1], n[id, 2]},
    "massiveCross", {b[id], n[id, 1], n[id, 2]},
    "masslessFull", {b[id], n[id]},
    "masslessCross", {b[id]},
    "shrunk", {bS[id]},
    _, Message[makeLinePack::badtype, line["packType"], id]; $Failed
    ]
   ];
makeLinePack::badtype = "未知 packType `1`，line id = `2`。";


makeLinePacks[topo_Association] := makeLinePack /@ topo["lines"];


makeBaseIntegral[topo_Association] := Module[
   {active = Lookup[topo, "activeVertexIds", topo["vertexIds"]], fixedA = Lookup[topo, "fixedAVertexValues", <||>]},
   J[
    Table[If[AssociationQ[fixedA] && KeyExistsQ[fixedA, v], fixedA[v], a[v]], {v, active}],
    makeLinePacks[topo],
    Table[ispN[j], {j, Length[topo["ispData"]]}]
    ]
   ];


makeSectorMetadata[topo_Association] := Module[
   {fixedA = Lookup[topo, "fixedAVertexValues", <||>], active = Lookup[topo, "activeVertexIds", topo["vertexIds"]],
    lines = topo["lines"], vertexIds = topo["vertexIds"], repMap, originalSlotByVertex, compactSlotByVertex,
    activeOriginalGroups, vertexSlots, compactASlots, lineSlots},
   repMap = Lookup[topo, "sectorVertexRepresentativeMap", AssociationThread[topo["vertexIds"] -> topo["vertexIds"]]];
   originalSlotByVertex = AssociationThread[vertexIds -> Range[Length[vertexIds]]];
   activeOriginalGroups = Table[
     v -> Select[vertexIds, Lookup[repMap, #, #] === v &],
     {v, active}
     ];
   compactSlotByVertex = Association @ Flatten[
      Table[Thread[activeOriginalGroups[[i, 2]] -> i], {i, Length[activeOriginalGroups]}],
      1
      ];
   vertexSlots = Table[
     <|
      "slot" -> i,
      "vertexId" -> vertexIds[[i]],
      "representativeVertexId" -> Lookup[repMap, vertexIds[[i]], vertexIds[[i]]],
      "aSymbol" -> a[vertexIds[[i]]],
      "activeQ" -> MemberQ[active, vertexIds[[i]]],
      "fixedValue" -> If[AssociationQ[fixedA] && KeyExistsQ[fixedA, vertexIds[[i]]], fixedA[vertexIds[[i]]], None],
      "compactASlot" -> Lookup[compactSlotByVertex, vertexIds[[i]], None]
      |>,
     {i, Length[vertexIds]}
     ];
   compactASlots = Table[
     <|
      "compactSlot" -> i,
      "representativeVertexId" -> active[[i]],
      "originalVertexIds" -> activeOriginalGroups[[i, 2]],
      "originalSlots" -> Lookup[originalSlotByVertex, activeOriginalGroups[[i, 2]]],
      "aSymbol" -> a[active[[i]]]
      |>,
     {i, Length[active]}
     ];
   lineSlots = Table[
     With[{pack = makeLinePack[lines[[e]]], endpoints = lines[[e]]["endpoints"], originalEndpoints = Lookup[lines[[e]], "originalEndpoints", lines[[e]]["endpoints"]]},
      <|
       "slot" -> e,
       "lineId" -> lines[[e]]["id"],
       "packType" -> lines[[e]]["packType"],
       "massType" -> lines[[e]]["massType"],
       "state" -> lines[[e]]["state"],
       "endpoints" -> endpoints,
       "originalEndpoints" -> originalEndpoints,
       "endpointOriginalASlots" -> Lookup[originalSlotByVertex, originalEndpoints],
       "endpointCompactASlots" -> Lookup[compactSlotByVertex, endpoints, None],
       "bSymbol" -> pack[[1]],
       "packTemplate" -> pack
       |>
      ],
     {e, Length[lines]}
     ];
   <|
    "caseName" -> topo["name"],
    "sectorShrunkLines" -> Lookup[topo, "sectorShrunkLines", {}],
    "sectorKey" -> sectorKeyFromShrunkLines[Lookup[topo, "sectorShrunkLines", {}]],
    "aSlotMode" -> "compactActiveSlots",
    "sectorVertexRepresentativeMap" -> repMap,
    "vertexIdToOriginalASlot" -> originalSlotByVertex,
    "vertexIdToCompactASlot" -> compactSlotByVertex,
    "vertexSlots" -> vertexSlots,
    "compactASlots" -> compactASlots,
    "activeASlots" -> Range[Length[active]],
    "lineSlots" -> lineSlots,
    "lineIdToSlot" -> AssociationThread[Lookup[lines, "id"] -> Range[Length[lines]]],
    "bSymbolToLineSlot" -> AssociationThread[lineSlots[[All, "bSymbol"]] -> Range[Length[lineSlots]]],
    "ispSlots" -> Table[
      <|"slot" -> j, "indexSymbol" -> ispN[j], "data" -> topo["ispData"][[j]]|>,
      {j, Length[topo["ispData"]]}
      ]
    |>
   ];


sectorKeyFromShrunkLines[shrunkLines_List] := If[shrunkLines === {}, "top", StringRiffle["e" <> ToString[#] & /@ shrunkLines, "_"]];


sectorMetadataKey[metadata_Association] := Lookup[metadata, "sectorKey", sectorKeyFromShrunkLines[Lookup[metadata, "sectorShrunkLines", {}]]];


sectorMetadataLinePackLengths[metadata_Association] := Length /@ Lookup[Lookup[metadata, "lineSlots", {}], "packTemplate", {}];


parsedTopologyQ[spec_Association] := TrueQ[KeyExistsQ[spec, "lines"] && KeyExistsQ[spec, "nL"]];
parsedTopologyQ[_] := False;


normalizeTopologySpec[spec_Association] := If[parsedTopologyQ[spec], spec, parseTopology[spec]];
normalizeTopologySpec[spec_] := spec;


indexContainsLineSymbolQ[index_, symbol_] := ! FreeQ[index, symbol];


indexHasAnyLineSymbolQ[index_] := ! FreeQ[index, _b | _bS];


linePackMatchesSlotQ[pack_List, slot_Association] := Module[
   {template = Lookup[slot, "packTemplate", {}], bSymbol = Lookup[slot, "bSymbol", Missing["bSymbol"]]},
   TrueQ[Length[pack] === Length[template]] &&
    TrueQ[
     Head[bSymbol] === Missing ||
      indexContainsLineSymbolQ[First[pack], bSymbol] ||
      ! indexHasAnyLineSymbolQ[First[pack]]
     ]
   ];


integralMatchesSectorMetadataQ[J[aList_, linePacks_, ispList_], metadata_Association] := Module[
   {lineSlots = Lookup[metadata, "lineSlots", {}], compactASlots = Lookup[metadata, "compactASlots", {}], ispSlots = Lookup[metadata, "ispSlots", {}]},
   TrueQ[
    Length[aList] === Length[compactASlots] &&
     Length[linePacks] === Length[lineSlots] &&
     Length[ispList] === Length[ispSlots] &&
     And @@ MapThread[linePackMatchesSlotQ, {linePacks, lineSlots}]
    ]
   ];


integralSectorKey[J[aList_, linePacks_, ispList_], metadataList_List] := Module[
   {matches},
   matches = Select[metadataList, integralMatchesSectorMetadataQ[J[aList, linePacks, ispList], #] &];
   Which[
    Length[matches] == 1, sectorMetadataKey[First[matches]],
    Length[matches] == 0, Missing["NoMatchingSector"],
    True, Missing["AmbiguousSector", sectorMetadataKey /@ matches]
    ]
   ];


batchSectorMetadataList[batch_Association, topoSpec_: Automatic] := Module[
   {fromBatch, topo, topMetadata},
   fromBatch = Lookup[batch, "sectorMetadataList", Missing["NoSectorMetadataList"]];
   If[ListQ[fromBatch], Return[fromBatch]];
   If[AssociationQ[Lookup[batch, "sectorMetadata", Missing["NoSectorMetadata"]]], Return[{batch["sectorMetadata"]}]];
   topo = normalizeTopologySpec[topoSpec];
   topMetadata = If[parsedTopologyQ[topo], makeSectorMetadata[topo], Missing["NoSectorMetadata"]];
   If[Head[topMetadata] === Missing, {}, {topMetadata}]
   ];


normaliseKiraOrderingSpec[spec_] := Which[
   AssociationQ[spec], spec,
   True, <||>
   ];


allowedKiraOrderingKeys[] := {"IntegralOrder", "ManualIntegralOrder", "PreferredIntegrals", "PreferredPriority", "SectorRank", "SectorOrder"};


validateKiraOrderingSpec[Automatic] := <|"status" -> "ok", "issues" -> {}|>;
validateKiraOrderingSpec[spec_] /; ! AssociationQ[spec] := <|"status" -> "invalidKiraOrdering", "reason" -> "KiraOrdering must be Automatic or an Association", "kiraOrdering" -> spec|>;
validateKiraOrderingSpec[spec_Association] := Module[
   {unknownKeys, badValueData},
   unknownKeys = Complement[Keys[spec], allowedKiraOrderingKeys[]];
   badValueData = DeleteCases[
     {
      If[KeyExistsQ[spec, "IntegralOrder"] && ! ListQ[spec["IntegralOrder"]], <|"optionKey" -> "IntegralOrder", "optionValue" -> spec["IntegralOrder"]|>, Nothing],
      If[KeyExistsQ[spec, "ManualIntegralOrder"] && ! ListQ[spec["ManualIntegralOrder"]], <|"optionKey" -> "ManualIntegralOrder", "optionValue" -> spec["ManualIntegralOrder"]|>, Nothing],
      If[KeyExistsQ[spec, "PreferredIntegrals"] && ! ListQ[spec["PreferredIntegrals"]], <|"optionKey" -> "PreferredIntegrals", "optionValue" -> spec["PreferredIntegrals"]|>, Nothing],
      If[KeyExistsQ[spec, "PreferredPriority"] && ! MemberQ[{"BeforeB", "AfterB"}, spec["PreferredPriority"]], <|"optionKey" -> "PreferredPriority", "optionValue" -> spec["PreferredPriority"]|>, Nothing],
      If[KeyExistsQ[spec, "SectorRank"] && ! AssociationQ[spec["SectorRank"]], <|"optionKey" -> "SectorRank", "optionValue" -> spec["SectorRank"]|>, Nothing],
      If[KeyExistsQ[spec, "SectorOrder"] && ! ListQ[spec["SectorOrder"]], <|"optionKey" -> "SectorOrder", "optionValue" -> spec["SectorOrder"]|>, Nothing]
      },
     Nothing
     ];
   If[unknownKeys === {} && badValueData === {},
    <|"status" -> "ok", "issues" -> {}|>,
    <|"status" -> "invalidKiraOrdering", "reason" -> "KiraOrdering contains unknown keys or invalid values", "unknownKiraOrderingKeys" -> unknownKeys, "malformedKiraOrderingValues" -> badValueData, "allowedKiraOrderingKeys" -> allowedKiraOrderingKeys[]|>
    ]
   ];


resolveKiraOrderingSpec[batch_Association, topoSpec_, optSpec_] := Module[{topo, spec},
   topo = normalizeTopologySpec[topoSpec];
   spec = Which[
     optSpec =!= Automatic, optSpec,
     parsedTopologyQ[topo], Lookup[topo, "kiraOrdering", <||>],
     AssociationQ[Lookup[batch, "kiraOrdering", Missing["NoKiraOrdering"]]], batch["kiraOrdering"],
     True, <||>
     ];
   normaliseKiraOrderingSpec[spec]
   ];


preferredIntegralRank[int_, orderingSpec_Association] := Module[
   {manual = Lookup[orderingSpec, "IntegralOrder", Lookup[orderingSpec, "ManualIntegralOrder", {}]], preferred, pos},
   If[! ListQ[manual], manual = {}];
   preferred = DeleteDuplicates@Join[manual, Lookup[orderingSpec, "PreferredIntegrals", {}]];
   pos = FirstPosition[preferred, int, Missing["NotPreferred"], {1}, Heads -> False];
   If[Head[pos] === Missing, 10^9, First[pos] - 1]
   ];


sectorRankFromOrdering[sectorKey_, orderingSpec_Association] := Module[
   {rank = Lookup[orderingSpec, "SectorRank", <||>], order = Lookup[orderingSpec, "SectorOrder", {}], pos},
   Which[
    AssociationQ[rank] && KeyExistsQ[rank, sectorKey], rank[sectorKey],
    ListQ[order] && MemberQ[order, sectorKey], First[FirstPosition[order, sectorKey]] - 1,
    True, 0
    ]
   ];


numericIndexValue[x_Integer] := x;
numericIndexValue[x_Rational] := x;
numericIndexValue[x_Real] := x;
numericIndexValue[_] := 0;


integralSortKey[J[aList_, linePacks_, ispList_], orderingSpec_: <||>, metadataList_: {}] := Module[
   {int = J[aList, linePacks, ispList], spec = normaliseKiraOrderingSpec[orderingSpec], bValues, aValues, ispValues, nValues,
    preferredRank, sectorKey, sectorRank, baseKey, priority},
   bValues = numericIndexValue /@ linePacks[[All, 1]];
   aValues = numericIndexValue /@ aList;
   ispValues = numericIndexValue /@ ispList;
   nValues = numericIndexValue /@ Flatten[Rest /@ Select[linePacks, Length[#] > 1 &]];
   preferredRank = preferredIntegralRank[int, spec];
   sectorKey = integralSectorKey[int, metadataList];
   sectorRank = sectorRankFromOrdering[sectorKey, spec];
   baseKey = {
     Total[Abs /@ bValues],
     Total[Clip[bValues, {0, Infinity}]],
     Total[Abs /@ aValues],
     Total[Abs /@ ispValues],
     Total[nValues],
     sectorRank,
     ToString[InputForm[int]]
     };
   priority = Lookup[spec, "PreferredPriority", "AfterB"];
   If[priority === "BeforeB",
    Prepend[baseKey, preferredRank],
    Insert[baseKey, preferredRank, 3]
    ]
   ];


sortIntegralsForKira[integrals_List, orderingSpec_: <||>, metadataList_: {}] := SortBy[integrals, integralSortKey[#, orderingSpec, metadataList] &];


integralOrderItemToIntegral[item_, integrals_List] := Which[
   Head[item] === J && MemberQ[integrals, item], item,
   IntegerQ[item] && 1 <= item <= Length[integrals], integrals[[item]],
   True, Missing["UnknownIntegralOrderItem", item]
   ];


normaliseIntegralOrder[order_List, integrals_List] := DeleteDuplicates @ DeleteMissing[
    integralOrderItemToIntegral[#, integrals] & /@ order
    ];


missingIntegralOrderItems[order_List, integrals_List] := Cases[
   integralOrderItemToIntegral[#, integrals] & /@ order,
   Missing["UnknownIntegralOrderItem", item_] :> item
   ];


validateKiraIntegralOrderSpec[orderSpec_] := If[orderSpec === Automatic || ListQ[orderSpec],
   <|"status" -> "ok"|>,
   <|"status" -> "invalidKiraIntegralOrder", "reason" -> "KiraIntegralOrder must be Automatic or a list of integral IDs/J objects", "kiraIntegralOrder" -> orderSpec|>
   ];


kiraOrderingIntegralRequestList[orderingSpec_Association] := Module[
   {manual = Lookup[orderingSpec, "IntegralOrder", Lookup[orderingSpec, "ManualIntegralOrder", {}]],
    preferred = Lookup[orderingSpec, "PreferredIntegrals", {}]},
   If[! ListQ[manual], manual = {}];
   If[! ListQ[preferred], preferred = {}];
   DeleteDuplicates@Join[manual, preferred]
   ];


kiraOrderingMatchReport[orderingSpec_Association, integrals_List] := Module[
   {requested = kiraOrderingIntegralRequestList[orderingSpec], matched, missing},
   matched = normaliseIntegralOrder[requested, integrals];
   missing = DeleteDuplicates @ missingIntegralOrderItems[requested, integrals];
   <|
    "requestedIntegrals" -> requested,
    "matchedIntegrals" -> matched,
    "missingIntegralOrderItems" -> missing,
    "allRequestedIntegralsMatchedQ" -> TrueQ[missing === {}]
    |>
   ];


integralMetadataList[integrals_List, metadataList_List, orderingSpec_: <||>] := Table[
   <|
    "id" -> i,
    "sectorKey" -> integralSectorKey[integrals[[i]], metadataList],
    "sortKey" -> integralSortKey[integrals[[i]], orderingSpec, metadataList]
    |>,
   {i, Length[integrals]}
   ];




discreteVarsForLine[line_Association] := Module[{id = line["id"]},
   Switch[line["packType"],
    "massiveFull", {n[id, 1], n[id, 2]},
    "massiveCross", {n[id, 1], n[id, 2]},
    "masslessFull", {n[id]},
    _, {}
    ]
   ];


ruleSetsForVars[vars_List] := If[Length[vars] == 0,
   {{}},
   Thread[vars -> #] & /@ Tuples[{0, 1}, Length[vars]]
   ];


(* 输出为 {rules, integrals}，便于检查 seed 数和具体替换规则。 *)
enumerateDiscreteStates[expr_, topo_Association] := Module[
   {perLineRuleSets, allRuleSets},
   perLineRuleSets = ruleSetsForVars /@ (discreteVarsForLine /@ topo["lines"]);
   allRuleSets = Flatten[#, 1] & /@ Tuples[perLineRuleSets];
   <|
    "rules" -> allRuleSets,
    "integrals" -> (expr /. # & /@ allRuleSets)
    |>
   ];


(* 大拓扑下不要为了 summary 展开所有离散态；计数只用逐线状态数相乘。 *)
discreteStateCountForLine[line_Association] := Switch[line["packType"],
   "massiveFull", 4,
   "massiveCross", 4,
   "masslessFull", 2,
   _, 1
   ];


discreteStateCount[topo_Association] := Times @@ (discreteStateCountForLine /@ topo["lines"]);


(* 验证只看手选样本；若 case 未给 sampleDiscreteRules，则只保留未替换模板。 *)
sampleDiscreteIntegrals[expr_, topo_Association] := Module[{rules = topo["sampleDiscreteRules"]},
   If[Length[rules] == 0,
    {expr},
    expr /. # & /@ rules
    ]
   ];


(* sample 模式必须给出完整 n=0/1 替换；否则 seed 中会残留符号 n，无法保证即时 EOM。 *)
sampleDiscreteRuleCoverageIssues[topo_Association, rules_List] := Module[
   {vars = Flatten[discreteVarsForLine /@ topo["lines"]]},
   If[vars === {}, Return[{}]];
    DeleteCases[
     MapIndexed[
      Module[{pairs, ruleVars, missing},
        pairs = sampleDiscreteRulePairs[#1];
        ruleVars = If[pairs === {}, {}, DeleteDuplicates[pairs[[All, 1]]]];
        missing = Complement[vars, ruleVars];
        If[missing === {},
         Nothing,
         <|"ruleIndex" -> First[#2], "missingVariables" -> missing, "rule" -> #1|>
        ]
       ] &,
     rules
     ],
    Nothing
    ]
   ];


(* ::Chapter:: *)
(*EOM canonical 与 forbidden-n 扫描*)

(* 本章只处理已经出现在 J 指标中的 Hankel 二阶导数态。
   seed 生成时应先枚举 n=0/1；若生成元把 massiveFull 的端点 n 推到 2 或更高，
   这里立即用 EOM 递推回 n=0/1。massless 的 {b,n} 只有两个状态，不用 Hankel EOM。 *)

vertexPosition[topo_Association, vertexId_] := Module[{pos},
   pos = FirstPosition[topo["vertexIds"], vertexId, Missing["NotFound"]];
   If[Head[pos] === Missing, Missing["VertexNotFound", vertexId], First[pos]]
   ];


activeAVertexIds[topo_Association] := Lookup[topo, "activeVertexIds", topo["vertexIds"]];


vertexRepresentative[topo_Association, vertexId_] := Lookup[
   Lookup[topo, "sectorVertexRepresentativeMap", AssociationThread[topo["vertexIds"] -> topo["vertexIds"]]],
   vertexId,
   vertexId
   ];


vertexASlot[topo_Association, vertexId_] := Module[
   {rep = vertexRepresentative[topo, vertexId], pos},
   pos = FirstPosition[activeAVertexIds[topo], rep, Missing["NotActiveVertex"]];
   If[Head[pos] === Missing, Missing["ActiveVertexNotFound", vertexId, rep], First[pos]]
   ];


shiftVertexA[J[aList_, linePacks_, ispList_], topo_Association, vertexId_, delta_] := Module[
   {newAList = aList, pos},
   pos = vertexASlot[topo, vertexId];
   If[Head[pos] === Missing, Return[$Failed]];
   newAList[[pos]] = newAList[[pos]] + delta;
   J[newAList, linePacks, ispList]
   ];


shiftLinePackEntry[J[aList_, linePacks_, ispList_], e_Integer, packPos_Integer, delta_] := Module[
   {newLinePacks = linePacks},
   newLinePacks[[e, packPos]] = newLinePacks[[e, packPos]] + delta;
   J[aList, newLinePacks, ispList]
   ];


setLinePackEntry[J[aList_, linePacks_, ispList_], e_Integer, packPos_Integer, value_] := Module[
   {newLinePacks = linePacks},
   newLinePacks[[e, packPos]] = value;
   J[aList, newLinePacks, ispList]
   ];


actualLinePackType[topo_Association, e_Integer, pack_List] := Module[
   {declared = topo["lines"][[e]]["packType"]},
   If[Length[pack] === 1 && declared =!= "masslessCross",
    "shrunk",
    declared
    ]
   ];


bbEOMCoefficients[line_Association] := Module[{bbType = Lookup[line, "bbType", "h"], nu = Lookup[line, "nu", nu]},
   Which[
    KeyExistsQ[line, "eomCoefficients"], line["eomCoefficients"],
    bbType === "h", {2 nu + 1, 1},
    bbType === "H", {2 nu, 1},
    ListQ[bbType] && Length[bbType] >= 2, bbType[[1 ;; 2]],
    True, Missing["NoHankelEOM"]
    ]
   ];


massiveEOMTarget[topo_Association, J[aList_, linePacks_, ispList_]] := Module[
   {lines = topo["lines"], packType, pack, nValue, target = Missing["NoEOMTarget"]},
   Do[
    pack = linePacks[[e]];
    packType = actualLinePackType[topo, e, pack];
    If[MemberQ[{"massiveFull", "massiveCross"}, packType],
     Do[
      nValue = pack[[endpointSlot + 1]];
      If[IntegerQ[nValue] && nValue >= 2 && Head[target] === Missing,
       target = <|"lineIndex" -> e, "endpointSlot" -> endpointSlot, "nValue" -> nValue|>
       ],
      {endpointSlot, 2}
      ]
     ],
    {e, Length[lines]}
    ];
   target
   ];


eomReduceIntegralAt[topo_Association, int_J, target_Association] := Module[
   {e, endpointSlot, nValue, line, coeffs, c1, c2, nPackPos, endpointVertex, termNMinus2, termNMinus1},
   e = target["lineIndex"];
   endpointSlot = target["endpointSlot"];
   nValue = target["nValue"];
   line = topo["lines"][[e]];
   coeffs = bbEOMCoefficients[line];
   If[Head[coeffs] === Missing, Return[int]];
   {c1, c2} = coeffs;
   nPackPos = endpointSlot + 1;
   endpointVertex = line["endpoints"][[endpointSlot]];
   termNMinus2 = setLinePackEntry[int, e, nPackPos, nValue - 2];
   termNMinus1 = setLinePackEntry[int, e, nPackPos, nValue - 1];
   termNMinus1 = shiftLineB[termNMinus1, e, 1];
   termNMinus1 = shiftVertexA[termNMinus1, topo, endpointVertex, -1];
   Expand[-c2 termNMinus2 - c1 termNMinus1]
   ];


applyEOMToIntegral[topo_Association, int_J] := Module[{target},
   target = massiveEOMTarget[topo, int];
   If[Head[target] === Missing,
    int,
    applyEOM[eomReduceIntegralAt[topo, int, target], topo]
    ]
   ];


applyEOM[expr_, topo_Association] := Expand[expr /. int_J :> applyEOMToIntegral[topo, int]];


(* massless full line 采用 A 类双 theta 合并后的逐线 {b,n} 约定。
   若中间步骤显式出现 n>=2，则用 {11}=q^2 {00} 的压缩关系递归回 n=0/1。 *)
masslessEndpointTarget[topo_Association, J[aList_, linePacks_, ispList_]] := Module[
   {lines = topo["lines"], pack, target = Missing["NoMasslessEndpointTarget"]},
   Do[
    pack = linePacks[[e]];
    If[actualLinePackType[topo, e, pack] === "masslessFull",
     If[Length[pack] >= 2 && IntegerQ[pack[[2]]] && pack[[2]] >= 2 && Head[target] === Missing,
      target = <|"lineIndex" -> e, "nValue" -> pack[[2]]|>
      ]
     ],
    {e, Length[lines]}
    ];
   target
   ];


masslessEndpointReduceIntegralAt[topo_Association, int_J, target_Association] := Module[
   {e = target["lineIndex"], nValue = target["nValue"], reduced},
   reduced = setLinePackEntry[int, e, 2, nValue - 2];
   shiftLineB[reduced, e, -2]
   ];


applyMasslessEndpointCanonicalToIntegral[topo_Association, int_J] := Module[{target},
   target = masslessEndpointTarget[topo, int];
   If[Head[target] === Missing,
    int,
    applyMasslessEndpointCanonical[masslessEndpointReduceIntegralAt[topo, int, target], topo]
    ]
   ];


applyMasslessEndpointCanonical[expr_, topo_Association] := Expand[expr /. int_J :> applyMasslessEndpointCanonicalToIntegral[topo, int]];


applySeedCanonical[expr_, topo_Association] := applyMasslessEndpointCanonical[applyEOM[expr, topo], topo];


forbiddenNDataForIntegral[topo_Association, J[aList_, linePacks_, ispList_]] := Module[
   {lines = topo["lines"], issues = {}, packType, pack},
   Do[
    pack = linePacks[[e]];
    packType = actualLinePackType[topo, e, pack];
    Switch[packType,
     "massiveFull",
     Do[
      If[IntegerQ[pack[[endpointSlot + 1]]] && pack[[endpointSlot + 1]] >= 2,
       AppendTo[issues, <|"lineIndex" -> e, "packType" -> packType, "endpointSlot" -> endpointSlot, "nValue" -> pack[[endpointSlot + 1]]|>]
       ],
     {endpointSlot, 2}
     ],
     "masslessFull",
     If[Length[pack] >= 2 && IntegerQ[pack[[2]]] && ! MemberQ[{0, 1}, pack[[2]]],
      AppendTo[issues, <|"lineIndex" -> e, "packType" -> packType, "nValue" -> pack[[2]]|>]
      ],
     "massiveCross",
     Do[
      If[IntegerQ[pack[[endpointSlot + 1]]] && pack[[endpointSlot + 1]] >= 2,
       AppendTo[issues, <|"lineIndex" -> e, "packType" -> packType, "endpointSlot" -> endpointSlot, "nValue" -> pack[[endpointSlot + 1]]|>]
       ],
      {endpointSlot, 2}
      ],
     _, Null
     ],
    {e, Length[lines]}
    ];
   issues
   ];


forbiddenNData[topo_Association, expr_] := DeleteCases[
   Flatten[forbiddenNDataForIntegral[topo, #] & /@ DeleteDuplicates[Cases[expr, _J, {0, Infinity}]]],
   Null
   ];


containsForbiddenNQ[topo_Association, expr_] := Length[forbiddenNData[topo, expr]] > 0;


assertNoForbiddenN::badn = "表达式仍含 forbidden n 指标：`1`。";
assertNoForbiddenN[expr_, topo_Association] := Module[{bad = forbiddenNData[topo, expr]},
   If[bad === {}, expr, Message[assertNoForbiddenN::badn, bad]; $Failed]
   ];

(* ::Chapter:: *)
(*标量积与 ISP 覆盖性*)

(* 本章将 Q_e^2 展开到 qq/qk/kk，并记录 propagator z_e 与用户 ISP 的结构信息。
   默认不做 MatrixRank/Solve 等解析检查；覆盖性验证应在单独 numeric/specialized 脚本中代数赋值后执行。 *)


scalarProductVariables[topo_Association] := Module[{nL = topo["nL"], nK = topo["nK"]},
   Join[
    Flatten[Table[qq[i, j], {i, nL}, {j, i, nL}]],
    Flatten[Table[qk[i, j], {i, nL}, {j, nK}]]
    ]
   ];


externalInvariantVariables[topo_Association] := Module[{nK = topo["nK"]},
   Flatten[Table[kk[i, j], {i, nK}, {j, i, nK}]]
   ];


numericRuleLHSVariables[topo_Association] := DeleteDuplicates[
   Cases[topo["numericRules"], (Rule | RuleDelayed)[lhs_, _] :> lhs, {0, Infinity}]
   ];


missingExternalInvariantNumericRules[topo_Association] := Complement[
   externalInvariantVariables[topo],
   numericRuleLHSVariables[topo]
   ];


vertexEnergyVariables[topo_Association] := DeleteDuplicates[
   Variables[vertexExternalEnergy[topo, #] & /@ activeAVertexIds[topo]]
   ];


missingVertexEnergyNumericRules[topo_Association] := Complement[
   vertexEnergyVariables[topo],
   numericRuleLHSVariables[topo]
   ];


lineParameterVariables[topo_Association] := DeleteDuplicates[
   Variables[Flatten[Lookup[topo["lines"], #, {}] & /@ {"nu", "eomCoefficients", "shrinkPrefactor"}]]
   ];


missingLineParameterNumericRules[topo_Association] := Complement[
   lineParameterVariables[topo],
   numericRuleLHSVariables[topo]
   ];


(* numeric workflow 的前置规则集中在这里，方便用户初始化时一次看清需要补哪些替换。 *)
numericRuleRequirementReport[topo_Association] := Module[
   {provided, external, vertex, line, required, missingExternal, missingVertex, missingLine, missingAll, toUser},
   provided = numericRuleLHSVariables[topo];
   external = externalInvariantVariables[topo];
   vertex = vertexEnergyVariables[topo];
   line = lineParameterVariables[topo];
   required = DeleteDuplicates[Join[external, vertex, line]];
   missingExternal = Complement[external, provided];
   missingVertex = Complement[vertex, provided];
   missingLine = Complement[line, provided];
   missingAll = Complement[required, provided];
   toUser[list_] := scalarProductInternalToUser[#, topo] & /@ list;
   <|
    "providedNumericVariables" -> toUser[provided],
    "internalProvidedNumericVariables" -> provided,
    "requiredExternalInvariants" -> toUser[external],
    "internalRequiredExternalInvariants" -> external,
    "externalInvariantNamingReport" -> externalInvariantNamingReport[topo],
    "vertexEnergyNamingReport" -> vertexEnergyNamingReport[topo],
    "requiredVertexEnergies" -> toUser[vertex],
    "internalRequiredVertexEnergies" -> vertex,
    "requiredLineParameters" -> line,
    "requiredNumericVariables" -> toUser[required],
    "internalRequiredNumericVariables" -> required,
    "missingExternalInvariants" -> toUser[missingExternal],
    "internalMissingExternalInvariants" -> missingExternal,
    "missingVertexEnergies" -> toUser[missingVertex],
    "internalMissingVertexEnergies" -> missingVertex,
    "missingLineParameters" -> missingLine,
    "missingNumericVariables" -> toUser[missingAll],
    "internalMissingNumericVariables" -> missingAll,
    "completeStaticNumericRulesQ" -> TrueQ[missingAll === {}]
    |>
   ];

numericRuleTemplateVariables[report_Association, scope_] := Switch[scope,
   "missing", report["missingNumericVariables"],
   "required", report["requiredNumericVariables"],
   "externalInvariants", report["requiredExternalInvariants"],
   "vertexEnergies", report["requiredVertexEnergies"],
   "lineParameters", report["requiredLineParameters"],
   list_List, list,
   _, report["missingNumericVariables"]
   ];


numericRuleTemplateValue[var_, valueSpec_] := If[valueSpec === Automatic, numericValue[var], valueSpec];


Options[makeNumericRuleTemplate] = {
   NumericRuleTemplateScope -> "missing",
   NumericRuleTemplateValue -> Automatic
   };


(* 生成可直接复制到 case["numericRules"] 的替换规则骨架；默认只列当前缺失项。 *)
makeNumericRuleTemplate[caseOrTopo_Association, OptionsPattern[]] := Module[
   {topo, report, vars, valueSpec},
   If[! parsedTopologyQ[caseOrTopo] && caseInputPreflightErrorQ[caseOrTopo],
    Return[{}]
    ];
   topo = If[KeyExistsQ[caseOrTopo, "lines"] && KeyExistsQ[caseOrTopo, "nL"], caseOrTopo, parseTopology[caseOrTopo]];
   report = numericRuleRequirementReport[topo];
   vars = numericRuleTemplateVariables[report, OptionValue[NumericRuleTemplateScope]];
   valueSpec = OptionValue[NumericRuleTemplateValue];
   (Rule[#, numericRuleTemplateValue[#, valueSpec]] &) /@ vars
   ];


(* 将两个线性动量表达式的点积展开为 qq/qk/kk。 *)
expandDotExpr[p_, r_, topo_Association] := Module[
   {loops = topo["loopMomenta"], exts = topo["externalMomenta"],
    nL = topo["nL"], nK = topo["nK"], lcP, lcR, ecP, ecR, result = 0},
   lcP = Coefficient[p, #] & /@ loops;
   lcR = Coefficient[r, #] & /@ loops;
   ecP = Coefficient[p, #] & /@ exts;
   ecR = Coefficient[r, #] & /@ exts;
   Do[
    result += lcP[[i]] lcR[[j]] qqSym[i, j],
    {i, nL}, {j, nL}
    ];
   Do[
    result += lcP[[i]] ecR[[j]] qk[i, j] + ecP[[j]] lcR[[i]] qk[i, j],
    {i, nL}, {j, nK}
    ];
   Do[
    result += ecP[[i]] ecR[[j]] kkSym[i, j],
    {i, nK}, {j, nK}
    ];
   Expand[result]
   ];



(* 用户口的 sp[p,r] 统一展开到内部 qq/qk/kk 坐标；p,r 可为用户命名的线性动量组合。 *)
scalarProductSPInputToInternal[expr_, topo_Association] := Expand[
   expr /. HoldPattern[sp[p_, r_]] :> expandDotExpr[p, r, topo]
   ];


externalInvariantSymbolName[i_Integer, j_Integer] := ToExpression["s" <> ToString[Min[i, j]] <> ToString[Max[i, j]]];


defaultExternalInvariantRulesForTopology[topo_Association] := Module[
   {exts = Lookup[topo, "externalMomenta", {}], nK = Lookup[topo, "nK", Length[Lookup[topo, "externalMomenta", {}]]]},
   Flatten[Table[sp[exts[[i]], exts[[j]]] -> externalInvariantSymbolName[i, j], {i, nK}, {j, i, nK}]]
   ];


normalizeExternalInvariantRulesForTopology[Automatic, topo_Association] := defaultExternalInvariantRulesForTopology[topo];
normalizeExternalInvariantRulesForTopology[rules_Association, topo_Association] := normalizeExternalInvariantRulesForTopology[Normal[rules], topo];
normalizeExternalInvariantRulesForTopology[rules_List, topo_Association] := Module[
   {defaults = defaultExternalInvariantRulesForTopology[topo], validRules},
   validRules = Select[rules, validReplacementRuleQ];
   Normal[Association[Join[defaults, validRules]]]
   ];
normalizeExternalInvariantRulesForTopology[_, topo_Association] := defaultExternalInvariantRulesForTopology[topo];


externalInvariantInternalToUserRules[topo_Association] := Module[
   {rules = Lookup[topo, "externalInvariantRules", defaultExternalInvariantRulesForTopology[topo]]},
   rules /. (Rule | RuleDelayed)[lhs_, rhs_] :> Rule[scalarProductSPInputToInternal[lhs, topo], rhs]
   ];


externalInvariantUserToInternalRules[topo_Association] := Module[
   {rules = externalInvariantInternalToUserRules[topo]},
   Cases[rules, Rule[lhs_, rhs_] :> Rule[rhs, lhs]]
   ];


externalInvariantNamingReport[topo_Association] := <|
   "externalMomenta" -> Lookup[topo, "externalMomenta", {}],
   "externalInvariantRules" -> Lookup[topo, "externalInvariantRules", defaultExternalInvariantRulesForTopology[topo]],
   "internalExternalInvariantRules" -> externalInvariantInternalToUserRules[topo],
   "defaultNamingConvention" -> "sij, where i,j are positions in externalMomenta and i<=j",
   "message" -> "圈动量相关标量积的用户输入统一用 sp[p,r]；外动量-外动量不变量在输出端使用 externalInvariantRules 指定的变量名，未指定时默认按 externalMomenta 顺序输出为 sij。"
   |>;


scalarProductInputToInternal[expr_, topo_Association] := Expand[
   scalarProductSPInputToInternal[expr, topo] /. externalInvariantUserToInternalRules[topo]
   ];


scalarProductInternalToUser[expr_, topo_Association] := Module[
   {loops = topo["loopMomenta"], exts = topo["externalMomenta"]},
   Expand[expr /. Join[
      externalInvariantInternalToUserRules[topo],
      {
       HoldPattern[qq[i_Integer, j_Integer]] :> sp[loops[[i]], loops[[j]]],
       HoldPattern[qk[i_Integer, j_Integer]] :> sp[loops[[i]], exts[[j]]]
       }
      ]]
   ];


scalarProductExpressionValidQ[expr_, topo_Association] := Module[
   {internal = scalarProductInputToInternal[expr, topo], allowedVars},
   allowedVars = Join[scalarProductVariables[topo], externalInvariantVariables[topo]];
   FreeQ[internal, sp] && SubsetQ[allowedVars, Variables[internal]]
   ];


normalizeISPExprs[topo_Association] := scalarProductInputToInternal[Lookup[#, "expr"], topo] & /@ topo["ispData"];


normalizeNumericRulesForTopology[rules_List, topo_Association] := rules /. (Rule | RuleDelayed)[lhs_, rhs_] :> Rule[scalarProductInputToInternal[lhs, topo], rhs];
normalizeNumericRulesForTopology[rules_, topo_Association] := rules;


normalizeCoefficientRulesForTopology[rules_List, topo_Association] := normalizeNumericRulesForTopology[rules, topo];
normalizeCoefficientRulesForTopology[rules_, topo_Association] := rules;


normalizeCoefficientRulesForLinearData[rules_, linearData_Association] := Module[
   {topo = Lookup[linearData, "topology", Missing["NoTopology"]]},
   If[parsedTopologyQ[topo], normalizeCoefficientRulesForTopology[rules, topo], rules]
   ];


userCoefficientRulesForLinearData[rules_, linearData_Association] := Module[
   {topo = Lookup[linearData, "topology", Missing["NoTopology"]]},
   If[parsedTopologyQ[topo] && ListQ[rules],
    rules /. (Rule | RuleDelayed)[lhs_, rhs_] :> Rule[scalarProductInternalToUser[lhs, topo], rhs],
    rules
    ]
   ];


userNumericRules[topo_Association] := topo["numericRules"] /. (Rule | RuleDelayed)[lhs_, rhs_] :> Rule[scalarProductInternalToUser[lhs, topo], rhs];

expandZList[topo_Association] := expandDotExpr[#, #, topo] & /@ Lookup[topo["lines"], "momentum"];


coefficientMatrix[exprs_List, vars_List] := Table[
   Coefficient[Expand[exprs[[r]]], vars[[c]]],
   {r, Length[exprs]}, {c, Length[vars]}
   ];


linearMomentumExpressionData[expr_, basis_List] := Module[
   {coeffs, residual},
   coeffs = Coefficient[expr, #] & /@ basis;
   residual = Expand[expr - Total[MapThread[#1 #2 &, {coeffs, basis}]]];
   <|"expr" -> expr, "basis" -> basis, "coefficients" -> coeffs, "residual" -> residual, "linearQ" -> TrueQ[residual === 0]|>
   ];


linearMomentumExpressionQ[expr_, basis_List] := TrueQ[linearMomentumExpressionData[expr, basis]["linearQ"]];


lineMomentumLinearityIssues[topo_Association] := Module[
   {basis = Join[topo["loopMomenta"], topo["externalMomenta"]]},
   DeleteCases[
    MapIndexed[
     With[{data = linearMomentumExpressionData[Lookup[#1, "momentum", 0], basis]},
       If[TrueQ[data["linearQ"]],
        Nothing,
        <|"lineIndex" -> First[#2], "lineId" -> Lookup[#1, "id", Missing["id"]], "momentum" -> Lookup[#1, "momentum", Missing["momentum"]], "residual" -> data["residual"], "basis" -> basis|>
        ]
       ] &,
     topo["lines"]
     ],
    Nothing
    ]
   ];


scalarProductArgumentLinearityIssues[topo_Association] := Module[
   {basis = Join[topo["loopMomenta"], topo["externalMomenta"]], rawISPExprs, spData},
   rawISPExprs = Lookup[#, "expr"] & /@ topo["ispData"];
   DeleteCases[
    Flatten[
     MapIndexed[
      Function[{expr, pos},
       MapIndexed[
        Function[{pair, pairPos},
         DeleteCases[
          MapIndexed[
           With[{data = linearMomentumExpressionData[#1, basis]},
             If[TrueQ[data["linearQ"]],
              Nothing,
              <|"ispPosition" -> First[pos], "ispName" -> Lookup[topo["ispData"][[First[pos]]], "name", Missing["name"]], "spPosition" -> First[pairPos], "argumentSlot" -> First[#2], "argument" -> #1, "residual" -> data["residual"], "basis" -> basis|>
              ]
             ] &,
           pair
           ],
          Nothing
          ]
         ],
        Cases[expr, HoldPattern[sp[p_, r_]] :> {p, r}, {0, Infinity}]
        ]
       ],
      rawISPExprs
      ],
     2
     ],
    Nothing
    ]
   ];


vertexEnergySPArgumentIssues[expr_, topo_Association] := Module[
   {basis = Join[topo["loopMomenta"], topo["externalMomenta"]], nL = topo["nL"], pairs},
   pairs = Cases[expr, HoldPattern[sp[p_, r_]] :> {p, r}, {0, Infinity}];
   DeleteCases[
    Flatten[
     MapIndexed[
      Function[{pair, pairPos},
       MapIndexed[
        Function[{arg, argPos},
         Module[{data = linearMomentumExpressionData[arg, basis], loopCoeffs},
          loopCoeffs = Take[data["coefficients"], nL];
          If[TrueQ[data["linearQ"]] && TrueQ[loopCoeffs === ConstantArray[0, nL]],
           Nothing,
           <|
            "spPosition" -> First[pairPos],
            "argumentSlot" -> First[argPos],
            "argument" -> arg,
            "residual" -> data["residual"],
            "loopCoefficients" -> loopCoeffs,
            "basis" -> basis
            |>
           ]
          ]
         ],
        pair
        ]
       ],
      pairs
      ],
     1
     ],
    Nothing
    ]
   ];


vertexEnergyMomentumDependenceIssues[topo_Association] := Module[
   {declared = Join[topo["loopMomenta"], topo["externalMomenta"]], loopSPVars = scalarProductVariables[topo], vertices = activeAVertexIds[topo]},
   DeleteCases[
    Table[
     Module[{raw = rawVertexExternalEnergy[topo, vertex], rawNoSP, directMomenta, spArgIssues, internal, loopSPUsed},
      rawNoSP = raw /. HoldPattern[sp[_, _]] -> 0;
      directMomenta = DeleteDuplicates@Cases[rawNoSP, sym_Symbol /; MemberQ[declared, sym], {0, Infinity}];
      spArgIssues = vertexEnergySPArgumentIssues[raw, topo];
      internal = scalarProductInputToInternal[raw, topo];
      loopSPUsed = Intersection[Variables[internal], loopSPVars];
      If[directMomenta === {} && spArgIssues === {} && loopSPUsed === {},
       Nothing,
       <|
        "vertexId" -> vertex,
        "rawVertexEnergy" -> raw,
        "userVertexEnergy" -> scalarProductInternalToUser[internal, topo],
        "directMomentumSymbols" -> directMomenta,
        "spArgumentIssues" -> spArgIssues,
        "loopScalarProducts" -> scalarProductInternalToUser[#, topo] & /@ loopSPUsed,
        "comment" -> "vertexEnergies are scalar time-phase energies for all external legs attached to a vertex; use external invariant variables when the energy is tied to externalMomenta space, otherwise use independent ke[i] parameters"
        |>
       ]
      ],
     {vertex, vertices}
     ],
    Nothing
    ]
   ];



(* 标量积坐标规则只依赖动量路由、ISP 和外部不变量命名。
   缓存键排除 sector、顶点和 seed 配置，使同一 family 的 shrink sectors 共享一次 LinearSolve。 *)
$scalarProductRuleCache = <||>;


scalarProductRuleCacheKey[topo_Association] := With[
   {
    nL = topo["nL"],
    nK = topo["nK"],
    nE = topo["nE"],
    loopMomenta = topo["loopMomenta"],
    externalMomenta = topo["externalMomenta"],
    lineMomenta = Lookup[topo["lines"], "momentum"],
    ispExprs = Lookup[topo["ispData"], "expr"],
    externalInvariantRules = Lookup[topo, "externalInvariantRules", {}]
    },
   HoldComplete[nL, nK, nE, loopMomenta, externalMomenta, lineMomenta, ispExprs, externalInvariantRules]
   ];


clearScalarProductRuleCache[] := ($scalarProductRuleCache = <||>; Null);


scalarProductRuleCacheReport[] := <|
   "entryCount" -> Length[$scalarProductRuleCache],
   "hashes" -> Keys[$scalarProductRuleCache]
   |>;


(* 小规模线性规则核心：直接作为 ISP 给出的标量积会被保留，不强行改写成 rho。
   本 package 假设用户输入的 z_e 与直接 ISP 已经构成闭合坐标；这里不把 dS 图
   默认当成 overcomplete propagator family 处理，避免改变用户定义的函数族。 *)
makeScalarProductRulesUncached[topo_Association] := Module[
   {spVars, zVars, zExprs, rawISPExprs, ispExprs, ispVars, invalidISPPositions, unsupportedISPExprs,
    coordExprs, coordVars, mat, const, rhs, solVec},
   spVars = scalarProductVariables[topo];
   zVars = Table[z[e], {e, topo["nE"]}];
   zExprs = expandZList[topo];
   rawISPExprs = Lookup[#, "expr"] & /@ topo["ispData"];
   ispExprs = scalarProductInputToInternal[#, topo] & /@ rawISPExprs;
   ispVars = Table[rho[j], {j, Length[ispExprs]}];
   invalidISPPositions = Flatten@Position[Map[scalarProductExpressionValidQ[#, topo] &, rawISPExprs], False];
   unsupportedISPExprs = rawISPExprs[[invalidISPPositions]];
   If[unsupportedISPExprs =!= {},
    Return[<|
      "status" -> "notComputed",
      "reason" -> "ISP expressions must be scalar products written as sp[p,r] or linear combinations of them",
      "repSP2Z" -> Missing["NotComputedUnsupportedISP"],
      "solveVars" -> Missing["NotComputedUnsupportedISP"],
      "preservedISPVars" -> ispVars,
      "ispCoordinateVars" -> ispVars,
      "unsupportedISPExprs" -> unsupportedISPExprs
      |>]
    ];
   coordExprs = Join[zExprs, ispExprs];
   coordVars = Join[zVars, ispVars];
   If[Length[coordExprs] =!= Length[spVars],
    Return[<|
      "status" -> "notComputed",
      "reason" -> "z plus ISP equation count does not match scalar-product count",
      "repSP2Z" -> Missing["NotComputedCountMismatch"],
      "solveVars" -> spVars,
      "preservedISPVars" -> ispVars,
      "ispCoordinateVars" -> ispVars,
      "zCount" -> Length[zExprs],
      "ispCount" -> Length[ispExprs],
      "scalarProductCount" -> Length[spVars]
      |>]
    ];
   mat = coefficientMatrix[coordExprs, spVars];
   const = coordExprs /. Thread[spVars -> 0];
   rhs = coordVars - const;
   solVec = Check[LinearSolve[mat, rhs], $Failed];
   If[solVec === $Failed,
    Return[<|
      "status" -> "notComputed",
      "reason" -> "LinearSolve failed",
      "repSP2Z" -> Missing["LinearSolveFailed"],
      "solveVars" -> spVars,
      "preservedISPVars" -> ispVars,
      "ispCoordinateVars" -> ispVars,
      "zCount" -> Length[zExprs],
      "ispCount" -> Length[ispExprs],
      "scalarProductCount" -> Length[spVars]
      |>]
    ];
   <|
    "status" -> "computed",
    "repSP2Z" -> Thread[spVars -> (Expand /@ solVec)],
    "userRepSP2Z" -> (Rule[scalarProductInternalToUser[#[[1]], topo], scalarProductInternalToUser[#[[2]], topo]] & /@ Thread[spVars -> (Expand /@ solVec)]),
    "repZ2SP" -> Thread[zVars -> zExprs],
    "userRepZ2SP" -> (Rule[#[[1]], scalarProductInternalToUser[#[[2]], topo]] & /@ Thread[zVars -> zExprs]),
    "repISP2SP" -> Thread[ispVars -> ispExprs],
    "userRepISP2SP" -> (Rule[#[[1]], scalarProductInternalToUser[#[[2]], topo]] & /@ Thread[ispVars -> ispExprs]),
    "solveVars" -> spVars,
    "preservedISPVars" -> ispVars,
    "ispCoordinateVars" -> ispVars,
    "zCount" -> Length[zExprs],
    "ispCount" -> Length[ispExprs],
    "scalarProductCount" -> Length[spVars]
    |>
   ];


(* 公开入口在命中缓存时直接返回；SHA-256 命中后仍用完整键 SameQ 防止哈希冲突。 *)
makeScalarProductRules[topo_Association] := Module[
   {key, hash, entry, result},
   key = scalarProductRuleCacheKey[topo];
   hash = Hash[key, "SHA256"];
   entry = Lookup[$scalarProductRuleCache, hash, Missing["NotCached"]];
   If[AssociationQ[entry] && SameQ[entry["key"], key],
    Return[entry["value"]]
    ];
   result = makeScalarProductRulesUncached[topo];
   AssociateTo[$scalarProductRuleCache, hash -> <|"key" -> key, "value" -> result|>];
   result
   ];


makeScalarProductData[topo_Association] := Module[
   {spVars, zVars, zExprs, rawISPExprs, ispExprs, ispSymbols, invalidISPPositions, unsupportedISPExprs,
    coordExprs, nSP, structuralNeededISPCount, structuralCountQ, coordinateCountQ},
   spVars = scalarProductVariables[topo];
   zVars = Table[z[e], {e, topo["nE"]}];
   zExprs = expandZList[topo];
   rawISPExprs = Lookup[#, "expr"] & /@ topo["ispData"];
   ispExprs = scalarProductInputToInternal[#, topo] & /@ rawISPExprs;
   ispSymbols = Table[rho[j], {j, Length[ispExprs]}];
   invalidISPPositions = Flatten@Position[Map[scalarProductExpressionValidQ[#, topo] &, rawISPExprs], False];
   unsupportedISPExprs = rawISPExprs[[invalidISPPositions]];
   coordExprs = Join[zExprs, ispExprs];
   nSP = Length[spVars];
   structuralNeededISPCount = Max[0, nSP - Length[zExprs]];
   structuralCountQ = Length[ispExprs] >= structuralNeededISPCount;
   coordinateCountQ = Length[coordExprs] === nSP;
   <|
    "scalarProducts" -> (scalarProductInternalToUser[#, topo] & /@ spVars),
    "internalScalarProducts" -> spVars,
    "externalInvariants" -> (scalarProductInternalToUser[#, topo] & /@ externalInvariantVariables[topo]),
    "internalExternalInvariants" -> externalInvariantVariables[topo],
    "externalInvariantNamingReport" -> externalInvariantNamingReport[topo],
    "zVars" -> zVars,
    "zExprs" -> (scalarProductInternalToUser[#, topo] & /@ zExprs),
    "internalZExprs" -> zExprs,
    "ispSymbols" -> ispSymbols,
    "ispExprs" -> (scalarProductInternalToUser[#, topo] & /@ ispExprs),
    "internalISPExprs" -> ispExprs,
    "directISPVars" -> ispSymbols,
    "internalDirectISPVars" -> ispSymbols,
    "unsupportedISPExprs" -> unsupportedISPExprs,
    "solveVars" -> spVars,
    "zCount" -> Length[zExprs],
    "spCount" -> nSP,
    "ispCount" -> Length[ispExprs],
    "directISPCount" -> Length[ispExprs],
    "nonISPScalarProductCount" -> nSP - Length[ispExprs],
    "structuralNeededISPCount" -> structuralNeededISPCount,
    "structuralCountQ" -> structuralCountQ,
    "coordinateCountQ" -> coordinateCountQ,
    "coverageQ" -> Missing["NotCheckedSeedOnly"],
    "independentQ" -> Missing["NotCheckedSeedOnly"],
    "repSP2Z" -> Missing["NotComputedSeedOnly"]
    |>
   ];

(* ::Chapter:: *)
(*IBP 生成元枚举*)

(* 本章只生成 IBP 算子标签，不展开公式。完整集合包括 time IBP 和
   momentum IBP: d/dq_l dot q_m, d/dq_l dot k_j。 *)


makeIBPGenerators[topo_Association] := Module[
   {timeGenerators, loopGenerators, externalGenerators},
   timeGenerators = <|"type" -> "time", "vertex" -> #|> & /@ Lookup[topo, "activeVertexIds", topo["vertexIds"]];
   loopGenerators = Flatten[
     Table[
      <|
       "type" -> "momentum",
       "dLoop" -> l,
       "vectorType" -> "loop",
       "vectorIndex" -> m,
       "vector" -> topo["loopMomenta"][[m]]
       |>,
      {l, topo["nL"]}, {m, topo["nL"]}
      ],
     1
     ];
   externalGenerators = Flatten[
     Table[
      <|
       "type" -> "momentum",
       "dLoop" -> l,
       "vectorType" -> "external",
       "vectorIndex" -> j,
       "vector" -> topo["externalMomenta"][[j]]
       |>,
      {l, topo["nL"]}, {j, topo["nK"]}
      ],
     1
     ];
   Join[timeGenerators, loopGenerators, externalGenerators]
   ];


expectedMomentumGeneratorCount[topo_Association] := topo["nL"] (topo["nL"] + topo["nK"]);


(* ::Chapter:: *)
(*轻量 momentum IBP seed*)

(* 本章生成 momentum IBP seed 的传播子幂次项、z/ISP 吸收和 massive building-block 导数项。
   输出会经过 EOM 与 per-line massless endpoint canonical 门禁；shrunk pack 的 bS 幂次也使用当前 pack 指标。 *)

linearTerms[expr_] := Module[{expanded = Expand[expr]},
   If[Head[expanded] === Plus, List @@ expanded, {expanded}]
   ];


shiftLineB[J[aList_, linePacks_, ispList_], e_Integer, delta_] := Module[
   {newLinePacks = linePacks},
   newLinePacks[[e, 1]] = newLinePacks[[e, 1]] + delta;
   J[aList, newLinePacks, ispList]
   ];


zeroPointRuleValue[topo_Association, symbol_, default_: 0] := Module[
   {hits},
   hits = Cases[Lookup[topo, "zeroPointRules", {}], (Rule | RuleDelayed)[lhs_, rhs_] /; lhs === symbol :> rhs];
   If[hits === {}, default, Last[hits]]
   ];


vertexZeroPoint[topo_Association, vertexId_] := zeroPointRuleValue[topo, a0[vertexRepresentative[topo, vertexId]]];


lineBZeroPoint[topo_Association, e_Integer] := zeroPointRuleValue[topo, b0[topo["lines"][[e, "id"]]]];


lineBSZeroPoint[topo_Association, e_Integer] := zeroPointRuleValue[topo, bS0[topo["lines"][[e, "id"]]]];


vertexPowerIndex[topo_Association, J[aList_, linePacks_, ispList_], vertexId_] := Module[
   {pos = vertexASlot[topo, vertexId]},
   If[Head[pos] === Missing, 0, aList[[pos]] + vertexZeroPoint[topo, vertexId]]
   ];


linePowerIndex[topo_Association, J[aList_, linePacks_, ispList_], e_Integer] := Module[
   {base = linePacks[[e, 1]], packType = actualLinePackType[topo, e, linePacks[[e]]]},
   base + If[packType === "shrunk", lineBSZeroPoint[topo, e], lineBZeroPoint[topo, e]]
   ];


shiftISPIndex[J[aList_, linePacks_, ispList_], j_Integer, delta_] := Module[
   {newISPList = ispList},
   newISPList[[j]] = newISPList[[j]] + delta;
   J[aList, linePacks, newISPList]
   ];


(* 将一个线性因子吸收到 b 或 ISP 指标中；无法识别的高次项保持为显式系数。 *)
absorbLinearFactorTerm[term_, int_J, topo_Association] := Module[
   {zVars, ispVars, vars, rules, rebuildMonomial},
   zVars = Table[z[e], {e, topo["nE"]}];
   ispVars = Table[rho[j], {j, Length[topo["ispData"]]}];
   vars = Join[zVars, ispVars];
   If[Length[vars] == 0, Return[term int]];
   rules = CoefficientRules[term, vars];
   rebuildMonomial[powers_] := Times @@ MapThread[#1^#2 &, {vars, powers}];
   Total[
    rules /. (powers_ -> coeff_) :> Module[
       {degree = Total[powers], pos, var},
       If[degree === 0,
        coeff int,
        If[Count[powers, 1] === 1 && Count[powers, Except[0 | 1]] === 0 && degree === 1,
         pos = First@FirstPosition[powers, 1];
         var = vars[[pos]];
         Which[
          MatchQ[var, z[_Integer]],
          coeff shiftLineB[int, var[[1]], -2],
          MemberQ[ispVars, var],
          coeff shiftISPIndex[int, First@FirstPosition[ispVars, var], 1],
          True,
          coeff var int
          ],
         coeff rebuildMonomial[powers] int
         ]
        ]
       ]
    ]
   ];


absorbLinearFactor[factor_, int_J, topo_Association] := Total[
   absorbLinearFactorTerm[#, int, topo] & /@ linearTerms[factor]
   ];


momentumDivergenceTerm[int_J, gen_Association] := If[
   gen["type"] === "momentum" && gen["vectorType"] === "loop" && gen["dLoop"] === gen["vectorIndex"],
   dim int,
   0
   ];


momentumBuildingBlockDerivativeTerms[topo_Association, int_J, gen_Association, repSP2ZRules_List] := Module[
   {dLoop, vector, lineMomenta, lines, loopCoeff, vDotQ, endpointVertex, shiftedInt},
   dLoop = gen["dLoop"];
   vector = gen["vector"];
   lineMomenta = Lookup[topo["lines"], "momentum"];
   lines = topo["lines"];
   Total[
    Table[
     If[! MemberQ[{"massiveFull", "massiveCross"}, lines[[e]]["packType"]],
      0,
      loopCoeff = Coefficient[lineMomenta[[e]], topo["loopMomenta"][[dLoop]]];
      If[zeroQ[loopCoeff],
       0,
       vDotQ = Expand[expandDotExpr[vector, lineMomenta[[e]], topo] /. repSP2ZRules];
       Total[
        Table[
         endpointVertex = lines[[e]]["endpoints"][[endpointSlot]];
         shiftedInt = shiftLinePackEntry[int, e, endpointSlot + 1, 1];
         shiftedInt = shiftVertexA[shiftedInt, topo, endpointVertex, 1];
         shiftedInt = shiftLineB[shiftedInt, e, 1];
         loopCoeff absorbLinearFactor[vDotQ, shiftedInt, topo],
         {endpointSlot, 2}
         ]
        ]
       ]
      ],
     {e, topo["nE"]}
     ]
    ]
   ];

momentumPropagatorDerivativeTerms[topo_Association, int_J, gen_Association, repSP2ZRules_List] := Module[
   {dLoop, vector, lineMomenta, loopCoeff, vDotQ, shiftedInt},
   dLoop = gen["dLoop"];
   vector = gen["vector"];
   lineMomenta = Lookup[topo["lines"], "momentum"];
   Total[
    Table[
     loopCoeff = Coefficient[lineMomenta[[e]], topo["loopMomenta"][[dLoop]]];
     If[zeroQ[loopCoeff],
      0,
      vDotQ = Expand[expandDotExpr[vector, lineMomenta[[e]], topo] /. repSP2ZRules];
      shiftedInt = shiftLineB[int, e, 2];
      -loopCoeff linePowerIndex[topo, int, e] absorbLinearFactor[vDotQ, shiftedInt, topo]
      ],
     {e, topo["nE"]}
     ]
    ]
   ];


applyMomentumGeneratorSeed::nosp =
   "拓扑 `1` 的标量积到 z/ISP 规则未生成：`2`。请补充 ISP 配置后再生成 momentum seed。";


applyMomentumGeneratorSeed[topo_Association, int_J, gen_Association] := Module[
   {ruleData},
   ruleData = makeScalarProductRules[topo];
   If[Lookup[ruleData, "status", "notComputed"] =!= "computed",
    Message[applyMomentumGeneratorSeed::nosp, topo["name"], Lookup[ruleData, "reason", Missing["reason"]]];
    Return[$Failed]
    ];
   Expand[
    momentumDivergenceTerm[int, gen] +
     momentumPropagatorDerivativeTerms[topo, int, gen, ruleData["repSP2Z"]] +
     momentumBuildingBlockDerivativeTerms[topo, int, gen, ruleData["repSP2Z"]]
    ]
   ];


(* ::Chapter:: *)
(*轻量 time IBP core seed*)

(* 本章接入 time-IBP 的通用 core 项：顶点幂次、外部能量、massive building-block 端点导数、massless 端点翻转项和 massive theta 边界缩并项。
   单独 time batch 会把进一步 shrink-sector 生成标为 pending；canonical batch 会在保护阈值内自动补齐这些 sectors。 *)

rawVertexExternalEnergy[topo_Association, vertexId_] := Module[
   {vertexEnergies = Lookup[topo, "vertexEnergies", Missing["NotSet"]]},
   Which[
    AssociationQ[vertexEnergies] && KeyExistsQ[vertexEnergies, vertexId], vertexEnergies[vertexId],
    ListQ[vertexEnergies], vertexId /. vertexEnergies,
    True,
    ke[vertexId]
    ]
   ];


vertexExternalEnergy[topo_Association, vertexId_] := scalarProductInputToInternal[rawVertexExternalEnergy[topo, vertexId], topo];


vertexEnergyDependencyData[topo_Association, vertexId_] := Module[
   {internal, vars, externalVars, externalUsed, independentUsed},
   internal = vertexExternalEnergy[topo, vertexId];
   vars = Variables[internal];
   externalVars = externalInvariantVariables[topo];
   externalUsed = Intersection[vars, externalVars];
   independentUsed = Complement[vars, externalVars];
   <|
    "internalExternalInvariantVariables" -> externalUsed,
    "externalInvariantVariables" -> (scalarProductInternalToUser[#, topo] & /@ externalUsed),
    "internalIndependentVertexEnergyParameters" -> independentUsed,
    "independentVertexEnergyParameters" -> (scalarProductInternalToUser[#, topo] & /@ independentUsed),
    "usesExternalInvariantQ" -> TrueQ[externalUsed =!= {}],
    "usesIndependentVertexEnergyQ" -> TrueQ[independentUsed =!= {}],
    "kind" -> Which[
      externalUsed =!= {} && independentUsed === {}, "externalInvariantExpression",
      externalUsed === {} && independentUsed =!= {}, "independentVertexEnergyParameter",
      externalUsed =!= {} && independentUsed =!= {}, "mixedExpression",
      True, "constant"
      ]
    |>
   ];


vertexEnergyNamingReport[topo_Association] := Module[
   {vertices = activeAVertexIds[topo], raw, internal, user, dependencies},
   raw = AssociationThread[vertices -> (rawVertexExternalEnergy[topo, #] & /@ vertices)];
   internal = AssociationThread[vertices -> (vertexExternalEnergy[topo, #] & /@ vertices)];
   user = AssociationThread[vertices -> (scalarProductInternalToUser[vertexExternalEnergy[topo, #], topo] & /@ vertices)];
   dependencies = AssociationThread[vertices -> (vertexEnergyDependencyData[topo, #] & /@ vertices)];
   <|
    "convention" -> "vertex external energy uses ke[i] for independent absolute-value parameters; expressions built from external invariant names are normalized to the same scalar-product coordinates used by loop momenta",
    "rawVertexEnergies" -> raw,
    "internalVertexEnergies" -> internal,
    "userVertexEnergies" -> user,
    "dependencyData" -> dependencies,
    "message" -> "vertexEnergies 的每个值表示一个顶点连着的所有外腿打包后的 e 指数能量。若该能量和 externalMomenta 空间的外部不变量是同一变量，应写成 externalInvariantRules 输出变量的函数，例如 Sqrt[s11]；否则写独立 ke[i]。不要把 |ke1+ke2| 与 |ke1|+|ke2| 混同；若 |ke1+ke2| 独立，应单独命名为 ke[i]。外腿能量参数之间不生成点积关系。"
    |>
   ];


timeVertexPowerTerm[topo_Association, J[aList_, linePacks_, ispList_], vertexId_] := Module[
   {pos = vertexASlot[topo, vertexId]},
   If[Head[pos] === Missing, Return[0]];
   -vertexPowerIndex[topo, J[aList, linePacks, ispList], vertexId] shiftVertexA[J[aList, linePacks, ispList], topo, vertexId, -1]
   ];


timeExternalEnergyTerm[topo_Association, int_J, vertexId_] := -I vertexExternalEnergy[topo, vertexId] int;


skEndpointPhaseSign[line_Association, endpointSlot_Integer] := Module[
   {skType = Lookup[line, "skType", "++"], chars},
   chars = Characters[skType];
   If[Length[chars] < endpointSlot,
    If[endpointSlot === 1, 1, -1],
    If[chars[[endpointSlot]] === "+", 1, -1]
    ]
   ];


timeMasslessEndpointDerivativeTerms[topo_Association, J[aList_, linePacks_, ispList_], vertexId_] := Module[
   {pos, connectedLines, lines = topo["lines"], endpointPos, endpointSign, newLinePacks},
   pos = vertexPosition[topo, vertexId];
   If[Head[pos] === Missing, Return[0]];
   connectedLines = topo["vertexLines"][[pos]][[All, 1]];
   Total[
    Table[
     Switch[lines[[e]]["packType"],
      "masslessFull",
      endpointPos = FirstPosition[lines[[e]]["endpoints"], vertexId, Missing["EndpointNotFound"]];
      If[Head[endpointPos] === Missing, 0,
       endpointSign = If[StringTake[Lookup[lines[[e]], "skType", "++"], 1] === "+", 1, -1] If[First[endpointPos] === 1, 1, -1];
       newLinePacks = linePacks;
       newLinePacks[[e, 1]] = newLinePacks[[e, 1]] - 1;
       newLinePacks[[e, 2]] = 1 - newLinePacks[[e, 2]];
       I endpointSign J[aList, newLinePacks, ispList]
       ],
      "masslessCross",
      endpointPos = FirstPosition[lines[[e]]["endpoints"], vertexId, Missing["EndpointNotFound"]];
      If[Head[endpointPos] === Missing, 0,
       endpointSign = skEndpointPhaseSign[lines[[e]], First[endpointPos]];
       newLinePacks = linePacks;
       newLinePacks[[e, 1]] = newLinePacks[[e, 1]] - 1;
       I endpointSign J[aList, newLinePacks, ispList]
       ],
      _, 0
      ],
     {e, connectedLines}
     ]
    ]
   ];


timeMassiveBuildingBlockDerivativeTerms[topo_Association, J[aList_, linePacks_, ispList_], vertexId_] := Module[
   {pos, connectedLines, lines = topo["lines"], endpointPos, shiftedInt},
   pos = vertexPosition[topo, vertexId];
   If[Head[pos] === Missing, Return[0]];
   connectedLines = topo["vertexLines"][[pos]][[All, 1]];
   Total[
    Table[
     If[! MemberQ[{"massiveFull", "massiveCross"}, actualLinePackType[topo, e, linePacks[[e]]]],
      0,
      endpointPos = FirstPosition[lines[[e]]["endpoints"], vertexId, Missing["EndpointNotFound"]];
      If[Head[endpointPos] === Missing,
       0,
       shiftedInt = shiftLineB[J[aList, linePacks, ispList], e, -1];
       -shiftLinePackEntry[shiftedInt, e, First[endpointPos] + 1, 1]
       ]
      ],
     {e, connectedLines}
     ]
    ]
   ];


lineShrinkPrefactor[topo_Association, e_Integer] := Module[
   {line = topo["lines"][[e]], pref},
   pref = Lookup[line, "shrinkPrefactor", (4 I/Pi) Exp[Pi Im[Lookup[line, "nu", nu]]]];
   pref /. topo["shrinkPrefactorRules"]
   ];


thetaBoundarySignOffset[topo_Association, e_Integer] := Lookup[
   topo["lines"][[e]],
   "thetaBoundarySignOffset",
   Lookup[topo, "thetaBoundarySignOffset", 0]
   ];
lineShrinkZeroPointShift[line_Association] := Module[
   {bbType = Lookup[line, "bbType", "h"], nuValue = Lookup[line, "nu", nu]},
   Lookup[line, "shrinkZeroPointShift", If[bbType === "h", 2 nuValue, 0]]
   ];


sectorZeroPointRules[topo_Association, shrunkLines_List, repMap_Association, activeVertices_List] := Module[
   {lineRules, vertexRules, classVertices, classShrunkLines, shiftSum},
   lineRules = Flatten@Table[
      If[MemberQ[shrunkLines, e],
       bS0[topo["lines"][[e, "id"]]] -> lineBZeroPoint[topo, e] + lineShrinkZeroPointShift[topo["lines"][[e]]],
       Switch[actualLinePackType[topo, e, makeLinePack[topo["lines"][[e]]]],
        "shrunk", bS0[topo["lines"][[e, "id"]]] -> lineBSZeroPoint[topo, e],
        _, b0[topo["lines"][[e, "id"]]] -> lineBZeroPoint[topo, e]
        ]
       ],
      {e, topo["nE"]}
      ];
   vertexRules = Table[
     classVertices = Select[topo["vertexIds"], Lookup[repMap, #] === rep &];
     classShrunkLines = Select[shrunkLines, Function[e, And @@ (Function[v, Lookup[repMap, v] === rep] /@ topo["lines"][[e, "endpoints"]])]];
     shiftSum = Total[lineShrinkZeroPointShift[topo["lines"][[#]]] & /@ classShrunkLines];
     a0[rep] -> Total[vertexZeroPoint[topo, #] & /@ classVertices] - shiftSum,
     {rep, activeVertices}
     ];
   DeleteDuplicates@Join[vertexRules, lineRules]
   ];


shrinkLineIntegral[topo_Association, J[aList_, linePacks_, ispList_], e_Integer] := Module[
   {line = topo["lines"][[e]], uSlot, vSlot, oldActive, newRepMap, newActive, newAList, newLinePacks = linePacks,
    mergedRep, oldSlotsForNewRep, slotValues},
   uSlot = vertexASlot[topo, line["endpoints"][[1]]];
   vSlot = vertexASlot[topo, line["endpoints"][[2]]];
   If[Head[uSlot] === Missing || Head[vSlot] === Missing, Return[$Failed]];
   oldActive = activeAVertexIds[topo];
   newRepMap = vertexRepresentativeMap[topo["vertexIds"], Join[
      ({#, vertexRepresentative[topo, #]} & /@ topo["vertexIds"]),
      {line["endpoints"]}
      ]];
   newActive = DeleteDuplicates[Lookup[newRepMap, topo["vertexIds"]]];
   mergedRep = Lookup[newRepMap, line["endpoints"][[1]]];
   newAList = Table[
     oldSlotsForNewRep = Flatten[Position[Lookup[newRepMap, oldActive], newActive[[i]]]];
     slotValues = aList[[oldSlotsForNewRep]];
     If[newActive[[i]] === mergedRep,
      If[uSlot === vSlot, 2 aList[[uSlot]], Total[slotValues]] - 1,
      Total[slotValues]
      ],
     {i, Length[newActive]}
     ];
   newLinePacks[[e]] = {linePacks[[e, 1]] + 1};
   J[newAList, newLinePacks, ispList]
   ];


timeThetaBoundaryShrinkTerms[topo_Association, J[aList_, linePacks_, ispList_], vertexId_] := Module[
   {pos, connectedLines, lines = topo["lines"], endpointPos, endpointSlot, pack, coeff},
   pos = vertexPosition[topo, vertexId];
   If[Head[pos] === Missing, Return[0]];
   connectedLines = topo["vertexLines"][[pos]][[All, 1]];
   Total[
    Table[
     pack = linePacks[[e]];
     If[actualLinePackType[topo, e, pack] =!= "massiveFull",
      0,
      endpointPos = FirstPosition[lines[[e]]["endpoints"], vertexId, Missing["EndpointNotFound"]];
      If[Head[endpointPos] === Missing,
       0,
       endpointSlot = First[endpointPos];
       coeff = lineShrinkPrefactor[topo, e] KroneckerDelta[pack[[2]] + pack[[3]], 1] (-1)^(pack[[endpointSlot + 1]] + thetaBoundarySignOffset[topo, e]);
       coeff shrinkLineIntegral[topo, J[aList, linePacks, ispList], e]
       ]
      ],
     {e, connectedLines}
     ]
    ]
   ];


seedUnsupportedPendingFeatures[topo_Association] := DeleteDuplicates@Join[
    unsupportedSeedFeaturesForTopology[topo]
    ];


momentumIBPPendingFeatures[topo_Association] := seedUnsupportedPendingFeatures[topo];


timeIBPPendingFeatures[topo_Association] := DeleteDuplicates@Join[
    seedUnsupportedPendingFeatures[topo],
    If[MemberQ[Lookup[topo["lines"], "packType"], "massiveFull"], {"shrinkSectorSeedGeneration"}, {}]
    ];


timeGeneratorLabel[gen_Association] := {gen["type"], gen["vertex"]};


applyTimeGeneratorSeed::badgen = "time seed 只能使用 time 生成元，收到：`1`。";


applyTimeGeneratorSeed[topo_Association, int_J, gen_Association] := Module[
   {vertexId},
   If[gen["type"] =!= "time",
    Message[applyTimeGeneratorSeed::badgen, gen];
    Return[$Failed]
    ];
   vertexId = gen["vertex"];
   Expand[
    timeVertexPowerTerm[topo, int, vertexId] +
     timeExternalEnergyTerm[topo, int, vertexId] +
     timeMasslessEndpointDerivativeTerms[topo, int, vertexId] +
     timeMassiveBuildingBlockDerivativeTerms[topo, int, vertexId] +
     timeThetaBoundaryShrinkTerms[topo, int, vertexId]
    ]
   ];


Options[makeTimeIBPSeedBatch] = {
   UseSampleOnly -> Automatic,
   MaxSeedRuleCount -> Automatic,
   DiscreteMode -> Automatic,
   MaxDiscreteRuleCount -> Automatic,
   MaxEquationCount -> Automatic,
   ApplyNumericRules -> False
   };
makeTimeIBPSeedBatch::toomany =
   "拓扑 `1` 的 time seed 方程数为 `2`，超过上限 `3`；未展开方程。";


makeTimeIBPSeedBatch[topo_Association, OptionsPattern[]] := Module[
   {baseIntegral, continuousData, discreteData, timeGenerators, equationCount,
    maxEquationCount, genTemplates, equations, pendingFeatures, topologyReport},
   topologyReport = topologyValidationReport[topo];
   If[topologyValidationErrorQ[topologyReport],
    Return[<|"status" -> "invalidTopology", "caseName" -> topo["name"], "topologyValidationReport" -> topologyReport, "equations" -> {}|>]
    ];
   baseIntegral = makeBaseIntegral[topo];
   continuousData = makeContinuousSeedRules[
     topo,
     UseSampleOnly -> OptionValue[UseSampleOnly],
     MaxSeedRuleCount -> OptionValue[MaxSeedRuleCount]
     ];
   If[continuousData["status"] =!= "generated",
    Return[Join[continuousData, <|"caseName" -> topo["name"], "topologyValidationReport" -> topologyReport, "equations" -> {}|>]]
    ];
   discreteData = selectedDiscreteSeedRules[
     topo,
     DiscreteMode -> OptionValue[DiscreteMode],
     MaxDiscreteRuleCount -> OptionValue[MaxDiscreteRuleCount]
     ];
   If[discreteData["status"] =!= "generated",
    Return[Join[discreteData, <|"caseName" -> topo["name"], "topologyValidationReport" -> topologyReport, "equations" -> {}|>]]
   ];
   timeGenerators = Select[makeIBPGenerators[topo], #["type"] === "time" &];
   equationCount = continuousData["ruleCount"] discreteData["ruleCount"] Length[timeGenerators];
   maxEquationCount = resolveSeedOption[topo, "MaxEquationCount", OptionValue[MaxEquationCount], 80];
   If[equationCount > maxEquationCount,
    Message[makeTimeIBPSeedBatch::toomany, topo["name"], equationCount, maxEquationCount];
    Return[<|
      "status" -> "tooMany",
      "caseName" -> topo["name"],
      "topologyValidationReport" -> topologyReport,
      "continuousSeedRuleCount" -> continuousData["ruleCount"],
      "discreteRuleCount" -> discreteData["ruleCount"],
      "timeGeneratorCount" -> Length[timeGenerators],
      "equationCount" -> equationCount,
      "equations" -> {}
      |>]
   ];
   genTemplates = ({#, applyTimeGeneratorSeed[topo, baseIntegral, #]} &) /@ timeGenerators;
   If[MemberQ[genTemplates[[All, 2]], $Failed], Return[<|"status" -> "failed", "caseName" -> topo["name"], "topologyValidationReport" -> topologyReport|>]];
   pendingFeatures = timeIBPPendingFeatures[topo];
   equations = Flatten[
     Table[
      Module[{rules = Join[continuousRule, discreteRule], expr},
       expr = genTemplate[[2]] /. rules;
       expr = applySeedCanonical[expr, topo];
       If[TrueQ[OptionValue[ApplyNumericRules]], expr = expr /. topo["numericRules"]];
       <|
        "generator" -> timeGeneratorLabel[genTemplate[[1]]],
        "continuousRules" -> continuousRule,
        "discreteRules" -> discreteRule,
        "equation" -> Expand[expr],
        "forbiddenNData" -> forbiddenNData[topo, expr],
        "eomCanonicalQ" -> ! containsForbiddenNQ[topo, expr]
        |>
       ],
      {genTemplate, genTemplates},
      {continuousRule, continuousData["rules"]},
      {discreteRule, discreteData["rules"]}
      ],
     2
     ];
   <|
    "status" -> "generated",
    "caseName" -> topo["name"],
    "topologyValidationReport" -> topologyReport,
    "continuousSeedRuleCount" -> continuousData["ruleCount"],
    "discreteRuleCount" -> discreteData["ruleCount"],
    "timeGeneratorCount" -> Length[timeGenerators],
    "equationCount" -> Length[equations],
    "eomCanonicalQ" -> And @@ Lookup[equations, "eomCanonicalQ"],
    "forbiddenNData" -> DeleteCases[Flatten[Lookup[equations, "forbiddenNData"]], Null],
    "generators" -> timeGeneratorLabel /@ timeGenerators,
    "continuousSeedRules" -> continuousData["rules"],
    "discreteRules" -> discreteData["rules"],
    "pendingFeatures" -> pendingFeatures,
    "completeTimeIBPQ" -> TrueQ[pendingFeatures === {}],
    "equations" -> equations
    |>
   ];
(* ::Chapter:: *)
(*seed 范围与批量 momentum seed*)

(* 本章把用户给出的 seedRanges 转成受保护的替换规则，并生成小批 momentum seed。
   默认尊重 sampleOnly，只使用基准连续指标和手选离散态，避免无意中展开整个 family。 *)

rangeValuesFromSpec[spec_] := Which[
   Head[spec] === Missing, {0},
   ListQ[spec] && Length[spec] == 2 && And @@ (IntegerQ /@ spec), Range[spec[[1]], spec[[2]]],
   ListQ[spec], spec,
   IntegerQ[spec], {spec},
   True, {0}
   ];


seedRangeValues[topo_Association, key_] := rangeValuesFromSpec[Lookup[topo["seedRanges"], key, Missing["NotSet"]]];


indexVariableQ[x_] := ! TrueQ[IntegerQ[x] || NumericQ[x]];


continuousIndexVariables[J[aList_, linePacks_, ispList_]] := Select[Join[aList, linePacks[[All, 1]], ispList], indexVariableQ];


continuousIndexValueLists[topo_Association, J[aList_, linePacks_, ispList_], useSampleOnly_] := Module[
   {aValues, bValues, ispValues, globalISPRangeQ, globalISPValues},
   aValues = ConstantArray[If[TrueQ[useSampleOnly], {0}, seedRangeValues[topo, "a"]], Count[aList, _?indexVariableQ]];
   bValues = ConstantArray[If[TrueQ[useSampleOnly], {0}, seedRangeValues[topo, "b"]], Count[linePacks[[All, 1]], _?indexVariableQ]];
   globalISPRangeQ = KeyExistsQ[topo["seedRanges"], "isp"];
   globalISPValues = seedRangeValues[topo, "isp"];
   ispValues = Table[
     If[TrueQ[useSampleOnly],
      {0},
      If[globalISPRangeQ,
       globalISPValues,
       rangeValuesFromSpec[Lookup[topo["ispData"][[j]], "range", Missing["NotSet"]]]
       ]
      ],
     {j, Length[ispList]}
     ];
   Join[aValues, bValues, ispValues]
   ];


resolveUseSampleOnly[topo_Association, value_] := If[value === Automatic,
   TrueQ[Lookup[topo["seedRanges"], "sampleOnly", False]],
   TrueQ[value]
   ];


resolveDiscreteMode[topo_Association, value_] := If[value === Automatic,
   Lookup[Lookup[topo, "seedOptions", <||>], "DiscreteMode", "sample"],
   value
   ];


resolveSeedOption[topo_Association, key_String, value_, default_] := If[value === Automatic,
   Lookup[Lookup[topo, "seedOptions", <||>], key, default],
   value
   ];


Options[makeContinuousSeedRules] = {UseSampleOnly -> Automatic, MaxSeedRuleCount -> Automatic};
makeContinuousSeedRules::toomany =
   "拓扑 `1` 的连续 seed 规则数为 `2`，超过上限 `3`；未生成规则。";


makeContinuousSeedRules[topo_Association, OptionsPattern[]] := Module[
   {baseIntegral, useSampleOnly, vars, valueLists, ruleCount, maxCount, rules},
   baseIntegral = makeBaseIntegral[topo];
   useSampleOnly = resolveUseSampleOnly[topo, OptionValue[UseSampleOnly]];
   vars = continuousIndexVariables[baseIntegral];
   valueLists = continuousIndexValueLists[topo, baseIntegral, useSampleOnly];
   ruleCount = Times @@ (Length /@ valueLists);
   maxCount = resolveSeedOption[topo, "MaxSeedRuleCount", OptionValue[MaxSeedRuleCount], 200];
   If[ruleCount > maxCount,
    Message[makeContinuousSeedRules::toomany, topo["name"], ruleCount, maxCount];
    Return[<|
      "status" -> "tooMany",
      "caseName" -> topo["name"],
      "useSampleOnly" -> useSampleOnly,
      "variables" -> vars,
      "valueLists" -> valueLists,
      "ruleCount" -> ruleCount,
      "rules" -> {}
      |>]
    ];
   rules = If[Length[vars] == 0,
     {{}},
     Thread[vars -> #] & /@ Tuples[valueLists]
     ];
   <|
    "status" -> "generated",
    "caseName" -> topo["name"],
    "useSampleOnly" -> useSampleOnly,
    "variables" -> vars,
    "valueLists" -> valueLists,
    "ruleCount" -> Length[rules],
    "rules" -> rules
    |>
   ];


Options[selectedDiscreteSeedRules] = {DiscreteMode -> Automatic, MaxDiscreteRuleCount -> Automatic};
selectedDiscreteSeedRules::toomany =
   "拓扑 `1` 的离散态数为 `2`，超过上限 `3`；未生成 all 离散规则。";


selectedDiscreteSeedRules[topo_Association, OptionsPattern[]] := Module[
   {mode, maxCount, rules, count, coverageIssues, shapeIssues},
   mode = resolveDiscreteMode[topo, OptionValue[DiscreteMode]];
   maxCount = resolveSeedOption[topo, "MaxDiscreteRuleCount", OptionValue[MaxDiscreteRuleCount], 64];
   Switch[mode,
    "none",
    rules = {{}},
     "sample",
     rules = If[Length[topo["sampleDiscreteRules"]] > 0, topo["sampleDiscreteRules"], {{}}];
     shapeIssues = sampleDiscreteRulesShapeIssues[rules];
     If[shapeIssues =!= {},
      Return[<|"status" -> "malformedSampleDiscreteRules", "mode" -> mode, "ruleCount" -> 0, "shapeIssues" -> shapeIssues, "rules" -> {}|>]
      ];
     coverageIssues = sampleDiscreteRuleCoverageIssues[topo, rules];
    If[coverageIssues =!= {},
     Return[<|"status" -> "incompleteSampleDiscreteRules", "mode" -> mode, "ruleCount" -> Length[rules], "coverageIssues" -> coverageIssues, "rules" -> {}|>]
     ],
    "all",
    count = discreteStateCount[topo];
    If[count > maxCount,
     Message[selectedDiscreteSeedRules::toomany, topo["name"], count, maxCount];
     Return[<|"status" -> "tooMany", "mode" -> mode, "ruleCount" -> count, "rules" -> {}|>]
     ];
    rules = enumerateDiscreteStates[makeBaseIntegral[topo], topo]["rules"],
    _,
    rules = If[Length[topo["sampleDiscreteRules"]] > 0, topo["sampleDiscreteRules"], {{}}]
    ];
   <|"status" -> "generated", "mode" -> mode, "ruleCount" -> Length[rules], "rules" -> rules|>
   ];


momentumGeneratorLabel[gen_Association] := {gen["type"], gen["dLoop"], gen["vectorType"], gen["vectorIndex"]};


Options[makeMomentumIBPSeedBatch] = {
   UseSampleOnly -> Automatic,
   MaxSeedRuleCount -> Automatic,
   DiscreteMode -> Automatic,
   MaxDiscreteRuleCount -> Automatic,
   MaxEquationCount -> Automatic,
   ApplyNumericRules -> False
   };
makeMomentumIBPSeedBatch::toomany =
   "拓扑 `1` 的 momentum seed 方程数为 `2`，超过上限 `3`；未展开方程。";


makeMomentumIBPSeedBatch[topo_Association, OptionsPattern[]] := Module[
   {baseIntegral, continuousData, discreteData, momentumGenerators, equationCount,
    maxEquationCount, genTemplates, equations, pendingFeatures, topologyReport},
   topologyReport = topologyValidationReport[topo];
   If[topologyValidationErrorQ[topologyReport],
    Return[<|"status" -> "invalidTopology", "caseName" -> topo["name"], "topologyValidationReport" -> topologyReport, "equations" -> {}|>]
    ];
   baseIntegral = makeBaseIntegral[topo];
   continuousData = makeContinuousSeedRules[
     topo,
     UseSampleOnly -> OptionValue[UseSampleOnly],
     MaxSeedRuleCount -> OptionValue[MaxSeedRuleCount]
     ];
   If[continuousData["status"] =!= "generated",
    Return[Join[continuousData, <|"caseName" -> topo["name"], "topologyValidationReport" -> topologyReport, "equations" -> {}|>]]
    ];
   discreteData = selectedDiscreteSeedRules[
     topo,
     DiscreteMode -> OptionValue[DiscreteMode],
     MaxDiscreteRuleCount -> OptionValue[MaxDiscreteRuleCount]
     ];
   If[discreteData["status"] =!= "generated",
    Return[Join[discreteData, <|"caseName" -> topo["name"], "topologyValidationReport" -> topologyReport, "equations" -> {}|>]]
   ];
   momentumGenerators = Select[makeIBPGenerators[topo], #["type"] === "momentum" &];
   equationCount = continuousData["ruleCount"] discreteData["ruleCount"] Length[momentumGenerators];
   maxEquationCount = resolveSeedOption[topo, "MaxEquationCount", OptionValue[MaxEquationCount], 80];
   If[equationCount > maxEquationCount,
    Message[makeMomentumIBPSeedBatch::toomany, topo["name"], equationCount, maxEquationCount];
    Return[<|
      "status" -> "tooMany",
      "caseName" -> topo["name"],
      "topologyValidationReport" -> topologyReport,
      "continuousSeedRuleCount" -> continuousData["ruleCount"],
      "discreteRuleCount" -> discreteData["ruleCount"],
      "momentumGeneratorCount" -> Length[momentumGenerators],
      "equationCount" -> equationCount,
      "equations" -> {}
      |>]
   ];
   genTemplates = ({#, applyMomentumGeneratorSeed[topo, baseIntegral, #]} &) /@ momentumGenerators;
   If[MemberQ[genTemplates[[All, 2]], $Failed], Return[<|"status" -> "failed", "caseName" -> topo["name"], "topologyValidationReport" -> topologyReport|>]];
   pendingFeatures = momentumIBPPendingFeatures[topo];
   equations = Flatten[
     Table[
      Module[{rules = Join[continuousRule, discreteRule], expr},
       expr = genTemplate[[2]] /. rules;
       expr = applySeedCanonical[expr, topo];
       If[TrueQ[OptionValue[ApplyNumericRules]], expr = expr /. topo["numericRules"]];
       <|
        "generator" -> momentumGeneratorLabel[genTemplate[[1]]],
        "continuousRules" -> continuousRule,
        "discreteRules" -> discreteRule,
        "equation" -> Expand[expr],
        "forbiddenNData" -> forbiddenNData[topo, expr],
        "eomCanonicalQ" -> ! containsForbiddenNQ[topo, expr]
        |>
       ],
      {genTemplate, genTemplates},
      {continuousRule, continuousData["rules"]},
      {discreteRule, discreteData["rules"]}
      ],
     2
     ];
   <|
    "status" -> "generated",
    "caseName" -> topo["name"],
    "topologyValidationReport" -> topologyReport,
    "continuousSeedRuleCount" -> continuousData["ruleCount"],
    "discreteRuleCount" -> discreteData["ruleCount"],
    "momentumGeneratorCount" -> Length[momentumGenerators],
    "equationCount" -> Length[equations],
    "eomCanonicalQ" -> And @@ Lookup[equations, "eomCanonicalQ"],
    "forbiddenNData" -> DeleteCases[Flatten[Lookup[equations, "forbiddenNData"]], Null],
    "generators" -> momentumGeneratorLabel /@ momentumGenerators,
    "continuousSeedRules" -> continuousData["rules"],
    "discreteRules" -> discreteData["rules"],
    "pendingFeatures" -> pendingFeatures,
    "completeMomentumIBPQ" -> TrueQ[pendingFeatures === {}],
    "equations" -> equations
    |>
   ];



(* ::Chapter:: *)
(*自动 shrink-sector seed*)

(* 本章从 top-sector 的 massive full lines 派生 shrunk sectors。
   为避免大图爆炸，默认有 sector 数量保护；超过保护时只保留 pending gate，不展开。 *)

vertexRepresentativeMap[vertexIds_List, pairs_List] := Module[
   {parent, pos, find, union},
   parent = AssociationThread[vertexIds -> vertexIds];
   pos = AssociationThread[vertexIds -> Range[Length[vertexIds]]];
   find[x_] := If[parent[x] === x, x, parent[x] = find[parent[x]]];
   union[x_, y_] := Module[{rx = find[x], ry = find[y], rep, other},
     If[rx === ry, Return[]];
     rep = If[pos[rx] <= pos[ry], rx, ry];
     other = If[rep === rx, ry, rx];
     parent[other] = rep;
     ];
   Scan[union[#[[1]], #[[2]]] &, pairs];
   Association[Table[v -> find[v], {v, vertexIds}]]
   ];


remapExtLegsToRepresentatives[extLegs_List, repMap_Association] := Map[
   If[ListQ[#] && Length[#] >= 2,
     Join[#[[1 ;; 1]], {Lookup[repMap, #[[2]], #[[2]]]}, Drop[#, 2]],
     #
     ] &,
   extLegs
   ];


remapVertexEnergiesToRepresentatives[vertexEnergies_, repMap_Association] := Module[
   {rules, grouped},
   Which[
    AssociationQ[vertexEnergies],
    rules = Normal[vertexEnergies] /. (v_ -> val_) :> (Lookup[repMap, v, v] -> val);
    grouped = Merge[rules, Total];
    grouped,
    ListQ[vertexEnergies],
    rules = vertexEnergies /. (v_ -> val_) :> (Lookup[repMap, v, v] -> val);
    Normal[Merge[rules, Total]],
    True,
    vertexEnergies
    ]
   ];


filterRulesToVariables[rules_List, vars_List] := Module[{varSet = DeleteDuplicates[vars]},
   Select[rules, MemberQ[varSet, First[#]] &]
   ];


filterSampleDiscreteRulesForTopology[rules_List, topo_Association] := Module[
   {vars = Flatten[discreteVarsForLine /@ topo["lines"]]},
   If[rules === {}, {}, filterRulesToVariables[#, vars] & /@ rules]
   ];


shrinkSectorTopology[topo_Association, shrunkLines_List] := Module[
   {pairs, repMap, activeVertices, fixedA, newLines, newExtLegs, newZeroPointRules, newCase, sectorTopo},
   pairs = topo["lines"][[#, "endpoints"]] & /@ shrunkLines;
   repMap = vertexRepresentativeMap[topo["vertexIds"], pairs];
   activeVertices = DeleteDuplicates[Lookup[repMap, topo["vertexIds"]]];
   fixedA = Association[Thread[Complement[topo["vertexIds"], activeVertices] -> 0]];
   newLines = MapIndexed[
     Module[{line = #1, e = First[#2], endpoints},
       endpoints = Lookup[repMap, line["endpoints"]];
       If[MemberQ[shrunkLines, e],
        Join[line, <|"originalEndpoints" -> Lookup[line, "originalEndpoints", line["endpoints"]], "endpoints" -> endpoints, "state" -> "shrunk", "packType" -> "shrunk"|>],
        Join[line, <|"originalEndpoints" -> Lookup[line, "originalEndpoints", line["endpoints"]], "endpoints" -> endpoints|>]
        ]
       ] &,
     topo["lines"]
     ];
   newExtLegs = remapExtLegsToRepresentatives[topo["extLegs"], repMap];
   newZeroPointRules = sectorZeroPointRules[topo, shrunkLines, repMap, activeVertices];
   newCase = <|
     "name" -> topo["name"] <> "_sector_" <> StringRiffle["e" <> ToString[#] & /@ shrunkLines, "_"],
     "vertexData" -> topo["vertexData"],
     "lineData" -> newLines,
     "extLegs" -> newExtLegs,
     "vertexEnergies" -> remapVertexEnergiesToRepresentatives[topo["vertexEnergies"], repMap],
     "loopMomenta" -> topo["loopMomenta"],
     "externalMomenta" -> topo["externalMomenta"],
     "rawExternalInvariantRules" -> Lookup[topo, "rawExternalInvariantRules", topo["externalInvariantRules"]],
     "externalInvariantRules" -> topo["externalInvariantRules"],
     "ispData" -> topo["ispData"],
     "numericRules" -> userNumericRules[topo],
     "sampleDiscreteRules" -> topo["sampleDiscreteRules"],
     "seedRanges" -> topo["seedRanges"],
     "zeroPointRules" -> newZeroPointRules,
     "shrinkPrefactorRules" -> topo["shrinkPrefactorRules"],
     "kiraOrdering" -> topo["kiraOrdering"],
     "sectorVertexRepresentativeMap" -> repMap,
     "activeVertexIds" -> activeVertices,
     "fixedAVertexValues" -> fixedA,
     "sectorShrunkLines" -> shrunkLines
     |>;
   sectorTopo = Join[parseTopology[newCase], <|"sectorShrunkLines" -> shrunkLines|>];
   Join[sectorTopo, <|
     "sectorMetadata" -> makeSectorMetadata[sectorTopo],
     "sampleDiscreteRules" -> filterSampleDiscreteRulesForTopology[topo["sampleDiscreteRules"], sectorTopo]
     |>]
   ];


massiveFullLineIndices[topo_Association] := Flatten@Position[Lookup[topo["lines"], "packType"], "massiveFull"];


shrinkSectorSubsets[topo_Association, maxDepthSpec_, maxCount_Integer] := Module[
   {lines = massiveFullLineIndices[topo], maxDepth, subsets},
   If[lines === {}, Return[<|"status" -> "generated", "subsets" -> {}, "completeCoverageQ" -> True|>]];
   maxDepth = If[maxDepthSpec === Automatic || maxDepthSpec === All || maxDepthSpec === Infinity,
     Length[lines],
     Min[Length[lines], maxDepthSpec]
     ];
   subsets = Rest[Subsets[lines, {0, maxDepth}]];
   If[Length[subsets] > maxCount,
    Return[<|"status" -> "tooMany", "subsets" -> {}, "requestedSubsetCount" -> Length[subsets], "maxCount" -> maxCount, "completeCoverageQ" -> False|>]
    ];
   <|"status" -> "generated", "subsets" -> subsets, "completeCoverageQ" -> TrueQ[maxDepth >= Length[lines]]|>
   ];


Options[makeTopologyData] = {PrecomputeShrinkSectorMetadata -> False, MaxShrinkSectorDepth -> Automatic, MaxShrinkSectorCount -> Automatic};


makeTopologyIndexMaps[topo_Association, metadata_Association] := <|
   "vertexIdToOriginalASlot" -> metadata["vertexIdToOriginalASlot"],
   "vertexIdToCompactASlot" -> metadata["vertexIdToCompactASlot"],
   "lineIdToSlot" -> metadata["lineIdToSlot"],
   "bSymbolToLineSlot" -> metadata["bSymbolToLineSlot"],
   "compactASlots" -> metadata["compactASlots"],
   "lineSlots" -> metadata["lineSlots"],
   "ispSlots" -> metadata["ispSlots"]
   |>;


makeTopologySeedSummary[topo_Association] := <|
   "continuousVariables" -> continuousIndexVariables[makeBaseIntegral[topo]],
   "discreteVariables" -> Flatten[discreteVarsForLine /@ topo["lines"]],
   "discreteStateCount" -> discreteStateCount[topo],
   "momentumGeneratorCount" -> Count[Lookup[makeIBPGenerators[topo], "type"], "momentum"],
   "timeGeneratorCount" -> Count[Lookup[makeIBPGenerators[topo], "type"], "time"],
   "seedRanges" -> topo["seedRanges"],
   "numericRules" -> topo["numericRules"],
   "numericRuleRequirementReport" -> numericRuleRequirementReport[topo],
   "externalInvariantNamingReport" -> externalInvariantNamingReport[topo],
   "vertexEnergyNamingReport" -> vertexEnergyNamingReport[topo],
   "sampleDiscreteRules" -> topo["sampleDiscreteRules"]
   |>;


vertexPairBundleKey[line_Association] := Sort[Lookup[line, "originalEndpoints", line["endpoints"]]];


masslessBundleCandidates[topo_Association] := Module[
   {indexedLines, masslessFullLines, grouped},
   indexedLines = MapIndexed[Join[#1, <|"lineIndex" -> First[#2]|>] &, topo["lines"]];
   masslessFullLines = Select[indexedLines, #["packType"] === "masslessFull" &];
   grouped = GroupBy[masslessFullLines, vertexPairBundleKey];
   KeyValueMap[
    If[Length[#2] > 1,
      <|
       "vertexPair" -> #1,
       "lineIndices" -> Lookup[#2, "lineIndex"],
       "lineIds" -> Lookup[#2, "id"],
       "packTemplates" -> (makeLinePack /@ #2),
       "bundleMode" -> "futureOptionalTwoThetaSharedPair"
       |>,
      Nothing
      ] &,
    grouped
    ]
   ];


unsupportedSeedFeaturesForTopology[topo_Association] := DeleteDuplicates@Join[
    {}
    ];


topologyValidationReport[topo_Association] := Module[
   {issues = {}, appendIssue, vertexIds, lineIds, packTypes, allowedPackTypes,
     duplicateLoopMomenta, duplicateExternalMomenta, loopExternalMomentumOverlap,
     vertexSigns, activeVertexIds, fixedAVertexIds, badVertexSigns, badActiveVertexIds, badFixedAVertexIds,
    extLegs, badExtLegShapePositions, badExtLegVertexData, vertexEnergies, vertexEnergyKeys, badVertexEnergyKeys,
    ispNames, seedRangeData, badSeedRangeData, badSeedSampleOnlyQ, badISPRangeData, seedOptions,
     unknownSeedOptionKeys, badSeedOptionData, kiraOrderingReport, numericRuleValidationReport,
     zeroPointRuleValidationReport, shrinkPrefactorRuleValidationReport,
    badMassTypeLines, badSKTypeLines, badStateLines,
    badEndpointLines, lineMomentumVars, declaredMomentumVars, undeclaredMomentumVars,
    nonLinearLineMomentumData, nonLinearScalarProductArgumentData, vertexEnergyMomentumDependenceData,
    spData, discreteVars, sampleRuleShapeIssues, sampleRulePairs, unknownDiscreteRules, badDiscreteValues,
    missingDiscreteRuleIssues, missingExternalInvariants, missingVertexEnergies,
    missingLineParameters, numericRequirementReport, pendingFeatures, ruleData},
   appendIssue[severity_, code_, data_: <||>] := AppendTo[issues, Join[<|"severity" -> severity, "code" -> code|>, data]];
   vertexIds = topo["vertexIds"];
   vertexSigns = topo["vertexData"][[All, 2]];
   activeVertexIds = Lookup[topo, "activeVertexIds", vertexIds];
   fixedAVertexIds = Keys[Lookup[topo, "fixedAVertexValues", <||>]];
   extLegs = Lookup[topo, "extLegs", {}];
   vertexEnergies = Lookup[topo, "vertexEnergies", <||>];
   ispNames = Lookup[topo["ispData"], "name", {}];
   seedRangeData = KeyDrop[topo["seedRanges"], {"sampleOnly"}];
   seedOptions = Lookup[topo, "seedOptions", <||>];
   lineIds = Lookup[topo["lines"], "id"];
   packTypes = Lookup[topo["lines"], "packType"];
   allowedPackTypes = {"massiveFull", "massiveCross", "masslessFull", "masslessCross", "shrunk"};
   duplicateLoopMomenta = Cases[Tally[topo["loopMomenta"]], {mom_, count_} /; count > 1 :> mom];
   If[duplicateLoopMomenta =!= {},
    appendIssue["error", "duplicateLoopMomenta", <|"loopMomenta" -> topo["loopMomenta"], "duplicates" -> duplicateLoopMomenta|>]
    ];
   duplicateExternalMomenta = Cases[Tally[topo["externalMomenta"]], {mom_, count_} /; count > 1 :> mom];
   If[duplicateExternalMomenta =!= {},
    appendIssue["error", "duplicateExternalMomenta", <|"externalMomenta" -> topo["externalMomenta"], "duplicates" -> duplicateExternalMomenta|>]
    ];
   loopExternalMomentumOverlap = Intersection[topo["loopMomenta"], topo["externalMomenta"]];
   If[loopExternalMomentumOverlap =!= {},
    appendIssue["error", "loopExternalMomentumOverlap", <|"overlap" -> loopExternalMomentumOverlap, "loopMomenta" -> topo["loopMomenta"], "externalMomenta" -> topo["externalMomenta"]|>]
    ];
   If[! DuplicateFreeQ[lineIds],
    appendIssue["error", "duplicateLineIds", <|"lineIds" -> lineIds|>]
    ];
   If[ispNames =!= {} && ! DuplicateFreeQ[ispNames],
    appendIssue["error", "duplicateISPNames", <|"ispNames" -> ispNames|>]
    ];
   badSeedRangeData = KeyValueMap[
     If[! validIndexRangeSpecQ[#2],
       <|"rangeKey" -> #1, "rangeSpec" -> #2|>,
       Nothing
       ] &,
     seedRangeData
     ];
   If[badSeedRangeData =!= {},
    appendIssue["error", "malformedSeedRangeSpecs", <|"ranges" -> badSeedRangeData, "allowed" -> "integer or nonempty integer list"|>]
    ];
   badSeedSampleOnlyQ = KeyExistsQ[topo["seedRanges"], "sampleOnly"] && ! BooleanQ[topo["seedRanges", "sampleOnly"]];
   If[TrueQ[badSeedSampleOnlyQ],
    appendIssue["error", "malformedSeedSampleOnly", <|"sampleOnly" -> topo["seedRanges", "sampleOnly"], "allowed" -> {True, False}|>]
    ];
   badISPRangeData = DeleteCases[
     MapIndexed[
      If[KeyExistsQ[#1, "range"] && ! validIndexRangeSpecQ[#1["range"]],
        <|"ispPosition" -> First[#2], "name" -> Lookup[#1, "name", Missing["name"]], "rangeSpec" -> #1["range"]|>,
        Nothing
        ] &,
      topo["ispData"]
      ],
     Nothing
     ];
   If[badISPRangeData =!= {},
    appendIssue["error", "malformedISPRangeSpecs", <|"isps" -> badISPRangeData, "allowed" -> "integer or nonempty integer list"|>]
    ];
   unknownSeedOptionKeys = Complement[Keys[seedOptions], allowedSeedOptionKeys[]];
   If[unknownSeedOptionKeys =!= {},
    appendIssue["error", "unknownSeedOptionKeys", <|"keys" -> unknownSeedOptionKeys, "allowedKeys" -> allowedSeedOptionKeys[]|>]
    ];
   badSeedOptionData = KeyValueMap[
     If[MemberQ[allowedSeedOptionKeys[], #1] && ! validSeedOptionValueQ[#1, #2],
       <|"optionKey" -> #1, "optionValue" -> #2|>,
       Nothing
       ] &,
     seedOptions
     ];
   If[badSeedOptionData =!= {},
    appendIssue["error", "malformedSeedOptionValues", <|"options" -> badSeedOptionData|>]
    ];
   kiraOrderingReport = validateKiraOrderingSpec[Lookup[topo, "kiraOrdering", <||>]];
   If[Lookup[kiraOrderingReport, "status", "ok"] =!= "ok",
    appendIssue["error", "invalidKiraOrdering", KeyDrop[kiraOrderingReport, {"status"}]]
    ];
   numericRuleValidationReport = validateCoefficientRules[topo["numericRules"]];
   If[Lookup[numericRuleValidationReport, "status", "ok"] =!= "ok",
    appendIssue["error", "invalidNumericRules", KeyDrop[numericRuleValidationReport, {"status"}]]
    ];
   zeroPointRuleValidationReport = validateCoefficientRules[topo["zeroPointRules"]];
   If[Lookup[zeroPointRuleValidationReport, "status", "ok"] =!= "ok",
    appendIssue["error", "invalidZeroPointRules", KeyDrop[zeroPointRuleValidationReport, {"status"}]]
    ];
   shrinkPrefactorRuleValidationReport = validateCoefficientRules[topo["shrinkPrefactorRules"]];
   If[Lookup[shrinkPrefactorRuleValidationReport, "status", "ok"] =!= "ok",
    appendIssue["error", "invalidShrinkPrefactorRules", KeyDrop[shrinkPrefactorRuleValidationReport, {"status"}]]
    ];
   If[! DuplicateFreeQ[vertexIds],
    appendIssue["error", "duplicateVertexIds", <|"vertexIds" -> vertexIds|>]
    ];
   badVertexSigns = DeleteDuplicates[Complement[vertexSigns, {"+", "-"}]];
   If[badVertexSigns =!= {},
    appendIssue["error", "unknownVertexSigns", <|"vertexSigns" -> badVertexSigns, "allowedVertexSigns" -> {"+", "-"}|>]
    ];
   badActiveVertexIds = Complement[activeVertexIds, vertexIds];
   If[badActiveVertexIds =!= {},
    appendIssue["error", "activeVertexIdsNotInVertexData", <|"activeVertexIds" -> badActiveVertexIds, "vertexIds" -> vertexIds|>]
    ];
   badFixedAVertexIds = Complement[fixedAVertexIds, vertexIds];
   If[badFixedAVertexIds =!= {},
    appendIssue["error", "fixedAVertexValuesNotInVertexData", <|"fixedAVertexIds" -> badFixedAVertexIds, "vertexIds" -> vertexIds|>]
    ];
   If[! ListQ[extLegs],
    appendIssue["error", "malformedExtLegs", <|"reason" -> "extLegs must be a list of entries with at least {label, vertexId, energy}"|>],
    badExtLegShapePositions = Flatten @ Position[extLegs, entry_ /; !(ListQ[entry] && Length[entry] >= 3), {1}, Heads -> False];
    If[badExtLegShapePositions =!= {},
     appendIssue["error", "malformedExtLegs", <|"badPositions" -> badExtLegShapePositions|>]
     ];
    badExtLegVertexData = DeleteCases[
      MapIndexed[
       If[ListQ[#1] && Length[#1] >= 2 && ! MemberQ[vertexIds, #1[[2]]],
         <|"extLegPosition" -> First[#2], "vertexId" -> #1[[2]]|>,
         Nothing
         ] &,
       extLegs
       ],
      Nothing
      ];
    If[badExtLegVertexData =!= {},
     appendIssue["error", "extLegVertexNotInVertexData", <|"extLegs" -> badExtLegVertexData, "vertexIds" -> vertexIds|>]
     ]
    ];
   vertexEnergyKeys = Which[
     AssociationQ[vertexEnergies], Keys[vertexEnergies],
     ListQ[vertexEnergies] && And @@ (MatchQ[#, _Rule | _RuleDelayed] & /@ vertexEnergies), Cases[vertexEnergies, (Rule | RuleDelayed)[v_, _] :> v],
     vertexEnergies === <||>, {},
     True, Missing["MalformedVertexEnergies"]
     ];
   If[vertexEnergyKeys === Missing["MalformedVertexEnergies"],
    appendIssue["error", "malformedVertexEnergies", <|"reason" -> "vertexEnergies must be an Association or list of rules"|>],
    badVertexEnergyKeys = Complement[vertexEnergyKeys, vertexIds];
    If[badVertexEnergyKeys =!= {},
     appendIssue["error", "vertexEnergiesNotInVertexData", <|"vertexEnergyKeys" -> badVertexEnergyKeys, "vertexIds" -> vertexIds|>]
     ]
    ];
   vertexEnergyMomentumDependenceData = vertexEnergyMomentumDependenceIssues[topo];
   If[vertexEnergyMomentumDependenceData =!= {},
    appendIssue["error", "invalidVertexEnergyMomentumDependence", <|"issues" -> vertexEnergyMomentumDependenceData, "comment" -> "vertexEnergies are scalar time-phase energies for all external legs attached to a vertex: use external invariant variables such as s11/sigW when they belong to externalMomenta space, otherwise use independent ke[i] parameters"|>]
    ];
   If[Lookup[topo, "unknownSeedPreset", None] =!= None,
    appendIssue["error", "unknownSeedPreset", <|"seedPreset" -> topo["unknownSeedPreset"], "allowedSeedPresets" -> {"quickCheck", "fullDiscrete", "bounded"}|>]
    ];
   badEndpointLines = Select[
     MapIndexed[Join[#1, <|"lineIndex" -> First[#2]|>] &, topo["lines"]],
     ! SubsetQ[vertexIds, Lookup[#, "endpoints", {}]] &
     ];
   If[badEndpointLines =!= {},
    appendIssue["error", "lineEndpointNotInVertexData", <|"lineIndices" -> Lookup[badEndpointLines, "lineIndex"], "endpoints" -> Lookup[badEndpointLines, "endpoints"]|>]
    ];
   If[Complement[packTypes, allowedPackTypes] =!= {},
    appendIssue["error", "unknownPackTypes", <|"packTypes" -> DeleteDuplicates[Complement[packTypes, allowedPackTypes]]|>]
    ];
   badMassTypeLines = Select[
     MapIndexed[Join[#1, <|"lineIndex" -> First[#2]|>] &, topo["lines"]],
     ! MemberQ[{"massive", "massless"}, Lookup[#, "massType", "massive"]] &
     ];
   If[badMassTypeLines =!= {},
    appendIssue["error", "unknownLineMassTypes", <|"lineIndices" -> Lookup[badMassTypeLines, "lineIndex"], "massTypes" -> Lookup[badMassTypeLines, "massType"], "allowedMassTypes" -> {"massive", "massless"}|>]
    ];
   badSKTypeLines = Select[
     MapIndexed[Join[#1, <|"lineIndex" -> First[#2]|>] &, topo["lines"]],
     ! MemberQ[{"++", "--", "+-", "-+"}, Lookup[#, "skType", "++"]] &
     ];
   If[badSKTypeLines =!= {},
    appendIssue["error", "unknownLineSKTypes", <|"lineIndices" -> Lookup[badSKTypeLines, "lineIndex"], "skTypes" -> Lookup[badSKTypeLines, "skType"], "allowedSKTypes" -> {"++", "--", "+-", "-+"}|>]
    ];
   badStateLines = Select[
     MapIndexed[Join[#1, <|"lineIndex" -> First[#2]|>] &, topo["lines"]],
     ! MemberQ[{"full", "shrunk"}, Lookup[#, "state", "full"]] &
     ];
   If[badStateLines =!= {},
    appendIssue["error", "unknownLineStates", <|"lineIndices" -> Lookup[badStateLines, "lineIndex"], "states" -> Lookup[badStateLines, "state"], "allowedStates" -> {"full", "shrunk"}|>]
    ];
   lineMomentumVars = DeleteDuplicates[Flatten[Variables /@ Lookup[topo["lines"], "momentum"]]];
   declaredMomentumVars = DeleteDuplicates@Join[topo["loopMomenta"], topo["externalMomenta"]];
   undeclaredMomentumVars = Complement[lineMomentumVars, declaredMomentumVars];
   If[undeclaredMomentumVars =!= {},
    appendIssue["error", "undeclaredMomentumVariables", <|"variables" -> undeclaredMomentumVars, "declared" -> declaredMomentumVars|>]
    ];
   nonLinearLineMomentumData = lineMomentumLinearityIssues[topo];
   If[nonLinearLineMomentumData =!= {},
    appendIssue["error", "nonLinearLineMomenta", <|"issues" -> nonLinearLineMomentumData, "comment" -> "line momenta must be linear combinations of loopMomenta and externalMomenta"|>]
    ];
   nonLinearScalarProductArgumentData = scalarProductArgumentLinearityIssues[topo];
   If[nonLinearScalarProductArgumentData =!= {},
    appendIssue["error", "nonLinearScalarProductArguments", <|"issues" -> nonLinearScalarProductArgumentData, "comment" -> "sp[p,r] arguments must be linear momentum combinations before scalar products are expanded"|>]
    ];
   spData = makeScalarProductData[topo];
   If[spData["unsupportedISPExprs"] =!= {},
    appendIssue["error", "unsupportedISPExpressions", <|"expressions" -> spData["unsupportedISPExprs"], "allowedScalarProducts" -> spData["scalarProducts"]|>]
    ];
   If[! TrueQ[spData["structuralCountQ"]],
    appendIssue["error", "insufficientISPData", <|"needed" -> spData["structuralNeededISPCount"], "providedDirect" -> spData["directISPCount"], "provided" -> spData["ispCount"]|>]
    ];
   If[spData["unsupportedISPExprs"] === {} && TrueQ[spData["structuralCountQ"]] && ! TrueQ[spData["coordinateCountQ"]],
    appendIssue["error", "scalarProductCoordinateCountMismatch", <|
      "zCount" -> spData["zCount"],
      "nonISPScalarProductCount" -> spData["nonISPScalarProductCount"],
      "assumption" -> "topology input must provide a closed z/ISP coordinate system; no automatic redundant propagator subset is selected"
      |>]
    ];
   If[spData["unsupportedISPExprs"] === {} && TrueQ[spData["structuralCountQ"]] && TrueQ[spData["coordinateCountQ"]],
    ruleData = makeScalarProductRules[topo];
    If[Lookup[ruleData, "status", "notComputed"] =!= "computed",
     appendIssue["error", "scalarProductCoordinateSolveFailed", <|
       "reason" -> Lookup[ruleData, "reason", Missing["reason"]],
       "solveVars" -> Lookup[ruleData, "solveVars", spData["solveVars"]],
       "zCount" -> spData["zCount"],
       "nonISPScalarProductCount" -> spData["nonISPScalarProductCount"]
       |>]
     ]
    ];
   numericRequirementReport = numericRuleRequirementReport[topo];
   missingExternalInvariants = numericRequirementReport["missingExternalInvariants"];
   If[missingExternalInvariants =!= {},
    appendIssue["warning", "numericRulesMissingExternalInvariants", <|
      "missingExternalInvariants" -> missingExternalInvariants,
      "numericRules" -> userNumericRules[topo],
      "comment" -> "analytic seed can still be generated; numeric linear/Kira stages need external invariant value rules, using the output names from externalInvariantRules/default sij"
      |>]
    ];
   missingVertexEnergies = numericRequirementReport["missingVertexEnergies"];
   If[missingVertexEnergies =!= {},
    appendIssue["warning", "numericRulesMissingVertexEnergies", <|
      "missingVertexEnergies" -> missingVertexEnergies,
      "numericRules" -> userNumericRules[topo],
      "comment" -> "analytic seed can still be generated; numeric linear/Kira stages need vertex energy rules from time IBP"
      |>]
    ];
   missingLineParameters = numericRequirementReport["missingLineParameters"];
   If[missingLineParameters =!= {},
    appendIssue["warning", "numericRulesMissingLineParameters", <|
      "missingLineParameters" -> missingLineParameters,
      "numericRules" -> userNumericRules[topo],
      "comment" -> "analytic seed can still be generated; numeric linear/Kira stages need massive line parameter rules"
      |>]
    ];
   discreteVars = Flatten[discreteVarsForLine /@ topo["lines"]];
   sampleRuleShapeIssues = sampleDiscreteRulesShapeIssues[topo["sampleDiscreteRules"]];
   If[sampleRuleShapeIssues =!= {},
    appendIssue["error", "malformedSampleDiscreteRules", <|"issues" -> sampleRuleShapeIssues|>],
    sampleRulePairs = sampleDiscreteRulePairs[topo["sampleDiscreteRules"]];
    unknownDiscreteRules = Select[sampleRulePairs, ! MemberQ[discreteVars, #[[1]]] &];
    If[unknownDiscreteRules =!= {},
     appendIssue["warning", "sampleDiscreteRulesContainUnknownVariables", <|"rules" -> (Rule @@@ unknownDiscreteRules), "allowedDiscreteVariables" -> discreteVars|>]
     ];
    badDiscreteValues = Select[sampleRulePairs, MemberQ[discreteVars, #[[1]]] && ! MemberQ[{0, 1}, #[[2]]] &];
    If[badDiscreteValues =!= {},
     appendIssue["warning", "sampleDiscreteRulesContainNonBinaryValues", <|"rules" -> (Rule @@@ badDiscreteValues)|>]
     ];
    If[discreteVars =!= {} && topo["sampleDiscreteRules"] === {},
     appendIssue["warning", "sampleDiscreteRulesMissingForDiscreteVariables", <|"missingVariables" -> discreteVars, "comment" -> "sample seed mode needs complete n=0/1 rules; DiscreteMode -> all can enumerate them automatically"|>]
     ];
    If[topo["sampleDiscreteRules"] =!= {},
     missingDiscreteRuleIssues = sampleDiscreteRuleCoverageIssues[topo, topo["sampleDiscreteRules"]];
     If[missingDiscreteRuleIssues =!= {},
      appendIssue["error", "sampleDiscreteRulesMissingVariables", <|"issues" -> missingDiscreteRuleIssues, "allowedDiscreteVariables" -> discreteVars|>]
      ]
     ]
    ];
   pendingFeatures = unsupportedSeedFeaturesForTopology[topo];
   If[pendingFeatures =!= {},
    appendIssue["pending", "unsupportedSeedFeatures", <|"pendingFeatures" -> pendingFeatures|>]
    ];
   <|
    "status" -> If[Count[Lookup[issues, "severity", {}], "error"] == 0, "ok", "issues"],
    "errorCount" -> Count[Lookup[issues, "severity", {}], "error"],
    "warningCount" -> Count[Lookup[issues, "severity", {}], "warning"],
    "pendingCount" -> Count[Lookup[issues, "severity", {}], "pending"],
    "numericRuleRequirementReport" -> numericRequirementReport,
    "pendingFeatures" -> pendingFeatures,
    "issues" -> issues
    |>
   ];


topologyValidationErrorQ[report_Association] := TrueQ[Lookup[report, "errorCount", 0] > 0];
topologyValidationErrorQ[_] := False;


makeTopologyData[case_Association, OptionsPattern[]] := Module[
   {topo, topMetadata, subsetData, sectorTopos, sectorMetadataList, maxShrinkDepth, maxShrinkCount, inputReport, validationReport},
   If[caseInputPreflightErrorQ[case],
    inputReport = caseInputRequirementReport[case];
    validationReport = caseInputErrorReport[case];
    Return[Join[case, <|
       "status" -> "invalidInput",
       "reason" -> If[inputReport["missingRequiredKeys"] =!= {}, "missingRequiredCaseKeys", "malformedCaseInput"],
       "inputRequirementReport" -> inputReport,
       "validationReport" -> validationReport,
       "sectorMetadataList" -> {},
       "indexMaps" -> <||>,
       "seedSummary" -> <||>,
       "numericRuleRequirementReport" -> <||>,
       "numericRuleTemplate" -> {},
       "masslessBundleCandidates" -> {},
       "precomputedShrinkSectorSummary" -> <|"status" -> "skipped"|>,
       "precomputedShrinkSectorKeys" -> {}
       |>]]
    ];
   topo = parseTopology[case];
   topMetadata = makeSectorMetadata[topo];
   maxShrinkDepth = resolveSeedOption[topo, "MaxShrinkSectorDepth", OptionValue[MaxShrinkSectorDepth], Automatic];
   maxShrinkCount = resolveSeedOption[topo, "MaxShrinkSectorCount", OptionValue[MaxShrinkSectorCount], 16];
   subsetData = If[TrueQ[OptionValue[PrecomputeShrinkSectorMetadata]],
     shrinkSectorSubsets[topo, maxShrinkDepth, maxShrinkCount],
     <|"status" -> "skipped", "subsets" -> {}, "completeCoverageQ" -> False|>
     ];
   sectorTopos = If[Lookup[subsetData, "status", "skipped"] === "generated",
     shrinkSectorTopology[topo, #] & /@ Lookup[subsetData, "subsets", {}],
     {}
     ];
   sectorMetadataList = Join[{topMetadata}, Lookup[#, "sectorMetadata", makeSectorMetadata[#]] & /@ sectorTopos];
   Join[topo, <|
     "sectorMetadata" -> topMetadata,
     "sectorMetadataList" -> sectorMetadataList,
     "indexMaps" -> makeTopologyIndexMaps[topo, topMetadata],
     "seedSummary" -> makeTopologySeedSummary[topo],
     "validationReport" -> topologyValidationReport[topo],
     "numericRuleRequirementReport" -> numericRuleRequirementReport[topo],
     "numericRuleTemplate" -> makeNumericRuleTemplate[topo],
     "masslessBundleCandidates" -> masslessBundleCandidates[topo],
     "precomputedShrinkSectorSummary" -> KeyDrop[subsetData, "subsets"],
     "precomputedShrinkSectorKeys" -> Lookup[sectorMetadataList, "sectorKey"]
     |>]
   ];

Options[makeShrinkSectorSeedBatch] = Join[
   Options[makeMomentumIBPSeedBatch],
   {MaxShrinkSectorDepth -> Automatic, MaxShrinkSectorCount -> Automatic}
   ];
makeShrinkSectorSeedBatch::toomany = "拓扑 `1` 的 shrink sector 数为 `2`，超过上限 `3`；未展开 shrink sectors。";


(* shrink sector 的摘要要保留各自的生成元列表；coverage report 依赖它判断每个子 sector 是否同时生成完整 q/t seed。 *)
shrinkSectorBatchSummary[batch_Association] := Module[
   {metadata = Lookup[batch["topology"], "sectorMetadata", makeSectorMetadata[batch["topology"]]]},
   <|
    "sectorShrunkLines" -> batch["sectorShrunkLines"],
    "sectorKey" -> metadata["sectorKey"],
    "momentumSummary" -> KeyDrop[batch["momentumBatch"], "equations"],
    "timeSummary" -> KeyDrop[batch["timeBatch"], "equations"]
    |>
   ];


makeShrinkSectorSeedBatch[topo_Association, OptionsPattern[]] := Module[
   {subsetData, subsets, seedOpts, sectorTopos, sectorBatches, bad, equations, pendingFeatures, completeQ, topologyReport, maxShrinkDepth, maxShrinkCount},
   topologyReport = topologyValidationReport[topo];
   maxShrinkDepth = resolveSeedOption[topo, "MaxShrinkSectorDepth", OptionValue[MaxShrinkSectorDepth], Automatic];
   maxShrinkCount = resolveSeedOption[topo, "MaxShrinkSectorCount", OptionValue[MaxShrinkSectorCount], 16];
   subsetData = shrinkSectorSubsets[topo, maxShrinkDepth, maxShrinkCount];
   If[subsetData["status"] === "tooMany",
    Message[makeShrinkSectorSeedBatch::toomany, topo["name"], subsetData["requestedSubsetCount"], subsetData["maxCount"]];
    Return[Join[subsetData, <|"caseName" -> topo["name"], "topologyValidationReport" -> topologyReport, "sectorMetadataList" -> {}, "equations" -> {}, "pendingFeatures" -> {"shrinkSectorSeedGeneration"}|>]]
    ];
   subsets = subsetData["subsets"];
   If[subsets === {},
    Return[<|"status" -> "generated", "caseName" -> topo["name"], "topologyValidationReport" -> topologyReport, "sectorCount" -> 0, "sectorMetadataList" -> {}, "equationCount" -> 0, "eomCanonicalQ" -> True, "forbiddenNData" -> {}, "pendingFeatures" -> {}, "completeShrinkSectorGenerationQ" -> True, "sectorSummaries" -> {}, "equations" -> {}|>]
    ];
   seedOpts = FilterRules[
     Table[opt -> OptionValue[opt], {opt, First /@ Options[makeMomentumIBPSeedBatch]}],
     Options[makeMomentumIBPSeedBatch]
     ];
   sectorTopos = shrinkSectorTopology[topo, #] & /@ subsets;
   sectorBatches = Table[
     Module[{mom = makeMomentumIBPSeedBatch[sectorTopo, Sequence @@ seedOpts], tim = makeTimeIBPSeedBatch[sectorTopo, Sequence @@ seedOpts]},
      <|"sectorShrunkLines" -> sectorTopo["sectorShrunkLines"], "topology" -> sectorTopo, "momentumBatch" -> mom, "timeBatch" -> tim|>
      ],
     {sectorTopo, sectorTopos}
     ];
   bad = Select[sectorBatches, Lookup[#["momentumBatch"], "status", "missing"] =!= "generated" || Lookup[#["timeBatch"], "status", "missing"] =!= "generated" &];
   If[bad =!= {},
    Return[<|"status" -> "notGenerated", "caseName" -> topo["name"], "topologyValidationReport" -> topologyReport, "badSectorCount" -> Length[bad], "sectorSummaries" -> KeyDrop[#, {"topology", "momentumBatch", "timeBatch"}] & /@ bad, "equations" -> {}, "pendingFeatures" -> {"shrinkSectorSeedGeneration"}|>]
    ];
   equations = Flatten[
     Table[
      Join[
       annotateSeedEquations[batch["momentumBatch"]["equations"], {"shrinkSectorMomentum", batch["sectorShrunkLines"]}],
       annotateSeedEquations[batch["timeBatch"]["equations"], {"shrinkSectorTime", batch["sectorShrunkLines"]}]
       ],
      {batch, sectorBatches}
      ],
     1
     ];
   pendingFeatures = DeleteCases[
     DeleteDuplicates[Flatten[Lookup[#["timeBatch"], "pendingFeatures", {}] & /@ sectorBatches]],
     "shrinkSectorSeedGeneration"
     ];
   completeQ = TrueQ[subsetData["completeCoverageQ"] && pendingFeatures === {}];
   <|
    "status" -> "generated",
    "caseName" -> topo["name"],
    "topologyValidationReport" -> topologyReport,
    "sectorCount" -> Length[sectorBatches],
    "sectorSubsets" -> subsets,
    "completeCoverageQ" -> subsetData["completeCoverageQ"],
    "equationCount" -> Length[equations],
    "eomCanonicalQ" -> And @@ Flatten[Table[{batch["momentumBatch"]["eomCanonicalQ"], batch["timeBatch"]["eomCanonicalQ"]}, {batch, sectorBatches}]],
    "forbiddenNData" -> DeleteCases[Flatten[Table[{batch["momentumBatch"]["forbiddenNData"], batch["timeBatch"]["forbiddenNData"]}, {batch, sectorBatches}]], Null],
    "pendingFeatures" -> If[completeQ, {}, DeleteDuplicates[Join[pendingFeatures, {"shrinkSectorSeedGeneration"}]]],
    "completeShrinkSectorGenerationQ" -> completeQ,
    "sectorMetadataList" -> (Lookup[#["topology"], "sectorMetadata", makeSectorMetadata[#["topology"]]] & /@ sectorBatches),
    "sectorSummaries" -> (shrinkSectorBatchSummary /@ sectorBatches),
    "equations" -> equations
    |>
   ];

(* ::Chapter:: *)
(*统一 canonical seed 与 Kira 导出门禁*)

(* 本章只合并已经生成的 seed，并给出 Kira 前的 readiness 判断。
   若 time/momentum seed 仍有 pending features 或 forbidden n，Kira exporter 必须返回 notReady，不写文件。 *)

annotateSeedEquations[equations_List, source_] := Join[<|"source" -> source|>, #] & /@ equations;


canonicalPendingFeatures[momentumBatch_Association, timeBatch_Association] := DeleteDuplicates @ Join[
    Lookup[momentumBatch, "pendingFeatures", {}],
    Lookup[timeBatch, "pendingFeatures", {}]
    ];


Options[makeCanonicalSeedBatch] = Join[
   Options[makeMomentumIBPSeedBatch],
   {GenerateShrinkSectors -> True, MaxShrinkSectorDepth -> Automatic, MaxShrinkSectorCount -> Automatic}
   ];


makeCanonicalSeedBatch[topo_Association, opts : OptionsPattern[]] := Module[
   {momentumBatch, timeBatch, shrinkBatch, seedOpts, shrinkOpts, pendingFeatures, equations, eomCanonicalQ, sectorMetadataList, topologyReport},
   topologyReport = topologyValidationReport[topo];
   If[topologyValidationErrorQ[topologyReport],
    Return[<|"status" -> "invalidTopology", "caseName" -> topo["name"], "topologyValidationReport" -> topologyReport, "sectorMetadataList" -> {}, "equationCount" -> 0, "eomCanonicalQ" -> False, "forbiddenNData" -> {}, "pendingFeatures" -> {}, "equations" -> {}|>]
    ];
   seedOpts = FilterRules[{opts}, Options[makeMomentumIBPSeedBatch]];
   shrinkOpts = FilterRules[{opts}, Options[makeShrinkSectorSeedBatch]];
   momentumBatch = makeMomentumIBPSeedBatch[topo, Sequence @@ seedOpts];
   timeBatch = makeTimeIBPSeedBatch[topo, Sequence @@ seedOpts];
   shrinkBatch = If[TrueQ[OptionValue[GenerateShrinkSectors]],
     makeShrinkSectorSeedBatch[topo, Sequence @@ shrinkOpts],
     <|"status" -> "skipped", "caseName" -> topo["name"], "topologyValidationReport" -> topologyReport, "sectorMetadataList" -> {}, "equationCount" -> 0, "eomCanonicalQ" -> True, "forbiddenNData" -> {}, "pendingFeatures" -> If[massiveFullLineIndices[topo] === {}, {}, {"shrinkSectorSeedGeneration"}], "equations" -> {}|>
     ];
   If[Lookup[momentumBatch, "status", "missing"] =!= "generated" || Lookup[timeBatch, "status", "missing"] =!= "generated",
    Return[<|
      "status" -> "notGenerated",
      "caseName" -> topo["name"],
      "topologyValidationReport" -> topologyReport,
      "momentumStatus" -> Lookup[momentumBatch, "status", Missing["momentumStatus"]],
      "timeStatus" -> Lookup[timeBatch, "status", Missing["timeStatus"]],
      "momentumBatch" -> KeyDrop[momentumBatch, "equations"],
      "timeBatch" -> KeyDrop[timeBatch, "equations"]
      |>]
    ];
   pendingFeatures = DeleteDuplicates@Join[
     Lookup[momentumBatch, "pendingFeatures", {}],
     Lookup[timeBatch, "pendingFeatures", {}],
     Lookup[shrinkBatch, "pendingFeatures", {}]
     ];
   If[TrueQ[Lookup[shrinkBatch, "completeShrinkSectorGenerationQ", False]],
    pendingFeatures = DeleteCases[pendingFeatures, "shrinkSectorSeedGeneration"]
    ];
   equations = Join[
     annotateSeedEquations[momentumBatch["equations"], "momentum"],
     annotateSeedEquations[timeBatch["equations"], "time"],
     Lookup[shrinkBatch, "equations", {}]
     ];
   eomCanonicalQ = TrueQ[momentumBatch["eomCanonicalQ"]] && TrueQ[timeBatch["eomCanonicalQ"]] && TrueQ[Lookup[shrinkBatch, "eomCanonicalQ", True]];
   sectorMetadataList = Join[{makeSectorMetadata[topo]}, Lookup[shrinkBatch, "sectorMetadataList", {}]];
   <|
    "status" -> "generated",
    "caseName" -> topo["name"],
    "topologyValidationReport" -> topologyReport,
    "momentumEquationCount" -> momentumBatch["equationCount"],
    "timeEquationCount" -> timeBatch["equationCount"],
    "shrinkSectorEquationCount" -> Lookup[shrinkBatch, "equationCount", 0],
    "equationCount" -> Length[equations],
    "eomCanonicalQ" -> eomCanonicalQ,
    "forbiddenNData" -> DeleteCases[Flatten[{momentumBatch["forbiddenNData"], timeBatch["forbiddenNData"], Lookup[shrinkBatch, "forbiddenNData", {}]}], Null],
    "pendingFeatures" -> pendingFeatures,
    "completeMomentumIBPQ" -> TrueQ[momentumBatch["eomCanonicalQ"] && Lookup[momentumBatch, "pendingFeatures", {}] === {}],
    "completeTimeIBPQ" -> TrueQ[pendingFeatures === {}],
    "completeCanonicalQ" -> TrueQ[eomCanonicalQ && pendingFeatures === {}],
    "sectorMetadata" -> First[sectorMetadataList],
    "sectorMetadataList" -> sectorMetadataList,
    "momentumSummary" -> KeyDrop[momentumBatch, "equations"],
    "timeSummary" -> KeyDrop[timeBatch, "equations"],
    "shrinkSectorSummary" -> KeyDrop[shrinkBatch, "equations"],
    "equations" -> equations
    |>
   ];


canonicalSeedReadyQ[batch_Association] := TrueQ[
   Lookup[batch, "status", "missing"] === "generated" &&
    Lookup[batch, "completeCanonicalQ", False] &&
    Lookup[batch, "forbiddenNData", {"missing"}] === {}
   ];


seedEntrySourceSectorKey[entry_Association] := Module[{source = Lookup[entry, "source", "top"]},
   Which[
    ListQ[source] && Length[source] >= 2 && StringContainsQ[ToString[First[source]], "shrinkSector"], sectorKeyFromShrunkLines[source[[2]]],
    True, "top"
    ]
   ];


seedEntryIBPClass[entry_Association] := Module[{source = ToString[Lookup[entry, "source", "unknown"], InputForm]},
   Which[
    StringContainsQ[source, "Momentum", IgnoreCase -> True], "qIBP",
    StringContainsQ[source, "momentum", IgnoreCase -> True], "qIBP",
    StringContainsQ[source, "Time", IgnoreCase -> True], "tIBP",
    StringContainsQ[source, "time", IgnoreCase -> True], "tIBP",
    True, "unknownIBP"
    ]
   ];


classifyCanonicalSeedBatch[batch_Association] := Module[
   {equations = Lookup[batch, "equations", {}], tagged, grouped},
   tagged = Join[#, <|"sectorKey" -> seedEntrySourceSectorKey[#], "ibpClass" -> seedEntryIBPClass[#]|>] & /@ equations;
   grouped = GroupBy[tagged, {#sectorKey &, #ibpClass &}];
   <|
    "status" -> If[Lookup[batch, "status", "missing"] === "generated", "generated", "notGenerated"],
    "caseName" -> Lookup[batch, "caseName", Missing["caseName"]],
    "sectorKeys" -> Sort[DeleteDuplicates[Lookup[tagged, "sectorKey", {}]]],
    "classes" -> Sort[DeleteDuplicates[Lookup[tagged, "ibpClass", {}]]],
    "equationCount" -> Length[tagged],
    "bySectorThenClass" -> grouped,
    "summary" -> Association @ KeyValueMap[#1 -> Map[Length, #2] &, grouped]
    |>
   ];


canonicalGeneratorStrings[list_] := Sort[ToString[#, InputForm] & /@ list];


expectedGeneratorsBySector[batch_Association] := Module[
   {topEntry, shrinkSummaries, shrinkEntries},
   topEntry = "top" -> <|
      "qIBP" -> Lookup[Lookup[batch, "momentumSummary", <||>], "generators", {}],
      "tIBP" -> Lookup[Lookup[batch, "timeSummary", <||>], "generators", {}]
      |>;
   shrinkSummaries = Lookup[Lookup[batch, "shrinkSectorSummary", <||>], "sectorSummaries", {}];
   shrinkEntries = Table[
     Lookup[summary, "sectorKey", sectorKeyFromShrunkLines[Lookup[summary, "sectorShrunkLines", {}]]] -> <|
       "qIBP" -> Lookup[Lookup[summary, "momentumSummary", <||>], "generators", {}],
       "tIBP" -> Lookup[Lookup[summary, "timeSummary", <||>], "generators", {}]
       |>,
     {summary, shrinkSummaries}
     ];
   Association[Join[{topEntry}, shrinkEntries]]
   ];


sectorGeneratorCoverageChecks[equations_List, expectedBySector_Association, sectorKeys_List] := Association @ Table[
    Module[
     {sectorEquations, actualQ, actualT, expected = Lookup[expectedBySector, sectorKey, <|"qIBP" -> {}, "tIBP" -> {}|>]},
     sectorEquations = Select[equations, seedEntrySourceSectorKey[#] === sectorKey &];
     actualQ = DeleteDuplicates @ Lookup[Select[sectorEquations, seedEntryIBPClass[#] === "qIBP" &], "generator", {}];
     actualT = DeleteDuplicates @ Lookup[Select[sectorEquations, seedEntryIBPClass[#] === "tIBP" &], "generator", {}];
     sectorKey -> <|
       "actualQGenerators" -> actualQ,
       "actualTGenerators" -> actualT,
       "expectedQGenerators" -> expected["qIBP"],
       "expectedTGenerators" -> expected["tIBP"],
       "qGeneratorCoverageQ" -> TrueQ[canonicalGeneratorStrings[actualQ] === canonicalGeneratorStrings[expected["qIBP"]]],
       "tGeneratorCoverageQ" -> TrueQ[canonicalGeneratorStrings[actualT] === canonicalGeneratorStrings[expected["tIBP"]]]
       |>
     ],
    {sectorKey, sectorKeys}
    ];


makeCanonicalSeedCoverageReport[batch_Association] := Module[
   {classified, summary, sectorKeys, equations, sectorClassChecks, topEquations, topQGenerators, topTGenerators,
    expectedQGenerators, expectedTGenerators, expectedBySector, sectorGeneratorChecks,
    totalClassifiedCount, forbiddenData, reportQ},
   classified = classifyCanonicalSeedBatch[batch];
   summary = Lookup[classified, "summary", <||>];
   sectorKeys = Lookup[Lookup[batch, "sectorMetadataList", {}], "sectorKey", {}];
   equations = Lookup[batch, "equations", {}];
   sectorClassChecks = Association @ Table[
      sectorKey -> <|
        "qIBPCount" -> Lookup[Lookup[summary, sectorKey, <||>], "qIBP", 0],
        "tIBPCount" -> Lookup[Lookup[summary, sectorKey, <||>], "tIBP", 0],
        "hasBothQAndT" -> TrueQ[
          Lookup[Lookup[summary, sectorKey, <||>], "qIBP", 0] > 0 &&
           Lookup[Lookup[summary, sectorKey, <||>], "tIBP", 0] > 0
          ]
        |>,
      {sectorKey, sectorKeys}
      ];
   topEquations = Select[equations, seedEntrySourceSectorKey[#] === "top" &];
   topQGenerators = DeleteDuplicates @ Lookup[Select[topEquations, seedEntryIBPClass[#] === "qIBP" &], "generator", {}];
   topTGenerators = DeleteDuplicates @ Lookup[Select[topEquations, seedEntryIBPClass[#] === "tIBP" &], "generator", {}];
   expectedQGenerators = Lookup[Lookup[batch, "momentumSummary", <||>], "generators", {}];
   expectedTGenerators = Lookup[Lookup[batch, "timeSummary", <||>], "generators", {}];
   expectedBySector = expectedGeneratorsBySector[batch];
   sectorGeneratorChecks = sectorGeneratorCoverageChecks[equations, expectedBySector, sectorKeys];
   totalClassifiedCount = Total[Cases[summary, _Integer, Infinity]];
   forbiddenData = DeleteCases[Flatten[Lookup[equations, "forbiddenNData", {}]], Null];
   reportQ = TrueQ[
     Lookup[batch, "status", Missing["status"]] === "generated" &&
      Lookup[batch, "pendingFeatures", {"missing"}] === {} &&
      Lookup[batch, "forbiddenNData", {"missing"}] === {} &&
      TrueQ[Lookup[batch, "eomCanonicalQ", False]] &&
      TrueQ[And @@ Lookup[equations, "eomCanonicalQ", {False}]] &&
      forbiddenData === {} &&
      totalClassifiedCount === Lookup[batch, "equationCount", Missing["equationCount"]] &&
      Sort[Lookup[classified, "sectorKeys", {}]] === Sort[sectorKeys] &&
      FreeQ[Lookup[classified, "classes", {}], "unknownIBP"] &&
      And @@ Lookup[Values[sectorClassChecks], "hasBothQAndT", {False}] &&
      And @@ Flatten[Lookup[Values[sectorGeneratorChecks], {"qGeneratorCoverageQ", "tGeneratorCoverageQ"}, {False}]] &&
      canonicalGeneratorStrings[topQGenerators] === canonicalGeneratorStrings[expectedQGenerators] &&
      canonicalGeneratorStrings[topTGenerators] === canonicalGeneratorStrings[expectedTGenerators]
     ];
   <|
    "status" -> If[reportQ, "ready", "notReady"],
    "caseName" -> Lookup[batch, "caseName", Missing["caseName"]],
    "passQ" -> reportQ,
    "canonicalSeedReadyQ" -> canonicalSeedReadyQ[batch],
    "sectorKeys" -> sectorKeys,
    "classes" -> Lookup[classified, "classes", {}],
    "classSummary" -> summary,
    "sectorClassChecks" -> sectorClassChecks,
    "sectorGeneratorChecks" -> sectorGeneratorChecks,
    "topQGenerators" -> topQGenerators,
    "topTGenerators" -> topTGenerators,
    "expectedQGenerators" -> expectedQGenerators,
    "expectedTGenerators" -> expectedTGenerators,
    "classifiedEquationCount" -> totalClassifiedCount,
    "equationCount" -> Lookup[batch, "equationCount", Missing["equationCount"]],
    "pendingFeatures" -> Lookup[batch, "pendingFeatures", {}],
    "forbiddenNData" -> Lookup[batch, "forbiddenNData", {}],
    "entryForbiddenNData" -> forbiddenData,
    "eomCanonicalQ" -> Lookup[batch, "eomCanonicalQ", False]
    |>
   ];



(* ::Chapter:: *)
(*seed MMA 保存与读取*)

(* seed batch 是前端产物，保存为 Mathematica 表达式；Kira exporter 只读取 linear-system 数据。 *)

Options[writeSeedBatchMMA] = {OutputDirectory -> None, SeedFileBaseName -> Automatic};


validOutputDirectoryOptionQ[value_] := value === None || value === Automatic || (StringQ[value] && StringLength[value] > 0);


validSeedFileBaseNameQ[value_] := value === Automatic || (StringQ[value] && StringLength[value] > 0);


validateSeedMMAOutputOptions[outputDir_, fileBaseName_] := Module[{issues = {}},
   If[! validOutputDirectoryOptionQ[outputDir],
    AppendTo[issues, <|"code" -> "invalidOutputDirectory", "optionKey" -> "OutputDirectory", "value" -> outputDir, "allowed" -> {"None", "Automatic", "non-empty string"}|>]
    ];
   If[! validSeedFileBaseNameQ[fileBaseName],
    AppendTo[issues, <|"code" -> "invalidSeedFileBaseName", "optionKey" -> "SeedFileBaseName", "value" -> fileBaseName, "allowed" -> {"Automatic", "non-empty string"}|>]
    ];
   <|"status" -> If[issues === {}, "ok", "invalidSeedMMAOutputOptions"], "issues" -> issues|>
   ];


validateSeedBatchForSave[batch_Association] := Module[{issues = {}},
   If[Lookup[batch, "status", Missing["status"]] =!= "generated",
    AppendTo[issues, <|"code" -> "seedBatchNotGenerated", "status" -> Lookup[batch, "status", Missing["status"]]|>]
    ];
   If[! KeyExistsQ[batch, "equations"] || ! ListQ[Lookup[batch, "equations", Missing["equations"]]],
    AppendTo[issues, <|"code" -> "seedBatchMissingEquations"|>]
    ];
   If[! KeyExistsQ[batch, "equationCount"],
    AppendTo[issues, <|"code" -> "seedBatchMissingEquationCount"|>]
    ];
   <|"status" -> If[issues === {}, "ok", "invalidSeedBatch"], "issues" -> issues|>
   ];


writeSeedBatchMMA[batch_Association, OptionsPattern[]] := Module[
   {outputDir = OptionValue[OutputDirectory], fileBaseName = OptionValue[SeedFileBaseName], outputOptionReport, batchReport, file},
   outputOptionReport = validateSeedMMAOutputOptions[outputDir, fileBaseName];
   If[outputOptionReport["status"] =!= "ok",
    Return[<|"status" -> "notWritten", "reason" -> "invalidSeedMMAOutputOptions", "outputOptionValidationReport" -> outputOptionReport|>]
    ];
   batchReport = validateSeedBatchForSave[batch];
   If[batchReport["status"] =!= "ok",
    Return[<|"status" -> "notWritten", "reason" -> "invalidSeedBatch", "seedBatchValidationReport" -> batchReport, "outputOptionValidationReport" -> outputOptionReport|>]
    ];
   If[! StringQ[outputDir], Return[<|"status" -> "notWritten", "reason" -> "OutputDirectory was not requested", "outputOptionValidationReport" -> outputOptionReport|>]];
   If[! DirectoryQ[outputDir], CreateDirectory[outputDir, CreateIntermediateDirectories -> True]];
   If[fileBaseName === Automatic, fileBaseName = Lookup[batch, "caseName", "seed_batch"] <> "_canonical_seed"];
   file = FileNameJoin[{outputDir, fileBaseName <> ".m"}];
   Put[batch, file];
   <|"status" -> "written", "file" -> file, "equationCount" -> Lookup[batch, "equationCount", Missing["equationCount"]]|>
   ];


readSeedBatchMMA[file_String] := If[FileExistsQ[file],
   Get[file],
   <|"status" -> "notRead", "reason" -> "fileNotFound", "file" -> file|>
   ];


(* ::Chapter:: *)
(*Kira user-defined system 导出*)

(* 本章按参考 codebubble 的 reduce_user_defined_system 格式导出。
   Kira exporter 的输入是已经撒点/替换参数后的线性系统数据，不直接消费 seed batch。
   userSystem/ibp.kira 每个非零方程一个 block，list 给目标积分编号，jobs.yaml 调用 Kira。
   默认只返回字符串；只有显式给 OutputDirectory 才写文件。 *)

kiraCoefficientString[expr_] := StringReplace[ToString[expr, InputForm], WhitespaceCharacter .. -> ""];


kiraNonzeroCoefficientRules[coefficientRules_List] := Select[
   (First[#] -> Cancel[Last[#]]) & /@ coefficientRules,
   ! TrueQ[Last[#] === 0] &
   ];


kiraEquationBlock[linearEquation_Association, coefficientRules_List] := Module[
   {nonzeroRules},
   nonzeroRules = kiraNonzeroCoefficientRules[coefficientRules];
   If[nonzeroRules === {}, Return[""]];
   StringRiffle[ToString[First[#]] <> "*(" <> kiraCoefficientString[Last[#]] <> ")" & /@ nonzeroRules, "\n"] <> "\n\n"
   ];


kiraNumericCoefficientSystemQ[linearEquations_List] := Module[
   {coefficients},
   coefficients = Last /@ Flatten[kiraNonzeroCoefficientRules[#["coefficientRules"]] & /@ linearEquations];
   coefficients =!= {} && And @@ (TrueQ[NumericQ[#]] & /@ coefficients)
   ];


linearCoefficientDiagnostics[linearEquations_List] := Module[
   {coefficients},
   coefficients = Last /@ Flatten[kiraNonzeroCoefficientRules[#["coefficientRules"]] & /@ linearEquations];
   <|
    "numericCoefficientSystemQ" -> TrueQ[coefficients =!= {} && And @@ (TrueQ[NumericQ[#]] & /@ coefficients)],
    "coefficientVariables" -> DeleteDuplicates[Variables[coefficients]]
    |>
   ];


kiraAppendNumericDummyQ[setting_, numericSystemQ_] := If[setting === Automatic, TrueQ[numericSystemQ], TrueQ[setting]];


kiraDummyCoefficientString[symbol_] := If[StringQ[symbol], symbol, kiraCoefficientString[symbol]];


kiraDummyEquationBlock[id_Integer, symbol_] := ToString[id] <> "*(" <> kiraDummyCoefficientString[symbol] <> ")\n\n";


kiraTargetIntegralItems[targetSpec_] := Which[
   targetSpec === Automatic || targetSpec === All, Automatic,
   ListQ[targetSpec], targetSpec,
   True, {targetSpec}
   ];


kiraResolveTargetIntegralIDs[linearData_Association, targetSpec_, numericDummyIntegralId_] := Module[
   {maxId = linearData["integralCount"], idRules, items, resolvedPairs, missingItems, ids, invalidIds, targetIDs},
   idRules = Association[linearData["integralRules"]];
   items = kiraTargetIntegralItems[targetSpec];
   If[items === Automatic,
    targetIDs = Range[maxId],
    resolvedPairs = ({#, Which[
          IntegerQ[#], #,
          MatchQ[#, _J], Lookup[idRules, #, Missing["targetIntegralNotInSystem", #]],
          True, Missing["unsupportedTargetIntegral", #]
          ]} &) /@ items;
    missingItems = Cases[resolvedPairs, {item_, _Missing} :> item];
    ids = DeleteDuplicates[Cases[resolvedPairs, {_, id_Integer} :> id]];
    invalidIds = Select[ids, # < 1 || # > maxId &];
    If[missingItems =!= {} || invalidIds =!= {},
     Return[<|"status" -> "invalidTargetIntegrals", "targetSpec" -> targetSpec, "missingTargetItems" -> missingItems, "invalidTargetIDs" -> invalidIds, "maxIntegralID" -> maxId|>]
     ];
    targetIDs = ids
    ];
   If[numericDummyIntegralId =!= None && ! MemberQ[targetIDs, numericDummyIntegralId],
    targetIDs = Append[targetIDs, numericDummyIntegralId]
    ];
   If[targetIDs === {},
    Return[<|"status" -> "invalidTargetIntegrals", "targetSpec" -> targetSpec, "missingTargetItems" -> {}, "invalidTargetIDs" -> {}, "reason" -> "empty target list"|>]
    ];
   <|"status" -> "resolved", "targetSpec" -> targetSpec, "targetIDs" -> targetIDs, "targetIntegralCount" -> Length[targetIDs]|>
   ];


applyKiraCoefficientRulesToLinearEquation[linearEquation_Association, coeffRules_List] := Module[
   {rules, const},
   rules = linearEquation["coefficientRules"] /. coeffRules;
   rules = (First[#] -> Cancel[Last[#]]) & /@ rules;
   const = Cancel[linearEquation["constantTerm"] /. coeffRules];
   Join[linearEquation, <|"coefficientRules" -> rules, "constantTerm" -> const|>]
   ];


validReplacementRuleQ[rule_] := MatchQ[Unevaluated[rule], _Rule | _RuleDelayed];


validateCoefficientRules[coeffRules_] := Module[
   {badPositions},
   If[! ListQ[coeffRules],
    Return[<|"status" -> "invalidCoefficientRules", "reason" -> "coefficient rules must be a list of Rule or RuleDelayed entries", "coefficientRules" -> coeffRules|>]
    ];
   badPositions = Flatten @ Position[Unevaluated[coeffRules], rule_ /; ! validReplacementRuleQ[rule], {1}, Heads -> False];
   If[badPositions === {},
    <|"status" -> "ok", "coefficientRules" -> coeffRules|>,
    <|"status" -> "invalidCoefficientRules", "reason" -> "coefficient rules contain non-rule entries", "badPositions" -> badPositions, "coefficientRules" -> coeffRules|>
    ]
   ];


defaultKiraJobOptions[] := <|
   "RunInitiate" -> True,
   "RunFirefly" -> True,
   "WriteKira2MathJob" -> True,
   "Kira2MathTarget" -> "list",
   "AppendNumericDummyEquation" -> Automatic,
   "NumericDummySymbol" -> "ccc",
   "WriteRunScript" -> True,
   "RunScriptName" -> "run.sh",
   "KiraCommand" -> "kira",
   "KiraParallelJobs" -> 10,
   "RunScriptDos2Unix" -> True,
   "RunScriptCleanup" -> True
   |>;


allowedKiraJobOptionKeys[] := Keys[defaultKiraJobOptions[]];


validKiraJobOptionValueQ[key_, value_] /; MemberQ[{"RunInitiate", "RunFirefly", "WriteKira2MathJob", "WriteRunScript", "RunScriptDos2Unix", "RunScriptCleanup"}, key] := BooleanQ[value];
validKiraJobOptionValueQ["AppendNumericDummyEquation", value_] := value === Automatic || BooleanQ[value];
validKiraJobOptionValueQ["KiraParallelJobs", value_] := IntegerQ[value] && value > 0;
validKiraJobOptionValueQ[key_, value_] /; MemberQ[{"Kira2MathTarget", "NumericDummySymbol", "RunScriptName", "KiraCommand"}, key] := StringQ[value] && value =!= "";
validKiraJobOptionValueQ[_, _] := False;


validateKiraJobOptions[jobOptions_] := Module[
   {raw, unknownKeys, badValueData},
   If[jobOptions === Automatic,
    Return[<|"status" -> "ok", "issues" -> {}|>]
    ];
   raw = Which[
     AssociationQ[jobOptions], jobOptions,
     ListQ[jobOptions], Check[Association[jobOptions], $Failed],
     True, $Failed
     ];
   If[raw === $Failed,
    Return[<|"status" -> "invalidKiraJobOptions", "reason" -> "KiraJobOptions must be Automatic, Association, or rule list", "issues" -> {<|"code" -> "malformedKiraJobOptions", "jobOptions" -> jobOptions|>}|>]
    ];
   unknownKeys = Complement[Keys[raw], allowedKiraJobOptionKeys[]];
   badValueData = KeyValueMap[
     If[MemberQ[allowedKiraJobOptionKeys[], #1] && ! validKiraJobOptionValueQ[#1, #2],
       <|"optionKey" -> #1, "optionValue" -> #2|>,
       Nothing
       ] &,
     raw
     ];
   If[unknownKeys === {} && badValueData === {},
    <|"status" -> "ok", "issues" -> {}|>,
    <|
     "status" -> "invalidKiraJobOptions",
     "reason" -> "KiraJobOptions contain unknown keys or invalid values",
     "unknownKiraJobOptionKeys" -> unknownKeys,
     "malformedKiraJobOptionValues" -> badValueData,
     "allowedKiraJobOptionKeys" -> allowedKiraJobOptionKeys[]
     |>
    ]
   ];


validateKiraOutputDirectory[outputDir_] := If[validOutputDirectoryOptionQ[outputDir],
   <|"status" -> "ok", "issues" -> {}|>,
   <|"status" -> "invalidOutputDirectory", "issues" -> {<|"code" -> "invalidOutputDirectory", "optionKey" -> "OutputDirectory", "value" -> outputDir, "allowed" -> {"None", "Automatic", "non-empty string"}|>}|>
   ];


normalizeKiraJobOptions[Automatic] := defaultKiraJobOptions[];
normalizeKiraJobOptions[opts_Association] := Join[defaultKiraJobOptions[], opts];
normalizeKiraJobOptions[opts_List] := normalizeKiraJobOptions[Association[opts]];
normalizeKiraJobOptions[_] := defaultKiraJobOptions[];


kiraYAMLBool[value_] := If[TrueQ[value], "true", "false"];


kiraJobsYAML[jobOptions_: Automatic] := Module[
   {opts = normalizeKiraJobOptions[jobOptions], text},
   text = "jobs:\n" <>
     "  - reduce_user_defined_system:\n" <>
     "      input_system: {files: [\"userSystem\"], config: false}\n" <>
     "      select_integrals:\n" <>
     "        select_mandatory_list:\n" <>
     "          - [list]\n" <>
     "      run_initiate: " <> kiraYAMLBool[Lookup[opts, "RunInitiate", True]] <> "\n" <>
     "      run_firefly: " <> kiraYAMLBool[Lookup[opts, "RunFirefly", True]] <> "\n";
   If[TrueQ[Lookup[opts, "WriteKira2MathJob", True]],
    text = text <>
      "  - kira2math:\n" <>
      "      target:\n" <>
      "       - [" <> ToString[Lookup[opts, "Kira2MathTarget", "list"]] <> "]\n"
    ];
   text
   ];


kiraRunCommand[opts_Association] := Module[
   {cmd = ToString[Lookup[opts, "KiraCommand", "kira"]], parallel = Lookup[opts, "KiraParallelJobs", 10]},
   If[IntegerQ[parallel] && parallel > 0,
    cmd <> " --parallel=" <> ToString[parallel] <> " jobs.yaml",
    cmd <> " jobs.yaml"
    ]
   ];


kiraRunScript[jobOptions_: Automatic] := Module[
   {opts = normalizeKiraJobOptions[jobOptions], lines = {}},
   If[TrueQ[Lookup[opts, "RunScriptCleanup", True]],
    lines = Join[lines, {
        "rm -f kira.log",
        "rm -f firefly.log",
        "rm -rf results",
        "rm -rf tmp",
        "rm -rf sectormappings",
        "rm -rf firefly_saves",
        "rm -rf ff_save"
        }]
    ];
   If[TrueQ[Lookup[opts, "RunScriptDos2Unix", True]],
    lines = Join[lines, {
        "dos2unix list",
        "dos2unix userSystem/ibp.kira",
        "dos2unix jobs.yaml"
        }]
    ];
   lines = Append[lines, kiraRunCommand[opts]];
   StringRiffle[lines, "\n"] <> "\n"
   ];


makeKiraInputStrings[linearData_Association, coeffRules_ : {}, jobOptions_: Automatic, targetSpec_: Automatic] := Module[
   {linearEquations, badEquations, exportedEquations, ibpText, listText, jobsText, runScriptText, repKira2JText, repJ2KiraText, metadataText,
    normalizedJobOptions, jobOptionReport, coefficientRuleReport, topologyReport, requiredKeys, missingKeys, coefficientDiagnostics, numericCoefficientSystemQ, appendNumericDummyQ,
    numericDummyIntegralId, targetData, targetIntegralCount, kiraBlockCount, numericDummySymbol, rawCoeffRules, normalizedCoeffRules},
   topologyReport = Lookup[linearData, "topologyValidationReport", Missing["NoTopologyValidationReport"]];
   If[Lookup[linearData, "status", "missing"] =!= "generated",
    Return[<|"status" -> "notGenerated", "reason" -> "linear data missing", "topologyValidationReport" -> topologyReport|>]
    ];
   If[topologyValidationErrorQ[topologyReport],
    Return[<|"status" -> "invalidTopology", "reason" -> "topology validation has errors", "topologyValidationReport" -> topologyReport|>]
    ];
   requiredKeys = {"linearEquations", "integralRules", "integralCount", "equationCount"};
   missingKeys = Select[requiredKeys, ! KeyExistsQ[linearData, #] &];
   If[missingKeys =!= {},
    Return[<|"status" -> "notLinearSystem", "reason" -> "Kira exporter expects makeLinearSystemData output", "topologyValidationReport" -> topologyReport, "missingKeys" -> missingKeys|>]
    ];
   jobOptionReport = validateKiraJobOptions[jobOptions];
   If[Lookup[jobOptionReport, "status", "ok"] =!= "ok",
    Return[Join[jobOptionReport, <|"topologyValidationReport" -> topologyReport|>]]
    ];
   rawCoeffRules = coeffRules;
   coefficientRuleReport = validateCoefficientRules[rawCoeffRules];
   If[Lookup[coefficientRuleReport, "status", "ok"] =!= "ok",
    Return[Join[coefficientRuleReport, <|"topologyValidationReport" -> topologyReport|>]]
    ];
   normalizedCoeffRules = normalizeCoefficientRulesForLinearData[rawCoeffRules, linearData];
   linearEquations = applyKiraCoefficientRulesToLinearEquation[#, normalizedCoeffRules] & /@ linearData["linearEquations"];
   badEquations = Select[linearEquations, ! TrueQ[#["linearQ"]] || ! TrueQ[#["constantTerm"] === 0] &];
   If[badEquations =!= {},
    Return[<|"status" -> "notLinear", "topologyValidationReport" -> topologyReport, "badEquationCount" -> Length[badEquations], "badEquations" -> badEquations|>]
    ];
   exportedEquations = Select[linearEquations, kiraNonzeroCoefficientRules[#["coefficientRules"]] =!= {} &];
   If[exportedEquations === {},
    Return[<|"status" -> "emptySystem", "reason" -> "all linear equations are zero after coefficient rules", "topologyValidationReport" -> topologyReport|>]
    ];
   normalizedJobOptions = normalizeKiraJobOptions[jobOptions];
   coefficientDiagnostics = linearCoefficientDiagnostics[exportedEquations];
   numericCoefficientSystemQ = coefficientDiagnostics["numericCoefficientSystemQ"];
   appendNumericDummyQ = kiraAppendNumericDummyQ[Lookup[normalizedJobOptions, "AppendNumericDummyEquation", Automatic], numericCoefficientSystemQ];
   numericDummyIntegralId = If[appendNumericDummyQ, linearData["integralCount"] + 1, None];
   targetData = kiraResolveTargetIntegralIDs[linearData, targetSpec, numericDummyIntegralId];
   If[Lookup[targetData, "status", "missing"] =!= "resolved",
    Return[Join[targetData, <|"topologyValidationReport" -> topologyReport|>]]
    ];
   targetIntegralCount = targetData["targetIntegralCount"];
   kiraBlockCount = Length[exportedEquations] + If[appendNumericDummyQ, 1, 0];
   numericDummySymbol = Lookup[normalizedJobOptions, "NumericDummySymbol", "ccc"];
   ibpText = StringJoin[kiraEquationBlock[#, #["coefficientRules"]] & /@ exportedEquations] <>
     If[appendNumericDummyQ, kiraDummyEquationBlock[numericDummyIntegralId, numericDummySymbol], ""];
   listText = StringRiffle[ToString /@ targetData["targetIDs"], "\n"] <> "\n";
   jobsText = kiraJobsYAML[normalizedJobOptions];
   runScriptText = If[TrueQ[Lookup[normalizedJobOptions, "WriteRunScript", True]], kiraRunScript[normalizedJobOptions], Missing["RunScriptDisabled"]];
   repKira2JText = ToString[InputForm[linearData["integralRules"] /. (j_J -> id_Integer) :> (Tuserweight[id] -> j)]] <> "\n";
   repJ2KiraText = ToString[InputForm[linearData["integralRules"]]] <> "\n";
   metadataText = ToString[InputForm[
       Join[
        KeyDrop[linearData, {"integralList", "integralRules", "linearEquations", "topology"}],
        <|
         "exportedEquationCount" -> Length[exportedEquations],
         "kiraBlockCount" -> kiraBlockCount,
         "targetIntegralCount" -> targetIntegralCount,
         "targetIntegralIDs" -> targetData["targetIDs"],
         "kiraTargetIntegrals" -> targetSpec,
         "numericCoefficientSystemQ" -> numericCoefficientSystemQ,
         "coefficientVariables" -> coefficientDiagnostics["coefficientVariables"],
         "numericDummyAppendedQ" -> appendNumericDummyQ,
         "numericDummyIntegralId" -> numericDummyIntegralId,
         "kiraCoefficientRules" -> normalizedCoeffRules,
         "userKiraCoefficientRules" -> userCoefficientRulesForLinearData[normalizedCoeffRules, linearData],
         "kiraJobOptions" -> normalizedJobOptions
         |>
        ]
       ]] <> "\n";
   <|
    "status" -> "generated",
    "topologyValidationReport" -> topologyReport,
    "ibp.kira" -> ibpText,
    "list" -> listText,
    "jobs.yaml" -> jobsText,
    "runScriptName" -> Lookup[normalizedJobOptions, "RunScriptName", "run.sh"],
    "run.sh" -> runScriptText,
    "result/repkira2J.m" -> repKira2JText,
    "result/repJ2kira.m" -> repJ2KiraText,
    "result/kira_export_metadata.m" -> metadataText,
    "equationCount" -> linearData["equationCount"],
    "exportedEquationCount" -> Length[exportedEquations],
    "kiraBlockCount" -> kiraBlockCount,
    "integralCount" -> linearData["integralCount"],
    "targetIntegralCount" -> targetIntegralCount,
    "targetIntegralIDs" -> targetData["targetIDs"],
    "kiraTargetIntegrals" -> targetSpec,
    "numericCoefficientSystemQ" -> numericCoefficientSystemQ,
    "coefficientVariables" -> coefficientDiagnostics["coefficientVariables"],
    "numericDummyAppendedQ" -> appendNumericDummyQ,
    "numericDummyIntegralId" -> numericDummyIntegralId,
    "kiraCoefficientRulesApplied" -> normalizedCoeffRules,
    "userKiraCoefficientRulesApplied" -> userCoefficientRulesForLinearData[normalizedCoeffRules, linearData]
    |>
   ];


writeKiraInputFiles[outputDir_String, strings_Association] := Module[
   {userSystemDir, resultDir, runScriptName, files},
   userSystemDir = FileNameJoin[{outputDir, "userSystem"}];
   resultDir = FileNameJoin[{outputDir, "result"}];
   If[! DirectoryQ[outputDir], CreateDirectory[outputDir, CreateIntermediateDirectories -> True]];
   If[! DirectoryQ[userSystemDir], CreateDirectory[userSystemDir, CreateIntermediateDirectories -> True]];
   If[! DirectoryQ[resultDir], CreateDirectory[resultDir, CreateIntermediateDirectories -> True]];
   runScriptName = Lookup[strings, "runScriptName", "run.sh"];
   files = <|
     FileNameJoin[{userSystemDir, "ibp.kira"}] -> strings["ibp.kira"],
     FileNameJoin[{outputDir, "list"}] -> strings["list"],
     FileNameJoin[{outputDir, "jobs.yaml"}] -> strings["jobs.yaml"],
     FileNameJoin[{resultDir, "repkira2J.m"}] -> strings["result/repkira2J.m"],
     FileNameJoin[{resultDir, "repJ2kira.m"}] -> strings["result/repJ2kira.m"],
     FileNameJoin[{resultDir, "kira_export_metadata.m"}] -> strings["result/kira_export_metadata.m"]
     |>;
   If[StringQ[Lookup[strings, "run.sh", Missing["NoRunScript"]]],
    files = Join[files, <|FileNameJoin[{outputDir, runScriptName}] -> strings["run.sh"]|>]
    ];
   KeyValueMap[Export[#1, #2, "Text"] &, files];
   Keys[files]
   ];


Options[makeKiraExportData] = {
   OutputDirectory -> None,
   KiraCoefficientRules -> {},
   KiraIntegralOrder -> Automatic,
   KiraTargetIntegrals -> Automatic,
   KiraJobOptions -> Automatic
   };

makeKiraExportData::notlinearinput = "Kira 导出只接受 linear-system 数据，不直接接受 seed batch：`1`。";
makeKiraExportData::badlinear = "linear-system 不能导出 Kira：`1`。";


makeKiraExportData[linearData_Association, OptionsPattern[]] := Module[
   {linearForExport, strings, outputDir, outputDirReport, filesWritten, topologyReport, integralOrderReport},
   topologyReport = Lookup[linearData, "topologyValidationReport", Missing["NoTopologyValidationReport"]];
   outputDir = OptionValue[OutputDirectory];
   outputDirReport = validateKiraOutputDirectory[outputDir];
   If[outputDirReport["status"] =!= "ok",
    Return[<|
      "status" -> "notReady",
      "caseName" -> Lookup[linearData, "caseName", Missing["caseName"]],
      "topologyValidationReport" -> topologyReport,
      "reason" -> "invalidOutputDirectory",
      "kiraInput" -> outputDirReport
      |>]
    ];
   If[! KeyExistsQ[linearData, "linearEquations"],
    Message[makeKiraExportData::notlinearinput, Lookup[linearData, "caseName", Missing["caseName"]]];
    Return[<|
      "status" -> "notReady",
      "caseName" -> Lookup[linearData, "caseName", Missing["caseName"]],
      "topologyValidationReport" -> topologyReport,
      "reason" -> "Kira exporter expects linear-system data; save seed batch as MMA first, then call makeLinearSystemData after numeric/sampling choices"
      |>]
    ];
   integralOrderReport = validateKiraIntegralOrderSpec[OptionValue[KiraIntegralOrder]];
   If[Lookup[integralOrderReport, "status", "ok"] =!= "ok",
    Return[<|"status" -> "notReady", "caseName" -> Lookup[linearData, "caseName", Missing["caseName"]], "topologyValidationReport" -> topologyReport, "reason" -> "invalid KiraIntegralOrder", "linearSystem" -> linearData, "kiraInput" -> integralOrderReport|>]
    ];
   linearForExport = If[ListQ[OptionValue[KiraIntegralOrder]], reorderLinearSystemIntegrals[linearData, OptionValue[KiraIntegralOrder]], linearData];
   strings = makeKiraInputStrings[linearForExport, OptionValue[KiraCoefficientRules], OptionValue[KiraJobOptions], OptionValue[KiraTargetIntegrals]];
   If[Lookup[strings, "status", "missing"] =!= "generated",
    If[! MemberQ[{"invalidKiraJobOptions", "invalidCoefficientRules"}, Lookup[strings, "status", Missing["status"]]],
     Message[makeKiraExportData::badlinear, Lookup[strings, "status", Missing["status"]]]
     ];
    Return[<|"status" -> "notReady", "caseName" -> linearForExport["caseName"], "topologyValidationReport" -> Lookup[linearForExport, "topologyValidationReport", topologyReport], "reason" -> "linear system is not exportable", "linearSystem" -> linearForExport, "kiraInput" -> strings|>]
    ];
   filesWritten = If[StringQ[outputDir], writeKiraInputFiles[outputDir, strings], {}];
   <|
    "status" -> "ready",
    "caseName" -> linearForExport["caseName"],
    "topologyValidationReport" -> Lookup[linearForExport, "topologyValidationReport", topologyReport],
    "linearSystem" -> linearForExport,
    "kiraInput" -> strings,
    "equationCount" -> Lookup[linearForExport, "equationCount", Missing["equationCount"]],
    "exportedEquationCount" -> Lookup[strings, "exportedEquationCount", Missing["exportedEquationCount"]],
    "kiraBlockCount" -> Lookup[strings, "kiraBlockCount", Missing["kiraBlockCount"]],
    "integralCount" -> Lookup[linearForExport, "integralCount", Missing["integralCount"]],
    "kiraOrderingReport" -> Lookup[linearForExport, "kiraOrderingReport", <||>],
    "manualIntegralOrderReport" -> Lookup[linearForExport, "manualIntegralOrderReport", <||>],
    "targetIntegralCount" -> Lookup[strings, "targetIntegralCount", Missing["targetIntegralCount"]],
    "targetIntegralIDs" -> Lookup[strings, "targetIntegralIDs", Missing["targetIntegralIDs"]],
    "kiraTargetIntegrals" -> Lookup[strings, "kiraTargetIntegrals", Missing["kiraTargetIntegrals"]],
    "numericCoefficientSystemQ" -> Lookup[strings, "numericCoefficientSystemQ", Missing["numericCoefficientSystemQ"]],
    "coefficientVariables" -> Lookup[strings, "coefficientVariables", Missing["coefficientVariables"]],
    "numericDummyAppendedQ" -> Lookup[strings, "numericDummyAppendedQ", Missing["numericDummyAppendedQ"]],
    "numericDummyIntegralId" -> Lookup[strings, "numericDummyIntegralId", Missing["numericDummyIntegralId"]],
    "outputDirectory" -> outputDir,
    "writeFilesQ" -> StringQ[outputDir],
    "filesWritten" -> filesWritten
    |>
   ];


(* ::Chapter:: *)
(*端到端轻量工作流入口*)

(* 本章只把 topology、canonical seed、linear-system 和 Kira 文件导出按 gate 串起来。
   它不运行 Kira reduction，也不改变底层 seed/linear/export 函数的物理逻辑。 *)

Options[makeIBPWorkflowData] = Join[
   Options[makeCanonicalSeedBatch],
   {
    LinearSystemMode -> "symbolic",
    CoefficientRules -> Automatic,
    KiraOrdering -> Automatic,
    OutputDirectory -> None,
    ExportKira -> False,
    KiraCoefficientRules -> Automatic,
    KiraIntegralOrder -> Automatic,
    KiraTargetIntegrals -> Automatic,
    KiraJobOptions -> Automatic
    }
   ];


validWorkflowOutputDirectoryQ[value_] := validOutputDirectoryOptionQ[value];


validateIBPWorkflowOptions[exportKira_, outputDirectory_] := Module[{issues = {}},
   If[! BooleanQ[exportKira],
    AppendTo[issues, <|"code" -> "invalidExportKiraValue", "optionKey" -> "ExportKira", "value" -> exportKira, "allowed" -> {True, False}|>]
    ];
   If[! validWorkflowOutputDirectoryQ[outputDirectory],
    AppendTo[issues, <|"code" -> "invalidOutputDirectory", "optionKey" -> "OutputDirectory", "value" -> outputDirectory, "allowed" -> {"None", "Automatic", "non-empty string"}|>]
    ];
   <|"status" -> If[issues === {}, "ok", "invalidWorkflowOptions"], "issues" -> issues|>
   ];


makeIBPWorkflowData[caseOrTopo_Association, opts : OptionsPattern[]] := Module[
   {topo, seedOpts, batch, linearOpts, linearMode, coeffRules, linearData,
     exportQ, kiraCoeffRules, kiraOpts, kiraData, seedCoverageReport, topologyReport,
     allowedLinearModes, workflowOptionReport, inputReport, numericRequirementReport, missingExternalInvariants, missingVertexEnergies, missingLineParameters},
   If[! parsedTopologyQ[caseOrTopo] && caseInputPreflightErrorQ[caseOrTopo],
    inputReport = caseInputRequirementReport[caseOrTopo];
    topologyReport = caseInputErrorReport[caseOrTopo];
    Return[<|
      "status" -> "notReady",
      "stage" -> "topology",
      "reason" -> If[inputReport["missingRequiredKeys"] =!= {}, "missingRequiredCaseKeys", "malformedCaseInput"],
      "missingRequiredKeys" -> inputReport["missingRequiredKeys"],
      "malformedInputIssues" -> inputReport["malformedInputIssues"],
      "inputRequirementReport" -> inputReport,
      "topologyValidationReport" -> topologyReport
      |>]
    ];
   topo = If[KeyExistsQ[caseOrTopo, "lines"] && KeyExistsQ[caseOrTopo, "nL"], caseOrTopo, parseTopology[caseOrTopo]];
   topologyReport = topologyValidationReport[topo];
   numericRequirementReport = numericRuleRequirementReport[topo];
   linearMode = OptionValue[LinearSystemMode];
   allowedLinearModes = {"symbolic", "sampled", "numeric"};
   If[! MemberQ[allowedLinearModes, linearMode],
     Return[<|
       "status" -> "notReady",
       "stage" -> "linear",
      "reason" -> "invalidLinearSystemMode",
      "linearSystemMode" -> linearMode,
      "allowedLinearSystemModes" -> allowedLinearModes,
      "topology" -> topo,
      "topologyValidationReport" -> topologyReport,
      "numericRuleRequirementReport" -> numericRequirementReport
       |>]
     ];
   workflowOptionReport = validateIBPWorkflowOptions[OptionValue[ExportKira], OptionValue[OutputDirectory]];
   If[workflowOptionReport["status"] =!= "ok",
    Return[<|
      "status" -> "notReady",
      "stage" -> "workflow",
      "reason" -> "invalidWorkflowOptions",
      "workflowOptionValidationReport" -> workflowOptionReport,
      "topology" -> topo,
      "topologyValidationReport" -> topologyReport,
      "numericRuleRequirementReport" -> numericRequirementReport
      |>]
    ];
   missingExternalInvariants = numericRequirementReport["missingExternalInvariants"];
   If[linearMode === "numeric" && missingExternalInvariants =!= {},
    Return[<|
      "status" -> "notReady",
      "stage" -> "linear",
      "reason" -> "numericRulesMissingExternalInvariants",
      "missingExternalInvariants" -> missingExternalInvariants,
      "topology" -> topo,
      "topologyValidationReport" -> topologyReport,
      "numericRuleRequirementReport" -> numericRequirementReport
      |>]
    ];
   missingVertexEnergies = numericRequirementReport["missingVertexEnergies"];
   If[linearMode === "numeric" && missingVertexEnergies =!= {},
    Return[<|
      "status" -> "notReady",
      "stage" -> "linear",
      "reason" -> "numericRulesMissingVertexEnergies",
      "missingVertexEnergies" -> missingVertexEnergies,
      "topology" -> topo,
      "topologyValidationReport" -> topologyReport,
      "numericRuleRequirementReport" -> numericRequirementReport
      |>]
    ];
   missingLineParameters = numericRequirementReport["missingLineParameters"];
   If[linearMode === "numeric" && missingLineParameters =!= {},
    Return[<|
      "status" -> "notReady",
      "stage" -> "linear",
      "reason" -> "numericRulesMissingLineParameters",
      "missingLineParameters" -> missingLineParameters,
      "topology" -> topo,
      "topologyValidationReport" -> topologyReport,
      "numericRuleRequirementReport" -> numericRequirementReport
      |>]
    ];
   seedOpts = FilterRules[{opts}, Options[makeCanonicalSeedBatch]];
   batch = makeCanonicalSeedBatch[topo, Sequence @@ seedOpts];
   seedCoverageReport = makeCanonicalSeedCoverageReport[batch];
   If[Lookup[batch, "status", "missing"] =!= "generated" || ! TrueQ[canonicalSeedReadyQ[batch]] || ! TrueQ[Lookup[seedCoverageReport, "passQ", False]],
    Return[<|"status" -> "notReady", "stage" -> "seed", "topology" -> topo, "topologyValidationReport" -> topologyReport, "numericRuleRequirementReport" -> numericRequirementReport, "seedBatch" -> KeyDrop[batch, "equations"], "seedCoverageReport" -> seedCoverageReport|>]
   ];
   linearOpts = FilterRules[{opts}, Options[makeLinearSystemData]];
   coeffRules = OptionValue[CoefficientRules];
   linearData = If[linearMode === "sampled" || linearMode === "numeric",
     makeSampledLinearSystemData[batch, topo, Sequence @@ linearOpts, CoefficientRules -> coeffRules],
     makeLinearSystemData[batch, topo, Sequence @@ linearOpts]
     ];
   If[Lookup[linearData, "status", "missing"] =!= "generated" || ! TrueQ[Lookup[linearData, "linearQ", False]],
    Return[<|"status" -> "notReady", "stage" -> "linear", "topology" -> topo, "topologyValidationReport" -> topologyReport, "numericRuleRequirementReport" -> numericRequirementReport, "seedBatch" -> KeyDrop[batch, "equations"], "linearSystem" -> linearData|>]
    ];
   If[linearMode === "numeric" && ! TrueQ[Lookup[linearData, "numericCoefficientSystemQ", False]],
    Return[<|
      "status" -> "notReady",
      "stage" -> "linear",
      "reason" -> "nonNumericCoefficients",
      "coefficientVariables" -> Lookup[linearData, "coefficientVariables", {}],
      "topology" -> topo,
      "topologyValidationReport" -> topologyReport,
      "numericRuleRequirementReport" -> numericRequirementReport,
      "seedBatch" -> KeyDrop[batch, "equations"],
      "linearSystem" -> linearData
      |>]
    ];
   exportQ = TrueQ[OptionValue[ExportKira]] || StringQ[OptionValue[OutputDirectory]];
   kiraCoeffRules = If[OptionValue[KiraCoefficientRules] === Automatic,
     If[linearMode === "sampled" || linearMode === "numeric", {}, topo["numericRules"]],
     OptionValue[KiraCoefficientRules]
     ];
   kiraOpts = FilterRules[
     {
      OutputDirectory -> OptionValue[OutputDirectory],
      KiraCoefficientRules -> kiraCoeffRules,
      KiraIntegralOrder -> OptionValue[KiraIntegralOrder],
      KiraTargetIntegrals -> OptionValue[KiraTargetIntegrals],
      KiraJobOptions -> OptionValue[KiraJobOptions]
      },
     Options[makeKiraExportData]
     ];
   kiraData = If[exportQ, makeKiraExportData[linearData, Sequence @@ kiraOpts], <|"status" -> "skipped"|>];
   <|
    "status" -> If[exportQ, Lookup[kiraData, "status", "missing"], "ready"],
    "stage" -> If[exportQ, "kira", "linear"],
    "topology" -> topo,
    "topologyValidationReport" -> topologyReport,
    "numericRuleRequirementReport" -> numericRequirementReport,
    "seedBatch" -> batch,
    "seedCoverageReport" -> seedCoverageReport,
    "linearSystem" -> linearData,
    "kiraExport" -> kiraData
   |>
   ];


readinessIssueCodes[report_] := If[AssociationQ[report], Lookup[Lookup[report, "issues", {}], "code", {}], {}];


readinessStatusFromQ[q_] := If[TrueQ[q], "ready", "notReady"];


Options[makeIBPReadinessReport] = Options[makeIBPWorkflowData];


makeIBPReadinessReport[caseOrTopo_Association, opts : OptionsPattern[]] := Module[
   {workflow, topologyReport, seedBatch, seedReport, linearData, kiraData, exportQ, topologyReadyQ, seedReadyQ,
     linearReadyQ, kiraReadyQ, numericRequirementReport, workflowOptionReport},
   workflow = makeIBPWorkflowData[caseOrTopo, opts];
   workflowOptionReport = Lookup[workflow, "workflowOptionValidationReport", validateIBPWorkflowOptions[OptionValue[ExportKira], OptionValue[OutputDirectory]]];
   topologyReport = Lookup[workflow, "topologyValidationReport", <||>];
   numericRequirementReport = Lookup[workflow, "numericRuleRequirementReport", Lookup[topologyReport, "numericRuleRequirementReport", <||>]];
   seedBatch = Lookup[workflow, "seedBatch", <||>];
   seedReport = Lookup[workflow, "seedCoverageReport", <||>];
   linearData = Lookup[workflow, "linearSystem", <||>];
   kiraData = Lookup[workflow, "kiraExport", <|"status" -> "skipped"|>];
   exportQ = workflowOptionReport["status"] === "ok" && (TrueQ[OptionValue[ExportKira]] || (StringQ[OptionValue[OutputDirectory]] && StringLength[OptionValue[OutputDirectory]] > 0));
   topologyReadyQ = AssociationQ[topologyReport] && ! topologyValidationErrorQ[topologyReport];
   seedReadyQ = AssociationQ[seedReport] && Lookup[seedReport, "status", Missing["status"]] === "ready";
   linearReadyQ = AssociationQ[linearData] && Lookup[linearData, "status", Missing["status"]] === "generated" && TrueQ[Lookup[linearData, "linearQ", False]];
   kiraReadyQ = If[exportQ, AssociationQ[kiraData] && Lookup[kiraData, "status", Missing["status"]] === "ready", Missing["NotRequested"]];
   <|
    "status" -> Lookup[workflow, "status", Missing["status"]],
    "stage" -> Lookup[workflow, "stage", Missing["stage"]],
    "caseName" -> Lookup[Lookup[workflow, "topology", <||>], "name", Lookup[workflow, "caseName", Missing["caseName"]]],
    "topologyReadyQ" -> topologyReadyQ,
    "seedReadyQ" -> seedReadyQ,
    "linearReadyQ" -> linearReadyQ,
    "kiraRequestedQ" -> exportQ,
    "kiraReadyQ" -> kiraReadyQ,
    "topologyStatus" -> Lookup[topologyReport, "status", Missing["status"]],
    "topologyIssueCodes" -> readinessIssueCodes[topologyReport],
    "inputRequirementReport" -> Lookup[workflow, "inputRequirementReport", Lookup[topologyReport, "inputRequirementReport", <||>]],
    "missingRequiredKeys" -> Lookup[workflow, "missingRequiredKeys", {}],
    "malformedInputIssues" -> Lookup[workflow, "malformedInputIssues", Lookup[Lookup[workflow, "inputRequirementReport", <||>], "malformedInputIssues", {}]],
    "seedStatus" -> Lookup[seedBatch, "status", Missing["notGenerated"]],
    "seedCoverageStatus" -> Lookup[seedReport, "status", Missing["notGenerated"]],
    "linearStatus" -> Lookup[linearData, "status", Missing["notGenerated"]],
    "kiraStatus" -> Lookup[kiraData, "status", "skipped"],
    "equationCount" -> Lookup[seedBatch, "equationCount", Missing["notGenerated"]],
    "linearEquationCount" -> Lookup[linearData, "equationCount", Missing["notGenerated"]],
    "integralCount" -> Lookup[linearData, "integralCount", Missing["notGenerated"]],
    "exportedEquationCount" -> Lookup[kiraData, "exportedEquationCount", Missing["notGenerated"]],
     "linearSystemMode" -> OptionValue[LinearSystemMode],
     "workflowOptionValidationReport" -> workflowOptionReport,
     "numericCoefficientSystemQ" -> Lookup[linearData, "numericCoefficientSystemQ", Missing["notGenerated"]],
    "coefficientVariables" -> DeleteDuplicates[Flatten[{
        Lookup[workflow, "coefficientVariables", {}],
        Lookup[linearData, "coefficientVariables", {}]
        }]],
    "numericRuleRequirementReport" -> numericRequirementReport,
    "missingExternalInvariants" -> Lookup[workflow, "missingExternalInvariants", {}],
    "missingVertexEnergies" -> Lookup[workflow, "missingVertexEnergies", {}],
    "missingLineParameters" -> Lookup[workflow, "missingLineParameters", {}],
    "pendingFeatures" -> DeleteDuplicates[Flatten[{
        Lookup[topologyReport, "pendingFeatures", {}],
        Lookup[seedBatch, "pendingFeatures", {}],
        Lookup[seedReport, "pendingFeatures", {}],
        Lookup[linearData, "pendingFeatures", {}]
        }]],
    "workflowReason" -> Lookup[workflow, "reason", None],
    "readinessByStage" -> <|
      "topology" -> readinessStatusFromQ[topologyReadyQ],
      "seed" -> readinessStatusFromQ[seedReadyQ],
      "linear" -> readinessStatusFromQ[linearReadyQ],
      "kira" -> If[exportQ, readinessStatusFromQ[kiraReadyQ], "notRequested"]
      |>,
    "workflowSummary" -> KeyDrop[workflow, {"topology", "seedBatch", "linearSystem", "kiraExport"}]
    |>
   ];


(* ::Chapter:: *)
(*线性系统中间格式*)

(* 本章把 seed 方程转成后端可消费的线性系统数据。
   这里只做积分抽取、编号和逐项系数收集，不做求解、排序优化或 Kira 文件语法假设。 *)

integralObjectsInExpression[expr_] := DeleteDuplicates[Cases[expr, _J, {0, Infinity}]];


integralObjectsInBatch[batch_Association] := DeleteDuplicates[
   Flatten[integralObjectsInExpression /@ Lookup[Lookup[batch, "equations", {}], "equation", {}]]
   ];


makeIntegralIndex[integrals_List] := AssociationThread[integrals, Range[Length[integrals]]];


linearTermData[term_, integralIndex_Association] := Module[
   {integrals, integral, coeff},
   integrals = Cases[term, _J, {0, Infinity}];
   Which[
    Length[integrals] == 0,
    <|"kind" -> "constant", "term" -> term|>,
    Length[DeleteDuplicates[integrals]] == 1,
    integral = First[DeleteDuplicates[integrals]];
    coeff = Cancel[term/integral];
    If[FreeQ[coeff, _J] && KeyExistsQ[integralIndex, integral],
     <|"kind" -> "linear", "id" -> integralIndex[integral], "integral" -> integral, "coefficient" -> coeff|>,
     <|"kind" -> "nonlinear", "term" -> term|>
     ],
    True,
    <|"kind" -> "nonlinear", "term" -> term|>
    ]
   ];


combineLinearCoefficientRules[linearTerms_List] := Normal @ Merge[
    (Rule[#["id"], #["coefficient"]] & /@ linearTerms),
    Total
    ];

reindexLinearEquation[eq_Association, oldIdToNewId_Association] := Module[
   {rules},
   rules = Select[
     (Lookup[oldIdToNewId, First[#], Missing["DroppedIntegral"]] -> Last[#]) & /@ Lookup[eq, "coefficientRules", {}],
     Head[First[#]] =!= Missing &
     ];
   Join[eq, <|"coefficientRules" -> Normal@Merge[rules, Total]|>]
   ];


reorderLinearSystemIntegrals[linearData_Association, integralOrder_List] := Module[
   {oldIntegrals, requested, newIntegrals, oldRules, oldIdToIntegral, newIndex, oldIdToNewId,
    newLinearEquations, metadataList, orderingSpec, manualOrderReport},
   If[Lookup[linearData, "status", "missing"] =!= "generated" || ! KeyExistsQ[linearData, "integralList"], Return[linearData]];
   oldIntegrals = linearData["integralList"];
   requested = normaliseIntegralOrder[integralOrder, oldIntegrals];
   newIntegrals = Join[requested, Select[oldIntegrals, ! MemberQ[requested, #] &]];
   oldRules = Association[linearData["integralRules"]];
   oldIdToIntegral = Association[Reverse /@ Normal[oldRules]];
   newIndex = makeIntegralIndex[newIntegrals];
   oldIdToNewId = Association @ KeyValueMap[#1 -> newIndex[#2] &, oldIdToIntegral];
   newLinearEquations = reindexLinearEquation[#, oldIdToNewId] & /@ linearData["linearEquations"];
   metadataList = Lookup[linearData, "sectorMetadataList", {}];
   orderingSpec = Join[Lookup[linearData, "kiraOrdering", <||>], <|"ManualIntegralOrder" -> requested|>];
   manualOrderReport = <|
     "requestedIntegrals" -> integralOrder,
     "matchedIntegrals" -> requested,
     "missingIntegralOrderItems" -> DeleteDuplicates @ missingIntegralOrderItems[integralOrder, oldIntegrals],
     "allRequestedIntegralsMatchedQ" -> TrueQ[missingIntegralOrderItems[integralOrder, oldIntegrals] === {}]
     |>;
   Join[linearData, <|
     "integralList" -> newIntegrals,
     "integralRules" -> Normal[newIndex],
     "kiraOrdering" -> orderingSpec,
     "kiraOrderingReport" -> kiraOrderingMatchReport[orderingSpec, newIntegrals],
     "manualIntegralOrderReport" -> manualOrderReport,
     "integralSortKeys" -> (integralSortKey[#, orderingSpec, metadataList] & /@ newIntegrals),
     "integralMetadata" -> integralMetadataList[newIntegrals, metadataList, orderingSpec],
     "linearEquations" -> newLinearEquations
     |>]
   ];


linearizeSeedEquation[entry_Association, integralIndex_Association] := Module[
   {terms, termData, linearPieces, constantTerms, nonlinearTerms},
   terms = linearTerms[Lookup[entry, "equation", 0]];
   termData = linearTermData[#, integralIndex] & /@ terms;
   linearPieces = Select[termData, #["kind"] === "linear" &];
   constantTerms = Lookup[Select[termData, #["kind"] === "constant" &], "term", {}];
   nonlinearTerms = Lookup[Select[termData, #["kind"] === "nonlinear" &], "term", {}];
   Join[
    KeyDrop[entry, "equation"],
    <|
     "coefficientRules" -> combineLinearCoefficientRules[linearPieces],
     "constantTerm" -> Total[constantTerms],
     "nonlinearTerms" -> nonlinearTerms,
     "linearQ" -> TrueQ[nonlinearTerms === {}]
     |>
    ]
   ];


Options[makeLinearSystemData] = {KiraOrdering -> Automatic};


makeLinearSystemData[batch_Association, topoSpec_: Automatic, OptionsPattern[]] := Module[
   {topo, integrals, integralIndex, equations, linearEquations, coefficientDiagnostics,
    metadataList, metadata, orderingSpec, orderingReport, seedCoverageReport, topologyReport},
   topo = normalizeTopologySpec[topoSpec];
   topologyReport = Lookup[batch, "topologyValidationReport", Missing["NoTopologyValidationReport"]];
   If[MatchQ[topologyReport, _Missing] && parsedTopologyQ[topo],
    topologyReport = topologyValidationReport[topo]
    ];
   If[Lookup[batch, "status", "missing"] =!= "generated",
    Return[<|"status" -> "notGenerated", "sourceStatus" -> Lookup[batch, "status", Missing["status"]], "topologyValidationReport" -> topologyReport|>]
    ];
   If[topologyValidationErrorQ[topologyReport],
    Return[<|"status" -> "invalidTopology", "caseName" -> Lookup[batch, "caseName", Missing["caseName"]], "topologyValidationReport" -> topologyReport|>]
    ];
   If[Lookup[batch, "pendingFeatures", {}] =!= {},
    Return[<|
      "status" -> "notReady",
      "caseName" -> Lookup[batch, "caseName", Missing["caseName"]],
      "topologyValidationReport" -> topologyReport,
      "reason" -> "pendingFeatures",
      "pendingFeatures" -> Lookup[batch, "pendingFeatures", {}]
      |>]
    ];
   If[Lookup[batch, "forbiddenNData", {}] =!= {},
    Return[<|
      "status" -> "notReady",
      "caseName" -> Lookup[batch, "caseName", Missing["caseName"]],
      "topologyValidationReport" -> topologyReport,
      "reason" -> "forbiddenNData",
      "forbiddenNData" -> Lookup[batch, "forbiddenNData", {}]
      |>]
    ];
   If[! KeyExistsQ[batch, "completeCanonicalQ"],
    Return[<|
      "status" -> "notReady",
      "caseName" -> Lookup[batch, "caseName", Missing["caseName"]],
      "topologyValidationReport" -> topologyReport,
      "reason" -> "notCanonicalSeedBatch",
      "comment" -> "linear/Kira stages require makeCanonicalSeedBatch output with all-sector qIBP/tIBP coverage; momentum-only or time-only seed batches are seed-level regression data only"
      |>]
    ];
   seedCoverageReport = makeCanonicalSeedCoverageReport[batch];
   If[! TrueQ[Lookup[seedCoverageReport, "passQ", False]],
    Return[<|
      "status" -> "notReady",
      "caseName" -> Lookup[batch, "caseName", Missing["caseName"]],
      "topologyValidationReport" -> topologyReport,
      "reason" -> "seedCoverageReportNotReady",
      "seedCoverageReport" -> seedCoverageReport
      |>]
    ];
   orderingReport = validateKiraOrderingSpec[OptionValue[KiraOrdering]];
   If[Lookup[orderingReport, "status", "ok"] =!= "ok",
    Return[<|"status" -> "notReady", "caseName" -> Lookup[batch, "caseName", Missing["caseName"]], "topologyValidationReport" -> topologyReport, "reason" -> "invalidKiraOrdering", "kiraOrderingValidationReport" -> orderingReport|>]
    ];
   metadataList = batchSectorMetadataList[batch, topo];
   orderingSpec = resolveKiraOrderingSpec[batch, topo, OptionValue[KiraOrdering]];
   integrals = sortIntegralsForKira[integralObjectsInBatch[batch], orderingSpec, metadataList];
   integralIndex = makeIntegralIndex[integrals];
   equations = Lookup[batch, "equations", {}];
   linearEquations = linearizeSeedEquation[#, integralIndex] & /@ equations;
   coefficientDiagnostics = linearCoefficientDiagnostics[linearEquations];
   metadata = If[metadataList === {}, Missing["NoSectorMetadata"], First[metadataList]];
   <|
    "status" -> "generated",
    "caseName" -> Lookup[batch, "caseName", Missing["caseName"]],
    "topology" -> topo,
    "integralCount" -> Length[integrals],
    "equationCount" -> Length[equations],
    "integralList" -> integrals,
    "integralRules" -> Normal[integralIndex],
    "kiraOrdering" -> orderingSpec,
    "kiraOrderingReport" -> kiraOrderingMatchReport[orderingSpec, integrals],
    "integralSortKeys" -> (integralSortKey[#, orderingSpec, metadataList] & /@ integrals),
    "integralMetadata" -> integralMetadataList[integrals, metadataList, orderingSpec],
    "sectorMetadata" -> metadata,
    "sectorMetadataList" -> metadataList,
    "topologyValidationReport" -> topologyReport,
    "seedCoverageReport" -> seedCoverageReport,
    "linearEquations" -> linearEquations,
    "linearQ" -> And @@ (Lookup[linearEquations, "linearQ"]),
    "nonlinearEquationCount" -> Count[Lookup[linearEquations, "linearQ"], False],
    "numericCoefficientSystemQ" -> coefficientDiagnostics["numericCoefficientSystemQ"],
    "coefficientVariables" -> coefficientDiagnostics["coefficientVariables"]
    |>
   ];


Options[applyCoefficientRulesToLinearSystem] = {CoefficientRules -> {}};


applyCoefficientRulesToLinearSystem[linearData_Association, OptionsPattern[]] := Module[
   {rawRules = OptionValue[CoefficientRules], rules, ruleReport, linearEquations, coefficientDiagnostics},
   If[Lookup[linearData, "status", "missing"] =!= "generated" || ! KeyExistsQ[linearData, "linearEquations"], Return[linearData]];
   ruleReport = validateCoefficientRules[rawRules];
   If[Lookup[ruleReport, "status", "ok"] =!= "ok",
    Return[Join[linearData, <|"status" -> "notReady", "reason" -> "invalidCoefficientRules", "coefficientRuleValidationReport" -> ruleReport|>]]
    ];
   rules = normalizeCoefficientRulesForLinearData[rawRules, linearData];
   linearEquations = applyKiraCoefficientRulesToLinearEquation[#, rules] & /@ linearData["linearEquations"];
   coefficientDiagnostics = linearCoefficientDiagnostics[linearEquations];
   Join[linearData, <|
     "coefficientRulesApplied" -> rules,
     "userCoefficientRulesApplied" -> userCoefficientRulesForLinearData[rules, linearData],
     "linearEquations" -> linearEquations,
     "linearQ" -> And @@ (Lookup[linearEquations, "linearQ"]),
     "nonlinearEquationCount" -> Count[Lookup[linearEquations, "linearQ"], False],
     "numericCoefficientSystemQ" -> coefficientDiagnostics["numericCoefficientSystemQ"],
     "coefficientVariables" -> coefficientDiagnostics["coefficientVariables"]
     |>]
   ];


Options[makeSampledLinearSystemData] = Join[Options[makeLinearSystemData], {CoefficientRules -> Automatic}];


makeSampledLinearSystemData[batch_Association, topoSpec_: Automatic, OptionsPattern[]] := Module[
   {topo, linearData, rules},
   topo = normalizeTopologySpec[topoSpec];
   linearData = makeLinearSystemData[batch, topo, KiraOrdering -> OptionValue[KiraOrdering]];
   If[Lookup[linearData, "status", "missing"] =!= "generated", Return[linearData]];
   rules = If[OptionValue[CoefficientRules] === Automatic,
     If[parsedTopologyQ[topo], Lookup[topo, "numericRules", {}], {}],
     OptionValue[CoefficientRules]
     ];
   applyCoefficientRulesToLinearSystem[linearData, CoefficientRules -> rules]
   ];

Options[makeMomentumIBPLinearSystem] = Options[makeMomentumIBPSeedBatch];
makeMomentumIBPLinearSystem[topoSpec_Association, opts : OptionsPattern[]] := Module[{topo, batch},
   topo = normalizeTopologySpec[topoSpec];
   batch = makeMomentumIBPSeedBatch[topo, opts];
   If[Lookup[batch, "status", "missing"] =!= "generated", Return[batch]];
   makeLinearSystemData[batch, topo]
   ];


(* ::Chapter:: *)
(*示例 case 与结构检查*)

(* 本章保留 bubble 作为输入样例，同时增加一个两圈 ISP toy case。
   检查目标不是物理公式正确性，而是验证替换输入拓扑后结构层仍能工作。 *)


bubbleMassiveCase = <|
   "name" -> "bubbleMassive",
   "vertexData" -> {{1, "+"}, {2, "+"}},
   "lineData" -> {
     <|"id" -> 1, "endpoints" -> {1, 2}, "momentum" -> q1, "nu" -> nu1, "bbType" -> "h", "massType" -> "massive"|>,
     <|"id" -> 2, "endpoints" -> {1, 2}, "momentum" -> q1 - k, "nu" -> nu2, "bbType" -> "h", "massType" -> "massive"|>
     },
   "extLegs" -> {{B, 1, p1}, {B, 2, p2}},
   "loopMomenta" -> {q1},
   "externalMomenta" -> {k},
   "ispData" -> {}
   |>;


bubbleMasslessCase = <|
   "name" -> "bubbleMasslessMergedTheta",
   "vertexData" -> {{1, "+"}, {2, "+"}},
   "lineData" -> {
     <|"id" -> 1, "endpoints" -> {1, 2}, "momentum" -> q1, "nu" -> 0, "bbType" -> "exp", "massType" -> "massless"|>,
     <|"id" -> 2, "endpoints" -> {1, 2}, "momentum" -> q1 - k, "nu" -> 0, "bbType" -> "exp", "massType" -> "massless"|>
     },
   "extLegs" -> {{B, 1, p1}, {B, 2, p2}},
   "loopMomenta" -> {q1},
   "externalMomenta" -> {k},
   "ispData" -> {},
   "numericRules" -> {dim -> 3, kk[1, 1] -> 5},
   "sampleDiscreteRules" -> {
     {n[1] -> 0, n[2] -> 0},
     {n[1] -> 1, n[2] -> 0},
     {n[1] -> 0, n[2] -> 1}
     },
   "seedRanges" -> <|"a" -> {-1, 1}, "b" -> {-2, 2}, "sampleOnly" -> True|>
   |>;


masslessCrossBubbleCase = <|
   "name" -> "bubbleMasslessCrossNoTheta",
   "vertexData" -> {{1, "+"}, {2, "-"}},
   "lineData" -> {
     <|"id" -> 1, "endpoints" -> {1, 2}, "momentum" -> q1, "nu" -> 0, "bbType" -> "exp", "massType" -> "massless"|>,
     <|"id" -> 2, "endpoints" -> {1, 2}, "momentum" -> q1 - k, "nu" -> 0, "bbType" -> "exp", "massType" -> "massless"|>
     },
   "extLegs" -> {{B, 1, p1}, {B, 2, p2}},
   "loopMomenta" -> {q1},
   "externalMomenta" -> {k},
   "ispData" -> {},
   "numericRules" -> {dim -> 3, kk[1, 1] -> 5},
   "sampleDiscreteRules" -> {{}},
   "seedRanges" -> <|"a" -> {-1, 1}, "b" -> {-2, 2}, "sampleOnly" -> True|>
   |>;


mixedBubbleCase = <|
   "name" -> "mixedBubbleMassiveMassless",
   "vertexData" -> {{1, "+"}, {2, "+"}},
   "lineData" -> {
     <|"id" -> 1, "endpoints" -> {1, 2}, "momentum" -> q1, "nu" -> nuM, "bbType" -> "h", "massType" -> "massive", "skType" -> "++"|>,
     <|"id" -> 2, "endpoints" -> {1, 2}, "momentum" -> q1 - k, "nu" -> 0, "bbType" -> "exp", "massType" -> "massless", "skType" -> "++"|>
     },
   "extLegs" -> {{B, 1, p1}, {B, 2, p2}},
   "loopMomenta" -> {q1},
   "externalMomenta" -> {k},
   "ispData" -> {},
   "numericRules" -> {dim -> 3, kk[1, 1] -> 5, nuM -> 2, p1 -> 7, p2 -> 11},
   "sampleDiscreteRules" -> {
     {n[1, 1] -> 0, n[1, 2] -> 0, n[2] -> 0},
     {n[1, 1] -> 1, n[1, 2] -> 0, n[2] -> 1}
     },
   "seedRanges" -> <|"a" -> {-1, 1}, "b" -> {-2, 2}, "sampleOnly" -> True|>
   |>;


massiveCrossBubbleCase = <|
   "name" -> "massiveCrossBubbleGate",
   "vertexData" -> {{1, "+"}, {2, "-"}},
   "lineData" -> {
     <|"id" -> 1, "endpoints" -> {1, 2}, "momentum" -> q1, "nu" -> nuM, "bbType" -> "h", "massType" -> "massive"|>,
     <|"id" -> 2, "endpoints" -> {1, 2}, "momentum" -> q1 - k, "nu" -> nuM, "bbType" -> "h", "massType" -> "massive"|>
     },
   "extLegs" -> {{B, 1, p1}, {B, 2, p2}},
   "loopMomenta" -> {q1},
   "externalMomenta" -> {k},
   "ispData" -> {},
   "numericRules" -> {dim -> 3, kk[1, 1] -> 5, nuM -> 2},
   "sampleDiscreteRules" -> {
     {n[1, 1] -> 0, n[1, 2] -> 0, n[2, 1] -> 0, n[2, 2] -> 0},
     {n[1, 1] -> 1, n[1, 2] -> 0, n[2, 1] -> 0, n[2, 2] -> 1}
     },
   "seedRanges" -> <|"a" -> {-1, 1}, "b" -> {-2, 2}, "sampleOnly" -> True|>
   |>;


mixedTriangleCase = <|
   "name" -> "mixedTriangleTwoMassiveOneMassless",
   "vertexData" -> {{1, "+"}, {2, "+"}, {3, "+"}},
   "lineData" -> {
     <|"id" -> 1, "endpoints" -> {1, 2}, "momentum" -> q1, "nu" -> nuM, "bbType" -> "h", "massType" -> "massive", "skType" -> "++"|>,
     <|"id" -> 2, "endpoints" -> {2, 3}, "momentum" -> q1 - k1, "nu" -> nuM, "bbType" -> "h", "massType" -> "massive", "skType" -> "++"|>,
     <|"id" -> 3, "endpoints" -> {3, 1}, "momentum" -> q1 + k2, "nu" -> 0, "bbType" -> "exp", "massType" -> "massless", "skType" -> "++"|>
     },
   "extLegs" -> {{B, 1, p1}, {B, 2, p2}, {B, 3, p3}},
   "loopMomenta" -> {q1},
   "externalMomenta" -> {k1, k2},
   "ispData" -> {},
   "numericRules" -> {dim -> 3, kk[1, 1] -> 5, kk[1, 2] -> -1, kk[2, 2] -> 7, nuM -> 2},
   "sampleDiscreteRules" -> {
     {n[1, 1] -> 0, n[1, 2] -> 0, n[2, 1] -> 0, n[2, 2] -> 0, n[3] -> 0},
     {n[1, 1] -> 1, n[1, 2] -> 0, n[2, 1] -> 0, n[2, 2] -> 0, n[3] -> 1},
     {n[1, 1] -> 0, n[1, 2] -> 1, n[2, 1] -> 1, n[2, 2] -> 0, n[3] -> 0}
     },
   "seedRanges" -> <|"a" -> {-1, 1}, "b" -> {-2, 2}, "sampleOnly" -> True|>
   |>;


masslessBoxCase = <|
   "name" -> "masslessBoxTopologyReplacement",
   "vertexData" -> {{1, "+"}, {2, "+"}, {3, "+"}, {4, "+"}},
   "lineData" -> {
     <|"id" -> 1, "endpoints" -> {1, 2}, "momentum" -> q1, "nu" -> 0, "bbType" -> "exp", "massType" -> "massless", "skType" -> "++"|>,
     <|"id" -> 2, "endpoints" -> {2, 3}, "momentum" -> q1 - k1, "nu" -> 0, "bbType" -> "exp", "massType" -> "massless", "skType" -> "++"|>,
     <|"id" -> 3, "endpoints" -> {3, 4}, "momentum" -> q1 - k1 - k2, "nu" -> 0, "bbType" -> "exp", "massType" -> "massless", "skType" -> "++"|>,
     <|"id" -> 4, "endpoints" -> {4, 1}, "momentum" -> q1 + k3, "nu" -> 0, "bbType" -> "exp", "massType" -> "massless", "skType" -> "++"|>
     },
   "extLegs" -> {{B, 1, p1}, {B, 2, p2}, {B, 3, p3}, {B, 4, p4}},
   "loopMomenta" -> {q1},
   "externalMomenta" -> {k1, k2, k3},
   "ispData" -> {},
   "numericRules" -> {dim -> 3, kk[1, 1] -> 5, kk[1, 2] -> -1, kk[1, 3] -> 2, kk[2, 2] -> 7, kk[2, 3] -> -3, kk[3, 3] -> 11, p1 -> 7, p2 -> 11, p3 -> 13, p4 -> 17},
   "sampleDiscreteRules" -> {
     {n[1] -> 0, n[2] -> 0, n[3] -> 0, n[4] -> 0},
     {n[1] -> 1, n[2] -> 0, n[3] -> 1, n[4] -> 0},
     {n[1] -> 0, n[2] -> 1, n[3] -> 0, n[4] -> 1}
     },
   "seedRanges" -> <|"a" -> {-1, 1}, "b" -> {-2, 2}, "sampleOnly" -> True|>
   |>;



mixedSunriseCase = <|
   "name" -> "sunriseOneMassiveTwoMasslessPerLineMergedTheta",
   "vertexData" -> {{1, "+"}, {2, "+"}},
   "lineData" -> {
     <|"id" -> 1, "endpoints" -> {1, 2}, "momentum" -> q1, "nu" -> nuM, "bbType" -> "h", "massType" -> "massive", "skType" -> "++"|>,
     <|"id" -> 2, "endpoints" -> {1, 2}, "momentum" -> q2, "nu" -> 0, "bbType" -> "exp", "massType" -> "massless", "skType" -> "++"|>,
     <|"id" -> 3, "endpoints" -> {1, 2}, "momentum" -> q1 - q2 - k, "nu" -> 0, "bbType" -> "exp", "massType" -> "massless", "skType" -> "++"|>
     },
   "extLegs" -> {{B, 1, p1}, {B, 2, p2}},
   "loopMomenta" -> {q1, q2},
   "externalMomenta" -> {k},
   "ispData" -> {
     {ispQ1K, sp[q1, k], {0, 1}},
     {ispQ2K, sp[q2, k], {0, 1}}
     },
   "numericRules" -> {dim -> 3, kk[1, 1] -> 5, nuM -> 2},
   "sampleDiscreteRules" -> {
     {n[1, 1] -> 0, n[1, 2] -> 0, n[2] -> 0, n[3] -> 0},
     {n[1, 1] -> 1, n[1, 2] -> 0, n[2] -> 1, n[3] -> 0},
     {n[1, 1] -> 0, n[1, 2] -> 1, n[2] -> 0, n[3] -> 1}
     },
   "seedRanges" -> <|"a" -> {-1, 1}, "b" -> {-2, 2}, "isp" -> {0, 1}, "sampleOnly" -> True|>,
   "masslessBundleMode" -> "perLineMergedTheta"
   |>;

twoLoopISPCase = <|
   "name" -> "twoLoopISPtoy",
   "vertexData" -> {{1, "+"}, {2, "+"}},
   "lineData" -> {
     <|"id" -> 1, "endpoints" -> {1, 2}, "momentum" -> q1, "nu" -> nu1, "bbType" -> "h", "massType" -> "massive"|>,
     <|"id" -> 2, "endpoints" -> {1, 2}, "momentum" -> q2, "nu" -> nu2, "bbType" -> "h", "massType" -> "massive"|>,
     <|"id" -> 3, "endpoints" -> {1, 2}, "momentum" -> q1 - q2, "nu" -> nu3, "bbType" -> "h", "massType" -> "massive"|>
     },
   "extLegs" -> {{B, 1, p1}, {B, 2, p2}},
   "loopMomenta" -> {q1, q2},
   "externalMomenta" -> {k},
   "ispData" -> {
     {ispQ1K, qk[1, 1], {0, 2}},
     {ispQ2K, qk[2, 1], {0, 2}}
     }
   |>;


summarizeCase[case_Association] := Module[
   {topo, baseIntegral, sampleIntegrals, spData, gens, momentumGenCount,
    discreteCount, seedTemplateCount},
   topo = parseTopology[case];
   baseIntegral = makeBaseIntegral[topo];
   discreteCount = discreteStateCount[topo];
   sampleIntegrals = sampleDiscreteIntegrals[baseIntegral, topo];
   spData = makeScalarProductData[topo];
   gens = makeIBPGenerators[topo];
   momentumGenCount = Count[Lookup[gens, "type"], "momentum"];
   seedTemplateCount = Length[gens];
   <|
    "name" -> topo["name"],
    "nV" -> topo["nV"],
    "nE" -> topo["nE"],
    "nL" -> topo["nL"],
    "nK" -> topo["nK"],
    "packTypes" -> Lookup[topo["lines"], "packType"],
    "linePacks" -> makeLinePacks[topo],
    "baseIntegral" -> baseIntegral,
    "discreteStateCount" -> discreteCount,
    "sampleDiscreteRules" -> topo["sampleDiscreteRules"],
    "sampleIntegrals" -> sampleIntegrals,
    "seedTemplateCount" -> seedTemplateCount,
    "maxExpandedSeedCount" -> discreteCount seedTemplateCount,
    "generatorCount" -> Length[gens],
    "generatorList" -> gens,
    "momentumGeneratorCount" -> momentumGenCount,
    "expectedMomentumGeneratorCount" -> expectedMomentumGeneratorCount[topo],
    "scalarProducts" -> spData["scalarProducts"],
    "zExprs" -> spData["zExprs"],
    "numericRules" -> userNumericRules[topo],
    "externalInvariantNamingReport" -> externalInvariantNamingReport[topo],
    "vertexEnergyNamingReport" -> vertexEnergyNamingReport[topo],
    "numericZExprs" -> (spData["internalZExprs"] /. topo["numericRules"]),
    "seedRanges" -> topo["seedRanges"],
    "validationReport" -> topologyValidationReport[topo],
    "masslessBundleCandidates" -> masslessBundleCandidates[topo],
    "structuralNeededISPCount" -> spData["structuralNeededISPCount"],
    "ispCoverageQ" -> spData["coverageQ"],
    "ispIndependentQ" -> spData["independentQ"],
    "ispCountQ" -> spData["structuralCountQ"],
    "repSP2Z" -> spData["repSP2Z"]
    |>
   ];


runStructureExamples[] := Module[
   {caseSummaries, summaryValue, structureChecks, summaryFile},
   caseSummaries = summarizeCase /@ {
      bubbleMassiveCase,
      bubbleMasslessCase,
      masslessCrossBubbleCase,
      mixedBubbleCase,
      massiveCrossBubbleCase,
      mixedTriangleCase,
      masslessBoxCase,
      mixedSunriseCase,
      twoLoopISPCase
      };
   summaryValue[index_, key_] := Lookup[Part[caseSummaries, index], key];
   structureChecks = <|
     "bubbleMassiveDiscreteStateCount" -> (summaryValue[1, "discreteStateCount"] === 16),
     "bubbleMasslessDiscreteStateCount" -> (summaryValue[2, "discreteStateCount"] === 4),
     "masslessCrossPackTypes" -> (summaryValue[3, "packTypes"] === {"masslessCross", "masslessCross"}),
     "masslessCrossDiscreteStateCount" -> (summaryValue[3, "discreteStateCount"] === 1),
     "mixedBubbleDiscreteStateCount" -> (summaryValue[4, "discreteStateCount"] === 8),
     "mixedBubbleMomentumGeneratorCount" -> (summaryValue[4, "momentumGeneratorCount"] === 2),
     "massiveCrossPackTypes" -> (summaryValue[5, "packTypes"] === {"massiveCross", "massiveCross"}),
     "massiveCrossDiscreteStateCount" -> (summaryValue[5, "discreteStateCount"] === 16),
     "mixedTriangleDiscreteStateCount" -> (summaryValue[6, "discreteStateCount"] === 32),
     "mixedTriangleMomentumGeneratorCount" -> (summaryValue[6, "momentumGeneratorCount"] === 3),
     "masslessBoxDiscreteStateCount" -> (summaryValue[7, "discreteStateCount"] === 16),
     "masslessBoxMomentumGeneratorCount" -> (summaryValue[7, "momentumGeneratorCount"] === 4),
     "masslessBoxValidationOK" -> (summaryValue[7, "validationReport"]["status"] === "ok"),
     "mixedSunriseDiscreteStateCount" -> (summaryValue[8, "discreteStateCount"] === 16),
     "mixedSunriseMomentumGeneratorCount" -> (summaryValue[8, "momentumGeneratorCount"] === 6),
     "mixedSunriseISPCount" -> TrueQ[summaryValue[8, "ispCountQ"]],
     "twoLoopMomentumGeneratorCount" -> (summaryValue[9, "momentumGeneratorCount"] === 6),
     "twoLoopISPCount" -> TrueQ[summaryValue[9, "ispCountQ"]]
     |>;
   summaryFile = FileNameJoin[{baseDir, "004_general_structure_summary.m"}];
   Put[caseSummaries, summaryFile];
   <|"summaries" -> caseSummaries, "checks" -> structureChecks, "summaryFile" -> summaryFile|>
   ];


(* 默认加载只定义函数和示例输入；需要检查时显式调用 runStructureExamples[]。 *)
