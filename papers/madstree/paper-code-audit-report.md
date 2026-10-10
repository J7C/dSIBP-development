# MadStree 论文草稿 vs. 程序源码 对抗性事实核查报告

核查对象：`papers/madstree/paper.tex`（工作树当前版本）
权威依据：`package-MadStree/versions/MadStree-v0.17/` 源码（源码 > Examples > 手册 > README）
核查日期：2026-10-10
核查方式：**只读静态核查**。未修改任何源文件；未运行 Wolfram 探针（所有结论均有源码行号级证据，静态证据已足够定论，无需最小探针）；未运行回归测试。

## 实际读过的文件

论文：
- `papers/madstree/paper.tex` 全文（分块读完，约 2100 行）

MadStree v0.17 源码（均位于 `package-MadStree/versions/MadStree-v0.17/`）：
- `MadStree.m`（全文）
- `Kernel/MadStree.wl`（全文，含所有公开符号 usage 串与 `$MadStreeVersion = "1.0"`，L94）
- `Kernel/Core/Topology.wl`（全文：线型白名单、必需键、`msNormalizeVertex`、`msNormalizeLine`、`msValidateTreeInput`）
- `Kernel/Core/Sectors.wl`（context 结构、`Options[MSInitTree]`、`MSInitTimeGraph` wrapper、sector 构造、coincident 线状态投影、contact 可达性）
- `Kernel/Core/VertexFamily.wl`（紧凑/显式两套键集合、未知字段拒绝）
- `Kernel/Core/Conventions.wl`（全文：+nu 基准、`formulaNu = s_nu·nu`、h↔H 换算矩阵）
- `Kernel/Core/Artifacts.wl`（`MSFormulaData` 选项、四个产物文件名、缺省目录）
- `Kernel/DE/DLog.wl`（`MSDLogDE` 返回键、`dlogStatus` 五种取值与认证值）
- `Kernel/Formula/TensorAtoms.wl`（`MSFormulaMatrices` 三种调用形式与返回结构）
- `Kernel/Formula/Recurrence.wl`（`MSContactMaps`、`MSRecurrenceStep`、`MSReduce` 签名与返回键）
- `Kernel/Numerics/Configuration.wl`（全文：`MSFlintNDEConfiguration`、Vendor 相对路径）
- `Kernel/Numerics/Boundary.wl`（`MSBoundaryData`/`MSBoundaryChartCertificate` 选项与返回键、chart 门禁）
- `Kernel/Numerics/PathEvaluation.wl`（`MSEvaluatePath`/`MSReconstructEpSeries` 选项与主体、pointSequence 规范化、tag 规则、辅助坐标注入、后端 singularityMode 映射、返回结构）
- `Kernel/Numerics/ExportEvaluation.wl`（选项、缺省目录、CSV/JSON 文件名与 schema）
- `Backend/flintnde_transport.py`（定点 grep：段级与顶层 `targetRelativeErrorMet`，L758/L790）
- `Vendor/FlintNDE/README.md`（working bits 公式，L74）、`Vendor/FlintNDE/pyproject.toml`（版本串）、Vendor 内 `regularization.py`（bits 公式复核）

Examples（全文或相关章节）：
- `Examples/01_massless_full_edge.wl`、`02_single_vertex_family.wl`、`03_time_only_cycle_chart.wl`、`04_three_vertex_tree.wl`（部分）、`05_massive_three_vertex_tree.wl`、`06_massless_three_vertex_ep_regularization.wl`、`07_zero_external_leg_energy.wl`

跑过的探针：**无**（未向 `results_temp/` 写入任何脚本）。

---

## 一、确证不符项（按论文出现顺序）

### 【1】L922–923：辅助外腿能量"逐顶点取零"与代码不符 — 严重度：中

- **论文位置**：Sec. 3（辅助能量机制段），L922–923
  > "The auxiliary energies are therefore taken to zero one vertex at a time, and a finite singular endpoint returns either a finite value or an explicit divergence…"
