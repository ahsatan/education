;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname P3_odd_from_n) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; 
; PROBLEM
;  
; Design a function called odd-from-n that consumes a natural number n,
; and produces a list of all the odd numbers from n down to 1. 
;  
; Note that there is a primitive function, odd?, that produces true if a natural number is odd.
;  


(: odd-from-n (Natural -> (ListOf Natural)))
;; Produce a list of odd numbers from [0, n], decreasing.

(check-expect (odd-from-n 0) empty)
(check-expect (odd-from-n 1) (cons 1 empty))
(check-expect (odd-from-n 2) (cons 1 empty))
(check-expect (odd-from-n 3) (cons 3 (cons 1 empty)))

(define (odd-from-n n)
  (cond [(zero? n) empty]
        [else (if (odd? n)
                  (cons n (odd-from-n (sub1 n)))
                  (odd-from-n (sub1 n)))]))