# FlintNDE

`FlintNDE` 是准备独立发布的 Python/FLINT 矩阵微分方程数值包。首版有两个核心功能：
任意精度数值输运一阶矩阵微分方程，以及在固定 regulator 数值求解后重构“幂次解析、
系数数值”的半解析 Laurent/幂级数解。支撑这两个功能的可复用能力包括：


## 版本更新说明与分支

本规则生效后的每个新 FlintNDE 版本必须在对应 `versions/FlintNDE-X.Y.Z/` 中增加
`UPDATE_NOTES.md`，其中目录版本与 `pyproject.toml` 完全一致。文件至少记录
基线版本、新增功能、修复、公开接口或数值 convention 变化、迁移要求、验证状态和已知限制。
工作树只保留最新三个版本，更早版本可从 Git 历史恢复。

建议新版本从稳定主线新建独立 Git branch 开发和验证；branch 是否创建、保留或合并由用户
决定，不会因版本完成而自动合并到 `main`。

## 当前版本 0.4.0

当前源码位于 `versions/FlintNDE-0.4.0/`。FlintNDE 仍是通用单变量矩阵微分方程包：
`RationalMatrixSystem` 从矩阵元内部发现奇点，并在 exact 验证通过时自动采用
`A(x)=P(x)+Sum R_j/(x-p_j)` 快速路线，其中 `P(x)` 可为任意有限次数；高阶极点和
一般有理系统保留通用路线。用户无需预提取奇点或提供 dlog letters。

原始点由规划入口生成完整计划，执行入口只执行计划；缺省避开奇点，只有显式奇点折跃才
选择多值分支。任何经过中途节点的多点输运都可称为折跃，只有穿越奇点的局部基连接称为
奇点折跃；模式只接受 `singularity_jump` / `"SingularityJump"`（以及缺省的
`avoid` / `"Avoid"`）。Python 导入与 Wolfram 公开入口的缺省工作精度均为 200 位；工作位数为
`ceil(WorkingPrecisionDigits*log2(10))+32`，序列化计划记录规划精度，执行要求更高精度
时必须重新规划。0.4.0 另提供按节点覆盖桶的 fast multipoint evaluation，以及不调用
规划器的公开 `direct_user_point_path`。独立包和 MadStree v0.11 的 Vendor 保持同一实现。

Python 使用 `import flintnde`。Wolfram Language 把版本根加入 `$Path` 后可直接
`Needs["FlintNDE`"]`，使用 `FlintNDERationalSystem`、`FlintNDEPlanPath` 和
`FlintNDEExecutePath`。

Wolfram 入口的 `"WorkDirectory"` 明确表示临时运行根本身；`Automatic` 使用当前调用目录下
的 `results_temp/`，接口只在其下追加 `bridge/`，不重复追加任务名或第二层 `results_temp`。
Windows 完整路径超过传统 Win32/Wolfram 安全上限时，程序在写文件和启动 Python 前独立返回
`RuntimePathTooLong`。`RuntimeInputWriteFailed`、`PythonFlintUnavailable`、
`BridgeLaunchFailed` 和 `BridgeOutputMissing` 分别保留真实故障边界。
Python bridge 通过参数列表 `RunProcess` 启动，不经过 shell 命令拼接或重定向；连续调用不会
保留旧 `Run` launcher、引号转义 helper 或兼容 fallback。

- 一般解析矩阵在普通点的 Cauchy--DFT Taylor 系数重建与高精度输运；
- exact Q(i)(x) 矩阵逐元约分、有限/无穷远奇点发现与命名路径规划；
- 正则奇点的矩阵 indicial equation、Jordan/resonance gate 与 power-log 局部基；
- 高阶 pole 的 exact Lee--Moser projector-balance 降阶、可严格解耦 sector 的
  指数乘 power-log 局部基、可复用 `{phi,a,b,C}` 边界保存，以及单重不同主导根二阶 pole
  的起点形式渐近基；
- 正规化参数的自动采样、以 200 位为最低值的工作精度规划和 Laurent 幂级数解重构；显式
  取值可作为有序冗余候选池按拟合精度增量消费，候选耗尽时不会越界自动生成新点；也可
  只指定复角开区间，程序在内部均匀选择最多三条射线，模长仍按目标精度自动决定。

