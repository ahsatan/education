;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname HtDW_P2_traffic_light) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; 
; PROBLEM
; 
; Design an animation of a traffic light that is red, then green,
; then yellow, then red etc.
; 
; Here is what your program might look like if the initial world
; state was the red traffic light:
; .
; Next:
; .
; Next:
; .
; 
; To make your lights change at a reasonable speed, use the rate
; option to on-tick. If you say (on-tick next-color 1) then
; big-bang will wait 1 second between calls to next-color.
; 


(require 2htdp/image)
(require 2htdp/universe)
(define Image (signature (predicate image?)))

(define STOP "red")
(define SLOW "yellow")
(define GO "green")
(define BKGD-COLOR "black")
(define WIDTH 100)
(define HEIGHT (* 3 WIDTH))
(define CENTER-X (/ WIDTH 2))
(define CENTER-Y (/ HEIGHT 2))
(define BULB-RADIUS (/ (- WIDTH 20) 2))
(define GAP (rectangle WIDTH 10 "solid" BKGD-COLOR))
(define MTS (empty-scene WIDTH HEIGHT BKGD-COLOR))

(define TrafficLight (signature (enum STOP SLOW GO)))
;; interp. State of a traffic light: STOP, SLOW, or GO.

#;
(define (fn-for-traffic-light tl)
  (cond [(string=? STOP tl) (...)]
        [(string=? SLOW tl) (...)]
        [(string=? GO tl) (...)]))


(: main (TrafficLight -> TrafficLight))
;; Render a traffic light that repeatedly transitions stop -> go -> slow -> stop in order.
;; Start with (main STOP).
(define (main tl)
  (big-bang tl
    (on-tick advance-traffic-light 1)
    (to-draw render)))


(: advance-traffic-light (TrafficLight -> TrafficLight))
;; Produce the next traffic light color.

(check-expect (advance-traffic-light STOP) GO)
(check-expect (advance-traffic-light SLOW) STOP)
(check-expect (advance-traffic-light GO) SLOW)

(define (advance-traffic-light tl)
  (cond [(string=? STOP tl) GO]
        [(string=? SLOW tl) STOP]
        [(string=? GO tl) SLOW]))


(: render (TrafficLight -> Image))
;; Produce an image representing the three bulbs of a traffic light with the given light lit up.

(check-expect (render STOP) (place-image (above (circle BULB-RADIUS "solid" STOP)
                                                GAP
                                                (circle BULB-RADIUS "outline" SLOW)
                                                GAP
                                                (circle BULB-RADIUS "outline" GO))
                                         CENTER-X
                                         CENTER-Y
                                         MTS))
(check-expect (render SLOW) (place-image (above (circle BULB-RADIUS "outline" STOP)
                                                GAP
                                                (circle BULB-RADIUS "solid" SLOW)
                                                GAP
                                                (circle BULB-RADIUS "outline" GO))
                                         CENTER-X
                                         CENTER-Y
                                         MTS))
(check-expect (render GO) (place-image (above (circle BULB-RADIUS "outline" STOP)
                                              GAP
                                              (circle BULB-RADIUS "outline" SLOW)
                                              GAP
                                              (circle BULB-RADIUS "solid" GO))
                                       CENTER-X
                                       CENTER-Y
                                       MTS))

(define (render tl)
  (place-image (above (render-bulb STOP tl)
                      GAP
                      (render-bulb SLOW tl)
                      GAP
                      (render-bulb GO tl))
               CENTER-X
               CENTER-Y
               MTS))


(: render-bulb (TrafficLight TrafficLight -> Image))
;; Render a single traffic light bulb.

(check-expect (render-bulb STOP STOP) (circle BULB-RADIUS "solid" STOP))
(check-expect (render-bulb GO SLOW) (circle BULB-RADIUS "outline" GO))

(define (render-bulb curr active)
  (circle BULB-RADIUS
          (if (string=? active curr) "solid" "outline")
          curr))



(main STOP)