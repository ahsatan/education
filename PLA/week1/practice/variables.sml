(* Variable Bindings *)

(* Syntax: how you write code
   Semantics: what code means
   - static environment: type-checking
   - dynamic environment: evaluation *)

val x = 34;
(* x : int *)
(* x -> 34 *)

val y = 17;
(* x : int, y : int *)
(* x -> 34, y -> 17 *)

val z = (x + y) + (y + 2);
(* x : int, y : int, z : int *)
(* x -> 34, y -> 17, z -> 70 *)

val q = z + 1;
(* x : int, y : int, z : int, q : int *)
(* x -> 34, y -> 17, z -> 70, q -> 71 *)

val abs_z = if z < 0 then 0 - z else z;
(* x : int, y : int, z : int, q : int, abs_z : int *)
(* x -> 34, y -> 17, z -> 70, q -> 71, abs_z -> 71 *)

val abs_z_simple = abs z;