- **论文声称**：多个辅助能量是**一个顶点一个顶点地**依次取零（暗示分多段/多次极限输运）。
- **代码实际**：`msEvaluationAddAuxiliaryCoordinates` 把**全部**辅助坐标一次性并入坐标表，并把每条辅助规则 `aux -> 0` 一次性附加到**每一个**用户点上，随后整个点列在一次后端请求中输运；不存在逐顶点分批取零的机制。
  - `Kernel/Numerics/PathEvaluation.wl:139–154`：
    ```mathematica
    auxiliaryRules = msAuxiliaryExternalLegEnergyRules[context];
    ...
    "coordinateSymbols" -> Join[normalizedInput["coordinateSymbols"], auxiliarySymbols],
    "points" -> Map[
      Append[#, "coordinate" -> Join[#["coordinate"], auxiliaryRules]] &,
      normalizedInput["points"]
    ],
    ```
  - `Kernel/Core/Topology.wl:115–119`：`msAuxiliaryExternalLegEnergyRules` 一次收集所有辅助顶点规则。
  - 奇异性由后端的折跃/拒绝机制统一处理（`PathEvaluation.wl:193–203`），不是靠"逐个取零"。
- **严重度**：中。不会让读者写出跑不通的调用，但对极限路径形状的描述与实现机制不一致，可能误导对奇异端点行为的理解。
- **建议改法**：改为"所有辅助坐标一次性并入 dlog 系统，每个用户点的辅助分量直接取其物理目标值 0；若该端点奇异，由奇点处理机制返回有限值或显式发散/失败"。若"one vertex at a time"另有所指（如边界构造阶段的某个内部次序），请在论文中说明具体环节。

### 【2】L1047–1056：`MSInitTree` verbatim 示例有语法错误（列表未闭合） — 严重度：高

- **论文位置**：Sec. "Input formats and core functions"，L1046–1056
  > ```
  > spec = <|
  >   "name" -> "masslessFullEdge",
  >   "vertices" -> {
  >     <|"id" -> v1, ...|>,
  >     <|"id" -> v2, ...|>
  >   "lines" -> {
  >   ...
  > ```
- **论文声称**：这是可复制运行的输入示例。
- **代码实际**：`"vertices"` 列表在 L1051 之后缺 `},`——第二个顶点 association 后直接接 `"lines" -> {`，整个表达式不是合法 Wolfram 语法，复制即报语法错误。
- **严重度**：高（verbatim 示例直接跑不通）。
- **建议改法**：L1051 行尾补 `},`。

### 【3】L1050：字段名拼写错误 `"externelLegEnergy"` — 严重度：高

- **论文位置**：同上示例 L1050
  > `<|"id" -> v1, "externelLegEnergy" -> k1, "timePower" -> a1, "vertexType" -> "+"|>,`
- **论文声称**：顶点外腿能量字段名为 `externelLegEnergy`（拼写错误；L1051 第二个顶点用的是正确的 `externalLegEnergy`，L1066 表格也是正确拼写）。
- **代码实际**：合法字段名是 `"externalLegEnergy"`。关键在于 tree/time-graph 输入对顶点额外字段**静默忽略**（`Kernel/Core/Topology.wl:16` 注释："Association 键顺序和额外字段不影响物理输入"；`msNormalizeVertex` 只 `Lookup[vertex, "externalLegEnergy", 0]`，L94）。因此拼错的键不会报错，而是让 v1 能量取缺省 0 → 触发私有辅助能量机制（`Topology.wl:95–99`：`auxiliaryQ = TrueQ[inputEnergy === 0]`）→ 得到与用户意图不同的**静默错误结果**。
- **严重度**：高（不报错但物理结果错，是最危险的一类文档错误）。
- **建议改法**：改为 `"externalLegEnergy" -> k1`。

### 【4】L1082–1083：线字段 `"masslessRepresentation"` 不存在 — 严重度：高

- **论文位置**：Line fields 表格，L1082–1083
  > `masslessRepresentation` & `"Quotient"` (default) or `"RedundantH"` & masslessFull only
