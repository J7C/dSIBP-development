(* ::Package:: *)
(* tadpole symmetry benchmark 的独立拓扑输入。*)

makeTadpoleCase[massType_String, withISPQ_: False, userRules_: {}] := <|
   "name" -> "tadpole_" <> massType,
   "vertexData" -> {{v, "+"}},
   "lineData" -> {
     <|
      "id" -> 1,
      "endpoints" -> {v, v},
      "momentum" -> ell,
      "massType" -> massType,
      "bbType" -> If[massType === "massive", "h", "exp"],
      "nu" -> nu1
      |>
     },
   "loopMomenta" -> {ell},
   "externalMomenta" -> {k},
   "externalInvariantRules" -> {sp[k, k] -> s11},
   "vertexEnergies" -> <|v -> ke[1]|>,
   "ispData" -> If[TrueQ[withISPQ], {<|"name" -> rhoEllK, "expr" -> sp[ell, k], "range" -> {0}|>}, {}],
   "zeroPointRules" -> {a0[v] -> alpha, b0[1] -> beta, bS0[1] -> beta},
   "symmetryRules" -> userRules,
   "seedPreset" -> "quickCheck"
   |>;


makeTadpoleDerivativeCase[] := Module[{case = makeTadpoleCase["massless", True, {}]},
   Join[case, <|
     "externalMomenta" -> {},
     "externalInvariantRules" -> {},
     "ispData" -> {},
     "lineData" -> {Join[case["lineData"][[1]], <|"skType" -> "+-"|>]}
     |>]
   ];
