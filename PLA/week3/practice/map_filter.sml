(* Higher order functions: Map & Filter *)

fun map (f, xs) =
    case xs of
        [] => []
      | x :: xs' => f x :: map(f, xs')

val a = map (fn x => x + 1, [3, 14, 5, 8])
val b = map (hd, [[1, 2], [3, 4], [5, 6]])

fun filter (f, xs) =
    case xs of
        [] => []
      | x :: xs' => if f x
                    then x :: filter(f, xs')
                    else filter(f, xs')

val c = filter(fn x => x mod 2 = 0, [3, 4, 8, 2, 1])
val d = filter(fn (_, x) => x mod 2 = 0, [(3, 4), (4, 2), (6, 5)])
