;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname 07_rolling_lambda) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; 
; PROBLEM
; 
; The world starts off with a lambda on the left hand side of the screen. As 
; time passes, the lambda will roll towards the right hand side of the screen. 
; Clicking the mouse changes the direction the lambda is rolling (ie from 
; left -> right to right -> left). If the lambda hits the side of the window 
; it should also change direction.
; 
; Starting display (rolling to the right):
; 
; .
; 
; After a few seconds (rolling to the right):
;       .
; After a few more seconds (rolling to the right):
;                .
; A few seconds after clicking the mouse (rolling to the left):
; 
;      .
; Work out the math you need to in order to make the lambda look like it is
; actually rolling.  Remember that the circumference of a circle is 2*pi*radius,
; so that for each degree of rotation the circle needs to move:
; 
;    2*pi*radius
;    -----------
;        360
; 
; Also note that the rotate function requires an angle in degrees as its 
; first argument. [By that it means Number[0, 360).  One solution to 
; that is to  use the modulo function as follows:
; 
; (rotate (modulo ... 360) LAMBDA)
; 
; where ... can be an expression that produces any positive number of degrees 
; and modulo will produce a number in [0, 360).
; 


(require 2htdp/image)
(require 2htdp/universe)
(require racket/math)
(define Image (signature (predicate image?)))
(define MouseEvent (signature (predicate mouse-event?)))

(define LAMBDA .)
(define RADIUS (/ (image-width LAMBDA) 2))
(define BASE-ROTATION 1)
(define BASE-SPEED (/ (* 2 pi RADIUS) 360))
(define MULTIPLIER 5)
(define ROTATION (* MULTIPLIER BASE-ROTATION))
(define SPEED (* MULTIPLIER BASE-SPEED))
(define WIDTH (* 10 (image-width LAMBDA)))
(define HEIGHT (/ WIDTH 2))
(define MTS (empty-scene WIDTH HEIGHT "midnight blue"))
(define CENTER-Y (/ HEIGHT 2))
(define L-EDGE RADIUS)
(define R-EDGE (- WIDTH RADIUS))


;; (RollerOf (Number Number Number))
(define-struct roller (x dx rot drot))
;; interp. X-position, velocity, rotation angle, and rotation speed of a rolling icon.

(define R1 (make-roller 0 3 0 1))
(define R2 (make-roller 31.4 3.14 50 5))

#;
(define (fn-for-roller r)
  (... (roller-x r)
       (roller-dx r)
       (roller-rot r)))


(: main (Roller -> Roller))
;; Renders an icon rolling back and forth across the background.
;; Start with (main (make-roller L-EDGE SPEED 0 ROTATION)).

(define (main r)
  (big-bang r
    (on-tick advance-roller)
    (to-draw render)
    (on-mouse handle-mouse)))


(: advance-roller (Roller -> Roller))
;; Increment the roller's x and rot and flip dx and drot if at an edge.
;; NOTE: Does NOT proportionally shortchange rot at edge if can't move full dx.

(check-expect (advance-roller (make-roller 42 2 129 3)) (make-roller 44 2 132 3))
(check-expect (advance-roller (make-roller 42 -2 129 -3)) (make-roller 40 -2 126 -3))
(check-expect (advance-roller (make-roller (+ L-EDGE 1) -1 3 -2)) (make-roller L-EDGE 1 0 2))
(check-expect (advance-roller (make-roller (+ L-EDGE 1) -3 3 -3.01)) (make-roller L-EDGE 3 0 3.01))
(check-expect (advance-roller (make-roller (- R-EDGE 1) 1 360 2)) (make-roller R-EDGE -1 362 -2))
(check-expect (advance-roller (make-roller (- R-EDGE 1) 3 360 3)) (make-roller R-EDGE -3 363 -3))

(define (advance-roller r)
  (cond [(>= L-EDGE (+ (roller-x r) (roller-dx r)))
         (make-roller L-EDGE
                      (- (roller-dx r))
                      0
                      (- (roller-drot r)))]
        [(<= R-EDGE (+ (roller-x r) (roller-dx r)))
         (make-roller R-EDGE
                      (- (roller-dx r))
                      (+ (roller-rot r) (roller-drot r))
                      (- (roller-drot r)))]
        [else (make-roller (+ (roller-x r) (roller-dx r))
                           (roller-dx r)
                           (+ (roller-rot r) (roller-drot r))
                           (roller-drot r))]))


(: render (Roller -> Image))
;; Render the icon at the given location and rotation on the background.

(check-expect (render R1) (place-image (rotate (modulo (roller-rot R1) 360) LAMBDA)
                                       (roller-x R1)
                                       CENTER-Y
                                       MTS))

(define (render r)
  (place-image (rotate (modulo (roller-rot r) 360) LAMBDA)
               (roller-x r)
               CENTER-Y
               MTS))


(: handle-mouse (Roller Number Number MouseEvent -> Roller))
;; On button-down, reverse the icon's dx and drot.

(check-expect (handle-mouse R2 20 30 "button-down")
              (make-roller (roller-x R2) (- (roller-dx R2)) (roller-rot R2) (- (roller-drot R2))))
(check-expect (handle-mouse R2 20 30 "button-up") R2)

(define (handle-mouse r x y me)
  (if (mouse=? "button-down" me)
      (make-roller (roller-x r) (- (roller-dx r)) (roller-rot r) (- (roller-drot r)))
      r))


(main (make-roller L-EDGE SPEED 0 ROTATION))