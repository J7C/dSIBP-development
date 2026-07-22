(* ::Package:: *)

(* ::Chapter:: *)
(*016 loop seed 与 linearData 高层入口*)

Options[DSSeeds] = Join[Options[makeCanonicalSeedBatch], {ProgressReporting -> Automatic}];
Options[DSLinear] = {
   LinearSystemMode -> "symbolic",
   CoefficientRules -> Automatic,
   KiraOrdering -> Automatic,
   ProgressReporting -> Automatic
   };

DSSeeds::noinit = "DSSeeds 需要有效的 DSInit context。";
DSSeeds::failed = "canonical seed 生成未通过门禁：`1`。";
DSSeeds::capability = "当前 context 不具备 seed 生成所需能力：`1`。";
DSLinear::noinit = "DSLinear 需要有效的 DSInit context。";
DSLinear::badseed = "DSLinear 需要 DSSeeds 返回的 canonical seed Association。";
DSLinear::badmode = "LinearSystemMode 只允许 \"symbolic\" 或 \"numeric\"，收到 `1`。";
DSLinear::failed = "linearData 生成未通过门禁：`1`。";
DSLinear::capability = "当前 context 不具备 linearData 生成所需能力：`1`。";
DSLinear::context = "seedData 与 context 不是同一次初始化的产物。";

DSSeeds[context_: Automatic, opts : OptionsPattern[]] := Module[{resolved, seedData, progress = OptionValue[ProgressReporting]},
   resolved = dsResolveContext[context];
   If[Head[resolved] === Missing,
    Message[DSSeeds::noinit]; dsErrorPrint["请先成功调用 DSInit。"]; Return[<|"status" -> "failed", "reason" -> "missingContext"|>]
    ];
   If[! dsContextCapabilityQ[resolved, "timeIBPUsableQ"] ||
     (Lookup[resolved["topology"], "ibpMode", "full"] === "full" &&
       ! dsContextCapabilityQ[resolved, "momentumIBPUsableQ"]),
    Message[DSSeeds::capability, dsContextCapabilities[resolved]];
    dsErrorPrint["动量声明审计未授权当前 seed 模式。"]; Return[<|
      "status" -> "failed", "reason" -> "capabilityGate",
      "capabilities" -> dsContextCapabilities[resolved]
      |>]
    ];
   seedData = dsStageRun[
     "生成 canonical IBP seeds",
     If[Lookup[resolved["topology"], "ibpMode", "full"] === "timeOnly",
      makePureTimeSeedBatch[
       resolved,
       Sequence @@ FilterRules[{opts}, Options[makePureTimeSeedBatch]]
       ],
      makeCanonicalSeedBatch[
       resolved["topology"],
       Sequence @@ FilterRules[{opts}, Options[makeCanonicalSeedBatch]]
       ]
      ],
     progress
     ];
   If[Lookup[seedData, "status", "missing"] =!= "generated",
    Message[DSSeeds::failed, Lookup[seedData, "status", Missing["status"]]];
    dsErrorPrint["seed generation 返回非 generated 状态。"];
    Return[Join[seedData, <|"dSIBPStatus" -> "failed", "dSIBPContextSummary" -> dsContextSummary[resolved]|>]]
    ];
   Join[seedData, <|
     "dSIBPStatus" -> "generated",
     "dSIBPContextSummary" -> dsContextSummary[resolved],
     "numericRulesAppliedBeforeSeeds" -> TrueQ[OptionValue[ApplyNumericRules]],
     "seedNumericRules" -> If[TrueQ[OptionValue[ApplyNumericRules]], userNumericRules[resolved["topology"]], {}]
     |>]
   ];

