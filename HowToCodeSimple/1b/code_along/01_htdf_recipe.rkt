;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname 01_htdf_recipe) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; 
; PROBLEM
; 
; Follow the HtDF recipe to design a function that consumes a number and
; produces twice that number. Call your function double.
; 


(: double (Number -> Number))
;; Produce 2 times the given number.

(check-expect (double 0) 0)
(check-expect (double -1) -2)
(check-expect (double 2) 4)
(check-expect (double 3.1) 6.2)

#;
(define (double n) 0)

#;
(define (double n)
  (... n))

(define (double n)
  (* 2 n))