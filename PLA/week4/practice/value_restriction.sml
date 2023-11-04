(* Val bindings can only be POLYMORPHIC if set to a variable or value!
   - a function will NOT type check because of potential for bad type checking if a reference is used. *)

val r = ref NONE (* Not a variable or value *)
val _ = r := SOME "hi"
val i = 1 + valOf (!r) (* Type checker would allow this if rule above did not exist. *)

type 'a foo = 'a ref
val f : 'a -> 'a foo = ref
val r2 = f NONE (* Masks the ref, demonstrates why we need the rule above. *)

(* Ends up affecting functions that would be safe. *)
val pair_with_one = List.map (fn x => (x, 1))

(* Wrap in function binding to resolve: *)
fun pair_with_one xs = List.map (fn x => (x, 1)) xs
