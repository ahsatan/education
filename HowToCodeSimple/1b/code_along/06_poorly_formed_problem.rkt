;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname 06_poorly_formed_problem) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; 
; PROBLEM
; 
; Follow the HtDF recipe to design a function that consumes an image and
; determines whether the image is tall.
; 


(require 2htdp/image)
(define Image (signature (predicate image?)))

(: tall? (Image -> Boolean))
;; Produce #true if an image is taller than it is wide, otherwise #false.

(check-expect (tall? (rectangle 10 20 "solid" "yellow")) #true)
(check-expect (tall? (rectangle 10 10 "solid" "orange")) #false)
(check-expect (tall? (rectangle 20 10 "solid" "blue")) #false)

#;
(define (tall? i) #false)

#;
(define (tall? i)
  (... i))

(define (tall? i)
  (> (image-height i) (image-width i)))