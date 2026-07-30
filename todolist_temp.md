# dS IBP Package 当前待办

更新日期：2026-07-30。

## P0 根目录组件说明与 GitHub 发布

- [x] 在根 README 统一说明 dSIBP 018.1、MadStree v0.3 与 FlintNDE 的职责、入口、依赖方向和验证状态。
- [x] 在根 AGENTS 登记跨组件规则、子目录 authority、调用目录输出与 fail-closed 边界。
- [x] 忽略 Python cache、`pyc` 和各组件开发 `test/results_test/`，保留 MadStree 独立验证的轻量 `results/summary.wl`。
- [x] 检查全部非忽略待提交资产、远端分歧和格式门禁；主发布提交 `304e4ba` 已推送到 `origin/main`。

## P0 MadStree v0.3 T1/T3 与独立验证归档

- [x] 在 package 初始化中加入固定的 `masslessRepresentation -> "Quotient"|"RedundantH"`，两种表示都直接产生递推、contact 与 dlog；开发检查 `42/42`。
- [x] 在独立验证任务书先冻结三顶点 mixed T1 的完整函数族、共同正规化、sector-wise 四态/二态映射和一阶 shift。
- [x] 重写并执行 T1，`20/20`；已自动保存 exact residual、数值路径、展开阶数、耗时、summary 与 `000_` 报告。
- [x] 盘点既有功能测试，按独立验证对象补任务书、版本化目录、独立程序和自动报告，不复用开发 expected。
- [x] 完成 T3 的 contact basis map、五维数值比较和自动报告；fresh `18/18`。
- [x] 同步 README、DEVELOPMENT_PLAN、tree formula、进度表与目录索引；受影响回归、27 页手册重编译与重点页目检均通过。
- [x] 新建并执行 T4：单顶点函数族、低阶 MSReduce、正负 NuConvention 的 H/h 局部与全 sector round trip；`15/15`。
- [x] 新建并执行 T5：simultaneous contact、time-only 圈图 canonicalization、全部 strict rank chart 的 normal-crossing 证书；`17/17`。
- [x] 新建并执行 T6：MadStree--FlintNDE 普通点与正则奇点调用、无名 save 标签逐点落盘、调用目录归属和超能力奇点 fail closed；`16/16`。

## P0 MadStree v0.3 目录整理

- [x] 建立 `versions/MadStree-v0.3/`、版本索引与当前版本加载入口。
- [x] 将独立验证任务书单列；T1--T6 各建一个名称含 v0.3 的验证目录。
- [x] 验证程序自动生成 `000_...report.md`，正式结果进本任务 `results/`，中间文件进调用目录 `results_temp/`。
- [x] 修正 FlintNDE 相对路径、Python cache 与临时 JSON 输出位置。
- [x] 更新文档并 fresh 重跑迁移后的 T1--T3。

## P0 MadStree 生产边界架构纠正

- [x] 删除生产 `Kernel/` 内有限 Euclidean 定义积分、闭式 chamber 和 `NIntegrate` 边界路线；测试定义积分迁入 `package-MadStree/test/DirectBoundaryOracle.wl`。
- [x] 实现 2411.03088 单顶点 $k_0\to\infty$ Frobenius leading coefficients、总次数级数和 MadStree master-order 映射；T2 `12/12`。
- [x] 实现两顶点 contact sector indicial leading system，接通 `MSBoundaryData`。
- [x] 让 `MSEvaluateTree`/`MSEvaluateVertexFamily` 从无穷远奇点调用 FlintNDE，并在有限匹配点继续普通输运；任何不支持情形 fail closed，禁止 direct-integration fallback。
- [x] 删除两顶点自写 bivariate Frobenius recurrence；输出一参数 blow-up 的 exact 奇点系统与规范化 `{a,b,C}` 分支，直接调用 FlintNDE 奇点模块，物理系数在 MadStree 侧组合。
- [x] 更新生产/测试边界文档，运行边界专项后再执行 T1--T3，分别记录功能验收与测试验收。
- [x] 校正并写入完整 mode 的 $d,m_{\rm eff},\nu$ 晚时幂次与 IBP 端点项讨论，明确适用条件及其与递推奇异层的区别。

