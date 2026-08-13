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

不得修改程序包源码，不得读取旧报告或旧 summary 生成 expected。

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

网格为 `x=1/10,...,30/10` 与 `y=-29/20,-27/20,...,29/20` 的 30x30 笛卡尔积，
按逐行蛇形顺序提交，共 900 个互异复点。两条路线固定：60 位十进制、参考阶 48、单进程。

- Route P：`plan_transport_path` 后 `transport_planned_path(order=48)`；记录 planner wall time、
  backend 返回 wall time、总 wall time、节点、段数、覆盖数和每段 dense 算法/点数。
- Route D：`direct_user_point_path` 后 `transport_planned_path(order=48)`；在构造和执行期间把
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
- `results/summary.json`：环境、0.4.0 源码 SHA-256、配置、节点/coverage/算法计数、耗时、
  fast/Horner 全分量差以及 900 点两分量三方差。
- `000_FlintNDE-0.4.0-validation-01-report.md`：自包含中文报告。

`overall_passed=true` 仅在 fast 算法被实际选择、全部数值门禁通过、direct sentinel 为 0、
直接节点链不变、穿奇点负例 fail closed、所有输出严格 UTF-8 无 BOM/无 replacement character
时成立。运行后清除 `__pycache__`、temp 和 cache，不删除正式 `results/`。
