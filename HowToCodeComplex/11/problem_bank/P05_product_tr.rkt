;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-advanced-reader.ss" "lang")((modname P5_product_tr) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; 
; PROBLEM
; 
; Use an accumulator to design a tail-recursive version of product.
; 


(: product ((ListOf Number) -> Number))
;; Produce product of all elements of lon.

(check-expect (product empty) 1)
(check-expect (product (list 2 3 4)) 24)

(define (product lon)
  (local [(define (product lon total)
            (cond [(empty? lon) total]
                  [else (product (rest lon) (* total (first lon)))]))]
    (product lon 1)))
          