(* ::Package:: *)

(***
File: check_core.wls
Purpose: Checks the first-stage MadStree loading, positive-order convention, sectors/masters, contact shifts and dlog dimensions.
Run: wolframscript -file package-MadStree/test/check_core.wls
***)

(* ::Chapter:: *)
(* Loading and check utilities *)

Get[FileNameJoin[{DirectoryName[$InputFileName], "_harness.wls"}]];
packageRoot = msTestLoadKernel[];

checks = <||>;
record[name_, value_] := AssociateTo[checks, name -> TrueQ[value]];


(* ::Chapter:: *)
(* Single massless full edge *)

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
masslessTopKey = First[masslessContext["sectorOrder"]];
record["masslessContext", MSContextQ[masslessContext]];
record["deterministicContext", MSInitTree[masslessSpec]["masterDigest"] === masslessContext["masterDigest"]];
record["positiveNuDefault", masslessContext["lines"][[1, "hankelOrder"]] === 1/2];
record["paperFormulaNu", masslessContext["lines"][[1, "formulaNu"]] === -1/2];
record["sectorCount", Length[MSSectors[masslessContext]] === 2];
record["topSharedSlot", MSSectors[masslessContext][[1, "slotCount"]] === 1];
record["topMasterCount", MSSectors[masslessContext][[1, "masterCount"]] === 2];
record["subMasterCount", MSSectors[masslessContext][[2, "masterCount"]] === 1];

masslessContacts = MSContactMaps[masslessContext, masslessTopKey];
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
(* Single massive full edge *)

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
massiveTopKey = First[massiveContext["sectorOrder"]];
massiveContacts = MSContactMaps[massiveContext, massiveTopKey];
record["massiveTopMasters", MSSectors[massiveContext][[1, "masterCount"]] === 4];
record["massiveSubMasters", MSSectors[massiveContext][[2, "masterCount"]] === 1];
record["massiveContactComplement",
  massiveContacts[[1, "matricesByComponent"]][1] === {{0}, {-1}, {1}, {0}} &&
  massiveContacts[[1, "matricesByComponent"]][2] === {{0}, {1}, {-1}, {0}}
];
record["massiveR1Shift", And @@ (Values[massiveContacts[[1, "R1TargetShiftsByComponent"]]] === {{0}, {0}})];


(* ::Section:: *)
(* Saved 4x1 tree reference of 2401 Eq. (3.68) *)

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
referenceTopKey = First[referenceContext["sectorOrder"]];
referenceActual = MSDLogDE[referenceContext]["contactBlocks"][[1, "matrix"]];
referenceExpected = {
  {(I/2) (Log[k12 - ks] - Log[k12 + ks]) + (I/2) (Log[k34 - ks] - Log[k34 + ks])},
  {(Log[k12 - ks] + Log[k12 + ks] - Log[k34 - ks] - Log[k34 + ks])/2},
  {(-Log[k12 - ks] - Log[k12 + ks] + Log[k34 - ks] + Log[k34 + ks])/2},
  {(I/2) (Log[k12 - ks] - Log[k12 + ks]) + (I/2) (Log[k34 - ks] - Log[k34 + ks])}
};
record["Eq368Reference", And @@ Flatten[Map[PossibleZeroQ, Simplify[referenceActual - referenceExpected], {2}]]];


(* ::Section:: *)
(* Mixed three-vertex chain *)

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
mixedTopKey = First[mixedContext["sectorOrder"]];
mixedDE = MSDLogDE[mixedContext];
record["mixedSectorCount", Length[MSSectors[mixedContext]] === 4];
record["mixedDimensions", Lookup[MSSectors[mixedContext], "masterCount"] === {8, 2, 4, 1}];
record["mixedDEDimension", mixedDE["matrixDimension"] === {15, 15} && mixedDE["masterCount"] === 15];
record["mixedDLog", mixedDE["dlogStatus"] === "certifiedByFormulaChecks"];
record["sectorKeysUnique", DuplicateFreeQ[Lookup[MSSectors[mixedContext], "sectorKey"]]];
record["sectorBitStringOrder",
  Lookup[MSSectors[mixedContext], "sectorKey"] === {"11", "01", "10", "00"}
];
record["sectorKeySchema",
  mixedContext["sectorKeySchema"] === <|
    "type" -> "rootPropagatorBitString",
    "rootLineOrder" -> {tm, tz},
    "width" -> 2,
    "contractedBit" -> "0",
    "uncontractedBit" -> "1",
    "storageType" -> "String"
  |>
];
record["globalMasterIntegralsUnique", DuplicateFreeQ[Lookup[MSMasterIntegrals[mixedContext], "integral"]]];
record["sectorIdentityCertificate",
  mixedContext["sectorIdentityCertificate", "status"] === "certified" &&
    And @@ Values[mixedContext["sectorIdentityCertificate", "checks"]]
];
record["sameLocalBitsRemainSectorDistinct",
  MSIntegral["01", {0, 0}, {0}] =!= MSIntegral["10", {0, 0}, {0}]
];
record["masterDigestUsesFullIntegralOrder",
  mixedContext["masterDigest"] === IntegerString[
    Hash[Lookup[MSMasterIntegrals[mixedContext], "integral"], "SHA256"], 16, 64
  ]
];

