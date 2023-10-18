;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname P10_rev_tr) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; 
; PROBLEM
; 
; Design a tail-recursive function that consumes (ListOf X) and produces a list of the same 
; elements in the opposite order. Use an accumulator. Call the function rev.
; 


;; (: rev ((ListOf X) -> (ListOf X)))
;; Produce list with elements of lox in reverse order.

(check-expect (rev empty) empty)
(check-expect (rev (list 1)) (list 1))
(check-expect (rev (list "a" "b" "c")) (list "c" "b" "a"))

(define (rev lox)
  (local [(define (rev lox l)
            (cond [(empty? lox) l]
                  [else (rev (rest lox) (cons (first lox) l))]))]
    (rev lox empty)))