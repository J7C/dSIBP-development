# Mix bubble+tree

运行 `wolframscript -file main.wl`。本例固定三条内线：`v1-v2` 间是一条 massive h cycle line 和一条 massless exponential cycle line，`v2-v3` 间是一条 massless exponential bridge line。

`loopExternalMomenta={k1+k2}` 定义 loop 外方向，`independentExternalMomenta={k1,k2}` 定义两个无圈模长；脚本展示缺省 `ss11/sE1/sE2`、自定义 `loopScale/legScale1/legScale2`、顶点独立相位，以及 cycle/fixed line pack 和 contact/shrink 后的 sector 数据。

本例不增加第二条 massive line，避免把 compound topology 的角色、massless convention 和 bridge/cycle contraction 演示混入不必要的 massive function-system 组合。
