# dS IBP Coding Plan（技术实现大纲）

本文件描述通用 dS IBP 生成器的技术实现步骤，适用于任意圈图拓扑。

## 0. 核心设计原则

- **所有代码必须对任意 (V, E, L, E_ext) 拓扑工作**
- bubble 只是测试用例，不是设计目标
- 拓扑信息通过输入数据结构驱动，不硬编码任何拓扑特征
- massless 在本 package 中统一采用双 theta 合并路线；单 theta 分支约化只作为外部参考，不进入主线生成器
- 主脚本默认只生成 seed、metadata、linear-system 和 Kira 输入文件；严禁默认触发解析大计算或运行 Kira。seed 保存为 MMA 表达式，Kira 导出只接受 linear-system 数据

## 1. 数据结构

### 1.1 拓扑输入

```mathematica
vertexData = {{v1, sign1}, {v2, sign2}, ...};  (* V 个顶点 *)
lineData = {{e1, {u1, v1}, Q1, nu1, bbType1}, ...};  (* 旧格式 E 条内线 *)
extLegs = {{B1, v1, k1}, ...};  (* 外腿 *)
loopMomenta = {q1, q2, ...};  (* L 个圈动量，显式指定 *)
externalMomenta = {k1, k2, ...};  (* 进入内线动量偏移的独立外动量向量基 *)
vertexEnergies = <|v1 -> ke[1], v2 -> Sqrt[s11], ...|>;  (* 独立顶点能量用 ke[i]；可复用外部不变量表达式 *)
ispData = {{isp1, sp[q1, k1], {min1, max1}}, ...};  (* 006 起用户口 ISP 定义用 sp *)
```

推荐使用带 metadata 的 `lineData` Association 格式，避免代码猜测物理类型：

```mathematica
<|
  "id" -> e,
  "endpoints" -> {u, v},
  "momentum" -> Qe,
  "nu" -> nue,
  "bbType" -> "h" | "H" | "exp",
  "massType" -> "massive" | "massless",
  "skType" -> "++" | "--" | "+-" | "-+",
  "thetaConvention" -> "mergedTwoTheta",
  "packType" -> Automatic
|>
```

必须一开始设定、且不写进指标里的初始化信息：

- `vertexData`：顶点编号和 SK 符号。
- `lineData`：每条内线的端点、动量、质量类型、building block 类型、SK 类型。
- `loopMomenta`：圈动量基。
- `externalMomenta`：独立外动量向量基。它只包含实际进入内线动量 `Q_e = l + sum k`、会与圈动量发生标量积的三动量方向；只出现在顶点相位中的无质量外腿能量模或能量组合不放这里；独立绝对值参数用 `ke[i]`，可由外部不变量复用的能量在 `vertexEnergies` 中写成相应表达式。外腿能量参数之间不做完备标量积，只有用户显式写成外部不变量表达式时才复用圈外动量空间变量。
- `vertexEnergies`：顶点 e 指数外部能量参数。若能量由 `externalMomenta` 张成且应与圈动量部分共享变量，写成外部不变量名的函数，如 `Sqrt[s11]`；若为独立绝对值参数，建议写 `ke[i]`。不要把 `|ke1+ke2|` 自动拆成 `|ke1|+|ke2|`；若该组合本身独立，就另记为 `ke[3]` 这类新参数。
- `externalInvariantRules`：外动量-外动量不变量的输出命名规则，例如 `sp[k1,k1] -> s11` 或 `sp[k1,k2] -> sig12`。未设时按 `externalMomenta` 位置默认生成 `sij`；输出端、数值规则模板和 Kira 系数替换都使用这些变量名。
- `ispData`：多圈或传播子不足以覆盖标量积空间时必须给；单圈无 ISP case 可为空。
- 零点和 prefactor 配置：`a0Rules`、`b0Rules`、`shrinkPrefactorRules` 可缺省，但建议 case 文件显式记录。
- 幂次范围：`aRange`、`bRange`、`nRange`、`ispRange`。它们控制 seed 枚举，不属于 `J` 的指标本体。`nRange` 对完整线固定为离散 `0/1` 枚举；任何生成元产生的 `n=2` 必须立刻 EOM 化。

可由代码自动派生的信息：

- `nV,nE,nL,nK`、关联矩阵、顶点连接线列表。
- `packType`：若未显式给出，则由 `massType`、`skType`、`state` 推断。
- 完整 IBP 生成元列表。
- 标量积变量列表和 ISP 覆盖性检查所需矩阵。

