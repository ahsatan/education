;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname 11_HtDF_itemization) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; 
; PROBLEM
; 
; Design a function that consumes Countdown and produces an
; image showing the current status of the countdown.
; 


(require 2htdp/image)
(define Image (signature (predicate image?)))

(: 10-1? (Natural -> Boolean))
(define (10-1? n)
  (>= 10 n 1))

(: complete? (String -> Boolean))
(define (complete? s)
  (string=? "Happy New Year!" s))

(define Waiting (signature (predicate false?)))
(define Countdown (signature (predicate 10-1?)))
(define Complete (signature (predicate complete?)))
(define NYECountdown (signature (mixed Waiting Countdown Complete)))
;; interp. Countdown information leading up to NYE midnight.

(define NYECD1 1)
(define NYECD2 4)
(define NYECD3 10)

#;
(define (fn-for-nye-countdown nyecd)
  (cond [(false? nyecd) (...)]
        [(number? nyecd) (... nyecd)]
        [else (...)]))

(: display_nyecd (NYECountdown -> Image))
;; Produce an image display the status of the NYE countdown.

(check-expect (display_nyecd #false) (text "Waiting..." 24 "white"))
(check-expect (display_nyecd 10) (text "10" 24 "red"))
(check-expect (display_nyecd "Happy New Year!") (text "Happy New Year!" 24 "gold"))

#;
(define (display_nyecd nyecd) empty-image)

#;
(define (display_nyecd nyecd)
  (cond [(false? nyecd) (...)]
        [(number? nyecd) (... nyecd)]
        [else (...)]))

(define (display_nyecd nyecd)
  (cond [(false? nyecd) (text "Waiting..." 24 "white")]
        [(number? nyecd) (text (number->string nyecd) 24 "red")]
        [else (text nyecd 24 "gold")]))