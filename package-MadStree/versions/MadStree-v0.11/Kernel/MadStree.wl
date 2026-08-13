(* ::Package:: *)

(***
File: MadStree.wl
Purpose: Declares the public MadStree interface and loads the formula modules in dependency order.
Scope: This package directly assembles the tree formula only; it does not generate general IBP systems or reduction inputs.
***)

(* ::Chapter:: *)
(* Public context and interface declarations *)

BeginPackage["MadStree`"];

MSInitTree::usage = "MSInitTree[spec] initializes a formula-type dS tree topology and returns a MadStree context; masslessFull lines may fix masslessRepresentation->\"Quotient\"|\"RedundantH\".";
MSInitTimeGraph::usage = "MSInitTimeGraph[spec] initializes a pure time-only looped incidence graph without loop momentum/ISP.";
MSInitVertexFamily::usage = "MSInitVertexFamily[spec] initializes a single-vertex function family (independent of graph topology) from ki/nui data or explicit h/exponential blocks.";
MSContextQ::usage = "MSContextQ[context] tests whether an object is a valid MadStree context.";
MSSectors::usage = "MSSectors[context] returns the deterministically ordered list of contact-reachable sectors.";
MSSlotRegistry::usage = "MSSlotRegistry[context,sector] returns the graph-wide two-dimensional slot registry of a sector.";
MSIntegral::usage = "MSIntegral[sectorKey,aShifts,stateBits] is the native time-only integral of MadStree.";
MSMasterIntegrals::usage = "MSMasterIntegrals[context] returns master-integral records in the exact order used by all formula matrices.";
MSFormulaMatrices::usage = "MSFormulaMatrices[context,sector] returns M1, M0, U and the energy letters.";
MSFormulaData::usage = "MSFormulaData[context] aggregates all-sector masters, recurrence metadata and the full dlog DE; TimePowerRules optionally substitutes user-specified a_i.";
MSWriteFormulaArtifacts::usage = "MSWriteFormulaArtifacts[context] writes all-sector masters, recurrence metadata, the dlog DE and a manifest to the calling script directory, and returns the actual output paths.";
MSContactMaps::usage = "MSContactMaps[context,sector] returns the exact parent-to-subsector contact matrices.";
MSRecurrenceStep::usage = "MSRecurrenceStep[integral,component,context] reduces one nonzero time shift toward zero.";
MSReduce::usage = "MSReduce[expr,context,MasterBasis->basis] iteratively reduces finite linear combinations of valid MSIntegral objects in a fixed context, returning the ordered coefficient vector, residual terms and singular layers.";
MSDLogDE::usage = "MSDLogDE[context] returns the ordered master integrals and the block-triangular dlog connection.";
MSHTohMatrix::usage = "MSHTohMatrix[nu,z,context] returns the local 2x2 transformation from H-states to h-states according to the initialized context.";
MShToHMatrix::usage = "MShToHMatrix[nu,z,context] returns the local inverse transformation from h-states to H-states according to the initialized context.";
MSConvertBasis::usage = "MSConvertBasis converts between ordered H/h state vectors locally or for a specified sector; sector conversion always reads the NuConvention of the initialized context, and integral objects continue to fail closed.";
MSToDSIBPJ::usage = "MSToDSIBPJ[integral,context] losslessly converts a MadStree time-only integral to a lazy dSIBP 020 J[sectorKey,timeShifts,stateBits]; further differentiation requires a dSIBP context matching the same sector/state-slot schema.";
MSFromDSIBPJ::usage = "MSFromDSIBPJ[j,context] converts a lazy or active dSIBP time-only J back to an MSIntegral in the same context.";
MSFromDSIBPExpression::usage = "MSFromDSIBPExpression[expr,context] converts a linear dSIBP J expression term by term into a MadStree MSIntegral expression without performing reduction.";
MSNumericalSystem::usage = "MSNumericalSystem[de,spec] validates the numerical substitutions and boundary vector and constructs the numerical DE data.";
MSBoundaryData::usage = "MSBoundaryData[context,targetRules] generates a finite starting vector from the k0->Infinity Frobenius formula in the same order as the dlog masters; fails closed when unsupported.";
MSBoundaryChartCertificate::usage = "MSBoundaryChartCertificate[context,targetRules] constructs the machine certificate for nested blow-up, per-sector theta fixing and normal crossing; RankOrder->All checks all strict charts.";
MSBlowupCoordinate::usage = "MSBlowupCoordinate[i] is the i-th local coordinate of a nested blow-up chart of the automatic boundary.";
MSDampingEnergy::usage = "MSDampingEnergy[v] denotes the internal positive damping energy K_v=i phaseSign_v k0_v of vertex v.";
MSFlintNDEConfiguration::usage = "MSFlintNDEConfiguration[] returns the current version directory, the built-in FlintNDE relative path and availability.";
MSSetFlintNDERelativePath::usage = "MSSetFlintNDERelativePath[path] changes the single version-directory-relative path to the FlintNDE package.";
MSRuntimeDirectory::usage = "MSRuntimeDirectory specifies the root directory for MadStree/FlintNDE runtime products; by default it is the calling script's directory.";
MessageLanguage::usage = "MessageLanguage selects the language of runtime notices and diagnostics; the default is \"EN\" and \"CN\" selects Chinese.";
SingularityMode::usage = "SingularityMode selects path treatment: \"Avoid\" (default) refuses a user segment that crosses a singularity, while \"SingularityJump\" explicitly permits a singularity jump whose multivalued branch must be confirmed by the user.";
FlintNDEPathPlanning::usage = "FlintNDEPathPlanning controls whether FlintNDE automatically plans nodes inside each MadStree affine segment. True (default) enables planning and fast dense multipoint evaluation; False uses the supplied user points strictly as transport nodes.";
NuConvention::usage = "NuConvention selects the prefactor of h=z^(+/-|nu|) H_|nu|; the default is \"Positive\", while \"Negative\" corresponds to 2401.";
BoundaryScale::usage = "BoundaryScale controls the distance of the finite starting point of the infinity Frobenius series from the boundary; it must be greater than 1.";
BoundarySeriesOrder::usage = "BoundarySeriesOrder specifies the total degree truncation of the infinity Frobenius boundary series.";
RankOrder::usage = "RankOrder specifies the vertex id order from largest to smallest damping energy; by default it is determined by the target point.";
PythonExecutable::usage = "PythonExecutable specifies the Python command used to invoke the FlintNDE adapter; Automatic (default) uses the MADSTREE_PYTHON environment variable when set and otherwise the bare \"python\" command from PATH.";
TransportOrder::usage = "TransportOrder specifies the local series order of the primary FlintNDE transport chain.";
ReferenceTransportOrder::usage = "ReferenceTransportOrder specifies the local series order of the reference FlintNDE transport chain.";
TargetRelativeError::usage = "TargetRelativeError specifies the endpoint relative-difference target between the primary and reference FlintNDE chains.";
MasterBasis::usage = "MasterBasis specifies the full ordering of master integrals output by MSReduce; by default the context-fixed order is used.";
TimePowerRules::usage = "TimePowerRules specifies optional substitution rules for the vertex time powers a_i in formula products; by default Automatic keeps them symbolic.";
MSOutputDirectory::usage = "MSOutputDirectory specifies the formula-product directory; relative paths are resolved against the calling script directory, and by default products are written to results/madstree_formula/run-UUID under the calling directory.";
MSExportEvaluationData::usage = "MSExportEvaluationData[evaluation] exports saved ordinary-point records from one MSEvaluatePath result to CSV and JSON. Transient records are not exported. Options: MSOutputDirectory, ExportFormats and SignificantDigits.";
MSEvaluatePath::usage = "MSEvaluatePath[context,pointSequence] identifies maximal consecutive complex-affine one-variable segments, pulls back the dlog DE once per segment, and sends all segments to FlintNDE in one process. FlintNDEPathPlanning->True lets FlintNDE plan nodes and use fast dense multipoint evaluation; False uses every supplied point as a node in order. Bare coordinates are saved and {coordinate,\"tmp\"} is transient.";

