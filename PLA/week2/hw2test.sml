use "hw2.sml";

(* All the tests should evaluate to true. For example, the REPL should say: val test1_0 = true : bool *)

val test1_0 = all_except_option ("string", ["string"]) = SOME []
val test1_a = all_except_option ("s", []) = NONE
val test1_b = all_except_option ("s", ["a", "s", "b"]) = SOME ["a", "b"]
val test1_c = all_except_option ("s", ["a", "b", "s"]) = SOME ["a", "b"]
val test1_d = all_except_option ("s", ["s", "a", "b"]) = SOME ["a", "b"]
val test1_e = all_except_option ("s", ["a", "b", "c"]) = NONE

val test2_0 = get_substitutions1 ([["foo"],["there"]], "foo") = []
val test2_a = get_substitutions1([["Fred","Fredrick"],["Elizabeth","Betty"],["Freddie","Fred","F"]], "Fred") =
              ["Fredrick", "Freddie", "F"]
val test2_b = get_substitutions1([["Fred","Fredrick"],["Jeff","Jeffrey"],["Geoff","Jeff","Jeffrey"]], "Jeff") =
              ["Jeffrey", "Geoff", "Jeffrey"]
val test2_c = get_substitutions1([], "Alice") = []
val test2_d = get_substitutions1([["Fred","Fredrick"],["Jeff","Jeffrey"],["Geoff","Jeff","Jeffrey"]], "Alice") = []

val test3_0 = get_substitutions2 ([["foo"],["there"]], "foo") = []
val test3_a = get_substitutions2([["Fred","Fredrick"],["Elizabeth","Betty"],["Freddie","Fred","F"]], "Fred") =
              ["Fredrick", "Freddie", "F"]
val test3_b = get_substitutions2([["Fred","Fredrick"],["Jeff","Jeffrey"],["Geoff","Jeff","Jeffrey"]], "Jeff") =
              ["Jeffrey", "Geoff", "Jeffrey"]
val test3_c = get_substitutions2([], "Alice") = []
val test3_d = get_substitutions2([["Fred","Fredrick"],["Jeff","Jeffrey"],["Geoff","Jeff","Jeffrey"]], "Alice") = []

val test4_0 = similar_names ([["Fred","Fredrick"],["Elizabeth","Betty"],["Freddie","Fred","F"]],
                           {first="Fred", middle="W", last="Smith"}) =
	          [{first="Fred", last="Smith", middle="W"}, {first="Fredrick", last="Smith", middle="W"},
	           {first="Freddie", last="Smith", middle="W"}, {first="F", last="Smith", middle="W"}]
val test4_a = similar_names ([["Fred","Fredrick"],["Elizabeth","Betty"],["Freddie","Fred","F"]],
                             {first="Alice", middle="W", last="Smith"}) =
	            [{first="Alice", last="Smith", middle="W"}]
val test4_b = similar_names ([], {first="Fred", middle="W", last="Smith"}) =
	            [{first="Fred", last="Smith", middle="W"}]

val test5_0 = card_color (Clubs, Num 2) = Black
val test5_a = card_color (Spades, Num 2) = Black
val test5_b = card_color (Hearts, Num 2) = Red
val test5_c = card_color (Diamonds, Num 2) = Red

val test6_0 = card_value (Clubs, Num 2) = 2
val test6_a = card_value (Clubs, Num 8) = 8
val test6_b = card_value (Clubs, Ace) = 11
val test6_c = card_value (Clubs, Jack) = 10
val test6_d = card_value (Clubs, Queen) = 10
val test6_e = card_value (Clubs, King) = 10

val test7_0 = remove_card ([(Hearts, Ace)], (Hearts, Ace), IllegalMove) = []
val test7_a = ((remove_card ([], (Hearts, Ace), IllegalMove);
                false)
               handle IllegalMove => true)
val test7_b = ((remove_card ([(Hearts, Ace)], (Spades, Ace), IllegalMove);
                false)
               handle IllegalMove => true)
val test7_c = remove_card ([(Hearts, Ace), (Hearts, Num 3), (Diamonds, Jack)], (Hearts, Ace), IllegalMove) = [(Hearts, Num 3), (Diamonds, Jack)]
val test7_d = remove_card ([(Hearts, Num 3), (Hearts, Ace), (Diamonds, Jack)], (Hearts, Ace), IllegalMove) = [(Hearts, Num 3), (Diamonds, Jack)]
val test7_e = remove_card ([(Diamonds, Jack), (Hearts, Num 3), (Hearts, Ace)], (Hearts, Ace), IllegalMove) = [(Diamonds, Jack), (Hearts, Num 3)]

val test8_0 = all_same_color [(Hearts, Ace), (Hearts, Queen)] = true
val test8_a = all_same_color [(Hearts, Ace)] = true
val test8_b = all_same_color [] = true
val test8_c = all_same_color [(Hearts, Ace), (Hearts, Queen), (Spades, Num 7)] = false
val test8_d = all_same_color [(Hearts, Ace), (Hearts, Queen), (Hearts, Num 7)] = true

