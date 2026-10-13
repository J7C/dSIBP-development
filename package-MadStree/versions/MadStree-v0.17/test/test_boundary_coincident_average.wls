(* ::Package:: *)

(***
文件：test_boundary_coincident_average.wls
用途：验证“两端并进同一个 component 的 massive full 传播子”的边界系数取两种 Hankel 排列乘积的对称平均
      m=(alpha+beta)/2，并且这个规律对两顶点之间任意多条平行传播子逐条成立；同时确认平均只改系数，
      不改 sector normalization、Frobenius 幂次与 binaryState。
范围：两顶点 bubble，单条 theta bundle 内含 2..5 条平行 massive 传播子，两种 nu prefactor convention；
      另用真实 sector 记录做 schema 一致的组合扩展，把观众传播子条数推到 7 条。全程 exact，不跑数值输运，
      不调外部后端。图初始化代价随平行传播子条数爆炸（实测 2/3/4/5 条为 0.3/0.4/2.7/44 秒），故真实图只到 5 条。
运行：wolframscript -file package-MadStree/versions/MadStree-v0.17/test/test_boundary_coincident_average.wls
***)


(* ::Chapter:: *)
(*加载与单条重合传播子的参考因子*)

Get[FileNameJoin[{DirectoryName[$InputFileName], "_harness.wls"}]];
packageRoot = msTestLoadKernel[];

ClearAll[endpointCoefficient, rankAssociation, hSlotsAtComponent, componentEndpointFactor, nuTilde];
endpointCoefficient = Symbol["MadStree`Private`msVertexEndpointCoefficient"];
rankAssociation = Symbol["MadStree`Private`msBoundaryRankAssociation"];
hSlotsAtComponent = Symbol["MadStree`Private`msHankelSlotsAtComponent"];
componentEndpointFactor = Symbol["MadStree`Private`msBoundaryComponentEndpointFactor"];


(* h 塔在小 z 的渐近系数，取论文发表的写法。 *)
paperC[nu_] := 2^(-nu) Gamma[-nu]/(I Pi);


(* 一条重合传播子在固定一种 Hankel 排列下的两端系数乘积。外层括号是必需的：
   文件里两行隐式相乘若不加括号会被读成两个独立表达式。 *)
arrangementProduct[convention_String, nu_, firstBit_Integer, secondBit_Integer, branches_List] :=
  (endpointCoefficient[convention, First[branches], firstBit, nu]
    endpointCoefficient[convention, Last[branches], secondBit, nu]);


(* 单条重合 massive full 传播子的参考因子 m=(alpha+beta)/2 的闭式写法，完全不提及排列：
   等 bit 时平均为恒等，混合 bit 时余弦因子承担两支交换。 *)
coincidentLineFactor[convention_String, firstBit_Integer, secondBit_Integer, nu_] := FullSimplify[
  Which[
    firstBit === 0 && secondBit === 0,
      If[convention === "Negative", -paperC[nu]^2, -paperC[-nu]^2],
    firstBit === 1 && secondBit === 1,
      If[convention === "Negative", -paperC[-nu - 1]^2, -4 nu^2 paperC[nu]^2],
    True,
      If[convention === "Negative",
        Cos[Pi nu] paperC[nu] paperC[-nu - 1],
        -2 nu Cos[Pi nu] paperC[-nu] paperC[nu]
      ]
  ]
];


(* 判定两个边界量恒等：混合 bit 的平均要过 Gamma 反射与双曲化简，普通 Simplify 到不了，
   因此把 FunctionExpand 加进变换函数；nuTilde 是纯虚 Hankel 阶的实变量。 *)
exactIdentityQ[lhs_, rhs_] := TrueQ[PossibleZeroQ[
  FullSimplify[lhs - rhs,
    TransformationFunctions -> {Automatic, FunctionExpand},
    Assumptions -> Element[nuTilde, Reals]
  ]
]];


(* 比值式恒等判定，用于 nu 已取数值的记录级比较：两支表达式只差一个代数因子时相消最快。 *)
exactRatioOneQ[lhs_, rhs_] := TrueQ[
  FullSimplify[lhs/rhs, TransformationFunctions -> {Automatic, FunctionExpand}] === 1
];


(* ::Chapter:: *)
(*两顶点 bubble 族与参考记录*)

