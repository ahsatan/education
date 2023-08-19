;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname HtDF_quiz) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; 
; PROBLEM
; 
; Follow the HtDF recipe to design a function that consumes two images and
; produces #true if the first is larger than the second.
; 


(require 2htdp/image)
(define Image (signature (predicate image?)))

(: larger? (Image Image -> Boolean))
;; Produce #true if the first image's area is larger than the second image, otherwise #false.

(check-expect (larger? (square 10 "solid" "red") (square 11 "solid" "red")) #false)
(check-expect (larger? (rectangle 10 15 "solid" "green") (rectangle 15 10 "solid" "green")) #false)
(check-expect (larger? (circle 5 "solid" "gold") (circle 4 "solid" "gold")) #true)

#;
(define (larger? i1 i2) #false)

#;
(define (larger? i1 i2)
  (... i1 i2))

(define (larger? i1 i2)
  (> (* (image-width i1) (image-height i1))
     (* (image-width i2) (image-height i2))))