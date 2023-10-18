;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-advanced-reader.ss" "lang")((modname P2_replicate_n) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; 
; PROBLEM
; 
; Design a function that consumes a list of elements and a natural n, and produces 
; a list where each element is replicated n times. 
; 
; (replicate-n (list "a" "b" "c") 2) should produce (list "a" "a" "b" "b" "c" "c")
; 


;; (: replicate ((ListOf X) Natural) -> (ListOf X)))
;; Produce a list where each element of the given list is repeated n times.

(check-expect (replicate-n empty 3) empty)
(check-expect (replicate-n (list 'a 'b 'c) 2) (list 'a 'a 'b 'b 'c 'c))
(check-expect (replicate-n (list 7) 5) (list 7 7 7 7 7))

(define (replicate-n lox n)
  (local [(define (replicate lox count)
            (cond [(empty? lox) empty]
                  [else (if (zero? count)
                            (replicate (rest lox) n)
                            (cons (first lox) (replicate lox (sub1 count))))]))]
    (replicate lox n)))