# MadStree v0.3 independent validation report: T6 FlintNDE adapter

> Generated automatically by `run_validation.wls`.

## Status

- status: `passed`
- checks: `16/16`
- version: `MadStree-v0.3`

## Scope, point and normalization

- ordinary family: `Integral[(-tau)^a Exp[I k0 tau], tau=-Infinity..0]`, normalization `1`
- target: `{k0 -> 3, a -> 1/3}`; anchor: `{k0 -> -8*I, a -> 1/3}`
- ordinary save input: `{{0, "save"}, {1/2, "save"}, {1, "save"}}` (no point names)
- physical k0 at saved points: `{-8*I, 3/2 - 4*I, 3}`
- regular-singular probe: `A(t)=2/t`, `{a,b,C}={2,0,{1}}`, weight `1`
- post-singular ordinary segment: `{k0 -> -8*I, a -> 1/3}` to `{k0 -> 3, a -> 1/3}`
- unsupported probe: `A(t)=2/t^2`

## Actual paths, orders and precision

- affine physical path: `{k0 -> -8*I + (3 + 8*I)*msPathParameter11}`
- FlintNDE adaptive path: `{<|"real" -> "0", "imag" -> "0", "realRadius" -> "0", "imagRadius" -> "0"|>, <|"real" -> "0.42134812990607004059175217009959660904627187233234", "imag" -> "0", "realRadius" -> "[1.8448426192772072402794090887952234517882636706161e-60 +/- 4.35e-110]", "imagRadius" -> "0"|>, <|"real" -> "0.50000000000000000000000000000000000000000000000000", "imag" -> "0", "realRadius" -> "0", "imagRadius" -> "0"|>, <|"real" -> "0.72500000000000000555111512312578270211815834045410", "imag" -> "0", "realRadius" -> "[2.4637815291353542222623665322545272477700503879623e-60 +/- 4.26e-110]", "imagRadius" -> "0"|>, <|"real" -> "0.88793756945866074010984038051586066253818581276126", "imag" -> "0", "realRadius" -> "[5.2727047184112191346227314235840768138662490288448e-60 +/- 3.35e-110]", "imagRadius" -> "0"|>, <|"real" -> "1.0000000000000000000000000000000000000000000000000", "imag" -> "0", "realRadius" -> "0", "imagRadius" -> "0"|>}`
- ordinary and singular orders: `{72, 96}`
- working precision: `50`; target relative error: `1e-22`
- boundary series order: `24`

## Timing

- boundary generation: `0.020925 s`
- ordinary save-point transport: `1.218607 s`
- regular-singular transport: `1.648919 s`
- unsupported-pole preflight: `0.536388 s`
- total wall time: `5.012889 s`

## Checks

- `contextAndNormalization`: PASS
- `boundaryGeneratedWithoutDirectFallback`: PASS
- `invalidNamedSaveRejectedBeforePython`: PASS
- `ordinaryTransportComputed`: PASS
- `ordinaryThreeSavedPoints`: PASS
- `ordinarySavedPointFilesExist`: PASS
- `ordinaryAnalyticAgreement`: PASS
- `ordinaryFinalMatchesReturn`: PASS
- `ordinaryRefinement`: PASS
- `regularSingularTransportComputed`: PASS
- `regularSingularClassification`: PASS
- `regularSingularOrdinaryContinuation`: PASS
- `savedFrobeniusBoundary`: PASS
- `unsupportedPoleFailsClosed`: PASS
- `callerDirectoryOwnsSaveOutputs`: PASS
- `packageDirectoryUnchangedByRuntime`: PASS

## Numerical and file evidence

- ordinary saved-point relative residuals: `{0``39.74671908809498, 1.0021408592247500710878653`6.174018080970582*^-33, 1.0889534659376275567066499`6.20430891547883*^-33}`
- ordinary primary/reference relative difference: `"[5.6371828678510944006191606881585354306946566817480e-25 +/- 2.89e-75]"`
- singular-to-ordinary final/expected: `{-1.8489633982683592129156060660959094373945548139862`49.26692831403239 - 3.2024985471360072711345743662654461194061252946367`49.50548894139223*I, -1.8489633982683592129156060660958981211891603025540107641794`44.61722431466213 - 3.202498547136007271134574366265447590129086448602619266716`44.74076541524448*I}`
- ordinary aggregate: `"F:\\Agent-projects-nut\\dSibp_package\\package-MadStree\\independent-validation\\MadStree-v0.3-validation-06-flintnde-adapter-capability\\results\\flintnde_save_points\\run-9f6613c8-a581-46ad-bdc5-d84050cdaff2\\madstree_flintnde_save_points.json"`
- singular aggregate: `"F:\\Agent-projects-nut\\dSibp_package\\package-MadStree\\independent-validation\\MadStree-v0.3-validation-06-flintnde-adapter-capability\\results\\flintnde_save_points\\run-295c31e7-5386-4f44-baa8-9ea5085eb796\\madstree_flintnde_save_points.json"`
- unsupported backend error: `MadStree requires a regular_singular start and ordinary target; got non_fuchsian_input_basis, ordinary`
- machine-readable validation summary: `results/summary.wl`
- adapter JSON and Python cache: `results_temp/` in this validation directory.
