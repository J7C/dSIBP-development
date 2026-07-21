(* ::Package:: *)
(* ds_total_derivative expected：直接使用 d/ds Sqrt[s]=1/(2 Sqrt[s]) 与乘积法则。*)

(* ::Chapter:: *)
(*独立手推公式*)

expectedDSIntegral[J[{av_}, {{bv_}}, {rv_}], variable_] :=
  I/(2 Sqrt[variable]) J[{av + 1}, {{bv}}, {rv}];


expectedDSProduct[coefficient_, int_J, variable_] :=
  Expand[D[coefficient, variable] int + coefficient expectedDSIntegral[int, variable]];


expectedDSLinearCombination[j0_J, j1_J, variable_] := Module[
   {coefficient0 = variable^2 + 3/variable, coefficient1 = variable},
   Expand[
    expectedDSProduct[coefficient0, j0, variable] +
     expectedDSProduct[coefficient1, j1, variable] +
     D[1 + variable^3, variable]
    ]
   ];
