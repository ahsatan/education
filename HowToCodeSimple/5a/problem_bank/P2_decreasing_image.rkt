;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname P2_decreasing_image) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; 
; PROBLEM
;  
; Design a function called decreasing-image that consumes a Natural n and
; produces an image of all the numbers from n to 0 side by side. 
;  
; So (decreasing-image 3) should produce .


(require 2htdp/image)
(define Image (signature (predicate image?)))

(define SIZE 24)
(define COLOR "gold")
(define SPACE (text " " SIZE COLOR))


(: decreasing-image (Natural -> Image))
;; Produce an image of all numbers from [0, n], decreasing, side by side.

(check-expect (decreasing-image 0) (text "0" SIZE COLOR))
(check-expect (decreasing-image 1) (beside (text "1" SIZE COLOR)
                                           SPACE
                                           (text "0" SIZE COLOR)))
(check-expect (decreasing-image 2) (beside (text "2" SIZE COLOR)
                                           SPACE
                                           (text "1" SIZE COLOR)
                                           SPACE
                                           (text "0" SIZE COLOR)))

(define (decreasing-image n)
  (cond [(zero? n) (text "0" SIZE COLOR)]
        [else (beside (text (number->string n) SIZE COLOR)
                      SPACE
                      (decreasing-image (sub1 n)))]))