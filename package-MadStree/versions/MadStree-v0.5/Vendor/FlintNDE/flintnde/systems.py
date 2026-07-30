"""一般解析矩阵系统及其普通点 Cauchy--DFT 系数重建。

用户提供 ``matrix_function(z) -> acb_mat`` 和已知奇点位置。系数生成只使用采样圆
内解析性，不要求矩阵先拆成单极点、dlog 或部分分式形式。
"""

from __future__ import annotations

from dataclasses import dataclass
from typing import Callable

from flint import acb, acb_mat, arb


MatrixFunction = Callable[[acb], acb_mat]


@dataclass(frozen=True)
class AnalyticMatrixSystem:
    """保存一般解析矩阵函数、维数和用于收敛圆控制的奇点。"""

    matrix_function: MatrixFunction
    dimension: int
    singularities: tuple[acb, ...] = ()
    name: str = "analytic-matrix-system"

    def evaluate(self, point: acb) -> acb_mat:
        """计算矩阵并验证输出维数。"""

        matrix = self.matrix_function(point)
        if matrix.nrows() != self.dimension or matrix.ncols() != self.dimension:
            raise ValueError(f"{self.name}: matrix dimension mismatch at {point}")
        return matrix

    def nearest_singularity_distance(self, point: acb) -> arb:
        """返回到最近已知奇点的距离；未声明奇点时要求调用者显式给半径。"""

        if not self.singularities:
            raise ValueError(f"{self.name}: no singularities declared for automatic radius control")
        return min((abs(point - singularity) for singularity in self.singularities), key=lambda x: float(x.mid()))

    def taylor_matrix_coefficients(
        self,
        center: acb,
        order: int,
        *,
        radius: acb,
        sample_count: int | None = None,
    ) -> list[acb_mat]:
        """用 Cauchy 圆周样本和离散 Fourier 投影生成 ``A_0..A_(order-1)``。

        `sample_count` 必须大于目标阶数；提高它可以压低高阶解析项的离散混叠。
        收敛误差应由另一组阶数和样本数独立复算，而不是把 Acb 采样半径当成完整
        截断误差证明。
        """

        if order <= 0:
            raise ValueError("Taylor order must be positive")
        count = sample_count or max(32, 2 * order)
        if count <= order:
            raise ValueError("Cauchy sample_count must exceed the Taylor order")
        if abs(radius).contains(0):
            raise ValueError("Cauchy radius must be nonzero")
        roots = [acb(0, 2 * arb.pi() * index / count).exp() for index in range(count)]
        samples = [self.evaluate(center + radius * root) for root in roots]
        coefficients: list[acb_mat] = []
        for degree in range(order):
            total = acb_mat(self.dimension, self.dimension)
            for root, sample in zip(roots, samples):
                total += sample * (root ** (-degree))
            coefficients.append(total / acb(count) / (radius**degree))
        return coefficients
