# FlintNDE Python package

自 2026-07-28 起，发布名使用 `FlintNDE`，Python 导入名使用 `flintnde`；旧开发导入名
`ndes_flint` 不再作为兼容入口。

## 版本更新说明

本规则生效后，每次修改 `pyproject.toml` 中的 FlintNDE 版本号，都必须在本目录增加
`UPDATE_NOTES_<version>.md`。更新说明至少包含基线版本、新增与修复内容、公开接口或数值
convention 变化、迁移要求、已执行验证和已知限制；文件中的版本必须与 `pyproject.toml`
一致。当前 `0.1.0.dev0` 及此前已有资产豁免，不追溯补建。建议在独立版本 branch 中完成
开发和验证，但是否创建或合并 branch 完全由用户决定。

首版公开接口分为以下部分：

- `initialize_output_layout` / `OutputLayout`：在调用脚本旁建立分层结果目录；
- `GaussianRational` / `gaussian_rational`：不增加依赖的 Q(i) 精确复数公开输入；
- `RationalMatrixSystem` / `analyze_singularities`：exact Gaussian-rational 矩阵与完整奇点清单；
- `NamedPoint` / `prepare_local_expansion` / `build_adaptive_path`：统一局部调度与自描述可执行路径；
- `AnalyticMatrixSystem`：接收任意返回 FLINT `acb_mat` 的解析矩阵函数；
- `transport_path` / `transport_path_refined`：普通点输运与统一奇点局部基 bridge；
- `transport_frobenius_boundaries_refined`：共享局部基和普通段 Taylor 矩阵的多列 Frobenius
  初值输运，并逐列报告 refinement；
- `RegularSingularSystem` / `build_frobenius_manifest` / `build_power_log_basis`：
  exact-first 的正则奇点局部解；
- `frobenius_boundary` / `FrobeniusBoundary`：验证奇点起点的 `{a,b,C}` 领头分支；
- `exponential_boundary` / `ExponentialBoundary`：验证指数型奇点的 `{phi,a,b,C}` 可复用边界；
- `attempt_fuchsian_reduction` / `build_local_solution_basis`：高阶 pole 的 exact Lee--Moser balance
  与认证指数 sector；
- `five_term_tail_diagnostic` / `FiveTermTailDiagnostic`：对 caller 给出的标量渐近项执行可读取的
  前后五项严格阈值门禁；
- `NumericalRegularSingularSystem` / `NumericalFrobeniusOptions`：没有 exact residue 时的
  精度感知结构判别；
- `reconstruct_series_solution` / `SeriesReconstructionResult`：复用完整 NDE 输运，重构
  正规化参数的幂级数解。
- `fit_sampled_series`：对调用方已经计算的标量或列矢量样本作 Laurent/Taylor 方阵重构；
  源采样标签可与实际代入的正规化数值点分开指定。
- `flintnde.regular_point_de`：固定 regulator 后的 pole/residue 系统、Watson 边界、
  普通点输运、认证的 k=0 Frobenius 局部解与 finite part。
- `flintnde.epsilon_jet_de`：解析 epsilon jet 的普通点输运、联合 epsilon/k 局部解与
  finite-part 系数，不使用浮点 epsilon 采样拟合。

普通点默认通过 Cauchy 圆周采样和离散 Fourier 投影恢复矩阵 Taylor 系数。该接口
只要求采样圆内解析，不要求矩阵预先拆成常数项与单极点 residue。

调用脚本用 `initialize_output_layout(__file__, run_name=None)` 初始化输出。缺省目录为
`<脚本目录>/results/<脚本stem>/`；`run_name` 只能是单层直观名称。固定分类为
`configuration`、`singularities`、`frobenius`、`transport`、`regularization`、`summary`，其中只有
`configuration/output_layout.json` 在初始化时创建，其余目录按实际输出懒创建。

## 安装与调用位置

用户环境要求 Python 3.10 或更高版本、`python-flint>=0.6` 和 `sympy>=1.12`。三种安装方式为：

```powershell
# 安装发布的 wheel；用户无需自行构建
python -m pip install .\flintnde-0.1.0-py3-none-any.whl

# 从下载的源码普通安装
python -m pip install "path\to\package-FlintNDE\versions\FlintNDE-0.1.0"

# 开发者可编辑安装
python -m pip install -e "path\to\package-FlintNDE\versions\FlintNDE-0.1.0"
```

