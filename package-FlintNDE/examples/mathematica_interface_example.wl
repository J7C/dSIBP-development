(* ::Package:: *)
(* FlintNDE Mathematica embedded-interface example (0.2.0).
   Demonstrates loading FlintNDELoader inside a Wolfram session, building a
   partialFraction dlog system, calling FlintNDETransport, reading the final
   result into a Wolfram variable and checking it against the closed form.
   Saving the result uses the built-in output command Put; bridge intermediate
   files stay in results_temp. Run from the package-FlintNDE root:
     wolframscript -file examples/mathematica_interface_example.wl *)

exampleDir = DirectoryName[$InputFileName];
loader = FileNameJoin[{
  exampleDir, "..", "versions", "FlintNDE-0.2.0", "Mathematica", "FlintNDELoader.wl"
}];
Get[loader];


(* ::Chapter:: *)
(*System construction and transport request*)

(* ::Section:: *)
(*Diagonal dlog system A(z)=diag(1/(z-1), -2/(z+3))*)

(* Closed form: y1(z)=1-z, y2(z)=((z+3)/3)^(-2), used as the reference. *)
request = <|
  "system" -> <|
    "type" -> "partialFraction",
    "constant" -> {{0, 0}, {0, 0}},
    "residues" -> {{{1, 0}, {0, 0}}, {{0, 0}, {0, -2}}},
    "poles" -> {1, -3}
  |>,
  "initialVector" -> {1, 1},
  "path" -> {0, 1/2},
  "samplePoints" -> {1/4},
  "primaryOrder" -> 40,
  "referenceOrder" -> 48,
  "targetRelativeError" -> "1e-30"
|>;


(* ::Chapter:: *)
(*Invocation and verification*)

(* ::Section:: *)
(*Transport and read the final result into a Wolfram variable*)

workDir = FileNameJoin[{exampleDir, "results_temp", "mathematica_interface_example"}];
result = FlintNDETransport[request, "WorkDirectory" -> workDir];

If[! AssociationQ[result] || Lookup[result, "status", "error"] =!= "complete",
  Print["mathematica_interface_example: FAILED at bridge invocation"];
  Exit[1]
];

Print["certification mode: ", result["certificationMode"]];
Print["relative difference (primary vs reference): ", result["relativeDifferenceInf"]];
Print["target met: ", result["targetRelativeErrorMet"]];


(* ::Section:: *)
(*Closed-form comparison*)

expectedFinal = N[{1/2, 36/49}, 40];
expectedSample = N[{3/4, 144/169}, 40];
finalCheck = Max[Abs[N[result["primaryFinalVector"], 40] - expectedFinal]];
(* chained single-level Part: multi-level string/integer Part does not
   evaluate under wolframscript, so index step by step *)
sampleValue = result["samplePoints"][[1]]["value"];
sampleCheck = Max[Abs[N[sampleValue, 40] - expectedSample]];
Print["final |delta| vs closed form: ", finalCheck];
Print["sample |delta| vs closed form: ", sampleCheck];

If[! TrueQ[finalCheck < 10^-30] || ! TrueQ[sampleCheck < 10^-30],
  Print["mathematica_interface_example: FAILED numerical check"];
  Exit[1]
];


(* ::Section:: *)
(*User-chosen persistence via built-in output commands*)

resultDir = FileNameJoin[{exampleDir, "results", "mathematica_interface_example"}];
If[! DirectoryQ[resultDir], CreateDirectory[resultDir]];
Put[result, FileNameJoin[{resultDir, "mathematica_interface_result.m"}]];
Print["mathematica_interface_example: PASSED"];
