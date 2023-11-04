(* Problem 1 a: *)
fun all_except_option (s, xs) =
    case xs of
        [] => NONE
      | x :: xs' => if s = x
                    then SOME xs'
                    else case all_except_option (s, xs') of
                             NONE => NONE
                           | SOME v => SOME(x :: v)

(* Problem 1 b: *)
fun get_substitutions1 (xss, s) =
    case xss of
        [] => []
      | xs :: xss' => case all_except_option (s, xs) of
                          NONE => get_substitutions1 (xss', s)
                        | SOME v => v @ get_substitutions1 (xss', s)

(* Problem 1 c: *)
fun get_substitutions2 (xss, s) = foldl (fn (xs, acc) => case all_except_option (s, xs) of
                                                             NONE => acc
                                                           | SOME v => acc @ v)
                                        []
                                        xss

(* Problem 1 d: *)
fun similar_names (xss, {first = f, middle = m, last = l}) =
    map (fn f' => {first = f', middle = m, last = l}) (f :: (get_substitutions2 (xss, f)))

(* Provided (data)types. *)
datatype suit = Clubs | Diamonds | Hearts | Spades
datatype rank = Jack | Queen | King | Ace | Num of int
type card = suit * rank

datatype color = Red | Black
datatype move = Discard of card | Draw

exception IllegalMove

(* Problem 2 a: *)
fun card_color (s, _) =
    case s of
        Hearts => Red
      | Diamonds => Red
      | _ => Black

(* Problem 2 b: *)
fun card_value (_, r) =
    case r of
        Num i => i
      | Ace => 11
      | _ => 10

(* Problem 2 c: *)
fun remove_card (cs, c, e) =
    case cs of
        [] => raise e
      | x :: cs' => if x = c
                    then cs'
                    else x :: remove_card (cs', c, e)

(* Problem 2 d: *)
fun all_same_color cs =
    case cs of
        c1 :: c2 :: cs' => card_color c1 = card_color c2 andalso all_same_color (c2 :: cs')
      | _ => true

(* Problem 2 e: *)
fun sum_cards cs = foldl (fn (c, acc) => card_value c + acc) 0 cs

(* Problem 2 f: *)
fun score (held, goal) =
    let
        val sum = sum_cards held
        val prelim = if sum > goal
                     then 3 * (sum - goal)
                     else goal - sum
    in
        if all_same_color held
        then prelim div 2
        else prelim
    end

(* Problem 2 g: *)
fun officiate (cs, ms, goal) =
    let
        fun play (cs, ms, held) =
            case ms of
                [] => held
              | Discard d :: ms' => play (cs, ms', remove_card (held, d, IllegalMove))
              | Draw :: ms' => case cs of
                                   [] => held
                                 | c :: cs' => if sum_cards (c :: held) > goal
                                                 then c :: held
                                                 else play (cs', ms', c :: held)
    in
        score (play (cs, ms, []), goal)
    end

(* Problem 3 a: *)
fun convert_ace cs =
    case cs of
        [] => []
      | (s, Ace) :: cs' => (s, Num 1) :: cs'
      | c :: cs' => c :: convert_ace cs'

fun score_challenge (held, goal) =
    let
        fun best_score (held, old_score) =
            let
                val new_held = convert_ace held
                val new_score = score (new_held, goal)
            in
                if new_score < old_score
                then best_score (new_held, new_score)
                else old_score
            end
    in
        best_score (held, score (held, goal))
    end

fun officiate_challenge (cs, ms, goal) =
    let
        fun lowest_sum (cs, old_sum) =
            let
                val new_cs = convert_ace cs
                val new_sum = sum_cards new_cs
            in
                if new_sum < old_sum
                then lowest_sum (new_cs, new_sum)
                else old_sum
            end
        fun play (cs, ms, held) =
            case ms of
                [] => held
              | Discard d :: ms' => play (cs, ms', remove_card (held, d, IllegalMove))
              | Draw :: ms' => case cs of
                                   [] => held
                                 | c :: cs' => if lowest_sum (c :: held, sum_cards (c :: held)) > goal
                                                 then c :: held
                                                 else play (cs', ms', c :: held)
    in
        score_challenge (play (cs, ms, []), goal)
    end

(* Problem 3 b: *)
fun careful_player (cs, goal) =
    let
        fun discard_to_0 (held, checked) =
            case held of
                [] => NONE
              | c :: held' => case score (held' @ checked, goal) of
                                  0 => SOME c
                                | _ => discard_to_0 (held', c :: checked)
        fun play (cs, ms, held) =
            case score (held, goal) of
                0 => ms
              | _ => case cs of
                         [] => if sum_cards held < goal - 10
                               then ms @ [Draw]
                               else ms
                       | c :: cs' => if sum_cards held < goal - 10
                                     then play (cs', ms @ [Draw], c :: held)
                                     else case discard_to_0 (held, [c]) of
                                              SOME d => ms @ [Discard d, Draw]
                                            | NONE => ms
    in
        play (cs, [], [])
    end
