(* Polymorphic datatypes *)

datatype ('a, 'b) tree =
         Node of 'a * ('a, 'b) tree * ('a, 'b) tree
       | Leaf of 'b

(* Usage will infer a type if necessary *)
datatype 'a list =
         Empty
       | Cons of 'a * 'a list

(* 'a list -> int *)
fun count_list l =
    case l of
        Empty => 0
      | Cons (first, rest) => 1 + count_list(rest)

(* int list -> int *)
fun sum_list l =
    case l of
        Empty => 0
      | Cons (first, rest) => first + sum_list(rest)


(* Equality Types
   - like normal polymorphism EXCEPT must support = comparison
   - functions and reals do NOT *)
(* ''a list * ''a -> bool *)

fun same_thing (x, y) =
    if x = y then "yes" else "no"
