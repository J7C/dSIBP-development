(* ::Package:: *)
(* mixed_triangle：只定义独立 benchmark 的输入。 *)

(* ::Chapter:: *)
(*函数族定义*)

mixedTriangleSigns = <|
   "+++" -> {"+", "+", "+"},
   "++-" -> {"+", "+", "-"},
   "+-+" -> {"+", "-", "+"},
   "+--" -> {"+", "-", "-"},
   "-++" -> {"-", "+", "+"},
   "-+-" -> {"-", "+", "-"},
   "--+" -> {"-", "-", "+"},
   "---" -> {"-", "-", "-"}
   |>;

makeMixedTriangleCase[signKey_String] := Module[
   {signs = mixedTriangleSigns[signKey]},
   <|
    "name" -> "mixedTriangle" <> signKey,
    "vertexData" -> {{v1, signs[[1]]}, {v2, signs[[2]]}, {v3, signs[[3]]}},
    "lineData" -> {
      <|"id" -> 1, "endpoints" -> {v1, v2}, "momentum" -> q,
        "nu" -> nuM, "bbType" -> "h", "massType" -> "massive"|>,
      <|"id" -> 2, "endpoints" -> {v2, v3}, "momentum" -> q - k1,
        "nu" -> nuM, "bbType" -> "h", "massType" -> "massive"|>,
      <|"id" -> 3, "endpoints" -> {v3, v1}, "momentum" -> q + k2,
        "nu" -> 0, "bbType" -> "exp", "massType" -> "massless"|>
      },
    "loopMomenta" -> {q},
    "externalMomenta" -> {k1, k2},
    "externalInvariantRules" -> {
      sp[k1, k1] -> s11,
      sp[k1, k2] -> s12,
      sp[k2, k2] -> s22
      },
    "vertexEnergies" -> <|v1 -> E1, v2 -> E2, v3 -> E3|>,
    "zeroPointRules" -> {
      a0[v1] -> alpha1,
      a0[v2] -> alpha2,
      a0[v3] -> alpha3,
      b0[1] -> beta1,
      b0[2] -> beta2,
      b0[3] -> beta3,
      bS0[3] -> beta3
      },
    "symmetryRules" -> {},
    "seedPreset" -> "quickCheck"
    |>
   ];
