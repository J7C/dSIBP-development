# independent-benchmark 文件夹用途

本文件夹用于交付独立推导任务和推导冻结后使用的程序。它不是本项目现有 expected、check 或运行结果的输出目录。

- 本 `README.md` 只说明目录边界；权威任务文件是 `independent-benchmark.md`。
- `independent-benchmark.md` 本身就是交给其它 AI 的完整任务说明书，不是等待补充手推答案的结果文件。
- `package/` 只保留当前 `package_016.wl/pdf` 与 `examples/` 下少量典型应用文件；不含旧版本副本、无版本名副本、expected、验证脚本、plan、design、技术笔记或 reduction 输出。
- 任务书第 2--15 节保存 014 物理 benchmark，第 16 节保存 015 根号坐标 adapter，第 17 节独立验证 016 的显式双动量列表、多重图/routing、cycle/bridge pack、pure-time、参数重定义和 exact/over/under 门禁。全部 expected 冻结后只加载当前 016 交付做比较。
- ISP 输入与 014 package 共用 `<|"name"->rho,"expr"->sp[...],"range"->{...}|>` schema；任务书、手推槽位和第二阶段 package 调用之间不设置字段名 adapter。
- 所有含 massive line 的 family 都对直接 h 做独立手推与 package 验证。裸 H 只选 `atomic_massive_line` 和 `pure_massive_bubble_reference` 两个 family；二者还必须比较裸 H `T=I`、H 经独立推导的 `T_Htoh` 变到 h，以及变换后结果与直接 h 的一致性。
- H/h 的微分方程、Wronskian、导数递推和具体 shrink 公式是独立 benchmark 的待推导答案，不在输入目录中提供；外部 AI 也不得从 package note 补读这些结论。
- 第一阶段只读任务书，不得读取 `package/`、`000_code/`、现有 check、expected 或运行结果。唯一例外是任务书第 13.2 节的 reference bubble 求导对照，可额外读取其中点名的 `001 bubble_ibp_sym.m` 和 `002 bubble_de.m`。手推结果与推导记录冻结后，第二阶段才可打开 `package/`，按正式手册学习调用并自行比较。
- 本项目自己的手推关系、程序 expected 和测试输出禁止放在本文件夹。
- 外部 AI 的推导结果也应输出到它自己的独立目录，再由维护者人工审查后决定是否导入项目 check。

## 独立检验位置与报告回收

独立检验分为两条路线：

- **内部检验**：由本项目 agent 在当前项目文件夹中新开独立会话，工作区使用 `codex-independent-benchmark/`。最终报告不留在该工作区，统一写入根目录 `000-report/`。
- **外部检验**：由外部 agent 在本项目以外的独立文件夹完成。维护者查阅并确认报告的来源隔离、程序版本和证据后，把原报告复制到本项目 `000-report/` 备份；项目内不得只保留外部路径引用。

两类报告统一命名为 `{时间}-{版本}-{内部/外部}.md`，其中时间格式为 `YYYY-MM-DD-HHmm`，版本为三位程序版本号，例如 `2026-07-21-1600-012-内部.md`。附件放在同名并追加 `-附件` 的目录。旧报告、`report-of-report`、针对报告的 battle 或临时争论稿不作为正式交付物保留。

本项目内 014 全面独立手推、015 根号坐标和 016 显式动量/指标增量的冻结 expected 与单向比较位于 `codex-independent-benchmark/`，正式报告统一归档到 `000-report/`。新的外部推导结果只有在完成来源隔离、逐式人工审查和 package 对照后，才可按当前版本规则导入；不得写回 `independent-benchmark/` 交付目录。
