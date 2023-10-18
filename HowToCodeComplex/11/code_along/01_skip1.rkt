;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname 01_skip1) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; 
; PROBLEM
; 
; Design a function that consumes a list of elements and produces the list
; consisting of only the 1st, 3rd, 5th and so on elements of its input. 
; 
;    (skip1 (list "a" "b" "c" "d")) should produce (list "a" "c")
; 


;; (: skip1 ((ListOf X) -> (ListOf X)))
;; Produce list consisting of only elements at odd indices.

(check-expect (skip1 empty) empty)
(check-expect (skip1 (list 'a 'b 'c 'd)) (list 'a 'c))
(check-expect (skip1 (list 1 2 3 4 5)) (list 1 3 5))

(define (skip1 lox)
  (local [(define (skip1 lox i)
            (cond [(empty? lox) empty]
                  [else (if (odd? i)
                            (cons (first lox) (skip1 (rest lox) (add1 i)))
                            (skip1 (rest lox) (add1 i)))]))]
    (skip1 lox 1)))