# kinematic-flow / wavefunction 公式补充计划

## 适用范围

本计划覆盖 `000_note/massless_loop_dS.tex` 中以下部分：

- `背景与 Feynman 规则`
- `从 tq 表示到 xq 表示`
- `xq 表示中的 wavefunction coefficient`
- `tq IBP 关系`

## 参考资料

- `参考资料（文献、笔记、代码）/papers/kinematic_flow/2403.07050v2_Cosmological Amplitudes in Power-Law FRW Universe.pdf`
- `参考资料（文献、笔记、代码）/papers/kinematic_flow/2410.17192v4_A Note on Kinematic Flow and Differential Equations for Two-Site One-Loop Graph in FRW Spacetime.pdf`
- `参考资料（文献、笔记、代码）/papers/kinematic_flow/2410.17994v1_Kinematic Flow for Cosmological Loop Integrands.pdf`
- 当前笔记 `000_note/massless_loop_dS.tex`
- `参考资料（文献、笔记、代码）/papers/dS_IBP/2401.00129v5_Towards Systematic Evaluation of de Sitter Correlators via Generalized Integration-By-Parts Relations.pdf`
- `参考资料（文献、笔记、代码）/papers/dS_IBP/2604.14549_Loop integrals in de Sitter spacetime - The parity-split IBP system and d log-form differential equations.pdf`

## 逻辑大纲

1. 先补 wavefunction conformal scalar 的基准 Feynman 规则。
   - 输入：kinematic-flow 文献中的 conformal scalar wavefunction 规则。
   - 产出：正文公式列出 bulk-to-boundary、bulk-to-bulk、顶点时间积分和 wavefunction coefficient 的基本图积分。
   - 后续用途：作为 kinematic flow 与本项目 correlator/tq 族对比的基准。

2. 补 t→x 变换的公式化版本。
   - 输入：当前笔记已有指数函数与 Gamma 函数表示，以及 kinematic-flow 文献中的 boundary energy integral 结构。
   - 产出：写清楚每个时间积分如何变成 x 积分，顶点能量如何进入分母。
   - 后续用途：连接当前 `xq` 分母 `D_i` 与 kinematic-flow 的 energy hyperplane。

3. 补 wavefunction 与 correlator 函数族差别表。
   - 输入：当前笔记已有 SK correlator 规则和 massless scalar 规则。
   - 产出：用表格对比对象、传播子、time-ordering、分母结构、质量/多项式因子、k-flow 适用范围。
   - 后续用途：避免把 kinematic-flow 的 conformal wavefunction 公式直接误用到 massless correlator。

4. 更新资料 README 中的使用说明。
   - 输入：正文新增公式后的结构。
   - 产出：标明每篇文献被用于哪些公式，不再只是参考文献列表。

5. 统一本项目 convention，并补充超平面排列解释。
   - 输入：用户指出不能直接沿用文献的 `X,Y` 记号，以及需要解释 `D_i=0` 曲线和 `d\log u=0` 临界点方程的关系。
   - 产出：正文中用 `k_1,k_2,k_3,q_1,q_2` 作为主记号，并在函数族首次引入处定义 $q_1=|\boldsymbol{q}|$, $q_2=|\boldsymbol{q}+\boldsymbol{k}_3|$；补充 twisted cohomology 中超平面、临界点、bounded chambers/主积分计数的对应关系。
   - 后续用途：避免把 kinematic-flow 文献 convention 与本项目 convention 混用。

6. 将主积分个数的图形解释改成例子驱动。
   - 输入：用户指出原解释仍不直观，需要一个提供 insight 的简单例子。
   - 产出：先用一维区间拆分说明“内部边界在通分后抵消”，再推广到二维三角形拆分，最后回到图 2 的两个有限三角形。
   - 后续用途：让主积分计数不依赖数学黑话，而是从通分和图形粘合关系看懂。

7. 消除正文重复讨论，集中到附录。
   - 输入：用户指出公式 2.21 附近已有相关讨论，后文 proofbox 重复。
   - 产出：正文只保留结论和指向；详细的一维例子、二维三角形解释、临界点方程关系统一放入附录。
   - 后续用途：正文保持推导主线，附录负责解释图形直觉。

8. 补充 tq 表示中 massless 两 theta、massless 单 theta、massive 两 theta 的 IBP 策略对比。
   - 输入：用户关于 A/B/C 的结构性判断，以及 dS IBP 文献中 massive Hankel/remaining-term/parity-split 的性质。
   - 产出：在 `tq IBP 关系` 章中加入一个专门小节，用正文分点定义 A/B/C；明确 A 相对 C 的无质量简化是端点导数指标满足 $(1,0)=-(0,1)$，而 A 相对 B 的复杂性只是需要额外跟踪反对称组合；最后说明为何纯 massless 更倾向于按单 theta 族分别做 IBP/DE。
   - 后续用途：指导后续 Kira/DE 的积分族选择，避免无质量情形沿用 massive 两 theta 合并策略。

9. 统一 tq 表示的时间幂次 convention。
   - 输入：当前笔记 `tq IBP 关系` 章中族定义与时间 IBP 公式。
   - 产出：所有 tq 族的 $\tau$ 幂次写在分子，例如 $(-\tau_i)^{a_i}$；tq 函数族定义不默认额外携带 $\epsilon$，若需要调节则由具体项把 $a_i$ 取成带调节量的值；时间 IBP 的权重项统一为 $-a_i\mathcal{I}[\ldots,a_i-1,\ldots]$。
   - 后续用途：与“积掉 $\tau$ 后产生能量分母幂次”的物理/计算直觉保持一致，避免把 tq 指标误当作分母幂次，也避免把边界调节量硬写进所有 tq 族。

