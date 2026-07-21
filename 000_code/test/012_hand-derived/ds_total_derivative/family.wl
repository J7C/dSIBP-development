(* ::Package:: *)
(* ds_total_derivative：提供外部变量 s11、单个 J 与带系数线性组合的独立测试输入。*)

(* ::Chapter:: *)
(*函数族定义*)

makeDSTotalDerivativeCase[] := <|
   "name" -> "dsTotalDerivative",
   "vertexData" -> {{v, "+"}},
   "lineData" -> {
     <|
      "id" -> 1,
      "endpoints" -> {v, v},
      "momentum" -> ell,
      "massType" -> "massless",
      "state" -> "shrunk",
      "bbType" -> "exp",
      "nu" -> 0
      |>
     },
   "loopMomenta" -> {ell},
   "externalMomenta" -> {k},
   "externalInvariantRules" -> {sp[k, k] -> s11},
   "vertexEnergies" -> <|v -> Sqrt[s11]|>,
   "ispData" -> {
     <|"name" -> rhoEllK, "expr" -> sp[ell, k], "range" -> {0}|>
     },
   "zeroPointRules" -> {a0[v] -> alpha, bS0[1] -> beta},
   "symmetryRules" -> {},
   "seedPreset" -> "quickCheck"
   |>;


makeDSTotalDerivativeIntegrals[topo_Association] := Module[{base},
   base = makeBaseIntegral[topo];
   <|
    "J0" -> (base /. {a[v] -> 0, bS[1] -> 0, ispN[1] -> 0}),
    "J1" -> (base /. {a[v] -> 1, bS[1] -> 2, ispN[1] -> 0})
    |>
   ];
