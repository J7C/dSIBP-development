(* ::Package:: *)
(* 本文件是 dS IBP package 的通用生成器骨架。
   目标是先把 topology-driven 的结构层做实：拓扑解析、传播子 metadata、统一 J 指标包、
   离散态枚举、完整圈动量 IBP 生成元列表、标量积/ISP 覆盖性验证。
   当前文件生成 momentum seed、time-core seed 与受保护的自动 shrink-sector seed；EOM、有方向的 per-line massless 单 n 规则与 massive/massless theta boundary shrink 已作为 seed 门禁接入，并提供 backend-neutral linear-system 与 Kira serializer。
   008 修正 massive ++ Wronskian theta-boundary 的 Vpm 符号，并加入用户 symmetryRules 的原子化单次应用接口。
   009 进一步按每个 J 的 shrunk packs 重建目标顶点映射，修正跨 sector 的 massless coincident n=1 canonical。
   010 增加 dtau/dqq/dqk 与 rep2innerform/rep2outform/rep2Integrand 公开 API；底层物理公式继续复用 009 原子模块。
   011 增加 P,Q,T,W 函数系统编译层；缺省 h 取 T=IdentityMatrix[2]、WT=W_h，Hankel 作为独立 preset。
   012 增加共同-theta odd-subset contact、contact 可达 sector、massless shrink 幂次修正与 massive coincidence canonical。
   013 只新增 pure time-IBP/tree 表示、loop-time 投影、通用迭代矩阵与直接 dlog DE；标准 package 和交互工程化留到 014。
   性能原则：默认只定义函数和示例输入，不自动运行检查；验证必须是 seed/metadata 层或代数赋值后的小检查。 *)

