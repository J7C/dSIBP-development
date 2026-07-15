# dS IBP 独立 benchmark 推导任务书

> **用途边界**：本文是交给其它 AI 的独立推导任务说明书，所在的 `independent-benchmark/` 目录只保存任务输入。不要把本项目的手推答案、expected、check 或运行产物写入此目录。独立推导者应把结果输出到自己的新目录，维护者审查后再决定是否导入项目。

## 1. 任务目标

从本文给出的费曼规则、指标 convention 和函数族定义出发，独立推导小型 dS IBP seed，用来反查当前开发主线 `000_code/009_dS_ibp_general.wl`。独立推导时禁止读取主线代码、`000_code/check/`、旧 expected 或已有运行结果。

只做 seed-level 小型符号推导：

- 不生成大范围解析 IBP。
- 不做大范围撒点。
- 不运行 Kira、Fermat、Rational Tracer 或其它 reduction。
- 解析 seed 保持非零符号 zero-point。
- 每个函数族必须覆盖所有顶点 `+/-`、所有实际可达 sector、每个 sector 的全部 time 与 loop-momentum 生成元，以及全部适用离散 `n=0/1` 状态。
- 任何 massive `n=2` 一出现就立即 EOM；massless 正式表示从不产生 `n=2`。

## 2. 统一积分表示

所有 sector 使用

```mathematica
J[aList, linePacks, ispList]
```

- `aList`：当前 sector 的 active/merged 顶点时间幂次。delta 合并顶点后只保留一个代表顶点的 `a`。
- massive full/cross：`{b[e],n[e,1],n[e,2]}`。
- massless full：`{b[e],n[e]}`。
- massless cross：`{b[e]}`。
- shrunk line：`{bS[e]}`。
- ISP 指标只写在第三槽。

质量、SK 分支、顶点能量、外不变量、zero-point 和 shrink prefactor 都属于 family 初始化信息，不写进指标槽。

实际时间和线幂次分别为

```text
A[v]  = a[v]  + a0[v]
B[e]  = b[e]  + b0[e]
BS[e] = bS[e] + bS0[e]
```

除旧 reference bubble 的单独 reference 对照外，所有新 benchmark 的 `a0/b0/bS0` 必须保持非零符号参数。连续整数指标可以在基点取 0，但不能把 zero-point 也取 0。

## 3. 有序 massless 单 n convention

对同分支 massless full line，`lineData["endpoints"] -> {u,v}` 是有序输入。第一端点 `u` 定义反对称 `n=1` 的方向。令 `Delta=tau[u]-tau[v]`，`sigma=+1` 对应 `++`，`sigma=-1` 对应 `--`：

```text
M[0] = theta[ Delta] exp[-i sigma q Delta]
     + theta[-Delta] exp[ i sigma q Delta]

M[1] = -theta[ Delta] exp[-i sigma q Delta]
     +  theta[-Delta] exp[ i sigma q Delta]
```

交换端点时 `M[0]` 不变、`M[1]` 变号。旧双端点标签只允许用于中间推导：

```text
{10} = -{01}
{20} = {02} = -q^2 {00}
{11} = +q^2 {00}
```

正式指标只保留 `n=0,1`。端点导数为

```text
d_u M[n] =  i sigma q M[1-n] - 2 n delta(tau[u]-tau[v])
d_v M[n] = -i sigma q M[1-n] + 2 n delta(tau[u]-tau[v])
```

因此：

- regular time 导数：`{b,n}->{b-1,1-n}`；
- 第一端点系数 `+i sigma`，第二端点 `-i sigma`；
- 同一端点连续求导两次回到原 `n`，regular 部分系数为 `-1` 且 `b->b-2`；
- 只有 `n=1` 产生 theta-delta；
- massless shrink 使用 `bS=b`，无 Hankel prefactor 或 `nu` zero-point shift；
- 缩并后两原端点重合时，反对称 `n=1` 状态为零。

massless cross line 没有 theta、没有离散 `n`、没有 shrink。其每个端点的 time regular 导数系数由该端点分支决定：`+` 端点为 `+i`，`-` 端点为 `-i`，并令 `b->b-1`。

## 4. Massive 导数、EOM 与 shrink

massive full/cross 在两个端点各保留 `n[e,1],n[e,2]`。time 导数作用在端点 `r` 时先产生

