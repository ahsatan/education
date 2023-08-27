;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname HtDW_P1_countdown_animation) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; 
; PROBLEM
; 
; Design an animation of a simple countdown that starts at ten and
; decreases by one each clock tick until it reaches zero then stays there.
; 
; To make your countdown progress at a reasonable speed, you can use the 
; rate option to on-tick. If you say, for example, 
; (on-tick advance-countdown 1) then big-bang will wait 1 second between 
; calls to advance-countdown.
; 
; Reset the countdown to 10 when you press the spacebar.
; 


(require 2htdp/image)
(require 2htdp/universe)
(define Image (signature (predicate image?)))
(define KeyEvent (signature (predicate key-event?)))

(: countdown? (Natural -> Boolean))
(define (countdown? n)
  (<= 0 n 10))

(define Countdown (signature (predicate countdown?)))

(define WIDTH 250)
(define HEIGHT 200)
(define CENTER-X (/ WIDTH 2))
(define CENTER-Y (/ HEIGHT 2))
(define FONT-SIZE 48)
(define FONT-COLOR "gold")
(define MTS (empty-scene WIDTH HEIGHT "black"))
(define TICK-RATE 1) ; seconds


(: main (Countdown -> Countdown))
;; Render a countdown, ticking away until it hits 0.
;; Start with (main 10).
(define (main cd)
  (big-bang cd
    (on-tick advance-countdown TICK-RATE)
    (to-draw render)
    (on-key handle-key)))


(: advance-countdown (Countdown -> Countdown))
;; Decrement countdown by 1 each tick until 0.

(check-expect (advance-countdown 10) 9)
(check-expect (advance-countdown 0) 0)

(define (advance-countdown cd)
  (if (= 0 cd)
      cd
      (- cd 1)))


(: render (Countdown -> Image))
;; Produce image of the countdown's current value on MTS.

(check-expect (render 10) (place-image (text "10" FONT-SIZE FONT-COLOR) CENTER-X CENTER-Y MTS))

(define (render cd)
  (place-image (text (number->string cd) FONT-SIZE FONT-COLOR) CENTER-X CENTER-Y MTS))


(: handle-key (Countdown KeyEvent -> Countdown))
;; Reset countdown to 10 on pressing spacebar.

(check-expect (handle-key 7 " ") 10)
(check-expect (handle-key 0 " ") 10)
(check-expect (handle-key 6 "a") 6)

(define (handle-key cd ke)
  (cond [(key=? " " ke) 10]
        [else cd]))


#;
(main 10)