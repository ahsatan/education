(* Create Datatype
   - syntax: datatype name = Constructor1 [of type1]
                           | Constructor2 [of type2]
                           | ...
                           | Constructorn
   - think of constructors like tags
   - type: Constructor1 has (type1 -> type of name) or simply "type of name"
 *)

(* Access Datatype
   - case varname of
        Pattern1 => exp1
      | Pattern2 => exp2
      | ...
      | Patternn => expn
   - pattern: ConstructorName (var1, ..., varn) or just ConstructorName if no additional type
*)

datatype mytype = TwoInts of int * int
                | Str of string
                | Pizza

val a = Str("hi")
val b = Str
val c = Pizza
val d = TwoInts(1 + 2, 3 + 4)
val e = a

(* Pattern Matching: built from the same constructor
   - must include all cases *)

(* mt does not need type declaration *)
fun ex (mt : mytype) =
    case mt of
        Pizza => 3
      | Str s => String.size s
      | TwoInts (a, b) => a + b

datatype suit = Heart
              | Spade
              | Diamond
              | Club

datatype rank = Jack
              | Queen
              | King
              | Ace
              | Num of int

(* Student identification where you only want EITHER name or an id number. *)
datatype id = StudentNum of int
            | Name of string * (string option) * string

(* Expression Tree *)
datatype exp = Constant of int
             | Negate of exp
             | Add of exp * exp
             | Multiply of exp * exp

fun eval e =
    case e of
        Constant i => i
      | Negate x => ~ (eval x)
      | Add (x, y) => (eval x) + (eval y)
      | Multiply (x, y) => (eval x) * (eval y)

fun num_adds e =
    case e of
        Constant i => 0
      | Negate x => num_adds x
      | Add (x, y) => 1 + num_adds(x) + num_adds(y)
      | Multiply (x, y) => num_adds(x) + num_adds(y)

fun max_constant e =
    case e of
        Constant i => i
      | Negate x => max_constant(x)
      | Add (x, y) => Int.max(max_constant(x), max_constant(y))
      | Multiply (x, y) => Int.max(max_constant(x), max_constant(y))

fun all_constants e =
    case e of
        Constant i => [i]
      | Negate x => all_constants(x)
      | Add (x, y) => all_constants(x) @ all_constants(y)
      | Multiply (x, y) => all_constants(x) @ all_constants(y)

fun any_multiply e =
    case e of
        Constant i => false
      | Negate x => any_multiply(x)
      | Add (x, y) => any_multiply(x) orelse any_multiply(y)
      | Multiply (x, y) => true

(* Types: synonyms for any other type *)
type card = suit * rank


type student = { id : int option,
                 first_name : string,
                 middle_name : string option,
                 last_name : string }

fun is_queen_of_spades (c : card) =
    #1 c = Spade andalso #2 c = Queen

fun is_q_of_s c =
    case c of
        (Spade, Queen) => true
      | _ => false

(* Base example, see below for BEST VERSION. *)
fun sum_triple triple =
    case triple of
        (x, y, z) => x + y + z

fun sum_triple (x, y, z) =
    x + y + z

(* Base example, see below for BEST VERSION. *)
fun to_name student =
    case student of
        { id = i, first_name = f, middle_name = m, last_name = l } => f ^ " " ^ m ^ " " ^ l

fun to_name { id = i, first_name = f, middle_name = m, last_name = l } =
    f ^ " " ^ m ^ " " ^ l

fun rotate_left (x, y, z) = (y, z, x)
fun rotate_right c = rotate_left(rotate_left t)
