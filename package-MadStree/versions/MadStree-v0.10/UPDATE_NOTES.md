# MadStree v0.10 更新说明

English version: [UPDATE_NOTES_en.md](UPDATE_NOTES_en.md)。

## 基线与定位

- 在 v0.9 基础上修改建立；v0.9 冻结并对应远端 tag `MadStree-v0.9`。
- 本轮按用户要求继续原位完善 v0.10，没有新开版本号。
- 主题：多变量折线的两阶段路径规划、缺省避开奇点、显式奇点折跃、奇点领头阶（LO）
  记录、点结果坐标化和高精度序列化。
- MadStree 负责多变量用户路径、dlog letters、边界 normalization 与主积分顺序，并把每一段
  拉回为单变量系统。FlintNDE 仍是通用单变量矩阵 DE 包；它内部自动认证
  `A(x)=P(x)+Sum R_j/(x-p_j)`（`P` 可为任意次数）并在适用时采用快速路线，
  该特化不是 MadStree 专属 dlog-only 接口。
- v0.10 的 `Vendor/FlintNDE` 与独立 FlintNDE 0.3.0 保持同一实现。

## 新增与修改

1. **真正的两阶段合同**：`MSGeneratePath` 完成多变量折线规划、仿射拉回和后端
   plan-only 调用；返回值保存完整节点、sample 路由、奇点折跃几何和 `serializedPlan`。
   `MSEvaluatePlannedPath` 只反序列化并执行这些计划，后端不再调用规划器。规划和执行
   本来就是两个命令，因此不另设“是否规划”选项。
2. **缺省避开奇点**：`SingularityMode -> "Avoid"` 是缺省。相邻用户点连线命中奇点时
   返回问题点对、奇点和最小距离，不静默穿越。只有显式
   `SingularityMode -> "SingularityJump"` 才启用奇点折跃。
3. **折跃术语、奇点折跃与分支责任**：任何经过中途节点的多点输运都称为折跃；只有显式
   穿过奇点并用局部基连接两侧匹配点时才称为奇点折跃。进入奇点步长范围后建立入射/出射
   桥；过奇点后依次检查后续用户点，取仍在一步范围内的最后一点为下一节点；若首点已超
   范围，先沿其方向走一个允许步长回到普通节点状态。奇点折跃选择的多值分支等价于某条
   绕行路径，用户必须自行确认。
4. **复仿射组与缓存求值**：输入点按 exact 复线性相关划分为最大连续
   `x(s)=x0+s v` 组，每组只拉回一次。组内复参数点落在同一 Taylor 收敛圆盘时共用
   节点解系数，不要求它们位于同一实线段；节点点和 dense 点都按 `userIndex` 完整返回。
   不同组只继承公共点数值，不共享局部系数，因此没有多变量 Taylor 球。
5. **奇面点与 LO**：裸坐标缺省保存，`{coord,"tmp"}` 为临时途经点，
   `{coord,"lo"}` 请求沿到达方向的领头阶。奇面上的用户点统一剔除并报告重连；
   LO 记录携带坐标、用户序号、重合 letters、到达方向、分支、指数、领头向量和路径依赖说明。
   不支持的共振局部基返回 `leadingOrderRefused`，不伪造数值。
6. **点结果格式**：每个结果均携带 `coordinate`、`value`、`status` 和
   `userIndex`。
7. **双语提示**：`MessageLanguage -> "EN"|"CN"`，缺省英文。规划时提示当前
   缺省/显式路径模式，执行时提示只执行已有计划；奇点折跃模式合并提示分支责任。
8. **单顶点路线统一**：single-vertex massiveExternal 使用通用“边界领头项 +
   FlintNDE Frobenius 递推”路线。2411.03088 Sec.3.3 显式多变量级数只作为测试 oracle，
   不进入生产分派。
