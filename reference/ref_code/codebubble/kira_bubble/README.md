# Massive bubble reference code 使用说明

本目录是 pure massive bubble 的 reference 工程记录。它用于解释对照结果的来源和 convention，不是 dSIBP package 的 producer，也不应在 package 发布检查中重新生成关系或重新运行 reference Kira。

当前对照的解析结果来自最终构造 `F:\Agent-projects-nut\dSibp\code_final_version\`（仓库外）；本目录下的 `001 bubble_ibp_sym.m`、`002 bubble_de.m`、`OmegaR/`、`Omegatau/`、`Omega_tau_generator.m`、`dlogde_extract.m`、`test.nb` 是旧构造的历史源码快照，只用于历史 convention 解释。

## 只读结果边界

package 对照只允许从 `F:\Agent-projects-nut\dSibp\code_final_version\` 复制并校验以下四份已经存在的解析结果：

| file | SHA-256 |
| --- | --- |
| `full19_connection/DEP0.m` | `3BBE60C195E6E12C2EABA224984D21E21FD46FB471EF07DE61177A78232FA1AF` |
| `full19_connection/DEks.m` | `55F0CCB7B510FD6F7EBFDAC60F1EF6CB71828C6C31E413C0698DF8E79B25CCD2` |
| `full19_connection/DEscaleCheck.m` | `0C89F900B4E6405F4037AB092DED337C48EF4BF0F6BA1411EF07B5DD9732254D` |
| `basis/MIdlogNote.m` | `500772CC4666FC9857D3EC6BF8490C15D11675FA0A776435B4AF15FAB0A8014E` |

旧构造 `F:\Agent-projects-nut\dSibp\codebubble\kira_bubble\result\` 的五份结果（`DEP0.m`、`DEks.m`、`DEscaleCheck.m`、`MIdlogNote.m`、`derivative_rules_bubble.m`）不再是对照来源，只作历史记录。

禁止用 `run.sh`、`jobs.yaml` 或 `001`/`002` 为某个新数值点重建 reference IBP/reduction。需要新 package 证据时，只重跑 package 侧 export/reduction/import；reference 侧继续复制上述同字节结果。

## basis 与恢复步骤

当前 `basis/MIdlogNote.m` 为 19 项统一权重的 physical dlog basis，全部 active、没有辅助关系；`002 bubble_de_exp_full.m` 保持 `ks` 符号并直接建立 physical 矩阵，`full19_connection/DEP0.m`、`DEks.m` 已是恢复后的结果。因此对照时不再有旧版第 15--18 项显式 `ks` 的恢复步骤，变换退化为能量方向号加恒等：

```text
A_P0_physical = -A_P0_export
A_ks_physical =  A_ks_export
```

旧构造的第 15--18 项各含一个显式 `ks`，且 `002 bubble_de.m` 曾经 `ks->1`，因此当时需要 `T = DiagonalMatrix[{1,...,1,ks,ks,ks,ks,1}]` 与 `D[T,ks] T^-1` 乘积法则项；当前构造不存在这两个问题，不要套用旧步骤，也不允许从差矩阵反解 post-hoc basis adapter。最终 19 个 reference/package master 定义比例逐项都是 1。

## 能量与 Kira-only 实变量

reference 与 package 物理能量满足

```text
P_pkg = -P_ref
```

package serializer 内部再使用

```text
P0_pkg = -I ip0
D/D P0_pkg = I D/D ip0
P0_pkg D/D P0_pkg = ip0 D/D ip0
```

`ip0` 是一个实变量名，不是 `I*p0`。固定 probe 为 `ks=43/17`、`ip0=29/13`，对应 package 物理点 `P0=-29 I/13` 和 reference 点 `P0=+29 I/13`。普通导数必须带上上述 Jacobian；Euler 算符不额外变号。

## 已确认结果

按上述来源和变换，reference 与当前 package 的 physical `P0`、backend `ip0`、physical `ks` 三套 `19x19` 矩阵均为 `361/361` 精确相等，非零差值 0。最终轻量 probe 及其来源哈希记录在 `independent-benchmark/reference-results/pure_massive_bubble/`；该 probe 只用于最后比较，不能用于选择 masters 或补造 reduction。
