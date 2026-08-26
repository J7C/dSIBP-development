# MadStree v0.16 当前任务清单

## 2026-08-25 v0.16 massive contact 边界与八分支独立检验

- [x] V1. 更新根研究计划，建立 v0.16 版本骨架、开发计划和本清单；不复制 cache、runtime、
  `results` 或重复历史计划文档。
- [x] V2. 将公开版本、loader、索引、README、更新说明、任务书和 validation 名称统一升到
  v0.16；不保留 v0.15 路径转发、别名、wrapper 或 schema fallback。
- [x] V3. 固化通用 boundary coefficient 删除 `I^contractedMassiveCount` 的修复；保持 sector
  normalization、contact recurrence、master 顺序和 dlog DE exact 不变。
- [x] V4. 更新中英文手册与说明：程序按 `J_s=calN_s I_s` 和 2411.03088 Eq. (4.2) 的定义积分
  取边界；Eq. (4.11) 相对直接积分多 `I`，只保留为论文印刷式诊断。
- [x] V5. 完成两顶点 single-pinch、三顶点 double-pinch exact 回归，并增加恢复旧 `I^n` 后
  必须失败的 counterfactual。
- [x] V6. 查明 arXiv:2309.10849v2 的覆盖边界：Eq. (83) 定义八个 SK 分支，Eqs. (148)--(151)
  明列四个独立分支，Eq. (103) 给出八支总和；论文没有单支闭式，不能把总和外推为单支 oracle。
- [x] V7. 重写 Validation-07：V5.5 与 MadStree 均直接计算全部八支，分别冻结 master、
  normalization、完整 `25x25` DE 和全部边界 branch，随后把各自 DE+边界送入同一 FlintNDE。
- [x] V8. 先将 V5.5 八支按论文 convention 组合并与 arXiv:2309.10849v2 Eq. (103) 比较；只有
  总和通过后，才把该批 V5.5 八支作为 MadStree 逐支外部参考。八支均保存低阶生产结果、高阶
  refinement、实际路径/节点、wall time、逐分量差与联合误差预算；任一支未执行时整体失败。
- [x] V8a. 在 MadStree 与 dSIBP 独立任务资料目录整理原论文和勘误：文件名分别为
  `{arxiv号}-{标题}.pdf` 与 `{arxiv号}-勘误.md`，校验 PDF 完整性/SHA-256，并在任务书列明
  每个文件实际对应的公式或章节编号。
- [x] V8b. 扫描两包独立任务书、runner、报告模板、正式报告与 reference 说明；论文只按 arXiv
  号称呼，不出现作者名。原始 PDF 和程序包既定用户引用区不改写。
- [x] V8c. 从空目录重跑 massive-contact exact 专项与 Validation-04，分别通过 `6/6`、`26/26`；
  Validation-04 把中文勘误文件的存在性与 SHA-256 纳入 fail-closed 门禁。
- [x] V8d. Validation-07 先认证原始 V5.5 八支总和：相对 arXiv:2309.10849v2 Eq. (103) 的差
  `4.8809132147*^-31` 小于联合预算 `9.7579053206*^-30`；补
  `Exp[Pi Im[nu]]` 的反事实差 `2.0701905924*^-24`，超过预算并被否决。以原始 V5.5 八支
  作为逐支 reference，完成 MadStree 八支后再生成正式报告。
- [x] V8e. 修复首轮 fresh `18/21` 暴露的共同阶 normalization 重复：从 massive
  `pinchNormalization` 删除 `Exp[Pi Im[formulaNu]]`，并在论文附件/手册中区分 2411.03088
  Eq. (4.2) 的 paper endpoint basis 与 MadStree 共同 Hankel 阶 basis。
- [x] V8f. 删除纯 massive contact 的额外 contour-sign helper；normalized master DE 只保留
  有符号能量、链式因子和最终 SK branch 权重。以 `+--/--+/---` 五变量 `25x25` exact 首差值
  全部归零为验收，不用内部 recurrence/dlog 同源 identity 替代外部 V5.5。
- [x] V8g. 修复 `--` full line 收缩后的 child master normalization：massive
  `pinchNormalization` 乘一次 `fullContourSign`，使 `++/--` 分别为 `-4 I/Pi`、`+4 I/Pi`
  （省略共同的 momentum 幂）。该符号只属于 sector normalization，不得重新加入 dlog contact
  block 或 recurrence event。增加 `++/--` exact 回归，并 fresh 重跑八支普通点比较。
