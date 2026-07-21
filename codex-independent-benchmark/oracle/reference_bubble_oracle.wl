(* ::Package:: *)
(* 本文件只实现任务书 13.2 允许的 reference bubble 映射。它使用独立 oracle 的
   general-index derivative，不加载 package；80 条 derivative 与 symmetry/parity 原子分开保存。 *)


(* ::Chapter:: *)
(*Reference-only family 与 basis*)

referenceBubbleFamily = Join[
   pureMassiveBubbleReferenceFamily,
   <|
    "vertexSignCases" -> <|"--" -> {-1, -1}|>,
    "vertexEnergies" -> <|v1 -> I k0, v2 -> I k0|>,
    "zeroPointRules" -> {
      a0[v1] -> 2 nuM, a0[v2] -> 2 nuM,
      b0[1] -> -2 nuM, b0[2] -> -2 nuM
      }
    |>
   ];

referenceSectors = reachableSectors[referenceBubbleFamily, "--"];
referenceTop = SelectFirst[referenceSectors, #1["name"] === "top" &];
referenceR1 = SelectFirst[referenceSectors, #1["name"] === "e1" &];

referenceTopChoices = sectorDiscreteChoices[referenceBubbleFamily, referenceTop];

(* R1 的四个原始端点态全部进入 derivative 输入；10 最后由 endpoint symmetry canonical。 *)
referenceR1Choices = Table[{{}, {n3, n4}}, {n3, {0, 1}}, {n4, {0, 1}}] // Flatten[#, 1] &;

referenceBasisData = Join[
   (<|"sector" -> referenceTop, "choice" -> #|> &) /@ referenceTopChoices,
   (<|"sector" -> referenceR1, "choice" -> #|> &) /@ referenceR1Choices
   ];


(* ::Chapter:: *)
(*80 条 dk0/dks 单积分与乘积法则 expected*)

referenceReduction = scalarReductionData[referenceBubbleFamily];

referenceDerivativeForVariable[index_, sector_, k0] :=
  parameterDerivativeJ[referenceBubbleFamily, sector, index, k0];

referenceDerivativeForVariable[index_, sector_, ks] := Module[
  {ds11},
  ds11 = integralDerivative[
    referenceBubbleFamily, referenceReduction, sector, index, s11
    ];
  Expand[2 ks ds11 /. s11 -> ks^2]
  ];

(* reference 的导数 expected 必须和 package 一样在完整乘积法则之后统一 canonical。
   这里独立固定 line exchange 后 vertex exchange 的顺序；R1 只排序剩余线端点。 *)
referenceDerivativeSwapEndpoints[{b_, nFirst_, nSecond_}] := {b, nSecond, nFirst};
referenceDerivativeSwapEndpoints[{b_}] := {b};

referenceDerivativeLineCanonical[int : J[a_, {pack1_, pack2_}, isp_]] :=
  First@SortBy[{int, J[a, {pack2, pack1}, isp]}, ToString[#1, InputForm] &];

referenceDerivativeVertexCanonical[int : J[{a1_, a2_}, packs_, isp_]] :=
  First@SortBy[
    {int, J[{a2, a1}, referenceDerivativeSwapEndpoints /@ packs, isp]},
    ToString[#1, InputForm] &
    ];

referenceDerivativeR1Canonical[
   J[{av_}, {{bS_}, {b_, nFirst_, nSecond_}}, isp_]
   ] := J[{av}, {{bS}, {b, Min[nFirst, nSecond], Max[nFirst, nSecond]}}, isp];

referenceDerivativeParityZeroQ[
   J[_, {{b1_, n1_, n2_}, {b2_, n3_, n4_}}, _]
   ] := And @@ (IntegerQ /@ {b1, n1, n2, b2, n3, n4}) &&
  (OddQ[n1 + n2 + b1] || OddQ[n3 + n4 + b2]);
referenceDerivativeParityZeroQ[
   J[_, {{bS_}, {b2_, n3_, n4_}}, _]
   ] := And @@ (IntegerQ /@ {bS, b2, n3, n4}) &&
  (OddQ[bS] || OddQ[n3 + n4 + b2]);
referenceDerivativeParityZeroQ[_] := False;

referenceDerivativeCanonicalIntegral[int_J] := Module[{canonical = int},
  canonical = Which[
    Length[int[[1]]] === 2 && And @@ (Length[#1] === 3 & /@ int[[2]]),
    referenceDerivativeVertexCanonical[referenceDerivativeLineCanonical[int]],
    Length[int[[1]]] === 1 && Length[int[[2, 1]]] === 1 &&
      Length[int[[2, 2]]] === 3,
    referenceDerivativeR1Canonical[int],
    True, int
    ];
  If[referenceDerivativeParityZeroQ[canonical], 0, canonical]
  ];

referenceDerivativeCanonicalExpression[expr_] := Expand[
   expr /. int_J :> referenceDerivativeCanonicalIntegral[int]
   ];

referenceExpectedDerivatives = Flatten@Table[
    Module[{sector = basis["sector"], index, rawIntegral, integral,
      rawSingleDerivative, singleDerivative, combination, combinationDerivative},
     index = makeGeneralIndex[referenceBubbleFamily, sector, basis["choice"]];
     rawIntegral = indexToJ[referenceBubbleFamily, sector, index];
     integral = referenceDerivativeCanonicalIntegral[rawIntegral];
     rawSingleDerivative = referenceDerivativeForVariable[index, sector, variable];
     singleDerivative = referenceDerivativeCanonicalExpression[rawSingleDerivative];
     combination = variable integral + variable^2;
     combinationDerivative = Expand[integral + variable singleDerivative + 2 variable];
     {
      <|
       "sector" -> sector["name"], "vertexSigns" -> "--",
       "mode" -> "referenceSingle", "variable" -> variable,
       "expression" -> integral, "derivative" -> singleDerivative,
       "tags" -> {"referenceBubble", "generalIndex", "singleIntegral"}
       |>,
      <|
       "sector" -> sector["name"], "vertexSigns" -> "--",
       "mode" -> "referenceCombination", "variable" -> variable,
       "expression" -> combination, "derivative" -> combinationDerivative,
       "tags" -> {"referenceBubble", "generalIndex", "productRule"}
       |>
      }
     ],
    {basis, referenceBasisData}, {variable, {k0, ks}}];


(* ::Chapter:: *)
(*Reference symmetry 与 parity 原子 expected*)

swapMassiveEndpoints[{bb_, nFirst_, nSecond_}] := {bb, nSecond, nFirst};
swapMassiveEndpoints[{bOnly_}] := {bOnly};

referenceLineCanonical[J[a_, {pack1_, pack2_}, isp_]] :=
  If[OrderedQ[{pack1, pack2}], J[a, {pack1, pack2}, isp], J[a, {pack2, pack1}, isp]];

referenceVertexCanonical[J[{av1_, av2_}, packs_, isp_]] := Module[
  {candidate = J[{av2, av1}, swapMassiveEndpoints /@ packs, isp], original},
  original = J[{av1, av2}, packs, isp];
  First@SortBy[{original, candidate}, ToString[#, InputForm] &]
  ];

referenceR1EndpointCanonical[J[{av_}, {{bS_}, {b_, nFirst_, nSecond_}}, isp_]] :=
  J[{av}, {{bS}, {b, Min[nFirst, nSecond], Max[nFirst, nSecond]}}, isp];

referenceCombinedCanonical[expr_J] :=
  referenceVertexCanonical[referenceLineCanonical[expr]];

referenceParityQ["top", J[_, {{b1_, n1_, n2_}, {b2_, n3_, n4_}}, _]] :=
  EvenQ[n1 + n2 + b1] && EvenQ[n3 + n4 + b2];

referenceParityQ["e1", J[_, {{bS_}, {b2_, n3_, n4_}}, _]] :=
  EvenQ[bS] && EvenQ[n3 + n4 + b2];

referenceSymmetryExpected = {
   <|
    "name" -> "r2ToR1", "inputSector" -> "e2", "outputSector" -> "e1",
    "input" -> J[{ar}, {{b1, n1, n2}, {bS2}}, {}],
    "expected" -> J[{ar}, {{bS2}, {b1, n1, n2}}, {}]
    |>,
   <|
    "name" -> "lineExchange", "inputSector" -> "top", "outputSector" -> "top",
    "input" -> J[{a1, a2}, {{2, 1, 0}, {1, 0, 1}}, {}],
    "expected" -> referenceLineCanonical[J[{a1, a2}, {{2, 1, 0}, {1, 0, 1}}, {}]]
    |>,
   <|
    "name" -> "vertexExchange", "inputSector" -> "top", "outputSector" -> "top",
    "input" -> J[{2, 1}, {{b1, 1, 0}, {b2, 0, 1}}, {}],
    "expected" -> referenceVertexCanonical[J[{2, 1}, {{b1, 1, 0}, {b2, 0, 1}}, {}]]
    |>,
   <|
    "name" -> "r1Endpoint", "inputSector" -> "e1", "outputSector" -> "e1",
    "input" -> J[{ar}, {{bS}, {b2, 1, 0}}, {}],
    "expected" -> J[{ar}, {{bS}, {b2, 0, 1}}, {}]
    |>,
   <|
    "name" -> "lineThenVertex", "inputSector" -> "top", "outputSector" -> "top",
    "input" -> J[{2, 1}, {{2, 1, 0}, {1, 0, 1}}, {}],
    "expected" -> referenceCombinedCanonical[
      J[{2, 1}, {{2, 1, 0}, {1, 0, 1}}, {}]
      ]
    |>,
   <|
    "name" -> "emptyRules", "inputSector" -> "top", "outputSector" -> "top",
    "input" -> J[{2, 1}, {{2, 1, 0}, {1, 0, 1}}, {}],
    "expected" -> J[{2, 1}, {{2, 1, 0}, {1, 0, 1}}, {}]
    |>
   };

referenceParityExpected = {
   <|"name" -> "topLine1Odd", "sector" -> "top",
    "input" -> J[{0, 0}, {{0, 1, 0}, {0, 0, 0}}, {}], "expected" -> 0|>,
   <|"name" -> "topLine2Odd", "sector" -> "top",
    "input" -> J[{0, 0}, {{0, 0, 0}, {0, 1, 0}}, {}], "expected" -> 0|>,
   <|"name" -> "r1ShrunkOdd", "sector" -> "e1",
    "input" -> J[{0}, {{1}, {0, 0, 0}}, {}], "expected" -> 0|>,
   <|"name" -> "r1RemainingOdd", "sector" -> "e1",
    "input" -> J[{0}, {{0}, {0, 1, 0}}, {}], "expected" -> 0|>
   };

referenceSummary = <|
   "basisCount" -> Length[referenceBasisData],
   "derivativeCount" -> Length[referenceExpectedDerivatives],
   "symmetryCount" -> Length[referenceSymmetryExpected],
   "parityCount" -> Length[referenceParityExpected]
   |>;
