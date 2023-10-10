;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname P4_abstract_any) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; 
; PROBLEM
; 
; Design an abstract function called any-pred? to simplify the following two functions.
; Then rewrite the original functions to use your new some-pred? function.
; 


(: any-positive? ((ListOf Number) -> Boolean))
;; Produce #true if any number in lon is positive.

(check-expect (any-positive? empty) #f)
(check-expect (any-positive? (list 2 -3 -4)) #t)
(check-expect (any-positive? (list -2 -3 -4)) #f)

#;
(define (any-positive? lon)
  (cond [(empty? lon) false]
        [else
         (or (positive? (first lon))
             (any-positive? (rest lon)))]))

(define (any-positive? lon)
  (any-pred? positive? lon))


(: any-negative? ((ListOf Number) -> Boolean))
;; Produce #true if any number in lon is negative.

(check-expect (any-negative? empty) #f)
(check-expect (any-negative? (list 2 3 -4)) #t)
(check-expect (any-negative? (list 2 3 4)) #f)

#;
(define (any-negative? lon)
  (cond [(empty? lon) false]
        [else
         (or (negative? (first lon))
             (any-negative? (rest lon)))]))

(define (any-negative? lon)
  (any-pred? negative? lon))


;; (: any-pred? ((X -> Boolean) (ListOf X) ->  Boolean))
;; Produce #true if any element in lox meets fn?.

(check-expect (any-pred? positive? empty) #f)
(check-expect (any-pred? positive? (list 2 -3 -4)) #t)
(check-expect (any-pred? positive? (list -2 -3 -4)) #f)
(check-expect (any-pred? negative? (list 2 3 -4)) #t)

#;
(define (any-pred? fn lox)
  (ormap fn lox))

(define (any-pred? fn? lon)
  (cond [(empty? lon) #f]
        [else
         (or (fn? (first lon))
             (any-pred? fn? (rest lon)))]))