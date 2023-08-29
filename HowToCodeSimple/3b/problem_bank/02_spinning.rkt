;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname 02_spinning) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; 
; PROBLEM
; 
; The world starts off with a small square at the center of the screen. As time 
; passes, the square stays fixed at the center, but increases in size and rotates 
; at a constant speed.Pressing the spacebar resets the world so that the square 
; is small and unrotated.
; 
; Starting display:
; .
; After a few seconds:
; .
; After a few more seconds:
; .
; Immediately after pressing the spacebar:
; .
; 
; The rotate function requires an angle in degrees as its first argument.
; By that it means Number[0, 360). As time goes by the box may end up 
; spinning more than once, for example, you may get to a point where it has spun 
; 362 degrees, which rotate won't accept. One solution to that is to use the 
; remainder function as follows:
; 
; (rotate (remainder ... 360) (text "hello" 30 "black"))
; 
; where ... can be an expression that produces any positive number of degrees 
; and remainder will produce a number in [0, 360).
; 


(require 2htdp/image)
(require 2htdp/universe)
(define Image (signature (predicate image?)))
(define KeyEvent (signature (predicate key-event?)))

(define INIT-SIZE 10)
(define BKGD-COLOR "black")
(define SQ-COLOR "red")
(define WIDTH 200)
(define HEIGHT WIDTH)
(define MTS (empty-scene WIDTH HEIGHT BKGD-COLOR))
(define CENTER-X (/ WIDTH 2))
(define CENTER-Y (/ HEIGHT 2))
(define GROW-RATE 1)
(define ROT-RATE 1)

;; (RotSquareOf (Natural Natural(0, 360)))
(define-struct rot-square (size angle))

(define RS1 (make-rot-square 15 4))
(define RS2 (make-rot-square 128 310))

#;
(define (fn-for-rot-square rs)
  (... (rot-square-size rs)
       (rot-square-angle rs)))


(: main (RotSquare -> RotSquare))
;; Render a rotating square on a background.
;; Start with (main (make-rot-square INIT-SIZE 0)).
(define (main rs)
  (big-bang rs
    (on-tick advance-rot-square)
    (to-draw render)
    (on-key handle-key)))


(: advance-rot-square (RotSquare -> RotSquare))
;; Produce the next incrementally grown and rotated square.

(check-expect (advance-rot-square (make-rot-square 24 16))
              (make-rot-square (+ GROW-RATE 24) (+ ROT-RATE 16)))
(check-expect (advance-rot-square (make-rot-square 24 360))
              (make-rot-square (+ GROW-RATE 24) ROT-RATE))

(define (advance-rot-square rs)
  (make-rot-square (+ GROW-RATE (rot-square-size rs))
                   (remainder (+ ROT-RATE (rot-square-angle rs)) 360)))


(: render (RotSquare -> Image))
;; Produce a rotated square on a background.

(check-expect (render (make-rot-square 12 15))
              (place-image (rotate 15 (square 12 "solid" SQ-COLOR))
                           CENTER-X
                           CENTER-Y
                           MTS))

(define (render rs)
  (place-image (rotate (rot-square-angle rs) (square (rot-square-size rs) "solid" SQ-COLOR))
               CENTER-X
               CENTER-Y
               MTS))


(: handle-key (RotSquare KeyEvent -> RotSquare))
;; Reset rotating square to initial size and rotation.

(check-expect (handle-key RS1 " ") (make-rot-square INIT-SIZE 0))
(check-expect (handle-key RS2 "a") RS2)

(define (handle-key rs ke)
  (cond [(key=? " " ke) (make-rot-square INIT-SIZE 0)]
        [else rs]))


#;
(main (make-rot-square INIT-SIZE 0))