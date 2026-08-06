(* ::Package:: *)

(***
文件：Recurrence.wl
用途：构造 Eq. (3.65) contact maps，并用 (-tau)^A 公式直接执行逐步和完整迭代约化。
关键边界：contact 始终携带 target sector 与精确 aShift；不得先丢掉 shift 再猜 subsector master。
***)

(* ::Chapter:: *)
(*Contact 矩阵*)

msLineById[context_?MSContextQ, lineId_] := SelectFirst[
  context["lines"], #["id"] === lineId &, Missing["UnknownLine", lineId]
];

msTargetSectorForEvent[event_Association, context_?MSContextQ] := msSectorByKey[
  context,
  event["targetSector"]
];

msBitsIndexAssociation[states_List] := AssociationThread[
  ToString[#, InputForm] & /@ states,
  Range[Length[states]]
];

msSpectatorTargetBits[sourceSector_Association, targetSector_Association, sourceBits_List] := Module[
  {sourcePositionByKey, targetKeys},
  sourcePositionByKey = AssociationThread[
    ToString[#, InputForm] & /@ Lookup[sourceSector["slots"], "key"],
    Range[sourceSector["slotCount"]]
  ];
  targetKeys = If[targetSector["slots"] === {}, {}, Lookup[targetSector["slots"], "key"]];
  sourceBits[[sourcePositionByKey[ToString[#, InputForm]]]] & /@ targetKeys
];

msCanonicalTargetBits[targetSector_Association, rawBits_List] := Module[{row, imageRow, column},
  row = FirstPosition[targetSector["rawStateOrder"], rawBits, Missing["UnknownRawState"]];
  If[Head[row] === Missing, Return[row]];
  imageRow = targetSector["stateEmbedding"][[First[row]]];
  column = FirstPosition[imageRow, 1, Missing["ZeroQuotientState"]];
  If[Head[column] === Missing, column, targetSector["stateOrder"][[First[column]]]]
];

msEventEndpointIndex[line_Association, sourceSector_Association, componentPosition_Integer] := Module[
  {positions = sourceSector["rootToComponent"] /@ line["endpoints"]},
  First@FirstPosition[positions, componentPosition]
];


msEventAtomicCoefficient[
  line_Association,
  sourceSector_Association,
  sourceBits_List,
  componentPosition_Integer
] := Module[{endpointIndex, positions, endpointBits, sharedPosition, complementCoefficient},
  endpointIndex = msEventEndpointIndex[line, sourceSector, componentPosition];
  Switch[line["type"],
    "massiveFull",
      positions = (First@msSlotPositionByKey[sourceSector, {line["id"], #}] &) /@ {1, 2};
      endpointBits = sourceBits[[positions]];
      If[Total[endpointBits] =!= 1,
        0,
        If[endpointIndex === 1, (-1)^endpointBits[[2]], (-1)^endpointBits[[1]]]
      ],
    "masslessFull",
      If[
        line["masslessRepresentation"] === "RedundantH",
        positions = (First@msSlotPositionByKey[sourceSector, {line["id"], #}] &) /@ {1, 2};
        endpointBits = sourceBits[[positions]];
        complementCoefficient = If[
          Total[endpointBits] =!= 1,
          0,
          If[endpointIndex === 1, (-1)^endpointBits[[2]], (-1)^endpointBits[[1]]]
        ];
        2 I line["sigma"] complementCoefficient,
        sharedPosition = First@msSlotPositionByKey[sourceSector, {line["id"], "shared"}];
        If[sourceBits[[sharedPosition]] =!= 1, 0, If[endpointIndex === 1, -2, 2]]
      ],
    _, 0
  ]
];


msNormalizedEventAbsorption[
  sourceSector_Association,
  targetSector_Association,
  selectedLines_List
] := Simplify[
  sourceSector["normalization"]/targetSector["normalization"] Times @@ Lookup[selectedLines, "pinchNormalization"]
];


msEventContactMatrix[
  sourceSector_Association,
  targetSector_Association,
  event_Association,
  componentPosition_Integer,
  context_?MSContextQ
] := Module[
  {sourceStates, targetStates, targetIndex, selectedLines, matrix, targetBits, canonicalBits,
   column, coefficient, absorption},
  sourceStates = sourceSector["stateOrder"];
  targetStates = targetSector["stateOrder"];
  targetIndex = msBitsIndexAssociation[targetStates];
  selectedLines = msLineById[context, #] & /@ event["selectedLineIds"];
  matrix = ConstantArray[0, {Length[sourceStates], Length[targetStates]}];
  absorption = msNormalizedEventAbsorption[sourceSector, targetSector, selectedLines];
  Do[
    coefficient = event["thetaBundleCoefficient"] Times @@ (
      msEventAtomicCoefficient[#, sourceSector, sourceStates[[row]], componentPosition] & /@ selectedLines
    );
    If[! TrueQ[coefficient === 0],
      targetBits = msSpectatorTargetBits[sourceSector, targetSector, sourceStates[[row]]];
      canonicalBits = msCanonicalTargetBits[targetSector, targetBits];
      If[Head[canonicalBits] =!= Missing,
        column = targetIndex[ToString[canonicalBits, InputForm]];
        matrix[[row, column]] += Simplify[absorption coefficient]
      ]
    ],
    {row, Length[sourceStates]}
  ];
  matrix
];

msContactTargetShiftEvent[
  sourceSector_Association,
  targetSector_Association,
  sourceShift_List
] := Module[{shift, sourceComponentsInTarget},
  Map[
    Function[targetComponent,
      sourceComponentsInTarget = MapIndexed[
        If[Intersection[#1, targetComponent] =!= {}, First[#2], Nothing] &,
        sourceSector["vertexComponents"]
      ];
      shift = Total[sourceShift[[sourceComponentsInTarget]]];
      shift - (Length[sourceComponentsInTarget] - 1)
    ],
    targetSector["vertexComponents"]
  ]
];

msContactMapForEvent[sourceSector_Association, event_Association, context_?MSContextQ] := Module[
  {targetSector, endpointComponents, matrices, zeroShift, r1TargetShifts, selectedLines},
  targetSector = msTargetSectorForEvent[event, context];
  endpointComponents = event["componentPair"];
  selectedLines = msLineById[context, #] & /@ event["selectedLineIds"];
  matrices = Association@Table[
    componentPosition -> msEventContactMatrix[sourceSector, targetSector, event, componentPosition, context],
    {componentPosition, endpointComponents}
  ];
  zeroShift = ConstantArray[0, Length[sourceSector["vertexComponents"]]];
  r1TargetShifts = Association@Map[
    Function[componentPosition,
      componentPosition -> msContactTargetShiftEvent[
        sourceSector,
        targetSector,
        ReplacePart[zeroShift, componentPosition -> 1]
      ]
    ],
    DeleteDuplicates[endpointComponents]
  ];
  <|
    "sourceSector" -> sourceSector["sectorKey"],
    "targetSector" -> targetSector["sectorKey"],
    "eventId" -> event["eventId"],
    "lineId" -> If[Length[event["selectedLineIds"]] === 1, First[event["selectedLineIds"]], Missing["MultiEdgeEvent"]],
    "selectedLineIds" -> event["selectedLineIds"],
    "bundleLineIds" -> event["bundleLineIds"],
    "thetaBundleCoefficient" -> event["thetaBundleCoefficient"],
    "lineTypes" -> Lookup[selectedLines, "type"],
    "endpointComponents" -> endpointComponents,
    "matricesByComponent" -> matrices,
    "R0TargetShift" -> msContactTargetShiftEvent[sourceSector, targetSector, zeroShift],
    "R1TargetShiftsByComponent" -> r1TargetShifts,
    "normalizationRatio" -> Simplify[sourceSector["normalization"]/targetSector["normalization"]],
    "pinchNormalization" -> Times @@ Lookup[selectedLines, "pinchNormalization"],
    "absorbedNormalization" -> msNormalizedEventAbsorption[sourceSector, targetSector, selectedLines]
  |>
];

msContactMapsForSector[sourceSector_Association, context_?MSContextQ] := Map[
  msContactMapForEvent[sourceSector, #, context] &,
  Select[context["contactTransitions"], #["sourceSector"] === sourceSector["sectorKey"] &]
];

MSContactMaps[context_?MSContextQ, All] := AssociationThread[
  context["sectorOrder"] -> (msContactMapsForSector[#, context] & /@ context["sectors"])
];

MSContactMaps[context_?MSContextQ, key_String] := Module[{sector = msSectorByKey[context, key]},
  If[Head[sector] === Missing,
    Message[MSContactMaps::nosector, key];
    Failure["UnknownSector", <|"sectorKey" -> key|>],
    msContactMapsForSector[sector, context]
  ]
];

MSContactMaps[context_?MSContextQ] := MSContactMaps[context, All];


(* ::Chapter:: *)
(*公式递推*)

msIntegralVector[sector_Association, shifts_List] := MSIntegral[
  sector["sectorKey"],
  shifts,
  #
] & /@ sector["stateOrder"];

msResolveComponentPosition[sector_Association, component_] := Which[
  IntegerQ[component] && 1 <= component <= Length[sector["vertexComponents"]], component,
  ListQ[component], First@FirstPosition[sector["vertexComponents"], component, Missing["UnknownComponent"]],
  True, Missing["UnknownComponent"]
];

msRemainingVector[
  sector_Association,
  sourceShift_List,
  componentPosition_Integer,
  context_?MSContextQ
] := Module[{result, maps, map, matrix, targetSector, targetShift, targetVector},
  result = ConstantArray[0, sector["masterCount"]];
  maps = Select[
    msContactMapsForSector[sector, context],
    KeyExistsQ[#["matricesByComponent"], componentPosition] &
  ];
  Do[
    map = contactMap;
    matrix = map["matricesByComponent"][componentPosition];
    targetSector = msSectorByKey[context, map["targetSector"]];
    targetShift = msContactTargetShiftEvent[
      sector,
      targetSector,
      sourceShift
    ];
    targetVector = msIntegralVector[targetSector, targetShift];
    result += matrix.targetVector,
    {contactMap, maps}
  ];
  result
];

msRecurrenceTowardZero[int : MSIntegral[_, _, _], component_, context_?MSContextQ] := Module[
  {data, sector, shifts, bits, componentPosition, stateRow, currentShift, nearerShift,
   regularMatrix, contactMatrix, remainingVector, nearerVector, result, denominators, u, diagonalM0},
  data = msIntegralData[int, context];
  If[Head[data] === Failure, Return[data]];
  sector = data["sector"];
  shifts = data["shifts"];
  bits = data["bits"];
  componentPosition = msResolveComponentPosition[sector, component];
  If[Head[componentPosition] === Missing, Return[Failure["UnknownComponent", <|"component" -> component|>]]];
  currentShift = shifts[[componentPosition]];
  If[currentShift === 0, Return[Failure["ZeroShiftAtComponent", <|"component" -> componentPosition|>]]];
  stateRow = First@FirstPosition[sector["stateOrder"], bits];
  If[currentShift > 0,
    nearerShift = ReplacePart[shifts, componentPosition -> currentShift - 1];
    regularMatrix = Simplify[
      msM0Inverse[sector, componentPosition].msM1Matrix[sector, componentPosition, currentShift]
    ];
    remainingVector = msRemainingVector[sector, shifts, componentPosition, context];
    contactMatrix = -msM0Inverse[sector, componentPosition];
    denominators = msEnergyLetters[sector, componentPosition],
    nearerShift = ReplacePart[shifts, componentPosition -> currentShift + 1];
    regularMatrix = Simplify[
      msM1Inverse[sector, componentPosition, currentShift + 1].msM0Matrix[sector, componentPosition]
    ];
    remainingVector = msRemainingVector[sector, nearerShift, componentPosition, context];
    contactMatrix = msM1Inverse[sector, componentPosition, currentShift + 1];
    denominators = msM1SingularSurfaces[sector, componentPosition, currentShift + 1]
  ];
  nearerVector = msIntegralVector[sector, nearerShift];
  result = Expand[
    regularMatrix[[stateRow]].nearerVector + contactMatrix[[stateRow]].remainingVector
  ];
  <|
    "status" -> "reducedOneStep",
    "input" -> int,
    "componentPosition" -> componentPosition,
    "direction" -> If[currentShift > 0, "raiseFormulaTowardZero", "lowerFormulaTowardZero"],
    "nearerShift" -> nearerShift,
    "result" -> result,
    "singularSurfaces" -> denominators
  |>
];

MSRecurrenceStep[int : MSIntegral[_, _, _], component_, context_?MSContextQ] := msRecurrenceTowardZero[
  int,
  component,
  context
];

MSRecurrenceStep[int : MSIntegral[_, shifts_List, _], context_?MSContextQ] := Module[
  {position = SelectFirst[Range[Length[shifts]], shifts[[#]] =!= 0 &, Missing["AlreadyMaster"]]},
  If[Head[position] === Missing,
    <|"status" -> "alreadyMaster", "input" -> int, "result" -> int|>,
    msRecurrenceTowardZero[int, position, context]
  ]
];

MSRecurrenceStep[other_, ___] := (
  Message[MSRecurrenceStep::badint, HoldForm[other]];
  Failure["InvalidRecurrenceInput", <|"input" -> HoldForm[other]|>]
);

Options[MSReduce] = {MasterBasis -> Automatic};

msRequestedMasterBasis[context_?MSContextQ, Automatic] := Lookup[context["masters"], "integral"];
msRequestedMasterBasis[context_?MSContextQ, records_List] := Module[
  {basis, expected = Lookup[context["masters"], "integral"]},
  basis = Replace[records, item_Association :> Lookup[item, "integral", Missing["Integral"]], {1}];
  If[
    MemberQ[basis, _Missing] || ! DuplicateFreeQ[basis] ||
      Sort[ToString[#, InputForm] & /@ basis] =!= Sort[ToString[#, InputForm] & /@ expected],
    Failure["MasterBasisMustBeCompletePermutation", <|"expected" -> expected, "actual" -> basis|>],
    basis
  ]
];

MSReduce[expr_, context_?MSContextQ, OptionsPattern[]] := Module[
  {memo = <||>, singularLayers = {}, reduceIntegral, result, masterBasis, variables,
   replaced, coefficients, residual, remainingShifted, masterRules, status},
  masterBasis = msRequestedMasterBasis[context, OptionValue[MasterBasis]];
  If[Head[masterBasis] === Failure, Return[masterBasis]];

  reduceIntegral[int : MSIntegral[_, shifts_List, _], stack_List] := Module[
    {key, step, reduced},
    key = ToString[HoldComplete[int], InputForm];
    If[KeyExistsQ[memo, key], Return[memo[key]]];
    If[MemberQ[stack, key],
      Message[MSReduce::cycle, int];
      Return[Failure["RecurrenceCycle", <|"integral" -> int|>]]
    ];
    If[And @@ (# === 0 & /@ shifts), AssociateTo[memo, key -> int]; Return[int]];
    step = MSRecurrenceStep[int, context];
    If[Head[step] === Failure, AssociateTo[memo, key -> step]; Return[step]];
    AppendTo[
      singularLayers,
      <|
        "integral" -> int,
        "componentPosition" -> step["componentPosition"],
        "direction" -> step["direction"],
        "surfaces" -> step["singularSurfaces"]
      |>
    ];
    reduced = Expand[
      step["result"] /. child : MSIntegral[_, _, _] :> reduceIntegral[child, Append[stack, key]]
    ];
    AssociateTo[memo, key -> reduced];
    reduced
  ];

  result = Expand[expr /. int : MSIntegral[_, _, _] :> reduceIntegral[int, {}]];
  variables = Array[Unique["msMasterCoefficient"] &, Length[masterBasis]];
  replaced = Expand[result /. Thread[masterBasis -> variables]];
  coefficients = Simplify[Coefficient[replaced, #] & /@ variables];
  residual = Simplify[
    Together[(replaced - coefficients.variables) /. Thread[variables -> masterBasis]]
  ];
  remainingShifted = DeleteDuplicates@Cases[
    result,
    int : MSIntegral[_, shifts_List, _] /; AnyTrue[shifts, # =!= 0 &] :> int,
    Infinity
  ];
  masterRules = Thread[masterBasis -> coefficients];
  status = Which[
    ! FreeQ[result, _Failure], "failed",
    remainingShifted =!= {} || ! TrueQ[residual === 0], "partiallyReduced",
    True, "reduced"
  ];
  <|
    "status" -> status,
    "input" -> expr,
    "result" -> result,
    "masterBasis" -> masterBasis,
    "masterRules" -> masterRules,
    "coefficientVector" -> coefficients,
    "nonMasterResidual" -> residual,
    "memoizedIntegralCount" -> Length[memo],
    "remainingShiftedIntegrals" -> remainingShifted,
    "singularLayers" -> DeleteDuplicates[singularLayers]
  |>
];
