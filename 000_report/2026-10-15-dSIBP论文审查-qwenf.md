# dSIBP 程序包论文审查报告（qwenf）

- 日期：2026-10-15
- 审查对象：`papers/dSIBP/paper.tex`（862 行）、`papers/dSIBP/references.bib`（24 条目）、`papers/dSIBP/figures/*.tex`
- 判定依据：`writing-paper`、`latex-compiler`、`bib-management-standard` 三个 skill 的条款；023 程序包源码与随包记录；arXiv:2401.00129 / 2411.03088 / 2604.14549 原文用词
- 证据产物：`results_temp/*_qwenf.py`、`results_temp/*_qwenf.txt`、`results_temp/bib_verify_qwenf.json`、`results_temp/zoom_panel_*.png`
- 分级：只有阻断、实质两级。只列不改就会让读者读错、读不下去，或让论文某句陈述不成立的条目。口语化与非常用词按审查要求单列在 F 节，不分级。
- 分级结果：0 条阻断、28 条实质（A 组 6、B 组 7、C 组 8、D 组 5、E 组 2）。A1 原判阻断，作者已确认对照数据取自论文，故降为实质并把缺陷重述为"随包证据链与正文冲突"；裁定记录见 A1 段。

## 结论摘要

| 编号 | 位置 | 级别 | 一句话 |
| --- | --- | --- | --- |
| A1 | tex L158-159、L605、L737-739 与 `independent-benchmark/reference/README.md` L12-13 | 实质 | 361/361 的对照数据作者确认取自论文，但随包来源记录写的是"无可核验论文身份、不列作论文 oracle"，正文论断无法按仓库证据复核 |
| A2 | bib L33 | 实质 | 本地 PDF 是 2604.14549 v2，v3 已修正主积分与 alphabet |
| A3 | tex L54-55 | 实质 | "Seed generation and reduction are automated by FIRE…Kira" 与两程序自述不符 |
| A4 | bib L332-336 | 实质 | `MadStree:inpreparation` 无来源注释，标题单复数与 MadStree 论文稿不符 |
| A5 | bib L83/94/107 | 实质 | 三条条目缺来源返回的 `note` / `reportnumber` |
| A6 | bib L57、L69 | 实质 | 两条 `% source:` 是 INSPIRE 检索式 URL，不是可稳定复现的记录接口 |
| B1 | tex L819-857 | 实质 | 附录列 31 个公开函数，程序登记 37 个 |
| B2 | tex L651-657 | 实质 | 五个 tree 调用形式在 Kernel 中都无定义 |
| B3 | tex L659-660 | 实质 | `deRoutesAgree` 是 example 自造汇总键，不是 package 报告 |
| B4 | tex L371-372 | 实质 | 无质量 full 收缩项数与符号写错，漏 $(-1)^{n_{e,2}}$ |
| B5 | tex L758-759 | 实质 | 六张矩阵的变量名与 example 06 随包记录不符 |
| B6 | tex L18-20 | 实质 | 摘要把 DE 与 scaling 恒等式说成"一条命令"，实际是 `DSDE` + `DSScaleCheck` |
| B7 | tex L168-171 | 实质 | "naively sampled raw IBP seeds of the same families" 复数无记录，现有记录只覆盖一族 |
| C1 | figures + tex L376、L465-467 | 实质 | $Q_1,Q_2,Q_3$ 图上未定义，且与正文 $Q(x)$、子集 $Q$ 撞字母 |
| C2 | tex L369 | 实质 | $\chi_e$ 的取值规则没给，代码有确定规则 |
| C3 | tex L83/271/452 | 实质 | "block" 同时指 Hankel 块与 parity 块 |
| C4 | tex L74 与 L85-86、L452 | 实质 | parity 分解一会儿叫 closed subsystems，一会儿叫 blocks |
| C5 | tex L294/361/436/443/456 | 实质 | $n_{e,i}$ 在 state 与 label 之间摇摆 |
| C6 | tex L697、L715、L407 | 实质 | 同一坐标三种排版写法 |
| C7 | tex L437、L453 | 实质 | "cycle skeleton" 全文未定义 |
| C8 | tex L287 | 实质 | branch types 与 L191 branch signs、L227 propagator types 三名冲突 |
| D1 | tex L307、L320、图注 | 实质 | mass index vs 原文 mass parameter |
| D2 | tex L201、L365-372 | 实质 | shrink vs 三篇原文 pinch / collapse / contact terms |
| D3 | tex L294-296、L489 | 实质 | state vs 三篇原文 indices |
| D4 | tex L199-203 | 实质 | full/cross 自造名，未与所引论文的 $G_{\pm\pm}$ 建立映射 |
| D5 | tex L158、L736-739 | 实质 | 能量方向号约定与"three variable conventions"未交代 |
| E1 | tex L823-824 | 实质 | 附录表裸 `center`+`tabular`+`\hline`，无 caption/label |
| E2 | figure 4 panel (b) | 实质 | $\nu$ 与面板标记 "(b)" 重合，目视可见 |

## 交接处理顺序

每条自带行号与最小修复，处理时按下面三档分批，同一档内互不牵连：

第一档，纯改 tex 文本、不需要任何重算：A3、B1、B2（五个调用的真实签名已逐条列在本段，照抄即可，静态核对不需重跑）、B3、B4、B5、B6、C1-C8、D1-D5、E1、E2，以及 F 节全部用词条目。改完直接跑完整编译链复核。

第二档，改 bib：A4（补来源注释、标题单复数照 MadStree 稿）、A5（三条补 `note`/`reportNumber`）、A6（两条 `% source:` 换成可稳定复现的记录接口 URL）。改完同样跑 `results_temp/bib_verify_qwenf.py` 复验。

