(* ::Package:: *)
(* 本模块把论文 vertex-basis 公式实现限制在 Private 内部，并为 017 的 tree 公开接口提供
   J[aList,linePacks,ispList] 适配。它不改变 massive-only 递推或 dlog 公式，也不绕过
   massless quotient 的 PendingRederivation 门禁。 *)

(* ::Chapter:: *)
(*统一 J 与私有 vertex basis 的双向映射*)

(* 公式内核按顶点保存 massive 状态；公开表示始终按 root line 顺序保存三槽 full pack
   和单槽 shrink pack。fixed line 使用短字符串 "F"，绝不把占位符变成积分指标。 *)
dsTreeFormulaIntegralToPublic017[int : J[_List], sectorKey_String, context_Association] := Module[
   {familyContext, family, topo, packs, aList, baseline, linePacks, line, states,
    vertexIndex, legIndex},
   familyContext = dsTreeFamilyContext[context];
   family = dsTreeFamilyBySector[sectorKey, familyContext];
   If[Head[family] === Missing || ! treeIntegralQ[int, family], Return[$Failed]];
   topo = family["topology"];
   packs = First[int];
   aList = packs[[All, 1]];
   baseline = Lookup[family, "loopBaselinePowers", <||>];
   linePacks = Table[
     line = topo["lines"][[e]];
     Switch[
      Lookup[line, "state", "full"] === "shrunk" || Lookup[line, "packType", ""] === "shrunk",
      True,
      If[lineIndexedPowerQ[line], {Lookup[baseline, line["id"], 0]}, {fixedLineSentinel017[]}],
      False,
      states = Table[
        vertexIndex = FirstPosition[
          family["vertexOrder"],
          line["endpoints"][[endpointSlot]],
          Missing["NoVertex"]
          ];
        If[Head[vertexIndex] === Missing, Return[$Failed]];
        legIndex = FirstPosition[
          Lookup[family["vertices"][[First[vertexIndex], "massiveLegs"]], "id", {}],
          {line["id"], endpointSlot},
          Missing["NoLeg"]
          ];
        If[Head[legIndex] === Missing, Return[$Failed]];
        packs[[First[vertexIndex], 1 + First[legIndex]]],
        {endpointSlot, 2}
        ];
      If[lineIndexedPowerQ[line],
       Prepend[states, Lookup[baseline, line["id"], 0]],
       Prepend[states, fixedLineSentinel017[]]
       ]
      ],
     {e, topo["nE"]}
     ];
   J[aList, linePacks, {}]
   ];


