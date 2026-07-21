(* ::Package:: *)
(* 本文件只保存两个 atomic family 的任务书输入，用于独立 oracle 自校验。 *)


(* ::Chapter:: *)
(*Atomic massive*)

atomicMassiveFamily[mode_] := <|
   "name" -> "atomic_massive_line",
   "vertexOrder" -> {v1, v2},
   "vertexSignCases" -> <|"--" -> {-1, -1}, "-+" -> {-1, 1}|>,
   "loopMomenta" -> {ell},
   "externalMomenta" -> {},
   "externalInvariantRules" -> {},
   "vertexEnergies" -> <|v1 -> E1, v2 -> E2|>,
   "lineOrder" -> {1},
   "lineData" -> {
     <|"id" -> 1, "endpoints" -> {v1, v2}, "momentum" -> ell,
      "massType" -> "massive", "bbType" -> mode, "nu" -> nuM|>
     },
   "ispData" -> {},
   "zeroPointRules" -> {
     a0[v1] -> alpha1, a0[v2] -> alpha2, b0[1] -> beta1
     },
   "basisRoutes" -> {"h", "HIdentity", "HToh"},
   "topIntegralTemplate" -> <|
     "sameBranch" -> HoldForm[J[{a1, a2}, {{b1, n11, n12}}, {}]],
     "crossBranch" -> HoldForm[J[{a1, a2}, {{b1, n11, n12}}, {}]]
     |>,
   "sectorNaming" -> <|"--" -> {"top", "e1"}, "-+" -> {"top"}|>,
   "generatorList" -> {dtau[v1], dtau[v2], dqq[1, 1]},
   "symmetryRules" -> {}
   |>;


(* ::Chapter:: *)
(*Atomic massless*)

atomicMasslessFamily = <|
   "name" -> "atomic_massless_line",
   "vertexOrder" -> {v1, v2},
   "vertexSignCases" -> <|"++" -> {1, 1}, "+-" -> {1, -1}|>,
   "loopMomenta" -> {ell},
   "externalMomenta" -> {},
   "externalInvariantRules" -> {},
   "vertexEnergies" -> <|v1 -> E1, v2 -> E2|>,
   "lineOrder" -> {1},
   "lineData" -> {
     <|"id" -> 1, "endpoints" -> {v1, v2}, "momentum" -> ell,
      "massType" -> "massless", "bbType" -> "exp", "nu" -> 0|>
     },
   "ispData" -> {},
   "zeroPointRules" -> {
     a0[v1] -> alpha1, a0[v2] -> alpha2, b0[1] -> beta1
     },
   "topIntegralTemplate" -> <|
     "sameBranch" -> HoldForm[J[{a1, a2}, {{b1, n1}}, {}]],
     "crossBranch" -> HoldForm[J[{a1, a2}, {{b1}}, {}]]
     |>,
   "sectorNaming" -> <|"++" -> {"top", "e1"}, "+-" -> {"top"}|>,
   "generatorList" -> {dtau[v1], dtau[v2], dqq[1, 1]},
   "symmetryRules" -> {}
   |>;
