(* ::Package:: *)
(* 本脚本只验证已经完成的真实 Kira reduction，不重新生成 seed、linearData 或 Kira 输入。
   它重建与 main.wl 相同的等能量 family context，再依次检查导入、19 维 DE 和标度关系。 *)

(* ::Chapter:: *)
(*标准 package 与 family convention*)

exampleDir = DirectoryName[$InputFileName];
packageDir = DirectoryName[DirectoryName[exampleDir]];
Get[FileNameJoin[{packageDir, "package_014.wl"}]];
Get[FileNameJoin[{exampleDir, "dlog_basis.wl"}]];
Get[FileNameJoin[{exampleDir, "family_conventions.wl"}]];

(* 与 export 端共享冻结的精确参数点，不在后处理阶段重新抽取或改值。 *)
parameterProbeSeed = 20260722;
parameterProbeRules = {dim -> 37/11, nu -> 7/13, etaNu -> 23/17};


(* ::Chapter:: *)
(*等能量 family 初始化*)

(* 顶点交换 symmetry 只在 reference P1=P2=-P0 时成立；独立 P1/P2 family 不得复用本配置。 *)
caseInput = <|
   "name" -> "014PureMassiveBubbleClosedLoopMinusMinus",
   "vertexData" -> {{v1, "-"}, {v2, "-"}},
   "lineData" -> {
     <|"id" -> 1, "endpoints" -> {v1, v2}, "momentum" -> q,
       "massType" -> "massive", "bbType" -> "h", "nu" -> nu|>,
     <|"id" -> 2, "endpoints" -> {v1, v2}, "momentum" -> q - k,
       "massType" -> "massive", "bbType" -> "h", "nu" -> nu|>
     },
   "loopMomenta" -> {q},
   "externalMomenta" -> {k},
   "externalInvariantRules" -> {sp[k, k] -> s11},
   "vertexEnergies" -> <|v1 -> P0, v2 -> P0|>,
   "ispData" -> {},
   "numericRules" -> parameterProbeRules,
   "zeroPointRules" -> {
     a0[v1] -> 2 nu, a0[v2] -> 2 nu,
     b0[1] -> -2 nu, b0[2] -> -2 nu
     },
   "shrinkPrefactorRules" -> {Exp[Pi Im[nu]]/Pi -> etaNu},
   "symmetryRules" -> exampleSymmetryRules0,
   "seedPreset" -> "quickCheck",
   "seedRanges" -> <|"a" -> {0}, "b" -> {0}, "isp" -> {0}, "sampleOnly" -> False|>,
   "generatorSeedRanges" -> referenceGeneratorSeedRanges,
   "seedOptions" -> <|"DiscreteMode" -> "all", "MaxSeedRuleCount" -> 5000, "MaxEquationCount" -> 100000|>
   |>;

context = DSInit[
   caseInput,
   WriteInitializationFiles -> False,
   GenerateDerivativeMetadata -> False,
   OverwriteInitialization -> False
   ];


(* ::Chapter:: *)
(*真实 Kira 结果取回与微分方程*)

kiraDir = FileNameJoin[{exampleDir, "kira"}];
deDir = FileNameJoin[{exampleDir, "results", "dlogDE"}];
savedDEFile = FileNameJoin[{deDir, "manifest.wl"}];
buildDESource = FileNameJoin[{packageDir, "package_014.wl"}];
summaryFile = FileNameJoin[{exampleDir, "results", "post_kira_summary.wl"}];

reductionData = DSKiraImport[kiraDir, context];
(* 已有 DE 是本脚本上一轮从同一 manifest 重算的正式结果；删除该目录即可强制重新调用 DSDE。 *)
deData = If[
   FileExistsQ[savedDEFile] &&
    FileDate[savedDEFile] >= FileDate[FileNameJoin[{kiraDir, "results", "Tuserweight", "kira_list.m"}]] &&
    FileDate[savedDEFile] >= FileDate[buildDESource],
   Join[Get[savedDEFile], <|"context" -> context|>],
   DSDE[reductionData, {s11, P0}, OutputDirectory -> deDir]
   ];
scaleData = DSScaleCheck[
   deData,
   <|
    "relation" -> "PureMassiveBubble",
    "variables" -> {s11, P0},
    (* ks d/dks = 2 s11 d/ds11，P0 与 k0 具有相同标度权重。 *)
    "weights" -> {2, 1}
    |>
   ];


(* ::Chapter:: *)
(*闭环验收*)

