(* ::Package:: *)
(* FlintNDE Wolfram loader (0.2.0).
   Loads the FlintNDE Python kernel from a Wolfram session and returns the final
   transport result (no intermediate series cache) as a Wolfram association.
   Conventions:
   - Only partialFraction (dlog simple-pole) systems are supported here;
   - exact rationals are passed to the Python bridge as "n/d" strings so JSON
     export cannot degrade them to machine numbers;
   - saving the result to a file is left to the user via Put/Save. *)

BeginPackage["FlintNDELoader`"];


FlintNDETransport::usage =
  "FlintNDETransport[request] sends the request association to the FlintNDE \
Python bridge and returns the final result association. Options: \"Python\", \
\"WorkDirectory\", \"RequestFileName\", \"OutputFileName\".";

FlintNDEBridgeError::usage = "FlintNDEBridgeError: FlintNDE bridge failure.";
FlintNDEBridgeError::error = "FlintNDE bridge failure: `1`";


Begin["`Private`"];


(* ::Chapter:: *)
(*Location setup*)

$FlintNDELoaderDirectory = DirectoryName[$InputFileName];
$FlintNDEVersionDirectory = DirectoryName[$FlintNDELoaderDirectory];
$FlintNDEPythonModule = "flintnde.mathematica_bridge";


(* Automatic resolves to the PATH python; users with a dedicated environment
   pass the full interpreter path via the "Python" option. *)
flintNDEResolvePython[Automatic] := "python";
flintNDEResolvePython[command_String] := command;


(* ::Chapter:: *)
(*Request serialization*)

(* ::Section:: *)
(*JSON-safe encoding of exact numbers*)

(* JSON degrades Rational values to machine approximations; the bridge only
   accepts exact input, so rationals and complex components are converted to
   strings before export. Associations are walked explicitly because a
   ReplaceAll substitution inside an Association is not re-evaluated in
   script mode; rules are applied only to normal subexpressions. *)
flintNDEEncode[expr_Association] := Association[flintNDEEncode /@ Normal[expr]];
flintNDEEncode[rule_Rule] := rule[[1]] -> flintNDEEncode[rule[[2]]];
flintNDEEncode[raw_] := raw /. {
  c_Complex :> <|
    "re" -> ToString[Re[c], InputForm],
    "im" -> ToString[Im[c], InputForm]
  |>,
  r_Rational :> ToString[Numerator[r]] <> "/" <> ToString[Denominator[r]]
};


flintNDEDefaults = <|
  "schema" -> "flintnde_mathematica_request_v1",
  "workingPrecisionDigits" -> 80,
  "outputDigits" -> 40,
  "radiusFraction" -> 0.6,
  "certificationMode" -> "embedded"
|>;


(* ::Chapter:: *)
(*Bridge invocation*)

(* ::Section:: *)
(*FlintNDETransport main entry*)

Options[FlintNDETransport] = {
  "Python" -> Automatic,
  "WorkDirectory" -> Automatic,
  "RequestFileName" -> "flintnde_bridge_request.json",
  "OutputFileName" -> "flintnde_bridge_result.m"
};

FlintNDETransport[request_Association, OptionsPattern[]] := Module[
  {workDir, requestFile, outputFile, merged, process, result},
  workDir = Replace[OptionValue["WorkDirectory"], Automatic :> Directory[]];
  If[! DirectoryQ[workDir], CreateDirectory[workDir]];
  requestFile = FileNameJoin[{workDir, OptionValue["RequestFileName"]}];
  outputFile = FileNameJoin[{workDir, OptionValue["OutputFileName"]}];
  merged = flintNDEEncode[Join[flintNDEDefaults, request]];
  Export[requestFile, merged, "JSON"];
  (* python -m puts the current directory on sys.path, so running from the
     version directory makes the local flintnde package importable without
     touching the caller's environment. *)
  process = RunProcess[
    {flintNDEResolvePython[OptionValue["Python"]], "-m", $FlintNDEPythonModule,
     requestFile, outputFile},
    "StandardOutput", "StandardError",
    ProcessDirectory -> $FlintNDEVersionDirectory
  ];
  If[! FileExistsQ[outputFile],
    Message[FlintNDEBridgeError::error, process["StandardError"]];
    Return[$Failed]
  ];
  Get[outputFile];
  result = Global`FlintNDEBridgeResult;
  If[! AssociationQ[result] || Lookup[result, "status"] =!= "complete",
    Message[FlintNDEBridgeError::error, Lookup[result, "message", "unknown bridge failure"]];
    Return[$Failed]
  ];
  result
];


End[];


EndPackage[];
