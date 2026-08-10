# MadStree

Current version: `v0.7`. This directory is built by modifying v0.6 (version lineage v0.5 -> v0.6 -> v0.7); interface changes are listed in `UPDATE_NOTES_en.md` (Chinese: `UPDATE_NOTES.md`).

`MadStree` is a Wolfram Language package that works directly with the time-integral tensor formula. The input can be an ordered dS tree topology or a pure time-only incidence graph that does not integrate loop momenta; the output includes contact-reachable sectors, ordered master integrals, stepwise or full iterative reduction, a block-triangular dlog connection and automatic boundary certificates. The main algorithm does not generate general IBP systems and does not call Kira.

The default conventions are

```text
time power: (-tau)^A
nu: |nu|
h(nu,0;z): z^nu H_nu(z)
NuConvention: "Positive"
```

Only the function name `h` is used. `NuConvention -> "Negative"` selects the negative-prefactor convention of 2401.00129; the two formula sets are related by the uniform replacement `nu -> -nu`.

`NuConvention` is chosen only at `MSInitTree` initialization. Once a context is built, the formula matrices, recurrence, dlog and all-sector H/h basis changes read this value fixed; there is no per-call convention override.

## Loading

```wl
packageRoot = ".../package-MadStree/versions/MadStree-v0.7";
AppendTo[$Path, packageRoot];
Needs["MadStree`"];
```

## Minimal workflow

```wl
spec = <|
  "vertices" -> {
    <|"id" -> v1, "energy" -> k1, "timePower" -> a1|>,
    <|"id" -> v2, "energy" -> k2, "timePower" -> a2|>
  },
  "lines" -> {
    <|"id" -> e1, "type" -> "masslessFull", "endpoints" -> {v1, v2},
      "momentum" -> q, "skType" -> "++", "nu" -> 1/2,
      "masslessRepresentation" -> "Quotient"|>
  }
|>;

context = MSInitTree[spec];
masters = MSMasterIntegrals[context];
topKey = First[context["sectorOrder"]];
matrices = MSFormulaMatrices[context, topKey];
de = MSDLogDE[context];

formulaData = MSFormulaData[context];
written = MSWriteFormulaArtifacts[
  context,
  TimePowerRules -> Automatic
];
written["outputDirectory"]

