# independent-benchmark 文件夹用途

本文件夹用于交付独立推导任务和推导冻结后使用的程序。它不是本项目现有 expected、check 或运行结果的输出目录。

- 本 `README.md` 只说明目录边界；权威任务文件是 `independent-benchmark.md`。
- `independent-benchmark.md` 本身就是交给其它 AI 的完整任务说明书，不是等待补充手推答案的结果文件。
- 根目录 `check-smoke/` 只供 package 维护者做轻量 smoke/check/test；独立执行者禁止读取、复制、写入或引用该目录，不得把其中内容作为 expected、比较器、先验结论或失败归因依据。
- `package/` 只保留当前最新的一对 `package_<三位版本>.wl/pdf` 与 `examples/` 下少量典型应用文件；不含旧版本副本、无版本名副本、expected、验证脚本、plan、design、技术笔记或 reduction 输出。
- 每轮独立审计必须完整执行任务书第 2--17 节：从头建立第 9 节八个 graph-valid loop family、两个 atomic `timeOnly` family、第 14 节两个 pure-time/tree family、全面物理工程/Kira 闭环、根号坐标层，以及显式双动量列表、多重图/routing、cycle/bridge pack、参数重定义、bubble+tree 六变量和全 family 参数闭合。章节顺序只表示功能依赖层级，不允许跳过前序范围或沿用旧 expected/报告。全部 expected 冻结后，按任务书的动态解析规则只加载 `package/` 中唯一提供的最新版本 package 做全量单向比较，不得写死版本号或改从仓库源码目录加载。
- 第 17.3--17.4 节的“自定义变量成功”要求同时通过逐变量 `ds`、全部 seed/`linearData`、重新生成的 loop `DSDE` 和 tree naive/dlog DE；只看到 metadata 中的变量名改变不算通过。计算结果禁止残留被替换旧坐标，旧规则只可保留在明确的 provenance/audit 字段。
- ISP 输入使用当前最新 package 的公开 `<|"name"->rho,"expr"->sp[...],"range"->{...}|>` schema；任务书、手推槽位和第二阶段 package 调用之间不设置字段名 adapter。
- 所有含 massive line 的 family 都对直接 h 做独立手推与 package 验证。裸 H 只选 `atomic_massive_line` 和 `pure_massive_bubble_reference` 两个 family；二者还必须比较裸 H `T=I`、H 经独立推导的 `T_Htoh` 变到 h，以及变换后结果与直接 h 的一致性。
- H/h 的微分方程、Wronskian、导数递推和具体 shrink 公式是独立 benchmark 的待推导答案，不在输入目录中提供；外部 AI 也不得从 package note 补读这些结论。
- 第一阶段只读任务书，不得读取 `package/`、`000_code/`、现有 check、expected 或运行结果。唯一例外是任务书第 13.2 节的 reference bubble 求导对照，可额外读取其中点名的 `001 bubble_ibp_sym.m` 和 `002 bubble_de.m`。手推结果与推导记录冻结后，第二阶段才可打开 `package/`，按正式手册学习调用并自行比较。
- 本项目自己的手推关系、程序 expected 和测试输出禁止放在本文件夹。
- 外部 AI 的推导结果也应输出到它自己的独立目录，再由维护者人工审查后决定是否导入项目 check。

## 独立检验位置与报告回收

独立检验分为两条路线：

- **内部检验**：由本项目 agent 在当前项目文件夹中新开独立会话，工作区使用 `codex-independent-benchmark/`。最终报告不留在该工作区，统一写入根目录 `000-report/`。
- **外部检验**：由外部 agent 在本项目以外的独立文件夹完成。维护者查阅并确认报告的来源隔离、程序版本和证据后，把原报告复制到本项目 `000-report/` 备份；项目内不得只保留外部路径引用。

两类报告统一命名为 `{时间}-{currentVersion}-{内部/外部}.md`，其中时间格式为 `YYYY-MM-DD-HHmm`，`currentVersion` 是任务书在 Phase 2 动态解析出的三位程序版本 token。附件放在同名并追加 `-附件` 的目录。旧报告、`report-of-report`、针对报告的 battle 或临时争论稿不作为正式交付物保留。

既有内部冻结 expected、单向比较脚本、运行结果和工作区已清理，正式归档报告及附件继续保留。后续内部检验必须重新建立空的独立工作区，并把新报告归档到 `000-report/`；新的外部推导结果只有在完成来源隔离、逐式人工审查和当前最新 package 对照后，才可按当前版本规则导入，不得写回 `independent-benchmark/` 交付目录。

已有报告不构成本轮证据。只有本轮第 2--17 节新的冻结手推、单向比较、两次规定的 fresh reduction 闭环和以 `currentVersion` 命名的正式报告全部完成，才能宣称 source-isolated 全量审计通过；任何未执行章节必须明确报告为未完成。