```text
- J[..., b[e]-1, n[e,r]+1, ...]
```

若出现 `n[e,r]=2`，立刻使用

```text
J[..., n_r=2, ...]
 = -c2[e] J[..., n_r=0, ...]
   -c1[e] J[..., a[r]-1, b[e]+1, n_r=1, ...]
```

其中：

- h 模式：`{c1,c2}={2 nu[e]+1,1}`；
- H 模式：`{c1,c2}={2 nu[e],1}`。

EOM 只改变发生二阶导数的端点指标；另一端点状态保持不变。

massive full 的 theta boundary 只在 `n1+n2=1` 时出现。默认端点系数为

```text
C[e] (-1)^(n_endpoint)
```

其中 `C[e]=(4 i/pi) exp(pi Im[nu[e]])`；若 family 明确给出额外 sign offset，再额外乘相应符号。massive cross 没有 theta shrink。

massive h shrink：

```text
aMerged      = a[u] + a[v] - 1
a0Merged     = a0[u] + a0[v] - 2 nu[e]
bS[e]        = b[e] + 1
bS0[e]       = b0[e] + 2 nu[e]
```

massive H shrink 的整数关系相同，但两个 `2 nu[e]` zero-point shift 均为 0。多线 shrink 时按每个连通合并类累加顶点 zero-point，并乘所有 massive shrink prefactor。

## 5. Time-IBP

对每个当前 sector 的 active vertex `v` 推导

```text
0 = integral d/dtau[v] (integrand)
```

必须同时包含：

1. 顶点幂次：`-A[v]` 乘 `a[v]->a[v]-1` 的积分。
2. 外腿相位：
   - `+` 顶点使用 `exp[-i E[v] tau[v]]`，导数为 `-i E[v]`；
   - `-` 顶点使用 `exp[+i E[v] tau[v]]`，导数为 `+i E[v]`。
3. 所有连接到该 active vertex 的 massive/massless building block 端点导数。
4. 所有适用 theta-delta shrink 项。
5. EOM 和 coincident massless canonical。

缩并后若某条未缩并线的两个原端点都映到同一个 active vertex，对该 active time 求导时两个端点贡献必须都算；不能只取第一个匹配端点。

## 6. Loop-momentum IBP

设圈动量数为 `L`，会进入内线动量的独立外动量数为 `K`。完整生成元为

```text
O[l,v] = d/dq_l . v
v in {q_1,...,q_L,k_1,...,k_K}
```

总数 `L(L+K)`，必须全部推导：

- `d/dq_l.q_l`；
- `d/dq_l.q_m`，`m!=l`；
- `d/dq_l.k_j`。

每条关系必须包含：

1. `v=q_l` 时的空间维数 divergence 项。
2. 所有 line denominator 幂次导数，包括 shrunk line 的 `BS[e]`。
3. massive building block 对线动量模的导数。
4. massless full/cross 指数核对线动量模的导数。
5. ISP 因子自身的导数，以及标量积因子吸收到 propagator/ISP 指标后的移位。
6. 立即 EOM/canonical。

用户端标量积统一写 `sp[p,r]`，且 `sp` 对称。这里仅指标量积交换性，不是图或积分族指标对称性。用户可给圈动量任意符号名。外动量-外动量标量积在输出中使用用户定义变量或默认 `sij`，不保留成 `sp[k_i,k_j]`。

`externalMomenta` 只包含会与圈动量纠缠的外动量。只进入顶点时间相位的外腿打包能量用 `ke[i]`；`|ke1+ke2|` 若是独立模长，应记为新的 `ke[3]`，不能自动等于 `ke[1]+ke[2]`。

## 7. Sector 覆盖

对每个顶点符号 case：

1. 先根据端点分支判断每条 full line：
   - massive 同分支：massiveFull，可 shrink；
   - massive 异分支：massiveCross，不 shrink；
   - massless 同分支：masslessFull，可 shrink；
   - massless 异分支：masslessCross，不 shrink。
2. 枚举所有 theta-full 线的 shrink 子集，包括 top 空集。
3. 每个 sector 重新确定 active/merged vertices、compact `aList`、coincident endpoints 和剩余离散变量。
4. 每个 sector 必须覆盖全部 active time 生成元、全部 `L(L+K)` momentum 生成元和该 sector 全部离散 `0/1` 状态。
5. 即使某条 canonical 关系变成 0，也保留记录并注明原因。

