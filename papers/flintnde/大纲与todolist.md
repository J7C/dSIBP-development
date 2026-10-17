# FlintNDE 程序包论文 · 大纲与待办

工作目录约定：与 `papers/dSIBP/`、`papers/madstree/` 并列，正式稿件放 `papers/flintnde/`
（`paper.tex`、`references.bib`、`jheppub.sty`、`JHEP.bst`、`figures/`）。
本文件是写作前的规划与裁定清单，不是稿件内容。

现有材料基线：`package-FlintNDE/Documentation/PAPER_PLAN.md`（章节级规划，已存在）、
`package-FlintNDE/Documentation/references.bib`（26 条 INSPIRE 条目）、
`package-FlintNDE/Documentation/FlintNDE.tex`（手册）、两级 `README.md`。
代码事实以 `versions/FlintNDE-0.5.0/` 为准，本轮已对全部模块做过功能盘点。

---

## 一、从 dSIBP / AMFlow / MadStree 提取的"程序包论文"结构特征

三篇都是包论文，共同骨架是：**问题驱动的 intro → 包消费的数学对象/记号 → 主功能逐个展开 →
Using the package（按用户操作顺序）→ Examples → 与独立参照的验证 → Summary and outlook →
附录 API 总表**。差异在于"方法层"放什么。

| 特征 | AMFlow (2201.11669) | dSIBP | MadStree | 对 FlintNDE 的取用 |
|---|---|---|---|---|
| Intro 长度与功能 | 短，纯问题+现有工具定位 | 中，问题+现有工具+本包定位 | 长，四段：现象学背景→dS 记号与已有解析方法→平直空间 IBP/DE 工具→本包两条推进 | 取 MadStree 的四段式，但第三段换成"矩阵 DE 数值求解在平直时空已是主流工具" |
| 方法章 | 有（auxiliary mass flow 原理 + numerical fit 经验公式，独立成章） | 有（Notation and conventions，6 个 subsection） | 有（Sec. 2，6 个 subsection，公式推导） | **不写理论推导章**。只写一节"包所处理的数学对象与接口合同"（一阶矩阵 DE、局部解的广义幂级数形式、边界数据格式），2–3 个 subsection |
| AMFlow 的 numerical fit 章 | 单独一章给采样点数/尺度/精度的经验公式 | — | — | FlintNDE 的 regulator 级数重构正是这条路线，**单列一个核心功能 subsection**，并显式声明公式取自 AMFlow 2.0 |
| Using the package | 4 个 subsection：Input / Automatic / Manual / Other functions + Summary of options | 4 个 subsection：Initialisation / Seeds / Linear systems / DE and checks（+tree track） | 5 个 subsection：Installation / Input formats & core / Numerical evaluation / Laurent reconstruction / Options & pitfalls | 按用户点 2 拆成"Python 基础命令"与"Wolfram 接口命令"两组 subsection |
| Examples | 正文穿插 | 1 节 + Validation subsection | Package examples + Application examples 两个 subsection + 独立 Verification 章 | 取 MadStree：Examples（包内可运行例子 + 应用例子）+ Verification 单独一节 |
| 附录 | 无 | Public functions 表 | common-theta 技术附录 | 附录 = 公开 API 总表（Python `__all__` + WL 符号），沿用 dSIBP 的表格样式 |
| 图 | 2 张流程图 | SK 费曼规则图 | 图在 examples | **2 张总流程图**（PAPER_PLAN 已规划），逐节点指向 subsection |
| 致谢/AI 声明位置 | — | intro 末尾（\maketitle 之后、第一章之前） | Summary 之后独立 `\section*` | 采用 MadStree 位置与措辞骨架，按用户点 3 删去推导相关子句 |

---

## 二、拟定章节大纲（正式稿 `paper.tex`）

标题（暂定，待定稿）：*FlintNDE: a package for high-precision numerical solution of matrix differential equations with rational coefficients*

0. 前置块
   - `\author[a,b]{Jiaqi Chen}`，两条 affiliation 逐字节复制 `papers/madstree/paper.tex` L54–55，
     `\emailAdd{jiaqichen@cup.edu.cn}` 复制 L57。**不写第二位作者、不写 Tianjin University 与其邮箱。**
   - `\documentclass[11pt,a4paper]{article}` + `\usepackage{jheppub}`；摘要用 `\abstract{}` 宏（目录由 `\maketitle` 自动生成，正文不写 `\tableofcontents`）；bibliography 用 `JHEP.bst`；**禁用 ctex**。
   - **摘要必须点出三个应用领域（2026-10-17 用户裁定）**：平直时空量子场论（费曼积分的 DE 数值求解）、
     de Sitter 时空场论（宇宙学关联函数）、黑洞 QNM（径向连接问题）。一句话级别，不展开。

