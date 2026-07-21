(* ::Package:: *)
(* vertex_energy_signs：检查顶点能量命名与 +/- 相位符号。 *)

(* ::Chapter:: *)
(*函数族定义*)

vertexEnergyBaseSigns = <|
   "++" -> {"+", "+"},
   "--" -> {"-", "-"},
   "+-" -> {"+", "-"},
   "-+" -> {"-", "+"}
   |>;

vertexEnergySigns = Association @ Flatten[
    Table[
     (case <> # -> vertexEnergyBaseSigns[#]) & /@ Keys[vertexEnergyBaseSigns],
     {case, {"A", "B", "C"}}
     ]
    ];

vertexEnergyCases = <|
   "A" -> <|v1 -> ke[1], v2 -> ke[2]|>,
   "B" -> <|v1 -> Sqrt[s11], v2 -> ke[2]|>,
   "C" -> <|v1 -> ke[3], v2 -> ke[2]|>
   |>;

vertexEnergyCaseName[signKey_String] := StringTake[signKey, 1];
vertexEnergyBaseSignKey[signKey_String] := StringDrop[signKey, 1];

vertexEnergyDefinition = <|
   "name" -> "vertexEnergySigns",
   "vertexOrder" -> {v1, v2},
   "vertexSignCases" -> vertexEnergySigns,
   "vertexEnergyCases" -> Association[
     Table[
      signKey -> vertexEnergyCases[vertexEnergyCaseName[signKey]],
      {signKey, Keys[vertexEnergySigns]}
      ]
     ],
   "loopMomenta" -> {ell},
   "externalMomenta" -> {k},
   "externalInvariantRules" -> {sp[k, k] -> s11},
   "vertexEnergies" -> vertexEnergyCases["A"],
   "lineData" -> {
     <|"id" -> 1, "endpoints" -> {v1, v2}, "momentum" -> ell - k,
       "massType" -> "massless", "bbType" -> "exp", "nu" -> 0|>
     },
   "ispData" -> {
     <|"name" -> rhoEllK, "expr" -> sp[ell, k], "expression" -> sp[ell, k], "range" -> {0}|>
     },
   "ispSeedRules" -> {{ispN[1] -> 0}},
   "zeroPointRules" -> {
     a0[v1] -> alpha1, a0[v2] -> alpha2,
     b0[1] -> beta1, bS0[1] -> beta1
     },
   "symmetryRules" -> {}
   |>;

makeVertexEnergySignsCase[signKey_String] := Module[
   {baseKey = vertexEnergyBaseSignKey[signKey], signs},
   signs = vertexEnergyBaseSigns[baseKey];
   <|
    "name" -> "vertexEnergySigns" <> signKey,
    "vertexData" -> {{v1, signs[[1]]}, {v2, signs[[2]]}},
    "lineData" -> vertexEnergyDefinition["lineData"],
    "loopMomenta" -> vertexEnergyDefinition["loopMomenta"],
    "externalMomenta" -> vertexEnergyDefinition["externalMomenta"],
    "externalInvariantRules" -> vertexEnergyDefinition["externalInvariantRules"],
    "vertexEnergies" -> vertexEnergyCases[vertexEnergyCaseName[signKey]],
    "ispData" -> vertexEnergyDefinition["ispData"],
    "zeroPointRules" -> vertexEnergyDefinition["zeroPointRules"],
    "symmetryRules" -> {},
    "seedPreset" -> "quickCheck"
    |>
   ];