不要给 cross line 伪造 shrink sector，也不要只按全 `+` case 的 sector 表套用到其它 SK case。

## 8. 必推函数族

### 8.1 atomic_massless_line

单条 massless 线，专测：

- `n=0/1 × 第一/第二端点`；
- `++/--/+-/-+`；
- 端点反转；
- 同端点二阶导数；
- theta-delta `-2/+2`；
- massless shrink `bS=b`；
- coincident `n=1` 为 0；
- massless full/cross 的 momentum 指数核导数；
- 顶点外部相位符号。

### 8.2 atomic_massive_line

单条 massive 线，分别测试 h/H：

- 两端点 `n=0/1`；
- time 导数后的即时 EOM；
- `n1+n2=1` 的两个端点 Wronskian sign；
- full/cross 区别；
- h/H shrink zero-point；
- 缩并后 compact `a`。

### 8.3 pure_massless_bubble

单圈两点图，两条 massless 线连接同一对顶点：

- `loopMomenta={q}`，`externalMomenta={k}`；
- 四个顶点符号组合；
- 每个 case 的全部可达 sector；
- 每个 sector 全部 time 和 `d/dq.q`、`d/dq.k`；
- 所有剩余 masslessFull `n=0/1`。

另推两版多线 theta 处理：

- `perLineMergedTheta`：每条线各自 `{b[e],n[e]}`，用于当前 package 比较；
- `bundledMasslessFuture`：同一顶点对共享两个 theta 区域，只作未来参考，不要求 009 通过。

### 8.4 mixed_bubble

单圈两点图，一条 massive h 线加一条 massless 线。要求同 pure massless bubble，并覆盖 massive/massless 两类 shrink、两线同时 shrink、cross case、EOM 和非零 zero-point。

### 8.5 mixed_triangle

单圈三点图，两条等质量 massive h 线加一条 massless 线：

- 三个顶点的 8 个 `+/-` 组合；
- `externalMomenta={k1,k2}`；
- 每个 sector 的全部 active time；
- `d/dq.q`、`d/dq.k1`、`d/dq.k2`；
- 全部剩余 massive/massless 离散状态；
- 缩并导致的顶点合并、coincident line 和 sector zero-point。

### 8.6 mixed_sunrise

两圈两点图，一条 massive h 线、两条 massless 线。建议路由：

```mathematica
loopMomenta = {q1,q2};
externalMomenta = {k};
Q[1] = q1;
Q[2] = q2;
Q[3] = q1-q2-k;
```

传播子不足以覆盖五个 loop scalar products，必须给独立 ISP 并先证明 propagator 加 ISP 可反解。不能只在 `ispN=0` 检查：至少另取一个最小 `ispN=1` seed，验证 ISP 因子自身求导。

四个顶点符号组合、全部可达 sector、全部 active time，以及六个 momentum 生成元：

```text
d/dq1.q1, d/dq1.q2, d/dq1.k
d/dq2.q1, d/dq2.q2, d/dq2.k
```

两条平行 massless 线同样给 `perLineMergedTheta` 与 `bundledMasslessFuture` 两版；009 只比较前者。

### 8.7 pure_massive_bubble_reference

用统一 `J` 与新 sector metadata 重推 pure massive bubble。另存一组与旧 reference code 相同零点的对照只用于检查旧代码；正式 benchmark 仍保留非零符号 zero-point。

本函数族还必须单独给出用户 `symmetryRules`：

- 两条 massive 内线质量相同（同一个 `nu`）时的内线交换/指标交换。
- 参考 code 特定参数中两外腿动量或顶点能量相等后新增的对称性。必须把这些参数条件写在 README，不能误说成一般 bubble 恒成立。
- 给出规则作用前后的代表积分与 IBP 关系，并检查 `symmetry` 后 canonical 结果。

### 8.8 two_loop_isp_toy

选择一个非 bubble 的两圈小拓扑，使用任意用户动量名和至少一个一般形式 ISP，例如 `sp[l3,k321+l3]` 或 `sp[l3+k321,wdnmd]`。专测：

