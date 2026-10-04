(* ::Package:: *)

(***
文件：test_boundary_gamma_poles.wls
用途：验证自动边界逐 component 按统一数学谓词检查全部非正整数 Gamma 参数。
范围：调用公开 MSBoundaryData；不调用 Python/FlintNDE，不写正式独立验证结果。
运行：wolframscript -file package-MadStree/versions/MadStree-v0.17/test/test_boundary_gamma_poles.wls
***)

(* ::Chapter:: *)
(*加载与单顶点函数族*)

Get[FileNameJoin[{DirectoryName[$InputFileName], "_harness.wls"}]];
packageRoot = msTestLoadKernel[];

context = MSInitVertexFamily[<|
  "ki" -> {k0},
  "nui" -> {a}
|>];

(* ::Chapter:: *)
(*有限 Gamma 参数与公开 coefficient*)

finiteArguments = {3/2, -1/2, I/3};
finiteBoundaries = Association@Table[
  alpha -> MSBoundaryData[
    context,
    {k0 -> 3, a -> alpha - 1},
    BoundaryScale -> 4,
    WorkingPrecision -> 80
  ],
  {alpha, finiteArguments}
];

finiteCoefficientResiduals = Association@Table[
  alpha -> Simplify[
    finiteBoundaries[alpha]["leadingBranches"][[1, "componentData", 1, "coefficient"]] -
      (-I)^alpha Gamma[alpha]
  ],
  {alpha, finiteArguments}
];


(* ::Chapter:: *)
(*非正整数 pole*)

poleArguments = Range[-12, 0];
poleFailures = Association@Table[
  alpha -> Quiet@MSBoundaryData[
    context,
    {k0 -> 3, a -> alpha - 1},
    BoundaryScale -> 4,
    WorkingPrecision -> 80
  ],
  {alpha, poleArguments}
];

failureSentenceQ[failure_Failure] := Module[{data, text, chinese},
  data = failure[[2]];
  text = Lookup[data, "message", ""];
  chinese = Lookup[data, "messageCN", ""];
  StringLength[text] > 20 && StringLength[chinese] > 10 &&
    StringMatchQ[text, ___ ~~ ("." | "?" | "!")] &&
    MemberQ[{12290, 65311, 65281}, First@ToCharacterCode[StringTake[chinese, -1]]]
];
failureSentenceQ[_] := False;


(* ::Chapter:: *)
(*结构摘要*)

checks = <|
  "finiteArgumentsAccepted" -> And @@ (
    Lookup[finiteBoundaries[#], "status", None] === "generated" & /@ finiteArguments
  ),
  "finiteCoefficientsExact" -> And @@ (TrueQ[PossibleZeroQ[#]] & /@
    Values[finiteCoefficientResiduals]),
  "poleArgumentsRejected" -> And @@ (
    MatchQ[poleFailures[#], Failure["BoundaryGammaPole", _Association]] & /@ poleArguments
  ),
  "poleLocationsReported" -> And @@ Table[
    poleFailures[alpha][[2, "gammaArgument"]] === alpha &&
      IntegerQ[poleFailures[alpha][[2, "componentPosition"]]],
    {alpha, poleArguments}
  ],
  "predicateCoversNonPositiveIntegers" -> And @@ Table[
    TrueQ[MadStree`Private`msBoundaryGammaPoleQ[value]] ===
      (IntegerQ[value] && value <= 0),
    {value, Join[Range[-20, 20], {-3/2, -1/2, I/3, 3/2}]}
  ],
  "naturalLanguageFeedback" -> And @@ (failureSentenceQ /@ Values[poleFailures])
|>;

msTestSummary[checks, "MadStree boundary Gamma poles"];
Print["finite coefficient residuals: ", InputForm[finiteCoefficientResiduals]];

If[! And @@ Values[checks],
  Print["finite boundaries: ", InputForm[finiteBoundaries]];
  Print["pole failures: ", InputForm[poleFailures]];
  Exit[1]
];