## P0 MadStree 三项待执行独立验收

- [x] 建立 `package-MadStree/test/TEST_PLAN.md`，登记无质量冗余四态/quotient 二态、2411 单顶点三 massive、2411 两顶点 `G++` 三项测试及共同 fail-closed 门禁。
- [x] 实现冗余四态 Hankel 验证 producer 后执行三顶点 mixed T1；`20/20`。
- [x] T2/T3 均显式 `NuConvention -> "Negative"` fresh 通过 `12/12`、`18/18`。

## P0 MadStree 通用边界与 contact 闭合

- [x] 审计当前 `000_FlintNDE` 的 Lee--Moser/Fuchsian 与不规则/Stokes 实现；加入全非普通点 preflight 后通过 `68/68`。
- [x] 实现 nested blow-up、theta 固化与全 sector normal-crossing 证书。
- [x] 实现共同-theta multi-edge simultaneous contact canonicalization。
- [x] 实现 time-only 圈图初始化与 contact sector canonicalization。
- [x] 实现 shifted `R^(1)` child reduction 后的 dlog block 组装。
- [x] 让 FlintNDE preflight 覆盖全部非普通路径点，并对非 $\mathbb Q(i)$ 正则奇点和不支持的 exact Frobenius 谱 fail closed。
- [x] 增加专项测试、更新文档、编译并目检 tree formula 与 FlintNDE 手册；MadStree `115/115`、FlintNDE `68/68`。

## P0 massless top-to-sub dlog 与约化定义域纠正

- [x] 用 2401 二进制字串 notation 重写 `MSReduce` 的合法输入域，不再称“任意积分”。
- [x] 推导 massive/massless contact 的 `R` 项及 spectator massless quotient 对 top-to-sub 块的投影求和。
- [x] 更新 tree formula、README、开发规划与进度记录，编译和目检手册。

## P0 NDE save-point 与 MadStree 单顶点/递推接口

- [x] 实现 FlintNDE 路径点 `save` 标签、逐点文件与调用目录汇总文件。
- [x] 增加普通点、奇点 save-point 测试并更新 FlintNDE 文档；Wolfram 输入只允许 `{coordinate,"save"}`，不为保存点命名。
- [x] 实现 MadStree 单顶点函数族专用初始化入口及与 topology 入口的符号/数值 NDE 等价检查。
- [x] 复核/编码 massive、massless shared `2x2` 局部对角化求逆，禁止通用大矩阵求逆。
- [x] 扩展 `MSReduce` 到固定 context 合法积分的有限线性组合和可指定完整 master 排列。
- [x] 验证并公开 H/Hankel 与 h 的局部/全 sector 正反变换。
- [x] 更新 FlintNDE/MadStree README、规划、公式手册及原 dSIBP 隔离状态说明。
- [x] 当前完成 Python `68/68`、Wolfram `115/115` 回归；旧计数只保留在进度历史。

## P0 MadStree 自动边界与 FlintNDE 接口（有限 anchor 路线已撤销）

- [x] 读清 `000_FlintNDE` 的公开输入、普通点/奇点路由、输运与输出合同，冻结相对路径和序列化设计。
- [x] 实现 MadStree 集中路径配置、普通点路径和 FlintNDE 薄适配层；原自动有限 Euclidean producer 现仅保留为待迁移的历史实现，不再属于生产能力。
- [x] 既有 representative tree 的有限点定义积分对照只作为历史测试证据，不再认证生产边界架构。
- [x] 实现 2411.03088 单顶点与两顶点单 massive `G++` 的无穷远 Frobenius/sector-leading system；有限普通点定义积分只在独立验证中作为 oracle。
- [x] 推广通用多 sector 的 2411 无穷远 Frobenius producer；按 sector metadata、strict-rank chart 与 ancestor residue 组装边界，超出已认证谱型时结构化 fail closed。
- [x] 更新 MadStree 规划、README、公式手册、可执行 example 与研究进度，编译并检查 PDF。

