;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname HtDD_P5_style_rules) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; 
; PROBLEM
; 
; Properly re-format the data definiton for SeatNum.
; 
; a) Why is it important to follow style rules?
; Style consistency makes it easier for others to read code (and self to read it later!).
; 
; b) Fix the data definition below so that it follows our style rules. Be sure to 
; consult the style rules page so that you make ALL the required changes, of which 
; there are quite a number.
; 


(: valid_seatnum? (Natural -> Boolean))
(define (valid_seatnum? sn)
  (<= 1 sn 32))

(define SeatNum (signature (predicate valid_seatnum?)))
;interp. The number of a seat in a row, 1 and 32 are aisle seats.

(define SN1 1)
(define SN2 17)
(define SN3 32)

#;
(define (fn-for-seat-num sn)
  (... sn))
