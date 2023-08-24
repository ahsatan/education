;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname HtDD_P4_letter-grade-error) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; 
; PROBLEM
; 
; Design a function that produces true if a given LetterGrade represents
; a passing grade in a course. Revise the code below until all the tests run
; (may still fail).
; 


(define LetterGrade (signature (enum "A" "B" "C" "D" "F")))
;; interp. A letter grade in a course.

#;
(define (fn-for-letter-grade lg)
  (cond [(string=? "A" lg) (...)]
        [(string=? "B" lg) (...)]
        [(string=? "C" lg) (...)]
        [(string=? "D" lg) (...)]
        [(string=? "F" lg) (...)]))


(: pass? (LetterGrade -> Boolean))
;; Produce #t if the LetterGrade represents a passing grade, otherwise #f.
(check-expect (pass? "A") #t)
(check-expect (pass? "B") #t)
(check-expect (pass? "C") #t)
(check-expect (pass? "D") #t)
(check-expect (pass? "F") #f)

(define (pass? lg) #t)