# dS-IBP-Package

面向 de Sitter 圈图的 IBP 关系生成框架。目标是支持任意圈数、任意拓扑、massive/massless 混合的函数族，用统一 `J[...]` 表示生成圈动量 IBP、time-IBP/EOM canonical seed，并在后端导出 Kira user-defined system。

## 当前主线

- `000_code/004_dS_ibp_general.wl`：上一版 linear/Kira 导出骨架。
- `000_code/005_dS_ibp_general.wl`：当前主线接口版，新增 topology 初始化缓存、seed 分类、sampled linear-system、精确 sector 匹配。
- `000_code/check/004_seed_expected_examples.wl`：轻量结构与手推 seed 对照检查，优先加载 `005`。
- `000_code/check/run_004_seed_expected_examples.wl`：Wolfram runner。

## 关键约定

- 所有 sector 统一使用 `J[aList, linePacks, ispList]`。
- massive full line: `{b_e, n_{e,1}, n_{e,2}}`。
- massless full line: `{b_e, n_e}`，主线统一采用双 theta 合并路线。
- shrink sector 当前使用 `{bS_e}`；缩并后 `aList` 只保留 compact active slots，原顶点到 compact slot 的映射保存在 `sectorMetadataList`。
- seed 层必须立即应用 EOM 和 massless endpoint canonical，不允许 `n=2` 留到输出 seed。
- seed 保存为 Mathematica 表达式；Kira 导出只消费 linear-system 数据。

## 轻量检查

```powershell
& 'D:\Wolfram Research\Wolfram\15.0\wolframscript.exe' -file '000_code\check\run_004_seed_expected_examples.wl'
```

该检查只做小型 seed/metadata/linear/Kira 文件结构验证，不运行 Kira reduction，不做大范围解析生成。

## 笔记

- `000_note/dS_IBP_package_plan.md`
- `000_note/dS_IBP_package_design_note.md`
- `000_note/dS_IBP_seed_validation_plan.md`
- `000_note/dS_IBP_package_tech_note.tex`