第三档，需要仓库记录或计算配合，不做完不能收尾：A1 与 A2 绑定（先取 2604.14549 v3、核对提取所据版本、把来源与式号写进 `independent-benchmark/reference/README.md`，必要时按 v3 印刷矩阵重做一次逐元比较）；B7（按任务书 §14.4 补 naive/递推双路线记录，或把该条 bullet 收窄到已有记录覆盖的那一族）。

改完后按 `latex-compiler` 交付门禁复验：pdflatex → bibtex → pdflatex ×2，log 中 0 error、0 未定义 `Citation`/`Reference`、无新增 `Overfull \hbox`，成品 PDF 无引用问号，再清理 `.aux/.log/.out/.toc`（`.bbl/.blg` 保留）。

C、D 两组的记号与叫法改动不要只落在论文里：同一批符号还出现在 `Documentation/dS_IBP_package_tech_note.tex`、`dS_IBP_package_plan.md`、`dS_IBP_package_design_note.md` 与交付手册，按本仓"记号不统一就全仓清扫"的约定，每改一个量要把这些现行文档一并扫一遍，论文与文档继续共用同一记号。

---

## A. 引用与参考文献规范

引用为全量核验：24 条条目逐字段与声明来源返回值比对，脚本 `results_temp/bib_verify_qwenf.py`，输出 `bib_verify_qwenf.txt` / `.json`。解析器对转义引号与花括号做了正确处理（修正过一次：`Maierhofer:2017gsa`、`Klappert:2020nbg` 曾因解析漏陷只取到 `author` 字段）。结果：20 条逐字段一致，3 条缺字段，1 条无来源。

### A1（实质）361/361 的论文归属与随包来源记录互相冲突

位置：tex L158-159（bullet 3）、L605（§4.3）、L737-739（§6 example 04）。三处都写 "reproduce the matrices of ref.~\cite{Chen:2026dqp} entry by entry, 361/361"。

裁定记录（本条定级的依据，写明以免下一位读者按旧稿理解）：审查阶段本条按"比较对象不是论文印刷矩阵"判为阻断，理由是仓库来源记录只把数据指向仓内解析 reference。作者 2026-10-15 已确认那份解析数据本身就是从论文里提取的，因此"正文把 361/361 归给 `Chen:2026dqp`"这一论断在事实上成立，不构成引用错误，本条降为实质，缺陷重述为下面这条可执行的分歧。

冲突的证据两侧都逐字存在：

