(* ::Package:: *)

$CharacterEncoding = "UTF-8";

(***
文件：run_validation.wls
用途：独立验证三顶点 mixed tree 中 massless RedundantH 四态公式与 quotient 二态公式等价。
路线：package 分别生成两套递推/contact/dlog；验证脚本只构造已冻结的常数投影，并以独立定义积分普通点 anchor 调用 FlintNDE。
输出：逐阶段保存 summary，最终自动生成 `000_MadStree-v0.3-validation-01-report.md`。
***)

(* ::Chapter:: *)
(*路径、固定函数族与参数*)

validationDirectory = DirectoryName[$InputFileName];
madStreeRoot = DirectoryName[DirectoryName[validationDirectory]];
packageRoot = FileNameJoin[{madStreeRoot, "versions", "MadStree-v0.3"}];
resultsDirectory = FileNameJoin[{validationDirectory, "results"}];
reportFile = FileNameJoin[{validationDirectory, "000_MadStree-v0.3-validation-01-report.md"}];
summaryFile = FileNameJoin[{resultsDirectory, "summary.wl"}];
If[! DirectoryQ[resultsDirectory], CreateDirectory[resultsDirectory, CreateIntermediateDirectories -> True]];
AppendTo[$Path, FileNameJoin[{packageRoot, "Kernel"}]];
Needs["MadStree`"];
Get[FileNameJoin[{validationDirectory, "DirectBoundaryOracle.wl"}]];
validationStartTime = AbsoluteTime[];

writeValidationText[path_String, text_String] := Module[{stream},
  stream = OpenWrite[path, BinaryFormat -> True];
  BinaryWrite[stream, ToCharacterCode[text, "UTF8"], "Byte"];
  Close[stream];
  path
];


writeValidationExpression[path_String, expression_] := writeValidationText[
  path,
  StringReplace[
    ToString[expression, InputForm, PageWidth -> 120],
    RegularExpression["[ \\t]+(?=\\r?\\n|$)"] -> ""
  ] <> "\n"
];

baseSpec = <|
  "normalization" -> 1,
  "vertices" -> {
    <|"id" -> v1, "energy" -> k1, "timePower" -> 1, "phaseSign" -> 1|>,
    <|"id" -> v2, "energy" -> k2, "timePower" -> 1, "phaseSign" -> 1|>,
    <|"id" -> v3, "energy" -> k3, "timePower" -> 1, "phaseSign" -> 1|>
  },
  "lines" -> {
    <|"id" -> em, "type" -> "massiveFull", "endpoints" -> {v1, v2},
      "momentum" -> qm, "nu" -> 1/5, "skType" -> "++"|>,
    <|"id" -> ez, "type" -> "masslessFull", "endpoints" -> {v2, v3},
      "momentum" -> qz, "nu" -> 1/2, "skType" -> "++"|>
  }
|>;
quotientSpec = Join[baseSpec, <|"lines" -> ReplacePart[
  baseSpec["lines"],
  2 -> Append[baseSpec["lines"][[2]], "masslessRepresentation" -> "Quotient"]
]|>];
redundantSpec = Join[baseSpec, <|"lines" -> ReplacePart[
  baseSpec["lines"],
  2 -> Append[baseSpec["lines"][[2]], "masslessRepresentation" -> "RedundantH"]
]|>];
quotientContext = MSInitTree[quotientSpec, NuConvention -> "Positive"];
redundantContext = MSInitTree[redundantSpec, NuConvention -> "Positive"];

anchorRules = {k1 -> -15 I, k2 -> -10 I, k3 -> -5 I, qm -> 4/3, qz -> 5/4};
targetRules = {k1 -> -9 I, k2 -> -6 I, k3 -> -3 I, qm -> 4/3, qz -> 5/4};
workingPrecision = 50;
oracleWorkingPrecision = 42;
transportOrder = 64;
referenceTransportOrder = 88;
targetRelativeError = "1e-20";

