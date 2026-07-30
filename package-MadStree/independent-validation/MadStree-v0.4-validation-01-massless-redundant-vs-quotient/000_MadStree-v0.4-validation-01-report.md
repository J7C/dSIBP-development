# MadStree v0.4 independent validation report: T1 mixed three-vertex massless four-state versus quotient

> Generated automatically by `run_validation.wls`.

## Status

- status: `passed`
- checks: `24/24`
- version: `MadStree-v0.4`
- explicit convention: `NuConvention -> "Positive"`; `massive nu=1/5`; `massless nu=1/2`; both lines `G++`

## Fixed family and normalization

- topology: `v1 -- massiveFull(em) -- v2 -- masslessFull(ez) -- v3`
- root normalization: `1`; massive contraction uses the package canonical pinch factor; massless contraction uses `1`.
- RedundantH uses `Pi/2` per active massless Hankel endpoint product, so the local maps are `S={{1,0},{0,I},{0,-I},{1,0}}`, `P={{1,0,0,0},{0,0,I,0}}`.
- quotient sector dimensions: `{8,2,4,1}`; redundant sector dimensions: `{16,4,4,1}`.
- root line order: `{em,ez}`; quotient and RedundantH sector keys: `{"11", "01", "10", "00"}`; key storage type: `String`.

## Fixed-point numerical matrix checks

- `representationsFrozen`: PASS
- `sectorDimensions`: PASS
- `globalMapDimensions`: PASS
- `leftInverseNumeric`: PASS
- `formulaProjectionNumeric`: PASS
- `contactProjectionNumeric`: PASS
- `dlogProjectionNumeric`: PASS
- `dlogCertified`: PASS
- `oneStepReductionsClosed`: PASS
- `oneStepReductionProjectionNumeric`: PASS
- maximum residuals `{left inverse, formula, contact, dlog, reduction}`: `{0, 0, 0, 0``77.78167013703201, 0}`
- reduction shifts: `v1:+1` massive contact and `v3:+1` massless contact; no higher shifts were tested.

## Numerical point, path and orders

- formula/contact/dlog substitution points: `{{k1 -> -15*I, k2 -> -10*I, k3 -> -5*I, qm -> 4/3, qz -> 5/4}, {k1 -> -480*I, k2 -> -60*I, k3 -> -7*I, qm -> 4/3, qz -> 5/4}}`
- production boundary rank: `{v1,v2,v3}`; quotient anchor: `{k1 -> -512*I, k2 -> -64*I, k3 -> -8*I, qm -> 4/3, qz -> 5/4}`
- target: `{k1 -> -480*I, k2 -> -60*I, k3 -> -7*I, qm -> 4/3, qz -> 5/4}`
- physical massless momentum: `qz=5/4`, so the tested double-derivative relation contains the nontrivial factor `qz^2=25/16`.
- quotient and RedundantH both use their own production `2411GenericSectorLeadingSeries`; all 25 RedundantH boundary branches are generated directly by MadStree and transported in the full 25-dimensional DE. `Sglobal/Pglobal` are used only after generation for cross-checks.
- complete 15/25 dimensional systems are transported from their Frobenius singular starts; quotient actual ordinary path `{<|"real" -> "0", "imag" -> "0", "realRadius" -> "0", "imagRadius" -> "0"|>, <|"real" -> "1.00000000000000000000000000000", "imag" -> "0", "realRadius" -> "0", "imagRadius" -> "0"|>}`; redundant actual ordinary path `{<|"real" -> "0", "imag" -> "0", "realRadius" -> "0", "imagRadius" -> "0"|>, <|"real" -> "1.00000000000000000000000000000", "imag" -> "0", "realRadius" -> "0", "imagRadius" -> "0"|>}`.
- FlintNDE batch column counts are `{15, 25}`; local basis and ordinary Taylor matrices are shared within each batch.
- production boundary uses `BoundarySeriesOrder=20`; transport uses `WorkingPrecision=30`, `TransportOrder=24`, `ReferenceTransportOrder=32`, target relative error `1e-8`.

## Numerical checks

- `ordinaryAnchorAndTarget`: PASS
- `physicalBoundariesGenerated`: PASS
- `physicalLeadingProjection`: PASS
- `physicalLeadingEmbedding`: PASS
- `redundantBoundaryGeneratedDirectly`: PASS
- `batchColumnCounts`: PASS
- `quotientTransportComputed`: PASS
- `redundantTransportComputed`: PASS
- `productionMatchPointProjection`: PASS
- `productionTargetProjection`: PASS
- `quotientRefinement`: PASS
- `redundantRefinement`: PASS
- `allRelevantMasslessSectorsCovered`: PASS
- `completeI25MasslessRelationsWithQ2`: PASS

## Numerical evidence and timing

- physical Frobenius leading quotient/projected-redundant maximum relative difference: `0``34.69897000433602`
- physical Frobenius leading redundant/embedded-quotient maximum relative difference: `0``24.69897000433602`
- production match-point `I15` versus `Pglobal.I25` maximum relative difference: `0``28.753198245163848`
- target quotient/projected-redundant maximum relative difference: `0``29.039215520609016`
- maximum absolute residual among h and physical q^2 relations: `0``37.50298929142859`
- quotient/redundant production-boundary generation wall time in seconds: `{0.3744714, 0.5245192}`
- quotient/redundant full physical transport wall time in seconds: `{7.6948773, 16.6509235}`
- total wall time in seconds: `27.195`

## Outputs

- machine-readable summary: `results/summary.wl`
- runtime JSON/cache: `results_temp/` in this validation directory
- no direct `NIntegrate` oracle or manufactured boundary is used in this T1 route.
