;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname P6_bag) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
;; (BagOf Number Number Number)
(define-struct bag (l w h))
;; interp. Bag with a length, width, and height in cm.

(define B1 (make-bag 19.5 10.0 6.5))
(define B2 (make-bag 23.0 11.5 7.0))
(define B3 (make-bag 18.0 9.5 5.5))

(define LOB0 empty)
(define LOB3 (list B1 B2 B3))


; 
; PROBLEM
; 
; The linear length of a bag is defined to be it length + width + height.
; Design a function linear-length-lob that consumes a list of bags and
; produces a list of the linear lengths of each bag in the list.
; 


(: linear-length-lob ((ListOf Bag) -> (ListOf Number)))
;; Produce a list of the linear length of each bag from the given list.

(check-expect (linear-length-lob LOB0) empty)
(check-expect (linear-length-lob (list B1)) (list (+ 19.5 10.0 6.5)))
(check-expect (linear-length-lob LOB3) (list (+ 19.5 10.0 6.5) (+ 23.0 11.5 7.0) (+ 18.0 9.5 5.5)))

(define (linear-length-lob lob)
  (local [(define (linear-length b) (+ (bag-l b) (bag-w b) (bag-h b)))]
    (map linear-length lob)))