`pip` 会自动安装满足版本要求的 `python-flint` 与 `sympy`。安装一次后，可在任意目录 `A` 的脚本中
直接 `import flintnde`。不需要复制源码；输出位置也不取决于 package 安装目录或启动命令的
当前目录，而只取决于传给 `initialize_output_layout` 的调用脚本路径。配置文件本身不会自动
触发计算，`A` 中仍需一个 Python 调用脚本读取配置并调用公开接口。

## 正规化参数的幂级数解重构

最小调用只指定完整 NDE 问题和用户需要返回的最高 regulator 幂：

```python
from flintnde import reconstruct_series_solution

series_result = reconstruct_series_solution(
    DEmatrix=DEmatrix,
    boundary=boundary,
    path=path,
    maximum_power=2,
)
```

若矩阵、边界或奇点位置依赖 `ep`，用工厂保持每个自动生成的有理样本在构造矩阵时仍是
exact rational：

```python
def DEmatrix(ep):
    # 自动 rationalization 时 ep 是 FLINT fmpq。
    return build_system_at(ep)

def boundary(ep):
    return build_ordinary_initial_vector_at(ep)

def path(ep, system_at_ep):
    return build_path_at(ep, system_at_ep)
```

固定的 `AnalyticMatrixSystem`/`RationalMatrixSystem`、边界和 `list[acb]` 也可直接传入。
普通点边界是 `acb_mat` 或标量列表；正则奇点边界使用下文的 `frobenius_boundary`。
`boundary(ep)` 可以按每个 regulator 样本返回其中任一种格式。

完整可选项为：

```python
series_result = reconstruct_series_solution(
    DEmatrix=DEmatrix,
    boundary=boundary,
    path=path,
    maximum_power=2,
    series_parameter="ep",
    goal_digits=30,
    sample_points="automatic",
    leading_power="automatic",
    sample_count="automatic",
    base_sample="automatic",
    sample_spacing=0.01,
    working_precision_digits="automatic",
    extra_working_precision=0.0,
    transport_order="automatic",
    transport_extra_order="automatic",
    transport_sample_count="automatic",
    transport_extra_sample_count="automatic",
    radius_fraction=0.60,
    guard_bits=32,
    pilot_sample_count=4,
    pilot_base_sample="automatic",
    pilot_ratio=0.5,
    pilot_max_rounds=3,
    leading_power_tolerance="automatic",
    validation_sample_count=2,
    validation_points="automatic",
    validation_scale=0.5,
    validation_tolerance="automatic",
    maximum_samples=100,
    rationalize_sample_points=True,
    output_layout=None,
    result_name="series_reconstruction",
)
```

`maximum_power=m` 是唯一必填的展开阶数。最低幂 pilot 在多个嵌套小 `ep` 点分别构造
边界和 DE，并完成同一条 NDE 输运，再由终点矢量的分量模比判定最低整数幂 `n_min`；
不稳定、非整数或含混的零分量会抛出 `LeadingPowerDetectionError`。不能只把边界与 DE
矩阵元的最低幂简单相加：含 regulator 负幂的 DE 可能产生非 Laurent 行为，完整输运
pilot 才是这里采用的覆盖判据。

`leading_power="automatic"` 直接采用 pilot 检出的 `n_min`。显式给出整数时仍运行同一个
pilot 作覆盖审计，但保留用户指定值；若用户值高于 `n_min`，FlintNDE 发出 `UserWarning`，
说明哪些低幂将被遗漏，并把检测值及覆盖状态写入 `diagnostics["pilot"]`。显式给出更低的
幂次是允许的，只会保留额外的零系数候选。随后定义

```text
P = max(0, -n_min)
K = m - n_min
N_fit = max(ceil(5 K / 2 + P), K + 1)
alpha_ep = P / 4 + goal_digits / (K + 1)
ep0 = 10^(-alpha_ep)
p0 = max(ceil((N_fit + P) alpha_ep), 30)
working_precision_digits = ceil(2 (1 + extra_working_precision) p0)
```

全部 `N_fit` 个生产点用于一个 Acb 方阵插值，内部拟合到
`n_min + N_fit - 1`，只把 `n_min..maximum_power` 返回用户；不使用最小二乘或伪逆。
`transport_order=4*p0`，`transport_extra_order=ceil(max(50,p0/5))`，后者作为参考链增加的
阶数。`transport_sample_count` 和 `transport_extra_sample_count` 分别覆盖两条 Cauchy--DFT
链的圆周点数；`"automatic"` 继续使用基础输运的 `max(32,2*order)`。

