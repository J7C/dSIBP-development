# MadStree 子项目规则

## 适用范围与权威入口

本文件适用于 `package-MadStree/` 及其全部子目录，只保存 agent 必须遵守的版本、目录、输出和独立验证工作流。公式、convention、接口和实现细节以当前版本的 `Documentation/` 和 README 为准；任务状态以项目根目录 `研究计划与研究进度.md` 为准。

收到 MadStree 的新开发、推导、验证或文档任务时，必须先更新项目根目录 `研究计划与研究进度.md`，再修改本子项目文件。

## 版本规则

- 当前工作版本由 `VERSION_INDEX.md` 指定；`load_current.wl` 只服务交互使用，正式验证和可复现计算必须显式加载版本目录。
- 是否升版只由用户明确指令决定，不由代码、公式或接口的改动类型或大小自动触发。用户未要求升版时，修订继续写入当前工作版本。
- 用户明确要求新开或发布版本后，才建立新的 `versions/MadStree-vX.Y/`。新版本建立并验收后，
  工作树只保留该唯一当前版本；此前版本从 Git 历史恢复，不保留旧入口、旧测试或旧任务书。
- 版本号必须在版本目录名、`VERSION.md`、公开版本字符串、验证任务书、验证目录和验证报告中保持一致。
- 本规则生效后新建的版本目录必须包含 `UPDATE_NOTES.md`；v0.3 及此前已经存在的版本不追溯补建。更新说明至少列出基线版本、新增功能、修复、接口或 convention 变化、迁移要求、验证状态和已知限制，不得只写版本号或提交列表。
- 建议每个新版本从当前稳定主线建立独立 branch 后再开发和验证。是否创建 branch、是否长期保留以及是否合并回主线均由用户决定；用户未明确要求时，agent 不得自动创建或合并版本 branch。

## 固定目录结构

```text
package-MadStree/
|- AGENTS.md
|- README.md
|- VERSION_INDEX.md
|- load_current.wl
|- versions/
|  `- MadStree-vX.Y/
|     |- VERSION.md
|     |- UPDATE_NOTES.md
|     |- README.md
|     |- Kernel/
|     |- Backend/
|     |- Documentation/
|     |  |- DEVELOPMENT_PLAN.md
|     |  |- todolist_temp.md
|     |- Examples/
|     |- test/
|     `- results_temp/
|- independent-validation-task/
|  `- MadStree-vX.Y-independent-validation-task.md
`- independent-validation/
   `- MadStree-vX.Y-validation-NN-short-name/
      |- run_validation.wls
      |- 000_MadStree-vX.Y-validation-NN-report.md
      |- results/
      `- results_temp/
```

- `versions/MadStree-vX.Y/` 保存该版本源码、适配器、手册、examples 和开发测试。版本内临时测试产物只进其 `test/results_test/`；历史遗留或可重跑中间数据只进 `results_temp/`。
- `independent-validation-task/` 只保留当前版本任务书。任务书不得复制进验证目录。
- `independent-validation/` 下每项验证单独建目录，目录名必须包含被验证版本号和任务编号。
  只保留当前版本下互不替代的正式 case；验证程序、专用独立 oracle、轻量正式结果和自动
  报告都归该任务目录所有。
- 验证目录的 `results/` 保存机器可读 summary、最终差值、计时和支撑结论的轻量证据；不得反向成为 package 生产输入。
- 验证目录的 `results_temp/` 保存 JSON、日志、Python cache、checkpoint、路径分段和其它可重跑中间文件，缺省不作为项目正式资产。
- MMA 自动调用 FlintNDE 时，运行文件必须生成在调用脚本所在目录的 `results_temp/`，不得写入 `versions/.../Kernel/`、`Backend/` 或其它 package 源码目录。
- 正式报告文件名以 `000_` 开头，使其在对应验证目录中排在最前；验证目录内不另放任务书副本或重复报告。

## 独立验证报告合同

每个 `run_validation.wls` 必须自动生成本任务的 `000_...report.md` 和 `results/summary.wl`。报告应当简短，但必须自包含以下信息：

- 验证对象、版本、源码身份或 digest、状态和通过计数；显式写出所用 convention、Hankel branch、master/basis 顺序及必要的 normalization。
- 所选数值点：列出用户/物理变量中的精确坐标及实际用于计算的变换坐标；说明该点是普通点还是边界/奇点起点，并给出避开相关 DE letter、共振层或收敛边界的简要依据。
- 实际路径：按顺序列出边界或奇点起点、anchor、分段路径、绕行或 blow-up chart、终点，以及各段使用的坐标。若 FlintNDE 自动生成路径，报告保存其实际返回的路径摘要，不能只写“自动输运”。
- 展开与精度：分别记录边界 Frobenius/级数阶数、局部奇点展开阶数、普通点输运阶数、reference/refinement 阶数、工作精度、误差目标；不适用的项目明确写 `不适用`。
- 耗时：至少记录总 wall time；能够分离时同时记录边界生成、独立 oracle、局部展开、路径输运和比较/报告阶段的 wall time。计时单位统一为秒。
- 数值证据：记录 exact residual、逐分量或最大绝对/相对差、refinement 估计、capability/奇点分类及输出文件路径。
- pending、失败或提前停止时仍保留上述字段。未真正执行的数值点、路径、展开和计时必须标为 `未执行`，同时写明阻断原因；计划参数不得冒充实际执行参数。

验证程序应把上述字段同时写入 `results/summary.wl`，使报告内容可以机器复核。算一个保存点就写出一个结果；最终再汇总，不得只在全部计算完成后一次性保存而丢失已完成证据。

## 修改与检查

- 新建、移动或清理目录前，先检查其用途、Git tracked/ignored 状态及是否属于用户未提交改动；不得删除无关资产。
- 修改验证程序后，至少检查 Wolfram 文件章节标记、路径集中配置、报告字段完整性和 `git diff --check`。实际数值验证未运行时必须明确报告，不得用静态检查代替执行结论。
- 版本、目录或报告规则变化时，同步更新本文件、顶层 README、`VERSION_INDEX.md`、对应独立验证任务书和项目根目录进度表，避免建立并行规则源。
