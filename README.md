# dS-IBP-Package

面向 de Sitter 圈图的通用 IBP seed 生成框架。目标是支持任意圈数、任意拓扑及 massive/massless 混合函数族，用统一 `J` 表示生成 time-IBP、loop-momentum IBP、即时 EOM/canonical seed，并转换为后端中立线性系统。Kira 只是可选 serializer，package 不负责运行 reduction。

## 先看这里

- 当前任务、真实完成状态和交接顺序：`研究计划与研究进度.md`。
- 长期总体架构：`000_note/dS_IBP_package_plan.md`。
- 设计约定：`000_note/dS_IBP_package_design_note.md`。
- 技术公式：`000_note/dS_IBP_package_tech_note.tex`。
- 给其它 AI 的独立推导任务书：`independent-benchmark/independent-benchmark.md`。

每次收到新任务，先更新 `研究计划与研究进度.md`；不要把逐任务 todolist 写进总体 plan。

## 当前版本

- `000_code/009_dS_ibp_general.wl`：当前开发主线，修复跨 sector 的 massless coincident canonical。
- `000_code/008_dS_ibp_general.wl`：上一开发版；已修复 massive `++` 符号，但 top 方程目标 sub-sector 的 coincident `n=1` 仍有已知缺陷。
- `000_code/007_dS_ibp_general.wl`：更早开发版；massive `++` Wronskian shrink 存在已知反号。
- `000_code/006_dS_ibp_general.wl`：旧稳定接口版。
- `dtau`、`dqq`、`dqk`、`rep2innerform`、`rep2outform` 和 `rep2Integrand` 等较大公开 API 尚未加入 009。

009 当前通过：

- 独立手推 `atomic_massive_line`：104/104。
- 独立手推 `atomic_massless_line`：22/22，加易错点 8/8。
- 独立手推 `pure_massless_bubble`：70/70。
- `009_symmetry_check.wl`：11/11。
- `009_massless_direction_check.wl`：27/27。
- `009_sp_interface_check.wl`：24/24。
- `009_scalar_product_cache_check.wl`：8/8。
- `009_kira_export_smoke_check.wl`：11/11，只检查 serializer，不运行 Kira/Fermat。

这些仍不是所有指定函数族的完整验证。mixed bubble、mixed triangle 和 mixed sunrise 等全 sector expected 仍待按新 convention 重推；旧 50 项 expected 不能作为 009 的证据。

## 核心表示

所有 sector 使用同一个 Head：

`J[aList, linePacks, ispList]`

- massive full/cross：`{b[e], n[e,1], n[e,2]}`。
- massless full：`{b[e], n[e]}`，采用双 theta 合并路线。
- massless cross：`{b[e]}`。
- shrunk line：`{bS[e]}`。
- massive 和 massless full 都可因 theta 导数产生 shrink sector。
- massive shrink：整数指标 `bS=b+1`。
- massless shrink：整数指标 `bS=b`。
- 缩并后 delta 积掉一个时间变量，合并顶点只保留一个 compact `a`；原顶点、代表顶点和指标槽映射保存在 sector metadata。
- 实际幂次包含用户给出的非零零点 `a0/b0/bS0`。新 benchmark 禁止把这些零点偷设为 0。

massless full 的 `lineData["endpoints"] -> {u,v}` 是有序输入。第一端点定义反对称 `n=1` 的方向；交换端点时 `n=0` 不变、`n=1` 变号。正式 massless 指标只允许 `n=0,1`。

## 用户输入

用户自行给出：

- `vertexData`：顶点 id 与 `+/-` 分支。
- `lineData`：每条内线 id、有序端点、动量、质量类型和 building-block 参数。
- `loopMomenta`：独立圈动量，可使用任意 Mathematica 符号。
- `externalMomenta`：会进入内线动量并与圈动量做标量积的独立外动量。
- `ispData`：补齐 loop scalar-product 空间的 ISP。
- `vertexEnergies`：只进入顶点时间相位的外腿打包能量。
- `externalInvariantRules`、`zeroPointRules`、`numericRules`、可选用户 `symmetryRules` 和受保护的 seed 范围。

用户端标量积统一写 `sp[p,q]`。`sp` 具有 `Orderless` 属性，因此 `sp[p,q]` 与 `sp[q,p]` 自动一致。外动量-外动量标量积输出为默认 `sij` 或用户指定变量，不保留为 `sp[k_i,k_j]`。

只进入顶点相位且不与圈动量纠缠的外腿能量使用独立参数 `ke[i]`。若某顶点能量应与外部不变量共用同一变量，应由用户显式写成该不变量的函数。`|ke1+ke2|` 与 `|ke1|+|ke2|` 不能自动混同；独立的模长和应另命名为新的 `ke[i]`。

## 生成元

对于 `L` 个圈动量和 `K` 个 `externalMomenta`，完整 loop-momentum 生成元为

`d/dq_l . v,  v in {q_1,...,q_L,k_1,...,k_K}`

总数为 `L(L+K)`，包括对角、圈动量交叉和外动量生成元。每个 active vertex 另有一个 time-IBP 生成元。

seed 生成顺序固定为：

1. 解析 topology 并检查传播子加 ISP 是否闭合。
2. 枚举当前 sector 的连续基点和全部所需 `n=0/1` 状态。
3. 作用所有 active time 与完整 loop-momentum 生成元。
4. massive 一旦产生 `n>=2`，立即 EOM；massless 直接在 `0/1` 间翻转。
5. 加入 massive/massless theta-boundary shrink，并 canonical 化 sector。
6. 保存解析 seed MMA。
7. 需要后端时才以小型代数数值规则构造 `linearData`。

## linearData

`linearData` 不是物理积分或约化结果，而是后端中立的 Mathematica `Association`。它保存：

- `linearEquations`：编号后的线性关系。
- `integralList` 和 `integralRules`：全 sector 的统一积分排序和映射。
- `sectorMetadataList`：各 sector 的 topology、compact `a` 和 line slot 信息。
- coefficient、ordering、coverage 与 readiness reports。

serializer 只把这些数据转换为后端语法，不重新推导 IBP。当前 Kira serializer 只生成基础 `ibp.kira`、`list`、`jobs.yaml`、积分映射和 metadata；不写本机 Kira/Fermat 路径，也不运行 Kira。

## 轻量检查

所有 WolframScript 检查必须提权运行，不使用 `Quiet`，并禁止大范围解析生成。例如：

```powershell
wolframscript -file '000_code\check\009_massless_direction_check.wl'
wolframscript -file '000_code\check\009_sp_interface_check.wl'
wolframscript -file '000_code\check\009_scalar_product_cache_check.wl'
wolframscript -file '000_code\check\009_kira_export_smoke_check.wl'
```

## 当前限制

- 新 convention 的 pure massless bubble 已完成 70/70；mixed bubble、mixed triangle、mixed sunrise 等全 sector、全生成元独立手推 expected 尚在重建。
- 同一顶点对多条 massless 线的进一步 bundle canonical 尚未实现；当前正式表示仍逐线使用 `{b[e],n[e]}`。
- 尚未正式封装 `BeginPackage/EndPackage`。
- 009 之后计划的较大公开原子 API 尚未实现。
- package 不自动选择或删除传播子 basis；用户输入的 propagator 与 ISP 应构成可反解 family。
- package 不运行 Kira、Rational Tracer 或其它 reduction backend。
- 禁止默认大范围解析 IBP 或大范围撒点。
