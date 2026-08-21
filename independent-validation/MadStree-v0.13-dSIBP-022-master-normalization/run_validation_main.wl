(* ::Package:: *)

(***
File: run_validation_main.wl
Purpose: 独立比较 MadStree v0.13 与 dSIBP 022 在三个 tree/time-only family 中选择的主积分及其裸积分外系数。
Scope: 只调用初始化与只读 master/sector metadata；不生成 IBP，不调用约化、Kira、DE、边界或数值输运，也不读取两包现有 expected 或验证结果。
Outputs: results/summary.wl 与同目录上一级的 000_MadStree-v0.13-dSIBP-022-master-normalization-report.md。
***)

(* ::Chapter:: *)
(*路径、清理与程序包加载*)

validationDirectory = DirectoryName[$InputFileName];
projectRoot = DirectoryName[DirectoryName[validationDirectory]];
resultsDirectory = FileNameJoin[{validationDirectory, "results"}];
summaryPath = FileNameJoin[{resultsDirectory, "summary.wl"}];
reportPath = FileNameJoin[{validationDirectory, "000_MadStree-v0.13-dSIBP-022-master-normalization-report.md"}];
madKernelDirectory = FileNameJoin[{projectRoot, "package-MadStree", "versions", "MadStree-v0.13", "Kernel"}];
dsibpVersionDirectory = FileNameJoin[{projectRoot, "package-dSibp", "versions", "022_dSIBP"}];

(* 旧结果或报告删不干净时立即失败，禁止把旧证据混入本轮。 *)
If[DirectoryQ[resultsDirectory],
  Quiet@Check[DeleteDirectory[resultsDirectory, DeleteContents -> True], $Failed];
  If[DirectoryQ[resultsDirectory], Print["fresh cleanup failed: ", resultsDirectory]; Exit[1]]
];
If[FileExistsQ[reportPath],
  Quiet@Check[DeleteFile[reportPath], $Failed];
  If[FileExistsQ[reportPath], Print["fresh cleanup failed: ", reportPath]; Exit[1]]
];
CreateDirectory[resultsDirectory, CreateIntermediateDirectories -> True];