targetRules = {k1 -> -9 I, k2 -> -3 I, q -> 1, a1 -> 1, a2 -> 1};
chart = MSBoundaryChartCertificate[context, targetRules];
```

The massless graph above can directly generate a complete multi-sector Frobenius boundary and transport to ordinary points:

```wl
boundary = MSBoundaryData[context, targetRules, RankOrder -> {v1, v2}];
value = MSEvaluateTree[
  context,
  targetRules,
  RankOrder -> {v1, v2},
  WorkingPrecision -> 40,
  TransportOrder -> 80,
  ReferenceTransportOrder -> 104,
  FlintNDESavePoints -> {{0, "save"}, {1/2, "save"}, {1, "save"}}
];
```

`de["masters"]` is the unique authority for the order of the DE rows and boundary vectors. Except for the single-vertex massive-external family, which keeps the explicit 2411.03088 Eqs. (3.44)--(3.46) series optimization, `MSBoundaryData` generates for closed tree/time-only contexts a nested curve from the sector DAG, component base powers, slot registry, normalization and strict time rank, pulls back the complete dlog connection, computes the residue, and solves the indicial leading vector of every master over the ancestor sectors. `MSEvaluateTree` hands the exact `{a,b,C}` branches to FlintNDE, transports from the regular singular point to the finite matching point, and then continues to the user's ordinary target point. Production code never evaluates defining integrals or calls `NIntegrate`; these are allowed only as independent-validation oracles.

Generic entries never dispatch on graph ids, vertex counts, master counts or paper numerical points. They fail closed in a structured way only when the dlog is not closed, the rank/chart does not pass the normal-crossing certificate, the late-time exponents do not decay, the pullback system is not an exact regular singularity, or the target/anchor lies on a DE letter.

`masslessFull` defaults to `"Quotient"`: the whole edge contributes one shared two-state slot. If `"masslessRepresentation" -> "RedundantH"` is given at initialization (equivalent alias `"functionSystem" -> "h"`), the same edge keeps two h endpoints and four states; `M1/M0`, contacts, recurrence, `MSReduce`, dlog and the H/h transforms are all generated directly from these two slots. The choice is written into the context and cannot be switched per call. `RedundantH` accepts only massless `nu=1/2`; the legacy master order and interfaces of the default quotient are unchanged.

The `sectorKey` of every sector is a fixed-length string in the root `lines` order: `0` means the propagator is contracted and `1` means it is not; lines that cannot undergo contact shrink keep bit `1`. The top is the all-`1` string. Leading zeros are part of the identity and the key must never be treated as an integer. `context["sectorKeySchema"]` gives `rootLineOrder`, the width and the bit semantics; for example, contracting `{e1,e2,e4}` in `{e1,e2,e3,e4}` gives `"0010"`. The full identity of a master is `MSIntegral[sectorKey,timeShifts,stateBits]`, so different subsectors are never the same integral even if their local shifts/bits coincide. The `sectorIdentityCertificate` of `MSInitTree` checks at once the contraction sets, sector keys, full masters, global indices and an SHA-256 digest over the full master order; collisions reject initialization. The massless top-to-sub dlog contact atoms multiply by `(-1)^N` for the actual number of selected massless lines in the event; simultaneous contacts use no graph-specific symbol table.

`MSBoundaryChartCertificate[context,targetRules]` builds the nested blow-up `1/K[sigma[j]]=Product[x[r],{r,j,V}]` before the boundary computation, fixes all thetas sector by sector, and checks that the complete dlog letters, normalization, coordinate Jacobian and the new denominators from shifted contacts are coordinate monomials times a nonzero boundary unit. `RankOrder -> All` checks all root-time strict charts; `MSBoundaryData` returns `BoundaryChartNotCertified` when the certificate fails.

## Common theta and time-only cycles

Full lines on the same current component pair automatically form a common-theta bundle. The program generates only nonempty odd-subset events with coefficient `2^(1-Length[selected])`; one event deletes the selected lines and merges the vertices exactly once. Sectors come from an event BFS, not the full-line power set. After merging, an unselected massless full line keeps only the even state, a massive full line uses the `10 -> 01` equal-time canonical form, and the raw tensor matrix is projected onto the true master space with the stored projection/embedding.

Pure time-only cycles use the dedicated entry:

```wl
cycleContext = MSInitTimeGraph[<|
  "vertices" -> {...},
  "lines" -> {...}
|>];
```

It allows only time integrals over fixed line momenta and neither reads nor generates loop momenta, ISPs, Landau or threshold data. Active self-loops no longer trigger contacts; multiple paths to the same vertex partition/contracted set are canonicalized to one sector.

## Single-vertex function families

A single-vertex family needs no fake topology. The compact input follows the `ki/nui` convention of the reference code:

```wl
vertexContext = MSInitVertexFamily[<|
  "ki" -> {k0, k1, k2},
  "nui" -> {a0, nu1, nu2},
  "hankelBranches" -> {1, 2}
|>];