- **论文声称**：masslessFull 线可通过 `masslessRepresentation` 字段在 Quotient 与 RedundantH 两种表示间选择。
- **代码实际**：不存在任何读取 `"masslessRepresentation"` 的代码；masslessFull 线的函数系统**硬编码**为共享二态 quotient：
  - `Kernel/Core/Topology.wl:170–171`：
    ```mathematica
    functionSystem = Which[
      type === "masslessFull", "masslessQuotient",
    ```
  - `Topology.wl:6–7` 文件头注释："massless Full 线固定使用共享二态 quotient，不读取其它表示选择"。
  - 线输入中被读取的键只有 `"type"`、`"endpoints"`、`"momentum"`、`"nu"`、`"contactRawPower"`、`"pinchNormalization"`、`"hankelBranches"`（`Topology.wl:134–175`）；`"masslessRepresentation"` 会被静默忽略。
- **严重度**：高。读者若为得到 RedundantH 表示而设置该字段，将被静默忽略且得不到预期基。
- **建议改法**：删除该行，或改为说明"masslessFull 线固定使用共享二态 quotient 表示，无表示选择字段"。

### 【5】L1096–1101：`MSInitTimeGraph` 示例含三个非法/无效字段 — 严重度：高

- **论文位置**：Sec. "Loop diagrams without loop integral"，L1096–1101
  > ```
  > cycleContext = MSInitTimeGraph[<|
  >   "vertices" -> {<|"id" -> t1, "energy" -> k1, "timePower" -> a1|>, ...},
  >   "lines" -> {<|"id" -> l12, "type" -> "masslessFull", "endpoints" -> {t1, t2},
  >                "momentum" -> q12, "skType" -> "++", "nu" -> 1/2|>, ...}
  > |>];
  > ```
- **论文声称**：这是合法的纯时间图输入。
- **代码实际**：三处错误——
  1. `"energy"` 不是顶点字段，正确键为 `"externalLegEnergy"`（`Topology.wl:94`）。且顶点缺 `"vertexType"` 会产生 `Missing` 并在 `msValidateTreeInput` 中失败（`Topology.wl:108, 273–275`）。`"energy"` 本身被静默忽略 → t1 能量变 0 → 触发辅助机制。
  2. `"type" -> "masslessFull"` 非法：输入线型只接受 `"massive"` 或 `"massless"`（`Topology.wl:13`：`$msSupportedInputLineTypes = {"massive", "massless"}`），`msValidateTreeInput` 显式拒绝并返回 `unsupportedLineType`（`Topology.wl:280–283`）。"masslessFull" 是内部**派生**类型（`inputType <> lineClass`，`Topology.wl:141–145`），不是合法输入。
  3. `"skType"` 字段不被任何代码读取；轮廓符号由端点顶点的 `vertexType` 派生（`Topology.wl:138–140, 150–151` 的 `contourType`/`fullContourSign`）。这与论文自己在 L1091 的正确陈述（"derived from the endpoint vertices, not supplied as line types or as a `skType` field"）直接矛盾。
  - 对照正确用法：`Examples/03_time_only_cycle_chart.wl` 用标准字段 `"externalLegEnergy"`、`"vertexType"`、线型 `"massless"`，无任何 `skType`。
- **严重度**：高（示例整体返回 Failure，`"masslessFull"` 一项即致命）。
- **建议改法**：示例改为与 Example 03 一致的字段：顶点 `<|"id"->t1, "externalLegEnergy"->k1, "timePower"->a1, "vertexType"->"+"|>`；线 `<|"type"->"massless", "endpoints"->{t1,t2}, "momentum"->q12, "nu"->1/2|>`，删除 `"skType"`。

### 【6】L1117：`MSInitVertexFamily` 显式键列出不存在的 `"k0"` — 严重度：中

- **论文位置**：Sec. "Single-vertex integral families"，L1117–1118
  > "The explicit alternatives `k0/timePower/hBlocks/exponentialBlocks` are accepted."
