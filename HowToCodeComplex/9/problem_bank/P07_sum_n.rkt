;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-advanced-reader.ss" "lang")((modname P7_sum_n) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #t #t none #f () #f)))
; 
; PROBLEM
; 
; Complete the design of the following function.
; 


(: sum-n-odds (Natural -> Natural))
;; Produce the sum of the first n odd numbers.

(check-expect (sum-n-odds 0) 0)
(check-expect (sum-n-odds 1) (+ 0 1))
(check-expect (sum-n-odds 3) (+ 0 1 3 5))

(define (sum-n-odds n)
  (foldr + 0 (filter odd? (build-list (* 2 n) identity))))