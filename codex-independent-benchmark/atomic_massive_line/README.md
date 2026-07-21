# atomic_massive_line

## Topology

两个有序顶点 `{v1,v2}`，一条 massive 线 `ell` 从 `v1` 指向 `v2`，无外部向量、无 ISP。固定 `--` 是 full line，可到达 `e1`；固定 `-+` 是 cross line，只有 top。分别计算 direct-h、bare-H 与 H-to-h，不施加额外 symmetry。

## J 槽位

- top：`J[{a1,a2},{{b1,n11,n12}},{}]`。`n11` 属于第一端点 `v1`，`n12` 属于第二端点 `v2`。
- shrink：`J[{a12},{{bS1}},{}]`。合并顶点代表是 `v1`。
- top zero-point：`{alpha1,alpha2,beta1}`。
- H shrink zero-point：`a0Merged=alpha1+alpha2`、`bS0=beta1`。
- h shrink zero-point：`a0Merged=alpha1+alpha2-2nuM`、`bS0=beta1+2nuM`。

## Generators And Coverage

生成元为 `dtau[v1]`、`dtau[v2]`、`dqq[1,1]`。top sector 穷举 `(n11,n12) in {0,1}^2`；shrink sector 没有离散态。

| 项目 | 每条 route | 三路合计 |
|---|---:|---:|
| top relations | 24 | 72 |
| shrink relations | 2 | 6 |
| total | 26 | 78 |

预期零关系数为 0；`(0,0)` 与 `(1,1)` 只是不产生 contact，regular IBP 本身并不为零。

## Tags

- `massiveEndpoint1` / `massiveEndpoint2`
- `massiveEOM`
- `thetaShrink` / `noThetaShrink`
- `hMode` / `HMode` / `HTohMode`
- `topSector` / `shrunkSector`
