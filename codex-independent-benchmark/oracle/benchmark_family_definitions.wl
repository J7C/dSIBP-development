(* ::Package:: *)
(* 本文件逐项录入独立 benchmark 第 9 节的非 atomic family。这里只保存固定 topology
   与 seed 点，不包含 expected、package 调用或由 actual 反推的 metadata。 *)


(* ::Chapter:: *)
(*固定 sign cases；每个 family 自己保存任务书第 9.0 节选定的两项。*)


(* ::Chapter:: *)
(*One-loop bubbles*)

pureMasslessBubbleFamily = <|
   "name" -> "pure_massless_bubble",
   "vertexOrder" -> {v1, v2},
   "vertexSignCases" -> <|"--" -> {-1, -1}, "+-" -> {1, -1}|>,
   "loopMomenta" -> {q}, "externalMomenta" -> {k},
   "externalInvariantRules" -> {sp[k, k] -> s11},
   "vertexEnergies" -> <|v1 -> E1, v2 -> E2|>,
   "lineOrder" -> {1, 2},
   "lineData" -> {
     <|"id" -> 1, "endpoints" -> {v1, v2}, "momentum" -> q,
      "massType" -> "massless", "bbType" -> "exp", "nu" -> 0|>,
     <|"id" -> 2, "endpoints" -> {v1, v2}, "momentum" -> q - k,
      "massType" -> "massless", "bbType" -> "exp", "nu" -> 0|>
     },
   "ispData" -> {},
   "zeroPointRules" -> {
     a0[v1] -> alpha1, a0[v2] -> alpha2,
     b0[1] -> beta1, b0[2] -> beta2
     },
   "topIntegralTemplate" -> <|
     "sameBranch" -> HoldForm[J[{a1, a2}, {{b1, n1}, {b2, n2}}, {}]],
     "crossBranch" -> HoldForm[J[{a1, a2}, {{b1}, {b2}}, {}]]
     |>,
   "sectorNaming" -> <|"--" -> {"top", "e1", "e2"}, "+-" -> {"top"}|>,
   "generatorList" -> {dtau[v1], dtau[v2], dqq[1, 1], dqk[1, 1]},
   "symmetryRules" -> {}
   |>;

mixedBubbleFamily = Join[
   pureMasslessBubbleFamily,
   <|
    "name" -> "mixed_bubble",
    "vertexSignCases" -> <|"++" -> {1, 1}, "-+" -> {-1, 1}|>,
    "lineData" -> {
      <|"id" -> 1, "endpoints" -> {v1, v2}, "momentum" -> q,
       "massType" -> "massive", "bbType" -> "h", "nu" -> nuM|>,
      <|"id" -> 2, "endpoints" -> {v1, v2}, "momentum" -> q - k,
       "massType" -> "massless", "bbType" -> "exp", "nu" -> 0|>
      },
    "topIntegralTemplate" -> <|
      "sameBranch" -> HoldForm[J[{a1, a2}, {{b1, n11, n12}, {b2, n2}}, {}]],
      "crossBranch" -> HoldForm[J[{a1, a2}, {{b1, n11, n12}, {b2}}, {}]]
      |>,
    "sectorNaming" -> <|"++" -> {"top", "e1", "e2"}, "-+" -> {"top"}|>
    |>
   ];

pureMassiveBubbleReferenceFamily = Join[
   pureMasslessBubbleFamily,
   <|
    "name" -> "pure_massive_bubble_reference",
    "vertexSignCases" -> <|"--" -> {-1, -1}, "-+" -> {-1, 1}|>,
    "lineData" -> {
      <|"id" -> 1, "endpoints" -> {v1, v2}, "momentum" -> q,
       "massType" -> "massive", "bbType" -> "h", "nu" -> nuM|>,
      <|"id" -> 2, "endpoints" -> {v1, v2}, "momentum" -> q - k,
       "massType" -> "massive", "bbType" -> "h", "nu" -> nuM|>
      },
    "basisRoutes" -> {"h", "HIdentity", "HToh"},
    "topIntegralTemplate" -> <|
      "sameBranch" -> HoldForm[J[{a1, a2}, {{b1, n11, n12}, {b2, n21, n22}}, {}]],
      "crossBranch" -> HoldForm[J[{a1, a2}, {{b1, n11, n12}, {b2, n21, n22}}, {}]]
      |>,
    "sectorNaming" -> <|"--" -> {"top", "e1", "e2"}, "-+" -> {"top"}|>
    |>
   ];


(* ::Chapter:: *)
(*Mixed triangle*)

