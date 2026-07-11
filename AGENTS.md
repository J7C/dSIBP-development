# dS IBP Package - 项目规则

## 项目概述

本 package 用于生成任意 dS 时空 Feynman 图（任意圈数、任意拓扑、massive/massless 混合）的 IBP 关系，并导出 Kira 输入文件。

核心设计：拓扑输入驱动通用 IBP 生成函数，所有 sector 使用统一 Head `J`，通过线的状态（完整/缩并）区分 sector。

## 文档结构

- `000_note/dS_IBP_package_plan.md`：实现计划，包含统一积分表示、IBP 生成函数设计、拓扑输入格式
- `000_note/dS_IBP_package_design_note.md`：设计笔记，记录约定体系和关键推导
- `000_note/dS_IBP_package_tech_note.tex`：技术笔记，包含完整公式推导和 convention 汇总

## 代码结构

- `000_code/`：主线脚本
- `000_code/check/`：验证脚本
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

### 多圈 IBP 生成元

- 完备集合：O_{l,v} = ∂/∂q_l^μ · v^μ，v ∈ {q_1, ..., q_L, k_1, ..., k_{E-1}}
- 总数：L(L + E - 1) = L（对角）+ L(L-1)（交叉）+ L(E-1)（外动量）
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
- `symmetry[expr]`：对称性约化
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

1. 读取拓扑输入 + ISP 配置
2. 验证 ISP 完备性
3. 构造 IBP 生成元集合
4. 对每个 sector：枚举种子 → 应用生成元 → 转化为指标移位 → 应用 EOM
5. 分 sector 保存 IBP 方程
6. 导出 Kira 输入格式
