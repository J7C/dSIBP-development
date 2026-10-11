# MadStree 论文初稿全文对抗性检查与逐条裁定（2026-10-11）

## 0. 检查设置

- 检查对象：`papers/madstree/paper.tex`（修订前 2423 行）。下文所有"报告行号"均指**修订前**行号，"落点"指修订后行号。
- 检查方式：六个互不共享上下文、也没有写作上下文的只读检查 agent 并行执行，只读不改文件。分工：
  1. 摘要 + Introduction + Sec.3.1（记号与 convention）；
  2. Sec.3.2–3.3（IBP block、递推、d log 形 DE）；
  3. Sec.3.4–3.6 + Sec.2 + App.A（remaining term、边界 blow-up、共同 theta bundle）；
  4. Sec.4（安装、输入格式、核心函数、数值流程、选项表、常见坑）对照 `package-MadStree/versions/MadStree-v0.17/` 源码；
  5. Sec.5–6（随包例子、两个应用例、总结）对照仓库例子文件与图件；
  6. 全部 59 个被引键逐条对照 INSPIRE 返回，并核对正文对该文献的刻画。
- 意见门槛：只报四类缺陷（论证跳跃、符号完整性、推导正确性、陈述与来源不符），且必须"不改就会让读者读错、读不下去，或让论文里某句陈述不成立"，并自带证据。可不改的意见不得进入报告。
- 裁定方式：本报告的作者对每一条**重新取证**，不采信检查者的自述结论。证据来源优先级：内核源码 `Kernel/**.wl` > 内嵌后端 `Vendor/FlintNDE/**.py` > 随包例子与 `test/` > 手册 `Documentation/tree_formula*.tex` > 文献原文与数值验证。

判定汇总：**共 19 条 = 成立 15 条（其中 2 条各含 1 项被驳回的子论断）／不成立 2 条／无法核验 2 条。**15 条成立项全部已改入正文。

| 编号 | 报告者 | 缺陷类别 | 修订前位置 | 裁定 | 落点（修订后） |
|---|---|---|---|---|---|
| F1.1 | A1 | (c) | 283（并 856） | 不成立（指错位置；其前提式本身为伪） | 见 §2 |
| F1.2 | A1 | (b) | 311 | 成立 | 316 |
| F1.3 | A1 | (d) | 380 | 成立 | 384–386 |
| F2.1 | A2 | (c) | 421–437 eq:component-energy | 成立（子论断"应为 $+\varsigma_{v_e}$"驳回） | 427–448 |
| F2.2 | A2 | (c) | 740–756 eq:global-Aminus/Aplus | 成立 | 758–780 |
| F2.3 | A2 | (b)(d) | 669–672 vs 726–732 | 成立（下游推论"极超曲面论断被推翻"驳回） | 737–747、857 |
| F2.4 | A2 | (d) | 420–421 | 成立 | 426–432 |
| F2.5 | A2 | (a) | 727–728 vs 341/613/685/741 | 成立 | 749–757、781 |
| F3.1 | A3 | (c) | 1009–1014 | 成立 | 1034–1037 |
| F3.2 | A3 | (b) | 1027 | 成立 | 1055–1060 |
| F4.1 | A4 | (c)(d) | 1687 eq:regulator-fit-count | 成立 | 1718–1724 |
| F4.2 | A4 | (d) | 1144 载入语句 | 不成立 | 见 §2 |
| F5.1 | A5 | (d) | 1831–1833 Sec.5 导语 | 成立 | 1866–1877 |
| F5.2 | A5 | (d) | 1911–1912 基准归属 | 成立 | 1947–1949、2077–2079 |
| F5.3 | A5 | (d) | 2231–2238 bubble 独立扫描 | 无法核验 | 见 §3 |
| F5.4 | A5 | (d) | 2256–2260 Sec.6 空节 | 成立 | 2292–2328 |
| F6.1 | A6 | (d) | 175–177 成果归属 | 成立 | 176–179 |
| F6.2 | A6 | (d) | 84 proves | 成立 | 84–86 |
| F6.3 | A6 | (d) | `dSIBP:inPreparation` | 无法核验 | 见 §3 |

## 1. 成立项逐条

### F1.2 `$s_i$` 取值范围两处冲突（实质）

