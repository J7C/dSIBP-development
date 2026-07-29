(* ::Package:: *)

(***
文件：check_core.wls
用途：检查 MadStree 第一阶段的加载、正阶 convention、sector/master、contact shift 与 dlog 维数。
运行：wolframscript -file package-MadStree/test/check_core.wls
***)

(* ::Chapter:: *)
(*加载与检查工具*)

packageRoot = DirectoryName[DirectoryName[$InputFileName]];
AppendTo[$Path, FileNameJoin[{packageRoot, "Kernel"}]];
Needs["MadStree`"];

checks = <||>;
record[name_, value_] := AssociateTo[checks, name -> TrueQ[value]];


(* ::Chapter:: *)
(*单条 massless full edge*)

masslessSpec = <|
  "vertices" -> {
    <|"id" -> v1, "energy" -> k1, "timePower" -> a1|>,
    <|"id" -> v2, "energy" -> k2, "timePower" -> a2|>
  },
  "lines" -> {
    <|"id" -> e1, "type" -> "masslessFull", "endpoints" -> {v1, v2},
      "momentum" -> q, "skType" -> "++", "nu" -> 1/2|>
  }
|>;

masslessContext = MSInitTree[masslessSpec];
record["masslessContext", MSContextQ[masslessContext]];
record["deterministicContext", MSInitTree[masslessSpec]["masterDigest"] === masslessContext["masterDigest"]];
record["positiveNuDefault", masslessContext["lines"][[1, "hankelOrder"]] === 1/2];
record["paperFormulaNu", masslessContext["lines"][[1, "formulaNu"]] === -1/2];
record["sectorCount", Length[MSSectors[masslessContext]] === 2];
record["topSharedSlot", MSSectors[masslessContext][[1, "slotCount"]] === 1];
record["topMasterCount", MSSectors[masslessContext][[1, "masterCount"]] === 2];
record["subMasterCount", MSSectors[masslessContext][[2, "masterCount"]] === 1];

masslessContacts = MSContactMaps[masslessContext, "top"];
record["R0Shift", masslessContacts[[1, "R0TargetShift"]] === {-1}];
record["R1Shifts", Sort[Values[masslessContacts[[1, "R1TargetShiftsByComponent"]]]] === {{0}, {0}}];
record["endpointWeights",
  masslessContacts[[1, "matricesByComponent"]][1] === {{0}, {-2}} &&
  masslessContacts[[1, "matricesByComponent"]][2] === {{0}, {2}}
];

masslessDE = MSDLogDE[masslessContext];
record["masslessDEDimension", masslessDE["matrixDimension"] === {3, 3}];
record["masslessMasterDimension", masslessDE["masterCount"] === 3];
record["masslessDLog", masslessDE["dlogStatus"] === "certifiedByFormulaChecks"];
record["masslessDLogResidual", masslessDE["dlogResidual"] === ConstantArray[0, {3, 3}]];
record["masslessOffsets", Values[masslessDE["masterSectorOffsets"]] === {1, 3}];


(* ::Chapter:: *)
(*单条 massive full edge*)

massiveSpec = <|
  "vertices" -> {
    <|"id" -> u, "energy" -> p1, "timePower" -> b1|>,
    <|"id" -> v, "energy" -> p2, "timePower" -> b2|>
  },
  "lines" -> {
    <|"id" -> m1, "type" -> "massiveFull", "endpoints" -> {u, v},
      "momentum" -> x, "skType" -> "++", "nu" -> nu|>
  }
|>;

massiveContext = MSInitTree[massiveSpec];
massiveContacts = MSContactMaps[massiveContext, "top"];
record["massiveTopMasters", MSSectors[massiveContext][[1, "masterCount"]] === 4];
record["massiveSubMasters", MSSectors[massiveContext][[2, "masterCount"]] === 1];
record["massiveContactComplement",
  massiveContacts[[1, "matricesByComponent"]][1] === {{0}, {-1}, {1}, {0}} &&
  massiveContacts[[1, "matricesByComponent"]][2] === {{0}, {1}, {-1}, {0}}
];
record["massiveR1Shift", And @@ (Values[massiveContacts[[1, "R1TargetShiftsByComponent"]]] === {{0}, {0}})];


(* ::Section:: *)
(*2401 Eq. (3.68) 的已保存 4x1 tree 参考*)

