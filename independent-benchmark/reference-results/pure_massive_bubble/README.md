# Pure massive bubble 最终对照

本目录只提供 `pure_massive_bubble_reference` 在固定精确 Gaussian-rational 点的轻量最终对照。它不是独立手推 expected，不是 Kira reduction，也不能替代 package 侧 fresh export/reduction/import、`DSDE` 或 scaling 检查。

## 读取顺序

1. Phase 1 禁止读取本目录，先按任务书独立推导并冻结 expected。
2. Phase 2 先用当前 package 完成 fresh Kira、`DSKiraImport -> DSDE`、scaling、19 维 basis 顺序和 convention 审计。
3. 上述检查通过后，才可读取 `reference_probe.wl` 做固定点最终比较。不得用它反推 master、补造 reduction 或修改 Phase 1 expected。

## 数据与 convention

`reference_probe.wl` 返回 Association，主要字段为：

- `"masterBasisNative"`：reference 的 19 个有序 active masters。
- `"deP0"`、`"deIp0"`、`"deKs"`：physical `P0`、backend `ip0`、physical `ks` 的三套精确 `19x19` DE 矩阵。
- `"scalingDiagonal"`：同序 physical master degrees 的 Euler/scaling 对角矩阵。
- `"probeRulesReference"`：`{ks->43/17,P0->29 I/13}`。
- `"probeRulesPackage"`：`{ss11->43/17,P0->-29 I/13}`。
- `"backendRules"`：`{ip0->29/13}`。
- `"masterDegrees"`、`"physicalDlogExplicitKsDegrees"`、`"physicalMasterDegrees"`：stored basis、显式 `ks` 与 physical basis 的 degree 数据。
- `"checks"`：复制来源、矩阵维数、分母、参数残留、Gaussian-rational 和 scaling 门禁。

固定 convention 为 `P_pkg=-P_ref`、`P0_pkg=-I ip0`、`ks=ss11=Sqrt[sp[k,k]]`。因此

```text
D/D P_pkg = -D/D P_ref
D/D P0_pkg = I D/D ip0
P0_pkg D/D P0_pkg = ip0 D/D ip0
```

既有解析矩阵先按 stored master degrees 做 `N A N^-1` 的 homogeneity lift，不加入 `N' N^-1`。随后恢复原始 `MIdlogNote` 第 15--18 项的显式 `ks`：`A_P0=T A_P0 T^-1`，`A_ks=T' T^-1+T A_ks T^-1`。这是源码定义的 physical dlog basis 恢复，不是 package normalization adapter。19 个 reference/package master 定义比例逐项均为 1。

## 来源与完整性

bundle 于 2026-07-25 从 `F:\Agent-projects-nut\dSibp\codebubble\kira_bubble\result\` 的既有解析结果复制并变换；没有重新生成 reference IBP，也没有运行 reference Kira。原始大矩阵不复制到本目录，只在 ignored 维护工作区中按下列 SHA-256 校验：

| source | SHA-256 |
| --- | --- |
| `DEP0.m` | `0BFE6B9CC01780C961D31A9488CE203B2A421735E5F6E735E19BAA5F357C8C8A` |
| `DEks.m` | `D21FE2474AE9A3DAB31B2618DA87AB8E3F98C65A4B0D6CB3CC5937DEE2267BC6` |
| `DEscaleCheck.m` | `5B1754A5DD285BDABB47068996E726624E137ABD1F298D2756C6EC038D66D573` |
| `MIdlogNote.m` | `5EF8F2E52A52FBFC06DC06054329E5573622875E6AC71ECB39C798BDF70F3A37` |
| `derivative_rules_bubble.m` | `00428810E74588A37291B55DBC23A8384927FA61EAE4D90BDC417F1707019FF6` |
| `reference_probe.wl` | `411D0F4766FF63A43406239C300714531F016115EFE12E2110568508F8B4DE05` |

维护 check 的最终结果为：来源/副本哈希 5/5，分母全非零，无残留参数，reference scaling 精确成立；与 package 比较时 physical `P0`、backend `ip0`、physical `ks` 均为 `361/361` 精确相等、差值 0。
