(* signatures define structure types
   - define: signature NAME = sig binding types end
     - all binding types MUST be defined as bindings in the structure
   - use: structure MyModule :> NAME = struct bindings end
   - convention is for signature names to be all caps
*)

signature MATHLIB = sig
    val fact : int -> int
    val half_pi : real
end

structure MyMath :> MATHLIB = struct
fun fact x = if x = 0 then 1 else x * fact (x - 1)
val half_pi = Math.pi / 2.0
fun doubler y = y + y (* private - can be used in module but not outside *)
end


(* Properties (public): denom <> 0, all strings are in reduced format, no infinite loops or unexpected exceptions *)
signature RATIONAL_A = sig
    datatype rational = Whole of int | Frac of int * int (* allows users to create non-invariant safe data *)
    exception BadFrac

    val make_frac : int * int -> rational
    val add : rational * rational -> rational
    val to_string : rational -> string
end

signature RATIONAL_B = sig
    type rational (* type exists but does not provide a definition *)
    exception BadFrac

(*  val Whole : int -> rational *) (* Could reveal safe parts of datatype but not usually too useful. *)
    val make_frac : int * int -> rational
    val add : rational * rational -> rational
    val to_string : rational -> string
end

(* INVARIANTS (private implementation details, only relevant inside module): all denoms > 0, rationals are always reduced if possible *)
structure Rational1 :> RATIONAL_B = struct
datatype rational =
         Whole of int | Frac of int * int
exception BadFrac

fun gcd (x, y) = if x = y then x else if x < y then gcd (x, y - x) else gcd (y, x)

fun reduce r =
    case r of
        Whole _ => r
      | Frac (x, y) => if x = 0
                       then Whole 0
                       else let val d = gcd (abs x, y) in
                                if d = y
                                then Whole (x div y)
                                else Frac (x div d, y div d)
                            end

fun make_frac (x, y) = if y = 0
                       then raise BadFrac
                       else if y < 0
                       then reduce (Frac (~x, ~y))
                       else reduce (Frac (x, y))

fun add (r1, r2) =
    case (r1, r2) of
        (Whole i, Whole j) => Whole (i + j)
      | (Whole i, Frac (j, k)) => Frac (j + k * i, k)
      | (Frac (j, k), Whole i) => Frac (j + k * i, k)
      | (Frac (a, b), Frac (c, d)) => reduce (Frac (a * d + b * c, b * d))

fun to_string r =
    case r of
        Whole i => Int.toString i
      | Frac (a, b) => (Int.toString a) ^ " / " ^ (Int.toString b)
end

(* INVARIANT: all denoms > 0 *)
structure Rational2 :> RATIONAL_B = struct
datatype rational =
         Whole of int | Frac of int * int
exception BadFrac

fun gcd (x, y) = if x = y then x else if x < y then gcd (x, y - x) else gcd (y, x)

fun reduce r =
    case r of
        Whole _ => r
      | Frac (x, y) => if x = 0
                       then Whole 0
                       else let val d = gcd (abs x, y) in
                                if d = y
                                then Whole (x div y)
                                else Frac (x div d, y div d)
                            end

fun make_frac (x, y) = if y = 0
                       then raise BadFrac
                       else if y < 0
                       then Frac (~x, ~y)
                       else Frac (x, y)

fun add (r1, r2) =
    case (r1, r2) of
        (Whole i, Whole j) => Whole (i + j)
      | (Whole i, Frac (j, k)) => Frac (j + k * i, k)
      | (Frac (j, k), Whole i) => Frac (j + k * i, k)
      | (Frac (a, b), Frac (c, d)) => Frac (a * d + b * c, b * d)

fun to_string r =
    case reduce r of
        Whole i => Int.toString i
      | Frac (a, b) => (Int.toString a) ^ " / " ^ (Int.toString b)
end

structure Rational3 :> RATIONAL_B = struct
type rational = int * int (* Whole is equivalent to a denom of 1 *)
exception BadFrac

(* fun Whole n = (n, 1) *) (* if wanted to include the val Whole line in signature *)

fun gcd (x, y) = if x = y
                 then x
                 else if x < y
                 then gcd (x, y - x)
                 else gcd (y, x)

fun reduce r = let d = gcd (abs x, y) in ((x div d), (y div d))

fun make_frac (x, y) = if y = 0
                       then raise BadFrac
                       else if y < 0
                       then (~x, ~y)
                       else (x, y)

fun add ((a, b), (c, d)) = (a * d + b * c, b * d)

fun to_string (x, y) =
    case reduce (x, y) of
        (0, _) => "0"
      | (_, 1) =>  Int.toString x
      | _ => (Int.toString x) ^ " / " ^ (Int.toString y)
end
