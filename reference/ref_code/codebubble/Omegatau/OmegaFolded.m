(* Created with the Wolfram Language : www.wolfram.com *)
{{-1/4*((1 + a0)*(log[P1 - x1 - x2] + log[P1 + x1 - x2] + log[P1 - x1 + x2] + 
      log[P1 + x1 + x2])) - 
   ((1 + a0)*(log[P2 - x1 - x2] + log[P2 + x1 - x2] + log[P2 - x1 + x2] + 
      log[P2 + x1 + x2]))/4, (I/4)*(a0 - 2*nu)*(log[P2 - x1 - x2] + 
    log[P2 + x1 - x2] - log[P2 - x1 + x2] - log[P2 + x1 + x2]), 
  (I/4)*(a0 - 2*nu)*(log[P2 - x1 - x2] - log[P2 + x1 - x2] + 
    log[P2 - x1 + x2] - log[P2 + x1 + x2]), 
  ((-1 + a0 - 4*nu)*(log[P2 - x1 - x2] - log[P2 + x1 - x2] - 
     log[P2 - x1 + x2] + log[P2 + x1 + x2]))/4, 
  (I/4)*(a0 - 2*nu)*(log[P1 - x1 - x2] + log[P1 + x1 - x2] - 
    log[P1 - x1 + x2] - log[P1 + x1 + x2]), 0, 0, 0, 
  (I/4)*(a0 - 2*nu)*(log[P1 - x1 - x2] - log[P1 + x1 - x2] + 
    log[P1 - x1 + x2] - log[P1 + x1 + x2]), 0, 0, 0, 
  ((-1 + a0 - 4*nu)*(log[P1 - x1 - x2] - log[P1 + x1 - x2] - 
     log[P1 - x1 + x2] + log[P1 + x1 + x2]))/4, 0, 0, 0, 
  (I/4)*(log[P1 - x1 - x2] + log[P2 - x1 - x2] + log[P1 + x1 - x2] + 
     log[P2 + x1 - x2] - log[P1 - x1 + x2] - log[P2 - x1 + x2] - 
     log[P1 + x1 + x2] - log[P2 + x1 + x2]) + 
   (I/4)*(log[P1 - x1 - x2] + log[P2 - x1 - x2] - log[P1 + x1 - x2] - 
     log[P2 + x1 - x2] + log[P1 - x1 + x2] + log[P2 - x1 + x2] - 
     log[P1 + x1 + x2] - log[P2 + x1 + x2]), 
  (log[P2 - x1 - x2] - log[P2 + x1 - x2] - log[P2 - x1 + x2] + 
    log[P2 + x1 + x2])/2, (log[P1 - x1 - x2] - log[P1 + x1 - x2] - 
    log[P1 - x1 + x2] + log[P1 + x1 + x2])/2, 0}, 
 {(-1/4*I)*(1 + a0)*(log[P2 - x1 - x2] + log[P2 + x1 - x2] - 
    log[P2 - x1 + x2] - log[P2 + x1 + x2]), -((1 + 2*nu)*log[x2]) - 
   ((1 + a0)*(log[P1 - x1 - x2] + log[P1 + x1 - x2] + log[P1 - x1 + x2] + 
      log[P1 + x1 + x2]))/4 - 
   ((a0 - 2*nu)*(log[P2 - x1 - x2] + log[P2 + x1 - x2] + log[P2 - x1 + x2] + 
      log[P2 + x1 + x2]))/4, 
  -1/4*((a0 - 2*nu)*(log[P2 - x1 - x2] - log[P2 + x1 - x2] - 
     log[P2 - x1 + x2] + log[P2 + x1 + x2])), (I/4)*(-1 + a0 - 4*nu)*
   (log[P2 - x1 - x2] - log[P2 + x1 - x2] + log[P2 - x1 + x2] - 
    log[P2 + x1 + x2]), 0, (I/4)*(a0 - 2*nu)*(log[P1 - x1 - x2] + 
    log[P1 + x1 - x2] - log[P1 - x1 + x2] - log[P1 + x1 + x2]), 0, 0, 0, 
  (I/4)*(a0 - 2*nu)*(log[P1 - x1 - x2] - log[P1 + x1 - x2] + 
    log[P1 - x1 + x2] - log[P1 + x1 + x2]), 0, 0, 0, 
  ((-1 + a0 - 4*nu)*(log[P1 - x1 - x2] - log[P1 + x1 - x2] - 
     log[P1 - x1 + x2] + log[P1 + x1 + x2]))/4, 0, 0, 
  (-log[P2 - x1 - x2] + log[P2 + x1 - x2] + log[P2 - x1 + x2] - 
     log[P2 + x1 + x2])/4 + (log[P1 - x1 - x2] - log[P2 - x1 - x2] + 
     log[P1 + x1 - x2] - log[P2 + x1 - x2] + log[P1 - x1 + x2] - 
     log[P2 - x1 + x2] + log[P1 + x1 + x2] - log[P2 + x1 + x2])/4, 
  (I/4)*(log[P2 - x1 - x2] - log[P2 + x1 - x2] + log[P2 - x1 + x2] - 
     log[P2 + x1 + x2]) + (I/4)*(log[P1 - x1 - x2] + log[P2 - x1 - x2] - 
     log[P1 + x1 - x2] - log[P2 + x1 - x2] + log[P1 - x1 + x2] + 
     log[P2 - x1 + x2] - log[P1 + x1 + x2] - log[P2 + x1 + x2]), 
  (-1/4*I)*(log[P1 - x1 - x2] - log[P1 + x1 - x2] + log[P1 - x1 + x2] - 
    log[P1 + x1 + x2]), (log[P1 - x1 - x2] - log[P1 + x1 - x2] - 
    log[P1 - x1 + x2] + log[P1 + x1 + x2])/4}, 
 {(-1/4*I)*(1 + a0)*(log[P2 - x1 - x2] - log[P2 + x1 - x2] + 
    log[P2 - x1 + x2] - log[P2 + x1 + x2]), 
  -1/4*((a0 - 2*nu)*(log[P2 - x1 - x2] - log[P2 + x1 - x2] - 
     log[P2 - x1 + x2] + log[P2 + x1 + x2])), -((1 + 2*nu)*log[x1]) - 
   ((1 + a0)*(log[P1 - x1 - x2] + log[P1 + x1 - x2] + log[P1 - x1 + x2] + 
      log[P1 + x1 + x2]))/4 - 
   ((a0 - 2*nu)*(log[P2 - x1 - x2] + log[P2 + x1 - x2] + log[P2 - x1 + x2] + 
      log[P2 + x1 + x2]))/4, (I/4)*(-1 + a0 - 4*nu)*
   (log[P2 - x1 - x2] + log[P2 + x1 - x2] - log[P2 - x1 + x2] - 
    log[P2 + x1 + x2]), 0, 0, (I/4)*(a0 - 2*nu)*
   (log[P1 - x1 - x2] + log[P1 + x1 - x2] - log[P1 - x1 + x2] - 
    log[P1 + x1 + x2]), 0, 0, 0, (I/4)*(a0 - 2*nu)*
   (log[P1 - x1 - x2] - log[P1 + x1 - x2] + log[P1 - x1 + x2] - 
    log[P1 + x1 + x2]), 0, 0, 0, 
  ((-1 + a0 - 4*nu)*(log[P1 - x1 - x2] - log[P1 + x1 - x2] - 
     log[P1 - x1 + x2] + log[P1 + x1 + x2]))/4, 0, 
  (-log[P2 - x1 - x2] + log[P2 + x1 - x2] + log[P2 - x1 + x2] - 
     log[P2 + x1 + x2])/4 + (log[P1 - x1 - x2] - log[P2 - x1 - x2] + 
     log[P1 + x1 - x2] - log[P2 + x1 - x2] + log[P1 - x1 + x2] - 
     log[P2 - x1 + x2] + log[P1 + x1 + x2] - log[P2 + x1 + x2])/4, 
  (I/4)*(log[P2 - x1 - x2] + log[P2 + x1 - x2] - log[P2 - x1 + x2] - 
     log[P2 + x1 + x2]) + (I/4)*(log[P1 - x1 - x2] + log[P2 - x1 - x2] + 
     log[P1 + x1 - x2] + log[P2 + x1 - x2] - log[P1 - x1 + x2] - 
     log[P2 - x1 + x2] - log[P1 + x1 + x2] - log[P2 + x1 + x2]), 
  (-1/4*I)*(log[P1 - x1 - x2] + log[P1 + x1 - x2] - log[P1 - x1 + x2] - 
    log[P1 + x1 + x2]), (log[P1 - x1 - x2] - log[P1 + x1 - x2] - 
    log[P1 - x1 + x2] + log[P1 + x1 + x2])/4}, 
 {((1 + a0)*(log[P2 - x1 - x2] - log[P2 + x1 - x2] - log[P2 - x1 + x2] + 
     log[P2 + x1 + x2]))/4, (-1/4*I)*(a0 - 2*nu)*
   (log[P2 - x1 - x2] - log[P2 + x1 - x2] + log[P2 - x1 + x2] - 
    log[P2 + x1 + x2]), (-1/4*I)*(a0 - 2*nu)*(log[P2 - x1 - x2] + 
    log[P2 + x1 - x2] - log[P2 - x1 + x2] - log[P2 + x1 + x2]), 
  -((1 + 2*nu)*log[x1]) - (1 + 2*nu)*log[x2] - 
   ((1 + a0)*(log[P1 - x1 - x2] + log[P1 + x1 - x2] + log[P1 - x1 + x2] + 
      log[P1 + x1 + x2]))/4 - 
   ((-1 + a0 - 4*nu)*(log[P2 - x1 - x2] + log[P2 + x1 - x2] + 
      log[P2 - x1 + x2] + log[P2 + x1 + x2]))/4, 0, 0, 0, 
  (I/4)*(a0 - 2*nu)*(log[P1 - x1 - x2] + log[P1 + x1 - x2] - 
    log[P1 - x1 + x2] - log[P1 + x1 + x2]), 0, 0, 0, 
  (I/4)*(a0 - 2*nu)*(log[P1 - x1 - x2] - log[P1 + x1 - x2] + 
    log[P1 - x1 + x2] - log[P1 + x1 + x2]), 0, 0, 0, 
  ((-1 + a0 - 4*nu)*(log[P1 - x1 - x2] - log[P1 + x1 - x2] - 
     log[P1 - x1 + x2] + log[P1 + x1 + x2]))/4, 
  (-1/4*I)*(log[P2 - x1 - x2] + log[P2 + x1 - x2] - log[P2 - x1 + x2] - 
     log[P2 + x1 + x2]) - (I/4)*(log[P2 - x1 - x2] - log[P2 + x1 - x2] + 
     log[P2 - x1 + x2] - log[P2 + x1 + x2]), 
  (log[P1 - x1 - x2] - log[P2 - x1 - x2] + log[P1 + x1 - x2] - 
    log[P2 + x1 - x2] + log[P1 - x1 + x2] - log[P2 - x1 + x2] + 
    log[P1 + x1 + x2] - log[P2 + x1 + x2])/2, 0, 
  (-1/4*I)*(log[P1 - x1 - x2] + log[P1 + x1 - x2] - log[P1 - x1 + x2] - 
     log[P1 + x1 + x2]) - (I/4)*(log[P1 - x1 - x2] - log[P1 + x1 - x2] + 
     log[P1 - x1 + x2] - log[P1 + x1 + x2])}, 
 {(-1/4*I)*(1 + a0)*(log[P1 - x1 - x2] + log[P1 + x1 - x2] - 
    log[P1 - x1 + x2] - log[P1 + x1 + x2]), 0, 0, 0, 
  -((1 + 2*nu)*log[x2]) - ((a0 - 2*nu)*(log[P1 - x1 - x2] + 
      log[P1 + x1 - x2] + log[P1 - x1 + x2] + log[P1 + x1 + x2]))/4 - 
   ((1 + a0)*(log[P2 - x1 - x2] + log[P2 + x1 - x2] + log[P2 - x1 + x2] + 
      log[P2 + x1 + x2]))/4, (I/4)*(a0 - 2*nu)*(log[P2 - x1 - x2] + 
    log[P2 + x1 - x2] - log[P2 - x1 + x2] - log[P2 + x1 + x2]), 
  (I/4)*(a0 - 2*nu)*(log[P2 - x1 - x2] - log[P2 + x1 - x2] + 
    log[P2 - x1 + x2] - log[P2 + x1 + x2]), 
  ((-1 + a0 - 4*nu)*(log[P2 - x1 - x2] - log[P2 + x1 - x2] - 
     log[P2 - x1 + x2] + log[P2 + x1 + x2]))/4, 
  -1/4*((a0 - 2*nu)*(log[P1 - x1 - x2] - log[P1 + x1 - x2] - 
     log[P1 - x1 + x2] + log[P1 + x1 + x2])), 0, 0, 0, 
  (I/4)*(-1 + a0 - 4*nu)*(log[P1 - x1 - x2] - log[P1 + x1 - x2] + 
    log[P1 - x1 + x2] - log[P1 + x1 + x2]), 0, 0, 0, 
  (-log[P1 - x1 - x2] + log[P1 + x1 - x2] + log[P1 - x1 + x2] - 
     log[P1 + x1 + x2])/4 + (-log[P1 - x1 - x2] + log[P2 - x1 - x2] - 
     log[P1 + x1 - x2] + log[P2 + x1 - x2] - log[P1 - x1 + x2] + 
     log[P2 - x1 + x2] - log[P1 + x1 + x2] + log[P2 + x1 + x2])/4, 
  (-1/4*I)*(log[P2 - x1 - x2] - log[P2 + x1 - x2] + log[P2 - x1 + x2] - 
    log[P2 + x1 + x2]), (I/4)*(log[P1 - x1 - x2] - log[P1 + x1 - x2] + 
     log[P1 - x1 + x2] - log[P1 + x1 + x2]) + 
   (I/4)*(log[P1 - x1 - x2] + log[P2 - x1 - x2] - log[P1 + x1 - x2] - 
     log[P2 + x1 - x2] + log[P1 - x1 + x2] + log[P2 - x1 + x2] - 
     log[P1 + x1 + x2] - log[P2 + x1 + x2]), 
  (log[P2 - x1 - x2] - log[P2 + x1 - x2] - log[P2 - x1 + x2] + 
    log[P2 + x1 + x2])/4}, 
 {0, (-1/4*I)*(1 + a0)*(log[P1 - x1 - x2] + log[P1 + x1 - x2] - 
    log[P1 - x1 + x2] - log[P1 + x1 + x2]), 0, 0, 
  (-1/4*I)*(1 + a0)*(log[P2 - x1 - x2] + log[P2 + x1 - x2] - 
    log[P2 - x1 + x2] - log[P2 + x1 + x2]), -2*(1 + 2*nu)*log[x2] - 
   ((a0 - 2*nu)*(log[P1 - x1 - x2] + log[P1 + x1 - x2] + log[P1 - x1 + x2] + 
      log[P1 + x1 + x2]))/4 - 
   ((a0 - 2*nu)*(log[P2 - x1 - x2] + log[P2 + x1 - x2] + log[P2 - x1 + x2] + 
      log[P2 + x1 + x2]))/4, 
  -1/4*((a0 - 2*nu)*(log[P2 - x1 - x2] - log[P2 + x1 - x2] - 
     log[P2 - x1 + x2] + log[P2 + x1 + x2])), (I/4)*(-1 + a0 - 4*nu)*
   (log[P2 - x1 - x2] - log[P2 + x1 - x2] + log[P2 - x1 + x2] - 
    log[P2 + x1 + x2]), 0, 
  -1/4*((a0 - 2*nu)*(log[P1 - x1 - x2] - log[P1 + x1 - x2] - 
     log[P1 - x1 + x2] + log[P1 + x1 + x2])), 0, 0, 0, 
  (I/4)*(-1 + a0 - 4*nu)*(log[P1 - x1 - x2] - log[P1 + x1 - x2] + 
    log[P1 - x1 + x2] - log[P1 + x1 + x2]), 0, 0, 
  (I/4)*(log[P1 - x1 - x2] + log[P2 - x1 - x2] + log[P1 + x1 - x2] + 
    log[P2 + x1 - x2] - log[P1 - x1 + x2] - log[P2 - x1 + x2] - 
    log[P1 + x1 + x2] - log[P2 + x1 + x2]), 
  (-log[P1 - x1 - x2] + log[P1 + x1 - x2] + log[P1 - x1 + x2] - 
     log[P1 + x1 + x2])/4 + (log[P2 - x1 - x2] - log[P2 + x1 - x2] - 
     log[P2 - x1 + x2] + log[P2 + x1 + x2])/4, 
  (log[P1 - x1 - x2] - log[P1 + x1 - x2] - log[P1 - x1 + x2] + 
     log[P1 + x1 + x2])/4 + (-log[P2 - x1 - x2] + log[P2 + x1 - x2] + 
     log[P2 - x1 + x2] - log[P2 + x1 + x2])/4, 
  (I/4)*(log[P1 - x1 - x2] + log[P2 - x1 - x2] - log[P1 + x1 - x2] - 
    log[P2 + x1 - x2] + log[P1 - x1 + x2] + log[P2 - x1 + x2] - 
    log[P1 + x1 + x2] - log[P2 + x1 + x2])}, 
 {0, 0, (-1/4*I)*(1 + a0)*(log[P1 - x1 - x2] + log[P1 + x1 - x2] - 
    log[P1 - x1 + x2] - log[P1 + x1 + x2]), 0, 
  (-1/4*I)*(1 + a0)*(log[P2 - x1 - x2] - log[P2 + x1 - x2] + 
    log[P2 - x1 + x2] - log[P2 + x1 + x2]), 
  -1/4*((a0 - 2*nu)*(log[P2 - x1 - x2] - log[P2 + x1 - x2] - 
     log[P2 - x1 + x2] + log[P2 + x1 + x2])), -((1 + 2*nu)*log[x1]) - 
   (1 + 2*nu)*log[x2] - ((a0 - 2*nu)*(log[P1 - x1 - x2] + log[P1 + x1 - x2] + 
      log[P1 - x1 + x2] + log[P1 + x1 + x2]))/4 - 
   ((a0 - 2*nu)*(log[P2 - x1 - x2] + log[P2 + x1 - x2] + log[P2 - x1 + x2] + 
      log[P2 + x1 + x2]))/4, (I/4)*(-1 + a0 - 4*nu)*
   (log[P2 - x1 - x2] + log[P2 + x1 - x2] - log[P2 - x1 + x2] - 
    log[P2 + x1 + x2]), 0, 0, 
  -1/4*((a0 - 2*nu)*(log[P1 - x1 - x2] - log[P1 + x1 - x2] - 
     log[P1 - x1 + x2] + log[P1 + x1 + x2])), 0, 0, 0, 
  (I/4)*(-1 + a0 - 4*nu)*(log[P1 - x1 - x2] - log[P1 + x1 - x2] + 
    log[P1 - x1 + x2] - log[P1 + x1 + x2]), 0, 
  (I/4)*(log[P1 - x1 - x2] + log[P1 + x1 - x2] - log[P1 - x1 + x2] - 
     log[P1 + x1 + x2]) + (I/4)*(log[P2 - x1 - x2] - log[P2 + x1 - x2] + 
     log[P2 - x1 + x2] - log[P2 + x1 + x2]), 
  (-log[P1 - x1 - x2] + log[P2 - x1 - x2] - log[P1 + x1 - x2] + 
    log[P2 + x1 - x2] - log[P1 - x1 + x2] + log[P2 - x1 + x2] - 
    log[P1 + x1 + x2] + log[P2 + x1 + x2])/4, 
  (log[P1 - x1 - x2] - log[P2 - x1 - x2] + log[P1 + x1 - x2] - 
    log[P2 + x1 - x2] + log[P1 - x1 + x2] - log[P2 - x1 + x2] + 
    log[P1 + x1 + x2] - log[P2 + x1 + x2])/4, 
  (I/4)*(log[P1 - x1 - x2] - log[P1 + x1 - x2] + log[P1 - x1 + x2] - 
     log[P1 + x1 + x2]) + (I/4)*(log[P2 - x1 - x2] + log[P2 + x1 - x2] - 
     log[P2 - x1 + x2] - log[P2 + x1 + x2])}, 
 {0, 0, 0, (-1/4*I)*(1 + a0)*(log[P1 - x1 - x2] + log[P1 + x1 - x2] - 
    log[P1 - x1 + x2] - log[P1 + x1 + x2]), 
  ((1 + a0)*(log[P2 - x1 - x2] - log[P2 + x1 - x2] - log[P2 - x1 + x2] + 
     log[P2 + x1 + x2]))/4, (-1/4*I)*(a0 - 2*nu)*
   (log[P2 - x1 - x2] - log[P2 + x1 - x2] + log[P2 - x1 + x2] - 
    log[P2 + x1 + x2]), (-1/4*I)*(a0 - 2*nu)*(log[P2 - x1 - x2] + 
    log[P2 + x1 - x2] - log[P2 - x1 + x2] - log[P2 + x1 + x2]), 
  -((1 + 2*nu)*log[x1]) - 2*(1 + 2*nu)*log[x2] - 
   ((a0 - 2*nu)*(log[P1 - x1 - x2] + log[P1 + x1 - x2] + log[P1 - x1 + x2] + 
      log[P1 + x1 + x2]))/4 - 
   ((-1 + a0 - 4*nu)*(log[P2 - x1 - x2] + log[P2 + x1 - x2] + 
      log[P2 - x1 + x2] + log[P2 + x1 + x2]))/4, 0, 0, 0, 
  -1/4*((a0 - 2*nu)*(log[P1 - x1 - x2] - log[P1 + x1 - x2] - 
     log[P1 - x1 + x2] + log[P1 + x1 + x2])), 0, 0, 0, 
  (I/4)*(-1 + a0 - 4*nu)*(log[P1 - x1 - x2] - log[P1 + x1 - x2] + 
    log[P1 - x1 + x2] - log[P1 + x1 + x2]), 
  (-log[P2 - x1 - x2] + log[P2 + x1 - x2] + log[P2 - x1 + x2] - 
    log[P2 + x1 + x2])/4, (I/4)*(log[P1 - x1 - x2] + log[P1 + x1 - x2] - 
     log[P1 - x1 + x2] - log[P1 + x1 + x2]) + 
   (I/4)*(log[P1 - x1 - x2] + log[P2 - x1 - x2] + log[P1 + x1 - x2] + 
     log[P2 + x1 - x2] - log[P1 - x1 + x2] - log[P2 - x1 + x2] - 
     log[P1 + x1 + x2] - log[P2 + x1 + x2]), 
  (-1/4*I)*(log[P2 - x1 - x2] + log[P2 + x1 - x2] - log[P2 - x1 + x2] - 
    log[P2 + x1 + x2]), (log[P1 - x1 - x2] - log[P1 + x1 - x2] - 
     log[P1 - x1 + x2] + log[P1 + x1 + x2])/4 + 
   (log[P1 - x1 - x2] - log[P2 - x1 - x2] + log[P1 + x1 - x2] - 
     log[P2 + x1 - x2] + log[P1 - x1 + x2] - log[P2 - x1 + x2] + 
     log[P1 + x1 + x2] - log[P2 + x1 + x2])/4}, 
 {(-1/4*I)*(1 + a0)*(log[P1 - x1 - x2] - log[P1 + x1 - x2] + 
    log[P1 - x1 + x2] - log[P1 + x1 + x2]), 0, 0, 0, 
  -1/4*((a0 - 2*nu)*(log[P1 - x1 - x2] - log[P1 + x1 - x2] - 
     log[P1 - x1 + x2] + log[P1 + x1 + x2])), 0, 0, 0, 
  -((1 + 2*nu)*log[x1]) - ((a0 - 2*nu)*(log[P1 - x1 - x2] + 
      log[P1 + x1 - x2] + log[P1 - x1 + x2] + log[P1 + x1 + x2]))/4 - 
   ((1 + a0)*(log[P2 - x1 - x2] + log[P2 + x1 - x2] + log[P2 - x1 + x2] + 
      log[P2 + x1 + x2]))/4, (I/4)*(a0 - 2*nu)*(log[P2 - x1 - x2] + 
    log[P2 + x1 - x2] - log[P2 - x1 + x2] - log[P2 + x1 + x2]), 
  (I/4)*(a0 - 2*nu)*(log[P2 - x1 - x2] - log[P2 + x1 - x2] + 
    log[P2 - x1 + x2] - log[P2 + x1 + x2]), 
  ((-1 + a0 - 4*nu)*(log[P2 - x1 - x2] - log[P2 + x1 - x2] - 
     log[P2 - x1 + x2] + log[P2 + x1 + x2]))/4, 
  (I/4)*(-1 + a0 - 4*nu)*(log[P1 - x1 - x2] + log[P1 + x1 - x2] - 
    log[P1 - x1 + x2] - log[P1 + x1 + x2]), 0, 0, 0, 
  (-log[P1 - x1 - x2] + log[P1 + x1 - x2] + log[P1 - x1 + x2] - 
     log[P1 + x1 + x2])/4 + (-log[P1 - x1 - x2] + log[P2 - x1 - x2] - 
     log[P1 + x1 - x2] + log[P2 + x1 - x2] - log[P1 - x1 + x2] + 
     log[P2 - x1 + x2] - log[P1 + x1 + x2] + log[P2 + x1 + x2])/4, 
  (-1/4*I)*(log[P2 - x1 - x2] + log[P2 + x1 - x2] - log[P2 - x1 + x2] - 
    log[P2 + x1 + x2]), (I/4)*(log[P1 - x1 - x2] + log[P1 + x1 - x2] - 
     log[P1 - x1 + x2] - log[P1 + x1 + x2]) + 
   (I/4)*(log[P1 - x1 - x2] + log[P2 - x1 - x2] + log[P1 + x1 - x2] + 
     log[P2 + x1 - x2] - log[P1 - x1 + x2] - log[P2 - x1 + x2] - 
     log[P1 + x1 + x2] - log[P2 + x1 + x2]), 
  (log[P2 - x1 - x2] - log[P2 + x1 - x2] - log[P2 - x1 + x2] + 
    log[P2 + x1 + x2])/4}, 
 {0, (-1/4*I)*(1 + a0)*(log[P1 - x1 - x2] - log[P1 + x1 - x2] + 
    log[P1 - x1 + x2] - log[P1 + x1 + x2]), 0, 0, 0, 
  -1/4*((a0 - 2*nu)*(log[P1 - x1 - x2] - log[P1 + x1 - x2] - 
     log[P1 - x1 + x2] + log[P1 + x1 + x2])), 0, 0, 
  (-1/4*I)*(1 + a0)*(log[P2 - x1 - x2] + log[P2 + x1 - x2] - 
    log[P2 - x1 + x2] - log[P2 + x1 + x2]), -((1 + 2*nu)*log[x1]) - 
   (1 + 2*nu)*log[x2] - ((a0 - 2*nu)*(log[P1 - x1 - x2] + log[P1 + x1 - x2] + 
      log[P1 - x1 + x2] + log[P1 + x1 + x2]))/4 - 
   ((a0 - 2*nu)*(log[P2 - x1 - x2] + log[P2 + x1 - x2] + log[P2 - x1 + x2] + 
      log[P2 + x1 + x2]))/4, 
  -1/4*((a0 - 2*nu)*(log[P2 - x1 - x2] - log[P2 + x1 - x2] - 
     log[P2 - x1 + x2] + log[P2 + x1 + x2])), (I/4)*(-1 + a0 - 4*nu)*
   (log[P2 - x1 - x2] - log[P2 + x1 - x2] + log[P2 - x1 + x2] - 
    log[P2 + x1 + x2]), 0, (I/4)*(-1 + a0 - 4*nu)*
   (log[P1 - x1 - x2] + log[P1 + x1 - x2] - log[P1 - x1 + x2] - 
    log[P1 + x1 + x2]), 0, 0, 
  (I/4)*(log[P1 - x1 - x2] - log[P1 + x1 - x2] + log[P1 - x1 + x2] - 
     log[P1 + x1 + x2]) + (I/4)*(log[P2 - x1 - x2] + log[P2 + x1 - x2] - 
     log[P2 - x1 + x2] - log[P2 + x1 + x2]), 
  (-log[P1 - x1 - x2] + log[P2 - x1 - x2] - log[P1 + x1 - x2] + 
    log[P2 + x1 - x2] - log[P1 - x1 + x2] + log[P2 - x1 + x2] - 
    log[P1 + x1 + x2] + log[P2 + x1 + x2])/4, 
  (log[P1 - x1 - x2] - log[P2 - x1 - x2] + log[P1 + x1 - x2] - 
    log[P2 + x1 - x2] + log[P1 - x1 + x2] - log[P2 - x1 + x2] + 
    log[P1 + x1 + x2] - log[P2 + x1 + x2])/4, 
  (I/4)*(log[P1 - x1 - x2] + log[P1 + x1 - x2] - log[P1 - x1 + x2] - 
     log[P1 + x1 + x2]) + (I/4)*(log[P2 - x1 - x2] - log[P2 + x1 - x2] + 
     log[P2 - x1 + x2] - log[P2 + x1 + x2])}, 
 {0, 0, (-1/4*I)*(1 + a0)*(log[P1 - x1 - x2] - log[P1 + x1 - x2] + 
    log[P1 - x1 + x2] - log[P1 + x1 + x2]), 0, 0, 0, 
  -1/4*((a0 - 2*nu)*(log[P1 - x1 - x2] - log[P1 + x1 - x2] - 
     log[P1 - x1 + x2] + log[P1 + x1 + x2])), 0, 
  (-1/4*I)*(1 + a0)*(log[P2 - x1 - x2] - log[P2 + x1 - x2] + 
    log[P2 - x1 + x2] - log[P2 + x1 + x2]), 
  -1/4*((a0 - 2*nu)*(log[P2 - x1 - x2] - log[P2 + x1 - x2] - 
     log[P2 - x1 + x2] + log[P2 + x1 + x2])), -2*(1 + 2*nu)*log[x1] - 
   ((a0 - 2*nu)*(log[P1 - x1 - x2] + log[P1 + x1 - x2] + log[P1 - x1 + x2] + 
      log[P1 + x1 + x2]))/4 - 
   ((a0 - 2*nu)*(log[P2 - x1 - x2] + log[P2 + x1 - x2] + log[P2 - x1 + x2] + 
      log[P2 + x1 + x2]))/4, (I/4)*(-1 + a0 - 4*nu)*
   (log[P2 - x1 - x2] + log[P2 + x1 - x2] - log[P2 - x1 + x2] - 
    log[P2 + x1 + x2]), 0, 0, (I/4)*(-1 + a0 - 4*nu)*
   (log[P1 - x1 - x2] + log[P1 + x1 - x2] - log[P1 - x1 + x2] - 
    log[P1 + x1 + x2]), 0, (I/4)*(log[P1 - x1 - x2] + log[P2 - x1 - x2] - 
    log[P1 + x1 - x2] - log[P2 + x1 - x2] + log[P1 - x1 + x2] + 
    log[P2 - x1 + x2] - log[P1 + x1 + x2] - log[P2 + x1 + x2]), 
  (-log[P1 - x1 - x2] + log[P1 + x1 - x2] + log[P1 - x1 + x2] - 
     log[P1 + x1 + x2])/4 + (log[P2 - x1 - x2] - log[P2 + x1 - x2] - 
     log[P2 - x1 + x2] + log[P2 + x1 + x2])/4, 
  (log[P1 - x1 - x2] - log[P1 + x1 - x2] - log[P1 - x1 + x2] + 
     log[P1 + x1 + x2])/4 + (-log[P2 - x1 - x2] + log[P2 + x1 - x2] + 
     log[P2 - x1 + x2] - log[P2 + x1 + x2])/4, 
  (I/4)*(log[P1 - x1 - x2] + log[P2 - x1 - x2] + log[P1 + x1 - x2] + 
    log[P2 + x1 - x2] - log[P1 - x1 + x2] - log[P2 - x1 + x2] - 
    log[P1 + x1 + x2] - log[P2 + x1 + x2])}, 
 {0, 0, 0, (-1/4*I)*(1 + a0)*(log[P1 - x1 - x2] - log[P1 + x1 - x2] + 
    log[P1 - x1 + x2] - log[P1 + x1 + x2]), 0, 0, 0, 
  -1/4*((a0 - 2*nu)*(log[P1 - x1 - x2] - log[P1 + x1 - x2] - 
     log[P1 - x1 + x2] + log[P1 + x1 + x2])), 
  ((1 + a0)*(log[P2 - x1 - x2] - log[P2 + x1 - x2] - log[P2 - x1 + x2] + 
     log[P2 + x1 + x2]))/4, (-1/4*I)*(a0 - 2*nu)*
   (log[P2 - x1 - x2] - log[P2 + x1 - x2] + log[P2 - x1 + x2] - 
    log[P2 + x1 + x2]), (-1/4*I)*(a0 - 2*nu)*(log[P2 - x1 - x2] + 
    log[P2 + x1 - x2] - log[P2 - x1 + x2] - log[P2 + x1 + x2]), 
  -2*(1 + 2*nu)*log[x1] - (1 + 2*nu)*log[x2] - 
   ((a0 - 2*nu)*(log[P1 - x1 - x2] + log[P1 + x1 - x2] + log[P1 - x1 + x2] + 
      log[P1 + x1 + x2]))/4 - 
   ((-1 + a0 - 4*nu)*(log[P2 - x1 - x2] + log[P2 + x1 - x2] + 
      log[P2 - x1 + x2] + log[P2 + x1 + x2]))/4, 0, 0, 0, 
  (I/4)*(-1 + a0 - 4*nu)*(log[P1 - x1 - x2] + log[P1 + x1 - x2] - 
    log[P1 - x1 + x2] - log[P1 + x1 + x2]), 
  (-log[P2 - x1 - x2] + log[P2 + x1 - x2] + log[P2 - x1 + x2] - 
    log[P2 + x1 + x2])/4, (I/4)*(log[P1 - x1 - x2] - log[P1 + x1 - x2] + 
     log[P1 - x1 + x2] - log[P1 + x1 + x2]) + 
   (I/4)*(log[P1 - x1 - x2] + log[P2 - x1 - x2] - log[P1 + x1 - x2] - 
     log[P2 + x1 - x2] + log[P1 - x1 + x2] + log[P2 - x1 + x2] - 
     log[P1 + x1 + x2] - log[P2 + x1 + x2]), 
  (-1/4*I)*(log[P2 - x1 - x2] - log[P2 + x1 - x2] + log[P2 - x1 + x2] - 
    log[P2 + x1 + x2]), (log[P1 - x1 - x2] - log[P1 + x1 - x2] - 
     log[P1 - x1 + x2] + log[P1 + x1 + x2])/4 + 
   (log[P1 - x1 - x2] - log[P2 - x1 - x2] + log[P1 + x1 - x2] - 
     log[P2 + x1 - x2] + log[P1 - x1 + x2] - log[P2 - x1 + x2] + 
     log[P1 + x1 + x2] - log[P2 + x1 + x2])/4}, 
 {((1 + a0)*(log[P1 - x1 - x2] - log[P1 + x1 - x2] - log[P1 - x1 + x2] + 
     log[P1 + x1 + x2]))/4, 0, 0, 0, (-1/4*I)*(a0 - 2*nu)*
   (log[P1 - x1 - x2] - log[P1 + x1 - x2] + log[P1 - x1 + x2] - 
    log[P1 + x1 + x2]), 0, 0, 0, (-1/4*I)*(a0 - 2*nu)*
   (log[P1 - x1 - x2] + log[P1 + x1 - x2] - log[P1 - x1 + x2] - 
    log[P1 + x1 + x2]), 0, 0, 0, -((1 + 2*nu)*log[x1]) - (1 + 2*nu)*log[x2] - 
   ((-1 + a0 - 4*nu)*(log[P1 - x1 - x2] + log[P1 + x1 - x2] + 
      log[P1 - x1 + x2] + log[P1 + x1 + x2]))/4 - 
   ((1 + a0)*(log[P2 - x1 - x2] + log[P2 + x1 - x2] + log[P2 - x1 + x2] + 
      log[P2 + x1 + x2]))/4, (I/4)*(a0 - 2*nu)*(log[P2 - x1 - x2] + 
    log[P2 + x1 - x2] - log[P2 - x1 + x2] - log[P2 + x1 + x2]), 
  (I/4)*(a0 - 2*nu)*(log[P2 - x1 - x2] - log[P2 + x1 - x2] + 
    log[P2 - x1 + x2] - log[P2 + x1 + x2]), 
  ((-1 + a0 - 4*nu)*(log[P2 - x1 - x2] - log[P2 + x1 - x2] - 
     log[P2 - x1 + x2] + log[P2 + x1 + x2]))/4, 
  (-1/4*I)*(log[P1 - x1 - x2] + log[P1 + x1 - x2] - log[P1 - x1 + x2] - 
     log[P1 + x1 + x2]) - (I/4)*(log[P1 - x1 - x2] - log[P1 + x1 - x2] + 
     log[P1 - x1 + x2] - log[P1 + x1 + x2]), 0, 
  (-log[P1 - x1 - x2] + log[P2 - x1 - x2] - log[P1 + x1 - x2] + 
    log[P2 + x1 - x2] - log[P1 - x1 + x2] + log[P2 - x1 + x2] - 
    log[P1 + x1 + x2] + log[P2 + x1 + x2])/2, 
  (-1/4*I)*(log[P2 - x1 - x2] + log[P2 + x1 - x2] - log[P2 - x1 + x2] - 
     log[P2 + x1 + x2]) - (I/4)*(log[P2 - x1 - x2] - log[P2 + x1 - x2] + 
     log[P2 - x1 + x2] - log[P2 + x1 + x2])}, 
 {0, ((1 + a0)*(log[P1 - x1 - x2] - log[P1 + x1 - x2] - log[P1 - x1 + x2] + 
     log[P1 + x1 + x2]))/4, 0, 0, 0, (-1/4*I)*(a0 - 2*nu)*
   (log[P1 - x1 - x2] - log[P1 + x1 - x2] + log[P1 - x1 + x2] - 
    log[P1 + x1 + x2]), 0, 0, 0, (-1/4*I)*(a0 - 2*nu)*
   (log[P1 - x1 - x2] + log[P1 + x1 - x2] - log[P1 - x1 + x2] - 
    log[P1 + x1 + x2]), 0, 0, (-1/4*I)*(1 + a0)*
   (log[P2 - x1 - x2] + log[P2 + x1 - x2] - log[P2 - x1 + x2] - 
    log[P2 + x1 + x2]), -((1 + 2*nu)*log[x1]) - 2*(1 + 2*nu)*log[x2] - 
   ((-1 + a0 - 4*nu)*(log[P1 - x1 - x2] + log[P1 + x1 - x2] + 
      log[P1 - x1 + x2] + log[P1 + x1 + x2]))/4 - 
   ((a0 - 2*nu)*(log[P2 - x1 - x2] + log[P2 + x1 - x2] + log[P2 - x1 + x2] + 
      log[P2 + x1 + x2]))/4, 
  -1/4*((a0 - 2*nu)*(log[P2 - x1 - x2] - log[P2 + x1 - x2] - 
     log[P2 - x1 + x2] + log[P2 + x1 + x2])), (I/4)*(-1 + a0 - 4*nu)*
   (log[P2 - x1 - x2] - log[P2 + x1 - x2] + log[P2 - x1 + x2] - 
    log[P2 + x1 + x2]), (-log[P1 - x1 - x2] + log[P1 + x1 - x2] + 
    log[P1 - x1 + x2] - log[P1 + x1 + x2])/4, 
  (-1/4*I)*(log[P1 - x1 - x2] + log[P1 + x1 - x2] - log[P1 - x1 + x2] - 
    log[P1 + x1 + x2]), (I/4)*(log[P2 - x1 - x2] + log[P2 + x1 - x2] - 
     log[P2 - x1 + x2] - log[P2 + x1 + x2]) + 
   (I/4)*(log[P1 - x1 - x2] + log[P2 - x1 - x2] + log[P1 + x1 - x2] + 
     log[P2 + x1 - x2] - log[P1 - x1 + x2] - log[P2 - x1 + x2] - 
     log[P1 + x1 + x2] - log[P2 + x1 + x2]), 
  (log[P2 - x1 - x2] - log[P2 + x1 - x2] - log[P2 - x1 + x2] + 
     log[P2 + x1 + x2])/4 + (-log[P1 - x1 - x2] + log[P2 - x1 - x2] - 
     log[P1 + x1 - x2] + log[P2 + x1 - x2] - log[P1 - x1 + x2] + 
     log[P2 - x1 + x2] - log[P1 + x1 + x2] + log[P2 + x1 + x2])/4}, 
 {0, 0, ((1 + a0)*(log[P1 - x1 - x2] - log[P1 + x1 - x2] - 
     log[P1 - x1 + x2] + log[P1 + x1 + x2]))/4, 0, 0, 0, 
  (-1/4*I)*(a0 - 2*nu)*(log[P1 - x1 - x2] - log[P1 + x1 - x2] + 
    log[P1 - x1 + x2] - log[P1 + x1 + x2]), 0, 0, 0, 
  (-1/4*I)*(a0 - 2*nu)*(log[P1 - x1 - x2] + log[P1 + x1 - x2] - 
    log[P1 - x1 + x2] - log[P1 + x1 + x2]), 0, 
  (-1/4*I)*(1 + a0)*(log[P2 - x1 - x2] - log[P2 + x1 - x2] + 
    log[P2 - x1 + x2] - log[P2 + x1 + x2]), 
  -1/4*((a0 - 2*nu)*(log[P2 - x1 - x2] - log[P2 + x1 - x2] - 
     log[P2 - x1 + x2] + log[P2 + x1 + x2])), -2*(1 + 2*nu)*log[x1] - 
   (1 + 2*nu)*log[x2] - ((-1 + a0 - 4*nu)*(log[P1 - x1 - x2] + 
      log[P1 + x1 - x2] + log[P1 - x1 + x2] + log[P1 + x1 + x2]))/4 - 
   ((a0 - 2*nu)*(log[P2 - x1 - x2] + log[P2 + x1 - x2] + log[P2 - x1 + x2] + 
      log[P2 + x1 + x2]))/4, (I/4)*(-1 + a0 - 4*nu)*
   (log[P2 - x1 - x2] + log[P2 + x1 - x2] - log[P2 - x1 + x2] - 
    log[P2 + x1 + x2]), (-log[P1 - x1 - x2] + log[P1 + x1 - x2] + 
    log[P1 - x1 + x2] - log[P1 + x1 + x2])/4, 
  (-1/4*I)*(log[P1 - x1 - x2] - log[P1 + x1 - x2] + log[P1 - x1 + x2] - 
    log[P1 + x1 + x2]), (I/4)*(log[P2 - x1 - x2] - log[P2 + x1 - x2] + 
     log[P2 - x1 + x2] - log[P2 + x1 + x2]) + 
   (I/4)*(log[P1 - x1 - x2] + log[P2 - x1 - x2] - log[P1 + x1 - x2] - 
     log[P2 + x1 - x2] + log[P1 - x1 + x2] + log[P2 - x1 + x2] - 
     log[P1 + x1 + x2] - log[P2 + x1 + x2]), 
  (log[P2 - x1 - x2] - log[P2 + x1 - x2] - log[P2 - x1 + x2] + 
     log[P2 + x1 + x2])/4 + (-log[P1 - x1 - x2] + log[P2 - x1 - x2] - 
     log[P1 + x1 - x2] + log[P2 + x1 - x2] - log[P1 - x1 + x2] + 
     log[P2 - x1 + x2] - log[P1 + x1 + x2] + log[P2 + x1 + x2])/4}, 
 {0, 0, 0, ((1 + a0)*(log[P1 - x1 - x2] - log[P1 + x1 - x2] - 
     log[P1 - x1 + x2] + log[P1 + x1 + x2]))/4, 0, 0, 0, 
  (-1/4*I)*(a0 - 2*nu)*(log[P1 - x1 - x2] - log[P1 + x1 - x2] + 
    log[P1 - x1 + x2] - log[P1 + x1 + x2]), 0, 0, 0, 
  (-1/4*I)*(a0 - 2*nu)*(log[P1 - x1 - x2] + log[P1 + x1 - x2] - 
    log[P1 - x1 + x2] - log[P1 + x1 + x2]), 
  ((1 + a0)*(log[P2 - x1 - x2] - log[P2 + x1 - x2] - log[P2 - x1 + x2] + 
     log[P2 + x1 + x2]))/4, (-1/4*I)*(a0 - 2*nu)*
   (log[P2 - x1 - x2] - log[P2 + x1 - x2] + log[P2 - x1 + x2] - 
    log[P2 + x1 + x2]), (-1/4*I)*(a0 - 2*nu)*(log[P2 - x1 - x2] + 
    log[P2 + x1 - x2] - log[P2 - x1 + x2] - log[P2 + x1 + x2]), 
  -2*(1 + 2*nu)*log[x1] - 2*(1 + 2*nu)*log[x2] - 
   ((-1 + a0 - 4*nu)*(log[P1 - x1 - x2] + log[P1 + x1 - x2] + 
      log[P1 - x1 + x2] + log[P1 + x1 + x2]))/4 - 
   ((-1 + a0 - 4*nu)*(log[P2 - x1 - x2] + log[P2 + x1 - x2] + 
      log[P2 - x1 + x2] + log[P2 + x1 + x2]))/4, 0, 
  (-log[P1 - x1 - x2] + log[P1 + x1 - x2] + log[P1 - x1 + x2] - 
    log[P1 + x1 + x2])/2, (-log[P2 - x1 - x2] + log[P2 + x1 - x2] + 
    log[P2 - x1 + x2] - log[P2 + x1 + x2])/2, 
  (I/4)*(log[P1 - x1 - x2] + log[P2 - x1 - x2] + log[P1 + x1 - x2] + 
     log[P2 + x1 - x2] - log[P1 - x1 + x2] - log[P2 - x1 + x2] - 
     log[P1 + x1 + x2] - log[P2 + x1 + x2]) + 
   (I/4)*(log[P1 - x1 - x2] + log[P2 - x1 - x2] - log[P1 + x1 - x2] - 
     log[P2 + x1 - x2] + log[P1 - x1 + x2] + log[P2 - x1 + x2] - 
     log[P1 + x1 + x2] - log[P2 + x1 + x2])}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
  0, 0, 0, 0, 0, 0, -1/2*((1 + a0)*(log[P1 - x1] + log[P1 + x1])) - 
   ((1 + a0)*(log[P2 - x1] + log[P2 + x1]))/2 - 
   ((1 + a0)*(log[P1 - x2] + log[P1 + x2]))/2 - 
   ((1 + a0)*(log[P2 - x2] + log[P2 + x2]))/2, 
  (I/2)*(a0 - 2*nu)*(log[P2 - x1] - log[P2 + x1]) + 
   (I/2)*(a0 - 2*nu)*(log[P2 - x2] - log[P2 + x2]), 
  (I/2)*(a0 - 2*nu)*(log[P1 - x1] - log[P1 + x1]) + 
   (I/2)*(a0 - 2*nu)*(log[P1 - x2] - log[P1 + x2]), 0}, 
 {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
  (-1/2*I)*(1 + a0)*(log[P2 - x1] - log[P2 + x1]) - 
   (I/2)*(1 + a0)*(log[P2 - x2] - log[P2 + x2]), 
  -((1 + 2*nu)*log[x1]) - ((1 + a0)*(log[P1 - x1] + log[P1 + x1]))/2 - 
   ((a0 - 2*nu)*(log[P2 - x1] + log[P2 + x1]))/2 - (1 + 2*nu)*log[x2] - 
   ((1 + a0)*(log[P1 - x2] + log[P1 + x2]))/2 - 
   ((a0 - 2*nu)*(log[P2 - x2] + log[P2 + x2]))/2, 0, 
  (I/2)*(a0 - 2*nu)*(log[P1 - x1] - log[P1 + x1]) + 
   (I/2)*(a0 - 2*nu)*(log[P1 - x2] - log[P1 + x2])}, 
 {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
  (-1/2*I)*(1 + a0)*(log[P1 - x1] - log[P1 + x1]) - 
   (I/2)*(1 + a0)*(log[P1 - x2] - log[P1 + x2]), 0, 
  -((1 + 2*nu)*log[x1]) - ((a0 - 2*nu)*(log[P1 - x1] + log[P1 + x1]))/2 - 
   ((1 + a0)*(log[P2 - x1] + log[P2 + x1]))/2 - (1 + 2*nu)*log[x2] - 
   ((a0 - 2*nu)*(log[P1 - x2] + log[P1 + x2]))/2 - 
   ((1 + a0)*(log[P2 - x2] + log[P2 + x2]))/2, 
  (I/2)*(a0 - 2*nu)*(log[P2 - x1] - log[P2 + x1]) + 
   (I/2)*(a0 - 2*nu)*(log[P2 - x2] - log[P2 + x2])}, 
 {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
  (-1/2*I)*(1 + a0)*(log[P1 - x1] - log[P1 + x1]) - 
   (I/2)*(1 + a0)*(log[P1 - x2] - log[P1 + x2]), 
  (-1/2*I)*(1 + a0)*(log[P2 - x1] - log[P2 + x1]) - 
   (I/2)*(1 + a0)*(log[P2 - x2] - log[P2 + x2]), 
  -2*(1 + 2*nu)*log[x1] - ((a0 - 2*nu)*(log[P1 - x1] + log[P1 + x1]))/2 - 
   ((a0 - 2*nu)*(log[P2 - x1] + log[P2 + x1]))/2 - 2*(1 + 2*nu)*log[x2] - 
   ((a0 - 2*nu)*(log[P1 - x2] + log[P1 + x2]))/2 - 
   ((a0 - 2*nu)*(log[P2 - x2] + log[P2 + x2]))/2}}
