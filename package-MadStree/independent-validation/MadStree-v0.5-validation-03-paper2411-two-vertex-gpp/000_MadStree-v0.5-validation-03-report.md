# MadStree v0.5 independent validation report: T3 two-vertex G++

> Generated automatically by `run_validation.wls`.

## Status

- status: `passed`
- checks: `18/18`
- version: `MadStree-v0.5`
- master digest: `f4ac081d27546cd9b383af6571ae067b54aeae47a2d195dd52415591e9e82252`
- explicit convention: `NuConvention -> "Negative"`

## Scope, basis and normalization

The independent route encodes 2411.03088 Eqs. (3.3), (4.4), (4.5), and (4.11)-(4.14). The production route uses MadStree's topology, dlog, nested blow-up and boundary producer. Both use the paper order `{I00,I01,I10,I11,IR}` and the exact identity basis map.

- top normalization: `1`
- child normalization Eq. (4.2): `(-4*I)/Pi`
- package child normalization: `(-4*I)/Pi`

## Numerical point, chart and path

- target: `{k12 -> -30*I, k34 -> -6*I, ks -> 1, nu0 -> 2, nu1 -> 1/5}`
- anchor: `{k12 -> -64*I, k34 -> -8*I, ks -> 1, nu0 -> 2, nu1 -> 1/5}`
- blow-up chart: `x=k34/k12`, `y=1/k34`; anchor `{x,y}={1/8, I/8}`
- singular path: `t:0->1` with `{k12 -> (-64*I)/paperT12^2, k34 -> (-8*I)/paperT12}`
- production ordinary adaptive path in `s`: `{<|"real" -> "0", "imag" -> "0", "realRadius" -> "0", "imagRadius" -> "0"|>, <|"real" -> "0.84716221795439614619159737194769442297743552772162", "imag" -> "0", "realRadius" -> "[3.5594280168560174879966422898541433673156336093972e-60 +/- 4.97e-110]", "imagRadius" -> "0"|>, <|"real" -> "1.0000000000000000000000000000000000000000000000000", "imag" -> "0", "realRadius" -> "0", "imagRadius" -> "0"|>}`
- paper ordinary adaptive path in `s`: `{<|"real" -> "0", "imag" -> "0", "realRadius" -> "0", "imagRadius" -> "0"|>, <|"real" -> "0.84716221795439614619159737194769442297743552772162", "imag" -> "0", "realRadius" -> "[3.5594280168560174879966422898541433673156336093972e-60 +/- 4.97e-110]", "imagRadius" -> "0"|>, <|"real" -> "1.0000000000000000000000000000000000000000000000000", "imag" -> "0", "realRadius" -> "0", "imagRadius" -> "0"|>}`

## Orders, precision and timing

- boundary metadata order: `20`
- Frobenius/ordinary transport order: `72`; reference: `96`
- working precision: `50`; target relative error: `1e-20`
- boundary generation wall time: `0.109315 s`
- production transport wall time: `3.532838 s`
- independent paper transport wall time: `3.368496 s`
- total wall time: `8.250435 s`

## Checks

- `negativeConvention`: PASS
- `fiveMastersInPaperOrder`: PASS
- `paperIRNormalization`: PASS
- `boundaryGenerated`: PASS
- `paperBoundaryNoDirectFallback`: PASS
- `thetaRank`: PASS
- `dlogConnection`: PASS
- `singularConnection`: PASS
- `identityBasisMap`: PASS
- `fiveBoundaryCoefficients`: PASS
- `homogeneousFactorization`: PASS
- `contactLeadingVector`: PASS
- `productionTransport`: PASS
- `paperTransport`: PASS
- `fullTargetVector`: PASS
- `contactTargetComponent`: PASS
- `productionRefinement`: PASS
- `paperRefinement`: PASS

## Numerical evidence

- full target-vector relative difference: `0``48.71446323282841`
- contact-component relative difference: `0``48.77138646828452`
- all multivariate and singular-curve connection residuals are exact zero: `True`
- all five principal-branch coefficient residuals are exact zero: `True`

## Outputs

- machine-readable summary: `results/summary.wl`
- runtime JSON and Python cache: `results_temp/` in this validation directory
- no finite-point defining integral was used as production boundary or as the paper expected value.
