# Npackage OOO-232 16x16 NDE 交叉检查

`check_01_nde_npackage_16x16.py` 在同一个 `epsilon=1/997` 样本上构造共同的 OOO-232
kECep 16 维系统、Watson 边界与路径。Npackage 使用 pole/residue 直接 Taylor 公式，
FlintNDE 使用一般矩阵的 Cauchy-DFT 系数重建；检查比较三个匹配点的完整 16 分量端点向量。

检查不执行局部 scalar contraction、epsilon 重构、Step4 或 `Rhat` 装配。正式轻量结果保存到
`results/check_01_nde_npackage_16x16_summary.json`。
