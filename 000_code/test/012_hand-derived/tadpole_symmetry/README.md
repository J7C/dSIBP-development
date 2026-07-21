# Tadpole symmetry and derivative batch

本 benchmark 以单顶点 self-loop 为独立输入，手工固定以下结果：

- massive full 的 `{n1,n2}={1,0}` 交换为 `{0,1}`；
- massless full 的 `n=1` 反对称态为零；
- loop-reversal 下的 odd ISP 为零；
- 用户 `symmetryRules` 与自动 tadpole rules 同时保留；
- 批量独立变量导数返回 `s11` 与 `ke[1]`，其中 `s11` 方程为零，`ke[1]` 只产生顶点相位导数项。

expected.wl 只写手推目标，不调用 `tadpoleSymmetryRules0` 或批量导数生成函数。
