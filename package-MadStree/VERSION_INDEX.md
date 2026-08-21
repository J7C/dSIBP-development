# MadStree 版本索引

## 当前版本

- 版本：`v0.15`
- 目录：`versions/MadStree-v0.15/`
- 状态：当前工作版本
- 数值后端：版本内嵌 FlintNDE `0.5.0` 同步副本
- 当前接口：`MSEvaluatePath[context, pointSequence, ParameterRules -> {...}, ...]`
- 点输入合同：`pointSequence` 首行是有序可跑动坐标符号，后续是等宽坐标值行；单点只有
  一行值，多点追加值行。固定、不可偏导参数只在 `ParameterRules` 中一次给出。
- 职责边界：MadStree 只划分最大连续复仿射单变量段并各拉回一次；FlintNDE 在同一
  Python 进程内完成边界初始化、可选路径规划、输运和多点求值。
- 拓扑接口：顶点用 `"vertexType" -> "+"|"-"` 指定轮廓支并以
  `"externalLegEnergy"` 给出外腿指数参数；传播子只输入
  `"type" -> "massive"|"massless"`，内部 SK 分类完全由端点派生。
- 兼容策略：v0.15 不读取、不转发也不保留旧 `energy`、`phaseSign`、`skType`、`sigma`、
  `phaseSigns`；它们作为额外键出现时被忽略，不能替代必需字段或覆盖端点派生值。六种带
  Full/Cross/External 后缀的旧公开线型因非法 `type` 取值失败。

## 工作树保留

- `v0.15`：唯一当前工作版本。

v0.15 及更早版本在当前验收后从工作树删除，只能从 Git 历史恢复。当前目录只保留 v0.15
任务书及当前版本正式 validation cases；旧版本任务书、报告和结果不另行归档。

## 升级规则

是否升级只由用户明确指令决定。新版本建立后旧版本冻结；目录名、运行时版本字符串、
更新说明、任务书、验证目录和报告必须使用同一版本号。