- 论文侧：三处均把逐元比较的 oracle 写成 `\cite{Chen:2026dqp}`（即 2604.14549）。
- 仓库侧：`package-dSibp/independent-benchmark/reference/README.md` L12-13：「`reference-results/pure_massive_bubble/reference_probe.wl` 是既有解析代码 reference；当前来源记录没有给出可核验的原论文身份或公式号，因此不把它列作论文 oracle。」
- `package-dSibp/independent-benchmark/reference-results/pure_massive_bubble/README.md` L36：bundle「于 2026-10-08 从 `F:\Agent-projects-nut\dSibp\code_final_version\` 的最终构造结果（`full19_connection/` 与 `basis/`）复制并变换；没有重新生成 reference IBP，也没有运行 reference Kira」，并给出四件源文件的 SHA-256。
- `package-dSibp/Documentation/dS_IBP_package_plan.md` L1204 与 `dS_IBP_package_design_note.md` L974 同口径：三套 361/361 只写"与 `code_final_version` 的既有解析矩阵逐元相符"。
- 全仓检索 `2604` 只在该 bubble 案例的**标度关系**上把 2604.14549 作为出处（example 04 `README.md` L3「Eq. (51)/(64) 标度检查」；`dS_IBP_package_tech_note.tex` L1537「pure massive bubble 的 top sector 使用文献 2604.14549 Eq. (51) 的 Euler 标度关系」），没有任何记录把 19×19 dlog 矩阵归到该论文。

后果（按实质级）：读者或后续审查 agent 拿论文头条验证去查随包记录，会读到一句与之相反的自述，无法判断该信哪一侧；提取时所据的 arXiv 版本也没有记录，而 A2 显示 v3 恰好改动了主积分与 alphabet，因此"提取的集合是否等于 v3 印刷的集合"仍是开放项。

最小修复（按 1→3 顺序执行，其中 1 是消除本条的充分条件）：

1. 在 `independent-benchmark/reference/README.md` L12-13 把该句改写为可核验的来源说明：写明对照矩阵由作者从 arXiv:2604.14549 提取、给出所据版本号与式号（或页/矩阵位置）、提取日期与经手人，并保留现有四件源文件的 SHA-256；同一段落里注明"没有重跑 reference IBP / reference Kira"这一事实不变。同一 README L6-10 的表格已按「文件 + SHA-256 + 页数 + 对应任务与公式」登记 2401.00129 与 2411.03088（如 L8「第 14 节；Eq. (3.33) 的 vertex-basis 二进制顺序」），修复照该格式补齐即可，不需要新立约定。
2. 与 A2 绑定：取 v3 PDF 入 `reference/ref_paper/` 与 `independent-benchmark/reference/`，核对提取所用版本。若提取源自 v2 而 v3 的主积分或 alphabet 有改动，需按 v3 印刷的矩阵重做一次逐元比较，结果写入 `package-dSibp/000-report/`。
3. 论文三处表述可保留，但建议其中一处（§6 example 04）用一句话交代比较数据的出处与版本，使正文论断在仓库内可追溯；标度关系式 (51)/(64) 的 `\cite{Chen:2026dqp}` 不动。

### A2（实质）2604.14549 引用停在 v2，而 v3 已改动主积分与 alphabet

证据：本地 `reference/ref_paper/2604.14549_*.pdf` 首页为「[v2] … 19 Apr 2026」；arXiv abs 页评论逐字为「8+5 pages, 1 attachment; v2: typo fixed, references added; v3: corrected the master integrals and the alphabet」，v3 提交于 2026-10-09。bib L32-41 条目无 `version`/`note` 字段说明所取版本。

与 A1 直接相关：A1 的对照数据作者确认取自该论文，但提取时所据版本没有记录，而 v3 恰好改动了主积分与 alphabet。因此本条的版本核对是 A1 收尾的前置步骤，不是可选项。

最小修复：取 v3 PDF 入 `reference/` 与 `independent-benchmark/reference/`，核对页数与 SHA-256，重新确认受影响的 expected；bib 条目补 `version = {v3}` 或 `note` 说明所引版本。

### A3（实质）FIRE 与 Kira 的能力描述超出其自述

位置：tex L54-56「Seed generation and reduction are automated by FIRE … and by Kira …」。

证据：FIRE abstract 页原文「FIRE is a program performing reduction of Feynman integrals to master integrals.」；Kira 2.0 abstract 原文「We present the new version 2.0 of the Feynman integral reduction program Kira and describe the new features.」。两者都只自述约化，不生成 seed。

最小修复：删去「Seed generation and」，改为「Reduction is automated by FIRE … and by Kira …」。

### A4（实质）`MadStree:inpreparation` 缺来源注释，标题与稿件不符

位置：bib L332-336。条目上方没有 `% source:` 行（文件里最后一条 `% source:` 在 L314，属于 `Liu:2022chg`）。条目 title 用单数 "correlator"。

证据：`papers/madstree/paper.tex` L50 `\title{MadStree: a package for quickly evaluating arbitrary tree-level cosmological correlators}` 为复数。`bib-management-standard` §4 要求任何条目都必须写明可打开核验的来源；§5 要求收录前先比对来源返回的 title 与作者。

最小修复：在条目上方加一行指向本仓库内可打开稿件的 `% source:` 注释（in preparation 无 INSPIRE 记录时，写明稿件路径与"数据由合作组提供"），并把 title 改为与 MadStree 稿件一致的复数。

### A5（实质）三条条目缺来源返回的字段

逐条 diff 结果（本地缺失项）：

| 条目 | 缺失字段 |
| --- | --- |
| `Kotikov:1991pm`（bib L83） | `note = "[Erratum: Phys.Lett.B 295, 409--409 (1992)]"` |
| `Bern:1993kr`（bib L94） | `reportnumber = "SLAC-PUB-5947, SACLAY-SPH-T-92-048, UCLA-92-043"` |
| `Gehrmann:1999as`（bib L107） | `reportnumber = "TTP-99-49"` |

这三处不是擅改，而是照抄时漏字段；`bib-management-standard` 要求条目与来源返回值一致。其余 20 条 author/title/eprint/doi/journal/volume/pages/year 全部逐字段相同。

最小修复：按来源返回补齐这三个字段，然后重跑一次 `results_temp/bib_verify_qwenf.py` 留档。

### A6（实质）两条 `% source:` 用的是 INSPIRE 检索式 URL

位置：bib L57（`Kotikov:1990kg`）、L69（`Laporta:2000dsw`）。两条都是 `https://inspirehep.net/api/literature?q=t%3A%22…%22&format=bibtex` 形式的查询串。

问题：查询接口返回的是结果列表，顺序与内容随时间变化，不满足 §4「URL 必须能直接打开并看到该条 bib 原文」。本次核验是在 DOI 接口上完成的（`10.1016/0370-2693(91)90413-K`、`10.1142/S0217751X00002159`），两条目与 DOI 返回值逐字段一致。

最小修复：把两行 `% source:` 换成核验所用的 `https://inspirehep.net/api/doi/<DOI>?format=bibtex`。

---

## B. 论文表述与 023 程序实际行为

### B1（实质）附录公开函数表少列 6 个已登记函数

位置：tex L819-857；正文 L134 与 L669 称「Appendix~\ref{app:api} lists the public functions」。

证据：`Kernel/Core/Context.wl` L136-150 的 `dsPublicAPISections[]` 登记 37 个公开名（initialization 5、messages 3、atomicOperations 9、loopWorkflow 14、pureTimeWorkflow 5、introspection 1），其上方 L134-135 注释逐字「公开函数清单是手册汇总表和成品 example 覆盖检查的共同来源。函数按用户工作流分组；符号 Head 与 option 名不混入函数覆盖计数。」。附录实际列出 31 个，缺 `DSInfo`、`DSMessagesOn`、`DSMessagesOff`、`DSMessagesQ`、`repSymmetry0`、`DSPublicAPI`；这六个名字在论文全文其他位置一次都没出现（`results_temp/api_count_qwenf.py`）。

最小修复：补六行；或在附录开头一句说明本表只列约化工作流入口，完整清单由 `DSPublicAPI` 返回。

### B2（实质）五个 tree 调用形式都与 Kernel 定义不符

位置：tex L651-657 的 verbatim 块。

证据（`Kernel/Tree/PublicBoundary.wl`）：

```
L282  DSTreeSeeds[vertex_, int : J[_, _, _], context_Association]
L305  DSTreeSeeds[int : J[_, _, _], context_Association]
L341  repIterative[data_Association, end_: Automatic, context_Association, opts]
L355  repIterative[expr_,        end_: Automatic, context_Association, opts]
L498  DSTreeNaiveIBP[context_Association, masters_: Automatic, OptionsPattern[]]
L520  DSTreeNaiveDE[context_Association, variables_: Automatic, masters_: Automatic, opts]
L544  DSTreeNaiveDE[ibpData_Association, variables_: Automatic, opts]
L569  DSTreeDLogDE[context_Association, opts]
L578  DSTreeDLogDE[context_Association, seedData_, opts]
```

