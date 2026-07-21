(* ::Package:: *)
(* 检查动力学量导数与 q/time IBP 共用最终 AT 编译结果；WT 只控制 theta shrink。 *)

Get[FileNameJoin[{DirectoryName[$InputFileName], "..", "012_dS_ibp_general.wl"}]];

makeExternalFunctionSystemCase[name_, functionSpec_] := <|
   "name" -> name,
   "vertexData" -> {{u, "+"}, {v, "-"}},
   "lineData" -> {
     <|
      "id" -> 1,
      "endpoints" -> {u, v},
      "momentum" -> q - k,
      "nu" -> nuX,
      "bbType" -> "custom",
      "massType" -> "massive",
      "functionSystem" -> functionSpec
      |>
     },
   "loopMomenta" -> {q},
   "externalMomenta" -> {k},
   "externalInvariantRules" -> {sp[k, k] -> s11},
   "vertexEnergies" -> <|u -> ke[1], v -> ke[2]|>,
   "ispData" -> {
     <|"name" -> rhoQK, "expr" -> sp[q, k], "range" -> {0}|>
     },
   "zeroPointRules" -> {
     a0[u] -> alphaU, a0[v] -> alphaV,
     b0[1] -> beta1
     },
   "seedPreset" -> "quickCheck"
   |>;

nontrivialSpec = <|
   "variable" -> x,
   "P" -> 0,
   "Q" -> 1,
   "T" -> {{x, 0}, {0, 1}},
   "W" -> -wronskianNormalization,
   "WT" -> Automatic
   |>;

nontrivialTopo = parseTopology[
   makeExternalFunctionSystemCase["externalNontrivialT", nontrivialSpec]
   ];
nontrivialCompiled = nontrivialTopo["lines"][[1, "compiledFunctionSystem"]];
nontrivialRules = makeScalarProductRules[nontrivialTopo]["repSP2Z"];
nontrivialGenerator = First @ externalVectorDerivativeGenerators[nontrivialTopo];
nontrivialIntegral = makeBaseIntegral[nontrivialTopo] /. {
    a[u] -> 0, a[v] -> 0, b[1] -> 0,
    n[1, 1] -> 0, n[1, 2] -> 1, ispN[1] -> 0
    };
nontrivialVDotQ = Expand[
   expandDotExpr[k, q - k, nontrivialTopo] /. nontrivialRules
   ];

manualCompiledExternalTerm[
   topo_, int_J, endpointSlot_Integer, targetState_Integer,
   xPower_Integer, coefficient_, factor_
   ] := Module[{result, endpointVertex},
   endpointVertex = topo["lines"][[1, "endpoints", endpointSlot]];
   result = setLinePackEntry[int, 1, endpointSlot + 1, targetState];
   result = shiftLineB[result, 1, 1 - xPower];
   result = shiftVertexA[result, topo, endpointVertex, xPower + 1];
   coefficient absorbLinearFactor[factor, result, topo]
   ];

(* Coefficient[q-k,k]=-1.  AT={{1/x,x},{-1/x,0}}:
   endpoint 1 starts in state 0 and endpoint 2 starts in state 1. *)
expectedNontrivialBuildingBlock = Expand[
   -manualCompiledExternalTerm[
      nontrivialTopo, nontrivialIntegral, 1, 0, -1, 1,
      nontrivialVDotQ
      ]
   -manualCompiledExternalTerm[
      nontrivialTopo, nontrivialIntegral, 1, 1, 1, 1,
      nontrivialVDotQ
      ]
   -manualCompiledExternalTerm[
      nontrivialTopo, nontrivialIntegral, 2, 0, -1, -1,
      nontrivialVDotQ
      ]
   ];

actualNontrivialBuildingBlock = Expand[
   externalVectorBuildingBlockDerivativeTerms[
    nontrivialTopo,
    nontrivialIntegral,
    nontrivialGenerator,
    nontrivialRules
    ]
   ];

expectedNontrivialFull = Expand[
   externalVectorPropagatorDerivativeTerms[
     nontrivialTopo, nontrivialIntegral, nontrivialGenerator, nontrivialRules
     ]
   + expectedNontrivialBuildingBlock
   + externalVectorISPDerivativeTerms[
     nontrivialTopo, nontrivialIntegral, nontrivialGenerator, nontrivialRules
     ]
   + externalVectorVertexEnergyDerivativeTerms[
     nontrivialTopo, nontrivialIntegral, nontrivialGenerator
     ]
   ];

actualNontrivialFull = Expand[
   applyExternalVectorDerivativeSeed[
    nontrivialTopo, nontrivialIntegral, nontrivialGenerator
    ]
   ];