dsTreePublicIntegralToFormula017[
   int : J[_, _, _], sectorKey_String, context_Association
   ] := Module[
   {metadata, familyContext, family, topo, aList, linePacks, lineIds, vertexPacks,
    legId, linePosition, endpointSlot, statePosition, states},
   metadata = SelectFirst[
     context["sectors"],
     Lookup[#, "sectorKey", None] === sectorKey && integralMatchesSectorMetadataQ[int, #] &,
     Missing["NoSector"]
     ];
   If[Head[metadata] === Missing, Return[$Failed]];
   familyContext = dsTreeFamilyContext[context];
   family = dsTreeFamilyBySector[sectorKey, familyContext];
   If[Head[family] === Missing, Return[$Failed]];
   topo = family["topology"];
   aList = int[[1]];
   linePacks = int[[2]];
   lineIds = Lookup[topo["lines"], "id", {}];
   If[Length[aList] =!= Length[family["vertexOrder"]], Return[$Failed]];

   (* massiveLegs 的 id 已保存 root line 与端点槽；公开 full pack 的后两槽正是这两个端点态。
      fixed sentinel 只占第一槽，因此 cycle/fixed line 共用同一读取规则。 *)
   vertexPacks = Table[
     states = Map[
       Function[leg,
        legId = Lookup[leg, "id", Missing["NoLegId"]];
        If[! MatchQ[legId, {_, 1 | 2}], Return[$Failed]];
        {linePosition, endpointSlot} = {
          FirstPosition[lineIds, legId[[1]], Missing["NoLine"]],
          legId[[2]]
          };
        If[Head[linePosition] === Missing, Return[$Failed]];
        linePosition = First[linePosition];
        statePosition = 1 + endpointSlot;
        If[Length[linePacks[[linePosition]]] < statePosition, Return[$Failed]];
        linePacks[[linePosition, statePosition]]
        ],
       family["vertices"][[vertexIndex, "massiveLegs"]]
       ];
     Prepend[states, aList[[vertexIndex]]],
     {vertexIndex, Length[family["vertices"]]}
     ];
   If[FreeQ[vertexPacks, $Failed], J[vertexPacks], $Failed]
   ];


dsTreeTaggedTermToPublic017[term_Association, context_Association] := Module[
   {sectorKey, formulaIntegral, publicIntegral},
   sectorKey = Lookup[term, "sectorKey", Missing["NoSector"]];
   formulaIntegral = Lookup[term, "integral", Missing["NoIntegral"]];
   If[! StringQ[sectorKey] || ! MatchQ[formulaIntegral, J[_List]], Return[$Failed]];
   publicIntegral = dsTreeFormulaIntegralToPublic017[formulaIntegral, sectorKey, context];
   If[publicIntegral === $Failed, Return[$Failed]];
   Join[KeyDrop[term, {"integral"}], <|"integral" -> publicIntegral|>]
   ];


dsTreeTaggedTermToFormula017[term_Association, context_Association] := Module[
   {sectorKey, publicIntegral, formulaIntegral},
   sectorKey = Lookup[term, "sectorKey", Missing["NoSector"]];
   publicIntegral = Lookup[term, "integral", Missing["NoIntegral"]];
   If[! StringQ[sectorKey] || ! MatchQ[publicIntegral, J[_, _, _]], Return[$Failed]];
   formulaIntegral = dsTreePublicIntegralToFormula017[publicIntegral, sectorKey, context];
   If[formulaIntegral === $Failed, Return[$Failed]];
   Join[KeyDrop[term, {"integral"}], <|"integral" -> formulaIntegral|>]
   ];


(* ::Chapter:: *)
(*Seed 与 tagged linearData 公开化*)

dsTreeLinearDataToPublic017[data_Association, context_Association] := Module[{terms},
   terms = dsTreeTaggedTermToPublic017[#, context] & /@ Lookup[data, "terms", {}];
   If[MemberQ[terms, $Failed], Return[$Failed]];
   Join[
    KeyDrop[data, {"terms", "expression"}],
    <|
     "terms" -> terms,
     "expression" -> Total[Lookup[#, "coefficient"] Lookup[#, "integral"] & /@ terms],
     "representation" -> "sectorTaggedJ[aList,linePacks,ispList]"
     |>
    ]
   ];


dsTreeLinearDataToFormula017[data_Association, context_Association] := Module[{terms},
   terms = dsTreeTaggedTermToFormula017[#, context] & /@ Lookup[data, "terms", {}];
   If[MemberQ[terms, $Failed], Return[$Failed]];
   Join[
    KeyDrop[data, {"terms", "expression"}],
    <|
     "terms" -> terms,
     "expression" -> Total[Lookup[#, "coefficient"] Lookup[#, "integral"] & /@ terms]
     |>
    ]
   ];


dsTreeSeedRecordToPublic017[record_Association, context_Association, referenceInt_J] := Module[
   {linearData, publicLinearData},
   linearData = Lookup[record, "treeLinearData", Missing["NoTreeLinearData"]];
   If[! AssociationQ[linearData], Return[$Failed]];
   publicLinearData = dsTreeLinearDataToPublic017[linearData, context];
   If[publicLinearData === $Failed, Return[$Failed]];
   publicLinearData = Join[
     KeyDrop[publicLinearData, {"referenceTreeIntegral", "referenceLoopIntegral"}],
     <|"referenceTreeIntegral" -> referenceInt|>
     ];
   Join[
    KeyDrop[record, {"treeSeed", "treeIntegral", "treeLinearData"}],
    <|
     "treeSeed" -> publicLinearData["expression"],
     "treeIntegral" -> referenceInt,
     "treeLinearData" -> publicLinearData,
     "representation" -> "J[aList,linePacks,ispList]"
     |>
    ]
   ];


(* ::Chapter:: *)
(*公开 DSTreeSeeds 与 repIterative*)

DSTreeSeeds[vertex_, int : J[_, _, _], context_Association] /; dsContextQ[context] := Module[
   {metadata, sectorKey, familyContext, family, formulaIntegral, raw},
   If[treeFormulaMasslessPendingQ017[context],
    Return[treeFormulaPendingRederivation017["DSTreeSeeds", context]]
    ];
   metadata = integralSectorMetadata017[context["topology"], int];
   If[Head[metadata] === Missing, Return[<|"status" -> "failed", "reason" -> "unknownTreeSector"|>]];
   sectorKey = metadata["sectorKey"];
   familyContext = dsTreeFamilyContext[context];
   family = dsTreeFamilyBySector[sectorKey, familyContext];
   formulaIntegral = dsTreePublicIntegralToFormula017[int, sectorKey, context];
   If[Head[family] === Missing || formulaIntegral === $Failed,
    Return[<|"status" -> "failed", "reason" -> "treePublicToFormulaFailed"|>]
    ];
   raw = dsDirectTreeSeedRecord[vertex, formulaIntegral, family, familyContext];
   If[! AssociationQ[raw], $Failed, dsTreeSeedRecordToPublic017[raw, context, int]]
   ];


DSTreeSeeds[int : J[_, _, _], context_Association] /; dsContextQ[context] :=
  If[treeFormulaMasslessPendingQ017[context],
   treeFormulaPendingRederivation017["DSTreeSeeds", context],
   DSTreeSeeds[#, int, context] & /@ Lookup[
     Select[makeIBPGenerators[context["topology"]], #["type"] === "time" &],
     "vertex"
     ]
   ];


dsTreePublicExpressionData017[expr_, context_Association] := Module[
   {terms, parsed},
   terms = dsExpandedTerms[Expand[expr]];
   parsed = Map[
     Function[term,
      Module[{integrals, int, coefficient, metadata},
       (* 裸 J 本身位于 level 0；若只从 level 1 搜索，单积分输入会被误判为空。 *)
       integrals = DeleteDuplicates[Cases[term, item : J[_, _, _] :> item, {0, Infinity}]];
       If[Length[integrals] =!= 1, Return[$Failed]];
       int = First[integrals];
       coefficient = Cancel[term/int];
       metadata = integralSectorMetadata017[context["topology"], int];
       If[Head[metadata] === Missing, Return[$Failed]];
       <|"sectorKey" -> metadata["sectorKey"], "integral" -> int, "coefficient" -> coefficient|>
       ]
      ],
     terms
     ];
   If[MemberQ[parsed, $Failed], $Failed,
    <|"status" -> "generated", "terms" -> parsed,
      "expression" -> Total[Lookup[#, "coefficient"] Lookup[#, "integral"] & /@ parsed]|>]
   ];


repIterative[data_Association, end_: Automatic, context_Association, opts : OptionsPattern[]] /;
   dsContextQ[context] := Module[{formulaData, result},
   If[treeFormulaMasslessPendingQ017[context],
    Return[treeFormulaPendingRederivation017["repIterative", context]]
    ];
   formulaData = dsTreeLinearDataToFormula017[data, context];
   If[formulaData === $Failed, Return[<|"status" -> "error", "reason" -> "invalidUnifiedTreeData"|>]];
   result = dsRepIterativeTreeLinearData[formulaData, end, context, opts];
   If[! AssociationQ[result] || ! ListQ[Lookup[result, "terms", None]], result,
    dsTreePublicResult017[result, context]
    ]
   ];


repIterative[expr_, end_: Automatic, context_Association, opts : OptionsPattern[]] /;
   dsContextQ[context] := Module[{data},
   If[treeFormulaMasslessPendingQ017[context],
    Return[treeFormulaPendingRederivation017["repIterative", context]]
    ];
   data = dsTreePublicExpressionData017[expr, context];
   If[data === $Failed,
    <|"status" -> "error", "reason" -> "invalidUnifiedTreeExpression"|>,
    repIterative[data, end, context, opts]
    ]
   ];


(* ::Chapter:: *)
(*Naive 与 dlog 结果的公开结构化映射*)

dsTreeMasterToFormula017[master_Association, context_Association] := Module[{term},
   term = dsTreeTaggedTermToFormula017[
     KeyTake[master, {"sectorKey", "integral", "coefficient"}],
     context
     ];
   If[term === $Failed, $Failed,
    Join[KeyDrop[master, {"integral"}], <|"integral" -> term["integral"]|>]
    ]
   ];


(* 公开 naive-IBP 结果中的 lhs/rhsTerms 已经是统一三参数 J；本适配器只恢复
   Private 公式内核所需的 sector-tagged vertex basis，并保留全部系数与 sectorKey。 *)
dsTreeNaiveReductionToFormula017[record_Association, context_Association] := Module[
   {lhs, rhsTerms},
   lhs = dsTreeTaggedTermToFormula017[Lookup[record, "lhs", <||>], context];
   rhsTerms = dsTreeTaggedTermToFormula017[#, context] & /@ Lookup[record, "rhsTerms", {}];
   If[lhs === $Failed || MemberQ[rhsTerms, $Failed], Return[$Failed]];
   Join[
    KeyDrop[record, {"lhs", "rhsTerms", "rhsExpression"}],
    <|
     "lhs" -> lhs,
     "rhsTerms" -> rhsTerms,
     "rhsExpression" -> Total[Lookup[#, "coefficient"] Lookup[#, "integral"] & /@ rhsTerms]
     |>
    ]
   ];


(* 输入必须是同一 context 产生的公开 solved 数据；失败时不猜测 sector 或积分形状。 *)
dsTreeNaiveIBPDataToFormula017[data_Association, context_Association] := Module[
   {masters, reductions},
   masters = dsTreeMasterToFormula017[#, context] & /@ Lookup[data, "masters", {}];
   reductions = dsTreeNaiveReductionToFormula017[#, context] & /@ Lookup[data, "reductions", {}];
   If[masters === {} || reductions === {} || MemberQ[Join[masters, reductions], $Failed],
    Return[$Failed]
    ];
   Join[
    KeyDrop[data, {"masters", "reductions", "bareMasters", "publicRepresentationAudit"}],
    <|"masters" -> masters, "reductions" -> reductions, "representation" -> "J[vertexPacks]"|>
    ]
   ];


dsTreePublicizeData017[value_, context_Association, sectorHint_: None] := Module[
   {hint = sectorHint, mapped, publicIntegral},
   Which[
    MatchQ[value, dsTreeToken[_String, J[_List]]],
    publicIntegral = dsTreeFormulaIntegralToPublic017[value[[2]], value[[1]], context];
    If[publicIntegral === $Failed, value, publicIntegral],

    MatchQ[value, J[_List]] && StringQ[hint],
    publicIntegral = dsTreeFormulaIntegralToPublic017[value, hint, context];
    If[publicIntegral === $Failed, value, publicIntegral],

    AssociationQ[value],
    hint = Lookup[value, "sectorKey", Lookup[value, "sector", hint]];
    mapped = Association@KeyValueMap[
       Function[{key, item}, key -> dsTreePublicizeData017[item, context, hint]],
       value
       ];
    If[AssociationQ[Lookup[mapped, "treeLinearData", None]],
     mapped = Join[mapped, <|
        "treeSeed" -> mapped["treeLinearData", "expression"],
        "treeIntegral" -> Lookup[
          mapped["treeLinearData"],
          "referenceLoopIntegral",
          Lookup[mapped, "treeIntegral", Missing["NoReferenceIntegral"]]
          ]
        |>]
     ];
    If[KeyExistsQ[mapped, "terms"] && ListQ[mapped["terms"]],
     mapped = Join[mapped, <|
        "expression" -> Total[
          Lookup[#, "coefficient", 1] Lookup[#, "integral", 0] & /@ mapped["terms"]
          ]
        |>]
     ];
    If[KeyExistsQ[mapped, "rhsTerms"] && ListQ[mapped["rhsTerms"]],
     mapped = Join[mapped, <|
        "rhsExpression" -> Total[
          Lookup[#, "coefficient", 1] Lookup[#, "integral", 0] & /@ mapped["rhsTerms"]
          ]
        |>]
     ];
    mapped,

    ListQ[value], dsTreePublicizeData017[#, context, hint] & /@ value,
    Head[value] === Rule,
    Rule @@ (dsTreePublicizeData017[#, context, hint] & /@ List @@ value),
    True, value
    ]
   ];


dsTreePublicResult017[result_Association, context_Association] := Module[
   {public, masters, legacyIntegrals, privateTokens},
   public = dsTreePublicizeData017[result, context];
   If[ListQ[Lookup[public, "masters", None]],
    masters = public["masters"];
    If[And @@ (AssociationQ /@ masters),
     public = Join[public, <|"bareMasters" -> Lookup[masters, "integral", {}]|>]
     ]
    ];
   If[ListQ[Lookup[public, "contactMaps", None]],
    public = Join[public, <|"sourceEquations" -> Lookup[public["contactMaps"], "rowsByVertex", {}]|>]
    ];
   legacyIntegrals = DeleteDuplicates[Cases[public, item : J[_List] :> item, Infinity]];
   privateTokens = DeleteDuplicates[Cases[public, _dsTreeToken, Infinity]];
   Join[public, <|
     "representation" -> "J[aList,linePacks,ispList]",
     "publicRepresentationAudit" -> <|
       "passQ" -> TrueQ[legacyIntegrals === {} && privateTokens === {}],
       "legacyVertexIntegrals" -> legacyIntegrals,
       "privateTreeTokens" -> privateTokens
       |>
     |>]
   ];


DSTreeNaiveIBP[context_Association, masters_: Automatic, OptionsPattern[]] /; dsContextQ[context] := Module[
   {formulaMasters, raw},
   If[treeFormulaMasslessPendingQ017[context],
    Return[treeFormulaPendingRederivation017["DSTreeNaiveIBP", context]]
    ];
   formulaMasters = If[masters === Automatic,
     Automatic,
     dsTreeMasterToFormula017[#, context] & /@ masters
     ];
   If[ListQ[formulaMasters] && MemberQ[formulaMasters, $Failed],
    Return[<|"status" -> "failed", "reason" -> "invalidUnifiedMasters"|>]
    ];
   raw = dsTreeNaiveIBPRaw017[
     context,
     formulaMasters,
     ProgressReporting -> OptionValue[ProgressReporting]
     ];
   If[AssociationQ[raw], dsTreePublicResult017[raw, context], raw]
   ];


DSTreeNaiveDE[context_Association, variables_: Automatic, masters_: Automatic, OptionsPattern[]] /;
   dsContextQ[context] := Module[{formulaMasters, raw},
   If[treeFormulaMasslessPendingQ017[context],
    Return[treeFormulaPendingRederivation017["DSTreeNaiveDE", context]]
    ];
   formulaMasters = If[masters === Automatic,
     Automatic,
     dsTreeMasterToFormula017[#, context] & /@ masters
     ];
   If[ListQ[formulaMasters] && MemberQ[formulaMasters, $Failed],
    Return[<|"status" -> "failed", "reason" -> "invalidUnifiedMasters"|>]
    ];
   raw = dsTreeNaiveDERaw017[
     context,
     variables,
     formulaMasters,
     ProgressReporting -> OptionValue[ProgressReporting]
     ];
   If[AssociationQ[raw], dsTreePublicResult017[raw, context], raw]
   ];


(* 支持把公开 DSTreeNaiveIBP 返回值直接传回 DSTreeNaiveDE；只在表示审计通过时跨越边界。 *)
DSTreeNaiveDE[ibpData_Association, variables_: Automatic, OptionsPattern[]] /;
   Lookup[ibpData, "status", "failed"] === "solved" &&
    Lookup[ibpData, "representation", None] === "J[aList,linePacks,ispList]" := Module[
   {context, formulaData, raw},
   context = Lookup[ibpData, "context", Missing["context"]];
   If[! dsContextQ[context] ||
     ! TrueQ[Lookup[Lookup[ibpData, "publicRepresentationAudit", <||>], "passQ", False]],
    Return[<|"status" -> "failed", "reason" -> "invalidPublicNaiveIBPData"|>]
    ];
   formulaData = dsTreeNaiveIBPDataToFormula017[ibpData, context];
   If[formulaData === $Failed,
    Return[<|"status" -> "failed", "reason" -> "publicNaiveIBPConversionFailed"|>]
    ];
   raw = dsTreeNaiveDEFromIBP[
     formulaData,
     variables,
     ProgressReporting -> OptionValue[ProgressReporting]
     ];
   If[AssociationQ[raw], dsTreePublicResult017[raw, context], raw]
   ];


DSTreeDLogDE[context_Association] /; dsContextQ[context] := Module[{raw},
   If[treeFormulaMasslessPendingQ017[context],
    Return[treeFormulaPendingRederivation017["DSTreeDLogDE", context]]
    ];
   raw = dsTreeMultiSectorDLog[context];
   If[AssociationQ[raw], dsTreePublicResult017[raw, context], raw]
   ];


DSTreeDLogDE[context_Association, seedData_] /; dsContextQ[context] := Module[{raw},
   If[treeFormulaMasslessPendingQ017[context],
    Return[treeFormulaPendingRederivation017["DSTreeDLogDE", context]]
    ];
   raw = dsTreeMultiSectorDLog[context, seedData];
   If[AssociationQ[raw], dsTreePublicResult017[raw, context], raw]
   ];
