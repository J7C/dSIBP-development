(* ::Package:: *)
(* 013 pure time-IBP/tree 正式专项。文件先以独立手推公式构造两组固定 family 的 loop/tree expected，
   再加载 package 逐项比较 8 条与 48 条 time seeds，并检查 general 迭代、零点显式系数和 mixed-SK 门禁。 *)

(* ::Chapter:: *)
(*加载 package 前的手推公式*)

ClearAll["Global`*"];


benchShiftA[J[a_List, p_List, r_List], v_Integer, delta_] :=
 J[ReplacePart[a, v -> a[[v]] + delta], p, r];


benchShiftMassiveState[J[a_List, p_List, r_List], e_Integer, slot_Integer, bDelta_, state_] := Module[{newP = p},
   newP[[e, 1]] += bDelta;
   newP[[e, slot + 1]] = state;
   J[a, newP, r]
   ];


benchContactLoop[int_J, "two", 1] := Module[{a = int[[1]], p = int[[2]]},
   J[{a[[1]] + a[[2]] - 1}, {{p[[1, 1]] + 1}}, {}]
   ];


benchContactLoop[int_J, "three", 1] := Module[{a = int[[1]], p = int[[2]]},
   J[{a[[1]] + a[[2]] - 1, a[[3]]}, {{p[[1, 1]] + 1}, p[[2]]}, {}]
   ];


benchManualLoopSeed[vertex_Integer, int_J, case_Association] := Module[
   {a = int[[1]], p = int[[2]], result, sign, endpointSlots, n, other, line},
   sign = case["signs"][[vertex]];
   result = -(a[[vertex]] + case["a0"][[vertex]]) benchShiftA[int, vertex, -1] +
     If[sign === "+", -I, I] case["energies"][[vertex]] int;
   Do[
    line = case["lines"][[e]];
    endpointSlots = Flatten@Position[line["endpoints"], vertex];
    Do[
     n = p[[e, slot + 1]];
     result += If[n === 0,
       -benchShiftMassiveState[int, e, slot, -1, 1],
       (2 line["nu"] + 1) benchShiftA[int, vertex, -1] + benchShiftMassiveState[int, e, slot, -1, 0]
       ];
     If[TrueQ[line["thetaQ"]],
      other = 3 - slot;
      If[p[[e, other + 1]] === 1 - n,
       result += (2 n - 1) line["contactPrefactor"] benchContactLoop[int, case["name"], e]
       ]
      ],
     {slot, endpointSlots}
     ],
    {e, Length[case["lines"]]}
    ];
   Expand[result]
   ];


benchTreeIntegral[int_J, "two"] := Module[{a = int[[1]], p = int[[2]]},
   J[{{a[[1]], p[[1, 2]]}, {a[[2]], p[[1, 3]]}}]
   ];


benchTreeIntegral[int_J, "three"] := Module[{a = int[[1]], p = int[[2]]},
   J[{{a[[1]], p[[1, 2]]}, {a[[2]], p[[1, 3]], p[[2, 2]]}, {a[[3]], p[[2, 3]]}}]
   ];


benchContactTree[int_J, "two", 1] := Module[{packs = First[int]},
   J[{{packs[[1, 1]] + packs[[2, 1]] - 1}}]
   ];


benchContactTree[int_J, "three", 1] := Module[{packs = First[int]},
   J[{{packs[[1, 1]] + packs[[2, 1]] - 1, packs[[2, 3]]}, packs[[3]]}]
   ];


