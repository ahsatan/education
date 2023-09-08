;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname 04_trip) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; 
; PROBLEM A
; 
; Design a data definition to help travellers plan their next trip including 
; origin, destination, mode of transport and duration (in days).
; 


;; (TripOf (String String String Natural))
(define-struct trip (orig dest mode days))
;; interp. Trip details incl. origin city, destination city, transport mode, & duration in days.

(define T1 (make-trip "Chicago" "San Francisco" "airplane" 1))
(define T2 (make-trip "Columbus" "Boulder" "bus" 2))

#;
(define (fn-for-trip t)
  (... (trip-orig t)
       (trip-dest t)
       (trip-mode t)
       (trip-days t)))

; 
; PROBLEM B
; 
; Design a function that compares two trips and returns the trip with the longest duration.
; 


(: longest-trip (Trip Trip -> Trip))
;; Produces the trip with the longer duration or the first trip if durations are equal.

(check-expect (longest-trip T1 T2) T2)
(check-expect (longest-trip T2 T1) T2)
(check-expect (longest-trip T2 (make-trip "Atlanta" "Miami" "car" 2)) T2)

(define (longest-trip t1 t2)
  (if (>= (trip-days t1) (trip-days t2))
      t1
      t2))