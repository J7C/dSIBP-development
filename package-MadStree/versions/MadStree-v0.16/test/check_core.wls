(* ::Package:: *)

(***
File: check_core.wls
Purpose: Checks the first-stage MadStree loading, positive-order convention, sectors/masters, contact shifts and dlog dimensions.
Run: wolframscript -file package-MadStree/versions/MadStree-v0.16/test/check_core.wls
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
    <|"id" -> v1, "externalLegEnergy" -> k1, "timePower" -> a1, "vertexType" -> "+"|>,
    <|"id" -> v2, "externalLegEnergy" -> k2, "timePower" -> a2, "vertexType" -> "+"|>
  },
  "lines" -> {
    <|"type" -> "massless", "endpoints" -> {v1, v2},
      "momentum" -> q, "nu" -> 1/2|>
  }
|>;

masslessContext = MSInitTree[masslessSpec];
extraRootField = MSInitTree[Append[masslessSpec, "unexpectedField" -> True]];
extraLineSpec = Join[
  masslessSpec,
  <|"lines" -> {Append[First[masslessSpec["lines"]], "unexpectedField" -> True]}|>
];
extraLineField = MSInitTree[extraLineSpec];
missingLineField = MSInitTree[Join[
  masslessSpec,
  <|"lines" -> {KeyDrop[First[masslessSpec["lines"]], "momentum"]}|>
]];
masslessTopKey = First[masslessContext["sectorOrder"]];
record["masslessContext", MSContextQ[masslessContext]];
record["requiredTreeInputFields",
  MSContextQ[extraRootField] && MSContextQ[extraLineField] &&
  MatchQ[missingLineField, Failure["InvalidTreeInputFields", _Association]]
];
record["deterministicContext", MSInitTree[masslessSpec]["masterDigest"] === masslessContext["masterDigest"]];
record["positiveNuDefault", masslessContext["lines"][[1, "hankelOrder"]] === 1/2];
record["paperFormulaNu", masslessContext["lines"][[1, "formulaNu"]] === -1/2];
record["sectorCount", Length[MSSectors[masslessContext]] === 2];
record["topSharedSlot", MSSectors[masslessContext][[1, "slotCount"]] === 1];
record["topMasterCount", MSSectors[masslessContext][[1, "masterCount"]] === 2];
record["subMasterCount", MSSectors[masslessContext][[2, "masterCount"]] === 1];


(* ::Section:: *)
(* v0.16 public topology schema *)

