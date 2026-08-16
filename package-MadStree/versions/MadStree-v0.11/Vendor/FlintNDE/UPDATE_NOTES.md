# FlintNDE 0.4.0 更新说明

## 基线与定位

- 从冻结的 0.3.0 建立；0.3.0 不再回写。
- 0.4.0 继续定位为与物理模型无关的单变量一阶矩阵微分方程求解器。它不读取 MadStree
  的 dlog letters、主积分顺序、normalization 或多变量图信息。
- 独立包与 MadStree v0.11 的 `Vendor/FlintNDE` 保持同一份实现和 0.4.0 版本身份。

## 0.4.0 新增功能

1. `evaluate_vector_series_many` 按单个展开节点的覆盖桶批量计算向量级数。点数不少于 8
   时使用 `acb_poly.evaluate(..., algorithm="fast")` 的子积树/余数树多点求值；小桶
   使用 `algorithm="iter"`，避免建树的固定开销。
2. 普通规划输运与奇点折跃输运都按节点/线段聚合 dense samples，并记录实际算法、点数
   和逐点算法来源。
3. 新增公开 `direct_user_point_path`：严格保留用户点顺序，不插点、不删点、不调用规划器；
   用户链端点落在奇点或线段穿过奇点时 fail closed。
4. 新增不同固定 `ep` 的有界进程池。Python 使用
   `run_ep_tasks(..., parallel_task_count=12)`，Wolfram 使用
   `FlintNDEEvaluateEpBatch[..., ParallelTaskCount -> 12]`；缺省上限为 12，实际并发取
   任务数与上限的较小者，超出上限的任务由程序自动续交。正规化重构的生产和验证样本
   使用同一选项；固定 exact 有理系统与认证路径会结构化跨进程恢复。
5. Python `import flintnde`、无参 `configure_working_precision()` 与 Wolfram
   `FlintNDEPlanPath` / `FlintNDEExecutePath` / `FlintNDEEvaluateEpBatch` 的缺省工作精度统一为
   200 位十进制精度（697 bit，含 32 guard bits）。正规化自动规划取 200 与原自适应公式的
   较大者；用户显式指定精度时仍直接采用指定值。
6. `reconstruct_series_solution` 的显式 `sample_points` 现可作为冗余有序候选池；新增
   `initial_internal_maximum_power` 控制首轮内部最高 regulator 幂。每轮只消费所需前缀，
   验证失败后复用旧值并增量取点，候选池耗尽时 fail closed，绝不生成用户范围外取值。
   新参数缺省为 `"automatic"`，未显式配置时输入格式、自动采样公式和结果保持不变。

以下能力说明为从 0.3.0 继承且在 0.4.0 继续保留的基线。

## 新增功能

1. **通用有理矩阵的内部奇点发现**：`RationalMatrixSystem` 从 exact 矩阵元分母内部
   发现有限奇点、极点阶数与无穷远分类，不要求用户预先提供奇点。
2. **多项式加简单极点内部特化**：自动验证
   `A(x)=P(x)+Sum_j R_j/(x-p_j)`，其中 `P(x)` 可为任意有限次数矩阵多项式。
   只有 exact 恒等重构和全部有限极点一阶等门禁通过时才使用快速递推；高阶极点与一般
   有理矩阵继续走通用 `RationalMatrixSystem` 路线或按既有能力 fail closed。该特化不要求
   dlog 输入，也不限制通用 DE 接口。
3. **规划与执行分离和复平面 dense output**：`plan_transport_path`/Wolfram
   `FlintNDEPlanPath` 从同一单变量复参数平面的原始点生成可序列化计划。当前节点
   收敛圆盘内的多个复点共享节点解系数，不再要求这些点实共线；不同单变量拉回不得
   共享局部系数。`transport_planned_path_refined`/Wolfram `FlintNDEExecutePath`
   只恢复并执行已有计划，不再次规划。
4. **缺省避开奇点**：Python 的通用 routing 使用
   `singularity_mode="avoid"` 和 Wolfram 的 `"SingularityMode" -> "Avoid"` 均为缺省。
   命中内部奇点时返回对应线段与奇点诊断。显式 `singularity_jump` /
   `"SingularityJump"` 模式才允许奇点折跃，并提醒用户：多值分支等价于某条绕行
   路径，必须自行确认。模式值集合固定为上述两项。
5. **奇点折跃后的用户点前瞻**：进入奇点步长范围后建立入射/出射桥；随后依次吸收仍位于
   奇点一步范围内的用户点，以最后一个为下一节点。首个点若已超范围，则沿该方向先走
   一个允许步长回到普通节点状态，再继续规划。
6. **双语提示**：Python `message_language="EN"|"CN"` 与 Wolfram
   `MessageLanguage -> "EN"|"CN"`；缺省英文。规划结果明确说明当前模式，
   执行结果明确说明没有重新规划。
7. **标准 Wolfram 程序包入口**：版本根的 `FlintNDE.m`、`Kernel/init.m` 与
   `Mathematica/FlintNDE.wl` 支持 `Needs["FlintNDE`"]`。公开构造器包括
   `FlintNDERationalSystem`、`FlintNDEPartialFractionSystem`，两阶段入口为
   `FlintNDEPlanPath` 与 `FlintNDEExecutePath`。