1. Introduction
   - 段 1（唯象背景，简要，**三个领域并列，QNM 只给最小必要背景与引用**）：高精度圈图费曼积分是平直时空 QFT 唯象计算的基础；dS 晚期关联函数把暴胀期交换粒子的质量与自旋信息带到原初非高斯信号上（`Chen:2017ryl`、`Arkani-Hamed:2018kmz`、`Xianyu:2023ytd`）；黑洞 QNM 是微扰衰减（ringdown）的特征信号，已被引力波观测直接看到（只引 `LIGOScientific:2016aoc`，INSPIRE /literature/1421100；综述 `Kokkotas:1999bd`、`Nollert:1999ji` **默认不引**）。
   - 段 1b（矩阵 DE 在黑洞微扰中的出现，1–2 句，最小引用）：Schwarzschild/Kerr 微扰在分离变量后归结为带特定边界条件的径向二阶 ODE（RWZ 方程，`Regge:1957td`、`Zerilli:1970se`），QNM 即其"视界纯入射、无穷远纯出射"边界值问题的离散复谱（`Leaver:1985ax`、`Berti:2009kk`）；数值求连接问题与本包的输运合同同构。**此条推翻 `PAPER_PLAN.md` "引言暂不放入 QNM 或黑洞散射内容" 的旧决定（2026-10-17 用户改判）；`Chandrasekhar:1975zza` 默认不引。**
   - 段 2（平直时空主流工具，必须逐个引用）：IBP 与 DE 方法 `Chetyrkin:1981qh`、`Kotikov:1990kg`、`Kotikov:1991pm`、`Bern:1993kr`、`Gehrmann:1999as`、d log 规范形式 `Henn:2013pwa`；约化程序 FIRE `Smirnov:2019qkx,Smirnov:2025prc`、Kira `Maierhofer:2017gsa,Klappert:2020nbg,Lange:2025fba`、AmpRed `Chen:2024xwt`；数值输运 DiffExp `Hidding:2020ytt` 与 auxiliary mass flow 的 AMFlow `Liu:2017jxz,Liu:2020kpc,Liu:2022chg,Huang:2026rjb`；按区域展开 `Beneke:1997zp,Pak:2010pt`；维度递推 `Lee:2013hzt`。
   - 段 3（同一数学对象出现在 dS，主要引用 Jiaqi Chen 为作者的三篇）：说明 IBP→一阶矩阵 DE→沿运动学路径数值输运→按 regulator 重构 Laurent 系数这条链条，在 dS 时空 recently 也被建立起来，`Chen:2023iix`（general dS IBP 与 d log DE）、`Chen:2024glu`（幂级数解与 blow-up 边界）、`Chen:2026dqp`（圈级宇称分裂 IBP 与 d log DE）。**本包不针对 dS 本身**，而是承接这三篇与平直时空工具共同产出的矩阵 DE。
   - 段 4（本文的数学结构，用户点 6 必须在 intro 出现）：沿路径输运时，局部解必须写成 **generalized power series**——幂因子 × 对数幂 × 级数，这一结构在 DiffExp 与 AMFlow 中已在使用，并见 `Moriello:2019yhu`。随后**一句带过**（用户已裁定：不算卖点、不系统，只是遇到时能额外处理）：对完全解耦的个别不规则奇点，本包在对数之外还可抽出**指数因子 $\exp(Q(u))$，$Q$ 为局部变量 $u=z-z_0$ 的负幂多项式**，不展开。再一句话给出定位：本包从"已约化、已认证边界的矩阵 DE"开始，不生成 IBP。
   - 段 5（正文路线图）+ `Statement on AI use.` + `\noindent The package is available at \url{...}`（仓库地址待用户确认，见待办 P-1）。

2. Mathematical object and interface contract（无推导，只给合同）
   - 2.1 The system：`dY/dz = A(z) Y`，`A(z)` 为 `Q(i)` 上有理矩阵或任意精度数值解析矩阵；奇点由包内部发现（`RationalMatrixSystem`），用户不必给 pole/residue 分解。
   - 2.2 Local solutions as generalized power series：常点 Taylor；正则奇点 `z^a log^b z Σ c_n z^n`；不规则奇点 `exp(Phi(z)) z^a log^b z Σ c_n z^n`。给出边界记录 `{a,b,C}` 与 `{phi,a,b,C}` 两种格式。
   - 2.3 What the package does and does not do：不生成 IBP、不做积分族管理、不读上层 normalization；精度、误差认证与 fail-closed 语义的总纲。

3. Core function I: numerical transport of matrix DE
   - 3.1 总流程图 1 + 逐节点导览（exact/数值输入、奇点清单、路径规划、常点、正则奇点、Lee–Moser 降阶/指数扇区/start-only 形式渐近/拒绝、refinement、输出）。
   - 3.2 Local solution construction：矩阵 indicial equation、Jordan 与整数差共振自动定 log 次数、exact-first 与浮点阈值分支。
   - 3.3 High-order poles: reduction and decoupled exponential sectors（**定位为顺带能力，篇幅从简**）：Moser projector-balance（明确写"实现对应 AMFlow 的 `FindProjector`"思想）；降不下去且完全解耦时在 power-log 外乘**指数型 generalized power series**；单重二阶 pole 的 start-only 形式渐近与五阶尾项诊断；跨 Stokes 扇区一律 fail closed。**技术事实（写作时以此为准，勿再写成单项式）**：
     - 指数因子的相位是**负幂多项式（多项式分式）**而非单项式：$Q(u)=\sum_{k=2}^{p}-\frac{c_k}{k-1}\,u^{-(k-1)}$，$u=z-z_0$，$c_k$ 为最高阶系数对角化后各阶 Laurent 系数的对角元，系数在 Q(i) 上**逐项积分 exact 求得**，不做数值拟合；
     - 前置条件与门禁：主导系数 $A_{-p}$ 在 Q(i) 完全分裂且非亏损；$A_{-p}\dots A_{-2}$ 在该本征基下**全部对角**（非对角即拒，提示需要 formal block decoupling）；对角签名相同的分量组成 sector，低于 $u^{-1}$ 阶的项不得耦合不同 sector（耦合即拒，提示 Levelt--Turrittin + Stokes）；抽掉指数后残差 pole 阶须 ≤1（否则拒，提示需要进一步 meromorphic gauge）；
     - **奇点位置无特化**：任意有限 $z_0\in$ Q(i) 的高阶极点用平移 $u=z-z_0$ 走同一调度（`classify_point` 对有限点与 `inf` 同列分类，`build_local_solution_basis` 以 `center=gaussian_rational(point)` 接任意有限点）；变量反演 $s\mapsto \mathrm{sinv}=1/s$ **只**在端点名为 `inf` 时由 `_working_system_and_point` 施加，且对普通点/正则奇点同样适用，不是本性奇点专用步骤；
     - 一般 rational 系数系统在无 ramification 规范下的形式指数相位数学上就是 $u$ 的负幂多项式，不存在"分母更高次的有理相位"；需要 ramified gauge 或 Stokes 连接的情形一律 fail closed。
   - 3.4 Path planning, singularities and transport：命名点与 `inf` 反演、按收敛圆半径的自适应折线、规划/执行两阶段与精度门禁、缺省避奇点、**奇点折跃**与绕数分支责任、严格用户节点链。
   - 3.5 Efficiency features（用户点 5，简要，每点一两句）：**简单极点专用快速路线**（exact 认证通过后改用几何级数递推与留数直接读取，跳过通用 Cauchy 采样）、**节点覆盖桶的 fast multipoint evaluation**、多初值共享局部基的批量输运、`spawn` 进程池并行。
   - 3.6 Error control：主链/参考链双阶 refinement、embedded 认证、尾项块比诊断；明确"残差是误差估计而非通用上界"。

