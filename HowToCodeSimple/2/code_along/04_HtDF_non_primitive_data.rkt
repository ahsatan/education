;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname 04_HtDF_non_primitive_data) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; 
; PROBLEM
; 
; Design a function that produces #true if the given city
; is the best in the world.
; 


;; (: CityName String)
;; interp. name of a city

(define CN1 "Boston")
(define CN2 "Vancouver")

#;
(define (fn-for-city-name cn)
  (... cn))