独立验证点缺省位于生产网格的 `validation_scale` 倍尺度；也可用字符串、`fmpq` 或 `acb`
序列显式传入 `validation_points`。验证点完全不参与插值；NDE 主/参考链以及
返回截断级数都必须通过 `validation_tolerance`，缺省为 `10^(-goal_digits)`，否则抛出
`SeriesValidationError`。显式 `sample_points` 应使用字符串、`fmpq` 或 `acb`，不接受会掩盖
输入精度的 Python `float/complex`。`rationalize_sample_points=False` 会让自动 pilot、生产和
验证点以 Acb 而非 `fmpq` 传给工厂。

结果的 `powers` 与 `coefficients` 一一对应；`coefficient(power)` 取单阶系数矢量，
`evaluate(ep)` 计算返回的截断级数。`sample_values`、`validation_values`、
`effective_parameters` 和 `diagnostics` 保存生产值、验证值、实际生效配置、每次 NDE refinement
与残差。提供 `output_layout` 时，JSON 写入调用脚本旁
`results/<run>/regularization/<result_name>_series_reconstruction.json`。

若目标量不是单条 NDE 的终点矢量，而是调用方已组合出的 Wronskian 或其它标量，可直接
复用相同的 Acb 方阵拟合层。下面以实轴奇点上方的 lateral 样本为例：`sample_points`
保存正的 `delta` 标签，`regularization_points` 才是级数变量 `+delta`。下方 lateral
使用同一组正标签，并把正规化点改为 `-delta`。

```python
from flintnde import fit_sampled_series

fit_plus = fit_sampled_series(
    sample_points=("0.006", "0.0041", "0.0027", "0.0013"),
    sample_values=(w_plus_1, w_plus_2, w_plus_3, w_plus_4),
    regularization_points=("0.006", "0.0041", "0.0027", "0.0013"),
    maximum_power=3,
    leading_power=0,
    validation_points=("0.0008", "0.00045"),
    validation_values=(w_plus_validation_1, w_plus_validation_2),
    validation_regularization_points=("0.0008", "0.00045"),
    validation_tolerance="1e-20",
    series_parameter="signed_iw_delta",
)
w_plus_limit = fit_plus.coefficient(0)[0, 0]
```

`regularization_points` 与 `validation_regularization_points` 都可缺省；缺省时分别直接
使用 `sample_points` 与 `validation_points`，输入格式、系数和摘要字段保持原接口行为。
显式提供时，两组点必须分别一一对应、非零且互异，验证正规化点还必须与生产正规化点
分离。该接口不重算 NDE，也不改变 FLINT 全局精度；全部生产正规化点一次进入方阵
Vandermonde 求解，不使用最小二乘或伪逆，验证点只用于残差和 fail-closed 门禁。

## 包内 regular-point 与 epsilon-jet DE

固定 regulator 的矩阵系统从 `flintnde.regular_point_de` 导入。它接收已经完成
convention 数值代入的 pole/residue payload，提供 Watson 边界、普通点 Taylor 输运、
由 exact manifest 认证的 `k=0` 局部基和有限部读取。解析 regulator jet 使用同一模块的
中性 `regulator` 接口。

```python
import flintnde.regular_point_de as regular_de
import flintnde.epsilon_jet_de as epsilon_de
```

`flintnde.epsilon_jet_de` 在此基础上处理截断的 epsilon 系数矢量。epsilon 只作为解析
jet 逐阶进入矩阵、边界和局部递推；普通点输运及联合 epsilon/k Frobenius 解都不需要
多个浮点 epsilon 样本。两模块均属于 FlintNDE 包，调用方只把包根加入导入路径并核对
实际模块文件位于该包根之下。
## exact Q(i) 输入、奇点清单与统一路径

自动奇点发现不从数值黑箱回归分母。矩阵元应写成 exact rational coefficient records；系数
顺序恒为常数项、一次项、二次项等：

