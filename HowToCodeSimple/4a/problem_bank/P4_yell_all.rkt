;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname P4_yell_all) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
;; (ListOf String): one of
;;  - empty
;;  - (cons String (ListOf String))
;; interp. A list of strings.

(define LOS0 empty) 
(define LOS1 (cons "a" empty))
(define LOS2 (cons "a" (cons "b" empty)))
(define LOS3 (cons "c" (cons "b" (cons "a" empty))))

#;
(define (fn-for-los los) 
  (cond [(empty? los) ...]
        [else (... (first los)
                   (fn-for-los (rest los)))]))


; 
; PROBLEM
; 
; Design a function that consumes a list of strings and "yells" each word by 
; adding "!" to the end of each string.
; 


(: yell-all ((ListOf String) -> (ListOf String)))
;; Produce a list where each string from the given list is appended with "!".

(check-expect (yell-all empty) empty)
(check-expect (yell-all (cons "a" empty)) (cons "a!" empty))
(check-expect (yell-all (cons "ab" (cons "cde" empty))) (cons "ab!" (cons "cde!" empty)))

(define (yell-all los)
  (cond [(empty? los) empty]
        [else (cons (string-append (first los) "!")
                    (yell-all (rest los)))]))