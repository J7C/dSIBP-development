# dS IBP seed 层验证计划

本文记录 package 的小拓扑 seed-level 验证路线。验证目标不是完成约化，也不是生成整族解析 IBP 方程组，而是检查：给定拓扑输入后，程序生成的单个 seed 模板、指标包移位、离散态枚举和生成元列表是否符合手推结果。

## 1. 验证红线

- seed 层预期表达式复杂度不大，默认保持解析。
- 只有需要做 rank/span、撒点或程序一致性统计时，才先应用 `numericRules`，再对有限的 `a_i,b_i,n_i` 取值。
- 严禁大范围撒点。验证范围只覆盖代表性状态，例如每条 massless 线的 `n=0,1`、massive 线的一两个端点态，而不是遍历所有 massive triangle 的 `n_{i,a}` 组合。
- 不对完整 family 做解析 `Solve`、`FullSimplify`、大符号 `MatrixRank` 或后端约化。
- 完整 seed 检查必须按 sector、生成元类型、离散态 `n=0/1` 展开后再比较；任何检查输出都要先应用 EOM，确认无 `n=2` 残留。
- Kira 导出不属于 seed-level 验证本身。seed batch 先保存为 MMA 表达式；只有 EOM/time-IBP canonical seed 转成 linear-system 后，才做 Kira 文件输出检查。

## 2. seed canonical 检查口径

每个手推/程序对比 case 都按同一口径组织：

1. 选择 sector：top 或某条线缩并后的 sub-sector。
2. 选择生成元：time-IBP 或 momentum-IBP，二者都要覆盖；只测 momentum propagator-only 不算完整 IBP 验证。
3. 先代入连续 seed 的少量样本值，再枚举该样本下的离散 `n=0/1` 状态。
4. 生成元作用后立即执行 EOM，所有 `n=2` 都必须在 seed 层消失。
5. 对 massless 线使用 A 类双 theta 合并主线，输出保持 `{b_e,n_e}`。若另写 bundle 合并版本，只作为未来优化检查，不作为当前 package 默认。
## 3. 输入中的数值规则

每个 case 可在初始化处给出

```mathematica
numericRules = {
  d -> 3,
  s11 -> 5,
  ke[3] -> 17,
  s12 -> -1,
  nu1 -> 2,
  nu2 -> 2,
  (* 其它外动量不变量、顶点能量、质量参数、零点参数 *)
};
```

`numericRules` 不属于 `J` 的指标。它只用于验证、撒点或导出数值 IBP 时替换系数。主线程序应允许：

- `numericRules -> {}`：保持解析 seed。
- `numericRules -> {...}`：生成数值系数 seed 或数值验证样本。

006 起用户口的圈动量相关标量积仍写 `sp[p,r]`。外动量-外动量不变量在输出和数值规则模板中写作变量名：用户可通过 `externalInvariantRules` 自定义，未指定时默认按 `externalMomenta` 顺序为 `sij`，因此例子中写 `s11 -> 5`。`vertexEnergies` 的每个值表示一个顶点连着的所有外腿打包后的 e 指数能量；若这个能量和 `externalMomenta` 空间中的外部不变量是同一变量，应写成对应变量名表达式并复用同一条数值规则；若不由 `externalMomenta` 的标量积表达式复用，应写作独立 `ke[i]` 参数和普通替换 `ke[i] -> value`，不放入 `externalMomenta` 或 ISP 完备性坐标。`|ke1+ke2|`、`|ke1|`、`|ke2|` 独立时必须分别命名。外腿能量参数之间不做完备标量积；该约定用于避免未复用关系造成约化冗余，并让微分方程阶段对同一变量统一求导；若用户希望独立求导，则应显式输入独立 `ke[i]` 参数。`vertexEnergies` 中不能直接写 `loopMomenta/externalMomenta` 的向量符号，也不能写圈相关 `sp[q,k]`；属于外动量空间时写外部不变量变量名表达式，否则写独立 `ke[i]`。

## 4. 验证 case A：一 massive 一 massless 的 bubble

拓扑：