论文写的 `DSTreeSeeds[context]`、`repIterative[treeSeeds, context]`、`DSTreeNaiveIBP[treeSeeds, context]`、`DSTreeNaiveDE[naiveIBP, context]`、`DSTreeDLogDE[iterative, context]` 都不匹配任何定义：`DSTreeSeeds` 没有以 context 为首参的形式，其余四条都把 context 放在末位（`repIterative` 会把 context 误绑成 `end_`，两条 `DSTree*` 会把 context 误绑成 `variables_`/`masters_` 并落到 `Kernel/DE/BuildDE.wl` L502、`Kernel/IBP/Tree.wl` L593 的失败形式）。

最小修复：按 `Examples/05_tree_two_vertex_time_ibp/main.wl` L102-114 的真实调用序列原样改写这个块。

### B3（实质）把 example 自造键说成 package 报告的标志

位置：tex L658-660「The two routes must agree, and the package reports the flag `deRoutesAgree`」。

证据：全 `Kernel/` 目录检索无 `deRoutesAgree`。该键只在 `Examples/05_tree_two_vertex_time_ibp/main.wl` 内构造：L119 `treeDERoutesAgree = And @@ Flatten[Map[TrueQ[#===0]&,Values[treeDEResiduals],{2}]];`，L136 写入该 example 自己的汇总 association。

最小修复：改为「两条路线的残差逐项为零，`Example`/`05` 的汇总里记为 `deRoutesAgree -> True`」，或删掉这一句只说两路结果相同。

### B4（实质）无质量 full 传播子的收缩项写成了两项

位置：tex L371-372「A massless full propagator shrinks with a $\mp2$ delta term and a $+2$ term, without a Wronskian prefactor and without label shifts.」

证据：`Kernel/Core/RelationsParity.wl` L~300-319 `thetaBoundaryAtomicTerms` 的 `"masslessFull"` 分支每个端点只产生**一项**：

```wl
{<"lineIndex" -> e,
  "coefficient" -> -2 endpointOrientation
      KroneckerDelta[Total[pack[[positions]]], 1] (-1)^pack[[positions[[2]]]],
  "bShift" -> 0, "zeroPointShift" -> 0, "aShift" -> 0>}
```

其中 `endpointOrientation = If[endpointSlot === 1, 1, -1]`，即端点槽 1 给 $-2$、端点槽 2 给 $+2$，并带因子 $(-1)^{n_{e,2}}$。`"massiveFull"` 分支才按 `lineCompiledShrinkTerms` 展开成多项（`/@ shrinkTerms`）。同一条相位规则在 `Documentation/dS_IBP_package_tech_note` 侧是一致的。

最小修复：改为「一个无质量 full 传播子在每个端点给出单项 $\mp2$ 项，符号由端点槽决定（槽 1 取 $-2$，槽 2 取 $+2$），并带 $(-1)^{n_{e,2}}$；没有 Wronskian 前因子，也不移指标」。

### B5（实质）example 06 的六个 DE 变量名与随包记录不符

位置：tex L758-759「six $81\times81$ differential-equation matrices, one for each of the variables $\texttt{ss}11,\texttt{sE}1,\texttt{sE}2,E_1,E_2,E_3$」。

证据：`Examples/06_mix_bubble_tree/kira_result_summary.wl` L30 `"deVariables" -> {loopScale, legScale1, legScale2, E1, E2, E3}`；`main.wl` L120-124 用 `DSRedefineParameters` 把 `sp[k1+k2,k1+k2]->loopScale^2` 等规则装入 custom context，L327 才把 `{ss11,sE1,sE2,E1,E2,E3}` 记为 `defaultDerivativeVariables`，L329-331 记 `customDerivativeVariables === {loopScale,legScale1,legScale2,E1,E2,E3}`。论文 L762-768 确实提到该例走 `DSRedefineParameters`，但报告矩阵个数时用的是重定义前的名字。

最小修复：把 L758-759 的变量名改成随包记录的 `{loopScale, legScale1, legScale2, E1, E2, E3}`，或加一句「在重定义后的运动系统里」。

### B6（实质）摘要把两条命令合并成一条

位置：tex L18-20「One further command differentiates the reduced masters and returns their differential equations, together with Euler scaling identities that check the result.」

证据：§4.3 中 DE 矩阵由 `DSDE` 给出（tex L599），Euler 恒等式由另一条命令 `DSScaleCheck` 在约化基上符号验证（tex L627）。

最小修复：改为「两条后续命令：一条给出约化主积分的微分方程，另一条用 Euler 标度恒等式检查结果」。

### B7（实质）"general formulas against naive sampling" 一项的覆盖面超出记录

位置：tex L168-171（bullet 5）「Its output was compared with reductions of naively sampled raw IBP seeds of the same families.」

证据：现行工作树里唯一的 023 独立检验报告 `package-dSibp/000-report/2026-08-30-1307-023-内部.md` 通篇无 naive/递推/dlog 路线计数（检索 `naive`、`Naive`、`抽样`、`采样`、`递推`、`dlog`、`DLog` 均无命中），其 §6「结论与未覆盖边界」也未把该项列为已验证；任务书 §14.4 要求最终报告列出「递推、naive/dlog」计数。naive 路线的记录只存在于 Git 历史的 022 报告（`2026-08-19-1719-022-内部.md` §4：naive IBP 9 方程/9 未知、solve residual 9/9、naive DE 15/15、与 direct 三变量 25/25 逐元），而任务书 §15.5 把该双路线门禁限定为「第 14.1 节两顶点 `{+,+}` massive `timeOnly` case」一个 family。

