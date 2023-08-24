;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname HtDD_P3_rocket) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; 
; PROBLEM A
; 
; Design a data definition RocketDescent to represent a rocket's journey as it descends 
; from 100 kilometers to Earth. Once the rocket has landed it is done.
; 


(: descending? (Natural -> Boolean))
(define (descending? n)
  (<= 1 n 100))

(: landed? (Boolean -> Boolean))
(define (landed? b) b)

(define RemainingDescent (signature (predicate descending?)))
(define Landed (signature (predicate landed?)))
(define RocketDescent (signature (mixed RemainingDescent Landed)))
;; interp. Remaining distance until rocket lands OR #true if landed.

(define RD1 100)
(define RD2 27)
(define RD3 1)
(define RD4 #true)

(define (fn-for-rocket-descent rd)
  (cond [(number? rd) (... rd)]
        [else (...)]))

; 
; PROBLEM B
; 
; Design a function rocket-descent-to-msg that will output the rocket's
; remaining descent distance in a short string that can be broadcast. 
; When the descent is over, the message should be "The rocket has landed!".
; 


(: rocket-descent-to-msg (RocketDescent -> String))
;; Produce shareable message detailing the rocket's descent status.

(check-expect (rocket-descent-to-msg RD1) "Rocket is 100 km from landing!")
(check-expect (rocket-descent-to-msg RD2) "Rocket is 27 km from landing!")
(check-expect (rocket-descent-to-msg RD3) "Rocket is 1 km from landing!")
(check-expect (rocket-descent-to-msg RD4) "The rocket has landed!")

#;
(define (rocket-descent-to-msg rd) "")

#;
(define (rocket-descent-to-msg rd)
  (cond [(number? rd) (... rd)]
        [else (...)]))

(define (rocket-descent-to-msg rd)
  (cond [(number? rd) (string-append "Rocket is " (number->string rd) " km from landing!")]
        [else "The rocket has landed!"]))