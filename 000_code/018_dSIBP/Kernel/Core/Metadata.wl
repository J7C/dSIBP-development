(* ::Package:: *)

(* ::Chapter:: *)
(*018 初始化与 metadata 序列化*)

Options[DSInit] = {
   WriteInitializationFiles -> False,
   InitializationDirectory -> Automatic,
   GenerateDerivativeMetadata -> False,
   OverwriteInitialization -> False,
   RegisterAsCurrent -> True,
   ProgressReporting -> Automatic,
   KinematicRules -> Automatic
   };

DSInit::badinput = "DSInit 输入不是有效的 topology Association，或 ISP/动量坐标不闭合。";
DSInit::sectorincomplete = "无法完整初始化 contact-reachable sectors：`1`。";
DSInit::initconflict = "初始化目录 `1` 已含不同输入哈希或未知文件；如确认覆盖，请显式设置 OverwriteInitialization -> True。";
DSInit::writefailed = "初始化 metadata 写入失败：`1`。";
DSInfo::noinit = "当前没有已注册的 DSInit context。";
DSInfo::badcontext = "给定对象不是有效的 DSInit context。";

dsInputHash[input_Association] := IntegerString[Hash[HoldComplete[input], "SHA256"], 16, 64];

dsCallerDirectory[] := Which[
   StringQ[$InputFileName] && $InputFileName =!= "", DirectoryName[$InputFileName],
   TrueQ[$Notebooks], With[{directory = Quiet[NotebookDirectory[]]}, If[StringQ[directory], directory, Directory[]]],
   True, Directory[]
   ];

dsResolveInitializationDirectory[Automatic] := FileNameJoin[{dsCallerDirectory[], "init"}];
dsAbsolutePathQ[path_String] := StringStartsQ[path, "/"] || StringStartsQ[path, "\\\\"] ||
   (StringLength[path] >= 3 && StringMatchQ[StringTake[path, 1], LetterCharacter] &&
     StringTake[path, {2, 2}] === ":" && MemberQ[{"\\", "/"}, StringTake[path, {3, 3}]]);
dsResolveInitializationDirectory[path_String] := ExpandFileName[
   If[dsAbsolutePathQ[path], path, FileNameJoin[{dsCallerDirectory[], path}]]
   ];
dsResolveInitializationDirectory[_] := $Failed;

dsDerivativeMetadata[topo_Association, progressSetting_] := Module[{generators, operators},
   generators = makeIndependentVariableDerivativeGenerators[topo];
   operators = dsProgressMap[
     "正在生成微分算符 / Building differential operators",
     generators,
     Function[generator,
      <|
       "variable" -> generator["variable"],
       "userVariable" -> generator["userVariable"],
       "kind" -> generator["kind"],
        "decomposition" -> Switch[generator["kind"],
          "externalInvariant",
          makeExternalInvariantDerivativeDecomposition[topo, generator["variable"]],
          "kinematicCoordinate",
          <|
           "status" -> "chainRuleAdapter",
           "atomicCoordinates" -> Lookup[kinematicAtomicDerivativeData[topo], "inputExpression", {}],
           "atomicJacobian" -> Lookup[generator, "atomicJacobian", {}]
           |>,
          _,
          Missing["DirectVertexEnergyDerivative"]
          ]
       |>
      ],
     progressSetting
     ];
   <|"status" -> If[FreeQ[operators, $Failed], "generated", "failed"], "variableCount" -> Length[generators], "operators" -> operators|>
   ];