原述：`eq:vertex-integral-family` 尾注写 `a_i,s_i\in\{0,1\}`，而 `$h^{(s)}$` 的分支在 Sec.3.1 定义为 `$s\in\{1,2\}$`，`$h^{(0)}$` 无定义。
取证：定义处（修订前 269/275 行）确为分支标号 `$s\in\{1,2\}$`；状态位才是 `$a_i\in\{0,1\}$`。同一式里两个不同性质的指标共用一个取值集合，读者会以为存在 `$h^{(0)}$`。
落点：316 行拆成 `a_0\in\mathbb Z,\quad a_i\in\{0,1\},\quad s_i\in\{1,2\}`。为吸收新增文字，式尾分隔由 `\qquad` 降为 `\quad`（否则该式溢出 1.19 pt，见 §4）。

### F1.3 `$\sigma_e$` 的交叉引用锚点落空（实质）

原述：隐藏数据清单称"the propagator sign $\sigma_e$ of \eqref{eq:sk-propagators}"，但 `eq:sk-propagators` 只列出 `$G_{++},G_{--},G_{+-},G_{-+}$`，式内没有 `$\sigma_e$`。
取证：`$\sigma_e=\pm1$` 的实际定义在 `eq:contact-weight`（修订后 574 行附近）；`$\epsilon_{ve}$` 定义在 `eq:incidence`；`$\varsigma_v$` 定义在 `eq:phase-block`。
落点：384–386 行三个符号各自指向真正定义它的式，不再指向 `eq:sk-propagators`。

### F2.1 `eq:component-energy` 的三处陈述互斥（阻断）

原述：`$k_{0,v}$` 被定义成"theta-free 外腿与 theta-free cross 传播子模之和"，而式的第二个求和又对恰有一端落在 `$C$` 内的传播子加 `$q_e$`；于是 `$C=\{v\}$` 时式子给 `$p_{0,\{v\}}=\varsigma_vk_{0,v}-\varsigma_vq_e$`，与同一节宣称的"归约为 `$p_{0,v}=\varsigma_vk_{0,v}$`"矛盾。
取证（成立部分）：内核 `Kernel/Core/Sectors.wl:218-235` 的 `msComponentEnergy` 先把分量内各顶点的 `vertexSign*externalLegEnergy` 求和（`externalLegEnergy` 只来自输入字段里的外腿模长，`Kernel/Core/Topology.wl:92-111` 的 `msNormalizeVertex` 不往里加体内动量），再对 `masslessCross`/`masslessExternal` 分支按落在 `$C$` 内的端点加 `endpointSigns*momentum`（`Sectors.wl:224-233`）；`Kernel/Core/Sectors.wl:266-267` 逐分量写入 `componentEnergies`/`baseTimePowers`。因此"cross 传播子也计入 `$k_{0,v}$`"这句与包的实际表示不符，且"单顶点分量必归约为 `$p_{0,v}$`"的无条件断言也不成立。`test/check_core.wls:130-173` 的构造同样只把外腿和写进 `externalLegEnergy`。
取证（驳回部分）：该条附带主张"正文说带上持有它的顶点的 contour 号，即 `$+\varsigma_{v_e}$`，而式里写 `$-\varsigma_{v_e}$`，两者差一个整体号"。此项**不成立**：代码里 `$\varsigma_v$` 与 contour 号本来就是两套符号——`Topology.wl:55-56` 的 `msVertexTypeSign` 给 `$\varsigma_{"+"}=-1$`，而 `Topology.wl:61-62` 的 `msVertexTypeContourSign` 给 `"+"` 的 contour 号为 $+1$，139 行把后者逐端点写成 `endpointSigns`，`Sectors.wl:228` 用 `endpointSigns*momentum` 累加进分量能量，所以代码给分支加的正是 `$-\varsigma_{v_e}$` 的 contour 号；`test/check_core.wls:154-156` 对 `"+-"` cross 分支核对到 `endpointSigns === {1, -1}`。式中的 `$(-\varsigma_{v_e})q_e$` 与代码一致，正文"with the contour sign of the vertex that holds them"正是对 `$-\varsigma_{v_e}$` 的口语描述。
落点：427–448 行。`$k_{0,v}$` 改为"贴在该顶点上的 theta-free 外腿模长之和，在包里就是输入字段 `externalLegEnergy`"，并明确"theta-free 传播子分支不折叠进这个符号，它保留自己的模长，该模长加到持有其端点的那个分量的能量上"；再补"两端都落在 `$C$` 内的分支贡献 `$+q_e-q_e=0$`，因此本就不出现在这个求和里"；最后的归约句改为条件式："当该顶点不带 theta-free 传播子分支时，`$C=\{v\}$` 的分量能量才正好归约为 `$p_{0,v}$`"。