vertexDE = MSDLogDE[vertexContext];
vertexValue = MSEvaluateVertexFamily[vertexContext, targetRules];
```

Here `First[ki]` is the pure vertex phase energy and `First[nui]` is the base power of `(-tau)`; the remaining entries give one by one the momentum and `nu=|nu|` of each h block. One may also give `k0`, `timePower`, `hBlocks` and `exponentialBlocks` explicitly. A pure exponential block is `1x1` and adds no state bits; every h block is `2x2`. The `NuConvention` chosen at initialization stays fixed and cannot be overridden in recurrence, DE, numerics or H/h transforms.

## Direct reduction

```wl
reduction = MSReduce[
  2 MSIntegral[First[vertexContext["sectorOrder"]], {1}, {0, 0}] -
  3 MSIntegral[First[vertexContext["sectorOrder"]], {-1}, {1, 0}],
  vertexContext,
  MasterBasis -> Automatic
];
```

`MSReduce` handles only valid `MSIntegral[sectorKey,timeShifts,stateBits]` objects in a fixed initialized context: `sectorKey` must belong to the contact-reachable sector DAG, `timeShifts` are integer shifts per component of that sector, and `stateBits` traverse all two-dimensional slots of the sector in the 2401 binary order. It can handle finitely many such objects linearly, but does not support new propagator powers, new discrete indices, sectors outside the context, or another function family. Reduction recurses along the shift/contact DAG to the zero-shift masters and caches repeated subproblems. The returned `masterBasis`, `coefficientVector` and `masterRules` are strictly ordered; `result` is an explicit linear combination of master integrals; `nonMasterResidual` and `remainingShiftedIntegrals` must both be empty for a complete reduction. `MasterBasis` may be any permutation of all context masters, but missing, duplicated or extra objects are rejected. `singularLayers` records stepwise the direction, component and denominators: raising toward zero reports only the `M0` energy letters, and lowering toward zero reports only the `M1` eigenvalues.

If the top-to-sub `R^(1)` lands on a child with a nonzero shift, `MSDLogDE` calls the same formula recurrence column by column, builds the reduction matrix from the shifted child to the global ordered masters, and right-composes it with the contact block. Each contact block keeps `shiftReductionRecords`, the residual, remaining shifts and singular layers; if any column does not close, the dlog status is `contactShiftReductionFailed` and no falsely closed connection is emitted.

The formula layer never constructs a generic large matrix inverse. The fixed `sigma2` of massive endpoints and `RedundantH` massless endpoints uses the paper's `2x2` transform and its explicit inverse; the fixed `sigma1` of massless shared slots uses the self-inverse Hadamard; an all-sector matrix is only the Kronecker product of these local matrices. `M1` takes reciprocals of diagonal entries in the state-bit basis and `M0` takes reciprocals letter by letter in the simultaneous diagonal basis. If a future slot cannot be simultaneously diagonalized along a Pauli direction, this fast path must fail closed.

The public H/Hankel-state to h-state transforms are `MSHTohMatrix`, `MShToHMatrix` and `MSConvertBasis`. Local and all-sector state vectors read the fixed `NuConvention` of the context; an already integrated `MSIntegral` also involves base time powers and is rejected explicitly when it cannot be recovered uniquely.

The FlintNDE source ships inside this version directory; its default location is defined in a single relative-path variable:

```wl
MSFlintNDEConfiguration[]
(* relativePath -> Vendor/FlintNDE *)

