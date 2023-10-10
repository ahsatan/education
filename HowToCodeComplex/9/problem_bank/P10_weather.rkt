;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname P10_weather) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
;; (WeatherOf String Number Number Number Number Number Number)
(define-struct weather (date max-tmp avg-tmp min-tmp rain snow precip))
;; interp. Data about weather in Vancouver on some date.
;; - max-tmp: maximum temperature in Celsius
;; - avg-tmp: average temperature in Celsius
;; - min-tmp: minimum temperature in Celsius
;; - rain: millimeters of rainfall
;; - snow: millimeters of snowfall
;; - precip: millimeters of total precipitation

(define W0 (make-weather "7/2/88" 21.9 17.7 13.4 0.2 0 0.2))
(define W1 (make-weather "7/3/88" 20.5 18.3 14.0 0.3 0 0.3))
(define W2 (make-weather "7/4/88" 19.1 14.9 10.2 0.1 0 0.1))

(define (fn-for-weather w)
  (... (weather-date w)
       (weather-max-tmp w)
       (weather-avg-tmp w)
       (weather-min-tmp w)
       (weather-rain w)
       (weather-snow w)
       (weather-precip w)))


; 
; PROBLEM
; 
; Complete the design of a function that takes a list of weather data
; and produces the sum total of rainfall in millimeters on days where
; the average temperature was greater than 15 degrees Celsius.
; 
; The function that you design must make at least one call to 
; built-in abstract functions (there is a very nice solution that
; composes calls to three built-in abstract functions).
; 


(: total-warm-rain ((ListOf Weather) -> Number))
;; Produce the total rainfall in millimeters of days with > 15 C average temp.

(check-expect (total-warm-rain empty) 0)
(check-expect (total-warm-rain (list W0)) 0.2)
(check-expect (total-warm-rain (list W0 W1 W2)) 0.5)

(define (total-warm-rain low)
  (local [(define (warm? w) (> (weather-avg-tmp w) 15))]
    (foldr + 0 (map weather-rain (filter warm? low)))))