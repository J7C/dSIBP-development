# MadStree v0.15 Update Notes

## Singular user points

`SingularityMode -> "Automatic"` follows explicitly supplied finite singular user points.
An exact intermediate singularity is removed from the ordinary-node chain; one FlintNDE local
basis owns user points on both sides inside its convergence disk, divergent components are
reported as textual `Infinity`, and transport resumes from an outgoing ordinary point. A terminal
singular target receives a hidden in-disk match point when required. The lower-order primary chain
supplies the result; the higher-order reference chain checks classifications and finite-value
accuracy only. Non-collinear singular turns, consecutive singular points, and intermediate
singularities with planning disabled remain fail closed.

Candidate singularities are determined only from the exact rational matrix or letters of the
complete pulled-back DE, never from variable names, zero coordinate values, or topology labels. An
independent FlintNDE regression places the target at the nonzero complex point $2+i$, with another
finite singularity at $5+i$, and obtains removable and true-pole components through the same entry.
Example 05 separately evaluates four `k2=0` points; none makes a complete dlog letter vanish, so all
are ordinary saved points and the classification table is empty.

## Baseline and breaking interface

v0.15 is based on frozen v0.13. Its topology, normalized-master definitions, sector DAG,
dlog, FlintNDE transport, and regulator reconstruction are retained. This release
destructively replaces the numerical-point schema: fixed parameters are supplied once through
`ParameterRules`, while running coordinates are supplied only through the `pointSequence` header
and value rows. The former per-point rule-list schema has no parser, alias, wrapper, fallback, or
compatibility test.

The only vertex form is

```wl
<|
  "id" -> 1,
  "vertexType" -> "+",
  "externalLegEnergy" -> E1,
  "timePower" -> a1
|>
```

`vertexType="+"` gives `Exp[-I externalLegEnergy tau]`; `"-"` gives
`Exp[+I externalLegEnergy tau]`. The external exponent sign (`vertexSign=-1/+1`) and
the SK contour sign (`contourSign=+1/-1`) are stored separately. Propagator classes,
endpoint signs, and contact data are derived only from endpoint vertex types. Lines have
no public IDs and are numbered internally in input order.

The explicit `MSInitVertexFamily` model also accepts only `externalLegEnergy`; context
metadata uses `userExternalLegEnergy`, `baseExternalLegEnergy`, and
`effectiveExternalLegEnergy`.

## Master-integral definitions

- `MSIntegral[s,n,a]` remains the normalized master $J_s(n;a)$ used by recurrence, DEs,
  and numerical transport.
- The inert `MSBareIntegral[s,n,a]` and `MSIntegralDefinition[integral,context]` use exactly
  the same sector, shift, and two-state indices to return the exact $J_s=\mathcal N_s I_s$.
- Ordered `MSMasterIntegrals` records now include `bareIntegral` and `definition`; the
  existing `integral`, normalization, order, and digest are unchanged. Unit normalization
  is displayed as $J_s=I_s$.
- The manual now denotes the number of two-state factors by $n_s^{\mathrm{slot}}$ and uses
  $\mathcal N_s$ only for normalization, including the corrected boundary-weight notation.

## Numerical and regulator workflows

- `pointSequence` is a coordinate table: the first row is the ordered coordinate-symbol header
  and later rows are equal-width values. A single point has one value row; a transient row is
  `{{values...},"tmp"}`.
- `ParameterRules` is disjoint from the header and must complete every symbol needed by the
  analytic DE and boundary. Missing or nonnumeric parameters fail before Python/FlintNDE starts.
- `MSReconstructEpSeries` uses the same contract. The regulator may occur on the right-hand side
  of `ParameterRules`, but path-coordinate values may not depend on it.
- `MSDLogDE` and `MSWriteFormulaArtifacts` always retain and write the full analytic DE. Every public
  numerical entry writes or reuses the formal artifacts before Python/FlintNDE starts and returns the
  actual paths; a partial write prevents NDE. Numerical work derives only a function-local
  parameterized copy and never overwrites `dlog_de.wl`.
- `MSEvaluatePath` still splits only maximal continuous complex-affine one-variable
  segments. FlintNDE owns node planning and fast multipoint evaluation.
- `FlintNDEPathPlanning -> True|False` selects backend planning or strict user nodes.
- `TransportOrder` is the primary production chain; `ReferenceTransportOrder` is used
  only for error checking and never replaces user output.
- `MSReconstructEpSeries` certifies the leading Laurent power from the boundary and DE,
  fits two extra powers by default, and reuses solved points when increasing fit order.
- `EpSamplePoints` is an ordered redundant candidate pool. Pool exhaustion returns the
  current coefficients with `computed_with_warning/candidate_pool_exhausted` and never
  generates an out-of-pool point.
- `EpSampleAngleRange` selects at most three uniformly spaced interior rays of an open
  angle interval; magnitudes remain precision driven.
- `ParallelTaskCount` defaults to 12 independent fixed-regulator worker processes.

## Citation reminder

After all 16 modules and representative definitions load, each Wolfram kernel prints one
citation reminder. Notebooks use real `Hyperlink` objects; headless kernels print full
URLs. The list contains only `2401.00129`, `2411.03088`, and
`MadStree package paper, arXiv identifier pending`.

The Python file protocol stores the same list in `metadata.citationNotice` without writing
it to stdout. Direct no-argument CLI use prints the text notice. The Vendor FlintNDE import
notice is explicitly suppressed inside protocol processes.

## Validation status

- Core topology/formula: `58/58`; formula artifacts: `24/24`.
- Point sequence/planning: `27/27`; 900-point complex-plane grouping: `8/8`;
  vertex-family NDE: `13/13`; runtime/export: `10/10`.
- Massless, massive Full, massive vertex, and mixed three-vertex checks: `10/10`, `6/6`,
  `8/8`, and `8/8`.
- All seven examples exited `0` from empty output directories; Example 06 passed `16/16`.
- The v0.15 independent-validation task book uses the new interface, but independent validation
  was not run in this task. Old-version reports and results were removed.

The final PDF, UTF-8, and cleanup status is recorded in the repository-root research progress file.

## Migration

Every numerical call must use the header/value `pointSequence` and one-time `ParameterRules`.
The old per-point rule-list schema is not read. The `externalLegEnergy` and `vertexType` topology
contract completed in v0.13 is unchanged.
