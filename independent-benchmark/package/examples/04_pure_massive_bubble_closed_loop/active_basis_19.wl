(* ::Package:: *)
(* pure massive bubble 的 018 formal Kira active basis。文件复用同目录中可读的 21 个
   reference 候选，恢复 physical ks=ss11 和 P_ref=-P_pkg 后，返回可直接交给
   DSKiraPlan[..., "activeBasis" -> ...] 的 19-master Association。 *)

(* ::Chapter:: *)
(*Reference 候选与 physical convention*)

activeBasisDirectory = DirectoryName[$InputFileName];
If[! ValueQ[referenceDlogCandidates],
 Get[FileNameJoin[{activeBasisDirectory, "dlog_basis.wl"}]]
 ];

pureMassiveBubbleActiveIndices = Range[19];
pureMassiveBubbleCandidateNames = "dlog" <> ToString[#] & /@ Range[21];
pureMassiveBubbleDerivativeVariables = {ss11, P0};

(* DEscaleCheck 的 stored degrees 在第 15--18 项恢复显式 ks 后各增加 1。
   用 ep=(3-dim)/2 消去 reference epsilon，得到 package 的 dim 表示。 *)
pureMassiveBubbleScalingDegrees = Join[
   ConstantArray[dim - 5, 5],
   ConstantArray[dim - 6, 9],
   ConstantArray[dim - 4, 5]
   ];

pureMassiveBubblePhysicalCandidates = Expand[
   referenceDlogCandidates /. {
      Sqrt[s11] -> ss11,
      P1 -> -P0,
      P2 -> -P0
      }
   ];


(* ::Chapter:: *)
(*可直接使用的 19-master Association*)

ClearAll[pureMassiveBubbleActiveBasis018];

(* parameterRules 只固定不参与微分的系数参数；缺省保留 dim、nu 等符号。 *)
pureMassiveBubbleActiveBasis018[parameterRules_List : {}] := <|
   "names" -> pureMassiveBubbleCandidateNames,
   "expressions" -> (pureMassiveBubblePhysicalCandidates /. parameterRules),
   "activeIndices" -> pureMassiveBubbleActiveIndices,
   "derivativeVariables" -> pureMassiveBubbleDerivativeVariables,
   "scalingDegrees" -> (pureMassiveBubbleScalingDegrees /. parameterRules)
   |>;

pureMassiveBubbleActiveBasis = pureMassiveBubbleActiveBasis018[];

If[
 Length[pureMassiveBubblePhysicalCandidates] =!= 21 ||
  Length[pureMassiveBubbleActiveIndices] =!= 19 ||
  Length[pureMassiveBubbleScalingDegrees] =!= 19,
 Print[Style["Pure massive bubble active basis length mismatch.", Red, Bold]];
 Abort[]
 ];

pureMassiveBubbleActiveBasis
