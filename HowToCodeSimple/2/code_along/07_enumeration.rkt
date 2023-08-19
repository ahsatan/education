;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname 07_enumeration) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; 
; PROBLEM
; 
; Design a data definition to represent the letter grade
; in a course which is one of A, B, or C.
;   


(define A "A")
(define B "B")
(define C "C")

(define LetterGrade (signature (enum A B C)))
;; interp. Letter grade for a course.

#;
(define (fn-for-letter-grade lg)
  (cond [(string=? A lg) (...)]
        [(string=? B lg) (...)]
        [(string=? C lg) (...)]))