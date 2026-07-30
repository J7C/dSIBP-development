# 013 pure time-IBP/tree 独立推导

## 来源与隔离

手推只使用任务书第 2、3、5、6、14 节和公开论文 arXiv:2401.00129：

- Eq. (3.33)：binary master 顺序；
- Eq. (3.37)：`M1/M0`；
- Eq. (3.47)、(3.50)：`A-/A+`；
- Eq. (3.54)--(3.55)：dlog connection；
- 论文第 3.7 节：`G++` 的 lower-sector source。

下载的 arXiv 源归档 SHA-256 为
`BCE77FD9F48F65A2174B8384B8C168B63A444ABB3B8F522E7EE29AD8358CE5AB`。

阶段 1 没有读取 013 package、主线代码、项目 note、旧 expected/check/results/report。

## h 一阶系统

令 `x=-k tau`，`h0=x^(-nu) H_nu(x)`，`h1=partial_x h0`。由标准 Hankel
方程

```text
x^2 H'' + x H' + (x^2-nu^2) H = 0
```

直接代入得

```text
h0'' + (2 nu+1)/x h0' + h0 = 0.
```

因此

```text
partial_tau h0 = -k h1,
partial_tau h1 = k h0 - (2 nu+1)/tau h1.
```

记 `d=2 nu+1`。对一个含 `p` 个 h 因子的 tree vertex

```text
V(mu,n) = integral tau^mu exp(i k0 tau) Product[h(nj;-kj tau),j] d tau
```

逐项求导给出

```text
0 = (mu-Sum[nj dj]) V(mu-1,n)
    + i k0 V(mu,n)
    + Sum[kj (2 nj-1) V(mu,Toggle[n,j]),j].
```

以最后一个 bit 变化最快的 binary 顺序排列，得到

```text
M1 = Sum[(nuj+1/2) Lambda3[j],j]
     +(mu-p/2-Sum[nuj]) IdentityMatrix[2^p],
M0 = -i Sum[kj Lambda2[j],j] + i k0 IdentityMatrix[2^p].
```

`M1` 的第 `n` 个对角元正是 `mu-Sum[nj(2nuj+1)]`。

## loop time seed

任务书的 loop 被积函数使用 `(-tau)^A exp(-i s E tau)`。对 active vertex `v`
和它的各 massive h endpoint bit `nj`，regular 部分为

```text
(-Av + Sum[nj dj]) J_loop[av-1]
- i sv Ev J_loop[av]
+ Sum[kj (2 nj-1) J_loop[Toggle[nj]],j].
```

这里 `Av=av+a0v`，并且只调用 `dtau`。两 case 均不生成、调用或消费
`dqq/dqk`。

## G++ contact 与 G+- guard

对有序端点 `(u,v)`，

```text
G++ = theta(tauu-tauv) WGreater + theta(tauv-tauu) WLess.
```

对第一端点求导的分布项为 `delta(tauu-tauv)(WGreater-WLess)`；第二端点
符号相反。coincidence 时 `(nu,nv)=(0,0),(1,1)` 为零，而

```text
(1,0): +F(x),
(0,1): -F(x),
F(x)=h1^(1) h0^(2)-h1^(2) h0^(1).
```

标准 Hankel Wronskian

```text
Hnu^(1) d_x Hnu^(2) - d_x Hnu^(1) Hnu^(2) = -4 i/(pi x)
```

结合 `h=x^(-nu)H`（以及纯虚 `nu` 的任务书 conjugation convention）得

```text
F(x)=Cnu x^(-2 nu-1),
Cnu=(4 i/pi) Exp[pi Im(nu)].
```

所以第一端点的 contact 系数是 `(nuBit-nvBit) Cnu`，第二端点是其相反数。
`G+-=WLess` 不含 theta，故它的 contact、shrink、`WT` 消费均严格为零。

## zero-point 与 loop -> tree 投影

对 top loop seed 定义

```text
Ptop = (-1)^Sum[Av] Product[kj^(-Bj),j],
Av=av+a0v,  Bj=bj+b0j.
```

这是从 `(-tau)^A` 改写成论文 tree 的 `tau^mu` 以及显式提出 line 能量幂的
完整 prefactor。降低一个 `a` 后 `Ptarget/Ptop=-1`，故 loop regular seed 的
`-Av+Sum[nj dj]` 投影后变为论文矩阵中的 `Av-Sum[nj dj]`。

对 h contact，`d=2nu+1`。loop sector 的机械整数/zero-point 分解为

```text
bS=b+1,        bS0=b0+2nu,
aMerged=au+av-1,
a0Merged=a0u+a0v-2nu.
```

其 tree prefactor 是

```text
Pcontact=(-1)^(Au+Av-d) k^(-(B+d))
```

（再乘其它未缩并线的 prefactor）。因此相对 top reference seed

```text
Pcontact/Ptop = (-1)^(-d) k^(-d) = (-k)^(-2nu-1).
```

这保留了 `a0`、`b0/bS0` 对绝对 prefactor 的贡献，并给出完整 h contact
能量幂；不是仅保留整数部分的 `k^-1`。

## 两个固定 family 的 general seed

令 `D12=2nu12+1`、`D23=2nu23+1`，`C12=(4i/pi)Exp[pi Im(nu12)]`。

### 两顶点 `++`

tree top 为 `J[{{A1,n11},{A2,n21}}]`。对 `v1`：

```text
0=(A1-n11 D12) J[{{A1-1,n11},{A2,n21}}]
  -i E1 J[{{A1,n11},{A2,n21}}]
  +k12(2n11-1) J[{{A1,1-n11},{A2,n21}}]
  +(n11-n21) C12 (-k12)^(-D12) J[{{A1+A2-D12}}].
```

`v2` 交换 `1<->2`，contact 系数为 `(n21-n11)`。

### 三顶点 `++-`

tree top 为 `J[{{A1,n11},{A2,n21,n22},{A3,n31}}]`。三个 regular seed 的
lowered 系数分别为

```text
A1-n11 D12,
A2-n21 D12-n22 D23,
A3-n31 D23.
```

相位项分别为 `-iE1,-iE2,+iE3`。每个 endpoint bit 都按
`k(2n-1) Toggle[n]` 贡献 regular 项。只有 `v1/v2` 含 `(1,2)` contact，系数
分别为 `(n11-n21)` 与 `(n21-n11)`，lower sector 是

```text
C12 (-k12)^(-D12) J[{{A1+A2-D12,n22},{A3,n31}}].
```

边 `(2,3)` 是单一 `G+-`，所有 `n22,n31` 下均无 contact。

## 单步、两级迭代与 dlog

冻结的 general 单步矩阵为

```text
Aminus(mu) = -Inverse[M1(mu)] . M0,
Aplus(mu)  = -Inverse[Tp] . Inverse[M0tilde] . Tp . M1(mu+1).
```

两级下降为 `Aminus(mu-1).Aminus(mu)`，并与逐次解两组 time-IBP 线性方程
所得表达式严格比较。

设 binary state `r` 对应字母

```text
Lr = k0 + Sum[(2 rj-1) kj,j].
```

冻结 letters 顺序为 `{k1,...,kp,L00...0,...,L11...1}`。dlog connection

```text
Omega = -Sum[Diag[rj(2nuj+1)] Log[kj],j]
        -Sum[Tp^-1 Err Tp M1(mu+1) Log[Lr],r].
```

其 master 顺序与 binary state 顺序完全相同。

