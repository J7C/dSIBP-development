# dS IBP general 化临时开发清单

本清单用于把现有 bubble 原型推进到 topology-driven 的通用生成器。bubble 仍可作为默认输入样例，但验收标准是：替换 topology input 后，不修改生成器主体也能构造 `J` 表示、完整 IBP 生成元、sector 和导出数据。

- [x] 拆分示例输入与生成器主体：`004_dS_ibp_general.wl` 中示例 case 与通用函数分离，默认加载不自动运行。
- [x] 增加 line metadata：至少包含 `massType`、`bbType`、`skType`、`thetaConvention -> "mergedTwoTheta"`、`packType`。
- [x] 实现 `makeLinePack[e]`：
  - massive `G^{++}/G^{--}` -> `{b_e,n_{e,1},n_{e,2}}`
  - massive `G^{+-}/G^{-+}` -> `{b_e,n_{e,1},n_{e,2}}`，无 theta boundary shrink
  - massless `G^{++}/G^{--}` -> `{b_e,n_e}`
  - massless `G^{+-}/G^{-+}` -> `{b_e}`
  - shrunk line -> `{bS_e}`
- [x] 实现 `enumerateDiscreteStates[int, lineData]`，按每条线的 `packType` 枚举，不再使用 `Tuples[{0,1}, 2 nE]`。
- [x] 实现完整圈动量生成元列表：
  \[
    \{\partial_{q_l}\cdot q_m\}_{l,m=1}^{L}
    \cup
    \{\partial_{q_l}\cdot k_j\}_{l=1,\ldots,L;\ j=1,\ldots,E_{\rm ext}-1}.
  \]
- [x] 重写 scalar-product 层：支持多外动量 `qk[l,j]`、`kk[i,j]`，并在 `nE != nSP` 时引入 ISP，而不是报错。当前仅做 seed/metadata 层函数定义，不默认求解析 `repSP2Z`。
- [x] 实现 `verifyISP[topology, ispData]` 的结构层：覆盖性、独立性、数目检查由 `makeScalarProductData` 返回；实际 rank/span 验证必须在代数赋值后的小 case 中运行。
- [x] EOM seed-canonical 门禁：实现 massiveFull 中 `n>=2` 的即时递推、`forbiddenNData` 扫描，并接入小批 seed 输出。
- [x] momentum seed 中加入 massive building-block 导数项，并在 batch 层立即接入 EOM canonical。
- [x] time-IBP core seed：实现顶点幂次、外部相位、massive 端点导数、massless 端点翻转项、massive theta boundary shrink 项，并在 batch 层立即接入 EOM/massless endpoint canonical。
- [x] massless endpoint canonical 规则：实现 `{10}=-{01}`、`{11}=q^2{00}` 对 `{b_e,n_e}` 的压缩。
- [x] 记录同一顶点对多 massless 线的 bundle 合并候选：`005` 已实现 `vertexPairBundleKey` / `masslessBundleCandidates` metadata，并在 massless bubble、mixed sunrise check 中验证候选线组；当前仍不改变逐线 `{b_e,n_e}` 的 merged-two-theta 主线，真实 bundle canonical 作为后续优化。
- [x] 自动 shrink-sector seed 生成：在 `MaxShrinkSectorCount` 保护内从 massive Wronskian 缩并项派生 `{bS_e}` sector，重映射端点/外腿/active 顶点，并生成对应 time/momentum seed；massless 双 theta 的 bundle 合并仍单独作为未来优化。
- [x] 统一 canonical seed/linear-system 门禁：合并 momentum/time-core/shrink-sector seed；pending features 未清空时不能进入后端导出。
- [x] Kira user-defined system 文件导出：`makeKiraExportData` 只接受 `makeLinearSystemData` 的输出，不直接消费 seed batch；seed 可用 `writeSeedBatchMMA` 保存；可写 `userSystem/ibp.kira`、`list`、`jobs.yaml` 和 `J <-> id` 映射文件，并跳过零方程。
- [x] 后端排序与 master 优先级接口：支持全 sector 的 `KiraOrdering["IntegralOrder"/"PreferredIntegrals"]`、`reorderLinearSystemIntegrals` 和 `makeKiraExportData[..., KiraIntegralOrder -> ...]`，默认仍以 b/bS 幂次复杂度为主。
- [x] massive `G^{+-}/G^{-+}` 不再误落入 `massiveFull`：`005` 已加入 `massiveCross` 分派，但按 massive convention 保持 `{b_e,n_{e,1},n_{e,2}}`；momentum/time building-block seed 与 EOM canonical 已接入，且不产生 theta boundary shrink。
- [x] massless `G^{+-}/G^{-+}` time seed：无 theta、无离散态，只保留 `{b_e}`；时间导数按端点 SK 符号产生 `\pm i q_e`，在指标上实现为 `b_e -> b_e-1`，并加入 massless-cross bubble 小检查。
- [x] topology validation report：`makeTopologyData` / `summarizeCase` 现在返回 `validationReport`，提前报告重复线编号、端点不在顶点表、未声明动量变量、ISP 数量不足、sampleDiscreteRules 异常和当前 unsupported seed feature。
- [ ] 测试分层：
  - bubble massive/h 与参考 code 对比（已加入 `ibp[expr_G,3]` raw momentum seed 小检查）；
  - bubble massless 双 theta `{b,n}` 检查 endpoint 压缩（已加入小样本 check）；
  - 单圈 triangle/box 检查 topology input 替换（triangle 已有结构检查；massless box 已加入 sample momentum linear-system 小检查）；
  - 两圈含 ISP toy 拓扑检查生成元数和 ISP 完备性（已加入 twoLoopISP / twoLoopISPCompleteness 小检查）；
  - Kira 文件语法检查（已加入 mixed bubble 的 canonical linear-system 与 massless box sampled momentum linear-system 文件导出小检查，并加入 raw seed batch 拒绝导出门禁；不运行 Kira）。

验证红线：任何默认脚本不得启动解析 IBP 大计算；需要验证时只做 seed/metadata 结构检查，或对参数做代数值替换后做小规模有限检查。


- [x] sector metadata 缓存 original/compact 两套 a-slot 映射：`sectorVertexRepresentativeMap`、`compactASlots`、`vertexIdToCompactASlot`、`lineSlots` 等已进入 seed/linear metadata。
- [x] 将 sub-sector 的 `J` 从兼容模式 `originalSlotsWithInactiveZero` 迁移为真实 compact `aList`；`makeBaseIntegral`、`shiftVertexA`、`shrinkLineIntegral` 和 mixed-bubble canonical check 已切换到 `compactActiveSlots`。
- [x] 增加 double-shrink compact `aList` 小检查：双 massive-line bubble toy 覆盖 `{e1}`、`{e2}`、`{e1,e2}` sectors，确认多重缩并后 `J` 只保留一个 active `a`。
- [x] 增加更一般多顶点 multi-shrink 检查：三顶点/两条不同边缩并后仍剩两个 active compact `a` 的例子，验证不是只覆盖两点图。
