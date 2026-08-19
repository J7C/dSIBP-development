# dSIBP 版本索引

## 当前版本

- 代码版本：`022`
- 正式发布：`022.0`
- 模块化入口：`versions/022_dSIBP/`
- 状态：当前开发主线（破坏性 topology schema；顶点统一为 `vertexType/externalLegEnergy`，line 的 SK/pack/contact 元数据只由内部派生）
- 更新说明：`versions/022_dSIBP/UPDATE_NOTES.md`

## 工作树保留

| 版本 | 目录 | 状态 |
| --- | --- | --- |
| 022 | `versions/022_dSIBP/` | 当前开发主线，正式发布号 022.0 |

021 及更早代码版本在 022 验收后从工作树删除，只能从 Git 历史恢复。当前入口、smoke、examples 和
正式单文件交付都不得加载或转发旧版本。
