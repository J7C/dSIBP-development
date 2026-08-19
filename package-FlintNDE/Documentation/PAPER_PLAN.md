# FlintNDE 论文与发布规划

## 定位

论文面向平直时空多圈 Feynman integral 的高精度矩阵微分方程求解。核心贡献应落在
可复核的软件接口、一般解析矩阵的普通点数值展开、正则奇点 power-log 自动门禁、
connection matrix 输运和正规化参数重建，而不把“直接使用矩阵 indicial equation”
本身包装为创新。

论文组织参考 AMFlow package paper 的问题驱动顺序，但按当前两个公开核心功能重新收口：
先给应用背景和两张总流程图，再给安装、examples，最后集中解释算法与完整 API。性能
benchmark 和公开 Feynman integral 示例仍留到发布前补充。

## 正文章节

1. Introduction
   - 平直时空 Feynman integral、IBP 与 DE 背景，定位 DiffExp、AMFlow、AmpRed/LP 和
     expansion by regions；明确本包采用 fixed-regulator 数值输运后重构 Laurent 系数；
   - dSIBP 的时间积分、时间加圈动量 IBP/DE，以及 energy-space kinematic flow/cohomology；
   - 汇总两类来源共有的一变量矩阵 DE 数值问题，明确 FlintNDE 从已完成的约化矩阵和认证
     边界开始，不生成 IBP；引言暂不放入 QNM 或黑洞散射内容。
2. Core function I: numerical matrix-DE transport
   - 第一张总流程图覆盖 exact/numerical 输入、奇点清单、路径、普通点、正则奇点、
     高阶 pole 的 Moser balance/收敛指数/起点形式渐近/拒绝分支、refinement 与 caller-local 输出；图注逐节点指向
     技术 subsection；
   - 明确 `RationalMatrixSystem` 内部发现奇点，并把任意次数矩阵多项式加简单极点写成
     通过 exact 结构认证后采用的优化，而不是 dlog-only 输入边界；
   - 把原始点规划与已有计划执行画成两个阶段：缺省避开奇点、显式奇点折跃的分支责任、
     Arb 球序列化、规划精度门禁及 Wolfram `Needs["FlintNDE`"]` 入口。
3. Core function II: semi-analytic regulator-series reconstruction
   - 第二张总流程图只把基础 NDE 作为一个模块；单独给上游符号最低阶证书、
      AMFlow-inspired production plan、显式冗余候选池的增量消费、开复角域内最多三条均匀
      射线、Acb 方阵插值和独立样本验证；说明未达精度时保留当前系数但撤销精度认证。
4. Installation and dependencies
   - 只声明 Python `>=3.10` 与 `python-flint>=0.6`；说明 wheel、源码安装和任意目录调用；
     说明首次 `import flintnde` 的 stderr 一次性引用提醒只列 FlintNDE 程序包论文，文件协议
     适配器可显式静默且不得污染机器可读 stdout。
5. Examples
   - dS example 暂时留空；
   - QNM 例子保留原始 odd-parity 二阶方程、Darboux 统一说明和按常数/单极点组织的 2x2
     一阶系统；解释抽出两端平面波后 indicial 零领头阶的物理意义，并给双向禁戒分量检查。
6. Technical details
   - 普通点 Cauchy--DFT、exact Q(i)(s) 奇点清单、无穷远 Jacobian、路径与收敛半径；
   - 矩阵 indicial equation、Frobenius recurrence、exact `{a,b,C}` 正则边界与
     `{phi,a,b,C}` 指数型奇点边界保存；
   - log 独立流程图：Jordan、整数差 resonance、exact-first 与浮点阈值分支；
   - 高阶 pole 的清单分类仍只认证 `non_fuchsian_input_basis`；局部调度已实现 exact
     Lee--Moser projector-balance 逐阶降 pole，以及严格解耦 Q(i) 标量
      sector 的指数乘 power-log 基，以及单重二阶-pole 的 start-only exact 形式递推；
   - 区分指数抽取后 residual-Fuchsian 的收敛 power-log 与一般 Gevrey/sectorial 渐近级数，
      说明指数根差与 N/3 匹配点、固定 N 阶加五阶诊断、公开标量尾项严格阈值对象、是否到达
      最小项和当前 Stokes fail-closed 边界；
   - 明确 Moser 模块限于 exact Q(i)(x)、有限局部变量和无 ramification 的 meromorphic
     gauge；一般 formal block decoupling、代数扩域、ramification 与 Stokes 数据继续 fail closed；
   - regulator 重构的 AMFlow 误差公式、通用化参数选择、用户限制取值范围时的候选池耗尽门禁、
     完整公开接口表与 connection matrix。