4. Core function II: semi-analytic regulator-series reconstruction
   - 4.1 总流程图 2；上游符号最低幂证书 `leading_power_certificate` 先行，未认证即 fail closed。
   - 4.2 **AMFlow-inspired production plan**：样本数、尺度、工作精度经验公式（`P=max(0,-n_min)`、`K=m-n_min`、`N_fit`、`alpha=P/4+goal/(K+1)`、`p0` 等），逐条标注与 AMFlow 2.0 的对应及本包的推广（`fit_extra_order` 等自由参数）。
   - 4.3 显式冗余候选池的增量消费、开复角域内至多三条均匀射线、Acb **方阵 Vandermonde 插值（不用最小二乘）**、独立验证点三方检查；池耗尽时保留当前系数但撤销精度认证。
   - 4.4 与 epsilon-jet 路线的分工（regulator 以解析 jet 进入矩阵，不做浮点采样）——只在需要时一句带过，见待办 Q-6。

5. Using the package（用户点 2：先基础，再 MMA 接口）
   - 5.1 Installation and loading：Python ≥ 3.10、`python-flint ≥ 0.6`；wheel 与源码安装；任意工作目录调用；首次 `import flintnde` 的 stderr 一次性引用提醒与 `FLINTNDE_SUPPRESS_CITATION_NOTICE`；`Needs["FlintNDE`"]` 入口。
   - 5.2 Python interface: basic commands——系统构造与奇点清单、局部基、路径规划与执行、保存点与输出布局、精度配置。命令表 + 最小可运行片段。
   - 5.3 Python interface: series reconstruction, batching and parallelism——`reconstruct_series_solution`、`fit_sampled_series`、`run_ep_tasks`、批量输运。
   - 5.4 Wolfram Language interface——`FlintNDERationalSystem`、`FlintNDEPartialFractionSystem`、`FlintNDEPlanPath`、`FlintNDEExecutePath`、`FlintNDEEvaluateEpBatch`、`$FlintNDEVersion`；选项 `ParallelTaskCount`、`MessageLanguage`、`SingularityMode`；`FlintNDEBridgeError`；JSON schema 协议与规划精度门禁对用户不可见这一点要说明。
   - 5.5 Options, validation and common pitfalls——汇总表（沿用 MadStree L1923 那节的写法）。

