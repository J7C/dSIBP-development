# ds total derivative

本目录冻结 `ds[expr,sij]` 的独立手推输入与 expected。参考实现来自：

- `reference/ref_code/codebubble/001 bubble_ibp_sym.m` 的 `dks[expr_] := D[expr,ks] + ...`；
- `reference/ref_code/codebubble/002 bubble_de.m` 在代入数值规则前保留 `ks/k0` 符号，以免丢掉显式系数导数。

测试 family 使用外部变量 `s11`，顶点相位能量为 `Sqrt[s11]`。传播子动量 `ell` 不含外动量，ISP 指数固定为零，因此单积分导数只有

```text
d J[a,b,0] / d s11 = i/(2 sqrt(s11)) J[a+1,b,0].
```

`expected.wl` 再独立应用普通乘积法则，覆盖单个积分、带系数积分、两个积分的线性组合与纯系数项；它不调用主线 `ds`、`applyIndependentVariableDerivativeSeed` 或指标移位 helper。
