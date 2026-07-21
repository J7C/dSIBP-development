(* ::Package:: *)
(* all_family_total_derivative expected：用独立手推外不变量 oracle 和普通乘积法则生成 expected。
   连续 a/b/ISP 指标保持 general；只有函数基底要求的离散 n 固定为 0/1。 *)

(* ::Chapter:: *)
(*载入独立手推引擎*)

handDerivedRoot = DirectoryName[DirectoryName[$InputFileName]];
Get[FileNameJoin[{handDerivedRoot, "_manual_ibp_engine.wl"}]];


(* ::Chapter:: *)
(*带参量系数的总导数*)

allFamilyDerivativeCoefficients[label_, variable_] := {
   variable^2 + dc[label, 1]/variable,
   1 + dc[label, 2] variable + variable^3
   };


allFamilyDerivativeExpression[entry_Association, def_Association, sector_String, variable_] := Module[
   {integrals, coefficients},
   integrals = {
     allFamilyGeneralIntegral[entry, def, sector, 0, 1],
     allFamilyGeneralIntegral[entry, def, sector, 1, 2]
     };
   coefficients = allFamilyDerivativeCoefficients[entry["label"], variable];
   Expand[
    coefficients[[1]] integrals[[1]] +
     coefficients[[2]] integrals[[2]] +
     variable^2 + dc[entry["label"], 3] variable
    ]
   ];


allFamilyExpectedTotalDerivative[
   entry_Association,
   def_Association,
   sector_String,
   variable_
   ] := Module[{integrals, coefficients},
   integrals = {
     allFamilyGeneralIntegral[entry, def, sector, 0, 1],
     allFamilyGeneralIntegral[entry, def, sector, 1, 2]
     };
   coefficients = allFamilyDerivativeCoefficients[entry["label"], variable];
   manualCanonical[
    def,
    Expand[
     D[coefficients[[1]], variable] integrals[[1]] +
      coefficients[[1]] manualIndependentVariableDerivative[
        def, entry["signKey"], sector, integrals[[1]], variable
        ] +
      D[coefficients[[2]], variable] integrals[[2]] +
      coefficients[[2]] manualIndependentVariableDerivative[
        def, entry["signKey"], sector, integrals[[2]], variable
        ] +
      D[variable^2 + dc[entry["label"], 3] variable, variable]
     ],
    sector
    ]
   ];