- propagator 加 ISP 的闭合性；
- `dqq` 对角与交叉；
- `dqk`；
- `ispN=0` 时由标量积吸收产生的 ISP 移位；
- `ispN=1` 时 ISP 因子自身导数。

### 8.9 parallel_massless_bundle_guard

至少三条 massless 线连接同一顶点对。分别给逐线 current 与共同 theta future 公式，明确二者积分族维数和关系数不同，禁止把 future 公式误拿来判定 009 失败。

### 8.10 vertex_energy_signs

最小拓扑专测：

- `++/--/+-/-+` 顶点相位；
- 独立 `ke[i]`；
- 顶点能量复用 `Sqrt[s11]`；
- 独立 `|ke1+ke2|` 另记 `ke[3]`；
- 外腿能量不参与 momentum generator。

## 9. Seed 取值

一般函数族只取一个连续整数基点：

```mathematica
a[v] -> 0;
b[e] -> 0;
bS[e] -> 0;
ispN[j] -> 0;
```

但始终保留 `a0[v]`、`b0[e]`、`bS0[e]`。若关系退化为 0，可增加一个最小非零整数点并写明原因。`mixed_sunrise` 与 `two_loop_isp_toy` 必须额外取一个 `ispN[j]->1` 点。

离散态不能抽样：每个当前 sector 的所有 massive `n1,n2` 和 masslessFull `n` 都遍历 `0/1`。最终关系中禁止 massive `n>=2` 和 massless 非 `0/1`。


## 10. 用户输入的积分族对称性

积分族对称性完全由用户提供规则，benchmark 不自动从拓扑推断。推荐输入：

```mathematica
symmetryRules = {
  (* 只在 README 写明的质量与外参条件成立时使用 *)
  HoldPattern[J[{av1_,av2_},{pack1_,pack2_},isp_]] /;
      ! OrderedQ[{pack1,pack2}] :>
    J[{av2,av1},{pack2,pack1},isp]
};
```

独立推导者必须同时给出：

- 原始规则及成立的物理参数条件；
- 至少一个积分的规则前后结果；
- 至少一个 time-IBP 与一个 momentum-IBP 的规则前后结果；
- 规则为空时表达式不变。

只有 `pure_massive_bubble_reference` 使用非空 `symmetryRules`。其它函数族不加入额外对称性。`sp` 的 Orderless 另行检查，不能计入这里的图对称性覆盖。
## 11. 简单输出格式

不要输出多层嵌套 Association。每个函数族建立独立目录：

```text
<family-name>/
  README.md
  family.wl
  expected.wl
  derivation.md   (仅在确有必要时)
```

`README.md` 只写拓扑、端点顺序、动量路由、sector、生成元、离散态、预期 relation 计数和特殊 tags。

`expected.wl` 使用扁平列表：

```mathematica
expectedRelations = {
  <|
    "sector" -> "top",
    "vertexSigns" -> "++",
    "generator" -> {"time",v1},
    "seedRules" -> {a[v1]->0, b[1]->0, n[1]->1},
    "equation" -> (* 已 EOM/canonical 的 J 线性组合 *),
    "tags" -> {"masslessFirstEndpoint","thetaShrink"}
  |>,
  ...
};
```

每条 relation 只保留上述六个字段。另在 README 写：

- 预期 sector 数；
- 每 sector active time 数；
- momentum generator 数；
- 每 sector 离散态数；
- 总 relation 数；
- 零关系数及原因。

## 12. 完成检查表

每个函数族交付前确认：

- [ ] 没有读取本项目代码或旧 expected。
- [ ] 所有顶点符号组合已覆盖。
- [ ] 每个符号 case 的所有可达 sector 已覆盖。
- [ ] 每个 sector 的所有 active time 生成元已覆盖。
- [ ] 每个 sector 的所有 `L(L+K)` momentum 生成元已覆盖。
- [ ] 所有剩余离散 `n=0/1` 状态已覆盖。
- [ ] massive `n=2` 已立即 EOM。
- [ ] massless theta-delta 与有序端点符号已检查。
- [ ] 非零 zero-point 已保留。
- [ ] ISP 非零指标点已在两圈 ISP 例中检查。
- [ ] 输出没有写回 `independent-benchmark/`。
- [ ] current per-line 与 future bundle 版本没有混用。
