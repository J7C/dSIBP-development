# MadStree 版本与验证入口

MadStree 是 Wolfram Language 的 dS time-integral 公式程序包。当前版本为 `v0.16`，数值
输运委托给版本内嵌且与独立包同步的 FlintNDE `0.5.0`。

## 加载

交互使用可直接执行根目录 `load_current.wl`。正式复现应显式加载版本目录：

```wl
packageRoot = ".../package-MadStree/versions/MadStree-v0.16";
AppendTo[$Path, packageRoot];
Needs["MadStree`"];
```

源码和文档均为 UTF-8；包内 `Get`、JSON 和后端日志入口显式使用 UTF-8，用户不需要给
`Needs` 额外填写编码参数。

主积分对象 `MSIntegral[sectorKey,timeShifts,stateBits]` 是 normalized master。
`MSMasterIntegrals[context]` 直接返回其裸积分标签、精确 sector normalization 和
`normalized == normalization bare` 定义；单个对象使用 `MSIntegralDefinition[integral,context]`。

## v0.16 数值接口

单点和多点只有一个入口。`pointSequence` 首行定义可跑动坐标，后续每行是一个等宽坐标点；
固定参数只在 `ParameterRules` 中给一次：

```wl
result = MSEvaluatePath[
  context,
  {{k0, k1}, {1, 1}, {11/10, 1}, {{6/5, 1}, "tmp"}},
  ParameterRules -> {q -> 1, nu -> 1/2, a -> 2},
  FlintNDEPathPlanning -> True
];
```

单点只保留表头和一行值，例如 `{{k0,k1},{1,1}}`；不另设 `MSEvaluatePoint`。表头与
`ParameterRules` 必须互斥，二者合起来必须覆盖解析 DE 和边界的全部必需符号。缺失或替换后
仍非数值时，返回列出问题符号的 `Failure`，并明确说明数值 NDE 未启动。

带共同正规化参数 `ep` 的极限计算使用：

```wl
series = MSReconstructEpSeries[
  context, ep, pointSequence,
  ParameterRules -> {q -> 1, a1 -> 1 + ep, a2 -> 1 + ep},
  MaximumEpPower -> 0,
  EpGoalDigits -> 20,
  ParallelTaskCount -> 12
];
```

`MaximumEpPower -> 0` 表示返回到 `ep^0`。缺省时用户不提供 `ep` 取值；任何数值 NDE 启动前，
程序从实际符号边界条件与 dlog DE 自动认证最低整数幂，并把证书交给后续采样规划。DE 含负
`ep` 阶、边界不是有限 Laurent 型、最低阶系数无法证明非零或路径坐标依赖 `ep` 时均
fail closed，不用终点数值 pilot 猜测。随后自动决定生产点、独立验证点、工作精度和输运阶数；
也可显式用 `EpSamplePoints` 提供冗余有序生产候选池、用 `EpValidationPoints` 固定独立验证点，
并以 `EpInitialInternalMaximumPower` 指定首轮内部最高幂。程序只按需增量消费候选点并复用旧值，
候选耗尽时不会越出用户给定范围，并返回带未认证标记的当前最佳系数。也可改用
`EpSampleAngleRange -> {thetaMin,thetaMax}` 指定复角开区间；程序在内部均匀选择最多三条射线，
模长仍由精度自动决定。相关选项缺省均为 `Automatic`，不改变缺省输入格式。
内部缺省多拟合两阶，验证失败时每轮再增加两阶，只求解新增生产点并复用既有生产/验证缓存。
自动工作精度不低于 200 位。`ParallelTaskCount` 缺省为 12，是不同 `ep` 的外层进程上限，
不是单个 Python 进程内的 `ctx.threads`。

MadStree 只按输入顺序识别最大连续复仿射单变量段 `x(s)=x0+s v`，并对每段拉回一次
dlog DE。它不选择输运节点、不构造绕行，也不保存路径计划。全部段和边界数据在一次
Python 进程中交给 FlintNDE。Wolfram 侧以参数列表 `RunProcess` 启动该进程，不经过 shell
命令拼接、引号 helper 或重定向，也不提供重试 fallback。

`MSBoundaryData` 与 `MSEvaluatePath` 的 `WorkingPrecision` 缺省均为 200 位。用户显式传入
其它正整数时按该值覆盖；内部 bit 数为 `ceil(WorkingPrecision*log2(10))+32`。

- `FlintNDEPathPlanning -> True`（缺省）：FlintNDE 自动规划节点。同一展开节点覆盖的
  多个用户点按桶使用 fast multipoint evaluation；大桶由子积树/余数树算法求值，小桶
  使用迭代法以避免建树开销。
- `FlintNDEPathPlanning -> False`：严格把每段用户点依次作为输运节点，不插点、不删点、
  不静默规划。用户必须给出落在逐步收敛圆内且不穿奇点的点列。

普通值行是需要返回的用户点；`{{values...},"tmp"}` 只参与连续段识别和输运。v0.16 不提供
奇点领头阶点标签，也不提供旧两阶段路径函数、计划对象、wrapper 或旧 JSON schema。
`SingularityMode -> "Automatic"` 缺省忠实处理用户显式给出的奇点：FlintNDE 的同一局部基
覆盖收敛域内双侧用户点，真实发散返回文本 `Infinity`，并从出射普通点继续。末端奇点若
需要则自动插入由目标奇点收敛半径决定的隐藏普通匹配点。`"Avoid"` 显式拒绝穿越；
`"SingularityJump"` 显式选择穿越分支，并要求用户确认等价绕行类的多值性。奇点处非共线
转向和关闭规划后的中间奇点仍 fail closed。

## 目录

- `versions/MadStree-v0.16/`：当前源码、内嵌后端、手册、examples 和开发测试。
- `VERSION_INDEX.md`：当前版本和冻结版本边界。
- `independent-validation-task/`：版本化独立验证任务书。
- `independent-validation/`：独立 runner、正式轻量结果和自动报告。

当前独立 runner 在数值计算前物理删除本任务旧 `results/`、`results_temp/` 和旧报告；删除失败
立即退出。它不读取仓库根旧 runtime，也不提供旧目录或旧 schema 的兼容入口。

`MSRuntimeDirectory -> Automatic` 把运行根设为调用脚本旁的 `results_temp/`；显式路径直接
表示运行根本身，不再由 MadStree 重复追加 `results_temp`。临时输入/日志位于 `nde/`，成功
cache 位于 `cache/`；正式结果由调用者写入 `results/`，不写入程序包源码目录。
Windows 完整路径过长时在 Python 启动前独立返回 `RuntimePathTooLong`，并给出实际路径长度；
输入写入、缺少 `python-flint`、后端启动和后端无输出分别使用不同错误标签。
内嵌 FlintNDE Wolfram bridge 使用参数列表 `RunProcess`，不保留 shell `Run` launcher、命令
引号 helper、重定向或失败重试 fallback。

解析公式使用 `MSDLogDE[context]` 直接读取；纯符号工作流可显式调用
`MSWriteFormulaArtifacts[context]` 保存。所有数值入口都会在启动 Python/FlintNDE 前自动写出或
复用同一 context 的完整解析资产，写出失败则不启动 NDE，并在返回值的 `"formulaArtifacts"`
给出实际路径。缺省正式目录是 `results/madstree_formula/run-<UUID>/`，其中 `masters.wl`、
`recurrence_metadata.wl`、`dlog_de.wl` 和 `manifest.wl` 分别保存同序主积分、递推 metadata、
完整解析 dlog DE 和版本/摘要/实际路径清单。数值阶段只构造函数内局部参数化 DE，不覆盖这些
正式解析结果。`MSExportEvaluationData` 的缺省正式数值目录是
`results/madstree_evaluation/run-<UUID>/`，文件固定为 `evaluation_data.csv/json`。
