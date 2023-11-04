(* Date: int * int * int
        year * month * day *)

(* Produce the given list with duplicates removed. *)
(* int list -> int list *)
fun remove_dupes xs = foldl (fn (x, acc) => if List.exists (fn y => x = y) acc
                                                         then acc
                                                         else x :: acc)
                                         []
                                         xs

(* Produce true if date1 is before date2, otherwise false. *)
(* fn : (int * int * int) * (int * int * int) -> bool *)
fun is_older ((y1, m1, d1), (y2, m2, d2)) =
    y1 < y2 orelse (* date1 year is older *)
    (y1 = y2 andalso (m1 < m2 orelse (* same year and date1 month is older *)
                                    (m1 = m2 andalso d1 < d2))) (* same year and month and date1 day is older *)

(* Produce the number of dates where the date's month is the given month. *)
(* fn : (int * int * int) list * int -> int *)
fun number_in_month (ds, m) = foldl (fn ((_, m', _), acc) => if m = m' then acc + 1 else acc) 0 ds

(* Produce the number of dates where the date's month is ANY of the given months.
   - ASSUME: Each month in months is unique. *)
(* fn : (int * int * int) list * int list -> int *)
                                     (* CAN I DO op+ o number_in_month *)
fun number_in_months (ds, ms) = foldl (fn (m, acc) => number_in_month (ds, m) + acc) 0 ms

(* Produce the number of dates where the date's month is ANY of the given months. *)
(* fn : (int * int * int) list * int list -> int *)
fun number_in_months_challenge (ds, ms) = number_in_months (ds, remove_dupes ms)

(* Produce a list of dates where the date's month is the given month. *)
(* fn : (int * int * int) list * int -> (int * int * int) list *)
fun dates_in_month (ds, m) = foldr (fn ((y, m', d), acc) => if m = m' then (y, m', d) :: acc else acc) [] ds

(* Produce a list of dates where the date's month is in ANY of the given months.
   - ASSUME: Each month in months is unique. *)
(* fn : (int * int * int) list * int list -> (int * int * int) list *)
fun dates_in_months (ds, ms) = foldr (fn (m, acc) => dates_in_month (ds, m) @ acc) [] ms

(* Produce a list of dates where the date's month is in ANY of the given months. *)
(* fn : (int * int * int) list * int list -> (int * int * int) list *)
fun dates_in_months_challenge (ds, ms) = dates_in_months (ds, remove_dupes ms)

(* Produce the (1-based) nth element in the list.
   - ASSUME: list has at least n elements, n >= 1 *)
(* string list * int -> string *)
fun get_nth (x :: xs, n) =
    case n of
        1 => x
      | _ => get_nth (xs, n - 1)

(* Produce a text representation of a date of the form "January 20, 2013"
   - ASSUME: The date's month is valid, i.e. [1, 12]. *)
(* int * int * int -> string *)
fun date_to_string (y, m, d) =
    let
        val month_names = ["January", "February", "March", "April", "May", "June",
                           "July", "August", "September", "October", "November", "December"]
    in
        get_nth(month_names, m) ^ " " ^ Int.toString(d) ^ ", " ^ Int.toString(y)
    end

(* Produce the number n such that the first n elements of nats add up to < sum and
   the first n + 1 elements add up to >= sum.
   - ASSUME: The entire list of numbers adds up to >= sum.  All numbers are > 0 (natural numbers). *)
(* int * int list -> int *)
fun number_before_reaching_sum (sum, x :: xs) =
    if sum <= x then 0 else 1 + number_before_reaching_sum (sum - x, xs)

(* Produce the month of the year that the given day of the year falls within.
   - ASSUME: The day of the year is valid, i.e. [1, 365]. *)
(* int -> int *)
fun what_month doy =
    let
        val month_days = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
    in
        1 + number_before_reaching_sum(doy, month_days)
    end

(* Produce a list of the month of each day from day_of_year1 to day_of_year2, inclusive. *)
(* int * int -> int list *)
fun month_range (doy1, doy2) =
    let
        fun days doy1 = if doy1 > doy2 then [] else doy1 :: days (doy1 + 1)
    in
        map what_month (days doy1)
    end

(* Produce the oldest date option from the given list or NONE if given an empty list. *)
(* (int * int * int) list -> (int * int * int) option *)
val oldest = foldl (fn (x, y) => case y of
                                     SOME v => if is_older (x, v) then SOME x else y
                                   | NONE => SOME x)
                   NONE

(* Produce true if the date is a real date in the common era. *)
(* int * int * int -> bool *)
fun reasonable_date (y, m, d) =
    let
        val leap_year = y mod 400 = 0 orelse (y mod 4 = 0 andalso y mod 100 <> 0)

        val month_days = [31, if leap_year then 29 else 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
    in
        y > 0 andalso
        m >= 1 andalso m <= 12 andalso
        d >= 1 andalso d <= get_nth(month_days, m)
    end
