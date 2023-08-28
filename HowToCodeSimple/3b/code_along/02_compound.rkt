;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname 02_compound) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; 
; PROBLEM
; 
; Design a data definition to represent hockey players, including both 
; their first and last names.
; 


;; (PlayerOf String String)
(define-struct player (first last))
;; interp. Hockey player with first and last name.

(define P1 (make-player "Brandon" "Smith"))
(define P2 (make-player "Sandy" "August"))

#;
(define (fn-for-player p)
  (... (player-first p)
       (player-last p)))