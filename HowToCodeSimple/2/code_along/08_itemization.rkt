;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname 08_itemization) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; 
; PROBLEM
; 
; Design a data definition to represent the current state 
; of a NYE countdown, which falls into one of three categories: 
; 
;  - not yet started
;  - from 10 to 1 seconds before midnight
;  - complete "Happy New Year!"
; 


(: waiting? (Boolean -> Boolean))
(define (waiting? b)
  (not b))

(: 10-1? (Natural -> Boolean))
(define (10-1? n)
  (>= 10 n 1))

(: complete? (String -> Boolean))
(define (complete? s)
  (string=? "Happy New Year!" s))

(define Waiting (signature (predicate waiting?)))
(define Countdown (signature (predicate 10-1?)))
(define Complete (signature (predicate complete?)))
(define NYECountdown (signature (mixed Waiting Countdown Complete)))
;; interp. Countdown information leading up to NYE midnight.

(define NYECD1 1)
(define NYECD2 4)
(define NYECD3 10)

#;
(define (fn-for-nye-countdown nyecd)
  (cond [(waiting? nyecd) (...)]
        [(10-1? nyecd) (... nyecd)]
        [(complete? nyecd) (...)]))