(* ::Package:: *)
(* all_family_total_derivative：汇总现有物理 family 的原始输入，并构造 general-index 总导数种子。
   本文件只复用各 family 的 topology 定义，不加载 012 package 或任何求导实现。 *)

(* ::Chapter:: *)
(*载入既有函数族输入*)

handDerivedRoot = DirectoryName[DirectoryName[$InputFileName]];
allFamilyDerivativeSourceNames = {
   "atomic_massless_line",
   "atomic_massive_line",
   "pure_massless_bubble",
   "mixed_bubble",
   "mixed_triangle",
   "mixed_sunrise",
   "pure_massive_bubble_reference",
   "two_loop_isp_toy",
   "parallel_massless_bundle_guard",
   "vertex_energy_signs"
   };

Scan[
  Get[FileNameJoin[{handDerivedRoot, #, "family.wl"}]] &,
  allFamilyDerivativeSourceNames
  ];


(* ::Chapter:: *)
(*覆盖 case 清单*)

allFamilyDerivativeEntry[family_, signKey_, mode_, case_] := <|
   "family" -> family,
   "signKey" -> signKey,
   "mode" -> mode,
   "label" -> StringRiffle[DeleteCases[{family, mode, signKey}, ""], ":"],
   "case" -> case
   |>;


makeAllFamilyDerivativeCases[] := Join[
   Table[
    allFamilyDerivativeEntry[
     "atomic_massless_line", signKey, "", makeAtomicMasslessCase[signKey]
     ],
    {signKey, Keys[atomicMasslessSigns]}
    ],
   Flatten[Table[
     allFamilyDerivativeEntry[
      "atomic_massive_line", signKey, mode, makeAtomicMassiveCase[signKey, mode]
      ],
     {mode, {"h", "H"}}, {signKey, Keys[atomicMassiveSigns]}
     ]],
   Table[
    allFamilyDerivativeEntry[
     "pure_massless_bubble", signKey, "", makePureMasslessBubbleCase[signKey]
     ],
    {signKey, Keys[pureMasslessBubbleSigns]}
    ],
   Table[
    allFamilyDerivativeEntry[
     "mixed_bubble", signKey, "", makeMixedBubbleCase[signKey]
     ],
    {signKey, Keys[mixedBubbleSigns]}
    ],
   Table[
    allFamilyDerivativeEntry[
     "mixed_triangle", signKey, "", makeMixedTriangleCase[signKey]
     ],
    {signKey, Keys[mixedTriangleSigns]}
    ],
   Table[
    allFamilyDerivativeEntry[
     "mixed_sunrise", signKey, "", makeMixedSunriseCase[signKey]
     ],
    {signKey, Keys[mixedSunriseSigns]}
    ],
   Flatten[Table[
     allFamilyDerivativeEntry[
      "pure_massive_bubble_reference", signKey, mode,
      makePureMassiveBubbleReferenceCase[signKey, mode]
      ],
     {mode, {"h", "H"}}, {signKey, Keys[pureMassiveBubbleSigns]}
     ]],
   Table[
    allFamilyDerivativeEntry[
     "two_loop_isp_toy", signKey, "", makeTwoLoopISPToyCase[signKey]
     ],
    {signKey, Keys[twoLoopISPSigns]}
    ],
   Table[
    allFamilyDerivativeEntry[
     "parallel_massless_bundle_guard", signKey, "",
     makeParallelMasslessBundleGuardCase[signKey]
     ],
    {signKey, Keys[parallelMasslessSigns]}
    ],
   Table[
    allFamilyDerivativeEntry[
     "vertex_energy_signs", signKey, "", makeVertexEnergySignsCase[signKey]
     ],
    {signKey, Keys[vertexEnergySigns]}
    ]
   ];


(* ::Chapter:: *)
(*手推 helper 所需的统一定义*)

allFamilyManualDefinition[entry_Association] := Module[{case = entry["case"], vertices, signs},
   vertices = First /@ case["vertexData"];
   signs = Last /@ case["vertexData"];
   <|
    "name" -> entry["label"],
    "vertexOrder" -> vertices,
    "vertexSignCases" -> <|entry["signKey"] -> signs|>,
    "loopMomenta" -> Lookup[case, "loopMomenta", {}],
    "externalMomenta" -> Lookup[case, "externalMomenta", {}],
    "externalInvariantRules" -> Lookup[case, "externalInvariantRules", {}],
    "vertexEnergies" -> Lookup[case, "vertexEnergies", AssociationThread[vertices -> 0]],
    "lineData" -> case["lineData"],
    "ispData" -> Lookup[case, "ispData", {}],
    "ispSeedRules" -> Lookup[case, "ispSeedRules", Automatic],
    "zeroPointRules" -> Lookup[case, "zeroPointRules", {}],
    "symmetryRules" -> Lookup[case, "symmetryRules", {}]
    |>
   ];


allFamilyGeneralIntegral[
   entry_Association,
   def_Association,
   sector_String,
   discreteValue_Integer,
   copy_Integer
   ] := Module[{shrunk, active, packs, isps, label = entry["label"]},
   shrunk = manualShrunkLines[sector];
   active = manualActiveVertices[def, sector];
   packs = Table[
     Which[
      MemberQ[shrunk, lineId],
      {gb[label, sector, copy, lineId]},
      manualLineMass[def, lineId] === "massive",
      {gb[label, sector, copy, lineId], discreteValue, discreteValue},
      manualSameBranchQ[def, entry["signKey"], lineId],
      {gb[label, sector, copy, lineId], discreteValue},
      True,
      {gb[label, sector, copy, lineId]}
      ],
     {lineId, manualLineIds[def]}
     ];
   isps = Table[gr[label, sector, copy, r], {r, Length[Lookup[def, "ispData", {}]]}];
   J[
    Table[ga[label, sector, copy, slot], {slot, Length[active]}],
    packs,
    isps
    ]
   ];
