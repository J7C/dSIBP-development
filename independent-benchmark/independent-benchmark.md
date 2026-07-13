# independent-benchmark

本文是给另一个 AI 独立推导 dS IBP benchmark seeds 的任务说明。不要参考本项目已有 check 结果；目标是从下面的 convention 出发，独立推导小拓扑的 time-IBP 与 loop-momentum IBP seed，用来反查 package。

## 1. 总目标

为 dS IBP package 独立生成一组小型、可人工审查的 seed-level benchmark。只推导 seed，不做大范围解析 IBP 生成，不跑 Kira reduction，不做大规模撒点。

本 independent benchmark 不包含旧 reference code 的例外情形。所有这里要求独立推导的例子都必须使用非零符号 zero-point；不能为了简化手推把零点设为 0，也不能把旧 bubble reference 的零点习惯套到这些新例子上。

每个 benchmark 必须覆盖：

- 所有顶点 SK 符号选择：每个顶点取 `+/-`，遍历全部组合。
- 全 sector：由 massive 线 shrink 产生的所有 subsector 都要覆盖；massless 线按主线 convention 不产生 shrink sector。
- 每个 sector 至少包含该 sector 的所有 time-IBP 生成元和所有 loop-momentum IBP 生成元在一个基准连续 seed 点上的关系。
- 离散 Hankel/massless theta 指标必须遍历 `0/1`，IBP 后立刻应用 EOM，输出中禁止残留任何 `n=2` 或更高阶导数指标。
- 输出应能直接被 Mathematica 读取比较，推荐另存为 `.wl` association；可另写简短 `.md` 说明，但不要把长推导塞进说明文档。

## 2. 积分与指标 convention

统一积分头：

```mathematica
J[aList, linePacks, ispList]
```

其中：

- `aList = {a[v1], a[v2], ...}` 为顶点时间幂次指标。若 sector 中因 massive shrink 用 delta 积掉并合并顶点，合并后的 sector 只保留代表顶点的一份 `a`。
- massive full line 的指标包为 `{b[e], n[e,1], n[e,2]}`。
- massless full line 的指标包为 `{b[e], n[e]}`，这是双 theta 合并路线的主线 convention。
- massive shrunk line 的指标包为 `{bS[e]}`。
- ISP 指标写在第三槽，例如 `{ispN[1], ispN[2]}`。没有 ISP 时为 `{}`。

不允许在指标槽中写质量、SK 符号、顶点能量、外动量不变量、zero-point 或 shrink prefactor；这些都属于 family 初始化信息。

重要：zero-point 不能在 benchmark 推导中取成 0。必须保留为符号参数，例如 `a0[v]`、`b0[e]`、`bS0[e]`。基准 seed 点只能把整数指标设为 0，例如 `a[v]->0`、`b[e]->0`，但系数中仍应出现 `a[v]+a0[v]`、`b[e]+b0[e]`、`bS[e]+bS0[e]`。若某个特定物理模式最后需要 `a0/b0` 的默认值，也只能作为后续替换规则单独记录，不能提前代入 benchmark seed。
massive shrink 后也必须保留 zero-point 变换，而不是把 shrink sector 的零点重新设为 0。对 `h` 模式 massive 线 `e`，若它连接的两个顶点合并为代表顶点 `r`，则在该 sector 中使用

```mathematica
a0[r]  -> a0[u] + a0[v] - 2 nu[e]
bS0[e] -> b0[e] + 2 nu[e]
```

剩余未缩并线的 `b0` 不变。若同一个 sector 中缩并多条 massive 线，合并顶点的 `a0` 要累加所有原顶点的 `a0`，并减去每条已缩并 `h` 线的 `2 nu[e]`。`H` 模式的非整数 zero-point shift 取 0，即 `bS0[e] -> b0[e]`，合并顶点不减 `2 nu[e]`。输出 seed 时必须能看出这些符号关系。

## 3. 标量积、外动量与顶点能量

用户口标量积统一写：

```mathematica
sp[p, q]
```

`sp` 是对称的，即 `sp[p,q] = sp[q,p]`。`p,q` 必须是 `loopMomenta` 与 `externalMomenta` 的线性组合。

`externalMomenta` 只包含会进入内线动量并和圈动量发生标量积的外部三动量。只进入顶点时间相位的外腿能量不放入 `externalMomenta`。

外动量-外动量不变量输出为变量名，不保持 `sp[k_i,k_j]` 形式。默认可记为 `sij`，或在 benchmark 中自定义，例如：

