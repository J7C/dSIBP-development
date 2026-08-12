# FlintNDE 版本索引

## 当前版本

- 版本：`0.3.0`
- 源码与测试：`versions/FlintNDE-0.3.0/`
- Python import：`flintnde`
- Wolfram Language：把版本根加入 `$Path` 后使用 `Needs["FlintNDE`"]`
- 手册：`Documentation/FlintNDE.pdf`
- 状态：当前工作版本。通用 `RationalMatrixSystem` 内部发现奇点；自动认证任意次数
  矩阵多项式加简单极点快速路线；规划/执行分离，缺省避奇点，显式奇点折跃保留分支责任；
  工作位数随请求精度自适应，低精度序列化计划不能用于更高精度执行。
- 同步合同：MadStree v0.10 的 `Vendor/FlintNDE` 与本版本受控实现保持逐文件一致。

## 保留版本

- `0.2.0`：冻结源码与测试，不再回写。
- `0.1.0`：冻结源码与测试，不再回写。
- `0.1.0.dev0`：冻结源码与测试，不再回写。

新版本只在用户明确要求后建立，并在对应版本目录内增加 `UPDATE_NOTES.md`；旧版本冻结保留。