### F2.2 `eq:global-Aminus`/`eq:global-Aplus` 的整体符号（阻断）

原述：由 `eq:one-step-ibp`（其 `$-\text{M}_1$` 号另由同文的升幂行佐证）令 `$\cR=0$`，应得 `$\bm F_s(\bm n-\bm e_C)=+\text{M}_1(A+n)^{-1}\text{M}_0\bm F_s(\bm n)$` 与 `$\bm F_s(\bm n+\bm e_C)=+\text{M}_0^{-1}\text{M}_1(A+n+1)\bm F_s(\bm n)$`，但两式都写了前置负号；且正文声称 `A_±` 正是把 `$\bm F_s(\bm n\pm\bm e_C)$` 用 `$\bm F_s(\bm n)$` 表出，于是每步迭代约化的整体号错。
取证：按修订后 758–763 行的 `eq:one-step-ibp`（`$-\text{M}_1(A_{C,s}+n_C)\bm F_s(\bm n-\bm e_C)+\text{M}_{0}\bm F_s(\bm n)+\cR=0$`）直接移项即可复现检查者的结果，两式均应**无**前置负号。代码侧同向佐证：`Kernel/Formula/Recurrence.wl:258-285` 把当前移位用更近零的移位表出，正向分支取 `regularMatrix = m0Inverse.msM1Matrix[sector, cp, currentShift]`、`contactMatrix = -m0Inverse`，负向分支取 `regularMatrix = msM1Inverse[sector, cp, currentShift + 1].msM0Matrix[...]`、`contactMatrix = msM1Inverse[...]`，两个正规矩阵都无前置负号，且 `$\cR$` 携带的符号分别是 `$-\text{M}_0^{-1}$` 与 `$+\text{M}_1^{-1}$`，与移项结果一致。负号来源可解释为照搬文献 `$\tau^A$` 写法下 `$A_-^{(\mathrm{ref})}=-\text{M}_1^{-1}\text{M}_0$` 的形式而未按本文 `$(-\tau)^A$` 翻号。
落点：769–773 行去掉两个负号；775–780 行把 `$\cR$` 的携带号写明白（降幂带 `$+\text{M}_{1}^{-1}\cR(\bm n)$`，升幂带 `$-\text{M}_{0}^{-1}\cR(\bm n+\bm e_C)$`），并加一句：这两个符号与 \cite{Chen:2023iix} 印刷式相反，因为该文显式幂为 `$\tau^A$`、一步关系带 `$+\text{M}_1$`，本文 `$(-\tau)^A$` 带 `$-\text{M}_1$`。同时把"两方向"一句改为显式说明它们由 `eq:one-step-ibp` 移项得到。

### F2.3 `$r_e$` 一符两义，且"read off"引用失实（阻断）

原述：`$r_e$` 在 `eq:global-energy-letter` 中是 massless 共享 slot 的状态位，在 `eq:base-power` 中又成为"裸接触幂"（`$2\nu_e-1$` 或 `$0$`）；`eq:graph-index` 还把 `$r$` 用作打包标签。若读者按 `$r_e=0$` 代回 `$\kappa$`，则 `$\kappa$` 与状态位无关，两态约化被推翻。另外"as read off from \eqref{eq:R-two-vertex}"不成立，因为该式只含 massive 的 `$2\pi\cos(\pi\nu)(-\tau)^{2\nu-1}\theta$` selector，从不给出 massless 的取值。
取证：符号冲突为真——同一节里 `$r_e$` 确实两处并用（`eq:global-energy-letter` 的位 vs `eq:base-power` 的幂）。`eq:R-two-vertex` 与 `eq:massless-relations` 在后文才推出 `$2\nu-1$` 与 `$0$`，此处"read off"属于前向误引。
驳回的下游推论：检查者进一步断言"因此 `eq:ndlogDE` 的极超曲面论断被推翻"。此项**不成立**：降幂奇异条件是 `$\text{M}_1$` 的本征值 `$A_{C,s}+n_C-\sum_ia_i(1-2\nu_i)=0$`，升幂奇异条件是 `$\kappa_{v,s;\bm a}=0$`，其中的位是 `eq:global-energy-letter` 的状态位，与接触幂无关；把接触幂改名后两处不再混读，原论断不受影响。
落点：接触幂改用 `$\varrho_e$`（738–747 行），并加一句"这是传播子的固定数，不要与 `eq:global-energy-letter` 的共享状态位 `$r_e$` 混淆"；"read off"改为"as will follow from `eq:R-two-vertex` and `eq:massless-relations`"；857 行与 App.A 的分量幂式、"一个 `$(-\tau)^{\varrho_e}$` 因子"同步改名。

