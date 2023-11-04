(* Foldr (right -> left, harder tail recursion) & Foldl (left -> right, easy tail recursion) *)

fun foldl (f, acc, xs) =
    case xs of
        [] => acc
      | x :: xs' => fold (f, f (acc, x), xs')

fun f1 xs = fold (fn (x, y) => x + y, 0. xs)

fun f2 xs = fold (fn (x, y) => x andalso y > 0, true, xs)

fun f3 (xs, lo, hi) =
    fold (fn (x, y) => x + (if y >= lo andalso y <= hi then 1 else 0), 0, xs)

fun f4 (xs, s) =
    let
        val len = String.size s
    in
        fold (fn (x, y) => x andalso String.size y < len, true, xs)
    end

(* andmap like *)
fun f5 (f, xs) = fold (fn (x, y) => x andalso f y, true, xs)

fun f4_2 (xs, s) =
    let
        val len = String.size s
    in
        f5 (fn x => String.size x < len, xs)
    end
