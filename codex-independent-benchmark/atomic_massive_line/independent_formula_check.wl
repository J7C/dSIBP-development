(* ::Package:: *)
(* 本脚本直接用 Mathematica 内置 Hankel 函数数值检查 derivation.md 的 h/H EOM 与
   cross-order Wronskian。它不加载 dS IBP package，也不生成 expected。 *)

ClearAll["Global`*"];


(* ::Chapter:: *)
(*数值检查定义*)

(* ::Section::Closed:: *)
(*h/H 原子函数与残差*)
f["H", 1, nu_, x_] := HankelH1[nu, x];
f["H", 2, nu_, x_] := HankelH2[Conjugate[nu], x];
f["h", 1, nu_, x_] := x^-nu HankelH1[nu, x];
f["h", 2, nu_, x_] := x^-nu HankelH2[Conjugate[nu], x];

eomResidual["H", branch_, nu_, x_] :=
  D[f["H", branch, nu, y], {y, 2}] + f["H", branch, nu, y] +
    D[f["H", branch, nu, y], y]/y - nu^2 f["H", branch, nu, y]/y^2 /.
   y -> x;

eomResidual["h", branch_, nu_, x_] :=
  D[f["h", branch, nu, y], {y, 2}] + f["h", branch, nu, y] +
    (2 nu + 1) D[f["h", branch, nu, y], y]/y /. y -> x;

wronskian[mode_, nu_, x_] :=
  f[mode, 1, nu, x] (D[f[mode, 2, nu, y], y] /. y -> x) -
   (D[f[mode, 1, nu, y], y] /. y -> x) f[mode, 2, nu, x];

wronskianExpected["H", nu_, x_] := -4 I Exp[Pi Im[nu]]/(Pi x);
wronskianExpected["h", nu_, x_] := -4 I Exp[Pi Im[nu]] x^(-2 nu - 1)/Pi;


(* ::Section::Closed:: *)
(*H 到 h 的基变换只由 h=x^-nu H 及一阶导数构造*)
hTohMatrix[nu_, x_] := {{x^-nu, 0}, {-nu x^(-nu - 1), x^-nu}};
hSystemMatrix[nu_, x_] := {{0, 1}, {-1, -(2 nu + 1)/x}};
HSystemMatrix[nu_, x_] := {{0, 1}, {-(1 - nu^2/x^2), -1/x}};

hTohAT[nu_, x_] := Module[{transform = hTohMatrix[nu, x]},
  D[transform, x].Inverse[transform] +
   transform.HSystemMatrix[nu, x].Inverse[transform]
  ];


(* ::Chapter:: *)
(*确定性样本与门禁*)

samplePoints = {
   <|"nu" -> 7/5, "x" -> 13/10|>,
   <|"nu" -> 3 I/5, "x" -> 17/10|>
   };

eomErrors = Quiet@Flatten@Table[
    Abs[N[eomResidual[mode, branch, sample["nu"], sample["x"]], 40]],
    {sample, samplePoints}, {mode, {"h", "H"}}, {branch, {1, 2}}];

wronskianErrors = Quiet@Flatten@Table[
    Abs[N[wronskian[mode, sample["nu"], sample["x"]] -
       wronskianExpected[mode, sample["nu"], sample["x"]], 40]],
    {sample, samplePoints}, {mode, {"h", "H"}}];

hTohChecks = {
   TrueQ[FullSimplify[hTohAT[nu, x] == hSystemMatrix[nu, x]]],
   TrueQ[FullSimplify[
     Det[hTohMatrix[nu, x]] wronskianExpected["H", nu, x] ==
      wronskianExpected["h", nu, x]
     ]]
   };

formulaCheckSummary = <|
   "maxEOMError" -> Max[eomErrors],
   "maxWronskianError" -> Max[wronskianErrors],
   "hTohATQ" -> hTohChecks[[1]],
   "hTohWTQ" -> hTohChecks[[2]],
   "passQ" -> Max[Join[eomErrors, wronskianErrors]] < 10^-30 &&
     And @@ hTohChecks
   |>;

Print[InputForm[formulaCheckSummary]];

If[! TrueQ[formulaCheckSummary["passQ"]], Exit[1]];
