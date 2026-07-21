(* ::Package:: *)
(* atomic_massless_line：由定义式直接手推的 expected；不得调用主线 seed 函数。 *)

(* ::Chapter:: *)
(*手推原子公式*)

manualBranchSign["+"] := 1;
manualBranchSign["-"] := -1;

manualPhaseCoefficient["+"] := -I;
manualPhaseCoefficient["-"] := I;

manualSigma["++"] := 1;
manualSigma["--"] := -1;

manualMasslessShrinkIntegral = J[{0}, {{0}}, {}];

manualMasslessTopTime[signKey_String, nValue_Integer, vertex_] := Module[
   {signs = atomicMasslessSigns[signKey], sigma, int, regular, power, phase, boundary},
   sigma = manualSigma[signKey];
   int = J[{0, 0}, {{0, nValue}}, {}];
   If[vertex === v1,
    power = -alpha1 J[{-1, 0}, {{0, nValue}}, {}];
    phase = manualPhaseCoefficient[signs[[1]]] E1 int;
    regular = I sigma J[{0, 0}, {{-1, 1 - nValue}}, {}];
    boundary = If[nValue === 1, -2 manualMasslessShrinkIntegral, 0],
    power = -alpha2 J[{0, -1}, {{0, nValue}}, {}];
    phase = manualPhaseCoefficient[signs[[2]]] E2 int;
    regular = -I sigma J[{0, 0}, {{-1, 1 - nValue}}, {}];
    boundary = If[nValue === 1, 2 manualMasslessShrinkIntegral, 0]
    ];
   Expand[power + phase + regular + boundary]
   ];

manualMasslessTopMomentum[signKey_String, nValue_Integer] := Module[
   {sigma = manualSigma[signKey], int, toggled},
   int = J[{0, 0}, {{0, nValue}}, {}];
   toggled = 1 - nValue;
   Expand[
    (dim - beta) int
     - I sigma J[{1, 0}, {{-1, toggled}}, {}]
     + I sigma J[{0, 1}, {{-1, toggled}}, {}]
    ]
   ];

manualMasslessCrossTime[signKey_String, vertex_] := Module[
   {signs = atomicMasslessSigns[signKey], int = J[{0, 0}, {{0}}, {}]},
   If[vertex === v1,
    Expand[
     -alpha1 J[{-1, 0}, {{0}}, {}]
      + manualPhaseCoefficient[signs[[1]]] E1 int
      + I manualBranchSign[signs[[1]]] J[{0, 0}, {{-1}}, {}]
     ],
    Expand[
     -alpha2 J[{0, -1}, {{0}}, {}]
      + manualPhaseCoefficient[signs[[2]]] E2 int
      + I manualBranchSign[signs[[2]]] J[{0, 0}, {{-1}}, {}]
     ]
    ]
   ];

manualMasslessCrossMomentum[signKey_String] := Module[
   {signs = atomicMasslessSigns[signKey], int = J[{0, 0}, {{0}}, {}]},
   Expand[
    (dim - beta) int
     - I manualBranchSign[signs[[1]]] J[{1, 0}, {{-1}}, {}]
     - I manualBranchSign[signs[[2]]] J[{0, 1}, {{-1}}, {}]
    ]
   ];

manualMasslessShrunkTime[signKey_String] := Module[
   {branch = First[atomicMasslessSigns[signKey]], int = J[{0}, {{0}}, {}]},
   Expand[
    -(alpha1 + alpha2) J[{-1}, {{0}}, {}]
     + manualPhaseCoefficient[branch] (E1 + E2) int
    ]
   ];

manualMasslessShrunkMomentum = (dim - beta) J[{0}, {{0}}, {}];

(* ::Chapter:: *)
(*全 sector、全生成元 expected*)

