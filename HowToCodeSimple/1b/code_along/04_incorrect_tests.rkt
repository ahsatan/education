;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname 04_incorrect_tests) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; 
; PROBLEM
; 
; Follow the HtDF recipe to design a function called area that consumes  
; the length of one side of a square and produces the area of the square.
; 


(: area (Number -> Number))
;; Produce area of square given length of one side.

(check-expect (area 0) 0)
(check-expect (area 5) 25)
(check-expect (area 2.2) 4.84)

#;
(define (area l) 0)

#;
(define (area l)
  (... l))

(define (area l)
  (sqr l))