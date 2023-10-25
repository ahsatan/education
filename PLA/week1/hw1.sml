(* Date: int * int * int
        year * month * day *)

(* Produce the given list with duplicates removed. *)
(* int list -> int list *)
fun remove_dupes(loi : int list) =
    if null loi
    then []
    else
        let
            fun is_dupe(loi : int list, i : int) =
                not(null loi) andalso (((hd loi) = i) orelse is_dupe(tl loi, i))
            val remove_dupes_tl = remove_dupes(tl loi)
        in
            if is_dupe(remove_dupes_tl, hd loi)
            then remove_dupes_tl
            else (hd loi) :: remove_dupes_tl
        end

(* Produce true if date1 is before date2, otherwise false. *)
(* fn : (int * int * int) * (int * int * int) -> bool *)
fun is_older (date1 : int * int * int, date2 : int * int * int) =
    (#1 date1 < #1 date2) orelse (* date1 year is older *)
    ((#1 date1 = #1 date2) andalso ((#2 date1 < #2 date2) orelse (* same year and date1 month is older *)
                                    ((#2 date1 = #2 date2) andalso (#3 date1 < #3 date2)))) (* same year and month and date1 day is older *)

(* Produce the number of dates where the date's month is the given month. *)
(* fn : (int * int * int) list * int -> int *)
fun number_in_month (dates : (int * int * int) list, month : int) =
    if null dates
    then 0
    else
        let
            val number_in_tl = number_in_month(tl dates, month)
         in
            if (#2 (hd dates)) = month
            then 1 + number_in_tl
            else number_in_tl
        end

(* Produce the number of dates where the date's month is ANY of the given months.
   - ASSUME: Each month in months is unique. *)
(* fn : (int * int * int) list * int list -> int *)
fun number_in_months (dates : (int * int * int) list, months : int list) =
    if null months
    then 0
    else number_in_month(dates, hd months) + number_in_months(dates, tl months)

(* Produce the number of dates where the date's month is ANY of the given months. *)
(* fn : (int * int * int) list * int list -> int *)
fun number_in_months_challenge (dates : (int * int * int) list, months : int list) =
    number_in_months(dates, remove_dupes(months))

(* Produce a list of dates where the date's month is the given month. *)
(* fn : (int * int * int) list * int -> (int * int * int) list *)
fun dates_in_month (dates : (int * int * int) list, month : int) =
    if null dates
    then []
    else
        let
            val dates_in_tl = dates_in_month(tl dates, month)
        in
            if (#2 (hd dates)) = month
            then (hd dates) :: dates_in_tl
            else dates_in_tl
        end

(* Produce a list of dates where the date's month is in ANY of the given months.
   - ASSUME: Each month in months is unique. *)
(* fn : (int * int * int) list * int list -> (int * int * int) list *)
fun dates_in_months (dates : (int * int * int) list, months : int list) =
    if null months
    then []
    else dates_in_month(dates, hd months) @ dates_in_months(dates, tl months)

(* Produce a list of dates where the date's month is in ANY of the given months. *)
(* fn : (int * int * int) list * int list -> (int * int * int) list *)
fun dates_in_months_challenge (dates : (int * int * int) list, months : int list) =
    dates_in_months(dates, remove_dupes(months))

(* Produce the (1-based) nth element in the list.
   - ASSUME: list has at least n elements, n >= 1 *)
(* string list * int -> string *)
fun get_nth (los : string list, n : int) =
    if n = 1
    then hd los
    else get_nth(tl los, n - 1)

(* Produce a text representation of a date of the form "January 20, 2013"
   - ASSUME: The date's month is valid, i.e. [1, 12]. *)
(* int * int * int -> string *)
fun date_to_string (date : int * int * int) =
    let
        val month_names = ["January", "February", "March", "April", "May", "June",
                           "July", "August", "September", "October", "November", "December"]
    in
        get_nth(month_names, #2 date) ^ " " ^ Int.toString(#3 date) ^ ", " ^ Int.toString(#1 date)
    end

(* Produce the number n such that the first n elements of nats add up to < sum and
   the first n + 1 elements add up to >= sum.
   - ASSUME: The entire list of numbers adds up to >= sum.  All numbers are > 0 (natural numbers). *)
(* int * int list -> int *)
fun number_before_reaching_sum (sum : int, nats : int list) =
    if sum <= (hd nats)
    then 0
    else 1 + number_before_reaching_sum(sum - (hd nats), tl nats)

(* Produce the month of the year that the given day of the year falls within.
   - ASSUME: The day of the year is valid, i.e. [1, 365]. *)
(* int -> int *)
fun what_month (day_of_year : int) =
    let
        val month_days = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
    in
        1 + number_before_reaching_sum(day_of_year, month_days)
    end

(* Produce a list of the month of each day from day_of_year1 to day_of_year2, inclusive. *)
(* int * int -> int list *)
fun month_range (day_of_year1 : int, day_of_year2 : int) =
    if day_of_year1 > day_of_year2
    then []
    else what_month(day_of_year1) :: month_range(day_of_year1 + 1, day_of_year2)

(* Produce the oldest date option from the given list or NONE if given an empty list. *)
(* (int * int * int) list -> (int * int * int) option *)
fun oldest (dates : (int * int * int) list) =
    if null dates
    then NONE
    else
        let
            (* Shadows outer oldest function. *)
            fun oldest (dates : (int * int * int) list) =
                if null (tl dates)
                then hd dates
                else
                    let
                        val rest_oldest = oldest (tl dates)
                    in
                        if is_older(hd dates, rest_oldest)
                        then hd dates
                        else rest_oldest
                    end
        in
            SOME (oldest(dates))
        end

(* Produce true if the date is a real date in the common era. *)
(* int * int * int -> bool *)
fun reasonable_date(date: int * int * int) =
    let
        fun divisible (num : int, denom : int) = num mod denom = 0
        fun days_in_month (month_days : int list, month : int) =
            if month = 1
            then hd month_days
            else days_in_month(tl month_days, month - 1)
        val is_leap_year = divisible(#1 date, 400) orelse
                           (divisible(#1 date, 4) andalso not(divisible(#1 date, 100)))
        val feb_days = if is_leap_year then 29 else 28
        val month_days = [31, feb_days, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
    in
        #1 date > 0 andalso
        #2 date >= 1 andalso #2 date <= 12 andalso
        #3 date >= 1 andalso #3 date <= days_in_month(month_days, #2 date)
    end
