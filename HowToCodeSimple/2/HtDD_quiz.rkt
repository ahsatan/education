;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname HtDD_quiz) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(define Age (signature Natural))
;; interp. A person's age in years.
(define A0 18)
(define A1 25)

#;
(define (fn-for-age a)
  (... a))


; 
; PROBLEM 1
; 
; Design a function called teenager? that determines whether a person
; of a particular age is a teenager (i.e., between the ages of 13 and 19).
; 


(: teenager? (Age -> Boolean))
;; Produce #t if the age is between 13 and 19, inclusive, otherwise #f.

(check-expect (teenager? 12) #f)
(check-expect (teenager? 13) #t)
(check-expect (teenager? 16) #t)
(check-expect (teenager? 19) #t)
(check-expect (teenager? 20) #f)

#;
(define (teenager? a) #f)

#;
(define (teenager? a)
  (... a))

(define (teenager? a)
  (<= 13 a 19))


; 
; PROBLEM 2
; 
; Design a data definition called MonthAge to represent a person's age
; in months.
; 


(define MonthAge (signature Natural))
;; interp. A person's age in months.

(define MA1 3)
(define MA2 127)

#;
(define (fn-for-month-age ma)
  (... ma))


; 
; PROBLEM 3
; 
; Design a function called months-old that takes a person's age in years 
; and yields that person's age in months.
; 


(: months-old (Age -> MonthAge))
;; Produce a person's age in months: 12 x a person's age.

(check-expect (months-old 1) 12)
(check-expect (months-old 20) 240)

#;
(define (months-old a) a)

#;
(define (months-old a)
  (... a))

(define (months-old a)
  (* 12 a))


; 
; PROBLEM 4
; 
; Consider a video game where you need to represent the health of your
; character. The only thing that matters about their health is:
; 
;   - if they are dead (which is shockingly poor health)
;   - if they are alive then they can have 0 or more extra lives
; 
; Design a data definition called Health to represent the health of your
; character.
; 
; Design a function called increase-health that allows you to increase the
; lives of a character.  The function should only increase the lives
; of the character if the character is not dead, otherwise the character
; remains dead.


(: dead? (Boolean -> Boolean))
(define (dead? b) b)

(define Dead (signature (predicate dead?)))
(define Lives (signature Natural))
(define Health (signature (mixed Dead Lives)))
;; interp. Health status of a character - either dead or the number of lives remaining.

(define H1 #t)
(define H2 0)
(define H3 7)

#;
(define (fn-for-health h)
  (cond [(boolean? h) (...)]
        [else (... h)]))

(: increase-health (Health -> Health))
;; Increase a character's health by 1 if they are not dead.

(check-expect (increase-health #t) #t)
(check-expect (increase-health 0) 1)
(check-expect (increase-health 3) 4)

#;
(define (increase-health h) h)

#;
(define (increase-health h)
  (cond [(boolean? h) (...)]
        [else (... h)]))

(define (increase-health h)
  (cond [(boolean? h) h]
        [else (+ 1 h)]))