mixedTopMatrices = MSFormulaMatrices[mixedContext, mixedTopKey];
record["sharedMasslessTwoEndpoints",
  ! TrueQ[Simplify[
    mixedTopMatrices["components"][[2, "M0"]] - mixedTopMatrices["components"][[3, "M0"]]
  ] === ConstantArray[0, {8, 8}]]
];


(* ::Section:: *)
(* Redundant massless h representation of the mixed three-vertex graph *)

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
(* H/h and recurrence *)

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
globalHToh = MSConvertBasis[globalState, "H" -> "h", massiveTopKey, {tauU, tauV}, massiveContext];
globalRoundTrip = MSConvertBasis[globalHToh, "h" -> "H", massiveTopKey, {tauU, tauV}, massiveContext];
record["globalHhRoundTrip", Simplify[globalRoundTrip - globalState] === ConstantArray[0, 4]];

negativeGlobalState = Array[negativeState, 4];
negativeGlobalHToh = MSConvertBasis[
  negativeGlobalState, "H" -> "h", referenceTopKey, {tau1, tau2}, referenceContext
];
negativeGlobalRoundTrip = MSConvertBasis[
  negativeGlobalHToh, "h" -> "H", referenceTopKey, {tau1, tau2}, referenceContext
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
    referenceTopKey,
    {tau1, tau2},
    referenceContext,
    NuConvention -> "Positive"
  ], MSConvertBasis::unsupported]] === Failure
];

legacyIntegral = MSIntegral[massiveTopKey, {1, -1}, {0, 1}];
legacyJ = MSToLegacyJ[legacyIntegral, massiveContext];
record["legacyRoundTrip", MSFromLegacyJ[legacyJ, massiveContext] === legacyIntegral];
record["masslessLegacyFailsClosed", Head[MSToLegacyJ[MSIntegral[masslessTopKey, {0, 0}, {0}], masslessContext]] === Failure];

numericalWithoutBoundary = MSNumericalSystem[masslessDE];
record["numericalBoundaryRequired", numericalWithoutBoundary["status"] === "boundaryDataRequired"];

shifted = MSIntegral[masslessTopKey, {1, 0}, {0}];
step = MSRecurrenceStep[shifted, 1, masslessContext];
record["recurrenceStep", step["status"] === "reducedOneStep" && step["nearerShift"] === {0, 0}];
reduced = MSReduce[shifted, masslessContext];
record["recurrenceClosed", reduced["status"] === "reduced" && reduced["remainingShiftedIntegrals"] === {}];

If[! TrueQ[checks["massiveContactComplement"]],
  Print["massive C1 actual: ", InputForm[massiveContacts[[1, "matricesByComponent"]][1]]];
  Print["massive C2 actual: ", InputForm[massiveContacts[[1, "matricesByComponent"]][2]]]
];
If[! TrueQ[checks["Eq368Reference"]],
  Print["Eq. (3.68) actual: ", InputForm[referenceActual]];
  Print["Eq. (3.68) saved reference: ", InputForm[referenceExpected]]
];
If[! TrueQ[checks["mixedDimensions"]],
  Print["mixed sector keys: ", InputForm[Lookup[MSSectors[mixedContext], "key"]]];
  Print["mixed dimensions actual: ", InputForm[Lookup[MSSectors[mixedContext], "masterCount"]]]
];
If[! TrueQ[checks["recurrenceClosed"]], Print["reduction actual: ", InputForm[reduced]]];


(* ::Chapter:: *)
(* Summary *)

msTestSummary[checks, "MadStree core checks"];
