(* ::Package:: *)

(***
文件：test_dsibp_derivative_dlog.wls
用途：比较 dSIBP ds + MadStree MSReduce 与 MadStree 直接 dlog 公式生成的 mixed 三顶点 DE。
边界：MadStree 不实现求导算符；本脚本只调用 dSIBP 020 的公开 ds，并在固定精确点比较。
***)

(* ::Chapter:: *)
(*路径与程序包加载*)

madStreeVersionDirectory = DirectoryName[DirectoryName[$InputFileName]];
projectRoot = DirectoryName[DirectoryName[DirectoryName[madStreeVersionDirectory]]];
dsibpPackageOverride = Quiet[Environment["DSIBP_PACKAGE_FILE"]];
AppendTo[$Path, madStreeVersionDirectory];
Needs["MadStree`"];
If[StringQ[dsibpPackageOverride] && StringLength[StringTrim[dsibpPackageOverride]] > 0,
  Get[ExpandFileName[dsibpPackageOverride]],
  dsibpVersionDirectory = FileNameJoin[{
    projectRoot, "package-dSibp", "versions", "020_dSIBP"
  }];
  AppendTo[$Path, dsibpVersionDirectory];
  Needs["dSIBP`"]
];
DSMessagesOff[];


(* ::Chapter:: *)
(*同一 mixed 三顶点函数族*)

madSpec = <|
  "name" -> "MixedThreeVertexDSIBPDerivative",
  "normalization" -> 1,
  "vertices" -> {
    <|"id" -> v1, "energy" -> k1, "timePower" -> a1, "phaseSign" -> -1|>,
    <|"id" -> v2, "energy" -> k2, "timePower" -> a2, "phaseSign" -> -1|>,
    <|"id" -> v3, "energy" -> k3, "timePower" -> a3, "phaseSign" -> -1|>
  },
  "lines" -> {
    <|"id" -> em, "type" -> "massiveFull", "endpoints" -> {v1, v2},
      "momentum" -> sE1, "nu" -> mu, "skType" -> "++",
      "pinchNormalization" -> (4 I/Pi) Exp[-Pi Im[mu]] sE1^(2 mu)|>,
    <|"id" -> ez, "type" -> "masslessFull", "endpoints" -> {v2, v3},
      "momentum" -> sE2, "nu" -> 1/2, "skType" -> "++",
      "masslessRepresentation" -> "Quotient"|>
  }
|>;

dsibpSpec = <|
  "name" -> "MixedThreeVertexDSIBPDerivative",
  "vertexData" -> {{v1, "+"}, {v2, "+"}, {v3, "+"}},
  "lineData" -> {
    <|"id" -> em, "endpoints" -> {v1, v2}, "momentum" -> pM,
      "treeEnergy" -> sE1, "nu" -> -mu, "bbType" -> "h",
      "massType" -> "massive", "skType" -> "++"|>,
    <|"id" -> ez, "endpoints" -> {v2, v3}, "momentum" -> pZ,
      "treeEnergy" -> sE2, "nu" -> 0, "bbType" -> "exp",
      "massType" -> "massless", "skType" -> "++"|>
  },
  "loopMomenta" -> {},
  "loopExternalMomenta" -> {},
  "independentExternalMomenta" -> {pM, pZ},
  "ibpMode" -> "timeOnly",
  "vertexEnergies" -> <|v1 -> k1, v2 -> k2, v3 -> k3|>,
  "ispData" -> {},
  "zeroPointRules" -> {
    a0[v1] -> a1, a0[v2] -> a2, a0[v3] -> a3,
    b0[em] -> 0, b0[ez] -> 0
  },
  "symmetryRules" -> {}
|>;

madContext = MSInitTree[madSpec, NuConvention -> "Positive"];
dsibpContext = DSInit[
  dsibpSpec,
  RegisterAsCurrent -> False,
  WriteInitializationFiles -> False,
  GenerateDerivativeMetadata -> True,
  ProgressReporting -> False
];