numericIdContext = MSInitTree[<|
  "vertices" -> {
    <|"id" -> 1, "externalLegEnergy" -> x1, "timePower" -> b1, "vertexType" -> "+"|>,
    <|"id" -> 2, "externalLegEnergy" -> x2, "timePower" -> b2, "vertexType" -> "-"|>
  },
  "lines" -> {
    <|"type" -> "massless", "endpoints" -> {1, 2}, "momentum" -> p12|>
  }
|>];
omittedEnergyContext = MSInitTree[<|
  "vertices" -> {
    <|"id" -> 1, "timePower" -> b1, "vertexType" -> "+"|>,
    <|"id" -> 2, "externalLegEnergy" -> x2, "timePower" -> b2,
      "vertexType" -> "+"|>
  },
  "lines" -> {
    <|"type" -> "massless", "endpoints" -> {1, 2}, "momentum" -> p12|>
  }
|>];
zeroEnergyContext = MSInitTree[<|
  "vertices" -> {
    <|"id" -> 1, "externalLegEnergy" -> 0, "timePower" -> b1,
      "vertexType" -> "+"|>,
    <|"id" -> 2, "externalLegEnergy" -> x2, "timePower" -> b2,
      "vertexType" -> "+"|>
  },
  "lines" -> {
    <|"type" -> "massless", "endpoints" -> {1, 2}, "momentum" -> p12|>
  }
|>];
plusPlusContext = MSInitTree[<|
  "vertices" -> {
    <|"id" -> 1, "externalLegEnergy" -> x1, "timePower" -> b1, "vertexType" -> "+"|>,
    <|"id" -> 2, "externalLegEnergy" -> x2, "timePower" -> b2, "vertexType" -> "+"|>
  },
  "lines" -> {<|"type" -> "massless", "endpoints" -> {1, 2}, "momentum" -> p12|>}
|>];
minusMinusContext = MSInitTree[<|
  "vertices" -> {
    <|"id" -> 1, "externalLegEnergy" -> x1, "timePower" -> b1, "vertexType" -> "-"|>,
    <|"id" -> 2, "externalLegEnergy" -> x2, "timePower" -> b2, "vertexType" -> "-"|>
  },
  "lines" -> {<|"type" -> "massless", "endpoints" -> {1, 2}, "momentum" -> p12|>}
|>];
minusPlusContext = MSInitTree[<|
  "vertices" -> {
    <|"id" -> 1, "externalLegEnergy" -> x1, "timePower" -> b1, "vertexType" -> "-"|>,
    <|"id" -> 2, "externalLegEnergy" -> x2, "timePower" -> b2, "vertexType" -> "+"|>
  },
  "lines" -> {<|"type" -> "massless", "endpoints" -> {1, 2}, "momentum" -> p12|>}
|>];
oldVertexField = Quiet@MSInitTree[<|
  "vertices" -> {<|"id" -> 1, "externalLegEnergy" -> x1, "timePower" -> b1, "phaseSign" -> 1|>},
  "lines" -> {}
|>];
oldLineFields = Quiet@MSInitTree[<|
  "vertices" -> {
    <|"id" -> 1, "externalLegEnergy" -> x1, "timePower" -> b1, "vertexType" -> "+"|>,
    <|"id" -> 2, "externalLegEnergy" -> x2, "timePower" -> b2, "vertexType" -> "+"|>
  },
  "lines" -> {
    <|"type" -> "massless", "endpoints" -> {1, 2}, "momentum" -> p12,
      "skType" -> "--", "sigma" -> -1, "phaseSigns" -> {-1, -1}|>
  }
|>];
oldLineType = Quiet@MSInitTree[<|
  "vertices" -> {
    <|"id" -> 1, "externalLegEnergy" -> x1, "timePower" -> b1, "vertexType" -> "+"|>,
    <|"id" -> 2, "externalLegEnergy" -> x2, "timePower" -> b2, "vertexType" -> "+"|>
  },
  "lines" -> {<|"type" -> "masslessFull", "endpoints" -> {1, 2}, "momentum" -> p12|>}
|>];
record["numericVertexIds", Lookup[numericIdContext["vertices"], "id"] === {1, 2}];
record["automaticLineIds", Lookup[numericIdContext["lines"], "id"] === {1}];
record["omittedAndZeroExternalEnergyEquivalent",
  omittedEnergyContext["masterDigest"] === zeroEnergyContext["masterDigest"] &&
    MSDLogDE[omittedEnergyContext] === MSDLogDE[zeroEnergyContext]
];
record["auxiliaryExternalEnergyRetainedAnalytically",
  TrueQ[omittedEnergyContext["vertices"][[1, "auxiliaryExternalLegEnergyQ"]]] &&
    omittedEnergyContext["vertices"][[1, "externalLegEnergyTarget"]] === 0 &&
    ! FreeQ[
      MSDLogDE[omittedEnergyContext]["omegaPotential"],
      omittedEnergyContext["vertices"][[1, "externalLegEnergy"]]
    ]
];
record["auxiliaryExternalEnergyNotUserRequired",
  FreeQ[
    MadStree`Private`msBoundaryRequiredSymbols[omittedEnergyContext],
    omittedEnergyContext["vertices"][[1, "externalLegEnergy"]]
  ]
];
record["plusMinusDerivedCross",
  Lookup[First[numericIdContext["lines"]], {"type", "contourType", "endpointSigns"}] ===
    {"masslessCross", "+-", {1, -1}}
];
record["minusPlusDerivedCross", Lookup[First[minusPlusContext["lines"]], "contourType"] === "-+"];
record[
  "vertexExternalPhaseSigns",
  Lookup[plusPlusContext["vertices"], "vertexSign"] === {-1, -1} &&
    Lookup[minusMinusContext["vertices"], "vertexSign"] === {1, 1} &&
    Lookup[plusPlusContext["energyCoordinates"], "dampingDefinition"] === {-I x1, -I x2} &&
    Lookup[minusMinusContext["energyCoordinates"], "dampingDefinition"] === {I x1, I x2}
];
record["plusPlusDerivedFull",
  Lookup[First[plusPlusContext["lines"]], {"type", "contourType", "fullContourSign"}] ===
    {"masslessFull", "++", 1}
];
record["minusMinusDerivedFull",
  Lookup[First[minusMinusContext["lines"]], {"type", "contourType", "fullContourSign"}] ===
    {"masslessFull", "--", -1}
];
record["requiredFieldsAndIgnoredExtras",
  Head[oldVertexField] === Failure && MSContextQ[oldLineFields] && Head[oldLineType] === Failure &&
  Lookup[First[oldLineFields["lines"]], {"type", "contourType", "fullContourSign"}] ===
    {"masslessFull", "++", 1}
];

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
    <|"id" -> u, "externalLegEnergy" -> p1, "timePower" -> b1, "vertexType" -> "+"|>,
    <|"id" -> v, "externalLegEnergy" -> p2, "timePower" -> b2, "vertexType" -> "+"|>
  },
  "lines" -> {
    <|"type" -> "massive", "endpoints" -> {u, v},
      "momentum" -> x, "nu" -> nu|>
  }
