(* Simple example callback *)

(* fn onKeyEvent : (int -> unit) -> unit *)

(* cbs is REFERENCE to list of all callbacks, init empty *)
val cbs : (int -> unit) list ref = ref [] (* unit means no useful result, we only care about side effect! *)

(* Update cbs reference to be the new callback f consed on to the contents of previous cbs *)
fun onKeyEvent f = cbs := f :: (!cbs)

(* takes an int (pretend key event) and then processes all callbacks *)
fun onEvent i =
    let
        fun play fs =
            case fs of
                [] => ()
              | f :: fs' => (f i ; loop fs') (* ; means do first part, throw away result, then do second and return result of that *)
    in
        loop (!cbs)
    end

val times_pressed = ref 0
val _ = onKeyEvent (fn _ => times_pressed := (!times_pressed) + 1)

fun print_if_pressed i =
    onKeyEvent (fn j => if i = j then print "you pressed " ^ Int.toString i else ())

val _ = print_if_pressed 4
val _ = onEvent 11
val _ = onEvent 79
val _ = onEvent 4
val _ = onEvent 23
(* !times_pressed should be 4 *)