### 1.2 积分表示

```mathematica
J[aList, packList, ispList]
```

- `aList = {a1, a2, ..., aV}`：顶点时间幂次
- `packList = {pack1, pack2, ..., packE}`：每条线的指标包
  - massive 完整线：`{b_e, n_{e,1}, n_{e,2}}`
  - massless 完整线（双 theta 合并）：`{b_e, n_e}`
  - 缩并线：`{bS_e}`
- `ispList = {n_{isp,1}, n_{isp,2}, ...}`：ISP 分子幂次

### 1.3 派生数据（从拓扑自动计算）

```mathematica
nV = Length[vertexData];
nE = Length[lineData];
nL = Length[loopMomenta];
bMatrix[[v, e]] = ±1 or 0;  (* 关联矩阵 *)
vertexLines[[v]] = {{e, direction}, ...};  (* 每个顶点连接的线 *)
loopCoeff[[e, l]] = Coefficient[Q_e, q_l];  (* Q_e 中 q_l 的系数 *)
externalPart[[e]] = Q_e - Σ_l loopCoeff[[e,l]] q_l;  (* Q_e 的外动量部分 *)
```

## 2. 标量积与 z=ξ² 线性变换

### 2.1 标量积变量

```mathematica
sp[p, r]  (* 用户口标量积；p,r 可为 loop/external 基动量的线性组合 *)
```

`sp` 具有 `Orderless` 属性，故 `sp[p,r]` 与 `sp[r,p]` 自动等同。它用于输入传播子/ISP 等圈动量相关标量积；外动量-外动量不变量在输出端改用变量名，用户可设 `externalInvariantRules -> {sp[k1,k1] -> s11}`，未设时默认按 `externalMomenta` 的位置输出 `sij`。内部实现仍可展开到 `qq/qk/kk` 编号坐标做线性代数，但这些内部记号不作为用户输入 convention。

### 2.2 正向变换 z = M·s + c

对每条线 e：
```
z_e = Q_e² = (Σ_l c_{e,l} q_l + P_e)²
    = Σ_{l,m} c_{e,l} c_{e,m} qq[l,m] + 2 Σ_l c_{e,l} qk[l, P_e] + P_e²
```

实现：
```mathematica
expandZ[e_] := Module[{result = 0},
  (* 圈-圈项 *)
  Do[
    If[l == m,
      result += loopCoeff[[e,l]]^2 * qq[l,l],
      result += 2 * loopCoeff[[e,l]] * loopCoeff[[e,m]] * qq[l,m]
    ],
    {l, nL}, {m, l, nL}
  ];
  (* 圈-外项：需要展开 P_e 为外动量线性组合 *)
  (* 外-外项：P_e² 用 kk 表示 *)
  result
];
```

### 2.3 逆向变换 s = M^{-1}·(z - c)

```mathematica
makeScalarProductRules[] := Module[{matM, vecC, vecZ, vecS, matInv},
  (* 构建矩阵 M 和向量 c *)
  matM = Table[Coefficient[expandZ[e], scalarProducts[[α]]], {e, nE}, {α, Length[scalarProducts]}];
  vecC = Table[expandZ[e] /. Thread[scalarProducts -> 0], {e, nE}];

  (* 求逆 *)
  matInv = Inverse[matM];

  (* 生成替换规则 *)
  repSP2Z = Thread[scalarProducts -> matInv . (zVec - vecC)];
  repZ2SP = Thread[zVec -> matM . scalarProducts + vecC];

  (* q_l · Q_e 的替换规则 *)
  repDotProduct = Table[
    qDotQ[l, e] -> (Σ_m loopCoeff[[e,m]] * (repSP2Z /. qq[l,m] -> ...)),
    {l, nL}, {e, nE}
  ];
];
```

## 3. IBP 生成元

### 3.1 时间 IBP（V 个生成元）

