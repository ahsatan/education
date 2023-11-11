use "hw3.sml";

(* All the tests should evaluate to true. For example, the REPL should say: val test1_0 = true : bool *)

val test1_0 = only_capitals ["A","B","C"] = ["A","B","C"]
val test1_a = only_capitals ["A", "b", "C", "d"] = ["A", "C"]
val test1_b = only_capitals [] = []
val test1_c = only_capitals ["aBC", "Def", "123", "GGG"] = ["Def", "GGG"]

val test2_0 = longest_string1 ["A","bc","C"] = "bc"
val test2_a = longest_string1 ["abc", "def", "ghi"] = "abc"
val test2_b = longest_string1 [] = ""
val test2_c = longest_string1 ["abc", "d", "ef", "ghi", "jklm"] = "jklm"

val test3_0 = longest_string2 ["A","bc","C"] = "bc"
val test3_a = longest_string2 ["abc", "def", "ghi"] = "ghi"
val test3_b = longest_string2 [] = ""
val test3_c = longest_string2 ["abc", "d", "ef", "ghi", "jklm"] = "jklm"

val test4a_0 = longest_string3 ["A","bc","C"] = "bc"
val test4a_a = longest_string3 ["abc", "def", "ghi"] = "abc"
val test4a_b = longest_string3 [] = ""
val test4a_c = longest_string3 ["abc", "d", "ef", "ghi", "jklm"] = "jklm"

val test4b_0 = longest_string4 ["A","bc","C"] = "bc"
val test4b_a = longest_string4 ["abc", "def", "ghi"] = "ghi"
val test4b_b = longest_string4 [] = ""
val test4b_c = longest_string4 ["abc", "d", "ef", "ghi", "jklm"] = "jklm"

val test5_0 = longest_capitalized ["A","bc","C"] = "A"
val test5_a = longest_capitalized ["abc","Bc","Cd"] = "Bc"
val test5_b = longest_capitalized [] = ""

val test6_0 = rev_string "abc" = "cba"
val test6_a = rev_string "" = ""
val test6_b = rev_string "1" = "1"

fun f x = if x > 3 then SOME x else NONE
val test7_0 = first_answer f [1,2,3,4,5] = 4
val test7_a = ((first_answer f [1,2,3,3] ; false) handle NoAnswer => true)
val test7_b = ((first_answer f [] ; false) handle NoAnswer => true)

fun f x = if x = 1 then SOME [x] else NONE
val test8_0 = all_answers f [2,3,4,5,6,7] = NONE
val test8_a = all_answers f [1,1,1] = SOME [1, 1, 1]
val test8_b = all_answers f [] = SOME []
val test8_c = all_answers f [1,1,7,1] = NONE

val test9a_0 = count_wildcards Wildcard = 1
val test9a_a = count_wildcards (Variable "a") = 0
val test9a_b = count_wildcards (TupleP [Variable "a", Wildcard, Variable "a", Wildcard]) = 2
val test9a_c = count_wildcards (ConstructorP("a", TupleP[Wildcard, Variable "a"])) = 1

val test9b_0 = count_wild_and_variable_lengths Wildcard = 1
val test9b_a = count_wild_and_variable_lengths (Variable "ab") = 2
val test9b_b = count_wild_and_variable_lengths UnitP = 0
val test9b_c = count_wild_and_variable_lengths (ConstructorP("a", TupleP[Wildcard, Variable "abc"])) = 4

val test9_c_0 = count_some_var("a", Wildcard) = 0
val test9_c_a = count_some_var("a", (Variable "a")) = 1
val test9_c_b = count_some_var("a", UnitP) = 0
val test9_c_c = count_some_var("a", TupleP[Wildcard, Variable "a", Variable "b"]) = 1
val test9_c_d = count_some_var("a", ConstructorP("a", TupleP[Wildcard, Variable "a", TupleP[Variable "a", Variable "b"]])) = 2

val test10_0 = check_pat Wildcard = true
val test10_a = check_pat (Variable "x") = true
val test10_b = check_pat (TupleP[Wildcard, Variable "a", ConstructorP("a", Variable "b")]) = true
val test10_c = check_pat (TupleP[Wildcard, Variable "a", ConstructorP("c", Variable "a")]) = false