AppendTo[$Path, madKernelDirectory];
AppendTo[$Path, dsibpVersionDirectory];
Needs["MadStree`"];
Needs["dSIBP`"];
DSMessagesOff[];
madStreeVersion = MadStree`Private`$MadStreeVersion;
dsibpVersion = dSIBP`$dSIBPVersion;


(* ::Chapter:: *)
(*固定 case 与共同输入*)

caseData = {
  <|"name" -> "two_vertex_massive", "title" -> "两顶点单 massive tree",
    "masses" -> {"massive"}, "expectedMasterCount" -> 5|>,
  <|"name" -> "three_vertex_massive", "title" -> "三顶点双 massive chain",
    "masses" -> {"massive", "massive"}, "expectedMasterCount" -> 25|>,
  <|"name" -> "three_vertex_mixed", "title" -> "三顶点 massive+massless chain",
    "masses" -> {"massive", "massless"}, "expectedMasterCount" -> 15|>
};


makeMadSpec[case_Association] := Module[{vertexCount, vertices, lines},
  vertexCount = Length[case["masses"]] + 1;
  vertices = Table[
    <|"id" -> i, "externalLegEnergy" -> Symbol["k" <> ToString[i]],
      "timePower" -> Symbol["a" <> ToString[i]], "vertexType" -> "+"|>,
    {i, vertexCount}
  ];
  lines = MapIndexed[
    Function[{massType, index},
      With[{i = First[index]},
        If[massType === "massive",
          <|"type" -> "massive", "endpoints" -> {i, i + 1},
            "momentum" -> Symbol["sE" <> ToString[i]], "nu" -> Symbol["mu" <> ToString[i]]|>,
          <|"type" -> "massless", "endpoints" -> {i, i + 1},
            "momentum" -> Symbol["sE" <> ToString[i]], "nu" -> 1/2,
            "masslessRepresentation" -> "Quotient"|>
        ]
      ]
    ],
    case["masses"]
  ];
  <|"name" -> case["name"], "vertices" -> vertices, "lines" -> lines|>
];


makeDSIBPSpec[case_Association] := Module[{vertexCount, vertices, lines, momenta, zeroPointRules},
  vertexCount = Length[case["masses"]] + 1;
  vertices = Table[
    <|"id" -> i, "vertexType" -> "+", "externalLegEnergy" -> Symbol["k" <> ToString[i]]|>,
    {i, vertexCount}
  ];
  momenta = Table[Symbol["p" <> ToString[i]], {i, Length[case["masses"]]}];
  lines = MapIndexed[
    Function[{massType, index},
      With[{i = First[index]},
        If[massType === "massive",
          <|"id" -> i, "massType" -> "massive", "endpoints" -> {i, i + 1},
            "momentum" -> momenta[[i]], "nu" -> -Symbol["mu" <> ToString[i]],
            "functionSystem" -> "h"|>,
          <|"id" -> i, "massType" -> "massless", "endpoints" -> {i, i + 1},
            "momentum" -> momenta[[i]]|>
        ]
      ]
    ],
    case["masses"]
  ];
  zeroPointRules = Join[
    Table[a0[i] -> Symbol["a" <> ToString[i]], {i, vertexCount}],
    Table[b0[i] -> 0, {i, Length[case["masses"]]}]
  ];
  <|
    "name" -> case["name"], "vertices" -> vertices, "lines" -> lines,
    "loopMomenta" -> {}, "loopExternalMomenta" -> {},
    "independentExternalMomenta" -> momenta, "ibpMode" -> "timeOnly",
    "ispData" -> {}, "zeroPointRules" -> zeroPointRules, "symmetryRules" -> {}
  |>
];


(* ::Chapter:: *)
(*独立 master identity 与 slot 映射*)

canonicalMaster[key_, shifts_, bits_] := <|
  "sectorKey" -> key, "timeShifts" -> shifts, "stateBits" -> bits
|>;


madMasterIdentity[record_Association] := With[
  {arguments = List @@ record["integral"]},
  canonicalMaster[arguments[[1]], arguments[[2]], arguments[[3]]]
];


dsMasterRecords[context_Association] := Flatten@Table[
  With[
    {
      key = sector["sectorKey"],
      shiftCount = Length[Lookup[sector, "compactASlots", {}]],
      stateCount = Lookup[sector, "timeOnlyStateCount", 0]
    },
    Table[
      <|
        "identity" -> canonicalMaster[
          key,
          ConstantArray[0, shiftCount],
          IntegerDigits[stateNumber, 2, stateCount]
        ],
        "integral" -> Inactive[dSIBP`J][
          key,
          ConstantArray[0, shiftCount],
          IntegerDigits[stateNumber, 2, stateCount]
        ]
      |>,
      {stateNumber, 0, 2^stateCount - 1}
    ]
  ],
  {sector, context["sectors"]}
];


madSlotDescriptor[slot_Association] := <|
  "linePosition" -> slot["linePosition"],
  "kind" -> slot["kind"],
  "endpoint" -> If[slot["kind"] === "masslessShared", "shared", slot["endpointIndex"]]
|>;


dsSlotDescriptor[slot_Association] := <|
  "linePosition" -> slot["rootLinePosition"],
  "kind" -> slot["kind"],
  "endpoint" -> If[slot["kind"] === "masslessShared", "shared", slot["endpointSlot"]]
|>;


(* ::Chapter:: *)
(*两边 coefficient 与 dSIBP normalization split*)

(* 只拆分指数中的加法，并用 Inactive 防止 Wolfram 立即把因子重新合并。 *)
canonicalizeExponentials[expression_] := expression /. HoldPattern[Power[E, argument_]] :> With[
  {expandedArgument = Expand[argument]},
  Times @@ (
    Inactive[Exp] /@ If[Head[expandedArgument] === Plus, List @@ expandedArgument, {expandedArgument}]
  )
];


zeroQ[expression_] := TrueQ[
  FullSimplify[Cancel[Together[canonicalizeExponentials[expression]]] === 0]
];


oracleLineFactor[case_Association, linePosition_Integer] := If[
  case["masses"][[linePosition]] === "massive",
  With[
    {
      momentum = Symbol["sE" <> ToString[linePosition]],
      order = Symbol["mu" <> ToString[linePosition]]
    },
    -(4 I/Pi) Exp[-Pi Im[order]] momentum^(2 order - 1)
  ],
  1
];