```python
from flintnde import *

layout = initialize_output_layout(__file__, run_name="physical_point_01")
system = RationalMatrixSystem(
    (
        (rational_function([0, "1+I"], ["-2-3*I", 1]), 0),
        (0, rational_function({"real": "1/3", "imag": "-2/5"}, [1, 0, 1])),
    ),
    variable_name="s",
    name="example-system",
)
inventory = analyze_singularities(system, output_layout=layout)
path = build_adaptive_path(
    system,
    NamedPoint("left_boundary", 2),
    NamedPoint("right_match", 3),
    path_name="left_to_right",
    max_step_over_radius=0.45,
    output_layout=layout,
)
local = prepare_local_expansion(
    system,
    NamedPoint("left_boundary", 0),
    order=32,
    radius_fraction=0.60,
    sample_count=96,
    output_layout=layout,
)
```

`numerator` 和 `denominator` 中每个 exact 系数可使用以下任一格式：整数、FLINT `fmpq`、
分数/十进制字符串、`"a+b*I"` 字符串、`(real, imag)` 二元组，或
`{"real": ..., "imag": ...}` 字典。`gaussian_rational(value)` 可单独验证并标准化这些输入，
返回 `GaussianRational`。Python `float`、`complex`、`arb` 和 Acb ball 会被 exact 路线拒绝；
它们只能进入显式 numerical 接口，不能靠提高 FLINT 工作精度恢复已经丢失的输入位数。
由于 `rational_function((c0, c1))` 的 tuple 本身表示按幂次排列的多项式系数，单个复常数若用
二元组，应写成 `rational_function([("a", "b")])` 或先调用
`rational_function(gaussian_rational(("a", "b")))`，避免把实部、虚部误读成常数项和一次项。
若一个矩阵元由多个分式项组成，用
`rational_function(...) + rational_function(...)` 先形成完整矩阵元，程序会 exact 合并约分，
再收集约分后分母。一般 `AnalyticMatrixSystem` 的回调无法从有限采样可靠恢复全部 pole，仍须
显式给 `singularities`。

一个实际 16 维 complex-exact kECep 系统的单点测试位于
`../../test/test_kECep_16x16.py`。它通过通用 `RationalMatrixSystem over Q(i)(k)` 自动发现
7 个有限复奇点，并在 epsilon=0 由 exact gate 得到 roots `0, 9`、重数 `14, 2`、14 个
active resonance gate 和一阶 log；没有调用 kECep 专用 package 类。普通点、短程输运、
numerical fallback、power-log 基与 3+1 样本重构也在同一脚本中通过。完整结果见
`../../test/results_test/kECep_16x16_ooo232/summary.json`。

Q(i)[s] 分母能严格分裂出的奇点会保存 `location_exact`，并可直接进入 exact 局部调度。
若一个 square-free 因子同时含零根和不在 Q(i) 中的代数根，奇点发现会先精确除出 `s`；
因此边界起点 `s=0` 仍保存 `location_exact="0"` 与因子 `("0","1")`，不会因同组其它根
需要 Acb 隔离而丢失 exact 身份。
一般代数根仍可通过 Acb ball 隔离并进入奇点清单，但 `regular_singular_system_at` 当前只在
奇点属于 Q(i) 时构造 exact Frobenius 数据。indicial polynomial 也必须完全分裂于 Q(i)；
否则 exact gate fail closed，且不会自动转用阈值分类。只有用户原始输入本来就是浮点数据时，
才应显式构造 `NumericalRegularSingularSystem`。

奇点 pole 阶由完整矩阵的所有矩阵元共同决定，不能只检查对角元。若任一约分后矩阵元在
某点有二阶或更高 pole，清单记录为 `non_fuchsian_input_basis`。这只说明输入基底不是
Fuchsian；局部调度随后按三层路线处理：

1. 逐轮由最高两阶 Laurent 矩阵构造 exact Lee--Moser projector，应用
   `I=(1-Q+Q/z)J`；每步要求 `Q^2=Q` 且完整矩阵 pole 阶严格下降，并保存 ordered
   projectors、逐步 pole 阶和正逆系统 exact round-trip；
2. 若仍有高阶 pole，尝试在 Q(i) 中 exact 对角化 leading matrix，并只接受所有高阶 Laurent
   矩阵同为对角、不同指数 signature 之间完整有理矩阵元严格为零的 sector；
3. 抽掉每个 sector 的标量指数后，残余系统必须至多为 simple pole，否则 fail closed；

