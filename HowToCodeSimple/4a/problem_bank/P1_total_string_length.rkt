;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname P1_total_string_length) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
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
; Design a function that consumes a list of strings and determines the total 
; number of characters (single letters) in the list. Call it total-string-length. 
; 


(: total-string-length ((ListOf String) -> Natural))
;; Produce the total number of characters of all the strings in the list.

(check-expect (total-string-length empty) 0)
(check-expect (total-string-length (cons "a" empty)) 1)
(check-expect (total-string-length (cons "ab" (cons "cde" empty))) 5)

(define (total-string-length los)
  (cond [(empty? los) 0]
        [else (+ (string-length (first los))
                 (total-string-length (rest los)))]))