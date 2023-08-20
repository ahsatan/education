;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname 10_HtDF_enumeration) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; 
; PROBLEM
; 
; Design a function 'bump-up' that consumes a letter grade and
; produces the next highest letter grade.
; 



(define A "A")
(define B "B")
(define C "C")

(define LetterGrade (signature (enum A B C)))
;; interp. Letter grade for a course.

#;
(define (fn-for-letter-grade lg)
  (cond [(string=? A lg) (...)]
        [(string=? B lg) (...)]
        [(string=? C lg) (...)]))

(: bump-up (LetterGrade -> LetterGrade))
;; Bump up the given letter grade to one above it, e.g. C -> B.

(check-expect (bump-up C) B)
(check-expect (bump-up B) A)
(check-expect (bump-up A) A)

#;
(define (bump-up lg) A)

#;
(define (bump-up lg)
  (cond [(string=? A lg) (...)]
        [(string=? B lg) (...)]
        [(string=? C lg) (...)]))

(define (bump-up lg)
  (cond [(string=? A lg) A]
        [(string=? B lg) A]
        [(string=? C lg) B]))