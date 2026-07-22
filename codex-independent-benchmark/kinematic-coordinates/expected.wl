(* ::Package:: *)
(* 015 根号坐标的冻结独立 expected；本文件不加载或调用 dSIBP package。 *)

(* ::Chapter:: *)
(*冻结坐标、Jacobian 与相位符号*)

(* 第一阶段不创建 package 的 sp 符号；只冻结 i<=j 顺序对应的公开 RHS。 *)
expectedOneMomentumLoopRHS = {ss11^2};
expectedTwoMomentumLoopRHS = {ss11^2, ss12^2, ss22^2};
expectedExternalLegRHS = {sE1^2, sE2^2, sE3^2};
expectedDependentMagnitudeIndependentRHS = {ss11^2, sE1^2, sE2^2};
expectedDependentMagnitudeSquaredBindings = {
   4 sE1^2,
   2 ss11^2 + 2 sE1^2 - sE2^2
   };
expectedDependentMagnitudeLineScale = D[Sqrt[4 sE1^2], sE1];
expectedDependentMagnitudePhaseScale = 2 sE1/Sqrt[2 ss11^2 + 2 sE1^2 - sE2^2];
expectedDependentCustomResolvedRHS = {
   vDependent^2,
   2 uDependent^2 + 2 vDependent^2 - wDependent^2
   };

expectedRootJacobians = <|ss11 -> 2 ss11, ss12 -> 2 ss12, ss22 -> 2 ss22|>;
(* x11=u^2, x12=u v, x22=v^2+w^2 时，固定 {v,w} 对 u 求导。 *)
expectedMixedSquaredJacobians = <|uMix -> {2 uMix, vMix, 0}|>;
expectedLegacyJacobian = 1;
expectedPlusPhaseEnergyCoefficient = I;
expectedMomentumGeneratorCount[l_, k_] := l (l + k);

(* 无圈 massive h 线对其独立模长求导时：分母幂贡献 -B shift_b(+1)，
   两端 n=0 的 h 导数各贡献一次 shift_a(+1),n_endpoint->1；正分支相位贡献 +I shift_a(+1)。 *)
expectedNoLoopMassiveDenominatorCoefficient[B_] := -B;
expectedNoLoopMassiveEndpointCoefficient = 1;
