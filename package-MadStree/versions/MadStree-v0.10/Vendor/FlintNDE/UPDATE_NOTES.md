# FlintNDE 0.3.0 更新说明

## 基线与定位

- 在 0.2.0 基础上修改建立；0.2.0 及更早版本冻结，不回写。
- 0.3.0 继续定位为与物理模型无关的单变量一阶矩阵微分方程求解器。它不读取 MadStree
  的 dlog letters、主积分顺序、normalization 或多变量图信息。
- 独立包与 MadStree v0.10 的 `Vendor/FlintNDE` 保持同一份 FlintNDE 实现和
  `pyproject.toml` 版本。本轮按用户要求原位完善 0.3.0，没有新开版本号。

## 新增功能

1. **通用有理矩阵的内部奇点发现**：`RationalMatrixSystem` 从 exact 矩阵元分母内部
   发现有限奇点、极点阶数与无穷远分类，不要求用户预先提供奇点。
2. **多项式加简单极点内部特化**：自动验证
   `A(x)=P(x)+Sum_j R_j/(x-p_j)`，其中 `P(x)` 可为任意有限次数矩阵多项式。
   只有 exact 恒等重构和全部有限极点一阶等门禁通过时才使用快速递推；高阶极点与一般
   有理矩阵继续走通用 `RationalMatrixSystem` 路线或按既有能力 fail closed。该特化不要求
   dlog 输入，也不限制通用 DE 接口。
3. **规划与执行分离**：`plan_transport_path`/Wolfram `FlintNDEPlanPath` 从原始点生成
   可序列化计划；`transport_planned_path_refined`/Wolfram `FlintNDEExecutePath`
   只恢复并执行已有计划，不再次规划。没有新增重复的“是否自动规划”选项。
4. **缺省避开奇点**：Python 的通用 routing 使用
   `singularity_mode="avoid"` 和 Wolfram 的 `"SingularityMode" -> "Avoid"` 均为缺省。
   命中内部奇点时返回对应线段与奇点诊断。显式 `singularity_jump` /
   `"SingularityJump"` 模式才允许奇点折跃，并提醒用户：多值分支等价于某条绕行
   路径，必须自行确认。模式值集合固定为上述两项。
5. **奇点折跃后的用户点前瞻**：进入奇点步长范围后建立入射/出射桥；随后依次吸收仍位于
   奇点一步范围内的用户点，以最后一个为下一节点。首个点若已超范围，则沿该方向先走
   一个允许步长回到普通节点状态，再继续规划。
6. **双语提示**：Python `message_language="EN"|"CN"` 与 Wolfram
   `MessageLanguage -> "EN"|"CN"`；缺省英文。规划结果明确说明当前模式，
   执行结果明确说明没有重新规划。
7. **标准 Wolfram 程序包入口**：版本根的 `FlintNDE.m`、`Kernel/init.m` 与
   `Mathematica/FlintNDE.wl` 支持 `Needs["FlintNDE`"]`。公开构造器包括
   `FlintNDERationalSystem`、`FlintNDEPartialFractionSystem`，两阶段入口为
   `FlintNDEPlanPath` 与 `FlintNDEExecutePath`。

## 精度与认证修复

- 工作位数统一按
  `ceil(WorkingPrecisionDigits*log2(10))+32` 设置。70 位为 265 bit，100 位为
  365 bit；提高 `OutputDigits` 本身不会提高内部精度。
- 修复规划比例在低精度 import 阶段构造 Arb 常量造成的永久精度污染；线段投影、
  匹配比例、旋转因子与节点现在均按当前 Arb 精度构造，70/100 位回归确认真实奇点折跃
  匹配节点的可用 bit 数随请求增长。
- `PlannedPath` 与 `AdaptivePath` JSON 均保存 `planning_precision_digits`。节点、
  奇点和奇点折跃几何以 Arb `midpoint/radius/exponent` 记录保存，不再只保存中点。
- 执行请求高于规划精度时 fail closed，并要求按目标精度重新规划；序列化数据不能在执行期
  伪装补回精度。
- winding/monodromy 与分支提升使用 Acb/Arb 辐角球，不经过 Python
  `complex`/`cmath`。
- 奇点桥不再把同一结果冒充 Embedded 主/参考双链；需要独立链时自动升级认证并在 warning
  和结果中报告。

## 接口合同

- Python 路径模式只接受 `singularity_mode="avoid"|"singularity_jump"`；Wolfram 只接受
  `"SingularityMode" -> "Avoid"|"SingularityJump"`。缺省均为避开奇点。
- “折跃”指任何经过中途节点的多点输运；只有显式穿过奇点的局部基连接称为“奇点折跃”。
- Wolfram 数值主线只有 `FlintNDEPlanPath` / `FlintNDEExecutePath`；JSON bridge 只有显式
  `action="plan"|"execute"`。执行入口只接受当前计划 schema 和带 Arb 球精度字段的节点。
- 正则奇点边界使用 `{a,b,C}`；指数型奇点边界只接受 `{phi,a,b,C}`。程序从 DE 独立推导
  exact 指数 sector 并核验 `phi`，不从 `C` 静默猜测指数签名。
- 0.3.0 仅定义上述公开合同；依赖和列向量 convention 不变。
## 验证状态

- Python `pytest`：144/144 通过；`unittest discover`：133/133 通过。
- Wolfram `Needs["FlintNDE`"]` 端到端检查：18/18 通过，覆盖一般有理矩阵、
  任意次多项式加简单极点特化、缺省避奇点、显式奇点折跃和高精度执行拒绝。
- MadStree adapter 的 plan-only/execute-only 回归另验证非共振奇点折跃的 Arb 球
  round-trip，执行阶段规划器哨兵未触发。
- 独立包与 MadStree v0.10 Vendor 的共同交付文件 SHA-256 全部一致；双方
  pyproject.toml 版本均为 0.3.0。

## 已知限制

- 一般代数扩域、ramification、缺 Stokes connection 的不规则奇点和未认证局部基继续
  fail closed。
- 共振/Jordan/log 只在现有 exact local-basis 门禁支持时进行奇点折跃；不能把简单 residue 特化
  当作这些结构的替代算法。
- 更高精度结果必须从同等或更高 `WorkingPrecisionDigits` 的新计划开始；不能复用低精度
  序列化计划。