- **论文声称**：显式输入模式的替代键为 `k0`、`timePower`、`hBlocks`、`exponentialBlocks`。
- **代码实际**：显式键集合为 `{"externalLegEnergy", "timePower", "hBlocks", "exponentialBlocks", "vertexType", "normalization"}`（`Kernel/Core/VertexFamily.wl:20–23`），**没有 `"k0"` 键**；纯顶点相能量的显式键名是 `"externalLegEnergy"`。且 `MSInitVertexFamily` 对未知字段**显式拒绝**（`VertexFamily.wl:28–38`：`unknownVertexFamilyFields`），传 `"k0"` 会直接失败，与 tree/time-graph 的静默忽略不同。
  - 对照 `Examples/02_single_vertex_family.wl`：显式模式使用 `"externalLegEnergy"`。
- **严重度**：中。论文此处像是把紧凑模式示例中的符号 `k0`（`"ki" -> {k0, k1, k2}` 的首元素）误当成了显式键名；按此写显式输入会得到明确 Failure，读者能察觉但会困惑。
- **建议改法**：改为 `externalLegEnergy/timePower/hBlocks/exponentialBlocks`。

### 【7】L1198：`phaseSign`/`skType` 字段名不存在 — 严重度：中

- **论文位置**：Sec. 4（MSIntegral 示例之后），L1198–1199
  > "The vertex phase sign (the `phaseSign` field) and the line SK signs (the `skType` field) determine…"
- **论文声称**：顶点相位符号存在名为 `phaseSign` 的字段、线 SK 符号存在名为 `skType` 的字段。
- **代码实际**：`msNormalizeVertex` 产出的内部键是 `"contourSign"` 与 `"vertexSign"`（`Topology.wl:109–110`），线级派生键是 `"contourType"` 与 `"fullContourSign"`（`Topology.wl:150–151`）；整个包内不存在 `phaseSign` 或 `skType` 字段。输入侧唯一相关字段是顶点的 `"vertexType"`（`"+"`/`"-"`）。与 L1091 的正确陈述矛盾（同【5】第 3 点）。
- **严重度**：中。描述性文字而非示例代码，但读者可能在 spec 里尝试设置这两个不存在的键（tree 输入下被静默忽略，后果同【3】）。
- **建议改法**：改为"顶点相位符号由 `vertexType` 字段决定（内部键 `vertexSign`/`contourSign`），线的 SK 符号由两端 `vertexType` 派生（内部键 `contourType`/`fullContourSign`）"。

### 【8】L1358：内嵌后端版本写成 "FlintNDE 0.4.0" — 严重度：中

- **论文位置**：Sec. "Numerical evaluation"，L1357–1359
  > "The backend inside the version directory is a synchronized copy of standalone FlintNDE 0.4.0…"
- **论文声称**：Vendor 内嵌后端同步自独立 FlintNDE 0.4.0。
- **代码实际**：当前 Vendor 快照同步自独立 **FlintNDE 0.5.0**：`Vendor/FlintNDE/README.md` 引用 `versions\FlintNDE-0.5.0` 布局；本仓库 `package-FlintNDE` 当前版本即 0.5.0（Vendor 内 `pyproject.toml` 的版本串 `"1.0"` 是发布版式，不是同步源版本号）。
- **严重度**：中。版本号陈述过时，不影响调用，但会误导读者去对照错误版本的后端文档。
- **建议改法**：改为 "standalone FlintNDE 0.5.0"，并建议以仓库 `VERSION_INDEX.md` 为唯一版本事实源。

### 【9】L1384–1389：`MSEvaluatePath` 调用格式错误（`{targetRules}` 不是合法 pointSequence） — 严重度：高

- **论文位置**：Sec. "Transport"，L1383–1389
  > ```
  > result = MSEvaluatePath[context, {targetRules},
  >   BoundaryScale -> 4, RankOrder -> {v1, v2}, ...]
  > ```
