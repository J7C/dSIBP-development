# Massive bubble reference code 使用说明

本目录是 pure massive bubble 的原始 reference Kira 工程。它用于解释既有解析结果的来源和 convention，不是 dSIBP package 的 producer，也不应在 package 发布检查中重新生成关系或重新运行 reference Kira。

## 只读结果边界

package 对照只允许从原始 `result/` 目录复制并校验以下五份已经存在的解析结果：

| file | SHA-256 |
| --- | --- |
| `DEP0.m` | `0BFE6B9CC01780C961D31A9488CE203B2A421735E5F6E735E19BAA5F357C8C8A` |
| `DEks.m` | `D21FE2474AE9A3DAB31B2618DA87AB8E3F98C65A4B0D6CB3CC5937DEE2267BC6` |
| `DEscaleCheck.m` | `5B1754A5DD285BDABB47068996E726624E137ABD1F298D2756C6EC038D66D573` |
| `MIdlogNote.m` | `5EF8F2E52A52FBFC06DC06054329E5573622875E6AC71ECB39C798BDF70F3A37` |
| `derivative_rules_bubble.m` | `00428810E74588A37291B55DBC23A8384927FA61EAE4D90BDC417F1707019FF6` |

禁止用 `run.sh`、`jobs.yaml`、`001 bubble_ibp_sym.m` 或 `002 bubble_de.m` 为某个新数值点重建 reference IBP/reduction。需要新 package 证据时，只重跑 package 侧 export/reduction/import；reference 侧继续复制上述同字节结果。

## 三种 basis 不能混用

1. 原始 physical dlog basis 是 `MIdlogNote[[;;19]]`。
2. `MIdlogKira` 是应用 `reppara2N` 后的 Kira basis；`reppara2N` 含 `ks->1`。
3. `DEP0.m/DEks.m` 保存的是第 2 种 stored basis 的矩阵，不是已经恢复显式 `ks` 的 physical dlog basis。

`MIdlogNote` 第 15--18 项各含一个显式 `ks`。设

```text
T = DiagonalMatrix[{1,...,1,ks,ks,ks,ks,1}]
```

则恢复 physical basis 时必须使用

```text
A_P0_physical = T A_P0_stored T^-1
A_ks_physical = (D T/D ks) T^-1 + T A_ks_stored T^-1
```

漏掉第一项会丢失四个 master 的 `ks` 导数系数。stored 矩阵在此之前只做 source-defined homogeneity lift `N A N^-1`；不要额外加入 `N' N^-1`。最终 19 个 reference/package master 定义比例逐项都是 1，不允许从差矩阵反解 post-hoc basis adapter。

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

按上述来源和变换，reference 与 018 package 的 physical `P0`、backend `ip0`、physical `ks` 三套 `19x19` 矩阵均为 `361/361` 精确相等，非零差值 0。最终轻量 probe 及其来源哈希记录在 `independent-benchmark/reference-results/pure_massive_bubble/`；该 probe 只用于最后比较，不能用于选择 masters 或补造 reduction。
