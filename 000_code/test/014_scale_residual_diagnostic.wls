(* ::Package:: *)
(* 本脚本只读取 pure massive bubble 已保存的真实 DE，在固定有理点诊断 Euler 标度残差。
   数值点仅用于定位非零结构，不能替代 post_kira_check.wl 的最终符号零判定。 *)

(* ::Chapter:: *)
(*读取 DE 与构造 Euler 残差*)

testDir = DirectoryName[$InputFileName];
codeDir = ExpandFileName[FileNameJoin[{testDir, ".."}]];
exampleDir = FileNameJoin[{codeDir, "examples", "014", "pure_massive_bubble_closed_loop"}];
deData = Get[FileNameJoin[{exampleDir, "results", "dlogDE", "manifest.wl"}]];

degrees = Join[
   ConstantArray[dim - 5, 5],
   ConstantArray[dim - 6, 9],
   ConstantArray[dim - 4, 5]
   ];
eulerMatrix = 2 s11 deData["matrices"][s11] + P0 deData["matrices"][P0];
residualMatrix = eulerMatrix - DiagonalMatrix[degrees];


(* ::Chapter:: *)
(*固定点结构诊断*)

probeRules = {s11 -> 4, kk[1, 1] -> 4, P0 -> 7/3, nu -> 2/7, dim -> 37/10, etaNu -> 5/6};
numericResidual = N[residualMatrix /. probeRules, 30];
nonzeroPositions = Position[numericResidual, value_ /; NumericQ[value] && Abs[value] > 10^-20, {2}];
nonzeroValues = Extract[numericResidual, nonzeroPositions];

summary = <|
   "dimensions" -> Dimensions[residualMatrix],
   "nonzeroCount" -> Length[nonzeroPositions],
   "firstNonzeroPositions" -> Take[nonzeroPositions, UpTo[30]],
   "firstNonzeroValues" -> Take[nonzeroValues, UpTo[30]],
   "numericDiagonal" -> Diagonal[N[eulerMatrix /. probeRules, 30]]
   |>;

Print[summary];

resultsDir = FileNameJoin[{testDir, "results_test", "014_scale_residual_diagnostic"}];
Quiet[CreateDirectory[resultsDir, CreateIntermediateDirectories -> True]];
Put[summary, FileNameJoin[{resultsDir, "summary.wl"}]];
