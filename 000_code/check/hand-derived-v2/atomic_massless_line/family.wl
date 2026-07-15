(* ::Package:: *)
(* atomic_massless_line：只定义独立 benchmark 的函数族输入。 *)

(* ::Chapter:: *)
(*函数族定义*)

atomicMasslessSigns = <|
   "++" -> {"+", "+"},
   "--" -> {"-", "-"},
   "+-" -> {"+", "-"},
   "-+" -> {"-", "+"}
   |>;

makeAtomicMasslessCase[signKey_String, reversed_: False] := Module[
   {signs = atomicMasslessSigns[signKey], endpoints},
   endpoints = If[TrueQ[reversed], {v2, v1}, {v1, v2}];
   <|
    "name" -> "atomicMasslessLine" <> signKey <> If[TrueQ[reversed], "Reversed", ""],
    "vertexData" -> {{v1, signs[[1]]}, {v2, signs[[2]]}},
    "lineData" -> {
      <|
       "id" -> 1,
       "endpoints" -> endpoints,
       "momentum" -> ell,
       "nu" -> 0,
       "bbType" -> "exp",
       "massType" -> "massless"
       |>
      },
    "loopMomenta" -> {ell},
    "externalMomenta" -> {},
    "vertexEnergies" -> <|v1 -> E1, v2 -> E2|>,
    "zeroPointRules" -> {
      a0[v1] -> alpha1,
      a0[v2] -> alpha2,
      b0[1] -> beta,
      bS0[1] -> beta
      },
    "seedPreset" -> "quickCheck"
    |>
   ];