- **论文声称**：第二参数可以传"规则列表的列表" `{targetRules}`（其中 `targetRules = {k1 -> -9 I, ...}`，见 L1366）。
- **代码实际**：`MSEvaluatePath` 第二参数是 **pointSequence**：首行必须是坐标符号表头（全部为 `Symbol`），后续每行是等宽数值行（可带唯一合法 tag `"tmp"`）：
  - `Kernel/Numerics/PathEvaluation.wl:74–79`：表头非 Symbol 列表 → `msFailure["EvaluationCoordinateHeader"]`；
  - `PathEvaluation.wl:29–57`：行规范化只接受裸数值列表或 `{{values...},"tmp"}`。
  - 规则形式 `{k1 -> -9 I, ...}` 既不是 Symbol 表头也不是数值行，`{targetRules}` 会立即返回 Failure。
  - 固定参数（如 `q -> 1, a1 -> 1, a2 -> 1`）应通过 `ParameterRules` 选项传入（`PathEvaluation.wl:428`）。
  - 正确用法见 `Examples/01_massless_full_edge.wl:61–80`：
    ```mathematica
    singlePointSequence = {{k1, k2}, {9 I, 3 I}};
    targetValue = MSEvaluatePath[context, singlePointSequence,
      ParameterRules -> parameterRules, BoundaryScale -> 4, ...];
    ```
- **严重度**：高（照抄示例必得 Failure）。
- **建议改法**：示例改为
  `result = MSEvaluatePath[context, {{k1, k2}, {-9 I, -3 I}}, ParameterRules -> {q -> 1, a1 -> 1, a2 -> 1}, BoundaryScale -> 4, RankOrder -> {v1, v2}, ...]`。

### 【10】L1407：引用过时版本号 "v0.11" — 严重度：低

- **论文位置**：Sec. "Reading the result"，L1407
  > "v0.11 does not provide leading-order point labels: every other tag is rejected."
- **论文声称**：以 "v0.11" 指称当前版本。
- **代码实际**：当前版本目录为 MadStree-v0.17，代码内版本身份字符串统一为发布版式 `"1.0"`（`Kernel/MadStree.wl:94`：`$MadStreeVersion = "1.0"`；论文 L1998 自己也写 "In MadStree v1.0"）。tag 拒绝行为本身描述正确（`PathEvaluation.wl:38–43`：唯一合法 tag 是 `"tmp"`）。
- **严重度**：低（行为陈述正确，仅版本标签过时且与论文其它处不一致）。
- **建议改法**：删去 "v0.11"，改为 "The current version does not provide…" 或 "MadStree v1.0"。

### 【11】L1408 与 L1447：默认 `SingularityMode -> "Avoid"` 错误，实际默认 `"Automatic"` — 严重度：高

- **论文位置**：两处——
  - L1408（"Reading the result"）："With the default `SingularityMode -> "Avoid"` a segment that crosses a singularity is refused…"
  - L1447（"The numerical backend"）："…with the default `SingularityMode -> "Avoid"` a segment that meets a singularity is refused…"
- **论文声称**：`MSEvaluatePath` 的 `SingularityMode` 默认值是 `"Avoid"`，默认行为是拒绝碰到奇点的线段。
- **代码实际**：默认值是 `"Automatic"`：
  - `Kernel/Numerics/PathEvaluation.wl:430`：`SingularityMode -> "Automatic"`（`Options[MSEvaluatePath]`，L425–442）。
  - `"Automatic"` 映射到后端 `"singularity_jump"`（`PathEvaluation.wl:201–203` 的 `msBackendSingularityMode`），即默认允许折跃；仅在 `FlintNDEPathPlanning -> False` 时后端模式被强制为 `"avoid"`（`PathEvaluation.wl:540` 附近：`"singularityMode" -> If[! planningQ, "avoid", ...]`），且显式 `"SingularityJump"` + 关闭 planning 直接返回 Failure（L468–473）。
  - 论文自己的选项表 L1543 与 pitfalls L1620 写的是正确的 `"Automatic"`——同一篇论文内自相矛盾。
- **严重度**：高。默认奇点行为是用户可见的关键语义：按论文理解为"默认拒绝"，实际是"默认折跃"，会导致对结果分支/多值性的错误预期。
- **建议改法**：两处均改为 `SingularityMode -> "Automatic"`（默认，映射到后端 singularity_jump），并补充"关闭 planning 时后端强制 avoid、显式 SingularityJump 需 planning 开启"。

