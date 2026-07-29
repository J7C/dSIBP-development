# FlintNDE 高阶 pole 独立测试与效率基准任务书

## 1. 任务定位

本任务独立验证 FlintNDE 对高阶 pole 的三段调度：

1. exact Lee--Moser projector-balance 逐阶降 pole；
2. 严格解耦标量 sector 的指数乘 power-log 局部基；
3. 单重不同主导根二阶 pole 的 start-only 形式指数递推、指数根差选点与五阶诊断；
4. 超出认证范围或缺少 Stokes connection 时 fail closed。

任务同时测正确性、失败门禁和效率，但不把包内单元测试、manifest 或私有函数生成的量当作
独立期望值。所有路线使用相同的原始复矩阵维数、输入矩阵、路径、工作精度和级数阶数；不得
把一个 N 维复系统改成 2N 维实系统后再宣称同维比较。

本 check 只检查矩阵 NDE 局部求解与输运，不执行 IBP、scalar contraction、regulator 重构、
Step4 或 `Rhat` 比较。

## 2. 目录和预定产物

```text
check_01_nde_high_pole_local/
    INDEPENDENT_BENCHMARK_TASK.md
    check_01_nde_high_pole_local.py       # 后续实现
    results/
        check_01_nde_high_pole_local_summary.json
        check_01_nde_high_pole_local_efficiency.md
```

正式结果只能写入本 check 的 `results/`。临时剖析、逐次原始计时和调试输出写入
`results_temp/`，不得写入 package、example 或已有 expected 数据目录。

## 3. 现有验证清单

截至 2026-07-29，package 全量 `unittest` 为 `62/62 passed`；这些是回归测试，
不是本任务要求的 source-isolated benchmark。

| 测试文件 | 数量 | 已覆盖内容 |
| --- | ---: | --- |
| `test_frobenius.py` | 18 | Q(i) 输入、indicial roots、Jordan、整数差 resonance、log、浮点阈值和拒绝门禁 |
| `test_general_transport.py` | 3 | 一般解析矩阵的 Cauchy--DFT 系数、普通点输运和精度 warning |
| `test_high_pole_local.py` | 16 | exact Moser balance、非交换 projector、原基边界 jet、指数 bridge、多指数 sector、形式渐近与 Stokes 门禁 |
| `test_output_layout.py` | 3 | 调用脚本锚定输出与路径安全 |
| `test_regularization.py` | 7 | regulator 幂级数重构、pilot、独立验证和奇点边界复用 |
| `test_singularity_routing.py` | 15 | 约分后奇点、无穷远、统一调度、路径、bridge、`{a,b,C}` |

高阶 pole 的 16 项现有回归测试逐项为：

1. `A12=1/t^2` 自动 Moser balance，bridge、解析终值和上半平面绕行一致；
2. `y'=y/t^2` 自动提取 `exp(-1/t)`，bridge、解析终值和绕行一致；
3. 高阶 pole 奇点起点继续使用 `{a,b,C}`，指数 sector 从 `C` 自动识别；
4. 由 Fuchsian 2x2 系统经非对角 `T=P diag(1,t)` 正向制造高阶 pole，自动寻找
   exact projector 并降阶；终值与变换前 Fuchsian 系统直接求解后乘回 `T` 一致；
5. 由 Fuchsian 3x3 系统经稠密非对角 `T=P diag(1,t,t^2)` 正向制造二/三阶 pole，
   自动结果同时与变换前直接求解和上半平面绕行一致；
6. 非对角输入基 `P diag(1,-2,3)P^-1/t^2` 的三个不同指数 sector 分别给出
   `exp(-1/t)`、`exp(2/t)`、`exp(-3/t)`，并在原积分基核对解析终值和绕行；
7. nilpotent 二阶项带反向单极点耦合形成约束闭环时拒绝，证明 `k=0` 不是兜底；
8. 二阶 pole、单重不同主导根且保留低阶耦合时构造
   `formal_exponential_asymptotic`，验证 `{a,b,C}` 选支、固定 N 阶和五阶块比报告；
9. 同一形式渐近点位于路径内部时，建路和规划均因缺少 Stokes connection 而拒绝；
10. 路径规划器把已认证收敛指数点标为 `continuation_ready=True`；
11. 路径规划器把不可降的 `k=0` defective/耦合点标为不可继续并记录原因。
12. 固定保留用户要求的 `N` 阶并额外生成五阶，显式核对“后五项矢量和范数 / 前五项
    矢量和范数”的报告公式；
