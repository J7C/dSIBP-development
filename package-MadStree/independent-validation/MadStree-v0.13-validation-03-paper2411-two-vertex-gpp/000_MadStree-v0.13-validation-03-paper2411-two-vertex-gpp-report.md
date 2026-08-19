# MadStree v0.13 独立检验报告：论文两顶点 massive G++

## 状态

- 状态：`passed`
- 通过：`16/16`
- 范围：只运行 2411.03088 Sec. 4 两顶点 G++ targeted validation；未运行全量回归。
- 论文级数/超几何 oracle 只存在独立验证目录，不是 MadStree 程序包功能；未使用 NIntegrate。

## 核心证据

- master 顺序：`{I00,I01,I10,I11,IR}`；package 记录见 `results/summary.wl`。
- 三个 exact 5x5 DE 非零差值数：`<|k12 -> 0, k34 -> 0, ks -> 0|>`。
- 五个边界 coefficient residual：`{0, 0, 0, 0, 0}`。
- child 边界 ratio（package/paper）：`1`。
- 论文级数 cutoff 30/42 最大变化：`3.346264317775406849800736121333309012534758877183141362504715376964842727959617744425381947`77.40974446089746*^-25`。
- 论文级数代入五维 DE 最大 residual：`2.259485321593640954017119700963016640658579194`35.2047516708083*^-32`。
- 普通点五分量最大相对差：`2.710388771436485636846374044664060037931103718081316336899351885053620919169484998958056`69.6660680087195*^-28`。
- child 普通点相对差：`1.2947738387242684134338094933987121240628796445230999`35.44468820837538*^-63`；ratio：`1.00000000000000000000000000000000000000000000000000000000000000129477383872426841343380949339871212406287964453963`97.86279659918338 - 6.00466900441902421290258`6.660695826787759*^-92*I`。

## 点、精度与耗时

- 点：`{k12 -> 30, k34 -> 6, ks -> 1, nu0 -> 2, nu1 -> 1/5}`；`x=1/5, y=1/6`，位于论文级数收敛域内且不跨复幂 branch cut。
- 工作精度：`100`；边界阶：`42`；输运阶：`144/184`；目标相对误差：`1e-30`。
- 边界/论文级数/输运/总 wall time（秒）：`{0.0927758, 0.0293715, 8.3072667, 10.210039`8.460572394491056}`。

## 检查项

- `paperHash`：PASS
- `referenceCodeHash`：PASS
- `referenceCodeResidual`：PASS
- `fiveMastersPaperOrder`：PASS
- `exactDE`：PASS
- `boundaryGenerated`：PASS
- `fiveBoundaryCoefficients`：PASS
- `contactLeadingVector`：PASS
- `childNormalization`：PASS
- `childBoundaryRatio`：PASS
- `paperSeriesConvergence`：PASS
- `paperSeriesDE`：PASS
- `transportComputed`：PASS
- `transportRefinement`：PASS
- `fullOrdinaryPointValue`：PASS
- `childOrdinaryPointValue`：PASS

机器证据：`results/summary.wl`。运行临时目录已清理。
