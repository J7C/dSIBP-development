(* ::Package:: *)
(* 016 成品 example 覆盖清单。键是相对于 examples/ 的文件路径，值是该文件实际演示的
   公开函数。正式检查会同时核对文件中的调用文本和 package 的 DSPublicAPI[]。 *)

<|
 "version" -> "016",
 "coverage" -> <|
   "01_mixed_bubble_workflow.wl" -> {
     "DSInit", "DSSeeds", "DSLinear"
     },
   "02_function_system_hankel.wl" -> {
     "DSInit", "DSInfo", "DSSeeds"
     },
   "03_two_loop_isp.wl" -> {
     "DSInit", "DSSeeds", "DSLinear"
     },
   "04_pure_massive_bubble_closed_loop/main.wl" -> {
     "DSInit", "DSInfo", "DSSeeds", "DSLinear", "DSKiraExport",
     "DSKiraImport", "DSDE", "DSScaleCheck"
     },
   (* 同一成品同时展示 massive direct vertex-pack 与 atomic massless fixed line-pack。 *)
   "05_tree_two_vertex_time_ibp/main.wl" -> {
     "DSMessagesOn", "DSInit", "DSSeeds", "DSLinear", "DSTreeSeeds",
     "repIterative", "DSTreeNaiveIBP", "DSTreeNaiveDE", "DSTreeDLogDE"
     },
   "06_root_kinematic_coordinates/main.wl" -> {
     "DSKinematics", "DSMessagesOn", "DSMessagesOff", "DSMessagesQ", "DSInit",
     "DSInfo", "DSParameterNotation", "DSRedefineParameters", "DSPublicAPI",
     "dtau", "dqq", "dqk", "ds", "rep2innerform", "rep2outform",
     "rep2Integrand", "symmetry", "repSymmetry0"
     }
   |>,
 "runtimeSmokeExamples" -> {
   "01_mixed_bubble_workflow.wl",
   "02_function_system_hankel.wl",
   "03_two_loop_isp.wl",
   "05_tree_two_vertex_time_ibp/main.wl",
   "06_root_kinematic_coordinates/main.wl"
   },
 "externalWorkflowExample" -> "04_pure_massive_bubble_closed_loop/main.wl"
 |>
