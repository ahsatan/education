;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname 04_HtDF_non_primitive_data) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; 
; PROBLEM
; 
; Design a function that produces #true if the given city
; is the best in the world.
; 


(define CityName (signature String))
;; interp. name of a city

(define CN1 "Boston")
(define CN_BEST "Kyoto")

#;
(define (fn-for-city-name cn)
  (... cn))

(: best? (CityName -> Boolean))
;; Produce #true if the given city is "Kyoto".

(check-expect (best? CN1) #false)
(check-expect (best? CN_BEST) #true)

#;
(define (best? cn) #false)

#;
(define (best? cn)
  (... cn))

(define (best? cn)
  (string=? CN_BEST cn))