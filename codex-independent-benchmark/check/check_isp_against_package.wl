(* ::Package:: *)
(* 本检查用冻结的 26 个 ISP numerator 插入公式，对 014 的两个固定 sign 分支、全部可达 sector 与全部离散态做 r=1/r=0 差分。 *)

ClearAll["Global`*"];


(* ::Chapter:: *)
(*冻结 expected 与 package*)
Get[FileNameJoin[{DirectoryName[DirectoryName[$InputFileName]], "isp-coverage", "expected.wl"}]];

checkDir = DirectoryName[$InputFileName];
workspaceDir = DirectoryName[checkDir];
projectDir = DirectoryName[workspaceDir];
expectedPath = FileNameJoin[{workspaceDir, "isp-coverage", "expected.wl"}];
packagePath = FileNameJoin[{projectDir, "independent-benchmark", "package", "package_014.wl"}];
resultsDir = FileNameJoin[{checkDir, "results"}];
resultPath = FileNameJoin[{resultsDir, "isp-against-package.wl"}];
If[! DirectoryQ[resultsDir], CreateDirectory[resultsDir, CreateIntermediateDirectories -> True]];

oracleDen = Global`den;
oracleRho = Global`rho;
oracleInsertions = expectedISPInsertions;
Quiet[Get[packagePath], General::shdw];
DSMessagesOff[];


(* ::Chapter:: *)
(*任务书与 014 共用的 ISP 输入*)

