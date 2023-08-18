;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname HtDF_P7_make_box) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; 
; PROBLEM
; 
; Follow the HtDF recipe to design a function that consumes a color, and creates a
; solid 10x10 square of that colour.
; 


(require 2htdp/image)
(define Image (signature (predicate image?)))

(: make-box (String -> Image))
;; Produce a 10 x 10 square of the given color.

(check-expect (make-box "red") (square 10 "solid" "red"))
(check-expect (make-box "gold") (square 10 "solid" "gold"))

#;
(define (make-box c) empty-image)

#;
(define (make-box c)
  (... c))

(define (make-box c)
  (square 10 "solid" c))