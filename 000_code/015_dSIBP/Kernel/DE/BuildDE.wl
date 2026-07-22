(* ::Package:: *)

(* ::Chapter:: *)
(*015 微分方程构造*)

(* DSDE 只消费经 KiraImport 验证的 reduction data；不会从不完整日志猜测 master 或规则。 *)

Options[DSDE] = {
   MaxReductionIterations -> 100,
   OutputDirectory -> None,
   ProgressReporting -> Automatic
   };

DSDE::badreduction = "DSDE 只接受 DSKiraImport 验证通过的 reductionData。";
DSDE::badvars = "微分变量必须是当前 family 初始化的外部独立变量：`1`。";
DSDE::baditer = "MaxReductionIterations 必须是正整数，收到 `1`。";
DSDE::writefailed = "DE 结果写入失败：`1`。";

dsDEResolveVariables[Automatic, context_Association] := scalarProductInternalToUser[#, context["topology"]] & /@
   independentVariableDerivativeVariables[context["topology"]];
dsDEResolveVariables[variable_List, _Association] := variable;
dsDEResolveVariables[variable_, _Association] := {variable};

dsSectorTopologyForIntegral[int_J, context_Association] := Module[{metadata, matches, shrunk},
   metadata = context["sectors"];
   matches = Select[metadata, integralMatchesSectorMetadataQ[int, #] &];
   If[Length[matches] =!= 1, Return[$Failed]];
   shrunk = Lookup[First[matches], "sectorShrunkLines", {}];
   If[shrunk === {}, context["topology"], shrinkSectorTopology[context["topology"], shrunk]]
   ];

dsReduceExpression[expr_, rules_List, maxIterations_Integer] := FixedPoint[ReplaceAll[#, rules] &, Expand[expr], maxIterations];

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

dsDEVariableData[variable_, masterDefinitions_List, masterTokens_List, rules_List, parameterRules_List, context_Association, maxIterations_Integer, progress_] := Module[
   {raw, reduced, decompositions},
   raw = dsProgressMap[
     "正在构造 " <> ToString[variable, InputForm] <> " 导数",
     masterDefinitions,
     Function[master, dsSectorAwareDerivative[master, variable, context] /. parameterRules],
     progress
     ];
   If[MemberQ[raw, $Failed], Return[<|"status" -> "failed", "variable" -> variable, "reason" -> "dsFailed", "rawDerivatives" -> raw|>]];
   reduced = dsProgressMap[
     "正在约化 " <> ToString[variable, InputForm] <> " 导数",
     raw,
     Function[expr, dsReduceExpression[expr, rules, maxIterations]],
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
   {context, masters, masterTokens, rules, resolvedVariables, allowedVariables, badVariables, maxIterations,
    parameterRules, variableRecords, variableData, status, result, outputDirectory = OptionValue[OutputDirectory], writeResult},
   If[Lookup[reductionData, "status", "missing"] =!= "imported" ||
     Lookup[Lookup[reductionData, "validationReport", <||>], "status", "missing"] =!= "passed",
    Message[DSDE::badreduction]; dsErrorPrint["reductionData 未经 DSKiraImport 完整验证。"]; Return[<|"status" -> "failed", "reason" -> "unvalidatedReductionData"|>]
    ];
   context = Lookup[reductionData, "context", Missing["context"]];
   If[! dsContextQ[context], Message[DSDE::badreduction]; Return[<|"status" -> "failed", "reason" -> "missingContext"|>]];
   masters = reductionData["masters"];
   masterTokens = Lookup[reductionData, "masterTokens", masters];
   If[! ListQ[masters] || ! ListQ[masterTokens] || Length[masters] =!= Length[masterTokens] || masters === {},
    Message[DSDE::badreduction]; Return[<|"status" -> "failed", "reason" -> "invalidMasterDefinitionsOrTokens"|>]
    ];
   rules = reductionData["reductionRules"];
   (* fixed-rational export 必须在 DE 原子求导层复用同一规则，否则 h EOM 会重新引入 nu 等固定参数。 *)
   parameterRules = If[
     TrueQ[Lookup[Lookup[reductionData, "sourceManifest", <||>], "numericRulesAppliedBeforeSeeds", False]],
     Lookup[context["topology"], "numericRules", {}],
     {}
     ];
   resolvedVariables = dsDEResolveVariables[variables, context];
   allowedVariables = dsDEResolveVariables[Automatic, context];
   badVariables = Complement[resolvedVariables, allowedVariables];
   If[badVariables =!= {},
    Message[DSDE::badvars, badVariables]; dsErrorPrint["DSDE 变量不属于当前 family 的外部表示。"]; Return[<|"status" -> "failed", "reason" -> "invalidVariables", "badVariables" -> badVariables, "allowedVariables" -> allowedVariables|>]
    ];
   maxIterations = OptionValue[MaxReductionIterations];
   If[! IntegerQ[maxIterations] || maxIterations <= 0,
    Message[DSDE::baditer, maxIterations]; dsErrorPrint["reduction 迭代上限无效。"]; Return[<|"status" -> "failed", "reason" -> "invalidMaxReductionIterations"|>]
    ];
   variableRecords = dsProgressMap[
     "正在生成微分方程",
     resolvedVariables,
     Function[variable, dsDEVariableData[variable, masters, masterTokens, rules, parameterRules, context, maxIterations, OptionValue[ProgressReporting]]],
     OptionValue[ProgressReporting]
     ];
   variableData = AssociationThread[resolvedVariables, variableRecords];
   status = Which[
     AnyTrue[variableRecords, Lookup[#, "status", "failed"] === "failed" &], "failed",
     AnyTrue[variableRecords, Lookup[#, "status", "notClosed"] === "notClosed" &], "notClosed",
     True, "generated"
     ];
   result = <|
     "status" -> status,
     "masters" -> masters,
     "masterTokens" -> masterTokens,
     "masterCount" -> Length[masters],
     "variables" -> resolvedVariables,
     "matrices" -> AssociationThread[resolvedVariables, Lookup[variableRecords, "matrix", {}]],
     "sources" -> AssociationThread[resolvedVariables, Lookup[variableRecords, "source", {}]],
     "residualIntegrals" -> AssociationThread[resolvedVariables, Lookup[variableRecords, "residualIntegrals", {}]],
     "residualBackendTokens" -> AssociationThread[resolvedVariables, Lookup[variableRecords, "residualBackendTokens", {}]],
     "residualObjects" -> AssociationThread[resolvedVariables, Lookup[variableRecords, "residualObjects", {}]],
     "variableData" -> variableData,
     "sourceManifest" -> reductionData["sourceManifest"],
     "activeBasis" -> Lookup[reductionData, "activeBasis", <|"status" -> "disabled", "count" -> 0|>],
     "parameterRulesApplied" -> If[parameterRules === {}, {}, userNumericRules[context["topology"]]],
     "context" -> context,
     "equationConvention" -> "D[masters,var] == matrices[var].masters + sources[var]",
     "reductionValidationReport" -> reductionData["validationReport"]
     |>;
   writeResult = If[StringQ[outputDirectory], dsWriteDEResult[result, ExpandFileName[outputDirectory]], <|"status" -> "notRequested"|>];
   If[Lookup[writeResult, "status", "failed"] === "failed", Message[DSDE::writefailed, outputDirectory]; dsErrorPrint["DE 文件未写出。"]];
   Join[result, <|"writeResult" -> writeResult|>]
   ];

DSDE[reductionData_, variables_: Automatic, OptionsPattern[]] := (Message[DSDE::badreduction]; dsErrorPrint["DSDE 输入必须是 reductionData Association。"]; <|"status" -> "failed", "reason" -> "inputNotAssociation"|>);


(* ::Chapter:: *)
(*Naive tree IBP 微分方程*)

(* 顶点相位导数继续由 loop 原子层生成后投影；treeEnergy 是树图的外部能量，不能误当成
   loop 适配器中的积分动量，必须由 h 的动量导数关系直接生成 tree 指标移位。
   sector master 的 normalization N 最后另按乘积法则求导。 *)

Options[DSTreeNaiveDE] = {ProgressReporting -> Automatic};

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


dsTreePhaseDerivative[loopIntegral_J, variable_, family_Association, rootTopology_Association] := Module[
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


dsTreeNaiveAllowedVariables[context_Association, familyContext_Association] := DeleteDuplicates@Join[
   dsDEResolveVariables[Automatic, context],
   Variables[Cases[
     familyContext["families"],
     leg_Association /; KeyExistsQ[leg, "nu"] && KeyExistsQ[leg, "energy"] :> leg["energy"],
     Infinity
     ]]
   ];


dsTreeNaiveMasterDerivative[master_Association, variable_, familyContext_Association, context_Association] := Module[
   {family, rootTopology, loopIntegral, phaseData, lineDerivative, bareToken, bareDerivative,
    normalizedDerivative, publicTerms},
   family = dsTreeFamilyBySector[master["sectorKey"], familyContext];
   If[Head[family] === Missing, Return[<|"status" -> "failed", "reason" -> "unknownSector"|>]];
   rootTopology = context["topology"];
   loopIntegral = treeLoopIntegralFromTree[master["integral"], family];
   If[loopIntegral === $Failed, Return[<|"status" -> "failed", "reason" -> "treeLoopBackProjectionFailed"|>]];
   phaseData = dsTreePhaseDerivative[loopIntegral, variable, family, rootTopology];
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
    "loopRepresentative" -> loopIntegral,
    "loopPhaseDerivative" -> phaseData["loopDerivative"],
    "projectedPhaseDerivative" -> phaseData["projectedData"],
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
     "正在构造 naive tree " <> ToString[variable, InputForm] <> " 导数",
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
     "正在生成 naive tree 微分方程",
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
    "derivativeRoute" -> "loop phase derivative projection + direct h treeEnergy derivative -> naive projected dtau reduction",
    "formulaDLogUsedQ" -> False
    |>
   ];


DSTreeNaiveDE[context_Association, variables_: Automatic, masters_: Automatic, OptionsPattern[]] /; dsContextQ[context] := Module[
   {ibpData = DSTreeNaiveIBP[context, masters, ProgressReporting -> OptionValue[ProgressReporting]]},
   If[Lookup[ibpData, "status", "failed"] =!= "solved", ibpData,
    dsTreeNaiveDEFromIBP[ibpData, variables, ProgressReporting -> OptionValue[ProgressReporting]]]
   ];


DSTreeNaiveDE[ibpData_Association, variables_: Automatic, OptionsPattern[]] /;
   Lookup[ibpData, "status", "failed"] === "solved" :=
   dsTreeNaiveDEFromIBP[ibpData, variables, ProgressReporting -> OptionValue[ProgressReporting]];


DSTreeNaiveDE[_, ___] := (Message[DSTreeNaiveDE::badibp]; <|"status" -> "failed", "reason" -> "invalidContextOrIBPData"|>);
