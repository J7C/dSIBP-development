# MadStree v0.11 更新说明

English version: [UPDATE_NOTES_en.md](UPDATE_NOTES_en.md)。

## 基线与定位

- 从冻结的 v0.10 建立；v0.10 不再回写。
- 数值后端升级为版本内嵌 FlintNDE 0.4.0 同步副本。
- MadStree 只负责最大连续复仿射单变量段的识别、dlog DE 拉回、边界和 master 顺序；
  节点规划、输运和多点级数求值全部属于 FlintNDE。

## 当前接口

- 唯一数值入口为 `MSEvaluatePath[context, pointSequence, ...]`。
- `FlintNDEPathPlanning -> True`（缺省）要求 FlintNDE 在每段内部自动规划节点。同一节点
  覆盖的用户点按桶做 fast multipoint evaluation；大桶使用子积树/余数树，小桶使用
  iterative 求值。
- `FlintNDEPathPlanning -> False` 要求 FlintNDE 严格按用户点顺序建立节点链，不插点、
  不删点、不调用规划器。用户点列若穿过奇点或超出局部收敛圆则明确失败。
- `SingularityMode -> "Avoid"` 缺省拒绝穿过奇点；`"SingularityJump"` 只在开启 FlintNDE
  规划时允许，并保留多值分支责任。
- 裸坐标需要返回；`{coordinate,"tmp"}` 只参与路径。其它标签拒绝。
- `MSBoundaryData` 与 `MSEvaluatePath` 的缺省 `WorkingPrecision` 提高到 200 位；正规化自动
  精度规划也以 200 位为下限。用户显式指定精度时继续直接采用指定值。

## 删除

v0.11 物理删除 MadStree 的路径规划模块、两阶段公开函数、计划对象判断、旧 JSON schema、
计划序列化/恢复、LO 点标签和相关兼容测试。当前包不加载、不转发、不保留 wrapper 或
fallback；需要旧行为只能显式加载冻结的 v0.10。

## 实现与编码

- 全部复仿射段、exact 拉回、边界和选项只通过一次 JSON 请求进入同一 Python 进程。
- 正则奇点 `{a,b,C}` 边界初始化与后续有限段输运在同一后端进程完成。
- 后端输入、输出、日志及 Wolfram 包内加载显式使用 UTF-8；普通 `Needs["MadStree`"]`
  不需要用户额外指定编码。
- `MSRuntimeDirectory` 现在明确表示临时运行根本身；`Automatic` 只在调用脚本旁建立一次
  `results_temp/`，其下固定使用 `nde/` 和 `cache/`。Example 06 不再拼接长任务目录，
  Notebook 直接运行也不再对空 `$ScriptCommandLine` 调用 `Last`。
- Windows 完整路径在目录创建和 Python 启动前检查。超过 259 字符时单独返回
  `RuntimePathTooLong`；输入写入、缺少 `python-flint`、后端启动、后端无输出和输出损坏
  分别返回独立错误，不再用安装提示覆盖真实路径错误。
- `MadStree package loaded` 只在 16 个模块文件及其代表性定义全部通过后打印。
- MadStree adapter 与 Vendor FlintNDE Wolfram bridge 均删除 shell `Run` launcher、引号 helper
  和重定向，改用参数列表 `RunProcess`；修复连续 Python/FLINT 启动的 Windows
  `0xC0000142`，不增加重试 fallback。
- `MSExportEvaluationData` 消费 `MSEvaluatePath` 的逐点结果和逐段 refinement 信息。
  任一请求格式写出失败时返回 `EvaluationExportFailed`，不能因另一格式已写出而返回
  `"written"`。
- 新增 `MSReconstructEpSeries[context,ep,pointTemplate,MaximumEpPower->m]`。用户不提供 `ep` 点；
  数值 NDE 前由符号边界条件与 dlog DE 自动认证最低整数幂，程序再确定生产/验证 exact 点、
  内部缓冲幂、工作精度和输运阶数。缺省额外拟合两阶；验证失败每轮再增加两阶，只计算
  新增生产点并复用两类旧点，最多三轮仍失败则关闭失败。
- 新增显式 `EpSamplePoints`、`EpValidationPoints` 与 `EpInitialInternalMaximumPower`。生产点列表
  是可冗余的有序候选池，每轮只消费所需前缀；池耗尽时不生成范围外点。三个选项缺省均为
  `Automatic`，缺省 adapter JSON 保持原字段集合。
- 新增 `EpSampleAngleRange -> {thetaMin,thetaMax}`：弧度开区间内部均匀使用最多三条射线，
  模长仍由精度策略自动决定。复点在交给 MadStree 前 exact rationalize 为 `Q(i)`；缺省不增加
  JSON 字段。拟合精度未达时保留当前系数并返回 `computed_with_warning`，候选池耗尽原因单列。
- `ParallelTaskCount -> 12` 控制生产和验证批次的外层进程上限，超额任务自动续交。
- 物理删除旧公开 `MSEvaluateEpBatch`；固定点批量器仅作为私有阶段执行器，不保留 wrapper。
- Example 06 的真实无质量三顶点共同正规化 `a1=a2=a3=1+ep` 只指定最高阶 `0`，
  fresh 符号证书得到最低幂 `0`；DE 无负 `ep` 阶，边界在 `ep=0` 解析。

## 验证状态

- Python adapter：8/8 通过；接收已认证 `-1` 后使用 4 个生产点、内部拟合至 `ep^2`，
  并恢复人工 `1/ep+2+3ep` 的 pole `1` 与 finite part `2`。
- Laurent valuation 8/8；真实 9 主积分、9 边界分支三顶点结构证书得到 `leadingPower=0`。
- 完整 Python 回归 166/166，Wolfram `Needs["FlintNDE`"]` 25/25；MadStree 浅层目录与导出
  门禁 10/10。独立包与 Vendor 的 42 个非缓存交付文件逐文件 SHA-256 一致。
- v0.11 独立验证 18/18：runner 先删除旧结果/runtime/报告并检查唯一 `results_temp` 根；
  900 点乘 3 masters 全分量互检，最大绝对差 `5.8262e-43`；
  自动规划路线 894 点进入 6 个 fast 桶，端到端与后端分别比严格用户节点路线快
  `2.5431` 倍和 `4.8023` 倍。报告、summary 和完整逐点 evidence 均按 UTF-8/LF 写出；runner 在当前 Windows
  `wolframscript -file` 下恢复可严格 UTF-8 往返的源码文本段，中文标题与内容无乱码。报告位于
  `independent-validation/MadStree-v0.11-validation-01-flintnde-planned-vs-user-nodes/`。
- 中英文手册均经 XeLaTeX/BibTeX 构建，日志无未定义引用，首页和数值接口页目检通过。

## 已知限制

- 关闭规划时不支持自动奇点折跃；用户必须给出合法普通点节点链。
- fast multipoint 的收益依赖每个节点的覆盖桶大小、级数阶数和 master 维数；独立验证报告
  必须同时记录实际节点、coverage、算法计数及相对直接节点路线的耗时。
- MadStree 不生成一般 IBP 系统，也不运行 Kira。
