;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-advanced-reader.ss" "lang")((modname P1_dropn) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; 
; PROBLEM
; 
; Design a function that consumes a list of elements lox and a natural number
; n and produces the list formed by dropping every nth element from lox.
; 
; (dropn (list 1 2 3 4 5 6 7) 3) should produce (list 1 2 4 5 7)
; 


;; (: dropn ((ListOf X) Natural -> (ListOf X)))
;; Remove every nth element from the given list.

(check-expect (dropn empty 5) empty)
(check-expect (dropn (list 1 2 3 4 5 6 7) 3) (list 1 2 4 5 7))
(check-expect (dropn (list 'a 'b 'c 'd 'e 'f 'g 'h) 4) (list 'a 'b 'c 'e 'f 'g))

(define (dropn lox n)
  (local [(define (dropn lox i)
            (cond [(empty? lox) empty]
                  [else (if (zero? (modulo i n))
                            (dropn (rest lox) (add1 i))
                            (cons (first lox) (dropn (rest lox) (add1 i))))]))]
    (dropn lox 1)))