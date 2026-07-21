(* ::Package:: *)
(* Independent symbolic audit of the bare-H and normalized-h derivative bases. *)

ClearAll[x, nu, t00, t01, t10, t11, f00, f01, f10, f11];

aH = {
   {0, 1},
   {nu^2/x^2 - 1, -1/x}
   };

ah = {
   {0, 1},
   {-1, -(2 nu + 1)/x}
   };

tHtoh = x^-nu {
    {1, 0},
    {-nu/x, 1}
    };

transformedConnection = FullSimplify[
   PowerExpand[D[tHtoh, x] . Inverse[tHtoh] + tHtoh . aH . Inverse[tHtoh]],
   Assumptions -> x > 0
   ];

tGeneral = {{t00, t01}, {t10, t11}};
fundamentalMatrix = {{f00, f01}, {f10, f11}};

checks = <|
   "bareHHasQuadraticPole" -> (Coefficient[aH[[2, 1]], x, -2] === nu^2),
   "HtohConnection" -> FullSimplify[transformedConnection == ah, Assumptions -> x > 0],
   "HtohDeterminant" -> FullSimplify[Det[tHtoh] == x^(-2 nu), Assumptions -> x > 0],
   "bareHAbelTrace" -> (Tr[aH] === -1/x),
   "hAbelTrace" -> (Tr[ah] === -(2 nu + 1)/x),
   "generalWronskianTransform" -> Expand[Det[tGeneral . fundamentalMatrix] - Det[tGeneral] Det[fundamentalMatrix]] === 0
   |>;

KeyValueMap[Print[#1, ": ", #2] &, checks];
Print["h/H basis-transform checks: ", Count[Values[checks], True], "/", Length[checks]];

If[!And @@ Values[checks], Exit[1]];