目录分工：

- `versions/FlintNDE-0.4.0/`：发布名为 `FlintNDE`、导入名为 `flintnde` 的可安装程序包与独立测试；
- `examples/`：通过顶部路径变量加载程序包的示例；
- `independent-validation-task/`：版本化独立检验任务书；
- `independent-validation/`：会先清除自身旧结果再 fresh 运行的独立 runner、summary 和报告；
- `Documentation/`：论文源文件、论文结构和发布路线规划；
- `../参考资料（文献、笔记、代码）/FlintNDE_ref/`：程序包论文与算法使用的外部参考资料。

调用脚本通过 `initialize_output_layout` 管理的正式输出统一放在该脚本旁的
`results/<调用脚本名或run_name>/`，再按 `configuration/`、`singularities/`、
`frobenius/`、`transport/`、`regularization/` 和 `summary/` 分类。程序包不向安装目录或不确定的
当前工作目录写这些 layout 输出。路径上的显式保存点是独立合同：用户只给
`(coordinate, "save")`，缺省立即写到调用目录 `Path.cwd()`；也可用
`save_output_directory` 显式指定调用者目录。两种路线都不向程序包安装目录写结果。

当前版本不依赖 BlackHoleQNM 的 IBP、积分族或运行配置。QNM 只作为一个独立的
二阶常微分方程示例放在 `examples/`，不进入程序包本体接口。

公开目录实际保留七个 examples：QNM 双端匹配、正则奇点 `{a,b,C}` 保存、指数型奇点
`{phi,a,b,C}` 保存/复用、Python 固定 `ep` 并行、自适应 Laurent 重构、Wolfram 固定 `ep`
并行和 Wolfram exact 矩阵接口。`ep_parallel.py` 与 `ep_parallel_mathematica.wl` 分别展示
`run_ep_tasks(..., parallel_task_count=12)` 与
`FlintNDEEvaluateEpBatch[..., ParallelTaskCount -> 12]`：缺省最多并行 12 个独立固定 `ep`
任务，实际并发为该值与任务数的较小者，超出的任务在 worker 完成后自动续交。这个任务级
选项不同于单进程 python-flint `ctx.threads`。

用户环境要求有三项：Python 3.10 或更高版本、`python-flint>=0.6` 和 `sympy>=1.12`。安装发布的
wheel、从源码普通安装以及开发者可编辑安装分别为

```powershell
python -m pip install .\flintnde-0.4.0-py3-none-any.whl
python -m pip install "path\to\package-FlintNDE\versions\FlintNDE-0.4.0"
python -m pip install -e path/to/package-FlintNDE/versions/FlintNDE-0.4.0
```

前两种方式均不要求用户自行构建；`pip` 会自动安装 `python-flint` 与 `sympy`。

0.4.0 当前聚焦回归覆盖通用有理矩阵、任意次数多项式加简单极点、默认避奇点、显式奇点折跃、
Arb 路径 round-trip、fast multipoint、严格用户节点、精度拒绝和运行路径门禁；Python
`unittest discover` 166/166 通过，Wolfram `Needs["FlintNDE`"]` 端到端检查为 25/25。
完整验证结果以
`versions/FlintNDE-0.4.0/UPDATE_NOTES.md` 和根进度表的最新记录为准。

2026-08-13 的 0.4.0 独立检验检查 257 点 fast/Horner 单节点桶和 30x30 复网格。
planned 路线使用 2 个节点并 fast 覆盖 899 点；direct 路线严格使用 901 个节点，全部 900 点
两分量通过闭式解和相互误差门禁。任务书、实际节点、逐点差值和效率见
`independent-validation/FlintNDE-0.4.0-validation-01-fast-multipoint-and-direct-path/`。

安装一次后，任意目录 `A` 中的调用脚本都可直接 `import flintnde`，无需把 package 源码
复制到 `A`。脚本调用 `initialize_output_layout(__file__, run_name=...)` 后，所有由该 layout
管理的输出写入 `A/results/<run_name>/`。配置既可直接写在调用脚本中，也可由脚本读取同目录
JSON/TOML 等文件；当前没有“只提交配置文件、无需 Python 调用脚本”的命令行入口。