|>;

massiveContext = MSInitTree[massiveSpec];
massiveTopKey = First[massiveContext["sectorOrder"]];
massiveContacts = MSContactMaps[massiveContext, massiveTopKey];
minusMassiveContext = MSInitTree[<|
  "vertices" -> {
    <|"id" -> u, "externalLegEnergy" -> p1, "timePower" -> b1, "vertexType" -> "-"|>,
    <|"id" -> v, "externalLegEnergy" -> p2, "timePower" -> b2, "vertexType" -> "-"|>
  },
  "lines" -> {
    <|"type" -> "massive", "endpoints" -> {u, v}, "momentum" -> x, "nu" -> nu|>
  }
|>];
record["massiveTopMasters", MSSectors[massiveContext][[1, "masterCount"]] === 4];
record["massiveSubMasters", MSSectors[massiveContext][[2, "masterCount"]] === 1];
record["massiveContactComplement",
  massiveContacts[[1, "matricesByComponent"]][1] === {{0}, {-1}, {1}, {0}} &&
  massiveContacts[[1, "matricesByComponent"]][2] === {{0}, {1}, {-1}, {0}}
];
record["massiveR1Shift", And @@ (Values[massiveContacts[[1, "R1TargetShiftsByComponent"]]] === {{0}, {0}})];


(* ::Section:: *)
(* 不依赖 dSIBP 的外腿能量导数与 recurrence/dlog exact identity *)

