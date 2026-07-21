(* ::Package:: *)
(* pure_massless_bubble：只定义独立 benchmark 的输入。 *)

(* ::Chapter:: *)
(*函数族定义*)

pureMasslessBubbleSigns = <|
   "++" -> {"+", "+"},
   "--" -> {"-", "-"},
   "+-" -> {"+", "-"},
   "-+" -> {"-", "+"}
   |>;

makePureMasslessBubbleCase[signKey_String] := Module[
   {signs = pureMasslessBubbleSigns[signKey]},
   <|
    "name" -> "pureMasslessBubble" <> signKey,
    "vertexData" -> {{v1, signs[[1]]}, {v2, signs[[2]]}},
    "lineData" -> {
      <|"id" -> 1, "endpoints" -> {v1, v2}, "momentum" -> q,
        "nu" -> 0, "bbType" -> "exp", "massType" -> "massless"|>,
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
      bS0[1] -> beta1,
      bS0[2] -> beta2
      },
    "symmetryRules" -> {},
    "seedPreset" -> "quickCheck"
    |>
   ];