程序包运行时只依赖 `python-flint>=0.6`。exact Q(i) residue 是缺省路线，使用 FLINT
精确判别 log 结构，失败时不自动降级；只有浮点 residue 才使用按输入可靠精度和矩阵
尺度生成的可调斩杀线，并在 warning 与 manifest 中报告最大被判零量。Python
binary64 输入按 15 位可靠十进制数处理。普通点的 Cauchy--DFT 是矩阵系数重建，不是对解做
回归；奇点局部解不会回退到不含 log 的纯多项式拟合。

exact Gaussian-rational 输入使用 `RationalMatrixSystem`。每个精确复数以两个 `fmpq` 保存，
每个复矩阵以两张同维 `fmpq_mat` 保存，不把 N 维复系统扩成 2N 维实系统。每个矩阵元由
`rational_function` 指定，分子和分母系数按变量幂次从低到高排列。程序先在 Q(i)[x] 中对
完整矩阵元做 exact `gcd` 约分，再对唯一分母做 square-free 分解并用 Acb ball 隔离全部
复根；因此同一矩阵元内相消的候选 pole 不会进入奇点清单。若 square-free 因子同时含精确零根
和不在 Q(i) 中的代数根，程序先精确抽出 `x` 因子，使零根保留 `location_exact=0` 并进入
exact Frobenius 调度，其余根继续由 Acb 隔离。无穷远使用 `sinv=1/s`，完整变换为
`dY/dsinv=-sinv^(-2) A(1/sinv)Y`，不会漏掉微分算符的 Jacobian。

exact 标量接受整数、`fmpq`、分数/十进制字符串、`"a+b*I"` 字符串、`(real, imag)` 二元组
和 `{"real": ..., "imag": ...}` 字典。Python `float`、`complex`、`arb` 和 `acb` 不进入
exact 路线；这类输入应显式使用数值系统并声明可靠输入精度。Q(i) 奇点可继续进入自动
奇点清单、无穷远分类、自适应路径和 exact Frobenius 调度。若 indicial polynomial 不能在
Q(i) 中完全分裂，exact gate 会 fail closed；一般代数奇点仍可由 Acb 定位，但当前 exact
Frobenius 不在一般代数数域上自动运算。

`prepare_local_expansion` 统一选择普通点 Cauchy--DFT、正则奇点 power-log 或高阶 pole
局部基。完整矩阵中出现二阶或更高 pole 时，清单仍只标记
`non_fuchsian_input_basis`，不把它误认证为基底不变量意义下的不规则奇点。局部调度先在
原基逐轮执行 exact Lee--Moser 降阶：由最高两阶 Laurent 矩阵构造 nilpotent Jordan
链和 projector，应用 `I=(1-Q+Q/z)J`，每步重新检查完整矩阵 pole 阶严格下降，并保存
全部 projectors、顺序、逐步 pole 阶与 exact round-trip。非 nilpotent 最高阶项或 Moser
构造不能认证时，再尝试严格解耦的 `exp(Phi(z))` 乘 power-log sector；仍不能认证则
fail closed。
`build_adaptive_path` 返回可直接作为数值输运路径参数的 `list[acb]`。普通点的
收敛半径取最近奇点距离，奇点的收敛半径取最近的其他奇点距离；实际步长另由用户选择的
`max_step_over_radius` 乘该半径限制。任一路段穿过内部奇点时，缺省
`singularity_mode="avoid"` 返回含奇点与对应路段的结构化拒绝；用户可用
`detour_points` 自选复平面绕行点。只有显式 `singularity_mode="singularity_jump"`
才建立两侧普通匹配点和局部基 bridge，并要求用户确认等价绕行类的多值分支。进入奇点的
步长以该奇点的收敛半径为分母。路径按
顺序报告完整 `step/R` 列表及其最大值。一般 formal block decoupling、
对二阶 pole 且主导根在 Q(i) 中单重互异时，还可逐 sector 精确递推形式
`exp(-k/z) z**rho Sum[v_n z**n]`。程序固定计算到用户要求的 `N` 阶，再额外计算五阶；报告
后五阶项矢量和无穷范数与前五阶项矢量和无穷范数之比，以及五阶相对 refinement。该路线只允许作为
路径起点；中间点或终点因没有 Stokes connection 而拒绝。重复/defective formal block、
ramification、代数扩域和 Stokes matching 尚未实现。

