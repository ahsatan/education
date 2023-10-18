;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-advanced-reader.ss" "lang")((modname P7_sum_odds_tr) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; 
; PROBLEM
; 
; Consider the following function that consumes a list of numbers and produces the sum of 
; all the odd numbers in the list.
; 
; Use an accumulator to design a tail-recursive version of sum-odds.
; 


(: sum-odds ((ListOf Number) -> Number))
;; Produce sum of all odd numbers of lon.

(check-expect (sum-odds empty) 0) 
(check-expect (sum-odds (list 1 2 5 6 11)) 17) 

(define (sum-odds lon)
  (local [(define (sum-odds lon total)
            (cond [(empty? lon) total]
                  [(odd? (first lon)) (sum-odds (rest lon) (+ total (first lon)))]
                  [else (sum-odds (rest lon) total)]))]
    (sum-odds lon 0)))
          