13. 用户选择过远的形式渐近首匹配点时，五阶块比不小于 1 会 warning，但仍返回结果；
14. 自动首匹配点使用最近指数根差估计 `n_min≈Delta/|z|`，缺省令 `n_min=3N`，并继续满足
    `max_step_over_radius` 上限；
15. 两个不交换 projectors 制造的稠密三阶 pole exact 按 `3->2->1` 降阶，系统 round-trip
    严格相等，并与已知 Fuchsian 原方程直接输运一致；
16. 高阶 pole 奇点边界在原积分基用完整 exact power-log jet 验证，允许相邻阶分量补全
    leading `C`，不再错误地只对 `C` 应用逆 gauge。

已有 16x16 NDE 与 2x2 connection check 可说明普通点和既有正则奇点路线没有回归，但它们
不含本任务的 source-isolated 高阶 pole oracle，不能替代下面的独立验收。

## 4. 独立性要求

1. expected 公式直接写在 check 中，来源是本任务书的解析推导，不从
   `test_high_pole_local.py`、`local_solutions.py`、`fuchsian.py` 或运行 manifest 读取。
2. 被测路线只通过 `from flintnde import ...` 调用公开 API；禁止导入包内下划线函数。
3. 手工 Moser/balance 对照矩阵在 check 中独立写出，不调用 `attempt_fuchsian_reduction` 生成。
4. 绕行对照只使用普通点 Cauchy--DFT 输运，不调用奇点 bridge。
5. 每个结果同时报告：解析差、自动路线与手工路线差、自动路线与绕行差；不得只报
   `passed=True`。
6. 效率结论只有在全部正确性 gate 通过后才生效。没有同矩阵、同精度、同路径、同阶数的
   数据时，不得写速度倍数。

## 5. 高阶 pole 降阶的数学原理

在局部变量 `t=x-x0` 下写

```text
dI/dt = A(t) I,
A(t) = sum_m A_m t^m.
```

### 5.1 Lee--Moser projector balance

若 pole 阶为 `p+1>1`，写

```text
A(t)=t^(-p-1)(A0+t A1+...),
TQ(t)=Identity-Q+Q/t,  TQ^(-1)=Identity-Q+t Q,  Q^2=Q.
```

取 `I=TQ J` 后

```text
dJ/dt = [TQ^(-1) A TQ - TQ^(-1) TQ'] J.
```

程序在 Q(i) 上由 `A0` 的 nilpotent Jordan chains 和 `A1` 构造 projector。每步必须 exact
验证 `Q^2=Q`，并要求完整矩阵 pole 阶严格下降；随后重算新的 `A0,A1` 继续迭代。最终保存
ordered projectors、逐步 pole 阶，并把降阶系统经全部逆 balances 恢复后逐元与原系统严格
比较。非 nilpotent `A0` 是无 ramification meromorphic Fuchsian gauge 的 exact obstruction；
内部构造条件不满足则只返回 `inconclusive`，不能写成真正不规则奇点证明。

### 5.2 指数因子

若 exact 常数换基后，一个互不耦合 sector 的高阶部分是标量矩阵

```text
A_high(t) = sum_(m>=2) c_m/t^m * Identity,
```

取 `I=exp(Phi(t)) U`，其中

```text
Phi'(t) = sum_(m>=2) c_m/t^m,
Phi(t)  = -sum_(m>=2) c_m/(m-1) * t^(-(m-1)).
```

则 `U` 的方程中这些高阶项被严格相消，剩余矩阵至多为单极点时继续调用 power-log 递推。
特别地，`A_-2=k` 给出 `exp(-k/t)`。

`k=0` 只说明标量特征值给出的指数为 1，不说明高阶矩阵为零。例如非零 nilpotent 矩阵
`N^2=0` 虽然所有特征值都是零，但

```text
exp(-N/t) = Identity - N/t != Identity.
```

因此 defective/nilpotent、不同指数 sector 的耦合、ramification 或 Stokes 数据不能通过
“最后取 `k=0`”解决。

### 5.3 单重二阶 pole 的形式递推

当 pole 阶恰为二、`A_-2` 在 Q(i) 中有单重互异根时，起点可使用

```text
Y = exp(-k/t) t^rho Sum[v_n t^n, {n,0,N}].
```

`rho` 由左右本征向量对 `A_-1` 的双线性投影精确确定；每阶奇异线性方程的自由分量由下一阶
相容条件固定。求值固定保留 N 阶并额外生成五阶；必须报告后五项矢量和与前五项矢量和的
无穷范数之比及五阶相对 refinement，同时保留是否看到最小项的辅助诊断。这是起点
渐近边界，不是跨奇点算法；内部点或终点没有 Stokes matrix 时必须拒绝。

