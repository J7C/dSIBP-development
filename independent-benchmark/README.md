# independent-benchmark 文件夹用途

本文件夹只用于保存“交给其它 AI 独立推导 benchmark”的任务说明。它是独立验证任务的输入目录，不是本项目手推结果不完整的输出目录。

- 本 `README.md` 只说明目录边界；权威任务文件是 `independent-benchmark.md`。
- `independent-benchmark.md` 本身就是交给其它 AI 的完整任务说明书，不是等待补充手推答案的结果文件。
- 独立推导者只读取本文件夹中的说明，不读取 `000_code/`、现有 check、expected 或运行结果。
- 本项目自己的手推关系、程序 expected 和测试输出禁止放在本文件夹。
- 外部 AI 的推导结果也应输出到它自己的独立目录，再由维护者人工审查后决定是否导入项目 check。

本项目内已经审查并采用的手推关系统一存放在：

`000_code/check/hand-derived-v2/<family-name>/`

当前重建期间，项目内旧手推目录会被整体清除；新结果只在重新推导并审查后进入 `hand-derived-v2/`。
