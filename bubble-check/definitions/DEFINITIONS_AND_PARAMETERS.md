# 定义与参数对应

## 积分与分支

论文 `eq:bubble-indexed-masters`（原 `paper.tex` 2055–2066 行附近）定义

\[
J^{\sigma_1\sigma_2}_{abcd}=\int_{-\infty}^0d\tau_1d\tau_2\,
(-\tau_1)^{p_1}(-\tau_2)^{p_2}
e^{i(\sigma_1P_1\tau_1+\sigma_2P_2\tau_2)}
\mathcal G^{\sigma_1\sigma_2}_{\nu_1;ab}(x_1;\tau_1,\tau_2)
\mathcal G^{\sigma_1\sigma_2}_{\nu_2;cd}(x_2;\tau_1,\tau_2).
\]

线 1、2 都连接顶点 1、2，动量固定。`a,b` 为线 1 在顶点 1、2 的端点状态，`c,d` 为线 2 同顺序的端点状态。`0` 不求导，`1` 对 Hankel 自变量求导，不对阶跃函数求导。

采用 Negative 约定：`h0^(r)(z)=z^(-nu) H_nu^(r)(z)`，`h1^(r)(z)=d h0/dz=-z^(-nu)H_(nu+1)^(r)(z)`。令 `W>=h^(1)(tau1)h^(2)(tau2)`，`W<=h^(2)(tau1)h^(1)(tau2)`，则 `Gpp=theta(tau1-tau2)W>+theta(tau2-tau1)W<`，`Gmm` 交换 `W>` 与 `W<`，`Gpm=W<`，`Gmp=W>`。准确论文原文见 [端点及传播子节录](paper_excerpts/endpoint_definitions.tex.txt)。

`pp/pm/mp/mm` 对应 `(+,+)/(+,-)/(-,+)/(-,-)`。比较的是各支顶层无导数分量 `J0000`，以及 `K=-Jpp+Jpm+Jmp-Jmm`。该组合才包括两顶点的 `(i sigma1)(i sigma2)` 因子。顶层 master normalization 为 1；没有再乘树图模式因子。论文定义的归一化为 `K(rho)/K(10)`，另有图轴口径 `Re K(rho)/Re K(10), Im K(rho)/Re K(10)`，已保存比较文件将两者分开。

## 分别从程序和参考脚本提取的参数

| 量 | 原生脚本及结果 | 独立参考脚本 | 对应关系 |
|---|---|---|---|
| 顶点能量 | `k1=k2=-10,-5,-14/5` | `rho` 由字符串 `10,5,2.8` 输入 Acb | 物理 `P1=P2=rho`；原生接口指数约定对应 `k=-P` |
| 时间变量 | `tau<0`，时间幂 `(-tau)^a` | `t=-tau`，正支 `t=-i u`、负支 `t=+i u`，`u>0` | Wick 旋转后指数衰减；不能仅比较输入能量的字面正负 |
| 阶数 | 精确 `I/4`，`formulaNu=-I/4` | `acb(0,1)/4` | 物理 Hankel 阶数相同，内部公式阶数符号不同 |
| 时间幂 | 精确 `a1=a2=1+I/2` | 约去 h 前因子后使用 `u^1` 及展开幂 `1+s*nu+2*n` | `p` 已吸收模式前因子，不能再加树图幂 |
| `x1` | 精确整数 1 | `acb(1)` | 相同 |
| `x2` | `Rationalize[N[Sqrt[2],120],0]` 的精确有理数 | `acb(2).sqrt()`，按工作精度给出球包围 | 物理目标相同，实际输入表示不同，不声称严格相同 |
| 分支积分 | 四支分别运行 | 同号两排序室；异号积分因子化 | 参考实现由本次 Codex 会话编写，不是作者官方程序 |
| 固定积分诊断 | 不适用 | `direct_quadrature.py`：`mpmath sqrt(2)`，25 位计算；节点 binary64 | 只对 `rho=10,pp` 作有限精度诊断 |

原生成功结果实际记录的 `x2` 为：

```text
1504971541748894116193408501376479674908449638047395789089923 /
1064175582663416344218339243578691919603263775474584411709342
```

这是从四份 `result.parameterRules` 读取的原分子、分母。本轮没有计算该近似与 sqrt(2) 的新误差界。早期 `bubble_calibration.wls` 的精确 `Sqrt[2]` 尝试没有产生此次成功终值。

## 基底顺序与接触归一化

完整逐分量定义在 [basis_index.json](basis_index.json) 和各支原始 `masters.wl`。Wolfram `globalIndex` 从 **1** 开始；JSON 数组索引从 **0** 开始。

| 分支 | 全局分量 | 扇区 | 状态及物理含义 |
|---|---|---|---|
| 全部 | 1–16 | `11` | `0000,0001,...,1111` 的二进制字典顺序；列向量，线 1 两端在前，线 2 两端在后 |
| pp/mm | 17–19 | `01` | 夹缩线 1，保留线 2 的等时端点；`00,01,11` |
| pp/mm | 20–22 | `10` | 夹缩线 2，保留线 1 的等时端点；`00,01,11` |
| pm/mp | 无接触分量 | 仅 `11` | massiveCross 内线，无上述同号接触扇区 |

扇区位按线 `{1,2}` 排列，`0` 表示夹缩，`1` 表示保留；它不同于端点导数状态位。接触扇区的 `10` 端点状态被投影为 `01`。每次单线接触的 bundle 系数为 1，顶点只合并一次。保留线两端都属于同一时间分量。接触扇区 baseTimePower 为 `a1+a2-I/2`，代入后 `2+I/2`（以原 formula/result 字段为准）。

原公式 pp 夹缩线 e 的 normalization 为 `-4 i/(pi*x_e^(1+i/2))`，mm 符号相反。原始 `normalization`、`stateProjection`、`stateEmbedding` 和 `contactMaps` 均在公式文件中；这些是包采用的定义，不表示已独立证明其全部正确。

## 原生设置、边界及路径

`WorkingPrecision=80, TransportOrder=80, ReferenceTransportOrder=96, BoundarySeriesOrder=17, TargetRelativeError="1e-32", BoundaryScale=4, RankOrder={1,2}, SingularityMode="Avoid"`。运行目录逐支独立。`BoundarySeriesOrder=17` 是本路线保存的元数据/诊断选项，不等于已运行 17/15 两档独立物理边界计算。

边界局部参数 `t_b` 与物理时间 `t=-tau` **不是同一个变量**。保存的奇异边界在 `t_b=0`，曲线为 `k1=196 i sigma1/t_b^2, k2=14 i sigma2/t_b`；输运到 `t_b=1` 的锚点，再到实能量点。精确变量名和完整实际节点见 [path_records.json](../boundaries/path_records.json)。路径参数说明见 [方程说明](../equations/README.md)。

参考序列采用 rho=10 的 N=16/24/36、rho=5 的 N=36/52、rho=2.8 的 N=100/150/200 等已保存记录；最终对照选择 N=36,dps=100；N=52,dps=100；N=200,dps=300。各中间文件保留自己的精度和失败标志，不统一改写。
