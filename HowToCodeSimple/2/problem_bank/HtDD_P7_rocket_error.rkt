;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname HtDD_P7_rocket_error) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; 
; PROBLEM
; 
; has-landed? has errors in the function design.  Make the minimial changes possible to
; 
; a) make the program work properly.
; 
; b) make the function design consistent.
; 



(: descending? (Number -> Boolean))
(define (descending? n)
  (and (< 0 n) (<= n 100)))

(: landed? (Boolean -> Boolean))
(define (landed? b) b)

(define RemainingDescent (signature (predicate descending?)))
(define Landed (signature (predicate landed?)))
(define RocketDescent (signature (mixed RemainingDescent Landed)))
;; interp. Remaining distance until rocket lands OR #t if landed.

(define RD1 100)
(define RD2 40)
(define RD3 0.5)
(define RD4 #t)

#;
(define (fn-for-rocket-descent rd)
  (cond [(number? rd) (... rd)]
        [else  (...)]))


(: has-landed? (RocketDescent -> Boolean))
;; Produce #t if rocket's descent has ended, otherwise #f.
(check-expect (has-landed? 100) #f)
(check-expect (has-landed? 23) #f)
(check-expect (has-landed? 0.25) #f)
(check-expect (has-landed? #t) #t)

#;
(define (has-landed? r) r)

(define (has-landed? rd)
  (not (number? rd)))