(* ::Package:: *)
(* 本脚本在 expected 冻结后加载 package_013.wl，逐条执行第 14 节 actual 对照。
   比较器只做任务书已声明的表示对齐：tree 首槽保存整数 a，a0 留在 nu0 metadata；
   (-k)^p 规范为 (-1)^p k^p。脚本不读取主线、旧 check 或旧 expected。 *)

ClearAll["Global`*"];


(* ::Chapter:: *)
(*路径、冻结哈希与加载*)

workDir = If[$InputFileName =!= "", DirectoryName[$InputFileName], NotebookDirectory[]];
repoDir = DirectoryName[DirectoryName[workDir]];
expectedFile = FileNameJoin[{workDir, "expected_013.wl"}];
packageFile = FileNameJoin[{repoDir, "independent-benchmark", "package", "package_013.wl"}];
Get[expectedFile];
Get[packageFile];
packageSHA256 = FileHash[packageFile, "SHA256", "HexString"] // ToUpperCase;


(* ::Chapter:: *)
(*固定 topology*)

caseTwo = <|
  "name" -> "two_vertex_pp_full",
  "vertexData" -> {{v1, "+"}, {v2, "+"}},
  "lineData" -> {
    <|"id" -> 1, "endpoints" -> {v1, v2}, "momentum" -> q12,
      "treeEnergy" -> k12, "nu" -> nu12, "bbType" -> "h", "massType" -> "massive", "skType" -> "++"|>
  },
  "loopMomenta" -> {}, "externalMomenta" -> {}, "ispData" -> {},
  "vertexEnergies" -> <|v1 -> E1, v2 -> E2|>,
  "zeroPointRules" -> {a0[v1] -> alpha1, a0[v2] -> alpha2, b0[1] -> beta12},
  "symmetryRules" -> {}
|>;


caseThree = <|
  "name" -> "three_vertex_ppm_chain",
  "vertexData" -> {{v1, "+"}, {v2, "+"}, {v3, "-"}},
  "lineData" -> {
    <|"id" -> 1, "endpoints" -> {v1, v2}, "momentum" -> q12,
      "treeEnergy" -> k12, "nu" -> nu12, "bbType" -> "h", "massType" -> "massive", "skType" -> "++"|>,
    <|"id" -> 2, "endpoints" -> {v2, v3}, "momentum" -> q23,
      "treeEnergy" -> k23, "nu" -> nu23, "bbType" -> "h", "massType" -> "massive", "skType" -> "+-"|>
  },
  "loopMomenta" -> {}, "externalMomenta" -> {}, "ispData" -> {},
  "vertexEnergies" -> <|v1 -> E1, v2 -> E2, v3 -> E3|>,
  "zeroPointRules" -> {a0[v1] -> alpha1, a0[v2] -> alpha2, a0[v3] -> alpha3,
    b0[1] -> beta12, b0[2] -> beta23},
  "symmetryRules" -> {}
|>;


topoTwo = parseTopology[caseTwo];
topoThree = parseTopology[caseThree];
familyTwo = makeTreeFamilyDataFromTopology[topoTwo];
familyThree = makeTreeFamilyDataFromTopology[topoThree];


(* ::Chapter:: *)
(*独立 expected 的 package 表示*)

contactC = (4 I/Pi) Exp[Pi Im[nu12]];
d12 = 2 nu12 + 1;
d23 = 2 nu23 + 1;


twoLoopJ[n1_, n2_, aa1_: a1, aa2_: a2, bb_: b12] :=
  J[{aa1, aa2}, {{bb, n1, n2}}, {}];


twoTreeJ[n1_, n2_, aa1_: a1, aa2_: a2] := J[{{aa1, n1}, {aa2, n2}}];


expectedTwoLoop[vertex_, n1_, n2_] := Module[{top = twoLoopJ[n1, n2], lower},
  lower = J[{a1 + a2 - 1}, {{b12 + 1}}, {}];
  If[vertex === v1,
    (-a1 - alpha1 + n1 d12) twoLoopJ[n1, n2, a1 - 1, a2] - I E1 top +
      (2 n1 - 1) twoLoopJ[1 - n1, n2, a1, a2, b12 - 1] +
      (n1 - n2) contactC lower,
    (-a2 - alpha2 + n2 d12) twoLoopJ[n1, n2, a1, a2 - 1] - I E2 top +
      (2 n2 - 1) twoLoopJ[n1, 1 - n2, a1, a2, b12 - 1] +
      (n2 - n1) contactC lower
  ]
];


