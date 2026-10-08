# FlintNDE 0.5.0 Validation-06 独立报告：公开反馈与异常语言

- 状态：**passed**，硬 check 121/121 通过。
- 被测源码聚合 SHA-256（flintnde/*.py + Mathematica/FlintNDE.wl）：`ffa2465cb781dded5fd3e5a8712abd70f1f17cb1d7c7528fb83a1f05b2719e03`。
- Wolfram 程序包版本：`0.5.0`；math.exe：`D:\Wolfram Research\Wolfram\15.0\math.exe`。
- 工作精度/守卫位（Python 通道）：`90 / 50`；Wolfram 规划精度 `60`，执行门禁请求 `90`。
- unittest 套件（版本目录 `python -m unittest discover -s tests -t tests` 运行一次）：`Ran 181 tests`，OK=`True`（任务书预期 181）。
- 公开 CLI：**not applicable / no public CLI**——pyproject.toml 无 `[project.scripts]`/`[project.gui-scripts]`（空 / 空），无 `flintnde/__main__.py`（hasMainModule=`False`）。CLI 通道按任务书标记“not applicable / no public CLI”，实际以桥接模块命令行 `python -m flintnde.mathematica_bridge <request.json> <output.m>` 作为公开命令行入口验证。
- 总 wall time：`25.943 s`。
- 出口矩阵计数：动态触发 `48`，仅静态审阅 `13`，无法安全触发 `4`；后两类不计为动态通过。
- findings（记录不改源）：`0` 条，见下文。

## 方法与范围

- 三个公开通道全部真实执行并捕获：Python API 直接调用；CLI 用 `python -m flintnde.mathematica_bridge <req.json> <out.m>` 喂入坏请求；Wolfram 通道由 math.exe -noprompt -script 执行 ASCII-only 包装脚本 `results_temp/wolfram/run_wolfram_channel.wls`（stub 解释器运行时重建于 results_temp）。
- 每项触发记录异常类型 / Failure tag / status+reason（机器可判定未变）、中英文用户句子、raise 站点 file:line，以及 naturalLanguageOk（完整自然语言句子、含具体原因与可行下一步、非黑话、非原始 `<|...|>` 转储）。
- 失败后未继续输运/未写假成功：Python 通道以异常传播为准（无返回值）；CLI 以 `status -> "error"` 关联 + 退出码 1 为准；Wolfram 以 `Failure[...]` 头或 `singularPathRefused`/`planFailed` status 为准；精度门禁在启动输运前返回。
- 本 case 不运行数值输运，不产生数值点/逐分量误差；数值一致性由 Validation-01~05 覆盖。

## Python 通道（PY01-PY15，无 PY12）

| case | 类别 | 类型/tag/status | 站点 | NL 句子 |
| --- | --- | --- | --- | --- |
| PY01 | input-type | `TypeError` | routing.py:32 | yes |
| PY02 | input-type | `ValueError` | routing.py:45 | yes |
| PY03 | dimension | `ValueError` | singularities.py:437 | yes |
| PY04 | precision | `ValueError` | core.py:53 | yes |
| PY05 | path | `ValueError` | transport.py:658 | yes |
| PY06 | singularity | `AdaptivePathSingularityError` | routing.py:1030 | yes |
| PY07 | singularity | `AdaptivePathSingularityError` | routing.py:1030 | yes |
| PY08 | singularity | `ValueError` | routing.py:958 | yes |
| PY09 | serialization | `ValueError` | routing.py:668 | yes |
| PY10 | savepoint+file-write | `FileExistsError` | savepoints.py:325 | yes |
| PY11-CN | notice | `UserWarning` | flintnde/routing.py:1386 | yes |
| PY11-EN | notice | `UserWarning` | flintnde/routing.py:1386 | yes |
| PY13 | unsupported-capability | `ValueError` | mathematica_bridge.py:761 | yes |
| PY14 | precision | `ValueError` | mathematica_bridge.py:537 | yes |
| PY15 | serialization | `ValueError` | core.py:38 | yes |

## CLI 通道（CLI01-CLI07）

- 公开 console-script CLI：**not applicable / no public CLI**。以下 case 通过桥接模块命令行 `python -m flintnde.mathematica_bridge <request.json> <output.m>` 动态触发。

| case | 类别 | 类型/tag/status | 站点 | NL 句子 |
| --- | --- | --- | --- | --- |
| CLI01 | serialization | `status=error` | - | yes |
| CLI02 | unsupported-capability | `status=error` | - | yes |
| CLI03 | serialization | `status=error` | - | yes |
| CLI04 | input-type | `status=error` | - | yes |
| CLI05 | singularity | `status=singularPathRefused` | - | yes |
| CLI06 | singularity | `status=singularPathRefused` | - | yes |
| CLI07 | file-write | `status=error` | flintnde/mathematica_bridge.py:861 | yes |

## Wolfram 通道

| case | 类别 | 类型/tag/status | 站点 | NL 句子 |
| --- | --- | --- | --- | --- |
| WM-nonRational | input-type | `NonRationalMatrixEntry` | Mathematica/FlintNDE.wl（见出口矩阵） | yes |
| WM-inexact | input-type | `InexactRationalMatrixEntry` | Mathematica/FlintNDE.wl（见出口矩阵） | yes |
| WM-nonSquare | dimension | `SquareMatrixRequired` | Mathematica/FlintNDE.wl（见出口矩阵） | yes |
| WM-badLanguage | input-type | `InvalidMessageLanguage` | Mathematica/FlintNDE.wl（见出口矩阵） | yes |
| WM-badModeString | input-type | `InvalidSingularityMode` | Mathematica/FlintNDE.wl（见出口矩阵） | yes |
| WM-badModeType | input-type | `InvalidSingularityMode` | Mathematica/FlintNDE.wl（见出口矩阵） | yes |
| WM-unknownOption | unsupported-capability | `UnknownOption` | Mathematica/FlintNDE.wl（见出口矩阵） | yes |
| WM-badPythonType | input-type | `InvalidPythonExecutable` | Mathematica/FlintNDE.wl（见出口矩阵） | yes |
| WM-badWorkDirType | input-type | `InvalidWorkDirectory` | Mathematica/FlintNDE.wl（见出口矩阵） | yes |
| WM-pathTooLong | file-write | `RuntimePathTooLong` | Mathematica/FlintNDE.wl（见出口矩阵） | yes |
| WM-workDirWriteBlocked | file-write | `RuntimeInputWriteFailed` | Mathematica/FlintNDE.wl（见出口矩阵） | yes |
| WM-launchFailed | file-write | `BridgeLaunchFailed` | Mathematica/FlintNDE.wl（见出口矩阵） | yes |
| WM-invalidPlanAssoc | serialization | `InvalidExecutionPlan` | Mathematica/FlintNDE.wl（见出口矩阵） | yes |
| WM-precisionMissing | precision | `PlannedPathPrecisionMissing` | Mathematica/FlintNDE.wl（见出口矩阵） | yes |
| WM-epBatchEmpty | input-type | `EpJobListEmpty` | Mathematica/FlintNDE.wl（见出口矩阵） | yes |
| WM-epJobMissing | input-type | `InvalidEpJob` | Mathematica/FlintNDE.wl（见出口矩阵） | yes |
| WM-parallelCount | input-type | `ParallelTaskCountPositiveIntegerRequired` | Mathematica/FlintNDE.wl（见出口矩阵） | yes |
| WM-invalidPlanArguments | input-type | `InvalidPlanArguments` | Mathematica/FlintNDE.wl（见出口矩阵） | yes |
| WM-invalidSystemArguments | input-type | `InvalidRationalSystemArguments` | Mathematica/FlintNDE.wl（见出口矩阵） | yes |
| WM-pfNonList | input-type | `InvalidPartialFractionSystemArguments` | Mathematica/FlintNDE.wl（见出口矩阵） | yes |
| WM-pfDimensions | dimension | `ConsistentSquareMatricesRequired` | Mathematica/FlintNDE.wl（见出口矩阵） | yes |
| WM-pfPoleMismatch | dimension | `PoleResidueLengthMismatch` | Mathematica/FlintNDE.wl（见出口矩阵） | yes |
| WM-pfArguments | input-type | `InvalidPartialFractionSystemArguments` | Mathematica/FlintNDE.wl（见出口矩阵） | yes |
| WM-executeArguments | input-type | `InvalidExecuteArguments` | Mathematica/FlintNDE.wl（见出口矩阵） | yes |
| WM-epBatchArguments | input-type | `InvalidEpBatchArguments` | Mathematica/FlintNDE.wl（见出口矩阵） | yes |
| WM-stub-flintMissing | unsupported-capability | `PythonFlintUnavailable` | Mathematica/FlintNDE.wl（见出口矩阵） | yes |
| WM-stub-noOutput | file-write | `BridgeOutputMissing` | Mathematica/FlintNDE.wl（见出口矩阵） | yes |
| WM-stub-exitNonzero | file-write | `BridgeLaunchFailed` | Mathematica/FlintNDE.wl（见出口矩阵） | yes |
| WM-stub-badOutput | serialization | `BridgeOutputInvalid` | Mathematica/FlintNDE.wl（见出口矩阵） | yes |
| WM-stub-symbolOutput | serialization | `InvalidBridgeResult` | Mathematica/FlintNDE.wl（见出口矩阵） | yes |
| WM-stub-errorStatus | unsupported-capability | `BridgeFailure` | Mathematica/FlintNDE.wl（见出口矩阵） | yes |
| WM-workDirCreationBadName | file-write | `RuntimeInputWriteFailed` | Mathematica/FlintNDE.wl（见出口矩阵） | yes |
| WM-refusedCN | singularity | `singularPathRefused` | Mathematica/FlintNDE.wl（见出口矩阵） | yes |
| WM-refusedEN | singularity | `singularPathRefused` | Mathematica/FlintNDE.wl（见出口矩阵） | yes |
| WM-precisionCN | precision | `PlannedPathPrecisionInsufficient` | Mathematica/FlintNDE.wl（见出口矩阵） | yes |
| WM-precisionEN | precision | `PlannedPathPrecisionInsufficient` | Mathematica/FlintNDE.wl（见出口矩阵） | yes |
| WM-epBatchRefused | singularity | `complete` | Mathematica/FlintNDE.wl（见出口矩阵） | yes |

- 四个 `FlintNDEBridgeError` Message 模板均为中英双语完整句子，且 stub case 使 `::error/::pythonFlintMissing/::launchFailed/::outputMissing` 全部真实发送到会话输出。
- 精度门禁 `PlannedPathPrecisionInsufficient` 在 CN 与 EN 下均返回 Failure，消息分别为完整中文/英文句子（验收第 2 条）。

## 公开提醒出口矩阵

- 计数：动态触发 `48`；仅静态审阅 `13`；无法安全触发 `4`。

### wolframFailureTag（31 行）

| 名称 | 站点 | 归类 |
| --- | --- | --- |
| BridgeFailure | `Mathematica/FlintNDE.wl:426` | dynamic |
| BridgeLaunchFailed | `Mathematica/FlintNDE.wl:370` | dynamic |
| BridgeOutputInvalid | `Mathematica/FlintNDE.wl:408` | dynamic |
| BridgeOutputMissing | `Mathematica/FlintNDE.wl:398` | dynamic |
| ConsistentSquareMatricesRequired | `Mathematica/FlintNDE.wl:238` | dynamic |
| EpJobListEmpty | `Mathematica/FlintNDE.wl:799` | dynamic |
| InexactRationalMatrixEntry | `Mathematica/FlintNDE.wl:169` | dynamic |
| InvalidBridgeResult | `Mathematica/FlintNDE.wl:417` | dynamic |
| InvalidEpBatchArguments | `Mathematica/FlintNDE.wl:850` | dynamic |
| InvalidEpJob | `Mathematica/FlintNDE.wl:756` | dynamic |
| InvalidExecuteArguments | `Mathematica/FlintNDE.wl:720` | dynamic |
| InvalidExecutionPlan | `Mathematica/FlintNDE.wl:645` | dynamic |
| InvalidMessageLanguage | `Mathematica/FlintNDE.wl:110` | dynamic |
| InvalidPartialFractionSystemArguments | `Mathematica/FlintNDE.wl:271` | dynamic |
| InvalidPlanArguments | `Mathematica/FlintNDE.wl:520` | dynamic |
| InvalidPythonExecutable | `Mathematica/FlintNDE.wl:60` | dynamic |
| InvalidRationalSystemArguments | `Mathematica/FlintNDE.wl:209` | dynamic |
| InvalidSingularityMode | `Mathematica/FlintNDE.wl:129` | dynamic |
| InvalidWorkDirectory | `Mathematica/FlintNDE.wl:71` | dynamic |
| NonRationalMatrixEntry | `Mathematica/FlintNDE.wl:156` | dynamic |
| ParallelTaskCountPositiveIntegerRequired | `Mathematica/FlintNDE.wl:805` | dynamic |
| PlannedPathPrecisionInsufficient | `Mathematica/FlintNDE.wl:680` | dynamic |
| PlannedPathPrecisionMissing | `Mathematica/FlintNDE.wl:659` | dynamic |
| PoleResidueLengthMismatch | `Mathematica/FlintNDE.wl:247` | dynamic |
| PolynomialMatrixListRequired | `Mathematica/FlintNDE.wl:226` | static-only |
| PythonFlintUnavailable | `Mathematica/FlintNDE.wl:381` | dynamic |
| RuntimeInputWriteFailed | `Mathematica/FlintNDE.wl:330` | dynamic |
| RuntimePathTooLong | `Mathematica/FlintNDE.wl:93` | dynamic |
| SquareMatrixRequired | `Mathematica/FlintNDE.wl:192` | dynamic |
| UnknownOption | `Mathematica/FlintNDE.wl:483` | dynamic |
| WorkDirectoryCreationFailed | `Mathematica/FlintNDE.wl:322` | static-only |

### wolframMessageTemplate（5 行）

| 名称 | 站点 | 归类 |
| --- | --- | --- |
| FlintNDEBridgeError::error | `Mathematica/FlintNDE.wl:30` | dynamic |
| FlintNDEBridgeError::launchFailed | `Mathematica/FlintNDE.wl:36` | dynamic |
| FlintNDEBridgeError::outputMissing | `Mathematica/FlintNDE.wl:39` | dynamic |
| FlintNDEBridgeError::pythonFlintMissing | `Mathematica/FlintNDE.wl:33` | dynamic |
| FlintNDEBridgeError::usage | `Mathematica/FlintNDE.wl:28` | static-only |

### pythonWarningSite（11 行）

| 名称 | 站点 | 归类 |
| --- | --- | --- |
| warnings.warn | `flintnde/numeric_structure.py:266` | static-only |
| warnings.warn | `flintnde/regularization.py:1524` | static-only |
| warnings.warn | `flintnde/routing.py:1386` | dynamic |
| warnings.warn | `flintnde/routing.py:1606` | static-only |
| warnings.warn | `flintnde/singularity_jump.py:1751` | static-only |
| warnings.warn | `flintnde/transport.py:303` | static-only |
| warnings.warn | `flintnde/transport.py:1096` | static-only |
| warnings.warn | `flintnde/transport.py:1185` | static-only |
| warnings.warn | `flintnde/transport.py:1271` | static-only |
| warnings.warn | `flintnde/transport.py:1330` | static-only |
| warnings.warn | `flintnde/transport.py:1375` | static-only |

### pythonRaiseSite（14 行）

| 名称 | 站点 | 归类 |
| --- | --- | --- |
| PY15 | `flintnde/core.py:38` | dynamic |
| PY04 | `flintnde/core.py:53` | dynamic |
| PY14 | `flintnde/mathematica_bridge.py:537` | dynamic |
| PY13 | `flintnde/mathematica_bridge.py:761` | dynamic |
| PY06 | `flintnde/routing.py:1030` | dynamic |
| PY01 | `flintnde/routing.py:32` | dynamic |
| PY02 | `flintnde/routing.py:45` | dynamic |
| PY09 | `flintnde/routing.py:668` | dynamic |
| PY08 | `flintnde/routing.py:958` | dynamic |
| PY10 | `flintnde/savepoints.py:325` | dynamic |
| PY03 | `flintnde/singularities.py:437` | dynamic |
| PY05 | `flintnde/transport.py:658` | dynamic |
| CLI01/CLI02 | `flintnde/mathematica_bridge.py:676` | dynamic |
| CLI07 | `flintnde/mathematica_bridge.py:861` | dynamic |

### cannotSafelyTrigger（4 行）

| 名称 | 站点 | 归类 |
| --- | --- | --- |
| 路径长度门禁的非 Windows 分支：本机为 Windows，只读验证无法切换操作系统 | `Mathematica/FlintNDE.wl:88` | cannot-safely-trigger |
| 规划器内部不变量：公开输入无法在不修改源码的情况下构造违例路径 | `flintnde/routing.py:1339` | cannot-safely-trigger |
| 序列化器内部守卫：公开 schema 请求产生的结果均为 JSON 型，无法安全触达 | `flintnde/mathematica_bridge.py:838` | cannot-safely-trigger |
| savepoint 写盘时磁盘满/权限中途丢失：无法在本机安全模拟磁盘满 | `flintnde/savepoints.py:347` | cannot-safely-trigger |


## Findings（记录，不修改源码）

- 无。全部动态触发的用户句子均为含原因与下一步的完整自然语言句子。

- 无 finding，全部消息合规 case 的 `*MessageCompliant` 硬 check 均通过。

## 未执行边界

- 仅静态审阅的 Wolfram Failure tag（2 个）：PolynomialMatrixListRequired, WorkDirectoryCreationFailed。
- `PolynomialMatrixListRequired`（`Mathematica/FlintNDE.wl:226`）为防御性分支：公开入口的 `_List /; flintNDEPolynomialMatricesQ` guard 使非矩阵列表输入实际落入 catch-all `InvalidPartialFractionSystemArguments`，公开调用形态无法到达该分支。
- 仅静态审阅的 Python warnings.warn 出口（10 个）：位于数值输运/正规化/奇点折跃深层流程，需要长时数值运行或内部状态才能到达，本 case 不动态触发。
- 无法安全触发项见出口矩阵 cannotSafelyTrigger 段（非 Windows 分支、内部不变量、序列化器守卫、磁盘满写盘失败）。
- Wolfram 公开面没有 savepoint 落盘入口，savepoint 错误类别仅由 Python 通道（PY10）覆盖。
- flintnde/*.py 中数百处内部 raise 守卫不在逐项动态触发范围内；矩阵覆盖三通道公开出口与九类代表性错误（输入类型、维数、精度、路径、奇点、savepoint、unsupported capability、序列化、文件写出）。
- 失败硬 check：`无`。
- 机器 summary：`results/summary.json`；Wolfram 会话日志：`results_temp/wolfram-stdout.log`。
