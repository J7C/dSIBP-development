# Omegatau 输出说明

本目录用于保存 `codebubble/000_DE_bubble_tau.m` 生成的 **时间积分（tau-side）** 符号微分方程数据，以及相关验证脚本。

## 主要输出文件

- `OmegaFolded.m`
  - 折叠 `R2 -> R1` 后的完整 tau-side 微分方程矩阵。
  - 维度为 `20 x 20`。
  - 保持符号形式，内部保留 `log[...]`，**不**转成 `Log[...]`。
  - 行/列顺序与 `MIstau.m` 严格一致。

- `MIstau.m`
  - 与 `OmegaFolded.m` 行/列顺序一一对应的 20 个主积分。
  - 前 16 个为 top sector 的 `G[{n1,n2,n3,n4},{0,0},{0,0}]`。
  - 后 4 个为折叠后 `R1[{n3,n4},{0},{0,0}]`。
  - **注意**：这里的排序是 tau-side 矩阵排序，**不是** `bubble_ibp_sym.m` 中 dlog/Kira 的排序。

## 生成脚本

- `generate_Omegatau.m`
  - 作为单独入口运行。
  - 其作用只是调用 `../000_DE_bubble_tau.m`，并把当前目录固定在 `codebubble` 下。

- `validate_TopToR1_against_dsdeppsol.m`
  - 用于验证 bubble 中的余项耦合构造逻辑。
  - 具体验证两件事：
    1. 用通用 contracted-two-vertex 余项生成代码重建 bubble 的 `Top -> R1` 余项块，并与当前 bubble 实现比较。
    2. 用同一套通用代码生成 `ref-de-code/000_dsdeppsol.m` 中树图两顶点缩并得到的一顶点 `4 x 1` 余项微分方程，并与参考文件中先前生成的结果比较。

## 约定

- 所有输出都保持**符号形式**。
- 不做任何 `nu/ep/k0/ks` 数值替换。
- 命名中的 `pp` 表示这里考虑的是 `++` 顶点情形；不再使用容易混淆的 `pm` 命名。
- 若后续需要 `OmegaCoeff` / `OmegaLogArgs` 等分解文件，可按需再生成；当前目录默认不导出这些文件。
