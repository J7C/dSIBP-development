(* ::Package:: *)
(* 本脚本单向读取 pure_massive_bubble_reference 的三路 frozen expected，并用
   package_012.wl 检查全部 seed、s11 总导数、AT、WT 与 shrinkTerms。
   reference-only k0/ks、symmetry、parity 由独立脚本另行检查。 *)


(* ::Chapter:: *)
(*路径与冻结输入*)

checkDir = DirectoryName[$InputFileName];
benchmarkDir = DirectoryName[checkDir];
workspaceDir = DirectoryName[benchmarkDir];

Get[FileNameJoin[{
    benchmarkDir, "pure_massive_bubble_reference", "expected.wl"
    }]];
frozenFamily = familyDefinition;
frozenRelations = expectedRelations;
frozenDerivatives = expectedDerivatives;
frozenSummary = expectedSummary;

Get[FileNameJoin[{
    workspaceDir, "independent-benchmark", "package", "package_012.wl"
    }]];


(* ::Chapter:: *)
(*三路显式函数系统*)

routeKappa = 4 I Exp[Pi Im[nuM]]/Pi;
routeHToh = {{x^-nuM, 0}, {-nuM x^(-nuM - 1), x^-nuM}};

routeFunctionSystem["direct-h"] := <|
   "variable" -> x, "P" -> (2 nuM + 1)/x, "Q" -> 1,
   "T" -> IdentityMatrix[2], "W" -> -routeKappa x^(-2 nuM - 1),
   "shrinkBShift" -> 1, "shrinkZeroPointShift" -> 2 nuM
   |>;
routeFunctionSystem["bare-H"] := <|
   "variable" -> x, "P" -> 1/x, "Q" -> 1 - nuM^2/x^2,
   "T" -> IdentityMatrix[2], "W" -> -routeKappa/x,
   "shrinkBShift" -> 1, "shrinkZeroPointShift" -> 0
   |>;
routeFunctionSystem["H-to-h"] := Join[
   routeFunctionSystem["bare-H"],
   <|"T" -> routeHToh, "shrinkZeroPointShift" -> 2 nuM|>
   ];

routeLineData[route_] := Map[
   Function[line,
    Join[line, <|
      "bbType" -> If[route === "direct-h", "h", "H"],
      "functionSystem" -> routeFunctionSystem[route]
      |>]
    ],
   frozenFamily["lineData"]
   ];

routeCase[route_, signCase_] := <|
   "name" -> "codexReferenceRoute_" <> route <> "_" <> signCase,
   "vertexData" -> Transpose[{
      frozenFamily["vertexOrder"],
      Characters[signCase]
      }],
   "lineData" -> routeLineData[route],
   "loopMomenta" -> frozenFamily["loopMomenta"],
   "externalMomenta" -> frozenFamily["externalMomenta"],
   "externalInvariantRules" -> frozenFamily["externalInvariantRules"],
   "vertexEnergies" -> frozenFamily["vertexEnergies"],
   "ispData" -> {},
   "zeroPointRules" -> frozenFamily["zeroPointRules"],
   "symmetryRules" -> {},
   "seedPreset" -> "quickCheck"
   |>;

routes = {"direct-h", "bare-H", "H-to-h"};
signCases = {"--", "-+"};
topologyCache = Association@Flatten@Table[
    (route <> "|" <> signCase) -> parseTopology[routeCase[route, signCase]],
    {route, routes}, {signCase, signCases}
    ];

selectedLines["top"] := {};
selectedLines[name_String] := ToExpression /@ StringCases[
   name,
   "e" ~~ digits : DigitCharacter .. :> digits
   ];

routeTopology[route_, signCase_, sector_] := Module[
  {topo = topologyCache[route <> "|" <> signCase], selected = selectedLines[sector]},
  If[selected === {}, topo, shrinkSectorTopology[topo, selected]]
  ];

