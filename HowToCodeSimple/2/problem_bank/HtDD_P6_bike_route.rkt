;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname HtDD_P6_bike_route) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; 
; PROBLEM A
; 
; Design a data definition BikeRoute to represent varieties of bike routes.
; There are four varieties of designated bike routes:
; 
; 1) Separated Bikeway
; 2) Local Street Bikeway
; 3) Painted Bike Lane
; 4) Painted Shared-Use Lane
; 


(define SEPARATED "Separated Bikeway")
(define LOCAL_STREET "Local Street Bikeway")
(define PAINTED "Painted Bike Lane")
(define PAINTED_SHARED "Painted Shared-Use Lane")

(define BikeRoute (signature (enum SEPARATED LOCAL_STREET PAINTED PAINTED_SHARED)))
;; interp. Various types of biking routes.

#;
(define (fn-for-bike-route br)
  (cond [(string=? SEPARATED br) (...)]
        [(string=? LOCAL_STREET br) (...)]
        [(string=? PAINTED br) (...)]
        [(string=? PAINTED_SHARED br) (...)]))

; 
; PROBLEM B
; 
; Separated bikeways and painted bike lanes are exclusively for bicycles, while
; local street bikeways and shared-use lanes are shared with cars and/or pedestrians.
; 
; Design a function 'exclusive?' that takes a BikeRoute and indicates whether it 
; is exclusively designated for bicycles.
; 


(: exclusive? (BikeRoute -> Boolean))
;; Produce #t if the given BikeRoute is exclusively for bikes, otherwise #f.

(check-expect (exclusive? SEPARATED) #t)
(check-expect (exclusive? LOCAL_STREET) #f)
(check-expect (exclusive? PAINTED) #t)
(check-expect (exclusive? PAINTED_SHARED) #f)

#;
(define (exclusive? br) #f)

#;
(define (exclusive? br)
  (cond [(string=? SEPARATED br) (...)]
        [(string=? LOCAL_STREET br) (...)]
        [(string=? PAINTED br) (...)]
        [(string=? PAINTED_SHARED br) (...)]))

(define (exclusive? br)
  (cond [(string=? SEPARATED br) #t]
        [(string=? LOCAL_STREET br) #f]
        [(string=? PAINTED br) #t]
        [(string=? PAINTED_SHARED br) #f]))