MSInitTree::badinput = "Invalid tree topology input: `1`.";
MSInitVertexFamily::badinput = "Invalid single-vertex function family input: `1`.";
MSFormulaMatrices::nosector = "Sector `1` not found.";
MSContactMaps::nosector = "Sector `1` not found.";
MSRecurrenceStep::badint = "Integral does not match the context: `1`.";
MSReduce::cycle = "Iterative reduction detected a repeated state: `1`.";
MSConvertBasis::unsupported = "This basis transformation is not implemented: `1`.";
MSEvaluatePath::backendLaunchFailed = "FlintNDE backend produced no output under Python command `1`. Captured backend output tail: `2`. Install python-flint for that interpreter, or point PythonExecutable or MADSTREE_PYTHON at an interpreter that has python-flint.";
MSEvaluatePath::backendRunFailed = "FlintNDE backend returned a non-success status under Python command `1`. Backend error: `2`.";


(* ::Chapter:: *)
(* Private module loading *)

Begin["`Private`"];

$MadStreeVersion = "0.11";
$MadStreeKernelDirectory = DirectoryName[$InputFileName];

Scan[
  Get[
    FileNameJoin[{$MadStreeKernelDirectory, #}],
    CharacterEncoding -> "UTF-8"
  ] &,
  {
    "Core/Paths.wl",
    "Core/Conventions.wl",
    "Core/Topology.wl",
    "Core/Sectors.wl",
    "Core/VertexFamily.wl",
    "Core/Representation.wl",
    "Formula/TensorAtoms.wl",
    "Formula/Recurrence.wl",
    "DE/DLog.wl",
    "Core/Artifacts.wl",
    "Numerics/Configuration.wl",
    "Numerics/Boundary.wl",
    "Numerics/Numerics.wl",
    "Numerics/FlintNDE.wl",
    "Numerics/PathEvaluation.wl",
    "Numerics/ExportEvaluation.wl"
  }
];


(* ::Chapter:: *)
(* Package scope finalization *)

End[];
EndPackage[];


(* ::Chapter:: *)
(* Citation reminder on load *)

If[! TrueQ[$MadStreeCitationReminderShown],
  $MadStreeCitationReminderShown = True;
  Print["MadStree package loaded. If you use this package in your work, please cite the dSIBP series:"];
  Print["  1. J. Chen and B. Feng, \"Towards Systematic Evaluation of de Sitter Correlators via Generalized Integration-By-Parts Relations\", arXiv:2401.00129, https://arxiv.org/abs/2401.00129"];
  Print["  2. J. Chen, B. Feng and Y.-X. Tao, \"Multivariate hypergeometric solutions of cosmological (dS) correlators by d log-form differential equations\", arXiv:2411.03088, https://arxiv.org/abs/2411.03088"];
  Print["  3. J. Chen, B. Feng, Z. Qin and Y.-X. Tao, \"Loop integrals in de Sitter spacetime: The parity-split IBP system and d log-form differential equations\", arXiv:2604.14549, https://arxiv.org/abs/2604.14549"];
  Print["  The FlintNDE backend is inspired by AMFlow: X. Liu and Y.-Q. Ma, \"AMFlow: A Mathematica package for Feynman integrals computation via auxiliary mass flow\", arXiv:2201.11669, https://arxiv.org/abs/2201.11669."];
];
