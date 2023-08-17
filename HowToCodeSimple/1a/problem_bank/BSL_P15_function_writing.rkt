;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname BSL_P15_function_writing) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; 
; PROBLEM
; 
; Write a function that consumes two numbers and produces the larger of the two.
; 


(check-expect (larger 3 4) 4)
(check-expect (larger 6 5) 6)
(check-expect (larger 1 1) 1)

(define (larger a b)
  (if (> a b)
      a
      b))