# MadStree v0.16 独立检验报告：论文两顶点 massive G++ 全链

## 状态

- 状态：`passed`
- 通过：`26/26`
- 范围：只 fresh 执行 2411.03088 Sec. 4 两顶点 massive G++ Validation-04。
- 数值判据：不要求逐位相等；安全因子固定为 `10`，按两条 FlintNDE 主/参考阶差与论文 cutoff 差组成联合预算。

## 路线独立性

- 论文路线在加载 MadStree 前由独立附件构造五维 DE、五支边界和 FlintNDE JSON。
- MadStree 路线实际调用：`{"MSInitTree", "MSMasterIntegrals", "MSDLogDE", "MSBoundaryData", "MSEvaluatePath"}`。
- 论文路线未读取 `MSDLogDE`、`MSBoundaryData` 或 MadStree runtime payload。

## 结构与边界

- 三个 exact `5x5` DE 相等项数：`<|k12 -> 25, k34 -> 25, ks -> 25|>`；非零差值数：`<|k12 -> 0, k34 -> 0, ks -> 0|>`。
- 五支 Frobenius exponent：`{9, 38/5, 31/5, 24/5, 46/5}`。
- 五个 boundary coefficient residual：`{0, 0, 0, 0, 0}`。
- 论文印刷 Eq. (4.11) / Eq. (4.2) 直接积分：`I`；本检验以 Eq. (4.2) 定义积分为 oracle。
- boundary weight 最大绝对 residual：`0`。

## 普通点与误差

- 论文点：`{{k12 -> 30, k34 -> 6}, {k12 -> 24, k34 -> 8}, {k12 -> 18, k34 -> 9}}`。
- 三点五分量比较行数：`15`；三方全部在联合预算内：`True`。
- 三方最大绝对差：`1.469495896713446014630449474403387345349514464885249704714769247570007997985468`65.24237564264244*^-37`。
- 论文级数代回 DE 的最大 residual：`1.99670253242289892315917821091508644691595`31.400760622890843*^-36`。

## 路径、精度与耗时

- 工作精度/边界阶/输运主参考阶：`{100, 42, 144, 184}`。
- MadStree 路线节点数：`{11, 3, 3}`。
- 论文 FlintNDE 路线节点数：`{11, 3, 3}`。
- 各阶段 wall time（秒）：`<|"packageBoundarySeconds" -> 0.0693281, "packageTransportSeconds" -> 7.9683752, "paperFlintSeconds" -> 7.5911752, "paperSeriesSeconds" -> 0.5425515, "totalSeconds" -> 19.3471674`8.738162382871574|>`。

## 检查项

- `paperHash`：PASS
- `erratumHash`：PASS
- `referenceCodeHash`：PASS
- `referenceCodeResidual`：PASS
- `printedEq411DiffersFromDefiningEq42ByI`：PASS
- `paperRouteRanBeforePackage`：PASS
- `paperFlintProcess`：PASS
- `paperFlintComputed`：PASS
- `publicCallCompleteness`：PASS
- `incompleteRouteRejectedByGate`：PASS
- `fiveMastersPaperOrder`：PASS
- `identityBasis`：PASS
- `childNormalization`：PASS
- `exactDE`：PASS
- `fiveBoundaryBranches`：PASS
- `boundaryExponents`：PASS
- `boundaryCoefficients`：PASS
- `boundaryVectors`：PASS
- `boundaryWeights`：PASS
- `boundaryWeightedVectors`：PASS
- `packageTransportComputed`：PASS
- `packageTransportRefinement`：PASS
- `paperFlintRefinement`：PASS
- `threeOrdinaryPoints`：PASS
- `allNumericalComparisonsWithinJointBudget`：PASS
- `paperSeriesDE`：PASS

机器证据：`results/summary.wl`。长 JSON、cache 与 runtime 已清理。
