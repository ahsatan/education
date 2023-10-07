;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-abbr-reader.ss" "lang")((modname 01_prefix_equal) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; 
; PROBLEM
; 
; Design a function that consumes two lists of strings and produces #true
; if the first list is a prefix of the second. Prefix means that the elements of
; the first list match the elements of the second list 1 for 1, and the second list
; is at least as long as the first.
; 


;; (ListOf String): one of
;; - empty
;; - (cons String (ListOf String))
;; interp. A list of strings.

(define LOS0 empty)
(define LOS1 (cons "a" empty))
(define LOS2 (cons "a" (cons "b" empty)))
(define LOS3 (cons "c" (cons "b" (cons "a" empty))))

#;
(define (fn-for-los los)
  (cond [(empty? los) ...]
        [else  (... (first los)
                    (fn-for-los (rest los)))]))


(: prefix? ((ListOf String) (ListOf String) -> Boolean))
;; Produce #true if the first list is a prefix of the second, otherwise #false.

(check-expect (prefix? empty empty) #t)
(check-expect (prefix? empty LOS1) #t)
(check-expect (prefix? LOS1 empty) #f)
(check-expect (prefix? LOS1 LOS1) #t)
(check-expect (prefix? LOS1 LOS2) #t)
(check-expect (prefix? LOS2 (append LOS2 (list "c"))) #t)
(check-expect (prefix? LOS2 LOS3) #f)

(define (prefix? a b)
  (cond [(empty? a) #t]
        [(empty? b) #f]
        [else (and (string=? (first a) (first b))
                   (prefix? (rest a) (rest b)))]))