expectedTwoTree[vertex_, n1_, n2_] := Module[{top = twoTreeJ[n1, n2], lower},
  lower = J[{{a1 + a2 - 1}}];
  If[vertex === v1,
    (a1 + alpha1 - n1 d12) twoTreeJ[n1, n2, a1 - 1, a2] - I E1 top +
      k12 (2 n1 - 1) twoTreeJ[1 - n1, n2] +
      (n1 - n2) contactC (-k12)^(-d12) lower,
    (a2 + alpha2 - n2 d12) twoTreeJ[n1, n2, a1, a2 - 1] - I E2 top +
      k12 (2 n2 - 1) twoTreeJ[n1, 1 - n2] +
      (n2 - n1) contactC (-k12)^(-d12) lower
  ]
];


threeLoopJ[n11_, n21_, n22_, n31_, aa1_: a1, aa2_: a2, aa3_: a3,
    bb12_: b12, bb23_: b23] :=
  J[{aa1, aa2, aa3}, {{bb12, n11, n21}, {bb23, n22, n31}}, {}];


threeTreeJ[n11_, n21_, n22_, n31_, aa1_: a1, aa2_: a2, aa3_: a3] :=
  J[{{aa1, n11}, {aa2, n21, n22}, {aa3, n31}}];


expectedThreeLoop[vertex_, n11_, n21_, n22_, n31_] := Module[
  {top = threeLoopJ[n11, n21, n22, n31], lower},
  lower = J[{a1 + a2 - 1, a3}, {{b12 + 1}, {b23, n22, n31}}, {}];
  Switch[vertex,
    v1,
    (-a1 - alpha1 + n11 d12) threeLoopJ[n11, n21, n22, n31, a1 - 1] - I E1 top +
      (2 n11 - 1) threeLoopJ[1 - n11, n21, n22, n31, a1, a2, a3, b12 - 1] +
      (n11 - n21) contactC lower,
    v2,
    (-a2 - alpha2 + n21 d12 + n22 d23) threeLoopJ[n11, n21, n22, n31, a1, a2 - 1] - I E2 top +
      (2 n21 - 1) threeLoopJ[n11, 1 - n21, n22, n31, a1, a2, a3, b12 - 1] +
      (2 n22 - 1) threeLoopJ[n11, n21, 1 - n22, n31, a1, a2, a3, b12, b23 - 1] +
      (n21 - n11) contactC lower,
    v3,
    (-a3 - alpha3 + n31 d23) threeLoopJ[n11, n21, n22, n31, a1, a2, a3 - 1] + I E3 top +
      (2 n31 - 1) threeLoopJ[n11, n21, n22, 1 - n31, a1, a2, a3, b12, b23 - 1]
  ]
];


expectedThreeTree[vertex_, n11_, n21_, n22_, n31_] := Module[
  {top = threeTreeJ[n11, n21, n22, n31], lower},
  lower = J[{{a1 + a2 - 1, n22}, {a3, n31}}];
  Switch[vertex,
    v1,
    (a1 + alpha1 - n11 d12) threeTreeJ[n11, n21, n22, n31, a1 - 1] - I E1 top +
      k12 (2 n11 - 1) threeTreeJ[1 - n11, n21, n22, n31] +
      (n11 - n21) contactC (-k12)^(-d12) lower,
    v2,
    (a2 + alpha2 - n21 d12 - n22 d23) threeTreeJ[n11, n21, n22, n31, a1, a2 - 1] - I E2 top +
      k12 (2 n21 - 1) threeTreeJ[n11, 1 - n21, n22, n31] +
      k23 (2 n22 - 1) threeTreeJ[n11, n21, 1 - n22, n31] +
      (n21 - n11) contactC (-k12)^(-d12) lower,
    v3,
    (a3 + alpha3 - n31 d23) threeTreeJ[n11, n21, n22, n31, a1, a2, a3 - 1] + I E3 top +
      k23 (2 n31 - 1) threeTreeJ[n11, n21, n22, 1 - n31]
  ]
];


