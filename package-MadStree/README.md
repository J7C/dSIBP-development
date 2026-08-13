# MadStree 版本与验证入口

MadStree 是 Wolfram Language 的 dS time-integral 公式程序包。当前版本为 `v0.11`，数值
输运委托给版本内嵌且与独立包同步的 FlintNDE `0.4.0`。

## 加载

交互使用可直接执行根目录 `load_current.wl`。正式复现应显式加载版本目录：

```wl
packageRoot = ".../package-MadStree/versions/MadStree-v0.11";
AppendTo[$Path, packageRoot];
Needs["MadStree`"];
```

源码和文档均为 UTF-8；包内 `Get`、JSON 和后端日志入口显式使用 UTF-8，用户不需要给
`Needs` 额外填写编码参数。

## v0.11 数值边界

唯一当前入口是：

```wl
result = MSEvaluatePath[
  context,
  {point1, point2, {point3, "tmp"}},
  FlintNDEPathPlanning -> True
];
```

MadStree 只按输入顺序识别最大连续复仿射单变量段 `x(s)=x0+s v`，并对每段拉回一次
dlog DE。它不选择输运节点、不构造绕行，也不保存路径计划。全部段和边界数据在一次
Python 进程中交给 FlintNDE。

- `FlintNDEPathPlanning -> True`（缺省）：FlintNDE 自动规划节点。同一展开节点覆盖的
  多个用户点按桶使用 fast multipoint evaluation；大桶由子积树/余数树算法求值，小桶
  使用迭代法以避免建树开销。
- `FlintNDEPathPlanning -> False`：严格把每段用户点依次作为输运节点，不插点、不删点、
  不静默规划。用户必须给出落在逐步收敛圆内且不穿奇点的点列。

裸坐标是需要返回的用户点；`{coordinate,"tmp"}` 只参与连续段识别和输运。v0.11 不提供
奇点领头阶点标签，也不提供旧两阶段路径函数、计划对象、wrapper 或旧 JSON schema。
`SingularityMode -> "Avoid"` 缺省拒绝穿过奇点；`"SingularityJump"` 只在开启 FlintNDE
规划时可用。

## 目录

- `versions/MadStree-v0.11/`：当前源码、内嵌后端、手册、examples 和开发测试。
- `VERSION_INDEX.md`：当前版本和冻结版本边界。
- `independent-validation-task/`：版本化独立验证任务书。
- `independent-validation/`：独立 runner、正式轻量结果和自动报告。

运行 JSON、日志和 cache 写入调用脚本所在目录的 `results_temp/`；正式结果由调用者写入
`results/`，不写入程序包源码目录。
