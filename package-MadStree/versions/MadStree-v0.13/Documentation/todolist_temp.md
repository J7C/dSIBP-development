# MadStree v0.13 外腿能量命名与干净拓扑接口

## 范围

本版本以 v0.12 为只读基线，保持其 tensor formula、sector DAG、dlog DE、FlintNDE 输运和正规化算法，
但将顶点指数参数从含混的 `energy` 统一改为 `externalLegEnergy`。不保留 `energy`
别名、fallback、wrapper 或兼容测试。

## 物理合同

```wl
<|
  "id" -> 1,
  "vertexType" -> "+",
  "externalLegEnergy" -> E1,
  "timePower" -> a1
|>
```

- `externalLegEnergy` 是连在该顶点的外腿指数因子参数，不是顶点本身能量。
- `vertexType="+"` 唯一导出 `Exp[-I externalLegEnergy tau]`。
- `vertexType="-"` 唯一导出 `Exp[+I externalLegEnergy tau]`。
- line 不可输入任何第二套顶点相位或能量符号。

## 任务

- [x] M1. 将顶点 schema 必需键改为 `id/externalLegEnergy/timePower/vertexType`。
- [x] M2. 将所有内部 context、sector、boundary、DE、artifact 和数值代入改用新键。
- [x] M3. 删除所有 `Lookup[...,"energy"]`、`vertex["energy"]`、内部 `userEnergy/baseEnergy`
  含混命名与旧 schema 测试；全部改用明确的新命名。
- [x] M4. 同步六个 examples、开发回归、三个当前独立验证和任务书。
- [x] M5. 同步中英文 README、VERSION/UPDATE_NOTES、DEVELOPMENT_PLAN 与两份手册。
- [x] M6. 增加 `+/-` 顶点导数系数、边界 damping 坐标和 dlog letter 的定向回归。
- [x] M7. 验收后删除 v0.12 目录和旧版本验证资产；清空中间产物后只从 v0.13 路径 fresh 重跑。
- [ ] M8. 执行旧键静态扫描、Vendor 同步、UTF-8、PDF、生成物和 `git diff --check` 门禁。
- [x] M9. 在 Wolfram 首次加载时显示完整可点击引用块；Python 后端在协议元数据和直接 CLI
  模式提供同一引用内容，不污染 JSON stdout 合同。只引用 2401.00129、2411.03088 和
  MadStree 程序包论文；实际运行后逐字复核 URL。
- [x] M10. 删除 contact dlog 对 exponent `vertexSign` 的错误读取；纯 massive 与 massless
  contact 统一以 `contourSign` 为 SK 权重 authority。用论文两顶点 G++ 的三个完整 5x5 DE、
  contact leading vector、五个绝对边界系数和五维普通点值作 targeted 验收。

完成记录（2026-08-19）：`DLog.wl` 已物理删除错误的 exponent-sign contact helper；论文 G++
targeted validation fresh 通过 `16/16`，五维普通点最大相对差约 `2.71*^-28`、child ratio 为 `1`。
受影响开发回归为 core `56/56`、massive full edge `6/6`、massless edge `10/10`、mixed
three-vertex `8/8`。该修复使 022-v0.13 的 15x15 比较暴露 MadStree 自身 recurrence 与 dlog
不一致；脚本未执行 dSIBP contact producer，对后者的试探性修改也不改变结果，因此不能据此
给 dSIBP 定责。
- [x] M11. 统一 recurrence 与 dlog 的 contact phase。当前 `externalLegEnergy derivative +
  MSReduce` 对 `D[MSDLogDE,...]` 的差只在纯 massive lower-sector blocks；含一条 massless
  contact 的 block 已通过。把 DLog 中已由论文验证的 phase helper 移到 recurrence 唯一内部层，
  两路共同消费；增加不调用 dSIBP 的 `+/-` exact identity，再重跑跨包 15x15 至 `9/9`。

