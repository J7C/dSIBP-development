# 微分方程和矩阵

## 三类证据必须区分

| 层次 | 已提供资料 | 可以核对的内容 |
|---|---|---|
| 论文一般定义 | `definitions/paper_excerpts/` 及固定提交链接 | 积分、端点、接触平均与参数；不是实际运行矩阵 |
| 本次包生成的系统 | `generated/{pp,pm,mp,mm}_formula.wl`，各分支目录 `dlog_de.wl`、`masters.wl`、`recurrence_metadata.wl`、`manifest.wl` | 完整符号 dlog 字母、对应矩阵、基底及接触块；由原运行保存 |
| 成功送入后端的请求 | 四份原始 `i-*.json` **缺失** | 不能逐字核对成功请求的仿射 letters、序列化边界矩阵及权重 |

此外，成功运行 `result.boundary.singularConnection` 和 `singularResidue` **确实已保存**，本目录 `boundary/` 是从该字段直接提取的完整矩阵。它们不是本轮重新生成的系统，但也不能冒称是已找回的后端 JSON。

## 方程、排列和索引

原生记录明确使用列向量约定 `Y'=A(s)Y`。生成的多变量系统为

\[
dY=\sum_\ell M_\ell\,d\log L_\ell\,Y.
\]

`kinematicSymbols={k1,k2,x1,x2}`，`a1,a2` 为参数。`dlog_de.wl` 的 `letters` 与 `letterMatrices` 逐项对应；`omegaPotential` 是 dlog 势矩阵，沿曲线求导产生连接矩阵。原文件还包含 `dlogResidual` 及包自己的 `certifiedByFormulaChecks` 等标志；这些标志不等于外部独立验证。

- pp/mm：22×22，17 个生成字母，扇区顺序 `11,01,10`，分块维数 `16,3,3`。
- pm/mp：16×16，10 个生成字母，仅 `11`。
- 行 i 表示 `dY_i`，列 j 表示右端 `Y_j` 的系数。排列与 `masters.wl` / `definitions/basis_index.json` 一致。Wolfram 从 1 编号，后端 JSON 从 0 编号。
- `masterDigest` 在生成 manifest、结果、边界和后端输出中逐支一致。pp/mm 共享一种基底摘要，pm/mp 共享另一种；**摘要相同不代表分支边界或物理结果相同**。

## 本次路径的物理变量对应

用 `t_b` 表示边界局部参数，避免与积分时间 `t=-tau` 混淆。四支均保存

\[
k_1(t_b)=196i\sigma_1/t_b^2,\qquad k_2(t_b)=14i\sigma_2/t_b,
\quad t_b:0\to1.
\]

`boundary/*_singularConnection.wl` 即 `dY/dt_b=A_b(t_b)Y` 中的连接矩阵；原变量分别是 pp `msBoundaryT11`、pm `msBoundaryT14`、mp `msBoundaryT17`、mm `msBoundaryT20`。`singularResidue` 是保存的局部留数。矩阵内已经代入本次的参数规则和 x2 有理近似。

到达锚点后，原结果保留两段仿射映射：

1. `s:0→1`，`k_j(s)=k_j(anchor)+s*(-10-k_j(anchor))`，将每支自己的复锚点连接到 `(-10,-10)`。
2. `s:0→1`，`k1=k2=-10+(36/5)s`。因此物理 `rho=10-(36/5)s`，保存点 rho=10、5、14/5 对应 s=0、25/36、1。这里是说明已有端点的线性换算，不是新增物理计算或新路径规划。

后端保存的全部实际节点、点分配和绕行信息见 `boundaries/path_records.json` 与 `results/backend_outputs/`。不能用直线路径描述代替真实节点列表。原生段号 1、2 对应后端段号 0、1。

按照固定提交 `FlintNDE.wl` 的 `msAffineLetterData`，沿仿射路径的字母写成 `alpha+beta*s`；相应系统为 `A(s)=sum M*beta/(alpha+beta*s)`。Python `_letters_to_system` 用极点 `-alpha/beta` 及 residue 建立输运系统。**这里说明的是固定源码的转换规则；缺失的成功 JSON 未在本轮重建。**

## 独立性边界

本次没有独立推导并逐项验证 22×22 或 16×16 的 DE。自行编写的参考程序直接计算 `J0000` 时间积分，既不导入 MadStree，也不导入 FlintNDE。这为少量物理积分提供外部数值对照，不能推广为整套 DE、全部基底分量或接触块均已独立验证。