sourceFiles = FileNameJoin[{packageRoot, #}] & /@ {
  "Kernel/Core/Topology.wl", "Kernel/Core/Sectors.wl", "Kernel/Formula/TensorAtoms.wl",
  "Kernel/Formula/Recurrence.wl", "Kernel/DE/DLog.wl"
};
sourceDigests = AssociationThread[
  FileNameTake /@ sourceFiles,
  IntegerString[FileHash[#, "SHA256"], 16, 64] & /@ sourceFiles
];


(* ::Chapter:: *)
(*Sector-wise 四态/二态映射*)

localS = {{1, 0}, {0, I}, {0, -I}, {1, 0}};
localP = {{1, 0, 0, 0}, {0, 0, I, 0}};
literalPosition[list_List, key_] := FirstPosition[list, item_ /; SameQ[item, key], Missing["NotFound"]];

(* 按实际 slot key 配对 spectator bits；不依赖 massless slot 在 Kronecker 积中的位置。 *)
sectorMaps[quotientSector_Association, redundantSector_Association] := Module[
  {qKeys, rKeys, qSharedPosition, rEndpointPositions, commonKeys, qCommonPositions,
   rCommonPositions, s, p, qState, rState, localRow, localColumn},
  qKeys = Lookup[quotientSector["slots"], "key", {}];
  rKeys = Lookup[redundantSector["slots"], "key", {}];
  qSharedPosition = literalPosition[qKeys, {ez, "shared"}];
  If[Head[qSharedPosition] === Missing,
    Return[<|
      "S" -> IdentityMatrix[quotientSector["masterCount"]],
      "P" -> IdentityMatrix[quotientSector["masterCount"]]
    |>]
  ];
  qSharedPosition = First[qSharedPosition];
  rEndpointPositions = First /@ (literalPosition[rKeys, {ez, #}] & /@ {1, 2});
  commonKeys = Select[qKeys, # =!= {ez, "shared"} &];
  qCommonPositions = First /@ (literalPosition[qKeys, #] & /@ commonKeys);
  rCommonPositions = First /@ (literalPosition[rKeys, #] & /@ commonKeys);
  s = ConstantArray[0, {redundantSector["masterCount"], quotientSector["masterCount"]}];
  p = ConstantArray[0, {quotientSector["masterCount"], redundantSector["masterCount"]}];
  Do[
    qState = quotientSector["stateOrder"][[qColumn]];
    rState = redundantSector["stateOrder"][[rRow]];
    If[qState[[qCommonPositions]] === rState[[rCommonPositions]],
      localRow = FromDigits[rState[[rEndpointPositions]], 2] + 1;
      localColumn = qState[[qSharedPosition]] + 1;
      s[[rRow, qColumn]] = localS[[localRow, localColumn]];
      p[[qColumn, rRow]] = localP[[localColumn, localRow]]
    ],
    {rRow, redundantSector["masterCount"]},
    {qColumn, quotientSector["masterCount"]}
  ];
  <|"S" -> s, "P" -> p|>
];

quotientSectorByKey = AssociationThread[quotientContext["sectorOrder"] -> quotientContext["sectors"]];
redundantSectorByKey = AssociationThread[redundantContext["sectorOrder"] -> redundantContext["sectors"]];
mapsBySector = Association@Table[
  key -> sectorMaps[quotientSectorByKey[key], redundantSectorByKey[key]],
  {key, quotientContext["sectorOrder"]}
];
globalS = ArrayFlatten@Map[
  Function[sourceKey, Map[
    If[sourceKey === #, mapsBySector[sourceKey, "S"],
      ConstantArray[0, {
        redundantSectorByKey[sourceKey, "masterCount"], quotientSectorByKey[#, "masterCount"]
      }]
    ] &,
    quotientContext["sectorOrder"]
  ]],
  redundantContext["sectorOrder"]
];
globalP = ArrayFlatten@Map[
  Function[sourceKey, Map[
    If[sourceKey === #, mapsBySector[sourceKey, "P"],
      ConstantArray[0, {
        quotientSectorByKey[sourceKey, "masterCount"], redundantSectorByKey[#, "masterCount"]
      }]
    ] &,
    redundantContext["sectorOrder"]
  ]],
  quotientContext["sectorOrder"]
];


(* ::Chapter:: *)
(*Exact 公式、contact、dlog 与低阶约化*)

formulaResiduals = Flatten@Table[
  qFormula = MSFormulaMatrices[quotientContext, key];
  rFormula = MSFormulaMatrices[redundantContext, key];
  s = mapsBySector[key, "S"];
  p = mapsBySector[key, "P"];
  Table[{
    Simplify[p.rFormula["components"][[component, "M1"]].s - qFormula["components"][[component, "M1"]]],
    Simplify[p.rFormula["components"][[component, "M1PlusOne"]].s - qFormula["components"][[component, "M1PlusOne"]]],
    Simplify[p.rFormula["components"][[component, "M0"]].s - qFormula["components"][[component, "M0"]]]
  }, {component, Length[qFormula["components"]]}],
  {key, quotientContext["sectorOrder"]}
];

contactResiduals = Flatten@Table[
  qMaps = MSContactMaps[quotientContext, key];
  rMaps = MSContactMaps[redundantContext, key];
  Table[
    rMap = SelectFirst[rMaps, #["eventId"] === qMap["eventId"] &];
    Table[
      Simplify[
        mapsBySector[key, "P"].rMap["matricesByComponent"][component].
          mapsBySector[qMap["targetSector"], "S"] - qMap["matricesByComponent"][component]
      ],
      {component, Keys[qMap["matricesByComponent"]]}
    ],
    {qMap, qMaps}
  ],
  {key, quotientContext["sectorOrder"]}
];

quotientDE = MSDLogDE[quotientContext];
redundantDE = MSDLogDE[redundantContext];
dlogResidual = Simplify[globalP.redundantDE["omegaPotential"].globalS - quotientDE["omegaPotential"]];

topKey = First[quotientContext["sectorOrder"]];
topQ = quotientSectorByKey[topKey];
topR = redundantSectorByKey[topKey];
redundantInputForQuotientState[shifts_List, quotientBits_List] := Module[{qIndex, coefficients},
  qIndex = First@FirstPosition[topQ["stateOrder"], quotientBits];
  coefficients = mapsBySector[topKey, "P"][[qIndex]];
  Total@MapThread[#1 MSIntegral[topKey, shifts, #2] &, {coefficients, topR["stateOrder"]}]
];

reductionCases = {
  <|"name" -> "massiveContactOneStep", "shifts" -> {1, 0, 0}, "bits" -> {0, 1, 0}|>,
  <|"name" -> "masslessContactOneStep", "shifts" -> {0, 0, 1}, "bits" -> {0, 0, 1}|>
};
reductionData = Association@Map[
  Function[case,
    qReduction = MSReduce[MSIntegral[topKey, case["shifts"], case["bits"]], quotientContext];
    rReduction = MSReduce[redundantInputForQuotientState[case["shifts"], case["bits"]], redundantContext];
    case["name"] -> <|
      "quotientStatus" -> qReduction["status"],
      "redundantStatus" -> rReduction["status"],
      "residual" -> Simplify[rReduction["coefficientVector"].globalS - qReduction["coefficientVector"]],
      "quotientRemaining" -> qReduction["remainingShiftedIntegrals"],
      "redundantRemaining" -> rReduction["remainingShiftedIntegrals"]
    |>
  ],
  reductionCases
];

exactNonzeroCount[expression_] := Count[
  Flatten[{expression}], value_ /; ! TrueQ[PossibleZeroQ[value]]
];
exactChecks = <|
  "representationsFrozen" -> quotientContext["lines"][[2, "masslessRepresentation"]] === "Quotient" &&
    redundantContext["lines"][[2, "masslessRepresentation"]] === "RedundantH",
  "sectorDimensions" -> Lookup[quotientContext["sectors"], "masterCount"] === {8, 2, 4, 1} &&
    Lookup[redundantContext["sectors"], "masterCount"] === {16, 4, 4, 1},
  "globalMapDimensions" -> Dimensions[globalS] === {25, 15} && Dimensions[globalP] === {15, 25},
  "leftInverse" -> exactNonzeroCount[Simplify[globalP.globalS - IdentityMatrix[15]]] === 0,
  "formulaIntertwining" -> exactNonzeroCount[formulaResiduals] === 0,
  "contactIntertwining" -> exactNonzeroCount[contactResiduals] === 0,
  "dlogIntertwining" -> exactNonzeroCount[dlogResidual] === 0,
  "dlogCertified" -> quotientDE["dlogStatus"] === "certifiedByFormulaChecks" &&
    redundantDE["dlogStatus"] === "certifiedByFormulaChecks",
  "oneStepReductionsClosed" -> And @@ Map[
    #["quotientStatus"] === "reduced" && #["redundantStatus"] === "reduced" &&
      #["quotientRemaining"] === {} && #["redundantRemaining"] === {} &,
    Values[reductionData]
  ],
  "oneStepReductionIntertwining" -> And @@ (exactNonzeroCount[#["residual"]] === 0 & /@ Values[reductionData])
|>;
exactPassed = And @@ Values[exactChecks];

summary = <|
  "schema" -> "madstree_independent_validation_v1", "version" -> "v0.3",
  "task" -> "T1 mixed three-vertex massless RedundantH versus Quotient",
  "status" -> If[exactPassed, "exactPassedNumericPending", "failed"],
  "sourceDigests" -> sourceDigests, "exactChecks" -> exactChecks,
  "formulaResidualNonzeroCount" -> exactNonzeroCount[formulaResiduals],
  "contactResidualNonzeroCount" -> exactNonzeroCount[contactResiduals],
  "dlogResidualNonzeroCount" -> exactNonzeroCount[dlogResidual],
  "reductionData" -> reductionData, "localS" -> localS, "localP" -> localP,
  "globalMapDimensions" -> {Dimensions[globalS], Dimensions[globalP]},
  "anchorRules" -> anchorRules, "targetRules" -> targetRules,
  "transportOrder" -> transportOrder, "referenceTransportOrder" -> referenceTransportOrder,
  "workingPrecision" -> workingPrecision
|>;
writeValidationExpression[summaryFile, summary];


(* ::Chapter:: *)
(*独立普通点 anchor、FlintNDE 输运与 massless 数值关系*)

relativeDifference[left_List, right_List] := Max@MapThread[
  Abs[#1 - #2]/Max[Abs[#2], 10^-35] &,
  {left, right}
];
lettersNonzeroAt[de_Association, rules_List] := And @@ Map[
  NumericQ[N[# /. rules, 30]] && ! TrueQ[PossibleZeroQ[# /. rules]] &,
  de["letters"]
];

masslessRelationResiduals[values_List, context_Association, rules_List] := Module[
  {offsets, residuals = {}, sector, slots, keys, positions, commonPositions, states, baseStates,
   stateIndex, globalOffset, qValue, indices, f00, f01, f10, f11},
  offsets = AssociationThread[context["sectorOrder"] -> Most@FoldList[Plus, 1, Lookup[context["sectors"], "masterCount"]]];
  Do[
    slots = sector["slots"];
    keys = Lookup[slots, "key", {}];
    positions = literalPosition[keys, {ez, #}] & /@ {1, 2};
    If[FreeQ[positions, _Missing],
      positions = First /@ positions;
      commonPositions = Complement[Range[Length[keys]], positions];
      states = sector["stateOrder"];
      baseStates = Select[states, #[[positions]] === {0, 0} &];
      stateIndex = AssociationThread[ToString[#, InputForm] & /@ states -> Range[Length[states]]];
      globalOffset = offsets[sector["sectorKey"]] - 1;
      qValue = qz /. rules;
      Do[
        indices = Table[
          globalOffset + stateIndex[ToString[ReplacePart[baseState, Thread[positions -> bits]], InputForm]],
          {bits, {{0, 0}, {0, 1}, {1, 0}, {1, 1}}}
        ];
        {f00, f01, f10, f11} = values[[indices]];
        AppendTo[residuals, <|
          "sectorKey" -> sector["sectorKey"], "spectatorBits" -> baseState[[commonPositions]],
          "hSingle" -> f01 + f10, "hDouble" -> f11 - f00,
          "physicalSingle" -> -qValue f01 - qValue f10,
          "physicalDoubleQ2" -> qValue^2 f11 - qValue^2 f00
        |>]
      , {baseState, baseStates}]
    ],
    {sector, context["sectors"]}
  ];
  residuals
];

If[exactPassed,
  childSectorKey = SelectFirst[
    quotientContext["sectors"],
    #["contractedLineIds"] === {em} &
  ]["sectorKey"];
  {quotientOracleSeconds, quotientAnchor} = AbsoluteTiming[
    MadStreeT1Test`DirectBoundaryOracle`MSDirectSectorOracle[
      quotientContext, childSectorKey, anchorRules, WorkingPrecision -> oracleWorkingPrecision,
      AccuracyGoal -> 24, PrecisionGoal -> 24, MaxRecursion -> 12
    ]
  ];
  Print["T1 stage quotient child oracle seconds: ", quotientOracleSeconds];
  writeValidationExpression[
    summaryFile,
    Join[summary, <|"quotientOracleSeconds" -> quotientOracleSeconds|>]
  ];
  {redundantOracleSeconds, redundantAnchor} = AbsoluteTiming[
    MadStreeT1Test`DirectBoundaryOracle`MSDirectSectorOracle[
      redundantContext, childSectorKey, anchorRules, WorkingPrecision -> oracleWorkingPrecision,
      AccuracyGoal -> 24, PrecisionGoal -> 24, MaxRecursion -> 12
    ]
  ];
  Print["T1 stage redundant child oracle seconds: ", redundantOracleSeconds];
  writeValidationExpression[
    summaryFile,
    Join[summary, <|"quotientOracleSeconds" -> quotientOracleSeconds,
      "redundantOracleSeconds" -> redundantOracleSeconds|>]
  ];
  manufacturedQuotientAnchor = Range[15]/17 + I Reverse[Range[15]]/19;
  manufacturedRedundantAnchor = globalS.manufacturedQuotientAnchor;
  quotientBoundary = <|
    "status" -> "generated", "boundaryKind" -> "validationOnlyManufacturedCompatibleAnchor",
    "masterDigest" -> quotientContext["masterDigest"], "values" -> manufacturedQuotientAnchor,
    "anchorRules" -> anchorRules, "targetRules" -> targetRules
  |>;
  redundantBoundary = <|
    "status" -> "generated", "boundaryKind" -> "validationOnlyManufacturedCompatibleAnchor",
    "masterDigest" -> redundantContext["masterDigest"], "values" -> manufacturedRedundantAnchor,
    "anchorRules" -> anchorRules, "targetRules" -> targetRules
  |>;
  {quotientTransportSeconds, quotientTransport} = AbsoluteTiming[MSFlintNDETransport[
    quotientContext, quotientBoundary, WorkingPrecision -> workingPrecision,
    TransportOrder -> transportOrder, ReferenceTransportOrder -> referenceTransportOrder,
    TargetRelativeError -> targetRelativeError, MSRuntimeDirectory -> validationDirectory
  ]];
  Print["T1 stage quotient transport seconds: ", quotientTransportSeconds];
  {redundantTransportSeconds, redundantTransport} = AbsoluteTiming[MSFlintNDETransport[
    redundantContext, redundantBoundary, WorkingPrecision -> workingPrecision,
    TransportOrder -> transportOrder, ReferenceTransportOrder -> referenceTransportOrder,
    TargetRelativeError -> targetRelativeError, MSRuntimeDirectory -> validationDirectory
  ]];
  Print["T1 stage redundant transport seconds: ", redundantTransportSeconds];
  anchorProjectionDifference = relativeDifference[manufacturedQuotientAnchor, globalP.manufacturedRedundantAnchor];
  childIntegralProjectionDifference = relativeDifference[
    quotientAnchor["values"], mapsBySector[childSectorKey, "P"].redundantAnchor["values"]
  ];
  targetProjectionDifference = If[
    AssociationQ[quotientTransport] && AssociationQ[redundantTransport],
    relativeDifference[quotientTransport["values"], globalP.redundantTransport["values"]],
    Infinity
  ];
  redundantChildGlobal = ConstantArray[0, Length[redundantContext["masters"]]];
  redundantChildOffset = First@Lookup[
    Select[redundantContext["masters"], #["sectorKey"] === childSectorKey &],
    "globalIndex"
  ];
  redundantChildGlobal[[redundantChildOffset ;; redundantChildOffset + Length[redundantAnchor["values"]] - 1]] =
    redundantAnchor["values"];
  anchorMasslessResiduals = Select[
    masslessRelationResiduals[redundantChildGlobal, redundantContext, anchorRules],
    #["sectorKey"] === childSectorKey &
  ];
  targetMasslessResiduals = If[AssociationQ[redundantTransport],
    masslessRelationResiduals[redundantTransport["values"], redundantContext, targetRules], {}];
  maximumMasslessResidual = Max[Abs@N[Flatten[Lookup[
    Join[anchorMasslessResiduals, targetMasslessResiduals],
    {"hSingle", "hDouble", "physicalSingle", "physicalDoubleQ2"}
  ]], 30]];
  numericChecks = <|
    "ordinaryAnchorAndTarget" -> lettersNonzeroAt[quotientDE, anchorRules] &&
      lettersNonzeroAt[quotientDE, targetRules] && lettersNonzeroAt[redundantDE, anchorRules] &&
      lettersNonzeroAt[redundantDE, targetRules],
    "childDirectOraclesComputed" -> Lookup[quotientAnchor, "status", None] === "computed" &&
      Lookup[redundantAnchor, "status", None] === "computed",
    "manufacturedAnchorProjection" -> TrueQ[anchorProjectionDifference < 10^-30],
    "childIntegralProjection" -> TrueQ[childIntegralProjectionDifference < 10^-18],
    "quotientTransportComputed" -> Lookup[quotientTransport, "status", None] === "computed",
    "redundantTransportComputed" -> Lookup[redundantTransport, "status", None] === "computed",
    "targetProjection" -> TrueQ[targetProjectionDifference < 10^-16],
    "quotientRefinement" -> TrueQ[Lookup[Lookup[quotientTransport, "flintNDE", <||>], "targetRelativeErrorMet", False]],
    "redundantRefinement" -> TrueQ[Lookup[Lookup[redundantTransport, "flintNDE", <||>], "targetRelativeErrorMet", False]],
    "masslessRelationsWithQ2" -> TrueQ[maximumMasslessResidual < 10^-18]
  |>,
  quotientOracleSeconds = redundantOracleSeconds = quotientTransportSeconds = redundantTransportSeconds = 0;
  quotientAnchor = redundantAnchor = quotientTransport = redundantTransport = Missing["ExactChecksFailed"];
  anchorProjectionDifference = childIntegralProjectionDifference = targetProjectionDifference =
    maximumMasslessResidual = Missing["NotExecuted"];
  anchorMasslessResiduals = targetMasslessResiduals = {};
  numericChecks = <|"notExecuted" -> False|>
];


(* ::Chapter:: *)
(*结果、自动报告与退出状态*)

allChecks = Join[exactChecks, numericChecks];
validationPassed = And @@ Values[allChecks];
validationSeconds = N[AbsoluteTime[] - validationStartTime, 10];
validationSecondsText = ToString[NumberForm[validationSeconds, {Infinity, 3}], OutputForm];
quotientPath = If[AssociationQ[quotientTransport], Lookup[quotientTransport["flintNDE"], "path", Missing["Unavailable"]], Missing["NotExecuted"]];
redundantPath = If[AssociationQ[redundantTransport], Lookup[redundantTransport["flintNDE"], "path", Missing["Unavailable"]], Missing["NotExecuted"]];

summary = Join[summary, <|
  "status" -> If[validationPassed, "passed", "failed"],
  "checks" -> allChecks, "passedCount" -> Count[Values[allChecks], True], "checkCount" -> Length[allChecks],
  "anchorProjectionRelativeDifference" -> anchorProjectionDifference,
  "childIntegralProjectionRelativeDifference" -> childIntegralProjectionDifference,
  "targetProjectionRelativeDifference" -> targetProjectionDifference,
  "maximumMasslessRelationAbsoluteResidual" -> maximumMasslessResidual,
  "anchorMasslessResiduals" -> anchorMasslessResiduals,
  "targetMasslessResiduals" -> targetMasslessResiduals,
  "quotientAdaptivePath" -> quotientPath, "redundantAdaptivePath" -> redundantPath,
  "quotientPathRules" -> If[AssociationQ[quotientTransport], quotientTransport["pathRules"], Missing["NotExecuted"]],
  "redundantPathRules" -> If[AssociationQ[redundantTransport], redundantTransport["pathRules"], Missing["NotExecuted"]],
  "quotientOracleSeconds" -> quotientOracleSeconds, "redundantOracleSeconds" -> redundantOracleSeconds,
  "quotientTransportSeconds" -> quotientTransportSeconds, "redundantTransportSeconds" -> redundantTransportSeconds,
  "elapsedSeconds" -> validationSeconds,
  "runtimeDirectory" -> If[AssociationQ[quotientTransport], quotientTransport["runtimeDirectory"], Missing["NotExecuted"]]
|>];
writeValidationExpression[summaryFile, summary];

reportLines = Join[{
  "# MadStree v0.3 independent validation report: T1 mixed three-vertex massless four-state versus quotient",
  "", "> Generated automatically by `run_validation.wls`.", "", "## Status", "",
  "- status: `" <> summary["status"] <> "`",
  "- checks: `" <> ToString[summary["passedCount"]] <> "/" <> ToString[summary["checkCount"]] <> "`",
  "- version: `MadStree-v0.3`",
  "- explicit convention: `NuConvention -> \"Positive\"`; `massive nu=1/5`; `massless nu=1/2`; both lines `G++`",
  "", "## Fixed family and normalization", "",
  "- topology: `v1 -- massiveFull(em) -- v2 -- masslessFull(ez) -- v3`",
  "- root normalization: `1`; massive contraction uses the package canonical pinch factor; massless contraction uses `1`.",
  "- RedundantH uses `Pi/2` per active massless Hankel endpoint product, so the local maps are `S={{1,0},{0,I},{0,-I},{1,0}}`, `P={{1,0,0,0},{0,0,I,0}}`.",
  "- quotient sector dimensions: `{8,2,4,1}`; redundant sector dimensions: `{16,4,4,1}`.",
  "", "## Exact checks", ""
}, KeyValueMap["- `" <> #1 <> "`: " <> If[TrueQ[#2], "PASS", "FAIL"] &, exactChecks], {
  "- formula/contact/dlog nonzero residual counts: `" <>
    ToString[{summary["formulaResidualNonzeroCount"], summary["contactResidualNonzeroCount"], summary["dlogResidualNonzeroCount"]}, InputForm] <> "`",
  "- reduction shifts: `v1:+1` massive contact and `v3:+1` massless contact; no higher shifts were tested.",
  "", "## Numerical point, path and orders", "",
  "- anchor: `" <> ToString[anchorRules, InputForm] <> "`",
  "- target: `" <> ToString[targetRules, InputForm] <> "`",
  "- physical massless momentum: `qz=5/4`, so the tested double-derivative relation contains the nontrivial factor `qz^2=25/16`.",
  "- full-system boundary type: validation-only manufactured compatible ordinary anchor `br=Sglobal.bq`; Frobenius/local singular order: `not applicable`.",
  "- defining-integral oracle: only the 2/4 dimensional child sector with contracted massive line and active massless line; it is not used as the full-system transport boundary.",
  "- affine path: all three vertex energies move synchronously from anchor to target; quotient actual path `" <> ToString[quotientPath, InputForm] <> "`; redundant actual path `" <> ToString[redundantPath, InputForm] <> "`.",
  "- `WorkingPrecision=50`, `TransportOrder=64`, `ReferenceTransportOrder=88`, target relative error `1e-20`.",
  "", "## Numerical checks", ""
}, KeyValueMap["- `" <> #1 <> "`: " <> If[TrueQ[#2], "PASS", "FAIL"] &, numericChecks], {
  "", "## Numerical evidence and timing", "",
  "- manufactured anchor quotient/projected-redundant maximum relative difference: `" <> ToString[anchorProjectionDifference, InputForm] <> "`",
  "- child defining-integral quotient/projected-redundant maximum relative difference: `" <> ToString[childIntegralProjectionDifference, InputForm] <> "`",
  "- target quotient/projected-redundant maximum relative difference: `" <> ToString[targetProjectionDifference, InputForm] <> "`",
  "- maximum absolute residual among h and physical q^2 relations: `" <> ToString[maximumMasslessResidual, InputForm] <> "`",
  "- quotient/redundant direct-oracle wall time in seconds: `" <> ToString[{quotientOracleSeconds, redundantOracleSeconds}, InputForm] <> "`",
  "- quotient/redundant transport wall time in seconds: `" <> ToString[{quotientTransportSeconds, redundantTransportSeconds}, InputForm] <> "`",
  "- total wall time in seconds: `" <> validationSecondsText <> "`",
  "", "## Outputs", "",
  "- machine-readable summary: `results/summary.wl`",
  "- runtime JSON/cache: `results_temp/` in this validation directory",
  "- direct integration is validation-only and is not loaded by MadStree Kernel."
}];
writeValidationText[reportFile, StringRiffle[reportLines, "\n"] <> "\n"];

Print["MadStree T1 mixed-tree checks: ", summary["passedCount"], "/", summary["checkCount"]];
KeyValueMap[Print[#1, ": ", #2] &, allChecks];
Print["anchor projection difference: ", InputForm[anchorProjectionDifference]];
Print["target projection difference: ", InputForm[targetProjectionDifference]];
Print["maximum massless residual: ", InputForm[maximumMasslessResidual]];
If[! validationPassed, Exit[1]];
