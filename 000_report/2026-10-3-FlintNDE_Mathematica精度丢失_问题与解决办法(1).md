# FlintNDE 的作用及 Mathematica 接口精度丢失问题

## 一、FlintNDE 是干什么的？

一句话：**FlintNDE 是高精度微分方程数值求解器，负责把已知的起始解沿路径输运到目标点。**

它处理形如下面的一阶矩阵微分方程：

```text
Y'(x) = A(x) Y(x)
```

- `Y(x)` 是一列需要一起求解的函数。在我们的应用中，它对应主积分向量。
- `A(x)` 是微分方程的系数矩阵。
- 给定起始条件和一条路径，FlintNDE 计算路径上所需点的 `Y(x)`。

它主要用局部级数展开分段推进，并提供路径规划、奇点边界处理、主/参考阶数比较及多点输出等功能。它还可以对调节参数 `ep` 的多次数值求解结果重构 Laurent/幂级数。

它的核心用 Python 实现，依赖 python-flint 的 `arb`/`acb` 任意精度数值运算；另外提供 Mathematica 接口。因此，既可以从 Python 独立调用，也可以在 Mathematica 中调用。

在本项目中，三个程序包的分工是：

| 程序包 | 主要负责什么 |
| --- | --- |
| dSIBP | 从图和积分族生成 IBP 关系、扇区信息以及供外部约化使用的数据 |
| MadStree | 组织树图/时间积分族的主积分、约化公式、解析 DE 和起始边界，然后调用数值后端 |
| FlintNDE | 接收已经构造好的 DE 与起始条件，计算目标点的数值 |

因此，**FlintNDE 自己不认识费曼图，也不替你推导宇宙学积分的 IBP 或物理归一化。**它负责数值输运，而不是每到一个点就重新直接计算原始多重时间积分。

