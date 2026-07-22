# Pure-time/tree 独立推导

## 公开来源

使用 arXiv:2401.00129 的 Eq. (3.33)、(3.37)、(3.44)--(3.50)、(3.54)--(3.55) 与 (3.64)--(3.66)。PDF 下载副本只放在 `results_temp/papers/`，不作为正式产物。

## 单顶点 n-fold h family

对

```text
V(nu0,a1,...,an)=Integral tau^nu0 Exp[i k0 tau]
                  Product[h(nui,ai;-ki tau),i] d tau,
ai in {0,1},
```

master 按 `j=1+Sum[ai 2^(n-i),i]` 排序，故 Mathematica 的 `Tuples[{0,1},n]` 恰好保持最后一个 bit 最快。

令 `Lambda_r^(j)` 表示只在第 `j` 个二维因子上放 Pauli `sigma_r`。time total derivative 给出

```text
M1(nu0) f(-1)+M0 f(0)=0,
M1=Sum[(nui+1/2)Lambda3^(i),i]
   +(nu0-n/2-Sum[nui,i]) I,
M0=-i Sum[ki Lambda2^(i),i]+i k0 I.
```

所以 `Aminus(nu0)=-Inverse[M1].M0`。用论文 Eq. (3.44) 的常矩阵 `T` 对每个 bit 做直积后，得到对角的 `Mtilde0` 和 Eq. (3.50) 的 `Aplus`。`expected.wl` 对 `n=1,2` 直接检查 Eq. (3.53) 与由 Eq. (3.54)--(3.55) 构造的 dlog connection 的导数严格一致。

## 两顶点与三顶点 chain

两顶点 `++` case 的两个顶点各有一个 h endpoint，离散态总数为 `2^2=4`；两个 active time generators 给出 `8` 条 top seed。三顶点 `{+,+,-}` chain 的 massive leg 数为 `{1,2,1}`，离散态总数为 `2^4=16`；三个 active time generators给出 `48` 条 top seed。边 `(v1,v2)` 是 `G++`，边 `(v2,v3)` 是完整 `G+-`；后者没有 theta，因此其 contact source 恒为零。

对 `G++`，Eq. (3.65) 的 contact 只在两个端点态互补时非零。以第一端点态 `a` 表示，系数为

```text
delta[a,1-b] (-1)^(a+1) (4 i/pi) Exp[pi Im[nu]]
(-k)^(-2nu-1).
```

合并后的连续时间指标为两端完整物理幂之和再减 `2nu+1`；这同时固定了 tree `nu0` 与显式 `(-k)^(-2nu-1)`，不能只保留整数 `k^-1`。

## 三条平行 massive h

共同 theta bundle 是

```text
theta(Delta) Product[WGreater[e],e]
+theta(-Delta) Product[WLess[e],e].
```

theta 导数只涉及两个完整乘积之差。对任意 `N` 条线，代数恒等式

```text
Product[a_i]-Product[b_i]
=2^(1-N) Sum_{|S| odd}
  Product[a_i-b_i,i in S] Product[a_j+b_j,j not in S]
```

说明 `N=3` 时只出现三个 single subsets 和一个 triple subset，不出现任何 even subset。每个差因子携带该线自己的 Wronskian及 `(-k_i)^(-2nu_i-1)`，所以 triple 项的显式能量因子是三条线因子的乘积。混合 branch 中每条传播子的两个端点分别为 `+/-`，故三条线都是完整 `G+-`，不能把同一条线拆成 full/cross 部分；因此没有 theta、`WT` 或 shrink source。