normalizeContactPower[expr_] := expr /. HoldPattern[(-k12)^power_] :> (-1)^power k12^power;
strictZeroQ[expr_] := Module[{reduced = Simplify[Expand[normalizeContactPower[expr]]]},
  If[ListQ[reduced], And @@ (TrueQ[# === 0] & /@ Flatten[reduced]), TrueQ[reduced === 0]]
];


(* 冻结 helper 的 p=1 KroneckerProduct 实现有已知机械缺陷；这里重写同一公开公式，
   tensorProduct1 对单因子直接返回该矩阵，不改变任何物理 expected。 *)
tensorProduct1[mats_List] := Which[
  mats === {}, {{1}}, Length[mats] === 1, First[mats], True, KroneckerProduct @@ mats
];


expectedLambda[p_, slot_, matrix_] := tensorProduct1[
  ReplacePart[ConstantArray[IdentityMatrix[2], p], slot -> matrix]
];


expectedM1[mu_, nus_List] := Module[{p = Length[nus], sigma3 = {{1, 0}, {0, -1}}},
  Sum[(nus[[j]] + 1/2) expectedLambda[p, j, sigma3], {j, p}] +
    (mu - p/2 - Total[nus]) IdentityMatrix[2^p]
];


expectedM0[k0_, ks_List] := Module[{p = Length[ks], sigma2 = {{0, -I}, {I, 0}}},
  -I Sum[ks[[j]] expectedLambda[p, j, sigma2], {j, p}] + I k0 IdentityMatrix[2^p]
];


expectedTransform[p_] := tensorProduct1[ConstantArray[{{1, -I}, {-I, 1}}/Sqrt[2], p]];
expectedM0Tilde[k0_, ks_List] := I DiagonalMatrix[
  (k0 + Total[(2 # - 1) ks]) & /@ Independent013Expected`indBinaryStates[Length[ks]]
];
expectedAMinus[mu_, k0_, ks_List, nus_List] := -Inverse[expectedM1[mu, nus]].expectedM0[k0, ks];
expectedAPlus[mu_, k0_, ks_List, nus_List] := Module[{tp = expectedTransform[Length[ks]]},
  -Inverse[tp].Inverse[expectedM0Tilde[k0, ks]].tp.expectedM1[mu + 1, nus]
];
expectedTwoStep[mu_, k0_, ks_List, nus_List] :=
  expectedAMinus[mu - 1, k0, ks, nus].expectedAMinus[mu, k0, ks, nus];


expectedDlog[mu_, k0_, ks_List, nus_List] := Module[
  {p = Length[ks], states, tp, m1Shift, energyMatrices, cutLetters, cutMatrices, letters, matrices},
  states = Independent013Expected`indBinaryStates[p];
  tp = expectedTransform[p];
  m1Shift = expectedM1[mu + 1, nus];
  energyMatrices = Table[-(2 nus[[j]] + 1) DiagonalMatrix[states[[All, j]]], {j, p}];
  cutLetters = (k0 + Total[(2 # - 1) ks]) & /@ states;
  cutMatrices = Table[-Inverse[tp].SparseArray[{{r, r} -> 1}, {2^p, 2^p}].tp.m1Shift, {r, 2^p}];
  letters = Join[ks, cutLetters];
  matrices = Join[energyMatrices, cutMatrices];
  <|"states" -> states, "letters" -> letters, "matrices" -> matrices,
    "connection" -> Total[MapThread[#1 Log[#2] &, {matrices, letters}]]|>
];


(* ::Chapter:: *)
(*全 seed 的 dtau 与投影比较*)

twoStates = Tuples[{0, 1}, 2];
threeStates = Tuples[{0, 1}, 4];


twoRecords = Flatten[Table[
  With[{int = twoLoopJ[state[[1]], state[[2]]]},
    Table[Join[DSTreeSeeds[vertex, int, topoTwo], <|"state" -> state, "case" -> "two"|>],
      {vertex, {v1, v2}}]
  ],
  {state, twoStates}
], 1];


threeRecords = Flatten[Table[
  With[{int = threeLoopJ @@ state},
    Table[Join[DSTreeSeeds[vertex, int, topoThree], <|"state" -> state, "case" -> "three"|>],
      {vertex, {v1, v2, v3}}]
  ],
  {state, threeStates}
], 1];


relationRows = Join[
  Map[Function[record, With[{state = record["state"], vertex = record["generator"] /. dtau[x_] :> x},
      <|"case" -> "two", "vertex" -> vertex, "state" -> state,
        "loopPass" -> strictZeroQ[record["loopSeed"] - expectedTwoLoop[vertex, state[[1]], state[[2]]]],
        "treePass" -> strictZeroQ[record["treeSeed"] - expectedTwoTree[vertex, state[[1]], state[[2]]]],
        "loopDifference" -> Expand[record["loopSeed"] - expectedTwoLoop[vertex, state[[1]], state[[2]]]],
        "treeDifference" -> Expand[normalizeContactPower[record["treeSeed"] - expectedTwoTree[vertex, state[[1]], state[[2]]]]]|>
    ]], twoRecords],
  Map[Function[record, With[{state = record["state"], vertex = record["generator"] /. dtau[x_] :> x},
      <|"case" -> "three", "vertex" -> vertex, "state" -> state,
        "loopPass" -> strictZeroQ[record["loopSeed"] - expectedThreeLoop[vertex, Sequence @@ state]],
        "treePass" -> strictZeroQ[record["treeSeed"] - expectedThreeTree[vertex, Sequence @@ state]],
        "loopDifference" -> Expand[record["loopSeed"] - expectedThreeLoop[vertex, Sequence @@ state]],
        "treeDifference" -> Expand[normalizeContactPower[record["treeSeed"] - expectedThreeTree[vertex, Sequence @@ state]]]|>
    ]], threeRecords]
];


(* ::Chapter:: *)
(*recurrence、两级迭代与 dlog*)

vertexBundles = Join[
  ({"two", #} & /@ familyTwo["vertices"]),
  ({"three", #} & /@ familyThree["vertices"])
];


recurrenceRows = Map[Function[item,
  Module[{caseName = item[[1]], vertex = item[[2]], k0, ks, nus, mu, actual, expectedTwoStepMatrix},
    k0 = vertex["signedEnergy"];
    ks = Lookup[vertex["massiveLegs"], "energy"];
    nus = Lookup[vertex["massiveLegs"], "nu"];
    mu = vertex["nu0"];
    actual = First@Select[makeTreeRecurrenceData[If[caseName === "two", familyTwo, familyThree]]["vertices"],
      #["vertex"] === vertex["id"] &];
    expectedTwoStepMatrix = expectedTwoStep[mu, k0, ks, nus];
    <|"case" -> caseName, "vertex" -> vertex["id"],
      "M1Pass" -> strictZeroQ[actual["M1"] - expectedM1[mu, nus]],
      "M0Pass" -> strictZeroQ[actual["M0"] - expectedM0[k0, ks]],
      "AminusPass" -> strictZeroQ[actual["Aminus"] - expectedAMinus[mu, k0, ks, nus]],
      "AplusPass" -> strictZeroQ[actual["Aplus"] - expectedAPlus[mu, k0, ks, nus]],
      "twoStepPass" -> strictZeroQ[treeAminusMatrix[vertex, -1].treeAminusMatrix[vertex, 0] - expectedTwoStepMatrix]|>
  ]
], vertexBundles];


dlogTwo = DSTreeDLogDE[familyTwo];
dlogThree = DSTreeDLogDE[familyThree];


dlogRows = Map[Function[item,
  Module[{caseName = item[[1]], vertex = item[[2]], actualCase, actualBlock, expected, alignedMatricesPass},
    actualCase = If[caseName === "two", dlogTwo, dlogThree];
    actualBlock = First@Select[actualCase["vertexBlocks"], #["vertex"] === vertex["id"] &];
    expected = expectedDlog[vertex["nu0"], vertex["signedEnergy"],
      Lookup[vertex["massiveLegs"], "energy"], Lookup[vertex["massiveLegs"], "nu"]];
    alignedMatricesPass = And @@ Table[
      strictZeroQ[actualBlock["letterMatrices"][letter] - expected["matrices"][[First@FirstPosition[expected["letters"], letter]]]],
      {letter, expected["letters"]}
    ];
    <|"case" -> caseName, "vertex" -> vertex["id"],
      "omegaPass" -> strictZeroQ[actualBlock["omega"] - expected["connection"]],
      "letterSetPass" -> SameQ[Sort[actualBlock["letters"]], Sort[expected["letters"]]],
      "letterOrderPass" -> SameQ[actualBlock["letters"], expected["letters"]],
      "actualLetters" -> actualBlock["letters"], "expectedLetters" -> expected["letters"],
      "alignedMatricesPass" -> alignedMatricesPass,
      "stateOrderPass" -> SameQ[actualBlock["states"], expected["states"]]|>
  ]
], vertexBundles];


expectedGlobalLettersTwo = DeleteDuplicates[Flatten[
  expectedDlog[#"nu0", #"signedEnergy", Lookup[#"massiveLegs", "energy"], Lookup[#"massiveLegs", "nu"]]["letters"] & /@
    familyTwo["vertices"]
]];
expectedGlobalLettersThree = DeleteDuplicates[Flatten[
  expectedDlog[#"nu0", #"signedEnergy", Lookup[#"massiveLegs", "energy"], Lookup[#"massiveLegs", "nu"]]["letters"] & /@
    familyThree["vertices"]
]];
globalDlogRows = {
  <|"case" -> "two", "letterSetPass" -> SameQ[Sort[dlogTwo["letters"]], Sort[expectedGlobalLettersTwo]],
    "letterOrderPass" -> SameQ[dlogTwo["letters"], expectedGlobalLettersTwo],
    "actualLetters" -> dlogTwo["letters"], "expectedLetters" -> expectedGlobalLettersTwo|>,
  <|"case" -> "three", "letterSetPass" -> SameQ[Sort[dlogThree["letters"]], Sort[expectedGlobalLettersThree]],
    "letterOrderPass" -> SameQ[dlogThree["letters"], expectedGlobalLettersThree],
    "actualLetters" -> dlogThree["letters"], "expectedLetters" -> expectedGlobalLettersThree|>
};


masterRows = {
  <|"case" -> "two", "pass" -> SameQ[dlogTwo["masters"], treeMasterList[familyTwo]], "count" -> dlogTwo["masterCount"]|>,
  <|"case" -> "three", "pass" -> SameQ[dlogThree["masters"], treeMasterList[familyThree]], "count" -> dlogThree["masterCount"]|>
};


(* ::Chapter:: *)
(*G+- guard 与非法终点*)

gPlusContactCount = Total[Length@Select[Lookup[#, "contactAudit", {}], #["lineId"] === 2 &] & /@ threeRecords];
gPlusTraceCount = Total[Length@Select[Lookup[#, "shrinkConsumptionTrace", {}], #["lineId"] === 2 &] & /@ threeRecords];
guardRows = {
  <|"name" -> "G+- contact count", "pass" -> gPlusContactCount === 0, "actual" -> gPlusContactCount|>,
  <|"name" -> "G+- WT trace count", "pass" -> gPlusTraceCount === 0, "actual" -> gPlusTraceCount|>
};


plainFamily = makeTreeFamilyData[<|"name" -> "guardFamily", "vertices" -> {
  <|"id" -> vg, "sign" -> "+", "nu0" -> mug, "energy" -> Eg,
    "massiveLegs" -> {<|"id" -> lg, "nu" -> nug, "energy" -> kg|>}|>
  }|>];
guardIntegral = J[{{-2, 0}}];
badLength = repIterativeData[guardIntegral, {0, 0}, plainFamily];
badNonInteger = repIterativeData[guardIntegral, {1/2}, plainFamily];
badMax = repIterativeData[guardIntegral, {0}, plainFamily, MaxIterations -> 0];
endpointRows = {
  <|"name" -> "endpoint length", "pass" -> badLength["status"] === "error"|>,
  <|"name" -> "endpoint noninteger", "pass" -> badNonInteger["status"] === "error"|>,
  <|"name" -> "explicit max steps", "pass" -> badMax["status"] === "maxSteps"|>
};


(* ::Chapter:: *)
(*确定性 probe 与汇总*)

parameterProbe = {alpha1 -> 7/3, alpha2 -> 5/4, alpha3 -> 9/5,
  nu12 -> 1/5, nu23 -> 2/7, E1 -> 11/3, E2 -> 13/4, E3 -> 17/5,
  k12 -> 2/3, k23 -> 3/5, beta12 -> 1/7, beta23 -> 2/9};
masterProbeTwo = Thread[dlogTwo["masters"] -> {2/11, 3/13, 5/17, 7/19}];
masterProbeThree = Thread[dlogThree["masters"] -> Table[Prime[i + 4]/Prime[i + 20], {i, 16}]];
lowerMasterProbe = {
  J[{{0}}] -> 11/29,
  J[{{0, 0}, {0, 0}}] -> 13/31,
  J[{{0, 0}, {0, 1}}] -> 17/37,
  J[{{0, 1}, {0, 0}}] -> 19/41,
  J[{{0, 1}, {0, 1}}] -> 23/43
};


allBundlePasses = Join[
  relationRows[[All, "loopPass"]], relationRows[[All, "treePass"]],
  Flatten[Lookup[recurrenceRows, {"M1Pass", "M0Pass", "AminusPass", "AplusPass", "twoStepPass"}]],
  Flatten[Lookup[dlogRows, {"omegaPass", "letterSetPass", "letterOrderPass", "alignedMatricesPass", "stateOrderPass"}]],
  Flatten[Lookup[globalDlogRows, {"letterSetPass", "letterOrderPass"}]],
  masterRows[[All, "pass"]], guardRows[[All, "pass"]], endpointRows[[All, "pass"]]
];


firstFailure = FirstCase[
  Join[
    Map[If[TrueQ[#"loopPass"] && TrueQ[#"treePass"], Nothing, #] &, relationRows],
    Map[If[And @@ Lookup[#, {"M1Pass", "M0Pass", "AminusPass", "AplusPass", "twoStepPass"}], Nothing, #] &, recurrenceRows],
    Map[If[And @@ Lookup[#, {"omegaPass", "letterSetPass", "letterOrderPass", "alignedMatricesPass", "stateOrderPass"}], Nothing, #] &, dlogRows],
    Map[If[And @@ Lookup[#, {"letterSetPass", "letterOrderPass"}], Nothing, #] &, globalDlogRows],
    Select[Join[masterRows, guardRows, endpointRows], ! TrueQ[Lookup[#, "pass", False]] &]
  ],
  item_ :> item,
  Missing["NoFailure"]
];


summary = <|
  "packageSHA256" -> packageSHA256,
  "frozenExpectedSHA256" -> "FBC0C0107B130C1D64E9F4CB2AC532664CE6BA736FE7E9284F6DACE1F10D6A9D",
  "loopRelations" -> <|"pass" -> Count[relationRows[[All, "loopPass"]], True], "fail" -> Count[relationRows[[All, "loopPass"]], False]|>,
  "treeProjections" -> <|"pass" -> Count[relationRows[[All, "treePass"]], True], "fail" -> Count[relationRows[[All, "treePass"]], False]|>,
  "recurrenceBundles" -> recurrenceRows,
  "dlogBundles" -> dlogRows,
  "globalDlogRows" -> globalDlogRows,
  "masterRows" -> masterRows,
  "guardRows" -> guardRows,
  "endpointRows" -> endpointRows,
  "totalAtomicPass" -> Count[allBundlePasses, True],
  "totalAtomicFail" -> Count[allBundlePasses, False],
  "firstFailure" -> firstFailure,
  "parameterProbe" -> parameterProbe,
  "topMasterProbeTwo" -> masterProbeTwo,
  "topMasterProbeThree" -> masterProbeThree,
  "lowerMasterProbe" -> lowerMasterProbe
|>;

Put[summary, FileNameJoin[{workDir, "actual_013_check_result.wl"}]];
Print[InputForm[KeyTake[summary, {"loopRelations", "treeProjections", "totalAtomicPass", "totalAtomicFail", "firstFailure"}]]];
