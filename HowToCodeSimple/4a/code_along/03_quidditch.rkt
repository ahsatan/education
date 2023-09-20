;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname 03_quidditch) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; 
; PROBLEM
; 
; Design a data definition to represent a list of Quidditch teams. (http://iqasport.org/).
;    


;; (ListOf String): one of
;; - empty
;; - (cons String (ListOf String))
;; interp. List of favorite quidditch team names.

(define LOS1 (cons "Slytherin" empty))
(define LOS2 (cons "Gryffindor" (cons "Hufflepuff" empty)))

#;
(define (fn-for-los los)
  (cond [(empty? los) ...]
        [else (... (first los)
                   (fn-for-los (rest los)))]))


; 
; PROBLEM
; 
; Design a function that consumes ListOfString and produces true if 
; the list includes "UBC".
; 


(: contains-ubc? ((ListOf String) -> Boolean))
;; Produce #true if UBC is one of the favorite quidditch team names.

(check-expect (contains-ubc? empty) #f)
(check-expect (contains-ubc? (cons "Hufflepuff" empty)) #f)
(check-expect (contains-ubc? (cons "UBC" empty)) #t)
(check-expect (contains-ubc? (cons "Slytherin" (cons "UBC" empty))) #t)

(define (contains-ubc? los)
  (cond [(empty? los) #f]
        [else (or (string=? "UBC" (first los))
                  (contains-ubc? (rest los)))]))