M11 实施要点：contact map 继续保存无外腿指数号的 R 矩阵；dlog phase 为纯 massive
`contourSign`、含 massless event 为 `(-1)^masslessCount`。recurrence correction 从同一 phase
唯一导出，只作用于 `msRemainingVector` 到 `M0/M1` recurrence 的消费边界。当前代数候选为每个
event 乘 `-contactPhase`，使单 massless event 保持 `+1`、纯 massive `+` 支翻转为 `-1`；必须先由
不调用 dSIBP 的 `+/-` exact identity 验证，未通过时回查推导而不改 expected。不得修改 contact
map、论文 potential、master order、normalization 或 H/h 变换。旧的 DLog-local helper 必须删除，
不得保留两套 phase authority。
- [x] M12. 修复 vertex-family `exponentType` 复用 `msVertexTypeSign` 的语义串线。v0.13 的
  `vertexType + -> -1` 只属于顶点外腿指数；额外 exponential block 仍应按字面代数号
  `exponentType + -> +1`、`- -> -1` 合并进 `effectiveExternalLegEnergy`。新增独立内部 helper，
  不保留错误映射或 fallback，并将 fresh `18/19` 回归恢复为 `19/19`。
- [x] M13. 处理 fresh 全回归中的正规化结构与边界数值失败。先隔离并行共享 runtime 后串行
  冷启动复跑；若 `test_ep_structure.wls` 仍返回 `VanishingComponentBoundaryEnergy`，检查 fixture
  是否违反当前非零边界能量合同，并检查 `MSEpsilonStructure -> MSAsymptoticBoundary` 对
  `Failure` 的传播。源码不得生成 `{Return[Failure[...]],...}` 后继续 `Lookup`。若
  `test_flintnde_boundary.wls` 的 `analyticAgreement` 仍失败，保存 primary 结果、解析值、误差和
  refinement，检查低阶 primary chain 的实际输出；不得以高阶 reference 值替代最终结果。
- [x] M14. 在中英文手册的加载章节补充与 Wolfram/Python 实际入口一致的引用提醒；两篇论文
  使用用户给出的精确 arXiv URL 和可点击链接，MadStree 程序包论文只写
  `arXiv identifier pending`。重编两份 PDF 后检查链接目标、中文渲染和英文排版。

M14 完成记录（2026-08-19）：中英文手册加载章节均已写入与实际 Wolfram/Python 入口一致的
引用提醒；2401.00129 和 2411.03088 使用指定可点击 URL，MadStree 程序包论文保留
`arXiv identifier pending`，不构造未提供的链接。两份 PDF 已重编并检查中文渲染、英文排版及
链接目标；对应的 headless/Notebook/CLI 加载证据登记在根进度表 S9 记录。

M13 验收标准：两个脚本都从空 `test/results_temp` 串行运行；正规化结构返回可用的 pole/order
metadata 且无 `Lookup::invrl`，或对物理上不允许的零能量输入返回单一、可诊断的 `Failure`；
boundary 恢复 `10/10`，报告低阶 primary 与解析值的误差，并保留高阶 reference 仅作精度核验。

M13 完成记录（2026-08-19）：三顶点 ep 结构测试改用实际 numeric vertex id 的
`RankOrder->{1,2,3}`，生产 `msGenericSectorLeadingRecord` 不再在 `Table` 内留下
`Return[Failure[...]]`；零 leading-energy 负例无消息返回单一
`VanishingComponentBoundaryEnergy`。有效路线为 9 master/9 branch，symbolic leading power 为
0，DE 负 valuation 数为 0。boundary 使用独立冷 runtime 恢复 `10/10`，低阶 primary 对
`Gamma[4/3]/(-3 I)^(4/3)` 的相对差约 `1.51*^-39`；高阶 reference 只用于误差核验。

M7 完成记录（2026-08-19）：v0.13 的开发回归、六个 examples、三项当前独立验证及 Vendor
FlintNDE `170/170` 均已从新路径 fresh 通过；随后物理删除未跟踪旧版本 `MadStree-v0.12`
（98 文件，2,528,713 bytes），并删除 v0.13 的 `results_temp`、隔离失败运行树、
`test/results_test`、example runtime 与 Python cache。当前 `versions/` 只保留 v0.13；正式独立
验证报告和轻量 `results/` 证据未删除。

