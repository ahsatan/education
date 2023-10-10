;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname P3_abstract_sum) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; 
; PROBLEM A
; 
; Design an abstract function to simplify the two sum-of functions. 
; 


;; (: sum-of-squares ((ListOf Number) -> Number))
;; Produce the sum of the squares of the numbers in lon.

#;
(define (sum-of-squares lon)
  (cond [(empty? lon) 0]
        [else
         (+ (sqr (first lon))
            (sum-of-squares (rest lon)))]))


;; (: sum-of-lengths ((ListOf String) -> Number))
;; Produce the sum of the lengths of the strings in los.

#;
(define (sum-of-lengths los)
  (cond [(empty? los) 0]
        [else
         (+ (string-length (first los))
            (sum-of-lengths (rest los)))]))


;; (: abstract-sum ((X -> Y) (ListOf X) -> Y))
;; Produce the sum of the values after mapping them with fn.

(check-expect (abstract-sum sqr empty) 0)
(check-expect (abstract-sum sqr (list 2 4)) (+ 4 16))
(check-expect (abstract-sum string-length (list "a" "bc")) 3)

#;
(define (abstract-sum fn lox)
  (foldr + 0 (map fn lox)))

(define (abstract-sum fn lox)
  (cond [(empty? lox) 0]
        [else
         (+ (fn (first lox))
            (abstract-sum fn (rest lox)))]))


; 
; PROBLEM B
; 
; Re-define the original functions to use abstract-sum.
; 


(: sum-of-squares ((ListOf Number) -> Number))
;; Produce the sum of the squares of the numbers in lon.

(check-expect (sum-of-squares empty) 0)
(check-expect (sum-of-squares (list 2 4)) (+ 4 16))

(define (sum-of-squares lon)
  (abstract-sum sqr lon))


(: sum-of-lengths ((ListOf String) -> Number))
;; Produce the sum of the lengths of the strings in los.

(check-expect (sum-of-lengths empty) 0)
(check-expect (sum-of-lengths (list "a" "bc")) 3)

(define (sum-of-lengths los)
  (abstract-sum string-length los))