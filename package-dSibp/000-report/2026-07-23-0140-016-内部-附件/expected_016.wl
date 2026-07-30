(* ::Chapter:: *)
(*016 独立 expected*)

(* 本文件只保存由任务书与公开定义独立推出的数据，不调用 package。 *)

ClearAll[expected016];

expected016 = <|
  "graphTheory" -> <|
    "main" -> <|
      "vertices" -> {v1, v2, v3},
      "edges" -> {e1, e2, e3},
      "incidence" -> {{-1, 1, 0}, {1, -1, -1}, {0, 0, 1}},
      "counts" -> <|"E" -> 3, "V" -> 3, "C" -> 1, "L" -> 1|>,
      "cycleBasis" -> {{1, 1, 0}},
      "cycleLines" -> {e1, e2},
      "bridges" -> {e3}
    |>,
    "selfLoop" -> <|
      "incidence" -> {{0}},
      "counts" -> <|"E" -> 1, "V" -> 1, "C" -> 1, "L" -> 1|>,
      "cycleLines" -> {s1}, "bridges" -> {}
    |>,
    "threeParallel" -> <|
      "incidence" -> {{-1, -1, -1}, {1, 1, 1}},
      "counts" -> <|"E" -> 3, "V" -> 2, "C" -> 1, "L" -> 2|>,
      "cycleLines" -> {p1, p2, p3}, "bridges" -> {}
    |>
  |>,
  "routing" -> <|
    "loopCoefficientMatrix" -> {{1}, {1}, {0}},
    "shiftVector" -> {arc, arc + spur, wing1 + wing2},
    "referenceRows" -> {1},
    "transformedShift" -> {0, spur, wing1 + wing2},
    "requiredLoopExternalMomenta" -> {spur},
    "rationalSignProbe" -> <|
      "loopCoefficients" -> {2, -3},
      "shifts" -> {arc, spur},
      "residualSecond" -> spur + 3 arc/2
    |>,
    "negativeCases" -> <|
      "loopCountMismatch" -> <|"declared" -> 2, "structural" -> 1|>,
      "bridgeFlow" -> {1, 1, 1},
      "illegalCycleSupport" -> {1, -1, 0},
      "illegalCycleResidual" -> {-2, 2, 0}
    |>
  |>,
  "declarations" -> <|
    "loopExternal" -> <|
      "exact" -> <|"declared" -> {spur}, "status" -> "exact", "initializationUsableQ" -> True, "symbolicSeedsQ" -> True, "derivativeUsableQ" -> True, "inverseAvailableQ" -> True|>,
      "over" -> <|"declared" -> {spur, arc}, "status" -> "overcomplete", "warningQ" -> True, "initializationUsableQ" -> True, "symbolicSeedsQ" -> True, "derivativeUsableQ" -> False, "inverseAvailableQ" -> False|>,
      "under" -> <|"declared" -> {}, "status" -> "undercomplete", "missingDirections" -> {spur}, "nullCertificate" -> {0, 1}, "initializationUsableQ" -> False, "symbolicSeedsQ" -> False, "derivativeUsableQ" -> False, "inverseAvailableQ" -> False|>
    |>,
    "independentExternal" -> <|
      "actualMagnitudes" -> {mag2[wing1], mag2[wing2], mag2[wing1 + wing2]},
      "exact" -> <|"declared" -> {wing1, wing2, wing1 + wing2}, "status" -> "exact"|>,
      "over" -> <|"declared" -> {wing1, wing2, wing1 + wing2, decoy}, "status" -> "overcomplete", "warningQ" -> True|>,
      "under" -> <|"declared" -> {wing1, wing2}, "status" -> "undercomplete", "missingDirections" -> {wing1 + wing2}|>,
      "overallSignCanonicalQ" -> True,
      "sumDifferenceDistinctQ" -> True,
      "synthesizedCrossGram" -> {}
    |>,
    "undercompleteCapabilityGate" -> <|
      "initializationUsableQ" -> False,
      "blocked" -> {DSSeeds, dtau, dqq, dqk, ds, DSDE, DSLinear, DSKiraExport}
    |>
  |>,
  "packs" -> <|
    "rootIntegral" -> J[{a1, a2, a3}, {{b1, n11, n12}, {b2, n2}, {n31, n32}}, {z1}],
    "cycleMassive" -> {b, n1, n2},
    "cycleMasslessFull" -> {b, n},
    "fixedMassive" -> {n1, n2},
    "fixedMasslessCross" -> {},
    "momentumTraversal" -> {e1, e2, rho1},
    "timeTraversal" -> <|v1 -> {e1, e2}, v2 -> {e1, e2, e3}, v3 -> {e3}|>,
    "allCycleShrunkIntegral" -> J[{a12, a3}, {{bS1}, {bS2}, {n31, n32}}, {z1}],
    "inheritedAfterAllCycleShrink" -> <|"L" -> 1, "cycleLines" -> {e1, e2}, "fixedLines" -> {e3}|>
  |>,
  "fixedMassiveH" -> <|
    "firstOrderSystem" -> {Derivative[1][f0][x] == f1[x], Derivative[1][f1][x] == -f0[x] - (2 nu + 1) f1[x]/x},
    "endpointTime" -> <|
      0 -> {-r fixedState[1]},
      1 -> {r fixedState[0], (2 nu + 1) shiftA[-1] fixedState[1]}
    |>,
    "radialDerivative" -> <|
      {0, 0} -> {-B/r fixedJ[0, 0], shiftAU[1] fixedJ[1, 0], shiftAV[1] fixedJ[0, 1]},
      {1, 0} -> {-(B + 2 nu + 1)/r fixedJ[1, 0], -shiftAU[1] fixedJ[0, 0], shiftAV[1] fixedJ[1, 1]},
      {0, 1} -> {-(B + 2 nu + 1)/r fixedJ[0, 1], shiftAU[1] fixedJ[1, 1], -shiftAV[1] fixedJ[0, 0]},
      {1, 1} -> {-(B + 2 (2 nu + 1))/r fixedJ[1, 1], -shiftAU[1] fixedJ[0, 1], -shiftAV[1] fixedJ[1, 0]}
    |>,
    "physicalPowerShift" -> HoldForm[coefficientFactor[DeltaB] == r^(-DeltaB)]
  |>,
  "timeOnly" -> <|
    "twoVertexIntegral" -> J[{{a1, n11}, {a2, n12}}],
    "threeVertexIntegral" -> J[{{a1, n121}, {a2, n122, n231}, {a3, n232}}],
    "twoVertexMasterBits" -> Tuples[{0, 1}, 2],
    "threeVertexMasterBits" -> Tuples[{0, 1}, 4],
    "binaryIndex" -> HoldForm[1 + Sum[bit[j] 2^(legCount - j), {j, 1, legCount}]],
    "forbiddenStructures" -> {b, bS, dqq, dqk, ISP},
    "allLineMagnitudesAuditedQ" -> True,
    "deterministicProbe" -> <|
      "twoVertex" -> <|"A" -> {7/3, 11/5}, "signs" -> {1, 1}, "energies" -> {13/7, 17/11}, "nus" -> {{2/5}, {3/7}}, "radii" -> {{19/13}, {19/13}}|>,
      "threeVertex" -> <|"A" -> {5/4, 7/5, 9/7}, "signs" -> {1, 1, -1}, "energies" -> {11/6, 13/8, 17/9}, "nus" -> {{1/3}, {2/5, 3/8}, {4/9}}, "radii" -> {{19/10}, {19/10, 23/12}, {23/12}}|>
    |>
  |>,
  "notation" -> <|
    9 -> <|"gram" -> {ss19}, "independent" -> {sE9}|>,
    10 -> <|"gram" -> {ss0101, ss0110}, "independent" -> {sE01}|>,
    100 -> <|"gram" -> {ss001100}, "independent" -> {sE001}|>
  |>,
  "redefinition" -> <|
    "coordinates" -> {ss11, sE1, sE2, sE3},
    "parameters" -> {u, v, w, z},
    "rules" -> {ss11 -> u + v, sE1 -> u - v, sE2 -> u + w, sE3 -> u + z},
    "jacobian" -> {{1, 1, 0, 0}, {1, -1, 0, 0}, {1, 0, 1, 0}, {1, 0, 0, 1}},
    "determinant" -> -2,
    "uChainWeights" -> {1, 1, 1, 1},
    "undercomplete" -> <|"rules" -> {ss11 -> u + v, sE1 -> u - v, sE2 -> u + w}, "missingCoordinates" -> {sE3}, "usableQ" -> False|>,
    "overcomplete" -> <|
      "parameters" -> {u, v, w, z, t},
      "rules" -> {ss11 -> u + v + t, sE1 -> u - v, sE2 -> u + w, sE3 -> u + z},
      "jacobian" -> {{1, 1, 0, 0, 1}, {1, -1, 0, 0, 0}, {1, 0, 1, 0, 0}, {1, 0, 0, 1, 0}},
      "rightNullVector" -> {1, 1, -1, -1, -2},
      "inverseAvailableQ" -> False,
      "derivativeUsableQ" -> False
    |>,
    "productRule" -> HoldForm[
      D[c[u], u] j1 + D[d[u], u] j2 +
      c[u] Sum[partial[coord][j1], {coord, {ss11, sE1, sE2, sE3}}] +
      d[u] Sum[partial[coord][j2], {coord, {ss11, sE1, sE2, sE3}}]
    ]
  |>
|>;

