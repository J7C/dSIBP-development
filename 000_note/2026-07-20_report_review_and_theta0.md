# 两份 v011 外部报告的独立复核与 theta(0) 处理结论

日期：2026-07-20

复核对象：

- `D:/Agent-projects-nut/dSibp-independent-benchmark/000_report_v011/01-report-ibp-check.md`
- `D:/Agent-projects-nut/dSibp-independent-benchmark/000_report_v011/02-report-package-module-test.md`

本报告不把外部报告、现有 package 或现有 expected 中任何一方预设为真值。判定依据依次是传播子定义、独立代数推导、图的 incidence、最小 Wolfram 复现和全 family 交叉检查。

## 1. 总结判定

外部 01 报告包含两项正确的手推错误归因，但其核心 package-bug 结论只对 massless 成立，对 massive 不成立；它关于 `theta(0)`、三线 bundle、当前 package 行为和 benchmark 拓扑的多项结论错误。它留下的 pure massless bubble 与 mixed triangle “未解决差异”也不是 convention 差异，而是外部手推/比较脚本错误。

外部 02 报告的模块测试结果只能证明 API/结构 smoke test 通过，不能推出公式正确。它声称 UTF-8 在所述环境中必然导致 package/examples 无法直接加载，但同机直接运行未显式指定编码的正式 example 成功，因而该严重性和普遍性结论不可复现。编码可移植性仍可作为风险记录，但不能写成已证实的普遍故障。

本次确认的旧 011 实现问题如下；修正全部进入新版本 012，011 文件与旧验证资产保留为报告审计基线：

1. massless theta shrink 错误地令 merged `a` 减 1；正确整数移位为 0。
2. 三条及以上共同 theta 的旧逐线 boundary 只保留单 shrink，漏掉奇数多线 contact，例如三线的 triple contact。
3. `shrinkSectorSubsets` 旧实现枚举所有 theta-full 线幂集，包含不可由 contact 事件到达的 sector。
4. coincident `massiveFull` 缺少 `{b,n1,n2}={b,n2,n1}` canonical。

## 2. theta(0) 与分布乘积

### 2.1 单个传播子的 equal-time 值

对

```text
G_e(x) = theta(x) A_e(x) + theta(-x) B_e(x)
```

采用对称 prescription 时，自然取

```text
theta(0) = 1/2,
G_e(0) = J_e = (A_e(0)+B_e(0))/2.
```

该值适合定义一个未缩并传播子的 coincidence 值。它本身不定义 `delta(x) theta(x)^m`；把后者直接替换为 `2^{-m} delta(x)` 没有分布论依据。

### 2.2 方案 A：共同 theta，推荐实现

同一当前代表顶点对之间的 full lines 共享同一时间差。其乘积作为局部可积函数满足

```text
Product[G_e]
 = theta(x) Product[A_e] + theta(-x) Product[B_e]
```

（等式按 almost-everywhere/distribution 意义理解）。一次 time derivative 的唯一 boundary 是

```text
delta(x) (Product[A_e]-Product[B_e]).
```

令

```text
J_e=(A_e+B_e)/2,
D_e=A_e-B_e,
```

则有精确、无顺序依赖的展开

```text
Product[A_e]-Product[B_e]
 = Sum_{S nonempty, |S| odd}
     2^(1-|S|) Product_{e in S}[D_e] Product_{e not in S}[J_e].
```

因此：

- 两条平行线：只有两个 single-contact 项。
- 三条平行线：三个 single-contact 项，加一个系数 `1/4` 的 triple-contact 项。
- triple contact 仍只乘一个共同 `delta(x)`，不是 `delta(x)^3`。
- contact 后两个代表顶点类只合并一次；剩余 coincident theta 不再求导。

这正是当前修正后的 package 规则。

### 2.3 方案 B：保留逐传播子 theta 的统一平滑正则化

逐传播子结构可以保留，但必须正则化整个乘积，不能只规定点值。取高斯 approximate identity

```text
rho_eps(x) = exp[-x^2/eps^2]/(sqrt(pi) eps),
H_eps(x)   = Integral_{-Infinity}^x rho_eps(t) dt.
```

则 `H_eps(0)=1/2`、`H_eps'=rho_eps`。所有共享同一时间差的线必须使用同一个 `H_eps`：

```text
G_{e,eps}=B_e+H_eps(A_e-B_e).
```

把 derivative 归因到第 `i` 条线时，其极限定义为

```text
delta(x) Integral_0^1 dh
  D_i Product_{j != i}(B_j+h D_j).
```

对所有 `i` 求和后严格得到 `delta(x)(Product[A]-Product[B])`，与方案 A 完全等价。它还给出一致的乘积规则

```text
rho_eps H_eps^m -> delta/(m+1),
rho_eps H_eps^r (1-H_eps)^s
  -> Beta(r+1,s+1) delta.
```

