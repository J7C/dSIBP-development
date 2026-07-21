(* ::Package:: *)
(* atomic_massive_line：只定义 h/H massive 单线函数族。 *)

(* ::Chapter:: *)
(*函数族定义*)

atomicMassiveSigns = <|
   "++" -> {"+", "+"},
   "--" -> {"-", "-"},
   "+-" -> {"+", "-"},
   "-+" -> {"-", "+"}
   |>;

makeAtomicMassiveCase[signKey_String, mode_String] := Module[
   {signs = atomicMassiveSigns[signKey]},
   <|
    "name" -> "atomicMassiveLine" <> mode <> signKey,
    "vertexData" -> {{v1, signs[[1]]}, {v2, signs[[2]]}},
    "lineData" -> {
      <|
       "id" -> 1,
       "endpoints" -> {v1, v2},
       "momentum" -> ell,
       "nu" -> nuM,
       "bbType" -> mode,
       "massType" -> "massive"
       |>
      },
    "loopMomenta" -> {ell},
    "externalMomenta" -> {},
    "vertexEnergies" -> <|v1 -> E1, v2 -> E2|>,
    "zeroPointRules" -> {
      a0[v1] -> alpha1,
      a0[v2] -> alpha2,
      b0[1] -> beta
      },
    "seedPreset" -> "quickCheck"
    |>
   ];