referenceContext = MSInitTree[
  <|
    "vertices" -> {
      <|"id" -> r1, "energy" -> k12, "timePower" -> v0|>,
      <|"id" -> r2, "energy" -> k34, "timePower" -> v0|>
    },
    "lines" -> {
      <|"id" -> re, "type" -> "massiveFull", "endpoints" -> {r1, r2},
        "momentum" -> ks, "skType" -> "++", "nu" -> v1|>
    }
  |>,
  NuConvention -> "Negative"
];
referenceActual = MSDLogDE[referenceContext]["contactBlocks"][[1, "matrix"]];
referenceExpected = {
  {(I/2) (Log[k12 - ks] - Log[k12 + ks]) + (I/2) (Log[k34 - ks] - Log[k34 + ks])},
  {(Log[k12 - ks] + Log[k12 + ks] - Log[k34 - ks] - Log[k34 + ks])/2},
  {(-Log[k12 - ks] - Log[k12 + ks] + Log[k34 - ks] + Log[k34 + ks])/2},
  {(I/2) (Log[k12 - ks] - Log[k12 + ks]) + (I/2) (Log[k34 - ks] - Log[k34 + ks])}
};
record["Eq368Reference", And @@ Flatten[Map[PossibleZeroQ, Simplify[referenceActual - referenceExpected], {2}]]];


(* ::Section:: *)
(*Mixed 三顶点链*)

mixedContext = MSInitTree[<|
  "vertices" -> {
    <|"id" -> t1, "energy" -> eA, "timePower" -> cA|>,
    <|"id" -> t2, "energy" -> eB, "timePower" -> cB|>,
    <|"id" -> t3, "energy" -> eC, "timePower" -> cC|>
  },
  "lines" -> {
    <|"id" -> tm, "type" -> "massiveFull", "endpoints" -> {t1, t2}, "momentum" -> km, "nu" -> mu|>,
    <|"id" -> tz, "type" -> "masslessFull", "endpoints" -> {t2, t3}, "momentum" -> kz, "nu" -> 1/2|>
  }
|>];
mixedDE = MSDLogDE[mixedContext];
record["mixedSectorCount", Length[MSSectors[mixedContext]] === 4];
record["mixedDimensions", Lookup[MSSectors[mixedContext], "masterCount"] === {8, 2, 4, 1}];
record["mixedDEDimension", mixedDE["matrixDimension"] === {15, 15} && mixedDE["masterCount"] === 15];
record["mixedDLog", mixedDE["dlogStatus"] === "certifiedByFormulaChecks"];

mixedTopMatrices = MSFormulaMatrices[mixedContext, "top"];
record["sharedMasslessTwoEndpoints",
  ! TrueQ[Simplify[
    mixedTopMatrices["components"][[2, "M0"]] - mixedTopMatrices["components"][[3, "M0"]]
  ] === ConstantArray[0, {8, 8}]]
];


(* ::Section:: *)
(*Mixed 三顶点的冗余 massless h 表示*)

mixedRedundantContext = MSInitTree[<|
  "vertices" -> {
    <|"id" -> t1, "energy" -> eA, "timePower" -> cA|>,
    <|"id" -> t2, "energy" -> eB, "timePower" -> cB|>,
    <|"id" -> t3, "energy" -> eC, "timePower" -> cC|>
  },
  "lines" -> {
    <|"id" -> tm, "type" -> "massiveFull", "endpoints" -> {t1, t2}, "momentum" -> km, "nu" -> mu|>,
    <|"id" -> tz, "type" -> "masslessFull", "endpoints" -> {t2, t3}, "momentum" -> kz, "nu" -> 1/2,
      "masslessRepresentation" -> "RedundantH"|>
  }
|>];
mixedRedundantDE = MSDLogDE[mixedRedundantContext];
record["redundantMasslessContext", MSContextQ[mixedRedundantContext]];
record["redundantMasslessMetadata",
  mixedRedundantContext["lines"][[2, "masslessRepresentation"]] === "RedundantH" &&
    mixedRedundantContext["lines"][[2, "functionSystem"]] === "h"
];
record["redundantMasslessDimensions",
  Lookup[MSSectors[mixedRedundantContext], "masterCount"] === {16, 4, 4, 1}
];
record["redundantMasslessDLog",
  mixedRedundantDE["matrixDimension"] === {25, 25} &&
    mixedRedundantDE["dlogStatus"] === "certifiedByFormulaChecks"
];
record["redundantMasslessNuGate",
  Head[Quiet@MSInitTree[<|
    "vertices" -> {
      <|"id" -> q1, "energy" -> x1, "timePower" -> 1|>,
      <|"id" -> q2, "energy" -> x2, "timePower" -> 1|>
    },
    "lines" -> {
      <|"id" -> qz, "type" -> "masslessFull", "endpoints" -> {q1, q2}, "momentum" -> q,
        "nu" -> 1/3, "masslessRepresentation" -> "RedundantH"|>
    }
  |>]] === Failure
];