所以统一高斯极限下通常不是 `delta theta^m = 2^{-m} delta`。例如三线时，每条逐线贡献各带 triple term 的 `1/12`，三条相加成为方案 A 的 `1/4`。

也可给各线使用有序点分裂 profile；单条线的贡献会依赖点分裂顺序，形成 telescoping 分配，但总和仍只由端点 `Product[A]-Product[B]` 决定。package 不应把这种人为顺序写入 canonical 输出。

### 2.4 最终选择

推荐方案 A 作为 package canonical：公式最短、无调节器和线序依赖，并直接给出可达 sector。方案 B 作为对“保留每条传播子 theta 后如何自洽”的定义和独立验证工具。最终 convention 是：

- 单传播子 coincidence 取 `theta(0)=1/2`。
- 不用点值乘法定义 `delta theta^m`。
- 多线 boundary 用共同 theta 的 odd-subset contact，或等价的统一 mollifier 极限。

## 3. 对 01 报告的逐项审查

### 3.1 “所有 shrink 的 merged a 都不应移位”只有一半正确

报告第 23--79 行把 massless 和 massive 合并为同一 bug，错误。

- massless：delta 无剩余 `(-tau)^{-1}`，所以 `aMerged=a_u+a_v`。旧 package 多减 1，确为 bug。
- massive h/H：Wronskian 含整数 `1/x=1/(q(-tau))`。当前 convention 把整数部分写成 `aMerged=a_u+a_v-1`、`bS=b+1`，非整数部分进入 zero point；物理幂正确。

外部手推可把整数 `-1/+1` 分别移入 `a0Sector/bS0`，但必须两边同时移动。报告第 287--294 行承认 `bS` 的这种拆分是记号差异，却把完全相同的 `a` 拆分判为 package bug，前后不一致。

### 3.2 cross momentum IBP 的结论正确，符号解释错误

报告正确指出外部手推漏了 `b->b-1`：`q partial_q exp(+-iq Delta)` 带一个 `q`。

但报告第 151--153 行所谓“IBP 整体再有一个负号”不成立。生成关系本身就是 `Integral partial_q.(v I)=0`，没有第二个额外负号。最终 `a` 项符号来自把 `tau=-(-tau)` 写回 package 的 `(-tau)` 基底。

### 3.3 massive momentum 的 untouched endpoint 判定正确

对某一端点 building block 求导只能改变该端点状态，另一个端点的 `n` 必须保持。外部手推把 untouched endpoint 重置为 0，确为手推错误；package 在该点正确。

### 3.4 报告漏掉 atomic massless `n=0` 的手推错误

由定义

```text
M0=theta exp[-i sigma q Delta]+theta(-Delta) exp[i sigma q Delta],
M1=-theta exp[-i sigma q Delta]+theta(-Delta) exp[i sigma q Delta]
```

直接得到

```text
partial_q M0 = i sigma Delta M1,
partial_q M1 = i sigma Delta M0.
```

外部比较脚本对 `n=0` 硬编码了相反符号，却对 `n=1` 使用正确符号。01 报告把部分 `n=0` 项列为完全匹配，统计和归因因此不完整。

### 3.5 pure massless bubble 不是 ISP/convention 未决问题

无 ISP 时

```text
q.k=(z1+s11-z2)/2
```

唯一确定。对第二条线的 denominator 求导含

```text
-B2 (q.Q2) Q2^{-B2-2}.
```

外部手推少保留了一个 `Q2^{-1}`，随后把 `b2` 移位方向写错。当前项目中从上述 `z1/z2` 恒等式独立生成的 pure-massless expected 与 package 64/64 一致。故报告第 573--585 行的“可能是标量积分解 convention”结论错误。

### 3.6 mixed triangle 的未决差异是 incidence 错误

三角形连线为

```text
e1={v1,v2}, e2={v2,v3}, e3={v3,v1}.
```

所以 `dtau[v1]` 只能作用于 `e1` 的第一端点和 `e3` 的第二端点，不能作用于 `e2`。外部硬编码方程加入了 `e2` 项，并在部分注释/pack 中混淆 endpoint slot。当前独立 triangle expected 按 incidence 重建后与 package 1792/1792 一致。报告第 587--597 行把它留作 package 疑点，错误。

### 3.7 比较方法与 16/30 统计不可信

报告第 5--7 行声称读取各 family 的 `expected.wl` 精确比较；实际 `package_seed/compare_all_families.wl` 大量直接硬编码 `hand...` 方程，没有加载外部 `derived-by-AI-hands/.../expected.wl`。因此它比较的是脚本作者重新录入的一小组公式，不是报告声称的冻结 expected。

由此产生的 16/30、14 mismatch 和各归因计数不能作为完整 benchmark 统计。

## 4. 对 01 报告 theta(0) 章节的审查