```mathematica
externalInvariantRules = {sp[k1,k1] -> s11, sp[k1,k2] -> s12};
```

顶点外腿打包能量写在 `vertexEnergies` 中：

- 若某顶点能量应和 `externalMomenta` 空间的外部不变量复用，写成对应变量表达式，如 `Sqrt[s11]`。
- 若它是独立绝对值参数，写成 `ke[i]`。
- `|ke1+ke2|`、`|ke1|`、`|ke2|` 若独立，必须分别命名；例如 `|ke1+ke2|` 写成新的 `ke[3]`，不能写成 `ke[1]+ke[2]`。
- 外腿能量之间不做点积。

## 4. IBP 生成元范围

time-IBP：

- 对每个当前 sector 的 active vertex 都要推导一个 time-IBP seed。
- 顶点 SK 符号 `+/-` 会改变时间相位和 propagator endpoint 符号；benchmark 必须遍历所有顶点符号组合。

loop-momentum IBP：

设圈动量数为 `L`，`externalMomenta` 个数为 `K`。完整生成元为

```mathematica
O[l, v] = d/dq_l . v
v in Join[loopMomenta, externalMomenta]
```

总数为 `L (L + K)`。必须包含：

- diagonal: `d/dq_l . q_l`
- cross: `d/dq_l . q_m`, `m != l`
- external: `d/dq_l . k_j`

不要把只进入顶点相位的 `ke[i]` 算进 `externalMomenta` 或 momentum-IBP 生成元。

## 5. EOM 与 massless 路线

Hankel/H-function 导数指标一旦出现 `n=2`，必须在 seed 层立即用 EOM 消去。最终 benchmark 中不允许出现 `n=2`。

massless 主线采用双 theta 合并路线：

- 不使用“只选单个 theta 项”的纯 massless 方案。
- massless full line 指标为 `{b[e], n[e]}`，其中 `n[e] in {0,1}`。
- 纯 massless 与 mixed massive/massless 都按同一路线处理。

同一对顶点之间有多条 massless 线时，还存在额外 bundle 合并简化。当前 package 主线可先不实现 bundle canonical 化，因此 benchmark 对这种例子要给两版：

- `perLineMergedTheta`：逐线 `{b[e], n[e]}`，这是当前 package 应比较的版本。
- `bundledMasslessFuture`：把同一对顶点之间多条 massless 线的两个 theta 区域合并后的未来版本，只作参考，不要求当前 package 通过。

## 6. 必推 benchmark 拓扑

### A. pure massless bubble

- 单圈两点图，两条 massless 线连接同一对顶点。
- `L=1`，一个进入内线的外动量 `k`。
- 需要两版：
  - `perLineMergedTheta`
  - `bundledMasslessFuture`
- 所有顶点符号组合：`++`, `+-`, `-+`, `--`。
- 全 sector：只有 top sector。
- 每个符号组合下，推导所有 time-IBP 与所有 momentum-IBP 生成元的 base seed，并遍历所有 `n[1], n[2] in {0,1}` 后 EOM/canonical。

### B. mixed bubble

- 单圈两点图，一条 massive 线、一条 massless 线。
- `L=1`，一个进入内线的外动量 `k`。
- 全 sector：
  - top sector
  - massive line shrunk sector
- 所有顶点符号组合：`++`, `+-`, `-+`, `--`。
- top sector 需遍历 massive `n[e,1], n[e,2] in {0,1}` 与 massless `n[e] in {0,1}`。
- shrunk sector 只保留 massive shrunk 包 `{bS[e]}` 与剩余 massless full line 包。

### C. mixed triangle

- 单圈三点图，两条等质量 massive 线、一条 massless 线。
- `L=1`，两个进入内线的独立外动量 `k1,k2`。
- massive 线共享同一个质量参数，例如 `nuM`。
- 全 sector：
  - top
  - massive line 1 shrunk
  - massive line 2 shrunk
  - massive line 1 与 2 同时 shrunk
- 所有三个顶点的 `+/-` 组合，共 `2^3` 个。
- 每个 sector 对 active vertices 推 time-IBP；对 `d/dq1 . q1`, `d/dq1 . k1`, `d/dq1 . k2` 推 momentum-IBP。
- 所有 massive/massless 离散 `n=0/1` 状态都要在 seed 层遍历并 EOM 化。

### D. mixed sunrise

