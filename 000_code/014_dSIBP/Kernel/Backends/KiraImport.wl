(* ::Package:: *)

(* ::Chapter:: *)
(*014 Kira 结果取回*)

Options[DSKiraImport] = {
   KiraReductionFile -> Automatic,
   KiraMasterFile -> Automatic,
   KiraCompletionFile -> Automatic,
   KiraCompletionPatterns -> Automatic,
   ProgressReporting -> Automatic
   };

DSKiraImport::badpath = "Kira workspace 路径不存在或不是目录：`1`。";
DSKiraImport::missing = "Kira 结果缺少必需文件：`1`。";
DSKiraImport::incomplete = "Kira 完成日志没有成功标记：`1`。";
DSKiraImport::mismatch = "Kira 结果与当前 export/context 不一致：`1`。";
DSKiraImport::invalid = "Kira reduction 数据未通过完整性检查：`1`。";

dsKiraResolveFile[root_String, Automatic, relative : {__String}] := FileNameJoin[Prepend[relative, root]];
dsKiraResolveFile[root_String, Automatic, relatives : {__List}] := Module[{paths},
   paths = FileNameJoin[Prepend[#, root]] & /@ relatives;
   SelectFirst[paths, FileExistsQ, First[paths]]
   ];
dsKiraResolveFile[root_String, path_String, _List] := ExpandFileName[If[dsAbsolutePathQ[path], path, FileNameJoin[{root, path}]]];
dsKiraResolveFile[_String, _, _List] := $Failed;

dsKiraCompletionPatterns[Automatic] := {
   RegularExpression["(?i)kira[^\\n]*(?:finished|completed)[^\\n]*(?:success|successfully)"],
   RegularExpression["(?i)all jobs[^\\n]*(?:finished|completed)[^\\n]*(?:success|successfully)"],
   RegularExpression["(?i)unreduced integrals:\\s*0\\.?"],
   "Kira finished successfully"
   };
dsKiraCompletionPatterns[patterns_List] := patterns;
dsKiraCompletionPatterns[pattern_] := {pattern};

dsKiraCompletionQ[text_String, patterns_] := AnyTrue[
   dsKiraCompletionPatterns[patterns],
   Function[pattern, StringContainsQ[text, pattern] || StringMatchQ[text, ___ ~~ pattern ~~ ___]]
   ];

dsKiraReadExpression[path_String] := Quiet[Check[Get[path], $Failed]];

dsKiraMasterIDs[text_String] := DeleteDuplicates @ ToExpression @ StringCases[
   text,
   StartOfLine ~~ WhitespaceCharacter ... ~~ id : NumberString ~~ WhitespaceCharacter ... ~~ "#" :> id
   ];

dsRuleListQ[rules_] := ListQ[rules] && And @@ (MatchQ[Unevaluated[#], _Rule | _RuleDelayed] & /@ rules);

dsJToIDPairs[rules_List] := Cases[rules, HoldPattern[integral_J -> id_Integer] :> {integral, id}];
dsIDToJPairs[rules_List] := Cases[rules, HoldPattern[Tuserweight[id_Integer] -> integral_J] :> {id, integral}];

(* 双向文本相等还不够：同步重复的积分或 ID 也会相等，但并不是可逆编号。 *)
dsKiraInverseMapQ[jToKira_List, kiraToJ_List] := Module[{forward, backward},
   forward = SortBy[dsJToIDPairs[jToKira], Last];
   backward = SortBy[Reverse /@ dsIDToJPairs[kiraToJ], Last];
   forward === backward &&
    Length[forward] === Length[jToKira] && Length[backward] === Length[kiraToJ] &&
    DuplicateFreeQ[First /@ forward] && DuplicateFreeQ[Last /@ forward]
   ];

dsKiraRuleIDs[rules_List] := <|
   "lhs" -> DeleteDuplicates @ Cases[rules, HoldPattern[Tuserweight[id_Integer] -> _] :> id],
   "rhs" -> DeleteDuplicates @ Cases[Last /@ rules, Tuserweight[id_Integer] :> id, Infinity],
   "all" -> DeleteDuplicates @ Cases[rules, Tuserweight[id_Integer] :> id, Infinity]
   |>;

dsKiraCoefficientVariables[rules_List] := Module[{rhs},
   rhs = Last /@ rules /. Tuserweight[_Integer] -> 1;
   DeleteDuplicates[Variables[Together /@ rhs]]
   ];

dsKiraBackendVariableNames[rules_List] := DeleteDuplicates[
   SymbolName /@ Select[dsKiraCoefficientVariables[rules], Head[#] === Symbol &]
   ];

dsKiraBackendRestoreRules[variableMap_List, imaginaryUnit_] := Join[
   Map[
    Function[item,
     With[{name = Lookup[item, "backend"], original = Lookup[item, "original"]},
      HoldPattern[s_Symbol /; SymbolName[s] === name] :> original
      ]
     ],
    variableMap
    ],
   If[StringQ[imaginaryUnit],
    {With[{name = imaginaryUnit}, HoldPattern[s_Symbol /; SymbolName[s] === name] :> I]},
    {}
    ]
   ];

dsKiraRestoreBackendCoefficients[rules_List, variableMap_List, imaginaryUnit_] :=
   rules /. dsKiraBackendRestoreRules[variableMap, imaginaryUnit];

dsKiraContextMatchQ[manifest_Association, context_Association] := And[
   Lookup[manifest, "packageVersion", Missing["packageVersion"]] === Lookup[context, "packageVersion", Missing["contextVersion"]],
   Lookup[Lookup[manifest, "context", <||>], "inputHash", Missing["inputHash"]] === Lookup[context, "inputHash", Missing["contextHash"]],
   Lookup[manifest, "zeroPointRules", Missing["zeroPointRules"]] === Lookup[context["topology"], "zeroPointRules", Missing["contextZeroPointRules"]],
   Lookup[manifest, "symmetryRules", Missing["symmetryRules"]] === Lookup[context["topology"], "symmetryRules", Missing["contextSymmetryRules"]],
   Lookup[manifest, "tadpoleSymmetryData", Missing["tadpoleSymmetryData"]] === dsStableTadpoleSymmetryData[Lookup[context["topology"], "tadpoleSymmetryData", tadpoleSymmetryData[context["topology"]]]],
   Lookup[manifest, "loopTreeProjectionConvention", Missing["projectionConvention"]] === Lookup[context, "loopTreeProjectionConvention", Missing["contextProjectionConvention"]]
   ];


(* ::Section::Closed:: *)
(*Active basis manifest 门禁*)

dsKiraActiveBasisData[manifest_Association] := Lookup[manifest, "activeBasis", <|"status" -> "disabled", "count" -> 0|>];

dsKiraActiveBasisDataQ[data_Association] := Module[
   {status, count, activeCount, names, expressions, ids, tokens, activeIndices, activeNames,
    activeExpressions, activeIDs, activeTokens, auxiliaryIDs, variables, targetIDs},
   status = Lookup[data, "status", "disabled"];
   If[status === "disabled", Return[True]];
   count = Lookup[data, "count", -1];
   activeCount = Lookup[data, "activeCount", -1];
   names = Lookup[data, "names", {}];
   expressions = Lookup[data, "expressions", {}];
   ids = Lookup[data, "ids", {}];
   tokens = Lookup[data, "tokens", {}];
   activeIndices = Lookup[data, "activeIndices", {}];
   activeNames = Lookup[data, "activeNames", {}];
   activeExpressions = Lookup[data, "activeExpressions", {}];
   activeIDs = Lookup[data, "activeIDs", {}];
   activeTokens = Lookup[data, "activeTokens", {}];
   auxiliaryIDs = Lookup[data, "auxiliaryIDs", {}];
   variables = Lookup[data, "derivativeVariables", {}];
   targetIDs = Lookup[data, "targetIntegralIDs", {}];
   status === "configured" && IntegerQ[count] && count > 0 && IntegerQ[activeCount] && activeCount > 0 &&
    Length[names] === count && Length[expressions] === count && Length[ids] === count && Length[tokens] === count &&
    And @@ (StringQ[#] && # =!= "" & /@ names) && DuplicateFreeQ[names] &&
    ids === Range[count] && tokens === (Tuserweight /@ ids) &&
    Length[activeIndices] === activeCount && DuplicateFreeQ[activeIndices] &&
    And @@ (IntegerQ[#] && 1 <= # <= count & /@ activeIndices) &&
    activeIDs === ids[[activeIndices]] && activeNames === names[[activeIndices]] &&
    activeExpressions === expressions[[activeIndices]] && activeTokens === (Tuserweight /@ activeIDs) &&
    auxiliaryIDs === Complement[ids, activeIDs] && variables =!= {} &&
    DuplicateFreeQ[targetIDs] && Complement[activeIDs, targetIDs] === {}
   ];

dsKiraBackendMasterObject[id_Integer, activeIDs_List, idToJ_Association] := If[
   MemberQ[activeIDs, id],
   Tuserweight[id],
   Lookup[idToJ, id, Missing["unrecognizedBackendMasterID", id]]
   ];

DSKiraImport[root_String, context_: Automatic, OptionsPattern[]] := Module[
   {resolved, workspace, files, missingFiles, manifest, repJ2Kira, repKira2J, reductionRulesBackend, reductionRulesRaw, masterText,
    completionText, completionQ, mapQ, manifestMapQ, contextQ, masterIDs, mapPairs, idToJ, mapIDs,
    dummyID, targetIDs, ruleIDs, completeTargetsQ, rhsMastersQ, coefficientVariables, allowedCoefficientVariables,
    coefficientQ, coefficientVariableMap, backendImaginaryUnit, backendVariableNames, allowedBackendVariableNames,
    backendCoefficientQ, activeData, activeDataQ, activeQ, relationIDs, activeIDs, auxiliaryIDs, activeExpressions, activeTokens,
    activeMasterOrderQ, auxiliaryNotMastersQ, recognizedIDs, backendMasters, boundaryMasterIDs, boundaryMasters,
    checks, issues, reductionRules, masters, masterTokens, returnedMasterIDs, progress = OptionValue[ProgressReporting]},
   resolved = dsResolveContext[context];
   If[Head[resolved] === Missing,
    Message[DSKiraImport::mismatch, "missing DSInit context"]; dsErrorPrint["Kira import 需要同源 DSInit context。"]; Return[<|"status" -> "failed", "reason" -> "missingContext"|>]
    ];
   workspace = ExpandFileName[root];
   If[! DirectoryQ[workspace],
    Message[DSKiraImport::badpath, workspace]; dsErrorPrint["Kira workspace 不存在。"]; Return[<|"status" -> "failed", "reason" -> "invalidWorkspace", "workspace" -> workspace|>]
    ];
   files = <|
     "manifest" -> FileNameJoin[{workspace, "dsibp-export-manifest.wl"}],
     "repJ2Kira" -> FileNameJoin[{workspace, "result", "repJ2kira.m"}],
     "repKira2J" -> FileNameJoin[{workspace, "result", "repkira2J.m"}],
     "reduction" -> dsKiraResolveFile[workspace, OptionValue[KiraReductionFile], {
        {"results", "Tuserweight", "kira_list.m"},
        {"results", "kira_list.m"}
        }],
     "masters" -> dsKiraResolveFile[workspace, OptionValue[KiraMasterFile], {
        {"results", "Tuserweight", "masters"},
        {"results", "masters"}
        }],
     "completion" -> dsKiraResolveFile[workspace, OptionValue[KiraCompletionFile], {"kira.log"}]
     |>;
   missingFiles = Select[Normal[files], ! StringQ[Last[#]] || ! FileExistsQ[Last[#]] &];
   If[missingFiles =!= {},
    Message[DSKiraImport::missing, missingFiles]; dsErrorPrint["完整 Kira 结果文件不足，未导入。"]; Return[<|"status" -> "failed", "reason" -> "missingFiles", "workspace" -> workspace, "files" -> files, "missingFiles" -> missingFiles|>]
    ];
   {manifest, repJ2Kira, repKira2J, reductionRulesBackend} = dsStageRun[
     "读取 Kira manifest、映射与 reduction",
     dsKiraReadExpression /@ Lookup[files, {"manifest", "repJ2Kira", "repKira2J", "reduction"}],
     progress
     ];
   masterText = Import[files["masters"], "Text"];
   completionText = Import[files["completion"], "Text"];
   completionQ = StringQ[completionText] && dsKiraCompletionQ[completionText, OptionValue[KiraCompletionPatterns]];
   If[! TrueQ[completionQ],
    Message[DSKiraImport::incomplete, files["completion"]]; dsErrorPrint["Kira 日志未确认成功完成。"]; Return[<|"status" -> "failed", "reason" -> "completionMarkerMissing", "workspace" -> workspace, "files" -> files|>]
    ];
   If[! AssociationQ[manifest] || ! dsRuleListQ[repJ2Kira] || ! dsRuleListQ[repKira2J] || ! dsRuleListQ[reductionRulesBackend],
    Message[DSKiraImport::invalid, "malformed manifest/map/reduction expression"]; dsErrorPrint["Kira 文件不是预期的 Wolfram 表达式。"]; Return[<|"status" -> "failed", "reason" -> "malformedExpressions", "workspace" -> workspace|>]
    ];
   coefficientVariableMap = Lookup[manifest, "coefficientVariableMap", {}];
   backendImaginaryUnit = Lookup[manifest, "backendImaginaryUnit", None];
   reductionRulesRaw = dsKiraRestoreBackendCoefficients[
     reductionRulesBackend,
     coefficientVariableMap,
     backendImaginaryUnit
     ];
   mapQ = dsKiraInverseMapQ[repJ2Kira, repKira2J];
   manifestMapQ = SortBy[dsJToIDPairs[Lookup[manifest, "integralRules", {}]], Last] === SortBy[dsJToIDPairs[repJ2Kira], Last];
   contextQ = dsKiraContextMatchQ[manifest, resolved];
   masterIDs = dsKiraMasterIDs[masterText];
   mapPairs = dsIDToJPairs[repKira2J];
   idToJ = Association[Rule @@@ mapPairs];
   mapIDs = Keys[idToJ];
   activeData = dsKiraActiveBasisData[manifest];
   activeDataQ = AssociationQ[activeData] && dsKiraActiveBasisDataQ[activeData];
   activeQ = TrueQ[activeDataQ] && Lookup[activeData, "status", "disabled"] === "configured";
   relationIDs = If[activeQ, Lookup[activeData, "ids", {}], {}];
   activeIDs = If[activeQ, Lookup[activeData, "activeIDs", {}], {}];
   auxiliaryIDs = If[activeQ, Lookup[activeData, "auxiliaryIDs", {}], {}];
   activeExpressions = If[activeQ, Lookup[activeData, "activeExpressions", {}], {}];
   activeTokens = If[activeQ, Lookup[activeData, "activeTokens", {}], {}];
   activeMasterOrderQ = ! activeQ || Select[masterIDs, MemberQ[activeIDs, #] &] === activeIDs;
   auxiliaryNotMastersQ = ! activeQ || Intersection[auxiliaryIDs, masterIDs] === {};
   recognizedIDs = Join[mapIDs, relationIDs];
   dummyID = Lookup[manifest, "numericDummyIntegralId", None];
   targetIDs = DeleteCases[Lookup[manifest, "targetIntegralIDs", mapIDs], dummyID];
   ruleIDs = dsKiraRuleIDs[reductionRulesBackend];
   completeTargetsQ = Complement[targetIDs, Union[ruleIDs["lhs"], masterIDs]] === {};
   rhsMastersQ = Complement[ruleIDs["rhs"], masterIDs] === {};
   coefficientVariables = dsKiraCoefficientVariables[reductionRulesRaw];
   allowedCoefficientVariables = Lookup[manifest, "coefficientVariables", {}];
   coefficientQ = Complement[coefficientVariables, allowedCoefficientVariables] === {};
   backendVariableNames = dsKiraBackendVariableNames[reductionRulesBackend];
   allowedBackendVariableNames = Lookup[manifest, "backendCoefficientVariables", {}];
   backendCoefficientQ = If[coefficientVariableMap === {} && allowedBackendVariableNames === {},
     True,
     Complement[backendVariableNames, allowedBackendVariableNames] === {}
     ];
   checks = <|
     "completionMarker" -> completionQ,
     "inverseIntegralMaps" -> mapQ,
     "manifestIntegralMap" -> manifestMapQ,
     "contextConventionMatch" -> contextQ,
     "activeBasisManifest" -> activeDataQ,
     "nonemptyMasterOrder" -> (masterIDs =!= {}),
     "masterIDsRecognized" -> (Complement[masterIDs, recognizedIDs] === {}),
     "activeBasisIDsAreMasters" -> (! activeQ || Complement[activeIDs, masterIDs] === {}),
     "activeBasisMasterOrder" -> activeMasterOrderQ,
     "auxiliaryBasisIDsNotMasters" -> auxiliaryNotMastersQ,
     "allReductionIDsRecognized" -> (Complement[ruleIDs["all"], Append[recognizedIDs, dummyID]] === {}),
     "completeTargetCoverage" -> completeTargetsQ,
     "rhsContainsOnlyMasters" -> rhsMastersQ,
     "backendCoefficientVariablesRecognized" -> backendCoefficientQ,
     "coefficientVariablesRecognized" -> coefficientQ
     |>;
   issues = Keys @ Select[checks, ! TrueQ[#] &];
   If[issues =!= {},
    Message[DSKiraImport::mismatch, issues]; dsErrorPrint["Kira 结果未通过同源性/完整性门禁。"]; Return[<|"status" -> "failed", "reason" -> "validationFailed", "workspace" -> workspace, "files" -> files, "validationReport" -> <|"checks" -> checks, "issues" -> issues|>|>]
    ];
   backendMasters = dsKiraBackendMasterObject[#, relationIDs, idToJ] & /@ masterIDs;
   boundaryMasterIDs = Complement[masterIDs, relationIDs];
   boundaryMasters = Lookup[idToJ, boundaryMasterIDs, {}];
   masters = If[activeQ, activeExpressions, backendMasters];
   masterTokens = If[activeQ, activeTokens, masters];
   returnedMasterIDs = If[activeQ, activeIDs, masterIDs];
   reductionRules = reductionRulesRaw /. Normal[Association[repKira2J]];
   <|
    "status" -> "imported",
    "workspace" -> workspace,
    "files" -> files,
    "reductionRules" -> reductionRules,
    "backendReductionRules" -> reductionRulesBackend,
    "masters" -> masters,
    "masterTokens" -> masterTokens,
    "masterIDs" -> returnedMasterIDs,
    "backendMasters" -> backendMasters,
    "backendMasterIDs" -> masterIDs,
    "boundaryMasters" -> boundaryMasters,
    "boundaryMasterIDs" -> boundaryMasterIDs,
    "activeBasis" -> activeData,
    "integralMap" -> <|"JToKira" -> repJ2Kira, "KiraToJ" -> repKira2J|>,
    "coefficientVariables" -> coefficientVariables,
    "backendCoefficientVariables" -> backendVariableNames,
    "coefficientVariableMap" -> coefficientVariableMap,
    "sourceManifest" -> manifest,
    "context" -> resolved,
    "validationReport" -> <|"status" -> "passed", "checks" -> checks, "issues" -> {}|>
    |>
   ];

DSKiraImport[root_, context_: Automatic, OptionsPattern[]] := (Message[DSKiraImport::badpath, root]; dsErrorPrint["DSKiraImport 的第一个参数必须是目录字符串。"]; <|"status" -> "failed", "reason" -> "workspaceNotString"|>);
