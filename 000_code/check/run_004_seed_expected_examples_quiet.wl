(* ::Package:: *)
(* Quiet runner: only prints checked keys and pass flags. *)

SetDirectory[FileNameJoin[{DirectoryName[$InputFileName], "..", ".."}]];

Block[{Print = (Null &)},
  Get["000_code/check/004_seed_expected_examples.wl"]
  ];

res = dSSeedExpected`runSeedExpectedStructureCheck[];
checked = Select[Normal[res], AssociationQ[Last[#]] && KeyExistsQ[Last[#], "pass"] &];

Print[checked[[All, 1]]];
Print[Lookup[checked[[All, 2]], "pass"]];

If[And @@ Lookup[checked[[All, 2]], "pass"], Exit[0], Exit[1]];