benchManualTreeSeed[vertex_Integer, int_J, case_Association] := Module[
   {packs = First[int], result, sign, vertexPack, aValue, n, leg, contactLine, contactSlot, otherVertex, otherSlot},
   sign = case["signs"][[vertex]];
   vertexPack = packs[[vertex]];
   aValue = First[vertexPack];
   result = (aValue + case["a0"][[vertex]])
      J[ReplacePart[packs, vertex -> ReplacePart[vertexPack, 1 -> aValue - 1]]] +
     If[sign === "+", -I, I] case["energies"][[vertex]] int;
   Do[
    n = vertexPack[[1 + leg]];
    result += -n (2 case["vertexLegs"][[vertex, leg, "nu"]] + 1)
       J[ReplacePart[packs, vertex -> ReplacePart[vertexPack, 1 -> aValue - 1]]] +
      (2 n - 1) case["vertexLegs"][[vertex, leg, "energy"]]
       J[ReplacePart[packs, vertex -> ReplacePart[vertexPack, 1 + leg -> 1 - n]]],
    {leg, Length[case["vertexLegs"][[vertex]]]}
    ];
   Do[
    contactLine = case["lines"][[e]];
    If[TrueQ[contactLine["thetaQ"]] && MemberQ[contactLine["endpoints"], vertex],
     contactSlot = First@FirstPosition[contactLine["endpoints"], vertex];
     otherSlot = 3 - contactSlot;
     otherVertex = contactLine["endpoints"][[otherSlot]];
     n = packs[[vertex, 1 + contactLine["legPositions"][[contactSlot]]]];
     If[packs[[otherVertex, 1 + contactLine["legPositions"][[otherSlot]]]] === 1 - n,
      result += (2 n - 1) contactLine["treeContactPrefactor"] benchContactTree[int, case["name"], e]
      ]
     ],
    {e, Length[case["lines"]]}
    ];
   Expand[result]
   ];


