;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname HtDD_P8_direction) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; 
; PROBLEM
; 
; Given the data definition below, design a function named left 
; that consumes a compass direction and produces the direction 
; that results from making a 90 degree left turn.
; 


(define Direction (signature (enum "N" "S" "E" "W")))
;; interp. Compass direction that a player can be facing.

#;
(define (fn-for-direction d)
  (cond [(string=? d "N") (...)]
        [(string=? d "S") (...)]
        [(string=? d "E") (...)]
        [(string=? d "W") (...)]))


(: left (Direction -> Direction))
;; Produce the direction that is 90 degrees to the left of the given direction.

(check-expect (left "N") "W")
(check-expect (left "E") "N")
(check-expect (left "S") "E")
(check-expect (left "W") "S")

#;
(define (left d) d)

#;
(define (left d)
  (cond [(string=? d "N") (...)]
        [(string=? d "S") (...)]
        [(string=? d "E") (...)]
        [(string=? d "W") (...)]))

(define (left d)
  (cond [(string=? d "N") "W"]
        [(string=? d "S") "E"]
        [(string=? d "E") "N"]
        [(string=? d "W") "S"]))