最小修复：把 bullet 5 的 families 改为单数并点明是哪个 family，或按 §14.4 补一次 023 的 naive/递推双路线记录再保留原表述。

---

## C. 符号与命名纪律（一物一符、一物一名）

### C1（实质）图上的 $Q_1,Q_2,Q_3$ 全文未定义，并与其他 $Q$ 撞字母

证据：`figures/fig_skrules.tex` L21-22 标 $Q_1=q$、$Q_2=q-k$；`figures/fig_examples.tex` L21-23（panel a）、L37-38（b）、L52-54（c）、L74（d）用 $Q_1,Q_2,Q_3$ 标传播子动量。正文只在图注与句子里直接给动量本身（tex L213-214、L222、L713），从未出现"$Q_e$ 表示传播子 $e$ 的动量"这类定义。同一字母还用于：tex L465-467 函数系统的 $Q(x)$、$Q_{\mathrm h}=1$；tex L376 \eqref{eq:contact} 的求和子集 $Q\subseteq B_v$。

最小修复：图上直接标 $q$、$q-k$、$l_3$、$k_{321}$ 等动量（图注已是这个写法），或在 §2.1 定义一次 $Q_e$ 并把 \eqref{eq:contact} 的子集换成别的字母。

### C2（实质）$\chi_e$ 只说"由两个顶点类型决定"，没给取值规则

位置：tex L369「$-\chi_e(-1)^{n_{e,i}}C_e$, where $\chi_e=\pm1$ is fixed by the two vertex types」。

证据：程序里该量是确定的。`Kernel/Core/LoopCore.wl` L2501-2506，注释逐字「同分支传播子的有序端点方向由 endpoints[[1]] 定义；++ 取 +1，-- 取 -1。」。而 tex L201-202 又说「$++$ and $--$ are the same full propagator」，读者据此会认为该系数与两种符号无关。

最小修复：补一句「$\chi_e=+1$ 对应 $++$，$\chi_e=-1$ 对应 $--$」，并在 L201-202 处说明两者只在收缩符号上有区别。

### C3（实质）"block" 一个词指两个客体

证据：tex L83「the powers of its two Hankel-function blocks」、L271-272「$H_e$ and $\bar H_e$ are the two Hankel-function blocks」、L322「Hankel blocks at each of its two vertices」、L341「built from the two blocks」；同一词在 tex L85-86「splits the system into independent blocks, and one block is enough per reduction」、L452「labels independent blocks of the IBP system」指 parity 分解出的子系统。

最小修复：Hankel 一侧保留"Hankel blocks"，parity 一侧统一改成一个不与前者共用的名字（见 C4）。

### C4（实质）parity 分解有两个名字

证据：tex L73-74「an $n$-propagator family splits into $2^n$ closed subsystems」；tex L85-86 与 L452 又叫同一客体 independent blocks / blocks of the IBP system。所引 2604.14549 原文一律用 closed subsystems / IBP-closed subsystems / independent sectors（原文逐字：「it splits into 2n closed subsystems classified by the parity of the propagator indices」「a decomposition into 2n IBP-closed subsystems」「reduction system decomposes into independent sectors labeled by the odd/even parity」）。

最小修复：全文统一 closed subsystems（或 independent sectors），删掉 parity 一侧的 blocks 说法。

### C5（实质）$n_{e,i}$ 一会儿叫 state、一会儿叫 label

证据：tex L294「the two state powers」、L296「it has no discrete state」、L244「keeps two state labels」、L361「keeps both labels」、L436「the parity of the sum of the labels on a propagator」、L443「its label is just $b_e$」、L456「the labels of \eqref{eq:parity}」、L457「the declaration spells the same labels as \texttt{b[1]}, \texttt{n[1,1]}」。这是同一客体在两个名字间交替。

最小修复：在 L294 定义处写定唯一叫法（建议 state power，并声明简称 label 即指它），其余各处按该叫法清扫一遍。

### C6（实质）同一坐标三种排版

证据：tex L697 图注 `written \texttt{kE}`；tex L715 正文 `written $\mathtt{kE}$ in the case`；tex L407 `$|\texttt{kE}i|$`。

最小修复：正文体里统一用 `\texttt{kE}`（或统一 math 体 `\mathtt`），一处定例后全文对齐。

### C7（实质）"cycle skeleton" 未定义

证据：tex L437「for every propagator of the cycle skeleton」、L453「for a graph whose propagators all lie on the cycle skeleton」。全文关于"在圈上/不在圈上"的正式说法只有 L229「Every propagator that lies on a cycle becomes a denominator」与 L230/L492 的 fixed propagator / non-cyclic propagator，没有出现 cycle skeleton 的定义。

最小修复：在 L229 定义处补一句「这些传播子构成 cycle skeleton」，或把两处改成「of the cycles」。

### C8（实质）branch types / branch signs / propagator types 三名冲突

证据：tex L191 定义「Schwinger--Keldysh branch signs $\sigma_v=\pm$」；tex L226-227 定义「the package distinguishes the four propagator types as ⟨massive, massless⟩×⟨full, cross⟩」；tex L287 却写「Its keys give the vertices with their branch types」。同一份 schema 里 `"branch"` 存的是 $\sigma_v$，type 一词在本文已专指四类传播子类型。

最小修复：L287 改为「the vertices with their branch signs」。

---

## D. 与三篇 Chen 论文用词习惯的对照

对照材料用 `results_temp/chen_terms_compare_qwenf.py` 从三篇 PDF 全文抽取含关键词的句子，逐字比较。

### D1（实质）$\nu_e$ 应叫 mass parameter

