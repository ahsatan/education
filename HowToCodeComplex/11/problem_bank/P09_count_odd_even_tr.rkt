;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname P09_count_odd_even_tr) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; 
; PROBLEM
; 
; Design a function that produces separate counts of the number of odd and even 
; numbers in a list after only traversing the list once.
; 
; Use tail recursion for two implementations: one with 2 accumulators and one with a single
; accumulator. You should provide both solutions.
; 


;; (StructOf Natural Natural)
(define-struct counts (odds evens))
;; interp. Number of even and odd numbers in a list.

(define C1 (make-counts 0 0))
(define C2 (make-counts 3 2))


(: count-1 ((ListOf Integer) -> Counts))
;; Produce the counts of even and odd numbers in the list.

(check-expect (count-1 empty) (make-counts 0 0))
(check-expect (count-1 (list 1 2 3 4 5)) (make-counts 3 2))
(check-expect (count-1 (list 2 4 6)) (make-counts 0 3))

(define (count-1 loi)
  (local [(define (count-1 loi counts)
            (cond [(empty? loi) counts]
                  [(odd? (first loi)) (count-1 (rest loi) (make-counts (add1 (counts-odds counts))
                                                                (counts-evens counts)))]
                  [else (count-1 (rest loi) (make-counts (counts-odds counts)
                                                  (add1 (counts-evens counts))))]))]
    (count-1 loi (make-counts 0 0))))


(: count-2 ((ListOf Integer) -> Counts))
;; Produce the counts of even and odd numbers in the list.

(check-expect (count-2 empty) (make-counts 0 0))
(check-expect (count-2 (list 1 2 3 4 5)) (make-counts 3 2))
(check-expect (count-2 (list 2 4 6)) (make-counts 0 3))

(define (count-2 loi)
  (local [(define (count-2 loi odds evens)
            (cond [(empty? loi) (make-counts odds evens)]
                  [(odd? (first loi)) (count-2 (rest loi) (add1 odds) evens)]
                  [else (count-2 (rest loi) odds (add1 evens))]))]
    (count-2 loi 0 0)))