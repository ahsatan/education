;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname BSL_P7_even_more_foo_evaluation) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; 
; PROBLEM
; 
; Write out the step-by-step evaluation of the expression below.
; 


(define (farfle s)
  (string-append s s))

(farfle (substring "abcdef" 0 2))
(farfle "ab")
(string-append "ab" "ab")
"abab"