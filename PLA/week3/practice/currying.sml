fun sorted_tuple (x, y, z) = z >= y andalso y >= x

val a = sorted_tuple (7, 9, 11)

val sorted = fn x => fn y => fn z => z >= y andalso y >= x

(* ((e1 e2) e3) e4 is order expressions are processed if given e1 e2 e3 e4 *)
val b = sorted 7 9 11

(* fun f p1 p2 p3 = e is syntactic sugar for fun f p1 = fn p2 => fn p3 => e *)
fun sorted x y z = z >= y andalso y >= x

fun foldl f acc xs =
    case xs of
        [] => acc
      | x :: xs' => foldl f (f (acc, x)) xs'

fun sum xs = foldl (fn (x, y) => x + y) 0 xs

(* Partial application *)
val is_positive x = sorted 0 0

val sum = fold (op +) 0
(* BETTER form and does the SAME THING: fun sum xs = fold (op +) 0 xs *)

fun range i j = if i > j then [] else i :: range (i + 1) j

val countup = range 1

(* ormap equivalent *)
fun exists predicate xs =
    case xs of
        [] => false
      | x :: xs' => predicate x orelse exists predicate xs'

val no = exists (fn x => x = 7) [4, 11, 23]

val has_zero = exists (fn x => x = 0)

val increment_all = List.map (fn x => x + 1)

val remove_zeros = List.filter (fn x => x <> 0)

(* Convert tupled function calls to curried: *)
fun curry f x y = f (x, y)

fun range (i, j) = if i > j then [] else i :: range (i + 1, j)

val countup = curry range 1

(* Convert curried to tupled: *)
fun uncurry f (x, y) = f x y

(* Re-ordering params *)
fun reorder f x y = f y x
