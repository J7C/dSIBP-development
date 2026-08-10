"""FlintNDE 的稳定公开接口。

程序包只在本文件汇总面向用户的对象；内部实现可在不改变这些导入名的前提下继续
拆分。所有数值矩阵均使用 python-flint 的 ``acb``/``acb_mat``。
"""

from .core import (
    acb_midpoint_matrix,
    column_vector,
    configure_working_precision,
    relative_difference_inf,
    vector_norm_inf,
)
from .asymptotics import FiveTermTailDiagnostic, five_term_tail_diagnostic
from .boundary import (
    ExponentialBoundary,
    ExponentialBoundaryTerm,
    FrobeniusBoundary,
    FrobeniusBoundaryTerm,
    exponential_boundary,
    frobenius_boundary,
)
from .exact_gaussian import GaussianRational, gaussian_rational
from .frobenius import (
    PowerLogBasis,
    RegularSingularSystem,
    build_exact_frobenius_manifest,
    build_frobenius_manifest,
    build_power_log_basis,
)
from .fuchsian import (
    DiagonalShearingTransformation,
    FuchsianReductionResult,
    MoserBalanceTransformation,
    attempt_fuchsian_reduction,
)
from .local_solutions import (
    LocalReductionError,
    LocalSolutionBasis,
    build_local_solution_basis,
)
from .regularization import (
    LeadingPowerDetectionError,
    SeriesReconstructionResult,
    SeriesValidationError,
    fit_sampled_series,
    reconstruct_series_solution,
)
from .output_layout import OutputLayout, initialize_output_layout
from .numeric_structure import (
    NumericalFrobeniusOptions,
    NumericalRegularSingularSystem,
    build_numerical_frobenius_manifest,
)
from .systems import AnalyticMatrixSystem, PartialFractionSystem
from .singularities import (
    RationalFunction,
    RationalMatrixSystem,
    SingularityInventory,
    SingularityRecord,
    analyze_singularities,
    rational_function,
)
from .routing import (
    AdaptivePath,
    LocalExpansion,
    NamedPoint,
    PathPlan,
    PointClassification,
    build_adaptive_path,
    build_adaptive_path_plan,
    classify_point,
    prepare_local_expansion,
)
from .transport import (
    build_straight_path,
    transport_frobenius_boundaries_refined,
    transport_path,
    transport_path_refined,
)

__all__ = [
    "AdaptivePath",
    "AnalyticMatrixSystem",
    "DiagonalShearingTransformation",
    "ExponentialBoundary",
    "ExponentialBoundaryTerm",
    "FuchsianReductionResult",
    "FrobeniusBoundary",
    "FrobeniusBoundaryTerm",
    "FiveTermTailDiagnostic",
    "GaussianRational",
    "LeadingPowerDetectionError",
    "LocalExpansion",
    "LocalReductionError",
    "LocalSolutionBasis",
    "MoserBalanceTransformation",
    "NamedPoint",
    "NumericalFrobeniusOptions",
    "NumericalRegularSingularSystem",
    "OutputLayout",
    "PartialFractionSystem",
    "PowerLogBasis",
    "PathPlan",
    "PointClassification",
    "RationalFunction",
    "RationalMatrixSystem",
    "RegularSingularSystem",
    "SeriesReconstructionResult",
    "SeriesValidationError",
    "SingularityInventory",
    "SingularityRecord",
    "acb_midpoint_matrix",
    "attempt_fuchsian_reduction",
    "build_exact_frobenius_manifest",
    "build_frobenius_manifest",
    "build_local_solution_basis",
    "build_adaptive_path",
    "build_adaptive_path_plan",
    "build_numerical_frobenius_manifest",
    "build_power_log_basis",
    "build_straight_path",
    "classify_point",
    "column_vector",
    "configure_working_precision",
    "frobenius_boundary",
    "five_term_tail_diagnostic",
    "fit_sampled_series",
    "exponential_boundary",
    "gaussian_rational",
    "analyze_singularities",
    "initialize_output_layout",
    "relative_difference_inf",
    "rational_function",
    "reconstruct_series_solution",
    "transport_path",
    "transport_path_refined",
    "transport_frobenius_boundaries_refined",
    "prepare_local_expansion",
    "vector_norm_inf",
]
