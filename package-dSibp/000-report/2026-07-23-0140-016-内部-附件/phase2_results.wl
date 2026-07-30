<|"summary" -> <|"version" -> "016", "groups" ->
    <|"graphRouting" -> <|"passed" -> 19, "total" -> 19,
       "nonzeroDifferenceCount" -> 0, "firstFailure" -> None|>,
     "capability" -> <|"passed" -> 15, "total" -> 15,
       "nonzeroDifferenceCount" -> 0, "firstFailure" -> None|>,
     "cycleFixed" -> <|"passed" -> 16, "total" -> 16,
       "nonzeroDifferenceCount" -> 0, "firstFailure" -> None|>,
     "pureTime" -> <|"passed" -> 28, "total" -> 28,
       "nonzeroDifferenceCount" -> 0, "firstFailure" -> None|>,
     "parameters" -> <|"passed" -> 18, "total" -> 18,
       "nonzeroDifferenceCount" -> 0, "firstFailure" -> None|>,
     "coverage" -> <|"passed" -> 79, "total" -> 79,
       "nonzeroDifferenceCount" -> 0, "firstFailure" -> None|>|>,
   "passed" -> 175, "total" -> 175, "nonzeroDifferenceCount" -> 0,
   "firstFailure" -> None|>, "checks" ->
  {<|"group" -> "graphRouting", "name" -> "package version",
    "passed" -> True, "actual" -> "016", "expected" -> "016",
    "difference" -> 0|>, <|"group" -> "graphRouting",
    "name" -> "main initialization", "passed" -> True,
    "actual" -> "initialized", "expected" -> "initialized",
    "difference" -> 0|>, <|"group" -> "graphRouting",
    "name" -> "main graph status", "passed" -> True, "actual" -> "valid",
    "expected" -> "valid", "difference" -> 0|>, <|"group" -> "graphRouting",
    "name" -> "main counts", "passed" -> True,
    "actual" -> <|"internalLineCount" -> 3, "vertexCount" -> 3,
      "connectedComponentCount" -> 1, "graphLoopCount" -> 1|>,
    "expected" -> <|"internalLineCount" -> 3, "vertexCount" -> 3,
      "connectedComponentCount" -> 1, "graphLoopCount" -> 1|>,
    "difference" -> 0|>, <|"group" -> "graphRouting",
    "name" -> "main cycle lines", "passed" -> True, "actual" -> {1, 2},
    "expected" -> {1, 2}, "difference" -> 0|>, <|"group" -> "graphRouting",
    "name" -> "main bridge", "passed" -> True, "actual" -> {3},
    "expected" -> {3}, "difference" -> 0|>, <|"group" -> "graphRouting",
    "name" -> "routing status", "passed" -> True, "actual" -> "valid",
    "expected" -> "valid", "difference" -> 0|>, <|"group" -> "graphRouting",
    "name" -> "required loop external", "passed" -> True, "actual" -> {spur},
    "expected" -> {spur}, "difference" -> 0|>, <|"group" -> "graphRouting",
    "name" -> "exact declaration status", "passed" -> True,
    "actual" -> "exact", "expected" -> "exact", "difference" -> 0|>,
   <|"group" -> "graphRouting", "name" -> "exact no-loop magnitude count",
    "passed" -> True, "actual" -> 3, "expected" -> 3, "difference" -> 0|>,
   <|"group" -> "graphRouting", "name" -> "no missing directions",
    "passed" -> True, "actual" -> {}, "expected" -> {}, "difference" -> 0|>,
   <|"group" -> "graphRouting", "name" -> "no missing magnitudes",
    "passed" -> True, "actual" -> {}, "expected" -> {}, "difference" -> 0|>,
   <|"group" -> "graphRouting", "name" -> "self-loop count",
    "passed" -> True, "actual" -> 1, "expected" -> 1, "difference" -> 0|>,
   <|"group" -> "graphRouting", "name" -> "self-loop classification",
    "passed" -> True, "actual" -> {1}, "expected" -> {1},
    "difference" -> 0|>, <|"group" -> "graphRouting",
    "name" -> "self-loop is not bridge", "passed" -> True, "actual" -> {},
    "expected" -> {}, "difference" -> 0|>, <|"group" -> "graphRouting",
    "name" -> "three-parallel loop count", "passed" -> True, "actual" -> 2,
    "expected" -> 2, "difference" -> 0|>, <|"group" -> "graphRouting",
    "name" -> "three-parallel cycle lines", "passed" -> True,
    "actual" -> {1, 2, 3}, "expected" -> {1, 2, 3}, "difference" -> 0|>,
   <|"group" -> "graphRouting", "name" -> "three-parallel bridge",
    "passed" -> True, "actual" -> {4}, "expected" -> {4},
    "difference" -> 0|>, <|"group" -> "graphRouting",
    "name" -> "triple-contact sector reachable", "passed" -> True,
    "actual" -> True, "expected" -> True, "difference" -> 0|>,
   <|"group" -> "capability", "name" -> "under loop status",
    "passed" -> True, "actual" -> "undercomplete",
    "expected" -> "undercomplete", "difference" -> 0|>,
   <|"group" -> "capability", "name" -> "under loop missing",
    "passed" -> True, "actual" -> {spur}, "expected" -> {spur},
    "difference" -> 0|>, <|"group" -> "capability",
    "name" -> "under magnitude status", "passed" -> True,
    "actual" -> "undercomplete", "expected" -> "undercomplete",
    "difference" -> 0|>, <|"group" -> "capability",
    "name" -> "under magnitude missing", "passed" -> True, "actual" -> True,
    "expected" -> True, "difference" -> 0|>, <|"group" -> "capability",
    "name" -> "under magnitude rejected", "passed" -> True,
    "actual" -> "failed", "expected" -> "failed", "difference" -> 0|>,
   <|"group" -> "capability", "name" -> "over loop continues",
    "passed" -> True, "actual" -> "initialized", "expected" -> "initialized",
    "difference" -> 0|>, <|"group" -> "capability",
    "name" -> "over loop derivative disabled", "passed" -> True,
    "actual" -> False, "expected" -> False, "difference" -> 0|>,
   <|"group" -> "capability", "name" -> "over loop inverse disabled",
    "passed" -> True, "actual" -> False, "expected" -> False,
    "difference" -> 0|>, <|"group" -> "capability",
    "name" -> "over loop symbolic seed available", "passed" -> True,
    "actual" -> True, "expected" -> True, "difference" -> 0|>,
   <|"group" -> "capability", "name" -> "over loop ds blocked",
    "passed" -> True, "actual" -> $Failed, "expected" -> $Failed,
    "difference" -> 0|>, <|"group" -> "capability",
    "name" -> "over loop inverse blocked", "passed" -> True,
    "actual" -> $Failed, "expected" -> $Failed, "difference" -> 0|>,
   <|"group" -> "capability", "name" ->
     "under loop rejected and all downstream blocked", "passed" -> True,
    "actual" -> True, "expected" -> True, "difference" -> 0|>,
   <|"group" -> "capability", "name" -> "loop count mismatch rejected",
    "passed" -> True, "actual" -> True, "expected" -> True,
    "difference" -> 0|>, <|"group" -> "capability",
    "name" -> "bridge loop flow rejected", "passed" -> True,
    "actual" -> True, "expected" -> True, "difference" -> 0|>,
   <|"group" -> "capability", "name" -> "illegal cycle support rejected",
    "passed" -> True, "actual" -> True, "expected" -> True,
    "difference" -> 0|>, <|"group" -> "cycleFixed",
    "name" -> "cycle massive pack 1", "passed" -> True,
    "actual" -> {b[1], n[1, 1], n[1, 2]}, "expected" ->
     {b[1], n[1, 1], n[1, 2]}, "difference" -> 0|>,
   <|"group" -> "cycleFixed", "name" -> "cycle massive pack 2",
    "passed" -> True, "actual" -> {b[2], n[2, 1], n[2, 2]},
    "expected" -> {b[2], n[2, 1], n[2, 2]}, "difference" -> 0|>,
   <|"group" -> "cycleFixed", "name" -> "fixed massive pack",
    "passed" -> True, "actual" -> {n[3, 1], n[3, 2]},
    "expected" -> {n[3, 1], n[3, 2]}, "difference" -> 0|>,
   <|"group" -> "cycleFixed", "name" -> "fixed line power mode",
    "passed" -> True, "actual" -> "fixedCoefficient",
    "expected" -> "fixedCoefficient", "difference" -> 0|>,
   <|"group" -> "cycleFixed", "name" -> "fixed line has no b",
    "passed" -> True, "actual" -> Missing["FixedLinePower"],
    "expected" -> Missing["FixedLinePower"], "difference" -> 0|>,
   <|"group" -> "cycleFixed", "name" -> "fixed radial {0, 0}",
    "passed" -> True, "actual" ->
     -((beta3*J[{a1, a2, a3}, {{b1, 0, 0}, {b2, 0, 0}, {0, 0}}, {}])/sE3) +
      J[{a1, a2, 1 + a3}, {{b1, 0, 0}, {b2, 0, 0}, {0, 1}}, {}] +
      J[{a1, 1 + a2, a3}, {{b1, 0, 0}, {b2, 0, 0}, {1, 0}}, {}],
    "expected" -> -((beta3*J[{a1, a2, a3}, {{b1, 0, 0}, {b2, 0, 0}, {0, 0}},
          {}])/sE3) + J[{a1, a2, 1 + a3}, {{b1, 0, 0}, {b2, 0, 0}, {0, 1}},
       {}] + J[{a1, 1 + a2, a3}, {{b1, 0, 0}, {b2, 0, 0}, {1, 0}}, {}],
    "difference" -> 0|>, <|"group" -> "cycleFixed",
    "name" -> "fixed radial {1, 0}", "passed" -> True,
    "actual" -> -(J[{a1, a2, a3}, {{b1, 0, 0}, {b2, 0, 0}, {1, 0}}, {}]/
        sE3) - (beta3*J[{a1, a2, a3}, {{b1, 0, 0}, {b2, 0, 0}, {1, 0}}, {}])/
       sE3 - (2*nu3*J[{a1, a2, a3}, {{b1, 0, 0}, {b2, 0, 0}, {1, 0}}, {}])/
       sE3 + J[{a1, a2, 1 + a3}, {{b1, 0, 0}, {b2, 0, 0}, {1, 1}}, {}] -
      J[{a1, 1 + a2, a3}, {{b1, 0, 0}, {b2, 0, 0}, {0, 0}}, {}],
    "expected" -> ((-1 - beta3 - 2*nu3)*J[{a1, a2, a3},
         {{b1, 0, 0}, {b2, 0, 0}, {1, 0}}, {}])/sE3 +
      J[{a1, a2, 1 + a3}, {{b1, 0, 0}, {b2, 0, 0}, {1, 1}}, {}] -
      J[{a1, 1 + a2, a3}, {{b1, 0, 0}, {b2, 0, 0}, {0, 0}}, {}],
    "difference" -> 0|>, <|"group" -> "cycleFixed",
    "name" -> "fixed radial {0, 1}", "passed" -> True,
    "actual" -> -(J[{a1, a2, a3}, {{b1, 0, 0}, {b2, 0, 0}, {0, 1}}, {}]/
        sE3) - (beta3*J[{a1, a2, a3}, {{b1, 0, 0}, {b2, 0, 0}, {0, 1}}, {}])/
       sE3 - (2*nu3*J[{a1, a2, a3}, {{b1, 0, 0}, {b2, 0, 0}, {0, 1}}, {}])/
       sE3 - J[{a1, a2, 1 + a3}, {{b1, 0, 0}, {b2, 0, 0}, {0, 0}}, {}] +
      J[{a1, 1 + a2, a3}, {{b1, 0, 0}, {b2, 0, 0}, {1, 1}}, {}],
    "expected" -> ((-1 - beta3 - 2*nu3)*J[{a1, a2, a3},
         {{b1, 0, 0}, {b2, 0, 0}, {0, 1}}, {}])/sE3 -
      J[{a1, a2, 1 + a3}, {{b1, 0, 0}, {b2, 0, 0}, {0, 0}}, {}] +
      J[{a1, 1 + a2, a3}, {{b1, 0, 0}, {b2, 0, 0}, {1, 1}}, {}],
    "difference" -> 0|>, <|"group" -> "cycleFixed",
    "name" -> "fixed radial {1, 1}", "passed" -> True,
    "actual" -> (-2*J[{a1, a2, a3}, {{b1, 0, 0}, {b2, 0, 0}, {1, 1}}, {}])/
       sE3 - (beta3*J[{a1, a2, a3}, {{b1, 0, 0}, {b2, 0, 0}, {1, 1}}, {}])/
       sE3 - (4*nu3*J[{a1, a2, a3}, {{b1, 0, 0}, {b2, 0, 0}, {1, 1}}, {}])/
       sE3 - J[{a1, a2, 1 + a3}, {{b1, 0, 0}, {b2, 0, 0}, {1, 0}}, {}] -
      J[{a1, 1 + a2, a3}, {{b1, 0, 0}, {b2, 0, 0}, {0, 1}}, {}],
    "expected" -> ((-beta3 - 2*(1 + 2*nu3))*J[{a1, a2, a3},
         {{b1, 0, 0}, {b2, 0, 0}, {1, 1}}, {}])/sE3 -
      J[{a1, a2, 1 + a3}, {{b1, 0, 0}, {b2, 0, 0}, {1, 0}}, {}] -
      J[{a1, 1 + a2, a3}, {{b1, 0, 0}, {b2, 0, 0}, {0, 1}}, {}],
    "difference" -> 0|>, <|"group" -> "cycleFixed",
    "name" -> "fixed endpoint dtau n0", "passed" -> True,
    "actual" -> -(a3*J[{a1, a2, -1 + a3}, {{b1, 0, 0}, {b2, 0, 0}, {0, 0}},
         {}]) - alpha3*J[{a1, a2, -1 + a3}, {{b1, 0, 0}, {b2, 0, 0}, {0, 0}},
        {}] - I*E3*J[{a1, a2, a3}, {{b1, 0, 0}, {b2, 0, 0}, {0, 0}}, {}] -
      sE3*J[{a1, a2, a3}, {{b1, 0, 0}, {b2, 0, 0}, {0, 1}}, {}],
    "expected" -> (-a3 - alpha3)*J[{a1, a2, -1 + a3},
        {{b1, 0, 0}, {b2, 0, 0}, {0, 0}}, {}] -
      I*E3*J[{a1, a2, a3}, {{b1, 0, 0}, {b2, 0, 0}, {0, 0}}, {}] -
      sE3*J[{a1, a2, a3}, {{b1, 0, 0}, {b2, 0, 0}, {0, 1}}, {}],
    "difference" -> 0|>, <|"group" -> "cycleFixed",
    "name" -> "fixed endpoint dtau n1 regular", "passed" -> True,
    "actual" -> J[{a1, a2, -1 + a3}, {{b1, 0, 0}, {b2, 0, 0}, {0, 1}}, {}] -
      a3*J[{a1, a2, -1 + a3}, {{b1, 0, 0}, {b2, 0, 0}, {0, 1}}, {}] -
      alpha3*J[{a1, a2, -1 + a3}, {{b1, 0, 0}, {b2, 0, 0}, {0, 1}}, {}] +
      2*nu3*J[{a1, a2, -1 + a3}, {{b1, 0, 0}, {b2, 0, 0}, {0, 1}}, {}] +
      sE3*J[{a1, a2, a3}, {{b1, 0, 0}, {b2, 0, 0}, {0, 0}}, {}] -
      I*E3*J[{a1, a2, a3}, {{b1, 0, 0}, {b2, 0, 0}, {0, 1}}, {}],
    "expected" -> (1 - a3 - alpha3 + 2*nu3)*J[{a1, a2, -1 + a3},
        {{b1, 0, 0}, {b2, 0, 0}, {0, 1}}, {}] +
      sE3*J[{a1, a2, a3}, {{b1, 0, 0}, {b2, 0, 0}, {0, 0}}, {}] -
      I*E3*J[{a1, a2, a3}, {{b1, 0, 0}, {b2, 0, 0}, {0, 1}}, {}],
    "difference" -> 0|>, <|"group" -> "cycleFixed",
    "name" -> "momentum seeds keep fixed pack length", "passed" -> True,
    "actual" -> True, "expected" -> True, "difference" -> 0|>,
   <|"group" -> "cycleFixed", "name" ->
     "momentum seeds do not shift fixed b", "passed" -> True,
    "actual" -> True, "expected" -> True, "difference" -> 0|>,
   <|"group" -> "cycleFixed", "name" -> "triple shrunk cycle packs",
    "passed" -> True, "actual" -> {{bS[1]}, {bS[2]}, {bS[3]}},
    "expected" -> {{bS[1]}, {bS[2]}, {bS[3]}}, "difference" -> 0|>,
   <|"group" -> "cycleFixed", "name" -> "triple fixed bridge mode inherited",
    "passed" -> True, "actual" -> "fixedCoefficient",
    "expected" -> "fixedCoefficient", "difference" -> 0|>,
   <|"group" -> "cycleFixed", "name" -> "triple root L inherited",
    "passed" -> True, "actual" -> 2, "expected" -> 2, "difference" -> 0|>,
   <|"group" -> "pureTime", "name" -> "two timeOnly mode", "passed" -> True,
    "actual" -> "timeOnly", "expected" -> "timeOnly", "difference" -> 0|>,
   <|"group" -> "pureTime", "name" -> "two no momentum generators",
    "passed" -> True, "actual" -> 0, "expected" -> 0, "difference" -> 0|>,
   <|"group" -> "pureTime", "name" -> "two direct route", "passed" -> True,
    "actual" -> "directPureTime", "expected" -> "directPureTime",
    "difference" -> 0|>, <|"group" -> "pureTime",
    "name" -> "two direct seed n0", "passed" -> True,
    "actual" -> (ta + xa1)*J[{{-1 + ta, 0}, {tb, 0}}] -
      I*X1*J[{{ta, 0}, {tb, 0}}] - k12*J[{{ta, 1}, {tb, 0}}],
    "expected" -> (ta + xa1)*J[{{-1 + ta, 0}, {tb, 0}}] -
      I*X1*J[{{ta, 0}, {tb, 0}}] - k12*J[{{ta, 1}, {tb, 0}}],
    "difference" -> 0|>, <|"group" -> "pureTime",
    "name" -> "two direct seed n1 regular", "passed" -> True,
    "actual" -> (-1 - 2*nu12 + ta + xa1)*J[{{-1 + ta, 1}, {tb, 0}}] +
      k12*J[{{ta, 0}, {tb, 0}}] - I*X1*J[{{ta, 1}, {tb, 0}}],
    "expected" -> (-1 - 2*nu12 + ta + xa1)*J[{{-1 + ta, 1}, {tb, 0}}] +
      k12*J[{{ta, 0}, {tb, 0}}] - I*X1*J[{{ta, 1}, {tb, 0}}],
    "difference" -> 0|>, <|"group" -> "pureTime",
    "name" -> "two dlog generated", "passed" -> True,
    "actual" -> "generated", "expected" -> "generated", "difference" -> 0|>,
   <|"group" -> "pureTime", "name" -> "two naive solved", "passed" -> True,
    "actual" -> "solved", "expected" -> "solved", "difference" -> 0|>,
   <|"group" -> "pureTime", "name" -> "two equation unknown count",
    "passed" -> True, "actual" -> 9, "expected" -> 9, "difference" -> 0|>,
   <|"group" -> "pureTime", "name" -> "two solve residuals",
    "passed" -> True, "actual" -> True, "expected" -> True,
    "difference" -> 0|>, <|"group" -> "pureTime",
    "name" -> "two naive dlog X1", "passed" -> True,
    "actual" -> {{-(X1/(-k12^2 + X1^2)) - (X1*xa1)/(-k12^2 + X1^2), 0,
       ((2*I)*k12*nu12)/(-k12^2 + X1^2) - (I*k12*xa1)/(-k12^2 + X1^2), 0,
       (I*k12)/(-k12^2 + X1^2)}, {0, X1/(k12^2 - X1^2) +
        (X1*xa1)/(k12^2 - X1^2), 0, ((-2*I)*k12*nu12)/(k12^2 - X1^2) +
        (I*k12*xa1)/(k12^2 - X1^2), X1/(k12^2 - X1^2)},
      {((-I)*k12)/(k12^2 - X1^2) - (I*k12*xa1)/(k12^2 - X1^2), 0,
       (-2*nu12*X1)/(k12^2 - X1^2) + (X1*xa1)/(k12^2 - X1^2), 0,
       -(X1/(k12^2 - X1^2))}, {0, (I*k12)/(-k12^2 + X1^2) +
        (I*k12*xa1)/(-k12^2 + X1^2), 0, (2*nu12*X1)/(-k12^2 + X1^2) -
        (X1*xa1)/(-k12^2 + X1^2), (I*k12)/(-k12^2 + X1^2)},
      {0, 0, 0, 0, -(X1 + X2)^(-1) + (2*nu12)/(X1 + X2) - xa1/(X1 + X2) -
        xa2/(X1 + X2)}}, "expected" ->
     {{1/(2*(-k12 - X1)) + 1/(2*(k12 - X1)) + xa1/(2*(-k12 - X1)) +
        xa1/(2*(k12 - X1)), 0, (I*nu12)/(-k12 - X1) - (I*nu12)/(k12 - X1) -
        ((I/2)*xa1)/(-k12 - X1) + ((I/2)*xa1)/(k12 - X1), 0,
       (I/2)/(-k12 - X1) - (I/2)/(k12 - X1)},
      {0, 1/(2*(-k12 - X1)) + 1/(2*(k12 - X1)) + xa1/(2*(-k12 - X1)) +
        xa1/(2*(k12 - X1)), 0, (I*nu12)/(-k12 - X1) - (I*nu12)/(k12 - X1) -
        ((I/2)*xa1)/(-k12 - X1) + ((I/2)*xa1)/(k12 - X1),
       1/(2*(-k12 - X1)) + 1/(2*(k12 - X1))},
      {(I/2)/(-k12 - X1) - (I/2)/(k12 - X1) + ((I/2)*xa1)/(-k12 - X1) -
        ((I/2)*xa1)/(k12 - X1), 0, -(nu12/(-k12 - X1)) - nu12/(k12 - X1) +
        xa1/(2*(-k12 - X1)) + xa1/(2*(k12 - X1)), 0, -1/2*1/(-k12 - X1) -
        1/(2*(k12 - X1))}, {0, (I/2)/(-k12 - X1) - (I/2)/(k12 - X1) +
        ((I/2)*xa1)/(-k12 - X1) - ((I/2)*xa1)/(k12 - X1), 0,
       -(nu12/(-k12 - X1)) - nu12/(k12 - X1) + xa1/(2*(-k12 - X1)) +
        xa1/(2*(k12 - X1)), (I/2)/(-k12 - X1) - (I/2)/(k12 - X1)},
      {0, 0, 0, 0, (-X1 - X2)^(-1) - (2*nu12)/(-X1 - X2) + xa1/(-X1 - X2) +
        xa2/(-X1 - X2)}}, "difference" -> 0|>, <|"group" -> "pureTime",
    "name" -> "two naive dlog X2", "passed" -> True,
    "actual" -> {{-(X2/(-k12^2 + X2^2)) - (X2*xa2)/(-k12^2 + X2^2),
       ((2*I)*k12*nu12)/(-k12^2 + X2^2) - (I*k12*xa2)/(-k12^2 + X2^2), 0, 0,
       (I*k12)/(-k12^2 + X2^2)}, {((-I)*k12)/(k12^2 - X2^2) -
        (I*k12*xa2)/(k12^2 - X2^2), (-2*nu12*X2)/(k12^2 - X2^2) +
        (X2*xa2)/(k12^2 - X2^2), 0, 0, -(X2/(k12^2 - X2^2))},
      {0, 0, X2/(k12^2 - X2^2) + (X2*xa2)/(k12^2 - X2^2),
       ((-2*I)*k12*nu12)/(k12^2 - X2^2) + (I*k12*xa2)/(k12^2 - X2^2),
       X2/(k12^2 - X2^2)}, {0, 0, (I*k12)/(-k12^2 + X2^2) +
        (I*k12*xa2)/(-k12^2 + X2^2), (2*nu12*X2)/(-k12^2 + X2^2) -
        (X2*xa2)/(-k12^2 + X2^2), (I*k12)/(-k12^2 + X2^2)},
      {0, 0, 0, 0, -(X1 + X2)^(-1) + (2*nu12)/(X1 + X2) - xa1/(X1 + X2) -
        xa2/(X1 + X2)}}, "expected" ->
     {{1/(2*(-k12 - X2)) + 1/(2*(k12 - X2)) + xa2/(2*(-k12 - X2)) +
        xa2/(2*(k12 - X2)), (I*nu12)/(-k12 - X2) - (I*nu12)/(k12 - X2) -
        ((I/2)*xa2)/(-k12 - X2) + ((I/2)*xa2)/(k12 - X2), 0, 0,
       (I/2)/(-k12 - X2) - (I/2)/(k12 - X2)},
      {(I/2)/(-k12 - X2) - (I/2)/(k12 - X2) + ((I/2)*xa2)/(-k12 - X2) -
        ((I/2)*xa2)/(k12 - X2), -(nu12/(-k12 - X2)) - nu12/(k12 - X2) +
        xa2/(2*(-k12 - X2)) + xa2/(2*(k12 - X2)), 0, 0,
       -1/2*1/(-k12 - X2) - 1/(2*(k12 - X2))},
      {0, 0, 1/(2*(-k12 - X2)) + 1/(2*(k12 - X2)) + xa2/(2*(-k12 - X2)) +
        xa2/(2*(k12 - X2)), (I*nu12)/(-k12 - X2) - (I*nu12)/(k12 - X2) -
        ((I/2)*xa2)/(-k12 - X2) + ((I/2)*xa2)/(k12 - X2),
       1/(2*(-k12 - X2)) + 1/(2*(k12 - X2))},
      {0, 0, (I/2)/(-k12 - X2) - (I/2)/(k12 - X2) + ((I/2)*xa2)/(-k12 - X2) -
        ((I/2)*xa2)/(k12 - X2), -(nu12/(-k12 - X2)) - nu12/(k12 - X2) +
        xa2/(2*(-k12 - X2)) + xa2/(2*(k12 - X2)), (I/2)/(-k12 - X2) -
        (I/2)/(k12 - X2)}, {0, 0, 0, 0, (-X1 - X2)^(-1) -
        (2*nu12)/(-X1 - X2) + xa1/(-X1 - X2) + xa2/(-X1 - X2)}},
    "difference" -> 0|>, <|"group" -> "pureTime",
    "name" -> "two naive dlog k12", "passed" -> True,
    "actual" -> {{-(k12/(k12^2 - X1^2)) - k12/(k12^2 - X2^2) -
        (k12*xa1)/(k12^2 - X1^2) - (k12*xa2)/(k12^2 - X2^2),
       ((2*I)*nu12*X2)/(k12^2 - X2^2) - (I*X2*xa2)/(k12^2 - X2^2),
       ((2*I)*nu12*X1)/(k12^2 - X1^2) - (I*X1*xa1)/(k12^2 - X1^2), 0,
       (I*X1)/(k12^2 - X1^2) + (I*X2)/(k12^2 - X2^2)},
      {((-I)*X2)/(-k12^2 + X2^2) - (I*X2*xa2)/(-k12^2 + X2^2),
       -k12^(-1) - (2*nu12)/k12 + k12/(-k12^2 + X1^2) -
        (2*k12*nu12)/(-k12^2 + X2^2) + (k12*xa1)/(-k12^2 + X1^2) +
        (k12*xa2)/(-k12^2 + X2^2), 0, ((-2*I)*nu12*X1)/(-k12^2 + X1^2) +
        (I*X1*xa1)/(-k12^2 + X1^2), k12/(-k12^2 + X1^2) -
        k12/(-k12^2 + X2^2)}, {((-I)*X1)/(-k12^2 + X1^2) -
        (I*X1*xa1)/(-k12^2 + X1^2), 0, -k12^(-1) - (2*nu12)/k12 -
        (2*k12*nu12)/(-k12^2 + X1^2) + k12/(-k12^2 + X2^2) +
        (k12*xa1)/(-k12^2 + X1^2) + (k12*xa2)/(-k12^2 + X2^2),
       ((-2*I)*nu12*X2)/(-k12^2 + X2^2) + (I*X2*xa2)/(-k12^2 + X2^2),
       -(k12/(-k12^2 + X1^2)) + k12/(-k12^2 + X2^2)},
      {0, (I*X1)/(k12^2 - X1^2) + (I*X1*xa1)/(k12^2 - X1^2),
       (I*X2)/(k12^2 - X2^2) + (I*X2*xa2)/(k12^2 - X2^2),
       -2/k12 - (4*nu12)/k12 + (2*k12*nu12)/(k12^2 - X1^2) +
        (2*k12*nu12)/(k12^2 - X2^2) - (k12*xa1)/(k12^2 - X1^2) -
        (k12*xa2)/(k12^2 - X2^2), (I*X1)/(k12^2 - X1^2) +
        (I*X2)/(k12^2 - X2^2)}, {0, 0, 0, 0, -k12^(-1) - (2*nu12)/k12}},
    "expected" -> {{1/(2*(-k12 - X1)) - 1/(2*(k12 - X1)) +
        1/(2*(-k12 - X2)) - 1/(2*(k12 - X2)) + xa1/(2*(-k12 - X1)) -
        xa1/(2*(k12 - X1)) + xa2/(2*(-k12 - X2)) - xa2/(2*(k12 - X2)),
       (I*nu12)/(-k12 - X2) + (I*nu12)/(k12 - X2) - ((I/2)*xa2)/(-k12 - X2) -
        ((I/2)*xa2)/(k12 - X2), (I*nu12)/(-k12 - X1) + (I*nu12)/(k12 - X1) -
        ((I/2)*xa1)/(-k12 - X1) - ((I/2)*xa1)/(k12 - X1), 0,
       (I/2)/(-k12 - X1) + (I/2)/(k12 - X1) + (I/2)/(-k12 - X2) +
        (I/2)/(k12 - X2)}, {(I/2)/(-k12 - X2) + (I/2)/(k12 - X2) +
        ((I/2)*xa2)/(-k12 - X2) + ((I/2)*xa2)/(k12 - X2),
       -k12^(-1) - (2*nu12)/k12 + 1/(2*(-k12 - X1)) - 1/(2*(k12 - X1)) -
        nu12/(-k12 - X2) + nu12/(k12 - X2) + xa1/(2*(-k12 - X1)) -
        xa1/(2*(k12 - X1)) + xa2/(2*(-k12 - X2)) - xa2/(2*(k12 - X2)), 0,
       (I*nu12)/(-k12 - X1) + (I*nu12)/(k12 - X1) - ((I/2)*xa1)/(-k12 - X1) -
        ((I/2)*xa1)/(k12 - X1), 1/(2*(-k12 - X1)) - 1/(2*(k12 - X1)) -
        1/(2*(-k12 - X2)) + 1/(2*(k12 - X2))},
      {(I/2)/(-k12 - X1) + (I/2)/(k12 - X1) + ((I/2)*xa1)/(-k12 - X1) +
        ((I/2)*xa1)/(k12 - X1), 0, -k12^(-1) - (2*nu12)/k12 -
        nu12/(-k12 - X1) + nu12/(k12 - X1) + 1/(2*(-k12 - X2)) -
        1/(2*(k12 - X2)) + xa1/(2*(-k12 - X1)) - xa1/(2*(k12 - X1)) +
        xa2/(2*(-k12 - X2)) - xa2/(2*(k12 - X2)), (I*nu12)/(-k12 - X2) +
        (I*nu12)/(k12 - X2) - ((I/2)*xa2)/(-k12 - X2) -
        ((I/2)*xa2)/(k12 - X2), -1/2*1/(-k12 - X1) + 1/(2*(k12 - X1)) +
        1/(2*(-k12 - X2)) - 1/(2*(k12 - X2))},
      {0, (I/2)/(-k12 - X1) + (I/2)/(k12 - X1) + ((I/2)*xa1)/(-k12 - X1) +
        ((I/2)*xa1)/(k12 - X1), (I/2)/(-k12 - X2) + (I/2)/(k12 - X2) +
        ((I/2)*xa2)/(-k12 - X2) + ((I/2)*xa2)/(k12 - X2),
       -2/k12 - (4*nu12)/k12 - nu12/(-k12 - X1) + nu12/(k12 - X1) -
        nu12/(-k12 - X2) + nu12/(k12 - X2) + xa1/(2*(-k12 - X1)) -
        xa1/(2*(k12 - X1)) + xa2/(2*(-k12 - X2)) - xa2/(2*(k12 - X2)),
       (I/2)/(-k12 - X1) + (I/2)/(k12 - X1) + (I/2)/(-k12 - X2) +
        (I/2)/(k12 - X2)}, {0, 0, 0, 0, (-1 - 2*nu12)/k12}},
    "difference" -> 0|>, <|"group" -> "pureTime",
    "name" -> "two iteration vs direct seed symbolic", "passed" -> True,
    "actual" -> (I*X1*J[{{0, 0}, {0, 0}}])/xa1 + (k12*J[{{0, 1}, {0, 0}}])/
       xa1, "expected" -> (I*X1*J[{{0, 0}, {0, 0}}] +
       k12*J[{{0, 1}, {0, 0}}])/xa1, "difference" -> 0|>,
   <|"group" -> "pureTime", "name" -> "two deterministic rational iteration",
    "passed" -> True, "actual" -> 119/64 + (77*I)/50,
    "expected" -> 119/64 + (77*I)/50, "difference" -> 0|>,
   <|"group" -> "pureTime", "name" -> "three initialization",
    "passed" -> True, "actual" -> "initialized", "expected" -> "initialized",
    "difference" -> 0|>, <|"group" -> "pureTime",
    "name" -> "three direct route", "passed" -> True,
    "actual" -> "directPureTime", "expected" -> "directPureTime",
    "difference" -> 0|>, <|"group" -> "pureTime",
    "name" -> "three two-leg vertex seed regular", "passed" -> True,
    "actual" -> (-1 + cb - 2*muB + ya2)*J[{{ca, 0}, {-1 + cb, 0, 1},
         {cc, 1}}] + kB*J[{{ca, 0}, {cb, 0, 0}, {cc, 1}}] -
      I*Y2*J[{{ca, 0}, {cb, 0, 1}, {cc, 1}}] -
      kA*J[{{ca, 0}, {cb, 1, 1}, {cc, 1}}], "expected" ->
     (-1 + cb - 2*muB + ya2)*J[{{ca, 0}, {-1 + cb, 0, 1}, {cc, 1}}] +
      kB*J[{{ca, 0}, {cb, 0, 0}, {cc, 1}}] -
      I*Y2*J[{{ca, 0}, {cb, 0, 1}, {cc, 1}}] -
      kA*J[{{ca, 0}, {cb, 1, 1}, {cc, 1}}], "difference" -> 0|>,
   <|"group" -> "pureTime", "name" -> "three dlog generated",
    "passed" -> True, "actual" -> "generated", "expected" -> "generated",
    "difference" -> 0|>, <|"group" -> "pureTime",
    "name" -> "three naive solved", "passed" -> True, "actual" -> "solved",
    "expected" -> "solved", "difference" -> 0|>,
   <|"group" -> "pureTime", "name" -> "three equation unknown count",
    "passed" -> True, "actual" -> 56, "expected" -> 56, "difference" -> 0|>,
   <|"group" -> "pureTime", "name" -> "three solve residuals",
    "passed" -> True, "actual" -> True, "expected" -> True,
    "difference" -> 0|>, <|"group" -> "pureTime",
    "name" -> "three naive dlog Y1", "passed" -> True,
    "actual" -> {{-(Y1/(-kA^2 + Y1^2)) - (Y1*ya1)/(-kA^2 + Y1^2), 0, 0, 0, 0,
       0, 0, 0, ((2*I)*kA*muA)/(-kA^2 + Y1^2) - (I*kA*ya1)/(-kA^2 + Y1^2), 0,
       0, 0, 0, 0, 0, 0, (I*kA)/(-kA^2 + Y1^2), 0, 0, 0},
      {0, -(Y1/(-kA^2 + Y1^2)) - (Y1*ya1)/(-kA^2 + Y1^2), 0, 0, 0, 0, 0, 0,
       0, ((2*I)*kA*muA)/(-kA^2 + Y1^2) - (I*kA*ya1)/(-kA^2 + Y1^2), 0, 0, 0,
       0, 0, 0, 0, (I*kA)/(-kA^2 + Y1^2), 0, 0},
      {0, 0, -(Y1/(-kA^2 + Y1^2)) - (Y1*ya1)/(-kA^2 + Y1^2), 0, 0, 0, 0, 0,
       0, 0, ((2*I)*kA*muA)/(-kA^2 + Y1^2) - (I*kA*ya1)/(-kA^2 + Y1^2), 0, 0,
       0, 0, 0, 0, 0, (I*kA)/(-kA^2 + Y1^2), 0},
      {0, 0, 0, -(Y1/(-kA^2 + Y1^2)) - (Y1*ya1)/(-kA^2 + Y1^2), 0, 0, 0, 0,
       0, 0, 0, ((2*I)*kA*muA)/(-kA^2 + Y1^2) - (I*kA*ya1)/(-kA^2 + Y1^2), 0,
       0, 0, 0, 0, 0, 0, (I*kA)/(-kA^2 + Y1^2)},
      {0, 0, 0, 0, Y1/(kA^2 - Y1^2) + (Y1*ya1)/(kA^2 - Y1^2), 0, 0, 0, 0, 0,
       0, 0, ((-2*I)*kA*muA)/(kA^2 - Y1^2) + (I*kA*ya1)/(kA^2 - Y1^2), 0, 0,
       0, Y1/(kA^2 - Y1^2), 0, 0, 0}, {0, 0, 0, 0, 0,
       Y1/(kA^2 - Y1^2) + (Y1*ya1)/(kA^2 - Y1^2), 0, 0, 0, 0, 0, 0, 0,
       ((-2*I)*kA*muA)/(kA^2 - Y1^2) + (I*kA*ya1)/(kA^2 - Y1^2), 0, 0, 0,
       Y1/(kA^2 - Y1^2), 0, 0}, {0, 0, 0, 0, 0, 0, Y1/(kA^2 - Y1^2) +
        (Y1*ya1)/(kA^2 - Y1^2), 0, 0, 0, 0, 0, 0, 0,
       ((-2*I)*kA*muA)/(kA^2 - Y1^2) + (I*kA*ya1)/(kA^2 - Y1^2), 0, 0, 0,
       Y1/(kA^2 - Y1^2), 0}, {0, 0, 0, 0, 0, 0, 0, Y1/(kA^2 - Y1^2) +
        (Y1*ya1)/(kA^2 - Y1^2), 0, 0, 0, 0, 0, 0, 0,
       ((-2*I)*kA*muA)/(kA^2 - Y1^2) + (I*kA*ya1)/(kA^2 - Y1^2), 0, 0, 0,
       Y1/(kA^2 - Y1^2)}, {((-I)*kA)/(kA^2 - Y1^2) -
        (I*kA*ya1)/(kA^2 - Y1^2), 0, 0, 0, 0, 0, 0, 0,
       (-2*muA*Y1)/(kA^2 - Y1^2) + (Y1*ya1)/(kA^2 - Y1^2), 0, 0, 0, 0, 0, 0,
       0, -(Y1/(kA^2 - Y1^2)), 0, 0, 0}, {0, ((-I)*kA)/(kA^2 - Y1^2) -
        (I*kA*ya1)/(kA^2 - Y1^2), 0, 0, 0, 0, 0, 0, 0,
       (-2*muA*Y1)/(kA^2 - Y1^2) + (Y1*ya1)/(kA^2 - Y1^2), 0, 0, 0, 0, 0, 0,
       0, -(Y1/(kA^2 - Y1^2)), 0, 0}, {0, 0, ((-I)*kA)/(kA^2 - Y1^2) -
        (I*kA*ya1)/(kA^2 - Y1^2), 0, 0, 0, 0, 0, 0, 0,
       (-2*muA*Y1)/(kA^2 - Y1^2) + (Y1*ya1)/(kA^2 - Y1^2), 0, 0, 0, 0, 0, 0,
       0, -(Y1/(kA^2 - Y1^2)), 0}, {0, 0, 0, ((-I)*kA)/(kA^2 - Y1^2) -
        (I*kA*ya1)/(kA^2 - Y1^2), 0, 0, 0, 0, 0, 0, 0,
       (-2*muA*Y1)/(kA^2 - Y1^2) + (Y1*ya1)/(kA^2 - Y1^2), 0, 0, 0, 0, 0, 0,
       0, -(Y1/(kA^2 - Y1^2))}, {0, 0, 0, 0, (I*kA)/(-kA^2 + Y1^2) +
        (I*kA*ya1)/(-kA^2 + Y1^2), 0, 0, 0, 0, 0, 0, 0,
       (2*muA*Y1)/(-kA^2 + Y1^2) - (Y1*ya1)/(-kA^2 + Y1^2), 0, 0, 0,
       (I*kA)/(-kA^2 + Y1^2), 0, 0, 0}, {0, 0, 0, 0, 0,
       (I*kA)/(-kA^2 + Y1^2) + (I*kA*ya1)/(-kA^2 + Y1^2), 0, 0, 0, 0, 0, 0,
       0, (2*muA*Y1)/(-kA^2 + Y1^2) - (Y1*ya1)/(-kA^2 + Y1^2), 0, 0, 0,
       (I*kA)/(-kA^2 + Y1^2), 0, 0}, {0, 0, 0, 0, 0, 0,
       (I*kA)/(-kA^2 + Y1^2) + (I*kA*ya1)/(-kA^2 + Y1^2), 0, 0, 0, 0, 0, 0,
       0, (2*muA*Y1)/(-kA^2 + Y1^2) - (Y1*ya1)/(-kA^2 + Y1^2), 0, 0, 0,
       (I*kA)/(-kA^2 + Y1^2), 0}, {0, 0, 0, 0, 0, 0, 0,
       (I*kA)/(-kA^2 + Y1^2) + (I*kA*ya1)/(-kA^2 + Y1^2), 0, 0, 0, 0, 0, 0,
       0, (2*muA*Y1)/(-kA^2 + Y1^2) - (Y1*ya1)/(-kA^2 + Y1^2), 0, 0, 0,
       (I*kA)/(-kA^2 + Y1^2)}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
       0, Y1/(kB^2 - Y1^2 - 2*Y1*Y2 - Y2^2) - (2*muA*Y1)/
         (kB^2 - Y1^2 - 2*Y1*Y2 - Y2^2) + Y2/(kB^2 - Y1^2 - 2*Y1*Y2 - Y2^2) -
        (2*muA*Y2)/(kB^2 - Y1^2 - 2*Y1*Y2 - Y2^2) +
        (Y1*ya1)/(kB^2 - Y1^2 - 2*Y1*Y2 - Y2^2) +
        (Y2*ya1)/(kB^2 - Y1^2 - 2*Y1*Y2 - Y2^2) +
        (Y1*ya2)/(kB^2 - Y1^2 - 2*Y1*Y2 - Y2^2) +
        (Y2*ya2)/(kB^2 - Y1^2 - 2*Y1*Y2 - Y2^2), 0,
       ((-2*I)*kB*muA)/(kB^2 - Y1^2 - 2*Y1*Y2 - Y2^2) -
        ((2*I)*kB*muB)/(kB^2 - Y1^2 - 2*Y1*Y2 - Y2^2) +
        (I*kB*ya1)/(kB^2 - Y1^2 - 2*Y1*Y2 - Y2^2) +
        (I*kB*ya2)/(kB^2 - Y1^2 - 2*Y1*Y2 - Y2^2), 0},
      {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
       Y1/(kB^2 - Y1^2 - 2*Y1*Y2 - Y2^2) - (2*muA*Y1)/(kB^2 - Y1^2 -
          2*Y1*Y2 - Y2^2) + Y2/(kB^2 - Y1^2 - 2*Y1*Y2 - Y2^2) -
        (2*muA*Y2)/(kB^2 - Y1^2 - 2*Y1*Y2 - Y2^2) +
        (Y1*ya1)/(kB^2 - Y1^2 - 2*Y1*Y2 - Y2^2) +
        (Y2*ya1)/(kB^2 - Y1^2 - 2*Y1*Y2 - Y2^2) +
        (Y1*ya2)/(kB^2 - Y1^2 - 2*Y1*Y2 - Y2^2) +
        (Y2*ya2)/(kB^2 - Y1^2 - 2*Y1*Y2 - Y2^2), 0,
       ((-2*I)*kB*muA)/(kB^2 - Y1^2 - 2*Y1*Y2 - Y2^2) -
        ((2*I)*kB*muB)/(kB^2 - Y1^2 - 2*Y1*Y2 - Y2^2) +
        (I*kB*ya1)/(kB^2 - Y1^2 - 2*Y1*Y2 - Y2^2) +
        (I*kB*ya2)/(kB^2 - Y1^2 - 2*Y1*Y2 - Y2^2)}, {0, 0, 0, 0, 0, 0, 0, 0,
       0, 0, 0, 0, 0, 0, 0, 0, (I*kB)/(-kB^2 - ((-I)*Y1 - I*Y2)^2) -
        ((2*I)*kB*muA)/(-kB^2 - ((-I)*Y1 - I*Y2)^2) +
        (I*kB*ya1)/(-kB^2 - ((-I)*Y1 - I*Y2)^2) +
        (I*kB*ya2)/(-kB^2 - ((-I)*Y1 - I*Y2)^2), 0,
       (2*muA*Y1)/(-kB^2 - ((-I)*Y1 - I*Y2)^2) + (2*muB*Y1)/
         (-kB^2 - ((-I)*Y1 - I*Y2)^2) + (2*muA*Y2)/
         (-kB^2 - ((-I)*Y1 - I*Y2)^2) + (2*muB*Y2)/
         (-kB^2 - ((-I)*Y1 - I*Y2)^2) - (Y1*ya1)/
         (-kB^2 - ((-I)*Y1 - I*Y2)^2) - (Y2*ya1)/
         (-kB^2 - ((-I)*Y1 - I*Y2)^2) - (Y1*ya2)/
         (-kB^2 - ((-I)*Y1 - I*Y2)^2) - (Y2*ya2)/
         (-kB^2 - ((-I)*Y1 - I*Y2)^2), 0}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
       0, 0, 0, 0, 0, 0, (I*kB)/(-kB^2 - ((-I)*Y1 - I*Y2)^2) -
        ((2*I)*kB*muA)/(-kB^2 - ((-I)*Y1 - I*Y2)^2) +
        (I*kB*ya1)/(-kB^2 - ((-I)*Y1 - I*Y2)^2) +
        (I*kB*ya2)/(-kB^2 - ((-I)*Y1 - I*Y2)^2), 0,
       (2*muA*Y1)/(-kB^2 - ((-I)*Y1 - I*Y2)^2) + (2*muB*Y1)/
         (-kB^2 - ((-I)*Y1 - I*Y2)^2) + (2*muA*Y2)/
         (-kB^2 - ((-I)*Y1 - I*Y2)^2) + (2*muB*Y2)/
         (-kB^2 - ((-I)*Y1 - I*Y2)^2) - (Y1*ya1)/
         (-kB^2 - ((-I)*Y1 - I*Y2)^2) - (Y2*ya1)/
         (-kB^2 - ((-I)*Y1 - I*Y2)^2) - (Y1*ya2)/
         (-kB^2 - ((-I)*Y1 - I*Y2)^2) - (Y2*ya2)/
         (-kB^2 - ((-I)*Y1 - I*Y2)^2)}}, "expected" ->
     {{1/(2*(-kA - Y1)) + 1/(2*(kA - Y1)) + ya1/(2*(-kA - Y1)) +
        ya1/(2*(kA - Y1)), 0, 0, 0, 0, 0, 0, 0, (I*muA)/(-kA - Y1) -
        (I*muA)/(kA - Y1) - ((I/2)*ya1)/(-kA - Y1) + ((I/2)*ya1)/(kA - Y1),
       0, 0, 0, 0, 0, 0, 0, (I/2)/(-kA - Y1) - (I/2)/(kA - Y1), 0, 0, 0},
      {0, 1/(2*(-kA - Y1)) + 1/(2*(kA - Y1)) + ya1/(2*(-kA - Y1)) +
        ya1/(2*(kA - Y1)), 0, 0, 0, 0, 0, 0, 0, (I*muA)/(-kA - Y1) -
        (I*muA)/(kA - Y1) - ((I/2)*ya1)/(-kA - Y1) + ((I/2)*ya1)/(kA - Y1),
       0, 0, 0, 0, 0, 0, 0, (I/2)/(-kA - Y1) - (I/2)/(kA - Y1), 0, 0},
      {0, 0, 1/(2*(-kA - Y1)) + 1/(2*(kA - Y1)) + ya1/(2*(-kA - Y1)) +
        ya1/(2*(kA - Y1)), 0, 0, 0, 0, 0, 0, 0, (I*muA)/(-kA - Y1) -
        (I*muA)/(kA - Y1) - ((I/2)*ya1)/(-kA - Y1) + ((I/2)*ya1)/(kA - Y1),
       0, 0, 0, 0, 0, 0, 0, (I/2)/(-kA - Y1) - (I/2)/(kA - Y1), 0},
      {0, 0, 0, 1/(2*(-kA - Y1)) + 1/(2*(kA - Y1)) + ya1/(2*(-kA - Y1)) +
        ya1/(2*(kA - Y1)), 0, 0, 0, 0, 0, 0, 0, (I*muA)/(-kA - Y1) -
        (I*muA)/(kA - Y1) - ((I/2)*ya1)/(-kA - Y1) + ((I/2)*ya1)/(kA - Y1),
       0, 0, 0, 0, 0, 0, 0, (I/2)/(-kA - Y1) - (I/2)/(kA - Y1)},
      {0, 0, 0, 0, 1/(2*(-kA - Y1)) + 1/(2*(kA - Y1)) + ya1/(2*(-kA - Y1)) +
        ya1/(2*(kA - Y1)), 0, 0, 0, 0, 0, 0, 0, (I*muA)/(-kA - Y1) -
        (I*muA)/(kA - Y1) - ((I/2)*ya1)/(-kA - Y1) + ((I/2)*ya1)/(kA - Y1),
       0, 0, 0, 1/(2*(-kA - Y1)) + 1/(2*(kA - Y1)), 0, 0, 0},
      {0, 0, 0, 0, 0, 1/(2*(-kA - Y1)) + 1/(2*(kA - Y1)) +
        ya1/(2*(-kA - Y1)) + ya1/(2*(kA - Y1)), 0, 0, 0, 0, 0, 0, 0,
       (I*muA)/(-kA - Y1) - (I*muA)/(kA - Y1) - ((I/2)*ya1)/(-kA - Y1) +
        ((I/2)*ya1)/(kA - Y1), 0, 0, 0, 1/(2*(-kA - Y1)) + 1/(2*(kA - Y1)),
       0, 0}, {0, 0, 0, 0, 0, 0, 1/(2*(-kA - Y1)) + 1/(2*(kA - Y1)) +
        ya1/(2*(-kA - Y1)) + ya1/(2*(kA - Y1)), 0, 0, 0, 0, 0, 0, 0,
       (I*muA)/(-kA - Y1) - (I*muA)/(kA - Y1) - ((I/2)*ya1)/(-kA - Y1) +
        ((I/2)*ya1)/(kA - Y1), 0, 0, 0, 1/(2*(-kA - Y1)) + 1/(2*(kA - Y1)),
       0}, {0, 0, 0, 0, 0, 0, 0, 1/(2*(-kA - Y1)) + 1/(2*(kA - Y1)) +
        ya1/(2*(-kA - Y1)) + ya1/(2*(kA - Y1)), 0, 0, 0, 0, 0, 0, 0,
       (I*muA)/(-kA - Y1) - (I*muA)/(kA - Y1) - ((I/2)*ya1)/(-kA - Y1) +
        ((I/2)*ya1)/(kA - Y1), 0, 0, 0, 1/(2*(-kA - Y1)) + 1/(2*(kA - Y1))},
      {(I/2)/(-kA - Y1) - (I/2)/(kA - Y1) + ((I/2)*ya1)/(-kA - Y1) -
        ((I/2)*ya1)/(kA - Y1), 0, 0, 0, 0, 0, 0, 0, -(muA/(-kA - Y1)) -
        muA/(kA - Y1) + ya1/(2*(-kA - Y1)) + ya1/(2*(kA - Y1)), 0, 0, 0, 0,
       0, 0, 0, -1/2*1/(-kA - Y1) - 1/(2*(kA - Y1)), 0, 0, 0},
      {0, (I/2)/(-kA - Y1) - (I/2)/(kA - Y1) + ((I/2)*ya1)/(-kA - Y1) -
        ((I/2)*ya1)/(kA - Y1), 0, 0, 0, 0, 0, 0, 0, -(muA/(-kA - Y1)) -
        muA/(kA - Y1) + ya1/(2*(-kA - Y1)) + ya1/(2*(kA - Y1)), 0, 0, 0, 0,
       0, 0, 0, -1/2*1/(-kA - Y1) - 1/(2*(kA - Y1)), 0, 0},
      {0, 0, (I/2)/(-kA - Y1) - (I/2)/(kA - Y1) + ((I/2)*ya1)/(-kA - Y1) -
        ((I/2)*ya1)/(kA - Y1), 0, 0, 0, 0, 0, 0, 0, -(muA/(-kA - Y1)) -
        muA/(kA - Y1) + ya1/(2*(-kA - Y1)) + ya1/(2*(kA - Y1)), 0, 0, 0, 0,
       0, 0, 0, -1/2*1/(-kA - Y1) - 1/(2*(kA - Y1)), 0},
      {0, 0, 0, (I/2)/(-kA - Y1) - (I/2)/(kA - Y1) + ((I/2)*ya1)/(-kA - Y1) -
        ((I/2)*ya1)/(kA - Y1), 0, 0, 0, 0, 0, 0, 0, -(muA/(-kA - Y1)) -
        muA/(kA - Y1) + ya1/(2*(-kA - Y1)) + ya1/(2*(kA - Y1)), 0, 0, 0, 0,
       0, 0, 0, -1/2*1/(-kA - Y1) - 1/(2*(kA - Y1))},
      {0, 0, 0, 0, (I/2)/(-kA - Y1) - (I/2)/(kA - Y1) +
        ((I/2)*ya1)/(-kA - Y1) - ((I/2)*ya1)/(kA - Y1), 0, 0, 0, 0, 0, 0, 0,
       -(muA/(-kA - Y1)) - muA/(kA - Y1) + ya1/(2*(-kA - Y1)) +
        ya1/(2*(kA - Y1)), 0, 0, 0, (I/2)/(-kA - Y1) - (I/2)/(kA - Y1), 0, 0,
       0}, {0, 0, 0, 0, 0, (I/2)/(-kA - Y1) - (I/2)/(kA - Y1) +
        ((I/2)*ya1)/(-kA - Y1) - ((I/2)*ya1)/(kA - Y1), 0, 0, 0, 0, 0, 0, 0,
       -(muA/(-kA - Y1)) - muA/(kA - Y1) + ya1/(2*(-kA - Y1)) +
        ya1/(2*(kA - Y1)), 0, 0, 0, (I/2)/(-kA - Y1) - (I/2)/(kA - Y1), 0,
       0}, {0, 0, 0, 0, 0, 0, (I/2)/(-kA - Y1) - (I/2)/(kA - Y1) +
        ((I/2)*ya1)/(-kA - Y1) - ((I/2)*ya1)/(kA - Y1), 0, 0, 0, 0, 0, 0, 0,
       -(muA/(-kA - Y1)) - muA/(kA - Y1) + ya1/(2*(-kA - Y1)) +
        ya1/(2*(kA - Y1)), 0, 0, 0, (I/2)/(-kA - Y1) - (I/2)/(kA - Y1), 0},
      {0, 0, 0, 0, 0, 0, 0, (I/2)/(-kA - Y1) - (I/2)/(kA - Y1) +
        ((I/2)*ya1)/(-kA - Y1) - ((I/2)*ya1)/(kA - Y1), 0, 0, 0, 0, 0, 0, 0,
       -(muA/(-kA - Y1)) - muA/(kA - Y1) + ya1/(2*(-kA - Y1)) +
        ya1/(2*(kA - Y1)), 0, 0, 0, (I/2)/(-kA - Y1) - (I/2)/(kA - Y1)},
      {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
       1/(2*(-kB - Y1 - Y2)) - muA/(-kB - Y1 - Y2) + 1/(2*(kB - Y1 - Y2)) -
        muA/(kB - Y1 - Y2) + ya1/(2*(-kB - Y1 - Y2)) +
        ya1/(2*(kB - Y1 - Y2)) + ya2/(2*(-kB - Y1 - Y2)) +
        ya2/(2*(kB - Y1 - Y2)), 0, (I*muA)/(-kB - Y1 - Y2) +
        (I*muB)/(-kB - Y1 - Y2) - (I*muA)/(kB - Y1 - Y2) -
        (I*muB)/(kB - Y1 - Y2) - ((I/2)*ya1)/(-kB - Y1 - Y2) +
        ((I/2)*ya1)/(kB - Y1 - Y2) - ((I/2)*ya2)/(-kB - Y1 - Y2) +
        ((I/2)*ya2)/(kB - Y1 - Y2), 0}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
       0, 0, 0, 0, 0, 1/(2*(-kB - Y1 - Y2)) - muA/(-kB - Y1 - Y2) +
        1/(2*(kB - Y1 - Y2)) - muA/(kB - Y1 - Y2) + ya1/(2*(-kB - Y1 - Y2)) +
        ya1/(2*(kB - Y1 - Y2)) + ya2/(2*(-kB - Y1 - Y2)) +
        ya2/(2*(kB - Y1 - Y2)), 0, (I*muA)/(-kB - Y1 - Y2) +
        (I*muB)/(-kB - Y1 - Y2) - (I*muA)/(kB - Y1 - Y2) -
        (I*muB)/(kB - Y1 - Y2) - ((I/2)*ya1)/(-kB - Y1 - Y2) +
        ((I/2)*ya1)/(kB - Y1 - Y2) - ((I/2)*ya2)/(-kB - Y1 - Y2) +
        ((I/2)*ya2)/(kB - Y1 - Y2)}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
       0, 0, 0, (I/2)/(-kB - Y1 - Y2) - (I*muA)/(-kB - Y1 - Y2) -
        (I/2)/(kB - Y1 - Y2) + (I*muA)/(kB - Y1 - Y2) +
        ((I/2)*ya1)/(-kB - Y1 - Y2) - ((I/2)*ya1)/(kB - Y1 - Y2) +
        ((I/2)*ya2)/(-kB - Y1 - Y2) - ((I/2)*ya2)/(kB - Y1 - Y2), 0,
       -(muA/(-kB - Y1 - Y2)) - muB/(-kB - Y1 - Y2) - muA/(kB - Y1 - Y2) -
        muB/(kB - Y1 - Y2) + ya1/(2*(-kB - Y1 - Y2)) +
        ya1/(2*(kB - Y1 - Y2)) + ya2/(2*(-kB - Y1 - Y2)) +
        ya2/(2*(kB - Y1 - Y2)), 0}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
       0, 0, 0, 0, (I/2)/(-kB - Y1 - Y2) - (I*muA)/(-kB - Y1 - Y2) -
        (I/2)/(kB - Y1 - Y2) + (I*muA)/(kB - Y1 - Y2) +
        ((I/2)*ya1)/(-kB - Y1 - Y2) - ((I/2)*ya1)/(kB - Y1 - Y2) +
        ((I/2)*ya2)/(-kB - Y1 - Y2) - ((I/2)*ya2)/(kB - Y1 - Y2), 0,
       -(muA/(-kB - Y1 - Y2)) - muB/(-kB - Y1 - Y2) - muA/(kB - Y1 - Y2) -
        muB/(kB - Y1 - Y2) + ya1/(2*(-kB - Y1 - Y2)) +
        ya1/(2*(kB - Y1 - Y2)) + ya2/(2*(-kB - Y1 - Y2)) +
        ya2/(2*(kB - Y1 - Y2))}}, "difference" -> 0|>,
   <|"group" -> "pureTime", "name" -> "three naive dlog Y2",
    "passed" -> True, "actual" ->
     {{(kA^2*Y2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 +
          Y2^4) + (kB^2*Y2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) - Y2^3/(kA^4 - 2*kA^2*kB^2 + kB^4 -
          2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) + (kA^2*Y2*ya2)/
         (kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) +
        (kB^2*Y2*ya2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) - (Y2^3*ya2)/(kA^4 - 2*kA^2*kB^2 + kB^4 -
          2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4), 0,
       ((2*I)*kA^2*kB*muB)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) - ((2*I)*kB^3*muB)/(kA^4 - 2*kA^2*kB^2 + kB^4 -
          2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) + ((2*I)*kB*muB*Y2^2)/
         (kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) -
        (I*kA^2*kB*ya2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) + (I*kB^3*ya2)/(kA^4 - 2*kA^2*kB^2 + kB^4 -
          2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) - (I*kB*Y2^2*ya2)/
         (kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4), 0,
       ((-2*I)*kA^3*muA)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) + ((2*I)*kA*kB^2*muA)/(kA^4 - 2*kA^2*kB^2 +
          kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) + ((2*I)*kA*muA*Y2^2)/
         (kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) +
        (I*kA^3*ya2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 +
          Y2^4) - (I*kA*kB^2*ya2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) - (I*kA*Y2^2*ya2)/(kA^4 - 2*kA^2*kB^2 + kB^4 -
          2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4), 0,
       (-2*kA*kB*Y2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 +
          Y2^4) - (4*kA*kB*muA*Y2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) - (4*kA*kB*muB*Y2)/(kA^4 - 2*kA^2*kB^2 + kB^4 -
          2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) + (2*kA*kB*Y2*ya2)/
         (kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4), 0,
       0, 0, 0, 0, 0, 0, 0, 0, ((-I)*kA^3)/(kA^4 - 2*kA^2*kB^2 + kB^4 -
          2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) + (I*kA*kB^2)/
         (kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) +
        (I*kA*Y2^2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 +
          Y2^4), 0, (-2*kA*kB*Y2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
         2*kB^2*Y2^2 + Y2^4), 0},
      {0, (kA^2*Y2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 +
          Y2^4) + (kB^2*Y2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) - Y2^3/(kA^4 - 2*kA^2*kB^2 + kB^4 -
          2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) + (kA^2*Y2*ya2)/
         (kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) +
        (kB^2*Y2*ya2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) - (Y2^3*ya2)/(kA^4 - 2*kA^2*kB^2 + kB^4 -
          2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4), 0,
       ((2*I)*kA^2*kB*muB)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) - ((2*I)*kB^3*muB)/(kA^4 - 2*kA^2*kB^2 + kB^4 -
          2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) + ((2*I)*kB*muB*Y2^2)/
         (kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) -
        (I*kA^2*kB*ya2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) + (I*kB^3*ya2)/(kA^4 - 2*kA^2*kB^2 + kB^4 -
          2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) - (I*kB*Y2^2*ya2)/
         (kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4), 0,
       ((-2*I)*kA^3*muA)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) + ((2*I)*kA*kB^2*muA)/(kA^4 - 2*kA^2*kB^2 +
          kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) + ((2*I)*kA*muA*Y2^2)/
         (kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) +
        (I*kA^3*ya2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 +
          Y2^4) - (I*kA*kB^2*ya2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) - (I*kA*Y2^2*ya2)/(kA^4 - 2*kA^2*kB^2 + kB^4 -
          2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4), 0,
       (-2*kA*kB*Y2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 +
          Y2^4) - (4*kA*kB*muA*Y2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) - (4*kA*kB*muB*Y2)/(kA^4 - 2*kA^2*kB^2 + kB^4 -
          2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) + (2*kA*kB*Y2*ya2)/
         (kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4), 0,
       0, 0, 0, 0, 0, 0, 0, 0, ((-I)*kA^3)/(kA^4 - 2*kA^2*kB^2 + kB^4 -
          2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) + (I*kA*kB^2)/
         (kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) +
        (I*kA*Y2^2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 +
          Y2^4), 0, (-2*kA*kB*Y2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
         2*kB^2*Y2^2 + Y2^4)}, {(I*kA^2*kB)/(kA^4 - 2*kA^2*kB^2 + kB^4 -
          2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) - (I*kB^3)/(kA^4 - 2*kA^2*kB^2 +
          kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) +
        (I*kB*Y2^2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 +
          Y2^4) + (I*kA^2*kB*ya2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) - (I*kB^3*ya2)/(kA^4 - 2*kA^2*kB^2 + kB^4 -
          2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) + (I*kB*Y2^2*ya2)/
         (kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4), 0,
       (-2*kA^2*muB*Y2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) - (2*kB^2*muB*Y2)/(kA^4 - 2*kA^2*kB^2 + kB^4 -
          2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) + (2*muB*Y2^3)/
         (kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) +
        (kA^2*Y2*ya2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) + (kB^2*Y2*ya2)/(kA^4 - 2*kA^2*kB^2 + kB^4 -
          2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) - (Y2^3*ya2)/
         (kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4), 0,
       (4*kA*kB*muA*Y2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) - (2*kA*kB*Y2*ya2)/(kA^4 - 2*kA^2*kB^2 + kB^4 -
          2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4), 0,
       ((-I)*kA^3)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 +
          Y2^4) + (I*kA*kB^2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) - ((2*I)*kA^3*muA)/(kA^4 - 2*kA^2*kB^2 + kB^4 -
          2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) + ((2*I)*kA*kB^2*muA)/
         (kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) -
        ((2*I)*kA^3*muB)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) + ((2*I)*kA*kB^2*muB)/(kA^4 - 2*kA^2*kB^2 +
          kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) +
        (I*kA*Y2^2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 +
          Y2^4) + ((2*I)*kA*muA*Y2^2)/(kA^4 - 2*kA^2*kB^2 + kB^4 -
          2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) + ((2*I)*kA*muB*Y2^2)/
         (kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) +
        (I*kA^3*ya2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 +
          Y2^4) - (I*kA*kB^2*ya2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) - (I*kA*Y2^2*ya2)/(kA^4 - 2*kA^2*kB^2 + kB^4 -
          2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4), 0, 0, 0, 0, 0, 0, 0, 0, 0,
       (2*kA*kB*Y2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 +
         Y2^4), 0, ((-I)*kA^3)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) + (I*kA*kB^2)/(kA^4 - 2*kA^2*kB^2 + kB^4 -
          2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) + (I*kA*Y2^2)/
         (kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4), 0},
      {0, (I*kA^2*kB)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) - (I*kB^3)/(kA^4 - 2*kA^2*kB^2 + kB^4 -
          2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) + (I*kB*Y2^2)/
         (kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) +
        (I*kA^2*kB*ya2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) - (I*kB^3*ya2)/(kA^4 - 2*kA^2*kB^2 + kB^4 -
          2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) + (I*kB*Y2^2*ya2)/
         (kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4), 0,
       (-2*kA^2*muB*Y2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) - (2*kB^2*muB*Y2)/(kA^4 - 2*kA^2*kB^2 + kB^4 -
          2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) + (2*muB*Y2^3)/
         (kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) +
        (kA^2*Y2*ya2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) + (kB^2*Y2*ya2)/(kA^4 - 2*kA^2*kB^2 + kB^4 -
          2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) - (Y2^3*ya2)/
         (kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4), 0,
       (4*kA*kB*muA*Y2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) - (2*kA*kB*Y2*ya2)/(kA^4 - 2*kA^2*kB^2 + kB^4 -
          2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4), 0,
       ((-I)*kA^3)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 +
          Y2^4) + (I*kA*kB^2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) - ((2*I)*kA^3*muA)/(kA^4 - 2*kA^2*kB^2 + kB^4 -
          2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) + ((2*I)*kA*kB^2*muA)/
         (kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) -
        ((2*I)*kA^3*muB)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) + ((2*I)*kA*kB^2*muB)/(kA^4 - 2*kA^2*kB^2 +
          kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) +
        (I*kA*Y2^2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 +
          Y2^4) + ((2*I)*kA*muA*Y2^2)/(kA^4 - 2*kA^2*kB^2 + kB^4 -
          2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) + ((2*I)*kA*muB*Y2^2)/
         (kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) +
        (I*kA^3*ya2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 +
          Y2^4) - (I*kA*kB^2*ya2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) - (I*kA*Y2^2*ya2)/(kA^4 - 2*kA^2*kB^2 + kB^4 -
          2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4), 0, 0, 0, 0, 0, 0, 0, 0, 0,
       (2*kA*kB*Y2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 +
         Y2^4), 0, ((-I)*kA^3)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) + (I*kA*kB^2)/(kA^4 - 2*kA^2*kB^2 + kB^4 -
          2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) + (I*kA*Y2^2)/
         (kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4)},
      {((-I)*kA^3)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 +
          Y2^4) + (I*kA*kB^2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) + (I*kA*Y2^2)/(kA^4 - 2*kA^2*kB^2 + kB^4 -
          2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) - (I*kA^3*ya2)/
         (kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) +
        (I*kA*kB^2*ya2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) + (I*kA*Y2^2*ya2)/(kA^4 - 2*kA^2*kB^2 + kB^4 -
          2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4), 0,
       (4*kA*kB*muB*Y2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) - (2*kA*kB*Y2*ya2)/(kA^4 - 2*kA^2*kB^2 + kB^4 -
          2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4), 0,
       (-2*kA^2*muA*Y2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) - (2*kB^2*muA*Y2)/(kA^4 - 2*kA^2*kB^2 + kB^4 -
          2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) + (2*muA*Y2^3)/
         (kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) +
        (kA^2*Y2*ya2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) + (kB^2*Y2*ya2)/(kA^4 - 2*kA^2*kB^2 + kB^4 -
          2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) - (Y2^3*ya2)/
         (kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4), 0,
       (I*kA^2*kB)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 +
          Y2^4) - (I*kB^3)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) + ((2*I)*kA^2*kB*muA)/(kA^4 - 2*kA^2*kB^2 +
          kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) - ((2*I)*kB^3*muA)/
         (kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) +
        ((2*I)*kA^2*kB*muB)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) - ((2*I)*kB^3*muB)/(kA^4 - 2*kA^2*kB^2 + kB^4 -
          2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) + (I*kB*Y2^2)/
         (kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) +
        ((2*I)*kB*muA*Y2^2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) + ((2*I)*kB*muB*Y2^2)/(kA^4 - 2*kA^2*kB^2 +
          kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) - (I*kA^2*kB*ya2)/
         (kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) +
        (I*kB^3*ya2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 +
          Y2^4) - (I*kB*Y2^2*ya2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4), 0, 0, 0, 0, 0, 0, 0, 0, 0,
       -((kA^2*Y2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 +
           Y2^4)) - (kB^2*Y2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) + Y2^3/(kA^4 - 2*kA^2*kB^2 + kB^4 -
          2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4), 0,
       (I*kA^2*kB)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 +
          Y2^4) - (I*kB^3)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) + (I*kB*Y2^2)/(kA^4 - 2*kA^2*kB^2 + kB^4 -
          2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4), 0},
      {0, ((-I)*kA^3)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) + (I*kA*kB^2)/(kA^4 - 2*kA^2*kB^2 + kB^4 -
          2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) + (I*kA*Y2^2)/
         (kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) -
        (I*kA^3*ya2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 +
          Y2^4) + (I*kA*kB^2*ya2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) + (I*kA*Y2^2*ya2)/(kA^4 - 2*kA^2*kB^2 + kB^4 -
          2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4), 0,
       (4*kA*kB*muB*Y2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) - (2*kA*kB*Y2*ya2)/(kA^4 - 2*kA^2*kB^2 + kB^4 -
          2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4), 0,
       (-2*kA^2*muA*Y2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) - (2*kB^2*muA*Y2)/(kA^4 - 2*kA^2*kB^2 + kB^4 -
          2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) + (2*muA*Y2^3)/
         (kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) +
        (kA^2*Y2*ya2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) + (kB^2*Y2*ya2)/(kA^4 - 2*kA^2*kB^2 + kB^4 -
          2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) - (Y2^3*ya2)/
         (kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4), 0,
       (I*kA^2*kB)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 +
          Y2^4) - (I*kB^3)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) + ((2*I)*kA^2*kB*muA)/(kA^4 - 2*kA^2*kB^2 +
          kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) - ((2*I)*kB^3*muA)/
         (kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) +
        ((2*I)*kA^2*kB*muB)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) - ((2*I)*kB^3*muB)/(kA^4 - 2*kA^2*kB^2 + kB^4 -
          2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) + (I*kB*Y2^2)/
         (kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) +
        ((2*I)*kB*muA*Y2^2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) + ((2*I)*kB*muB*Y2^2)/(kA^4 - 2*kA^2*kB^2 +
          kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) - (I*kA^2*kB*ya2)/
         (kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) +
        (I*kB^3*ya2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 +
          Y2^4) - (I*kB*Y2^2*ya2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4), 0, 0, 0, 0, 0, 0, 0, 0, 0,
       -((kA^2*Y2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 +
           Y2^4)) - (kB^2*Y2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) + Y2^3/(kA^4 - 2*kA^2*kB^2 + kB^4 -
          2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4), 0,
       (I*kA^2*kB)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 +
          Y2^4) - (I*kB^3)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) + (I*kB*Y2^2)/(kA^4 - 2*kA^2*kB^2 + kB^4 -
          2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4)},
      {(2*kA^2*kB^2*Y2)/(kA^5*kB - 2*kA^3*kB^3 + kA*kB^5 - 2*kA^3*kB*Y2^2 -
          2*kA*kB^3*Y2^2 + kA*kB*Y2^4) + (2*kA^2*kB^2*Y2*ya2)/
         (kA^5*kB - 2*kA^3*kB^3 + kA*kB^5 - 2*kA^3*kB*Y2^2 - 2*kA*kB^3*Y2^2 +
          kA*kB*Y2^4), 0, ((2*I)*kA^4*kB*muB)/(kA^5*kB - 2*kA^3*kB^3 +
          kA*kB^5 - 2*kA^3*kB*Y2^2 - 2*kA*kB^3*Y2^2 + kA*kB*Y2^4) -
        ((2*I)*kA^2*kB^3*muB)/(kA^5*kB - 2*kA^3*kB^3 + kA*kB^5 -
          2*kA^3*kB*Y2^2 - 2*kA*kB^3*Y2^2 + kA*kB*Y2^4) -
        ((2*I)*kA^2*kB*muB*Y2^2)/(kA^5*kB - 2*kA^3*kB^3 + kA*kB^5 -
          2*kA^3*kB*Y2^2 - 2*kA*kB^3*Y2^2 + kA*kB*Y2^4) -
        (I*kA^4*kB*ya2)/(kA^5*kB - 2*kA^3*kB^3 + kA*kB^5 - 2*kA^3*kB*Y2^2 -
          2*kA*kB^3*Y2^2 + kA*kB*Y2^4) + (I*kA^2*kB^3*ya2)/
         (kA^5*kB - 2*kA^3*kB^3 + kA*kB^5 - 2*kA^3*kB*Y2^2 - 2*kA*kB^3*Y2^2 +
          kA*kB*Y2^4) + (I*kA^2*kB*Y2^2*ya2)/(kA^5*kB - 2*kA^3*kB^3 +
          kA*kB^5 - 2*kA^3*kB*Y2^2 - 2*kA*kB^3*Y2^2 + kA*kB*Y2^4), 0,
       ((-2*I)*kA^3*kB^2*muA)/(kA^5*kB - 2*kA^3*kB^3 + kA*kB^5 -
          2*kA^3*kB*Y2^2 - 2*kA*kB^3*Y2^2 + kA*kB*Y2^4) +
        ((2*I)*kA*kB^4*muA)/(kA^5*kB - 2*kA^3*kB^3 + kA*kB^5 -
          2*kA^3*kB*Y2^2 - 2*kA*kB^3*Y2^2 + kA*kB*Y2^4) -
        ((2*I)*kA*kB^2*muA*Y2^2)/(kA^5*kB - 2*kA^3*kB^3 + kA*kB^5 -
          2*kA^3*kB*Y2^2 - 2*kA*kB^3*Y2^2 + kA*kB*Y2^4) +
        (I*kA^3*kB^2*ya2)/(kA^5*kB - 2*kA^3*kB^3 + kA*kB^5 - 2*kA^3*kB*Y2^2 -
          2*kA*kB^3*Y2^2 + kA*kB*Y2^4) - (I*kA*kB^4*ya2)/
         (kA^5*kB - 2*kA^3*kB^3 + kA*kB^5 - 2*kA^3*kB*Y2^2 - 2*kA*kB^3*Y2^2 +
          kA*kB*Y2^4) + (I*kA*kB^2*Y2^2*ya2)/(kA^5*kB - 2*kA^3*kB^3 +
          kA*kB^5 - 2*kA^3*kB*Y2^2 - 2*kA*kB^3*Y2^2 + kA*kB*Y2^4), 0,
       -((kA^3*kB*Y2)/(kA^5*kB - 2*kA^3*kB^3 + kA*kB^5 - 2*kA^3*kB*Y2^2 -
           2*kA*kB^3*Y2^2 + kA*kB*Y2^4)) - (kA*kB^3*Y2)/
         (kA^5*kB - 2*kA^3*kB^3 + kA*kB^5 - 2*kA^3*kB*Y2^2 - 2*kA*kB^3*Y2^2 +
          kA*kB*Y2^4) - (2*kA^3*kB*muA*Y2)/(kA^5*kB - 2*kA^3*kB^3 + kA*kB^5 -
          2*kA^3*kB*Y2^2 - 2*kA*kB^3*Y2^2 + kA*kB*Y2^4) -
        (2*kA*kB^3*muA*Y2)/(kA^5*kB - 2*kA^3*kB^3 + kA*kB^5 -
          2*kA^3*kB*Y2^2 - 2*kA*kB^3*Y2^2 + kA*kB*Y2^4) -
        (2*kA^3*kB*muB*Y2)/(kA^5*kB - 2*kA^3*kB^3 + kA*kB^5 -
          2*kA^3*kB*Y2^2 - 2*kA*kB^3*Y2^2 + kA*kB*Y2^4) -
        (2*kA*kB^3*muB*Y2)/(kA^5*kB - 2*kA^3*kB^3 + kA*kB^5 -
          2*kA^3*kB*Y2^2 - 2*kA*kB^3*Y2^2 + kA*kB*Y2^4) +
        (kA*kB*Y2^3)/(kA^5*kB - 2*kA^3*kB^3 + kA*kB^5 - 2*kA^3*kB*Y2^2 -
          2*kA*kB^3*Y2^2 + kA*kB*Y2^4) + (2*kA*kB*muA*Y2^3)/
         (kA^5*kB - 2*kA^3*kB^3 + kA*kB^5 - 2*kA^3*kB*Y2^2 - 2*kA*kB^3*Y2^2 +
          kA*kB*Y2^4) + (2*kA*kB*muB*Y2^3)/(kA^5*kB - 2*kA^3*kB^3 + kA*kB^5 -
          2*kA^3*kB*Y2^2 - 2*kA*kB^3*Y2^2 + kA*kB*Y2^4) +
        (kA^3*kB*Y2*ya2)/(kA^5*kB - 2*kA^3*kB^3 + kA*kB^5 - 2*kA^3*kB*Y2^2 -
          2*kA*kB^3*Y2^2 + kA*kB*Y2^4) + (kA*kB^3*Y2*ya2)/
         (kA^5*kB - 2*kA^3*kB^3 + kA*kB^5 - 2*kA^3*kB*Y2^2 - 2*kA*kB^3*Y2^2 +
          kA*kB*Y2^4) - (kA*kB*Y2^3*ya2)/(kA^5*kB - 2*kA^3*kB^3 + kA*kB^5 -
          2*kA^3*kB*Y2^2 - 2*kA*kB^3*Y2^2 + kA*kB*Y2^4), 0, 0, 0, 0, 0, 0, 0,
       0, 0, ((-I)*kA^3*kB^2)/(kA^5*kB - 2*kA^3*kB^3 + kA*kB^5 -
          2*kA^3*kB*Y2^2 - 2*kA*kB^3*Y2^2 + kA*kB*Y2^4) +
        (I*kA*kB^4)/(kA^5*kB - 2*kA^3*kB^3 + kA*kB^5 - 2*kA^3*kB*Y2^2 -
          2*kA*kB^3*Y2^2 + kA*kB*Y2^4) - (I*kA*kB^2*Y2^2)/
         (kA^5*kB - 2*kA^3*kB^3 + kA*kB^5 - 2*kA^3*kB*Y2^2 - 2*kA*kB^3*Y2^2 +
          kA*kB*Y2^4), 0, -((kA^3*kB*Y2)/(kA^5*kB - 2*kA^3*kB^3 + kA*kB^5 -
           2*kA^3*kB*Y2^2 - 2*kA*kB^3*Y2^2 + kA*kB*Y2^4)) -
        (kA*kB^3*Y2)/(kA^5*kB - 2*kA^3*kB^3 + kA*kB^5 - 2*kA^3*kB*Y2^2 -
          2*kA*kB^3*Y2^2 + kA*kB*Y2^4) + (kA*kB*Y2^3)/
         (kA^5*kB - 2*kA^3*kB^3 + kA*kB^5 - 2*kA^3*kB*Y2^2 - 2*kA*kB^3*Y2^2 +
          kA*kB*Y2^4), 0}, {0, (2*kA^2*kB^2*Y2)/(kA^5*kB - 2*kA^3*kB^3 +
          kA*kB^5 - 2*kA^3*kB*Y2^2 - 2*kA*kB^3*Y2^2 + kA*kB*Y2^4) +
        (2*kA^2*kB^2*Y2*ya2)/(kA^5*kB - 2*kA^3*kB^3 + kA*kB^5 -
          2*kA^3*kB*Y2^2 - 2*kA*kB^3*Y2^2 + kA*kB*Y2^4), 0,
       ((2*I)*kA^4*kB*muB)/(kA^5*kB - 2*kA^3*kB^3 + kA*kB^5 -
          2*kA^3*kB*Y2^2 - 2*kA*kB^3*Y2^2 + kA*kB*Y2^4) -
        ((2*I)*kA^2*kB^3*muB)/(kA^5*kB - 2*kA^3*kB^3 + kA*kB^5 -
          2*kA^3*kB*Y2^2 - 2*kA*kB^3*Y2^2 + kA*kB*Y2^4) -
        ((2*I)*kA^2*kB*muB*Y2^2)/(kA^5*kB - 2*kA^3*kB^3 + kA*kB^5 -
          2*kA^3*kB*Y2^2 - 2*kA*kB^3*Y2^2 + kA*kB*Y2^4) -
        (I*kA^4*kB*ya2)/(kA^5*kB - 2*kA^3*kB^3 + kA*kB^5 - 2*kA^3*kB*Y2^2 -
          2*kA*kB^3*Y2^2 + kA*kB*Y2^4) + (I*kA^2*kB^3*ya2)/
         (kA^5*kB - 2*kA^3*kB^3 + kA*kB^5 - 2*kA^3*kB*Y2^2 - 2*kA*kB^3*Y2^2 +
          kA*kB*Y2^4) + (I*kA^2*kB*Y2^2*ya2)/(kA^5*kB - 2*kA^3*kB^3 +
          kA*kB^5 - 2*kA^3*kB*Y2^2 - 2*kA*kB^3*Y2^2 + kA*kB*Y2^4), 0,
       ((-2*I)*kA^3*kB^2*muA)/(kA^5*kB - 2*kA^3*kB^3 + kA*kB^5 -
          2*kA^3*kB*Y2^2 - 2*kA*kB^3*Y2^2 + kA*kB*Y2^4) +
        ((2*I)*kA*kB^4*muA)/(kA^5*kB - 2*kA^3*kB^3 + kA*kB^5 -
          2*kA^3*kB*Y2^2 - 2*kA*kB^3*Y2^2 + kA*kB*Y2^4) -
        ((2*I)*kA*kB^2*muA*Y2^2)/(kA^5*kB - 2*kA^3*kB^3 + kA*kB^5 -
          2*kA^3*kB*Y2^2 - 2*kA*kB^3*Y2^2 + kA*kB*Y2^4) +
        (I*kA^3*kB^2*ya2)/(kA^5*kB - 2*kA^3*kB^3 + kA*kB^5 - 2*kA^3*kB*Y2^2 -
          2*kA*kB^3*Y2^2 + kA*kB*Y2^4) - (I*kA*kB^4*ya2)/
         (kA^5*kB - 2*kA^3*kB^3 + kA*kB^5 - 2*kA^3*kB*Y2^2 - 2*kA*kB^3*Y2^2 +
          kA*kB*Y2^4) + (I*kA*kB^2*Y2^2*ya2)/(kA^5*kB - 2*kA^3*kB^3 +
          kA*kB^5 - 2*kA^3*kB*Y2^2 - 2*kA*kB^3*Y2^2 + kA*kB*Y2^4), 0,
       -((kA^3*kB*Y2)/(kA^5*kB - 2*kA^3*kB^3 + kA*kB^5 - 2*kA^3*kB*Y2^2 -
           2*kA*kB^3*Y2^2 + kA*kB*Y2^4)) - (kA*kB^3*Y2)/
         (kA^5*kB - 2*kA^3*kB^3 + kA*kB^5 - 2*kA^3*kB*Y2^2 - 2*kA*kB^3*Y2^2 +
          kA*kB*Y2^4) - (2*kA^3*kB*muA*Y2)/(kA^5*kB - 2*kA^3*kB^3 + kA*kB^5 -
          2*kA^3*kB*Y2^2 - 2*kA*kB^3*Y2^2 + kA*kB*Y2^4) -
        (2*kA*kB^3*muA*Y2)/(kA^5*kB - 2*kA^3*kB^3 + kA*kB^5 -
          2*kA^3*kB*Y2^2 - 2*kA*kB^3*Y2^2 + kA*kB*Y2^4) -
        (2*kA^3*kB*muB*Y2)/(kA^5*kB - 2*kA^3*kB^3 + kA*kB^5 -
          2*kA^3*kB*Y2^2 - 2*kA*kB^3*Y2^2 + kA*kB*Y2^4) -
        (2*kA*kB^3*muB*Y2)/(kA^5*kB - 2*kA^3*kB^3 + kA*kB^5 -
          2*kA^3*kB*Y2^2 - 2*kA*kB^3*Y2^2 + kA*kB*Y2^4) +
        (kA*kB*Y2^3)/(kA^5*kB - 2*kA^3*kB^3 + kA*kB^5 - 2*kA^3*kB*Y2^2 -
          2*kA*kB^3*Y2^2 + kA*kB*Y2^4) + (2*kA*kB*muA*Y2^3)/
         (kA^5*kB - 2*kA^3*kB^3 + kA*kB^5 - 2*kA^3*kB*Y2^2 - 2*kA*kB^3*Y2^2 +
          kA*kB*Y2^4) + (2*kA*kB*muB*Y2^3)/(kA^5*kB - 2*kA^3*kB^3 + kA*kB^5 -
          2*kA^3*kB*Y2^2 - 2*kA*kB^3*Y2^2 + kA*kB*Y2^4) +
        (kA^3*kB*Y2*ya2)/(kA^5*kB - 2*kA^3*kB^3 + kA*kB^5 - 2*kA^3*kB*Y2^2 -
          2*kA*kB^3*Y2^2 + kA*kB*Y2^4) + (kA*kB^3*Y2*ya2)/
         (kA^5*kB - 2*kA^3*kB^3 + kA*kB^5 - 2*kA^3*kB*Y2^2 - 2*kA*kB^3*Y2^2 +
          kA*kB*Y2^4) - (kA*kB*Y2^3*ya2)/(kA^5*kB - 2*kA^3*kB^3 + kA*kB^5 -
          2*kA^3*kB*Y2^2 - 2*kA*kB^3*Y2^2 + kA*kB*Y2^4), 0, 0, 0, 0, 0, 0, 0,
       0, 0, ((-I)*kA^3*kB^2)/(kA^5*kB - 2*kA^3*kB^3 + kA*kB^5 -
          2*kA^3*kB*Y2^2 - 2*kA*kB^3*Y2^2 + kA*kB*Y2^4) +
        (I*kA*kB^4)/(kA^5*kB - 2*kA^3*kB^3 + kA*kB^5 - 2*kA^3*kB*Y2^2 -
          2*kA*kB^3*Y2^2 + kA*kB*Y2^4) - (I*kA*kB^2*Y2^2)/
         (kA^5*kB - 2*kA^3*kB^3 + kA*kB^5 - 2*kA^3*kB*Y2^2 - 2*kA*kB^3*Y2^2 +
          kA*kB*Y2^4), 0, -((kA^3*kB*Y2)/(kA^5*kB - 2*kA^3*kB^3 + kA*kB^5 -
           2*kA^3*kB*Y2^2 - 2*kA*kB^3*Y2^2 + kA*kB*Y2^4)) -
        (kA*kB^3*Y2)/(kA^5*kB - 2*kA^3*kB^3 + kA*kB^5 - 2*kA^3*kB*Y2^2 -
          2*kA*kB^3*Y2^2 + kA*kB*Y2^4) + (kA*kB*Y2^3)/
         (kA^5*kB - 2*kA^3*kB^3 + kA*kB^5 - 2*kA^3*kB*Y2^2 - 2*kA*kB^3*Y2^2 +
          kA*kB*Y2^4)}, {0, 0, 0, 0, 0, 0, 0, 0,
       (kA^2*Y2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 +
          Y2^4) + (kB^2*Y2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) - Y2^3/(kA^4 - 2*kA^2*kB^2 + kB^4 -
          2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) + (kA^2*Y2*ya2)/
         (kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) +
        (kB^2*Y2*ya2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) - (Y2^3*ya2)/(kA^4 - 2*kA^2*kB^2 + kB^4 -
          2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4), 0,
       ((2*I)*kA^2*kB*muB)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) - ((2*I)*kB^3*muB)/(kA^4 - 2*kA^2*kB^2 + kB^4 -
          2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) + ((2*I)*kB*muB*Y2^2)/
         (kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) -
        (I*kA^2*kB*ya2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) + (I*kB^3*ya2)/(kA^4 - 2*kA^2*kB^2 + kB^4 -
          2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) - (I*kB*Y2^2*ya2)/
         (kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4), 0,
       ((-2*I)*kA^3*muA)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) + ((2*I)*kA*kB^2*muA)/(kA^4 - 2*kA^2*kB^2 +
          kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) + ((2*I)*kA*muA*Y2^2)/
         (kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) +
        (I*kA^3*ya2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 +
          Y2^4) - (I*kA*kB^2*ya2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) - (I*kA*Y2^2*ya2)/(kA^4 - 2*kA^2*kB^2 + kB^4 -
          2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4), 0,
       (-2*kA*kB*Y2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 +
          Y2^4) - (4*kA*kB*muA*Y2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) - (4*kA*kB*muB*Y2)/(kA^4 - 2*kA^2*kB^2 + kB^4 -
          2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) + (2*kA*kB*Y2*ya2)/
         (kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4), 0,
       (kA^2*Y2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 +
          Y2^4) + (kB^2*Y2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) - Y2^3/(kA^4 - 2*kA^2*kB^2 + kB^4 -
          2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4), 0,
       ((-I)*kA^2*kB)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) + (I*kB^3)/(kA^4 - 2*kA^2*kB^2 + kB^4 -
          2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) - (I*kB*Y2^2)/
         (kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4), 0},
      {0, 0, 0, 0, 0, 0, 0, 0, 0, (kA^2*Y2)/(kA^4 - 2*kA^2*kB^2 + kB^4 -
          2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) + (kB^2*Y2)/(kA^4 - 2*kA^2*kB^2 +
          kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) -
        Y2^3/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) +
        (kA^2*Y2*ya2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) + (kB^2*Y2*ya2)/(kA^4 - 2*kA^2*kB^2 + kB^4 -
          2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) - (Y2^3*ya2)/
         (kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4), 0,
       ((2*I)*kA^2*kB*muB)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) - ((2*I)*kB^3*muB)/(kA^4 - 2*kA^2*kB^2 + kB^4 -
          2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) + ((2*I)*kB*muB*Y2^2)/
         (kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) -
        (I*kA^2*kB*ya2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) + (I*kB^3*ya2)/(kA^4 - 2*kA^2*kB^2 + kB^4 -
          2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) - (I*kB*Y2^2*ya2)/
         (kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4), 0,
       ((-2*I)*kA^3*muA)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) + ((2*I)*kA*kB^2*muA)/(kA^4 - 2*kA^2*kB^2 +
          kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) + ((2*I)*kA*muA*Y2^2)/
         (kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) +
        (I*kA^3*ya2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 +
          Y2^4) - (I*kA*kB^2*ya2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) - (I*kA*Y2^2*ya2)/(kA^4 - 2*kA^2*kB^2 + kB^4 -
          2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4), 0,
       (-2*kA*kB*Y2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 +
          Y2^4) - (4*kA*kB*muA*Y2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) - (4*kA*kB*muB*Y2)/(kA^4 - 2*kA^2*kB^2 + kB^4 -
          2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) + (2*kA*kB*Y2*ya2)/
         (kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4), 0,
       (kA^2*Y2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 +
          Y2^4) + (kB^2*Y2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) - Y2^3/(kA^4 - 2*kA^2*kB^2 + kB^4 -
          2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4), 0,
       ((-I)*kA^2*kB)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) + (I*kB^3)/(kA^4 - 2*kA^2*kB^2 + kB^4 -
          2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) - (I*kB*Y2^2)/
         (kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4)},
      {0, 0, 0, 0, 0, 0, 0, 0, (I*kA^2*kB)/(kA^4 - 2*kA^2*kB^2 + kB^4 -
          2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) - (I*kB^3)/(kA^4 - 2*kA^2*kB^2 +
          kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) +
        (I*kB*Y2^2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 +
          Y2^4) + (I*kA^2*kB*ya2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) - (I*kB^3*ya2)/(kA^4 - 2*kA^2*kB^2 + kB^4 -
          2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) + (I*kB*Y2^2*ya2)/
         (kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4), 0,
       (-2*kA^2*muB*Y2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) - (2*kB^2*muB*Y2)/(kA^4 - 2*kA^2*kB^2 + kB^4 -
          2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) + (2*muB*Y2^3)/
         (kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) +
        (kA^2*Y2*ya2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) + (kB^2*Y2*ya2)/(kA^4 - 2*kA^2*kB^2 + kB^4 -
          2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) - (Y2^3*ya2)/
         (kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4), 0,
       (4*kA*kB*muA*Y2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) - (2*kA*kB*Y2*ya2)/(kA^4 - 2*kA^2*kB^2 + kB^4 -
          2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4), 0,
       ((-I)*kA^3)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 +
          Y2^4) + (I*kA*kB^2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) - ((2*I)*kA^3*muA)/(kA^4 - 2*kA^2*kB^2 + kB^4 -
          2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) + ((2*I)*kA*kB^2*muA)/
         (kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) -
        ((2*I)*kA^3*muB)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) + ((2*I)*kA*kB^2*muB)/(kA^4 - 2*kA^2*kB^2 +
          kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) +
        (I*kA*Y2^2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 +
          Y2^4) + ((2*I)*kA*muA*Y2^2)/(kA^4 - 2*kA^2*kB^2 + kB^4 -
          2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) + ((2*I)*kA*muB*Y2^2)/
         (kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) +
        (I*kA^3*ya2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 +
          Y2^4) - (I*kA*kB^2*ya2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) - (I*kA*Y2^2*ya2)/(kA^4 - 2*kA^2*kB^2 + kB^4 -
          2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4), 0,
       (I*kA^2*kB)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 +
          Y2^4) - (I*kB^3)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) + (I*kB*Y2^2)/(kA^4 - 2*kA^2*kB^2 + kB^4 -
          2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4), 0,
       (kA^2*Y2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 +
          Y2^4) + (kB^2*Y2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) - Y2^3/(kA^4 - 2*kA^2*kB^2 + kB^4 -
          2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4), 0}, {0, 0, 0, 0, 0, 0, 0, 0, 0,
       (I*kA^2*kB)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 +
          Y2^4) - (I*kB^3)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) + (I*kB*Y2^2)/(kA^4 - 2*kA^2*kB^2 + kB^4 -
          2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) + (I*kA^2*kB*ya2)/
         (kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) -
        (I*kB^3*ya2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 +
          Y2^4) + (I*kB*Y2^2*ya2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4), 0, (-2*kA^2*muB*Y2)/(kA^4 - 2*kA^2*kB^2 +
          kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) - (2*kB^2*muB*Y2)/
         (kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) +
        (2*muB*Y2^3)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 +
          Y2^4) + (kA^2*Y2*ya2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) + (kB^2*Y2*ya2)/(kA^4 - 2*kA^2*kB^2 + kB^4 -
          2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) - (Y2^3*ya2)/
         (kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4), 0,
       (4*kA*kB*muA*Y2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) - (2*kA*kB*Y2*ya2)/(kA^4 - 2*kA^2*kB^2 + kB^4 -
          2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4), 0,
       ((-I)*kA^3)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 +
          Y2^4) + (I*kA*kB^2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) - ((2*I)*kA^3*muA)/(kA^4 - 2*kA^2*kB^2 + kB^4 -
          2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) + ((2*I)*kA*kB^2*muA)/
         (kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) -
        ((2*I)*kA^3*muB)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) + ((2*I)*kA*kB^2*muB)/(kA^4 - 2*kA^2*kB^2 +
          kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) +
        (I*kA*Y2^2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 +
          Y2^4) + ((2*I)*kA*muA*Y2^2)/(kA^4 - 2*kA^2*kB^2 + kB^4 -
          2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) + ((2*I)*kA*muB*Y2^2)/
         (kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) +
        (I*kA^3*ya2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 +
          Y2^4) - (I*kA*kB^2*ya2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) - (I*kA*Y2^2*ya2)/(kA^4 - 2*kA^2*kB^2 + kB^4 -
          2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4), 0,
       (I*kA^2*kB)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 +
          Y2^4) - (I*kB^3)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) + (I*kB*Y2^2)/(kA^4 - 2*kA^2*kB^2 + kB^4 -
          2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4), 0,
       (kA^2*Y2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 +
          Y2^4) + (kB^2*Y2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) - Y2^3/(kA^4 - 2*kA^2*kB^2 + kB^4 -
          2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4)}, {0, 0, 0, 0, 0, 0, 0, 0,
       ((-I)*kA^3)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 +
          Y2^4) + (I*kA*kB^2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) + (I*kA*Y2^2)/(kA^4 - 2*kA^2*kB^2 + kB^4 -
          2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) - (I*kA^3*ya2)/
         (kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) +
        (I*kA*kB^2*ya2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) + (I*kA*Y2^2*ya2)/(kA^4 - 2*kA^2*kB^2 + kB^4 -
          2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4), 0,
       (4*kA*kB*muB*Y2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) - (2*kA*kB*Y2*ya2)/(kA^4 - 2*kA^2*kB^2 + kB^4 -
          2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4), 0,
       (-2*kA^2*muA*Y2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) - (2*kB^2*muA*Y2)/(kA^4 - 2*kA^2*kB^2 + kB^4 -
          2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) + (2*muA*Y2^3)/
         (kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) +
        (kA^2*Y2*ya2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) + (kB^2*Y2*ya2)/(kA^4 - 2*kA^2*kB^2 + kB^4 -
          2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) - (Y2^3*ya2)/
         (kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4), 0,
       (I*kA^2*kB)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 +
          Y2^4) - (I*kB^3)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) + ((2*I)*kA^2*kB*muA)/(kA^4 - 2*kA^2*kB^2 +
          kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) - ((2*I)*kB^3*muA)/
         (kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) +
        ((2*I)*kA^2*kB*muB)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) - ((2*I)*kB^3*muB)/(kA^4 - 2*kA^2*kB^2 + kB^4 -
          2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) + (I*kB*Y2^2)/
         (kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) +
        ((2*I)*kB*muA*Y2^2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) + ((2*I)*kB*muB*Y2^2)/(kA^4 - 2*kA^2*kB^2 +
          kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) - (I*kA^2*kB*ya2)/
         (kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) +
        (I*kB^3*ya2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 +
          Y2^4) - (I*kB*Y2^2*ya2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4), 0, ((-I)*kA^3)/(kA^4 - 2*kA^2*kB^2 + kB^4 -
          2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) + (I*kA*kB^2)/
         (kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) +
        (I*kA*Y2^2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 +
          Y2^4), 0, (-2*kA*kB*Y2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
         2*kB^2*Y2^2 + Y2^4), 0}, {0, 0, 0, 0, 0, 0, 0, 0, 0,
       ((-I)*kA^3)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 +
          Y2^4) + (I*kA*kB^2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) + (I*kA*Y2^2)/(kA^4 - 2*kA^2*kB^2 + kB^4 -
          2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) - (I*kA^3*ya2)/
         (kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) +
        (I*kA*kB^2*ya2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) + (I*kA*Y2^2*ya2)/(kA^4 - 2*kA^2*kB^2 + kB^4 -
          2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4), 0,
       (4*kA*kB*muB*Y2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) - (2*kA*kB*Y2*ya2)/(kA^4 - 2*kA^2*kB^2 + kB^4 -
          2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4), 0,
       (-2*kA^2*muA*Y2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) - (2*kB^2*muA*Y2)/(kA^4 - 2*kA^2*kB^2 + kB^4 -
          2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) + (2*muA*Y2^3)/
         (kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) +
        (kA^2*Y2*ya2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) + (kB^2*Y2*ya2)/(kA^4 - 2*kA^2*kB^2 + kB^4 -
          2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) - (Y2^3*ya2)/
         (kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4), 0,
       (I*kA^2*kB)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 +
          Y2^4) - (I*kB^3)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) + ((2*I)*kA^2*kB*muA)/(kA^4 - 2*kA^2*kB^2 +
          kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) - ((2*I)*kB^3*muA)/
         (kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) +
        ((2*I)*kA^2*kB*muB)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) - ((2*I)*kB^3*muB)/(kA^4 - 2*kA^2*kB^2 + kB^4 -
          2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) + (I*kB*Y2^2)/
         (kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) +
        ((2*I)*kB*muA*Y2^2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) + ((2*I)*kB*muB*Y2^2)/(kA^4 - 2*kA^2*kB^2 +
          kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) - (I*kA^2*kB*ya2)/
         (kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) +
        (I*kB^3*ya2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 +
          Y2^4) - (I*kB*Y2^2*ya2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4), 0, ((-I)*kA^3)/(kA^4 - 2*kA^2*kB^2 + kB^4 -
          2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) + (I*kA*kB^2)/
         (kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) +
        (I*kA*Y2^2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 +
          Y2^4), 0, (-2*kA*kB*Y2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
         2*kB^2*Y2^2 + Y2^4)}, {0, 0, 0, 0, 0, 0, 0, 0,
       (-2*kA^3*kB*Y2)/(-kA^6 + 2*kA^4*kB^2 - kA^2*kB^4 + 2*kA^4*Y2^2 +
          2*kA^2*kB^2*Y2^2 - kA^2*Y2^4) - (2*kA^3*kB*Y2*ya2)/
         (-kA^6 + 2*kA^4*kB^2 - kA^2*kB^4 + 2*kA^4*Y2^2 + 2*kA^2*kB^2*Y2^2 -
          kA^2*Y2^4), 0, ((-2*I)*kA^5*muB)/(-kA^6 + 2*kA^4*kB^2 - kA^2*kB^4 +
          2*kA^4*Y2^2 + 2*kA^2*kB^2*Y2^2 - kA^2*Y2^4) +
        ((2*I)*kA^3*kB^2*muB)/(-kA^6 + 2*kA^4*kB^2 - kA^2*kB^4 +
          2*kA^4*Y2^2 + 2*kA^2*kB^2*Y2^2 - kA^2*Y2^4) +
        ((2*I)*kA^3*muB*Y2^2)/(-kA^6 + 2*kA^4*kB^2 - kA^2*kB^4 +
          2*kA^4*Y2^2 + 2*kA^2*kB^2*Y2^2 - kA^2*Y2^4) +
        (I*kA^5*ya2)/(-kA^6 + 2*kA^4*kB^2 - kA^2*kB^4 + 2*kA^4*Y2^2 +
          2*kA^2*kB^2*Y2^2 - kA^2*Y2^4) - (I*kA^3*kB^2*ya2)/
         (-kA^6 + 2*kA^4*kB^2 - kA^2*kB^4 + 2*kA^4*Y2^2 + 2*kA^2*kB^2*Y2^2 -
          kA^2*Y2^4) - (I*kA^3*Y2^2*ya2)/(-kA^6 + 2*kA^4*kB^2 - kA^2*kB^4 +
          2*kA^4*Y2^2 + 2*kA^2*kB^2*Y2^2 - kA^2*Y2^4), 0,
       ((2*I)*kA^4*kB*muA)/(-kA^6 + 2*kA^4*kB^2 - kA^2*kB^4 + 2*kA^4*Y2^2 +
          2*kA^2*kB^2*Y2^2 - kA^2*Y2^4) - ((2*I)*kA^2*kB^3*muA)/
         (-kA^6 + 2*kA^4*kB^2 - kA^2*kB^4 + 2*kA^4*Y2^2 + 2*kA^2*kB^2*Y2^2 -
          kA^2*Y2^4) + ((2*I)*kA^2*kB*muA*Y2^2)/(-kA^6 + 2*kA^4*kB^2 -
          kA^2*kB^4 + 2*kA^4*Y2^2 + 2*kA^2*kB^2*Y2^2 - kA^2*Y2^4) -
        (I*kA^4*kB*ya2)/(-kA^6 + 2*kA^4*kB^2 - kA^2*kB^4 + 2*kA^4*Y2^2 +
          2*kA^2*kB^2*Y2^2 - kA^2*Y2^4) + (I*kA^2*kB^3*ya2)/
         (-kA^6 + 2*kA^4*kB^2 - kA^2*kB^4 + 2*kA^4*Y2^2 + 2*kA^2*kB^2*Y2^2 -
          kA^2*Y2^4) - (I*kA^2*kB*Y2^2*ya2)/(-kA^6 + 2*kA^4*kB^2 -
          kA^2*kB^4 + 2*kA^4*Y2^2 + 2*kA^2*kB^2*Y2^2 - kA^2*Y2^4), 0,
       (kA^4*Y2)/(-kA^6 + 2*kA^4*kB^2 - kA^2*kB^4 + 2*kA^4*Y2^2 +
          2*kA^2*kB^2*Y2^2 - kA^2*Y2^4) + (kA^2*kB^2*Y2)/
         (-kA^6 + 2*kA^4*kB^2 - kA^2*kB^4 + 2*kA^4*Y2^2 + 2*kA^2*kB^2*Y2^2 -
          kA^2*Y2^4) + (2*kA^4*muA*Y2)/(-kA^6 + 2*kA^4*kB^2 - kA^2*kB^4 +
          2*kA^4*Y2^2 + 2*kA^2*kB^2*Y2^2 - kA^2*Y2^4) +
        (2*kA^2*kB^2*muA*Y2)/(-kA^6 + 2*kA^4*kB^2 - kA^2*kB^4 + 2*kA^4*Y2^2 +
          2*kA^2*kB^2*Y2^2 - kA^2*Y2^4) + (2*kA^4*muB*Y2)/
         (-kA^6 + 2*kA^4*kB^2 - kA^2*kB^4 + 2*kA^4*Y2^2 + 2*kA^2*kB^2*Y2^2 -
          kA^2*Y2^4) + (2*kA^2*kB^2*muB*Y2)/(-kA^6 + 2*kA^4*kB^2 -
          kA^2*kB^4 + 2*kA^4*Y2^2 + 2*kA^2*kB^2*Y2^2 - kA^2*Y2^4) -
        (kA^2*Y2^3)/(-kA^6 + 2*kA^4*kB^2 - kA^2*kB^4 + 2*kA^4*Y2^2 +
          2*kA^2*kB^2*Y2^2 - kA^2*Y2^4) - (2*kA^2*muA*Y2^3)/
         (-kA^6 + 2*kA^4*kB^2 - kA^2*kB^4 + 2*kA^4*Y2^2 + 2*kA^2*kB^2*Y2^2 -
          kA^2*Y2^4) - (2*kA^2*muB*Y2^3)/(-kA^6 + 2*kA^4*kB^2 - kA^2*kB^4 +
          2*kA^4*Y2^2 + 2*kA^2*kB^2*Y2^2 - kA^2*Y2^4) -
        (kA^4*Y2*ya2)/(-kA^6 + 2*kA^4*kB^2 - kA^2*kB^4 + 2*kA^4*Y2^2 +
          2*kA^2*kB^2*Y2^2 - kA^2*Y2^4) - (kA^2*kB^2*Y2*ya2)/
         (-kA^6 + 2*kA^4*kB^2 - kA^2*kB^4 + 2*kA^4*Y2^2 + 2*kA^2*kB^2*Y2^2 -
          kA^2*Y2^4) + (kA^2*Y2^3*ya2)/(-kA^6 + 2*kA^4*kB^2 - kA^2*kB^4 +
          2*kA^4*Y2^2 + 2*kA^2*kB^2*Y2^2 - kA^2*Y2^4), 0,
       (-2*kA^3*kB*Y2)/(-kA^6 + 2*kA^4*kB^2 - kA^2*kB^4 + 2*kA^4*Y2^2 +
         2*kA^2*kB^2*Y2^2 - kA^2*Y2^4), 0,
       (I*kA^5)/(-kA^6 + 2*kA^4*kB^2 - kA^2*kB^4 + 2*kA^4*Y2^2 +
          2*kA^2*kB^2*Y2^2 - kA^2*Y2^4) - (I*kA^3*kB^2)/
         (-kA^6 + 2*kA^4*kB^2 - kA^2*kB^4 + 2*kA^4*Y2^2 + 2*kA^2*kB^2*Y2^2 -
          kA^2*Y2^4) - (I*kA^3*Y2^2)/(-kA^6 + 2*kA^4*kB^2 - kA^2*kB^4 +
          2*kA^4*Y2^2 + 2*kA^2*kB^2*Y2^2 - kA^2*Y2^4), 0},
      {0, 0, 0, 0, 0, 0, 0, 0, 0, (-2*kA^3*kB*Y2)/(-kA^6 + 2*kA^4*kB^2 -
          kA^2*kB^4 + 2*kA^4*Y2^2 + 2*kA^2*kB^2*Y2^2 - kA^2*Y2^4) -
        (2*kA^3*kB*Y2*ya2)/(-kA^6 + 2*kA^4*kB^2 - kA^2*kB^4 + 2*kA^4*Y2^2 +
          2*kA^2*kB^2*Y2^2 - kA^2*Y2^4), 0,
       ((-2*I)*kA^5*muB)/(-kA^6 + 2*kA^4*kB^2 - kA^2*kB^4 + 2*kA^4*Y2^2 +
          2*kA^2*kB^2*Y2^2 - kA^2*Y2^4) + ((2*I)*kA^3*kB^2*muB)/
         (-kA^6 + 2*kA^4*kB^2 - kA^2*kB^4 + 2*kA^4*Y2^2 + 2*kA^2*kB^2*Y2^2 -
          kA^2*Y2^4) + ((2*I)*kA^3*muB*Y2^2)/(-kA^6 + 2*kA^4*kB^2 -
          kA^2*kB^4 + 2*kA^4*Y2^2 + 2*kA^2*kB^2*Y2^2 - kA^2*Y2^4) +
        (I*kA^5*ya2)/(-kA^6 + 2*kA^4*kB^2 - kA^2*kB^4 + 2*kA^4*Y2^2 +
          2*kA^2*kB^2*Y2^2 - kA^2*Y2^4) - (I*kA^3*kB^2*ya2)/
         (-kA^6 + 2*kA^4*kB^2 - kA^2*kB^4 + 2*kA^4*Y2^2 + 2*kA^2*kB^2*Y2^2 -
          kA^2*Y2^4) - (I*kA^3*Y2^2*ya2)/(-kA^6 + 2*kA^4*kB^2 - kA^2*kB^4 +
          2*kA^4*Y2^2 + 2*kA^2*kB^2*Y2^2 - kA^2*Y2^4), 0,
       ((2*I)*kA^4*kB*muA)/(-kA^6 + 2*kA^4*kB^2 - kA^2*kB^4 + 2*kA^4*Y2^2 +
          2*kA^2*kB^2*Y2^2 - kA^2*Y2^4) - ((2*I)*kA^2*kB^3*muA)/
         (-kA^6 + 2*kA^4*kB^2 - kA^2*kB^4 + 2*kA^4*Y2^2 + 2*kA^2*kB^2*Y2^2 -
          kA^2*Y2^4) + ((2*I)*kA^2*kB*muA*Y2^2)/(-kA^6 + 2*kA^4*kB^2 -
          kA^2*kB^4 + 2*kA^4*Y2^2 + 2*kA^2*kB^2*Y2^2 - kA^2*Y2^4) -
        (I*kA^4*kB*ya2)/(-kA^6 + 2*kA^4*kB^2 - kA^2*kB^4 + 2*kA^4*Y2^2 +
          2*kA^2*kB^2*Y2^2 - kA^2*Y2^4) + (I*kA^2*kB^3*ya2)/
         (-kA^6 + 2*kA^4*kB^2 - kA^2*kB^4 + 2*kA^4*Y2^2 + 2*kA^2*kB^2*Y2^2 -
          kA^2*Y2^4) - (I*kA^2*kB*Y2^2*ya2)/(-kA^6 + 2*kA^4*kB^2 -
          kA^2*kB^4 + 2*kA^4*Y2^2 + 2*kA^2*kB^2*Y2^2 - kA^2*Y2^4), 0,
       (kA^4*Y2)/(-kA^6 + 2*kA^4*kB^2 - kA^2*kB^4 + 2*kA^4*Y2^2 +
          2*kA^2*kB^2*Y2^2 - kA^2*Y2^4) + (kA^2*kB^2*Y2)/
         (-kA^6 + 2*kA^4*kB^2 - kA^2*kB^4 + 2*kA^4*Y2^2 + 2*kA^2*kB^2*Y2^2 -
          kA^2*Y2^4) + (2*kA^4*muA*Y2)/(-kA^6 + 2*kA^4*kB^2 - kA^2*kB^4 +
          2*kA^4*Y2^2 + 2*kA^2*kB^2*Y2^2 - kA^2*Y2^4) +
        (2*kA^2*kB^2*muA*Y2)/(-kA^6 + 2*kA^4*kB^2 - kA^2*kB^4 + 2*kA^4*Y2^2 +
          2*kA^2*kB^2*Y2^2 - kA^2*Y2^4) + (2*kA^4*muB*Y2)/
         (-kA^6 + 2*kA^4*kB^2 - kA^2*kB^4 + 2*kA^4*Y2^2 + 2*kA^2*kB^2*Y2^2 -
          kA^2*Y2^4) + (2*kA^2*kB^2*muB*Y2)/(-kA^6 + 2*kA^4*kB^2 -
          kA^2*kB^4 + 2*kA^4*Y2^2 + 2*kA^2*kB^2*Y2^2 - kA^2*Y2^4) -
        (kA^2*Y2^3)/(-kA^6 + 2*kA^4*kB^2 - kA^2*kB^4 + 2*kA^4*Y2^2 +
          2*kA^2*kB^2*Y2^2 - kA^2*Y2^4) - (2*kA^2*muA*Y2^3)/
         (-kA^6 + 2*kA^4*kB^2 - kA^2*kB^4 + 2*kA^4*Y2^2 + 2*kA^2*kB^2*Y2^2 -
          kA^2*Y2^4) - (2*kA^2*muB*Y2^3)/(-kA^6 + 2*kA^4*kB^2 - kA^2*kB^4 +
          2*kA^4*Y2^2 + 2*kA^2*kB^2*Y2^2 - kA^2*Y2^4) -
        (kA^4*Y2*ya2)/(-kA^6 + 2*kA^4*kB^2 - kA^2*kB^4 + 2*kA^4*Y2^2 +
          2*kA^2*kB^2*Y2^2 - kA^2*Y2^4) - (kA^2*kB^2*Y2*ya2)/
         (-kA^6 + 2*kA^4*kB^2 - kA^2*kB^4 + 2*kA^4*Y2^2 + 2*kA^2*kB^2*Y2^2 -
          kA^2*Y2^4) + (kA^2*Y2^3*ya2)/(-kA^6 + 2*kA^4*kB^2 - kA^2*kB^4 +
          2*kA^4*Y2^2 + 2*kA^2*kB^2*Y2^2 - kA^2*Y2^4), 0,
       (-2*kA^3*kB*Y2)/(-kA^6 + 2*kA^4*kB^2 - kA^2*kB^4 + 2*kA^4*Y2^2 +
         2*kA^2*kB^2*Y2^2 - kA^2*Y2^4), 0,
       (I*kA^5)/(-kA^6 + 2*kA^4*kB^2 - kA^2*kB^4 + 2*kA^4*Y2^2 +
          2*kA^2*kB^2*Y2^2 - kA^2*Y2^4) - (I*kA^3*kB^2)/
         (-kA^6 + 2*kA^4*kB^2 - kA^2*kB^4 + 2*kA^4*Y2^2 + 2*kA^2*kB^2*Y2^2 -
          kA^2*Y2^4) - (I*kA^3*Y2^2)/(-kA^6 + 2*kA^4*kB^2 - kA^2*kB^4 +
          2*kA^4*Y2^2 + 2*kA^2*kB^2*Y2^2 - kA^2*Y2^4)},
      {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
       Y1/(kB^2 - Y1^2 - 2*Y1*Y2 - Y2^2) - (2*muA*Y1)/(kB^2 - Y1^2 -
          2*Y1*Y2 - Y2^2) + Y2/(kB^2 - Y1^2 - 2*Y1*Y2 - Y2^2) -
        (2*muA*Y2)/(kB^2 - Y1^2 - 2*Y1*Y2 - Y2^2) +
        (Y1*ya1)/(kB^2 - Y1^2 - 2*Y1*Y2 - Y2^2) +
        (Y2*ya1)/(kB^2 - Y1^2 - 2*Y1*Y2 - Y2^2) +
        (Y1*ya2)/(kB^2 - Y1^2 - 2*Y1*Y2 - Y2^2) +
        (Y2*ya2)/(kB^2 - Y1^2 - 2*Y1*Y2 - Y2^2), 0,
       ((-2*I)*kB*muA)/(kB^2 - Y1^2 - 2*Y1*Y2 - Y2^2) -
        ((2*I)*kB*muB)/(kB^2 - Y1^2 - 2*Y1*Y2 - Y2^2) +
        (I*kB*ya1)/(kB^2 - Y1^2 - 2*Y1*Y2 - Y2^2) +
        (I*kB*ya2)/(kB^2 - Y1^2 - 2*Y1*Y2 - Y2^2), 0},
      {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
       Y1/(kB^2 - Y1^2 - 2*Y1*Y2 - Y2^2) - (2*muA*Y1)/(kB^2 - Y1^2 -
          2*Y1*Y2 - Y2^2) + Y2/(kB^2 - Y1^2 - 2*Y1*Y2 - Y2^2) -
        (2*muA*Y2)/(kB^2 - Y1^2 - 2*Y1*Y2 - Y2^2) +
        (Y1*ya1)/(kB^2 - Y1^2 - 2*Y1*Y2 - Y2^2) +
        (Y2*ya1)/(kB^2 - Y1^2 - 2*Y1*Y2 - Y2^2) +
        (Y1*ya2)/(kB^2 - Y1^2 - 2*Y1*Y2 - Y2^2) +
        (Y2*ya2)/(kB^2 - Y1^2 - 2*Y1*Y2 - Y2^2), 0,
       ((-2*I)*kB*muA)/(kB^2 - Y1^2 - 2*Y1*Y2 - Y2^2) -
        ((2*I)*kB*muB)/(kB^2 - Y1^2 - 2*Y1*Y2 - Y2^2) +
        (I*kB*ya1)/(kB^2 - Y1^2 - 2*Y1*Y2 - Y2^2) +
        (I*kB*ya2)/(kB^2 - Y1^2 - 2*Y1*Y2 - Y2^2)}, {0, 0, 0, 0, 0, 0, 0, 0,
       0, 0, 0, 0, 0, 0, 0, 0, (I*kB)/(-kB^2 - ((-I)*Y1 - I*Y2)^2) -
        ((2*I)*kB*muA)/(-kB^2 - ((-I)*Y1 - I*Y2)^2) +
        (I*kB*ya1)/(-kB^2 - ((-I)*Y1 - I*Y2)^2) +
        (I*kB*ya2)/(-kB^2 - ((-I)*Y1 - I*Y2)^2), 0,
       (2*muA*Y1)/(-kB^2 - ((-I)*Y1 - I*Y2)^2) + (2*muB*Y1)/
         (-kB^2 - ((-I)*Y1 - I*Y2)^2) + (2*muA*Y2)/
         (-kB^2 - ((-I)*Y1 - I*Y2)^2) + (2*muB*Y2)/
         (-kB^2 - ((-I)*Y1 - I*Y2)^2) - (Y1*ya1)/
         (-kB^2 - ((-I)*Y1 - I*Y2)^2) - (Y2*ya1)/
         (-kB^2 - ((-I)*Y1 - I*Y2)^2) - (Y1*ya2)/
         (-kB^2 - ((-I)*Y1 - I*Y2)^2) - (Y2*ya2)/
         (-kB^2 - ((-I)*Y1 - I*Y2)^2), 0}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
       0, 0, 0, 0, 0, 0, (I*kB)/(-kB^2 - ((-I)*Y1 - I*Y2)^2) -
        ((2*I)*kB*muA)/(-kB^2 - ((-I)*Y1 - I*Y2)^2) +
        (I*kB*ya1)/(-kB^2 - ((-I)*Y1 - I*Y2)^2) +
        (I*kB*ya2)/(-kB^2 - ((-I)*Y1 - I*Y2)^2), 0,
       (2*muA*Y1)/(-kB^2 - ((-I)*Y1 - I*Y2)^2) + (2*muB*Y1)/
         (-kB^2 - ((-I)*Y1 - I*Y2)^2) + (2*muA*Y2)/
         (-kB^2 - ((-I)*Y1 - I*Y2)^2) + (2*muB*Y2)/
         (-kB^2 - ((-I)*Y1 - I*Y2)^2) - (Y1*ya1)/
         (-kB^2 - ((-I)*Y1 - I*Y2)^2) - (Y2*ya1)/
         (-kB^2 - ((-I)*Y1 - I*Y2)^2) - (Y1*ya2)/
         (-kB^2 - ((-I)*Y1 - I*Y2)^2) - (Y2*ya2)/
         (-kB^2 - ((-I)*Y1 - I*Y2)^2)}}, "expected" ->
     {{1/(4*(-kA - kB - Y2)) + 1/(4*(kA - kB - Y2)) + 1/(4*(-kA + kB - Y2)) +
        1/(4*(kA + kB - Y2)) + ya2/(4*(-kA - kB - Y2)) +
        ya2/(4*(kA - kB - Y2)) + ya2/(4*(-kA + kB - Y2)) +
        ya2/(4*(kA + kB - Y2)), 0, ((I/2)*muB)/(-kA - kB - Y2) +
        ((I/2)*muB)/(kA - kB - Y2) - ((I/2)*muB)/(-kA + kB - Y2) -
        ((I/2)*muB)/(kA + kB - Y2) - ((I/4)*ya2)/(-kA - kB - Y2) -
        ((I/4)*ya2)/(kA - kB - Y2) + ((I/4)*ya2)/(-kA + kB - Y2) +
        ((I/4)*ya2)/(kA + kB - Y2), 0, ((I/2)*muA)/(-kA - kB - Y2) -
        ((I/2)*muA)/(kA - kB - Y2) + ((I/2)*muA)/(-kA + kB - Y2) -
        ((I/2)*muA)/(kA + kB - Y2) - ((I/4)*ya2)/(-kA - kB - Y2) +
        ((I/4)*ya2)/(kA - kB - Y2) - ((I/4)*ya2)/(-kA + kB - Y2) +
        ((I/4)*ya2)/(kA + kB - Y2), 0, 1/(4*(-kA - kB - Y2)) +
        muA/(2*(-kA - kB - Y2)) + muB/(2*(-kA - kB - Y2)) -
        1/(4*(kA - kB - Y2)) - muA/(2*(kA - kB - Y2)) -
        muB/(2*(kA - kB - Y2)) - 1/(4*(-kA + kB - Y2)) -
        muA/(2*(-kA + kB - Y2)) - muB/(2*(-kA + kB - Y2)) +
        1/(4*(kA + kB - Y2)) + muA/(2*(kA + kB - Y2)) +
        muB/(2*(kA + kB - Y2)) - ya2/(4*(-kA - kB - Y2)) +
        ya2/(4*(kA - kB - Y2)) + ya2/(4*(-kA + kB - Y2)) -
        ya2/(4*(kA + kB - Y2)), 0, 0, 0, 0, 0, 0, 0, 0, 0,
       (I/4)/(-kA - kB - Y2) - (I/4)/(kA - kB - Y2) + (I/4)/(-kA + kB - Y2) -
        (I/4)/(kA + kB - Y2), 0, 1/(4*(-kA - kB - Y2)) -
        1/(4*(kA - kB - Y2)) - 1/(4*(-kA + kB - Y2)) + 1/(4*(kA + kB - Y2)),
       0}, {0, 1/(4*(-kA - kB - Y2)) + 1/(4*(kA - kB - Y2)) +
        1/(4*(-kA + kB - Y2)) + 1/(4*(kA + kB - Y2)) +
        ya2/(4*(-kA - kB - Y2)) + ya2/(4*(kA - kB - Y2)) +
        ya2/(4*(-kA + kB - Y2)) + ya2/(4*(kA + kB - Y2)), 0,
       ((I/2)*muB)/(-kA - kB - Y2) + ((I/2)*muB)/(kA - kB - Y2) -
        ((I/2)*muB)/(-kA + kB - Y2) - ((I/2)*muB)/(kA + kB - Y2) -
        ((I/4)*ya2)/(-kA - kB - Y2) - ((I/4)*ya2)/(kA - kB - Y2) +
        ((I/4)*ya2)/(-kA + kB - Y2) + ((I/4)*ya2)/(kA + kB - Y2), 0,
       ((I/2)*muA)/(-kA - kB - Y2) - ((I/2)*muA)/(kA - kB - Y2) +
        ((I/2)*muA)/(-kA + kB - Y2) - ((I/2)*muA)/(kA + kB - Y2) -
        ((I/4)*ya2)/(-kA - kB - Y2) + ((I/4)*ya2)/(kA - kB - Y2) -
        ((I/4)*ya2)/(-kA + kB - Y2) + ((I/4)*ya2)/(kA + kB - Y2), 0,
       1/(4*(-kA - kB - Y2)) + muA/(2*(-kA - kB - Y2)) +
        muB/(2*(-kA - kB - Y2)) - 1/(4*(kA - kB - Y2)) -
        muA/(2*(kA - kB - Y2)) - muB/(2*(kA - kB - Y2)) -
        1/(4*(-kA + kB - Y2)) - muA/(2*(-kA + kB - Y2)) -
        muB/(2*(-kA + kB - Y2)) + 1/(4*(kA + kB - Y2)) +
        muA/(2*(kA + kB - Y2)) + muB/(2*(kA + kB - Y2)) -
        ya2/(4*(-kA - kB - Y2)) + ya2/(4*(kA - kB - Y2)) +
        ya2/(4*(-kA + kB - Y2)) - ya2/(4*(kA + kB - Y2)), 0, 0, 0, 0, 0, 0,
       0, 0, 0, (I/4)/(-kA - kB - Y2) - (I/4)/(kA - kB - Y2) +
        (I/4)/(-kA + kB - Y2) - (I/4)/(kA + kB - Y2), 0,
       1/(4*(-kA - kB - Y2)) - 1/(4*(kA - kB - Y2)) - 1/(4*(-kA + kB - Y2)) +
        1/(4*(kA + kB - Y2))}, {(I/4)/(-kA - kB - Y2) +
        (I/4)/(kA - kB - Y2) - (I/4)/(-kA + kB - Y2) - (I/4)/(kA + kB - Y2) +
        ((I/4)*ya2)/(-kA - kB - Y2) + ((I/4)*ya2)/(kA - kB - Y2) -
        ((I/4)*ya2)/(-kA + kB - Y2) - ((I/4)*ya2)/(kA + kB - Y2), 0,
       -1/2*muB/(-kA - kB - Y2) - muB/(2*(kA - kB - Y2)) -
        muB/(2*(-kA + kB - Y2)) - muB/(2*(kA + kB - Y2)) +
        ya2/(4*(-kA - kB - Y2)) + ya2/(4*(kA - kB - Y2)) +
        ya2/(4*(-kA + kB - Y2)) + ya2/(4*(kA + kB - Y2)), 0,
       -1/2*muA/(-kA - kB - Y2) + muA/(2*(kA - kB - Y2)) +
        muA/(2*(-kA + kB - Y2)) - muA/(2*(kA + kB - Y2)) +
        ya2/(4*(-kA - kB - Y2)) - ya2/(4*(kA - kB - Y2)) -
        ya2/(4*(-kA + kB - Y2)) + ya2/(4*(kA + kB - Y2)), 0,
       (I/4)/(-kA - kB - Y2) + ((I/2)*muA)/(-kA - kB - Y2) +
        ((I/2)*muB)/(-kA - kB - Y2) - (I/4)/(kA - kB - Y2) -
        ((I/2)*muA)/(kA - kB - Y2) - ((I/2)*muB)/(kA - kB - Y2) +
        (I/4)/(-kA + kB - Y2) + ((I/2)*muA)/(-kA + kB - Y2) +
        ((I/2)*muB)/(-kA + kB - Y2) - (I/4)/(kA + kB - Y2) -
        ((I/2)*muA)/(kA + kB - Y2) - ((I/2)*muB)/(kA + kB - Y2) -
        ((I/4)*ya2)/(-kA - kB - Y2) + ((I/4)*ya2)/(kA - kB - Y2) -
        ((I/4)*ya2)/(-kA + kB - Y2) + ((I/4)*ya2)/(kA + kB - Y2), 0, 0, 0, 0,
       0, 0, 0, 0, 0, -1/4*1/(-kA - kB - Y2) + 1/(4*(kA - kB - Y2)) +
        1/(4*(-kA + kB - Y2)) - 1/(4*(kA + kB - Y2)), 0,
       (I/4)/(-kA - kB - Y2) - (I/4)/(kA - kB - Y2) + (I/4)/(-kA + kB - Y2) -
        (I/4)/(kA + kB - Y2), 0}, {0, (I/4)/(-kA - kB - Y2) +
        (I/4)/(kA - kB - Y2) - (I/4)/(-kA + kB - Y2) - (I/4)/(kA + kB - Y2) +
        ((I/4)*ya2)/(-kA - kB - Y2) + ((I/4)*ya2)/(kA - kB - Y2) -
        ((I/4)*ya2)/(-kA + kB - Y2) - ((I/4)*ya2)/(kA + kB - Y2), 0,
       -1/2*muB/(-kA - kB - Y2) - muB/(2*(kA - kB - Y2)) -
        muB/(2*(-kA + kB - Y2)) - muB/(2*(kA + kB - Y2)) +
        ya2/(4*(-kA - kB - Y2)) + ya2/(4*(kA - kB - Y2)) +
        ya2/(4*(-kA + kB - Y2)) + ya2/(4*(kA + kB - Y2)), 0,
       -1/2*muA/(-kA - kB - Y2) + muA/(2*(kA - kB - Y2)) +
        muA/(2*(-kA + kB - Y2)) - muA/(2*(kA + kB - Y2)) +
        ya2/(4*(-kA - kB - Y2)) - ya2/(4*(kA - kB - Y2)) -
        ya2/(4*(-kA + kB - Y2)) + ya2/(4*(kA + kB - Y2)), 0,
       (I/4)/(-kA - kB - Y2) + ((I/2)*muA)/(-kA - kB - Y2) +
        ((I/2)*muB)/(-kA - kB - Y2) - (I/4)/(kA - kB - Y2) -
        ((I/2)*muA)/(kA - kB - Y2) - ((I/2)*muB)/(kA - kB - Y2) +
        (I/4)/(-kA + kB - Y2) + ((I/2)*muA)/(-kA + kB - Y2) +
        ((I/2)*muB)/(-kA + kB - Y2) - (I/4)/(kA + kB - Y2) -
        ((I/2)*muA)/(kA + kB - Y2) - ((I/2)*muB)/(kA + kB - Y2) -
        ((I/4)*ya2)/(-kA - kB - Y2) + ((I/4)*ya2)/(kA - kB - Y2) -
        ((I/4)*ya2)/(-kA + kB - Y2) + ((I/4)*ya2)/(kA + kB - Y2), 0, 0, 0, 0,
       0, 0, 0, 0, 0, -1/4*1/(-kA - kB - Y2) + 1/(4*(kA - kB - Y2)) +
        1/(4*(-kA + kB - Y2)) - 1/(4*(kA + kB - Y2)), 0,
       (I/4)/(-kA - kB - Y2) - (I/4)/(kA - kB - Y2) + (I/4)/(-kA + kB - Y2) -
        (I/4)/(kA + kB - Y2)}, {(I/4)/(-kA - kB - Y2) -
        (I/4)/(kA - kB - Y2) + (I/4)/(-kA + kB - Y2) - (I/4)/(kA + kB - Y2) +
        ((I/4)*ya2)/(-kA - kB - Y2) - ((I/4)*ya2)/(kA - kB - Y2) +
        ((I/4)*ya2)/(-kA + kB - Y2) - ((I/4)*ya2)/(kA + kB - Y2), 0,
       -1/2*muB/(-kA - kB - Y2) + muB/(2*(kA - kB - Y2)) +
        muB/(2*(-kA + kB - Y2)) - muB/(2*(kA + kB - Y2)) +
        ya2/(4*(-kA - kB - Y2)) - ya2/(4*(kA - kB - Y2)) -
        ya2/(4*(-kA + kB - Y2)) + ya2/(4*(kA + kB - Y2)), 0,
       -1/2*muA/(-kA - kB - Y2) - muA/(2*(kA - kB - Y2)) -
        muA/(2*(-kA + kB - Y2)) - muA/(2*(kA + kB - Y2)) +
        ya2/(4*(-kA - kB - Y2)) + ya2/(4*(kA - kB - Y2)) +
        ya2/(4*(-kA + kB - Y2)) + ya2/(4*(kA + kB - Y2)), 0,
       (I/4)/(-kA - kB - Y2) + ((I/2)*muA)/(-kA - kB - Y2) +
        ((I/2)*muB)/(-kA - kB - Y2) + (I/4)/(kA - kB - Y2) +
        ((I/2)*muA)/(kA - kB - Y2) + ((I/2)*muB)/(kA - kB - Y2) -
        (I/4)/(-kA + kB - Y2) - ((I/2)*muA)/(-kA + kB - Y2) -
        ((I/2)*muB)/(-kA + kB - Y2) - (I/4)/(kA + kB - Y2) -
        ((I/2)*muA)/(kA + kB - Y2) - ((I/2)*muB)/(kA + kB - Y2) -
        ((I/4)*ya2)/(-kA - kB - Y2) - ((I/4)*ya2)/(kA - kB - Y2) +
        ((I/4)*ya2)/(-kA + kB - Y2) + ((I/4)*ya2)/(kA + kB - Y2), 0, 0, 0, 0,
       0, 0, 0, 0, 0, -1/4*1/(-kA - kB - Y2) - 1/(4*(kA - kB - Y2)) -
        1/(4*(-kA + kB - Y2)) - 1/(4*(kA + kB - Y2)), 0,
       (I/4)/(-kA - kB - Y2) + (I/4)/(kA - kB - Y2) - (I/4)/(-kA + kB - Y2) -
        (I/4)/(kA + kB - Y2), 0}, {0, (I/4)/(-kA - kB - Y2) -
        (I/4)/(kA - kB - Y2) + (I/4)/(-kA + kB - Y2) - (I/4)/(kA + kB - Y2) +
        ((I/4)*ya2)/(-kA - kB - Y2) - ((I/4)*ya2)/(kA - kB - Y2) +
        ((I/4)*ya2)/(-kA + kB - Y2) - ((I/4)*ya2)/(kA + kB - Y2), 0,
       -1/2*muB/(-kA - kB - Y2) + muB/(2*(kA - kB - Y2)) +
        muB/(2*(-kA + kB - Y2)) - muB/(2*(kA + kB - Y2)) +
        ya2/(4*(-kA - kB - Y2)) - ya2/(4*(kA - kB - Y2)) -
        ya2/(4*(-kA + kB - Y2)) + ya2/(4*(kA + kB - Y2)), 0,
       -1/2*muA/(-kA - kB - Y2) - muA/(2*(kA - kB - Y2)) -
        muA/(2*(-kA + kB - Y2)) - muA/(2*(kA + kB - Y2)) +
        ya2/(4*(-kA - kB - Y2)) + ya2/(4*(kA - kB - Y2)) +
        ya2/(4*(-kA + kB - Y2)) + ya2/(4*(kA + kB - Y2)), 0,
       (I/4)/(-kA - kB - Y2) + ((I/2)*muA)/(-kA - kB - Y2) +
        ((I/2)*muB)/(-kA - kB - Y2) + (I/4)/(kA - kB - Y2) +
        ((I/2)*muA)/(kA - kB - Y2) + ((I/2)*muB)/(kA - kB - Y2) -
        (I/4)/(-kA + kB - Y2) - ((I/2)*muA)/(-kA + kB - Y2) -
        ((I/2)*muB)/(-kA + kB - Y2) - (I/4)/(kA + kB - Y2) -
        ((I/2)*muA)/(kA + kB - Y2) - ((I/2)*muB)/(kA + kB - Y2) -
        ((I/4)*ya2)/(-kA - kB - Y2) - ((I/4)*ya2)/(kA - kB - Y2) +
        ((I/4)*ya2)/(-kA + kB - Y2) + ((I/4)*ya2)/(kA + kB - Y2), 0, 0, 0, 0,
       0, 0, 0, 0, 0, -1/4*1/(-kA - kB - Y2) - 1/(4*(kA - kB - Y2)) -
        1/(4*(-kA + kB - Y2)) - 1/(4*(kA + kB - Y2)), 0,
       (I/4)/(-kA - kB - Y2) + (I/4)/(kA - kB - Y2) - (I/4)/(-kA + kB - Y2) -
        (I/4)/(kA + kB - Y2)}, {-1/4*1/(-kA - kB - Y2) +
        1/(4*(kA - kB - Y2)) + 1/(4*(-kA + kB - Y2)) - 1/(4*(kA + kB - Y2)) -
        ya2/(4*(-kA - kB - Y2)) + ya2/(4*(kA - kB - Y2)) +
        ya2/(4*(-kA + kB - Y2)) - ya2/(4*(kA + kB - Y2)), 0,
       ((-1/2*I)*muB)/(-kA - kB - Y2) + ((I/2)*muB)/(kA - kB - Y2) -
        ((I/2)*muB)/(-kA + kB - Y2) + ((I/2)*muB)/(kA + kB - Y2) +
        ((I/4)*ya2)/(-kA - kB - Y2) - ((I/4)*ya2)/(kA - kB - Y2) +
        ((I/4)*ya2)/(-kA + kB - Y2) - ((I/4)*ya2)/(kA + kB - Y2), 0,
       ((-1/2*I)*muA)/(-kA - kB - Y2) - ((I/2)*muA)/(kA - kB - Y2) +
        ((I/2)*muA)/(-kA + kB - Y2) + ((I/2)*muA)/(kA + kB - Y2) +
        ((I/4)*ya2)/(-kA - kB - Y2) + ((I/4)*ya2)/(kA - kB - Y2) -
        ((I/4)*ya2)/(-kA + kB - Y2) - ((I/4)*ya2)/(kA + kB - Y2), 0,
       -1/4*1/(-kA - kB - Y2) - muA/(2*(-kA - kB - Y2)) -
        muB/(2*(-kA - kB - Y2)) - 1/(4*(kA - kB - Y2)) -
        muA/(2*(kA - kB - Y2)) - muB/(2*(kA - kB - Y2)) -
        1/(4*(-kA + kB - Y2)) - muA/(2*(-kA + kB - Y2)) -
        muB/(2*(-kA + kB - Y2)) - 1/(4*(kA + kB - Y2)) -
        muA/(2*(kA + kB - Y2)) - muB/(2*(kA + kB - Y2)) +
        ya2/(4*(-kA - kB - Y2)) + ya2/(4*(kA - kB - Y2)) +
        ya2/(4*(-kA + kB - Y2)) + ya2/(4*(kA + kB - Y2)), 0, 0, 0, 0, 0, 0,
       0, 0, 0, (-1/4*I)/(-kA - kB - Y2) - (I/4)/(kA - kB - Y2) +
        (I/4)/(-kA + kB - Y2) + (I/4)/(kA + kB - Y2), 0,
       -1/4*1/(-kA - kB - Y2) - 1/(4*(kA - kB - Y2)) -
        1/(4*(-kA + kB - Y2)) - 1/(4*(kA + kB - Y2)), 0},
      {0, -1/4*1/(-kA - kB - Y2) + 1/(4*(kA - kB - Y2)) +
        1/(4*(-kA + kB - Y2)) - 1/(4*(kA + kB - Y2)) -
        ya2/(4*(-kA - kB - Y2)) + ya2/(4*(kA - kB - Y2)) +
        ya2/(4*(-kA + kB - Y2)) - ya2/(4*(kA + kB - Y2)), 0,
       ((-1/2*I)*muB)/(-kA - kB - Y2) + ((I/2)*muB)/(kA - kB - Y2) -
        ((I/2)*muB)/(-kA + kB - Y2) + ((I/2)*muB)/(kA + kB - Y2) +
        ((I/4)*ya2)/(-kA - kB - Y2) - ((I/4)*ya2)/(kA - kB - Y2) +
        ((I/4)*ya2)/(-kA + kB - Y2) - ((I/4)*ya2)/(kA + kB - Y2), 0,
       ((-1/2*I)*muA)/(-kA - kB - Y2) - ((I/2)*muA)/(kA - kB - Y2) +
        ((I/2)*muA)/(-kA + kB - Y2) + ((I/2)*muA)/(kA + kB - Y2) +
        ((I/4)*ya2)/(-kA - kB - Y2) + ((I/4)*ya2)/(kA - kB - Y2) -
        ((I/4)*ya2)/(-kA + kB - Y2) - ((I/4)*ya2)/(kA + kB - Y2), 0,
       -1/4*1/(-kA - kB - Y2) - muA/(2*(-kA - kB - Y2)) -
        muB/(2*(-kA - kB - Y2)) - 1/(4*(kA - kB - Y2)) -
        muA/(2*(kA - kB - Y2)) - muB/(2*(kA - kB - Y2)) -
        1/(4*(-kA + kB - Y2)) - muA/(2*(-kA + kB - Y2)) -
        muB/(2*(-kA + kB - Y2)) - 1/(4*(kA + kB - Y2)) -
        muA/(2*(kA + kB - Y2)) - muB/(2*(kA + kB - Y2)) +
        ya2/(4*(-kA - kB - Y2)) + ya2/(4*(kA - kB - Y2)) +
        ya2/(4*(-kA + kB - Y2)) + ya2/(4*(kA + kB - Y2)), 0, 0, 0, 0, 0, 0,
       0, 0, 0, (-1/4*I)/(-kA - kB - Y2) - (I/4)/(kA - kB - Y2) +
        (I/4)/(-kA + kB - Y2) + (I/4)/(kA + kB - Y2), 0,
       -1/4*1/(-kA - kB - Y2) - 1/(4*(kA - kB - Y2)) -
        1/(4*(-kA + kB - Y2)) - 1/(4*(kA + kB - Y2))},
      {0, 0, 0, 0, 0, 0, 0, 0, 1/(4*(-kA - kB - Y2)) + 1/(4*(kA - kB - Y2)) +
        1/(4*(-kA + kB - Y2)) + 1/(4*(kA + kB - Y2)) +
        ya2/(4*(-kA - kB - Y2)) + ya2/(4*(kA - kB - Y2)) +
        ya2/(4*(-kA + kB - Y2)) + ya2/(4*(kA + kB - Y2)), 0,
       ((I/2)*muB)/(-kA - kB - Y2) + ((I/2)*muB)/(kA - kB - Y2) -
        ((I/2)*muB)/(-kA + kB - Y2) - ((I/2)*muB)/(kA + kB - Y2) -
        ((I/4)*ya2)/(-kA - kB - Y2) - ((I/4)*ya2)/(kA - kB - Y2) +
        ((I/4)*ya2)/(-kA + kB - Y2) + ((I/4)*ya2)/(kA + kB - Y2), 0,
       ((I/2)*muA)/(-kA - kB - Y2) - ((I/2)*muA)/(kA - kB - Y2) +
        ((I/2)*muA)/(-kA + kB - Y2) - ((I/2)*muA)/(kA + kB - Y2) -
        ((I/4)*ya2)/(-kA - kB - Y2) + ((I/4)*ya2)/(kA - kB - Y2) -
        ((I/4)*ya2)/(-kA + kB - Y2) + ((I/4)*ya2)/(kA + kB - Y2), 0,
       1/(4*(-kA - kB - Y2)) + muA/(2*(-kA - kB - Y2)) +
        muB/(2*(-kA - kB - Y2)) - 1/(4*(kA - kB - Y2)) -
        muA/(2*(kA - kB - Y2)) - muB/(2*(kA - kB - Y2)) -
        1/(4*(-kA + kB - Y2)) - muA/(2*(-kA + kB - Y2)) -
        muB/(2*(-kA + kB - Y2)) + 1/(4*(kA + kB - Y2)) +
        muA/(2*(kA + kB - Y2)) + muB/(2*(kA + kB - Y2)) -
        ya2/(4*(-kA - kB - Y2)) + ya2/(4*(kA - kB - Y2)) +
        ya2/(4*(-kA + kB - Y2)) - ya2/(4*(kA + kB - Y2)), 0,
       1/(4*(-kA - kB - Y2)) + 1/(4*(kA - kB - Y2)) + 1/(4*(-kA + kB - Y2)) +
        1/(4*(kA + kB - Y2)), 0, (-1/4*I)/(-kA - kB - Y2) -
        (I/4)/(kA - kB - Y2) + (I/4)/(-kA + kB - Y2) + (I/4)/(kA + kB - Y2),
       0}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 1/(4*(-kA - kB - Y2)) +
        1/(4*(kA - kB - Y2)) + 1/(4*(-kA + kB - Y2)) + 1/(4*(kA + kB - Y2)) +
        ya2/(4*(-kA - kB - Y2)) + ya2/(4*(kA - kB - Y2)) +
        ya2/(4*(-kA + kB - Y2)) + ya2/(4*(kA + kB - Y2)), 0,
       ((I/2)*muB)/(-kA - kB - Y2) + ((I/2)*muB)/(kA - kB - Y2) -
        ((I/2)*muB)/(-kA + kB - Y2) - ((I/2)*muB)/(kA + kB - Y2) -
        ((I/4)*ya2)/(-kA - kB - Y2) - ((I/4)*ya2)/(kA - kB - Y2) +
        ((I/4)*ya2)/(-kA + kB - Y2) + ((I/4)*ya2)/(kA + kB - Y2), 0,
       ((I/2)*muA)/(-kA - kB - Y2) - ((I/2)*muA)/(kA - kB - Y2) +
        ((I/2)*muA)/(-kA + kB - Y2) - ((I/2)*muA)/(kA + kB - Y2) -
        ((I/4)*ya2)/(-kA - kB - Y2) + ((I/4)*ya2)/(kA - kB - Y2) -
        ((I/4)*ya2)/(-kA + kB - Y2) + ((I/4)*ya2)/(kA + kB - Y2), 0,
       1/(4*(-kA - kB - Y2)) + muA/(2*(-kA - kB - Y2)) +
        muB/(2*(-kA - kB - Y2)) - 1/(4*(kA - kB - Y2)) -
        muA/(2*(kA - kB - Y2)) - muB/(2*(kA - kB - Y2)) -
        1/(4*(-kA + kB - Y2)) - muA/(2*(-kA + kB - Y2)) -
        muB/(2*(-kA + kB - Y2)) + 1/(4*(kA + kB - Y2)) +
        muA/(2*(kA + kB - Y2)) + muB/(2*(kA + kB - Y2)) -
        ya2/(4*(-kA - kB - Y2)) + ya2/(4*(kA - kB - Y2)) +
        ya2/(4*(-kA + kB - Y2)) - ya2/(4*(kA + kB - Y2)), 0,
       1/(4*(-kA - kB - Y2)) + 1/(4*(kA - kB - Y2)) + 1/(4*(-kA + kB - Y2)) +
        1/(4*(kA + kB - Y2)), 0, (-1/4*I)/(-kA - kB - Y2) -
        (I/4)/(kA - kB - Y2) + (I/4)/(-kA + kB - Y2) + (I/4)/(kA + kB - Y2)},
      {0, 0, 0, 0, 0, 0, 0, 0, (I/4)/(-kA - kB - Y2) + (I/4)/(kA - kB - Y2) -
        (I/4)/(-kA + kB - Y2) - (I/4)/(kA + kB - Y2) +
        ((I/4)*ya2)/(-kA - kB - Y2) + ((I/4)*ya2)/(kA - kB - Y2) -
        ((I/4)*ya2)/(-kA + kB - Y2) - ((I/4)*ya2)/(kA + kB - Y2), 0,
       -1/2*muB/(-kA - kB - Y2) - muB/(2*(kA - kB - Y2)) -
        muB/(2*(-kA + kB - Y2)) - muB/(2*(kA + kB - Y2)) +
        ya2/(4*(-kA - kB - Y2)) + ya2/(4*(kA - kB - Y2)) +
        ya2/(4*(-kA + kB - Y2)) + ya2/(4*(kA + kB - Y2)), 0,
       -1/2*muA/(-kA - kB - Y2) + muA/(2*(kA - kB - Y2)) +
        muA/(2*(-kA + kB - Y2)) - muA/(2*(kA + kB - Y2)) +
        ya2/(4*(-kA - kB - Y2)) - ya2/(4*(kA - kB - Y2)) -
        ya2/(4*(-kA + kB - Y2)) + ya2/(4*(kA + kB - Y2)), 0,
       (I/4)/(-kA - kB - Y2) + ((I/2)*muA)/(-kA - kB - Y2) +
        ((I/2)*muB)/(-kA - kB - Y2) - (I/4)/(kA - kB - Y2) -
        ((I/2)*muA)/(kA - kB - Y2) - ((I/2)*muB)/(kA - kB - Y2) +
        (I/4)/(-kA + kB - Y2) + ((I/2)*muA)/(-kA + kB - Y2) +
        ((I/2)*muB)/(-kA + kB - Y2) - (I/4)/(kA + kB - Y2) -
        ((I/2)*muA)/(kA + kB - Y2) - ((I/2)*muB)/(kA + kB - Y2) -
        ((I/4)*ya2)/(-kA - kB - Y2) + ((I/4)*ya2)/(kA - kB - Y2) -
        ((I/4)*ya2)/(-kA + kB - Y2) + ((I/4)*ya2)/(kA + kB - Y2), 0,
       (I/4)/(-kA - kB - Y2) + (I/4)/(kA - kB - Y2) - (I/4)/(-kA + kB - Y2) -
        (I/4)/(kA + kB - Y2), 0, 1/(4*(-kA - kB - Y2)) +
        1/(4*(kA - kB - Y2)) + 1/(4*(-kA + kB - Y2)) + 1/(4*(kA + kB - Y2)),
       0}, {0, 0, 0, 0, 0, 0, 0, 0, 0, (I/4)/(-kA - kB - Y2) +
        (I/4)/(kA - kB - Y2) - (I/4)/(-kA + kB - Y2) - (I/4)/(kA + kB - Y2) +
        ((I/4)*ya2)/(-kA - kB - Y2) + ((I/4)*ya2)/(kA - kB - Y2) -
        ((I/4)*ya2)/(-kA + kB - Y2) - ((I/4)*ya2)/(kA + kB - Y2), 0,
       -1/2*muB/(-kA - kB - Y2) - muB/(2*(kA - kB - Y2)) -
        muB/(2*(-kA + kB - Y2)) - muB/(2*(kA + kB - Y2)) +
        ya2/(4*(-kA - kB - Y2)) + ya2/(4*(kA - kB - Y2)) +
        ya2/(4*(-kA + kB - Y2)) + ya2/(4*(kA + kB - Y2)), 0,
       -1/2*muA/(-kA - kB - Y2) + muA/(2*(kA - kB - Y2)) +
        muA/(2*(-kA + kB - Y2)) - muA/(2*(kA + kB - Y2)) +
        ya2/(4*(-kA - kB - Y2)) - ya2/(4*(kA - kB - Y2)) -
        ya2/(4*(-kA + kB - Y2)) + ya2/(4*(kA + kB - Y2)), 0,
       (I/4)/(-kA - kB - Y2) + ((I/2)*muA)/(-kA - kB - Y2) +
        ((I/2)*muB)/(-kA - kB - Y2) - (I/4)/(kA - kB - Y2) -
        ((I/2)*muA)/(kA - kB - Y2) - ((I/2)*muB)/(kA - kB - Y2) +
        (I/4)/(-kA + kB - Y2) + ((I/2)*muA)/(-kA + kB - Y2) +
        ((I/2)*muB)/(-kA + kB - Y2) - (I/4)/(kA + kB - Y2) -
        ((I/2)*muA)/(kA + kB - Y2) - ((I/2)*muB)/(kA + kB - Y2) -
        ((I/4)*ya2)/(-kA - kB - Y2) + ((I/4)*ya2)/(kA - kB - Y2) -
        ((I/4)*ya2)/(-kA + kB - Y2) + ((I/4)*ya2)/(kA + kB - Y2), 0,
       (I/4)/(-kA - kB - Y2) + (I/4)/(kA - kB - Y2) - (I/4)/(-kA + kB - Y2) -
        (I/4)/(kA + kB - Y2), 0, 1/(4*(-kA - kB - Y2)) +
        1/(4*(kA - kB - Y2)) + 1/(4*(-kA + kB - Y2)) + 1/(4*(kA + kB - Y2))},
      {0, 0, 0, 0, 0, 0, 0, 0, (I/4)/(-kA - kB - Y2) - (I/4)/(kA - kB - Y2) +
        (I/4)/(-kA + kB - Y2) - (I/4)/(kA + kB - Y2) +
        ((I/4)*ya2)/(-kA - kB - Y2) - ((I/4)*ya2)/(kA - kB - Y2) +
        ((I/4)*ya2)/(-kA + kB - Y2) - ((I/4)*ya2)/(kA + kB - Y2), 0,
       -1/2*muB/(-kA - kB - Y2) + muB/(2*(kA - kB - Y2)) +
        muB/(2*(-kA + kB - Y2)) - muB/(2*(kA + kB - Y2)) +
        ya2/(4*(-kA - kB - Y2)) - ya2/(4*(kA - kB - Y2)) -
        ya2/(4*(-kA + kB - Y2)) + ya2/(4*(kA + kB - Y2)), 0,
       -1/2*muA/(-kA - kB - Y2) - muA/(2*(kA - kB - Y2)) -
        muA/(2*(-kA + kB - Y2)) - muA/(2*(kA + kB - Y2)) +
        ya2/(4*(-kA - kB - Y2)) + ya2/(4*(kA - kB - Y2)) +
        ya2/(4*(-kA + kB - Y2)) + ya2/(4*(kA + kB - Y2)), 0,
       (I/4)/(-kA - kB - Y2) + ((I/2)*muA)/(-kA - kB - Y2) +
        ((I/2)*muB)/(-kA - kB - Y2) + (I/4)/(kA - kB - Y2) +
        ((I/2)*muA)/(kA - kB - Y2) + ((I/2)*muB)/(kA - kB - Y2) -
        (I/4)/(-kA + kB - Y2) - ((I/2)*muA)/(-kA + kB - Y2) -
        ((I/2)*muB)/(-kA + kB - Y2) - (I/4)/(kA + kB - Y2) -
        ((I/2)*muA)/(kA + kB - Y2) - ((I/2)*muB)/(kA + kB - Y2) -
        ((I/4)*ya2)/(-kA - kB - Y2) - ((I/4)*ya2)/(kA - kB - Y2) +
        ((I/4)*ya2)/(-kA + kB - Y2) + ((I/4)*ya2)/(kA + kB - Y2), 0,
       (I/4)/(-kA - kB - Y2) - (I/4)/(kA - kB - Y2) + (I/4)/(-kA + kB - Y2) -
        (I/4)/(kA + kB - Y2), 0, 1/(4*(-kA - kB - Y2)) -
        1/(4*(kA - kB - Y2)) - 1/(4*(-kA + kB - Y2)) + 1/(4*(kA + kB - Y2)),
       0}, {0, 0, 0, 0, 0, 0, 0, 0, 0, (I/4)/(-kA - kB - Y2) -
        (I/4)/(kA - kB - Y2) + (I/4)/(-kA + kB - Y2) - (I/4)/(kA + kB - Y2) +
        ((I/4)*ya2)/(-kA - kB - Y2) - ((I/4)*ya2)/(kA - kB - Y2) +
        ((I/4)*ya2)/(-kA + kB - Y2) - ((I/4)*ya2)/(kA + kB - Y2), 0,
       -1/2*muB/(-kA - kB - Y2) + muB/(2*(kA - kB - Y2)) +
        muB/(2*(-kA + kB - Y2)) - muB/(2*(kA + kB - Y2)) +
        ya2/(4*(-kA - kB - Y2)) - ya2/(4*(kA - kB - Y2)) -
        ya2/(4*(-kA + kB - Y2)) + ya2/(4*(kA + kB - Y2)), 0,
       -1/2*muA/(-kA - kB - Y2) - muA/(2*(kA - kB - Y2)) -
        muA/(2*(-kA + kB - Y2)) - muA/(2*(kA + kB - Y2)) +
        ya2/(4*(-kA - kB - Y2)) + ya2/(4*(kA - kB - Y2)) +
        ya2/(4*(-kA + kB - Y2)) + ya2/(4*(kA + kB - Y2)), 0,
       (I/4)/(-kA - kB - Y2) + ((I/2)*muA)/(-kA - kB - Y2) +
        ((I/2)*muB)/(-kA - kB - Y2) + (I/4)/(kA - kB - Y2) +
        ((I/2)*muA)/(kA - kB - Y2) + ((I/2)*muB)/(kA - kB - Y2) -
        (I/4)/(-kA + kB - Y2) - ((I/2)*muA)/(-kA + kB - Y2) -
        ((I/2)*muB)/(-kA + kB - Y2) - (I/4)/(kA + kB - Y2) -
        ((I/2)*muA)/(kA + kB - Y2) - ((I/2)*muB)/(kA + kB - Y2) -
        ((I/4)*ya2)/(-kA - kB - Y2) - ((I/4)*ya2)/(kA - kB - Y2) +
        ((I/4)*ya2)/(-kA + kB - Y2) + ((I/4)*ya2)/(kA + kB - Y2), 0,
       (I/4)/(-kA - kB - Y2) - (I/4)/(kA - kB - Y2) + (I/4)/(-kA + kB - Y2) -
        (I/4)/(kA + kB - Y2), 0, 1/(4*(-kA - kB - Y2)) -
        1/(4*(kA - kB - Y2)) - 1/(4*(-kA + kB - Y2)) + 1/(4*(kA + kB - Y2))},
      {0, 0, 0, 0, 0, 0, 0, 0, -1/4*1/(-kA - kB - Y2) +
        1/(4*(kA - kB - Y2)) + 1/(4*(-kA + kB - Y2)) - 1/(4*(kA + kB - Y2)) -
        ya2/(4*(-kA - kB - Y2)) + ya2/(4*(kA - kB - Y2)) +
        ya2/(4*(-kA + kB - Y2)) - ya2/(4*(kA + kB - Y2)), 0,
       ((-1/2*I)*muB)/(-kA - kB - Y2) + ((I/2)*muB)/(kA - kB - Y2) -
        ((I/2)*muB)/(-kA + kB - Y2) + ((I/2)*muB)/(kA + kB - Y2) +
        ((I/4)*ya2)/(-kA - kB - Y2) - ((I/4)*ya2)/(kA - kB - Y2) +
        ((I/4)*ya2)/(-kA + kB - Y2) - ((I/4)*ya2)/(kA + kB - Y2), 0,
       ((-1/2*I)*muA)/(-kA - kB - Y2) - ((I/2)*muA)/(kA - kB - Y2) +
        ((I/2)*muA)/(-kA + kB - Y2) + ((I/2)*muA)/(kA + kB - Y2) +
        ((I/4)*ya2)/(-kA - kB - Y2) + ((I/4)*ya2)/(kA - kB - Y2) -
        ((I/4)*ya2)/(-kA + kB - Y2) - ((I/4)*ya2)/(kA + kB - Y2), 0,
       -1/4*1/(-kA - kB - Y2) - muA/(2*(-kA - kB - Y2)) -
        muB/(2*(-kA - kB - Y2)) - 1/(4*(kA - kB - Y2)) -
        muA/(2*(kA - kB - Y2)) - muB/(2*(kA - kB - Y2)) -
        1/(4*(-kA + kB - Y2)) - muA/(2*(-kA + kB - Y2)) -
        muB/(2*(-kA + kB - Y2)) - 1/(4*(kA + kB - Y2)) -
        muA/(2*(kA + kB - Y2)) - muB/(2*(kA + kB - Y2)) +
        ya2/(4*(-kA - kB - Y2)) + ya2/(4*(kA - kB - Y2)) +
        ya2/(4*(-kA + kB - Y2)) + ya2/(4*(kA + kB - Y2)), 0,
       -1/4*1/(-kA - kB - Y2) + 1/(4*(kA - kB - Y2)) +
        1/(4*(-kA + kB - Y2)) - 1/(4*(kA + kB - Y2)), 0,
       (I/4)/(-kA - kB - Y2) - (I/4)/(kA - kB - Y2) + (I/4)/(-kA + kB - Y2) -
        (I/4)/(kA + kB - Y2), 0}, {0, 0, 0, 0, 0, 0, 0, 0, 0,
       -1/4*1/(-kA - kB - Y2) + 1/(4*(kA - kB - Y2)) +
        1/(4*(-kA + kB - Y2)) - 1/(4*(kA + kB - Y2)) -
        ya2/(4*(-kA - kB - Y2)) + ya2/(4*(kA - kB - Y2)) +
        ya2/(4*(-kA + kB - Y2)) - ya2/(4*(kA + kB - Y2)), 0,
       ((-1/2*I)*muB)/(-kA - kB - Y2) + ((I/2)*muB)/(kA - kB - Y2) -
        ((I/2)*muB)/(-kA + kB - Y2) + ((I/2)*muB)/(kA + kB - Y2) +
        ((I/4)*ya2)/(-kA - kB - Y2) - ((I/4)*ya2)/(kA - kB - Y2) +
        ((I/4)*ya2)/(-kA + kB - Y2) - ((I/4)*ya2)/(kA + kB - Y2), 0,
       ((-1/2*I)*muA)/(-kA - kB - Y2) - ((I/2)*muA)/(kA - kB - Y2) +
        ((I/2)*muA)/(-kA + kB - Y2) + ((I/2)*muA)/(kA + kB - Y2) +
        ((I/4)*ya2)/(-kA - kB - Y2) + ((I/4)*ya2)/(kA - kB - Y2) -
        ((I/4)*ya2)/(-kA + kB - Y2) - ((I/4)*ya2)/(kA + kB - Y2), 0,
       -1/4*1/(-kA - kB - Y2) - muA/(2*(-kA - kB - Y2)) -
        muB/(2*(-kA - kB - Y2)) - 1/(4*(kA - kB - Y2)) -
        muA/(2*(kA - kB - Y2)) - muB/(2*(kA - kB - Y2)) -
        1/(4*(-kA + kB - Y2)) - muA/(2*(-kA + kB - Y2)) -
        muB/(2*(-kA + kB - Y2)) - 1/(4*(kA + kB - Y2)) -
        muA/(2*(kA + kB - Y2)) - muB/(2*(kA + kB - Y2)) +
        ya2/(4*(-kA - kB - Y2)) + ya2/(4*(kA - kB - Y2)) +
        ya2/(4*(-kA + kB - Y2)) + ya2/(4*(kA + kB - Y2)), 0,
       -1/4*1/(-kA - kB - Y2) + 1/(4*(kA - kB - Y2)) +
        1/(4*(-kA + kB - Y2)) - 1/(4*(kA + kB - Y2)), 0,
       (I/4)/(-kA - kB - Y2) - (I/4)/(kA - kB - Y2) + (I/4)/(-kA + kB - Y2) -
        (I/4)/(kA + kB - Y2)}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
       0, 1/(2*(-kB - Y1 - Y2)) - muA/(-kB - Y1 - Y2) +
        1/(2*(kB - Y1 - Y2)) - muA/(kB - Y1 - Y2) + ya1/(2*(-kB - Y1 - Y2)) +
        ya1/(2*(kB - Y1 - Y2)) + ya2/(2*(-kB - Y1 - Y2)) +
        ya2/(2*(kB - Y1 - Y2)), 0, (I*muA)/(-kB - Y1 - Y2) +
        (I*muB)/(-kB - Y1 - Y2) - (I*muA)/(kB - Y1 - Y2) -
        (I*muB)/(kB - Y1 - Y2) - ((I/2)*ya1)/(-kB - Y1 - Y2) +
        ((I/2)*ya1)/(kB - Y1 - Y2) - ((I/2)*ya2)/(-kB - Y1 - Y2) +
        ((I/2)*ya2)/(kB - Y1 - Y2), 0}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
       0, 0, 0, 0, 0, 1/(2*(-kB - Y1 - Y2)) - muA/(-kB - Y1 - Y2) +
        1/(2*(kB - Y1 - Y2)) - muA/(kB - Y1 - Y2) + ya1/(2*(-kB - Y1 - Y2)) +
        ya1/(2*(kB - Y1 - Y2)) + ya2/(2*(-kB - Y1 - Y2)) +
        ya2/(2*(kB - Y1 - Y2)), 0, (I*muA)/(-kB - Y1 - Y2) +
        (I*muB)/(-kB - Y1 - Y2) - (I*muA)/(kB - Y1 - Y2) -
        (I*muB)/(kB - Y1 - Y2) - ((I/2)*ya1)/(-kB - Y1 - Y2) +
        ((I/2)*ya1)/(kB - Y1 - Y2) - ((I/2)*ya2)/(-kB - Y1 - Y2) +
        ((I/2)*ya2)/(kB - Y1 - Y2)}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
       0, 0, 0, (I/2)/(-kB - Y1 - Y2) - (I*muA)/(-kB - Y1 - Y2) -
        (I/2)/(kB - Y1 - Y2) + (I*muA)/(kB - Y1 - Y2) +
        ((I/2)*ya1)/(-kB - Y1 - Y2) - ((I/2)*ya1)/(kB - Y1 - Y2) +
        ((I/2)*ya2)/(-kB - Y1 - Y2) - ((I/2)*ya2)/(kB - Y1 - Y2), 0,
       -(muA/(-kB - Y1 - Y2)) - muB/(-kB - Y1 - Y2) - muA/(kB - Y1 - Y2) -
        muB/(kB - Y1 - Y2) + ya1/(2*(-kB - Y1 - Y2)) +
        ya1/(2*(kB - Y1 - Y2)) + ya2/(2*(-kB - Y1 - Y2)) +
        ya2/(2*(kB - Y1 - Y2)), 0}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
       0, 0, 0, 0, (I/2)/(-kB - Y1 - Y2) - (I*muA)/(-kB - Y1 - Y2) -
        (I/2)/(kB - Y1 - Y2) + (I*muA)/(kB - Y1 - Y2) +
        ((I/2)*ya1)/(-kB - Y1 - Y2) - ((I/2)*ya1)/(kB - Y1 - Y2) +
        ((I/2)*ya2)/(-kB - Y1 - Y2) - ((I/2)*ya2)/(kB - Y1 - Y2), 0,
       -(muA/(-kB - Y1 - Y2)) - muB/(-kB - Y1 - Y2) - muA/(kB - Y1 - Y2) -
        muB/(kB - Y1 - Y2) + ya1/(2*(-kB - Y1 - Y2)) +
        ya1/(2*(kB - Y1 - Y2)) + ya2/(2*(-kB - Y1 - Y2)) +
        ya2/(2*(kB - Y1 - Y2))}}, "difference" -> 0|>,
   <|"group" -> "pureTime", "name" -> "three naive dlog Y3",
    "passed" -> True, "actual" ->
     {{Y3/(kB^2 - Y3^2) + (Y3*ya3)/(kB^2 - Y3^2),
       ((2*I)*kB*muB)/(kB^2 - Y3^2) - (I*kB*ya3)/(kB^2 - Y3^2), 0, 0, 0, 0,
       0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
      {(I*kB)/(kB^2 - Y3^2) + (I*kB*ya3)/(kB^2 - Y3^2),
       (-2*muB*Y3)/(kB^2 - Y3^2) + (Y3*ya3)/(kB^2 - Y3^2), 0, 0, 0, 0, 0, 0,
       0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
      {0, 0, Y3/(kB^2 - Y3^2) + (Y3*ya3)/(kB^2 - Y3^2),
       ((2*I)*kB*muB)/(kB^2 - Y3^2) - (I*kB*ya3)/(kB^2 - Y3^2), 0, 0, 0, 0,
       0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
      {0, 0, (I*kB)/(kB^2 - Y3^2) + (I*kB*ya3)/(kB^2 - Y3^2),
       (-2*muB*Y3)/(kB^2 - Y3^2) + (Y3*ya3)/(kB^2 - Y3^2), 0, 0, 0, 0, 0, 0,
       0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, Y3/(kB^2 - Y3^2) +
        (Y3*ya3)/(kB^2 - Y3^2), ((2*I)*kB*muB)/(kB^2 - Y3^2) -
        (I*kB*ya3)/(kB^2 - Y3^2), 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
      {0, 0, 0, 0, (I*kB)/(kB^2 - Y3^2) + (I*kB*ya3)/(kB^2 - Y3^2),
       (-2*muB*Y3)/(kB^2 - Y3^2) + (Y3*ya3)/(kB^2 - Y3^2), 0, 0, 0, 0, 0, 0,
       0, 0, 0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, Y3/(kB^2 - Y3^2) +
        (Y3*ya3)/(kB^2 - Y3^2), ((2*I)*kB*muB)/(kB^2 - Y3^2) -
        (I*kB*ya3)/(kB^2 - Y3^2), 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
      {0, 0, 0, 0, 0, 0, (I*kB)/(kB^2 - Y3^2) + (I*kB*ya3)/(kB^2 - Y3^2),
       (-2*muB*Y3)/(kB^2 - Y3^2) + (Y3*ya3)/(kB^2 - Y3^2), 0, 0, 0, 0, 0, 0,
       0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0, 0, Y3/(kB^2 - Y3^2) +
        (Y3*ya3)/(kB^2 - Y3^2), ((2*I)*kB*muB)/(kB^2 - Y3^2) -
        (I*kB*ya3)/(kB^2 - Y3^2), 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
      {0, 0, 0, 0, 0, 0, 0, 0, (I*kB)/(kB^2 - Y3^2) +
        (I*kB*ya3)/(kB^2 - Y3^2), (-2*muB*Y3)/(kB^2 - Y3^2) +
        (Y3*ya3)/(kB^2 - Y3^2), 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
      {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, Y3/(kB^2 - Y3^2) +
        (Y3*ya3)/(kB^2 - Y3^2), ((2*I)*kB*muB)/(kB^2 - Y3^2) -
        (I*kB*ya3)/(kB^2 - Y3^2), 0, 0, 0, 0, 0, 0, 0, 0},
      {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, (I*kB)/(kB^2 - Y3^2) +
        (I*kB*ya3)/(kB^2 - Y3^2), (-2*muB*Y3)/(kB^2 - Y3^2) +
        (Y3*ya3)/(kB^2 - Y3^2), 0, 0, 0, 0, 0, 0, 0, 0},
      {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, Y3/(kB^2 - Y3^2) +
        (Y3*ya3)/(kB^2 - Y3^2), ((2*I)*kB*muB)/(kB^2 - Y3^2) -
        (I*kB*ya3)/(kB^2 - Y3^2), 0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0, 0,
       0, 0, 0, 0, (I*kB)/(kB^2 - Y3^2) + (I*kB*ya3)/(kB^2 - Y3^2),
       (-2*muB*Y3)/(kB^2 - Y3^2) + (Y3*ya3)/(kB^2 - Y3^2), 0, 0, 0, 0, 0, 0},
      {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, Y3/(kB^2 - Y3^2) +
        (Y3*ya3)/(kB^2 - Y3^2), ((2*I)*kB*muB)/(kB^2 - Y3^2) -
        (I*kB*ya3)/(kB^2 - Y3^2), 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
       0, 0, 0, 0, (I*kB)/(kB^2 - Y3^2) + (I*kB*ya3)/(kB^2 - Y3^2),
       (-2*muB*Y3)/(kB^2 - Y3^2) + (Y3*ya3)/(kB^2 - Y3^2), 0, 0, 0, 0},
      {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
       Y3/(kB^2 - Y3^2) + (Y3*ya3)/(kB^2 - Y3^2),
       ((2*I)*kB*muB)/(kB^2 - Y3^2) - (I*kB*ya3)/(kB^2 - Y3^2), 0, 0},
      {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
       (I*kB)/(kB^2 - Y3^2) + (I*kB*ya3)/(kB^2 - Y3^2),
       (-2*muB*Y3)/(kB^2 - Y3^2) + (Y3*ya3)/(kB^2 - Y3^2), 0, 0},
      {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
       Y3/(kB^2 - Y3^2) + (Y3*ya3)/(kB^2 - Y3^2),
       ((2*I)*kB*muB)/(kB^2 - Y3^2) - (I*kB*ya3)/(kB^2 - Y3^2)},
      {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
       (I*kB)/(kB^2 - Y3^2) + (I*kB*ya3)/(kB^2 - Y3^2),
       (-2*muB*Y3)/(kB^2 - Y3^2) + (Y3*ya3)/(kB^2 - Y3^2)}},
    "expected" -> {{-1/2*1/(-kB + Y3) - 1/(2*(kB + Y3)) -
        ya3/(2*(-kB + Y3)) - ya3/(2*(kB + Y3)), ((-I)*muB)/(-kB + Y3) +
        (I*muB)/(kB + Y3) + ((I/2)*ya3)/(-kB + Y3) - ((I/2)*ya3)/(kB + Y3),
       0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
      {(-1/2*I)/(-kB + Y3) + (I/2)/(kB + Y3) - ((I/2)*ya3)/(-kB + Y3) +
        ((I/2)*ya3)/(kB + Y3), muB/(-kB + Y3) + muB/(kB + Y3) -
        ya3/(2*(-kB + Y3)) - ya3/(2*(kB + Y3)), 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
       0, 0, 0, 0, 0, 0, 0, 0}, {0, 0, -1/2*1/(-kB + Y3) - 1/(2*(kB + Y3)) -
        ya3/(2*(-kB + Y3)) - ya3/(2*(kB + Y3)), ((-I)*muB)/(-kB + Y3) +
        (I*muB)/(kB + Y3) + ((I/2)*ya3)/(-kB + Y3) - ((I/2)*ya3)/(kB + Y3),
       0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
      {0, 0, (-1/2*I)/(-kB + Y3) + (I/2)/(kB + Y3) - ((I/2)*ya3)/(-kB + Y3) +
        ((I/2)*ya3)/(kB + Y3), muB/(-kB + Y3) + muB/(kB + Y3) -
        ya3/(2*(-kB + Y3)) - ya3/(2*(kB + Y3)), 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
       0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, -1/2*1/(-kB + Y3) - 1/(2*(kB + Y3)) -
        ya3/(2*(-kB + Y3)) - ya3/(2*(kB + Y3)), ((-I)*muB)/(-kB + Y3) +
        (I*muB)/(kB + Y3) + ((I/2)*ya3)/(-kB + Y3) - ((I/2)*ya3)/(kB + Y3),
       0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
      {0, 0, 0, 0, (-1/2*I)/(-kB + Y3) + (I/2)/(kB + Y3) -
        ((I/2)*ya3)/(-kB + Y3) + ((I/2)*ya3)/(kB + Y3),
       muB/(-kB + Y3) + muB/(kB + Y3) - ya3/(2*(-kB + Y3)) -
        ya3/(2*(kB + Y3)), 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
      {0, 0, 0, 0, 0, 0, -1/2*1/(-kB + Y3) - 1/(2*(kB + Y3)) -
        ya3/(2*(-kB + Y3)) - ya3/(2*(kB + Y3)), ((-I)*muB)/(-kB + Y3) +
        (I*muB)/(kB + Y3) + ((I/2)*ya3)/(-kB + Y3) - ((I/2)*ya3)/(kB + Y3),
       0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0,
       (-1/2*I)/(-kB + Y3) + (I/2)/(kB + Y3) - ((I/2)*ya3)/(-kB + Y3) +
        ((I/2)*ya3)/(kB + Y3), muB/(-kB + Y3) + muB/(kB + Y3) -
        ya3/(2*(-kB + Y3)) - ya3/(2*(kB + Y3)), 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
       0, 0}, {0, 0, 0, 0, 0, 0, 0, 0, -1/2*1/(-kB + Y3) - 1/(2*(kB + Y3)) -
        ya3/(2*(-kB + Y3)) - ya3/(2*(kB + Y3)), ((-I)*muB)/(-kB + Y3) +
        (I*muB)/(kB + Y3) + ((I/2)*ya3)/(-kB + Y3) - ((I/2)*ya3)/(kB + Y3),
       0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0, 0,
       (-1/2*I)/(-kB + Y3) + (I/2)/(kB + Y3) - ((I/2)*ya3)/(-kB + Y3) +
        ((I/2)*ya3)/(kB + Y3), muB/(-kB + Y3) + muB/(kB + Y3) -
        ya3/(2*(-kB + Y3)) - ya3/(2*(kB + Y3)), 0, 0, 0, 0, 0, 0, 0, 0, 0,
       0}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, -1/2*1/(-kB + Y3) -
        1/(2*(kB + Y3)) - ya3/(2*(-kB + Y3)) - ya3/(2*(kB + Y3)),
       ((-I)*muB)/(-kB + Y3) + (I*muB)/(kB + Y3) + ((I/2)*ya3)/(-kB + Y3) -
        ((I/2)*ya3)/(kB + Y3), 0, 0, 0, 0, 0, 0, 0, 0},
      {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, (-1/2*I)/(-kB + Y3) + (I/2)/(kB + Y3) -
        ((I/2)*ya3)/(-kB + Y3) + ((I/2)*ya3)/(kB + Y3),
       muB/(-kB + Y3) + muB/(kB + Y3) - ya3/(2*(-kB + Y3)) -
        ya3/(2*(kB + Y3)), 0, 0, 0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0, 0,
       0, 0, 0, 0, -1/2*1/(-kB + Y3) - 1/(2*(kB + Y3)) - ya3/(2*(-kB + Y3)) -
        ya3/(2*(kB + Y3)), ((-I)*muB)/(-kB + Y3) + (I*muB)/(kB + Y3) +
        ((I/2)*ya3)/(-kB + Y3) - ((I/2)*ya3)/(kB + Y3), 0, 0, 0, 0, 0, 0},
      {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, (-1/2*I)/(-kB + Y3) +
        (I/2)/(kB + Y3) - ((I/2)*ya3)/(-kB + Y3) + ((I/2)*ya3)/(kB + Y3),
       muB/(-kB + Y3) + muB/(kB + Y3) - ya3/(2*(-kB + Y3)) -
        ya3/(2*(kB + Y3)), 0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
       0, 0, 0, 0, -1/2*1/(-kB + Y3) - 1/(2*(kB + Y3)) - ya3/(2*(-kB + Y3)) -
        ya3/(2*(kB + Y3)), ((-I)*muB)/(-kB + Y3) + (I*muB)/(kB + Y3) +
        ((I/2)*ya3)/(-kB + Y3) - ((I/2)*ya3)/(kB + Y3), 0, 0, 0, 0},
      {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, (-1/2*I)/(-kB + Y3) +
        (I/2)/(kB + Y3) - ((I/2)*ya3)/(-kB + Y3) + ((I/2)*ya3)/(kB + Y3),
       muB/(-kB + Y3) + muB/(kB + Y3) - ya3/(2*(-kB + Y3)) -
        ya3/(2*(kB + Y3)), 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
       0, 0, 0, 0, -1/2*1/(-kB + Y3) - 1/(2*(kB + Y3)) - ya3/(2*(-kB + Y3)) -
        ya3/(2*(kB + Y3)), ((-I)*muB)/(-kB + Y3) + (I*muB)/(kB + Y3) +
        ((I/2)*ya3)/(-kB + Y3) - ((I/2)*ya3)/(kB + Y3), 0, 0},
      {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
       (-1/2*I)/(-kB + Y3) + (I/2)/(kB + Y3) - ((I/2)*ya3)/(-kB + Y3) +
        ((I/2)*ya3)/(kB + Y3), muB/(-kB + Y3) + muB/(kB + Y3) -
        ya3/(2*(-kB + Y3)) - ya3/(2*(kB + Y3)), 0, 0},
      {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
       -1/2*1/(-kB + Y3) - 1/(2*(kB + Y3)) - ya3/(2*(-kB + Y3)) -
        ya3/(2*(kB + Y3)), ((-I)*muB)/(-kB + Y3) + (I*muB)/(kB + Y3) +
        ((I/2)*ya3)/(-kB + Y3) - ((I/2)*ya3)/(kB + Y3)},
      {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
       (-1/2*I)/(-kB + Y3) + (I/2)/(kB + Y3) - ((I/2)*ya3)/(-kB + Y3) +
        ((I/2)*ya3)/(kB + Y3), muB/(-kB + Y3) + muB/(kB + Y3) -
        ya3/(2*(-kB + Y3)) - ya3/(2*(kB + Y3))}}, "difference" -> 0|>,
   <|"group" -> "pureTime", "name" -> "three naive dlog kA",
    "passed" -> True, "actual" ->
     {{-(kA/(kA^2 - Y1^2)) - kA^3/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) + (kA*kB^2)/(kA^4 - 2*kA^2*kB^2 + kB^4 -
          2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) + (kA*Y2^2)/(kA^4 - 2*kA^2*kB^2 +
          kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) - (kA*ya1)/(kA^2 - Y1^2) -
        (kA^3*ya2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 +
          Y2^4) + (kA*kB^2*ya2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) + (kA*Y2^2*ya2)/(kA^4 - 2*kA^2*kB^2 + kB^4 -
          2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4), 0,
       ((-4*I)*kA*kB*muB*Y2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) + ((2*I)*kA*kB*Y2*ya2)/(kA^4 - 2*kA^2*kB^2 +
          kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4), 0,
       ((2*I)*kA^2*muA*Y2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) + ((2*I)*kB^2*muA*Y2)/(kA^4 - 2*kA^2*kB^2 +
          kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) - ((2*I)*muA*Y2^3)/
         (kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) -
        (I*kA^2*Y2*ya2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) - (I*kB^2*Y2*ya2)/(kA^4 - 2*kA^2*kB^2 + kB^4 -
          2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) + (I*Y2^3*ya2)/
         (kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4), 0,
       (kA^2*kB)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 +
          Y2^4) - kB^3/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) + (2*kA^2*kB*muA)/(kA^4 - 2*kA^2*kB^2 + kB^4 -
          2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) - (2*kB^3*muA)/
         (kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) +
        (2*kA^2*kB*muB)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) - (2*kB^3*muB)/(kA^4 - 2*kA^2*kB^2 + kB^4 -
          2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) + (kB*Y2^2)/(kA^4 - 2*kA^2*kB^2 +
          kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) + (2*kB*muA*Y2^2)/
         (kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) +
        (2*kB*muB*Y2^2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) - (kA^2*kB*ya2)/(kA^4 - 2*kA^2*kB^2 + kB^4 -
          2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) + (kB^3*ya2)/
         (kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) -
        (kB*Y2^2*ya2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4), 0, ((2*I)*muA*Y1)/(kA^2 - Y1^2) -
        (I*Y1*ya1)/(kA^2 - Y1^2), 0, 0, 0, 0, 0, 0, 0,
       (I*Y1)/(kA^2 - Y1^2) + (I*kA^2*Y2)/(kA^4 - 2*kA^2*kB^2 + kB^4 -
          2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) + (I*kB^2*Y2)/
         (kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) -
        (I*Y2^3)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 +
          Y2^4), 0, (kA^2*kB)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) - kB^3/(kA^4 - 2*kA^2*kB^2 + kB^4 -
          2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) + (kB*Y2^2)/(kA^4 - 2*kA^2*kB^2 +
          kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4), 0},
      {0, -(kA/(kA^2 - Y1^2)) - kA^3/(kA^4 - 2*kA^2*kB^2 + kB^4 -
          2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) + (kA*kB^2)/(kA^4 - 2*kA^2*kB^2 +
          kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) +
        (kA*Y2^2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 +
          Y2^4) - (kA*ya1)/(kA^2 - Y1^2) - (kA^3*ya2)/(kA^4 - 2*kA^2*kB^2 +
          kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) +
        (kA*kB^2*ya2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) + (kA*Y2^2*ya2)/(kA^4 - 2*kA^2*kB^2 + kB^4 -
          2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4), 0,
       ((-4*I)*kA*kB*muB*Y2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) + ((2*I)*kA*kB*Y2*ya2)/(kA^4 - 2*kA^2*kB^2 +
          kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4), 0,
       ((2*I)*kA^2*muA*Y2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) + ((2*I)*kB^2*muA*Y2)/(kA^4 - 2*kA^2*kB^2 +
          kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) - ((2*I)*muA*Y2^3)/
         (kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) -
        (I*kA^2*Y2*ya2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) - (I*kB^2*Y2*ya2)/(kA^4 - 2*kA^2*kB^2 + kB^4 -
          2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) + (I*Y2^3*ya2)/
         (kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4), 0,
       (kA^2*kB)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 +
          Y2^4) - kB^3/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) + (2*kA^2*kB*muA)/(kA^4 - 2*kA^2*kB^2 + kB^4 -
          2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) - (2*kB^3*muA)/
         (kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) +
        (2*kA^2*kB*muB)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) - (2*kB^3*muB)/(kA^4 - 2*kA^2*kB^2 + kB^4 -
          2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) + (kB*Y2^2)/(kA^4 - 2*kA^2*kB^2 +
          kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) + (2*kB*muA*Y2^2)/
         (kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) +
        (2*kB*muB*Y2^2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) - (kA^2*kB*ya2)/(kA^4 - 2*kA^2*kB^2 + kB^4 -
          2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) + (kB^3*ya2)/
         (kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) -
        (kB*Y2^2*ya2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4), 0, ((2*I)*muA*Y1)/(kA^2 - Y1^2) -
        (I*Y1*ya1)/(kA^2 - Y1^2), 0, 0, 0, 0, 0, 0, 0,
       (I*Y1)/(kA^2 - Y1^2) + (I*kA^2*Y2)/(kA^4 - 2*kA^2*kB^2 + kB^4 -
          2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) + (I*kB^2*Y2)/
         (kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) -
        (I*Y2^3)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 +
          Y2^4), 0, (kA^2*kB)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) - kB^3/(kA^4 - 2*kA^2*kB^2 + kB^4 -
          2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) + (kB*Y2^2)/(kA^4 - 2*kA^2*kB^2 +
          kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4)},
      {((-2*I)*kA^2*kB^2*Y2)/(kA^5*kB - 2*kA^3*kB^3 + kA*kB^5 -
          2*kA^3*kB*Y2^2 - 2*kA*kB^3*Y2^2 + kA*kB*Y2^4) -
        ((2*I)*kA^2*kB^2*Y2*ya2)/(kA^5*kB - 2*kA^3*kB^3 + kA*kB^5 -
          2*kA^3*kB*Y2^2 - 2*kA*kB^3*Y2^2 + kA*kB*Y2^4), 0,
       -(kA/(kA^2 - Y1^2)) + (2*kA^4*kB*muB)/(kA^5*kB - 2*kA^3*kB^3 +
          kA*kB^5 - 2*kA^3*kB*Y2^2 - 2*kA*kB^3*Y2^2 + kA*kB*Y2^4) -
        (2*kA^2*kB^3*muB)/(kA^5*kB - 2*kA^3*kB^3 + kA*kB^5 - 2*kA^3*kB*Y2^2 -
          2*kA*kB^3*Y2^2 + kA*kB*Y2^4) - (2*kA^2*kB*muB*Y2^2)/
         (kA^5*kB - 2*kA^3*kB^3 + kA*kB^5 - 2*kA^3*kB*Y2^2 - 2*kA*kB^3*Y2^2 +
          kA*kB*Y2^4) - (kA*ya1)/(kA^2 - Y1^2) - (kA^4*kB*ya2)/
         (kA^5*kB - 2*kA^3*kB^3 + kA*kB^5 - 2*kA^3*kB*Y2^2 - 2*kA*kB^3*Y2^2 +
          kA*kB*Y2^4) + (kA^2*kB^3*ya2)/(kA^5*kB - 2*kA^3*kB^3 + kA*kB^5 -
          2*kA^3*kB*Y2^2 - 2*kA*kB^3*Y2^2 + kA*kB*Y2^4) +
        (kA^2*kB*Y2^2*ya2)/(kA^5*kB - 2*kA^3*kB^3 + kA*kB^5 -
          2*kA^3*kB*Y2^2 - 2*kA*kB^3*Y2^2 + kA*kB*Y2^4), 0,
       (-2*kA^3*kB^2*muA)/(kA^5*kB - 2*kA^3*kB^3 + kA*kB^5 - 2*kA^3*kB*Y2^2 -
          2*kA*kB^3*Y2^2 + kA*kB*Y2^4) + (2*kA*kB^4*muA)/
         (kA^5*kB - 2*kA^3*kB^3 + kA*kB^5 - 2*kA^3*kB*Y2^2 - 2*kA*kB^3*Y2^2 +
          kA*kB*Y2^4) - (2*kA*kB^2*muA*Y2^2)/(kA^5*kB - 2*kA^3*kB^3 +
          kA*kB^5 - 2*kA^3*kB*Y2^2 - 2*kA*kB^3*Y2^2 + kA*kB*Y2^4) +
        (kA^3*kB^2*ya2)/(kA^5*kB - 2*kA^3*kB^3 + kA*kB^5 - 2*kA^3*kB*Y2^2 -
          2*kA*kB^3*Y2^2 + kA*kB*Y2^4) - (kA*kB^4*ya2)/
         (kA^5*kB - 2*kA^3*kB^3 + kA*kB^5 - 2*kA^3*kB*Y2^2 - 2*kA*kB^3*Y2^2 +
          kA*kB*Y2^4) + (kA*kB^2*Y2^2*ya2)/(kA^5*kB - 2*kA^3*kB^3 + kA*kB^5 -
          2*kA^3*kB*Y2^2 - 2*kA*kB^3*Y2^2 + kA*kB*Y2^4), 0,
       (I*kA^3*kB*Y2)/(kA^5*kB - 2*kA^3*kB^3 + kA*kB^5 - 2*kA^3*kB*Y2^2 -
          2*kA*kB^3*Y2^2 + kA*kB*Y2^4) + (I*kA*kB^3*Y2)/
         (kA^5*kB - 2*kA^3*kB^3 + kA*kB^5 - 2*kA^3*kB*Y2^2 - 2*kA*kB^3*Y2^2 +
          kA*kB*Y2^4) + ((2*I)*kA^3*kB*muA*Y2)/(kA^5*kB - 2*kA^3*kB^3 +
          kA*kB^5 - 2*kA^3*kB*Y2^2 - 2*kA*kB^3*Y2^2 + kA*kB*Y2^4) +
        ((2*I)*kA*kB^3*muA*Y2)/(kA^5*kB - 2*kA^3*kB^3 + kA*kB^5 -
          2*kA^3*kB*Y2^2 - 2*kA*kB^3*Y2^2 + kA*kB*Y2^4) +
        ((2*I)*kA^3*kB*muB*Y2)/(kA^5*kB - 2*kA^3*kB^3 + kA*kB^5 -
          2*kA^3*kB*Y2^2 - 2*kA*kB^3*Y2^2 + kA*kB*Y2^4) +
        ((2*I)*kA*kB^3*muB*Y2)/(kA^5*kB - 2*kA^3*kB^3 + kA*kB^5 -
          2*kA^3*kB*Y2^2 - 2*kA*kB^3*Y2^2 + kA*kB*Y2^4) -
        (I*kA*kB*Y2^3)/(kA^5*kB - 2*kA^3*kB^3 + kA*kB^5 - 2*kA^3*kB*Y2^2 -
          2*kA*kB^3*Y2^2 + kA*kB*Y2^4) - ((2*I)*kA*kB*muA*Y2^3)/
         (kA^5*kB - 2*kA^3*kB^3 + kA*kB^5 - 2*kA^3*kB*Y2^2 - 2*kA*kB^3*Y2^2 +
          kA*kB*Y2^4) - ((2*I)*kA*kB*muB*Y2^3)/(kA^5*kB - 2*kA^3*kB^3 +
          kA*kB^5 - 2*kA^3*kB*Y2^2 - 2*kA*kB^3*Y2^2 + kA*kB*Y2^4) -
        (I*kA^3*kB*Y2*ya2)/(kA^5*kB - 2*kA^3*kB^3 + kA*kB^5 -
          2*kA^3*kB*Y2^2 - 2*kA*kB^3*Y2^2 + kA*kB*Y2^4) -
        (I*kA*kB^3*Y2*ya2)/(kA^5*kB - 2*kA^3*kB^3 + kA*kB^5 -
          2*kA^3*kB*Y2^2 - 2*kA*kB^3*Y2^2 + kA*kB*Y2^4) +
        (I*kA*kB*Y2^3*ya2)/(kA^5*kB - 2*kA^3*kB^3 + kA*kB^5 -
          2*kA^3*kB*Y2^2 - 2*kA*kB^3*Y2^2 + kA*kB*Y2^4), 0, 0, 0,
       ((2*I)*muA*Y1)/(kA^2 - Y1^2) - (I*Y1*ya1)/(kA^2 - Y1^2), 0, 0, 0, 0,
       0, -((kA^3*kB^2)/(kA^5*kB - 2*kA^3*kB^3 + kA*kB^5 - 2*kA^3*kB*Y2^2 -
           2*kA*kB^3*Y2^2 + kA*kB*Y2^4)) + (kA*kB^4)/(kA^5*kB - 2*kA^3*kB^3 +
          kA*kB^5 - 2*kA^3*kB*Y2^2 - 2*kA*kB^3*Y2^2 + kA*kB*Y2^4) -
        (kA*kB^2*Y2^2)/(kA^5*kB - 2*kA^3*kB^3 + kA*kB^5 - 2*kA^3*kB*Y2^2 -
          2*kA*kB^3*Y2^2 + kA*kB*Y2^4), 0, (I*Y1)/(kA^2 - Y1^2) +
        (I*kA^3*kB*Y2)/(kA^5*kB - 2*kA^3*kB^3 + kA*kB^5 - 2*kA^3*kB*Y2^2 -
          2*kA*kB^3*Y2^2 + kA*kB*Y2^4) + (I*kA*kB^3*Y2)/
         (kA^5*kB - 2*kA^3*kB^3 + kA*kB^5 - 2*kA^3*kB*Y2^2 - 2*kA*kB^3*Y2^2 +
          kA*kB*Y2^4) - (I*kA*kB*Y2^3)/(kA^5*kB - 2*kA^3*kB^3 + kA*kB^5 -
          2*kA^3*kB*Y2^2 - 2*kA*kB^3*Y2^2 + kA*kB*Y2^4), 0},
      {0, ((-2*I)*kA^2*kB^2*Y2)/(kA^5*kB - 2*kA^3*kB^3 + kA*kB^5 -
          2*kA^3*kB*Y2^2 - 2*kA*kB^3*Y2^2 + kA*kB*Y2^4) -
        ((2*I)*kA^2*kB^2*Y2*ya2)/(kA^5*kB - 2*kA^3*kB^3 + kA*kB^5 -
          2*kA^3*kB*Y2^2 - 2*kA*kB^3*Y2^2 + kA*kB*Y2^4), 0,
       -(kA/(kA^2 - Y1^2)) + (2*kA^4*kB*muB)/(kA^5*kB - 2*kA^3*kB^3 +
          kA*kB^5 - 2*kA^3*kB*Y2^2 - 2*kA*kB^3*Y2^2 + kA*kB*Y2^4) -
        (2*kA^2*kB^3*muB)/(kA^5*kB - 2*kA^3*kB^3 + kA*kB^5 - 2*kA^3*kB*Y2^2 -
          2*kA*kB^3*Y2^2 + kA*kB*Y2^4) - (2*kA^2*kB*muB*Y2^2)/
         (kA^5*kB - 2*kA^3*kB^3 + kA*kB^5 - 2*kA^3*kB*Y2^2 - 2*kA*kB^3*Y2^2 +
          kA*kB*Y2^4) - (kA*ya1)/(kA^2 - Y1^2) - (kA^4*kB*ya2)/
         (kA^5*kB - 2*kA^3*kB^3 + kA*kB^5 - 2*kA^3*kB*Y2^2 - 2*kA*kB^3*Y2^2 +
          kA*kB*Y2^4) + (kA^2*kB^3*ya2)/(kA^5*kB - 2*kA^3*kB^3 + kA*kB^5 -
          2*kA^3*kB*Y2^2 - 2*kA*kB^3*Y2^2 + kA*kB*Y2^4) +
        (kA^2*kB*Y2^2*ya2)/(kA^5*kB - 2*kA^3*kB^3 + kA*kB^5 -
          2*kA^3*kB*Y2^2 - 2*kA*kB^3*Y2^2 + kA*kB*Y2^4), 0,
       (-2*kA^3*kB^2*muA)/(kA^5*kB - 2*kA^3*kB^3 + kA*kB^5 - 2*kA^3*kB*Y2^2 -
          2*kA*kB^3*Y2^2 + kA*kB*Y2^4) + (2*kA*kB^4*muA)/
         (kA^5*kB - 2*kA^3*kB^3 + kA*kB^5 - 2*kA^3*kB*Y2^2 - 2*kA*kB^3*Y2^2 +
          kA*kB*Y2^4) - (2*kA*kB^2*muA*Y2^2)/(kA^5*kB - 2*kA^3*kB^3 +
          kA*kB^5 - 2*kA^3*kB*Y2^2 - 2*kA*kB^3*Y2^2 + kA*kB*Y2^4) +
        (kA^3*kB^2*ya2)/(kA^5*kB - 2*kA^3*kB^3 + kA*kB^5 - 2*kA^3*kB*Y2^2 -
          2*kA*kB^3*Y2^2 + kA*kB*Y2^4) - (kA*kB^4*ya2)/
         (kA^5*kB - 2*kA^3*kB^3 + kA*kB^5 - 2*kA^3*kB*Y2^2 - 2*kA*kB^3*Y2^2 +
          kA*kB*Y2^4) + (kA*kB^2*Y2^2*ya2)/(kA^5*kB - 2*kA^3*kB^3 + kA*kB^5 -
          2*kA^3*kB*Y2^2 - 2*kA*kB^3*Y2^2 + kA*kB*Y2^4), 0,
       (I*kA^3*kB*Y2)/(kA^5*kB - 2*kA^3*kB^3 + kA*kB^5 - 2*kA^3*kB*Y2^2 -
          2*kA*kB^3*Y2^2 + kA*kB*Y2^4) + (I*kA*kB^3*Y2)/
         (kA^5*kB - 2*kA^3*kB^3 + kA*kB^5 - 2*kA^3*kB*Y2^2 - 2*kA*kB^3*Y2^2 +
          kA*kB*Y2^4) + ((2*I)*kA^3*kB*muA*Y2)/(kA^5*kB - 2*kA^3*kB^3 +
          kA*kB^5 - 2*kA^3*kB*Y2^2 - 2*kA*kB^3*Y2^2 + kA*kB*Y2^4) +
        ((2*I)*kA*kB^3*muA*Y2)/(kA^5*kB - 2*kA^3*kB^3 + kA*kB^5 -
          2*kA^3*kB*Y2^2 - 2*kA*kB^3*Y2^2 + kA*kB*Y2^4) +
        ((2*I)*kA^3*kB*muB*Y2)/(kA^5*kB - 2*kA^3*kB^3 + kA*kB^5 -
          2*kA^3*kB*Y2^2 - 2*kA*kB^3*Y2^2 + kA*kB*Y2^4) +
        ((2*I)*kA*kB^3*muB*Y2)/(kA^5*kB - 2*kA^3*kB^3 + kA*kB^5 -
          2*kA^3*kB*Y2^2 - 2*kA*kB^3*Y2^2 + kA*kB*Y2^4) -
        (I*kA*kB*Y2^3)/(kA^5*kB - 2*kA^3*kB^3 + kA*kB^5 - 2*kA^3*kB*Y2^2 -
          2*kA*kB^3*Y2^2 + kA*kB*Y2^4) - ((2*I)*kA*kB*muA*Y2^3)/
         (kA^5*kB - 2*kA^3*kB^3 + kA*kB^5 - 2*kA^3*kB*Y2^2 - 2*kA*kB^3*Y2^2 +
          kA*kB*Y2^4) - ((2*I)*kA*kB*muB*Y2^3)/(kA^5*kB - 2*kA^3*kB^3 +
          kA*kB^5 - 2*kA^3*kB*Y2^2 - 2*kA*kB^3*Y2^2 + kA*kB*Y2^4) -
        (I*kA^3*kB*Y2*ya2)/(kA^5*kB - 2*kA^3*kB^3 + kA*kB^5 -
          2*kA^3*kB*Y2^2 - 2*kA*kB^3*Y2^2 + kA*kB*Y2^4) -
        (I*kA*kB^3*Y2*ya2)/(kA^5*kB - 2*kA^3*kB^3 + kA*kB^5 -
          2*kA^3*kB*Y2^2 - 2*kA*kB^3*Y2^2 + kA*kB*Y2^4) +
        (I*kA*kB*Y2^3*ya2)/(kA^5*kB - 2*kA^3*kB^3 + kA*kB^5 -
          2*kA^3*kB*Y2^2 - 2*kA*kB^3*Y2^2 + kA*kB*Y2^4), 0, 0, 0,
       ((2*I)*muA*Y1)/(kA^2 - Y1^2) - (I*Y1*ya1)/(kA^2 - Y1^2), 0, 0, 0, 0,
       0, -((kA^3*kB^2)/(kA^5*kB - 2*kA^3*kB^3 + kA*kB^5 - 2*kA^3*kB*Y2^2 -
           2*kA*kB^3*Y2^2 + kA*kB*Y2^4)) + (kA*kB^4)/(kA^5*kB - 2*kA^3*kB^3 +
          kA*kB^5 - 2*kA^3*kB*Y2^2 - 2*kA*kB^3*Y2^2 + kA*kB*Y2^4) -
        (kA*kB^2*Y2^2)/(kA^5*kB - 2*kA^3*kB^3 + kA*kB^5 - 2*kA^3*kB*Y2^2 -
          2*kA*kB^3*Y2^2 + kA*kB*Y2^4), 0, (I*Y1)/(kA^2 - Y1^2) +
        (I*kA^3*kB*Y2)/(kA^5*kB - 2*kA^3*kB^3 + kA*kB^5 - 2*kA^3*kB*Y2^2 -
          2*kA*kB^3*Y2^2 + kA*kB*Y2^4) + (I*kA*kB^3*Y2)/
         (kA^5*kB - 2*kA^3*kB^3 + kA*kB^5 - 2*kA^3*kB*Y2^2 - 2*kA*kB^3*Y2^2 +
          kA*kB*Y2^4) - (I*kA*kB*Y2^3)/(kA^5*kB - 2*kA^3*kB^3 + kA*kB^5 -
          2*kA^3*kB*Y2^2 - 2*kA*kB^3*Y2^2 + kA*kB*Y2^4)},
      {(I*kA^2*Y2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 +
          Y2^4) + (I*kB^2*Y2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) - (I*Y2^3)/(kA^4 - 2*kA^2*kB^2 + kB^4 -
          2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) + (I*kA^2*Y2*ya2)/
         (kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) +
        (I*kB^2*Y2*ya2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) - (I*Y2^3*ya2)/(kA^4 - 2*kA^2*kB^2 + kB^4 -
          2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4), 0,
       (-2*kA^2*kB*muB)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) + (2*kB^3*muB)/(kA^4 - 2*kA^2*kB^2 + kB^4 -
          2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) - (2*kB*muB*Y2^2)/
         (kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) +
        (kA^2*kB*ya2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) - (kB^3*ya2)/(kA^4 - 2*kA^2*kB^2 + kB^4 -
          2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) + (kB*Y2^2*ya2)/
         (kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4), 0,
       -kA^(-1) - (2*muA)/kA + kA/(-kA^2 + Y1^2) + (2*kA^3*muA)/
         (kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) -
        (2*kA*kB^2*muA)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) - (2*kA*muA*Y2^2)/(kA^4 - 2*kA^2*kB^2 + kB^4 -
          2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) + (kA*ya1)/(-kA^2 + Y1^2) -
        (kA^3*ya2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 +
          Y2^4) + (kA*kB^2*ya2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) + (kA*Y2^2*ya2)/(kA^4 - 2*kA^2*kB^2 + kB^4 -
          2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4), 0,
       ((-2*I)*kA*kB*Y2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) - ((4*I)*kA*kB*muA*Y2)/(kA^4 - 2*kA^2*kB^2 +
          kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) - ((4*I)*kA*kB*muB*Y2)/
         (kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) +
        ((2*I)*kA*kB*Y2*ya2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4), 0, 0, 0, 0, 0,
       ((-2*I)*muA*Y1)/(-kA^2 + Y1^2) + (I*Y1*ya1)/(-kA^2 + Y1^2), 0, 0, 0,
       kA/(-kA^2 + Y1^2) + kA^3/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) - (kA*kB^2)/(kA^4 - 2*kA^2*kB^2 + kB^4 -
          2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) - (kA*Y2^2)/(kA^4 - 2*kA^2*kB^2 +
          kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4), 0,
       ((-2*I)*kA*kB*Y2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
         2*kB^2*Y2^2 + Y2^4), 0},
      {0, (I*kA^2*Y2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) + (I*kB^2*Y2)/(kA^4 - 2*kA^2*kB^2 + kB^4 -
          2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) - (I*Y2^3)/(kA^4 - 2*kA^2*kB^2 +
          kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) + (I*kA^2*Y2*ya2)/
         (kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) +
        (I*kB^2*Y2*ya2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) - (I*Y2^3*ya2)/(kA^4 - 2*kA^2*kB^2 + kB^4 -
          2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4), 0,
       (-2*kA^2*kB*muB)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) + (2*kB^3*muB)/(kA^4 - 2*kA^2*kB^2 + kB^4 -
          2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) - (2*kB*muB*Y2^2)/
         (kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) +
        (kA^2*kB*ya2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) - (kB^3*ya2)/(kA^4 - 2*kA^2*kB^2 + kB^4 -
          2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) + (kB*Y2^2*ya2)/
         (kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4), 0,
       -kA^(-1) - (2*muA)/kA + kA/(-kA^2 + Y1^2) + (2*kA^3*muA)/
         (kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) -
        (2*kA*kB^2*muA)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) - (2*kA*muA*Y2^2)/(kA^4 - 2*kA^2*kB^2 + kB^4 -
          2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) + (kA*ya1)/(-kA^2 + Y1^2) -
        (kA^3*ya2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 +
          Y2^4) + (kA*kB^2*ya2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) + (kA*Y2^2*ya2)/(kA^4 - 2*kA^2*kB^2 + kB^4 -
          2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4), 0,
       ((-2*I)*kA*kB*Y2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) - ((4*I)*kA*kB*muA*Y2)/(kA^4 - 2*kA^2*kB^2 +
          kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) - ((4*I)*kA*kB*muB*Y2)/
         (kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) +
        ((2*I)*kA*kB*Y2*ya2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4), 0, 0, 0, 0, 0,
       ((-2*I)*muA*Y1)/(-kA^2 + Y1^2) + (I*Y1*ya1)/(-kA^2 + Y1^2), 0, 0, 0,
       kA/(-kA^2 + Y1^2) + kA^3/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) - (kA*kB^2)/(kA^4 - 2*kA^2*kB^2 + kB^4 -
          2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) - (kA*Y2^2)/(kA^4 - 2*kA^2*kB^2 +
          kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4), 0,
       ((-2*I)*kA*kB*Y2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
         2*kB^2*Y2^2 + Y2^4)},
      {-((kA^2*kB)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 +
           Y2^4)) + kB^3/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) - (kB*Y2^2)/(kA^4 - 2*kA^2*kB^2 + kB^4 -
          2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) - (kA^2*kB*ya2)/
         (kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) +
        (kB^3*ya2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 +
          Y2^4) - (kB*Y2^2*ya2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4), 0, ((-2*I)*kA^2*muB*Y2)/(kA^4 - 2*kA^2*kB^2 +
          kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) - ((2*I)*kB^2*muB*Y2)/
         (kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) +
        ((2*I)*muB*Y2^3)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) + (I*kA^2*Y2*ya2)/(kA^4 - 2*kA^2*kB^2 + kB^4 -
          2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) + (I*kB^2*Y2*ya2)/
         (kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) -
        (I*Y2^3*ya2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 +
          Y2^4), 0, ((4*I)*kA*kB*muA*Y2)/(kA^4 - 2*kA^2*kB^2 + kB^4 -
          2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) - ((2*I)*kA*kB*Y2*ya2)/
         (kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4), 0,
       -kA^(-1) - (2*muA)/kA + kA/(-kA^2 + Y1^2) +
        kA^3/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) -
        (kA*kB^2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 +
          Y2^4) + (2*kA^3*muA)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) - (2*kA*kB^2*muA)/(kA^4 - 2*kA^2*kB^2 + kB^4 -
          2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) + (2*kA^3*muB)/
         (kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) -
        (2*kA*kB^2*muB)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) - (kA*Y2^2)/(kA^4 - 2*kA^2*kB^2 + kB^4 -
          2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) - (2*kA*muA*Y2^2)/
         (kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) -
        (2*kA*muB*Y2^2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) + (kA*ya1)/(-kA^2 + Y1^2) -
        (kA^3*ya2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 +
          Y2^4) + (kA*kB^2*ya2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) + (kA*Y2^2*ya2)/(kA^4 - 2*kA^2*kB^2 + kB^4 -
          2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4), 0, 0, 0, 0, 0, 0, 0,
       ((-2*I)*muA*Y1)/(-kA^2 + Y1^2) + (I*Y1*ya1)/(-kA^2 + Y1^2), 0,
       ((2*I)*kA*kB*Y2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
         2*kB^2*Y2^2 + Y2^4), 0, kA/(-kA^2 + Y1^2) +
        kA^3/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) -
        (kA*kB^2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 +
          Y2^4) - (kA*Y2^2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4), 0},
      {0, -((kA^2*kB)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
           2*kB^2*Y2^2 + Y2^4)) + kB^3/(kA^4 - 2*kA^2*kB^2 + kB^4 -
          2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) - (kB*Y2^2)/(kA^4 - 2*kA^2*kB^2 +
          kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) -
        (kA^2*kB*ya2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) + (kB^3*ya2)/(kA^4 - 2*kA^2*kB^2 + kB^4 -
          2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) - (kB*Y2^2*ya2)/
         (kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4), 0,
       ((-2*I)*kA^2*muB*Y2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) - ((2*I)*kB^2*muB*Y2)/(kA^4 - 2*kA^2*kB^2 +
          kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) + ((2*I)*muB*Y2^3)/
         (kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) +
        (I*kA^2*Y2*ya2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) + (I*kB^2*Y2*ya2)/(kA^4 - 2*kA^2*kB^2 + kB^4 -
          2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) - (I*Y2^3*ya2)/
         (kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4), 0,
       ((4*I)*kA*kB*muA*Y2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) - ((2*I)*kA*kB*Y2*ya2)/(kA^4 - 2*kA^2*kB^2 +
          kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4), 0,
       -kA^(-1) - (2*muA)/kA + kA/(-kA^2 + Y1^2) +
        kA^3/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) -
        (kA*kB^2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 +
          Y2^4) + (2*kA^3*muA)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) - (2*kA*kB^2*muA)/(kA^4 - 2*kA^2*kB^2 + kB^4 -
          2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) + (2*kA^3*muB)/
         (kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) -
        (2*kA*kB^2*muB)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) - (kA*Y2^2)/(kA^4 - 2*kA^2*kB^2 + kB^4 -
          2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) - (2*kA*muA*Y2^2)/
         (kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) -
        (2*kA*muB*Y2^2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) + (kA*ya1)/(-kA^2 + Y1^2) -
        (kA^3*ya2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 +
          Y2^4) + (kA*kB^2*ya2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) + (kA*Y2^2*ya2)/(kA^4 - 2*kA^2*kB^2 + kB^4 -
          2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4), 0, 0, 0, 0, 0, 0, 0,
       ((-2*I)*muA*Y1)/(-kA^2 + Y1^2) + (I*Y1*ya1)/(-kA^2 + Y1^2), 0,
       ((2*I)*kA*kB*Y2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
         2*kB^2*Y2^2 + Y2^4), 0, kA/(-kA^2 + Y1^2) +
        kA^3/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) -
        (kA*kB^2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 +
          Y2^4) - (kA*Y2^2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4)}, {((-I)*Y1)/(-kA^2 + Y1^2) -
        (I*Y1*ya1)/(-kA^2 + Y1^2), 0, 0, 0, 0, 0, 0, 0,
       -kA^(-1) - (2*muA)/kA - (2*kA*muA)/(-kA^2 + Y1^2) -
        kA^3/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) +
        (kA*kB^2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 +
          Y2^4) + (kA*Y2^2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) + (kA*ya1)/(-kA^2 + Y1^2) -
        (kA^3*ya2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 +
          Y2^4) + (kA*kB^2*ya2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) + (kA*Y2^2*ya2)/(kA^4 - 2*kA^2*kB^2 + kB^4 -
          2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4), 0,
       ((-4*I)*kA*kB*muB*Y2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) + ((2*I)*kA*kB*Y2*ya2)/(kA^4 - 2*kA^2*kB^2 +
          kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4), 0,
       ((2*I)*kA^2*muA*Y2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) + ((2*I)*kB^2*muA*Y2)/(kA^4 - 2*kA^2*kB^2 +
          kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) - ((2*I)*muA*Y2^3)/
         (kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) -
        (I*kA^2*Y2*ya2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) - (I*kB^2*Y2*ya2)/(kA^4 - 2*kA^2*kB^2 + kB^4 -
          2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) + (I*Y2^3*ya2)/
         (kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4), 0,
       (kA^2*kB)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 +
          Y2^4) - kB^3/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) + (2*kA^2*kB*muA)/(kA^4 - 2*kA^2*kB^2 + kB^4 -
          2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) - (2*kB^3*muA)/
         (kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) +
        (2*kA^2*kB*muB)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) - (2*kB^3*muB)/(kA^4 - 2*kA^2*kB^2 + kB^4 -
          2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) + (kB*Y2^2)/(kA^4 - 2*kA^2*kB^2 +
          kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) + (2*kB*muA*Y2^2)/
         (kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) +
        (2*kB*muB*Y2^2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) - (kA^2*kB*ya2)/(kA^4 - 2*kA^2*kB^2 + kB^4 -
          2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) + (kB^3*ya2)/
         (kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) -
        (kB*Y2^2*ya2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4), 0, -(kA/(-kA^2 + Y1^2)) -
        kA^3/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) +
        (kA*kB^2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 +
          Y2^4) + (kA*Y2^2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4), 0, ((2*I)*kA*kB*Y2)/(kA^4 - 2*kA^2*kB^2 +
         kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4), 0},
      {0, ((-I)*Y1)/(-kA^2 + Y1^2) - (I*Y1*ya1)/(-kA^2 + Y1^2), 0, 0, 0, 0,
       0, 0, 0, -kA^(-1) - (2*muA)/kA - (2*kA*muA)/(-kA^2 + Y1^2) -
        kA^3/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) +
        (kA*kB^2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 +
          Y2^4) + (kA*Y2^2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) + (kA*ya1)/(-kA^2 + Y1^2) -
        (kA^3*ya2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 +
          Y2^4) + (kA*kB^2*ya2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) + (kA*Y2^2*ya2)/(kA^4 - 2*kA^2*kB^2 + kB^4 -
          2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4), 0,
       ((-4*I)*kA*kB*muB*Y2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) + ((2*I)*kA*kB*Y2*ya2)/(kA^4 - 2*kA^2*kB^2 +
          kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4), 0,
       ((2*I)*kA^2*muA*Y2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) + ((2*I)*kB^2*muA*Y2)/(kA^4 - 2*kA^2*kB^2 +
          kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) - ((2*I)*muA*Y2^3)/
         (kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) -
        (I*kA^2*Y2*ya2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) - (I*kB^2*Y2*ya2)/(kA^4 - 2*kA^2*kB^2 + kB^4 -
          2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) + (I*Y2^3*ya2)/
         (kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4), 0,
       (kA^2*kB)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 +
          Y2^4) - kB^3/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) + (2*kA^2*kB*muA)/(kA^4 - 2*kA^2*kB^2 + kB^4 -
          2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) - (2*kB^3*muA)/
         (kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) +
        (2*kA^2*kB*muB)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) - (2*kB^3*muB)/(kA^4 - 2*kA^2*kB^2 + kB^4 -
          2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) + (kB*Y2^2)/(kA^4 - 2*kA^2*kB^2 +
          kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) + (2*kB*muA*Y2^2)/
         (kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) +
        (2*kB*muB*Y2^2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) - (kA^2*kB*ya2)/(kA^4 - 2*kA^2*kB^2 + kB^4 -
          2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) + (kB^3*ya2)/
         (kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) -
        (kB*Y2^2*ya2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4), 0, -(kA/(-kA^2 + Y1^2)) -
        kA^3/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) +
        (kA*kB^2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 +
          Y2^4) + (kA*Y2^2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4), 0, ((2*I)*kA*kB*Y2)/(kA^4 - 2*kA^2*kB^2 +
         kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4)},
      {0, 0, ((-I)*Y1)/(-kA^2 + Y1^2) - (I*Y1*ya1)/(-kA^2 + Y1^2), 0, 0, 0,
       0, 0, ((2*I)*kA^3*kB*Y2)/(-kA^6 + 2*kA^4*kB^2 - kA^2*kB^4 +
          2*kA^4*Y2^2 + 2*kA^2*kB^2*Y2^2 - kA^2*Y2^4) +
        ((2*I)*kA^3*kB*Y2*ya2)/(-kA^6 + 2*kA^4*kB^2 - kA^2*kB^4 +
          2*kA^4*Y2^2 + 2*kA^2*kB^2*Y2^2 - kA^2*Y2^4), 0,
       -kA^(-1) - (2*muA)/kA - (2*kA*muA)/(-kA^2 + Y1^2) -
        (2*kA^5*muB)/(-kA^6 + 2*kA^4*kB^2 - kA^2*kB^4 + 2*kA^4*Y2^2 +
          2*kA^2*kB^2*Y2^2 - kA^2*Y2^4) + (2*kA^3*kB^2*muB)/
         (-kA^6 + 2*kA^4*kB^2 - kA^2*kB^4 + 2*kA^4*Y2^2 + 2*kA^2*kB^2*Y2^2 -
          kA^2*Y2^4) + (2*kA^3*muB*Y2^2)/(-kA^6 + 2*kA^4*kB^2 - kA^2*kB^4 +
          2*kA^4*Y2^2 + 2*kA^2*kB^2*Y2^2 - kA^2*Y2^4) +
        (kA*ya1)/(-kA^2 + Y1^2) + (kA^5*ya2)/(-kA^6 + 2*kA^4*kB^2 -
          kA^2*kB^4 + 2*kA^4*Y2^2 + 2*kA^2*kB^2*Y2^2 - kA^2*Y2^4) -
        (kA^3*kB^2*ya2)/(-kA^6 + 2*kA^4*kB^2 - kA^2*kB^4 + 2*kA^4*Y2^2 +
          2*kA^2*kB^2*Y2^2 - kA^2*Y2^4) - (kA^3*Y2^2*ya2)/
         (-kA^6 + 2*kA^4*kB^2 - kA^2*kB^4 + 2*kA^4*Y2^2 + 2*kA^2*kB^2*Y2^2 -
          kA^2*Y2^4), 0, (2*kA^4*kB*muA)/(-kA^6 + 2*kA^4*kB^2 - kA^2*kB^4 +
          2*kA^4*Y2^2 + 2*kA^2*kB^2*Y2^2 - kA^2*Y2^4) -
        (2*kA^2*kB^3*muA)/(-kA^6 + 2*kA^4*kB^2 - kA^2*kB^4 + 2*kA^4*Y2^2 +
          2*kA^2*kB^2*Y2^2 - kA^2*Y2^4) + (2*kA^2*kB*muA*Y2^2)/
         (-kA^6 + 2*kA^4*kB^2 - kA^2*kB^4 + 2*kA^4*Y2^2 + 2*kA^2*kB^2*Y2^2 -
          kA^2*Y2^4) - (kA^4*kB*ya2)/(-kA^6 + 2*kA^4*kB^2 - kA^2*kB^4 +
          2*kA^4*Y2^2 + 2*kA^2*kB^2*Y2^2 - kA^2*Y2^4) +
        (kA^2*kB^3*ya2)/(-kA^6 + 2*kA^4*kB^2 - kA^2*kB^4 + 2*kA^4*Y2^2 +
          2*kA^2*kB^2*Y2^2 - kA^2*Y2^4) - (kA^2*kB*Y2^2*ya2)/
         (-kA^6 + 2*kA^4*kB^2 - kA^2*kB^4 + 2*kA^4*Y2^2 + 2*kA^2*kB^2*Y2^2 -
          kA^2*Y2^4), 0, ((-I)*kA^4*Y2)/(-kA^6 + 2*kA^4*kB^2 - kA^2*kB^4 +
          2*kA^4*Y2^2 + 2*kA^2*kB^2*Y2^2 - kA^2*Y2^4) -
        (I*kA^2*kB^2*Y2)/(-kA^6 + 2*kA^4*kB^2 - kA^2*kB^4 + 2*kA^4*Y2^2 +
          2*kA^2*kB^2*Y2^2 - kA^2*Y2^4) - ((2*I)*kA^4*muA*Y2)/
         (-kA^6 + 2*kA^4*kB^2 - kA^2*kB^4 + 2*kA^4*Y2^2 + 2*kA^2*kB^2*Y2^2 -
          kA^2*Y2^4) - ((2*I)*kA^2*kB^2*muA*Y2)/(-kA^6 + 2*kA^4*kB^2 -
          kA^2*kB^4 + 2*kA^4*Y2^2 + 2*kA^2*kB^2*Y2^2 - kA^2*Y2^4) -
        ((2*I)*kA^4*muB*Y2)/(-kA^6 + 2*kA^4*kB^2 - kA^2*kB^4 + 2*kA^4*Y2^2 +
          2*kA^2*kB^2*Y2^2 - kA^2*Y2^4) - ((2*I)*kA^2*kB^2*muB*Y2)/
         (-kA^6 + 2*kA^4*kB^2 - kA^2*kB^4 + 2*kA^4*Y2^2 + 2*kA^2*kB^2*Y2^2 -
          kA^2*Y2^4) + (I*kA^2*Y2^3)/(-kA^6 + 2*kA^4*kB^2 - kA^2*kB^4 +
          2*kA^4*Y2^2 + 2*kA^2*kB^2*Y2^2 - kA^2*Y2^4) +
        ((2*I)*kA^2*muA*Y2^3)/(-kA^6 + 2*kA^4*kB^2 - kA^2*kB^4 +
          2*kA^4*Y2^2 + 2*kA^2*kB^2*Y2^2 - kA^2*Y2^4) +
        ((2*I)*kA^2*muB*Y2^3)/(-kA^6 + 2*kA^4*kB^2 - kA^2*kB^4 +
          2*kA^4*Y2^2 + 2*kA^2*kB^2*Y2^2 - kA^2*Y2^4) +
        (I*kA^4*Y2*ya2)/(-kA^6 + 2*kA^4*kB^2 - kA^2*kB^4 + 2*kA^4*Y2^2 +
          2*kA^2*kB^2*Y2^2 - kA^2*Y2^4) + (I*kA^2*kB^2*Y2*ya2)/
         (-kA^6 + 2*kA^4*kB^2 - kA^2*kB^4 + 2*kA^4*Y2^2 + 2*kA^2*kB^2*Y2^2 -
          kA^2*Y2^4) - (I*kA^2*Y2^3*ya2)/(-kA^6 + 2*kA^4*kB^2 - kA^2*kB^4 +
          2*kA^4*Y2^2 + 2*kA^2*kB^2*Y2^2 - kA^2*Y2^4), 0,
       ((2*I)*kA^3*kB*Y2)/(-kA^6 + 2*kA^4*kB^2 - kA^2*kB^4 + 2*kA^4*Y2^2 +
         2*kA^2*kB^2*Y2^2 - kA^2*Y2^4), 0, -(kA/(-kA^2 + Y1^2)) +
        kA^5/(-kA^6 + 2*kA^4*kB^2 - kA^2*kB^4 + 2*kA^4*Y2^2 +
          2*kA^2*kB^2*Y2^2 - kA^2*Y2^4) - (kA^3*kB^2)/(-kA^6 + 2*kA^4*kB^2 -
          kA^2*kB^4 + 2*kA^4*Y2^2 + 2*kA^2*kB^2*Y2^2 - kA^2*Y2^4) -
        (kA^3*Y2^2)/(-kA^6 + 2*kA^4*kB^2 - kA^2*kB^4 + 2*kA^4*Y2^2 +
          2*kA^2*kB^2*Y2^2 - kA^2*Y2^4), 0},
      {0, 0, 0, ((-I)*Y1)/(-kA^2 + Y1^2) - (I*Y1*ya1)/(-kA^2 + Y1^2), 0, 0,
       0, 0, 0, ((2*I)*kA^3*kB*Y2)/(-kA^6 + 2*kA^4*kB^2 - kA^2*kB^4 +
          2*kA^4*Y2^2 + 2*kA^2*kB^2*Y2^2 - kA^2*Y2^4) +
        ((2*I)*kA^3*kB*Y2*ya2)/(-kA^6 + 2*kA^4*kB^2 - kA^2*kB^4 +
          2*kA^4*Y2^2 + 2*kA^2*kB^2*Y2^2 - kA^2*Y2^4), 0,
       -kA^(-1) - (2*muA)/kA - (2*kA*muA)/(-kA^2 + Y1^2) -
        (2*kA^5*muB)/(-kA^6 + 2*kA^4*kB^2 - kA^2*kB^4 + 2*kA^4*Y2^2 +
          2*kA^2*kB^2*Y2^2 - kA^2*Y2^4) + (2*kA^3*kB^2*muB)/
         (-kA^6 + 2*kA^4*kB^2 - kA^2*kB^4 + 2*kA^4*Y2^2 + 2*kA^2*kB^2*Y2^2 -
          kA^2*Y2^4) + (2*kA^3*muB*Y2^2)/(-kA^6 + 2*kA^4*kB^2 - kA^2*kB^4 +
          2*kA^4*Y2^2 + 2*kA^2*kB^2*Y2^2 - kA^2*Y2^4) +
        (kA*ya1)/(-kA^2 + Y1^2) + (kA^5*ya2)/(-kA^6 + 2*kA^4*kB^2 -
          kA^2*kB^4 + 2*kA^4*Y2^2 + 2*kA^2*kB^2*Y2^2 - kA^2*Y2^4) -
        (kA^3*kB^2*ya2)/(-kA^6 + 2*kA^4*kB^2 - kA^2*kB^4 + 2*kA^4*Y2^2 +
          2*kA^2*kB^2*Y2^2 - kA^2*Y2^4) - (kA^3*Y2^2*ya2)/
         (-kA^6 + 2*kA^4*kB^2 - kA^2*kB^4 + 2*kA^4*Y2^2 + 2*kA^2*kB^2*Y2^2 -
          kA^2*Y2^4), 0, (2*kA^4*kB*muA)/(-kA^6 + 2*kA^4*kB^2 - kA^2*kB^4 +
          2*kA^4*Y2^2 + 2*kA^2*kB^2*Y2^2 - kA^2*Y2^4) -
        (2*kA^2*kB^3*muA)/(-kA^6 + 2*kA^4*kB^2 - kA^2*kB^4 + 2*kA^4*Y2^2 +
          2*kA^2*kB^2*Y2^2 - kA^2*Y2^4) + (2*kA^2*kB*muA*Y2^2)/
         (-kA^6 + 2*kA^4*kB^2 - kA^2*kB^4 + 2*kA^4*Y2^2 + 2*kA^2*kB^2*Y2^2 -
          kA^2*Y2^4) - (kA^4*kB*ya2)/(-kA^6 + 2*kA^4*kB^2 - kA^2*kB^4 +
          2*kA^4*Y2^2 + 2*kA^2*kB^2*Y2^2 - kA^2*Y2^4) +
        (kA^2*kB^3*ya2)/(-kA^6 + 2*kA^4*kB^2 - kA^2*kB^4 + 2*kA^4*Y2^2 +
          2*kA^2*kB^2*Y2^2 - kA^2*Y2^4) - (kA^2*kB*Y2^2*ya2)/
         (-kA^6 + 2*kA^4*kB^2 - kA^2*kB^4 + 2*kA^4*Y2^2 + 2*kA^2*kB^2*Y2^2 -
          kA^2*Y2^4), 0, ((-I)*kA^4*Y2)/(-kA^6 + 2*kA^4*kB^2 - kA^2*kB^4 +
          2*kA^4*Y2^2 + 2*kA^2*kB^2*Y2^2 - kA^2*Y2^4) -
        (I*kA^2*kB^2*Y2)/(-kA^6 + 2*kA^4*kB^2 - kA^2*kB^4 + 2*kA^4*Y2^2 +
          2*kA^2*kB^2*Y2^2 - kA^2*Y2^4) - ((2*I)*kA^4*muA*Y2)/
         (-kA^6 + 2*kA^4*kB^2 - kA^2*kB^4 + 2*kA^4*Y2^2 + 2*kA^2*kB^2*Y2^2 -
          kA^2*Y2^4) - ((2*I)*kA^2*kB^2*muA*Y2)/(-kA^6 + 2*kA^4*kB^2 -
          kA^2*kB^4 + 2*kA^4*Y2^2 + 2*kA^2*kB^2*Y2^2 - kA^2*Y2^4) -
        ((2*I)*kA^4*muB*Y2)/(-kA^6 + 2*kA^4*kB^2 - kA^2*kB^4 + 2*kA^4*Y2^2 +
          2*kA^2*kB^2*Y2^2 - kA^2*Y2^4) - ((2*I)*kA^2*kB^2*muB*Y2)/
         (-kA^6 + 2*kA^4*kB^2 - kA^2*kB^4 + 2*kA^4*Y2^2 + 2*kA^2*kB^2*Y2^2 -
          kA^2*Y2^4) + (I*kA^2*Y2^3)/(-kA^6 + 2*kA^4*kB^2 - kA^2*kB^4 +
          2*kA^4*Y2^2 + 2*kA^2*kB^2*Y2^2 - kA^2*Y2^4) +
        ((2*I)*kA^2*muA*Y2^3)/(-kA^6 + 2*kA^4*kB^2 - kA^2*kB^4 +
          2*kA^4*Y2^2 + 2*kA^2*kB^2*Y2^2 - kA^2*Y2^4) +
        ((2*I)*kA^2*muB*Y2^3)/(-kA^6 + 2*kA^4*kB^2 - kA^2*kB^4 +
          2*kA^4*Y2^2 + 2*kA^2*kB^2*Y2^2 - kA^2*Y2^4) +
        (I*kA^4*Y2*ya2)/(-kA^6 + 2*kA^4*kB^2 - kA^2*kB^4 + 2*kA^4*Y2^2 +
          2*kA^2*kB^2*Y2^2 - kA^2*Y2^4) + (I*kA^2*kB^2*Y2*ya2)/
         (-kA^6 + 2*kA^4*kB^2 - kA^2*kB^4 + 2*kA^4*Y2^2 + 2*kA^2*kB^2*Y2^2 -
          kA^2*Y2^4) - (I*kA^2*Y2^3*ya2)/(-kA^6 + 2*kA^4*kB^2 - kA^2*kB^4 +
          2*kA^4*Y2^2 + 2*kA^2*kB^2*Y2^2 - kA^2*Y2^4), 0,
       ((2*I)*kA^3*kB*Y2)/(-kA^6 + 2*kA^4*kB^2 - kA^2*kB^4 + 2*kA^4*Y2^2 +
         2*kA^2*kB^2*Y2^2 - kA^2*Y2^4), 0, -(kA/(-kA^2 + Y1^2)) +
        kA^5/(-kA^6 + 2*kA^4*kB^2 - kA^2*kB^4 + 2*kA^4*Y2^2 +
          2*kA^2*kB^2*Y2^2 - kA^2*Y2^4) - (kA^3*kB^2)/(-kA^6 + 2*kA^4*kB^2 -
          kA^2*kB^4 + 2*kA^4*Y2^2 + 2*kA^2*kB^2*Y2^2 - kA^2*Y2^4) -
        (kA^3*Y2^2)/(-kA^6 + 2*kA^4*kB^2 - kA^2*kB^4 + 2*kA^4*Y2^2 +
          2*kA^2*kB^2*Y2^2 - kA^2*Y2^4)}, {0, 0, 0, 0,
       (I*Y1)/(kA^2 - Y1^2) + (I*Y1*ya1)/(kA^2 - Y1^2), 0, 0, 0,
       (I*kA^2*Y2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 +
          Y2^4) + (I*kB^2*Y2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) - (I*Y2^3)/(kA^4 - 2*kA^2*kB^2 + kB^4 -
          2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) + (I*kA^2*Y2*ya2)/
         (kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) +
        (I*kB^2*Y2*ya2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) - (I*Y2^3*ya2)/(kA^4 - 2*kA^2*kB^2 + kB^4 -
          2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4), 0,
       (-2*kA^2*kB*muB)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) + (2*kB^3*muB)/(kA^4 - 2*kA^2*kB^2 + kB^4 -
          2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) - (2*kB*muB*Y2^2)/
         (kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) +
        (kA^2*kB*ya2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) - (kB^3*ya2)/(kA^4 - 2*kA^2*kB^2 + kB^4 -
          2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) + (kB*Y2^2*ya2)/
         (kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4), 0,
       -2/kA - (4*muA)/kA + (2*kA*muA)/(kA^2 - Y1^2) +
        (2*kA^3*muA)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 +
          Y2^4) - (2*kA*kB^2*muA)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) - (2*kA*muA*Y2^2)/(kA^4 - 2*kA^2*kB^2 + kB^4 -
          2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) - (kA*ya1)/(kA^2 - Y1^2) -
        (kA^3*ya2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 +
          Y2^4) + (kA*kB^2*ya2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) + (kA*Y2^2*ya2)/(kA^4 - 2*kA^2*kB^2 + kB^4 -
          2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4), 0,
       ((-2*I)*kA*kB*Y2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) - ((4*I)*kA*kB*muA*Y2)/(kA^4 - 2*kA^2*kB^2 +
          kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) - ((4*I)*kA*kB*muB*Y2)/
         (kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) +
        ((2*I)*kA*kB*Y2*ya2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4), 0, (I*Y1)/(kA^2 - Y1^2) +
        (I*kA^2*Y2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 +
          Y2^4) + (I*kB^2*Y2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) - (I*Y2^3)/(kA^4 - 2*kA^2*kB^2 + kB^4 -
          2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4), 0,
       (kA^2*kB)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 +
          Y2^4) - kB^3/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) + (kB*Y2^2)/(kA^4 - 2*kA^2*kB^2 + kB^4 -
          2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4), 0}, {0, 0, 0, 0, 0,
       (I*Y1)/(kA^2 - Y1^2) + (I*Y1*ya1)/(kA^2 - Y1^2), 0, 0, 0,
       (I*kA^2*Y2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 +
          Y2^4) + (I*kB^2*Y2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) - (I*Y2^3)/(kA^4 - 2*kA^2*kB^2 + kB^4 -
          2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) + (I*kA^2*Y2*ya2)/
         (kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) +
        (I*kB^2*Y2*ya2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) - (I*Y2^3*ya2)/(kA^4 - 2*kA^2*kB^2 + kB^4 -
          2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4), 0,
       (-2*kA^2*kB*muB)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) + (2*kB^3*muB)/(kA^4 - 2*kA^2*kB^2 + kB^4 -
          2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) - (2*kB*muB*Y2^2)/
         (kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) +
        (kA^2*kB*ya2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) - (kB^3*ya2)/(kA^4 - 2*kA^2*kB^2 + kB^4 -
          2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) + (kB*Y2^2*ya2)/
         (kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4), 0,
       -2/kA - (4*muA)/kA + (2*kA*muA)/(kA^2 - Y1^2) +
        (2*kA^3*muA)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 +
          Y2^4) - (2*kA*kB^2*muA)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) - (2*kA*muA*Y2^2)/(kA^4 - 2*kA^2*kB^2 + kB^4 -
          2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) - (kA*ya1)/(kA^2 - Y1^2) -
        (kA^3*ya2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 +
          Y2^4) + (kA*kB^2*ya2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) + (kA*Y2^2*ya2)/(kA^4 - 2*kA^2*kB^2 + kB^4 -
          2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4), 0,
       ((-2*I)*kA*kB*Y2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) - ((4*I)*kA*kB*muA*Y2)/(kA^4 - 2*kA^2*kB^2 +
          kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) - ((4*I)*kA*kB*muB*Y2)/
         (kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) +
        ((2*I)*kA*kB*Y2*ya2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4), 0, (I*Y1)/(kA^2 - Y1^2) +
        (I*kA^2*Y2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 +
          Y2^4) + (I*kB^2*Y2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) - (I*Y2^3)/(kA^4 - 2*kA^2*kB^2 + kB^4 -
          2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4), 0,
       (kA^2*kB)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 +
          Y2^4) - kB^3/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) + (kB*Y2^2)/(kA^4 - 2*kA^2*kB^2 + kB^4 -
          2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4)}, {0, 0, 0, 0, 0, 0,
       (I*Y1)/(kA^2 - Y1^2) + (I*Y1*ya1)/(kA^2 - Y1^2), 0,
       -((kA^2*kB)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 +
           Y2^4)) + kB^3/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) - (kB*Y2^2)/(kA^4 - 2*kA^2*kB^2 + kB^4 -
          2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) - (kA^2*kB*ya2)/
         (kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) +
        (kB^3*ya2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 +
          Y2^4) - (kB*Y2^2*ya2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4), 0, ((-2*I)*kA^2*muB*Y2)/(kA^4 - 2*kA^2*kB^2 +
          kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) - ((2*I)*kB^2*muB*Y2)/
         (kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) +
        ((2*I)*muB*Y2^3)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) + (I*kA^2*Y2*ya2)/(kA^4 - 2*kA^2*kB^2 + kB^4 -
          2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) + (I*kB^2*Y2*ya2)/
         (kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) -
        (I*Y2^3*ya2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 +
          Y2^4), 0, ((4*I)*kA*kB*muA*Y2)/(kA^4 - 2*kA^2*kB^2 + kB^4 -
          2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) - ((2*I)*kA*kB*Y2*ya2)/
         (kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4), 0,
       -2/kA - (4*muA)/kA + (2*kA*muA)/(kA^2 - Y1^2) +
        kA^3/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) -
        (kA*kB^2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 +
          Y2^4) + (2*kA^3*muA)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) - (2*kA*kB^2*muA)/(kA^4 - 2*kA^2*kB^2 + kB^4 -
          2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) + (2*kA^3*muB)/
         (kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) -
        (2*kA*kB^2*muB)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) - (kA*Y2^2)/(kA^4 - 2*kA^2*kB^2 + kB^4 -
          2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) - (2*kA*muA*Y2^2)/
         (kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) -
        (2*kA*muB*Y2^2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) - (kA*ya1)/(kA^2 - Y1^2) -
        (kA^3*ya2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 +
          Y2^4) + (kA*kB^2*ya2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) + (kA*Y2^2*ya2)/(kA^4 - 2*kA^2*kB^2 + kB^4 -
          2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4), 0,
       -((kA^2*kB)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 +
           Y2^4)) + kB^3/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) - (kB*Y2^2)/(kA^4 - 2*kA^2*kB^2 + kB^4 -
          2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4), 0, (I*Y1)/(kA^2 - Y1^2) +
        (I*kA^2*Y2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 +
          Y2^4) + (I*kB^2*Y2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) - (I*Y2^3)/(kA^4 - 2*kA^2*kB^2 + kB^4 -
          2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4), 0}, {0, 0, 0, 0, 0, 0, 0,
       (I*Y1)/(kA^2 - Y1^2) + (I*Y1*ya1)/(kA^2 - Y1^2), 0,
       -((kA^2*kB)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 +
           Y2^4)) + kB^3/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) - (kB*Y2^2)/(kA^4 - 2*kA^2*kB^2 + kB^4 -
          2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) - (kA^2*kB*ya2)/
         (kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) +
        (kB^3*ya2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 +
          Y2^4) - (kB*Y2^2*ya2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4), 0, ((-2*I)*kA^2*muB*Y2)/(kA^4 - 2*kA^2*kB^2 +
          kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) - ((2*I)*kB^2*muB*Y2)/
         (kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) +
        ((2*I)*muB*Y2^3)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) + (I*kA^2*Y2*ya2)/(kA^4 - 2*kA^2*kB^2 + kB^4 -
          2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) + (I*kB^2*Y2*ya2)/
         (kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) -
        (I*Y2^3*ya2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 +
          Y2^4), 0, ((4*I)*kA*kB*muA*Y2)/(kA^4 - 2*kA^2*kB^2 + kB^4 -
          2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) - ((2*I)*kA*kB*Y2*ya2)/
         (kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4), 0,
       -2/kA - (4*muA)/kA + (2*kA*muA)/(kA^2 - Y1^2) +
        kA^3/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) -
        (kA*kB^2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 +
          Y2^4) + (2*kA^3*muA)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) - (2*kA*kB^2*muA)/(kA^4 - 2*kA^2*kB^2 + kB^4 -
          2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) + (2*kA^3*muB)/
         (kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) -
        (2*kA*kB^2*muB)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) - (kA*Y2^2)/(kA^4 - 2*kA^2*kB^2 + kB^4 -
          2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) - (2*kA*muA*Y2^2)/
         (kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) -
        (2*kA*muB*Y2^2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) - (kA*ya1)/(kA^2 - Y1^2) -
        (kA^3*ya2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 +
          Y2^4) + (kA*kB^2*ya2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) + (kA*Y2^2*ya2)/(kA^4 - 2*kA^2*kB^2 + kB^4 -
          2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4), 0,
       -((kA^2*kB)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 +
           Y2^4)) + kB^3/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) - (kB*Y2^2)/(kA^4 - 2*kA^2*kB^2 + kB^4 -
          2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4), 0, (I*Y1)/(kA^2 - Y1^2) +
        (I*kA^2*Y2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 +
          Y2^4) + (I*kB^2*Y2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) - (I*Y2^3)/(kA^4 - 2*kA^2*kB^2 + kB^4 -
          2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4)}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
       0, 0, 0, 0, 0, 0, -kA^(-1) - (2*muA)/kA, 0, 0, 0},
      {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
       -kA^(-1) - (2*muA)/kA, 0, 0}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
       0, 0, 0, 0, 0, -kA^(-1) - (2*muA)/kA, 0}, {0, 0, 0, 0, 0, 0, 0, 0, 0,
       0, 0, 0, 0, 0, 0, 0, 0, 0, 0, -kA^(-1) - (2*muA)/kA}},
    "expected" -> {{1/(2*(-kA - Y1)) - 1/(2*(kA - Y1)) +
        1/(4*(-kA - kB - Y2)) - 1/(4*(kA - kB - Y2)) +
        1/(4*(-kA + kB - Y2)) - 1/(4*(kA + kB - Y2)) + ya1/(2*(-kA - Y1)) -
        ya1/(2*(kA - Y1)) + ya2/(4*(-kA - kB - Y2)) -
        ya2/(4*(kA - kB - Y2)) + ya2/(4*(-kA + kB - Y2)) -
        ya2/(4*(kA + kB - Y2)), 0, ((I/2)*muB)/(-kA - kB - Y2) -
        ((I/2)*muB)/(kA - kB - Y2) - ((I/2)*muB)/(-kA + kB - Y2) +
        ((I/2)*muB)/(kA + kB - Y2) - ((I/4)*ya2)/(-kA - kB - Y2) +
        ((I/4)*ya2)/(kA - kB - Y2) + ((I/4)*ya2)/(-kA + kB - Y2) -
        ((I/4)*ya2)/(kA + kB - Y2), 0, ((I/2)*muA)/(-kA - kB - Y2) +
        ((I/2)*muA)/(kA - kB - Y2) + ((I/2)*muA)/(-kA + kB - Y2) +
        ((I/2)*muA)/(kA + kB - Y2) - ((I/4)*ya2)/(-kA - kB - Y2) -
        ((I/4)*ya2)/(kA - kB - Y2) - ((I/4)*ya2)/(-kA + kB - Y2) -
        ((I/4)*ya2)/(kA + kB - Y2), 0, 1/(4*(-kA - kB - Y2)) +
        muA/(2*(-kA - kB - Y2)) + muB/(2*(-kA - kB - Y2)) +
        1/(4*(kA - kB - Y2)) + muA/(2*(kA - kB - Y2)) +
        muB/(2*(kA - kB - Y2)) - 1/(4*(-kA + kB - Y2)) -
        muA/(2*(-kA + kB - Y2)) - muB/(2*(-kA + kB - Y2)) -
        1/(4*(kA + kB - Y2)) - muA/(2*(kA + kB - Y2)) -
        muB/(2*(kA + kB - Y2)) - ya2/(4*(-kA - kB - Y2)) -
        ya2/(4*(kA - kB - Y2)) + ya2/(4*(-kA + kB - Y2)) +
        ya2/(4*(kA + kB - Y2)), 0, (I*muA)/(-kA - Y1) + (I*muA)/(kA - Y1) -
        ((I/2)*ya1)/(-kA - Y1) - ((I/2)*ya1)/(kA - Y1), 0, 0, 0, 0, 0, 0, 0,
       (I/2)/(-kA - Y1) + (I/2)/(kA - Y1) + (I/4)/(-kA - kB - Y2) +
        (I/4)/(kA - kB - Y2) + (I/4)/(-kA + kB - Y2) + (I/4)/(kA + kB - Y2),
       0, 1/(4*(-kA - kB - Y2)) + 1/(4*(kA - kB - Y2)) -
        1/(4*(-kA + kB - Y2)) - 1/(4*(kA + kB - Y2)), 0},
      {0, 1/(2*(-kA - Y1)) - 1/(2*(kA - Y1)) + 1/(4*(-kA - kB - Y2)) -
        1/(4*(kA - kB - Y2)) + 1/(4*(-kA + kB - Y2)) - 1/(4*(kA + kB - Y2)) +
        ya1/(2*(-kA - Y1)) - ya1/(2*(kA - Y1)) + ya2/(4*(-kA - kB - Y2)) -
        ya2/(4*(kA - kB - Y2)) + ya2/(4*(-kA + kB - Y2)) -
        ya2/(4*(kA + kB - Y2)), 0, ((I/2)*muB)/(-kA - kB - Y2) -
        ((I/2)*muB)/(kA - kB - Y2) - ((I/2)*muB)/(-kA + kB - Y2) +
        ((I/2)*muB)/(kA + kB - Y2) - ((I/4)*ya2)/(-kA - kB - Y2) +
        ((I/4)*ya2)/(kA - kB - Y2) + ((I/4)*ya2)/(-kA + kB - Y2) -
        ((I/4)*ya2)/(kA + kB - Y2), 0, ((I/2)*muA)/(-kA - kB - Y2) +
        ((I/2)*muA)/(kA - kB - Y2) + ((I/2)*muA)/(-kA + kB - Y2) +
        ((I/2)*muA)/(kA + kB - Y2) - ((I/4)*ya2)/(-kA - kB - Y2) -
        ((I/4)*ya2)/(kA - kB - Y2) - ((I/4)*ya2)/(-kA + kB - Y2) -
        ((I/4)*ya2)/(kA + kB - Y2), 0, 1/(4*(-kA - kB - Y2)) +
        muA/(2*(-kA - kB - Y2)) + muB/(2*(-kA - kB - Y2)) +
        1/(4*(kA - kB - Y2)) + muA/(2*(kA - kB - Y2)) +
        muB/(2*(kA - kB - Y2)) - 1/(4*(-kA + kB - Y2)) -
        muA/(2*(-kA + kB - Y2)) - muB/(2*(-kA + kB - Y2)) -
        1/(4*(kA + kB - Y2)) - muA/(2*(kA + kB - Y2)) -
        muB/(2*(kA + kB - Y2)) - ya2/(4*(-kA - kB - Y2)) -
        ya2/(4*(kA - kB - Y2)) + ya2/(4*(-kA + kB - Y2)) +
        ya2/(4*(kA + kB - Y2)), 0, (I*muA)/(-kA - Y1) + (I*muA)/(kA - Y1) -
        ((I/2)*ya1)/(-kA - Y1) - ((I/2)*ya1)/(kA - Y1), 0, 0, 0, 0, 0, 0, 0,
       (I/2)/(-kA - Y1) + (I/2)/(kA - Y1) + (I/4)/(-kA - kB - Y2) +
        (I/4)/(kA - kB - Y2) + (I/4)/(-kA + kB - Y2) + (I/4)/(kA + kB - Y2),
       0, 1/(4*(-kA - kB - Y2)) + 1/(4*(kA - kB - Y2)) -
        1/(4*(-kA + kB - Y2)) - 1/(4*(kA + kB - Y2))},
      {(I/4)/(-kA - kB - Y2) - (I/4)/(kA - kB - Y2) - (I/4)/(-kA + kB - Y2) +
        (I/4)/(kA + kB - Y2) + ((I/4)*ya2)/(-kA - kB - Y2) -
        ((I/4)*ya2)/(kA - kB - Y2) - ((I/4)*ya2)/(-kA + kB - Y2) +
        ((I/4)*ya2)/(kA + kB - Y2), 0, 1/(2*(-kA - Y1)) - 1/(2*(kA - Y1)) -
        muB/(2*(-kA - kB - Y2)) + muB/(2*(kA - kB - Y2)) -
        muB/(2*(-kA + kB - Y2)) + muB/(2*(kA + kB - Y2)) +
        ya1/(2*(-kA - Y1)) - ya1/(2*(kA - Y1)) + ya2/(4*(-kA - kB - Y2)) -
        ya2/(4*(kA - kB - Y2)) + ya2/(4*(-kA + kB - Y2)) -
        ya2/(4*(kA + kB - Y2)), 0, -1/2*muA/(-kA - kB - Y2) -
        muA/(2*(kA - kB - Y2)) + muA/(2*(-kA + kB - Y2)) +
        muA/(2*(kA + kB - Y2)) + ya2/(4*(-kA - kB - Y2)) +
        ya2/(4*(kA - kB - Y2)) - ya2/(4*(-kA + kB - Y2)) -
        ya2/(4*(kA + kB - Y2)), 0, (I/4)/(-kA - kB - Y2) +
        ((I/2)*muA)/(-kA - kB - Y2) + ((I/2)*muB)/(-kA - kB - Y2) +
        (I/4)/(kA - kB - Y2) + ((I/2)*muA)/(kA - kB - Y2) +
        ((I/2)*muB)/(kA - kB - Y2) + (I/4)/(-kA + kB - Y2) +
        ((I/2)*muA)/(-kA + kB - Y2) + ((I/2)*muB)/(-kA + kB - Y2) +
        (I/4)/(kA + kB - Y2) + ((I/2)*muA)/(kA + kB - Y2) +
        ((I/2)*muB)/(kA + kB - Y2) - ((I/4)*ya2)/(-kA - kB - Y2) -
        ((I/4)*ya2)/(kA - kB - Y2) - ((I/4)*ya2)/(-kA + kB - Y2) -
        ((I/4)*ya2)/(kA + kB - Y2), 0, 0, 0, (I*muA)/(-kA - Y1) +
        (I*muA)/(kA - Y1) - ((I/2)*ya1)/(-kA - Y1) - ((I/2)*ya1)/(kA - Y1),
       0, 0, 0, 0, 0, -1/4*1/(-kA - kB - Y2) - 1/(4*(kA - kB - Y2)) +
        1/(4*(-kA + kB - Y2)) + 1/(4*(kA + kB - Y2)), 0,
       (I/2)/(-kA - Y1) + (I/2)/(kA - Y1) + (I/4)/(-kA - kB - Y2) +
        (I/4)/(kA - kB - Y2) + (I/4)/(-kA + kB - Y2) + (I/4)/(kA + kB - Y2),
       0}, {0, (I/4)/(-kA - kB - Y2) - (I/4)/(kA - kB - Y2) -
        (I/4)/(-kA + kB - Y2) + (I/4)/(kA + kB - Y2) +
        ((I/4)*ya2)/(-kA - kB - Y2) - ((I/4)*ya2)/(kA - kB - Y2) -
        ((I/4)*ya2)/(-kA + kB - Y2) + ((I/4)*ya2)/(kA + kB - Y2), 0,
       1/(2*(-kA - Y1)) - 1/(2*(kA - Y1)) - muB/(2*(-kA - kB - Y2)) +
        muB/(2*(kA - kB - Y2)) - muB/(2*(-kA + kB - Y2)) +
        muB/(2*(kA + kB - Y2)) + ya1/(2*(-kA - Y1)) - ya1/(2*(kA - Y1)) +
        ya2/(4*(-kA - kB - Y2)) - ya2/(4*(kA - kB - Y2)) +
        ya2/(4*(-kA + kB - Y2)) - ya2/(4*(kA + kB - Y2)), 0,
       -1/2*muA/(-kA - kB - Y2) - muA/(2*(kA - kB - Y2)) +
        muA/(2*(-kA + kB - Y2)) + muA/(2*(kA + kB - Y2)) +
        ya2/(4*(-kA - kB - Y2)) + ya2/(4*(kA - kB - Y2)) -
        ya2/(4*(-kA + kB - Y2)) - ya2/(4*(kA + kB - Y2)), 0,
       (I/4)/(-kA - kB - Y2) + ((I/2)*muA)/(-kA - kB - Y2) +
        ((I/2)*muB)/(-kA - kB - Y2) + (I/4)/(kA - kB - Y2) +
        ((I/2)*muA)/(kA - kB - Y2) + ((I/2)*muB)/(kA - kB - Y2) +
        (I/4)/(-kA + kB - Y2) + ((I/2)*muA)/(-kA + kB - Y2) +
        ((I/2)*muB)/(-kA + kB - Y2) + (I/4)/(kA + kB - Y2) +
        ((I/2)*muA)/(kA + kB - Y2) + ((I/2)*muB)/(kA + kB - Y2) -
        ((I/4)*ya2)/(-kA - kB - Y2) - ((I/4)*ya2)/(kA - kB - Y2) -
        ((I/4)*ya2)/(-kA + kB - Y2) - ((I/4)*ya2)/(kA + kB - Y2), 0, 0, 0,
       (I*muA)/(-kA - Y1) + (I*muA)/(kA - Y1) - ((I/2)*ya1)/(-kA - Y1) -
        ((I/2)*ya1)/(kA - Y1), 0, 0, 0, 0, 0, -1/4*1/(-kA - kB - Y2) -
        1/(4*(kA - kB - Y2)) + 1/(4*(-kA + kB - Y2)) + 1/(4*(kA + kB - Y2)),
       0, (I/2)/(-kA - Y1) + (I/2)/(kA - Y1) + (I/4)/(-kA - kB - Y2) +
        (I/4)/(kA - kB - Y2) + (I/4)/(-kA + kB - Y2) + (I/4)/(kA + kB - Y2)},
      {(I/4)/(-kA - kB - Y2) + (I/4)/(kA - kB - Y2) + (I/4)/(-kA + kB - Y2) +
        (I/4)/(kA + kB - Y2) + ((I/4)*ya2)/(-kA - kB - Y2) +
        ((I/4)*ya2)/(kA - kB - Y2) + ((I/4)*ya2)/(-kA + kB - Y2) +
        ((I/4)*ya2)/(kA + kB - Y2), 0, -1/2*muB/(-kA - kB - Y2) -
        muB/(2*(kA - kB - Y2)) + muB/(2*(-kA + kB - Y2)) +
        muB/(2*(kA + kB - Y2)) + ya2/(4*(-kA - kB - Y2)) +
        ya2/(4*(kA - kB - Y2)) - ya2/(4*(-kA + kB - Y2)) -
        ya2/(4*(kA + kB - Y2)), 0, -kA^(-1) - (2*muA)/kA + 1/(2*(-kA - Y1)) -
        1/(2*(kA - Y1)) - muA/(2*(-kA - kB - Y2)) + muA/(2*(kA - kB - Y2)) -
        muA/(2*(-kA + kB - Y2)) + muA/(2*(kA + kB - Y2)) +
        ya1/(2*(-kA - Y1)) - ya1/(2*(kA - Y1)) + ya2/(4*(-kA - kB - Y2)) -
        ya2/(4*(kA - kB - Y2)) + ya2/(4*(-kA + kB - Y2)) -
        ya2/(4*(kA + kB - Y2)), 0, (I/4)/(-kA - kB - Y2) +
        ((I/2)*muA)/(-kA - kB - Y2) + ((I/2)*muB)/(-kA - kB - Y2) -
        (I/4)/(kA - kB - Y2) - ((I/2)*muA)/(kA - kB - Y2) -
        ((I/2)*muB)/(kA - kB - Y2) - (I/4)/(-kA + kB - Y2) -
        ((I/2)*muA)/(-kA + kB - Y2) - ((I/2)*muB)/(-kA + kB - Y2) +
        (I/4)/(kA + kB - Y2) + ((I/2)*muA)/(kA + kB - Y2) +
        ((I/2)*muB)/(kA + kB - Y2) - ((I/4)*ya2)/(-kA - kB - Y2) +
        ((I/4)*ya2)/(kA - kB - Y2) + ((I/4)*ya2)/(-kA + kB - Y2) -
        ((I/4)*ya2)/(kA + kB - Y2), 0, 0, 0, 0, 0, (I*muA)/(-kA - Y1) +
        (I*muA)/(kA - Y1) - ((I/2)*ya1)/(-kA - Y1) - ((I/2)*ya1)/(kA - Y1),
       0, 0, 0, 1/(2*(-kA - Y1)) - 1/(2*(kA - Y1)) - 1/(4*(-kA - kB - Y2)) +
        1/(4*(kA - kB - Y2)) - 1/(4*(-kA + kB - Y2)) + 1/(4*(kA + kB - Y2)),
       0, (I/4)/(-kA - kB - Y2) - (I/4)/(kA - kB - Y2) -
        (I/4)/(-kA + kB - Y2) + (I/4)/(kA + kB - Y2), 0},
      {0, (I/4)/(-kA - kB - Y2) + (I/4)/(kA - kB - Y2) +
        (I/4)/(-kA + kB - Y2) + (I/4)/(kA + kB - Y2) +
        ((I/4)*ya2)/(-kA - kB - Y2) + ((I/4)*ya2)/(kA - kB - Y2) +
        ((I/4)*ya2)/(-kA + kB - Y2) + ((I/4)*ya2)/(kA + kB - Y2), 0,
       -1/2*muB/(-kA - kB - Y2) - muB/(2*(kA - kB - Y2)) +
        muB/(2*(-kA + kB - Y2)) + muB/(2*(kA + kB - Y2)) +
        ya2/(4*(-kA - kB - Y2)) + ya2/(4*(kA - kB - Y2)) -
        ya2/(4*(-kA + kB - Y2)) - ya2/(4*(kA + kB - Y2)), 0,
       -kA^(-1) - (2*muA)/kA + 1/(2*(-kA - Y1)) - 1/(2*(kA - Y1)) -
        muA/(2*(-kA - kB - Y2)) + muA/(2*(kA - kB - Y2)) -
        muA/(2*(-kA + kB - Y2)) + muA/(2*(kA + kB - Y2)) +
        ya1/(2*(-kA - Y1)) - ya1/(2*(kA - Y1)) + ya2/(4*(-kA - kB - Y2)) -
        ya2/(4*(kA - kB - Y2)) + ya2/(4*(-kA + kB - Y2)) -
        ya2/(4*(kA + kB - Y2)), 0, (I/4)/(-kA - kB - Y2) +
        ((I/2)*muA)/(-kA - kB - Y2) + ((I/2)*muB)/(-kA - kB - Y2) -
        (I/4)/(kA - kB - Y2) - ((I/2)*muA)/(kA - kB - Y2) -
        ((I/2)*muB)/(kA - kB - Y2) - (I/4)/(-kA + kB - Y2) -
        ((I/2)*muA)/(-kA + kB - Y2) - ((I/2)*muB)/(-kA + kB - Y2) +
        (I/4)/(kA + kB - Y2) + ((I/2)*muA)/(kA + kB - Y2) +
        ((I/2)*muB)/(kA + kB - Y2) - ((I/4)*ya2)/(-kA - kB - Y2) +
        ((I/4)*ya2)/(kA - kB - Y2) + ((I/4)*ya2)/(-kA + kB - Y2) -
        ((I/4)*ya2)/(kA + kB - Y2), 0, 0, 0, 0, 0, (I*muA)/(-kA - Y1) +
        (I*muA)/(kA - Y1) - ((I/2)*ya1)/(-kA - Y1) - ((I/2)*ya1)/(kA - Y1),
       0, 0, 0, 1/(2*(-kA - Y1)) - 1/(2*(kA - Y1)) - 1/(4*(-kA - kB - Y2)) +
        1/(4*(kA - kB - Y2)) - 1/(4*(-kA + kB - Y2)) + 1/(4*(kA + kB - Y2)),
       0, (I/4)/(-kA - kB - Y2) - (I/4)/(kA - kB - Y2) -
        (I/4)/(-kA + kB - Y2) + (I/4)/(kA + kB - Y2)},
      {-1/4*1/(-kA - kB - Y2) - 1/(4*(kA - kB - Y2)) +
        1/(4*(-kA + kB - Y2)) + 1/(4*(kA + kB - Y2)) -
        ya2/(4*(-kA - kB - Y2)) - ya2/(4*(kA - kB - Y2)) +
        ya2/(4*(-kA + kB - Y2)) + ya2/(4*(kA + kB - Y2)), 0,
       ((-1/2*I)*muB)/(-kA - kB - Y2) - ((I/2)*muB)/(kA - kB - Y2) -
        ((I/2)*muB)/(-kA + kB - Y2) - ((I/2)*muB)/(kA + kB - Y2) +
        ((I/4)*ya2)/(-kA - kB - Y2) + ((I/4)*ya2)/(kA - kB - Y2) +
        ((I/4)*ya2)/(-kA + kB - Y2) + ((I/4)*ya2)/(kA + kB - Y2), 0,
       ((-1/2*I)*muA)/(-kA - kB - Y2) + ((I/2)*muA)/(kA - kB - Y2) +
        ((I/2)*muA)/(-kA + kB - Y2) - ((I/2)*muA)/(kA + kB - Y2) +
        ((I/4)*ya2)/(-kA - kB - Y2) - ((I/4)*ya2)/(kA - kB - Y2) -
        ((I/4)*ya2)/(-kA + kB - Y2) + ((I/4)*ya2)/(kA + kB - Y2), 0,
       -kA^(-1) - (2*muA)/kA + 1/(2*(-kA - Y1)) - 1/(2*(kA - Y1)) -
        1/(4*(-kA - kB - Y2)) - muA/(2*(-kA - kB - Y2)) -
        muB/(2*(-kA - kB - Y2)) + 1/(4*(kA - kB - Y2)) +
        muA/(2*(kA - kB - Y2)) + muB/(2*(kA - kB - Y2)) -
        1/(4*(-kA + kB - Y2)) - muA/(2*(-kA + kB - Y2)) -
        muB/(2*(-kA + kB - Y2)) + 1/(4*(kA + kB - Y2)) +
        muA/(2*(kA + kB - Y2)) + muB/(2*(kA + kB - Y2)) +
        ya1/(2*(-kA - Y1)) - ya1/(2*(kA - Y1)) + ya2/(4*(-kA - kB - Y2)) -
        ya2/(4*(kA - kB - Y2)) + ya2/(4*(-kA + kB - Y2)) -
        ya2/(4*(kA + kB - Y2)), 0, 0, 0, 0, 0, 0, 0, (I*muA)/(-kA - Y1) +
        (I*muA)/(kA - Y1) - ((I/2)*ya1)/(-kA - Y1) - ((I/2)*ya1)/(kA - Y1),
       0, (-1/4*I)/(-kA - kB - Y2) + (I/4)/(kA - kB - Y2) +
        (I/4)/(-kA + kB - Y2) - (I/4)/(kA + kB - Y2), 0,
       1/(2*(-kA - Y1)) - 1/(2*(kA - Y1)) - 1/(4*(-kA - kB - Y2)) +
        1/(4*(kA - kB - Y2)) - 1/(4*(-kA + kB - Y2)) + 1/(4*(kA + kB - Y2)),
       0}, {0, -1/4*1/(-kA - kB - Y2) - 1/(4*(kA - kB - Y2)) +
        1/(4*(-kA + kB - Y2)) + 1/(4*(kA + kB - Y2)) -
        ya2/(4*(-kA - kB - Y2)) - ya2/(4*(kA - kB - Y2)) +
        ya2/(4*(-kA + kB - Y2)) + ya2/(4*(kA + kB - Y2)), 0,
       ((-1/2*I)*muB)/(-kA - kB - Y2) - ((I/2)*muB)/(kA - kB - Y2) -
        ((I/2)*muB)/(-kA + kB - Y2) - ((I/2)*muB)/(kA + kB - Y2) +
        ((I/4)*ya2)/(-kA - kB - Y2) + ((I/4)*ya2)/(kA - kB - Y2) +
        ((I/4)*ya2)/(-kA + kB - Y2) + ((I/4)*ya2)/(kA + kB - Y2), 0,
       ((-1/2*I)*muA)/(-kA - kB - Y2) + ((I/2)*muA)/(kA - kB - Y2) +
        ((I/2)*muA)/(-kA + kB - Y2) - ((I/2)*muA)/(kA + kB - Y2) +
        ((I/4)*ya2)/(-kA - kB - Y2) - ((I/4)*ya2)/(kA - kB - Y2) -
        ((I/4)*ya2)/(-kA + kB - Y2) + ((I/4)*ya2)/(kA + kB - Y2), 0,
       -kA^(-1) - (2*muA)/kA + 1/(2*(-kA - Y1)) - 1/(2*(kA - Y1)) -
        1/(4*(-kA - kB - Y2)) - muA/(2*(-kA - kB - Y2)) -
        muB/(2*(-kA - kB - Y2)) + 1/(4*(kA - kB - Y2)) +
        muA/(2*(kA - kB - Y2)) + muB/(2*(kA - kB - Y2)) -
        1/(4*(-kA + kB - Y2)) - muA/(2*(-kA + kB - Y2)) -
        muB/(2*(-kA + kB - Y2)) + 1/(4*(kA + kB - Y2)) +
        muA/(2*(kA + kB - Y2)) + muB/(2*(kA + kB - Y2)) +
        ya1/(2*(-kA - Y1)) - ya1/(2*(kA - Y1)) + ya2/(4*(-kA - kB - Y2)) -
        ya2/(4*(kA - kB - Y2)) + ya2/(4*(-kA + kB - Y2)) -
        ya2/(4*(kA + kB - Y2)), 0, 0, 0, 0, 0, 0, 0, (I*muA)/(-kA - Y1) +
        (I*muA)/(kA - Y1) - ((I/2)*ya1)/(-kA - Y1) - ((I/2)*ya1)/(kA - Y1),
       0, (-1/4*I)/(-kA - kB - Y2) + (I/4)/(kA - kB - Y2) +
        (I/4)/(-kA + kB - Y2) - (I/4)/(kA + kB - Y2), 0,
       1/(2*(-kA - Y1)) - 1/(2*(kA - Y1)) - 1/(4*(-kA - kB - Y2)) +
        1/(4*(kA - kB - Y2)) - 1/(4*(-kA + kB - Y2)) + 1/(4*(kA + kB - Y2))},
      {(I/2)/(-kA - Y1) + (I/2)/(kA - Y1) + ((I/2)*ya1)/(-kA - Y1) +
        ((I/2)*ya1)/(kA - Y1), 0, 0, 0, 0, 0, 0, 0, -kA^(-1) - (2*muA)/kA -
        muA/(-kA - Y1) + muA/(kA - Y1) + 1/(4*(-kA - kB - Y2)) -
        1/(4*(kA - kB - Y2)) + 1/(4*(-kA + kB - Y2)) - 1/(4*(kA + kB - Y2)) +
        ya1/(2*(-kA - Y1)) - ya1/(2*(kA - Y1)) + ya2/(4*(-kA - kB - Y2)) -
        ya2/(4*(kA - kB - Y2)) + ya2/(4*(-kA + kB - Y2)) -
        ya2/(4*(kA + kB - Y2)), 0, ((I/2)*muB)/(-kA - kB - Y2) -
        ((I/2)*muB)/(kA - kB - Y2) - ((I/2)*muB)/(-kA + kB - Y2) +
        ((I/2)*muB)/(kA + kB - Y2) - ((I/4)*ya2)/(-kA - kB - Y2) +
        ((I/4)*ya2)/(kA - kB - Y2) + ((I/4)*ya2)/(-kA + kB - Y2) -
        ((I/4)*ya2)/(kA + kB - Y2), 0, ((I/2)*muA)/(-kA - kB - Y2) +
        ((I/2)*muA)/(kA - kB - Y2) + ((I/2)*muA)/(-kA + kB - Y2) +
        ((I/2)*muA)/(kA + kB - Y2) - ((I/4)*ya2)/(-kA - kB - Y2) -
        ((I/4)*ya2)/(kA - kB - Y2) - ((I/4)*ya2)/(-kA + kB - Y2) -
        ((I/4)*ya2)/(kA + kB - Y2), 0, 1/(4*(-kA - kB - Y2)) +
        muA/(2*(-kA - kB - Y2)) + muB/(2*(-kA - kB - Y2)) +
        1/(4*(kA - kB - Y2)) + muA/(2*(kA - kB - Y2)) +
        muB/(2*(kA - kB - Y2)) - 1/(4*(-kA + kB - Y2)) -
        muA/(2*(-kA + kB - Y2)) - muB/(2*(-kA + kB - Y2)) -
        1/(4*(kA + kB - Y2)) - muA/(2*(kA + kB - Y2)) -
        muB/(2*(kA + kB - Y2)) - ya2/(4*(-kA - kB - Y2)) -
        ya2/(4*(kA - kB - Y2)) + ya2/(4*(-kA + kB - Y2)) +
        ya2/(4*(kA + kB - Y2)), 0, -1/2*1/(-kA - Y1) + 1/(2*(kA - Y1)) +
        1/(4*(-kA - kB - Y2)) - 1/(4*(kA - kB - Y2)) +
        1/(4*(-kA + kB - Y2)) - 1/(4*(kA + kB - Y2)), 0,
       (-1/4*I)/(-kA - kB - Y2) + (I/4)/(kA - kB - Y2) +
        (I/4)/(-kA + kB - Y2) - (I/4)/(kA + kB - Y2), 0},
      {0, (I/2)/(-kA - Y1) + (I/2)/(kA - Y1) + ((I/2)*ya1)/(-kA - Y1) +
        ((I/2)*ya1)/(kA - Y1), 0, 0, 0, 0, 0, 0, 0, -kA^(-1) - (2*muA)/kA -
        muA/(-kA - Y1) + muA/(kA - Y1) + 1/(4*(-kA - kB - Y2)) -
        1/(4*(kA - kB - Y2)) + 1/(4*(-kA + kB - Y2)) - 1/(4*(kA + kB - Y2)) +
        ya1/(2*(-kA - Y1)) - ya1/(2*(kA - Y1)) + ya2/(4*(-kA - kB - Y2)) -
        ya2/(4*(kA - kB - Y2)) + ya2/(4*(-kA + kB - Y2)) -
        ya2/(4*(kA + kB - Y2)), 0, ((I/2)*muB)/(-kA - kB - Y2) -
        ((I/2)*muB)/(kA - kB - Y2) - ((I/2)*muB)/(-kA + kB - Y2) +
        ((I/2)*muB)/(kA + kB - Y2) - ((I/4)*ya2)/(-kA - kB - Y2) +
        ((I/4)*ya2)/(kA - kB - Y2) + ((I/4)*ya2)/(-kA + kB - Y2) -
        ((I/4)*ya2)/(kA + kB - Y2), 0, ((I/2)*muA)/(-kA - kB - Y2) +
        ((I/2)*muA)/(kA - kB - Y2) + ((I/2)*muA)/(-kA + kB - Y2) +
        ((I/2)*muA)/(kA + kB - Y2) - ((I/4)*ya2)/(-kA - kB - Y2) -
        ((I/4)*ya2)/(kA - kB - Y2) - ((I/4)*ya2)/(-kA + kB - Y2) -
        ((I/4)*ya2)/(kA + kB - Y2), 0, 1/(4*(-kA - kB - Y2)) +
        muA/(2*(-kA - kB - Y2)) + muB/(2*(-kA - kB - Y2)) +
        1/(4*(kA - kB - Y2)) + muA/(2*(kA - kB - Y2)) +
        muB/(2*(kA - kB - Y2)) - 1/(4*(-kA + kB - Y2)) -
        muA/(2*(-kA + kB - Y2)) - muB/(2*(-kA + kB - Y2)) -
        1/(4*(kA + kB - Y2)) - muA/(2*(kA + kB - Y2)) -
        muB/(2*(kA + kB - Y2)) - ya2/(4*(-kA - kB - Y2)) -
        ya2/(4*(kA - kB - Y2)) + ya2/(4*(-kA + kB - Y2)) +
        ya2/(4*(kA + kB - Y2)), 0, -1/2*1/(-kA - Y1) + 1/(2*(kA - Y1)) +
        1/(4*(-kA - kB - Y2)) - 1/(4*(kA - kB - Y2)) +
        1/(4*(-kA + kB - Y2)) - 1/(4*(kA + kB - Y2)), 0,
       (-1/4*I)/(-kA - kB - Y2) + (I/4)/(kA - kB - Y2) +
        (I/4)/(-kA + kB - Y2) - (I/4)/(kA + kB - Y2)},
      {0, 0, (I/2)/(-kA - Y1) + (I/2)/(kA - Y1) + ((I/2)*ya1)/(-kA - Y1) +
        ((I/2)*ya1)/(kA - Y1), 0, 0, 0, 0, 0, (I/4)/(-kA - kB - Y2) -
        (I/4)/(kA - kB - Y2) - (I/4)/(-kA + kB - Y2) + (I/4)/(kA + kB - Y2) +
        ((I/4)*ya2)/(-kA - kB - Y2) - ((I/4)*ya2)/(kA - kB - Y2) -
        ((I/4)*ya2)/(-kA + kB - Y2) + ((I/4)*ya2)/(kA + kB - Y2), 0,
       -kA^(-1) - (2*muA)/kA - muA/(-kA - Y1) + muA/(kA - Y1) -
        muB/(2*(-kA - kB - Y2)) + muB/(2*(kA - kB - Y2)) -
        muB/(2*(-kA + kB - Y2)) + muB/(2*(kA + kB - Y2)) +
        ya1/(2*(-kA - Y1)) - ya1/(2*(kA - Y1)) + ya2/(4*(-kA - kB - Y2)) -
        ya2/(4*(kA - kB - Y2)) + ya2/(4*(-kA + kB - Y2)) -
        ya2/(4*(kA + kB - Y2)), 0, -1/2*muA/(-kA - kB - Y2) -
        muA/(2*(kA - kB - Y2)) + muA/(2*(-kA + kB - Y2)) +
        muA/(2*(kA + kB - Y2)) + ya2/(4*(-kA - kB - Y2)) +
        ya2/(4*(kA - kB - Y2)) - ya2/(4*(-kA + kB - Y2)) -
        ya2/(4*(kA + kB - Y2)), 0, (I/4)/(-kA - kB - Y2) +
        ((I/2)*muA)/(-kA - kB - Y2) + ((I/2)*muB)/(-kA - kB - Y2) +
        (I/4)/(kA - kB - Y2) + ((I/2)*muA)/(kA - kB - Y2) +
        ((I/2)*muB)/(kA - kB - Y2) + (I/4)/(-kA + kB - Y2) +
        ((I/2)*muA)/(-kA + kB - Y2) + ((I/2)*muB)/(-kA + kB - Y2) +
        (I/4)/(kA + kB - Y2) + ((I/2)*muA)/(kA + kB - Y2) +
        ((I/2)*muB)/(kA + kB - Y2) - ((I/4)*ya2)/(-kA - kB - Y2) -
        ((I/4)*ya2)/(kA - kB - Y2) - ((I/4)*ya2)/(-kA + kB - Y2) -
        ((I/4)*ya2)/(kA + kB - Y2), 0, (I/4)/(-kA - kB - Y2) -
        (I/4)/(kA - kB - Y2) - (I/4)/(-kA + kB - Y2) + (I/4)/(kA + kB - Y2),
       0, -1/2*1/(-kA - Y1) + 1/(2*(kA - Y1)) + 1/(4*(-kA - kB - Y2)) -
        1/(4*(kA - kB - Y2)) + 1/(4*(-kA + kB - Y2)) - 1/(4*(kA + kB - Y2)),
       0}, {0, 0, 0, (I/2)/(-kA - Y1) + (I/2)/(kA - Y1) +
        ((I/2)*ya1)/(-kA - Y1) + ((I/2)*ya1)/(kA - Y1), 0, 0, 0, 0, 0,
       (I/4)/(-kA - kB - Y2) - (I/4)/(kA - kB - Y2) - (I/4)/(-kA + kB - Y2) +
        (I/4)/(kA + kB - Y2) + ((I/4)*ya2)/(-kA - kB - Y2) -
        ((I/4)*ya2)/(kA - kB - Y2) - ((I/4)*ya2)/(-kA + kB - Y2) +
        ((I/4)*ya2)/(kA + kB - Y2), 0, -kA^(-1) - (2*muA)/kA -
        muA/(-kA - Y1) + muA/(kA - Y1) - muB/(2*(-kA - kB - Y2)) +
        muB/(2*(kA - kB - Y2)) - muB/(2*(-kA + kB - Y2)) +
        muB/(2*(kA + kB - Y2)) + ya1/(2*(-kA - Y1)) - ya1/(2*(kA - Y1)) +
        ya2/(4*(-kA - kB - Y2)) - ya2/(4*(kA - kB - Y2)) +
        ya2/(4*(-kA + kB - Y2)) - ya2/(4*(kA + kB - Y2)), 0,
       -1/2*muA/(-kA - kB - Y2) - muA/(2*(kA - kB - Y2)) +
        muA/(2*(-kA + kB - Y2)) + muA/(2*(kA + kB - Y2)) +
        ya2/(4*(-kA - kB - Y2)) + ya2/(4*(kA - kB - Y2)) -
        ya2/(4*(-kA + kB - Y2)) - ya2/(4*(kA + kB - Y2)), 0,
       (I/4)/(-kA - kB - Y2) + ((I/2)*muA)/(-kA - kB - Y2) +
        ((I/2)*muB)/(-kA - kB - Y2) + (I/4)/(kA - kB - Y2) +
        ((I/2)*muA)/(kA - kB - Y2) + ((I/2)*muB)/(kA - kB - Y2) +
        (I/4)/(-kA + kB - Y2) + ((I/2)*muA)/(-kA + kB - Y2) +
        ((I/2)*muB)/(-kA + kB - Y2) + (I/4)/(kA + kB - Y2) +
        ((I/2)*muA)/(kA + kB - Y2) + ((I/2)*muB)/(kA + kB - Y2) -
        ((I/4)*ya2)/(-kA - kB - Y2) - ((I/4)*ya2)/(kA - kB - Y2) -
        ((I/4)*ya2)/(-kA + kB - Y2) - ((I/4)*ya2)/(kA + kB - Y2), 0,
       (I/4)/(-kA - kB - Y2) - (I/4)/(kA - kB - Y2) - (I/4)/(-kA + kB - Y2) +
        (I/4)/(kA + kB - Y2), 0, -1/2*1/(-kA - Y1) + 1/(2*(kA - Y1)) +
        1/(4*(-kA - kB - Y2)) - 1/(4*(kA - kB - Y2)) +
        1/(4*(-kA + kB - Y2)) - 1/(4*(kA + kB - Y2))},
      {0, 0, 0, 0, (I/2)/(-kA - Y1) + (I/2)/(kA - Y1) +
        ((I/2)*ya1)/(-kA - Y1) + ((I/2)*ya1)/(kA - Y1), 0, 0, 0,
       (I/4)/(-kA - kB - Y2) + (I/4)/(kA - kB - Y2) + (I/4)/(-kA + kB - Y2) +
        (I/4)/(kA + kB - Y2) + ((I/4)*ya2)/(-kA - kB - Y2) +
        ((I/4)*ya2)/(kA - kB - Y2) + ((I/4)*ya2)/(-kA + kB - Y2) +
        ((I/4)*ya2)/(kA + kB - Y2), 0, -1/2*muB/(-kA - kB - Y2) -
        muB/(2*(kA - kB - Y2)) + muB/(2*(-kA + kB - Y2)) +
        muB/(2*(kA + kB - Y2)) + ya2/(4*(-kA - kB - Y2)) +
        ya2/(4*(kA - kB - Y2)) - ya2/(4*(-kA + kB - Y2)) -
        ya2/(4*(kA + kB - Y2)), 0, -2/kA - (4*muA)/kA - muA/(-kA - Y1) +
        muA/(kA - Y1) - muA/(2*(-kA - kB - Y2)) + muA/(2*(kA - kB - Y2)) -
        muA/(2*(-kA + kB - Y2)) + muA/(2*(kA + kB - Y2)) +
        ya1/(2*(-kA - Y1)) - ya1/(2*(kA - Y1)) + ya2/(4*(-kA - kB - Y2)) -
        ya2/(4*(kA - kB - Y2)) + ya2/(4*(-kA + kB - Y2)) -
        ya2/(4*(kA + kB - Y2)), 0, (I/4)/(-kA - kB - Y2) +
        ((I/2)*muA)/(-kA - kB - Y2) + ((I/2)*muB)/(-kA - kB - Y2) -
        (I/4)/(kA - kB - Y2) - ((I/2)*muA)/(kA - kB - Y2) -
        ((I/2)*muB)/(kA - kB - Y2) - (I/4)/(-kA + kB - Y2) -
        ((I/2)*muA)/(-kA + kB - Y2) - ((I/2)*muB)/(-kA + kB - Y2) +
        (I/4)/(kA + kB - Y2) + ((I/2)*muA)/(kA + kB - Y2) +
        ((I/2)*muB)/(kA + kB - Y2) - ((I/4)*ya2)/(-kA - kB - Y2) +
        ((I/4)*ya2)/(kA - kB - Y2) + ((I/4)*ya2)/(-kA + kB - Y2) -
        ((I/4)*ya2)/(kA + kB - Y2), 0, (I/2)/(-kA - Y1) + (I/2)/(kA - Y1) +
        (I/4)/(-kA - kB - Y2) + (I/4)/(kA - kB - Y2) +
        (I/4)/(-kA + kB - Y2) + (I/4)/(kA + kB - Y2), 0,
       1/(4*(-kA - kB - Y2)) + 1/(4*(kA - kB - Y2)) - 1/(4*(-kA + kB - Y2)) -
        1/(4*(kA + kB - Y2)), 0}, {0, 0, 0, 0, 0, (I/2)/(-kA - Y1) +
        (I/2)/(kA - Y1) + ((I/2)*ya1)/(-kA - Y1) + ((I/2)*ya1)/(kA - Y1), 0,
       0, 0, (I/4)/(-kA - kB - Y2) + (I/4)/(kA - kB - Y2) +
        (I/4)/(-kA + kB - Y2) + (I/4)/(kA + kB - Y2) +
        ((I/4)*ya2)/(-kA - kB - Y2) + ((I/4)*ya2)/(kA - kB - Y2) +
        ((I/4)*ya2)/(-kA + kB - Y2) + ((I/4)*ya2)/(kA + kB - Y2), 0,
       -1/2*muB/(-kA - kB - Y2) - muB/(2*(kA - kB - Y2)) +
        muB/(2*(-kA + kB - Y2)) + muB/(2*(kA + kB - Y2)) +
        ya2/(4*(-kA - kB - Y2)) + ya2/(4*(kA - kB - Y2)) -
        ya2/(4*(-kA + kB - Y2)) - ya2/(4*(kA + kB - Y2)), 0,
       -2/kA - (4*muA)/kA - muA/(-kA - Y1) + muA/(kA - Y1) -
        muA/(2*(-kA - kB - Y2)) + muA/(2*(kA - kB - Y2)) -
        muA/(2*(-kA + kB - Y2)) + muA/(2*(kA + kB - Y2)) +
        ya1/(2*(-kA - Y1)) - ya1/(2*(kA - Y1)) + ya2/(4*(-kA - kB - Y2)) -
        ya2/(4*(kA - kB - Y2)) + ya2/(4*(-kA + kB - Y2)) -
        ya2/(4*(kA + kB - Y2)), 0, (I/4)/(-kA - kB - Y2) +
        ((I/2)*muA)/(-kA - kB - Y2) + ((I/2)*muB)/(-kA - kB - Y2) -
        (I/4)/(kA - kB - Y2) - ((I/2)*muA)/(kA - kB - Y2) -
        ((I/2)*muB)/(kA - kB - Y2) - (I/4)/(-kA + kB - Y2) -
        ((I/2)*muA)/(-kA + kB - Y2) - ((I/2)*muB)/(-kA + kB - Y2) +
        (I/4)/(kA + kB - Y2) + ((I/2)*muA)/(kA + kB - Y2) +
        ((I/2)*muB)/(kA + kB - Y2) - ((I/4)*ya2)/(-kA - kB - Y2) +
        ((I/4)*ya2)/(kA - kB - Y2) + ((I/4)*ya2)/(-kA + kB - Y2) -
        ((I/4)*ya2)/(kA + kB - Y2), 0, (I/2)/(-kA - Y1) + (I/2)/(kA - Y1) +
        (I/4)/(-kA - kB - Y2) + (I/4)/(kA - kB - Y2) +
        (I/4)/(-kA + kB - Y2) + (I/4)/(kA + kB - Y2), 0,
       1/(4*(-kA - kB - Y2)) + 1/(4*(kA - kB - Y2)) - 1/(4*(-kA + kB - Y2)) -
        1/(4*(kA + kB - Y2))}, {0, 0, 0, 0, 0, 0, (I/2)/(-kA - Y1) +
        (I/2)/(kA - Y1) + ((I/2)*ya1)/(-kA - Y1) + ((I/2)*ya1)/(kA - Y1), 0,
       -1/4*1/(-kA - kB - Y2) - 1/(4*(kA - kB - Y2)) +
        1/(4*(-kA + kB - Y2)) + 1/(4*(kA + kB - Y2)) -
        ya2/(4*(-kA - kB - Y2)) - ya2/(4*(kA - kB - Y2)) +
        ya2/(4*(-kA + kB - Y2)) + ya2/(4*(kA + kB - Y2)), 0,
       ((-1/2*I)*muB)/(-kA - kB - Y2) - ((I/2)*muB)/(kA - kB - Y2) -
        ((I/2)*muB)/(-kA + kB - Y2) - ((I/2)*muB)/(kA + kB - Y2) +
        ((I/4)*ya2)/(-kA - kB - Y2) + ((I/4)*ya2)/(kA - kB - Y2) +
        ((I/4)*ya2)/(-kA + kB - Y2) + ((I/4)*ya2)/(kA + kB - Y2), 0,
       ((-1/2*I)*muA)/(-kA - kB - Y2) + ((I/2)*muA)/(kA - kB - Y2) +
        ((I/2)*muA)/(-kA + kB - Y2) - ((I/2)*muA)/(kA + kB - Y2) +
        ((I/4)*ya2)/(-kA - kB - Y2) - ((I/4)*ya2)/(kA - kB - Y2) -
        ((I/4)*ya2)/(-kA + kB - Y2) + ((I/4)*ya2)/(kA + kB - Y2), 0,
       -2/kA - (4*muA)/kA - muA/(-kA - Y1) + muA/(kA - Y1) -
        1/(4*(-kA - kB - Y2)) - muA/(2*(-kA - kB - Y2)) -
        muB/(2*(-kA - kB - Y2)) + 1/(4*(kA - kB - Y2)) +
        muA/(2*(kA - kB - Y2)) + muB/(2*(kA - kB - Y2)) -
        1/(4*(-kA + kB - Y2)) - muA/(2*(-kA + kB - Y2)) -
        muB/(2*(-kA + kB - Y2)) + 1/(4*(kA + kB - Y2)) +
        muA/(2*(kA + kB - Y2)) + muB/(2*(kA + kB - Y2)) +
        ya1/(2*(-kA - Y1)) - ya1/(2*(kA - Y1)) + ya2/(4*(-kA - kB - Y2)) -
        ya2/(4*(kA - kB - Y2)) + ya2/(4*(-kA + kB - Y2)) -
        ya2/(4*(kA + kB - Y2)), 0, -1/4*1/(-kA - kB - Y2) -
        1/(4*(kA - kB - Y2)) + 1/(4*(-kA + kB - Y2)) + 1/(4*(kA + kB - Y2)),
       0, (I/2)/(-kA - Y1) + (I/2)/(kA - Y1) + (I/4)/(-kA - kB - Y2) +
        (I/4)/(kA - kB - Y2) + (I/4)/(-kA + kB - Y2) + (I/4)/(kA + kB - Y2),
       0}, {0, 0, 0, 0, 0, 0, 0, (I/2)/(-kA - Y1) + (I/2)/(kA - Y1) +
        ((I/2)*ya1)/(-kA - Y1) + ((I/2)*ya1)/(kA - Y1), 0,
       -1/4*1/(-kA - kB - Y2) - 1/(4*(kA - kB - Y2)) +
        1/(4*(-kA + kB - Y2)) + 1/(4*(kA + kB - Y2)) -
        ya2/(4*(-kA - kB - Y2)) - ya2/(4*(kA - kB - Y2)) +
        ya2/(4*(-kA + kB - Y2)) + ya2/(4*(kA + kB - Y2)), 0,
       ((-1/2*I)*muB)/(-kA - kB - Y2) - ((I/2)*muB)/(kA - kB - Y2) -
        ((I/2)*muB)/(-kA + kB - Y2) - ((I/2)*muB)/(kA + kB - Y2) +
        ((I/4)*ya2)/(-kA - kB - Y2) + ((I/4)*ya2)/(kA - kB - Y2) +
        ((I/4)*ya2)/(-kA + kB - Y2) + ((I/4)*ya2)/(kA + kB - Y2), 0,
       ((-1/2*I)*muA)/(-kA - kB - Y2) + ((I/2)*muA)/(kA - kB - Y2) +
        ((I/2)*muA)/(-kA + kB - Y2) - ((I/2)*muA)/(kA + kB - Y2) +
        ((I/4)*ya2)/(-kA - kB - Y2) - ((I/4)*ya2)/(kA - kB - Y2) -
        ((I/4)*ya2)/(-kA + kB - Y2) + ((I/4)*ya2)/(kA + kB - Y2), 0,
       -2/kA - (4*muA)/kA - muA/(-kA - Y1) + muA/(kA - Y1) -
        1/(4*(-kA - kB - Y2)) - muA/(2*(-kA - kB - Y2)) -
        muB/(2*(-kA - kB - Y2)) + 1/(4*(kA - kB - Y2)) +
        muA/(2*(kA - kB - Y2)) + muB/(2*(kA - kB - Y2)) -
        1/(4*(-kA + kB - Y2)) - muA/(2*(-kA + kB - Y2)) -
        muB/(2*(-kA + kB - Y2)) + 1/(4*(kA + kB - Y2)) +
        muA/(2*(kA + kB - Y2)) + muB/(2*(kA + kB - Y2)) +
        ya1/(2*(-kA - Y1)) - ya1/(2*(kA - Y1)) + ya2/(4*(-kA - kB - Y2)) -
        ya2/(4*(kA - kB - Y2)) + ya2/(4*(-kA + kB - Y2)) -
        ya2/(4*(kA + kB - Y2)), 0, -1/4*1/(-kA - kB - Y2) -
        1/(4*(kA - kB - Y2)) + 1/(4*(-kA + kB - Y2)) + 1/(4*(kA + kB - Y2)),
       0, (I/2)/(-kA - Y1) + (I/2)/(kA - Y1) + (I/4)/(-kA - kB - Y2) +
        (I/4)/(kA - kB - Y2) + (I/4)/(-kA + kB - Y2) + (I/4)/(kA + kB - Y2)},
      {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, (-1 - 2*muA)/kA, 0, 0,
       0}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
       (-1 - 2*muA)/kA, 0, 0}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
       0, 0, 0, (-1 - 2*muA)/kA, 0}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
       0, 0, 0, 0, 0, 0, (-1 - 2*muA)/kA}}, "difference" -> 0|>,
   <|"group" -> "pureTime", "name" -> "three naive dlog kB",
    "passed" -> True, "actual" ->
     {{(kA^2*kB)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 +
          Y2^4) - kB^3/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) + (kB*Y2^2)/(kA^4 - 2*kA^2*kB^2 + kB^4 -
          2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) - kB/(kB^2 - Y3^2) +
        (kA^2*kB*ya2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) - (kB^3*ya2)/(kA^4 - 2*kA^2*kB^2 + kB^4 -
          2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) + (kB*Y2^2*ya2)/
         (kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) -
        (kB*ya3)/(kB^2 - Y3^2), ((-2*I)*muB*Y3)/(kB^2 - Y3^2) +
        (I*Y3*ya3)/(kB^2 - Y3^2), ((2*I)*kA^2*muB*Y2)/(kA^4 - 2*kA^2*kB^2 +
          kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) + ((2*I)*kB^2*muB*Y2)/
         (kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) -
        ((2*I)*muB*Y2^3)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) - (I*kA^2*Y2*ya2)/(kA^4 - 2*kA^2*kB^2 + kB^4 -
          2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) - (I*kB^2*Y2*ya2)/
         (kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) +
        (I*Y2^3*ya2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 +
          Y2^4), 0, ((-4*I)*kA*kB*muA*Y2)/(kA^4 - 2*kA^2*kB^2 + kB^4 -
          2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) + ((2*I)*kA*kB*Y2*ya2)/
         (kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4), 0,
       -(kA^3/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 +
           Y2^4)) + (kA*kB^2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) - (2*kA^3*muA)/(kA^4 - 2*kA^2*kB^2 + kB^4 -
          2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) + (2*kA*kB^2*muA)/
         (kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) -
        (2*kA^3*muB)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 +
          Y2^4) + (2*kA*kB^2*muB)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) + (kA*Y2^2)/(kA^4 - 2*kA^2*kB^2 + kB^4 -
          2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) + (2*kA*muA*Y2^2)/
         (kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) +
        (2*kA*muB*Y2^2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) + (kA^3*ya2)/(kA^4 - 2*kA^2*kB^2 + kB^4 -
          2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) - (kA*kB^2*ya2)/
         (kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) -
        (kA*Y2^2*ya2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4), 0, 0, 0, 0, 0, 0, 0, 0, 0,
       ((-2*I)*kA*kB*Y2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
         2*kB^2*Y2^2 + Y2^4), 0,
       -(kA^3/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 +
           Y2^4)) + (kA*kB^2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) + (kA*Y2^2)/(kA^4 - 2*kA^2*kB^2 + kB^4 -
          2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4), 0},
      {((-I)*Y3)/(kB^2 - Y3^2) - (I*Y3*ya3)/(kB^2 - Y3^2),
       -kB^(-1) - (2*muB)/kB + (kA^2*kB)/(kA^4 - 2*kA^2*kB^2 + kB^4 -
          2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) - kB^3/(kA^4 - 2*kA^2*kB^2 +
          kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) +
        (kB*Y2^2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 +
          Y2^4) + (2*kB*muB)/(kB^2 - Y3^2) + (kA^2*kB*ya2)/
         (kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) -
        (kB^3*ya2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 +
          Y2^4) + (kB*Y2^2*ya2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) - (kB*ya3)/(kB^2 - Y3^2), 0,
       ((2*I)*kA^2*muB*Y2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) + ((2*I)*kB^2*muB*Y2)/(kA^4 - 2*kA^2*kB^2 +
          kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) - ((2*I)*muB*Y2^3)/
         (kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) -
        (I*kA^2*Y2*ya2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) - (I*kB^2*Y2*ya2)/(kA^4 - 2*kA^2*kB^2 + kB^4 -
          2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) + (I*Y2^3*ya2)/
         (kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4), 0,
       ((-4*I)*kA*kB*muA*Y2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) + ((2*I)*kA*kB*Y2*ya2)/(kA^4 - 2*kA^2*kB^2 +
          kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4), 0,
       -(kA^3/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 +
           Y2^4)) + (kA*kB^2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) - (2*kA^3*muA)/(kA^4 - 2*kA^2*kB^2 + kB^4 -
          2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) + (2*kA*kB^2*muA)/
         (kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) -
        (2*kA^3*muB)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 +
          Y2^4) + (2*kA*kB^2*muB)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) + (kA*Y2^2)/(kA^4 - 2*kA^2*kB^2 + kB^4 -
          2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) + (2*kA*muA*Y2^2)/
         (kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) +
        (2*kA*muB*Y2^2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) + (kA^3*ya2)/(kA^4 - 2*kA^2*kB^2 + kB^4 -
          2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) - (kA*kB^2*ya2)/
         (kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) -
        (kA*Y2^2*ya2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4), 0, 0, 0, 0, 0, 0, 0, 0, 0,
       ((-2*I)*kA*kB*Y2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
         2*kB^2*Y2^2 + Y2^4), 0,
       -(kA^3/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 +
           Y2^4)) + (kA*kB^2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) + (kA*Y2^2)/(kA^4 - 2*kA^2*kB^2 + kB^4 -
          2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4)},
      {(I*kA^2*Y2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 +
          Y2^4) + (I*kB^2*Y2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) - (I*Y2^3)/(kA^4 - 2*kA^2*kB^2 + kB^4 -
          2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) + (I*kA^2*Y2*ya2)/
         (kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) +
        (I*kB^2*Y2*ya2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) - (I*Y2^3*ya2)/(kA^4 - 2*kA^2*kB^2 + kB^4 -
          2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4), 0, -kB^(-1) - (2*muB)/kB -
        (2*kA^2*kB*muB)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) + (2*kB^3*muB)/(kA^4 - 2*kA^2*kB^2 + kB^4 -
          2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) - (2*kB*muB*Y2^2)/
         (kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) -
        kB/(kB^2 - Y3^2) + (kA^2*kB*ya2)/(kA^4 - 2*kA^2*kB^2 + kB^4 -
          2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) - (kB^3*ya2)/
         (kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) +
        (kB*Y2^2*ya2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) - (kB*ya3)/(kB^2 - Y3^2),
       ((-2*I)*muB*Y3)/(kB^2 - Y3^2) + (I*Y3*ya3)/(kB^2 - Y3^2),
       (2*kA^3*muA)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 +
          Y2^4) - (2*kA*kB^2*muA)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) - (2*kA*muA*Y2^2)/(kA^4 - 2*kA^2*kB^2 + kB^4 -
          2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) - (kA^3*ya2)/
         (kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) +
        (kA*kB^2*ya2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) + (kA*Y2^2*ya2)/(kA^4 - 2*kA^2*kB^2 + kB^4 -
          2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4), 0,
       ((-2*I)*kA*kB*Y2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) - ((4*I)*kA*kB*muA*Y2)/(kA^4 - 2*kA^2*kB^2 +
          kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) - ((4*I)*kA*kB*muB*Y2)/
         (kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) +
        ((2*I)*kA*kB*Y2*ya2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4), 0, 0, 0, 0, 0, 0, 0, 0, 0,
       kA^3/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) -
        (kA*kB^2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 +
          Y2^4) - (kA*Y2^2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4), 0, ((-2*I)*kA*kB*Y2)/(kA^4 - 2*kA^2*kB^2 +
         kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4), 0},
      {0, (I*kA^2*Y2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) + (I*kB^2*Y2)/(kA^4 - 2*kA^2*kB^2 + kB^4 -
          2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) - (I*Y2^3)/(kA^4 - 2*kA^2*kB^2 +
          kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) + (I*kA^2*Y2*ya2)/
         (kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) +
        (I*kB^2*Y2*ya2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) - (I*Y2^3*ya2)/(kA^4 - 2*kA^2*kB^2 + kB^4 -
          2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4), ((-I)*Y3)/(kB^2 - Y3^2) -
        (I*Y3*ya3)/(kB^2 - Y3^2), -2/kB - (4*muB)/kB -
        (2*kA^2*kB*muB)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) + (2*kB^3*muB)/(kA^4 - 2*kA^2*kB^2 + kB^4 -
          2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) - (2*kB*muB*Y2^2)/
         (kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) +
        (2*kB*muB)/(kB^2 - Y3^2) + (kA^2*kB*ya2)/(kA^4 - 2*kA^2*kB^2 + kB^4 -
          2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) - (kB^3*ya2)/
         (kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) +
        (kB*Y2^2*ya2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) - (kB*ya3)/(kB^2 - Y3^2), 0,
       (2*kA^3*muA)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 +
          Y2^4) - (2*kA*kB^2*muA)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) - (2*kA*muA*Y2^2)/(kA^4 - 2*kA^2*kB^2 + kB^4 -
          2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) - (kA^3*ya2)/
         (kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) +
        (kA*kB^2*ya2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) + (kA*Y2^2*ya2)/(kA^4 - 2*kA^2*kB^2 + kB^4 -
          2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4), 0,
       ((-2*I)*kA*kB*Y2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) - ((4*I)*kA*kB*muA*Y2)/(kA^4 - 2*kA^2*kB^2 +
          kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) - ((4*I)*kA*kB*muB*Y2)/
         (kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) +
        ((2*I)*kA*kB*Y2*ya2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4), 0, 0, 0, 0, 0, 0, 0, 0, 0,
       kA^3/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) -
        (kA*kB^2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 +
          Y2^4) - (kA*Y2^2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4), 0, ((-2*I)*kA*kB*Y2)/(kA^4 - 2*kA^2*kB^2 +
         kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4)},
      {((-2*I)*kA^2*kB^2*Y2)/(kA^5*kB - 2*kA^3*kB^3 + kA*kB^5 -
          2*kA^3*kB*Y2^2 - 2*kA*kB^3*Y2^2 + kA*kB*Y2^4) -
        ((2*I)*kA^2*kB^2*Y2*ya2)/(kA^5*kB - 2*kA^3*kB^3 + kA*kB^5 -
          2*kA^3*kB*Y2^2 - 2*kA*kB^3*Y2^2 + kA*kB*Y2^4), 0,
       (2*kA^4*kB*muB)/(kA^5*kB - 2*kA^3*kB^3 + kA*kB^5 - 2*kA^3*kB*Y2^2 -
          2*kA*kB^3*Y2^2 + kA*kB*Y2^4) - (2*kA^2*kB^3*muB)/
         (kA^5*kB - 2*kA^3*kB^3 + kA*kB^5 - 2*kA^3*kB*Y2^2 - 2*kA*kB^3*Y2^2 +
          kA*kB*Y2^4) - (2*kA^2*kB*muB*Y2^2)/(kA^5*kB - 2*kA^3*kB^3 +
          kA*kB^5 - 2*kA^3*kB*Y2^2 - 2*kA*kB^3*Y2^2 + kA*kB*Y2^4) -
        (kA^4*kB*ya2)/(kA^5*kB - 2*kA^3*kB^3 + kA*kB^5 - 2*kA^3*kB*Y2^2 -
          2*kA*kB^3*Y2^2 + kA*kB*Y2^4) + (kA^2*kB^3*ya2)/
         (kA^5*kB - 2*kA^3*kB^3 + kA*kB^5 - 2*kA^3*kB*Y2^2 - 2*kA*kB^3*Y2^2 +
          kA*kB*Y2^4) + (kA^2*kB*Y2^2*ya2)/(kA^5*kB - 2*kA^3*kB^3 + kA*kB^5 -
          2*kA^3*kB*Y2^2 - 2*kA*kB^3*Y2^2 + kA*kB*Y2^4), 0,
       (-2*kA^3*kB^2*muA)/(kA^5*kB - 2*kA^3*kB^3 + kA*kB^5 - 2*kA^3*kB*Y2^2 -
          2*kA*kB^3*Y2^2 + kA*kB*Y2^4) + (2*kA*kB^4*muA)/
         (kA^5*kB - 2*kA^3*kB^3 + kA*kB^5 - 2*kA^3*kB*Y2^2 - 2*kA*kB^3*Y2^2 +
          kA*kB*Y2^4) - (2*kA*kB^2*muA*Y2^2)/(kA^5*kB - 2*kA^3*kB^3 +
          kA*kB^5 - 2*kA^3*kB*Y2^2 - 2*kA*kB^3*Y2^2 + kA*kB*Y2^4) -
        kB/(kB^2 - Y3^2) + (kA^3*kB^2*ya2)/(kA^5*kB - 2*kA^3*kB^3 + kA*kB^5 -
          2*kA^3*kB*Y2^2 - 2*kA*kB^3*Y2^2 + kA*kB*Y2^4) -
        (kA*kB^4*ya2)/(kA^5*kB - 2*kA^3*kB^3 + kA*kB^5 - 2*kA^3*kB*Y2^2 -
          2*kA*kB^3*Y2^2 + kA*kB*Y2^4) + (kA*kB^2*Y2^2*ya2)/
         (kA^5*kB - 2*kA^3*kB^3 + kA*kB^5 - 2*kA^3*kB*Y2^2 - 2*kA*kB^3*Y2^2 +
          kA*kB*Y2^4) - (kB*ya3)/(kB^2 - Y3^2),
       ((-2*I)*muB*Y3)/(kB^2 - Y3^2) + (I*Y3*ya3)/(kB^2 - Y3^2),
       (I*kA^3*kB*Y2)/(kA^5*kB - 2*kA^3*kB^3 + kA*kB^5 - 2*kA^3*kB*Y2^2 -
          2*kA*kB^3*Y2^2 + kA*kB*Y2^4) + (I*kA*kB^3*Y2)/
         (kA^5*kB - 2*kA^3*kB^3 + kA*kB^5 - 2*kA^3*kB*Y2^2 - 2*kA*kB^3*Y2^2 +
          kA*kB*Y2^4) + ((2*I)*kA^3*kB*muA*Y2)/(kA^5*kB - 2*kA^3*kB^3 +
          kA*kB^5 - 2*kA^3*kB*Y2^2 - 2*kA*kB^3*Y2^2 + kA*kB*Y2^4) +
        ((2*I)*kA*kB^3*muA*Y2)/(kA^5*kB - 2*kA^3*kB^3 + kA*kB^5 -
          2*kA^3*kB*Y2^2 - 2*kA*kB^3*Y2^2 + kA*kB*Y2^4) +
        ((2*I)*kA^3*kB*muB*Y2)/(kA^5*kB - 2*kA^3*kB^3 + kA*kB^5 -
          2*kA^3*kB*Y2^2 - 2*kA*kB^3*Y2^2 + kA*kB*Y2^4) +
        ((2*I)*kA*kB^3*muB*Y2)/(kA^5*kB - 2*kA^3*kB^3 + kA*kB^5 -
          2*kA^3*kB*Y2^2 - 2*kA*kB^3*Y2^2 + kA*kB*Y2^4) -
        (I*kA*kB*Y2^3)/(kA^5*kB - 2*kA^3*kB^3 + kA*kB^5 - 2*kA^3*kB*Y2^2 -
          2*kA*kB^3*Y2^2 + kA*kB*Y2^4) - ((2*I)*kA*kB*muA*Y2^3)/
         (kA^5*kB - 2*kA^3*kB^3 + kA*kB^5 - 2*kA^3*kB*Y2^2 - 2*kA*kB^3*Y2^2 +
          kA*kB*Y2^4) - ((2*I)*kA*kB*muB*Y2^3)/(kA^5*kB - 2*kA^3*kB^3 +
          kA*kB^5 - 2*kA^3*kB*Y2^2 - 2*kA*kB^3*Y2^2 + kA*kB*Y2^4) -
        (I*kA^3*kB*Y2*ya2)/(kA^5*kB - 2*kA^3*kB^3 + kA*kB^5 -
          2*kA^3*kB*Y2^2 - 2*kA*kB^3*Y2^2 + kA*kB*Y2^4) -
        (I*kA*kB^3*Y2*ya2)/(kA^5*kB - 2*kA^3*kB^3 + kA*kB^5 -
          2*kA^3*kB*Y2^2 - 2*kA*kB^3*Y2^2 + kA*kB*Y2^4) +
        (I*kA*kB*Y2^3*ya2)/(kA^5*kB - 2*kA^3*kB^3 + kA*kB^5 -
          2*kA^3*kB*Y2^2 - 2*kA*kB^3*Y2^2 + kA*kB*Y2^4), 0, 0, 0, 0, 0, 0, 0,
       0, 0, -((kA^3*kB^2)/(kA^5*kB - 2*kA^3*kB^3 + kA*kB^5 -
           2*kA^3*kB*Y2^2 - 2*kA*kB^3*Y2^2 + kA*kB*Y2^4)) +
        (kA*kB^4)/(kA^5*kB - 2*kA^3*kB^3 + kA*kB^5 - 2*kA^3*kB*Y2^2 -
          2*kA*kB^3*Y2^2 + kA*kB*Y2^4) - (kA*kB^2*Y2^2)/
         (kA^5*kB - 2*kA^3*kB^3 + kA*kB^5 - 2*kA^3*kB*Y2^2 - 2*kA*kB^3*Y2^2 +
          kA*kB*Y2^4), 0, (I*kA^3*kB*Y2)/(kA^5*kB - 2*kA^3*kB^3 + kA*kB^5 -
          2*kA^3*kB*Y2^2 - 2*kA*kB^3*Y2^2 + kA*kB*Y2^4) +
        (I*kA*kB^3*Y2)/(kA^5*kB - 2*kA^3*kB^3 + kA*kB^5 - 2*kA^3*kB*Y2^2 -
          2*kA*kB^3*Y2^2 + kA*kB*Y2^4) - (I*kA*kB*Y2^3)/
         (kA^5*kB - 2*kA^3*kB^3 + kA*kB^5 - 2*kA^3*kB*Y2^2 - 2*kA*kB^3*Y2^2 +
          kA*kB*Y2^4), 0}, {0, ((-2*I)*kA^2*kB^2*Y2)/(kA^5*kB - 2*kA^3*kB^3 +
          kA*kB^5 - 2*kA^3*kB*Y2^2 - 2*kA*kB^3*Y2^2 + kA*kB*Y2^4) -
        ((2*I)*kA^2*kB^2*Y2*ya2)/(kA^5*kB - 2*kA^3*kB^3 + kA*kB^5 -
          2*kA^3*kB*Y2^2 - 2*kA*kB^3*Y2^2 + kA*kB*Y2^4), 0,
       (2*kA^4*kB*muB)/(kA^5*kB - 2*kA^3*kB^3 + kA*kB^5 - 2*kA^3*kB*Y2^2 -
          2*kA*kB^3*Y2^2 + kA*kB*Y2^4) - (2*kA^2*kB^3*muB)/
         (kA^5*kB - 2*kA^3*kB^3 + kA*kB^5 - 2*kA^3*kB*Y2^2 - 2*kA*kB^3*Y2^2 +
          kA*kB*Y2^4) - (2*kA^2*kB*muB*Y2^2)/(kA^5*kB - 2*kA^3*kB^3 +
          kA*kB^5 - 2*kA^3*kB*Y2^2 - 2*kA*kB^3*Y2^2 + kA*kB*Y2^4) -
        (kA^4*kB*ya2)/(kA^5*kB - 2*kA^3*kB^3 + kA*kB^5 - 2*kA^3*kB*Y2^2 -
          2*kA*kB^3*Y2^2 + kA*kB*Y2^4) + (kA^2*kB^3*ya2)/
         (kA^5*kB - 2*kA^3*kB^3 + kA*kB^5 - 2*kA^3*kB*Y2^2 - 2*kA*kB^3*Y2^2 +
          kA*kB*Y2^4) + (kA^2*kB*Y2^2*ya2)/(kA^5*kB - 2*kA^3*kB^3 + kA*kB^5 -
          2*kA^3*kB*Y2^2 - 2*kA*kB^3*Y2^2 + kA*kB*Y2^4),
       ((-I)*Y3)/(kB^2 - Y3^2) - (I*Y3*ya3)/(kB^2 - Y3^2),
       -kB^(-1) - (2*muB)/kB - (2*kA^3*kB^2*muA)/(kA^5*kB - 2*kA^3*kB^3 +
          kA*kB^5 - 2*kA^3*kB*Y2^2 - 2*kA*kB^3*Y2^2 + kA*kB*Y2^4) +
        (2*kA*kB^4*muA)/(kA^5*kB - 2*kA^3*kB^3 + kA*kB^5 - 2*kA^3*kB*Y2^2 -
          2*kA*kB^3*Y2^2 + kA*kB*Y2^4) - (2*kA*kB^2*muA*Y2^2)/
         (kA^5*kB - 2*kA^3*kB^3 + kA*kB^5 - 2*kA^3*kB*Y2^2 - 2*kA*kB^3*Y2^2 +
          kA*kB*Y2^4) + (2*kB*muB)/(kB^2 - Y3^2) + (kA^3*kB^2*ya2)/
         (kA^5*kB - 2*kA^3*kB^3 + kA*kB^5 - 2*kA^3*kB*Y2^2 - 2*kA*kB^3*Y2^2 +
          kA*kB*Y2^4) - (kA*kB^4*ya2)/(kA^5*kB - 2*kA^3*kB^3 + kA*kB^5 -
          2*kA^3*kB*Y2^2 - 2*kA*kB^3*Y2^2 + kA*kB*Y2^4) +
        (kA*kB^2*Y2^2*ya2)/(kA^5*kB - 2*kA^3*kB^3 + kA*kB^5 -
          2*kA^3*kB*Y2^2 - 2*kA*kB^3*Y2^2 + kA*kB*Y2^4) -
        (kB*ya3)/(kB^2 - Y3^2), 0, (I*kA^3*kB*Y2)/(kA^5*kB - 2*kA^3*kB^3 +
          kA*kB^5 - 2*kA^3*kB*Y2^2 - 2*kA*kB^3*Y2^2 + kA*kB*Y2^4) +
        (I*kA*kB^3*Y2)/(kA^5*kB - 2*kA^3*kB^3 + kA*kB^5 - 2*kA^3*kB*Y2^2 -
          2*kA*kB^3*Y2^2 + kA*kB*Y2^4) + ((2*I)*kA^3*kB*muA*Y2)/
         (kA^5*kB - 2*kA^3*kB^3 + kA*kB^5 - 2*kA^3*kB*Y2^2 - 2*kA*kB^3*Y2^2 +
          kA*kB*Y2^4) + ((2*I)*kA*kB^3*muA*Y2)/(kA^5*kB - 2*kA^3*kB^3 +
          kA*kB^5 - 2*kA^3*kB*Y2^2 - 2*kA*kB^3*Y2^2 + kA*kB*Y2^4) +
        ((2*I)*kA^3*kB*muB*Y2)/(kA^5*kB - 2*kA^3*kB^3 + kA*kB^5 -
          2*kA^3*kB*Y2^2 - 2*kA*kB^3*Y2^2 + kA*kB*Y2^4) +
        ((2*I)*kA*kB^3*muB*Y2)/(kA^5*kB - 2*kA^3*kB^3 + kA*kB^5 -
          2*kA^3*kB*Y2^2 - 2*kA*kB^3*Y2^2 + kA*kB*Y2^4) -
        (I*kA*kB*Y2^3)/(kA^5*kB - 2*kA^3*kB^3 + kA*kB^5 - 2*kA^3*kB*Y2^2 -
          2*kA*kB^3*Y2^2 + kA*kB*Y2^4) - ((2*I)*kA*kB*muA*Y2^3)/
         (kA^5*kB - 2*kA^3*kB^3 + kA*kB^5 - 2*kA^3*kB*Y2^2 - 2*kA*kB^3*Y2^2 +
          kA*kB*Y2^4) - ((2*I)*kA*kB*muB*Y2^3)/(kA^5*kB - 2*kA^3*kB^3 +
          kA*kB^5 - 2*kA^3*kB*Y2^2 - 2*kA*kB^3*Y2^2 + kA*kB*Y2^4) -
        (I*kA^3*kB*Y2*ya2)/(kA^5*kB - 2*kA^3*kB^3 + kA*kB^5 -
          2*kA^3*kB*Y2^2 - 2*kA*kB^3*Y2^2 + kA*kB*Y2^4) -
        (I*kA*kB^3*Y2*ya2)/(kA^5*kB - 2*kA^3*kB^3 + kA*kB^5 -
          2*kA^3*kB*Y2^2 - 2*kA*kB^3*Y2^2 + kA*kB*Y2^4) +
        (I*kA*kB*Y2^3*ya2)/(kA^5*kB - 2*kA^3*kB^3 + kA*kB^5 -
          2*kA^3*kB*Y2^2 - 2*kA*kB^3*Y2^2 + kA*kB*Y2^4), 0, 0, 0, 0, 0, 0, 0,
       0, 0, -((kA^3*kB^2)/(kA^5*kB - 2*kA^3*kB^3 + kA*kB^5 -
           2*kA^3*kB*Y2^2 - 2*kA*kB^3*Y2^2 + kA*kB*Y2^4)) +
        (kA*kB^4)/(kA^5*kB - 2*kA^3*kB^3 + kA*kB^5 - 2*kA^3*kB*Y2^2 -
          2*kA*kB^3*Y2^2 + kA*kB*Y2^4) - (kA*kB^2*Y2^2)/
         (kA^5*kB - 2*kA^3*kB^3 + kA*kB^5 - 2*kA^3*kB*Y2^2 - 2*kA*kB^3*Y2^2 +
          kA*kB*Y2^4), 0, (I*kA^3*kB*Y2)/(kA^5*kB - 2*kA^3*kB^3 + kA*kB^5 -
          2*kA^3*kB*Y2^2 - 2*kA*kB^3*Y2^2 + kA*kB*Y2^4) +
        (I*kA*kB^3*Y2)/(kA^5*kB - 2*kA^3*kB^3 + kA*kB^5 - 2*kA^3*kB*Y2^2 -
          2*kA*kB^3*Y2^2 + kA*kB*Y2^4) - (I*kA*kB*Y2^3)/
         (kA^5*kB - 2*kA^3*kB^3 + kA*kB^5 - 2*kA^3*kB*Y2^2 - 2*kA*kB^3*Y2^2 +
          kA*kB*Y2^4)}, {kA^3/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) - (kA*kB^2)/(kA^4 - 2*kA^2*kB^2 + kB^4 -
          2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) - (kA*Y2^2)/(kA^4 - 2*kA^2*kB^2 +
          kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) +
        (kA^3*ya2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 +
          Y2^4) - (kA*kB^2*ya2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) - (kA*Y2^2*ya2)/(kA^4 - 2*kA^2*kB^2 + kB^4 -
          2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4), 0,
       ((4*I)*kA*kB*muB*Y2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) - ((2*I)*kA*kB*Y2*ya2)/(kA^4 - 2*kA^2*kB^2 +
          kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4), 0,
       ((-2*I)*kA^2*muA*Y2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) - ((2*I)*kB^2*muA*Y2)/(kA^4 - 2*kA^2*kB^2 +
          kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) + ((2*I)*muA*Y2^3)/
         (kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) +
        (I*kA^2*Y2*ya2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) + (I*kB^2*Y2*ya2)/(kA^4 - 2*kA^2*kB^2 + kB^4 -
          2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) - (I*Y2^3*ya2)/
         (kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4), 0,
       -kB^(-1) - (2*muB)/kB - (kA^2*kB)/(kA^4 - 2*kA^2*kB^2 + kB^4 -
          2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) + kB^3/(kA^4 - 2*kA^2*kB^2 +
          kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) - (2*kA^2*kB*muA)/
         (kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) +
        (2*kB^3*muA)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 +
          Y2^4) - (2*kA^2*kB*muB)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) + (2*kB^3*muB)/(kA^4 - 2*kA^2*kB^2 + kB^4 -
          2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) - (kB*Y2^2)/(kA^4 - 2*kA^2*kB^2 +
          kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) - (2*kB*muA*Y2^2)/
         (kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) -
        (2*kB*muB*Y2^2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) - kB/(kB^2 - Y3^2) + (kA^2*kB*ya2)/
         (kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) -
        (kB^3*ya2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 +
          Y2^4) + (kB*Y2^2*ya2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) - (kB*ya3)/(kB^2 - Y3^2),
       ((-2*I)*muB*Y3)/(kB^2 - Y3^2) + (I*Y3*ya3)/(kB^2 - Y3^2), 0, 0, 0, 0,
       0, 0, 0, 0, ((-I)*kA^2*Y2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) - (I*kB^2*Y2)/(kA^4 - 2*kA^2*kB^2 + kB^4 -
          2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) + (I*Y2^3)/(kA^4 - 2*kA^2*kB^2 +
          kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4), 0,
       -((kA^2*kB)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 +
           Y2^4)) + kB^3/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) - (kB*Y2^2)/(kA^4 - 2*kA^2*kB^2 + kB^4 -
          2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4), 0},
      {0, kA^3/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 +
          Y2^4) - (kA*kB^2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) - (kA*Y2^2)/(kA^4 - 2*kA^2*kB^2 + kB^4 -
          2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) + (kA^3*ya2)/
         (kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) -
        (kA*kB^2*ya2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) - (kA*Y2^2*ya2)/(kA^4 - 2*kA^2*kB^2 + kB^4 -
          2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4), 0,
       ((4*I)*kA*kB*muB*Y2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) - ((2*I)*kA*kB*Y2*ya2)/(kA^4 - 2*kA^2*kB^2 +
          kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4), 0,
       ((-2*I)*kA^2*muA*Y2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) - ((2*I)*kB^2*muA*Y2)/(kA^4 - 2*kA^2*kB^2 +
          kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) + ((2*I)*muA*Y2^3)/
         (kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) +
        (I*kA^2*Y2*ya2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) + (I*kB^2*Y2*ya2)/(kA^4 - 2*kA^2*kB^2 + kB^4 -
          2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) - (I*Y2^3*ya2)/
         (kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4),
       ((-I)*Y3)/(kB^2 - Y3^2) - (I*Y3*ya3)/(kB^2 - Y3^2),
       -2/kB - (4*muB)/kB - (kA^2*kB)/(kA^4 - 2*kA^2*kB^2 + kB^4 -
          2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) + kB^3/(kA^4 - 2*kA^2*kB^2 +
          kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) - (2*kA^2*kB*muA)/
         (kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) +
        (2*kB^3*muA)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 +
          Y2^4) - (2*kA^2*kB*muB)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) + (2*kB^3*muB)/(kA^4 - 2*kA^2*kB^2 + kB^4 -
          2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) - (kB*Y2^2)/(kA^4 - 2*kA^2*kB^2 +
          kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) - (2*kB*muA*Y2^2)/
         (kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) -
        (2*kB*muB*Y2^2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) + (2*kB*muB)/(kB^2 - Y3^2) +
        (kA^2*kB*ya2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) - (kB^3*ya2)/(kA^4 - 2*kA^2*kB^2 + kB^4 -
          2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) + (kB*Y2^2*ya2)/
         (kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) -
        (kB*ya3)/(kB^2 - Y3^2), 0, 0, 0, 0, 0, 0, 0, 0, 0,
       ((-I)*kA^2*Y2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) - (I*kB^2*Y2)/(kA^4 - 2*kA^2*kB^2 + kB^4 -
          2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) + (I*Y2^3)/(kA^4 - 2*kA^2*kB^2 +
          kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4), 0,
       -((kA^2*kB)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 +
           Y2^4)) + kB^3/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) - (kB*Y2^2)/(kA^4 - 2*kA^2*kB^2 + kB^4 -
          2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4)}, {0, 0, 0, 0, 0, 0, 0, 0,
       (kA^2*kB)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 +
          Y2^4) - kB^3/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) + (kB*Y2^2)/(kA^4 - 2*kA^2*kB^2 + kB^4 -
          2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) - kB/(kB^2 - Y3^2) +
        (kA^2*kB*ya2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) - (kB^3*ya2)/(kA^4 - 2*kA^2*kB^2 + kB^4 -
          2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) + (kB*Y2^2*ya2)/
         (kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) -
        (kB*ya3)/(kB^2 - Y3^2), ((-2*I)*muB*Y3)/(kB^2 - Y3^2) +
        (I*Y3*ya3)/(kB^2 - Y3^2), ((2*I)*kA^2*muB*Y2)/(kA^4 - 2*kA^2*kB^2 +
          kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) + ((2*I)*kB^2*muB*Y2)/
         (kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) -
        ((2*I)*muB*Y2^3)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) - (I*kA^2*Y2*ya2)/(kA^4 - 2*kA^2*kB^2 + kB^4 -
          2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) - (I*kB^2*Y2*ya2)/
         (kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) +
        (I*Y2^3*ya2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 +
          Y2^4), 0, ((-4*I)*kA*kB*muA*Y2)/(kA^4 - 2*kA^2*kB^2 + kB^4 -
          2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) + ((2*I)*kA*kB*Y2*ya2)/
         (kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4), 0,
       -(kA^3/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 +
           Y2^4)) + (kA*kB^2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) - (2*kA^3*muA)/(kA^4 - 2*kA^2*kB^2 + kB^4 -
          2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) + (2*kA*kB^2*muA)/
         (kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) -
        (2*kA^3*muB)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 +
          Y2^4) + (2*kA*kB^2*muB)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) + (kA*Y2^2)/(kA^4 - 2*kA^2*kB^2 + kB^4 -
          2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) + (2*kA*muA*Y2^2)/
         (kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) +
        (2*kA*muB*Y2^2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) + (kA^3*ya2)/(kA^4 - 2*kA^2*kB^2 + kB^4 -
          2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) - (kA*kB^2*ya2)/
         (kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) -
        (kA*Y2^2*ya2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4), 0, (kA^2*kB)/(kA^4 - 2*kA^2*kB^2 + kB^4 -
          2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) - kB^3/(kA^4 - 2*kA^2*kB^2 +
          kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) +
        (kB*Y2^2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 +
          Y2^4), 0, ((-I)*kA^2*Y2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) - (I*kB^2*Y2)/(kA^4 - 2*kA^2*kB^2 + kB^4 -
          2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) + (I*Y2^3)/(kA^4 - 2*kA^2*kB^2 +
          kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4), 0},
      {0, 0, 0, 0, 0, 0, 0, 0, ((-I)*Y3)/(kB^2 - Y3^2) -
        (I*Y3*ya3)/(kB^2 - Y3^2), -kB^(-1) - (2*muB)/kB +
        (kA^2*kB)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 +
          Y2^4) - kB^3/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) + (kB*Y2^2)/(kA^4 - 2*kA^2*kB^2 + kB^4 -
          2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) + (2*kB*muB)/(kB^2 - Y3^2) +
        (kA^2*kB*ya2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) - (kB^3*ya2)/(kA^4 - 2*kA^2*kB^2 + kB^4 -
          2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) + (kB*Y2^2*ya2)/
         (kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) -
        (kB*ya3)/(kB^2 - Y3^2), 0, ((2*I)*kA^2*muB*Y2)/(kA^4 - 2*kA^2*kB^2 +
          kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) + ((2*I)*kB^2*muB*Y2)/
         (kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) -
        ((2*I)*muB*Y2^3)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) - (I*kA^2*Y2*ya2)/(kA^4 - 2*kA^2*kB^2 + kB^4 -
          2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) - (I*kB^2*Y2*ya2)/
         (kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) +
        (I*Y2^3*ya2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 +
          Y2^4), 0, ((-4*I)*kA*kB*muA*Y2)/(kA^4 - 2*kA^2*kB^2 + kB^4 -
          2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) + ((2*I)*kA*kB*Y2*ya2)/
         (kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4), 0,
       -(kA^3/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 +
           Y2^4)) + (kA*kB^2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) - (2*kA^3*muA)/(kA^4 - 2*kA^2*kB^2 + kB^4 -
          2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) + (2*kA*kB^2*muA)/
         (kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) -
        (2*kA^3*muB)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 +
          Y2^4) + (2*kA*kB^2*muB)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) + (kA*Y2^2)/(kA^4 - 2*kA^2*kB^2 + kB^4 -
          2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) + (2*kA*muA*Y2^2)/
         (kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) +
        (2*kA*muB*Y2^2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) + (kA^3*ya2)/(kA^4 - 2*kA^2*kB^2 + kB^4 -
          2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) - (kA*kB^2*ya2)/
         (kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) -
        (kA*Y2^2*ya2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4), 0, (kA^2*kB)/(kA^4 - 2*kA^2*kB^2 + kB^4 -
          2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) - kB^3/(kA^4 - 2*kA^2*kB^2 +
          kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) +
        (kB*Y2^2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 +
          Y2^4), 0, ((-I)*kA^2*Y2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) - (I*kB^2*Y2)/(kA^4 - 2*kA^2*kB^2 + kB^4 -
          2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) + (I*Y2^3)/(kA^4 - 2*kA^2*kB^2 +
          kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4)}, {0, 0, 0, 0, 0, 0, 0, 0,
       (I*kA^2*Y2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 +
          Y2^4) + (I*kB^2*Y2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) - (I*Y2^3)/(kA^4 - 2*kA^2*kB^2 + kB^4 -
          2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) + (I*kA^2*Y2*ya2)/
         (kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) +
        (I*kB^2*Y2*ya2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) - (I*Y2^3*ya2)/(kA^4 - 2*kA^2*kB^2 + kB^4 -
          2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4), 0, -kB^(-1) - (2*muB)/kB -
        (2*kA^2*kB*muB)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) + (2*kB^3*muB)/(kA^4 - 2*kA^2*kB^2 + kB^4 -
          2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) - (2*kB*muB*Y2^2)/
         (kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) -
        kB/(kB^2 - Y3^2) + (kA^2*kB*ya2)/(kA^4 - 2*kA^2*kB^2 + kB^4 -
          2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) - (kB^3*ya2)/
         (kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) +
        (kB*Y2^2*ya2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) - (kB*ya3)/(kB^2 - Y3^2),
       ((-2*I)*muB*Y3)/(kB^2 - Y3^2) + (I*Y3*ya3)/(kB^2 - Y3^2),
       (2*kA^3*muA)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 +
          Y2^4) - (2*kA*kB^2*muA)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) - (2*kA*muA*Y2^2)/(kA^4 - 2*kA^2*kB^2 + kB^4 -
          2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) - (kA^3*ya2)/
         (kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) +
        (kA*kB^2*ya2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) + (kA*Y2^2*ya2)/(kA^4 - 2*kA^2*kB^2 + kB^4 -
          2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4), 0,
       ((-2*I)*kA*kB*Y2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) - ((4*I)*kA*kB*muA*Y2)/(kA^4 - 2*kA^2*kB^2 +
          kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) - ((4*I)*kA*kB*muB*Y2)/
         (kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) +
        ((2*I)*kA*kB*Y2*ya2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4), 0, (I*kA^2*Y2)/(kA^4 - 2*kA^2*kB^2 + kB^4 -
          2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) + (I*kB^2*Y2)/
         (kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) -
        (I*Y2^3)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 +
          Y2^4), 0, (kA^2*kB)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) - kB^3/(kA^4 - 2*kA^2*kB^2 + kB^4 -
          2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) + (kB*Y2^2)/(kA^4 - 2*kA^2*kB^2 +
          kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4), 0},
      {0, 0, 0, 0, 0, 0, 0, 0, 0, (I*kA^2*Y2)/(kA^4 - 2*kA^2*kB^2 + kB^4 -
          2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) + (I*kB^2*Y2)/
         (kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) -
        (I*Y2^3)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 +
          Y2^4) + (I*kA^2*Y2*ya2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) + (I*kB^2*Y2*ya2)/(kA^4 - 2*kA^2*kB^2 + kB^4 -
          2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) - (I*Y2^3*ya2)/
         (kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4),
       ((-I)*Y3)/(kB^2 - Y3^2) - (I*Y3*ya3)/(kB^2 - Y3^2),
       -2/kB - (4*muB)/kB - (2*kA^2*kB*muB)/(kA^4 - 2*kA^2*kB^2 + kB^4 -
          2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) + (2*kB^3*muB)/
         (kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) -
        (2*kB*muB*Y2^2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) + (2*kB*muB)/(kB^2 - Y3^2) +
        (kA^2*kB*ya2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) - (kB^3*ya2)/(kA^4 - 2*kA^2*kB^2 + kB^4 -
          2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) + (kB*Y2^2*ya2)/
         (kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) -
        (kB*ya3)/(kB^2 - Y3^2), 0, (2*kA^3*muA)/(kA^4 - 2*kA^2*kB^2 + kB^4 -
          2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) - (2*kA*kB^2*muA)/
         (kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) -
        (2*kA*muA*Y2^2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) - (kA^3*ya2)/(kA^4 - 2*kA^2*kB^2 + kB^4 -
          2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) + (kA*kB^2*ya2)/
         (kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) +
        (kA*Y2^2*ya2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4), 0, ((-2*I)*kA*kB*Y2)/(kA^4 - 2*kA^2*kB^2 +
          kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) - ((4*I)*kA*kB*muA*Y2)/
         (kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) -
        ((4*I)*kA*kB*muB*Y2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) + ((2*I)*kA*kB*Y2*ya2)/(kA^4 - 2*kA^2*kB^2 +
          kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4), 0,
       (I*kA^2*Y2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 +
          Y2^4) + (I*kB^2*Y2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) - (I*Y2^3)/(kA^4 - 2*kA^2*kB^2 + kB^4 -
          2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4), 0,
       (kA^2*kB)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 +
          Y2^4) - kB^3/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) + (kB*Y2^2)/(kA^4 - 2*kA^2*kB^2 + kB^4 -
          2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4)}, {0, 0, 0, 0, 0, 0, 0, 0,
       ((2*I)*kA^3*kB*Y2)/(-kA^6 + 2*kA^4*kB^2 - kA^2*kB^4 + 2*kA^4*Y2^2 +
          2*kA^2*kB^2*Y2^2 - kA^2*Y2^4) + ((2*I)*kA^3*kB*Y2*ya2)/
         (-kA^6 + 2*kA^4*kB^2 - kA^2*kB^4 + 2*kA^4*Y2^2 + 2*kA^2*kB^2*Y2^2 -
          kA^2*Y2^4), 0, (-2*kA^5*muB)/(-kA^6 + 2*kA^4*kB^2 - kA^2*kB^4 +
          2*kA^4*Y2^2 + 2*kA^2*kB^2*Y2^2 - kA^2*Y2^4) +
        (2*kA^3*kB^2*muB)/(-kA^6 + 2*kA^4*kB^2 - kA^2*kB^4 + 2*kA^4*Y2^2 +
          2*kA^2*kB^2*Y2^2 - kA^2*Y2^4) + (2*kA^3*muB*Y2^2)/
         (-kA^6 + 2*kA^4*kB^2 - kA^2*kB^4 + 2*kA^4*Y2^2 + 2*kA^2*kB^2*Y2^2 -
          kA^2*Y2^4) + (kA^5*ya2)/(-kA^6 + 2*kA^4*kB^2 - kA^2*kB^4 +
          2*kA^4*Y2^2 + 2*kA^2*kB^2*Y2^2 - kA^2*Y2^4) -
        (kA^3*kB^2*ya2)/(-kA^6 + 2*kA^4*kB^2 - kA^2*kB^4 + 2*kA^4*Y2^2 +
          2*kA^2*kB^2*Y2^2 - kA^2*Y2^4) - (kA^3*Y2^2*ya2)/
         (-kA^6 + 2*kA^4*kB^2 - kA^2*kB^4 + 2*kA^4*Y2^2 + 2*kA^2*kB^2*Y2^2 -
          kA^2*Y2^4), 0, (2*kA^4*kB*muA)/(-kA^6 + 2*kA^4*kB^2 - kA^2*kB^4 +
          2*kA^4*Y2^2 + 2*kA^2*kB^2*Y2^2 - kA^2*Y2^4) -
        (2*kA^2*kB^3*muA)/(-kA^6 + 2*kA^4*kB^2 - kA^2*kB^4 + 2*kA^4*Y2^2 +
          2*kA^2*kB^2*Y2^2 - kA^2*Y2^4) + (2*kA^2*kB*muA*Y2^2)/
         (-kA^6 + 2*kA^4*kB^2 - kA^2*kB^4 + 2*kA^4*Y2^2 + 2*kA^2*kB^2*Y2^2 -
          kA^2*Y2^4) - kB/(kB^2 - Y3^2) - (kA^4*kB*ya2)/
         (-kA^6 + 2*kA^4*kB^2 - kA^2*kB^4 + 2*kA^4*Y2^2 + 2*kA^2*kB^2*Y2^2 -
          kA^2*Y2^4) + (kA^2*kB^3*ya2)/(-kA^6 + 2*kA^4*kB^2 - kA^2*kB^4 +
          2*kA^4*Y2^2 + 2*kA^2*kB^2*Y2^2 - kA^2*Y2^4) -
        (kA^2*kB*Y2^2*ya2)/(-kA^6 + 2*kA^4*kB^2 - kA^2*kB^4 + 2*kA^4*Y2^2 +
          2*kA^2*kB^2*Y2^2 - kA^2*Y2^4) - (kB*ya3)/(kB^2 - Y3^2),
       ((-2*I)*muB*Y3)/(kB^2 - Y3^2) + (I*Y3*ya3)/(kB^2 - Y3^2),
       ((-I)*kA^4*Y2)/(-kA^6 + 2*kA^4*kB^2 - kA^2*kB^4 + 2*kA^4*Y2^2 +
          2*kA^2*kB^2*Y2^2 - kA^2*Y2^4) - (I*kA^2*kB^2*Y2)/
         (-kA^6 + 2*kA^4*kB^2 - kA^2*kB^4 + 2*kA^4*Y2^2 + 2*kA^2*kB^2*Y2^2 -
          kA^2*Y2^4) - ((2*I)*kA^4*muA*Y2)/(-kA^6 + 2*kA^4*kB^2 - kA^2*kB^4 +
          2*kA^4*Y2^2 + 2*kA^2*kB^2*Y2^2 - kA^2*Y2^4) -
        ((2*I)*kA^2*kB^2*muA*Y2)/(-kA^6 + 2*kA^4*kB^2 - kA^2*kB^4 +
          2*kA^4*Y2^2 + 2*kA^2*kB^2*Y2^2 - kA^2*Y2^4) -
        ((2*I)*kA^4*muB*Y2)/(-kA^6 + 2*kA^4*kB^2 - kA^2*kB^4 + 2*kA^4*Y2^2 +
          2*kA^2*kB^2*Y2^2 - kA^2*Y2^4) - ((2*I)*kA^2*kB^2*muB*Y2)/
         (-kA^6 + 2*kA^4*kB^2 - kA^2*kB^4 + 2*kA^4*Y2^2 + 2*kA^2*kB^2*Y2^2 -
          kA^2*Y2^4) + (I*kA^2*Y2^3)/(-kA^6 + 2*kA^4*kB^2 - kA^2*kB^4 +
          2*kA^4*Y2^2 + 2*kA^2*kB^2*Y2^2 - kA^2*Y2^4) +
        ((2*I)*kA^2*muA*Y2^3)/(-kA^6 + 2*kA^4*kB^2 - kA^2*kB^4 +
          2*kA^4*Y2^2 + 2*kA^2*kB^2*Y2^2 - kA^2*Y2^4) +
        ((2*I)*kA^2*muB*Y2^3)/(-kA^6 + 2*kA^4*kB^2 - kA^2*kB^4 +
          2*kA^4*Y2^2 + 2*kA^2*kB^2*Y2^2 - kA^2*Y2^4) +
        (I*kA^4*Y2*ya2)/(-kA^6 + 2*kA^4*kB^2 - kA^2*kB^4 + 2*kA^4*Y2^2 +
          2*kA^2*kB^2*Y2^2 - kA^2*Y2^4) + (I*kA^2*kB^2*Y2*ya2)/
         (-kA^6 + 2*kA^4*kB^2 - kA^2*kB^4 + 2*kA^4*Y2^2 + 2*kA^2*kB^2*Y2^2 -
          kA^2*Y2^4) - (I*kA^2*Y2^3*ya2)/(-kA^6 + 2*kA^4*kB^2 - kA^2*kB^4 +
          2*kA^4*Y2^2 + 2*kA^2*kB^2*Y2^2 - kA^2*Y2^4), 0,
       ((2*I)*kA^3*kB*Y2)/(-kA^6 + 2*kA^4*kB^2 - kA^2*kB^4 + 2*kA^4*Y2^2 +
         2*kA^2*kB^2*Y2^2 - kA^2*Y2^4), 0,
       kA^5/(-kA^6 + 2*kA^4*kB^2 - kA^2*kB^4 + 2*kA^4*Y2^2 +
          2*kA^2*kB^2*Y2^2 - kA^2*Y2^4) - (kA^3*kB^2)/(-kA^6 + 2*kA^4*kB^2 -
          kA^2*kB^4 + 2*kA^4*Y2^2 + 2*kA^2*kB^2*Y2^2 - kA^2*Y2^4) -
        (kA^3*Y2^2)/(-kA^6 + 2*kA^4*kB^2 - kA^2*kB^4 + 2*kA^4*Y2^2 +
          2*kA^2*kB^2*Y2^2 - kA^2*Y2^4), 0}, {0, 0, 0, 0, 0, 0, 0, 0, 0,
       ((2*I)*kA^3*kB*Y2)/(-kA^6 + 2*kA^4*kB^2 - kA^2*kB^4 + 2*kA^4*Y2^2 +
          2*kA^2*kB^2*Y2^2 - kA^2*Y2^4) + ((2*I)*kA^3*kB*Y2*ya2)/
         (-kA^6 + 2*kA^4*kB^2 - kA^2*kB^4 + 2*kA^4*Y2^2 + 2*kA^2*kB^2*Y2^2 -
          kA^2*Y2^4), 0, (-2*kA^5*muB)/(-kA^6 + 2*kA^4*kB^2 - kA^2*kB^4 +
          2*kA^4*Y2^2 + 2*kA^2*kB^2*Y2^2 - kA^2*Y2^4) +
        (2*kA^3*kB^2*muB)/(-kA^6 + 2*kA^4*kB^2 - kA^2*kB^4 + 2*kA^4*Y2^2 +
          2*kA^2*kB^2*Y2^2 - kA^2*Y2^4) + (2*kA^3*muB*Y2^2)/
         (-kA^6 + 2*kA^4*kB^2 - kA^2*kB^4 + 2*kA^4*Y2^2 + 2*kA^2*kB^2*Y2^2 -
          kA^2*Y2^4) + (kA^5*ya2)/(-kA^6 + 2*kA^4*kB^2 - kA^2*kB^4 +
          2*kA^4*Y2^2 + 2*kA^2*kB^2*Y2^2 - kA^2*Y2^4) -
        (kA^3*kB^2*ya2)/(-kA^6 + 2*kA^4*kB^2 - kA^2*kB^4 + 2*kA^4*Y2^2 +
          2*kA^2*kB^2*Y2^2 - kA^2*Y2^4) - (kA^3*Y2^2*ya2)/
         (-kA^6 + 2*kA^4*kB^2 - kA^2*kB^4 + 2*kA^4*Y2^2 + 2*kA^2*kB^2*Y2^2 -
          kA^2*Y2^4), ((-I)*Y3)/(kB^2 - Y3^2) - (I*Y3*ya3)/(kB^2 - Y3^2),
       -kB^(-1) - (2*muB)/kB + (2*kA^4*kB*muA)/(-kA^6 + 2*kA^4*kB^2 -
          kA^2*kB^4 + 2*kA^4*Y2^2 + 2*kA^2*kB^2*Y2^2 - kA^2*Y2^4) -
        (2*kA^2*kB^3*muA)/(-kA^6 + 2*kA^4*kB^2 - kA^2*kB^4 + 2*kA^4*Y2^2 +
          2*kA^2*kB^2*Y2^2 - kA^2*Y2^4) + (2*kA^2*kB*muA*Y2^2)/
         (-kA^6 + 2*kA^4*kB^2 - kA^2*kB^4 + 2*kA^4*Y2^2 + 2*kA^2*kB^2*Y2^2 -
          kA^2*Y2^4) + (2*kB*muB)/(kB^2 - Y3^2) - (kA^4*kB*ya2)/
         (-kA^6 + 2*kA^4*kB^2 - kA^2*kB^4 + 2*kA^4*Y2^2 + 2*kA^2*kB^2*Y2^2 -
          kA^2*Y2^4) + (kA^2*kB^3*ya2)/(-kA^6 + 2*kA^4*kB^2 - kA^2*kB^4 +
          2*kA^4*Y2^2 + 2*kA^2*kB^2*Y2^2 - kA^2*Y2^4) -
        (kA^2*kB*Y2^2*ya2)/(-kA^6 + 2*kA^4*kB^2 - kA^2*kB^4 + 2*kA^4*Y2^2 +
          2*kA^2*kB^2*Y2^2 - kA^2*Y2^4) - (kB*ya3)/(kB^2 - Y3^2), 0,
       ((-I)*kA^4*Y2)/(-kA^6 + 2*kA^4*kB^2 - kA^2*kB^4 + 2*kA^4*Y2^2 +
          2*kA^2*kB^2*Y2^2 - kA^2*Y2^4) - (I*kA^2*kB^2*Y2)/
         (-kA^6 + 2*kA^4*kB^2 - kA^2*kB^4 + 2*kA^4*Y2^2 + 2*kA^2*kB^2*Y2^2 -
          kA^2*Y2^4) - ((2*I)*kA^4*muA*Y2)/(-kA^6 + 2*kA^4*kB^2 - kA^2*kB^4 +
          2*kA^4*Y2^2 + 2*kA^2*kB^2*Y2^2 - kA^2*Y2^4) -
        ((2*I)*kA^2*kB^2*muA*Y2)/(-kA^6 + 2*kA^4*kB^2 - kA^2*kB^4 +
          2*kA^4*Y2^2 + 2*kA^2*kB^2*Y2^2 - kA^2*Y2^4) -
        ((2*I)*kA^4*muB*Y2)/(-kA^6 + 2*kA^4*kB^2 - kA^2*kB^4 + 2*kA^4*Y2^2 +
          2*kA^2*kB^2*Y2^2 - kA^2*Y2^4) - ((2*I)*kA^2*kB^2*muB*Y2)/
         (-kA^6 + 2*kA^4*kB^2 - kA^2*kB^4 + 2*kA^4*Y2^2 + 2*kA^2*kB^2*Y2^2 -
          kA^2*Y2^4) + (I*kA^2*Y2^3)/(-kA^6 + 2*kA^4*kB^2 - kA^2*kB^4 +
          2*kA^4*Y2^2 + 2*kA^2*kB^2*Y2^2 - kA^2*Y2^4) +
        ((2*I)*kA^2*muA*Y2^3)/(-kA^6 + 2*kA^4*kB^2 - kA^2*kB^4 +
          2*kA^4*Y2^2 + 2*kA^2*kB^2*Y2^2 - kA^2*Y2^4) +
        ((2*I)*kA^2*muB*Y2^3)/(-kA^6 + 2*kA^4*kB^2 - kA^2*kB^4 +
          2*kA^4*Y2^2 + 2*kA^2*kB^2*Y2^2 - kA^2*Y2^4) +
        (I*kA^4*Y2*ya2)/(-kA^6 + 2*kA^4*kB^2 - kA^2*kB^4 + 2*kA^4*Y2^2 +
          2*kA^2*kB^2*Y2^2 - kA^2*Y2^4) + (I*kA^2*kB^2*Y2*ya2)/
         (-kA^6 + 2*kA^4*kB^2 - kA^2*kB^4 + 2*kA^4*Y2^2 + 2*kA^2*kB^2*Y2^2 -
          kA^2*Y2^4) - (I*kA^2*Y2^3*ya2)/(-kA^6 + 2*kA^4*kB^2 - kA^2*kB^4 +
          2*kA^4*Y2^2 + 2*kA^2*kB^2*Y2^2 - kA^2*Y2^4), 0,
       ((2*I)*kA^3*kB*Y2)/(-kA^6 + 2*kA^4*kB^2 - kA^2*kB^4 + 2*kA^4*Y2^2 +
         2*kA^2*kB^2*Y2^2 - kA^2*Y2^4), 0,
       kA^5/(-kA^6 + 2*kA^4*kB^2 - kA^2*kB^4 + 2*kA^4*Y2^2 +
          2*kA^2*kB^2*Y2^2 - kA^2*Y2^4) - (kA^3*kB^2)/(-kA^6 + 2*kA^4*kB^2 -
          kA^2*kB^4 + 2*kA^4*Y2^2 + 2*kA^2*kB^2*Y2^2 - kA^2*Y2^4) -
        (kA^3*Y2^2)/(-kA^6 + 2*kA^4*kB^2 - kA^2*kB^4 + 2*kA^4*Y2^2 +
          2*kA^2*kB^2*Y2^2 - kA^2*Y2^4)}, {0, 0, 0, 0, 0, 0, 0, 0,
       kA^3/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) -
        (kA*kB^2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 +
          Y2^4) - (kA*Y2^2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) + (kA^3*ya2)/(kA^4 - 2*kA^2*kB^2 + kB^4 -
          2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) - (kA*kB^2*ya2)/
         (kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) -
        (kA*Y2^2*ya2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4), 0, ((4*I)*kA*kB*muB*Y2)/(kA^4 - 2*kA^2*kB^2 +
          kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) - ((2*I)*kA*kB*Y2*ya2)/
         (kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4), 0,
       ((-2*I)*kA^2*muA*Y2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) - ((2*I)*kB^2*muA*Y2)/(kA^4 - 2*kA^2*kB^2 +
          kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) + ((2*I)*muA*Y2^3)/
         (kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) +
        (I*kA^2*Y2*ya2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) + (I*kB^2*Y2*ya2)/(kA^4 - 2*kA^2*kB^2 + kB^4 -
          2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) - (I*Y2^3*ya2)/
         (kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4), 0,
       -kB^(-1) - (2*muB)/kB - (kA^2*kB)/(kA^4 - 2*kA^2*kB^2 + kB^4 -
          2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) + kB^3/(kA^4 - 2*kA^2*kB^2 +
          kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) - (2*kA^2*kB*muA)/
         (kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) +
        (2*kB^3*muA)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 +
          Y2^4) - (2*kA^2*kB*muB)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) + (2*kB^3*muB)/(kA^4 - 2*kA^2*kB^2 + kB^4 -
          2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) - (kB*Y2^2)/(kA^4 - 2*kA^2*kB^2 +
          kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) - (2*kB*muA*Y2^2)/
         (kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) -
        (2*kB*muB*Y2^2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) - kB/(kB^2 - Y3^2) + (kA^2*kB*ya2)/
         (kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) -
        (kB^3*ya2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 +
          Y2^4) + (kB*Y2^2*ya2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) - (kB*ya3)/(kB^2 - Y3^2),
       ((-2*I)*muB*Y3)/(kB^2 - Y3^2) + (I*Y3*ya3)/(kB^2 - Y3^2),
       kA^3/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) -
        (kA*kB^2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 +
          Y2^4) - (kA*Y2^2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4), 0, ((-2*I)*kA*kB*Y2)/(kA^4 - 2*kA^2*kB^2 +
         kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4), 0},
      {0, 0, 0, 0, 0, 0, 0, 0, 0, kA^3/(kA^4 - 2*kA^2*kB^2 + kB^4 -
          2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) - (kA*kB^2)/(kA^4 - 2*kA^2*kB^2 +
          kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) -
        (kA*Y2^2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 +
          Y2^4) + (kA^3*ya2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) - (kA*kB^2*ya2)/(kA^4 - 2*kA^2*kB^2 + kB^4 -
          2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) - (kA*Y2^2*ya2)/
         (kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4), 0,
       ((4*I)*kA*kB*muB*Y2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) - ((2*I)*kA*kB*Y2*ya2)/(kA^4 - 2*kA^2*kB^2 +
          kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4), 0,
       ((-2*I)*kA^2*muA*Y2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) - ((2*I)*kB^2*muA*Y2)/(kA^4 - 2*kA^2*kB^2 +
          kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) + ((2*I)*muA*Y2^3)/
         (kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) +
        (I*kA^2*Y2*ya2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) + (I*kB^2*Y2*ya2)/(kA^4 - 2*kA^2*kB^2 + kB^4 -
          2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) - (I*Y2^3*ya2)/
         (kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4),
       ((-I)*Y3)/(kB^2 - Y3^2) - (I*Y3*ya3)/(kB^2 - Y3^2),
       -2/kB - (4*muB)/kB - (kA^2*kB)/(kA^4 - 2*kA^2*kB^2 + kB^4 -
          2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) + kB^3/(kA^4 - 2*kA^2*kB^2 +
          kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) - (2*kA^2*kB*muA)/
         (kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) +
        (2*kB^3*muA)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 +
          Y2^4) - (2*kA^2*kB*muB)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) + (2*kB^3*muB)/(kA^4 - 2*kA^2*kB^2 + kB^4 -
          2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) - (kB*Y2^2)/(kA^4 - 2*kA^2*kB^2 +
          kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) - (2*kB*muA*Y2^2)/
         (kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) -
        (2*kB*muB*Y2^2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) + (2*kB*muB)/(kB^2 - Y3^2) +
        (kA^2*kB*ya2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 -
          2*kB^2*Y2^2 + Y2^4) - (kB^3*ya2)/(kA^4 - 2*kA^2*kB^2 + kB^4 -
          2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) + (kB*Y2^2*ya2)/
         (kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) -
        (kB*ya3)/(kB^2 - Y3^2), 0, kA^3/(kA^4 - 2*kA^2*kB^2 + kB^4 -
          2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) - (kA*kB^2)/(kA^4 - 2*kA^2*kB^2 +
          kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4) -
        (kA*Y2^2)/(kA^4 - 2*kA^2*kB^2 + kB^4 - 2*kA^2*Y2^2 - 2*kB^2*Y2^2 +
          Y2^4), 0, ((-2*I)*kA*kB*Y2)/(kA^4 - 2*kA^2*kB^2 + kB^4 -
         2*kA^2*Y2^2 - 2*kB^2*Y2^2 + Y2^4)}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
       0, 0, 0, 0, 0, 0, kB/(-kB^2 - ((-I)*Y1 - I*Y2)^2) -
        (2*kB*muA)/(-kB^2 - ((-I)*Y1 - I*Y2)^2) - kB/(kB^2 - Y3^2) +
        (kB*ya1)/(-kB^2 - ((-I)*Y1 - I*Y2)^2) +
        (kB*ya2)/(-kB^2 - ((-I)*Y1 - I*Y2)^2) - (kB*ya3)/(kB^2 - Y3^2),
       ((-2*I)*muB*Y3)/(kB^2 - Y3^2) + (I*Y3*ya3)/(kB^2 - Y3^2),
       ((-2*I)*muA*Y1)/(-kB^2 - ((-I)*Y1 - I*Y2)^2) -
        ((2*I)*muB*Y1)/(-kB^2 - ((-I)*Y1 - I*Y2)^2) -
        ((2*I)*muA*Y2)/(-kB^2 - ((-I)*Y1 - I*Y2)^2) -
        ((2*I)*muB*Y2)/(-kB^2 - ((-I)*Y1 - I*Y2)^2) +
        (I*Y1*ya1)/(-kB^2 - ((-I)*Y1 - I*Y2)^2) +
        (I*Y2*ya1)/(-kB^2 - ((-I)*Y1 - I*Y2)^2) +
        (I*Y1*ya2)/(-kB^2 - ((-I)*Y1 - I*Y2)^2) +
        (I*Y2*ya2)/(-kB^2 - ((-I)*Y1 - I*Y2)^2), 0}, {0, 0, 0, 0, 0, 0, 0, 0,
       0, 0, 0, 0, 0, 0, 0, 0, ((-I)*Y3)/(kB^2 - Y3^2) -
        (I*Y3*ya3)/(kB^2 - Y3^2), -kB^(-1) - (2*muB)/kB +
        kB/(-kB^2 - ((-I)*Y1 - I*Y2)^2) - (2*kB*muA)/
         (-kB^2 - ((-I)*Y1 - I*Y2)^2) + (2*kB*muB)/(kB^2 - Y3^2) +
        (kB*ya1)/(-kB^2 - ((-I)*Y1 - I*Y2)^2) +
        (kB*ya2)/(-kB^2 - ((-I)*Y1 - I*Y2)^2) - (kB*ya3)/(kB^2 - Y3^2), 0,
       ((-2*I)*muA*Y1)/(-kB^2 - ((-I)*Y1 - I*Y2)^2) -
        ((2*I)*muB*Y1)/(-kB^2 - ((-I)*Y1 - I*Y2)^2) -
        ((2*I)*muA*Y2)/(-kB^2 - ((-I)*Y1 - I*Y2)^2) -
        ((2*I)*muB*Y2)/(-kB^2 - ((-I)*Y1 - I*Y2)^2) +
        (I*Y1*ya1)/(-kB^2 - ((-I)*Y1 - I*Y2)^2) +
        (I*Y2*ya1)/(-kB^2 - ((-I)*Y1 - I*Y2)^2) +
        (I*Y1*ya2)/(-kB^2 - ((-I)*Y1 - I*Y2)^2) +
        (I*Y2*ya2)/(-kB^2 - ((-I)*Y1 - I*Y2)^2)}, {0, 0, 0, 0, 0, 0, 0, 0, 0,
       0, 0, 0, 0, 0, 0, 0, (I*Y1)/(kB^2 - Y1^2 - 2*Y1*Y2 - Y2^2) -
        ((2*I)*muA*Y1)/(kB^2 - Y1^2 - 2*Y1*Y2 - Y2^2) +
        (I*Y2)/(kB^2 - Y1^2 - 2*Y1*Y2 - Y2^2) - ((2*I)*muA*Y2)/
         (kB^2 - Y1^2 - 2*Y1*Y2 - Y2^2) + (I*Y1*ya1)/(kB^2 - Y1^2 - 2*Y1*Y2 -
          Y2^2) + (I*Y2*ya1)/(kB^2 - Y1^2 - 2*Y1*Y2 - Y2^2) +
        (I*Y1*ya2)/(kB^2 - Y1^2 - 2*Y1*Y2 - Y2^2) +
        (I*Y2*ya2)/(kB^2 - Y1^2 - 2*Y1*Y2 - Y2^2), 0, -kB^(-1) - (2*muB)/kB +
        (2*kB*muA)/(kB^2 - Y1^2 - 2*Y1*Y2 - Y2^2) +
        (2*kB*muB)/(kB^2 - Y1^2 - 2*Y1*Y2 - Y2^2) - kB/(kB^2 - Y3^2) -
        (kB*ya1)/(kB^2 - Y1^2 - 2*Y1*Y2 - Y2^2) -
        (kB*ya2)/(kB^2 - Y1^2 - 2*Y1*Y2 - Y2^2) - (kB*ya3)/(kB^2 - Y3^2),
       ((-2*I)*muB*Y3)/(kB^2 - Y3^2) + (I*Y3*ya3)/(kB^2 - Y3^2)},
      {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
       (I*Y1)/(kB^2 - Y1^2 - 2*Y1*Y2 - Y2^2) - ((2*I)*muA*Y1)/
         (kB^2 - Y1^2 - 2*Y1*Y2 - Y2^2) + (I*Y2)/(kB^2 - Y1^2 - 2*Y1*Y2 -
          Y2^2) - ((2*I)*muA*Y2)/(kB^2 - Y1^2 - 2*Y1*Y2 - Y2^2) +
        (I*Y1*ya1)/(kB^2 - Y1^2 - 2*Y1*Y2 - Y2^2) +
        (I*Y2*ya1)/(kB^2 - Y1^2 - 2*Y1*Y2 - Y2^2) +
        (I*Y1*ya2)/(kB^2 - Y1^2 - 2*Y1*Y2 - Y2^2) +
        (I*Y2*ya2)/(kB^2 - Y1^2 - 2*Y1*Y2 - Y2^2), ((-I)*Y3)/(kB^2 - Y3^2) -
        (I*Y3*ya3)/(kB^2 - Y3^2), -2/kB - (4*muB)/kB +
        (2*kB*muA)/(kB^2 - Y1^2 - 2*Y1*Y2 - Y2^2) +
        (2*kB*muB)/(kB^2 - Y1^2 - 2*Y1*Y2 - Y2^2) +
        (2*kB*muB)/(kB^2 - Y3^2) - (kB*ya1)/(kB^2 - Y1^2 - 2*Y1*Y2 - Y2^2) -
        (kB*ya2)/(kB^2 - Y1^2 - 2*Y1*Y2 - Y2^2) - (kB*ya3)/(kB^2 - Y3^2)}},
    "expected" -> {{1/(4*(-kA - kB - Y2)) + 1/(4*(kA - kB - Y2)) -
        1/(4*(-kA + kB - Y2)) - 1/(4*(kA + kB - Y2)) + 1/(2*(-kB + Y3)) -
        1/(2*(kB + Y3)) + ya2/(4*(-kA - kB - Y2)) + ya2/(4*(kA - kB - Y2)) -
        ya2/(4*(-kA + kB - Y2)) - ya2/(4*(kA + kB - Y2)) +
        ya3/(2*(-kB + Y3)) - ya3/(2*(kB + Y3)), (I*muB)/(-kB + Y3) +
        (I*muB)/(kB + Y3) - ((I/2)*ya3)/(-kB + Y3) - ((I/2)*ya3)/(kB + Y3),
       ((I/2)*muB)/(-kA - kB - Y2) + ((I/2)*muB)/(kA - kB - Y2) +
        ((I/2)*muB)/(-kA + kB - Y2) + ((I/2)*muB)/(kA + kB - Y2) -
        ((I/4)*ya2)/(-kA - kB - Y2) - ((I/4)*ya2)/(kA - kB - Y2) -
        ((I/4)*ya2)/(-kA + kB - Y2) - ((I/4)*ya2)/(kA + kB - Y2), 0,
       ((I/2)*muA)/(-kA - kB - Y2) - ((I/2)*muA)/(kA - kB - Y2) -
        ((I/2)*muA)/(-kA + kB - Y2) + ((I/2)*muA)/(kA + kB - Y2) -
        ((I/4)*ya2)/(-kA - kB - Y2) + ((I/4)*ya2)/(kA - kB - Y2) +
        ((I/4)*ya2)/(-kA + kB - Y2) - ((I/4)*ya2)/(kA + kB - Y2), 0,
       1/(4*(-kA - kB - Y2)) + muA/(2*(-kA - kB - Y2)) +
        muB/(2*(-kA - kB - Y2)) - 1/(4*(kA - kB - Y2)) -
        muA/(2*(kA - kB - Y2)) - muB/(2*(kA - kB - Y2)) +
        1/(4*(-kA + kB - Y2)) + muA/(2*(-kA + kB - Y2)) +
        muB/(2*(-kA + kB - Y2)) - 1/(4*(kA + kB - Y2)) -
        muA/(2*(kA + kB - Y2)) - muB/(2*(kA + kB - Y2)) -
        ya2/(4*(-kA - kB - Y2)) + ya2/(4*(kA - kB - Y2)) -
        ya2/(4*(-kA + kB - Y2)) + ya2/(4*(kA + kB - Y2)), 0, 0, 0, 0, 0, 0,
       0, 0, 0, (I/4)/(-kA - kB - Y2) - (I/4)/(kA - kB - Y2) -
        (I/4)/(-kA + kB - Y2) + (I/4)/(kA + kB - Y2), 0,
       1/(4*(-kA - kB - Y2)) - 1/(4*(kA - kB - Y2)) + 1/(4*(-kA + kB - Y2)) -
        1/(4*(kA + kB - Y2)), 0}, {(I/2)/(-kB + Y3) + (I/2)/(kB + Y3) +
        ((I/2)*ya3)/(-kB + Y3) + ((I/2)*ya3)/(kB + Y3),
       -kB^(-1) - (2*muB)/kB + 1/(4*(-kA - kB - Y2)) + 1/(4*(kA - kB - Y2)) -
        1/(4*(-kA + kB - Y2)) - 1/(4*(kA + kB - Y2)) - muB/(-kB + Y3) +
        muB/(kB + Y3) + ya2/(4*(-kA - kB - Y2)) + ya2/(4*(kA - kB - Y2)) -
        ya2/(4*(-kA + kB - Y2)) - ya2/(4*(kA + kB - Y2)) +
        ya3/(2*(-kB + Y3)) - ya3/(2*(kB + Y3)), 0,
       ((I/2)*muB)/(-kA - kB - Y2) + ((I/2)*muB)/(kA - kB - Y2) +
        ((I/2)*muB)/(-kA + kB - Y2) + ((I/2)*muB)/(kA + kB - Y2) -
        ((I/4)*ya2)/(-kA - kB - Y2) - ((I/4)*ya2)/(kA - kB - Y2) -
        ((I/4)*ya2)/(-kA + kB - Y2) - ((I/4)*ya2)/(kA + kB - Y2), 0,
       ((I/2)*muA)/(-kA - kB - Y2) - ((I/2)*muA)/(kA - kB - Y2) -
        ((I/2)*muA)/(-kA + kB - Y2) + ((I/2)*muA)/(kA + kB - Y2) -
        ((I/4)*ya2)/(-kA - kB - Y2) + ((I/4)*ya2)/(kA - kB - Y2) +
        ((I/4)*ya2)/(-kA + kB - Y2) - ((I/4)*ya2)/(kA + kB - Y2), 0,
       1/(4*(-kA - kB - Y2)) + muA/(2*(-kA - kB - Y2)) +
        muB/(2*(-kA - kB - Y2)) - 1/(4*(kA - kB - Y2)) -
        muA/(2*(kA - kB - Y2)) - muB/(2*(kA - kB - Y2)) +
        1/(4*(-kA + kB - Y2)) + muA/(2*(-kA + kB - Y2)) +
        muB/(2*(-kA + kB - Y2)) - 1/(4*(kA + kB - Y2)) -
        muA/(2*(kA + kB - Y2)) - muB/(2*(kA + kB - Y2)) -
        ya2/(4*(-kA - kB - Y2)) + ya2/(4*(kA - kB - Y2)) -
        ya2/(4*(-kA + kB - Y2)) + ya2/(4*(kA + kB - Y2)), 0, 0, 0, 0, 0, 0,
       0, 0, 0, (I/4)/(-kA - kB - Y2) - (I/4)/(kA - kB - Y2) -
        (I/4)/(-kA + kB - Y2) + (I/4)/(kA + kB - Y2), 0,
       1/(4*(-kA - kB - Y2)) - 1/(4*(kA - kB - Y2)) + 1/(4*(-kA + kB - Y2)) -
        1/(4*(kA + kB - Y2))}, {(I/4)/(-kA - kB - Y2) +
        (I/4)/(kA - kB - Y2) + (I/4)/(-kA + kB - Y2) + (I/4)/(kA + kB - Y2) +
        ((I/4)*ya2)/(-kA - kB - Y2) + ((I/4)*ya2)/(kA - kB - Y2) +
        ((I/4)*ya2)/(-kA + kB - Y2) + ((I/4)*ya2)/(kA + kB - Y2), 0,
       -kB^(-1) - (2*muB)/kB - muB/(2*(-kA - kB - Y2)) -
        muB/(2*(kA - kB - Y2)) + muB/(2*(-kA + kB - Y2)) +
        muB/(2*(kA + kB - Y2)) + 1/(2*(-kB + Y3)) - 1/(2*(kB + Y3)) +
        ya2/(4*(-kA - kB - Y2)) + ya2/(4*(kA - kB - Y2)) -
        ya2/(4*(-kA + kB - Y2)) - ya2/(4*(kA + kB - Y2)) +
        ya3/(2*(-kB + Y3)) - ya3/(2*(kB + Y3)), (I*muB)/(-kB + Y3) +
        (I*muB)/(kB + Y3) - ((I/2)*ya3)/(-kB + Y3) - ((I/2)*ya3)/(kB + Y3),
       -1/2*muA/(-kA - kB - Y2) + muA/(2*(kA - kB - Y2)) -
        muA/(2*(-kA + kB - Y2)) + muA/(2*(kA + kB - Y2)) +
        ya2/(4*(-kA - kB - Y2)) - ya2/(4*(kA - kB - Y2)) +
        ya2/(4*(-kA + kB - Y2)) - ya2/(4*(kA + kB - Y2)), 0,
       (I/4)/(-kA - kB - Y2) + ((I/2)*muA)/(-kA - kB - Y2) +
        ((I/2)*muB)/(-kA - kB - Y2) - (I/4)/(kA - kB - Y2) -
        ((I/2)*muA)/(kA - kB - Y2) - ((I/2)*muB)/(kA - kB - Y2) -
        (I/4)/(-kA + kB - Y2) - ((I/2)*muA)/(-kA + kB - Y2) -
        ((I/2)*muB)/(-kA + kB - Y2) + (I/4)/(kA + kB - Y2) +
        ((I/2)*muA)/(kA + kB - Y2) + ((I/2)*muB)/(kA + kB - Y2) -
        ((I/4)*ya2)/(-kA - kB - Y2) + ((I/4)*ya2)/(kA - kB - Y2) +
        ((I/4)*ya2)/(-kA + kB - Y2) - ((I/4)*ya2)/(kA + kB - Y2), 0, 0, 0, 0,
       0, 0, 0, 0, 0, -1/4*1/(-kA - kB - Y2) + 1/(4*(kA - kB - Y2)) -
        1/(4*(-kA + kB - Y2)) + 1/(4*(kA + kB - Y2)), 0,
       (I/4)/(-kA - kB - Y2) - (I/4)/(kA - kB - Y2) - (I/4)/(-kA + kB - Y2) +
        (I/4)/(kA + kB - Y2), 0}, {0, (I/4)/(-kA - kB - Y2) +
        (I/4)/(kA - kB - Y2) + (I/4)/(-kA + kB - Y2) + (I/4)/(kA + kB - Y2) +
        ((I/4)*ya2)/(-kA - kB - Y2) + ((I/4)*ya2)/(kA - kB - Y2) +
        ((I/4)*ya2)/(-kA + kB - Y2) + ((I/4)*ya2)/(kA + kB - Y2),
       (I/2)/(-kB + Y3) + (I/2)/(kB + Y3) + ((I/2)*ya3)/(-kB + Y3) +
        ((I/2)*ya3)/(kB + Y3), -2/kB - (4*muB)/kB - muB/(2*(-kA - kB - Y2)) -
        muB/(2*(kA - kB - Y2)) + muB/(2*(-kA + kB - Y2)) +
        muB/(2*(kA + kB - Y2)) - muB/(-kB + Y3) + muB/(kB + Y3) +
        ya2/(4*(-kA - kB - Y2)) + ya2/(4*(kA - kB - Y2)) -
        ya2/(4*(-kA + kB - Y2)) - ya2/(4*(kA + kB - Y2)) +
        ya3/(2*(-kB + Y3)) - ya3/(2*(kB + Y3)), 0, -1/2*muA/(-kA - kB - Y2) +
        muA/(2*(kA - kB - Y2)) - muA/(2*(-kA + kB - Y2)) +
        muA/(2*(kA + kB - Y2)) + ya2/(4*(-kA - kB - Y2)) -
        ya2/(4*(kA - kB - Y2)) + ya2/(4*(-kA + kB - Y2)) -
        ya2/(4*(kA + kB - Y2)), 0, (I/4)/(-kA - kB - Y2) +
        ((I/2)*muA)/(-kA - kB - Y2) + ((I/2)*muB)/(-kA - kB - Y2) -
        (I/4)/(kA - kB - Y2) - ((I/2)*muA)/(kA - kB - Y2) -
        ((I/2)*muB)/(kA - kB - Y2) - (I/4)/(-kA + kB - Y2) -
        ((I/2)*muA)/(-kA + kB - Y2) - ((I/2)*muB)/(-kA + kB - Y2) +
        (I/4)/(kA + kB - Y2) + ((I/2)*muA)/(kA + kB - Y2) +
        ((I/2)*muB)/(kA + kB - Y2) - ((I/4)*ya2)/(-kA - kB - Y2) +
        ((I/4)*ya2)/(kA - kB - Y2) + ((I/4)*ya2)/(-kA + kB - Y2) -
        ((I/4)*ya2)/(kA + kB - Y2), 0, 0, 0, 0, 0, 0, 0, 0, 0,
       -1/4*1/(-kA - kB - Y2) + 1/(4*(kA - kB - Y2)) -
        1/(4*(-kA + kB - Y2)) + 1/(4*(kA + kB - Y2)), 0,
       (I/4)/(-kA - kB - Y2) - (I/4)/(kA - kB - Y2) - (I/4)/(-kA + kB - Y2) +
        (I/4)/(kA + kB - Y2)}, {(I/4)/(-kA - kB - Y2) -
        (I/4)/(kA - kB - Y2) - (I/4)/(-kA + kB - Y2) + (I/4)/(kA + kB - Y2) +
        ((I/4)*ya2)/(-kA - kB - Y2) - ((I/4)*ya2)/(kA - kB - Y2) -
        ((I/4)*ya2)/(-kA + kB - Y2) + ((I/4)*ya2)/(kA + kB - Y2), 0,
       -1/2*muB/(-kA - kB - Y2) + muB/(2*(kA - kB - Y2)) -
        muB/(2*(-kA + kB - Y2)) + muB/(2*(kA + kB - Y2)) +
        ya2/(4*(-kA - kB - Y2)) - ya2/(4*(kA - kB - Y2)) +
        ya2/(4*(-kA + kB - Y2)) - ya2/(4*(kA + kB - Y2)), 0,
       -1/2*muA/(-kA - kB - Y2) - muA/(2*(kA - kB - Y2)) +
        muA/(2*(-kA + kB - Y2)) + muA/(2*(kA + kB - Y2)) + 1/(2*(-kB + Y3)) -
        1/(2*(kB + Y3)) + ya2/(4*(-kA - kB - Y2)) + ya2/(4*(kA - kB - Y2)) -
        ya2/(4*(-kA + kB - Y2)) - ya2/(4*(kA + kB - Y2)) +
        ya3/(2*(-kB + Y3)) - ya3/(2*(kB + Y3)), (I*muB)/(-kB + Y3) +
        (I*muB)/(kB + Y3) - ((I/2)*ya3)/(-kB + Y3) - ((I/2)*ya3)/(kB + Y3),
       (I/4)/(-kA - kB - Y2) + ((I/2)*muA)/(-kA - kB - Y2) +
        ((I/2)*muB)/(-kA - kB - Y2) + (I/4)/(kA - kB - Y2) +
        ((I/2)*muA)/(kA - kB - Y2) + ((I/2)*muB)/(kA - kB - Y2) +
        (I/4)/(-kA + kB - Y2) + ((I/2)*muA)/(-kA + kB - Y2) +
        ((I/2)*muB)/(-kA + kB - Y2) + (I/4)/(kA + kB - Y2) +
        ((I/2)*muA)/(kA + kB - Y2) + ((I/2)*muB)/(kA + kB - Y2) -
        ((I/4)*ya2)/(-kA - kB - Y2) - ((I/4)*ya2)/(kA - kB - Y2) -
        ((I/4)*ya2)/(-kA + kB - Y2) - ((I/4)*ya2)/(kA + kB - Y2), 0, 0, 0, 0,
       0, 0, 0, 0, 0, -1/4*1/(-kA - kB - Y2) - 1/(4*(kA - kB - Y2)) +
        1/(4*(-kA + kB - Y2)) + 1/(4*(kA + kB - Y2)), 0,
       (I/4)/(-kA - kB - Y2) + (I/4)/(kA - kB - Y2) + (I/4)/(-kA + kB - Y2) +
        (I/4)/(kA + kB - Y2), 0}, {0, (I/4)/(-kA - kB - Y2) -
        (I/4)/(kA - kB - Y2) - (I/4)/(-kA + kB - Y2) + (I/4)/(kA + kB - Y2) +
        ((I/4)*ya2)/(-kA - kB - Y2) - ((I/4)*ya2)/(kA - kB - Y2) -
        ((I/4)*ya2)/(-kA + kB - Y2) + ((I/4)*ya2)/(kA + kB - Y2), 0,
       -1/2*muB/(-kA - kB - Y2) + muB/(2*(kA - kB - Y2)) -
        muB/(2*(-kA + kB - Y2)) + muB/(2*(kA + kB - Y2)) +
        ya2/(4*(-kA - kB - Y2)) - ya2/(4*(kA - kB - Y2)) +
        ya2/(4*(-kA + kB - Y2)) - ya2/(4*(kA + kB - Y2)),
       (I/2)/(-kB + Y3) + (I/2)/(kB + Y3) + ((I/2)*ya3)/(-kB + Y3) +
        ((I/2)*ya3)/(kB + Y3), -kB^(-1) - (2*muB)/kB -
        muA/(2*(-kA - kB - Y2)) - muA/(2*(kA - kB - Y2)) +
        muA/(2*(-kA + kB - Y2)) + muA/(2*(kA + kB - Y2)) - muB/(-kB + Y3) +
        muB/(kB + Y3) + ya2/(4*(-kA - kB - Y2)) + ya2/(4*(kA - kB - Y2)) -
        ya2/(4*(-kA + kB - Y2)) - ya2/(4*(kA + kB - Y2)) +
        ya3/(2*(-kB + Y3)) - ya3/(2*(kB + Y3)), 0, (I/4)/(-kA - kB - Y2) +
        ((I/2)*muA)/(-kA - kB - Y2) + ((I/2)*muB)/(-kA - kB - Y2) +
        (I/4)/(kA - kB - Y2) + ((I/2)*muA)/(kA - kB - Y2) +
        ((I/2)*muB)/(kA - kB - Y2) + (I/4)/(-kA + kB - Y2) +
        ((I/2)*muA)/(-kA + kB - Y2) + ((I/2)*muB)/(-kA + kB - Y2) +
        (I/4)/(kA + kB - Y2) + ((I/2)*muA)/(kA + kB - Y2) +
        ((I/2)*muB)/(kA + kB - Y2) - ((I/4)*ya2)/(-kA - kB - Y2) -
        ((I/4)*ya2)/(kA - kB - Y2) - ((I/4)*ya2)/(-kA + kB - Y2) -
        ((I/4)*ya2)/(kA + kB - Y2), 0, 0, 0, 0, 0, 0, 0, 0, 0,
       -1/4*1/(-kA - kB - Y2) - 1/(4*(kA - kB - Y2)) +
        1/(4*(-kA + kB - Y2)) + 1/(4*(kA + kB - Y2)), 0,
       (I/4)/(-kA - kB - Y2) + (I/4)/(kA - kB - Y2) + (I/4)/(-kA + kB - Y2) +
        (I/4)/(kA + kB - Y2)}, {-1/4*1/(-kA - kB - Y2) +
        1/(4*(kA - kB - Y2)) - 1/(4*(-kA + kB - Y2)) + 1/(4*(kA + kB - Y2)) -
        ya2/(4*(-kA - kB - Y2)) + ya2/(4*(kA - kB - Y2)) -
        ya2/(4*(-kA + kB - Y2)) + ya2/(4*(kA + kB - Y2)), 0,
       ((-1/2*I)*muB)/(-kA - kB - Y2) + ((I/2)*muB)/(kA - kB - Y2) +
        ((I/2)*muB)/(-kA + kB - Y2) - ((I/2)*muB)/(kA + kB - Y2) +
        ((I/4)*ya2)/(-kA - kB - Y2) - ((I/4)*ya2)/(kA - kB - Y2) -
        ((I/4)*ya2)/(-kA + kB - Y2) + ((I/4)*ya2)/(kA + kB - Y2), 0,
       ((-1/2*I)*muA)/(-kA - kB - Y2) - ((I/2)*muA)/(kA - kB - Y2) -
        ((I/2)*muA)/(-kA + kB - Y2) - ((I/2)*muA)/(kA + kB - Y2) +
        ((I/4)*ya2)/(-kA - kB - Y2) + ((I/4)*ya2)/(kA - kB - Y2) +
        ((I/4)*ya2)/(-kA + kB - Y2) + ((I/4)*ya2)/(kA + kB - Y2), 0,
       -kB^(-1) - (2*muB)/kB - 1/(4*(-kA - kB - Y2)) -
        muA/(2*(-kA - kB - Y2)) - muB/(2*(-kA - kB - Y2)) -
        1/(4*(kA - kB - Y2)) - muA/(2*(kA - kB - Y2)) -
        muB/(2*(kA - kB - Y2)) + 1/(4*(-kA + kB - Y2)) +
        muA/(2*(-kA + kB - Y2)) + muB/(2*(-kA + kB - Y2)) +
        1/(4*(kA + kB - Y2)) + muA/(2*(kA + kB - Y2)) +
        muB/(2*(kA + kB - Y2)) + 1/(2*(-kB + Y3)) - 1/(2*(kB + Y3)) +
        ya2/(4*(-kA - kB - Y2)) + ya2/(4*(kA - kB - Y2)) -
        ya2/(4*(-kA + kB - Y2)) - ya2/(4*(kA + kB - Y2)) +
        ya3/(2*(-kB + Y3)) - ya3/(2*(kB + Y3)), (I*muB)/(-kB + Y3) +
        (I*muB)/(kB + Y3) - ((I/2)*ya3)/(-kB + Y3) - ((I/2)*ya3)/(kB + Y3),
       0, 0, 0, 0, 0, 0, 0, 0, (-1/4*I)/(-kA - kB - Y2) -
        (I/4)/(kA - kB - Y2) - (I/4)/(-kA + kB - Y2) - (I/4)/(kA + kB - Y2),
       0, -1/4*1/(-kA - kB - Y2) - 1/(4*(kA - kB - Y2)) +
        1/(4*(-kA + kB - Y2)) + 1/(4*(kA + kB - Y2)), 0},
      {0, -1/4*1/(-kA - kB - Y2) + 1/(4*(kA - kB - Y2)) -
        1/(4*(-kA + kB - Y2)) + 1/(4*(kA + kB - Y2)) -
        ya2/(4*(-kA - kB - Y2)) + ya2/(4*(kA - kB - Y2)) -
        ya2/(4*(-kA + kB - Y2)) + ya2/(4*(kA + kB - Y2)), 0,
       ((-1/2*I)*muB)/(-kA - kB - Y2) + ((I/2)*muB)/(kA - kB - Y2) +
        ((I/2)*muB)/(-kA + kB - Y2) - ((I/2)*muB)/(kA + kB - Y2) +
        ((I/4)*ya2)/(-kA - kB - Y2) - ((I/4)*ya2)/(kA - kB - Y2) -
        ((I/4)*ya2)/(-kA + kB - Y2) + ((I/4)*ya2)/(kA + kB - Y2), 0,
       ((-1/2*I)*muA)/(-kA - kB - Y2) - ((I/2)*muA)/(kA - kB - Y2) -
        ((I/2)*muA)/(-kA + kB - Y2) - ((I/2)*muA)/(kA + kB - Y2) +
        ((I/4)*ya2)/(-kA - kB - Y2) + ((I/4)*ya2)/(kA - kB - Y2) +
        ((I/4)*ya2)/(-kA + kB - Y2) + ((I/4)*ya2)/(kA + kB - Y2),
       (I/2)/(-kB + Y3) + (I/2)/(kB + Y3) + ((I/2)*ya3)/(-kB + Y3) +
        ((I/2)*ya3)/(kB + Y3), -2/kB - (4*muB)/kB - 1/(4*(-kA - kB - Y2)) -
        muA/(2*(-kA - kB - Y2)) - muB/(2*(-kA - kB - Y2)) -
        1/(4*(kA - kB - Y2)) - muA/(2*(kA - kB - Y2)) -
        muB/(2*(kA - kB - Y2)) + 1/(4*(-kA + kB - Y2)) +
        muA/(2*(-kA + kB - Y2)) + muB/(2*(-kA + kB - Y2)) +
        1/(4*(kA + kB - Y2)) + muA/(2*(kA + kB - Y2)) +
        muB/(2*(kA + kB - Y2)) - muB/(-kB + Y3) + muB/(kB + Y3) +
        ya2/(4*(-kA - kB - Y2)) + ya2/(4*(kA - kB - Y2)) -
        ya2/(4*(-kA + kB - Y2)) - ya2/(4*(kA + kB - Y2)) +
        ya3/(2*(-kB + Y3)) - ya3/(2*(kB + Y3)), 0, 0, 0, 0, 0, 0, 0, 0, 0,
       (-1/4*I)/(-kA - kB - Y2) - (I/4)/(kA - kB - Y2) -
        (I/4)/(-kA + kB - Y2) - (I/4)/(kA + kB - Y2), 0,
       -1/4*1/(-kA - kB - Y2) - 1/(4*(kA - kB - Y2)) +
        1/(4*(-kA + kB - Y2)) + 1/(4*(kA + kB - Y2))},
      {0, 0, 0, 0, 0, 0, 0, 0, 1/(4*(-kA - kB - Y2)) + 1/(4*(kA - kB - Y2)) -
        1/(4*(-kA + kB - Y2)) - 1/(4*(kA + kB - Y2)) + 1/(2*(-kB + Y3)) -
        1/(2*(kB + Y3)) + ya2/(4*(-kA - kB - Y2)) + ya2/(4*(kA - kB - Y2)) -
        ya2/(4*(-kA + kB - Y2)) - ya2/(4*(kA + kB - Y2)) +
        ya3/(2*(-kB + Y3)) - ya3/(2*(kB + Y3)), (I*muB)/(-kB + Y3) +
        (I*muB)/(kB + Y3) - ((I/2)*ya3)/(-kB + Y3) - ((I/2)*ya3)/(kB + Y3),
       ((I/2)*muB)/(-kA - kB - Y2) + ((I/2)*muB)/(kA - kB - Y2) +
        ((I/2)*muB)/(-kA + kB - Y2) + ((I/2)*muB)/(kA + kB - Y2) -
        ((I/4)*ya2)/(-kA - kB - Y2) - ((I/4)*ya2)/(kA - kB - Y2) -
        ((I/4)*ya2)/(-kA + kB - Y2) - ((I/4)*ya2)/(kA + kB - Y2), 0,
       ((I/2)*muA)/(-kA - kB - Y2) - ((I/2)*muA)/(kA - kB - Y2) -
        ((I/2)*muA)/(-kA + kB - Y2) + ((I/2)*muA)/(kA + kB - Y2) -
        ((I/4)*ya2)/(-kA - kB - Y2) + ((I/4)*ya2)/(kA - kB - Y2) +
        ((I/4)*ya2)/(-kA + kB - Y2) - ((I/4)*ya2)/(kA + kB - Y2), 0,
       1/(4*(-kA - kB - Y2)) + muA/(2*(-kA - kB - Y2)) +
        muB/(2*(-kA - kB - Y2)) - 1/(4*(kA - kB - Y2)) -
        muA/(2*(kA - kB - Y2)) - muB/(2*(kA - kB - Y2)) +
        1/(4*(-kA + kB - Y2)) + muA/(2*(-kA + kB - Y2)) +
        muB/(2*(-kA + kB - Y2)) - 1/(4*(kA + kB - Y2)) -
        muA/(2*(kA + kB - Y2)) - muB/(2*(kA + kB - Y2)) -
        ya2/(4*(-kA - kB - Y2)) + ya2/(4*(kA - kB - Y2)) -
        ya2/(4*(-kA + kB - Y2)) + ya2/(4*(kA + kB - Y2)), 0,
       1/(4*(-kA - kB - Y2)) + 1/(4*(kA - kB - Y2)) - 1/(4*(-kA + kB - Y2)) -
        1/(4*(kA + kB - Y2)), 0, (-1/4*I)/(-kA - kB - Y2) -
        (I/4)/(kA - kB - Y2) - (I/4)/(-kA + kB - Y2) - (I/4)/(kA + kB - Y2),
       0}, {0, 0, 0, 0, 0, 0, 0, 0, (I/2)/(-kB + Y3) + (I/2)/(kB + Y3) +
        ((I/2)*ya3)/(-kB + Y3) + ((I/2)*ya3)/(kB + Y3),
       -kB^(-1) - (2*muB)/kB + 1/(4*(-kA - kB - Y2)) + 1/(4*(kA - kB - Y2)) -
        1/(4*(-kA + kB - Y2)) - 1/(4*(kA + kB - Y2)) - muB/(-kB + Y3) +
        muB/(kB + Y3) + ya2/(4*(-kA - kB - Y2)) + ya2/(4*(kA - kB - Y2)) -
        ya2/(4*(-kA + kB - Y2)) - ya2/(4*(kA + kB - Y2)) +
        ya3/(2*(-kB + Y3)) - ya3/(2*(kB + Y3)), 0,
       ((I/2)*muB)/(-kA - kB - Y2) + ((I/2)*muB)/(kA - kB - Y2) +
        ((I/2)*muB)/(-kA + kB - Y2) + ((I/2)*muB)/(kA + kB - Y2) -
        ((I/4)*ya2)/(-kA - kB - Y2) - ((I/4)*ya2)/(kA - kB - Y2) -
        ((I/4)*ya2)/(-kA + kB - Y2) - ((I/4)*ya2)/(kA + kB - Y2), 0,
       ((I/2)*muA)/(-kA - kB - Y2) - ((I/2)*muA)/(kA - kB - Y2) -
        ((I/2)*muA)/(-kA + kB - Y2) + ((I/2)*muA)/(kA + kB - Y2) -
        ((I/4)*ya2)/(-kA - kB - Y2) + ((I/4)*ya2)/(kA - kB - Y2) +
        ((I/4)*ya2)/(-kA + kB - Y2) - ((I/4)*ya2)/(kA + kB - Y2), 0,
       1/(4*(-kA - kB - Y2)) + muA/(2*(-kA - kB - Y2)) +
        muB/(2*(-kA - kB - Y2)) - 1/(4*(kA - kB - Y2)) -
        muA/(2*(kA - kB - Y2)) - muB/(2*(kA - kB - Y2)) +
        1/(4*(-kA + kB - Y2)) + muA/(2*(-kA + kB - Y2)) +
        muB/(2*(-kA + kB - Y2)) - 1/(4*(kA + kB - Y2)) -
        muA/(2*(kA + kB - Y2)) - muB/(2*(kA + kB - Y2)) -
        ya2/(4*(-kA - kB - Y2)) + ya2/(4*(kA - kB - Y2)) -
        ya2/(4*(-kA + kB - Y2)) + ya2/(4*(kA + kB - Y2)), 0,
       1/(4*(-kA - kB - Y2)) + 1/(4*(kA - kB - Y2)) - 1/(4*(-kA + kB - Y2)) -
        1/(4*(kA + kB - Y2)), 0, (-1/4*I)/(-kA - kB - Y2) -
        (I/4)/(kA - kB - Y2) - (I/4)/(-kA + kB - Y2) - (I/4)/(kA + kB - Y2)},
      {0, 0, 0, 0, 0, 0, 0, 0, (I/4)/(-kA - kB - Y2) + (I/4)/(kA - kB - Y2) +
        (I/4)/(-kA + kB - Y2) + (I/4)/(kA + kB - Y2) +
        ((I/4)*ya2)/(-kA - kB - Y2) + ((I/4)*ya2)/(kA - kB - Y2) +
        ((I/4)*ya2)/(-kA + kB - Y2) + ((I/4)*ya2)/(kA + kB - Y2), 0,
       -kB^(-1) - (2*muB)/kB - muB/(2*(-kA - kB - Y2)) -
        muB/(2*(kA - kB - Y2)) + muB/(2*(-kA + kB - Y2)) +
        muB/(2*(kA + kB - Y2)) + 1/(2*(-kB + Y3)) - 1/(2*(kB + Y3)) +
        ya2/(4*(-kA - kB - Y2)) + ya2/(4*(kA - kB - Y2)) -
        ya2/(4*(-kA + kB - Y2)) - ya2/(4*(kA + kB - Y2)) +
        ya3/(2*(-kB + Y3)) - ya3/(2*(kB + Y3)), (I*muB)/(-kB + Y3) +
        (I*muB)/(kB + Y3) - ((I/2)*ya3)/(-kB + Y3) - ((I/2)*ya3)/(kB + Y3),
       -1/2*muA/(-kA - kB - Y2) + muA/(2*(kA - kB - Y2)) -
        muA/(2*(-kA + kB - Y2)) + muA/(2*(kA + kB - Y2)) +
        ya2/(4*(-kA - kB - Y2)) - ya2/(4*(kA - kB - Y2)) +
        ya2/(4*(-kA + kB - Y2)) - ya2/(4*(kA + kB - Y2)), 0,
       (I/4)/(-kA - kB - Y2) + ((I/2)*muA)/(-kA - kB - Y2) +
        ((I/2)*muB)/(-kA - kB - Y2) - (I/4)/(kA - kB - Y2) -
        ((I/2)*muA)/(kA - kB - Y2) - ((I/2)*muB)/(kA - kB - Y2) -
        (I/4)/(-kA + kB - Y2) - ((I/2)*muA)/(-kA + kB - Y2) -
        ((I/2)*muB)/(-kA + kB - Y2) + (I/4)/(kA + kB - Y2) +
        ((I/2)*muA)/(kA + kB - Y2) + ((I/2)*muB)/(kA + kB - Y2) -
        ((I/4)*ya2)/(-kA - kB - Y2) + ((I/4)*ya2)/(kA - kB - Y2) +
        ((I/4)*ya2)/(-kA + kB - Y2) - ((I/4)*ya2)/(kA + kB - Y2), 0,
       (I/4)/(-kA - kB - Y2) + (I/4)/(kA - kB - Y2) + (I/4)/(-kA + kB - Y2) +
        (I/4)/(kA + kB - Y2), 0, 1/(4*(-kA - kB - Y2)) +
        1/(4*(kA - kB - Y2)) - 1/(4*(-kA + kB - Y2)) - 1/(4*(kA + kB - Y2)),
       0}, {0, 0, 0, 0, 0, 0, 0, 0, 0, (I/4)/(-kA - kB - Y2) +
        (I/4)/(kA - kB - Y2) + (I/4)/(-kA + kB - Y2) + (I/4)/(kA + kB - Y2) +
        ((I/4)*ya2)/(-kA - kB - Y2) + ((I/4)*ya2)/(kA - kB - Y2) +
        ((I/4)*ya2)/(-kA + kB - Y2) + ((I/4)*ya2)/(kA + kB - Y2),
       (I/2)/(-kB + Y3) + (I/2)/(kB + Y3) + ((I/2)*ya3)/(-kB + Y3) +
        ((I/2)*ya3)/(kB + Y3), -2/kB - (4*muB)/kB - muB/(2*(-kA - kB - Y2)) -
        muB/(2*(kA - kB - Y2)) + muB/(2*(-kA + kB - Y2)) +
        muB/(2*(kA + kB - Y2)) - muB/(-kB + Y3) + muB/(kB + Y3) +
        ya2/(4*(-kA - kB - Y2)) + ya2/(4*(kA - kB - Y2)) -
        ya2/(4*(-kA + kB - Y2)) - ya2/(4*(kA + kB - Y2)) +
        ya3/(2*(-kB + Y3)) - ya3/(2*(kB + Y3)), 0, -1/2*muA/(-kA - kB - Y2) +
        muA/(2*(kA - kB - Y2)) - muA/(2*(-kA + kB - Y2)) +
        muA/(2*(kA + kB - Y2)) + ya2/(4*(-kA - kB - Y2)) -
        ya2/(4*(kA - kB - Y2)) + ya2/(4*(-kA + kB - Y2)) -
        ya2/(4*(kA + kB - Y2)), 0, (I/4)/(-kA - kB - Y2) +
        ((I/2)*muA)/(-kA - kB - Y2) + ((I/2)*muB)/(-kA - kB - Y2) -
        (I/4)/(kA - kB - Y2) - ((I/2)*muA)/(kA - kB - Y2) -
        ((I/2)*muB)/(kA - kB - Y2) - (I/4)/(-kA + kB - Y2) -
        ((I/2)*muA)/(-kA + kB - Y2) - ((I/2)*muB)/(-kA + kB - Y2) +
        (I/4)/(kA + kB - Y2) + ((I/2)*muA)/(kA + kB - Y2) +
        ((I/2)*muB)/(kA + kB - Y2) - ((I/4)*ya2)/(-kA - kB - Y2) +
        ((I/4)*ya2)/(kA - kB - Y2) + ((I/4)*ya2)/(-kA + kB - Y2) -
        ((I/4)*ya2)/(kA + kB - Y2), 0, (I/4)/(-kA - kB - Y2) +
        (I/4)/(kA - kB - Y2) + (I/4)/(-kA + kB - Y2) + (I/4)/(kA + kB - Y2),
       0, 1/(4*(-kA - kB - Y2)) + 1/(4*(kA - kB - Y2)) -
        1/(4*(-kA + kB - Y2)) - 1/(4*(kA + kB - Y2))},
      {0, 0, 0, 0, 0, 0, 0, 0, (I/4)/(-kA - kB - Y2) - (I/4)/(kA - kB - Y2) -
        (I/4)/(-kA + kB - Y2) + (I/4)/(kA + kB - Y2) +
        ((I/4)*ya2)/(-kA - kB - Y2) - ((I/4)*ya2)/(kA - kB - Y2) -
        ((I/4)*ya2)/(-kA + kB - Y2) + ((I/4)*ya2)/(kA + kB - Y2), 0,
       -1/2*muB/(-kA - kB - Y2) + muB/(2*(kA - kB - Y2)) -
        muB/(2*(-kA + kB - Y2)) + muB/(2*(kA + kB - Y2)) +
        ya2/(4*(-kA - kB - Y2)) - ya2/(4*(kA - kB - Y2)) +
        ya2/(4*(-kA + kB - Y2)) - ya2/(4*(kA + kB - Y2)), 0,
       -1/2*muA/(-kA - kB - Y2) - muA/(2*(kA - kB - Y2)) +
        muA/(2*(-kA + kB - Y2)) + muA/(2*(kA + kB - Y2)) + 1/(2*(-kB + Y3)) -
        1/(2*(kB + Y3)) + ya2/(4*(-kA - kB - Y2)) + ya2/(4*(kA - kB - Y2)) -
        ya2/(4*(-kA + kB - Y2)) - ya2/(4*(kA + kB - Y2)) +
        ya3/(2*(-kB + Y3)) - ya3/(2*(kB + Y3)), (I*muB)/(-kB + Y3) +
        (I*muB)/(kB + Y3) - ((I/2)*ya3)/(-kB + Y3) - ((I/2)*ya3)/(kB + Y3),
       (I/4)/(-kA - kB - Y2) + ((I/2)*muA)/(-kA - kB - Y2) +
        ((I/2)*muB)/(-kA - kB - Y2) + (I/4)/(kA - kB - Y2) +
        ((I/2)*muA)/(kA - kB - Y2) + ((I/2)*muB)/(kA - kB - Y2) +
        (I/4)/(-kA + kB - Y2) + ((I/2)*muA)/(-kA + kB - Y2) +
        ((I/2)*muB)/(-kA + kB - Y2) + (I/4)/(kA + kB - Y2) +
        ((I/2)*muA)/(kA + kB - Y2) + ((I/2)*muB)/(kA + kB - Y2) -
        ((I/4)*ya2)/(-kA - kB - Y2) - ((I/4)*ya2)/(kA - kB - Y2) -
        ((I/4)*ya2)/(-kA + kB - Y2) - ((I/4)*ya2)/(kA + kB - Y2), 0,
       (I/4)/(-kA - kB - Y2) - (I/4)/(kA - kB - Y2) - (I/4)/(-kA + kB - Y2) +
        (I/4)/(kA + kB - Y2), 0, 1/(4*(-kA - kB - Y2)) -
        1/(4*(kA - kB - Y2)) + 1/(4*(-kA + kB - Y2)) - 1/(4*(kA + kB - Y2)),
       0}, {0, 0, 0, 0, 0, 0, 0, 0, 0, (I/4)/(-kA - kB - Y2) -
        (I/4)/(kA - kB - Y2) - (I/4)/(-kA + kB - Y2) + (I/4)/(kA + kB - Y2) +
        ((I/4)*ya2)/(-kA - kB - Y2) - ((I/4)*ya2)/(kA - kB - Y2) -
        ((I/4)*ya2)/(-kA + kB - Y2) + ((I/4)*ya2)/(kA + kB - Y2), 0,
       -1/2*muB/(-kA - kB - Y2) + muB/(2*(kA - kB - Y2)) -
        muB/(2*(-kA + kB - Y2)) + muB/(2*(kA + kB - Y2)) +
        ya2/(4*(-kA - kB - Y2)) - ya2/(4*(kA - kB - Y2)) +
        ya2/(4*(-kA + kB - Y2)) - ya2/(4*(kA + kB - Y2)),
       (I/2)/(-kB + Y3) + (I/2)/(kB + Y3) + ((I/2)*ya3)/(-kB + Y3) +
        ((I/2)*ya3)/(kB + Y3), -kB^(-1) - (2*muB)/kB -
        muA/(2*(-kA - kB - Y2)) - muA/(2*(kA - kB - Y2)) +
        muA/(2*(-kA + kB - Y2)) + muA/(2*(kA + kB - Y2)) - muB/(-kB + Y3) +
        muB/(kB + Y3) + ya2/(4*(-kA - kB - Y2)) + ya2/(4*(kA - kB - Y2)) -
        ya2/(4*(-kA + kB - Y2)) - ya2/(4*(kA + kB - Y2)) +
        ya3/(2*(-kB + Y3)) - ya3/(2*(kB + Y3)), 0, (I/4)/(-kA - kB - Y2) +
        ((I/2)*muA)/(-kA - kB - Y2) + ((I/2)*muB)/(-kA - kB - Y2) +
        (I/4)/(kA - kB - Y2) + ((I/2)*muA)/(kA - kB - Y2) +
        ((I/2)*muB)/(kA - kB - Y2) + (I/4)/(-kA + kB - Y2) +
        ((I/2)*muA)/(-kA + kB - Y2) + ((I/2)*muB)/(-kA + kB - Y2) +
        (I/4)/(kA + kB - Y2) + ((I/2)*muA)/(kA + kB - Y2) +
        ((I/2)*muB)/(kA + kB - Y2) - ((I/4)*ya2)/(-kA - kB - Y2) -
        ((I/4)*ya2)/(kA - kB - Y2) - ((I/4)*ya2)/(-kA + kB - Y2) -
        ((I/4)*ya2)/(kA + kB - Y2), 0, (I/4)/(-kA - kB - Y2) -
        (I/4)/(kA - kB - Y2) - (I/4)/(-kA + kB - Y2) + (I/4)/(kA + kB - Y2),
       0, 1/(4*(-kA - kB - Y2)) - 1/(4*(kA - kB - Y2)) +
        1/(4*(-kA + kB - Y2)) - 1/(4*(kA + kB - Y2))},
      {0, 0, 0, 0, 0, 0, 0, 0, -1/4*1/(-kA - kB - Y2) +
        1/(4*(kA - kB - Y2)) - 1/(4*(-kA + kB - Y2)) + 1/(4*(kA + kB - Y2)) -
        ya2/(4*(-kA - kB - Y2)) + ya2/(4*(kA - kB - Y2)) -
        ya2/(4*(-kA + kB - Y2)) + ya2/(4*(kA + kB - Y2)), 0,
       ((-1/2*I)*muB)/(-kA - kB - Y2) + ((I/2)*muB)/(kA - kB - Y2) +
        ((I/2)*muB)/(-kA + kB - Y2) - ((I/2)*muB)/(kA + kB - Y2) +
        ((I/4)*ya2)/(-kA - kB - Y2) - ((I/4)*ya2)/(kA - kB - Y2) -
        ((I/4)*ya2)/(-kA + kB - Y2) + ((I/4)*ya2)/(kA + kB - Y2), 0,
       ((-1/2*I)*muA)/(-kA - kB - Y2) - ((I/2)*muA)/(kA - kB - Y2) -
        ((I/2)*muA)/(-kA + kB - Y2) - ((I/2)*muA)/(kA + kB - Y2) +
        ((I/4)*ya2)/(-kA - kB - Y2) + ((I/4)*ya2)/(kA - kB - Y2) +
        ((I/4)*ya2)/(-kA + kB - Y2) + ((I/4)*ya2)/(kA + kB - Y2), 0,
       -kB^(-1) - (2*muB)/kB - 1/(4*(-kA - kB - Y2)) -
        muA/(2*(-kA - kB - Y2)) - muB/(2*(-kA - kB - Y2)) -
        1/(4*(kA - kB - Y2)) - muA/(2*(kA - kB - Y2)) -
        muB/(2*(kA - kB - Y2)) + 1/(4*(-kA + kB - Y2)) +
        muA/(2*(-kA + kB - Y2)) + muB/(2*(-kA + kB - Y2)) +
        1/(4*(kA + kB - Y2)) + muA/(2*(kA + kB - Y2)) +
        muB/(2*(kA + kB - Y2)) + 1/(2*(-kB + Y3)) - 1/(2*(kB + Y3)) +
        ya2/(4*(-kA - kB - Y2)) + ya2/(4*(kA - kB - Y2)) -
        ya2/(4*(-kA + kB - Y2)) - ya2/(4*(kA + kB - Y2)) +
        ya3/(2*(-kB + Y3)) - ya3/(2*(kB + Y3)), (I*muB)/(-kB + Y3) +
        (I*muB)/(kB + Y3) - ((I/2)*ya3)/(-kB + Y3) - ((I/2)*ya3)/(kB + Y3),
       -1/4*1/(-kA - kB - Y2) + 1/(4*(kA - kB - Y2)) -
        1/(4*(-kA + kB - Y2)) + 1/(4*(kA + kB - Y2)), 0,
       (I/4)/(-kA - kB - Y2) - (I/4)/(kA - kB - Y2) - (I/4)/(-kA + kB - Y2) +
        (I/4)/(kA + kB - Y2), 0}, {0, 0, 0, 0, 0, 0, 0, 0, 0,
       -1/4*1/(-kA - kB - Y2) + 1/(4*(kA - kB - Y2)) -
        1/(4*(-kA + kB - Y2)) + 1/(4*(kA + kB - Y2)) -
        ya2/(4*(-kA - kB - Y2)) + ya2/(4*(kA - kB - Y2)) -
        ya2/(4*(-kA + kB - Y2)) + ya2/(4*(kA + kB - Y2)), 0,
       ((-1/2*I)*muB)/(-kA - kB - Y2) + ((I/2)*muB)/(kA - kB - Y2) +
        ((I/2)*muB)/(-kA + kB - Y2) - ((I/2)*muB)/(kA + kB - Y2) +
        ((I/4)*ya2)/(-kA - kB - Y2) - ((I/4)*ya2)/(kA - kB - Y2) -
        ((I/4)*ya2)/(-kA + kB - Y2) + ((I/4)*ya2)/(kA + kB - Y2), 0,
       ((-1/2*I)*muA)/(-kA - kB - Y2) - ((I/2)*muA)/(kA - kB - Y2) -
        ((I/2)*muA)/(-kA + kB - Y2) - ((I/2)*muA)/(kA + kB - Y2) +
        ((I/4)*ya2)/(-kA - kB - Y2) + ((I/4)*ya2)/(kA - kB - Y2) +
        ((I/4)*ya2)/(-kA + kB - Y2) + ((I/4)*ya2)/(kA + kB - Y2),
       (I/2)/(-kB + Y3) + (I/2)/(kB + Y3) + ((I/2)*ya3)/(-kB + Y3) +
        ((I/2)*ya3)/(kB + Y3), -2/kB - (4*muB)/kB - 1/(4*(-kA - kB - Y2)) -
        muA/(2*(-kA - kB - Y2)) - muB/(2*(-kA - kB - Y2)) -
        1/(4*(kA - kB - Y2)) - muA/(2*(kA - kB - Y2)) -
        muB/(2*(kA - kB - Y2)) + 1/(4*(-kA + kB - Y2)) +
        muA/(2*(-kA + kB - Y2)) + muB/(2*(-kA + kB - Y2)) +
        1/(4*(kA + kB - Y2)) + muA/(2*(kA + kB - Y2)) +
        muB/(2*(kA + kB - Y2)) - muB/(-kB + Y3) + muB/(kB + Y3) +
        ya2/(4*(-kA - kB - Y2)) + ya2/(4*(kA - kB - Y2)) -
        ya2/(4*(-kA + kB - Y2)) - ya2/(4*(kA + kB - Y2)) +
        ya3/(2*(-kB + Y3)) - ya3/(2*(kB + Y3)), 0, -1/4*1/(-kA - kB - Y2) +
        1/(4*(kA - kB - Y2)) - 1/(4*(-kA + kB - Y2)) + 1/(4*(kA + kB - Y2)),
       0, (I/4)/(-kA - kB - Y2) - (I/4)/(kA - kB - Y2) -
        (I/4)/(-kA + kB - Y2) + (I/4)/(kA + kB - Y2)},
      {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
       1/(2*(-kB - Y1 - Y2)) - muA/(-kB - Y1 - Y2) - 1/(2*(kB - Y1 - Y2)) +
        muA/(kB - Y1 - Y2) + 1/(2*(-kB + Y3)) - 1/(2*(kB + Y3)) +
        ya1/(2*(-kB - Y1 - Y2)) - ya1/(2*(kB - Y1 - Y2)) +
        ya2/(2*(-kB - Y1 - Y2)) - ya2/(2*(kB - Y1 - Y2)) +
        ya3/(2*(-kB + Y3)) - ya3/(2*(kB + Y3)), (I*muB)/(-kB + Y3) +
        (I*muB)/(kB + Y3) - ((I/2)*ya3)/(-kB + Y3) - ((I/2)*ya3)/(kB + Y3),
       (I*muA)/(-kB - Y1 - Y2) + (I*muB)/(-kB - Y1 - Y2) +
        (I*muA)/(kB - Y1 - Y2) + (I*muB)/(kB - Y1 - Y2) -
        ((I/2)*ya1)/(-kB - Y1 - Y2) - ((I/2)*ya1)/(kB - Y1 - Y2) -
        ((I/2)*ya2)/(-kB - Y1 - Y2) - ((I/2)*ya2)/(kB - Y1 - Y2), 0},
      {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
       (I/2)/(-kB + Y3) + (I/2)/(kB + Y3) + ((I/2)*ya3)/(-kB + Y3) +
        ((I/2)*ya3)/(kB + Y3), -kB^(-1) - (2*muB)/kB +
        1/(2*(-kB - Y1 - Y2)) - muA/(-kB - Y1 - Y2) - 1/(2*(kB - Y1 - Y2)) +
        muA/(kB - Y1 - Y2) - muB/(-kB + Y3) + muB/(kB + Y3) +
        ya1/(2*(-kB - Y1 - Y2)) - ya1/(2*(kB - Y1 - Y2)) +
        ya2/(2*(-kB - Y1 - Y2)) - ya2/(2*(kB - Y1 - Y2)) +
        ya3/(2*(-kB + Y3)) - ya3/(2*(kB + Y3)), 0, (I*muA)/(-kB - Y1 - Y2) +
        (I*muB)/(-kB - Y1 - Y2) + (I*muA)/(kB - Y1 - Y2) +
        (I*muB)/(kB - Y1 - Y2) - ((I/2)*ya1)/(-kB - Y1 - Y2) -
        ((I/2)*ya1)/(kB - Y1 - Y2) - ((I/2)*ya2)/(-kB - Y1 - Y2) -
        ((I/2)*ya2)/(kB - Y1 - Y2)}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
       0, 0, 0, (I/2)/(-kB - Y1 - Y2) - (I*muA)/(-kB - Y1 - Y2) +
        (I/2)/(kB - Y1 - Y2) - (I*muA)/(kB - Y1 - Y2) +
        ((I/2)*ya1)/(-kB - Y1 - Y2) + ((I/2)*ya1)/(kB - Y1 - Y2) +
        ((I/2)*ya2)/(-kB - Y1 - Y2) + ((I/2)*ya2)/(kB - Y1 - Y2), 0,
       -kB^(-1) - (2*muB)/kB - muA/(-kB - Y1 - Y2) - muB/(-kB - Y1 - Y2) +
        muA/(kB - Y1 - Y2) + muB/(kB - Y1 - Y2) + 1/(2*(-kB + Y3)) -
        1/(2*(kB + Y3)) + ya1/(2*(-kB - Y1 - Y2)) - ya1/(2*(kB - Y1 - Y2)) +
        ya2/(2*(-kB - Y1 - Y2)) - ya2/(2*(kB - Y1 - Y2)) +
        ya3/(2*(-kB + Y3)) - ya3/(2*(kB + Y3)), (I*muB)/(-kB + Y3) +
        (I*muB)/(kB + Y3) - ((I/2)*ya3)/(-kB + Y3) - ((I/2)*ya3)/(kB + Y3)},
      {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
       (I/2)/(-kB - Y1 - Y2) - (I*muA)/(-kB - Y1 - Y2) +
        (I/2)/(kB - Y1 - Y2) - (I*muA)/(kB - Y1 - Y2) +
        ((I/2)*ya1)/(-kB - Y1 - Y2) + ((I/2)*ya1)/(kB - Y1 - Y2) +
        ((I/2)*ya2)/(-kB - Y1 - Y2) + ((I/2)*ya2)/(kB - Y1 - Y2),
       (I/2)/(-kB + Y3) + (I/2)/(kB + Y3) + ((I/2)*ya3)/(-kB + Y3) +
        ((I/2)*ya3)/(kB + Y3), -2/kB - (4*muB)/kB - muA/(-kB - Y1 - Y2) -
        muB/(-kB - Y1 - Y2) + muA/(kB - Y1 - Y2) + muB/(kB - Y1 - Y2) -
        muB/(-kB + Y3) + muB/(kB + Y3) + ya1/(2*(-kB - Y1 - Y2)) -
        ya1/(2*(kB - Y1 - Y2)) + ya2/(2*(-kB - Y1 - Y2)) -
        ya2/(2*(kB - Y1 - Y2)) + ya3/(2*(-kB + Y3)) - ya3/(2*(kB + Y3))}},
    "difference" -> 0|>, <|"group" -> "pureTime",
    "name" -> "three iteration vs direct seed symbolic", "passed" -> True,
    "actual" -> ((-I)*Y3*J[{{0, 0}, {0, 0, 0}, {0, 0}}])/ya3 +
      (kB*J[{{0, 0}, {0, 0, 0}, {0, 1}}])/ya3,
    "expected" -> ((-I)*Y3*J[{{0, 0}, {0, 0, 0}, {0, 0}}] +
       kB*J[{{0, 0}, {0, 0, 0}, {0, 1}}])/ya3, "difference" -> 0|>,
   <|"group" -> "pureTime", "name" ->
     "three deterministic rational iteration", "passed" -> True,
    "actual" -> 23/68 - (9*I)/28, "expected" -> 23/68 - (9*I)/28,
    "difference" -> 0|>, <|"group" -> "parameters",
    "name" -> "main notation variables", "passed" -> True,
    "actual" -> {ss11, sE1, sE2, sE3}, "expected" -> {ss11, sE1, sE2, sE3},
    "difference" -> 0|>, <|"group" -> "parameters",
    "name" -> "main notation complete", "passed" -> True,
    "actual" -> "complete", "expected" -> "complete", "difference" -> 0|>,
   <|"group" -> "parameters", "name" -> "no dependent magnitudes",
    "passed" -> True, "actual" -> {}, "expected" -> {}, "difference" -> 0|>,
   <|"group" -> "parameters", "name" -> "notation N9 gram", "passed" -> True,
    "actual" -> ss19, "expected" -> ss19, "difference" -> 0|>,
   <|"group" -> "parameters", "name" -> "notation N9 leg", "passed" -> True,
    "actual" -> sE9, "expected" -> sE9, "difference" -> 0|>,
   <|"group" -> "parameters", "name" -> "notation N10 first",
    "passed" -> True, "actual" -> ss0101, "expected" -> ss0101,
    "difference" -> 0|>, <|"group" -> "parameters",
    "name" -> "notation N10 mixed", "passed" -> True, "actual" -> ss0110,
    "expected" -> ss0110, "difference" -> 0|>, <|"group" -> "parameters",
    "name" -> "notation N10 leg", "passed" -> True, "actual" -> sE01,
    "expected" -> sE01, "difference" -> 0|>, <|"group" -> "parameters",
    "name" -> "notation N100 gram", "passed" -> True, "actual" -> ss001100,
    "expected" -> ss001100, "difference" -> 0|>, <|"group" -> "parameters",
    "name" -> "notation N100 leg", "passed" -> True, "actual" -> sE001,
    "expected" -> sE001, "difference" -> 0|>, <|"group" -> "parameters",
    "name" -> "mixed redefine initialized", "passed" -> True,
    "actual" -> "initialized", "expected" -> "initialized",
    "difference" -> 0|>, <|"group" -> "parameters",
    "name" -> "mixed variables", "passed" -> True, "actual" -> {u, v, w, z},
    "expected" -> {u, v, w, z}, "difference" -> 0|>,
   <|"group" -> "parameters", "name" -> "mixed input hash changed",
    "passed" -> True, "actual" -> True, "expected" -> True,
    "difference" -> 0|>, <|"group" -> "parameters",
    "name" -> "mixed product and chain rule", "passed" -> True,
    "actual" -> (b2*u*c[u]*J[{a1, a2, a3}, {{-2 + b1, 0, 0}, {2 + b2, 0, 0},
          {0, 0}}, {}])/(2*(u^2 + 2*u*v + v^2)) +
      (beta2*u*c[u]*J[{a1, a2, a3}, {{-2 + b1, 0, 0}, {2 + b2, 0, 0},
          {0, 0}}, {}])/(2*(u^2 + 2*u*v + v^2)) +
      (b2*v*c[u]*J[{a1, a2, a3}, {{-2 + b1, 0, 0}, {2 + b2, 0, 0}, {0, 0}},
         {}])/(2*(u^2 + 2*u*v + v^2)) +
      (beta2*v*c[u]*J[{a1, a2, a3}, {{-2 + b1, 0, 0}, {2 + b2, 0, 0},
          {0, 0}}, {}])/(2*(u^2 + 2*u*v + v^2)) -
      (b2*u*c[u]*J[{a1, a2, a3}, {{b1, 0, 0}, {b2, 0, 0}, {0, 0}}, {}])/
       (2*(u^2 + 2*u*v + v^2)) - (beta2*u*c[u]*J[{a1, a2, a3},
         {{b1, 0, 0}, {b2, 0, 0}, {0, 0}}, {}])/(2*(u^2 + 2*u*v + v^2)) -
      (b2*v*c[u]*J[{a1, a2, a3}, {{b1, 0, 0}, {b2, 0, 0}, {0, 0}}, {}])/
       (2*(u^2 + 2*u*v + v^2)) - (beta2*v*c[u]*J[{a1, a2, a3},
         {{b1, 0, 0}, {b2, 0, 0}, {0, 0}}, {}])/(2*(u^2 + 2*u*v + v^2)) -
      (beta3*u*c[u]*J[{a1, a2, a3}, {{b1, 0, 0}, {b2, 0, 0}, {0, 0}}, {}])/
       (u^2 + 2*u*z + z^2) - (beta3*z*c[u]*J[{a1, a2, a3},
         {{b1, 0, 0}, {b2, 0, 0}, {0, 0}}, {}])/(u^2 + 2*u*z + z^2) -
      (b2*u*c[u]*J[{a1, a2, a3}, {{b1, 0, 0}, {2 + b2, 0, 0}, {0, 0}}, {}])/
       2 - (beta2*u*c[u]*J[{a1, a2, a3}, {{b1, 0, 0}, {2 + b2, 0, 0},
          {0, 0}}, {}])/2 - (b2*v*c[u]*J[{a1, a2, a3},
         {{b1, 0, 0}, {2 + b2, 0, 0}, {0, 0}}, {}])/2 -
      (beta2*v*c[u]*J[{a1, a2, a3}, {{b1, 0, 0}, {2 + b2, 0, 0}, {0, 0}},
         {}])/2 + (u*c[u]*J[{a1, a2, 1 + a3}, {{b1, 0, 0}, {b2, 0, 0},
          {0, 1}}, {}])/Sqrt[u^2 + 2*u*z + z^2] +
      (z*c[u]*J[{a1, a2, 1 + a3}, {{b1, 0, 0}, {b2, 0, 0}, {0, 1}}, {}])/
       Sqrt[u^2 + 2*u*z + z^2] - (u*c[u]*J[{a1, 1 + a2, a3},
         {{-2 + b1, 0, 0}, {1 + b2, 1, 0}, {0, 0}}, {}])/
       (2*(u^2 + 2*u*v + v^2)) - (v*c[u]*J[{a1, 1 + a2, a3},
         {{-2 + b1, 0, 0}, {1 + b2, 1, 0}, {0, 0}}, {}])/
       (2*(u^2 + 2*u*v + v^2)) + (u*c[u]*J[{a1, 1 + a2, a3},
         {{b1, 0, 0}, {-1 + b2, 1, 0}, {0, 0}}, {}])/
       (2*(u^2 + 2*u*v + v^2)) + (v*c[u]*J[{a1, 1 + a2, a3},
         {{b1, 0, 0}, {-1 + b2, 1, 0}, {0, 0}}, {}])/
       (2*(u^2 + 2*u*v + v^2)) + (u*c[u]*J[{a1, 1 + a2, a3},
         {{b1, 0, 0}, {b2, 0, 0}, {1, 0}}, {}])/Sqrt[u^2 + 2*u*z + z^2] +
      (z*c[u]*J[{a1, 1 + a2, a3}, {{b1, 0, 0}, {b2, 0, 0}, {1, 0}}, {}])/
       Sqrt[u^2 + 2*u*z + z^2] + (u*c[u]*J[{a1, 1 + a2, a3},
         {{b1, 0, 0}, {1 + b2, 1, 0}, {0, 0}}, {}])/2 +
      (v*c[u]*J[{a1, 1 + a2, a3}, {{b1, 0, 0}, {1 + b2, 1, 0}, {0, 0}}, {}])/
       2 - (u*c[u]*J[{1 + a1, a2, a3}, {{-2 + b1, 0, 0}, {1 + b2, 0, 1},
          {0, 0}}, {}])/(2*(u^2 + 2*u*v + v^2)) -
      (v*c[u]*J[{1 + a1, a2, a3}, {{-2 + b1, 0, 0}, {1 + b2, 0, 1}, {0, 0}},
         {}])/(2*(u^2 + 2*u*v + v^2)) +
      (b2*u*d[u]*J[{1 + a1, a2, a3}, {{-2 + b1, 0, 0}, {2 + b2, 0, 0},
          {1, 0}}, {}])/(2*(u^2 + 2*u*v + v^2)) +
      (beta2*u*d[u]*J[{1 + a1, a2, a3}, {{-2 + b1, 0, 0}, {2 + b2, 0, 0},
          {1, 0}}, {}])/(2*(u^2 + 2*u*v + v^2)) +
      (b2*v*d[u]*J[{1 + a1, a2, a3}, {{-2 + b1, 0, 0}, {2 + b2, 0, 0},
          {1, 0}}, {}])/(2*(u^2 + 2*u*v + v^2)) +
      (beta2*v*d[u]*J[{1 + a1, a2, a3}, {{-2 + b1, 0, 0}, {2 + b2, 0, 0},
          {1, 0}}, {}])/(2*(u^2 + 2*u*v + v^2)) +
      (u*c[u]*J[{1 + a1, a2, a3}, {{b1, 0, 0}, {-1 + b2, 0, 1}, {0, 0}}, {}])/
       (2*(u^2 + 2*u*v + v^2)) + (v*c[u]*J[{1 + a1, a2, a3},
         {{b1, 0, 0}, {-1 + b2, 0, 1}, {0, 0}}, {}])/
       (2*(u^2 + 2*u*v + v^2)) - (b2*u*d[u]*J[{1 + a1, a2, a3},
         {{b1, 0, 0}, {b2, 0, 0}, {1, 0}}, {}])/(2*(u^2 + 2*u*v + v^2)) -
      (beta2*u*d[u]*J[{1 + a1, a2, a3}, {{b1, 0, 0}, {b2, 0, 0}, {1, 0}},
         {}])/(2*(u^2 + 2*u*v + v^2)) -
      (b2*v*d[u]*J[{1 + a1, a2, a3}, {{b1, 0, 0}, {b2, 0, 0}, {1, 0}}, {}])/
       (2*(u^2 + 2*u*v + v^2)) - (beta2*v*d[u]*J[{1 + a1, a2, a3},
         {{b1, 0, 0}, {b2, 0, 0}, {1, 0}}, {}])/(2*(u^2 + 2*u*v + v^2)) -
      (u*d[u]*J[{1 + a1, a2, a3}, {{b1, 0, 0}, {b2, 0, 0}, {1, 0}}, {}])/
       (u^2 + 2*u*z + z^2) - (beta3*u*d[u]*J[{1 + a1, a2, a3},
         {{b1, 0, 0}, {b2, 0, 0}, {1, 0}}, {}])/(u^2 + 2*u*z + z^2) -
      (2*nu3*u*d[u]*J[{1 + a1, a2, a3}, {{b1, 0, 0}, {b2, 0, 0}, {1, 0}},
         {}])/(u^2 + 2*u*z + z^2) -
      (z*d[u]*J[{1 + a1, a2, a3}, {{b1, 0, 0}, {b2, 0, 0}, {1, 0}}, {}])/
       (u^2 + 2*u*z + z^2) - (beta3*z*d[u]*J[{1 + a1, a2, a3},
         {{b1, 0, 0}, {b2, 0, 0}, {1, 0}}, {}])/(u^2 + 2*u*z + z^2) -
      (2*nu3*z*d[u]*J[{1 + a1, a2, a3}, {{b1, 0, 0}, {b2, 0, 0}, {1, 0}},
         {}])/(u^2 + 2*u*z + z^2) +
      (u*c[u]*J[{1 + a1, a2, a3}, {{b1, 0, 0}, {1 + b2, 0, 1}, {0, 0}}, {}])/
       2 + (v*c[u]*J[{1 + a1, a2, a3}, {{b1, 0, 0}, {1 + b2, 0, 1}, {0, 0}},
         {}])/2 - (b2*u*d[u]*J[{1 + a1, a2, a3}, {{b1, 0, 0}, {2 + b2, 0, 0},
          {1, 0}}, {}])/2 - (beta2*u*d[u]*J[{1 + a1, a2, a3},
         {{b1, 0, 0}, {2 + b2, 0, 0}, {1, 0}}, {}])/2 -
      (b2*v*d[u]*J[{1 + a1, a2, a3}, {{b1, 0, 0}, {2 + b2, 0, 0}, {1, 0}},
         {}])/2 - (beta2*v*d[u]*J[{1 + a1, a2, a3}, {{b1, 0, 0},
          {2 + b2, 0, 0}, {1, 0}}, {}])/2 +
      (u*d[u]*J[{1 + a1, a2, 1 + a3}, {{b1, 0, 0}, {b2, 0, 0}, {1, 1}}, {}])/
       Sqrt[u^2 + 2*u*z + z^2] + (z*d[u]*J[{1 + a1, a2, 1 + a3},
         {{b1, 0, 0}, {b2, 0, 0}, {1, 1}}, {}])/Sqrt[u^2 + 2*u*z + z^2] -
      (u*d[u]*J[{1 + a1, 1 + a2, a3}, {{-2 + b1, 0, 0}, {1 + b2, 1, 0},
          {1, 0}}, {}])/(2*(u^2 + 2*u*v + v^2)) -
      (v*d[u]*J[{1 + a1, 1 + a2, a3}, {{-2 + b1, 0, 0}, {1 + b2, 1, 0},
          {1, 0}}, {}])/(2*(u^2 + 2*u*v + v^2)) +
      (u*d[u]*J[{1 + a1, 1 + a2, a3}, {{b1, 0, 0}, {-1 + b2, 1, 0}, {1, 0}},
         {}])/(2*(u^2 + 2*u*v + v^2)) +
      (v*d[u]*J[{1 + a1, 1 + a2, a3}, {{b1, 0, 0}, {-1 + b2, 1, 0}, {1, 0}},
         {}])/(2*(u^2 + 2*u*v + v^2)) -
      (u*d[u]*J[{1 + a1, 1 + a2, a3}, {{b1, 0, 0}, {b2, 0, 0}, {0, 0}}, {}])/
       Sqrt[u^2 + 2*u*z + z^2] - (z*d[u]*J[{1 + a1, 1 + a2, a3},
         {{b1, 0, 0}, {b2, 0, 0}, {0, 0}}, {}])/Sqrt[u^2 + 2*u*z + z^2] +
      (u*d[u]*J[{1 + a1, 1 + a2, a3}, {{b1, 0, 0}, {1 + b2, 1, 0}, {1, 0}},
         {}])/2 + (v*d[u]*J[{1 + a1, 1 + a2, a3}, {{b1, 0, 0},
          {1 + b2, 1, 0}, {1, 0}}, {}])/2 -
      (u*d[u]*J[{2 + a1, a2, a3}, {{-2 + b1, 0, 0}, {1 + b2, 0, 1}, {1, 0}},
         {}])/(2*(u^2 + 2*u*v + v^2)) -
      (v*d[u]*J[{2 + a1, a2, a3}, {{-2 + b1, 0, 0}, {1 + b2, 0, 1}, {1, 0}},
         {}])/(2*(u^2 + 2*u*v + v^2)) +
      (u*d[u]*J[{2 + a1, a2, a3}, {{b1, 0, 0}, {-1 + b2, 0, 1}, {1, 0}}, {}])/
       (2*(u^2 + 2*u*v + v^2)) + (v*d[u]*J[{2 + a1, a2, a3},
         {{b1, 0, 0}, {-1 + b2, 0, 1}, {1, 0}}, {}])/
       (2*(u^2 + 2*u*v + v^2)) + (u*d[u]*J[{2 + a1, a2, a3},
         {{b1, 0, 0}, {1 + b2, 0, 1}, {1, 0}}, {}])/2 +
      (v*d[u]*J[{2 + a1, a2, a3}, {{b1, 0, 0}, {1 + b2, 0, 1}, {1, 0}}, {}])/
       2 + J[{a1, a2, a3}, {{b1, 0, 0}, {b2, 0, 0}, {0, 0}}, {}]*
       Derivative[1][c][u] + J[{1 + a1, a2, a3}, {{b1, 0, 0}, {b2, 0, 0},
         {1, 0}}, {}]*Derivative[1][d][u], "expected" ->
     c[u]*((b2*J[{a1, a2, a3}, {{-2 + b1, 0, 0}, {2 + b2, 0, 0}, {0, 0}},
           {}])/(2*(u + v)) + (beta2*J[{a1, a2, a3}, {{-2 + b1, 0, 0},
            {2 + b2, 0, 0}, {0, 0}}, {}])/(2*(u + v)) -
        (b2*J[{a1, a2, a3}, {{b1, 0, 0}, {b2, 0, 0}, {0, 0}}, {}])/
         (2*(u + v)) - (beta2*J[{a1, a2, a3}, {{b1, 0, 0}, {b2, 0, 0},
            {0, 0}}, {}])/(2*(u + v)) -
        (beta3*J[{a1, a2, a3}, {{b1, 0, 0}, {b2, 0, 0}, {0, 0}}, {}])/
         (u + z) - (b2*(u + v)*J[{a1, a2, a3}, {{b1, 0, 0}, {2 + b2, 0, 0},
            {0, 0}}, {}])/2 - (beta2*(u + v)*J[{a1, a2, a3},
           {{b1, 0, 0}, {2 + b2, 0, 0}, {0, 0}}, {}])/2 +
        J[{a1, a2, 1 + a3}, {{b1, 0, 0}, {b2, 0, 0}, {0, 1}}, {}] -
        J[{a1, 1 + a2, a3}, {{-2 + b1, 0, 0}, {1 + b2, 1, 0}, {0, 0}}, {}]/
         (2*(u + v)) + J[{a1, 1 + a2, a3}, {{b1, 0, 0}, {-1 + b2, 1, 0},
           {0, 0}}, {}]/(2*(u + v)) + J[{a1, 1 + a2, a3},
         {{b1, 0, 0}, {b2, 0, 0}, {1, 0}}, {}] +
        ((u + v)*J[{a1, 1 + a2, a3}, {{b1, 0, 0}, {1 + b2, 1, 0}, {0, 0}},
           {}])/2 - J[{1 + a1, a2, a3}, {{-2 + b1, 0, 0}, {1 + b2, 0, 1},
           {0, 0}}, {}]/(2*(u + v)) + J[{1 + a1, a2, a3},
          {{b1, 0, 0}, {-1 + b2, 0, 1}, {0, 0}}, {}]/(2*(u + v)) +
        ((u + v)*J[{1 + a1, a2, a3}, {{b1, 0, 0}, {1 + b2, 0, 1}, {0, 0}},
           {}])/2) + d[u]*((b2*J[{1 + a1, a2, a3}, {{-2 + b1, 0, 0},
            {2 + b2, 0, 0}, {1, 0}}, {}])/(2*(u + v)) +
        (beta2*J[{1 + a1, a2, a3}, {{-2 + b1, 0, 0}, {2 + b2, 0, 0}, {1, 0}},
           {}])/(2*(u + v)) - (b2*J[{1 + a1, a2, a3}, {{b1, 0, 0},
            {b2, 0, 0}, {1, 0}}, {}])/(2*(u + v)) -
        (beta2*J[{1 + a1, a2, a3}, {{b1, 0, 0}, {b2, 0, 0}, {1, 0}}, {}])/
         (2*(u + v)) - J[{1 + a1, a2, a3}, {{b1, 0, 0}, {b2, 0, 0}, {1, 0}},
          {}]/(u + z) - (beta3*J[{1 + a1, a2, a3}, {{b1, 0, 0}, {b2, 0, 0},
            {1, 0}}, {}])/(u + z) - (2*nu3*J[{1 + a1, a2, a3},
           {{b1, 0, 0}, {b2, 0, 0}, {1, 0}}, {}])/(u + z) -
        (b2*(u + v)*J[{1 + a1, a2, a3}, {{b1, 0, 0}, {2 + b2, 0, 0}, {1, 0}},
           {}])/2 - (beta2*(u + v)*J[{1 + a1, a2, a3}, {{b1, 0, 0},
            {2 + b2, 0, 0}, {1, 0}}, {}])/2 + J[{1 + a1, a2, 1 + a3},
         {{b1, 0, 0}, {b2, 0, 0}, {1, 1}}, {}] -
        J[{1 + a1, 1 + a2, a3}, {{-2 + b1, 0, 0}, {1 + b2, 1, 0}, {1, 0}},
          {}]/(2*(u + v)) + J[{1 + a1, 1 + a2, a3}, {{b1, 0, 0},
           {-1 + b2, 1, 0}, {1, 0}}, {}]/(2*(u + v)) -
        J[{1 + a1, 1 + a2, a3}, {{b1, 0, 0}, {b2, 0, 0}, {0, 0}}, {}] +
        ((u + v)*J[{1 + a1, 1 + a2, a3}, {{b1, 0, 0}, {1 + b2, 1, 0},
            {1, 0}}, {}])/2 - J[{2 + a1, a2, a3}, {{-2 + b1, 0, 0},
           {1 + b2, 0, 1}, {1, 0}}, {}]/(2*(u + v)) +
        J[{2 + a1, a2, a3}, {{b1, 0, 0}, {-1 + b2, 0, 1}, {1, 0}}, {}]/
         (2*(u + v)) + ((u + v)*J[{2 + a1, a2, a3}, {{b1, 0, 0},
            {1 + b2, 0, 1}, {1, 0}}, {}])/2) +
      J[{a1, a2, a3}, {{b1, 0, 0}, {b2, 0, 0}, {0, 0}}, {}]*
       Derivative[1][c][u] + J[{1 + a1, a2, a3}, {{b1, 0, 0}, {b2, 0, 0},
         {1, 0}}, {}]*Derivative[1][d][u], "difference" -> 0|>,
   <|"group" -> "parameters", "name" -> "under redefinition rejected",
    "passed" -> True, "actual" -> True, "expected" -> True,
    "difference" -> 0|>, <|"group" -> "parameters",
    "name" -> "over redefinition continues", "passed" -> True,
    "actual" -> "initialized", "expected" -> "initialized",
    "difference" -> 0|>, <|"group" -> "parameters",
    "name" -> "over redefine inverse disabled", "passed" -> True,
    "actual" -> False, "expected" -> False, "difference" -> 0|>,
   <|"group" -> "parameters", "name" -> "over redefine derivative disabled",
    "passed" -> True, "actual" -> False, "expected" -> False,
    "difference" -> 0|>, <|"group" -> "coverage",
    "name" -> "public API version", "passed" -> True, "actual" -> "016",
    "expected" -> "016", "difference" -> 0|>, <|"group" -> "coverage",
    "name" -> "public function count", "passed" -> True, "actual" -> 29,
    "expected" -> 29, "difference" -> 0|>, <|"group" -> "coverage",
    "name" -> "manifest version", "passed" -> True, "actual" -> "016",
    "expected" -> "016", "difference" -> 0|>, <|"group" -> "coverage",
    "name" -> "manifest exact API set", "passed" -> True,
    "actual" -> {"dqk", "dqq", "ds", "DSDE", "DSInfo", "DSInit",
      "DSKinematics", "DSKiraExport", "DSKiraImport", "DSLinear",
      "DSMessagesOff", "DSMessagesOn", "DSMessagesQ", "DSParameterNotation",
      "DSPublicAPI", "DSRedefineParameters", "DSScaleCheck", "DSSeeds",
      "DSTreeDLogDE", "DSTreeNaiveDE", "DSTreeNaiveIBP", "DSTreeSeeds",
      "dtau", "rep2innerform", "rep2Integrand", "rep2outform",
      "repIterative", "repSymmetry0", "symmetry"},
    "expected" -> {"dqk", "dqq", "ds", "DSDE", "DSInfo", "DSInit",
      "DSKinematics", "DSKiraExport", "DSKiraImport", "DSLinear",
      "DSMessagesOff", "DSMessagesOn", "DSMessagesQ", "DSParameterNotation",
      "DSPublicAPI", "DSRedefineParameters", "DSScaleCheck", "DSSeeds",
      "DSTreeDLogDE", "DSTreeNaiveDE", "DSTreeNaiveIBP", "DSTreeSeeds",
      "dtau", "rep2innerform", "rep2Integrand", "rep2outform",
      "repIterative", "repSymmetry0", "symmetry"}, "difference" -> 0|>,
   <|"group" -> "coverage", "name" ->
     "example call DSInit in 01_mixed_bubble_workflow.wl", "passed" -> True,
    "actual" -> True, "expected" -> True, "difference" -> 0|>,
   <|"group" -> "coverage", "name" ->
     "example call DSSeeds in 01_mixed_bubble_workflow.wl", "passed" -> True,
    "actual" -> True, "expected" -> True, "difference" -> 0|>,
   <|"group" -> "coverage", "name" ->
     "example call DSLinear in 01_mixed_bubble_workflow.wl",
    "passed" -> True, "actual" -> True, "expected" -> True,
    "difference" -> 0|>, <|"group" -> "coverage",
    "name" -> "example call DSInit in 02_function_system_hankel.wl",
    "passed" -> True, "actual" -> True, "expected" -> True,
    "difference" -> 0|>, <|"group" -> "coverage",
    "name" -> "example call DSInfo in 02_function_system_hankel.wl",
    "passed" -> True, "actual" -> True, "expected" -> True,
    "difference" -> 0|>, <|"group" -> "coverage",
    "name" -> "example call DSSeeds in 02_function_system_hankel.wl",
    "passed" -> True, "actual" -> True, "expected" -> True,
    "difference" -> 0|>, <|"group" -> "coverage",
    "name" -> "example call DSInit in 03_two_loop_isp.wl", "passed" -> True,
    "actual" -> True, "expected" -> True, "difference" -> 0|>,
   <|"group" -> "coverage", "name" ->
     "example call DSSeeds in 03_two_loop_isp.wl", "passed" -> True,
    "actual" -> True, "expected" -> True, "difference" -> 0|>,
   <|"group" -> "coverage", "name" ->
     "example call DSLinear in 03_two_loop_isp.wl", "passed" -> True,
    "actual" -> True, "expected" -> True, "difference" -> 0|>,
   <|"group" -> "coverage", "name" ->
     "example call DSInit in 04_pure_massive_bubble_closed_loop/main.wl",
    "passed" -> True, "actual" -> True, "expected" -> True,
    "difference" -> 0|>, <|"group" -> "coverage",
    "name" ->
     "example call DSInfo in 04_pure_massive_bubble_closed_loop/main.wl",
    "passed" -> True, "actual" -> True, "expected" -> True,
    "difference" -> 0|>, <|"group" -> "coverage",
    "name" ->
     "example call DSSeeds in 04_pure_massive_bubble_closed_loop/main.wl",
    "passed" -> True, "actual" -> True, "expected" -> True,
    "difference" -> 0|>, <|"group" -> "coverage",
    "name" ->
     "example call DSLinear in 04_pure_massive_bubble_closed_loop/main.wl",
    "passed" -> True, "actual" -> True, "expected" -> True,
    "difference" -> 0|>, <|"group" -> "coverage",
    "name" ->
     "example call DSKiraExport in \
04_pure_massive_bubble_closed_loop/main.wl", "passed" -> True,
    "actual" -> True, "expected" -> True, "difference" -> 0|>,
   <|"group" -> "coverage", "name" ->
     "example call DSKiraImport in \
04_pure_massive_bubble_closed_loop/main.wl", "passed" -> True,
    "actual" -> True, "expected" -> True, "difference" -> 0|>,
   <|"group" -> "coverage", "name" ->
     "example call DSDE in 04_pure_massive_bubble_closed_loop/main.wl",
    "passed" -> True, "actual" -> True, "expected" -> True,
    "difference" -> 0|>, <|"group" -> "coverage",
    "name" ->
     "example call DSScaleCheck in \
04_pure_massive_bubble_closed_loop/main.wl", "passed" -> True,
    "actual" -> True, "expected" -> True, "difference" -> 0|>,
   <|"group" -> "coverage", "name" ->
     "example call DSMessagesOn in 05_tree_two_vertex_time_ibp/main.wl",
    "passed" -> True, "actual" -> True, "expected" -> True,
    "difference" -> 0|>, <|"group" -> "coverage",
    "name" -> "example call DSInit in 05_tree_two_vertex_time_ibp/main.wl",
    "passed" -> True, "actual" -> True, "expected" -> True,
    "difference" -> 0|>, <|"group" -> "coverage",
    "name" -> "example call DSSeeds in 05_tree_two_vertex_time_ibp/main.wl",
    "passed" -> True, "actual" -> True, "expected" -> True,
    "difference" -> 0|>, <|"group" -> "coverage",
    "name" -> "example call DSLinear in 05_tree_two_vertex_time_ibp/main.wl",
    "passed" -> True, "actual" -> True, "expected" -> True,
    "difference" -> 0|>, <|"group" -> "coverage",
    "name" ->
     "example call DSTreeSeeds in 05_tree_two_vertex_time_ibp/main.wl",
    "passed" -> True, "actual" -> True, "expected" -> True,
    "difference" -> 0|>, <|"group" -> "coverage",
    "name" ->
     "example call repIterative in 05_tree_two_vertex_time_ibp/main.wl",
    "passed" -> True, "actual" -> True, "expected" -> True,
    "difference" -> 0|>, <|"group" -> "coverage",
    "name" ->
     "example call DSTreeNaiveIBP in 05_tree_two_vertex_time_ibp/main.wl",
    "passed" -> True, "actual" -> True, "expected" -> True,
    "difference" -> 0|>, <|"group" -> "coverage",
    "name" ->
     "example call DSTreeNaiveDE in 05_tree_two_vertex_time_ibp/main.wl",
    "passed" -> True, "actual" -> True, "expected" -> True,
    "difference" -> 0|>, <|"group" -> "coverage",
    "name" ->
     "example call DSTreeDLogDE in 05_tree_two_vertex_time_ibp/main.wl",
    "passed" -> True, "actual" -> True, "expected" -> True,
    "difference" -> 0|>, <|"group" -> "coverage",
    "name" ->
     "example call DSKinematics in 06_root_kinematic_coordinates/main.wl",
    "passed" -> True, "actual" -> True, "expected" -> True,
    "difference" -> 0|>, <|"group" -> "coverage",
    "name" ->
     "example call DSMessagesOn in 06_root_kinematic_coordinates/main.wl",
    "passed" -> True, "actual" -> True, "expected" -> True,
    "difference" -> 0|>, <|"group" -> "coverage",
    "name" ->
     "example call DSMessagesOff in 06_root_kinematic_coordinates/main.wl",
    "passed" -> True, "actual" -> True, "expected" -> True,
    "difference" -> 0|>, <|"group" -> "coverage",
    "name" ->
     "example call DSMessagesQ in 06_root_kinematic_coordinates/main.wl",
    "passed" -> True, "actual" -> True, "expected" -> True,
    "difference" -> 0|>, <|"group" -> "coverage",
    "name" -> "example call DSInit in 06_root_kinematic_coordinates/main.wl",
    "passed" -> True, "actual" -> True, "expected" -> True,
    "difference" -> 0|>, <|"group" -> "coverage",
    "name" -> "example call DSInfo in 06_root_kinematic_coordinates/main.wl",
    "passed" -> True, "actual" -> True, "expected" -> True,
    "difference" -> 0|>, <|"group" -> "coverage", "name" -> "example call \
DSParameterNotation in 06_root_kinematic_coordinates/main.wl",
    "passed" -> True, "actual" -> True, "expected" -> True,
    "difference" -> 0|>, <|"group" -> "coverage", "name" -> "example call \
DSRedefineParameters in 06_root_kinematic_coordinates/main.wl",
    "passed" -> True, "actual" -> True, "expected" -> True,
    "difference" -> 0|>, <|"group" -> "coverage",
    "name" ->
     "example call DSPublicAPI in 06_root_kinematic_coordinates/main.wl",
    "passed" -> True, "actual" -> True, "expected" -> True,
    "difference" -> 0|>, <|"group" -> "coverage",
    "name" -> "example call dtau in 06_root_kinematic_coordinates/main.wl",
    "passed" -> True, "actual" -> True, "expected" -> True,
    "difference" -> 0|>, <|"group" -> "coverage",
    "name" -> "example call dqq in 06_root_kinematic_coordinates/main.wl",
    "passed" -> True, "actual" -> True, "expected" -> True,
    "difference" -> 0|>, <|"group" -> "coverage",
    "name" -> "example call dqk in 06_root_kinematic_coordinates/main.wl",
    "passed" -> True, "actual" -> True, "expected" -> True,
    "difference" -> 0|>, <|"group" -> "coverage",
    "name" -> "example call ds in 06_root_kinematic_coordinates/main.wl",
    "passed" -> True, "actual" -> True, "expected" -> True,
    "difference" -> 0|>, <|"group" -> "coverage",
    "name" ->
     "example call rep2innerform in 06_root_kinematic_coordinates/main.wl",
    "passed" -> True, "actual" -> True, "expected" -> True,
    "difference" -> 0|>, <|"group" -> "coverage",
    "name" ->
     "example call rep2outform in 06_root_kinematic_coordinates/main.wl",
    "passed" -> True, "actual" -> True, "expected" -> True,
    "difference" -> 0|>, <|"group" -> "coverage",
    "name" ->
     "example call rep2Integrand in 06_root_kinematic_coordinates/main.wl",
    "passed" -> True, "actual" -> True, "expected" -> True,
    "difference" -> 0|>, <|"group" -> "coverage",
    "name" -> "example call symmetry in \
06_root_kinematic_coordinates/main.wl", "passed" -> True, "actual" -> True,
    "expected" -> True, "difference" -> 0|>, <|"group" -> "coverage",
    "name" ->
     "example call repSymmetry0 in 06_root_kinematic_coordinates/main.wl",
    "passed" -> True, "actual" -> True, "expected" -> True,
    "difference" -> 0|>, <|"group" -> "coverage",
    "name" -> "manual API DSInit", "passed" -> True, "actual" -> True,
    "expected" -> True, "difference" -> 0|>, <|"group" -> "coverage",
    "name" -> "manual API DSInfo", "passed" -> True, "actual" -> True,
    "expected" -> True, "difference" -> 0|>, <|"group" -> "coverage",
    "name" -> "manual API DSKinematics", "passed" -> True, "actual" -> True,
    "expected" -> True, "difference" -> 0|>, <|"group" -> "coverage",
    "name" -> "manual API DSParameterNotation", "passed" -> True,
    "actual" -> True, "expected" -> True, "difference" -> 0|>,
   <|"group" -> "coverage", "name" -> "manual API DSRedefineParameters",
    "passed" -> True, "actual" -> True, "expected" -> True,
    "difference" -> 0|>, <|"group" -> "coverage",
    "name" -> "manual API DSMessagesOn", "passed" -> True, "actual" -> True,
    "expected" -> True, "difference" -> 0|>, <|"group" -> "coverage",
    "name" -> "manual API DSMessagesOff", "passed" -> True, "actual" -> True,
    "expected" -> True, "difference" -> 0|>, <|"group" -> "coverage",
    "name" -> "manual API DSMessagesQ", "passed" -> True, "actual" -> True,
    "expected" -> True, "difference" -> 0|>, <|"group" -> "coverage",
    "name" -> "manual API dtau", "passed" -> True, "actual" -> True,
    "expected" -> True, "difference" -> 0|>, <|"group" -> "coverage",
    "name" -> "manual API dqq", "passed" -> True, "actual" -> True,
    "expected" -> True, "difference" -> 0|>, <|"group" -> "coverage",
    "name" -> "manual API dqk", "passed" -> True, "actual" -> True,
    "expected" -> True, "difference" -> 0|>, <|"group" -> "coverage",
    "name" -> "manual API ds", "passed" -> True, "actual" -> True,
    "expected" -> True, "difference" -> 0|>, <|"group" -> "coverage",
    "name" -> "manual API rep2innerform", "passed" -> True, "actual" -> True,
    "expected" -> True, "difference" -> 0|>, <|"group" -> "coverage",
    "name" -> "manual API rep2outform", "passed" -> True, "actual" -> True,
    "expected" -> True, "difference" -> 0|>, <|"group" -> "coverage",
    "name" -> "manual API rep2Integrand", "passed" -> True, "actual" -> True,
    "expected" -> True, "difference" -> 0|>, <|"group" -> "coverage",
    "name" -> "manual API symmetry", "passed" -> True, "actual" -> True,
    "expected" -> True, "difference" -> 0|>, <|"group" -> "coverage",
    "name" -> "manual API repSymmetry0", "passed" -> True, "actual" -> True,
    "expected" -> True, "difference" -> 0|>, <|"group" -> "coverage",
    "name" -> "manual API DSSeeds", "passed" -> True, "actual" -> True,
    "expected" -> True, "difference" -> 0|>, <|"group" -> "coverage",
    "name" -> "manual API DSLinear", "passed" -> True, "actual" -> True,
    "expected" -> True, "difference" -> 0|>, <|"group" -> "coverage",
    "name" -> "manual API DSKiraExport", "passed" -> True, "actual" -> True,
    "expected" -> True, "difference" -> 0|>, <|"group" -> "coverage",
    "name" -> "manual API DSKiraImport", "passed" -> True, "actual" -> True,
    "expected" -> True, "difference" -> 0|>, <|"group" -> "coverage",
    "name" -> "manual API DSDE", "passed" -> True, "actual" -> True,
    "expected" -> True, "difference" -> 0|>, <|"group" -> "coverage",
    "name" -> "manual API DSScaleCheck", "passed" -> True, "actual" -> True,
    "expected" -> True, "difference" -> 0|>, <|"group" -> "coverage",
    "name" -> "manual API DSTreeSeeds", "passed" -> True, "actual" -> True,
    "expected" -> True, "difference" -> 0|>, <|"group" -> "coverage",
    "name" -> "manual API repIterative", "passed" -> True, "actual" -> True,
    "expected" -> True, "difference" -> 0|>, <|"group" -> "coverage",
    "name" -> "manual API DSTreeNaiveIBP", "passed" -> True,
    "actual" -> True, "expected" -> True, "difference" -> 0|>,
   <|"group" -> "coverage", "name" -> "manual API DSTreeNaiveDE",
    "passed" -> True, "actual" -> True, "expected" -> True,
    "difference" -> 0|>, <|"group" -> "coverage",
    "name" -> "manual API DSTreeDLogDE", "passed" -> True, "actual" -> True,
    "expected" -> True, "difference" -> 0|>, <|"group" -> "coverage",
    "name" -> "manual API DSPublicAPI", "passed" -> True, "actual" -> True,
    "expected" -> True, "difference" -> 0|>, <|"group" -> "coverage",
    "name" -> "manual rendered page count", "passed" -> True,
    "actual" -> True, "expected" -> True, "difference" -> 0|>,
   <|"group" -> "coverage", "name" -> "manual rendered pages nonblank",
    "passed" -> True, "actual" -> True, "expected" -> True,
    "difference" -> 0|>}|>
