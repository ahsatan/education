(* Anonymous Functions
   - syntax: fn args => exp *)

fun n_times (f, n, x) =
    if n = 0
    then x
    else f(n_times(f, n - 1, x))

fun triple_n_times (n, x) = n_times(fn x => 3 * x, n, x)

(* DON'Ts *)
val rev xs = List.rev xs
(* DO *)
val rev = List.rev
