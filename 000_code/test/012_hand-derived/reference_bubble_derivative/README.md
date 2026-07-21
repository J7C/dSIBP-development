# reference bubble derivative

本目录把 `reference/ref_code/codebubble/001 bubble_ibp_sym.m` 的 massive bubble 求导路线完整映射到统一 `J`：

- `Vpm=0` 映射为 `--`，顶点能量取 `I k0`，使 reference 的 `dk0Term` 与 package 相位 convention 一致。
- `G` 映射 top sector；`R1/R2` 分别映射 line 1/2 shrink sector。
- top zero-point 使用 `a0=2 nu`、`b0=-2 nu`；shrink 后得到 `a0R=2 nu`、`b10R=0`、`b20R=-2 nu`。
- `s11=ks^2`，因此 `partial_ks=2 ks partial_s11`。
- reference 的 `R2->R1`、top/sector canonical symmetry 和 `reppowerselection` parity 均通过 case 的 `symmetryRules` 交给 package `symmetry` 模块应用。

`expected.wl` 冻结 reference 的 `dk0Term`、`dksTerm` 和 h-EOM，不调用主线 `ds` 或独立变量求导 helper。reference 在构造求导 basis 前已经执行 `R2 -> R1`，因此导数逐项比较覆盖其实际保留的 top 与 R1 全部 0/1 端点态；R2 通过 package `symmetry` 的原子检查确认先 canonical 到 R1。连续指标保持 general，同时检查带参数系数的积分组合、zero-point 映射及 symmetry/parity。