6. Examples（**2026-10-17 用户裁定：七例全部写入论文**；每例必须 fresh 实跑并记录输出，数字不得沿用手册旧值）
   - 6.1 Schwarzschild QNM: a two-ended radial connection problem（`qnm_2x2.py`，**物理背景与推导完整写，但只提最小必要背景、只引最小必要文献**——2026-10-17 用户裁定；素材以 `Documentation/FlintNDE.tex` subsec:qnm-example 为基）：
     - **最小引用集（共 5 条，多于此时须请示）**：`Regge:1957td`、`Zerilli:1970se`（RWZ 方程出处）、`Glampedakis:2017rar`（Darboux 变换）、`Leaver:1985ax`（QNM 谱定义与连分数法）、`Berti:2009kk`（列表频率出处）。`Chandrasekhar:1975zza`、`Kokkotas:1999bd`、`Nollert:1999ji` 默认**不引**（除非用户点名）。背景文字压缩到：一段三句以内——RWZ 主函数方程、QNM 边界值问题定义（视界纯入射+无穷远纯出射、离散复谱）、本例做什么连接问题。
     - **输运基（写作时必须写对，2026-10-17 已核实）**：输运的是**朴素 companion 对 $(u,u')$**——第二个分量就是 $u$ 的导数，**不是**入射/出射振幅。入射/出射内容只出现在边界记录层：视界 `{a,b,C}` 给 $(u,u')$ 基下两条 indicial 余量——allowed 支 $a=0$、$C=[1,-b_h/a_h]$（$c_1$ 由方程一阶修正固定 $a_h c_1+b_h c_0=0$）；forbidden 支公共幂 $-a_h$、$C=[0,\,1-a_h]$（$u$ 从幂 $1-a_h$ 起、$u'$ 低一幂，记录取两分量最低公共幂）。无穷远 `{phi,a,b,C}`：指数相位 $\exp(\pm w z^{-1})$（$z=1/x$，$w=i\omega$）即 $e^{\pm i\omega r_*}$；代数余量幂 outgoing 为 $3-2w$、incoming 为 $3$（outgoing 多出的 $-2w$ 来自 $r_*=x+\ln(x-1)$ 的 $\ln$ 因子与视界前因子的差）；$C=[1,\pm w]$ 恰为平面波本征矢（$S_\infty$ 的列）。手册里 $S_\infty$ 对角化的 $a'=[\Lambda_\infty+R_0/x+R_H/(x-1)]a$ 是等价的"组织形式"（$a$ 为局部入/出振幅）；代码输运 companion 形式，端点的对角化/shearing 由包的局部机制自行完成。论文两种呈现都可用，但**不得写成输运变量是入/出振幅**。
     - 推导链（从二阶方程起到 2x2 一阶系统）：单位 2M=1、坐标 $x=r/2M\in(1,\infty)$、tortoise $r_*=x+\ln(x-1)$；奇宇称 RW 方程写成手册 Eq.~(qnm-original-rw) 的形式（位势 $V=(1-1/x)[\ell(\ell+1)/x^2-3/x^3]$）；偶宇称不必单列方程——固定 $(\ell,\omega)$ 下 Zerilli 主函数及其导数经 **Chandrasekhar--Darboux 变换**由 RW 主函数对给出（引 `Glampedakis:2017rar`），这就是"统一 u"的含义之一；前因子 $u^-_o=x^{\alpha_0}(x-1)^{\alpha_1 i\omega}u$、$(\alpha_0,\alpha_1)=(3,-1)$（即 config 的 it0/it1）消去两个有限点的二阶极点（$x^3$ 收中心 $x=0$ 的代数行为，$(x-1)^{-i\omega}$ 收视界入射平面波 $e^{-i\omega r_*}$，因 $r_*\sim\ln(x-1)$）；$U=(u,u')^T$ 的 companion 系统即代码矩阵，$S_\infty$ 组织形式照手册 Eq.~(qnm-residue-matrices) 抄。
     - 边界条件的来源要说透（这部分不可省）：视界入射/无穷远出射是物理边界条件（经典微扰无出视界流、无入无穷远流）；本例里它们表现为"抽掉已知端点因子后 indicial 领头幂为零"——零根标注的是渐近平面波的**正则余量**而非物理常数波；两端基在公共匹配点连接，QNM 条件即连接矩阵的禁戒分量为零。
     - **本例算的"主对象"要写明**：输运的是统一主函数对 $(u,u')$，做的是**两端连接问题**，计算连接矩阵与禁戒分量比；**没有任何积分族/主积分**——QNM 例不涉及 integral family，"master"指黑洞微扰论的 master function，这点必须显式与 Sec. 2 的积分族语境区分开，防误解。
     - 验证内容：列表格频率下双方向禁戒比 ~1e-15、频率偏移 1e-3 的反事实对照 ~4e-3（手册表格数字须 fresh 重跑）；inf 的形式渐近展开（$A_{-2}$ 单重互异谱、最近指数根差 + q=3 规则定首匹配点 $x\simeq74.20$、五阶块比 ~0.02）；独立二阶标量递推对照 ~1e-42；采样半径分数 0.40 的 Cauchy--DFT 混叠说明；"形式/Gevrey 展开而非收敛 Frobenius 盘"的定性说明。
     - 频率约定注意：脚本精确频率 `iw` 与物理频率 $\omega$ 的映射（$\omega=-i\cdot\mathrm{iw}$，列表值 $2M\omega=0.74734-0.17792i$ 的 $\ell=2,n=0$ 基频）写作时从 config/手册双向核对后再落笔。
   - 6.2 Regular-singular and exponential-type boundaries with save points（`regular_singular_save.py` + `exponential_boundary_save.py`）：两个标量教学例合并一节，各一段——`y'=2y/x` 的 `{a,b,C}` 与 `y'=y/x^2`（解 $C\,e^{-1/x}$）的 `{phi,a,b,C}`，展示保存点 JSON 的写与 round-trip 复用。
   - 6.3 Regulator Laurent-series reconstruction（`ep_series_reconstruction.py`）：证书先行、候选池前缀消费与增量扩阶、独立验证点、复角域三射线、并行；闭式系数 1/ep、2 的复原。
   - 6.4 Batch evaluation in parallel（`ep_parallel.py` + `ep_parallel_mathematica.wl` 合并）：固定 regulator 值的有界多进程批处理，Python 与 Wolfram 两侧同一合同（`run_ep_tasks` / `FlintNDEEvaluateEpBatch`），闭式 $2^{\varepsilon}$ 对照。
   - 6.5 Wolfram interface walkthrough（`mathematica_interface_example.wl`）：exact 有理矩阵→规划→执行→闭式对照，展示规划/执行分离与选项面。
   - 6.2b/顺序微调允许：写正文时按"教学例→接口例→重构例→QNM 压轴"或"QNM 先行"重排，以叙事最顺为准，但每例的验证数字一律 fresh 取证。
   - 16×16 `check_01_nde_npackage_16x16` 与 validation 目录进 Sec. 7（Verification），不进本节。

7. Verification against independent references
   - 沿用 MadStree 该节的"逐条说明比对对象与独立性"写法：Python 回归 181 项、Wolfram 26 项、独立验证 validation-01/02 fresh 报告、`check_01_nde_nlqnm_2x2`、`check_01_nde_npackage_16x16`。**数字须重跑取证后才写**（见待办 V-1）。

8. Summary and outlook
   - 已实现边界 + 仍 fail closed 的一般 Katz / Levelt–Turrittin / Stokes 连接、代数扩域与 ramification；发布前补同输入 benchmark 与平直时空费曼积分例子。

9. `\section*{Acknowledgments}` —— 逐字节复制 MadStree L2936–2938（NSFC 12505094 与 CUPB 2462025YJRC019）。

Appendix A. Public functions —— Python `__all__`（79 个名字）分类表 + WL 符号表；沿用 dSIBP `app:api` 表格样式。
Appendix B（可选，视 Q-5 而定）. Exact arithmetic and schema records —— `Q(i)` 域运算、JSON schema 名清单、fail-closed 语义表。

---

## 三、写作注意事项（用户六条的落地条款）

- N-1 **背景只作简要铺垫**。唯象句子不超过两句；不得把 intro 写成 dS 综述。平直时空主流包必须逐个引用（FIRE/Kira/AmpRed/DiffExp/AMFlow），且明确本包的 regulator 解析幂次重构是**参考 AMFlow 实现**的。
- N-2 **mma 接口分 subsection，先基础后接口**（大纲 5.2→5.3→5.4）。两套命令不得混在同一 subsection；`__all__` 公开对象与"模块级公开但不在 `__all__`"的对象（`regular_point_de`、`epsilon_jet_de`、`mathematica_bridge`、`savepoints`）要分开说，不得把后者写成顶层 API。
- N-3 **AI 声明照 MadStree 骨架，但删掉一切"指导理论推导"的说法**，因为本文没有理论推导。拟定稿（待用户确认）：
  > *Statement on AI use.* The authors designed the package notation, user-facing functions and input formats, and set the overall direction of the implementation. Several agent programs, each driven by a different large language model, implemented the package and its documentation under the authors' guidance. The validation combines comparisons with independent references and cross-language consistency checks with internal certification gates.
- N-4 **署名单一作者**：Jiaqi Chen，两条 affiliation 与邮箱从 MadStree 原样复制；Acknowledgments 原样复制。MadStree 里的 `Dong Zhang` / `Tianjin University` / `yanyandreamer@tju.edu.cn` **不得出现**。
- N-5 **技术细节"够清晰即止"**。dlog（单极点+留数）专用优化、路径规划、奇点折跃、fast multipoint、并行各自不超过 2–3 句正文 + 图节点指向，细节进附录或手册；读者视角是"我能得到什么、什么时候会被拒绝"，不是"如何实现"。
- N-6 **generalized power series 必须引 `Moriello:2019yhu`**，并在 intro 就提及本包在对数之外为本性奇点加入了指数因子 $\exp(Q(u))$（$Q$ 为局部变量负幂多项式、系数 exact 求得）——**一句带过，不作卖点**（用户定调：只是遇到时能额外处理，不系统）；同时说明 DiffExp/AMFlow 用的是同一数学结构（只在 log 范围内）。手册 L774、L1036 已引该文献，正文首次出现要与手册口径一致。

## 四、跨论文动作

- C-1 **MadStree 论文缺 `Moriello:2019yhu`**：`papers/madstree/references.bib` 无该条目，正文只在 L114/L130 引了 `Chen:2024glu` 的幂级数解，未给 generalized power series 的一般文献。需在 MadStree 论文撰写会话里补引——合适位置是 intro 讲平直时空数值输运工具（DiffExp/AMFlow 那句）处，以及 Sec. 2 首次构造局部幂级数解处。**提醒措辞（用户已定调）**：MadStree 用不到 generalized power series，该文献只是**作为平直时空方法发展的背景文献**被引用（引 AMFlow/DiffExp 时顺带引出），**不要在稿件里刻意强调 MadStree 没用到它**，也不写成"本文使用该结构"。`papers/dSIBP/references.bib` 同样没有，但 dSIBP 不做数值输运，**是否补引由用户裁定**（默认不动）。
- C-2 待用户确认后，用 builtin 会话工具把 C-1 转达给 MadStree 论文会话；未经确认不发消息。

## 五、高阶功能是否写入论文 —— 征询清单（代码盘点结果，非 README 转述）

标 [D] = 已写入 README/手册；[L] = 只在历史版本更新日志出现、现行文档缺；[N] = 文档完全未提。

- Q-1 简单极点（dlog 型）快速路线：exact 结构认证 + 恒等重构门禁后自动切换几何级数递推，留数直接读 Laurent 系数，跳过通用 Cauchy 采样。[D] —— 建议写入 3.5，两句。**请裁定。**
- Q-2 奇点折跃 + 绕数/分支割线：匹配点方向旋转 π/4、主支约定、`lifted_evaluate(local, winding)`、折跃数上限 16、失败闭合。[D] —— 建议写入 3.4，两句。**请裁定。**
- Q-3 Lee–Moser projector-balance 的 Fuchsian 化约（exact `Q(i)`、逐轮幂等投影、round-trip 认证）。[D] —— **已裁定**：写入 3.3，篇幅从简。
- Q-4 本性/不规则奇点的两条支路：严格解耦指数扇区的 `exp(Phi)·z^a log^b` 基（Phi 为负幂多项式，见 3.3 技术事实）；单重二阶 pole 的 start-only 形式渐近（固定 N 阶 + 5 阶前瞻、指数根差定匹配点、`continuation_ready=False`、跨 Stokes 一律拒绝）。[D] —— **已裁定**：写入 3.3，**一句带过、不作卖点**（用户定调：只是遇到时能稍微额外处理，不系统）。
- Q-5 公开标量尾项诊断对象 `five_term_tail_diagnostic`（分子/分母/比值/阈值/严格门禁）。[D] —— 是否单独提一句，还是并入 3.6。**请裁定。**
- Q-6 regulator 重构细节：复角域内至多三条均匀射线 [L]、显式候选池耗尽门禁 [L]、增量扩阶复用 [D]、Acb 方阵 Vandermonde 且 `least_squares_used=False` [D]、`rationalize_sample_points` [D]。—— 是否全写进 4.3。**请裁定。**
- Q-7 epsilon-jet 路线：regulator 作为作用点平移、解析 jet 逐阶进入矩阵、`k^0 log^0` 有限部提取（`epsilon_jet_de.py`、`regular_point_de.py`，模块级公开）。[L/N] —— 这条与 QNM 的 `solve_k0_finite_part` 绑定较深，**请裁定**是否写入、写入哪节、是否降级为一句展望。
- Q-8 奇点目标求值 `evaluate_singular_target` / `plan_singular_target_match`：removable / true-pole / log-divergent 三分量分类，命中 dlog pole 序列化为 `Infinity` 文本，末端隐藏匹配点。[L] —— **现行 README 未写**，建议写入 3.4 并顺手补文档。**请裁定。**
- Q-9 fast multipoint evaluation（同节点覆盖桶、`acb_poly` algorithm="fast"、阈值 8 退回 Horner）。[D] —— 建议 3.5 一句。**请裁定。**
- Q-10 严格用户节点链 `direct_user_point_path`（不插点不删点、穿奇点 fail closed）。[D] —— 建议 3.4 一句。**请裁定。**
- Q-11 多 Frobenius 初值批量输运 `transport_frobenius_boundaries_refined`（共享局部基与 Taylor 矩阵、逐列门禁）。[D] —— 建议 3.5 一句。**请裁定。**
- Q-12 进程池并行 `run_ep_tasks`（spawn + maxtasksperchild=1 隔离 FLINT 全局精度上下文）与 WL 侧 `ParallelTaskCount`。[D] —— 建议 3.5 一句。**请裁定。**
- Q-13 浮点输入的精度感知判别 `numeric_structure.py`（`NumericalFrobeniusOptions`、`_ZeroAudit` 记录最大被判零量、binary64 按 15 位可靠十进制封顶、特征值聚类）。[N] —— **现行 README/手册均未提**。是否写入附录 B。**请裁定。**
- Q-14 保存点体系 `(coordinate,"save")`、逐点即时写、`continuationReady=false` 标记 start-only 输出、中途失败禁写 complete summary。[L] —— 建议 5.2 提一句。**请裁定。**
- Q-15 精确 `Q(i)` 代数后端（无外部 CAS：square-free 分解、charpoly、rref、nullspace、exact RREF 取 canonical 广义本征向量补 log 分支）。[D] —— 建议附录 B 或 2.1 一句。**请裁定。**
- Q-16 JSON schema 合同与"缺字段/多余字段双向拒绝" `require_exact_keys`、规划精度门禁、跨进程计划恢复。[D] —— 建议附录 B，正文不展开。**请裁定。**
- Q-17 引用提醒（首次 import 只向 stderr 一次，文件协议适配器可静默）。[D] —— 建议 5.1 一句。**请裁定。**
- Q-18 输出布局 `OutputLayout` 六类固定目录、禁止绝对/跨目录名。[D] —— 建议 5.2 半句。**请裁定。**
- Q-19 **不写入**：代码里没有一般 blow-up/解析变量替换（只有 `s=1/z` 无穷远反演与局部坐标平移）。MadStree 论文的 blow-up 是它自己的边界构造，**不得移植到 FlintNDE 论文**，也不得列入能力表。此项为纪律，不需裁定。

## 六、其他待办

- [x] P-1 GitHub 地址确认（2026-10-17 用户裁定用发布版地址）：与 dSIBP 同一仓库
  `https://github.com/J7C/dSIBP-Packages`（packages-final 远端核实），已写入正文 AI 声明后。
- P-2 投稿目标确认：JHEP 格式已定（`jheppub` + `JHEP.bst`，`\abstract` 宏、禁 ctex、JHEP.bst 不支持 `\citet`）；是否投 Comput. Phys. Commun. 需改类。
- V-1 所有测试计数（181/181、26/26、validation-01/02 结论）必须在正文写作前从干净结果目录 fresh 重跑取证，禁止沿用旧文档数字。
- [x] V-2 两张总流程图（2026-10-17 完成）：未另建 figures/ 位图，而是直接以手册
  `Documentation/FlintNDE.tex` 既有 TikZ 版式（box/decision/flow/fail、`[p]`/`[t]` 浮动）内嵌绘制，
  见执行记录第八节末段与 `fig:transport-workflow`/`fig:reconstruction-workflow`。
- V-3 BibTeX 纪律：每条直接来自 INSPIRE，条目前单列 `% INSPIRE:` 链接；找不到的单独报告，不自编。
  QNM 相关注解状态（2026-10-17，INSPIRE 官方 bibtex 键，勿手写变体）：
  **入稿**（最小集）：`Regge:1957td`（/literature/2454）、`Zerilli:1970se`（/literature/61120，PRL 24,737）、
  `Glampedakis:2017rar`（Darboux）、`Leaver:1985ax`、`Berti:2009kk`、`LIGOScientific:2016aoc`（/literature/1421100）。
  **已核验但默认不引**（用户裁定最小必要；要点名再加）：
  `Chandrasekhar:1975zza`（/literature/107949）、`Kokkotas:1999bd`（/literature/507420）、`Nollert:1999ji`（/literature/502903）。
- V-4 术语纪律：与 MadStree/dSIBP 保持一致——散文一律 propagator（`line` 只留给 schema 键）、"线段"不写"腿"、mode-function 的 state/bit/two-state block 用法、记号不统一时全仓清扫。
- V-5 编译校验：完整链 pdflatex→bibtex→2×pdflatex；先 `-jobname` 临时试编，0 error/0 Overfull/0 undefined，`pdftotext` 无 `??`，后才写正式 `paper.pdf`；清理 aux 类中间文件。

## 六点五、examples/ 实测清单（2026-10-17 逐文件核对，供 Sec. 6 选取）

七个例子（`package-FlintNDE/examples/`，README 与脚本正文一致）：

| 例子 | 物理背景 | 覆盖的功能（按本文件 Q 编号/章节） |
|---|---|---|
| `qnm_2x2.py` | Schwarzschild 黑洞 ℓ=2 正则模（QNM）：统一 u 二阶方程写成 exact 2×2 有理系统，视界 x=1 与无穷远两个奇点，入射/出射边界与已知基频对照 | 3.2 horizon 的 `{a,b,C}`；Q-4 inf 反演 + `{phi,a,b,C}` + start-only 形式渐近（`formal_asymptotic_order`、`formal_minimum_order_factor`、`formal_accuracy_*` 五阶诊断）；Q-1 常数+双单极点系统自动走认证递推；3.4 自适应折线；3.6 双链 refinement；Q-18 输出布局与 summary |
| `regular_singular_save.py` | 教学型标量 `y'=2y/x`（解 3x²） | 3.2；Q-14 两端无名 `save`；3.6；Q-18 |
| `exponential_boundary_save.py` | 教学型标量 `y'=y/x²`（解 C·exp(−1/x)） | Q-4 显式 `{phi,a,b,C}`；Q-14/Q-16 保存 JSON round-trip 复用边界；单链输运 |
| `ep_parallel.py` | regulator 工作流的并行演示，`y'=ep/(1+x)y`、闭式 `y(1)=2^ep` | Q-12 `run_ep_tasks` 有界池（缺省 12）；3.6 |
| `ep_series_reconstruction.py` | AMFlow 式 Laurent 重构的教学演示：零 DE + 符号边界 `1/ep+2+3ep+…`，证书 `leading_power=-1` | 核心功能 II 全套：证书先行；Q-6 七候选池前缀消费、增量扩阶复用、留 1 个未用、独立验证点不入拟合、复角域 `(-π/3,π/3)` 三射线；Q-12 `parallel_task_count`；`AnalyticMatrixSystem` 黑盒普通点路线 |
| `mathematica_interface_example.wl` | 对角有理系统闭式对照 | 5.4 全套：`FlintNDERationalSystem`/`PlanPath`/`ExecutePath`；规划/执行分离（执行不重规划）；`SingularityMode`/`MessageLanguage`/`WorkDirectory`/精度/阶数选项 |
| `ep_parallel_mathematica.wl` | 同 `ep_parallel.py` 的 Wolfram 入口 | 5.4 `FlintNDEEvaluateEpBatch` + `ParallelTaskCount`；输入序保持与闭式检查 |

**例子未覆盖、只在 tests/ 与 independent-validation/ 出现的功能**（若要进论文例子需新写或引用验证目录）：
Q-2 显式奇点折跃（`test_planned_path_and_singularity_jump.py`、validation-02/04）；Q-8 奇点目标求值三分量分类（`test_singular_targets.py`、validation-01/02）；Q-9 fast multipoint/dense output（`test_partial_fraction_and_dense_output.py`）；Q-10 `direct_user_point_path`（`test_planned_path_and_singularity_jump.py`、validation-01）；Q-11 批量 Frobenius 输运（`test_singularity_routing.py`）；Q-13 浮点精度感知 manifest（`test_frobenius.py`）；Q-7 epsilon-jet（无 example，`check_01_*` 与 validation-04/05 部分）。论文 Sec. 6 选取例子时应优先实跑 `examples/` 现成七例，缺口功能默认引用验证目录证据而不新造例子（新造须用户批准）。

## 七、执行顺序（开始写作后）

1. 建 `papers/flintnde/`，复制 jheppub 样式与 `JHEP.bst`，按大纲 0 写前置块。
2. 从 `Documentation/references.bib` 迁入并裁剪所需条目，补 dSIBP/MadStree 里 FlintNDE 需要的条目（FIRE/Kira/AmpRed/Henn/…），逐条核对 INSPIRE 链接。
3. 先写 Sec. 1 Introduction 与 Sec. 2 对象合同，**交用户过目后再往下**。
4. 写 Sec. 3、4 两大功能与两张图。
5. 写 Sec. 5 使用章（5.2 基础 → 5.4 MMA），所有命令名与选项以 `__all__` 和 `Mathematica/FlintNDE.wl` 为准。
6. 写 Sec. 6、7 例子与验证，全部数字 fresh 重跑。
7. 写 Sec. 8、致谢、AI 声明、附录 API 表。
8. 两轮独立审查：第一轮正确性（可运行性、数字、引用、fail-closed 描述与代码一致），第二轮凝练性与术语统一；各轮由独立只读 agent 承担，逐条重新取证。

## 八、写作执行记录（2026-10-17，初稿交付）

- [x] `papers/flintnde/paper.tex` 完整初稿：8 章 + 2 附录，JHEP 格式；正式 `paper.pdf` 20 页，
      pdflatex→bibtex→2×pdflatex 全链 0 error、0 未定义引用、0 Overfull、pdftotext 无 `??`；
      编译先用临时 jobname 试编、清理后出正式件（保留 .bbl/.blg，aux/log/out 已删）。
- [x] `references.bib` 35 条：从两份 INSPIRE 源库逐字复制 + 三条 INSPIRE bibtex API 现取
      （Regge/Zerilli/LIGO）+ Crossref 核验 Arb（IEEE TC 66 (2017) 8；曾误记 IJCM，作废）
      + python-flint 仓库条目。**更正**：维度递推引文由 Lee:2013hzt（实为 Lee–Pomeransky 临界点）
      换为 Lee:2010wea（arXiv:1007.2256，DRA）。
- [x] 例子八例全写、全部 fresh 实跑（2026-10-17，python-flint 0.9.0 / WL 15.0）；
      测试计数 fresh：Python 181/181、Wolfram 26/26。取数处见
      `results_temp/flintnde_paper_research/evidence_notes.md`。
- [x] **新增第八例**（用户指示）：`examples/exponential_polynomial_boundary.py`——三阶极点双 sector
      对角系统，指数多项式相位 Φ1=−3/(4z²)−1/z、Φ2=−1/(2z²)−1/(3z)（各两项负幂，超出旧例的单项
      e^{−1/x}），闭式 (e^{1/4},e^{−11/6}) 复原至 6.0×10⁻²⁵/3.9×10⁻²⁵；examples/README.md 已同步七→八。
      注意：构造时踩过 rational_function 升序系数陷阱（常数项除以 z³ 落在 z⁻³），已修正并加注释。
- [x] 第一轮独立正确性审查（无写作上下文的只读 agent，逐条取证）：无阻断级；12 条实质级全采纳修复
      （§5.2 片段改 dict 返回、规划精度门禁限定 Wolfram 路由、N_fit 第二支 K+3（含缺省
      fit_extra_order=2）、伪虚部中点/半径口径、QNM 19.2 s 为单频块（control 21.7 s）、
      例子产物布局口径、二阶导排版、Lee 引文更正、behaviour/centre 拼写、master function 措辞、
      z=1/2 说明、API 表补 5 个导出名）。
- [x] 第二轮凝练审查：必改 5 项（三例计数矛盾、摘要首句 overclaim 改 shared numerical core、
      §3.1 三处重复瘦身、eq(2.3) 机制移 §3.5、本性奇点三名统一为 decoupled essential
      singularities）+ 建议 7 项中 6 项落实（阈值公式移附录 B、log 机制拆句+定义后加具体例子、
      引言 item2/3 压缩、第三例压缩、§3.3 改引用、措辞包）；"plain" 按"朴素"原意保留。
- [x] 本性奇点定位按用户第四轮裁定执行：摘要一句提及（decoupled essential singularities，
      不作核心卖点），正文 2.2/3.3 给 generalized power series 形式（含指数多项式相位与门禁），
      明示"no systematic treatment of general high-order poles is attempted"。
- [x] 遗留项已全部收口（2026-10-17 用户指示"该画的就画/用发布版地址/复制进发布版"）：
      两张总流程图已按手册 `Documentation/FlintNDE.tex` 既有 TikZ 版式（box/decision/flow/fail
      样式、`[p]`/`[t]` 浮动、caption 逐节点指向 subsection）画入正文——Fig.1 输运管线（§3.1，
      `fig:transport-workflow`）与 Fig.2 regulator 重构管线（§4.1，`fig:reconstruction-workflow`，
      含"no: extend with remaining candidates"回流箭头）；重编译 22 页、0 error/0 未定义/0 Overfull，
      fitz 几何核 图形范围 x∈[110.9,484.4]/[130.8,457.5] 均在版心内，三支盒子无重叠（间隙 ≥7.8pt）。
      仓库地址已按 dSIBP 先例写入 AI 声明后：`\url{https://github.com/J7C/dSIBP-Packages}`（P-1 关闭）。
      AMFlow 2.0 句已补实证细节：desolver 输入为 Mathematica 格式的裸 DE 矩阵文件 + 边界值文件 +
      job.yaml（GitLab examples/differential_equation_solver_cpp/input_files/{diffeq,boundary} 取证）。
- [x] 发布版同步（packages-final/FlintNDE）：第八例已复制并改发布版 bootstrap（PACKAGE_ROOT 指向
      包根），发布树内 fresh 实跑 PASSED（6.0×10⁻²⁵/3.9×10⁻²⁵ 与 dev 一致）；examples/README.md
      与版本 README.md（七→八例）已同步；QNM 手册小节旧数字已按发布树内 fresh 运行更新
      （块比 2.9034×10⁻³/3.1998×10⁻³ @N=38、独立递推 3.3×10⁻³⁶/9.4×10⁻³⁶；主表四数、
      x≈74.196、3.75×10⁻²² 与旧值相同），FlintNDE.pdf 已重编（35 页不变，0 error/0 未定义/0 Overfull）。
      版本身份核对：pyproject=1.0，无 0.5.0 残留。差异定性：块比/递推两处并非误差范围内差异，
      系旧手册运行配置不同（旧文写 "at reference order 55"，现行脚本五阶诊断在请求阶 N=38 报出），
      已如实改为新值并以发布树运行为准。
- [x] 第五轮增改（2026-10-17 用户指示：全曲线/记忆更正/AMFlow 定位/独立审查/同步推送）：
      (1) QNM 例新增第三块全曲线：tortoise 均匀网格 721 点一次规划执行，1e-10 相对精度；
      κ=0.06 短步长（默认 1/4 下双链端点差 109.98 失败，如实写入论文）；论文 §6.5 增
      "Full radial profile" 段 + Fig.3（fig_qnm_curve.pdf，左 Re 近域窗口/右 log10|u_o| 全程）；
      双端块计时按新 run 更新为 18.4/20.0 s。坐标惯例经调研定案：tortoise 截断 + 实部
      近域 + log 幅度（QNM 特征函数两端指数增长，GRG 2025 Heun 综述原句；谱方法另用
      紧致化坐标）。
      (2) §3.5 第 2 条改写为 "Lookahead node selection and fast multipoint evaluation"：
      前瞻规则（reach=0.9·min(κ_user,1/4)·R，取最远可达用户点为下一节点，跨过点共享
      段系数）按 singularity_jump.py 代码核实写入；intro 增 desolver 定位句（AMFlow 轻量
      NDE 访问 vs 本包路径规划/多点覆盖/本性奇点）。
      (3) 记忆更正：figures-follow-originals 条目已删（原为 PPT 课件场景，范围扩大过头）。
      手册（dev+release）QNM 小节各增曲线段；两手册 PDF 重编（35 页，0 error/0 Overfull）。
      论文 24 页、0 error/0 未定义/0 Overfull。
