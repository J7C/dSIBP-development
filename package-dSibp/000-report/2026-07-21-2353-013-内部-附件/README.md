# 013 pure time-IBP/tree 独立检验工作区

本目录只服务于任务书第 14 节。阶段 1 的输入限于：

- `independent-benchmark/independent-benchmark.md`；
- 根 `AGENTS.md` 与 `independent-benchmark/README.md` 的流程边界；
- arXiv:2401.00129 的公开源码（本目录 `paper_source/`）。

冻结前未读取 `independent-benchmark/package/`、`000_code/`、`000_note/`、
`研究计划与研究进度.md`、旧 expected/check/results/report。

## 固定 case

### `two_vertex_pp_full`

- 分支：`{+,+}`。
- 顶点：`v1,v2`；相位能量 `E1,E2` 与内部能量 `k12` 独立。
- 内线：有序 `(v1,v2)` 的单一 massive h `G++`，参数 `nu12,k12`。
- loop top：`J[{a1,a2},{{b12,n11,n21}},{}]`。
- tree top：`J[{{A1,n11},{A2,n21}}]`，其中 `Ai=ai+alphai`。
- contact sector：`J[{{A1+A2-(2 nu12+1)}}]`。
- top master 顺序：`00,01,10,11`，最后一个 bit 变化最快；lower master 数为 1。
- general `dtau`：`4` 个离散态 x `2` 个 active vertex = `8` 条；其中 `4` 条含非零 contact。

### `three_vertex_ppm_chain`

- 分支：`{+,+,-}`。
- 顶点：`v1,v2,v3`；相位能量 `E1,E2,E3` 与 `k12,k23` 相互独立。
- 边 `(v1,v2)`：单一 massive h `G++`，参数 `nu12,k12`。
- 边 `(v2,v3)`：单一 massive h `G+-`，参数 `nu23,k23`。
- loop top：`J[{a1,a2,a3},{{b12,n11,n21},{b23,n22,n31}},{}]`。
- tree top：`J[{{A1,n11},{A2,n21,n22},{A3,n31}}]`。
- `(v1,v2)` contact sector：`J[{{A1+A2-(2 nu12+1),n22},{A3,n31}}]`。
- top master 顺序：`0000,0001,...,1111`，bit 顺序为
  `{n11,n21,n22,n31}`，最后一个 bit 变化最快；lower master 顺序为
  `{n22,n31}=00,01,10,11`。
- general `dtau`：`16` 个离散态 x `3` 个 active vertex = `48` 条；其中 `16` 条含 `G++` contact。
- `G+-` 负面门禁：全部 `48` 条关系中 `(v2,v3)` contact 数必须为 `0`。

## 第 14 节新增计数口径

| 阶段 | two-vertex | three-vertex | 合计 |
|---|---:|---:|---:|
| general `dtau` relation | 8 | 48 | 56 |
| loop -> tree projection | 8 | 48 | 56 |
| 局部 vertex `M1/M0` row | 4 | 8 | 12 |
| general 单步 `A-/A+` bundle | 2 | 3 | 5 |
| 两级下降迭代 bundle | 2 | 3 | 5 |
| dlog bundle | 2 | 3 | 5 |
| `G+-` contact/WT guard | 0 | 2 | 2 |

这里的 bundle 以 active vertex 计数。每个 bundle 内比较完整矩阵、全部 binary
master 和全部 letters，不把矩阵元素拆成额外“通过数”。

