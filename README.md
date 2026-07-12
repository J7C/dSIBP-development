# dS-IBP-Package

面向 de Sitter 圈图的 IBP 关系生成框架。目标是支持任意圈数、任意拓扑、massive/massless 混合的函数族，用统一 `J[...]` 表示生成圈动量 IBP、time-IBP/EOM canonical seed，并在后端导出 Kira user-defined system。

## 当前主线

- `000_code/004_dS_ibp_general.wl`：上一版 linear/Kira 导出骨架。
- `000_code/005_dS_ibp_general.wl`：稳定接口版，包含 topology 初始化缓存、seed 分类、sampled linear-system、精确 sector 匹配。
- `000_code/006_dS_ibp_general.wl`：新接口版，在 `005` 基础上新增用户口 `sp[p,r]` scalar-product convention；旧版不动，便于回退对照。
- `000_code/check/004_seed_expected_examples.wl`：轻量结构与手推 seed 对照检查，优先加载 `005`。
- `000_code/check/run_004_seed_expected_examples.wl`：`005` 稳定版 Wolfram runner。
- `000_code/check/006_sp_interface_check.wl`：`006` 的 `sp[p,r]` 用户接口轻量检查，并贯通 `makeIBPWorkflowData` 的 sampled linear/Kira 内存导出门禁。

## 关键约定

- 所有 sector 统一使用 `J[aList, linePacks, ispList]`。
- massive full line: `{b_e, n_{e,1}, n_{e,2}}`。
- massless full line: `{b_e, n_e}`，主线统一采用双 theta 合并路线。
- shrink sector 当前使用 `{bS_e}`；缩并后 `aList` 只保留 compact active slots，原顶点到 compact slot 的映射保存在 `sectorMetadataList`。
- seed 层必须立即应用 EOM 和 massless endpoint canonical，不允许 `n=2` 留到输出 seed。
- seed 保存为 Mathematica 表达式；Kira 导出只消费 linear-system 数据。
- 用户输入 `loopMomenta` 与 `externalMomenta` 后，可用任意符号命名这些动量；`006` 用户口的圈动量相关标量积统一写作 `sp[p,r]`，例如 ISP 可写 `sp[l3, k321 + l3]`。外动量-外动量不变量在输出端不显示为 `sp[k_i,k_j]`，而显示为变量名：用户可用 `externalInvariantRules -> {sp[k1,k1] -> s11, sp[k1,k2] -> s12}` 自定义；若未指定，默认按 `externalMomenta` 中的位置输出为 `sij`（`i<=j`）。内部 `qq/qk/kk` 只作为编号坐标，不要求用户输入。
- dS 中要区分“进入内线动量的外部三动量向量”和“只进入顶点时间相位的外腿能量”。`externalMomenta` 只列前者，即会在内线动量中以 `l + sum k` 形式和圈动量纠缠的独立外部向量；`vertexEnergies` 的每个值表示一个顶点连着的所有外腿打包后的 e 指数能量。若这个能量属于 `externalMomenta` 张成的空间并应与圈动量部分共用变量，优先写成外部不变量变量名的函数，例如 `Sqrt[s11]` 或 `Sqrt[sigW]`；若不是，就作为独立绝对值参数，内部/文档统一建议记为 `ke[i]`。特别注意 `|ke1+ke2|`、`|ke1|`、`|ke2|` 是三个独立参数时必须分别命名，例如把 `|ke1+ke2|` 另记为 `ke[3]`，不要自动写成 `ke[1]+ke[2]`。外腿能量参数之间不需要也不应自动建立互相点积；只有用户显式把某个顶点能量写成外部不变量表达式时，才与圈外动量空间复用同一个变量。这样做的目的有两个：一是避免明明应共用的外部不变量没被用上而使约化结果冗余，二是后续求微分方程时同一变量能被统一求导；若用户物理上要把这些量当独立变量，应通过输入显式写成独立参数，package 不主动替用户拆分或合并。`vertexEnergies` 中不能直接写 `loopMomenta/externalMomenta` 的向量符号，也不能写圈相关 `sp[q,k]`；属于外动量空间时写外部不变量变量名表达式，否则写独立 `ke[i]`。
- 用户输入的传播子平方与 ISP 定义共同固定 family 坐标；程序验证这组 `z/ISP` 坐标是否闭合并可反解，不把 dS 拓扑默认当成需要自动删线或重选 basis 的冗余传播子族。所有 line momentum 和 `sp[p,r]` 的参数都必须是 `loopMomenta/externalMomenta` 的线性组合；非线性写法如 `q1^2` 会在 topology validation 中返回 `nonLinearLineMomenta` 或 `nonLinearScalarProductArguments`。
- `seedPreset` 可选 `"quickCheck"`、`"fullDiscrete"`、`"bounded"`：分别对应小样本检查、连续指标基点加全离散态、有限连续范围加全离散态；未知 preset 会作为 topology error 停止 seed，显式 `seedRanges` / `seedOptions` 会覆盖 preset，batch 调用里的显式 option 又会覆盖 `seedOptions` 默认的 seed/batch/shrink-sector 上限。

