;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname accumulators_quiz) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; 
; PROBLEM 1
;  
; Using at least one accumulator, design a function that consumes (ListOf String)
; and produces the length of the longest string in the list.
;  


(: longest-length ((ListOf String) -> Natural))
;; Produce the length of the longest string in the given list.

(check-expect (longest-length empty) 0)
(check-expect (longest-length (list "ab")) 2)
(check-expect (longest-length (list "a" "bc" "def" "g")) 3)

(define (longest-length los)
  (local [(define (longest-length los longest)
            (cond [(empty? los) longest]
                  [else (if (< longest (string-length (first los)))
                            (longest-length (rest los) (string-length (first los)))
                            (longest-length (rest los) longest))]))]
    (longest-length los 0)))


; 
; PROBLEM 2
;  
; The Fibbonacci Sequence is  0, 1, 1, 2, 3, 5, 8, 13, ... where n = n-2 + n-1. 
;  
; Design a function that given (ListOf Natural), length >= 2, determines if the list
; obeys the fibonacci rule. The sequence does not have to start at zero, so for 
; example, the sequence 4, 5, 9, 14, 23 would follow the rule. 
;  


(: fib? ((ListOf Natural) -> Boolean))
;; Produce #true if the given list follows the fibonacci sequence formula (n = n-2 + n-1).
;; ASSUME: List length >= 2.

(check-expect (fib? (list 3 5)) #t)
(check-expect (fib? (list 3 5 7)) #f)
(check-expect (fib? (list 4 5 9 14 23)) #t)

(define (fib? lon)
  (local [(define (fib? lon n-2 n-1)
            (cond [(empty? lon) #t]
                  [(= (+ n-2 n-1) (first lon)) (fib? (rest lon) n-1 (first lon))]
                  [else #f]))]
    (fib? (rest (rest lon)) (first lon) (first (rest lon)))))


; 
; PROBLEM 3
;  
; Refactor the function below to make it tail recursive.  
;  


(: fact (Natural -> Natural))
;; Produces the factorial of the given number.

(check-expect (fact 0) 1)
(check-expect (fact 3) 6)
(check-expect (fact 5) 120)

(define (fact n)
  (local [(define (fact n total)
            (cond [(zero? n) total]
                  [else (fact (sub1 n) (* total n))]))]
    (fact n 1)))


; 
; PROBLEM 4
;  
; Use a worklist accumulator to design a tail recursive function that counts the number of
; regions within and including a given region.
; 
; So (count-regions CANADA) should produce 7.
; 


(define Type (signature (enum "Continent" "Country" "Province" "State" "City")))
;; interp. Category of geographical region.

;; (RegionOf String Type (ListOf Region))
(define-struct region (name type subs))
;; interp. Geographical region.

(define VANCOUVER (make-region "Vancouver" "City" empty))
(define VICTORIA (make-region "Victoria" "City" empty))
(define BC (make-region "British Columbia" "Province" (list VANCOUVER VICTORIA)))
(define CALGARY (make-region "Calgary" "City" empty))
(define EDMONTON (make-region "Edmonton" "City" empty))
(define ALBERTA (make-region "Alberta" "Province" (list CALGARY EDMONTON)))
(define CANADA (make-region "Canada" "Country" (list BC ALBERTA)))

#;
(define (fn-for-r r)
  (local [(define (--r r)
            (... (region-name r)
                 (--type (region-type r))
                 (--lor (region-subs r))))
          
          (define (--type t)
            (cond [(string=? t "Continent") (...)]
                  [(string=? t "Country") (...)]
                  [(string=? t "Province") (...)]
                  [(string=? t "State") (...)]
                  [(string=? t "City") (...)]))
          
          (define (--lor lor)
            (cond [(empty? lor) ...]
                  [else (... (--r (first lor))
                             (--lor (rest lor)))]))]
    (--r r)))


(: count-regions (Region -> Natural))
;; Produce the total number of regions within and including the given region.

(check-expect (count-regions VANCOUVER) 1)
(check-expect (count-regions CANADA) 7)

(define (count-regions r)
  (local [(define (--r r todo count)
            (--lor (append (region-subs r) todo) (add1 count)))
          
          (define (--lor todo count)
            (cond [(empty? todo) count]
                  [else (--r (first todo) (rest todo) count)]))]
    (--r r empty 0)))