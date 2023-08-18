;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname 05_vary_recipe_order) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; 
; PROBLEM
; 
; Follow the HtDF recipe to design a function called image-area that consumes an image  
; and produces the area of that image (width x height).
; 


(require 2htdp/image)
(define Image (signature (predicate image?)))

(: image-area (Image -> Natural))
;; Produce an image's area by multiplying width by height.

(check-expect (image-area (rectangle 10 15 "solid" "red")) 150)
(check-expect (image-area (circle 6 "solid" "white")) 144)

#;
(define (image-area i) 0)

#;
(define (image-area i)
  (... i))

(define (image-area i)
  (* (image-width i) (image-height i)))