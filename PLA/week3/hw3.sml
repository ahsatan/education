exception NoAnswer

datatype pattern = Wildcard
		             | Variable of string
		             | UnitP
		             | ConstP of int
		             | TupleP of pattern list
		             | ConstructorP of string * pattern

datatype valu = Const of int
	            | Unit
	            | Tuple of valu list
	            | Constructor of string * valu

fun g f1 f2 p =
    let
	      val r = g f1 f2
    in
	      case p of
	          Wildcard          => f1 ()
	        | Variable x        => f2 x
	        | TupleP ps         => List.foldl (fn (p,i) => (r p) + i) 0 ps
	        | ConstructorP(_,p) => r p
	        | _                 => 0
    end

datatype typ = Anything
	           | UnitT
	           | IntT
	           | TupleT of typ list
	           | Datatype of string

(* 1: val only_capitals = fn : string list -> string list *)
val only_capitals = List.filter (fn s => Char.isUpper (String.sub (s, 0)))

(* 2: val longest_string1 = fn : string list -> string *)
val longest_string1 = foldl (fn (s, l) => if size s > size l then s else l) ""

(* 3: val longest_string2 = fn : string list -> string *)
val longest_string2 = foldl (fn (s, l) => if size s >= size l then s else l) ""

(* 4: val longest_string_helper = fn : (int * int -> bool) -> string list -> string
      val longest_string3 = fn : string list -> string
      val longest_string4 = fn : string list -> string *)
fun longest_string_helper f = foldl (fn (s, l) => if f (size s, size l) then s else l) ""

val longest_string3 = longest_string_helper op>

val longest_string4 = longest_string_helper op>=

(* 5: val longest_capitalized = fn : string list -> string *)
val longest_capitalized = longest_string1 o only_capitals

(* 6: val rev_string = fn : string -> string *)
val rev_string = implode o rev o explode

(* 7: val first_answer = fn : (’a -> ’b option) -> ’a list -> ’b *)
fun first_answer f xs =
    case xs of
        [] => raise NoAnswer
      | x :: xs' => case f x of
                        SOME v => v
                      | NONE => first_answer f xs'

(* 8: val all_answers = fn : (’a -> ’b list option) -> ’a list -> ’b list option *)
fun all_answers f xs =
    let
        fun all_answers_tail xs acc =
            case xs of
                [] => SOME acc
              | x :: xs' => case f x of
                                NONE => NONE
                              | SOME v => all_answers_tail xs' (v @ acc)
    in
        all_answers_tail xs []
    end

(* 9: val count_wildcards = fn : pattern -> int
      val count_wild_and_variable_lengths = fn : pattern -> int
      val count_some_var = fn : string * pattern -> int *)
val count_wildcards = g (fn _ => 1) (fn _ => 0)

val count_wild_and_variable_lengths = g (fn _ => 1) size

fun count_some_var (s, p) = g (fn _ => 0) (fn v => if v = s then 1 else 0) p

(* 10: val check_pat = fn : pattern -> bool *)
val check_pat =
    let
        fun var_names p =
            case p of
                Variable s => [s]
              | TupleP ps => foldl (fn (p, acc) => var_names p @ acc) [] ps
              | ConstructorP (_, p) => var_names p
              | _ => []

        fun has_dupes xs =
            case xs of
                [] => false
              | x :: xs' => List.exists (fn y => y = x) xs' orelse has_dupes xs'
    in
        not o has_dupes o var_names
    end

(* 11: val match = fn : valu * pattern -> (string * valu) list option *)
fun match (v, p) =
    case (v, p) of
        (_, Wildcard) => SOME []
      | (_, Variable s) => SOME [(s, v)]
      | (Unit, UnitP) => SOME []
      | (Const x, ConstP y) => if x = y then SOME [] else NONE
      | (Tuple vs, TupleP ps) => if length vs = length ps
                                 then all_answers match (ListPair.zip (vs, ps))
                                 else NONE
      | (Constructor (s1, v), ConstructorP (s2, p)) => if s1 = s2 then match (v, p) else NONE
      | _ => NONE

(* 12: val first_match = fn : valu -> pattern list -> (string * valu) list option *)
fun first_match v ps = SOME (first_answer (fn p => match (v, p)) ps) handle NoAnswer => NONE

(* Challenge: val typecheck_patterns = fn : (string * string * typ) list * pattern list -> typ option
   - Confusingly worded but the first parameter is ONLY needed for type-checking ConstructorP. *)
fun typecheck_patterns (cs, ps) =
    let
        fun to_dtype n t =
            case (List.find (fn (cn, _, ct) => cn = n andalso t = ct) cs) of
                SOME (_, dn, _) => dn
              | NONE => raise NoAnswer

        fun to_type p =
            case p of
                UnitP => UnitT
              | ConstP _ => IntT
              | TupleP ps => TupleT (map to_type ps)
              | ConstructorP (n, p) => Datatype (to_dtype n (to_type p))
              | _ => Anything

        fun mlt (t1, t2) =
            case (t1, t2) of
                (TupleT ts1, TupleT ts2) => TupleT (map mlt (ListPair.zipEq (ts1, ts2)))
              | (Anything, t) => t
              | (t, Anything) => t
              | (t1, t2) => if t1 = t2 then t1 else raise NoAnswer
    in
        SOME (foldl mlt Anything (map to_type ps)) handle _ => NONE
    end

(* typecheck_patterns: Your function fails when there is no typ that all the patterns in the list can have. *)
