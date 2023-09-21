;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname P3_boolean_list) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; 
; PROBLEM A
; 
; Design a data definition to represent a list of booleans. Call it ListOfBoolean. 
; 


;; (ListOf Boolean): one of
;; - empty
;; - (cons Boolean (ListOf Boolean))
;; interp. A list of booleans.

#;
(define (fn-for-lob lob)
  (cond [(empty? lob) ...]
        [else (... (first lob)
                   (fn-for-lob (rest lob)))]))


; 
; PROBLEM B
; 
; Design a function that consumes a list of boolean values and produces #true 
; if every value in the list is #true. If the list is empty, your function 
; should also produce #true. Call it all-true?
; 


(: all-true? ((ListOf Boolean) -> Boolean))
;; Produce #true if all values in list are #true.  Empty list is #true.

(check-expect (all-true? empty) #t)
(check-expect (all-true? (cons #t empty)) #t)
(check-expect (all-true? (cons #f empty)) #f)
(check-expect (all-true? (cons #t (cons #f empty))) #f)
(check-expect (all-true? (cons #f (cons #t empty))) #f)

(define (all-true? lob)
  (cond [(empty? lob) #t]
        [else (and (first lob)
                   (all-true? (rest lob)))]))