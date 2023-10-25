(* Lists *)

(* Build List
  - syntax: [] or exp1 :: exp2
  - type-checking:
    - [] is 'a list ("alpha" list) is any type
    - [type] list, e.g. (int list * int) list: all exp must have same type
  - eval: exp1 :: exp2 (exp1 "cons" exp2): exp1 is like first and exp2 is like rest
*)

(* Access List
  - eval:
    - null exp: is true if []
    - hd exp: is first element
    - tl exp: is rest of list
*)

fun sum_list (loi : int list) =
    if null loi
    then 0
    else (hd loi) + sum_list(tl loi);

fun countdown (n : int) =
    if n = 0
    then []
    else n :: countdown(n - 1);

(* int list * int list -> int list *)
fun append (loi1 : int list, loi2 : int list) =
    if null loi1
    then loi2
    else (hd loi1) :: append(tl loi1, loi2);

(* (int * int) list -> int *)
fun sum_pair_list (lop : (int * int) list) =
    if null lop
    then 0
    else (#1 (hd lop)) + (#2 (hd lop)) + sum_pair_list(tl lop);

(* (int * int) list -> int list *)
fun firsts (lop : (int * int) list) =
    if null lop
    then []
    else (#1 (hd lop)) :: firsts(tl lop);

(* (int * int) list -> int list *)
fun seconds (lop : (int * int) list) =
    if null lop
    then []
    else (#2 (hd lop)) :: seconds(tl lop);

fun sum_pair_list2 (lop : (int * int) list) =
    sum_list(firsts lop) + sum_list(seconds lop);
