# 三顶点 V5.5 外部参考代码

本目录保存合作者在 GitHub `main` 提交 `5840049` 中补齐的三顶点 V5.5 参考实现及其解析验证代码，
是仓库内该参考实现的唯一正式来源。MadStree 的生产源码不得加载本目录；独立验证需要关闭自动运行、
改写 runtime 路径或生成缓存时，必须先复制所需文件到对应 case 的 `results_temp/`。

核心文件：

- `001_dsde3vertex_v5.5.wl`：V5.5 主脚本，SHA-256
  `F5152B6FDED43971C8B6AFEC8D421AAAEF080B3FCC8A8D8A36363F84ABD63AF9`。
- `pyflint_e2_transport.py`：主脚本声明的 Python-FLINT companion，SHA-256
  `78891A14C2A5A20C8F2C6082E64561A883FD6DD31C4CFA3D1662626BA96BFA44`。
- `requirements-pyflint.txt`：companion 的 Python 依赖说明。
- `check_v55_load.wl`：V5.5 加载 smoke check。
- `validation/`：合作者提供的解析公式和连接矩阵比较代码，保留原文作为外部证据，不作为
  MadStree 生产输入。

此前位于 `package-MadStree/independent-validation-task/` 的带 `(1)` 文件名主脚本与本目录主脚本
blob 完全相同，已删除重复副本。历史内容从 Git 追溯。
