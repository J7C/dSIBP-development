# FlintNDE 0.5.0 Validation-01 独立报告

- 状态：**passed**，14/14。
- 当前 Python 源码聚合 SHA-256：`39b0e7956a400faa9bf219ca2d2c81bbb599cc0583f4fe2f58ad5d43142b0225`。
- wall time：`0.054462000 s`。
- 工作精度/局部阶/目标误差：`90 / 64 / 1e-25`。

## 独立模型与结果

- removable：闭式 `y=x`，目标极限为 0；返回 Acb，分类为 `removable_singularity`。
- true pole：闭式 `y=1/x`；返回文本 `Infinity`，分类为 `true_pole`。
- zero-order log：闭式 `(log(x),1)`；第一分量返回文本 `Infinity`，第二分量返回 Acb 1。
- 三个系统均保存五级趋近样本、局部基方法、局部阶和逐分量 magnitude；bridge round-trip
  保持 `{text: Infinity}` 与 Acb 中点/半径记录为不同类型。

## 误差与产物

- removable 对闭式极限的绝对误差球：`[5.0000000000000000000000000000000000000000000000000e-25 +/- 3e-79]`。
- log 有限分量对 1 的绝对误差球：`0`。
- 机器 summary：`results/summary.json`。
- 失败项：`无`。
- 本 case 不认证上游物理 DE、master 顺序或 normalization。
