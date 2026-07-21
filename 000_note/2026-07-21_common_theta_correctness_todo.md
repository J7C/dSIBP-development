# Common-theta boundary 正确性专项 TODO

日期：2026-07-21

本任务是 IBP 公式正确性门禁，不是 bundle 表示优化。当前权威进度入口为根目录 `研究计划与研究进度.md`。

## A. 分布公式与等价性

- [x] 从同一代表顶点对的原始传播子乘积推导共同 theta 的唯一 boundary。
- [x] 在 `J_e=(A_e+B_e)/2`、`D_e=A_e-B_e` 基底证明只出现非空奇数子集及系数 `2^(1-|S|)`。
- [x] 用统一 Gaussian `rho_eps/H_eps` 定义逐线 theta 求导，并用测试函数证明 `rho_eps F(H_eps) -> delta Integral_0^1 F(h) dh`。
- [x] 展开中心矩，推导逐线三传播子项中的 `1/12`、求和后的 triple `1/4` 和一般 odd-subset 系数。
- [x] 增加三线 worked example：分别展示共同-theta直接展开、Gaussian 逐线分配及其求和，并把 representative massive/massless contact 映射到最终 `J[...]`、`a/a0`、`bS/bS0`。
- [x] 写明等价条件：同一 bundle 使用同一 regulator、`A/B` 在 contact 附近平滑、所有逐线贡献求和后才与共同-theta canonical 等价。
- [x] 写明非等价做法：只代入 `theta(0)=1/2`、逐线使用不同 regulator、丢弃高阶奇数 contact 或生成 `delta^k`。

## B. `WT` 与指标表示完整链路

- [x] `compileFunctionSystem`：核对 `WT=Det[T] W` 是唯一权威变换后 Wronskian。
- [x] `compileShrinkTerms`：对 `WT=Sum c_alpha x^p_alpha` 编译 `-WT` 的 coefficient、整数 `bShift` 与 `zeroPointShift`，并验证所有 Laurent 项的 zero-point shift 兼容。
- [x] `lineCompiledShrinkTerms` / `lineShrinkZeroPointShift`：确认 time boundary 和 sector metadata 读取同一编译结果。
- [x] `thetaBoundaryAtomicTerms`：massive contact 必须消费 `WT/shrinkTerms`；massless contact 使用有序端点 `-2/+2` 且 shift 为零。
- [x] `timeThetaBoundaryShrinkTerms`：按当前代表顶点对分 bundle，枚举非空奇数子集，系数乘 `2^(1-k)`，对每条 massive 线展开全部 `WT` Laurent choices。
- [x] `shrinkLinesIntegral`：一次事件只合并代表顶点一次；`aMerged` 减去所有选中线整数 shift 之和，各选中 line pack 分别写成 `{b+s}`。
- [x] `sectorZeroPointRules`：`a0Merged` 减去所有选中线 zero-point shift 之和，且每条 shrunk line 使用 `bS0=b0+z`。
- [x] coincident canonical：未选中 massless `n=1` 置零、massive `{b,1,0}->{b,0,1}`，coincident full line 不再产生 theta boundary。
- [x] `contactReachableShrinkSubsets` / `shrinkSectorSubsets`：sector 只来自真实 contact 事件；事件之间连接不同代表类，不能回退到全幂集。

## C. 下游与验证模块

- [x] `makeCanonicalSeedBatch` / coverage：只接收 contact-reachable sector，关系即时通过 EOM/canonical。
- [x] `makeLinearSystemData` / sampled linearData：保持 simultaneous contact 系数、compact `aList` 和 zero-point metadata。
- [x] Kira serializer：只序列化 canonical `linearData`，不得重新推导 contact 或改变 sector。
- [x] 专项测试覆盖：单线、两线、三线、massive/massless/mixed、h/H、一般多项式 `WT`、coincident cancellation、不可达 sector 和总物理幂次。
- [x] 继承回归覆盖：function-system、外不变量导数、massless direction、`sp`、symmetry、public API、serializer。
- [x] 十个修正后 hand-derived family 全量通过；旧 011 oracle 只保留审计用途。

## D. 文档、独立 benchmark 与交付

- [x] 技术笔记正文只保留共同-theta canonical 的完整 `传播子 -> boundary -> D/J -> WT/contact -> shift -> J[...]` 链路。
- [x] 技术笔记附录分别给出共同-theta和统一 Gaussian 两套详细推导，并证明总 boundary 等价。
- [x] plan/design/README/AGENTS/用户手册将该模块列为正确性门禁，不得描述为 future 或可选优化。
- [x] independent benchmark 只明确原始传播子、distribution 和指标/零点记账 convention；删除特定多线结果、triple/pair-sector 等答案提示。
- [x] independent benchmark 明确一般 shrink factor `q^(-s-z)(-tau)^(-s-z)` 如何映射到 `bS=b+s`、`bS0=b0+z`、`aMerged=a_u+a_v-s`、`a0Merged=a0_u+a0_v-z`。
- [x] `independent-benchmark/package/` 只保留 `package_012.wl`、`package_012.pdf` 和更新后的 examples；删除旧无版本名程序和手册。
- [x] 两份 TeX/PDF 编译并目视检查；运行矛盾扫描、快照哈希和 `git diff --check`。