dsConventionMetadata[topo_Association] := <|
   "vertexData" -> topo["vertexData"],
   "lineOrder" -> Lookup[topo["lines"], "id"],
   "lineConventions" -> Map[
     KeyTake[#, {"id", "massType", "packType", "state", "skType", "bbType", "thetaConvention", "functionSystem", "compiledFunctionSystem"}] &,
     topo["lines"]
     ],
   "zeroPointRules" -> topo["zeroPointRules"],
   "shrinkPrefactorRules" -> topo["shrinkPrefactorRules"],
   "symmetryRules" -> topo["symmetryRules"],
   "effectiveSymmetryRules" -> Lookup[topo, "effectiveSymmetryRules", effectiveSymmetryRules0[topo]],
   "tadpoleSymmetryData" -> Lookup[topo, "tadpoleSymmetryData", tadpoleSymmetryData[topo]],
   "externalInvariantRules" -> topo["externalInvariantRules"],
   "independentVariables" -> independentVariableDerivativeVariables[topo],
   "loopTreeProjection" -> <|
     "vertexPhysicalPower" -> "a+a0 becomes tree a+nu0",
     "linePhysicalPower" -> "removed b+b0 or bS+bS0 becomes an explicit energy power",
     "normalization" -> "relative to the reference loop integral, term by term",
     "unsafePowerExpand" -> False
     |>
   |>;

(* 缺失 numericRules 只约束显式请求的全数值 linear mode；symbolic Kira/DE 必须保留
   动力学变量，因此初始化时不把“未数值化”误报为 warning。完整报告仍保存在 metadata。 *)
dsRelevantInitializationWarningQ[issue_Association, topo_Association] := Module[{code},
   code = Lookup[issue, "code", ""];
   ! MemberQ[
     {
      "numericRulesMissingExternalInvariants",
      "numericRulesMissingVertexEnergies",
      "numericRulesMissingLineParameters"
      },
     code
     ]
   ];


dsInitializationIssueText[issue_Association] := Module[{code, details},
   code = Lookup[issue, "code", "unknownInitializationIssue"];
   details = KeyDrop[issue, {"severity", "code"}];
   "初始化问题 / Initialization issue: " <> code <>
    If[details === <||>, "", "：" <> ToString[details, InputForm]]
   ];

dsReadExistingManifest[path_String] := If[FileExistsQ[path], Quiet[Check[Get[path], $Failed]], Missing["NoManifest"]];


(* 初始化 metadata 固定为 UTF-8/LF 的可读 InputForm，避免 Windows Put 产生 CRLF 与行尾空格。 *)
dsWriteInitializationExpression[expr_, path_String] := Module[{text},
   text = ToString[expr, InputForm, PageWidth -> 120] <> "\n";
   text = StringReplace[text, RegularExpression["[ \\t]+(?=\\n|$)"] -> ""];
   writeKiraUTF8LFText[path, text]
   ];


dsInitializationConflictQ[directory_String, inputHash_String, overwriteQ_] := Module[{manifestPath, manifest, knownFiles},
   If[TrueQ[overwriteQ] || ! DirectoryQ[directory], Return[False]];
   manifestPath = FileNameJoin[{directory, "manifest.wl"}];
   manifest = dsReadExistingManifest[manifestPath];
   knownFiles = FileExistsQ /@ (FileNameJoin[{directory, #}] & /@ {"topology.wl", "sectors.wl", "conventions.wl", "derivatives.wl"});
   Which[
    AssociationQ[manifest], Lookup[manifest, "inputHash", Missing["inputHash"]] =!= inputHash,
    Head[manifest] === Missing && ! Or @@ knownFiles, False,
    True, True
    ]
   ];

dsWriteInitializationFiles[context_Association, directory_String, overwriteQ_] := Module[
   {manifestPath, fileData, paths, manifest, writeResult},
   If[dsInitializationConflictQ[directory, context["inputHash"], overwriteQ], Return[<|"status" -> "conflict", "directory" -> directory|>]];
   Quiet[CreateDirectory[directory, CreateIntermediateDirectories -> True]];
   fileData = <|
     "topology.wl" -> context["topologyData"],
     "sectors.wl" -> context["sectors"],
     "conventions.wl" -> context["conventions"]
     |>;
   If[AssociationQ[context["derivatives"]], AssociateTo[fileData, "derivatives.wl" -> context["derivatives"]]];
   paths = AssociationMap[FileNameJoin[{directory, #}] &, Keys[fileData]];
   writeResult = Quiet[Check[KeyValueMap[(dsWriteInitializationExpression[#2, paths[#1]]; #1) &, fileData], $Failed]];
   If[writeResult === $Failed, Return[<|"status" -> "failed", "directory" -> directory|>]];
   manifest = <|
     "status" -> "initialized",
     "packageVersion" -> context["packageVersion"],
     "inputHash" -> context["inputHash"],
     "caseName" -> context["caseName"],
     "generatedAt" -> DateString[{"ISODate", "T", "Time", "TimeZone"}],
      "files" -> Map[FileNameTake, paths],
     "sectorCount" -> Length[context["sectors"]],
     "derivativeMetadataQ" -> AssociationQ[context["derivatives"]]
     |>;
   manifestPath = FileNameJoin[{directory, "manifest.wl"}];
   If[Quiet[Check[dsWriteInitializationExpression[manifest, manifestPath]; True, False]] =!= True, Return[<|"status" -> "failed", "directory" -> directory|>]];
   <|"status" -> "written", "directory" -> directory, "manifest" -> manifestPath, "files" -> Append[paths, "manifest.wl" -> manifestPath]|>
   ];

DSInit[input_Association, OptionsPattern[]] := Module[
   {progress = OptionValue[ProgressReporting], topologyData, validation, subsetSummary, derivatives, context,
     inputHash, initDirectory, writeResult = <|"status" -> "notRequested"|>, warnings, errors,
     effectiveInput, kinematicAudit, declarationAudit, guide, guideText, parityDataList,
     parityRequestedQ, parityUsableQ, parityFailures},
   effectiveInput = If[
     OptionValue[KinematicRules] === Automatic,
     input,
     Join[input, <|"kinematicRules" -> OptionValue[KinematicRules]|>]
     ];
   inputHash = dsInputHash[effectiveInput];
   topologyData = dsStageRun[
     "初始化 topology、ISP 与完整 sector metadata / Initializing topology, ISP, and complete sector metadata",
     makeTopologyData[
       effectiveInput,
      PrecomputeShrinkSectorMetadata -> True
      ],
     progress
     ];
   validation = Lookup[topologyData, "validationReport", <|"errorCount" -> 1, "issues" -> {}|>];
   kinematicAudit = Lookup[topologyData, "kinematicCoordinateAudit", <||>];
   declarationAudit = Lookup[topologyData, "momentumDeclarationAudit", <||>];
   guide = kinematicParameterRedefinitionGuide[kinematicAudit];
   guideText = If[
     StringQ[Lookup[guide, "commandExample", None]],
     Lookup[guide, "commandExample", ""],
     Lookup[guide, "defaultBehavior", ""]
     ];
   dsInfoPrint[
     "动量角色：loopMomenta " <> ToString[Lookup[topologyData, "loopMomenta", {}], InputForm] <>
      "；loopExternalMomenta " <> ToString[Lookup[topologyData, "loopExternalMomenta", {}], InputForm] <>
      "；effectiveLoopExternalMomenta " <> ToString[Lookup[topologyData, "effectiveLoopExternalMomenta", {}], InputForm] <>
      "；independentExternalMomenta " <> ToString[Lookup[topologyData, "independentExternalMomenta", {}], InputForm] <>
      "；实际需要的 loop 方向 " <> ToString[Lookup[declarationAudit, "requiredLoopExternalDirections", {}], InputForm] <>
      "；实际需要的无圈模长 " <> ToString[Lookup[declarationAudit, "requiredIndependentMomentumMagnitudes", {}], InputForm] <>
      ". Momentum roles: loopMomenta " <> ToString[Lookup[topologyData, "loopMomenta", {}], InputForm] <>
      "; loopExternalMomenta " <> ToString[Lookup[topologyData, "loopExternalMomenta", {}], InputForm] <>
      "; effectiveLoopExternalMomenta " <> ToString[Lookup[topologyData, "effectiveLoopExternalMomenta", {}], InputForm] <>
      "; independentExternalMomenta " <> ToString[Lookup[topologyData, "independentExternalMomenta", {}], InputForm] <>
      "; required loop directions " <> ToString[Lookup[declarationAudit, "requiredLoopExternalDirections", {}], InputForm] <>
      "; required loop-free magnitudes " <> ToString[Lookup[declarationAudit, "requiredIndependentMomentumMagnitudes", {}], InputForm],
     progress
     ];
   dsInfoPrint[
     "动力学变量选择：" <> ToString[Lookup[kinematicAudit, "status", "unknown"]] <>
      "；缺省规则 " <> ToString[Lookup[kinematicAudit, "defaultRules", {}], InputForm] <>
      "；当前规则 " <> ToString[Lookup[kinematicAudit, "selectedRules", {}], InputForm] <>
      "；从属模长绑定 " <> ToString[Lookup[kinematicAudit, "dependentMagnitudeBindings", {}], InputForm] <>
      ". Kinematic-variable selection: " <> ToString[Lookup[kinematicAudit, "status", "unknown"]] <>
      "; default rules " <> ToString[Lookup[kinematicAudit, "defaultRules", {}], InputForm] <>
      "; selected rules " <> ToString[Lookup[kinematicAudit, "selectedRules", {}], InputForm] <>
      "; dependent magnitude bindings " <> ToString[Lookup[kinematicAudit, "dependentMagnitudeBindings", {}], InputForm],
     progress
     ];
   dsInfoPrint[
     "必需模长的参数覆盖 " <> ToString[kinematicRequiredMagnitudeCoverage[topologyData], InputForm] <>
      ". Parameter coverage of required magnitudes " <> ToString[kinematicRequiredMagnitudeCoverage[topologyData], InputForm],
     progress
     ];
   dsInfoPrint[
     "参数可保持缺省，也可复制以下格式重定义：" <> guideText <>
      "。规则左端写原始 sp[...]，不要写 ssij/sEi -> custom；右端写自定义参数表达式。 " <>
      "Keep the default parameters or copy this form to redefine them: " <> guideText <>
      ". Put the original sp[...] on the left, not ssij/sEi -> custom, and the custom parameter expression on the right.",
     progress
     ];
   If[Lookup[topologyData, "status", None] === "invalidInput" || topologyValidationErrorQ[validation],
    errors = Select[Lookup[validation, "issues", {}], Lookup[#, "severity", ""] === "error" &];
    Scan[dsErrorPrint[dsInitializationIssueText[#]] &, errors];
    Message[DSInit::badinput]; dsErrorPrint["topology/ISP 初始化失败；上述详情同时保存在 validationReport[\"issues\"]。 Topology/ISP initialization failed; the details above are also stored in validationReport[\"issues\"]."];
    Return[dsFailedInitializationData[
      "invalidInputOrTopology",
      <|"inputHash" -> inputHash, "topologyData" -> topologyData, "validationReport" -> validation|>
      ]]
    ];
   subsetSummary = Lookup[topologyData, "precomputedShrinkSectorSummary", <||>];
   If[Lookup[subsetSummary, "status", "missing"] =!= "generated" || ! TrueQ[Lookup[subsetSummary, "completeCoverageQ", False]],
    Message[DSInit::sectorincomplete, subsetSummary]; dsErrorPrint["contact-reachable sector 未完整初始化。 Contact-reachable sectors were not initialized completely."];
    Return[dsFailedInitializationData[
      "incompleteSectorMetadata",
      <|"inputHash" -> inputHash, "topologyData" -> topologyData|>
      ]]
    ];
   parityDataList = Lookup[Lookup[topologyData, "sectorMetadataList", {}], "parityData", {}];
   parityRequestedQ = Lookup[topologyData, "parityConstraints", {}] =!= {};
   parityUsableQ = parityDataList =!= {} && And @@ Lookup[parityDataList, "parityUsableQ", {False}];
   parityFailures = Select[
     parityDataList,
     Lookup[#, "status", "disabled"] === "disabled" &&
       Lookup[#, "reason", "noParityConstraints"] =!= "noParityConstraints" &
     ];
   topologyData = Join[topologyData, <|
      "capabilities" -> Join[
        Lookup[topologyData, "capabilities", <||>],
        <|"parityUsableQ" -> parityUsableQ|>
        ]
      |>];
   If[parityRequestedQ && parityFailures =!= {},
    dsErrorPrint[
     "显式 parity 约束无法在全部 sector 上定义，初始化已拒绝：" <>
      ToString[parityFailures, InputForm] <>
      ". Explicit parity constraints are not defined on every sector; initialization was rejected: " <>
      ToString[parityFailures, InputForm]
     ];
    Return[dsFailedInitializationData[
      "invalidParityConstraints",
      <|"inputHash" -> inputHash, "topologyData" -> topologyData,
        "parityFailures" -> parityFailures|>
      ]]
    ];
   If[! parityRequestedQ && ! parityUsableQ,
    dsErrorPrint[
     "当前函数族不是完整 h/H parity 域，parity 筛选已禁用；普通 IBP 仍可继续。 " <>
      "The current family is not a complete h/H parity domain; parity filtering is disabled, while ordinary IBP remains available."
     ]
    ];
   warnings = Select[
     Lookup[validation, "issues", {}],
     Lookup[#, "severity", ""] === "warning" && dsRelevantInitializationWarningQ[#, topologyData] &
     ];
   Scan[dsWarningPrint[dsInitializationIssueText[#], progress] &, warnings];
   derivatives = If[
     TrueQ[OptionValue[GenerateDerivativeMetadata]] && dsTopologyCapabilityQ[topologyData, "derivativeUsableQ"],
     dsDerivativeMetadata[topologyData, progress],
     Missing["NotGenerated"]
     ];
   context = <|
     "status" -> "initialized",
     "packageVersion" -> $dSIBPVersion,
     "inputHash" -> inputHash,
     "caseName" -> Lookup[topologyData, "name", "unnamed"],
      "input" -> effectiveInput,
     "topology" -> topologyData,
     "topologyData" -> topologyData,
     "capabilities" -> Lookup[topologyData, "capabilities", <||>],
     "sectors" -> Lookup[topologyData, "sectorMetadataList", {}],
     "conventions" -> dsConventionMetadata[topologyData],
     "derivatives" -> derivatives,
     "validationReport" -> validation,
     "loopTreeProjectionConvention" -> <|
       "targetAZeroPointBecomesTreeNu0" -> True,
       "removedLineZeroPointsBecomeExplicitEnergyPowers" -> True,
       "relativePhysicalPowerNormalization" -> True,
       "unsafePowerExpand" -> False
       |>,
     "initializationWrite" -> writeResult
     |>;
   If[TrueQ[OptionValue[WriteInitializationFiles]],
    initDirectory = dsResolveInitializationDirectory[OptionValue[InitializationDirectory]];
    If[initDirectory === $Failed,
     Message[DSInit::writefailed, OptionValue[InitializationDirectory]];
     dsWarningPrint["InitializationDirectory 无效；内存数学 context 仍然有效。 InitializationDirectory is invalid; the in-memory mathematical context remains valid."];
     writeResult = <|"status" -> "failed", "reason" -> "invalidInitializationDirectory",
       "requestedDirectory" -> OptionValue[InitializationDirectory]|>,
     writeResult = dsWriteInitializationFiles[context, initDirectory, OptionValue[OverwriteInitialization]];
     If[writeResult["status"] === "conflict",
      Message[DSInit::initconflict, initDirectory];
      dsWarningPrint["已有初始化信息与当前输入不一致，未覆盖；内存数学 context 仍然有效。 Existing initialization data do not match the current input and were not overwritten; the in-memory mathematical context remains valid."]
      ];
     If[! MemberQ[{"written", "conflict"}, writeResult["status"]],
      Message[DSInit::writefailed, initDirectory];
      dsWarningPrint["初始化文件未完整写入；内存数学 context 仍然有效。 Initialization files were not written completely; the in-memory mathematical context remains valid."]
      ]
     ];
    context = Join[context, <|"initializationWrite" -> writeResult|>]
    ];
   If[TrueQ[OptionValue[RegisterAsCurrent]],
    $dSIBPCurrentContext = context;
    setIBPTopologyContext[context["topology"]]
    ];
   dsInfoPrint[
    "初始化完成：" <> context["caseName"] <> "，sector " <> ToString[Length[context["sectors"]]] <> "/" <> ToString[Length[context["sectors"]]] <>
     ". Initialization completed: " <> context["caseName"] <> ", sectors " <> ToString[Length[context["sectors"]]] <> "/" <> ToString[Length[context["sectors"]]],
    progress
    ];
   context
   ];

DSInit[input_, OptionsPattern[]] := (
   Message[DSInit::badinput];
   dsErrorPrint["DSInit 需要 Association 输入。 DSInit requires an Association input."];
   dsFailedInitializationData["inputNotAssociation", <|"input" -> HoldForm[input]|>]
   );

DSInfo[] := Module[{context = dsResolveContext[Automatic]},
   If[Head[context] === Missing, Message[DSInfo::noinit]; Return[<|"status" -> "notInitialized"|>]];
   DSInfo[context]
   ];

DSInfo[context_Association] := Module[{resolved = dsResolveContext[context]},
   If[Head[resolved] === Missing, Message[DSInfo::badcontext]; Return[<|"status" -> "invalidContext"|>]];
   Join[<|"status" -> "initialized"|>, dsContextSummary[resolved], <|
     "sectorCount" -> Length[resolved["sectors"]],
     "independentVariables" -> Lookup[resolved["conventions"], "independentVariables", {}],
     "initializationWrite" -> Lookup[resolved, "initializationWrite", <||>]
     |>]
   ];

DSInfo[context_Association, "Full"] := Module[{resolved = dsResolveContext[context]},
   If[Head[resolved] === Missing, Message[DSInfo::badcontext]; <|"status" -> "invalidContext"|>, resolved]
   ];
