;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname P2_merge) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; 
; PROBLEM
; 
; Design a function merge that consumes two lists of numbers which it assumes are 
; each sorted in ascending order. It produces a single list of all the numbers, 
; sorted in ascending order. 
; 


;; (ListOf Number): one of
;; - empty
;; - (cons Number (ListOf Number))
;; interp. A list of numbers.

(define LON0 empty)
(define LON1 (list 2))
(define LON2 (list 3.14 5 6))
(define LON3 (list 1 4 5 7))

#;
(define (fn-for-lon lon)
  (cond [(empty? lon) ...]
        [else (... (first lon)
                   (fn-for-lon (rest lon)))]))


(: merge ((ListOf Number) (ListOf Number) -> (ListOf Number)))
;; Produce the combined sorted list of two sorted lists of numbers.

(check-expect (merge empty LON1) LON1)
(check-expect (merge LON1 empty) LON1)
(check-expect (merge LON1 LON2) (list 2 3.14 5 6))
(check-expect (merge LON2 LON1) (list 2 3.14 5 6))
(check-expect (merge LON2 LON3) (list 1 3.14 4 5 5 6 7))
(check-expect (merge LON3 LON2) (list 1 3.14 4 5 5 6 7))

(define (merge a b)
  (cond [(empty? a) b]
        [(empty? b) a]
        [else (if (< (first a) (first b))
                  (cons (first a) (merge (rest a) b))
                  (cons (first b) (merge a (rest b))))]))