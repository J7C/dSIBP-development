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
- [x] `independent-benchmark/package/` 当前只保留 `package_014.wl`、`package_014.pdf` 和更新后的 examples；旧 `package_012` 及无版本名程序/手册已删除。
- [x] 两份 TeX/PDF 编译并目视检查；运行矛盾扫描、快照哈希和 `git diff --check`。

## E. 017 sector prefactor 与 parity 迁移（已实施，待独立全量审计）

- [x] 每条 full line pack 固定为三槽：cycle/fixed full 分别为 `{b,n1,n2}` / `{"F",n1,n2}`；shrunk line 允许退为单槽 `{bS}` / `{"F"}`，但 root-ordered `linePacks` 的对应位置绝不删除；massless 不退化为单 `n`。
- [ ] 把 full/shrunk pack pattern 作为 shrink set 的隐式、可逆编码：只由该 pattern 派生 `sectorKey`，并让 seed/metadata/`linearData` 的显式 key 与其交叉核验；不同 shrink set 即使 compact `aList` 相同也不得混合。
- [ ] fixed/non-loop line 的 `b/bS` 不进入三槽 pack；每个 sector 按 root fixed-line 顺序保存结构化 `sectorPrefactorData`。
- [ ] `sectorPrefactorData` 分别保存稳定 `parameterKeys`、当前输出坐标的 `parameterList`、`powerList/powerParts` 和常数 prefactor，不缓存已经乘开的 `parameter^power`。
- [ ] 参数重定义后逐 fixed line 更新 `parameterList`；prefactor materializer、求导、scaling、serializer 和 time-only 转换只消费同一 metadata。
- [x] 对 normalized `J_s=N_s I_s`，验证 `ds` 含 `D[Log[N_s]] J_s`，跨 sector contact/derivative 含 `N_s/N_t`；atomic massless fixed 幂次不得内外重复。
- [ ] fixed-line shrink 只由 source/target zero point 的选择决定吸收量；逐 transition 序列化 $B_s$、$B_t$、override 来源、compiled $(s,z)$ 和剩余 coefficient exponent $s+z-(B_t-B_s)$，所有 reduction/DE 路径共用。不得新增与 zero point 平行的整数吸收选项。
- [x] 缺省 shift 表逐项验收：h 为 `(s,z)=(1,2nu)`、H 为 `(1,0)`、massless 为 `(0,0)`；缺省 $B_t-B_s=z$ 后 h/H 系数保留 $r^{-1}$、massless 无额外模长幂。用户 zero-point override 后系数按一般差公式改变；额外吸收只由 master/basis 选择处理。
- [x] 文档与实现共同验收缺省 child 映射：h 为 `a->a_u+a_v-1, a0->a0_u+a0_v-2nu, bS->b+1, bS0->b0+2nu`，H 为相同整数 shift 且 zero-point shift 为零；由 `n1+n2=1` 证明两者都保持 cycle-line subsector parity。fixed/non-loop line 不进入 parity；手册建议一般不要修改 shrink shift，override 必须同步 child zero point、coefficient 与 parity metadata。
- [x] massless 缺省吸收验收：`(s,z)=(0,0)`；cycle 为 `a/a0/bS/bS0` 全无 shift，fixed 为 `B_t-B_s=0`、`N_s/N_t=1`，不得删除 target 中原有 prefactor或额外外乘同一因子。由 `n1+n2=1, bS=b` 验证 cycle child parity offset 翻转 1；fixed line 不参与 parity，simultaneous contact 按 massless cycle 线数模 2 累加。
- [x] 所有 contact-reachable sector 都必须直接生成该 sector 的完整 time/momentum IBP。sector 继承 root `L`、loop basis、cycle/fixed schema，只替换 compact vertex map、line pack state、zero point、prefactor 与 affine parity；不得用 top-only equations、表观 masters 或 `shrinkSectorSeedGeneration` pending 状态代替。
- [x] 从实际 compiled shrink data 验证 h/H 缺省 `{bShift,zShift}={1,2nu}` / `{1,0}` 是否与 `n1+n2=1` 共同保持 child parity；不得只按 preset 文本假定。
- [x] 用户修改 H/h child zero point 时，对可判定整数重基更新 parity offset；非整数或不可判定重基关闭相应 sector parity capability并返回双语诊断。

实现 smoke：load `4/4`、sector model `21/21`、full workflow `14/14`、contact/parity `30/30`。massless quotient 上的公式型 tree 递推与 dlog 仍未重推，017 对五个相关接口返回 `PendingRederivation`；该项保留为未来推导任务，不伪装成已认证能力。