sameBranchTopRelations = Flatten[
   Table[
    {
     <|
      "sector" -> "top",
      "vertexSigns" -> signKey,
      "generator" -> {"time", v1},
      "seedRules" -> {a[v1] -> 0, a[v2] -> 0, b[1] -> 0, n[1] -> nValue},
      "equation" -> manualMasslessTopTime[signKey, nValue, v1],
      "tags" -> {"masslessFull", "firstEndpoint", If[nValue === 1, "thetaShrink", "regularOnly"]}
      |>,
     <|
      "sector" -> "top",
      "vertexSigns" -> signKey,
      "generator" -> {"time", v2},
      "seedRules" -> {a[v1] -> 0, a[v2] -> 0, b[1] -> 0, n[1] -> nValue},
      "equation" -> manualMasslessTopTime[signKey, nValue, v2],
      "tags" -> {"masslessFull", "secondEndpoint", If[nValue === 1, "thetaShrink", "regularOnly"]}
      |>,
     <|
      "sector" -> "top",
      "vertexSigns" -> signKey,
      "generator" -> {"momentum", 1, "loop", 1},
      "seedRules" -> {a[v1] -> 0, a[v2] -> 0, b[1] -> 0, n[1] -> nValue},
      "equation" -> manualMasslessTopMomentum[signKey, nValue],
      "tags" -> {"masslessFull", "momentumKernel"}
      |>
     },
    {signKey, {"++", "--"}},
    {nValue, {0, 1}}
    ],
   2
   ];

sameBranchShrunkRelations = Flatten[
   Table[
    {
     <|
      "sector" -> "e1",
      "vertexSigns" -> signKey,
      "generator" -> {"time", v1},
      "seedRules" -> {a[v1] -> 0, bS[1] -> 0},
      "equation" -> manualMasslessShrunkTime[signKey],
      "tags" -> {"masslessShrunk", "compactA", "nonzeroZeroPoint"}
      |>,
     <|
      "sector" -> "e1",
      "vertexSigns" -> signKey,
      "generator" -> {"momentum", 1, "loop", 1},
      "seedRules" -> {a[v1] -> 0, bS[1] -> 0},
      "equation" -> manualMasslessShrunkMomentum,
      "tags" -> {"masslessShrunk", "bS"}
      |>
     },
    {signKey, {"++", "--"}}
    ],
   1
   ];

crossRelations = Flatten[
   Table[
    {
     <|
      "sector" -> "top",
      "vertexSigns" -> signKey,
      "generator" -> {"time", v1},
      "seedRules" -> {a[v1] -> 0, a[v2] -> 0, b[1] -> 0},
      "equation" -> manualMasslessCrossTime[signKey, v1],
      "tags" -> {"masslessCross", "firstEndpoint", "noTheta"}
      |>,
     <|
      "sector" -> "top",
      "vertexSigns" -> signKey,
      "generator" -> {"time", v2},
      "seedRules" -> {a[v1] -> 0, a[v2] -> 0, b[1] -> 0},
      "equation" -> manualMasslessCrossTime[signKey, v2],
      "tags" -> {"masslessCross", "secondEndpoint", "noTheta"}
      |>,
     <|
      "sector" -> "top",
      "vertexSigns" -> signKey,
      "generator" -> {"momentum", 1, "loop", 1},
      "seedRules" -> {a[v1] -> 0, a[v2] -> 0, b[1] -> 0},
      "equation" -> manualMasslessCrossMomentum[signKey],
      "tags" -> {"masslessCross", "momentumKernel", "noTheta"}
      |>
     },
    {signKey, {"+-", "-+"}}
    ],
   1
   ];

expectedRelations = Join[
   sameBranchTopRelations,
   sameBranchShrunkRelations,
   crossRelations
   ];

(* ::Chapter:: *)
(*额外易错点 expected*)

atomicExpected = {
   <|"name" -> "reversedEndpointAtV1N0", "expected" -> -I J[{0, 0}, {{-1, 1}}, {}]|>,
   <|"name" -> "reversedEndpointAtV1N1Regular", "expected" -> -I J[{0, 0}, {{-1, 0}}, {}]|>,
   <|"name" -> "sameEndpointSecondDerivativeN0", "expected" -> -J[{0, 0}, {{-2, 0}}, {}]|>,
   <|"name" -> "sameEndpointSecondDerivativeN1", "expected" -> -J[{0, 0}, {{-2, 1}}, {}]|>,
   <|"name" -> "boundaryFirstEndpointN1", "expected" -> -2 manualMasslessShrinkIntegral|>,
   <|"name" -> "boundarySecondEndpointN1", "expected" -> 2 manualMasslessShrinkIntegral|>,
   <|"name" -> "coincidentAntisymmetricN1", "expected" -> 0|>,
   <|"name" -> "spIsOrderless", "expected" -> True|>
   };
