# dSIBP-development 仓库规则

## 仓库边界

本仓库并列维护三个独立程序包：`package-dSibp/`、`package-MadStree/` 和
`package-FlintNDE/`。进入任一子项目后，以该目录内最近的 `AGENTS.md` 为直接规则源；
根规则只维护三者的依赖方向、共同版本纪律和 Git 边界。

依赖方向固定为 `MadStree -> FlintNDE`。dSIBP 不调用另外两包；FlintNDE 不读取 dS 图、
主积分顺序或 normalization；MadStree 负责把自己的 dlog DE 和边界转换为 FlintNDE 输入。

## 共同工作流

- 每次任务先更新根目录 `研究计划与研究进度.md`，再修改子项目源码或文档。
- 三个程序包根均维护 `README.md`、`VERSION_INDEX.md`、`Documentation/`、`versions/` 和
  自身 `AGENTS.md`；历史验证目录可以按各自合同保留，不强制伪装成相同内容。
- 是否新建版本只由用户明确决定。新版本必须有更新说明；已有 dSIBP 018.1、MadStree
  v0.3 和 FlintNDE 0.1.0.dev0 不追溯补建。
- 本仓库缺省不做向后兼容。当前工作版本中的接口被替代时，物理删除旧函数名、参数别名、
  wrapper、fallback、旧 schema 读取分支、兼容测试和现行文档中的旧调用法；冻结历史版本
  只作版本档案，不得被当前入口加载或转发。只有用户明确要求迁移期时才可另行设计兼容层。
- 建议新版本在独立 branch 开发；是否创建、保留或合并 branch 由用户决定，agent 未经
  明确指令不得自行创建或合并。
- 运行产物、cache、保存点和临时文件归调用目录或各子项目规定的 `results_test/`、
  `results_temp/` 所有，不写入其它程序包的源码目录。
- 不回滚用户未提交改动。删除、移动或发布前必须核对精确路径、Git 状态和当前消费者。

## 发布

GitHub 发布前必须从新路径运行受影响测试，执行 `git diff --check`，确认没有 cache、pyc、
TeX 中间文件或临时结果进入 staged 集合，并核对本地分支与远端分歧。仓库可见性设置由用户
在 GitHub 管理，代码任务不得自行改变 visibility、协作者或 branch protection。