```mathematica
makeTimeIBP[expr_, v_] := Module[{result = 0},
  (* (a) 顶点幂次: -a_v *)
  result += -expr[[1, v]] * shiftA[expr, v, -1];

  (* (b) 外部能量: -I P_v *)
  result += -I * Pext[v] * expr;

  (* (c) 对每条连接 v 的线 *)
  Do[
    {e, dir} = vertexLines[[v]];
    If[fullLineQ[expr, e],
      (* building block 导数: -shift_n shift_b *)
      result += -shiftN[shiftB[expr, e, -1], e, endpoint[dir], 1];

      (* massive 边界缩并: n_{e,1} + n_{e,2} == 1 时 *)
      If[linePackType[e] === "massiveFull" && expr[[2, e, 2]] + expr[[2, e, 3]] == 1,
        result += shrinkPrefactor[e] * shrinkLine[expr, e, v];
      ];
    ];
    (* 缩并线: 无 building block 导数, 无缩并 *)
  ],
  {j, Length[vertexLines[[v]]]}
  ];
  result
];
```

### 3.2 动量 IBP（L(L+E-1) 个生成元）

```mathematica
makeMomIBP[expr_, l_, v_] := Module[{result, e, coeff, dotProduct},
  (* v 可以是 q_m 或 k_j *)

  (* 散度项: ∂·v = d if v=q_l, 0 otherwise *)
  result = If[v === loopMomenta[[l]], d * expr, 0];

  (* 链式法则: Σ_e c_{e,l} (v·Q_e)/z_e ∂/∂z_e *)
  Do[
    If[fullLineQ[expr, e],
      coeff = loopCoeff[[e, l]];
      dotProduct = computeDotProduct[v, e];  (* 用 repDotProduct *)

      (* dotProduct 是 z_e 的线性组合: Σ_α c_α z_{e_α} *)
      (* 每一项 z_{e_α}^n 作用在 z_{e_α}^{-(b+b0)/2} 上 → b_{e_α} → b_{e_α} - 2n *)
      result += coeff * applyDotProduct[dotProduct, expr, e];
    ];
    (* ISP 项: 对每个 ISP_j, (v·∂ISP_j/∂q_l) ∂/∂ISP_j *)
    (* ... *)
  ],
  {e, nE}
  ];

  (* n-shift 项: building block 导数产生 n → n+1 *)
  Do[
    If[fullLineQ[expr, e],
      result += nShiftTerms[expr, e, l, v];
    ];
  ],
  {e, nE}
  ];

  result
];
```

### 3.3 生成元枚举

```mathematica
allIBPGenerators[] := Join[
  (* 时间 IBP: V 个 *)
  Table[{time, v}, {v, nV}],
  (* 动量 IBP: L(L+E-1) 个 *)
  Flatten[Table[
    Join[
      Table[{momentum, l, loopMomenta[[m]]}, {m, nL}],  (* 对角 + 交叉 *)
      Table[{momentum, l, extMomenta[[j]]}, {j, nExt}]  (* 外动量 *)
    ],
    {l, nL}
  ], 1]
];
```

## 4. 缩并机制

### 4.1 缩并条件

massive 线 e 可缩并 ⟺ `fullLineQ[expr, e] && linePackType[e] == "massiveFull" && n_{e,1} + n_{e,2} == 1`。

massless 线走双 theta 合并路线，不使用 Hankel Wronskian 缩并条件。它的 Heaviside 导数和端点关系应由 massless endpoint/canonical 规则处理，并保持正式 pack `{b_e,n_e}`。

### 4.2 缩并操作

```mathematica
shrinkLine[expr_, e_, mergeVertex_] := Module[{aSum, bS, prefactor},
  (* 合并顶点时间幂次：整数 -1 入指标，-2 nu_e 入零点 *)
  aSum = a_{u[e]} + a_{v[e]} - 1;

  (* 缩并线的 bS 值：整数 +1 入指标，+2 nu_e 入 bS0 零点 *)
  bS = b_e + 1;

  (* 缩并 prefactor *)
  prefactor = (4 I / Pi) * Exp[Pi * Im[nu_e]];

  (* 构造新积分: 线 e 变为缩并态, 合并顶点 *)
  prefactor * ReplacePart[expr, {
    {1, u[e]} -> aSum,
    {1, v[e]} -> 0,  (* 或移除 *)
    {2, e} -> {bS}
  }]
];
```

### 4.3 缩并线的处理

缩并线 `{bS_e}`：
- 无 n 指标，无 EOM 递推
- 时间 IBP 无 building block 导数项，无缩并项
- 动量 IBP 中：bS_e 贡献 -bS_e * expr（来自 ∂/∂ξ_e 作用在 z_e^{-bS_e/2} 上）

## 5. EOM 递推