上述分工对应本次检查的 [FlintNDE 官方说明](https://github.com/J7C/dSIBP-Packages/blob/da496dd62a4593f3a833424b21ad3a28c2acecfc/FlintNDE/README.md)。

## 二、问题摘要

**问题确实属于程序包，但定位于独立 FlintNDE 的 Mathematica 结果转换接口，不是目前发现 Python 输运算法在这个例子中算错。**

本次结果传递过程是：

```text
Python 高精度输运
    → 返回实部、虚部的高精度字符串
    → Mathematica 将字符串转换成复数
```

精度丢失发生在最后一步：零分量被转换成机器精度零，继而把整个复数结果的精度拖低。

### 检验范围

- 仓库：`https://github.com/J7C/dSIBP-Packages`。
- 本次下载提交：`da496dd62a4593f3a833424b21ad3a28c2acecfc`。
- 提交说明：`Release dSIBP, MadStree and FlintNDE 1.0`。
- 实测环境：Wolfram Language 14.3、Python 3.13.1、python-flint 0.9.0、SymPy 1.14.0。
- 本报告针对这个已下载的 v1.0 快照，不推断未来提交是否已修复。

**当前状态：bug 已复现；最小修改已在独立诊断代码中验证；仓库源码尚未修改，修复后的完整接口回归尚未运行。**

## 三、实际复现及数值证据

### 3.1 使用的官方示例

运行 `FlintNDE/examples/mathematica_interface_example.wl`。只通过公开的 `"Python"` 选项指定已有且安装了依赖的解释器，没有修改官方示例的方程、阶数或数值参数。

该例使用：

- 80 位十进制工作精度；
- 40 位输出；
- 40 阶主结果、48 阶参考结果；
- 内部目标相对差 `1e-30`。

方程、起始条件与闭式解为：

```text
A(x) = diag(1/(x-1), -2/(x+3))
Y(0) = {1, 1}
Y(x) = {1-x, 9/(x+3)^2}
Y(1/2) = {1/2, 36/49}
```

### 3.2 Python 的结果字符串仍然正确保留高精度

第二个分量的原始记录为：

```text
real = "0.7346938775510204081632653061224489795918"
imag = "0"
```

这些字符串也保存在返回结果的 `primaryFinalVectorRecords` 中。后端主/参考链的内部相对差约为 `3.40e-45`，目标字段为 True。

### 3.3 Mathematica 数值向量却变成机器精度

接口实际返回：

```wl
{0.5 + 0. I, 0.7346938775510204 + 0. I}
```

检查：

```wl
Precision /@ result["primaryFinalVector"]
```

实测输出：

```wl
{MachinePrecision, MachinePrecision}
```

对于这个量级约为 1 的例子，第二个分量的实际绝对误差约为：

```text
3.85179416706687e-17
```

因此，返回给 Mathematica 用户的数值不能当作达到 `1e-30` 精度的结果使用。

为揭示这个误差，诊断时将已经返回的机器数精确化，再与精确的 `36/49` 相减。这是在检查机器数已经发生的舍入，**不是通过提高精度把丢失的位数补回来**。

### 3.4 为什么官方示例还打印“误差为 0”？

官方示例使用混合精度数值相减来比较终值。机器精度结果参与比较时，细小差异可能在该次运算中被舍入掉，因而打印 `0.`。

这个零表示当前运算已经看不见差异，而不是高精度结果真的与解析值相等。同样，两个不同的高精度主/参考结果也可能在转换后落到同一个机器数上，导致用户直接比较返回向量时得到零差。

## 四、源码原因

出问题的文件：

```text
C:/Users/Moons/Documents/宇宙学关联函数计算/dSIBP-Packages/FlintNDE/Mathematica/FlintNDE.wl
```

对应 [已检验版本的第 461–472 行](https://github.com/J7C/dSIBP-Packages/blob/da496dd62a4593f3a833424b21ad3a28c2acecfc/FlintNDE/Mathematica/FlintNDE.wl#L461-L472)。

原始实现为：

```wl
flintNDEDecodeDecimal[text_String, digits_Integer] := Module[
  {parts, mantissa, exponent},
  parts = StringSplit[ToLowerCase[StringTrim[text]], "e", 2];
  mantissa = First[parts];
  exponent = If[Length[parts] === 2, "*^" <> Last[parts], ""];
  If[! StringContainsQ[mantissa, "."], mantissa = mantissa <> ".0"];
  ToExpression[mantissa <> "`" <> ToString[digits] <> exponent]
];

flintNDEDecodeComplex[record_Association, digits_Integer] :=
  flintNDEDecodeDecimal[record["real"], digits] +
  I flintNDEDecodeDecimal[record["imag"], digits];
```

这段代码对零字符串也执行同样的“加小数点、加精度标记”操作，得到：

```wl
ToExpression["0.0`40"]
```

在本次 Wolfram 14.3 环境中，实测结果是机器精度零。零的精度处理不能直接套用非零数的转换方式。

逐步检查得到：

| 检查对象 | 实测 Precision |
| --- | --- |
| 非零实部字符串单独解码 | 40 |
| 零字符串按原函数解码 | MachinePrecision |
| 将上述实部和虚部组成复数 | MachinePrecision |
| 同一实部加上精确 `I*0` | 40 |

这说明问题在结果转换层，不需要归因于并行负载、缓存或用户的工作精度设置。

## 五、影响范围

### 已确认的影响

1. 独立 FlintNDE 的 Mathematica 接口在本次纯实数结果上丢失精度。
2. 官方 `mathematica_interface_example.wl` 受影响。
3. 官方 `ep_parallel_mathematica.wl` 的返回数值向量也退化为机器精度。
4. 直接使用这些数值进行精度比较，可能得到误导性的零误差。

本次已确认零虚部的路径；原函数对零实部使用相同转换逻辑，修复测试也包含纯虚数情况。

### 会导致什么？

- 高精度计算结果在交给用户时只剩约 16 位有效数字。
- 后端的精度状态与实际返回向量的精度不再一致。
- 后续相减、抵消、提取小残差时，误差可能进一步被放大。
- 输出更多位数或提高工作精度，不能自动修复结果转换层的错误。

这里的 `3.85e-17` 是特定例子的绝对误差，不是所有结果都具有同一个绝对误差。一般应区分有效位数、数值大小和后续运算的误差放大。

### 不应扩大解释的部分

- 目前没有由此发现 Python 输运核心在这个例子中计算错误；其原始高精度记录仍在。
- MadStree 使用自己的适配器和结果解析代码，不是直接走这套独立 FlintNDE Mathematica 解码函数。
- 本次检查到的 MadStree 返回值仍保留任意精度，因此不能据此宣称此前所有 MadStree 数据无效。
- 本报告不是所有拓扑、分支或物理关联函数正确性的证明。

## 六、具体解决办法

### 6.1 推荐的最小修改

在 `flintNDEDecodeDecimal` 内，紧接下面这一行：

```wl
mantissa = First[parts];
```

加入：

```wl
If[mantissa === "0", Return[0]];
```

完整修改后的函数如下：

```wl
flintNDEDecodeDecimal[text_String, digits_Integer] := Module[
  {parts, mantissa, exponent},
  parts = StringSplit[ToLowerCase[StringTrim[text]], "e", 2];
  mantissa = First[parts];

  (* 当前后端将零中点输出为字符串 "0"；保留为精确零。 *)
  If[mantissa === "0", Return[0]];

  exponent = If[Length[parts] === 2, "*^" <> Last[parts], ""];
  If[! StringContainsQ[mantissa, "."], mantissa = mantissa <> ".0"];
  ToExpression[mantissa <> "`" <> ToString[digits] <> exponent]
];
```

`flintNDEDecodeComplex` 不需要改变，Python 输运算法也不需要改变。

该修改针对当前后端实际输出的零格式。它没有设置“小于某个阈值就当零”的容差，因此不会把真正非零的小分量人为删除。

保留精确零只是避免精度退化，不代表整个数值解的所有误差严格为零；误差检查和原始半径信息仍需另行读取。

### 6.2 已完成的独立验证

在独立辅助文件 `zero_decode_fix_probe.wl` 中复制该解码逻辑并加入上述一行，**没有覆盖程序包函数或修改仓库源码**。

| 输入类型 | 修改后 Precision |
| --- | --- |
| 高精度实数，虚部为零 | 40 |
| 实部为零的纯虚数 | 40 |
| 实部、虚部均非零 | 40 |
| 实部、虚部均为零 | Infinity，即精确零 |

四种情况均未出现 MachinePrecision。修复逻辑读回的 `36/49` 近似值，其数值中点与精确值的绝对差约为 `4.97e-41`，明显低于例子要求的 `1e-30`。

但这仍是**解码函数的局部验证**，不是“已经修改并完整重跑了程序包”。

### 6.3 修改源码后还需要做什么？

1. 在上述源文件加入该行，保持其他数值算法不变。
2. 重启 Mathematica kernel，再加载包；仅重复 `Needs` 不会重新加载已经加载的包。
3. 重跑官方 `mathematica_interface_example.wl` 和 `ep_parallel_mathematica.wl`。
4. 检查返回向量的 `Precision` 不再退成 MachinePrecision，并核对原始字符串和已知解析解。
5. 保留后端主/参考链精度检查，但不能只靠返回向量相减得到 `0.` 就宣布达到目标精度。

当前报告没有执行步骤 1–5 的源码修复后完整回归，不能将其标记为已完成。

### 6.4 暂时不改源码时

可以从 `primaryFinalVectorRecords`、`referenceFinalVectorRecords` 的高精度字符串重新构造数值，解码方式采用上述精确零处理。已有字符串保留完整输出位数时，不需要为了找回这些位数重新进行 Python 输运。

但**不能**对已经返回的机器精度向量简单执行：

```wl
SetPrecision[result["primaryFinalVector"], 40]
```

这不会恢复已丢失的数字。

## 七、另一个独立问题：Python 并行示例的通过条件不一致

不要把它与前面的 Mathematica 精度丢失混在一起。

`FlintNDE/examples/ep_parallel.py` 对 `y'=ep/(1+x)y`、`y(0)=1` 使用 96/112 阶，声明目标 `1e-40`。本次三个 ep 点的内部相对差约为 `1.05e-37` 至 `1.06e-37`，独立闭式解 `2^ep` 的对照也确认未达到 `1e-40`。

求解器正确警告并保留结果，问题是示例仅按绝对差 `< 1e-30` 判断通过，因而仍打印 PASSED。

解决办法是让示例的检查条件与声明目标一致，并检查 `target_relative_error_met`；若保留 `1e-40` 目标，本例可以提高阶数。独立测试中改成 112/128 阶后，最大闭式相对误差约为 `2.51e-43`，目标字段均为 True。

Wolfram 并行示例的实际路径设置不同，其 Python 后端目标字段在本次测试中已达标；它受影响的是返回向量解码，不能把两种问题混报。

## 八、证据文件

文件均在本报告所在目录：

- [precision_probe.wl](precision_probe.wl)：原始接口精度退化的诊断代码。
- [precision_probe.json](precision_probe.json)：修改前的 Precision、原始字符串和实际误差。
- [zero_decode_fix_probe.wl](zero_decode_fix_probe.wl)：最小修法的独立验证代码，不修改程序包。
- [zero_decode_fix_probe.json](zero_decode_fix_probe.json)：修改逻辑的四种输入测试结果。
- [fn_wolfram_configured_details.json](fn_wolfram_configured_details.json)：官方独立 Mathematica 接口的运行记录。
- [fn_wolfram_parallel_configured_details.json](fn_wolfram_parallel_configured_details.json)：官方 Wolfram 并行接口的运行记录。
- [closed_forms_standalone.json](closed_forms_standalone.json)、[closed_forms_vendor.json](closed_forms_vendor.json)：Python 示例与闭式解的对照。
- [检验报告.md](检验报告.md)：本次仓库整体运行检查及其他文档问题。

**最终判断：程序包的 Mathematica 接口存在可复现的精度转换 bug；修复位置明确、所需改动很小，但目前不能标记为仓库已修复。**

## 3. README 中的两处实际不一致

### 3.1 availableQ 不检验 Python 环境

`MadStree/README.md` 第 33–34 行称 `MSFlintNDEConfiguration[]` 会报告是否找到了可用 Python 环境。

但 `MadStree/Kernel/Numerics/Configuration.wl` 第 41 行的 `availableQ` 仅检查内置 `flintnde/__init__.py` 是否存在，不启动 Python，也不检查 flint/SymPy。

本机 `availableQ=True` 时，默认 Python 仍不能导入 flint，足以说明两者不是同一个检查。**应改文档，而不是为配置查询额外加入环境探测。**实际计算仍应明确指定有依赖的解释器。

### 3.2 DSKiraPlan 与 DSKiraExport 的职责没有写清

`dSIBP/README.md` 第 56 行把 `DSKiraPlan` 和 `DSKiraExport` 一起描述为写入 Kira 输入目录。

`Kernel/Backends/KiraPlan.wl` 中 `DSKiraPlan` 实际构造并返回状态为 `planned` 的计划；写盘由 `DSKiraExport` 完成。官方混合 bubble 例子也明确只在内存中规划。本次记录为 `kiraPlanStatus=planned`，不能据此宣称外部约化已经完成。

**修法范围：**把 README 改为“DSKiraPlan constructs a plan; DSKiraExport writes the input files”。这是文档问题，不是规划算法错误。
