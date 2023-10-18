;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname P3_strictly_decreasing) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; 
; PROBLEM
; 
; Design a function that consumes a list of numbers and produces #true if the 
; numbers in lon are strictly decreasing. You may assume that the list has at 
; least two elements.
; 


(: decreasing? ((ListOf Number) -> Boolean))
;; Produce #true if every number in the list < the previous number.
;; ASSUME: List length >= 2.

(check-expect (decreasing? (list 1 2)) #f)
(check-expect (decreasing? (list 3 2 1 2)) #f)
(check-expect (decreasing? (list 2 1)) #t)
(check-expect (decreasing? (list 3.04 2.8 2.44)) #t)

(define (decreasing? lon)
  (local [(define (decreasing? lon prev)
            (cond [(empty? lon) #t]
                  [else (if (< (first lon) prev)
                        (decreasing? (rest lon) (first lon))
                        #f)]))]
    (decreasing? (rest lon) (first lon))))