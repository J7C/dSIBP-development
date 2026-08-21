# MadStree v0.13 与 dSIBP 022 tree master normalization 独立交叉验证报告

- 日期：2026-08-20
- Git commit：`ea5add8e432fa4902cff9b21170a15538ce633bb`
- 版本：MadStree `0.13`；dSIBP `022.0`
- 状态：**PASS**
- wall time：1.59675 s

## 范围

本轮只调用两个当前版本的初始化与只读 master/sector metadata。未生成 IBP，未调用约化、Kira、DE、边界或数值输运；未读取两包既有 expected、测试结果或独立验证报告。

## convention 对齐

- 两边顶点、传播子输入顺序、外腿能量、时间幂和 `vertexType="+"` 相同。
- MadStree 使用正 Hankel 阶 `mu_e` 与 `NuConvention -> "Positive"`；dSIBP h preset 使用 `nu_e=-mu_e`。
- 两边都在 h basis；massless full 使用一个 shared quotient state，不做 H-to-h 变换。
- sector key 按根线顺序取 `1=active, 0=contracted`；state bits 按 massive 两端点、massless shared 的根线顺序枚举。
- 独立 identity 统一投影为 `CanonicalMaster[sectorKey,timeShifts,stateBits]`，不调用 MadStree 的跨包 adapter。
- 第 `e` 条 massive 线收缩贡献 `W_e=-(4 I/Pi) Exp[-Pi Im[mu_e]] q_e^(2 mu_e-1)`；massless full 线收缩贡献 1。
- dSIBP complete coefficient 直接由编译后的 h-system Wronskian 在固定线模长处求值；另行检查 `physicalSectorPrefactor * selector` 的拆分。
- dSIBP selector 中每条收缩 massive 线贡献 `-1/q_e`，massless 线贡献 1；该拆分逐 sector 回乘检查。

## case 汇总

| case | MadStree masters | dSIBP masters | sector order | masters per sector | status |
|---|---:|---:|---|---|---|
| 两顶点单 massive tree | 5 | 5 | `{"1", "0"}` | `{4, 1}` | PASS |
| 三顶点双 massive chain | 25 | 25 | `{"11", "01", "10", "00"}` | `{16, 4, 4, 1}` | PASS |
| 三顶点 massive+massless chain | 15 | 15 | `{"11", "01", "10", "00"}` | `{8, 2, 4, 1}` | PASS |

## 逐 sector 系数

`C_MS` 与 `C_DS` 都是同一裸积分外的完整系数；其自身可含固定传播子模长与 `mu`，对齐后比值必须为 1。

| case | sector | C_MS | C_DS | ratio | status |
|---|---|---|---|---|---|
| two_vertex_massive | `1` | `1` | `1` | `1` | PASS |
| two_vertex_massive | `0` | `((-4*I)*sE1^(-1 + 2*mu1))/(E^(Pi*Im[mu1])*Pi)` | `((-4*I)*sE1^(-1 + 2*mu1))/(E^(Pi*Im[mu1])*Pi)` | `1` | PASS |
| three_vertex_massive | `11` | `1` | `1` | `1` | PASS |
| three_vertex_massive | `01` | `((-4*I)*sE1^(-1 + 2*mu1))/(E^(Pi*Im[mu1])*Pi)` | `((-4*I)*sE1^(-1 + 2*mu1))/(E^(Pi*Im[mu1])*Pi)` | `1` | PASS |
| three_vertex_massive | `10` | `((-4*I)*sE2^(-1 + 2*mu2))/(E^(Pi*Im[mu2])*Pi)` | `((-4*I)*sE2^(-1 + 2*mu2))/(E^(Pi*Im[mu2])*Pi)` | `1` | PASS |
| three_vertex_massive | `00` | `(-16*sE1^(-1 + 2*mu1)*sE2^(-1 + 2*mu2))/(E^(Pi*(Im[mu1] + Im[mu2]))*Pi^2)` | `(-16*E^(-(Pi*Im[mu1]) - Pi*Im[mu2])*sE1^(-1 + 2*mu1)*sE2^(-1 + 2*mu2))/Pi^2` | `1` | PASS |
| three_vertex_mixed | `11` | `1` | `1` | `1` | PASS |
| three_vertex_mixed | `01` | `((-4*I)*sE1^(-1 + 2*mu1))/(E^(Pi*Im[mu1])*Pi)` | `((-4*I)*sE1^(-1 + 2*mu1))/(E^(Pi*Im[mu1])*Pi)` | `1` | PASS |
| three_vertex_mixed | `10` | `1` | `1` | `1` | PASS |
| three_vertex_mixed | `00` | `((-4*I)*sE1^(-1 + 2*mu1))/(E^(Pi*Im[mu1])*Pi)` | `((-4*I)*sE1^(-1 + 2*mu1))/(E^(Pi*Im[mu1])*Pi)` | `1` | PASS |

## 精确计数

- case：`3/3`
- sector slot order：`10/10`
- dSIBP selector split：`10/10`
- sector normalization：`10/10`
- master identity：`45/45`
- master coefficient：`45/45`

## 结论与边界

三个指定 tree family 中，两包选择的 master identity、顺序和完整裸积分外系数逐项一致；所有系数比值为 1、差为 0。

混合 massive+massless case 在此只验证 master 定义。dSIBP 对 massless quotient 的公式型递推/DE 认证边界不属于本任务，本报告不将 master 对齐解释为该路线已经通过。

机器可读结果：`results/summary.wl`。