val test9_0 = sum_cards [(Clubs, Num 2),(Clubs, Num 2)] = 4
val test9_a = sum_cards [] = 0
val test9_b = sum_cards [(Clubs, Jack)] = 10
val test9_c = sum_cards [(Clubs, Num 2),(Clubs, Num 3),(Diamonds, Ace)] = 16

val test10_0 = score ([(Hearts, Num 2),(Clubs, Num 4)],10) = 4
val test10_a = score ([(Hearts, Num 6),(Clubs, Num 4)],10) = 0
val test10_b = score ([(Hearts, Num 6),(Clubs, Num 5)],10) = 3
val test10_c = score ([(Hearts, Num 6),(Hearts, Num 5)],10) = 1
val test10_d = score ([(Hearts, Num 6),(Hearts, Num 6)],10) = 3

val test11_0 = officiate ([(Hearts, Num 2),(Clubs, Num 4)],[Draw], 15) = 6
val test11_a = officiate ([(Clubs,Ace),(Spades,Ace),(Clubs,Ace),(Spades,Ace)],
                        [Draw,Draw,Draw,Draw,Draw],
                        42)
             = 3
val test11_b = ((officiate([(Clubs,Jack),(Spades,Num(8))],
                         [Draw,Discard(Hearts,Jack)],
                         42);
               false)
              handle IllegalMove => true)
val test11_c = officiate([], [Draw], 3) = 1

val test12_0 = score_challenge([(Clubs,Ace)], 11)                                = 0
val test12_a = score_challenge([(Diamonds,Queen),(Clubs,Ace)], 20)               = 3
val test12_b = score_challenge([(Clubs,Queen),(Clubs,Ace)], 20)                  = 1
val test12_c = score_challenge([(Clubs,Queen),(Clubs,Ace)], 11)                  = 0
val test12_d = score_challenge([(Clubs,Queen),(Clubs,Ace),(Spades,Ace)], 22)     = 0
val test12_e = score_challenge([(Clubs,Num 3),(Hearts,Ace)], 17)                 = 3
val test12_f = score_challenge([(Clubs,Num 3),(Clubs,Ace)], 17)                  = 1
val test12_g = score_challenge([(Clubs,Num 3),(Clubs,Ace),(Hearts,Ace)], 17)     = 2
val test12_h = score_challenge([(Clubs,Num 3),(Clubs,Ace),(Clubs,Ace)], 17)      = 1
val test12_i = score_challenge([(Clubs,Num 3),(Clubs,Queen),(Clubs,King)], 17)   = 9
val test12_j = score_challenge([(Clubs,Num 3),(Clubs,Queen),(Hearts,King)], 17) = 18
val test12_k = score_challenge([(Clubs,Ace),(Clubs,Ace),(Hearts,Ace)], 3)       = 0
val test12_l = score_challenge([(Clubs,Ace),(Clubs,Ace),(Clubs,Ace)], 4)        = 0
val test12_m = score_challenge([(Clubs,Ace),(Spades,Ace),(Clubs,Ace),(Spades,Ace)], 22) = 3

val test13_0 = officiate_challenge ([(Hearts, Num 2),(Clubs, Num 4)],[Draw], 15) = 6
val test13_a = officiate_challenge ([(Clubs,Ace),(Spades,Ace),(Clubs,Ace),(Spades,Ace)],
                                    [Draw,Draw,Draw,Draw,Draw],
                                    42)
               = 3
val test13_b = ((officiate_challenge ([(Clubs,Jack),(Spades,Num(8))],
                                      [Draw,Discard(Hearts,Jack)],
                                      42);
                 false)
                handle IllegalMove => true)
val test13_c = officiate_challenge ([], [Draw], 3) = 1
val test13_d = officiate_challenge ([(Clubs,Ace),(Spades,Ace),(Clubs,Ace),(Spades,Ace)],
                                    [Draw,Draw,Draw,Draw,Draw],
                                    22)
               = 3
val test13_e = officiate_challenge ([(Hearts,Ace),(Spades,Ace),(Clubs,Ace),(Spades,Ace)],
                                    [Draw,Draw,Draw,Draw,Draw],
                          22)
               = 6

val test14_0 = careful_player ([(Hearts,Ace),(Spades,Ace),(Clubs,Ace),(Spades,Ace)], 11) = [Draw]
val test14_a = careful_player ([(Hearts,Ace),(Spades,Ace),(Clubs,Ace),(Spades,Ace)], 21) = [Draw]
val test14_b = careful_player ([(Hearts,Ace),(Spades,Ace),(Clubs,Ace),(Spades,Ace)], 54) = [Draw,Draw,Draw,Draw]
val test14_c = careful_player ([(Hearts,Ace),(Spades,Ace),(Clubs,Ace),(Spades,Ace)], 55) = [Draw,Draw,Draw,Draw,Draw]
val test14_d = careful_player ([(Hearts, Num 1)], 0) = []
val test14_e = careful_player ([(Hearts, Jack),(Hearts, Ace)], 11) = [Draw]
val test15_f = careful_player ([(Hearts, Num 4),(Spades, Queen),(Clubs, Num 7)], 17) = [Draw,Draw,Discard(Hearts, Num 4),Draw]
