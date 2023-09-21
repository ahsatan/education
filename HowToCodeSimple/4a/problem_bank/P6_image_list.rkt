;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname P6_image_list) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; 
; PROBLEM A
; 
; Design a data definition to represent a list of images. Call it ListOfImage. 
; 


(require 2htdp/image)
(define Image (signature (predicate image?)))

;; (ListOf Image): one of
;; - empty
;; - (cons Image (ListOf Image))

(define LOI1 empty)
(define LOI2 (cons (square 10 "solid" "orange") empty))
(define LOI3 (cons (rectangle 11 291 "solid" "gold") (cons (square 10 "solid" "orange") empty)))

#;
(define (fn-for-loi loi)
  (cond [(empty? loi) ...]
        [else (... (first loi)
                   (fn-for-loi (rest loi)))]))


; 
; PROBLEM B
; 
; Design a function that consumes a list of images and produces a number 
; that is the sum of the areas of each image. For area, just use the image's 
; width times its height.
; 


(: sum-areas ((ListOf Image) -> Number))
;; Produce the sum total area of all images in the list using the calculation width * height.

(check-expect (sum-areas empty) 0)
(check-expect (sum-areas (cons (square 10 "solid" "orange") empty)) 100)
(check-expect (sum-areas (cons (rectangle 11 291 "solid" "gold")
                               (cons (square 10 "solid" "orange") empty)))
              (+ (* 11 291) 100))

(define (sum-areas loi)
  (cond [(empty? loi) 0]
        [else (+ (* (image-width (first loi)) (image-height (first loi)))
                 (sum-areas (rest loi)))]))