公开 `five_term_tail_diagnostic(terms,N,threshold=...)` 另用于 caller 已生成的标量项序列。
它返回可读取的 `FiveTermTailDiagnostic`，按
`abs(sum(T[N+1:N+6]))/sum(abs(T[N-4:N+1]))` 保存分子、分母、比值、阈值与严格小于的
门禁状态。该标量判据不替换上述矩阵形式分支的矢量块比；零分母或区间无法严格证明通过时
必须 fail closed。

在正式输运前可先调用 `build_adaptive_path_plan` 做能力预检。它对起点、终点和每个内部
奇点运行同一局部调度器，并返回 `continuation_ready`、每个奇点的分类、已认证 method 和
拒绝原因。`continuation_ready=False` 表示当前程序不能完成这条路径，调用者必须更换普通
绕行点或提供外部局部/Stokes 数据；不得继续调用输运把未知奇点当普通点。直接调用
`build_adaptive_path` 时，同一情况抛出 `LocalReductionError`。程序不会在 exact gate、
Lee--Moser 或 formal gate 失败后静默降级成普通 Taylor/Cauchy 路线。这一预检不只针对
高阶 pole：正则奇点的位置不在 Q(i)，或位置虽在 Q(i) 但 exact indicial/Jordan/resonance
结构超出当前 power-log 能力时，同样返回 `continuation_ready=False` 并禁止正式建路。

路径中需要保留结果的坐标直接写成 `(coordinate, "save")`，不为 point 取名字：

```python
path = [(z0, "save"), z1, (z2, "save")]
result = transport_path_refined(system, boundary, path)
```

adaptive path 的起点、终点和 `detour_points` 也接受同一标签。每到达一个保存点，程序立即按
路径次序写 `flintnde_save_001.json`、`flintnde_save_002.json` 等文件；全部输运成功后再写
`flintnde_save_points.json` 汇总。中途失败时，已经完成的逐点文件保留，但不写虚假的完整汇总。
refinement 只保存 reference chain，避免同一坐标出现两套结果。普通点记录含坐标和 Acb 结果
列向量；正则奇点记录含可再次输入的 `{a,b,C}`；已认证的严格解耦指数型奇点记录含
`{phi,a,b,C}`，表示 `exp(phi(z)) z^a log(z)^b C`。带 `"save"` 的中间奇点在局部 bridge
反解常数后立即保存。程序不把奇点处通常不存在的有限 `Y(z_*)` 冒充为结果。Lee--Moser 后
尚无原基逆局部 jet 的情形和需要 Stokes 数据的中间/终点仍 fail closed。

FlintNDE 的普通 `transport_path` / `transport_path_refined` 已能在正则奇点起点或终点保存
可复用的 `{a,b,C}` 边界常数；JSON 的 `resultType` 为 `frobenius_boundary`，`result.terms`
可直接再次作为边界输入。指数型本性奇点对应 `resultType: "exponential_boundary"`；
`result.terms` 可直接交给 `exponential_boundary`。下面的限制只针对不写中途文件的多列
批量加速入口，不是用户级奇点边界保存能力的限制。

同一 exact `RationalMatrixSystem` 若有多个 Frobenius 初值，可调用
`transport_frobenius_boundaries_refined` 批量输运。主链与参考链分别只构造一次局部基，并在
每个普通段只构造一次 Taylor 矩阵，再把不同初值作为矩阵列同时推进；返回值仍逐列保存
`relative_differences_inf` 与 `target_relative_error_met`。当前批量入口要求奇点启动后的全部
transition 都是 `ordinary_taylor`，且不直接处理路径 `save` 标签。MadStree adapter 对多个
奇点分支且没有保存点的情形自动选择批量入口；用户要求保存普通点或奇点边界常数时则自动
回退到 `transport_path_refined` 逐分支处理，保存功能保持完整。