### F2.4 顶点指数的出处引错（实质）

原述：Block (i) 正文说"`+` 顶点给 `$e^{-\ii k_{0,v}\tau_v}$`……正如 `eq:sk-propagators` 附近所引"，但 `eq:sk-propagators` 是体–体组合 `$G_{++}$` 等，附近唯一涉及符号的式是 `$G_\pm\propto(1\mp\ii k\tau)e^{\pm\ii k\tau}$`，该式从未说明哪个 `$G$` 配哪个分支顶点，且带多项式因子。
取证：`$\varsigma_v$` 的取值由 `eq:phase-block` 就地以分段式定义（`Kernel/Core/Topology.wl:55-56` 的 `msVertexTypeSign`：`"+"` 给 $-1$，`"-"` 给 $+1$；`test/check_core.wls:159-164` 的 `vertexExternalPhaseSigns` 记录核对过这一点），与 `eq:sk-propagators` 无推导关系。
落点：426–432 行删去"as quoted around \eqref{eq:sk-propagators}"，只保留就地定义，并补一句 `\cite{Chen:2023iix}` 式 (3.1) 同样每顶点只写一个 `$k_0$`，本文不引入按腿或按 block 的指数参数。

### F2.5 合并分量上 `$\nu_{0,v}+n_v$` 未说明读法（实质）

原述：`eq:base-power` 已定义分量幂 `$A_{C,s}$`，`eq:graph-index` 也说移位按分量取值，但 `eq:one-step-ibp`、`eq:M-form`、`eq:global-A_\pm` 全写 `$\nu_{0,v}+n_v$`；对 `$|C|\ge2$` 的分量，`$\partial_\tau$` 给出的是 `$-A_{C,s}-n_C$`，文中没有任何一句说明 `$\nu_{0,v}$` 在合并后指份额还是全幂。
取证：`Kernel/Formula/TensorAtoms.wl:57-70` 的 `msM1Matrix` 用的正是 `baseTimePowers[[componentPosition]] + integerShift`（分量级），同文件 72 行的 `msM0Matrix` 与 179 行的 `msEnergyLetters` 同样只接受 `componentPosition`；`Kernel/DE/DLog.wl:25-35` 的 `msComponentLogKernel` 亦按分量取 `$\widetilde\Omega_{0}$`，代码层从来没有"顶点的 `$\nu_{0,v}$`"参与合并后的求导；因此正文必须声明这个读法。手册 `Documentation/tree_formula.tex` 同样按分量写。
落点：749–757 行"迭代约化"段首句加入：一步读到的幂与能量是分量的，即 `$\nu_{0,v}$`、`$p_{0,v}$` 在 `$v$` 已并入更大 `$C$` 时分别代表 `eq:base-power` 的 `$A_{C,s}$` 与 `eq:component-energy` 的 `$p_{0,C}$`，仅当 `$C=\{v\}$` 才回到顶点量；该读法同样适用于 `eq:ndlogDE`–`eq:global-M0-diagonal`。式内符号随之改为 `$A_{C,s}+n_C$`（759、769、772、781 行）。

### F3.1 边界 Gamma 份数按腿计数（阻断）

