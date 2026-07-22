# bare-H 与 H-to-h 的独立推导

## 一阶系统

裸 Hankel 函数满足

```text
H''+(1/x)H'+(1-nu^2/x^2)H=0,
A_H={{0,1},{-1+nu^2/x^2,-1/x}}.
```

定义 `h=x^(-nu)H`，并都使用导数基底 `{function,partial_x function}`，则

```text
{h,h'}^T = T_Htoh {H,H'}^T,
T_Htoh=x^(-nu) {{1,0},{-nu/x,1}}.
```

对变量依赖基变换，一阶系统必须包含连接项

```text
A_T=T'.Inverse[T]+T.A_H.Inverse[T].
```

直接化简得到

```text
A_T={{0,1},{-1,-(2nu+1)/x}},
```

正是从 `h=x^(-nu)H` 直接二次求导得到的 h 系统。

## Wronskian 与 shrink

对任意二维基变换，反对称双线性型满足

```text
T.epsilon.Transpose[T]=Det[T] epsilon,
epsilon={{0,1},{-1,0}}.
```

这里 `Det[T]=x^(-2nu)`。裸 H Wronskian与 `x^-1` 成正比，故变换后 `WT=Det[T] W_H` 与 `x^(-2nu-1)` 成正比，完全等于直接 h 的 Wronskian。于是 complementary endpoint states 的 contact、shrink integer shift、zero-point shift 和显式能量幂也逐项相同。

## 全 seed 覆盖为何由矩阵恒等保证

`atomic_massive_line` 的 top 离散基底有两个 endpoint slots，共 `2^2=4` 个状态；`pure_massive_bubble_reference` 有四个 endpoint slots，共 `2^4=16` 个状态。每个 time/momentum generator 都是局部一阶矩阵在某个 slot 的 tensor lift，再加标量幂和相位项。`A_T=A_h` 对每个 slot 成立，因此它们在完整 4 维和 16 维离散空间的算符矩阵严格相等；这不是抽样。contact 部分则由上面的反对称双线性型恒等式逐线成立，共同-theta 的多线项按乘积继续成立。

bare-H `T=I` 使用 `A_H,W_H`，只和 bare-H 独立 expected 比较；它不能不经 `T_Htoh` 直接与 h 的 `J` 关系相减。
