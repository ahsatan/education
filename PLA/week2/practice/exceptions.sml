fun hd l =
    case l of
        [] => raise List.Empty
      | x::_ => x

exception MyUndesirableCondition

(* raise MyOtherException(3, 4) *)
exception MyOtherException of int * int

fun my_div (x, y) =
    if y = 0
    then raise MyOtherException(x, y)
    else x div y

val test = my_div(3, 0)
           handle MyOtherException(x, y) => 0
         | handle MyUndesirableCondition => 42

(* int list * exn -> int *)
fun max_list (l, ex) =
    case l of
        [] => raise ex
      | x :: [] => x
      | x :: tl => Int.max(x, max_list(tl, ex))

val a = max_list([3, 4, 5], MyUndesirableCondition)

val b = max_list([3, 4, 5], MyUndesirableCondition)
        handle MyUndesirableCondition => 42

(* syntax: exp1 handle exn => exp2 *)
val c = max_list([], MyUndesirableCondition)
        handle MyUndesirableCondition => 42