## 轻量检查

```powershell
& 'D:\Wolfram Research\Wolfram\15.0\wolframscript.exe' -file '000_code\check\run_004_seed_expected_examples.wl'
```

该检查只做小型 seed/metadata/linear/Kira 文件结构验证，不运行 Kira reduction，不做大范围解析生成。`006_sp_interface_check.wl` 另用奇怪动量命名和 `sp[p,r]` 输入检查 006 接口可贯通 sampled linear/Kira 内存导出。

## 推荐调用顺序

优先使用 workflow 入口做门禁串联；`LinearSystemMode -> "sampled"` 时默认使用 topology 里的 `numericRules` 做 sampled linear，Kira 阶段默认不再重复撒点：

```wl
Get["000_code/006_dS_ibp_general.wl"];  (* 新接口；若需旧稳定版可加载 005 *)

readiness = makeIBPReadinessReport[
  mixedBubbleCase,
  LinearSystemMode -> "sampled",
  ExportKira -> True
];

workflow = makeIBPWorkflowData[
  mixedBubbleCase,
  LinearSystemMode -> "sampled",
  ExportKira -> True,
  OutputDirectory -> "path/to/kira_input",
  KiraTargetIntegrals -> Automatic
];
```

若需要保存解析 seed 或手动插入自定义排序/撒点，也可以显式展开为 seed、linear、Kira 三步：

```wl
topoData = makeTopologyData[mixedBubbleCase];
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
  KiraCoefficientRules -> {},
  KiraTargetIntegrals -> Automatic
];
```

流程约束：

