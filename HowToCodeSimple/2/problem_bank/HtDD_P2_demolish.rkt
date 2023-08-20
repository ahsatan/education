;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname HtDD_P2_demolish) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; 
; PROBLEM A
; 
; Develop a system that will classify buildings in downtown Vancouver
; based on how old they are. There are three different classification levels:
; new, old, and heritage.
; 
; Design a data definition BuildingStatus to represent these classification levels.
; 


(define BuildingStatus (signature (enum "new" "old" "heritage")))
;; interp. Status of a building based on age.

(define BS1 "new")
(define BS2 "old")
(define BS3 "heritage")

#;
(define (fn-for-building-status bs)
  (cond [(string=? "new" bs) (...)]
        [(string=? "old" bs) (...)]
        [(string=? "heritage" bs) (...)]))

; 
; PROBLEM B
; 
; The city wants to demolish all buildings classified as "old". 
; Design a function called demolish? that determines
; whether a building should be torn down or not.
; 


(: demolish? (BuildingStatus -> Boolean))
;; Produce #true if the building is old, #false otherwise.

(check-expect (demolish? BS1) #false)
(check-expect (demolish? BS2) #true)
(check-expect (demolish? BS3) #false)

#;
(define (demolish? bs) #false)

#;
(define (demolish? bs)
  (cond [(string=? "new" bs) (...)]
        [(string=? "old" bs) (...)]
        [(string=? "heritage" bs) (...)]))

(define (demolish? bs)
  (cond [(string=? "old" bs) #true]
        [else #false]))