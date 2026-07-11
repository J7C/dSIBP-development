# dS-IBP-Package

面向 de Sitter 圈图的 IBP 关系生成框架。目标是支持任意圈数、任意拓扑、massive/massless 混合的函数族，用统一 `J[...]` 表示生成圈动量 IBP、time-IBP/EOM canonical seed，并在后端导出 Kira user-defined system。

## 当前主线

- `000_code/004_dS_ibp_general.wl`：上一版 linear/Kira 导出骨架。
- `000_code/005_dS_ibp_general.wl`：当前主线接口版，新增 topology 初始化缓存、seed 分类、sampled linear-system、精确 sector 匹配。
- `000_code/check/004_seed_expected_examples.wl`：轻量结构与手推 seed 对照检查，优先加载 `005`。
- `000_code/check/run_004_seed_expected_examples.wl`：Wolfram runner。

## 关键约定

- 所有 sector 统一使用 `J[aList, linePacks, ispList]`。
- massive full line: `{b_e, n_{e,1}, n_{e,2}}`。
- massless full line: `{b_e, n_e}`，主线统一采用双 theta 合并路线。
- shrink sector 当前使用 `{bS_e}`；缩并后 `aList` 只保留 compact active slots，原顶点到 compact slot 的映射保存在 `sectorMetadataList`。
- seed 层必须立即应用 EOM 和 massless endpoint canonical，不允许 `n=2` 留到输出 seed。
- seed 保存为 Mathematica 表达式；Kira 导出只消费 linear-system 数据。
- 用户输入的传播子平方与直接 ISP 定义共同固定 family 坐标；程序验证这组 `z/ISP` 坐标是否闭合并可反解，不把 dS 拓扑默认当成需要自动删线或重选 basis 的冗余传播子族。
- `seedPreset` 可选 `"quickCheck"`、`"fullDiscrete"`、`"bounded"`：分别对应小样本检查、连续指标基点加全离散态、有限连续范围加全离散态；显式 `seedRanges` / `seedOptions` 会覆盖 preset，batch 调用里的显式 option 又会覆盖 `seedOptions` 默认的 seed/batch/shrink-sector 上限。

## 轻量检查

```powershell
& 'D:\Wolfram Research\Wolfram\15.0\wolframscript.exe' -file '000_code\check\run_004_seed_expected_examples.wl'
```

该检查只做小型 seed/metadata/linear/Kira 文件结构验证，不运行 Kira reduction，不做大范围解析生成。

## 推荐调用顺序

```wl
Get["000_code/005_dS_ibp_general.wl"];

topoData = makeTopologyData[mixedBubbleCase];
readiness = makeIBPReadinessReport[mixedBubbleCase];
seedBatch = makeCanonicalSeedBatch[mixedBubbleCase];
seedReport = makeCanonicalSeedCoverageReport[seedBatch];

writeSeedBatchMMA[
  seedBatch,
  OutputDirectory -> "path/to/seed_output",
  SeedFileBaseName -> "mixed_bubble_canonical_seed"
];

linearData = makeSampledLinearSystemData[
  seedBatch,
  mixedBubbleCase,
  CoefficientRules -> mixedBubbleCase["numericRules"]
];

kiraData = makeKiraExportData[
  linearData,
  OutputDirectory -> "path/to/kira_input",
  KiraCoefficientRules -> mixedBubbleCase["numericRules"],
  KiraTargetIntegrals -> Automatic
];
```

流程约束：

- seed 阶段只生成 Mathematica 表达式，不直接导出 Kira。
- `makeIBPReadinessReport[case, ...]` 是轻量体检入口，会返回 topology/seed/linear/Kira 各阶段 ready 状态、计数、pending features、issue codes、失败原因，以及 numeric workflow 的残留 `coefficientVariables`。
- `makeCanonicalSeedBatch` 会合并 momentum/time/shrink-sector seed，并检查 EOM canonical 与 pending features。
- `makeCanonicalSeedCoverageReport` 检查 all-sector `qIBP/tIBP` 覆盖、top-sector 生成元标签、EOM canonical 和 pending/forbidden 数据；canonical batch 进入 linear/Kira 时会把这个 report 写入 metadata。
- `topologyValidationReport` 在 topology 初始化、seed batch、linear-system 和 Kira metadata 中都会保留，用来追踪输入拓扑/ISP/numeric rules 是否满足通用生成器前置条件。
- `topologyValidationReport` 中若存在 error，seed/linear/workflow/Kira 导出会在入口返回 `invalidTopology` 或 `notReady`，不会继续生成 IBP、编号线性系统或写 Kira 文件；warning 只作为提示保留。
- 数值规则和撒点规则在 linear/Kira 阶段使用；解析 seed 本身保持不撒点。
- 若 workflow 使用 `LinearSystemMode -> "numeric"`，`numericRules` 必须覆盖所有外部不变量 `kk[i,j]`；缺失时会在 seed 生成前返回 `numericRulesMissingExternalInvariants`。线性系统生成后还会检查系数是否已全数值化，若仍残留 `dim`、`nu`、外部能量等参数则返回 `nonNumericCoefficients` 并列出 `coefficientVariables`。
- `makeLinearSystemData` / `makeSampledLinearSystemData` / `makeMomentumIBPLinearSystem` 的 topology 参数可传 raw case 或 `parseTopology` 后的 topology；内部会统一规范化。
- workflow 的 `LinearSystemMode` 只接受 `"symbolic"`、`"sampled"`、`"numeric"`；拼写错误会在 seed 生成前返回 `invalidLinearSystemMode`。
- Kira 导出只接受 `makeLinearSystemData` 或 `makeSampledLinearSystemData` 的完整输出；手工拼出的残缺 linear-system association 会返回 `notLinearSystem`。
- `makeIBPWorkflowData[..., ExportKira -> True]` 可只生成内存中的 Kira 字符串；只有同时给出 `OutputDirectory -> "..."` 时才写入文件，返回的 `kiraExport["writeFilesQ"]` 会显式记录是否落盘。
- `KiraTargetIntegrals -> Automatic` 默认把全部积分编号写入 `list`；也可传 `{1, J[...]}` 这样的 id/积分对象混合列表来只导出指定目标。
- Kira 导出返回值会直接包含 `kiraOrderingReport` 与 `manualIntegralOrderReport`，用于检查用户指定的 master/排序对象是否全部出现在当前全局积分列表中。
- 若导出的 Kira 系数已经全部数值化，`KiraJobOptions` 中的 `"AppendNumericDummyEquation" -> Automatic` 会追加参考代码同款 dummy block `(N+1)*(ccc)`，并把 `list` 扩到 `targetIntegralCount = integralCount + 1`。
- 默认只写 Kira 输入文件和参考式 `run.sh`，不运行 Kira reduction；`KiraJobOptions` 可覆盖 `"KiraCommand"`、`"KiraParallelJobs"` 或设 `"WriteRunScript" -> False`。

## 当前验证覆盖

已纳入轻量检查的例子包括 pure massless bubble、mixed massive/massless bubble、mixed triangle、mixed sunrise、pure massive bubble 参考对照、two-loop ISP toy 和 massless box topology replacement。它们覆盖的是逐线 `{b_e,n_e}` 的 massless double-theta merged 主线；同一顶点对多条 massless 线的真实 bundle 合并目前只记录 `masslessBundleCandidates`，暂不作为默认 seed canonical。

## 笔记

- `000_note/dS_IBP_package_plan.md`
- `000_note/dS_IBP_package_design_note.md`
- `000_note/dS_IBP_seed_validation_plan.md`
- `000_note/dS_IBP_package_tech_note.tex`
