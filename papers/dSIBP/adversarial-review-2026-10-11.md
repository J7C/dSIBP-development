# dSIBP 论文初稿全文对抗性检查与逐条裁定（2026-10-11）

## 0. 检查设置

- 检查对象：`papers/dSIBP/paper.tex`（本轮修订前 733 行，修订后 863 行）与 `figures/*.tex`。
  下文“报告位置”指修订前行号或公式标签，“落点”指修订后的公式标签或章节。
- 检查方式：三个互不共享上下文、也没有写作上下文的只读检查 agent 并行执行，只读不改文件。分工：
  1. 陌生读者可懂性与符号完整性（全文，含 Introduction 与附录）；
  2. 论文自身公式的内部一致性 + 全部数字与仓库记录比对；
  3. 24 个被引键逐条对照 INSPIRE 返回，并核对正文对该文献的刻画。
- 意见门槛：只报四类缺陷（读不懂、符号缺陷、推导错误、陈述与来源不符），且必须“不改就会让读者读错、
  读不下去，或让论文里某句陈述不成立”，并自带证据；只设阻断／实质两级。
- 裁定方式：本报告作者对每一条**重新取证**，不采信检查者的自述结论。证据来源优先级：
  内核源码 `package-dSibp/versions/023_dSIBP/Kernel/**.wl` > 随包例子 `Examples/**` >
  用户手册 `Documentation/01_dS_ibp_package/dS_ibp_package.tex` >
  内部验证报告 `000-report/2026-08-30-1307-023-内部.md` > 三篇 dS IBP 原文的 pdftotext 抽取。

判定汇总：**共 36 条 = 成立 35 条（其中 1 条含 1 项被驳回的子论断）／不成立 1 条。**
成立项全部已改入正文。此外本轮复核新发现 6 处三位检查未报的问题，一并修入（§3）。
检查者自身有一处结论被推翻：Referee B 把 `J[sectorKey, linePacks, ispList]` 列为“已验证正确”，
实际内核模式是 `J[aList_, linePacks_, ispList_]`（见 B4）。

## 1. 逐条裁定

### Referee A：可懂性与符号纪律（24 条）

