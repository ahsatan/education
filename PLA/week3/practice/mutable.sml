(* Reference:
   - type: t ref
   - syntax: ref exp to create reference
   - exp1 := exp2 to update contents
     - exp1 has to be type t ref and exp2 has to be type t
   - !e to retrieve contents *)

(* References like x y and z do NOT change but the contents at the reference locations DO change *)

val x = ref 42
val y = ref 42
val z = x
val _ = x := 43 (* val _ means we don't care to name the result *)
val w = !y + !z (* 85 *)
