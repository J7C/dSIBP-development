(* ::Package:: *)
(* mixed_bubble：只定义独立 benchmark 的输入。 *)

(* ::Chapter:: *)
(*函数族定义*)

mixedBubbleSigns = <|
   "++" -> {"+", "+"},
   "--" -> {"-", "-"},
   "+-" -> {"+", "-"},
   "-+" -> {"-", "+"}
   |>;

makeMixedBubbleCase[signKey_String] := Module[
   {signs = mixedBubbleSigns[signKey]},
   <|
    "name" -> "mixedBubble" <> signKey,
    "vertexData" -> {{v1, signs[[1]]}, {v2, signs[[2]]}},
    "lineData" -> {
      <|"id" -> 1, "endpoints" -> {v1, v2}, "momentum" -> q,
        "nu" -> nuM, "bbType" -> "h", "massType" -> "massive"|>,
      <|"id" -> 2, "endpoints" -> {v1, v2}, "momentum" -> q - k,
        "nu" -> 0, "bbType" -> "exp", "massType" -> "massless"|>
      },
    "loopMomenta" -> {q},
    "externalMomenta" -> {k},
    "externalInvariantRules" -> {sp[k, k] -> s11},
    "vertexEnergies" -> <|v1 -> E1, v2 -> E2|>,
    "zeroPointRules" -> {
      a0[v1] -> alpha1,
      a0[v2] -> alpha2,
      b0[1] -> beta1,
      b0[2] -> beta2,
      bS0[2] -> beta2
      },
    "symmetryRules" -> {},
    "seedPreset" -> "quickCheck"
    |>
   ];
