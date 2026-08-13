# MadStree 效率测试记录

----------
## Step 1: Example 04 真实三顶点的 900 点线程测试

Case：MadStree v0.11 `Examples/04_three_vertex_tree.wl` 的三顶点、两条
`masslessFull` 传播子树图，dlog 系统为 9 个 master。900 个 exact 点从自动边界 anchor
`{k1=-4096 I,k2=-256 I,k3=-16 I}` 沿同一复仿射单变量段到
`{k1=-9 I,k2=-3 I,k3=-5 I}`；固定 `q12=1,q23=2,a1=a2=a3=1`。工作精度 40 位，
primary/reference 阶数为 80/104，目标相对误差 `1e-20`。每条路线使用 cold Python 进程，
在 adapter 执行前设置并回读 python-flint `ctx.threads`。

路线说明：

- R1 planned：FlintNDE 规划输运节点，同一节点覆盖的非节点用户点做 dense 批量求值。
- R2 direct：关闭规划，严格把 900 个用户点按输入顺序作为输运节点。

| route | parallel | run 1 wall | run 2 wall | mean wall | process CPU/wall mean | check/status |
| --- | --- | ---: | ---: | ---: | ---: | --- |
| R1 planned | w1*1 | 11.394483 s | 11.289446 s | 11.341965 s | 0.995 | passed |
| R1 planned | w10*1 | 11.486995 s | 11.655929 s | 11.571462 s | 1.140 | passed; relative to w1, 2.02% slower |
| R2 direct | w1*1 | 40.149104 s | 41.410223 s | 40.779663 s | 0.998 | passed |
| R2 direct | w10*1 | 40.646019 s | 41.292360 s | 40.969189 s | 1.039 | passed; relative to w1, 0.46% slower |

两轮均确认 `3 vertices / 2 propagators / 9 masters / 900 points`。planned/direct 对全部
`900*9=8100` 个复分量逐点互检，两轮及两种线程数的最大绝对差均为
`1.0847529429307444e-35`。threads=1/10 下 planned 相对 direct 分别快 3.59547/3.54054 倍。

第二轮的实际分配不随线程数变化：planned 共 28 个后端节点，875 个用户点由节点展开作
dense 求值；其中 854 点走 `acb_poly.evaluate(..., algorithm="fast")` 子积树/余数树，
21 点走小桶迭代求值，另 25 点恰落在节点。direct 共 901 个节点，900 个用户点均逐点输运，
没有 dense 点。

这里的 wall time 是从 Wolfram 调用 `MSEvaluatePath` 到返回结果的端到端现实墙钟时间，包含
边界生成、Python 进程启动、路径处理、primary/reference 输运和结果回读。第二轮单独记录的
backend-only wall time（上述四个数值阶段之和）为：planned w1/w10 = 8.921989/9.272482 s，
direct w1/w10 = 38.879582/38.750232 s；它不是另一种 CPU 时间。

结论：当前真实三顶点 case 不采用 `ctx.threads=10` 作为加速设置；planned 的算法降复杂度
产生约 3.5 倍整体收益，而不是 FLINT 线程数产生收益。