(* 加载主线脚本不得清空用户 Global` 上下文；开发时需要彻底重载应使用新 kernel。 *)


(* ::Chapter:: *)
(*环境与通用工具*)

(* 本章只解析脚本目录并定义小工具函数。加载 package 不改变用户当前工作目录；输出路径由调用者显式决定。 *)

baseDir = If[StringQ[$InputFileName] && $InputFileName =!= "",
   DirectoryName[$InputFileName],
   If[TrueQ[$Notebooks],
    With[{nd = Quiet[NotebookDirectory[]]},
     If[StringQ[nd] && nd =!= $Failed, nd, Directory[]]
     ],
    Directory[]
    ]
   ];


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
   "name", "extLegs", "externalMomenta", "externalInvariantRules", "rawExternalInvariantRules",
   "externalLegMomenta", "externalLegInvariantRules", "rawExternalLegInvariantRules",
   "kinematicRules",
   "ispData", "vertexEnergies", "activeVertexIds",
   "fixedAVertexValues", "numericRules", "rawNumericRules", "sampleDiscreteRules", "seedPreset", "seedRanges",
   "generatorSeedRanges", "seedOptions", "zeroPointRules", "shrinkPrefactorRules", "symmetryRules", "thetaBoundarySignOffset", "kiraOrdering"
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


(* 每条生成元覆盖记录都显式携带 sector、现有 generator label 与变量值域。
   ranges 允许只覆盖部分连续变量；未列出的变量继续使用统一 seedRanges。 *)
generatorSeedRangeEntryShapeIssues[entry_, index_] := Module[
   {required = {"sectorKey", "generator", "ranges"}, missing, ranges, badRangePositions},
   If[! AssociationQ[entry],
    Return[{<|"entryIndex" -> index, "reason" -> "entry must be an Association", "entry" -> entry|>}]
    ];
   missing = Complement[required, Keys[entry]];
   If[missing =!= {},
    Return[{<|"entryIndex" -> index, "reason" -> "missing required keys", "missingKeys" -> missing|>}]
    ];
   ranges = entry["ranges"];
   If[! StringQ[entry["sectorKey"]] || ! ListQ[entry["generator"]] || ! ListQ[ranges],
    Return[{<|"entryIndex" -> index, "reason" -> "sectorKey must be a string and generator/ranges must be lists"|>}]
    ];
   badRangePositions = Flatten @ Position[
      ranges,
      rule_ /; ! MatchQ[Unevaluated[rule], (_Rule | _RuleDelayed)] || ! validIndexRangeSpecQ[Last[rule]],
      {1},
      Heads -> False
      ];
   If[badRangePositions === {},
    {},
    {<|"entryIndex" -> index, "reason" -> "ranges must contain index -> integer-range rules", "badRangePositions" -> badRangePositions|>}
    ]
   ];


generatorSeedRangesShapeIssues[data_] := If[
   ! ListQ[data],
   {<|"reason" -> "generatorSeedRanges must be a list of Associations", "value" -> data|>},
   Flatten[MapIndexed[generatorSeedRangeEntryShapeIssues[#1, First[#2]] &, data], 1]
   ];


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
   {issues = {}, vertexData, lineData, loopMomenta, externalMomenta, ispData, seedRanges, generatorSeedRanges, seedOptions, badVertexPositions,
    badLineShapePositions, lineMissingKeyData, badEndpointData, badISPShapePositions, ispMissingKeyData,
    sampleDiscreteRules, sampleRuleShapeIssues, generatorRangeShapeIssues, symmetryRules, badSymmetryRulePositions},
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
   If[KeyExistsQ[case, "generatorSeedRanges"],
    generatorSeedRanges = case["generatorSeedRanges"];
    generatorRangeShapeIssues = generatorSeedRangesShapeIssues[generatorSeedRanges];
    If[generatorRangeShapeIssues =!= {},
     AppendTo[issues, <|"severity" -> "error", "code" -> "malformedGeneratorSeedRanges", "issues" -> generatorRangeShapeIssues|>]
     ]
    ];
   If[KeyExistsQ[case, "seedOptions"],
    seedOptions = case["seedOptions"];
    If[! AssociationQ[seedOptions],
     AppendTo[issues, <|"severity" -> "error", "code" -> "malformedSeedOptions", "reason" -> "seedOptions must be an Association"|>]
     ]
    ];
   If[KeyExistsQ[case, "symmetryRules"],
    symmetryRules = case["symmetryRules"];
    If[! ListQ[symmetryRules],
     AppendTo[issues, <|"severity" -> "error", "code" -> "malformedSymmetryRules", "reason" -> "symmetryRules must be a list of Rule or RuleDelayed entries"|>],
     badSymmetryRulePositions = Flatten @ Position[
        symmetryRules,
        rule_ /; ! validDiscreteReplacementRuleQ[rule],
        {1},
        Heads -> False
        ];
     If[badSymmetryRulePositions =!= {},
      AppendTo[issues, <|"severity" -> "error", "code" -> "malformedSymmetryRules", "badPositions" -> badSymmetryRulePositions|>]
      ]
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


(* ::Section:: *)
(*特殊函数系统编译*)

functionSystemZeroQ[expr_] := TrueQ[Quiet[FullSimplify[Together[expr] == 0]]];


functionSystemAdditiveTerms[expr_] := Module[{expanded = Expand[expr]},
   Which[
    functionSystemZeroQ[expanded], {},
    Head[expanded] === Plus, List @@ expanded,
    True, {expanded}
    ]
   ];


functionSystemMonomialData[term_, variable_] := Module[{factors, power, coefficient},
   factors = If[Head[term] === Times, List @@ term, {term}];
   power = Total[Replace[
      factors,
      {
       factor_ /; SameQ[factor, variable] :> 1,
       HoldPattern[Power[base_, exponent_]] /; SameQ[base, variable] :> exponent,
       _ -> 0
       },
      {1}
      ]];
   coefficient = Quiet[FullSimplify[term/variable^power]];
   If[FreeQ[coefficient, variable],
    <|"coefficient" -> coefficient, "xPower" -> power|>,
    Missing["NotFiniteLaurentMonomial", term]
    ]
   ];


compileDerivativeTerms[at_, variable_] := Catch[
   Module[{entries = {}, data, grouped},
    Do[
     Do[
      Do[
       data = functionSystemMonomialData[term, variable];
       If[Head[data] === Missing || ! IntegerQ[data["xPower"]], Throw[$Failed, derivativeCompileFailure]];
       AppendTo[entries, Join[
         <|"sourceState" -> i - 1, "targetState" -> j - 1|>,
         data
         ]],
       {term, functionSystemAdditiveTerms[at[[i, j]]]}
       ],
      {j, 2}
      ],
     {i, 2}
     ];
    grouped = GroupBy[entries, {#["sourceState"], #["targetState"], #["xPower"]} &];
    KeyValueMap[
     <|
       "sourceState" -> #1[[1]], "targetState" -> #1[[2]], "xPower" -> #1[[3]],
       "coefficient" -> Quiet[FullSimplify[Total[Lookup[#2, "coefficient"]]]]
       |> &,
     grouped
     ]
    ],
   derivativeCompileFailure
   ];


compileShrinkTerms[wt_, variable_, spec_Association] := Module[
   {rawTerms, data, powers, integerPowers, bShifts, zeroPointShifts, commonZeroPointShift},
   rawTerms = functionSystemAdditiveTerms[wt];
   If[rawTerms === {}, Return[$Failed]];
   data = functionSystemMonomialData[#, variable] & /@ rawTerms;
   If[AnyTrue[data, Head[#] === Missing &], Return[$Failed]];
   powers = Lookup[data, "xPower"];
   If[KeyExistsQ[spec, "shrinkBShift"] || KeyExistsQ[spec, "shrinkZeroPointShift"],
    If[Length[data] =!= 1 || ! KeyExistsQ[spec, "shrinkBShift"] || ! KeyExistsQ[spec, "shrinkZeroPointShift"], Return[$Failed]];
    bShifts = {spec["shrinkBShift"]};
    zeroPointShifts = {spec["shrinkZeroPointShift"]},
    integerPowers = Quiet[FullSimplify[# /. Thread[Variables[{#}] -> 0]]] & /@ powers;
    If[AnyTrue[integerPowers, ! IntegerQ[#] &], Return[$Failed]];
    bShifts = -integerPowers;
    zeroPointShifts = MapThread[Quiet[FullSimplify[-#1 - #2]] &, {powers, bShifts}]
    ];
   If[AnyTrue[bShifts, ! IntegerQ[#] &], Return[$Failed]];
   commonZeroPointShift = First[zeroPointShifts];
   If[AnyTrue[Rest[zeroPointShifts], ! functionSystemZeroQ[# - commonZeroPointShift] &], Return[$Failed]];
   <|
    "terms" -> MapThread[
      Join[#1, <|"coefficient" -> -#1["coefficient"], "bShift" -> #2, "zeroPointShift" -> #3|>] &,
      {data, bShifts, zeroPointShifts}
      ],
    "zeroPointShift" -> commonZeroPointShift
    |>
   ];


functionSystemPreset[preset_String, line_Association] := Module[
   {variable = x, nuValue = Lookup[line, "nu", nu], prefactor},
   prefactor = Lookup[line, "shrinkPrefactor", (4 I/Pi) Exp[Pi Im[nuValue]]];
   Switch[preset,
    "h",
    <|
     "preset" -> "h", "variable" -> variable,
     "P" -> (2 nuValue + 1)/variable, "Q" -> 1,
     "T" -> IdentityMatrix[2],
     "W" -> -prefactor variable^(-2 nuValue - 1), "WT" -> Automatic,
     "shrinkBShift" -> 1, "shrinkZeroPointShift" -> 2 nuValue
     |>,
    "H",
    <|
     "preset" -> "H", "variable" -> variable,
     "P" -> 1/variable, "Q" -> 1 - nuValue^2/variable^2,
     "T" -> IdentityMatrix[2],
     "W" -> -prefactor/variable, "WT" -> Automatic,
     "shrinkBShift" -> 1, "shrinkZeroPointShift" -> 0
     |>,
    _,
    Missing["UnknownFunctionSystemPreset", preset]
    ]
   ];


legacyFunctionSystem[line_Association, coefficients_List] := Module[
   {variable = x, c1, c2, prefactor},
   {c1, c2} = coefficients[[1 ;; 2]];
   prefactor = Lookup[line, "shrinkPrefactor", (4 I/Pi) Exp[Pi Im[Lookup[line, "nu", nu]]]];
   <|
    "preset" -> "legacyEOMCoefficients", "variable" -> variable,
    "P" -> c1/variable, "Q" -> c2, "T" -> IdentityMatrix[2],
    "W" -> -prefactor variable^(-c1), "WT" -> Automatic,
    "shrinkBShift" -> 1, "shrinkZeroPointShift" -> c1 - 1
    |>
   ];


normalizeLineFunctionSystem[line_Association] := Module[{explicit, bbType, coefficients},
   explicit = Lookup[line, "functionSystem", Automatic];
   bbType = Lookup[line, "bbType", "h"];
   Which[
    AssociationQ[explicit], explicit,
    MemberQ[{"h", "H"}, explicit], functionSystemPreset[explicit, line],
    explicit =!= Automatic, Missing["MalformedFunctionSystem", explicit],
    MemberQ[{"h", "H"}, bbType], functionSystemPreset[bbType, line],
    KeyExistsQ[line, "eomCoefficients"] && ListQ[line["eomCoefficients"]] && Length[line["eomCoefficients"]] >= 2,
    legacyFunctionSystem[line, line["eomCoefficients"]],
    ListQ[bbType] && Length[bbType] >= 2, legacyFunctionSystem[line, bbType],
    True, Missing["UnknownFunctionSystemPreset", bbType]
    ]
   ];


compileFunctionSystem[spec_Association] := Module[
   {required = {"P", "Q", "W"}, missing, variable, p, q, t, w, explicitWT, a0, at, wt,
    detT, derivativeTerms, shrinkData, issues = {}},
   missing = Complement[required, Keys[spec]];
   If[missing =!= {}, Return[<|"status" -> "invalid", "issues" -> {<|"code" -> "missingFunctionSystemKeys", "missingKeys" -> missing|>}|>]];
   variable = Lookup[spec, "variable", x];
   p = spec["P"];
   q = spec["Q"];
   t = Replace[Lookup[spec, "T", Automatic], Automatic -> IdentityMatrix[2]];
   w = spec["W"];
   explicitWT = Lookup[spec, "WT", Automatic];
   If[! MatrixQ[t] || Dimensions[t] =!= {2, 2},
    Return[<|"status" -> "invalid", "issues" -> {<|"code" -> "functionSystemTNot2x2", "T" -> t|>}|>]
    ];
   detT = Quiet[FullSimplify[Det[t]]];
   If[functionSystemZeroQ[detT],
    Return[<|"status" -> "invalid", "issues" -> {<|"code" -> "functionSystemTSingular", "T" -> t|>}|>]
    ];
   a0 = {{0, 1}, {-q, -p}};
   at = Quiet[FullSimplify[D[t, variable].Inverse[t] + t.a0.Inverse[t]]];
   wt = Quiet[FullSimplify[detT w]];
   If[! functionSystemZeroQ[D[w, variable] + p w],
    AppendTo[issues, <|"code" -> "functionSystemWInconsistent", "residual" -> Quiet[FullSimplify[D[w, variable] + p w]]|>]
    ];
   If[explicitWT =!= Automatic && ! functionSystemZeroQ[explicitWT - wt],
    AppendTo[issues, <|"code" -> "functionSystemWTInconsistent", "expectedWT" -> wt, "providedWT" -> explicitWT|>]
    ];
   If[! functionSystemZeroQ[D[wt, variable]/wt - Tr[at]],
    AppendTo[issues, <|"code" -> "functionSystemTraceInconsistent", "residual" -> Quiet[FullSimplify[D[wt, variable]/wt - Tr[at]]]|>]
    ];
   derivativeTerms = compileDerivativeTerms[at, variable];
   If[derivativeTerms === $Failed,
    AppendTo[issues, <|"code" -> "functionSystemDerivativeNotFiniteLaurent", "AT" -> at|>]
    ];
   shrinkData = compileShrinkTerms[wt, variable, spec];
   If[shrinkData === $Failed,
    AppendTo[issues, <|"code" -> "functionSystemWTNotFiniteCompatibleLaurent", "WT" -> wt|>]
    ];
   If[issues =!= {}, Return[<|"status" -> "invalid", "issues" -> issues|>]];
   <|
    "status" -> "compiled", "input" -> Join[spec, <|"variable" -> variable, "T" -> t|>],
    "variable" -> variable, "P" -> p, "Q" -> q, "T" -> t, "W" -> w,
    "A0" -> a0, "AT" -> at, "WT" -> wt,
    "derivativeTerms" -> derivativeTerms,
    "shrinkTerms" -> shrinkData["terms"],
    "shrinkZeroPointShift" -> shrinkData["zeroPointShift"]
    |>
   ];


compileFunctionSystem[data_Association] /; KeyExistsQ[data, "endpoints"] := Module[{spec = normalizeLineFunctionSystem[data]},
   If[Head[spec] === Missing,
    <|"status" -> "invalid", "issues" -> {<|"code" -> "invalidLineFunctionSystem", "value" -> spec|>}|>,
    compileFunctionSystem[spec]
    ]
   ];


(* 补齐每条线的默认 metadata。thetaConvention 固定为 mergedTwoTheta。
   endpoints 是有序输入；对 masslessFull，第一端点定义单 n=1 的反对称方向。 *)
completeLineMetadata[line_, vertexSignAssoc_] := Module[
   {endpoints, referenceEndpoints, massType, skType, state, packType, metadata, functionSpec, compiled},
   endpoints = line["endpoints"];
   referenceEndpoints = Lookup[line, "originalEndpoints", endpoints];
   massType = Lookup[line, "massType", "massive"];
   skType = Lookup[line, "skType", inferSKType[endpoints, vertexSignAssoc]];
   state = Lookup[line, "state", "full"];
   packType = Lookup[line, "packType", inferPackType[massType, skType, state]];
   metadata = Join[
     line,
    <|
     "massType" -> massType,
     "skType" -> skType,
     "state" -> state,
     "thetaConvention" -> "mergedTwoTheta",
     "packType" -> packType,
     "masslessN1ReferenceEndpoint" -> If[packType === "masslessFull", referenceEndpoints[[1]], Missing["NotApplicable"]],
     "masslessN1OppositeEndpoint" -> If[packType === "masslessFull", referenceEndpoints[[2]], Missing["NotApplicable"]]
      |>
     ];
   If[massType =!= "massive", Return[metadata]];
   functionSpec = normalizeLineFunctionSystem[metadata];
   compiled = If[Head[functionSpec] === Missing,
     <|"status" -> "invalid", "issues" -> {<|"code" -> "invalidLineFunctionSystem", "value" -> functionSpec|>}|>,
     compileFunctionSystem[functionSpec]
     ];
   Join[metadata, <|
     "functionSystem" -> Lookup[compiled, "input", Lookup[metadata, "functionSystem", Missing["InvalidFunctionSystem"]]],
     "compiledFunctionSystem" -> compiled
     |>]
   ];


(* 将一个 case 解析为通用拓扑对象。externalMomenta 必须给出独立外动量基。 *)
parseTopology::missingkeys = "case 缺少必需字段：`1`。";
parseTopology::badinput = "case 输入 preflight 失败：`1`。";
parseTopology::badfunction = "massive line 的函数系统编译失败：`1`。";


parseTopology[case_Association] := Module[
   {vertexData, vertexIds, vertexSignAssoc, rawLines, lines, badFunctionLines, loopMomenta,
   externalMomenta, rawExternalInvariantRules, externalInvariantRules, externalLegMomenta,
    rawExternalLegInvariantRules, externalLegInvariantRules, kinematicRules, kinematicAudit,
    ispData, nV, nE, nL, nK, bMatrix, vertexLines,
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
   badFunctionLines = Select[
     MapIndexed[Join[<|"lineIndex" -> First[#2], "lineId" -> Lookup[#1, "id", Missing["NoLineId"]]|>, Lookup[#1, "compiledFunctionSystem", <||>]] &, lines],
     KeyExistsQ[#, "status"] && #["status"] =!= "compiled" &
     ];
   If[badFunctionLines =!= {},
    Message[parseTopology::badfunction, Lookup[badFunctionLines, {"lineIndex", "lineId", "issues"}]];
    Return[$Failed]
    ];
   loopMomenta = case["loopMomenta"];
   externalMomenta = Lookup[case, "externalMomenta", {}];
   externalLegMomenta = Lookup[case, "externalLegMomenta", {}];
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
   topoContext = <|"loopMomenta" -> loopMomenta, "externalMomenta" -> externalMomenta,
     "externalLegMomenta" -> externalLegMomenta, "lines" -> lines,
     "vertexEnergies" -> Lookup[case, "vertexEnergies", <||>], "extLegs" -> Lookup[case, "extLegs", {}],
     "nL" -> nL, "nK" -> nK|>;
   kinematicRules = Lookup[case, "kinematicRules", Automatic];
   kinematicAudit = resolveKinematicRulesForCase[case, topoContext];
   rawExternalInvariantRules = Lookup[
     kinematicAudit,
     "rawLoopRules",
     Lookup[case, "rawExternalInvariantRules", Lookup[case, "externalInvariantRules", Automatic]]
     ];
   externalInvariantRules = Lookup[
     kinematicAudit,
     "resolvedLoopRules",
     normalizeExternalInvariantRulesForTopology[rawExternalInvariantRules, topoContext]
     ];
   rawExternalLegInvariantRules = Lookup[
     kinematicAudit,
     "rawExternalLegRules",
     Lookup[case, "rawExternalLegInvariantRules", Lookup[case, "externalLegInvariantRules", Automatic]]
     ];
   externalLegInvariantRules = Lookup[
     kinematicAudit,
     "resolvedExternalLegRules",
     normalizeExternalLegInvariantRulesForTopology[rawExternalLegInvariantRules, topoContext]
     ];
   topoContext = Join[topoContext, <|
      "externalInvariantRules" -> externalInvariantRules,
      "rawExternalLegInvariantRules" -> rawExternalLegInvariantRules,
      "externalLegInvariantRules" -> externalLegInvariantRules,
      "kinematicRules" -> kinematicRules,
      "kinematicCoordinateAudit" -> kinematicAudit
      |>];
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
    "externalLegMomenta" -> externalLegMomenta,
    "rawExternalInvariantRules" -> rawExternalInvariantRules,
    "externalInvariantRules" -> externalInvariantRules,
    "rawExternalLegInvariantRules" -> rawExternalLegInvariantRules,
    "externalLegInvariantRules" -> externalLegInvariantRules,
    "kinematicRules" -> kinematicRules,
    "kinematicCoordinateAudit" -> kinematicAudit,
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
    "rawNumericRules" -> Lookup[case, "rawNumericRules", Lookup[case, "numericRules", {}]],
    "numericRules" -> normalizeNumericRulesForTopology[Lookup[case, "rawNumericRules", Lookup[case, "numericRules", {}]], topoContext],
    "sampleDiscreteRules" -> Lookup[case, "sampleDiscreteRules", {}],
    "seedPreset" -> seedConfig["seedPreset"],
    "seedRanges" -> seedConfig["seedRanges"],
    "generatorSeedRanges" -> Lookup[case, "generatorSeedRanges", {}],
    "seedOptions" -> seedConfig["seedOptions"],
    "unknownSeedPreset" -> seedConfig["unknownSeedPreset"],
    "zeroPointRules" -> Lookup[case, "zeroPointRules", {}],
    "shrinkPrefactorRules" -> Lookup[case, "shrinkPrefactorRules", {}],
    "symmetryRules" -> Lookup[case, "symmetryRules", {}],
    "thetaBoundarySignOffset" -> Lookup[case, "thetaBoundarySignOffset", Automatic],
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
       "masslessN1ReferenceEndpoint" -> Lookup[lines[[e]], "masslessN1ReferenceEndpoint", Missing["NotApplicable"]],
       "masslessN1OppositeEndpoint" -> Lookup[lines[[e]], "masslessN1OppositeEndpoint", Missing["NotApplicable"]],
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


lineCompiledFunctionSystem[line_Association] := Lookup[line, "compiledFunctionSystem", <||>];


lineDerivativeTerms[line_Association, sourceState_Integer] := Select[
   Lookup[lineCompiledFunctionSystem[line], "derivativeTerms", {}],
   Lookup[#, "sourceState", Missing["NoSourceState"]] === sourceState &
   ];


applyCompiledEOMTerm[topo_Association, int_J, e_Integer, endpointSlot_Integer, term_Association] := Module[
   {result, endpointVertex, xPower = term["xPower"]},
   endpointVertex = topo["lines"][[e, "endpoints", endpointSlot]];
   result = setLinePackEntry[int, e, endpointSlot + 1, term["targetState"]];
   result = shiftLineB[result, e, -xPower];
   result = shiftVertexA[result, topo, endpointVertex, xPower];
   term["coefficient"] result
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
   {e, endpointSlot, nValue, line, terms},
   e = target["lineIndex"];
   endpointSlot = target["endpointSlot"];
   nValue = target["nValue"];
   line = topo["lines"][[e]];
   If[nValue =!= 2, Return[int]];
   terms = lineDerivativeTerms[line, 1];
   If[terms === {}, Return[int]];
   Expand[Total[applyCompiledEOMTerm[topo, int, e, endpointSlot, #] & /@ terms]]
   ];


applyEOMToIntegral[topo_Association, int_J] := Module[{target},
   target = massiveEOMTarget[topo, int];
   If[Head[target] === Missing,
    int,
    applyEOM[eomReduceIntegralAt[topo, int, target], topo]
    ]
   ];


applyEOM[expr_, topo_Association] := Expand[expr /. int_J :> applyEOMToIntegral[topo, int]];


(* masslessFull 的单 n 只允许 0/1。它以 line endpoints 的第一端点定义方向，
   所有导数直接在 0/1 间翻转；不再用有歧义的临时 n=2 混写 {20} 与 {11}。
   若其它缩并使该线两端点重合，反对称态 n=1 在等时点恒为零。 *)
integralShrunkLineIndices[
   topo_Association,
   J[aList_, linePacks_, ispList_]
   ] := Select[
   Range[Length[topo["lines"]]],
   actualLinePackType[topo, #, linePacks[[#]]] === "shrunk" &
   ];


integralTargetVertexRepresentativeMap[
   topo_Association,
   int_J
   ] := Module[
   {shrunkLines, originalPairs},
   shrunkLines = integralShrunkLineIndices[topo, int];
   originalPairs = Lookup[
       topo["lines"][[#]],
       "originalEndpoints",
       topo["lines"][[#, "endpoints"]]
       ] & /@ shrunkLines;
   vertexRepresentativeMap[topo["vertexIds"], originalPairs]
   ];


(* J 中的 shrunk packs 决定目标 sector；不能只读取 source topology 的当前 endpoints。 *)
masslessCoincidentAntisymmetricIntegralQ[
   topo_Association,
   int : J[aList_, linePacks_, ispList_]
   ] := Module[
   {lines = topo["lines"], repMap},
   repMap = integralTargetVertexRepresentativeMap[topo, int];
   AnyTrue[
    Range[Length[lines]],
    Function[e,
     Module[{originalEndpoints, targetEndpoints},
      originalEndpoints = Lookup[
        lines[[e]],
        "originalEndpoints",
        lines[[e]]["endpoints"]
        ];
      targetEndpoints = Lookup[repMap, originalEndpoints];
      actualLinePackType[topo, e, linePacks[[e]]] === "masslessFull" &&
       SameQ @@ targetEndpoints &&
       linePacks[[e, 2]] === 1
      ]
     ]
    ]
   ];


applyMasslessEndpointCanonical[expr_, topo_Association] := Expand[
   expr /. (int_J /; masslessCoincidentAntisymmetricIntegralQ[topo, int]) :> 0
   ];


canonicalizeMassiveCoincidentIntegral[
   topo_Association,
   int : J[aList_, linePacks_, ispList_]
   ] := Module[{lines = topo["lines"], repMap, newPacks = linePacks, originalEndpoints, targetEndpoints},
   repMap = integralTargetVertexRepresentativeMap[topo, int];
   Do[
    originalEndpoints = Lookup[lines[[e]], "originalEndpoints", lines[[e]]["endpoints"]];
    targetEndpoints = Lookup[repMap, originalEndpoints];
    If[
     actualLinePackType[topo, e, linePacks[[e]]] === "massiveFull" &&
      SameQ @@ targetEndpoints &&
      linePacks[[e, {2, 3}]] === {1, 0},
     newPacks[[e, {2, 3}]] = linePacks[[e, {3, 2}]]
     ],
    {e, Length[lines]}
    ];
   J[aList, newPacks, ispList]
   ];


applyMassiveCoincidentCanonical[expr_, topo_Association] := Expand[
   expr /. int_J :> canonicalizeMassiveCoincidentIntegral[topo, int]
   ];


applySeedCanonical[expr_, topo_Association] :=
  symmetry[
   applyMasslessEndpointCanonical[
    applyMassiveCoincidentCanonical[applyEOM[expr, topo], topo],
    topo
    ],
   topo
   ];


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
(*用户输入的积分族对称性*)

(* sp 的 Orderless 只处理标量积交换性；本章只应用用户确认物理条件后的积分族规则。 *)
repSymmetry0[topo_Association] := Lookup[topo, "symmetryRules", {}];


symmetry::badrules = "symmetryRules 必须是 Rule/RuleDelayed 的列表。";


(* tadpole symmetry 只识别可由单个 loop momentum reversal 证明的 self-loop。*)
tadpoleLoopReversalData[topo_Association] := Module[
   {loops = Lookup[topo, "loopMomenta", {}], lines = Lookup[topo, "lines", {}], candidates, momentum, endpoints, loopIndex, exclusiveLoopQ, data = {}},
   Do[
    endpoints = Lookup[lines[[e]], "originalEndpoints", Lookup[lines[[e]], "endpoints", {}]];
    If[SameQ @@ endpoints,
     momentum = Expand[Lookup[lines[[e]], "momentum", 0]];
     candidates = Select[
       Range[Length[loops]],
       Function[l,
        With[{coefficient = Coefficient[momentum, loops[[l]]]},
         coefficient =!= 0 && Expand[momentum - coefficient loops[[l]]] === 0
         ]
        ]
       ];
     If[Length[candidates] === 1,
      loopIndex = First[candidates];
      exclusiveLoopQ = And @@ Table[
         otherLine === e || Coefficient[Expand[Lookup[lines[[otherLine]], "momentum", 0]], loops[[loopIndex]]] === 0,
         {otherLine, Length[lines]}
         ];
      AppendTo[data, <|
        "lineIndex" -> e,
        "lineId" -> Lookup[lines[[e]], "id", e],
        "packType" -> Lookup[lines[[e]], "packType", Missing["packType"]],
        "endpoints" -> endpoints,
        "loopIndex" -> loopIndex,
        "loopMomentum" -> loops[[loopIndex]],
        "exclusiveLoopQ" -> exclusiveLoopQ
        |>]
      ]
     ],
    {e, Length[lines]}
    ];
   data
   ];


reverseLoopScalarProductExpr[expr_, loopIndex_Integer] := Expand[
   expr /. {
     HoldPattern[qq[i_Integer, j_Integer]] :> (-1)^Count[{i, j}, loopIndex] qq[i, j],
     HoldPattern[qk[i_Integer, j_Integer]] :> (-1)^Count[{i}, loopIndex] qk[i, j]
     }
   ];


tadpoleISPParity[topo_Association, loopIndex_Integer, ispIndex_Integer] := Module[
   {exprs = normalizeISPExprs[topo], expr, reversed},
   If[ispIndex < 1 || ispIndex > Length[exprs], Return[0]];
   expr = exprs[[ispIndex]];
   reversed = reverseLoopScalarProductExpr[expr, loopIndex];
   Which[
    Expand[reversed - expr] === 0, 1,
    Expand[reversed + expr] === 0, -1,
    True, 0
    ]
   ];


tadpoleOddISPIntegralQ[topo_Association, J[_, _, ispList_]] := Module[{loopData, oddPowers},
   loopData = Select[
     tadpoleLoopReversalData[topo],
     MemberQ[{"massiveFull", "masslessFull"}, #["packType"]] && TrueQ[#["exclusiveLoopQ"]] &
     ];
   AnyTrue[
    loopData,
    Function[data,
     oddPowers = Select[
       Table[
        If[tadpoleISPParity[topo, data["loopIndex"], j] === -1, ispList[[j]], Nothing],
        {j, Length[ispList]}
        ],
       IntegerQ
       ];
     oddPowers =!= {} && And @@ (IntegerQ /@ oddPowers) && OddQ[Total[oddPowers]]
     ]
    ]
   ];


tadpoleMassiveSwapNeededQ[topo_Association, lineIndex_Integer, J[_, linePacks_, _]] :=
  lineIndex <= Length[linePacks] &&
   Lookup[topo["lines"][[lineIndex]], "packType", Missing["packType"]] === "massiveFull" &&
   Length[linePacks[[lineIndex]]] >= 3 && linePacks[[lineIndex, {2, 3}]] === {1, 0};


tadpoleMasslessZeroQ[topo_Association, lineIndex_Integer, J[_, linePacks_, _]] :=
  lineIndex <= Length[linePacks] &&
   Lookup[topo["lines"][[lineIndex]], "packType", Missing["packType"]] === "masslessFull" &&
   Length[linePacks[[lineIndex]]] >= 2 && linePacks[[lineIndex, 2]] === 1;


tadpoleSwapLinePack[J[aList_, linePacks_, ispList_], lineIndex_Integer] := Module[
   {newPacks = linePacks},
   newPacks[[lineIndex, {2, 3}]] = newPacks[[lineIndex, {3, 2}]];
   J[aList, newPacks, ispList]
   ];


tadpoleSymmetryRules0[topo_Association] := Module[{data, rules = {}},
   data = tadpoleLoopReversalData[topo];
   AppendTo[rules,
    HoldPattern[(int_J /; tadpoleOddISPIntegralQ[topo, int])] :> 0
    ];
   Do[
    Switch[dataItem["packType"],
     "massiveFull",
     With[{lineIndex = dataItem["lineIndex"]},
      AppendTo[rules,
       HoldPattern[(int_J /; tadpoleMassiveSwapNeededQ[topo, lineIndex, int])] :>
        tadpoleSwapLinePack[int, lineIndex]
       ]
      ],
     "masslessFull",
     With[{lineIndex = dataItem["lineIndex"]},
      AppendTo[rules,
       HoldPattern[(int_J /; tadpoleMasslessZeroQ[topo, lineIndex, int])] :> 0
       ]
      ],
     _, Null
     ],
    {dataItem, data}
    ];
   rules
   ];


effectiveSymmetryRules0[topo_Association] := Module[{userRules = repSymmetry0[topo]},
   If[! ListQ[userRules], Return[userRules]];
   DeleteDuplicates@Join[tadpoleSymmetryRules0[topo], userRules]
   ];


tadpoleSymmetryData[topo_Association] := Module[{data = tadpoleLoopReversalData[topo]},
   <|
    "status" -> "generated",
    "loopReversalData" -> data,
    "massiveFullLineIndices" -> Lookup[Select[data, #["packType"] === "massiveFull" &], "lineIndex"],
    "masslessFullLineIndices" -> Lookup[Select[data, #["packType"] === "masslessFull" &], "lineIndex"],
    "automaticRuleCount" -> Length[tadpoleSymmetryRules0[topo]],
    "automaticRules" -> tadpoleSymmetryRules0[topo],
    "userRuleCount" -> Length[repSymmetry0[topo]],
    "effectiveRuleCount" -> Length[effectiveSymmetryRules0[topo]]
    |>
   ];


symmetry[expr_, topo_Association] := Module[
   {rules = effectiveSymmetryRules0[topo]},
   If[
    ! ListQ[rules] || ! And @@ (validDiscreteReplacementRuleQ /@ rules),
    Message[symmetry::badrules];
    Return[$Failed]
    ];
   expr /. rules
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

loopDependentLineIndices[topo_Association] := Flatten@Position[
   Lookup[topo, "loopCoeffMatrix", {}],
   row_List /; AnyTrue[row, ! zeroQ[#] &]
   ];


expandZList[topo_Association] := Module[{indices = loopDependentLineIndices[topo]},
   expandDotExpr[#, #, topo] & /@ Lookup[topo["lines"][[indices]], "momentum"]
   ];


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
   {basis = Join[topo["loopMomenta"], topo["externalMomenta"], Lookup[topo, "externalLegMomenta", {}]]},
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
   {basis = Join[topo["loopMomenta"], topo["externalMomenta"], Lookup[topo, "externalLegMomenta", {}]], nL = topo["nL"], pairs},
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
   {declared = Join[topo["loopMomenta"], topo["externalMomenta"], Lookup[topo, "externalLegMomenta", {}]],
    loopSPVars = scalarProductVariables[topo], vertices = activeAVertexIds[topo]},
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
   zVars = z /@ loopDependentLineIndices[topo];
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
   zVars = z /@ loopDependentLineIndices[topo];
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

(* 本章生成 momentum IBP seed 的传播子幂次项、z/ISP 吸收和 massive/massless building-block 导数项。
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
   zVars = z /@ loopDependentLineIndices[topo];
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


(* masslessFull 的 n=1 方向由 endpoints[[1]] 定义；++ 取 sigma=+1，-- 取 sigma=-1。 *)
masslessFullSKSign[line_Association] := If[
   StringTake[Lookup[line, "skType", "++"], 1] === "+",
   1,
   -1
   ];


lineEndpointSlotsAtVertex[line_Association, vertexId_] := Flatten @ Position[
   line["endpoints"],
   vertexId
   ];


applyCompiledTimeDerivativeTerm[
   topo_Association, int_J, e_Integer, endpointSlot_Integer, term_Association
   ] := Module[{result, endpointVertex, xPower = term["xPower"]},
   endpointVertex = topo["lines"][[e, "endpoints", endpointSlot]];
   result = setLinePackEntry[int, e, endpointSlot + 1, term["targetState"]];
   result = shiftLineB[result, e, -(xPower + 1)];
   result = shiftVertexA[result, topo, endpointVertex, xPower];
   -term["coefficient"] result
   ];


compiledTimeEndpointDerivativeTerms[
   topo_Association, int_J, e_Integer, endpointSlot_Integer
   ] := Module[{state, terms},
   state = int[[2, e, endpointSlot + 1]];
   terms = Lookup[lineCompiledFunctionSystem[topo["lines"][[e]]], "derivativeTerms", {}];
   Total[
    KroneckerDelta[state, Lookup[#, "sourceState", Missing["NoSourceState"]]] *
       applyCompiledTimeDerivativeTerm[topo, int, e, endpointSlot, #] & /@ terms
    ]
   ];


applyCompiledMomentumDerivativeTerm[
   topo_Association, int_J, e_Integer, endpointSlot_Integer, factor_, term_Association
   ] := Module[{result, endpointVertex, xPower = term["xPower"]},
   endpointVertex = topo["lines"][[e, "endpoints", endpointSlot]];
   result = setLinePackEntry[int, e, endpointSlot + 1, term["targetState"]];
   result = shiftLineB[result, e, 1 - xPower];
   result = shiftVertexA[result, topo, endpointVertex, xPower + 1];
   term["coefficient"] absorbLinearFactor[factor, result, topo]
   ];


compiledMomentumEndpointDerivativeTerms[
   topo_Association, int_J, e_Integer, endpointSlot_Integer, factor_
   ] := Module[{state, terms},
   state = int[[2, e, endpointSlot + 1]];
   terms = Lookup[lineCompiledFunctionSystem[topo["lines"][[e]]], "derivativeTerms", {}];
   Total[
    KroneckerDelta[state, Lookup[#, "sourceState", Missing["NoSourceState"]]] *
       applyCompiledMomentumDerivativeTerm[topo, int, e, endpointSlot, factor, #] & /@ terms
    ]
   ];


toggleMasslessLineState[J[aList_, linePacks_, ispList_], e_Integer] := Module[
   {newLinePacks = linePacks},
   newLinePacks[[e, 2]] = 1 - newLinePacks[[e, 2]];
   J[aList, newLinePacks, ispList]
   ];


(* q 导数同时作用 massive Hankel block 与 massless 指数核。
   masslessFull 使用 d_q M_n = i sigma (tau_u-tau_v) M_(1-n)；
   masslessCross 使用两个端点相位符号的和。 *)
momentumBuildingBlockDerivativeTerms[topo_Association, int_J, gen_Association, repSP2ZRules_List] := Module[
   {dLoop, vector, lineMomenta, lines, loopCoeff, vDotQ,
     shiftedInt, packType, sigma},
   dLoop = gen["dLoop"];
   vector = gen["vector"];
   lineMomenta = Lookup[topo["lines"], "momentum"];
   lines = topo["lines"];
   Total[
    Table[
     loopCoeff = Coefficient[lineMomenta[[e]], topo["loopMomenta"][[dLoop]]];
     If[zeroQ[loopCoeff],
      0,
      vDotQ = Expand[expandDotExpr[vector, lineMomenta[[e]], topo] /. repSP2ZRules];
      packType = lines[[e]]["packType"];
      Switch[packType,
       "massiveFull" | "massiveCross",
        Total[
         Table[
          loopCoeff compiledMomentumEndpointDerivativeTerms[topo, int, e, endpointSlot, vDotQ],
          {endpointSlot, 2}
          ]
        ],
       "masslessFull",
       sigma = masslessFullSKSign[lines[[e]]];
       shiftedInt = shiftLineB[toggleMasslessLineState[int, e], e, 1];
       loopCoeff (
         -I sigma absorbLinearFactor[
           vDotQ,
           shiftVertexA[shiftedInt, topo, lines[[e]]["endpoints"][[1]], 1],
           topo
           ] +
          I sigma absorbLinearFactor[
           vDotQ,
           shiftVertexA[shiftedInt, topo, lines[[e]]["endpoints"][[2]], 1],
           topo
           ]
         ),
       "masslessCross",
       shiftedInt = shiftLineB[int, e, 1];
       loopCoeff Total[
         Table[
          -I skEndpointPhaseSign[lines[[e]], endpointSlot] absorbLinearFactor[
            vDotQ,
            shiftVertexA[shiftedInt, topo, lines[[e]]["endpoints"][[endpointSlot]], 1],
            topo
            ],
          {endpointSlot, 2}
          ]
         ],
       _,
       0
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


(* ISP 是 numerator 因子；momentum IBP 必须同时微分 ISP^r。
   内部坐标使用 qq/qk/kk，方向导数后再沿现有 z/rho 坐标吸收到指标。 *)
momentumDirectionalSPDerivative[topo_Association, expr_, gen_Association] := Module[
   {dLoop = gen["dLoop"], vector = gen["vector"], loops = topo["loopMomenta"], exts = topo["externalMomenta"]},
   Expand[
    expr /. {
      HoldPattern[qq[i_Integer, j_Integer]] :>
       If[i === dLoop, expandDotExpr[vector, loops[[j]], topo], 0] +
        If[j === dLoop, expandDotExpr[loops[[i]], vector, topo], 0],
      HoldPattern[qk[i_Integer, j_Integer]] :>
       If[i === dLoop, expandDotExpr[vector, exts[[j]], topo], 0],
      HoldPattern[kk[_Integer, _Integer]] :> 0
      }
    ]
   ];


momentumISPDerivativeTerms[topo_Association, int_J, gen_Association, repSP2ZRules_List] := Module[
   {ispExprs, exponent, derivative},
   ispExprs = normalizeISPExprs[topo];
   Total[
    Table[
     exponent = int[[3, j]];
     If[zeroQ[exponent],
      0,
      derivative = Expand[momentumDirectionalSPDerivative[topo, ispExprs[[j]], gen] /. repSP2ZRules];
      exponent absorbLinearFactor[
        derivative,
        shiftISPIndex[int, j, -1],
        topo
        ]
      ],
     {j, Length[ispExprs]}
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
     momentumBuildingBlockDerivativeTerms[topo, int, gen, ruleData["repSP2Z"]] +
     momentumISPDerivativeTerms[topo, int, gen, ruleData["repSP2Z"]]
    ]
   ];


(* ::Chapter:: *)
(*轻量 time IBP core seed*)

(* 本章接入 time-IBP 的通用 core 项：顶点幂次、外部能量、massive building-block 端点导数、massless 端点翻转项和 massive/massless theta 边界缩并项。
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


(* 顶点 + 对应 exp[-i E tau]，顶点 - 对应 exp[+i E tau]。 *)
vertexExternalPhaseDerivativeCoefficient[topo_Association, vertexId_] := If[
   Lookup[topo["vertexSignAssoc"], vertexId, "+"] === "+",
   -I,
   I
   ];


timeExternalEnergyTerm[topo_Association, int_J, vertexId_] :=
   vertexExternalPhaseDerivativeCoefficient[topo, vertexId] vertexExternalEnergy[topo, vertexId] int;


skEndpointPhaseSign[line_Association, endpointSlot_Integer] := Module[
   {skType = Lookup[line, "skType", "++"], chars},
   chars = Characters[skType];
   If[Length[chars] < endpointSlot,
    If[endpointSlot === 1, 1, -1],
    If[chars[[endpointSlot]] === "+", 1, -1]
    ]
   ];


(* massless time regular 原子：masslessFull 在有序端点上执行 {b,n}->{b-1,1-n}，两端系数为 +I sigma/-I sigma；
   若 sector 已使两端点 coincident，endpointSlots 同时包含 1、2，两个 regular 项必须在此处相消。
   masslessCross 没有 n 或 theta，只按各端点 SK 相位移动 b。 *)
timeMasslessEndpointDerivativeTerms[topo_Association, J[aList_, linePacks_, ispList_], vertexId_] := Module[
   {pos, connectedLines, lines = topo["lines"], endpointSlots, endpointSign,
    newLinePacks, sigma},
   pos = vertexPosition[topo, vertexId];
   If[Head[pos] === Missing, Return[0]];
   connectedLines = topo["vertexLines"][[pos]][[All, 1]];
   Total[
    Table[
     endpointSlots = lineEndpointSlotsAtVertex[lines[[e]], vertexId];
     Switch[lines[[e]]["packType"],
      "masslessFull",
      sigma = masslessFullSKSign[lines[[e]]];
      Total[
       Table[
        endpointSign = sigma If[endpointSlot === 1, 1, -1];
        newLinePacks = linePacks;
        newLinePacks[[e, 1]] = newLinePacks[[e, 1]] - 1;
        newLinePacks[[e, 2]] = 1 - newLinePacks[[e, 2]];
        I endpointSign J[aList, newLinePacks, ispList],
        {endpointSlot, endpointSlots}
        ]
       ],
      "masslessCross",
      Total[
       Table[
        endpointSign = skEndpointPhaseSign[lines[[e]], endpointSlot];
        newLinePacks = linePacks;
        newLinePacks[[e, 1]] = newLinePacks[[e, 1]] - 1;
        I endpointSign J[aList, newLinePacks, ispList],
        {endpointSlot, endpointSlots}
        ]
       ],
      _,
      0
      ],
     {e, connectedLines}
     ]
    ]
   ];


(* 缩并后同一条线的两个原端点可能落到同一 active vertex；
   此时必须同时微分两个 building block，不能只取 FirstPosition。 *)
timeMassiveBuildingBlockDerivativeTerms[topo_Association, J[aList_, linePacks_, ispList_], vertexId_] := Module[
   {pos, connectedLines, lines = topo["lines"], endpointSlots},
   pos = vertexPosition[topo, vertexId];
   If[Head[pos] === Missing, Return[0]];
   connectedLines = topo["vertexLines"][[pos]][[All, 1]];
   Total[
    Table[
     If[! MemberQ[{"massiveFull", "massiveCross"}, actualLinePackType[topo, e, linePacks[[e]]]],
      0,
      endpointSlots = lineEndpointSlotsAtVertex[lines[[e]], vertexId];
       Total[
        Table[
         compiledTimeEndpointDerivativeTerms[topo, J[aList, linePacks, ispList], e, endpointSlot],
         {endpointSlot, endpointSlots}
         ]
       ]
      ],
     {e, connectedLines}
     ]
    ]
   ];


lineCompiledShrinkTerms[line_Association] := Lookup[
   lineCompiledFunctionSystem[line],
   "shrinkTerms",
   {}
   ];


defaultThetaBoundarySignOffset[line_Association] := If[
   Lookup[line, "packType", "massiveFull"] === "massiveFull" &&
    Lookup[line, "skType", "++"] === "++",
   1,
   0
   ];


(* 参考 bubble 的 Vpm convention：++ 为 1，-- 为 0；显式 line/case 设置仍可覆盖默认值。 *)
thetaBoundarySignOffset[topo_Association, e_Integer] := Module[
   {line = topo["lines"][[e]], caseOffset},
   caseOffset = Lookup[topo, "thetaBoundarySignOffset", Automatic];
   Lookup[
    line,
    "thetaBoundarySignOffset",
    If[caseOffset === Automatic, defaultThetaBoundarySignOffset[line], caseOffset]
    ]
   ];
lineShrinkZeroPointShift[line_Association] := Module[
   {compiled = lineCompiledFunctionSystem[line]},
   Lookup[
    line,
    "shrinkZeroPointShift",
    Lookup[compiled, "shrinkZeroPointShift", 0]
    ]
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


(* massive Wronskian 缩并带一个额外 1/q 和 1/(-tau)，故 bS=b+1 且 merged a 减 1；
   massless 反对称 theta-delta 不带这些因子，必须保持 bS=b 且 merged a 不移位。 *)
lineShrinkBShift[line_Association] := If[
   Lookup[line, "massType", "massive"] === "massless",
   0,
   Lookup[First[Lookup[lineCompiledFunctionSystem[line], "shrinkTerms", {<|"bShift" -> 1|>}]], "bShift", 1]
   ];


shrinkLineIntegral[topo_Association, J[aList_, linePacks_, ispList_], e_Integer, bShift_: Automatic, aShift_: Automatic] := Module[
   {line = topo["lines"][[e]], uSlot, vSlot, oldActive, newRepMap, newActive, newAList, newLinePacks = linePacks,
     mergedRep, oldSlotsForNewRep, slotValues, effectiveBShift, effectiveAShift},
   effectiveBShift = If[bShift === Automatic, lineShrinkBShift[line], bShift];
    effectiveAShift = If[
      aShift === Automatic,
      If[Lookup[line, "massType", "massive"] === "massless", 0, effectiveBShift],
      aShift
      ];
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
       If[uSlot === vSlot, 2 aList[[uSlot]], Total[slotValues]] - effectiveAShift,
       Total[slotValues]
       ],
     {i, Length[newActive]}
     ];
   newLinePacks[[e]] = {linePacks[[e, 1]] + effectiveBShift};
   J[newAList, newLinePacks, ispList]
   ];


shrinkLinesIntegral[
   topo_Association,
   J[aList_, linePacks_, ispList_],
   specs_List
   ] := Module[
   {selectedLines, oldActive, pairs, newRepMap, newActive, newAList,
    newLinePacks = linePacks, oldSlotsForNewRep, selectedShiftForRep},
   selectedLines = Lookup[specs, "lineIndex"];
   oldActive = activeAVertexIds[topo];
   pairs = topo["lines"][[#, "endpoints"]] & /@ selectedLines;
   newRepMap = vertexRepresentativeMap[topo["vertexIds"], Join[
      ({#, vertexRepresentative[topo, #]} & /@ topo["vertexIds"]),
      pairs
      ]];
   newActive = DeleteDuplicates[Lookup[newRepMap, topo["vertexIds"]]];
   newAList = Table[
     oldSlotsForNewRep = Flatten[Position[Lookup[newRepMap, oldActive], newActive[[i]]]];
     selectedShiftForRep = Total[MapThread[
        If[SameQ @@ Lookup[newRepMap, #1] && First[Lookup[newRepMap, #1]] === newActive[[i]], #2, 0] &,
        {pairs, Lookup[specs, "aShift"]}
        ]];
     Total[aList[[oldSlotsForNewRep]]] - selectedShiftForRep,
     {i, Length[newActive]}
     ];
   Scan[
    Function[spec,
     newLinePacks[[spec["lineIndex"]]] = {
       linePacks[[spec["lineIndex"], 1]] + spec["bShift"]
       }
     ],
    specs
    ];
   J[newAList, newLinePacks, ispList]
   ];


thetaBoundaryAtomicTerms[
   topo_Association,
   J[aList_, linePacks_, ispList_],
   e_Integer,
   vertexId_
   ] := Module[
   {line = topo["lines"][[e]], endpointSlots, endpointSlot, endpointOrientation,
    pack = linePacks[[e]], packType, coeff, shrinkTerms},
   endpointSlots = lineEndpointSlotsAtVertex[line, vertexId];
   If[Length[endpointSlots] =!= 1, Return[{}]];
   endpointSlot = First[endpointSlots];
   endpointOrientation = If[endpointSlot === 1, 1, -1];
   packType = actualLinePackType[topo, e, pack];
   Switch[packType,
    "massiveFull",
    coeff = KroneckerDelta[pack[[2]] + pack[[3]], 1] (-1)^(pack[[endpointSlot + 1]] + thetaBoundarySignOffset[topo, e]);
    shrinkTerms = lineCompiledShrinkTerms[line];
    (<|
        "lineIndex" -> e,
        "coefficient" -> coeff (Lookup[#, "coefficient", 0] /. topo["shrinkPrefactorRules"]),
        "bShift" -> Lookup[#, "bShift", 1],
        "aShift" -> Lookup[#, "bShift", 1]
        |> &) /@ shrinkTerms,
    "masslessFull",
    {<|
      "lineIndex" -> e,
      "coefficient" -> -2 endpointOrientation KroneckerDelta[pack[[2]], 1],
      "bShift" -> 0,
      "aShift" -> 0
      |>},
    _,
    {}
    ]
   ];


thetaBundleKey[topo_Association, e_Integer] := Sort[vertexPosition[topo, #] & /@ topo["lines"][[e, "endpoints"]]];


(* 同一代表顶点对的 full lines 共享一个 theta。共同边界
   Product[A]-Product[B] 在 J=(A+B)/2、D=A-B 基底中只含非空奇数 D 子集，
   k-line contact 的系数为 2^(1-k)。每个子集只合并顶点一次，绝不生成 delta^k。 *)
timeThetaBoundaryShrinkTerms[topo_Association, int : J[aList_, linePacks_, ispList_], vertexId_] := Module[
   {pos, connectedLines, eligibleLines, bundles, oddSubsets, atomicChoices},
   pos = vertexPosition[topo, vertexId];
   If[Head[pos] === Missing, Return[0]];
   connectedLines = topo["vertexLines"][[pos]][[All, 1]];
   eligibleLines = Select[
     connectedLines,
     MemberQ[{"massiveFull", "masslessFull"}, actualLinePackType[topo, #, linePacks[[#]]]] &&
       Length[lineEndpointSlotsAtVertex[topo["lines"][[#]], vertexId]] === 1 &
     ];
   bundles = GatherBy[eligibleLines, thetaBundleKey[topo, #] &];
   Total[Table[
     oddSubsets = Select[Rest[Subsets[bundle]], OddQ[Length[#]] &];
     Total[Table[
       atomicChoices = thetaBoundaryAtomicTerms[topo, int, #, vertexId] & /@ selected;
       If[AnyTrue[atomicChoices, # === {} &],
        0,
        Total[
         Function[choice,
            2^(1 - Length[selected]) Times @@ Lookup[choice, "coefficient"] *
             shrinkLinesIntegral[topo, int, KeyDrop[#, "coefficient"] & /@ choice]
            ] /@ Tuples[atomicChoices]
         ]
        ],
       {selected, oddSubsets}
       ]],
     {bundle, bundles}
     ]]
   ];


seedUnsupportedPendingFeatures[topo_Association] := DeleteDuplicates@Join[
    unsupportedSeedFeaturesForTopology[topo]
    ];


momentumIBPPendingFeatures[topo_Association] := seedUnsupportedPendingFeatures[topo];


timeIBPPendingFeatures[topo_Association] := DeleteDuplicates@Join[
    seedUnsupportedPendingFeatures[topo],
    If[thetaFullLineIndices[topo] =!= {}, {"shrinkSectorSeedGeneration"}, {}]
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
   {baseIntegral, continuousDataByGenerator, continuousCounts, commonContinuousQ, legacyContinuousCount,
    legacyContinuousRules, discreteData, timeGenerators, equationCount,
    maxEquationCount, genTemplates, equations, pendingFeatures, topologyReport},
   topologyReport = topologyValidationReport[topo];
   If[topologyValidationErrorQ[topologyReport],
    Return[<|"status" -> "invalidTopology", "caseName" -> topo["name"], "topologyValidationReport" -> topologyReport, "equations" -> {}|>]
    ];
   baseIntegral = makeBaseIntegral[topo];
   discreteData = selectedDiscreteSeedRules[
     topo,
     DiscreteMode -> OptionValue[DiscreteMode],
     MaxDiscreteRuleCount -> OptionValue[MaxDiscreteRuleCount]
     ];
   If[discreteData["status"] =!= "generated",
    Return[Join[discreteData, <|"caseName" -> topo["name"], "topologyValidationReport" -> topologyReport, "equations" -> {}|>]]
   ];
   timeGenerators = Select[makeIBPGenerators[topo], #["type"] === "time" &];
   continuousDataByGenerator = Table[
     With[{label = timeGeneratorLabel[generator]},
      Join[
       <|"generator" -> label|>,
       makeGeneratorContinuousSeedRules[
        topo,
        label,
        UseSampleOnly -> OptionValue[UseSampleOnly],
        MaxSeedRuleCount -> OptionValue[MaxSeedRuleCount]
        ]
       ]
      ],
     {generator, timeGenerators}
     ];
   If[AnyTrue[continuousDataByGenerator, Lookup[#, "status", "missing"] =!= "generated" &],
    Return[<|"status" -> "invalidGeneratorSeedRanges", "caseName" -> topo["name"], "topologyValidationReport" -> topologyReport,
      "generatorContinuousSeedData" -> (KeyDrop[#, "rules"] & /@ continuousDataByGenerator), "equations" -> {}|>]
    ];
   continuousCounts = Lookup[continuousDataByGenerator, "ruleCount", 0];
   commonContinuousQ = Length[continuousDataByGenerator] == 0 || SameQ @@ Lookup[continuousDataByGenerator, "rules", {}];
   legacyContinuousCount = If[Length[continuousCounts] == 0, 0, If[commonContinuousQ, First[continuousCounts], Total[continuousCounts]]];
   legacyContinuousRules = If[Length[continuousDataByGenerator] > 0 && commonContinuousQ, First[Lookup[continuousDataByGenerator, "rules"]], {}];
   equationCount = Total[continuousCounts] discreteData["ruleCount"];
   maxEquationCount = resolveSeedOption[topo, "MaxEquationCount", OptionValue[MaxEquationCount], 80];
   If[equationCount > maxEquationCount,
    Message[makeTimeIBPSeedBatch::toomany, topo["name"], equationCount, maxEquationCount];
    Return[<|
      "status" -> "tooMany",
      "caseName" -> topo["name"],
      "topologyValidationReport" -> topologyReport,
      "continuousSeedRuleCount" -> legacyContinuousCount,
      "generatorContinuousSeedData" -> (KeyDrop[#, "rules"] & /@ continuousDataByGenerator),
      "discreteRuleCount" -> discreteData["ruleCount"],
      "timeGeneratorCount" -> Length[timeGenerators],
      "equationCount" -> equationCount,
      "equations" -> {}
      |>]
   ];
   genTemplates = MapThread[
     <|"generatorData" -> #1, "generator" -> timeGeneratorLabel[#1],
       "template" -> applyTimeGeneratorSeed[topo, baseIntegral, #1], "continuousData" -> #2|> &,
     {timeGenerators, continuousDataByGenerator}
     ];
   If[MemberQ[Lookup[genTemplates, "template"], $Failed], Return[<|"status" -> "failed", "caseName" -> topo["name"], "topologyValidationReport" -> topologyReport|>]];
   pendingFeatures = timeIBPPendingFeatures[topo];
   equations = Flatten[
     Table[
      Module[{rules = Join[continuousRule, discreteRule], expr},
       expr = genTemplate["template"] /. rules;
       expr = applySeedCanonical[expr, topo];
       If[TrueQ[OptionValue[ApplyNumericRules]], expr = expr /. topo["numericRules"]];
       <|
        "generator" -> genTemplate["generator"],
        "continuousRules" -> continuousRule,
        "discreteRules" -> discreteRule,
        "equation" -> Expand[expr],
        "forbiddenNData" -> forbiddenNData[topo, expr],
        "eomCanonicalQ" -> ! containsForbiddenNQ[topo, expr]
        |>
       ],
      {genTemplate, genTemplates},
      {continuousRule, genTemplate["continuousData"]["rules"]},
      {discreteRule, discreteData["rules"]}
      ],
     2
     ];
   <|
    "status" -> "generated",
    "caseName" -> topo["name"],
    "topologyValidationReport" -> topologyReport,
    "continuousSeedRuleCount" -> legacyContinuousCount,
    "continuousSeedRuleCountTotal" -> Total[continuousCounts],
    "discreteRuleCount" -> discreteData["ruleCount"],
    "timeGeneratorCount" -> Length[timeGenerators],
    "equationCount" -> Length[equations],
    "eomCanonicalQ" -> And @@ Lookup[equations, "eomCanonicalQ"],
    "forbiddenNData" -> DeleteCases[Flatten[Lookup[equations, "forbiddenNData"]], Null],
    "generators" -> timeGeneratorLabel /@ timeGenerators,
    "continuousSeedRules" -> legacyContinuousRules,
    "generatorSpecificContinuousRangesQ" -> AnyTrue[continuousDataByGenerator, Lookup[#, "rangeSource", "uniform"] === "generatorOverride" &],
    "generatorContinuousSeedData" -> (KeyDrop[#, "rules"] & /@ continuousDataByGenerator),
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


(* generatorSeedRanges 是统一 seedRanges 之上的稀疏覆盖层。
   同一 sector/generator 只允许一条记录；未覆盖变量沿用统一范围。 *)
generatorSeedRangeMatches[topo_Association, generatorLabel_List] := Select[
   Lookup[topo, "generatorSeedRanges", {}],
   Lookup[#, "sectorKey", Missing["sectorKey"]] === sectorKeyFromShrunkLines[Lookup[topo, "sectorShrunkLines", {}]] &&
     Lookup[#, "generator", Missing["generator"]] === generatorLabel &
   ];


Options[makeGeneratorContinuousSeedRules] = Options[makeContinuousSeedRules];
makeGeneratorContinuousSeedRules[topo_Association, generatorLabel_List, OptionsPattern[]] := Module[
   {matches, baseData, useSampleOnly, baseIntegral, vars, baseValueLists, configuredRules,
    configuredVars, duplicateVars, unknownVars, valueLists, ruleCount, maxCount, rules, sectorKey},
   sectorKey = sectorKeyFromShrunkLines[Lookup[topo, "sectorShrunkLines", {}]];
   useSampleOnly = resolveUseSampleOnly[topo, OptionValue[UseSampleOnly]];
   matches = generatorSeedRangeMatches[topo, generatorLabel];
   If[useSampleOnly || matches === {},
    baseData = makeContinuousSeedRules[
      topo,
      UseSampleOnly -> OptionValue[UseSampleOnly],
      MaxSeedRuleCount -> OptionValue[MaxSeedRuleCount]
      ];
    Return[Join[baseData, <|"sectorKey" -> sectorKey, "rangeSource" -> "uniform",
       "configuredRanges" -> {}, "generatorOverrideIgnoredBySampleOnlyQ" -> TrueQ[useSampleOnly && matches =!= {}]|>]]
    ];
   If[Length[matches] =!= 1,
    Return[<|"status" -> "duplicateGeneratorRangeEntries", "caseName" -> topo["name"],
      "sectorKey" -> sectorKey, "generator" -> generatorLabel, "entryCount" -> Length[matches], "rules" -> {}|>]
    ];
   baseIntegral = makeBaseIntegral[topo];
   vars = continuousIndexVariables[baseIntegral];
   baseValueLists = continuousIndexValueLists[topo, baseIntegral, False];
   configuredRules = matches[[1]]["ranges"];
   configuredVars = First /@ configuredRules;
   duplicateVars = Cases[Tally[configuredVars], {var_, count_} /; count > 1 :> var];
   unknownVars = Select[configuredVars, Function[var, ! AnyTrue[vars, SameQ[#, var] &]]];
   If[duplicateVars =!= {} || unknownVars =!= {},
    Return[<|"status" -> "invalidGeneratorRangeVariables", "caseName" -> topo["name"],
      "sectorKey" -> sectorKey, "generator" -> generatorLabel, "variables" -> vars,
      "duplicateVariables" -> duplicateVars, "unknownVariables" -> unknownVars, "rules" -> {}|>]
    ];
   valueLists = MapThread[
     Function[{var, fallback},
      With[{match = SelectFirst[configuredRules, SameQ[First[#], var] &, Missing["NotConfigured"]]},
       If[Head[match] === Missing, fallback, rangeValuesFromSpec[Last[match]]]
       ]
      ],
     {vars, baseValueLists}
     ];
   ruleCount = Times @@ (Length /@ valueLists);
   maxCount = resolveSeedOption[topo, "MaxSeedRuleCount", OptionValue[MaxSeedRuleCount], 200];
   If[ruleCount > maxCount,
    Message[makeContinuousSeedRules::toomany, topo["name"] <> "/" <> ToString[generatorLabel, InputForm], ruleCount, maxCount];
    Return[<|"status" -> "tooMany", "caseName" -> topo["name"], "sectorKey" -> sectorKey,
      "generator" -> generatorLabel, "rangeSource" -> "generatorOverride", "useSampleOnly" -> False,
      "variables" -> vars, "valueLists" -> valueLists, "configuredRanges" -> configuredRules,
      "ruleCount" -> ruleCount, "rules" -> {}|>]
    ];
   rules = If[vars === {}, {{}}, Thread[vars -> #] & /@ Tuples[valueLists]];
   <|"status" -> "generated", "caseName" -> topo["name"], "sectorKey" -> sectorKey,
    "generator" -> generatorLabel, "rangeSource" -> "generatorOverride", "useSampleOnly" -> False,
    "variables" -> vars, "valueLists" -> valueLists, "configuredRanges" -> configuredRules,
    "ruleCount" -> Length[rules], "rules" -> rules|>
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


(* ::Chapter:: *)
(*独立变量导数 seed*)

(* 本章生成微分方程阶段使用的独立变量导数。顶点能量 ke[i] 只微分顶点相位；
   外部不变量先在约束坐标中解成外动量矢量导数 k_i.d/dk_j 的线性组合，解的 basis 显式返回。 *)

externalVectorDerivativeGenerators[topo_Association] := Flatten[
   Table[
    <|
     "type" -> "externalVector",
     "vectorIndex" -> i,
     "dExternal" -> j,
     "vector" -> topo["externalMomenta"][[i]]
     |>,
    {i, topo["nK"]}, {j, topo["nK"]}
    ],
   1
   ];


externalVectorDerivativeGeneratorBasis[topo_Association, Automatic] := externalVectorDerivativeGeneratorBasis[topo, "upperTriangular"];
externalVectorDerivativeGeneratorBasis[topo_Association, "upperTriangular"] := Flatten[
   Table[
    If[i <= j,
     <|
      "type" -> "externalVector",
      "vectorIndex" -> i,
      "dExternal" -> j,
      "vector" -> topo["externalMomenta"][[i]]
      |>,
     Nothing
     ],
    {i, topo["nK"]}, {j, topo["nK"]}
    ],
   1
   ];
externalVectorDerivativeGeneratorBasis[topo_Association, "all"] := externalVectorDerivativeGenerators[topo];
externalVectorDerivativeGeneratorBasis[topo_Association, gens_List] := gens;
externalVectorDerivativeGeneratorBasis[topo_Association, _] := externalVectorDerivativeGeneratorBasis[topo, "upperTriangular"];


externalVectorDerivativeLabel[gen_Association] := {gen["type"], gen["vectorIndex"], gen["dExternal"]};


externalVectorSPCoordinateDerivative[topo_Association, coordinate_, gen_Association] := Module[
   {dExternal = gen["dExternal"], vector = gen["vector"], loops = topo["loopMomenta"], exts = topo["externalMomenta"]},
   Expand[
    coordinate /. {
      HoldPattern[qq[_Integer, _Integer]] :> 0,
      HoldPattern[qk[i_Integer, j_Integer]] :>
       If[j === dExternal, expandDotExpr[loops[[i]], vector, topo], 0],
      HoldPattern[kk[i_Integer, j_Integer]] :>
       If[i === dExternal, expandDotExpr[vector, exts[[j]], topo], 0] +
        If[j === dExternal, expandDotExpr[exts[[i]], vector, topo], 0]
      }
   ]
   ];


(* 对非线性动力学量表达式必须显式执行链式法则，不能把坐标直接替成其方向导数。 *)
externalVectorDirectionalSPDerivative[topo_Association, expr_, gen_Association] := Module[
   {coordinates},
   coordinates = DeleteDuplicates[Cases[expr, _qq | _qk | _kk, {0, Infinity}]];
   Expand[Total[
     D[expr, #] externalVectorSPCoordinateDerivative[topo, #, gen] & /@ coordinates
     ]]
   ];


externalVectorPropagatorDerivativeTerms[topo_Association, int_J, gen_Association, repSP2ZRules_List] := Module[
   {dExternal, vector, lineMomenta, extCoeff, vDotQ, shiftedInt},
   dExternal = gen["dExternal"];
   vector = gen["vector"];
   lineMomenta = Lookup[topo["lines"], "momentum"];
   Total[
    Table[
     extCoeff = Coefficient[lineMomenta[[e]], topo["externalMomenta"][[dExternal]]];
     If[zeroQ[extCoeff] || externalLegCoordinateLineQ[lineMomenta[[e]], topo],
      0,
      vDotQ = Expand[expandDotExpr[vector, lineMomenta[[e]], topo] /. repSP2ZRules];
      shiftedInt = shiftLineB[int, e, 2];
      -extCoeff linePowerIndex[topo, int, e] absorbLinearFactor[vDotQ, shiftedInt, topo]
      ],
     {e, topo["nE"]}
     ]
    ]
   ];


(* 外部动力学量导数与 qIBP 共用最终 AT 编译结果；WT 只用于 theta shrink。 *)
externalVectorBuildingBlockDerivativeTerms[topo_Association, int_J, gen_Association, repSP2ZRules_List] := Module[
   {dExternal, vector, lineMomenta, lines, extCoeff, vDotQ,
    shiftedInt, packType, sigma},
   dExternal = gen["dExternal"];
   vector = gen["vector"];
   lineMomenta = Lookup[topo["lines"], "momentum"];
   lines = topo["lines"];
   Total[
    Table[
     extCoeff = Coefficient[lineMomenta[[e]], topo["externalMomenta"][[dExternal]]];
     If[zeroQ[extCoeff] || externalLegCoordinateLineQ[lineMomenta[[e]], topo],
      0,
      vDotQ = Expand[expandDotExpr[vector, lineMomenta[[e]], topo] /. repSP2ZRules];
      packType = lines[[e]]["packType"];
      Switch[packType,
       "massiveFull" | "massiveCross",
       Total[
        Table[
         extCoeff compiledMomentumEndpointDerivativeTerms[
           topo, int, e, endpointSlot, vDotQ
           ],
         {endpointSlot, 2}
         ]
        ],
       "masslessFull",
       sigma = masslessFullSKSign[lines[[e]]];
       shiftedInt = shiftLineB[toggleMasslessLineState[int, e], e, 1];
       extCoeff (
         -I sigma absorbLinearFactor[
           vDotQ,
           shiftVertexA[shiftedInt, topo, lines[[e]]["endpoints"][[1]], 1],
           topo
           ] +
          I sigma absorbLinearFactor[
           vDotQ,
           shiftVertexA[shiftedInt, topo, lines[[e]]["endpoints"][[2]], 1],
           topo
           ]
         ),
       "masslessCross",
       shiftedInt = shiftLineB[int, e, 1];
       extCoeff Total[
         Table[
          -I skEndpointPhaseSign[lines[[e]], endpointSlot] absorbLinearFactor[
            vDotQ,
            shiftVertexA[shiftedInt, topo, lines[[e]]["endpoints"][[endpointSlot]], 1],
            topo
            ],
          {endpointSlot, 2}
          ]
         ],
       _,
       0
       ]
      ],
     {e, topo["nE"]}
     ]
    ]
   ];


externalVectorISPDerivativeTerms[topo_Association, int_J, gen_Association, repSP2ZRules_List] := Module[
   {ispExprs, exponent, derivative},
   ispExprs = normalizeISPExprs[topo];
   Total[
    Table[
     exponent = int[[3, j]];
     If[zeroQ[exponent],
      0,
      derivative = Expand[externalVectorDirectionalSPDerivative[topo, ispExprs[[j]], gen] /. repSP2ZRules];
      exponent absorbLinearFactor[
        derivative,
        shiftISPIndex[int, j, -1],
        topo
        ]
      ],
     {j, Length[ispExprs]}
     ]
    ]
   ];


externalVectorVertexEnergyDerivativeTerms[topo_Association, int_J, gen_Association] := Module[
   {vertices = activeAVertexIds[topo], derivative},
   Total[
    Table[
     derivative = externalVectorDirectionalSPDerivative[topo, vertexExternalEnergy[topo, vertexId], gen];
     If[zeroQ[derivative],
      0,
      -vertexExternalPhaseDerivativeCoefficient[topo, vertexId] derivative shiftVertexA[int, topo, vertexId, 1]
      ],
     {vertexId, vertices}
     ]
    ]
   ];


applyExternalVectorDerivativeSeed::badgen = "external-vector seed 只能使用 externalVector 生成元，收到：`1`。";
applyExternalVectorDerivativeSeed::nosp =
   "拓扑 `1` 的标量积到 z/ISP 规则未生成：`2`。请补充 ISP 配置后再生成 external-vector seed。";


applyExternalVectorDerivativeSeed[topo_Association, int_J, gen_Association] := Module[
   {ruleData},
   If[gen["type"] =!= "externalVector",
    Message[applyExternalVectorDerivativeSeed::badgen, gen];
    Return[$Failed]
    ];
   ruleData = makeScalarProductRules[topo];
   If[Lookup[ruleData, "status", "notComputed"] =!= "computed",
    Message[applyExternalVectorDerivativeSeed::nosp, topo["name"], Lookup[ruleData, "reason", Missing["reason"]]];
    Return[$Failed]
    ];
   Expand[
    externalVectorPropagatorDerivativeTerms[topo, int, gen, ruleData["repSP2Z"]] +
     externalVectorBuildingBlockDerivativeTerms[topo, int, gen, ruleData["repSP2Z"]] +
     externalVectorISPDerivativeTerms[topo, int, gen, ruleData["repSP2Z"]] +
     externalVectorVertexEnergyDerivativeTerms[topo, int, gen]
    ]
   ];


Options[makeExternalInvariantDerivativeDecomposition] = {
   ExternalInvariantCoordinateVariables -> Automatic,
   ExternalVectorOperatorBasis -> Automatic
   };

makeExternalInvariantDerivativeDecomposition::badvar =
   "变量 `1` 不在当前外部不变量坐标 `2` 中；若它是组合变量，请显式给出 ExternalInvariantCoordinateVariables。";
makeExternalInvariantDerivativeDecomposition::nosol =
   "变量 `1` 无法由所选 external-vector operator basis `2` 解出。";


normalizeExternalInvariantCoordinateList[topo_Association, Automatic] := externalInvariantVariables[topo];
normalizeExternalInvariantCoordinateList[topo_Association, coords_List] := scalarProductInputToInternal[#, topo] & /@ coords;
normalizeExternalInvariantCoordinateList[topo_Association, coord_] := {scalarProductInputToInternal[coord, topo]};


makeExternalInvariantDerivativeDecomposition[topo_Association, var_, OptionsPattern[]] := Module[
   {target, coords, targetPos, gens, matrix, coeffs, equations, solutions, selectedRules,
    selectedCoefficients, residual, fullGens, fullMatrix, rank, nullity, freeCoeffRules},
   target = scalarProductInputToInternal[var, topo];
   coords = normalizeExternalInvariantCoordinateList[topo, OptionValue[ExternalInvariantCoordinateVariables]];
   targetPos = FirstPosition[coords, target, Missing["NotFound"]];
   If[Head[targetPos] === Missing,
    Message[makeExternalInvariantDerivativeDecomposition::badvar, var, scalarProductInternalToUser[#, topo] & /@ coords];
    Return[<|"status" -> "badVariable", "targetVariable" -> scalarProductInternalToUser[target, topo], "coordinateVariables" -> scalarProductInternalToUser[#, topo] & /@ coords|>]
    ];
   targetPos = First[targetPos];
   gens = externalVectorDerivativeGeneratorBasis[topo, OptionValue[ExternalVectorOperatorBasis]];
   matrix = Table[
     externalVectorDirectionalSPDerivative[topo, coords[[r]], gens[[c]]],
     {r, Length[coords]}, {c, Length[gens]}
     ];
   coeffs = Array[cv, Length[gens]];
   equations = Thread[matrix . coeffs == UnitVector[Length[coords], targetPos]];
   solutions = Quiet[Solve[equations, coeffs]];
   If[solutions === {},
    Message[makeExternalInvariantDerivativeDecomposition::nosol, var, externalVectorDerivativeLabel /@ gens];
    Return[<|"status" -> "noSolution", "targetVariable" -> scalarProductInternalToUser[target, topo], "operatorBasis" -> externalVectorDerivativeLabel /@ gens, "matrix" -> matrix|>]
    ];
   selectedRules = First[solutions];
   freeCoeffRules = Thread[Complement[coeffs, selectedRules[[All, 1]]] -> 0];
   selectedCoefficients = Expand[coeffs /. selectedRules /. freeCoeffRules];
   residual = Simplify[Expand[matrix . selectedCoefficients - UnitVector[Length[coords], targetPos]]];
   fullGens = externalVectorDerivativeGenerators[topo];
   fullMatrix = Table[
     externalVectorDirectionalSPDerivative[topo, coords[[r]], fullGens[[c]]],
     {r, Length[coords]}, {c, Length[fullGens]}
     ];
   rank = Quiet[MatrixRank[fullMatrix]];
   nullity = If[IntegerQ[rank], Length[fullGens] - rank, Missing["SymbolicRankNotComputed"]];
   <|
    "status" -> "solved",
    "targetVariable" -> scalarProductInternalToUser[target, topo],
    "internalTargetVariable" -> target,
    "coordinateVariables" -> (scalarProductInternalToUser[#, topo] & /@ coords),
    "internalCoordinateVariables" -> coords,
    "operatorBasis" -> (externalVectorDerivativeLabel /@ gens),
    "operators" -> gens,
    "matrix" -> matrix,
    "coefficientRules" -> Thread[externalVectorDerivativeLabel /@ gens -> selectedCoefficients],
    "coefficients" -> selectedCoefficients,
    "residual" -> residual,
    "solutionFamilyRules" -> solutions,
    "fullOperatorCount" -> Length[fullGens],
    "coordinateCount" -> Length[coords],
    "fullOperatorRank" -> rank,
    "nullity" -> nullity,
    "nonUniqueQ" -> TrueQ[IntegerQ[nullity] && nullity > 0]
    |>
   ];


directVertexEnergyVariableDerivativeSeed[topo_Association, int_J, var_] := Module[
   {internalVar, vertices = activeAVertexIds[topo], derivative},
   internalVar = scalarProductInputToInternal[var, topo];
   Total[
    Table[
     derivative = D[vertexExternalEnergy[topo, vertexId], internalVar];
     If[zeroQ[derivative],
      0,
      -vertexExternalPhaseDerivativeCoefficient[topo, vertexId] derivative shiftVertexA[int, topo, vertexId, 1]
      ],
     {vertexId, vertices}
     ]
    ]
   ];


Options[applyExternalInvariantVariableDerivativeSeed] = Options[makeExternalInvariantDerivativeDecomposition];
applyExternalInvariantVariableDerivativeSeed[topo_Association, int_J, var_, opts : OptionsPattern[]] := Module[
   {decomp, terms},
   decomp = makeExternalInvariantDerivativeDecomposition[topo, var, FilterRules[{opts}, Options[makeExternalInvariantDerivativeDecomposition]]];
   If[Lookup[decomp, "status", "failed"] =!= "solved", Return[$Failed]];
   terms = MapThread[
     #1 applyExternalVectorDerivativeSeed[topo, int, #2] &,
     {decomp["coefficients"], decomp["operators"]}
     ];
   Expand[Total[terms]]
   ];


Options[applyIndependentVariableDerivativeSeed] = Options[makeExternalInvariantDerivativeDecomposition];
applyIndependentVariableDerivativeSeed[topo_Association, int_J, var_, opts : OptionsPattern[]] := Module[
   {internalVar},
   internalVar = scalarProductInputToInternal[var, topo];
   If[MemberQ[externalInvariantVariables[topo], internalVar],
    Return[applyExternalInvariantVariableDerivativeSeed[topo, int, internalVar, opts]]
    ];
   Expand[directVertexEnergyVariableDerivativeSeed[topo, int, internalVar]]
   ];


(* 独立变量集合按 external invariant 坐标与未被其表达的顶点能量参数组成。*)
independentVariableDerivativeVariables[topo_Association] := DeleteDuplicates@Join[
   externalInvariantVariables[topo],
   Complement[vertexEnergyVariables[topo], externalInvariantVariables[topo]]
   ];


independentVariableDerivativeKind[topo_Association, var_] := If[
   MemberQ[externalInvariantVariables[topo], var],
   "externalInvariant",
   "vertexEnergy"
   ];


makeIndependentVariableDerivativeGenerators[topo_Association] :=
  (<|
      "variable" -> #,
      "userVariable" -> scalarProductInternalToUser[#, topo],
      "kind" -> independentVariableDerivativeKind[topo, #]
      |> &) /@ independentVariableDerivativeVariables[topo];


Options[makeIndependentVariableDerivativeSeedBatch] = Options[makeExternalInvariantDerivativeDecomposition];
makeIndependentVariableDerivativeSeedBatch[topo_Association, int_J, opts : OptionsPattern[]] := Module[
   {generators, results, derivative, decomposition, kind, variable, failureQ},
   generators = makeIndependentVariableDerivativeGenerators[topo];
   results = Table[
     variable = generator["variable"];
     kind = generator["kind"];
     decomposition = If[kind === "externalInvariant",
       makeExternalInvariantDerivativeDecomposition[
        topo,
        variable,
        FilterRules[{opts}, Options[makeExternalInvariantDerivativeDecomposition]]
        ],
       Missing["NotApplicable"]
       ];
     derivative = If[kind === "externalInvariant" && Lookup[decomposition, "status", "failed"] =!= "solved",
       $Failed,
       applyIndependentVariableDerivativeSeed[
        topo,
        int,
        variable,
        Sequence @@ FilterRules[{opts}, Options[makeExternalInvariantDerivativeDecomposition]]
        ]
       ];
     derivative = If[derivative === $Failed, $Failed, applySeedCanonical[Expand[derivative], topo]];
     <|
      "variable" -> variable,
      "userVariable" -> generator["userVariable"],
      "kind" -> kind,
      "decomposition" -> decomposition,
      "derivative" -> derivative,
      "status" -> If[derivative === $Failed, "failed", "generated"],
      "forbiddenNData" -> If[derivative === $Failed, {}, forbiddenNData[topo, derivative]],
      "canonicalQ" -> If[derivative === $Failed, False, ! containsForbiddenNQ[topo, derivative]]
      |>,
     {generator, generators}
     ];
   failureQ = AnyTrue[results, Lookup[#, "status", "failed"] =!= "generated" &];
   <|
    "status" -> If[failureQ, "failed", "generated"],
    "caseName" -> Lookup[topo, "name", Missing["caseName"]],
    "variables" -> generators,
    "variableCount" -> Length[generators],
    "integral" -> int,
    "equationCount" -> Length[results],
    "equations" -> results,
    "allCanonicalQ" -> And @@ Lookup[results, "canonicalQ", True],
    "failedVariables" -> Lookup[Select[results, Lookup[#, "status", "failed"] =!= "generated" &], "userVariable", {}]
    |>
   ];


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
   {baseIntegral, continuousDataByGenerator, continuousCounts, commonContinuousQ, legacyContinuousCount,
    legacyContinuousRules, discreteData, momentumGenerators, equationCount,
    maxEquationCount, genTemplates, equations, pendingFeatures, topologyReport},
   topologyReport = topologyValidationReport[topo];
   If[topologyValidationErrorQ[topologyReport],
    Return[<|"status" -> "invalidTopology", "caseName" -> topo["name"], "topologyValidationReport" -> topologyReport, "equations" -> {}|>]
    ];
   baseIntegral = makeBaseIntegral[topo];
   discreteData = selectedDiscreteSeedRules[
     topo,
     DiscreteMode -> OptionValue[DiscreteMode],
     MaxDiscreteRuleCount -> OptionValue[MaxDiscreteRuleCount]
     ];
   If[discreteData["status"] =!= "generated",
    Return[Join[discreteData, <|"caseName" -> topo["name"], "topologyValidationReport" -> topologyReport, "equations" -> {}|>]]
   ];
   momentumGenerators = Select[makeIBPGenerators[topo], #["type"] === "momentum" &];
   continuousDataByGenerator = Table[
     With[{label = momentumGeneratorLabel[generator]},
      Join[
       <|"generator" -> label|>,
       makeGeneratorContinuousSeedRules[
        topo,
        label,
        UseSampleOnly -> OptionValue[UseSampleOnly],
        MaxSeedRuleCount -> OptionValue[MaxSeedRuleCount]
        ]
       ]
      ],
     {generator, momentumGenerators}
     ];
   If[AnyTrue[continuousDataByGenerator, Lookup[#, "status", "missing"] =!= "generated" &],
    Return[<|"status" -> "invalidGeneratorSeedRanges", "caseName" -> topo["name"], "topologyValidationReport" -> topologyReport,
      "generatorContinuousSeedData" -> (KeyDrop[#, "rules"] & /@ continuousDataByGenerator), "equations" -> {}|>]
    ];
   continuousCounts = Lookup[continuousDataByGenerator, "ruleCount", 0];
   commonContinuousQ = Length[continuousDataByGenerator] == 0 || SameQ @@ Lookup[continuousDataByGenerator, "rules", {}];
   legacyContinuousCount = If[Length[continuousCounts] == 0, 0, If[commonContinuousQ, First[continuousCounts], Total[continuousCounts]]];
   legacyContinuousRules = If[Length[continuousDataByGenerator] > 0 && commonContinuousQ, First[Lookup[continuousDataByGenerator, "rules"]], {}];
   equationCount = Total[continuousCounts] discreteData["ruleCount"];
   maxEquationCount = resolveSeedOption[topo, "MaxEquationCount", OptionValue[MaxEquationCount], 80];
   If[equationCount > maxEquationCount,
    Message[makeMomentumIBPSeedBatch::toomany, topo["name"], equationCount, maxEquationCount];
    Return[<|
      "status" -> "tooMany",
      "caseName" -> topo["name"],
      "topologyValidationReport" -> topologyReport,
      "continuousSeedRuleCount" -> legacyContinuousCount,
      "generatorContinuousSeedData" -> (KeyDrop[#, "rules"] & /@ continuousDataByGenerator),
      "discreteRuleCount" -> discreteData["ruleCount"],
      "momentumGeneratorCount" -> Length[momentumGenerators],
      "equationCount" -> equationCount,
      "equations" -> {}
      |>]
   ];
   genTemplates = MapThread[
     <|"generatorData" -> #1, "generator" -> momentumGeneratorLabel[#1],
       "template" -> applyMomentumGeneratorSeed[topo, baseIntegral, #1], "continuousData" -> #2|> &,
     {momentumGenerators, continuousDataByGenerator}
     ];
   If[MemberQ[Lookup[genTemplates, "template"], $Failed], Return[<|"status" -> "failed", "caseName" -> topo["name"], "topologyValidationReport" -> topologyReport|>]];
   pendingFeatures = momentumIBPPendingFeatures[topo];
   equations = Flatten[
     Table[
      Module[{rules = Join[continuousRule, discreteRule], expr},
       expr = genTemplate["template"] /. rules;
       expr = applySeedCanonical[expr, topo];
       If[TrueQ[OptionValue[ApplyNumericRules]], expr = expr /. topo["numericRules"]];
       <|
        "generator" -> genTemplate["generator"],
        "continuousRules" -> continuousRule,
        "discreteRules" -> discreteRule,
        "equation" -> Expand[expr],
        "forbiddenNData" -> forbiddenNData[topo, expr],
        "eomCanonicalQ" -> ! containsForbiddenNQ[topo, expr]
        |>
       ],
      {genTemplate, genTemplates},
      {continuousRule, genTemplate["continuousData"]["rules"]},
      {discreteRule, discreteData["rules"]}
      ],
     2
     ];
   <|
    "status" -> "generated",
    "caseName" -> topo["name"],
    "topologyValidationReport" -> topologyReport,
    "continuousSeedRuleCount" -> legacyContinuousCount,
    "continuousSeedRuleCountTotal" -> Total[continuousCounts],
    "discreteRuleCount" -> discreteData["ruleCount"],
    "momentumGeneratorCount" -> Length[momentumGenerators],
    "equationCount" -> Length[equations],
    "eomCanonicalQ" -> And @@ Lookup[equations, "eomCanonicalQ"],
    "forbiddenNData" -> DeleteCases[Flatten[Lookup[equations, "forbiddenNData"]], Null],
    "generators" -> momentumGeneratorLabel /@ momentumGenerators,
    "continuousSeedRules" -> legacyContinuousRules,
    "generatorSpecificContinuousRangesQ" -> AnyTrue[continuousDataByGenerator, Lookup[#, "rangeSource", "uniform"] === "generatorOverride" &],
    "generatorContinuousSeedData" -> (KeyDrop[#, "rules"] & /@ continuousDataByGenerator),
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
      "externalLegMomenta" -> Lookup[topo, "externalLegMomenta", {}],
      "kinematicRules" -> Lookup[topo, "kinematicRules", Automatic],
     "rawExternalInvariantRules" -> Lookup[topo, "rawExternalInvariantRules", topo["externalInvariantRules"]],
     "externalInvariantRules" -> topo["externalInvariantRules"],
     "rawExternalLegInvariantRules" -> Lookup[topo, "rawExternalLegInvariantRules", Automatic],
     "externalLegInvariantRules" -> Lookup[topo, "externalLegInvariantRules", {}],
     "ispData" -> topo["ispData"],
     "rawNumericRules" -> Lookup[topo, "rawNumericRules", userNumericRules[topo]],
     "numericRules" -> userNumericRules[topo],
     "sampleDiscreteRules" -> topo["sampleDiscreteRules"],
     "seedRanges" -> topo["seedRanges"],
     "generatorSeedRanges" -> Lookup[topo, "generatorSeedRanges", {}],
     "zeroPointRules" -> newZeroPointRules,
     "shrinkPrefactorRules" -> topo["shrinkPrefactorRules"],
     "symmetryRules" -> topo["symmetryRules"],
     "thetaBoundarySignOffset" -> topo["thetaBoundarySignOffset"],
     "kiraOrdering" -> topo["kiraOrdering"],
     "sectorVertexRepresentativeMap" -> repMap,
     "activeVertexIds" -> activeVertices,
     "fixedAVertexValues" -> fixedA,
     "sectorShrunkLines" -> shrunkLines
     |>;
   sectorTopo = Join[parseTopology[newCase], <|"sectorShrunkLines" -> shrunkLines|>];
   Join[sectorTopo, <|
    "sectorMetadata" -> makeSectorMetadata[sectorTopo],
    "tadpoleSymmetryData" -> tadpoleSymmetryData[sectorTopo],
    "effectiveSymmetryRules" -> effectiveSymmetryRules0[sectorTopo],
    "sampleDiscreteRules" -> filterSampleDiscreteRulesForTopology[topo["sampleDiscreteRules"], sectorTopo]
    |>]
   ];


massiveFullLineIndices[topo_Association] := Flatten@Position[Lookup[topo["lines"], "packType"], "massiveFull"];


masslessFullLineIndices[topo_Association] := Flatten@Position[Lookup[topo["lines"], "packType"], "masslessFull"];


thetaFullLineIndices[topo_Association] := Sort @ Join[
   massiveFullLineIndices[topo],
   masslessFullLineIndices[topo]
   ];


contactReachableShrinkSubsets[topo_Association] := Module[
   {lines = thetaFullLineIndices[topo], queue = {{}}, seen = <||>, result = {},
    state, pairs, repMap, eligible, bundles, events, newState, key},
   AssociateTo[seen, ToString[{}, InputForm] -> True];
   While[queue =!= {},
    state = First[queue];
    queue = Rest[queue];
    pairs = topo["lines"][[#, "endpoints"]] & /@ state;
    repMap = vertexRepresentativeMap[topo["vertexIds"], pairs];
    eligible = Select[
      Complement[lines, state],
      ! SameQ @@ Lookup[repMap, topo["lines"][[#, "endpoints"]]] &
      ];
    bundles = GatherBy[
      eligible,
      Sort[vertexPosition[topo, #] & /@ Lookup[repMap, topo["lines"][[#, "endpoints"]]]] &
      ];
    events = Flatten[Select[Rest[Subsets[#]], OddQ[Length[#]] &] & /@ bundles, 1];
    Do[
     newState = Sort[Union[state, event]];
     key = ToString[newState, InputForm];
     If[! KeyExistsQ[seen, key],
      AssociateTo[seen, key -> True];
      AppendTo[result, newState];
      AppendTo[queue, newState]
      ],
     {event, events}
     ];
    ];
   SortBy[result, {Length[#], #} &]
   ];


shrinkSectorSubsets[topo_Association, maxDepthSpec_, maxCount_Integer] := Module[
   {lines = thetaFullLineIndices[topo], maxDepth, allSubsets, subsets},
   If[lines === {}, Return[<|"status" -> "generated", "subsets" -> {}, "completeCoverageQ" -> True|>]];
   maxDepth = If[maxDepthSpec === Automatic || maxDepthSpec === All || maxDepthSpec === Infinity,
     Length[lines],
     Min[Length[lines], maxDepthSpec]
     ];
   allSubsets = contactReachableShrinkSubsets[topo];
   subsets = Select[allSubsets, Length[#] <= maxDepth &];
   If[Length[subsets] > maxCount,
    Return[<|"status" -> "tooMany", "subsets" -> {}, "requestedSubsetCount" -> Length[subsets], "maxCount" -> maxCount, "completeCoverageQ" -> False|>]
    ];
   <|"status" -> "generated", "subsets" -> subsets, "completeCoverageQ" -> TrueQ[Length[subsets] === Length[allSubsets]]|>
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
        "bundleMode" -> "commonThetaOddSubsetContacts"
       |>,
      Nothing
      ] &,
    grouped
    ]
   ];


masslessEndpointConventionData[topo_Association] := MapIndexed[
   <|
     "lineIndex" -> First[#2],
     "lineId" -> #1["id"],
     "orderedEndpoints" -> #1["endpoints"],
     "n1ReferenceEndpoint" -> #1["endpoints"][[1]],
     "n1OppositeEndpoint" -> #1["endpoints"][[2]],
     "convention" -> "n=1 is the antisymmetric state defined by the first endpoint; swapping endpoints flips n=1"
     |> &,
   Select[topo["lines"], #["packType"] === "masslessFull" &]
   ];


unsupportedSeedFeaturesForTopology[topo_Association] := DeleteDuplicates@Join[
    {}
    ];


topologyValidationReport[topo_Association] := Module[
   {issues = {}, appendIssue, vertexIds, lineIds, packTypes, allowedPackTypes,
     duplicateLoopMomenta, duplicateExternalMomenta, duplicateExternalLegMomenta,
     loopExternalMomentumOverlap, externalLegMomentumOverlap,
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
     missingLineParameters, numericRequirementReport, pendingFeatures, ruleData, kinematicAudit},
   appendIssue[severity_, code_, data_: <||>] := AppendTo[issues, Join[<|"severity" -> severity, "code" -> code|>, data]];
   vertexIds = topo["vertexIds"];
   vertexSigns = topo["vertexData"][[All, 2]];
   activeVertexIds = Lookup[topo, "activeVertexIds", vertexIds];
   fixedAVertexIds = Keys[Lookup[topo, "fixedAVertexValues", <||>]];
   extLegs = Lookup[topo, "extLegs", {}];
   vertexEnergies = Lookup[topo, "vertexEnergies", <||>];
   kinematicAudit = Lookup[topo, "kinematicCoordinateAudit", <||>];
   ispNames = Lookup[topo["ispData"], "name", {}];
   seedRangeData = KeyDrop[topo["seedRanges"], {"sampleOnly"}];
   If[Lookup[kinematicAudit, "status", "complete"] === "incomplete",
    appendIssue["error", "incompleteKinematicCoordinates", <|
      "coordinateRank" -> Lookup[kinematicAudit, "coordinateRank", Missing["rank"]],
      "parameterRank" -> Lookup[kinematicAudit, "parameterRank", Missing["parameterRank"]],
      "baseCoordinateCount" -> Lookup[kinematicAudit, "baseCoordinateCount", Missing["count"]],
      "missingDirections" -> Lookup[kinematicAudit, "missingDirections", {}],
      "parameterMissingDirections" -> Lookup[kinematicAudit, "parameterMissingDirections", {}],
      "unsupportedRulePositions" -> Lookup[kinematicAudit, "unsupportedRulePositions", {}]
      |>]
    ];
   If[Lookup[kinematicAudit, "status", "complete"] === "overcomplete",
    appendIssue["warning", "overcompleteKinematicCoordinates", <|
      "constraintResiduals" -> Lookup[kinematicAudit, "constraintResiduals", {}],
      "ruleDependencies" -> Lookup[kinematicAudit, "ruleDependencies", {}],
      "comment" -> "IBP generation may continue, but inverse conversion and ds in the redundant coordinates are disabled until the family definition supplies the constraints."
      |>]
    ];
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
   duplicateExternalLegMomenta = Cases[Tally[Lookup[topo, "externalLegMomenta", {}]], {mom_, count_} /; count > 1 :> mom];
   If[duplicateExternalLegMomenta =!= {},
    appendIssue["error", "duplicateExternalLegMomenta", <|"externalLegMomenta" -> Lookup[topo, "externalLegMomenta", {}], "duplicates" -> duplicateExternalLegMomenta|>]
    ];
   loopExternalMomentumOverlap = Intersection[topo["loopMomenta"], topo["externalMomenta"]];
   If[loopExternalMomentumOverlap =!= {},
    appendIssue["error", "loopExternalMomentumOverlap", <|"overlap" -> loopExternalMomentumOverlap, "loopMomenta" -> topo["loopMomenta"], "externalMomenta" -> topo["externalMomenta"]|>]
    ];
   externalLegMomentumOverlap = Intersection[
     Lookup[topo, "externalLegMomenta", {}],
     Join[topo["loopMomenta"], topo["externalMomenta"]]
     ];
   If[externalLegMomentumOverlap =!= {},
    appendIssue["error", "externalLegMomentumOverlap", <|"overlap" -> externalLegMomentumOverlap|>]
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
   declaredMomentumVars = DeleteDuplicates@Join[
     topo["loopMomenta"], topo["externalMomenta"], Lookup[topo, "externalLegMomenta", {}]
     ];
   undeclaredMomentumVars = Complement[lineMomentumVars, declaredMomentumVars];
   If[undeclaredMomentumVars =!= {},
    appendIssue["error", "undeclaredMomentumVariables", <|"variables" -> undeclaredMomentumVars, "declared" -> declaredMomentumVars|>]
    ];
   nonLinearLineMomentumData = lineMomentumLinearityIssues[topo];
   If[nonLinearLineMomentumData =!= {},
    appendIssue["error", "nonLinearLineMomenta", <|"issues" -> nonLinearLineMomentumData, "comment" -> "line momenta must be linear combinations of loopMomenta, externalMomenta and declared externalLegMomenta"|>]
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
    "tadpoleSymmetryData" -> tadpoleSymmetryData[topo],
    "effectiveSymmetryRules" -> effectiveSymmetryRules0[topo],
    "masslessBundleCandidates" -> masslessBundleCandidates[topo],
     "masslessEndpointConventions" -> masslessEndpointConventionData[topo],
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
     <|"status" -> "skipped", "caseName" -> topo["name"], "topologyValidationReport" -> topologyReport, "sectorMetadataList" -> {}, "equationCount" -> 0, "eomCanonicalQ" -> True, "forbiddenNData" -> {}, "pendingFeatures" -> If[thetaFullLineIndices[topo] === {}, {}, {"shrinkSectorSeedGeneration"}], "equations" -> {}|>
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

kiraBackendSymbol[name_String] := Symbol["Global`" <> name];


(* Kira/Fermat 只接收小写原子变量；原始 Mathematica 变量可以是 kk[1,1] 这类非原子表达式。 *)
kiraCoefficientVariableMap[variables_List] := MapIndexed[
   <|"original" -> #1, "backend" -> ("dsc" <> ToString[First[#2]])|> &,
   variables
   ];


(* Fermat 的 user-system 文本不直接接收 Sqrt 等分数幂。把这些代数生成元先整体视为
   扩大有理函数域中的独立原子；importer 再按 manifest 恢复原 Mathematica 表达式。 *)
kiraCoefficientAlgebraicGenerators[coefficients_List] := SortBy[
   DeleteDuplicates @ Cases[
     coefficients,
     (power : Power[_, exponent_Rational] /; Denominator[exponent] > 1) :> power,
     Infinity
     ],
   ToString[InputForm[#]] &
   ];


kiraBackendCoefficientRules[variableMap_List] := Join[
   (Lookup[#, "original"] -> kiraBackendSymbol[Lookup[#, "backend"]]) & /@ variableMap
   ];


(* Mathematica 将 -I 和一般有理复数保存为不可再向下匹配的 Complex 原子，
   因此必须先把每个 Gaussian numeric atom 显式写成 a+b dsii，再替换其它系数原子。 *)
kiraBackendCoefficientExpression[expr_, variableMap_List] :=
   (expr /. value_Complex :> Re[value] + Im[value] kiraBackendSymbol["dsii"]) /.
    kiraBackendCoefficientRules[variableMap];


kiraCoefficientString[expr_, variableMap_List] := StringReplace[
   ToString[kiraBackendCoefficientExpression[expr, variableMap], InputForm],
   WhitespaceCharacter .. -> ""
   ];
kiraCoefficientString[expr_] := kiraCoefficientString[expr, {}];


kiraBackendCoefficientStringQ[text_String] := StringMatchQ[
   text,
   RegularExpression["[a-z0-9_+\\-*/^().]+"]
   ];


kiraBackendCoefficientSyntaxReport[linearEquations_List, variableMap_List] := Module[
   {coefficients, strings, badPositions},
   coefficients = Last /@ Flatten[kiraNonzeroCoefficientRules[#["coefficientRules"]] & /@ linearEquations];
   strings = kiraCoefficientString[#, variableMap] & /@ coefficients;
   badPositions = Flatten@Position[strings, text_ /; ! kiraBackendCoefficientStringQ[text], {1}, Heads -> False];
   <|
    "status" -> If[badPositions === {}, "valid", "invalid"],
    "coefficientCount" -> Length[strings],
    "badPositions" -> badPositions,
    "badStrings" -> Lookup[AssociationThread[Range[Length[strings]] -> strings], badPositions, {}]
    |>
   ];


kiraNonzeroCoefficientRules[coefficientRules_List] := Select[
   (First[#] -> Cancel[Last[#]]) & /@ coefficientRules,
   ! TrueQ[Last[#] === 0] &
   ];


kiraEquationBlock[linearEquation_Association, coefficientRules_List, variableMap_List : {}] := Module[
   {nonzeroRules},
   nonzeroRules = kiraNonzeroCoefficientRules[coefficientRules];
   If[nonzeroRules === {}, Return[""]];
   StringRiffle[ToString[First[#]] <> "*(" <> kiraCoefficientString[Last[#], variableMap] <> ")" & /@ nonzeroRules, "\n"] <> "\n\n"
   ];


kiraNumericCoefficientSystemQ[linearEquations_List] := Module[
   {coefficients},
   coefficients = Last /@ Flatten[kiraNonzeroCoefficientRules[#["coefficientRules"]] & /@ linearEquations];
   coefficients =!= {} && And @@ (TrueQ[NumericQ[#]] & /@ coefficients)
   ];


linearCoefficientDiagnostics[linearEquations_List] := Module[
   {coefficients, algebraicGenerators, ordinaryVariables, coefficientVariables},
   coefficients = Last /@ Flatten[kiraNonzeroCoefficientRules[#["coefficientRules"]] & /@ linearEquations];
   algebraicGenerators = kiraCoefficientAlgebraicGenerators[coefficients];
   ordinaryVariables = DeleteDuplicates[Variables[coefficients]];
   coefficientVariables = DeleteDuplicates[Join[algebraicGenerators, ordinaryVariables]];
   <|
    "numericCoefficientSystemQ" -> TrueQ[coefficients =!= {} && And @@ (TrueQ[NumericQ[#]] & /@ coefficients)],
    "coefficientVariables" -> coefficientVariables,
    "coefficientAlgebraicGenerators" -> algebraicGenerators
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
   "WriteRunScript" -> False,
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
    numericDummyIntegralId, targetData, targetIntegralCount, kiraBlockCount, numericDummySymbol, rawCoeffRules, normalizedCoeffRules,
    coefficientVariableMap, backendCoefficientVariables, imaginaryUnitUsedQ, backendSyntaxReport},
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
   coefficientVariableMap = kiraCoefficientVariableMap[coefficientDiagnostics["coefficientVariables"]];
   imaginaryUnitUsedQ = ! FreeQ[
      Last /@ Flatten[kiraNonzeroCoefficientRules[#["coefficientRules"]] & /@ exportedEquations],
      _Complex
      ];
   backendCoefficientVariables = Join[
      Lookup[coefficientVariableMap, "backend", {}],
      If[imaginaryUnitUsedQ, {"dsii"}, {}]
      ];
   backendSyntaxReport = kiraBackendCoefficientSyntaxReport[exportedEquations, coefficientVariableMap];
   If[Lookup[backendSyntaxReport, "status", "invalid"] =!= "valid",
    Return[<|
      "status" -> "invalidBackendCoefficientSyntax",
      "reason" -> "Kira/Fermat coefficients must contain only lowercase atomic variables and rational operators",
      "coefficientVariableMap" -> coefficientVariableMap,
      "backendCoefficientSyntaxReport" -> backendSyntaxReport,
      "topologyValidationReport" -> topologyReport
      |>]
    ];
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
   ibpText = StringJoin[kiraEquationBlock[#, #["coefficientRules"], coefficientVariableMap] & /@ exportedEquations] <>
     If[appendNumericDummyQ, kiraDummyEquationBlock[numericDummyIntegralId, numericDummySymbol], ""];
   listText = StringRiffle[ToString /@ targetData["targetIDs"], "\n"] <> "\n";
   jobsText = kiraJobsYAML[normalizedJobOptions];
   runScriptText = If[TrueQ[Lookup[normalizedJobOptions, "WriteRunScript", False]], kiraRunScript[normalizedJobOptions], Missing["RunScriptDisabled"]];
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
         "coefficientAlgebraicGenerators" -> coefficientDiagnostics["coefficientAlgebraicGenerators"],
         "coefficientVariableMap" -> coefficientVariableMap,
         "backendCoefficientVariables" -> backendCoefficientVariables,
         "backendImaginaryUnit" -> If[imaginaryUnitUsedQ, "dsii", None],
         "backendCoefficientSyntaxReport" -> backendSyntaxReport,
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
    "coefficientAlgebraicGenerators" -> coefficientDiagnostics["coefficientAlgebraicGenerators"],
    "coefficientVariableMap" -> coefficientVariableMap,
    "backendCoefficientVariables" -> backendCoefficientVariables,
    "backendImaginaryUnit" -> If[imaginaryUnitUsedQ, "dsii", None],
    "backendCoefficientSyntaxReport" -> backendSyntaxReport,
    "numericDummyAppendedQ" -> appendNumericDummyQ,
    "numericDummyIntegralId" -> numericDummyIntegralId,
    "kiraCoefficientRulesApplied" -> normalizedCoeffRules,
    "userKiraCoefficientRulesApplied" -> userCoefficientRulesForLinearData[normalizedCoeffRules, linearData]
    |>
   ];


(* Kira 的 Linux user-system parser 会把 CRLF 空行误读为非空方程；所有后端文本固定写成无 BOM UTF-8/LF。 *)
writeKiraUTF8LFText[path_String, text_String] := Module[{stream, normalized, bytes},
   normalized = StringReplace[text, {"\r\n" -> "\n", "\r" -> "\n"}];
   bytes = ToCharacterCode[normalized, "UTF8"];
   stream = OpenWrite[path, BinaryFormat -> True];
   BinaryWrite[stream, bytes, "Byte"];
   Close[stream];
   path
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
   KeyValueMap[writeKiraUTF8LFText, files];
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
    "coefficientAlgebraicGenerators" -> Lookup[strings, "coefficientAlgebraicGenerators", {}],
    "coefficientVariableMap" -> Lookup[strings, "coefficientVariableMap", {}],
    "backendCoefficientVariables" -> Lookup[strings, "backendCoefficientVariables", {}],
    "backendImaginaryUnit" -> Lookup[strings, "backendImaginaryUnit", None],
    "backendCoefficientSyntaxReport" -> Lookup[strings, "backendCoefficientSyntaxReport", <||>],
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
   equations = symmetry[Lookup[batch, "equations", {}], topo];
   If[equations === $Failed,
    Return[<|"status" -> "notReady", "caseName" -> Lookup[batch, "caseName", Missing["caseName"]], "topologyValidationReport" -> topologyReport, "reason" -> "invalidSymmetryRules"|>]
    ];
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
    "tadpoleSymmetryData" -> tadpoleSymmetryData[topo],
    "effectiveSymmetryRules" -> effectiveSymmetryRules0[topo],
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

(* ::Chapter:: *)
(*010 公开原子 API 与表示转换*)

(* J 本身不携带 topology；公开短签名必须使用显式注册的 context，不能从指标形状猜测物理类型。 *)
If[! ValueQ[$dSIBPTopologyContext], $dSIBPTopologyContext = Missing["NotSet"]];


dSIBPPublicAPI::notopo =
   "公开 API 缺少 topology context。请使用显式 topo 参数，或先调用 setIBPTopologyContext[topo]。";
dSIBPPublicAPI::badtopo = "topology context 无效或解析失败：`1`。";
dSIBPPublicAPI::badshape = "表达式中的 J 与 topology context 不兼容：`1`。";
dSIBPPublicAPI::badstate = "IBP 公开算子要求所有 full-line 离散态已显式取 0/1：`1`。";
dSIBPPublicAPI::badgen = "找不到请求的 IBP 生成元：`1`。";
dSIBPPublicAPI::badvar = "变量 `1` 不在当前 topology 初始化的外部独立变量列表 `2` 中。";
dSIBPPublicAPI::ambiguousvar = "变量 `1` 属于过完备动力学坐标；在 family 定义中补充约束并重选独立变量前，ds 已禁用。";
dSIBPPublicAPI::noinverse = "当前动力学规则没有唯一的用户坐标到基础标量积反向映射；rep2innerform 已拒绝。审计：`1`。";
dSIBPPublicAPI::nonlinear = "ds 只接受 J 的线性组合；检测到非线性或非多项式 J 依赖：`1`。";
dSIBPPublicAPI::derivativefailed = "变量 `1` 的积分导数生成失败。";


setIBPTopologyContext[spec_Association] := Module[{topo = normalizeTopologySpec[spec]},
   If[! parsedTopologyQ[topo],
    Message[dSIBPPublicAPI::badtopo, spec];
    Return[$Failed]
    ];
   $dSIBPTopologyContext = topo
   ];


clearIBPTopologyContext[] := ($dSIBPTopologyContext = Missing["NotSet"]);


resolvePublicTopologyContext[spec_: Automatic] := Module[{topo},
   topo = If[spec === Automatic, $dSIBPTopologyContext, normalizeTopologySpec[spec]];
   If[! parsedTopologyQ[topo],
    If[spec === Automatic,
     Message[dSIBPPublicAPI::notopo],
     Message[dSIBPPublicAPI::badtopo, spec]
     ];
    Return[$Failed]
    ];
   topo
   ];


publicExpectedPackLength[packType_String] := Switch[packType,
   "massiveFull" | "massiveCross", 3,
   "masslessFull", 2,
   "masslessCross" | "shrunk", 1,
   _, Missing["UnknownPackType", packType]
   ];


publicIntegralShapeIssues[topo_Association, J[aList_, linePacks_, ispList_]] := Module[
   {issues = {}, expected, packType},
   If[Length[aList] =!= Length[activeAVertexIds[topo]],
    AppendTo[issues, <|"slot" -> "aList", "expected" -> Length[activeAVertexIds[topo]], "actual" -> Length[aList]|>]
    ];
   If[Length[linePacks] =!= topo["nE"],
    AppendTo[issues, <|"slot" -> "linePacks", "expected" -> topo["nE"], "actual" -> Length[linePacks]|>],
    Do[
     If[! ListQ[linePacks[[e]]],
      AppendTo[issues, <|"slot" -> "linePack", "lineIndex" -> e, "reason" -> "notList"|>],
      packType = actualLinePackType[topo, e, linePacks[[e]]];
      expected = publicExpectedPackLength[packType];
      If[Head[expected] === Missing || Length[linePacks[[e]]] =!= expected,
       AppendTo[issues, <|"slot" -> "linePack", "lineIndex" -> e, "packType" -> packType, "expected" -> expected, "actual" -> Length[linePacks[[e]]]|>]
       ]
      ],
     {e, Length[linePacks]}
     ]
    ];
   If[Length[ispList] =!= Length[topo["ispData"]],
    AppendTo[issues, <|"slot" -> "ispList", "expected" -> Length[topo["ispData"]], "actual" -> Length[ispList]|>]
    ];
   issues
   ];


publicResolvedDiscreteStateIssues[topo_Association, J[aList_, linePacks_, ispList_]] := Module[
   {issues = {}, packType, pack},
   If[Length[linePacks] =!= topo["nE"], Return[issues]];
   Do[
    pack = linePacks[[e]];
    If[ListQ[pack],
     packType = actualLinePackType[topo, e, pack];
     Switch[packType,
      "massiveFull" | "massiveCross",
      Do[If[! MemberQ[{0, 1}, pack[[p]]], AppendTo[issues, <|"lineIndex" -> e, "packType" -> packType, "packPosition" -> p, "value" -> pack[[p]]|>]], {p, 2, 3}],
      "masslessFull",
      If[! MemberQ[{0, 1}, pack[[2]]], AppendTo[issues, <|"lineIndex" -> e, "packType" -> packType, "packPosition" -> 2, "value" -> pack[[2]]|>]],
      _, Null
      ]
     ],
    {e, Length[linePacks]}
    ];
   issues
   ];


publicExpressionIntegrals[expr_] := DeleteDuplicates[Cases[expr, _J, {0, Infinity}]];


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


publicLoopIndex[topo_Association, item_] := Which[
   IntegerQ[item] && 1 <= item <= topo["nL"], item,
   MemberQ[topo["loopMomenta"], item], First@FirstPosition[topo["loopMomenta"], item],
   True, Missing["LoopMomentumNotFound", item]
   ];


publicExternalIndex[topo_Association, item_] := Which[
   IntegerQ[item] && 1 <= item <= topo["nK"], item,
   MemberQ[topo["externalMomenta"], item], First@FirstPosition[topo["externalMomenta"], item],
   True, Missing["ExternalMomentumNotFound", item]
   ];


publicApplyIBPGenerator[expr_, topo_Association, gen_Association] := Module[{result},
   If[! validatePublicExpression[expr, topo, True], Return[$Failed]];
   result = Expand[expr /. int_J :> If[
        gen["type"] === "time",
        applyTimeGeneratorSeed[topo, int, gen],
        applyMomentumGeneratorSeed[topo, int, gen]
        ]];
   If[! FreeQ[result, $Failed], Return[$Failed]];
   applySeedCanonical[result, topo]
   ];


dtau[vertex_, expr_, topoSpec_Association] := Module[{topo, gen},
   topo = resolvePublicTopologyContext[topoSpec];
   If[topo === $Failed, Return[$Failed]];
   gen = SelectFirst[makeIBPGenerators[topo], #1["type"] === "time" && #1["vertex"] === vertex &, Missing["NotFound"]];
   If[Head[gen] === Missing, Message[dSIBPPublicAPI::badgen, {"dtau", vertex}]; Return[$Failed]];
   publicApplyIBPGenerator[expr, topo, gen]
   ];
dtau[vertex_, expr_] := Module[{topo = resolvePublicTopologyContext[]},
   If[topo === $Failed, $Failed, dtau[vertex, expr, topo]]
   ];


dqq[dLoop_, vectorLoop_, expr_, topoSpec_Association] := Module[{topo, i, j, gen},
   topo = resolvePublicTopologyContext[topoSpec];
   If[topo === $Failed, Return[$Failed]];
   i = publicLoopIndex[topo, dLoop];
   j = publicLoopIndex[topo, vectorLoop];
   If[Head[i] === Missing || Head[j] === Missing, Message[dSIBPPublicAPI::badgen, {"dqq", dLoop, vectorLoop}]; Return[$Failed]];
   gen = <|"type" -> "momentum", "dLoop" -> i, "vectorType" -> "loop", "vectorIndex" -> j, "vector" -> topo["loopMomenta"][[j]]|>;
   publicApplyIBPGenerator[expr, topo, gen]
   ];
dqq[dLoop_, vectorLoop_, expr_] := Module[{topo = resolvePublicTopologyContext[]},
   If[topo === $Failed, $Failed, dqq[dLoop, vectorLoop, expr, topo]]
   ];


dqk[dLoop_, vectorExternal_, expr_, topoSpec_Association] := Module[{topo, i, j, gen},
   topo = resolvePublicTopologyContext[topoSpec];
   If[topo === $Failed, Return[$Failed]];
   i = publicLoopIndex[topo, dLoop];
   j = publicExternalIndex[topo, vectorExternal];
   If[Head[i] === Missing || Head[j] === Missing, Message[dSIBPPublicAPI::badgen, {"dqk", dLoop, vectorExternal}]; Return[$Failed]];
   gen = <|"type" -> "momentum", "dLoop" -> i, "vectorType" -> "external", "vectorIndex" -> j, "vector" -> topo["externalMomenta"][[j]]|>;
   publicApplyIBPGenerator[expr, topo, gen]
   ];
dqk[dLoop_, vectorExternal_, expr_] := Module[{topo = resolvePublicTopologyContext[]},
   If[topo === $Failed, $Failed, dqk[dLoop, vectorExternal, expr, topo]]
   ];


publicProtectJMap[expr_, function_] := Module[{integrals, tokens, forward, backward},
   integrals = publicExpressionIntegrals[expr];
   tokens = Table[Unique["heldJ$"], {Length[integrals]}];
   forward = Thread[integrals -> tokens];
   backward = Thread[tokens -> integrals];
   function[expr /. forward] /. backward
   ];


userISPToInternalRules[topo_Association] := MapIndexed[
   Rule[Lookup[#1, "name", rho[First[#2]]], rho[First[#2]]] &,
   topo["ispData"]
   ];


internalISPToUserRules[topo_Association] := MapIndexed[
   Rule[rho[First[#2]], Lookup[#1, "name", rho[First[#2]]]] &,
   topo["ispData"]
   ];


rep2innerform[expr_, topoSpec_Association] := Module[{topo, audit},
   topo = resolvePublicTopologyContext[topoSpec];
   If[topo === $Failed, Return[$Failed]];
   audit = Lookup[topo, "kinematicCoordinateAudit", <||>];
   If[AssociationQ[audit] && ! TrueQ[Lookup[audit, "inverseAvailableQ", True]],
    Message[dSIBPPublicAPI::noinverse, KeyTake[audit, {"status", "constraintResiduals", "parameterDependencies"}]];
    Return[$Failed]
    ];
   If[! validatePublicExpression[expr, topo], Return[$Failed]];
   publicProtectJMap[expr, Function[body,
     Expand[scalarProductInputToInternal[body, topo] /. userISPToInternalRules[topo]]
     ]]
   ];
rep2innerform[expr_] := Module[{topo = resolvePublicTopologyContext[]},
   If[topo === $Failed, $Failed, rep2innerform[expr, topo]]
   ];


rep2outform[expr_, topoSpec_Association] := Module[{topo},
   topo = resolvePublicTopologyContext[topoSpec];
   If[topo === $Failed, Return[$Failed]];
   If[! validatePublicExpression[expr, topo], Return[$Failed]];
   publicProtectJMap[expr, Function[body,
     Expand[scalarProductInternalToUser[body /. internalISPToUserRules[topo], topo]]
     ]]
   ];
rep2outform[expr_] := Module[{topo = resolvePublicTopologyContext[]},
   If[topo === $Failed, $Failed, rep2outform[expr, topo]]
   ];


(* ::Section:: *)
(*外部动力学变量总导数*)

(* ds 的变量必须使用 topology 初始化时的外部名称；内部 kk 坐标只在底层导数中出现。 *)
publicIndependentVariableDerivativeData[topo_Association] := makeIndependentVariableDerivativeGenerators[topo];


resolvePublicIndependentVariableDerivativeData[topo_Association, userVariable_] := SelectFirst[
   publicIndependentVariableDerivativeData[topo],
   SameQ[Lookup[#, "userVariable", Missing["userVariable"]], userVariable] &,
   Missing["UnknownIndependentVariable", userVariable]
   ];


(* 先把每个不同的 J 替成惰性 token；这样 D 只作用于显式系数，不会进入指标。 *)
publicLinearIntegralDecomposition[expr_] := Module[
   {expanded, integrals, tokens, forwardRules, backwardRules, heldExpression,
    constantTerm, coefficients, reconstructed},
   expanded = Expand[expr];
   integrals = publicExpressionIntegrals[expanded];
   tokens = Table[Unique["heldJ$"], {Length[integrals]}];
   forwardRules = Thread[integrals -> tokens];
   backwardRules = Thread[tokens -> integrals];
   heldExpression = Expand[expanded /. forwardRules];
   constantTerm = Expand[heldExpression /. Thread[tokens -> 0]];
   coefficients = Coefficient[heldExpression, #] & /@ tokens;
   reconstructed = Expand[constantTerm + Total[MapThread[#1 #2 &, {coefficients, tokens}]]];
   If[! TrueQ[Expand[heldExpression - reconstructed] === 0],
    Return[<|
      "status" -> "nonlinear",
      "heldExpression" -> heldExpression,
      "integrals" -> integrals
      |>]
    ];
   <|
    "status" -> "linear",
    "expression" -> expanded,
    "heldExpression" -> heldExpression,
    "integrals" -> integrals,
    "tokens" -> tokens,
    "coefficients" -> coefficients,
    "constantTerm" -> constantTerm,
    "backwardRules" -> backwardRules
    |>
   ];


(* 乘积法则：显式系数导数与每个 J 的指标导数分别生成，合并后再统一 canonical。 *)
ds[expr_, userVariable_, topoSpec_Association] := Module[
   {topo, variableData, userVariables, userExpr, linearData, internalVariable,
    coefficientDerivative, integralDerivativeTerms, result},
   topo = resolvePublicTopologyContext[topoSpec];
   If[topo === $Failed, Return[$Failed]];
   If[
    TrueQ[Lookup[Lookup[topo, "kinematicCoordinateAudit", <||>], "overcompleteQ", False]] &&
     MemberQ[Lookup[Lookup[topo, "kinematicCoordinateAudit", <||>], "selectedUserVariables", {}], userVariable],
    Message[dSIBPPublicAPI::ambiguousvar, userVariable];
    Return[$Failed]
    ];
   userVariables = Lookup[publicIndependentVariableDerivativeData[topo], "userVariable", {}];
   variableData = resolvePublicIndependentVariableDerivativeData[topo, userVariable];
   If[Head[variableData] === Missing,
    Message[dSIBPPublicAPI::badvar, userVariable, userVariables];
    Return[$Failed]
    ];
   userExpr = rep2outform[expr, topo];
   If[userExpr === $Failed || ! validatePublicExpression[userExpr, topo, True], Return[$Failed]];
   linearData = publicLinearIntegralDecomposition[userExpr];
   If[Lookup[linearData, "status", "failed"] =!= "linear",
    Message[dSIBPPublicAPI::nonlinear, Lookup[linearData, "heldExpression", userExpr]];
    Return[$Failed]
    ];
   internalVariable = variableData["variable"];
   coefficientDerivative = Expand[
     D[linearData["heldExpression"], userVariable] /. linearData["backwardRules"]
     ];
   integralDerivativeTerms = MapThread[
     Function[{coefficient, int},
      With[{term = applyIndependentVariableDerivativeSeed[topo, int, internalVariable]},
       If[term === $Failed, $Failed, coefficient term]
       ]
      ],
     {linearData["coefficients"], linearData["integrals"]}
     ];
   If[! FreeQ[integralDerivativeTerms, $Failed],
    Message[dSIBPPublicAPI::derivativefailed, userVariable];
    Return[$Failed]
    ];
   result = applySeedCanonical[
     Expand[coefficientDerivative + Total[integralDerivativeTerms]],
     topo
     ];
   If[result === $Failed, Return[$Failed]];
   rep2outform[result, topo]
   ];
ds[expr_, userVariable_] := Module[{topo = resolvePublicTopologyContext[]},
   If[topo === $Failed, $Failed, ds[expr, userVariable, topo]]
   ];


integrandVertexFactor[topo_Association, int_J] := Times @@ Table[
   With[{vertex = activeAVertexIds[topo][[slot]]},
    (-tau[vertex])^(int[[1, slot]] + vertexZeroPoint[topo, vertex])
     Exp[vertexExternalPhaseDerivativeCoefficient[topo, vertex] vertexExternalEnergy[topo, vertex] tau[vertex]]
    ],
   {slot, Length[activeAVertexIds[topo]]}
   ];


integrandBuildingBlock[line_Association, pack_List] := Module[
   {lineId = line["id"], endpoints = line["endpoints"], packType = line["packType"]},
   Switch[packType,
    "massiveFull" | "massiveCross",
    Hh[MassiveBlock[Lookup[line, "bbType", "h"], Lookup[line, "nu", nu], Lookup[line, "skType", "++"], lineId, endpoints, xi[lineId], pack[[2]], pack[[3]]]],
    "masslessFull",
    Hh[MasslessBlock[Lookup[line, "skType", "++"], lineId, endpoints, xi[lineId], pack[[2]]]],
    "masslessCross",
    Hh[MasslessCrossBlock[Lookup[line, "skType", "+-"], lineId, endpoints, xi[lineId]]],
    _, 1
    ]
   ];


integrandLineFactor[topo_Association, int_J, e_Integer] := Module[
   {line = topo["lines"][[e]], pack = int[[2, e]], packType, denominator},
   packType = actualLinePackType[topo, e, pack];
   denominator = xi[line["id"]]^(-linePowerIndex[topo, int, e]);
   If[packType === "shrunk", denominator, denominator integrandBuildingBlock[Join[line, <|"packType" -> packType|>], pack]]
   ];


integrandISPFactor[topo_Association, int_J] := Times @@ Table[
   Lookup[topo["ispData"][[j]], "name", rho[j]]^int[[3, j]],
   {j, Length[topo["ispData"]]}
   ];


integralToInertIntegrand[topo_Association, int_J] := Times[
   integrandVertexFactor[topo, int],
   Times @@ Table[integrandLineFactor[topo, int, e], {e, topo["nE"]}],
   integrandISPFactor[topo, int]
   ];


rep2Integrand[expr_, topoSpec_Association] := Module[{topo, result},
   topo = resolvePublicTopologyContext[topoSpec];
   If[topo === $Failed, Return[$Failed]];
   If[! validatePublicExpression[expr, topo], Return[$Failed]];
   result = Expand[expr /. int_J :> integralToInertIntegrand[topo, int]];
   rep2outform[result, topo]
   ];
rep2Integrand[expr_] := Module[{topo = resolvePublicTopologyContext[]},
   If[topo === $Failed, $Failed, rep2Integrand[expr, topo]]
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
   "ispData" -> {},
   "symmetryRules" -> {}
   |>;


(* 用户只有在确认 nu1==nu2 且相关外腿参数相等后，才可把交换规则放入 case。
   示例只展示输入形状；package 不自动检测这些物理条件。
   "symmetryRules" -> {
     HoldPattern[J[{av1_, av2_}, {pack1_, pack2_}, isp_]] :>
       J[{av2, av1}, {pack2, pack1}, isp]
     }
*)


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
   "masslessBundleMode" -> "perLinePacksCommonThetaContacts"
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
    "masslessEndpointConventions" -> masslessEndpointConventionData[topo],
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


(* ::Chapter:: *)
(*013 Tree 积分表示与 family metadata*)

(* 本章只处理单槽 J[vertexPacks]。tree 与 loop 共用 Head，但任何入口都先按 arity 分派；
   tree family 的 massiveLegs 顺序同时固定 binary master 顺序和矩阵 tensor 顺序。 *)

integralKind[J[_List, _List, _List]] := "Loop";
integralKind[J[packs_List]] := If[VectorQ[packs, ListQ], "Tree", $Failed];
integralKind[_] := $Failed;


makeTreeFamilyData::badinput = "tree family 输入无效：`1`。";
treeIntegralShape::badshape = "tree J 的 pack 形状与 family 不一致：`1`。";


treeSignedEnergy[vertex_Association] := Lookup[
   vertex,
   "signedEnergy",
   (* package 的 + 顶点相位为 Exp[-I E tau]，故论文 e^(I k0 tau) 中 k0=-E。 *)
   If[Lookup[vertex, "sign", "+"] === "+", -Lookup[vertex, "energy", 0], Lookup[vertex, "energy", 0]]
   ];


treeVertexIssues[vertex_Association] := Module[{issues = {}, legs, required, missing},
   required = {"id", "nu0", "energy", "massiveLegs"};
   missing = Complement[required, Keys[vertex]];
   If[missing =!= {}, AppendTo[issues, <|"code" -> "missingVertexKeys", "keys" -> missing|>]];
   If[! MemberQ[{"+", "-"}, Lookup[vertex, "sign", "+"]],
    AppendTo[issues, <|"code" -> "badVertexSign", "value" -> Lookup[vertex, "sign", Missing["sign"]]|>]
    ];
   legs = Lookup[vertex, "massiveLegs", {}];
   If[! ListQ[legs] || ! And @@ (AssociationQ /@ legs),
    AppendTo[issues, <|"code" -> "badMassiveLegs"|>],
    Do[
     missing = Complement[{"id", "nu", "energy"}, Keys[legs[[i]]]];
     If[missing =!= {}, AppendTo[issues, <|"code" -> "missingLegKeys", "leg" -> i, "keys" -> missing|>]],
     {i, Length[legs]}
     ]
    ];
   issues
   ];


makeTreeFamilyData[spec_Association] := Module[{vertices, issues, ids, normalized},
   vertices = Lookup[spec, "vertices", Missing["vertices"]];
   If[! ListQ[vertices] || ! And @@ (AssociationQ /@ vertices),
    Message[makeTreeFamilyData::badinput, {<|"code" -> "badVertices"|>}];
    Return[$Failed]
    ];
   issues = Flatten[treeVertexIssues /@ vertices];
   ids = Lookup[vertices, "id", Missing["id"]];
   If[DuplicateFreeQ[ids] =!= True, AppendTo[issues, <|"code" -> "duplicateVertexIds", "ids" -> ids|>]];
   If[issues =!= {}, Message[makeTreeFamilyData::badinput, issues]; Return[$Failed]];
   normalized = Map[
     Join[#, <|
         "signedEnergy" -> treeSignedEnergy[#],
         "p" -> Length[#"massiveLegs"]
         |>] &,
     vertices
     ];
   <|
    "status" -> "ready",
    "name" -> Lookup[spec, "name", "treeFamily"],
    "vertices" -> normalized,
    "vertexOrder" -> Lookup[normalized, "id"],
    "packLengths" -> (1 + Lookup[normalized, "p"]),
    "sector" -> Lookup[spec, "sector", "top"],
    "sourceStructure" -> Lookup[spec, "sourceStructure", {}],
    "topology" -> Lookup[spec, "topology", Missing["NoLoopTopology"]],
    "requiresSourceRules" -> TrueQ[Lookup[spec, "requiresSourceRules", False]],
    "loopBaselinePowers" -> Lookup[spec, "loopBaselinePowers", <||>]
    |>
   ];


treeIntegralShapeIssues[int_J, data_Association] := Module[{packs, expected, issues = {}},
   If[integralKind[int] =!= "Tree", Return[{<|"code" -> "notTreeIntegral", "integral" -> int|>}]];
   packs = First[int];
   expected = data["packLengths"];
   If[Length[packs] =!= Length[expected],
    Return[{<|"code" -> "vertexCount", "expected" -> Length[expected], "actual" -> Length[packs]|>}]
    ];
   Do[
    If[! ListQ[packs[[i]]] || Length[packs[[i]]] =!= expected[[i]],
     AppendTo[issues, <|"code" -> "packLength", "vertex" -> data["vertexOrder"][[i]], "expected" -> expected[[i]], "actual" -> If[ListQ[packs[[i]]], Length[packs[[i]]], Missing["NotList"]]|>]
     ],
    {i, Length[packs]}
    ];
   issues
   ];


treeIntegralQ[int_J, data_Association] := treeIntegralShapeIssues[int, data] === {};


treeBinaryStates[p_Integer?NonNegative] := IntegerDigits[#, 2, p] & /@ Range[0, 2^p - 1];


treeVertexMasterPacks[vertex_Association, aValue_: 0] := Prepend[#, aValue] & /@ treeBinaryStates[vertex["p"]];


treeMasterList[data_Association, aValues_: Automatic] := Module[{values, perVertex},
   values = If[aValues === Automatic, ConstantArray[0, Length[data["vertices"]]], aValues];
   If[! ListQ[values] || Length[values] =!= Length[data["vertices"]], Return[$Failed]];
   perVertex = MapThread[treeVertexMasterPacks, {data["vertices"], values}];
   J[#] & /@ Tuples[perVertex]
   ];


(* ::Chapter:: *)
(*Tree 通用迭代矩阵*)

(* 这里直接实现 2401.00129 Eq. (3.37)、(3.47)、(3.50)。M1 与 M0tilde 的逆
   只由对角元构造；数值零对角元返回 $Failed，符号分母则作为 singularLoci 显式记录。 *)

treePauli[0] = {{1, 0}, {0, 1}};
treePauli[1] = {{0, 1}, {1, 0}};
treePauli[2] = {{0, -I}, {I, 0}};
treePauli[3] = {{1, 0}, {0, -1}};
treeBasisTransform = 1/Sqrt[2] {{1, -I}, {-I, 1}};
treeBasisTransformInverse = 1/Sqrt[2] {{1, I}, {I, 1}};


treeTensorProduct[mats_List] := Which[
   mats === {}, {{1}},
   Length[mats] === 1, First[mats],
   True, KroneckerProduct @@ mats
   ];


treePauliLift[p_Integer?Positive, slot_Integer, component_Integer] := treeTensorProduct[
   Table[If[i === slot, treePauli[component], treePauli[0]], {i, p}]
   ];


treeM1[vertex_Association, effectiveNu0_] := Module[{p, nus, identity},
   p = vertex["p"];
   nus = Lookup[vertex["massiveLegs"], "nu"];
   identity = IdentityMatrix[2^p];
   If[p === 0,
    effectiveNu0 identity,
    Sum[(nus[[i]] + 1/2) treePauliLift[p, i, 3], {i, p}] +
     (effectiveNu0 - p/2 - Total[nus]) identity
    ]
   ];


treeM0[vertex_Association] := Module[{p, energies, identity},
   p = vertex["p"];
   energies = Lookup[vertex["massiveLegs"], "energy"];
   identity = IdentityMatrix[2^p];
   If[p === 0,
    I vertex["signedEnergy"] identity,
    -I Sum[energies[[i]] treePauliLift[p, i, 2], {i, p}] + I vertex["signedEnergy"] identity
    ]
   ];


treeM0Tilde[vertex_Association] := Module[{p, energies, identity},
   p = vertex["p"];
   energies = Lookup[vertex["massiveLegs"], "energy"];
   identity = IdentityMatrix[2^p];
   If[p === 0,
    I vertex["signedEnergy"] identity,
    -I Sum[energies[[i]] treePauliLift[p, i, 3], {i, p}] + I vertex["signedEnergy"] identity
    ]
   ];


treeTp[vertex_Association] := treeTensorProduct[ConstantArray[treeBasisTransform, vertex["p"]]];
treeTpInverse[vertex_Association] := treeTensorProduct[ConstantArray[treeBasisTransformInverse, vertex["p"]]];


treeDiagonalInverse::singular = "tree recurrence 位于奇异面：`1`。";


treeDiagonalInverse[matrix_List] := Module[{diag, offDiagonal},
   diag = Diagonal[matrix];
   offDiagonal = matrix - DiagonalMatrix[diag];
   If[! TrueQ[offDiagonal === ConstantArray[0, Dimensions[matrix]]], Return[$Failed]];
   If[AnyTrue[diag, TrueQ[# === 0] &], Message[treeDiagonalInverse::singular, Select[diag, TrueQ[# === 0] &]]; Return[$Failed]];
   DiagonalMatrix[1/diag]
   ];


treeAminusMatrix[vertex_Association, shift_: 0] := Module[{m1, inv},
   m1 = treeM1[vertex, vertex["nu0"] + shift];
   inv = treeDiagonalInverse[m1];
   If[inv === $Failed, $Failed, -inv . treeM0[vertex]]
   ];


treeAplusMatrix[vertex_Association, shift_: 0] := Module[{m0t, inv},
   m0t = treeM0Tilde[vertex];
   inv = treeDiagonalInverse[m0t];
   If[inv === $Failed, $Failed,
    -treeTpInverse[vertex] . inv . treeTp[vertex] . treeM1[vertex, vertex["nu0"] + shift + 1]
    ]
   ];


makeTreeRecurrenceData[data_Association] := Module[{vertices, records},
   vertices = data["vertices"];
   records = Map[
     Function[vertex,
      <|
       "vertex" -> vertex["id"],
       "states" -> treeBinaryStates[vertex["p"]],
       "M1" -> treeM1[vertex, vertex["nu0"]],
       "M0" -> treeM0[vertex],
       "M0Tilde" -> treeM0Tilde[vertex],
       "Aminus" -> treeAminusMatrix[vertex, 0],
       "Aplus" -> treeAplusMatrix[vertex, 0],
       "singularLoci" -> Join[
         Thread[Diagonal[treeM1[vertex, vertex["nu0"]]] != 0],
         Thread[Diagonal[treeM0Tilde[vertex]] != 0]
         ]
       |>
      ],
     vertices
     ];
   <|"status" -> If[FreeQ[records, $Failed], "ready", "singular"], "vertices" -> records|>
   ];


treeStateIndex[bits_List] := FromDigits[bits, 2] + 1;


treeLoopIntegralFromTree::unsupported = "tree 到 loop seed 的反投影尚不支持该 line pack：`1`。";


treeLoopIntegralFromTree[int_J, data_Association] := Module[
   {topo = Lookup[data, "topology", Missing["NoLoopTopology"]], packs, aList, linePacks, baseline, line, states, vertexIndex, legIndex},
   If[Head[topo] === Missing || ! treeIntegralQ[int, data], Return[$Failed]];
   packs = First[int];
   aList = packs[[All, 1]];
   baseline = Lookup[data, "loopBaselinePowers", <||>];
   linePacks = Table[
     line = topo["lines"][[e]];
     Switch[line["packType"],
      "massiveFull" | "massiveCross",
      states = Table[
        vertexIndex = FirstPosition[data["vertexOrder"], line["endpoints"][[slot]], Missing["NoVertex"]];
        If[Head[vertexIndex] === Missing, Return[$Failed]];
        vertexIndex = First[vertexIndex];
        legIndex = FirstPosition[Lookup[data["vertices"][[vertexIndex, "massiveLegs"]], "id"], {line["id"], slot}, Missing["NoLeg"]];
        If[Head[legIndex] === Missing, Return[$Failed]];
        packs[[vertexIndex, 1 + First[legIndex]]],
        {slot, 2}
        ];
      Prepend[states, Lookup[baseline, line["id"], 0]],
      "shrunk",
      {Lookup[baseline, line["id"], 0]},
      _,
      Message[treeLoopIntegralFromTree::unsupported, <|"line" -> line["id"], "packType" -> line["packType"]|>];
      Return[$Failed]
      ],
     {e, topo["nE"]}
     ];
   J[aList, linePacks, ConstantArray[0, Length[topo["ispData"]]]]
   ];


treeSourceAwareStepFromTopology[int_J, vertexIndex_Integer, endpoint_Integer, data_Association] := Module[
   {packs = First[int], current, seedA, states, vertexId, localIntegrals, loopIntegrals, records, ruleData, rules, result},
   current = packs[[vertexIndex, 1]];
   If[current === endpoint, Return[int]];
   seedA = If[current < endpoint, current + 1, current];
   states = treeBinaryStates[data["vertices"][[vertexIndex, "p"]]];
   vertexId = data["vertexOrder"][[vertexIndex]];
   localIntegrals = J[ReplacePart[packs, vertexIndex -> Prepend[#, seedA]]] & /@ states;
   loopIntegrals = treeLoopIntegralFromTree[#, data] & /@ localIntegrals;
   If[! FreeQ[loopIntegrals, $Failed], Return[$Failed]];
   records = Map[DSTreeSeeds[vertexId, #, data["topology"]] &, loopIntegrals];
   If[! FreeQ[records, $Failed], Return[$Failed]];
   ruleData = makeTreeTimeReductionRules[records, data];
   rules = Lookup[ruleData, If[current < endpoint, "minus", "plus"], {}];
   result = Replace[int, rules];
   If[result === int,
    Message[makeTreeFamilyData::badinput, {<|"code" -> "missingSourceAwareStep", "integral" -> int, "vertex" -> vertexId|>}];
    $Failed,
    result
    ]
   ];


treeSingleStepIntegral[int_J, vertexIndex_Integer, endpoint_Integer, data_Association] := Module[
   {packs, pack, current, bits, vertex, matrix, nextA, states, row, newPacks, directRules, directResult},
   If[! treeIntegralQ[int, data], Return[$Failed]];
   packs = First[int];
   pack = packs[[vertexIndex]];
   current = First[pack];
   bits = Rest[pack];
   vertex = data["vertices"][[vertexIndex]];
   If[TrueQ[Lookup[data, "requiresSourceRules", False]] && AssociationQ[Lookup[data, "topology", Missing["NoLoopTopology"]]],
    Return[treeSourceAwareStepFromTopology[int, vertexIndex, endpoint, data]]
    ];
   directRules = Lookup[Lookup[data, "timeReductionRules", <||>], If[current < endpoint, "minus", "plus"], {}];
   directResult = Replace[int, directRules];
   If[directResult =!= int, Return[directResult]];
   If[TrueQ[Lookup[data, "requiresSourceRules", False]],
    Message[makeTreeFamilyData::badinput, {<|"code" -> "missingSourceAwareStep", "integral" -> int, "vertex" -> vertex["id"]|>}];
    Return[$Failed]
    ];
   Which[
    current < endpoint,
    matrix = treeAminusMatrix[vertex, current + 1];
    nextA = current + 1,
    current > endpoint,
    matrix = treeAplusMatrix[vertex, current - 1];
    nextA = current - 1,
    True,
    Return[int]
    ];
   If[matrix === $Failed, Return[$Failed]];
   states = treeBinaryStates[vertex["p"]];
   row = treeStateIndex[bits];
   Total[MapIndexed[
     Function[{state, index},
      newPacks = ReplacePart[packs, vertexIndex -> Prepend[state, nextA]];
      matrix[[row, First[index]]] J[newPacks]
      ],
     states
     ]]
   ];


treeEndpointData::badend = "tree 迭代终点无效：`1`。";


normalizeTreeEndpoints[end_, data_Association] := Module[{result},
   result = If[end === Automatic, ConstantArray[0, Length[data["vertices"]]], end];
   If[! ListQ[result] || Length[result] =!= Length[data["vertices"]] || ! And @@ (IntegerQ /@ result),
    Message[treeEndpointData::badend, end];
    Return[$Failed]
    ];
   result
   ];


treeReducibleIntegrals[expr_, endpoints_List, data_Association] := Select[
   DeleteDuplicates[Cases[expr, int_J /; treeIntegralQ[int, data], {0, Infinity}]],
   Or @@ MapThread[Unequal, {First[#][[All, 1]], endpoints}] &
   ];


repIterativeData::badindex = "tree a 指标必须是可判定整数：`1`。";
repIterativeData::maxsteps = "tree 迭代超过最大步数 `1`。";
repIterativeData::nosector = "tree 积分无法唯一匹配 sector family：`1`。";


Options[repIterativeData] = {MaxIterations -> Automatic};


repIterativeData[expr_, end_: Automatic, data_Association, OptionsPattern[]] := Module[
   {endpoints, result = Expand[expr], integrals, allA, maxSteps, steps = 0, firstInt, packs, vertexIndex},
   endpoints = normalizeTreeEndpoints[end, data];
   If[endpoints === $Failed, Return[<|"status" -> "error", "result" -> $Failed, "steps" -> 0|>]];
   integrals = Select[DeleteDuplicates[Cases[result, int_J /; treeIntegralQ[int, data], {0, Infinity}]], True &];
   allA = Flatten[First[#][[All, 1]] & /@ integrals];
   If[! And @@ (IntegerQ /@ allA), Message[repIterativeData::badindex, Select[allA, ! IntegerQ[#] &]]; Return[<|"status" -> "error", "result" -> $Failed, "steps" -> 0|>]];
   maxSteps = OptionValue[MaxIterations];
   If[maxSteps === Automatic,
    maxSteps = If[integrals === {}, 0, Max[Total[Abs[First[#][[All, 1]] - endpoints]] & /@ integrals]]
    ];
   While[(integrals = treeReducibleIntegrals[result, endpoints, data]) =!= {},
    If[steps >= maxSteps, Message[repIterativeData::maxsteps, maxSteps]; Return[<|"status" -> "maxSteps", "result" -> $Failed, "steps" -> steps|>]];
    firstInt = First[integrals];
    packs = First[firstInt];
    vertexIndex = SelectFirst[Range[Length[endpoints]], packs[[#, 1]] =!= endpoints[[#]] &];
    result = Expand[result /. int_J /; treeIntegralQ[int, data] && First[int][[vertexIndex, 1]] === packs[[vertexIndex, 1]] :>
        treeSingleStepIntegral[int, vertexIndex, endpoints[[vertexIndex]], data]];
    If[! FreeQ[result, $Failed], Return[<|"status" -> "singular", "result" -> $Failed, "steps" -> steps|>]];
    steps++;
    ];
   <|"status" -> "reduced", "result" -> result, "steps" -> steps, "endpoints" -> endpoints|>
   ];


$dSIBPTreeFamilyContext = None;
repIterative0 = {};


treeFirstStepToZero[int_J, data_Association] := Module[{packs, vertexIndex},
   If[! treeIntegralQ[int, data], Return[int]];
   packs = First[int];
   If[! And @@ (IntegerQ /@ packs[[All, 1]]), Return[$Failed]];
   vertexIndex = SelectFirst[Range[Length[packs]], packs[[#, 1]] =!= 0 &, Missing["AtEndpoint"]];
   If[Head[vertexIndex] === Missing, int, treeSingleStepIntegral[int, vertexIndex, 0, data]]
   ];


makeRepIterative0[data_Association] /; KeyExistsQ[data, "vertices"] && ! KeyExistsQ[data, "families"] := With[{family = data}, {
    HoldPattern[int_J] /; treeIntegralQ[int, family] && And @@ (IntegerQ /@ First[int][[All, 1]]) && AnyTrue[First[int][[All, 1]], # != 0 &] :>
     treeFirstStepToZero[int, family]
    }];


setTreeFamilyContext[data_Association] := Module[{},
   $dSIBPTreeFamilyContext = data;
   repIterative0 = makeRepIterative0[data];
   data
   ];


Options[repIterative] = Options[repIterativeData];


repIterative[expr_, end_: Automatic, OptionsPattern[]] := If[
   AssociationQ[$dSIBPTreeFamilyContext],
   If[KeyExistsQ[$dSIBPTreeFamilyContext, "families"],
    repIterativeSectorData[expr, end, $dSIBPTreeFamilyContext, MaxIterations -> OptionValue[MaxIterations]]["result"],
    repIterativeData[expr, end, $dSIBPTreeFamilyContext, MaxIterations -> OptionValue[MaxIterations]]["result"]
    ],
   Message[makeTreeFamilyData::badinput, {<|"code" -> "treeContextNotSet"|>}];
   $Failed
   ];


repIterative[expr_, end_, data_Association, OptionsPattern[]] /;
   KeyExistsQ[data, "vertices"] && ! KeyExistsQ[data, "families"] := Module[{activeData},
   (* 显式 family 调用同时刷新公开原始规则，保证随后可直接使用 repIterative0。 *)
   activeData = setTreeFamilyContext[data];
   repIterativeData[
     expr, end, activeData, MaxIterations -> OptionValue[MaxIterations]
     ]["result"]
   ];


(* ::Chapter:: *)
(*Loop time-IBP 到 tree 的显式投影*)

(* 投影器从每个 loop J 的 shrunk pack 重建目标 sector，再按原始 line/endpoint 顺序打包 n。
   所有 theta、WT、zero-point 与 coincident canonical 已在 dtau 中完成；这里不重写传播子边界公式。 *)

loopToTreeProjection::badloop = "loop-to-tree 投影只接受合法三槽 loop J：`1`。";
loopToTreeProjection::mixedcontact = "mixed-sign line 不得产生 theta/contact shrink：`1`。";


loopIntegralShrunkLines[int : J[_, linePacks_List, _], topo_Association] := Select[
   Range[Min[Length[linePacks], topo["nE"]]],
   Length[linePacks[[#]]] === 1 && ! MemberQ[{"masslessCross", "massiveCross"}, topo["lines"][[#, "packType"]]] &
   ];


loopTreeTargetTopology[int : J[_, linePacks_List, _], topo_Association] := Module[{shrunk, badMixed},
   shrunk = loopIntegralShrunkLines[int, topo];
   badMixed = Select[shrunk, MemberQ[{"+-", "-+"}, Lookup[topo["lines"][[#]], "skType", "++"]] &];
   If[badMixed =!= {}, Message[loopToTreeProjection::mixedcontact, badMixed]; Return[$Failed]];
   If[shrunk === {}, topo, shrinkSectorTopology[topo, shrunk]]
   ];


(* loop 的 a0 留在 tree family 的 nu0 中；b0/bS0 没有 tree 指标槽，必须随完整物理幂次进入显式能量系数。 *)
loopTreeProjectionCoefficient[int : J[aList_List, _, _], targetTopo_Association] := Module[
   {active = activeAVertexIds[targetTopo], timePower, energyPower},
   timePower = Total[aList] + Total[vertexZeroPoint[targetTopo, #] & /@ active];
   energyPower = Times @@ Table[
      Lookup[targetTopo["lines"][[e]], "treeEnergy", xi[targetTopo["lines"][[e, "id"]]]]^(-linePowerIndex[targetTopo, int, e]),
      {e, targetTopo["nE"]}
      ];
   (-1)^timePower energyPower
   ];


loopTreeRelativeProjectionCoefficient[
   int : J[targetA_List, _, _], targetTopo_Association,
   referenceInt : J[referenceA_List, _, _], referenceTopo_Association
   ] := Module[{targetTimePower, referenceTimePower, targetLinePower, referenceLinePower, energy},
   targetTimePower = Total[targetA] + Total[vertexZeroPoint[targetTopo, #] & /@ activeAVertexIds[targetTopo]];
   referenceTimePower = Total[referenceA] + Total[vertexZeroPoint[referenceTopo, #] & /@ activeAVertexIds[referenceTopo]];
   (-1)^Expand[targetTimePower - referenceTimePower] Times @@ Table[
      targetLinePower = linePowerIndex[targetTopo, int, e];
      referenceLinePower = linePowerIndex[referenceTopo, referenceInt, e];
      energy = Lookup[targetTopo["lines"][[e]], "treeEnergy", xi[targetTopo["lines"][[e, "id"]]]];
      energy^(-Expand[targetLinePower - referenceLinePower]),
      {e, targetTopo["nE"]}
      ]
   ];


projectLoopIntegralToTree[int : J[aList_List, linePacks_List, ispList_List], topo_Association, referenceInt : J[_, _, _]] := Module[
   {targetTopo, referenceTopo, active, repMap, packs, legStates, originalEndpoints, line, lineId,
    relativeCoefficient},
   If[Length[linePacks] =!= topo["nE"] || ispList =!= ConstantArray[0, Length[ispList]],
    Message[loopToTreeProjection::badloop, int]; Return[$Failed]
    ];
   targetTopo = loopTreeTargetTopology[int, topo];
   referenceTopo = loopTreeTargetTopology[referenceInt, topo];
   If[MemberQ[{targetTopo, referenceTopo}, $Failed], Return[$Failed]];
   active = activeAVertexIds[targetTopo];
   repMap = Lookup[targetTopo, "sectorVertexRepresentativeMap", AssociationThread[topo["vertexIds"] -> topo["vertexIds"]]];
   If[Length[aList] =!= Length[active], Message[loopToTreeProjection::badloop, int]; Return[$Failed]];
   packs = Table[
     legStates = {};
     Do[
      If[! MemberQ[loopIntegralShrunkLines[int, topo], e] && MemberQ[{"massiveFull", "massiveCross"}, topo["lines"][[e, "packType"]]],
       line = topo["lines"][[e]];
       lineId = line["id"];
       originalEndpoints = Lookup[line, "originalEndpoints", line["endpoints"]];
       Do[
        If[Lookup[repMap, originalEndpoints[[slot]], originalEndpoints[[slot]]] === active[[v]],
         AppendTo[legStates, linePacks[[e, slot + 1]]]
         ],
        {slot, 2}
        ]
       ],
      {e, topo["nE"]}
      ];
     Prepend[legStates, aList[[v]]],
     {v, Length[active]}
     ];
   relativeCoefficient = loopTreeRelativeProjectionCoefficient[int, targetTopo, referenceInt, referenceTopo];
   relativeCoefficient J[packs]
   ];


projectLoopIntegralToTree[int : J[_, _, _], topo_Association] := Module[{targetTopo = loopTreeTargetTopology[int, topo]},
   If[targetTopo === $Failed, $Failed, loopTreeProjectionCoefficient[int, targetTopo] projectLoopIntegralToTree[int, topo, int]]
   ];
projectLoopIntegralToTree[int_J, _Association, _J] := (Message[loopToTreeProjection::badloop, int]; $Failed);
projectLoopIntegralToTree[int_J, _Association] := (Message[loopToTreeProjection::badloop, int]; $Failed);


projectLoopTimeEquationToTree[expr_, topoSpec_Association, referenceInt_: Automatic] := Module[{topo, result, ref},
   topo = normalizeTopologySpec[topoSpec];
   If[topo === $Failed, Return[$Failed]];
   ref = If[referenceInt === Automatic, FirstCase[expr, int : J[_, _, _] :> int, Missing["NoReferenceIntegral"], Infinity], referenceInt];
   If[Head[ref] === Missing || integralKind[ref] =!= "Loop", Message[loopToTreeProjection::badloop, ref]; Return[$Failed]];
   result = Expand[expr /. int : J[_, _, _] :> projectLoopIntegralToTree[int, topo, ref]];
   If[FreeQ[result, $Failed], result, $Failed]
   ];


treeContactSourceIntegrals[expr_] := Module[{integrals, maxVertices},
   integrals = DeleteDuplicates[Cases[expr, int : J[_List] :> int, Infinity]];
   If[integrals === {}, Return[{}]];
   maxVertices = Max[Length[First[#]] & /@ integrals];
   Select[integrals, Length[First[#]] < maxVertices &]
   ];


DSTreeSeeds[vertex_, int : J[_, _, _], topoSpec_Association] := Module[
   {topo, loopSeed, treeSeed, contactAudit, shrinkConsumptionTrace, allLoopIntegrals, shrunkByTerm, projectedReference},
   topo = normalizeTopologySpec[topoSpec];
   If[topo === $Failed, Return[$Failed]];
   loopSeed = dtau[vertex, int, topo];
   If[loopSeed === $Failed, Return[$Failed]];
   allLoopIntegrals = DeleteDuplicates[Cases[loopSeed, J[_, _, _], Infinity]];
   shrunkByTerm = Association@Table[
      ToString[item, InputForm] -> loopIntegralShrunkLines[item, topo],
      {item, allLoopIntegrals}
      ];
   contactAudit = Map[
     Function[e,
      <|"lineIndex" -> e, "lineId" -> topo["lines"][[e, "id"]], "skType" -> Lookup[topo["lines"][[e]], "skType", Missing["skType"]],
       "thetaAllowedQ" -> MemberQ[{"++", "--"}, Lookup[topo["lines"][[e]], "skType", "++"]]|>
      ],
     DeleteDuplicates[Flatten[Values[shrunkByTerm]]]
     ];
   shrinkConsumptionTrace = Map[
     Function[e,
      <|"lineIndex" -> e, "lineId" -> topo["lines"][[e, "id"]],
       "skType" -> Lookup[topo["lines"][[e]], "skType", Missing["skType"]],
       "consumer" -> If[Lookup[topo["lines"][[e]], "massType", "massive"] === "massive", "WT/shrinkTerms", "masslessContact"]|>
      ],
     DeleteDuplicates[Flatten[Values[shrunkByTerm]]]
     ];
   If[AnyTrue[contactAudit, ! TrueQ[#"thetaAllowedQ"] &], Message[loopToTreeProjection::mixedcontact, contactAudit]; Return[$Failed]];
   treeSeed = projectLoopTimeEquationToTree[loopSeed, topo, int];
   projectedReference = projectLoopIntegralToTree[int, topo, int];
   <|
    "status" -> If[treeSeed === $Failed, "error", "generated"],
    "generator" -> dtau[vertex],
    "loopSeed" -> loopSeed,
    "treeSeed" -> treeSeed,
    "treeIntegral" -> projectedReference,
    "referenceA" -> First[int],
    "contactAudit" -> contactAudit,
    "shrinkConsumptionTrace" -> shrinkConsumptionTrace,
    "mixedContactQ" -> AnyTrue[contactAudit, MemberQ[{"+-", "-+"}, #"skType"] &],
    "shrunkLinesByIntegral" -> shrunkByTerm
    |>
   ];


DSTreeSeeds[int : J[_, _, _], topoSpec_Association] := Module[{topo, vertices},
   topo = normalizeTopologySpec[topoSpec];
   If[topo === $Failed, Return[$Failed]];
   vertices = Lookup[Select[makeIBPGenerators[topo], #"type" === "time" &], "vertex"];
   DSTreeSeeds[#, int, topo] & /@ vertices
   ];


treeSeedRuleGroupKey[record_Association, data_Association] := Module[
   {treeInt, treeInts, vertexId, vertexIndex, packs},
   treeInts = Cases[record["treeIntegral"], _J, {0, Infinity}];
   treeInt = If[treeInts === {}, Missing["NoTreeIntegral"], First[treeInts]];
   vertexId = record["generator"] /. dtau[v_] :> v;
   vertexIndex = FirstPosition[data["vertexOrder"], vertexId, Missing["NoVertex"]];
   If[Head[treeInt] === Missing || Head[vertexIndex] === Missing, Return[Missing["BadSeedRecord"]]];
   vertexIndex = First[vertexIndex];
   packs = First[treeInt];
   {vertexId, ReplacePart[packs, vertexIndex -> {packs[[vertexIndex, 1]], "state"}]}
   ];


makeTreeTimeReductionRules::incomplete = "tree time seed 状态组不完整：`1`。";


makeTreeTimeReductionRules[records_List, data_Association] := Module[
   {good, grouped, minusRules = {}, plusRules = {}, sourceQ = False, groupData, vertexId, vertexIndex,
    vertex, states, ordered, currentInts, minusInts, equations, m1, m0, invM1, invM0t, tp, tpInv,
    regular, source, lowerRhs, upperRhs},
   good = Select[Flatten[records], AssociationQ[#] && Lookup[#, "status", "error"] === "generated" &];
   grouped = GroupBy[good, treeSeedRuleGroupKey[#, data] &];
   KeyValueMap[
    Function[{key, group},
     If[Head[key] === Missing, Return[]];
     vertexId = key[[1]];
     vertexIndex = First@FirstPosition[data["vertexOrder"], vertexId];
     vertex = data["vertices"][[vertexIndex]];
     states = treeBinaryStates[vertex["p"]];
     ordered = SortBy[group, Function[record,
        treeStateIndex[Rest[First[First[Cases[record["treeIntegral"], _J, {0, Infinity}]]][[vertexIndex]]]]
        ]];
     If[Length[ordered] =!= Length[states], Message[makeTreeTimeReductionRules::incomplete, <|"key" -> key, "expected" -> Length[states], "actual" -> Length[ordered]|>]; Return[]];
     currentInts = First[Cases[#"treeIntegral", _J, {0, Infinity}]] & /@ ordered;
     minusInts = MapThread[
       Function[{int, state}, J[ReplacePart[First[int], vertexIndex -> Prepend[state, First[int][[vertexIndex, 1]] - 1]]]],
       {currentInts, states}
       ];
     equations = Lookup[ordered, "treeSeed"];
     m1 = treeM1[vertex, vertex["nu0"] + First[currentInts[[1]]][[vertexIndex, 1]]];
     m0 = treeM0[vertex];
     invM1 = treeDiagonalInverse[m1];
     invM0t = treeDiagonalInverse[treeM0Tilde[vertex]];
     If[MemberQ[{invM1, invM0t}, $Failed], Return[]];
     tp = treeTp[vertex];
     tpInv = treeTpInverse[vertex];
     regular = m1.minusInts + m0.currentInts;
     source = Expand[equations - regular];
     If[! TrueQ[source === ConstantArray[0, Length[source]]], sourceQ = True];
     lowerRhs = Expand[treeAminusMatrix[vertex, First[currentInts[[1]]][[vertexIndex, 1]]] . currentInts - invM1.source];
     upperRhs = Expand[treeAplusMatrix[vertex, First[currentInts[[1]]][[vertexIndex, 1]] - 1] . minusInts - tpInv.invM0t.tp.source];
     minusRules = Join[minusRules, Thread[minusInts -> lowerRhs]];
     plusRules = Join[plusRules, Thread[currentInts -> upperRhs]];
     ],
    grouped
    ];
   <|
    "status" -> If[Length[grouped] === 0, "empty", "generated"],
    "minus" -> DeleteDuplicates[minusRules],
    "plus" -> DeleteDuplicates[plusRules],
    "sourceQ" -> sourceQ,
    "groupCount" -> Length[grouped]
    |>
   ];


attachTreeTimeReductionRules[data_Association, ruleData_Association] /;
   KeyExistsQ[data, "vertices"] && ! KeyExistsQ[data, "families"] := Join[
   data,
   <|
    "timeReductionRules" -> KeyTake[ruleData, {"minus", "plus"}],
    "requiresSourceRules" -> TrueQ[ruleData["sourceQ"]]
    |>
   ];


makeTreeFamilyDataFromTopology[topoSpec_Association] := Module[
   {topo, active, repMap, vertices, originalClass, signs, legs},
   topo = normalizeTopologySpec[topoSpec];
   If[topo === $Failed, Return[$Failed]];
   active = activeAVertexIds[topo];
   repMap = Lookup[topo, "sectorVertexRepresentativeMap", AssociationThread[topo["vertexIds"] -> topo["vertexIds"]]];
   vertices = Table[
     originalClass = Select[topo["vertexIds"], Lookup[repMap, #, #] === active[[v]] &];
     signs = DeleteDuplicates[Lookup[topo["vertexSignAssoc"], originalClass]];
     If[Length[signs] =!= 1,
      Message[makeTreeFamilyData::badinput, {<|"code" -> "mixedSignMergedVertex", "vertices" -> originalClass|>}];
      Return[$Failed]
      ];
     legs = Flatten@Table[
        If[MemberQ[{"massiveFull", "massiveCross"}, topo["lines"][[e, "packType"]]],
         Table[
          If[topo["lines"][[e, "endpoints", slot]] === active[[v]],
           {<|
             "id" -> {topo["lines"][[e, "id"]], slot},
             "nu" -> topo["lines"][[e, "nu"]],
             "energy" -> Lookup[topo["lines"][[e]], "treeEnergy", xi[topo["lines"][[e, "id"]]]]
             |>},
           {}
           ],
          {slot, 2}
          ],
         {}
         ],
        {e, topo["nE"]}
        ];
     <|
      "id" -> active[[v]],
      "sign" -> First[signs],
      "nu0" -> vertexZeroPoint[topo, active[[v]]],
      "energy" -> vertexExternalEnergy[topo, active[[v]]],
      "massiveLegs" -> legs
      |>,
     {v, Length[active]}
     ];
   makeTreeFamilyData[<|
     "name" -> topo["name"],
     "sector" -> sectorKeyFromShrunkLines[Lookup[topo, "sectorShrunkLines", {}]],
     "vertices" -> vertices,
     "topology" -> topo,
     "requiresSourceRules" -> thetaFullLineIndices[topo] =!= {}
     |>]
   ];


makeTreeSectorFamilies[topoSpec_Association] := Module[{topo, subsets, sectorTopos, families},
   topo = normalizeTopologySpec[topoSpec];
   If[topo === $Failed, Return[$Failed]];
   subsets = contactReachableShrinkSubsets[topo];
   sectorTopos = Join[{topo}, shrinkSectorTopology[topo, #] & /@ subsets];
   families = makeTreeFamilyDataFromTopology /@ sectorTopos;
   If[MemberQ[families, $Failed], Return[$Failed]];
   <|
    "status" -> "ready",
    "families" -> families,
    "sectorOrder" -> Lookup[families, "sector"],
    "topFamily" -> First[families]
    |>
   ];


attachTreeTimeReductionRules[context_Association, ruleData_Association] /; KeyExistsQ[context, "families"] := Module[
   {families = context["families"]},
   families[[1]] = attachTreeTimeReductionRules[First[families], ruleData];
   Join[context, <|"families" -> families, "topFamily" -> First[families]|>]
   ];


treeFamilyForIntegral::ambiguous = "tree J 的 pack 形状同时匹配多个 sector：`1`。当前表示无法唯一确定 sector，已拒绝继续约化。";


treeFamilyForIntegral[int_J, context_Association] := Module[{matches},
   matches = Select[context["families"], treeIntegralQ[int, #] &];
   Which[
    matches === {}, Missing["NoTreeSectorFamily", int],
    Length[matches] === 1, First[matches],
    True,
    Message[treeFamilyForIntegral::ambiguous, <|"integral" -> int, "sectors" -> Lookup[matches, "sector"]|>];
    Missing["AmbiguousTreeSectorFamily", int, Lookup[matches, "sector"]]
    ]
   ];


makeRepIterative0[context_Association] /; KeyExistsQ[context, "families"] := With[{sectorContext = context}, {
    HoldPattern[int_J] /; integralKind[int] === "Tree" &&
       AssociationQ[treeFamilyForIntegral[int, sectorContext]] &&
       And @@ (IntegerQ /@ First[int][[All, 1]]) &&
       AnyTrue[First[int][[All, 1]], # != 0 &] :>
     treeFirstStepToZero[int, treeFamilyForIntegral[int, sectorContext]]
    }];


treeSectorEndpoints[end_, family_Association, context_Association] := Which[
   end === Automatic, ConstantArray[0, Length[family["vertices"]]],
   AssociationQ[end], Lookup[end, family["sector"], ConstantArray[0, Length[family["vertices"]]]],
   family["sector"] === context["topFamily"]["sector"], end,
   True, ConstantArray[0, Length[family["vertices"]]]
   ];


Options[repIterativeSectorData] = Options[repIterativeData];


repIterativeSectorData[expr_, end_: Automatic, context_Association, OptionsPattern[]] := Module[
   {result = Expand[expr], maxSteps, steps = 0, integrals, item, family, endpoints, packs, vertexIndex, unresolved, scanFailure},
   maxSteps = OptionValue[MaxIterations];
   If[maxSteps === Automatic,
    maxSteps = 10 (1 + Total[Abs[Flatten[First[#][[All, 1]] & /@ DeleteDuplicates[Cases[result, _J, {0, Infinity}]]]]] + Length[context["families"]])
    ];
   If[! IntegerQ[maxSteps] || maxSteps < 0,
    Message[repIterativeData::maxsteps, maxSteps];
    Return[<|"status" -> "error", "result" -> $Failed, "steps" -> steps|>]
    ];
   While[True,
    integrals = DeleteDuplicates[Cases[result, int_J /; integralKind[int] === "Tree", {0, Infinity}]];
    unresolved = {};
    scanFailure = None;
    Do[
     family = treeFamilyForIntegral[item, context];
     If[Head[family] === Missing,
      Message[repIterativeData::nosector, item];
      scanFailure = <|"status" -> "error", "result" -> $Failed, "steps" -> steps|>;
      Break[]
      ];
     If[! And @@ (IntegerQ /@ First[item][[All, 1]]),
      Message[repIterativeData::badindex, First[item][[All, 1]]];
      scanFailure = <|"status" -> "error", "result" -> $Failed, "steps" -> steps|>;
      Break[]
      ];
     endpoints = normalizeTreeEndpoints[treeSectorEndpoints[end, family, context], family];
     If[endpoints === $Failed,
      scanFailure = <|"status" -> "error", "result" -> $Failed, "steps" -> steps|>;
      Break[]
      ];
     If[Or @@ MapThread[Unequal, {First[item][[All, 1]], endpoints}], AppendTo[unresolved, item]],
     {item, integrals}
     ];
    If[AssociationQ[scanFailure], Return[scanFailure]];
    If[unresolved === {}, Break[]];
    If[steps >= maxSteps, Message[repIterativeData::maxsteps, maxSteps]; Return[<|"status" -> "maxSteps", "result" -> $Failed, "steps" -> steps|>]];
    item = First[unresolved];
    family = treeFamilyForIntegral[item, context];
    endpoints = normalizeTreeEndpoints[treeSectorEndpoints[end, family, context], family];
    If[endpoints === $Failed, Return[<|"status" -> "error", "result" -> $Failed, "steps" -> steps|>]];
    packs = First[item];
    vertexIndex = SelectFirst[Range[Length[endpoints]], packs[[#, 1]] =!= endpoints[[#]] &];
    result = Expand[result /. item -> treeSingleStepIntegral[item, vertexIndex, endpoints[[vertexIndex]], family]];
    If[! FreeQ[result, $Failed], Return[<|"status" -> "error", "result" -> $Failed, "steps" -> steps|>]];
    steps++;
    ];
   <|"status" -> "reduced", "result" -> result, "steps" -> steps|>
   ];


repIterative[expr_, end_, context_Association, OptionsPattern[]] /; KeyExistsQ[context, "families"] := Module[{activeContext},
   (* 多 sector context 保留既有唯一分派门禁，同时同步本轮可直接替换的单步规则。 *)
   activeContext = setTreeFamilyContext[context];
   repIterativeSectorData[
     expr, end, activeContext, MaxIterations -> OptionValue[MaxIterations]
     ]["result"]
   ];


(* ::Chapter:: *)
(*Tree dlog connection*)

(* dlog 输出始终把 primitive matrix、letter/constant-matrix 对和同序 master list 一起返回。
   多顶点 top block 是按 vertexOrder 的 Kronecker sum；contact source 由 DSTreeSeeds 单独提供。 *)

treeVertexDLogData[vertex_Association] := Module[
   {p, states, energies, k0, omega0, omegaEx, tp, tpInv, m1, omega, letters, coeffs},
   p = vertex["p"];
   states = treeBinaryStates[p];
   energies = Lookup[vertex["massiveLegs"], "energy"];
   k0 = vertex["signedEnergy"];
   omega0 = -I DiagonalMatrix[Table[
      Log[k0 + Sum[(2 states[[row, i]] - 1) energies[[i]], {i, p}]],
      {row, Length[states]}
      ]];
   omegaEx = DiagonalMatrix[Table[
     -Sum[states[[row, i]] (2 vertex["massiveLegs"][[i, "nu"]] + 1) Log[energies[[i]]], {i, p}],
     {row, Length[states]}
     ]];
   tp = treeTp[vertex];
   tpInv = treeTpInverse[vertex];
   m1 = treeM1[vertex, vertex["nu0"] + 1];
   omega = Expand[omegaEx - I tpInv . omega0 . tp . m1];
   (* 每个顶点先列 massive-leg energies，再按 binary master order 列 cut letters；
      多顶点输出按 vertexOrder 稳定拼接，保证矩阵序列化可复现。 *)
   letters = DeleteDuplicates@Join[energies, Cases[omega0, Log[arg_] :> arg, Infinity]];
   coeffs = Association@Table[letter -> Map[Coefficient[#, Log[letter]] &, omega, {2}], {letter, letters}];
   <|"vertex" -> vertex["id"], "states" -> states, "omega" -> omega, "letters" -> letters, "letterMatrices" -> coeffs|>
   ];


treeEmbedVertexMatrix[matrix_List, vertexIndex_Integer, dimensions_List] := treeTensorProduct[
   Table[If[i === vertexIndex, matrix, IdentityMatrix[dimensions[[i]]]], {i, Length[dimensions]}]
   ];


DSTreeDLogDE[data_Association] := Module[{vertexData, dimensions, omega, letters, letterMatrices, masters},
   vertexData = treeVertexDLogData /@ data["vertices"];
   dimensions = 2^Lookup[data["vertices"], "p"];
   omega = Total[MapIndexed[treeEmbedVertexMatrix[#1["omega"], First[#2], dimensions] &, vertexData]];
   letters = DeleteDuplicates[Flatten[Lookup[vertexData, "letters"]]];
   letterMatrices = Association@Table[
      letter -> Map[Coefficient[#, Log[letter]] &, omega, {2}],
      {letter, letters}
      ];
   masters = treeMasterList[data];
   <|
    "status" -> "generated",
    "sector" -> data["sector"],
    "omega" -> omega,
    "letters" -> letters,
    "letterMatrices" -> letterMatrices,
    "masters" -> masters,
    "masterCount" -> Length[masters],
    "vertexOrder" -> data["vertexOrder"],
    "vertexBlocks" -> vertexData,
    "sourceStructure" -> data["sourceStructure"]
    |>
   ];


DSTreeDLogDE[data_Association, seedData_] := Join[
   DSTreeDLogDE[data],
   <|"sourceEquations" -> seedData|>
   ];