- [x] V9. fresh 删除并重跑受影响开发回归、examples、Validation-04 和 Validation-07；报告和
  `summary.wl` 自动生成，reference 原件只读，隔离副本和 cache 只进 `results_temp/`。
- [x] V10. 重编中英文手册并目视检查受影响页；完成旧入口、旧版本字符串、孤立定义、Python AST、
  Wolfram DownValues/caller 和兼容分支专项审计。
- [x] V11. v0.16 验收后删除 v0.15 源码、旧任务书和被新版取代的 validation；清理生成物并执行
  UTF-8、Wolfram 分节、进程、Vendor hash、`git diff --check` 与 Git 状态门禁。

完成记录（2026-08-26）：Validation-04 `26/26`、Validation-07 `21/21`；八支乘五变量的
40 个 `25x25` DE 全部 exact 相等，八支普通点最大 vector residual 约 `6.49*^-21`。
独立/Vendor FlintNDE 各 `181/181`，MadStree adapter `17/17`，42 个共同运行时代码文件
SHA-256 一致；全仓 513 个当前文本严格 UTF-8，适用的 Wolfram 实现/验证脚本分节、作者名、
生成物、进程和 `git diff --check` 门禁通过。

## 2026-08-25 末端奇点 affine 斜率修复

- [x] F1. 局部有理系统按 `beta R/(alpha+beta s)` 重建每条 dlog record。
- [x] F2. 增加 `beta != 1`、同 pole 缩放 letter 合并和末端奇点分类回归。
- [x] F3. 运行 adapter 完整测试，更新中英文更新说明与审计报告并完成清理门禁。

完成记录：adapter 完整回归 `17/17`；两条缩放等价 records 合并为一个 pole、总留数为 3，
局部/普通系统在三个样点严格一致。未修改普通输运或独立 FlintNDE。

## 2026-08-21 通用奇点分类与 massive 三顶点零中间外腿点列

- [x] G1. 在独立 FlintNDE 增加非零复奇点、其它有限奇点共存的可去/真实分类回归，证明
  目标位置和变量名称不参与物理分类；通过后逐文件同步 MadStree Vendor。
- [x] G2. 保留 Example 05 原有 `pointSequence` 和数值调用；另建中间顶点 `k2=0` 的
  `zeroMiddleEnergyPointSequence`、独立调用和独立导出，不合并两组规划或结果。
- [x] G3. Example 05 检查零中间外腿各用户点全部计算成功，并保存/显示完整
  `singularityClassifications`；若实际没有零 letter，该表必须为空，不能因坐标值为零误报。
- [x] G4. 同步中英文 README 与两份手册的典型例子说明，记录两组点列职责和零坐标不等于
  DE 奇点的判据。
- [x] G5. 清空受影响运行目录后，提权串行运行独立 FlintNDE 专项、Vendor 专项和 Example 05；
  重编/检查手册，清理 cache 与可重跑结果，并执行 UTF-8、Vendor hash、`git diff --check`。

完成记录（2026-08-21）：独立 FlintNDE 与 Vendor 的 `test_singular_targets` 均为 `7/7`，
同名测试 SHA-256 一致。Example 05 从空的 `results/`、`results_temp/` 提权串行运行并退出
`0`；原点列与 `k2=0` 四点列分别规划、求值和导出。新增组有 25 个主积分，四点均
`saved`，主/参考相对差均约 `2.3007194469693847e-31`，完整 letters 无零值且
`singularityClassifications` 为空。中英文手册及 FlintNDE 手册已重编并检查新增页。

## 2026-08-21 奇点用户点局部路线

- [x] S1. 中间奇点交给 FlintNDE 局部 bucket；精确奇点不作为普通节点，收敛域内前后用户点由同一局部基求值，并从出射普通点继续。
- [ ] S2. 末端奇点不再直接使用可能位于局部收敛圆外的最后一个用户点；消费 FlintNDE 生成的隐藏普通匹配点并先输运到该点。
- [ ] S3. 末端奇点分别用低阶主链和高阶参考链求值；低阶值进入用户结果，高阶只检查分类一致性和有限值相对误差。
- [ ] S4. 更新中英文 README/手册、Example 07、任务书和独立报告；从空结果目录 fresh 重跑全部受影响验证。

## 2026-08-21 参数规则与点序列表数值接口

- [x] N1. 建立 v0.16 并同步版本目录、loader、索引、任务书和更新说明。
- [x] N2. 将 `pointSequence` 改为首行坐标符号、后续等宽值行的唯一数值点 schema；单点只含
  一行值，临时点写作 `{{values...},"tmp"}`。
