# dS IBP Package - 项目规则

## 项目概述

本 package 用于生成任意 dS 时空 Feynman 图（任意圈数、任意拓扑、massive/massless 混合）的 IBP 关系，并导出 Kira 输入文件。

核心设计：拓扑输入驱动通用 IBP 生成函数，所有 sector 使用统一 Head `J`，通过线的状态（完整/缩并）区分 sector。

## 文档结构

- `000_note/dS_IBP_package_plan.md`：实现计划，包含统一积分表示、IBP 生成函数设计、拓扑输入格式
- `000_note/dS_IBP_package_design_note.md`：设计笔记，记录约定体系和关键推导
- `000_note/dS_IBP_package_tech_note.tex`：技术笔记，包含完整公式推导和 convention 汇总
- `研究计划与研究进度.md`：当前任务、完成状态、验证记录和交接顺序；每次收到新任务必须先更新
- `independent-benchmark/independent-benchmark.md`：交给独立推导者的 benchmark 规范
- `independent-benchmark/package/`：独立推导结果冻结后使用的当前程序、正式用户手册和少量应用 examples；不得放 expected、验证脚本或开发文档
- `000_note/2026-07-21_common_theta_correctness_todo.md`：共同-theta、`WT`、指标/零点、可达 sector 与下游模块的最高优先级正确性验收清单

## 代码结构

- `000_code/012_dS_ibp_general.wl`：当前开发主线脚本
- `000_code/011_dS_ibp_general.wl`：上一开发版，保留 v011 报告对应行为
- `000_code/010_dS_ibp_general.wl`：再上一开发版
- `000_code/009_dS_ibp_general.wl`、`000_code/008_dS_ibp_general.wl`、`000_code/007_dS_ibp_general.wl`：保留的历史版本；001--006 及其专用检查不再保留
- `000_code/check/`：当前主线验证脚本
- `000_code/test/`：临时测试脚本
- `000_code/test/results_test/`：测试输出

## 关键约定

### 质量参数 ν

- ν² = m²/H² - d²/4（d=3 时为 m²/H² - 9/4）
- 本 package 只考虑纯实数 ν（重场）和纯虚数 ν = iμ（轻场）
- 详见 tech note §1.1

### 缩并 prefactor

- h 模式和 H 模式相同，均为 (4i/π)e^{π Im[ν]}
- 来源：cross-order Wronskian W[H_ν^(1), H_{ν*}^(2)] = -e^{π Im[ν]} 4i/(πz)（已数值验证）
- H 模式 τ 依赖为纯 1/z（整数幂次 -1，零点无移位）
- h 模式为 (-kτ)^{-2ν-1}（整数 -1 → 指标，非整数 -2ν → 零点）

### Common-theta 正确性门禁

- 同一当前代表顶点对的 full lines 必须作为一个共同时间差的 bundle 处理；该模块是正确性门禁，不是 future optimization。
- massive contact 必须消费最终 `WT=Det[T]W -> shrinkTerms`；不得绕过编译结果重新硬编码 Wronskian。
- simultaneous contact 只合并一次顶点，但每条选中线的整数 shift 与 zero-point shift 都必须累加到最终 `J` 和 sector metadata。
- 未选中 coincident full lines 必须立即 canonical；sector 只能来自 contact-reachable 状态。
- 两种等价分布方案的证明放在 tech note 附录；主实现固定使用共同-theta odd-subset canonical。
- 独立 benchmark 的正式交付文件名为 `package_012.wl` 和 `package_012.pdf`；更新版本时删除旧 package/manual，不保留无版本名副本。

### H 模式 EOM

- 裸 Hankel 导数基底 `H0=H_ν(x), H1=∂x H0` 的一阶矩阵必须含 `ν²/x²` 二次 pole。
- 007--010 的内置 H EOM 与 011/012 的 H preset 都必须使用 `H2=-H0-H1/x+ν² H0/x²`，对应第三项 `a_v->a_v-2, b_e->b_e+2, n->n-2`。
- 从 004 起传承的错误 `{2ν,1}` 递推已从保留版本和正式 benchmark 删除；不得重新引入。

### 多圈 IBP 生成元

