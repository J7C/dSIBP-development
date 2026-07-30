# dS IBP Package - 项目规则

## 项目边界

本 package 由拓扑输入驱动，为任意圈数、任意拓扑及 massive/massless 混合的 dS Feynman 图生成 IBP 关系，并导出 Kira 等后端的基础输入。package 只生成和序列化关系，不运行 reduction。

本文件适用于 `package-dSibp/` 及其全部子目录。三程序包的共同依赖方向和 Git 规则见仓库根 `../AGENTS.md`。

`AGENTS.md` 只保存 agent 必须直接遵守的工作流、目录边界和正确性门禁。公式、convention、推导及接口细节以对应项目文档为准，不在本文件重复维护。

## 权威文档

- `../研究计划与研究进度.md`：当前版本、当前任务、未完成项、验收记录和交接入口；每次收到新任务必须先更新。
- `Documentation/dS_IBP_package_plan.md`：总体架构、统一积分表示、IBP 生成流程和拓扑输入格式。
- `Documentation/dS_IBP_package_design_note.md`：约定体系、设计决定和关键推导索引。
- `Documentation/dS_IBP_package_tech_note.tex`：完整公式、物理 convention 与证明。
- `Documentation/2026-07-21_common_theta_correctness_todo.md`：共同-theta、`WT`、指标/零点、可达 sector 与下游模块的正确性验收清单。
- `independent-benchmark/independent-benchmark.md`：交给独立推导者的自包含 benchmark 任务书。
- `independent-benchmark/README.md`：独立 benchmark 的目录边界、内部/外部检验路线和报告回收规则。

文档表述冲突时，先在 `研究计划与研究进度.md` 登记，再依据当前代码与专项验证纠正权威文档；不得把 `AGENTS.md` 扩写成第二份技术笔记。

## 程序与目录

- 当前开发主线由 `../研究计划与研究进度.md` 指定；当前为模块化目录 `versions/018_dSIBP/`，标准入口是把该目录加入 `$Path` 后调用 `Needs["dSIBP`"]`。
- 当前正式单文件兼容入口是 `independent-benchmark/package/package_018.1.wl`。代码版本只保留 `versions/016_dSIBP/`、`versions/017_dSIBP/` 和 `versions/018_dSIBP/`；010--015 只从 Git 历史追溯。
- 改变积分表示、sector convention 或物理公式边界时新开三位整数版本目录。018 内保持接口与 convention 兼容的修订不再新建代码目录，发布号依次记为 `018.1`、`018.2`；版本字符串、单文件名、手册名、manifest 和报告必须使用同一发布号。
- 本规则生效后新增的 dSIBP 版本都必须附带独立更新说明，至少记录基线版本、新增功能、修复、接口或 convention 变化、迁移要求、验证状态和已知限制；018.1 及更早资产不追溯补建。新整数代码版本使用 `versions/NNN_dSIBP/UPDATE_NOTES.md`，同一代码版本的新正式发布号使用 `independent-benchmark/package/package_NNN.x_UPDATE_NOTES.md`。
- `check-smoke/` 是维护 agent 日常小范围、轻量 check/test 的唯一目录；每项可复用检查放入名称直接说明功能的独立子目录，禁止重新堆叠全 family、全 sign/parity、连续指标撒点或完整 reduction 工作树。运行产物只放对应子目录的 `results_test/` 并在任务结束后清理。
- `check-smoke/` 不属于独立检验工作区。内部或外部独立执行者均不得读取、复制、写入或引用其中的脚本、结果与结论。
- 根目录 `check/` 专供内部独立会话按完整任务书执行；每轮开始前必须清空旧工作树并从头建立，不得复用上一轮 expected、撒点、reduction 或结果。该目录整体忽略，不作为长期项目资产。
- `independent-benchmark/package/` 只保留当前版本化程序 `package_<version>.wl`、同版本正式用户手册 `package_<version>.pdf`、本规则生效后的同版本 `package_<version>_UPDATE_NOTES.md` 和少量应用 examples；更新版本时覆盖当前交付并删除旧版本或无版本名副本。018.1 及更早交付不追溯补建更新说明。
- `independent-benchmark/package/` 不得放 expected、验证脚本、开发文档、报告或 reduction 输出。
- 每个发布版本必须维护 `independent-benchmark/package/examples/coverage_manifest.wl`：列出全部需要用户掌握的公开函数及其成品 example；正式检查必须与 package 的 `DSPublicAPI[]` 比较并验证源码调用覆盖，缺项不得发布。
- 三个典型成品 example 长期保留且不得由全 family 变体取代：`03_single_massive_sunrise/` 是唯一 sunrise example，固定三平行边、单 massive line 和 ISP，只生成 general seeds 与 general 参数微分算符，禁止撒点、`linearData`、Kira、DE 和 scaling；`04_pure_massive_bubble_closed_loop/` 保留 dlog basis、既有 reference 对照及从初始化到 19-master DE/scaling 的完整闭环；`06_mix_bubble_tree/` 固定一条 massive cycle line，其余 cycle/bridge lines massless，覆盖 `kL/kE`、无圈参量、massless convention 与 cycle/bridge contraction。清理 smoke/check 时不得删除、降格或移出 examples。
- `000-report/` 是本项目唯一的独立检验报告归档目录；除目录说明 `README.md` 外，不在其它项目目录散放报告。