M12 实施要点：只修改 `msNormalizeVertexFamilyExponentialBlock` 的符号 producer；不修改顶点
schema、tree `vertexSign/contourSign`、h blocks 或用户输入格式。验收对象固定为
`baseExternalLegEnergy=p0`、两个额外块 `+q1/-q2`，结果必须 exact 等于 `p0+q1-q2`。

M11/M12 完成记录（2026-08-19）：`Recurrence.wl` 现持有唯一 contact phase helper，DLog 与
recurrence 共用；无 dSIBP 的纯 massive `++/--` 5x5 外腿能量导数 exact identity 均通过，core
`58/58`。跨包 15x15 恢复 `9/9`，五个变量全部矩阵元差为零；massive `6/6`、massless
`10/10`、mixed `8/8`、simultaneous/cycle/chart `22/22`，论文 G++ fresh `16/16`。
独立 `msExponentTypeSign` 恢复 `p0+q1-q2`，vertex/reduce `19/19`、FlintNDE vertex-family
`8/8`。未修改 contact map、论文 potential、normalization、master order 或 H/h 变换。

### M9 实施要点

- Notebook 使用 `Hyperlink`；headless 与 Python 文本只给相同 arXiv 号和完整 URL。
- Wolfram 引用块只在 16 个模块及代表定义全部加载成功后显示，每个 kernel 一次。
- Python JSON 后端把引用清单写入响应 metadata，不向 stdout 打印；人工直接 CLI 才显示文本。
- 条目顺序固定为 2401.00129、2411.03088、MadStree 程序包论文；程序包论文暂写
  `arXiv identifier pending`，不构造未提供的链接或书目信息。
- 静态白名单扫描和 Wolfram/Python 实际输出都要逐字命中两个指定 URL，且不得出现
  2604.14549、AMFlow 或其它 arXiv 链接。

## 验收

- 用户拓扑中的旧 `energy` 缺少必需新键时必须失败，不能静默兼容。
- 两种 `vertexType` 的指数与导数符号和 dSIBP 022 一致。
- `vertexSign` 只进入外腿指数，`contourSign` 只进入 contact；`+` 顶点的两者分别为 `-1/+1`。
- 所有现行例子、正规化重建、多点输运与论文交叉验证结果不因纯命名重构改变。
- 当前源码、examples、tests 和现行文档不含旧公开键的读取或调用。

## 实施要点

1. `normalizeVertex` 只把 `id/externalLegEnergy/timePower/vertexType` 写入内部 vertex；
   `vertexSign` 是由 `vertexType` 派生的内部键。缺少 `externalLegEnergy` 时直接返回 schema
   failure，旧 `energy` 即使存在也不能补足。
2. Association 键顺序任意，额外键忽略。line 继续只读取当前公开字段并按输入顺序产生内部
   `lineIndex=1,2,...`；不新增公开 line id，也不读取用户给出的 id。
3. `Sectors/Boundary/DLog/TensorAtoms/VertexFamily` 及导出 metadata 中统一使用
   `externalLegEnergy`、`userExternalLegEnergy`、`baseExternalLegEnergy` 等明确命名；禁止同一
   context 同时保存 `energy` 与新键。
4. vertex-family 的紧凑 `ki` 模型仍把 `First[ki]` 解释为外腿指数参数，但规范化后只写入
   `externalLegEnergy`；显式模型只接受同名字段，不保留 `energy` fallback。
5. 加载检查在 16 个模块和代表性定义全部存在后才显示一次引用块。Notebook 使用
   `Hyperlink`，headless 使用完整 URL；JSON 后端只在返回对象的 `citationNotice` metadata
   写清单，直接 CLI 文本模式才打印。
6. 先运行 topology/schema/相位最小回归，再逐个 fresh 运行六个 examples、正规化和三个当前
   独立验证。v0.13 验收完成后才删除 v0.12，且现行 loader 只指向 v0.13。
