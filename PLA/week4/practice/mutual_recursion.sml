(* and keyword links functions: need to be adjacent
   - fun f1 p1 = e1
     and f2 p2 = e2
     ...
     and fn pn = en
*)
fun to_dtype n p =
    case (List.find (fn (cn, _, ct) => cn = n andalso (to_type p) = ct) cs) of
        SOME (_, dn, _) => dn
      | NONE => raise NoAnswer
and to_type p =
    case p of
        UnitP => UnitT
      | ConstP _ => IntT
      | TupleP ps => TupleT (map to_type ps)
      | ConstructorP (n, p) => Datatype (to_dtype n p)
      | _ => Anything


(* and keyword also links datatypes:
   - datatype t1 = ...
     and t2 = ...
     ...
     and tn = ...
*)

(* State machine: determines if a list alternates between 1 and 2 and NOT ending on a 1. *)
fun match xs =
    let
        fun need_one xs =
            case xs of
                [] => true
              | 1 :: xs' => need_two xs'
              | _ => false
        and need_two xs =
            case xs of
                [] => false
              | 2 :: xs' => need_one xs'
              | _ => false
    in
        need_one xs
    end

(* Datatype example: *)
datatype t1 = Foo of int
            | Bar of t2
     and t2 = Baz of string
            | Quux of t1

fun no_0_or_empty_t1 x =
    case x of
        Foo i => i <> 0
      | Bar y => no_0_or_empty_t2 y
and no_0_or_empty_t2 x =
    case x of
        Baz s => size s > 0
      | Quux y => no_0_or_empty_t1 y

(* Alternate version without keyword, slower and less efficient but can be separated further in code. *)
fun no_0_or_empty_t1 (f, x) =
    case x of
        Foo i => i <> 0
      | Bar y => f y

fun no_0_or_empty_t2 x =
    case x of
        Baz s => size s > 0
      | Quux y => no_0_or_empty_t1 (no_0_or_empty_t2, y)
