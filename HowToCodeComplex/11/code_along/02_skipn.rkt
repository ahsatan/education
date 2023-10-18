;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname 02_skipn) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; 
; PROBLEM
; 
; Design a function that consumes a list of elements lox and a natural number
; n and produces the list formed by including the first element of lox, then 
; skipping the next n elements, including an element, skipping the next n 
; and so on.
; 
;  (skipn (list "a" "b" "c" "d" "e" "f") 2) should produce (list "a" "d")
; 


;; (: skipn ((ListOf X) Natural -> (ListOf X)))
;; Produce the list formed by including an element then skipping n elements, repeat.

(check-expect (skipn empty 1) empty)
(check-expect (skipn (list 1 2 3 4 5) 1) (list 1 3 5))
(check-expect (skipn (list 'a 'b 'c 'd 'e 'f) 2) (list 'a 'd))

(define (skipn lox n)
  (local [(define (skipn lox count)
            (cond [(empty? lox) empty]
                  [else (if (zero? count)
                            (cons (first lox) (skipn (rest lox) n))
                            (skipn (rest lox) (sub1 count)))]))]
    (skipn lox 0)))