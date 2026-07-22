# dS IBP Package - 项目规则

## 项目边界

本 package 由拓扑输入驱动，为任意圈数、任意拓扑及 massive/massless 混合的 dS Feynman 图生成 IBP 关系，并导出 Kira 等后端的基础输入。package 只生成和序列化关系，不运行 reduction。

`AGENTS.md` 只保存 agent 必须直接遵守的工作流、目录边界和正确性门禁。公式、convention、推导及接口细节以对应项目文档为准，不在本文件重复维护。

## 权威文档

- `研究计划与研究进度.md`：当前版本、当前任务、未完成项、验收记录和交接入口；每次收到新任务必须先更新。
- `000_note/dS_IBP_package_plan.md`：总体架构、统一积分表示、IBP 生成流程和拓扑输入格式。
- `000_note/dS_IBP_package_design_note.md`：约定体系、设计决定和关键推导索引。
- `000_note/dS_IBP_package_tech_note.tex`：完整公式、物理 convention 与证明。
- `000_note/2026-07-21_common_theta_correctness_todo.md`：共同-theta、`WT`、指标/零点、可达 sector 与下游模块的正确性验收清单。
- `independent-benchmark/independent-benchmark.md`：交给独立推导者的自包含 benchmark 任务书。
- `independent-benchmark/README.md`：独立 benchmark 的目录边界、内部/外部检验路线和报告回收规则。

文档表述冲突时，先在 `研究计划与研究进度.md` 登记，再依据当前代码与专项验证纠正权威文档；不得把 `AGENTS.md` 扩写成第二份技术笔记。

## 程序与目录

- 当前主线版本由 `研究计划与研究进度.md` 指定；当前为模块化目录 `000_code/016_dSIBP/`，标准入口是把该目录加入 `$Path` 后调用 `Needs["dSIBP`"]`。
- 016 的冻结单文件兼容入口是 `independent-benchmark/package/package_016.wl`；`000_code/010_dS_ibp_general.wl` 至 `015_dS_ibp_general.wl` 及其模块目录是只读基线/历史版本，不在新任务中回写。
- `000_code/check/` 保存当前主线正式验证脚本。
- `000_code/test/` 保存临时测试脚本，运行产物只放 `000_code/test/results_test/`。
- `independent-benchmark/package/` 只保留当前版本化程序 `package_<version>.wl`、同版本正式用户手册 `package_<version>.pdf` 和少量应用 examples；更新版本时覆盖当前交付并删除旧版本或无版本名副本。
- `independent-benchmark/package/` 不得放 expected、验证脚本、开发文档、报告或 reduction 输出。
- 每个发布版本必须维护 `independent-benchmark/package/examples/coverage_manifest.wl`：列出全部需要用户掌握的公开函数及其成品 example；正式检查必须与 package 的 `DSPublicAPI[]` 比较并验证源码调用覆盖，缺项不得发布。
- `000-report/` 是本项目唯一的独立检验报告归档目录；除目录说明 `README.md` 外，不在其它项目目录散放报告。

新建、移动、清理程序目录时遵守 `program-directory-layout` skill：正式可复用结果进 `results/`，临时测试进 `test/results_test/`，可重跑中间产物进 `results_temp/`；不得误删用户未提交改动。

## 独立检验与报告

独立检验分为两类，二者都必须遵守 `independent-benchmark/independent-benchmark.md` 的来源隔离和先手推、后调用 package 顺序。

### 内部检验

- 由本 agent 在本项目文件夹中新开独立会话执行。
- 独立工作区使用 `codex-independent-benchmark/`；不得读取主线 expected 或旧检验结果来生成新的 expected。
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

- 所有 sector 统一使用 Head `J`，sector 由线状态区分；不得恢复按 sector 复制的 `G/R1/R2` 主实现。
- 共同-theta bundle、compiled `WT -> shrinkTerms`、simultaneous contact shift 累加、coincident canonical 和 contact-reachable sector 必须作为一个整体通过专项验收。
- h/H 模式、质量参数、缩并 prefactor、zero-point 和 H EOM 必须使用当前 tech note 与 preset；不得从历史版本重新引入旧递推。
- 多圈动量 IBP 生成元必须覆盖当前 plan/tech note 规定的完备集合；ISP 由用户定义并在生成关系前验证闭合性。
- topology、sector metadata、canonical seed、`linearData` 和 serializer 之间的状态必须一致；backend 只消费 backend-neutral `linearData`。
- 016 要求用户分别显式给出 `loopExternalMomenta` 与 `independentExternalMomenta`；不得根据符号名称或统一动量原子表猜角色。旧 `externalMomenta/externalLegMomenta` 只作为字段别名兼容。
- 加减号和复合方向必须保留精确系数。整体反号的无圈动量模长可 canonical 成同一对象，但 `p_1+p_2` 与 `p_1-p_2` 不得合并；实际模长只生成 `sE1,sE2,...` 或 dependent binding，不主动输出外腿交叉点积。
- 016 缺省公开 loop 坐标为 `ssij=Sqrt[sp[p_i,p_j]]`，内部原子仍为 `kk[i,j]`。编号只依赖推断后列表顺序；任一类别总数超过 9 时按总数位宽补零，旧 `sij` 兼容名使用同一规则。
- 动量列表或动力学规则欠完备时必须红色报错，返回缺失方向/零空间表达式并拒绝初始化；所有下游入口读取 capability gate。过完备时 warning 后允许 symbolic IBP，但 `ds/DSDE` 与唯一反变换必须关闭。
- root topology 决定圈数、loop space 与 cycle/bridge line-power schema；contact/shrink sector 必须继承这些 metadata，只改变端点代表、pack 状态、零点和对称性，不得重新降圈。
- 根号坐标求导必须通过链式法则复用平方不变量原子导数：`d/dssij=2 ssij d/d(sp[ki,kj])`；不得复制或重写一套 loop 外动量导数实现。显式用户规则 `sp[ki,kj]->sij` 保持单位 Jacobian 的兼容语义。

## Mathematica 实现约定

- 原始替换规则命名为 `rep****0`，可直接用于 `/.`；函数形式命名为 `rep****[expr_]`。
- 函数名表达物理或数学含义，不用数字编号区分不同物理操作。
- 拓扑性质、奇偶筛选、线数和顶点数必须参数化，不在通用函数中硬编码特定 topology。
- 优先用 `//` 展示清晰的数据流；按“定义与初始化、物理规则、生成与导出”等逻辑功能组织章节。
- 注释说明原因、约定来源或非显然边界，不复述代码动作。
- 不为各 sector 复制实现，不建立与 `J` 并行的积分 Head。

## 开发流程

1. 先更新 `研究计划与研究进度.md`，写清任务、未完成项和验收标准。
2. 读取 topology 与 ISP 配置，验证输入和 ISP 完备性。
3. 构造完整生成元；按 contact-reachable sector 枚举 canonical seeds，生成指标移位并应用 EOM、symmetry 和 parity。
4. 分 sector 保存 canonical seed 数据，转换为 backend-neutral `linearData`；必要的小规模数值规则只在该层代入。
5. 由 serializer 导出后端基础输入，不运行 reduction。
6. 按风险运行专项和受影响回归，更新进度结论；正式独立报告统一归档到 `000-report/`。
