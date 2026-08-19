# MadStree v0.13 独立验证任务书

## 1. 对象与接口边界

验证 `versions/MadStree-v0.13/` 的当前单阶段公开数值接口及端点派生拓扑 schema：

- 顶点只用 `"vertexType" -> "+"|"-"` 指定轮廓支；
- 顶点外腿指数参数只用 `"externalLegEnergy"`；不得读取旧 `"energy"` 字段；
- 传播子只用 `"type" -> "massive"|"massless"`，其 Full/Cross/External 与 SK 数据由端点派生；
- 数字顶点 ID 必须被覆盖；传播子公开接口不定义 `id`，内部编号必须严格等于 `lines` 输入位置；
- Association 键顺序可任意，额外字段应被忽略；`phaseSign/skType/sigma/phaseSigns` 不得覆盖
  `vertexType` 与端点派生结果，也不得替代必需字段；旧公开线型仍必须因非法 `type` 取值失败。

```wl
MSEvaluatePath[context, pointSequence, FlintNDEPathPlanning -> True | False]
```

MadStree 只把连续用户点划分为最大复仿射单变量段并逐段拉回 dlog DE，不选择输运节点。
实际节点必须由返回的 FlintNDE `actualNodes` 证明。验证不得调用、引用或模拟冻结版本的旧路径接口。

## 2. 强制输入与共同参数

使用 massless full-edge 三主积分系统，取 exact 900 点：

- `k1 = +900 I + a/10`，`a=0,1,2`；
- `k2 = +30 I + n/10 + I m/10`，`n=0,...,99`，`m=0,1,2`；
- `q=1`、`a1=a2=1`；输入顺序为 `a/n/m`。

共同取 `BoundaryScale=15`、`RankOrder={1,2}`。此时通用边界曲线的阻尼基数为 30，
matching anchor 正好是 `k1=+900 I,k2=+30 I`。独立 exact 极点距离预审必须证明 Route B
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
`independent-validation/MadStree-v0.13-validation-02-ep-angle-capacity/`。本项验证当前
live v0.13 工作树中的 `MSReconstructEpSeries`、MadStree adapter 与内嵌 FlintNDE，不复用
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
`000_MadStree-v0.13-validation-02-ep-angle-capacity-report.md`、`results/summary.wl` 和
`results/evidence.json`；结束时删除 `results_temp/`、adapter JSON、cache 与 Python bytecode。

## 7. 验证 03：MadStree 单独对论文的 massive 两顶点 G++ 检验

验证目录固定为
`independent-validation/MadStree-v0.13-validation-03-paper2411-two-vertex-gpp/`。本项只验证
2411.03088 Sec. 4 的两顶点、单条 `massiveFull G++` 五主积分族；不读取 dSIBP 的矩阵、结果或
报告，也不扩展为多边 tree 的 `0--3` pinch 扫描。

### 7.1 外部论文 oracle 与来源隔离

任务书目录的 `paper2411_two_vertex_gpp_de.wl` 独立保存 Eqs. (3.3)、(4.2)、(4.4)、(4.5)、
(4.11) 的 exact 五维矩阵、master 顺序、normalization 与 leading vector。
`paper2411_two_vertex_gpp_solution.wl` 仅在本验证中实现 Eqs. (3.14)、(3.16)、(4.8)、(4.10)、
(4.11) 的收敛域求值；它不是 MadStree 功能，生产 `Kernel/`、README 和 examples 均不得加载或
公开该入口。禁止用暴力 `NIntegrate` 代替论文级数，也禁止把“论文 DE + 同一 FlintNDE 输运”
冒充独立普通点值。

论文 PDF SHA-256 固定为
`34315DA929126E8B455638C168722B6909CD243183B71C4137EEC81B5F0F2EAA`；参考代码
`validate_TopToR1_against_dsdeppsol.m` SHA-256 固定为
`C6E4C290D9BF1B76CF6A029109521078B843E4A1B2E84EB184A79E6B7C3B1A06`，只用于独立核对
Eq. (4.4) 的 top-to-child 列。runner 必须先加载、哈希并冻结 oracle，再加载 MadStree。

### 7.2 basis、DE 与绝对边界

固定 `NuConvention -> "Negative"`，论文和 package 顺序均为
`{I00,I01,I10,I11,IR}`，列向量 convention 为 `dI=A I`。必须保存
`MSMasterIntegrals` 的全部记录，确认 state 顺序、积分对象和 normalization；再对
`{k12,k34,ks}` 三个 `5x5` 矩阵逐项 exact 比较论文与 `MSDLogDE`，分别报告 `25/25` 计数、
首个非零位置及差值。只比较 top `4x4` 不通过。

论文使用 `Exp[+I k tau]`，而 MadStree v0.13 的 `+` 顶点定义为
`Exp[-I externalLegEnergy tau]`，因此 oracle 到公开输入的唯一映射是
`externalLegEnergy -> -k`。runner 必须在构造 topology 时完成这个变量映射；不得通过事后
给 DE 或普通点值乘相位来掩盖接口 convention 的差异。

`MSBoundaryData` 必须在 `{nu0->2,nu1->1/5,ks->1}` 下逐项比较论文五个 leading vectors 与五个
绝对 coefficients。特别单列 Eq. (4.2) child normalization 和 Eq. (4.11) child coefficient：
`pinchNormalization` 对应论文 Eq. (4.2) 的 child 定义；绝对边界系数还必须包含 Eq. (4.11)
要求的单条 massive contraction 相位 `I`。验收最终 package/paper coefficient ratio 精确为 `1`；
删除该边界相位的实现会给出 `-I`，因此这项能直接暴露该错误。

### 7.3 收敛域普通点完整五维值

固定点为
`{k12->30,k34->6,ks->1,nu0->2,nu1->1/5}`，对应
`x=k34/k12=1/5`、`y=1/k34=1/6`，满足一顶点 `2F1` 比值 `{1/30,1/6}<1`，Eq. (4.10) 的级数
参数模也全部远小于 `1`。正实能量点还避免把不同复幂 branch 的解析延拓误报成程序包差异。
论文 oracle 分别以 cutoff `30` 与 `42` 求值，最大逐分量变化必须
小于 `10^-20`；高阶结果还必须以高精度数值导数满足论文三个五维 DE，最大 residual 小于
`10^-25`。

随后只调用一次 MadStree `MSEvaluatePath` 到该普通点，与高阶论文值比较完整五维向量；最大
相对差要求小于 `10^-18`。第五个 child 分量必须单独报告相对差及
`MadStree/paper` ratio，不能让 top 四分量掩盖整体相位。这个常点检验与绝对边界检查共同构成
当前 bug 的必要验收：DE-only 即使完全相等也不能通过本项。

### 7.4 报告、清理与执行边界

runner 自动生成 `000_MadStree-v0.13-validation-03-paper2411-two-vertex-gpp-report.md` 和
`results/summary.wl`，保存源码/oracle/PDF hash、master 定义、三个矩阵差值、五个边界系数、
级数收敛、普通点五维差值、child ratio、实际路径、精度/阶数和 wall time。每轮先删除本验证
目录旧报告、`results/` 与 `results_temp/`，从空产物运行；结束后仅保留报告和轻量 summary，
清除 runtime/cache/JSON。只执行本 targeted validation，不重跑 validation-01/02 或全量开发测试。
