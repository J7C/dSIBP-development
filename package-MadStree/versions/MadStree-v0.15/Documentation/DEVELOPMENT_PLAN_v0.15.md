# MadStree v0.15 开发计划

## 边界

MadStree 只把用户 `pointSequence` 划分为同一复仿射单变量段并生成拉回 DE；FlintNDE 负责
节点规划、奇点局部解、输运、双侧 bucket 和多点求值。MadStree 不重复规划节点。

## 实施顺序

1. 先完成独立 FlintNDE 0.5.0 并通过测试，再逐文件同步到本版本 `Vendor/FlintNDE`。
2. 允许无外腿顶点的 `externalLegEnergy` 省略或为 0：内部使用私有辅助能量生成无穷远边界，
   再输运到用户目标 0；不改变用户可见拓扑定义。
3. 将 `SingularityMode` 缺省设为自动识别用户目标；保留显式 `Avoid` 选项并提示其可能
   绕过 apparent/removable singularity。
4. 对 dlogDE 奇点用户点，传给 FlintNDE 的目标合同必须保留：真实 pole 最终文本为
   `Infinity`，可去奇点按普通数值返回；另写 DE 奇点分类表供用户检查。
5. 更新解析 dlogDE、数值结果、手册和 examples；从空目录 fresh 重跑全部 test/examples。
6. 奇点分类不得把坐标名、零坐标或单个示例 letter 当作 authority。独立 FlintNDE 先用
   任意非零复奇点和其它有限奇点共存的系统验证可去/真实分类，再同步 Vendor；MadStree
   只交付每段完整拉回 letters、用户点和主/参考阶数。
7. Example 05 复用同一个 massive 三顶点 context，但把原有非零点列与中间顶点
   `externalLegEnergy=0` 点列分成两个独立 `MSEvaluatePath` 调用、结果对象和导出目录。

## 验收

- FlintNDE Vendor 字节与独立 0.5.0 一致；
- 无外腿/零能量边界与普通拓扑回归通过；
- 奇点点值、分类表、路径和点归属均可追溯；
- 平移/旋转到非零复坐标后，可去奇点仍返回数值、真实奇点仍返回 `Infinity`；另有坐标为零
  但完整 letters 非零的 massive 三顶点批量正例；
- 不保留 v0.15 兼容入口或旧 schema；
- 清理临时产物并通过 UTF-8、`git diff --check` 和目录边界检查。