bubbleSpec[count_Integer] := <|
  "vertices" -> {
    <|"id" -> 1, "externalLegEnergy" -> e1, "timePower" -> a1, "vertexType" -> "+"|>,
    <|"id" -> 2, "externalLegEnergy" -> e2, "timePower" -> a2, "vertexType" -> "+"|>
  },
  "lines" -> Table[
    <|"type" -> "massive", "endpoints" -> {1, 2},
      "momentum" -> ToExpression["q" <> ToString[i]],
      "nu" -> ToExpression["nu" <> ToString[i]]|>,
    {i, count}
  ],
  "thetaBundles" -> {Range[count]}
|>;

bubbleRules[count_Integer] := Join[
  {e1 -> 11 I, e2 -> 7 I, a1 -> 1 + I/3, a2 -> 1 - I/3},
  Table[ToExpression["nu" <> ToString[i]] -> I/(4 + i), {i, count}],
  Table[ToExpression["q" <> ToString[i]] -> Rationalize[(1 + i)/2], {i, count}]
];


(* 一条 pinched bubble 记录的参考系数，按 sector 的定义逐项重建：接触之后两个顶点并成一个 component，
   bundle 里未被收缩的每条传播子都是重合传播子，于是记录等于 sector normalization 乘 merged component
   的积分因子，再乘每条重合传播子各自的平均因子。 *)