奇点起点使用 `frobenius_boundary([{"a": a, "b": b, "C": [...]}, ...])` 指定
`z**a log(z)**b C` 的最高 log 领头项；有限奇点的 `z=s-s0`，无穷远的 `z=sinv=1/s`。
程序以 exact Q(i) manifest 验证 `a`、`b` 和完整主积分系数矢量 `C`，自动生成 Jordan
分支的低次 log completion，并在首个普通匹配点初始化输运。格式不符、`C` 不在要求的
本征/广义本征子空间或把普通有限值冒充奇点边界时，均在计算前拒绝。指数型奇点边界只接受显式输入/保存格式
`exponential_boundary([{"phi":[{"power":-1,"coefficient":-k}],"a":a,"b":b,"C":[...]}])`；
缺少 `phi` 或含有额外字段时直接拒绝。
这里 `phi(z)=Sum[c_p z^p]` 只含负整数幂；`phi=[]` 明确表示该 sector 的 `exp(phi)=1`。
程序会把每项与高阶 Laurent 矩阵推出的 sector
逐项 exact 比较，跨多个指数 sector 的 `C` 必须拆成多项。该 Frobenius 协议也由
`reconstruct_series_solution` 的 `boundary(ep)` 直接复用。

实际 16 维 kECep 单点测试见 `test/test_kECep_16x16.py`。该测试只消费共享 OOO-232 EC
资源，在一个物理点上检查一般矩阵系数、短程输运、epsilon=0 共振 log、power-log 基、
3+1 个 regulator 样本的重构，以及通用 `RationalMatrixSystem over Q(i)(k)` 的自动奇点和
exact Frobenius 全链。当前结果为 `passed`，位于
`test/results_test/kECep_16x16_ooo232/summary.json`。

`reconstruct_series_solution` 已作为公开高层接口实现。调用方给出 `DEmatrix`、
`boundary`、`path`、目标 `maximum_power`、符号认证的整数 `leading_power` 及其严格证书。
FlintNDE 面向任意 callable 时不具备证明 Laurent 支撑的符号信息，因此不再用数值 pilot
猜最低阶；MadStree 会从自己的符号边界与 dlog DE 自动生成证书。每个生产点
和独立验证点都复用同一基础输运函数，生产样本使用 FLINT Acb 方阵插值，不使用最小二乘
或伪逆。自动样本数、参数量级和工作精度采用文献中 AMFlow 2.0 的经验公式，但程序包内的
功能名称统一为“幂级数解重构”，不暴露 AMFlow 命名的接口。

## 当前边界

power-log 是首版基础功能。当前可自动处理能被 exact Lee--Moser projector balances
降到 simple pole 的 Q(i)(x) 输入基，以及高阶 Laurent 系数在同一 exact 常数基中对角、不同指数 signature 之间完整
解耦、抽掉指数后至多 simple pole 的系统。对 `A_{-2}=k`，指数为 `exp(-k/z)`；`k=0`
只表示该 sector 没有这一标量指数，不能消除 nilpotent/off-diagonal 高阶约束。一般
一般 Katz/Levelt--Turrittin formal gauge、ramification 与 Stokes matching 仍未实现
并保持 fail closed。

出现 `exp(-k/z)` 不意味着其余级数必然只是渐近级数。当前指数路线会抽掉完整的已认证
标量高阶部分，并重新检查 residual 系统；只有 residual 至多为 simple pole 时才调用
收敛的 Frobenius power-log 级数，其收敛半径仍由最近其他奇点决定。若 residual 仍有高阶
非对角项，或需要无穷 formal gauge 才能逐阶消元，则一般只得到依赖 Stokes sector 的
Gevrey/渐近级数。当前只实现上述单重二阶-pole 的起点递推；最近其他奇点距离只作首匹配点
参考尺度，不是收敛半径。自动选点对每个指数根 `k_i` 取最近根差
`Delta_i=min_{j!=i}|k_i-k_j|`，用 `n_min≈Delta_i/|z|` 估计最小项阶数；缺省令
`n_min≈3N`，即请求阶数 `N` 约取预计最小项阶数的三分之一。`step/R` 只有给出更小步长时才
进一步限制。实际验收始终看额外五阶：
五阶块比必须小于 1；否则结果仍生成，但 warning 和 report 都标明收敛性问题。其它
formal/Stokes 情形继续 fail closed。
