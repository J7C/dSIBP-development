# MadStree v0.8 release notes

## Baseline

- Built by modifying v0.7 (version lineage v0.5 -> v0.6 -> v0.7 -> v0.8; v0.7 is frozen).
- The v0.7 source, manual, examples and validation results are kept as the baseline; v0.8 upgrades the bundled FlintNDE to 0.2.0 and rewrites the numerical transport chain to use the pole-residue fast path, embedded truncation certification and backend output caching.

## New features

- **Pole-residue serialization (schema v2)**: the ordinary stage no longer serializes the full rational matrix `Q(i)(s)`; instead each dlog letter `α_j+β_j s` along the affine path is serialized as a pole `p_j=-α_j/β_j` and a residue matrix `M_j` (`madstree_flintnde_transport_v2`). The backend `PartialFractionSystem` generates solution coefficients via pole-state recurrence directly, skipping Cauchy sampling. Coincident poles merge residues automatically. `msAffineLetterData` replaces the v0.7 `msAffineConnectionData`; `msAffineLetterRecord` handles per-letter affine validation and serialization.
- **Embedded truncation certification**: both singular and ordinary stages pass `certificationMode -> "embedded"`; the backend runs a single `referenceOrder` chain and the primary result is recovered by re-evaluating the solution-coefficient prefix via Horner (the prefix property of the recurrence guarantees digit-by-digit agreement), eliminating the reference-chain overhead. Per-segment truncation differences are returned as local error estimates.
- **Dense-output save points**: save points are no longer path nodes; endpoint saves remain attached to the first/last nodes, while internal saves go through the `sample_points` parameter evaluated within an ordinary-segment Cauchy disk without altering the path.
- **Backend output caching**: `msExecuteFlintNDEAdapter` caches backend output under `runtimeDirectory/flintnde_cache/<digest>/`. The digest is computed from the request payload with `saveOutputDirectory` and `backendPackagePath` removed via `Hash[ExportString[#, "RawJSON"]]`, ensuring determinism. Only successful (`status == "success"`) outputs are reused; failed outputs are never cache hits.
- **RootReduce algebraic-number handling**: `msGaussianRationalParts` applies `RootReduce` before `ComplexExpand` for algebraic constants like `(-1)^(1/3)`, ensuring serialized strings are always `p/q` literals parseable by `arb()`.
- **Non-dlog fallback markers removed**: `Boundary.wl` residual markers `fallbackUsedQ` and `directIntegrationFallbackQ` are deleted; numerical entry is gated by `certifiedByFormulaChecks` only. Corresponding test assertions are removed.

## Interface and path changes

- `MSFlintNDEConfiguration[]` default relative path remains `Vendor/FlintNDE` resolved against the current version directory; the vendored backend is now FlintNDE 0.2.0.
- The Python adapter `flintnde_transport.py` adds `_build_partial_fraction_system` (v2 pole-residue) and `_build_rational_system` (v1 rational matrix / singular stage) branches; poles are converted to acb balls via `GaussianRational.to_acb()`.
- The ordinary stage uses `build_straight_path` (straight-line stepping, `step_fraction=0.45`) instead of `build_adaptive_path`; the singular stage keeps `build_adaptive_path` + detour.
- `relative_difference_inf` now uses `matrix_norm_inf` (identical behaviour for column vectors), enabling batch-Frobenius multi-column snapshots to pass through the embedded truncation certification path.
- `MSFlintNDETransport` ordinary inputData no longer contains `variable`/`matrix`/`saveOutputDirectory`; it now carries `letters` (pole-residue record list).

## Fixes

- Fixed time-power symbol `a` leaking into the payload because the letter matrix was serialized without applying `constantRules`.
- Fixed `PartialFractionSystem` poles not converted via `GaussianRational.to_acb()`, causing `'GaussianRational' object has no attribute 'str'`.
- Fixed batch-Frobenius multi-column snapshots triggering `vector_norm_inf requires a column vector` during embedded truncation certification.

## Migration

- The v0.7 loading recipe is unchanged; adding `versions/MadStree-v0.8/` to `$Path` allows a direct `Needs["MadStree`"]`.
- Scripts depending on the v0.7 schema-v1 rational-matrix serialization must update to the v2 pole-residue format or add a v1-compatibility branch on the MadStree side.
- The `flintnde_cache/` directory is created automatically by MadStree and is a calling-directory artefact; `results_temp/flintnde_transport/` remains a temporary JSON exchange area deleted on success.

## Validation status

- `check_core` fresh pass `49/49`.
- `test_package_artifacts` fresh pass `18/18`.
- `test_flintnde_boundary` fresh pass `9/9` (`relativeDifference ≈ 4.9e-45`).
- `test_flintnde_massive_vertex` fresh pass `7/7`.
- `test_flintnde_massless_edge` fresh pass `9/9`.
- `test_flintnde_massive_full_edge` fresh pass `5/5`.
- `test_flintnde_mixed_three_vertex` fresh pass `7/7`.
- `test_flintnde_vertex_family` fresh pass `7/7`.
- `test_dsibp_derivative_dlog` fresh pass `9/9`.
- `test_simultaneous_cycle_chart` fresh pass `22/22`.
- `test_vertex_family_reduce` fresh pass `18/18`.
- Total `160/160` checks passed.

## Known limitations

- General IBP systems are not generated, Kira is not run, and the external-momentum derivative implementation of dSIBP is not duplicated.
- The pole-residue fast path applies only when dlog letters reduce to `α+β s` along the affine path; non-affine or higher-degree letters fail closed (`FlintNDEExactPathRequired`).
- The mathematical capability boundary of the bundled FlintNDE 0.2.0 matches the source version; the vendor does not extend its irregular/Stokes coverage.
