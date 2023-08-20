;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname 09_HtDF_interval) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; 
; PROBLEM:
; 
; Using the SeatNum data definition below design a function
; that produces true if the given seat number is on the aisle. 
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

(: aisle? (SeatNum -> Boolean))
;; Produce #true if the given seat number is an aisle seat, #false otherwise.

(check-expect (aisle? SN1) #true)
(check-expect (aisle? SN3) #true)
(check-expect (aisle? SN2) #false)

#;
(define (aisle? sn) #false)

#;
(define (aisle? sn)
  (... sn))

(define (aisle? sn)
  (or (= 1 sn)
      (= 32 sn)))