;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname BSL_P11_bobble_evaluation) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; 
; PROBLEM
; 
; Write out the step-by-step evaluation of the expression below.
; 


(define (bobble s)
  (if (<= (string-length s) 6)
      (string-append s "ible")
      s))

(bobble (substring "fungus" 0 4))