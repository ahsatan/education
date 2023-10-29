(* Create Record
   - syntax: {name1 = exp1, name2 = exp2, ..., namen = expn}
   - type checking: names are valid bindings and expressions are valid -> result type is automatically derived
     - {name1 : type1, name2 : type2, ..., namen : typen}
*)

(* Access Record
  - syntax: #name1 record_var
  - type checking: #name1 is a valid binding in the record
  - eval: exp1
*)

val x = {bar = (1 + 2, true andalso true), foo = 3 + 4, baz = (false, 9)}

val niece = {name = "Amelia", id = 41123 - 12}
(* #id niece => 41111 *)

val brain = {id = true, ego = false, superego = false}

(* Tuples are simply syntactic sugar for records!
   - automatically assigned names of numbers *)