- [x] N3. 新增一次性 `ParameterRules`，与表头互斥并在 Python/NDE 启动前检查完整性和数值性。
- [x] N4. 让正规化重建复用同一接口；允许 regulator 出现在 `ParameterRules` 右端，禁止路径
  坐标依赖 regulator。
- [x] N5. 保证 `MSDLogDE` 与 `dlog_de.wl` 始终保持解析；数值阶段只使用函数内参数化副本。
- [x] N6. 重做六个 examples、开发测试、中英文 README/手册并从空输出目录 fresh 验收。
- [x] N7. 清理旧版本、旧任务书、旧验证产物、runtime/cache/TeX 中间物，执行 UTF-8、PDF、
  旧 schema 扫描和 `git diff --check`。

## 2026-08-21 统一点序列与单顶点函数族例子

- [x] P1. 明确单点和多点共用 `MSEvaluatePath[context,pointSequence]`；v0.16 的单点是同一
  坐标表只有一行值，不新增单点入口或第二返回格式。
- [x] P2. 将 Example 02 整理为单顶点函数族完整例子，展示紧凑/显式初始化、公式/约化及
  单行/多行坐标表的同一数值调用，并互检共同首点。
- [x] P3. 在中英文 README 与手册说明单顶点 schema 和树拓扑 schema 的职责差异，同时声明
  两类 context 共用同一个数值入口、选项和返回结构。
- [x] P4. 在中英文手册新增典型使用例子章节，覆盖单顶点函数族、树图多点和正规化拟合。
- [x] P5. fresh 运行 Example 02、vertex-family/path 回归，重编并检查两本 PDF，执行 UTF-8、
  临时产物和 `git diff --check` 门禁。

## 范围

以下是 v0.13 已完成并由 v0.16 继承的拓扑合同：tensor formula、sector DAG、dlog DE、
FlintNDE 输运和正规化算法保持；顶点指数参数只使用 `externalLegEnergy`，不保留 `energy`
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
- [x] M7. 验收后删除 v0.12 目录和旧版本验证资产；清空中间产物后只从 v0.16 路径 fresh 重跑。
- [ ] M8. 执行旧键静态扫描、Vendor 同步、UTF-8、PDF、生成物和 `git diff --check` 门禁。
- [ ] M8a. 修复独立验证 runner 在 Windows `wolframscript -file` 单字节源解码环境下把中文
  报告二次编码为 UTF-8 的问题；正确解码环境不得重复转换，修复后从空 `results/` 重跑并
  检查报告原始字节、中文正文和 summary/report 的 fresh 修改时间。
- [x] M9. 在 Wolfram 首次加载时显示完整可点击引用块；Python 后端在协议元数据和直接 CLI
  模式提供同一引用内容，不污染 JSON stdout 合同。只引用 2401.00129、2411.03088 和
  MadStree 程序包论文；实际运行后逐字复核 URL。
- [x] M10. 删除 contact dlog 对 exponent `vertexSign` 的错误读取；纯 massive 与 massless
  contact 统一以 `contourSign` 为 SK 权重 authority。用论文两顶点 G++ 的三个完整 5x5 DE、
  contact leading vector、五个绝对边界系数和五维普通点值作 targeted 验收。

完成记录（2026-08-19）：`DLog.wl` 已物理删除错误的 exponent-sign contact helper；论文 G++
targeted validation fresh 通过 `16/16`，五维普通点最大相对差约 `2.71*^-28`、child ratio 为 `1`。
受影响开发回归为 core `56/56`、massive full edge `6/6`、massless edge `10/10`、mixed
three-vertex `8/8`。该修复使 022-v0.16 的 15x15 比较暴露 MadStree 自身 recurrence 与 dlog
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
- [x] M12. 修复 vertex-family `exponentType` 复用 `msVertexTypeSign` 的语义串线。v0.16 的
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

M7 完成记录（2026-08-19）：v0.16 的开发回归、六个 examples、三项当前独立验证及 Vendor
FlintNDE `170/170` 均已从新路径 fresh 通过；随后物理删除未跟踪旧版本 `MadStree-v0.12`
（98 文件，2,528,713 bytes），并删除 v0.16 的 `results_temp`、隔离失败运行树、
`test/results_test`、example runtime 与 Python cache。当前 `versions/` 只保留 v0.16；正式独立
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

## M15：最新版冗余审计修复

