(* ::Package:: *)
(* 本脚本单向读取 frozen atomic_massive_line expected 与正式 package_012.wl，
   对 direct-h、bare-H 与 H-to-h 的 78 条记录逐条生成 actual，并检查 AT、WT
   与 shrinkTerms。失败只落在 check 层，不修改手推文件。 *)

ClearAll["Global`*"];

Get[FileNameJoin[{
    DirectoryName[DirectoryName[$InputFileName]],
    "atomic_massive_line", "expected.wl"
    }]];
frozenExpectedRelations = expectedRelations;
frozenExpectedSummary = expectedSummary;


(* ::Chapter:: *)
(*路径与冻结输入*)

checkDir = DirectoryName[$InputFileName];
benchmarkDir = DirectoryName[checkDir];
workspaceDir = DirectoryName[benchmarkDir];
packagePath = FileNameJoin[{workspaceDir, "independent-benchmark", "package", "package_012.wl"}];

Get[packagePath];


(* ::Chapter:: *)
(*Package topology 实例*)

(* ::Section::Closed:: *)
(* 三路都把公式输入显式保存；H-to-h 只改变 T，不改变裸 H 的 P、Q、W。 *)
atomicKappa = 4 I Exp[Pi Im[nuM]]/Pi;
atomicHToh = {{x^-nuM, 0}, {-nuM x^(-nuM - 1), x^-nuM}};

atomicFunctionSystem["direct-h"] := <|
   "variable" -> x, "P" -> (2 nuM + 1)/x, "Q" -> 1,
   "T" -> IdentityMatrix[2], "W" -> -atomicKappa x^(-2 nuM - 1),
   "shrinkBShift" -> 1, "shrinkZeroPointShift" -> 2 nuM
   |>;
atomicFunctionSystem["bare-H"] := <|
   "variable" -> x, "P" -> 1/x, "Q" -> 1 - nuM^2/x^2,
   "T" -> IdentityMatrix[2], "W" -> -atomicKappa/x,
   "shrinkBShift" -> 1, "shrinkZeroPointShift" -> 0
   |>;
atomicFunctionSystem["H-to-h"] := Join[
   atomicFunctionSystem["bare-H"],
   <|"T" -> atomicHToh, "shrinkZeroPointShift" -> 2 nuM|>
   ];

makeAtomicCase[route_, signCase_] := <|
   "name" -> "codexAtomicMassive_" <> route <> "_" <> signCase,
   "vertexData" -> Transpose[{{v1, v2}, Characters[signCase]}],
   "lineData" -> {
     <|
      "id" -> 1, "endpoints" -> {v1, v2}, "momentum" -> ell,
      "nu" -> nuM,
      "bbType" -> If[route === "direct-h", "h", "H"],
      "massType" -> "massive",
      "functionSystem" -> atomicFunctionSystem[route]
      |>
     },
   "loopMomenta" -> {ell},
   "externalMomenta" -> {},
   "externalInvariantRules" -> {},
   "vertexEnergies" -> <|v1 -> E1, v2 -> E2|>,
   "ispData" -> {},
   "zeroPointRules" -> {
     a0[v1] -> alpha1, a0[v2] -> alpha2, b0[1] -> beta1
     },
   "symmetryRules" -> {},
   "seedPreset" -> "quickCheck"
   |>;

topologyCache = Association@Flatten@Table[
    (route <> "|" <> signCase) -> parseTopology[makeAtomicCase[route, signCase]],
    {route, {"direct-h", "bare-H", "H-to-h"}}, {signCase, {"--", "-+"}}];

sectorTopologyCache = Association@Flatten@Table[
    (route <> "|--") ->
     shrinkSectorTopology[topologyCache[route <> "|--"], {1}],
    {route, {"direct-h", "bare-H", "H-to-h"}}];

