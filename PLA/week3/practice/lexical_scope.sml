(* Lexical Scope: scope surrounding the function DECLARATION, not function call. *)

val x = 1

fun f y = x + y

val x = 2

val y = 3

val z = f (x + y)
(* -> 6 NOT 5, x and y in the args are handled in calling scope but then body of f has lexical scope of declaration. *)
(* Function declarations have closures associated which contain scope info. *)
