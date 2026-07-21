(* ::Package:: *)
(* 通用 per-family package 对照：先加载 frozen expected，再加载 package，逐条调用 public
   dtau/dqq/dqk/ds。脚本不修改 expected；失败保存 record metadata 与差值。 *)


(* ::Chapter:: *)
(*命令行与 frozen 输入*)

scriptArgs = Rest[$ScriptCommandLine];
If[Length[scriptArgs] < 1,
 Print["usage: wolframscript -file check_family_against_package.wl <family>"];
 Exit[2]
 ];

familyName = First[scriptArgs];
checkDir = DirectoryName[$InputFileName];
benchmarkDir = DirectoryName[checkDir];
workspaceDir = DirectoryName[benchmarkDir];
expectedPath = FileNameJoin[{benchmarkDir, familyName, "expected.wl"}];
packagePath = FileNameJoin[{workspaceDir, "independent-benchmark", "package", "package_012.wl"}];

Get[expectedPath];
frozenFamily = familyDefinition;
frozenRelations = expectedRelations;
frozenDerivatives = If[ListQ[expectedDerivatives], expectedDerivatives, {}];
frozenSummary = expectedSummary;

Get[packagePath];


(* ::Chapter:: *)
(*Package topology adapter*)

codexCheckISPData[family_Association] := MapIndexed[
   <|"name" -> rho[First[#2]], "expr" -> #1["expression"], "range" -> {0, 1}|> &,
   family["ispData"]
   ];

codexCheckCase[family_Association, signCase_] := <|
   "name" -> "codexFull_" <> family["name"] <> "_" <> signCase,
   "vertexData" -> Transpose[{
      family["vertexOrder"],
      (If[# === 1, "+", "-"] &) /@ family["vertexSignCases"][signCase]
      }],
   "lineData" -> family["lineData"],
   "loopMomenta" -> family["loopMomenta"],
   "externalMomenta" -> family["externalMomenta"],
   "externalInvariantRules" -> family["externalInvariantRules"],
   "vertexEnergies" -> family["vertexEnergies"],
   "ispData" -> codexCheckISPData[family],
   "zeroPointRules" -> family["zeroPointRules"],
   "symmetryRules" -> {},
   "seedPreset" -> "quickCheck"
   |>;

codexCheckSelectedLines["top"] := {};
codexCheckSelectedLines[name_String] := ToExpression /@ StringCases[
   name,
   "e" ~~ digits : DigitCharacter .. :> digits
   ];

codexCheckTopologies = Association@Table[
   signCase -> parseTopology[codexCheckCase[frozenFamily, signCase]],
   {signCase, Keys[frozenFamily["vertexSignCases"]]}
   ];

codexCheckTopology[signCase_, sectorName_] := Module[
  {topo = codexCheckTopologies[signCase], selected = codexCheckSelectedLines[sectorName]},
  If[selected === {}, topo, shrinkSectorTopology[topo, selected]]
  ];

codexCheckTopologyStatusQ = And @@ (
    Lookup[topologyValidationReport[#], "status", "invalid"] === "ok" & /@
     Values[codexCheckTopologies]
    );


(* ::Chapter:: *)
(*Seed relation 对照*)

codexCheckRelationActual[record_Association] := Module[
  {topo, integral, generator = record["generator"], actual},
  topo = codexCheckTopology[record["vertexSigns"], record["sector"]];
  integral = makeBaseIntegral[topo] /. record["seedRules"];
  actual = Which[
   Head[generator] === dtau, dtau[generator[[1]], integral, topo],
   Head[generator] === dqq, dqq[generator[[1]], generator[[2]], integral, topo],
   Head[generator] === dqk, dqk[generator[[1]], generator[[2]], integral, topo],
   True, $Failed
   ];
  If[actual === $Failed,
   $Failed,
   If[Head[generator] === dtau, actual, rep2outform[actual, topo]]
   ]
  ];

codexCheckZeroDifferenceQ[difference_] := TrueQ[difference === 0] ||
  TrueQ[Quiet[FullSimplify[difference == 0]]];

codexCheckRelationRows = MapIndexed[
   Function[{record, position},
    Module[{actual, difference, passQ},
     actual = codexCheckRelationActual[record];
     difference = If[actual === $Failed, $Failed,
       Expand[(actual /. dim -> d) - record["equation"]]
       ];
     passQ = codexCheckZeroDifferenceQ[difference];
     <|
      "index" -> First[position], "sector" -> record["sector"],
      "vertexSigns" -> record["vertexSigns"], "generator" -> record["generator"],
      "seedRules" -> record["seedRules"], "passQ" -> passQ,
      "difference" -> If[passQ, 0, difference]
      |>
     ]
    ],
   frozenRelations
   ];

codexCheckRelationFailures = Select[codexCheckRelationRows, ! TrueQ[#1["passQ"]] &];


(* ::Chapter:: *)
(*General total derivative 对照*)

codexCheckDerivativeRows = MapIndexed[
   Function[{record, position},
    Module[{topo, actual, difference, passQ},
     topo = codexCheckTopology[record["vertexSigns"], record["sector"]];
     actual = ds[record["expression"], record["variable"], topo];
     difference = If[actual === $Failed, $Failed,
       Expand[(actual /. dim -> d) - record["derivative"]]
       ];
     passQ = codexCheckZeroDifferenceQ[difference];
     <|
      "index" -> First[position], "sector" -> record["sector"],
      "vertexSigns" -> record["vertexSigns"], "mode" -> record["mode"],
      "variable" -> record["variable"], "passQ" -> passQ,
      "difference" -> If[passQ, 0, difference]
      |>
     ]
    ],
   frozenDerivatives
   ];

codexCheckDerivativeFailures = Select[codexCheckDerivativeRows, ! TrueQ[#1["passQ"]] &];


(* ::Chapter:: *)
(*Summary 与失败样本*)

codexCheckSummary = <|
   "family" -> familyName,
   "topologyStatusQ" -> codexCheckTopologyStatusQ,
   "relationCount" -> Length[codexCheckRelationRows],
   "relationPassed" -> Count[Lookup[codexCheckRelationRows, "passQ"], True],
   "relationFailed" -> Length[codexCheckRelationFailures],
   "derivativeCount" -> Length[codexCheckDerivativeRows],
   "derivativePassed" -> Count[Lookup[codexCheckDerivativeRows, "passQ"], True],
   "derivativeFailed" -> Length[codexCheckDerivativeFailures],
   "passQ" -> TrueQ[codexCheckTopologyStatusQ] &&
     codexCheckRelationFailures === {} && codexCheckDerivativeFailures === {}
   |>;

Print[InputForm[codexCheckSummary]];
If[codexCheckRelationFailures =!= {},
 Print["FIRST_RELATION_FAILURES"];
 Print[InputForm[Take[codexCheckRelationFailures, UpTo[4]]]]
 ];
If[codexCheckDerivativeFailures =!= {},
 Print["FIRST_DERIVATIVE_FAILURES"];
 Print[InputForm[Take[codexCheckDerivativeFailures, UpTo[4]]]]
 ];

If[! TrueQ[codexCheckSummary["passQ"]], Exit[1]];