---

## 二、存疑项（静态核查无法定论，宁列勿漏）

### 【Q1】L1376：Frobenius 领头分支写成 `{a,b,C}`

- **原文**："`MSBoundaryData` … returns the Frobenius leading branches $\{a,b,C\}$ at the $K_v\to\infty$ boundary."
- **卡点**：`MSBoundaryData` 返回键中确有 `"leadingBranches"`（`Kernel/Numerics/Boundary.wl:687–727`），但其内部三元结构是否恰为 (指数 a、系数 b、常数 C) 这一约定，静态阅读未能逐字段确认到与论文符号一一对应。建议作者对照 `Boundary.wl` 的 leadingBranches 构造处核实符号命名。

### 【Q2】L919："FlintNDE transports along that auxiliary coordinate back to the physical value"

- **原文**：边界在 $K_v^{\rm aux}\to\infty$ 构造后，"FlintNDE then transports along that auxiliary coordinate back to the physical value $k_{0,v}^{\rm aux}=0$"。
- **卡点**：代码事实是每个用户点的辅助坐标直接被赋目标值 0（【1】所引 `PathEvaluation.wl:148–151`），输运沿用户坐标线段进行，辅助坐标作为附加维度进入 letters。"沿辅助坐标输运回物理值"这一表述是否在拉回后的单变量段意义上成立，取决于后端对多维坐标的具体处理路径，静态核查不能完全定论；倾向与【1】合并修正表述。

### 【Q3】L1012：安装路径 `".../dSIBP-Packages/MadStree"`

- **卡点**：论文指向公开发布仓库 `github.com/J7C/dSIBP-Packages` 的目录布局；本开发仓库布局为 `package-MadStree/versions/MadStree-v0.17/`。两者是否一致取决于发布仓库的实际结构（未验证外部仓库内容）。发布前需确认公开仓库根下确有可直接 `Needs` 的 `MadStree/` 目录（含 `MadStree.m`）。

### 【Q4】L1841：应用代码"passes $-E_v$ as `externalLegEnergy`"

- **卡点**：三顶点应用例的驱动脚本不在程序包内，无法核对其确实传 $-E_v$ 且与 `NuConvention -> "Negative"`、pinch normalization 的组合自洽。机制本身（能量符号自由传入、NuConvention 全局选项）与源码一致。

### 【Q5】全部计时/精度数字（L1874–1947 树应用例、L2029–2047 bubble 应用例等）

- **卡点**：如 "678.20 s"、"5.24 s"、"683.43 s"、"3.37 s per point"、"$4.740\times10^{-24}$"、"$1.025\times10^{-50}$"、"$3.70\times10^{-14}$"、"22 masters"（此项已独立确证**正确**：16+3+3，见下文清单）等均为测量断言，静态核查无法复核数值本身；仅确认了产生这些数字的机制（TransportOrder/ReferenceTransportOrder/TargetRelativeError 选项、边界阶选项）在源码中存在且语义一致。

---

## 三、严重度统计

| 严重度 | 条数 | 条目 |
|---|---|---|
| 高 | 6 | 【2】spec 示例语法错误；【3】`externelLegEnergy` 拼写；【4】`masslessRepresentation` 不存在；【5】TimeGraph 示例三处非法字段；【9】`{targetRules}` 调用格式；【11】默认 SingularityMode 写错（两处） |
| 中 | 4 | 【1】辅助能量"逐顶点取零"；【6】显式键 `"k0"`；【7】`phaseSign`/`skType` 字段名；【8】FlintNDE 0.4.0 |
| 低 | 1 | 【10】"v0.11" 过时版本引用 |
| 存疑 | 5 | 【Q1】–【Q5】 |

---

## 四、已核查且未发现问题的方面

以下断言均与源码逐项对照通过：

