(* ::Package:: *)
(* 本 package 自检按新版任务书从零重写十个 family，核对固定 sign 分支、独立 sector 集、生成元、全离散 canonical 与非零 ISP coverage。 *)

ClearAll["Global`*"];


(* ::Chapter:: *)
(*路径与 package*)
checkDir = DirectoryName[$InputFileName];
workspaceDir = DirectoryName[checkDir];
projectDir = DirectoryName[workspaceDir];
packagePath = FileNameJoin[{projectDir, "independent-benchmark", "package", "package_014.wl"}];
resultsDir = FileNameJoin[{checkDir, "results"}];
resultPath = FileNameJoin[{resultsDir, "full-family-coverage.wl"}];
If[! DirectoryQ[resultsDir], CreateDirectory[resultsDir, CreateIntermediateDirectories -> True]];
Get[packagePath];
DSMessagesOff[];


(* ::Chapter:: *)
(*任务书 topology 构造*)

(* ::Section::Closed:: *)
(*统一 line/ISP/zero-point helper*)
line[id_, endpoints_, momentum_, massType_, bbType_, nu_] := <|
  "id" -> id, "endpoints" -> endpoints, "momentum" -> momentum,
  "massType" -> massType, "bbType" -> bbType, "nu" -> nu
|>;

packageISP[expressions_List] := MapIndexed[
  <|"name" -> Symbol["rho" <> ToString[First[#2]]], "expr" -> #1, "range" -> {0, 1}|> &,
  expressions
];

zeroPoints[vertices_List, lines_List] := Join[
  MapIndexed[a0[#1] -> Symbol["alpha" <> ToString[First[#2]]] &, vertices],
  Map[b0[Lookup[#, "id"]] -> Symbol["beta" <> ToString[Lookup[#, "id"]]] &, lines]
];

baseCase[name_, vertices_List, signs_List, lines_List, loops_List, externals_List,
    invariantRules_List, energies_Association, ispExpressions_List] := <|
  "name" -> name,
  "vertexData" -> MapThread[{#1, If[#2 === 1, "+", "-"]} &, {vertices, signs}],
  "lineData" -> lines,
  "loopMomenta" -> loops,
  "externalMomenta" -> externals,
  "externalInvariantRules" -> invariantRules,
  "vertexEnergies" -> energies,
  "ispData" -> packageISP[ispExpressions],
  "zeroPointRules" -> zeroPoints[vertices, lines],
  "symmetryRules" -> {},
  "seedRanges" -> <|
    "a" -> {0}, "b" -> {0},
    "isp" -> If[ispExpressions === {}, {0}, {0, 1}],
    "sampleOnly" -> If[ispExpressions === {}, True, False]
  |>
|>;


(* ::Section::Closed:: *)
(*十个 family 的固定定义*)
makeFamilyCase[family_, signs_List, energyCase_: "A"] := Module[
  {vertices, lines, loops, externals, invariants, energies, isps},
  Switch[family,
    "atomic_massless_line",
      vertices = {v1, v2}; lines = {line[1, vertices, ell, "massless", "exp", 0]};
      loops = {ell}; externals = {}; invariants = {}; energies = <|v1 -> E1, v2 -> E2|>; isps = {},
    "atomic_massive_line",
      vertices = {v1, v2}; lines = {line[1, vertices, ell, "massive", "h", nuM]};
      loops = {ell}; externals = {}; invariants = {}; energies = <|v1 -> E1, v2 -> E2|>; isps = {},
    "pure_massless_bubble",
      vertices = {v1, v2}; lines = {
        line[1, vertices, q, "massless", "exp", 0],
        line[2, vertices, q - k, "massless", "exp", 0]
      };
      loops = {q}; externals = {k}; invariants = {sp[k, k] -> s11}; energies = <|v1 -> E1, v2 -> E2|>; isps = {},
    "mixed_bubble",
      vertices = {v1, v2}; lines = {
        line[1, vertices, q, "massive", "h", nuM],
        line[2, vertices, q - k, "massless", "exp", 0]
      };
      loops = {q}; externals = {k}; invariants = {sp[k, k] -> s11}; energies = <|v1 -> E1, v2 -> E2|>; isps = {},
    "mixed_triangle",
      vertices = {v1, v2, v3}; lines = {
        line[1, {v1, v2}, q, "massive", "h", nuM],
        line[2, {v2, v3}, q - k1, "massive", "h", nuM],
        line[3, {v3, v1}, q + k2, "massless", "exp", 0]
      };
      loops = {q}; externals = {k1, k2};
      invariants = {sp[k1, k1] -> s11, sp[k1, k2] -> s12, sp[k2, k2] -> s22};
      energies = <|v1 -> E1, v2 -> E2, v3 -> E3|>; isps = {},
    "mixed_sunrise",
      vertices = {v1, v2}; lines = {
        line[1, vertices, q1, "massive", "h", nuM],
        line[2, vertices, q2, "massless", "exp", 0],
        line[3, vertices, q1 - q2 - k, "massless", "exp", 0]
      };
      loops = {q1, q2}; externals = {k}; invariants = {sp[k, k] -> s11};
      energies = <|v1 -> E1, v2 -> E2|>; isps = {sp[q1, k], sp[q2, k]},
    "pure_massive_bubble_reference",
      vertices = {v1, v2}; lines = {
        line[1, vertices, q, "massive", "h", nuM],
        line[2, vertices, q - k, "massive", "h", nuM]
      };
      loops = {q}; externals = {k}; invariants = {sp[k, k] -> s11}; energies = <|v1 -> E1, v2 -> E2|>; isps = {},
    "two_loop_isp_toy",
      vertices = {v1, v2}; lines = {
        line[1, vertices, l3, "massless", "exp", 0],
        line[2, vertices, k321, "massless", "exp", 0],
        line[3, vertices, l3 - k321 - wdnmd, "massless", "exp", 0]
      };
      loops = {l3, k321}; externals = {wdnmd}; invariants = {sp[wdnmd, wdnmd] -> s11};
      energies = <|v1 -> E1, v2 -> E2|>; isps = {sp[l3, k321 + l3], sp[l3, wdnmd]},
    "parallel_massless_bundle_guard",
      vertices = {v1, v2}; lines = {
        line[1, vertices, q, "massless", "exp", 0],
        line[2, vertices, q - k1, "massless", "exp", 0],
        line[3, vertices, q - k2, "massless", "exp", 0]
      };
      loops = {q}; externals = {k1, k2};
      invariants = {sp[k1, k1] -> s11, sp[k1, k2] -> s12, sp[k2, k2] -> s22};
      energies = <|v1 -> E1, v2 -> E2|>; isps = {},
    "vertex_energy_signs",
      vertices = {v1, v2}; lines = {line[1, vertices, ell - k, "massless", "exp", 0]};
      loops = {ell}; externals = {k}; invariants = {sp[k, k] -> s11};
      energies = Switch[energyCase,
        "A", <|v1 -> ke[1], v2 -> ke[2]|>,
        "B", <|v1 -> Sqrt[s11], v2 -> ke[2]|>,
        "C", <|v1 -> ke[3], v2 -> ke[2]|>
      ];
      isps = {sp[ell, k]}
  ];
  baseCase[family <> "-" <> energyCase, vertices, signs, lines, loops, externals, invariants, energies, isps]
];


(* ::Chapter:: *)
(*独立 sector 与生成元 expected*)
expectedSectors = <|
  "atomic_massless_line" -> <|"same" -> {"top", "e1"}, "mixed" -> {"top"}|>,
  "atomic_massive_line" -> <|"same" -> {"top", "e1"}, "mixed" -> {"top"}|>,
  "pure_massless_bubble" -> <|"same" -> {"top", "e1", "e2"}, "mixed" -> {"top"}|>,
  "mixed_bubble" -> <|"same" -> {"top", "e1", "e2"}, "mixed" -> {"top"}|>,
  "mixed_triangle" -> <|"same" -> {"top", "e1", "e2", "e3", "e1_e2", "e1_e3", "e2_e3"}, "mixed" -> {"top", "e3"}|>,
  "mixed_sunrise" -> <|"same" -> {"top", "e1", "e2", "e3", "e1_e2_e3"}, "mixed" -> {"top"}|>,
  "pure_massive_bubble_reference" -> <|"same" -> {"top", "e1", "e2"}, "mixed" -> {"top"}|>,
  "two_loop_isp_toy" -> <|"same" -> {"top", "e1", "e2", "e3", "e1_e2_e3"}, "mixed" -> {"top"}|>,
  "parallel_massless_bundle_guard" -> <|"same" -> {"top", "e1", "e2", "e3", "e1_e2_e3"}, "mixed" -> {"top"}|>,
  "vertex_energy_signs" -> <|"same" -> {"top", "e1"}, "mixed" -> {"top"}|>
|>;

expectedGenerators = <|
  "atomic_massless_line" -> {{"dtau", v1}, {"dtau", v2}, {"dqq", 1, 1}},
  "atomic_massive_line" -> {{"dtau", v1}, {"dtau", v2}, {"dqq", 1, 1}},
  "pure_massless_bubble" -> {{"dtau", v1}, {"dtau", v2}, {"dqq", 1, 1}, {"dqk", 1, 1}},
  "mixed_bubble" -> {{"dtau", v1}, {"dtau", v2}, {"dqq", 1, 1}, {"dqk", 1, 1}},
  "mixed_triangle" -> {{"dtau", v1}, {"dtau", v2}, {"dtau", v3}, {"dqq", 1, 1}, {"dqk", 1, 1}, {"dqk", 1, 2}},
  "mixed_sunrise" -> {{"dtau", v1}, {"dtau", v2}, {"dqq", 1, 1}, {"dqq", 1, 2}, {"dqk", 1, 1}, {"dqq", 2, 1}, {"dqq", 2, 2}, {"dqk", 2, 1}},
  "pure_massive_bubble_reference" -> {{"dtau", v1}, {"dtau", v2}, {"dqq", 1, 1}, {"dqk", 1, 1}},
  "two_loop_isp_toy" -> {{"dtau", v1}, {"dtau", v2}, {"dqq", 1, 1}, {"dqq", 1, 2}, {"dqk", 1, 1}, {"dqq", 2, 1}, {"dqq", 2, 2}, {"dqk", 2, 1}},
  "parallel_massless_bundle_guard" -> {{"dtau", v1}, {"dtau", v2}, {"dqq", 1, 1}, {"dqk", 1, 1}, {"dqk", 1, 2}},
  "vertex_energy_signs" -> {{"dtau", v1}, {"dtau", v2}, {"dqq", 1, 1}, {"dqk", 1, 1}}
|>;

(* package metadata 可返回字符串或带 context 的 Symbol；这里只归一化标签，不改变生成元含义。 *)
tokenName[value_] := StringTrim[
  Last[StringSplit[ToString[Unevaluated[value], InputForm], "`"]],
  "\""
];

generatorKey[{kind_, vertex_}] /; tokenName[kind] === "time" := {"dtau", vertex};
generatorKey[{kind_, i_, direction_, j_}] /; tokenName[kind] === "momentum" := {
  If[tokenName[direction] === "loop", "dqq", "dqk"], i, j
};


(* ::Chapter:: *)
(*全部固定 run*)
runSpecs = {
  {"atomic_massless_line", {1, 1}, "same", "A"}, {"atomic_massless_line", {1, -1}, "mixed", "A"},
  {"atomic_massive_line", {-1, -1}, "same", "A"}, {"atomic_massive_line", {-1, 1}, "mixed", "A"},
  {"pure_massless_bubble", {-1, -1}, "same", "A"}, {"pure_massless_bubble", {1, -1}, "mixed", "A"},
  {"mixed_bubble", {1, 1}, "same", "A"}, {"mixed_bubble", {-1, 1}, "mixed", "A"},
  {"mixed_triangle", {-1, -1, -1}, "same", "A"}, {"mixed_triangle", {1, -1, 1}, "mixed", "A"},
  {"mixed_sunrise", {1, 1}, "same", "A"}, {"mixed_sunrise", {1, -1}, "mixed", "A"},
  {"pure_massive_bubble_reference", {-1, -1}, "same", "A"}, {"pure_massive_bubble_reference", {-1, 1}, "mixed", "A"},
  {"two_loop_isp_toy", {1, 1}, "same", "A"}, {"two_loop_isp_toy", {-1, 1}, "mixed", "A"},
  {"parallel_massless_bundle_guard", {-1, -1}, "same", "A"}, {"parallel_massless_bundle_guard", {1, -1}, "mixed", "A"},
  {"vertex_energy_signs", {1, 1}, "same", "A"}, {"vertex_energy_signs", {-1, 1}, "mixed", "A"},
  {"vertex_energy_signs", {1, 1}, "same", "B"}, {"vertex_energy_signs", {-1, 1}, "mixed", "B"},
  {"vertex_energy_signs", {1, 1}, "same", "C"}, {"vertex_energy_signs", {-1, 1}, "mixed", "C"}
};

runOne[spec_List] := Module[
  {family = spec[[1]], signs = spec[[2]], branch = spec[[3]], energyCase = spec[[4]],
   case, context, seeds, records, actualSectors, actualGenerators, ispCount, nonzeroISPQ, checks},
  case = makeFamilyCase[family, signs, energyCase];
  context = DSInit[case, RegisterAsCurrent -> False, ProgressReporting -> False];
  seeds = DSSeeds[
    context,
    UseSampleOnly -> If[Lookup[case, "ispData"] === {}, True, False],
    DiscreteMode -> "all",
    GenerateShrinkSectors -> True,
    MaxEquationCount -> 10000,
    ProgressReporting -> False
  ];
  records = Lookup[seeds, "equations", {}];
  actualSectors = Lookup[Lookup[context, "sectors", {}], "sectorKey", {}];
  actualGenerators = DeleteDuplicates[generatorKey /@ Lookup[records, "generator", {}]];
  ispCount = Length[Lookup[case, "ispData"]];
  nonzeroISPQ = If[ispCount === 0,
    True,
    And @@ Table[
      AnyTrue[
        Lookup[records, "continuousRules", {}],
        Lookup[Association[#], ispN[index], 0] === 1 &
      ],
      {index, ispCount}
    ]
  ];
  checks = <|
    "initialized" -> (Lookup[context, "status", "failed"] === "initialized"),
    "seedGenerated" -> (Lookup[seeds, "dSIBPStatus", "failed"] === "generated"),
    "sectorSet" -> (Sort[actualSectors] === Sort[Lookup[expectedSectors[family], branch]]),
    "generatorSet" -> (Sort[actualGenerators] === Sort[expectedGenerators[family]]),
    "canonical" -> TrueQ[Lookup[seeds, "completeCanonicalQ", False]],
    "nonzeroISP" -> nonzeroISPQ,
    "nonempty" -> (Length[records] > 0)
  |>;
  <|
    "family" -> family, "signs" -> signs, "branch" -> branch, "energyCase" -> energyCase,
    "sectorKeys" -> actualSectors, "equationCount" -> Length[records],
    "checks" -> checks, "passed" -> And @@ Values[checks]
  |>
];

runResults = runOne /@ runSpecs;
summary = <|
  "packageHash" -> FileHash[packagePath, "SHA256", "HexString"],
  "passed" -> Count[runResults, _?(TrueQ[Lookup[#, "passed", False]] &)],
  "total" -> Length[runResults],
  "equationCount" -> Total[Lookup[runResults, "equationCount"]],
  "failures" -> Select[runResults, ! TrueQ[Lookup[#, "passed", False]] &],
  "byRun" -> runResults
|>;

Put[summary, resultPath];
Print[InputForm[summary]];
If[summary["passed"] =!= summary["total"], Exit[1]];