论文写法：tex L306-307「for a propagator of mass index $\nu$」、L320「A massive propagator $e$ with mass index $\nu_e$」、图注 L695「of mass $\nu_1$」/L699「of the same mass $\nu$」/L700-701「of mass $\nu_1$」、正文 L711/L744「of mass $\nu_1$」、L771「of mass $\nu_{12}$」。三篇原文写法：2604.14549 逐字「Here $\nu\equiv\sqrt{d^2/4-m^2}$ is the mass parameter.」「where $\nu$ is the common mass parameter.」（Eqs. (35)、(45) 之后各一次），另处用「the Hankel index $\nu$」。三篇均无 "mass index"。

最小修复：全文把 $\nu_e$ 称为 mass parameter（与质量数值区分时写 mass parameter $\nu_e$），图注里的 "of mass $\nu_1$" 改 "with mass parameter $\nu_1$"。

### D2（实质）"shrink" 不是三篇的叫法

论文写法：tex L201「theta-shrink terms」、L365 段标题「Shrink rules.」、L366-372 shrink/shrunk、L446「such a shrink raises the power」、L470「The theta-coincidence and Wronskian shrink terms」、L472「never generate theta shrinks」；正文散文还用 "theta" 拼写而数学里是 $\theta$（L201、L372、L470、L472）。三篇原文写法：2401.00129「two vertex are "pinched" together」「R terms come from pinching two vertex connected via G±± together」；2411.03088「which is given by pinching the propagator of (a)」；2604.14549「time IBP relations will collapse one of the time integrations and produce tadpole families」「derivatives acting on θ21 and θ12 generate contact terms proportional to δ(τ1−τ2)」。三篇都没有 shrink 术语。

最小修复：在 L365 段标题处一次性声明「本文用 shrink 指三篇文献中的 pinching/collapsing 操作」，或整体改用所引文献的叫法；散文里的 "theta" 统一写作 $\theta$。

### D3（实质）"state" 不是三篇的叫法

论文写法：tex L294「state powers」、L296「discrete state」、L244「state labels」、L489「one bit for each massive vertex state or massless quotient state」、L100-101「The massive vertex states are restricted to the proven representative set $\{0,1\}$」。三篇对同一类离散量的叫法：2604.14549「the parity of the propagator indices」「indices associated with each propagator」「a shift of the corresponding $|k|$-power index by $2\nu+1$ and the $\tau$-power index by $-2\nu-1$」；2411.03088「referring to the definition of index $\tilde a$」；三篇都没有 state。

最小修复：要么在定义处写明本文把 $n_{e,i}$ 称为 state power 并对应原文的 index，要么改用 index 并同步 `stateBits`/`state powers` 各处；两种都要与 C5 一起处理，避免 state / label / index 三名并存。

### D4（实质）full / cross 是自造名，缺与所引论文的映射

证据：tex L199-203 定义 full/cross。三篇用的是 $G_{\pm\pm}$、$G_{\pm\mp}$（2401.00129「the combination of the two terms in these propagator…G±±」、2411.03088「For propagator G±∓, the master integrals are just the product…」）。这套自造名本身可读，但论文把它当作唯一叫法，读者无法把 L199-203 与所引论文的分支记号对上。