7. Software status and outlook
   - 记录已实现边界、16 维 Q(i)(k) 验证、高阶 pole 单元交叉验证和仍 fail-closed 的
     一般 Katz/Levelt--Turrittin/Stokes 路线；
   - 发布前补平直时空 Feynman integral、dS 示例及同输入 benchmark。

## 软件模块

| 模块 | 首版状态 | 责任 |
|---|---|---|
| `systems.py` | 已实现 | 一般解析矩阵与 Cauchy--DFT Taylor coefficient |
| `exact_gaussian.py` | 已实现 | 两个 `fmpq` 表示 Q(i) 标量、两张同维 `fmpq_mat` 表示原维复矩阵，以及 Q(i)[x] 运算 |
| `boundary.py` | 已实现 | `{a,b,C}` 与 `{phi,a,b,C}` 领头分支解析、indicial/指数/log 精确门禁与 canonical 局部基常数恢复 |
| `singularities.py` | 已实现 | exact Q(i)(x) 矩阵、逐元约分、有限/无穷远奇点清单 |
| `fuchsian.py` | 已实现 | exact Lee--Moser projector-balance、ordered projectors、逐步 pole 阶与完整系统 round-trip 认证 |
| `local_solutions.py` | 已实现（受限） | 统一 power-log、Moser 后原基 exact-jet 边界验证、严格解耦指数 sector 与单重二阶-pole 起点形式递推；一般 formal gauge/Stokes fail closed |
| `asymptotics.py` | 已实现 | 公开标量五阶尾项诊断，返回分子、分母、比值、阈值与严格门禁状态 |
| `routing.py` / `singularity_jump.py` | 已实现 | `inf` 反演、普通/正则/高阶奇点调度、通用有理矩阵内部奇点清单、缺省避奇点与显式奇点折跃、用户点前瞻、自描述 Arb 球计划及反序列化；非 Q(i) 正则中心/谱及未认证内部/终点 fail closed |
| `transport.py` | 已实现 | 普通点分段输运、统一奇点局部基 bridge、低阶主链生产结果与高阶参考链精度核验，以及普通/正则/指数型 `(coordinate,"save")` 的主链逐点即时输出与完成后汇总 |
| `frobenius.py` | 已实现 | Q(i) exact indicial/Jordan/resonance manifest 与 power-log 基；非 Q(i) 谱 fail closed |
| `numeric_structure.py` | 已实现 | 浮点 residue 的精度感知斩杀、结构判别与审计 manifest |
| `regularization.py` | 已实现 | 文献公式给出的缺省采样规划、自定义覆盖与 Laurent 插值重构 |
| `output_layout.py` | 已实现 | 调用脚本锚定、固定分类和安全文件名检查 |
| general irregular reduction | 部分实现 | exact meromorphic Moser/projector/balance 已实现；formal block decoupling、ramification 与 Stokes matching 规划中 |

## 发布验收

- 新包不得读取 BlackHoleQNM 私有结果或运行配置。
- 每个 Python 进程首次 `import flintnde` 只向 stderr 显示一次 FlintNDE 程序包论文引用提醒；
  不列 dSIBP、MadStree 或其它论文。文件协议适配器可在 import 前显式静默该提示，并由自身
  响应 metadata 保存调用方的引用清单，禁止把提醒混入机器可读 stdout。
- ordinary-point 主接口不得要求 pole/residue 分解；简单极点快速路线必须由包内部 exact 认证。
- 计划与执行必须分离；执行不得重新规划。执行工作精度高于计划精度时必须拒绝并要求重规划。
- 缺省路径不得穿过内部奇点；显式奇点折跃必须报告多值分支责任。任何经过中途节点的多点输运均可称折跃，只有穿越奇点的局部基连接称奇点折跃。
- exact gate 测试至少覆盖：半单重根无 log、长度三 Jordan 的 `log^2`、整数差共振
  自动 log、mixed-root defective fail closed。
- 浮点 gate 必须记录输入精度、相对/绝对斩杀线、矩阵尺度和最大被判零量；binary64
  按 15 位可靠十进制输入处理；无法稳定分类时不得回退为无 log 多项式。
- 数值结果至少有一条独立阶数/样本 refinement 链。
- 每条正式奇点路径必须先能由同一局部调度得到 `continuation_ready=True`；非 Q(i) 正则中心、非 Q(i) indicial 谱和其它不支持的奇点类型不得回退为普通点或纯数值阈值路线。
- save-point 只接受 `(coordinate,"save")`；中途失败必须保留已完成逐点文件且禁止写 complete summary。
- QNM 示例同时报告双向禁戒分量和偏移频率 control。
- 所有 BibTeX 条目必须直接来自 INSPIRE，并在条目前单列 `% INSPIRE:` 链接；当前 26/26
  条目满足该约束，找不到 INSPIRE 的文献必须单独报告而不能自编。
- 加入公开 Feynman integral 示例与同口径 benchmark 后，才把版本提升到 `0.1.0`。