- seed 阶段只生成 Mathematica 表达式，不直接导出 Kira。
- `writeSeedBatchMMA` 只保存 `makeCanonicalSeedBatch` 生成的完整 seed batch；`OutputDirectory -> "..."` 为非空字符串时才写文件，`SeedFileBaseName` 必须是 `Automatic` 或非空字符串。`readSeedBatchMMA` 读取不存在文件时返回 `notRead`，不抛底层 `Get` 消息。
- `makeIBPReadinessReport[case, ...]` 是轻量体检入口，会返回 topology/seed/linear/Kira 各阶段 ready 状态、计数、pending features、issue codes、失败原因、`numericRuleRequirementReport`，以及 numeric workflow 的残留 `coefficientVariables`。
- raw case 会先经过输入 preflight；若缺少 `vertexData`、`lineData` 或 `loopMomenta`，`makeTopologyData`/workflow/readiness 会返回 `missingRequiredCaseKeys`。若这些字段形状明显不对，如 line 缺 `momentum` 或 `loopMomenta` 不是列表，会返回 `malformedCaseInput`，不会进入 parser 或 seed 生成。
- `loopMomenta` 与 `externalMomenta` 必须各自无重复，且两组基变量不能重叠；否则 topology validation 返回 `duplicateLoopMomenta`、`duplicateExternalMomenta` 或 `loopExternalMomentumOverlap`。line momentum 与 `sp[p,r]` 参数必须是这些基的线性组合，否则返回 `nonLinearLineMomenta` / `nonLinearScalarProductArguments`，避免 `Coefficient` 静默给出错误坐标。
- `vertexData` 会检查重复顶点、非法 `+/-` 符号，以及 `activeVertexIds` / `fixedAVertexValues` 是否引用了不存在的顶点。
- `extLegs` 与 `vertexEnergies` 会检查基础形状和顶点引用，避免 time-IBP 顶点能量从错误输入静默退回默认符号。
- line metadata 的 `massType`、`skType`、`state` 会在 `topologyValidationReport` 中检查；拼写错误会作为 topology error 阻止 seed/linear/Kira。
- `ispData` 会在 raw input 阶段检查列表形状、Association 必需键，并在 topology validation 阶段拦截重复 ISP 名，避免同一 family 坐标被静默覆盖。
- `seedRanges` 与 ISP 自带 `range` 只接受整数或非空整数列表；坏范围会作为 topology error 停止 seed/linear/Kira，避免拼错范围后静默退回 `{0}`。
- `seedOptions` 必须是 Association；`DiscreteMode` 只接受 `"sample"`、`"all"`、`"none"`，各类 `Max...Count` 必须是非负整数，`MaxShrinkSectorDepth` 还可取 `Automatic`。
- `makeCanonicalSeedBatch` 会合并 momentum/time/shrink-sector seed，并检查 EOM canonical 与 pending features。
- `makeCanonicalSeedCoverageReport` 检查 all-sector `qIBP/tIBP` 覆盖、逐 sector 生成元标签、EOM canonical 和 pending/forbidden 数据；canonical batch 进入 linear/Kira 前必须通过该 report，失败时 linear-system 返回 `seedCoverageReportNotReady` 并附带完整 report。若传入的是 momentum-only/time-only seed batch，`makeLinearSystemData` 会返回 `notCanonicalSeedBatch`；这些 batch 只用于 seed 层回归，不进入 Kira。
- `topologyValidationReport` 在 topology 初始化、seed batch、linear-system 和 Kira metadata 中都会保留，用来追踪输入拓扑/ISP/numeric rules 是否满足通用生成器前置条件。
- `topologyValidationReport` 中若存在 error，seed/linear/workflow/Kira 导出会在入口返回 `invalidTopology` 或 `notReady`，不会继续生成 IBP、编号线性系统或写 Kira 文件；warning 只作为提示保留。
- 数值规则和撒点规则在 linear/Kira 阶段使用；解析 seed 本身保持不撒点。
- `sampleDiscreteRules` 必须写成“替换规则列表的列表”，如 `{{n[1] -> 0, n[2] -> 1}}`；sample 模式下每个样本需覆盖当前 sector 的全部离散 `n`，取值只能是 `0/1`。
- `numericRules` 和 sampled linear-system 的 `CoefficientRules` 必须是替换规则列表；坏规则会在 topology 或 sampled linear 阶段返回 `invalidNumericRules` / `invalidCoefficientRules`。
- `zeroPointRules` 与 `shrinkPrefactorRules` 也必须是替换规则列表；坏规则会在 topology 阶段返回 `invalidZeroPointRules` / `invalidShrinkPrefactorRules`。
- 若 workflow 使用 `LinearSystemMode -> "numeric"`，`numericRules` 必须覆盖所有外部不变量、time-IBP 顶点外部能量和 massive line 参数（如 `nu`）。外部不变量的规则左端应使用输出变量名，例如自定义 `sigW -> 5` 或默认 `s11 -> 5`；`sp[k_i,k_j] -> value` 仍可作为输入兼容形式被内部转换，但报告和模板会提醒用户使用变量名。`numericRuleRequirementReport` 会集中列出 required/provided/missing 变量、`externalInvariantNamingReport` 和 `vertexEnergyNamingReport`，`makeNumericRuleTemplate[case]` 会生成缺失项的替换规则骨架。缺失时会在 seed 生成前返回 `numericRulesMissingExternalInvariants`、`numericRulesMissingVertexEnergies` 或 `numericRulesMissingLineParameters`。线性系统生成后还会检查系数是否已全数值化，若仍残留 `dim` 等其它参数则返回 `nonNumericCoefficients` 并列出 `coefficientVariables`。
- `makeLinearSystemData` / `makeSampledLinearSystemData` / `makeMomentumIBPLinearSystem` 的 topology 参数可传 raw case 或 `parseTopology` 后的 topology；内部会统一规范化。注意 `makeMomentumIBPLinearSystem` 现在会被 canonical 覆盖门禁拒绝，保留它只是为了确认旧 momentum-only 入口不会误入 linear/Kira 主线。
- workflow 的 `LinearSystemMode` 只接受 `"symbolic"`、`"sampled"`、`"numeric"`；拼写错误会在 seed 生成前返回 `invalidLinearSystemMode`。
- workflow 的 `ExportKira` 必须是 `True/False`；`OutputDirectory` 必须是 `None`、`Automatic` 或非空字符串，坏值会返回 `invalidWorkflowOptions`。
- Kira 导出只接受 `makeLinearSystemData` 或 `makeSampledLinearSystemData` 的完整输出；手工拼出的残缺 linear-system association 会返回 `notLinearSystem`。
- 直接调用 `makeKiraExportData` 时，`OutputDirectory` 同样必须是 `None`、`Automatic` 或非空字符串；`None/Automatic` 只生成内存字符串，不写文件。
- `makeIBPWorkflowData[..., ExportKira -> True]` 可只生成内存中的 Kira 字符串；只有同时给出 `OutputDirectory -> "..."` 时才写入文件，返回的 `kiraExport["writeFilesQ"]` 会显式记录是否落盘。`LinearSystemMode -> "sampled"` 或 `"numeric"` 且 `CoefficientRules -> Automatic` 时，workflow 会使用 topology 的 `numericRules`；此时 `KiraCoefficientRules -> Automatic` 会解析为 `{}`，避免重复撒点。
- `KiraTargetIntegrals -> Automatic` 默认把全部积分编号写入 `list`；也可传 `{1, J[...]}` 这样的 id/积分对象混合列表来只导出指定目标。
- `KiraOrdering` 必须是 `Automatic` 或 Association；`IntegralOrder` / `PreferredIntegrals` / `SectorOrder` 必须是列表，`PreferredPriority` 只接受 `"BeforeB"` 或 `"AfterB"`。排序作用于全局 `integralList`，不是逐 sector 分别排序；轻量检查已覆盖把 shrink-sector 积分指定为 preferred 后排到全局第一。
- Kira 导出返回值会直接包含 `kiraOrderingReport` 与 `manualIntegralOrderReport`，用于检查用户指定的 master/排序对象是否全部出现在当前全局积分列表中。
- `KiraIntegralOrder` 必须是 `Automatic` 或积分 id / `J[...]` 对象列表；其它类型会返回 `invalidKiraIntegralOrder`，避免手动 master 排序被静默忽略。
- Kira 导出和 `kira_export_metadata.m` 会记录系数替换后的 `numericCoefficientSystemQ` 与 `coefficientVariables`；若用户选择符号系数导出，残留参数会显式列出但不强制阻止导出。
- `KiraCoefficientRules` 必须是替换规则列表；非列表或混入非 `Rule/RuleDelayed` 项时导出会返回 `invalidCoefficientRules`，不会写 Kira 文件。
- 若导出的 Kira 系数已经全部数值化，`KiraJobOptions` 中的 `"AppendNumericDummyEquation" -> Automatic` 会追加参考代码同款 dummy block `(N+1)*(ccc)`，并把 `list` 扩到 `targetIntegralCount = integralCount + 1`。
- 默认只写 Kira 输入文件和参考式 `run.sh`，不运行 Kira reduction；`KiraJobOptions` 可覆盖 `"KiraCommand"`、`"KiraParallelJobs"` 或设 `"WriteRunScript" -> False`。
- `KiraJobOptions` 会在导出前检查未知 key 和非法值；布尔开关必须是 `True/False`，`KiraParallelJobs` 必须是正整数，命令/文件名/符号名必须是非空字符串。

