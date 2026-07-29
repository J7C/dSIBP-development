(* ::Package:: *)

(***
文件：TensorAtoms.wl
用途：由 sector slot registry 直接组装 Kronecker 原子、M1/M0、共同对角化矩阵和 energy letters。
公式参数：正 prefactor 时 2401 矩阵消费 slot["formulaNu"]=-nu；负 prefactor 时消费 +nu。
***)

(* ::Chapter:: *)
(*Kronecker 工具*)

msKroneckerAll[{}] := {{1}};
msKroneckerAll[matrices_List] := Fold[KroneckerProduct, First[matrices], Rest[matrices]];

msEmbedMatrix[matrix_, position_Integer, slotCount_Integer] := msKroneckerAll@Table[
  If[index === position, matrix, msIdentity2],
  {index, slotCount}
];

msIdentityForSector[sector_Association] := IdentityMatrix[sector["masterCount"]];

msRawIdentityForSector[sector_Association] := IdentityMatrix[sector["rawStateCount"]];

msQuotientMatrix[sector_Association, rawMatrix_] := Simplify[
  sector["stateProjection"].rawMatrix.sector["stateEmbedding"]
];

msSlotPositionByKey[sector_Association, key_] := FirstPosition[
  Lookup[sector["slots"], "key"],
  key,
  Missing["UnknownSlot", key]
];


(* ::Section:: *)
(*Component 与 slot incidence*)

msComponentContainsRootQ[sector_Association, componentPosition_Integer, rootVertex_] := MemberQ[
  sector["vertexComponents"][[componentPosition]],
  rootVertex
];

