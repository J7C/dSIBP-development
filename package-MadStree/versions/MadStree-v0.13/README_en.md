# MadStree

Current version: `v0.13`. This directory is upgraded from v0.12; interface changes are listed in `UPDATE_NOTES_en.md` (Chinese: `UPDATE_NOTES.md`).

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
packageRoot = ".../package-MadStree/versions/MadStree-v0.13";
AppendTo[$Path, packageRoot];
Needs["MadStree`"];
```

The first successful load prints one citation reminder. arXiv identifiers are clickable
in notebooks, while a headless kernel prints full URLs. MadStree lists only
[arXiv:2401.00129](https://arxiv.org/abs/2401.00129),
[arXiv:2411.03088](https://arxiv.org/abs/2411.03088), and the MadStree package paper
(arXiv identifier pending).

## Minimal workflow

```wl
spec = <|
  "vertices" -> {
    <|"id" -> 1, "externalLegEnergy" -> k1, "timePower" -> a1, "vertexType" -> "+"|>,
    <|"id" -> 2, "externalLegEnergy" -> k2, "timePower" -> a2, "vertexType" -> "+"|>
  },
  "lines" -> {
    <|"type" -> "massless", "endpoints" -> {1, 2},
      "momentum" -> q, "nu" -> 1/2,
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

targetRules = {k1 -> 9 I, k2 -> 3 I, q -> 1, a1 -> 1, a2 -> 1};
chart = MSBoundaryChartCertificate[context, targetRules];
```

`"vertexType" -> "+"|"-"` is the vertex's Schwinger--Keldysh contour branch and is
required explicitly on every vertex. A propagator no longer accepts `skType`, `sigma`, or
endpoint-sign input. Its Full/Cross/External class, contour label, overall sign, endpoint signs,
and default Hankel branches are derived from the vertices listed in `"endpoints"`. Public line
`"type"` accepts only `"massive"` or `"massless"`. Propagators have no public ID field; MadStree
always assigns `1,2,...` internally in the exact `"lines"` input order. Only an explicit
`thetaBundles` declaration refers to propagators through these position numbers.

`"externalLegEnergy"` does not mean that a vertex itself carries an energy. It is the
parameter of the theta-free external-leg exponential attached to the vertex.
`vertexType="+"` gives `Exp[-I externalLegEnergy tau]`, while `"-"` gives
`Exp[+I externalLegEnergy tau]`. The SK contour sign is also derived from `vertexType`,
but is stored separately from the exponent sign internally. For a positive damping
coordinate `K`, use `externalLegEnergy=+I K` on a `+` vertex and `-I K` on a `-` vertex.

The massless graph above can generate a complete multi-sector Frobenius boundary and transport to one or more user points through one entry point:

```wl
result = MSEvaluatePath[
  context,
  {targetRules},
  FlintNDEPathPlanning -> True,
  BoundaryScale -> 4,
  RankOrder -> {v1, v2},
  PythonExecutable -> "...",
  WorkingPrecision -> 200,
  TransportOrder -> 80,
  ReferenceTransportOrder -> 104,
  TargetRelativeError -> "1e-20",
  MessageLanguage -> "EN"
];
```

`TransportOrder -> 80` is the production order: returned nodes, dense user points, segment
endpoints, and regulator-fit samples come from the lower-order primary chain.
`ReferenceTransportOrder -> 104` runs only the higher-order reference chain used by
`TargetRelativeError`. Across complex-affine segments, both chains propagate their own endpoint;
the reference value neither replaces user output nor becomes the next primary initial state.

For a Laurent limit in a shared regulator, use

```wl
epSeries = MSReconstructEpSeries[
  context, ep, pointTemplate,
  MaximumEpPower -> 0,
  EpGoalDigits -> 20,
  ParallelTaskCount -> 12
];
```

`MaximumEpPower` is the highest requested power; its default `0` asks for poles, if present,
and the finite part. By default users do not supply `ep` samples. Before any numerical NDE solve, the actual
symbolic boundary condition and dlog DE certify the lowest integer power. A negative DE Laurent
power, a non-Laurent boundary, or an unproved leading coefficient fails closed. The fit initially
includes two powers above the user maximum; failed independent validation adds two powers per round,
solves only new production points, and reuses separate production/validation caches. Three failed
rounds return the current best coefficients without relaxing the tolerance. Such a result has
`status -> "computed_with_warning"` and `precisionTargetMet -> False`; it is not precision-certified.
`ParallelTaskCount` defaults to 12 and controls outer
process parallelism, not python-flint's in-process `ctx.threads` setting.

To restrict every regulator value to a user-approved range, set `EpSamplePoints -> {...}` and
`EpValidationPoints -> {...}` explicitly. The former is an ordered production candidate pool and
may contain surplus points. With `EpInitialInternalMaximumPower -> q`, the first round consumes only
the prefix required to fit through `ep^q`; failed validation incrementally consumes later candidates
while reusing cached values. Validation points never enter the fit and must be disjoint from the
whole production pool. Exhaustion never generates an out-of-range point and is reported as
`candidate_pool_exhausted` while retaining the current coefficients.

Alternatively, `EpSampleAngleRange -> {thetaMin,thetaMax}` selects an open angular interval in
radians for automatic complex samples. Up to three uniformly spaced interior rays are used; the
magnitudes remain controlled by the precision, pole depth, and fit order, with no user radius cap.
Validation samples keep the corresponding angles and reduce only the magnitudes. MadStree converts
the high-precision generated points to exact Gaussian rationals before the exact dlog pullback.
These options default to `Automatic`, so the default call and backend schema are unchanged.

`WorkingPrecision` defaults to 200 decimal digits for both `MSBoundaryData` and `MSEvaluatePath`.
An explicit positive integer overrides the default; the backend uses
`ceil(WorkingPrecision log2(10))+32` bits.

For multiple points, replace the second argument with `{pointP1, pointP2, pointP3}`. MadStree partitions the input order into maximal consecutive complex-affine one-variable segments `x(s)=x0+s v`, pulls each segment back once, and sends all exact complex parameters to FlintNDE. MadStree does not plan nodes or detours. Bare coordinates are returned; `{coord,"tmp"}` is transient, and every other string tag is rejected.

Any multipoint transport through intermediate nodes is a jump; only an explicit crossing of a singularity through a local-basis connection is a singularity jump. `SingularityMode -> "Avoid"` is the default and returns `"Singular Path Pair"` with the offending adjacent points when a segment hits a singularity. Only `SingularityMode -> "SingularityJump"` permits a singularity jump; the planner builds incoming/outgoing matches and looks ahead through later user points. Its multivalued branch is equivalent to a detour path and must be confirmed by the user. `MessageLanguage -> "EN"|"CN"` is case-sensitive and defaults to English.

`FlintNDEPathPlanning -> True` lets FlintNDE plan nodes inside each segment. User points covered by one node form an evaluation bucket and use that node's stored vector series: buckets of at least eight points use subproduct/remainder-tree fast multipoint evaluation, while small buckets use the iterative algorithm. `False` preserves every user point as a node and never calls the planner. Different affine segments never share local coefficients.

`de["masters"]` is the unique authority for DE rows and boundary-vector order. `MSEvaluatePath` sends exact `{a,b,C}` branches, all affine segments, and the selected options in one UTF-8 request; FlintNDE initializes the singular boundary and transports every finite segment in one process. Production code never evaluates defining integrals or calls `NIntegrate`; these are independent-validation oracles only.

Generic entries never dispatch on graph ids, vertex counts, master counts or paper numerical points. They fail closed in a structured way only when the dlog is not closed, the rank/chart does not pass the normal-crossing certificate, the late-time exponents do not decay, the pullback system is not an exact regular singularity, or the target/anchor lies on a DE letter.

When both endpoints lie on the same contour branch, a public `"massless"` line is internally
derived as `masslessFull` and defaults to `"Quotient"`: the whole edge contributes one shared
two-state slot. Setting `"masslessRepresentation" -> "RedundantH"` at initialization keeps two h
endpoints and four states; `M1/M0`, contacts, recurrence, `MSReduce`, dlog and the H/h transforms
are generated directly from these slots. The choice is fixed in the context. `RedundantH` accepts
only massless `nu=1/2`.

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
vertexValue = MSEvaluatePath[vertexContext, {targetRules}];
```

Here `First[ki]` is the pure vertex phase energy and `First[nui]` is the base power of `(-tau)`; the remaining entries give one by one the momentum and `nu=|nu|` of each h block. One may also give `energy`, `timePower`, `hBlocks` and `exponentialBlocks` explicitly. A pure exponential block is `1x1` and adds no state bits; every h block is `2x2`. The `NuConvention` chosen at initialization stays fixed and cannot be overridden in recurrence, DE, numerics or H/h transforms.

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

The FlintNDE 0.4.0 numerical backend ships as a synchronized copy inside this version directory; its default location is defined in a single relative-path variable:

```wl
MSFlintNDEConfiguration[]
(* relativePath -> Vendor/FlintNDE *)

MSSetFlintNDERelativePath[FileNameJoin[{"new-name", "code", "package"}]]
```

Paths are always relative to the current MadStree version directory; if Vendor is renamed or moved later, only this item changes. `MSNumericalSystem` remains the low-level entry for users who supply their own boundary vectors.

The default runtime root for automatic MMA calls is the single `results_temp/` next to the calling script:

```text
results_temp/
  nde/    # current request input and log
  cache/  # successful JSON cache keyed by request and backend source identity
```

An explicit `MSRuntimeDirectory -> path` denotes the runtime root itself. Absolute paths are used directly and relative paths are resolved against the calling script directory; MadStree does not append another `results_temp`. On Windows, complete cache/input/log paths are checked before directory creation or Python launch. An overlong path returns `RuntimePathTooLong` with its actual length. `RuntimeInputWriteFailed`, `PythonFlintUnavailable`, `FlintNDELaunchFailed`, `FlintNDEOutputMissing`, and `FlintNDEOutputInvalid` retain distinct failure boundaries. A successful-result cache key includes both the request and SHA-256 identities of `Backend/flintnde_transport.py`, the Vendor `pyproject.toml`, and sorted `flintnde/*.py`; an in-place source fix therefore cannot reuse a plan with a different source identity. Apart from caller-side caches, the package source directory never receives run artifacts.
Both the MadStree adapter and the Vendor Wolfram bridge launch Python with argument-list `RunProcess`; shell `Run`, quoting helpers, redirection, and retry fallbacks do not exist. Current numerical gates and the Vendor `25/25` interface regression cover repeated Windows DLL initialization.

Bare user points are returned under the `"saved"` records of `MSEvaluatePath`; `"tmp"` points participate only in transport. Export saved points with

```wl
MSExportEvaluationData[result, MSOutputDirectory -> outputDirectory]
```

to produce CSV/JSON. If any requested format fails, the function returns `EvaluationExportFailed` and never reports the whole export as `"written"`; an overlong target remains a separate `RuntimePathTooLong`. Singular leading data, removed singular points, and transient points are excluded from the ordinary-point export. Durable exports live under the caller-selected `results/`; package source directories receive no runtime products.
The full formulas, the massless `4 -> 2` quotient, contact shifts and the top-to-sub dlog derivation are in [Documentation/tree_formula.pdf](Documentation/tree_formula.pdf).

## Examples

- [01_massless_full_edge.wl](Examples/01_massless_full_edge.wl): massless quotient, master integrals, recurrence, dlog and the automatic boundary/numerical entry (including a user custom finite boundary and batch multi-point evaluation with CSV/JSON export).
- [02_vertex_family_reduction.wl](Examples/02_vertex_family_reduction.wl): single-vertex input, local tensor inverses and finite-combination reduction.
- [03_time_only_cycle_chart.wl](Examples/03_time_only_cycle_chart.wl): time-only cycle, common theta, contact sector and all strict-rank chart certificates.
- [04_three_vertex_tree.wl](Examples/04_three_vertex_tree.wl): three-vertex massless tree with the `+++` vertex structure, followed by a batch multi-point evaluation with CSV/JSON export.
- [05_massive_three_vertex_tree.wl](Examples/05_massive_three_vertex_tree.wl): three-vertex massive tree with the `+++` vertex structure and non-half-integer nu, followed by a batch multi-point evaluation with CSV/JSON export.
- [06_massless_three_vertex_ep_regularization.wl](Examples/06_massless_three_vertex_ep_regularization.wl): a massless three-vertex chain with `a1=a2=a3=1+ep`; the symbolic boundary and DE certify leading power zero before numerical NDE work, after which the program selects production/validation points and extracts the finite part.

After deleting the existing `results/` and `results_temp/` trees, all six examples passed fresh v0.13 runs with `Example PASSED` and exit code `0`. Example 06 passed `15/15` checks with three production points and two independent validation points; the default request of 12 workers was automatically capped at the five actual ep tasks.

## Current boundaries

- Common-theta odd-subset simultaneous contacts, coincident massless/massive quotients, event-reachable sector BFS and pure time-only cycles are supported; this does not mean loop-momentum integration is supported.
- The local two-state and all-sector H/h state vectors are invertible; a basis change of an already integrated `MSIntegral` changes the family base time powers and is currently not disguised as an ordinary state transform.
- Production boundaries never dispatch on graph names or master counts. The single-vertex massiveExternal case follows the same general route (the explicit 2411.03088 Sec.3.3 series is kept only as a test reference baseline); closed tree/time-only contexts build the nested curve, complete dlog pullback residue and ancestor-sector leading system from the sector DAG, component/slot metadata, normalization and strict time rank. When the formula/dlog/chart is not closed, the late-time exponents do not decay, or the pullback system is not an exact regular singularity, the package fails closed and never falls back to finite-point defining integrals.
- FlintNDE transport requires the pulled-back connection to be in exact `Q(i)(s)` or `Q(i)(t)`. The independent `15 x 15`/`25 x 25` boundary and transport of the T1 mixed three-vertex case passed `24/24`; T2 (single-vertex three massive) passed `12/12`; T3 (two-vertex `G++`) passed `18/18` for the paper/package basis map, the five boundary branches and the full target vector. The pure-massless and triangle time-only development checks use the same generic boundary producer.
- FlintNDE 0.4.0 retains exact Lee--Moser, high-pole, and singularity-jump capabilities, and adds node-bucket fast multipoint evaluation plus the public strict user-node route. Uncertified high poles and internal/final points requiring ramification, algebraic extensions, or general Stokes connections continue to fail closed.

The current v0.13 regression includes exact Laurent valuation, the real three-vertex symbolic support certificate, and the Python adapter suite. Examples 01--06 passed `6/6`; after old reports and results were removed, independent validations 01/02/03 passed `18/18`, `26/26`, and `16/16` respectively.
