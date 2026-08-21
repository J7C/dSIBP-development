# MadStree v0.13 与 dSIBP 022 tree master normalization 独立验证任务书

## 1. 范围

本任务只比较两个程序包对同一 tree/time-only 主积分的选择、顺序和裸积分外系数，不生成
IBP 关系，不调用约化、Kira、DE、边界或数值输运。验证脚本不得读取两包现有测试、expected、
独立验证结果或报告；这些文件也不得成为本任务的输入。

固定检查三个 `+++` chain：

1. 两顶点、单条 massive 线；
2. 三顶点、两条 massive 线；
3. 三顶点、第一条 massive、第二条 massless full 线。

## 2. 共同积分身份

根传播子按用户输入顺序编号。sector key 的第 `e` 位在第 `e` 条线 active 时为 `1`，收缩时
为 `0`。每个 sector 的主积分身份统一写为

```text
CanonicalMaster[sectorKey, timeShifts, stateBits].
```

其中 `timeShifts` 是 contact 后各连通分量的零移位列表。`stateBits` 按根线顺序排列：active
massive 线依次放端点 1、端点 2 两位；active massless full quotient 放一个 shared 位；已收缩
线不放状态位。固定长度二进制列表按 `IntegerDigits[m,2,stateCount]` 从小到大枚举。

MadStree 的 `MSIntegral[key,shifts,bits]` 和 dSIBP 的
`J[key,shifts,bits]` 都只投影到上述独立标签后比较；不调用 MadStree 的跨包 adapter。

## 3. convention 对齐

- 顶点顺序、传播子顺序、顶点类型、外腿能量和时间幂逐项相同；本任务全部取 `vertexType="+"`。
- MadStree 使用 `NuConvention -> "Positive"`，massive 输入为正 Hankel 阶 `mu_e`；dSIBP h
  preset 输入 `nu_e=-mu_e`。因此两边 h 方程中的参数相同。
- 两边都使用 h basis；不做 H-to-h 变换。massless full 使用一个 shared quotient state。
- dSIBP 的固定线 `b0[e]=0`；massive contact 后的连续幂由其冻结
  `sectorPrefactorData` 保存，不写回 public master 指标。

对第 `e` 条 massive 线，令固定模长为 `q_e`，则共同的收缩系数为

```text
W_e = -(4 I/Pi) Exp[-Pi Im[mu_e]] q_e^(2 mu_e - 1).
```

massless full 收缩系数为 1。若 sector `s` 的收缩线集合为 `C_s`，独立 oracle 为

```text
C_s = Product[W_e, e in C_s and e massive].
```

dSIBP 还要独立记录其内部拆分：`physicalSectorPrefactor` 保存 Wronskian 常数和连续动量幂，
`selector` 是 compiled Wronskian product 与前者的商。massive 线每收缩一条应贡献 `-1/q_e`，
massless 线贡献 1；二者乘积必须回到 `C_s`。

## 4. 验收

- 三个 case 的总 master 数应分别为 `5`、`25`、`15`。
- 两包 sector 顺序、每个 sector 的 component/time-shift 数、state slot 顺序和全部 canonical
  master identity 必须逐项相同。
- 对每个 sector，MadStree normalization、dSIBP compiled-Wronskian normalization 和独立
  oracle `C_s` 必须严格相等。
- 对每个 master，两包系数之比必须严格为 1、差为 0。同一 sector 内系数不得依赖 stateBits
  或 master 序号。
- 任一失败都保留结果和报告并以非零 exit code 结束。

## 5. 输出

- `run_validation.wls`：唯一执行入口，以 ASCII bootstrap 显式按 UTF-8 加载验证主体。
- `run_validation_main.wl`：验证主体；每次运行先删除本任务旧 `results/` 和旧报告，删除失败立即停止。
- `results/summary.wl`：机器可读的源码身份、convention、逐 case、逐 sector 和逐 master 结果。
- `000_MadStree-v0.13-dSIBP-022-master-normalization-report.md`：自动生成的自包含报告。