| 编号 | 缺陷类别 | 报告位置 | 裁定 | 落点与依据 |
|---|---|---|---|---|
| A1 | 读不懂 | eq:family | 成立 | `eq:family` 新增 $N_s$ 定义段。依据：`LoopCore.wl` 的固定线模长幂与 Wronskian 常数因子落在 sector 归一化里。 |
| A2 | 读不懂 | Introduction | 成立 | §1 项目符号处 $J$、$L$、$K$、ISP 首现即解释。 |
| A3 | 读不懂 | §2.5 标题与全篇 | 成立 | “dynamical rules/variables” 全部删除，§2.5 改名 “Massive function systems”。 |
| A4 | 读不懂 | §2.2、§3.2 | 成立 | 补 actual 幂（$A_v,B_e$）、active 顶点、top sector、root labels 四处定义。 |
| A5 | 符号 | §2.2 pack 次序 | 成立 | 写明按声明键 `"lines"` 的次序。 |
| A6 | 读不懂 | §2.1 | 成立 | 写明 full $=\sigma_u=\sigma_v$、cross $=\sigma_u=-\sigma_v$，$++/--$ 与 $+-/-+$ 各塌成一型。 |
| A7 | 读不懂 | §2.6、例 06 | 成立 | §2.6 限定该轨只用于无圈图；含圈图的圈外线是 fixed propagator，例 06 照此改写。 |
| A8 | 陈述与来源 | 附录表 | 成立 | 去掉无来由的 “gated”，改指 §3.2；§3.2 已说明 tadpole 规则条件与作用。 |
| A9 | 推导 | 例 06 | 成立 | `Examples/06/main.wl:32-34` 显示 `externalLegEnergy -> E1/E2/E3` 为自由符号；§2.1 改为“可绑定可独立”，例 06 另说明 $\texttt{ss}11$ 来自 $k_1+k_2$。 |
| A10 | 推导 | §3.4 | 成立 | 与 B-F6 同题。 |
| B1 | 符号 | §2.2 | 成立 | $\nu_{\mathrm{ref}}$ 删除。 |
| B2 | 符号 | 全篇 | 成立 | “sector” 只指分母子集；parity 的分块一律称 blocks。 |
| B3 | 符号 | eq:contact | 成立 | 与 B-F4 同题。 |
| B4 | 符号 | §2.2 | 成立（检查者结论被推翻） | 正文改为内核真实三槽式 `J[aList, linePacks, ispList]`；`sectorKey` 只属于 `timeOnly` 公开式。 |
| B5 | 符号 | eq:family | 成立 | 槽内标签、被积函数实际幂，两级同时给出并定义。 |
| B6 | 符号 | §2.1 图注、§2.6、例 05 | 成立 | 无质量 full 线保留两标签并满足商关系；`timeOnly` 一位一态的说法限定到“massive 顶点态或 massless 商态”；例 05 按 $F_{00},F_{10}$ 重写。 |
| B7 | 符号 | eq:eom、缩并规则 | 成立 | $i$ 专职端点槽，$r$ 专职 $\rho$/ISP，Euler 式改用 $j,\alpha$。 |
| B8 | 符号 | §2.2、§2.5 | 成立 | $x=-\xi\tau$ 两处写明。 |
| B9 | 符号 | eq:euler、eq:eulerMatrix | 成立 | 重排为 $x_j,I_\alpha,\Omega_j(x)$、$\Delta=\mathrm{diag}(d_1,\dots,d_R)$ 并定义 $R$。 |
| B10 | 符号 | §2.2、§2.4、§2.5 | 成立 | preset 早用处加前指；界面串用 \texttt{"h"}/\texttt{"H"}，系数用 $P_{\mathrm h},Q_{\mathrm h}$，Hankel 块用 $H_e,\bar H_e$。 |
| B11 | 符号 | §2.3、例 03/05 | 部分成立 | 采纳 `ss`ij/`sE`i 与 $\texttt{kE}$ 顶点能量的交代。**驳回**其关于例 05 $p_{12}$ 的子论断：$p_{12}$ 是该例子用户自己声明的动量符号，正文照抄声明才对。 |
| B12 | 读不懂 | §3.3 | 成立 | 说明 `k` 为物理符号、`ik` 为后端符号、`I` 为虚数单位，manifest 存物理 section 与双向映射。 |
| B13 | 符号 | §2.1 | 成立 | 写明 fixed propagator 即程序所称 bridge，此后统一。 |
| B14 | 符号 | §3.5 | 成立 | 只称 iterative / naive 两条路线，“direct $d\log$ formula route” 专指 MadStree。 |

### Referee B：公式与数字（11 条）

| 编号 | 报告位置 | 裁定 | 落点与依据 |
|---|---|---|---|
| F1 | §2.2 零点 | 成立 | `LoopCore.wl:805` 从用户 case 读 `zeroPointRules`、缺省为空。零点段改为“属于声明”，并列出随包例子两种实际设置。 |
| F2 | 图 2 题注、§2.2 | 成立 | `SectorModel.wl:26-29`：`massiveCross`、`massiveFull`、`masslessFull` 同为三槽，只有 `masslessCross` 强制 `{b_e,0,0}`。题注与槽位列表改正。 |
| F3 | eq:eom | 成立 | `LoopCore.wl:1349-1357` 的 $a$ 位移作用在被约端点本身，改为 $a_{e,i}\to a_{e,i}-1$。 |
| F4 | eq:contact | 成立 | `LoopCore.wl:3055-3091`：对同一顶点 theta 支撑重合的线束 $B_v$ 取非空奇子集，每个子集给出**一个**积分，系数为子集各线缩并系数之积。子集改记 $Q$ 以避开 $b_{S,e}$。 |
| F5 | §2.4 | 成立 | 见 §3 第 1 条，整段重写。 |
| F6 | §3.4 | 成立 | 各例子 `deVariables` 含顶点能量、不含质量标度；变量表改为 $\texttt{ss}ij$、$\texttt{sE}i$、$E_v$，质量与维数只在保持符号时进入。 |
| F7 | eq:family | 成立 | 同 B4/B5；Hankel 乘积限制在 $\mathrm{massive}$。 |
| F8 | §1、例 04 | 成立 | 随包 `kira_result_summary.wl:32` 记 `{53,53}`；`33/33` 属内部报告另一次运行。正文两处统一为 $53/53$。 |
| F9 | §2.2 缩并规则 | 成立 | 缩并条件 $n_{e,1}+n_{e,2}=1$ 使非零端点唯一，正文明写“$i$ 即该端点”。 |
| 尾 a | §1 两顶点项 | 成立 | $25/25$ 处补 “at the recorded probe point”（`内部.md:38-42` 记的是固定探针点）。 |
| 尾 b | §1 两顶点项 | 成立 | 顶点基与主积分次序改指 `Chen:2024glu`（`内部.md:33-36`：论文矩阵按该篇顺序作 oracle）。 |

