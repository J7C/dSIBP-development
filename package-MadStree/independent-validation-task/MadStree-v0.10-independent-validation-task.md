# MadStree v0.10 独立验证任务书

## 1. 验证对象与边界

验证当前 `versions/MadStree-v0.10/`，不新建版本号。验证对象是多变量用户点在
MadStree 侧按最大连续复仿射单变量平面分组、每组一次拉回 FlintNDE、以及用节点缓存
的局部解系数生成组内多个用户点值的完整两阶段流程。

本任务不构造多变量 Taylor 球。每组必须具有
\[
x(s)=x_0+s v,\qquad s\in\mathbb C,
\]
其中 `x` 是多变量坐标向量，`v` 是固定非零方向。不同组只在公共用户点继承数值向量，
不得共享 Taylor/Frobenius 系数。

## 2. 强制测试数据

取 exact 基点 `x1_0`、`x2_0`，生成 900 个二维复格点：

- `x1 = x1_0 + 0.1 a`，`a = 0,1,2`；
- `x2 = x2_0 + 0.1 n + 0.1 I m`，`n = 0,...,99`，`m = 0,1,2`；
- 输入顺序以 `a` 为外层、`n` 为中层、`m` 为内层，使不同 `n` 依次出现。

固定 `a` 的 300 个点都属于同一个 `x2` 复变量平面。验证程序必须确认它们没有按固定
`m` 拆成三条实直线。公共边界 anchor 与首个用户点不在同一个复仿射平面时，必须如实
保留独立的 boundary-anchor 到首点组；`a` 改变时允许插入只含公共端点和下一点的过渡组，
然后重新建立固定 `x1` 的 `x2` 复平面组。总组数必须按公共 `MSGeneratePath` 的实际输出
报告，不得用私有分组器的人工 anchor 结构替代。

## 3. 对比路线

路线 A 为现行分组规划：

1. 调用 `MSGeneratePath`，保存每个复仿射组的一份 FlintNDE `serializedPlan`。
2. 记录每个 `userIndex` 的 `node_snapshot` 或 dense sample assignment。
3. 调用 `MSEvaluatePlannedPath`，只执行保存计划。
4. 从节点 snapshot 或缓存局部系数合并出全部 900 个用户点值。

路线 B 为逐点基线：

1. 不做跨用户点的组内 dense-output 复用。
2. 严格按原始 900 点顺序逐点输运，每个点作为下一次输运终点。
3. 使用与路线 A 相同的 DE、边界、工作精度、主阶、参考阶和误差目标。

两条路线都从 cold cache 开始；不得用路线 A 的计划、局部系数或数值结果预热路线 B。

## 4. 必须记录的证据

- 源码 commit、MadStree 版本、两份 FlintNDE digest 和是否逐文件一致；
- 900 个 exact 用户坐标及实际输入顺序；
- 复仿射组数、每组 `userIndices`、方向和 exact 参数范围；
- 每组 FlintNDE 节点数、节点用户点数、dense 用户点数；
- 每节点覆盖用户点数的最小值、中位数、平均值、最大值和直方图；
- 路线 A 的规划、执行和总 wall time；
- 路线 B 的逐点规划/执行和总 wall time；
- 全部 900 点逐分量绝对误差与相对误差，以及其最大值；
- 至少 12 个覆盖不同 `a,n,m` 的抽样点用更高阶重新计算；
- `targetRelativeErrorMet`、refinement 估计和任何认证升级；
- 执行期规划器哨兵结果，确认 `MSEvaluatePlannedPath` 不调用路径规划器；
- 缺省 `SingularityMode -> "Avoid"` 和 `MessageLanguage -> "EN"` 的实际记录。

性能结论必须照实报告，不预设路线 A 一定更快。若路线 A 未加速，仍保留节点覆盖率、
耗时分解和瓶颈证据。

## 5. 通过标准

- 固定每个 `x1` 的 300 个复数 `x2` 点各自形成一个复仿射单变量平面组；
- 所有 900 个 `userIndex` 恰好返回一个值，节点点和 dense 点都不遗漏；
- 至少一个 FlintNDE 节点覆盖 3 到 10 个用户点；若实际几何无法达到，应记录真实分布及原因，
  不得通过调整统计口径伪造；
- 两路线的 900 点结果均满足共同 refinement 阈值；
- 更高阶抽样复核不显示系统性漂移；
- 执行期规划器哨兵未触发；
- 不同复仿射组没有共享局部系数；
- 结果与报告符合 `package-MadStree/AGENTS.md` 的独立验证报告合同。

## 6. 交付物

在 `package-MadStree/independent-validation/` 下新建符合项目规则的验证目录，包含：

- `run_validation.wls`；
- `000_MadStree-v0.10-validation-NN-...-report.md`；
- `results/summary.wl`；
- 支撑结论的轻量误差、计时和覆盖率数据。

运行 JSON、日志、cache、逐点中间值和 checkpoint 只能进入该验证目录的
`results_temp/`，不得写入 package 源码目录。
