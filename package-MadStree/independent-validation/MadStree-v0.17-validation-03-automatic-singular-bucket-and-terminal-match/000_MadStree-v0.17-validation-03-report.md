# MadStree v0.17 Validation-03 独立报告

- 状态：**passed**，19/19。
- exact 系统：`Y=(x+1)/(1-x)`；用户点 18 个，`x=1` 为真实 pole。
- 工作精度/主阶/参考阶：`90 / 64 / 88`；目标相对误差 `1e-25`；安全因子 8。

## 路径与效率

planned/naive wall time：`0.2073649000376463 / 3.325805999804288 s`；naive/planned：`16.038423085105055`。
真实节点、逐点 source/assignment、收敛半径、userIndex 与闭式/naive 误差均保存在 `results/summary.wl`。

## 末端与反例

末端奇点使用到最近其它奇点的距离生成域内隐藏匹配点；低阶链给结果，高阶链只核验分类和误差。
关闭规划的中间奇点、需要隐藏末端匹配点以及从不可继续的奇点进入下一段均 fail closed。
本 case 只认证 adapter，不认证真实树图 master、dlog 或边界。