```mathematica
vertexData = {{1, "+"}, {2, "+"}};
loopMomenta = {q1};
externalMomenta = {k};
lineData = {
  <|"id" -> 1, "endpoints" -> {1, 2}, "momentum" -> q1,
    "massType" -> "massive", "bbType" -> "h", "skType" -> "++"|>,
  <|"id" -> 2, "endpoints" -> {1, 2}, "momentum" -> q1 - k,
    "massType" -> "massless", "bbType" -> "exp", "skType" -> "++"|>
};
```

指标包：

```mathematica
J[{a1, a2}, {{b1, n11, n12}, {b2, n2}}, ispList]
```

离散态数量：

- massive 线：`{n11,n12} ∈ {0,1}^2`，4 个状态。
- massless 线：`n2 ∈ {0,1}`，2 个状态。
- top-sector 基础离散态共 8 个。

生成元：

- 时间 IBP：`?_{τ1}`、`?_{τ2}`。
- 圈动量 IBP：`?_{q1}·q1`、`?_{q1}·k`。
- 基础 seed 模板共 4 个；完整离散态展开最多 32 条，验证时不必全撒点。

手推检查重点：

- massive 线的端点导数仍按 `{b1,n11,n12}` 移位。
- massless 线只能在 `{b2,n2}` 中翻转/压缩，不能生成 `{b2,n21,n22}`。
- `G^{++}` 双 theta 合并下，massless 的 `{10}=-{01}` 和 `{11}=q^2{00}` 已经吸收到 `{b2,n2}` 约定中。

## 5. 验证 case B：两个等质量 massive + 一个 massless 的 triangle

选择这个 case 是为了测试多传播子和 mixed pack，同时避免纯 massive triangle 的 `n_{i,a}` 全遍历爆炸。

拓扑示例：

```mathematica
vertexData = {{1, "+"}, {2, "+"}, {3, "+"}};
loopMomenta = {q1};
externalMomenta = {k1, k2};
lineData = {
  <|"id" -> 1, "endpoints" -> {1, 2}, "momentum" -> q1,
    "massType" -> "massive", "bbType" -> "h", "nu" -> nuM, "skType" -> "++"|>,
  <|"id" -> 2, "endpoints" -> {2, 3}, "momentum" -> q1 - k1,
    "massType" -> "massive", "bbType" -> "h", "nu" -> nuM, "skType" -> "++"|>,
  <|"id" -> 3, "endpoints" -> {3, 1}, "momentum" -> q1 + k2,
    "massType" -> "massless", "bbType" -> "exp", "nu" -> 0, "skType" -> "++"|>
};
```

指标包：

```mathematica
J[{a1, a2, a3}, {{b1,n11,n12}, {b2,n21,n22}, {b3,n3}}, ispList]
```

生成元：

- 时间 IBP：3 个。
- 圈动量 IBP：`?_{q1}·q1`、`?_{q1}·k1`、`?_{q1}·k2`，共 3 个。
- 基础 seed 模板共 6 个。

验证时只取代表性离散态，例如：

```mathematica
{n11, n12, n21, n22, n3} -> {0,0,0,0,0}
{n11, n12, n21, n22, n3} -> {1,0,0,0,1}
{n11, n12, n21, n22, n3} -> {0,1,1,0,0}
```

不要遍历全部 \(2^5=32\) 个状态，除非只是做 pack/seed 计数而不展开解析公式。

## 6. 验证 case C：纯 massless bubble

拓扑仍为单圈两点、两条 massless 内线，两个传播子连接同一对顶点。这个 case 用来检查双 theta 合并主线和“同一顶点对多条 massless 线”的未来 bundle 优化口径。

当前 package 默认检查版本：逐线 merged-two-theta，不做 bundle 合并。指标包为

```mathematica
J[{a1, a2}, {{b1, n1}, {b2, n2}}, ispList]
```

未来 bundle 检查版本：两条 massless 线共享同一对时间变量，严格 theta 支撑只有两个互斥区域，可把两条线的 theta 状态合并处理。此版本暂不作为代码默认，也不要求当前实现；只保留为未来减少冗余状态的计划。