## 6. 正确性 case

### 6.1 必须成功的解析 case

| ID | 原始方程 | 独立 oracle | 预期自动路线 |
| --- | --- | --- | --- |
| H01 | `y'=y/t^2`, `y(-1)=1` | `y(t)=exp(-1-1/t)`，所以 `y(1)=exp(-2)` | `exponential_power_log` |
| H02 | `y'=(1/t^2+rho/t)y`, `rho=1/2` | `y=C exp(-1/t)t^rho`；上半平面分支由 `log(-1)=i*pi` 固定 | 指数后 power-law；上绕行一致，下绕行按分支相位不同 |
| H03 | `y'=2y/t^3` | `y=C exp(-1/t^2)` | 三阶 pole 指数 `Phi=-1/t^2` |
| H04 | `A=P diag(1,-2,3)P^-1/t^2`，`P` 非对角 | `P diag(exp(-1/t),exp(2/t),exp(-3/t))P^-1` | 三个严格解耦但输入基非对角的指数 sector |
| H05 | `A=k*Identity/t^2+N/t`, `N=[[0,1],[0,0]]` | `F=exp(-k/t)[Identity+N log(t)]` | 同指数 sector 内 `maximum_log_degree=1` |
| H06 | 已知 Fuchsian 2x2 `B` 经非对角 `T=P diag(1,t)` 正向生成 `A=TBT^-1+T'T^-1` | 直接求解 `J'=BJ` 后手写乘回 `I=TJ` | exact Moser balances |
| H07 | 已知 Fuchsian 3x3 `B` 经稠密 `T=P diag(1,t,t^2)` 生成含二/三阶 pole 的 `A` | 变换前直接解、手工乘回原基以及普通点绕行三方对照 | repeated exact Moser balances |
| H08 | 原变量 `s` 中 `y'=k y`，检查 `s=inf` | `t=1/s` 后 `dy/dt=-k y/t^2`，解为 `exp(k/t)` | 无穷远 Jacobian 与指数符号正确 |
| H09 | `A_-2=diag(1,-1)` 且低阶项耦合两 sector | 独立按左右本征相容条件生成形式系数，并以普通点输运核对两个邻近匹配点 | `formal_exponential_asymptotic`，只允许起点 |
| H10 | 两个不交换 projectors 的 `T_Q1 T_Q2` 正向制造稠密三阶 pole | 硬编码正向矩阵，直接求解原 Fuchsian 系统后手写乘回，并检查 exact round-trip | pole 阶 `3->2->1` 的 ordered Moser balances |
| H11 | `A12=1/t^2` 的奇点边界 `{a=-1,b=0,C=(-1,0)}` | 解析解 `I=(-1/t,1)`；次阶第二分量参与降阶基 leading term | 原基 exact power-log jet 边界验证 |

H01、H03、H04 必须直接比较解析终值。H05、H06、H07 还必须比较自动路线和独立手工换基路线；
H06、H07 必须直接求解变换前 Fuchsian 系统，不能只核对自动 manifest 或同一高阶系统绕行。
H01、H02、H06 必须同时比较自动 bridge 与显式复平面绕行。H09 必须报告逐阶 exact recurrence
残差、最小项诊断和两个邻近匹配点稳定性，不得把绕行跨 Stokes sector 当作唯一 oracle。所有
返回量都在原始积分基比较。

### 6.2 必须拒绝的 case

| ID | 输入结构 | 必须拒绝的原因 |
| --- | --- | --- |
| N01 | `A12=1/t^2` 且 `A21=1/t` | Moser 后出现不可 Fuchsian 化的高阶闭环；不得当作 `k=0` 无指数 |
| N02 | `A_-2=[[0,1],[2,0]]` | 特征值 `+-sqrt(2)` 不在 Q(i)，需要代数扩域 |
| N03 | leading matrix 可对角化，但 `A_-3,A_-2` 在该基中不能同时对角 | 需要 formal block decoupling |
| N04 | H09 的形式渐近奇点位于路径内部或终点 | 没有 Stokes connection，start-only 基不得跨点 |
| N05 | pole 阶高于二，或抽掉已认证标量指数后仍有当前形式递推不覆盖的高阶块 | 需要进一步 meromorphic/formal gauge |

拒绝验收必须检查异常类型和结构类别，不要求逐字匹配完整英文错误字符串。路径规划器还应将
这些点标记为 `continuation_ready=False` 并保存原因。

## 7. 效率路线