numericRules = {
  k1 -> 13 I, k2 -> 9 I, k3 -> 5 I,
  sE1 -> 4/3, sE2 -> 5/4,
  mu -> 1/5, a1 -> 1, a2 -> 1, a3 -> 1,
  Exp[Pi Im[-mu]] -> 1, Exp[Pi Im[mu]] -> 1
};
numericMadContext = madContext /. numericRules;
madDE = MSDLogDE[madContext];
masters = Lookup[MSMasterIntegrals[madContext], "integral"];
dsibpMasters = Activate[MSToDSIBPJ[#, madContext]] & /@ masters;
derivativeVariables = Lookup[
  Lookup[Lookup[dsibpContext, "derivatives", <||>], "operators", {}],
  "userVariable",
  {}
];


(* ::Chapter:: *)
(*ds 求导、表示转换与数值 MSReduce*)

reduceDerivativeRow[masterIndex_Integer, variable_] := Module[
  {derivative, converted, reduced},
  derivative = ds[dsibpMasters[[masterIndex]], variable, dsibpContext];
  If[derivative === $Failed,
    Return[Failure["DSIBPDerivativeFailed", <|"masterIndex" -> masterIndex, "variable" -> variable|>]]
  ];
  converted = MSFromDSIBPExpression[derivative /. numericRules, numericMadContext];
  If[Head[converted] === Failure, Return[converted]];
  reduced = MSReduce[converted, numericMadContext];
  If[Head[reduced] === Failure || Lookup[reduced, "status", None] =!= "reduced" ||
     Lookup[reduced, "nonMasterResidual", Missing["Absent"]] =!= 0 ||
     Lookup[reduced, "remainingShiftedIntegrals", {Missing["Absent"]}] =!= {},
    Return[Failure[
      "DerivativeReductionFailed",
      <|"masterIndex" -> masterIndex, "variable" -> variable, "result" -> reduced|>
    ]]
  ];
  reduced["coefficientVector"]
];

variablesToCheck = Intersection[{k1, k2, k3, sE1, sE2}, derivativeVariables];
routeData = Association@Table[
  rows = Table[reduceDerivativeRow[index, variable], {index, Length[masters]}];
  failures = Cases[rows, _Failure];
  directMatrix = Map[
    Cancel[Together[# /. numericRules]] &,
    D[madDE["omegaPotential"], variable],
    {2}
  ];
  routeMatrix = If[failures === {}, rows, Missing["ReductionFailed"]];
  residual = If[failures === {}, Map[Cancel[Together[#]] &, routeMatrix - directMatrix, {2}], Missing["NotCompared"]];
  variable -> <|
    "routeMatrix" -> routeMatrix,
    "directMatrix" -> directMatrix,
    "failures" -> failures,
    "residual" -> residual,
    "nonzeroDifferenceCount" -> If[failures === {}, Count[Flatten[residual], value_ /; ! TrueQ[value === 0]], Missing["NotCompared"]]
  |>,
  {variable, variablesToCheck}
];


(* ::Section::Closed:: *)
(*Time-only sector prefactor 诊断*)

diagnosticMasterIndex = 9;
diagnosticDSIBPMaster = dsibpMasters[[diagnosticMasterIndex]];
diagnosticInternalMaster = dSIBP`Private`dsTimeOnlyPublicIntegralToInternal020[
  diagnosticDSIBPMaster,
  dsibpContext
];
diagnosticPrefactorData = dSIBP`Private`sectorPrefactorDataForIntegral018[
  dsibpContext["topology"],
  diagnosticInternalMaster
];
diagnosticPrefactor = dSIBP`Private`materializeSectorPrefactor018[diagnosticPrefactorData];
diagnosticPrefactorLogDerivative = dSIBP`Private`sectorPrefactorLogDerivative018[
  <|"sectorPrefactorData" -> diagnosticPrefactorData|>,
  sE1
];
diagnosticDerivative = ds[diagnosticDSIBPMaster, sE1, dsibpContext];


(* ::Chapter:: *)
(*验收与证据*)

(* 返回每个变量的首个非零矩阵元，直接关联源 master、目标 master 与两条路线的值。 *)
firstDifferenceRecord[data_Association] := Module[{residual, position},
  residual = Lookup[data, "residual", Missing["NotCompared"]];
  If[! MatrixQ[residual], Return[Missing["NotCompared"]]];
  position = FirstCase[
    Position[
      residual,
      value_ /; ! ListQ[value] && ! TrueQ[value === 0],
      {2},
      1,
      Heads -> False
    ],
    {row_Integer, column_Integer} :> {row, column},
    Missing["NoDifference"]
  ];
  If[Head[position] === Missing, Return[position]];
  <|
    "position" -> position,
    "sourceMaster" -> masters[[position[[1]]]],
    "targetMaster" -> masters[[position[[2]]]],
    "routeValue" -> data["routeMatrix"][[Sequence @@ position]],
    "directValue" -> data["directMatrix"][[Sequence @@ position]],
    "residual" -> residual[[Sequence @@ position]]
  |>
];

(* 按全局 master offsets 汇总残差，区分 massive 与 massless contact 所在的 sector 块。 *)
sectorBlockDifferenceCounts[data_Association] := Module[
  {residual, offsets, dimensions},
  residual = Lookup[data, "residual", Missing["NotCompared"]];
  If[! MatrixQ[residual], Return[Missing["NotCompared"]]];
  offsets = madDE["masterSectorOffsets"];
  dimensions = AssociationThread[madDE["sectorOrder"] -> madDE["sectorDimensions"]];
  Association@Flatten@Table[
    With[
      {sourceStart = offsets[sourceKey], targetStart = offsets[targetKey],
       sourceDimension = dimensions[sourceKey], targetDimension = dimensions[targetKey]},
      (sourceKey <> "->" <> targetKey) -> Count[
        Flatten@residual[[
          sourceStart ;; sourceStart + sourceDimension - 1,
          targetStart ;; targetStart + targetDimension - 1
        ]],
        value_ /; ! TrueQ[value === 0]
      ]
    ],
    {sourceKey, madDE["sectorOrder"]},
    {targetKey, madDE["sectorOrder"]}
  ]
];

checks = <|
  "madContext" -> MSContextQ[madContext],
  "dsibpContext" -> (Lookup[dsibpContext, "status", None] === "initialized"),
  "sectorOrder" -> (
    madContext["sectorOrder"] === {"11", "01", "10", "00"} &&
      Lookup[dsibpContext["sectors"], "sectorKey"] === {"11", "01", "10", "00"}
  ),
  "masterCount" -> (Length[masters] === 15),
  "masterAdapter" -> And @@ MapThread[
    MSFromDSIBPJ[Inactive[dSIBP`J] @@ List @@ #1, madContext] === #2 &,
    {dsibpMasters, masters}
  ],
  "derivativeVariables" -> (variablesToCheck === {k1, k2, k3, sE1, sE2}),
  "allReductionsClosed" -> And @@ (Lookup[#, "failures", {1}] === {} & /@ Values[routeData]),
  "allMatrices15" -> And @@ (
    Dimensions[Lookup[#, "routeMatrix", {}]] === {15, 15} & /@ Values[routeData]
  ),
  "allResidualsZero" -> And @@ (
    Lookup[#, "nonzeroDifferenceCount", 1] === 0 & /@ Values[routeData]
  )
|>;

failed = Keys@Select[checks, Not@TrueQ[#] &];
Print[InputForm[<|
  "passed" -> Count[Values[checks], True],
  "total" -> Length[checks],
  "failed" -> failed,
  "numericRules" -> numericRules,
  "madSectorNormalizations" -> AssociationThread[
    madContext["sectorOrder"],
    Lookup[madContext["sectors"], "normalization"]
  ],
  "dsibpSectorPrefactors" -> AssociationThread[
    Lookup[dsibpContext["sectors"], "sectorKey"],
    dSIBP`Private`materializeSectorPrefactor018 /@
      Lookup[dsibpContext["sectors"], "sectorPrefactorData"]
  ],
  "prefactorDiagnostic" -> <|
    "masterIndex" -> diagnosticMasterIndex,
    "publicMaster" -> diagnosticDSIBPMaster,
    "internalMaster" -> diagnosticInternalMaster,
    "prefactor" -> diagnosticPrefactor,
    "prefactorLogDerivative" -> diagnosticPrefactorLogDerivative,
    "dsResult" -> diagnosticDerivative
  |>,
  "derivativeVariables" -> derivativeVariables,
  "variablesChecked" -> variablesToCheck,
  "differenceCounts" -> Map[Lookup[#, "nonzeroDifferenceCount"] &, routeData],
  "firstDifferenceRecords" -> Map[firstDifferenceRecord, routeData],
  "sectorBlockDifferenceCounts" -> Map[sectorBlockDifferenceCounts, routeData],
  "routeFailures" -> Map[Lookup[#, "failures"] &, routeData],
  "checks" -> checks
|>]];

Exit[If[failed === {}, 0, 1]];
