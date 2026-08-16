# FlintNDE 0.4.0 独立检验任务书

日期：2026-08-13
对象：`versions/FlintNDE-0.4.0/` 当前实际源码
性质：全新独立验证；不读取或沿用 0.3.0 独立检验结论

## 1. 验证目标

本任务只通过 0.4.0 当前 Python API 验证三项新合同：

1. 同一展开节点覆盖的大桶通过 FLINT fast multipoint（子积树/余数树）求值，并与同一
   系数、点、工作精度下的逐点 Horner oracle 全分量一致。
2. 同一 900 点、初值、精度与单进程条件下，比较 planned dense fast 路线与
   `direct_user_point_path` 用户节点逐点路线；记录真实 nodes、coverage、算法桶计数和 backend
   wall time，并对所有点所有分量同时做路线互检及闭式解 oracle。
3. `direct_user_point_path` 不调用 planner；直接节点路径穿过奇点必须 fail closed。

不得修改程序包源码，不得读取旧报告或旧 summary 生成 expected。runner 必须在数值计算前
物理删除本任务旧 `results/`、旧报告和 validation cache；任一删除失败即停止，不允许混写。

## 2. Fast Multipoint 独立桶

- 工作精度：60 位十进制。
- 向量多项式：2 分量、64 阶（65 个 exact Gaussian-rational 系数）。
- 局部点：257 个互异 exact Gaussian-rational 复点。
- fast 路线：公开实现模块的 `evaluate_vector_series_many`，必须返回算法 `fast`；实现合同为
  每分量调用 FLINT `acb_poly.evaluate(..., algorithm="fast")`，即子积树/余数树路线。
- oracle：对每一点独立调用 `evaluate_vector_series` Horner。
- 保存 fast/Horner 墙钟、点数、阶数、分量数以及每点每分量绝对差；最大差须 `<1e-50`。

复杂度说明必须如实限定为算法模型：对次数 `n`、点数 `m`，逐点 Horner 为 `O(nm)` 次
标量操作；基于快速多项式算术的子积树/余数树为约 `O(M(n) log m)`（均衡 `m~n` 时常写
`O(M(n) log n)`）。本检验记录当前主机实测时间，但不以倍率作为正确性门禁。

## 3. 900 点输运

系统和独立闭式解为

```text
dY/dz = diag(1/(z-20), -2/(z+20)) Y,  Y(0)=(1,1)^T,
Y1(z)=1-z/20,  Y2(z)=(20/(z+20))^2.
```

网格为 `x=9/20,...,270/20` 与 `y=-261/40,-243/40,...,261/40` 的 30x30 笛卡尔积，
即实部、虚部相邻点间距均为 `9/20=0.45`；按逐行蛇形顺序提交，共 900 个互异复点。
间距不作为算法输入调参，而是用于避免原小网格被一个起点展开盘全部覆盖。两条路线固定：
60 位十进制、输运阶 64、单进程。阶数扫描表明 60 阶的 direct 900 段累计误差略高于
`1e-28` 门限，64 阶才稳定通过；两条路线必须使用相同阶数。

- Route P：`plan_transport_path` 后 `transport_planned_path(order=64)`；记录 planner wall time、
  backend 返回 wall time、总 wall time、节点、段数、覆盖数和每段 dense 算法/点数。逐段统计
  dense sample 和恰好命中该段终点的用户点，定义二者之和为该段承担的用户值数；自动插入且
  不承担用户值的纯输运桥段单列。所有承担用户值的段必须包含 3--20 个用户值，并报告
  min/median/mean/max、直方图、纯输运段和例外段。
- Route D：`direct_user_point_path` 后 `transport_planned_path(order=64)`；在构造和执行期间把
  `singularity_jump.plan_transport_path` 替换成报错 sentinel。节点必须严格等于
  `[start,*user_points]`，sample assignment 必须为空，planner sentinel 调用次数必须为 0。

两路线都必须恢复 900 点值；每一点两个分量分别保存 `P-closed`、`D-closed` 和 `P-D` 绝对差，
每项须 `<1e-28`。报告不可把用户输入 waypoint 数冒充实际执行节点数。

## 4. Fail-closed 负例

构造在 `z=1` 有极点的系统，从 `0` 直接到 `2`。调用 `direct_user_point_path` 必须抛出
`SingularPathError`，不得返回计划、插入绕行点或调用 planner。

## 5. 保留证据与门禁

