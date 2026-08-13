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
跨路线复用 cache。边界成本不得从任一路线中扣除。

## 3. 两条路线

- Route A：`FlintNDEPathPlanning -> True`。FlintNDE 自动选择每段节点，按同一节点覆盖桶执行
  fast/iter dense multipoint；记录逐点 `evaluationAlgorithm`。必须核对同一 assignment bucket 的
  用户点被整批交给 FlintNDE；`fast` 必须对应 Vendor FlintNDE 的 FLINT
  `acb_poly.evaluate(..., algorithm="fast")` 子积树/余数树路线，而非 Wolfram 逐点求值。
- Route B：`FlintNDEPathPlanning -> False`。FlintNDE 严格把段内用户点按输入顺序作为节点；
  不允许 dense assignment，实际节点数和节点链必须与用户参数链一致。

## 4. 必须保存的证据

- commit、MadStree 主入口 SHA-256、adapter SHA-256、Vendor FlintNDE 源码树 digest；
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
  全部文本 UTF-8 无 BOM。运行结束删除 `results_temp/`、cache 与 Python bytecode。
