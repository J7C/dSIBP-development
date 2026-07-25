# Single-massive sunrise

运行 `wolframscript -file main.wl`。本例固定为两个顶点、三条平行传播子和两个圈动量：第一条传播子是 massive h，另外两条是 massless exponential，并显式给出两个 ISP。

脚本把两个顶点的外腿能量统一为 `kE`，并保留独立圈外模长 `kL`，因此是两标度输入。两个 ISP 选成在两条 massless 平行线交换下互换的一对；`symmetryRules` 同时实现顶点交换和 massless line/ISP 交换。

脚本依次执行 `DSKinematics`、`DSInit` 和 `DSSeeds`，正常构造 contact-reachable sectors 的 general 模板；随后只选取一个 top-sector `qIBP` 模板。目标包络由该模板的 shift bounds 构造，因此只展开一个 seed 点的最小关系并调用 `DSLinear`。本例不构造 formal Kira plan，不运行 Kira 或 reduction，也不写运行产物。

本目录是 package 中唯一的 sunrise example；其它 examples 不应再复制或改名形成第二套 sunrise 输入。