(* ::Section::Closed:: *)
(* name/expr/range 直接对应任务书槽位；这里只批量构造三个 family 的固定输入。 *)
standardISPData[expressions_List] := MapIndexed[
  <|"name" -> Symbol["rho" <> ToString[First[#2]]], "expr" -> #1, "range" -> {0, 1}|> &,
  expressions
];

line[id_, endpoints_, momentum_, massType_, bbType_, nu_] := <|
  "id" -> id, "endpoints" -> endpoints, "momentum" -> momentum,
  "massType" -> massType, "bbType" -> bbType, "nu" -> nu
|>;

makeISPCase[family_, signs_List, energyCase_: "A"] := Module[
  {vertices = {v1, v2}, lines, loops, externals, invariants, energies, isps},
  Switch[family,
    "mixed_sunrise",
      lines = {
        line[1, vertices, q1, "massive", "h", nuM],
        line[2, vertices, q2, "massless", "exp", 0],
        line[3, vertices, q1 - q2 - k, "massless", "exp", 0]
      };
      loops = {q1, q2}; externals = {k}; invariants = {sp[k, k] -> s11};
      energies = <|v1 -> E1, v2 -> E2|>;
      isps = standardISPData[{sp[q1, k], sp[q2, k]}],
    "two_loop_isp_toy",
      lines = {
        line[1, vertices, l3, "massless", "exp", 0],
        line[2, vertices, k321, "massless", "exp", 0],
        line[3, vertices, l3 - k321 - wdnmd, "massless", "exp", 0]
      };
      loops = {l3, k321}; externals = {wdnmd}; invariants = {sp[wdnmd, wdnmd] -> s11};
      energies = <|v1 -> E1, v2 -> E2|>;
      isps = standardISPData[{sp[l3, k321 + l3], sp[l3, wdnmd]}],
    "vertex_energy_signs",
      lines = {line[1, vertices, ell - k, "massless", "exp", 0]};
      loops = {ell}; externals = {k}; invariants = {sp[k, k] -> s11};
      energies = Switch[energyCase,
        "A", <|v1 -> ke[1], v2 -> ke[2]|>,
        "B", <|v1 -> Sqrt[s11], v2 -> ke[2]|>,
        "C", <|v1 -> ke[3], v2 -> ke[2]|>
      ];
      isps = standardISPData[{sp[ell, k]}]
  ];
  <|
    "name" -> StringRiffle[{family, StringJoin[ToString /@ signs], energyCase}, "-"],
    "vertexData" -> MapThread[{#1, If[#2 === 1, "+", "-"]} &, {vertices, signs}],
    "lineData" -> lines,
    "loopMomenta" -> loops,
    "externalMomenta" -> externals,
    "externalInvariantRules" -> invariants,
    "vertexEnergies" -> energies,
    "ispData" -> isps,
    "zeroPointRules" -> Join[
      {a0[v1] -> alpha1, a0[v2] -> alpha2},
      Map[b0[Lookup[#, "id"]] -> Symbol["beta" <> ToString[Lookup[#, "id"]]] &, lines]
    ],
    "symmetryRules" -> {},
    "seedRanges" -> <|"a" -> {0}, "b" -> {0}, "isp" -> {0, 1}, "sampleOnly" -> False|>
  |>
];


(* ::Chapter:: *)
(*记录 pairing 与独立 polynomial action*)

(* ::Section::Closed:: *)
(*generator 与 ISP seed 的稳定键*)
generatorLabel[{"momentum", i_, "loop", j_}] := {"dqq", i, j};
generatorLabel[{"momentum", i_, "external", j_}] := {"dqk", i, j};
generatorLabel[{momentum, i_, loop, j_}] /;
    SymbolName[Unevaluated[momentum]] === "momentum" && SymbolName[Unevaluated[loop]] === "loop" := {"dqq", i, j};
generatorLabel[{momentum, i_, external, j_}] /;
    SymbolName[Unevaluated[momentum]] === "momentum" && SymbolName[Unevaluated[external]] === "external" := {"dqk", i, j};

expectedGeneratorLabel[expr_] := {SymbolName[Head[expr]], Sequence @@ (List @@ expr)};

ispValues[rules_List, count_Integer] := Table[Lookup[Association[rules], ispN[index], Missing["Absent"]], {index, count}];
dropISPRules[rules_List] := Select[rules, Head[First[#]] =!= ispN &];
recordPairKey[record_, count_Integer] := ToString[
  {Lookup[record, "generator"], dropISPRules[Lookup[record, "continuousRules", {}]], Lookup[record, "discreteRules", {}]},
  InputForm
];


(* ::Section::Closed:: *)
(*从 seed rules 机械重建被差分的零 ISP 积分*)
ruleValue[rules_List, lhs_] := Lookup[Association[rules], lhs, Missing["Absent", lhs]];

seedIntegralFromRecord[record_, case_Association, ispCount_Integer] := Module[
  {continuous = Lookup[record, "continuousRules", {}], discrete = Lookup[record, "discreteRules", {}],
   aValues, packs, rValues, signs, sameBranchQ},
  aValues = Last /@ Select[continuous, Head[First[#]] === a &];
  signs = Lookup[case, "vertexData"][[All, 2]];
  sameBranchQ = SameQ @@ signs;
  packs = Table[
    If[! MissingQ[ruleValue[continuous, bS[id]]],
      {ruleValue[continuous, bS[id]]},
      With[{lineData = SelectFirst[Lookup[case, "lineData"], Lookup[#, "id"] === id &]},
        Switch[{Lookup[lineData, "massType"], sameBranchQ},
          {"massive", _}, {
            ruleValue[continuous, b[id]],
            ruleValue[discrete, n[id, 1]],
            ruleValue[discrete, n[id, 2]]
          },
          {"massless", True}, {
            ruleValue[continuous, b[id]],
            ruleValue[discrete, n[id]]
          },
          {"massless", False}, {ruleValue[continuous, b[id]]}
        ]
      ]
    ],
    {id, Lookup[Lookup[case, "lineData"], "id"]}
  ];
  rValues = Table[ruleValue[continuous, ispN[index]], {index, ispCount}];
  J[aValues, packs, rValues]
];


(* ::Section::Closed:: *)
(*den/rho 单项式分别映射为 line-pack 与 ISP 指标移位*)
shiftLinePower[int_J, lineSlot_Integer, amount_Integer] := ReplacePart[
  int,
  {2, lineSlot, 1} -> int[[2, lineSlot, 1]] - amount
];

shiftISPPower[int_J, ispSlot_Integer, amount_Integer] := ReplacePart[
  int,
  {3, ispSlot} -> int[[3, ispSlot]] + amount
];

raiseISPInExpression[expr_, ispSlot_Integer] := expr /. int_J :> shiftISPPower[int, ispSlot, 1];

polynomialAction[poly_, int_J, lineCount_Integer, ispCount_Integer] := Module[
  {dVars = Array[dd, lineCount], rVars = Array[rr, ispCount], replaced, variables, terms},
  If[TrueQ[Expand[poly] === 0], Return[0]];
  replaced = poly /. oracleDen[index_Integer] :> dVars[[index]] /. oracleRho[index_Integer] :> rVars[[index]];
  variables = Join[dVars, rVars];
  terms = MonomialList[Expand[replaced], variables];
  Total[Map[Function[term,
    dPowers = Exponent[term, #] & /@ dVars;
    rPowers = Exponent[term, #] & /@ rVars;
    coefficient = Together[term/Times @@ MapThread[Power, {variables, Join[dPowers, rPowers]}]];
    shifted = Fold[shiftLinePower[#1, #2, 2*dPowers[[#2]]] &, int, Range[lineCount]];
    shifted = Fold[shiftISPPower[#1, #2, rPowers[[#2]]] &, shifted, Range[ispCount]];
    coefficient*shifted
  ], terms]]
];


(* ::Chapter:: *)
(*全部分支、sector 与离散态对照*)
runs = {
  {"mixed_sunrise", {1, 1}, "A"},
  {"mixed_sunrise", {1, -1}, "A"},
  {"two_loop_isp_toy", {1, 1}, "A"},
  {"two_loop_isp_toy", {-1, 1}, "A"},
  {"vertex_energy_signs", {1, 1}, "A"},
  {"vertex_energy_signs", {-1, 1}, "A"},
  {"vertex_energy_signs", {1, 1}, "B"},
  {"vertex_energy_signs", {-1, 1}, "B"},
  {"vertex_energy_signs", {1, 1}, "C"},
  {"vertex_energy_signs", {-1, 1}, "C"}
};

runISPComparison[spec_List] := Module[
  {family = spec[[1]], signs = spec[[2]], energyCase = spec[[3]], case, context, seedData,
   records, ispCount, zeroRecords, zeroIndex, oneHotRecords, checks},
  case = makeISPCase[family, signs, energyCase];
  context = DSInit[case, RegisterAsCurrent -> False, ProgressReporting -> False];
  seedData = DSSeeds[
    context,
    UseSampleOnly -> False,
    DiscreteMode -> "all",
    GenerateShrinkSectors -> True,
    MaxEquationCount -> 5000,
    ProgressReporting -> False
  ];
  records = Select[Lookup[seedData, "equations", {}], Lookup[#, "source", ""] === "momentum" &];
  ispCount = Length[Lookup[case, "ispData"]];
  zeroRecords = Select[records, ispValues[Lookup[#, "continuousRules", {}], ispCount] === ConstantArray[0, ispCount] &];
  zeroIndex = Association[recordPairKey[#, ispCount] -> # & /@ zeroRecords];
  oneHotRecords = Select[records, MemberQ[IdentityMatrix[ispCount], ispValues[Lookup[#, "continuousRules", {}], ispCount]] &];
  checks = Map[Function[record,
    seed = ispValues[Lookup[record, "continuousRules", {}], ispCount];
    ispSlot = First[FirstPosition[seed, 1]];
    baseRecord = Lookup[zeroIndex, recordPairKey[record, ispCount], Missing["MissingBaseRecord"]];
    generator = generatorLabel[Lookup[record, "generator"]];
    expectedRecord = SelectFirst[
      oracleInsertions,
      Lookup[#, "family"] === family && Lookup[#, "ispSeed"] === seed && expectedGeneratorLabel[Lookup[#, "generator"]] === generator &,
      Missing["MissingExpected"]
    ];
    If[
      MissingQ[baseRecord] || MissingQ[expectedRecord],
      <|
        "family" -> family, "signs" -> signs, "energyCase" -> energyCase,
        "generator" -> generator, "ispSeed" -> seed,
        "difference" -> Missing["MissingPair"], "passed" -> False
      |>,
      baseIntegral = seedIntegralFromRecord[baseRecord, case, ispCount];
      actualInsertion = Expand[
        Lookup[record, "equation"] - raiseISPInExpression[Lookup[baseRecord, "equation"], ispSlot]
      ];
      expectedInsertion = polynomialAction[
        Lookup[expectedRecord, "insertion"],
        baseIntegral,
        Length[Lookup[case, "lineData"]],
        ispCount
      ];
      difference = Together[Expand[rep2outform[actualInsertion, context["topology"]] - expectedInsertion]];
      <|
        "family" -> family,
        "signs" -> signs,
        "energyCase" -> energyCase,
        "generator" -> generator,
        "ispSeed" -> seed,
        "difference" -> difference,
        "passed" -> TrueQ[difference === 0]
      |>
    ]
  ], oneHotRecords];
  <|
    "family" -> family,
    "signs" -> signs,
    "energyCase" -> energyCase,
    "initStatus" -> Lookup[context, "status", "failed"],
    "seedStatus" -> Lookup[seedData, "dSIBPStatus", "failed"],
    "checks" -> checks
  |>
];

runResults = runISPComparison /@ runs;
allChecks = Flatten[Lookup[runResults, "checks"]];

summary = <|
  "packageHash" -> FileHash[packagePath, "SHA256", "HexString"],
  "ispInputSchema" -> {"name", "expr", "range"},
  "passed" -> Count[allChecks, _?(TrueQ[Lookup[#, "passed", False]] &)],
  "total" -> Length[allChecks],
  "nonzeroDifferenceCount" -> Count[Lookup[allChecks, "difference"], Except[0]],
  "byRun" -> Map[
    Function[result, <|
      "family" -> Lookup[result, "family"],
      "signs" -> Lookup[result, "signs"],
      "energyCase" -> Lookup[result, "energyCase"],
      "passed" -> Count[Lookup[result, "checks"], _?(TrueQ[Lookup[#, "passed", False]] &)],
      "total" -> Length[Lookup[result, "checks"]]
    |>],
    runResults
  ],
  "firstFailure" -> SelectFirst[allChecks, ! TrueQ[Lookup[#, "passed", False]] &, Missing["NoFailure"]]
|>;

Put[summary, resultPath];
Print[InputForm[summary]];
If[summary["passed"] =!= summary["total"], Exit[1]];
