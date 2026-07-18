(* ::Package:: *)
(* parallel_massless_bundle_guard：三条平行 massless 线的逐线 shrink guard。 *)

(* ::Chapter:: *)
(*函数族定义*)

parallelMasslessSigns = <|
   "++" -> {"+", "+"},
   "--" -> {"-", "-"},
   "+-" -> {"+", "-"},
   "-+" -> {"-", "+"}
   |>;

parallelMasslessDefinition = <|
   "name" -> "parallelMasslessBundleGuard",
   "vertexOrder" -> {v1, v2},
   "vertexSignCases" -> parallelMasslessSigns,
   "loopMomenta" -> {q},
   "externalMomenta" -> {k1, k2},
   "externalInvariantRules" -> {sp[k1, k1] -> s11, sp[k1, k2] -> s12, sp[k2, k2] -> s22},
   "vertexEnergies" -> <|v1 -> E1, v2 -> E2|>,
   "lineData" -> {
     <|"id" -> 1, "endpoints" -> {v1, v2}, "momentum" -> q,
       "massType" -> "massless", "bbType" -> "exp", "nu" -> 0|>,
     <|"id" -> 2, "endpoints" -> {v1, v2}, "momentum" -> q - k1,
       "massType" -> "massless", "bbType" -> "exp", "nu" -> 0|>,
     <|"id" -> 3, "endpoints" -> {v1, v2}, "momentum" -> q - k2,
       "massType" -> "massless", "bbType" -> "exp", "nu" -> 0|>
     },
   "ispData" -> {},
   "zeroPointRules" -> {
     a0[v1] -> alpha1, a0[v2] -> alpha2,
     b0[1] -> beta1, b0[2] -> beta2, b0[3] -> beta3,
     bS0[1] -> beta1, bS0[2] -> beta2, bS0[3] -> beta3
     },
   "symmetryRules" -> {}
   |>;

makeParallelMasslessBundleGuardCase[signKey_String] := Module[
   {signs = parallelMasslessSigns[signKey]},
   <|
    "name" -> "parallelMasslessBundleGuard" <> signKey,
    "vertexData" -> {{v1, signs[[1]]}, {v2, signs[[2]]}},
    "lineData" -> parallelMasslessDefinition["lineData"],
    "loopMomenta" -> parallelMasslessDefinition["loopMomenta"],
    "externalMomenta" -> parallelMasslessDefinition["externalMomenta"],
    "externalInvariantRules" -> parallelMasslessDefinition["externalInvariantRules"],
    "vertexEnergies" -> parallelMasslessDefinition["vertexEnergies"],
    "zeroPointRules" -> parallelMasslessDefinition["zeroPointRules"],
    "symmetryRules" -> {},
    "seedPreset" -> "quickCheck"
    |>
   ];