每个成功 case 比较以下路线；不适用的路线填 `N/A`，不得伪造时间：

| route | language | parallel | 说明 |
| --- | --- | --- | --- |
| R1-auto | Python + FLINT | single process | 自动奇点分析、Moser/指数调度和局部 bridge |
| R2-manual | Python + FLINT | single process | 独立手写变换后 Fuchsian/残余系统，再调用公开 power-log/输运接口 |
| R3-detour | Python + FLINT | single process | 不经过奇点，沿固定复折线路径做普通点 Cauchy--DFT 输运 |

计时拆成：

1. exact 系统构造；
2. 奇点清单；
3. Moser balance 或指数结构分析；
4. 局部基构造；
5. 单次局部基求值或 bridge；
6. 端到端输运。

先跑 1x1、2x2 小 case。通过后再用相同基本块的 4、8、16 维 direct sum 单独测维数缩放；
所有路线保持相同的 N 维复矩阵，不做 2N 维实块化。每组先预热一次，再记录 3 次墙钟的
`min/median/max`。不得为了稳定小数重复 5 次以上。

建议固定两组工作点：

| profile | decimal digits | series order | sample count | max step/R |
| --- | ---: | ---: | ---: | ---: |
| validation | 50 | 32 | 96 | 0.25 |
| precision check | 100 | 40 | 128 | 0.25 |

一次只改变维数、精度或路线中的一个变量。若某路线正确性失败，其时间只记录为
`failed/provisional`，不得进入速度结论。

## 8. 数值验收标准

1. exact 变换恒等式、Laurent 系数消元和变换后 pole 阶使用 exact Q(i) 比较，差必须严格为零。
2. 对解析终值、手工路线和绕行路线分别报告 infinity-norm 绝对差与相对差。
3. 硬门槛为相对误差优于 `1e-10`；100 位、40 阶 profile 的目标为约 `1e-15` 到 `1e-20`。
4. 不在没有条件数、消减或最终 scalar 需求的情况下继续加阶追求远优于 `1e-20`。
5. 分支敏感 case 必须记录 detour 在上半还是下半平面、局部 `log` 约定和预期相位。
6. 每个 case 报告 `equal component count` 与 `nonzero-difference component count`，并列出维数。

## 9. Summary 最低字段

```json
{
  "schema": "flintnde_independent_high_pole_benchmark_v1",
  "package_version": "...",
  "python_version": "...",
  "python_flint_version": "...",
  "working_precision_digits": 100,
  "case_id": "H01",
  "dimension_complex": 1,
  "route": "R1-auto",
  "series_order": 40,
  "sample_count": 128,
  "path": ["..."],
  "local_method": "exponential_power_log",
  "exact_structure_check": "passed",
  "analytic_relative_error": "...",
  "manual_route_relative_error": "...",
  "detour_relative_error": "...",
  "equal_component_count": 1,
  "nonzero_difference_component_count": 0,
  "wall_time_seconds": {"min": 0.0, "median": 0.0, "max": 0.0},
  "status": "passed"
}
```

最终效率表固定包含 `route`、`language`、`parallel`、`wall time`、`total size` 和
`check/status`。另记录输入矩阵 SHA-256 或可复算的 exact coefficient payload。

## 10. 执行顺序和停止条件

1. Phase A：实现 H01、H06、N01，确认独立 oracle 和输出 schema。
2. Phase B：完成 H02--H09 与 N02--N05，只做正确性，不做规模计时。
3. Phase C：全部正确性通过后，按 R1/R2/R3 和固定 profile 计时。
4. Phase D：才允许做 4、8、16 维缩放；任一维数出现新失败立即停止更高维。
5. Phase E：写 summary 和效率结论，运行 package 全量单元测试确认 check 没有改变程序包行为。

以下任一情况必须停止并标记 `blocked` 或 `failed`：解析 oracle 不一致、自动路线与手工变换
路线不一致、绕行分支未固定、输出不在原始积分基、未认证 case 被当作成功、或不同路线没有
保持同输入/精度/路径/阶数。

## 11. 允许形成的结论

- 可以说明 exact Lee--Moser projector balance 或严格解耦指数 sector 在列出的 case 上正确、精度达到门槛、
  相对手工路线或绕行路线的同口径耗时是多少。
- 不可以由这些 case 宣称完成 Levelt--Turrittin、ramification、代数扩域或 Stokes matching。
- 不可以把 direct-sum 合成矩阵的缩放规律外推成任意真实 IBP DE 的性能。
- 不可以只因所有 leading eigenvalues 为零就宣称 `k=0` 已消除高阶 pole。