benchBinaryStates[p_Integer] := IntegerDigits[#, 2, p] & /@ Range[0, 2^p - 1];


benchManualTreeStep[int_J, vertex_Integer, endpoint_Integer, case_Association] := Module[
   {packs = First[int], current, seedA, p, states, seedIntegrals, minusIntegrals, equations, unknowns, matrix, rhs, solution, row},
   current = packs[[vertex, 1]];
   If[current === endpoint, Return[int]];
   seedA = If[current < endpoint, current + 1, current];
   p = Length[packs[[vertex]]] - 1;
   states = benchBinaryStates[p];
   seedIntegrals = J[ReplacePart[packs, vertex -> Prepend[#, seedA]]] & /@ states;
   minusIntegrals = J[ReplacePart[packs, vertex -> Prepend[#, seedA - 1]]] & /@ states;
   equations = benchManualTreeSeed[vertex, #, case] & /@ seedIntegrals;
   unknowns = If[current < endpoint, minusIntegrals, seedIntegrals];
   matrix = Table[Coefficient[equations[[i]], unknowns[[j]]], {i, Length[equations]}, {j, Length[unknowns]}];
   rhs = -Expand[equations /. Thread[unknowns -> 0]];
   solution = LinearSolve[matrix, rhs];
   row = FromDigits[Rest[packs[[vertex]]], 2] + 1;
   Together[solution[[row]]]
   ];


benchPauli[0] = {{1, 0}, {0, 1}};
benchPauli[1] = {{0, 1}, {1, 0}};
benchPauli[2] = {{0, -I}, {I, 0}};
benchPauli[3] = {{1, 0}, {0, -1}};
benchT1 = 1/Sqrt[2] {{1, -I}, {-I, 1}};
benchT1Inverse = 1/Sqrt[2] {{1, I}, {I, 1}};


benchTensor[mats_List] := Which[mats === {}, {{1}}, Length[mats] === 1, First[mats], True, KroneckerProduct @@ mats];


benchLift[p_Integer, slot_Integer, component_Integer] := benchTensor[
   Table[If[i === slot, benchPauli[component], benchPauli[0]], {i, p}]
   ];


benchVertexData[case_Association, vertex_Integer] := <|
   "p" -> Length[case["vertexLegs"][[vertex]]],
   "nu0" -> case["a0"][[vertex]],
   "k0" -> If[case["signs"][[vertex]] === "+", -case["energies"][[vertex]], case["energies"][[vertex]]],
   "nus" -> Lookup[case["vertexLegs"][[vertex]], "nu"],
   "ks" -> Lookup[case["vertexLegs"][[vertex]], "energy"]
   |>;


benchM1[vertex_Association, shift_: 0] := Module[{p = vertex["p"], identity},
   identity = IdentityMatrix[2^p];
   Sum[(vertex["nus"][[i]] + 1/2) benchLift[p, i, 3], {i, p}] +
    (vertex["nu0"] + shift - p/2 - Total[vertex["nus"]]) identity
   ];


benchM0[vertex_Association] := Module[{p = vertex["p"], identity = IdentityMatrix[2^vertex["p"]]},
   -I Sum[vertex["ks"][[i]] benchLift[p, i, 2], {i, p}] + I vertex["k0"] identity
   ];


benchM0Tilde[vertex_Association] := Module[{p = vertex["p"], identity = IdentityMatrix[2^vertex["p"]]},
   -I Sum[vertex["ks"][[i]] benchLift[p, i, 3], {i, p}] + I vertex["k0"] identity
   ];


benchT[vertex_Association] := benchTensor[ConstantArray[benchT1, vertex["p"]]];
benchTInverse[vertex_Association] := benchTensor[ConstantArray[benchT1Inverse, vertex["p"]]];


benchAminus[vertex_Association, shift_: 0] := -Inverse[benchM1[vertex, shift]].benchM0[vertex];
benchAplus[vertex_Association, shift_: 0] :=
 -benchTInverse[vertex].Inverse[benchM0Tilde[vertex]].benchT[vertex].benchM1[vertex, shift + 1];


benchVertexOmega[vertex_Association] := Module[{p = vertex["p"], states, omega0, omegaEx},
   states = benchBinaryStates[p];
   omega0 = -I DiagonalMatrix@Table[
      Log[vertex["k0"] + Sum[(2 states[[row, i]] - 1) vertex["ks"][[i]], {i, p}]],
      {row, Length[states]}
      ];
   omegaEx = DiagonalMatrix@Table[
     -Sum[states[[row, i]] (2 vertex["nus"][[i]] + 1) Log[vertex["ks"][[i]]], {i, p}],
     {row, Length[states]}
     ];
   Expand[omegaEx - I benchTInverse[vertex].omega0.benchT[vertex].benchM1[vertex, 1]]
   ];


benchVertexLetters[vertex_Association] := Module[{p = vertex["p"], states},
   states = benchBinaryStates[p];
   DeleteDuplicates@Join[
     vertex["ks"],
     Table[vertex["k0"] + Sum[(2 states[[row, i]] - 1) vertex["ks"][[i]], {i, p}], {row, Length[states]}]
     ]
   ];


benchEmbed[matrix_List, vertex_Integer, dimensions_List] := benchTensor[
   Table[If[i === vertex, matrix, IdentityMatrix[dimensions[[i]]]], {i, Length[dimensions]}]
   ];


benchCaseDLog[case_Association] := Module[{vertices, dimensions, omega, letters, masters, vertexPacks},
   vertices = Table[benchVertexData[case, v], {v, Length[case["signs"]]}];
   dimensions = 2^Lookup[vertices, "p"];
   omega = Total@Table[benchEmbed[benchVertexOmega[vertices[[v]]], v, dimensions], {v, Length[vertices]}];
   letters = DeleteDuplicates[Flatten[benchVertexLetters /@ vertices]];
   vertexPacks = (Prepend[#, 0] & /@ benchBinaryStates[#]) & /@ Lookup[vertices, "p"];
   masters = J[#] & /@ Tuples[vertexPacks];
   <|"vertices" -> vertices, "omega" -> omega, "letters" -> letters, "masters" -> masters|>
   ];


treeContactCoefficient = 4 I eta12 (-1)^(-1 - 2 nu12) k12^(-1 - 2 nu12)/Pi;


twoManualCase = <|
   "name" -> "two",
   "packLengths" -> {2, 2},
   "signs" -> {"+", "+"},
   "energies" -> {K1, K2},
   "a0" -> {alpha1, alpha2},
   "lines" -> {
     <|"endpoints" -> {1, 2}, "nu" -> nu12, "thetaQ" -> True,
      "contactPrefactor" -> 4 I eta12/Pi, "treeContactPrefactor" -> treeContactCoefficient,
      "legPositions" -> {1, 1}|>
     },
   "vertexLegs" -> {
     {<|"nu" -> nu12, "energy" -> k12|>},
     {<|"nu" -> nu12, "energy" -> k12|>}
     }
   |>;


threeManualCase = <|
   "name" -> "three",
   "packLengths" -> {2, 3, 2},
   "signs" -> {"+", "+", "-"},
   "energies" -> {K1, K2, K3},
   "a0" -> {alpha1, alpha2, alpha3},
   "lines" -> {
     <|"endpoints" -> {1, 2}, "nu" -> nu12, "thetaQ" -> True,
      "contactPrefactor" -> 4 I eta12/Pi, "treeContactPrefactor" -> treeContactCoefficient,
      "legPositions" -> {1, 1}|>,
     <|"endpoints" -> {2, 3}, "nu" -> nu23, "thetaQ" -> False,
      "contactPrefactor" -> 0, "treeContactPrefactor" -> 0,
      "legPositions" -> {2, 1}|>
     },
   "vertexLegs" -> {
     {<|"nu" -> nu12, "energy" -> k12|>},
     {<|"nu" -> nu12, "energy" -> k12|>, <|"nu" -> nu23, "energy" -> k23|>},
     {<|"nu" -> nu23, "energy" -> k23|>}
     }
   |>;


twoLowerManualCase = <|
   "name" -> "twoLower", "packLengths" -> {1},
   "signs" -> {"+"}, "energies" -> {K1 + K2},
   "a0" -> {alpha1 + alpha2 - 2 nu12}, "lines" -> {}, "vertexLegs" -> {{}}
   |>;


threeLowerManualCase = <|
   "name" -> "threeLower", "packLengths" -> {2, 2},
   "signs" -> {"+", "-"}, "energies" -> {K1 + K2, K3},
   "a0" -> {alpha1 + alpha2 - 2 nu12, alpha3},
   "lines" -> {
     <|"endpoints" -> {1, 2}, "nu" -> nu23, "thetaQ" -> False,
      "contactPrefactor" -> 0, "treeContactPrefactor" -> 0, "legPositions" -> {1, 1}|>
     },
   "vertexLegs" -> {
     {<|"nu" -> nu23, "energy" -> k23|>},
     {<|"nu" -> nu23, "energy" -> k23|>}
     }
   |>;


twoLoopIntegrals = Flatten@Table[
    J[{a1, a2}, {{b12, n1, n2}}, {}],
    {n1, 0, 1}, {n2, 0, 1}
    ];
twoExpectedLoop = Flatten@Table[benchManualLoopSeed[v, int, twoManualCase], {v, 2}, {int, twoLoopIntegrals}];
twoExpectedTree = Flatten@Table[benchManualTreeSeed[v, benchTreeIntegral[int, "two"], twoManualCase], {v, 2}, {int, twoLoopIntegrals}];


threeLoopIntegrals = Flatten@Table[
    J[{a1, a2, a3}, {{b12, n11, n12}, {b23, n21, n22}}, {}],
    {n11, 0, 1}, {n12, 0, 1}, {n21, 0, 1}, {n22, 0, 1}
    ];
threeExpectedLoop = Flatten@Table[benchManualLoopSeed[v, int, threeManualCase], {v, 3}, {int, threeLoopIntegrals}];
threeExpectedTree = Flatten@Table[benchManualTreeSeed[v, benchTreeIntegral[int, "three"], threeManualCase], {v, 3}, {int, threeLoopIntegrals}];


twoMinusTargets = Flatten@Table[
    J[ReplacePart[First[benchTreeIntegral[int, "two"]], v -> ReplacePart[First[benchTreeIntegral[int, "two"]][[v]], 1 -> -1]]],
    {v, 2}, {int, twoLoopIntegrals}
    ];
twoExpectedMinusSteps = MapThread[benchManualTreeStep[#1, #2, 0, twoManualCase] &, {twoMinusTargets, Flatten@Table[v, {v, 2}, {Length[twoLoopIntegrals]}]}];


threeMinusTargets = Flatten@Table[
    J[ReplacePart[First[benchTreeIntegral[int, "three"]], v -> ReplacePart[First[benchTreeIntegral[int, "three"]][[v]], 1 -> -1]]],
    {v, 3}, {int, threeLoopIntegrals}
    ];
threeExpectedMinusSteps = MapThread[benchManualTreeStep[#1, #2, 0, threeManualCase] &, {threeMinusTargets, Flatten@Table[v, {v, 3}, {Length[threeLoopIntegrals]}]}];


twoFullTarget = J[{{-1, 1}, {0, 0}}];
threeFullTarget = J[{{-1, 1}, {0, 0, 1}, {0, 0}}];
twoLowerTarget = J[{{-1}}];
threeLowerTarget = J[{{-1, 1}, {0, 0}}];
twoExpectedFullReduction = Expand[
   benchManualTreeStep[twoFullTarget, 1, 0, twoManualCase] /.
    twoLowerTarget -> benchManualTreeStep[twoLowerTarget, 1, 0, twoLowerManualCase]
   ];
threeExpectedFullReduction = Expand[
   benchManualTreeStep[threeFullTarget, 1, 0, threeManualCase] /.
    threeLowerTarget -> benchManualTreeStep[threeLowerTarget, 1, 0, threeLowerManualCase]
   ];


twoExpectedDLog = benchCaseDLog[twoManualCase];
threeExpectedDLog = benchCaseDLog[threeManualCase];
twoExpectedRecurrence = <|
   "Aminus" -> (benchAminus[#, 0] & /@ twoExpectedDLog["vertices"]),
   "Aplus" -> (benchAplus[#, 0] & /@ twoExpectedDLog["vertices"])
   |>;
threeExpectedRecurrence = <|
   "Aminus" -> (benchAminus[#, 0] & /@ threeExpectedDLog["vertices"]),
   "Aplus" -> (benchAplus[#, 0] & /@ threeExpectedDLog["vertices"])
   |>;

(* ::Chapter:: *)
(*加载 013 并逐项核对*)

checkDir = DirectoryName[$InputFileName];
codeDir = DirectoryName[checkDir];
Get[FileNameJoin[{codeDir, "013_dS_ibp_general.wl"}]];


twoSpec = <|
   "name" -> "013TwoVertexPPFormal",
   "vertexData" -> {{v1, "+"}, {v2, "+"}},
   "lineData" -> {
     <|"id" -> 1, "endpoints" -> {v1, v2}, "momentum" -> ell12,
      "treeEnergy" -> k12, "nu" -> nu12, "bbType" -> "h", "massType" -> "massive"|>
     },
   "loopMomenta" -> {ell12},
   "externalMomenta" -> {},
   "vertexEnergies" -> <|v1 -> K1, v2 -> K2|>,
   "zeroPointRules" -> {a0[v1] -> alpha1, a0[v2] -> alpha2, b0[1] -> beta12},
   "shrinkPrefactorRules" -> {Exp[Pi Im[nu12]] -> eta12},
   "seedPreset" -> "quickCheck"
   |>;


threeSpec = <|
   "name" -> "013ThreeVertexPPMFormal",
   "vertexData" -> {{v1, "+"}, {v2, "+"}, {v3, "-"}},
   "lineData" -> {
     <|"id" -> 1, "endpoints" -> {v1, v2}, "momentum" -> ell12,
      "treeEnergy" -> k12, "nu" -> nu12, "bbType" -> "h", "massType" -> "massive"|>,
     <|"id" -> 2, "endpoints" -> {v2, v3}, "momentum" -> ell23,
      "treeEnergy" -> k23, "nu" -> nu23, "bbType" -> "h", "massType" -> "massive"|>
     },
   "loopMomenta" -> {ell12, ell23},
   "externalMomenta" -> {},
   "vertexEnergies" -> <|v1 -> K1, v2 -> K2, v3 -> K3|>,
   "zeroPointRules" -> {a0[v1] -> alpha1, a0[v2] -> alpha2, a0[v3] -> alpha3, b0[1] -> beta12, b0[2] -> beta23},
   "shrinkPrefactorRules" -> {Exp[Pi Im[nu12]] -> eta12, Exp[Pi Im[nu23]] -> eta23},
   "seedPreset" -> "quickCheck"
   |>;


twoTopo = parseTopology[twoSpec];
threeTopo = parseTopology[threeSpec];
twoPackageRecords = Flatten@Table[DSTreeSeeds[vertex, int, twoTopo], {vertex, {v1, v2}}, {int, twoLoopIntegrals}];
threePackageRecords = Flatten@Table[DSTreeSeeds[vertex, int, threeTopo], {vertex, {v1, v2, v3}}, {int, threeLoopIntegrals}];


twoLoopDiffs = MapThread[Together[Expand[#1 - #2]] &, {Lookup[twoPackageRecords, "loopSeed"], twoExpectedLoop}];
twoTreeDiffs = MapThread[Together[Expand[#1 - #2]] &, {Lookup[twoPackageRecords, "treeSeed"], twoExpectedTree}];
threeLoopDiffs = MapThread[Together[Expand[#1 - #2]] &, {Lookup[threePackageRecords, "loopSeed"], threeExpectedLoop}];
threeTreeDiffs = MapThread[Together[Expand[#1 - #2]] &, {Lookup[threePackageRecords, "treeSeed"], threeExpectedTree}];

(* ::Chapter:: *)
(*迭代、dlog 与门禁*)

twoContext = makeTreeSectorFamilies[twoTopo];
threeContext = makeTreeSectorFamilies[threeTopo];
twoPackageMinusSteps = MapThread[treeSingleStepIntegral[#1, #2, 0, twoContext["topFamily"]] &, {twoMinusTargets, Flatten@Table[v, {v, 2}, {Length[twoLoopIntegrals]}]}];
threePackageMinusSteps = MapThread[treeSingleStepIntegral[#1, #2, 0, threeContext["topFamily"]] &, {threeMinusTargets, Flatten@Table[v, {v, 3}, {Length[threeLoopIntegrals]}]}];
twoStepDiffs = MapThread[Together[Expand[#1 - #2]] &, {twoPackageMinusSteps, twoExpectedMinusSteps}];
threeStepDiffs = MapThread[Together[Expand[#1 - #2]] &, {threePackageMinusSteps, threeExpectedMinusSteps}];
twoPackageFullReduction = repIterative[twoFullTarget, {0, 0}, twoContext];
threePackageFullReduction = repIterative[threeFullTarget, {0, 0, 0}, threeContext];
twoLowerStepDiff = Together[treeSingleStepIntegral[twoLowerTarget, 1, 0, twoContext["families"][[2]]] -
    benchManualTreeStep[twoLowerTarget, 1, 0, twoLowerManualCase]];
threeLowerStepDiff = Together[treeSingleStepIntegral[threeLowerTarget, 1, 0, threeContext["families"][[2]]] -
    benchManualTreeStep[threeLowerTarget, 1, 0, threeLowerManualCase]];
twoFullDiff = Together[Expand[twoPackageFullReduction - twoExpectedFullReduction]];
threeFullDiff = Together[Expand[threePackageFullReduction - threeExpectedFullReduction]];


probeRules = {alpha1 -> 2, alpha2 -> 3, alpha3 -> 4, nu12 -> 0, nu23 -> 0,
   K1 -> 5, K2 -> 7, K3 -> 11, k12 -> 2, k23 -> 3, eta12 -> 1, eta23 -> 1};
probeMasters = DeleteDuplicates[Cases[{twoPackageFullReduction, twoExpectedFullReduction, threePackageFullReduction, threeExpectedFullReduction}, _J, Infinity]];
probeMasterRules = Thread[probeMasters -> Range[Length[probeMasters]]/13];
twoNumericDiff = Together[(twoPackageFullReduction - twoExpectedFullReduction) /. probeRules /. probeMasterRules];
threeNumericDiff = Together[(threePackageFullReduction - threeExpectedFullReduction) /. probeRules /. probeMasterRules];
twoGeneralTarget = J[{{-2, 1}, {1, 0}}];
threeGeneralTarget = J[{{-1, 1}, {1, 0, 1}, {-1, 0}}];
twoReduced = repIterative[twoGeneralTarget, {0, 0}, twoContext];
threeReduced = repIterative[threeGeneralTarget, {0, 0, 0}, threeContext];
setTreeFamilyContext[twoContext];
twoOneStep = twoGeneralTarget /. repIterative0;


badLength = Quiet[repIterative[twoGeneralTarget, {0}, twoContext], treeEndpointData::badend];
badInteger = Quiet[repIterative[twoGeneralTarget, {0, 1/2}, twoContext], treeEndpointData::badend];
badMaxSteps = Quiet[repIterative[twoGeneralTarget, {0, 0}, twoContext, MaxIterations -> 0], repIterativeData::maxsteps];


twoDLog = DSTreeDLogDE[twoContext["topFamily"]];
threeDLog = DSTreeDLogDE[threeContext["topFamily"]];
twoRecurrence = makeTreeRecurrenceData[twoContext["topFamily"]];
threeRecurrence = makeTreeRecurrenceData[threeContext["topFamily"]];
twoDLogExpectedCount = 2^Total[Lookup[twoContext["topFamily"]["vertices"], "p"]];
threeDLogExpectedCount = 2^Total[Lookup[threeContext["topFamily"]["vertices"], "p"]];
twoRecurrenceDiffs = Flatten@Table[
    Flatten@MapThread[
      Function[{packageMatrix, expectedMatrix}, Map[Together[Expand[#]] &, packageMatrix - expectedMatrix, {2}]],
      {Lookup[twoRecurrence["vertices"], key], twoExpectedRecurrence[key]}
      ],
    {key, {"Aminus", "Aplus"}}
    ];
threeRecurrenceDiffs = Flatten@Table[
    Flatten@MapThread[
      Function[{packageMatrix, expectedMatrix}, Map[Together[Expand[#]] &, packageMatrix - expectedMatrix, {2}]],
      {Lookup[threeRecurrence["vertices"], key], threeExpectedRecurrence[key]}
      ],
    {key, {"Aminus", "Aplus"}}
    ];
twoOmegaDiff = Map[Together[Expand[#]] &, twoDLog["omega"] - twoExpectedDLog["omega"], {2}];
threeOmegaDiff = Map[Together[Expand[#]] &, threeDLog["omega"] - threeExpectedDLog["omega"], {2}];


checks = <|
   "twoLoopSeeds8" -> And @@ (# === 0 & /@ twoLoopDiffs),
   "twoTreeSeeds8" -> And @@ (# === 0 & /@ twoTreeDiffs),
   "threeLoopSeeds48" -> And @@ (# === 0 & /@ threeLoopDiffs),
   "threeTreeSeeds48" -> And @@ (# === 0 & /@ threeTreeDiffs),
   "twoSeedVsIterative8" -> And @@ (# === 0 & /@ twoStepDiffs),
   "threeSeedVsIterative48" -> And @@ (# === 0 & /@ threeStepDiffs),
   "twoLowerStep" -> twoLowerStepDiff === 0,
   "threeLowerStep" -> threeLowerStepDiff === 0,
   "twoFullSymbolicReduction" -> twoFullDiff === 0,
   "threeFullSymbolicReduction" -> threeFullDiff === 0,
   "deterministicRationalProbe" -> twoNumericDiff === 0 && threeNumericDiff === 0,
   "twoZeroPointExplicitCoefficient" -> ! FreeQ[Lookup[twoPackageRecords, "treeSeed"], k12^(-1 - 2 nu12)],
   "mixedLineNoContact" -> FreeQ[Flatten[Lookup[threePackageRecords, "contactAudit"]], <|___, "lineId" -> 2, ___|>],
   "mixedLineNoWTConsumption" -> FreeQ[Flatten[Lookup[threePackageRecords, "shrinkConsumptionTrace"]], <|___, "lineId" -> 2, ___|>],
   "twoGeneralReduction" -> FreeQ[twoReduced, $Failed] && FreeQ[twoReduced, int : J[packs_List] /; AnyTrue[packs, First[#] =!= 0 &]],
   "threeGeneralReduction" -> FreeQ[threeReduced, $Failed] && FreeQ[threeReduced, int : J[packs_List] /; AnyTrue[packs, First[#] =!= 0 &]],
   "repIterative0OneStep" -> twoOneStep =!= twoGeneralTarget && ! FreeQ[twoOneStep, int : J[packs_List] /; AnyTrue[packs, First[#] =!= 0 &]],
   "endpointLengthGuard" -> badLength === $Failed,
   "endpointIntegerGuard" -> badInteger === $Failed,
   "maxStepGuard" -> badMaxSteps === $Failed,
   "twoDLogMasterOrder" -> twoDLog["masterCount"] === twoDLogExpectedCount && Length[twoDLog["masters"]] === twoDLogExpectedCount,
   "threeDLogMasterOrder" -> threeDLog["masterCount"] === threeDLogExpectedCount && Length[threeDLog["masters"]] === threeDLogExpectedCount,
   "recurrenceMatrices" -> And @@ (# === 0 & /@ Join[twoRecurrenceDiffs, threeRecurrenceDiffs]),
   "twoDLogConnection" -> And @@ (# === 0 & /@ Flatten[twoOmegaDiff]) &&
    twoDLog["letters"] === twoExpectedDLog["letters"] &&
    twoDLog["masters"] === twoExpectedDLog["masters"],
   "threeDLogConnection" -> And @@ (# === 0 & /@ Flatten[threeOmegaDiff]) &&
    threeDLog["letters"] === threeExpectedDLog["letters"] &&
    threeDLog["masters"] === threeExpectedDLog["masters"]
   |>;


Print["013 pure time-IBP formal check: ", Count[Values[checks], True], "/", Length[checks]];
If[! And @@ Values[checks], Print[Select[checks, Not]]; Exit[1]];