MSSetFlintNDERelativePath[FileNameJoin[{"new-name", "code", "package"}]]
```

Paths are always relative to the current MadStree version directory; if Vendor is renamed or moved later, only this item changes. `MSNumericalSystem` remains the low-level entry for users who supply their own boundary vectors.

Transient JSON produced by automatic MMA calls is written by default to the calling script directory:

```text
results_temp/flintnde_transport/
```

`MSRuntimeDirectory -> path` selects another caller directory explicitly: absolute paths are used directly and relative paths are resolved against the calling script directory, independent of the process working directory. On success the transient JSON files are deleted automatically; on failure the input/output paths are kept for diagnostics. Python creates `__pycache__/` next to the relevant package by default; the directory and `*.pyc` are ignored by Git and can be reused under the same Python version and source state. Apart from this interpreter cache, the package source directory never receives run artifacts.

`FlintNDESavePoints` accepts only `{{coordinate,"save"},...}`, or a stage-split Association `<|"singular"->{{...}},"ordinary"->{{...}}|>`; a third name field is not allowed. The backend writes one JSON per reached marker point immediately, and only afterwards aggregates them into

```text
results/flintnde_save_points/run-UUID/madstree_flintnde_save_points.json
```

Ordinary points record the coordinate and the full result vector; a regular-singular start stores the reusable Frobenius `{a,b,C}` without fabricating a function value at the singularity. If an internal saved coordinate of the same DE is an exponential-type singularity that FlintNDE certifies and can bridge, the Python backend merges its `{phi,a,b,C}` / `exponential_boundary` record verbatim; start-only formal points or intermediate points requiring Stokes data are still rejected at the path-planning stage. When a later path segment fails, completed per-point files are kept but the full aggregate is not written.

The full formulas, the massless `4 -> 2` quotient, contact shifts and the top-to-sub dlog derivation are in [Documentation/tree_formula.pdf](Documentation/tree_formula.pdf).

## Examples

- [01_massless_full_edge.wl](Examples/01_massless_full_edge.wl): massless quotient, master integrals, recurrence, dlog and the automatic boundary/numerical entry (including a user custom finite boundary and batch multi-point evaluation with CSV/JSON export).
- [02_vertex_family_reduction.wl](Examples/02_vertex_family_reduction.wl): single-vertex input, local tensor inverses and finite-combination reduction.
- [03_time_only_cycle_chart.wl](Examples/03_time_only_cycle_chart.wl): time-only cycle, common theta, contact sector and all strict-rank chart certificates.
- [04_three_vertex_tree.wl](Examples/04_three_vertex_tree.wl): three-vertex massless tree with the `+++` vertex structure, followed by a batch multi-point evaluation with CSV/JSON export.
- [05_massive_three_vertex_tree.wl](Examples/05_massive_three_vertex_tree.wl): three-vertex massive tree with the `+++` vertex structure and non-half-integer nu, followed by a batch multi-point evaluation with CSV/JSON export.

The examples migrated from v0.5 into v0.7 (v0.5's three original examples passed fresh runs with exit code `0`); examples 04 and 05 run end-to-end with exit code `0`, and the batch sections export `evaluation_data.csv/json` under `results/madstree_evaluation*`.

## Current boundaries

- Common-theta odd-subset simultaneous contacts, coincident massless/massive quotients, event-reachable sector BFS and pure time-only cycles are supported; this does not mean loop-momentum integration is supported.
- The local two-state and all-sector H/h state vectors are invertible; a basis change of an already integrated `MSIntegral` changes the family base time powers and is currently not disguised as an ordinary state transform.
- Production boundaries never dispatch on graph names or master counts. The single-vertex massive-external family keeps the 2411 explicit-series optimization; every other closed tree/time-only context builds the nested curve, complete dlog pullback residue and ancestor-sector leading system from the sector DAG, component/slot metadata, normalization and strict time rank. When the formula/dlog/chart is not closed, the late-time exponents do not decay, or the pullback system is not an exact regular singularity, the package fails closed and never falls back to finite-point defining integrals.
- FlintNDE transport requires the pulled-back connection to be in exact `Q(i)(s)` or `Q(i)(t)`. The independent `15 x 15`/`25 x 25` boundary and transport of the T1 mixed three-vertex case passed `24/24`; T2 (single-vertex three massive) passed `12/12`; T3 (two-vertex `G++`) passed `18/18` for the paper/package basis map, the five boundary branches and the full target vector. The pure-massless and triangle time-only development checks use the same generic boundary producer.
- FlintNDE implements exact Lee--Moser projector balances, strictly decoupled exponential times power-log, and the start-only formal asymptotics of second-order poles with simple distinct leading roots. `build_adaptive_path_plan` first reports `continuation_ready`; strictly decoupled exponential singularities may be saved as `{phi,a,b,C}` for the start, end and intermediate bridges, while formal branches may only save the start; uncertified high poles, interior points or endpoints that require ramification/algebraic extensions/general Stokes connections must be rejected. Wolfram save points use `{coordinate,"save"}`; on later failure, completed per-point files are kept but the full aggregate is not written.

v0.7 is built by modifying v0.6 (v0.6 was copied from frozen v0.5); all eleven development tests, the three original examples and the cross-package DE checks of v0.5 passed fresh serial runs (historical evidence), and the T1--T6 independent validations passed with counts `24/24`, `12/12`, `18/18`, `15/15`, `17/17`, `16/16` (reports and machine summaries live under `../../independent-validation/MadStree-v0.5-validation-*/`).