topologyStatusQ = And @@ (
    Lookup[topologyValidationReport[#], "status", "invalid"] === "ok" & /@
     Values[topologyCache]);


(* ::Chapter:: *)
(*逐条 actual 与差值*)

(* ::Section::Closed:: *)
(*记录中的 route 由 frozen tags 决定，不向 expected 增加第七个字段*)
recordRoute[record_Association] := Which[
   MemberQ[record["tags"], "hMode"], "direct-h",
   MemberQ[record["tags"], "HMode"], "bare-H",
   MemberQ[record["tags"], "HTohMode"], "H-to-h",
   True, Missing["UnknownRoute"]
   ];

recordTopology[record_Association] := Module[
  {key = recordRoute[record] <> "|" <> record["vertexSigns"]},
  If[record["sector"] === "top", topologyCache[key], sectorTopologyCache[key]]
  ];

recordIntegral[record_Association, topo_Association] :=
  makeBaseIntegral[topo] /. record["seedRules"];

recordActual[record_Association] := Module[
  {topo = recordTopology[record], integral, generator = record["generator"]},
  integral = recordIntegral[record, topo];
  Which[
   MatchQ[generator, dtau[_]], dtau[generator[[1]], integral, topo],
   MatchQ[generator, dqq[_, _]], dqq[generator[[1]], generator[[2]], integral, topo],
   True, $Failed
   ]
  ];

checkRows = MapIndexed[
   Function[{record, position},
    Module[{actual, difference, passQ},
     actual = recordActual[record];
     (* 任务书把空间维数写成 d；正式 package 的公共输出符号是 dim。 *)
     difference = If[actual === $Failed, $Failed,
       Expand[(actual /. dim -> d) - record["equation"]]
       ];
     passQ = TrueQ[difference === 0] ||
       TrueQ[Quiet[FullSimplify[difference == 0]]];
     <|
      "index" -> First[position],
      "route" -> recordRoute[record],
      "sector" -> record["sector"],
      "vertexSigns" -> record["vertexSigns"],
      "generator" -> record["generator"],
      "seedRules" -> record["seedRules"],
      "passQ" -> passQ,
      "difference" -> If[passQ, 0, difference]
      |>
     ]
    ],
   frozenExpectedRelations
   ];

failedRows = Select[checkRows, ! TrueQ[#1["passQ"]] &];


(* ::Chapter:: *)
(*AT、WT 与 shrinkTerms 三路检查*)

compiledRouteData[route_] :=
  topologyCache[route <> "|--"]["lines"][[1]]["compiledFunctionSystem"];

directCompiled = compiledRouteData["direct-h"];
bareCompiled = compiledRouteData["bare-H"];
hTohCompiled = compiledRouteData["H-to-h"];

expectedATH = {{0, 1}, {-(1 - nuM^2/x^2), -1/x}};
expectedATh = {{0, 1}, {-1, -(2 nuM + 1)/x}};
expectedWTH = -atomicKappa/x;
expectedWTh = -atomicKappa x^(-2 nuM - 1);

zeroExpressionQ[expr_] := TrueQ[expr === 0] ||
  TrueQ[Quiet[FullSimplify[expr == 0]]];
zeroArrayQ[array_] := And @@ (zeroExpressionQ /@ Flatten[array]);

compiledChecks = <|
   "directATQ" -> zeroArrayQ[directCompiled["AT"] - expectedATh],
   "bareATQ" -> zeroArrayQ[bareCompiled["AT"] - expectedATH],
   "hTohATQ" -> zeroArrayQ[hTohCompiled["AT"] - expectedATh],
   "directWTQ" -> zeroExpressionQ[directCompiled["WT"] - expectedWTh],
   "bareWTQ" -> zeroExpressionQ[bareCompiled["WT"] - expectedWTH],
   "hTohWTQ" -> zeroExpressionQ[hTohCompiled["WT"] - expectedWTh],
   "hTohVsDirectATQ" -> zeroArrayQ[hTohCompiled["AT"] - directCompiled["AT"]],
   "hTohVsDirectWTQ" -> zeroExpressionQ[hTohCompiled["WT"] - directCompiled["WT"]],
   "hTohVsDirectShrinkTermsQ" -> TrueQ[
     hTohCompiled["shrinkTerms"] === directCompiled["shrinkTerms"]
     ]
   |>;
compiledChecksPassQ = And @@ Values[compiledChecks];


(* ::Chapter:: *)
(*汇总与失败出口*)

checkSummary = <|
   "expectedRelationCount" -> frozenExpectedSummary["relationCount"],
   "actualRelationCount" -> Length[checkRows],
   "passedRelationCount" -> Count[Lookup[checkRows, "passQ"], True],
   "failedRelationCount" -> Length[failedRows],
   "byRoute" -> Counts[Lookup[checkRows, "route"]],
   "derivativeCount" -> 0,
   "compiledChecks" -> compiledChecks,
   "topologyStatusQ" -> topologyStatusQ,
   "forbiddenMassiveNQ" -> (Cases[
       Lookup[checkRows, "difference"],
       HoldPattern[J[_, {{_, nFirst_Integer, nSecond_Integer}}, _]] /;
        nFirst >= 2 || nSecond >= 2,
       Infinity
       ] === {}),
   "passQ" -> TrueQ[topologyStatusQ] && Length[failedRows] === 0 &&
     TrueQ[compiledChecksPassQ]
   |>;

Print[InputForm[checkSummary]];

If[failedRows =!= {},
 Print["FIRST_FAILURES"];
 Print[InputForm[Take[failedRows, UpTo[8]]]]
 ];

If[! TrueQ[checkSummary["passQ"]], Exit[1]];