原述：Sec.3.5 说主积分在边界分解为"每条 massive 腿或 massless 共享传播子一份，外加每条 theta-free exponential 一份"的一维时间积分，严重超计。
取证：`eq:vertex-integral-family` 明确一个顶点只有一个 `$\int\dd\tau$`，`$n$` 条 Hankel 腿只是同一 `$\tau$` 的被积因子；Block (i) 又说明每顶点恰有一个 theta-free exponential，于是"按腿计数"与"按 exponential 计数"都退化为按顶点（合并后按分量）计数。App.A 的结论是"merge 数不随同批 contract 的传播子数增长"，同样只支持分量计数。手册 `Documentation/tree_formula.tex` 的对应段落的因子化也是逐时间分量写出。
落点：1034–1037 行改为"每**时间分量**一份：theta 冻结后一个分量只对其唯一的时间积分，它携带的腿通过小 `$\tau$` 端点系数进入这一个积分，不再产生新的积分"。1039 行附近的一维公式（`$\int_{-\infty}^0\dd\tau(-\tau)^Ae^{\ii K\tau}=(-\ii)^{A+1}\Gamma(A+1)K^{-A-1}$`）经核对正确，未改。

### F3.2 `$K_v$` 首现即未定义（实质）

原述：辅助外腿能量在 1024、1029 行记作 `$k_{0,v}^{\rm aux}$`，1027 行却写 `$K_v^{\rm aux}\to\infty$`，`$K_v$` 的语义直到数值章节才出现。
取证：边界的排序与极限变量就是虚方向上的衰减能量——`Kernel/Numerics/Boundary.wl:69-88` 为每个 rank 建 `MSDampingEnergy[id]` 并在 80 行做替换 `externalLegEnergy -> -I vertexSign*MSDampingEnergy[id]`，207 行把该定义以 `dampingDefinition -> I vertexSign externalLegEnergy` 记入顶点坐标；`Kernel/Numerics/Boundary.wl:453-522` 的逐分量构造取的正是 `componentEnergies[[componentPosition]]` 在小参数极限下的常数（485-493 行，常数为零即 `VanishingComponentBoundaryEnergy` 失败）。正文需要给出 `$K_v$` 这个名字。
落点：1055–1060 行就地定义 `$K_v\equiv\ii p_{0,v}=\ii\varsigma_vk_{0,v}$` 为**衰减能量**：在衰减射线 `$k_{0,v}\to-\ii\varsigma_vK_v$`（`$K_v>0$` 实）上，`eq:phase-block` 的指数变成衰减的 `$e^{K_v\tau_v}$`，这正是 `eq:energy-rank` 排序的量，合并后为 `$K_C=\ii p_{0,C}$`，并说明包把该替换记入 `dampingDefinition`。

### F4.1 `$N_{\rm fit}$` 第二项少了拟合余量（实质）

原述：正文写 `$N_{\rm fit}=\max(\lceil\tfrac52\Delta+P\rceil,\Delta+1)$`，而源码计数含 `+fit_extra_order`；且正文自己说"初始拟合至少包含高于用户上限的两个幂"，只有把余量计入 `$N_{\rm fit}$` 才可能达到 `$m+2$`。
取证：`Vendor/FlintNDE/flintnde/regularization.py:348-351` 的 `automatic_count = max(ceil(2.5*reconstruction_depth + pole_depth), reconstruction_depth + 1 + fit_extra_order)` 显示采样数第二项为 `($\Delta+1$) + fit_extra_order`，同函数 365-367 行的 `alpha_decimal = pole_depth/4 + goal_digits/(reconstruction_depth+1)` 与之同段；`fit_extra_order` 由 `EpFitExtraOrder` 传入，缺省 2（`Kernel/Numerics/PathEvaluation.wl:1050,1187`、`Kernel/MadStree.wl:51`）。因此第二项在 `$\Delta=0,1$` 时是 `$\Delta+3$` 而非 `$\Delta+1$`；派生的 `$p_0=\max(\lceil(N_{\rm fit}+P)\alpha_\varepsilon\rceil,30)$` 亦随之改变（该式与 `regularization.py:416` 的 `base_precision` 一致，无需改形）。
落点：1718–1724 行写作 `$N_{\rm fit}=\max(\lceil\tfrac52\Delta+P\rceil,\Delta+1+f)$`，定义 `$f=$` `EpFitExtraOrder`（缺省 2）为"拟合在用户上限之上保留的幂数"，并说明 `$\Delta+1$` 只覆盖 `$c_{n_{\min}},\dots,c_m$`、额外的 `$f$` 才是每次运行中越过 `$c_m$` 的插值余量；补上 `SampleCount` 只能抬高 `$N_{\rm fit}$`、不会低于 `$\Delta+1$`。

