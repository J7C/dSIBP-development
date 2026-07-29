# MadStree v0.3 independent validation report: T1 mixed three-vertex massless four-state versus quotient

> Generated automatically by `run_validation.wls`.

## Status

- status: `passed`
- checks: `20/20`
- version: `MadStree-v0.3`
- explicit convention: `NuConvention -> "Positive"`; `massive nu=1/5`; `massless nu=1/2`; both lines `G++`

## Fixed family and normalization

- topology: `v1 -- massiveFull(em) -- v2 -- masslessFull(ez) -- v3`
- root normalization: `1`; massive contraction uses the package canonical pinch factor; massless contraction uses `1`.
- RedundantH uses `Pi/2` per active massless Hankel endpoint product, so the local maps are `S={{1,0},{0,I},{0,-I},{1,0}}`, `P={{1,0,0,0},{0,0,I,0}}`.
- quotient sector dimensions: `{8,2,4,1}`; redundant sector dimensions: `{16,4,4,1}`.

## Exact checks

- `representationsFrozen`: PASS
- `sectorDimensions`: PASS
- `globalMapDimensions`: PASS
- `leftInverse`: PASS
- `formulaIntertwining`: PASS
- `contactIntertwining`: PASS
- `dlogIntertwining`: PASS
- `dlogCertified`: PASS
- `oneStepReductionsClosed`: PASS
- `oneStepReductionIntertwining`: PASS
- formula/contact/dlog nonzero residual counts: `{0, 0, 0}`
- reduction shifts: `v1:+1` massive contact and `v3:+1` massless contact; no higher shifts were tested.

## Numerical point, path and orders

- anchor: `{k1 -> -15*I, k2 -> -10*I, k3 -> -5*I, qm -> 4/3, qz -> 5/4}`
- target: `{k1 -> -9*I, k2 -> -6*I, k3 -> -3*I, qm -> 4/3, qz -> 5/4}`
- physical massless momentum: `qz=5/4`, so the tested double-derivative relation contains the nontrivial factor `qz^2=25/16`.
- full-system boundary type: validation-only manufactured compatible ordinary anchor `br=Sglobal.bq`; Frobenius/local singular order: `not applicable`.
- defining-integral oracle: only the 2/4 dimensional child sector with contracted massive line and active massless line; it is not used as the full-system transport boundary.
- affine path: all three vertex energies move synchronously from anchor to target; quotient actual path `{<|"real" -> "0", "imag" -> "0", "realRadius" -> "0", "imagRadius" -> "0"|>, <|"real" -> "1.0000000000000000000000000000000000000000000000000", "imag" -> "0", "realRadius" -> "0", "imagRadius" -> "0"|>}`; redundant actual path `{<|"real" -> "0", "imag" -> "0", "realRadius" -> "0", "imagRadius" -> "0"|>, <|"real" -> "1.0000000000000000000000000000000000000000000000000", "imag" -> "0", "realRadius" -> "0", "imagRadius" -> "0"|>}`.
- `WorkingPrecision=50`, `TransportOrder=64`, `ReferenceTransportOrder=88`, target relative error `1e-20`.

## Numerical checks

- `ordinaryAnchorAndTarget`: PASS
- `childDirectOraclesComputed`: PASS
- `manufacturedAnchorProjection`: PASS
- `childIntegralProjection`: PASS
- `quotientTransportComputed`: PASS
- `redundantTransportComputed`: PASS
- `targetProjection`: PASS
- `quotientRefinement`: PASS
- `redundantRefinement`: PASS
- `masslessRelationsWithQ2`: PASS

## Numerical evidence and timing

- manufactured anchor quotient/projected-redundant maximum relative difference: `0`
- child defining-integral quotient/projected-redundant maximum relative difference: `0``41.69897000433602`
- target quotient/projected-redundant maximum relative difference: `0``48.71571170885438`
- maximum absolute residual among h and physical q^2 relations: `0``47.175332254439155`
- quotient/redundant direct-oracle wall time in seconds: `{0.0107415, 0.0136785}`
- quotient/redundant transport wall time in seconds: `{3.7375581, 7.0062171}`
- total wall time in seconds: `13.089`

## Outputs

- machine-readable summary: `results/summary.wl`
- runtime JSON/cache: `results_temp/` in this validation directory
- direct integration is validation-only and is not loaded by MadStree Kernel.
