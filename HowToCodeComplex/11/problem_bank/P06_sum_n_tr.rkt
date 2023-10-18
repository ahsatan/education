;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname P6_sum_n_tr) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; 
; PROBLEM
; 
; Consider the following function that consumes Natural number n and produces the sum 
; of all the naturals in [0, n].
;     
; Use an accumulator to design a tail-recursive version of sum-n.
; 


(: sum-n (Natural -> Natural))
;; Produce sum of Natural[0, n].

(check-expect (sum-n 0) 0)
(check-expect (sum-n 1) 1)
(check-expect (sum-n 3) (+ 3 2 1 0))

(define (sum-n n)
  (local [(define (sum-n n total)
            (cond [(zero? n) total]
                  [else (sum-n (sub1 n) (+ total n))]))]
    (sum-n n 0)))