### F5.1 Sec.5 导语承诺了本章没有的例子（实质）

原述：导语称"reproduce the results for the tree with two vertices and one massive exchange [Chen:2024glu]"，但随包七例无一为二顶点大质量（01 是二顶点无质量 `$\nu=1/2$`，见 `Examples/01_massless_full_edge.wl:26-27`；04/05 是三顶点，见 `Examples/04:21-33`、`Examples/05:23-35`），Sec.5.2 两个应用是三顶点两大质量链与 bubble 时间核。
取证：另查 `Examples/` 全目录无二顶点大质量例子；该二顶点对照属于 `AI Use` 一节记录的独立验证任务，而非本章交付内容。
落点：1866–1877 行重写导语：Sec.5.1 列七例并说明各自覆盖（递推约化、单顶点族、时间序 chart、无质量与有质量树、零外腿能量、`sec:regulator` 的调节子重构），Sec.5.2 给两个应用并写明其数值对照是 \cite{Xianyu:2023ytd} 的多元超几何表示；把"单顶点族与二顶点大质量对照 \cite{Chen:2024glu}、IBP 与 DE 对照 `dSIBP`"归位到 `sec:ai-use` 记录的独立验证任务，并明确本章不再复现。为可引用，给 5.2 加了 `\label{sec:applications}`。

### F5.2 基准归属错配（实质）

原述：三顶点例正文写"because the physical mode functions and the printed formulae of \cite{Chen:2024glu} that we benchmark against are written in that option"，把 \cite{Chen:2024glu} 说成本例的对照基准；实际数值对照是 `Xianyu:2023ytd`。
取证：本例全部偏差与计时比都写作"from the hypergeometric result"，而该表示在 2077 行明确归给 \cite{Xianyu:2023ytd}；\cite{Chen:2024glu} 在本例中的作用只是 `$h(\nu,0;z)=z^{-\nu}H^{(s)}_\nu$` 这套 mode function 约定（与 Sec.4 坑表第 1 条一致）。
落点：1947–1949 行改为"本例在 `NuConvention -> "Negative"` 下求值，因为本例所用的 mode functions 沿用 \cite{Chen:2024glu}，该文即以该选项书写"，删去"printed formulae … that we benchmark against"；2077–2079 行把 \cite{Xianyu:2023ytd} 一句显式写成"作为数值基准（独立于 DE 构造）"。

### F5.4 Sec.6 空节（实质）

原述：`sec:summary` 只有 `\section` 与 `\label`，正文为空，而 Introduction 路线图承诺"In Sec.~\ref{sec:summary} we close with a summary and outlook"。
落点：2292–2328 行补写三段：第一段总结"三个局部 block → 一份 registry → 递推/DE/接触项，边界由能量严格排序给出，每时间分量一份 Gamma 乘积，无外腿顶点用私有辅助能量，一次输运覆盖整条路径"，并引 Sec.5.2 的批量单点成本下降与越过直接级数收敛域的解析延拓；第二段总结两条工程决定（所有会作废结果的判据都在数值之前定：`dlogStatus`、`MSBoundaryData` 需要的边界 chart 证书、调节子最低幂 `$n_{\min}$` 的支持证书；检查不过即 fail closed 返回带后端输出的 `Failure`），并如实列出留给用户的义务（奇点折跃后的分支需自行判定，边界阶与输运阶比较是稳定性检查而非总误差界）；第三段界定范围（只算顶点时间积分，圈图按固定内动量计算，不做动量积分），并把展望落在 \cite{Chen:2026dqp} 的 loop 级 parity-split IBP 与 d log 形 DE 上——动量积分及其带来的 sector 仍待建立。

### F6.1 d log 形 DE 的成果归属错配（实质）