- [x] 删除正式 Kernel 中无生产/测试 caller 的单顶点 Frobenius 特殊路线，不移动为假 oracle。
- [x] 删除五个无消费者私有定义，不增加兼容入口。
- [x] 与独立 FlintNDE 同步 Vendor 清理，并核对三个变更 Python 文件逐一同 hash。
- [x] 运行 core、generic boundary、artifact、Backend 和 Vendor 全量 Python 回归。

M15 完成记录（2026-08-19）：保留 generic boundary 实际调用的端点系数函数；退休路线四个
符号及五个孤立定义在当前 Kernel/Backend 中均归零。回归结果为 `58/58`、`10/10`、`18/18`、
`11/11` 和 `170/170`。

## M16：normalized master 与裸指标积分的公开对应（已完成）

### 接口设计

- [x] 保持现有记号 `J_s(n;a)=MSIntegral[sectorKey,aShifts,stateBits]`；`s`、`n`、`a`
  已分别完整标识 sector、component shifts 和 slot states，不新增另一套指标。
- [x] 用惰性 `MSBareIntegral[s,n,a]` 只表示同指标的裸积分 `I_s(n;a)`；它不参与约化或输运。
- [x] 新增唯一查询入口 `MSIntegralDefinition[integral,context]`，返回显式
  `normalization -> calN_s` 和 `J_s(n;a)=calN_s I_s(n;a)`；非法指标复用 `msIntegralData`。
- [x] 既有 `MSMasterIntegrals` 的 record 直接加入同源定义；不新增重复 bulk API，不改变
  `integral` 字段及 master identity/order。

### 手册定义

- [x] 沿用 `J_s(n;a)=calN_s I_s(n;a)`；normalization 只写作 `calN_s`，二态因子数量统一
  改记为 `n_s^(slot)`。同时修正边界权重一节把 normalization 误写成普通 `N_s` 的符号 typo。
- [x] 手册一次性定义 `I_s(n;a)` 的 measure、时间幂、外腿指数与 slot building blocks；
  massless shared quotient 保持共享二态，`++/--` h 组合不在逐 master 输出中展开。
- [x] README 只给一个列全部 masters 和一个查询单积分的短例子。

### 验收

- [x] 两顶点 massive `G++` 五个 masters 保持同序：top 给 `calN_s=1`，child 给 context 中
  exact prefactor；合法 shifts/state bits 原样保留，非法指标 fail closed。
- [x] massless quotient 与 `RedundantH` 各检查一个定义；definition、sector、master record 和
  dlog normalization gauge 使用同一 normalization authority。
- [x] master order/digest、recurrence、contact phase、DE 和 boundary 在改动前后 exact 不变。
- [x] 更新 `MadStree.wl` usage/API coverage、UPDATE_NOTES、中英文 README、两份 TeX 手册和
  一个现行 example；运行 targeted/core/artifact 回归，重编并目视检查两份 PDF，最后清理
  `results_test`、TeX 中间物与 cache，执行 UTF-8 和 `git diff --check`。

M16 完成记录（2026-08-20）：专项、core、package artifact 分别通过 `17/17`、`58/58`、
`18/18`；Example 05 从空输出目录运行，exit code 为 `0`。中英文 PDF 重编为 31/32 页，
日志无 fatal error、undefined reference/citation 或 overfull box，受影响页面目视正常；14 个
本轮文本文件严格 UTF-8 解码通过，普通 `N_s` 旧歧义扫描为空。运行产物、cache、TeX 中间
文件和 PDF 渲染文件清理后，`git diff --check` 通过。

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
   独立验证。v0.16 验收完成后才删除 v0.12，且现行 loader 只指向 v0.16。
# 解析公式先落盘补充门禁

- [x] 在 `MSEvaluatePath` 与 `MSReconstructEpSeries` 启动任何数值 NDE 前强制保存完整解析公式。
- [x] 同一 context 与调用根复用有效公式资产；文件缺失时重建，写出失败时 fail closed。
- [x] 数值返回值携带公式目录和文件路径；固定参数只作用于函数局部 DE 副本。
- [x] 同步 README、手册、examples、更新说明与测试计数。
- [x] fresh 运行受影响测试与 examples，重建并检查 PDF，清理全部生成物后执行最终门禁。

完成记录：formula artifact `24/24`、point/planning `27/27`、core `58/58`、runtime/export
`10/10`；六个 examples 独立冷启动全部退出 `0`，Example 06 为 `16/16`。中英文 PDF 均为
33 页且受影响页渲染通过；最终生成物、UTF-8 与 Git 门禁见根进度表同任务记录。
