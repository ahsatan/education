;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname P1_concat) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; 
; PROBLEM
; 
; Design a function called concat that consumes two (ListOf String) and
; produces a single list with all the elements of a preceding b.
; 
; (concat (list "a" "b" ...) (list "x" "y" ...)) should produce:
; 
; (list "a" "b" ... "x" "y" ...)
; 
; You are basically going to design the function append using a cross product 
; of type comments table.
; 


;; (ListOf String): one of
;; - empty
;; - (cons String (ListOf String))
;; interp. A list of strings.

(define LOS0 empty)
(define LOS1 (cons "a" empty))
(define LOS2 (cons "b" (cons "c" empty)))
(define LOS3 (cons "d" (cons "e" (cons "f" empty))))

#;
(define (fn-for-los los)
  (cond [(empty? los) ...]
        [else  (... (first los)
                    (fn-for-los (rest los)))]))


(: concat ((ListOf String) (ListOf String) -> (ListOf String)))
;; Produce a combined list with the elements of a followed by the elements of b.

(check-expect (concat LOS1 empty) LOS1)
(check-expect (concat empty LOS1) LOS1)
(check-expect (concat LOS1 LOS2) (list "a" "b" "c"))
(check-expect (concat LOS2 LOS3) (list "b" "c" "d" "e" "f"))

(define (concat a b)
  (cond [(empty? a) b]
        [(empty? b) a]
        [else (cons (first a) (concat (rest a) b))]))