1. 报告第 312、526--540 行称旧 package 已实现共同-theta convention A，错误。旧代码只有逐线 boundary，没有 bundle/contact 对象。
2. 报告第 424--433 行把“对线 1 的 theta 求导”写成整个全局 `Product[A]-Product[B]` 的一半，错误。正确逐线项是 `D_1` 乘其它正则化传播子。
3. 报告第 498--523 行称 `n>=3` 仅差整体因子且项结构不变，错误。对称 `J,D` 基底中三线必有 `D1 D2 D3/4`，不是只有三个 single terms。
4. 报告的 telescoping 恒等式本身成立，但它使用有序的 directional `A/B` 因子；当前 coincident `J` 是对称平均。该 telescoping 分配依赖线序，不能据此声称等于旧 package 行为。
5. 报告第 560--565 行称当前 benchmark 同一顶点对最多两条 full line，事实错误。`mixed_sunrise`、`two_loop_isp_toy`、`parallel_massless_bundle_guard` 都有三条平行线。
6. 它把 `mixed_sunrise` 描述为三顶点非平行图，事实错误；该 family 是两顶点三平行线。
7. 三条 massless `n=1` 时，`D_e=-2`，triple contact 为 `(1/4)(-2)^3=-2`，非零。旧 guard 所称 `(1,1,1)` shrink 消失不成立。

## 5. 对 02 报告的审查

### 5.1 UTF-8 “严重且普遍加载失败”未复现

在报告所述同一 Windows/WolframScript 环境，直接运行未显式给 `CharacterEncoding` 的

```text
package/examples/01_mixed_bubble_workflow.wl
```

退出码为 0，并生成 topology、三类 relation、canonical batch 与 linear data。因此报告第 20--62 行把它表述成正式 examples 的必现严重故障，证据不足。

旧内核或不同 locale 仍可能有编码可移植性风险。稳妥方案是让 loader 显式指定编码，或把程序源变为 ASCII；在被加载文件内部先设置 `$CharacterEncoding` 不能可靠地解决“文件尚未被正确解码”的自举问题。

### 5.2 “43 项全部通过”不能证明数学正确

这些测试大量断言返回 head、status、equation count 或结构字段。它们在旧 massless `a`、错误幂集 sector 和三线 contact 缺失同时存在时仍全部通过，说明覆盖层级是 smoke/structure，而不是公式 oracle。

### 5.3 “唯一计算 bug”错误

除 massless `a` 外，旧实现还缺共同-theta odd contacts、枚举不可达 sector、缺 massive coincidence canonical。故报告第 297--305 行“逻辑正确、只有一个计算错误”的总结不成立；报告列出的 equation count 也包含旧的错误 sector 模型。

## 6. 为什么项目内旧 hand-derived 检查会全部对上

旧检查通过不反驳本报告发现的 011 错误，因为其 expected 在三个关键位置与实现共享了同一假设：

1. `_manual_ibp_engine.wl` 的 `manualShrinkIntegral` 对 massive 和 massless 都统一执行 `Total[aList]-1`，与 011 的 massless bug 相同。
2. `manualSectors` 直接调用 `Subsets[manualFullLines]`，与 011 的全幂集 sector 枚举相同。
3. time boundary 在 `manualTimeLineTerms` 中逐线生成，没有独立构造共同 theta 的乘积差或三线 odd contact。
4. pure/mixed bubble 与 triangle 的定制 expected 又各自复制了相同的 `-1`、幂集和逐线 boundary 结构。

因此这些文件虽未调用 package seed 函数，却不是针对上述三项风险的独立 oracle；它们是“实现独立、关键假设同源”。结构 smoke test 只检查 relation 数量、status、pack shape，也无法发现双方一起多列 sector 或一起错移幂次。

`000_code/test/012_legacy_handcheck_oracle_audit_test.wl` 可执行地证明：011 与旧 atomic massless expected 确实精确相等，但双方共同含错误的 `J[{-1},{{0}},{}]`；同一 seed 在 012 中变为 `J[{0},{{0}},{}]`。该审计当前为 6/6。

## 7. 实施与验证状态

新主线 012 已实现：

- common-theta bundle 的非空奇数子集 contact，系数 `2^(1-k)`；
- 一次事件的 simultaneous multi-line shrink，只合并一次顶点；
- massless `aShift=0`，massive 保留 `aShift=bShift`；
- contact-reachable BFS sector；
- coincident massive endpoint canonical。

新增测试全部位于 `000_code/test/`。`012_theta_bundle_and_report_audit_test.wl` 当前 30/30，其中显式验证 h 的总幂次 shift 为整数 `1` 加 zero-point `2 nu`、H 为 `1+0`、massless 为 `0+0`；旧 oracle 审计 6/6。修正后的独立 family 结果包括：atomic massless 22/22+8/8、atomic massive 104/104、pure massless bubble 64/64、mixed bubble 132/132、parallel massless 194/194、mixed sunrise 1842/1842、triangle 1792/1792、two-loop ISP 978/978、pure massive h/H 608/608、vertex energy 90/90。
