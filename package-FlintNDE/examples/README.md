# Examples

仓库内示例通过脚本顶部的 `PACKAGE_ROOT` 路径变量加载当前 `versions/FlintNDE-0.1.0/`，不复制程序包
源码，也不读取项目外其它代码包。发布用户应先安装 `FlintNDE`，随后在任意调用目录直接
`import flintnde`；路径变量只服务于尚未安装的仓库内开发示例。

当前保留三个典型示例：

- `qnm_2x2.py`：统一 `u` 的 exact 2x2 一阶系统。分别从字面量 horizon `1` 和
  infinity `"inf"` 的 `{a,b,C}` 边界出发，输运到公共匹配点并检查另一端的禁戒分量；
  同时运行一个轻微偏移频率作为反事实对照。
- `regular_singular_save.py`：标量正则奇点，从 `{a,b,C}` 起点输运到普通点，并保存可复用奇点边界和普通终点。
- `exponential_boundary_save.py`：严格解耦的指数型奇点，从 `{phi,a,b,C}` 起点输运，保存并重新读入同一边界。

运行：

```powershell
python qnm_2x2.py
# 或显式选择 convention
python qnm_2x2.py --config ../config/qnm_u_unified_it0_3_it1_minus1.json
python regular_singular_save.py
python exponential_boundary_save.py
```

正式摘要写入 `results/qnm_2x2/summary/qnm_2x2_summary.json`；初始化布局说明写入
`results/qnm_2x2/configuration/output_layout.json`。两条路径均由调用脚本传入
`__file__` 后通过 package 公共接口生成，不依赖启动时的工作目录。
`it0/it1` 只从实际 config 读取并写回 summary。无穷远自动使用 start-only
`formal_exponential_asymptotic`；最近指数根差和缺省四倍最小项阶数规则自动生成首匹配点，
结果固定保留指定 N 阶并记录后五阶/前五阶矢量块比、五阶相对 refinement 和辅助最小项信息。
块比不小于 1 时 warning 但仍保存结果；自动点和附近点另与独立二阶标量递推交叉验证。

后两个脚本抽自当前 `tests/test_save_points.py` 已执行的公开调用配置。它们把输出写到本 example 调用目录下的 `results/`；本轮整理只做语法和相对路径检查，不另作数值通过声明。