在第二条路线中 `Phi'(z)=sum_{m>=2} c_m z**(-m)`，所以
`Phi(z)=-sum_{m>=2} c_m/(m-1) z**(-(m-1))`。特别地，`A[-2]=k` 给出
`exp(-k/z)`。`k=0` 只表示没有该标量指数，不能把 defective/nilpotent 高阶块变成正则奇点。
4. 若严格解耦失败，但 pole 阶恰为二、`A_-2` 在 Q(i) 中有单重互异谱，则构造
`exp(-k/z) z**rho Sum[v_n z**n]` 的 exact 形式递推。每次固定求到用户指定的 `N` 阶，并额外
生成 `N+1,...,N+5` 五阶用于块比和相对 refinement；仍同时报告最小项位置作为诊断，但不据此
提前截断。该方法仅可作为奇点起点；内部/终点需要 Stokes
connection，因而 fail closed。

当前 Moser 路线在 exact Q(i)(x)、有限局部变量和无 ramification 的 meromorphic gauge
范围内工作。需要重复/defective formal block、代数数域扩张、ramification 或 Stokes
矩阵的系统继续拒绝，也可由用户显式给普通绕行路径。

### 计算前能力预检

`build_adaptive_path_plan(system,start,target,...)` 对路径端点和全部内部奇点执行与正式建路
相同的局部分类，不做数值输运。返回的 `PathPlan.continuation_ready` 是能力门禁；`False`
时 `messages` 和各 segment method 说明是 defective/repeated formal block、ramification、
代数扩域、缺失 Stokes connection 或其它未认证类型。普通 simple pole 也必须通过该门禁：
非 Q(i) 奇点位置以及不受支持的 exact indicial/Jordan/resonance 谱均返回 `False`。此时调用者只能改用普通绕行点，或
自行提供本包外的局部连接数据。正式 `build_adaptive_path` 对同一未认证内部点/终点抛出
`LocalReductionError`，不会退回普通点 Cauchy--DFT，也不会把提高工作精度当作结构证明。

start-only 的单重二阶-pole 形式渐近是唯一例外：它只负责从给定奇点边界初始化到同一
Stokes sector 内首个普通匹配点；相同局部基一旦位于路径内部或终点，`continuation_ready`
即为 `False`。

`exp(-k/z)` 本身不决定剩余级数是否收敛。程序抽掉完整的已认证标量高阶部分后，会重新检查
residual 系统；residual 至多为 simple pole 时，后续是收敛的 Frobenius power-log 级数，
可在最近其他奇点给出的半径内按 `max_step_over_radius` 选匹配点。若 residual 仍有高阶项，
一般只能形成 sectorial/Gevrey 渐近级数。上述单重二阶-pole 路线不提供 Stokes 连接；最近
其他奇点距离只是首匹配点参考尺度，不是收敛半径。自动首匹配点对分支 `k_i` 使用最近指数
根差 `Delta_i=min_{j!=i}|k_i-k_j|` 和晚期项估算 `n_min≈Delta_i/|z|`。缺省
`formal_minimum_order_factor=3`，所以建议距离为
`min_i Delta_i/(3*N)`，令请求阶数 `N` 约为预计最小项阶数的三分之一；仅当
`max_step_over_radius*R` 或路径区间给出更小距离时再缩短步长。其它渐近结构拒绝，不会把离
奇点较远的点当作可靠求值点。

形式级数令 `T_n=v_n z**n`。完成 `N+5` 阶后报告
`r5=norm_inf(sum(T[N+1:N+6]))/norm_inf(sum(T[N-4:N+1]))`，即先做五个矢量项之和再取
无穷范数；同时报告 `norm_inf(S[N+5]-S[N])/norm_inf(S[N+5])`。希望 `r5<1`；若不满足，
程序仍返回结果，但发出醒目 warning 并在 `formal_accuracy_issues` 中记录。即使 `r5<1`，实际
数值也始终保留供用户判断下降是否足够。

当下游已有标量级数项而需要硬门禁时，调用
`five_term_tail_diagnostic(terms,N,threshold="0.1")`。它使用不同且明确的标量定义
`abs(sum(T[N+1:N+6]))/sum(abs(T[N-4:N+1]))`；结果对象公开
`next_five_sum_absolute`、`previous_five_absolute_sum`、`next_over_previous`、`threshold`
和 `passed`。比较为严格 `<`，等于阈值不通过；前五项绝对值之和包含零时直接抛错。

奇点清单写入 `results/<run>/singularities/singularity_inventory.json`；若路径含 `inf`，还会
保存反演变量的 `singularity_inventory_sinv.json`。命名路径写入
`transport/<path_name>_path.json`，逐段记录方法、步长、控制收敛半径和两者比值。`inf` 只接受
精确字符串 `"inf"`，反演后矩阵为 `-sinv**(-2) A(1/sinv)`。