最小修复：在 L199-203 定义处补一句映射：full 即 $G_{\sigma\sigma}$，cross 即 $G_{\sigma\sigma'}$（$\sigma\neq\sigma'$）。

### D5（实质）能量方向号约定与"three variable conventions"没有交代

证据：随包记录把该 bubble 案例的对照约定固定写死 —— `reference-results/pure_massive_bubble/README.md` L24-30「固定 convention 为 `P_pkg=-P_ref`、`P0_pkg=-I ip0`、`ks=ss11=Sqrt[sp[k,k]]`」并给出三条导数关系；`Examples/04_pure_massive_bubble_closed_loop/README.md` L3「package 与 reference 的能量满足 `P_pkg=P0=-P_ref`」；design_note L974 同。论文 tex L158-159、L605、L736-739 在逐元比较处一字未提，只说「each of the three variable conventions」，而 §2.2/§6 只定义了两个导数变量（tex L735「keep $\texttt{ss}11$ and $P_0$ symbolic」、随包记录 `deVariables -> {ss11, P0}`），第三个（backend `ip0`）从未介绍。

最小修复：在比较处加一句「reference 侧能量取向与 package 相反（$P_{\text{ref}}=-P_0$），导数相差一个符号；三套约定即 physical $P_0$、backend $ip_0$、physical $ks$」。

---

## E. LaTeX / JHEP 排版与编译

编译链已按 `latex-compiler` §2.2 完整跑过（pdflatex → bibtex → pdflatex ×2）：log 内 0 error、0 `Overfull \hbox`、0 未定义 `Citation`/`Reference`；bibtex 处理 24 条目、0 warning；成品 PDF 正文与参考文献页无 `[?]`。目录由 `jheppub.sty` 在 `\maketitle` 内自动排，符合本仓两篇论文的 JHEP 合同；`JHEP.bst` 不支持 `\citet`/`\citep`，全文只使用数字 `\cite`，正确。

### E1（实质）附录 API 表未进浮动体

位置：tex L823-824、L825/L827 的 `\hline`。当前是裸 `\begin{center}\begin{tabular}{p{4.3cm}p{9.8cm}}`，没有 `table` 环境、`\caption`、`\label`。正文 L134、L669 又以 `Appendix~\ref{app:api}` 指称该节而非该表，符合 skill §1.4 的写法要求但缺表号。

最小修复：包进 `table` 浮动体，加 `\caption{Public functions of the package.}\label{tab:api}`，正文两处改成 `table~\ref{tab:api}`；`\hline` 换 `booktabs` 三线。

### E2（实质）Figure 4 panel (b) 中标签相撞

证据：`results_temp/fig_overlap_qwenf.py` 用 fitz `get_text('words')` 取词框，$\nu$ 与 "(b)" 的框重叠 4.36×3.46 pt；9× 局部渲染 `results_temp/zoom_panel_b.png` 目视确认两字符压在一起。panel (a) 的 $-k_{321}$ 与 "(a)" 只重叠 12.86×1.25 pt，`zoom_panel_a.png` 未见墨迹相撞，不作为缺陷。

最小修复：`figures/fig_examples.tex` 里把 panel (b) 的 $\nu$ 标签加 `xshift`/`yshift` 或改 `fill=white` 背景，重编译后再目视一次。

### E3（记录）两处超长句

tex L442-451（51 词）：「The package therefore does not apply a constraint to a sector below the top sector in its original form: it rewrites…」。tex L694-705 图注 (c)（44 词）。均按 skill §3.1「多用短句」要求列出，不构成读错。

---

## F. 用词记录（口语化与非常用词）

按审查要求逐条列出，均不分级。左列行号可点开 tex 核对。

### 口语化 / 口语句式

| 行 | 现文 | 建议 |
| --- | --- | --- |
| L54 | What made this route decisive is not only the algebra but also the software built around it. | 这半句是评论句式，改成陈述：这条路线的实际推动力是围绕它的软件生态。 |
| L62-63 | with no integration input left to supply. In practice the user writes down a topology, and a program handles the rest. | "left to supply"、"handles the rest" 是口语；改为：不再需要额外积分输入；用户只需声明拓扑，其余由程序完成。 |
| L81 | Assembling the system by hand | 改为 manually / by hand 保留但整句改为陈述语气 |
| L85 | the parity classification just recalled | "just recalled" 口语，改为 the parity classification above |
| L85-86 | one block is enough per reduction | "is enough" 口语，改为 a single subsystem suffices per reduction |
| L111 | Two boundaries of the package are worth stating. | 评论式开场，改为 We state two boundaries of the package. |
| L131 | walks through the examples | 改为 describes the shipped examples |
| L133 | closes with an outlook | 改为 ends with an outlook |
| L152 | first derived independently by an agent, which generalized an earlier hand-written … implementation | "hand-written" 口语；agent 的说法已在 L136-140 的 AI 声明里统一交代，此处可改为 a first derivation produced outside the package |
| L155/L156/L163/L736/L757 | closes with no unreduced target | "closes" 为口语用法，改为 finishes / terminates with no unreduced target |
| L273/L298 | powers that no longer sit in a denominator / its magnitude power sits in $N_s$ | sit in 改 be collected in |
| L645 | when several topologies are alive | "alive" 口语，改为 when several topologies are registered |
| L731 | This example runs the full closed loop | 习语，改为 covers the full workflow |
| L743 | The most demanding released case | "demanding" 口语，改为 the largest released case |
| L285/L486/L490 | in the frozen vertex order / frozen for the whole family / the frozen order | frozen 是比喻，改为 fixed |
| L536/L558-565/L18/L798 | sealed（含 `sealedQ`） | 除键名 `sealedQ` 必须原样保留外，散文中的 sealed 建议改为 hash-certified |

### 非常用词 / 拔高词

| 行 | 现文 | 建议 |
| --- | --- | --- |
| L102/L523/L675/L732/L791/L837 | envelope（sweep…over an envelope、the IBP envelope） | 指连续指标范围时改 range / index range；§4.2 小标题可保留一次并定义 |
| L435 | The characteristic discrete invariant of de Sitter IBP is the parity… | 名词堆叠，改为 The discrete invariant of the dS IBP system is the parity… |
| L494/L497 | fully certified / A certification gate | 改为 fully checked / a check gate，或保留 certified 但在 §3.5 定义一次 |
| L506/L388/L828 | structural audit / structural loop number / structural, kinematic and time-domain audits | structural 空泛，改为 topology audit / graph-level loop number |
| L537-538 | canonicalization … audited | 用常用词：the canonicalization step … checked |
| L559 | capability flags | 软件术语，加一句解释或改 status switches |
| L587/L799 | artifact / artifact identities | 物理读者不熟，改 export files |
| L363 | not a sampling prescription | prescription 可留，但改为 an exact algebraic identification, not a numerical sampling rule |
| L372/L470/L472/L201 | theta（散文拼写） | 统一写作 $\theta$ |
| L73 | identifies a structural property | 该短语是 2604.14549 原文自述（"We identify a structural property of the dS IBP system"），此处不算拔高词，保留 |

---

## G. 已核验通过

1. 引用键与编译：24 条 bib 键全部存在、全部被正文引用；正文无 `\citet`/`\citep`；`paper.aux`/`.blg` 无 undefined、无 multiply defined；`\ref`/`\eqref` 全部解析，正文无硬编码"公式 42""表 3"一类写法。
2. 逐字段一致性：`Chen:2023iix`、`Chen:2024glu`、`Chen:2026dqp`、`Chetyrkin:1981qh`、`Kotikov:1990kg`、`Laporta:2000dsw`、`Henn:2013pwa`、`Maierhofer:2017gsa`（10 字段）、`Klappert:2020nbg`（11 字段）、`Smirnov:2019qkx`、`Smirnov:2025prc`、`Magerya:2022hvj`、`Chen:2017ryl`、`Fan:2024iek`、`Hang:2024xas`、`Baumann:2024mvm`、`Hidding:2020ytt`、`Liu:2017jxz`、`Liu:2022mfb`、`Liu:2022chg` 与来源返回值逐字段相同，未见擅改。
3. `Liu:2022mfb`「verifies this on examples up to five loops」经复核为正确表述，先前怀疑的错标不成立。
4. Introduction 对三篇 Chen 论文的每句论断都取到原文对应句：包括「These formulas dominate all tree-level de Sitter correlators and play a kernel role at the loop-level as well」、「Kira could solve IBP reduction of user-defined system」、「how to give a boundary condition of DE is beyond the scope of this paper」、「Automatic tools… widely applied in flat QFT, could also help」、「we analytically solve d log-form differential equations via power series expansion」、「We also show how to determine the boundary conditions」、「explicit computations… limited to tree level and to bubble topologies at one loop」。
5. `Bern:1993kr`（dimensionally regulated pentagon）、`Gehrmann:1999as`（two-loop four-point）、`Kotikov` 两条（DE 方法）、`Henn:2013pwa`（dlog 形式）在正文中的用途与各文献实际内容相符。
6. bullet 1 关于 vertex basis 与 master 排序「follow the same reference」经 2411.03088 原文核实成立：其原文给出「in the 2-fold vertex integral family, there are four master integrals. The 3-th master integrals can be denoted as I3 or I{1,0}」与「n-fold vertex integral family has 2n master integrals, which we denote as I˜a」，即二进制下标与末位最快变化的顺序。仓库另外在 `independent-benchmark.md` L1320 把同一约定登记为 2401.00129 Eq. (3.33)，两者不冲突。
7. 53/53 这个数字不是错抄：`kira_result_summary.wl` 在 commit `e5d3314` 记 `{33, 33}`，commit `81e7c04`（Replace the pure massive bubble example with the 19-item uniform-weight basis）把该 example 端到端重跑后改为 `{53, 53}`（同 commit 记录 Kira 2.3、109.09 s、300 targets、361/361）。论文取现行随包记录，符合"验证计数取随包记录"。
8. bullet 6 的 MadStree 交叉验证有记录：`研究计划与研究进度.md` L3511 逐字「在固定精确点对 mixed 三顶点 15 masters 的 5 个变量执行 dSIBP 020 `ds` -> MadStree `MSReduce`；75 个导数全部闭合且每个矩阵均为 `15x15`……五个矩阵与直接 dlog 公式逐项严格相等，最终检查 `9/9`」。
9. 四个 atomic 调用签名（tex L635-638）与 `Kernel/Core/LoopCore.wl` L5902-5937、L6051 的 `dtau[vertex_,expr_,topoSpec_]`、`dqq[dLoop_,vectorLoop_,expr_,topoSpec_]`、`dqk[dLoop_,vectorExternal_,expr_,topoSpec_]`、`ds[expr_,userVariable_,topoSpec_]` 一致，L641-643 的参数说明也正确。
10. `zeroPointRules` 是真实 schema 键；tex L303-314 关于 $a0_v=\alpha_v$、$b0_e=\beta_e$、纯质量 bubble 下 `b0_e=-2\nu`、`a0_v=2\nu+analyticRegulator` 的描述，以及 L509-511 的时间域门禁，与 `Kernel/Core/Metadata.wl` L484-499 的中英双语报错（reason `timeIBPRequiresRegularization`）一致。
11. `timeOnly` 三槽 schema（tex L483）、`sectorKey` 位串含义、`PendingRederivation` / `masslessQuotientFormulaNotCertified` 门禁（tex L496-497、L781-783）与程序一致；tex L494-495 未越权宣称 massless 情形可用。
12. 其余计数可追溯到随包记录：818,217 条关系、约 160 s（160.11 s 墙钟）、81 个 master、53/53、19/19、81/81、25/25、6 张 81×81、"ships six worked examples"（`Examples/` 下 01–06 六例）。
13. 散文用词符合本仓约定：正文一律用 propagator/传播子，`line` 只出现在 schema 键（如 L285 的 `"lines"`）。
14. JHEP 合同：`\abstract` 宏、无 `ctex`、目录由样式自动排、`JHEP.bst`；`fig_linetypes` caption 已写明只画一种 ± 组合（L240-241「The conjugate assignments $--$ and $-+$ give the same two types」）。
15. tex L182 的仓库地址与本地 `.git/config` 一致：`packages-final/.git/config` origin 为 `git@github.com:J7C/dSIBP-Packages`，其内含 `dSIBP/`、`MadStree/`、`FlintNDE/`。

## H. 未能核验

1. `https://github.com/J7C/dSIBP-Packages` 的外网可达性未验证：探测被权限拦截，只核对了本地两处 `.git/config` 的 origin 字符串。
2. 2604.14549 **v3 的实际内容**未取：本次只读到 arXiv abs 页评论「v3: corrected the master integrals and the alphabet」与版本历史，未与 v3 正文做任何比对（见 A2）。
3. INSPIRE 记录页是 JS 渲染，`WebFetch` 只返回脚本；FIRE/Kira 自述改从 arXiv `/abs/` 页逐字取到，其余条目走的是 INSPIRE bibtex 接口，返回值可直接比对，不受影响。
4. example 05 的 massless family 那一段（tex L778-783）只做了静态核对，未跑 Wolfram 探针确认 `PendingRederivation` 的真实返回。
5. 全部结论均为静态核查：除已有随包记录外，没有重跑 Kira、MadStree 后端或任何长时间探针。A1/B2/B7 三条的收尾各需要什么：A1 需要将「对照数据由作者从 2604.14549 提取」写入来源记录（版本号 + 式号），并按 v3 核对一次提取结果是否等于 v3 印刷矩阵；B2 需要按 `Examples/05` 的真实调用形式改写论文中的五个调用；B7 需要按任务书 §14.4 补一次 naive/递推双路线记录。本审查没有独立复核过作者那句确认，只把它作为改变 A1 定级的依据记在裁定段。
