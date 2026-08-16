# MadStree v0.11 独立验证任务书

## 1. 对象与接口边界

验证 `versions/MadStree-v0.11/` 的当前单阶段公开数值接口：

```wl
MSEvaluatePath[context, pointSequence, FlintNDEPathPlanning -> True | False]
```

MadStree 只把连续用户点划分为最大复仿射单变量段并逐段拉回 dlog DE，不选择输运节点。
实际节点必须由返回的 FlintNDE `actualNodes` 证明。验证不得调用、引用或模拟冻结版本的旧路径接口。

## 2. 强制输入与共同参数

使用 massless full-edge 三主积分系统，取 exact 900 点：

- `k1 = -900 I + a/10`，`a=0,1,2`；
- `k2 = -30 I + n/10 + I m/10`，`n=0,...,99`，`m=0,1,2`；
- `q=1`、`a1=a2=1`；输入顺序为 `a/n/m`。

共同取 `BoundaryScale=15`、`RankOrder={v1,v2}`。此时通用边界曲线的阻尼基数为 30，
matching anchor 正好是 `k1=-900 I,k2=-30 I`。独立 exact 极点距离预审必须证明 Route B
每一步的 `step/nearest-pole-distance < 0.60`；正式报告记录预审最大值，并以 Route B 实际成功
执行和返回的完整节点链作黑盒复核。此配置只用于使既定 0.1 间距、a/n/m 点序可由严格用户
节点合同执行，不改变 A/B 之间的任何参数。

两条路线必须使用同一 context、点序、`BoundaryScale`、`BoundarySeriesOrder`、`RankOrder`、
工作精度、主阶、参考阶、目标误差、奇点模式、消息语言和 Python executable。每条路线各自从
空 runtime 启动，只调用一次 `MSEvaluatePath`，因此各自只产生一个 Python adapter 进程；禁止
跨路线复用 cache。边界成本不得从任一路线中扣除。runner 必须在数值计算前物理删除本任务
旧 `results/`、旧 `results_temp/` 和旧报告；运行根只允许是验证目录下的 `results_temp/`，
删除失败或发现仓库根旧 runtime 时立即停止，不提供旧路径兼容读取。

## 3. 两条路线

- Route A：`FlintNDEPathPlanning -> True`。FlintNDE 自动选择每段节点，按同一节点覆盖桶执行
  fast/iter dense multipoint；记录逐点 `evaluationAlgorithm`。必须核对同一 assignment bucket 的
  用户点被整批交给 FlintNDE；`fast` 必须对应 Vendor FlintNDE 的 FLINT
  `acb_poly.evaluate(..., algorithm="fast")` 子积树/余数树路线，而非 Wolfram 逐点求值。
- Route B：`FlintNDEPathPlanning -> False`。FlintNDE 严格把段内用户点按输入顺序作为节点；
  不允许 dense assignment，实际节点数和节点链必须与用户参数链一致。

## 4. 必须保存的证据

- commit、验证 runner SHA-256、MadStree 主入口 SHA-256、adapter SHA-256、Vendor FlintNDE 源码树 digest；
- 900 个 exact 物理坐标、master 顺序、normalization、Hankel branch 和 dlog convention；
- 两路线实际段数、每段物理起终点、userIndices、FlintNDE 参数节点链、节点数和覆盖统计；
- Route A 每个 assignment bucket 的覆盖数、算法和 userIndices，以及 fast bucket 的最小规模；
- Route A 的 fast/iter/node 算法计数，Route B 的 node/fast/iter 计数；
- 两路线各自的 boundary、planning、primary、reference、backend-only 和 end-to-end wall time；
- `cacheHit=False`、单次 Python command/exit code，以及 MadStree 返回结构中不存在节点规划产物；
- 全部 900 点、全部 master 的逐分量绝对/相对差及全局最大值；
- 两路线 refinement gate、逐段 refinement 估计和 certification mode。

## 5. 通过标准与交付

- 两路线都返回 900 个唯一用户点，三组固定 `k1` 的复平面各含 300 点；
- Route A 至少使用一次 `fast` multipoint；Route B fast/iter/dense 均为 0，用户点严格为节点；
- 全部 900 点全部 master 的相对差小于 `1e-15`，两路线 target gate 全部通过；
- A/B 各自产生一个 cold Python 进程，边界初始化各执行一次；
- 报告诚实给出性能结果，不预设自动规划一定更快；
- `run_validation.wls` 自动生成 `000_...report.md`、`results/summary.wl` 和完整轻量 JSON；
  完整逐点证据固定为 `results/evidence.json` 并随报告保留；全部文本 UTF-8 无 BOM。运行结束
  删除 `results_temp/`、cache 与 Python bytecode。

## 6. 验证 02：正规化角域与候选容量

验证目录固定为
`independent-validation/MadStree-v0.11-validation-02-ep-angle-capacity/`。本项验证当前
live v0.11 工作树中的 `MSReconstructEpSeries`、MadStree adapter 与内嵌 FlintNDE，不复用
validation-01 的结果，也不把当前 commit 当作未提交源码的完整身份；报告必须分别记录
`Kernel/MadStree.wl`、`Kernel/Numerics/PathEvaluation.wl`、adapter 和 Vendor
`regularization.py` 的 SHA-256。

验证使用 Example 06 同型的真实无质量三顶点、两传播子树图，公共时间幂取
`a1=a2=a3=1+ep`，并包含以下三条互相隔离的 fresh 路线：

- 默认 schema 探针：独立构造 `madstree_flintnde_ep_series_control_v1` 的
  `production_plan` JSON，不写 `sampleAngleRange`，用当前 adapter CLI 实际执行并确认默认
  请求键集合不含该字段、返回 `sampleSource="automatic"`。此路线只验证 producer/consumer
  schema，不代替真实程序包端到端计算。
- 显式角域路线：通过公共 `MSReconstructEpSeries` 设置
  `EpSampleAngleRange->{-Pi/3,Pi/3}`。生产点和验证点必须是 exact、互异、非零的 Gaussian
  rationals；所有生产点角度严格位于开区间，不得触碰端点；内部射线数最多为 3；
  `productionEpCandidateValues===Automatic`、`sampleSource="automatic-angle-range"`，且自动
  `baseSample/alphaEpsilon` 与同参数默认计划一致，以证明只约束角度而未改为用户指定模长。
- 候选耗尽路线：通过公共 `MSReconstructEpSeries` 给出恰能完成首轮拟合、但不足以达到独立
  验证精度的 exact 生产候选池和显式独立验证点。结果必须是
  `status="computed_with_warning"`，保留非空系数，`precisionTargetMet=False`，
  `precisionFailureReason="candidate_pool_exhausted"`，并证明生产点、验证点及全部实际 ep
  求值点均未越出用户给定集合。

本项通过标准：默认 schema、显式角域、候选耗尽、真实点求值、路径/refinement、源码身份、
fresh-clean 和 UTF-8/no-BOM 门禁全部通过。warning case 是本任务要求的成功行为，不得因
`precisionTargetMet=False` 被 runner 当作进程失败。`run_validation.wls` 必须自动生成
`000_MadStree-v0.11-validation-02-ep-angle-capacity-report.md`、`results/summary.wl` 和
`results/evidence.json`；结束时删除 `results_temp/`、adapter JSON、cache 与 Python bytecode。