mixedTriangleFamily = <|
   "name" -> "mixed_triangle",
   "vertexOrder" -> {v1, v2, v3},
   "vertexSignCases" -> <|"---" -> {-1, -1, -1}, "+-+" -> {1, -1, 1}|>,
   "loopMomenta" -> {q}, "externalMomenta" -> {k1, k2},
   "externalInvariantRules" -> {
     sp[k1, k1] -> s11, sp[k1, k2] -> s12, sp[k2, k2] -> s22
     },
   "vertexEnergies" -> <|v1 -> E1, v2 -> E2, v3 -> E3|>,
   "lineOrder" -> {1, 2, 3},
   "lineData" -> {
     <|"id" -> 1, "endpoints" -> {v1, v2}, "momentum" -> q,
      "massType" -> "massive", "bbType" -> "h", "nu" -> nuM|>,
     <|"id" -> 2, "endpoints" -> {v2, v3}, "momentum" -> q - k1,
      "massType" -> "massive", "bbType" -> "h", "nu" -> nuM|>,
     <|"id" -> 3, "endpoints" -> {v3, v1}, "momentum" -> q + k2,
      "massType" -> "massless", "bbType" -> "exp", "nu" -> 0|>
     },
   "ispData" -> {},
   "zeroPointRules" -> {
     a0[v1] -> alpha1, a0[v2] -> alpha2, a0[v3] -> alpha3,
     b0[1] -> beta1, b0[2] -> beta2, b0[3] -> beta3
     },
   "topIntegralTemplate" -> <|
     "sameBranch" -> HoldForm[J[{a1, a2, a3}, {{b1, n11, n12}, {b2, n21, n22}, {b3, n3}}, {}]],
     "mixedBranch" -> HoldForm[J[{a1, a2, a3}, {{b1}, {b2}, {b3}}, {}]]
     |>,
   "sectorNaming" -> "top or a contact-reachable forest, named by sorted original line ids",
   "generatorList" -> {dtau[v1], dtau[v2], dtau[v3], dqq[1, 1], dqk[1, 1], dqk[1, 2]},
   "symmetryRules" -> {}
   |>;


(* ::Chapter:: *)
(*Two-loop ISP families*)

mixedSunriseFamily = <|
   "name" -> "mixed_sunrise",
   "vertexOrder" -> {v1, v2},
   "vertexSignCases" -> <|"++" -> {1, 1}, "+-" -> {1, -1}|>,
   "loopMomenta" -> {q1, q2}, "externalMomenta" -> {k},
   "externalInvariantRules" -> {sp[k, k] -> s11},
   "vertexEnergies" -> <|v1 -> E1, v2 -> E2|>,
   "lineOrder" -> {1, 2, 3},
   "lineData" -> {
     <|"id" -> 1, "endpoints" -> {v1, v2}, "momentum" -> q1,
      "massType" -> "massive", "bbType" -> "h", "nu" -> nuM|>,
     <|"id" -> 2, "endpoints" -> {v1, v2}, "momentum" -> q2,
      "massType" -> "massless", "bbType" -> "exp", "nu" -> 0|>,
     <|"id" -> 3, "endpoints" -> {v1, v2}, "momentum" -> q1 - q2 - k,
      "massType" -> "massless", "bbType" -> "exp", "nu" -> 0|>
     },
   "ispData" -> {
     <|"id" -> 1, "expression" -> sp[q1, k]|>,
     <|"id" -> 2, "expression" -> sp[q2, k]|>
     },
   "ispSeedPoints" -> {{0, 0}, {1, 0}, {0, 1}},
   "zeroPointRules" -> {
     a0[v1] -> alpha1, a0[v2] -> alpha2,
     b0[1] -> beta1, b0[2] -> beta2, b0[3] -> beta3
     },
   "topIntegralTemplate" -> <|
     "sameBranch" -> HoldForm[J[{a1, a2}, {{b1, n11, n12}, {b2, n2}, {b3, n3}}, {r1, r2}]],
     "crossBranch" -> HoldForm[J[{a1, a2}, {{b1, n11, n12}, {b2}, {b3}}, {r1, r2}]]
     |>,
   "sectorNaming" -> "top or an odd-subset contact-reachable sector",
   "generatorList" -> {dtau[v1], dtau[v2], dqq[1, 1], dqq[1, 2], dqk[1, 1], dqq[2, 1], dqq[2, 2], dqk[2, 1]},
   "symmetryRules" -> {}
   |>;

