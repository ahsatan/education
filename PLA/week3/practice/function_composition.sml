(* ('b -> 'c) * ('a -> 'b) -> (a' -> 'c) *)
fun compose (f, g) = fn x => f (g x)

f o g (* means same as above *)

fun sqrt_of_abs x = (Math.sqrt o Real.fromInt o abs) x
val sqrt_of_abs = Math.sqrt o Real.fromInt o abs

(* Pipelines (function comp chains) in F# uses |> but emacs triggers so use !> here *)
infix !>
fun x !> f = f x

fun sqrt_of_abs x = x !> abs !> Real.fromInt !> Math.sqrt

fun backup (f, g) = fn x => case f x of
                                NONE => g x
                              | SOME y => y

fun backup (f, g) = fn x => f x handle _ => g x
