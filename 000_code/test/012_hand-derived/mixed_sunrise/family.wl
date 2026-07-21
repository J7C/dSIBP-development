(* ::Package:: *)
(* mixed_sunrise：两圈一 massive 加两 massless，并显式包含两个 ISP。 *)

(* ::Chapter:: *)
(*函数族定义*)

mixedSunriseSigns = <|
   "++" -> {"+", "+"},
   "--" -> {"-", "-"},
   "+-" -> {"+", "-"},
   "-+" -> {"-", "+"}
   |>;

mixedSunriseDefinition = <|
   "name" -> "mixedSunrise",
   "vertexOrder" -> {v1, v2},
   "vertexSignCases" -> mixedSunriseSigns,
   "loopMomenta" -> {q1, q2},
   "externalMomenta" -> {k},
   "externalInvariantRules" -> {sp[k, k] -> s11},
   "vertexEnergies" -> <|v1 -> E1, v2 -> E2|>,
   "lineData" -> {
     <|"id" -> 1, "endpoints" -> {v1, v2}, "momentum" -> q1,
       "massType" -> "massive", "bbType" -> "h", "nu" -> nuM|>,
     <|"id" -> 2, "endpoints" -> {v1, v2}, "momentum" -> q2,
       "massType" -> "massless", "bbType" -> "exp", "nu" -> 0|>,
     <|"id" -> 3, "endpoints" -> {v1, v2}, "momentum" -> q1 - q2 - k,
       "massType" -> "massless", "bbType" -> "exp", "nu" -> 0|>
     },
   "ispData" -> {
     <|"name" -> ispQ1K, "expr" -> sp[q1, k], "expression" -> sp[q1, k], "range" -> {0, 1}|>,
     <|"name" -> ispQ2K, "expr" -> sp[q2, k], "expression" -> sp[q2, k], "range" -> {0, 1}|>
     },
   "ispSeedRules" -> {
     {ispN[1] -> 0, ispN[2] -> 0},
     {ispN[1] -> 1, ispN[2] -> 0},
     {ispN[1] -> 0, ispN[2] -> 1}
     },
   "zeroPointRules" -> {
     a0[v1] -> alpha1, a0[v2] -> alpha2,
     b0[1] -> beta1, b0[2] -> beta2, b0[3] -> beta3,
     bS0[2] -> beta2, bS0[3] -> beta3
     },
   "symmetryRules" -> {}
   |>;

makeMixedSunriseCase[signKey_String] := Module[
   {signs = mixedSunriseSigns[signKey]},
   <|
    "name" -> "mixedSunrise" <> signKey,
    "vertexData" -> {{v1, signs[[1]]}, {v2, signs[[2]]}},
    "lineData" -> mixedSunriseDefinition["lineData"],
    "loopMomenta" -> mixedSunriseDefinition["loopMomenta"],
    "externalMomenta" -> mixedSunriseDefinition["externalMomenta"],
    "externalInvariantRules" -> mixedSunriseDefinition["externalInvariantRules"],
    "vertexEnergies" -> mixedSunriseDefinition["vertexEnergies"],
    "ispData" -> mixedSunriseDefinition["ispData"],
    "zeroPointRules" -> mixedSunriseDefinition["zeroPointRules"],
    "symmetryRules" -> {},
    "seedPreset" -> "quickCheck"
    |>
   ];
