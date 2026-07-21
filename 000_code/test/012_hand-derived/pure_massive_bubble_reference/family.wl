(* ::Package:: *)
(* pure_massive_bubble_reference：统一 J 表示下的纯 massive bubble 输入。 *)

(* ::Chapter:: *)
(*函数族定义*)

pureMassiveBubbleSigns = <|
   "++" -> {"+", "+"},
   "--" -> {"-", "-"},
   "+-" -> {"+", "-"},
   "-+" -> {"-", "+"}
   |>;

pureMassiveBubbleDefinition = <|
   "name" -> "pureMassiveBubbleReference",
   "vertexOrder" -> {v1, v2},
   "vertexSignCases" -> pureMassiveBubbleSigns,
   "loopMomenta" -> {q},
   "externalMomenta" -> {k},
   "externalInvariantRules" -> {sp[k, k] -> s11},
   "vertexEnergies" -> <|v1 -> E1, v2 -> E2|>,
   "lineData" -> {
     <|"id" -> 1, "endpoints" -> {v1, v2}, "momentum" -> q,
       "massType" -> "massive", "bbType" -> "h", "nu" -> nuM|>,
     <|"id" -> 2, "endpoints" -> {v1, v2}, "momentum" -> q - k,
       "massType" -> "massive", "bbType" -> "h", "nu" -> nuM|>
     },
   "ispData" -> {},
   "zeroPointRules" -> {
     a0[v1] -> alpha1, a0[v2] -> alpha2,
     b0[1] -> beta1, b0[2] -> beta2
     },
   "symmetryRules" -> {}
   |>;

pureMassiveBubbleDefinitionForMode[mode_String] := Join[
   pureMassiveBubbleDefinition,
   <|
    "name" -> "pureMassiveBubbleReference" <> mode,
    "lineData" -> (Join[#, <|"bbType" -> mode|>] & /@ pureMassiveBubbleDefinition["lineData"])
    |>
   ];


makePureMassiveBubbleReferenceCase[signKey_String, mode_String : "h"] := Module[
   {signs = pureMassiveBubbleSigns[signKey], definition = pureMassiveBubbleDefinitionForMode[mode]},
   <|
    "name" -> "pureMassiveBubbleReference" <> mode <> signKey,
    "vertexData" -> {{v1, signs[[1]]}, {v2, signs[[2]]}},
    "lineData" -> definition["lineData"],
    "loopMomenta" -> definition["loopMomenta"],
    "externalMomenta" -> definition["externalMomenta"],
    "externalInvariantRules" -> definition["externalInvariantRules"],
    "vertexEnergies" -> definition["vertexEnergies"],
    "zeroPointRules" -> definition["zeroPointRules"],
    "symmetryRules" -> {},
    "seedPreset" -> "quickCheck"
    |>
   ];
