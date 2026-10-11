# Bubble 固定圈动量核验资料

本目录整理 2026 年 10 月 10 日至 11 日已完成的 MadStree bubble 时间积分计算：两个顶点、两条 massive 内线，固定内线动量，四个 SK 分支，三个参数点。未积分空间圈动量。这里没有新增物理计算、程序包修改或修复后结果，也不包含三顶点树图、XYZZ、两顶点树图或 V5.5 的计算材料。

已有结果显示同号分支与本次自行编写的独立积分参考存在显著差异。代码和已保存边界记录支持一个具体问题：等时接触扇区的单导数边界系数使用单一 Hankel 排列，与论文要求的对称平均不一致。**没有修复后重算，因此尚不能量化该问题对终值偏差的贡献，也不能证明它解释全部差异。**

## 阅读顺序

1. [版本和原始来源](provenance/VERSIONS.md)：区分运行提交、后续只读审查提交与待上传仓库。
2. [定义及参数对应](definitions/DEFINITIONS_AND_PARAMETERS.md)：积分定义、SK 排列、精确输入、基底编号、精度。
3. [微分方程说明](equations/README.md)：已保存的生成方程、矩阵和缺失的成功运行请求。
4. [边界与后端对应](boundaries/README.md)：边界曲线、领头向量、physicalWeight、接触扇区。
5. [结果与误差说明](results/README.md)及[逐点逐分支完整对照表](results/comparison/by_point_and_branch.csv)。
6. [边界系数审查](review/REVIEW.md)和用户提供的 [Word 原件](review/MadStree_bubble边界系数问题审查及修复建议.docx)。Word 附录为 ChatGPT 提出的、未执行和未验证的候选代码。
7. [资料缺口](provenance/GAPS.md)、[结构核对结果](provenance/structural_checks.json)、[文件来源](provenance/file_origins.json)、[SHA-256 清单](provenance/SHA256SUMS.txt)。

## 运行对象

| 项目 | 本次实际计算 |
|---|---|
| 程序包 | `J7C/dSIBP-Packages`，`7dfd3c4afad4dd29ccae744f606a784121a90619` |
| 论文 | `J7C/dSIBP-development`，`264141f0b1349cc045ab5cbf3a290642b1102201`，`papers/madstree/paper.tex` |
| 物理参数 | `ks=x1=1, x2=sqrt(2), nu1=nu2=i/4, p1=p2=1+i/2` |
| 参数点及分支 | `rho=10,5,2.8`；`pp,pm,mp,mm` |
| 程序输入 | `k1=k2=-rho`，`NuConvention -> "Negative"`；`x2` 使用已保存的有理近似 |
| 维数 | `pp/mm`：22；`pm/mp`：16；外部独立比较只覆盖 `J0000` 和其 SK 组合 |
| 精度 | 工作精度 80，主/参考输运阶数 80/96，目标 `1e-32`；已保存目标判据未通过 |

## 文件组织与复现入口

`equations/generated/` 保存四支原始公式及运行导出的 dlog 字母、矩阵、masters、manifest；`results/native/` 保存完整原生结果和各参数点全部分量；`results/backend_outputs/` 是原运行缓存输出的逐字副本，作为证据保留，不是新缓存。`boundaries/extracted/`、`equations/boundary/`、各索引 JSON 是本轮从旧结果进行的文本提取，未执行 Wolfram 表达式。

原始运行根目录：`C:/Users/14372/Desktop/paperofuniver/cases/task12_20261010_221725`。
运行入口见 [scripts/README.md](scripts/README.md)。脚本保留原样；其中路径仍指向原实验布局，**本目录是核验资料包，不是移动后即可直接运行的安装包**。完整运行需要固定提交的 MadStree 及其 Vendor/FlintNDE、Wolfram 14.3 和原 Python 环境。本轮没有执行这些入口。

## 完整性范围

现存资料可以核对生成的 DE、主积分顺序、符号边界、路径、四支终值和外部比较。成功运行的四份 `i-*.json` 请求未保存；原包成功后删除请求文件。因而不能逐字核验其实际序列化矩阵和初值；之前失败尝试的请求单列，不能替代成功请求。独立积分参考也不是整套 DE 的独立推导或验证。本目录不宣称已支持全面核验。

上传目标尚待用户确认：现有上下文同时指向发布库和开发库，没有唯一的提交目的地。本地整理不代表已上传。
