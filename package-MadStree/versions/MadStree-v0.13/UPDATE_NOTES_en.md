# MadStree v0.13 Update Notes

## Baseline and breaking interface

v0.13 is based on frozen v0.12. The formula, sector DAG, dlog, FlintNDE transport, and
regulator reconstruction algorithms are retained. The vertex external-leg exponent
parameter is renamed from `energy` to `externalLegEnergy` with no alias, wrapper,
fallback, or compatibility parser.

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

## Numerical and regulator workflows

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

- Core topology/formula checks: `56/56`.
- Massless `++/--` defining-integral dlog checks: `10/10`.
- dSIBP 022 `ds` versus the MadStree 15 by 15 dlog DE for five variables: `9/9`.
- Vertex-family/reduction: `19/19`; planned/direct multipoint: `21/21`; cycle/chart: `22/22`.

The final examples, full regression, independent validation, PDF, UTF-8, and cleanup
status is recorded in the repository-root research progress file.

## Migration

Every vertex input and downstream reader must use `externalLegEnergy`. An old `energy`
field cannot satisfy the new required key. A positive damping point uses
`externalLegEnergy=+I K` for a `+` vertex and `-I K` for a `-` vertex.