## 当前验证覆盖

已纳入轻量检查的例子包括 pure massless bubble、mixed massive/massless bubble、mixed triangle、mixed sunrise、pure massive bubble 参考对照、two-loop ISP toy 和 massless box topology replacement。它们覆盖的是逐线 `{b_e,n_e}` 的 massless double-theta merged 主线；同一顶点对多条 massless 线的真实 bundle 合并目前只记录 `masslessBundleCandidates`，暂不作为默认 seed canonical。

其中以下函数族已经按 sector 做了手推 seed 对照：每个 sector 至少有一个 qIBP seed 和一个 tIBP seed 与程序输出逐项比较。

- pure massless bubble：`top`
- mixed massive/massless bubble：`top`, `e1`
- mixed triangle：`top`, `e1`, `e2`, `e1_e2`
- mixed sunrise：`top`, `e1`

这些检查证明当前主线接口可以生成小规模 seed、linear-system 和 Kira 文件结构，并且上述代表函数族的 sector-level q/t seed 公式已做手推对照；它们仍不等价于对任意拓扑的完整数学证明。后续工作应优先补充新的代表 topology 或生成元类型，而不是继续增加零散输入检查。

当前不默认实现的内容：

- 同一顶点对多条 massless 线的真实 bundle canonical 合并；目前只记录候选 metadata。
- 自动选择或删除冗余 propagator basis；用户输入的 propagator 与 ISP 坐标应已构成可反解 family。
- 运行 Kira reduction 或确认最终 master integral 数；本 package 只导出输入文件。
- 大范围解析 IBP 生成；验证应保持 seed 层或数值/撒点小范围。

## 笔记

- `000_note/dS_IBP_package_plan.md`
- `000_note/dS_IBP_package_design_note.md`
- `000_note/dS_IBP_seed_validation_plan.md`
- `000_note/dS_IBP_package_tech_note.tex`