- 两圈两点图，三个内线连接同一对顶点：一条 massive 线、两条 massless 线。
- massive 线质量参数用 `nuM`，两条 massless 线用双 theta合并路线。
- 建议动量指定：
  - `loopMomenta = {q1, q2}`
  - massive line: `q1`
  - massless line 1: `q2`
  - massless line 2: `q1 - q2 - k`
  - `externalMomenta = {k}`
- 需要 ISP，因为两圈标量积维度为 `L(L+1)/2 + L K = 5`，三条 propagator 不够。可选 ISP 例如 `sp[q1,k]` 与 `sp[q2,k]`，但推导者必须先检查 `z + ISP` 可反解全部 loop scalar products。
- 需要两版：
  - `perLineMergedTheta`
  - `bundledMasslessFuture`，因为两条 massless 线连接同一对顶点
- 全 sector：
  - top
  - massive line shrunk sector
- 顶点符号组合：`++`, `+-`, `-+`, `--`。
- momentum-IBP 生成元共 `2(2+1)=6` 个：
  - `d/dq1.q1`, `d/dq1.q2`, `d/dq1.k`
  - `d/dq2.q1`, `d/dq2.q2`, `d/dq2.k`
- 必须确认 seed 中 ISP 指标变化没有漏掉。

## 7. 连续 seed 点与输出范围

为了避免表达式爆炸，只取一个基准连续 seed 点；推荐：

```mathematica
a[v] -> 0
b[e] -> 0
bS[e] -> 0
ispN[j] -> 0
```

这些规则只作用于整数指标，不作用于 zero-point。也就是说，`a[v] -> 0` 后 time-IBP 幂次项应保留 `a0[v]`；`b[e] -> 0` 后 momentum-IBP 传播子幂次项应保留 `b0[e]`。

对 shrunk sector，`bS[e] -> 0` 后 momentum-IBP 传播子幂次项应保留 `bS0[e]`，并且 `bS0[e]` 要按上面的 shrink 规则表达为 `b0[e] + 2 nu[e]` 或 `b0[e]`。合并顶点的 time-IBP 幂次项也应保留变换后的 `a0[rep]`，例如 `a[rep] + a0[u] + a0[v] - 2 nu[e]`。

若某条 seed 在该点退化为零，可额外给一个最小非零点，例如把相关整数指标 `b[e]` 或 `a[v]` 设为 `1`，但必须在输出中记录原因；即使这样，zero-point 仍保留为参数。

离散指标不允许只取一个样本；必须遍历全部 `n=0/1` 状态，然后 EOM/canonical。

## 8. 输出格式要求

推荐输出一个 Mathematica 文件：

```mathematica
independentBenchmarkSeeds = <|
  "conventionVersion" -> "dS-IBP independent benchmark v1",
  "topologies" -> <|
    "pureMasslessBubble" -> <|
      "route" -> "perLineMergedTheta",
      "caseData" -> <| ... |>,
      "sectors" -> <|
        "top" -> <|
          "vertexSigns" -> <|
            "++" -> <|
              "timeIBP" -> { ... },
              "momentumIBP" -> { ... }
            |>
          |>
        |>
      |>
    |>
  |>
|>;
```

每条 seed 记录至少包含：

- `sectorKey`
- `vertexSigns`
- `generator`，如 `<|"type"->"time","vertex"->1|>` 或 `<|"type"->"momentum","dLoop"->1,"vector"->q1|>`
- `continuousSeedRules`
- `zeroPointSymbols`，例如 `{a0[1], b0[1], bS0[1]}`
- `zeroPointRulesForSector`，例如 `{a0[1] -> a0[1] + a0[2] - 2 nuM, bS0[1] -> b0[1] + 2 nuM}`；top sector 可给恒等或空规则，但 shrunk sector 必须给出
- `discreteStateRules`
- `equationAfterEOM`
- `containsNGe2Q -> False`
- 若是 bundled future 版本，标记 `"compareToCurrentPackageQ" -> False`

## 9. 禁止事项

- 不要从本项目已有 check 文件复制 seed 结果。
- 不要运行大范围解析 IBP。
- 不要做 Kira reduction。
- 不要只检查 top sector。
- 不要只检查全 `+` 顶点。
- 不要只推 momentum-IBP 而漏 time-IBP。
- 不要在最终 seed 中留下 `n=2`。
- 不要把 pure massless 改成单 theta 方案。
- 不要把本 independent benchmark 的任何新例子的 `a0/b0/bS0` 取成 0；旧 reference code 的零点例外不属于本文任务范围。
