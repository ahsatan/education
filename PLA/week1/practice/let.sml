(* Let *)

(* Local Expression
   - syntax: let b1 ... bn in exp end
   - type-checking: add bindings to static environment for the rest of the let, result type is type of exp
   - eval: eval bindings in order on top of dynamic environment for the rest of the let, result is result of exp
*)

fun countup_from1 (n : int) =
    let
        fun countup (from : int) =
            if from = n
            then [n]
            else from :: countup(from + 1)
    in
        countup(1)
    end;

fun max (lon : int list) =
    if null lon
    then 0
    else if null (tl lon)
    then hd lon
    else
        let
            val max_rest = max(tl lon)
        in
            if (hd lon) > max_rest
            then hd lon
            else max_rest
        end;

(* Options *)

(* Build Option
  - syntax: NONE or SOME exp
  - type-checking: NONE is 'a option, SOME exp is t option where t is the type of exp
*)

(* Access Option
  - syntax: isSome or valOf
  - type-checking:
    - isSome: 'a option -> bool
    - valOf: 'a option -> 'a
*)

(* int list -> int option *)
fun good_max (lon : int list) =
    if null lon
    then NONE
    else
        let
            val max_rest = good_max(tl lon)
        in
            if isSome max_rest andalso (valOf max_rest) > (hd lon)
            then max_rest
            else SOME (hd lon)
        end;

(* int list -> int option *)
fun best_max (lon : int list) =
    if null lon
    then NONE
    else
        let
            (* int list -> int *)
            fun max (lon : int list) =
                if null (tl lon)
                then hd lon
                else
                    let
                        val max_rest = max(tl lon)
                    in
                        if (hd lon) > max_rest
                        then hd lon
                        else max_rest
                    end
        in
            SOME (max lon)
        end;
