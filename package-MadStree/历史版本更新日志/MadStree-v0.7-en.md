# MadStree v0.7 release notes

## Baseline

- Built by modifying v0.6 (version lineage v0.5 -> v0.6 -> v0.7; v0.6 was copied from frozen v0.5).
- The v0.6 source, manual, examples and validation results are kept as the baseline; v0.7 only adjusts the version number and adds English comments, the load-time citation reminder, examples and documentation synchronization on top.

## New features

- Added the version-root `MadStree.m`; adding `versions/MadStree-v0.7/` to `$Path` allows a direct `Needs["MadStree`"]`.
- Bundled the FlintNDE `v0.1.0.dev0` source under `Vendor/FlintNDE/`; the default adapter no longer depends on the external sibling `package-FlintNDE` directory.
- Added `MSFormulaData`, which returns at once all-sector masters, the `M1/M0/U` recurrence metadata of every sector and the complete block-triangular dlog DE in the same master order.
- Added `MSWriteFormulaArtifacts`, which writes `masters.wl`, `recurrence_metadata.wl`, `dlog_de.wl` and `manifest.wl` to the calling script directory and returns the actual output directory and file paths.
- Added `MSBatchEvaluateTree`, a multi-point batch evaluation entry that can reuse one automatic boundary or a finite anchor (`AnchorPoint`/`AnchorValues`) and supports `Parallel` execution; it returns the same result associations as `MSFlintNDETransport` and can be handed directly to `MSExportEvaluationData`.
- Added `MSExportEvaluationData`, which exports multi-point numerical results (point coordinates + real/imaginary parts of every master + status/relativeDifferenceInf/targetRelativeErrorMet) to CSV and JSON for downstream plotting tools; `MSOutputDirectory` writes by default to `results/madstree_evaluation/run-UUID/` under the calling directory.
- `TimePowerRules` optionally substitutes the vertex time powers `a_i`; the default `Automatic` keeps them symbolic and lists the substitutable symbols in the manifest.

## Interface and path changes

- The default relative path of `MSFlintNDEConfiguration[]` is now `Vendor/FlintNDE`, resolved against the current MadStree version directory.
- `MSSetFlintNDERelativePath[path]` remains the only override interface, but `path` is now resolved relative to the current version directory.
- Python uses the default `__pycache__/`; the repository-root `.gitignore` ignores `__pycache__/` and `*.py[cod]` at any depth. Only JSON, save points and computed results belong to the calling directory.
- MadStree adds no external-momentum derivative operators. The new DE checks reuse the dSIBP `ds`, reduce with MadStree `MSReduce`, and compare against the direct `MSDLogDE` formula.
- `MSToDSIBPJ/MSFromDSIBPJ/MSFromDSIBPExpression` migrated to the native dSIBP 020 `J[sectorKey,timeShifts,stateBits]`; the 019 root-line packs are no longer generated or parsed. Cross-package use requires the sector/state-slot schemas and per-sector normalizations to agree on both sides.

## Fixes

- The singular-then-ordinary combined backend of `MSFlintNDETransport` now hoists `relativeDifferenceInf`, `relativeDifferenceMidpoint`, `targetRelativeError`, `primarySeconds` and `referenceSeconds` to the top level of `flintNDE`, isomorphic to the pure-ordinary boundary output; previously only `targetRelativeErrorMet` was at the top level, so the flat access `flintNDE["relativeDifferenceInf"]` returned `Missing` for `singularFrobenius` boundaries in example 01. The `singularLaunch`/`ordinaryTransport` substructures are unchanged and nested access remains compatible.

## Migration

- The explicit loading path of v0.6 can be changed to add the v0.7 version root to `$Path`; the `Kernel/` directory no longer needs to be added directly.
- Scripts depending on an external sibling FlintNDE can remove the manual path setup; to use another backend copy shipped with the version, call `MSSetFlintNDERelativePath`.
- Scripts that need formula data on disk call `MSWriteFormulaArtifacts`; a relative `MSOutputDirectory` is always resolved against the calling script directory.

## Validation status

- The staged package/artifact smoke passed fresh `16/16`, covering version-root loading, Vendor availability, all-sector data, `a_i` preservation/substitution and calling-directory output.
- After the 020 adapter, the package/artifact smoke expanded to a fresh `18/18`. The 75 derivatives of the mixed three-vertex cross-package DE all close onto the 15 masters; after unifying the massive child normalization, the five `15 x 15` matrices over `{k1,k2,k3,sE1,sE2}` agree term by term with the direct formula, passing `9/9`.
- The dlog contact event phase is aligned with the two formula atom types: pure massive uses the component `phaseSign`, events containing masslessFull use `(-1)^N0`. The 2401 Eq. (3.68) core `49/49`, the positive/negative massless defining integrals/FlintNDE `9/9`, the three-edge simultaneous/cycle/chart `22/22` and the cross-package DE `9/9` all pass together.
- v0.7 is built on v0.6 (v0.6 was copied from frozen v0.5); all eleven development tests and the three original examples of v0.5 passed fresh serial runs (historical evidence). The T1--T6 independent validations passed with `24/24`, `12/12`, `18/18`, `15/15`, `17/17`, `16/16`; the official reports and machine summaries live in the versioned independent-validation directories (v0.5). The 25-state and 15-state boundaries of T1 were generated directly by v0.5, and T6 invokes the built-in FlintNDE through the public Wolfram entry.

## Known limitations

- General IBP systems are not generated, Kira is not run, and the external-momentum derivative implementation of dSIBP is not duplicated.
- `MSFormulaData` returns product data only after `MSDLogDE` passes the formula dlog certification; it fails closed when a contact shift or normalization is not closed.
- The mathematical capability boundary of the bundled FlintNDE matches the source version; the vendor does not extend its irregular/Stokes coverage.
