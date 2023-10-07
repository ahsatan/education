;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname P3_zip) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; 
; PROBLEM
; 
; Design a function called zip that consumes two lists of numbers and produces
; a list of Entry formed from the corresponding elements of the two lists.
; 
; (zip (list 1 2 ...) (list 11 12 ...)) should produce:
; 
; (list (make-entry 1 11) (make-entry 2 12) ...)
; 
; Assume that the two lists have the same length.
; 


;; (EntryOf Number Number)
(define-struct entry (k v))
;; Interp. An entry of a key-value pair.

(define E1 (make-entry 3 12))

;; (ListOf Entry): one of
;; - empty
;; - (cons Entry (ListOf Entry))
;; interp. A list of key-value entries.

(define LOE1 (list E1 (make-entry 1 11)))

#;
(define (fn-for-entry e)
  (... (entry-k e)
       (entry-v e)))

#;
(define (fn-for-loe loe)
  (cond [(empty? loe) ...]
        [else (... (fn-for-entry (first loe))
                   (fn-for-loe (rest loe)))]))


(: zip ((ListOf Number) (ListOf Number) -> (ListOf Entry)))
;; Produce a list of entries pairing the keys from the list a with values from list b in order.
;; ASSUME: Lists have the same length.

(check-expect (zip empty empty) empty)
(check-expect (zip (list 1) (list 2)) (list (make-entry 1 2)))
(check-expect (zip (list 1 3) (list 2 4)) (list (make-entry 1 2) (make-entry 3 4)))

(define (zip a b)
  (cond [(empty? a) empty]
        [else (cons (make-entry (first a) (first b)) (zip (rest a) (rest b)))]))