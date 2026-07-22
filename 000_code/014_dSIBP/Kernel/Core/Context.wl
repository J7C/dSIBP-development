(* ::Package:: *)

(* ::Chapter:: *)
(*014 上下文、消息与进度*)

If[! ValueQ[$dSIBPMessagesEnabled], $dSIBPMessagesEnabled = True];
If[! ValueQ[$dSIBPCurrentContext], $dSIBPCurrentContext = Missing["NotInitialized"]];

DSMessagesOn[] := ($dSIBPMessagesEnabled = True);
DSMessagesOff[] := ($dSIBPMessagesEnabled = False);
DSMessagesQ[] := TrueQ[$dSIBPMessagesEnabled];

dsMessagesEnabledQ[setting_: Automatic] := If[setting === Automatic, DSMessagesQ[], TrueQ[setting]];

dsInfoPrint[text_, setting_: Automatic] := If[dsMessagesEnabledQ[setting], Print["[dSIBP] ", text]];

dsWarningPrint[text_, setting_: Automatic] := If[
   dsMessagesEnabledQ[setting],
   If[TrueQ[$Notebooks], Print[Style["Warning: " <> ToString[text], Darker[Orange]]], Print["[dSIBP Warning] ", text]]
   ];

(* fatal error 不读取全局开关；即使用户关闭可选提醒也必须可见。 *)
dsErrorPrint[text_] := If[
   TrueQ[$Notebooks],
   Print[Style["Error: " <> ToString[text], Red]],
   Print["[dSIBP Error] ", text]
   ];

dsStageRun[label_String, expression_, setting_: Automatic] := Module[{result, elapsed},
   dsInfoPrint["开始：" <> label, setting];
   {elapsed, result} = AbsoluteTiming[expression];
   dsInfoPrint["完成：" <> label <> "（" <> ToString[Round[elapsed, 0.001], InputForm] <> " s）", setting];
   result
   ];

(* Notebook 由 Monitor 在同一输出区域刷新；headless 只报告 25% 里程碑，避免逐项刷屏。 *)
dsProgressMap[label_String, items_List, function_, setting_: Automatic] := Module[
   {index = 0, total = Length[items], marks, result},
   If[total == 0, Return[{}]];
   If[! dsMessagesEnabledQ[setting], Return[function /@ items]];
   If[TrueQ[$Notebooks],
    Monitor[
     Map[(index++; function[#]) &, items],
     Row[{label, " ", Dynamic[index], "/", total, "  ", ProgressIndicator[Dynamic[index], {0, total}]}]
     ],
    marks = If[total < 8, {total}, DeleteDuplicates[Ceiling[total {1/4, 1/2, 3/4, 1}]]];
    result = Map[
      Function[item,
       index++;
       If[MemberQ[marks, index], dsInfoPrint[label <> " " <> ToString[index] <> "/" <> ToString[total], setting]];
       function[item]
       ],
      items
      ];
    result
    ]
   ];

dsContextQ[context_] := AssociationQ[context] && Lookup[context, "status", Missing["status"]] === "initialized" &&
   parsedTopologyQ[Lookup[context, "topology", Missing["topology"]]];

dsResolveContext[Automatic] := If[dsContextQ[$dSIBPCurrentContext], $dSIBPCurrentContext, Missing["NotInitialized"]];
dsResolveContext[context_Association] := If[dsContextQ[context], context, Missing["InvalidContext"]];
dsResolveContext[_] := Missing["InvalidContext"];

dsContextSummary[context_Association] := <|
   "packageVersion" -> Lookup[context, "packageVersion", Missing["packageVersion"]],
   "inputHash" -> Lookup[context, "inputHash", Missing["inputHash"]],
   "caseName" -> Lookup[context, "caseName", Missing["caseName"]],
   "sectorKeys" -> Lookup[Lookup[context, "sectors", {}], "sectorKey", {}],
   "loopTreeProjectionConvention" -> Lookup[context, "loopTreeProjectionConvention", <||>]
   |>;
