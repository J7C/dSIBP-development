# 接触边界系数审查

## 发现与结论范围

先比较 MadStree 原版在 rho=10、5、2.8 的 `J0000` 与本次自行编写的 Wick 旋转积分参考，发现 pp/mm 的显著差异。随后审查了运行提交下的边界端点选择、扇区状态投影、请求序列化和后端权重合并。

已确认的是：**特定等时接触边界的单导数系数生成与论文对称平均定义不一致，且对应单边因子实际出现在这次保存的边界数据中。** 未证明的是：修正这一问题能解释多少终值差异，或是否能消除全部差异。本轮没有执行修复、重新生成边界或重算输运。

用户提供的 [Word 原件](MadStree_bubble边界系数问题审查及修复建议.docx) 是审查说明，其附录由 ChatGPT 提出，尚未执行和验证；不是作者官方补丁，也不是已验证补丁。Word 中提及的后来提交只作为后来审查版本登记。文档中的修改建议不构成本轮执行指令。

## 固定提交与准确代码位置

下列代码均固定为包提交 `7dfd3c4afad4dd29ccae744f606a784121a90619`。完整原件在 `source_at_run_commit/MadStree/`，逐行代码原文见 [fixed_commit_code_excerpts.md](fixed_commit_code_excerpts.md)，文件哈希与 Git blob 对照见 `provenance/fixed_commit_file_checks.json`。

| 文件与函数 | 原行号 | 行为 |
|---|---|---|
| [Boundary.wl](https://github.com/J7C/dSIBP-Packages/blob/7dfd3c4afad4dd29ccae744f606a784121a90619/MadStree/Kernel/Numerics/Boundary.wl#L249)，`msPaperC` / `msVertexEndpointCoefficient` | 249；252–255 | 定义 C 与 Negative 端点系数 |
| 同文件，`msBoundaryFullBranches` | 266–267 | pp 按 firstDominantQ 选择 `(1,2)`，mm 选择 `(2,1)` |
| 同文件，`msBoundaryHankelBranch` | 275–302，核心 290–297 | 两端属于同一时间分量时设 `firstDominantQ=True` |
| 同文件，`msGenericSectorLeadingRecord` | 440–559，核心 493–506、555–557 | 单独选择每个端点系数，相乘；生成 physicalWeight |
| [Sectors.wl](https://github.com/J7C/dSIBP-Packages/blob/7dfd3c4afad4dd29ccae744f606a784121a90619/MadStree/Kernel/Core/Sectors.wl#L183)，局部 `canonicalize` 及 embedding/projection 构造 | 183；193–206 | 10→01；矩阵选择/复制分量，没有对 Hankel 排列取平均 |
| [PathEvaluation.wl](https://github.com/J7C/dSIBP-Packages/blob/7dfd3c4afad4dd29ccae744f606a784121a90619/MadStree/Kernel/Numerics/PathEvaluation.wl#L335)，`msEvaluationBoundaryInput` | 335–367 | 将已生成 leadingBranches、physicalWeight 序列化 |
| [flintnde_transport.py](https://github.com/J7C/dSIBP-Packages/blob/7dfd3c4afad4dd29ccae744f606a784121a90619/MadStree/Backend/flintnde_transport.py#L368)，`_initial_vectors` | 368；375–377 | 读取权重并加权合并局部基解，不重新决定物理平均 |

## 论文定义与原实现

固定论文提交为 `264141f0b1349cc045ab5cbf3a290642b1102201`。`eq:bundle-odd-subsets`（988行标签；定义在981–996行）及附录 Step 4 规定 `d_e=A_e-B_e`，`m_e=(A_e+B_e)/2`。两条平行线时 `A1*A2-B1*B2=d1*m2+m1*d2`。夹缩一条线，另一条等时线保留 **两个完整乘积的平均**。

端点规则是论文 `eq:application-endpoint-states`，bubble 基底规则是 `eq:bubble-indexed-masters`。本例保留线的 01 状态中，两种排列为 `h0^(1)*h1^(2)` 与 `h0^(2)*h1^(1)`；等时本身不使这两个单导数乘积相同。

原代码 `C(nu)=2^(-nu)*Gamma(-nu)/(i*pi)`，记 `D(nu)=C(-nu-1)`。由原代码四条 Negative 系数规则读取，01 状态的两种乘积系数为 `exp(-i*pi*nu)*C*D`、`exp(+i*pi*nu)*C*D`；对称平均应为 `cos(pi*nu)*C*D`。nu=i/4 时，对应因子为：pp 实际选 `exp(pi/4)`，mm 实际选 `exp(-pi/4)`，平均定义为 `cosh(pi/4)`。这是特定边界乘积的符号比较；不是新增数值计算，也不是最终积分的整体修正因子。

## 对应到实际边界记录

| 全局索引 | 扇区/端点状态 | 实际记录的关键项 |
|---|---|---|
| 18 | 01 / 01；夹缩线1，保留线2 | pp 的 coefficient、physicalWeight 含 `E^(Pi/4)`；mm 对应反向指数因子 |
| 21 | 10 / 01；夹缩线2，保留线1 | 同样的单边指数因子 |

原 pp 记录第一处根索引18在 `results/native/pp_result.wl` 第1003–1027行附近；原文逐字保留。便于阅读的两个完整记录见 [pp_contact_18_21_records.wl](pp_contact_18_21_records.wl) 和 [mm_contact_18_21_records.wl](mm_contact_18_21_records.wl)。各记录同时保留 coefficient、anchorFactor、physicalWeight、normalizedLeadingVector；未写入候选 cosh 系数。

保存的边界结构与固定代码能够证明问题进入了本次**生成的物理边界数据**。代码调用链和成功 process 记录显示后端按这类权重合并；但成功请求 JSON 已删除，不能声称已逐字核验成功请求的每个舍入权重。原始证据缺口与符号系数不一致的判断应同时保留。

没有将候选修复拆成可执行补丁，也没有修改 source_at_run_commit 原件。若将来获准修复，需要另建运行证据，不能覆盖本目录的旧结果。