```mathematica
makeEOMRules[] := Module[{rules = {}},
  Do[
    Do[
      (* n_{e,a} = 2 → c1 * (n=1, b+1, a±1) + c2 * (n=0) *)
      AppendTo[rules,
        J[args___] /; packE[[e, a]] == 2 :>
          -getC1[e] * shiftN[shiftB[shiftA[expr, vertex, -1], e, 1], e, a, 1]
          - getC2[e] * shiftN[expr, e, a, 0]
      ],
      {a, 2}  (* 两个端点 *)
    ],
    {e, nE}
  ];
  rules
];
```

## 6. 种子枚举与方程生成

```mathematica
generateIBPEquations[] := Module[{int00, int000, seeds, equations, seedEq},
  (* 1. 构造基积分模板 *)
  int00 = J[aVars, makeLinePacks[lineData], ispVars];

  (* 2. 添加零点 *)
  int000 = int00 /. repAddZeroPoints;

  (* 3. 按每条线的 pack 类型枚举离散态：
        massiveFull -> {n1,n2} ∈ {0,1}^2
        masslessFull -> n ∈ {0,1}
        crossMassless/shrunk -> 无离散态 *)
  seeds = enumerateDiscreteStates[int000, lineData];

  (* 4. 对每个离散种子，应用所有 IBP 生成元并立刻 EOM canonical *)
  equations = Flatten@Table[
    seedEq = applyGenerator[seeds[[i]], gen];
    seedEq = applyEOM[seedEq, topo];
    assertNoForbiddenN[seedEq, topo],
    {i, Length[seeds]},
    {gen, allIBPGenerators[]}
  ];

  (* 5. massless 双 theta 合并 canonical 与边界检查 *)
  equations = applyMasslessCanonical[equations, topo];
  equations = checkIndexBounds[equations, topo];

  (* 6. 移除零点，去重 *)
  equations = equations /. repRemoveZeroPoints // DeleteDuplicates;

  equations
];
```

## 7. 分 Sector 保存

```mathematica
sectorID[expr_] := Sort[Select[Range[nE], shrunkLineQ[expr, #] &]];

saveBySector[equations_] := Module[{grouped},
  grouped = GatherBy[equations, sectorID];
  Do[
    Export["IBP_sector_" <> sectorName[grouped[[i]]] <> ".m", grouped[[i]]],
    {i, Length[grouped]}
  ];
];
```

## 8. 实现顺序

1. **数据结构与拓扑解析**（已完成）
2. **标量积规则通用实现**（当前 bubble 硬编码 → 改为矩阵求逆）
3. **时间 IBP core 通用化**（已接入顶点幂次、外部相位、massive 端点导数、massless 端点翻转、massive theta boundary shrink、即时 canonical 和受保护的自动 shrink-sector seed 派生/联立）
4. **动量 IBP 通用化**（已接入传播子项、z/ISP 吸收、massive building-block 导数项与即时 canonical；仍需补 shrunk line 与更多 sub-sector 检查）
5. **缩并线处理**（EOM、IBP、prefactor；massive Wronskian 缩并和 massless theta 边界分开处理）
6. **ISP 管线**（当前保留直接 ISP 移位；后续补完备性数值检查和 Kira 映射）
7. **time-IBP 完整化**（当前已完成受保护的 shrink-sector seed 派生与联立；生成后立即 EOM/massless canonical）
8. **canonical seed 验证**（无 `n=2`、time/momentum 完备、小样本手推对比）
9. **Linear/Kira 导出**（已实现 ready linear-system 中间层和 Kira user-defined system 文件导出；全 sector b 幂次排序和 sectorMetadataList 已接入，用户指定 master/weight 仍需细化）

## 9. 验证原则

- 任何验证默认只生成 seed、metadata、生成元列表、pack 结构和有限数量的检查摘要。
- 禁止在默认测试中生成完整解析 IBP 方程组，更禁止对大解析方程组做 `Solve`、`FullSimplify`、解析 `MatrixRank` 或后端约化。
- 若需要 rank/span 检查，必须先对符号参数做明确代数赋值，使用小整数或有理数测试；检查文件名需标注 `numeric` 或 `specialized`。
- 解析公式检查只允许针对单条公式、单个 seed 或非常小的 representative term，不得批量展开。
- Kira 测试只检查导出文件语法和小范围 toy case，不在主线结构测试中启动大约化。没有 EOM/time-IBP 完整 canonical seed 和 linear-system 数据时，不做 Kira 导出测试；seed 本身不直接导出 Kira。
