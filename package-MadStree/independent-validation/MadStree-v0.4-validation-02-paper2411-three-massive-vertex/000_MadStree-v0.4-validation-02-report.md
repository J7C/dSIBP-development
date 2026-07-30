# MadStree v0.4 independent validation report: T2 one vertex with three massive blocks

> Generated automatically by `run_validation.wls`.

## Status

- status: `passed`
- checks: `12/12`
- version: `MadStree-v0.4`
- explicit convention: `NuConvention -> "Negative"`

## Scope and method

Validate the eight leading coefficients of 2411.03088 Eqs. (3.44)-(3.46), an independent order-28 multivariate series, the MadStree production Frobenius boundary, a validation-only direct integral oracle, and FlintNDE transport. All routes use the same exact parameters, Hankel branches, normalization, and master order.

## Numerical point and orders

- `k0=-12 I, k1=1, k2=2, k3=1`
- `nu0=31/5, nu1=1/5, nu2=2/7, nu3=1/4`
- `seriesOrder=28`, `workingPrecision=60`, `transportWorkingPrecision=50`
- `TransportOrder=72`, `ReferenceTransportOrder=96`

## Actual boundary and transport path

- Frobenius boundary: `k0 -> -I Infinity`; truncated evaluation at anchor `{k0 -> -30*I, k1 -> 1, k2 -> 2, k3 -> 1, nu0 -> 31/5, nu1 -> 1/5, nu2 -> 2/7, nu3 -> 1/4}`
- affine coordinate path from anchor to target: `{k0 -> -30*I + (18*I)*msPathParameter19, k1 -> 1, k2 -> 2, k3 -> 1}`
- FlintNDE adaptive path points in `s`: `{<|"real" -> "0", "imag" -> "0", "realRadius" -> "0", "imagRadius" -> "0"|>, <|"real" -> "0.75000000000000001850371707708594234039386113484701", "imag" -> "0", "realRadius" -> "[2.3647458176421538384488638440645868114541242425586e-60 +/- 2.91e-110]", "imagRadius" -> "0"|>, <|"real" -> "1.0000000000000000000000000000000000000000000000000", "imag" -> "0", "realRadius" -> "0", "imagRadius" -> "0"|>}`
- adaptive path point count: `3`

## Checks

- `negativeConvention`: PASS
- `eightMasters`: PASS
- `boundaryGenerated`: PASS
- `paperAuthority`: PASS
- `noDirectFallback`: PASS
- `masterDigest`: PASS
- `leadingCoefficients`: PASS
- `independentSeriesAtAnchor`: PASS
- `directOracleAtAnchor`: PASS
- `transportComputed`: PASS
- `transportVsPaper`: PASS
- `refinement`: PASS

## Numerical evidence

- production/independent series at anchor: `0``59.69897000433602`
- direct oracle/production at anchor: `2.27415501672151846966018032508023`5.469564334403506*^-45`
- FlintNDE/independent series at target: `9.461630928426300895861696450994348983537771498389242124`27.356927647498047*^-23`
- boundary generation wall time in seconds: `34.5662516`
- direct oracle wall time in seconds: `15.9029978`
- MadStree/FlintNDE transport wall time in seconds: `38.0479034`
- FlintNDE primary/reference transport time in seconds: `{0.7783168999885675, 1.3070107999956235}`
- total wall time in seconds: `128.645`

## Outputs

- machine-readable summary: `results/summary.wl`
- runtime intermediates and Python cache: `results_temp/`
- production code did not call direct integration; `DirectBoundaryOracle.wl` belongs only to this validation directory.
