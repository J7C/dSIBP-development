# mixed_triangle 推导

每条边单独形成 theta bundle。第一次 contact 合并一对顶点；在全同分支下，余下两条边成为同一代表顶点对的二线 bundle，只允许 odd single selection，因此得到三种两边 forest 而没有三边 cycle。massless line 3 始终以 `v3->v1` 定向，不能按顶点编号翻转。

scalar-product 反解为

```text
q^2=D1,
k1.q=(s11+D1-D2)/2,
k2.q=(-s22-D1+D3)/2.
```

这闭合 `d/dq.q`、`d/dq.k1`、`d/dq.k2`。外不变量导数按任务书正式 convention，以 upper-triangular `{D11,D12,D22}` 反解 `partial_s11,partial_s12,partial_s22`；该选择 residual 为零，重生后 package 对照为 27/27。
