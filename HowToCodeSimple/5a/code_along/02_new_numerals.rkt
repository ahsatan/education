;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-abbr-reader.ss" "lang")((modname 02_new_numerals) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; 
; PROBLEM
; 
; Your friend has just given you a new pad, and it runs a prototype version of Racket. 
; 
; This is great, you can make it do anything. There's just one problem, this version of 
; racket doesn't include numbers as primitive data. There just are no numbers in it!
; 
; But you need natural numbers to write your next program.
; 
; No problem you say, because you remember the well-formed self-referential data definition 
; for Natural, as well as the idea that add1 is kind of like cons, and sub1 is kind of like
; rest. Your idea is to make add1 actually be cons, and sub1 actually be rest...
; 


;; NATURAL one of
;; - empty
;; - (cons "!" NATURAL)
;; interp. A natural number represented by the number of "!" in the list.

(define N0 empty)
(define N1 (cons "!" N0))
(define N2 (cons "!" N1))
(define N3 (cons "!" N2))
(define N4 (cons "!" N3))
(define N5 (cons "!" N4))
(define N6 (cons "!" N5))
(define N7 (cons "!" N6))
(define N8 (cons "!" N7))
(define N9 (cons "!" N8))

#;
(define (fn-for-NATURAL n)
  (cond [(ZERO? n) ...]
        [else (... n
                   (fn-for-NATURAL (SUB1 n)))]))


(: ZERO? (Any -> Boolean))
(define (ZERO? n)
  (empty? n))

;; (: ADD1 (NATURAL -> NATURAL))
(define (ADD1 n)
  (cons "!" n))

;; (: SUB1 (NATURAL -> NATURAL))
(define (SUB1 n)
  (rest n))


;; (: ADD (NATURAL NATURAL -> NATURAL))
;; Produce the sum of two naturals.

(check-expect (ADD N2 N0) N2)
(check-expect (ADD N0 N3) N3)
(check-expect (ADD N3 N4) N7)

(define (ADD a b)
  (cond [(ZERO? b) a]
        [else (ADD (ADD1 a) (SUB1 b))]))


;; (: SUB (NATURAL NATURAL -> NATURAL))
;; Produce (a - b) where a >= b.

(check-expect (SUB N1 N0) N1)
(check-expect (SUB N5 N2) N3)

(define (SUB a b)
  (cond [(ZERO? b) a]
        [else (SUB (SUB1 a) (SUB1 b))]))