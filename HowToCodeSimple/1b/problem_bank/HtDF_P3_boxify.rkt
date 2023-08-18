;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname HtDF_P3_boxify) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; 
; PROBLEM
; 
; Follow the HtDF recipe to design a function that consumes an image
; and puts a box around it.
; 
; (boxify (ellipse 60 30 "solid" "red")) should produce .
; 


(require 2htdp/image)
(define Image (signature (predicate image?)))

(: boxify (Image -> Image))
;; Produce a copy of the given image with an outline box around it.

(check-expect (boxify (ellipse 60 30 "solid" "red"))
              (overlay (ellipse 60 30 "solid" "red")
                       (rectangle 62 32 "outline" "black")))

#;
(define (boxify i) i)

#;
(define (boxify i)
  (... i))

(define (boxify i)
  (overlay i
           (rectangle (+ 2 (image-width i)) (+ 2 (image-height i)) "outline" "black")))