## 7. 验证 case D：mixed sunrise，两圈两点图

拓扑：三个圈传播子连接同一对外部顶点，其中一条等质量 massive、两条 massless。该 case 用来检查两圈生成元、ISP 保留，以及多条 massless 线位于同一顶点对时程序不会出错。

当前 package 默认检查版本：逐线 merged-two-theta，指标包示意为

```mathematica
J[{a1, a2}, {{b1, n11, n12}, {b2, n2}, {b3, n3}}, {ispN[1], ispN[2]}]
```

这里 `ispN` 必须出现在手推 seed 与程序 seed 中；sunrise 检查不能只比较基准积分而漏掉 ISP。和 pure massless bubble 一样，bundle 合并版本只作为未来 check 文件中的 alternative expected data，不作为当前 package 默认。
## 8. 后续程序验证接口

建议每个 check case 输出：

- `caseName`
- `linePacks`
- `generatorList`
- `seedTemplates`
- `sampleDiscreteRules`
- `numericRules`
- `sampleExpandedSeeds`

其中 `sampleExpandedSeeds` 只对少量手选状态生成，用于和手推结果逐项比较。


## 9. 同一顶点对多条 massless 线的 bundle 合并

若两顶点之间有多条 `G^{++}`/`G^{--}` massless 传播子，它们共享同一对时间变量，严格说只有两个互斥 theta 区域，而不是逐线独立的 `2^N` 个 theta 选择。当前 package 暂不实现这个额外 bundle 合并；实际 check 采用逐线 `{b_e,n_e}` 的 per-line merged-theta 版本，确保程序对任意输入不出错。`000_code/check/004_seed_expected_examples.wl` 中已保留 `bundledFuture` 预期草图，未来若实现 bundle 逻辑，可切换 check 版本。


## 10. 当前已落地的小 seed 检查

当前 `000_code/004_dS_ibp_general.wl` 已实现 `applyMomentumGeneratorSeed` 的 momentum seed 层：包含传播子幂次 `b_e`/`bS_e` 导数项、`v.Q_e` 中 `z_e` 对应的 `b_e -> b_e-2` 吸收、直接 ISP（如 `qk[i,j]`）的 `ispN[j] -> ispN[j]+1` 吸收，以及 massive building-block 动量导数项。`makeMomentumIBPSeedBatch` 已在每条 seed 后调用 `applySeedCanonical`，并用 `forbiddenNData` 扫描保证 massiveFull 中不残留 `n>=2`。同时，`applyTimeGeneratorSeed`/`makeTimeIBPSeedBatch` 已接入 time-IBP core：顶点幂次项、外部相位项、massive building-block 端点导数项、massless 端点翻转项、massive theta boundary shrink 项，并在 batch 层立即调用 EOM 与 massless endpoint canonical。`makeCanonicalSeedBatch` 会在 `MaxShrinkSectorCount` 保护内自动派生 shrink-sector 拓扑并联立其 time/momentum seed；linear-system 后端可导出 Kira user-defined system 文件，但检查不运行 Kira。

对应 check 写在 `000_code/check/004_seed_expected_examples.wl`：

- pure massless bubble：检查 `?_{q1}·q1` 的 massless per-line merged-theta momentum seed。
- mixed bubble：检查 massive building-block 动量导数项会产生端点 `n+1`，且若出现 `n=2` 会被 EOM seed-canonical 化；同时检查 time-core 的 `τ1` seed 和 time batch EOM 门禁。
- mixed sunrise：检查 `?_{q1}·k` 会产生 `ispN[1]+1` 与 `ispN[2]+1` 的分子指标移位，并包含 massive building-block 动量导数项，确认 sunrise 预期并非只在基准积分里包含 ISP。

运行入口为：

```powershell
& 'D:\Wolfram Research\Wolfram\15.0\wolframscript.exe' -file '000_code\check\run_004_seed_expected_examples.wl'
```

注意：Wolfram 运行需要提权；该检查只做小 seed/metadata 比较，不生成完整解析 IBP 系统。