`path` 的运行时类型就是 `list[acb]`，可直接使用：

```python
snapshots, segment_reports, elapsed = transport_path(
    system, initial_vector, path,
    order=32, sample_count=96, radius_fraction=0.60,
    target_relative_error="1e-15",
)
```

`transport_path_refined(..., target_relative_error="1e-15")` 还会把主链/参考链末点相对差与
该阈值比较，返回 `target_relative_error_met`。未达到时只警告并保留结果；外层幂级数重构仍按
自身的样本精度门禁拒绝不合格样本。

`transport_path` / `transport_path_refined` 已支持把正则奇点保存成可复用的
`{"resultType":"frobenius_boundary","result":{"terms":[{"a":...,"b":...,"C":[...]}]}}`，
也支持把已认证指数型奇点保存为 `resultType: "exponential_boundary"` 及 `{phi,a,b,C}` terms。
以下限制只属于多列批量加速入口；它不表示 FlintNDE 不能保存奇点边界常数。

仓库级 `examples/` 提供三个入口：`qnm_2x2.py`、`regular_singular_save.py` 和 `exponential_boundary_save.py`。后两项分别给出本节 `{a,b,C}` 与 `{phi,a,b,C}` 保存合同的最小可运行配置。

多个 Frobenius 初值属于同一 exact `RationalMatrixSystem` 时，可用

```python
batch = transport_frobenius_boundaries_refined(
    system,
    boundaries,
    path,
    primary_order=24,
    reference_order=32,
    target_relative_error="1e-12",
)
```

`boundaries` 是非空 `FrobeniusBoundary` 列表；返回的每个 snapshot 是以这些初值为列的
Acb 矩阵。主链与参考链各共享一次局部基和每段 Taylor 矩阵，但
`relative_differences_inf`、`target_relative_error_met` 与 boundary report 仍按输入列分别给出。
当前批量入口只接受正则奇点启动后全部 transition 均为 `ordinary_taylor` 的路径，并且自身
不写 `save` 文件；需要保存普通点、保存奇点边界或使用其它局部 bridge 时，调用方应
逐个调用 `transport_path_refined`。MadStree adapter 会自动执行这一回退。

### 路径保存点

保存点没有名称字段。用户只在坐标后加 `"save"`：

```python
path = [(z0, "save"), z1, (z2, "save")]
snapshots, reports, elapsed = transport_path(
    system,
    initial_vector,
    path,
    order=32,
    save_output_directory=output_directory,  # 可省略；缺省为 Path.cwd()
)
```

`build_adaptive_path(system, (z0, "save"), (z1, "save"))` 以及带保存标签的
`detour_points` 使用同一格式。内部 `NamedPoint` 只服务旧路径/奇点诊断，其名称不进入保存合同。

程序到达一个保存点就立即写 `flintnde_save_001.json`、`flintnde_save_002.json` 等文件；
整条路径完成后再写 `flintnde_save_points.json`。后续步骤失败不删除已完成文件，也不写完整
汇总。`transport_path_refined` 只保存 reference chain。普通点的 `resultType` 是
`ordinary_vector`，结果含坐标和 Acb 列向量；正则奇点的 `resultType` 是
`frobenius_boundary`，结果含可再次交给 `frobenius_boundary` 的 `{a,b,C}` terms。后者是
局部边界数据，不是奇点处的 `Y(z_*)`。严格解耦指数型奇点的 `resultType` 是
`exponential_boundary`，结果可直接交给 `exponential_boundary`；显式带 `"save"` 的中间
奇点在 bridge 入射侧反解局部常数后立即写出。Lee--Moser 后尚无原基逆局部 jet 的情形和
需要 Stokes connection 的中间/终点仍拒绝执行；start-only formal 分支只允许保存起点，并
在输出中标记 `continuationReady: false`。

## 指数型奇点的 `{phi,a,b,C}` 边界

对 FlintNDE 已认证的指数局部解，令局部变量为有限点的 `z=s-s0` 或无穷远的
`z=sinv=1/s`。可移植边界格式表示
`exp(phi(z)) * z**a * log(z)**b * C`：

```python
from flintnde import exponential_boundary

boundary = exponential_boundary([
    {
        "phi": [
            {"power": -2, "coefficient": "3/2"},
            {"power": -1, "coefficient": "-1"},
        ],
        "a": "2/3",
        "b": 0,
        "C": [1, 0],
    }
])
```