msHankelSlotsAtComponent[sector_Association, componentPosition_Integer] := Select[
  MapIndexed[Append[#1, "slotPosition" -> First[#2]] &, sector["slots"]],
  MemberQ[{"massiveEndpoint", "masslessEndpointH"}, #["kind"]] &&
    msComponentContainsRootQ[sector, componentPosition, #["rootVertex"]] &
];

msMasslessSharedIncidence[slot_Association, sector_Association, componentPosition_Integer] := Total@MapThread[
  If[MemberQ[sector["vertexComponents"][[componentPosition]], #1], #2, 0] &,
  {slot["endpoints"], {1, -1}}
];


(* ::Section:: *)
(*M1/M0 与共同对角化*)

msM1Matrix[sector_Association, componentPosition_Integer, integerShift_: 0] := Module[
  {matrix, slots},
  matrix = (sector["baseTimePowers"][[componentPosition]] + integerShift) msRawIdentityForSector[sector];
  slots = msHankelSlotsAtComponent[sector, componentPosition];
  Do[
    matrix -= (2 slot["formulaNu"] + 1) msEmbedMatrix[
      msProjector1,
      slot["slotPosition"],
      sector["slotCount"]
    ],
    {slot, slots}
  ];
  msQuotientMatrix[sector, matrix]
];

msM0Matrix[sector_Association, componentPosition_Integer] := Module[
  {matrix, slot, incidence},
  matrix = I sector["componentEnergies"][[componentPosition]] msRawIdentityForSector[sector];
  Do[
    slot = Append[sector["slots"][[slotPosition]], "slotPosition" -> slotPosition];
    Switch[
      slot["kind"],
      "massiveEndpoint" | "masslessEndpointH",
        If[msComponentContainsRootQ[sector, componentPosition, slot["rootVertex"]],
          matrix += msEmbedMatrix[-I slot["momentum"] msSigma2, slotPosition, sector["slotCount"]]
        ],
      "masslessShared",
        incidence = msMasslessSharedIncidence[slot, sector, componentPosition];
        If[incidence =!= 0,
          matrix += msEmbedMatrix[
            I incidence slot["sigma"] slot["momentum"] msSigma1,
            slotPosition,
            sector["slotCount"]
          ]
        ]
    ],
    {slotPosition, sector["slotCount"]}
  ];
  msQuotientMatrix[sector, matrix]
];

msSectorDiagonalizer[sector_Association] := msQuotientMatrix[
  sector,
  msKroneckerAll@Map[
    Switch[
      #["kind"],
      "massiveEndpoint" | "masslessEndpointH", msPaperT,
      "masslessShared", If[MemberQ[sector["coincidentLineIds"], #["lineId"]], msIdentity2, msHadamard]
    ] &,
    sector["slots"]
  ]
];

msSectorDiagonalizerInverse[sector_Association] := msQuotientMatrix[
  sector,
  msKroneckerAll@Map[
    Switch[
      #["kind"],
      "massiveEndpoint" | "masslessEndpointH", msPaperTInverse,
      "masslessShared", If[MemberQ[sector["coincidentLineIds"], #["lineId"]], msIdentity2, msHadamard]
    ] &,
    sector["slots"]
  ]
];

(* M1 在 state-bit basis 中严格对角；这里只对标量本征值取倒数。 *)
msM1Inverse[sector_Association, componentPosition_Integer, integerShift_: 0] := Module[
  {diagonal = Diagonal[msM1Matrix[sector, componentPosition, integerShift]]},
  DiagonalMatrix[Simplify[1/diagonal]]
];

msM0Inverse[sector_Association, componentPosition_Integer] := Module[
  {u, uInverse, diagonal},
  u = msSectorDiagonalizer[sector];
  uInverse = msSectorDiagonalizerInverse[sector];
  diagonal = Simplify[Diagonal[u.msM0Matrix[sector, componentPosition].uInverse]];
  Simplify[uInverse.DiagonalMatrix[1/diagonal].u]
];

msEnergyLetters[sector_Association, componentPosition_Integer] := Module[
  {u = msSectorDiagonalizer[sector], uInverse = msSectorDiagonalizerInverse[sector]},
  Simplify[Diagonal[u.msM0Matrix[sector, componentPosition].uInverse]/I]
];

msM1SingularSurfaces[sector_Association, componentPosition_Integer, integerShift_: 0] := DeleteDuplicates[
  Simplify[Diagonal[msM1Matrix[sector, componentPosition, integerShift]]]
];


(* ::Section:: *)
(*公开矩阵查询*)

msFormulaMatricesForSector[sector_Association] := Module[
  {componentCount, u, uInverse, components},
  componentCount = Length[sector["vertexComponents"]];
  u = msSectorDiagonalizer[sector];
  uInverse = msSectorDiagonalizerInverse[sector];
  components = Table[
    <|
      "componentPosition" -> componentPosition,
      "rootVertices" -> sector["vertexComponents"][[componentPosition]],
      "baseTimePower" -> sector["baseTimePowers"][[componentPosition]],
      "energy" -> sector["componentEnergies"][[componentPosition]],
      "M1" -> msM1Matrix[sector, componentPosition, 0],
      "M1PlusOne" -> msM1Matrix[sector, componentPosition, 1],
      "M0" -> msM0Matrix[sector, componentPosition],
      "M0Diagonal" -> Simplify[u.msM0Matrix[sector, componentPosition].uInverse],
      "energyLetters" -> msEnergyLetters[sector, componentPosition],
      "M1SingularSurfaces" -> msM1SingularSurfaces[sector, componentPosition, 0]
    |>,
    {componentPosition, componentCount}
  ];
  <|
    "status" -> "generated",
    "sectorKey" -> sector["sectorKey"],
    "slotRegistry" -> sector["slots"],
      "stateOrder" -> sector["stateOrder"],
      "rawStateOrder" -> sector["rawStateOrder"],
      "stateEmbedding" -> sector["stateEmbedding"],
      "stateProjection" -> sector["stateProjection"],
    "dimension" -> sector["masterCount"],
    "U" -> u,
    "UInverse" -> uInverse,
    "components" -> components,
    "letters" -> DeleteDuplicates[Flatten[Lookup[components, "energyLetters"]]]
  |>
];

MSFormulaMatrices[context_?MSContextQ, All] := AssociationThread[
  context["sectorOrder"] -> (msFormulaMatricesForSector /@ context["sectors"])
];

MSFormulaMatrices[context_?MSContextQ, key_String] := Module[{sector = msSectorByKey[context, key]},
  If[Head[sector] === Missing,
    Message[MSFormulaMatrices::nosector, key];
    Failure["UnknownSector", <|"sectorKey" -> key|>],
    msFormulaMatricesForSector[sector]
  ]
];

MSFormulaMatrices[context_?MSContextQ] := MSFormulaMatrices[context, All];