## 11. seedRanges 驱动的批量 seed 接口

当前 `000_code/004_dS_ibp_general.wl` 新增了受保护的批量接口：

- `makeContinuousSeedRules[topo]`：从 `seedRanges` 读取 `"a"`、`"b"`、`"isp"` 范围，生成连续指标替换规则。若 `"sampleOnly" -> True`，只取所有连续指标为 0 的基准规则。
- `selectedDiscreteSeedRules[topo]`：默认使用 `sampleDiscreteRules`，不自动全遍历 massive 线的离散 `n` 状态；只有显式 `DiscreteMode -> "all"` 才尝试全枚举，并受 `MaxDiscreteRuleCount` 保护。
- `makeMomentumIBPSeedBatch[topo]`：组合连续规则、离散规则和所有 momentum 生成元，生成小批 EOM-canonical momentum seed。默认 `MaxEquationCount -> 80`，超过即返回 `"tooMany"`，不展开方程。

`000_code/check/004_seed_expected_examples.wl` 已加入 massless bubble 的批量检查：在 `sampleOnly` 下生成 1 组连续规则、3 组手选离散规则、2 个 momentum 生成元，因此共 6 条 seed；同时检查关闭 `sampleOnly` 后连续规则数为 225，并能被小阈值 guard 拦住。

该接口仍只服务 momentum seed 层：它会自动执行 massive EOM canonical 和 massless endpoint canonical，也会处理 massive building-block 动量导数及 shrunk-line `bS` 幂次，但不会生成 time-IBP，不会导出 Kira。time seed 由 `makeTimeIBPSeedBatch` 单独生成；在自动 shrink-sector seed 派生/联立接入前，两类 batch 都只能作为 seed regression data；后续 Kira exporter 不应直接消费不完整 batch，而应消费 time/momentum 完整后的 canonical seed 字段。

## 12. 线性系统中间格式

为后续 Kira 导出，`000_code/004_dS_ibp_general.wl` 新增了 seed 方程的线性系统中间层。seed batch 本身只保存为 MMA 表达式，不直接导出到 Kira；Kira exporter 只消费 `makeLinearSystemData` 的输出，并可在导出前用 `KiraCoefficientRules` 代入数值/撒点参数：

- `integralObjectsInBatch[batch]`：从 batch 的 `"equations"` 中抽取所有出现过的 `J[...]` 对象。
- `sortIntegralsForKira[integrals]`：对全 sector 的积分一起排序编号，当前第一优先级为所有线第一幂次指标（`b`/`bS`）的复杂度，避免 sub-sector master 被简单追加到最后。
- `makeLinearSystemData[batch, topo]`：只接受 `makeCanonicalSeedBatch` 产生、带 all-sector `qIBP/tIBP` 覆盖信息的 canonical batch；给排序后的 `J[...]` 建立整数编号，并把每条 seed 方程转成 `"coefficientRules" -> {id -> coeff, ...}`；若 batch 含 shrink sectors，会保存 top 与各 sub-sector 的 `sectorMetadataList`。momentum-only/time-only batch 会返回 `notCanonicalSeedBatch`，只作为 seed regression data。
- `writeSeedBatchMMA[batch, OutputDirectory -> dir]` / `readSeedBatchMMA[file]`：保存和读取 canonical seed batch；这是 seed 层输出，不是 Kira 输入。
- `makeKiraExportData[linearData]`：只接受 linear-system 数据，写 `userSystem/ibp.kira`、`list`、`jobs.yaml` 和 `J <-> id` 映射文件；零方程不会写入 `ibp.kira` block。

该层会保留：

- `"integralList"`：编号前的完整 `J` 对象列表。
- `"integralRules"`：`J[...] -> id` 的编号映射。
- `"integralSortKeys"`：全局排序 key，便于检查主积分优先级。
- `"sectorMetadataList"`：top sector 与每个 shrink sub-sector 的活跃 `a` 槽、固定 `a=0` 槽、每条线的端点/pack/b 指标和 ISP 槽信息。
- `"linearEquations"`：每条 seed 的生成元标签、连续/离散替换规则、系数规则、常数项和非线性残留。
- `"linearQ"` 与 `"nonlinearEquationCount"`：用于导出前检查是否出现了不能作为线性约化输入的项。