新建、移动、清理程序目录时遵守 `program-directory-layout` skill：正式可复用结果进 `results/`，临时测试进 `test/results_test/`，可重跑中间产物进 `results_temp/`；不得误删用户未提交改动。

## 独立检验与报告

独立检验分为两类，二者都必须遵守 `independent-benchmark/independent-benchmark.md` 的来源隔离和先手推、后调用 package 顺序。

### 内部检验

- 由本 agent 在本项目文件夹中新开独立会话执行。
- 独立工作区使用根目录 `check/`；开始新一轮前删除其中全部旧内容，不得读取主线 expected 或旧检验结果来生成新的 expected。
- 内部独立执行者不得读取或使用根目录 `check-smoke/`；该目录只服务主线维护者的非独立轻量检查。
- 最终报告直接写入 `000-report/`，不得留在工作区或 `independent-benchmark/package/`。

### 外部检验

- 由外部 agent 在本项目之外的独立文件夹执行；外部工作目录不得成为本 package 的下游输入。
- 只向外部检验方提供 `independent-benchmark/` 中规定的任务书和分阶段交付物。
- 收到外部报告后先查阅来源隔离、版本和证据，再把原报告复制到本项目 `000-report/` 备份；不得只保留外部路径引用。

### 报告命名与清理

- 报告文件名统一为 `{时间}-{版本}-{内部/外部}.md`。
- 时间使用 `YYYY-MM-DD-HHmm`，版本使用三位程序版本号；例如 `2026-07-21-1600-012-内部.md`、`2026-07-21-1600-012-外部.md`。
- 报告如有附件，放入与报告同名并追加 `-附件` 的目录；附件不得混入程序、expected 或 package 交付目录。
- 新一轮检验开始前先确认目标版本；旧报告、针对报告的 battle/`report-of-report` 和临时争论稿不作为项目资产长期保留。

## 正确性门禁

以下是实现约束，不在此复述公式；具体定义与证明见 plan/design/tech note 和共同-theta TODO。

