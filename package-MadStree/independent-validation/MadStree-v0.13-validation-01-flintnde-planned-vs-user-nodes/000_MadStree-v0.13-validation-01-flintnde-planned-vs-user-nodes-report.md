# MadStree v0.13 独立验证 01：FlintNDE 自动规划与严格用户节点

- 日期：2026-08-19
- 状态：`passed`（18/18）
- Git baseline commit（运行时工作树源码由下列 SHA-256 标识）：`508e92e09be7c0d41f54181b8d60b6d2a65b3f76`
- MadStree kernel/numerical module/adapter/FlintNDE tree/validation runner SHA-256：`e7c56e608a452a687855baea7adb993223ab5c9aae7869c8e93237b318ad2982` / `19fe6be952f3ee6f63eb3ce07ffea6335844d881b96025dfb6b48339ece6d386` / `23ff5339311f64ba3cf90609e66bb81fa7297ef0bc94eeb1e2cc39b65d7efe20` / `b2bc47242995e783a1915c1d0d9130223b0b350f9acd1a5dbfc268e745dd5c25` / `0cda8cca5f4525d6f5cdf4b17eba2b9a41860326dd656da5e18ba4f3c8ed1b81`。
- 约定：`Y'=A(s)Y`；master/normalization 见 `results/summary.wl`；boundaryKind=`singularFrobenius`，seriesOrder=24，Hankel branch=`HankelH[1|2] and h prefactor fixed by initialized context`。
- master 顺序：`{<|"sectorKey" -> "1", "sectorOffset" -> 1, "globalIndex" -> 1, "stateBits" -> {0}, "integral" -> MSIntegral["1", {0, 0}, {0}], "normalization" -> 1|>, <|"sectorKey" -> "1", "sectorOffset" -> 1, "globalIndex" -> 2, "stateBits" -> {1}, "integral" -> MSIntegral["1", {0, 0}, {1}], "normalization" -> 1|>, <|"sectorKey" -> "0", "sectorOffset" -> 3, "globalIndex" -> 3, "stateBits" -> {}, "integral" -> MSIntegral["0", {0}, {}], "normalization" -> 1|>}`；normalization：`{1, 1, 1}`。

## 输入与职责边界

runner 在数值计算前删除本任务旧 `results/`、`results_temp/` 和旧报告；删除失败会直接退出。运行根固定为验证目录下唯一的 `results_temp/`，不读取仓库根旧 runtime。

exact 900 点：`k1=+900 I+a/10`、`k2=+30 I+n/10+I m/10`、`q=1,a1=a2=1`，a/n/m 顺序。工作精度 40 位，边界和普通点输运主/参考阶 64/88，目标相对误差 `1e-18`。共同 BoundaryScale=15、seriesOrder=24；阻尼基数 30 给出 matching anchor `k1=+900 I,k2=+30 I`。exact 拉回极点预审的最大 `step/nearest-pole-distance=0.3183863423793468<0.60`；Route B 的正式成功执行和实际节点链构成黑盒复核。全部用户点避开 dlog 奇点；边界是正则奇点 Frobenius 起点，实际 transformed boundary path、convergenceRatio 和 physical anchor 见 JSON。

MadStree 实际只返回 5 个 maximal 复仿射拉回段（300/2/300/2/300 用户记录）；外层 segment 无 `actualNodes` 或 `nodeCount`。所有节点链只存在于 FlintNDE 返回字段，因此 MadStree 本身未规划节点。A/B 使用相同 Python executable，各自在一个 cold adapter 进程内同时完成同一边界初始化和全部段。
边界 transformed `t` 路径 A=`{<|"real" -> "0.3333333333333333333333333333333333333333", "imag" -> "0", "real_ball" -> <|"midpoint" -> "333333333333333333333333333333333333333333333", "radius" -> "2", "exponent" -> -45|>, "imag_ball" -> <|"midpoint" -> "0", "radius" -> "0", "exponent" -> 0|>|>, <|"real" -> "0.4833333333333333333333333333333333333333", "imag" -> "0", "real_ball" -> <|"midpoint" -> "483333333333333333333333333333333333333333333", "radius" -> "2", "exponent" -> -45|>, "imag_ball" -> <|"midpoint" -> "0", "radius" -> "0", "exponent" -> 0|>|>, <|"real" -> "0.7008333333333333333333333333333333333333", "imag" -> "0", "real_ball" -> <|"midpoint" -> "700833333333333333333333333333333333333333333", "radius" -> "2", "exponent" -> -45|>, "imag_ball" -> <|"midpoint" -> "0", "radius" -> "0", "exponent" -> 0|>|>, <|"real" -> "1.000000000000000000000000000000000000000", "imag" -> "0", "real_ball" -> <|"midpoint" -> "100000000000000000000000000000000000000000000", "radius" -> "0", "exponent" -> -44|>, "imag_ball" -> <|"midpoint" -> "0", "radius" -> "0", "exponent" -> 0|>|>}`，B=`{<|"real" -> "0.3333333333333333333333333333333333333333", "imag" -> "0", "real_ball" -> <|"midpoint" -> "333333333333333333333333333333333333333333333", "radius" -> "2", "exponent" -> -45|>, "imag_ball" -> <|"midpoint" -> "0", "radius" -> "0", "exponent" -> 0|>|>, <|"real" -> "0.4833333333333333333333333333333333333333", "imag" -> "0", "real_ball" -> <|"midpoint" -> "483333333333333333333333333333333333333333333", "radius" -> "2", "exponent" -> -45|>, "imag_ball" -> <|"midpoint" -> "0", "radius" -> "0", "exponent" -> 0|>|>, <|"real" -> "0.7008333333333333333333333333333333333333", "imag" -> "0", "real_ball" -> <|"midpoint" -> "700833333333333333333333333333333333333333333", "radius" -> "2", "exponent" -> -45|>, "imag_ball" -> <|"midpoint" -> "0", "radius" -> "0", "exponent" -> 0|>|>, <|"real" -> "1.000000000000000000000000000000000000000", "imag" -> "0", "real_ball" -> <|"midpoint" -> "100000000000000000000000000000000000000000000", "radius" -> "0", "exponent" -> -44|>, "imag_ball" -> <|"midpoint" -> "0", "radius" -> "0", "exponent" -> 0|>|>}`；两者均从同一正则奇点 Frobenius 数据输运至 `t=1` 的 physical anchor `k1=+900 I,k2=+30 I`。