twoLoopISPToyFamily = <|
   "name" -> "two_loop_isp_toy",
   "vertexOrder" -> {v1, v2},
   "vertexSignCases" -> <|"++" -> {1, 1}, "-+" -> {-1, 1}|>,
   "loopMomenta" -> {l3, k321}, "externalMomenta" -> {wdnmd},
   "externalInvariantRules" -> {sp[wdnmd, wdnmd] -> s11},
   "vertexEnergies" -> <|v1 -> E1, v2 -> E2|>,
   "lineOrder" -> {1, 2, 3},
   "lineData" -> {
     <|"id" -> 1, "endpoints" -> {v1, v2}, "momentum" -> l3,
      "massType" -> "massless", "bbType" -> "exp", "nu" -> 0|>,
     <|"id" -> 2, "endpoints" -> {v1, v2}, "momentum" -> k321,
      "massType" -> "massless", "bbType" -> "exp", "nu" -> 0|>,
     <|"id" -> 3, "endpoints" -> {v1, v2}, "momentum" -> l3 - k321 - wdnmd,
      "massType" -> "massless", "bbType" -> "exp", "nu" -> 0|>
     },
   "ispData" -> {
     <|"id" -> 1, "expression" -> sp[l3, k321 + l3]|>,
     <|"id" -> 2, "expression" -> sp[l3, wdnmd]|>
     },
   "ispSeedPoints" -> {{0, 0}, {1, 0}, {0, 1}},
   "zeroPointRules" -> {
     a0[v1] -> alpha1, a0[v2] -> alpha2,
     b0[1] -> beta1, b0[2] -> beta2, b0[3] -> beta3
     },
   "topIntegralTemplate" -> <|
     "sameBranch" -> HoldForm[J[{a1, a2}, {{b1, n1}, {b2, n2}, {b3, n3}}, {r1, r2}]],
     "crossBranch" -> HoldForm[J[{a1, a2}, {{b1}, {b2}, {b3}}, {r1, r2}]]
     |>,
   "sectorNaming" -> "top or an odd-subset contact-reachable sector",
   "generatorList" -> {dtau[v1], dtau[v2], dqq[1, 1], dqq[1, 2], dqk[1, 1], dqq[2, 1], dqq[2, 2], dqk[2, 1]},
   "symmetryRules" -> {}
   |>;


(* ::Chapter:: *)
(*Three-line common-theta guard*)

parallelMasslessBundleFamily = <|
   "name" -> "parallel_massless_bundle_guard",
   "vertexOrder" -> {v1, v2},
   "vertexSignCases" -> <|"--" -> {-1, -1}, "+-" -> {1, -1}|>,
   "loopMomenta" -> {q}, "externalMomenta" -> {k1, k2},
   "externalInvariantRules" -> {
     sp[k1, k1] -> s11, sp[k1, k2] -> s12, sp[k2, k2] -> s22
     },
   "vertexEnergies" -> <|v1 -> E1, v2 -> E2|>,
   "lineOrder" -> {1, 2, 3},
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
     b0[1] -> beta1, b0[2] -> beta2, b0[3] -> beta3
     },
   "topIntegralTemplate" -> <|
     "sameBranch" -> HoldForm[J[{a1, a2}, {{b1, n1}, {b2, n2}, {b3, n3}}, {}]],
     "crossBranch" -> HoldForm[J[{a1, a2}, {{b1}, {b2}, {b3}}, {}]]
     |>,
   "sectorNaming" -> <|
     "--" -> {"top", "e1", "e2", "e3", "e1_e2_e3"},
     "+-" -> {"top"}
     |>,
   "generatorList" -> {dtau[v1], dtau[v2], dqq[1, 1], dqk[1, 1], dqk[1, 2]},
   "symmetryRules" -> {}
   |>;


(* ::Chapter:: *)
(*Vertex-energy sign cases*)

vertexEnergyFamily[energyName_, energies_Association] := <|
   "name" -> "vertex_energy_signs_" <> energyName,
   "benchmarkFamilyName" -> "vertex_energy_signs",
   "energyCase" -> energyName,
   "vertexOrder" -> {v1, v2},
   "vertexSignCases" -> <|"++" -> {1, 1}, "-+" -> {-1, 1}|>,
   "loopMomenta" -> {ell}, "externalMomenta" -> {k},
   "externalInvariantRules" -> {sp[k, k] -> s11},
   "vertexEnergies" -> energies,
   "lineOrder" -> {1},
   "lineData" -> {
     <|"id" -> 1, "endpoints" -> {v1, v2}, "momentum" -> ell - k,
      "massType" -> "massless", "bbType" -> "exp", "nu" -> 0|>
     },
   "ispData" -> {
     <|"id" -> 1, "expression" -> sp[ell, k]|>
     },
   "ispSeedPoints" -> {{0}, {1}},
   "zeroPointRules" -> {
     a0[v1] -> alpha1, a0[v2] -> alpha2, b0[1] -> beta1
     },
   "topIntegralTemplate" -> <|
     "sameBranch" -> HoldForm[J[{a1, a2}, {{b1, n1}}, {r1}]],
     "crossBranch" -> HoldForm[J[{a1, a2}, {{b1}}, {r1}]]
     |>,
   "sectorNaming" -> <|"++" -> {"top", "e1"}, "-+" -> {"top"}|>,
   "generatorList" -> {dtau[v1], dtau[v2], dqq[1, 1], dqk[1, 1]},
   "symmetryRules" -> {}
   |>;

vertexEnergyFamilies = {
   vertexEnergyFamily["A", <|v1 -> ke[1], v2 -> ke[2]|>],
   vertexEnergyFamily["B", <|v1 -> Sqrt[s11], v2 -> ke[2]|>],
   vertexEnergyFamily["C", <|v1 -> ke[3], v2 -> ke[2]|>]
   };