DSLinear[seedData_Association, context_: Automatic, opts : OptionsPattern[]] := Module[
   {resolved, linearData, mode = OptionValue[LinearSystemMode], progress = OptionValue[ProgressReporting]},
   resolved = dsResolveContext[context];
   If[Head[resolved] === Missing,
    Message[DSLinear::noinit]; dsErrorPrint["请传入与 seed 同源的 DSInit context。"]; Return[<|"status" -> "failed", "reason" -> "missingContext"|>]
    ];
    If[! KeyExistsQ[seedData, "completeCanonicalQ"],
     Message[DSLinear::badseed]; dsErrorPrint["输入不是 canonical seed batch。"]; Return[<|"status" -> "failed", "reason" -> "notCanonicalSeedBatch"|>]
     ];
    If[Lookup[Lookup[seedData, "dSIBPContextSummary", <||>], "inputHash", Missing["seedHash"]] =!=
      Lookup[resolved, "inputHash", Missing["contextHash"]],
     Message[DSLinear::context]; dsErrorPrint["seed 与 context 的 inputHash 不一致。"]; Return[<|
       "status" -> "failed", "reason" -> "contextMismatch"
       |>]
     ];
    If[Lookup[seedData, "dSIBPStatus", "failed"] =!= "generated" ||
      ! dsContextCapabilityQ[resolved, "timeIBPUsableQ"] ||
      (Lookup[resolved["topology"], "ibpMode", "full"] === "full" &&
        ! dsContextCapabilityQ[resolved, "momentumIBPUsableQ"]),
     Message[DSLinear::capability, dsContextCapabilities[resolved]];
     dsErrorPrint["seed 或 context 未通过 linearData 能力门禁。"]; Return[<|
       "status" -> "failed", "reason" -> "capabilityGate",
       "capabilities" -> dsContextCapabilities[resolved]
       |>]
     ];
   If[! MemberQ[{"symbolic", "numeric"}, mode],
    Message[DSLinear::badmode, mode]; dsErrorPrint["linearData 模式无效。"]; Return[<|"status" -> "failed", "reason" -> "invalidLinearSystemMode", "mode" -> mode|>]
    ];
   linearData = dsStageRun[
     "转换 backend-neutral linearData",
     If[Lookup[seedData, "representation", None] === "J[vertexPacks]",
      With[{treeLinear = makePureTimeLinearSystemData[seedData, resolved]},
       If[mode === "numeric" && Lookup[treeLinear, "status", "missing"] === "generated",
        applyCoefficientRulesToLinearSystem[
         treeLinear,
         CoefficientRules -> If[
           OptionValue[CoefficientRules] === Automatic,
           userNumericRules[resolved["topology"]],
           OptionValue[CoefficientRules]
           ]
         ],
        treeLinear
        ]
       ],
      If[mode === "numeric",
       makeSampledLinearSystemData[
        seedData,
        resolved["topology"],
        KiraOrdering -> OptionValue[KiraOrdering],
        CoefficientRules -> OptionValue[CoefficientRules]
        ],
       makeLinearSystemData[
        seedData,
        resolved["topology"],
        KiraOrdering -> OptionValue[KiraOrdering]
        ]
       ]
      ],
     progress
     ];
   If[Lookup[linearData, "status", "missing"] =!= "generated",
    Message[DSLinear::failed, Lookup[linearData, "status", Missing["status"]]];
    dsErrorPrint["linearData 未通过 canonical/linearity 门禁。"];
    Return[Join[linearData, <|"dSIBPStatus" -> "failed", "dSIBPContextSummary" -> dsContextSummary[resolved]|>]]
    ];
   Join[linearData, <|
      "dSIBPStatus" -> "generated",
      "dSIBPContextSummary" -> dsContextSummary[resolved],
      "contextCapabilities" -> dsContextCapabilities[resolved],
      "contextInputHash" -> Lookup[resolved, "inputHash", Missing["inputHash"]],
      "numericRulesAppliedBeforeSeeds" -> TrueQ[Lookup[seedData, "numericRulesAppliedBeforeSeeds", False]],
     "seedNumericRules" -> Lookup[seedData, "seedNumericRules", {}]
     |>]
   ];
