(* ::Package:: *)
(* 本文件把 derivation.md 中逐式得到的 atomic massive 公式展开为 78 条扁平 expected。
   它不加载 package 或旧 helper；每个 helper 只对应一条已写明的物理恒等式。 *)

ClearAll["Global`*"];


(* ::Chapter:: *)
(*独立原子公式*)

(* ::Section::Closed:: *)
(*J 构造与 mode 参数*)
kappaM = 4 I Exp[Pi Im[nuM]]/Pi;

topJ[da1_, da2_, db_, nn1_, nn2_] :=
  J[{da1, da2}, {{db, nn1, nn2}}, {}];

shrunkJ[da_, db_] := J[{da}, {{db}}, {}];

modeZeroPointShift["h"] := 2 nuM;
modeZeroPointShift["H"] := 0;


(* ::Section::Closed:: *)
(*端点 time 导数；输入 n 只允许 0/1，输出已立即 EOM*)
timeEndpointTerm[mode_, 1, 0, n2_] := -topJ[0, 0, -1, 1, n2];
timeEndpointTerm[mode_, 2, n1_, 0] := -topJ[0, 0, -1, n1, 1];

timeEndpointTerm["h", 1, 1, n2_] :=
  topJ[0, 0, -1, 0, n2] + (2 nuM + 1) topJ[-1, 0, 0, 1, n2];
timeEndpointTerm["h", 2, n1_, 1] :=
  topJ[0, 0, -1, n1, 0] + (2 nuM + 1) topJ[0, -1, 0, n1, 1];

timeEndpointTerm["H", 1, 1, n2_] :=
  topJ[0, 0, -1, 0, n2] + topJ[-1, 0, 0, 1, n2] -
   nuM^2 topJ[-2, 0, 1, 0, n2];
timeEndpointTerm["H", 2, n1_, 1] :=
  topJ[0, 0, -1, n1, 0] + topJ[0, -1, 0, n1, 1] -
   nuM^2 topJ[0, -2, 1, n1, 0];


