# all family total derivative

本 benchmark 对现有 10 个物理函数族的全部 sign/mode 和 contact-reachable sector 检查公开接口 `ds[expr,sij]`。

每个 case 使用两个积分：一个取所有允许离散态 `n=0`，另一个取所有允许离散态 `n=1`；时间指标、线指标和 ISP 指标分别保持为 general 的 `ga[...]`、`gb[...]`、`gr[...]`。测试表达式为两个带动力学量系数的积分加纯系数项。

`expected.wl` 不调用主线 `ds`、`applyIndependentVariableDerivativeSeed`、external-vector decomposition 或主线指标移位 helper。外不变量部分从

```text
D_ij = k_i . partial/partial k_j
```

独立构造：分别求传播子幂、building block、ISP 和顶点相位的导数，再解出 `partial/partial sij`。顶点能量参数直接按相位乘积法则求导。