目录：`independent-validation/FlintNDE-0.4.0-validation-01-fast-multipoint-and-direct-path/`

- `run_validation.py`：唯一 runner；所有文本读写显式 `encoding="utf-8"`。
- `results/summary.json`：环境、runner 与 0.4.0 源码 SHA-256、fresh 清理记录、配置、节点/coverage/算法计数、耗时、
  fast/Horner 全分量差以及 900 点两分量三方差。
- `000_FlintNDE-0.4.0-validation-01-report.md`：自包含中文报告。

`overall_passed=true` 仅在 fast 算法被实际选择、全部数值门禁通过、direct sentinel 为 0、
直接节点链不变、穿奇点负例 fail closed、所有输出严格 UTF-8 无 BOM/无 replacement character
时成立。运行后清除 `__pycache__`、temp 和 cache，不删除正式 `results/`。

---

## 6. Validation-02：正规化角域与候选容量

日期：2026-08-16
目录：`independent-validation/FlintNDE-0.4.0-validation-02-regularization-angle-and-candidate-capacity/`

本专项从当前 `regularization.py` 重新生成全部 expected，不读取 validation-01 或其它 retained
summary。runner 在任何数值计算前必须物理删除本专项旧 `results/`、旧报告以及本专项 cache；
删除失败立即停止。只允许重新建立正式 `results/summary.json` 和中文报告。

### 6.1 默认 Automatic 基线

使用零矩阵 DE、普通点路径和已知边界

```text
F(ep)=2 ep^-1 + 3 + 4 ep + 5 ep^2.
```

固定 `sample_count=4`、`fit_extra_order=0`、`base_sample=1/100`、
`sample_spacing=1/100`。四点恰好对应请求的 `ep^-1,...,ep^2` 四个系数，避免用病态高阶
Vandermonde 的应为零尾项替代角域功能门禁。缺省 `sample_angle_range="automatic"` 时，第
`i=1,...,4` 个生产点必须逐项等于旧公式

```text
ep_i=(1/100)(1+i/100)
```

并位于正实轴；传给边界工厂的生产参数必须保持 exact `fmpq`。自动验证点必须与前部生产点
同角且模长按 `validation_scale=1/2` 缩小。返回的 `ep^-1,ep^0,ep^1,ep^2` 系数分别恢复
`2,3,4,5`，最大绝对误差 `<1e-35`；正例独立验证容差固定为 `1e-40`，且
`precision_target_met=True`。

### 6.2 开角域

保持与 6.1 完全相同的生产模长参数，只增加 `sample_angle_range=(-1,1)`。四个点必须循环使用
开区间内部三条均匀射线 `-1/2,0,1/2`，不得使用端点，角数量不得超过 3。每一点模长必须与
6.1 同索引旧公式相等。前三个自动验证点必须与对应生产点同角，且复数值严格等于生产点的
`1/2` 缩放。相同四个 Laurent 系数仍须恢复，且达到精度目标。

### 6.3 显式候选池耗尽

候选池严格固定为 `0.10,0.09,0.08,0.07`，验证点为 `0.04,0.03`；边界使用 `exp(ep)`，只请求
常数项，并以严格容差迫使拟合扩展到候选池尾。验收要求：

1. 即使候选池耗尽仍返回 `power=(0,)` 和一个系数，不抛弃当前最佳结果。
2. `precision_target_met=False`，`precision_failure_reason="candidate_pool_exhausted"`。
3. `sample_candidate_count=4`、`sample_count=4`、`unused_sample_candidate_count=0`。
4. 边界工厂实际收到的参数集合严格等于四个候选点加两个验证点；无重复求解、无池外点。
5. 必须产生明确的 `RuntimeWarning`，其文本说明候选池耗尽且未生成池外点。

### 6.4 证据与门禁

- `run_validation.py`：fresh-clean 唯一 runner，禁用 bytecode 写入，显式 UTF-8 I/O。
- `results/summary.json`：保存当前 runner、`regularization.py`、`__init__.py` SHA-256，清理记录，
  所有生产/验证点、模长、角、系数差、候选池调用记录及有效参数。
- `000_FlintNDE-0.4.0-validation-02-report.md`：自包含中文报告。

只有上述逐项、角域、模长、同角缩模、系数恢复、候选耗尽和无池外点门禁全部通过，且所有
正式文本严格 UTF-8 无 BOM/无 replacement character、本专项目录无 cache/temp 时，才可写
`overall_passed=true`。