bubbleReferenceRecord[
  context_?MSContextQ,
  sector_Association,
  stateBits_List,
  rules_List
] := Module[
  {convention, slots, groups, basePower, alpha, endpointProduct},
  convention = context["convention", "nuConvention"];
  slots = MapIndexed[Append[#1, "slotPosition" -> First[#2]] &, sector["slots"]];
  groups = GatherBy[slots, #["lineId"] &];
  basePower = First[sector["baseTimePowers"]] /. rules;
  alpha = Simplify[
    basePower + 1 - Total[
      Function[slot,
        stateBits[[slot["slotPosition"]]] (1 - 2 (slot["formulaNu"] /. rules))
      ] /@ slots
    ]
  ];
  endpointProduct = Times @@ Map[
    Function[group,
      Module[{line, momentum, nu, formulaNu, bits},
        line = SelectFirst[context["lines"], #["id"] === First[group]["lineId"] &];
        momentum = line["momentum"] /. rules;
        nu = line["nu"] /. rules;
        formulaNu = line["formulaNu"] /. rules;
        bits = stateBits[[#["slotPosition"]]] & /@ group;
        (Times @@ Map[Function[bit, (-I momentum)^(-bit (1 - 2 formulaNu))], bits]
          coincidentLineFactor[convention, First[bits], Last[bits], nu])
      ]
    ],
    groups
  ];
  Simplify[
    (sector["normalization"] /. rules)
      (-I)^(basePower + 1) Gamma[alpha] endpointProduct
  ]
];


(* ::Chapter:: *)
(*参考因子确为纤维平均，且两种排列并不简并*)

recordChecks = <||>;
recordCheck[name_, value_] := AssociateTo[recordChecks, name -> TrueQ[value]];
chapterStart = SessionTime[];

conventionsList = {"Negative", "Positive"};
mixedBitValues = {I nuTilde, 3/4 + I nuTilde};

Do[
  Do[
    With[{nu = mixedBitValues[[nuIndex]], convention = conventionsList[[conventionIndex]]},
      Module[{oneSided, flipped, equalBitsOk, suffix},
        suffix = convention <> ToString[nuIndex];
        equalBitsOk = And @@ Table[
          exactIdentityQ[
            arrangementProduct[convention, nu, bit, bit, {1, 2}],
            coincidentLineFactor[convention, bit, bit, nu]
          ],
          {bit, {0, 1}}
        ];
        oneSided = arrangementProduct[convention, nu, 0, 1, {1, 2}];
        flipped = arrangementProduct[convention, nu, 0, 1, {2, 1}];
        recordCheck["mixedBitsAreFibreAverage" <> suffix,
          exactIdentityQ[(oneSided + flipped)/2, coincidentLineFactor[convention, 0, 1, nu]] &&
            exactIdentityQ[
              coincidentLineFactor[convention, 0, 1, nu],
              coincidentLineFactor[convention, 1, 0, nu]
            ]
        ];
        (* 反事实：若单边排列与翻转排列恒等，平均就不是一处缺陷修复，本案例失去意义。 *)
        recordCheck["mixedBitsAreNonDegenerate" <> suffix,
          ! exactIdentityQ[oneSided, flipped]
        ];
        recordCheck["equalBitsAreUnchanged" <> suffix, equalBitsOk];
      ]
    ],
    {nuIndex, {1, 2}}
  ],
  {conventionIndex, {1, 2}}
];

Print["chapter3 elapsed=", Round[SessionTime[] - chapterStart, 0.01], "s"];


(* ::Chapter:: *)
(*记录级比对：两条与三条重合传播子的 bubble*)

Do[
  Do[
    With[{count = count, convention = conventionsList[[conventionIndex]], rules = bubbleRules[count]},
      Module[
        {t0, context, boundary, sectorByKey, pinchedSectors, branchRecords, suffix, coefficientOk,
         exponentOk, normalizationOk, shapeOk},
        t0 = SessionTime[];
        context = MSInitTimeGraph[bubbleSpec[count], NuConvention -> convention];
        boundary = MSBoundaryData[
          context, rules,
          BoundaryScale -> 4, BoundarySeriesOrder -> 4,
          RankOrder -> {1, 2}, WorkingPrecision -> 60
        ];
        suffix = convention <> ToString[count];
        recordCheck["boundaryGenerated" <> suffix, Head[boundary] =!= Failure];
        If[Head[boundary] === Failure,
          Print[convention, " count ", count, " boundary failed: ", boundary];
          Return[]
        ];
        sectorByKey = AssociationThread[context["sectorOrder"] -> MSSectors[context]];
        pinchedSectors = Select[MSSectors[context], Length[#["contractedLineIds"]] > 0 &];
        branchRecords = Select[
          boundary["leadingBranches"],
          Length[sectorByKey[#["sectorKey"]]["contractedLineIds"]] > 0 &
        ];
        (* sector 形状门禁：pinched sector 只有一个 component，观众重合传播子条数等于总条数减收缩条数，
           且纯 massive 图不含 massless shared slot。 *)
        shapeOk = And @@ Map[
          Function[mergedSector,
            Length[mergedSector["vertexComponents"]] === 1 &&
              Length[mergedSector["coincidentLineIds"]] ===
                count - Length[mergedSector["contractedLineIds"]] &&
              FreeQ[Lookup[mergedSector["slots"], "kind"], "masslessShared"]
          ],
          pinchedSectors
        ];
        recordCheck["singleMergedComponent" <> suffix, shapeOk];
        coefficientOk = And @@ Map[
          Function[branchRecord,
            exactRatioOneQ[
              branchRecord["coefficient"],
              bubbleReferenceRecord[
                context,
                sectorByKey[branchRecord["sectorKey"]],
                branchRecord["binaryState"],
                rules
              ]
            ]
          ],
          branchRecords
        ];
        recordCheck["coefficientIsFibreAverage" <> suffix, coefficientOk];
        (* merged component 取两个顶点里的领头 rank，故其 rank 权重为 2；平均不得动这个幂次。 *)
        exponentOk = And @@ Map[
          Function[branchRecord,
            Module[{mergedSector, mergedSlots, mergedAlpha},
              mergedSector = sectorByKey[branchRecord["sectorKey"]];
              mergedSlots = MapIndexed[
                Append[#1, "slotPosition" -> First[#2]] &, mergedSector["slots"]
              ];
              mergedAlpha = Simplify[
                (First[mergedSector["baseTimePowers"]] /. rules) + 1 -
                  Total[
                    Function[slot,
                      branchRecord["binaryState"][[slot["slotPosition"]]]
                        (1 - 2 (slot["formulaNu"] /. rules))
                    ] /@ mergedSlots
                  ]
              ];
              exactIdentityQ[branchRecord["frobeniusExponent"], 2 mergedAlpha]
            ]
          ],
          branchRecords
        ];
        recordCheck["frobeniusExponentUnchanged" <> suffix, exponentOk];
        normalizationOk = And @@ Map[
          Function[mergedSector,
            With[
              {contracted = First[mergedSector["contractedLineIds"]],
               sign = If[convention === "Positive", 1, -1]},
              exactIdentityQ[
                mergedSector["normalization"],
                (-(4 I/Pi)
                  (ToExpression["q" <> ToString[contracted]])^
                  (2 sign ToExpression["nu" <> ToString[contracted]] - 1))
              ]
            ]
          ],
          Select[pinchedSectors, Length[#["contractedLineIds"]] === 1 &]
        ];
        recordCheck["normalizationKept" <> suffix, normalizationOk];
        Print["chapter4 ", convention, " count=", count, " records=", Length[branchRecords],
          " elapsed=", Round[SessionTime[] - t0, 0.01], "s"];
      ]
    ],
    {conventionIndex, {1, 2}}
  ],
  {count, {2, 3}}
];


(* ::Chapter:: *)
(*逐条因子律：真实图上 1..4 条观众重合传播子*)

(* 1 号传播子被收缩，2..count 号都是 merged component 上的观众重合传播子。每条观众传播子都取混合 bit，
   于是生产端的 component 端点因子必须等于 count-1 个各自平均因子的乘积。 *)
Do[
  With[{count = count, rules = bubbleRules[count]},
    Module[{context, sector, slots, bits, produced, expected},
      context = MSInitTimeGraph[bubbleSpec[count], NuConvention -> "Negative"];
      sector = SelectFirst[
        MSSectors[context],
        #["contractedLineIds"] === {1} && Length[#["coincidentLineIds"]] === count - 1 &
      ];
      slots = hSlotsAtComponent[sector, 1];
      bits = ReplacePart[
        ConstantArray[0, Length[sector["slots"]]],
        MapIndexed[
          Rule[#1["slotPosition"], Mod[First[#2] - 1, 2]] &, slots
        ]
      ];
      produced = componentEndpointFactor[
        context, sector, rankAssociation[{1, 2}], slots, bits, rules
      ];
      expected = Times @@ Table[
        With[
          {nu = I/(4 + spectator), formulaNu = -I/(4 + spectator),
           momentum = Rationalize[(1 + spectator)/2]},
          ((-I momentum)^(-(1 - 2 formulaNu))
            coincidentLineFactor["Negative", 0, 1, nu])
        ],
        {spectator, 2, count}
      ];
      recordCheck["factorLawForSpectatorCount" <> ToString[count - 1],
        Length[slots] === 2 (count - 1) && Length[bits] === Length[sector["slots"]] &&
          exactRatioOneQ[produced, expected]
      ];
    ]
  ],
  {count, {2, 3, 4, 5}}
];


(* ::Chapter:: *)
(*任意条数：把真实 sector 记录按 schema 复制到 7 条观众重合传播子*)

(* 图初始化在 5 条以上已经不可用于回归，这里改为在真实 count=2 sector 记录上按既有 slot 与 line
   schema 复制观众传播子：新传播子仍接同样的两个顶点，rootToComponent 不变，所以每条新传播子同样被判为重合传播子。
   检验的是端点因子生成对观众传播子条数是归纳闭合的这一条结构性质。 *)
Module[
  {baseContext, baseSector, baseSlots, baseRules, templateLine, maxLineId, single, extra},
  baseRules = bubbleRules[2];
  baseContext = MSInitTimeGraph[bubbleSpec[2], NuConvention -> "Negative"];
  baseSector = SelectFirst[
    MSSectors[baseContext],
    #["contractedLineIds"] === {1} && Length[#["coincidentLineIds"]] === 1 &
  ];
  baseSlots = hSlotsAtComponent[baseSector, 1];
  templateLine = SelectFirst[baseContext["lines"], #["id"] === First[baseSlots]["lineId"] &];
  maxLineId = Max[baseContext["lines"][[All, "id"]]];
  (* 一条观众重合传播子在混合 bit 下的参考因子：动量幂次只由 bit=1 的那端贡献。 *)
  single = ((-I (templateLine["momentum"] /. baseRules))^
      (-(1 - 2 (templateLine["formulaNu"] /. baseRules)))
    coincidentLineFactor["Negative", 0, 1, templateLine["nu"] /. baseRules]);
  Do[
    Module[{lines, allSlots, allBits, produced, spectatorCount, context},
      spectatorCount = extra + 1;
      (* 每追加一组，就按既有 line 与 slot schema 复制一条观众传播子和它的两个端点 slot；
         新传播子仍接同样的两个顶点，新 slot 的 slotPosition 顺延到当前尾部。 *)
      lines = Join[
        baseContext["lines"],
        Table[ReplacePart[templateLine, "id" -> maxLineId + added], {added, extra}]
      ];
      allSlots = Join[
        baseSlots,
        Flatten[
          Table[
            Table[
              ReplacePart[
                baseSlots[[position]],
                {"lineId" -> maxLineId + added, "slotPosition" -> 2 added + position}
              ],
              {position, {1, 2}}
            ],
            {added, extra}
          ],
          1
        ]
      ];
      allBits = Mod[# - 1, 2] & /@ Range[Length[allSlots]];
      context = baseContext;
      context["lines"] = lines;
      produced = componentEndpointFactor[
        context, baseSector, rankAssociation[{1, 2}], allSlots, allBits, baseRules
      ];
      recordCheck["anyCoincidentLineCountLaw" <> ToString[spectatorCount],
        Length[allSlots] === 2 spectatorCount &&
          Length[lines] === Length[baseContext["lines"]] + extra &&
          exactRatioOneQ[produced, single^spectatorCount]
      ];
    ],
    {extra, {0, 1, 2, 4, 6}}
  ];
];


msTestSummary[recordChecks, "MadStree coincident propagator boundary average"];
