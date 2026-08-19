# FlintNDE 版本索引

## 当前版本

- 版本：`0.4.0`
- 源码与测试：`versions/FlintNDE-0.4.0/`
- Python import：`flintnde`
- Wolfram Language：把版本根加入 `$Path` 后使用 `Needs["FlintNDE`"]`
- 手册：`Documentation/FlintNDE.pdf`
- 状态：当前工作版本。在 0.3.0 路径与奇点能力上新增节点覆盖桶的 fast multipoint
  evaluation，以及公开 `direct_user_point_path` 严格用户节点链入口。
- 同步合同：MadStree v0.13 的 `Vendor/FlintNDE` 与本版本共同实现保持逐文件同字节。
- 当前独立检验：validation-01 验证 fast multipoint/严格用户节点路线，validation-02 验证
  regulator 复角域与候选容量；均以各目录内 fresh 自动报告为正式状态。

## 工作树保留

- `0.4.0`：唯一当前工作版本。

0.3.0 及更早版本已从工作树删除，只能从 Git 历史恢复。新版本只在用户明确要求后建立，
并在对应版本目录内增加 `UPDATE_NOTES.md`；新版本验收后删除旧版本目录和旧版本验证资产。
