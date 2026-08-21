# MadStree v0.15 独立验证任务书

对象：`versions/MadStree-v0.15/` 当前源码。验证程序不得调用 MadStree 生产结果作为 expected，运行前删除本 case 的旧 `results/`、`results_temp/` 和报告后 fresh 计算。

## Validation-01：零外腿辅助能量

选择一个含 massless edge 的两顶点图，使一个顶点分别省略 `externalLegEnergy` 和显式输入 0。独立检查：

1. 两种输入的 master 顺序、解析 dlog 和 digest 完全一致；
2. 解析 dlog 保留确定性的私有辅助坐标，但公开 `pointSequence` 和 `ParameterRules` 不要求用户输入；
3. 边界从非零阻尼 anchor 出发并实际输运到辅助坐标 0；两种输入的物理点结果逐分量一致；
4. 报告实际边界点、用户点、FlintNDE 节点、wall time、主/参考阶差及结果路径。

## Validation-02：有限奇点终点分类

使用相互独立的 exact 一维 dlog 模型覆盖 removable、true pole 和零阶 log divergence。分别检查数值、文本 `Infinity`、逐分量分类及 `singularityClassifications` 表互相一致；不得用绕行点值冒充奇点值。

## Validation-03：Automatic 奇点双侧 bucket 与末端隐藏匹配

以 `SingularityMode -> "Automatic"` 构造“奇点前普通点、奇点、奇点收敛域内多个用户点、奇点后 continuation 点”的同一复仿射序列。要求精确奇点不进入普通节点，局部基只使用必要的入射/出射匹配点，其余近奇点用户点由同一奇点解输出；真实 pole 的用户值为文本 `Infinity`，分类表保留原始 userIndex，最后普通点继续得到闭式值。记录每点归属、收敛半径、节点数，并与 naive 逐点局部求值逐分量互检和比较 wall time。

再构造末端奇点且前一普通点位于局部收敛圆外，检查 MadStree 只消费 FlintNDE 给出的隐藏匹配计划，低阶主链给出最终值，高阶参考链仅做误差核验。`FlintNDEPathPlanning -> False` 的中间奇点和需隐藏末端匹配点必须明确拒绝；奇点位于下一复仿射段转向处时必须以分支不唯一 fail closed。

机器 summary 至少保存：原始 `pointSequence`、userIndex、实际节点、每点 assignment/source、奇点分类表、收敛半径、隐藏匹配点、主/参考阶、逐点误差、planned/naive wall time、后续普通点闭式误差及所有反例状态。

## 交付

每项验证单独放入 `independent-validation/MadStree-v0.15-validation-NN-.../`，自动生成 `000_...report.md` 和轻量机器可读 summary。报告遵守子项目 `AGENTS.md` 中的路径、节点、精度、计时和 fail-closed 合同。