### Referee C：引用（1 条）

| 编号 | 报告位置 | 裁定 | 落点与依据 |
|---|---|---|---|
| C-F1 | §1 kinematic-flow 句 | 成立 | INSPIRE 对 2403.07050 的记录是 tree-level family-tree 构造，不支撑“圈被积函数的 kinematic flow”。从该引用组移除 `Fan:2024iek`，保留 `Baumann:2024mvm`、`Hang:2024xas`；其余 23 条 bib 字段与 INSPIRE 逐字段一致，被引键集合与 bib 集合完全相同。 |

## 2. 不成立项

- B11 的子论断（例 05 的 $p_{12}$ 与 §2.3 记号冲突）：$p_{12}$ 是随包例子中用户声明的动量符号，
  正文复述声明内容才是正确写法；替换成别的记号反而与 `Examples/05` 不符。已在正文保留原符号。

## 3. 本轮复核新发现（三位检查未报）

1. **§2.4 自相矛盾**。原正文既称 $p_e$ 被所有生成元守恒，又称无质量接触是例外。取证
   `LoopCore.wl:2923-2929`：massive 缩并 $b_S=b+1$（配 $n_1+n_2=1$ 被移除，parity 不变），
   massless 缩并 $b_S=b$（parity 偏移 1）。再取证 `RelationsParity.wl:849-918`：程序把用户约束按每个
   sector 的缩并位移与零点重基**搬运**后再用，搬运非整数则整个 parity 过滤失效；只有 fixed 线被点名才报
   `fixedLineInParity`。§2.4 按此重写，例 06 的无质量圈线约束因此不再与正文冲突。
2. **零点取值的外部出处不可核**。原句把 $b0_e=-2\nu$、$a0_v=2\nu+\texttt{analyticRegulator}$ 归给两篇
   参考文献。对 2604.14549 与 2411.03088 的 pdftotext 全文检索均无对应表述，按“事实来源受限”改为只陈述
   随包例子的实际设置。
3. **`analyticRegulator` 的真实作用**。`Examples/04/README.md` 与 `Metadata.wl:484-502`：该符号在 seed
   生成期保持符号、之后置零，因为 `DSInit` 的时间域证书会在整数指标移位触及发散时间边界时停止初始化并
   点名需要正规子的顶点。正文补该说明，§3.1 增加该审计一句话并加 `\label{sec:init}`。
4. **展望的工具定性错误**。原文 “high-precision series-transport solvers \cite{Liu:2022chg}” 中
   Liu:2022chg 是 AMFlow，不是级数输运求解器。改为“数值求解约化后微分方程的工具
   \cite{Hidding:2020ytt,Liu:2022chg}”。
5. **eq:family 的 $\rho_r,i_r$ 首现未定义**。补一句指向 §2.3 的 ISP 定义。
6. **附录两行与正文/源码不符**。`DSInit` 行补时间域审计；`DSRedefineParameters` 行按 `dSIBP.wl:58` 的
   usage 改为“以新的完整动力学变量规则重新初始化 context”。

## 4. 构建与校验

`pdflatex -jobname=paper_build` → `bibtex`（JHEP.bst）→ 两次 `pdflatex` → `mv -f paper_build.pdf paper.pdf`。
末次构建：**0 error、0 undefined citation/reference、0 Overfull、0 Underfull**，21 页。
`figures/fig_examples.pdf` 由改过的 `.tex` 重新生成（sunrise 外腿标签改为 `$\mathtt{kE}$`，与正文例 03 一致），
`fig_linetypes.tex` 经核对本已正确、未改。逐页目检覆盖本轮全部改动页：式 (2.1)–(2.6)、(2.7)–(2.9)、
(3.1)–(3.2) 均在版心内且与编号留有空隙，图 2 题注、§2.4、§3.1、例 05/06、附录表与展望按新文本渲染。