1. **加载机制**（L1017–1018）：`MadStree.m` → `Get[Kernel/MadStree.wl, CharacterEncoding->"UTF-8"]`，与论文一致（`MadStree.m` 全文 13 行）。
2. **版本身份**：代码内 `$MadStreeVersion = "1.0"`（`MadStree.wl:94`），论文 L1998 "In MadStree v1.0" 一致。
3. **顶点/线字段表**（L1065–1081）：`id`/`timePower`/`vertexType` 必需、`externalLegEnergy` 可选缺省 0、线 `type`/`endpoints`/`momentum` 必需、massive 必需 `nu`、massless 缺省 `nu=1/2`——全部与 `Topology.wl:17–19, 94, 147, 292` 一致。
4. **`NuConvention` 机制**（L1087–1089, L1123–1131）：`Options[MSInitTree] = {NuConvention -> "Positive"}`（`Sectors.wl:566`），context 级固定、不可逐调用更改；`formulaNu = If["Positive", nu, -nu]`（`Topology.wl:149`）；h 定义 $z^{\pm\nu}H_\nu$ 与 `Conventions.wl` 头注释及 `msHTohMatrix`/`msHToHMatrix`（L27–35）一致。
5. **L1091 整段**（除被 L1198 矛盾外本身正确）：线类由端点派生、`"+"` 顶点相位 $e^{-iE\tau}$、省略或零外腿能量触发目标值为 0 的辅助变量（`Topology.wl:94–99`；`Examples/07_zero_external_leg_energy.wl` 确证 omitted ≡ explicit-zero 且用户 pointSequence 不含辅助坐标）。
6. **`MSIntegral[sectorKey, timeShifts, stateBits]` 语义**（L1134–1139）与 sectorKey 定长比特串约定：与 `Sectors.wl` sector 构造（L246–283）一致；四组 sector 示例表（"11"/"01"/"10"/"00" 及 massless 情形态数）与 contact 可达性规则（偶子集不产生 contact 事件、只连接不同 component 的 full 线，`Sectors.wl:65–66, 100`）一致。
7. **核心函数签名**（L1218–1309 函数表与详述）：`MSDLogDE`、`MSFormulaMatrices`（三种调用形式，`TensorAtoms.wl:232–244`）、`MSContactMaps`（三种形式，`Recurrence.wl:183–195`）、`MSRecurrenceStep[int,component,context]`/`[int,context]`（L297–308）、`MSReduce[expr,context,opts]` 与 `MasterBasis->Automatic`（L316, 330）、`MSBoundaryData`、`MSBoundaryChartCertificate`（含 `RankOrder->All`，`Boundary.wl:220–224`）、`MSEvaluatePath`、`MSReconstructEpSeries[context,epSymbol,pointSequence,opts]`（`PathEvaluation.wl:1155–1159`）、`MSExportEvaluationData`——签名与选项均与源码一致。
8. **返回结构**：`MSDLogDE` 的 `"dlogStatus"`（认证值 `"certifiedByFormulaChecks"`）/`"omegaPotential"`/`"letters"`/`"letterMatrices"` 等（`DLog.wl:275–310`）；`MSReduce` 的 `"remainingShiftedIntegrals"`（拼写正确）；`MSEvaluatePath` 返回的 `pointResults` 点记录键 `coordinate`/`userIndex`/`status`(`"saved"`/`"transient"`)/`value`（单数）（`PathEvaluation.wl:376–401, 567–586`），与 L1404–1406 及 L1415–1417 的读取代码一致。
9. **单阶段工作流**（L1350–1357）：最大连续复仿射分段、每段一次拉回、所有段+边界+选项打包为一次 UTF-8 JSON 请求（`PathEvaluation.wl:551` 单次 `msExecuteFlintNDEAdapter`）；`FlintNDEPathPlanning -> True` 默认、planning 关闭时用全部用户点作节点——与源码一致。
10. **所有选项默认值**（L1532–1579 选项表）：`WorkingPrecision->200`、`TransportOrder->48`、`ReferenceTransportOrder->64`、`TargetRelativeError->"1e-25"`、`ParameterRules->{}`、`MessageLanguage->"EN"`、`SingularityMode->"Automatic"`（L1543 正确，与 L1408/L1447 矛盾，见【11】）、`BoundaryScale->8`、`BoundarySeriesOrder->24`、`RankOrder->Automatic`、`MSOutputDirectory->Automatic`、`ExportFormats->Automatic`、`SignificantDigits->16`、ep 重构选项（`EpSampleAngleRange` 等）——逐项与 `PathEvaluation.wl:425–442, 1045–1067`、`Boundary.wl:14–19`、`ExportEvaluation.wl:14–18`、`Artifacts.wl:28` 一致。
11. **fail-closed 清单**（L1582–1602）：dlogStatus 门禁（`MSEvaluatePath` L476、`MSBoundaryData` L648）、chart 未认证返回 `BoundaryChartNotCertified`（`Boundary.wl:672–673`，与 L1377 一致）、`"SingularityJump"`+无 planning → Failure、未知选项拒绝、`result["flintNDE"]["targetRelativeErrorMet"]` 合法（后端顶层 `flintnde_transport.py:790`，段级 L758）。
12. **点 tag 规则**（L1406–1407）：唯一合法 tag `"tmp"`，其它 tag（如 `"lo"`）被拒绝（`PathEvaluation.wl:38–43`）。
13. **后端机制描述**（L1423–1459）：`certificationMode -> "embedded"`（`PathEvaluation.wl:546` 附近 inputData）、working bits $=\lceil \mathrm{WP}\log_2 10\rceil+32$（`Vendor/FlintNDE/README.md:74` 与 `regularization.py:427`）、`MSFlintNDEConfiguration` 的 `"version"`/`"availableQ"` 键（`Configuration.wl:31–43`）。
14. **产物与导出**（L1311–1344）：formula 产物四文件 `masters.wl`/`recurrence_metadata.wl`/`dlog_de.wl`/`manifest.wl`（`Artifacts.wl:151–156`），`dlog_de.wl` 保存未代数值解析 DE（L67–68 注释）；缺省目录 `results/madstree_formula/run-UUID` 与 `results/madstree_evaluation/run-UUID`（`Artifacts.wl:97–102`、`ExportEvaluation.wl:24–29`）；导出文件 `evaluation_data.csv`/`.json`、CSV 列 `<var>_re/_im`+`M<i>_re/_im`+status/relativeDifferenceInf/targetRelativeErrorMet、JSON schema `madstree_evaluation_data_v1`、只导出 `"saved"` 点（`ExportEvaluation.wl:87–91, 164–183`）。
15. **bubble 应用例结构断言**（L1998–1999）：等号轮廓 22 masters（Top 16 + 两个 3 态 sector；"00" sector 因偶子集双收缩无 contact 事件而不可达；coincident massiveFull 线状态投影 {1,0}≡{0,1} 使 4→3，`Sectors.wl:175–215`）；异号轮廓仅 Top sector 16 masters——与源码机制一致（数值本身未复核，见【Q5】）。
16. **ep 重构描述**（L1461–1530）：`MSReconstructEpSeries` 机制、符号认证最低幂、Example 06 九维与 leadingPower=0 对应关系。
17. **七个 example 对应关系**（L1643–1697）：论文描述与 `Examples/01`–`07` 文件内容逐一吻合（01 massless full edge、02 单顶点族两种 schema、03 time-only cycle、04/05 三顶点树、06 ep 正规化、07 零外腿能量）。
18. **spec `"name"` 字段**：读入为 `caseName`（`Sectors.wl:633`），论文示例用法一致。

---

## 五、总体评价

论文对 MadStree 的**机制性描述**（工作流、门禁、convention、返回结构、选项默认值、后端合同）与 v0.17 源码高度一致，绝大部分核查项通过。问题集中在**可复制的 verbatim 代码示例**：6 条高严重度项中 5 条是示例代码错误（语法、拼写、非法字段、错误调用格式），1 条是默认选项语义写错且与论文自身选项表矛盾。建议优先按【2】【3】【5】【9】【11】修正示例区（Sec. "Input formats"与 Sec. "Numerical evaluation"），并做一次"论文示例 ↔ Examples/ 目录逐条 diff"以杜绝同类漂移。
