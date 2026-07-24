# Pure massive bubble 最终对照

本目录只提供 `pure_massive_bubble_reference` 在固定精确有理点的轻量最终对照。它不是独立手推 expected，不是 Kira reduction，也不能替代 fresh export/reduction/import、符号 DE 或 scaling 检查。

## 读取时序

1. Phase 1 禁止读取本目录。先按任务书独立推导并冻结全部 expected。
2. Phase 2 先用当前最新 package 完成 fresh Kira、`DSKiraImport -> DSDE`、符号 scaling、19 维 basis 顺序和 convention adapter 审计。
3. 上述检查全部通过后，才可 `Get["reference_probe.wl"]` 做固定点最终比较。不得用该文件反推 master、补造 reduction 或修订冻结 expected。

## 文件内容

`reference_probe.wl` 返回一个 Association，主要字段为：

- `"masterBasisNative"`：reference 的 19 个有序 active masters；行列顺序均按此列表。
- `"deP0"`、`"deKs"`：固定有理点的两套精确 `19x19` DE 矩阵。
- `"scalingDiagonal"`：同序 master 的 Euler/scaling 对角矩阵。
- `"probeRulesReference"`：`{ks->43/17,P0->29/13}`。
- `"probeRulesPackage"`：`{ss11->43/17,P0->29/13}`。
- `"masterDegrees"`、`"checks"`：逐项 scaling degree 与提取时的精确门禁。

convention adapter 固定为：reference `Vpm=0` 对应 package `--`；`P_pkg=-P_ref`，且 reference `P1=P2=-P0`；`ks=ss11=Sqrt[sp[k,k]]`，旧平方变量为 `s11=ks^2`。跨不同 scaling degree 的矩阵元已按逐行/逐列 degree 差恢复，不能再统一乘除一个 `ks`。

最终比较必须在同序同 normalization basis 中得到：`deP0` 为 `361/361` 精确相等，`deKs` 为 `361/361` 精确相等，且 Euler 组合等于 `scalingDiagonal`。比较前必须检查全部矩阵元分母在 probe 上非零。

## 来源与完整性

该 bundle 于 2026-07-24 从只读目录 `dSibp/codebubble/kira_bubble/result/` 的既有解析结果提取；没有加载 dSIBP package，也没有运行 reduction。原始大表不复制到本目录。

| source | SHA-256 |
| --- | --- |
| `DEP0.m` | `0BFE6B9CC01780C961D31A9488CE203B2A421735E5F6E735E19BAA5F357C8C8A` |
| `DEks.m` | `D21FE2474AE9A3DAB31B2618DA87AB8E3F98C65A4B0D6CB3CC5937DEE2267BC6` |
| `DEscaleCheck.m` | `5B1754A5DD285BDABB47068996E726624E137ABD1F298D2756C6EC038D66D573` |
| `MIdlogNote.m` | `5EF8F2E52A52FBFC06DC06054329E5573622875E6AC71ECB39C798BDF70F3A37` |
| `derivative_rules_bubble.m` | `00428810E74588A37291B55DBC23A8384927FA61EAE4D90BDC417F1707019FF6` |
| `reference_probe.wl` | `51A141F8086A8904D4670AE9B9D3C90A7866156534648C33E94450F4E3E599AC` |

提取门禁为：矩阵维数正确、全部实虚部为精确 Gaussian 有理数、Euler/scaling `361/361`、source scaling diagonal 一致；当前四项均为字面 `True`。
