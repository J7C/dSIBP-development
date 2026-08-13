# FlintNDE 0.4.0 独立检验报告

日期：2026-08-13
对象：`versions/FlintNDE-0.4.0/` 当前实际源码
结论：**通过**

## 范围与方法

本次未读取 0.3.0 独立报告或结果。fast multipoint 的 expected 是同一系数/点/精度下逐点
Horner；900 点输运 expected 是脚本直接计算的闭式解。执行均为单进程，工作精度
60 位十进制（实际
232 bits）。

## 单节点覆盖桶：Fast 与 Horner

测试 2 分量、64 阶向量多项式在 257 个
互异复点上的求值。批量入口实际返回算法 `fast`，对应
`acb_poly.evaluate(..., algorithm="fast")` 的子积树/余数树；oracle 为逐点 Horner。

| route | points | components | wall time | 最大逐分量绝对差 | status |
| --- | ---: | ---: | ---: | ---: | --- |
| fast subproduct/remainder tree | 257 | 2 | 0.011144 s | 1.965860e-62 | passed |
| iterative Horner oracle | 257 | 2 | 0.015097 s | oracle | passed |

当前实测 Horner/fast 为 1.355x。复杂度模型：逐点 Horner
是 `O(n*m)` 标量操作；基于快速多项式算术的子积树/余数树约为 `O(M(n) log(m))`，当
`m~n` 时常写为 `O(M(n) log(n))`。倍率只描述当前主机 case，不是复杂度证明。

## 900 点 Planned 与 Direct

系统为 `dY/dz=diag(1/(z-20),-2/(z+20))Y`、`Y(0)=(1,1)^T`；闭式解为
`Y1=1-z/20`、`Y2=(20/(z+20))^2`。两路线使用相同 30x30 蛇形点序、初值、60 位精度、
48 阶和单进程。

Route P 实际节点 2 个、段 1 条，覆盖
899 个 dense 点。节点链为：

```text
0 -> [0.1000000000000000000000000000000000000000 +/- 3e-45] + [1.450000000000000000000000000000000000000 +/- 3e-44]j
```

其算法桶数为 `{"fast": 1}`，
对应点数为 `{"fast": 899}`。
这说明 900 个蛇形 waypoint 在当前远极点系统中被一个起点展开盘覆盖，实际只执行一个普通段，
其余 899 点由一个 fast multipoint 桶求值。

Route D 由 `direct_user_point_path` 构造，实际节点 901 个、段
900 条、coverage 0；节点序列与
`[start,*900 user points]` 严格一致：`True`。planner sentinel 调用
0 次，证明构造与执行未调用 planner。

| route | nodes | coverage | backend wall | total wall | algorithm |
| --- | ---: | ---: | ---: | ---: | --- |
| planned dense fast | 2 | 899 | 0.048225 s | 0.079003 s | fast buckets=1 |
| direct user nodes | 901 | 0 | 0.625728 s | 0.638485 s | dense none; 900 ordinary segments |

direct/planned backend wall time 为 **12.975x**，总墙钟
为 **8.082x**。

## 全点全分量互检

| comparison | values checked | 最大逐分量绝对差 | gate | status |
| --- | ---: | ---: | ---: | --- |
| planned vs closed | 1800 | 3.151999e-37 | 1e-28 | passed |
| direct vs closed | 1800 | 8.033238e-55 | 1e-28 | passed |
| planned vs direct | 1800 | 3.151999e-37 | 1e-28 | passed |

`results/summary.json` 保留全部 900 点、两个分量的三组误差，没有以抽样或总体范数替代。

## Sentinel 与 Fail Closed

直接节点正例的 planner sentinel 为 0。负例从 `0` 到 `2` 穿过
`z=1` 极点，实际抛出 `SingularPathError`，planner sentinel 仍为
0；因此没有静默规划、插点或绕行。

## 证据边界

本报告认证 0.4.0 当前 SHA-256 所对应源码的 fast multipoint、普通点 planned/direct 路线和
直接路径穿奇点拒绝。它不认证奇点折跃分支、Stokes connection、ramification、一般代数扩域、
Lee--Moser 或指数型边界。所有正式输出严格 UTF-8、无 BOM、无 replacement character。

复核命令：

```powershell
python package-FlintNDE/independent-validation/FlintNDE-0.4.0-validation-01-fast-multipoint-and-direct-path/run_validation.py
```
