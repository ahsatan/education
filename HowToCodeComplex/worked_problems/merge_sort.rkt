;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-advanced-reader.ss" "lang")((modname merge_sort) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #t #t none #f () #f)))
;; (require racket/list) - take and drop are built ins

;; Merge Sort

(: msort ((ListOf Number) -> (ListOf Number)))
;; Sort the given list of numbers.

(check-expect (msort empty) empty)
(check-expect (msort (list 3)) (list 3))
(check-expect (msort (list 2 3)) (list 2 3))
(check-expect (msort (list 4 3)) (list 3 4))

(define (msort lon)
  (cond [(empty? lon) empty]
        [(empty? (rest lon)) lon]
        [else (merge (take lon (quotient (length lon) 2))
                     (drop lon (quotient (length lon) 2)))]))


(: take ((ListOf Number) Natural -> (ListOf Number)))
;; Produce the first part of the list n long.
;; ASSUME: list length >= n

(check-expect (take empty 0) empty)
(check-expect (take (list 3 12 5) 0) empty)
(check-expect (take (list 3 12 5) 1) (list 3))
(check-expect (take (list 3 12 5) 3) (list 3 12 5))

(define (take lon n)
  (cond [(zero? n) empty]
        [else (cons (first lon) (take (rest lon) (- n 1)))]))


(: drop ((ListOf Number) Natural -> (ListOf Number)))
;; Produce the part of the list after the first n elements.
;; ASSUME: list length >= n

(check-expect (drop empty 0) empty)
(check-expect (drop (list 3 12 5) 0) (list 3 12 5))
(check-expect (drop (list 3 12 5) 1) (list 12 5))
(check-expect (drop (list 3 12 5) 3) empty)

(define (drop lon n)
  (cond [(zero? n) lon]
        [else (drop (rest lon) (- n 1))]))


(: merge ((ListOf Number) (ListOf Number) -> (ListOf Number)))
;; Merge two sorted lists together.

(check-expect (merge empty empty) empty)
(check-expect (merge empty (list 3 4)) (list 3 4))
(check-expect (merge (list 3 4) empty) (list 3 4))
(check-expect (merge (list 1 3 7) (list 2 5 6)) (list 1 2 3 5 6 7))
(check-expect (merge (list 2 5 6) (list 1 3 7)) (list 1 2 3 5 6 7))

(define (merge lon1 lon2)
  (cond [(empty? lon1) lon2]
        [(empty? lon2) lon1]
        [(< (first lon1) (first lon2)) (cons (first lon1) (merge (rest lon1) lon2))]
        [else (cons (first lon2) (merge lon1 (rest lon2)))]))