;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname P5_largest) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
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
; Design a function that consumes a list of numbers and produces the largest number 
; in the list. You may assume that all numbers in the list are greater than 0. If
; the list is empty, produce 0.
; 


(: largest ((ListOf Number) -> Number))
;; Produce the largest number in the list, 0 if list is empty.

(check-expect (largest empty) 0)
(check-expect (largest (cons 3 empty)) 3)
(check-expect (largest (cons 3 (cons 17 empty))) 17)

(define (largest lon)
  (cond [(empty? lon) 0]
        [else (if (> (first lon) (largest (rest lon)))
                  (first lon)
                  (largest (rest lon)))]))