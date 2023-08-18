;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname HtDF_P8_ensure_question) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; 
; PROBLEM
; 
; Follow the HtDF recipe to design a function that consumes a string, and adds "?" 
; to the end unless the string already ends in "?".  Assume given string length > 0.
; 


(: ensure-question (String -> String))
;; Return the given string with a '?' at the end, only adding one if not already there.

(check-expect (ensure-question "help") "help?")
(check-expect (ensure-question "why?") "why?")

#;
(define (ensure-question s) s)

#;
(define (ensure-question s)
  (... s))

(define (ensure-question s)
  (if (string=? "?" (string-ith s (- (string-length s) 1)))
      s
      (string-append s "?")))