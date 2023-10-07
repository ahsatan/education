;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname P4_pattern_match) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(: 1String? (String -> Boolean))
(define (1String? s)
  (= 1 (string-length s)))

(define 1String (signature (predicate 1String?)))
;; 1String is String
;; interp. Strings that are only 1 character long.

(define S1 "x")
(define S2 "2")

(define Pattern (signature (enum "A" "N")))
;; interp. A pattern of a sequence of representative 1Strings, "A" = alphabetic, "N" = numeric.
;;   For example:
;;      (list "A" "N" "A" "N" "A" "N")
;;   describes Canadian postal codes like:
;;      (list "V" "6" "T" "1" "Z" "4")

(define P1 (list "A" "N" "A" "N" "A" "N"))

;; (ListOf 1String): one of
;; - empty
;; - (cons Char (ListOf 1String))
;; interp. A list of 1Strings.

(define LOS1 (list "V" "6" "T" "1" "Z" "4"))

; 
; PROBLEM
; 
; Design a function that consumes Pattern and (ListOf 1String) and produces #true 
; if the pattern matches the (ListOf 1String). For example,
; 
; (pattern-match? (list "A" "N" "A" "N" "A" "N")
;                 (list "V" "6" "T" "1" "Z" "4"))
; 
; should produce #true. If the (ListOf 1String) is longer than the pattern, but the 
; first part matches the whole pattern produce #true. If the (ListOf 1String) is 
; shorter than the Pattern you should produce #false.
; 


(: pattern-match? ((ListOf Pattern) (ListOf 1String) -> Boolean))
;; Produce #true if the given Char list matches the given Pattern list.

(check-expect (pattern-match? empty empty) #t)
(check-expect (pattern-match? (list "A" "N") (list "V")) #f)
(check-expect (pattern-match? (list "A") (list "V" "6")) #t)
(check-expect (pattern-match? (list "A" "N" "A" "N" "N" "N") (list "V" "6" "T" "1" "Z" "4")) #f)
(check-expect (pattern-match? (list "A" "N" "A" "N" "A" "N") (list "V" "6" "T" "1" "Z" "4")) #t)

(define (pattern-match? lop loc)
  (cond [(empty? lop) #t]
        [(empty? loc) #f]
        [(string=? "A" (first lop)) (and (alphabetic? (first loc))
                                         (pattern-match? (rest lop) (rest loc)))]
        [else (and (numeric? (first loc))
                   (pattern-match? (rest lop) (rest loc)))]))


(check-expect (alphabetic? " ") #f)
(check-expect (alphabetic? "1") #f)
(check-expect (alphabetic? "a") #t)
(check-expect (numeric? " ") #f)
(check-expect (numeric? "1") #t)
(check-expect (numeric? "a") #f)

(define (alphabetic? c) (char-alphabetic? (string-ref c 0)))
(define (numeric?    c) (char-numeric?    (string-ref c 0)))