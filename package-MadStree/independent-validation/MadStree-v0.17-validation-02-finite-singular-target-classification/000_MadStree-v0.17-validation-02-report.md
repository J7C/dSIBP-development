# MadStree v0.17 Validation-02 独立报告

- 状态：**passed**，16/16。
- 后端 SHA-256：`4ded63a0baaccb8c544cc63ce252549f1c9e16ea7277830124a9f5ab28b915ac`。
- 工作精度/主阶/参考阶：`90 / 64 / 88`；目标相对误差 `1e-30`；总 wall time `0.7128945 s`。

## Exact 模型

- removable：`Y=1-x`，奇点值为有限零。
- pole：`Y=1/(1-x)`，奇点值为文本 `Infinity`。
- log：`Y=(log(1-x),1)`，第一分量为文本 `Infinity`，第二分量有限为 1。

三者均由正式 JSON/CLI 路线返回原始 userIndex、逐分量值和 `singularityClassifications` 表。
本 case 不调用真实树图 producer，不能推广为 MadStree master、dlog 或边界的包级验证。
机器结果：`results/summary.wl`；原始请求/响应：`results_temp/`。