10. 更新单圈内线模长 notation。
   - 输入：项目 notation 规则和当前 bubble 公式。
   - 产出：单圈图中内线模长使用 $q_i$；当前 bubble 固定为 $q_1=|\boldsymbol{q}|$, $q_2=|\boldsymbol{q}+\boldsymbol{k}_3|$，后续公式使用 $q_1,q_2$。
   - 后续用途：降低长模长表达在公式中的视觉负担，并兼容后续更多外腿单圈图。

11. 修正 tq 小节中单传播子分支和 Hankel building block 的记号。
   - 输入：公式 5.9--5.12 附近的 A/B/C 对比段落，以及 dS-IBP 对 Hankel building block 的记号习惯。
   - 产出：Hankel 写作 $h_{\nu}(n;q_i\tau_a)$；time-ordering 符号写作第 $i$ 条传播子的 $\sigma_i=\pm$；A 类端点导数标签先写作 $\{n_{i,1}n_{i,2}\}$，最终压缩成 $\{n_i\}$ 并放入 $\mathcal{I}[\cdots]$ 的变量列表内部。
   - 后续用途：避免端点标签与 Heaviside 分支上标混淆，并清楚表达 massless 相对 massive Hankel 族的简化关系。

12. 统一 A 类两 Heaviside 合并处理的 tq-IBP 记号。
   - 输入：`tq IBP 关系` 章中 A 类两 theta 家族的定义、时间 IBP 和动量 IBP。
   - 产出：5.1 先给 bubble 的 naive 四端点导数积分定义式 $\mathcal{I}_{\pm}^{\mathrm{naive}}[\{n_{1,1}n_{1,2};n_{2,1}n_{2,2}\},\cdots]$，只作为来源说明；A 类 subsection 中说明同一对顶点之间多条传播子只有两项互斥 Heaviside 分支，并把每对顶点的端点标签 $\{n_{i,1}n_{i,2}\}$ 进一步化为单指标 $n_i=0,1$，最终用 $\mathcal{I}_{\pm}[\{n_i\},\cdots]$ 写 IBP；B 类单 theta 族不带端点标签，保持 $\mathcal{I}_{\sigma_1,\sigma_2}[a_1,a_2,a_3,a_4]$，并同样给出完整积分定义式。
   - 后续用途：把 massless 特有的 $\{10\}=-\{01\}$、$\{11\}=q_j^2\{00\}$ 关系直接吸收到 A 类的对称/反对称单指标表示中，避免用每条传播子的多端点标签作为最终族记号；同时说明若要和有质量 Hankel 族放在同一框架中处理，A 类两 theta 合并方式更容易与 massive 的两 theta/Hankel building block 组织方式对齐。

13. 补充积掉 $\tau$ 后的 tq 等价函数族。
   - 输入：5.4 无阶梯 $(+-)$ 情形、5.3 B 类单 theta IBP，以及当前 bubble 的 $q_1,q_2,k_1,k_2,k_3$ 记号。
   - 产出：5.4 直接完成 $\tau_1,\tau_2$ 积分，给出 Gamma 函数和四个分母槽位的指标族定义；新建 5.6 说明 B 类中全微分作用于 theta 只给 subsector，因此 topsector 内可去掉 theta、先积掉时间，并定义带 $\sigma_i$ 的 topsector 等价函数族。
   - 后续用途：为每个 sector 内的 dlog 基构造提供纯能量分母表示；若要联立不同 sector，则保留把 $\tau$ 积分部分当作统一积分核的视角可能更系统。

## 检查点

- LaTeX 编译通过。
- 新增公式没有使用 `k_s`，外部尺度仍为 `k_1,k_2,k_3`。
- wavefunction 对比公式必须先用本项目记号；若提到文献记号，只能作为括号说明。
- t→x 不称为“梅林变换”。
- 红字只保留真正待完成/待确认内容。
- `tq` 或类似族标号不混入段落中。
- A/B/C 对比中不得把 massive 文献的 `P_i,k_s,h` 记号直接搬进正文主公式；正文仍用 $k_1,k_2,k_3,q_1,q_2$，且在函数族首次引入处定义 $q_i$。
- tq 表示中 $\tau$ 幂次必须在分子，时间 IBP 移位方向为 $a_i\to a_i-1$。
- 单圈图中不要反复写长模长；定义 $q_i$ 后，公式、分母和指数相位统一用 $q_i$。
- tq 小节中 $\sigma_i$ 只取 $+$ 或 $-$，不写成 $+1/-1$；若出现端点导数标签，必须放在 $\mathcal{I}[\cdots]$ 内部。
- A 类两 theta 的 tq-IBP 不使用 $\widetilde{\mathcal{I}}$ 顶层族；naive 多端点标签只用于说明来源，最终 IBP 记为 $\mathcal{I}_{\pm}[\{n_i\},\cdots]$，其中 $i$ 标记顶点对、$n_i=0,1$ 表示对称/反对称组合。B 类单 theta 族不加这些端点标签，但必须给出完整积分定义式。
- 积掉时间后的等价函数族也必须用括号指标表示，并显式定义每个分母槽位；带 $\sigma_i$ 的 B 类表达式中不得漏写 $\sigma_i$。
