# 版本与来源

## 实际运行版本

运行入口 `scripts/original/bubble_calibration_rational120_intlimit.wls` 明确从原 case 的 `sources/dSIBP-Packages/MadStree` 加载包；结果中的 `backendPackagePath` 指向同一包的 `MadStree/Vendor/FlintNDE`。没有使用开发仓库代码替代发布包。

原始 `sources/*.commit.txt`、`*.ls-remote.txt`、已保存源码完整性检查、当前原 case 的 Git HEAD 及代码对象共同对应：

- 包：[7dfd3c4afad4dd29ccae744f606a784121a90619](https://github.com/J7C/dSIBP-Packages/commit/7dfd3c4afad4dd29ccae744f606a784121a90619)。提交时间 2026-10-10 19:08:33 +08:00。
- 论文：[264141f0b1349cc045ab5cbf3a290642b1102201](https://github.com/J7C/dSIBP-development/commit/264141f0b1349cc045ab5cbf3a290642b1102201)。提交时间 2026-10-10 21:51:37 +08:00。

这些结论不是从 PDF 报告抄来的。本轮对随附的五份代码原件以及论文源文件逐项比较工作文件 Git blob 与固定提交的 blob，结果见 [fixed_commit_file_checks.json](fixed_commit_file_checks.json)。原 case 两个 checkout 均保持上述提交，且本轮开始检查时无未提交改动。历史运行期间未改代码的证据来自原保存记录；本轮当前文件哈希相等本身不能单独证明过去每个时刻的状态。

## 后续只读查看的版本

1. 原轮末次成功在线核对时，开发库已到 `4616cb03eec2434a7c0b14f92d92ab3d5bb1582c`。原 checkout 未切换；保存的 `paper_end_revision.diff` 只作后续审查记录，不是计算依据。其后一次联网复查失败也原样保留，不能将失败检查写成最新 HEAD。
2. 用户提供的 Word 记载 2026-10-11 另行只读审查了包 `74762457fa2d780cbfccaab4d5a38dc4c30afc1c` 和论文 `4a82284770fea7cda0b1c64e5b716dd255f58124`，并称相关代码及对称平均定义未变。这是 **Word 所报告的后续审查版本**；本次打包不将该描述作为重新获取这些提交的证据，也不将原数值标为这两个版本计算所得。

## 上传时版本

待唯一确定目标仓库后再记录远端当前分支 HEAD、上传分支和提交。当前本地资料包未上传。无论上传基线如何变化，上述旧运行证据均保留，不会用上传时的新源码覆盖。

## 来源层次

- `unaltered original copy`：字节不变的原始文件副本，可用来源 SHA-256 核对。
- `text-only extract` / `unchanged JSON subtree`：本轮摘取旧文件中的字段，记录来源路径及定位，不做数学求值。Wolfram 文本摘录仅拼接原来的反斜杠续行。
- 本轮说明、索引及结构检查：属于新增整理材料，不是旧运行输出。
- `file_origins.json` 记录原件和提取件来源；`SHA256SUMS.txt` 覆盖除清单自身外的全部交付文件。混合了树图的原 `comparisons.json` 和比较脚本保留在原 case；这里只提取 bubble 内容，并登记原整文件哈希，避免夹带别的计算。

原始参考脚本在同一轮工作中有所完善：例如较早参考 JSON 仍写 `truncation_certified:false`，末态脚本已包含尾界函数。没有每次运行对应的独立脚本版本快照；因此随附脚本是已保存的末态文件，不假称其每一行都与全部早期运行时完全相同。
