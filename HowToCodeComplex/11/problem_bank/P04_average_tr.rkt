;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname P4_average_tr) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; 
; PROBLEM
; 
; Design a function called average that consumes (ListOf Number) and produces the
; average of the numbers in the list.
; 


(: average ((ListOf Number) -> Number))
;; Produce the average of all the numbers in the list.
;; Average of empty list is 0.

(check-expect (average empty) 0)
(check-expect (average (list 1)) 1)
(check-expect (average (list 3 4 6.5)) 4.5)

(define (average lon)
  (local [(define (average lon total count)
            (cond [(empty? lon) (if (zero? count) 0 (/ total count))]
                  [else (average (rest lon) (+ total (first lon)) (add1 count))]))]
    (average lon 0 0)))