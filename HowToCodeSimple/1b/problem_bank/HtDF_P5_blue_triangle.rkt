;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname HtDF_P5_blue_triangle) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; 
; PROBLEM
; 
; Follow the HtDF recipe to design a function that consumes a number and
; produces a blue solid triangle of that size.
; 


(require 2htdp/image)
(define Image (signature (predicate image?)))

(: blue-triangle (Natural -> Image))
;; Produce a blue triangle of the given size.

(check-expect (blue-triangle 25) (triangle 25 "solid" "blue"))

#;
(define (blue-triangle s) empty-image)

#;
(define (blue-triangle s)
  (... s))

(define (blue-triangle s)
  (triangle s "solid" "blue"))