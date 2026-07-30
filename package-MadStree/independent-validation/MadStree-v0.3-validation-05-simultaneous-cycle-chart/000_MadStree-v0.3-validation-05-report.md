# MadStree v0.3 independent validation report: T5 simultaneous/cycle/chart

> Generated automatically by `run_validation.wls`.

## Status

- status: `passed`
- checks: `17/17`
- version: `MadStree-v0.3`

## Scope and normalization

- massless common-theta root/line normalization: `1 / {1,1,1}`
- massive quotient root/explicit pinch normalization: `1 / {2,3,5}`
- odd-subset coefficients: `{<|"selectedLineIds" -> {e1}, "coefficient" -> 1|>, <|"selectedLineIds" -> {e2}, "coefficient" -> 1|>, <|"selectedLineIds" -> {e3}, "coefficient" -> 1|>, <|"selectedLineIds" -> {e1, e2, e3}, "coefficient" -> 1/4|>}`
- simultaneous child power: `au+av+1=26/15`; a multi-edge event merges the vertices once

## Boundary point, charts and path

- exact triangle point: `{k1 -> -11*I, k2 -> -7*I, k3 -> -5*I, q12 -> 2, q23 -> 3, q31 -> 4}`
- strict rank orders: `{{t1, t2, t3}, {t1, t3, t2}, {t2, t1, t3}, {t2, t3, t1}, {t3, t1, t2}, {t3, t2, t1}}`
- boundary: all `K_i -> infinity` in each nested chart
- numerical transport path: `not applicable`
- Frobenius/local/transport orders: `not applicable`

## Timing

- simultaneous/contact construction: `1.106614 s`
- all-chart certificate: `0.432536 s`
- total wall time: `1.840734 s`

## Checks

- `oddSubsetIdentity`: PASS
- `masslessContactMatrices`: PASS
- `masslessChildCount`: PASS
- `masslessChildBasePower`: PASS
- `masslessNormalization`: PASS
- `masslessCoincidentMasters`: PASS
- `massiveSingleCoincidentDimension`: PASS
- `massiveNormalizationAccumulation`: PASS
- `massiveLocalDiagonalizers`: PASS
- `triangleSevenCanonicalSectors`: PASS
- `triangleNineTransitions`: PASS
- `allSixRankCharts`: PASS
- `allChartsNormalCrossing`: PASS
- `allSectorThetaFixed`: PASS
- `allChartQuotientsCertified`: PASS
- `shiftedChildReduction`: PASS
- `triangleDLogClosed`: PASS

## Evidence

- triangle contracted sets: `{{}, {l12}, {l23}, {l31}, {l12, l23}, {l12, l31}, {l23, l31}}`
- triangle transition count: `9`
- chart divisor counts: `{25, 25, 25, 25, 25, 25}`
- machine-readable summary: `results/summary.wl`
- no FlintNDE transport or finite-point defining integral was used.
