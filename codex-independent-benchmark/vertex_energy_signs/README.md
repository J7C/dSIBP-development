# vertex_energy_signs

三组能量输入 A/B/C 均保持任务书原样，并显式加入 `rho1=sp[ell,k]`。由 `D1=(ell-k)^2` 与 `rho1` 可反解 `ell^2=D1+2rho1-s11`，所以两个 momentum generators 和 `s11` 总导数完整闭合。

第三槽固定为 `{r1}`，并覆盖 `r1=0,1`。同分支有 `top/e1`，混合分支只有 top；A 使用独立 `ke[1],ke[2]`，B 使用 `Sqrt[s11],ke[2]`，C 使用独立 `ke[3],ke[2]`。relations 与 derivatives 的正式计数由 `expectedSummary` 和 package 对照脚本冻结。
