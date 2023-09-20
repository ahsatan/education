;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname 06_designing_with_lists) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; 
; PROBLEM
; 
; You've been asked to design a program having to do with all the owls
; in the owlery.
; 
; (A) Design a data definition to represent the weights of all the owls. 
;     For this problem call it ListOfNumber.
; (B) Design a function that consumes the weights of owls and produces
;     the total weight of all the owls.
; (C) Design a function that consumes the weights of owls and produces
;     the total number of owls.
;     


;; (ListOf Number): one of
;;  - empty
;;  - (cons Number (ListOf Number))
;; interp. List of owl weights in ounces.

(define LON1 empty)
(define LON2 (cons 60 (cons 42 empty)))

#;
(define (fn-for-lon lon)
  (cond [(empty? lon) ...]
        [else (... (first lon)
                   (fn-for-lon (rest lon)))]))


(: sum ((ListOf Number) -> Number))
;; Produce sum of the weights of the owls in the list.
   
(check-expect (sum empty) 0)
(check-expect (sum (cons 20 empty)) 20)
(check-expect (sum (cons 32 (cons 20 empty))) (+ 32 20))

(define (sum lon)
  (cond [(empty? lon) 0]
        [else (+ (first lon)          
                 (sum (rest lon)))]))


(: total ((ListOf Number) -> Number))
;; Produce the total number of owls in the list.

(check-expect (total empty) 0)
(check-expect (total (cons 20 empty)) 1)
(check-expect (total (cons 32 (cons 20 empty))) 2)

(define (total lon)
  (cond [(empty? lon) 0]
        [else (+ 1 (total (rest lon)))]))