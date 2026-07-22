(* ::Chapter:: *)
(*016 Phase 1 package-free 自检*)

(* ::Section:: *)
(*初始化*)

ClearAll["Global`*"];
Get[FileNameJoin[{DirectoryName[$InputFileName], "expected_016.wl"}]];

checks = {};
zeroExpressionQ[expr_] := If[ListQ[expr], AllTrue[Flatten[expr], TrueQ[# === 0] &], TrueQ[expr === 0]];
addCheck[name_String, actual_, expected_] := Module[{difference = Together[actual - expected]},
  AppendTo[
    checks,
    <|"name" -> name, "actual" -> actual, "expected" -> expected,
      "difference" -> difference, "passed" -> zeroExpressionQ[difference]|>
  ]
];
addSameCheck[name_String, actual_, expected_] := AppendTo[
  checks,
  <|"name" -> name, "actual" -> actual, "expected" -> expected,
    "difference" -> If[SameQ[actual, expected], 0, HoldForm[actual - expected]],
    "passed" -> SameQ[actual, expected]|>
];

(* ::Section:: *)
(*图论与 routing*)

main = expected016["graphTheory"]["main"];
bmat = main["incidence"];
addCheck["main loop count", 3 - 3 + 1, main["counts"]["L"]];
addSameCheck["main nullspace", NullSpace[bmat], main["cycleBasis"]];
addSameCheck["main cycle lines", main["cycleLines"], {e1, e2}];
addSameCheck["main bridge", main["bridges"], {e3}];
addCheck["self-loop count", 1 - 1 + 1, expected016["graphTheory"]["selfLoop"]["counts"]["L"]];
addCheck["parallel count", 3 - 2 + 1, expected016["graphTheory"]["threeParallel"]["counts"]["L"]];
addCheck["parallel nullity", Length[NullSpace[expected016["graphTheory"]["threeParallel"]["incidence"]]], 2];

amat = expected016["routing"]["loopCoefficientMatrix"];
shift = expected016["routing"]["shiftVector"];
transformed = Expand[shift - Flatten[amat] First[shift]];
addSameCheck["routing shift removal", transformed, expected016["routing"]["transformedShift"]];
addSameCheck["routing support in cycle space", Flatten[amat], First[NullSpace[bmat]]];
addSameCheck["exact loop-external declaration", DeleteCases[transformed[[1 ;; 2]], 0], {spur}];
addSameCheck["rational residual", Expand[spur - (-3) arc/2], expected016["routing"]["rationalSignProbe"]["residualSecond"]];
addSameCheck["illegal support residual", bmat.expected016["routing"]["negativeCases"]["illegalCycleSupport"], expected016["routing"]["negativeCases"]["illegalCycleResidual"]];
addSameCheck["undercomplete missing direction", expected016["declarations"]["loopExternal"]["under"]["missingDirections"], {spur}];
addSameCheck["overcomplete derivative gate", expected016["declarations"]["loopExternal"]["over"]["derivativeUsableQ"], False];
addSameCheck["undercomplete downstream count", Length[expected016["declarations"]["undercompleteCapabilityGate"]["blocked"]], 8];
addSameCheck["independent magnitude count", Length[expected016["declarations"]["independentExternal"]["actualMagnitudes"]], 3];

(* ::Section:: *)
(*cycle/fixed pack 与 h 导数*)

rootIntegral = expected016["packs"]["rootIntegral"];
addSameCheck["root line packs", rootIntegral[[2]], {{b1, n11, n12}, {b2, n2}, {n31, n32}}];
addSameCheck["fixed cross empty pack", expected016["packs"]["fixedMasslessCross"], {}];
addSameCheck["momentum traversal excludes bridge", FreeQ[expected016["packs"]["momentumTraversal"], e3], True];
addSameCheck["time traversal includes bridge", MemberQ[expected016["packs"]["timeTraversal"][v2], e3], True];
addCheck["root loop count inherited", expected016["packs"]["inheritedAfterAllCycleShrink"]["L"], 1];
addSameCheck["root roles inherited", expected016["packs"]["inheritedAfterAllCycleShrink"]["cycleLines"], {e1, e2}];

(* 直接对抽象 F0/F1 一阶系统应用乘积法则，核对四个 radial 状态。 *)
ClearAll[yU, yV, radialTerm];
radialTerm[0, y_] := y state[1];
radialTerm[1, y_] := -y state[0] - (2 nu + 1) state[1]/r;
radialCoefficients[nuState_, nvState_] := Module[{terms},
  terms = {-B fixedJ[nuState, nvState]/r};
  terms = Join[terms,
    (radialTerm[nuState, yU] /. {
       yU state[1] :> shiftAU[1] fixedJ[1, nvState],
       -yU state[0] :> -shiftAU[1] fixedJ[0, nvState],
       state[1]/r :> fixedJ[1, nvState]/r}),
    (radialTerm[nvState, yV] /. {
       yV state[1] :> shiftAV[1] fixedJ[nuState, 1],
       -yV state[0] :> -shiftAV[1] fixedJ[nuState, 0],
       state[1]/r :> fixedJ[nuState, 1]/r})];
  Collect[Total[terms], _fixedJ, Together] // List @@ Expand[#] &
];

(* 使用逐态手工展开，避免替换顺序掩盖两端点贡献。 *)
radialManual = <|
  {0, 0} -> {-B/r fixedJ[0, 0], shiftAU[1] fixedJ[1, 0], shiftAV[1] fixedJ[0, 1]},
  {1, 0} -> {-(B + 2 nu + 1)/r fixedJ[1, 0], -shiftAU[1] fixedJ[0, 0], shiftAV[1] fixedJ[1, 1]},
  {0, 1} -> {-(B + 2 nu + 1)/r fixedJ[0, 1], shiftAU[1] fixedJ[1, 1], -shiftAV[1] fixedJ[0, 0]},
  {1, 1} -> {-(B + 2 (2 nu + 1))/r fixedJ[1, 1], -shiftAU[1] fixedJ[0, 1], -shiftAV[1] fixedJ[1, 0]}
|>;
Do[
  addCheck[
    "fixed radial state " <> ToString[stateKey, InputForm],
    Total[radialManual[stateKey]],
    Total[expected016["fixedMassiveH"]["radialDerivative"][stateKey]]
  ],
  {stateKey, Keys[radialManual]}
];
addSameCheck["fixed n0 time coefficient", expected016["fixedMassiveH"]["endpointTime"][0], {-r fixedState[1]}];
addSameCheck["fixed n1 time terms", expected016["fixedMassiveH"]["endpointTime"][1], {r fixedState[0], (2 nu + 1) shiftA[-1] fixedState[1]}];

(* ::Section:: *)
(*pure-time seed 与独立矩阵路线*)

ClearAll[binaryBits, seedMatrices, kronMatrices];
binaryBits[p_Integer] := Tuples[{0, 1}, p];

(* 路线 A 逐行读取 total-derivative seed。 *)
seedMatrices[aPhys_, sign_, energy_, nus_List, radii_List] := Module[
  {bits = binaryBits[Length[nus]], m1, m0, row, flipped, coefficient},
  m1 = DiagonalMatrix[(aPhys - Total[MapThread[If[#1 == 1, 2 #2 + 1, 0] &, {#, nus}]]) & /@ bits];
  m0 = ConstantArray[0, {Length[bits], Length[bits]}];
  Do[
    m0[[row, row]] = -I sign energy;
    Do[
      flipped = ReplacePart[bits[[row]], j -> 1 - bits[[row, j]]];
      coefficient = If[bits[[row, j]] == 0, -radii[[j]], radii[[j]]];
      m0[[row, First@FirstPosition[bits, flipped]]] += coefficient,
      {j, Length[nus]}
    ],
    {row, Length[bits]}
  ];
  {m1, m0}
];

(* 路线 B 用独立的 Kronecker 嵌入构造同一局部矩阵。 *)
kronAt[m_, j_, p_] := Module[{factors = Table[If[i == j, m, IdentityMatrix[2]], {i, p}]},
  If[p == 1, First[factors], KroneckerProduct @@ factors]
];
kronMatrices[aPhys_, sign_, energy_, nus_List, radii_List] := Module[
  {p = Length[nus], projector1, flip0to1, flip1to0, m1, m0},
  projector1 = {{0, 0}, {0, 1}};
  flip0to1 = {{0, 0}, {1, 0}};
  flip1to0 = {{0, 1}, {0, 0}};
  m1 = aPhys IdentityMatrix[2^p] - Sum[(2 nus[[j]] + 1) kronAt[projector1, j, p], {j, p}];
  m0 = -I sign energy IdentityMatrix[2^p] + Sum[radii[[j]] kronAt[flip0to1 - flip1to0, j, p], {j, p}];
  {m1, m0}
];

Do[
  probe = expected016["timeOnly"]["deterministicProbe"][case];
  Do[
    routeA = seedMatrices[probe["A"][[vertex]], probe["signs"][[vertex]], probe["energies"][[vertex]], probe["nus"][[vertex]], probe["radii"][[vertex]]];
    routeB = kronMatrices[probe["A"][[vertex]], probe["signs"][[vertex]], probe["energies"][[vertex]], probe["nus"][[vertex]], probe["radii"][[vertex]]];
    addCheck[case <> " vertex " <> ToString[vertex] <> " M1", routeA[[1]], routeB[[1]]];
    addCheck[case <> " vertex " <> ToString[vertex] <> " M0", routeA[[2]], routeB[[2]]];
    probeVector = Range[Length[routeA[[1]]]]/17;
    addCheck[
      case <> " vertex " <> ToString[vertex] <> " lowering probe",
      -Inverse[routeA[[1]]].routeA[[2]].probeVector,
      -Inverse[routeB[[1]]].routeB[[2]].probeVector
    ],
    {vertex, Length[probe["A"]]}
  ],
  {case, {"twoVertex", "threeVertex"}}
];
addSameCheck["two-vertex binary order", expected016["timeOnly"]["twoVertexMasterBits"], {{0, 0}, {0, 1}, {1, 0}, {1, 1}}];
addSameCheck["three-vertex master count", Length[expected016["timeOnly"]["threeVertexMasterBits"]], 16];

(* ::Section:: *)
(*notation 与参数 Jacobian*)

addSameCheck["notation N=9", expected016["notation"][9], <|"gram" -> {ss19}, "independent" -> {sE9}|>];
addSameCheck["notation N=10", expected016["notation"][10], <|"gram" -> {ss0101, ss0110}, "independent" -> {sE01}|>];
addSameCheck["notation N=100", expected016["notation"][100], <|"gram" -> {ss001100}, "independent" -> {sE001}|>];

redef = expected016["redefinition"];
derivedJacobian = D[redef["coordinates"] /. redef["rules"], {redef["parameters"]}];
addSameCheck["mixed Jacobian", derivedJacobian, redef["jacobian"]];
addCheck["mixed determinant", Det[derivedJacobian], redef["determinant"]];
addSameCheck["u chain weights", derivedJacobian[[All, 1]], redef["uChainWeights"]];
over = redef["overcomplete"];
addSameCheck["overcomplete right null", over["jacobian"].over["rightNullVector"], ConstantArray[0, 4]];
addCheck["overcomplete row rank", MatrixRank[over["jacobian"]], 4];
addSameCheck["overcomplete inverse gate", over["inverseAvailableQ"], False];
addSameCheck["undercomplete missing coordinate", redef["undercomplete"]["missingCoordinates"], {sE3}];

(* ::Section:: *)
(*汇总*)

passedCount = Count[checks, check_ /; TrueQ[check["passed"]]];
totalCount = Length[checks];
failedChecks = Select[checks, Not@TrueQ[#passed] &];
summary = <|
  "passed" -> passedCount,
  "total" -> totalCount,
  "nonzeroDifferenceCount" -> Length[failedChecks],
  "firstFailure" -> If[failedChecks === {}, None, First[failedChecks]]
|>;

Print["PHASE1_SELF_CHECK=" <> ToString[summary, InputForm]];
If[failedChecks =!= {}, Exit[1]];