val test11_0 = match(Const 1, Wildcard) = SOME []
val test11_a = match(Unit, Wildcard) = SOME []
val test11_b = match(Tuple[Const 1, Unit], Wildcard) = SOME []
val test11_c = match(Constructor("a", Const 1), Wildcard) = SOME []
val test11_d = match(Const 1, Variable "a") = SOME [("a",Const 1)]
val test11_e = match(Unit, Variable "a") = SOME [("a", Unit)]
val test11_f = match(Tuple[Const 1, Unit], Variable "a") = SOME [("a",Tuple[Const 1, Unit])]
val test11_g = match(Constructor("a", Const 1), Variable "a") = SOME [("a",Constructor("a", Const 1))]
val test11_h = match(Const 1, UnitP) = NONE
val test11_i = match(Unit, UnitP) = SOME []
val test11_j = match(Tuple[Const 1, Unit], UnitP) = NONE
val test11_k = match(Constructor("a", Unit), UnitP) = NONE
val test11_l = match(Const 1, ConstP 1) = SOME []
val test11_m = match(Const 1, ConstP 2) = NONE
val test11_n = match(Unit, ConstP 1) = NONE
val test11_o = match(Tuple[Const 1, Unit], ConstP 1) = NONE
val test11_p = match(Constructor("a", Const 1), ConstP 1) = NONE
val test11_q = match(Const 1, TupleP[ConstP 1]) = NONE
val test11_r = match(Unit, TupleP[UnitP]) = NONE
val test11_s = match(Constructor("a", Const 1), TupleP[ConstP 1]) = NONE
val test11_t = match(Tuple[Unit], TupleP[UnitP, UnitP]) = NONE
val test11_u = match(Tuple[Unit, Unit], TupleP[UnitP]) = NONE
val test11_v = match(Tuple[Const 1], TupleP[UnitP]) = NONE
val test11_w = match(Tuple[Const 1], TupleP[ConstP 2]) = NONE
val test11_x = match(Tuple[Const 1], TupleP[ConstP 1]) = SOME []
val test11_y = match(Tuple[Unit], TupleP[Variable "a"]) = SOME [("a", Unit)]
val test11_z = match(Tuple[Constructor("a", Const 1)], TupleP[ConstructorP("a", ConstP 1)]) = SOME []
val test11_aa = match(Const 1, ConstructorP("a", ConstP 1)) = NONE
val test11_bb = match(Unit, ConstructorP("a", UnitP)) = NONE
val test11_cc = match(Tuple[Unit], ConstructorP("a", TupleP[UnitP])) = NONE
val test11_dd = match(Constructor("a", Unit), ConstructorP("b", UnitP)) = NONE
val test11_ee = match(Constructor("a", Unit), ConstructorP("a", UnitP)) = SOME []

val test12_0 = first_match Unit [UnitP] = SOME []
val test12_a = first_match (Const 1) [] = NONE
val test12_b = first_match (Const 1) [ConstP 2] = NONE
val test12_c = first_match (Const 1) [ConstP 2, Variable "a", ConstP 1] = SOME [("a", Const 1)]

val test13_0 = typecheck_patterns ([],
                                  [TupleP[Variable("x"),Variable("y")],TupleP[Wildcard,Wildcard]]) =
               SOME (TupleT[Anything,Anything])
val test13_a = typecheck_patterns ([("foo","bar",IntT)],
                                  [TupleP[Variable("x"),Variable("y")],TupleP[Wildcard,ConstructorP("foo",ConstP 12)]]) =
               SOME (TupleT[Anything,Datatype "bar"])
val test13_b = typecheck_patterns ([],
                                  [TupleP[Wildcard,TupleP[Wildcard,Wildcard]],TupleP[ConstP 12,Wildcard]]) =
               SOME (TupleT[IntT,TupleT[Anything,Anything]])
val test13_c = typecheck_patterns ([],[UnitP,TupleP[Wildcard,Wildcard],ConstP 1]) = NONE
val test13_d = typecheck_patterns ([("foo","bar",IntT),("baz","bin",UnitT)],
                                  [ConstructorP("foo",ConstP 1),ConstructorP("baz",UnitP)]) = NONE
val test13_e = typecheck_patterns ([("foo","bar",Datatype "bin"),("baz","bin",UnitT)],
                                  [ConstructorP("foo",UnitP)]) = NONE
val test13_f = typecheck_patterns ([("foo","bar",IntT),("baz","bar",UnitT)],
                                  [ConstructorP("foo",ConstP 7),ConstructorP("baz",UnitP)]) =
               SOME (Datatype "bar")
val test13_g = typecheck_patterns ([("SOME","foo",IntT)],
                                   [ConstP 10,Variable "a",ConstructorP("SOME",Variable "x")]) = NONE
val test13_h = typecheck_patterns ([("Empty","list",UnitT),("List","list",(TupleT[Anything,Datatype "list"]))],
                                   [ConstructorP("Empty", UnitP),
                                    ConstructorP("List", TupleP[ConstP 1, Variable "xs"]),
                                    ConstructorP("List", TupleP[  UnitP , Variable "xs"]),
                                    Wildcard]) = SOME (Datatype "list")
