(* ::Package:: *)
(* pure massive bubble 的 reference parity、canonical symmetry 与逐生成元 seed 范围。
   主例和 fresh-session 交叉检查共同加载本文件，避免初始化 metadata 引用未定义 helper。 *)

(* ::Chapter:: *)
(*Reference parity 与 symmetry*)

exampleTopQ[J[_, {pack1_, pack2_}, {}]] := Length[pack1] === 3 && Length[pack2] === 3;
exampleR1Q[J[_, {pack1_, pack2_}, {}]] := Length[pack1] === 1 && Length[pack2] === 3;
exampleR2Q[J[_, {pack1_, pack2_}, {}]] := Length[pack1] === 3 && Length[pack2] === 1;

exampleSwapVertices[J[{a1_, a2_}, {{b1_, n1_, n2_}, {b2_, n3_, n4_}}, {}]] :=
  J[{a2, a1}, {{b1, n2, n1}, {b2, n4, n3}}, {}];
exampleSwapLines[J[{a1_, a2_}, {{b1_, n1_, n2_}, {b2_, n3_, n4_}}, {}]] :=
  J[{a1, a2}, {{b2, n3, n4}, {b1, n1, n2}}, {}];

exampleTopCanonical[int_J] := Module[{result = int},
   If[TrueQ[result[[1, 1]] > result[[1, 2]]], result = exampleSwapVertices[result]];
   If[TrueQ[result[[2, 1, 1]] > result[[2, 2, 1]]], result = exampleSwapLines[result]];
   If[TrueQ[result[[1, 1]] === result[[1, 2]] && result[[2, 1, 2]] > result[[2, 1, 3]]], result = exampleSwapVertices[result]];
   If[TrueQ[result[[2, 1, 1]] === result[[2, 2, 1]] && result[[2, 1, 2]] > result[[2, 2, 2]]], result = exampleSwapLines[result]];
   result
   ];

exampleR1Canonical[J[aList_, {{bS1_}, {b2_, n3_, n4_}}, {}]] := If[
   TrueQ[n3 > n4],
   J[aList, {{bS1}, {b2, n4, n3}}, {}],
   J[aList, {{bS1}, {b2, n3, n4}}, {}]
   ];
exampleR2ToR1[J[aList_, {{b1_, n1_, n2_}, {bS2_}}, {}]] :=
  exampleR1Canonical[J[aList, {{bS2}, {b1, n1, n2}}, {}]];

(* top 要求 n1+n2+b1、n3+n4+b2 为偶数；R1/R2 对应保留相同 reference parity。 *)
exampleParityZeroQ[J[_, {{b1_, n1_, n2_}, {b2_, n3_, n4_}}, {}]] :=
  TrueQ[OddQ[n1 + n2 + b1] || OddQ[n3 + n4 + b2]];
exampleParityZeroQ[J[_, {{bS1_}, {b2_, n3_, n4_}}, {}]] :=
  TrueQ[OddQ[bS1] || OddQ[n3 + n4 + b2]];
exampleParityZeroQ[J[_, {{b1_, n1_, n2_}, {bS2_}}, {}]] :=
  TrueQ[OddQ[bS2] || OddQ[n1 + n2 + b1]];
exampleParityZeroQ[_] := False;

exampleSymmetryRules0 = {
   HoldPattern[(int_J /; exampleParityZeroQ[int])] :> 0,
   HoldPattern[(int_J /; exampleR2Q[int])] :> exampleR2ToR1[int],
   HoldPattern[(int_J /; exampleTopQ[int])] :> exampleTopCanonical[int],
   HoldPattern[(int_J /; exampleR1Q[int])] :> exampleR1Canonical[int]
   };


(* ::Chapter:: *)
(*Reference 逐生成元 seed 范围*)

(* Reference 的 seed 不是统一外包矩形。下面逐项翻译 001 bubble_ibp_sym.m：
   top 的两个 time 与两个 momentum 生成元各有独立范围；e1/e2 都使用 R1 范围，
   其中 shrunk pack 对应 reference b1，剩余 massive pack 对应 reference b2。 *)
referenceGeneratorSeedRanges = {
   <|"sectorKey" -> "top", "generator" -> {"time", v1},
    "ranges" -> {a[v1] -> Range[0, 4], a[v2] -> Range[-1, 4],
      b[1] -> Range[-2, 5], b[2] -> Range[-2, 5]}|>,
   <|"sectorKey" -> "top", "generator" -> {"time", v2},
    "ranges" -> {a[v1] -> Range[-1, 4], a[v2] -> Range[0, 4],
      b[1] -> Range[-2, 5], b[2] -> Range[-2, 5]}|>,
   <|"sectorKey" -> "top", "generator" -> {"momentum", 1, "loop", 1},
    "ranges" -> {a[v1] -> Range[-1, 3], a[v2] -> Range[-1, 3],
      b[1] -> Range[-1, 5], b[2] -> Range[-2, 3]}|>,
   <|"sectorKey" -> "top", "generator" -> {"momentum", 1, "external", 1},
    "ranges" -> {a[v1] -> Range[-1, 3], a[v2] -> Range[-1, 3],
      b[1] -> Range[-2, 3], b[2] -> Range[-1, 5]}|>,
   <|"sectorKey" -> "e1", "generator" -> {"time", v1},
    "ranges" -> {a[v1] -> Range[-3, 8], bS[1] -> Range[-4, 8], b[2] -> Range[-3, 8]}|>,
   <|"sectorKey" -> "e1", "generator" -> {"momentum", 1, "loop", 1},
    "ranges" -> {a[v1] -> Range[-4, 7], bS[1] -> Range[-2, 8], b[2] -> Range[-3, 6]}|>,
   <|"sectorKey" -> "e1", "generator" -> {"momentum", 1, "external", 1},
    "ranges" -> {a[v1] -> Range[-4, 7], bS[1] -> Range[-4, 6], b[2] -> Range[-2, 8]}|>,
   <|"sectorKey" -> "e2", "generator" -> {"time", v1},
    "ranges" -> {a[v1] -> Range[-3, 8], bS[2] -> Range[-4, 8], b[1] -> Range[-3, 8]}|>,
   <|"sectorKey" -> "e2", "generator" -> {"momentum", 1, "loop", 1},
    "ranges" -> {a[v1] -> Range[-4, 7], bS[2] -> Range[-2, 8], b[1] -> Range[-3, 6]}|>,
   <|"sectorKey" -> "e2", "generator" -> {"momentum", 1, "external", 1},
    "ranges" -> {a[v1] -> Range[-4, 7], bS[2] -> Range[-4, 6], b[1] -> Range[-2, 8]}|>
   };