当前 check 用 massless bubble 的 `sampleOnly` batch 验证线性抽取，用 mixed bubble 和 mixed sunrise 检查 building-block/ISP 项，用 shrunk-line toy 检查 `bS` 动量项，并用 mixed bubble 检查自动 shrink-sector 后 canonical batch 可生成 `{top,e1}` 的 `sectorMetadataList`、可保存/读取 seed `.m`、且可写 Kira user-defined system 文件。006 接口另用 `sp[p,r]` 和非标准动量命名检查 `makeIBPWorkflowData` 可贯通 sampled linear 与 Kira 内存导出，并覆盖 `CoefficientRules -> Automatic` 时自动使用 topology `numericRules`、`KiraCoefficientRules -> Automatic` 时不重复撒点的默认路径。它还检查 line momentum 与 `sp[p,r]` 参数的线性组合门禁，非线性输入应在 topology validation 阶段被拒绝。该检查只做文件语法层，不运行 Kira。

## 13. 当前 time-core seed 检查

`000_code/004_dS_ibp_general.wl` 现在提供 `applyTimeGeneratorSeed` 与 `makeTimeIBPSeedBatch`。当前实现 time-IBP core：

- 顶点幂次项 `-a_v J[a_v-1]`。
- 外部相位项 `-I P_v J`，其中 `P_v` 由 `vertexEnergies` 指定；未指定时 006 使用独立占位 `ke[v]`，不再从 `extLegs` 自动求和，避免混淆 `|ke1+ke2|` 与 `|ke1|+|ke2|`。
- massive full line 的端点导数项，按端点把 `{b_e,n_{e,1},n_{e,2}}` 移到 `{b_e-1,n_{e,a}+1}`。
- massless full line 的端点翻转项，按逐线 merged theta 约定把 `{b_e,n_e}` 移到 `{b_e-1,1-n_e}`，端点 1/2 符号分别为 `+I/-I`。
- batch 层立即应用 EOM 与 massless endpoint canonical，并扫描 `forbiddenNData`。

当前已实现 top-sector massive theta boundary shrink 项；单独 `makeTimeIBPSeedBatch` 对含 massive full line 的拓扑仍标记 `shrinkSectorSeedGeneration`，而 `makeCanonicalSeedBatch` 会在保护阈值内自动派生并联立这些缩并 sector。当前 check 用 mixed bubble 验证 `τ1` core seed、massless endpoint 翻转、theta boundary shrink 和 `n=1 -> n=2 -> EOM` 路径，用 shrunk-line toy 验证输入为 shrunk sector 时 time batch 无额外 pending，并验证 mixed bubble canonical batch 自动补 1 个 shrink sector 后 ready。

非 quiet 检查入口：

```powershell
& 'D:\Wolfram Research\Wolfram\15.0\wolframscript.exe' -file '000_code\check\run_004_seed_expected_examples.wl'
```

## 14. canonical seed 与 Kira readiness 门禁检查

`makeCanonicalSeedBatch[topo]` 合并 momentum batch 与 time-core batch，并统一给出：

- `equationCount`、`momentumEquationCount`、`timeEquationCount`。
- `eomCanonicalQ` 与 `forbiddenNData`。
- `pendingFeatures`。
- `completeCanonicalQ`。

`makeKiraExportData[linearData]` 不再接受 seed batch；调用顺序必须是 `makeCanonicalSeedBatch[topo]`、必要时保存 seed MMA 文件、`makeLinearSystemData[batch, topo]`，最后再用数值/撒点规则导出 Kira。当前 mixed bubble 检查中，batch 合并 4 条 momentum seed、4 条 time-core seed 和 6 条 shrink-sector seed，`completeCanonicalQ=True`；linear-system 有 14 条方程、28 个积分、两份 sector metadata（`top` 与 `e1`），Kira 文件导出跳过零方程后写出 12 个非空 equation block。
