(* ::Package:: *)
(* 本文件只保存 atomic_massive_line 的独立 benchmark 输入。它不加载 package，
   也不包含由程序 actual 反推的规则；mode 在 h/H 两个值上分别实例化。 *)

ClearAll["Global`*"];


(* ::Chapter:: *)
(*函数族固定输入*)

(* ::Section::Closed:: *)
(*拓扑、指标与生成元*)
familyDefinition = <|
   "name" -> "atomic_massive_line",
   "vertexOrder" -> {v1, v2},
   "vertexSignCases" -> <|"--" -> {-1, -1}, "-+" -> {-1, +1}|>,
   "loopMomenta" -> {ell},
   "externalMomenta" -> {},
   "externalInvariantRules" -> {},
   "vertexEnergies" -> <|v1 -> E1, v2 -> E2|>,
   "lineOrder" -> {1},
   "lineData" -> {
     <|
      "id" -> 1, "endpoints" -> {v1, v2}, "momentum" -> ell,
      "massType" -> "massive", "bbType" -> mode, "nu" -> nuM
      |>
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
   "sectorNaming" -> <|
     "--" -> {"top", "e1"}, "-+" -> {"top"}
     |>,
   "generatorList" -> {dtau[v1], dtau[v2], dqq[1, 1]},
   "symmetryRules" -> {}
   |>;

familyDefinition