- 完备集合：O_{l,v} = ∂/∂q_l^μ · v^μ，v ∈ {q_1, ..., q_L, k_1, ..., k_{E-1}}
- 总数：L(L + K)，其中 K 是 externalMomenta 中独立外动量数；包括 L 个对角、L(L-1) 个交叉和 LK 个外动量生成元
- ISP 处理：用户定义，需验证完备性

## Mathematica 脚本规范

### 1. 替换规则命名

**原则**：区分"规则本身"和"应用规则的函数"。

- `rep****0`：原始替换规则（raw rule），可直接用于 `/.`
- `rep****[expr_]`：函数形式，内部为 `expr /. rep****0`

**原因**：避免 `expr // func /. rep` 的优先级问题（需要括号 `(expr // func) /. rep`）。定义函数形式使链式调用更简洁。

### 2. 函数命名

**原则**：函数名应反映其物理/数学含义，而非操作方式。

- `eom[expr]`：EOM 递推约化（而非 `id`，后者含义模糊）
- `repSymmetry0[topo_]`：用户原始对称性规则；`symmetry[expr_, topo_]`：函数化单次应用
- `shiftIndex[expr, ...]`：指标移位（而非 `listcal`）
- `ibp[expr, generator]`：IBP 生成（用生成元标识，而非数字编号）

### 3. 统一积分表示

**原则**：所有 sector 使用同一个 Head，通过线的状态区分。

- 统一用 `J[...]`，不用 `G`, `R1`, `R2` 分别定义
- Sector 由哪些线处于缩并态标记
- 避免为不同 sector 写重复代码

### 4. 参数化而非硬编码

**原则**：物理性质应作为参数传入，而非写死在函数定义中。

**示例**：奇偶性筛选应参数化
```mathematica
(* 不好：硬编码特定拓扑的奇偶性 *)
reppowerselection = {
  G[{n1_, n2_, n3_, n4_}, ...] /; OddQ[n1+n2+b1] :> 0,
  R1[...] /; OddQ[b1] :> 0
};

(* 好：参数化，适配任意拓扑 *)
paritySelection[J_, parityFunc_] := {
  J[args___] /; parityFunc[args] :> 0
};
```

### 5. 代码组织

**原则**：按逻辑功能分章节，而非按操作步骤。

典型结构：
- **定义与初始化**：环境、参数、基本工具函数
- **物理规则**：EOM、对称性、缩并规则、IBP 生成元
- **生成与导出**：种子枚举、方程生成、格式化输出

### 6. 链式调用风格

**原则**：优先使用 `//` postfix 使数据流清晰。

```mathematica
(* 好：数据流从左到右 *)
seeds // generateIBP // applyEOM // applySymmetry // DeleteDuplicates

(* 避免：嵌套过深 *)
DeleteDuplicates[applySymmetry[applyEOM[generateIBP[seeds]]]]
```

### 7. 注释原则

**原则**：注释说明"为什么"，而非"做什么"。

- 引用文献公式：`(* Momentum IBP: eq.XX from ref *)`
- 说明特殊处理：`(* 注意：缩并后 ν→0，与函数族定义统一 *)`
- 不注释显而易见的操作

### 8. 避免的模式

- **不要**为每个 sector 复制粘贴代码，用统一函数 + 参数处理
- **不要**用数字编号区分物理上不同的操作（如 `ibp[expr, 1]`, `ibp[expr, 2]`），用生成元标识
- **不要**在函数内部硬编码拓扑特定信息（如线数、顶点数）

## 参考代码

- `reference/ref_code/codebubble/001 bubble_ibp_sym.m`：bubble 拓扑参考实现
- 注意：参考代码使用 `G`, `R1`, `R2` 分别标记 sector，新 package 应统一为 `J`
- 参考代码中的命名习惯（如 `rep****0`）应遵循，但具体实现应 generalize

## 开发流程

1. 收到新任务后先更新根目录 `研究计划与研究进度.md`，写清任务、未完成项和验收标准
2. 读取拓扑输入 + ISP 配置
3. 验证 ISP 完备性
4. 构造 IBP 生成元集合
5. 对每个 sector：枚举种子 → 应用生成元 → 转化为指标移位 → 应用 EOM
6. 分 sector 保存 canonical seed MMA 文件
7. 转换为 backend-neutral `linearData`，必要时在此层代入小规模数值规则
8. 由 serializer 转成 Kira 或其它后端的基础输入文件；package 不运行 reduction
