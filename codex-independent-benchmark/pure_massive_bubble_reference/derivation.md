# pure_massive_bubble_reference 推导

seed EOM/contact 分别使用独立推导的 direct-h 与 bare-H 原子。H-to-h 使用 `T_Htoh={{x^-nu,0},{-nu x^(-nu-1),x^-nu}}`，从裸 H 的 `P,Q,W` 得到与 direct-h 相同的 `AT/WT/shrinkTerms`。两条平行 full lines 的 common-theta 只允许 single shrink，故无 `e1_e2`。动量反解是 `q^2=D1`、`k.q=(s11+D1-D2)/2`。

reference `Vpm=0` 是 `--`。令 `E1=E2=i k0`，则 `partial_k0` 对 top 分别产生两个 `a+1`，对 merged R1 产生系数 2；`partial_ks=2ks partial_s11`。R2 先交换 line slots 到 R1；line exchange 后再做 vertex exchange，R1 单独做 endpoint sort；完整乘积法则结果最后统一 canonical。parity 条件直接按 reference 的两条偶性约束实现。