(* ::Section::Closed:: *)
(*径向 momentum 导数；x F' 的时间与动量幂同时移位*)
momentumEndpointTerm[mode_, 1, 0, n2_] := topJ[1, 0, -1, 1, n2];
momentumEndpointTerm[mode_, 2, n1_, 0] := topJ[0, 1, -1, n1, 1];

momentumEndpointTerm["h", 1, 1, n2_] :=
  -topJ[1, 0, -1, 0, n2] - (2 nuM + 1) topJ[0, 0, 0, 1, n2];
momentumEndpointTerm["h", 2, n1_, 1] :=
  -topJ[0, 1, -1, n1, 0] - (2 nuM + 1) topJ[0, 0, 0, n1, 1];

momentumEndpointTerm["H", 1, 1, n2_] :=
  -topJ[1, 0, -1, 0, n2] - topJ[0, 0, 0, 1, n2] +
   nuM^2 topJ[-1, 0, 1, 0, n2];
momentumEndpointTerm["H", 2, n1_, 1] :=
  -topJ[0, 1, -1, n1, 0] - topJ[0, 0, 0, n1, 1] +
   nuM^2 topJ[0, -1, 1, n1, 0];


(* ::Section::Closed:: *)
(*同分支 theta contact；cross case 或 Wronskian 为零的端点态返回 0*)
contactStateSign[1, 0] := 1;
contactStateSign[0, 1] := -1;
contactStateSign[_, _] := 0;

branchContactSign["++"] := 1;
branchContactSign["--"] := -1;
branchContactSign[_] := 0;

contactTerm[signCase_, endpoint_, n1_, n2_] :=
  branchContactSign[signCase] * If[endpoint === 1, 1, -1] *
   contactStateSign[n1, n2] * kappaM * shrunkJ[-1, 1];


(* ::Chapter:: *)
(*扁平 expectedRelations*)

(* ::Section::Closed:: *)
(*Top sector：两个冻结 sign、四个端点态、三个完整生成元*)
signRules = <|
   "--" -> {-1, -1}, "-+" -> {-1, 1}
   |>;

topTimeEquation[mode_, signCase_, endpoint_, n1_, n2_] := Module[
  {signs = signRules[signCase], seed = topJ[0, 0, 0, n1, n2], powerTerm,
   phaseTerm},
  powerTerm = If[endpoint === 1,
    -alpha1 topJ[-1, 0, 0, n1, n2],
    -alpha2 topJ[0, -1, 0, n1, n2]
    ];
  phaseTerm = -I signs[[endpoint]] If[endpoint === 1, E1, E2] seed;
  Expand[powerTerm + phaseTerm +
    timeEndpointTerm[mode, endpoint, n1, n2] +
    contactTerm[signCase, endpoint, n1, n2]]
  ];

topMomentumEquation[mode_, n1_, n2_] := Expand[
   (d - beta1) topJ[0, 0, 0, n1, n2] +
    momentumEndpointTerm[mode, 1, n1, n2] +
    momentumEndpointTerm[mode, 2, n1, n2]
   ];

topRelations = Flatten@Table[
    Join[
     Table[
      <|
       "sector" -> "top", "vertexSigns" -> signCase,
       "generator" -> dtau[If[endpoint === 1, v1, v2]],
       "seedRules" -> {a[v1] -> 0, a[v2] -> 0, b[1] -> 0,
         n[1, 1] -> n1, n[1, 2] -> n2},
       "equation" -> topTimeEquation[mode, signCase, endpoint, n1, n2],
       "tags" -> {If[mode === "h", "hMode", "HMode"], "topSector",
         If[endpoint === 1, "massiveEndpoint1", "massiveEndpoint2"],
         "massiveEOM",
         If[contactStateSign[n1, n2] =!= 0 && branchContactSign[signCase] =!= 0,
          "thetaShrink", "noThetaShrink"]}
       |>,
      {endpoint, {1, 2}}],
     {
      <|
       "sector" -> "top", "vertexSigns" -> signCase,
       "generator" -> dqq[1, 1],
       "seedRules" -> {a[v1] -> 0, a[v2] -> 0, b[1] -> 0,
         n[1, 1] -> n1, n[1, 2] -> n2},
       "equation" -> topMomentumEquation[mode, n1, n2],
       "tags" -> {If[mode === "h", "hMode", "HMode"], "topSector",
         "momentumRadial", "massiveEOM"}
       |>
      }
     ],
    {mode, {"h", "H"}}, {signCase, Keys[signRules]},
    {n1, {0, 1}}, {n2, {0, 1}}];


(* ::Section::Closed:: *)
(*Shrunk sector：同分支各保留一个 merged-time 与一个径向 momentum 关系*)
shrunkTimeEquation[mode_, signCase_] := Module[
  {sigma = branchContactSign[signCase], z = modeZeroPointShift[mode]},
  Expand[-(alpha1 + alpha2 - z) shrunkJ[-1, 0] -
    I sigma (E1 + E2) shrunkJ[0, 0]]
  ];

shrunkMomentumEquation[mode_] := Module[
  {z = modeZeroPointShift[mode]},
  Expand[(d - beta1 - z) shrunkJ[0, 0]]
  ];

shrunkRelations = Flatten@Table[
    {
     <|
      "sector" -> "e1", "vertexSigns" -> signCase,
      "generator" -> dtau[v1],
      "seedRules" -> {a[v1] -> 0, bS[1] -> 0},
      "equation" -> shrunkTimeEquation[mode, signCase],
      "tags" -> {If[mode === "h", "hMode", "HMode"], "shrunkSector",
        "compactMergedVertex", "derivedZeroPoint"}
      |>,
     <|
      "sector" -> "e1", "vertexSigns" -> signCase,
      "generator" -> dqq[1, 1],
      "seedRules" -> {a[v1] -> 0, bS[1] -> 0},
      "equation" -> shrunkMomentumEquation[mode],
      "tags" -> {If[mode === "h", "hMode", "HMode"], "shrunkSector",
        "momentumRadial", "derivedZeroPoint"}
      |>
     },
    {mode, {"h", "H"}}, {signCase, {"--"}}];

baseRouteRelations = Join[topRelations, shrunkRelations];

(* HToh 的物理 expected 是独立基变换后的 h 基底关系；只替换路线 tag，
   equation 本身必须与 direct-h 位于同一 J 指标 convention。 *)
hTohRelations = Map[
   Function[record,
    Join[record, <|"tags" -> (record["tags"] /. "hMode" -> "HTohMode")|>]
    ],
   Select[baseRouteRelations, MemberQ[#1["tags"], "hMode"] &]
   ];

expectedRelations = Join[baseRouteRelations, hTohRelations];


(* ::Chapter:: *)
(*冻结前结构门禁*)

relationLinearInJQ[expr_] := Module[
  {expanded = Expand[expr], terms},
  terms = If[Head[expanded] === Plus, List @@ expanded, {expanded}];
  And @@ (! FreeQ[#1, _J] & /@ terms)
  ];

expectedSummary = <|
   "relationCount" -> Length[expectedRelations],
   "byMode" -> Counts[(First@Select[#1["tags"], MemberQ[{"hMode", "HMode", "HTohMode"}, #] &] &) /@
      expectedRelations],
   "bySector" -> Counts[Lookup[expectedRelations, "sector"]],
   "fieldShapeQ" -> And @@ (Sort[Keys[#]] ===
        Sort[{"sector", "vertexSigns", "generator", "seedRules", "equation", "tags"}] & /@
      expectedRelations),
   "linearInJQ" -> And @@ (relationLinearInJQ /@ Lookup[expectedRelations, "equation"]),
   "resolvedHelperQ" -> FreeQ[
     Lookup[expectedRelations, "equation"],
     _topJ | _shrunkJ | _timeEndpointTerm | _momentumEndpointTerm | _contactTerm
     ],
   "forbiddenMassiveNQ" -> (Cases[
       Lookup[expectedRelations, "equation"],
       HoldPattern[J[_, {{_, nFirst_Integer, nSecond_Integer}}, _]] /;
        nFirst >= 2 || nSecond >= 2,
       Infinity
       ] === {})
   |>;

If[expectedSummary["relationCount"] =!= 78 || ! TrueQ[expectedSummary["fieldShapeQ"]] ||
  ! TrueQ[expectedSummary["linearInJQ"]] || ! TrueQ[expectedSummary["resolvedHelperQ"]] ||
  ! TrueQ[expectedSummary["forbiddenMassiveNQ"]],
 Exit[1]
 ];

expectedSummary
