;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname P2_double_all) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
;; (ListOf Number): one of
;;  - empty
;;  - (cons Number (ListOf Number))
;; interp. A list of numbers.

(define LON1 empty)
(define LON2 (cons 60 (cons 42 empty)))

#;
(define (fn-for-lon lon)
  (cond [(empty? lon) ...]
        [else (... (first lon)
                   (fn-for-lon (rest lon)))]))


; 
; PROBLEM
; 
; Design a function that consumes a list of numbers and doubles every number 
; in the list. Call it double-all.
; 


(: double-all ((ListOf Number) -> (ListOf Number)))
;; Produce a list where each value is double the value in the given list.

(check-expect (double-all empty) empty)
(check-expect (double-all (cons 3 empty)) (cons 6 empty))
(check-expect (double-all (cons 2 (cons 5 empty))) (cons 4 (cons 10 empty)))

(define (double-all lon)
  (cond [(empty? lon) empty]
        [else (cons (* 2 (first lon))
                    (double-all (rest lon)))]))