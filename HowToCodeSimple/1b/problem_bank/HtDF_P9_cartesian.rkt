;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname HtDF_P9_cartesian) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; 
; PROBLEM
; 
; Determine the distance between two points on the screen. We can describe
; those points using Cartesian coordinates as four numbers: x1, y1 and x2, y2. 
; The formula for the distance between those points is:
; .
; Follow the HtDF recipe to design a function called distance that consumes 
; four numbers representing two points and produces the distance between the two points.
; 


(: distance (Number Number Number Number -> Number))
;; Produce the distance between two points on a cartesian coordinate system.

(check-expect (distance 3 0 0 4) 5)
(check-within (distance 1 0 0 1) (sqrt 2) 0.1)

#;
(define (distance x1 y1 x2 y2) 0)

#;
(define (distance x1 y1 x2 y2)
  (... x1 y1 x2 y2))

(define (distance x1 y1 x2 y2)
  (sqrt (+ (sqr (- x2 x1)) (sqr (- y2 y1)))))