(* 对每个有序 master 直接提高所属 component 的 (-tau) 幂，再用 MSReduce 得到导数矩阵。 *)
msExternalLegEnergyDerivativeMatrix[context_?MSContextQ, vertexId_] := Module[
  {vertex, masters, sectors, derivativeRows},
  vertex = SelectFirst[context["vertices"], #["id"] === vertexId &, Missing["UnknownVertex"]];
  If[Head[vertex] === Missing, Return[Failure["UnknownVertex", <|"vertexId" -> vertexId|>]]];
  masters = Lookup[MSMasterIntegrals[context], "integral"];
  sectors = AssociationThread[Lookup[MSSectors[context], "sectorKey"] -> MSSectors[context]];
  derivativeRows = Map[
    Function[integral,
      integral /. MSIntegral[sectorKey_, shifts_List, bits_List] :> Module[
        {sector, componentPosition, shiftedIntegral, reduction},
        sector = sectors[sectorKey];
        componentPosition = First@FirstPosition[
          sector["vertexComponents"],
          componentVertices_List /; MemberQ[componentVertices, vertexId]
        ];
        shiftedIntegral = MSIntegral[
          sectorKey,
          ReplacePart[shifts, componentPosition -> shifts[[componentPosition]] + 1],
          bits
        ];
        reduction = MSReduce[-I vertex["vertexSign"] shiftedIntegral, context];
        If[
          Lookup[reduction, "status", None] === "reduced" &&
            TrueQ[Lookup[reduction, "nonMasterResidual", Missing["Absent"]] === 0] &&
            Lookup[reduction, "remainingShiftedIntegrals", {Missing["Absent"]}] === {},
          reduction["coefficientVector"],
          Failure[
            "ExternalLegEnergyDerivativeReductionFailed",
            <|"vertexId" -> vertexId, "integral" -> integral, "reduction" -> reduction|>
          ]
        ]
      ]
    ],
    masters
  ];
  If[FreeQ[derivativeRows, _Failure], derivativeRows, FirstCase[derivativeRows, _Failure, $Failed]]
];

plusDerivativeMatrices = Association@Table[
  vertexId -> msExternalLegEnergyDerivativeMatrix[massiveContext, vertexId],
  {vertexId, {u, v}}
];
minusDerivativeMatrices = Association@Table[
  vertexId -> msExternalLegEnergyDerivativeMatrix[minusMassiveContext, vertexId],
  {vertexId, {u, v}}
];
plusDLogPotential = MSDLogDE[massiveContext]["omegaPotential"];
minusDLogPotential = MSDLogDE[minusMassiveContext]["omegaPotential"];
record["massivePlusRecurrenceDLogDerivativeIdentity",
  And @@ Table[
    Simplify[plusDerivativeMatrices[vertexId] - D[plusDLogPotential, If[vertexId === u, p1, p2]]] ===
      ConstantArray[0, {5, 5}],
    {vertexId, {u, v}}
  ]
];
record["massiveMinusRecurrenceDLogDerivativeIdentity",
  And @@ Table[
    Simplify[minusDerivativeMatrices[vertexId] - D[minusDLogPotential, If[vertexId === u, p1, p2]]] ===
      ConstantArray[0, {5, 5}],
    {vertexId, {u, v}}
  ]
];


(* ::Section:: *)
(* Saved 4x1 tree reference of 2401 Eq. (3.68). The paper uses Exp[+I k tau],
   so the v0.16 public convention maps a "+" vertex through externalLegEnergy=-k. *)

referenceContext = MSInitTree[
  <|
    "vertices" -> {
      <|"id" -> r1, "externalLegEnergy" -> e12, "timePower" -> v0, "vertexType" -> "+"|>,
      <|"id" -> r2, "externalLegEnergy" -> e34, "timePower" -> v0, "vertexType" -> "+"|>
    },
    "lines" -> {
      <|"type" -> "massive", "endpoints" -> {r1, r2},
        "momentum" -> ks, "nu" -> v1|>
    }
  |>,
  NuConvention -> "Negative"
];
referenceTopKey = First[referenceContext["sectorOrder"]];
referenceActual = MSDLogDE[referenceContext]["contactBlocks"][[1, "matrix"]] /.
  {e12 -> -k12, e34 -> -k34};
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
    <|"id" -> t1, "externalLegEnergy" -> eA, "timePower" -> cA, "vertexType" -> "+"|>,
    <|"id" -> t2, "externalLegEnergy" -> eB, "timePower" -> cB, "vertexType" -> "+"|>,
    <|"id" -> t3, "externalLegEnergy" -> eC, "timePower" -> cC, "vertexType" -> "+"|>
  },
  "lines" -> {
    <|"type" -> "massive", "endpoints" -> {t1, t2}, "momentum" -> km, "nu" -> mu|>,
    <|"type" -> "massless", "endpoints" -> {t2, t3}, "momentum" -> kz, "nu" -> 1/2|>
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
    "rootLineOrder" -> {1, 2},
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
    <|"id" -> t1, "externalLegEnergy" -> eA, "timePower" -> cA, "vertexType" -> "+"|>,
    <|"id" -> t2, "externalLegEnergy" -> eB, "timePower" -> cB, "vertexType" -> "+"|>,
    <|"id" -> t3, "externalLegEnergy" -> eC, "timePower" -> cC, "vertexType" -> "+"|>
  },
  "lines" -> {
    <|"type" -> "massive", "endpoints" -> {t1, t2}, "momentum" -> km, "nu" -> mu|>,
    <|"type" -> "massless", "endpoints" -> {t2, t3}, "momentum" -> kz, "nu" -> 1/2,
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
      <|"id" -> q1, "externalLegEnergy" -> x1, "timePower" -> 1, "vertexType" -> "+"|>,
      <|"id" -> q2, "externalLegEnergy" -> x2, "timePower" -> 1, "vertexType" -> "+"|>
    },
    "lines" -> {
      <|"type" -> "massless", "endpoints" -> {q1, q2}, "momentum" -> q,
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
