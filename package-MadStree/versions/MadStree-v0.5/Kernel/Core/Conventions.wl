(* ::Package:: *)

(***
文件：Conventions.wl
用途：集中保存 Pauli 原子、h-prefactor convention 与 H/h 局部变换。
约定：始终规定 nu=|nu|。缺省 h=z^nu H_nu；负 prefactor h=z^(-nu) H_nu 对应 2401。
***)

(* ::Chapter:: *)
(*局部二态原子*)

msIdentity2 = IdentityMatrix[2];
msSigma1 = {{0, 1}, {1, 0}};
msSigma2 = {{0, -I}, {I, 0}};
msSigma3 = {{1, 0}, {0, -1}};
msProjector1 = (msIdentity2 - msSigma3)/2;

msPaperT = 1/Sqrt[2] {{1, -I}, {-I, 1}};
msPaperTInverse = 1/Sqrt[2] {{1, I}, {I, 1}};
msHadamard = 1/Sqrt[2] {{1, 1}, {1, -1}};


(* ::Section:: *)
(*H/h 正反变换*)

(* 私有构造器只消费已经解析的 convention 字符串。 *)
msHTohMatrix[nu_, z_, nuConvention_String] := Module[{power},
  power = If[nuConvention === "Positive", nu, -nu];
  {{z^power, 0}, {power z^(power - 1), z^power}}
];

msHToHMatrix[nu_, z_, nuConvention_String] := Module[{power},
  power = If[nuConvention === "Positive", nu, -nu];
  {{z^(-power), 0}, {-power z^(-power - 1), z^(-power)}}
];

(* 公开局部矩阵必须读取已初始化 context，不提供逐调用 convention option。 *)
MSHTohMatrix[nu_, z_, context_?MSContextQ] := msHTohMatrix[
  nu, z, context["convention"]["nuConvention"]
];

MShToHMatrix[nu_, z_, context_?MSContextQ] := msHToHMatrix[
  nu, z, context["convention"]["nuConvention"]
];

MSHTohMatrix[___] := Failure["InitializedContextRequired", <|"function" -> "MSHTohMatrix"|>];
MShToHMatrix[___] := Failure["InitializedContextRequired", <|"function" -> "MShToHMatrix"|>];

MSConvertBasis[
  vector_List,
  direction_Rule,
  nu_,
  z_,
  context_?MSContextQ
] /; Length[vector] === 2 := Module[
  {nuConvention = context["convention"]["nuConvention"]},
  Switch[
    direction,
    "H" -> "h", Simplify[msHTohMatrix[nu, z, nuConvention].vector],
    "h" -> "H", Simplify[msHToHMatrix[nu, z, nuConvention].vector],
    _, Message[MSConvertBasis::unsupported, direction]; Failure["UnsupportedBasisConversion", <|"direction" -> direction|>]
  ]
];

MSConvertBasis[object_, direction_, ___] := (
  Message[MSConvertBasis::unsupported, <|"object" -> HoldForm[object], "direction" -> direction|>];
  Failure["UnsupportedBasisConversion", <|"direction" -> direction|>]
);


(* ::Section:: *)
(*函数系统 preset*)

msFunctionSystemPreset["h", nu_, variable_: z, nuConvention_: "Positive"] := Module[{formulaNu},
 formulaNu = If[nuConvention === "Positive", -nu, nu];
 <|
  "basis" -> "h",
  "nu" -> nu,
  "formulaNu" -> formulaNu,
  "nuConvention" -> nuConvention,
  "variable" -> variable,
  "P" -> (2 formulaNu + 1)/variable,
  "Q" -> 1,
  "hToH" -> msHToHMatrix[nu, variable, nuConvention],
  "HToh" -> msHTohMatrix[nu, variable, nuConvention]
 |>
];

msFunctionSystemPreset["H", nu_, variable_: z] := <|
  "basis" -> "H",
  "nu" -> nu,
  "variable" -> variable,
  "P" -> 1/variable,
  "Q" -> 1 - nu^2/variable^2,
  "hToH" -> msHToHMatrix[nu, variable, "Positive"],
  "HToh" -> msHTohMatrix[nu, variable, "Positive"]
|>;
