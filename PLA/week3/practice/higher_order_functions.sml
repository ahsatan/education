(* Higher order functions *)

fun double_or_triple f =
    if f 7
    then fn x => 2 * x
    else fn x => 3 * x

datatype exp = Constant of int
              | Negate of exp
              | Add of exp * exp
              | Multiply of exp * exp

fun andmap_constant (f, exp) =
    case exp of
        Constant i => f i
      | Negate e => andmap_constant (f, e)
      | Add e1 e2 => andmap_constant (f, e1) andalso andmap_constant (f, e2)
      | Multiply e1 e2 => andmap_constant (f, e1) andalso andmap_constant (f, e2)

fun all_even e = and_map_constant(fn i => i mod 2 = 0, e)
