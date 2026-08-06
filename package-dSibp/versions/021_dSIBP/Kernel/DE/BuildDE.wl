(* ::Package:: *)

(* ::Chapter:: *)
(*018 微分方程构造*)

(* DSDE 只消费经 KiraImport 验证的 reduction data；不会从不完整日志猜测 master 或规则。 *)

Options[DSDE] = {
   OutputDirectory -> None,
   ProgressReporting -> Automatic
   };

DSDE::badreduction = "DSDE 只接受 DSKiraImport 验证通过的 reductionData。";
DSDE::badvars = "微分变量必须是当前 family 初始化的外部独立变量：`1`。";
DSDE::writefailed = "DE 结果写入失败：`1`。";


(* ::Section::Closed:: *)
(*Kira 内部能量坐标的微分接口*)

(* DSDE 的公开矩阵仍表示物理 D_k。这里同时给出直接 backend 坐标的
   D_ik=-I D_k 结果，并保存 D_k=I D_ik 与 Euler 不变量供 scaling 审计。 *)
dsDEBackendEnergyDerivativeView[matrices_Association, sources_Association, variables_List, convention_Association] := Module[
   {records, activeRecords, backendVariables, backendMatrices, backendSources},
   If[Lookup[convention, "status", "notRequired"] =!= "configured",
    Return[<|"status" -> "notRequired", "scope" -> "KiraBackendOnly"|>]
    ];
   records = Lookup[convention, "records", {}];
   activeRecords = Select[records, MemberQ[variables, Lookup[#, "physical"]] &];
   backendVariables = Lookup[activeRecords, "backend", {}];
   backendMatrices = AssociationThread[
     backendVariables,
     (-I Lookup[matrices, Lookup[#, "physical"]]) & /@ activeRecords
     ];
   backendSources = AssociationThread[
     backendVariables,
     (-I Lookup[sources, Lookup[#, "physical"]]) & /@ activeRecords
     ];
   <|
    "status" -> If[activeRecords === {}, "notRequired", "generated"],
    "scope" -> "KiraBackendOnly",
    "backendVariables" -> backendVariables,
    "matrices" -> backendMatrices,
    "sources" -> backendSources,
    "backendFromPhysicalDerivativeFactor" -> -I,
    "physicalFromBackendDerivativeFactor" -> I,
    "ordinaryDerivativeConvention" -> "D[physicalEnergy] == I D[backendEnergy]",
    "eulerConvention" -> "physicalEnergy D[physicalEnergy] == backendEnergy D[backendEnergy]",
    "records" -> activeRecords
    |>
   ];

dsSectorTopologyForIntegral[int_J, context_Association] := Module[{metadata, matches, shrunk},
   metadata = context["sectors"];
   matches = Select[metadata, integralMatchesSectorMetadataQ[int, #] &];
   If[Length[matches] =!= 1, Return[$Failed]];
   shrunk = Lookup[First[matches], "sectorShrunkLines", {}];
   If[shrunk === {}, context["topology"], shrinkSectorTopology[context["topology"], shrunk]]
   ];

(* DSKiraImport 已验证每条 reduction 的右端只含 masters，因此一次替换就是完整约化；
   若外部结果违反该合同，后续 residual gate 会拒绝 DE，而不是用任意迭代次数掩盖问题。 *)
dsReduceExpression[expr_, rules_List] := Expand[expr /. rules];

(* Kira 关系可以使用内部 kk/ISP 坐标；公开 DE 必须只含 family 声明的外部不变量。 *)
dsDEReducedExpressionToUser[expr_, context_Association] := Module[{topo = context["topology"]},
   Expand[scalarProductInternalToUser[expr /. internalISPToUserRules[topo], topo]]
   ];

dsDEMasterDecomposition[expr_, masterTokens_List] := Module[
   {coefficientTokens, tokenExpr, coefficients, source, residualIntegrals, residualBackendTokens, residualObjects},
   coefficientTokens = Array[Unique["dsMaster$"] &, Length[masterTokens]];
   tokenExpr = expr /. Thread[masterTokens -> coefficientTokens];
   coefficients = Coefficient[tokenExpr, #] & /@ coefficientTokens;
   source = Expand[tokenExpr - coefficients.coefficientTokens];
   residualIntegrals = DeleteDuplicates[Cases[source, _J, Infinity]];
   residualBackendTokens = DeleteDuplicates[Cases[source, Tuserweight[_Integer], Infinity]];
   residualObjects = Join[residualIntegrals, residualBackendTokens];
   <|
    "coefficients" -> coefficients,
    "source" -> source,
    "residualIntegrals" -> residualIntegrals,
    "residualBackendTokens" -> residualBackendTokens,
    "residualObjects" -> residualObjects,
    "closedQ" -> (residualObjects === {})
    |>
   ];

(* active basis 可同时含 top 与 residual-sector J；逐项选择 sector topology，并显式保留系数导数。 *)
dsSectorAwareDerivative[expr_, variable_, context_Association] := Module[
   {linearData, coefficientDerivative, integralDerivativeTerms},
   linearData = publicLinearIntegralDecomposition[expr];
   If[Lookup[linearData, "status", "failed"] =!= "linear", Return[$Failed]];
   coefficientDerivative = Expand[D[linearData["heldExpression"], variable] /. linearData["backwardRules"]];
   integralDerivativeTerms = MapThread[
     Function[{coefficient, int},
      With[{sectorTopology = dsSectorTopologyForIntegral[int, context]},
       If[sectorTopology === $Failed, $Failed, coefficient ds[int, variable, sectorTopology]]
       ]
      ],
     {linearData["coefficients"], linearData["integrals"]}
     ];
   If[! FreeQ[integralDerivativeTerms, $Failed], $Failed, Expand[coefficientDerivative + Total[integralDerivativeTerms]]]
   ];

dsDEVariableData[variable_, masterDefinitions_List, masterTokens_List, rules_List, parameterRules_List, context_Association, progress_] := Module[
   {raw, reduced, decompositions},
   raw = dsProgressMap[
     "正在构造 " <> ToString[variable, InputForm] <> " 导数 / Building " <> ToString[variable, InputForm] <> " derivatives",
     masterDefinitions,
     Function[master, dsSectorAwareDerivative[master, variable, context] /. parameterRules],
     progress
     ];
   If[MemberQ[raw, $Failed], Return[<|"status" -> "failed", "variable" -> variable, "reason" -> "dsFailed", "rawDerivatives" -> raw|>]];
   reduced = dsProgressMap[
     "正在约化 " <> ToString[variable, InputForm] <> " 导数 / Reducing " <> ToString[variable, InputForm] <> " derivatives",
     raw,
     Function[expr, dsReduceExpression[expr, rules]],
     progress
     ];
   reduced = dsDEReducedExpressionToUser[#, context] & /@ reduced;
   decompositions = dsDEMasterDecomposition[#, masterTokens] & /@ reduced;
   <|
    "status" -> If[And @@ Lookup[decompositions, "closedQ", False], "generated", "notClosed"],
    "variable" -> variable,
    "matrix" -> Lookup[decompositions, "coefficients", {}],
    "source" -> Lookup[decompositions, "source", {}],
    "rawDerivatives" -> raw,
    "reducedDerivatives" -> reduced,
    "residualIntegrals" -> DeleteDuplicates[Flatten[Lookup[decompositions, "residualIntegrals", {}]]],
    "residualBackendTokens" -> DeleteDuplicates[Flatten[Lookup[decompositions, "residualBackendTokens", {}]]],
    "residualObjects" -> DeleteDuplicates[Flatten[Lookup[decompositions, "residualObjects", {}]]]
    |>
   ];

dsWriteDEResult[data_Association, directory_String] := Module[{paths, compact},
   Quiet[CreateDirectory[directory, CreateIntermediateDirectories -> True]];
   paths = <|
     "masters" -> FileNameJoin[{directory, "masters.wl"}],
     "de" -> FileNameJoin[{directory, "de.wl"}],
     "manifest" -> FileNameJoin[{directory, "manifest.wl"}]
     |>;
   compact = KeyDrop[data, {"variableData", "context"}];
   If[Quiet[Check[
       Put[data["masters"], paths["masters"]];
       Put[KeyTake[data, {"status", "variables", "matrices", "sources", "residualIntegrals", "equationConvention"}], paths["de"]];
       Put[Join[compact, <|"files" -> AssociationMap[FileNameTake, paths]|>], paths["manifest"]];
       True,
       False
       ]],
    <|"status" -> "written", "directory" -> directory, "files" -> paths|>,
    <|"status" -> "failed", "directory" -> directory|>
    ]
   ];

DSDE[reductionData_Association, variables_: Automatic, OptionsPattern[]] := Module[
   {context, masters, masterTokens, rules, resolvedVariables, allowedVariables, badVariables,
    sourceManifest, kiraPlan, postDerivativeRules, physicalPostDerivativeRules, parameterRules, variableRecords,
    variableData, status, matrices, sources, backendEnergyConvention, backendDerivativeView,
    result, outputDirectory = OptionValue[OutputDirectory], writeResult},
   If[Lookup[reductionData, "status", "missing"] =!= "imported" ||
     Lookup[Lookup[reductionData, "validationReport", <||>], "status", "missing"] =!= "passed",
    Message[DSDE::badreduction]; dsErrorPrint["reductionData 未经 DSKiraImport 完整验证。 reductionData has not passed complete DSKiraImport validation."]; Return[<|"status" -> "failed", "reason" -> "unvalidatedReductionData"|>]
    ];
   context = Lookup[reductionData, "context", Missing["context"]];
   If[! dsContextQ[context], Message[DSDE::badreduction]; Return[<|"status" -> "failed", "reason" -> "missingContext"|>]];
   If[! dsContextCapabilityQ[context, "derivativeUsableQ"],
    Message[DSDE::badreduction];
    dsErrorPrint["当前参数声明不支持唯一微分算符。 The current parameter declaration does not define unique differential operators."]; Return[<|
      "status" -> "failed", "reason" -> "derivativeCapabilityGate",
      "capabilities" -> dsContextCapabilities[context]
      |>]
    ];
   masters = reductionData["masters"];
   masterTokens = Lookup[reductionData, "masterTokens", masters];
   If[! ListQ[masters] || ! ListQ[masterTokens] || Length[masters] =!= Length[masterTokens] || masters === {},
    Message[DSDE::badreduction]; Return[<|"status" -> "failed", "reason" -> "invalidMasterDefinitionsOrTokens"|>]
    ];
   rules = reductionData["reductionRules"];
   sourceManifest = Lookup[reductionData, "sourceManifest", <||>];
   kiraPlan = Lookup[sourceManifest, "kiraPlan", <||>];
   postDerivativeRules = If[
     Lookup[kiraPlan, "numericStage", "symbolic"] === "postDerivative",
     Lookup[kiraPlan, "coefficientRules", {}],
     {}
     ];
   physicalPostDerivativeRules = If[postDerivativeRules === {},
     {},
     Lookup[sourceManifest, "physicalCoefficientRulesApplied", postDerivativeRules]
     ];
   (* fixed-rational export 在解析导数 closure 冻结后才数值化；DSDE 必须把同一规则
      同时用于内部原子和公开坐标，否则 h EOM 或系数乘积法则会重新引入参数。 *)
   parameterRules = DeleteDuplicatesBy[
     Join[
      If[TrueQ[Lookup[sourceManifest, "numericRulesAppliedBeforeSeeds", False]],
       Lookup[context["topology"], "numericRules", {}], {}],
      If[ListQ[physicalPostDerivativeRules],
       normalizeCoefficientRulesForTopology[physicalPostDerivativeRules, context["topology"]], {}],
      If[ListQ[physicalPostDerivativeRules], physicalPostDerivativeRules, {}]
      ],
     First
     ];
   resolvedVariables = dsDEResolveVariables[variables, context];
   allowedVariables = dsDEResolveVariables[Automatic, context];
   badVariables = Complement[resolvedVariables, allowedVariables];
   If[badVariables =!= {},
    Message[DSDE::badvars, badVariables]; dsErrorPrint["DSDE 变量不属于当前 family 的外部表示。 The DSDE variables are not external coordinates of the current family."]; Return[<|"status" -> "failed", "reason" -> "invalidVariables", "badVariables" -> badVariables, "allowedVariables" -> allowedVariables|>]
    ];
   variableRecords = dsProgressMap[
     "正在生成微分方程 / Building differential equations",
     resolvedVariables,
     Function[variable, dsDEVariableData[variable, masters, masterTokens, rules, parameterRules, context, OptionValue[ProgressReporting]]],
     OptionValue[ProgressReporting]
     ];
   variableData = AssociationThread[resolvedVariables, variableRecords];
   status = Which[
     AnyTrue[variableRecords, Lookup[#, "status", "failed"] === "failed" &], "failed",
     AnyTrue[variableRecords, Lookup[#, "status", "notClosed"] === "notClosed" &], "notClosed",
     True, "generated"
     ];
   matrices = AssociationThread[resolvedVariables, Lookup[variableRecords, "matrix", {}]];
   sources = AssociationThread[resolvedVariables, Lookup[variableRecords, "source", {}]];
   backendEnergyConvention = Lookup[sourceManifest, "backendEnergyConvention", <|"status" -> "notRequired"|>];
   backendDerivativeView = dsDEBackendEnergyDerivativeView[
     matrices,
     sources,
     resolvedVariables,
     backendEnergyConvention
     ];
   result = <|
     "status" -> status,
     "masters" -> masters,
     "masterTokens" -> masterTokens,
     "masterCount" -> Length[masters],
     "variables" -> resolvedVariables,
     "matrices" -> matrices,
     "sources" -> sources,
     "backendEnergyDerivativeView" -> backendDerivativeView,
     "residualIntegrals" -> AssociationThread[resolvedVariables, Lookup[variableRecords, "residualIntegrals", {}]],
     "residualBackendTokens" -> AssociationThread[resolvedVariables, Lookup[variableRecords, "residualBackendTokens", {}]],
     "residualObjects" -> AssociationThread[resolvedVariables, Lookup[variableRecords, "residualObjects", {}]],
     "variableData" -> variableData,
     "sourceManifest" -> reductionData["sourceManifest"],
     "activeBasis" -> Lookup[reductionData, "activeBasis", <|"status" -> "disabled", "count" -> 0|>],
     "parameterRulesApplied" -> If[parameterRules === {}, {}, userNumericRules[context["topology"]]],
     "postDerivativeRulesApplied" -> postDerivativeRules,
     "physicalPostDerivativeRulesApplied" -> physicalPostDerivativeRules,
     "context" -> context,
     "equationConvention" -> "D[masters,var] == matrices[var].masters + sources[var]",
     "reductionValidationReport" -> reductionData["validationReport"]
     |>;
   writeResult = If[StringQ[outputDirectory], dsWriteDEResult[result, ExpandFileName[outputDirectory]], <|"status" -> "notRequested"|>];
   If[Lookup[writeResult, "status", "failed"] === "failed", Message[DSDE::writefailed, outputDirectory]; dsErrorPrint["DE 文件未写出。 DE files were not written."]];
   Join[result, <|"writeResult" -> writeResult|>]
   ];

DSDE[reductionData_, variables_: Automatic, OptionsPattern[]] := (Message[DSDE::badreduction]; dsErrorPrint["DSDE 输入必须是 reductionData Association。 DSDE input must be a reductionData Association."]; <|"status" -> "failed", "reason" -> "inputNotAssociation"|>);


(* ::Chapter:: *)
(*Naive tree IBP 微分方程*)

(* tree 原生导数直接作用于 Exp[I k0_v tau_v] 与 h building block。
   tree J 使用论文 recurrence 的 tau^a convention，故顶点相位贡献为
   +I D[k0_v,x] J[...,a_v+1,...]；loop 投影中的 (-1)^Delta a 不属于 tree 原生导数。
   sector master 的 normalization N 最后另按乘积法则求导。 *)

Options[DSTreeNaiveDE] = {AuditLevel -> "standard", ProgressReporting -> Automatic};

DSTreeNaiveDE::badibp = "DSTreeNaiveDE 需要 DSTreeNaiveIBP 成功返回的数据或合法 DSInit context。";
DSTreeNaiveDE::badvars = "tree 微分变量必须是当前 family 初始化的外部独立变量：`1`。";


dsTreeZeroTokenTerms[expr_] := If[TrueQ[Expand[expr] === 0], {}, dsTreeTokenTerms[expr]];


dsTreeLineEnergyDerivative[int_J, variable_, family_Association] := Module[
   {packs = First[int], terms = {}, vertex, leg, energyDerivative, state, newPacks, shiftedIntegral},
   Do[
    vertex = family["vertices"][[vertexIndex]];
    Do[
     leg = vertex["massiveLegs"][[legIndex]];
     energyDerivative = D[leg["energy"], variable];
     If[! TrueQ[energyDerivative === 0],
      state = packs[[vertexIndex, 1 + legIndex]];
      If[! MemberQ[{0, 1}, state], Return[$Failed]];
      newPacks = ReplacePart[packs, {vertexIndex, 1} -> packs[[vertexIndex, 1]] + 1];
      newPacks = ReplacePart[newPacks, {vertexIndex, 1 + legIndex} -> 1 - state];
      shiftedIntegral = J[newPacks];
      AppendTo[terms,
       energyDerivative If[
         state === 0,
         -dsTreeToken[family["sector"], shiftedIntegral],
         dsTreeToken[family["sector"], shiftedIntegral] -
          (2 leg["nu"] + 1)/leg["energy"] dsTreeToken[family["sector"], int]
         ]
       ]
      ],
     {legIndex, Length[vertex["massiveLegs"]]}
     ],
    {vertexIndex, Length[family["vertices"]]}
    ];
   Expand[Total[terms]]
   ];


(* 旧 loop 投影只保留为正式 check 的单向 oracle，不再被 018 生产 DE 调用。 *)
dsTreePhaseDerivativeProjectionOracle[loopIntegral_J, variable_, family_Association, rootTopology_Association] := Module[
   {internalVariable, loopDerivative, projectedData, expression},
   internalVariable = scalarProductInputToInternal[variable, family["topology"]];
   loopDerivative = directVertexEnergyVariableDerivativeSeed[family["topology"], loopIntegral, internalVariable];
   If[TrueQ[Expand[loopDerivative] === 0],
    Return[<|"status" -> "generated", "loopDerivative" -> 0,
      "projectedData" -> <|"status" -> "generated", "terms" -> {}, "termCount" -> 0|>,
      "internalExpression" -> 0|>]
    ];
   projectedData = dsTreeLinearData[<|"loopSeed" -> loopDerivative|>, rootTopology, loopIntegral];
   If[Lookup[projectedData, "status", "failed"] =!= "generated",
    Return[<|"status" -> "failed", "reason" -> "phaseDerivativeProjectionFailed",
      "loopDerivative" -> loopDerivative, "projectedData" -> projectedData|>]
    ];
   expression = scalarProductInternalToUser[dsTreeTokenExpression[projectedData], rootTopology];
   <|"status" -> "generated", "loopDerivative" -> loopDerivative,
    "projectedData" -> projectedData, "internalExpression" -> expression|>
   ];


dsTreePhaseDerivativeDirect[int_J, variable_, family_Association, rootTopology_Association] := Module[
   {packs = First[int], terms, publicEnergy, derivative, shiftedPacks, shiftedIntegral},
   terms = Table[
     publicEnergy = scalarProductInternalToUser[family["vertices"][[vertexIndex, "signedEnergy"]], rootTopology];
     derivative = D[publicEnergy, variable];
     If[TrueQ[derivative === 0],
      0,
      shiftedPacks = ReplacePart[packs, {vertexIndex, 1} -> packs[[vertexIndex, 1]] + 1];
      shiftedIntegral = J[shiftedPacks];
      I derivative dsTreeToken[family["sector"], shiftedIntegral]
      ],
     {vertexIndex, Length[family["vertices"]]}
     ];
   <|
    "status" -> "generated",
    "generationRoute" -> "directTreePhase",
    "terms" -> dsTreeZeroTokenTerms[Expand[Total[terms]]],
    "internalExpression" -> Expand[Total[terms]]
    |>
   ];


dsTreeNaiveAllowedVariables[context_Association, familyContext_Association] := DeleteDuplicates@Join[
   dsDEResolveVariables[Automatic, context],
   Variables[Cases[
     familyContext["families"],
     leg_Association /; KeyExistsQ[leg, "nu"] && KeyExistsQ[leg, "energy"] :> leg["energy"],
     Infinity
     ]]
   ];


dsTreeNaiveMasterDerivative[master_Association, variable_, familyContext_Association, context_Association] := Module[
   {family, rootTopology, phaseData, lineDerivative, bareToken, bareDerivative,
    normalizedDerivative, publicTerms},
   family = dsTreeFamilyBySector[master["sectorKey"], familyContext];
   If[Head[family] === Missing, Return[<|"status" -> "failed", "reason" -> "unknownSector"|>]];
   rootTopology = context["topology"];
   phaseData = dsTreePhaseDerivativeDirect[master["integral"], variable, family, rootTopology];
   If[Lookup[phaseData, "status", "failed"] =!= "generated", Return[phaseData]];
   lineDerivative = dsTreeLineEnergyDerivative[master["integral"], variable, family];
   If[lineDerivative === $Failed, Return[<|"status" -> "failed", "reason" -> "lineEnergyDerivativeFailed"|>]];
   bareToken = dsTreeToken[master["sectorKey"], master["integral"]];
   bareDerivative = Expand[phaseData["internalExpression"] + lineDerivative];
   normalizedDerivative = Expand[
     D[master["coefficient"], variable] bareToken + master["coefficient"] bareDerivative
     ];
   publicTerms = dsTreeZeroTokenTerms[normalizedDerivative];
   <|
    "status" -> If[publicTerms === $Failed, "failed", "generated"],
    "master" -> master,
    "variable" -> variable,
    "phaseDerivativeRoute" -> phaseData["generationRoute"],
    "directPhaseDerivativeTerms" -> phaseData["terms"],
    "lineEnergyDerivativeTerms" -> dsTreeZeroTokenTerms[lineDerivative],
    "masterNormalizationDerivative" -> D[master["coefficient"], variable],
    "rawTerms" -> publicTerms,
    "internalExpression" -> normalizedDerivative
    |>
   ];


dsTreeNaiveVariableData[variable_, ibpData_Association, familyContext_Association, context_Association, progress_] := Module[
   {masters, derivativeRecords, rules, reduced, masterTokens, coefficientTokens, normalizedMasterRules,
    tokenExpressions, coefficients, residuals, residualTokens, rows},
   masters = ibpData["masters"];
   derivativeRecords = dsProgressMap[
     "正在构造 naive tree " <> ToString[variable, InputForm] <> " 导数 / Building naive-tree " <> ToString[variable, InputForm] <> " derivatives",
     masters,
     Function[master, dsTreeNaiveMasterDerivative[master, variable, familyContext, context]],
     progress
     ];
   If[AnyTrue[derivativeRecords, Lookup[#, "status", "failed"] =!= "generated" &],
    Return[<|"status" -> "failed", "variable" -> variable, "reason" -> "derivativeGenerationFailed",
      "derivativeRecords" -> derivativeRecords|>]
    ];
   rules = dsTreeInternalReductionRules[ibpData];
   reduced = Expand[Lookup[derivativeRecords, "internalExpression"] /. rules];
   masterTokens = dsTreeToken[Lookup[#, "sectorKey"], Lookup[#, "integral"]] & /@ masters;
   coefficientTokens = Array[Unique["dsTreeMaster$"] &, Length[masters]];
   normalizedMasterRules = MapThread[#1 -> #2/#3 &,
     {masterTokens, coefficientTokens, Lookup[masters, "coefficient"]}];
   tokenExpressions = Expand[reduced /. normalizedMasterRules];
   coefficients = Table[Coefficient[tokenExpressions[[row]], coefficientTokens[[column]]],
     {row, Length[masters]}, {column, Length[masters]}];
   residuals = Expand[tokenExpressions - coefficients . coefficientTokens];
   residualTokens = DeleteDuplicates[Cases[residuals, _dsTreeToken, Infinity]];
   rows = MapThread[
     <|"master" -> #1, "coefficients" -> #2, "source" -> #3|> &,
     {masters, coefficients, residuals}
     ];
   <|
    "status" -> If[residualTokens === {} && And @@ (TrueQ[# === 0] & /@ residuals), "generated", "notClosed"],
    "variable" -> variable,
    "matrix" -> coefficients,
    "source" -> residuals,
    "rows" -> rows,
    "derivativeRecords" -> (KeyDrop[#, "internalExpression"] & /@ derivativeRecords),
    "residualObjects" -> residualTokens
    |>
   ];


dsTreeNaiveDEFromIBP[ibpData_Association, variables_, OptionsPattern[DSTreeNaiveDE]] := Module[
   {context, familyContext, resolvedVariables, allowedVariables, badVariables, variableRecords, variableData, status},
   If[Lookup[ibpData, "status", "failed"] =!= "solved" || ! ListQ[Lookup[ibpData, "masters", None]],
    Message[DSTreeNaiveDE::badibp]; Return[<|"status" -> "failed", "reason" -> "invalidNaiveIBPData"|>]
    ];
   context = Lookup[ibpData, "context", Missing["context"]];
   If[! dsContextQ[context], Message[DSTreeNaiveDE::badibp]; Return[<|"status" -> "failed", "reason" -> "missingContext"|>]];
   familyContext = dsTreeFamilyContext[context];
   allowedVariables = dsTreeNaiveAllowedVariables[context, familyContext];
   resolvedVariables = If[variables === Automatic, allowedVariables, dsDEResolveVariables[variables, context]];
   badVariables = Complement[resolvedVariables, allowedVariables];
   If[badVariables =!= {},
    Message[DSTreeNaiveDE::badvars, badVariables];
    Return[<|"status" -> "failed", "reason" -> "invalidVariables", "badVariables" -> badVariables,
      "allowedVariables" -> allowedVariables|>]
    ];
   variableRecords = dsProgressMap[
     "正在生成 naive tree 微分方程 / Building naive-tree differential equations",
     resolvedVariables,
     Function[variable, dsTreeNaiveVariableData[
       variable, ibpData, familyContext, context, OptionValue[ProgressReporting]
       ]],
     OptionValue[ProgressReporting]
     ];
   variableData = AssociationThread[resolvedVariables, variableRecords];
   status = Which[
     AnyTrue[variableRecords, Lookup[#, "status", "failed"] === "failed" &], "failed",
     AnyTrue[variableRecords, Lookup[#, "status", "failed"] === "notClosed" &], "notClosed",
     True, "generated"
     ];
   <|
    "status" -> status,
    "masters" -> ibpData["masters"],
    "masterCount" -> Length[ibpData["masters"]],
    "variables" -> resolvedVariables,
    "matrices" -> AssociationThread[resolvedVariables, Lookup[variableRecords, "matrix", {}]],
    "sources" -> AssociationThread[resolvedVariables, Lookup[variableRecords, "source", {}]],
    "residualObjects" -> AssociationThread[resolvedVariables, Lookup[variableRecords, "residualObjects", {}]],
    "variableData" -> variableData,
    "naiveIBP" -> KeyDrop[ibpData, {"seedRecords", "context"}],
    "context" -> context,
    "equationConvention" -> "D[normalized tagged masters,var] == matrices[var].normalized tagged masters + sources[var]",
    "derivativeRoute" -> "direct tree phase derivative + direct h treeEnergy derivative -> direct tree dtau reduction",
    "formulaDLogUsedQ" -> False
    |>
   ];


dsTreeNaiveDERaw018[context_Association, variables_: Automatic, masters_: Automatic, OptionsPattern[DSTreeNaiveDE]] /; dsContextQ[context] := Module[
   {ibpData},
   If[treeFormulaMasslessPendingQ018[context],
    Return[treeFormulaPendingRederivation018["DSTreeNaiveDE", context]]
    ];
   ibpData = dsTreeNaiveIBPRaw018[context, masters,
     AuditLevel -> OptionValue[AuditLevel], ProgressReporting -> OptionValue[ProgressReporting]];
   If[Lookup[ibpData, "status", "failed"] =!= "solved", ibpData,
    dsTreeNaiveDEFromIBP[ibpData, variables, ProgressReporting -> OptionValue[ProgressReporting]]]
   ];


DSTreeNaiveDE[_, ___] := (Message[DSTreeNaiveDE::badibp]; <|"status" -> "failed", "reason" -> "invalidContextOrIBPData"|>);
