;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname P1_sum_to_n) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; 
; PROBLEM
;   
; Design a function that produces the sum of all the naturals from 0 to a given n. 
;   


(: sum-to-n (Natural -> Natural))
;; Produce the sum of all naturals from [0, n].

(check-expect (sum-to-n 0) 0)
(check-expect (sum-to-n 1) 1)
(check-expect (sum-to-n 4) 10)

(define (sum-to-n n)
  (cond [(zero? n) 0]
        [else (+ n (sum-to-n (sub1 n)))]))