8. **浅层 Wolfram 运行目录**：`"WorkDirectory"` 表示运行根本身；`Automatic` 只建立一次
   `results_temp/`，其下使用 `bridge/` 和短 token 文件名。Windows 完整路径超过 259 字符时
   在任何写入和 Python 启动前返回 `RuntimePathTooLong`。输入写入、缺少 `python-flint`、
   bridge 启动失败、无输出和输出损坏均保留独立错误标签。
9. **无 shell 的 Wolfram launcher**：物理删除 `Run` 命令字符串、引号转义和日志重定向
   helper，改用参数列表 `RunProcess` 与显式 `ProcessDirectory`。这修复了 Windows 下同一
   Wolfram kernel 连续加载 FLINT DLL 时可复现的 `0xC0000142` 启动失败，不增加重试或 fallback。

## 精度与认证修复

- 工作位数统一按
  `ceil(WorkingPrecisionDigits*log2(10))+32` 设置。70 位为 265 bit，100 位为
  365 bit；提高 `OutputDigits` 本身不会提高内部精度。
- 修复规划比例在低精度 import 阶段构造 Arb 常量造成的永久精度污染；线段投影、
  匹配比例、旋转因子与节点现在均按当前 Arb 精度构造，70/100 位回归确认真实奇点折跃
  匹配节点的可用 bit 数随请求增长。
- `PlannedPath` 与 `AdaptivePath` JSON 均保存 `planning_precision_digits`。节点、
  奇点和奇点折跃几何以 Arb `midpoint/radius/exponent` 记录保存，不再只保存中点。
- 执行请求高于规划精度时 fail closed，并要求按目标精度重新规划；序列化数据不能在执行期
  伪装补回精度。
- winding/monodromy 与分支提升使用 Acb/Arb 辐角球，不经过 Python
  `complex`/`cmath`。
- 奇点桥不再把同一结果冒充 Embedded 主/参考双链；需要独立链时自动升级认证并在 warning
  和结果中报告。

## 接口合同

- Python 路径模式只接受 `singularity_mode="avoid"|"singularity_jump"`；Wolfram 只接受
  `"SingularityMode" -> "Avoid"|"SingularityJump"`。缺省均为避开奇点。
- “折跃”指任何经过中途节点的多点输运；只有显式穿过奇点的局部基连接称为“奇点折跃”。
- Wolfram 单任务主线为 `FlintNDEPlanPath` / `FlintNDEExecutePath`，不同固定 `ep` 的批量
  入口为 `FlintNDEEvaluateEpBatch`；JSON bridge 对应
  `action="plan"|"execute"|"evaluate"|"ep_batch"`。执行入口只接受当前计划 schema
  和带 Arb 球精度字段的节点。
- 正则奇点边界使用 `{a,b,C}`；指数型奇点边界只接受 `{phi,a,b,C}`。程序从 DE 独立推导
  exact 指数 sector 并核验 `phi`，不从 `C` 静默猜测指数签名。
- `reconstruct_series_solution` 要求整数 `leading_power` 及严格
  `leading_power_certificate`；数值 pilot、`leading_power="automatic"`、pilot 参数和
  `LeadingPowerDetectionError` 已物理删除。泛型 callable 缺少符号结构时必须由上游认证，
  不能用有限数值点冒充 Laurent 支撑证明。
- 0.4.0 保留上述公开合同；依赖和列向量 convention 不变。
## 验证状态

- fast/iter 多点求值单元测试与公开直接用户节点测试已通过。
- 完整 Python 回归 165/165；Wolfram `Needs["FlintNDE`"]` 端到端 25/25，其中新增 4 项覆盖
  浅层目录、259/260 字符边界及 Python 前置输入写入失败。
- 独立包与 MadStree v0.11 Vendor 的 42 个非缓存交付文件逐文件 SHA-256 一致。
- 0.4.0 独立检验：257 点、64 阶 fast/Horner 最大差 `1.96586e-62`；900 点 planned/direct
  共 1800 分量通过闭式解和路线互检，planned 为 128 节点、覆盖 774 个 dense 点，direct
  为 901 节点且 planner sentinel 为 0；本轮 direct/planned 后端与总墙钟比为
  `5.505/5.120`。runner 在计算前删除旧结果和报告。报告位于
  `independent-validation/FlintNDE-0.4.0-validation-01-fast-multipoint-and-direct-path/`。
- 七个仓库 examples 均在删除旧 `results/`/`results_temp/` 后从 0.4.0 路径 fresh 执行；正式 PDF 经 XeLaTeX/BibTeX 构建，
  日志无未定义引用，抽查页目检通过。

## 已知限制

- 一般代数扩域、ramification、缺 Stokes connection 的不规则奇点和未认证局部基继续
  fail closed。
- 共振/Jordan/log 只在现有 exact local-basis 门禁支持时进行奇点折跃；不能把简单 residue 特化
  当作这些结构的替代算法。
- 更高精度结果必须从同等或更高 `WorkingPrecisionDigits` 的新计划开始；不能复用低精度
  序列化计划。
- fast 与 iterative/Horner 可能因舍入路径不同而不返回同一 Acb 球；必须按请求精度做
  数值误差门禁和独立逐点互检。
