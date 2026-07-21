# 来源隔离记录

## 第一阶段允许来源

- `independent-benchmark/independent-benchmark.md`
- 用户在根目录 `AGENTS.md` 中直接给出的项目约定
- DLMF 10.4.7、10.5.5、10.6.1、10.6.2 所代表的标准 Hankel continuation、Wronskian 与导数恒等式

## 已知暴露

在正式选定 family 前，为定位项目原有目录和确认第二阶段可执行入口，曾用文本搜索看到 `package_012.wl` 的若干公开函数名，例如 `makeTopologyData`、`makeTimeIBPSeedBatch`、`makeMomentumIBPSeedBatch` 和 `ds`。没有读取旧 `expected.wl`、旧手推 helper 或 package 内部公式来构造本目录 expected。

首个 atomic family 冻结后曾读取 package 的公开输入和 public API 实现来完成 104 条 actual 对照。后续全量 oracle 因而不满足“从未打开 package”的最严格盲测边界；它仍保持公式来源隔离：所有 massless/massive/common-theta/scalar-product/ISP/`D_ij` 公式都在 `ORACLE_DERIVATION.md` 明写并由新 oracle 实现，未调用 package helper 生成 expected。全量冻结清单在新增 family 的首次 package actual 运行前记录聚合哈希。

## 明确未用来源

- `000_code/check/hand-derived-v2/**/expected.wl`
- `000_code/check/hand-derived-v2/_manual_ibp_engine.wl`
- `000_code/test/012_hand-derived/**/expected.wl`
- 现有 package cross-check 的 expected 或运行结果

后续 package 对照允许读取 frozen expected 和正式 package；任何差异不得无说明地回写 expected。

全量冻结 v1 后、首个新增 family actual 运行前，表示审计发现两处由任务书本身也能判定的 oracle 错误：coincident massless `n=0` 应保留 full `{b,0}` pack，coincident massive sector seed 应遍历四个原始端点态再 canonical。修正后建立 v2 聚合冻结；v1 哈希仅作为历史保留。

v2 的首个 pure-massless actual 暴露了一个纯实现错误：`Table` 内的 `Return[$Failed]` 被保留为 J pack，而非使 boundary term 消失。把 massless `n=1` coincidence 零条件移到建表前，并增加 `_Return/$Failed` 结构门禁后建立 v3；该修正不改变 common-theta 公式。

mixed-bubble actual 随后发现普通 sector-seed 路径没有对 coincident massive `10->01` canonical，虽然 contact-child 路径已经执行。把 canonical 统一放到 `indexToJ` 后建立 v4；seedRules 仍遍历四态，equation 输出才 canonical。

更新任务书改为固定两条 sign 分支和两个 H family 的三路验收后，旧 v4 只保留历史意义。本轮 package 对照又暴露两项可从任务书独立判定的 oracle 错误：triangle contact child 曾把 selected-line integer shift 从所有 child vertex class 都减去；reference derivative 曾漏做最终 symmetry/parity canonical。两项均先由原始指标映射/用户规则复核，再修改 oracle，未复制 package actual。

`parallel_massless_bundle_guard` 的旧 0/36 差异来自 oracle 取 `{D11,D12,D21}`、package 默认取 `{D11,D12,D22}`。四个 directional seed 完全相同，两种 decomposition residual 都为零。Package 已给标量积设置 `Orderless`，也已显式默认 upper-triangular operator basis；旧差异的直接责任是 oracle 选择了另一套 raw representative。任务书现已独立固定 `{Dij|i<=j}`，oracle 依新任务书显式重生，不再把 package actual 当作未写明 convention 的替代来源。

`vertex_energy_signs` 的原任务书输入缺 1 个 ISP，独立 oracle 与 package 都先给出不闭合证据。任务书作者随后明确指定补全；当前采用 `rho1=sp[ell,k]`，其选择来自 `{ell^2,ell.k}` 与唯一 denominator square 的独立线性闭合，不是从 package actual 复制 expected。任务书更新、family/derivation/expected 重生均先于本轮完整 package 对照。

新版冻结是在上述 package 差异审计之后建立的 post-audit snapshot，不宣称为从未读取 package actual 的盲冻结。公式来源仍只使用任务书、标准 Hankel 恒等式和本目录明示推导。
