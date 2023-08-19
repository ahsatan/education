;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname 02_data_definitions) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; 
; (define TLColor (signature (enum 0 1 2)))
; ;; interp. 0 means red, 1 yellow, 2 green               
; #;
; (define (fn-for-tlcolor c)
;   (cond [(= c 0) (...)]
;         [(= c 1) (...)]
;         [(= c 2) (...)]))
; 
; (: next-color (TLColor -> TLColor))
; ;; produce next color of traffic light
; (check-expect (next-color 0) 2)
; (check-expect (next-color 1) 0)
; (check-expect (next-color 2) 1)
; 
; #;
; (define (next-color c) 0)
; 
; (define (next-color c)
;   (cond [(= c 0) 2]
;         [(= c 1) 0]
;         [(= c 2) 1]))


;; A small part of a traffic simulation.

(define TLColor (signature (enum "red" "yellow" "green")))
;; interp. traffic light colors
#;
(define (fn-for-tlcolor c)
  (cond [(string=? c "red") (...)]
        [(string=? c "yellow") (...)]
        [(string=? c "green") (...)]))

(: next-color (TLColor -> TLColor))
;; Produce next color of traffic light.

(check-expect (next-color "red") "green")
(check-expect (next-color "yellow") "red")
(check-expect (next-color "green") "yellow")

#;
(define (next-color c) "red")

(define (next-color c)
  (cond [(string=? c "red")    "green"]
        [(string=? c "yellow") "red"]
        [(string=? c "green")  "yellow"]))