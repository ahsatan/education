(* Tuples *)

(* Build Tuple:
   - syntax: (exp1, ..., expn)
   - type-checking: type1 * ... * typen
   - eval: (v1, ..., vn) *)

(* Access Tuple:
   - syntax: #n expn
   - type-checking: typen
   - eval: lookup in environment
*)

(* int * bool -> bool * int *)
fun swap (pr : int * bool) =
    (#2 pr, #1 pr);

(* (int * int) * (int * int) -> int *)
fun sum_two_pairs (pr1 : int * int, pr2 : int * int) =
    (#1 pr1) + (#2 pr1) + (#1 pr2) + (#2 pr2);

(* int * int -> int * int *)
fun div_mod (x : int, y : int) =
    (x div y, x mod y);

(* int * int -> int * int *)
fun sort_pair (pr: int * int) =
    if (#1 pr) < (#2 pr)
    then pr
    else (#2 pr, #1 pr);

(* int * (bool * int) *)
val a = (7, (true, 9));

(* bool *)
val b = (#1 (#2 a));

(* bool * int *)
val c = (#2 a);

(* (int * int) * ((int * int) * (int * int)) *)
val d = ((3, 5), ((4, 8), (0, 0)));
