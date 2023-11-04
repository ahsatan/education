(* Save unnecessary recomputations *)

(* Bad: computes String.size s every filter loop *)
fun all_shorter_than1 (xs, s) = List.filter(fn x => String.size x < String.size s, xs)

(* Good: only compute once, save in let *)
fun all_shorter_than2 (xs, s) =
    let
        val sz = String.size s
    in
        List.filter(fn x => String.size x < sz, xs)
    end