oracleSelectorFactor[case_Association, linePosition_Integer] := If[
  case["masses"][[linePosition]] === "massive",
  -1/Symbol["sE" <> ToString[linePosition]],
  1
];


dsLineMagnitudeMap[context_Association] := Association@Map[
  Lookup[#, "lineIndex"] -> Lookup[#, "parameter"] &,
  Lookup[First[context["sectors"]]["sectorPrefactorData"], "powerParts", {}]
];


dsCompiledWronskianFactor[context_Association, linePosition_Integer, magnitudeMap_Association] := Module[
  {line, system, variable, wronskian},
  line = context["topology", "lines"][[linePosition]];
  If[Lookup[line, "massType", "massive"] =!= "massive", Return[1]];
  system = line["functionSystem"];
  variable = system["variable"];
  wronskian = system["W"];
  Expand[wronskian /. variable -> magnitudeMap[linePosition]]
];


dsPhysicalSectorPrefactor[sector_Association] := Module[
  {data, powers, expressions, residualParts},
  data = sector["sectorPrefactorData"];
  powers = List @@ data["kEPower"];
  expressions = data["kEParameterExpressions"];
  residualParts = Lookup[data, "residualPowerParts", {}];
  Expand[
    data["constantPrefactor"]
      Times @@ MapThread[Power, {expressions, powers}]
      Times @@ (Power[#["parameter"], #["prefactorPower"]] & /@ residualParts)
  ]
];


(* ::Chapter:: *)
(*逐 case fresh 比较*)

startTime = AbsoluteTime[];
caseResults = Table[
  madContext = MSInitTree[makeMadSpec[case], NuConvention -> "Positive"];
  dsContext = DSInit[
    makeDSIBPSpec[case], RegisterAsCurrent -> False, WriteInitializationFiles -> False,
    GenerateDerivativeMetadata -> False, ProgressReporting -> False
  ];
  madSectors = MSSectors[madContext];
  dsSectors = dsContext["sectors"];
  madMasters = MSMasterIntegrals[madContext];
  dsMasters = dsMasterRecords[dsContext];
  magnitudeMap = dsLineMagnitudeMap[dsContext];
  sectorResults = MapThread[
    Function[{madSector, dsSector},
      contractedLines = Lookup[dsSector, "sectorShrunkLines", {}];
      oracleCoefficient = Expand[Times @@ (oracleLineFactor[case, #] & /@ contractedLines)];
      oracleSelector = Expand[Times @@ (oracleSelectorFactor[case, #] & /@ contractedLines)];
      dsWronskianCoefficient = Expand[
        Times @@ (dsCompiledWronskianFactor[dsContext, #, magnitudeMap] & /@ contractedLines)
      ];
      dsPhysicalCoefficient = dsPhysicalSectorPrefactor[dsSector];
      dsSelector = Cancel[Together[dsWronskianCoefficient/dsPhysicalCoefficient]];
      madCoefficient = madSector["normalization"];
      madSlots = madSlotDescriptor /@ Lookup[madSector, "slots", {}];
      dsSlots = dsSlotDescriptor /@ Lookup[dsSector, "timeOnlyStateSlots", {}];
      <|
        "sectorKey" -> madSector["sectorKey"],
        "contractedLinePositions" -> contractedLines,
        "madSlots" -> madSlots,
        "dsibpSlots" -> dsSlots,
        "slotOrderEqual" -> TrueQ[madSlots === dsSlots],
        "madCoefficient" -> madCoefficient,
        "dsibpCompiledWronskianCoefficient" -> dsWronskianCoefficient,
        "dsibpPhysicalSectorPrefactor" -> dsPhysicalCoefficient,
        "dsibpSelector" -> dsSelector,
        "expectedSelector" -> oracleSelector,
        "oracleCoefficient" -> oracleCoefficient,
        "coefficientDifference" -> FullSimplify[madCoefficient - dsWronskianCoefficient],
        "coefficientRatio" -> FullSimplify[madCoefficient/dsWronskianCoefficient],
        "madMatchesOracle" -> zeroQ[madCoefficient - oracleCoefficient],
        "dsibpMatchesOracle" -> zeroQ[dsWronskianCoefficient - oracleCoefficient],
        "selectorMatches" -> zeroQ[dsSelector - oracleSelector],
        "splitReconstructs" -> zeroQ[dsPhysicalCoefficient dsSelector - dsWronskianCoefficient]
      |>
    ],
    {madSectors, dsSectors}
  ];
  madIdentities = madMasterIdentity /@ madMasters;
  dsIdentities = Lookup[dsMasters, "identity"];
  masterResults = MapThread[
    Function[{index, madRecord, dsRecord},
      key = madRecord["sectorKey"];
      sectorRecord = SelectFirst[sectorResults, #["sectorKey"] === key &];
      <|
        "globalIndex" -> index,
        "madStreeIntegral" -> madRecord["integral"],
        "dSIBPIntegral" -> dsRecord["integral"],
        "madStreeIdentity" -> madMasterIdentity[madRecord],
        "dSIBPIdentity" -> dsRecord["identity"],
        "identityEqual" -> TrueQ[madMasterIdentity[madRecord] === dsRecord["identity"]],
        "madStreeCoefficient" -> madRecord["normalization"],
        "dSIBPCoefficient" -> sectorRecord["dsibpCompiledWronskianCoefficient"],
        "coefficientDifference" -> FullSimplify[
          madRecord["normalization"] - sectorRecord["dsibpCompiledWronskianCoefficient"]
        ],
        "coefficientRatio" -> FullSimplify[
          madRecord["normalization"]/sectorRecord["dsibpCompiledWronskianCoefficient"]
        ],
        "passed" -> And[
          madMasterIdentity[madRecord] === dsRecord["identity"],
          zeroQ[madRecord["normalization"] - sectorRecord["dsibpCompiledWronskianCoefficient"]]
        ]
      |>
    ],
    {Range[Length[madMasters]], madMasters, dsMasters}
  ];
  casePassed = And[
    MSContextQ[madContext],
    Lookup[dsContext, "status", None] === "initialized",
    Lookup[madSectors, "sectorKey"] === Lookup[dsSectors, "sectorKey"],
    Length[madMasters] === case["expectedMasterCount"],
    Length[dsMasters] === case["expectedMasterCount"],
    madIdentities === dsIdentities,
    And @@ Lookup[sectorResults, "slotOrderEqual"],
    And @@ Lookup[sectorResults, "madMatchesOracle"],
    And @@ Lookup[sectorResults, "dsibpMatchesOracle"],
    And @@ Lookup[sectorResults, "selectorMatches"],
    And @@ Lookup[sectorResults, "splitReconstructs"],
    And @@ Lookup[masterResults, "passed"]
  ];
  <|
    "name" -> case["name"],
    "title" -> case["title"],
    "masses" -> case["masses"],
    "sectorOrder" -> Lookup[madSectors, "sectorKey"],
    "sectorMasterCounts" -> (2^Lookup[dsSectors, "timeOnlyStateCount", 0]),
    "expectedMasterCount" -> case["expectedMasterCount"],
    "madStreeMasterCount" -> Length[madMasters],
    "dSIBPMasterCount" -> Length[dsMasters],
    "sectorResults" -> sectorResults,
    "masterResults" -> masterResults,
    "passed" -> casePassed
  |>,
  {case, caseData}
];
wallTimeSeconds = N[AbsoluteTime[] - startTime, 6];


(* ::Chapter:: *)
(*汇总、报告与失败门禁*)

allSectorResults = Flatten[Lookup[caseResults, "sectorResults"]];
allMasterResults = Flatten[Lookup[caseResults, "masterResults"]];
overallPassed = And @@ Lookup[caseResults, "passed"];
gitCommit = StringTrim@RunProcess[{"git", "rev-parse", "HEAD"}, "StandardOutput"];

sourceFiles = <|
  "MadStreeEntry" -> FileNameJoin[{madKernelDirectory, "MadStree.wl"}],
  "MadStreeSectors" -> FileNameJoin[{madKernelDirectory, "Core", "Sectors.wl"}],
  "dSIBPEntry" -> FileNameJoin[{dsibpVersionDirectory, "Kernel", "dSIBP.wl"}],
  "dSIBPSectorModel" -> FileNameJoin[{dsibpVersionDirectory, "Kernel", "Core", "SectorModel018.wl"}]
|>;
sourceHashes = Association@KeyValueMap[#1 -> FileHash[#2, "SHA256", "HexString"] &, sourceFiles];

summary = <|
  "status" -> If[overallPassed, "passed", "failed"],
  "overallPassed" -> overallPassed,
  "date" -> DateString[{"Year", "-", "Month", "-", "Day"}],
  "gitCommit" -> gitCommit,
  "versions" -> <|"MadStree" -> madStreeVersion, "dSIBP" -> dsibpVersion|>,
  "sourceFiles" -> sourceFiles,
  "sourceHashes" -> sourceHashes,
  "scope" -> "master identity and normalization only; no IBP, reduction, Kira, DE, boundary or transport",
  "conventions" -> <|
    "vertexTypes" -> "all +",
    "MadStreeNuConvention" -> "Positive, input mu_e",
    "dSIBPNuConvention" -> "h preset with nu_e=-mu_e",
    "basis" -> "h on both sides; massless full uses one shared quotient state",
    "sectorKey" -> "root line order, 1=active, 0=contracted",
    "stateOrder" -> "massive endpoint 1, endpoint 2; massless shared; IntegerDigits order",
    "normalization" -> "MadStree sector normalization versus dSIBP compiled Wronskian product"
  |>,
  "caseCount" -> Length[caseResults],
  "passedCaseCount" -> Count[Lookup[caseResults, "passed"], True],
  "sectorCount" -> Length[allSectorResults],
  "slotOrderEqualCount" -> Count[Lookup[allSectorResults, "slotOrderEqual"], True],
  "selectorEqualCount" -> Count[Lookup[allSectorResults, "selectorMatches"], True],
  "normalizationEqualSectorCount" -> Count[
    MapThread[And, {Lookup[allSectorResults, "madMatchesOracle"], Lookup[allSectorResults, "dsibpMatchesOracle"]}],
    True
  ],
  "masterCount" -> Length[allMasterResults],
  "identityEqualCount" -> Count[Lookup[allMasterResults, "identityEqual"], True],
  "normalizationEqualMasterCount" -> Count[Lookup[allMasterResults, "coefficientDifference"], 0],
  "wallTimeSeconds" -> wallTimeSeconds,
  "cases" -> caseResults
|>;

Put[summary, summaryPath];

expressionString[expression_] := ToString[InputForm[expression]];
caseTableLines = Map[
  "| " <> #["title"] <> " | " <> ToString[#["madStreeMasterCount"]] <> " | " <>
    ToString[#["dSIBPMasterCount"]] <> " | `" <> expressionString[#["sectorOrder"]] <> "` | `" <>
    expressionString[#["sectorMasterCounts"]] <> "` | " <>
    If[TrueQ[#["passed"]], "PASS", "FAIL"] <> " |" &,
  caseResults
];
sectorTableLines = Flatten@Map[
  Function[caseResult,
    Map[
      "| " <> caseResult["name"] <> " | `" <> #["sectorKey"] <> "` | `" <>
        expressionString[#["madCoefficient"]] <> "` | `" <>
        expressionString[#["dsibpCompiledWronskianCoefficient"]] <> "` | `" <>
        expressionString[#["coefficientRatio"]] <> "` | " <>
        If[And[#["slotOrderEqual"], #["madMatchesOracle"], #["dsibpMatchesOracle"],
          #["selectorMatches"], #["splitReconstructs"]], "PASS", "FAIL"] <> " |" &,
      caseResult["sectorResults"]
    ]
  ],
  caseResults
];

reportLines = Join[
  {
    "# MadStree v0.13 与 dSIBP 022 tree master normalization 独立交叉验证报告",
    "",
    "- 日期：" <> summary["date"],
    "- Git commit：`" <> gitCommit <> "`",
    "- 版本：MadStree `" <> ToString[madStreeVersion] <> "`；dSIBP `" <> ToString[dsibpVersion] <> "`",
    "- 状态：**" <> If[overallPassed, "PASS", "FAIL"] <> "**",
    "- wall time：" <> ToString[wallTimeSeconds] <> " s",
    "",
    "## 范围",
    "",
    "本轮只调用两个当前版本的初始化与只读 master/sector metadata。未生成 IBP，未调用约化、Kira、DE、边界或数值输运；未读取两包既有 expected、测试结果或独立验证报告。",
    "",
    "## convention 对齐",
    "",
    "- 两边顶点、传播子输入顺序、外腿能量、时间幂和 `vertexType=\"+\"` 相同。",
    "- MadStree 使用正 Hankel 阶 `mu_e` 与 `NuConvention -> \"Positive\"`；dSIBP h preset 使用 `nu_e=-mu_e`。",
    "- 两边都在 h basis；massless full 使用一个 shared quotient state，不做 H-to-h 变换。",
    "- sector key 按根线顺序取 `1=active, 0=contracted`；state bits 按 massive 两端点、massless shared 的根线顺序枚举。",
    "- 独立 identity 统一投影为 `CanonicalMaster[sectorKey,timeShifts,stateBits]`，不调用 MadStree 的跨包 adapter。",
    "- 第 `e` 条 massive 线收缩贡献 `W_e=-(4 I/Pi) Exp[-Pi Im[mu_e]] q_e^(2 mu_e-1)`；massless full 线收缩贡献 1。",
    "- dSIBP complete coefficient 直接由编译后的 h-system Wronskian 在固定线模长处求值；另行检查 `physicalSectorPrefactor * selector` 的拆分。",
    "- dSIBP selector 中每条收缩 massive 线贡献 `-1/q_e`，massless 线贡献 1；该拆分逐 sector 回乘检查。",
    "",
    "## case 汇总",
    "",
    "| case | MadStree masters | dSIBP masters | sector order | masters per sector | status |",
    "|---|---:|---:|---|---|---|"
  },
  caseTableLines,
  {
    "",
    "## 逐 sector 系数",
    "",
    "`C_MS` 与 `C_DS` 都是同一裸积分外的完整系数；其自身可含固定传播子模长与 `mu`，对齐后比值必须为 1。",
    "",
    "| case | sector | C_MS | C_DS | ratio | status |",
    "|---|---|---|---|---|---|"
  },
  sectorTableLines,
  {
    "",
    "## 精确计数",
    "",
    "- case：`" <> ToString[summary["passedCaseCount"]] <> "/" <> ToString[summary["caseCount"]] <> "`",
    "- sector slot order：`" <> ToString[summary["slotOrderEqualCount"]] <> "/" <> ToString[summary["sectorCount"]] <> "`",
    "- dSIBP selector split：`" <> ToString[summary["selectorEqualCount"]] <> "/" <> ToString[summary["sectorCount"]] <> "`",
    "- sector normalization：`" <> ToString[summary["normalizationEqualSectorCount"]] <> "/" <> ToString[summary["sectorCount"]] <> "`",
    "- master identity：`" <> ToString[summary["identityEqualCount"]] <> "/" <> ToString[summary["masterCount"]] <> "`",
    "- master coefficient：`" <> ToString[summary["normalizationEqualMasterCount"]] <> "/" <> ToString[summary["masterCount"]] <> "`",
    "",
    "## 结论与边界",
    "",
    If[overallPassed,
      "三个指定 tree family 中，两包选择的 master identity、顺序和完整裸积分外系数逐项一致；所有系数比值为 1、差为 0。",
      "至少一个指定 family 的 master identity、顺序或完整系数不一致；逐项失败证据见 `results/summary.wl`。"
    ],
    "",
    "混合 massive+massless case 在此只验证 master 定义。dSIBP 对 massless quotient 的公式型递推/DE 认证边界不属于本任务，本报告不将 master 对齐解释为该路线已经通过。",
    "",
    "机器可读结果：`results/summary.wl`。"
  }
];

Export[reportPath, StringRiffle[reportLines, "\n"] <> "\n", "Text", CharacterEncoding -> "UTF-8"];
Print[InputForm[KeyTake[summary, {
  "status", "passedCaseCount", "caseCount", "sectorCount", "slotOrderEqualCount",
  "selectorEqualCount", "normalizationEqualSectorCount", "masterCount",
  "identityEqualCount", "normalizationEqualMasterCount", "wallTimeSeconds"
}]]];
If[! overallPassed, Exit[1]];
