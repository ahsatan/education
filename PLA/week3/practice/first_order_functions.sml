(* First order functions: functions as arguments *)
(* Higher order functions: functions that take functions as arguments *)

fun bad_increment_n_times (n, x) =
    if n = 0
    then x
    else 1 + bad_increment_n_times(n - 1, x)

fun bad_double_n_times (n, x) =
    if n = 0
    then x
    else 2 * bad_double_n_times(n - 1, x)

fun bad_nth_tail (n, xs) =
    if n = 0
    then xs
    else tl (bad_nth_tail(n - 1, xs))

fun n_times (f, n, x) =
    if n = 0
    then x
    else f(n_times(f, n - 1, x))

fun increment x = x + 1
fun double x = x * 2

val a = n_times(increment, 5, 3)
val b = n_times(double, 3, 1)
val c = n_times(tl, 2, [4, 5, 6])

fun increment_n_times (n, x) = n_times(increment, n, x)
fun double_n_times (n, x) = n_times(double, n, x)
fun nth_tail (n, xs) = n_times(tl, n, xs)

(* Higher order but NOT polymorphic *)
(* fn : (int -> int) * int -> int *)
fun times_to_zero (f, x) =
    if x = 0
    then 0
    else 1 + times_to_zero(f, f x)
