(*
   - syntax: fun fname vname =
                 case vname of
                      p1 => exp1
                      ...
                      pn => expn

   - new syntax: fun fname p1 = exp1
                     | ...
                     | fname pn = expn)
*)

datatype exp = Constant of int
             | Negate of exp
             | Add of exp * exp
             | Multiply of exp * exp

fun eval (Constant i) = i
  | eval (Negate e) = ~ (eval e)
  | eval (Add(e1, e2)) = (eval e1) + (eval e2)
  | eval (Multiply(e1, e2)) = (eval e1) * (eval e2)

fun append ([], l2) = ln
  | append (hd :: tl, l2) = hd :: append(tl, l2)
