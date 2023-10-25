use "hw1.sml";

(* Homework1 Simple Test *)
(* These are basic test cases. Passing these tests does not guarantee that your code will pass the actual homework grader *)
(* To run the test, add a new line to the top of this file: use "homeworkname.sml"; *)
(* All the tests should evaluate to true. For example, the REPL should say: val test1 = true : bool *)

val test0_a = remove_dupes ([]) = []
val test0_b = remove_dupes ([3]) = [3]
val test0_c = remove_dupes ([3,3]) = [3]
val test0_d = remove_dupes ([2,3,2,3,2]) = [3,2]

val test1_a = is_older ((1,2,3),(2,3,4)) = true
val test1_b = is_older ((1,2,3),(1,2,3)) = false
val test1_c = is_older ((2,3,4),(1,2,3)) = false
val test1_d = is_older ((1,2,3),(1,3,3)) = true
val test1_e = is_older ((1,2,3),(1,2,4)) = true

val test2_a = number_in_month ([(2012,2,28),(2013,12,1)],2) = 1
val test2_b = number_in_month ([(2012,2,28),(2013,12,1)],1) = 0
val test2_c = number_in_month ([(2012,2,28),(2013,12,1),(1,12,13)],12) = 2
val test2_d = number_in_month ([],4) = 0

val test3_a = number_in_months ([(2012,2,28),(2013,12,1),(2011,3,31),(2011,4,28)],[2,3,4]) = 3
val test3_b = number_in_months ([(2012,2,28),(2013,2,1),(2011,3,31),(2011,4,28)],[2,3,4]) = 4
val test3_c = number_in_months ([(2012,2,28),(2013,12,1),(2011,3,31),(2011,4,28)],[5,6,7]) = 0
val test3_d = number_in_months ([],[1,2,3,4,5,6,7,8,9,10,11,12]) = 0
val test3_e = number_in_months ([(2012,2,28),(2013,12,1),(2011,3,31),(2011,4,28)],[]) = 0
val test3_f = number_in_months ([],[]) = 0

val chtest_1 = number_in_months_challenge ([(2012,2,28),(2013,12,1),(2011,3,31),(2011,4,28)],[2,3,4,2,3]) = 3

val test4_a = dates_in_month ([(2012,2,28),(2013,12,1)],2) = [(2012,2,28)]
val test4_b = dates_in_month ([(2012,2,28),(2013,12,1)],1) = []
val test4_c = dates_in_month ([(2012,2,28),(2013,12,1),(1,12,13)],12) = [(2013,12,1),(1,12,13)]
val test4_d = dates_in_month ([],4) = []

val test5_a = dates_in_months ([(2012,2,28),(2013,12,1),(2011,3,31),(2011,4,28)],[2,3,4]) = [(2012,2,28),(2011,3,31),(2011,4,28)]
val test5_b = dates_in_months ([(2012,2,28),(2013,2,1),(2011,3,31),(2011,4,28)],[2,3,4]) = [(2012,2,28),(2013,2,1),(2011,3,31),(2011,4,28)]
val test5_c = dates_in_months ([(2012,2,28),(2013,12,1),(2011,3,31),(2011,4,28)],[5,6,7]) = []
val test5_d = dates_in_months ([],[1,2,3,4,5,6,7,8,9,10,11,12]) = []
val test5_e = dates_in_months ([(2012,2,28),(2013,12,1),(2011,3,31),(2011,4,28)],[]) = []
val test5_f = dates_in_months ([],[]) = []

val chtest_2 = dates_in_months_challenge ([(2012,2,28),(2013,12,1),(2011,3,31),(2011,4,28)],[2,3,4,2,3]) = [(2011,4,28),(2012,2,28),(2011,3,31)]

val test6_a = get_nth (["hi", "there", "how", "are", "you"], 2) = "there"
val test6_b = get_nth (["hi", "there", "how", "are", "you"], 1) = "hi"

val test7_a = date_to_string (2013, 6, 1) = "June 1, 2013"
val test7_b = date_to_string (2011, 12, 31) = "December 31, 2011"
val test7_c = date_to_string (0, 1, 50) = "January 50, 0"

val test8_a = number_before_reaching_sum (10, [1,2,3,4,5]) = 3
val test8_b = number_before_reaching_sum (10, [1,2,3,4]) = 3
val test8_c = number_before_reaching_sum (10, [8,3,2,1]) = 1
val test8_d = number_before_reaching_sum (30, [30,31]) = 0
val test8_e = number_before_reaching_sum (31, [30, 31]) = 1

val test9_a = what_month 70 = 3
val test9_b = what_month 31 = 1
val test9_c = what_month 32 = 2
val test9_d = what_month 365 = 12

val test10_a = month_range (31, 34) = [1,2,2,2]
val test10_b = month_range (34, 34) = [2]
val test10_c = month_range (34, 33) = []

val test11_a = oldest([(2012,2,28),(2011,3,31),(2011,4,28)]) = SOME (2011,3,31)
val test11_b = oldest([]) = NONE
val test11_c = oldest([(2012,2,28)]) = SOME (2012,2,28)

val chtest_3_a = reasonable_date (2010,12,31) = true
val chtest_3_b = reasonable_date (2000,2,29) = true
val chtest_3_c = reasonable_date (1900,2,29) = false
val chtest_3_d = reasonable_date (2016,2,29) = true
val chtest_3_e = reasonable_date (0,1,1) = false
val chtest_3_f = reasonable_date (1,1,31) = true
val chtest_3_g = reasonable_date (1300,0,4) = false
val chtest_3_h = reasonable_date (1300,13,4) = false
val chtest_3_i = reasonable_date (2023,9,30) = true