`phi` 只允许负整数幂，系数、`a` 和 `C` 必须是 exact Q(i)；同幂项会合并，零项会删除。
`phi=[]` 表示同一高阶-pole 系统中该 sector 的 `exp(phi)=1`，用于完整保存可能同时含零/非零
指数签名的解。
程序仍从 DE 的高阶 Laurent 矩阵推导指数 sector，并逐项验证输入 `phi`，因此它不是用户可
任意选择的新参数。旧 `{a,b,C}` 输入继续兼容并由 `C` 推断 sector；保存输出始终显式写出
`phi`，便于跨进程复用和审计。若要保存路径中的本性奇点，可写
`detour_points=((s0,"save"),)`；该坐标不是绕行普通点，而是明确要求保存的 singular checkpoint。
只有 `continuation_ready=True` 的指数局部基可这样作为中间点。

## 奇点起点的 `{a,b,C}` 边界

若路径起点是奇点，奇点本身通常没有有限数值。用户给出局部变量 `z` 下
`z**a * log(z)**b * C` 的最高 log 领头项：有限奇点使用 `z=s-s0`，无穷远使用
`z=sinv=1/s`。推荐输入格式为：

```python
from flintnde import frobenius_boundary

boundary = frobenius_boundary([
    {"a": "0", "b": 1, "C": [1, 0]},
    {"a": "0", "b": 0, "C": [2, 0]},
])

snapshots, reports, elapsed = transport_path(
    system,
    boundary,
    path,                 # build_adaptive_path 返回的奇点起点路径
    order=32,
    sample_count=96,
    radius_fraction=0.60,
)
```

每项也可写成 `(a, b, C)` 三元组；多个记录表示线性叠加。`a` 和 `C` 的每个分量必须是
exact Q(i) 输入，`b` 必须是非负 Python 整数，`C` 的长度必须等于微分方程维数且不能为零。
输入 `float`、`complex` 或 Acb ball 会在输运前拒绝。

程序按 exact manifest 验证：

- 半单 residue：`a` 必须是 indicial root，`b=0`，`C` 必须属于该 root 的 exact 本征子空间；
  整数差 resonance 在更高阶产生的 log 由 recurrence 自动加入。
- 单根 Jordan residue：`C` 是该分支最高 `log**b` 的系数，必须满足 `N C=0` 且属于
  `N**b` 的像；`b` 不得超过 exact 最大 log 次数。程序用 exact RREF 取自由变量为零的
  规范广义本征向量，随后由 `exp(N log(z))` 自动补齐较低 log 次数。需要额外低 log
  齐次分支时，再增加相同 `a`、较小 `b` 的记录。
- Moser 或指数型高阶 pole：Moser 路线生成降阶 power-log 基的 exact jet，乘回完整
  Laurent gauge 后直接在用户原积分基验证 `a,b,C`；它不会只对 leading `C` 应用逆变换，
  因而不会漏掉相邻阶分量。指数 sector 由 exact 变换后的 `C` 自动识别，不新增用户参数；
  单项 `C` 若跨多个指数 sectors 会被拒绝，必须拆成多项。

验证通过后，程序在路径的第一个普通匹配点求值统一局部基，再进入原有普通点输运。
`reports[0]` 的方法名记录实际局部路线，保存原始 terms、规范基常数、
工作变量、分支约定和匹配点。奇点起点传普通有限列向量、普通点起点传 `{a,b,C}`、错误的
`a/b/C` 或 numerical Frobenius manifest 都会 fail closed。

正规化参数重构直接复用同一协议：

```python
def boundary(ep):
    return frobenius_boundary([
        {"a": 1, "b": 0, "C": [1 + ep]},
    ])

series_result = reconstruct_series_solution(
    DEmatrix=DEmatrix,
    boundary=boundary,
    path=path,
    maximum_power=2,
)
```

每个生产、pilot 和验证样本都会重新验证对应系统的 indicial/log 结构；参考链的边界初始化
审计记录保存在 `diagnostics` 的各样本 `boundary_initialization` 字段中。

这里 `convergence_radius` 是由奇点位置决定的收敛半径；`max_step_over_radius=0.45` 只表示
每一步不超过该半径的 `0.45` 倍。后续 `transport_path` 的 `radius_fraction` 应大于
`max_step_over_radius`，使实际步长严格落在 Cauchy 采样圆内。

