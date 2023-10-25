(* Function Bindings *)

(* Function Definition:
     syntax: fun name (arg1 : type1, ..., argn : typen) = exp
     type-check: fn : type1 * ... * typen -> typeres
     - access to existing static env, arguments, and fn ref itself
     eval: functions ARE values *)

(* Function Call:
     syntax: name (arg1, ..., argn)
     type-check:
     - name must be: type1 * ... * typen -> typeres
     - args: number and types must match
     eval:
     - name becomes a function value
     - eval args
     - eval function body with extended environment (current at time of Definition + args)
*)

(* ASSUME: y >= 0 *)
fun pow (x : int, y : int) =
    if y = 0
    then 1
    else x * pow (x, (y - 1));

fun cube (x : int) =
    pow (x, 3);

val sixtyfour = cube (4);

val fortytwo = pow (2, pow (2, 2)) + pow (4, 2) + cube (2) + 2;
