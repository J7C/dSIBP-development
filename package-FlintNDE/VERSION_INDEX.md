# FlintNDE 版本索引

## 当前版本

- 版本：`0.4.0`
- 源码与测试：`versions/FlintNDE-0.4.0/`
- Python import：`flintnde`
- Wolfram Language：把版本根加入 `$Path` 后使用 `Needs["FlintNDE`"]`
- 手册：`Documentation/FlintNDE.pdf`
- 状态：当前工作版本。在 0.3.0 路径与奇点能力上新增节点覆盖桶的 fast multipoint
  evaluation，以及公开 `direct_user_point_path` 严格用户节点链入口。
- 同步合同：MadStree v0.11 的 `Vendor/FlintNDE` 与本版本共同实现保持逐文件同字节。
- 当前独立检验：`independent-validation/FlintNDE-0.4.0-validation-01-fast-multipoint-and-direct-path/`；
  以目录内 fresh 自动报告为正式状态，旧 0.3.0 报告只证明冻结版本。

## 保留版本

- `0.2.0`：冻结源码与测试，不再回写。
- `0.3.0`：冻结源码与测试，不再回写。
`0.1.0` 及更早版本按只保留最新三个版本的规则从工作树删除，可从 Git 历史恢复。
新版本只在用户明确要求后建立，并在对应版本目录内增加 `UPDATE_NOTES.md`；冻结版本不得回写。