| segment | userIndex | physical start | physical target | nodes A/B | dense A/B |
| ---: | --- | --- | --- | ---: | ---: |
| 1 | 1--300 | `{k1 -> 900*I, k2 -> 30*I, q -> 1, a1 -> 1, a2 -> 1}` | `{k1 -> 900*I, k2 -> 99/10 + (151*I)/5, q -> 1, a1 -> 1, a2 -> 1}` | 3 / 301 | 298 / 0 |
| 2 | 300--301 | `{k1 -> 900*I, k2 -> 99/10 + (151*I)/5, q -> 1, a1 -> 1, a2 -> 1}` | `{k1 -> 1/10 + 900*I, k2 -> 30*I, q -> 1, a1 -> 1, a2 -> 1}` | 3 / 3 | 1 / 0 |
| 3 | 301--600 | `{k1 -> 1/10 + 900*I, k2 -> 30*I, q -> 1, a1 -> 1, a2 -> 1}` | `{k1 -> 1/10 + 900*I, k2 -> 99/10 + (151*I)/5, q -> 1, a1 -> 1, a2 -> 1}` | 3 / 301 | 298 / 0 |
| 4 | 600--601 | `{k1 -> 1/10 + 900*I, k2 -> 99/10 + (151*I)/5, q -> 1, a1 -> 1, a2 -> 1}` | `{k1 -> 1/5 + 900*I, k2 -> 30*I, q -> 1, a1 -> 1, a2 -> 1}` | 3 / 3 | 1 / 0 |
| 5 | 601--900 | `{k1 -> 1/5 + 900*I, k2 -> 30*I, q -> 1, a1 -> 1, a2 -> 1}` | `{k1 -> 1/5 + 900*I, k2 -> 99/10 + (151*I)/5, q -> 1, a1 -> 1, a2 -> 1}` | 3 / 301 | 298 / 0 |

完整 A/B 参数节点链、逐段 refinement 和 certification mode 位于 `results/evidence.json`。Route A coverage min/median/mean/max = 1./1./64.2857/203.，histogram=`<|"203" -> 1, "1" -> 8, "95" -> 3, "202" -> 2|>`。算法计数 A=`<|"fast" -> 894, "node" -> 8, "iter" -> 2|>`，B=`<|"node" -> 904|>`。
Route A 的 assignment bucket、覆盖用户索引和算法逐桶保存在 JSON。`fast` bucket 数=6，最小桶规模=95。当前 Vendor `flintnde/transport.py` 对不少于 8 点的同节点覆盖桶调用 FLINT `acb_poly.evaluate(deltas, algorithm="fast")`，即子积树/余数树快速多点求值；Wolfram 只提交点列并读取后端结果，没有逐点计算这些值。

## 耗时（秒）

| route | boundary | planning | primary | reference | backend-only | end-to-end |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| A planning=True | 0.77516 | 0.018418 | 0.0660671 | 0.0872648 | 0.94691 | 2.2705 |
| B planning=False | 0.755394 | 0.0144693 | 1.36908 | 2.22051 | 4.35946 | 5.51271 |

A/B end-to-end ratio=`0.411866x`；backend-only ratio=`0.217208x`。等价地，本次 Route A 比 Route B 的 end-to-end 约快 `2.42798x`，backend-only 约快 `4.60388x`。性能结论只适用于本系统、点序、精度与本次 fresh 运行。

## 数值互检与结论

全部 900 点 × 3 masters 逐分量互检；最大绝对差=`3.827350668350548054`8.287488625279325*^-40`，最大相对差=`2.807514799941868386854795483`8.281717248175553*^-31`。两路线全部 refinement gate 通过，A/B 均 cacheHit=False、单一 Python process ExitCode=0。

本任务通过。