- package 运行时门禁只放在真实信任边界：用户新输入、尚未推导的数学公式、递推终止、外部 artifact 身份与 reduction/DE 闭合。由同一 producer 生成并带同源状态的 sealed 数据，consumer 缺省只读取状态、计数和 digest 字段，不得重复全量 canonical、parity、coverage、representation、residual 或内容 hash 自证；这些开发证书只在显式 `AuditLevel -> "full"`、`check-smoke/`、独立检验或发布阶段执行。没有实际失败证据或新信任边界时，不得向 package 默认路径追加门禁。
- 数值交叉检查缺省只使用一个固定、非奇异、精确有理点。`P0`、`ip0`、`ks` 等同一点在不同变量 convention 或导数方向下的矩阵表示不计作多个数值点；除用户明确要求或原点落在奇异面外，不得通过增加数值点堆叠验收。
- 所有 sector 统一使用 Head `J`，sector 由线状态区分；不得恢复按 sector 复制的 `G/R1/R2` 主实现。
- 共同-theta bundle、compiled `WT -> shrinkTerms`、simultaneous contact shift 累加、coincident canonical 和 contact-reachable sector 必须作为一个整体通过专项验收。
- h/H 模式、质量参数、缩并 prefactor、zero-point 和 H EOM 必须使用当前 tech note 与 preset；不得从历史版本重新引入旧递推。
- 多圈动量 IBP 生成元必须覆盖当前 plan/tech note 规定的完备集合；ISP 由用户定义并在生成关系前验证闭合性。
- ISP 指数的定义零点固定为 `0`。正指数是 numerator 幂；用户显式选择负 range/target/J 时 package 不阻断。自动 target-to-seed 反推不得把 ISP 下界降到用户给定下界以下，且 `ispN=0` 的 ISP 自身求导必须先精确化为零。
- topology、sector metadata、canonical seed、`linearData` 和 serializer 之间的状态必须一致；backend 只消费 backend-neutral `linearData`。
- 016 要求用户分别显式给出 `loopExternalMomenta` 与 `independentExternalMomenta`；不得根据符号名称或统一动量原子表猜角色。旧 `externalMomenta/externalLegMomenta` 只作为字段别名兼容。
- 加减号和复合方向必须保留精确系数。整体反号的无圈动量模长可 canonical 成同一对象，但 `p_1+p_2` 与 `p_1-p_2` 不得合并；实际模长只生成 `sE1,sE2,...` 或 dependent binding，不主动输出外腿交叉点积。
- 016 缺省公开 loop 坐标为 `ssij=Sqrt[sp[p_i,p_j]]`，内部原子仍为 `kk[i,j]`。编号只依赖推断后列表顺序；任一类别总数超过 9 时按总数位宽补零，旧 `sij` 兼容名使用同一规则。
- 动量列表或动力学规则欠完备时必须红色报错，返回缺失方向/零空间表达式并拒绝初始化；所有下游入口读取 capability gate。过完备时 warning 后允许 symbolic IBP，但 `ds/DSDE` 与唯一反变换必须关闭。
- root topology 决定圈数、loop space 与 cycle/bridge line-power schema；contact/shrink sector 必须继承这些 metadata，只改变端点代表、pack 状态、零点和对称性，不得重新降圈。
- 根号坐标求导必须通过链式法则复用平方不变量原子导数：`d/dssij=2 ssij d/d(sp[ki,kj])`；不得复制或重写一套 loop 外动量导数实现。显式用户规则 `sp[ki,kj]->sij` 保持单位 Jacobian 的兼容语义。
- 初次 Kira 探测不得把全部积分设为 targets；必须按预估 master 规模设置有界候选范围，未有更具体依据时上限取约 1000，formal 阶段只选择 active basis 及其导数闭包。
- 任何进入 Kira reduction 的 family 都必须先实数化。实数化的固定动作是：从 topology/line 的 phase-dependency metadata 结构性识别每个 massless propagator 动量原子 `k`，定义单个实 backend 变量 `ik` 并执行 `k -> -I ik`，不得按符号名猜测；再用可逆积分相位变换消除剩余整体虚相位。`ibp.kira` 出现 `I`、`dsii` 或其它虚数替代 token 时必须拒绝导出；该 convention 只限 Kira 内部，import 后恢复物理变量和导数 Jacobian。实现与检查直接参考已经完成的 massive bubble 路线，不重新构造另一套 convention。

## Mathematica 实现约定

- 原始替换规则命名为 `rep****0`，可直接用于 `/.`；函数形式命名为 `rep****[expr_]`。
- 函数名表达物理或数学含义，不用数字编号区分不同物理操作。
- 拓扑性质、奇偶筛选、线数和顶点数必须参数化，不在通用函数中硬编码特定 topology。
- 优先用 `//` 展示清晰的数据流；按“定义与初始化、物理规则、生成与导出”等逻辑功能组织章节。
- 注释说明原因、约定来源或非显然边界，不复述代码动作。
- 不为各 sector 复制实现，不建立与 `J` 并行的积分 Head。

## 开发流程

1. 先更新 `研究计划与研究进度.md`，写清任务、未完成项和验收标准。
2. 每实现或修复一个独立功能，必须在继续下一功能或正式验证前同步更新 `../研究计划与研究进度.md`，并把该功能的接口、数据流、公式、边界、状态和错误处理细节整合补入 `Documentation/dS_IBP_package_tech_note.tex` 的对应用户步骤位置。已有记录不得重复堆叠，应就地校正和补全。
3. 读取 topology 与 ISP 配置，验证输入和 ISP 完备性。
4. 构造完整生成元；按 contact-reachable sector 枚举 canonical seeds，生成指标移位并应用 EOM、symmetry 和 parity。
5. 分 sector 保存 canonical seed 数据，转换为 backend-neutral `linearData`；必要的小规模数值规则只在该层代入。
6. 由 serializer 导出后端基础输入，不运行 reduction。
7. 按风险运行专项和受影响回归，更新进度结论；正式独立报告统一归档到 `000-report/`。

更新当前正式交付时必须先在 `test/results_test/` 生成候选程序/手册，并让受影响检查显式加载候选路径。候选全部通过且记录哈希后，才可用同一候选字节覆盖 `independent-benchmark/package/`；覆盖后还要对正式路径复验，最后清理候选产物。
