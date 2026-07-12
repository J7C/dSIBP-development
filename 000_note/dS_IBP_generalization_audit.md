# dS IBP package general 化审查记录

本文记录当前主线计划、设计笔记和代码相对于“任意圈图、任意拓扑、massive/massless 混合”的差距。这里的核心判据是：bubble 可以作为默认输入样例，但不能把生成器主体写死成 bubble。真正 general 的实现应满足：只替换 `vertexData`、`lineData`、`extLegs`、`loopMomenta`、`ispData`、`numericRules` 和策略配置，不修改 IBP 生成代码本身，仍能生成 EOM-canonical 的 time-IBP 与完整圈动量 IBP seed。Kira 输入是后端阶段，只能在 EOM/time-IBP canonical seed 转成 linear-system 后开放；seed 本身保存为 MMA 表达式，不直接导出 Kira。

## 1. general 判据

- 拓扑由输入数据驱动，bubble 只能是一个 case。
- 后端逻辑不得假设固定两顶点、两内线、单圈动量、单外动量或无 ISP。
- 完整圈动量 IBP 生成元为
  \[
    \mathcal O_{l,v}=\frac{\partial}{\partial q_l^\mu}v^\mu,\qquad
    v\in\{q_1,\ldots,q_L,k_1,\ldots,k_{E_{\rm ext}-1}\}.
  \]
  总数为 \(L(L+K)\)，其中 \(K=#externalMomenta\)，包含 diagonal、cross 和所有独立外动量方向；只有用户把普通散射的 \(E_{\rm ext}-1\) 个独立外动量都放进 externalMomenta 时才写成旧的 \(L(L+E_{\rm ext}-1)\)。
- massive 完整线指标包为 `{b_i,n_{i,1},n_{i,2}}`；massless 完整线在统一双 theta 合并路线中为 `{b_i,n_i}`。单 theta 分支约化只作为外部纯 massless 项目的参考路线，不作为本 package 的主线配置。
- seed 生成必须按 sector 和生成元分类，先枚举离散 `n=0/1`，再作用 IBP，并立即应用 EOM。输出中不得残留 `n=2`。
- 若同一对顶点之间有多条 massless 线，双 theta 合并路线中 Heaviside 区域不是逐线独立的 \(2^N\) 个分支，而是同一对时间变量的两个互斥区域；可进一步做 bundle 合并简化。该简化需要在设计中保留，但代码可先不专门实现 bundle canonical 化。

## 2. 当前代码状态与主要问题

当前主线代码应以 `000_code/004_dS_ibp_general.wl` 为准。相比早期 `003_dS_ibp_gen.wl`，它已经把 topology parser、pack 类型、massless `{b,n}`、momentum generator 列表、z/ISP 吸收、massive building-block 动量导数项、EOM seed-canonical 门禁和若干示例 case general 化了一部分；bubble 现在只是输入样例，不应视为硬编码目标。

仍未完成或有风险的点：

1. momentum seed 已覆盖传播子幂次项、直接 ISP 移位、z/ISP 吸收和 massive building-block 导数项；batch 输出已经接入 `applySeedCanonical`、`applyEOM` 与 `forbiddenNData` 扫描，原则上不允许 `n=2` 留在 seed 输出中。仍需继续检查的是 shrink/sector 交互，而不是再把 momentum 层视为纯 propagator-only。
2. EOM 已作为 massiveFull 的 seed 内部 canonical 步骤接入；任何新代码若产生 `n=2`，必须立刻通过同一门禁消去。linear-system 现在作为编号/线性抽取回归层；canonical batch 已能在保护阈值内补齐 shrink sectors；Kira user-defined system 文件语法与 jobs.yaml 已接入，master ordering/weight 仍需继续细化。
3. time-IBP core 已接入：顶点幂次项、外部相位项、massive building-block 端点导数项、massless 端点翻转项和 massive theta boundary shrink 项可生成小批 seed，并立即执行 EOM 与 massless endpoint canonical。已加入 shrunk-line `bS` momentum/time 小样本；canonical batch 现在会在 `MaxShrinkSectorCount` 保护内自动派生 shrink-sector 拓扑并生成其 time/momentum seed。
4. massless 主线已经约定并实现为 A 类双 theta 合并的逐线 `{b_e,n_e}` 路线；纯 massless 也不能切到单 theta 分支路线。
5. 同一顶点对多条 massless 线的 bundle 合并暂不实现，但代码必须在逐线 `{b_e,n_e}` 版本下不出错。future check 可保留 bundle expected data。
6. sub-sector 的一般图收缩仍需继续完善：缩并线 `{bS}`、顶点合并、线关联、外腿和后续 IBP 数据要保持一致。
7. 已加入统一 `makeCanonicalSeedBatch`、`makeLinearSystemData` 与 `makeKiraExportData` 分层：当前会合并 momentum/time-core/shrink-sector seed；canonical seed 通过后转成全 sector 统一排序编号的 linear-system，并保留 top/sub-sector 的 `sectorMetadataList`；Kira exporter 只接受 linear-system，可写 user-defined system 文件并跳过零方程。master ordering/weight 仍需继续细化。
8. 验证案例已有 pure massless bubble、mixed bubble、mixed triangle 和 mixed sunrise 的结构/seed 小样本，并加入 massless endpoint canonical、massive theta boundary shrink 和 shrunk-line `bS` 小检查；后续应继续补自动 shrink-sector 派生/联立的极小 seed-level 检查。验证只做小样本，不做整族解析大计算。

## 3. 后续实现顺序建议

1. 固化 topology/parser/pack/ISP 层，并保留 `numericRules` 作为系数替换输入。
2. 已有 EOM 工具需要继续作为所有 seed 入口的强制门禁：`applyEOM`、`containsForbiddenNQ`、`assertNoForbiddenN`，新增 time-IBP 后也必须复用。
3. 继续完善 momentum-IBP 的边界情形：shrunk line 动量项、sub-sector 与 ISP 的组合检查。
4. 在已接入的 canonical seed 层上继续细化 Kira 后端配置：用户指定 master、ordering/weight、参数文件和更大 toy case 语法检查。
5. 保持 massless 双 theta canonical 规则在 `{b_e,n_e}` 包内工作，不切换到单 theta 分支路线。
6. 扩展小拓扑 seed 检查：已有 momentum、mixed-bubble time-core、massless endpoint、theta boundary shrink、shrunk-line 与自动 shrink-sector 小样本继续保留，新增 Kira 文件语法 toy、mixed sunrise/sunrise bundle future 的小样本。所有检查先确保无 `n=2`。
7. Kira exporter 必须继续只接受 linear-system 数据；seed batch 只能先保存 MMA，再在完成数值/撒点规则后进入 Kira user-defined system 导出。
