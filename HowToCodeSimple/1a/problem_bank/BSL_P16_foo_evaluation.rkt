;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname BSL_P16_foo_evaluation) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; 
; PROBLEM
; 
; Write out the step-by-step evaluation of the expression below.
; 


(define (foo s)
  (if (string=? (substring s 0 1) "a")
      (string-append s "a")
      s))

(foo (substring "abcde" 0 3))
(foo "abc")
(if (string=? (substring "abc" 0 1) "a")
      (string-append "abc" "a")
      "abc")
(if (string=? "a" "a")
      (string-append "abc" "a")
      "abc")
(if #true
      (string-append "abc" "a")
      "abc")
(string-append "abc" "a")
"abca"