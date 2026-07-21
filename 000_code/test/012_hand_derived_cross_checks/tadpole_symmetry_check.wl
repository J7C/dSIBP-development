(* ::Package:: *)
(* tadpole symmetry 与独立变量导数批量生成的 hand-derived 交叉检查。*)

exampleDir = DirectoryName[$InputFileName];
codeDir = DirectoryName[DirectoryName[exampleDir]];
handDerivedDir = FileNameJoin[{codeDir, "test", "012_hand-derived", "tadpole_symmetry"}];
Get[FileNameJoin[{codeDir, "012_dS_ibp_general.wl"}]];
Get[FileNameJoin[{handDerivedDir, "family.wl"}]];
Get[FileNameJoin[{handDerivedDir, "expected.wl"}]];

massiveTopo = parseTopology[makeTadpoleCase["massive", False, {}]];
massiveInt = makeBaseIntegral[massiveTopo] /. {a[v] -> 0, b[1] -> 0, n[1, 1] -> 1, n[1, 2] -> 0};
massiveActual = symmetry[massiveInt, massiveTopo];
massiveExpected = expectedTadpoleMassiveSwap[massiveInt];
massivePassQ = TrueQ[massiveActual === massiveExpected];

masslessTopo = parseTopology[makeTadpoleCase["massless", False, {}]];
masslessInt = makeBaseIntegral[masslessTopo] /. {a[v] -> 0, b[1] -> 0, n[1] -> 1};
masslessPassQ = TrueQ[symmetry[masslessInt, masslessTopo] === expectedTadpoleMasslessZero[masslessInt]];

oddISPTopo = parseTopology[makeTadpoleCase["massive", True, {}]];
oddISPInt = makeBaseIntegral[oddISPTopo] /. {a[v] -> 0, b[1] -> 0, n[1, 1] -> 0, n[1, 2] -> 0, ispN[1] -> 1};
oddISPActual = symmetry[oddISPInt, oddISPTopo];
oddISPPassQ = TrueQ[oddISPActual === expectedTadpoleOddISPZero[oddISPInt]];

sharedLoopCase = Module[{case = makeTadpoleCase["massive", True, {}]},
   Join[case, <|
     "vertexData" -> {{v, "+"}, {w, "-"}},
     "vertexEnergies" -> <|v -> ke[1], w -> ke[2]|>,
     "lineData" -> Append[
       case["lineData"],
       <|"id" -> 2, "endpoints" -> {v, w}, "momentum" -> ell - k, "massType" -> "massless", "bbType" -> "exp", "nu" -> 0|>
       ],
     "zeroPointRules" -> Join[case["zeroPointRules"], {a0[w] -> alphaW, b0[2] -> beta2, bS0[2] -> beta2}]
     |>]
   ];
sharedLoopTopo = parseTopology[sharedLoopCase];
sharedLoopInt = makeBaseIntegral[sharedLoopTopo] /. {
    a[v] -> 0, a[w] -> 0, b[1] -> 0, b[2] -> 0,
    n[1, 1] -> 0, n[1, 2] -> 0, ispN[1] -> 1
    };
sharedLoopGuardPassQ = TrueQ[
   tadpoleLoopReversalData[sharedLoopTopo][[1]]["exclusiveLoopQ"] === False &&
    symmetry[sharedLoopInt, sharedLoopTopo] === sharedLoopInt
   ];

crossCase = Module[{case = makeTadpoleCase["massive", False, {}]},
   Join[case, <|"lineData" -> {Join[case["lineData"][[1]], <|"skType" -> "+-"|>]}|>]
   ];
crossTopo = parseTopology[crossCase];
crossInt = makeBaseIntegral[crossTopo] /. {a[v] -> 0, b[1] -> 0, n[1, 1] -> 1, n[1, 2] -> 0};
crossGuardPassQ = TrueQ[symmetry[crossInt, crossTopo] === crossInt && crossTopo["lines"][[1]]["packType"] === "massiveCross"];

userRule = HoldPattern[J[{0}, {{0, 0, 1}}, {}]] :> expectedTadpoleUserRule[J[{0}, {{0, 0, 1}}, {}]];
unionTopo = parseTopology[makeTadpoleCase["massive", False, {userRule}]];
unionInt = makeBaseIntegral[unionTopo] /. {a[v] -> 0, b[1] -> 0, n[1, 1] -> 0, n[1, 2] -> 1};
unionPassQ = TrueQ[
   Length[effectiveSymmetryRules0[unionTopo]] === Length[tadpoleSymmetryRules0[unionTopo]] + 1 &&
    symmetry[unionInt, unionTopo] === expectedTadpoleUserRule[unionInt]
   ];

topologyData = makeTopologyData[makeTadpoleCase["massive", False, {userRule}]];
metadataPassQ = TrueQ[
   KeyExistsQ[topologyData, "tadpoleSymmetryData"] &&
    topologyData["tadpoleSymmetryData"]["effectiveRuleCount"] === Length[effectiveSymmetryRules0[topologyData]]
   ];

derivativeTopo = parseTopology[makeTadpoleDerivativeCase[]];
derivativeInt = makeBaseIntegral[derivativeTopo] /. {a[v] -> 0, b[1] -> 0, n[1, 1] -> 0, n[1, 2] -> 0, ispN[1] -> 0};
derivativeBatch = makeIndependentVariableDerivativeSeedBatch[derivativeTopo, derivativeInt];
derivativeExpected = expectedDerivativeBatchVariables[derivativeTopo];
derivativePassQ = TrueQ[
   derivativeBatch["status"] === "generated" &&
    derivativeBatch["variables"] === derivativeExpected &&
    And @@ MapThread[
      Expand[#1["derivative"] - expectedDerivativeBatchEquation[derivativeTopo, derivativeInt, #2["kind"]]] === 0 &,
      {derivativeBatch["equations"], derivativeExpected}
      ]
   ];

Print["tadpole massive swap: ", massivePassQ];
Print["tadpole massless n=1 zero: ", masslessPassQ];
Print["tadpole odd ISP zero: ", oddISPPassQ];
Print["shared-loop odd ISP guard: ", sharedLoopGuardPassQ];
Print["G+- tadpole guard: ", crossGuardPassQ];
Print["automatic/user symmetry union: ", unionPassQ];
Print["full-sector symmetry metadata: ", metadataPassQ];
Print["independent derivative batch: ", derivativePassQ];

If[! And[massivePassQ, masslessPassQ, oddISPPassQ, sharedLoopGuardPassQ, crossGuardPassQ, unionPassQ, metadataPassQ, derivativePassQ],
 Print["Derivative batch: ", derivativeBatch];
 Exit[1]
 ];
