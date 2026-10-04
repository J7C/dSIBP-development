# FlintNDE 0.5.0 Validation-04 独立报告

- 状态：**passed**，15/15。
- 当前 Python 源码聚合 SHA-256：`39b0e7956a400faa9bf219ca2d2c81bbb599cc0583f4fe2f58ad5d43142b0225`。
- 工作精度：`90`；表观 pole 主/参考阶 `40/56`；指数起点主/参考阶 `64/88`；总 wall time `1.253788 s`。

## 支持路线

- 表观二阶 pole：Lee–Moser exact 降为一阶 pole，projector 幂等和原系统 round-trip 均 exact；
  普通点闭式 `(-3,2)` 最大主/参考误差为 `[5.1680771128914625008681537198234680958176608984357e-24 +/- 1.04e-74]` / `[2.8716425566837269923877943597530057079894430182580e-33 +/- 1.89e-83]`。
- 标量指数起点：局部签名 `phi=-1/x`，边界 `C=3`；闭式终点为 `3/e`；
  主/参考误差为 `[8.2021932710969107393582832863985825073014062799140e-41 +/- 2.52e-91]` / `[9.9889793780386625804690345457024718172675248264007e-55 +/- 7.31e-105]`。

## Fail-closed 边界

- nilpotent defective block：局部基和规划均在输运前拒绝。
- indicial roots `+/-sqrt(2)`：不属于 Q(i)，规划标记不可 continuation。
- coupled formal exponential block：只允许 start-only 局部求值；作为中间点或终点均明确要求 Stokes connection。
- 失败项：`无`。
- 机器 summary：`results/summary.json`，含实际路径、变换、边界和失败消息。
