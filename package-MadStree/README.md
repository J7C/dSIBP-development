# MadStree 版本与验证入口

MadStree 是以 Wolfram Language 为主体、自动调用 FlintNDE 数值后端的 dS time-integral 公式程序包。当前工作版本为 `v0.3`。

## 目录

- `versions/MadStree-v0.3/`：v0.3 的 Wolfram 源码、Python 适配器、手册、examples 和开发测试。
- `AGENTS.md`：MadStree 的版本、目录、输出和独立验证报告规则。
- `independent-validation-task/`：单列的独立验证任务书；不复制到验证工作目录。
- `independent-validation/MadStree-v0.3-validation-*/`：按验证任务分开的程序、结果和自动报告。
- `VERSION_INDEX.md`：当前版本、状态和版本升级记录。
- `load_current.wl`：加载 `VERSION_INDEX.md` 指定的当前版本；正式复现应使用显式版本路径。

## 版本规则

是否升级版本只由用户的明确指令决定，不由改动类型或改动大小自动触发。用户未要求升版时，代码、公式和接口的小改动继续写入当前工作版本；用户明确要求新开或发布版本后，才从当前工作版本复制建立新的 `MadStree-vX.Y/` 目录。新版本建立后，此前版本冻结并永久保留，不得覆盖或删除。

显式加载 v0.3：

```wl
madStreeRoot = ".../package-MadStree";
AppendTo[$Path, FileNameJoin[{madStreeRoot, "versions", "MadStree-v0.3", "Kernel"}]];
Needs["MadStree`"];
```

运行时生成的适配器 JSON 和 Python cache 写入调用脚本目录的 `results_temp/`，不写入版本源码目录。用户以 `FlintNDESavePoints -> {{coordinate,"save"},...}` 标出的路径点会逐点即时写入调用目录的 `results/flintnde_save_points/run-UUID/`，成功后同目录生成汇总 JSON；保存点不接受名称字段。正式结果由调用程序写入自己的 `results/`。

## 独立验证

每个验证任务目录名必须包含被验证版本号。目录内的 `run_validation.wls` 负责执行检查、保存机器可读结果，并生成按名称排序位于最前面的 `000_MadStree-vX.Y-...-report.md`。报告必须包含验证目标、版本与源码身份、输入、所选数值点、实际路径、各类展开阶数、工作精度、分项或总耗时、实际执行结果、失败边界和结果文件；因此验证目录内不再放任务书副本。完整合同见 `AGENTS.md`。

v0.3 的 T1--T6 已于 2026-07-30 fresh 通过，计数依次为 `20/20`、`12/12`、`18/18`、`15/15`、`17/17`、`16/16`。任务书位于 `independent-validation-task/MadStree-v0.3-independent-validation-task.md`，每项的程序、机器 summary 与自动报告位于对应的版本化验证目录。开发回归另为 MadStree `115/115`、FlintNDE `68/68`，不替代独立验证结论。