若直线或某条折线路段遇到内部奇点，`build_adaptive_path` 会发出 warning，提醒用户
可以决定是否显式给出绕行点：

```python
path = build_adaptive_path(
    system,
    NamedPoint("left", -1),
    NamedPoint("right", 1),
    detour_points=(NamedPoint("upper_detour", 0.5j),),
    max_step_over_radius=0.45,
)
```

库函数不调用交互式 `input()`。未提供 `detour_points` 时也会继续生成路径：内部奇点
由左/右普通匹配点之间的统一局部基 bridge 表示，`transport_path(system, ..., path, ...)`
先在入射侧反解局部基常数，再在出射侧求值。缺省分支是 python-flint Acb 的主值
`log/power` 分支；复平面绕行点会相应改变路径。起点或终点本身为奇点时，返回列表从/到
奇点收敛圆内的普通匹配点；奇点局部边界值由 `prepare_local_expansion` 计算。

返回对象 `AdaptivePath` 是 `list[acb]` 的子类，无需格式转换；额外只读诊断包括
`step_reports`、`internal_singularities`、`start_classification`、`target_classification`、
`working_variable`、`infinity_transformation` 和
`max_step_over_convergence_radius`。`step_reports` 按实际路径顺序列出每一步的长度、控制
半径、`radius_owner` 与 `step_over_convergence_radius`；进入奇点时 `radius_owner` 是
`singularity`，不会误用前一普通点半径。相同内容写入路径 JSON 的 `steps`、
`step_over_convergence_radius_list` 和 `actual_max_step_over_convergence_radius`。含 `inf`
时工作点自动位于 `sinv`，把原 `RationalMatrixSystem` 直接交给主输运即可。

## 依赖与奇点门禁

运行依赖只有 `python-flint>=0.6`。普通点 Cauchy--DFT 重建不调用符号求导，也不对解做
多项式回归。正则奇点缺省读取 exact Q(i) residue，以两张同维 FLINT `fmpq_mat` 精确判断
indicial roots、Jordan 结构和整数差共振；当前 exact gate 对非 Q(i) 谱 fail closed，且
失败后绝不自动降级为浮点判别。

若只有浮点 residue，使用 `NumericalRegularSingularSystem`。缺省相对零斩杀线为

```text
dimension * 10^(-precision_digits)
```

再乘 residue/regular coefficient 的最大矩阵元尺度。Python `float`/`complex` 自动按
15 位可靠十进制输入处理，即使计算工作精度更高也不会提高该值；高精度十进制或 Acb
记录应通过 `input_precision_digits` 或 `precision_digits` 声明可靠输入位数。无法判断
输入精度且用户未声明时 fail closed。`relative_zero_tolerance` 可由用户覆盖。每次浮点判别都会
发出 warning，并在 manifest 中记录 `matrix_scale`、相对/绝对 cutoff、被判零数量，
以及最大被判零量和最小保留量各自的绝对值与相对 `matrix_scale` 的比值。即使用户
覆盖阈值，这些量也会完整出现；零矩阵尺度的相对比值明确记为 `null`。
无法稳定分类的 mixed-root defective 系统会阻断，要求提高精度或提供 exact 输入。

一旦 exact 或数值 gate 判定存在 log，局部解必定使用 power-log recurrence。程序包
没有在奇点用纯多项式回归拟合解的入口。`reconstruct_series_solution` 只在多个完整 NDE
终点值之间重构 regulator 的 Laurent 系数，与局部解是否含 log 无关。

运行测试：

```powershell
python -m unittest discover -s tests -v
```

2026-08-05 fresh 结果为 `95/95`（88 项既有 + 7 项 serializer 合同测试），wall time
约 `16.5 s`；测试临时目录显式位于 D 盘 package 内并在运行后删除。本轮 0.1.0 为纯重构版本，
公开接口与输出 schema 与 0.1.0.dev0 完全一致，详见 `UPDATE_NOTES_0.1.0.md`。
当前 BlackHoleQNM resource 的 project-local extension
覆盖 sampled-series 自定义正规化点、regular-point DE 与解析 epsilon-jet DE；权威 version、
受控文件聚合 SHA-256、测试计数和 pending authority sync 状态以
`RESOURCE_PROVENANCE.json` 为准。

完整安装方式、普通点输运、正则奇点、数值 fallback、正规化重建及全部公开参数见
`../../Documentation/FlintNDE.pdf` 的 “Installation and public interface” 一节。