本文件只列仍需执行的工作。已完成过程、历史计数和取消路线统一留在 `研究计划与研究进度.md` 的归档区；这里不再重复旧 016/017、全 family、全 sign/parity 或 sunrise reduction 记录。

## P0 当前整理与正式发布

- [ ] 新建 dSIBP 020，把 time-only 公开积分改为 metadata 驱动的 `J[sectorKey,timeShifts,stateBits]`；内部复用旧三参数 producer，所有 seed/关系/linearData/`ds`/derivative 输出经统一边界转换，full 模式不变。
- [ ] 为 020 增加全 sector round trip、旧表示拒绝、massive/massless/simultaneous contact、lower-sector `ds` 和 mixed 三顶点跨包 DE 检验；只重跑 time-only 受影响范围。

- [ ] 修正 dSIBP 019 time-only key：移除跨 mode 旧 key 兼容，只在显式 full-loop 分支保留 legacy key，并重建/复验 019.0。
- [x] 新建 MadStree v0.5，内置 FlintNDE、标准化 package 初始化与调用目录输出，生成全 sector 约化 metadata/dlog DE/masters 和可选 `a_i` 代入；阶段接口 smoke `16/16`，全量验证另列。
- [x] 调用 dSIBP 已有 time-only 外动量求导算符，接 MadStree 表示转换与迭代约化，并与直接 dlog 公式在 mixed 三顶点数值点逐项比较；MadStree 不新增求导实现。
- [x] 修复 time-only `ds` 在 public key 逆转换后重新推断 lower-sector prefactor而丢失动量幂的问题；改读冻结 sector metadata，并增加非零 `D Log[N_s]` 回归。
- [x] 把 MadStree dlog contact 的统一负号改为 event phase：pure massive 读取 component `phaseSign`，含 masslessFull 的 event 使用 `(-1)^N0`；同时通过 2401 Eq. (3.68)、正负 massless 定义积分、三边 simultaneous 与 dSIBP 跨包参考。
- [x] 处理 dSIBP 019 的真实表示缺口：冻结 019，另建 020 原生 `J[sectorKey,timeShifts,stateBits]` public boundary；跨包 DE 已只对 020 认证并严格零差。
- [x] fresh 重跑 MadStree v0.5 全部开发 tests、examples 与 T1--T6 独立验证；报告、summary、29 页手册编译目检、索引/README 更新和临时产物清理均已完成。
- [x] 完成 dSIBP 019.0 与 MadStree v0.4 的第一轮 time-only sector 定长位串实现；该轮验证事实保留，但旧 key 兼容设计由上方当前任务取代。

- [x] 完成本轮全项目文档残留扫描、TeX 基本检查和临时目录清理，并把最终结果写回 `研究计划与研究进度.md`。
- [x] 从当前 `000_code/018_dSIBP/` 模块重建并发布 source-identical 的 `package_018.1.wl/pdf`；候选与正式路径的受影响检查、hash 和手册渲染均已记录。
- [ ] 在干净的根目录 `check/` 中按 `independent-benchmark/independent-benchmark.md` 从零完成 source-isolated 独立 benchmark；不得读取 `check-smoke/`、旧 expected 或旧 reduction 结果。
- [ ] 为 `03_single_massive_sunrise/` 单独执行纯数值 DE/scaling 验证：从现有 general seeds/operators 建立 fixed exact rational point 的 sampled relations，经外部 Kira reduction、`DSKiraImport -> DSDE -> DSScaleCheck` 闭环；当前 example 和旧报告均不构成这项验证。

## P1 接口与排序

