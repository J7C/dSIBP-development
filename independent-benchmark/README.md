# independent-benchmark 文件夹用途

本文件夹用于交付独立推导任务和推导冻结后使用的程序。它不是本项目现有 expected、check 或运行结果的输出目录。

- 本 `README.md` 只说明目录边界；权威任务文件是 `independent-benchmark.md`。
- `independent-benchmark.md` 本身就是交给其它 AI 的完整任务说明书，不是等待补充手推答案的结果文件。
- `package/` 只含当前程序 `package_012.wl`、正式用户手册 `package_012.pdf` 和 `examples/` 下三个典型应用文件；不含无版本名旧副本、expected、验证脚本、plan、design 或技术笔记。
- 任务书只自包含最基本的函数定义、SK 费曼规则、massless 有序单 `n` 基底 convention、统一 `J` 的逐槽物理含义，以及每个待测函数族的固定 topology/notation。
- H/h 的微分方程、Wronskian、导数递推和具体 shrink 公式是独立 benchmark 的待推导答案，不在输入目录中提供；外部 AI 也不得从 package note 补读这些结论。
- 第一阶段只读任务书，不得读取 `package/`、`000_code/`、现有 check、expected 或运行结果。手推结果与推导记录冻结后，第二阶段才可打开 `package/`，按正式手册学习调用并自行比较。
- 本项目自己的手推关系、程序 expected 和测试输出禁止放在本文件夹。
- 外部 AI 的推导结果也应输出到它自己的独立目录，再由维护者人工审查后决定是否导入项目 check。

本项目内已经审查并采用的手推关系统一存放在：

`000_code/check/hand-derived-v2/<family-name>/`

新的外部推导结果只有在完成来源隔离、逐式人工审查和 package 对照后，才可进入 `hand-derived-v2/`。