actualNontrivialInvariant = Expand[
   applyExternalInvariantVariableDerivativeSeed[
    nontrivialTopo, nontrivialIntegral, s11
    ]
   ];
expectedNontrivialInvariant = Expand[
   expectedNontrivialFull/(2 kk[1, 1])
   ];

legacyExternalMassiveBuildingBlock[
   topo_, int_J, gen_Association, repSP2ZRules_List
   ] := Module[
   {dExternal, vector, lineMomentum, extCoeff, vDotQ, shiftedInt},
   dExternal = gen["dExternal"];
   vector = gen["vector"];
   lineMomentum = topo["lines"][[1, "momentum"]];
   extCoeff = Coefficient[
     lineMomentum, topo["externalMomenta"][[dExternal]]
     ];
   vDotQ = Expand[
     expandDotExpr[vector, lineMomentum, topo] /. repSP2ZRules
     ];
   Total@Table[
     shiftedInt = shiftLinePackEntry[int, 1, endpointSlot + 1, 1];
     shiftedInt = shiftVertexA[
       shiftedInt,
       topo,
       topo["lines"][[1, "endpoints", endpointSlot]],
       1
       ];
     shiftedInt = shiftLineB[shiftedInt, 1, 1];
     extCoeff absorbLinearFactor[vDotQ, shiftedInt, topo],
     {endpointSlot, 2}
     ]
   ];

presetRegressionChecks = Flatten@Table[
    Module[{case, topo, rules, gen, int, actual, expected},
     case = makeExternalFunctionSystemCase[
       "externalPreset" <> mode,
       functionSystemPreset[mode, <|"nu" -> nuX|>]
       ];
     topo = parseTopology[case];
     rules = makeScalarProductRules[topo]["repSP2Z"];
     gen = First @ externalVectorDerivativeGenerators[topo];
     int = makeBaseIntegral[topo] /. {
        a[u] -> 0, a[v] -> 0, b[1] -> 0,
        n[1, 1] -> states[[1]], n[1, 2] -> states[[2]],
        ispN[1] -> 0
        };
     actual = applySeedCanonical[
       externalVectorBuildingBlockDerivativeTerms[topo, int, gen, rules],
       topo
       ];
     expected = applySeedCanonical[
       legacyExternalMassiveBuildingBlock[topo, int, gen, rules],
       topo
       ];
     <|
      "mode" -> mode,
      "states" -> states,
      "passQ" -> TrueQ[Expand[actual - expected] === 0]
      |>
     ],
    {mode, {"h", "H"}},
    {states, Tuples[{0, 1}, 2]}
    ];

checks = <|
   "nontrivial T compiles" -> TrueQ[
     nontrivialCompiled["status"] === "compiled"
     ],
   "nontrivial final AT" -> TrueQ[
     FullSimplify[
       nontrivialCompiled["AT"] == {{1/x, x}, {-1/x, 0}}
       ]
     ],
   "WT is compiled but derivative independent" -> TrueQ[
     FullSimplify[
       nontrivialCompiled["WT"] == -wronskianNormalization x
       ] && FreeQ[actualNontrivialFull, wronskianNormalization]
     ],
   "external-vector building block uses final AT" -> TrueQ[
     Expand[actualNontrivialBuildingBlock - expectedNontrivialBuildingBlock] === 0
     ],
   "external-vector full seed uses final AT" -> TrueQ[
     Expand[actualNontrivialFull - expectedNontrivialFull] === 0
     ],
   "external-invariant derivative uses final AT" -> TrueQ[
     Expand[actualNontrivialInvariant - expectedNontrivialInvariant] === 0
     ],
   "nontrivial derivative has no forbidden n" -> TrueQ[
     ! containsForbiddenNQ[nontrivialTopo, actualNontrivialInvariant]
     ],
   "h/H preset external derivatives unchanged" -> TrueQ[
     And @@ Lookup[presetRegressionChecks, "passQ"]
     ]
   |>;

Print[
 "012 external function-system derivative checks: ",
 Count[Values[checks], True], "/", Length[checks]
 ];
Print[Select[checks, ! TrueQ[#] &]];
If[! TrueQ[checks["external-vector building block uses final AT"]],
 Print["actual building-block: ", InputForm[actualNontrivialBuildingBlock]];
 Print["expected building-block: ", InputForm[expectedNontrivialBuildingBlock]]
 ];
If[! TrueQ[checks["h/H preset external derivatives unchanged"]],
 Print["preset regression failures: ",
  InputForm[Select[presetRegressionChecks, ! TrueQ[#passQ] &]]]
 ];

If[! And @@ Values[checks], Exit[1]];
