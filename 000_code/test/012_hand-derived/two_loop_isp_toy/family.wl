(* ::Package:: *)
(* two_loop_isp_toy：三条 massless 线，两圈任意符号名，并含两个 ISP。 *)

(* ::Chapter:: *)
(*函数族定义*)

twoLoopISPSigns = <|
   "++" -> {"+", "+"},
   "--" -> {"-", "-"},
   "+-" -> {"+", "-"},
   "-+" -> {"-", "+"}
   |>;

twoLoopISPDefinition = <|
   "name" -> "twoLoopISPToy",
   "vertexOrder" -> {v1, v2},
   "vertexSignCases" -> twoLoopISPSigns,
   "loopMomenta" -> {l3, k321},
   "externalMomenta" -> {wdnmd},
   "externalInvariantRules" -> {sp[wdnmd, wdnmd] -> s11},
   "vertexEnergies" -> <|v1 -> E1, v2 -> E2|>,
   "lineData" -> {
     <|"id" -> 1, "endpoints" -> {v1, v2}, "momentum" -> l3,
       "massType" -> "massless", "bbType" -> "exp", "nu" -> 0|>,
     <|"id" -> 2, "endpoints" -> {v1, v2}, "momentum" -> k321,
       "massType" -> "massless", "bbType" -> "exp", "nu" -> 0|>,
     <|"id" -> 3, "endpoints" -> {v1, v2}, "momentum" -> l3 - k321 - wdnmd,
       "massType" -> "massless", "bbType" -> "exp", "nu" -> 0|>
     },
   "ispData" -> {
     <|"name" -> rhoK321L3, "expr" -> sp[k321, l3],
       "expression" -> sp[k321, l3], "range" -> {0, 1}|>,
     <|"name" -> rhoL3Wdnmd, "expr" -> sp[l3, wdnmd],
       "expression" -> sp[l3, wdnmd], "range" -> {0, 1}|>
     },
   "ispSeedRules" -> {
     {ispN[1] -> 0, ispN[2] -> 0},
     {ispN[1] -> 1, ispN[2] -> 0},
     {ispN[1] -> 0, ispN[2] -> 1}
     },
   "zeroPointRules" -> {
     a0[v1] -> alpha1, a0[v2] -> alpha2,
     b0[1] -> beta1, b0[2] -> beta2, b0[3] -> beta3,
     bS0[1] -> beta1, bS0[2] -> beta2, bS0[3] -> beta3
     },
   "symmetryRules" -> {}
   |>;

makeTwoLoopISPToyCase[signKey_String] := Module[
   {signs = twoLoopISPSigns[signKey]},
   <|
    "name" -> "twoLoopISPToy" <> signKey,
    "vertexData" -> {{v1, signs[[1]]}, {v2, signs[[2]]}},
    "lineData" -> twoLoopISPDefinition["lineData"],
    "loopMomenta" -> twoLoopISPDefinition["loopMomenta"],
    "externalMomenta" -> twoLoopISPDefinition["externalMomenta"],
    "externalInvariantRules" -> twoLoopISPDefinition["externalInvariantRules"],
    "vertexEnergies" -> twoLoopISPDefinition["vertexEnergies"],
    "ispData" -> twoLoopISPDefinition["ispData"],
    "zeroPointRules" -> twoLoopISPDefinition["zeroPointRules"],
    "symmetryRules" -> {},
    "seedPreset" -> "quickCheck"
    |>
   ];