原述：Sec.3 开头把"uniform d log-form DE"记到 \cite{Chen:2024glu} 名下。
取证：arXiv:2401.00129 摘要自述"universal formulas for iterative reduction **and d log-form differential equations** of arbitrary vertex integral family are presented and proved"，其 Sec.3.5 标题即 universal formula of d log-form DE；arXiv:2411.03088 正文 Sec.2 明写"The iterative IBP reduction and d log-form differential equations have been given in [52]"，`[52]` 即 2401.00129，其引言又说"[52] directly gives the uniform formulas … as we will review them"。本文 Introduction（修订前 90–96 行）写法本就正确，Sec.3 与之自相矛盾。
落点：176–179 行改为 \cite{Chen:2023iix} 给出广义 IBP 关系、一步升降幂递推与任意顶点积分族的 uniform d log 形 DE；\cite{Chen:2024glu} 以幂级数求解该系统并用多能限下退化点的 blow-up 定边界数据。

### F6.2 "proves" 强度不符（实质）
原述：`\cite{Liu:2022mfb} proves that the master integrals … are completely fixed once the linear relations … are given`。
取证：arXiv:2201.11637（PRL 129 (2022) 222001）摘要为"We **find** that … can be completely determined once linear relations … are provided. Examples up to 5 loops are given to **verify this observation**"，结论亦称"interesting observation has been explicitly verified by some examples"。该文未自称证明。
落点：84–86 行改为"argues that … and works this out on examples"。

## 2. 不成立项逐条

### F1.1 与旧 278 行：反射恒等式（不成立，但同段确有缺陷）

检查者主张：`$e^{-\pi\mu}H^{(2)}_{-\ii\mu}(z)=H^{(2)}_{\ii\mu}(z)$` 不成立，正确右端应为 `$-H^{(1)}_{\ii\mu}$`，依据是同段给出的 `$H^{(2)}_{-\nu}=-e^{-\ii\pi\nu}H^{(1)}_\nu$`。
裁定：**不成立（所指行号）**。数值核对（`mpmath` 40 位，`D:/anaconda/python.exe`）：

```
1) general: H1_-nu - e^{+i pi nu}H1_nu = 1.1e-41 j
   general: H2_-nu - e^{-i pi nu}H2_nu = -1.1e-41 j
2) H2_-nu + e^{-i pi nu}H1_nu = 0.4243 - 1.3059 i        (nu=0.4, z=1.3)
3) nu=i mu:  e^{-pi mu}H2_{-i mu} = 0.20952525118994817773 - 0.058739344988433082868 i
             H2_{i mu}           = 0.20952525118994817773 - 0.058739344988433082868 i
   resid = -2.9e-42
4) 检查者给出的右端 -H1_{i mu} = -1.8893 - 0.5297 i      （与 3) 不等）
```

由 `J_{-\nu}=\cos\pi\nu\,J_\nu-\sin\pi\nu\,Y_\nu`、`Y_{-\nu}=\sin\pi\nu\,J_\nu+\cos\pi\nu\,Y_\nu` 直接推出 `1)` 的两条同分支恒等式，取 `$\nu=\ii\mu$` 即得 `3)`：论文该行正确，按其"最小修复"改反而会引入错误。
同段真缺陷：修订前 278–279 行写的是一对**换分支**的反射式 `$H^{(1)}_{-\nu}=-e^{\ii\pi\nu}H^{(2)}_\nu$`、`$H^{(2)}_{-\nu}=-e^{-\ii\pi\nu}H^{(1)}_\nu$`，`2)` 的残差说明它不成立。落点：修订后 280–284 行改为同分支、相位互逆的一对，并说明因此由两支构成的归一化（如 `eq:wronskian-h`）不受 `$\nu\to-\nu$` 影响。

### F4.2 `Needs` 载入的是 `MadStree.m` 还是 `Kernel/init.m`（不成立）

检查者主张：`Needs["MadStree`"]` 解析 context 时载入的是 `Kernel/init.m`，版本根目录的 `MadStree.m` 只是另一个便捷入口，故正文"This loads `MadStree.m`"应改为"`Kernel/init.m`"。
裁定：**不成立**。headless 实测（Wolfram 15.0 `math.exe`，把版本目录加入 `$Path` 后）：

