# MadStree v0.5 independent validation report: T4 vertex/reduce/H-h

> Generated automatically by `run_validation.wls`.

## Status

- status: `passed`
- checks: `15/15`
- version: `MadStree-v0.5`

## Scope and normalization

- family: one vertex with two massive h blocks; branches `{1,2}`
- root/master normalization: `1`
- master order: `{00,01,10,11}` with the first bit assigned to `(k1,nu1)`
- conventions checked separately: `h=z^nu H_nu` and `h=z^(-nu) H_nu`
- reduced expression: `-3*MSIntegral["11", {-1}, {1, 0}] + 2*MSIntegral["11", {1}, {0, 0}]`

## Point, path and orders

- exact non-singular probe: `{a0 -> 7/6, k0 -> 11/3, k1 -> 2/5, k2 -> 3/7, nu1 -> 1/4, nu2 -> 2/7, z1 -> 5/4, z2 -> 7/5}`
- physical boundary and anchor: `not applicable`
- numerical path: `not applicable`
- Frobenius/local/transport orders: `not applicable`

## Timing

- matrix comparison: `0.000239 s`
- reduction: `0.125237 s`
- transforms/report preparation: `1.262904 s`
- total wall time: `1.516580 s`

## Checks

- `contextsAndNormalization`: PASS
- `binaryMasterOrder`: PASS
- `positiveMatrices`: PASS
- `negativeMatrices`: PASS
- `probeAvoidsSingularLayers`: PASS
- `lowOrderReductionStatus`: PASS
- `lowOrderReductionCoefficients`: PASS
- `lowOrderReductionNoResidual`: PASS
- `customMasterOrder`: PASS
- `positiveLocalRoundTrip`: PASS
- `negativeLocalRoundTrip`: PASS
- `positiveGlobalTransform`: PASS
- `negativeGlobalTransform`: PASS
- `conventionOverrideRejected`: PASS
- `noGeneralLargeInverse`: PASS

## Evidence

- independent coefficient residual: `{0, 0, 0, 0}`
- shifted and non-master residuals: `{{}, 0}`
- machine-readable summary: `results/summary.wl`
- no numerical boundary or finite-point integral was used.