(* ::Chapter:: *)
(*H/h 与递推*)

hRoundTrip = Simplify[
  MShToHMatrix[nu, z, massiveContext].MSHTohMatrix[nu, z, massiveContext]
];
record["HhRoundTrip", hRoundTrip === IdentityMatrix[2]];

hNegativeRoundTrip = Simplify[
  MShToHMatrix[nu, z, referenceContext].MSHTohMatrix[nu, z, referenceContext]
];
record["HhNegativeRoundTrip", hNegativeRoundTrip === IdentityMatrix[2]];
record["localContextRequired", Head[MSHTohMatrix[nu, z]] === Failure];

globalState = Array[state, 4];
globalHToh = MSConvertBasis[globalState, "H" -> "h", "top", {tauU, tauV}, massiveContext];
globalRoundTrip = MSConvertBasis[globalHToh, "h" -> "H", "top", {tauU, tauV}, massiveContext];
record["globalHhRoundTrip", Simplify[globalRoundTrip - globalState] === ConstantArray[0, 4]];

negativeGlobalState = Array[negativeState, 4];
negativeGlobalHToh = MSConvertBasis[
  negativeGlobalState, "H" -> "h", "top", {tau1, tau2}, referenceContext
];
negativeGlobalRoundTrip = MSConvertBasis[
  negativeGlobalHToh, "h" -> "H", "top", {tau1, tau2}, referenceContext
];
record[
  "globalNegativeHhRoundTrip",
  Simplify[negativeGlobalRoundTrip - negativeGlobalState] === ConstantArray[0, 4]
];
record[
  "globalConventionOverrideRejected",
  Head[Quiet[MSConvertBasis[
    negativeGlobalState,
    "H" -> "h",
    "top",
    {tau1, tau2},
    referenceContext,
    NuConvention -> "Positive"
  ], MSConvertBasis::unsupported]] === Failure
];

legacyIntegral = MSIntegral["top", {1, -1}, {0, 1}];
legacyJ = MSToLegacyJ[legacyIntegral, massiveContext];
record["legacyRoundTrip", MSFromLegacyJ[legacyJ, massiveContext] === legacyIntegral];
record["masslessLegacyFailsClosed", Head[MSToLegacyJ[MSIntegral["top", {0, 0}, {0}], masslessContext]] === Failure];

numericalWithoutBoundary = MSNumericalSystem[masslessDE];
record["numericalBoundaryRequired", numericalWithoutBoundary["status"] === "boundaryDataRequired"];

shifted = MSIntegral["top", {1, 0}, {0}];
step = MSRecurrenceStep[shifted, 1, masslessContext];
record["recurrenceStep", step["status"] === "reducedOneStep" && step["nearerShift"] === {0, 0}];
reduced = MSReduce[shifted, masslessContext];
record["recurrenceClosed", reduced["status"] === "reduced" && reduced["remainingShiftedIntegrals"] === {}];

If[! TrueQ[checks["massiveContactComplement"]],
  Print["massive C1 actual: ", InputForm[massiveContacts[[1, "matricesByComponent"]][1]]];
  Print["massive C2 actual: ", InputForm[massiveContacts[[1, "matricesByComponent"]][2]]]
];
If[! TrueQ[checks["mixedDimensions"]],
  Print["mixed sector keys: ", InputForm[Lookup[MSSectors[mixedContext], "key"]]];
  Print["mixed dimensions actual: ", InputForm[Lookup[MSSectors[mixedContext], "masterCount"]]]
];
If[! TrueQ[checks["recurrenceClosed"]], Print["reduction actual: ", InputForm[reduced]]];


(* ::Chapter:: *)
(*汇总*)

passed = Count[Values[checks], True];
total = Length[checks];
Print["MadStree core checks: ", passed, "/", total];
KeyValueMap[Print[#1, ": ", #2] &, checks];

If[passed =!= total, Exit[1]];
