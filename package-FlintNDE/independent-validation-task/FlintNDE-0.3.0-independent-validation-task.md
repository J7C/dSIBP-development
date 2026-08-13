# FlintNDE 0.3.0 独立检验任务书

日期：2026-08-13
对象：`versions/FlintNDE-0.3.0/` 公开 Python API
性质：独立验证；不得读取旧独立检验报告生成 expected

## 1. 目标与边界

验证 FlintNDE 0.3.0 的“原始点规划、计划序列化、既有计划执行、段内 dense output”数据链。
检验只消费公开入口 `plan_transport_path`、`planned_path_to_json`、
`planned_path_from_json`、`transport_planned_path_refined` 和
`relative_difference_inf`，不调用内部递推函数产生 expected，不修改程序包源码。

本任务不认证一般代数扩域、奇点折跃分支、Stokes connection、ramification 或
Lee--Moser 路线；这些能力边界继续由程序包自身门禁负责。

## 2. 独立参考系统

使用二维对角有理系统

```text
dY/dz = diag(1/(z-20), -2/(z+20)) Y,    Y(0)=(1,1)^T.
```

闭式参考为

```text
Y_1(z)=1-z/20,    Y_2(z)=(20/(z+20))^2.
```

expected 必须由上述闭式公式在 runner 中逐点直接求值，不得从 FlintNDE 输运结果、旧报告或
缓存反推。路径区域远离 `z=+20,-20`，因此本任务只验证缺省 `avoid` 路由，不涉及多值分支。

## 3. 900 点复平面网格

- 横坐标：`x=1/10,2/10,...,30/10`，共 30 个值。
- 纵坐标：`y=-29/20,-27/20,...,29/20`，共 30 个值。
- 点为 `z=x+i y`，共 900 个互异点。
- 输入顺序按纵坐标逐行；偶数行从左到右，奇数行从右到左，形成连续蛇形折线。
- 起点固定为 `z=0`，输入顺序和每一点坐标必须写入 retained summary。

## 4. 两条执行路线

### Route G：整体规划与 dense output

1. 一次调用 `plan_transport_path(system, 0, points)`。
2. 用 `planned_path_to_json(..., digits=80)` 写出 UTF-8 JSON。
3. 从磁盘以 `encoding="utf-8"` 读回，调用 `planned_path_from_json(..., system=system)`。
4. 在执行期间把规划器替换为会立即报错的 sentinel，再调用
   `transport_planned_path_refined`；必须返回
   `execution_action="execute_existing_plan_without_replanning"`，且 sentinel 调用次数为 0。
5. 从节点 snapshots 与 `sample_results` 恢复全部 900 个点的值，任何缺失、重复或顺序错位
   都判失败。

### Route N：独立逐点 naive

对 900 个点分别从同一起点 `z=0` 和同一边界 `Y(0)` 开始，逐点独立执行
`plan -> JSON round-trip -> transport_planned_path_refined`。各点之间不得复用计划、dense patch
或前一点传播后的边界。该路线用于与 Route G 逐点互检，并提供无跨点复用的基准耗时。

两条路线均使用 60 位十进制工作精度、主阶 40、参考阶 48、目标相对误差 `1e-30`；计时不含
Python import，分别记录 planning、JSON round-trip、execution 和总墙钟时间。

## 5. 必须保存的证据

工作目录：
`independent-validation/FlintNDE-0.3.0-validation-01-planned-complex-grid/`

- `run_validation.py`：唯一生产 runner，所有文本 I/O 显式 UTF-8。
- `results/plan_grouped.json`：Route G 实际执行计划。
- `results/summary.json`：配置、环境、源码哈希、实际节点、节点数、sample 数、逐段报告、
  两路线耗时、全部 900 点误差与总体门禁。
- `000_FlintNDE-0.3.0-validation-01-planned-complex-grid-report.md`：可独立阅读的正式中文报告，
  明确已验证和未验证边界。

## 6. 通过门禁

同时满足以下条件才可写 `overall_passed=true`：

1. 严格得到 900 个互异输入点和两条路线各 900 个结果。
2. Route G 的计划经 JSON 磁盘往返后执行；no-replanning sentinel 未被触发。
3. Route G 与闭式参考的 900 个相对无穷范数误差全部 `<1e-28`。
4. Route N 与闭式参考的 900 个相对无穷范数误差全部 `<1e-28`。
5. Route G 与 Route N 的 900 个逐点相对无穷范数差全部 `<1e-28`。
6. 两条路线的 `target_relative_error_met` 均为真。
7. summary 和 report 能以严格 UTF-8 解码，不含 Unicode replacement character。

效率只作当前主机、当前 case 的实测结论，不作为数学正确性门禁。报告必须给出 Route G 的
真实节点规划和 Route N 的 900 次独立规划数量，不能只给速度倍率。
