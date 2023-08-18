;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname HtDF_P2_less_than_five) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; 
; PROBLEM
; 
; Follow the HtDF recipe to design a function that consumes a string and
; determines whether its length is less than 5.
; 


(: length-less-than-5? (String -> Boolean))
;; Produce #true if the given string's length is less than 5.

(check-expect (length-less-than-5? "fancypants") #false)
(check-expect (length-less-than-5? "fancy") #false)
(check-expect (length-less-than-5? "orca") #true)

#;
(define (length-less-than-5? s) s)

#;
(define (length-less-than-5? s)
  (... s))

(define (length-less-than-5? s)
  (> 5 (string-length s)))