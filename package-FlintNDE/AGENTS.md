# FlintNDE 项目规则

## 项目边界

FlintNDE 是与物理模型无关的 Python/FLINT 矩阵微分方程后端。它消费矩阵 DE、普通点向量、
正则奇点 `{a,b,C}` 或已认证指数型奇点 `{phi,a,b,C}` 边界，负责局部解、路径规划、数值
输运和保存点；不得读取 MadStree/dSIBP 的积分族、主积分顺序或 normalization。

## 目录与版本

- 当前源码和测试：`versions/FlintNDE-0.4.0/`。
- 手册与论文规划：`Documentation/`。
- 用户示例：`examples/`；配置：`config/`；专项验证和开发测试保留在各自 `check_*`、`test/`。
- 是否升版只由用户决定。新版本进入 `versions/FlintNDE-X.Y.Z/`，冻结旧版本，并在新版本
  内增加 `UPDATE_NOTES.md`。工作树只保留最新三个版本，更早版本从 Git 历史恢复。

## 数值与输出门禁

- exact Q(i) 输入优先走 exact 路线；不支持的代数扩域、ramification、Lee--Moser 原基逆
  local jet 或缺 Stokes connection 的中间/终点必须 fail closed，不能伪装成普通点继续。
- `(coordinate,"save")` 不带点名。普通点、正则奇点和 continuation-ready 指数型奇点均
  逐点即时写入调用目录；formal start-only 输出必须标记 `continuationReady=false`。
- package 源码目录不得接收运行 JSON、cache、保存点或结果。正式结果进调用脚本旁的
  `results/`；测试输出进 `test/results_test/`，可重跑中间产物进 `results_temp/`。
- Python cache 可以保留本地复用，但不得提交。修改公开格式或奇点路由必须增加 round-trip、
  错误输入和 fail-closed 测试，并运行完整 `unittest`。

## 文档与发布

接口、schema、能力边界或路径改变时同步更新根 README、版本 README、`Documentation/FlintNDE.tex`
和 `PAPER_PLAN.md`。发布前编译并检查 PDF，运行完整测试和 `git diff --check`，再由仓库根流程
提交；不得自行改变 GitHub visibility 或合并版本 branch。
