(* ::Package:: *)
(* 本模块实现 016 的 direct pure-time IBP。输入只使用 J[vertexPacks]；regular 项直接由
   vertex-family 的 M1/M0 构造，contact 项直接消费 compiled WT/shrinkTerms 与共同 theta。
   loop 三槽表示仅由独立交叉验证调用，不是本模块的生产路径。 *)

(* ::Chapter:: *)
(*Pure-time 表示能力与状态访问*)

(* 同分支 massless 内线的 regular 导数在 n=0/1 间翻转；当前用户约定的 tree pack
   只保存 massive h 状态，因此这类线必须显式拒绝，不能当作无状态相位。 *)
dsPureTimeUnsupportedLines[family_Association] := Select[
   Range[Lookup[family["topology"], "nE", 0]],
   With[{line = family["topology", "lines"][[#]]},
     Lookup[line, "state", "full"] =!= "shrunk" && Lookup[line, "packType", ""] === "masslessFull"
     ] &
   ];


dsPureTimeFamilyUsableQ[family_Association] := dsPureTimeUnsupportedLines[family] === {};


dsTreeVertexIndex[family_Association, vertexId_] := Module[{position},
   position = FirstPosition[family["vertexOrder"], vertexId, Missing["NoVertex"]];
   If[Head[position] === Missing, position, First[position]]
   ];


dsTreeLegState[int_J, family_Association, lineId_, endpointSlot_Integer] := Module[
   {matches, vertexIndex, legIndex},
   matches = Reap[
       Do[
        legIndex = FirstPosition[
          Lookup[family["vertices"][[vertexIndex, "massiveLegs"]], "id", {}],
          {lineId, endpointSlot},
          Missing["NoLeg"]
          ];
        If[Head[legIndex] =!= Missing, Sow[{vertexIndex, First[legIndex]}]],
        {vertexIndex, Length[family["vertices"]]}
        ]
       ][[2]];
   matches = If[matches === {}, {}, First[matches]];
   If[Length[matches] =!= 1,
    Missing["TreeLegState", lineId, endpointSlot, Length[matches]],
    {vertexIndex, legIndex} = First[matches];
    int[[1, vertexIndex, 1 + legIndex]]
    ]
   ];


(* ::Chapter:: *)
(*Regular M1/M0 time seed*)

dsTreeStateVectorIntegrals[int_J, family_Association, vertexIndex_Integer, aValue_] := Module[
   {packs = First[int], states},
   states = treeBinaryStates[family["vertices"][[vertexIndex, "p"]]];
   J[ReplacePart[packs, vertexIndex -> Prepend[#, aValue]]] & /@ states
   ];


dsDirectTreeRegularSeed[vertexId_, int_J, family_Association] := Module[
   {vertexIndex, vertex, pack, currentA, stateRow, currentIntegrals, lowerIntegrals, equationVector},
   If[! treeIntegralQ[int, family], Return[$Failed]];
   vertexIndex = dsTreeVertexIndex[family, vertexId];
   If[Head[vertexIndex] === Missing, Return[$Failed]];
   vertex = family["vertices"][[vertexIndex]];
   pack = First[int][[vertexIndex]];
   currentA = First[pack];
   stateRow = treeStateIndex[Rest[pack]];
   currentIntegrals = dsTreeStateVectorIntegrals[int, family, vertexIndex, currentA];
   lowerIntegrals = dsTreeStateVectorIntegrals[int, family, vertexIndex, currentA - 1];
   equationVector = Expand[
     treeM1[vertex, vertex["nu0"] + currentA] . lowerIntegrals +
      treeM0[vertex] . currentIntegrals
     ];
   Expand[equationVector[[stateRow]]]
   ];


(* ::Chapter:: *)
(*Direct 共同-theta contact*)

dsDirectTreeAtomicContactChoices[
   vertexId_, int_J, family_Association, lineIndex_Integer
   ] := Module[
   {topo = family["topology"], line, endpointSlots, endpointSlot, n1, n2, coefficient, shrinkTerms},
   line = topo["lines"][[lineIndex]];
   endpointSlots = lineEndpointSlotsAtVertex[line, vertexId];
   If[Length[endpointSlots] =!= 1 || Lookup[line, "packType", ""] =!= "massiveFull", Return[{}]];
   endpointSlot = First[endpointSlots];
   n1 = dsTreeLegState[int, family, line["id"], 1];
   n2 = dsTreeLegState[int, family, line["id"], 2];
   If[MemberQ[{n1, n2}, _Missing], Return[{}]];
   coefficient = KroneckerDelta[n1 + n2, 1] (-1)^(
       If[endpointSlot === 1, n1, n2] + thetaBoundarySignOffset[topo, lineIndex]
       );
   shrinkTerms = lineCompiledShrinkTerms[line];
   Map[
    <|
      "lineIndex" -> lineIndex,
      "coefficient" -> coefficient (Lookup[#, "coefficient", 0] /. topo["shrinkPrefactorRules"]),
      "bShift" -> Lookup[#, "bShift", 1],
      "aShift" -> Lookup[#, "bShift", 1]
      |> &,
    shrinkTerms
    ]
   ];


dsTreeContactTargetIntegral[
   int_J,
   sourceFamily_Association,
   targetFamily_Association,
   choices_List
   ] := Module[
   {sourcePacks = First[int], sourceTopo = sourceFamily["topology"], targetTopo = targetFamily["topology"],
    sourceVertices, targetVertices, targetRepMap, selectedLines, targetPacks, sourceClass, aValue, legStates},
   sourceVertices = sourceFamily["vertexOrder"];
   targetVertices = targetFamily["vertexOrder"];
   targetRepMap = Lookup[
     targetTopo,
     "sectorVertexRepresentativeMap",
     AssociationThread[targetTopo["vertexIds"] -> targetTopo["vertexIds"]]
     ];
   selectedLines = Lookup[choices, "lineIndex"];
   targetPacks = Table[
     sourceClass = Select[sourceVertices, Lookup[targetRepMap, #, #] === targetVertices[[targetIndex]] &];
     aValue = Total[
        First[sourcePacks[[dsTreeVertexIndex[sourceFamily, #]]]] & /@ sourceClass
        ] - Total[
        Map[
         Function[choice,
          If[
           And @@ (Lookup[targetRepMap, #, #] === targetVertices[[targetIndex]] & /@
              sourceTopo["lines"][[choice["lineIndex"], "endpoints"]]),
           choice["aShift"],
           0
           ]
          ],
         choices
         ]
        ];
     legStates = Map[
       Function[leg,
        dsTreeLegState[int, sourceFamily, leg["id"][[1]], leg["id"][[2]]]
        ],
       targetFamily["vertices"][[targetIndex, "massiveLegs"]]
       ];
     If[MemberQ[legStates, _Missing], Return[$Failed]];
     Prepend[legStates, aValue],
     {targetIndex, Length[targetVertices]}
     ];
   J[targetPacks]
   ];


dsTreeLineZeroPoint[topo_Association, e_Integer] := If[
   MemberQ[Lookup[topo, "sectorShrunkLines", {}], e] || Lookup[topo["lines"][[e]], "state", "full"] === "shrunk",
   lineBSZeroPoint[topo, e],
   lineBZeroPoint[topo, e]
   ];


dsDirectTreeContactCoefficient[
   int_J,
   targetInt_J,
   sourceFamily_Association,
   targetFamily_Association,
   choices_List,
   thetaBundleCoefficient_
   ] := Module[
   {sourceTopo = sourceFamily["topology"], targetTopo = targetFamily["topology"], sourceA, targetA,
    deltaTimePower, shiftByLine, deltaLinePowers, lineEnergies, atomicCoefficient},
   sourceA = Total[First /@ First[int]] + Total[Lookup[sourceFamily["vertices"], "nu0"]];
   targetA = Total[First /@ First[targetInt]] + Total[Lookup[targetFamily["vertices"], "nu0"]];
   deltaTimePower = Expand[targetA - sourceA];
   shiftByLine = Association@Map[Lookup[#, "lineIndex"] -> Lookup[#, "bShift", 0] &, choices];
   deltaLinePowers = Table[
     Expand[
      Lookup[shiftByLine, e, 0] + dsTreeLineZeroPoint[targetTopo, e] - dsTreeLineZeroPoint[sourceTopo, e]
      ],
     {e, sourceTopo["nE"]}
     ];
   lineEnergies = Table[lineTreeEnergy[targetTopo, e], {e, targetTopo["nE"]}];
   atomicCoefficient = Times @@ Lookup[choices, "coefficient"];
   Expand[
    thetaBundleCoefficient atomicCoefficient (-1)^deltaTimePower
      Times @@ MapThread[Power, {lineEnergies, -deltaLinePowers}]
    ]
   ];


dsDirectTreeContactTerms[
   vertexId_, int_J, sourceFamily_Association, familyContext_Association
   ] := Module[
   {topo = sourceFamily["topology"], connectedLines, eligibleLines, bundles, sourceShrunk,
    oddSubsets, atomicChoices, totalShrunk, targetSector, targetFamily, targetInt, coefficient, terms = {}},
   connectedLines = DeleteDuplicates@Flatten[Cases[
       Lookup[topo, "vertexLines", {}][[dsTreeVertexIndex[sourceFamily, vertexId]]],
       {e_Integer, _} :> e
       ]];
   eligibleLines = Select[
     connectedLines,
     Lookup[topo["lines"][[#]], "packType", ""] === "massiveFull" &&
       Lookup[topo["lines"][[#]], "state", "full"] =!= "shrunk" &&
       Length[lineEndpointSlotsAtVertex[topo["lines"][[#]], vertexId]] === 1 &
     ];
   bundles = GatherBy[eligibleLines, thetaBundleKey[topo, #] &];
   sourceShrunk = Lookup[topo, "sectorShrunkLines", {}];
   Do[
    oddSubsets = Select[Rest[Subsets[bundle]], OddQ[Length[#]] &];
    Do[
     atomicChoices = dsDirectTreeAtomicContactChoices[vertexId, int, sourceFamily, #] & /@ selected;
     If[AnyTrue[atomicChoices, # === {} &], Continue[]];
     Do[
      totalShrunk = Sort@Union[sourceShrunk, Lookup[choice, "lineIndex"]];
      targetSector = sectorKeyFromShrunkLines[totalShrunk];
      targetFamily = dsTreeFamilyBySector[targetSector, familyContext];
      If[Head[targetFamily] === Missing, Return[$Failed]];
      targetInt = dsTreeContactTargetIntegral[int, sourceFamily, targetFamily, choice];
      If[targetInt === $Failed, Return[$Failed]];
      coefficient = dsDirectTreeContactCoefficient[
        int, targetInt, sourceFamily, targetFamily, choice, 2^(1 - Length[selected])
        ];
      If[! TrueQ[coefficient === 0],
       AppendTo[terms, <|
         "sectorKey" -> targetSector,
         "integral" -> targetInt,
         "coefficient" -> coefficient,
         "selectedLines" -> Lookup[choice, "lineIndex"],
         "route" -> "directCompiledTheta"
         |>]
       ],
      {choice, Tuples[atomicChoices]}
      ],
     {selected, oddSubsets}
     ],
    {bundle, bundles}
    ];
   terms
   ];


(* ::Chapter:: *)
(*公开 direct seed record*)

dsTreeExpressionTerms[expr_, sectorKey_String] := Module[{terms, records},
   terms = If[Head[Expand[expr]] === Plus, List @@ Expand[expr], {Expand[expr]}];
   records = Map[
     Function[term,
      With[{integrals = DeleteDuplicates[Cases[term, int_J :> int, {0, Infinity}]]},
       If[Length[integrals] =!= 1,
        $Failed,
        <|"sectorKey" -> sectorKey, "integral" -> First[integrals],
          "coefficient" -> Expand[term /. First[integrals] -> 1], "route" -> "directM1M0"|>
        ]
       ]
      ],
     terms
     ];
   If[MemberQ[records, $Failed], $Failed, records]
   ];


dsDirectTreeSeedRecord[
   vertexId_, int_J, sourceFamily_Association, familyContext_Association
   ] := Module[{regular, regularTerms, contactTerms, combined},
   If[! dsPureTimeFamilyUsableQ[sourceFamily],
    Return[<|"status" -> "failed", "reason" -> "masslessFullNeedsTreeState",
      "lineIndices" -> dsPureTimeUnsupportedLines[sourceFamily]|>]
    ];
   regular = dsDirectTreeRegularSeed[vertexId, int, sourceFamily];
   If[regular === $Failed, Return[<|"status" -> "failed", "reason" -> "regularSeedFailed"|>]];
   regularTerms = dsTreeExpressionTerms[regular, sourceFamily["sector"]];
   contactTerms = dsDirectTreeContactTerms[vertexId, int, sourceFamily, familyContext];
   If[MemberQ[{regularTerms, contactTerms}, $Failed],
    Return[<|"status" -> "failed", "reason" -> "contactSeedFailed"|>]
    ];
   combined = dsCombineTreeTaggedTerms[Join[regularTerms, contactTerms]];
   <|
    "status" -> "generated",
    "generator" -> dtau[vertexId],
    "treeSeed" -> Total[Lookup[#, "coefficient"] Lookup[#, "integral"] & /@ combined],
    "treeIntegral" -> int,
    "sectorKey" -> sourceFamily["sector"],
    "generationRoute" -> "directPureTime",
    "loopSeed" -> Missing["NotUsed"],
    "treeLinearData" -> <|
      "status" -> "generated",
      "terms" -> combined,
      "termCount" -> Length[combined],
      "sectorKeys" -> DeleteDuplicates[Lookup[combined, "sectorKey"]],
      "expression" -> Total[Lookup[#, "coefficient"] Lookup[#, "integral"] & /@ combined],
      "referenceTreeIntegral" -> int,
      "coefficientConvention" -> "direct tree physical powers from M1/M0 and compiled WT"
      |>
   |>
   ];


(* ::Chapter:: *)
(*Pure-time canonical seed batch*)

Options[makePureTimeSeedBatch] = Options[makeTimeIBPSeedBatch];

makePureTimeSeedBatch::toomany =
   "拓扑 `1` 的 pure-time tree seed 方程数为 `2`，超过上限 `3`；未展开方程。";
makePureTimeSeedBatch::toomanystates =
   "sector `1` 的 massive h 离散态数为 `2`，超过上限 `3`；未展开方程。";


(* 每条 generator 继续复用统一 a-range/generator override 解析；tree 表示只消费顶点 a，
   不把 loop 表示中的 b/ISP 变量带入 pure-time 积分。 *)
dsPureTimeGeneratorSeedData[family_Association, vertexId_, opts : OptionsPattern[makePureTimeSeedBatch]] := Module[
   {topo = family["topology"], generatorLabel, continuousData, aVariables, aValueLists},
   generatorLabel = {"time", vertexId};
   continuousData = makeGeneratorContinuousSeedRules[
     topo,
     generatorLabel,
     UseSampleOnly -> OptionValue[UseSampleOnly],
     MaxSeedRuleCount -> OptionValue[MaxSeedRuleCount]
     ];
   If[Lookup[continuousData, "status", "missing"] =!= "generated", Return[continuousData]];
   aVariables = a /@ family["vertexOrder"];
   aValueLists = (aVariables /. #) & /@ Lookup[continuousData, "rules", {}];
   If[! And @@ (VectorQ[#, IntegerQ] & /@ aValueLists),
    Return[Join[KeyDrop[continuousData, "rules"], <|
      "status" -> "invalidTreeASeedRules",
      "generator" -> generatorLabel,
      "aVariables" -> aVariables,
      "aValueLists" -> aValueLists
      |>]]
    ];
   Join[KeyDrop[continuousData, "rules"], <|
     "status" -> "generated",
     "generator" -> generatorLabel,
     "aVariables" -> aVariables,
     "aValueLists" -> aValueLists
     |>]
   ];


(* DSSeeds 的 timeOnly 生产路径：sector tag 保存在 record/linear terms 中，裸积分始终是 J[vertexPacks]。 *)
makePureTimeSeedBatch[context_Association, opts : OptionsPattern[]] /; dsContextQ[context] := Module[
   {familyContext, families, rootTopo = context["topology"], generatorData, stateCounts,
    maxDiscreteCount, equationCount, maxEquationCount, records, numericRules, applyNumericRules,
    sectorMetadataList, badFamilies},
   familyContext = dsTreeFamilyContext[context];
   If[familyContext === $Failed,
    Return[<|"status" -> "failed", "reason" -> "treeFamilyInitializationFailed", "equations" -> {}|>]
    ];
   families = familyContext["families"];
   badFamilies = Select[families, ! dsPureTimeFamilyUsableQ[#] &];
   If[badFamilies =!= {},
    Return[<|
      "status" -> "unsupportedTreeState",
      "reason" -> "masslessFullNeedsTreeState",
      "sectorLineIndices" -> Association@Table[
        family["sector"] -> dsPureTimeUnsupportedLines[family],
        {family, badFamilies}
        ],
      "equations" -> {}
      |>]
    ];
   stateCounts = Association@Table[
      family["sector"] -> 2^Total[Lookup[family["vertices"], "p", 0]],
      {family, families}
      ];
   maxDiscreteCount = resolveSeedOption[
     rootTopo, "MaxDiscreteRuleCount", OptionValue[MaxDiscreteRuleCount], 64
     ];
   If[AnyTrue[Values[stateCounts], # > maxDiscreteCount &],
    With[{sector = SelectFirst[Keys[stateCounts], stateCounts[#] > maxDiscreteCount &]},
     Message[makePureTimeSeedBatch::toomanystates, sector, stateCounts[sector], maxDiscreteCount];
     Return[<|"status" -> "tooManyDiscreteStates", "sectorStateCounts" -> stateCounts,
       "maxDiscreteStateCount" -> maxDiscreteCount, "equations" -> {}|>]
     ]
    ];
   generatorData = Flatten@Table[
      dsPureTimeGeneratorSeedData[family, vertexId, opts],
      {family, families}, {vertexId, family["vertexOrder"]}
      ];
   If[AnyTrue[generatorData, Lookup[#, "status", "missing"] =!= "generated" &],
    Return[<|"status" -> "invalidGeneratorSeedRanges", "generatorSeedData" -> generatorData,
      "equations" -> {}|>]
    ];
   equationCount = Total[
     Lookup[#, "ruleCount", 0] stateCounts[Lookup[#, "sectorKey", "top"]] & /@ generatorData
     ];
   maxEquationCount = resolveSeedOption[rootTopo, "MaxEquationCount", OptionValue[MaxEquationCount], 80];
   If[equationCount > maxEquationCount,
    Message[makePureTimeSeedBatch::toomany, rootTopo["name"], equationCount, maxEquationCount];
    Return[<|"status" -> "tooManyEquations", "equationCount" -> equationCount,
      "maxEquationCount" -> maxEquationCount, "generatorSeedData" -> generatorData,
      "equations" -> {}|>]
    ];
   records = Flatten@Table[
      With[{family = families[[familyIndex]]},
       Flatten@Table[
         dsDirectTreeSeedRecord[vertexId, #, family, familyContext] & /@
          treeMasterList[family, aValues],
         {vertexId, family["vertexOrder"]},
         {aValues, Lookup[
            SelectFirst[generatorData,
             Lookup[#, "sectorKey", None] === family["sector"] &&
               Lookup[#, "generator", None] === {"time", vertexId} &],
            "aValueLists", {}
            ]}
         ]
       ],
      {familyIndex, Length[families]}
      ];
   If[MemberQ[records, $Failed] || AnyTrue[records, Lookup[#, "status", "failed"] =!= "generated" &],
    Return[<|"status" -> "failed", "reason" -> "directPureTimeSeedGenerationFailed",
      "seedRecords" -> records, "equations" -> {}|>]
    ];
   applyNumericRules = TrueQ[OptionValue[ApplyNumericRules]];
   numericRules = If[applyNumericRules, userNumericRules[rootTopo], {}];
   If[applyNumericRules, records = records /. numericRules];
   sectorMetadataList = makeSectorMetadata /@ Lookup[families, "topology"];
   <|
    "status" -> "generated",
    "caseName" -> rootTopo["name"],
    "ibpMode" -> "timeOnly",
    "representation" -> "J[vertexPacks]",
    "generationRoute" -> "directPureTime",
    "completeCanonicalQ" -> True,
    "completeTimeGenerationQ" -> True,
    "completeMomentumGenerationQ" -> False,
    "eomCanonicalQ" -> True,
    "sectorCount" -> Length[families],
    "sectorMetadataList" -> sectorMetadataList,
    "sectorStateCounts" -> stateCounts,
    "generatorSeedData" -> generatorData,
    "equationCount" -> Length[records],
    "equations" -> records,
    "seedRecords" -> records,
    "numericRulesAppliedBeforeSeeds" -> applyNumericRules,
    "seedNumericRules" -> numericRules,
    "pendingFeatures" -> {}
   |>
   ];


(* ::Chapter:: *)
(*Pure-time backend-neutral linearData*)

dsPureTimeTaggedIntegral[term_Association] := dsTreeToken[
   Lookup[term, "sectorKey", "top"],
   Lookup[term, "integral", Missing["TreeIntegral"]]
   ];


dsPureTimeLinearEquation[record_Association, integralIndex_Association] := Module[
   {terms, rules},
   terms = Lookup[Lookup[record, "treeLinearData", <||>], "terms", {}];
   rules = Merge[
     Rule[
        integralIndex[dsPureTimeTaggedIntegral[#]],
        Lookup[#, "coefficient", 0]
        ] & /@ terms,
     Total
     ];
   <|
    "source" -> "directPureTime",
    "generator" -> Lookup[record, "generator", Missing["generator"]],
    "sectorKey" -> Lookup[record, "sectorKey", "top"],
    "referenceTreeIntegral" -> Lookup[record, "treeIntegral", Missing["TreeIntegral"]],
    "coefficientRules" -> Normal[rules],
    "constantTerm" -> 0,
    "nonlinearTerms" -> {},
    "linearQ" -> True
    |>
   ];


makePureTimeLinearSystemData[batch_Association, context_Association] /; dsContextQ[context] := Module[
   {records, terms, tokens, integralIndex, linearEquations, publicIntegrals, coefficientDiagnostics},
   If[Lookup[batch, "status", "missing"] =!= "generated" ||
     Lookup[batch, "representation", None] =!= "J[vertexPacks]",
    Return[<|"status" -> "notGenerated", "reason" -> "notPureTimeSeedBatch"|>]
    ];
   records = Lookup[batch, "seedRecords", {}];
   terms = Flatten[Lookup[Lookup[records, "treeLinearData", <||>], "terms", {}], 1];
   If[AnyTrue[terms, ! StringQ[Lookup[#, "sectorKey", None]] || ! MatchQ[Lookup[#, "integral", None], J[_List]] &],
    Return[<|"status" -> "notReady", "reason" -> "invalidSectorTaggedTreeTerms"|>]
    ];
   tokens = DeleteDuplicates[dsPureTimeTaggedIntegral /@ terms];
   integralIndex = makeIntegralIndex[tokens];
   linearEquations = dsPureTimeLinearEquation[#, integralIndex] & /@ records;
   publicIntegrals = Map[
     <|"id" -> integralIndex[#], "sectorKey" -> #[[1]], "integral" -> #[[2]]|> &,
     tokens
     ];
   coefficientDiagnostics = linearCoefficientDiagnostics[linearEquations];
   <|
    "status" -> "generated",
    "caseName" -> Lookup[batch, "caseName", context["topology", "name"]],
    "ibpMode" -> "timeOnly",
    "representation" -> "sectorTaggedJ[vertexPacks]",
    "topology" -> context["topology"],
    "integralCount" -> Length[tokens],
    "equationCount" -> Length[linearEquations],
    "integralList" -> tokens,
    "publicIntegralList" -> publicIntegrals,
    "integralRules" -> Normal[integralIndex],
    "sectorMetadataList" -> Lookup[batch, "sectorMetadataList", {}],
    "topologyValidationReport" -> topologyValidationReport[context["topology"]],
    "seedCoverageReport" -> <|
      "passQ" -> True,
      "mode" -> "timeOnly",
      "completeTimeGenerationQ" -> True,
      "completeMomentumGenerationQ" -> False
      |>,
    "linearEquations" -> linearEquations,
    "linearQ" -> And @@ Lookup[linearEquations, "linearQ", False],
    "nonlinearEquationCount" -> Count[Lookup[linearEquations, "linearQ", False], False],
    "numericCoefficientSystemQ" -> coefficientDiagnostics["numericCoefficientSystemQ"],
    "coefficientVariables" -> coefficientDiagnostics["coefficientVariables"],
    "sourceSeedBatch" -> KeyDrop[batch, {"equations", "seedRecords"}]
    |>
   ];
