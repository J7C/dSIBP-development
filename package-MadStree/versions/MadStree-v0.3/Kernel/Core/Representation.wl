(* ::Package:: *)

(***
文件：Representation.wl
用途：验证原生 MSIntegral，执行 H/h 状态变换，并提供不含 massless shared quotient 的旧 time-only J 适配。
边界：旧 J 不带 sectorKey，只有从 shrunk line pack 可唯一恢复 sector 时才允许反向转换。
***)

(* ::Chapter:: *)
(*原生积分验证*)

msIntegralData[int : MSIntegral[key_String, shifts_List, bits_List], context_?MSContextQ] := Module[
  {sector = msSectorByKey[context, key]},
  If[Head[sector] === Missing, Return[Failure["UnknownSector", <|"sectorKey" -> key|>]]];
  If[Length[shifts] =!= Length[sector["vertexComponents"]] || ! And @@ (IntegerQ /@ shifts),
    Return[Failure["BadTimeShifts", <|"expected" -> Length[sector["vertexComponents"]], "actual" -> shifts|>]]
  ];
  If[! MemberQ[sector["stateOrder"], bits],
    Return[Failure[
      "BadStateBits",
      <|"expectedStateOrder" -> sector["stateOrder"], "actual" -> bits|>
    ]]
  ];
  <|"sector" -> sector, "shifts" -> shifts, "bits" -> bits|>
];

msIntegralData[other_, _] := Failure["NotMSIntegral", <|"input" -> HoldForm[other]|>];


(* ::Section:: *)
(*全 sector H/h 状态向量变换*)

(*
输入按 sector 的 stateBits 顺序排列；massive endpoint 与 RedundantH massless endpoint
各自使用 z=-k tau，massless shared quotient 在 H/h 换基中保持单位作用。
*)
msSectorBasisTransformMatrix[
  direction_Rule,
  sector_Association,
  componentTimes_List,
  nuConvention_String
] := Module[{localMatrices, componentPosition, zValue},
  If[! MemberQ[{"H" -> "h", "h" -> "H"}, direction],
    Return[Failure["UnsupportedBasisDirection", <|"direction" -> direction|>]]
  ];
  localMatrices = Map[
    Function[slot,
      If[slot["kind"] === "masslessShared",
        msIdentity2,
        componentPosition = sector["rootToComponent"][slot["rootVertex"]];
        zValue = -slot["momentum"] componentTimes[[componentPosition]];
        If[direction === ("H" -> "h"),
          msHTohMatrix[slot["nu"], zValue, nuConvention],
          msHToHMatrix[slot["nu"], zValue, nuConvention]
        ]
      ]
    ],
    sector["slots"]
  ];
  msQuotientMatrix[sector, msKroneckerAll[localMatrices]]
];

(*
返回与输入同序的 sector 状态向量。该接口作用于被积函数状态，不改变 MSIntegral 的
基准时间幂；对积分对象的换基必须另带目标 family metadata，当前继续拒绝。
*)
MSConvertBasis[
  vector_List,
  direction_Rule,
  key_String,
  componentTimes_List,
  context_?MSContextQ
] := Module[{sector, matrix, nuConvention},
  sector = msSectorByKey[context, key];
  If[Head[sector] === Missing, Return[Failure["UnknownSector", <|"sectorKey" -> key|>]]];
  If[Length[componentTimes] =!= Length[sector["vertexComponents"]],
    Return[Failure[
      "ComponentTimeCount",
      <|"expected" -> Length[sector["vertexComponents"]], "actual" -> Length[componentTimes]|>
    ]]
  ];
  If[Length[vector] =!= sector["masterCount"],
    Return[Failure[
      "StateVectorDimension",
      <|"expected" -> sector["masterCount"], "actual" -> Length[vector]|>
    ]]
  ];
  nuConvention = context["convention"]["nuConvention"];
  matrix = msSectorBasisTransformMatrix[direction, sector, componentTimes, nuConvention];
  If[Head[matrix] === Failure, matrix, Simplify[matrix.vector]]
];


(* ::Section:: *)
(*旧 massive time-only J adapter*)

MSToLegacyJ[int : MSIntegral[_, _, _], context_?MSContextQ] := Module[
  {data, sector, slots, bitsByKey, linePacks},
  data = msIntegralData[int, context];
  If[Head[data] === Failure, Return[data]];
  sector = data["sector"];
  If[AnyTrue[sector["slots"], #["kind"] === "masslessShared" &],
    Return[Failure["MasslessSharedHasNoLegacyFactorizedJ", <|"sectorKey" -> sector["sectorKey"]|>]]
  ];
  slots = sector["slots"];
  bitsByKey = AssociationThread[(ToString[#["key"], InputForm] & /@ slots) -> data["bits"]];
  linePacks = Map[
    Function[line,
      If[MemberQ[sector["contractedLineIds"], line["id"]],
        True,
        Switch[
          line["type"],
          "massiveFull" | "massiveCross" | "masslessFull",
            {"F", bitsByKey[ToString[{line["id"], 1}, InputForm]], bitsByKey[ToString[{line["id"], 2}, InputForm]]},
          "massiveExternal",
            {"F", bitsByKey[ToString[{line["id"], 1}, InputForm]]},
          _, {"F"}
        ]
      ]
    ],
    context["lines"]
  ];
  Inactive[J][data["shifts"], linePacks, {}]
];

MSFromLegacyJ[Inactive[J][shifts_List, linePacks_List, {}], context_?MSContextQ] := Module[
  {contractedIds, key, sector, bits},
  If[Length[linePacks] =!= Length[context["lines"]],
    Return[Failure["LegacyLinePackLength", <||>]]
  ];
  contractedIds = Pick[Lookup[context["lines"], "id"], TrueQ /@ linePacks];
  key = msSectorKey[contractedIds];
  sector = msSectorByKey[context, key];
  If[Head[sector] === Missing, Return[Failure["UnknownLegacySector", <|"contractedLineIds" -> contractedIds|>]]];
  If[AnyTrue[sector["slots"], #["kind"] === "masslessShared" &],
    Return[Failure["MasslessSharedHasNoLegacyFactorizedJ", <|"sectorKey" -> key|>]]
  ];
  bits = Map[
    Function[slot,
      With[{linePosition = First@FirstPosition[Lookup[context["lines"], "id"], slot["lineId"]]},
        linePacks[[linePosition, 1 + slot["endpointIndex"]]]
      ]
    ],
    sector["slots"]
  ];
  With[{candidate = MSIntegral[key, shifts, bits]},
    If[Head[msIntegralData[candidate, context]] === Failure, msIntegralData[candidate, context], candidate]
  ]
];

MSFromLegacyJ[other_, _?MSContextQ] := Failure["UnsupportedLegacyJ", <|"input" -> HoldForm[other]|>];
