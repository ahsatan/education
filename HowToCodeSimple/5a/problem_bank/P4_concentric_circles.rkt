;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname P4_concentric_circles) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; 
; PROBLEM
;  
; Design a function that consumes a natural number n and a color c,
; and produces n concentric circles of the given color.
;  
; So (concentric-circles 5 "black") should produce .
;  


(require 2htdp/image)
(define Image (signature (predicate image?)))

(define SIZE-MULTIPLIER 10)


(: concentric-circles (Natural String -> Image))
;; Produce an image with n number of concentric circles in the given color.

(check-expect (concentric-circles 0 "gold") empty-image)
(check-expect (concentric-circles 1 "gold") (circle SIZE-MULTIPLIER "outline" "gold"))
(check-expect (concentric-circles 2 "gold") (overlay (circle (* SIZE-MULTIPLIER 2) "outline" "gold")
                                                     (circle SIZE-MULTIPLIER "outline" "gold")))

(define (concentric-circles n c)
  (cond [(zero? n) empty-image]
        [else (overlay (circle (* SIZE-MULTIPLIER n) "outline" c)
                       (concentric-circles (sub1 n) c))]))