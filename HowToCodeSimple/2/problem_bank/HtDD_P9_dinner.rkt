;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname HtDD_P9_dinner) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; 
; PROBLEM A
; 
; You are working on a system that will automate delivery for 
; YesItCanFly! airlines catering service. 
; There are three dinner options for each passenger, chicken, pasta 
; or no dinner at all. 
; 
; Design a data definition to represent a dinner order. Call the type 
; DinnerOrder.
; 


(define DinnerOrder (signature (enum "Chicken" "Pasta" "None")))
;; interp. Airline dinner food order.

#;
(define (fn-for-dinner-order do)
  [cond ((string=? "Chicken" do) (...))
        ((string=? "Pasta" do) (...))
        ((string=? "None" do) (...))])

; 
; PROBLEM B
; 
; Design the function dinner-order-to-msg that consumes a dinner order 
; and produces a message for the flight attendants saying what the
; passenger ordered. 
; 
; For example, calling dinner-order-to-msg for a chicken dinner would
; produce "The passenger ordered chicken."
; 


(: dinner-order-to-msg (DinnerOrder -> String))
;; Produce a string representation of a passenger's dinner order.

(check-expect (dinner-order-to-msg "Chicken") "The passenger ordered chicken.")
(check-expect (dinner-order-to-msg "Pasta") "The passenger ordered pasta.")
(check-expect (dinner-order-to-msg "None") "The passenger ordered nothing.")

#;
(define (dinner-order-to-msg do) do)


#;
(define (dinner-order-to-msg do)
  [cond ((string=? "Chicken" do) (...))
        ((string=? "Pasta" do) (...))
        ((string=? "None" do) (...))])

(define (dinner-order-to-msg do)
  (string-append "The passenger ordered "
                 [cond ((string=? "Chicken" do) "chicken")
                       ((string=? "Pasta" do) "pasta")
                       ((string=? "None" do) "nothing")]
                 "."))