;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname 06_interval) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; 
; PROBLEM
; 
; Imagine that you are designing a program to manage ticket sales for a
; theatre. (Also imagine that the theatre is perfectly rectangular in shape!)
; 
; Design a data definition to represent a seat number in a row, where each
; row has 32 seats. (Just the seat number, not the row number.)
;  


(: 1-32? (Natural -> Boolean))
(define (1-32? n)
  (<= 1 n 32))

(define SeatNum (signature (predicate 1-32?)))
;; interp. Seat number in a theatre row, 1 and 32 are aisle seats.

(define SN1 1)
(define SN2 13)
(define SN3 32)

#;
(define (fn-for-seat-num sn)
  (... sn))