(* Nested Pattern Matching *)

exception ListLengthMismatch

fun zip list_triple =
    case list_triple of
        ([], [], []) => []
      | (hd1 :: tl1, hd2 :: tl2, hd3 :: tl3) => (hd1, hd2, hd3) :: zip(tl1, tl2, tl3)
      | _ => raise ListLengthMismatch

fun unzip triple_list =
    case triple_list of
        [] => ([], [], [])
      | (a, b, c) :: tl => let val (l1, l2, l3) = unzip tl
                           in
                               (a :: l1, b :: l2, c :: l3)
                           end

fun nondecreasing loi =
    case loi of
        [] => true
      | _ :: [] => true
      | i1 :: i2 :: tl => i1 <= i2 andalso nondecreasing(i2 :: tl)

datatype sign =
         P
       | N
       | Z

fun mult_sign (i1, i2) =
    let
        fun to_sign i =
            if i = 0 then Z else if i > 0 then P else N
    in
        case (to_sign i1, to_sign i2) of
            (Z, _) => Z
          | (_, Z) => Z
          | (P, P) => P
          | (N, N) => P
          | _ => N (* doing it this way instead of listing all cases loses exhaustive type checking *)
    end

fun len l =
    case l of
        [] => 0
      | _ :: tl => 1 + len tl
