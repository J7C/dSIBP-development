(* ::Package:: *)
(* 本文件独立验证 bare-H 经变量依赖 T_Htoh 后的一阶系统、Wronskian和完整 endpoint tensor basis。它不加载 dSIBP package。 *)

ClearAll["Global`*"];


(* ::Chapter:: *)
(*局部 H/h 系统*)

(* ::Section::Closed:: *)
(*裸 H、直接 h 与基变换*)
bareHSystem[x_, nu_] := {{0, 1}, {-1 + nu^2/x^2, -1/x}};
directHSystem[x_, nu_] := {{0, 1}, {-1, -(2 nu + 1)/x}};
hTohTransform[x_, nu_] := x^-nu {{1, 0}, {-nu/x, 1}};

transformedHSystem[x_, nu_] := Module[{transform = hTohTransform[x, nu]},
  D[transform, x] . Inverse[transform]
    + transform . bareHSystem[x, nu] . Inverse[transform]
];

localSystemResidual = Simplify[
  Together[transformedHSystem[x, nu] - directHSystem[x, nu]]
];


(* ::Section::Closed:: *)
(*Wronskian 双线性型与 WT*)
epsilon2 = {{0, 1}, {-1, 0}};
wronskianFormResidual = Simplify[
  Together[
    hTohTransform[x, nu] . epsilon2 . Transpose[hTohTransform[x, nu]]
      - Det[hTohTransform[x, nu]] epsilon2
  ]
];

bareHWronskian[x_] := wronskianNormalization/x;
transformedWronskian[x_, nu_] := Det[hTohTransform[x, nu]] bareHWronskian[x];
directHWronskian[x_, nu_] := wronskianNormalization x^(-2 nu - 1);
wronskianResidual = Together[
  transformedWronskian[x, nu] - directHWronskian[x, nu]
];


(* ::Chapter:: *)
(*完整 endpoint tensor basis*)

(* ::Section::Closed:: *)
(*把局部系统嵌入任意 endpoint slot*)
kronProduct[matrices_List] := If[
  Length[matrices] === 1,
  First[matrices],
  KroneckerProduct @@ matrices
];

liftEndpointOperator[matrix_, slot_Integer, endpointCount_Integer] := kronProduct[
  Table[If[index === slot, matrix, IdentityMatrix[2]], {index, endpointCount}]
];

fullEndpointOperator[matrix_, endpointCount_Integer] := Total[
  Table[liftEndpointOperator[matrix, slot, endpointCount], {slot, endpointCount}]
];

endpointTensorResidual[endpointCount_Integer] := Simplify[
  Together[
    fullEndpointOperator[transformedHSystem[x, nu], endpointCount]
      - fullEndpointOperator[directHSystem[x, nu], endpointCount]
  ]
];


(* ::Section::Closed:: *)
(*两个指定 H family 的全离散基底记录*)
hRouteInventory = {
  <|
    "family" -> "atomic_massive_line",
    "endpointSlots" -> 2,
    "discreteStates" -> Tuples[{0, 1}, 2],
    "stateCount" -> 4,
    "routes" -> {"direct-h", "bare-H", "H-to-h"}
  |>,
  <|
    "family" -> "pure_massive_bubble_reference",
    "endpointSlots" -> 4,
    "discreteStates" -> Tuples[{0, 1}, 4],
    "stateCount" -> 16,
    "routes" -> {"direct-h", "bare-H", "H-to-h"}
  |>
};


(* ::Chapter:: *)
(*冻结前符号自检*)
hRouteExpectedSelfCheck = <|
  "localSystemResidual" -> localSystemResidual,
  "wronskianFormResidual" -> wronskianFormResidual,
  "wronskianResidual" -> wronskianResidual,
  "atomicTensorResidual" -> endpointTensorResidual[2],
  "bubbleTensorResidual" -> endpointTensorResidual[4],
  "familyStateCounts" -> Lookup[hRouteInventory, "stateCount"]
|>;

Print[InputForm[hRouteExpectedSelfCheck]];