expectedMasters = (referenceDlogCandidates[[referenceDlogActiveIndices]] /. {P1 -> -P0, P2 -> -P0} /. parameterProbeRules);
expectedMasterIDs = Range[19];
expectedMasterTokens = Tuserweight /@ expectedMasterIDs;
sourceManifest = Lookup[reductionData, "sourceManifest", <||>];
probeSymbols = First /@ parameterProbeRules;
dePublicData = HoldComplete[
   Lookup[deData, "masters", {}],
   Lookup[deData, "matrices", <||>],
   Lookup[deData, "sources", <||>]
   ];
fixedParameterResiduals = Select[probeSymbols, ! FreeQ[dePublicData, #] &];

(* sourceManifest/backendReductionRules 有意保留可逆后端映射；用户结果面不得出现这些原子。 *)
backendLeakSymbols = DeleteDuplicates @ Cases[
    HoldComplete[
     Lookup[reductionData, "reductionRules", {}],
     Lookup[deData, "masters", {}],
     Lookup[deData, "matrices", <||>],
     Lookup[deData, "sources", <||>]
     ],
    symbol_Symbol /; StringMatchQ[SymbolName[Unevaluated[symbol]], ("dsc" ~~ ___) | "dsii"],
    Infinity
    ];

validationChecks = Lookup[Lookup[reductionData, "validationReport", <||>], "checks", <||>];
checks = <|
   "importStatus" -> (Lookup[reductionData, "status", "missing"] === "imported"),
   "importValidation" -> (Lookup[Lookup[reductionData, "validationReport", <||>], "status", "missing"] === "passed"),
   "activeMasterCount" -> (Length[Lookup[reductionData, "masters", {}]] === 19),
   "activeMasterIDs" -> (Lookup[reductionData, "masterIDs", {}] === expectedMasterIDs),
   "activeMasterTokens" -> (Lookup[reductionData, "masterTokens", {}] === expectedMasterTokens),
   "activeMasterOrder" -> (Lookup[reductionData, "masters", {}] === expectedMasters),
   "auxiliaryIDsNotMasters" -> (Intersection[{20, 21}, Lookup[reductionData, "backendMasterIDs", {}]] === {}),
   "completeTargetCoverage" -> TrueQ[Lookup[validationChecks, "completeTargetCoverage", False]],
   "rhsContainsOnlyMasters" -> TrueQ[Lookup[validationChecks, "rhsContainsOnlyMasters", False]],
   "deStatus" -> (Lookup[deData, "status", "missing"] === "generated"),
   "deMasterOrder" -> (Lookup[deData, "masters", {}] === expectedMasters),
   "deVariables" -> (Lookup[deData, "variables", {}] === {s11, P0}),
   "deDimensions" -> (And @@ (Dimensions[#] === {19, 19} & /@ Values[Lookup[deData, "matrices", <||>]])),
   "noResidualJ" -> FreeQ[Lookup[deData, "residualIntegrals", <||>], _J],
   "noResidualBackendTokens" -> FreeQ[Lookup[deData, "residualBackendTokens", <||>], Tuserweight[_Integer]],
   "noBackendCoefficientSymbols" -> (backendLeakSymbols === {}),
   "manifestParameterRules" -> (Lookup[sourceManifest, "userNumericRules", Missing["numericRules"]] === parameterProbeRules),
   "numericRulesAppliedBeforeSeeds" -> TrueQ[Lookup[sourceManifest, "numericRulesAppliedBeforeSeeds", False]],
   "noFixedParameterResidual" -> (fixedParameterResiduals === {}),
   "scalingStatus" -> (Lookup[scaleData, "status", "missing"] === "passed"),
   "scalingMatrixResidual" -> TrueQ[Lookup[Lookup[scaleData, "checks", <||>], "matrixRelation", False]],
   "scalingSourceResidual" -> TrueQ[Lookup[Lookup[scaleData, "checks", <||>], "sourceRelation", False]]
   |>;

failedChecks = Keys @ Select[checks, ! TrueQ[#] &];
summary = <|
   "status" -> If[failedChecks === {}, "passed", "failed"],
   "passed" -> Count[Values[checks], True],
   "total" -> Length[checks],
   "failedChecks" -> failedChecks,
   "backendMasterIDs" -> Lookup[reductionData, "backendMasterIDs", {}],
   "activeMasterIDs" -> Lookup[reductionData, "masterIDs", {}],
   "deVariables" -> Lookup[deData, "variables", {}],
   "parameterProbeSeed" -> parameterProbeSeed,
   "parameterProbeRules" -> parameterProbeRules,
   "fixedParameterResiduals" -> fixedParameterResiduals,
   "scalingDegrees" -> Lookup[scaleData, "degrees", {}]
   |>;

Print[summary];
Quiet[CreateDirectory[DirectoryName[summaryFile], CreateIntermediateDirectories -> True]];
Put[summary, summaryFile];
If[failedChecks =!= {}, Exit[1]];