- [x] 支持用户指定 `userMI` 优先 basis，并保存用户 basis、backend basis 与物理积分之间的可逆映射。
- [x] 让 serializer 显式消费调用方提供的 `integralList` 顺序；禁止在未声明的情况下重新排序或改变编号。

## P2 已知设计项

- [ ] 完成 massless-tree quotient、iterative reduction 与 dlog 表示的同 basis 重新推导；在推导完成前保持现有数学边界 fail closed。
- [ ] 设计可选 symmetry-rule ordering helper：把用户给出的未定向等价关系按缺省复杂度与稳定字典序定向到唯一 canonical representative。当前用户仍须提供已排序的单向规则。

## 固定边界

- `03_single_massive_sunrise/` 只做 general IBP seeds 和 `{ss11,kE}` general 参数微分算符；不撒点，不生成 `linearData`，不进入 Kira、master、DE 或 scaling。
- `04_pure_massive_bubble_closed_loop/` 长期保留 reference/dlog 及 19-master DE/scaling 完整闭环。
- `06_mix_bubble_tree/` 长期保留 mixed cycle/bridge 复合流程。
- package 只生成和序列化关系，不运行 reduction；需要 reduction 的正式验证由外部 Kira 流程完成。
# package-MadStree 公式型树图程序包（2026-07-27）

- [x] 盘点 tree 公式、参考 code、018 time-only/sector/H-h 变换的数据流；详细规划见 `package-MadStree/DEVELOPMENT_PLAN.md`。
- [x] 建立独立目录与模块职责，迁移 tree formula note。
- [x] 实现最小 topology/sector 初始化和原生 time-only 表示。
- [x] 实现 H/h 状态向量与 legacy massive time-only 的可逆子集；积分对象级 H/Hankel family 换基保持 fail closed。
- [x] 实现 Kronecker 原子、共享 massless slot、迭代约化与 dlog DE。
- [x] 建立精确 test，编译手册并更新进度结论。
- [x] 清除 MadStree 中带正负号或论文专用下标的 $h$ 记号；测试参数统一写作 `nu`，重跑检查并重新编译手册。
- [x] 把 `NuConvention` 冻结为 context 初始化属性，移除全 sector 换基的逐调用覆盖入口并复验。
- [x] 清理本轮 `results_test/` 渲染图片、TeX 中间文件和迁移后空目录；完成 scoped diff 检查。
- [x] dSIBP 020：建立 `J[sectorKey,timeShifts,stateBits]` 与内部三槽 `J` 的中央双向转换，并完成首轮 mixed 三顶点 smoke。
- [x] dSIBP 020：接通 tree 公式公开入口及 `rep2innerform/rep2outform/rep2Integrand/symmetry`。
- [x] dSIBP 020：确认 `DSDE`/`DSScaleCheck` 只消费 KiraImport reduction artifact，不属于本次 time-only tree 边界；未修改、未重跑 full/Kira/reduction/scaling。
- [x] dSIBP 020：扩展 reachable-sector、simultaneous contact、massive/massless 状态与 lower-sector `ds` 检查。
- [x] MadStree v0.5：令零传播子 family 的 width-zero `sectorKey` 显式等于字符串 `""`，并 fresh 复验边界检查 `9/9`、无 Wolfram 初始化消息。
- [x] dSIBP 020：检查候选手册最终日志及封面、time-only 表示页和末页渲染。
- [x] dSIBP 020：在提权 Wolfram 中完成候选路径 public representation、tree formula、example 05 与 API/example coverage 检查。
- [x] dSIBP 020：记录候选哈希，以完全相同字节晋升 WL/PDF/更新说明，并从正式路径复验。
- [x] dSIBP 020：active 文档已更新，候选临时产物已清理，Git 格式、状态、忽略项和 fetch 后远端分歧检查通过。
- [ ] 提交并推送 dSIBP 020、MadStree v0.5 及对应文档/独立验证资产，随后登记发布提交。