```
FindFile["MadStree`"] = "D:\Agent-projects-nut\dSibp_package\package-MadStree\versions\MadStree-v0.17\MadStree.m"
```

`$Path` 上已存在名为 `MadStree` 的目录本身，其内的 `MadStree.m` 先被解析到，`Needs` 不落到 `Kernel/init.m`。两个文件都是 `Get` 起 `Kernel/MadStree.wl` 并显式按 UTF-8 读（`MadStree.m:9-12`、`Kernel/init.m:9-12`），因此正文"which loads `Kernel/MadStree.wl` with explicit UTF-8"与"loading through `Needs` 无需用户设置编码"两句均与源码一致，未改（现落点 1175 行）。

## 3. 无法核验项（需要作者提供外部事实）

- **F5.3 bubble 例的"独立扫描/独立参考"**：正文与图注各出现一次 `$3.70\times10^{-14}$` 与"the independent reference"，但全文没有交代该参考的来源（无引用键、无随包文件、无方法描述）。仓库内的冻结审查报告 `paper-code-audit-report.md:219` 也记录当时静态审查无法核实这组测量；`git log -S` 显示该句随文件首次入库。`AI Use` 一节列出的三项验证来源（\cite{Chen:2024glu} 二顶点、\cite{Xianyu:2023ytd}+agent 泛化码三顶点、`dSIBP` 的 IBP/DE）都不含 bubble。**未改**：凭空补一个来源比留着缺口更糟，需作者指明该对照是文献、脚本还是直接数值积分，然后再落一句到 2231 行附近。
- **F6.3 `dSIBP:inPreparation`**：`@misc` 条目只有 `note = {in preparation}`，无作者、eprint、DOI、URL，外部无 arXiv/INSPIRE 记录可比对。可按本地 `package-dSibp/README.md` 自述核对方向一致（采样 naive IBP seed、产出 backend-neutral 线性系统、不执行约化），但作为文献条目它仍是不可核验的，投稿前需补作者与状态说明或由期刊处理。
- 其余 58 个被引键的逐字段核对全部通过（55 条经 `inspirehep.net/api/arxiv/<eprint>?format=bibtex`，3 条无 eprint 的经 `api/doi/<DOI>`），未发现 arXiv 号与标题/作者错配或臆造条目。

## 4. 修订后的编译与清理记录

- 链：`pdflatex` → `bibtex` → `pdflatex` ×2（`papers/madstree/`，JHEP 版式，`\textwidth=.72\paperwidth`）。
- 首轮出现 1 条 `Overfull \hbox (1.18864pt too wide) detected at line 318`，来源即 F1.2 在 `eq:vertex-integral-family` 式尾新增的 `$s_i\in\{1,2\}$`；把该处 `\qquad` 降为 `\quad` 后重编两次。
- 判据达成：`!` 计数 0，`Overfull` 计数 0，`Reference/Citation ... undefined` 计数 0；`pdftotext` 抽出后
  `Contents` 计数 1（目录未重复）、`摘要`/`目录` 中文字样 0 处。`OMS/cmtt/m/n` 的字体形状警告与 28 条
  `Underfull` 属既有噪声，非本次引入。
- 页数由 50 增至 51（Sec.6 正文补入）。
- 中间产物 `.aux/.log/.out/.toc/.bbl/.blg` 已删除。

## 5. 顺带发现但不在本次四类门槛内（仅登记，未改）

- `Documentation/tree_formula.tex:570`（中文版）与 `Documentation/tree_formula_en_full.tex:580`（英文版）
  同写"单顶点 component 的 `eq:component-energy` 退化为 `eq:signed-vertex-M0` 的 `$p_{0,v}$`"，与 F2.1
  同一处过满表述：该顶点若带 theta-free 的 massless cross/external 分支，第二求和不为零，退化不成立。
  本次按只读参考处理，仅登记，需在手册任务里同步收紧。
- 手册引用键 `Chen:2023eic` 与本文 `Chen:2023iix` 指向同一篇 arXiv:2401.00129，两库键名不一致。
- 正文若干处把 `MadStree v1.0`/`FlintNDE v1.0` 用作身份标签（如 1921 行与图注），与"版本号只出现在版本目录名与交付件文件名"的仓库纪律不完全对齐；论文语境下属交付件描述，交由用户决定是否统一。
- App.A 中分量幂记号 `$P_s$`/`$S_s$` 与 Sec.3 投影矩阵 `$\text{P}_1$` 字母相近，不构成歧义但可在后续润色时避让。