topologyStatusQ = And @@ (
    Lookup[topologyValidationReport[#1], "status", "invalid"] === "ok" & /@
     Values[topologyCache]
    );


(* ::Chapter:: *)
(*逐条 relation 与 ds 对照*)

relationRoute[record_Association] := StringDrop[
   SelectFirst[record["tags"], StringStartsQ[#1, "basisRoute:"] &],
   StringLength["basisRoute:"]
   ];

zeroDifferenceQ[difference_] := TrueQ[difference === 0] ||
  TrueQ[Quiet[FullSimplify[difference == 0]]];

relationActual[record_Association] := Module[
  {route = relationRoute[record], topo, integral, generator = record["generator"], actual},
  topo = routeTopology[route, record["vertexSigns"], record["sector"]];
  integral = makeBaseIntegral[topo] /. record["seedRules"];
  actual = Which[
    Head[generator] === dtau, dtau[generator[[1]], integral, topo],
    Head[generator] === dqq, dqq[generator[[1]], generator[[2]], integral, topo],
    Head[generator] === dqk, dqk[generator[[1]], generator[[2]], integral, topo],
    True, $Failed
    ];
  If[actual === $Failed, $Failed,
   If[Head[generator] === dtau, actual, rep2outform[actual, topo]]
   ]
  ];

relationRows = MapIndexed[
   Function[{record, position},
    Module[{route = relationRoute[record], actual, difference, passQ},
     actual = relationActual[record];
     difference = If[actual === $Failed, $Failed,
       Expand[(actual /. dim -> d) - record["equation"]]
       ];
     passQ = zeroDifferenceQ[difference];
     <|
      "index" -> First[position], "route" -> route,
      "sector" -> record["sector"], "vertexSigns" -> record["vertexSigns"],
      "generator" -> record["generator"], "seedRules" -> record["seedRules"],
      "actual" -> actual, "passQ" -> passQ,
      "difference" -> If[passQ, 0, difference]
      |>
     ]
    ],
   frozenRelations
   ];
relationFailures = Select[relationRows, ! TrueQ[#1["passQ"]] &];

derivativeRows = MapIndexed[
   Function[{record, position},
    Module[{route = record["mode"], topo, actual, difference, passQ},
     topo = routeTopology[route, record["vertexSigns"], record["sector"]];
     actual = ds[record["expression"], record["variable"], topo];
     difference = If[actual === $Failed, $Failed,
       Expand[(actual /. dim -> d) - record["derivative"]]
       ];
     passQ = zeroDifferenceQ[difference];
     <|
      "index" -> First[position], "route" -> route,
      "sector" -> record["sector"], "vertexSigns" -> record["vertexSigns"],
      "variable" -> record["variable"], "actual" -> actual,
      "passQ" -> passQ, "difference" -> If[passQ, 0, difference]
      |>
     ]
    ],
   frozenDerivatives
   ];
derivativeFailures = Select[derivativeRows, ! TrueQ[#1["passQ"]] &];


(* ::Chapter:: *)
(*H-to-h 与 direct-h 直接比较*)

directRelationRows = Select[relationRows, #1["route"] === "direct-h" &];
hTohRelationRows = Select[relationRows, #1["route"] === "H-to-h" &];
directRelationDifferences = MapThread[
   Expand[(#1["actual"] /. dim -> d) - (#2["actual"] /. dim -> d)] &,
   {directRelationRows, hTohRelationRows}
   ];
directRelationAgreementQ = And @@ (zeroDifferenceQ /@ directRelationDifferences);

directDerivativeRows = Select[derivativeRows, #1["route"] === "direct-h" &];
hTohDerivativeRows = Select[derivativeRows, #1["route"] === "H-to-h" &];
directDerivativeDifferences = MapThread[
   Expand[(#1["actual"] /. dim -> d) - (#2["actual"] /. dim -> d)] &,
   {directDerivativeRows, hTohDerivativeRows}
   ];
directDerivativeAgreementQ = And @@ (zeroDifferenceQ /@ directDerivativeDifferences);


(* ::Chapter:: *)
(*AT、WT 与 shrinkTerms*)

compiledLineData[route_, linePosition_] :=
  topologyCache[route <> "|--"]["lines"][[linePosition]]["compiledFunctionSystem"];

expectedATH = {{0, 1}, {-(1 - nuM^2/x^2), -1/x}};
expectedATh = {{0, 1}, {-1, -(2 nuM + 1)/x}};
expectedWTH = -routeKappa/x;
expectedWTh = -routeKappa x^(-2 nuM - 1);

zeroArrayQ[array_] := And @@ (zeroDifferenceQ /@ Flatten[array]);

compiledRows = Flatten@Table[
    Module[{compiled = compiledLineData[route, linePosition], expectedAT, expectedWT},
     expectedAT = If[route === "bare-H", expectedATH, expectedATh];
     expectedWT = If[route === "bare-H", expectedWTH, expectedWTh];
     <|
      "route" -> route, "line" -> linePosition,
      "ATQ" -> zeroArrayQ[compiled["AT"] - expectedAT],
      "WTQ" -> zeroDifferenceQ[compiled["WT"] - expectedWT]
      |>
     ],
    {route, routes}, {linePosition, {1, 2}}
    ];
compiledPassQ = And @@ Flatten[
    ({#1["ATQ"], #1["WTQ"]} &) /@ compiledRows
    ];

hTohCompiledAgreementQ = And @@ Flatten@Table[
    Module[{direct = compiledLineData["direct-h", linePosition],
      transformed = compiledLineData["H-to-h", linePosition]},
     {
      zeroArrayQ[direct["AT"] - transformed["AT"]],
      zeroDifferenceQ[direct["WT"] - transformed["WT"]],
      TrueQ[direct["shrinkTerms"] === transformed["shrinkTerms"]]
      }
     ],
    {linePosition, {1, 2}}
    ];


(* ::Chapter:: *)
(*汇总*)

checkSummary = <|
   "topologyStatusQ" -> topologyStatusQ,
   "relationCount" -> Length[relationRows],
   "relationPassed" -> Count[Lookup[relationRows, "passQ"], True],
   "relationFailed" -> Length[relationFailures],
   "relationByRoute" -> Counts[Lookup[relationRows, "route"]],
   "derivativeCount" -> Length[derivativeRows],
   "derivativePassed" -> Count[Lookup[derivativeRows, "passQ"], True],
   "derivativeFailed" -> Length[derivativeFailures],
   "derivativeByRoute" -> Counts[Lookup[derivativeRows, "route"]],
   "hTohVsDirectRelationCount" -> Length[directRelationDifferences],
   "hTohVsDirectRelationQ" -> directRelationAgreementQ,
   "hTohVsDirectDerivativeCount" -> Length[directDerivativeDifferences],
   "hTohVsDirectDerivativeQ" -> directDerivativeAgreementQ,
   "compiledRows" -> compiledRows,
   "hTohVsDirectCompiledQ" -> hTohCompiledAgreementQ,
   "passQ" -> TrueQ[topologyStatusQ] && relationFailures === {} &&
     derivativeFailures === {} && TrueQ[directRelationAgreementQ] &&
     TrueQ[directDerivativeAgreementQ] && TrueQ[compiledPassQ] &&
     TrueQ[hTohCompiledAgreementQ]
   |>;

Print[InputForm[checkSummary]];
If[relationFailures =!= {},
 Print["FIRST_RELATION_FAILURES"];
 Print[InputForm[Take[relationFailures, UpTo[4]]]]
 ];
If[derivativeFailures =!= {},
 Print["FIRST_DERIVATIVE_FAILURES"];
 Print[InputForm[Take[derivativeFailures, UpTo[4]]]]
 ];

If[! TrueQ[checkSummary["passQ"]], Exit[1]];
