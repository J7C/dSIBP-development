(* ::Package:: *)

$CharacterEncoding = "UTF-8";

(***
文件：run_validation.wls
用途：数值验证三顶点 mixed tree 中 massless RedundantH 四态公式与 quotient 二态公式等价。
路线：package 分别生成两套递推/contact/dlog 和生产 Frobenius 边界；固定点代入后比较矩阵，
并由 FlintNDE 独立算出完整 25/15 维主积分数值及 massless 关系残差。
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
targetRules = {k1 -> -480 I, k2 -> -60 I, k3 -> -7 I, qm -> 4/3, qz -> 5/4};
boundaryScale = 2;
workingPrecision = 30;
transportOrder = 24;
referenceTransportOrder = 32;
targetRelativeError = "1e-8";
numericTolerance = 10^-10;

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
(*固定点数值公式、contact、dlog 与低阶约化*)

numericResidualMaximum[expression_, rules_List] := Module[{values},
  values = Abs@N[Flatten[{expression} /. rules], workingPrecision];
  If[values === {}, 0, Max[values]]
];

formulaResiduals = Flatten@Table[
  qFormula = MSFormulaMatrices[quotientContext, key];
  rFormula = MSFormulaMatrices[redundantContext, key];
  s = mapsBySector[key, "S"];
  p = mapsBySector[key, "P"];
  Table[
    rComponent = rFormula["components"][[component]];
    qComponent = qFormula["components"][[component]];
    {
      N[p.(rComponent["M1"] /. rules).s - (qComponent["M1"] /. rules), workingPrecision],
      N[p.(rComponent["M1PlusOne"] /. rules).s -
        (qComponent["M1PlusOne"] /. rules), workingPrecision],
      N[p.(rComponent["M0"] /. rules).s - (qComponent["M0"] /. rules), workingPrecision]
    },
    {rules, {anchorRules, targetRules}},
    {component, Length[qFormula["components"]]}
  ],
  {key, quotientContext["sectorOrder"]}
];
formulaResidualMaximum = numericResidualMaximum[formulaResiduals, {}];

contactResiduals = Flatten@Table[
  qMaps = MSContactMaps[quotientContext, key];
  rMaps = MSContactMaps[redundantContext, key];
  Table[
    rMap = SelectFirst[rMaps, #["eventId"] === qMap["eventId"] &];
    Table[
      N[
        mapsBySector[key, "P"].(rMap["matricesByComponent"][component] /. targetRules).
          mapsBySector[qMap["targetSector"], "S"] -
          (qMap["matricesByComponent"][component] /. targetRules),
        workingPrecision
      ],
      {component, Keys[qMap["matricesByComponent"]]}
    ],
    {qMap, qMaps}
  ],
  {key, quotientContext["sectorOrder"]}
];
contactResidualMaximum = numericResidualMaximum[contactResiduals, {}];

quotientDE = MSDLogDE[quotientContext];
redundantDE = MSDLogDE[redundantContext];
dlogResiduals = Table[
  N[
    globalP.(redundantDE["omegaPotential"] /. rules).globalS -
      (quotientDE["omegaPotential"] /. rules),
    workingPrecision
  ],
  {rules, {anchorRules, targetRules}}
];
dlogResidualMaximum = numericResidualMaximum[dlogResiduals, {}];

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
      "residual" -> N[
        (rReduction["coefficientVector"].globalS - qReduction["coefficientVector"]) /. targetRules,
        workingPrecision
      ],
      "quotientRemaining" -> qReduction["remainingShiftedIntegrals"],
      "redundantRemaining" -> rReduction["remainingShiftedIntegrals"]
    |>
  ],
  reductionCases
];
reductionResidualMaximum = Max[
  numericResidualMaximum[#1["residual"], {}] & /@ Values[reductionData]
];
leftInverseResidualMaximum = numericResidualMaximum[
  globalP.globalS - IdentityMatrix[15], {}
];

matrixChecks = <|
  "representationsFrozen" -> quotientContext["lines"][[2, "masslessRepresentation"]] === "Quotient" &&
    redundantContext["lines"][[2, "masslessRepresentation"]] === "RedundantH",
  "sectorDimensions" -> Lookup[quotientContext["sectors"], "masterCount"] === {8, 2, 4, 1} &&
    Lookup[redundantContext["sectors"], "masterCount"] === {16, 4, 4, 1},
  "globalMapDimensions" -> Dimensions[globalS] === {25, 15} && Dimensions[globalP] === {15, 25},
  "leftInverseNumeric" -> TrueQ[leftInverseResidualMaximum < numericTolerance],
  "formulaProjectionNumeric" -> TrueQ[formulaResidualMaximum < numericTolerance],
  "contactProjectionNumeric" -> TrueQ[contactResidualMaximum < numericTolerance],
  "dlogProjectionNumeric" -> TrueQ[dlogResidualMaximum < numericTolerance],
  "dlogCertified" -> quotientDE["dlogStatus"] === "certifiedByFormulaChecks" &&
    redundantDE["dlogStatus"] === "certifiedByFormulaChecks",
  "oneStepReductionsClosed" -> And @@ Map[
    #["quotientStatus"] === "reduced" && #["redundantStatus"] === "reduced" &&
      #["quotientRemaining"] === {} && #["redundantRemaining"] === {} &,
    Values[reductionData]
  ],
  "oneStepReductionProjectionNumeric" -> TrueQ[reductionResidualMaximum < numericTolerance]
|>;
matrixChecksPassed = And @@ Values[matrixChecks];

summary = <|
  "schema" -> "madstree_independent_validation_v1", "version" -> "v0.3",
  "task" -> "T1 mixed three-vertex massless RedundantH versus Quotient",
  "status" -> If[matrixChecksPassed, "matrixChecksPassedTransportPending", "failed"],
  "sourceDigests" -> sourceDigests, "matrixChecks" -> matrixChecks,
  "leftInverseResidualMaximum" -> leftInverseResidualMaximum,
  "formulaResidualMaximum" -> formulaResidualMaximum,
  "contactResidualMaximum" -> contactResidualMaximum,
  "dlogResidualMaximum" -> dlogResidualMaximum,
  "reductionResidualMaximum" -> reductionResidualMaximum,
  "reductionData" -> reductionData, "localS" -> localS, "localP" -> localP,
  "globalMapDimensions" -> {Dimensions[globalS], Dimensions[globalP]},
  "anchorRules" -> anchorRules, "targetRules" -> targetRules,
  "transportOrder" -> transportOrder, "referenceTransportOrder" -> referenceTransportOrder,
  "workingPrecision" -> workingPrecision
|>;
writeValidationExpression[summaryFile, summary];


(* ::Chapter:: *)
(*生产 Frobenius 边界、FlintNDE 输运与独立 massless 数值关系*)

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

If[matrixChecksPassed,
  {quotientBoundarySeconds, quotientPhysicalBoundary} = AbsoluteTiming[MSBoundaryData[
    quotientContext, targetRules, BoundaryScale -> boundaryScale, BoundarySeriesOrder -> 20,
    RankOrder -> {v1, v2, v3}, WorkingPrecision -> workingPrecision
  ]];
  {redundantBoundarySeconds, redundantPhysicalBoundary} = AbsoluteTiming[MSBoundaryData[
    redundantContext, targetRules, BoundaryScale -> boundaryScale, BoundarySeriesOrder -> 20,
    RankOrder -> {v1, v2, v3}, WorkingPrecision -> workingPrecision
  ]];
  Print["T1 stage production boundaries seconds: ", {quotientBoundarySeconds, redundantBoundarySeconds}];
  physicalExponents = Union[
    Lookup[quotientPhysicalBoundary["leadingBranches"], "frobeniusExponent"],
    Lookup[redundantPhysicalBoundary["leadingBranches"], "frobeniusExponent"]
  ];
  leadingCoefficient[boundary_Association, exponent_, dimension_Integer] := Module[{records},
    records = Select[boundary["leadingBranches"], #1["frobeniusExponent"] === exponent &];
    If[
      records === {},
      ConstantArray[0, dimension],
      Total[Lookup[#, "physicalWeight"] Lookup[#, "normalizedLeadingVector"] & /@ records]
    ]
  ];
  physicalLeadingProjectionDifference = Max[
    relativeDifference[
      N[leadingCoefficient[quotientPhysicalBoundary, #, Length[quotientContext["masters"]]], 35],
      N[globalP.leadingCoefficient[redundantPhysicalBoundary, #, Length[redundantContext["masters"]]], 35]
    ] & /@ physicalExponents
  ];
  physicalLeadingEmbeddingDifference = Max[
    relativeDifference[
      N[leadingCoefficient[redundantPhysicalBoundary, #, Length[redundantContext["masters"]]], 25],
      N[globalS.leadingCoefficient[quotientPhysicalBoundary, #, Length[quotientContext["masters"]]], 25]
    ] & /@ physicalExponents
  ];
  {quotientTransportSeconds, quotientTransport} = AbsoluteTiming[MSFlintNDETransport[
    quotientContext, quotientPhysicalBoundary, WorkingPrecision -> workingPrecision,
    TransportOrder -> transportOrder, ReferenceTransportOrder -> referenceTransportOrder,
    TargetRelativeError -> targetRelativeError, MSRuntimeDirectory -> validationDirectory
  ]];
  Print["T1 stage quotient transport seconds: ", quotientTransportSeconds];
  {redundantTransportSeconds, redundantTransport} = AbsoluteTiming[MSFlintNDETransport[
    redundantContext, redundantPhysicalBoundary, WorkingPrecision -> workingPrecision,
    TransportOrder -> transportOrder, ReferenceTransportOrder -> referenceTransportOrder,
    TargetRelativeError -> targetRelativeError, MSRuntimeDirectory -> validationDirectory
  ]];
  Print["T1 stage redundant transport seconds: ", redundantTransportSeconds];
  quotientBatchEvidence = Lookup[
    quotientTransport["flintNDE", "singularLaunch"], "batchTransport", <||>
  ];
  redundantBatchEvidence = Lookup[
    redundantTransport["flintNDE", "singularLaunch"], "batchTransport", <||>
  ];
  anchorProjectionDifference = relativeDifference[
    quotientTransport["boundary", "values"],
    globalP.redundantTransport["boundary", "values"]
  ];
  targetProjectionDifference = If[
    AssociationQ[quotientTransport] && AssociationQ[redundantTransport],
    relativeDifference[quotientTransport["values"], globalP.redundantTransport["values"]],
    Infinity
  ];
  anchorMasslessResiduals = masslessRelationResiduals[
    redundantTransport["boundary", "values"], redundantContext,
    redundantPhysicalBoundary["anchorRules"]
  ];
  targetMasslessResiduals = If[AssociationQ[redundantTransport],
    masslessRelationResiduals[redundantTransport["values"], redundantContext, targetRules], {}];
  maximumMasslessResidual = Max[Abs@N[Flatten[Lookup[
    Join[anchorMasslessResiduals, targetMasslessResiduals],
    {"hSingle", "hDouble", "physicalSingle", "physicalDoubleQ2"}
  ]], 30]];
  numericChecks = <|
    "ordinaryAnchorAndTarget" -> lettersNonzeroAt[quotientDE, quotientPhysicalBoundary["anchorRules"]] &&
      lettersNonzeroAt[quotientDE, targetRules] &&
      lettersNonzeroAt[redundantDE, redundantPhysicalBoundary["anchorRules"]] &&
      lettersNonzeroAt[redundantDE, targetRules],
    "physicalBoundariesGenerated" -> Lookup[quotientPhysicalBoundary, "method", None] ===
      "2411GenericSectorLeadingSeries" && Lookup[redundantPhysicalBoundary, "method", None] ===
      "2411GenericSectorLeadingSeries",
    "physicalLeadingProjection" -> TrueQ[physicalLeadingProjectionDifference < 10^-16],
    "physicalLeadingEmbedding" -> TrueQ[physicalLeadingEmbeddingDifference < 10^-16],
    "redundantBoundaryGeneratedDirectly" -> Length[redundantPhysicalBoundary["leadingBranches"]] === 25,
    "batchColumnCounts" -> Lookup[quotientBatchEvidence, "columnCount", None] === 15 &&
      Lookup[redundantBatchEvidence, "columnCount", None] === 25,
    "quotientTransportComputed" -> Lookup[quotientTransport, "status", None] === "computed",
    "redundantTransportComputed" -> Lookup[redundantTransport, "status", None] === "computed",
    "productionMatchPointProjection" -> TrueQ[anchorProjectionDifference < 10^-10],
    "productionTargetProjection" -> TrueQ[targetProjectionDifference < 10^-10],
    "quotientRefinement" -> TrueQ[Lookup[Lookup[quotientTransport, "flintNDE", <||>], "targetRelativeErrorMet", False]],
    "redundantRefinement" -> TrueQ[Lookup[Lookup[redundantTransport, "flintNDE", <||>], "targetRelativeErrorMet", False]],
    "allRelevantMasslessSectorsCovered" -> Length[anchorMasslessResiduals] >= 5 &&
      Length[targetMasslessResiduals] >= 5,
    "completeI25MasslessRelationsWithQ2" -> TrueQ[maximumMasslessResidual < 10^-10]
  |>,
  quotientBoundarySeconds = redundantBoundarySeconds = quotientTransportSeconds = redundantTransportSeconds = 0;
  quotientPhysicalBoundary = redundantPhysicalBoundary = quotientTransport = redundantTransport =
    Missing["MatrixChecksFailed"];
  quotientBatchEvidence = redundantBatchEvidence = <||>;
  anchorProjectionDifference = targetProjectionDifference =
    maximumMasslessResidual = Missing["NotExecuted"];
  physicalLeadingProjectionDifference = Missing["NotExecuted"];
  physicalLeadingEmbeddingDifference = Missing["NotExecuted"];
  anchorMasslessResiduals = targetMasslessResiduals = {};
  numericChecks = <|"notExecuted" -> False|>
];


(* ::Chapter:: *)
(*结果、自动报告与退出状态*)

allChecks = Join[matrixChecks, numericChecks];
validationPassed = And @@ Values[allChecks];
validationSeconds = N[AbsoluteTime[] - validationStartTime, 10];
validationSecondsText = ToString[NumberForm[validationSeconds, {Infinity, 3}], OutputForm];
transportPath[result_Association] := Module[{backend = result["flintNDE"]},
  If[Lookup[backend, "schema", ""] === "madstree_flintnde_singular_then_ordinary_v1",
    backend["ordinaryTransport", "path"],
    Lookup[backend, "path", Missing["Unavailable"]]
  ]
];
transportPath[_] := Missing["NotExecuted"];
quotientPath = transportPath[quotientTransport];
redundantPath = transportPath[redundantTransport];

summary = Join[summary, <|
  "status" -> If[validationPassed, "passed", "failed"],
  "checks" -> allChecks, "passedCount" -> Count[Values[allChecks], True], "checkCount" -> Length[allChecks],
  "anchorProjectionRelativeDifference" -> anchorProjectionDifference,
  "physicalLeadingProjectionRelativeDifference" -> physicalLeadingProjectionDifference,
  "physicalLeadingEmbeddingRelativeDifference" -> physicalLeadingEmbeddingDifference,
  "targetProjectionRelativeDifference" -> targetProjectionDifference,
  "quotientMatchValues" -> If[AssociationQ[quotientTransport], quotientTransport["boundary", "values"], Missing["NotExecuted"]],
  "redundantMatchValues" -> If[AssociationQ[redundantTransport], redundantTransport["boundary", "values"], Missing["NotExecuted"]],
  "quotientTargetValues" -> If[AssociationQ[quotientTransport], quotientTransport["values"], Missing["NotExecuted"]],
  "redundantTargetValues" -> If[AssociationQ[redundantTransport], redundantTransport["values"], Missing["NotExecuted"]],
  "maximumMasslessRelationAbsoluteResidual" -> maximumMasslessResidual,
  "anchorMasslessResiduals" -> anchorMasslessResiduals,
  "targetMasslessResiduals" -> targetMasslessResiduals,
  "quotientAdaptivePath" -> quotientPath, "redundantAdaptivePath" -> redundantPath,
  "quotientPathRules" -> If[AssociationQ[quotientTransport], quotientTransport["pathRules"], Missing["NotExecuted"]],
  "redundantPathRules" -> If[AssociationQ[redundantTransport], redundantTransport["pathRules"], Missing["NotExecuted"]],
  "quotientBoundarySeconds" -> quotientBoundarySeconds, "redundantBoundarySeconds" -> redundantBoundarySeconds,
  "quotientTransportSeconds" -> quotientTransportSeconds, "redundantTransportSeconds" -> redundantTransportSeconds,
  "quotientBatchTransport" -> quotientBatchEvidence, "redundantBatchTransport" -> redundantBatchEvidence,
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
  "", "## Fixed-point numerical matrix checks", ""
}, KeyValueMap["- `" <> #1 <> "`: " <> If[TrueQ[#2], "PASS", "FAIL"] &, matrixChecks], {
  "- maximum residuals `{left inverse, formula, contact, dlog, reduction}`: `" <>
    ToString[{leftInverseResidualMaximum, formulaResidualMaximum, contactResidualMaximum,
      dlogResidualMaximum, reductionResidualMaximum}, InputForm] <> "`",
  "- reduction shifts: `v1:+1` massive contact and `v3:+1` massless contact; no higher shifts were tested.",
  "", "## Numerical point, path and orders", "",
  "- formula/contact/dlog substitution points: `" <> ToString[{anchorRules, targetRules}, InputForm] <> "`",
  "- production boundary rank: `{v1,v2,v3}`; quotient anchor: `" <> If[AssociationQ[quotientPhysicalBoundary],
    ToString[quotientPhysicalBoundary["anchorRules"], InputForm], "not executed"] <> "`",
  "- target: `" <> ToString[targetRules, InputForm] <> "`",
  "- physical massless momentum: `qz=5/4`, so the tested double-derivative relation contains the nontrivial factor `qz^2=25/16`.",
  "- quotient and RedundantH both use their own production `2411GenericSectorLeadingSeries`; all 25 RedundantH boundary branches are generated directly by MadStree and transported in the full 25-dimensional DE. `Sglobal/Pglobal` are used only after generation for cross-checks.",
  "- complete 15/25 dimensional systems are transported from their Frobenius singular starts; quotient actual ordinary path `" <> ToString[quotientPath, InputForm] <> "`; redundant actual ordinary path `" <> ToString[redundantPath, InputForm] <> "`.",
  "- FlintNDE batch column counts are `" <> ToString[{Lookup[quotientBatchEvidence, "columnCount", Missing["NotExecuted"]],
    Lookup[redundantBatchEvidence, "columnCount", Missing["NotExecuted"]]}, InputForm] <>
    "`; local basis and ordinary Taylor matrices are shared within each batch.",
  "- production boundary uses `BoundarySeriesOrder=20`; transport uses `WorkingPrecision=" <> ToString[workingPrecision] <>
    "`, `TransportOrder=" <> ToString[transportOrder] <> "`, `ReferenceTransportOrder=" <>
    ToString[referenceTransportOrder] <> "`, target relative error `" <> targetRelativeError <> "`.",
  "", "## Numerical checks", ""
}, KeyValueMap["- `" <> #1 <> "`: " <> If[TrueQ[#2], "PASS", "FAIL"] &, numericChecks], {
  "", "## Numerical evidence and timing", "",
  "- physical Frobenius leading quotient/projected-redundant maximum relative difference: `" <> ToString[physicalLeadingProjectionDifference, InputForm] <> "`",
  "- physical Frobenius leading redundant/embedded-quotient maximum relative difference: `" <> ToString[physicalLeadingEmbeddingDifference, InputForm] <> "`",
  "- production match-point `I15` versus `Pglobal.I25` maximum relative difference: `" <> ToString[anchorProjectionDifference, InputForm] <> "`",
  "- target quotient/projected-redundant maximum relative difference: `" <> ToString[targetProjectionDifference, InputForm] <> "`",
  "- maximum absolute residual among h and physical q^2 relations: `" <> ToString[maximumMasslessResidual, InputForm] <> "`",
  "- quotient/redundant production-boundary generation wall time in seconds: `" <> ToString[{quotientBoundarySeconds, redundantBoundarySeconds}, InputForm] <> "`",
  "- quotient/redundant full physical transport wall time in seconds: `" <> ToString[{quotientTransportSeconds, redundantTransportSeconds}, InputForm] <> "`",
  "- total wall time in seconds: `" <> validationSecondsText <> "`",
  "", "## Outputs", "",
  "- machine-readable summary: `results/summary.wl`",
  "- runtime JSON/cache: `results_temp/` in this validation directory",
  "- no direct `NIntegrate` oracle or manufactured boundary is used in this T1 route."
}];
writeValidationText[reportFile, StringRiffle[reportLines, "\n"] <> "\n"];

Print["MadStree T1 mixed-tree checks: ", summary["passedCount"], "/", summary["checkCount"]];
KeyValueMap[Print[#1, ": ", #2] &, allChecks];
Print["anchor projection difference: ", InputForm[anchorProjectionDifference]];
Print["target projection difference: ", InputForm[targetProjectionDifference]];
Print["maximum massless residual: ", InputForm[maximumMasslessResidual]];
If[! validationPassed, Exit[1]];
