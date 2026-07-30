# FlintNDE

`FlintNDE` 是准备独立发布的 Python/FLINT 矩阵微分方程数值包。首版有两个核心功能：
任意精度数值输运一阶矩阵微分方程，以及在固定 regulator 数值求解后重构“幂次解析、
系数数值”的半解析 Laurent/幂级数解。支撑这两个功能的可复用能力包括：

更名记录：2026-07-28，开发名 `NDEs-flint` 改为 `FlintNDE`，Python 导入名由
`ndes_flint` 改为 `flintnde`。当前为发布前开发版本，不保留旧导入名兼容层。

## 版本更新说明与分支

本规则生效后的每个新 FlintNDE 版本必须在对应 `versions/FlintNDE-vX.Y.Z/` 中增加
`UPDATE_NOTES.md`，其中目录版本与 `pyproject.toml` 完全一致。文件至少记录
基线版本、新增功能、修复、公开接口或数值 convention 变化、迁移要求、验证状态和已知限制。
当前 `0.1.0.dev0` 及此前已有资产不追溯补建。

建议新版本从稳定主线新建独立 Git branch 开发和验证；branch 是否创建、保留或合并由用户
决定，不会因版本完成而自动合并到 `main`。

- 一般解析矩阵在普通点的 Cauchy--DFT Taylor 系数重建与高精度输运；
- exact Q(i)(x) 矩阵逐元约分、有限/无穷远奇点发现与命名路径规划；
- 正则奇点的矩阵 indicial equation、Jordan/resonance gate 与 power-log 局部基；
- 高阶 pole 的 exact Lee--Moser projector-balance 降阶、可严格解耦 sector 的
  指数乘 power-log 局部基、可复用 `{phi,a,b,C}` 边界保存，以及单重不同主导根二阶 pole
  的起点形式渐近基；
- 正规化参数的自动采样、工作精度规划和 Laurent 幂级数解重构。

目录分工：

- `versions/FlintNDE-v0.1.0.dev0/`：发布名为 `FlintNDE`、导入名为 `flintnde` 的可安装程序包与独立测试；
- `examples/`：通过顶部路径变量加载程序包的示例；
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

用户环境要求只有两项：Python 3.10 或更高版本，以及 `python-flint>=0.6`。安装发布的
wheel、从源码普通安装以及开发者可编辑安装分别为

```powershell
python -m pip install .\flintnde-0.1.0-py3-none-any.whl
python -m pip install "path\to\package-FlintNDE\versions\FlintNDE-v0.1.0.dev0"
python -m pip install -e path/to/package-FlintNDE/versions/FlintNDE-v0.1.0.dev0
```

前两种方式均不要求用户自行构建；`pip` 会自动安装 `python-flint`。

2026-07-30 fresh 执行 `python -m unittest discover -s tests -v` 通过 `76/76`，wall time
为 `8.653 s`。其中包含正则奇点 `{a,b,C}`、指数型奇点 `{phi,a,b,C}` 的起点/终点/中间点
保存与重用、多列 Frobenius 批量输运、高阶 pole、Lee--Moser 与超能力 fail-closed 回归。

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
`max_step_over_radius` 乘该半径限制。任一路段穿过内部奇点时，程序会提示用户可用
`detour_points` 自选复平面绕行点，但不阻断路径生成。若用户保持原路径，内部奇点由两侧
普通匹配点和自动局部基 bridge 处理；进入奇点的步长以该奇点的收敛半径为分母。路径按
顺序报告完整 `step/R` 列表及其最大值。一般 formal block decoupling、
对二阶 pole 且主导根在 Q(i) 中单重互异时，还可逐 sector 精确递推形式
`exp(-k/z) z**rho Sum[v_n z**n]`。程序固定计算到用户要求的 `N` 阶，再额外计算五阶；报告
后五阶项矢量和无穷范数与前五阶项矢量和无穷范数之比，以及五阶相对 refinement。该路线只允许作为
路径起点；中间点或终点因没有 Stokes connection 而拒绝。重复/defective formal block、
ramification、代数扩域和 Stokes matching 尚未实现。

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
本征/广义本征子空间或把普通有限值冒充奇点边界时，均在计算前拒绝。旧输入仍可让指数
sector 由 `C` 自动推断；可移植的显式输入/保存格式为
`exponential_boundary([{"phi":[{"power":-1,"coefficient":-k}],"a":a,"b":b,"C":[...]}])`。
这里 `phi(z)=Sum[c_p z^p]` 只含负整数幂；`phi=[]` 明确表示该 sector 的 `exp(phi)=1`。
程序会把每项与高阶 Laurent 矩阵推出的 sector
逐项 exact 比较，跨多个指数 sector 的 `C` 必须拆成多项。该 Frobenius 协议也由
`reconstruct_series_solution` 的 `boundary(ep)` 直接复用。

实际 16 维 kECep 单点测试见 `test/test_kECep_16x16.py`。该测试只消费共享 OOO-232 EC
资源，在一个物理点上检查一般矩阵系数、短程输运、epsilon=0 共振 log、power-log 基、
3+1 个 regulator 样本的重构，以及通用 `RationalMatrixSystem over Q(i)(k)` 的自动奇点和
exact Frobenius 全链。当前结果为 `passed`，位于
`test/results_test/kECep_16x16_ooo232/summary.json`。

`reconstruct_series_solution` 已作为公开高层接口实现。最小调用只需给出 `DEmatrix`、
`boundary`、`path` 和目标 `maximum_power`；最低幂缺省由 pilot NDE 自动判断。每个生产点
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