9. **边界与 blow-up 结论**：嵌套权重和 `RankOrder` 选择多变量 blow-up chart；
   进入 FlintNDE 后是沿该一参数曲线的普通点/正则奇点矩阵 DE。MadStree 不在数值后端
   重做多变量 blow-up。反 blow-up 后的领头边界系数由 component endpoint 系数乘积及
   sector normalization 给出，不依赖把单顶点显式级数保留为生产特例。
10. **常量 letter 段**：若一段上全部 dlog letters 都是常量，拉回连接严格为零；后端构造
   无有限极点的零系统并正常输运，不再以“没有极点”为由拒绝。

## 精度、序列化与缓存修复

- FlintNDE 工作位数按
  `ceil(WorkingPrecision*log2(10))+32` 自适应设置；70、100 位分别为 265、365 bit。
- 路径记录规划精度；节点和奇点折跃几何保存 Arb `midpoint/radius/exponent`。
  执行 `WorkingPrecision` 高于规划值时结构化拒绝并要求重新运行
  `MSGeneratePath`。
- 线段投影、匹配比例、旋转因子与 winding/monodromy 均使用当前 Acb/Arb 精度，不经过 Python `complex` 或 binary64 几何。
- 成功缓存键除请求外，还包含 `Backend/flintnde_transport.py`、Vendor
  `pyproject.toml` 与排序后的 `flintnde/*.py` 的 SHA-256。当前版本原位修复
  会自然使用新的缓存身份，不需要用户手动清理。
- 修复 LO 到达节点的 `FirstPosition` 条件误匹配 Association 内部 Rule 而产生的
  `Rule::argr`；现已无该消息。
- 结构化拒绝仍原样返回且不写入成功缓存。

## 公开接口

- 路径主线：`MSGeneratePath`、`MSEvaluatePlannedPath`、`MSPlannedPathQ`。
- 结果导出：`MSExportEvaluationData`。
- 奇点策略：`SingularityMode -> "Avoid"|"SingularityJump"`，缺省 `"Avoid"`。
- 消息语言：`MessageLanguage -> "EN"|"CN"`，缺省 `"EN"`；值严格区分大小写。
- adapter 只接受六个现行 plan/execute schema；Association 和 JSON 记录严格拒绝缺字段、
  多余字段、未知模式和值的宽松大小写。
- `$MadStreeVersion` 为 `"0.10"`。
## 验证状态

- 路径专项：53/53 通过，包含缺省避奇点、显式奇点折跃、零连接段、
  高精度拒绝、EN/CN、计划直接执行、LO 正式合同和无 `Rule::argr`。
- Python adapter：10/10 通过；非共振奇点折跃 plan/execute Arb round-trip，并用规划器哨兵
  确认执行期未重新规划。
- 12 个 Wolfram 开发测试文件全部通过，合计 221/221；单顶点显式级数 oracle 与通用路线的互检为 8/8、10/10。
- Examples 01--05：5/5 全部退出 0。
- Vendor 与独立 FlintNDE 0.3.0 的 26 个共同交付文件 SHA-256 全部一致；双方 pyproject.toml 版本均为 0.3.0。

## 使用要求

- 先运行 `path = MSGeneratePath[...]` 并检查计划，再调用
  `MSEvaluatePlannedPath[context,path,...]`。
- 需要奇点折跃时显式给 `SingularityMode -> "SingularityJump"` 并确认分支；缺省不穿越奇点。
- 规划和执行使用相同 `WorkingPrecision`；需要更高精度时重新规划。
- 用户点只使用裸坐标、`{coord,"tmp"}` 或 `{coord,"lo"}`。
## 已知限制

- 共振/Jordan/log 只有在 FlintNDE exact local-basis 门禁支持时才可数值奇点折跃；否则返回
  结构化拒绝。
- MadStree 不生成一般 IBP 方程组、不运行 Kira；Python 解释器仍按零探测策略由显式选项、
  `MADSTREE_PYTHON` 或 PATH 选择。
